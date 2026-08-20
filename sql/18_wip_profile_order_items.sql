-- ============================================
-- OmniRetail 360
-- Order Items Profiling and Cleaning
-- File: 18_clean_order_items.sql
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


-- ============================================
-- Quantity Profiling
-- ============================================

-- Check blank or NULL quantities
SELECT quantity
FROM raw.OrderItems
WHERE quantity IS NULL
   OR TRIM(quantity) = '';


-- Inspect all quantity values
SELECT DISTINCT quantity
FROM raw.OrderItems;


-- Count invalid quantity values
SELECT  
    quantity,
    COUNT(*) AS quantity_count
FROM raw.OrderItems
WHERE quantity IN ('0', '-1')
GROUP BY quantity;


-- Check whether quantity 0 / -1 is related
-- to a specific order status
SELECT 
    oi.quantity,
    o.order_status,
    COUNT(*) AS order_count
FROM raw.OrderItems AS oi
LEFT JOIN clean.Orders AS o
    ON oi.order_id = o.order_id
WHERE oi.quantity IN ('0', '-1')
GROUP BY
    oi.quantity,
    o.order_status;


-- Preview quantity cleaning rule
-- Positive values are kept
-- 0 and -1 are treated as unknown / invalid
SELECT
    CASE
        WHEN TRY_CONVERT(INT, quantity) > 0
            THEN TRY_CONVERT(INT, quantity)
        WHEN TRY_CONVERT(INT, quantity) IN (0, -1)
            THEN NULL
    END AS cleaned_quantity
FROM raw.OrderItems;


-- Check nonblank quantity values that cannot convert
SELECT quantity
FROM raw.OrderItems
WHERE TRIM(quantity) <> ''
  AND TRY_CONVERT(INT, quantity) IS NULL;


-- ============================================
-- Unit Price Profiling
-- ============================================

-- Find nonblank unit prices that cannot convert
-- Known dirty value: N/A
SELECT unit_price
FROM raw.OrderItems
WHERE TRIM(unit_price) <> ''
  AND TRY_CONVERT(DECIMAL(10,2), unit_price) IS NULL;


-- Check numeric unit price range
SELECT
    MIN(TRY_CONVERT(DECIMAL(10,2), unit_price)) AS minimum_unit_price,
    MAX(TRY_CONVERT(DECIMAL(10,2), unit_price)) AS maximum_unit_price
FROM raw.OrderItems
WHERE TRY_CONVERT(DECIMAL(10,2), unit_price) IS NOT NULL;


-- Check for zero or negative valid prices
SELECT unit_price
FROM raw.OrderItems
WHERE TRY_CONVERT(DECIMAL(10,2), unit_price) <= 0;


-- ============================================
-- Discount Profiling
-- ============================================

-- Inspect discount formats
-- Examples include 30%, 30, 15%, 15
SELECT DISTINCT discount_pct
FROM raw.OrderItems;


-- Check blank or NULL discounts
SELECT discount_pct
FROM raw.OrderItems
WHERE discount_pct IS NULL
   OR TRIM(discount_pct) = '';


-- Check whether discount values can convert
-- after removing the percent symbol
SELECT discount_pct
FROM raw.OrderItems
WHERE TRIM(discount_pct) <> ''
  AND TRY_CONVERT(
        DECIMAL(5,2),
        REPLACE(TRIM(discount_pct), '%', '')
      ) IS NULL;


-- Preview cleaned discount values
SELECT
    TRY_CONVERT(
        DECIMAL(5,2),
        REPLACE(TRIM(discount_pct), '%', '')
    ) AS cleaned_discount_pct
FROM raw.OrderItems;


-- ============================================
-- Gift Flag Profiling
-- ============================================

-- Inspect raw gift flag values
SELECT DISTINCT gift_flag
FROM raw.OrderItems;


-- Preview standardized gift flag
SELECT DISTINCT
    CASE 
        WHEN TRIM(gift_flag) = '' THEN NULL
        ELSE UPPER(TRIM(gift_flag))
    END AS cleaned_gift_flag
FROM raw.OrderItems;


-- ============================================
-- Clean OrderItems Table
-- ============================================

CREATE TABLE clean.OrderItems(
    order_item_id VARCHAR(100) PRIMARY KEY,
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10,2),
    discount_pct DECIMAL(5,2),
    gift_flag VARCHAR(1)
);


-- ============================================
-- Load Clean OrderItems
-- ============================================

INSERT INTO clean.OrderItems(
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    gift_flag
)

SELECT
    TRIM(order_item_id) AS order_item_id,
    TRIM(order_id) AS order_id,
    TRIM(product_id) AS product_id,

    CASE
        WHEN TRY_CONVERT(INT, quantity) > 0
            THEN TRY_CONVERT(INT, quantity)
        WHEN TRY_CONVERT(INT, quantity) IN (0, -1)
            THEN NULL
    END AS quantity,

    TRY_CONVERT(
        DECIMAL(10,2),
        TRIM(unit_price)
    ) AS unit_price,

    TRY_CONVERT(
        DECIMAL(5,2),
        REPLACE(TRIM(discount_pct), '%', '')
    ) AS discount_pct,

    CASE 
        WHEN TRIM(gift_flag) = '' THEN NULL
        ELSE UPPER(TRIM(gift_flag))
    END AS gift_flag

FROM raw.OrderItems;


-- ============================================
-- Validation
-- ============================================

-- Check clean row count
SELECT COUNT(*) AS clean_order_item_count
FROM clean.OrderItems;


-- Preview cleaned records
SELECT TOP 100 *
FROM clean.OrderItems;


-- Check how many quantities became NULL
SELECT COUNT(*) AS null_quantity_count
FROM clean.OrderItems
WHERE quantity IS NULL;


-- Check cleaned gift flag values
SELECT DISTINCT gift_flag
FROM clean.OrderItems;


-- Check cleaned discount range
SELECT
    MIN(discount_pct) AS minimum_discount,
    MAX(discount_pct) AS maximum_discount
FROM clean.OrderItems;