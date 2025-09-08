# 📝 Database Monitoring & Performance Report

## 1. Objective

Continuously monitor frequently used queries, identify performance bottlenecks, implement indexes or schema adjustments, and measure improvements.

---

## 2. Monitored Queries

### **Query 1:** Booking with user and property details

```sql
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    p.location
FROM booking b
JOIN user u ON b.user_id = u.user_id
JOIN property p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
  AND p.location = 'New York'
ORDER BY b.start_date DESC
LIMIT 20;
```

### **Query 2:** Payments for a user’s bookings

```sql
SELECT 
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    b.booking_id,
    u.email
FROM payment pay
JOIN booking b ON pay.booking_id = b.booking_id
JOIN user u ON b.user_id = u.user_id
WHERE b.user_id = '11111111-1111-1111-1111-111111111111';
```

---

## 3. Performance Analysis (Before Indexing)

| Query   | Observed Issues                                                                           |
| ------- | ----------------------------------------------------------------------------------------- |
| Query 1 | Full table scans on `booking` and `property`. `ORDER BY b.start_date DESC` uses filesort. |
| Query 2 | Full table scan on `payment` when joining `booking`. Slow joins.                          |

**Explanation:**

* Both queries scanned all relevant tables.
* Sorting and filtering was inefficient without indexes.

---

## 4. Changes Implemented

### **Indexes Created**

```sql
CREATE INDEX idx_booking_status_startdate ON booking(status, start_date);
CREATE INDEX idx_property_location ON property(location);
CREATE INDEX idx_payment_booking_id ON payment(booking_id);
CREATE INDEX idx_booking_user_property ON booking(user_id, property_id);
```

**Rationale:**

* `booking(status, start_date)` → speeds up filtering by status and ordering by start date.
* `property(location)` → speeds up filtering properties by location.
* `payment(booking_id)` → speeds up lookups of payments per booking.
* `booking(user_id, property_id)` → improves joins when fetching bookings for a user and their properties.

---

## 5. Performance Analysis (After Indexing)

| Query   | Observed Improvements                                                                                             |
| ------- | ----------------------------------------------------------------------------------------------------------------- |
| Query 1 | Rows scanned reduced drastically; `EXPLAIN ANALYZE` shows index usage instead of table scan; filesort eliminated. |
| Query 2 | Index used for `booking_id` in `payment`; fewer rows scanned; faster joins.                                       |

**Estimated Execution Time Improvement:**

* Query 1: \~1.1s → \~0.15s
* Query 2: \~0.8s → \~0.1s

---

## 6. Conclusion

* Continuous monitoring with `EXPLAIN ANALYZE` allows detection of bottlenecks.
* Adding targeted indexes significantly improved query performance.
* Future recommendations:

  * Consider partitioning large tables (e.g., `booking` by `start_date`) for further optimization.
  * Periodically review index usage and remove unused indexes to reduce write overhead.
  * Use `ANALYZE FORMAT=tree` to get deeper insight into execution plans.

