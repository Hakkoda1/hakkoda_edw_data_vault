{{ 
  config(
    tags=["customer","jaffle_shop"]
  )
}}

{% set source_model=ref('stage_jaffle_shop_customers') %}

{% set target_model=ref('src_jaffle_shop_customers') %}

with base_test_cte as (
  {{ 
    audit_helper.compare_all_columns(
      a_relation=source_model,
      b_relation=target_model, 
      exclude_columns=['updated_at'], 
      primary_key='id'
    ) 
  }}
  left join {{ ref('stage_jaffle_shop_customers') }} using(id)
  where conflicting_values
)
select
  status, -- assume there's a "status" column in stg_customers
  count(distinct case when conflicting_values then id end) as conflicting_values
from base_test_cte
group by 1