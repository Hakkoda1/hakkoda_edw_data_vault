{{ 
  config(
    tags=["hubspot"]
  )
}}


SELECT dc.*
,d.PROPERTY_DEALNAME DEAL_NAME
,c.PROPERTY_NAME COMPANY_NAME
FROM {{ source('hubspot', 'deal_company') }} dc
LEFT JOIN {{ source('hubspot', 'deal') }} d ON dc.DEAL_ID = d.DEAL_ID
LEFT JOIN {{ source('hubspot', 'company') }} c ON dc.COMPANY_ID = c.ID