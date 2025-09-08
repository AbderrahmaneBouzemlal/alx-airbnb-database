Got it 👍 — let’s create a **clear markdown explanation** that you could save as `performance.md`.
This will document what’s happening, why the query was slow, and how we improved it.

---

# 📊 Query Performance Optimization

## 📝 Objective

Optimize a query that retrieves **bookings along with user, property, and payment details** by:

1. Writing the initial query.
2. Analyzing performance with `EXPLAIN`.
3. Refactoring and adding indexes.

---

## ⚡ Initial Query

```sql
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.payment_date
FROM booking b
JOIN user u ON b.user_id = u.user_id
JOIN property p ON b.property_id = p.property_id
LEFT JOIN payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;
```

### ❌ Problems

* **Unnecessary columns** increase I/O.
* **Filesort** for `ORDER BY b.created_at DESC` if no index exists.
* **Joins without supporting indexes** → full table scans.

---

## 🔍 Performance Analysis

Run:

```sql
EXPLAIN SELECT ...;
```

Before optimization, you might see:

* **type = ALL** → full table scans.
* **Extra = Using temporary; Using filesort** → expensive sort operation.
* Joins relying on scanning instead of index lookups.

---

## ✅ Refactored Query

```sql
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    pay.amount,
    pay.payment_method
FROM booking b
JOIN user u ON b.user_id = u.user_id
JOIN property p ON b.property_id = p.property_id
LEFT JOIN payment pay 
       ON pay.booking_id = b.booking_id
ORDER BY b.created_at DESC;
```

### Improvements

* **Fewer columns** → reduces data scanned.
* **Indexes on join/filter/sort columns** → speeds up lookups.

---

## 🗂 Recommended Indexes

```sql
-- Booking table
CREATE INDEX idx_booking_user_id ON booking(user_id);
CREATE INDEX idx_booking_property_id ON booking(property_id);
CREATE INDEX idx_booking_created_at ON booking(created_at);

-- Payment table
CREATE INDEX idx_payment_booking_id ON payment(booking_id);
```

---

## 🚀 Expected Results

After optimization:

* `EXPLAIN` should show **ref** or **const** joins instead of full scans.
* `ORDER BY b.created_at` should use `idx_booking_created_at` instead of filesort.
* Overall execution time significantly reduced.

---

## 📈 Verification

Use:

```sql
ANALYZE FORMAT=tree
SELECT ...
```

Before indexes:

```
-> Sort: b.created_at DESC
    -> Nested loop join
        -> Table scan on booking
        -> Table scan on user
        -> Table scan on property
        -> Table scan on payment
```

After indexes:

```
-> Sort: b.created_at DESC
    -> Nested loop join
        -> Index lookup on booking using idx_booking_created_at
        -> Index lookup on user (PK)
        -> Index lookup on property (PK)
        -> Index lookup on payment using idx_payment_booking_id
```

✅ Much fewer rows scanned, lower cost, faster response.

---

Would you like me to also add a **side-by-side comparison table** (before vs. after optimization) in the markdown to make it easier for presentations or reports?
