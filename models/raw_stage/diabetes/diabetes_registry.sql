select
    p.*,
    labs.*,
    meds.ace_date,
    meds.ace_medication
from
    {{ source("healthcare_fhir", "patient")}} p inner join
    (
        select 
            patient_id,
            max(case when observation_code = '718-7' then response_display end) as last_hba1c_value,
            max(case when observation_code = '718-7' then observation_time end) as last_hba1c_date,
            max(case when observation_code = '4544-3' then response_display end) as last_hematocrit_value,
            max(case when observation_code = '4544-3' then observation_time end) as last_hematocrit_date,
            max(case when observation_code = '39156-5' then response_display end) as last_bmi_value,
            max(case when observation_code = '39156-5' then observation_time end) as last_bmi_date,
            max(case when observation_code = '8462-4' then response_display end) as last_bp_diast_value,
            max(case when observation_code = '8462-4' then observation_time end) as last_bp_diast_date,
            max(case when observation_code = '8480-6' then response_display end) as last_dp_syst_value,
            max(case when observation_code = '8480-6' then observation_time end) as last_bp_syst_date,
            max(case when observation_code = '93030-5' then response_display end) as lack_transport_value,
            max(case when observation_code = '93030-5' then observation_time end) as lack_transport_date
        from
            (
                select
                    row_number() over(partition by patient_id, observation_code order by observation_time desc) as rn,
                    *
                from
                    {{ref('diabetes_labs')}}
            ) t
        where
            t.rn = 1 --latest observation
        group by patient_id
    ) labs on p.id = labs.patient_id left outer join
    (
        select
            t.patient_id,
            max(case when t.medication_code in ('314076') then t.created_time end) as ACE_date,
            max(case when t.medication_code in ('314076') then t.medication_name end) as ACE_medication
        from
            (
                select
                *,
                row_number() over(partition by patient_id order by created_time desc) rn
                from
                    {{ref('diabetes_medications')}}
                where
                    medication_code in ('314076')
            ) t
        where
            t.rn = 1
        group by
            t.patient_id
    ) meds on p.id = meds.patient_id