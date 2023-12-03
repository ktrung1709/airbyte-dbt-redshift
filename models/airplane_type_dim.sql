{{
    config(
        materialized='incremental',
        unique_key='type_id'
    )
}}

with max_updated_time as 
(select max(_ab_cdc_updated_at) from airplane_type)

select
    type_id, 
    identifier,
    "description"
from airplane_type

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  -- (uses >= to include records arriving later on the same day as the last run of this model)
  where _ab_cdc_updated_at >= max_updated_time

{% endif %}