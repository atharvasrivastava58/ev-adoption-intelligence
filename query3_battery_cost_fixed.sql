-- Did falling battery prices directly drive EV adoption — and is there a price threshold where adoption accelerated?

WITH battery_yoy AS (

SELECT
    Year                                                  AS year,
    ROUND(`Price of lithium-ion battery cells`, 0)        AS battery_price_usd,
    ROUND(
      `Price of lithium-ion battery cells` -
      LAG(`Price of lithium-ion battery cells`)
        OVER (ORDER BY Year)
    , 0)                                                  AS battery_price_drop_usd,
    ROUND(
      SAFE_DIVIDE(
        `Price of lithium-ion battery cells` -
        LAG(`Price of lithium-ion battery cells`)
          OVER (ORDER BY Year),
        LAG(`Price of lithium-ion battery cells`)
          OVER (ORDER BY Year)
      ) * 100
    , 1)                                                  AS battery_price_drop_pct

FROM `ev-market-analysis-01.ev_adoption.battery_cost`
),

country_adoption AS (

  SELECT
    s.Entity                                              AS country,
    s.Year                                                AS year,
    s.`Electric cars sold`                                AS ev_sales,
    sh.`Share of new cars that are electric`              AS market_share_pct,

    LAG(s.`Electric cars sold`)
      OVER (PARTITION BY s.Entity ORDER BY s.Year)        AS prev_year_sales,

    LAG(sh.`Share of new cars that are electric`)
      OVER (PARTITION BY s.Entity ORDER BY s.Year)        AS prev_year_share

  FROM `ev-market-analysis-01.ev_adoption.ev_sales` AS s
  JOIN `ev-market-analysis-01.ev_adoption.ev_sales_share` AS sh
    ON s.Entity = sh.Entity
   AND s.Year   = sh.Year

  WHERE s.Entity IN (
    'China', 'United States', 'Norway', 'Germany',
    'United Kingdom', 'France', 'Netherlands',
    'South Korea', 'Japan', 'Canada'
  )
  AND s.Year BETWEEN 2015 AND 2024
),

combined AS (

SELECT
    ca.country,
    ca.year,
    b.battery_price_usd,
    b.battery_price_drop_usd,
    b.battery_price_drop_pct,
    ca.ev_sales,
    ca.market_share_pct,
    ROUND(
      SAFE_DIVIDE(ca.ev_sales - ca.prev_year_sales, ca.prev_year_sales) * 100
    , 1)                                                  AS ev_sales_growth_pct,
    ROUND(ca.market_share_pct - ca.prev_year_share, 2)    AS share_growth_pp,
    CASE
      WHEN b.battery_price_usd > 500  THEN 'Early Stage'
      WHEN b.battery_price_usd > 200  THEN 'Growth Stage'
      WHEN b.battery_price_usd > 100  THEN 'Acceleration Stage'
      ELSE                                 'Mass Market Stage'
    END                                                   AS battery_era,
    RANK() OVER (
      PARTITION BY ca.country
      ORDER BY
        SAFE_DIVIDE(ca.ev_sales - ca.prev_year_sales, ca.prev_year_sales) DESC
    )                                                     AS growth_rank

FROM country_adoption ca
JOIN battery_yoy b
  ON ca.year = b.year
WHERE ca.prev_year_sales IS NOT NULL
)

SELECT
  year,
  country,
  battery_price_usd,
  battery_price_drop_usd,
  battery_price_drop_pct,
  battery_era,
  ev_sales,
  ev_sales_growth_pct,
  market_share_pct,
  share_growth_pp,
  growth_rank

FROM combined
ORDER BY country, year;
