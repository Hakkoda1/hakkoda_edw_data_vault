{{ config(
    tags=["customer","jaffle_gaggle"]
) }}

{% set personal_emails = get_personal_emails() %}

WITH LATEST_SAT_RECORD AS (
    SELECT *
    FROM {{ref('hsat_customer_gaggle_user_details_crm')}} s
    {{qualify_latest_satellite_records('s.HUB_CUSTOMER_HKEY', 's.LOAD_DATETIME')}} 
)
SELECT HUB_CUSTOMER_HKEY
,{{ extract_email_domain('email') }} AS email_domain
,iff(email_domain in {{ personal_emails }}, null, email_domain)  as corporate_email
,CURRENT_TIMESTAMP AS LOAD_DATETIME
,'Computed' AS RECORD_SOURCE
FROM LATEST_SAT_RECORD
