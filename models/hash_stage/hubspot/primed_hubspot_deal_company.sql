{{ 
  config(
    tags=["hubspot"]
  )
}}

{%- set yaml_metadata -%}
source_model: "stage_hubspot_deal_company"
derived_columns:
  RECORD_SOURCE: "!Hubspot"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: "_FIVETRAN_SYNCED"
  CUSTOMER_NAME: "COMPANY_NAME"
hashed_columns:
  HUB_DEAL_HKEY: "DEAL_NAME"
  HUB_CUSTOMER_HKEY: "CUSTOMER_NAME"
  LNK_DEAL_CUSTOMER_HKEY:
    - 'DEAL_NAME'
    - 'CUSTOMER_NAME'  
  SAT_DEAL_COMPANY_DETAILS_HASHDIFF:
    is_hashdiff: true
    exclude_columns: true
    columns:
      - "DEAL_NAME"
      - "COMPANY_NAME"
      - "_FIVETRAN_SYNCED" 
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=none) }}