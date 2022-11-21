{{ config(
    tags=["order","stripe"]
) }}

{%- set payment_methods = ['bank_transfer', 'coupon', 'credit_card', 'gift_card'] -%}

WITH LATEST_SAT_RECORD AS (
    SELECT *
    FROM {{ref('lsat_payment_details_stripe')}} s
    {{qualify_latest_satellite_records('s.LNK_PAYMENT_ORDER_HKEY', 's.LOAD_DATETIME')}} 
)
,ORDER_AMOUNTS_BY_PAYMENT_METHOD AS (
    SELECT HUB_ORDER_HKEY,
    {% for payment_method in payment_methods -%}
        SUM(CASE WHEN PAYMENTMETHOD = '{{ payment_method }}' THEN AMOUNT ELSE 0 END) AS {{ payment_method }}_amount
        {%- if not loop.last -%}
        ,
        {%- else -%}

        {% endif %}
        {% endfor -%}
    ,CURRENT_TIMESTAMP AS LOAD_DATETIME
    ,'Computed' AS RECORD_SOURCE    
    FROM {{ref('lnk_payment_order')}} l
    INNER JOIN LATEST_SAT_RECORD s ON l.LNK_PAYMENT_ORDER_HKEY = s.LNK_PAYMENT_ORDER_HKEY
    WHERE STATUS = 'success'
    GROUP BY 1     
)
SELECT *
FROM ORDER_AMOUNTS_BY_PAYMENT_METHOD