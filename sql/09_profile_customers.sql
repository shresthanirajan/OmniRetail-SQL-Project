USE OmniRetail360;
GO

-- ============================================
-- CUSTOMER DATA PROFILING
-- ============================================

-- Preview raw customer data
SELECT *
FROM raw.Customers;

-- Total row count
SELECT COUNT(*) AS customer_count
FROM raw.Customers;

-- Unique customer IDs
SELECT COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM raw.Customers;

-- Duplicate emails
SELECT
    email,
    COUNT(*) AS duplicate_count
FROM raw.Customers
GROUP BY email
HAVING COUNT(*) > 1;

-- Distinct loyalty tiers
SELECT DISTINCT loyalty_tier
FROM raw.Customers
ORDER BY loyalty_tier;

-- Distinct contact preferences
SELECT DISTINCT contact_preference
FROM raw.Customers
ORDER BY contact_preference;

-- Blank contact preferences
SELECT *
FROM raw.Customers
WHERE TRIM(contact_preference) = '';

-- Invalid emails
SELECT email
FROM raw.Customers
WHERE TRIM(email) != ''
  AND email NOT LIKE '%@%';

-- Emails needing formatting cleanup
SELECT
    email,
    LOWER(TRIM(email)) AS cleaned_email
FROM raw.Customers
WHERE email != LOWER(TRIM(email));

-- Birth dates that cannot convert
SELECT birth_date
FROM raw.Customers
WHERE TRIM(birth_date) != ''
  AND TRY_CONVERT(DATE, birth_date) IS NULL;

-- Future birth dates
SELECT birth_date
FROM raw.Customers
WHERE TRY_CONVERT(DATE, birth_date) > GETDATE();

-- Suspiciously old birth dates
SELECT
    birth_date,
    YEAR(TRY_CONVERT(DATE, birth_date)) AS birth_year
FROM raw.Customers
WHERE TRY_CONVERT(DATE, birth_date) IS NOT NULL
  AND YEAR(TRY_CONVERT(DATE, birth_date)) <= 1945;

-- Created-at range
SELECT
    MIN(TRY_CONVERT(DATETIME2, created_at)) AS earliest_created_at,
    MAX(TRY_CONVERT(DATETIME2, created_at)) AS latest_created_at
FROM raw.Customers;

-- First-name whitespace check
SELECT
    first_name,
    LEN(first_name) AS original_length,
    LEN(TRIM(first_name)) AS trimmed_length
FROM raw.Customers
WHERE LEN(first_name) != LEN(TRIM(first_name));

-- Last-name whitespace check
SELECT
    last_name,
    LEN(last_name) AS original_length,
    LEN(TRIM(last_name)) AS trimmed_length
FROM raw.Customers
WHERE LEN(last_name) != LEN(TRIM(last_name));

-- Phone format investigation
SELECT *
FROM (
    SELECT
        phone,
        LEN(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(phone, ' ', ''),
                        '+', ''),
                    '(', ''),
                ')', ''),
            '-', '')
        ) AS cleaned_phone_length,

        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(phone, ' ', ''),
                    '+', ''),
                '(', ''),
            ')', ''),
        '-', '') AS cleaned_phone
    FROM raw.Customers
) AS phone_check
WHERE cleaned_phone_length = 11
  AND cleaned_phone NOT LIKE '1%';