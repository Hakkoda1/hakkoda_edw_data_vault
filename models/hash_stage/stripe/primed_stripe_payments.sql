{{ config(
    tags=["payment","stripe"]
) }}

{%- set yaml_metadata -%}
source_model: "stage_stripe_payments"
derived_columns:
  RECORD_SOURCE: "!Stripe"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: "CREATED"
  PAYMENT_ID: "ID"
  ORDER_ID: "ORDERID"
hashed_columns:
  HUB_ORDER_HKEY: "ORDER_ID"
  HUB_PAYMENT_HKEY: "PAYMENT_ID"
  LNK_PAYMENT_ORDER_HKEY:
    - 'PAYMENT_ID'
    - 'ORDER_ID'
  LSAT_PAYMENT_DETAILS_HASHDIFF:
    is_hashdiff: true
    exclude_columns: true
    columns:
      - "ID"
      - "ORDERID"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=none) }}