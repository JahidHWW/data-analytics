-- =====================================================
-- Project: Retail Sales Performance Analysis
-- Analysis: Top 10 Products by Revenue
-- =====================================================

-- Business Question:
-- Which individual products generate the highest
-- sales revenue, and how many units are sold?

-- Method:
-- 1. Clean product prices by removing currency symbols
--    and converting text values to numeric values.
-- 2. Join the Sales and Products tables using product_key.
-- 3. Calculate total units sold for each product.
-- 4. Calculate estimated revenue as quantity * unit price.
-- 5. Rank products by total revenue in descending order.
-- 6. Return the top 10 products.

-- SQL Techniques:
-- CTE, CAST, REPLACE, INNER JOIN, SUM,
-- GROUP BY, ORDER BY, LIMIT.
WITH cleaned_products AS(
	SELECT product_key, product_name,
	CAST(REPLACE(REPLACE(unit_price_usd, '$', ''), ',', '') 
	AS NUMERIC(12,2)
	) AS clean_price
	FROM products
	) 

SELECT cp.product_name,
	   SUM(s.quantity) AS total_units_sold,
	   SUM(s.quantity * cp.clean_price) AS total_revenue
FROM sales AS s
INNER JOIN cleaned_products AS cp
ON s.product_key = cp.product_key
WHERE s.order_date >= '2016-01-01'
AND s.order_date < '2021-01-01'
GROUP BY cp.product_key, cp.product_name
ORDER BY total_revenue DESC
LIMIT 10;