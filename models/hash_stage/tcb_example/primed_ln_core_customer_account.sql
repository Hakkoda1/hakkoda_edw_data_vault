{{ config(
    tags=["tcb"]
) }}

{%- set yaml_metadata -%}
source_model: "stage_ln_core_customer_account"
derived_columns:
  RECORD_SOURCE: "!TCB Example - LNCORE Customer Account"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: "CREATED_AT"
  CUSTOMER_ID: "CUST_ID"
  ACCOUNT_ID: "ACCT_ID"
  COLLISION_KEY: '!LNCORE'
hashed_columns:
  LNK_CUSTOMER_ACCOUNT_LENDING_HKEY:
    - 'COLLISION_KEY'
    - 'nvl(CUSTOMER_ID,to_varchar(-1))' 
    - 'COLLISION_KEY'
    - 'nvl(ACCOUNT_ID,to_varchar(-1))'     
  HUB_CUSTOMER_HKEY:
    - 'COLLISION_KEY'
    - 'nvl(CUSTOMER_ID,to_varchar(-1))' 
  HUB_ACCOUNT_HKEY:
    - 'COLLISION_KEY'
    - 'nvl(ACCOUNT_ID,to_varchar(-1))'      
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=none) }}