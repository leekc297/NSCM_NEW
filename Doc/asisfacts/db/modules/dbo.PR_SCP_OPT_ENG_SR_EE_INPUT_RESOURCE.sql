
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_SR_EE_INPUT_RESOURCE]
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_SR_EE_INPUT_RESOURCE';
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

    DECLARE @V_SINGLE_PLAN_TYPE     NVARCHAR(1);
    DECLARE @V_PLAN_GROUP_ORG       NVARCHAR(20);

    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    SELECT @V_SINGLE_PLAN_TYPE = CASE WHEN RIGHT(@V_GROUP_ID, 2) = '_C' THEN 'C' WHEN RIGHT(@V_GROUP_ID, 2) = '_A' THEN 'A' ELSE '-' END;
    SELECT @V_PLAN_GROUP_ORG = CASE WHEN RIGHT(@V_GROUP_ID, 2) IN ('_C', '_A') THEN LEFT(@V_GROUP_ID, LEN(@V_GROUP_ID) - 2) ELSE @V_GROUP_ID END;
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

		SELECT DIVISION_ID 
		INTO #DIVISION
		FROM SCM_MST_DIVISION WITH(NOLOCK)
		WHERE  VALID_YN = 'Y'
		AND    ATTRIBUTE3 <> 'EE'
		AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) -- 전극 Division 변수
		;

        /*
		SELECT DIVISION_ID, PLANT_ID, ITEM_ID, LINE_ID, MONTH, TACT_TIME, OPERATION_ID, STAGE, SCM_SITE_ID
		INTO #TACT_TIME
		FROM (  
				--SELECT    LU.SEGMENT2   AS DIVISION_ID
				--		, LU.SEGMENT3   AS PLANT_ID
				--		, LU.SEGMENT4   AS SCM_SITE_ID
				--		, LU.SEGMENT5   AS OPERATION_ID
				--		, LU.ATTRIBUTE1 AS LINE_ID
				--		, LU.ATTRIBUTE2 AS ITEM_ID
				--		, LU.ATTRIBUTE3 AS MONTH
				--		, CONVERT(FLOAT, ATTRIBUTE4) AS TACT_TIME 
				--		, 'COATING'     AS STAGE 
						 
				--FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
				--WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_MASTER_CAPA_TEMP'
				--AND    LU.VALID_YN    = 'Y'
				--AND    LU.SEGMENT2    = @V_DIVISION_ID
				--AND    LU.SEGMENT5    = 'E2000'
				--AND    LU.ATTRIBUTE3  BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
				--/************************* 
				--대상 프로젝트 ITEM 필터링 
				--*************************/
				--AND CONCAT(LU.SEGMENT4, LU.ATTRIBUTE2) 
				--  IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
				--	  FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
				--	  WHERE  PLAN_ID = @V_PLAN_ID
				--	 )

                -- 2025.10.21 Minyong Lee : Lookup -> UI Table 전환
                SELECT  CP.DIVISION_ID      AS DIVISION_ID
                      , CP.PLANT_ID         AS PLANT_ID
                      , ST.SCM_SITE_ID      AS SCM_SITE_ID
                      , CP.OPERATION_ID     AS OPERATION_ID
                      , CP.LINE_ID          AS LINE_ID
                      , CP.ITEM_ID          AS ITEM_ID
                      , CP.YYYYMM           AS MONTH
                      , CONVERT(FLOAT, 60 / (CONVERT(NUMERIC(20, 10), CONVERT(FLOAT, CP.M_MIN)) * (ISNULL(CP.PRDN_OPER_RT, 100) / 100))) / CONVERT(FLOAT, (CP.LANE * (IIF(CP.WIDE_YN='Y',2,1)))) AS TACT_TIME
                      , 'COATING'       AS STAGE
                FROM    SCP_OPMZ_DDLY_CAPA CP WITH(NOLOCK)
	                LEFT JOIN (
				                SELECT	OPERATION_ID
					                  , OPERATION_GROUP
				                FROM	SCM_MST_OPERATION_FLOW_V
				                WHERE	1=1
				                AND		VALID_YN = 'Y'
				                GROUP BY
						                OPERATION_ID
					                  , OPERATION_GROUP
				                ) OP
		                ON	CP.OPERATION_ID = OP.OPERATION_ID
	                LEFT JOIN (
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
		                ON	CP.PLANT_ID = ST.PLANT_ID
		                AND	OP.OPERATION_GROUP = ST.OPERATION_GROUP
                WHERE   1=1
                AND     CP.VALID_YN    = 'Y'
                AND     CP.DIVISION_ID    = @V_DIVISION_ID
                AND     CP.OPERATION_ID    = 'E2000'
                AND     CP.YYYYMM  BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
                AND     CONVERT(NUMERIC(20, 10), CONVERT(FLOAT, CP.M_MIN)) > 0
                AND     CP.LANE > 0
                AND     CP.WIDE_YN IS NOT NULL
                AND		(CP.PRDN_OPER_RT > 0 OR CP.PRDN_OPER_RT IS NULL)
                /************************* 
				대상 프로젝트 ITEM 필터링 
				*************************/
                AND     CONCAT(ST.SCM_SITE_ID, CP.ITEM_ID) 
	                IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID)
		                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
		                WHERE  PLAN_ID = @V_PLAN_ID
		                )
		
		        --  FP 정보
				--SELECT A.DIVISION_ID AS DIVISION_ID
				--	  ,A.PLANT_ID    AS PLANT_ID
				--	  ,A.ITEM_ID     AS ITEM_ID
				--	  ,A.LINE_ID     AS LINE_ID
				--	  ,A.MONTH       AS MONTH
				--	  ,A.TACT_TIME   AS TACT_TIME
				--	  ,A.OPERATION_ID AS OPERATION_ID
				--	  ,'COATING'      AS STAGE
				--	  ,PLANT_ID +'-E' AS SCM_SITE_ID
				--FROM   SCM_MST_TACT_TIME_SN A WITH(NOLOCK)

				--INNER JOIN #DIVISION D WITH(NOLOCK)
				--ON A.DIVISION_ID = D.DIVISION_ID

				--WHERE  1=1
				--AND    A.OPERATION_ID IN ('E2000')
				--AND    A.MONTH BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
				--/************************* 
				--대상 프로젝트 ITEM 필터링 
				--*************************/
				--AND CONCAT(CONCAT(A.PLANT_ID,'-E'), A.ITEM_ID) 
				--  IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
				--	  FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
				--	  WHERE  PLAN_ID = @V_PLAN_ID
				--	 )
			) B; */

            -- 2026-03-23, 사업부 통합적용
            SELECT ML.SCM_SITE_ID
                  ,ILA.LINE_ID      AS RESOURCE_NAME
                  ,CAST(NULL AS NVARCHAR(50)) AS STAGE -- 같은 라인에 PACK, MDLE 모두 ASSIGN된 CASE 존재시 DUP 에러
                  ,CAST(NULL AS NVARCHAR(50)) AS ITEM_ID
                  ,ILA.LINE_ID      AS LINE_ID
                  ,'LINE'           AS RESOURCE_TYPE
            INTO #TACT_TIME
            FROM SCM_MST_ITEM_LINE_ASSIGN_SN ILA WITH(NOLOCK) 
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
                    ON  ILA.DIVISION_ID = ML.DIVISION_ID
                    AND ILA.COMPANY_ID  = ML.COMPANY_ID
                    AND ILA.SITE_ID     = ML.SITE_ID
                    AND ILA.PLANT_ID    = ML.PLANT_ID
                    AND ILA.ITEM_ID     = ML.ITEM_ID
                INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)
                    ON  ILA.DIVISION_ID  = LM.DIVISION_ID
                    AND ILA.COMPANY_ID   = LM.COMPANY_ID
                    AND ILA.SITE_ID      = LM.SITE_ID
                    AND ILA.PLANT_ID     = LM.PLANT_ID
                    AND ILA.LINE_ID      = LM.LINE_ID
					AND ILA.OPERATION_ID = LM.OPERATION_ID
                    AND LM.ACTIVE_FLAG   = 'Y'
                INNER JOIN #DIVISION DIV WITH(NOLOCK)
                    ON  DIV.DIVISION_ID = ILA.DIVISION_ID
            WHERE   1=1
            AND ILA.MONTH  BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM 
            AND ILA.OPERATION_ID = 'E2000'
            GROUP BY ML.SCM_SITE_ID
                    ,ILA.LINE_ID
            ;

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

		-- PR_SCP_OPT_ENG_EE_INPUT_FROZEN_PLAN/IBR 에서 동일 정보 사용
  --      SELECT  @V_PROD_FROZEN = SEGMENT4
		--FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		--WHERE   LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN'
		--AND     VALID_YN    = 'Y'
		--AND     SEGMENT1    = @V_DIVISION_ID -- 전극 Division 변수
		--AND     SEGMENT2    = @V_GROUP_ID
  --      --AND     SEGMENT3    = 'PR' --임시
  --      AND     SEGMENT3    = @V_SCP_PLAN_TYPE  -- 전극 Division 기준
        ;

        ------------------------------------------------------------------------------------------
        -- 2025.05.20 Philsu Park: Packing Equipment Temp 생성.
        ------------------------------------------------------------------------------------------
        IF OBJECT_ID('TEMPDB..#PACKING_EQUIPMENT') IS NOT NULL
		BEGIN 
			DROP TABLE  #PACKING_EQUIPMENT;
		END;

        -- Model 별 Input: Model GROUP 단위로 동일 MIN, MAX 적용.
        -- 2025.05.28 Philsu Park: TO_DATE는 하루 더해줌.
        -- 2025.07.24 Philsu Park: Plan Horizon 내에 해당하는 PACKING EQP 정보만 추출.
        WITH MODEL_GROUP AS (
                --SELECT    SEGMENT2                                  AS DIVISION
                --        , SEGMENT3                                  AS PLAN_GROUP
                --        , SEGMENT5                                  AS MODEL_GROUP
                --        , GREATEST(@V_PLAN_START_YYYYMMDD, MIN(ATTRIBUTE4))                           AS FROM_DATE
                --        , LEAST(@V_PLAN_END_YYYYMMDD, CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE, MAX(ATTRIBUTE5), 112)), 112)) AS TO_DATE
                --        , MIN(CONVERT(NUMERIC(20,10), ATTRIBUTE6))  AS LOWER_QTY
                --        , MAX(CONVERT(NUMERIC(20,10), ATTRIBUTE7))  AS UPPER_QTY
                --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
                --WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
                --AND     D.VALID_YN      = 'Y'  -- ***!!!Valid Flag는 나중에 살려야됨!!!***
                --AND     D.SEGMENT2      = @V_DIVISION_ID
                --AND     D.SEGMENT3      = @V_GROUP_ID
                --GROUP BY SEGMENT2, SEGMENT3, SEGMENT5

                -- 2025.11.24 Minyong Lee : Lookup -> UI 전환 (Packing Equipment)
                SELECT    CS.DIVISION_ID                                 AS DIVISION
                        , PG.OPMZ_PLAN_GR_NAME                           AS PLAN_GROUP
                        , CS.MDL_GR_NM                                   AS MODEL_GROUP
                        , GREATEST(@V_PLAN_START_YYYYMMDD, MIN(CS.FROM_YYYYMMDD))                           AS FROM_DATE
                        , LEAST(@V_PLAN_END_YYYYMMDD, CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE, MAX(CS.TO_YYYYMMDD), 112)), 112)) AS TO_DATE
                        --, MIN(CONVERT(NUMERIC(20,10), CS.SIPM_MIN_QTY))  AS LOWER_QTY
                        , MIN(CONVERT(NUMERIC(20,10), CS.SIPM_MIN_QYT))  AS LOWER_QTY
                        , MAX(CONVERT(NUMERIC(20,10), CS.SIPM_MAX_QTY))  AS UPPER_QTY
                FROM    SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS WITH(NOLOCK)
                    LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                        ON  CS.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                        AND PG.VALID_YN = 'Y'
                    INNER JOIN  (
                                SELECT  DISTINCT ITEM_ID
                                FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                WHERE   PLAN_ID = @V_PLAN_ID
                                ) MDL
                        ON  CS.ITEM_ID = MDL.ITEM_ID
                WHERE   1=1
                AND     CS.VALID_YN          = 'Y'
                AND     CS.DIVISION_ID       = @V_DIVISION_ID
                AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                GROUP BY CS.DIVISION_ID, PG.OPMZ_PLAN_GR_NAME, CS.MDL_GR_NM
            )
        -- 동일 모델 여러줄 나오는 경우가 있어 DISTINCT 처리.
        --SELECT    DISTINCT 
        --          D.SEGMENT2                                  AS DIVISION
        --        , D.SEGMENT3                                  AS PLAN_GROUP
        --        , D.SEGMENT4                                  AS MODEL
        --        , D.SEGMENT5                                  AS MODEL_GROUP
        --        , D.ATTRIBUTE1                                AS FROM_SITE
        --        , D.ATTRIBUTE2                                AS STAGE
        --        , D.ATTRIBUTE3                                AS TO_SITE
        --        , GRP.FROM_DATE                               AS FROM_DATE
        --        , GRP.TO_DATE                                 AS TO_DATE
        --        , GRP.LOWER_QTY                               AS LOWER_QTY
        --        , GRP.UPPER_QTY                               AS UPPER_QTY
        --INTO    #PACKING_EQUIPMENT
        --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
        --INNER JOIN MODEL_GROUP GRP
        --    ON  GRP.DIVISION    = D.SEGMENT2
        --    AND GRP.PLAN_GROUP  = D.SEGMENT3
        --    AND GRP.MODEL_GROUP = D.SEGMENT5
        --WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
        --AND     D.VALID_YN      = 'Y'
        --AND     D.SEGMENT2      = @V_DIVISION_ID
        --AND     D.SEGMENT3      = @V_GROUP_ID
        --AND     GRP.FROM_DATE   < @V_PLAN_END_YYYYMMDD
        --AND     GRP.TO_DATE    >= @V_PLAN_START_YYYYMMDD
        --;

        -- 2025.11.24 Minyong Lee : Lookup -> UI 전환 (Packing Equipment)
        SELECT    DISTINCT 
                  CS.DIVISION_ID                        AS DIVISION
                , PG.OPMZ_PLAN_GR_NAME                  AS PLAN_GROUP
                , CS.ITEM_ID                            AS MODEL
                , CS.MDL_GR_NM                          AS MODEL_GROUP
                , CS.FROM_STE_ID                        AS FROM_SITE
                , CS.STAGE                              AS STAGE
                , CS.TO_STE_ID                          AS TO_SITE
                , GRP.FROM_DATE                         AS FROM_DATE
                , GRP.TO_DATE                           AS TO_DATE
                , GRP.LOWER_QTY                         AS LOWER_QTY
                , GRP.UPPER_QTY                         AS UPPER_QTY
        INTO    #PACKING_EQUIPMENT
        FROM    SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS WITH(NOLOCK)
            LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                ON  CS.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                AND PG.VALID_YN = 'Y'
            INNER JOIN  (
                        SELECT  DISTINCT ITEM_ID
                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                        WHERE   PLAN_ID = @V_PLAN_ID
                        ) MDL
                ON  CS.ITEM_ID = MDL.ITEM_ID
            INNER JOIN MODEL_GROUP GRP
                ON  GRP.DIVISION    = CS.DIVISION_ID
                AND GRP.PLAN_GROUP  = PG.OPMZ_PLAN_GR_NAME
                AND GRP.MODEL_GROUP = CS.MDL_GR_NM
        WHERE   1=1
        AND     CS.VALID_YN          = 'Y'
        AND     CS.DIVISION_ID          = @V_DIVISION_ID
        AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
        AND     GRP.FROM_DATE        < @V_PLAN_END_YYYYMMDD
        AND     GRP.TO_DATE          >= @V_PLAN_START_YYYYMMDD
        ;

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
              ,ATTRIBUTE15
              --,ATTRIBUTE14
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
              ,LINE_ID                                                   AS ATTRIBUTE15
              --,OPERATION_ID                                              AS ATTRIBUTE14
        FROM(
            ------------------------------------------------------------------------
            -- Add Plant 
            ------------------------------------------------------------------------
            SELECT A.PLANT_SITE_ID AS SITE
                  ,A.ITEM_ID       AS RESOURCE_NAME
                  ,'COATING'       AS STAGE
                  ,A.ITEM_ID       AS ITEM_ID
                  ,NULL            AS LINE_ID
                  ,CASE WHEN A.ITEM_ID = '-' THEN 'PLANT' ELSE 'MODEL' END RESOURCE_TYPE
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
            ------------------------------------------------------------------------
            UNION ALL
            SELECT A.PLANT_SITE_ID AS SITE
                  ,A.ITEM_ID       AS RESOURCE_NAME
                  ,'COATING'       AS STAGE
                  ,A.ITEM_ID       AS ITEM_ID
                  ,NULL            AS LINE_ID
                  ,CASE WHEN A.ITEM_ID = '-' THEN 'PLANT' ELSE 'MODEL' END RESOURCE_TYPE
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
            -- 2026-03-10, 사업부 통합적용 추가
            SELECT TT.SCM_SITE_ID
                  ,TT.RESOURCE_NAME
                  ,TT.STAGE
                  ,TT.ITEM_ID
                  ,TT.LINE_ID
                  ,TT.RESOURCE_TYPE
            FROM   #TACT_TIME TT WITH(NOLOCK)
            /*
            SELECT ML.SCM_SITE_ID   AS SITE
                  ,ILA.LINE_ID      AS RESOURCE_NAME
                  ,TT.STAGE         AS STAGE
                  ,NULL             AS ITEM_ID
                  ,ILA.LINE_ID      AS LINE_ID
                  ,'LINE'           AS RESOURCE_TYPE
                  --,ILA.OPERATION_ID AS OPERATION_ID
            FROM SCM_MST_ITEM_LINE_ASSIGN_SN ILA WITH(NOLOCK) 
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
                    AND ILA.LINE_ID      = TT.LINE_ID
                    AND ILA.OPERATION_ID = TT.OPERATION_ID
                    AND ILA.ITEM_ID      = TT.ITEM_ID
                    AND TT.MONTH  BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
                INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)
                    ON  ILA.DIVISION_ID  = LM.DIVISION_ID
                    AND ILA.COMPANY_ID   = LM.COMPANY_ID
                    AND ILA.SITE_ID      = LM.SITE_ID
                    AND ILA.PLANT_ID     = LM.PLANT_ID
                    AND ILA.LINE_ID      = LM.LINE_ID
					AND ILA.OPERATION_ID = LM.OPERATION_ID
                    AND LM.ACTIVE_FLAG = 'Y'
            WHERE   1=1
            GROUP BY ML.SCM_SITE_ID,ILA.LINE_ID, TT.STAGE */
            ) AS A
        ------------------------------------------------------------------------
        -- APPLY TO TOOL CONSTRAINT AND DATA INSERT
        ------------------------------------------------------------------------ 
		 -- 전극 Line / 인원 제약은 별도 처리 방안 필요함
        UNION ALL
        SELECT  @V_PLAN_ID                     AS PLAN_ID
               ,LU.SEGMENT3+'::'+LU.SEGMENT5   AS RESOURCE_ID
               ,LU.SEGMENT5                    AS RESOURCE_NAME
               ,LU.SEGMENT3                    AS SITE_ID
               ,'COATING'                      AS STAGE
               ,'LINE'                         AS RESOURCE_TYPE
				,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(PF.FROZEN_END_DATE)),112)+':000000' AS FROZENCARRYOVERDATE
				,LU.SEGMENT3+'::'+LU.SEGMENT5  AS FROZENCARRYOVERSETUPGROUPNAME
				,'COATING'				       AS FROZENCARRYOVERSETUPITEMNAME 
               ,'LINECHANGE'                   AS GROUP_SETUP_CONTROL_CODE
               ,'LINECHANGE'                   AS ITEM_SETUP_CONTROL_CODE
               ,NULL                           AS GROUP_ALLOCATION_CONTROL_CODE
               ,NULL                           AS ITEM_ALLOCATION_CONTROL_CODE
               ,'LINE'				           AS EVERY_UPPER_CONTROL_CODE
               ,'LINE'                         AS EVERY_LOWER_CONTROL_CODE
               ,NULL                           AS HORIZON_UPPER_CONTROL_CODE
               ,NULL                           AS HORIZON_LOWER_CONTROL_CODE
               ,LU.SEGMENT3                    AS ATTRIBUTE1
               ,NULL                           AS ATTRIBUTE2
               ,'COATING'                      AS ATTRIBUTE3
               ,LU.SEGMENT5                    AS ATTRIBUTE15
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
        AND     LU.SEGMENT2 = @V_DIVISION_ID
		AND     LU.ATTRIBUTE5 = @V_GROUP_ID
        AND     LU.VALID_YN ='Y'
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
        -- 2025.05.20 Philsu Park: Temp Table 기준으로 반영.
        ------------------------------------------------------------------------   
        UNION ALL
        SELECT  @V_PLAN_ID                      AS PLAN_ID
               ,FROM_SITE_ID+'::'+RESOURCE_NAME AS RESOURCE_ID
               ,RESOURCE_NAME                   AS RESOURCE_NAME
               ,FROM_SITE_ID                    AS SITE_ID
               ,STAGE                           AS STAGE
               ,'MOVE'                          AS RESOURCE_TYPE
               ,NULL                            AS FROZENCARRYOVERDATE
               ,NULL                            AS FROZENCARRYOVERSETUPGROUPNAME
               ,NULL                            AS FROZENCARRYOVERSETUPITEMNAME
               ,NULL                            AS GROUP_SETUP_CONTROL_CODE
               ,NULL                            AS ITEM_SETUP_CONTROL_CODE
               ,NULL                            AS GROUP_ALLOCATION_CONTROL_CODE
               ,NULL                            AS ITEM_ALLOCATION_CONTROL_CODE
               ,'MOVE'                          AS EVERY_UPPER_CONTROL_CODE -- TYPE B 적용후 추가/20251110/T.H.KIM
               ,'MOVE'                          AS EVERY_LOWER_CONTROL_CODE -- TYPE B 적용후 추가/20251110/T.H.KIM
               ,'MOVE'                          AS HORIZON_UPPER_CONTROL_CODE
               ,'MOVE'                          AS HORIZON_LOWER_CONTROL_CODE
               ,FROM_SITE_ID                    AS ATTRIBUTE1
               ,NULL                            AS ATTRIBUTE2
               ,STAGE                           AS ATTRIBUTE3
               ,NULL                            AS ATTRIBUTE15
        FROM(
            SELECT    PKG.FROM_SITE             AS FROM_SITE_ID
                    , PKG.STAGE                 AS STAGE
                    , PKG.TO_SITE               AS TO_SITE_ID
                    , CONCAT('PACKING_EQUIPMENT', '_', PKG.MODEL_GROUP, '@', PKG.STAGE, '::', PKG.TO_SITE) AS RESOURCE_NAME
            FROM    #PACKING_EQUIPMENT PKG
            GROUP BY PKG.MODEL_GROUP, PKG.FROM_SITE, PKG.STAGE, PKG.TO_SITE
            /* SELECT SEGMENT4                      AS FROM_SITE_ID
                  ,SEGMENT5                      AS STAGE
                  ,'PACKING_EQUIPMENT@'+SEGMENT5+'::'+ATTRIBUTE1 AS RESOURCE_NAME
            FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
            WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_EQUIPMENT'
            AND    VALID_YN    = 'Y'
            AND    SEGMENT2    = @V_DIVISION_ID
            GROUP BY  SEGMENT4, SEGMENT5, ATTRIBUTE1 */
            ) PE

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
        ;

        ------------------------------------------------------------------------
        -- 2025.08.14 Philsu Park
        -- 신규버전 라인 인원 제약 반영.
        -- 2025.09.05 Philsu Park: 서로 다른 Site가 동일 Line Group으로 묶일 수 있어 Group By 조건 변경.
        ------------------------------------------------------------------------  
        INSERT INTO SCP_OPT_ENG_RESOURCE_SN
            ( 
                  PLAN_ID
                , RESOURCE_ID
                , RESOURCE_NAME
                , SITE_ID
                , STAGE
                , RESOURCE_TYPE
                , EVERY_UPPER_CONTROL_CODE
                , EVERY_LOWER_CONTROL_CODE
                , ATTRIBUTE1
                , ATTRIBUTE3
                , ATTRIBUTE15
                , INSERT_ID
                , INSERT_TIME
                , UPDATE_ID
                , UPDATE_TIME
            )
            SELECT    @V_PLAN_ID            AS PLAN_ID
                    , CONCAT(LK.SITE_ID, '::', LK.LINE_GROUP) AS RESOURCE_ID
                    , LK.LINE_GROUP         AS RESOURCE_NAME
                    , LK.SITE_ID            AS SITE_ID
                    , LK.STAGE              AS STAGE
                    , 'TOOL'                AS RESOURCE_TYPE
                    , 'MP'                  AS EVERY_UPPER_CONTROL_CODE
                    , 'MP'                  AS EVERY_LOWER_CONTROL_CODE
                    , LK.SITE_ID            AS ATTRIBUTE1
                    , LK.STAGE              AS ATTRIBUTE3
                    , LK.LINE_GROUP         AS ATTRIBUTE15
                    , 'LINE_PERSONNEL_NEW'  AS INSERT_ID
                    , CURRENT_TIMESTAMP     AS INSERT_TIME
                    , 'LINE_PERSONNEL_NEW'  AS UPDATE_ID
                    , CURRENT_TIMESTAMP     AS UPDATE_TIME
            FROM    (
                        SELECT    
                                  LK.SEGMENT4   AS SITE_ID
                                -- , LK.SEGMENT5   AS LINE_ID
                                , LK.SEGMENT6   AS LINE_GROUP
                                , LK.SEGMENT7   AS STAGE
                                , MAX(LK.ATTRIBUTE1) AS TOTAL_PERSONS
                                , MAX(LK.ATTRIBUTE2) AS PERSONNEL_PER_LINE
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                        WHERE   LK.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_LINE_PERSONNEL_NEW'
                        AND     LK.VALID_YN     = 'Y'
                        AND     LK.SEGMENT2     = @V_DIVISION_ID
                        AND     LK.SEGMENT3     = @V_GROUP_ID
                        GROUP BY LK.SEGMENT4, LK.SEGMENT6, LK.SEGMENT7
                    ) LK
            ;
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
