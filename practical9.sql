
-- EXPERIMENT 9: RAILWAY BOOKING AND INDEXING

-- STEP 1: REMOVE OLD TABLE

DROP TABLE IF EXISTS Railway_Booking;

-- STEP 2: CREATE RAILWAY BOOKING TABLE

CREATE TABLE Railway_Booking (
    BookingID INT PRIMARY KEY,
    PassengerName VARCHAR(50),
    TrainNumber INT,
    SourceStation VARCHAR(50),
    DestinationStation VARCHAR(50),
    TravelDate DATE,
    SeatNumber INT,
    Fare DECIMAL(10,2),
    BookingStatus VARCHAR(20)
);

-- STEP 3: INSERT 5000 RECORDS

INSERT INTO Railway_Booking
SELECT
    n + 1,
    CONCAT('Passenger_', n + 1),
    10000 + (n % 100),

    CASE
        WHEN n % 4 = 0 THEN 'Delhi'
        WHEN n % 4 = 1 THEN 'Mumbai'
        WHEN n % 4 = 2 THEN 'Pune'
        ELSE 'Lucknow'
    END,

    CASE
        WHEN n % 4 = 0 THEN 'Jaipur'
        WHEN n % 4 = 1 THEN 'Delhi'
        WHEN n % 4 = 2 THEN 'Lucknow'
        ELSE 'Mumbai'
    END,

    DATE_ADD('2026-01-01', INTERVAL (n % 365) DAY),

    (n % 100) + 1,
    500 + (n % 20) * 100,

    CASE
        WHEN n % 3 = 0 THEN 'Confirmed'
        WHEN n % 3 = 1 THEN 'Waiting'
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
WHERE n < 5000;

-- STEP 4: VERIFY RECORD COUNT

SELECT COUNT(*) AS Total_Bookings
FROM Railway_Booking;

-- STEP 5: QUERY BEFORE INDEXING

SELECT *
FROM Railway_Booking
WHERE TrainNumber = 10025;

EXPLAIN
SELECT *
FROM Railway_Booking
WHERE TrainNumber = 10025;

-- STEP 6: CREATE SINGLE COLUMN INDEX

CREATE INDEX idx_train
ON Railway_Booking(TrainNumber);

-- QUERY AFTER SINGLE INDEX

EXPLAIN
SELECT *
FROM Railway_Booking
WHERE TrainNumber = 10025;

SELECT *
FROM Railway_Booking
WHERE TrainNumber = 10025;

-- STEP 7: CREATE COMPOSITE INDEX

CREATE INDEX idx_route_date
ON Railway_Booking(
    SourceStation,
    DestinationStation,
    TravelDate
);

-- QUERY AFTER COMPOSITE INDEX

EXPLAIN
SELECT *
FROM Railway_Booking
WHERE SourceStation = 'Delhi'
AND DestinationStation = 'Jaipur'
AND TravelDate = '2026-01-01';

SELECT *
FROM Railway_Booking
WHERE SourceStation = 'Delhi'
AND DestinationStation = 'Jaipur'
AND TravelDate = '2026-01-01';

-- STEP 8: DISPLAY ALL INDEXES

SHOW INDEX FROM Railway_Booking;

-- STEP 9: DISPLAY SAMPLE RECORDS

SELECT * FROM Railway_Booking
LIMIT 10;
