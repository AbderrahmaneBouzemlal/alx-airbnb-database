# 📌 Database Index Optimization Guide (MySQL)

## 1. Objective
Improve query performance by identifying high-usage columns in the `User`, `Property`, and `Booking` tables, creating appropriate indexes, and measuring performance improvements with `EXPLAIN` and `EXPLAIN ANALYZE`.

---

## 2. High-Usage Columns

### **User Table**
- `email` → already unique (auto-indexed).
- `role` → used in filters (e.g., `WHERE role = 'host'`).
- `created_at` → useful for sorting/filtering recent users.

### **Property Table**
- `host_id` → joins with `user`.
- `location` → often filtered in searches.
- `pricepernight` → used in range queries.
- `created_at` → for sorting recent properties.

### **Booking Table**
- `property_id` → joins with property.
- `user_id` → joins with user.
- `status` → often filtered (`confirmed`, `pending`, etc.).
- `start_date`, `end_date` → for availability searches.
- `created_at` → recent bookings.

---

## 3. Index Creation (`database_index.sql`)

```sql
-- ======================
-- User table indexes
-- ======================
CREATE INDEX idx_user_role ON user(role);
CREATE INDEX idx_user_created_at ON user(created_at);

-- ======================
-- Property table indexes
-- ======================
CREATE INDEX idx_property_host_id ON property(host_id);
CREATE INDEX idx_property_location ON property(location);
CREATE INDEX idx_property_price ON property(pricepernight);
CREATE INDEX idx_property_created_at ON property(created_at);

-- ======================
-- Booking table indexes
-- ======================
CREATE INDEX idx_booking_property_id ON booking(property_id);
CREATE INDEX idx_booking_user_id ON booking(user_id);
CREATE INDEX idx_booking_status ON booking(status);
CREATE INDEX idx_booking_start_end_date ON booking(start_date, end_date);
CREATE INDEX idx_booking_created_at ON booking(created_at);


```
## 4. Measuring Query Performance

```sql
EXPLAIN
SELECT * 
FROM booking b
JOIN property p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
  AND p.location = 'New York'
ORDER BY b.start_date DESC;
```

## using EXPLAIN ANALYZE MYSQL8


```sql
EXPLAIN ANALYZE
SELECT * 
FROM booking b
JOIN property p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
  AND p.location = 'New York'
ORDER BY b.start_date DESC;
```
```
| -> Sort: b.start_date DESC  (actual time=0.359..0.359 rows=0 loops=1)
    -> Stream results  (cost=1.24 rows=0.909) (actual time=0.325..0.325 rows=0 loops=1)
        -> Nested loop inner join  (cost=1.24 rows=0.909) (actual time=0.32..0.32 rows=0 loops=1)
            -> Index lookup on p using idx_property_location (location='New York')  (cost=0.35 rows=1) (actual time=0.0984..0.0984 rows=0 loops=1)
            -> Filter: (b.`status` = 'confirmed')  (cost=0.727 rows=0.909) (never executed)
                -> Index lookup on b using idx_booking_property_id (property_id=p.property_id)  (cost=0.727 rows=2.55) (never executed)
|
```
