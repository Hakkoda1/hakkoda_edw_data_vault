{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_model: "v_company_2"
src_pk: "HUB_COMPANY_HKEY"
src_hashdiff: 
  source_column: "SAT_COMPANY_DETAILS_HASHDIFF"
  alias: "HASH_DIFF"
src_payload:
    exclude_columns: true
    columns:
        - "COMPANY_NAME"
        - "PROPERTY_NAME"
        - "dbt_scd_id"
        - "dbt_updated_at"
        - "dbt_valid_from" 
        - "dbt_valid_to"
        - "SAT_COMPANY_DETAILS_HASHDIFF"
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
