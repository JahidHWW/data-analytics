# Business Findings Report

**Project:** Global Electronics Retailer — Sales Performance Analysis  
**Reporting window:** January 2016 – December 2020  
**Tools:** PostgreSQL, SQL, Tableau Public

## Executive summary

Using transaction-level data from a fictitious global electronics retailer, this analysis estimated **$54.72 million in sales value** across **25,828 distinct orders**, for an **average order value of $2,118.48** in 2016–2020. Computers was the leading category. Revenue varied considerably over time, with sharp recorded declines in March and April; however, recurring 35–37-day gaps without recorded transactions mean that these declines cannot be confidently attributed to normal seasonality.

## Key findings

### 1. Computers generated the most estimated sales value

- **Computers:** $18,855,849.81; **43,169 units** (2016–2020).
- **Home Appliances:** $10,718,396.53; **18,245 units**.
- **Cameras and camcorders:** $6,390,971.03; **17,299 units**.
- **Cell phones:** $6,024,337.18; **30,739 units**.

**Interpretation:** Computers leads on estimated sales value. Differences between revenue ranking and units sold indicate that product pricing/mix matters in addition to volume. Profitability and inventory data would be needed before recommending category expansion.

### 2. Lower recorded order counts largely explain the February–April 2019 decline

| Metric | Feb 2019 | Mar 2019 | Apr 2019 |
| --- | ---: | ---: | ---: |
| Distinct orders | 967 | 386 | 75 |
| Estimated sales value | $2,102,862.57 | $845,925.09 | $149,892.71 |
| Average order value | $2,174.63 | $2,191.52 | $1,998.57 |

Recorded orders declined much more sharply than average order value. This accounts for much of the reported decline **arithmetically**, but does not establish why fewer orders appear in the dataset.

### 3. Annual transaction-record gaps limit seasonal conclusions

The longest gaps between consecutive recorded sales dates occurred in March–April every year from 2016 through 2020:

| Year | Last recorded March sale | First recorded April sale | Days with no recorded sales in between |
| --- | --- | --- | ---: |
| 2016 | 2016-03-17 | 2016-04-23 | 36 |
| 2017 | 2017-03-18 | 2017-04-25 | 37 |
| 2018 | 2018-03-17 | 2018-04-24 | 37 |
| 2019 | 2019-03-19 | 2019-04-24 | 35 |
| 2020 | 2020-03-18 | 2020-04-23 | 35 |

**Interpretation:** These are verified periods **without recorded orders** in the source, not verified data losses. Potential explanations include source omissions, a recurring operating schedule, or periods of genuinely zero sales. Do not claim established seasonality until the data owner clarifies the cause.

### 4. Key-reference consistency was verified

Checks using `LEFT JOIN` and `IS NULL` returned **zero unmatched sales references** for products, customers, and stores. This reduces the risk of excluding sales rows through the corresponding `INNER JOIN` calculations. Further quality checks remain possible, including null quantities and pricing consistency.

## Recommendations

1. **Investigate the annual reporting gap first.** Ask the data owner whether the March–April dates reflect closure, zero-activity periods, or omitted transaction exports.
2. **Review product economics before expansion.** Compare product/category profitability, stock availability, and demand trends rather than inferring margins from revenue alone.
3. **Examine order-volume drivers.** Where records are reliable, separate purchasing frequency, unique-customer counts, online versus physical stores, and product mix.
4. **Standardize KPI definitions.** Label `quantity × USD product list price` as **estimated sales value** until transaction-level realized sales amounts are available.

## Methodology and caveats

- PostgreSQL joins sales lines to product USD prices on `product_key`.
- Monthly grouping uses `order_date`, not delivery date.
- Distinct order counts use `COUNT(DISTINCT order_number)`.
- MoM comparisons use a `LAG` window ordered by month; require checking for absent calendar months.
- Reporting window is **2016–2020**, leaving partial 2021 outside KPI comparison.
- Data are from a **fictitious** retailer; public portfolio exercise, not a real company consulting engagement.

**Data credit:** Global Electronics Retailer, Maven Analytics Data Playground (original source: Microsoft; Public Domain). https://mavenanalytics.io/data-playground/global-electronics-retailer
