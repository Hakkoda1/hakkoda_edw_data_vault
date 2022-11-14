{{ 
    config(materialized='view') 
}}


select * 
from {{source('healthcare_raw_stg','phm_providers') }}