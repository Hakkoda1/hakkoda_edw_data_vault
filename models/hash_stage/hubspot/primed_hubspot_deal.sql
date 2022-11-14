{{ 
  config(
    tags=["hubspot"]
  )
}}

{%- set yaml_metadata -%}
source_model: "stage_hubspot_deal"
derived_columns:
  RECORD_SOURCE: "!Hubspot"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: "_FIVETRAN_SYNCED"
  DEAL_NAME: "PROPERTY_DEALNAME"
  PIPELINE_STAGE_NAME: "PIPELINE_STAGE_LABEL"
  EMPLOYEE_EMAIL_ADDRESS: "DEAL_OWNER_EMAIL"
hashed_columns:
  HUB_DEAL_HKEY: "DEAL_NAME"
  HUB_SALES_PIPELINE_STAGE_HKEY: "PIPELINE_STAGE_NAME"
  HUB_EMPLOYEE_HKEY: "EMPLOYEE_EMAIL_ADDRESS"
  LNK_SALES_PIPELINE_HKEY:
    - 'DEAL_NAME'
    - 'PIPELINE_STAGE_NAME'
    - 'EMPLOYEE_EMAIL_ADDRESS'
  SAT_DEAL_DETAILS_HASHDIFF:
    is_hashdiff: true
    exclude_columns: true
    columns:
      - "PROPERTY_DEALNAME"
      - "PIPELINE_STAGE_LABEL"
      - "DEAL_OWNER_EMAIL"
      - "_FIVETRAN_SYNCED" 
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=metadata_dict['ranked_columns']) }}