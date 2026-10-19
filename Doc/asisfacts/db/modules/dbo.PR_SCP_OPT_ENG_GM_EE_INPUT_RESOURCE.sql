
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_EE_INPUT_RESOURCE]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.05 Y.S.H Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Prameter
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_EE_INPUT_RESOURCE';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_PLAN_START_YYYYMM NVARCHAR(6);
    DECLARE @V_PLAN_END_YYYYMM   NVARCHAR(6);
    DECLARE @V_PROD_FROZEN       INT;


	-- 임시 : 아래 변수 수정 처리 필요
    DECLARE @V_SCP_PLAN_TYPE    NVARCHAR(200)
    DECLARE @V_SCP_PLAN_DATE    NVARCHAR(200)
    DECLARE @V_SCP_PLAN_SEQ    NVARCHAR(200)
    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    ------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
	--BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------  
	BEGIN TRY
        ------------------------------------------------------------------------
        -- Get Plan Mater Info
        ------------------------------------------------------------------------
        SELECT @V_PLAN_START_YYYYMM = LEFT(PLAN_START_DATE,6)
              ,@V_PLAN_END_YYYYMM   = LEFT(PLAN_END_DATE,6)
        FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        WHERE  PLAN_ID = @V_PLAN_ID
        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

		IF OBJECT_ID('TEMPDB..#TACT_TIME') IS NOT NULL
		BEGIN 
			DROP TABLE  #TACT_TIME;
		END;

		SELECT  DIVISION_ID 
		INTO    #DIVISION
		FROM    SCM_MST_DIVISION WITH(NOLOCK)
		WHERE   VALID_YN    = 'Y'
		AND     ATTRIBUTE3 <> 'EE'
		AND     ATTRIBUTE4  = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) -- 전극 Division 변수
		;

		SELECT DIVISION_ID, PLANT_ID, ITEM_ID, LINE_ID, MONTH, TACT_TIME, OPERATION_ID, STAGE, SCM_SITE_ID
		INTO #TACT_TIME
		FROM (  
				--SELECT    DISTINCT
    --                      LU.SEGMENT2   AS DIVISION_ID
    --                    , LU.SEGMENT3   AS PLANT_ID
    --                    , LU.SEGMENT4   AS SCM_SITE_ID
    --                    , LU.SEGMENT5   AS OPERATION_ID
    --                    , LU.ATTRIBUTE1 AS LINE_ID
    --                    , LU.ATTRIBUTE2 AS ITEM_ID
    --                    , LU.ATTRIBUTE3 AS MONTH
    --                    , CONVERT(FLOAT, LU.ATTRIBUTE4) AS TACT_TIME 
    --                    , MDL.STAGE     AS STAGE
    --            FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
    --            INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN MDL WITH(NOLOCK)
    --                ON  MDL.PLAN_ID     = @V_PLAN_ID
    --                AND MDL.SCM_SITE_ID = LU.SEGMENT4
    --                AND MDL.ITEM_ID     = LU.ATTRIBUTE2
    --                AND MDL.ATTRIBUTE1  = LU.SEGMENT5
    --            WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_MASTER_CAPA_TEMP'
    --            AND    LU.VALID_YN    = 'Y'
    --            AND    LU.ATTRIBUTE3  BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
		  --      AND    LU.SEGMENT2 = @V_DIVISION_ID
		  --      --  FP 정보
				----SELECT A.DIVISION_ID AS DIVISION_ID
				----	  ,A.PLANT_ID    AS PLANT_ID
				----	  ,A.ITEM_ID     AS ITEM_ID
				----	  ,A.LINE_ID     AS LINE_ID
				----	  ,A.MONTH       AS MONTH
				----	  ,A.TACT_TIME   AS TACT_TIME
				----	  ,A.OPERATION_ID AS OPERATION_ID
				----	  ,'COATING'      AS STAGE
				----	  ,PLANT_ID +'-E' AS SCM_SITE_ID
				----FROM   SCM_MST_TACT_TIME_SN A WITH(NOLOCK)

				----INNER JOIN #DIVISION D WITH(NOLOCK)
				----ON A.DIVISION_ID = D.DIVISION_ID

				----WHERE  1=1
				----AND    A.OPERATION_ID IN ('E2000')
				----AND    A.MONTH BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
				----/************************* 
				----대상 프로젝트 ITEM 필터링 
				----*************************/
				----AND CONCAT(CONCAT(A.PLANT_ID,'-E'), A.ITEM_ID) 
				----  IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
				----	  FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
				----	  WHERE  PLAN_ID = @V_PLAN_ID
				----	 )

                -- 2025.11.19 Minyong Lee : Lookup -> UI 전환 (GM Daily Capa)
                SELECT  DISTINCT
                        @V_DIVISION_ID  AS DIVISION_ID
                      , TT.PLANT_ID     AS PLANT_ID
                      , ST.SCM_SITE_ID  AS SCM_SITE_ID
                      , TT.OPERATION_ID AS OPERATION_ID
                      , CONCAT(TT.LINE_ID, IIF(TT.OPERATION_ID = 'A5000' AND TT.ELECTRODE_TYPE = 'Anode', '@A',
                                           IIF(TT.OPERATION_ID = 'A5000' AND TT.ELECTRODE_TYPE = 'Cathode', '@C',
                                           ''))
                              ) AS LINE_ID
                      , TT.ITEM_ID      AS ITEM_ID
                      , TT.MONTH        AS MONTH
                      , CASE
                            WHEN TT.OPERATION_ID = 'E2000' THEN TT.TACT_TIME / ISNULL(ICC.VALUE, LA.LANE_QTY) / LS.LOSS_RATE
                            WHEN TT.OPERATION_ID = 'A5000' THEN 86400 / TT.DAILY_CAPA / LS.LOSS_RATE
                        END             AS TACT_TIME
	                  , CASE
                            WHEN TT.OPERATION_ID = 'E2000' THEN 'COATING'
                            WHEN TT.OPERATION_ID = 'A5000' THEN 'NND'
                        END AS STAGE
                FROM    SCM_MST_TACT_TIME_SN TT
	                INNER JOIN #DIVISION D WITH(NOLOCK)
		                ON TT.DIVISION_ID = D.DIVISION_ID
                    LEFT JOIN   (
                                SELECT	OPERATION_ID
	                                  , OPERATION_GROUP
                                FROM	SCM_MST_OPERATION_FLOW_V
                                WHERE	1=1
                                AND		VALID_YN = 'Y'
                                GROUP BY
		                                OPERATION_ID
	                                  , OPERATION_GROUP
                                ) OP
                        ON	TT.OPERATION_ID = OP.OPERATION_ID
                    LEFT JOIN   (
                                SELECT	PLANT_ID
	                                  , SCM_SITE_ID
	                                  , OPERATION_GROUP
                                FROM	SCM_MST_SITE
                                WHERE	1=1
                                AND		VALID_YN = 'Y'
                                AND		PLANT_ID IS NOT NULL
                                AND		SCM_SITE_ID IS NOT NULL 
                                GROUP BY
		                                PLANT_ID
	                                  , SCM_SITE_ID
	                                  , OPERATION_GROUP
                                ) ST
                        ON	TT.PLANT_ID = ST.PLANT_ID
                        AND	OP.OPERATION_GROUP = ST.OPERATION_GROUP
                    LEFT JOIN SCM_LOSS_M_SN LS
                        ON  TT.DIVISION_ID  = LS.DIVISION_ID
                        AND TT.PLANT_ID     = LS.PLANT_ID
                        AND TT.OPERATION_ID = LS.OPERATION_ID
                        AND TT.LINE_ID      = LS.LINE_ID
                        AND TT.MONTH        = LS.WORK_MONTH
                        AND LS.FACTORY_ID   IN ('AB', 'EI')
                        AND LS.LOSS_CODE    = 'M12' -- Product Efficiency
                    LEFT JOIN   (
                                SELECT  CC.DIVISION_ID
                                      , CC.PLANT_ID
                                      , CC.OPERATION
                                      , CC.ITEM_ID
                                      , CC.VALUE
                                FROM    SCM_MST_ITEM_CONV_CALC_SN CC -- LANE Priority 1
                                    INNER JOIN  (
                                                SELECT  DIVISION_ID, PLANT_ID, OPERATION, ITEM_ID,
                                                        MAX(APPLY_DATE) AS MAX_APPLY_DATE
                                                FROM    SCM_MST_ITEM_CONV_CALC_SN
                                                WHERE   OPERATION  = 'E2000'
                                                AND     CATEGORY   = 'LANE NUMBER'
                                                GROUP BY DIVISION_ID, PLANT_ID, OPERATION, ITEM_ID
                                                ) C
                                        ON  CC.DIVISION_ID = C.DIVISION_ID
                                        AND CC.PLANT_ID    = C.PLANT_ID
                                        AND CC.OPERATION   = C.OPERATION
                                        AND CC.ITEM_ID     = C.ITEM_ID
                                        AND CC.APPLY_DATE  = C.MAX_APPLY_DATE
                                WHERE   CC.OPERATION = 'E2000'
                                AND     CC.CATEGORY  = 'LANE NUMBER'
                                ) ICC
                        ON  TT.DIVISION_ID  = ICC.DIVISION_ID
                        AND TT.PLANT_ID     = ICC.PLANT_ID
                        AND TT.OPERATION_ID = ICC.OPERATION
                        AND TT.ITEM_ID      = ICC.ITEM_ID
                    LEFT JOIN SCM_MST_ITEM_LINE_ASSIGN_SN LA -- LANE Priority 2
                        ON  TT.DIVISION_ID  = LA.DIVISION_ID
                        AND TT.PLANT_ID     = LA.PLANT_ID
                        AND TT.OPERATION_ID = LA.OPERATION_ID
                        AND TT.ITEM_ID      = LA.ITEM_ID
                        AND TT.MONTH        = LA.MONTH
                        AND LA.OPERATION_ID = 'E2000'
                WHERE   1=1
                AND     TT.OPERATION_ID IN ('E2000', 'A5000')
                AND     TT.MONTH BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
                AND     LS.LOSS_RATE > 0
                AND     ((TT.OPERATION_ID = 'E2000' AND ISNULL(ICC.VALUE, LA.LANE_QTY) > 0) OR
                         (TT.OPERATION_ID = 'A5000' AND TT.DAILY_CAPA > 0))
			) B;

	    -- 전극 Plan Type 확인
		SELECT @V_SCP_PLAN_DATE = A.PLAN_START_YYYYMMDD
		     , @V_SCP_PLAN_TYPE = A.PLAN_TYPE
		     , @V_SCP_PLAN_SEQ  = A.PLAN_SEQ
        FROM  (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
		            , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_TYPE_ORDER DESC, PLAN_SEQ DESC ) AS PLAN_RANK
               FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
			   -- 전극 Division 에 해당하는 사업부 확인
               WHERE  DIVISION_ID          = @V_DIVISION_ID -- 전극 Division 변수
               AND    PLAN_START_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 전주 월요일 YYYYMMDD
               AND    PLAN_START_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD,  -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 당주 월요일 YYYYMMDD
              ) A
        WHERE PLAN_RANK = 1

		-- PR_SCP_OPT_ENG_GM_EE_INPUT_FROZEN_PLAN/IBR 에서 동일 정보 사용
        SELECT  @V_PROD_FROZEN = SEGMENT4
		FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		WHERE   LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN'
		AND     VALID_YN    = 'Y'
		AND     SEGMENT1    = @V_DIVISION_ID -- 전극 Division 변수
		AND     SEGMENT2    = @V_GROUP_ID
        --AND     SEGMENT3    = 'PR' --임시
        AND     SEGMENT3    = @V_SCP_PLAN_TYPE  -- 전극 Division 기준

        INSERT INTO SCP_OPT_ENG_RESOURCE_SN(
               PLAN_ID
              ,RESOURCE_ID
              ,RESOURCE_NAME
              ,SITE_ID
              ,STAGE
              ,RESOURCE_TYPE
              ,FROZENCARRYOVERDATE
              ,FROZENCARRYOVERSETUPGROUPNAME
              ,FROZENCARRYOVERSETUPITEMNAME
              ,GROUP_SETUP_CONTROL_CODE
              ,ITEM_SETUP_CONTROL_CODE
              ,GROUP_ALLOCATION_CONTROL_CODE
              ,ITEM_ALLOCATION_CONTROL_CODE
              ,EVERY_UPPER_CONTROL_CODE
              ,EVERY_LOWER_CONTROL_CODE
              ,HORIZON_UPPER_CONTROL_CODE
              ,HORIZON_LOWER_CONTROL_CODE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE14
              ,ATTRIBUTE15
              )
        SELECT @V_PLAN_ID                                                AS PLAN_ID
              ,SITE+'::'+RESOURCE_NAME                                   AS RESOURCE_ID
              ,RESOURCE_NAME                                             AS RESOURCE_NAME
              ,SITE                                                      AS SITE_ID
              ,STAGE                                                     AS STAGE
              ,RESOURCE_TYPE                                             AS RESOURCE_TYPE
              ,NULL                                                      AS FROZENCARRYOVERDATE
              ,NULL                                                      AS FROZENCARRYOVERSETUPGROUPNAME
              ,NULL                                                      AS FROZENCARRYOVERSETUPITEMNAME
              ,CASE WHEN RESOURCE_TYPE = 'LINE' THEN STAGE ELSE NULL END AS GROUP_SETUP_CONTROL_CODE
              ,CASE WHEN RESOURCE_TYPE = 'LINE' THEN STAGE ELSE NULL END AS ITEM_SETUP_CONTROL_CODE
              ,STAGE                                                     AS GROUP_ALLOCATION_CONTROL_CODE
              ,STAGE                                                     AS ITEM_ALLOCATION_CONTROL_CODE
              ,'LINE'                                                    AS EVERY_UPPER_CONTROL_CODE
              ,'LINE'                                                    AS EVERY_LOWER_CONTROL_CODE
              ,NULL                                                      AS HORIZON_UPPER_CONTROL_CODE
              ,NULL                                                      AS HORIZON_LOWER_CONTROL_CODE
              ,SITE                                                      AS ATTRIBUTE1
              ,ITEM_ID                                                   AS ATTRIBUTE2
              ,STAGE                                                     AS ATTRIBUTE3
              ,LINE_ID_ORG                                               AS ATTRIBUTE14
              ,LINE_ID                                                   AS ATTRIBUTE15
              --,OPERATION_ID                                              AS ATTRIBUTE14
        FROM(
            ------------------------------------------------------------------------
            -- Add Plant 
            -- EE_UC: 없음.
            ------------------------------------------------------------------------
            SELECT A.PLANT_SITE_ID AS SITE
                  ,A.ITEM_ID       AS RESOURCE_NAME
                  ,'COATING'       AS STAGE
                  ,A.ITEM_ID       AS ITEM_ID
                  ,NULL            AS LINE_ID
                  ,CASE WHEN A.ITEM_ID = '-' THEN 'PLANT' ELSE 'MODEL' END RESOURCE_TYPE
                  ,NULL            AS LINE_ID_ORG
                  --,NULL          AS OPERATION_ID
	        FROM SCP_MST_OUTSOURCING_CAPA A WITH(NOLOCK)

			INNER JOIN #DIVISION D WITH(NOLOCK)
			ON A.DIVISION_ID = D.DIVISION_ID

			INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
			ON  A.DIVISION_ID   = B.DIVISION_ID
			AND A.PLANT_SITE_ID = B.SCM_SITE_ID
			AND B.VALID_YN      = 'Y'
			AND B.OPERATION_GROUP IN ('E')

	        WHERE 1=1
	        AND A.VALID_YN = 'Y'
	        AND A.ITEM_ID = '-'
			/************************* 
			대상 프로젝트 ITEM 필터링 
			*************************/
	        AND A.PLANT_SITE_ID IN (SELECT PR.PLANT_SITE_ID
	                                FROM   SCM_MST_SITE_ITEM_PRIORITY PR WITH(NOLOCK)
                                    WHERE  CONCAT(PR.PLANT_SITE_ID, PR.ITEM_ID)																			 
												IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
													FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
													WHERE  PLAN_ID = @V_PLAN_ID
													)
                                 )
            ------------------------------------------------------------------------
            -- Add Model 
            -- EE_UC: 없음
            ------------------------------------------------------------------------
            UNION ALL
            SELECT A.PLANT_SITE_ID AS SITE
                  ,A.ITEM_ID       AS RESOURCE_NAME
                  ,'COATING'       AS STAGE
                  ,A.ITEM_ID       AS ITEM_ID
                  ,NULL            AS LINE_ID
                  ,CASE WHEN A.ITEM_ID = '-' THEN 'PLANT' ELSE 'MODEL' END RESOURCE_TYPE
                  ,NULL            AS LINE_ID_ORG
                  --,NULL          AS OPERATION_ID
	        FROM SCP_MST_OUTSOURCING_CAPA A WITH(NOLOCK)

			INNER JOIN #DIVISION D WITH(NOLOCK)
			ON A.DIVISION_ID = D.DIVISION_ID

			INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
			ON  A.DIVISION_ID   = B.DIVISION_ID
			AND A.PLANT_SITE_ID = B.SCM_SITE_ID
			AND B.VALID_YN      = 'Y'
			AND B.OPERATION_GROUP IN ('E')

	        WHERE 1=1
	        AND A.VALID_YN = 'Y'
			/************************* 
			대상 프로젝트 ITEM 필터링 
			*************************/
	        AND CONCAT(A.PLANT_SITE_ID, '_', A.ITEM_ID) IN ( SELECT DISTINCT CONCAT(PR.PLANT_SITE_ID, '_', PR.ITEM_ID)
															 FROM   SCM_MST_SITE_ITEM_PRIORITY PR WITH(NOLOCK)
															 WHERE CONCAT(PR.PLANT_SITE_ID, PR.ITEM_ID)																			 
																			IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
																				FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
																				WHERE  PLAN_ID = @V_PLAN_ID
																				)
															)
            ------------------------------------------------------------------------
            -- Add Line 
            ------------------------------------------------------------------------
            UNION ALL
            SELECT ML.SCM_SITE_ID   AS SITE
                  ,ILA.LINE_ID      AS RESOURCE_NAME
                  ,TT.STAGE         AS STAGE
                  ,NULL             AS ITEM_ID
                  ,ILA.LINE_ID      AS LINE_ID
                  --,+'@'+ILA.ELECTRODE_TYPE AS TEST
                  ,'LINE'           AS RESOURCE_TYPE
                  ,ILA.LINE_ID_ORG  AS LINE_ID_ORG
                  --,ILA.OPERATION_ID AS OPERATION_ID
            FROM (SELECT LA.COMPANY_ID
                        ,LA.DIVISION_ID
                        ,LA.SITE_ID
                        ,LA.PLANT_ID
                        ,LA.ITEM_ID 
                        ,LA.MONTH
                        ,LA.OPERATION_ID
                        ,CASE WHEN OPERATION_ID = 'E2000' THEN LINE_ID
                              WHEN OPERATION_ID = 'A5000' THEN LINE_ID+'@'+LEFT(ELECTRODE_TYPE,1)
                         END AS LINE_ID
                        ,LINE_ID AS LINE_ID_ORG
                  FROM SCM_MST_ITEM_LINE_ASSIGN_SN LA WITH(NOLOCK)
                      INNER JOIN #DIVISION DV
                          ON  LA.DIVISION_ID = DV.DIVISION_ID
                ) ILA
                INNER JOIN (SELECT  MS.DIVISION_ID
                                   ,MS.PLANT_ID
                                   ,ML.ITEM_ID
                                   ,MS.COMPANY_ID
                                   ,MS.SITE_ID
                                   ,ML.SCM_SITE_ID
                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                            INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
                            ON      ML.SCM_SITE_ID = MS.SCM_SITE_ID
                            AND     ML.PLAN_ID     = @V_PLAN_ID
                            WHERE   MS.PLANT_ID IS NOT NULL
                            GROUP BY MS.DIVISION_ID, MS.PLANT_ID, ML.ITEM_ID, MS.COMPANY_ID, MS.SITE_ID, ML.SCM_SITE_ID
                           ) AS ML 
                    ON  1=1 -- ILA.DIVISION_ID = ML.DIVISION_ID
                    AND ILA.COMPANY_ID  = ML.COMPANY_ID
                    AND ILA.SITE_ID     = ML.SITE_ID
                    AND ILA.PLANT_ID    = ML.PLANT_ID
                    AND ILA.ITEM_ID     = ML.ITEM_ID
                    AND ILA.MONTH  BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
                INNER JOIN  #TACT_TIME TT WITH(NOLOCK)  
                    ON  1=1 -- ILA.DIVISION_ID = TT.DIVISION_ID
                    AND ILA.PLANT_ID     = TT.PLANT_ID
                    AND ILA.LINE_ID = TT.LINE_ID
                    AND ILA.OPERATION_ID = TT.OPERATION_ID
                    AND ILA.ITEM_ID      = TT.ITEM_ID
                    AND TT.MONTH  BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
                INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)
                    ON  ILA.DIVISION_ID  = LM.DIVISION_ID
                    AND ILA.COMPANY_ID   = LM.COMPANY_ID
                    AND ILA.SITE_ID      = LM.SITE_ID
                    AND ILA.PLANT_ID     = LM.PLANT_ID
                    AND ILA.LINE_ID      = IIF(LM.OPERATION_ID = 'A5000',LM.LINE_ID+'@'+LEFT(ELECTRODE_TYPE,1),LM.LINE_ID)
					AND ILA.OPERATION_ID = LM.OPERATION_ID
                    AND LM.ACTIVE_FLAG = 'Y'
            WHERE   1=1
            GROUP BY ML.SCM_SITE_ID,ILA.LINE_ID, TT.STAGE, ILA.LINE_ID_ORG
            ) AS A
        ------------------------------------------------------------------------
        -- APPLY TO TOOL CONSTRAINT AND DATA INSERT
        -- EE_UC: 일단 Site 정보 기반으로 Stage 구분(임시)
        -- THKIM/2025.09.22/FROZEN_MASTER 보도록 변경
        ------------------------------------------------------------------------ 
		 -- 전극 Line / 인원 제약은 별도 처리 방안 필요함
        UNION ALL
  --      SELECT  @V_PLAN_ID                     AS PLAN_ID
  --             ,SEGMENT3+'::'+SEGMENT5         AS RESOURCE_ID
  --             ,SEGMENT5                       AS RESOURCE_NAME
  --             ,SEGMENT3                       AS SITE_ID
  --             ,CASE WHEN RIGHT(SEGMENT3, 2) = '-A' THEN 'NND' ELSE 'COATING' END AS STAGE
  --             ,'LINE'                         AS RESOURCE_TYPE
		--		,CONVERT(NVARCHAR,DATEADD(DAY,@V_PROD_FROZEN+1,@V_SCP_PLAN_DATE),112)+':000000' AS FROZENCARRYOVERDATE
		--		,SEGMENT3+'::'+SEGMENT5        AS FROZENCARRYOVERSETUPGROUPNAME
		--		,'COATING'				       AS FROZENCARRYOVERSETUPITEMNAME 
  --             ,'LINECHANGE'                   AS GROUP_SETUP_CONTROL_CODE
  --             ,'LINECHANGE'                   AS ITEM_SETUP_CONTROL_CODE
  --             ,NULL                           AS GROUP_ALLOCATION_CONTROL_CODE
  --             ,NULL                           AS ITEM_ALLOCATION_CONTROL_CODE
  --             ,'LINE'				           AS EVERY_UPPER_CONTROL_CODE
  --             ,'LINE'                         AS EVERY_LOWER_CONTROL_CODE
  --             ,NULL                           AS HORIZON_UPPER_CONTROL_CODE
  --             ,NULL                           AS HORIZON_LOWER_CONTROL_CODE
  --             ,SEGMENT3                       AS ATTRIBUTE1
  --             ,NULL                           AS ATTRIBUTE2
  --             ,'COATING'                      AS ATTRIBUTE3
  --             ,SEGMENT5                       AS ATTRIBUTE15
  --             ,SEGMENT5                       AS ATTRIBUTE15
  --      FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
  --      WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_LINE_PERSONNEL'
  --      AND     LU.SEGMENT2    = @V_DIVISION_ID
		--AND     LU.ATTRIBUTE5  = @V_GROUP_ID
  --      AND     LU.VALID_YN    = 'Y'
  --      GROUP BY LU.SEGMENT3, LU.SEGMENT5

        SELECT  @V_PLAN_ID                     AS PLAN_ID
               ,LU.SEGMENT3+'::'+LU.SEGMENT5         AS RESOURCE_ID
               ,LU.SEGMENT5                       AS RESOURCE_NAME
               ,LU.SEGMENT3                       AS SITE_ID
               ,CASE WHEN RIGHT(LU.SEGMENT3, 2) = '-A' THEN 'NND' ELSE 'COATING' END AS STAGE
               ,'LINE'                         AS RESOURCE_TYPE
			   ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(PF.FROZEN_END_DATE)),112)+':000000' AS FROZENCARRYOVERDATE
				,LU.SEGMENT3+'::'+LU.SEGMENT5        AS FROZENCARRYOVERSETUPGROUPNAME
				,'COATING'				       AS FROZENCARRYOVERSETUPITEMNAME 
               ,'LINECHANGE'                   AS GROUP_SETUP_CONTROL_CODE
               ,'LINECHANGE'                   AS ITEM_SETUP_CONTROL_CODE
               ,NULL                           AS GROUP_ALLOCATION_CONTROL_CODE
               ,NULL                           AS ITEM_ALLOCATION_CONTROL_CODE
               ,'LINE'				           AS EVERY_UPPER_CONTROL_CODE
               ,'LINE'                         AS EVERY_LOWER_CONTROL_CODE
               ,NULL                           AS HORIZON_UPPER_CONTROL_CODE
               ,NULL                           AS HORIZON_LOWER_CONTROL_CODE
               ,LU.SEGMENT3                       AS ATTRIBUTE1
               ,NULL                           AS ATTRIBUTE2
               ,'COATING'                      AS ATTRIBUTE3
               ,LU.SEGMENT5                       AS ATTRIBUTE15
               ,LU.SEGMENT5                       AS ATTRIBUTE15
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
				LEFT OUTER JOIN ( SELECT DISTINCT SCM_SITE_ID, LINE_ID, STAGE 
								  FROM #TACT_TIME ) TT
					ON   LU.SEGMENT3 = SCM_SITE_ID
					AND  LU.SEGMENT4 = LINE_ID
                LEFT OUTER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN PF 
                    ON  1=1
                    AND PF.FROZEN_TYPE = 'PROD'
                    AND PF.PLAN_ID = @V_PLAN_ID
                    AND TT.STAGE = PF.STAGE
        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_LINE_PERSONNEL'
        AND     LU.SEGMENT2    = @V_DIVISION_ID
		AND     LU.ATTRIBUTE5  = @V_GROUP_ID
        AND     LU.VALID_YN    = 'Y'
        GROUP BY LU.SEGMENT3, LU.SEGMENT5
        ------------------------------------------------------------------------
        -- APPLY TO CAPA CONSTRAINT 
        ------------------------------------------------------------------------   
        UNION ALL
        SELECT  @V_PLAN_ID                     AS PLAN_ID
               ,SCM_SITE_ID+'::'+RESOURCE_NAME AS RESOURCE_ID
               ,RESOURCE_NAME                  AS RESOURCE_NAME
               ,SCM_SITE_ID                    AS SITE_ID
               ,STAGE                          AS STAGE
               ,'STORAGE'                      AS RESOURCE_TYPE
               ,NULL                           AS FROZENCARRYOVERDATE
               ,NULL                           AS FROZENCARRYOVERSETUPGROUPNAME
               ,NULL                           AS FROZENCARRYOVERSETUPITEMNAME
               ,NULL                           AS GROUP_SETUP_CONTROL_CODE
               ,NULL                           AS ITEM_SETUP_CONTROL_CODE
               ,NULL                           AS GROUP_ALLOCATION_CONTROL_CODE
               ,NULL                           AS ITEM_ALLOCATION_CONTROL_CODE
               ,'STORAGE'                      AS EVERY_UPPER_CONTROL_CODE
               ,'STORAGE'                      AS EVERY_LOWER_CONTROL_CODE
               ,NULL                           AS HORIZON_UPPER_CONTROL_CODE
               ,NULL                           AS HORIZON_LOWER_CONTROL_CODE
               ,SCM_SITE_ID                    AS ATTRIBUTE1
               ,NULL                           AS ATTRIBUTE2
               ,STAGE                          AS ATTRIBUTE3
               ,NULL                           AS ATTRIBUTE14
               ,NULL                           AS ATTRIBUTE15
        FROM(
            /*SELECT  SEGMENT3   AS SCM_SITE_ID
                   ,SEGMENT4   AS STORAGE_ID
                   ,SEGMENT5   AS STAGE
                   --,ATTRIBUTE1 AS RESOURCE_NAME
                   ,SEGMENT4 AS RESOURCE_NAME
                   --,ATTRIBUTE2 AS MAX_CAPA
            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SL_CAPA'
            AND     LU.SEGMENT2     = @V_DIVISION_ID
            AND     LU.VALID_YN     = 'Y'
            GROUP BY SEGMENT3, SEGMENT4, SEGMENT5, SEGMENT4*/-- BLOCKED 2025.12.04 jongykim2: Warehouse Capacity
            -- ADDED 2025.12.04 jongykim2: Warehouse Capacity
            SELECT T.SCM_SITE_ID AS SCM_SITE_ID
                 , T.WH_NM       AS STORAGE_ID
                 , T.STAGE       AS STAGE
                 , T.WH_NM       AS RESOURCE_NAME
            FROM   SCP_OPMZ_WAREHOUSE_CAPACITY T WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
            ON     T.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            WHERE  T.DIVISION_ID     = @V_DIVISION_ID
            AND    PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
            AND    T.VALID_YN        = 'Y'
            AND    PG.VALID_YN       = 'Y'
            AND    T.TO_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
            AND    T.FROM_YYYYMMDD < @V_PLAN_END_YYYYMMDD
            GROUP BY T.SCM_SITE_ID, T.WH_NM, T.STAGE
            ) CP

        ------------------------------------------------------------------------
        -- APPLY TO PACKAGING CONSTRAINT 
        -- 2025.12.01 Minyong Lee : 5.20부 변경된 로직으로 주석처리
        ------------------------------------------------------------------------   
        --UNION ALL
        --SELECT  @V_PLAN_ID                      AS PLAN_ID
        --       ,FROM_SITE_ID+'::'+RESOURCE_NAME AS RESOURCE_ID
        --       ,RESOURCE_NAME                   AS RESOURCE_NAME
        --       ,FROM_SITE_ID                    AS SITE_ID
        --       ,STAGE                           AS STAGE
        --       ,'MOVE'                          AS RESOURCE_TYPE
        --       ,NULL                            AS FROZENCARRYOVERDATE
        --       ,NULL                            AS FROZENCARRYOVERSETUPGROUPNAME
        --       ,NULL                            AS FROZENCARRYOVERSETUPITEMNAME
        --       ,NULL                            AS GROUP_SETUP_CONTROL_CODE
        --       ,NULL                            AS ITEM_SETUP_CONTROL_CODE
        --       ,NULL                            AS GROUP_ALLOCATION_CONTROL_CODE
        --       ,NULL                            AS ITEM_ALLOCATION_CONTROL_CODE
        --       ,NULL                            AS EVERY_UPPER_CONTROL_CODE
        --       ,NULL                            AS EVERY_LOWER_CONTROL_CODE
        --       ,'MOVE'                          AS HORIZON_UPPER_CONTROL_CODE
        --       ,'MOVE'                          AS HORIZON_LOWER_CONTROL_CODE
        --       ,FROM_SITE_ID                    AS ATTRIBUTE1
        --       ,NULL                            AS ATTRIBUTE2
        --       ,STAGE                           AS ATTRIBUTE3
        --       ,NULL                            AS ATTRIBUTE14
        --       ,NULL                            AS ATTRIBUTE15
        --FROM(
        --    SELECT SEGMENT4                      AS FROM_SITE_ID
        --          ,SEGMENT5                      AS STAGE
        --          ,'PACKING_EQUIPMENT@'+SEGMENT5 AS RESOURCE_NAME
        --    FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
        --    WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
        --    AND    VALID_YN    = 'Y'
        --    AND    SEGMENT2    = @V_DIVISION_ID
        --    GROUP BY  SEGMENT4, SEGMENT5
        --    ) PE

        ------------------------------------------------------------------------
        -- LINE FULL LOADING 제약이 있으면 DINAMIC RAMP UP 적용을 위해 IDLE 데이터 추가
        -- 2025-07-29 THK
        ------------------------------------------------------------------------ 
        UPDATE  RE
        SET     RE.HORIZON_UPPER_CONTROL_CODE = 'FULL_LOADING'
               ,RE.EVERY_LOWER_CONTROL_CODE = 'FULL_LOADING'
        FROM    SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_LINE'
                AND LU.VALID_YN    = 'Y'
                AND LU.SEGMENT1    = @V_DIVISION_ID
                AND LU.SEGMENT2    = @V_GROUP_ID
                AND LU.SEGMENT3    = RE.ATTRIBUTE1
                AND LU.SEGMENT4    = RE.ATTRIBUTE3
        WHERE   RE.PLAN_ID = @V_PLAN_ID
        AND     RE.RESOURCE_TYPE = 'LINE'


        ------------------------------------------------------------------------
        -- EQUIPMENT FULL LOADING 제약적용을 위해 기존 데이터 삭제 후 호기별로 LINE 증가
        -- 2025-08-06 THK
        ------------------------------------------------------------------------ 
        -- 기존 데이터 삭제를 위한 MARKING
        --UPDATE  RE
        --SET     RE.ATTRIBUTE14 = 'DEL'
        --FROM    SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)
        --    INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        --        ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_EQ'
        --        AND LU.VALID_YN    = 'Y'
        --        AND LU.SEGMENT1    = @V_DIVISION_ID
        --        AND LU.SEGMENT2    = @V_GROUP_ID
        --        AND LU.SEGMENT3    = RE.ATTRIBUTE1
        --        AND LU.SEGMENT4    = RE.ATTRIBUTE3
        --        AND RE.RESOURCE_TYPE = 'LINE'
        --WHERE   RE.PLAN_ID = @V_PLAN_ID

        INSERT INTO SCP_OPT_ENG_RESOURCE_SN(PLAN_ID
                                           ,RESOURCE_ID
                                           ,RESOURCE_NAME
                                           ,SITE_ID
                                           ,STAGE
                                           ,RESOURCE_TYPE
                                           ,FROZENCARRYOVERDATE
                                           ,FROZENCARRYOVERSETUPGROUPNAME
                                           ,FROZENCARRYOVERSETUPITEMNAME
                                           ,GROUP_SETUP_CONTROL_CODE
                                           ,ITEM_SETUP_CONTROL_CODE
                                           ,GROUP_ALLOCATION_CONTROL_CODE
                                           ,ITEM_ALLOCATION_CONTROL_CODE
                                           ,EVERY_UPPER_CONTROL_CODE
                                           ,EVERY_LOWER_CONTROL_CODE
                                           ,HORIZON_UPPER_CONTROL_CODE
                                           ,HORIZON_LOWER_CONTROL_CODE
                                           ,USER_ATTB1
                                           ,USER_ATTB2
                                           ,USER_ATTB3
                                           ,USER_ATTB4
                                           ,USER_ATTB5
                                           ,USER_ATTB6
                                           ,USER_ATTB7
                                           ,USER_ATTB8
                                           ,USER_ATTB9
                                           ,ATTRIBUTE1
                                           ,ATTRIBUTE2
                                           ,ATTRIBUTE3
                                           ,ATTRIBUTE4
                                           ,ATTRIBUTE5
                                           ,ATTRIBUTE6
                                           ,ATTRIBUTE7
                                           ,ATTRIBUTE8
                                           ,ATTRIBUTE9
                                           ,ATTRIBUTE10
                                           ,ATTRIBUTE11
                                           ,ATTRIBUTE12
                                           ,ATTRIBUTE13
                                           ,ATTRIBUTE14
                                           ,ATTRIBUTE15
                                            )
        SELECT  RE.PLAN_ID                                                                                AS PLAN_ID
               ,RE.ATTRIBUTE1+'::'+RE.ATTRIBUTE15+'_'+CONVERT(NVARCHAR(1000),LU.EQ_QTY)+'@'+RE.ATTRIBUTE4 AS RESOURCE_ID
               ,RE.ATTRIBUTE15+'_'+CONVERT(NVARCHAR(1000),LU.EQ_QTY)+'@'+RE.ATTRIBUTE4                    AS RESOURCE_NAME
               ,RE.SITE_ID                                                                                AS SITE_ID
               ,RE.STAGE                                                                                  AS STAGE
               ,'EQ'                                                                                      AS RESOURCE_TYPE
               ,RE.FROZENCARRYOVERDATE                                                                    AS FROZENCARRYOVERDATE
               ,RE.FROZENCARRYOVERSETUPGROUPNAME                                                          AS FROZENCARRYOVERSETUPGROUPNAME
               ,RE.FROZENCARRYOVERSETUPITEMNAME                                                           AS FROZENCARRYOVERSETUPITEMNAME
               ,'EQ'                                                                                      AS GROUP_SETUP_CONTROL_CODE
               ,'EQ'                                                                                      AS ITEM_SETUP_CONTROL_CODE
               ,'EQ'                                                                                      AS GROUP_ALLOCATION_CONTROL_CODE
               ,'EQ'                                                                                      AS ITEM_ALLOCATION_CONTROL_CODE
               ,'EQ'                                                                                      AS EVERY_UPPER_CONTROL_CODE
               ,'FULL_LOADING'                                                                            AS EVERY_LOWER_CONTROL_CODE
               ,NULL                                                                                      AS HORIZON_UPPER_CONTROL_CODE
               ,NULL                                                                                      AS HORIZON_LOWER_CONTROL_CODE
               ,RE.USER_ATTB1                                                                             AS USER_ATTB1
               ,RE.USER_ATTB2                                                                             AS USER_ATTB2
               ,RE.USER_ATTB3                                                                             AS USER_ATTB3
               ,RE.USER_ATTB4                                                                             AS USER_ATTB4
               ,RE.USER_ATTB5                                                                             AS USER_ATTB5
               ,RE.USER_ATTB6                                                                             AS USER_ATTB6
               ,RE.USER_ATTB7                                                                             AS USER_ATTB7
               ,RE.USER_ATTB8                                                                             AS USER_ATTB8
               ,RE.USER_ATTB9                                                                             AS USER_ATTB9
               ,RE.ATTRIBUTE1                                                                             AS ATTRIBUTE1
               ,RE.ATTRIBUTE2                                                                             AS ATTRIBUTE2
               ,RE.ATTRIBUTE3                                                                             AS ATTRIBUTE3
               ,RE.ATTRIBUTE4                                                                             AS ATTRIBUTE4
               ,RE.ATTRIBUTE5                                                                             AS ATTRIBUTE5
               ,RE.ATTRIBUTE6                                                                             AS ATTRIBUTE6
               ,RE.ATTRIBUTE7                                                                             AS ATTRIBUTE7
               ,RE.ATTRIBUTE8                                                                             AS ATTRIBUTE8
               ,RE.ATTRIBUTE9                                                                             AS ATTRIBUTE9
               ,RE.ATTRIBUTE10                                                                            AS ATTRIBUTE10
               ,RE.ATTRIBUTE11                                                                            AS ATTRIBUTE11
               ,RE.ATTRIBUTE12                                                                            AS ATTRIBUTE12
               ,RE.ATTRIBUTE13                                                                            AS ATTRIBUTE13
               ,NULL                                                                                      AS ATTRIBUTE14
               ,RE.ATTRIBUTE15+'_'+CONVERT(NVARCHAR(1000),LU.EQ_QTY)                                      AS ATTRIBUTE15
        FROM    SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)                                                    
            INNER JOIN(                                                                                    
                      SELECT LU.SEGMENT1   AS DIVISION_ID                                                  
                            ,LU.SEGMENT2   AS GROUP_ID
                            ,LU.SEGMENT3   AS SITE_ID
                            ,LU.SEGMENT4   AS STAGE
                            ,NUM.NUM       AS EQ_QTY
                            ,LU.ATTRIBUTE2 AS MARGIN
                      FROM(
                          SELECT  TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NUM
                          FROM    sys.objects
                          ) NUM
                        INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                            ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_FULL_LOADING_EQ'
                            AND LU.VALID_YN = 'Y'
                            AND NUM.NUM <= LU.ATTRIBUTE1
                            AND LU.SEGMENT1    = @V_DIVISION_ID
                            AND LU.SEGMENT2    = @V_GROUP_ID
                     ) LU
                ON  LU.SITE_ID = RE.ATTRIBUTE1
                AND LU.STAGE   = RE.ATTRIBUTE3
                AND RE.RESOURCE_TYPE = 'LINE'
        WHERE   1=1
        AND     RE.PLAN_ID = @V_PLAN_ID

        --DELETE FROM SCP_OPT_ENG_RESOURCE_SN
        --WHERE PLAN_ID = @V_PLAN_ID
        --AND   ATTRIBUTE14 = 'DEL'
        ------------------------------------------------------------------------
        -- 비율 별 CAPA 할당 제약
        -- 적용 시 주석 제거 필요
        ------------------------------------------------------------------------   
        --SELECT @V_PLAN_ID                   AS PLAN_ID
        --      ,SITE_ID + '::' + CNG_LINE_ID AS REOSURCE_ID
        --      ,CNG_LINE_ID                  AS RESOURCE_NAME
        --      ,SITE_ID                      AS SITE_ID
        --      ,'COATING'                    AS STAGE
        --      ,'LINE'                       AS RESOURCE_TYPE
        --      ,NULL                         AS FROZENCARRYOVERDATE
        --      ,NULL                         AS FROZENCARRYOVERSETUPGROUPNAME
        --      ,NULL                         AS FROZENCARRYOVERSETUPITEMNAME
        --      ,'COATING'                    AS GROUP_SETUP_CONTROL_CODE
        --      ,'COATING'                    AS ITEM_SETUP_CONTROL_CODE
        --      ,NULL                         AS GROUP_ALLOCATION_CONTROL_CODE
        --      ,NULL                         AS ITEM_ALLOCATION_CONTROL_CODE
        --      ,'LINE'                       AS EVERY_UPPER_CONTROL_CODE
        --      ,'LINE'                       AS EVERY_LOWER_CONTROL_CODE
        --      ,NULL                         AS HORIZON_UPPER_CONTROL_CODE
        --      ,NULL                         AS HORIZON_LOWER_CONTROL_CODE
        --      ,SITE_ID                      AS ATTRIBUTE1
        --      ,ITEM_ID                      AS ATTRIBUTE2
        --      ,'COATING'                    AS ATTRIBUTE3
        --      ,LINE_ID                      AS ATTRIBUTE15
        --FROM(
        --     SELECT AL.SEGMENT3   AS SITE_ID
        --           ,AL.SEGMENT4   AS LINE_ID
        --           ,IIF(ALI.SEGMENT5 = '81',AL.SEGMENT4+'@Auto',AL.SEGMENT4+'@ESS') AS CNG_LINE_ID
        --           ,ALI.SEGMENT4  AS ITEM_ID
        --           ,ALI.SEGMENT5  AS DEVISION_ID
        --           ,AL.ATTRIBUTE1 AS AUTO_RATIO
        --           ,AL.ATTRIBUTE2 AS ESS_RATIO
        --           ,AL.ATTRIBUTE3 AS EFF_START_DATE
        --           ,AL.ATTRIBUTE4 AS EFF_END_DATE
        --     FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL AL WITH(NOLOCK)
        --         INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL ALI WITH(NOLOCK)
        --             ON  AL.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CAPA_ALLOCATION'
        --             AND ALI.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CAPA_ALLOCATION_ITEM'
        --             AND AL.SEGMENT3 = ALI.SEGMENT2
        --             AND AL.SEGMENT4 = ALI.SEGMENT3
        --             AND AL.VALID_YN  = 'Y'
        --             AND ALI.VALID_YN = 'Y'
        --     ) CAL
            --INNER JOIN SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
            --    ON  CAL.LINE_ID      = RS.RESOURCE_NAME
            --    AND CAL.SITE_ID      = RS.SITE_ID
            --    AND RS.RESOURCE_TYPE = 'LINE'
            --    AND RS.PLAN_ID       = @V_PLAN_ID
        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------
		
		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

		IF OBJECT_ID('TEMPDB..#TACT_TIME') IS NOT NULL
		BEGIN 
			DROP TABLE  #TACT_TIME;
		END;

	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------
      -- ERROR LOG
	------------------------------------------------------------------------
        SET @V_MESSAGE_TEXT = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'ERROR',NULL,@V_MESSAGE_TEXT,NULL,@V_PLAN_ID
        ------------------------------------------------------------------------
        SELECT @V_DETAIL_DATE = GETDATE()
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,@V_DETAIL_DATE,NULL,@V_MESSAGE_TEXT,'ERROR'
        ------------------------------------------------------------------------
        RAISERROR(@V_PROGRAM_NAME, 16,1)
        ------------------------------------------------------------------------
    END CATCH
	------------------------------------------------------------------------

	------------------------------------------------------------------------
    -- 종료 LOG
    ------------------------------------------------------------------------
    IF @V_MESSAGE_TEXT IS NULL 
    ------------------------------------------------------------------------
    BEGIN
	    EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'END',NULL,NULL,NULL,@V_PLAN_ID
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL
    END
    ------------------------------------------------------------------------
  END;
