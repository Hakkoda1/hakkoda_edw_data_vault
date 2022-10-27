{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_model: "v_stg_products"
src_pk: "HUB_PRODUCT_HKEY"
src_hashdiff: 
  source_column: "PRODUCT_HASHDIFF"
  alias: "HASH_DIFF"
src_payload:
  - "ID"
  - "UNIT_PRICE"
  - "UNITS"
src_eff: "EFFECTIVE_FROM"
src_ldts: "LOAD_DATETIME"
src_source: "RECORD_SOURCE"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.sat(src_pk=metadata_dict["src_pk"],
                src_hashdiff=metadata_dict["src_hashdiff"],
                src_payload=metadata_dict["src_payload"],
                src_eff=metadata_dict["src_eff"],
                src_ldts=metadata_dict["src_ldts"],
                src_source=metadata_dict["src_source"],
                source_model=metadata_dict["source_model"])   }}
