with airplane_source as (
    select
        airplane_id, 
        capacity,
        type_id
    from airplane
    where airline_id = 107
)

select *
from airplane_source