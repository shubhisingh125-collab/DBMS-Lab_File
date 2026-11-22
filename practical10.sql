
-- EXPERIMENT 10: QUERY OPTIMIZATION

-- STEP 1: REMOVE OLD TABLE

DROP TABLE IF EXISTS Sales_10K;

-- STEP 2: CREATE SALES TABLE

CREATE TABLE Sales_10K (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(50),
    ProductID INT,
    OrderDate DATE,
    Quantity INT,
    Amount DECIMAL(10,2),
    Status VARCHAR(20)
);

-- STEP 3: INSERT 10000 RECORDS

INSERT INTO Sales_10K
SELECT
    n + 1,
    (n % 500) + 1,
    CONCAT('Customer_', (n % 500) + 1),
    (n % 100) + 1,

    DATE_ADD('2025-01-01', INTERVAL (n % 1095) DAY),

    (n % 10) + 1,
    ((n % 10) + 1) * 500,

    CASE
        WHEN n % 3 = 0 THEN 'Completed'
        WHEN n % 3 = 1 THEN 'Pending'
        ELSE 'Cancelled'
    END

FROM (
    SELECT
        a.d + b.d * 10 + c.d * 100
        + d.d * 1000 + e.d * 10000 AS n

    FROM
        (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2
         UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6
         UNION ALL SELECT 7 UNION ALL SELECT 8
         UNION ALL SELECT 9) a

    CROSS JOIN
        (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2
         UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6
         UNION ALL SELECT 7 UNION ALL SELECT 8
         UNION ALL SELECT 9) b

    CROSS JOIN
        (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2
         UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6
         UNION ALL SELECT 7 UNION ALL SELECT 8
         UNION ALL SELECT 9) c

    CROSS JOIN
        (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2
         UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6
         UNION ALL SELECT 7 UNION ALL SELECT 8
         UNION ALL SELECT 9) d

    CROSS JOIN
        (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2
         UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6
         UNION ALL SELECT 7 UNION ALL SELECT 8
         UNION ALL SELECT 9) e

) numbers
WHERE n < 10000;

-- STEP 4: VERIFY DATASET

SELECT COUNT(*) AS Total_Records
FROM Sales_10K;

-- ==================================
-- FIVE SLOW QUERIES BEFORE OPTIMIZATION
-- ==================================

-- SLOW QUERY 1: FUNCTION ON DATE COLUMN

EXPLAIN
SELECT *
FROM Sales_10K
WHERE YEAR(OrderDate) = 2025;

SELECT *
FROM Sales_10K
WHERE YEAR(OrderDate) = 2025;

-- SLOW QUERY 2: FUNCTION ON CUSTOMER NAME

EXPLAIN
SELECT *
FROM Sales_10K
WHERE UPPER(CustomerName) = 'CUSTOMER_25';

SELECT *
FROM Sales_10K
WHERE UPPER(CustomerName) = 'CUSTOMER_25';

-- SLOW QUERY 3: FILTERING WITHOUT INDEX

EXPLAIN
SELECT *
FROM Sales_10K
WHERE Status = 'Pending'
AND OrderDate = '2025-03-01';

SELECT *
FROM Sales_10K
WHERE Status = 'Pending'
AND OrderDate = '2025-03-01';

-- SLOW QUERY 4: CORRELATED SUBQUERY

EXPLAIN
SELECT CustomerID, CustomerName, Amount
FROM Sales_10K S
WHERE Amount > (
    SELECT AVG(Amount)
    FROM Sales_10K
    WHERE CustomerID = S.CustomerID
);

SELECT CustomerID, CustomerName, Amount
FROM Sales_10K S
WHERE Amount > (
    SELECT AVG(Amount)
    FROM Sales_10K
    WHERE CustomerID = S.CustomerID
);

-- SLOW QUERY 5: OR CONDITION

EXPLAIN
SELECT *
FROM Sales_10K
WHERE ProductID = 10
OR Status = 'Pending';

SELECT *
FROM Sales_10K
WHERE ProductID = 10
OR Status = 'Pending';

-- ==================================
-- STEP 5: CREATE INDEXES
-- ==================================

CREATE INDEX idx_orderdate
ON Sales_10K(OrderDate);

CREATE INDEX idx_customer
ON Sales_10K(CustomerName);

CREATE INDEX idx_status_date
ON Sales_10K(Status, OrderDate);

CREATE INDEX idx_customer_amount
ON Sales_10K(CustomerID, Amount);

CREATE INDEX idx_product
ON Sales_10K(ProductID);

-- ==================================
-- STEP 6: OPTIMIZED QUERIES
-- ==================================

-- OPTIMIZED QUERY 1
-- Replace YEAR() with date range

EXPLAIN
SELECT *
FROM Sales_10K
WHERE OrderDate >= '2025-01-01'
AND OrderDate < '2026-01-01';

SELECT *
FROM Sales_10K
WHERE OrderDate >= '2025-01-01'
AND OrderDate < '2026-01-01';

-- OPTIMIZED QUERY 2
-- Avoid UPPER() function

EXPLAIN
SELECT *
FROM Sales_10K
WHERE CustomerName = 'Customer_25';

SELECT *
FROM Sales_10K
WHERE CustomerName = 'Customer_25';

-- OPTIMIZED QUERY 3
-- Use composite index

EXPLAIN
SELECT *
FROM Sales_10K
WHERE Status = 'Pending'
AND OrderDate = '2025-03-01';

SELECT *
FROM Sales_10K
WHERE Status = 'Pending'
AND OrderDate = '2025-03-01';

-- OPTIMIZED QUERY 4
-- Replace correlated subquery with JOIN

EXPLAIN
SELECT S.CustomerID, S.CustomerName, S.Amount
FROM Sales_10K S
JOIN (
    SELECT CustomerID, AVG(Amount) AS AvgAmount
    FROM Sales_10K
    GROUP BY CustomerID
) A
ON S.CustomerID = A.CustomerID
WHERE S.Amount > A.AvgAmount;

SELECT S.CustomerID, S.CustomerName, S.Amount
FROM Sales_10K S
JOIN (
    SELECT CustomerID, AVG(Amount) AS AvgAmount
    FROM Sales_10K
    GROUP BY CustomerID
) A
ON S.CustomerID = A.CustomerID
WHERE S.Amount > A.AvgAmount;

-- OPTIMIZED QUERY 5
-- Replace OR with UNION

EXPLAIN
SELECT *
FROM Sales_10K
WHERE ProductID = 10

UNION

SELECT *
FROM Sales_10K
WHERE Status = 'Pending';

SELECT *
FROM Sales_10K
WHERE ProductID = 10

UNION

SELECT *
FROM Sales_10K
WHERE Status = 'Pending';

-- ==================================
-- STEP 7: DISPLAY INDEXES
-- ==================================

SHOW INDEX FROM Sales_10K;

-- STEP 8: DISPLAY SAMPLE RECORDS

SELECT * FROM Sales_10K
LIMIT 10;
