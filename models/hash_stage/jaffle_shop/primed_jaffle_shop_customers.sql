{{ config(
    tags=["customer","jaffle_shop"]
) }}

{%- set yaml_metadata -%}
source_model: "stage_jaffle_shop_customers"
derived_columns:
  RECORD_SOURCE: "!Jaffle Shop"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  CUSTOMER_ID: "ID"
hashed_columns:
  HUB_CUSTOMER_HKEY: "CUSTOMER_ID"
  SAT_CUSTOMER_NAME_HASHDIFF:
    is_hashdiff: true
    exclude_columns: true
    columns:
      - "ID"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=none) }}