{{ 
    config(materialized='view') 
}}

{%- set yaml_metadata -%}
source_model: "phm_providers"
derived_columns:
  RECORD_SOURCE: "!PHM Provider Database Sample"
  LOAD_DATETIME: 'DATEADD(milliseconds,-(ROW_NUMBER() OVER (PARTITION BY PROVIDER_ID ORDER BY dbt_valid_from DESC) - 1),TO_TIMESTAMP_NTZ(CURRENT_TIMESTAMP))'
  EFFECTIVE_FROM: "dbt_valid_from"
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
      - "dbt_scd_id"
      - "dbt_updated_at"
      - "dbt_valid_from" 
      - "dbt_valid_to"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=none) }}