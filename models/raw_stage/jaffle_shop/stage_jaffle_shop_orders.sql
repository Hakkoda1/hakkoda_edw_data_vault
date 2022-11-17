{{ config(
    tags=["order","jaffle_shop"]
) }}

with orders as (

    select
        id ,
        user_id ,
        order_date,
        status

    from {{ source('jaffle_shop', 'orders') }}

)

select * from orders