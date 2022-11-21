{{ config(
    materialized='incremental'
    ,tags=["customer","jaffle_shop"]
    )    
}}

{%- set source_model = ["primed_jaffle_shop_customers", "primed_jaffle_shop_orders"]  -%}
{%- set src_pk = "HUB_CUSTOMER_HKEY"      -%}
{%- set src_nk = "CUSTOMER_ID"          -%}
{%- set src_ldts = "LOAD_DATETIME"       -%}
{%- set src_source = "RECORD_SOURCE"     -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}