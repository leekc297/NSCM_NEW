SELECT CONVERT(VARCHAR, HISTORY_TIME, 20) AS HISTORY_TIME, CONVERT(VARCHAR, SUBMIT_TIME, 20) AS SUBMIT_TIME
          	 , CASE WHEN HISTORY_TIME IS NULL THEN 'N'  -- 보정자체를 안하면 패스
          	        WHEN HISTORY_TIME IS NOT NULL AND SUBMIT_TIME IS NULL THEN 'Y' -- 보정은 하고 전송은 안했으면 메세지 출력
          	        WHEN HISTORY_TIME IS NOT NULL AND SUBMIT_TIME IS NOT NULL AND HISTORY_TIME > SUBMIT_TIME  THEN 'Y' -- 보정, 전송 둘다했는데 전송시간보다 보정시간이 이후면 메세지 출력
          	   ELSE 'N' END AS IS_SUBMIT
          FROM (
            	-- AMEND 
              SELECT MAX(JOB_TIME) AS HISTORY_TIME
              FROM   @DW_TABLE A WITH(NOLOCK)
              WHERE  1=1
              AND    A.INSTANCE_ID = @INSTANCE_ID
              AND    A.FP_PLAN_ID  = @FP_PLAN_ID
          ) A
          , (
            	-- DW SUBMIT
            	SELECT MAX(INSERT_TIME) AS SUBMIT_TIME
            	FROM   FP_PROC_PARAMETER_H A WITH(NOLOCK)
            	WHERE  1=1
            	AND    CONDITION_TYPE  = 'FP_PLAN_ID'
            	AND    CONDITION_VALUE = @FP_PLAN_ID
          ) B