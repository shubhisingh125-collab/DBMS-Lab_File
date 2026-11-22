DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Department;
 
-- Create Department Table
CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);
 
-- Create Project Table
CREATE TABLE Project (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    Budget DECIMAL(12,2)
);
 
-- Create Employee Table
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Salary DECIMAL(10,2),
    DeptID INT,
    ProjectID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);
 
-- Insert Department Records
INSERT INTO Department VALUES
(1, 'Software'),
(2, 'Human Resources'),
(3, 'Accounts'),
(4, 'Sales'),
(5, 'Support');
 
-- Insert Project Records
INSERT INTO Project VALUES
(301, 'E-Commerce Platform', 900000),
(302, 'Helpdesk Tool', 350000),
(303, 'CRM Integration', 700000),
(304, 'Lead Tracker', 280000),
(305, 'Hiring Portal', 420000),
(306, 'Training Module', 260000),
(307, 'Audit Automation', 550000),
(308, 'Expense Manager', 480000);
 
-- Insert 30 Employee Records
INSERT INTO Employee VALUES
(1,  'Aditya',  62000, 1, 301),
(2,  'Bhumika', 48000, 1, 302),
(3,  'Chirag',  55000, 1, 301),
(4,  'Disha',   45000, 1, 303),
(5,  'Eshan',   70000, 1, 304),
(6,  'Falguni', 50000, 1, 302),
 
(7,  'Girish',  41000, 2, 305),
(8,  'Hina',    46000, 2, 306),
(9,  'Imran',   52000, 2, 305),
(10, 'Juhi',    39000, 2, 306),
(11, 'Kartik',  58000, 2, 305),
(12, 'Leena',   44000, 2, 306),
 
(13, 'Mohan',   60000, 3, 307),
(14, 'Neelam',  53000, 3, 307),
(15, 'Omkar',   47000, 3, 308),
(16, 'Pooja',   65000, 3, 307),
(17, 'Qasim',   51000, 3, 308),
(18, 'Radha',   49000, 3, 308),
 
(19, 'Sagar',   57000, 4, 303),
(20, 'Tanya',   43000, 4, 304),
(21, 'Uday',    68000, 4, 303),
(22, 'Vidya',   50000, 4, 304),
(23, 'Waseem',  54000, 4, 303),
(24, 'Yamini',  40000, 4, 304),
 
(25, 'Zoya',    45000, 5, 301),
(26, 'Abhay',   38000, 5, 302),
(27, 'Bela',    52000, 5, 301),
(28, 'Chetan',  42000, 5, 302),
(29, 'Dhruv',   56000, 5, 301),
(30, 'Esha',    47000, 5, 302);
 
-- Display All Records
SELECT * FROM Department;
SELECT * FROM Project;
SELECT * FROM Employee;
 
-- 1. Selection
SELECT * FROM Employee
WHERE Salary > 50000;
 
-- 2. Projection
SELECT EmpName, Salary
FROM Employee;
 
-- 3. Aggregate Functions
SELECT COUNT(*)    AS TotalEmployees,
       SUM(Salary) AS TotalSalary,
       AVG(Salary) AS AverageSalary,
       MIN(Salary) AS MinimumSalary,
       MAX(Salary) AS MaximumSalary
FROM Employee;
 
-- 4. GROUP BY
SELECT DeptID, COUNT(*) AS TotalEmployees
FROM Employee
GROUP BY DeptID;
 
-- 5. HAVING
SELECT DeptID, COUNT(*) AS TotalEmployees
FROM Employee
GROUP BY DeptID
HAVING COUNT(*) > 5;
 
-- 6. CASE Expression
SELECT EmpName, Salary,
CASE
    WHEN Salary >= 60000 THEN 'High'
    WHEN Salary >= 45000 THEN 'Medium'
    ELSE 'Low'
END AS SalaryCategory
FROM Employee;
 
-- 7. ORDER BY
SELECT EmpName, Salary
FROM Employee
ORDER BY Salary DESC;
 
-- 8. EXCEPT
-- Employees in Dept 1 except those earning above 50000
-- (EXCEPT/INTERSECT need MySQL 8.0.31 or newer)
SELECT EmpID FROM Employee
WHERE DeptID = 1
EXCEPT
SELECT EmpID FROM Employee
WHERE Salary > 50000;
 
-- 9. INTERSECT
-- Employees in Dept 1 who earn above 50000
SELECT EmpID FROM Employee
WHERE DeptID = 1
INTERSECT
SELECT EmpID FROM Employee
WHERE Salary > 50000;
 
-- 10. INNER JOIN
SELECT E.EmpName, D.DeptName
FROM Employee E
INNER JOIN Department D
ON E.DeptID = D.DeptID;
 
-- 11. LEFT JOIN
SELECT D.DeptName, E.EmpName
FROM Department D
LEFT JOIN Employee E
ON D.DeptID = E.DeptID;
 
-- 12. SELF JOIN
-- Pairs of employees working in the same department
SELECT E1.EmpName AS Employee1,
       E2.EmpName AS Employee2,
       E1.DeptID
FROM Employee E1
JOIN Employee E2
ON E1.DeptID = E2.DeptID
AND E1.EmpID < E2.EmpID;
 
-- 13. THREE-WAY JOIN
-- Employee, department and project details
SELECT E.EmpName, D.DeptName, P.ProjectName
FROM Employee E
INNER JOIN Department D
ON E.DeptID = D.DeptID
INNER JOIN Project P
ON E.ProjectID = P.ProjectID;
 
-- 14. CORRELATED SUBQUERY
-- Employees earning more than their department average
SELECT E.EmpName, E.Salary, E.DeptID
FROM Employee E
WHERE E.Salary > (
    SELECT AVG(E2.Salary)
    FROM Employee E2
    WHERE E2.DeptID = E.DeptID
);
 
