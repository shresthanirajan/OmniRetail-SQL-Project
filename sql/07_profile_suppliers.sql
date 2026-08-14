USE OmniRetail360;
GO

-- ============================================
-- SUPPLIER DATA PROFILING
-- ============================================

-- Preview supplier data
SELECT *
FROM raw.Suppliers;


-- Check total row count
SELECT COUNT(*) AS supplier_count
FROM raw.Suppliers;


-- Check for NULL values
SELECT *
FROM raw.Suppliers
WHERE supplier_id IS NULL
   OR supplier_name IS NULL
   OR country IS NULL
   OR payment_terms IS NULL
   OR lead_time_days IS NULL
   OR status IS NULL;


-- Check for blank values
SELECT *
FROM raw.Suppliers
WHERE TRIM(supplier_id) = ''
   OR TRIM(supplier_name) = ''
   OR TRIM(country) = ''
   OR TRIM(payment_terms) = ''
   OR TRIM(lead_time_days) = ''
   OR TRIM(status) = '';


-- Check duplicate supplier IDs
SELECT
    supplier_id,
    COUNT(*) AS duplicate_count
FROM raw.Suppliers
GROUP BY supplier_id
HAVING COUNT(*) > 1;


-- Check duplicate supplier names
SELECT
    supplier_name,
    COUNT(*) AS duplicate_count
FROM raw.Suppliers
GROUP BY supplier_name
HAVING COUNT(*) > 1;


-- Inspect countries
SELECT DISTINCT country
FROM raw.Suppliers
ORDER BY country;


-- Inspect payment terms
SELECT DISTINCT payment_terms
FROM raw.Suppliers
ORDER BY payment_terms;


-- Inspect supplier statuses
SELECT DISTINCT status
FROM raw.Suppliers
ORDER BY status;


-- Find lead_time_days values that cannot become integers
SELECT
    lead_time_days
FROM raw.Suppliers
WHERE TRY_CONVERT(INT, lead_time_days) IS NULL;


-- Check lead-time range
SELECT
    MIN(TRY_CONVERT(INT, lead_time_days)) AS minimum_lead_time,
    MAX(TRY_CONVERT(INT, lead_time_days)) AS maximum_lead_time
FROM raw.Suppliers;


-- Find suspicious lead times
SELECT *
FROM raw.Suppliers
WHERE TRY_CONVERT(INT, lead_time_days) < 1
   OR TRY_CONVERT(INT, lead_time_days) > 30;