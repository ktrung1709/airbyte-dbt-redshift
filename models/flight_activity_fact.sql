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
    CASE
        WHEN DATE_PART(dayofweek, f.departure) = 0 AND fs.sunday IS TRUE
            THEN CAST(TO_CHAR(f.departure, 'YYYYMMDD') AS INT) 
        WHEN DATE_PART(dayofweek, f.departure) = 1 AND fs.monday IS TRUE
            THEN CAST(TO_CHAR(f.departure, 'YYYYMMDD') AS INT) 
        WHEN DATE_PART(dayofweek, f.departure) = 2 AND fs.tuesday IS TRUE
            THEN CAST(TO_CHAR(f.departure, 'YYYYMMDD') AS INT) 
        WHEN DATE_PART(dayofweek, f.departure) = 3 AND fs.wednesday IS TRUE
            THEN CAST(TO_CHAR(f.departure, 'YYYYMMDD') AS INT) 
        WHEN DATE_PART(dayofweek, f.departure) = 4 AND fs.thursday IS TRUE
            THEN CAST(TO_CHAR(f.departure, 'YYYYMMDD') AS INT) 
        WHEN DATE_PART(dayofweek, f.departure) = 5 AND fs.friday IS TRUE
            THEN CAST(TO_CHAR(f.departure, 'YYYYMMDD') AS INT) 
        WHEN DATE_PART(dayofweek, f.departure) = 6 AND fs.saturday IS TRUE
            THEN CAST(TO_CHAR(f.departure, 'YYYYMMDD') AS INT) 
        ELSE 0
    END AS "scheduled_departure_date_id",
    CAST('2023' || LPAD(CAST(EXTRACT(HOUR FROM fs.departure) AS VARCHAR(2)), 2, '0') || LPAD(CAST(EXTRACT(MINUTE FROM fs.departure) AS VARCHAR(2)), 2, '0') AS INT) AS "scheduled_departure_time_id",
    CAST(TO_CHAR(f.departure, 'YYYYMMDD') AS INT) as "actual_departure_date_id",
    CAST('2023' || TO_CHAR(f.departure, 'HH24') || TO_CHAR(f.departure, 'MI') AS INT) as "actual_departure_time_id",
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
    getdate() as updated_at,
    agf.latitude
    {{ haversine('agf.latitude', 'agf.longitude', 'agt.latitude', 'agt.longitude')}} as miles_flown

FROM
    booking_temp b
INNER JOIN flight f ON b.flight_id = f.flight_id
INNER JOIN flightschedule fs ON f.flightno = fs.flightno
INNER JOIN "public".airport_geo agf ON agf.airport_id = f.from
INNER JOIN "public".airport_geo agt ON agt.airport_id = f.to
WHERE
    f.airline_id = 107

{% if is_incremental() %}
  and
  ( CAST(f."_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})
  or CAST(b."_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})
  or CAST(fs."_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})
  )
{% endif %}