{% macro generate_dates_dimension (start_date) %}
WITH RECURSIVE RecursiveDates (DateValue) AS (
    SELECT CAST('{{ start_date }}' AS DATE) AS DateValue
    UNION ALL
    SELECT CAST(DATEADD(day, 1, DateValue) AS DATE) AS DateValue
    FROM RecursiveDates
    WHERE CAST(dateValue as DATE) <= GETDATE()
)
-- SELECT * FROM RecursiveDates

  , 
  dates_fin AS (
  SELECT d1.DateValue AS "Date",
         extract(year from d1.DateValue) as "Year",
         extract(quarter from d1.DateValue) AS "Quarter",
         concat(cast(extract(year from d1.DateValue) as text), 'Q',cast(EXTRACT(quarter FROM d1.DateValue) as text)) AS QuarterID,
         extract(month from d1.DateValue) AS "Month",
         concat(cast(extract(year from d1.DateValue) as text), cast(EXTRACT(month FROM d1.DateValue) as text)) AS MonthID,
         dbt_date.month_name(d1.DateValue) AS MonthName,
         dbt_date.day_of_week(d1.DateValue) as DayOfWeek,
         dbt_date.day_of_month(d1.DateValue) AS DayOfMonth,
         dbt_date.day_name(d1.DateValue) AS DayName
         
  FROM RecursiveDates d1
)
-- SELECT *,
--        CONCAT ('p',Fin_Period) AS Fin_Period_Name,
--        CONCAT ('FQ',Fin_Quarter) AS Fin_Quarter_Name,
--        CONCAT ('wk',Fin_Week) AS Fin_Week_Name
-- FROM dates_fin
select * from dates_fin
{% endmacro %}
