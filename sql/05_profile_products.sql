USE OmniRetail360;
GO


-- ============================================
-- PRODUCT DATA PROFILING
-- ============================================


-- Preview raw product data
SELECT *
FROM raw.Products;


-- Check total rows
SELECT COUNT(*) AS product_count
FROM raw.Products;


-- ============================================
-- NULL CHECKS
-- ============================================

SELECT COUNT(*) AS rows_with_nulls
FROM raw.Products
WHERE product_id IS NULL
   OR sku IS NULL
   OR product_name IS NULL
   OR brand IS NULL
   OR category IS NULL
   OR supplier_id IS NULL
   OR unit_cost IS NULL
   OR list_price IS NULL
   OR active_flag IS NULL
   OR uom IS NULL;


-- ============================================
-- DUPLICATE KEY CHECKS
-- ============================================

-- Product ID should be unique
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM raw.Products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- SKU should also be unique
SELECT
    sku,
    COUNT(*) AS duplicate_count
FROM raw.Products
GROUP BY sku
HAVING COUNT(*) > 1;


-- ============================================
-- CATEGORY PROFILING
-- ============================================

SELECT DISTINCT category
FROM raw.Products
ORDER BY category;


-- Test category cleaning rules
SELECT
    category,
    LOWER(TRIM(category)) AS normalized_category,

    CASE
        WHEN LOWER(TRIM(category)) IN ('computer', 'computers')
            THEN 'Computers'

        WHEN LOWER(TRIM(category)) IN ('toy', 'toys')
            THEN 'Toys'

        WHEN LOWER(TRIM(category)) IN ('fitnes', 'fitness')
            THEN 'Fitness'

        WHEN LOWER(TRIM(category)) IN ('electronics', 'electronic')
            THEN 'Electronics'

        WHEN LOWER(TRIM(category)) IN ('auto', 'automotive')
            THEN 'Automotive'

        WHEN LOWER(TRIM(category)) IN ('shoes', 'footwear')
            THEN 'Footwear'

        WHEN LOWER(TRIM(category)) IN ('kitchen', 'kitchen & dining')
            THEN 'Kitchen & Dining'

        WHEN LOWER(TRIM(category)) IN ('outdoors', 'outdoor')
            THEN 'Outdoors'

        WHEN LOWER(TRIM(category)) = 'office'
            THEN 'Office'

        WHEN LOWER(TRIM(category)) = 'home'
            THEN 'Home'

        WHEN LOWER(TRIM(category)) = 'beauty'
            THEN 'Beauty'

        WHEN LOWER(TRIM(category)) IN ('clothing', 'apparel')
            THEN 'Clothing'

        ELSE TRIM(category)

    END AS clean_category

FROM raw.Products;


-- ============================================
-- UNIT COST PROFILING
-- ============================================

-- Find values that still cannot become numbers
-- after removing dollar signs and spaces.

SELECT
    unit_cost
FROM raw.Products
WHERE TRY_CONVERT(
    DECIMAL(10,2),
    TRIM(REPLACE(unit_cost, '$', ''))
) IS NULL;


-- Preview cleaned unit cost
SELECT
    unit_cost AS original_unit_cost,

    TRIM(
        REPLACE(unit_cost, '$', '')
    ) AS cleaned_text,

    TRY_CONVERT(
        DECIMAL(10,2),
        TRIM(REPLACE(unit_cost, '$', ''))
    ) AS cleaned_unit_cost

FROM raw.Products;


-- ============================================
-- LIST PRICE PROFILING
-- ============================================

SELECT
    list_price
FROM raw.Products
WHERE TRY_CONVERT(
    DECIMAL(10,2),
    TRIM(REPLACE(list_price, '$', ''))
) IS NULL;


-- ============================================
-- ACTIVE FLAG PROFILING
-- ============================================

-- Expected values: Y and N
SELECT DISTINCT active_flag
FROM raw.Products
ORDER BY active_flag;


-- Find unexpected active flag values
SELECT *
FROM raw.Products
WHERE active_flag NOT IN ('Y', 'N')
   OR active_flag IS NULL;


-- ============================================
-- UNIT OF MEASURE PROFILING
-- ============================================

SELECT DISTINCT uom
FROM raw.Products
ORDER BY uom;


-- Test UOM cleaning
SELECT
    uom,

    CASE
        WHEN LOWER(TRIM(uom)) IN ('ea', 'each', 'unit')
            THEN 'EA'
        ELSE TRIM(uom)
    END AS clean_uom

FROM raw.Products;