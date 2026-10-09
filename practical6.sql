-- EXPERIMENT 6
-- STORED PROCEDURE AND TRIGGERS

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
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- Create Salary Audit Table
CREATE TABLE salary_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Department Data
INSERT INTO department VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');

-- Insert Employee Data
INSERT INTO employee VALUES
(101, 'Rahul', 60000, 1),
(102, 'Aman', 45000, 1),
(103, 'Priya', 50000, 2);


-- Salary Validation Trigger
DELIMITER //

CREATE TRIGGER salary_validation_trigger
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END //

DELIMITER ;


-- Salary Validation Trigger for UPDATE
DELIMITER //

CREATE TRIGGER salary_update_validation_trigger
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END //

DELIMITER ;


-- Salary Audit Trigger
DELIMITER //

CREATE TRIGGER salary_audit_trigger
AFTER UPDATE ON employee
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_audit
        (emp_id, old_salary, new_salary)
        VALUES
        (OLD.emp_id, OLD.salary, NEW.salary);
    END IF;
END //

DELIMITER ;


-- Stored Procedure for Employee Transfer
DELIMITER //

CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE emp_exists INT DEFAULT 0;
    DECLARE dept_exists INT DEFAULT 0;

    -- Check whether employee exists
    SELECT COUNT(*)
    INTO emp_exists
    FROM employee
    WHERE emp_id = p_emp_id;

    IF emp_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist';

    ELSE

        -- Check whether department exists
        SELECT COUNT(*)
        INTO dept_exists
        FROM department
        WHERE dept_id = p_new_dept_id;

        IF dept_exists = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Department does not exist';

        ELSE

            -- Transfer employee
            UPDATE employee
            SET dept_id = p_new_dept_id
            WHERE emp_id = p_emp_id;

        END IF;
    END IF;
END //

DELIMITER ;


-- Test Salary Validation
UPDATE employee
SET salary = 48000
WHERE emp_id = 102;

-- Display Salary Audit
SELECT * FROM salary_audit;


-- Display Employee Before Transfer
SELECT * FROM employee
WHERE emp_id = 102;

-- Transfer Employee 102 from IT to HR
CALL transfer_employee(102, 2);

-- Display Employee After Transfer
SELECT * FROM employee
WHERE emp_id = 102;


-- Test Invalid Employee
CALL transfer_employee(999, 2);


-- Test Invalid Department
CALL transfer_employee(102, 99);


-- Test Invalid Salary
UPDATE employee
SET salary = -5000
WHERE emp_id = 102;