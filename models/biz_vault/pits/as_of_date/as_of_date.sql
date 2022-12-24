{{ config(
    materialized='table'
    ) 
}}

{%- set datepart = "day" -%}
{%- set start_date = "dateadd(year, -5, CURRENT_DATE)" -%}
{%- set end_date = "CURRENT_DATE" -%}

with as_of_date as (
    {{ dbt_utils.date_spine(datepart=datepart, 
                            start_date=start_date,
                            end_date=end_date) }}
)
,dates as (
    select date_{{datepart}} as as_of_date from as_of_date
)
, daily as (
  select as_of_date
  from dates
  where as_of_date >= dateadd('DAY', -30, current_date) 
) 
, monthly as (
  select trunc(as_of_date, 'MONTH') as_of_date
  from dates
  where as_of_date between dateadd('YEAR', -2, current_date) and dateadd('DAY', -30, current_date)
) 
, yearly as (
  select trunc(as_of_date, 'YEAR') as_of_date
  from dates
  where as_of_date between dateadd('YEAR', -5, current_date) and dateadd('YEAR', -2, current_date)
) 
, combined_dates AS (
  select as_of_date
  from yearly
  union
  select as_of_date
  from monthly
  union
  select as_of_date
  from daily
)
select distinct dateadd(ms, -1, dateadd(day, 1, to_timestamp(as_of_date))) as_of_date
from combined_dates
order by 1 asc