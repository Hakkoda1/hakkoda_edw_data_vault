{{ config(
    tags=["customer","jaffle_shop"]
) }}

{%- set yaml_metadata -%}
source_model: "stage_jaffle_gaggle_raw_gaggle_customer_reps"
derived_columns:
  RECORD_SOURCE: "!Jaffle Gaggle - raw_gaggle_customer_reps.csv"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: "UPDATED_AT"
  CUSTOMER_ID: "ID"
  EMPLOYEE_EMAIL: "REP_EMAIL"
  START_DATE: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  END_DATE: 'TO_TIMESTAMP(''9999-12-31 23:59:59.999999'')' 
hashed_columns:
  LNK_GAGGLE_CUSTOMER_REP_HKEY:
    - 'CUSTOMER_ID'
    - 'EMPLOYEE_EMAIL'
  HUB_CUSTOMER_HKEY: "CUSTOMER_ID"
  HUB_EMPLOYEE_HKEY: "EMPLOYEE_EMAIL"
  LSAT_GAGGLE_CUSTOMER_REP_CRM_HASHDIFF:
    is_hashdiff: true
    exclude_columns: true
    columns:
      - "ID"
      - "REP_EMAIL"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=none) }}