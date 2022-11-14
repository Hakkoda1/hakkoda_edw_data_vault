{{ 
  config(
    tags=["ionis", "veeva_etmf"]
  )
}}

{%- set yaml_metadata -%}
source_model: "stage_veeva_etmf_study"
derived_columns:
  RECORD_SOURCE: "!Veeva ETMF"
  LOAD_DATETIME: 'TO_TIMESTAMP(''{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S.%f") }}'')'
  EFFECTIVE_FROM: "MODIFIED_DATE"
  PAYLOAD: "SRC_JSON"  
hashed_columns:
  HUB_STUDY_HKEY: "STUDY_PROTOCOL_NUMBER"
  SAT_STUDY_DETAILS_HASHDIFF:
    is_hashdiff: true
    exclude_columns: true
    columns:
      - "STUDY_PROTOCOL_NUMBER"
      - "MODIFIED_DATE"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  null_columns=none,
                  hashed_columns=metadata_dict['hashed_columns'],
                  ranked_columns=none) }}