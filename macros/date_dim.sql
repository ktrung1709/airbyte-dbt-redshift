{% macro generate_dates_dimension (start_date) %}
WITH RECURSIVE dates AS (
  SELECT CAST('{{ start_date }}' AS DATE) AS date
  UNION ALL
  SELECT dbt_utils.dateadd(day, 1, date)
  FROM dates
  WHERE date < dbt_utils.dateadd(month, 12, dbt_date.today())), dates_fin AS (
  SELECT date AS Carlendar_Date,
         EXTRACT(DAYOFWEEK FROM date) as Day_Of_Week,
         DATE_FORMAT(date, '%a') as Day_Of_Week_Name,
         DATE_TRUNC(date, 'WEEK') AS Cal_Week_Start_Date, --Monday Start
         EXTRACT(DAY FROM date) AS Day_Of_Month,
         EXTRACT(MONTH FROM date) AS Cal_Month,
         DATE_FORMAT(date, '%M') AS Cal_Mon_Name,
         DATE_FORMAT(date, '%b') AS Cal_Mon_Name_Short,
         EXTRACT(quarter FROM date) AS Cal_Quarter,
         CONCAT ('Q',EXTRACT(quarter FROM date)) AS Cal_Quarter_Name,
         EXTRACT(year FROM date) AS Cal_Year,
         CASE EXTRACT(DAYOFWEEK FROM date)
           WHEN 6 THEN TRUE
           WHEN 7 THEN TRUE
           ELSE FALSE
         END AS Is_Weekend,
         CASE WHEN EXTRACT(MONTH FROM date) < 7
           THEN EXTRACT(YEAR FROM date)
           ELSE EXTRACT(YEAR FROM date) + 1
         END AS Fin_Year,
         CASE WHEN EXTRACT(MONTH FROM date) < 7
           THEN EXTRACT(MONTH FROM date) + 6
           ELSE EXTRACT(MONTH FROM date) - 6
         END AS Fin_Period,
         CASE WHEN EXTRACT(MONTH FROM date) < 7
           THEN EXTRACT(quarter FROM date) + 2
           ELSE EXTRACT(quarter FROM date) - 2
         END AS Fin_Quarter,
         CASE WHEN date < date_trunc(date, 'year') + interval '6 months'
           THEN EXTRACT(WEEK FROM (date - interval '6 months'))::integer
           ELSE EXTRACT(WEEK FROM (date + interval '6 months'))::integer
         END AS Fin_Week
  FROM dates
)
SELECT *,
       CONCAT ('p',Fin_Period) AS Fin_Period_Name,
       CONCAT ('FQ',Fin_Quarter) AS Fin_Quarter_Name,
       CONCAT ('wk',Fin_Week) AS Fin_Week_Name
FROM dates_fin
{% endmacro %}
