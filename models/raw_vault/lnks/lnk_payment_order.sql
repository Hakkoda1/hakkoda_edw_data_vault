{{ config(
    materialized='incremental',
    tags=["payment","stripe"]
) }}

{%- set source_model = "primed_stripe_payments" -%}
{%- set src_pk = "LNK_PAYMENT_ORDER_HKEY" -%}
{%- set src_fk = ["HUB_PAYMENT_HKEY","HUB_ORDER_HKEY"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}
{{ dbtvault.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                 src_source=src_source, source_model=source_model) }}