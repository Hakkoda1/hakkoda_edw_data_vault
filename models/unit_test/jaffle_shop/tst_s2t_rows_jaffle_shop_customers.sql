{{ 
  config(
    tags=["customer","jaffle_shop"]
  )
}}

{% set source_model=ref('stage_jaffle_shop_customers') %}

{% set target_model=ref('src_jaffle_shop_customers') %}

{{ audit_helper.compare_relations(
    a_relation=source_model,
    b_relation=target_model,
    primary_key="ID"
) }}