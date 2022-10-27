{% macro get_pacific_time_from_utc(input_timestamp) %}
  {# Takes an input timestamp and convert from utc to pacific time. #}
CONVERT_TIMEZONE('UTC','America/Los_Angeles', {{ input_timestamp }})
{% endmacro %}
