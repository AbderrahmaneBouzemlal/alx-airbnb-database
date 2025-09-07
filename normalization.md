## Identified Issues

### Redundancy in Booking Table - total_price:

The total_price is likely a calculated value: total_price = (end_date - start_date) * pricepernight (assuming nights are calculated as end_date - start_date, or +1 depending on business rules; the exact formula isn't specified but is deterministic).
Storing total_price introduces redundancy because it can be derived FROM other attributes (start_date, end_date) and the pricepernight FROM the Property table.
This creates a risk of inconsistencies (e.g., if dates are updated without recalculating total_price).


### Normalization Violation:

The schema is in 1NF (atomic values, no repeating groups) and 2NF (no partial dependencies, as all keys are single attributes).
However, it violates 3NF in the Booking table due to a transitive dependency.

Functional Dependencies (FDs):

booking_id → (property_id, start_date, end_date, total_price, ...)
Implicitly (FROM domain knowledge): (property_id, start_date, end_date) → total_price (since total_price is determined by the property's pricepernight and the booking duration).


Here, total_price depends on non-key attributes (property_id, start_date, end_date) transitively via pricepernight (FROM another table).
In 3NF, every non-prime attribute must depend directly on the primary key, not transitively on other non-key attributes. This FD violates that: (property_id, start_date, end_date) is not a superkey, and total_price is not prime.


Additionally, joining with Property for calculations risks using updated pricepernight values for historical bookings, leading to inaccuracies if prices change over time.


#### Other Potential Concerns (Not Normalization Violations):

User Role: The role is a single ENUM ('guest', 'host', 'admin'). In reality, users might act as both guests and hosts. This is a modeling limitation, not a normalization issue. Could be addressed with a many-to-many roles table, but not required for 3NF.
Payment Amount vs. Booking Total: If payments are always full and single, amount might duplicate total_price. However, the schema allows multiple payments (no unique constraint on booking_id), so this is not redundant. It's handled at the application level.
No other redundancies (e.g., no duplicated data across tables).



### Normalization Steps to Achieve 3NF
To resolve the 3NF violation and eliminate redundancy:

Remove the Calculated Field (total_price):

Do not store total_price in the Booking table. Instead, compute it dynamically in queries using: (end_date - start_date) * price_per_night (adjust formula for inclusive/exclusive dates as per business rules).
This eliminates the transitive dependency and redundancy, as the value is derived on-the-fly.


Add Historical Price Field to Booking:

Introduce price_per_night DECIMAL NOT NULL to the Booking table.
This field captures the pricepernight FROM the Property table at the time of booking.
Reason: Prevents issues with price changes in Property affecting historical bookings. When creating a booking, the application copies property.pricepernight to booking.price_per_night.
Now, computations use booking.price_per_night, avoiding joins and ensuring historical accuracy.
No new FDs are introduced that violate 3NF, as price_per_night directly depends on booking_id (it's a snapshot for that booking).


#### Why This Achieves 3NF:

After adjustments, all non-prime attributes in Booking depend directly on booking_id.
No transitive dependencies remain, as no stored attribute depends on non-key attributes.
The schema remains in 2NF and now fully complies with 3NF.
Benefits: Reduces storage, avoids update anomalies (e.g., changing dates automatically affects computed total), and maintains data integrity.


No Decomposition Needed:

Decomposition (e.g., creating a separate table for pricing) was considered but unnecessary. The adjustments keep the schema simple while resolving the issue.


Impact on Other Tables:

Payment: amount remains independent. Applications can compare sum of payments to the computed total for validation.
No changes to other tables, as they are already in 3NF.
