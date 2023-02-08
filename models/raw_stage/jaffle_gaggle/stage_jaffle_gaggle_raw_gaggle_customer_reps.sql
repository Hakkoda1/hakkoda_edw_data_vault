{{ config(
    tags=["customer","jaffle_gaggle"]
) }}

with gaggle_customer_reps as (
    select
        id,
        rep_name,
        rep_email,
        updated_at
        
    from {{ ref('raw_gaggle_customer_reps') }}
)

select * from gaggle_customer_reps