{{ 
  config(
    tags=["customer","jaffle_shop"]
  )
}}

SELECT h.CUSTOMER_ID ID 
,s.first_name
,s.last_name
FROM {{ref('hub_customer')}} h 
INNER JOIN {{ref('hsat_customer_name_jaffle_shop')}} s ON h.HUB_CUSTOMER_HKEY = s.HUB_CUSTOMER_HKEY
{{qualify_latest_satellite_records('h.HUB_CUSTOMER_HKEY', 's.LOAD_DATETIME')}} 