{{ 
    config(materialized='view') 
}}

{%- set yaml_metadata -%}
source_model: "company"
derived_columns:
  RECORD_SOURCE: "!Hubspot"
  LOAD_DATETIME: CURRENT_TIMESTAMP
  EFFECTIVE_FROM: "_FIVETRAN_SYNCED"
  COMPANY_NAME: "PROPERTY_NAME"
hashed_columns:
  HUB_COMPANY_HKEY: "PROPERTY_NAME"
  SAT_COMPANY_DETAILS_HASHDIFF:
    is_hashdiff: true
    exclude_columns: true
    columns:
      - "PROPERTY_NAME"
      - "dbt_scd_id"
      - "dbt_updated_at"
      - "dbt_valid_from" 
      - "dbt_valid_to"
      - "DBTVAULT_RANK"
ranked_columns:
  DBTVAULT_RANK:
    partition_by: "PROPERTY_NAME"
    order_by: "_FIVETRAN_SYNCED"      
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=metadata_dict['ranked_columns']) }}