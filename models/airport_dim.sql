{{ config(materialized='table') }}

with airport_source as (
    select
        a.airport_id, a.iata, a.icao, a.name, a1.city, a1.country, a1.latitude, a1.longitude, a1.geolocation
    from airport a
    inner join airport_geo a1 on a.airport_id = a1.airport_id
)

select *
from airport_source