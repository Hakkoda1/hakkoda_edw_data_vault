{{ config(
    materialized='incremental'
    ,tags=["hubspot"]
    )    
}}

{%- set source_model = ["primed_hubspot_deal","primed_hubspot_deal_company"]  -%}
{%- set src_pk = "HUB_DEAL_HKEY"      -%}
{%- set src_nk = "DEAL_NAME"          -%}
{%- set src_ldts = "LOAD_DATETIME"       -%}
{%- set src_source = "RECORD_SOURCE"     -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}