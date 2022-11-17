{{ config(
    tags=["customer","jaffle_shop"]
) }}

WITH LATEST_SAT_RECORD AS (
    SELECT *
    FROM {{ref('sat_jaffle_customer_details_jaffle_shop')}} s
    {{qualify_latest_satellite_records('s.HUB_JAFFLE_CUSTOMER_HKEY', 's.LOAD_DATETIME')}} 
)
SELECT h.HUB_JAFFLE_CUSTOMER_HKEY JAFFLE_CUSTOMER_KEY
,s.LOAD_DATETIME AS EFFECTIVE_DATE
,CUSTOMER_ID
,FIRST_ORDER 
,MOST_RECENT_ORDER
,CUSTOMER_STATUS
,NUMBER_OF_ORDERS 
,LIFETIME_VALUE
FROM {{ref('hub_jaffle_customer')}} h
INNER JOIN LATEST_SAT_RECORD s ON h.HUB_JAFFLE_CUSTOMER_HKEY = s.HUB_JAFFLE_CUSTOMER_HKEY
INNER JOIN {{ref('sat_jaffle_customer_order_history')}} co ON h.HUB_JAFFLE_CUSTOMER_HKEY = co.HUB_JAFFLE_CUSTOMER_HKEY