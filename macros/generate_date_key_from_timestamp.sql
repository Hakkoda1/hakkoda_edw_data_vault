{% macro generate_date_key_from_timestamp(input_timestamp) %}
  {# Takes an input timestamp and generates a date key for a fact table in the format of YYYYMMDD. #}
IFNULL(TO_VARCHAR(TO_DATE( {{ input_timestamp }}), 'YYYYMMDD'),'-1')
{% endmacro %}