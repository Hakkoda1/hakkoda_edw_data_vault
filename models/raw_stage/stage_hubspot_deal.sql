{{ 
    config(materialized='view') 
}}


SELECT d.*
,dps.LABEL AS pipeline_stage_label 
,o.EMAIL AS deal_owner_email
FROM {{ source('hubspot', 'deal') }} d
LEFT JOIN {{ source('hubspot', 'owner') }} o ON d.OWNER_ID = o.OWNER_ID
LEFT JOIN {{ source('hubspot', 'deal_pipeline_stage') }} dps ON d.DEAL_PIPELINE_STAGE_ID = dps.STAGE_ID
