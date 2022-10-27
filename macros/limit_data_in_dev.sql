{% macro limit_data_in_dev(column_name, dev_days_to_look_back = 3) -%}
{% if target.name == 'dev' -%}
where {{column_name}} >= dateadd('day', - {{ dev_days_to_look_back}}, current_timestamp)
{%- endif %}
{%- endmacro %}
