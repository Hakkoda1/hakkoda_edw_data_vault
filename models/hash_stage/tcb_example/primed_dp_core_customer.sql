{{ config(
    tags=["tcb"]
) }}

{%- set yaml_metadata -%}
source_model: "stage_dp_core_customer"
derived_columns:
  RECORD_SOURCE: "!TCB Example - DPCORE Customer"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: "CREATED_AT"
  CUSTOMER_ID: "ID"
  COLLISION_KEY: '!DPCORE'
hashed_columns:
  HUB_CUSTOMER_HKEY:
    - 'COLLISION_KEY'
    - 'nvl(CUSTOMER_ID,to_varchar(-1))'  
  SAT_CUSTOMER_DP_CORE_HASHDIFF:
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