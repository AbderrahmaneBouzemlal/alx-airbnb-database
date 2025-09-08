SELECT COUNT(*) FROM booking 
GROUP BY user_id ;

SELECT 
    name,
    number_booking,
    status,
    ROW_NUMBER() OVER (ORDER BY number_booking DESC) AS row_num
FROM (
    SELECT 
        p.name,
        COUNT(b.booking_id) AS number_booking,
        b.property_id,
        b.status
    FROM property p
    JOIN booking b ON p.property_id = b.property_id
    GROUP BY p.property_id, b.status
) AS sub;
