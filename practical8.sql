
-- EXPERIMENT 8: BANKING TRANSACTIONS

-- Remove previous table

DROP TABLE IF EXISTS Accounts;

-- STEP 1: CREATE ACCOUNT TABLE

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    AccountHolder VARCHAR(50),
    Balance DECIMAL(12,2)
) ENGINE=InnoDB;

-- INSERT SAMPLE RECORDS

INSERT INTO Accounts VALUES
(101, 'Rahul', 10000),
(102, 'Priya', 15000),
(103, 'Aman', 20000);

-- DISPLAY INITIAL BALANCES

SELECT * FROM Accounts;

-- STEP 2: BEGIN AND COMMIT
-- Transfer Rs. 2000 from Rahul to Priya

START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 2000
WHERE AccountID = 101;

UPDATE Accounts
SET Balance = Balance + 2000
WHERE AccountID = 102;

COMMIT;

SELECT * FROM Accounts;

-- STEP 3: ROLLBACK
-- Transfer Rs. 5000 and cancel transaction

START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 5000
WHERE AccountID = 101;

UPDATE Accounts
SET Balance = Balance + 5000
WHERE AccountID = 103;

ROLLBACK;

-- Changes are cancelled

SELECT * FROM Accounts;

-- STEP 4: SAVEPOINT
-- Demonstrate partial rollback

START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 1000
WHERE AccountID = 101;

SAVEPOINT SP1;

UPDATE Accounts
SET Balance = Balance + 1000
WHERE AccountID = 102;

-- Rollback only changes after savepoint

ROLLBACK TO SAVEPOINT SP1;

COMMIT;

SELECT * FROM Accounts;

-- STEP 5: ISOLATION LEVELS

-- READ UNCOMMITTED

SET SESSION TRANSACTION ISOLATION LEVEL
READ UNCOMMITTED;

START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- READ COMMITTED

SET SESSION TRANSACTION ISOLATION LEVEL
READ COMMITTED;

START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- REPEATABLE READ

SET SESSION TRANSACTION ISOLATION LEVEL
REPEATABLE READ;

START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- SERIALIZABLE

SET SESSION TRANSACTION ISOLATION LEVEL
SERIALIZABLE;

START TRANSACTION;
SELECT * FROM Accounts;
COMMIT;

-- STEP 6: FINAL BALANCE

SELECT * FROM Accounts;

-- STEP 7: CHECK TOTAL BANK BALANCE

SELECT SUM(Balance) AS Total_Bank_Balance
FROM Accounts;
