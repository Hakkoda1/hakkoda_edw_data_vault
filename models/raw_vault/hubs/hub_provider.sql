{{ config(materialized='incremental')    }}

{%- set source_model = ["primed_phm_providers", "primed_kp_fhir_practitioner"]  -%}
{%- set src_pk = "HUB_PROVIDER_HKEY"      -%}
{%- set src_nk = ["PROVIDER_ID", "COLLISION_KEY"]  -%}
{%- set src_ldts = "LOAD_DATETIME"       -%}
{%- set src_source = "RECORD_SOURCE"     -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}