SELECT * FROM booking INNER JOIN user on booking.user_id user.user_id ;
SELECT * FROM property LEFT JOIN review on property.property_id = review.property_id ORDER BY review.property_id;
SELECT first_name, last_name, booking_id, start_date, end_date  FROM user FULL OUTER JOIN booking on user.user_id = booking.user_id;