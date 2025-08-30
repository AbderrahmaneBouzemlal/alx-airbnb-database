# Sample Data Insertion for AirBnB Database

In the seed.sql file four SQL `INSERT` statements to poppulate the AirBnB database tables with sample data. This data simulates real-world usage, including multiple users (hosts, guests, and an admin), properties, bookings, payments, reviews, and messages. Below is a structured overview of the inserted records, highlighting key entities and relationships. All UUIDs are hardcoded for simplicity, and timestamps/dates are set around August 31, 2025, for consistency.

## 1. **Users** (4 records inserted)
Users represent guests, hosts, and admins. Each has a unique email, hashed password, and role.

- **Host**: John Doe (user_id: 123e4567-e89b-12d3-a456-426614174000, email: john.doe@example.com, role: host)
- **Guest 1**: Jane Smith (user_id: 123e4567-e89b-12d3-a456-426614174001, email: jane.smith@example.com, role: guest)
- **Guest 2**: Alice Johnson (user_id: 123e4567-e89b-12d3-a456-426614174002, email: alice.johnson@example.com, role: guest)
- **Admin**: Bob Admin (user_id: 123e4567-e89b-12d3-a456-426614174003, email: bob.admin@example.com, role: admin)

All created around 10:00–10:15 on 2025-08-31.

## 2. **Properties** (2 records inserted)
Properties are hosted by John Doe (host_id: 123e4567-e89b-12d3-a456-426614174000).

- **Property 1**: Cozy Apartment (property_id: 223e4567-e89b-12d3-a456-426614174000, location: New York, NY, price per night: $100.00)
  - Description: A comfortable apartment in the city center.
- **Property 2**: Beach House (property_id: 223e4567-e89b-12d3-a456-426614174001, location: Miami, FL, price per night: $150.00)
  - Description: Spacious house with ocean view.

Both created around 11:00 on 2025-08-31.

## 3. **Bookings** (3 records inserted)
Bookings link guests to properties, capturing historical price per night (from property at booking time). Statuses include confirmed and pending. Assumes nights calculated as (end_date - start_date).

- **Booking 1**: Jane Smith books Cozy Apartment (booking_id: 323e4567-e89b-12d3-a456-426614174000)
  - Dates: 2025-09-01 to 2025-09-05 (4 nights, computed total: $400.00)
  - Price per night: $100.00, Status: confirmed
- **Booking 2**: Alice Johnson books Beach House (booking_id: 323e4567-e89b-12d3-a456-426614174001)
  - Dates: 2025-09-10 to 2025-09-12 (2 nights, computed total: $300.00)
  - Price per night: $150.00, Status: pending
- **Booking 3**: Alice Johnson books Cozy Apartment (booking_id: 323e4567-e89b-12d3-a456-426614174002)
  - Dates: 2025-09-15 to 2025-09-18 (3 nights, computed total: $300.00)
  - Price per night: $100.00, Status: confirmed

All created around 12:00 on 2025-08-31.

## 4. **Payments** (4 records inserted)
Payments demonstrate multiple (partial) payments for some bookings and single payments for others. Methods include credit_card, paypal, and stripe.

- **For Booking 1** (total $400.00):
  - Payment 1: $200.00 (payment_id: 423e4567-e89b-12d3-a456-426614174000, method: credit_card)
  - Payment 2: $200.00 (payment_id: 423e4567-e89b-12d3-a456-426614174001, method: paypal)
- **For Booking 2** (total $300.00):
  - Payment 1: $300.00 (payment_id: 423e4567-e89b-12d3-a456-426614174002, method: stripe)
- **For Booking 3** (total $300.00):
  - Payment 1: $300.00 (payment_id: 423e4567-e89b-12d3-a456-426614174003, method: credit_card)

All processed around 13:00 on 2025-08-31.

## 5. **Reviews** (2 records inserted)
Reviews are post-stay feedback for properties, with ratings (1-5) and comments.

- **Review 1**: By Jane Smith for Cozy Apartment (review_id: 523e4567-e89b-12d3-a456-426614174000)
  - Rating: 5, Comment: "Great stay, very comfortable!" (created: 2025-09-06)
- **Review 2**: By Alice Johnson for Cozy Apartment (review_id: 523e4567-e89b-12d3-a456-426614174001)
  - Rating: 4, Comment: "Nice location, but a bit noisy." (created: 2025-09-19)

## 6. **Messages** (3 records inserted)
Messages simulate communication between guests and hosts.

- **Message 1**: From Jane Smith to John Doe (message_id: 623e4567-e89b-12d3-a456-426614174000)
  - Body: "Is the apartment available for September?" (sent: 2025-08-30 15:00)
- **Message 2**: From John Doe to Jane Smith (message_id: 623e4567-e89b-12d3-a456-426614174001)
  - Body: "Yes, it is available." (sent: 2025-08-30 15:05)
- **Message 3**: From Alice Johnson to John Doe (message_id: 623e4567-e89b-12d3-a456-426614174002)
  - Body: "What amenities does the beach house have?" (sent: 2025-08-30 15:10)
