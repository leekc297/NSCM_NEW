SELECT DISTINCT ATTRIBUTE2 AS PROD_TYPE
          FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
          WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
          AND    A.ACTIVE_FLAG = 'Y'
          AND    A.ATTRIBUTE5 = 'Y'
          AND    A.SEGMENT1 = @DIVISION_ID
          AND  (
          	SELECT A.SEGMENT1 AS INSTANCE_ID
          	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
          	WHERE  A.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
          	AND    A.ACTIVE_FLAG = 'Y'
          	AND    A.SEGMENT2 = 'Y'
          	AND    A.SEGMENT1 IN (
          		SELECT MAX(INSTANCE_ID)
          		FROM   FP_INSTANCE_LINE_V
          		WHERE  1=1
          		AND    FACTORY_ID   = @FACTORY_ID
          		AND    OPERATION_ID = @OPERATION_ID
          		AND    LINE_ID      = @LINE_ID
          	)
          ) IS NOT NULL