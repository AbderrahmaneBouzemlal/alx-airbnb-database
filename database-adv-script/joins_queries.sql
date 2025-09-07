SELECT * FROM booking INNER JOIN user on booking.user_id user.user_id ;
SELECT * FROM property LEFT JOIN review on property.property_id = review.property_id ;
SELECT first_name, last_name, booking_id, start_date, end_date  FROM user RIGHT JOIN booking on user.user_id = booking.user_id
UNION
SELECT first_name, last_name, booking_id, start_date, end_date  FROM user LEFT JOIN booking on user.user_id = booking.user_id;