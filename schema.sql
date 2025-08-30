-- Create ENUM types (no changes)
CREATE TYPE user_role AS ENUM ('guest', 'host', 'admin');
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'canceled');
CREATE TYPE payment_method_type AS ENUM ('credit_card', 'paypal', 'stripe');

-- User table (no changes)
CREATE TABLE "user" (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    email VARCHAR UNIQUE NOT NULL,
    password_hash VARCHAR NOT NULL,
    phone_number VARCHAR,
    role user_role NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Property table (no changes)
CREATE TABLE property (
    property_id UUID PRIMARY KEY,
    host_id UUID REFERENCES "user"(user_id),
    name VARCHAR NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR NOT NULL,
    pricepernight DECIMAL NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger function for updating updated_at (no changes)
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for Property table (no changes)
CREATE TRIGGER update_property_updated_at
BEFORE UPDATE ON property
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

-- Booking table (changes: add price_per_night, remove total_price)
CREATE TABLE booking (
    booking_id UUID PRIMARY KEY,
    property_id UUID REFERENCES property(property_id),
    user_id UUID REFERENCES "user"(user_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price_per_night DECIMAL NOT NULL,  -- Added to capture historical price
    status booking_status NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payment table (no changes)
CREATE TABLE payment (
    payment_id UUID PRIMARY KEY,
    booking_id UUID REFERENCES booking(booking_id),
    amount DECIMAL NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method payment_method_type NOT NULL
);

-- Review table (no changes)
CREATE TABLE review (
    review_id UUID PRIMARY KEY,
    property_id UUID REFERENCES property(property_id),
    user_id UUID REFERENCES "user"(user_id),
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Message table (no changes)
CREATE TABLE message (
    message_id UUID PRIMARY KEY,
    sender_id UUID REFERENCES "user"(user_id),
    recipient_id UUID REFERENCES "user"(user_id),
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Additional Indexes (no changes, but ensure they align)
CREATE INDEX idx_booking_property_id ON booking(property_id);
CREATE INDEX idx_payment_booking_id ON payment(booking_id);