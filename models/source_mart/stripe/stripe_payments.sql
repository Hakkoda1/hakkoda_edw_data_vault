{{ 
  config(
    tags=["stripe","payment"]
  )
}}

SELECT h1.PAYMENT_ID ID
,h2.ORDER_ID ORDERID
,s.PAYMENTMETHOD
,s.STATUS
,s.AMOUNT
,s.CREATED
FROM {{ref('lnk_payment_order')}} l
INNER JOIN {{ref('hub_payment')}} h1 ON l.HUB_PAYMENT_HKEY = h1.HUB_PAYMENT_HKEY
INNER JOIN {{ref('hub_order')}} h2 ON l.HUB_ORDER_HKEY = h2.HUB_ORDER_HKEY
INNER JOIN {{ref('lsat_payment_details_stripe')}} s ON l.LNK_PAYMENT_ORDER_HKEY = s.LNK_PAYMENT_ORDER_HKEY
{{qualify_latest_satellite_records('l.LNK_PAYMENT_ORDER_HKEY', 's.LOAD_DATETIME')}} 