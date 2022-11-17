{{ config(
    tags=["payment","stripe"]
) }}

select
    id,
    orderid,
    paymentmethod,
    status,

    -- amount is stored in cents, convert it to dollars
    {{ cents_to_dollars('amount') }} as amount,
    created

from {{ source('stripe', 'payment') }}