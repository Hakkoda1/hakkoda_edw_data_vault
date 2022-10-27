{{ 
    config(materialized='view') 
}}


SELECT *
FROM {{ ref('waterlevel')}}
WHERE event_name = 'model deployment started'
QUALIFY ROW_NUMBER() OVER (PARTITION BY invocation_id, event_model ORDER BY event_timestamp) = 1