{% macro qualify_latest_satellite_records(satellite_key, datefield) %}
  {# Takes an input primary key for a satellite and generate a qualify row_number() = 1 statement to get the latest satellite record. #}
QUALIFY ROW_NUMBER() OVER (PARTITION BY {{ satellite_key }} ORDER BY {{ datefield }} DESC) = 1
{% endmacro %}