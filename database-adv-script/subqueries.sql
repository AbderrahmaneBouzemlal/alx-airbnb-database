SELECT property_id
 FROM (
     SELECT property_id, AVG(rating) AS average_rating
     FROM review
     GROUP BY property_id
 ) AS sub
 WHERE average_rating > 4.0;

 select user_id 
 from (
 	select count(booking_id) as count_booking, user_id 
 	from booking 
 	group by user_id
 	) as sub 
 where count_booking > 3;
