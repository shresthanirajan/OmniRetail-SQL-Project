-- ============================================
-- OmniRetail 360
-- Employee Data Profiling
-- File: 11_profile_employees.sql
-- ============================================

-- Check total employee rows
SELECT COUNT(*)
FROM raw.Employees;


-- Check employee_id uniqueness
SELECT COUNT(DISTINCT employee_id)
FROM raw.Employees;


-- Check for blank or NULL employee IDs
SELECT employee_id
FROM raw.Employees
WHERE TRIM(employee_id) = ''
   OR employee_id IS NULL;


-- Check for blank or NULL employee names
SELECT first_name, last_name
FROM raw.Employees
WHERE TRIM(first_name) = ''
   OR first_name IS NULL
   OR TRIM(last_name) = ''
   OR last_name IS NULL;


-- Inspect unique job titles
SELECT DISTINCT job_title
FROM raw.Employees;


-- Check hire_date blanks or NULLs
SELECT hire_date
FROM raw.Employees
WHERE TRIM(hire_date) = ''
   OR hire_date IS NULL;


-- Check hire_date conversion
SELECT hire_date
FROM raw.Employees
WHERE TRY_CONVERT(DATE, hire_date) IS NULL
  AND TRIM(hire_date) <> '';


-- Check earliest and latest hire dates
SELECT
    MIN(TRY_CONVERT(DATE, hire_date)) AS earliest_hire_date,
    MAX(TRY_CONVERT(DATE, hire_date)) AS latest_hire_date
FROM raw.Employees;


-- Check for future hire dates
SELECT hire_date
FROM raw.Employees
WHERE TRY_CONVERT(DATE, hire_date) > GETDATE();


-- Check salary blanks or NULLs
SELECT annual_salary
FROM raw.Employees
WHERE TRIM(annual_salary) = ''
   OR annual_salary IS NULL;


-- Check salary conversion
SELECT annual_salary
FROM raw.Employees
WHERE TRY_CONVERT(DECIMAL(10,2), annual_salary) IS NULL
  AND TRIM(annual_salary) <> '';


-- Check salary range
SELECT
    MIN(TRY_CONVERT(DECIMAL(10,2), annual_salary)) AS minimum_salary,
    MAX(TRY_CONVERT(DECIMAL(10,2), annual_salary)) AS maximum_salary
FROM raw.Employees;


-- Inspect employment status values
SELECT DISTINCT employment_status
FROM raw.Employees;


-- Check manager IDs
SELECT COUNT(DISTINCT manager_id)
FROM raw.Employees;


-- Validate employee store IDs against clean.Stores
SELECT
    e.store_id
FROM raw.Employees AS e
LEFT JOIN clean.Stores AS s
    ON e.store_id = s.store_id
WHERE TRIM(e.store_id) <> ''
  AND s.store_id IS NULL;


-- Validate manager_id against employee_id
-- Self-join because managers are also employees
SELECT
    e.manager_id
FROM raw.Employees AS e
LEFT JOIN raw.Employees AS m
    ON e.manager_id = m.employee_id
WHERE TRIM(e.manager_id) <> ''
  AND m.employee_id IS NULL;