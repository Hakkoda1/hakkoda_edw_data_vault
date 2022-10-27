{{ 
    config(materialized='view') 
}}


select * 
from {{ref('phm_providers_snapshot') }}
{% if var("is_incremental") == true %}
WHERE dbt_valid_to IS NULL
{% else %}{% endif %}