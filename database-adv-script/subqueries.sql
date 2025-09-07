SELECT property_id
 FROM (
     SELECT property_id, AVG(rating) AS average_rating
     FROM review
     GROUP BY property_id
 ) AS sub
 WHERE average_rating > 4.0;

 SELECT user_id 
 FROM (
 	SELECT COUNT(booking_id) as COUNT_booking, user_id 
 	FROM booking 
 	group by user_id
 	) as sub 
 WHERE COUNT_booking > 3;
