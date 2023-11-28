{% macro generate_date_dim() %}
    with date_series as (
        select 
            dateadd(day, number, '2015-01-01') as date,
            number as id
        from 
            (select row_number() over (order by (select null)) - 1 as number from sys.all_objects) a
        where 
            dateadd(day, number, '2015-01-01') <= getdate()
    ),
    date_parts as (
        select
            id,
            date,
            datepart(dw, date) as day_of_week,
            datepart(wk, date) as week_of_month,
            datepart(mm, date) as month,
            datepart(qq, date) as quarter,
            datepart(yy, date) as year
        from 
            date_series
    )
    insert into date_dim
    select 
        *
    from 
        date_parts
{% endmacro %}
