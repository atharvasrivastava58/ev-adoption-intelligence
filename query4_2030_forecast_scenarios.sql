-- Based on historical growth trends, which countries are on track to achieve full EV dominance by 2030, and what will global EV market share look like?

WITH historical_growth AS (

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
  AND s.Year BETWEEN 2019 AND 2024
),

growth_rates AS (

SELECT
    country,
    year,
    ev_sales,
    market_share_pct,
    ROUND(
      SAFE_DIVIDE(ev_sales - prev_year_sales, prev_year_sales) * 100
    , 1)                                                  AS yoy_growth_pct,
    ROUND(market_share_pct - prev_year_share, 2)          AS yoy_share_change_pp

FROM historical_growth
WHERE prev_year_sales IS NOT NULL
),

avg_growth AS (

SELECT
    country,
    LEAST(ROUND(AVG(yoy_growth_pct), 1), 40.0)           AS expected_growth_rate,
    ROUND(AVG(yoy_share_change_pp), 2)                    AS avg_share_gain_pp,
    MAX(CASE WHEN year = 2024 THEN ev_sales END)          AS ev_sales_2024,
    MAX(CASE WHEN year = 2024 THEN market_share_pct END)  AS market_share_2024

FROM growth_rates
GROUP BY country
),

forecast AS (

  SELECT
    country,
    ev_sales_2024,
    market_share_2024,
    expected_growth_rate,
    avg_share_gain_pp,
    ROUND(
      LEAST(market_share_2024 + (avg_share_gain_pp * 0.6 * 6), 100)
    , 1)                                                  AS share_2030_conservative,
    ROUND(
      ev_sales_2024 * POWER(1 + 15.0 / 100, 6)
    , 0)                                                  AS sales_2030_conservative,
    ROUND(
      LEAST(market_share_2024 + (avg_share_gain_pp * 6), 100)
    , 1)                                                  AS share_2030_expected,
    ROUND(
      ev_sales_2024 * POWER(1 + expected_growth_rate / 100, 6)
    , 0)                                                  AS sales_2030_expected,
    ROUND(
      LEAST(market_share_2024 + (avg_share_gain_pp * 1.4 * 6), 100)
    , 1)                                                  AS share_2030_aggressive,
    ROUND(
      ev_sales_2024 * POWER(1 + LEAST(expected_growth_rate + 10, 50) / 100, 6)
    , 0)                                                  AS sales_2030_aggressive,
    CASE
      WHEN LEAST(market_share_2024 + (avg_share_gain_pp * 6), 100) >= 90
        THEN 'Full EV Dominance'
      WHEN LEAST(market_share_2024 + (avg_share_gain_pp * 6), 100) >= 60
        THEN 'EV Majority'
      WHEN LEAST(market_share_2024 + (avg_share_gain_pp * 6), 100) >= 30
        THEN 'Strong Transition'
      WHEN LEAST(market_share_2024 + (avg_share_gain_pp * 6), 100) >= 15
        THEN 'Active Transition'
      ELSE
        'Early Transition'
    END                                                   AS forecast_category,
    CASE
      WHEN expected_growth_rate < 0  THEN 'Declining'
      WHEN expected_growth_rate < 15 THEN 'Slowing'
      WHEN expected_growth_rate < 35 THEN 'Steady'
      ELSE                                'Accelerating'
    END                                                   AS growth_trajectory

FROM avg_growth
)

SELECT
  country,
  ev_sales_2024,
  market_share_2024,
  expected_growth_rate,
  share_2030_conservative,
  share_2030_expected,
  share_2030_aggressive,
  sales_2030_conservative,
  sales_2030_expected,
  sales_2030_aggressive,
  forecast_category,
  growth_trajectory

FROM forecast
ORDER BY share_2030_expected DESC;
