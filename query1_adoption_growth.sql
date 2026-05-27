-- Which 10 countries grew EV adoption the fastest between 2015 and 2024, and when did each country hit its inflection point?
WITH country_growth AS (
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

growth_calc AS (
  SELECT
    country,
    year,
    ev_sales,
    ROUND(market_share_pct, 2)                            AS market_share_pct,
    ROUND(
      SAFE_DIVIDE(ev_sales - prev_year_sales, prev_year_sales) * 100
    , 1)                                                  AS yoy_sales_growth_pct,
    ROUND(market_share_pct - prev_year_share, 2)          AS yoy_share_change_pp,
    RANK() OVER (
      PARTITION BY country
      ORDER BY
        SAFE_DIVIDE(ev_sales - prev_year_sales, prev_year_sales) DESC
    )                                                     AS growth_rank
  FROM country_growth
  WHERE prev_year_sales IS NOT NULL
)

SELECT
  country,
  year,
  ev_sales,
  market_share_pct,
  yoy_sales_growth_pct,
  yoy_share_change_pp,
  growth_rank
FROM growth_calc
ORDER BY country, year;
