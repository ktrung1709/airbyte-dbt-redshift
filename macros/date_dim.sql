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
  SELECT d1.DateValue AS Carlendar_Date,
         EXTRACT(DAYOFWEEK FROM d1.DateValue) as Day_Of_Week,
         DATE_FORMAT(d1.DateValue, '%a') as Day_Of_Week_Name,
         DATE_TRUNC(d1.DateValue, 'WEEK') AS Cal_Week_Start_Date, --Monday Start
         EXTRACT(DAY FROM d1.DateValue) AS Day_Of_Month,
         EXTRACT(MONTH FROM d1.DateValue) AS Cal_Month,
         DATE_FORMAT(d1.DateValue, '%M') AS Cal_Mon_Name,
         DATE_FORMAT(d1.DateValue, '%b') AS Cal_Mon_Name_Short,
         EXTRACT(quarter FROM d1.DateValue) AS Cal_Quarter,
         CONCAT ('Q',EXTRACT(quarter FROM d1.DateValue)) AS Cal_Quarter_Name,
         EXTRACT(year FROM d1.DateValue) AS Cal_Year,
         CASE EXTRACT(DAYOFWEEK FROM d1.DateValue)
           WHEN 6 THEN TRUE
           WHEN 7 THEN TRUE
           ELSE FALSE
         END AS Is_Weekend,
         CASE WHEN EXTRACT(MONTH FROM d1.DateValue) < 7
           THEN EXTRACT(YEAR FROM d1.DateValue)
           ELSE EXTRACT(YEAR FROM d1.DateValue) + 1
         END AS Fin_Year,
         CASE WHEN EXTRACT(MONTH FROM d1.DateValue) < 7
           THEN EXTRACT(MONTH FROM d1.DateValue) + 6
           ELSE EXTRACT(MONTH FROM d1.DateValue) - 6
         END AS Fin_Period,
         CASE WHEN EXTRACT(MONTH FROM d1.DateValue) < 7
           THEN EXTRACT(quarter FROM d1.DateValue) + 2
           ELSE EXTRACT(quarter FROM d1.DateValue) - 2
         END AS Fin_Quarter,
         CASE WHEN d1.DateValue < date_trunc(d1.DateValue, 'year') + interval '6 months'
           THEN EXTRACT(WEEK FROM (d1.DateValue - interval '6 months'))::integer
           ELSE EXTRACT(WEEK FROM (d1.DateValue + interval '6 months'))::integer
         END AS Fin_Week
  FROM RecursiveDates d1
)
-- SELECT *,
--        CONCAT ('p',Fin_Period) AS Fin_Period_Name,
--        CONCAT ('FQ',Fin_Quarter) AS Fin_Quarter_Name,
--        CONCAT ('wk',Fin_Week) AS Fin_Week_Name
-- FROM dates_fin
select * from dates_fin
{% endmacro %}
