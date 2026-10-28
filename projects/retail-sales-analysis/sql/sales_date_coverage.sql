-- Project: Retail Sales Performance Analysis
-- Analysis: Monthly Sales Date Coverage
--
-- Business Question:
-- How consistently are transactions recorded
-- throughout each month?
--
-- Method:
-- Count unique orders and active sales days,
-- and identify the first and last transaction
-- dates for each month.
SELECT 
	DATE_TRUNC('month',order_date) AS sales_month,
	COUNT(DISTINCT order_number) AS total_orders,
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	COUNT(DISTINCT order_date) AS active_sales_days
FROM sales
GROUP BY sales_month
ORDER BY sales_month;