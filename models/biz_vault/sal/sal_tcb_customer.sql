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
,master_keys as (
select h.hub_customer_hkey
,h.customer_id 
,h.collision_key
,coalesce(sd.firstname, sl.firstname) first_name
,coalesce(sd.lastname, sl.lastname) last_name
,coalesce(sd.dob, sl.dob) date_of_birth
,coalesce(sd.ssn, sl.ssn) ssn
,coalesce(sd.address, sl.address) address
,coalesce(sd.record_source, sl.record_source) record_source
,coalesce(sd.hash_diff, sl.hash_diff) hash_diff
from {{ref('hub_tcb_customer')}} h 
left join hsat_customer_details_dp_core_latest sd on h.HUB_CUSTOMER_HKEY = sd.HUB_CUSTOMER_HKEY
left join hsat_customer_details_ln_core_latest sl on h.HUB_CUSTOMER_HKEY = sl.HUB_CUSTOMER_HKEY
where customer_id <> 8261
)
,duplicate_keys as (
select h.hub_customer_hkey
,h.customer_id 
,h.collision_key
,coalesce(sd.firstname, sl.firstname) first_name
,coalesce(sd.lastname, sl.lastname) last_name
,coalesce(sd.dob, sl.dob) date_of_birth
,coalesce(sd.ssn, sl.ssn) ssn
,coalesce(sd.address, sl.address) address
,coalesce(sd.record_source, sl.record_source) record_source
,coalesce(sd.hash_diff, sl.hash_diff) hash_diff
from {{ref('hub_tcb_customer')}} h 
left join hsat_customer_details_dp_core_latest sd on h.HUB_CUSTOMER_HKEY = sd.HUB_CUSTOMER_HKEY
left join hsat_customer_details_ln_core_latest sl on h.HUB_CUSTOMER_HKEY = sl.HUB_CUSTOMER_HKEY
where customer_id <> 567
)
select m.hub_customer_hkey master_hub_customer_hkey
,d.hub_customer_hkey duplicate_hub_customer_hkey
,100 as match_score
from master_keys m 
left join duplicate_keys d on m.hash_diff = d.hash_diff