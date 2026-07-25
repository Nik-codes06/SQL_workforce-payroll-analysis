-- ============================================================================
-- PORTFOLIO PROJECT: Parks & Recreation Data Analysis
-- AUTHOR: Nikunj_pitti
-- PURPOSE: Demonstrating foundational SQL, multi-table joins, 
--          window functions, and Common Table Expressions (CTEs).
-- ============================================================================

USE parks_and_recreation;

-- ============================================================================
-- SECTION 1: FOUNDATIONAL QUERIES (5)
-- ============================================================================

-- Query 1: Filtering & Sorting
-- Business Goal: Identify senior workforce members aged over 40 sorted by age.
SELECT * 
FROM employee_demographics
WHERE age > 40
ORDER BY age DESC;

-- Query 2: Text Manipulation & Formatting
-- Business Goal: Generate standardized full names in uppercase for employee badging.
SELECT 
    first_name, 
    last_name,
    UPPER(CONCAT(first_name, ' ', last_name)) AS full_name
FROM employee_demographics;

-- Query 3: Date Functions & Extraction
-- Business Goal: Extract birth years to analyze employee age cohorts.
SELECT 
    first_name, 
    birth_date,
    EXTRACT(YEAR FROM birth_date) AS birth_year
FROM employee_demographics;

-- Query 4: Conditional Logic (CASE Statement)
-- Business Goal: Categorize workforce into High, Medium, and Low compensation brackets.
SELECT 
    first_name, 
    salary,
    CASE 
        WHEN salary > 70000 THEN 'High'
        WHEN salary BETWEEN 50000 AND 70000 THEN 'Medium'
        ELSE 'Low' 
    END AS salary_bracket
FROM employee_salary;

-- Query 5: Grouping & Aggregation with HAVING
-- Business Goal: Summarize department payroll expenditures exceeding $100,000 (excluding directors).
SELECT 
    dept_id, 
    SUM(salary) AS total_salary
FROM employee_salary
WHERE occupation NOT LIKE '%Director%'
GROUP BY dept_id
HAVING SUM(salary) > 100000;


-- ============================================================================
-- SECTION 2: MULTI-TABLE JOINS (5)
-- ============================================================================

-- Query 6: INNER JOIN
-- Business Goal: Combine demographic data with salary records for active employees.
SELECT 
    dem.employee_id, 
    dem.first_name, 
    dem.last_name, 
    dem.age, 
    sal.salary
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
    ON dem.employee_id = sal.employee_id;

-- Query 7: LEFT JOIN
-- Business Goal: Map all employee salaries to departments, preserving unassigned personnel.
SELECT 
    sal.first_name, 
    sal.last_name, 
    pks_dept.department_name
FROM employee_salary AS sal
LEFT JOIN parks_departments AS pks_dept
    ON sal.dept_id = pks_dept.department_id;

-- Query 8: RIGHT JOIN
-- Business Goal: Inspect all department entries, including those with zero assigned employees.
SELECT 
    sal.first_name, 
    sal.last_name, 
    pks_dept.department_name
FROM employee_salary AS sal
RIGHT JOIN parks_departments AS pks_dept
    ON sal.dept_id = pks_dept.department_id;

-- Query 9: 3-Table Join
-- Business Goal: Build a consolidated master view of demographics, salaries, and department names.
SELECT 
    dem.first_name, 
    dem.last_name, 
    dem.age, 
    sal.salary, 
    pks_dept.department_name
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
    ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS pks_dept
    ON sal.dept_id = pks_dept.department_id
ORDER BY dem.age;

-- Query 10: Self Join
-- Business Goal: Match pairs of employees working within the exact same department.
SELECT 
    emp1.first_name AS employee_1, 
    emp2.first_name AS employee_2, 
    emp1.dept_id
FROM employee_salary AS emp1
INNER JOIN employee_salary AS emp2
    ON emp1.dept_id = emp2.dept_id
WHERE emp1.employee_id < emp2.employee_id;


-- ============================================================================
-- SECTION 3: WINDOW FUNCTIONS (5)
-- ============================================================================

-- Query 11: ROW_NUMBER()
-- Business Goal: Assign a sequential row number to employees ordered by salary within departments.
SELECT 
    dept_id, 
    first_name, 
    salary,
    ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS row_num
FROM employee_salary
WHERE dept_id IS NOT NULL;

-- Query 12: DENSE_RANK()
-- Business Goal: Rank compensation levels within each department handling tied values cleanly.
SELECT 
    dept_id, 
    first_name, 
    salary,
    DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_salary_rank
FROM employee_salary
WHERE dept_id IS NOT NULL;

-- Query 13: Partitioned Average
-- Business Goal: Compare each individual's salary directly against their department's average.
SELECT 
    first_name, 
    dept_id, 
    salary,
    AVG(salary) OVER (PARTITION BY dept_id) AS dept_avg_salary
FROM employee_salary
WHERE dept_id IS NOT NULL;

-- Query 14: Running Total
-- Business Goal: Calculate a cumulative running total of payroll spent as employee IDs progress.
SELECT 
    employee_id, 
    first_name, 
    salary,
    SUM(salary) OVER (ORDER BY employee_id) AS running_total_payroll
FROM employee_salary;

-- Query 15: Maximum Salary Benchmark
-- Business Goal: Compute department max salary on every row to evaluate compensation gaps.
SELECT 
    first_name, 
    dept_id, 
    salary,
    MAX(salary) OVER (PARTITION BY dept_id) AS max_dept_salary
FROM employee_salary
WHERE dept_id IS NOT NULL;


-- ============================================================================
-- SECTION 4: COMMON TABLE EXPRESSIONS (CTEs) (2)
-- ============================================================================

-- Query 16: CTE with Window Function Filter
-- Business Goal: Isolate the top 2 highest earners from each department.
-- Note: CTE is required because window function aliases cannot be filtered directly in WHERE.
WITH top_2_dept AS (
    SELECT 
        dept_id, 
        first_name, 
        last_name, 
        salary,
        DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_salary_rank
    FROM employee_salary
    WHERE dept_id IS NOT NULL
)
SELECT * 
FROM top_2_dept
WHERE dept_salary_rank <= 2;

-- Query 17: CTE for Demographic Ranking
-- Business Goal: Identify the single oldest employee across each gender category.
WITH senior_emp AS (
    SELECT 
        gender, 
        first_name, 
        last_name, 
        age,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY age DESC) AS sr
    FROM employee_demographics
)
SELECT * 
FROM senior_emp
WHERE sr = 1;