{{ 
  config(
    tags=["ionis", "veeva_etmf"]
  )
}}

{% set old_etl_relation=adapter.get_relation(
      database=target.database,
      schema="raw_stage",
      identifier="stage_veeva_etmf_study"
) -%}

{% set dbt_relation=ref('src_veeva_etmf_study') %}

{{ audit_helper.compare_relations(
    a_relation=old_etl_relation,
    b_relation=dbt_relation,
    primary_key="STUDY_PROTOCOL_NUMBER"
) }}