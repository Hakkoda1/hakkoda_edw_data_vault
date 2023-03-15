--Lending Customer History
select customer_id 
,sl.firstname
,sl.lastname 
,sl.dob 
,sl.ssn
,sl.address
,sl.load_datetime
from {{ref('hub_tcb_customer')}} h 
inner join {{ref('hsat_customer_details_ln_core')}} sl on h.HUB_CUSTOMER_HKEY = sl.HUB_CUSTOMER_HKEY
order by sl.load_datetime

--Latest Lending Customer
select customer_id 
,sl.firstname
,sl.lastname 
,sl.dob 
,sl.ssn
,sl.address
,sl.load_datetime
from {{ref('hub_tcb_customer')}} h 
inner join {{ref('hsat_customer_details_ln_core')}} sl on h.HUB_CUSTOMER_HKEY = sl.HUB_CUSTOMER_HKEY
qualify row_number() over (partition by sl.HUB_CUSTOMER_HKEY order by sl.load_datetime desc) = 1

--Combined Customer Dimension - No Same-as-link
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
select h.hub_customer_hkey
,h.customer_id 
,coalesce(sd.firstname, sl.firstname) first_name
,coalesce(sd.lastname, sl.lastname) last_name
,coalesce(sd.dob, sl.dob) date_of_birth
,coalesce(sd.ssn, sl.ssn) ssn
,coalesce(sd.address, sl.address) address
,coalesce(sd.record_source, sl.record_source) record_source
from {{ref('hub_tcb_customer')}} h 
left join hsat_customer_details_dp_core_latest sd on h.HUB_CUSTOMER_HKEY = sd.HUB_CUSTOMER_HKEY
left join hsat_customer_details_ln_core_latest sl on h.HUB_CUSTOMER_HKEY = sl.HUB_CUSTOMER_HKEY

--Combined Customer Dimension - With Same-as-link
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
select h.hub_customer_hkey
,h.customer_id 
,coalesce(sd.firstname, sl.firstname) first_name
,coalesce(sd.lastname, sl.lastname) last_name
,coalesce(sd.dob, sl.dob) date_of_birth
,coalesce(sd.ssn, sl.ssn) ssn
,coalesce(sd.address, sl.address) address
from {{ref('sal_tcb_customer')}} sal
inner join {{ref('hub_tcb_customer')}} h on sal.MASTER_HUB_CUSTOMER_HKEY = h.HUB_CUSTOMER_HKEY
left join hsat_customer_details_dp_core_latest sd on sal.MASTER_HUB_CUSTOMER_HKEY = sd.HUB_CUSTOMER_HKEY
left join hsat_customer_details_ln_core_latest sl on sal.MASTER_HUB_CUSTOMER_HKEY = sl.HUB_CUSTOMER_HKEY