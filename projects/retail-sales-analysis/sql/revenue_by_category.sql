-- =====================================================
-- Project: Retail Sales Performance Analysis
-- Analysis: Revenue by Product Category
-- =====================================================

-- Business Question:
-- Which product categories contribute the most
-- revenue, and which categories sell the most units?

-- Method:
-- 1. Clean and convert product prices into numeric values.
-- 2. Join the Sales and Products tables.
-- 3. Group transactions by product category.
-- 4. Calculate total units sold for each category.
-- 5. Calculate estimated revenue for each category.
-- 6. Sort categories by revenue in descending order.

-- SQL Techniques:
-- CTE, CAST, REPLACE, INNER JOIN, SUM,
-- GROUP BY, ORDER BY.
WITH cleaned_products AS (
	SELECT product_key, category_key, category,
	CAST(REPLACE(
	REPLACE(unit_price_usd,'$',''),',','')
	AS NUMERIC(12,2)
	) AS clean_price
	FROM products
)
SELECT cp.category,
       SUM(s.quantity) AS total_units_sold,
	   SUM(s.quantity * cp.clean_price) AS total_revenue
FROM sales AS s
INNER JOIN cleaned_products AS cp
ON s.product_key = cp.product_key
WHERE s.order_date >= '2016-01-01'
AND s.order_date < '2021-01-01'
GROUP BY cp.category, cp.category_key
ORDER BY total_revenue DESC;