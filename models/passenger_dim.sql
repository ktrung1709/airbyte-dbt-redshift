with passenger_source as (
    SELECT p.passenger_id, p.passportno, p.firstname, p.lastname, pd.birthdate, pd.sex, pd.street, pd.city, pd.zip, pd.country, pd.emailaddress, pd.telephoneno
    FROM passenger p
    INNER JOIN passengerdetails pd
    ON p.passenger_id = pd.passenger_id;
)

select *
from passenger_source