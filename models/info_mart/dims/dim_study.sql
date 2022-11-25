{{ 
  config(
    tags=["ionis", "veeva_etmf"]
  )
}}

SELECT h.HUB_STUDY_HKEY DIM_STUDY_TYPE1_KEY
,s.EFFECTIVE_FROM EFFECTIVE_DATE
,h.STUDY_PROTOCOL_NUMBER 
,t1.VALUE:VeevaStudyId::String AS VEEVA_STUDY_ID
,t1.VALUE:Compound::string AS STUDY_COMPOUND
,t1.VALUE:Phase::String AS PHASE 
,t1.VALUE:Description::String AS STUDY_DESCRIPTION
FROM {{ref('hub_study')}} h 
INNER JOIN {{ref('hsat_study_details_veeva_etmf')}} s ON h.HUB_STUDY_HKEY = s.HUB_STUDY_HKEY
, lateral flatten( input => PAYLOAD ) t1
{{qualify_latest_satellite_records('h.HUB_STUDY_HKEY', 's.LOAD_DATETIME')}} 