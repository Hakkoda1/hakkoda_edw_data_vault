{% snapshot company_snapshot %}

{{
        config(
          target_schema='raw_stage',
          strategy='timestamp',
          unique_key='id',
          updated_at='_fivetran_synced',
        )
}}

select * from {{ source('hubspot', 'company') }}

{% endsnapshot %}
