-- models/airplane_type_dim.sql
{{ config(
    materialized='table',
    materialized_table='public.airplane_type_dim'
) }}

with source_data as (
    select
        type_id, 
        identifier,
        "description"
    from airplane_type
)

select *
from source_data