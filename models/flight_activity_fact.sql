{{
    config(
        materialized='incremental',
        unique_key='booking_id'
    )
}}

SELECT
    b.booking_id,
    f.flightno,
    b.passenger_id,
    f.from AS origin_airport_id,
    f.to AS destination_airport_id,
    CAST(TO_CHAR(DATE(departure), 'YYYYMMDD') AS INT) as "actual_departure_date_id",
    CASE
        WHEN SUBSTRING(b.seat, 1, 1) IN ('0', '1', '2', '3', '4', '5')
        	AND SUBSTRING(b.seat, 2, 1) NOT IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
        	THEN 1
        WHEN SUBSTRING(b.seat, 1, 1) IN ('6', '7', '8', '9')
        	AND SUBSTRING(b.seat, 2, 1) NOT IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
        	THEN 2
        ELSE 3
    END AS cos_id,
    b.price AS transaction_fee,
    getdate() as updated_at
FROM
    booking_temp b
INNER JOIN flight f ON b.flight_id = f.flight_id
INNER JOIN flightschedule fs ON f.flightno = fs.flightno
WHERE
    f.airline_id = 107

{% if is_incremental() %}
  and
  ( CAST(f."_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})
  or CAST(b."_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})
  or CAST(fs."_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})
  )
{% endif %}