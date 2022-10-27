{% snapshot stg_customers_snapshot %}

{{
    config(
      target_schema='snapshots',
      strategy='check',
      unique_key='customer_id',
      check_cols='all'
    )
}}

select * from {{ source('jaffle_shop', 'customers') }}

{% endsnapshot %}