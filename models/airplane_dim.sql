{{ config(
    materialized='table',
) }}

with source_data as (
    select
        airplane_id, 
        capacity,
        type_id
    from airplane
    where airline_id = 107
)

select *
from source_data