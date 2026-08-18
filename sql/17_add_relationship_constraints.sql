-- ============================================
-- OmniRetail 360
-- Relationship Constraints
-- File: 17_add_relationship_constraints.sql
-- ============================================


-- Validate Orders -> Campaigns before creating FK
SELECT
    o.campaign_id
FROM raw.Orders AS o
LEFT JOIN clean.Campaigns AS c
    ON o.campaign_id = c.campaign_id
WHERE TRIM(o.campaign_id) <> ''
  AND c.campaign_id IS NULL;


-- Store ID must be NOT NULL before becoming a primary key
ALTER TABLE clean.Stores
ALTER COLUMN store_id VARCHAR(50) NOT NULL;


-- Add Stores primary key
ALTER TABLE clean.Stores
ADD CONSTRAINT PK_Stores
PRIMARY KEY (store_id);


-- Orders -> Customers
ALTER TABLE clean.Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (customer_id)
REFERENCES clean.Customers(customer_id);


-- Orders -> Stores
ALTER TABLE clean.Orders
ADD CONSTRAINT FK_Orders_Stores
FOREIGN KEY (store_id)
REFERENCES clean.Stores(store_id);


-- Orders -> Employees
ALTER TABLE clean.Orders
ADD CONSTRAINT FK_Orders_Employees
FOREIGN KEY (employee_id)
REFERENCES clean.Employees(employee_id);


-- Orders -> Campaigns
ALTER TABLE clean.Orders
ADD CONSTRAINT FK_Orders_Campaigns
FOREIGN KEY (campaign_id)
REFERENCES clean.Campaigns(campaign_id);


-- Final basic Orders validation
SELECT COUNT(*) AS order_count
FROM clean.Orders;


SELECT COUNT(DISTINCT order_id) AS unique_order_ids
FROM clean.Orders;


SELECT *
FROM clean.Orders
WHERE order_id IS NULL
   OR customer_id IS NULL;