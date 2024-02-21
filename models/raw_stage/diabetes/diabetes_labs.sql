select
    replace(subject:reference::text, 'urn:uuid:' ) as patient_id,
    try_to_timestamp(o.effectivedatetime) observation_time,
    o.category:coding[0].display as observation_category,
    oc.code:coding[0].code::text as observation_code,
    oc.code:coding[0].display::text as observation_name,
    oc.valuecodeableconcept:coding[0].code as response_code,
    coalesce( 
        oc.valuecodeableconcept:coding[0].display::text,
        oc.valuequantity:value::text
        ) as response_display,
    oc.valuequantity:unit::text as response_units
from
    {{ source('healthcare_fhir', 'fhir_observation_component') }} oc left outer join
    {{ source('healthcare_fhir', 'fhir_observation') }} o on oc.parent_id = o.id
union
select
    replace(subject:reference::text, 'urn:uuid:' ) as patient_id,
    try_to_timestamp(effectivedatetime) observation_time,
    category:coding[0].display as observation_category,
    code:coding[0].code::text as observation_code,
    code:coding[0].display::text as observation_name,
    valuecodeableconcept:coding[0].code as response_code,    
    coalesce( 
        valuecodeableconcept:coding[0].display::text,
        valuequantity:value::text
        ) as response_display,
    valuequantity:unit::text as response_units
from
    {{ source('healthcare_fhir', 'fhir_observation') }} 