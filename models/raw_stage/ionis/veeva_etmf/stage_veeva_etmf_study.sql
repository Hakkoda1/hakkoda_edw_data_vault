{{ 
  config(
    tags=["ionis", "veeva_etmf"]
  )
}}

WITH VEEVA_ETMF_STUDY AS (
SELECT TO_VARIANT(
    PARSE_JSON(
        '[{
    "VeevaStudyId": "0SC000000048003",
    "ClinicalStudyName": "696844-CS1",
    "Status": "Archived",
    "Phase": "Phase I",
    "Description": "A Masked,Placebo-Controlled,Dose-Escalation,Phase 1 Study to Assess the Safety,Tolerability,Pharmacokinetics and Pharmacodynamics of Single Doses of ISIS 696844 Administered Subcutaneously to Healthy Volunteers",
    "Indication": "AMD",
    "Compound": "696844",
    "StudyStartDate": "2012-09-21",
    "StudyPlannedEndDate": "2019-03-03",
    "StudyCloseDate": "2019-03-03",
    "IonisStudyId": "0SC000000048003",
    "CreatedDate": "2019-02-25T18:31:27.000Z",
    "ModifiedDate": "2022-09-16T17:26:25.000Z",
    "ModifiedBy": "jabctest@ionisph.com",
    "GlobalIdSys": "104281_0ST000000001001",
    "StudyPersonnel":
    [
        {
            "VeevaStudyPersonId": "OOZ000000000R06",
            "StudyRole": "Principal Investigator",
            "StartDate": "2019-02-25",
            "EndDate": "2019-02-25",
            "CreatedDate": "2021-07-30T14:43:42.000Z",
            "ModifiedDate": "2022-10-06T18:39:54.000Z",
            "ModifiedBy": "jabctest@ionisph.com",
            "GlobalIdSys": "104281_0ST000000001001",
            "Person":
            {
                "VeevaPersonId": "V0B000000000516",
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
                "Status": "",
                "VeevaNetworkID": "9b8adc2d-18cc-4e26-83c4-22d9adda5fd2",
                "CreatedDate": "2021-07-30T14:43:42.000Z",
                "ModifiedDate": "2022-10-06T18:39:54.000Z",
                "ModifiedBy": "jabctest@ionisph.com",
                "GlobalIdSys": "104281_0ST000000001001"
            },
            "ContactInfo":
            {
                "VeevaContactInfoId": "OOU000000000101",
                "VeevaContactInfoName": "CI-005220",
                "VeevaContactInfoTypeId": "OOT000000000B01",
                "VeevaContactInfoType": "Base Contact Information",
                "EffectiveDate": "2019-02-25",
                "ExpirationDate": "2019-02-25",
                "Status": "Active",
                "PhoneNumber": "+55 19 3521-7844",
                "FaxNumber": "+55 19 3521-7844",
                "Email": "barbara.ferrarezi@gmail.com",
                "AddressLine1": "2344 Laguna Del Mar Court",
                "AddressLine2": "Suite 104",
                "PostalZipCode": "78041",
                "StateProvinceRegion": "TX",
                "TownCity": "Laredo",
                "Country":
                {
                    "VeevaId": "00C000000048003",
                    "Country": "United States",
                    "CountryAbbreviation": "USA"
                },
                "VeevaOrgId": "0OR000000002W05",
                "OrganizationName": "Medpace",
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
            "StudyOrgId": "Medpace-SO-000007",
            "Status": "",
            "Lifecycle State": "",
            "VendorType": "OOT000000000Y02",
            "OrgName": "Bioclinica",
            "StartDate": "2019-02-25",
            "EndDate": "2019-02-25",
            "CreatedDate": "2022-02-28T22:33:41.000Z",
            "ModifiedDate": "2022-02-28T22:33:41.000Z",
            "GlobalIdSys": "104281_V0H000000001001",
            "Organization":
            {
                "VeevaOrgId": "0TB000000000K15",
                "Organization": "Medpace",
                "OrganizationType": "Vendor",
                "OrgNetworkMergedToRecordVid": "0OR000000001058",
                "Status": "Active",
                "LifeCycleState": "Active",
                "CreatedDate": "2022-02-28T22:33:41.000Z",
                "ModifiedDate": "2022-02-28T22:33:41.000Z",
                "GlobalIdSys": "104281_V0H000000001001"
            },
            "StudyCountry":
            {
                "VeevaStudyCountryId": "0SC000000048003",
                "Country": "United States",
                "CountryAbbreviation": "USA"
            }
        }
    ],
    "StudySites":
    [
        "0101",
        "0202",
        "0303"
    ]
}]'
    )
) AS SRC_JSON
)
SELECT t1.VALUE:ClinicalStudyName::STRING as STUDY_PROTOCOL_NUMBER
,t1.VALUE:ModifiedDate::STRING as MODIFIED_DATE
,t0.SRC_JSON
FROM VEEVA_ETMF_STUDY t0
, lateral flatten( input => SRC_JSON ) t1
