-- Do countries with more charging infrastructure have higher EV adoption rates — and which came first, the chargers or the cars?

WITH infrastructure_adoption AS (
  SELECT
    c.country                                               AS country,
    c.year                                                  AS year,
    c.total_public_chargers                                 AS total_chargers,
    c.public_fast_chargers                                  AS fast_chargers,
    c.public_slow_chargers                                  AS slow_chargers,
    sh.`Share of new cars that are electric`                AS market_share_pct,
    s.`Electric cars sold`                                  AS ev_sales,
    ROUND(
      SAFE_DIVIDE(c.total_public_chargers, s.`Electric cars sold`) * 1000
    , 1)                                                    AS chargers_per_1000_evs,
    LAG(c.total_public_chargers)
      OVER (PARTITION BY c.country ORDER BY c.year)         AS prev_year_chargers,
    LAG(sh.`Share of new cars that are electric`)
      OVER (PARTITION BY c.country ORDER BY c.year)         AS prev_year_share
  FROM `ev-market-analysis-01.ev_adoption.ev_charging` AS c
  JOIN `ev-market-analysis-01.ev_adoption.ev_sales_share` AS sh
    ON c.country = sh.Entity
   AND c.year    = sh.Year
  JOIN `ev-market-analysis-01.ev_adoption.ev_sales` AS s
    ON c.country = s.Entity
   AND c.year    = s.Year
  WHERE c.country IN (
    'China', 'United States', 'Norway', 'Germany',
    'United Kingdom', 'France', 'Netherlands',
    'South Korea', 'Japan', 'Canada'
  )
  AND c.year BETWEEN 2015 AND 2024
),

growth_comparison AS (
  SELECT
    country,
    year,
    total_chargers,
    fast_chargers,
    slow_chargers,
    market_share_pct,
    ev_sales,
    chargers_per_1000_evs,
    ROUND(
      SAFE_DIVIDE(total_chargers - prev_year_chargers, prev_year_chargers) * 100
    , 1)                                                    AS charger_growth_pct,
    ROUND(market_share_pct - prev_year_share, 2)            AS share_growth_pp,
    RANK() OVER (
      PARTITION BY year
      ORDER BY SAFE_DIVIDE(total_chargers, ev_sales) DESC
    )                                                       AS infra_rank,
    RANK() OVER (
      PARTITION BY year
      ORDER BY market_share_pct DESC
    )                                                       AS adoption_rank
  FROM infrastructure_adoption
  WHERE prev_year_chargers IS NOT NULL
)

SELECT
  country,
  year,
  total_chargers,
  fast_chargers,
  market_share_pct,
  ev_sales,
  chargers_per_1000_evs,
  charger_growth_pct,
  share_growth_pp,
  infra_rank,
  adoption_rank
FROM growth_comparison
ORDER BY country, year;
