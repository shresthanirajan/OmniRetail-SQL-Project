-- ============================================
-- OmniRetail 360
-- Order Data Profiling
-- File: 13_profile_orders.sql
-- ============================================

-- Check total order rows
SELECT COUNT(*)
FROM raw.Orders;


-- Check order_id uniqueness
SELECT COUNT(DISTINCT order_id)
FROM raw.Orders;


-- Check blank or NULL order IDs
SELECT order_id
FROM raw.Orders
WHERE TRIM(order_id) = ''
   OR order_id IS NULL;


-- Check blank or NULL customer IDs
SELECT customer_id
FROM raw.Orders
WHERE TRIM(customer_id) = ''
   OR customer_id IS NULL;


-- Validate customer IDs against clean.Customers
SELECT DISTINCT
    o.customer_id
FROM raw.Orders AS o
LEFT JOIN clean.Customers AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- Check order_datetime conversion
SELECT order_datetime
FROM raw.Orders
WHERE TRY_CONVERT(DATETIME2, order_datetime) IS NULL;


-- Check order date range
SELECT
    MIN(TRY_CONVERT(DATETIME2, order_datetime)) AS earliest_order,
    MAX(TRY_CONVERT(DATETIME2, order_datetime)) AS latest_order
FROM raw.Orders;


-- Check for future orders
SELECT order_datetime
FROM raw.Orders
WHERE TRY_CONVERT(DATETIME2, order_datetime) > GETDATE();


-- Inspect order status values
SELECT DISTINCT order_status
FROM raw.Orders;


-- Preview standardized order statuses
SELECT DISTINCT
    CASE
        WHEN LOWER(TRIM(order_status)) = 'pending' THEN 'Pending'
        WHEN LOWER(TRIM(order_status)) = 'returned' THEN 'Returned'
        WHEN LOWER(TRIM(order_status)) IN ('canceled', 'cancelled') THEN 'Cancelled'
        WHEN LOWER(TRIM(order_status)) IN ('completed', 'complete') THEN 'Complete'
        ELSE TRIM(order_status)
    END AS cleaned_order_status
FROM raw.Orders;


-- Inspect sales channel values
SELECT DISTINCT sales_channel
FROM raw.Orders;


-- Check blank store IDs by sales channel
SELECT
    sales_channel,
    COUNT(*) AS blank_store_count
FROM raw.Orders
WHERE TRIM(store_id) = ''
GROUP BY sales_channel;


-- Check blank employee IDs by sales channel
SELECT
    sales_channel,
    COUNT(*) AS blank_employee_count
FROM raw.Orders
WHERE TRIM(employee_id) = ''
GROUP BY sales_channel;


-- Check blank campaign IDs by sales channel
SELECT
    sales_channel,
    COUNT(*) AS blank_campaign_count
FROM raw.Orders
WHERE TRIM(campaign_id) = ''
GROUP BY sales_channel;


-- Inspect currency values
SELECT DISTINCT currency
FROM raw.Orders;


-- Inspect fulfillment method values
SELECT DISTINCT fulfillment_method
FROM raw.Orders;


-- Validate nonblank store IDs against clean.Stores
SELECT
    o.store_id
FROM raw.Orders AS o
LEFT JOIN clean.Stores AS s
    ON o.store_id = s.store_id
WHERE TRIM(o.store_id) <> ''
  AND s.store_id IS NULL;


-- Validate nonblank employee IDs against clean.Employees
SELECT
    o.employee_id
FROM raw.Orders AS o
LEFT JOIN clean.Employees AS e
    ON o.employee_id = e.employee_id
WHERE TRIM(o.employee_id) <> ''
  AND e.employee_id IS NULL;