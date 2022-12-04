{{ config(
    tags=["customer","jaffle_shop"]
) }}

{%- set yaml_metadata -%}
source_model: "stage_jaffle_gaggle_raw_user"
derived_columns:
  RECORD_SOURCE: "!Jaffle Gaggle - raw_user.csv"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: "CREATED_AT"
  CUSTOMER_ID: "ID"
hashed_columns:
  HUB_CUSTOMER_HKEY: "CUSTOMER_ID"
  SAT_CUSTOMER_GAGGLE_USER_CRM_HASHDIFF:
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