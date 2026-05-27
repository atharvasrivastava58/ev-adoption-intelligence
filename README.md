🚗⚡ Global EV Adoption Intelligence
What Actually Drives Electric Vehicle Growth? A Data Analysis of Infrastructure, Affordability & Market Leadership (2015–2024)

🚀Project At a Glance

| | |
|---|---|
| Objective | Identify the key drivers of EV adoption globally |
| Countries Analysed | China, USA, Norway, Germany, UK, France, Netherlands, South Korea, Japan, Canada |
| Time Period | 2015–2024 |
| Tools Used | SQL (BigQuery), Python, Power BI |
| Key Outcome | Policy incentives appear to influence EV adoption more strongly than charging infrastructure alone |

📌Project Overview

This project investigates the key drivers behind global electric vehicle adoption across 10 major markets from 2015 to 2024. Rather than simply visualising EV sales trends, this analysis attempts to answer a genuine business question:

> Why do some countries adopt EVs rapidly while others stall — and what will the global EV landscape look like by 2030?

This is the third project in my data analytics portfolio, building on previous work in automotive sales analysis and F1 motorsport analytics. Combining an Automotive & Motorsport Engineering background with growing expertise in Data Analytics gives me domain context that shapes the analytical decisions throughout this project.


🛠️Tools & Technologies

| Tool | Purpose |
|---|---|
| SQL (BigQuery) | Data querying, transformation, window functions, YoY growth analysis |
| Python | Correlation analysis, regression modelling, visualisation |
| Power BI | Interactive dashboard, KPI reporting, scenario forecasting |

Python libraries used: pandas, matplotlib, numpy, scipy


📂Dataset Sources

| Dataset | Source | Description |
|---|---|---|
| EV Sales Volume | Our World in Data / IEA Global EV Outlook | Annual EV sales by country (2010–2025) |
| EV Market Share | Our World in Data / IEA Global EV Outlook | % of new cars sold that are electric, by country |
| Battery Cost | Our World in Data / IEA | Lithium-ion battery price per kWh (1991–2024) |
| Charging Infrastructure | Compiled from IEA Global EV Outlook reports | Public charger counts by country and year (2015–2024) |
| Manufacturer Market Share | Compiled from IEA & EV-Volumes research | Global EV sales by brand (BYD, Tesla, VW Group etc.) |

> Data note: EV adoption and battery pricing data were sourced directly from Our World in Data using IEA figures, a widely recognised source for EV market analysis. Data was sourced and transformed to enable cross-country comparative analysis. Business analysis, forecasting logic, and dashboard design were independently developed as part of this project.


🔍Project Structure & Business Questions

Section 1 — Adoption Growth
Question: Which countries grew EV adoption the fastest between 2015 and 2024, and when did each hit its inflection point?

Section 2 — Charging Infrastructure
Question: Do countries with more charging infrastructure have higher EV adoption rates — and which came first, the chargers or the cars?

Section 3 — Battery Cost Impact
Question: Did falling battery prices directly drive EV adoption, and is there a price threshold where adoption accelerated?

Section 4 — 2030 Forecast
Question: Based on historical growth trends, which countries are on track to achieve full EV dominance by 2030?


📊SQL Analysis

All queries were written in BigQuery using:
- Common Table Expressions (CTEs) for multi-step logic
- Window functions (`LAG`, `RANK`, `PARTITION BY`) for YoY growth and country ranking
- Multi-table JOINs across 3–4 datasets
- `SAFE_DIVIDE` for division safety and `CASE` statements for era classification
- Scenario-based forecasting using compound growth with capped assumptions

Queries written:
1. `query1_adoption_growth` — YoY growth rates and inflection point identification
2. `query2_infrastructure_adoption` — Charger density vs adoption correlation
3. `query3_battery_cost_fixed` — Battery price era classification and adoption correlation
4. `query4_2030_forecast_scenarios` — Conservative, expected, and aggressive 2030 projections


🐍Python Analysis

Three analyses were conducted in Python:

Chart 1 — Charging Infrastructure vs EV Adoption
Scatter plot with linear regression line and R² value across 10 countries (2015–2024). Result: R² = 0.040, r = -0.199, indicating a weak negative correlation — infrastructure density does not reliably predict adoption rates.

Chart 2 — Battery Cost vs Global EV Sales
Dual-axis line chart showing battery price decline alongside global EV sales growth. Includes a 2020 marker highlighting the COVID policy surge inflection point.

Chart 3 — 2030 Scenario Forecast
Horizontal bar chart showing conservative, expected, and aggressive market share projections for all 10 countries, with 2024 actuals as reference points.

📈Key Findings

1. Policy appears to drive adoption more than infrastructure
Correlation analysis (R² = 0.040) shows charging infrastructure density explains only 4% of variation in EV adoption rates. Norway achieved 92% market share despite relatively lower charger density, suggesting policy incentives may have played a stronger role than infrastructure alone. South Korea built the densest charging network yet saw stalling adoption at 7.4%.

2. The $200/kWh battery threshold appears to be a global turning point
Every country's strongest growth period began after battery prices crossed below $200/kWh in 2017. However, Japan's declining adoption despite identical battery price drops suggests that cost reduction enables adoption but does not guarantee it.

3. Germany's subsidy removal is a cautionary case
Germany's EV sales peaked in 2022 at 830,000 units following subsidy-driven growth, then fell -15.7% in 2023 and -18.6% in 2024 after incentives were removed. This indicates adoption driven primarily by subsidies may be structurally fragile without complementary demand-side measures.

4. 2022 supply chain disruption is visible in the data
Battery prices briefly rose from $119 to $132/kWh in 2022 due to lithium supply chain pressures following post-COVID demand surges — a short-term reversal in an otherwise consistent long-term decline.

5. Japan is a notable strategic underperformer
Despite being home to Toyota, Honda, and Nissan, Japan's EV market share was only 2.8% in 2024 and is projected to reach just 5.1% by 2030 under expected conditions. Japan's slower EV adoption may partly reflect a long-term strategic focus on hybrid and hydrogen technologies rather than battery EVs.

6. BYD has overtaken Tesla as the global volume leader
BYD sold 4.27M EVs in 2024 vs Tesla's 1.79M, commanding 24.4% global market share. This shift from a US-led to a China-led EV market represents one of the most significant structural changes in the dataset.


Business Recommendations

For governments:
Financial incentives appear more effective than infrastructure investment alone in driving early adoption. However, incentive dependency creates fragility — Germany's reversal demonstrates the risk of abrupt policy removal. Gradual phase-outs with clear timelines may sustain adoption better.

For automotive manufacturers:
Affordable mass-market EV models appear to drive adoption more effectively than premium innovation. BYD's dominance in China and growing export presence suggests that price-competitive BEVs targeting mainstream segments outperform luxury-first strategies in volume markets.

For infrastructure investors:
Charging infrastructure appears necessary for long-term market sustainability but insufficient as a standalone adoption driver. Investment timing matters — building ahead of demand (South Korea model) does not guarantee uptake, while demand-led expansion (Norway model) may be more capital-efficient.


2030 Forecast Summary

| Country | 2024 Share | Conservative | Expected | Aggressive |
|---|---|---|---|---|
| Norway | 92% | 100% | 100% | 100% |
| China | 48% | 79% | 99.6% | 100% |
| Netherlands | 48% | 71.8% | 87.6% | 100% |
| United Kingdom | 27% | 44.1% | 55.6% | 67% |
| France | 24% | 39.3% | 49.6% | 59.8% |
| Germany | 20% | 32.2% | 40.4% | 48.6% |
| United States | 10% | 15.7% | 19.5% | 23.3% |
| Japan | 2.8% | 4.2% | 5.1% | 6.0% |

> Forecasts are scenario-based and assume continuation of recent adoption trends. Mature markets may experience slower growth as adoption saturates. Germany's expected scenario may overstate growth given recent policy reversals.


📁Repository Structure
├── query1_adoption_growth.sql
├── query2_infrastructure_adoption.sql
├── query3_battery_cost_fixed.sql
├── query4_2030_forecast_scenarios.sql
├── ev_analysis.ipynb
├── chart1_charger_vs_adoption.png
├── chart2_battery_vs_sales.png
├── chart3_2030_forecast.png
├── Ev analysis Dashboard.pbix
├── electric-car-sales.csv
├── electric-car-sales-share.csv
├── ev_charging_infrastructure.csv
├── ev_manufacturer_market_share.csv
├── price-of-lithium-ion-battery-cells.csv
└── README.md

Dashboard Preview

Page 1 — Global EV Market Overview
KPI cards (Global Sales, Market Share, Battery Cost) + EV sales growth line chart + market share bar chart + interactive slicers

Page 2 — What Drives EV Adoption?
Charging infrastructure correlation + battery cost trend + manufacturer market share + 2030 scenario forecast + key findings

About

Atharva Srivastava
Combining an Automotive & Motorsport Engineering background with growing expertise in Data Analytics.

Portfolio projects:
- Project 1: Automotive Sales Analysis (SQL + BigQuery)
- Project 2: F1 Motorsport Performance Analytics (SQL + BigQuery + Python + Power BI)
- Project 3: Global EV Adoption Intelligence (this project)

[LinkedIn](https://www.linkedin.com/in/atharva-srivastava-automotive/) | [GitHub](https://github.com/atharvasrivastava58)
