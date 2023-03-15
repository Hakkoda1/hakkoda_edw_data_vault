{{ config(
    tags=["tcb"]
    )    
}}

{%- set source_model = ["primed_dp_core_customer", "primed_ln_core_customer"]  -%}
{%- set src_pk = "HUB_CUSTOMER_HKEY"      -%}
{%- set src_nk = ["COLLISION_KEY","CUSTOMER_ID"]          -%}
{%- set src_ldts = "LOAD_DATETIME"       -%}
{%- set src_source = "RECORD_SOURCE"     -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}