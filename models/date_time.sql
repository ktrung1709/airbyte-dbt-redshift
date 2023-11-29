
-- {{ generate_dates_dimension ("2015-01-01") }}
WITH date_spine AS (

  {{ dbt_utils.date_spine(
      start_date="to_date('01/01/2000', 'mm/dd/yyyy')",
      datepart="day",
      end_date="to_date('12/01/2050', 'mm/dd/yyyy')"
     )
  }}

)

select * from date_spine