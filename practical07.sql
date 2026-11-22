
-- STEP 1: DENORMALIZED SALES TABLE (UNF)

DROP TABLE IF EXISTS Sales_UNF;

CREATE TABLE Sales_UNF (
    OrderID INT,
    CustomerID INT,
    CustomerName VARCHAR(50),
    CustomerCity VARCHAR(50),
    ProductID INT,
    ProductName VARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    PRIMARY KEY (OrderID, ProductID)
);

INSERT INTO Sales_UNF VALUES
(101, 1, 'Rahul', 'Delhi', 201, 'Laptop', 1, 50000),
(101, 1, 'Rahul', 'Delhi', 202, 'Mouse', 2, 500),
(102, 2, 'Priya', 'Mumbai', 201, 'Laptop', 1, 50000),
(103, 3, 'Aman', 'Pune', 203, 'Keyboard', 1, 1500),
(104, 2, 'Priya', 'Mumbai', 202, 'Mouse', 3, 500);

SELECT * FROM Sales_UNF;

-- FUNCTIONAL DEPENDENCIES:
-- OrderID -> CustomerID
-- CustomerID -> CustomerName, CustomerCity
-- ProductID -> ProductName, UnitPrice
-- (OrderID, ProductID) -> Quantity

-- STEP 2: FIRST NORMAL FORM (1NF)
-- All values are atomic.

-- STEP 3: SECOND NORMAL FORM (2NF)
-- Remove partial dependencies.

DROP TABLE IF EXISTS Order_2NF;
CREATE TABLE Order_2NF (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(50),
    CustomerCity VARCHAR(50)
);

INSERT INTO Order_2NF
SELECT DISTINCT OrderID, CustomerID,
       CustomerName, CustomerCity
FROM Sales_UNF;

DROP TABLE IF EXISTS Product_2NF;
CREATE TABLE Product_2NF (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

INSERT INTO Product_2NF
SELECT DISTINCT ProductID, ProductName, UnitPrice
FROM Sales_UNF;

DROP TABLE IF EXISTS OrderDetails_2NF;
CREATE TABLE OrderDetails_2NF (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);

INSERT INTO OrderDetails_2NF
SELECT OrderID, ProductID, Quantity
FROM Sales_UNF;

-- STEP 4: THIRD NORMAL FORM (3NF)
-- Remove transitive dependency:
-- OrderID -> CustomerID -> CustomerName, CustomerCity

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    CustomerCity VARCHAR(50)
);

INSERT INTO Customers
SELECT DISTINCT CustomerID, CustomerName, CustomerCity
FROM Sales_UNF;

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders
SELECT DISTINCT OrderID, CustomerID
FROM Sales_UNF;

DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

INSERT INTO Products
SELECT DISTINCT ProductID, ProductName, UnitPrice
FROM Sales_UNF;

DROP TABLE IF EXISTS OrderDetails;
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO OrderDetails
SELECT OrderID, ProductID, Quantity
FROM Sales_UNF;

-- DISPLAY NORMALIZED TABLES

SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Products;
SELECT * FROM OrderDetails;

-- STEP 5: VERIFY LOSSLESS JOIN

SELECT O.OrderID, C.CustomerName,
       P.ProductName, OD.Quantity, P.UnitPrice
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID;

-- STEP 6: VERIFY DEPENDENCY PRESERVATION

-- CustomerID determines customer details
SELECT CustomerID, COUNT(DISTINCT CustomerName),
       COUNT(DISTINCT CustomerCity)
FROM Customers
GROUP BY CustomerID;

-- ProductID determines product details
SELECT ProductID, COUNT(DISTINCT ProductName),
       COUNT(DISTINCT UnitPrice)
FROM Products
GROUP BY ProductID;

-- OrderID determines CustomerID
SELECT OrderID, COUNT(DISTINCT CustomerID)
FROM Orders
GROUP BY OrderID;

-- STEP 7: CHECK BCNF
-- Every determinant in the final decomposition
-- is a candidate key of its respective relation.
-- Customers: CustomerID
-- Orders: OrderID
-- Products: ProductID
-- OrderDetails: (OrderID, ProductID)

SELECT 'BCNF decomposition verified' AS Result;
