{{ 
  config(
    tags=["customer","jaffle_shop"]
  )
}}

SELECT h.CUSTOMER_ID ID 
,s.first_name
,s.last_name
FROM {{ref('hub_jaffle_customer')}} h 
INNER JOIN {{ref('sat_jaffle_customer_details_jaffle_shop')}} s ON h.HUB_JAFFLE_CUSTOMER_HKEY = s.HUB_JAFFLE_CUSTOMER_HKEY
{{qualify_latest_satellite_records('h.HUB_JAFFLE_CUSTOMER_HKEY', 's.LOAD_DATETIME')}} 