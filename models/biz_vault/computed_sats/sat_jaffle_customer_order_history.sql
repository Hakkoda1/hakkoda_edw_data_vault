{{ config(
    tags=["customer","order","jaffle_shop"]
) }}

WITH LATEST_SAT_RECORD AS (
    SELECT *
    FROM {{ref('lsat_order_details_jaffle_shop')}} s
    {{qualify_latest_satellite_records('s.LNK_ORDER_CUSTOMER_HKEY', 's.LOAD_DATETIME')}} 
)
,CUSTOMER_ORDER AS (
    SELECT HUB_JAFFLE_CUSTOMER_HKEY
    ,MIN(ORDER_DATE) FIRST_ORDER 
    ,MAX(ORDER_DATE) MOST_RECENT_ORDER
    ,COUNT(l.HUB_ORDER_HKEY) NUMBER_OF_ORDERS 
    ,SUM(AMOUNT) LIFETIME_VALUE
    FROM {{ref('lnk_order_customer')}} l
    INNER JOIN LATEST_SAT_RECORD s ON l.LNK_ORDER_CUSTOMER_HKEY = s.LNK_ORDER_CUSTOMER_HKEY
    LEFT JOIN {{ref('sat_order_amounts')}} soa ON l.HUB_ORDER_HKEY = soa.HUB_ORDER_HKEY
    GROUP BY 1
)
SELECT HUB_JAFFLE_CUSTOMER_HKEY
,FIRST_ORDER
,MOST_RECENT_ORDER
,CASE
    WHEN MOST_RECENT_ORDER <= '2018-01-15' THEN 'Churned'
    WHEN MOST_RECENT_ORDER <= '2018-03-01' THEN 'Churn Risk'
    ELSE 'Healthy'
END AS CUSTOMER_STATUS
,NUMBER_OF_ORDERS    
,LIFETIME_VALUE
,CURRENT_TIMESTAMP AS LOAD_DATETIME
,'Computed' AS RECORD_SOURCE
FROM CUSTOMER_ORDER
