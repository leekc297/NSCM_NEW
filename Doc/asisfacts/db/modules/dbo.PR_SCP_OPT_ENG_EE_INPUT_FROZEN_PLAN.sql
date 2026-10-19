



CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_INPUT_FROZEN_PLAN]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
    ,@T_SCP_PLAN            optTableType_SCP_PLAN READONLY
AS 
BEGIN
    --2025.02.14 Taehyun Initial Release
    -- 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영.
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_INPUT_FROZEN_PLAN';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME;
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_PROD_FROZEN         INT;
    DECLARE @V_PROD_FROZEN_END     NVARCHAR(8); -- Prod Frozen 다음 일자 정보

    DECLARE @V_SINGLE_PLAN_TYPE     NVARCHAR(1);
    DECLARE @V_PLAN_GROUP_ORG       NVARCHAR(20);

	-- 임시 : 아래 변수 수정 처리 필요
    DECLARE @V_SYS_DIVS_CD      NVARCHAR(100)
    DECLARE @V_PROD_FP_FRZ_TYPE NVARCHAR(100)
    DECLARE @V_SCP_PLAN_TYPE    NVARCHAR(200);
    DECLARE @V_SCP_PLAN_DATE    NVARCHAR(200);
    DECLARE @V_SCP_PLAN_SEQ    NVARCHAR(200);
    DECLARE @V_CURRENT_YYYYMMDD NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(CURRENT_TIMESTAMP, 'MON')), 112);

    --THKIM/20250922/LOOKUP 바라보고 SCP OR FP 계획 볼 수 있도록 수정 -> 성재책임님 요청사항
    DECLARE @FROZEN_PLAN_TYPE NVARCHAR(100) 
    
    SELECT  @FROZEN_PLAN_TYPE = ATTRIBUTE1
    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
    WHERE   LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN'
    AND     VALID_YN    = 'Y'
    AND     SEGMENT1    = @V_DIVISION_ID
    AND     SEGMENT2    = @V_GROUP_ID
    GROUP BY ATTRIBUTE1

    ------------------------------------------------------------------------ 
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
        -- Data Insert Start
        ------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

		SELECT DIVISION_ID 
		INTO #DIVISION
		FROM SCM_MST_DIVISION WITH(NOLOCK)
		WHERE  VALID_YN = 'Y'
		AND    ATTRIBUTE3 <> 'EE'
		AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) -- 전극 Division 변수
		;
		
	    -- 전극 Plan Type 확인
		--SELECT @V_SCP_PLAN_DATE = A.PLAN_START_YYYYMMDD
		--     , @V_SCP_PLAN_TYPE = A.PLAN_TYPE
		--     , @V_SCP_PLAN_SEQ  = A.PLAN_SEQ
  --      FROM  (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
		--            , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_TYPE_ORDER DESC ) AS PLAN_RANK
  --             FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
		--	   -- 전극 Division 에 해당하는 사업부 확인
  --             WHERE  DIVISION_ID          = @V_DIVISION_ID -- 전극 Division 변수
  --             AND    PLAN_START_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 전주 월요일 YYYYMMDD
  --             AND    PLAN_START_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD,  -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 당주 월요일 YYYYMMDD
  --            ) A   
  --      WHERE PLAN_RANK = 1 

        ------------------------------------------------------------------------
        -- 2025.09.25 김태현 : Frozen Master 정보 활용
        ------------------------------------------------------------------------
        SELECT  @V_SYS_DIVS_CD      = SYS_DIVS_CD
               ,@V_SCP_PLAN_TYPE    = PLAN_TYPE
               ,@V_SCP_PLAN_DATE    = PLAN_YYYYMMDD
               ,@V_SCP_PLAN_SEQ     = PLAN_SEQ
               ,@V_PROD_FP_FRZ_TYPE = PLAN_TYPE
        FROM    (SELECT  TOP 1 SYS_DIVS_CD
                              ,PLAN_TYPE
                              ,PLAN_YYYYMMDD
                              ,PLAN_SEQ
                 FROM    SCP_OPT_ENG_FROZEN_MASTER_SN WITH(NOLOCK)
                 WHERE   1=1
                 AND     PLAN_ID     = @V_PLAN_ID
                 AND     DIVISION_ID = @V_DIVISION_ID
                 AND     FROZEN_TYPE = 'PROD'
                ) A

		-- PR_SCP_OPT_ENG_EE_INPUT_ITEM_BOM_ROUTING 에서 동일 정보 사용
  --      SELECT  @V_PROD_FROZEN = SEGMENT4
		--FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
		--WHERE   LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN'
		--AND     VALID_YN    = 'Y'
		--AND     SEGMENT1    = @V_DIVISION_ID -- 전극 Division 변수
		--AND     SEGMENT2    = @V_GROUP_ID
  --      --AND     SEGMENT3    = 'PR' --임시
  --      AND     SEGMENT3    = @V_SCP_PLAN_TYPE -- 전극 Division 기준
  --      ;

		--SET @V_PROD_FROZEN_END = CONVERT(CHAR(8), DATEADD(DD, ISNULL(@V_PROD_FROZEN, 0), @V_SCP_PLAN_DATE ), 112); -- Prod Frozen 다음 일자 정보

        --------------------------------------------------------------------------------------------------
        -- START
        -- 2025.05.13 Philsu Park: FP Plan으로 Frozen 반영.
        -- 2025.05.14 Philsu Park:  Insert 구문 두개로 갈라서 분기처리.
        --                          Plan Start YMD = 당주인 경우 FP Release 된 최신계획을 사용
        --                          Plan Start YMD = 당주가 아닌 경우 해당주차의 SCP Prod Plan Amend를 사용
        -- 2025.08.14 Philsu Park:  소형 전극의 경우, FP_PRODUCTION_TYPE 제약조건 추가('MASS', 'C-MASS', 'M-SAMPLE')
        --------------------------------------------------------------------------------------------------
        --IF @V_CURRENT_YYYYMMDD = @V_SCP_PLAN_DATE AND 1=2 -- 20250916/THKIM/성재 책임님 계획 짜시는 동안 임시로 SCP 계획 보도록 수정
        --IF ISNULL(@FROZEN_PLAN_TYPE,'') != 'SCP' -- THKIM/20250922/LOOKUP 바라보고 "SCP"라고 입력이 안되어있으면 FP 계획 보도록 수정 -> 성재책임님 요청사항
        IF @V_SYS_DIVS_CD = 'FP' AND @V_PROD_FP_FRZ_TYPE = 'Latest FP Plan'
            BEGIN 

                IF OBJECT_ID('TEMPDB..#FP_RELEASE_PLAN') IS NOT NULL
                BEGIN 
                    DROP TABLE  #FP_RELEASE_PLAN;
                END;

                ------------------------------------------------------------------------
                -- 2025.08.14 Philsu Park: 속도 이슈로 TEMP에 담아서 사용.
                -- 2025.08.22 Philsu Park: Demand 제외구간 제약 적용.
                -- 2025.09.17 Philsu Park: FP Release Plan을 View가 아닌 C 로 변경.(신성재 책임님 요청):: _C도 최신계획이 아니라서 Rollback.
                ------------------------------------------------------------------------
                WITH DEMAND_EXCEPTION AS
                    (
                        -- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
                        -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
                        --SELECT    DISTINCT
                        --        LV.SEGMENT2   AS DIVISION_ID
                        --        , LV.SEGMENT3   AS SCM_SITE_ID
                        --        -- , LV.SEGMENT4   AS ITEM_ID
                        --        , EBM.CHILD_ITEM_ID AS ITEM_ID
                        --        , LV.SEGMENT5   AS GROUP_ID
                        --        , CASE WHEN ISNULL(LV.ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                        --                ELSE LV.ATTRIBUTE2
                        --        END AS START_DATE  -- PLAN 제외 시작일자
                        --        , CASE WHEN ISNULL(LV.ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                        --                ELSE LV.ATTRIBUTE3
                        --        END AS END_DATE  -- PLAN 제외 끝일자
                        --FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                        --INNER JOIN SCP_OPT_ENG_BOM_ELEC_SN EBM WITH(NOLOCK)
                        --    ON  EBM.PLAN_ID         = @V_PLAN_ID
                        --    AND EBM.PARENT_ITEM_ID  = LV.SEGMENT4
                        --WHERE   LV.LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                        --AND     LV.VALID_YN    = 'Y'
                        --AND     LV.SEGMENT2    = @V_DIVISION_ID
                        --AND     LV.SEGMENT5    = @V_GROUP_ID
                        --AND     LV.ATTRIBUTE1  = 'ASSY' -- CELL PLAN 제외
                        ---- 전극의 경우 공용 전극 ITEM이 있으므로 DEMAND가 있는 경우에는 제외하지 않음/20251013/THKIM
                        --AND     EBM.CHILD_ITEM_ID NOT IN (
                        --                                  SELECT  DISTINCT ATTRIBUTE2
                        --                                  FROM    SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                        --                                  WHERE   DM.PLAN_ID = @V_PLAN_ID
                        --                                 )
                        ---- ON  A.SCM_SITE_ID = DE.SCM_SITE_ID
                        ---- AND A.ITEM_ID     = DE.ITEM_ID

                        -- 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환
                        SELECT  DISTINCT
                                D.DIVISION_ID           AS DIVISION_ID
                              , D.SCM_SITE_ID           AS SCM_SITE_ID
                              , EBM.CHILD_ITEM_ID       AS ITEM_ID
                              , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                              , CASE
                                    WHEN ISNULL(D.FROM_YYYYMMDD, '') = '' THEN @V_PLAN_END_YYYYMMDD
                                    ELSE D.FROM_YYYYMMDD
                                END                     AS START_DATE
                              , CASE
                                    WHEN ISNULL(D.TO_YYYYMMDD, '') = '' THEN @V_PLAN_END_YYYYMMDD
                                    ELSE D.TO_YYYYMMDD
                                END                     AS END_DATE
                        FROM    SCP_OPMZ_DEMAND_EXCEPTION D WITH(NOLOCK)
                            INNER JOIN SCP_OPT_ENG_BOM_ELEC_SN EBM WITH(NOLOCK)
                                ON  EBM.PLAN_ID         = @V_PLAN_ID
                                AND EBM.PARENT_ITEM_ID  = D.ITEM_ID
                            LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                                ON  D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                AND PG.VALID_YN = 'Y'
                            INNER JOIN  (
                                        SELECT  DISTINCT ITEM_ID
                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE   PLAN_ID = @V_PLAN_ID
                                        ) MDL
                                ON  D.ITEM_ID = MDL.ITEM_ID
                        AND     D.VALID_YN = 'Y'
                        AND     D.DIVISION_ID = @V_DIVISION_ID
                        AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                        --AND     D.STAGE = 'TARGETBIZ'
                        -- 전극의 경우 공용 전극 ITEM이 있으므로 DEMAND가 있는 경우에는 제외하지 않음/20251013/THKIM
                        AND     EBM.CHILD_ITEM_ID NOT IN (
                                                            SELECT  DISTINCT ATTRIBUTE2
                                                            FROM    SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                                                            WHERE   DM.PLAN_ID = @V_PLAN_ID
                                                            )
                    )
                /* SELECT    FP.DIVISION_ID
                        , FP.SCM_SITE_ID
                        , ISNULL(FI.PACKER_PLAN_ITEM_ID, FP.ITEM_ID) AS ITEM_ID
                        , FP.LINE_ID
                        , CONVERT(NVARCHAR, FP.PLAN_DATE, 112) AS PLAN_DATE
                        , FP.PLAN_QTY
                        , FP.PRODUCTION_TYPE
                INTO    #FP_RELEASE_PLAN
                FROM   SCM_DNM_FP_RELEASE_PROD_PLAN_C FP WITH(NOLOCK)
                LEFT OUTER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)--2018.06.29
                    ON  FP.DIVISION_ID   = FI.DIVISION_ID
                    AND FP.ITEM_ID       = FI.ITEM_ID
                where  1=1
                AND    FP.YYYYMMDD  = @V_PLAN_START_YYYYMMDD
                AND     FP.PLAN_QTY > 0
                AND     CONVERT(NVARCHAR, FP.PLAN_DATE, 112) >= @V_SCP_PLAN_DATE  -- @V_START_YYYYMMDD
                AND     CONVERT(NVARCHAR, FP.PLAN_DATE, 112)  < @V_PROD_FROZEN_END  -- @V_START_YYYYMMDD
                -- AND    CONVERT(NVARCHAR, PLAN_DATE, 112) = '20250915'
                AND     (FP.DIVISION_ID  = '40' AND FP.PRODUCTION_TYPE IN ('MASS', 'C-MASS', 'M-SAMPLE')
                                                    OR  FP.DIVISION_ID  != '40')
                AND     EXISTS (SELECT 1
                                FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                WHERE   PLAN_ID         = @V_PLAN_ID
                                AND     RESOURCE_TYPE   = 'LINE'
                                AND    ATTRIBUTE15      = FP.LINE_ID
                                )
                AND     EXISTS (SELECT 1
                                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                WHERE  PLAN_ID      = @V_PLAN_ID
                                AND    SCM_SITE_ID = FP.SCM_SITE_ID
                                AND    ITEM_ID     = ISNULL(FI.PACKER_PLAN_ITEM_ID, FP.ITEM_ID)
                                )
                AND NOT EXISTS (SELECT 1
                                FROM   DEMAND_EXCEPTION DE 
                                WHERE  1=1
                                AND   DE.ITEM_ID       = ISNULL(FI.PACKER_PLAN_ITEM_ID, FP.ITEM_ID)
                                AND    CONVERT(NVARCHAR, FP.PLAN_DATE, 112) BETWEEN DE.START_DATE AND DE.END_DATE
                                ) */
                SELECT    R.DIVISION_ID
                        , M.SCM_SITE_ID
                        , ISNULL(FI.PACKER_PLAN_ITEM_ID, R.ITEM_ID) AS ITEM_ID --2018.06.29
                        , R.LINE_ID
                        , CONVERT(NVARCHAR, R.PLAN_DATE, 112)       AS PLAN_DATE
                        , R.PLAN_QTY          -- OUT 수량
                        , R.FP_PRODUCTION_TYPE
                        /* Input 생성 시 미사용 컬럼 주석처리.
                        , r.top_item_id 
                        , r.item_id origin_item_id --2018.06.29
                        , r.company_id
                        , r.division_id
                        , r.site_id
                        , r.fp_production_type  -- 2025.05.13 양산 및 샘플, 테스트 등등.. 나중에 조건 걸어야 될 수도 있음.
                        , r.plant_id
                        , r.factory_id  
                        , r.operation_id
                        , r.location    
                        , r.market
                        , r.electrode_type
                        -- IN 수량
                        , CASE WHEN r.plan_in_qty <= 0 THEN r.plan_qty
                            ELSE r.plan_in_qty
                        END plan_in_qty
                        , r.equipment_id */
                INTO #FP_RELEASE_PLAN
                FROM DBO.SCM_DNM_FP_RELEASE_PLAN_V_SN R WITH(NOLOCK)
                LEFT JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)--2018.06.29
                    ON  R.DIVISION_ID   = FI.DIVISION_ID
                    AND R.ITEM_ID       = FI.ITEM_ID
                OUTER APPLY (
                            SELECT TOP 1 ISNULL(I.SCP_OPERATION_GROUP,'') AS SCP_OPERATION_GROUP
                                FROM DBO.SCM_MST_ITEM_SN              I WITH(NOLOCK)
                            WHERE 1=1
                                AND I.DIVISION_ID          = R.DIVISION_ID
                                AND I.ITEM_ID              = R.ITEM_ID
                            ) AS OG
                OUTER APPLY (
                            SELECT TOP 1 ISNULL(I.SCM_SITE_ID,'') AS SCM_SITE_ID
                                FROM DBO.SCM_MST_SITE             I WITH(NOLOCK)
                            WHERE 1 = 1
                                AND I.PLANT_ID             = R.PLANT_ID
                                AND I.OPERATION_GROUP      = OG.SCP_OPERATION_GROUP
                                AND I.SITE_TYPE            = 'PLANT'
                                AND I.VALID_YN             = 'Y'
                            ) AS M
                INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                    ON  FM.FROZEN_TYPE = 'PROD'
                    AND FM.STAGE = IIF(R.OPERATION_ID = 'E2000','COATING','')
                    AND FM.PLAN_ID = @V_PLAN_ID
                WHERE   1=1
                AND     R.PLAN_QTY > 0
                AND     CONVERT(NVARCHAR, R.PLAN_DATE, 112) >= FROZEN_START_DATE  -- @V_SCP_PLAN_DATE
                AND     CONVERT(NVARCHAR, R.PLAN_DATE, 112)  < FROZEN_END_DATE  -- @V_PROD_FROZEN_END
                AND     EXISTS (SELECT 1
                                FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                WHERE   PLAN_ID         = @V_PLAN_ID
                                AND     RESOURCE_TYPE   = 'LINE'
                                AND    ATTRIBUTE15      = R.LINE_ID
                                )
                AND     EXISTS (SELECT 1
                                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                WHERE  PLAN_ID      = @V_PLAN_ID
                                AND    SCM_SITE_ID = M.SCM_SITE_ID
                                AND    ITEM_ID     = ISNULL(FI.PACKER_PLAN_ITEM_ID, R.ITEM_ID)
                                )
                AND NOT EXISTS (SELECT 1
                                FROM   DEMAND_EXCEPTION DE 
                                WHERE  1=1
                                AND   DE.ITEM_ID       = ISNULL(FI.PACKER_PLAN_ITEM_ID, R.ITEM_ID)
                                AND    CONVERT(NVARCHAR, R.PLAN_DATE, 112) BETWEEN DE.START_DATE AND DE.END_DATE
                                )
                ;

                INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(
                                                        PLAN_ID
                                                    ,FROZEN_ID
                                                    ,ROUTING_BOM_MAPPING_ID
                                                    ,OP_SEQ
                                                    ,RESOURCE_ID
                                                    ,QUANTITY
                                                    ,EFFECTIVE_DATE
                                                    ,ATTRIBUTE1
                                                    ,ATTRIBUTE2
                                                    ,ATTRIBUTE3
                                                    ,ATTRIBUTE13
                                                    ,ATTRIBUTE14
                                                    ,ATTRIBUTE15
                                                    )
                    SELECT  @V_PLAN_ID                                                      AS PLAN_ID
                        ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+LINE_ID+'::'+PLAN_DATE AS FROZEN_ID
                        ,'RB'+B.ROUTING_ID                                               AS ROUTING_BOM_MAPPING_ID
                        ,0                                                               AS OP_SEQ
                        ,SCM_SITE_ID+'::'+LINE_ID                                        AS RESOURCE_ID
                        ,QTY                                                             AS QUANTITY
                        ,PLAN_DATE                                                       AS EFFECTIVE_DATE
                        ,SCM_SITE_ID                                                     AS SITE_ID
                        ,ITEM_ID                                                         AS ITEM_ID    
                        ,STAGE                                                           AS STAGE      
                        ,SOURCE_CHK                                                      AS SOURCE_CHK
                        ,LINE_ID                                                         AS LINE_ID    
                        ,PLAN_MONTH                                                      AS PLAN_MONTH 
                    FROM(
                        SELECT  SCM_SITE_ID       AS SCM_SITE_ID
                            ,ITEM_ID           AS ITEM_ID
                            ,STAGE             AS STAGE
                            ,LINE_ID           AS LINE_ID
                            ,PLAN_DATE         AS PLAN_DATE
                            ,LEFT(PLAN_DATE,6) AS PLAN_MONTH
                            ,SUM(PLAN_IN_QTY)  AS QTY
                            ,SOURCE_CHK            AS SOURCE_CHK
                        FROM(
                                SELECT    V.SCM_SITE_ID AS SCM_SITE_ID
                                        , V.ITEM_ID     AS ITEM_ID
                                        , 'COATING'     AS STAGE
                                        , V.LINE_ID     AS LINE_ID
                                        , V.PLAN_DATE   AS PLAN_DATE
                                        , SUM(V.PLAN_QTY)    AS PLAN_IN_QTY  -- AFTER_CORRECT에서  수율 먹여서 투입수량으로 변경.
                                        , 'FP_RELEASE_PLAN' AS SOURCE_CHK
                                FROM    #FP_RELEASE_PLAN V
                                WHERE   1=1
                                AND     ISNULL(V.FP_PRODUCTION_TYPE, '-') NOT IN ('REWORK', 'M/C')  -- TEST는 포함하고 나머지는 제외.
                                AND     (V.DIVISION_ID  = '40' AND ISNULL(V.FP_PRODUCTION_TYPE, '-') IN ('MASS', 'C-MASS', 'M-SAMPLE')
                                    OR  V.DIVISION_ID  != '40')
                                GROUP BY  V.SCM_SITE_ID
                                        , V.ITEM_ID
                                        , V.LINE_ID
                                        , V.PLAN_DATE
                                ------------------------------------------------------------------------------------------------------
                                UNION ALL
                                ------------------------------------------------------------------------------------------------------
                                -- 2025.05.14 Philsu Park: Lookup Fix값 0 보다 큰 값만 들어가게 제약조건 추가.
                                -- 2025.05.20 Philsu Park: GROUP_ID 조건 추가.(두군데)
                                ------------------------------------------------------------------------------------------------------
                                SELECT	 LVF.SEGMENT5	AS SCM_SITE_ID
                                        ,LVF.ATTRIBUTE2 AS ITEM_ID
                                        ,'COATING' AS STAGE
                                        ,LVF.ATTRIBUTE1 AS LINE_ID
                                        ,LVF.ATTRIBUTE3 AS PLAN_DATE
                                        ,LVF.ATTRIBUTE4 AS PLAN_IN_QTY
                                        ,'LOOKUP_PROD_FIX' AS SOURCE_CHK
                                FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LVF WITH(NOLOCK)
                                        INNER JOIN ( 
                                                    SELECT A.*
                                                    FROM   SCM_MST_SITE A WITH (NOLOCK)

                                                    INNER JOIN #DIVISION D WITH(NOLOCK)
                                                    ON A.DIVISION_ID = D.DIVISION_ID

                                                    WHERE  1=1 -- A.DIVISION_ID = @V_DIVISION_ID 
                                                    AND    A.SITE_TYPE   = 'PLANT'
                                                    AND    A.VALID_YN    = 'Y'	
                                                    AND    A.OPERATION_GROUP = 'E'	
                                                    ) MSE
                                            ON   LVF.SEGMENT5 = MSE.SCM_SITE_ID 
                                        INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                                            ON  FM.FROZEN_TYPE = 'PROD'
                                            AND FM.STAGE = IIF(LVF.SEGMENT4= 'E2000','COATING','')
                                            AND FM.PLAN_ID = @V_PLAN_ID
                                WHERE	LVF.LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
                                AND     LVF.SEGMENT3    = @V_GROUP_ID           -- GROUP_ID 제약조건 추가
                                AND		LVF.ATTRIBUTE3 >= FROZEN_END_DATE -- @V_PROD_FROZEN_END  -- Frozen 구간 이후 FIX 만 적용
                                AND		LVF.ATTRIBUTE3 <  @V_PLAN_END_YYYYMMDD
                                AND     CONVERT(NUMERIC(30, 10), LVF.ATTRIBUTE4) > 0
                                AND     LVF.VALID_YN    = 'Y'
                                AND     LVF.ATTRIBUTE1 IN (SELECT DISTINCT ATTRIBUTE15
                                                            FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                                            WHERE   PLAN_ID = @V_PLAN_ID
                                                            AND     RESOURCE_TYPE = 'LINE'
                                                        )
                                /************************* 
                                대상 프로젝트 ITEM 필터링 
                                *************************/
                                AND CONCAT(LVF.SEGMENT5, LVF.ATTRIBUTE2) 
                                    IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
                                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE  PLAN_ID = @V_PLAN_ID
                                    )
                            ------------------------------------------------------------------------------------------------------
                        ) AA
                        GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, SOURCE_CHK
                    ) A
                    --ROUTING ID가 일 기준으로 변경되면서 ROUTING_RESOURCE로 JOIN 조건 변경/20250702/김태현 선임
                    --LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN B WITH(NOLOCK)
                    --ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                    --AND A.ITEM_ID     = B.ATTRIBUTE2
                    --AND A.STAGE       = B.ATTRIBUTE3
                    --AND A.LINE_ID     = B.ATTRIBUTE14
                    --AND A.PLAN_MONTH  = B.ATTRIBUTE15
                    --AND B.PLAN_ID     = @V_PLAN_ID
                    LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN B WITH(NOLOCK)
                        ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                        AND A.ITEM_ID     = B.ATTRIBUTE2
                        AND A.STAGE       = B.ATTRIBUTE3
                        AND A.LINE_ID     = B.ATTRIBUTE15
                        AND A.PLAN_DATE   >= B.START_DATE
                        AND A.PLAN_DATE   <  B.END_DATE
                        AND B.PLAN_ID     = @V_PLAN_ID
                    GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, B.ROUTING_ID, QTY, PLAN_MONTH, SOURCE_CHK 
            END
        IF @V_SYS_DIVS_CD = 'FP' AND @V_PROD_FP_FRZ_TYPE = 'CUT_OFF'
            BEGIN 
                IF OBJECT_ID('TEMPDB..#FP_RELEASE_PLAN_CUTOFF') IS NOT NULL
                BEGIN 
                    DROP TABLE  #FP_RELEASE_PLAN_CUTOFF;
                END;

                ------------------------------------------------------------------------
                -- 2025.08.14 Philsu Park: 속도 이슈로 TEMP에 담아서 사용.
                -- 2025.08.22 Philsu Park: Demand 제외구간 제약 적용.
                -- 2025.09.17 Philsu Park: FP Release Plan을 View가 아닌 C 로 변경.(신성재 책임님 요청):: _C도 최신계획이 아니라서 Rollback.
                ------------------------------------------------------------------------
                WITH DEMAND_EXCEPTION AS
                    (
                        -- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
                        -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
                        --SELECT    DISTINCT
                        --        LV.SEGMENT2   AS DIVISION_ID
                        --        , LV.SEGMENT3   AS SCM_SITE_ID
                        --        -- , LV.SEGMENT4   AS ITEM_ID
                        --        , EBM.CHILD_ITEM_ID AS ITEM_ID
                        --        , LV.SEGMENT5   AS GROUP_ID
                        --        , CASE WHEN ISNULL(LV.ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                        --                ELSE LV.ATTRIBUTE2
                        --        END AS START_DATE  -- PLAN 제외 시작일자
                        --        , CASE WHEN ISNULL(LV.ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                        --                ELSE LV.ATTRIBUTE3
                        --        END AS END_DATE  -- PLAN 제외 끝일자
                        --FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                        --INNER JOIN SCP_OPT_ENG_BOM_ELEC_SN EBM WITH(NOLOCK)
                        --    ON  EBM.PLAN_ID         = @V_PLAN_ID
                        --    AND EBM.PARENT_ITEM_ID  = LV.SEGMENT4
                        --WHERE   LV.LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                        --AND     LV.VALID_YN    = 'Y'
                        --AND     LV.SEGMENT2    = @V_DIVISION_ID
                        --AND     LV.SEGMENT5    = @V_GROUP_ID
                        --AND     LV.ATTRIBUTE1  = 'ASSY' -- CELL PLAN 제외
                        ---- 전극의 경우 공용 전극 ITEM이 있으므로 DEMAND가 있는 경우에는 제외하지 않음/20251013/THKIM
                        --AND     EBM.CHILD_ITEM_ID NOT IN (
                        --                                  SELECT  DISTINCT ATTRIBUTE2
                        --                                  FROM    SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                        --                                  WHERE   DM.PLAN_ID = @V_PLAN_ID
                        --                                 )
                        ---- ON  A.SCM_SITE_ID = DE.SCM_SITE_ID
                        ---- AND A.ITEM_ID     = DE.ITEM_ID

                        -- 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환
                        SELECT  DISTINCT
                                D.DIVISION_ID           AS DIVISION_ID
                              , D.SCM_SITE_ID           AS SCM_SITE_ID
                              , EBM.CHILD_ITEM_ID       AS ITEM_ID
                              , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                              , CASE
                                    WHEN ISNULL(D.FROM_YYYYMMDD, '') = '' THEN @V_PLAN_END_YYYYMMDD
                                    ELSE D.FROM_YYYYMMDD
                                END                     AS START_DATE
                              , CASE
                                    WHEN ISNULL(D.TO_YYYYMMDD, '') = '' THEN @V_PLAN_END_YYYYMMDD
                                    ELSE D.TO_YYYYMMDD
                                END                     AS END_DATE
                        FROM    SCP_OPMZ_DEMAND_EXCEPTION D WITH(NOLOCK)
                            INNER JOIN SCP_OPT_ENG_BOM_ELEC_SN EBM WITH(NOLOCK)
                                ON  EBM.PLAN_ID         = @V_PLAN_ID
                                AND EBM.PARENT_ITEM_ID  = D.ITEM_ID
                            LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                                ON  D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                AND PG.VALID_YN = 'Y'
                            INNER JOIN  (
                                        SELECT  DISTINCT ITEM_ID
                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE   PLAN_ID = @V_PLAN_ID
                                        ) MDL
                                ON  D.ITEM_ID = MDL.ITEM_ID
                        AND     D.VALID_YN = 'Y'
                        AND     D.DIVISION_ID = @V_DIVISION_ID
                        AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                        --AND     D.STAGE = 'TARGETBIZ'
                        -- 전극의 경우 공용 전극 ITEM이 있으므로 DEMAND가 있는 경우에는 제외하지 않음/20251013/THKIM
                        AND     EBM.CHILD_ITEM_ID NOT IN (
                                                            SELECT  DISTINCT ATTRIBUTE2
                                                            FROM    SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                                                            WHERE   DM.PLAN_ID = @V_PLAN_ID
                                                            )
                    )
                /* SELECT    FP.DIVISION_ID
                        , FP.SCM_SITE_ID
                        , ISNULL(FI.PACKER_PLAN_ITEM_ID, FP.ITEM_ID) AS ITEM_ID
                        , FP.LINE_ID
                        , CONVERT(NVARCHAR, FP.PLAN_DATE, 112) AS PLAN_DATE
                        , FP.PLAN_QTY
                        , FP.PRODUCTION_TYPE
                INTO    #FP_RELEASE_PLAN
                FROM   SCM_DNM_FP_RELEASE_PROD_PLAN_C FP WITH(NOLOCK)
                LEFT OUTER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)--2018.06.29
                    ON  FP.DIVISION_ID   = FI.DIVISION_ID
                    AND FP.ITEM_ID       = FI.ITEM_ID
                where  1=1
                AND    FP.YYYYMMDD  = @V_PLAN_START_YYYYMMDD
                AND     FP.PLAN_QTY > 0
                AND     CONVERT(NVARCHAR, FP.PLAN_DATE, 112) >= @V_SCP_PLAN_DATE  -- @V_START_YYYYMMDD
                AND     CONVERT(NVARCHAR, FP.PLAN_DATE, 112)  < @V_PROD_FROZEN_END  -- @V_START_YYYYMMDD
                -- AND    CONVERT(NVARCHAR, PLAN_DATE, 112) = '20250915'
                AND     (FP.DIVISION_ID  = '40' AND FP.PRODUCTION_TYPE IN ('MASS', 'C-MASS', 'M-SAMPLE')
                                                    OR  FP.DIVISION_ID  != '40')
                AND     EXISTS (SELECT 1
                                FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                WHERE   PLAN_ID         = @V_PLAN_ID
                                AND     RESOURCE_TYPE   = 'LINE'
                                AND    ATTRIBUTE15      = FP.LINE_ID
                                )
                AND     EXISTS (SELECT 1
                                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                WHERE  PLAN_ID      = @V_PLAN_ID
                                AND    SCM_SITE_ID = FP.SCM_SITE_ID
                                AND    ITEM_ID     = ISNULL(FI.PACKER_PLAN_ITEM_ID, FP.ITEM_ID)
                                )
                AND NOT EXISTS (SELECT 1
                                FROM   DEMAND_EXCEPTION DE 
                                WHERE  1=1
                                AND   DE.ITEM_ID       = ISNULL(FI.PACKER_PLAN_ITEM_ID, FP.ITEM_ID)
                                AND    CONVERT(NVARCHAR, FP.PLAN_DATE, 112) BETWEEN DE.START_DATE AND DE.END_DATE
                                ) */
                SELECT    R.DIVISION_ID
                        , M.SCM_SITE_ID
                        , ISNULL(FI.PACKER_PLAN_ITEM_ID, R.ITEM_ID) AS ITEM_ID --2018.06.29
                        , R.LINE_ID
                        , CONVERT(NVARCHAR, R.PLAN_DATE, 112)       AS PLAN_DATE
                        , R.PLAN_QTY          -- OUT 수량
                        , R.PRODUCTION_TYPE
                        /* Input 생성 시 미사용 컬럼 주석처리.
                        , r.top_item_id 
                        , r.item_id origin_item_id --2018.06.29
                        , r.company_id
                        , r.division_id
                        , r.site_id
                        , r.fp_production_type  -- 2025.05.13 양산 및 샘플, 테스트 등등.. 나중에 조건 걸어야 될 수도 있음.
                        , r.plant_id
                        , r.factory_id  
                        , r.operation_id
                        , r.location    
                        , r.market
                        , r.electrode_type
                        -- IN 수량
                        , CASE WHEN r.plan_in_qty <= 0 THEN r.plan_qty
                            ELSE r.plan_in_qty
                        END plan_in_qty
                        , r.equipment_id */
                INTO #FP_RELEASE_PLAN_CUTOFF
                FROM DBO.SCM_DNM_FP_RELEASE_PROD_PLAN_C R WITH(NOLOCK)
                LEFT JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)--2018.06.29
                    ON  R.DIVISION_ID   = FI.DIVISION_ID
                    AND R.ITEM_ID       = FI.ITEM_ID
                OUTER APPLY (
                            SELECT TOP 1 ISNULL(I.SCP_OPERATION_GROUP,'') AS SCP_OPERATION_GROUP
                                FROM DBO.SCM_MST_ITEM_SN              I WITH(NOLOCK)
                            WHERE 1=1
                                AND I.DIVISION_ID          = R.DIVISION_ID
                                AND I.ITEM_ID              = R.ITEM_ID
                            ) AS OG
                OUTER APPLY (
                            SELECT TOP 1 ISNULL(I.SCM_SITE_ID,'') AS SCM_SITE_ID
                                FROM DBO.SCM_MST_SITE             I WITH(NOLOCK)
                            WHERE 1 = 1
                                AND I.PLANT_ID             = R.PLANT_ID
                                AND I.OPERATION_GROUP      = OG.SCP_OPERATION_GROUP
                                AND I.SITE_TYPE            = 'PLANT'
                                AND I.VALID_YN             = 'Y'
                            ) AS M
                INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                    ON  FM.FROZEN_TYPE = 'PROD'
                    AND FM.STAGE = IIF(R.OPERATION_ID = 'E2000','COATING','')
                    AND FM.PLAN_ID = @V_PLAN_ID
                WHERE   1=1
                AND     R.PLAN_QTY > 0
                AND     R.YYYYMMDD            = @V_SCP_PLAN_DATE
                AND     CONVERT(NVARCHAR, R.PLAN_DATE, 112) >= FROZEN_START_DATE  -- @V_SCP_PLAN_DATE
                AND     CONVERT(NVARCHAR, R.PLAN_DATE, 112)  < FROZEN_END_DATE  -- @V_PROD_FROZEN_END
                AND     EXISTS (SELECT 1
                                FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                WHERE   PLAN_ID         = @V_PLAN_ID
                                AND     RESOURCE_TYPE   = 'LINE'
                                AND    ATTRIBUTE15      = R.LINE_ID
                                )
                AND     EXISTS (SELECT 1
                                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                WHERE  PLAN_ID      = @V_PLAN_ID
                                AND    SCM_SITE_ID = M.SCM_SITE_ID
                                AND    ITEM_ID     = ISNULL(FI.PACKER_PLAN_ITEM_ID, R.ITEM_ID)
                                )
                AND NOT EXISTS (SELECT 1
                                FROM   DEMAND_EXCEPTION DE 
                                WHERE  1=1
                                AND   DE.ITEM_ID       = ISNULL(FI.PACKER_PLAN_ITEM_ID, R.ITEM_ID)
                                AND    CONVERT(NVARCHAR, R.PLAN_DATE, 112) BETWEEN DE.START_DATE AND DE.END_DATE
                                )
                ;

                INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(
                                                        PLAN_ID
                                                    ,FROZEN_ID
                                                    ,ROUTING_BOM_MAPPING_ID
                                                    ,OP_SEQ
                                                    ,RESOURCE_ID
                                                    ,QUANTITY
                                                    ,EFFECTIVE_DATE
                                                    ,ATTRIBUTE1
                                                    ,ATTRIBUTE2
                                                    ,ATTRIBUTE3
                                                    ,ATTRIBUTE13
                                                    ,ATTRIBUTE14
                                                    ,ATTRIBUTE15
                                                    )
                SELECT  @V_PLAN_ID                                                      AS PLAN_ID
                    ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+LINE_ID+'::'+PLAN_DATE AS FROZEN_ID
                    ,'RB'+B.ROUTING_ID                                               AS ROUTING_BOM_MAPPING_ID
                    ,0                                                               AS OP_SEQ
                    ,SCM_SITE_ID+'::'+LINE_ID                                        AS RESOURCE_ID
                    ,QTY                                                             AS QUANTITY
                    ,PLAN_DATE                                                       AS EFFECTIVE_DATE
                    ,SCM_SITE_ID                                                     AS SITE_ID
                    ,ITEM_ID                                                         AS ITEM_ID    
                    ,STAGE                                                           AS STAGE      
                    ,SOURCE_CHK                                                      AS SOURCE_CHK
                    ,LINE_ID                                                         AS LINE_ID    
                    ,PLAN_MONTH                                                      AS PLAN_MONTH 
                FROM(
                    SELECT  SCM_SITE_ID       AS SCM_SITE_ID
                        ,ITEM_ID           AS ITEM_ID
                        ,STAGE             AS STAGE
                        ,LINE_ID           AS LINE_ID
                        ,PLAN_DATE         AS PLAN_DATE
                        ,LEFT(PLAN_DATE,6) AS PLAN_MONTH
                        ,SUM(PLAN_IN_QTY)  AS QTY
                        ,SOURCE_CHK            AS SOURCE_CHK
                    FROM(
                            SELECT    V.SCM_SITE_ID AS SCM_SITE_ID
                                    , V.ITEM_ID     AS ITEM_ID
                                    , 'COATING'     AS STAGE
                                    , V.LINE_ID     AS LINE_ID
                                    , V.PLAN_DATE   AS PLAN_DATE
                                    , SUM(V.PLAN_QTY)    AS PLAN_IN_QTY  -- AFTER_CORRECT에서  수율 먹여서 투입수량으로 변경.
                                    , 'FP_RELEASE_PLAN' AS SOURCE_CHK
                            FROM    #FP_RELEASE_PLAN_CUTOFF V
                            WHERE   1=1
                            AND     ISNULL(V.PRODUCTION_TYPE, '-') NOT IN ('REWORK', 'M/C')  -- TEST는 포함하고 나머지는 제외.
                            AND     (V.DIVISION_ID  = '40' AND ISNULL(V.PRODUCTION_TYPE, '-') IN ('MASS', 'C-MASS', 'M-SAMPLE')
                                OR  V.DIVISION_ID  != '40')
                            GROUP BY  V.SCM_SITE_ID
                                    , V.ITEM_ID
                                    , V.LINE_ID
                                    , V.PLAN_DATE
                            ------------------------------------------------------------------------------------------------------
                            UNION ALL
                            ------------------------------------------------------------------------------------------------------
                            -- 2025.05.14 Philsu Park: Lookup Fix값 0 보다 큰 값만 들어가게 제약조건 추가.
                            -- 2025.05.20 Philsu Park: GROUP_ID 조건 추가.(두군데)
                            ------------------------------------------------------------------------------------------------------
                            SELECT	 LVF.SEGMENT5	AS SCM_SITE_ID
                                    ,LVF.ATTRIBUTE2 AS ITEM_ID
                                    ,'COATING' AS STAGE
                                    ,LVF.ATTRIBUTE1 AS LINE_ID
                                    ,LVF.ATTRIBUTE3 AS PLAN_DATE
                                    ,LVF.ATTRIBUTE4 AS PLAN_IN_QTY
                                    ,'LOOKUP_PROD_FIX' AS SOURCE_CHK
                            FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LVF WITH(NOLOCK)
                                    INNER JOIN ( 
                                                SELECT A.*
                                                FROM   SCM_MST_SITE A WITH (NOLOCK)

                                                INNER JOIN #DIVISION D WITH(NOLOCK)
                                                ON A.DIVISION_ID = D.DIVISION_ID

                                                WHERE  1=1 -- A.DIVISION_ID = @V_DIVISION_ID 
                                                AND    A.SITE_TYPE   = 'PLANT'
                                                AND    A.VALID_YN    = 'Y'	
                                                AND    A.OPERATION_GROUP = 'E'	
                                                ) MSE
                                        ON   LVF.SEGMENT5 = MSE.SCM_SITE_ID 
                                    INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                                        ON  FM.FROZEN_TYPE = 'PROD'
                                        AND FM.STAGE = IIF(LVF.SEGMENT4= 'E2000','COATING','')
                                        AND FM.PLAN_ID = @V_PLAN_ID
                            WHERE	LVF.LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
                            AND     LVF.SEGMENT3    = @V_GROUP_ID           -- GROUP_ID 제약조건 추가
                            AND		LVF.ATTRIBUTE3 >= FROZEN_END_DATE -- @V_PROD_FROZEN_END  -- Frozen 구간 이후 FIX 만 적용
                            AND		LVF.ATTRIBUTE3 <  @V_PLAN_END_YYYYMMDD
                            AND     CONVERT(NUMERIC(30, 10), LVF.ATTRIBUTE4) > 0
                            AND     LVF.VALID_YN    = 'Y'
                            AND     LVF.ATTRIBUTE1 IN (SELECT DISTINCT ATTRIBUTE15
                                                        FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                                        WHERE   PLAN_ID = @V_PLAN_ID
                                                        AND     RESOURCE_TYPE = 'LINE'
                                                    )
                            /************************* 
                            대상 프로젝트 ITEM 필터링 
                            *************************/
                            AND CONCAT(LVF.SEGMENT5, LVF.ATTRIBUTE2) 
                                IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
                                    FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                    WHERE  PLAN_ID = @V_PLAN_ID
                                )
                        ------------------------------------------------------------------------------------------------------
                    ) AA
                    GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, SOURCE_CHK
                ) A
                --ROUTING ID가 일 기준으로 변경되면서 ROUTING_RESOURCE로 JOIN 조건 변경/20250702/김태현 선임
                --LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN B WITH(NOLOCK)
                --ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                --AND A.ITEM_ID     = B.ATTRIBUTE2
                --AND A.STAGE       = B.ATTRIBUTE3
                --AND A.LINE_ID     = B.ATTRIBUTE14
                --AND A.PLAN_MONTH  = B.ATTRIBUTE15
                --AND B.PLAN_ID     = @V_PLAN_ID
                LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN B WITH(NOLOCK)
                    ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                    AND A.ITEM_ID     = B.ATTRIBUTE2
                    AND A.STAGE       = B.ATTRIBUTE3
                    AND A.LINE_ID     = B.ATTRIBUTE15
                    AND A.PLAN_DATE   >= B.START_DATE
                    AND A.PLAN_DATE   <  B.END_DATE
                    AND B.PLAN_ID     = @V_PLAN_ID
                GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, B.ROUTING_ID, QTY, PLAN_MONTH, SOURCE_CHK 
            END
        ELSE IF @V_SYS_DIVS_CD = 'SCP'
            BEGIN 
                ------------------------------------------------------------------------------------------------------
                -- 2025.08.22 Philsu Park: Demand 제외구간 제약 적용.
                ------------------------------------------------------------------------------------------------------
                WITH DEMAND_EXCEPTION AS
                    (
                        -- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
                        -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
                        --SELECT    DISTINCT
                        --        LV.SEGMENT2   AS DIVISION_ID
                        --        , LV.SEGMENT3   AS SCM_SITE_ID
                        --        -- , LV.SEGMENT4   AS ITEM_ID
                        --        , EBM.CHILD_ITEM_ID AS ITEM_ID
                        --        , LV.SEGMENT5   AS GROUP_ID
                        --        , CASE WHEN ISNULL(LV.ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                        --                ELSE LV.ATTRIBUTE2
                        --        END AS START_DATE  -- PLAN 제외 시작일자
                        --        , CASE WHEN ISNULL(LV.ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                        --                ELSE LV.ATTRIBUTE3
                        --        END AS END_DATE  -- PLAN 제외 끝일자
                        --FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                        --INNER JOIN SCP_OPT_ENG_BOM_ELEC_SN EBM WITH(NOLOCK)
                        --    ON  EBM.PLAN_ID         = @V_PLAN_ID
                        --    AND EBM.PARENT_ITEM_ID  = LV.SEGMENT4
                        --WHERE   LV.LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                        --AND     LV.VALID_YN    = 'Y'
                        --AND     LV.SEGMENT2    = @V_DIVISION_ID
                        --AND     LV.SEGMENT5    = @V_GROUP_ID
                        --AND     LV.ATTRIBUTE1  = 'ASSY' -- CELL PLAN 제외
                        ---- 전극의 경우 공용 전극 ITEM이 있으므로 DEMAND가 있는 경우에는 제외하지 않음/20251013/THKIM
                        --AND     EBM.CHILD_ITEM_ID NOT IN (
                        --                                  SELECT  DISTINCT ATTRIBUTE2
                        --                                  FROM    SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                        --                                  WHERE   DM.PLAN_ID = @V_PLAN_ID
                        --                                 )
                        ---- ON  A.SCM_SITE_ID = DE.SCM_SITE_ID
                        ---- AND A.ITEM_ID     = DE.ITEM_ID

                        -- 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환
                        SELECT  DISTINCT
                                D.DIVISION_ID           AS DIVISION_ID
                              , D.SCM_SITE_ID           AS SCM_SITE_ID
                              , EBM.CHILD_ITEM_ID       AS ITEM_ID
                              , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                              , CASE
                                    WHEN ISNULL(D.FROM_YYYYMMDD, '') = '' THEN @V_PLAN_END_YYYYMMDD
                                    ELSE D.FROM_YYYYMMDD
                                END                     AS START_DATE
                              , CASE
                                    WHEN ISNULL(D.TO_YYYYMMDD, '') = '' THEN @V_PLAN_END_YYYYMMDD
                                    ELSE D.TO_YYYYMMDD
                                END                     AS END_DATE
                        FROM    SCP_OPMZ_DEMAND_EXCEPTION D WITH(NOLOCK)
                            INNER JOIN SCP_OPT_ENG_BOM_ELEC_SN EBM WITH(NOLOCK)
                                ON  EBM.PLAN_ID         = @V_PLAN_ID
                                AND EBM.PARENT_ITEM_ID  = D.ITEM_ID
                            LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                                ON  D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                AND PG.VALID_YN = 'Y'
                            INNER JOIN  (
                                        SELECT  DISTINCT ITEM_ID
                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE   PLAN_ID = @V_PLAN_ID
                                        ) MDL
                                ON  D.ITEM_ID = MDL.ITEM_ID
                        AND     D.VALID_YN = 'Y'
                        AND     D.DIVISION_ID = @V_DIVISION_ID
                        AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                        --AND     D.STAGE = 'TARGETBIZ'
                        -- 전극의 경우 공용 전극 ITEM이 있으므로 DEMAND가 있는 경우에는 제외하지 않음/20251013/THKIM
                        AND     EBM.CHILD_ITEM_ID NOT IN (
                                                            SELECT  DISTINCT ATTRIBUTE2
                                                            FROM    SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                                                            WHERE   DM.PLAN_ID = @V_PLAN_ID
                                                            )
                    )
                INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(
                                                        PLAN_ID
                                                    ,FROZEN_ID
                                                    ,ROUTING_BOM_MAPPING_ID
                                                    ,OP_SEQ
                                                    ,RESOURCE_ID
                                                    ,QUANTITY
                                                    ,EFFECTIVE_DATE
                                                    ,ATTRIBUTE1
                                                    ,ATTRIBUTE2
                                                    ,ATTRIBUTE3
                                                    ,ATTRIBUTE13
                                                    ,ATTRIBUTE14
                                                    ,ATTRIBUTE15
                                                    )
                    SELECT  @V_PLAN_ID                                                      AS PLAN_ID
                        ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+LINE_ID+'::'+PLAN_DATE AS FROZEN_ID
                        ,'RB'+B.ROUTING_ID                                               AS ROUTING_BOM_MAPPING_ID
                        ,0                                                               AS OP_SEQ
                        ,SCM_SITE_ID+'::'+LINE_ID                                        AS RESOURCE_ID
                        ,QTY                                                             AS QUANTITY
                        ,PLAN_DATE                                                       AS EFFECTIVE_DATE
                        ,SCM_SITE_ID                                                     AS SITE_ID
                        ,ITEM_ID                                                         AS ITEM_ID    
                        ,STAGE                                                           AS STAGE      
                        ,SOURCE_CHK                                                      AS SOURCE_CHK
                        ,LINE_ID                                                         AS LINE_ID    
                        ,PLAN_MONTH                                                      AS PLAN_MONTH 
                    FROM(
                        SELECT  SCM_SITE_ID       AS SCM_SITE_ID
                            ,ITEM_ID           AS ITEM_ID
                            ,STAGE             AS STAGE
                            ,LINE_ID           AS LINE_ID
                            ,PLAN_DATE         AS PLAN_DATE
                            ,LEFT(PLAN_DATE,6) AS PLAN_MONTH
                            ,SUM(PLAN_IN_QTY)  AS QTY
                            ,SOURCE_CHK            AS SOURCE_CHK
                        FROM(
                                SELECT    A.SCM_SITE_ID
                                        , A.ITEM_ID
                                        , 'COATING' AS STAGE
                                        /* PLAN_DATE 투입계획으로 변환 필요 / FP내에공정별LT관리되나 데이터 전체 0으로 따로 로직 반영 안함 : AFTER 작업에서 수율 적용하여 IN Qty 로 Update함 */ 
                                        , A.LINE_ID
                                        , A.YYYYMMDD AS PLAN_DATE
                                        , A.QTY AS PLAN_IN_QTY
                                        , 'ANL_PRODUCTION_PLAN' AS SOURCE_CHK
                                FROM    SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)    

                                INNER JOIN ( 
                                            SELECT A.*
                                            FROM   SCM_MST_SITE A WITH (NOLOCK)

                                            INNER JOIN #DIVISION D WITH(NOLOCK)
                                            ON A.DIVISION_ID = D.DIVISION_ID

                                            WHERE  1=1 -- A.DIVISION_ID = @V_DIVISION_ID 
                                            AND    A.SITE_TYPE   = 'PLANT'
                                            AND    A.VALID_YN    = 'Y'	
                                            AND    A.OPERATION_GROUP = 'E'	
                                            ) MSE
                                ON   A.SCM_SITE_ID = MSE.SCM_SITE_ID 
                                INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                                    ON  FM.FROZEN_TYPE = 'PROD'
                                    AND FM.STAGE = IIF(A.OPERATION_ID= 'E2000','COATING','')
                                    AND FM.PLAN_ID = @V_PLAN_ID
                                    
                                WHERE A.DIVISION_ID         = @V_DIVISION_ID
                                AND   A.PLAN_START_YYYYMMDD = @V_SCP_PLAN_DATE
                                AND   A.PLAN_TYPE           = @V_SCP_PLAN_TYPE 
                                AND   A.SEQ                 = @V_SCP_PLAN_SEQ  
                                AND   A.MEASURE             = 'PROD_PLAN_AMEND'
                                AND   A.OPERATION_ID        = 'E2000'
                                AND   A.QTY                >  0   
                                AND   A.YYYYMMDD           >= FROZEN_START_DATE --@V_SCP_PLAN_DATE 
                                AND   A.YYYYMMDD           <  FROZEN_END_DATE -- @V_PROD_FROZEN_END
                                AND   A.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
                                                    FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                                    WHERE   PLAN_ID =@V_PLAN_ID
                                                    AND     RESOURCE_TYPE = 'LINE'
                                                    )
                                /************************* 
                                대상 프로젝트 ITEM 필터링 
                                *************************/
                                AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
                                    IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
                                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE  PLAN_ID = @V_PLAN_ID
                                    ) 
                                AND NOT EXISTS (SELECT  1
                                                FROM    DEMAND_EXCEPTION DE 
                                                WHERE   1=1
                                                AND     DE.ITEM_ID          = A.ITEM_ID
                                                AND     A.YYYYMMDD    BETWEEN DE.START_DATE AND DE.END_DATE
                                                )
                                ------------------------------------------------------------------------------------------------------
                                UNION ALL
                                ------------------------------------------------------------------------------------------------------
                                -- 2025.05.14 Philsu Park: Lookup Fix값 0 보다 큰 값만 들어가게 제약조건 추가.
                                -- 2025.05.20 Philsu Park: Group_Id 조건 추가.(두군데)
                                ------------------------------------------------------------------------------------------------------
                                SELECT	 LVF.SEGMENT5	AS SCM_SITE_ID
                                        ,LVF.ATTRIBUTE2 AS ITEM_ID
                                        ,'COATING' AS STAGE
                                        ,LVF.ATTRIBUTE1 AS LINE_ID
                                        ,LVF.ATTRIBUTE3 AS PLAN_DATE
                                        ,LVF.ATTRIBUTE4 AS PLAN_IN_QTY
                                        ,'LOOKUP_PROD_FIX' AS SOURCE_CHK
                                FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LVF WITH(NOLOCK)
                                        INNER JOIN ( 
                                                    SELECT A.*
                                                    FROM   SCM_MST_SITE A WITH (NOLOCK)

                                                    INNER JOIN #DIVISION D WITH(NOLOCK)
                                                    ON A.DIVISION_ID = D.DIVISION_ID

                                                    WHERE  1=1 -- A.DIVISION_ID = @V_DIVISION_ID 
                                                    AND    A.SITE_TYPE   = 'PLANT'
                                                    AND    A.VALID_YN    = 'Y'	
                                                    AND    A.OPERATION_GROUP = 'E'	
                                                    ) MSE
                                            ON   LVF.SEGMENT5 = MSE.SCM_SITE_ID 
                                INNER JOIN SCP_OPT_ENG_FROZEN_MASTER_SN FM WITH(NOLOCK)
                                    ON  FM.FROZEN_TYPE = 'PROD'
                                    AND FM.STAGE = IIF(LVF.SEGMENT4= 'E2000','COATING','')
                                    AND FM.PLAN_ID = @V_PLAN_ID
                                WHERE	LVF.LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
                                AND     LVF.SEGMENT3    = @V_GROUP_ID           -- GROUP_ID 제약조건 추가
                                AND		LVF.ATTRIBUTE3 >= FROZEN_END_DATE -- @V_PROD_FROZEN_END Frozen 구간 이후 FIX 만 적용
                                AND		LVF.ATTRIBUTE3 <  @V_PLAN_END_YYYYMMDD
                                AND     CONVERT(NUMERIC(30, 10), LVF.ATTRIBUTE4) > 0
                                AND     LVF.VALID_YN    = 'Y'
                                AND     LVF.ATTRIBUTE1 IN (SELECT DISTINCT ATTRIBUTE15
                                                            FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                                            WHERE   PLAN_ID = @V_PLAN_ID
                                                            AND     RESOURCE_TYPE = 'LINE'
                                                        )
                                /************************* 
                                대상 프로젝트 ITEM 필터링 
                                *************************/
                                AND CONCAT(LVF.SEGMENT5, LVF.ATTRIBUTE2) 
                                    IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
                                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE  PLAN_ID = @V_PLAN_ID
                                    )
                            ------------------------------------------------------------------------------------------------------
                        ) AA
                        GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, SOURCE_CHK
                    ) A
                        --ROUTING ID가 일 기준으로 변경되면서 ROUTING_RESOURCE로 JOIN 조건 변경/20250702/김태현 선임
                        --LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN B WITH(NOLOCK)
                        --ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                        --AND A.ITEM_ID     = B.ATTRIBUTE2
                        --AND A.STAGE       = B.ATTRIBUTE3
                        --AND A.LINE_ID     = B.ATTRIBUTE14
                        --AND A.PLAN_MONTH  = B.ATTRIBUTE15
                        --AND B.PLAN_ID     = @V_PLAN_ID
                        LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN B WITH(NOLOCK)
                            ON  A.SCM_SITE_ID = B.ATTRIBUTE1
                            AND A.ITEM_ID     = B.ATTRIBUTE2
                            AND A.STAGE       = B.ATTRIBUTE3
                            AND A.LINE_ID     = B.ATTRIBUTE15
                            AND A.PLAN_DATE   >= B.START_DATE
                            AND A.PLAN_DATE   <  B.END_DATE
                            AND B.PLAN_ID     = @V_PLAN_ID
                    GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, B.ROUTING_ID, QTY, PLAN_MONTH, SOURCE_CHK 
                    ;
            END
    -------------------------------------------------
    -- START
    -- 2025.05.13 Philsu Park: 기존 Prod Plan Amend 사용구문 주석처리.
	-------------------------------------------------
        /* INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(
												PLAN_ID
											   ,FROZEN_ID
											   ,ROUTING_BOM_MAPPING_ID
											   ,OP_SEQ
											   ,RESOURCE_ID
											   ,QUANTITY
											   ,EFFECTIVE_DATE
											   ,ATTRIBUTE1
											   ,ATTRIBUTE2
											   ,ATTRIBUTE3
											   ,ATTRIBUTE13
											   ,ATTRIBUTE14
											   ,ATTRIBUTE15
											   )
        SELECT  @V_PLAN_ID                                                      AS PLAN_ID
               ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+LINE_ID+'::'+PLAN_DATE AS FROZEN_ID
               ,'RB'+B.ROUTING_ID                                               AS ROUTING_BOM_MAPPING_ID
               ,0                                                               AS OP_SEQ
               ,SCM_SITE_ID+'::'+LINE_ID                                        AS RESOURCE_ID
               ,QTY                                                             AS QUANTITY
               ,PLAN_DATE                                                       AS EFFECTIVE_DATE
               ,SCM_SITE_ID                                                     AS SITE_ID
               ,ITEM_ID                                                         AS ITEM_ID    
               ,STAGE                                                           AS STAGE      
               ,SOURCE_CHK                                                      AS SOURCE_CHK
               ,LINE_ID                                                         AS LINE_ID    
               ,PLAN_MONTH                                                      AS PLAN_MONTH 
        FROM(
            SELECT  SCM_SITE_ID       AS SCM_SITE_ID
                   ,ITEM_ID           AS ITEM_ID
                   ,STAGE             AS STAGE
                   ,LINE_ID           AS LINE_ID
                   ,PLAN_DATE         AS PLAN_DATE
                   ,LEFT(PLAN_DATE,6) AS PLAN_MONTH
                   ,SUM(PLAN_IN_QTY)  AS QTY
                   ,SOURCE_CHK            AS SOURCE_CHK
            FROM(
                SELECT  A.SCM_SITE_ID
                       ,A.ITEM_ID
                       ,'COATING' AS STAGE
            		  /* PLAN_DATE 투입계획으로 변환 필요 / FP내에공정별LT관리되나 데이터 전체 0으로 따로 로직 반영 안함 : AFTER 작업에서 수율 적용하여 IN Qty 로 Update함 */ 
            		   ,A.LINE_ID
                       ,A.YYYYMMDD AS PLAN_DATE
                       ,A.QTY AS PLAN_IN_QTY
                       ,'ANL_PRODUCTION_PLAN' AS SOURCE_CHK
            	FROM    SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)    

				INNER JOIN ( 
							SELECT A.*
							FROM   SCM_MST_SITE A WITH (NOLOCK)

							INNER JOIN #DIVISION D WITH(NOLOCK)
							ON A.DIVISION_ID = D.DIVISION_ID

							WHERE  1=1 -- A.DIVISION_ID = @V_DIVISION_ID 
							AND    A.SITE_TYPE   = 'PLANT'
							AND    A.VALID_YN    = 'Y'	
							AND    A.OPERATION_GROUP = 'E'	
							) MSE
				ON   A.SCM_SITE_ID = MSE.SCM_SITE_ID 
					
				WHERE A.DIVISION_ID         = @V_DIVISION_ID
				AND   A.PLAN_START_YYYYMMDD = @V_SCP_PLAN_DATE
				AND   A.PLAN_TYPE           = @V_SCP_PLAN_TYPE 
				AND   A.SEQ                 = @V_SCP_PLAN_SEQ  
				AND   A.MEASURE             = 'PROD_PLAN_AMEND'
				AND   A.OPERATION_ID        = 'E2000'
				AND   A.QTY                >  0   
				AND   A.YYYYMMDD           >= @V_SCP_PLAN_DATE  
				AND   A.YYYYMMDD           <  @V_PROD_FROZEN_END -- DATEADD(DD, ISNULL(@V_PROD_FROZEN, 0), @V_SCP_PLAN_DATE )
            	AND   A.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
									FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
									WHERE   PLAN_ID =@V_PLAN_ID
									AND     RESOURCE_TYPE = 'LINE'
									)
				/************************* 
				대상 프로젝트 ITEM 필터링 
				*************************/
				AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
					IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
						FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
						WHERE  PLAN_ID = @V_PLAN_ID
					   ) 
			    ------------------------------------------------------------------------------------------------------
			    UNION ALL
			    ------------------------------------------------------------------------------------------------------
			    SELECT	 LVF.SEGMENT5	AS SCM_SITE_ID
			    		,LVF.ATTRIBUTE2 AS ITEM_ID
                       ,'COATING' AS STAGE
			    		,LVF.ATTRIBUTE1 AS LINE_ID
			    		,LVF.ATTRIBUTE3 AS PLAN_DATE
			    		,LVF.ATTRIBUTE4 AS PLAN_IN_QTY
                        ,'LOOKUP_PROD_FIX' AS SOURCE_CHK
			    FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LVF WITH(NOLOCK)
			    		INNER JOIN ( 
									SELECT A.*
									FROM   SCM_MST_SITE A WITH (NOLOCK)

									INNER JOIN #DIVISION D WITH(NOLOCK)
									ON A.DIVISION_ID = D.DIVISION_ID

									WHERE  1=1 -- A.DIVISION_ID = @V_DIVISION_ID 
									AND    A.SITE_TYPE   = 'PLANT'
									AND    A.VALID_YN    = 'Y'	
									AND    A.OPERATION_GROUP = 'E'	
									) MSE
			    			ON   LVF.SEGMENT5 = MSE.SCM_SITE_ID 

			    WHERE	LOOKUP_TYPE     = 'SCP_OPT_ENG_PROD_FIX'
			    AND		LVF.ATTRIBUTE3 >= @V_PROD_FROZEN_END -- @V_SCP_PLAN_DATE  -- Frozen 구간 이후 FIX 만 적용
			    AND		LVF.ATTRIBUTE3 <  @V_PLAN_END_YYYYMMDD
                AND     LVF.VALID_YN    = 'Y'
			    AND     LVF.ATTRIBUTE1 IN (SELECT DISTINCT ATTRIBUTE15
			    							FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
			    							WHERE   PLAN_ID = @V_PLAN_ID
			    							AND     RESOURCE_TYPE = 'LINE'
			    						 )
				/************************* 
				대상 프로젝트 ITEM 필터링 
				*************************/
				AND CONCAT(LVF.SEGMENT5, LVF.ATTRIBUTE2) 
					IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
						FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
						WHERE  PLAN_ID = @V_PLAN_ID
					   )
			    ------------------------------------------------------------------------------------------------------
            ) AA
            GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, SOURCE_CHK
        ) A
        LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN B WITH(NOLOCK)
        ON  A.SCM_SITE_ID = B.ATTRIBUTE1
        AND A.ITEM_ID     = B.ATTRIBUTE2
        AND A.STAGE       = B.ATTRIBUTE3
        AND A.LINE_ID     = B.ATTRIBUTE14
        AND A.PLAN_MONTH  = B.ATTRIBUTE15
        AND B.PLAN_ID     = @V_PLAN_ID
        GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, B.ROUTING_ID, QTY, PLAN_MONTH, SOURCE_CHK 
        */
    -------------------------------------------------
    -- 임시 적용 : W07 Final Plan 정보 : END
	-------------------------------------------------

/*--원래 적용 로직 -- 적용 시 수정 필요 : START

        INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(
												PLAN_ID
											   ,FROZEN_ID
											   ,ROUTING_BOM_MAPPING_ID
											   ,OP_SEQ
											   ,RESOURCE_ID
											   ,QUANTITY
											   ,EFFECTIVE_DATE
											   ,ATTRIBUTE1
											   ,ATTRIBUTE2
											   ,ATTRIBUTE3
											   ,ATTRIBUTE14
											   ,ATTRIBUTE15
											   )
        SELECT  @V_PLAN_ID                                                      AS PLAN_ID
               ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+LINE_ID+'::'+PLAN_DATE AS FROZEN_ID
               ,'RB'+B.ROUTING_ID                                               AS ROUTING_BOM_MAPPING_ID
               ,0                                                               AS OP_SEQ
               ,SCM_SITE_ID+'::'+LINE_ID                                        AS RESOURCE_ID
               ,QTY                                                             AS QUANTITY
               ,PLAN_DATE                                                       AS EFFECTIVE_DATE
               ,SCM_SITE_ID                                                     AS SITE_ID
               ,ITEM_ID                                                         AS ITEM_ID    
               ,STAGE                                                           AS STAGE      
               ,LINE_ID                                                         AS LINE_ID    
               ,PLAN_MONTH                                                      AS PLAN_MONTH 
        FROM(
            SELECT  SCM_SITE_ID       AS SCM_SITE_ID
                   ,ITEM_ID           AS ITEM_ID
                   ,STAGE             AS STAGE
                   ,LINE_ID           AS LINE_ID
                   ,PLAN_DATE         AS PLAN_DATE
                   ,LEFT(PLAN_DATE,6) AS PLAN_MONTH
                   ,SUM(PLAN_IN_QTY)  AS QTY
            FROM(
                SELECT  A.SCM_SITE_ID
                       ,A.ITEM_ID
                       --,'ASSY' AS STAGE
                	   ,CASE WHEN MSE.OPERATION_GROUP = 'A'                          THEN 'ASSY'
                			WHEN MSE.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500' THEN 'PACK'
                			WHEN MSE.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500' THEN 'MDLE'
                			WHEN MSE.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5000' THEN 'MDLE'
                		END AS STAGE
            		  /* PLAN_DATE 투입계획으로 변환 필요 / FP내에공정별LT관리되나 데이터 전체 0으로 따로 로직 반영 안함 */ 
            		   ,A.LINE_ID
                       ,CONVERT(VARCHAR(8), A.PLAN_DATE, 112) AS PLAN_DATE
                       ,A.PLAN_IN_QTY
            	FROM    SCM_DNM_FP_RELEASE_PROD_PLAN_C A WITH(NOLOCK)    

				INNER JOIN ( 
							SELECT *
							FROM   SCM_MST_SITE  WITH (NOLOCK)
							WHERE  DIVISION_ID = @V_DIVISION_ID 
							AND    SITE_TYPE   = 'PLANT'
							AND    VALID_YN    = 'Y'
							) MSE
				ON   A.SCM_SITE_ID = MSE.SCM_SITE_ID 
				AND ((MSE.DIVISION_ID  = '40' AND MSE.OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
					OR  (MSE.DIVISION_ID <> '40' AND MSE.OPERATION_GROUP IN ('A', 'P') )
					)

				INNER JOIN (SELECT DISTINCT DIVISION_ID
											,ITEM_ID
											,OPERATION_GROUP
											,FLOW_ID
											,ATTRIBUTE8
							FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
							WHERE  DIVISION_ID = @V_DIVISION_ID--@P_DIVISION_ID  
							AND    OPERATION_GROUP IN ('A', 'P')  
							) FI
				ON    A.ITEM_ID     = FI.ITEM_ID
				AND   A.DIVISION_ID = FI.DIVISION_ID 
					
            	WHERE 1=1
            	AND     A.DIVISION_ID = @V_DIVISION_ID    
            	AND     A.YYYYMMDD    = @V_PLAN_START_YYYYMMDD -- W04 Pre Plan
            	AND     A.PLAN_QTY    > 0        
            	AND     A.PLAN_IN_QTY > 0
            	AND     A.PLAN_DATE   >= @V_PLAN_START_YYYYMMDD
			    -- PLAN_DATE 관련 로직 변경 시 PR_SCP_OPT_ENG_EE_INPUT_BOM_ROUTING_SN 의 FROZEN_FENCE 설정 부분도 같이 수정할 것
            	AND     A.PLAN_DATE   <  DATEADD(DD, ISNULL(@V_PROD_FROZEN, 0), @V_PLAN_START_YYYYMMDD )
            	AND     A.ITEM_ID IN   (SELECT DISTINCT ITEM_ID
                                      FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                      WHERE  PLAN_ID = @V_PLAN_ID
                                     )
            	AND A.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
                                FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                WHERE   PLAN_ID =@V_PLAN_ID
                                AND     RESOURCE_TYPE = 'LINE'
                                )
				-- SCP Line별 생산 계획 생성 공정 정보				
				--AND    A.operation_id  IN ( 
				--						   SELECT b.segment2
				--						   FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
				--						   INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
				--						   ON  a.segment1= b.segment1
				--						   AND a.lookup_type = 'LOCATION_GROUP'
				--						   AND a.segment4    = 'Y' -- Capa 공정 여부 
				--						   AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
				--						   AND a.valid_yn    = 'Y'
				--						   AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
				--						   AND b.valid_yn    = 'Y'
				--						   AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
				--						 )
            ) AA
            GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE
        ) A
        LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN B WITH(NOLOCK)
        ON  A.SCM_SITE_ID = B.ATTRIBUTE1
        AND A.ITEM_ID     = B.ATTRIBUTE2
        AND A.STAGE       = B.ATTRIBUTE3
        AND A.LINE_ID     = B.ATTRIBUTE14
        AND A.PLAN_MONTH  = B.ATTRIBUTE15
        GROUP BY SCM_SITE_ID, ITEM_ID, STAGE, LINE_ID, PLAN_DATE, B.ROUTING_ID, QTY, PLAN_MONTH  

*/-- 원래 적용 로직 : END
        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------

		IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
		BEGIN 
			DROP TABLE  #DIVISION;
		END;

        ------------------------------------------------------------------------
        -- 2026.08.28 Minyong Lee : [E20260818-000193] [최적화 알고리즘] 사이트간 물량 이관 반영
        --   룩업 SCP_OPT_ENG_SITE_MOVE_FROZEN_PLAN
        ------------------------------------------------------------------------
        IF OBJECT_ID('TEMPDB..#SM_FZ_TARGET') IS NOT NULL DROP TABLE #SM_FZ_TARGET;

        DECLARE @V_SM_FZ_BASE_MONDAY NVARCHAR(8);
        SELECT  @V_SM_FZ_BASE_MONDAY = MIN(BASIS_YYYYMMDD)   -- 계획시작일이 속한 주의 월요일
        FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK)
        WHERE   ISO_YYYYWW = (SELECT ISO_YYYYWW FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
                              WHERE BASIS_YYYYMMDD = @V_PLAN_START_YYYYMMDD)
        ;

        SELECT  FZ.SITE_ID
               ,FZ.VIRT_ITEM
               ,MAP.ORIG_ITEM                                                  -- NULL = 역매핑 실패(차감 스킵)
               ,FZ.LINE_ID
               ,FZ.TARGET_MONDAY
               ,FZ.STAGE
               ,RRV.ROUTING_ID                                                 AS VIRT_ROUTING_ID
               ,FZ.FROZEN_QTY                                                  AS PLAN_QTY  -- 룩업 입력값 그대로 (IN 보정은 AFTER_CORRECT 담당)
        INTO    #SM_FZ_TARGET
        FROM   (SELECT  LU.SEGMENT3 AS SITE_ID
                       ,LU.SEGMENT4 AS VIRT_ITEM
                       ,LU.SEGMENT5 AS LINE_ID
                       ,LU.SEGMENT6 AS STAGE
                       ,CONVERT(NVARCHAR(8), DATEADD(DAY, 7 * TRY_CAST(LU.SEGMENT7 AS INT), CONVERT(DATE, @V_SM_FZ_BASE_MONDAY, 112)), 112) AS TARGET_MONDAY
                       ,SUM(CONVERT(NUMERIC(30,10), LU.ATTRIBUTE1)) AS FROZEN_QTY
                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_SITE_MOVE_FROZEN_PLAN'
                AND     LU.VALID_YN    = 'Y'
                AND     LU.SEGMENT1    = @V_DIVISION_ID
                AND     LU.SEGMENT2    = @V_GROUP_ID
                AND     TRY_CAST(LU.SEGMENT7 AS INT) IS NOT NULL
                AND     ISNULL(TRY_CAST(LU.ATTRIBUTE1 AS NUMERIC(30,10)), 0) > 0
                GROUP BY LU.SEGMENT3, LU.SEGMENT4, LU.SEGMENT5, LU.SEGMENT6
                        ,CONVERT(NVARCHAR(8), DATEADD(DAY, 7 * TRY_CAST(LU.SEGMENT7 AS INT), CONVERT(DATE, @V_SM_FZ_BASE_MONDAY, 112)), 112)
               ) FZ
        LEFT JOIN (SELECT DISTINCT SEGMENT4 + SEGMENT5 AS VIRT_ITEM, SEGMENT4 AS ORIG_ITEM
                   FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                   WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SITE_MOVE' AND VALID_YN = 'Y'
                   AND    ISNULL(SEGMENT5, '-') <> '-') MAP
            ON  MAP.VIRT_ITEM = FZ.VIRT_ITEM
        OUTER APPLY (SELECT TOP 1 RR.ROUTING_ID                                -- 가상코드 라우팅 (RB용)
                     FROM   SCP_OPT_ENG_ROUTING_RESOURCE_SN RR WITH(NOLOCK)
                     WHERE  RR.PLAN_ID     = @V_PLAN_ID
                     AND    RR.ATTRIBUTE1  = FZ.SITE_ID
                     AND    RR.ATTRIBUTE2  = FZ.VIRT_ITEM
                     AND    RR.ATTRIBUTE3  = FZ.STAGE
                     AND    RR.ATTRIBUTE15 = FZ.LINE_ID
                     AND    FZ.TARGET_MONDAY >= RR.START_DATE
                     AND    FZ.TARGET_MONDAY <  RR.END_DATE
                     ORDER BY RR.START_DATE DESC) RRV
        WHERE   FZ.TARGET_MONDAY >= @V_PLAN_START_YYYYMMDD
        AND     FZ.TARGET_MONDAY <  @V_PLAN_END_YYYYMMDD                       -- 계획구간 밖 스킵
        ;

        ------------------------------------------------------------------------
        -- 원본 모델 FROZEN_PLAN 차감 (주차 첫 날짜부터 누적, 부족 시 있는 만큼만, 0 행 유지)
        ------------------------------------------------------------------------
        ;WITH DED AS (
            SELECT  SITE_ID, ORIG_ITEM, LINE_ID, STAGE, TARGET_MONDAY
                   ,CONVERT(NVARCHAR(8), DATEADD(DAY, 6, CONVERT(DATE, TARGET_MONDAY, 112)), 112) AS WEEK_END
                   ,SUM(PLAN_QTY) AS DED_QTY
            FROM    #SM_FZ_TARGET
            WHERE   ORIG_ITEM IS NOT NULL
            GROUP BY SITE_ID, ORIG_ITEM, LINE_ID, STAGE, TARGET_MONDAY
        )
        , ALLOC AS (
            SELECT  FP.QUANTITY
                   ,FP.UPDATE_ID
                   ,DED.DED_QTY
                   ,SUM(FP.QUANTITY) OVER (PARTITION BY DED.SITE_ID, DED.ORIG_ITEM, DED.LINE_ID, DED.STAGE, DED.TARGET_MONDAY
                                           ORDER BY FP.EFFECTIVE_DATE, FP.FROZEN_ID
                                           ROWS UNBOUNDED PRECEDING) AS CUM_QTY
            FROM    SCP_OPT_ENG_FROZEN_PLAN_SN FP
            INNER JOIN DED
                ON  FP.ATTRIBUTE1      = DED.SITE_ID
                AND FP.ATTRIBUTE2      = DED.ORIG_ITEM
                AND FP.ATTRIBUTE3      = DED.STAGE
                AND FP.ATTRIBUTE14     = DED.LINE_ID
                AND FP.EFFECTIVE_DATE >= DED.TARGET_MONDAY
                AND FP.EFFECTIVE_DATE <= DED.WEEK_END
            WHERE   FP.PLAN_ID = @V_PLAN_ID
        )
        UPDATE  ALLOC
        SET     QUANTITY  = CASE WHEN CUM_QTY <= DED_QTY THEN 0                -- 전량 차감
                                 ELSE CUM_QTY - DED_QTY END                    -- 부분 차감 (잔여량)
               ,UPDATE_ID = 'SITE_MOVE'
        WHERE   CUM_QTY - QUANTITY < DED_QTY                                   -- 실제 차감 발생 행만
        ;

        ------------------------------------------------------------------------
        -- 가상코드 FROZEN_PLAN 생성 (오프셋 주차 월요일, 룩업 입력 수량 그대로)
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_FROZEN_PLAN_SN(
                                                PLAN_ID
                                               ,FROZEN_ID
                                               ,ROUTING_BOM_MAPPING_ID
                                               ,OP_SEQ
                                               ,RESOURCE_ID
                                               ,QUANTITY
                                               ,EFFECTIVE_DATE
                                               ,ATTRIBUTE1
                                               ,ATTRIBUTE2
                                               ,ATTRIBUTE3
                                               ,ATTRIBUTE13
                                               ,ATTRIBUTE14
                                               ,ATTRIBUTE15
                                               ,INSERT_ID
                                               ,UPDATE_ID
                                               )
        SELECT  @V_PLAN_ID                                                     AS PLAN_ID
               ,T.SITE_ID+'::'+T.VIRT_ITEM+'::'+T.STAGE+'::'+T.LINE_ID+'::'+T.TARGET_MONDAY AS FROZEN_ID
               ,'RB' + T.VIRT_ROUTING_ID                                       AS ROUTING_BOM_MAPPING_ID  -- 가상 라우팅 없으면 NULL (기존 LEFT JOIN 방식과 동일)
               ,0                                                              AS OP_SEQ
               ,T.SITE_ID+'::'+T.LINE_ID                                       AS RESOURCE_ID
               ,T.PLAN_QTY                                                     AS QUANTITY
               ,T.TARGET_MONDAY                                                AS EFFECTIVE_DATE
               ,T.SITE_ID                                                      AS SITE_ID
               ,T.VIRT_ITEM                                                    AS ITEM_ID
               ,T.STAGE                                                        AS STAGE
               ,'SITE_MOVE_FROZEN'                                             AS SOURCE_CHK
               ,T.LINE_ID                                                      AS LINE_ID
               ,LEFT(T.TARGET_MONDAY, 6)                                       AS PLAN_MONTH
               ,'SITE_MOVE'                                                    AS INSERT_ID
               ,'SITE_MOVE'                                                    AS UPDATE_ID
        FROM    #SM_FZ_TARGET T
        WHERE   NOT EXISTS (SELECT 1 FROM SCP_OPT_ENG_FROZEN_PLAN_SN X WITH(NOLOCK)
                            WHERE  X.PLAN_ID   = @V_PLAN_ID
                            AND    X.FROZEN_ID = T.SITE_ID+'::'+T.VIRT_ITEM+'::'+T.STAGE+'::'+T.LINE_ID+'::'+T.TARGET_MONDAY)
        ;

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
