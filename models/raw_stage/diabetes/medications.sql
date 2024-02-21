{{ config(
    materialized="table"
) }}

select 
    distinct
    code:coding[0].code::text as medication_code,
    code:coding[0].display::text as medication_name
from
    {{ source('healthcare_fhir', 'fhir_medication') }}