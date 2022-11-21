{{ 
  config(
    tags=["order","jaffle_shop"]
  )
}}

SELECT h1.ORDER_ID ID
,h2.CUSTOMER_ID USER_ID 
,s.ORDER_DATE
,s.STATUS
FROM {{ref('lnk_order_customer')}} l
INNER JOIN {{ref('hub_order')}} h1 ON l.HUB_ORDER_HKEY = h1.HUB_ORDER_HKEY
INNER JOIN {{ref('hub_customer')}} h2 ON l.HUB_CUSTOMER_HKEY = h2.HUB_CUSTOMER_HKEY
INNER JOIN {{ref('lsat_order_details_jaffle_shop')}} s ON l.LNK_ORDER_CUSTOMER_HKEY = s.LNK_ORDER_CUSTOMER_HKEY
{{qualify_latest_satellite_records('l.LNK_ORDER_CUSTOMER_HKEY', 's.LOAD_DATETIME')}} 