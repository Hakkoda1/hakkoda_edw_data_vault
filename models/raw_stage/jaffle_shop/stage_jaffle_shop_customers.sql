{{ config(
    tags=["customer","jaffle_shop"]
) }}

with customers as (

    select
        id,
        first_name,
        last_name

    from {{ source('jaffle_shop', 'customers') }}
)

select * from customers