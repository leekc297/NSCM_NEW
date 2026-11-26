SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER
           , B.ATTRIBUTE3 AS USE_WOW_STATUS
           , B.ATTRIBUTE1 AS CONFIRM_AREA
           , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID
           , B.ATTRIBUTE14 AS ROUND_POINT
           , C.SITE_ID
           , ISNULL(D.FACTORY_YN, 'N') AS FACTORY_YN
      FROM (
			        	SELECT DISTINCT A.INSTANCE_ID
			        	FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)
			        	WHERE  USER_ID = @USER_ID
			      ) A
	      		LEFT OUTER JOIN (
								SELECT	SEGMENT1 AS INSTANCE_ID, 'Y' AS FACTORY_YN
								FROM	SCM_SYS_LOOKUP_VALUE                                                                                          		
								WHERE	1=1                                                                                                                       
								AND		LOOKUP_TYPE_CODE = 'FORM_TRAY_SIMUL_OPTION'                                                                      
								AND		ACTIVE_FLAG = 'Y'     				
								AND	    ATTRIBUTE1 = 'BUILDING'
								GROUP BY SEGMENT1
						) D
						ON 1=1
						AND A.INSTANCE_ID = D.INSTANCE_ID
						, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK), (
			          SELECT B.INSTANCE_ID, MAX(A.SITE_ID) AS SITE_ID
			          FROM   SCM_FACTORY_M A WITH(NOLOCK), FP_INSTANCE_FACTORY_M B WITH(NOLOCK)
			          WHERE  A.FACTORY_ID  = B.FACTORY_ID
			          AND    A.ACTIVE_FLAG = 'Y'
			          AND    B.ACTIVE_FLAG = 'Y'
			          GROUP BY B.INSTANCE_ID
					  ) C
      WHERE A.INSTANCE_ID      = B.SEGMENT1
      AND   A.INSTANCE_ID      = C.INSTANCE_ID
      AND   B.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
      AND   B.SEGMENT1 IN 	(
								SELECT INSTANCE_ID
								FROM   FP_AMEND_UI_V
								WHERE  AMEND_UI_NAME = @AMEND_INSTANCE
								AND    USE_FLAG = 'Y'
								--AND    INSTANCE_ID = 'KR_FORM_A'
								AND    INSTANCE_ID NOT IN ('CN_FORM_EB', 'CN_FORM_E') -- auto 만 보여줌
      						)
      AND   A.INSTANCE_ID NOT LIKE '%_M'
      ORDER BY B.SORT_ORDER