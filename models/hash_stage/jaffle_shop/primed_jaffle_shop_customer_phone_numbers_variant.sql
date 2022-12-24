{{ config(
    tags=["phone_numbers", "customer","jaffle_shop"]
) }}

{%- set yaml_metadata -%}
source_model: "stage_jaffle_shop_customer_phone_numbers_variant"
derived_columns:
  RECORD_SOURCE: "!Sample Phone Numbers"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  CUSTOMER_ID: "ID"
hashed_columns:
  HUB_CUSTOMER_HKEY: "CUSTOMER_ID"
  HASHDIFF:
    is_hashdiff: true
    columns:
      - "PAYLOAD"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=none) }}