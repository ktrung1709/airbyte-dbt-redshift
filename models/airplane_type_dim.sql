-- models/airplane_type_dim.sql
{{ config(
    materialized='table',
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