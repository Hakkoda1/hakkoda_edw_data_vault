{{ 
    config(materialized='view') 
}}

{%- set yaml_metadata -%}
source_model: "kp_fhir_practitioner"
derived_columns:
  RECORD_SOURCE: "!KP FHIR Practitioner"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: "LAST_UPDATED"
  PROVIDER_ID: "ID"
  COLLISION_KEY: "!KP"
hashed_columns:
  HUB_PROVIDER_HKEY: 
    - "PROVIDER_ID"
    - "COLLISION_KEY"
  HASH_DIFF:
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