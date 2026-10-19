SELECT A.*
      FROM (
          SELECT A._DATE, A._NAME, A._COUNT
               , (A._VALUE + B.POSTFIX) AS _VALUE
               , A._DATE_SEQ, A.WEEK_SEQ, A._TYPE
               , B.POST_ORDER
          FROM (
              SELECT YYYYMMDD AS _DATE
                    ,SUBSTRING(YYYYMMDD,1,4) + '-' + SUBSTRING(YYYYMMDD,5,2) + '-' + SUBSTRING(YYYYMMDD,7,2) + ' '
                    +(CASE WHEN DAY_SEQ=2 THEN '(Mon)'
                           WHEN DAY_SEQ=3 THEN '(Tue)'
                           WHEN DAY_SEQ=4 THEN '(Wed)'
                           WHEN DAY_SEQ=5 THEN '(Thu)'
                           WHEN DAY_SEQ=6 THEN '(Fri)'
                           WHEN DAY_SEQ=7 THEN '(Sat)'
                           ELSE '(SUN)' END)
                    AS _NAME
                    , 1 AS _COUNT
                    ,'D' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS _VALUE
                    , 1 AS _DATE_SEQ
                    , YYYYWW AS WEEK_SEQ
                    , 'D' AS _TYPE
              FROM   TH_UIS_CAL A WITH(NOLOCK)
              WHERE  YYYYMMDD BETWEEN @BUCKET_FROM AND @BUCKET_TO
          ) A
          INNER JOIN (
              SELECT '_QTY' AS POSTFIX, 10 AS POST_ORDER
          ) B
          ON     1=1
          --UNION ALL
          --SELECT A._DATE, A._NAME, A._COUNT
          --     , (A._VALUE + B.POSTFIX) AS _VALUE
          --     , A._DATE_SEQ, A.WEEK_SEQ, A._TYPE
          --     , B.POST_ORDER
          --FROM (
          --    SELECT ISO_YYYYWW AS _DATE
          --         , (SUBSTRING(ISO_YYYYWW,1,4) + 'W' + SUBSTRING(ISO_YYYYWW,5,2)) AS _NAME
          --         , COUNT(*) AS _COUNT
          --         , 'W' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS _VALUE
          --         , 1 AS _DATE_SEQ
          --         , ISO_YYYYWW AS WEEK_SEQ
          --         , 'W' AS _TYPE
          --    FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)
          --    WHERE  CAL.DT >= CONVERT(DATETIME, @BUCKET_FROM, 112)
          --    AND    CAL.DT <= CONVERT(DATETIME, @BUCKET_TO, 112)
          --    GROUP BY ISO_YYYYWW
          --) A
          --INNER JOIN (
          --    SELECT '_QTY' AS POSTFIX, 100 AS POST_ORDER
          --) B
          --ON     1=1
      ) A
      ORDER BY WEEK_SEQ, (CASE WHEN _TYPE = 'W' THEN 1 ELSE 2 END), _DATE, POST_ORDER