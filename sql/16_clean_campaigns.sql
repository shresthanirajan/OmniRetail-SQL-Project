-- ============================================
-- OmniRetail 360
-- Clean Campaigns Table
-- File: 16_clean_campaigns.sql
-- ============================================

CREATE TABLE clean.Campaigns(
    campaign_id VARCHAR(50) PRIMARY KEY,
    campaign_name VARCHAR(100),
    channel VARCHAR(50),
    start_date DATE,
    end_date DATE,
    budget_usd DECIMAL(10,2),
    objective VARCHAR(50)
);


-- Load cleaned campaign data
INSERT INTO clean.Campaigns(
    campaign_id,
    campaign_name,
    channel,
    start_date,
    end_date,
    budget_usd,
    objective
)

SELECT
    TRIM(campaign_id) AS campaign_id,
    TRIM(campaign_name) AS campaign_name,
    TRIM(channel) AS channel,
    TRY_CONVERT(DATE, start_date) AS start_date,
    TRY_CONVERT(DATE, end_date) AS end_date,
    TRY_CONVERT(DECIMAL(10,2), budget_usd) AS budget_usd,
    TRIM(objective) AS objective

FROM raw.Campaigns;


-- Validate clean table
SELECT COUNT(*) AS campaign_count
FROM clean.Campaigns;

SELECT *
FROM clean.Campaigns;