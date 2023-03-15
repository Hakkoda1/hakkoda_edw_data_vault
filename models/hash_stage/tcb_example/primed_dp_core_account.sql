{{ config(
    tags=["tcb"]
) }}

{%- set yaml_metadata -%}
source_model: "stage_dp_core_account"
derived_columns:
  RECORD_SOURCE: "!TCB Example - DPCORE Account"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: "CREATED_AT"
  ACCOUNT_ID: "ACCT_ID"
  COLLISION_KEY: '!DPCORE'
hashed_columns:
  HUB_ACCOUNT_HKEY:
    - 'COLLISION_KEY'
    - 'nvl(ACCOUNT_ID,to_varchar(-1))'  
  SAT_ACCOUNT_DP_CORE_HASHDIFF:
    is_hashdiff: true
    exclude_columns: true
    columns:
      - "ACCT_ID"
      - "CREATED_AT"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=none) }}