{{ config(materialized='table') }}

{%- set datepart = "day" -%}
{%- set start_date = "TO_DATE('2022/11/01', 'yyyy/mm/dd')" -%}
{%- set end_date = "TO_DATE('2022/12/05', 'yyyy/mm/dd')" -%}

WITH as_of_date AS (
    {{ dbt_utils.date_spine(datepart=datepart, 
                            start_date=start_date,
                            end_date=end_date) }}
)
,dates AS (
    SELECT DATE_{{datepart}} as AS_OF_DATE FROM as_of_date
)
select dateadd(ms, -1, dateadd(day, 1, to_timestamp(as_of_date))) as_of_date
from dates
