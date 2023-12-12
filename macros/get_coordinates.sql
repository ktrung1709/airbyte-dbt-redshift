{% macro get_latlong(airport_id) %}

{% set query %}
    select latitude, longitude
    from airport_geo
    where id = {{airport_id}}

{% endset %}

{% set lat = run_query(query).columns[0][0] %}
{% do return(lat) %}

{% endmacro %}