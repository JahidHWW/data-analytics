-- =====================================================
-- Project: Retail Sales Performance Analysis
-- Analysis: Transaction Gap Detection
-- =====================================================

-- Business Question:
-- Are there extended periods without recorded sales
-- that could affect the reliability of revenue trends?

-- Method:
-- 1. Retrieve unique dates with recorded transactions.
-- 2. Use LAG() to identify the previous active sales date.
-- 3. Calculate the number of intervening calendar days.
-- 4. Exclude consecutive sales dates without gaps.
-- 5. Rank the largest transaction gaps.

-- SQL Techniques:
-- CTE, DISTINCT, LAG, OVER, DATE subtraction,
-- WHERE, ORDER BY, LIMIT.

-- Key Finding:
-- The five largest transaction gaps occur annually
-- between March and April from 2016 through 2020,
-- ranging from 35 to 37 days.

-- Limitation:
-- A date without recorded transactions does not
-- establish whether transactions are missing or
-- whether the business was inactive.
WITH sales_dates AS (
SELECT DISTINCT order_date
FROM sales
),
date_comparison AS (
SELECT
	order_date,
	LAG(order_date) OVER (
		ORDER BY order_date
	) AS previous_order_date
FROM sales_dates
)
SELECT
	previous_order_date,
	order_date,
	order_date - previous_order_date - 1 AS days_without_sales
FROM date_comparison
WHERE order_date - previous_order_date - 1 > 0
ORDER BY days_without_sales DESC
LIMIT 10;