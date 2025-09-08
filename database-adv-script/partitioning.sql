-- =============================================
-- Step 1: Backup existing Booking table
-- =============================================
CREATE TABLE booking_backup AS 
SELECT * FROM booking;

-- =============================================
-- Step 2: Drop original Booking table
-- (⚠️ only if safe; otherwise rename instead)
-- =============================================
DROP TABLE booking;

-- =============================================
-- Step 3: Recreate Booking table with PARTITIONING
-- Partitioning by RANGE on start_date
-- =============================================
CREATE TABLE booking (
    booking_id VARCHAR(36) NOT NULL PRIMARY KEY,
    property_id VARCHAR(36),
    user_id VARCHAR(36),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    status ENUM('pending','confirmed','canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY idx_booking_property_id (property_id),
    KEY idx_booking_user_id (user_id),
    KEY idx_booking_status (status)
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);

-- =============================================
-- Step 4: Reload data into partitioned table
-- =============================================
INSERT INTO booking 
SELECT * FROM booking_backup;

-- =============================================
-- Step 5: Example query before/after partitioning
-- =============================================
EXPLAIN ANALYZE
SELECT *
FROM booking
WHERE start_date BETWEEN '2025-01-01' AND '2025-03-31';
