{% macro haversine(lat1, lon1, lat2, lon2) %} 
    6371 * 2 * ASIN(SQRT(
        POWER(SIN(({{ lat2 }} - abs({{ lat1 }})) * pi()/180 / 2), 2) +
        COS({{ lat1 }} * pi()/180) * COS(abs({{ lat2 }}) * pi()/180) *
        POWER(SIN(({{ lon2 }} - {{ lon1 }}) * pi()/180 / 2), 2)
    ))
{% endmacro %}