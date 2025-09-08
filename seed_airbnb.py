import uuid
import random
from faker import Faker
from datetime import datetime, timedelta
import mysql.connector

fake = Faker()

# ENUM values (must match MySQL schema)
USER_ROLES = ["guest", "host", "admin"]
BOOKING_STATUSES = ["pending", "confirmed", "canceled"]
PAYMENT_METHODS = ["credit_card", "paypal", "stripe"]

# Connect to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="abdou",
    password="Password123!@#",
    database="AirbnbAlx"
)
cursor = conn.cursor()

# Insert Users
def insert_users(n=20):
    users = []
    for _ in range(n):
        user = (
            str(uuid.uuid4()),
            fake.first_name(),
            fake.last_name(),
            fake.unique.email(),
            fake.sha256(),
            fake.phone_number() if random.random() > 0.2 else None,
            random.choice(USER_ROLES)
        )
        users.append(user)

    cursor.executemany("""
        INSERT INTO user (user_id, first_name, last_name, email, password_hash, phone_number, role)
        VALUES (%s,%s,%s,%s,%s,%s,%s)
    """, users)
    conn.commit()
    return users

# Insert Properties (only for hosts)
def insert_properties(hosts, n=10):
    properties = []
    for _ in range(n):
        prop = (
            str(uuid.uuid4()),
            random.choice(hosts)[0],  # host_id
            fake.catch_phrase(),
            fake.text(max_nb_chars=200),
            f"{fake.city()}, {fake.state_abbr()}",
            round(random.uniform(50, 500), 2)
        )
        properties.append(prop)

    cursor.executemany("""
        INSERT INTO property (property_id, host_id, name, description, location, pricepernight)
        VALUES (%s,%s,%s,%s,%s,%s)
    """, properties)
    conn.commit()
    return properties

# Insert Bookings
def insert_bookings(guests, properties, n=25):
    bookings = []
    for _ in range(n):
        start_date = fake.date_between(start_date="+1d", end_date="+30d")
        end_date = start_date + timedelta(days=random.randint(2, 7))
        price_per_night = round(random.uniform(50, 300), 2)
        booking = (
            str(uuid.uuid4()),
            random.choice(properties)[0],  # property_id
            random.choice(guests)[0],      # guest_id
            start_date,
            end_date,
            price_per_night,
            random.choice(BOOKING_STATUSES)
        )
        bookings.append(booking)

    cursor.executemany("""
        INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, price_per_night, status)
        VALUES (%s,%s,%s,%s,%s,%s,%s)
    """, bookings)
    conn.commit()
    return bookings

# Insert Payments (only for confirmed bookings)
def insert_payments(bookings):
    payments = []
    for b in bookings:
        if b[6] == "confirmed":  # status
            nights = (b[4] - b[3]).days
            total_amount = round(b[5] * nights, 2)
            payment = (
                str(uuid.uuid4()),
                b[0],  # booking_id
                total_amount,
                random.choice(PAYMENT_METHODS)
            )
            payments.append(payment)

    if payments:
        cursor.executemany("""
            INSERT INTO payment (payment_id, booking_id, amount, payment_method)
            VALUES (%s,%s,%s,%s)
        """, payments)
        conn.commit()
    return payments

# Insert Reviews (only after confirmed bookings)
def insert_reviews(bookings):
    reviews = []
    for b in bookings:
        if b[6] == "confirmed":
            review = (
                str(uuid.uuid4()),
                b[1],  # property_id
                b[2],  # user_id
                random.randint(1, 5),
                fake.sentence()
            )
            reviews.append(review)

    if reviews:
        cursor.executemany("""
            INSERT INTO review (review_id, property_id, user_id, rating, comment)
            VALUES (%s,%s,%s,%s,%s)
        """, reviews)
        conn.commit()
    return reviews

# Insert Messages (between random users)
def insert_messages(users, n=40):
    messages = []
    for _ in range(n):
        sender, recipient = random.sample(users, 2)
        message = (
            str(uuid.uuid4()),
            sender[0],
            recipient[0],
            fake.sentence(nb_words=12)
        )
        messages.append(message)

    cursor.executemany("""
        INSERT INTO message (message_id, sender_id, recipient_id, message_body)
        VALUES (%s,%s,%s,%s)
    """, messages)
    conn.commit()
    return messages


# ---- Run Generators ----
users = insert_users(20)
hosts = [u for u in users if u[6] == "host"]
guests = [u for u in users if u[6] == "guest"]

properties = insert_properties(hosts, 10)
bookings = insert_bookings(guests, properties, 25)
payments = insert_payments(bookings)
reviews = insert_reviews(bookings)
messages = insert_messages(users, 40)

print("✅ Sample data inserted into MySQL successfully!")

cursor.close()
conn.close()
