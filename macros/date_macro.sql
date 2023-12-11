{% macro generate_dates_dimension (start_date) %}
WITH RECURSIVE RecursiveDates (DateValue) AS (
    SELECT CAST('{{ start_date }}' AS DATE) AS DateValue
    UNION ALL
    SELECT CAST(DATEADD(day, 1, DateValue) AS DATE) AS DateValue
    FROM RecursiveDates
    WHERE CAST(dateValue as DATE) <= GETDATE()
)
  , 
  dates_fin AS (
  SELECT CAST(TO_CHAR(d1.DateValue, 'YYYYMMDD') AS INT) as "date_id",
         d1.DateValue AS "date",
         extract(year from d1.DateValue) as "year",
         extract(quarter from d1.DateValue) AS "quarter",
         cast(extract(year from d1.DateValue) as text) || cast('Q' as text) || cast(EXTRACT(quarter FROM d1.DateValue) as text) AS quarter_id,
         extract(month from d1.DateValue) AS "month",
         cast(extract(year from d1.DateValue) as text) || cast(EXTRACT(month FROM d1.DateValue) as text) AS month_id,
         TO_CHAR(d1.DateValue, 'mon') AS "month_name",
         date_part(dayofweek, d1.DateValue) as day_of_week,
         lower(TO_CHAR(d1.DateValue, 'Day')) as day_name,
         date_part(day, d1.DateValue) AS "day_of_month"
         
  FROM RecursiveDates d1
)
select * from dates_fin
{% endmacro %}
