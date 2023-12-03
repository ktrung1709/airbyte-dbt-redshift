{{
    config(
        materialized='incremental',
        unique_key='type_id'
    )
}}

select
    type_id, 
    identifier,
    "description",
    getdate() as updated_at
from airplane_type

{% if is_incremental() %}
  where CAST("_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})
{% endif %}