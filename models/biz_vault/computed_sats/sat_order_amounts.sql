{{ config(
    tags=["order","stripe"]
) }}

WITH LATEST_SAT_RECORD AS (
    SELECT *
    FROM {{ref('lsat_payment_details_stripe')}} s
    {{qualify_latest_satellite_records('s.LNK_PAYMENT_ORDER_HKEY', 's.LOAD_DATETIME')}} 
)
,ORDER_AMOUNT AS (
    SELECT HUB_ORDER_HKEY
    ,SUM(CASE WHEN STATUS = 'success' THEN AMOUNT END) AMOUNT 
    FROM {{ref('lnk_payment_order')}} l
    INNER JOIN LATEST_SAT_RECORD s ON l.LNK_PAYMENT_ORDER_HKEY = s.LNK_PAYMENT_ORDER_HKEY
    GROUP BY 1
      
)
SELECT HUB_ORDER_HKEY
,COALESCE(AMOUNT, 0) as AMOUNT   
,CURRENT_TIMESTAMP AS LOAD_DATETIME
,'Computed' AS RECORD_SOURCE
FROM ORDER_AMOUNT
