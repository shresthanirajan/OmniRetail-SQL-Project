-- ============================================
-- OmniRetail 360
-- Order Items Profiling - WORK IN PROGRESS
-- File: 18_wip_profile_order_items.sql
--
-- Status:
-- Order Items profiling has just started.
-- This file will be expanded during the next
-- project session.
-- ============================================


-- Raw OrderItems table
CREATE TABLE raw.OrderItems(
    order_item_id VARCHAR(100),
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity VARCHAR(50),
    unit_price VARCHAR(50),
    discount_pct VARCHAR(50),
    gift_flag VARCHAR(50)
);


-- Check total number of order item records
SELECT COUNT(*) AS order_item_count
FROM raw.OrderItems;


-- Begin checking order_item_id uniqueness
SELECT COUNT(DISTINCT order_item_id) AS unique_order_item_ids
FROM raw.OrderItems;


-- Preview source data
SELECT TOP 100 *
FROM raw.OrderItems;


/*
NEXT SESSION:

1. Check order_item_id duplicates / blanks
2. Validate order_id -> clean.Orders
3. Validate product_id -> clean.Products
4. Profile quantity
5. Profile unit_price
6. Profile discount_pct
7. Profile gift_flag
8. Investigate duplicates
9. Design clean.OrderItems
*/