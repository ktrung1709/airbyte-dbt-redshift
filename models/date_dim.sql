WITH date_dim AS (
  SELECT *
  FROM {{ ref('date_time') }}
)
SELECT *
FROM date_dim