{{ config(
    tags=["order","jaffle_shop"]
) }}

WITH LATEST_SAT_RECORD AS (
    SELECT *
    FROM {{ref('lsat_order_details_jaffle_shop')}} s
    {{qualify_latest_satellite_records('s.LNK_ORDER_CUSTOMER_HKEY', 's.LOAD_DATETIME')}} 
)
SELECT l.LNK_ORDER_CUSTOMER_HKEY FACT_ORDER_KEY
,s.LOAD_DATETIME AS EFFECTIVE_DATE
,l.HUB_JAFFLE_CUSTOMER_HKEY JAFFLE_CUSTOMER_KEY
,{{generate_date_key_from_timestamp('ORDER_DATE')}} ORDER_DATE_KEY
,ORDER_ID
,ORDER_DATE
,STATUS ORDER_STATUS
,AMOUNT
FROM {{ref('lnk_order_customer')}} l
INNER JOIN {{ref('hub_order')}} h ON l.HUB_ORDER_HKEY = h.HUB_ORDER_HKEY
INNER JOIN LATEST_SAT_RECORD s ON l.LNK_ORDER_CUSTOMER_HKEY = s.LNK_ORDER_CUSTOMER_HKEY
INNER JOIN {{ref('sat_order_amounts')}} oa ON l.HUB_ORDER_HKEY = oa.HUB_ORDER_HKEY