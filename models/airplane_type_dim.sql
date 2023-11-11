{{ config(materialized='table', schema='bi') }}

with airplane_type_source as (
    select
        type_id, 
        identifier,
        "description"
    from airplane_type
)

select *
from airplane_type_source