-- ============================================
-- OmniRetail 360
-- Clean Employees Table
-- File: 12_clean_employees.sql
-- ============================================

-- Create clean Employees table
CREATE TABLE clean.Employees(
    employee_id VARCHAR(50) PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    store_id VARCHAR(50) NULL,
    job_title VARCHAR(100),
    hire_date DATE,
    manager_id VARCHAR(50) NULL,
    annual_salary DECIMAL(10,2),
    employment_status VARCHAR(50)
);


-- Insert cleaned employee data
INSERT INTO clean.Employees(
    employee_id,
    first_name,
    last_name,
    store_id,
    job_title,
    hire_date,
    manager_id,
    annual_salary,
    employment_status
)

SELECT
    TRIM(employee_id) AS employee_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,

    CASE
        WHEN TRIM(store_id) = '' THEN NULL
        ELSE TRIM(store_id)
    END AS store_id,

    TRIM(job_title) AS job_title,

    TRY_CONVERT(DATE, hire_date) AS hire_date,

    CASE
        WHEN TRIM(manager_id) = '' THEN NULL
        ELSE TRIM(manager_id)
    END AS manager_id,

    TRY_CONVERT(DECIMAL(10,2), annual_salary) AS annual_salary,

    TRIM(employment_status) AS employment_status

FROM raw.Employees;


-- Validate row count
SELECT COUNT(*) AS employee_count
FROM clean.Employees;


-- Preview cleaned employees
SELECT TOP 20 *
FROM clean.Employees;