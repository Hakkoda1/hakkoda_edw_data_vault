{{ 
    config(materialized='view') 
}}

{%- set yaml_metadata -%}
source_model: "phm_providers"
derived_columns:
  RECORD_SOURCE: "!PHM Provider Database Sample"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: "_FIVETRAN_SYNCED"
  COLLISION_KEY: "!PHM"
hashed_columns:
  HUB_PROVIDER_HKEY: 
    - "PROVIDER_ID"
    - "COLLISION_KEY"
  HASH_DIFF:
    is_hashdiff: true
    exclude_columns: true
    columns:
      - "PROVIDER_ID"
      - "_FIVETRAN_SYNCED"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=none) }}