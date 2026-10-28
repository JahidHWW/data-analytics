-- =====================================================
-- Project: Retail Sales Performance Analysis
-- Analysis: Data Validation and Referential Integrity
-- =====================================================

-- Business Question:
-- Do all sales records reference valid products
-- and customers?

-- Method:
-- 1. Use LEFT JOIN to preserve sales records.
-- 2. Identify unmatched foreign key references.
-- 3. Count records without corresponding matches.

-- SQL Techniques:
-- LEFT JOIN, COUNT, IS NULL.

-- Finding:
-- All 62,884 sales records have matching products.
SELECT COUNT(*) AS unmatched_product_sales
FROM sales AS s
LEFT JOIN products AS p
ON s.product_key = p.product_key
WHERE p.product_key IS NULL;
-- Validation: Sales to Customers
-- Checks whether any sales reference customers
-- that do not exist in the Customers table.
--
-- Result: 0 unmatched sales records.
SELECT COUNT(*) AS unmatched_customer_sales
FROM sales AS s
LEFT JOIN customers AS c
ON s.customer_key = c.customer_key
WHERE c.customer_key IS NULL;
-- Validation: Sales to Stores
-- Checks for sales referencing nonexistent stores.
-- Result: 0 unmatched records.
SELECT COUNT(*) AS unmatched_store_sales   
FROM sales AS s
LEFT JOIN stores AS st
    ON s.store_key = st.store_key
WHERE st.store_key IS NULL;
-- Validation: Duplicate Exchange Rates
-- Identifies duplicate date/currency combinations.
SELECT
	rate_date,
	currency,
	COUNT(*) AS duplicate_exchange_rates
FROM exchange_rates
GROUP BY rate_date, currency
HAVING COUNT (*) > 1;
-- Validation: Duplicate Exchange Rate Summary
-- Counts the total number of duplicate date/currency groups.
-- Result: 0 indicates no duplicates found.
SELECT COUNT(*) AS total_duplicate_groups
FROM (
    SELECT rate_date, currency
    FROM exchange_rates
    GROUP BY rate_date, currency
    HAVING COUNT(*) > 1
) AS duplicates;