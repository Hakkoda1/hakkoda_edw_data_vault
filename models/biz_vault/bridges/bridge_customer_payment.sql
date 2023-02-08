{{ config(
    materialized="bridge_incremental"
    ,tags=["payment","order","customer"]
) }}

{%- set yaml_metadata -%}
source_model: hub_customer
src_pk: HUB_CUSTOMER_HKEY
src_ldts: LOAD_DATETIME
as_of_dates_table: as_of_date
bridge_walk:
  ORDER_CUSTOMER:
    bridge_link_pk: LNK_ORDER_CUSTOMER_HKEY
    bridge_end_date: EFFSAT_CUSTOMER_ORDER_ENDDATE
    bridge_load_date: EFFSAT_CUSTOMER_ORDER_LOADDATE
    link_table: lnk_order_customer
    link_pk: LNK_ORDER_CUSTOMER_HKEY
    link_fk1: HUB_ORDER_HKEY
    link_fk2: HUB_CUSTOMER_HKEY
    eff_sat_table: effsat_order_customer
    eff_sat_pk: LNK_ORDER_CUSTOMER_HKEY
    eff_sat_end_date: END_DATE
    eff_sat_load_date: LOAD_DATETIME
  PAYMENT_ORDER:
    bridge_link_pk: LNK_PAYMENT_ORDER_HKEY
    bridge_end_date: EFFSAT_PAYMENT_ORDER_ENDDATE
    bridge_load_date: EFFSAT_PAYMENT_ORDER_LOADDATE
    link_table: lnk_payment_order
    link_pk: LNK_PAYMENT_ORDER_HKEY
    link_fk1: HUB_PAYMENT_HKEY
    link_fk2: HUB_ORDER_HKEY
    eff_sat_table: effsat_payment_order
    eff_sat_pk: LNK_PAYMENT_ORDER_HKEY
    eff_sat_end_date: END_DATE
    eff_sat_load_date: LOAD_DATETIME
stage_tables_ldts:
  primed_jaffle_shop_orders: LOAD_DATETIME
  primed_stripe_payments: LOAD_DATETIME
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{% set source_model = metadata_dict["source_model"] %}
{% set src_pk = metadata_dict["src_pk"] %}
{% set src_ldts = metadata_dict["src_ldts"] %}
{% set as_of_dates_table = metadata_dict["as_of_dates_table"] %}
{% set bridge_walk = metadata_dict["bridge_walk"] %}
{% set stage_tables_ldts = metadata_dict["stage_tables_ldts"] %}

{{ dbtvault.bridge(source_model=source_model, src_pk=src_pk,
                   src_ldts=src_ldts,
                   bridge_walk=bridge_walk,
                   as_of_dates_table=as_of_dates_table,
                   stage_tables_ldts=stage_tables_ldts) }}