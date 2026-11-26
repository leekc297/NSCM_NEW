SELECT (CASE WHEN YYYYMMDD >= @PLAN_DATE THEN 'Y' ELSE 'N' END) AS IS_PLAN
              ,'D' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS D_VALUE
              ,YYYYMMDD AS _DATE
              ,ISO_YYYYWW AS _WEEK
              ,MONTH AS _MONTH
              ,SUBSTRING(YYYYMMDD,1,4) + '-' + SUBSTRING(YYYYMMDD,5,2) + '-' + SUBSTRING(YYYYMMDD,7,2) + ' '
              +(CASE WHEN DAY_SEQ=2 THEN '(Mon.)'
                     WHEN DAY_SEQ=3 THEN '(Tue.)'
                     WHEN DAY_SEQ=4 THEN '(Wed.)'
                     WHEN DAY_SEQ=5 THEN '(Thu.)'
                     WHEN DAY_SEQ=6 THEN '(Fri.)'
                     WHEN DAY_SEQ=7 THEN '(Sat.)'
                     ELSE '(SUN.)' END)
              AS _DATE_TXT
              ,DAY_SEQ
        FROM   TH_UIS_CAL A WITH(NOLOCK)
        WHERE  YYYYMMDD BETWEEN @BUCKET_FROM AND @BUCKET_TO
        ORDER BY YYYYMMDD