select * from booking inner join user on booking.user_id user.user_id ;
select * from property left join review on property.property_id = review.property_id ;
select first_name, last_name, booking_id, start_date, end_date  from user right JOIN booking on user.user_id = booking.user_id
union
select first_name, last_name, booking_id, start_date, end_date  from user left JOIN booking on user.user_id = booking.user_id;