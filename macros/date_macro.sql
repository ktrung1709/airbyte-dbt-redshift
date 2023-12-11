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
  SELECT CAST(TO_CHAR(d1.DateValue, 'YYYYMMDD') AS INT) as "Date ID",
         d1.DateValue AS "Date",
         extract(year from d1.DateValue) as "Year",
         extract(quarter from d1.DateValue) AS "Quarter",
         cast(extract(year from d1.DateValue) as text) || cast('Q' as text) || cast(EXTRACT(quarter FROM d1.DateValue) as text) AS QuarterID,
         extract(month from d1.DateValue) AS "Month",
         cast(extract(year from d1.DateValue) as text) || cast(EXTRACT(month FROM d1.DateValue) as text) AS MonthID,
         TO_CHAR(d1.DateValue, 'mon') AS "MonthName",
         date_part(dayofweek, d1.DateValue) as DayOfWeek,
         lower(TO_CHAR(d1.DateValue, 'Day')) as DayName,
         date_part(day, d1.DateValue) AS "DayOfMonth"
         
  FROM RecursiveDates d1
)
select * from dates_fin
{% endmacro %}
