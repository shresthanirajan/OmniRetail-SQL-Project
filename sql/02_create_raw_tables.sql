USE OmniRetail360;
GO


-- ============================================
-- RAW STORES TABLE
-- ============================================
-- Raw tables use flexible data types because
-- source CSV data may contain formatting issues.

CREATE TABLE raw.Stores (
    store_id VARCHAR(50),
    store_name VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(50),
    opened_date VARCHAR(50),
    store_type VARCHAR(50)
);
GO


-- ============================================
-- RAW PRODUCTS TABLE
-- ============================================
-- Price columns are VARCHAR in the raw layer
-- because the source contains values such as:
-- $44.03, spaces, blanks, and N/A.

CREATE TABLE raw.Products (
    product_id VARCHAR(50),
    sku VARCHAR(50),
    product_name VARCHAR(100),
    brand VARCHAR(50),
    category VARCHAR(50),
    supplier_id VARCHAR(50),
    unit_cost VARCHAR(50),
    list_price VARCHAR(50),
    active_flag VARCHAR(50),
    uom VARCHAR(50)
);
GO