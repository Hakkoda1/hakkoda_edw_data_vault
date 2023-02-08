/*
select
    h.hub_customer_hkey,
    h.customer_id,
    sum(s.amount) lifetime_payment_amount
from {{ ref("hub_customer") }} h
left join {{ ref("lnk_order_customer") }} loc on h.hub_customer_hkey = loc.hub_customer_hkey
inner join {{ ref("effsat_order_customer") }} esoc on loc.lnk_order_customer_hkey = esoc.lnk_order_customer_hkey
--inner join {{ ref("hub_order") }} ho on loc.hub_order_hkey = ho.hub_order_hkey
left join {{ ref("lnk_payment_order") }} lpo on ho.hub_order_hkey = lpo.hub_order_hkey
inner join {{ ref("effsat_order_customer") }} espo on lpo.lnk_payment_order_hkey = espo.lnk_payment_order_hkey
inner join {{ ref("lsat_payment_details_stripe") }} s on lpo.lnk_payment_order_hkey = s.lnk_payment_order_hkey and s.status = 'success'
group by h.hub_customer_hkey,
    h.customer_id 
*/    

select
    h.hub_customer_hkey,
    h.customer_id,
    sum(s.amount) lifetime_payment_amount
from {{ ref("hub_customer") }} h
inner join {{ ref("bridge_order_customer_payment") }} br on h.hub_customer_hkey = br.hub_customer_hkey
inner join {{ ref("lsat_payment_details_stripe") }} s on br.lnk_payment_order_hkey = s.lnk_payment_order_hkey and s.status = 'success'
group by h.hub_customer_hkey,
    h.customer_id     