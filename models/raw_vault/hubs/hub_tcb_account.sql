{{ config(
    tags=["tcb"]
    )    
}}

{%- set source_model = ["primed_dp_core_account", "primed_ln_core_account"]  -%}
{%- set src_pk = "HUB_ACCOUNT_HKEY"      -%}
{%- set src_nk = ["COLLISION_KEY","ACCOUNT_ID"]          -%}
{%- set src_ldts = "LOAD_DATETIME"       -%}
{%- set src_source = "RECORD_SOURCE"     -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}