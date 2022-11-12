{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: "stg_products"
derived_columns:
  RECORD_SOURCE: "!DUMMY"
  LOAD_DATETIME: CURRENT_TIMESTAMP
  EFFECTIVE_FROM: "FIVETRAN_SYNCED"
hashed_columns:
  HUB_PRODUCT_HKEY: "PRODUCT_NAME"
  PRODUCT_HASHDIFF:
    is_hashdiff: true
    columns:
      - "ID"
      - "UNIT_PRICE"
      - "UNITS"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=none) }}