-- =====================================================
-- Project: Retail Sales Performance Analysis
-- Analysis: Monthly Revenue Trends
-- =====================================================

-- Business Question:
-- How does sales revenue change over time, and
-- which months generate the highest and lowest revenue?

-- Method:
-- 1. Clean product prices and convert them to numeric values.
-- 2. Join Sales with Products using product_key.
-- 3. Group transactions by month and year.
-- 4. Calculate total monthly units sold.
-- 5. Calculate estimated monthly revenue.
-- 6. Sort results chronologically.

-- SQL Techniques:
-- CTE, CAST, REPLACE, INNER JOIN, DATE_TRUNC,
-- SUM, GROUP BY, ORDER BY.

-- Analytical Consideration:
-- Monthly comparisons should account for incomplete
-- periods and gaps in recorded transactions.
WITH cleaned_products AS (
	SELECT product_key, product_name,
	CAST(
	REPLACE(REPLACE(unit_price_usd, '$', ''), ',','')
	AS NUMERIC (12,2)
	) AS clean_price
	FROM products
)
SELECT
	DATE_TRUNC('month', order_date) AS sales_month,
	SUM(s.quantity) AS total_units_sold,
	SUM(s.quantity * cp.clean_price) AS total_revenue
FROM sales AS s
INNER JOIN cleaned_products AS cp
ON s.product_key = cp.product_key
GROUP BY sales_month
ORDER BY sales_month ASC;