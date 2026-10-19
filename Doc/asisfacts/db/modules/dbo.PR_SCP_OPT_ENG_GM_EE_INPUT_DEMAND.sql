

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_EE_INPUT_DEMAND]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
    ,@T_SCP_PLAN            optTableType_SCP_PLAN READONLY
AS 
BEGIN
    --2025.02.07 Taehyun Initial Release
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_EE_INPUT_DEMAND';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    DECLARE @MAX_TUESDAY         NVARCHAR(8)
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_DETAIL_DATE       DATETIME;
    DECLARE @P_PLAN_NAME         NVARCHAR(8) 
    DECLARE @D_PLAN_NAME         DATETIME 
    DECLARE @V_DEMAND_CUTOFF_DAY NVARCHAR(8) 
    DECLARE @V_DM_MAX_VERSION    NVARCHAR(200)

    DECLARE @V_START_WEEK        INT
    DECLARE @V_PLAN_TYPE         NVARCHAR(20);
    -- DECLARE @V_SHIP_FROZEN       INT;
    -- DECLARE @V_SHIP_FROZEN_DAY   NVARCHAR(8);
    DECLARE @V_PROD_FROZEN       INT;
    DECLARE @V_PROD_FROZEN_DAY   NVARCHAR(8);

	-- 임시 : 아래 변수 수정 처리 필요
    DECLARE @V_SCP_PLAN_TYPE    NVARCHAR(200)
    DECLARE @V_SCP_PLAN_DATE    NVARCHAR(200)
    DECLARE @V_SCP_PLAN_SEQ    NVARCHAR(200)

    DECLARE @V_ROLLING_YN   NVARCHAR(1);
    DECLARE @V_LATEST_FP_PLAN_ID NVARCHAR(100)


    DECLARE @V_PLAN_END_YYYYMMDD_ORI	NVARCHAR(20) = CONVERT(NVARCHAR(8), DATEADD(DAY,-1,@V_PLAN_END_YYYYMMDD),112);

    --DEMAND INSERT TEMP
    DECLARE @DM_INS_TEMP TABLE(
                          PLAN_ID nvarchar(200) NOT NULL,
                          DEMAND_ID nvarchar(200) NOT NULL,
                          BUFFER_ID nvarchar(200) NULL,
                          DEMAND_GROUP nvarchar(100) NULL,
                          DUE_DATE nvarchar(20) NULL,
                          TARGET_DATE nvarchar(20) NULL,
                          SALES_CUTOFF_DATE nvarchar(20) NULL,
                          EXPIRY_DATE nvarchar(20) NULL,
                          PRIORITY numeric(20, 0) NULL,
                          QUANTITY numeric(20, 10) NULL,
                          PRIORITY_GROUP nvarchar(100) NULL,
                          CUSTOMER_ID nvarchar(200) NULL,
                          ALLOW_SHORT nvarchar(100) NULL,
                          ATTRIBUTE1 nvarchar(150) NULL,
                          ATTRIBUTE2 nvarchar(150) NULL,
                          ATTRIBUTE3 nvarchar(150) NULL,
                          ATTRIBUTE4 nvarchar(150) NULL,
                          ATTRIBUTE5 nvarchar(150) NULL,
                          ATTRIBUTE6 nvarchar(150) NULL,
                          ATTRIBUTE7 nvarchar(150) NULL,
                          ATTRIBUTE8 nvarchar(150) NULL,
                          ATTRIBUTE9 nvarchar(150) NULL,
                          ATTRIBUTE10 nvarchar(150) NULL,
                          ATTRIBUTE11 nvarchar(150) NULL,
                          ATTRIBUTE12 nvarchar(150) NULL,
                          ATTRIBUTE13 nvarchar(150) NULL,
                          ATTRIBUTE14 nvarchar(150) NULL,
                          ATTRIBUTE15 nvarchar(150) NULL,
                          GROUP_ID    NVARCHAR(150) NULL
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
    -- Get Plan Mater Info
    ------------------------------------------------------------------------

    SELECT  @V_START_WEEK = CONVERT(INT,ISO_WEEK)
    FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK)
    WHERE   BASIS_YYYYMMDD = @V_PLAN_START_YYYYMMDD

    /* 
	SELECT  @V_SHIP_FROZEN = SEGMENT4
	FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
	WHERE   LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN'
	AND     VALID_YN    = 'Y'
	AND     SEGMENT1    = @V_DIVISION_ID
	AND     SEGMENT2    = @V_GROUP_ID
    --AND     SEGMENT3    = 'PR' --임시
    AND     SEGMENT3    = @V_SCP_PLAN_TYPE

    SET @V_SHIP_FROZEN_DAY = CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(@V_SHIP_FROZEN, 0), @V_SCP_PLAN_DATE ),112); 
    */
    
    ------------------------------------------------------------------------
    -- 2025.06.11 Philsu Park: FIND PROD Frozen Info.
    ------------------------------------------------------------------------
    SELECT    @V_SCP_PLAN_TYPE = PLAN_TYPE
            , @V_SCP_PLAN_DATE = PLAN_START_YYYYMMDD
    FROM    @T_SCP_PLAN

    SELECT  @V_PROD_FROZEN = CONVERT(INT, SEGMENT4)
	FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
	WHERE   LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN'
	AND     VALID_YN    = 'Y'
	AND     SEGMENT1    = @V_DIVISION_ID
	AND     SEGMENT2    = @V_GROUP_ID
    AND     SEGMENT3    = @V_SCP_PLAN_TYPE

    -- PRINT ISNULL(@V_PROD_FROZEN, 0);

    SET @V_PROD_FROZEN_DAY = CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(@V_PROD_FROZEN, 0), @V_SCP_PLAN_DATE ),112); 

    -- PRINT @V_PROD_FROZEN_DAY;
  
    ------------------------------------------------------------------------
    -- Set Param for Demand
    ------------------------------------------------------------------------
    SELECT  @MAX_TUESDAY = MAX(BASIS_YYYYMMDD)
    FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK) 
    WHERE   BASIS_YYYYMMDD <= CONVERT(NVARCHAR(8),GETDATE(),112)
    AND     DAYOFWEEK = 'TUE'

    SELECT @P_PLAN_NAME          = @V_PLAN_START_YYYYMMDD; --CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    SELECT @D_PLAN_NAME          = CONVERT(DATETIME, @P_PLAN_NAME) ;--= CONVERT(CHAR(8), DATEADD(DD, -6, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 화요일 YYYYMMDD	
	
    DECLARE @V_PLAN_START_YYYYMM NVARCHAR(6);
    DECLARE @V_PLAN_END_YYYYMM   NVARCHAR(6);
	
    SELECT @V_PLAN_START_YYYYMM = LEFT(PLAN_START_DATE,6)
            ,@V_PLAN_END_YYYYMM   = LEFT(PLAN_END_DATE,6)
    FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
    WHERE  PLAN_ID = @V_PLAN_ID;

    SELECT  @V_ROLLING_YN = ATTRIBUTE1
    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_GM_ONOFF_TEMP'
    AND     SEGMENT1 = @V_DIVISION_ID
    AND     SEGMENT2 = @V_GROUP_ID 
    AND     VALID_YN = 'Y'

    SELECT  @V_LATEST_FP_PLAN_ID = FP_PLAN_ID
                                   FROM(SELECT  TOP 1 FP_PLAN_ID
                                        FROM    BUF_AMEND_PLAN_R_XLS_SN WITH(NOLOCK)
                                        WHERE   INSTANCE_ID = 'UC_CELL_A'
                                        ORDER BY UPDATE_TIME DESC
                                        ) T

	IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
	BEGIN 
		DROP TABLE  #DIVISION;
	END;

	IF OBJECT_ID('TEMPDB..#DEMAND_VERSION') IS NOT NULL
	BEGIN 
		DROP TABLE  #DEMAND_VERSION;
	END;

	SELECT DIVISION_ID 
	INTO #DIVISION
	FROM SCM_MST_DIVISION WITH(NOLOCK)
	WHERE  VALID_YN = 'Y'
	AND    ATTRIBUTE3 <> 'EE'
	AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) -- 전극 Division 변수
	;

	-- DM Demand : Version 정의
    SELECT P.DIVISION_ID, P.CUTOFF_YYYYMMDD, MAX(P.VERSION_NO) AS VERSION_NO
	INTO #DEMAND_VERSION
    FROM   DM_PLN_NET_DEMAND P WITH(NOLOCK)
	INNER JOIN (SELECT A.DIVISION_ID, MAX(A.CUTOFF_YYYYMMDD) AS CUTOFF_YYYYMMDD
                FROM   DM_PLN_NET_DEMAND A WITH(NOLOCK)

				INNER JOIN #DIVISION D WITH(NOLOCK)
				ON A.DIVISION_ID = D.DIVISION_ID
                WHERE  1=1
                AND    A.CUTOFF_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -3, @D_PLAN_NAME), 112) -- 월요일 기준 최근 3일 이내									
                AND    A.CUTOFF_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, +6, @D_PLAN_NAME), 112) -- 해당 주차 일요일 이전
				GROUP BY A.DIVISION_ID
			) B
    ON      P.DIVISION_ID      = B.DIVISION_ID 
    AND     P.CUTOFF_YYYYMMDD  = B.CUTOFF_YYYYMMDD
	GROUP BY P.DIVISION_ID, P.CUTOFF_YYYYMMDD
    ;

	-- 2025.10.16 Philsu Park: ON, OFF 로직을 동일하게 가기 위해 STK의 수율을 적용.
    SELECT    Y.COMPANY_ID          AS COMPANY_ID
            , Y.DIVISION_ID         AS DIVISION_ID
            , Y.SITE_ID             AS SITE_ID
            , Y.PLANT_ID            AS PLANT_ID
            , Y.FACTORY_ID          AS FACTORY_ID
            , Y.LINE_ID             AS LINE_ID
            , Y.ITEM_ID             AS ITEM_ID
            , Y.MONTH               AS PLAN_YYYYMM
            , ISNULL(Y.YIELD, 1)    AS YIELD
    INTO    #YIELD
    FROM    SCM_MST_YIELD_SN Y WITH(NOLOCK)
    INNER JOIN #DIVISION D
        ON  Y.DIVISION_ID = D.DIVISION_ID
    WHERE   1=1
    AND     Y.OPERATION_ID  = 'A8000'
    AND     Y.MONTH   BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
    ;

    ------------------------------------------------------------------------
    -- Data Insert Start
    -- 2025.09.02 Philsu Park: Rolling 인 경우, 엔진결과 기반의 Demand Input 생성.
	-- 2025.10.16 Philsu Park: STK 기준으로 수율을 먹인 다음 소요량 전개.
    ------------------------------------------------------------------------
    IF @V_ROLLING_YN = 'Y'
        BEGIN
            INSERT INTO SCP_OPT_ENG_DEMAND_SN
                (PLAN_ID
                ,DEMAND_ID
                ,BUFFER_ID
                ,DEMAND_GROUP
                ,DUE_DATE
                ,TARGET_DATE
                ,SALES_CUTOFF_DATE
                ,EXPIRY_DATE
                ,PRIORITY
                ,QUANTITY
                ,PRIORITY_GROUP
                ,CUSTOMER_ID
                ,ALLOW_SHORT
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
            SELECT   DM.PLAN_ID
                    ,DM.DEMAND_ID
                    ,DM.BUFFER_ID
                    ,DM.DEMAND_GROUP
                    ,DM.DUE_DATE
                    ,DM.TARGET_DATE
                    ,DM.SALES_CUTOFF_DATE
                    ,DM.EXPIRY_DATE
                    ,DM.PRIORITY
                    ,DM.QUANTITY
                    ,DM.PRIORITY_GROUP
                    ,DM.CUSTOMER_ID
                    ,DM.ALLOW_SHORT
                    ,DM.ATTRIBUTE1
                    ,DM.ATTRIBUTE2
                    ,DM.ATTRIBUTE3
                    ,DM.ATTRIBUTE4
                    ,DM.ATTRIBUTE5
                    ,DM.ATTRIBUTE6
                    ,DM.ATTRIBUTE7
                    ,DM.ATTRIBUTE8
                    ,DM.ATTRIBUTE9
                    ,DM.ATTRIBUTE10
                    ,DM.ATTRIBUTE11
                    ,DM.ATTRIBUTE12
                    ,DM.ATTRIBUTE13
                    ,DM.ATTRIBUTE14
                    ,DM.ATTRIBUTE15
            FROM(
                SELECT   @V_PLAN_ID                                                                                         AS PLAN_ID
                        ,DM.SCM_SITE_ID+'::'+DM.CHILD_ITEM_ID+'::'+DM.STAGE+'@'+DM.INCOTERMS+'@'+PROJECT_CODE+'::'+DUE_DATE AS DEMAND_ID
                        ,DM.SCM_SITE_ID+'::'+DM.CHILD_ITEM_ID+'::'+DM.STAGE+'@'+DM.INCOTERMS+'@'+PROJECT_CODE               AS BUFFER_ID
                        ,DM.INCOTERMS+'@'+'D'+CONVERT(NVARCHAR,PRIORITY)                                                    AS DEMAND_GROUP
                        ,DM.DUE_DATE                                                                                        AS DUE_DATE
                        ,NULL                                                                                               AS TARGET_DATE
                        ,NULL                                                                                               AS SALES_CUTOFF_DATE
                        ,NULL                                                                                               AS EXPIRY_DATE
                        ,DM.PRIORITY                                                                                        AS PRIORITY
                        ,SUM(DM.QUANTITY)                                                                                   AS QUANTITY
                        ,'D'+CONVERT(NVARCHAR,PRIORITY)                                                                     AS PRIORITY_GROUP
                        ,NULL                                                                                               AS CUSTOMER_ID
                        ,NULL                                                                                               AS ALLOW_SHORT
                        ,DM.SCM_SITE_ID                                                                                     AS ATTRIBUTE1       
                        ,DM.CHILD_ITEM_ID                                                                                   AS ATTRIBUTE2
                        ,DM.STAGE                                                                                           AS ATTRIBUTE3
                        ,DM.INCOTERMS                                                                                       AS ATTRIBUTE4
                        ,DM.PROJECT_CODE                                                                                    AS ATTRIBUTE5
                        ,NULL                                                                                               AS ATTRIBUTE6
                        ,NULL                                                                                               AS ATTRIBUTE7
                        ,DM.FCST_TYPE                                                                                       AS ATTRIBUTE8
                        ,NULL                                                                                               AS ATTRIBUTE9
                        ,NULL                                                                                               AS ATTRIBUTE10
                        ,NULL                                                                                               AS ATTRIBUTE11
                        ,NULL                                                                                               AS ATTRIBUTE12
                        ,NULL                                                                                               AS ATTRIBUTE13
                        ,NULL                                                                                               AS ATTRIBUTE14
                        ,NULL                                                                                               AS ATTRIBUTE15
                FROM(
                    SELECT    ST.SCM_SITE_ID                        AS SCM_SITE_ID
                            , BM2.CHILD_ITEM_ID                     AS CHILD_ITEM_ID
                            , CONVERT(NVARCHAR, PP.PLAN_DATE, 112)  AS DUE_DATE
                            --, SUM(CONVERT(NUMERIC(20,10), PP.QTY)) * MAX(BOM.CHILD_QTY/BOM.PARENT_QTY) * MAX(BM2.CHILD_QTY/BM2.PARENT_QTY) AS QUANTITY
                            -- , PP.QTY * (BOM.CHILD_QTY/BOM.PARENT_QTY) * (BM2.CHILD_QTY/BM2.PARENT_QTY) AS QUANTITY
                            -- , PP.QTY * (BOM.CHILD_QTY/BOM.PARENT_QTY) * (BM2.CHILD_QTY/BM2.PARENT_QTY)/Y.YIELD AS QUANTITY
							, (PP.QTY/Y.YIELD) * (BOM.CHILD_QTY/BOM.PARENT_QTY) * (BM2.CHILD_QTY/BM2.PARENT_QTY) AS QUANTITY
                            , 'TARGETBIZ'                                   AS STAGE
                            , 'DAP'                                         AS INCOTERMS
                            , '-'                                           AS PROJECT_CODE
                            , 1                                             AS PRIORITY
                            , '-'                                           AS FCST_TYPE
                    FROM    BUF_AMEND_PLAN_R_XLS_SN PP WITH(NOLOCK)
                    INNER JOIN SCM_MST_BOM_ENG_SN BOM WITH(NOLOCK)
                        ON  BOM.COMPANY_ID      = PP.COMPANY_ID
                        AND BOM.DIVISION_ID     = PP.DIVISION_ID
                        AND BOM.SITE_ID         = PP.SITE_ID
                        AND BOM.PLANT_ID        = PP.PLANT_ID
                        AND BOM.PARENT_ITEM_ID  = PP.ITEM_ID
                        AND BOM.EFF_END_DATE   >= CONVERT(DATE, @V_PLAN_START_YYYYMMDD)
                        AND BOM.ACTIVE_FLAG     = 'Y'
                    INNER JOIN SCM_MST_BOM_ENG_SN BM2 WITH(NOLOCK)
                        ON  BM2.COMPANY_ID      = PP.COMPANY_ID
                        AND BM2.DIVISION_ID     = PP.DIVISION_ID
                        AND BM2.SITE_ID         = PP.SITE_ID
                        AND BM2.PLANT_ID        = PP.PLANT_ID
                        AND BM2.PARENT_ITEM_ID  = BOM.CHILD_ITEM_ID
                        AND BM2.EFF_END_DATE   >= CONVERT(DATE, @V_PLAN_START_YYYYMMDD)
                        AND BM2.ACTIVE_FLAG     = 'Y'
                    INNER JOIN SCM_ITEM_M_SN ITM WITH(NOLOCK)
                        ON  ITM.COMPANY_ID  = PP.COMPANY_ID
                        AND ITM.DIVISION_ID = PP.DIVISION_ID
                        AND ITM.SITE_ID     = PP.SITE_ID
                        AND ITM.ITEM_ID     = BM2.CHILD_ITEM_ID
                        AND ITM.ITEM_TYPE   <> 'R'
                    INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                        ON  ML.PLAN_ID = @V_PLAN_ID
                        AND ML.ITEM_ID = BM2.CHILD_ITEM_ID
                    LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)  -- SCM_SITE_ID를 찾기 위한 Join.
                        ON  ST.DIVISION_ID      = PP.DIVISION_ID
                        AND ST.COMPANY_ID       = PP.COMPANY_ID
                        AND ST.SITE_ID          = PP.SITE_ID
                        AND ST.PLANT_ID         = PP.PLANT_ID
                        AND ST.OPERATION_GROUP  = REPLACE(LEFT(OPERATION_ID, 1), 'F', 'A')
                        and ST.SITE_TYPE        = 'PLANT'
                        AND ST.VALID_YN         = 'Y'
                    LEFT OUTER JOIN #YIELD Y
                        ON  Y.COMPANY_ID    = PP.COMPANY_ID
                        AND Y.DIVISION_ID   = PP.DIVISION_ID
                        AND Y.SITE_ID       = PP.SITE_ID
                        AND Y.PLANT_ID      = PP.PLANT_ID
                        AND Y.FACTORY_ID    = PP.FACTORY_ID
                        AND Y.LINE_ID       = PP.LINE_ID
                        -- AND Y.ITEM_ID       = BM2.CHILD_ITEM_ID
						AND Y.ITEM_ID       = PP.ITEM_ID
                        AND Y.PLAN_YYYYMM   = LEFT(CONVERT(NVARCHAR, PP.PLAN_DATE, 112), 6)
                    WHERE 1=1
                    -- AND   PP.INSTANCE_ID IN ('INS_ASY_0829_T01', 'INS_ELC_0829_T01', 'INS_FOR_0829_T01')  -- 이 조건은 빼야될 것 같음..
                    AND   PP.OPERATION_ID   = 'A8000'  -- STK을 가져와서 -> LAMI -> NND로 환산해서 반영.
                    AND   PP.INSTANCE_ID    = 'UC_CELL_A'
                    AND   PP.FP_PLAN_ID     = @V_LATEST_FP_PLAN_ID
                    AND   PP.QTY            > 0
                    -- AND   CONVERT(NVARCHAR, PP.PLAN_DATE, 112) >= @V_PLAN_START_YYYYMMDD
                    -- AND   CONVERT(NVARCHAR, PP.PLAN_DATE, 112)  < @V_PLAN_END_YYYYMMDD
                    --GROUP BY ST.SCM_SITE_ID, BM2.CHILD_ITEM_ID, CONVERT(NVARCHAR, PP.PLAN_DATE, 112)
                    ) DM
                    WHERE   DM.DUE_DATE >= @V_PLAN_START_YYYYMMDD
                    AND     DM.DUE_DATE < @V_PLAN_END_YYYYMMDD
                    GROUP BY SCM_SITE_ID, CHILD_ITEM_ID, DUE_DATE, STAGE, INCOTERMS, PROJECT_CODE, PRIORITY, FCST_TYPE
                ) DM
                LEFT JOIN (
                            --SELECT  SEGMENT2   AS DIVISION_ID
                            --    ,SEGMENT3   AS SCM_SITE_ID
                            --    ,SEGMENT4   AS ITEM_ID
                            --    ,SEGMENT5   AS GROUP_ID
                            --    ,CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                            --    ELSE ATTRIBUTE2
                            --    END AS START_DATE  -- PLAN 제외 시작일자
                            --    ,CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                            --    ELSE ATTRIBUTE3
                            --    END AS END_DATE  -- PLAN 제외 끝일자
                            --FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                            --WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                            --AND    VALID_YN    = 'Y'
                            --AND    SEGMENT2    = @V_DIVISION_ID
                            --AND    SEGMENT5    = @V_GROUP_ID
                            --AND    ATTRIBUTE1  = 'ELEC' -- 전극 ITEM 제외
                            
                            -- 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환
                            SELECT  D.DIVISION_ID           AS DIVISION_ID
                                  , D.SCM_SITE_ID           AS SCM_SITE_ID
                                  , D.ITEM_ID               AS ITEM_ID
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
                                LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                                    ON  D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                    AND PG.VALID_YN = 'Y'
                            WHERE   1=1
                            AND     D.VALID_YN = 'Y'
                            AND     D.DIVISION_ID = @V_DIVISION_ID
                            AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                            ) DE
                    ON  DM.ATTRIBUTE1 = DE.SCM_SITE_ID
                    AND DM.ATTRIBUTE2 = DE.ITEM_ID
            WHERE 1=1
            AND DM.PLAN_ID       = @V_PLAN_ID
            AND (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
                OR (ISNULL(DE.ITEM_ID, '') <> '' AND (DM.DUE_DATE < DE.START_DATE OR DM.DUE_DATE > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
                )
        END
    ELSE
        BEGIN
            ------------------------------------------------------------------------
            -- 1.1 DM TEMP INSERT
            -- 양극일 경우 일반 로직, 음극일 경우 양극 RTF를 DEMAND로 넣는다.
            ------------------------------------------------------------------------
            -- IF NOT(@V_DIVISION_ID = 'EE' AND RIGHT(@V_PLAN_ID,2)='_A') -- 음극이 아닌 경우
            -- 2025.05.09 Philsu Park: 음극 분기 제거(ELSE 구문)에 따른 조건문 분기 주석 처리.
            --                         음극이든 양극이든 동일 Rule로 생성.
            -- 2025.09.11 Philsu Park: Half LAMI Demand 추가를 위해 Line 정보 Join 구문 변경.
            INSERT INTO SCP_OPT_ENG_DEMAND_SN
                (PLAN_ID
                ,DEMAND_ID
                ,BUFFER_ID
                ,DEMAND_GROUP
                ,DUE_DATE
                ,TARGET_DATE
                ,SALES_CUTOFF_DATE
                ,EXPIRY_DATE
                ,PRIORITY
                ,QUANTITY
                ,PRIORITY_GROUP
                ,CUSTOMER_ID
                ,ALLOW_SHORT
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
            SELECT   DM.PLAN_ID
                    ,DM.DEMAND_ID
                    ,DM.BUFFER_ID
                    ,DM.DEMAND_GROUP
                    ,DM.DUE_DATE
                    ,DM.TARGET_DATE
                    ,DM.SALES_CUTOFF_DATE
                    ,DM.EXPIRY_DATE
                    ,DM.PRIORITY
                    ,DM.QUANTITY
                    ,DM.PRIORITY_GROUP
                    ,DM.CUSTOMER_ID
                    ,DM.ALLOW_SHORT
                    ,DM.ATTRIBUTE1
                    ,DM.ATTRIBUTE2
                    ,DM.ATTRIBUTE3
                    ,DM.ATTRIBUTE4
                    ,DM.ATTRIBUTE5
                    ,DM.ATTRIBUTE6
                    ,DM.ATTRIBUTE7
                    ,DM.ATTRIBUTE8
                    ,DM.ATTRIBUTE9
                    ,DM.ATTRIBUTE10
                    ,DM.ATTRIBUTE11
                    ,DM.ATTRIBUTE12
                    ,DM.ATTRIBUTE13
                    ,DM.ATTRIBUTE14
                    ,DM.ATTRIBUTE15
            FROM(
                SELECT @V_PLAN_ID                                                                                         AS PLAN_ID
                    ,DM.SCM_SITE_ID+'::'+DM.CHILD_ITEM_ID+'::'+DM.STAGE+'@'+DM.INCOTERMS+'@'+PROJECT_CODE+'::'+DUE_DATE AS DEMAND_ID
                    ,DM.SCM_SITE_ID+'::'+DM.CHILD_ITEM_ID+'::'+DM.STAGE+'@'+DM.INCOTERMS+'@'+PROJECT_CODE               AS BUFFER_ID
                    ,DM.INCOTERMS+'@'+'D'+CONVERT(NVARCHAR,PRIORITY)                                                    AS DEMAND_GROUP
                    ,DM.DUE_DATE                                                                                        AS DUE_DATE
                    ,NULL                                                                                               AS TARGET_DATE
                    ,NULL                                                                                               AS SALES_CUTOFF_DATE
                    ,NULL                                                                                               AS EXPIRY_DATE
                    ,DM.PRIORITY                                                                                        AS PRIORITY
                    ,SUM(DM.QUANTITY)                                                                                   AS QUANTITY
                    ,'D'+CONVERT(NVARCHAR,PRIORITY)                                                                     AS PRIORITY_GROUP
                    ,NULL                                                                                               AS CUSTOMER_ID
                    ,NULL                                                                                               AS ALLOW_SHORT
                    ,DM.SCM_SITE_ID                                                                                     AS ATTRIBUTE1       
                    ,DM.CHILD_ITEM_ID                                                                                   AS ATTRIBUTE2
                    ,DM.STAGE                                                                                           AS ATTRIBUTE3
                    ,DM.INCOTERMS                                                                                       AS ATTRIBUTE4
                    ,DM.PROJECT_CODE                                                                                    AS ATTRIBUTE5
                    ,NULL                                                                                               AS ATTRIBUTE6
                    ,NULL                                                                                               AS ATTRIBUTE7
                    ,DM.FCST_TYPE                                                                                       AS ATTRIBUTE8
                    ,NULL                                                                                               AS ATTRIBUTE9
                    ,NULL                                                                                               AS ATTRIBUTE10
                    ,NULL                                                                                               AS ATTRIBUTE11
                    ,NULL                                                                                               AS ATTRIBUTE12
                    ,NULL                                                                                               AS ATTRIBUTE13
                    ,NULL                                                                                               AS ATTRIBUTE14
                    ,NULL                                                                                               AS ATTRIBUTE15
                FROM(
                    SELECT FP.SCM_SITE_ID                        AS SCM_SITE_ID
                        ,FP.ITEM_ID                            AS ITEM_ID
                        ,BM2.CHILD_ITEM_ID                     AS CHILD_ITEM_ID
                        ,CONVERT(NVARCHAR(8),FP.PLAN_DATE,112) AS DUE_DATE
                        -- ,FP.IN_QTY*PARENT_QTY/CHILD_QTY        AS QUANTITY
                        ,FP.IN_QTY*(BOM.CHILD_QTY/BOM.PARENT_QTY) * (BM2.CHILD_QTY/BM2.PARENT_QTY) AS QUANTITY
                        ,'TARGETBIZ'                           AS STAGE
                        ,'DAP'                                 AS INCOTERMS
                        ,'-'                                   AS PROJECT_CODE
                        ,1                                     AS PRIORITY
                        ,'-'                                   AS FCST_TYPE
                    FROM(
                        SELECT   FP.COMPANY_ID
                                ,FP.DIVISION_ID
                                ,FP.SITE_ID
                                ,FP.PLANT_ID
                                ,FP.ITEM_ID
                                ,FP.PLAN_DATE
                                ,MS.SCM_SITE_ID
                                ,SUM(FP.PLAN_IN_QTY) AS IN_QTY
                        FROM   SCM_DNM_FP_RELEASE_PLAN_V_SN FP WITH(NOLOCK)
                        INNER JOIN #DIVISION DV
                                ON  FP.DIVISION_ID = DV.DIVISION_ID
                        INNER JOIN SCM_MST_SITE MS WITH(NOLOCK) 
                            ON  DV.DIVISION_ID = MS.DIVISION_ID
                            AND FP.PLANT_ID = MS.PLANT_ID
                            AND MS.VALID_YN = 'Y'
                            AND MS.SITE_TYPE = 'PLANT'
                            --INNER JOIN SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
                            --    ON  RS.PLAN_ID = @V_PLAN_ID
                            --    AND MS.SCM_SITE_ID = RS.SITE_ID
                            --    AND FP.LINE_ID = RS.ATTRIBUTE14
                            INNER JOIN ( SELECT SITE_ID, ATTRIBUTE14
                                        FROM   SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
                                        WHERE  PLAN_ID = @V_PLAN_ID 
                                        UNION
                                        SELECT    ST.SCM_SITE_ID
                                                , T.LINE_ID
                                        FROM    SCP_OPMZ_PLAN_GR_LINE_M T WITH(NOLOCK)
                                        INNER JOIN SCP_OPMZ_PLAN_GR_M GR WITH(NOLOCK)
                                            ON  T.OPMZ_PLAN_GR_ID       = GR.OPMZ_PLAN_GR_ID
                                        INNER JOIN SCM_MST_SITE ST WITH(NOLOCK)
                                            ON  ST.DIVISION_ID      = (SELECT DIVISION_ID FROM #DIVISION)
                                            AND ST.PLANT_ID         = T.PLANT_ID
                                            AND ST.SITE_TYPE        = 'PLANT'
                                            AND ST.OPERATION_GROUP  = 'A'
                                            AND ST.VALID_YN         = 'Y'
                                        WHERE   GR.OPMZ_PLAN_GR_NAME    = @V_GROUP_ID
                                        AND     T.VALID_YN              = 'Y'
                                        AND     T.OPERATION_ID          = 'A8000')  RS 
                                ON  MS.SCM_SITE_ID = RS.SITE_ID
                                AND FP.LINE_ID = RS.ATTRIBUTE14
                            /* INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                                ON  ML.PLAN_ID = @V_PLAN_ID
                                AND MS.SCM_SITE_ID = ML.SCM_SITE_ID
                                AND FP.ITEM_ID = ML.ITEM_ID
                                AND ML.STAGE = 'TARGETBIZ' */
                        WHERE   FP.OPERATION_ID = 'A8000'
                        AND     FP.PLAN_IN_QTY != 0
                        GROUP BY FP.COMPANY_ID,FP.DIVISION_ID,FP.SITE_ID,FP.PLANT_ID,FP.ITEM_ID,FP.PLAN_DATE,MS.SCM_SITE_ID
                        /*SELECT  ML.SCM_SITE_ID
                            ,MS.SITE_ID
                            ,FP.PLANT_ID
                            ,FP.ITEM_ID
                            ,FP.PLAN_DATE
                            ,SUM(FP.PLAN_IN_QTY) AS IN_QTY
                        FROM   SCM_DNM_FP_RELEASE_PROD_PLAN_C FP WITH(NOLOCK)
                            INNER JOIN SCM_MST_SITE MS WITH(NOLOCK) 
                                ON FP.PLANT_ID = MS.PLANT_ID
                            --INNER JOIN SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
                            --    ON  RS.PLAN_ID = @V_PLAN_ID
                            --    AND MS.SCM_SITE_ID = RS.SITE_ID
                            --    AND FP.LINE_ID = RS.ATTRIBUTE14
                            /* INNER JOIN ( SELECT DISTINCT PLAN_ID, SITE_ID, ATTRIBUTE14
                                        FROM   SCP_OPT_ENG_RESOURCE_SN RS WITH(NOLOCK)
                                        WHERE  PLAN_ID = @V_PLAN_ID )  RS 
                                ON  MS.SCM_SITE_ID = RS.SITE_ID
                                AND FP.LINE_ID = RS.ATTRIBUTE14 */
                            INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                                ON  ML.PLAN_ID = @V_PLAN_ID
                                AND MS.SCM_SITE_ID = ML.SCM_SITE_ID
                                AND FP.ITEM_ID = ML.ITEM_ID
                                AND ML.STAGE = 'TARGETBIZ'
                            INNER JOIN #DIVISION DV
                                ON  FP.DIVISION_ID = DV.DIVISION_ID
                        WHERE   FP.OPERATION_ID = 'A7000'
                        AND     FP.PLAN_IN_QTY != 0
                        AND     FP.YYYYMMDD = @V_PLAN_START_YYYYMMDD
                        GROUP BY ML.SCM_SITE_ID, MS.SITE_ID, FP.ITEM_ID, FP.PLAN_DATE, FP.PLANT_ID*/

                        ) FP
                        INNER JOIN SCM_MST_BOM_ENG_SN BOM WITH(NOLOCK)
                            ON  BOM.COMPANY_ID      = FP.COMPANY_ID
                            AND BOm.DIVISION_ID     = FP.DIVISION_ID
                            AND BOM.SITE_ID         = FP.SITE_ID
                            AND BOM.PLANT_ID        = FP.PLANT_ID
                            AND BOM.PARENT_ITEM_ID  = FP.ITEM_ID
                            AND BOM.ACTIVE_FLAG     = 'Y'
                            AND BOM.EFF_END_DATE   >= @P_PLAN_NAME
                        INNER JOIN SCM_MST_BOM_ENG_SN BM2 WITH(NOLOCK)
                            ON  BM2.COMPANY_ID      = BOM.COMPANY_ID
                            AND BM2.DIVISION_ID     = BOM.DIVISION_ID
                            AND BM2.SITE_ID         = BOM.SITE_ID
                            AND BM2.PLANT_ID        = BOM.PLANT_ID
                            AND BM2.PARENT_ITEM_ID   = BOM.CHILD_ITEM_ID
                            AND BM2.ACTIVE_FLAG     = 'Y'
                            AND BM2.EFF_END_DATE   >= @P_PLAN_NAME
                        INNER JOIN SCM_ITEM_M_SN ITM WITH(NOLOCK)
                            ON  ITM.COMPANY_ID  = BM2.COMPANY_ID
                            AND ITM.DIVISION_ID = BM2.DIVISION_ID
                            AND ITM.SITE_ID     = BM2.SITE_ID
                            AND ITM.ITEM_ID     = BM2.CHILD_ITEM_ID
                            AND ITM.ITEM_TYPE  <> 'R'
                        INNER JOIN #DIVISION DV
                            ON BOM.DIVISION_ID = DV.DIVISION_ID
                        INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                            ON  ML.PLAN_ID = @V_PLAN_ID
                            AND FP.SCM_SITE_ID = ML.SCM_SITE_ID
                            AND BOM.CHILD_ITEM_ID = ML.ITEM_ID
                    ) DM
                    WHERE   DM.DUE_DATE >= @V_PLAN_START_YYYYMMDD
                    AND     DM.DUE_DATE < @V_PLAN_END_YYYYMMDD
                    GROUP BY SCM_SITE_ID, CHILD_ITEM_ID, DUE_DATE, STAGE, INCOTERMS, PROJECT_CODE, PRIORITY, FCST_TYPE
                ) DM
                LEFT JOIN (
                            --SELECT  SEGMENT2   AS DIVISION_ID
                            --      , SEGMENT3   AS SCM_SITE_ID
                            --      , SEGMENT4   AS ITEM_ID
                            --      , SEGMENT5   AS GROUP_ID
                            --      , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                            --             ELSE ATTRIBUTE2
                            --        END AS START_DATE  -- PLAN 제외 시작일자
                            --      , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                            --             ELSE ATTRIBUTE3
                            --        END AS END_DATE  -- PLAN 제외 끝일자
                            --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                            --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                            --AND     VALID_YN    = 'Y'
                            --AND     SEGMENT2    = @V_DIVISION_ID
                            --AND     SEGMENT5    = @V_GROUP_ID
                            --AND     ATTRIBUTE1  = 'ELEC' -- 전극 ITEM 제외

                            -- 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환
                            SELECT  D.DIVISION_ID           AS DIVISION_ID
                                  , D.SCM_SITE_ID           AS SCM_SITE_ID
                                  , D.ITEM_ID               AS ITEM_ID
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
                                LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                                    ON  D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                    AND PG.VALID_YN = 'Y'
                            WHERE   1=1
                            AND     D.VALID_YN = 'Y'
                            AND     D.DIVISION_ID = @V_DIVISION_ID
                            AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                            ) DE
                    ON  DM.ATTRIBUTE1 = DE.SCM_SITE_ID
                    AND DM.ATTRIBUTE2 = DE.ITEM_ID
            WHERE 1=1
            AND DM.PLAN_ID       = @V_PLAN_ID
            AND (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
                OR (ISNULL(DE.ITEM_ID, '') <> '' AND (DM.DUE_DATE < DE.START_DATE OR DM.DUE_DATE > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
                )
    END
	IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
	BEGIN 
		DROP TABLE  #DIVISION;
	END;

	IF OBJECT_ID('TEMPDB..#DEMAND_VERSION') IS NOT NULL
	BEGIN 
		DROP TABLE  #DEMAND_VERSION;
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
