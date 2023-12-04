{{
    config(
        materialized='incremental',
        unique_key='passenger_id'
    )
}}

SELECT  p.passenger_id, 
        p.passportno, 
        p.firstname, 
        p.lastname, 
        pd.birthdate, 
        pd.sex, 
        pd.street, 
        pd.city, 
        pd.zip, 
        pd.country, 
        pd.emailaddress, 
        pd.telephoneno,
        getdate() as updated_at
FROM passenger p
INNER JOIN passengerdetails pd
ON p.passenger_id = pd.passenger_id

{% if is_incremental() %}
  where CAST(p."_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})
  or CAST(pd."_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})
{% endif %}