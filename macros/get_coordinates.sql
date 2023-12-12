{% macro get_latlong(airport_id) %}

{% set query %}
    select latitude, longitude
    from airport_geo

{% endset %}


{% if execute %}

{% set lat = run_query(query).columns[0][0] %}
{% else %}
{% set lat = "" %}
{% endif %}
{% do return(lat) %}

{% endmacro %}