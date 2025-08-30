-- Assume the 'uuid-ossp' extension is installed for uuid_generate_v4().
-- For simplicity, I'll use hardcoded UUIDs as strings.

-- Insert Users
INSERT INTO "user" (user_id The task is to write SQL INSERT statements to add sample data for the AirBnB database tables: User, Property, Booking, etc.

The schema is the updated one from the previous message, in 3NF.

Tables:

- User: user_id (UUID PK), first_name, last_name, email (unique), password_hash, phone_number (null), role (enum: guest, host, admin), created_at (timestamp default)

- Property: property_id (UUID PK), host_id (FK User), name, description, location, pricepernight (decimal), created_at, updated_at

- Booking: booking_id (UUID PK), property_id (FK), user_id (FK), start_date (date), end_date (date), price_per_night (decimal), status (enum), created_at

- Payment: payment_id (UUID PK), booking_id (FK), amount (decimal), payment_date (timestamp default), payment_method (enum)

- Review: review_id (UUID PK), property_id (FK), user_id (FK), rating (int 1-5), comment, created_at

- Message: message_id (UUID PK), sender_id (FK), recipient_id (FK), message_body, sent_at

I need to insert sample data that reflects real-world usage: multiple users, bookings, payments.

Since user_id, etc., are UUIDs, I need to generate sample UUIDs. In SQL, I can use uuid_generate_v4() but since this is PostgreSQL (from the schema, it uses CREATE TYPE, etc.), I'll assume we have uuid-ossp extension or just hardcode UUID strings.

The schema uses UUID, so I'll hardcode some UUID values for simplicity.

Plan sample data:

- Users: A few guests, hosts, maybe an admin.

  - Host1: John Doe, host

  - Guest1: Jane Smith, guest

  - Guest2: Alice Johnson, guest

  - Admin: Bob Admin, admin

- Properties: Owned by hosts.

  - Property1: Cozy Apartment, by Host1, location NYC, price 100/night

  - Property2: Beach House, by Host1, location Miami, price 150/night

- Bookings: By guests for properties.

  - Booking1: Guest1 books Property1 from 2025-09-01 to 2025-09-05, price_per_night 100, status confirmed

  - Booking2: Guest2 books Property2 from 2025-09-10 to 2025-09-12, price_per_night 150, status pending

- Payments: For bookings.

  - Payment for Booking1: amount 400 (4 nights *100), credit_card

  - Maybe partial payment for Booking2

In the updated schema, Booking has price_per_night, but no total_price stored. Payments have amount.

For real-world, a booking might have one or more payments.

- Reviews: After bookings.

  - Review by Guest1 for Property1: rating 5, comment great

- Messages: Between users.

  - Message from Guest1 to Host1: Inquiry about Property1

Current date is August 31, 2025, so dates in future or past accordingly.

I need to ensure FKs match.

Hardcode UUIDs like '123e4567-e89b-12d3-a456-426614174000' etc.

I need to insert in order: Users first, then Properties (need host_id), then Bookings (need property_id, user_id), then Payments (need booking_id), Reviews, Messages.

Password_hash: just some string like 'hashedpass'

Emails unique.

No tools needed here, as it's just writing SQL based on schema.

The question is to write SQL INSERT statements.

Output should be the SQL code.```sql
-- Insert sample Users
INSERT INTO "user" (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES 
    ('123e4567-e89b-12d3-a456-426614174000', 'John', 'Doe', 'john.doe@example.com', 'hashedpass1', '123-456-7890', 'host', '2025-08-31 10:00:00'),
    ('123e4567-e89b-12d3-a456-426614174001', 'Jane', 'Smith', 'jane.smith@example.com', 'hashedpass2', '987-654-3210', 'guest', '2025-08-31 10:05:00'),
    ('123e4567-e89b-12d3-a456-426614174002', 'Alice', 'Johnson', 'alice.johnson@example.com', 'hashedpass3', NULL, 'guest', '2025-08-31 10:10:00'),
    ('123e4567-e89b-12d3-a456-426614174003', 'Bob', 'Admin', 'bob.admin@example.com', 'hashedpass4', '555-555-5555', 'admin', '2025-08-31 10:15:00');

-- Insert sample Properties (hosted by John Doe)
INSERT INTO property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at)
VALUES 
    ('223e4567-e89b-12d3-a456-426614174000', '123e4567-e89b-12d3-a456-426614174000', 'Cozy Apartment', 'A comfortable apartment in the city center.', 'New York, NY', 100.00, '2025-08-31 11:00:00', '2025-08-31 11:00:00'),
    ('223e4567-e89b-12d3-a456-426614174001', '123e4567-e89b-12d3-a456-426614174000', 'Beach House', 'Spacious house with ocean view.', 'Miami, FL', 150.00, '2025-08-31 11:05:00', '2025-08-31 11:05:00');

-- Insert sample Bookings
INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, price_per_night, status, created_at)
VALUES 
    ('323e4567-e89b-12d3-a456-426614174000', '223e4567-e89b-12d3-a456-426614174000', '123e4567-e89b-12d3-a456-426614174001', '2025-09-01', '2025-09-05', 100.00, 'confirmed', '2025-08-31 12:00:00'),
    ('323e4567-e89b-12d3-a456-426614174001', '223e4567-e89b-12d3-a456-426614174001', '123e4567-e89b-12d3-a456-426614174002', '2025-09-10', '2025-09-12', 150.00, 'pending', '2025-08-31 12:05:00'),
    ('323e4567-e89b-12d3-a456-426614174002', '223e4567-e89b-12d3-a456-426614174000', '123e4567-e89b-12d3-a456-426614174002', '2025-09-15', '2025-09-18', 100.00, 'confirmed', '2025-08-31 12:10:00');

-- Insert sample Payments (multiple for one booking to show partial payments)
INSERT INTO payment (payment_id, booking_id, amount, payment_date, payment_method)
VALUES 
    ('423e4567-e89b-12d3-a456-426614174000', '323e4567-e89b-12d3-a456-426614174000', 200.00, '2025-08-31 13:00:00', 'credit_card'),
    ('423e4567-e89b-12d3-a456-426614174001', '323e4567-e89b-12d3-a456-426614174000', 200.00, '2025-08-31 13:05:00', 'paypal'),
    ('423e4567-e89b-12d3-a456-426614174002', '323e4567-e89b-12d3-a456-426614174001', 300.00, '2025-08-31 13:10:00', 'stripe'),
    ('423e4567-e89b-12d3-a456-426614174003', '323e4567-e89b-12d3-a456-426614174002', 300.00, '2025-08-31 13:15:00', 'credit_card');

-- Insert sample Reviews
INSERT INTO review (review_id, property_id, user_id, rating, comment, created_at)
VALUES 
    ('523e4567-e89b-12d3-a456-426614174000', '223e4567-e89b-12d3-a456-426614174000', '123e4567-e89b-12d3-a456-426614174001', 5, 'Great stay, very comfortable!', '2025-09-06 14:00:00'),
    ('523e4567-e89b-12d3-a456-426614174001', '223e4567-e89b-12d3-a456-426614174000', '123e4567-e89b-12d3-a456-426614174002', 4, 'Nice location, but a bit noisy.', '2025-09-19 14:05:00');

-- Insert sample Messages
INSERT INTO message (message_id, sender_id, recipient_id, message_body, sent_at)
VALUES 
    ('623e4567-e89b-12d3-a456-426614174000', '123e4567-e89b-12d3-a456-426614174001', '123e4567-e89b-12d3-a456-426614174000', 'Is the apartment available for September?', '2025-08-30 15:00:00'),
    ('623e4567-e89b-12d3-a456-426614174001', '123e4567-e89b-12d3-a456-426614174000', '123e4567-e89b-12d3-a456-426614174001', 'Yes, it is available.', '2025-08-30 15:05:00'),
    ('623e4567-e89b-12d3-a456-426614174002', '123e4567-e89b-12d3-a456-426614174002', '123e4567-e89b-12d3-a456-426614174000', 'What amenities does the beach house have?', '2025-08-30 15:10:00');
