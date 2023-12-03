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

  -- this filter will only be applied on an incremental run
  -- (uses > to include records whose timestamp occurred since the last run of this model)
  where CAST("_ab_cdc_updated_at" AS TIMESTAMP) > (select max(updated_at) from {{ this }})

{% endif %}