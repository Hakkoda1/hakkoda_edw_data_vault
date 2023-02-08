{{ config(
    tags=["payment","order","stripe"]
    ,is_auto_end_dating=true
) }}


{%- set yaml_metadata -%}
source_model: primed_stripe_payments
src_pk: LNK_PAYMENT_ORDER_HKEY
src_dfk: 
  - HUB_PAYMENT_HKEY
src_sfk:
  - HUB_ORDER_HKEY
src_start_date: START_DATE
src_end_date: END_DATE
src_eff: EFFECTIVE_FROM
src_ldts: LOAD_DATETIME
src_source: RECORD_SOURCE
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.eff_sat(src_pk=metadata_dict["src_pk"],
                    src_dfk=metadata_dict["src_dfk"],
                    src_sfk=metadata_dict["src_sfk"],
                    src_start_date=metadata_dict["src_start_date"],
                    src_end_date=metadata_dict["src_end_date"],
                    src_eff=metadata_dict["src_eff"],
                    src_ldts=metadata_dict["src_ldts"],
                    src_source=metadata_dict["src_source"],
                    source_model=metadata_dict["source_model"]) }}