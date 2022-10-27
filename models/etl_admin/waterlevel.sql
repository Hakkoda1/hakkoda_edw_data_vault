{{ 
    config(materialized='view') 
}}

WITH COMPUTED_STATUS AS (
    SELECT EVENT_MODEL, INVOCATION_ID, event_name
    ,IFF(
    EVENT_NAME = 'model deployment started' 
        AND LEAD(EVENT_NAME) OVER (PARTITION BY INVOCATION_ID, EVENT_MODEL ORDER BY EVENT_TIMESTAMP) = 'model deployment completed'
        , 'SUCCEEDED'
        , 'FAILED') AS STATUS
    FROM {{source('etl_admin','dbt_audit_log')}}
)
SELECT a.*
,b.status
FROM {{source('etl_admin','dbt_audit_log')}} a
LEFT JOIN COMPUTED_STATUS b 
    ON a.event_model = b.event_model 
    and a.invocation_id = b.invocation_id
    and a.event_name = b.event_name and b.event_name = 'model deployment started'