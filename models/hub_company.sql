{{ config(materialized='incremental')    }}

{%- set source_model = "v_company"  -%}
{%- set src_pk = "HUB_COMPANY_HKEY"      -%}
{%- set src_nk = "COMPANY_NAME"          -%}
{%- set src_ldts = "LOAD_DATETIME"       -%}
{%- set src_source = "RECORD_SOURCE"     -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}