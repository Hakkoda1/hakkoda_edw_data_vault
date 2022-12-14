{%- set yaml_metadata -%}
source_model: primed_jaffle_shop_customer_phone_numbers
src_pk: HUB_CUSTOMER_HKEY
src_cdk: 
  - PHONE_TYPE
  - PHONE_NUMBER
src_hashdiff: HASHDIFF
src_eff: EFFECTIVE_FROM
src_ldts: LOAD_DATETIME
src_source: RECORD_SOURCE
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.ma_sat(src_pk=metadata_dict["src_pk"],
                   src_cdk=metadata_dict["src_cdk"],
                   src_hashdiff=metadata_dict["src_hashdiff"],
                   src_eff=metadata_dict["src_eff"],
                   src_ldts=metadata_dict["src_ldts"],
                   src_source=metadata_dict["src_source"],
                   source_model=metadata_dict["source_model"]) }}