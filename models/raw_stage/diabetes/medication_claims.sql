
select
    claim_id,
    patient_id,
    product_or_service_code as medication_code,
    product_or_service_description as medication_name,
    created as claim_date
from
    {{ source('healthcare_fhir', 'claim_item') }} ci left outer join
    {{ source('healthcare_fhir', 'claim') }} c on ci.claim_id = c.id inner join
    {{ ref("medications")}} m on ci.product_or_service_code = m.medication_code
