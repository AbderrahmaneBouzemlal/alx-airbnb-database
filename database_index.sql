-- ======================
-- Indexes for User table
-- ======================
CREATE INDEX idx_user_role ON user(role);
CREATE INDEX idx_user_created_at ON user(created_at);

-- ======================
-- Indexes for Property table
-- ======================
CREATE INDEX idx_property_host_id ON property(host_id);
CREATE INDEX idx_property_location ON property(location);
CREATE INDEX idx_property_price ON property(pricepernight);
CREATE INDEX idx_property_created_at ON property(created_at);

-- ======================
-- Indexes for Booking table
-- ======================
CREATE INDEX idx_booking_property_id ON booking(property_id);
CREATE INDEX idx_booking_user_id ON booking(user_id);
CREATE INDEX idx_booking_status ON booking(status);
CREATE INDEX idx_booking_start_end_date ON booking(start_date, end_date);
CREATE INDEX idx_booking_created_at ON booking(created_at);
