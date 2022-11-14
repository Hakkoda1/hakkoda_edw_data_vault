{{ 
    config(
        tags=["master_provider"]
        ) 
}}


select * 
from {{source('healthcare_raw_stg','phm_providers_with_key') }}