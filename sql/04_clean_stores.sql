USE OmniRetail360;
GO


-- ============================================
-- CREATE CLEAN STORES TABLE
-- ============================================

CREATE TABLE clean.Stores (
    store_id VARCHAR(50) PRIMARY KEY,
    store_name VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(50),
    opened_date DATE,
    store_type VARCHAR(50)
);
GO


-- ============================================
-- LOAD RAW STORES INTO CLEAN STORES
-- ============================================

INSERT INTO clean.Stores (
    store_id,
    store_name,
    city,
    state,
    country,
    opened_date,
    store_type
)

SELECT
    store_id,
    store_name,
    city,
    state,
    country,
    CONVERT(DATE, opened_date),
    store_type
FROM raw.Stores;


-- ============================================
-- VALIDATION
-- ============================================

SELECT COUNT(*) AS raw_store_count
FROM raw.Stores;


SELECT COUNT(*) AS clean_store_count
FROM clean.Stores;


SELECT *
FROM clean.Stores;