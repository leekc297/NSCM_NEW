


CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_SR_INPUT_ROUTING_RESOURCE]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
    --,@V_SCP_PLAN_DATE       NVARCHAR(8)
    --,@V_SCP_PLAN_TYPE       NVARCHAR(8)
    --,@V_SCP_PLAN_SEQ        NVARCHAR(8)
AS 
/*----------------------------------------------------------------------------------------------
* Date          In Charge       Description
*----------------------------------------------------------------------------------------------
* 2026.03.16    jongykim2       SHIP_REQ
*                - plan_group : SHIP_REQ
*                - 기본 사업부 단위 수행
*                - 생산/출하 제약 제거 : @v_group_id 지정 제약은 별도 수정하지 않음, 그 외 제약은 모두 제거
*                - 생산 : 무한 CAPA (after correct load_per 강제: 0.0000000001)
*
*
*               특이사항
*                - 외주(외주팩커)는 Outsourcing Capacity 기준(No LINE) 라우팅/리소스 정의
*                - 외주(외주팩커)는 PACK 단일 STAGE 로 BOM 구성 (기존 로직)
*                - 생산사이트 간 출하 BOD L/T 0 반영
*                - 소형 수요 원산지 기준 buffer 정보 갱신 -> AFTER CORRECT
*                - Line/Assign 집계시 SUBMDLE은 소형만 반영, 자동차는 기존 모델링에서 커버하여 추가불요. 추가시 엔진수행 결과에서 PACK ~ SUBMDLE 계획 안풀림
*
* 2026.04.08     jongykim2 기존소스 백업후 미사용 코드 제거
*
****************************************************************************************************/
BEGIN
    --2025.02.12 Taehyun Initial Release
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Param for Log
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_SR_INPUT_ROUTING_RESOURCE';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME;
    DECLARE @P_PLAN_NAME         NVARCHAR(8);
    DECLARE @D_PLAN_NAME         DATETIME;
    DECLARE @V_PLAN_START_YYYYMM   NVARCHAR(6);
    DECLARE @V_PLAN_END_YYYYMM     NVARCHAR(6);
    --TOOL 제약 반영을 위한 임시테이블
    DECLARE @RR_TEMP TABLE(
     PLAN_ID             NVARCHAR(50)
    ,ROUTING_ID          NVARCHAR(200)
    ,OP_SEQ              NUMERIC(20,0)
    ,RESOURCE_CLASS_ID   NVARCHAR(200)
    ,RESOURCE_ID         NVARCHAR(100)
    ,LOAD_PER            NUMERIC(20,10)
    ,PRIORITY            NUMERIC(20,0)
    ,START_DATE          NVARCHAR(20)
    ,END_DATE            NVARCHAR(20)
    ,SETUP_GROUP_ID      NVARCHAR(200)
    ,SETUP_ID            NVARCHAR(200)
    ,GROUP_SETUP_TIME    NVARCHAR(100)
    ,SETUP_TIME          NVARCHAR(100)
    ,CONTAINER_CATEGORY  NVARCHAR(100)
    ,CONTAINER_SIZE      NUMERIC(20,0)
    ,ATTRIBUTE1          NVARCHAR(150)
    ,ATTRIBUTE2          NVARCHAR(150)
    ,ATTRIBUTE3          NVARCHAR(150)
    ,ATTRIBUTE14         NVARCHAR(150)
    ,ATTRIBUTE15         NVARCHAR(150)
    ,STEP                INT
    )
    --SOP EOP 반영을 위한 임시테이블
    DECLARE @SE_TEMP TABLE(
     ITEM_ID  NVARCHAR(100)
    ,LINE_ID  NVARCHAR(100)
    ,SOP_DATE NVARCHAR(8)
    ,EOP_DATE NVARCHAR(8)
    ,SOP_MM   NVARCHAR(6)
    ,EOP_MM   NVARCHAR(6)
    )

    ------------------------------------------------------------------------ 
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
        -- SET Param
        ------------------------------------------------------------------------
        SELECT @P_PLAN_NAME = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
        SELECT @D_PLAN_NAME = CONVERT(DATETIME, @P_PLAN_NAME) ;
        
        SELECT @V_PLAN_START_YYYYMM   = CONVERT(NVARCHAR(6),PLAN_START_DATE,112)
              ,@V_PLAN_END_YYYYMM     = CONVERT(NVARCHAR(6),PLAN_END_DATE,112)
        FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        WHERE  PLAN_ID = @P_PLAN_ID

        ------------------------------------------------------------------------
        --BASIC DATA INSERT 
        ------------------------------------------------------------------------		
		IF OBJECT_ID('TEMPDB..#TACT_TIME') IS NOT NULL
		BEGIN 
			DROP TABLE  #TACT_TIME;
		END;

        /* -- 2026-03-10, 사업부 통합적용에 따른 블럭
		SELECT DIVISION_ID, PLANT_ID, ITEM_ID, LINE_ID, MONTH, TACT_TIME, OPERATION_ID, STAGE, SCM_SITE_ID
		INTO #TACT_TIME
		FROM (  -- 소형 외 : FP 정보
				SELECT A.DIVISION_ID AS DIVISION_ID
					  ,A.PLANT_ID    AS PLANT_ID
					  ,A.ITEM_ID     AS ITEM_ID
					  ,A.LINE_ID     AS LINE_ID
					  ,A.MONTH       AS MONTH
					  ,A.TACT_TIME   AS TACT_TIME
					  ,A.OPERATION_ID   AS OPERATION_ID
					  ,CASE WHEN A.OPERATION_ID IN ('A3000', 'A8210', 'A9000') THEN 'ASSY'
					        WHEN A.OPERATION_ID IN ('P5500') THEN 'MDLE'
					        WHEN A.OPERATION_ID IN ('P9500') THEN 'PACK'
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
	                          , 86400 / (CP.CAPA * (ISNULL(CP.PRDN_OPER_RT, 100) / 100)) AS TACT_TIME
                        FROM	SCP_OPMZ_DDLY_CAPA CP WITH(NOLOCK) -- 소형 데이터 미존재
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
                        AND		CP.DIVISION_ID = @V_DIVISION_ID
                        AND		CP.CAPA > 0
                        AND		(CP.PRDN_OPER_RT > 0 OR CP.PRDN_OPER_RT IS NULL)
				       ) A
				WHERE  1=1
				AND    A.DIVISION_ID <> '40' -- 소형 제외 
				AND    A.DIVISION_ID  = @V_DIVISION_ID
				AND    A.OPERATION_ID IN ('A3000', 'A8210', 'A9000', 'P5500', 'P9500')
				AND    A.MONTH BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
				AND (A.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
								  FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
								  WHERE   PLAN_ID =@V_PLAN_ID
								  AND     RESOURCE_TYPE = 'LINE')
					 OR A.LINE_ID IS NULL)
				AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
				  IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
					  FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
					  WHERE  PLAN_ID = @V_PLAN_ID
					 )

				-- 소형 : SCP CAPA(Mobility) 정보
                -- 2025.08.18 Philsu Park: 소형 PG별 Line Item Setup 정보 제약추가
				UNION
				SELECT A.DIVISION_ID AS DIVISION_ID
					  ,A.PLANT_ID    AS PLANT_ID
					  ,A.ITEM_ID     AS ITEM_ID
					  ,A.LINE_ID     AS LINE_ID
					  ,A.YYYYMM      AS MONTH
					  ,ROUND((60 * 60 * 24)/a.value, 6, 1)   AS TACT_TIME
					  ,A.OPERATION_ID   AS OPERATION_ID
					  ,CASE WHEN A.OPERATION_ID IN ('A3000', 'A8210', 'A9000') THEN 'ASSY'
					        WHEN A.OPERATION_ID IN ('P5500') THEN 'MDLE'
					        WHEN A.OPERATION_ID IN ('P9500') THEN 'PACK'
					   END AS STAGE
					  ,CASE WHEN A.OPERATION_ID IN ('A3000', 'A8210', 'A9000') THEN PLANT_ID +'-A'
					        WHEN A.OPERATION_ID IN ('P5500') THEN PLANT_ID +'-P'
					        WHEN A.OPERATION_ID IN ('P9500') THEN PLANT_ID +'-P'
					   END AS SCM_SITE_ID
				FROM   SCP_MST_CAPA A WITH (NOLOCK) -- ASSY만 존재
				WHERE  1=1
				AND    A.DIVISION_ID  = '40' -- 소형 전용 
				AND    A.DIVISION_ID  = @V_DIVISION_ID 
				AND    A.OPERATION_ID IN ('A3000', 'A8210', 'A9000', 'P5500', 'P9500')    
				AND    A.YYYYMM        BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM 
				AND    A.VALUE         > 0   
				AND (A.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
								  FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
								  WHERE   PLAN_ID =@V_PLAN_ID
								  AND     RESOURCE_TYPE = 'LINE')
					 OR A.LINE_ID IS NULL)
				AND CONCAT(CONCAT(A.PLANT_ID,'-'+SUBSTRING(A.OPERATION_ID, 1, 1)), A.ITEM_ID) 
				  IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
					  FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
					  WHERE  PLAN_ID = @V_PLAN_ID
					 )
                AND     EXISTS (SELECT    T.LINE_ID             AS LINE_ID
                                        , T.OPERATION_ID        AS OPERATION_ID
                                        , T.FACTORY_ID          AS FACTORY_ID
                                        , T.PLANT_ID            AS PLANT_ID
                                        , T.ITEM_ID             AS ITEM_ID
                                FROM    SCP_OPMZ_PLAN_GR_LINE_M T WITH(NOLOCK)
                                INNER JOIN SCP_OPMZ_PLAN_GR_M GR WITH(NOLOCK)
                                    ON  T.OPMZ_PLAN_GR_ID       = GR.OPMZ_PLAN_GR_ID
                                WHERE   1=1
                                and     GR.OPMZ_PLAN_GR_NAME    = @V_GROUP_ID
                                AND     T.VALID_YN              = 'Y'
                                AND     T.PLANT_ID              = A.PLANT_ID
                                AND     T.FACTORY_ID            = A.FACTORY_ID
                                AND     T.LINE_ID               = A.LINE_ID
                                AND     T.ITEM_ID               = IIF(T.ITEM_ID = '-', T.ITEM_ID, A.ITEM_ID)
                                )
			) B;*/
        -- =======================================================
        -- 2026-03-10, 사업부 통합적용
        -- ● 2026-03-31 소형 사업부 SUBMDLE P5000 추가
        -- =======================================================
        DECLARE @TACT_TIME NUMERIC(18,10) = 0.0000000001;
        WITH RR AS (
            SELECT ML.DIVISION_ID
                  ,ML.PLANT_ID
                  ,ML.ITEM_ID
                  ,ILA.LINE_ID      AS LINE_ID
                  ,ILA.MONTH
                  ,@TACT_TIME       AS TACT_TIME
                  ,ILA.OPERATION_ID
                  ,CASE WHEN ILA.OPERATION_ID IN ('A3000', 'A8210', 'A9000') THEN 'ASSY'
                        WHEN ILA.OPERATION_ID IN ('P5000') THEN 'SUBMDLE' -- 2026-03-31 소형 사업부 SUBMDLE P5000 추가
                        WHEN ILA.OPERATION_ID IN ('P5500') THEN 'MDLE'
                        WHEN ILA.OPERATION_ID IN ('P9500') THEN 'PACK'
                   END AS STAGE
                  ,ML.SCM_SITE_ID
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
                    ON  ILA.DIVISION_ID  = ML.DIVISION_ID
                    AND ILA.COMPANY_ID   = ML.COMPANY_ID
                    AND ILA.SITE_ID      = ML.SITE_ID
                    AND ILA.PLANT_ID     = ML.PLANT_ID
                    AND ILA.ITEM_ID      = ML.ITEM_ID
                INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)
                    ON  ILA.DIVISION_ID  = LM.DIVISION_ID
                    AND ILA.COMPANY_ID   = LM.COMPANY_ID
                    AND ILA.SITE_ID      = LM.SITE_ID
                    AND ILA.PLANT_ID     = LM.PLANT_ID
                    AND ILA.LINE_ID      = LM.LINE_ID
                    AND ILA.OPERATION_ID = LM.OPERATION_ID
                    AND LM.ACTIVE_FLAG   = 'Y'
            WHERE   1=1
            AND ILA.DIVISION_ID = @V_DIVISION_ID
            AND ILA.MONTH  BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
            AND ILA.OPERATION_ID IN ('A3000', 'A8210', 'A9000', 'P5500', 'P9500', CASE WHEN @V_DIVISION_ID = '40' THEN 'P5000' ELSE '' END) -- 2026-03-31 소형 사업부 SUBMDLE P5000 추가
        )
        SELECT RR.DIVISION_ID
              ,RR.PLANT_ID
              ,RR.ITEM_ID
              ,RR.LINE_ID
              ,RR.MONTH
              ,RR.TACT_TIME
              ,RR.OPERATION_ID
              ,RR.STAGE
              ,RR.SCM_SITE_ID
        INTO   #TACT_TIME            
        FROM   RR
        ;

        INSERT INTO @RR_TEMP(PLAN_ID             
                            ,ROUTING_ID          
                            ,OP_SEQ              
                            ,RESOURCE_CLASS_ID   
                            ,RESOURCE_ID         
                            ,LOAD_PER            
                            ,PRIORITY            
                            ,START_DATE          
                            ,END_DATE            
                            ,SETUP_GROUP_ID      
                            ,SETUP_ID            
                            ,GROUP_SETUP_TIME    
                            ,SETUP_TIME          
                            ,CONTAINER_CATEGORY  
                            ,CONTAINER_SIZE      
                            ,ATTRIBUTE1          
                            ,ATTRIBUTE2          
                            ,ATTRIBUTE3          
                            ,ATTRIBUTE14         
                            ,ATTRIBUTE15    
                            ,STEP
                            )
        SELECT DISTINCT @V_PLAN_ID                                              AS PLAN_ID
                       --,SITE+'::'+ITEM+'::'+STAGE+'::'+ISNULL(RESOURCE_NAME,'-')+'::'+ISNULL(MONTH,'-') AS ROUTING_ID
                       ,SITE+'::'+ITEM+'::'+STAGE+'::'+ISNULL(RESOURCE_NAME,'-')+'::'+ISNULL(START_DATE,'-') AS ROUTING_ID -- routing 기준으로 맞춤
                       ,0                                                       AS OP_SEQ
                       ,RESOURCE_CLASS_ID                                       AS RESOURCE_CLASS_ID
                       ,SITE+'::'+ISNULL(RESOURCE_NAME,'-')                     AS RESOURCE_ID
                       ,LOAD_PER                                                AS LOAD_PER
                       ,PRIORITY                                                AS PRIORITY
                       ,START_DATE                                              AS START_DATE
                       ,END_DATE                                                AS END_DATE
                       ,NULL                                                    AS SETUP_GROUP_ID
                       ,NULL                                                    AS SETUP_ID
                       ,NULL                                                    AS GROUP_SETUP_TIME
                       ,NULL                                                    AS SETUP_TIME
                       ,NULL                                                    AS CONTAINER_CATEGORY
                       ,NULL                                                    AS CONTAINER_SIZE
                       ,SITE                                                    AS ATTRIBUTE1
                       ,ITEM                                                    AS ATTRIBUTE2
                       ,STAGE                                                   AS ATTRIBUTE3
                       ,MONTH                                                   AS ATTRIBUTE14
                       ,LINE_ID                                                 AS ATTRIBUTE15
                       ,1                                                       AS STEP
        FROM(

            /**********************
            1) P_PLANT 
            ***********************/
            SELECT A.PLANT_SITE_ID AS SITE
                  ,A.ITEM_ID       AS ITEM
                  ,CASE WHEN B.OPERATION_GROUP = 'P' THEN 'PACK' -- MDLE 구분 필요 ???
				        WHEN B.OPERATION_GROUP = 'A' THEN 'CHAR' -- STAGE 확인 ???
				   END AS STAGE
                  ,CASE WHEN B.OPERATION_GROUP = 'P' THEN 'P_PLANT' -- MDLE 구분 필요 ???
				        WHEN B.OPERATION_GROUP = 'A' THEN 'A_PLANT' -- STAGE 확인 ???
				   END AS RESOURCE_CLASS_ID
                  --,'PACK'        AS STAGE
                  --,'P_PLANT'     AS RESOURCE_CLASS_ID
                  ,NULL      AS RESOURCE_NAME
                  ,CM.BASIS_YYYYMM   AS MONTH
                  ,CASE WHEN @V_PLAN_START_YYYYMMDD > CM.START_DATE THEN @V_PLAN_START_YYYYMMDD ELSE CM.START_DATE END AS START_DATE
                  ,CM.END_DATE
                  ,1         AS LOAD_PER
                  ,1         AS PRIORITY
                  ,NULL      AS LINE_ID
            FROM   [SCP_MST_OUTSOURCING_CAPA] A WITH(NOLOCK)
               CROSS APPLY( SELECT BASIS_YYYYMM, MIN(BASIS_YYYYMMDD) AS START_DATE, MAX(BASIS_YYYYMMDD) AS END_DATE
                            FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
                            WHERE  BASIS_YYYYMM BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
                            GROUP BY BASIS_YYYYMM ) CM
			INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
			ON  A.DIVISION_ID   = B.DIVISION_ID
			AND A.PLANT_SITE_ID = B.SCM_SITE_ID
			AND B.VALID_YN      = 'Y'
			AND B.OPERATION_GROUP IN ('A', 'P')

            WHERE 1=1
            AND   A.DIVISION_ID = @V_DIVISION_ID
            --AND   @V_DIVISION_ID <> '40' -- 2026-03-10, 소형 특화제거 -- 소형 Cell Demand : 소형은 Pack 제외
            AND   A.VALID_YN = 'Y'
            /************************* 
            소형 파일럿대상 18650 필터링 
            *************************/
            /* -- RESOURCE 기준 적용 후 테스트
            AND CONCAT(A.PLANT_SITE_ID, '_', A.ITEM_ID) IN (SELECT DISTINCT CONCAT (SCM_SITE_ID, '_',ITEM_ID )
                                                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                        WHERE  PLAN_ID = @V_PLAN_ID
                                                       )*/
	        -- 생산사이트의 모델을 결정하는 아래 테이블 기준을 적용
            AND CONCAT(A.PLANT_SITE_ID, '_', A.ITEM_ID) IN (SELECT DISTINCT CONCAT(PR.PLANT_SITE_ID, '_', PR.ITEM_ID)
	                                                        FROM   SCM_MST_SITE_ITEM_PRIORITY PR WITH(NOLOCK)
                                                            WHERE PR.ITEM_ID IN (SELECT DISTINCT ITEM_ID 
                                                                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                                 WHERE   PLAN_ID = @V_PLAN_ID
                                                                                )
                                                           )
            GROUP BY A.PLANT_SITE_ID, A.ITEM_ID, B.OPERATION_GROUP, CM.BASIS_YYYYMM, CM.START_DATE, CM.END_DATE
            /**********************
            2) P_MODEL
            ***********************/
            UNION ALL
            SELECT A.PLANT_SITE_ID AS SITE
                  ,A.ITEM_ID   AS ITEM
                  ,CASE WHEN B.OPERATION_GROUP = 'P' THEN 'PACK' -- MDLE 구분 필요 ???
				        WHEN B.OPERATION_GROUP = 'A' THEN 'CHAR' -- STAGE 확인 ???
				   END AS STAGE
                  ,CASE WHEN B.OPERATION_GROUP = 'P' THEN 'P_MODEL' -- MDLE 구분 필요 ???
				        WHEN B.OPERATION_GROUP = 'A' THEN 'A_MODEL' -- STAGE 확인 ???
				   END AS RESOURCE_CLASS_ID
                  --,'PACK'    AS STAGE
                  --,'P_MODEL' AS RESOURCE_CLASS_ID
                  ,A.ITEM_ID AS RESOURCE_NAME
                  ,CM.BASIS_YYYYMM   AS MONTH
                  ,CASE WHEN @V_PLAN_START_YYYYMMDD > CM.START_DATE THEN @V_PLAN_START_YYYYMMDD ELSE CM.START_DATE END AS START_DATE
                  ,CM.END_DATE
                  ,1         AS LOAD_PER
                  ,1         AS PRIORITY
                  ,A.ITEM_ID AS LINE_ID
            FROM  [SCP_MST_OUTSOURCING_CAPA] A WITH(NOLOCK)
               CROSS APPLY( SELECT BASIS_YYYYMM, MIN(BASIS_YYYYMMDD) AS START_DATE, MAX(BASIS_YYYYMMDD) AS END_DATE
                            FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
                            WHERE  BASIS_YYYYMM BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
                            GROUP BY BASIS_YYYYMM ) CM
			INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
			ON  A.DIVISION_ID   = B.DIVISION_ID
			AND A.PLANT_SITE_ID = B.SCM_SITE_ID
			AND B.VALID_YN      = 'Y'
			AND B.OPERATION_GROUP IN ('A', 'P')

            WHERE 1=1
            AND   A.DIVISION_ID = @V_DIVISION_ID
            --AND   @V_DIVISION_ID <> '40' -- 2026-03-10, 소형 특화제거 -- 소형 Cell Demand : 소형은 Pack 제외
            AND   A.VALID_YN = 'Y'
            /************************* 
            소형 파일럿대상 18650 필터링 
            *************************/
            /* -- RESOURCE 기준 적용 후 테스트
            AND CONCAT(A.PLANT_SITE_ID, '_', A.ITEM_ID) IN (SELECT DISTINCT CONCAT (SCM_SITE_ID, '_',ITEM_ID )
                                                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                        WHERE  PLAN_ID = @V_PLAN_ID
                                                       )*/
	        -- 생산사이트의 모델을 결정하는 아래 테이블 기준을 적용
            AND CONCAT(A.PLANT_SITE_ID, '_', A.ITEM_ID) IN (SELECT DISTINCT CONCAT(PR.PLANT_SITE_ID, '_', PR.ITEM_ID)
	                                                        FROM   SCM_MST_SITE_ITEM_PRIORITY PR WITH(NOLOCK)
                                                            WHERE PR.ITEM_ID IN (SELECT DISTINCT ITEM_ID 
                                                                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                                 WHERE   PLAN_ID = @V_PLAN_ID
                                                                                )
                                                           )
            GROUP BY A.PLANT_SITE_ID, A.ITEM_ID, B.OPERATION_GROUP, CM.BASIS_YYYYMM, CM.START_DATE, CM.END_DATE
            /**********************
            3) LINE
            ***********************/
            UNION ALL
            SELECT A.SCM_SITE_ID  AS SITE
                  ,A.ITEM_ID      AS ITEM
                  ,A.STAGE        AS STAGE
                  --,'A_LINE' AS RESOURCE_CLASS_ID
				  ,'LINE'       AS RESOURCE_CLASS_ID
                  ,A.LINE_ID    AS RESOURCE_NAME
                  ,A.MONTH      AS MONTH
                  ,CASE WHEN @V_PLAN_START_YYYYMMDD >= A.MONTH+'01' AND @V_PLAN_START_YYYYMMDD >= ISNULL(C.SOP_DATE,'11111111') THEN @V_PLAN_START_YYYYMMDD
                        WHEN A.MONTH+'01'   >= @V_PLAN_START_YYYYMMDD AND A.MONTH+'01' >= ISNULL(C.SOP_DATE,'11111111') THEN A.MONTH+'01'
                        ELSE ISNULL(C.SOP_DATE,'11111111')
                   END AS START_DATE
                  ,CASE WHEN @V_PLAN_END_YYYYMMDD <= CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,A.MONTH+'01')),112) AND @V_PLAN_END_YYYYMMDD <= ISNULL(C.EOP_DATE,'29991231') THEN @V_PLAN_END_YYYYMMDD
                        WHEN CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,A.MONTH+'01')),112) <= @V_PLAN_END_YYYYMMDD 
						 AND CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,A.MONTH+'01')),112) <= ISNULL(C.EOP_DATE,'29991231') 
                        	THEN CONVERT(NVARCHAR(8),DATEADD(MONTH,1,A.MONTH+'01'),112)
                        ELSE CONVERT(NVARCHAR(8),DATEADD(DAY,1, CONVERT(DATETIME, ISNULL(C.EOP_DATE,'29991231')) ),112)
                   END AS END_DATE
                  ,A.TACT_TIME  AS LOAD_PER
                  --,B.PRIORITY   AS PRIORITY -- 2026-03-10 블럭
                  ,ISNULL(B.PRIORITY,1)   AS PRIORITY -- 2026-03-10 추가
                  ,A.LINE_ID    AS LINE_ID
            FROM #TACT_TIME A WITH(NOLOCK)
                LEFT JOIN SCM_MST_ITEM_LINE_ASSIGN_SN B
                ON  A.PLANT_ID     = B.PLANT_ID
                AND A.LINE_ID      = B.LINE_ID
                AND A.OPERATION_ID = B.OPERATION_ID
                AND A.MONTH        = B.MONTH
                AND A.ITEM_ID      = B.ITEM_ID
				AND B.DIVISION_ID  = @V_DIVISION_ID
                LEFT OUTER JOIN @SE_TEMP C
                ON  A.ITEM_ID = C.ITEM_ID
                AND A.LINE_ID = C.LINE_ID -- 신규
            WHERE 1=1
            AND A.DIVISION_ID = @V_DIVISION_ID
            --AND B.PRIORITY <> 'NULL' -- 2026-03-10, 외주포함
            AND (    (C.SOP_MM IS NULL OR (A.ITEM_ID = C.ITEM_ID AND A.MONTH >= C.SOP_MM))
                 AND (C.EOP_MM IS NULL OR (A.ITEM_ID = C.ITEM_ID AND A.MONTH <= C.EOP_MM))
                 OR C.ITEM_ID IS NULL
                )
            GROUP BY A.PLANT_ID, A.ITEM_ID, A.LINE_ID, A.MONTH, A.TACT_TIME, B.PRIORITY,C.SOP_DATE,C.EOP_DATE, A.STAGE, A.SCM_SITE_ID
            ) A

        ------------------------------------------------------------------------
        -- DATA INSERT
        ------------------------------------------------------------------------   
        INSERT INTO SCP_OPT_ENG_ROUTING_RESOURCE_SN(PLAN_ID
                                        ,ROUTING_ID
                                        ,OP_SEQ
                                        ,RESOURCE_CLASS_ID
                                        ,RESOURCE_ID
                                        ,LOAD_PER
                                        ,PRIORITY
                                        ,START_DATE
                                        ,END_DATE
                                        ,SETUP_GROUP_ID
                                        ,SETUP_ID
                                        ,GROUP_SETUP_TIME
                                        ,SETUP_TIME
                                        ,CONTAINER_CATEGORY
                                        ,CONTAINER_SIZE
                                        ,ATTRIBUTE1
                                        ,ATTRIBUTE2
                                        ,ATTRIBUTE3
                                        ,ATTRIBUTE14
                                        ,ATTRIBUTE15
                                        )
            SELECT RR.PLAN_ID
                  ,RR.ROUTING_ID
                  ,RR.OP_SEQ
                  ,RR.RESOURCE_CLASS_ID
                  ,RR.RESOURCE_ID
                  ,RR.LOAD_PER
                  ,RR.PRIORITY
                  ,RR.START_DATE
                  ,RR.END_DATE
                  ,RR.SETUP_GROUP_ID
                  ,RR.SETUP_ID
                  ,RR.GROUP_SETUP_TIME
                  ,RR.SETUP_TIME
                  ,RR.CONTAINER_CATEGORY
                  ,RR.CONTAINER_SIZE
                  ,RR.ATTRIBUTE1
                  ,RR.ATTRIBUTE2
                  ,RR.ATTRIBUTE3
                  ,RR.ATTRIBUTE14
                  ,RR.ATTRIBUTE15
            FROM   @RR_TEMP RR
            ;

        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------

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
