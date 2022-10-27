{% snapshot phm_providers_snapshot %}

{{
    config(
      target_schema='raw_stage',
      strategy='check',
      unique_key='provider_id',
      check_cols='all'
    )
}}

select * 
from {{ source('healthcare_raw_stg', 'phm_providers_with_key') }}

{% endsnapshot %}
