{{ 
    config(materialized='view') 
}}

select s.* 
,T.VALUE::timestamp AS LAST_UPDATED
from healthcare.stg.kp_fhir_practitioner s,
table(flatten(input => s.META)) as T
WHERE T.PATH = 'lastUpdated'