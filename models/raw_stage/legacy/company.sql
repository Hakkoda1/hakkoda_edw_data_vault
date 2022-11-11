{{ 
    config(materialized='view') 
}}


SELECT *
FROM {{ ref('company_snapshot') }}
WHERE PROPERTY_NAME = 'Info-Via'