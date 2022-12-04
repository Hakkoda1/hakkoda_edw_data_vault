{{ config(
    tags=["customer","jaffle_shop"]
) }}

SELECT h.HUB_CUSTOMER_HKEY CUSTOMER_KEY
,GREATEST(s1.LOAD_DATETIME, s2.LOAD_DATETIME) AS EFFECTIVE_DATE
,CUSTOMER_ID
,FIRST_NAME 
,LAST_NAME
,NAME 
,EMAIL 
,EMAIL_DOMAIN 
,CORPORATE_EMAIL
,GAGGLE_ID 
,CREATED_AT
,FIRST_ORDER 
,MOST_RECENT_ORDER
,CUSTOMER_STATUS
,NUMBER_OF_ORDERS 
,LIFETIME_VALUE
FROM {{ref('pit_customer')}} p
INNER JOIN {{ref('hub_customer')}} h ON p.HUB_CUSTOMER_HKEY = h.HUB_CUSTOMER_HKEY
INNER JOIN {{ref('hsat_customer_name_jaffle_shop')}} s1 ON p."hsat_customer_name_jaffle_shop_PK" = s1.HUB_CUSTOMER_HKEY AND s1.LOAD_DATETIME = p."hsat_customer_name_jaffle_shop_LDTS"
INNER JOIN {{ref('hsat_customer_gaggle_user_details_crm')}} s2 ON p."hsat_customer_gaggle_user_details_crm_PK" = s2.HUB_CUSTOMER_HKEY AND s2.LOAD_DATETIME = p."hsat_customer_gaggle_user_details_crm_LDTS"
LEFT JOIN {{ref('sat_customer_order_history')}} co ON h.HUB_CUSTOMER_HKEY = co.HUB_CUSTOMER_HKEY
LEFT JOIN {{ref('sat_customer_gaggle_user_email_domains')}} ed ON h.HUB_CUSTOMER_HKEY = co.HUB_CUSTOMER_HKEY
{{qualify_latest_satellite_records('p.HUB_CUSTOMER_HKEY', 'p.AS_OF_DATE')}} 