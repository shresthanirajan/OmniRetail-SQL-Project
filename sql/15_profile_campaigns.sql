-- ============================================
-- OmniRetail 360
-- Campaign Data Profiling
-- File: 15_profile_campaigns.sql
-- ============================================

-- Check total campaign rows
SELECT COUNT(*) AS campaign_count
FROM raw.Campaigns;


-- Check campaign_id uniqueness
SELECT COUNT(DISTINCT campaign_id) AS unique_campaign_ids
FROM raw.Campaigns;


-- Check blank or NULL campaign IDs
SELECT campaign_id
FROM raw.Campaigns
WHERE TRIM(campaign_id) = ''
   OR campaign_id IS NULL;


-- Inspect campaign names
SELECT DISTINCT campaign_name
FROM raw.Campaigns;


-- Inspect marketing channels
SELECT DISTINCT channel
FROM raw.Campaigns;


-- Check start_date conversion
SELECT start_date
FROM raw.Campaigns
WHERE TRY_CONVERT(DATE, start_date) IS NULL;


-- Check campaign date range
SELECT
    MIN(TRY_CONVERT(DATE, start_date)) AS earliest_start_date,
    MAX(TRY_CONVERT(DATE, start_date)) AS latest_start_date
FROM raw.Campaigns;


-- Check end_date conversion
SELECT end_date
FROM raw.Campaigns
WHERE TRY_CONVERT(DATE, end_date) IS NULL;


-- Check for campaigns where end date is before start date
SELECT *
FROM raw.Campaigns
WHERE TRY_CONVERT(DATE, end_date) <
      TRY_CONVERT(DATE, start_date);


-- Check budget conversion
SELECT budget_usd
FROM raw.Campaigns
WHERE TRY_CONVERT(DECIMAL(10,2), budget_usd) IS NULL;


-- Check budget range
SELECT
    MIN(TRY_CONVERT(DECIMAL(10,2), budget_usd)) AS minimum_budget,
    MAX(TRY_CONVERT(DECIMAL(10,2), budget_usd)) AS maximum_budget
FROM raw.Campaigns;


-- Check for zero or negative budgets
SELECT *
FROM raw.Campaigns
WHERE TRY_CONVERT(DECIMAL(10,2), budget_usd) <= 0;


-- Inspect campaign objectives
SELECT DISTINCT objective
FROM raw.Campaigns;