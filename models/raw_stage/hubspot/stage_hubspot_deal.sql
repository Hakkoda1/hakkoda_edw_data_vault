{{ 
  config(
    tags=["hubspot"]
  )
}}


SELECT d.*
,dps.LABEL AS pipeline_stage_label 
,o.EMAIL AS deal_owner_email
--,cu.PROPERTY_EMAIL AS deal_updated_by_owner_email
--,cc.PROPERTY_EMAIL AS deal_created_by_owner_email
FROM {{ source('hubspot', 'deal') }} d
LEFT JOIN {{ source('hubspot', 'owner') }} o ON d.OWNER_ID = o.OWNER_ID
LEFT JOIN {{ source('hubspot', 'deal_pipeline_stage') }} dps ON d.DEAL_PIPELINE_STAGE_ID = dps.STAGE_ID
--LEFT JOIN {{ source('hubspot', 'contact') }} cu ON d.PROPERTY_HS_UPDATED_BY_USER_ID = cu.ID
--LEFT JOIN {{ source('hubspot', 'contact') }} cc ON d.PROPERTY_HS_CREATED_BY_USER_ID = cc.ID
