{{ 
  config(
    tags=["payment","stripe"]
  )
}}

{% set stage_table=adapter.get_relation(
      database=target.database,
      schema="raw_stage",
      identifier="stage_stripe_payments"
) -%}

{% set source_mart_view=ref('src_stripe_payments') %}

{{ audit_helper.compare_relations(
    a_relation=stage_table,
    b_relation=source_mart_view,
    primary_key="ID"
) }}