{{ config(
    materialized='incremental',
    tags=["order","jaffle_shop"]
) }}

{%- set source_model = "primed_jaffle_shop_orders" -%}
{%- set src_pk = "LNK_ORDER_CUSTOMER_HKEY" -%}
{%- set src_fk = ["HUB_ORDER_HKEY","HUB_CUSTOMER_HKEY"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}
{{ dbtvault.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                 src_source=src_source, source_model=source_model) }}