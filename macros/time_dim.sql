{% macro generate_time_dim() %}
    with time_series as (
        select 
            dateadd(minute, number, '00:00:00') as time,
            number as id
        from 
            (select row_number() over (order by (select null)) - 1 as number from sys.all_objects) a
        where 
            dateadd(minute, number, '00:00:00') < '24:00:00'
    ),
    time_parts as (
        select
            id,
            time,
            datepart(hour, time) as hour,
            datepart(minute, time) as minute,
            case when datepart(hour, time) < 12 then 'AM' else 'PM' end as am_pm
        from 
            time_series
    )
    insert into time_dim
    select 
        *
    from 
        time_parts
{% endmacro %}
