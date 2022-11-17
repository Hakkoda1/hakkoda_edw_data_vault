{{
  config(
    materialized = 'table',
    tags=["date"],
    transient=false
    )
}}
WITH DATE_SPINE AS (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="TRUNC(DATEADD('YEAR', -10, '2022-01-01'::DATE), 'YEAR')",
        end_date="TRUNC(DATEADD('YEAR', 10, CURRENT_DATE), 'YEAR')"
    )
    }}
)
, START_OF_WEEK AS (
    SELECT DATE
    ,MIN(DATE) OVER(PARTITION BY ROW_ID ORDER BY DATE ASC) AS FIRST_DAY_OF_WEEK
    ,MAX(DATE) OVER(PARTITION BY ROW_ID ORDER BY DATE DESC) AS LAST_DAY_OF_WEEK
    ,DATEADD(DAY, 7, MAX(DATE) OVER(PARTITION BY ROW_ID ORDER BY DATE DESC)) AS PAY_DATE2
    FROM (
        SELECT CEIL(ROW_NUMBER() OVER(ORDER BY DATE_DAY) / 7.0) AS ROW_ID
        , DATE_DAY AS DATE
        FROM DATE_SPINE 
        WHERE DATE_DAY >= '2013-05-25'  
        AND DATE_DAY <= (
            SELECT MAX(DATE_DAY) 
            FROM DATE_SPINE
    ) 
    ORDER BY 2
  ) 
  ORDER BY 1, 2
)
, PAY_PERIODS AS (
    SELECT DATE
    ,MIN(DATE) OVER(PARTITION BY ROW_ID ORDER BY DATE ASC) AS PAY_PERIOD_FROM_DATE
    ,MAX(DATE) OVER(PARTITION BY ROW_ID ORDER BY DATE DESC) AS PAY_PERIOD_TO_DATE
    ,DATEADD(DAY, 7, MAX(DATE) OVER(PARTITION BY ROW_ID ORDER BY DATE DESC)) AS PAY_DATE
    FROM (
        SELECT CEIL(ROW_NUMBER() OVER(ORDER BY DATE_DAY) / 14.0) AS ROW_ID
        , DATE_DAY AS DATE
        FROM DATE_SPINE 
        WHERE DATE_DAY >= '2019-05-25' 
        AND DATE_DAY <= (
            SELECT MAX(DATE_DAY) 
            FROM DATE_SPINE
    ) 
    ORDER BY 2
  ) 
  ORDER BY 1, 2
)
, MISSING_VALUE_KEY AS (
    SELECT '-1' AS MISSING_VALUE_KEY
    ,CURRENT_TIMESTAMP AS EFFECTIVE_DATE
    ,'-1' MISSING_VALUE_ID 
    ,'Missing Value' AS MISSING_VALUE_DESCRIPTION
)
, date_base as (
--, Placeholder for Adding Corporate Holidays and Pay Periods into CTE
SELECT COALESCE(REPLACE(TO_VARCHAR(DATE_DAY), '-', ''), MISSING_VALUE_KEY) AS DATE_KEY
, CAST(DATE_DAY AS DATE) AS DATE_VALUE
, DATE_DAY AS DATE_VARCHAR_YYYY_MM_DD
, TO_VARCHAR( DATE_VALUE, 'MM/DD/YYYY') AS DATE_VARCHAR_MM_DD_YYYY
, DAYNAME(DATE_VALUE) DAY_SHORT_NAME
, COALESCE(DECODE( DAY_SHORT_NAME,
  'Mon', 'Monday',
  'Tue', 'Tuesday',
  'Wed', 'Wednesday',
  'Thu', 'Thursday',
  'Fri', 'Friday',
  'Sat', 'Saturday',
  'Sun', 'Sunday'), MISSING_VALUE_DESCRIPTION) DAY_LONG_NAME
, DAYOFMONTH( DATE_VALUE ) AS DAY_OF_MONTH_NUMBER
--, DAYOFWEEK( DATE_VALUE ) AS DAY_OF_WEEK_NUMBER
,case 
         when day_short_name ='Sat' then 1
         when day_short_name ='Sun' then 2
         when day_short_name ='Mon' then 3
         when day_short_name ='Tue' then 4
         when day_short_name ='Wed' then 5
         when day_short_name ='Thu' then 6
         when day_short_name ='Fri' then 7
        else 0 
        end day_of_week_number

, DAYOFWEEKISO( DATE_VALUE ) as DAY_OF_WEEK_ISO_NUMBER
, DAYOFYEAR( DATE_VALUE ) AS DAY_OF_YEAR_NUMBER
, WEEKOFYEAR( DATE_VALUE ) AS WEEK_OF_YEAR_NUMBER
--, DATEADD(D,-3,TRUNC(DATE_VALUE, 'WEEK')) AS FIRST_DAY_OF_WEEK2
--, DATEADD(D,-3,LAST_DAY(DATE_VALUE, 'WEEK')) AS LAST_DAY_OF_WEEK2
--, TRUNC(DATE_VALUE, 'WEEK') AS FIRST_DAY_OF_WEEK1
--, LAST_DAY(DATE_VALUE, 'WEEK') AS LAST_DAY_OF_WEEK1
, SW.FIRST_DAY_OF_WEEK
, SW.LAST_DAY_OF_WEEK
--, WEEKISO( DATE_VALUE  ) AS WEEK_OF_YEAR_ISO_NUMBER
, MONTH( DATE_VALUE ) AS MONTH_NUMBER
, MONTHNAME( DATE_VALUE ) AS MONTH_SHORT_NAME
, DECODE( MONTH_NUMBER,
  1, 'January',
  2, 'February',
  3, 'March',
  4, 'April',
  5, 'May',
  6, 'June',
  7, 'July',  
  8, 'August',
  9, 'September',
  10, 'October',
  11, 'November',
  12, 'December') MONTH_LONG_NAME
, TRUNC( DATE_VALUE , 'MONTH') MONTH_BEGIN_DATE
, LAST_DAY( DATE_VALUE , 'MONTH') MONTH_END_DATE
, QUARTER( DATE_VALUE ) AS QUARTER_NUMBER
, CAST(YEAR( DATE_VALUE ) || QUARTER( DATE_VALUE ) AS INT) AS YEAR_QUARTER_NUMBER
, CAST(DATE_VALUE - TRUNC(DATE_VALUE, 'QUARTER') + 1 AS INT) AS DAY_OF_QUARTER_NUMBER
, CAST('Q' || QUARTER_NUMBER AS VARCHAR(5)) AS QUARTER_SHORT_NAME
, CAST('Quarter ' || QUARTER_NUMBER AS VARCHAR(50)) AS QUARTER_NAME
, TRUNC( DATE_VALUE , 'QUARTER') QUARTER_BEGIN_DATE
, LAST_DAY( DATE_VALUE , 'QUARTER') QUARTER_END_DATE
, YEAR( DATE_VALUE ) AS YEAR_NUMBER
, TRUNC( DATE_VALUE , 'YEAR') YEAR_BEGIN_DATE
, LAST_DAY( DATE_VALUE , 'YEAR') YEAR_END_DATE
, IFF( DAY_SHORT_NAME IN ('Sat', 'Sun'), TRUE, FALSE) IS_WEEKEND
, CAST(ROW_NUMBER() OVER (PARTITION BY YEAR( DATE_VALUE ), MONTH( DATE_VALUE ), DAYOFWEEK( DATE_VALUE ) ORDER BY DATE_VALUE) AS INT) AS ORDINAL_WEEKDAY_OF_MONTH
, CAST(
    CASE
    WHEN MONTH(DATE_VALUE) = 1 AND DAYOFMONTH(DATE_VALUE) = 1
    THEN 'New Year''s Day'
    WHEN MONTH(DATE_VALUE) = 1 AND DAYOFMONTH(DATE_VALUE) = 20 AND ((YEAR(DATE_VALUE) - 1) % 4) = 0
    THEN 'Inauguration Day'
    WHEN MONTH(DATE_VALUE) = 1 AND DAYOFWEEK(DATE_VALUE) = 2 AND ORDINAL_WEEKDAY_OF_MONTH = 3
    THEN 'Martin Luther King Jr Day'
    WHEN MONTH(DATE_VALUE) = 2 AND DAYOFMONTH(DATE_VALUE) = 14
    THEN 'Valentine''s Day'
    WHEN MONTH(DATE_VALUE) = 2 AND DAYOFWEEK(DATE_VALUE) = 2 AND ORDINAL_WEEKDAY_OF_MONTH = 3
    THEN 'President''s Day'
    WHEN MONTH(DATE_VALUE) = 3 AND DAYOFMONTH(DATE_VALUE) = 17
    THEN 'Saint Patrick''s Day'
    WHEN MONTH(DATE_VALUE) = 5 AND DAYOFWEEK(DATE_VALUE) = 1 AND ORDINAL_WEEKDAY_OF_MONTH = 2
    THEN 'Mother''s Day'
    WHEN MONTH(DATE_VALUE) = 5 AND DAYOFWEEK(DATE_VALUE) = 2 AND LAST_VALUE(DAYOFMONTH(DATE_VALUE)) OVER (PARTITION BY MONTH_NUMBER ORDER BY TO_DATE(DATE_VALUE)) - 7 <= DAYOFMONTH(DATE_VALUE)
    THEN 'Memorial Day'
    WHEN MONTH(DATE_VALUE) = 6 AND DAYOFWEEK(DATE_VALUE) = 1 AND ORDINAL_WEEKDAY_OF_MONTH = 3
    THEN 'Father''s Day'
    WHEN MONTH(DATE_VALUE) = 6 AND DAYOFMONTH(DATE_VALUE) = 19 
    THEN 'Juneteenth'
    WHEN MONTH(DATE_VALUE) = 7 AND DAYOFMONTH(DATE_VALUE) = 4
    THEN 'Independence Day'
    WHEN MONTH(DATE_VALUE) = 9 AND DAYOFWEEK(DATE_VALUE) = 2 AND ORDINAL_WEEKDAY_OF_MONTH = 1
    THEN 'Labor Day'
    WHEN MONTH(DATE_VALUE) = 10 AND DAYOFWEEK(DATE_VALUE) = 2 AND ORDINAL_WEEKDAY_OF_MONTH = 2
    THEN 'Columbus Day'
    WHEN MONTH(DATE_VALUE) = 10 AND DAYOFMONTH(DATE_VALUE) = 31
    THEN 'Halloween'
    WHEN MONTH(DATE_VALUE) = 11 AND DAYOFWEEK(DATE_VALUE) = 5 AND ORDINAL_WEEKDAY_OF_MONTH = 4
    THEN 'Thanksgiving Day'
    WHEN MONTH(DATE_VALUE) = 11 AND DAYOFWEEK(DATE_VALUE) = 6 AND ORDINAL_WEEKDAY_OF_MONTH = 4
    THEN 'Day After Thanksgiving'
    WHEN MONTH(DATE_VALUE) = 11 AND DAYOFMONTH(DATE_VALUE) = 11
    THEN 'Veterans''s Day'
     WHEN MONTH(DATE_VALUE) = 12 AND DAYOFMONTH(DATE_VALUE) = 24
    THEN 'Christmas Eve'
    WHEN MONTH(DATE_VALUE) = 12 AND DAYOFMONTH(DATE_VALUE) = 25
    THEN 'Christmas Day'
    WHEN MONTH(DATE_VALUE) = 12 AND DAYOFMONTH(DATE_VALUE) = 31
    THEN 'New Year''s Eve'
    ELSE NULL
    END AS VARCHAR(50)) AS HOLIDAY_DESC
, CAST(CASE WHEN HOLIDAY_DESC IS NULL THEN 0 ELSE 1 END AS BOOLEAN) AS IS_HOLIDAY
, CAST(CASE WHEN HOLIDAY_DESC IN ('New Year''s Day', 'Memorial Day', 'Juneteenth', 'Independence Day', 'Labor Day',
    'Thanksgiving Day', 'Christmas Eve', 'Christmas Day', 'New Year''s Eve') THEN 1 ELSE 0 END AS BOOLEAN) AS IS_FIELD_HOLIDAY
, CAST(CASE WHEN HOLIDAY_DESC IN ('New Year''s Day', 'Memorial Day', 'Juneteenth', 'Independence Day', 'Labor Day',
    'Thanksgiving Day', 'Day After Thanksgiving', 'Christmas Day', 'Martin Luther King Jr Day', 'Veterans''s Day') THEN 1 ELSE 0 END AS BOOLEAN) AS IS_VQ_HOLIDAY    
, case when day(DATE_VALUE) = day(last_day(DATE_VALUE)) then TRUE else FALSE end last_day_of_month
, NULL AS HOLIDAY_OBSERVED_DATE
, PAY_PERIOD_FROM_DATE
, PAY_PERIOD_TO_DATE
, PAY_DATE
, CASE 
      WHEN TO_CHAR(DATE_VALUE, 'MMDD') BETWEEN '0101' AND '0320' THEN 'WINTER'  
      WHEN TO_CHAR(DATE_VALUE, 'MMDD') BETWEEN '0321' AND '0621' THEN 'SPRING'
      WHEN TO_CHAR(DATE_VALUE, 'MMDD') BETWEEN '0622' AND '0922' THEN 'SUMMER'
      WHEN TO_CHAR(DATE_VALUE, 'MMDD') BETWEEN '0923' AND '1220' THEN 'FALL'
      WHEN TO_CHAR(DATE_VALUE, 'MMDD') BETWEEN '1221' AND '1231' THEN 'WINTER'
 END AS SEASON
FROM DATE_SPINE d 
LEFT JOIN PAY_PERIODS p ON d.DATE_DAY = p.DATE
LEFT JOIN START_OF_WEEK SW ON d.DATE_DAY = SW.DATE
FULL JOIN MISSING_VALUE_KEY mvc ON REPLACE(TO_VARCHAR(d.DATE_DAY), '-', '') = mvc.MISSING_VALUE_KEY
--WHERE DATE_KEY BETWEEN  '20221007' AND '20221026' 
ORDER BY DATE_KEY )
, prep_for_wk_info as
(
select  first_day_of_week fdow
    , last_day_of_week ldow
    , min(week_of_year_number) mn
    , max(week_of_year_number) mx
    , case when mn = 1 and mx in(52,53) then 1 else mx end week_of_year    
    ,max (is_holiday) week_is_holiday
    ,max (is_field_holiday) week_is_field_holiday
    ,max (is_vq_holiday) week_is_vq_holiday
from date_base 
where first_day_of_week is not null --date_key >= 20110101 --and week_of_year_number IN ( 1,52,53)
group by first_day_of_week, last_day_of_week
order by 2
)

SELECT DATE_KEY,
       DATE_VALUE,
       DATE_VARCHAR_YYYY_MM_DD,
       DATE_VARCHAR_MM_DD_YYYY,
       DAY_SHORT_NAME,
       DAY_LONG_NAME,
       DAY_OF_MONTH_NUMBER,
       DAY_OF_WEEK_NUMBER,
       DAY_OF_WEEK_ISO_NUMBER,
       DAY_OF_YEAR_NUMBER,
       WEEK_OF_YEAR_NUMBER,
       week_of_year,
       FIRST_DAY_OF_WEEK,
       LAST_DAY_OF_WEEK,
       MONTH_NUMBER,
       MONTH_SHORT_NAME,
       MONTH_LONG_NAME,
       MONTH_BEGIN_DATE,
       MONTH_END_DATE,
       QUARTER_NUMBER,
       YEAR_QUARTER_NUMBER,
       DAY_OF_QUARTER_NUMBER,
       QUARTER_SHORT_NAME,
       QUARTER_NAME,
       QUARTER_BEGIN_DATE,
       QUARTER_END_DATE,
       YEAR_NUMBER,
       YEAR_BEGIN_DATE,
       YEAR_END_DATE,
       IS_WEEKEND,
       ORDINAL_WEEKDAY_OF_MONTH,
       HOLIDAY_DESC,
       IS_HOLIDAY,
       IS_FIELD_HOLIDAY,
       IS_VQ_HOLIDAY,
       LAST_DAY_OF_MONTH,
       HOLIDAY_OBSERVED_DATE,
       PAY_PERIOD_FROM_DATE,
       PAY_PERIOD_TO_DATE,
       PAY_DATE,
       SEASON,   
        week_is_holiday,
        week_is_field_holiday,
        week_is_vq_holiday
    from date_base a
    inner join prep_for_wk_info b
        on a.first_day_of_week = b.fdow 
            and a.last_day_of_week = b.ldow
union 
select -1,
null,
null,
null,
null,
'Missing Value',
null,
0,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
null,
FALSE,
1,
null,
FALSE,
FALSE,
FALSE,
FALSE,
null,
null,
null,
null,
null,
FALSE,
FALSE,
FALSE

















