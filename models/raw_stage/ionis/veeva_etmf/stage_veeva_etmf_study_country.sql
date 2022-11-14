{{ 
  config(
    tags=["ionis", "veeva_etmf"]
  )
}}

WITH VEEVA_ETMF_STUDY_COUNTRY AS (
SELECT TO_VARIANT(
    PARSE_JSON(
        '[
{
    "VeevaStudyCountryId": "0SC000000048003",
    "ClinicalStudyName": "696844-CS1",
    "Status": "Archived",
    "CreatedDate": "2021-07-30T14:43:42.000Z",
    "ModifiedDate": "2022-10-06T18:39:54.000Z",
    "ModifiedBy": "jabctest@ionisph.com",
    "GlobalIdSys": "104281_0ST000000001001",
    "Lifecycle State": "",
    "Country":
    {
        "VeevaCountryId": "0SC000000048003",
        "Country": "United States",
        "CountryAbbreviation": "USA"
    },
    "StudyPersonnel":
    [
        {
            "StudyRole": "Principal Investigator",
            "StartDate": "2019-02-25",
            "EndDate": "",
            "CreatedDate": "2021-07-30T14:43:42.000Z",
            "ModifiedDate": "2022-10-06T18:39:54.000Z",
            "ModifiedBy": "jabctest@ionisph.com",
            "GlobalIdSys": "104281_0ST000000001001",
            "Person":
            {
                "VeevaId": "0SC000000048003",
                "PersonType": "Investigator",
                "FirstName": "Damaris",
                "MiddleName": "Medpace",
                "LastName": "Vega",
                "NPINumber": "",
                "Email": "damaris_vega@junoresearch.us",
                "Mobile": "713-779-5494",
                "Language": "",
                "Timezone": "",
                "Locale": "",
                "VeevaNetworkID": "9b8adc2d-18cc-4e26-83c4-22d9adda5fd2",
                "CreatedDate": "2021-07-30T14:43:42.000Z",
                "ModifiedDate": "2022-10-06T18:39:54.000Z",
                "ModifiedBy": "jabctest@ionisph.com",
                "GlobalIdSys": "104281_0ST000000001001"
            }
        }
    ],
    "StudyOrganizations":
    [
        {
            "VeevaStudyOrgId": "0TB000000000K15",
            "StudyOrgName": "Medpace-SO-000007",
            "Status": "",
            "CreatedDate": "2021-07-30T14:43:42.000Z",
            "ModifiedDate": "2022-10-06T18:39:54.000Z",
            "ModifiedBy": "jabctest@ionisph.com",
            "GlobalIdSys": "104281_0ST000000001001",
            "Organization":
            {
                "VeevaId": "0TB000000000K15",
                "Organization": "Medpace",
                "OrganizationType": "Vendor",
                "Status": "Active",
                "LifeCycleState": "Active"
            },
            "StudyCountry":
            {
                "VeevaId": "0SC000000048003",
                "Country": "United States",
                "CountryAbbreviation": "USA"
            },
            "StartDate": "2019-02-25",
            "EndDate": "",
            "Lifecycle State": ""
        }
    ],
    "StudySites":
    [
        "0101",
        "0202",
        "0303"
    ]
}
]'
    )
) AS SRC_JSON
)
SELECT t1.VALUE:ClinicalStudyName::STRING as STUDY_ID
,t1.VALUE:Country.Country::STRING as COUNTRY_NAME
,t0.SRC_JSON
FROM VEEVA_ETMF_STUDY_COUNTRY t0
, lateral flatten( input => SRC_JSON ) t1

