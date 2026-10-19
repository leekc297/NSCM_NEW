



/**
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : dbo.FN_SCP_PLN_RUNNING_TIME_V
  * DESCRIPTION   : 속도 계선을 위한 엔진 OUTPUT 실행시간 조회
                    사업부별 중복해서 엔진 수행 한경우는 체크안됨.
                    SCM_SYS_LOG_BATCH 에 로그가 있어야 함.

                   SELECT * FROM dbo.FN_SCP_PLN_RUNNING_TIME_V('PR','20181224','EE') -- ORDER BY orderNo2, OrderNo1, No

  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-12-27   KTH             INITIAL 
  * 2022-03-23   KSG             PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
  * 2022.04.29   sclee           PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가관련 @p_division_id NVARCHAR(2) -> NVARCHAR(10)으로 변경
  * 2023.03.23	 hrkim			 PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
  */
CREATE FUNCTION [dbo].[FN_SCP_PLN_RUNNING_TIME_V]  
(
 @p_plan_type     NVARCHAR(2) 
,@p_plan_date     NVARCHAR(8) =''

-- PJ20216891(sclee)
-- ,@p_division_id   NVARCHAR(2) =''  -- --  EE/40/82/81(1/2/3/4)
,@p_division_id   NVARCHAR(30) =''  -- --  EE/40/82/81(1/2/3/4)
)
RETURNS @Running_time TABLE
(
     PLAN_DATE        NVARCHAR(1000)
    ,MASTER_ID        NVARCHAR(1000) 
	  ,PLAN_ID          NVARCHAR(1000)   
    ,SEQ              NVARCHAR(1000)   
    ,PROGRAM_NAME     NVARCHAR(1000)
    ,PLAN_START       DATETIME
    ,PLAN_END         DATETIME
    ,PLN_RUNNING_TIME NVARCHAR(1000)
	,DIVISION_ID	  NVARCHAR(30) -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
--	  ,NO               int
	  ,ORDERNO1         int
    ,ORDERNO2         int
  
)AS
BEGIN



	------------------
  
    INSERT @Running_time
    SELECT XX.PLAN_DATE,XX.MASTER_ID,XX.PLAN_ID,XX.SEQ   , YY.PROGRAM_NAME, XX.PLAN_START AS PLAN_START,  YY.PLAN_END AS PLAN_END
     , REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END)/ 60))) )) + (convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END)/ 60))) + ':' +                 
       REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END))% 60)) )) + (convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END))% 60))         AS PLN_RUNNING_TIME
       ,XX.division_id	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
	   ,xx.orderNo1
	   , 0 AS orderNo2  
     FROM 
     (
    SELECT * 
     FROM 
     (
    SELECT 
		  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CREATION_DATE, 'MON')), 112) AS PLAN_DATE
		, SUBSTRING(DESCRIPTION, 33						,8+LEN(@p_division_id))	AS MASTER_ID	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
		, SUBSTRING(DESCRIPTION, 44+LEN(@p_division_id)	,11)					AS PLAN_ID		-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
		, SUBSTRING(DESCRIPTION, 54+LEN(@p_division_id)	,1)						AS SEQ			-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
		, CREATION_DATE  AS PLAN_START, NULL AS  PLAN_END	
		, SUBSTRING(DESCRIPTION, 33						,LEN(@p_division_id))	AS DIVISION_ID  -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
		, PROGRAM_NAME
		, ROW_NUMBER() OVER(PARTITION BY CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CREATION_DATE, 'MON')), 112)
										,SUBSTRING(DESCRIPTION, 33						, 8+LEN(@p_division_id))	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
								ORDER BY SUBSTRING(DESCRIPTION, 54+LEN(@p_division_id)	, 1) desc					-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
								) AS orderNo1  
    FROM SCM_SYS_LOG_BATCH    WITH (NOLOCK)  
	WHERE 0 = 0 
	  AND DESCRIPTION LIKE '%Start Plan SCP PLN Create%'   
	  AND DESCRIPTION LIKE '%::' + @p_plan_type + '::%'  
    ) X
     WHERE orderNo1 =1
    ) XX
    JOIN 
     (
     SELECT * 
     FROM 
     (
     SELECT CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CREATION_DATE, 'MON')), 112)  AS PLAN_DATE
			, SUBSTRING(DESCRIPTION, 2						,8+LEN(@p_division_id))	AS MASTER_ID	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
			, SUBSTRING(DESCRIPTION, 12+LEN(@p_division_id)	,11)					AS PLAN_ID		-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
			, SUBSTRING(DESCRIPTION, 22+LEN(@p_division_id)	,1)						AS SEQ			-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
			, NULL AS PLAN_START, CREATION_DATE AS  PLAN_END
			, SUBSTRING(DESCRIPTION, 2						,LEN(@p_division_id))	AS DDIVISION_ID -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
			, PROGRAM_NAME
			, ROW_NUMBER() OVER(PARTITION BY CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CREATION_DATE, 'MON')), 112)
											,SUBSTRING(DESCRIPTION, 2						,8+LEN(@p_division_id))	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
									ORDER BY SUBSTRING(DESCRIPTION, 22+LEN(@p_division_id)	,1) desc				-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
									) AS orderNo1  

     FROM SCM_SYS_LOG_BATCH    WITH (NOLOCK)  
	 WHERE 0 = 0 
	   AND PROGRAM_NAME ='PR_SCP_PLN_CREATE_DATA' 
	   AND LOG_TYPE='END' 
	   AND DESCRIPTION LIKE '%::' + @p_plan_type + '::%'  
     ) X
     WHERE orderNo1 =1
    ) YY

    ON 0 = 0
    AND XX.PLAN_DATE  = YY.PLAN_DATE
    AND XX.MASTER_ID  = YY.MASTER_ID
    AND XX.PLAN_ID    = YY.PLAN_ID
    ANd XX.SEQ        = YY.SEQ
    AND XX.PLAN_DATE = (CASE WHEN @p_plan_date = '' THEN XX.PLAN_DATE ELSE @p_plan_date END) 
	AND XX.DIVISION_ID = @p_division_id  -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영

    INSERT @Running_time
    SELECT XX.PLAN_DATE, XX.MASTER_ID, XX.PLAN_ID, XX.SEQ, XX.PROGRAM_NAME, XX.PLAN_START AS PLAN_START, YY.PLAN_END AS PLAN_END
         , REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END)/ 60))) )) + (convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END)/ 60))) + ':' +                 
           REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END))% 60)) )) + (convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END))% 60))         AS PLN_RUNNING_TIME
        , DIVISION_ID	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
		, XX.orderNo1
		, 1 AS orderNo2  
      FROM (
            SELECT CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CREATION_DATE, 'MON')), 112) AS PLAN_DATE, Y.MASTER_ID, Y.PLAN_ID, Y.SEQ, X.PROGRAM_NAME, CREATION_DATE AS PLAN_START,NULL AS PLAN_END
              ,(CASE 
                  WHEN X.PROGRAM_NAME ='PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA'        THEN 1 
                  WHEN X.PROGRAM_NAME ='PR_SCP_PLN_TH_ENG_STOCK_PLAN'           THEN 2             
                  WHEN X.PROGRAM_NAME ='PR_SCP_PLN_SHIPMENT_PLAN'               THEN 3 
                  WHEN X.PROGRAM_NAME ='PR_SCP_PLN_PRODUCTION_PLAN'             THEN 4 
                  WHEN X.PROGRAM_NAME ='PR_SCP_PLN_PLANT_ONHAND'                THEN 5 
                  WHEN X.PROGRAM_NAME ='PR_SCP_PLN_BOH_ASSIGN'                  THEN 6 
                  WHEN X.PROGRAM_NAME ='PR_SCP_PLN_SALES_ONHAND'                THEN 7 
                  WHEN X.PROGRAM_NAME ='PR_SCP_PLN_ALLOCATION'                  THEN 8 
                  ELSE '99'
              END) AS orderNo1
			  , SUBSTRING(Y.MASTER_ID, 1, LEN(@p_division_id))  AS DIVISION_ID -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
              FROM SCM_SYS_LOG_BATCH X   WITH (NOLOCK)  
				   JOIN @Running_time Y -- WITH (NOLOCK)  
					 ON 0 = 0
					AND X.CREATION_DATE >= Y.PLAN_START 
					AND X.CREATION_DATE <= Y.PLAN_END
					AND Y.PROGRAM_NAME = 'PR_SCP_PLN_CREATE_DATA'
              WHERE 0 = 0 
               AND X.PROGRAM_NAME IN ( 'PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA'
                                      ,'PR_SCP_PLN_TH_ENG_STOCK_PLAN' 
                                      ,'PR_SCP_PLN_SHIPMENT_PLAN'
                                      ,'PR_SCP_PLN_PRODUCTION_PLAN'
                                      ,'PR_SCP_PLN_PLANT_ONHAND'
                                      ,'PR_SCP_PLN_BOH_ASSIGN'
                                      ,'PR_SCP_PLN_SALES_ONHAND'
                                      ,'PR_SCP_PLN_ALLOCATION'
                                      )
               AND X.LOG_TYPE IN ('START')
      ) XX
      JOIN 
      (
      SELECT CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CREATION_DATE, 'MON')), 112)  AS PLAN_DATE, Y.MASTER_ID, Y.PLAN_ID, Y.SEQ, X.PROGRAM_NAME, NULL AS PLAN_START,CREATION_DATE AS PLAN_END--, DESCRIPTION
              FROM SCM_SYS_LOG_BATCH X   WITH (NOLOCK)  
				   JOIN @Running_time Y  --WITH (NOLOCK)  
					 ON 0 = 0
					AND X.CREATION_DATE >= Y.PLAN_START 
					AND X.CREATION_DATE <= Y.PLAN_END
					AND Y.PROGRAM_NAME = 'PR_SCP_PLN_CREATE_DATA'
              WHERE 0 = 0 
               AND X.PROGRAM_NAME IN ( 'PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA'
                                      ,'PR_SCP_PLN_TH_ENG_STOCK_PLAN' 
                                      ,'PR_SCP_PLN_SHIPMENT_PLAN'
                                      ,'PR_SCP_PLN_PRODUCTION_PLAN'
                                      ,'PR_SCP_PLN_PLANT_ONHAND'
                                      ,'PR_SCP_PLN_BOH_ASSIGN'
                                      ,'PR_SCP_PLN_SALES_ONHAND'
                                      ,'PR_SCP_PLN_ALLOCATION'
                                      )
               AND X.LOG_TYPE IN ('END')
         
       ) YY 
       ON 0 = 0
      AND XX.PLAN_DATE    = YY.PLAN_DATE
      AND XX.MASTER_ID    = YY.MASTER_ID
      AND XX.PLAN_ID      = YY.PLAN_ID
      ANd XX.SEQ          = YY.SEQ
      ANd XX.PROGRAM_NAME = YY.PROGRAM_NAME
      AND XX.PLAN_DATE = (CASE WHEN @p_plan_date = '' THEN XX.PLAN_DATE ELSE @p_plan_date END)
	  AND XX.DIVISION_ID = @p_division_id  -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
	  
       -- PR_SCP_ANL_CREATE_DATA 추출
       INSERT @Running_time

     SELECT XX.PLAN_DATE,XX.MASTER_ID,XX.PLAN_ID,XX.SEQ, YY.PROGRAM_NAME, XX.PLAN_START AS PLAN_START,  YY.PLAN_END AS PLAN_END
       , REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END)/ 60))) )) + (convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END)/ 60))) + ':' +                 
         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END))% 60)) )) + (convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END))% 60))         AS PLN_RUNNING_TIME
        ,XX.DIVISION_ID	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
		,xx.orderNo1
		,  2 AS orderNo2
       FROM 
       (
      SELECT * 
       FROM 
       (
      SELECT 
		     CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CREATION_DATE, 'MON')), 112) AS PLAN_DATE
		   , SUBSTRING(DESCRIPTION, 33						,8+LEN(@p_division_id))	AS MASTER_ID	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
		   , SUBSTRING(DESCRIPTION, 44+LEN(@p_division_id)	,11)					AS PLAN_ID		-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
	  	   , SUBSTRING(DESCRIPTION, 54+LEN(@p_division_id)	,1)						AS SEQ			-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
		   , CREATION_DATE  AS PLAN_START, NULL AS  PLAN_END 
		   , SUBSTRING(DESCRIPTION, 33						,LEN(@p_division_id))	AS DIVISION_ID	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
		   , PROGRAM_NAME
		   , ROW_NUMBER() OVER(PARTITION BY CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CREATION_DATE, 'MON')), 112)
										  , SUBSTRING(DESCRIPTION ,33						,8+LEN(@p_division_id))	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
							       ORDER BY SUBSTRING(DESCRIPTION ,54+LEN(@p_division_id)	,1) desc				-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
								   ) AS orderNo1	
       FROM SCM_SYS_LOG_BATCH    WITH (NOLOCK)  
	  WHERE 0 = 0 
	    AND DESCRIPTION LIKE '%Start Plan SCP ANL Create%'   
		AND DESCRIPTION LIKE '%::' + @p_plan_type + '::%'  
      ) X
       WHERE orderNo1 =1
      ) XX
      JOIN 
       (
       SELECT * 
       FROM 
       (
       SELECT CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CREATION_DATE, 'MON')), 112)  AS PLAN_DATE
			, SUBSTRING(DESCRIPTION, 2						,8+LEN(@p_division_id))	AS MASTER_ID	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
			, SUBSTRING(DESCRIPTION, 12+LEN(@p_division_id)	,11)					AS PLAN_ID		-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
			, SUBSTRING(DESCRIPTION, 22+LEN(@p_division_id)	,1)						AS SEQ			-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
			, NULL AS PLAN_START, CREATION_DATE AS  PLAN_END
			, SUBSTRING(DESCRIPTION, 2						,LEN(@p_division_id))	AS DIVISION_ID	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
			, PROGRAM_NAME
			, DESCRIPTION
			, ROW_NUMBER() OVER(PARTITION BY CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CREATION_DATE, 'MON')), 112)
											,SUBSTRING(DESCRIPTION, 2						,8+LEN(@p_division_id))	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
									ORDER BY SUBSTRING(DESCRIPTION, 22+LEN(@p_division_id)	,1) desc				-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
									) AS orderNo1 
       FROM SCM_SYS_LOG_BATCH    WITH (NOLOCK)  WHERE 0 = 0 AND PROGRAM_NAME ='PR_SCP_ANL_CREATE_DATA' AND LOG_TYPE='END' AND DESCRIPTION LIKE '%::' + @p_plan_type + '::%'  
       ) X
       WHERE orderNo1 =1
      ) YY

      ON 0 = 0
      AND XX.PLAN_DATE = YY.PLAN_DATE
      AND XX.MASTER_ID = YY.MASTER_ID
      AND XX.PLAN_ID = YY.PLAN_ID
      ANd XX.SEQ = YY.SEQ
      AND XX.PLAN_DATE = (CASE WHEN @p_plan_date = '' THEN XX.PLAN_DATE ELSE @p_plan_date END) 
	  AND XX.DIVISION_ID = @p_division_id  -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영


     INSERT @Running_time
      SELECT XX.PLAN_DATE, XX.MASTER_ID, XX.PLAN_ID, XX.SEQ, XX.PROGRAM_NAME, XX.PLAN_START AS PLAN_START, YY.PLAN_END AS PLAN_END
		   , REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END)/ 60))) )) + (convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END)/ 60))) + ':' +                 
			 REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END))% 60)) )) + (convert(varchar, (DATEDIFF(second,       XX.PLAN_START, YY.PLAN_END))% 60))         AS PLN_RUNNING_TIME
			, DIVISION_ID	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
			, XX.orderNo1
			, 3 AS orderNo2  
--       INTO #LOG_PR_SCP_ANL
      FROM (
            SELECT CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CREATION_DATE, 'MON')), 112) AS PLAN_DATE, Y.MASTER_ID, Y.PLAN_ID, Y.SEQ, X.PROGRAM_NAME, CREATION_DATE AS PLAN_START,NULL AS PLAN_END
              ,(CASE 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_SHIPMENT_PLAN_SEMI'        THEN 1 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_PRODUCTION_PLAN_S'         THEN 2 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_PRODUCTION_PLAN'           THEN 3 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_PRODUCTION_PLAN_I'         THEN 4 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_PSI_PRODUCTION'            THEN 5 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_PROBLEM_REPORT_DEMAND'     THEN 6 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_PROBLEM_REPORT_PEGGING'    THEN 7 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_SHIPMENT_PLAN_FG'          THEN 8 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_PSI_GLOBAL'                THEN 9 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_PSI_GLOBAL_SMALL'          THEN 10 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_PROBLEM_REPORT_DESC'       THEN 11 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_TACT_TIME'                 THEN 12 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_WORKING_TIME'              THEN 13 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_PSI_ELECTRODE'             THEN 14 
                  WHEN X.PROGRAM_NAME ='PR_SCP_PLN_ELEC_CELL_RTF_PLAN'        THEN 15 
                  WHEN X.PROGRAM_NAME ='PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE'  THEN 16 
                  ELSE '99'
              END) AS orderNo1
			  ,SUBSTRING(Y.MASTER_ID,1,LEN(@p_division_id)) AS DIVISION_ID  -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
              FROM SCM_SYS_LOG_BATCH X   WITH (NOLOCK)  
				   JOIN @Running_time Y 
				     ON 0 = 0
				    AND X.CREATION_DATE >= Y.PLAN_START 
				    AND X.CREATION_DATE <= Y.PLAN_END
				    AND Y.PROGRAM_NAME = 'PR_SCP_ANL_CREATE_DATA'
              WHERE 0 = 0 
               AND X.PROGRAM_NAME IN ( 'PR_SCP_ANL_SHIPMENT_PLAN_SEMI'
                                      ,'PR_SCP_ANL_PRODUCTION_PLAN_S'
                                      ,'PR_SCP_ANL_PRODUCTION_PLAN'
                                      ,'PR_SCP_ANL_PRODUCTION_PLAN_I'
                                      ,'PR_SCP_ANL_PSI_PRODUCTION'
                                      ,'PR_SCP_ANL_PROBLEM_REPORT_DEMAND'
                                      ,'PR_SCP_ANL_PROBLEM_REPORT_PEGGING'
                                      ,'PR_SCP_ANL_SHIPMENT_PLAN_FG'
                                      ,'PR_SCP_ANL_PSI_GLOBAL'
                                      ,'PR_SCP_ANL_PSI_GLOBAL_SMALL'
                                      ,'PR_SCP_ANL_PROBLEM_REPORT_DESC'
                                      ,'PR_SCP_ANL_TACT_TIME'
                                      ,'PR_SCP_ANL_WORKING_TIME'
                                      ,'PR_SCP_ANL_PSI_ELECTRODE'
                                      ,'PR_SCP_PLN_ELEC_CELL_RTF_PLAN'
                                      ,'PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE'
                                      )
               AND LOG_TYPE IN ('START')
      ) XX
      JOIN 
      (
      SELECT CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CREATION_DATE, 'MON')), 112)  AS PLAN_DATE, Y.MASTER_ID, Y.PLAN_ID, Y.SEQ, X.PROGRAM_NAME, NULL AS PLAN_START,CREATION_DATE AS PLAN_END
              FROM SCM_SYS_LOG_BATCH X   WITH (NOLOCK)  
				  JOIN @Running_time Y               
				    ON 0 = 0
				   AND X.CREATION_DATE >= Y.PLAN_START 
				   AND X.CREATION_DATE <= Y.PLAN_END
				   AND Y.PROGRAM_NAME = 'PR_SCP_ANL_CREATE_DATA'
              WHERE 0 = 0 
               AND X.PROGRAM_NAME IN ( 'PR_SCP_ANL_SHIPMENT_PLAN_SEMI'
                                      ,'PR_SCP_ANL_PRODUCTION_PLAN_S'
                                      ,'PR_SCP_ANL_PRODUCTION_PLAN'
                                      ,'PR_SCP_ANL_PRODUCTION_PLAN_I'
                                      ,'PR_SCP_ANL_PSI_PRODUCTION'
                                      ,'PR_SCP_ANL_PROBLEM_REPORT_DEMAND'
                                      ,'PR_SCP_ANL_PROBLEM_REPORT_PEGGING'
                                      ,'PR_SCP_ANL_SHIPMENT_PLAN_FG'
                                      ,'PR_SCP_ANL_PSI_GLOBAL'
                                      ,'PR_SCP_ANL_PSI_GLOBAL_SMALL'
                                      ,'PR_SCP_ANL_PROBLEM_REPORT_DESC'
                                      ,'PR_SCP_ANL_TACT_TIME'
                                      ,'PR_SCP_ANL_WORKING_TIME'
                                      ,'PR_SCP_ANL_PSI_ELECTRODE'
                                      ,'PR_SCP_PLN_ELEC_CELL_RTF_PLAN'
                                      ,'PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE'
                                      )
               AND LOG_TYPE IN ('END')
       ) YY 
       ON 0 = 0
      AND XX.PLAN_DATE    = YY.PLAN_DATE
      AND XX.MASTER_ID    = YY.MASTER_ID
      AND XX.PLAN_ID      = YY.PLAN_ID
      ANd XX.SEQ          = YY.SEQ
      ANd XX.PROGRAM_NAME = YY.PROGRAM_NAME
      AND XX.PLAN_DATE = (CASE WHEN @p_plan_date = '' THEN XX.PLAN_DATE ELSE @p_plan_date END) 
	  AND XX.DIVISION_ID = @p_division_id  -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영

	RETURN;
END;

