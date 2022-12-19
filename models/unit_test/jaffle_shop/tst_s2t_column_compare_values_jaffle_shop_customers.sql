{{ 
  config(
    tags=["customer","jaffle_shop"]
  )
}}

{% set source_model=ref('stage_jaffle_shop_customers') %}

{% set target_model=ref('src_jaffle_shop_customers') %}

{{ 
    audit_helper.compare_all_columns(
      a_relation=source_model,
      b_relation=target_model, 
      exclude_columns=['updated_at'], 
      primary_key="ID"
    ) 
}}
where not perfect_match