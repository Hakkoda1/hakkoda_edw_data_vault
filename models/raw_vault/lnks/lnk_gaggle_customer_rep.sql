{{ config(
    tags=["customer","jaffle_gaggle"]
) }}

{%- set source_model = "primed_jaffle_gaggle_raw_gaggle_customer_reps" -%}
{%- set src_pk = "LNK_GAGGLE_CUSTOMER_REP_HKEY" -%}
{%- set src_fk = ["HUB_CUSTOMER_HKEY","HUB_EMPLOYEE_HKEY"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}
{{ dbtvault.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                 src_source=src_source, source_model=source_model) }}