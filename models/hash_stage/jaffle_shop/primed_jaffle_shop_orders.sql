{{ config(
    tags=["order","jaffle_shop"]
) }}

{%- set yaml_metadata -%}
source_model: "stage_jaffle_shop_orders"
derived_columns:
  RECORD_SOURCE: "!Jaffle Shop"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  ORDER_ID: "ID"
  CUSTOMER_ID: "USER_ID"
hashed_columns:
  HUB_ORDER_HKEY: "ORDER_ID"
  HUB_CUSTOMER_HKEY: "CUSTOMER_ID"
  LNK_ORDER_CUSTOMER_HKEY:
    - 'ORDER_ID'
    - 'CUSTOMER_ID'
  LSAT_ORDER_DETAILS_HASHDIFF:
    is_hashdiff: true
    exclude_columns: true
    columns:
      - "ID"
      - "USER_ID"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=none) }}