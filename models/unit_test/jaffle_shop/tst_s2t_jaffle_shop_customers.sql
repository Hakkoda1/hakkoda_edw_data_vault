{{ 
  config(
    tags=["customer","jaffle_shop"]
  )
}}

{% set stage_table=adapter.get_relation(
      database=target.database,
      schema="raw_stage",
      identifier="stage_jaffle_shop_customers"
) -%}

{% set source_mart_view=ref('src_jaffle_shop_customers') %}

{{ audit_helper.compare_relations(
    a_relation=stage_table,
    b_relation=source_mart_view,
    primary_key="ID"
) }}