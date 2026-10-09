-- EXPERIMENT 3
-- Employee-Department-Project Database
 
-- Use the database provided by the execution environment
 
-- 2. Create Department table
CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);
 
-- 3. Create Employee table
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);
 
-- 4. Create Project table
CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    budget DECIMAL(12,2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);
 
-- 5. Insert departments
INSERT INTO Department VALUES
(1, 'Engineering', 'Pune'),
(2, 'Sales', 'Chennai'),
(3, 'Operations', 'Kolkata');
 
-- 6. Insert projects
INSERT INTO Project VALUES
(201, 'Mobile Banking App', 1500000, 1),
(202, 'Data Warehouse', 1100000, 1),
(203, 'Network Upgrade', 900000, 1),
(204, 'Customer Outreach', 600000, 2),
(205, 'Sales Dashboard', 450000, 2),
(206, 'Supply Tracking', 850000, 3),
(207, 'Warehouse Automation', 1250000, 3),
(208, 'Vendor Portal', 700000, 3);
 
-- 7. Insert 30 employees
INSERT INTO Employee VALUES
(1,  'Rohit',   58000, '2021-02-14', 1),
(2,  'Meera',   72000, '2020-06-09', 1),
(3,  'Kunal',   49000, '2023-01-23', 1),
(4,  'Divya',   66000, '2021-10-30', 1),
(5,  'Harsh',   81000, '2019-03-12', 1),
(6,  'Pallavi', 53000, '2022-07-19', 1),
(7,  'Nitin',   61000, '2022-01-05', 1),
(8,  'Sakshi',  77000, '2020-11-17', 1),
(9,  'Yogesh',  45000, '2023-04-02', 1),
(10, 'Tara',    69000, '2021-08-25', 1),
 
(11, 'Gaurav',  42000, '2022-03-11', 2),
(12, 'Anjali',  56000, '2021-05-28', 2),
(13, 'Deepak',  47000, '2023-02-16', 2),
(14, 'Rekha',   63000, '2020-09-04', 2),
(15, 'Sumit',   51000, '2022-10-21', 2),
(16, 'Bhavna',  59000, '2021-12-13', 2),
(17, 'Lalit',   44000, '2023-06-30', 2),
(18, 'Komal',   67000, '2019-12-08', 2),
(19, 'Rajat',   52000, '2022-05-09', 2),
(20, 'Isha',    71000, '2020-02-27', 2),
 
(21, 'Mayank',  64000, '2021-04-06', 3),
(22, 'Naina',   55000, '2022-08-14', 3),
(23, 'Ashish',  48000, '2023-03-01', 3),
(24, 'Poonam',  73000, '2019-10-22', 3),
(25, 'Tarun',   60000, '2021-09-18', 3),
(26, 'Swati',   46000, '2023-07-12', 3),
(27, 'Vishal',  68000, '2020-05-31', 3),
(28, 'Ritika',  57000, '2022-02-24', 3),
(29, 'Jatin',   75000, '2019-07-15', 3),
(30, 'Alka',    50000, '2022-11-03', 3);
 
-- 8. Selection (employees earning more than 55000)
SELECT *
FROM Employee
WHERE salary > 55000;
 
-- 9. Projection
SELECT emp_name, salary
FROM Employee;
 
-- 10. Sorting using ORDER BY
SELECT emp_name, salary
FROM Employee
ORDER BY salary DESC;
 
-- 11. Aggregate functions
SELECT
    COUNT(*)    AS total_employees,
    AVG(salary) AS average_salary,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM Employee;
 
-- 12. GROUP BY (employees per department)
SELECT dept_id, COUNT(*) AS employee_count
FROM Employee
GROUP BY dept_id;
 
-- 13. GROUP BY with average
SELECT dept_id, AVG(salary) AS average_salary
FROM Employee
GROUP BY dept_id;
 
-- 14. HAVING (departments with at least 10 employees)
SELECT dept_id, COUNT(*) AS employee_count
FROM Employee
GROUP BY dept_id
HAVING COUNT(*) >= 10;
 
-- 15. CASE expression
SELECT
    emp_name,
    salary,
    CASE
        WHEN salary >= 70000 THEN 'High Salary'
        WHEN salary >= 50000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM Employee;
 
-- 16. Employee with department name (JOIN)
SELECT
    e.emp_name,
    d.dept_name,
    e.salary
FROM Employee e
JOIN Department d
ON e.dept_id = d.dept_id;
 
-- 17. Departments with average salary greater than 58000
SELECT dept_id, AVG(salary) AS average_salary
FROM Employee
GROUP BY dept_id
HAVING AVG(salary) > 58000;
 
-- 18. Projects sorted by budget
SELECT project_name, budget
FROM Project
ORDER BY budget DESC;
 
