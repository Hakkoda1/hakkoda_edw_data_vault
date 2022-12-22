 -- insert_ghost_record_to_satellite.sql
 -- {{ insert_ghost_record_to_satellite('sat_vetspire_stg_locations_location') }}
{% macro insert_ghost_record_to_satellite(sat_name) %}
  {# Takes input metadata for Satellite name to generate and execute the insert statement of a ghost record to a satellite. #}

{% set table_schema = schema %}


{% set hkey_query %}
    select column_name hkey_name
    from information_schema.columns
    where lower(table_schema) = lower('{{ table_schema }}')
    and lower(table_name) = lower('{{ sat_name }}') 
    and column_name like '%_KEY'
    and ordinal_position = 1
{% endset %}

{% set results = run_query(hkey_query) %}

{% if execute %}
{# Return the first column #}
{% set hkey_list = results.columns[0].values() %}
{% else %}
{% set hkey_list = [] %}
{% endif %}

{% set hashdiff_query %}
    select column_name hashdiff_name
    from information_schema.columns
    where lower(table_schema) = lower('{{ table_schema }}')
    and lower(table_name) = lower('{{ sat_name }}') 
    and column_name = 'HASH_DIFF'
{% endset %}

{% set results = run_query(hashdiff_query) %}

{% if execute %}
{# Return the first column #}
{% set hashdiff_list = results.columns[0].values() %}
{% else %}
{% set hashdiff_list = [] %}
{% endif %}

    INSERT INTO RAW_VAULT.{{ sat_name }} ({% for hkey_name in hkey_list %}{{ hkey_name }}{% endfor %},{% for hashdiff_name in hashdiff_list %}{{ hashdiff_name }}{% endfor %}, EFFECTIVE_FROM, LOAD_DATETIME, RECORD_SOURCE)
    WITH GHOST_RECORD AS (
        SELECT TO_BINARY(REPEAT('0', 16)) HKEY
        ,REPEAT('0', 16) HASHDIFF
        ,TO_TIMESTAMP('1900-01-01') EFFECTIVE_FROM
        ,TO_TIMESTAMP('1900-01-01') LOAD_DATETIME
        ,'SYSTEM' RECORD_SOURCE
        )
    SELECT *
    FROM GHOST_RECORD S
    WHERE NOT EXISTS (
        SELECT *
        FROM RAW_VAULT.{{ sat_name }} S2
        WHERE S.HKEY = S2.{% for hkey_name in hkey_list %}{{ hkey_name }}{% endfor %}
        )

{% endmacro %}