{{
    config(
        materialized='incremental',
        unique_key='airport_id'
    )
}}

select
    a.airport_id, a.iata, a.icao, a.name, a1.city, a1.country, a1.latitude, a1.longitude,
    getdate() as updated_at
from airport a
inner join airport_geo a1 on a.airport_id = a1.airport_id


{% if is_incremental() %}
  where CAST(a."_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})
  or CAST(a1."_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})
{% endif %}