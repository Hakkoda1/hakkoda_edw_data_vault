{{ 
  config(
    tags=["ionis", "veeva_etmf"]
  )
}}

SELECT h.STUDY_PROTOCOL_NUMBER
,s.PAYLOAD AS SRC_JSON
FROM {{ref('hub_study')}} h 
INNER JOIN {{ref('sat_study_details_veeva_etmf')}} s ON h.HUB_STUDY_HKEY = s.HUB_STUDY_HKEY
{{qualify_latest_satellite_records('h.HUB_STUDY_HKEY')}} 