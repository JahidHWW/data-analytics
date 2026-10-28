-- =====================================================
-- Project: Retail Sales Performance Analysis
-- Analysis: Month-over-Month Revenue Growth
-- =====================================================

-- Business Question:
-- How much does revenue increase or decrease
-- compared with the previous month?

-- Method:
-- 1. Clean product prices and calculate monthly revenue.
-- 2. Use LAG() to retrieve the previous month's revenue.
-- 3. Calculate the percentage change in revenue.
-- 4. Use NULLIF() to prevent division-by-zero errors.
-- 5. Round growth percentages to two decimal places.
-- 6. Sort results chronologically.

-- Formula:
-- MoM Growth (%) =
-- ((Current Revenue - Previous Revenue)
--  / Previous Revenue) * 100

-- SQL Techniques:
-- Multiple CTEs, INNER JOIN, DATE_TRUNC, SUM,
-- GROUP BY, LAG, OVER, ORDER BY, NULLIF, ROUND.

-- Analytical Consideration:
-- LAG() compares the previous available row.
-- Consecutive calendar months should be verified.
WITH cleaned_products AS (
	SELECT product_key, product_name,
	CAST(
	REPLACE(REPLACE(unit_price_usd, '$', ''), ',','')
	AS NUMERIC (12,2)
	) AS clean_price
	FROM products
)
,
monthly_sales AS (
SELECT
	DATE_TRUNC('month', order_date) AS sales_month,
	SUM(s.quantity) AS total_units_sold,
	SUM(s.quantity * cp.clean_price) AS total_revenue
FROM sales AS s
INNER JOIN cleaned_products AS cp
ON s.product_key = cp.product_key
GROUP BY sales_month
),
revenue_comparison AS (
	SELECT sales_month, total_revenue, 
		LAG(total_revenue) OVER (
			ORDER BY sales_month
		) AS previous_month_revenue
FROM monthly_sales
)
SELECT sales_month,
	   total_revenue,
	   previous_month_revenue,
	   ROUND((total_revenue - previous_month_revenue)
			/ NULLIF(previous_month_revenue, 0) * 100, 2)
		AS mom_growth_percentage
FROM revenue_comparison
ORDER BY sales_month;