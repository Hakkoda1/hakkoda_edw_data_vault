{{ config(
    materialized='incremental'
    ,tags=["ionis", "veeva_etmf"]
    )    
}}

{%- set source_model = ["primed_veeva_etmf_study"]  -%}
{%- set src_pk = "HUB_STUDY_HKEY"      -%}
{%- set src_nk = "STUDY_PROTOCOL_NUMBER"          -%}
{%- set src_ldts = "LOAD_DATETIME"       -%}
{%- set src_source = "RECORD_SOURCE"     -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}