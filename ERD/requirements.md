

## 🗃️ Database Design

<img style="color: white" width="1621" height="1051" alt="Untitled Diagram" src="https://github.com/user-attachments/assets/74fdd21f-37b4-4aa8-ba3c-2d40b04019ce" />


The database schema supports all core Airbnb-like features, including user management, property listings, bookings, payments, and reviews. Below are the key entities, their fields, and how they relate to one another.

### 🧑 User

Represents both guests and hosts on the platform.

**Key Fields:**

* `user_id`: Primary Key, UUID, Indexed
* `first_name`: VARCHAR, NOT NULL
* `last_name`: VARCHAR, NOT NULL
* `email`: VARCHAR, UNIQUE, NOT NULL
* `password_hash`: VARCHAR, NOT NULL
* `role`: ENUM (guest, host, admin), NOT NULL
* `phone_number`: VARCHAR, NULL
* `created_at`: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

**Relationships:**

* A user **can create** multiple properties (if a host).
* A user **can make** multiple bookings (if a guest).
* A user **can leave** multiple reviews.

---

### 🏘️ Property

Represents accommodations listed by hosts.

**Key Fields:**

* property_id: Primary Key, UUID, Indexed
* host_id: Foreign Key, references User(user_id)
* name: VARCHAR, NOT NULL
* description: TEXT, NOT NULL
* location: VARCHAR, NOT NULL
* pricepernight: DECIMAL, NOT NULL
* created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
* updated_at: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

**Relationships:**

* A property **belongs to** one host.
* A property **can have** multiple bookings.
* A property **can receive** multiple reviews.

---

### 📅 Bookings

Handles reservation information for guests.

**Key Fields:**

* booking_id: Primary Key, UUID, Indexed
* property_id: Foreign Key, references Property(property_id)
* user_id: Foreign Key, references User(user_id)
* start_date: DATE, NOT NULL
* end_date: DATE, NOT NULL
* total_price: DECIMAL, NOT NULL
* status: ENUM (pending, confirmed, canceled), NOT NULL
* created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

**Relationships:**

* A booking **is made by** one user (guest).
* A booking **is linked to** one property.
* A booking **can be linked to** one payment.

---

### 💳 Payments

Tracks financial transactions related to bookings.

**Key Fields:**

* payment_id: Primary Key, UUID, Indexed
* booking_id: Foreign Key, references Booking(booking_id)
* amount: DECIMAL, NOT NULL
* payment_date: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
* payment_method: ENUM (credit_card, paypal, stripe), NOT NULL


**Relationships:**

* A payment **belongs to** one booking.

---

### ⭐ Reviews

Allows users to provide feedback on properties.

**Key Fields:**


* review_id: Primary Key, UUID, Indexed
* property_id: Foreign Key, references Property(property_id)
* user_id: Foreign Key, references User(user_id)
* rating: INTEGER, CHECK: rating >= 1 AND rating <= 5, NOT NULL
*  comment: TEXT, NOT NULL
* created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP


**Relationships:**

* A review **is written by** one user.
* A review **is about** one property.

### 💬 Message

* message_id: Primary Key, UUID, Indexed
* sender_id: Foreign Key, references User(user_id)
* recipient_id: Foreign Key, references User(user_id)
* message_body: TEXT, NOT NULL
* sent_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

**Relationships:**

* A message **is written by** one user.
* A user **can have many** many messages

