{% macro generate_dates_dimension (start_date) %}
WITH RECURSIVE dates AS (
  SELECT '{{ start_date }}' as "date"
  UNION ALL
  SELECT cast(dateadd(day, 1, d."date") as date)
  FROM dates d
  WHERE d."date" < dbt_date.today())
--   , 
--   dates_fin AS (
--   SELECT d1.date AS Carlendar_Date,
--          EXTRACT(DAYOFWEEK FROM d1.date) as Day_Of_Week,
--          DATE_FORMAT(d1.date, '%a') as Day_Of_Week_Name,
--          DATE_TRUNC(d1.date, 'WEEK') AS Cal_Week_Start_Date, --Monday Start
--          EXTRACT(DAY FROM d1.date) AS Day_Of_Month,
--          EXTRACT(MONTH FROM d1.date) AS Cal_Month,
--          DATE_FORMAT(d1.date, '%M') AS Cal_Mon_Name,
--          DATE_FORMAT(d1.date, '%b') AS Cal_Mon_Name_Short,
--          EXTRACT(quarter FROM d1.date) AS Cal_Quarter,
--          CONCAT ('Q',EXTRACT(quarter FROM d1.date)) AS Cal_Quarter_Name,
--          EXTRACT(year FROM d1.date) AS Cal_Year,
--          CASE EXTRACT(DAYOFWEEK FROM d1.date)
--            WHEN 6 THEN TRUE
--            WHEN 7 THEN TRUE
--            ELSE FALSE
--          END AS Is_Weekend,
--          CASE WHEN EXTRACT(MONTH FROM d1.date) < 7
--            THEN EXTRACT(YEAR FROM d1.date)
--            ELSE EXTRACT(YEAR FROM d1.date) + 1
--          END AS Fin_Year,
--          CASE WHEN EXTRACT(MONTH FROM d1.date) < 7
--            THEN EXTRACT(MONTH FROM d1.date) + 6
--            ELSE EXTRACT(MONTH FROM d1.date) - 6
--          END AS Fin_Period,
--          CASE WHEN EXTRACT(MONTH FROM d1.date) < 7
--            THEN EXTRACT(quarter FROM d1.date) + 2
--            ELSE EXTRACT(quarter FROM d1.date) - 2
--          END AS Fin_Quarter,
--          CASE WHEN d1.date < date_trunc(d1.date, 'year') + interval '6 months'
--            THEN EXTRACT(WEEK FROM (d1.date - interval '6 months'))::integer
--            ELSE EXTRACT(WEEK FROM (d1.date + interval '6 months'))::integer
--          END AS Fin_Week
--   FROM dates d1
-- )
-- SELECT *,
--        CONCAT ('p',Fin_Period) AS Fin_Period_Name,
--        CONCAT ('FQ',Fin_Quarter) AS Fin_Quarter_Name,
--        CONCAT ('wk',Fin_Week) AS Fin_Week_Name
-- FROM dates_fin
select * from dates
{% endmacro %}
