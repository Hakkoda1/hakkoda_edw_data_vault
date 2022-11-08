{{ config(
    materialized='incremental'
    ,tags=["hubspot"]
    )    
}}

{%- set source_model = ["primed_hubspot_deal"]  -%}
{%- set src_pk = "HUB_SALES_PIPELINE_STAGE_HKEY"      -%}
{%- set src_nk = "PIPELINE_STAGE_NAME"          -%}
{%- set src_ldts = "LOAD_DATETIME"       -%}
{%- set src_source = "RECORD_SOURCE"     -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}