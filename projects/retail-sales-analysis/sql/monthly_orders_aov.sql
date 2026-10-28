-- =====================================================
-- Project: Retail Sales Performance Analysis
-- Analysis: Monthly Orders and Average Order Value
-- =====================================================

-- Business Question:
-- Are changes in monthly revenue driven by changes
-- in order volume, average spending per order, or both?

-- Method:
-- 1. Clean product prices and convert them to numeric values.
-- 2. Join the Sales and Products tables.
-- 3. Group transactions by month and year.
-- 4. Count unique orders using COUNT(DISTINCT).
-- 5. Calculate estimated total monthly revenue.
-- 6. Calculate Average Order Value (AOV).
-- 7. Sort results chronologically.

-- Formula:
-- Average Order Value = Total Revenue / Total Orders

-- SQL Techniques:
-- CTE, CAST, REPLACE, INNER JOIN, DATE_TRUNC,
-- COUNT(DISTINCT), SUM, GROUP BY, NULLIF, ROUND.

-- Analytical Consideration:
-- Order numbers may appear in multiple transaction lines.
-- DISTINCT prevents counting these lines as separate orders.
WITH cleaned_products AS (
    SELECT
        product_key,
        product_name,
        CAST(
            REPLACE(REPLACE(unit_price_usd, '$', ''), ',', '')
            AS NUMERIC(12,2)
        ) AS clean_price
    FROM products
),
monthly_sales AS (
    SELECT
        DATE_TRUNC('month', s.order_date)::date AS sales_month,
        SUM(s.quantity) AS total_units_sold,
        SUM(s.quantity * cp.clean_price) AS total_revenue,
        COUNT(DISTINCT s.order_number) AS total_orders
    FROM sales AS s
    INNER JOIN cleaned_products AS cp
        ON s.product_key = cp.product_key
    GROUP BY DATE_TRUNC('month', s.order_date)
)
SELECT
    sales_month,
    total_orders,
    total_revenue,
    ROUND(
        total_revenue / NULLIF(total_orders, 0),
        2
    ) AS average_order_value
FROM monthly_sales
ORDER BY sales_month;