-- ============================================
-- OmniRetail 360
-- Order Items Profiling - WORK IN PROGRESS
-- File: 18_wip_profile_order_items.sql
-- ============================================

-- Create raw OrderItems table
CREATE TABLE raw.OrderItems(
    order_item_id VARCHAR(100),
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity VARCHAR(50),
    unit_price VARCHAR(50),
    discount_pct VARCHAR(50),
    gift_flag VARCHAR(50)
);


-- Check total row count
SELECT COUNT(*) AS order_item_count
FROM raw.OrderItems;


-- Check order_item_id uniqueness
SELECT COUNT(DISTINCT order_item_id) AS unique_order_item_ids
FROM raw.OrderItems;


-- Check repeated product IDs
SELECT 
    product_id,
    COUNT(*) AS product_count
FROM raw.OrderItems
GROUP BY product_id
HAVING COUNT(*) > 1;


-- Check blank or NULL product IDs
SELECT product_id
FROM raw.OrderItems
WHERE product_id IS NULL
   OR TRIM(product_id) = '';


-- Quantity profiling
SELECT quantity
FROM raw.OrderItems
WHERE quantity IS NULL
   OR TRIM(quantity) = '';


-- Known issue:
-- quantity contains 0 and -1 values that still need investigation
SELECT DISTINCT quantity
FROM raw.OrderItems;


-- Unit price profiling
-- Known issues: blank values and N/A
SELECT unit_price
FROM raw.OrderItems
WHERE TRIM(unit_price) <> ''
  AND TRY_CONVERT(DECIMAL(10,2), unit_price) IS NULL;


-- Check valid numeric unit prices
SELECT
    MIN(TRY_CONVERT(DECIMAL(10,2), unit_price)) AS minimum_unit_price,
    MAX(TRY_CONVERT(DECIMAL(10,2), unit_price)) AS maximum_unit_price
FROM raw.OrderItems
WHERE TRY_CONVERT(DECIMAL(10,2), unit_price) IS NOT NULL;


-- Discount profiling
-- Known issue: mixed formats such as 30% and 30
SELECT DISTINCT discount_pct
FROM raw.OrderItems;


-- Check blank discount values
SELECT discount_pct
FROM raw.OrderItems
WHERE discount_pct IS NULL
   OR TRIM(discount_pct) = '';


-- Gift flag profiling
-- Known issue: inconsistent casing and spaces
SELECT DISTINCT gift_flag
FROM raw.OrderItems;


-- Preview raw data
SELECT TOP 100 *
FROM raw.OrderItems;


-- ============================================
-- Clean OrderItems table structure
-- Data load will be completed after cleaning
-- rules for quantity and discount_pct are finalized.
-- ============================================

CREATE TABLE clean.OrderItems(
    order_item_id VARCHAR(100) PRIMARY KEY,
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10,2),
    gift_flag VARCHAR(1),
    discount_pct DECIMAL(5,2)
);


/*
NEXT SESSION:

1. Decide how to handle quantity = 0 and -1
2. Standardize discount_pct values
3. Standardize gift_flag to Y / N
4. Handle unit_price blanks / N/A
5. Validate order_id -> clean.Orders
6. Validate product_id -> clean.Products
7. Insert cleaned data into clean.OrderItems
8. Add foreign keys
*/