{{ config(
    materialized='incremental',
    tags=["hubspot"]
) }}

{%- set source_model = "primed_hubspot_deal" -%}
{%- set src_pk = "LNK_SALES_PIPELINE_HKEY" -%}
{%- set src_fk = ["HUB_DEAL_HKEY","HUB_SALES_PIPELINE_STAGE_HKEY","HUB_EMPLOYEE_HKEY"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}
{{ dbtvault.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                 src_source=src_source, source_model=source_model) }}