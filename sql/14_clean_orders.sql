-- ============================================
-- OmniRetail 360
-- Clean Orders Table
-- File: 14_clean_orders.sql
-- ============================================

-- Create clean Orders table
CREATE TABLE clean.Orders(
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_datetime DATETIME2,
    order_status VARCHAR(20),
    sales_channel VARCHAR(30),
    employee_id VARCHAR(50) NULL,
    store_id VARCHAR(50) NULL,
    campaign_id VARCHAR(50) NULL,
    currency VARCHAR(3),
    fulfillment_method VARCHAR(30)
);


-- Insert cleaned order data
INSERT INTO clean.Orders(
    order_id,
    customer_id,
    order_datetime,
    order_status,
    sales_channel,
    employee_id,
    store_id,
    campaign_id,
    currency,
    fulfillment_method
)

SELECT
    TRIM(order_id) AS order_id,
    TRIM(customer_id) AS customer_id,

    TRY_CONVERT(DATETIME2, order_datetime) AS order_datetime,

    CASE
        WHEN LOWER(TRIM(order_status)) = 'pending' THEN 'Pending'
        WHEN LOWER(TRIM(order_status)) = 'returned' THEN 'Returned'
        WHEN LOWER(TRIM(order_status)) IN ('canceled', 'cancelled') THEN 'Cancelled'
        WHEN LOWER(TRIM(order_status)) IN ('completed', 'complete') THEN 'Complete'
        ELSE TRIM(order_status)
    END AS order_status,

    CASE
        WHEN LOWER(TRIM(sales_channel)) = 'store' THEN 'Store'
        WHEN LOWER(TRIM(sales_channel)) = 'marketplace' THEN 'Marketplace'
        WHEN LOWER(TRIM(sales_channel)) = 'mobile app' THEN 'Mobile App'
        WHEN LOWER(TRIM(sales_channel)) = 'web' THEN 'Web'
        ELSE NULL
    END AS sales_channel,

    CASE
        WHEN TRIM(employee_id) = '' THEN NULL
        ELSE TRIM(employee_id)
    END AS employee_id,

    CASE
        WHEN TRIM(store_id) = '' THEN NULL
        ELSE TRIM(store_id)
    END AS store_id,

    CASE
        WHEN TRIM(campaign_id) = '' THEN NULL
        ELSE TRIM(campaign_id)
    END AS campaign_id,

    CASE
        WHEN LOWER(TRIM(currency)) IN ('us$', 'usd') THEN 'USD'
        ELSE NULL
    END AS currency,

    CASE
        WHEN LOWER(TRIM(fulfillment_method)) = 'pickup' THEN 'Pickup'
        WHEN LOWER(TRIM(fulfillment_method)) = 'standard' THEN 'Standard'
        WHEN LOWER(TRIM(fulfillment_method)) = 'express' THEN 'Express'
        ELSE NULL
    END AS fulfillment_method

FROM raw.Orders;


-- Validate row count
SELECT COUNT(*) AS order_count
FROM clean.Orders;


-- Preview cleaned orders
SELECT TOP 20 *
FROM clean.Orders;


-- Validate cleaned categorical values
SELECT DISTINCT order_status
FROM clean.Orders;

SELECT DISTINCT sales_channel
FROM clean.Orders;

SELECT DISTINCT currency
FROM clean.Orders;

SELECT DISTINCT fulfillment_method
FROM clean.Orders;