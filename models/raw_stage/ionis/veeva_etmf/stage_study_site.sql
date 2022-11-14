{{ 
  config(
    tags=["ionis", "veeva_etmf"]
  )
}}

WITH VEEVA_ETMF_STUDY_SITE AS (
SELECT TO_VARIANT(
    PARSE_JSON(
        '[
{
    "VeevaStudySiteId": "0SI000000000183",
    "SiteNumber": "2889",
    "SiteName": "Laguna Clinical Research Associates",
    "VeevaSiteNumber": "2889",
    "PartnerSiteId": "ABC",
    "VeevaStudyId": "0ST00000000B001",
    "ClinicalStudyName": "696844-CS1",
    "CreatedDate": "2021-07-30T14:43:42.000Z",
    "ModifiedDate": "2022-10-06T18:39:54.000Z",
    "ModifiedBy": "jabctest@ionisph.com",
    "GlobalIdSys": "104281_0ST000000001001",
    "Lifecycle State": "",
    "StudyCountry":
    {
        "VeevaStudyCountryId": "0SC000000048003",
        "Country": "United States",
        "CountryAbbreviation": "USA"
    },
    "OrganizationLocation":
    {
        "VeevaLocationId": "00L000000000175",
        "Organization":
        {
            "VeevaOrgId": "0OR000000000P44",
            "Organization": "Hamilton Centre for Kidney Research",
            "OrganizationTypeId": "OOT000000000I02",
            "OrganizationType": "Institution",
            "Status": "Active",
            "LifeCycleState": "Active"
        },
        "Name": "Laguna Clinical Research Associates",
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
        "CreatedDate": "2021-07-30T14:43:42.000Z",
        "ModifiedDate": "2022-10-06T18:39:54.000Z",
        "ModifiedBy": "jabctest@ionisph.com",
        "GlobalIdSys": "104281_0ST000000001001"
    },
    "PrincipalInvestigator":
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
        "GlobalIdSys": "104281_0ST000000001001",
        "ContactInfo": {
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
            "CreatedDate": "2021-07-30T14:43:42.000Z",
            "ModifiedDate": "2022-10-06T18:39:54.000Z",
            "ModifiedBy": "jabctest@ionisph.com",
            "GlobalIdSys": "104281_0ST000000001001"
        }
    },
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
            "ContactInfo": {
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
            "StudyOrgName": "Medpace-SO-000007",
            "StartDate": "2019-02-25",
            "EndDate": "",
            "Status": "",
            "Lifecycle State": "",
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
            }
        }
    ]
}
]'
    )
) AS SRC_JSON
)
SELECT t1.VALUE:ClinicalStudyName::STRING as STUDY_ID
,t1.VALUE:SiteNumber::STRING as SITE_NUMBER
,t1.VALUE:StudyCountry.Country::STRING as COUNTRY_NAME
,t1.VALUE:PrincipalInvestigator.VeevaNetworkID::STRING AS PRINCIPAL_INVESTIGATOR_ID
,t0.SRC_JSON
FROM VEEVA_ETMF_STUDY_SITE t0
, lateral flatten( input => SRC_JSON ) t1