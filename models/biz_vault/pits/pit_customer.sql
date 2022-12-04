{{ config(
    materialized='pit_incremental',
    tags=["customer"]
) }}

{%- set yaml_metadata -%}
source_model: hub_customer
src_pk: HUB_CUSTOMER_HKEY
as_of_dates_table: as_of_date
satellites: 
  hsat_customer_name_jaffle_shop:
    pk:
      PK: HUB_CUSTOMER_HKEY
    ldts:
      LDTS: LOAD_DATETIME   
  hsat_customer_gaggle_user_details_crm:
    pk:
      PK: HUB_CUSTOMER_HKEY
    ldts:
      LDTS: LOAD_DATETIME                           
src_ldts: LOAD_DATETIME
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.pit(source_model=metadata_dict['source_model'], 
                src_pk=metadata_dict['src_pk'],
                as_of_dates_table=metadata_dict['as_of_dates_table'],
                satellites=metadata_dict['satellites'],
                src_ldts=metadata_dict['src_ldts']) }}