{{ 
    config(materialized='view') 
}}

select s.* 
,T.VALUE::timestamp AS LAST_UPDATED
from {{source('healthcare_stg', 'kp_fhir_practitioner')}} s,
table(flatten(input => s.META)) as T
WHERE T.PATH = 'lastUpdated'