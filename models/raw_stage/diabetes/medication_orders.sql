with medication_orders as (

    select
        replace(encounter:reference::text, 'urn:uuid:' ) as encounter_id,
        replace(subject:reference::text, 'urn:uuid:' ) as patient_id,
        try_to_timestamp(authoredon) as created_time,
        id,
        intent,
        medicationcodeableconcept:coding[0].code::text as medication_code,
        medicationcodeableconcept:coding[0].display::text as medication_name,
        requester:display::text as ordering_provider,
        status
    from
        {{ source('healthcare_fhir', 'fhir_medicationrequest') }}
)

select * from medication_orders