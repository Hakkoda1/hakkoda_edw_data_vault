{{ config(
    tags=["tcb"]
) }}

select *
,CURRENT_TIMESTAMP CREATED_AT
from {{ ref('ln_core_account') }}