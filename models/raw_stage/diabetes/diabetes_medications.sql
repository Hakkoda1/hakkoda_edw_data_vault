
select
    patient_id,
    created_time,
    medication_code,
    medication_name
from
    {{ ref("medication_orders")}} m
union
select
    patient_id,
    claim_date,
    medication_code,
    medication_name
from
    {{ ref("medication_claims")}}



