


CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_ESS_INPUT_RESOURCE]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.05 Y.S.H Initial Release
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_ESS_INPUT_RESOURCE';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_PLAN_START_YYYYMM NVARCHAR(6);
    DECLARE @V_PLAN_END_YYYYMM   NVARCHAR(6);


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

		IF OBJECT_ID('TEMPDB..#TACT_TIME') IS NOT NULL
		BEGIN 
			DROP TABLE  #TACT_TIME;
		END;

		SELECT DIVISION_ID, PLANT_ID, ITEM_ID, LINE_ID, MONTH, TACT_TIME, OPERATION_ID, STAGE, SCM_SITE_ID
		INTO #TACT_TIME
		FROM (  -- 자사 Line TT 정보
				SELECT A.DIVISION_ID AS DIVISION_ID
					  ,A.PLANT_ID    AS PLANT_ID
					  ,A.ITEM_ID     AS ITEM_ID
					  ,A.LINE_ID     AS LINE_ID
					  ,A.MONTH       AS MONTH
					  ,A.TACT_TIME   AS TACT_TIME
					  ,A.OPERATION_ID   AS OPERATION_ID
					  ,CASE WHEN A.OPERATION_ID IN ('A3000', 'A9000') THEN 'ASSY'
					        WHEN A.OPERATION_ID IN ('P5500') THEN 'MDLE'
					        WHEN A.OPERATION_ID IN ('P9500') THEN 'PACK'
                            WHEN A.OPERATION_ID IN ('PL500') THEN 'LINK' -- 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응
					   END AS STAGE
					  ,A.SCM_SITE_ID AS SCM_SITE_ID
				FROM   (
      --                  SELECT SEGMENT2   AS DIVISION_ID
				  --           , SEGMENT3   AS PLANT_ID
				  --           , SEGMENT4   AS SCM_SITE_ID
				  --           , SEGMENT5   AS OPERATION_ID
				  --           , ATTRIBUTE1 AS LINE_ID
				  --           , ATTRIBUTE2 AS ITEM_ID
				  --           , ATTRIBUTE3 AS MONTH
				  --           , CONVERT(FLOAT, ATTRIBUTE4)  AS TACT_TIME
						--FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
						--WHERE  LOOKUP_TYPE = 'SCP_OPT_MASTER_CAPA_TEMP'
						--AND    VALID_YN    = 'Y'

                        -- 2025.10.21 Minyong Lee : Lookup -> UI Table 전환
                        SELECT	CP.DIVISION_ID		AS DIVISION_ID
	                          , CP.PLANT_ID			AS PLANT_ID
	                          , ST.SCM_SITE_ID		AS SCM_SITE_ID
	                          , CP.OPERATION_ID		AS OPERATION_ID
	                          , CP.LINE_ID			AS LINE_ID
	                          , CP.ITEM_ID			AS ITEM_ID
	                          , CP.YYYYMM			AS MONTH
	                          , 86400 / (CP.CAPA * (IIF(CP.PRDN_OPER_RT IS NULL, 100, CP.PRDN_OPER_RT) / 100)) AS TACT_TIME
                        FROM	SCP_OPMZ_DDLY_CAPA CP WITH(NOLOCK)
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
                        WHERE	CP.VALID_YN = 'Y'
                        AND		CP.CAPA > 0
                        AND		(CP.PRDN_OPER_RT > 0 OR CP.PRDN_OPER_RT IS NULL)

				       ) A
				WHERE  1=1
				AND    A.DIVISION_ID <> '40' -- 소형 제외 
				AND    A.DIVISION_ID  = @V_DIVISION_ID
				AND    A.OPERATION_ID IN ('A3000', 'A9000', 'P5500', 'P9500', 'PL500') -- 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응
				AND    A.MONTH BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
				AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
				  IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
					  FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
					  WHERE  PLAN_ID = @V_PLAN_ID
					 )
				-------------------------------------------------------------------------------------------
				UNION ALL
				-------------------------------------------------------------------------------------------
				-- 외주 Line TT 정보
				SELECT  SMO.DIVISION_ID			AS DIVISION_ID
					   ,SMS.PLANT_ID			AS PLANT_ID
					   ,SMO.ITEM_ID				AS ITEM_ID
					   ,SMO.LINE_ID				AS LINE_ID
					   ,@V_PLAN_START_YYYYMM	AS MONTH
					   ,SMO.TACT_TIME			AS TACT_TIME
					   ,FNL.FLOW_ID				AS OPERATION_ID
					   ,CASE  WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID  = 'P9500'    THEN 'LINK'
                              WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID  = 'PL500'    THEN 'LINK' -- 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응
							  WHEN FNL.OPERATION_GROUP_ID = 'P' AND FNL.FLOW_ID	 = 'R5500'    THEN 'RACK' 
							  WHEN FNL.OPERATION_GROUP_ID = 'B' AND FNL.FLOW_ID  = 'P9500'    THEN 'PACK'
							  WHEN FNL.OPERATION_GROUP_ID = 'B' AND FNL.FLOW_ID  = 'P5500'    THEN 'PACK'
							  WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID	 = 'P9500'    THEN 'PACK' 
							  WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID	 = 'P5000'    AND SMO.ITEM_ID NOT LIKE 'EP%'  THEN 'PACK' 
							  WHEN FNL.OPERATION_GROUP_ID = 'M' AND FNL.FLOW_ID  = 'P5000'    AND SMO.ITEM_ID LIKE 'EP%'      THEN 'PACK' 
							  ELSE '-'
						END						AS STAGE
					   ,SMS.SCM_SITE_ID			AS SCM_SITE_ID
				FROM    SCP_MST_TACT_TIME_OSP SMO WITH(NOLOCK)
						LEFT OUTER JOIN SCM_MST_SITE SMS WITH(NOLOCK)
							ON  SMO.DIVISION_ID   = SMS.DIVISION_ID
							AND SMO.PLANT_SITE_ID = SMS.SCM_SITE_ID
						INNER JOIN (
									SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, OPERATION_GROUP_ID,  FLOW_ID, ATTRIBUTE8
									FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
									WHERE  1=1
									AND   ( (DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
										OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
											)
									) FNL
							ON  SMO.DIVISION_ID = FNL.DIVISION_ID
							AND SMO.ITEM_ID     = FNL.ITEM_ID
				WHERE 1=1
				AND CONCAT(SMO.PLANT_SITE_ID, SMO.ITEM_ID) IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
																FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
																WHERE  PLAN_ID = @V_PLAN_ID
																)
			) B;

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
                        , MIN(CONVERT(NUMERIC(20,10), CS.SIPM_MIN_QYT))  AS LOWER_QTY
                        , MAX(CONVERT(NUMERIC(20,10), CS.SIPM_MAX_QTY))  AS UPPER_QTY
                FROM    SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY CS WITH(NOLOCK)
                    LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                        ON  CS.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                        AND PG.VALID_YN = 'Y'
                WHERE   1=1
                AND     CS.VALID_YN          = 'Y'
                AND     CS.DIVISION_ID       = @V_DIVISION_ID
                AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
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
            INNER JOIN MODEL_GROUP GRP
                ON  GRP.DIVISION    = CS.DIVISION_ID
                AND GRP.PLAN_GROUP  = PG.OPMZ_PLAN_GR_NAME
                AND GRP.MODEL_GROUP = CS.MDL_GR_NM
        WHERE   1=1
        AND     CS.VALID_YN          = 'Y'
        AND     CS.DIVISION_ID       = @V_DIVISION_ID
        AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
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
              ,NULL                                                      AS GROUP_ALLOCATION_CONTROL_CODE
              ,NULL                                                      AS ITEM_ALLOCATION_CONTROL_CODE
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
            -- Add Line For 자사 ASSY
            ------------------------------------------------------------------------
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
                    ON  ILA.DIVISION_ID = ML.DIVISION_ID
                    AND ILA.COMPANY_ID  = ML.COMPANY_ID
                    AND ILA.SITE_ID     = ML.SITE_ID
                    AND ILA.PLANT_ID    = ML.PLANT_ID
                    AND ILA.ITEM_ID     = ML.ITEM_ID
                    AND ILA.MONTH  BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
                INNER JOIN  #TACT_TIME TT WITH(NOLOCK)  
                    ON  ILA.DIVISION_ID = TT.DIVISION_ID
                    --AND ILA.COMPANY_ID  = TT.COMPANY_ID
                    --AND ILA.SITE_ID     = TT.SITE_ID
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
                    AND LM.ACTIVE_FLAG   = 'Y'
            WHERE   1=1
            GROUP BY ML.SCM_SITE_ID,ILA.LINE_ID, TT.STAGE
			UNION ALL
            ------------------------------------------------------------------------
            -- Add Line For 외주
			------------------------------------------------------------------------
			SELECT	 ML.SCM_SITE_ID   AS SITE
					,ILA.LINE_ID      AS RESOURCE_NAME
					,TT.STAGE         AS STAGE
					,NULL             AS ITEM_ID
					,ILA.LINE_ID      AS LINE_ID
					,'LINE'           AS RESOURCE_TYPE
			FROM SCP_MST_TACT_TIME_OSP ILA WITH(NOLOCK) 
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
					ON  ILA.DIVISION_ID   = ML.DIVISION_ID
					AND ILA.PLANT_SITE_ID = ML.SCM_SITE_ID
					AND ILA.ITEM_ID       = ML.ITEM_ID
				INNER JOIN  #TACT_TIME TT WITH(NOLOCK)  
					ON  ILA.DIVISION_ID   = TT.DIVISION_ID
					AND ILA.PLANT_SITE_ID = TT.SCM_SITE_ID
					AND ILA.ITEM_ID       = TT.ITEM_ID
				INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
					ON  ILA.DIVISION_ID    = MS2.DIVISION_ID
					AND  ILA.PLANT_SITE_ID = MS2.SCM_SITE_ID
			WHERE   1=1
			AND     ILA.VALID_YN = 'Y'
			AND     CONCAT (MS2.PLANT_ID, ILA.LINE_ID) IN (SELECT  CONCAT (T.PLANT_ID, T.LINE_ID) 
															FROM    SCP_OPMZ_PLAN_GR_LINE_M T WITH(NOLOCK)
																	INNER JOIN SCP_OPMZ_PLAN_GR_M GR WITH(NOLOCK)
																		ON  T.OPMZ_PLAN_GR_ID  = GR.OPMZ_PLAN_GR_ID
															WHERE   GR.OPMZ_PLAN_GR_NAME    = @V_GROUP_ID
															AND     T.VALID_YN              = 'Y' )
			GROUP BY ML.SCM_SITE_ID,ILA.LINE_ID, TT.STAGE
            ) AS A
		------------------------------------------------------------------------
        UNION ALL
        ------------------------------------------------------------------------
        -- APPLY TO TOOL CONSTRAINT AND DATA INSERT
        ------------------------------------------------------------------------   
		-- PACK Plant Site 정보 등록 시 PAXK/MDLE 구분 방법 정의하여 수정 필요함
        SELECT   @V_PLAN_ID						       AS PLAN_ID
				,LV.SEGMENT3+'::'+LV.SEGMENT5	       AS RESOURCE_ID
				,LV.SEGMENT5					       AS RESOURCE_NAME
				,LV.SEGMENT3					       AS SITE_ID
				,TT.STAGE						       AS STAGE
				,'LINE'							       AS RESOURCE_TYPE
				,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(PF.FROZEN_END_DATE)),112)+':000000' AS FROZENCARRYOVERDATE          
				,LV.SEGMENT3+'::'+LV.SEGMENT5		   AS FROZENCARRYOVERSETUPGROUPNAME
				,TT.STAGE       	                   AS FROZENCARRYOVERSETUPITEMNAME 
               ,'LINECHANGE'                           AS GROUP_SETUP_CONTROL_CODE
               ,'LINECHANGE'                           AS ITEM_SETUP_CONTROL_CODE
				,NULL							       AS GROUP_ALLOCATION_CONTROL_CODE
				,NULL							       AS ITEM_ALLOCATION_CONTROL_CODE
				,'LINE'					               AS EVERY_UPPER_CONTROL_CODE
				,'LINE'					               AS EVERY_LOWER_CONTROL_CODE
				,NULL							       AS HORIZON_UPPER_CONTROL_CODE
				,NULL							       AS HORIZON_LOWER_CONTROL_CODE
				,LV.SEGMENT3					       AS ATTRIBUTE1
				,NULL							       AS ATTRIBUTE2
				,TT.STAGE						       AS ATTRIBUTE3
				,LV.SEGMENT5					       AS ATTRIBUTE15
		FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
				LEFT OUTER JOIN ( SELECT DISTINCT SCM_SITE_ID, LINE_ID, STAGE 
								  FROM #TACT_TIME ) TT
					ON   LV.SEGMENT3 = SCM_SITE_ID
					AND  LV.SEGMENT4 = LINE_ID
                LEFT OUTER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN PF 
                    ON  1=1
                    AND PF.FROZEN_TYPE = 'PROD'
                    AND PF.PLAN_ID = @V_PLAN_ID
                    AND TT.STAGE = PF.STAGE
		WHERE   LV.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_LINE_PERSONNEL'
		AND     LV.SEGMENT2    = @V_DIVISION_ID
		AND     LV.VALID_YN    = 'Y'
		AND     LV.ATTRIBUTE1  = 'A'
		AND     LV.ATTRIBUTE5  = @V_GROUP_ID
		GROUP BY LV.SEGMENT3, LV.SEGMENT5, TT.STAGE
        ------------------------------------------------------------------------
        -- APPLY TO CAPA CONSTRAINT 
        -- 2025.05.12 Philsu Park: GROUP_ID 제약 추가.
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
            AND     LU.ATTRIBUTE1   = @V_GROUP_ID
            GROUP BY SEGMENT3, SEGMENT4, SEGMENT5, SEGMENT4*/
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
               ,NULL                            AS EVERY_UPPER_CONTROL_CODE
               ,NULL                            AS EVERY_LOWER_CONTROL_CODE
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
        -- APPLY TO CONTAINER
        -- 2025.08.29 YSH: 출하 LOT SIZE 적용.
        -- 2025.09.03 Philsu Park: ITEM 단위 LOT SIZE 적용 룩업으로 변경.
        ------------------------------------------------------------------------   
        UNION ALL
        SELECT  @V_PLAN_ID                      AS PLAN_ID
               ,SCM_SITE_ID+'::'+RESOURCE_NAME  AS RESOURCE_ID
               ,RESOURCE_NAME                   AS RESOURCE_NAME
               ,SCM_SITE_ID                     AS SITE_ID
               ,STAGE                           AS STAGE
               ,'MOVE'                          AS RESOURCE_TYPE
               ,NULL                            AS FROZENCARRYOVERDATE
               ,NULL                            AS FROZENCARRYOVERSETUPGROUPNAME
               ,NULL                            AS FROZENCARRYOVERSETUPITEMNAME
               ,NULL                            AS GROUP_SETUP_CONTROL_CODE
               ,NULL                            AS ITEM_SETUP_CONTROL_CODE
               ,NULL                            AS GROUP_ALLOCATION_CONTROL_CODE
               ,NULL                            AS ITEM_ALLOCATION_CONTROL_CODE
               ,'MOVE'                          AS EVERY_UPPER_CONTROL_CODE
               ,NULL                            AS EVERY_LOWER_CONTROL_CODE
               ,NULL                            AS HORIZON_UPPER_CONTROL_CODE
               ,NULL                            AS HORIZON_LOWER_CONTROL_CODE
               ,SCM_SITE_ID                     AS ATTRIBUTE1
               ,NULL                            AS ATTRIBUTE2
               ,STAGE                           AS ATTRIBUTE3
               --,RESOURCE_NAME                   AS ATTRIBUTE4
               ,NULL                            AS ATTRIBUTE15
        FROM(
            SELECT  DISTINCT
                    SEGMENT6    AS SCM_SITE_ID
                   ,SEGMENT5    AS STAGE
                   ,SEGMENT8    AS RESOURCE_NAME
            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            WHERE   LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_SHIP_LOT_SIZE_NEW'
            AND     LU.SEGMENT1     = @V_DIVISION_ID
            AND     LU.SEGMENT2     = @V_GROUP_ID
            AND     LU.VALID_YN     = 'Y'
            AND     LU.SEGMENT3     = 'CON'  -- LOT TYPE이 CON만 대상.
            ) CP

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
        -- Data Insert End
        ------------------------------------------------------------------------
	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_ESS_RUN_MAIN_PROC;
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
