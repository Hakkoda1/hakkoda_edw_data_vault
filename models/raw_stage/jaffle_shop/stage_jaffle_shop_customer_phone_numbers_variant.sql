{{ config(
    tags=["phone_numbers", "jaffle_shop", "customer"]
) }}

{# Use Object Construct function to create a variant from sample dataset of phone numbers to align 
with existing Jaffle Shop customers to show alternative to Multi-active satellite #}
select id,
object_construct(
    'phone_numbers',
    array_agg(
        object_construct(
            'phone_type', phone_type,
            'phone_number', phone_number
        ) 
    )
 ) phone_numbers
from {{ref('stage_jaffle_shop_customer_phone_numbers')}}
group by 1