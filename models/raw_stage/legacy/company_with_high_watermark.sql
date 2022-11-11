{{ 
    config(materialized='view') 
}}


SELECT *
FROM {{ source('hubspot', 'company') }}
{% if var("is_incremental") == true %}
WHERE _fivetran_synced > (
    SELECT EVENT_TIMESTAMP
    FROM {{ ref('latest_waterlevel') }}
    WHERE event_model = 'company'
    AND status = 'SUCCEEDED'

    )
{% else %}{% endif %}
