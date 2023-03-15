{{ config(
    tags=["tcb"]
) }}

select *
,CURRENT_TIMESTAMP CREATED_AT
from {{ ref('dp_core_customer') }}