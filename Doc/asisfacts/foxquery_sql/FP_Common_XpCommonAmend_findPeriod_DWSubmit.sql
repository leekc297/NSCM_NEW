SELECT @CURR_DATE AS START_DATE
           , CASE WHEN @MPP_WPP = 'WPP_OUT_QTY' THEN ( SELECT MAX(CCC.DATED7)
                                                        FROM   TH_UIS_CALENDAR CCC WITH(NOLOCK)
                                                        WHERE  CCC.D0 IN (
                                                            SELECT CC.ISO_YYYYWW
                                                            FROM   TH_UIS_CAL CC WITH(NOLOCK)
                                                            WHERE  CC.YYYYMMDD = (CONVERT(VARCHAR, CONVERT(DATETIME,@PLAN_DATE) + ((CONVERT(NUMERIC, ISNULL(A.ATTRIBUTE15,'8')))*7), 112))
                                                        ))
             --ELSE CONVERT(VARCHAR, DATEADD(DAY, -1, CONVERT(VARCHAR(6),DATEADD(MONTH,2,@CURR_DATE),112) + '01'), 112) END AS END_DATE
             ELSE CONVERT(VARCHAR, DATEADD(DAY, -1, CONVERT(VARCHAR(6),DATEADD(MONTH,2, CONVERT(VARCHAR, dbo.FN_SITE_TIME((SELECT MAX(VV.SITE_ID) FROM FP_INSTANCE_INFO_V VV WITH(NOLOCK) WHERE VV.INSTANCE_ID = @MASTER_ID)), 112) ),112) + '01'), 112) END AS END_DATE -- site 별 현지날짜로 변경... 20230531
      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
      WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
      AND    A.ACTIVE_FLAG      = 'Y'
      AND    A.SEGMENT1         = @MASTER_ID