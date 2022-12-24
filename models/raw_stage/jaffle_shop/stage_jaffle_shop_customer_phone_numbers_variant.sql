{{ config(
    tags=["phone_numbers", "jaffle_shop", "customer"]
) }}

select id
,array_agg(
    object_construct(
        'phone_type', phone_type,
        'phone_number', phone_number
    )
) within group (order by phone_type) payload
from {{ref('stage_jaffle_shop_customer_phone_numbers')}}
group by 1
order by 1