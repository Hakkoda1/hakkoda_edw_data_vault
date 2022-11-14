{{ config(
    tags=["sales"]
) }}

SELECT DEAL_NAME
,AMOUNT 
,DATE(CLOSED_AT) CLOSE_DATE 
,DATE(PROPERTY_PROJECT_START_DATE) PROJECT_START_DATE
,PIPELINE_STAGE_LABEL PIPELINE_STAGE 
,OWNER_FULL_NAME DEAL_OWNER
,d.DESCRIPTION DEAL_DESCRIPTION
,COMPANY_NAME 
,c.DESCRIPTION COMPANY_DESCRIPTION
,INDUSTRY
,c.STATE AS COMPANY_STATE
,COMPANY_ANNUAL_REVENUE
,PROPERTY_HS_PRIORITY PRIORITY
,PROPERTY_HS_IS_CLOSED IS_CLOSED
--,PROPERTY_HS_DAYS_TO_CLOSE 
,TO_TIMESTAMP(PROPERTY_HS_LASTMODIFIEDDATE) LAST_MODIFIED_DATE
,PROPERTY_CLIENT_STACK_REQUIREMENTS CLIENT_STACK_REQUIREMENTS
,PROPERTY_CLIENT_STACK CLIENT_STACK
,PROPERTY_DEALTYPE DEAL_TYPE
,PROPERTY_NET_NEW_FOR_SNOWFLAKE_ IS_NET_NEW_FOR_SNOWFLAKE
,PROPERTY_REGISTERED_WITH_SNOWFLAKE_ IS_REGISTERED_WITH_SNOWFLAKE
--,PROPERTY_PROJECT_DURATION_ 
,PROPERTY_LEAD_SOURCE LEAD_SOURCE
,PROPERTY_PARTNER PARTNER
,PROPERTY_CLOSED_LOST_REASON CLOSED_LOST_REASON
,PROPERTY_COMPETITOR_S_ COMPETITOR
,PROPERTY_OTHER_COMPETITOR OTHER_COMPETITOR
--,PROPERTY_LOST_REASON 
,CASE
    WHEN INDUSTRY IN (
        'HOSPITAL_HEALTH_CARE'
        ,'BIOTECHNOLOGY'
        ,'HEALTH_WELLNESS_AND_FITNESS'
        ,'MEDICAL_DEVICES'
        ,'MEDICAL_PRACTICE'
        ,'MENTAL_HEALTH_CARE'
        ,'PHARMACEUTICALS'
        ) THEN 'Healthcare'
    WHEN INDUSTRY IN (
        'BANKING'
        , 'FINANCIAL_SERVICES'
        ,'CAPITAL_MARKETS'
        ,'INVESTMENT_BANKING'
        ,'INVESTMENT_MANAGEMENT'
        ,'VENTURE_CAPITAL_PRIVATE_EQUITY'
        ) THEN 'FSI'
END AS RESPONSIBLE_PRACTICE
,CASE 
    WHEN DEAL_NAME LIKE '%VCU Health%' THEN 'Migration'
    WHEN DEAL_NAME LIKE '%Migration%' THEN 'Migration'
    WHEN DEAL_NAME LIKE '%migration%' THEN 'Migration'
    WHEN DEAL_NAME LIKE '%Data Lake%' THEN 'Migration'
    WHEN DEAL_NAME LIKE '%Data Vault%' THEN 'Implementation'
    WHEN DEAL_NAME LIKE '%Capacity%' THEN 'Scale Teams'
    WHEN DEAL_NAME LIKE '%Scalable%' THEN 'Scale Teams'
     END
AS ARCHETYPE
,CASE 
    WHEN DEAL_NAME LIKE '%UCHealth%' THEN 'Steamroller'
    WHEN DEAL_NAME LIKE '%VCU Health%' THEN 'SnowFactory'
    WHEN DEAL_NAME LIKE '%Ampr%' THEN 'Ampr'
    WHEN DEAL_NAME LIKE '%Aloha%' THEN 'Aloha'
    WHEN DEAL_NAME LIKE '%Looking Glass%' THEN 'Looking Glass'
    WHEN DEAL_NAME LIKE '%Price Transparency%' THEN 'Looking Glass'
     END
AS ACCELERATOR
FROM {{ref('hubspot__deals')}} d 
INNER JOIN {{source('hubspot', 'deal_company')}} dc ON d.DEAL_ID = dc.DEAL_ID 
INNER JOIN {{ref('hubspot__companies')}} c ON c.COMPANY_ID = dc.COMPANY_ID
INNER JOIN {{source('hubspot', 'deal')}} sd ON sd.DEAL_ID = d.DEAL_ID