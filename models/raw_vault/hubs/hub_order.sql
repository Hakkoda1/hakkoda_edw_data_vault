{{ config(
    materialized='incremental'
    ,tags=["order","jaffle_shop","stripe"]
    )    
}}

{%- set source_model = ["primed_jaffle_shop_orders", "primed_stripe_payments"]  -%}
{%- set src_pk = "HUB_ORDER_HKEY"      -%}
{%- set src_nk = "ORDER_ID"          -%}
{%- set src_ldts = "LOAD_DATETIME"       -%}
{%- set src_source = "RECORD_SOURCE"     -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}