{#Set Entity Name to be used model file#}
{% set entity_name = "contact" %}

select *
{{ optionset_select( entity_name=entity_name ) }}
FROM {{ ref('stg_customers') }}
{{ optionset_join( entity_name=entity_name ) }}
