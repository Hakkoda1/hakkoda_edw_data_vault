{{ config(
    tags=["tcb"]
    )    
}}

with hsat_customer_details_dp_core_latest as (
    select *
    from {{ref('hsat_customer_details_dp_core')}}
    qualify row_number() over (partition by HUB_CUSTOMER_HKEY order by LOAD_DATETIME DESC) = 1
)
,hsat_customer_details_ln_core_latest as (
    select *
    from {{ref('hsat_customer_details_ln_core')}}
    qualify row_number() over (partition by HUB_CUSTOMER_HKEY order by LOAD_DATETIME DESC) = 1
)
select *
from {{ref('hub_tcb_customer')}} h 
left join hsat_customer_details_dp_core_latest sd on h.HUB_CUSTOMER_HKEY = sd.HUB_CUSTOMER_HKEY
left join hsat_customer_details_ln_core_latest sl on h.HUB_CUSTOMER_HKEY = sl.HUB_CUSTOMER_HKEY