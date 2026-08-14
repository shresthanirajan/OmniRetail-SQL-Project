USE OmniRetail360;
GO

-- ============================================
-- CREATE CLEAN SUPPLIERS TABLE
-- ============================================

CREATE TABLE clean.Suppliers (
    supplier_id VARCHAR(50) PRIMARY KEY,
    supplier_name VARCHAR(50),
    country VARCHAR(30),
    payment_terms VARCHAR(30),
    lead_time_days INT,
    status VARCHAR(20)
);
GO


-- ============================================
-- RAW -> CLEAN SUPPLIER TRANSFORMATION
-- ============================================

INSERT INTO clean.Suppliers (
    supplier_id,
    supplier_name,
    country,
    payment_terms,
    lead_time_days,
    status
)

SELECT
    supplier_id,
    supplier_name,
    country,
    payment_terms,
    TRY_CONVERT(INT, lead_time_days) AS lead_time_days,
    status
FROM raw.Suppliers;


-- ============================================
-- VALIDATE CLEAN SUPPLIERS
-- ============================================

SELECT COUNT(*) AS raw_supplier_count
FROM raw.Suppliers;


SELECT COUNT(*) AS clean_supplier_count
FROM clean.Suppliers;


SELECT TOP 20 *
FROM clean.Suppliers;


-- ============================================
-- CHECK PRODUCT -> SUPPLIER RELATIONSHIP
-- ============================================

-- Find product supplier IDs that do not exist
-- in the clean Suppliers table.

SELECT DISTINCT
    p.supplier_id
FROM clean.Products AS p

LEFT JOIN clean.Suppliers AS s
    ON p.supplier_id = s.supplier_id

WHERE s.supplier_id IS NULL;


-- ============================================
-- ADD FOREIGN KEY
-- ============================================

ALTER TABLE clean.Products
ADD CONSTRAINT FK_Products_Suppliers
FOREIGN KEY (supplier_id)
REFERENCES clean.Suppliers(supplier_id);