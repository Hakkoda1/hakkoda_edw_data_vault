{{ config(
    tags=["tcb"]
) }}

{%- set source_model = "primed_ln_core_customer_account" -%}
{%- set src_pk = "LNK_CUSTOMER_ACCOUNT_LENDING_HKEY" -%}
{%- set src_fk = ["HUB_CUSTOMER_HKEY","HUB_ACCOUNT_HKEY"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}
{{ dbtvault.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                 src_source=src_source, source_model=source_model) }}