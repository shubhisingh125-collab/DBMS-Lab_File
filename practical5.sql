-- EXPERIMENT 5
-- SQL VIEWS AND RECURSIVE CTE

-- Create Department Table
CREATE TABLE department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Create Employee Table
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2),
    dept_id INT,
    manager_id INT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id),
    FOREIGN KEY (manager_id) REFERENCES employee(emp_id)
);

-- Insert Department Data
INSERT INTO department VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');

-- Insert Employee Data
-- First insert employees who do not have managers
INSERT INTO employee VALUES
(101, 'Rahul', 60000, 1, NULL),
(104, 'Neha', 40000, 2, NULL),
(106, 'Karan', 55000, 3, NULL);

-- Then insert employees who have managers
INSERT INTO employee VALUES
(102, 'Aman', 45000, 1, 101),
(103, 'Priya', 50000, 1, 101),
(105, 'Riya', 35000, 2, 104);


-- Create Department Salary Summary View
CREATE OR REPLACE VIEW department_salary_summary AS
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    SUM(e.salary) AS total_salary,
    AVG(e.salary) AS average_salary
FROM department d
LEFT JOIN employee e
ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

-- Display Department Salary Summary
SELECT * FROM department_salary_summary;


-- Create Employee Hierarchy View
CREATE OR REPLACE VIEW employee_hierarchy AS
SELECT
    e.emp_id,
    e.emp_name,
    e.salary,
    d.dept_name,
    e.manager_id
FROM employee e
JOIN department d
ON e.dept_id = d.dept_id;

-- Display Employee Hierarchy
SELECT * FROM employee_hierarchy;


-- Create Simple View for Testing Updatability
CREATE OR REPLACE VIEW employee_basic AS
SELECT
    emp_id,
    emp_name,
    salary
FROM employee;

-- Update Employee Salary Through View
UPDATE employee_basic
SET salary = 47000
WHERE emp_id = 102;

-- Display Updated View
SELECT * FROM employee_basic;


-- Recursive CTE to Display Employee Reporting Chain
WITH RECURSIVE employee_chain AS
(
    -- Starting point: Employees who have no manager
    SELECT
        emp_id,
        emp_name,
        manager_id,
        1 AS level,
        CAST(emp_name AS CHAR(1000)) AS reporting_chain
    FROM employee
    WHERE manager_id IS NULL

    UNION ALL

    -- Find employees working under each manager
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        ec.level + 1,
        CONCAT(ec.reporting_chain, ' -> ', e.emp_name)
    FROM employee e
    JOIN employee_chain ec
        ON e.manager_id = ec.emp_id
)

SELECT
    emp_id,
    emp_name,
    manager_id,
    level,
    reporting_chain
FROM employee_chain
ORDER BY level, emp_id;