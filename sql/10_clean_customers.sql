USE OmniRetail360;
GO

-- ============================================
-- CREATE CLEAN CUSTOMERS TABLE
-- ============================================

CREATE TABLE clean.Customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    birth_date DATE,
    created_at DATETIME2,
    loyalty_tier VARCHAR(10),
    contact_preference VARCHAR(20)
);
GO

-- ============================================
-- RAW -> CLEAN CUSTOMER TRANSFORMATION
-- ============================================

INSERT INTO clean.Customers (
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    birth_date,
    created_at,
    loyalty_tier,
    contact_preference
)

SELECT
    customer_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,

    CASE
        WHEN TRIM(email) = '' THEN NULL
        WHEN TRIM(email) NOT LIKE '%@%' THEN NULL
        ELSE LOWER(TRIM(email))
    END AS email,

    CASE
        WHEN TRIM(phone) = '' THEN NULL

        WHEN LEN(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(phone, '+', ''),
                        '-', ''),
                    '(', ''),
                ')', ''),
            ' ', '')
        ) = 10
        THEN CONCAT(
            '+1',
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(phone, '+', ''),
                        '-', ''),
                    '(', ''),
                ')', ''),
            ' ', '')
        )

        WHEN LEN(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(phone, '+', ''),
                        '-', ''),
                    '(', ''),
                ')', ''),
            ' ', '')
        ) = 11
        AND REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(phone, '+', ''),
                    '-', ''),
                '(', ''),
            ')', ''),
        ' ', '') LIKE '1%'
        THEN CONCAT(
            '+',
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(phone, '+', ''),
                        '-', ''),
                    '(', ''),
                ')', ''),
            ' ', '')
        )

        ELSE NULL
    END AS phone,

    TRY_CONVERT(DATE, NULLIF(TRIM(birth_date), '')) AS birth_date,

    TRY_CONVERT(DATETIME2, NULLIF(TRIM(created_at), '')) AS created_at,

    CASE
        WHEN LOWER(TRIM(loyalty_tier)) = 'bronze' THEN 'Bronze'
        WHEN LOWER(TRIM(loyalty_tier)) = 'silver' THEN 'Silver'
        WHEN LOWER(TRIM(loyalty_tier)) = 'gold' THEN 'Gold'
        WHEN LOWER(TRIM(loyalty_tier)) = 'platinum' THEN 'Platinum'
        ELSE NULL
    END AS loyalty_tier,

    CASE
        WHEN LOWER(TRIM(contact_preference)) = 'email' THEN 'Email'
        WHEN LOWER(TRIM(contact_preference)) = 'sms' THEN 'SMS'
        WHEN LOWER(TRIM(contact_preference)) = 'push' THEN 'Push'
        WHEN LOWER(TRIM(contact_preference)) = 'none' THEN 'None'
        ELSE NULL
    END AS contact_preference

FROM raw.Customers;

-- ============================================
-- VALIDATION
-- ============================================

SELECT COUNT(*) AS raw_customer_count
FROM raw.Customers;

SELECT COUNT(*) AS clean_customer_count
FROM clean.Customers;

SELECT DISTINCT loyalty_tier
FROM clean.Customers
ORDER BY loyalty_tier;

SELECT DISTINCT contact_preference
FROM clean.Customers
ORDER BY contact_preference;

SELECT TOP 20 *
FROM clean.Customers;