SELECT CONVERT(VARCHAR, dbo.FN_SITE_TIME(@SITE_ID)- ( SELECT ISNULL(LLL2._DAY, CONVERT(NUMERIC,ISNULL(LLL.SEGMENT1,'0'))) AS _DAY
                                                        				FROM   SCM_SYS_LOOKUP_VALUE LLL WITH(NOLOCK)
                                                        				LEFT OUTER JOIN (
                                                        					SELECT CONVERT(NUMERIC,ISNULL(SEGMENT1,'0')) AS _DAY
                                                        					FROM   SCM_SYS_LOOKUP_VALUE LLL2 WITH(NOLOCK)
                                                        					WHERE  LLL2.LOOKUP_TYPE_CODE = 'WPP_DAY_RANGE_BY_INSTANCE'
                                                        					AND    LLL2.ACTIVE_FLAG = 'Y'
                                                        					AND    LLL2.SEGMENT2 = @MASTER_ID
                                                        				) LLL2
                                                        				ON 1=1
                                                        				WHERE LLL.LOOKUP_TYPE_CODE = 'WPP_DAY_RANGE') ,112) AS CURR_DATE
           , A.RELEASE_PLAN_ID, (CASE WHEN A.RELEASE_PLAN_ID = @PLAN_ID THEN 'Y' ELSE 'N' END) AS IS_LATEST_PLAN, A.RELEASE_TYPE AS RELEASE_VALUE
      FROM (
      	SELECT A.*
      		   , ROW_NUMBER() OVER (ORDER BY A.INSERT_TIME DESC) AS ROW_NUM
      		   , B.RELEASE_TYPE
      	FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)
      	INNER JOIN (
        		SELECT RR.INSTANCE_ID, (CASE WHEN RR.FACTORY_ID ='-' THEN RR.PLAN_GROUP_ID ELSE RR.FACTORY_ID END) AS RELEASE_TYPE
        		FROM   FP_RELEASE_PLAN_INFO_H RR WITH(NOLOCK)
        		WHERE  INSTANCE_ID     = @MASTER_ID
        		AND    RELEASE_PLAN_ID = @PLAN_ID
      	) B
      	ON  A.INSTANCE_ID = B.INSTANCE_ID
      	AND (CASE WHEN @CONFIRM_AREA = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END) = B.RELEASE_TYPE
      ) A
      WHERE A.ROW_NUM = 1