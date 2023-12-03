{{
    config(
        materialized='incremental',
        unique_key='airplane_id'
    )
}}

select
    airplane_id, 
    capacity,
    type_id,
    getdate() as updated_at
from airplane
where airline_id = 107

{% if is_incremental() %}
  and CAST("_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})
{% endif %}