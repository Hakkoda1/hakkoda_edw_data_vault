{{ config(
    tags=["customer","jaffle_gaggle"]
) }}

with users as (
    select
        id,
        name,
        email,
        gaggle_id,
        created_at

    from {{ ref('raw_user') }}
)

select * from users