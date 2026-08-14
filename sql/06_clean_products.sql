USE OmniRetail360;
GO


-- ============================================
-- CREATE CLEAN PRODUCTS TABLE
-- ============================================

CREATE TABLE clean.Products (
    product_id VARCHAR(50) PRIMARY KEY,
    sku VARCHAR(50) UNIQUE,
    product_name VARCHAR(100),
    brand VARCHAR(50),
    category VARCHAR(50),
    supplier_id VARCHAR(50),
    unit_cost DECIMAL(10,2),
    list_price DECIMAL(10,2),
    active_flag VARCHAR(1),
    uom VARCHAR(10)
);
GO


-- ============================================
-- RAW -> CLEAN PRODUCT TRANSFORMATION
-- ============================================

INSERT INTO clean.Products (
    product_id,
    sku,
    product_name,
    brand,
    category,
    supplier_id,
    unit_cost,
    list_price,
    active_flag,
    uom
)

SELECT
    product_id,
    sku,
    product_name,
    brand,

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

    END AS category,

    supplier_id,

    TRY_CONVERT(
        DECIMAL(10,2),
        TRIM(REPLACE(unit_cost, '$', ''))
    ) AS unit_cost,

    TRY_CONVERT(
        DECIMAL(10,2),
        TRIM(REPLACE(list_price, '$', ''))
    ) AS list_price,

    active_flag,

    CASE
        WHEN LOWER(TRIM(uom)) IN ('ea', 'each', 'unit')
            THEN 'EA'
        ELSE TRIM(uom)
    END AS uom

FROM raw.Products;


-- ============================================
-- VALIDATE CLEAN PRODUCT DATA
-- ============================================

SELECT COUNT(*) AS raw_product_count
FROM raw.Products;


SELECT COUNT(*) AS clean_product_count
FROM clean.Products;


SELECT DISTINCT category
FROM clean.Products
ORDER BY category;


SELECT DISTINCT active_flag
FROM clean.Products;


SELECT DISTINCT uom
FROM clean.Products;


SELECT TOP 20 *
FROM clean.Products;