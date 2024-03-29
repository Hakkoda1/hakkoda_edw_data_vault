with query_history as (
    select split_part(query_tag, '|', 1) invocation_id
    ,split_part(query_tag, '|', 2) dbt_model_name
    ,query_id 
    ,session_id
    ,query_text 
    ,query_type
    ,user_name 
    ,role_name
    ,warehouse_name
    ,warehouse_size 
    ,execution_status 
    ,error_message
    ,start_time
    ,end_time 
    ,total_elapsed_time 
    ,bytes_scanned 
    ,rows_produced
    ,partitions_scanned 
    ,partitions_total 
    ,bytes_spilled_to_local_storage
from {{ source('account_usage', 'query_history') }}
where 1=1
and split_part(query_tag, '|', 2) <> ''
)
select *
from {{ ref('fct_dbt__test_executions') }} executions
inner join {{ref('dim_dbt__tests')}} dim_tests on executions.test_execution_id = dim_tests.test_execution_id
inner join query_history 
    on executions.command_invocation_id = query_history.invocation_id 
    and dim_tests.name = query_history.dbt_model_name
order by executions.run_started_at desc