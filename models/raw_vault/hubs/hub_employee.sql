{{ config(
    tags=["employee","jaffle_gaggle"]
    )    
}}

{%- set source_model = ["primed_jaffle_gaggle_raw_gaggle_customer_reps"]  -%}
{%- set src_pk = "HUB_EMPLOYEE_HKEY"      -%}
{%- set src_nk = "EMPLOYEE_EMAIL"          -%}
{%- set src_ldts = "LOAD_DATETIME"       -%}
{%- set src_source = "RECORD_SOURCE"     -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}