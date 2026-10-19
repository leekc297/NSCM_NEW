

--EXEC PR_SCP_OPT_ENG_SR_INPUT_DEMAND 'PLAN_ID_001'
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_SR_INPUT_DEMAND]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.07 Taehyun Initial Release
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_SR_INPUT_DEMAND';
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
    DECLARE @V_SHIP_FROZEN       INT;
    DECLARE @V_SHIP_FROZEN_DAY   NVARCHAR(8) 

    DECLARE @V_PROD_FROZEN_END_YMD NVARCHAR(8);

    DECLARE @V_SCP_PLAN_DATE       NVARCHAR(8)
    DECLARE @V_SCP_PLAN_TYPE       NVARCHAR(8)
    DECLARE @V_SCP_PLAN_SEQ        NVARCHAR(8)
    DECLARE @V_CNT              INT;

    DECLARE @V_PLAN_END_YYYYMMDD_ORI	NVARCHAR(20) = CONVERT(NVARCHAR(8), DATEADD(DAY,-1,@V_PLAN_END_YYYYMMDD),112);

    DECLARE @V_SHIPMENT_SNAP_CNT INT;

    --DEMAND GROUP
    DECLARE @DM_TEMP TABLE(
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
    -- 셀 생산지 버퍼 추가
    DECLARE @CELL_PROD_SITE TABLE(
      SALES_SITE_ID NVARCHAR(200)
    , ITEM_ID       NVARCHAR(200)
    )

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

    --2025.06.19 김태현 : DEMAND에 필요한 SEMI 정보는 FROZEN 계획을 SSP로 선택하거나 SCP 다른 버전을 선택했더라도, 최신 SCP 계획을 가져오는 것이 맞음/재욱 책임님 확인 사항 
    SELECT   @V_SCP_PLAN_DATE   = A.PLAN_START_YYYYMMDD
            ,@V_SCP_PLAN_TYPE   = A.PLAN_TYPE
            ,@V_SCP_PLAN_SEQ    = A.PLAN_SEQ
    FROM  (SELECT TOP 1 DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
            FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
            WHERE  DIVISION_ID          = @V_DIVISION_ID
            AND    PLAN_START_YYYYMMDD  = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(@V_PLAN_START_YYYYMMDD, 'MON')), 112) -- 해당 주 월요일 YYYYMMDD
            ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC
            ) A

    SELECT  @V_START_WEEK = CONVERT(INT,ISO_WEEK)
    FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK)
    WHERE   BASIS_YYYYMMDD = @V_PLAN_START_YYYYMMDD

	SELECT  @V_SHIP_FROZEN = SEGMENT4
	FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
	WHERE   LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN'
	AND     VALID_YN    = 'Y'
	AND     SEGMENT1    = @V_DIVISION_ID
	AND     SEGMENT2    = @V_GROUP_ID
    --AND     SEGMENT3    = 'PR' --임시
    AND     SEGMENT3    = @V_SCP_PLAN_TYPE

	SET @V_SHIP_FROZEN_DAY = CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(@V_SHIP_FROZEN, 0), @V_SCP_PLAN_DATE ),112);

    SELECT  @V_PROD_FROZEN_END_YMD = FROZEN_END_DATE
    FROM    SCP_OPT_ENG_FROZEN_MASTER_SN M WITH(NOLOCK)
    WHERE   M.PLAN_ID  = @V_PLAN_ID
    AND     M.STAGE = 'ASSY'
    ;

    --SELECT @V_PROD_FROZEN_END_YMD = '20260427' -- 임시 테스트 값

    ------------------------------------------------------------------------
    -- Set Param for Demand
    ------------------------------------------------------------------------
    SELECT  @MAX_TUESDAY = MAX(BASIS_YYYYMMDD)
    FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK) 
    WHERE   BASIS_YYYYMMDD <= CONVERT(NVARCHAR(8),GETDATE(),112)
    AND     DAYOFWEEK = 'TUE'

    SELECT @P_PLAN_NAME          = @V_PLAN_START_YYYYMMDD; --CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    SELECT @D_PLAN_NAME          = CONVERT(DATETIME, @P_PLAN_NAME) ;--= CONVERT(CHAR(8), DATEADD(DD, -6, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 화요일 YYYYMMDD
    SELECT @V_DEMAND_CUTOFF_DAY  = ISNULL(MAX(P.CUTOFF_YYYYMMDD),@MAX_TUESDAY)
                                    --, CONVERT(CHAR(8), DATEADD(DD, -6, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) -- 당주 화요일 YYYYMMDD
                                    FROM   DM_PLN_NET_DEMAND P WITH(NOLOCK)
                                    WHERE  P.DIVISION_ID      = @V_DIVISION_ID 
                                    AND    P.CUTOFF_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -3, @D_PLAN_NAME), 112) -- 월요일 기준 최근 3일 이내									
                                    AND    P.CUTOFF_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, +6, @D_PLAN_NAME), 112) -- 해당 주차 일요일 이전
    ------------------------------------------------------------------------
    SELECT @V_DM_MAX_VERSION = MAX(P.VERSION_NO)
    FROM    DM_PLN_NET_DEMAND P WITH(NOLOCK)
    WHERE   P.DIVISION_ID      = @V_DIVISION_ID 
    AND     P.CUTOFF_YYYYMMDD  = @V_DEMAND_CUTOFF_DAY
    ------------------------------------------------------------------------
    -- 셀 생산지 버퍼 추가
    ------------------------------------------------------------------------
    INSERT INTO @CELL_PROD_SITE
    SELECT  DISTINCT
            SEGMENT3 AS SALES_SITE_ID
           ,SEGMENT4 AS ITEM_ID
    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
    WHERE   1=1
    AND     LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
    AND     SEGMENT1 = @V_DIVISION_ID
    --AND     SEGMENT2 = @V_GROUP_ID -- 2026-03-10, 그룹조건 막고 셀 생산지 버퍼 추가 + DISTINCT 처리
    ------------------------------------------------------------------------
	-- 임시
	------------------------------------------------------------------------
	--SET @P_PLAN_NAME			= '20250310'
	--SET @V_DEMAND_CUTOFF_DAY	= '20250311'
	--SET @V_DM_MAX_VERSION		= 'MF_W_20250313_V001'     --3월 2주차 고정, 임시
	--SET @V_DM_MAX_VERSION		= 'MF_W_20250311_V001'     --3월 2주차 고정, 임시
    ------------------------------------------------------------------------
    -- 2025.05.07 Philsu Park.
    -- 소형 Demand Input 분기 추가를 위한 Snapshot data count. 
    -- 1. 동 주차의 Snapshot Data가 존재하는 경우 Snapshot 사용.
    -- 2. 동 주차의 Snapshot Data가 존재하지 않는 경우 기존 Rule 적용(Shipment Plan Semi)
    ------------------------------------------------------------------------
    BEGIN
        SELECT  @V_SHIPMENT_SNAP_CNT    = COUNT(*)
        FROM    SCP_OPT_ENG_SHIPMENT_PLAN_SEMI_SNAPSHOT_SN S WITH(NOLOCK)
        WHERE   S.DIVISION_ID           = @V_DIVISION_ID
        AND     S.PLAN_START_YYYYMMDD   = @V_PLAN_START_YYYYMMDD
        ;
    END
    ------------------------------------------------------------------------
    -- Data Insert Start
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    -- 0. UI에서 수정한 수요 데이터 선 반영/김태현 선임/20250709
    ------------------------------------------------------------------------
    INSERT INTO @DM_INS_TEMP
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
    SELECT  @V_PLAN_ID
           ,AD.SCM_SITE_ID+'::'+AD.ITEM_ID+'::'+AD.STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE+'::'+DUE_DATE+'::'+'-'+'::'+FCST_TYPE+IIF(ISNULL(AD.CELL_PROD_SITE_ID,'-') = '-','','::'+AD.CELL_PROD_SITE_ID) AS DEMAND_ID
           ,AD.SCM_SITE_ID+'::'+AD.ITEM_ID+'::'+AD.STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE                                                                                                                AS BUFFER_ID
           --,SCM_SITE_ID+'::'+AD.ITEM_ID+'::'+AD.STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE+IIF(ISNULL(AD.CELL_PROD_SITE_ID,'-') = '-','','::'+AD.CELL_PROD_SITE_ID)                                       AS BUFFER_ID
           ,INCOTERMS+'@'+'D'+PRIORITY                                                 AS DEMAND_GROUP
           ,DUE_DATE                                                                   AS DUE_DATE
           ,NULL                                                                       AS TARGET_DATE
           ,NULL                                                                       AS SALES_CUTOFF_DATE
           ,NULL                                                                       AS EXPIRY_DATE
           ,PRIORITY                                                                   AS PRIORITY
           ,QTY                                                                        AS QUANTITY
           ,'D'+PRIORITY                                                               AS PRIORITY_GROUP
           ,NULL                                                                       AS CUSTOMER_ID
           ,NULL                                                                       AS ALLOW_SHORT
           ,AD.SCM_SITE_ID                                                             AS ATTRIBUTE1       
           ,AD.ITEM_ID                                                                 AS ATTRIBUTE2
           ,AD.STAGE                                                                   AS ATTRIBUTE3
           ,INCOTERMS                                                                  AS ATTRIBUTE4
           ,PROJECT_CODE                                                               AS ATTRIBUTE5
           ,NULL                                                                       AS ATTRIBUTE6
           ,NULL                                                                       AS ATTRIBUTE7
           ,FCST_TYPE                                                                  AS ATTRIBUTE8
           ,NULL                                                                       AS ATTRIBUTE9
           ,NULL                                                                       AS ATTRIBUTE10
           ,NULL                                                                       AS ATTRIBUTE11
           ,NULL                                                                       AS ATTRIBUTE12
           ,NULL                                                                       AS ATTRIBUTE13
           ,NULL                                                                       AS ATTRIBUTE14
           ,NULL                                                                       AS ATTRIBUTE15
    FROM(
        SELECT  DA.DIVISION_ID       AS DIVISION_ID       
               ,DA.PROJECT_CODE      AS PROJECT_CODE     
               ,DA.SCM_SITE_ID       AS SCM_SITE_ID      
               ,DA.ITEM_ID           AS ITEM_ID          
               ,DA.FCST_TYPE         AS FCST_TYPE        
               ,CASE WHEN ISNULL(MSE.VMI_YN, 'N' ) = 'Y' THEN 'DAP' ELSE DA.INCOTERMS END AS INCOTERMS
               ,DA.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
               ,DA.DUE_DATE          AS DUE_DATE         
               ,SUM(DA.CHG_QTY)      AS QTY     
               ,TP.PRIORITY          AS PRIORITY
               ,CASE   WHEN FI.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P9500'                 THEN 'PACKBIZ'
                       WHEN FI.OPERATION_GROUP = 'P' AND FI.FLOW_ID = 'P5500'                 THEN 'MDLEBIZ'
                       WHEN FI.OPERATION_GROUP = 'P' AND FI.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ'
                       WHEN FI.OPERATION_GROUP = 'A'                                          THEN 'CELLBIZ' 
                ELSE '-' END AS STAGE
        FROM    SCP_OPMZ_DMD_ADJ DA WITH(NOLOCK)
            INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                        FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                        WHERE  DIVISION_ID = @V_DIVISION_ID  
        				AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                                 OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                              )
                       ) FI
                ON    DA.ITEM_ID     = FI.ITEM_ID
                AND   DA.DIVISION_ID = FI.DIVISION_ID 
            ------------------------------------------------------------------------
            LEFT JOIN ( -- VMI 대상 SITE 조회
                        SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN 
                        FROM   SCM_MST_SITE  WITH (NOLOCK)
                        WHERE  DIVISION_ID = @V_DIVISION_ID 
                            AND SITE_TYPE   = 'SALES'
                            AND  VALID_YN    = 'Y'
                            AND  VMI_YN      = 'Y'
                        ) MSE
                ON   DA.DIVISION_ID      = MSE.DIVISION_ID
                AND  DA.SCM_SITE_ID      = MSE.SCM_SITE_ID 
            LEFT OUTER JOIN ( --TOSITE PRIORITY CONSTRAINT
                                --SELECT   SEGMENT4   AS ITEM_ID
                                --        ,SEGMENT5   AS TO_SITE
                                --        ,SEGMENT6   AS PRIORITY
                                --        ,ATTRIBUTE1 AS FROM_DATE
                                --        ,ATTRIBUTE2 AS TO_DATE
                                --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW'
                                --AND     SEGMENT2    = @V_DIVISION_ID
                                --AND     SEGMENT3    = @V_GROUP_ID
                                --AND     VALID_YN    = 'Y'

                                -- 2025.11.18 Minyong Lee : Sales Site Priority Lookup -> UI 전환
                                SELECT  P.ITEM_ID       AS ITEM_ID
                                      , P.SCM_SITE_ID   AS TO_SITE
                                      , CONVERT(NVARCHAR,P.PRIO_RANK)     AS PRIORITY
                                      , FROM_YYYYMMDD   AS FROM_DATE
                                      , TO_YYYYMMDD     AS TO_DATE
                                FROM    SCP_OPMZ_SALES_SITE_PRIORITY P WITH(NOLOCK)
                                    LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                                        ON  P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                        AND PG.VALID_YN = 'Y'
                                WHERE   1=1
                                AND     P.VALID_YN = 'Y'
                                AND     P.DIVISION_ID = @V_DIVISION_ID
                                AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                            ) TP
                ON  DA.SCM_SITE_ID = TP.TO_SITE
                AND DA.ITEM_ID     = TP.ITEM_ID
                AND DA.DUE_DATE BETWEEN TP.FROM_DATE AND TP.TO_DATE
            
        WHERE   1=2 -- 2026-03-10, 제약제거
        AND     DA.VERSION_NO      = @V_DM_MAX_VERSION
        AND     DA.DIVISION_ID     = @V_DIVISION_ID
        AND     DA.CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY
        AND     DA.DUE_DATE        >= @P_PLAN_NAME
        AND     DA.DUE_DATE        <  @V_PLAN_END_YYYYMMDD
        AND     DA.CHG_QTY         >= 0
        AND (   (@V_DIVISION_ID = '40' 
                                       --상현 책임님 요청으로 SALES SITE는 MEDEL LIST를 고려하지 않도록 수정/20250526/김태현선임
                                       --AND CONCAT(A.SCM_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID)
                                       --                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                       --                                        WHERE   PLAN_ID = @V_PLAN_ID 
                                       --                                       )
                                       AND CONCAT(DA.CELL_PROD_SITE_ID,DA.ITEM_ID) IN (SELECT DISTINCT CONCAT(SCM_SITE_ID,ITEM_ID)
                                                                                     FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
                                                                                     WHERE   PLAN_ID = @V_PLAN_ID
                                                                                     )
                )
             OR (@V_DIVISION_ID != '40' AND  DA.ITEM_ID IN (SELECT DISTINCT ITEM_ID 
                                                           FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                           WHERE   PLAN_ID = @V_PLAN_ID
                                                          )
                )
           )
        GROUP BY DA.DIVISION_ID, DA.SCM_SITE_ID, DA.ITEM_ID, DA.INCOTERMS, DA.DUE_DATE, FI.FLOW_ID, FI.OPERATION_GROUP, TP.PRIORITY, DA.FCST_TYPE, DA.PROJECT_CODE, DA.CELL_PROD_SITE_ID, MSE.VMI_YN
        )AD
            LEFT OUTER JOIN @CELL_PROD_SITE CPS 
                ON  1=1
                AND AD.SCM_SITE_ID = CPS.SALES_SITE_ID
                AND AD.ITEM_ID     = CPS.ITEM_ID
            ------------------------------------------------------------------------
            -- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
            -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
            -- 2025.11.10 Minyong Lee : 소형 Demand 제외 조건에 Stage 추가 적용을 위한 JOIN Depth 변경
            ------------------------------------------------------------------------
            LEFT JOIN (
                      --SELECT SEGMENT2   AS DIVISION_ID
                      --     , SEGMENT3   AS SCM_SITE_ID
                      --     , SEGMENT4   AS ITEM_ID
                      --     , SEGMENT5   AS GROUP_ID
                      --     , ATTRIBUTE1 AS STAGE
                      --     , CASE
                      --           WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                      --           ELSE ATTRIBUTE2
                      --       END AS START_DATE  -- PLAN 제외 시작일자
                      --     , CASE
                      --           WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                      --           ELSE ATTRIBUTE3
                      --       END AS END_DATE  -- PLAN 제외 끝일자
                      --FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                      --WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                      --AND    VALID_YN    = 'Y'
                      --AND    SEGMENT2    = @V_DIVISION_ID
                      --AND    SEGMENT5    = @V_GROUP_ID

                        -- 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환
                        SELECT  D.DIVISION_ID           AS DIVISION_ID
                              , D.SCM_SITE_ID           AS SCM_SITE_ID
                              , D.ITEM_ID               AS ITEM_ID
                              , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                              , D.STAGE                 AS STAGE
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
                ON  AD.SCM_SITE_ID   = DE.SCM_SITE_ID
                AND AD.ITEM_ID       = DE.ITEM_ID
                AND ((AD.DIVISION_ID = '40' AND AD.STAGE = DE.STAGE) OR  -- 소형의 경우 JOIN 조건에 STAGE까지 고려
                     AD.DIVISION_ID <> '40')
        -- DEMAND 제외 대상 처리
        WHERE   1=1
        AND     (ISNULL(DE.ITEM_ID, '') = '' OR                                                                 -- 수요 제외 대상이 아니거나
                 (ISNULL(DE.ITEM_ID, '') <> '' AND (AD.DUE_DATE < DE.START_DATE OR AD.DUE_DATE > DE.END_DATE))) -- 수요 제외 대상이어도 기간 범위 밖인 것
    ------------------------------------------------------------------------
    -- 1. DM Demand Insert
    -- 2025.09.30 Philsu Park: 워크벤치 반영 재고와 동일 DEMAND_ID는 제외(@DM_INS_TEMP)
    ------------------------------------------------------------------------
    INSERT INTO @DM_INS_TEMP
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
    FROM    (
            SELECT  @V_PLAN_ID                                                                 AS PLAN_ID
                  , DEMAND.SCM_SITE_ID+'::'+DEMAND.ITEM_ID+'::'+DEMAND.STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE+'::'+DUE_DATE+'::'+'-'+'::'+FCST_TYPE+IIF(ISNULL(DEMAND.CELL_PROD_SITE_ID,'-') = '-','','::'+DEMAND.CELL_PROD_SITE_ID) AS DEMAND_ID
                  , DEMAND.SCM_SITE_ID+'::'+DEMAND.ITEM_ID+'::'+DEMAND.STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE                                                                                                                        AS BUFFER_ID
                  , INCOTERMS+'@'+'D'+PRIORITY                                                 AS DEMAND_GROUP
                  , DEMAND.DUE_DATE                                                                   AS DUE_DATE
                  , NULL                                                                       AS TARGET_DATE
                  , NULL                                                                       AS SALES_CUTOFF_DATE
                  , NULL                                                                       AS EXPIRY_DATE
                  , PRIORITY                                                                   AS PRIORITY
                  , QUANTITY                                                                   AS QUANTITY
                  , 'D'+PRIORITY                                                               AS PRIORITY_GROUP
                  , NULL                                                                       AS CUSTOMER_ID
                  , NULL                                                                       AS ALLOW_SHORT
                  , DEMAND.SCM_SITE_ID                                                         AS ATTRIBUTE1       
                  , DEMAND.ITEM_ID                                                             AS ATTRIBUTE2
                  , DEMAND.STAGE                                                               AS ATTRIBUTE3
                  , INCOTERMS                                                                  AS ATTRIBUTE4
                  , PROJECT_CODE                                                               AS ATTRIBUTE5
                  , NULL                                                                       AS ATTRIBUTE6
                  , NULL                                                                       AS ATTRIBUTE7
                  , FCST_TYPE                                                                  AS ATTRIBUTE8
                  , NULL                                                                       AS ATTRIBUTE9
                  , NULL                                                                       AS ATTRIBUTE10
                  , NULL                                                                       AS ATTRIBUTE11
                  , NULL                                                                       AS ATTRIBUTE12
                  , NULL                                                                       AS ATTRIBUTE13
                  , NULL                                                                       AS ATTRIBUTE14
                  , NULL                                                                       AS ATTRIBUTE15
            FROM   (
                   SELECT  A.DIVISION_ID  AS DIVISION_ID
                         , A.SCM_SITE_ID  AS SCM_SITE_ID
                         , A.ITEM_ID      AS ITEM_ID
                         , CASE
                               WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'        THEN 'PACKBIZ'
                               WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'        THEN 'MDLEBIZ'
                               WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ'
                               WHEN B.OPERATION_GROUP = 'A'    THEN 'CELLBIZ' 
                           ELSE '-' END                                                               AS STAGE
                         , CASE WHEN ISNULL(MSE.VMI_YN, 'N' ) = 'Y' THEN 'DAP' ELSE A.INCOTERMS END   AS INCOTERMS
                         , A.ATTRIBUTE1                                                                 AS DUE_DATE
                         , SUM(A.QTY)                                                                   AS QUANTITY
                         , TP.PRIORITY                                                                  AS PRIORITY
                         , A.FCST_TYPE                                                                  AS FCST_TYPE
                         , A.PROJECT_CODE                                                               AS PROJECT_CODE
                         , A.CELL_PROD_SITE_ID                                                          AS CELL_PROD_SITE_ID
                   FROM DM_PLN_NET_DEMAND A WITH (NOLOCK)
                   ------------------------------------------------------------------------
                       INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                   FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                                   WHERE  DIVISION_ID = @V_DIVISION_ID  
                                   AND    OPERATION_GROUP IN ('A', 'P') -- ADDED 2026-03-10
	    				        --BLOCKED 2026-03-10
                                --AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                                --      OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                                --         )
                                  ) B
                           ON    A.ITEM_ID     = B.ITEM_ID
                           AND   A.DIVISION_ID = B.DIVISION_ID 
                   ------------------------------------------------------------------------
                       LEFT JOIN ( -- VMI 대상 SITE 조회
                                   SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN 
                                   FROM   SCM_MST_SITE  WITH (NOLOCK)
                                   WHERE  DIVISION_ID = @V_DIVISION_ID 
                                       AND SITE_TYPE   = 'SALES'
                                       AND  VALID_YN    = 'Y'
                                       AND  VMI_YN      = 'Y'
                                   ) MSE
                           ON   A.DIVISION_ID      = MSE.DIVISION_ID
                           AND  A.SCM_SITE_ID      = MSE.SCM_SITE_ID 
                   ------------------------------------------------------------------------
                       LEFT OUTER JOIN ( --TOSITE PRIORITY CONSTRAINT
                                       --SELECT   SEGMENT4   AS ITEM_ID
                                       --        ,SEGMENT5   AS TO_SITE
                                       --        ,SEGMENT6   AS PRIORITY
                                       --        ,ATTRIBUTE1 AS FROM_DATE
                                       --        ,ATTRIBUTE2 AS TO_DATE
                                       --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                       --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW'
                                       --AND     SEGMENT2    = @V_DIVISION_ID
                                       --AND     SEGMENT3    = @V_GROUP_ID
                                       --AND     VALID_YN    = 'Y'

                                        -- 2025.11.18 Minyong Lee : Sales Site Priority Lookup -> UI 전환
                                        SELECT  P.ITEM_ID       AS ITEM_ID
                                              , P.SCM_SITE_ID   AS TO_SITE
                                              , CONVERT(NVARCHAR,P.PRIO_RANK)     AS PRIORITY
                                              , FROM_YYYYMMDD   AS FROM_DATE
                                              , TO_YYYYMMDD     AS TO_DATE
                                        FROM    SCP_OPMZ_SALES_SITE_PRIORITY P WITH(NOLOCK)
                                            LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                                                ON  P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                                AND PG.VALID_YN = 'Y'
                                        WHERE   1=1
                                        AND     P.VALID_YN = 'Y'
                                        AND     P.DIVISION_ID = @V_DIVISION_ID
                                        AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                                       ) TP
                           ON  A.SCM_SITE_ID = TP.TO_SITE
                           AND A.ITEM_ID     = TP.ITEM_ID
                           AND A.ATTRIBUTE1 BETWEEN TP.FROM_DATE AND TP.TO_DATE
                   WHERE   A.DIVISION_ID     =  @V_DIVISION_ID
                   AND     A.CUTOFF_YYYYMMDD   =  @V_DEMAND_CUTOFF_DAY
                   AND     A.VERSION_NO        =  @V_DM_MAX_VERSION
                   AND     A.ATTRIBUTE1        >= @P_PLAN_NAME
                   AND     A.ATTRIBUTE1        <  @V_PLAN_END_YYYYMMDD
                   AND     A.QTY               >  0
                   -- comment2: 소형 생산지 구분 로직 블럭에 따른 추가
                   AND     A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
                                          FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                          WHERE  PLAN_ID = @V_PLAN_ID
                                        )
                   --소형 생산지 구분을 위한 분리
                   -- comment: 소형 생산지 사이트 구분 로직은 유지
                   -- comment2: 소형 생산지 구분 로직으로 PACK, MDL Demand 누락됨 ---- CELL_PROD_SITE_ID 는 ASSY(%-A) 사이트만 존재
                   /*AND ((@V_DIVISION_ID = '40'
                                                  --상현 책임님 요청으로 SALES SITE는 MEDEL LIST를 고려하지 않도록 수정/20250526/김태현선임
                                                  --AND CONCAT(A.SCM_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID)
                                                  --                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                  --                                        WHERE   PLAN_ID = @V_PLAN_ID 
                                                  --                                       )
                                                  AND CONCAT(A.CELL_PROD_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT(SCM_SITE_ID,ITEM_ID)
                                                                                                FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
                                                                                                WHERE   PLAN_ID = @V_PLAN_ID
                                                                                                )
                        )
                        OR (@V_DIVISION_ID != '40' AND  A.ITEM_ID IN (SELECT DISTINCT ITEM_ID 
                                                          FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                          WHERE   PLAN_ID = @V_PLAN_ID
                                                         )
                       )
                   ) */
                   --------------------------
                   GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, MSE.VMI_YN, A.INCOTERMS, A.ATTRIBUTE1
                          , B.FLOW_ID, B.OPERATION_GROUP, TP.PRIORITY, A.FCST_TYPE,A.PROJECT_CODE,A.CELL_PROD_SITE_ID
                   ) DEMAND
                LEFT OUTER JOIN @CELL_PROD_SITE CPS 
                    ON  1=1
                    AND DEMAND.SCM_SITE_ID = CPS.SALES_SITE_ID
                    AND DEMAND.ITEM_ID     = CPS.ITEM_ID
                ------------------------------------------------------------------------
                -- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
                -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
                -- 2025.11.10 Minyong Lee : 소형 Demand 제외 조건에 Stage 추가 적용을 위한 JOIN Depth 변경
                ------------------------------------------------------------------------
                LEFT JOIN   (
                            --SELECT  SEGMENT2   AS DIVISION_ID
                            --      , SEGMENT3   AS SCM_SITE_ID
                            --      , SEGMENT4   AS ITEM_ID
                            --      , SEGMENT5   AS GROUP_ID
                            --      , ATTRIBUTE1 AS STAGE
                            --      , CASE
                            --            WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                            --            ELSE ATTRIBUTE2
                            --        END AS START_DATE  -- PLAN 제외 시작일자
                            --      , CASE
                            --            WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                            --            ELSE ATTRIBUTE3
                            --        END AS END_DATE  -- PLAN 제외 끝일자
                            --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                            --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                            --AND     VALID_YN    = 'Y'
                            --AND     SEGMENT2    = @V_DIVISION_ID
                            --AND     SEGMENT5    = @V_GROUP_ID

                            -- 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환
                            SELECT  D.DIVISION_ID           AS DIVISION_ID
                                  , D.SCM_SITE_ID           AS SCM_SITE_ID
                                  , D.ITEM_ID               AS ITEM_ID
                                  , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                                  , D.STAGE                 AS STAGE
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
                    ON  DEMAND.SCM_SITE_ID   = DE.SCM_SITE_ID
                    AND DEMAND.ITEM_ID       = DE.ITEM_ID
                    AND ((DEMAND.DIVISION_ID = '40' AND DEMAND.STAGE = DE.STAGE) OR  -- 소형의 경우 JOIN 조건에 STAGE까지 고려
                         DEMAND.DIVISION_ID <> '40')
            -- DEMAND 제외 대상 처리
            WHERE   1=1
            AND     (ISNULL(DE.ITEM_ID, '') = '' OR                                                                         -- 수요 제외 대상이 아니거나
                     (ISNULL(DE.ITEM_ID, '') <> '' AND (DEMAND.DUE_DATE < DE.START_DATE OR DEMAND.DUE_DATE > DE.END_DATE))) -- 수요 제외 대상이어도 기간 범위 밖인 것
            ) AS DM
        LEFT OUTER JOIN @DM_INS_TEMP DT
            ON  DM.PLAN_ID = DT.PLAN_ID
            AND DM.DEMAND_ID = DT.DEMAND_ID
    WHERE DT.PLAN_ID IS NULL
    ------------------------------------------------------------------------
    -- 2. Shipment Plan Semi => Demand Insert : 소형 - Cell Plant 의 CHAR Stage에 Demand 처리
    -- 2025.05.07 Philsu Park: SHIPTMENT_SNAPSHOT_COUNT > 0 일 때는 해당 데이터 사용, 아닐때는 기존 로직으로 분기.
    ------------------------------------------------------------------------
    IF @V_DIVISION_ID = 'XX' -- '40' -- 2026-03-10, 소형 특화제거 --소형은 외주 Packer 이후부터는 계획을 수립하지 않으며 CHAR 출하계획(OR 출하계획스넵샷->엔진수행시 계획이 바뀌니 사용자가 수립한 계획을 화면에서 별도 스넵샷한 것) 기준 DEMAND 생성하는 부분으로 SHIP REQ용으로는 불필요
        IF @V_SHIPMENT_SNAP_CNT > 0
            BEGIN
                INSERT INTO @DM_INS_TEMP
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
                SELECT   @V_PLAN_ID
                        ,DEMAND.SCM_SITE_ID+'::'+DEMAND.ITEM_ID+'::'+DEMAND.STAGE+'::'+DUE_DATE+'::'+TO_SITE+'::'+INCOTERMS+'::'+TRANSPORT_MODE+'::'+'REQ' AS DEMAND_ID
                        ,DEMAND.SCM_SITE_ID+'::'+DEMAND.ITEM_ID+'::'+DEMAND.STAGE             AS BUFFER_ID
                        --,TO_SITE                                                            AS DEMAND_GROUP
                        -- Ship Frozen 내인 경우 'SF'
                        ,CASE WHEN SHIP_FROZEN = 'Y' THEN 'SF'
                            ELSE IIF(ISNULL(PRIORITY, '') = '', NULL, 'D'+PRIORITY)
                         END                                                                 AS DEMAND_GROUP
                        ,DEMAND.DUE_DATE                                                     AS DUE_DATE
                        ,NULL                                                                AS TARGET_DATE
                        ,NULL                                                                AS SALES_CUTOFF_DATE
                        ,NULL                                                                AS EXPIRY_DATE
                        ,PRIORITY                                                            AS PRIORITY
                        -- Ship Frozen 내인 경우 ''
                        --,CASE WHEN SHIP_FROZEN = 'Y' THEN ''
                        --      ELSE NULL
                        -- END                                                                AS PRIORITY
                        ,QUANTITY                                                            AS QUANTITY
                        --,NULL                                                               AS PRIORITY_GROUP
                        -- Ship Frozen 내인 경우 'SF'
                        ,CASE WHEN SHIP_FROZEN = 'Y' THEN 'SF'
                            ELSE IIF(ISNULL(PRIORITY, '') = '', NULL, 'D'+PRIORITY)
                        END                                                                 AS PRIORITY_GROUP
                        ,NULL                                                               AS CUSTOMER_ID
                        ,NULL                                                               AS ALLOW_SHORT
                        ,DEMAND.SCM_SITE_ID                                                 AS ATTRIBUTE1       
                        ,DEMAND.ITEM_ID                                                     AS ATTRIBUTE2
                        ,DEMAND.STAGE                                                       AS ATTRIBUTE3
                        ,INCOTERMS                                                          AS ATTRIBUTE4
                        ,NULL                                                               AS ATTRIBUTE5
                        ,TO_SITE                                                            AS ATTRIBUTE6
                        ,TRANSPORT_MODE                                                     AS ATTRIBUTE7
                        ,NULL                                                               AS ATTRIBUTE8
                        ,NULL                                                               AS ATTRIBUTE9
                        ,NULL                                                               AS ATTRIBUTE10
                        ,NULL                                                               AS ATTRIBUTE11
                        ,NULL                                                               AS ATTRIBUTE12
                        ,NULL                                                               AS ATTRIBUTE13
                        ,NULL                                                               AS ATTRIBUTE14
                        ,'SNAPSHOT'                                                         AS ATTRIBUTE15  --Snapshot 사용 마킹.
                FROM    (
                        SELECT  A.DIVISION_ID          AS DIVISION_ID
                               ,A.FROM_SITE            AS SCM_SITE_ID
                               ,A.TO_SITE              AS TO_SITE
                               ,A.ITEM_ID              AS ITEM_ID
                               ,'CHAR'                 AS STAGE
                               --,'EXW'          AS INCOTERMS
                               ,BOD.INCOTERMS          AS INCOTERMS
                               ,BOD.TRANSPORT_MODE     AS TRANSPORT_MODE
                               ,A.YYYYMMDD             AS DUE_DATE  
                               ,CASE WHEN A.YYYYMMDD < @V_SHIP_FROZEN_DAY THEN 'Y'
                                     ELSE 'N'
                                     END               AS SHIP_FROZEN
                               ,SUM(A.QTY)             AS QUANTITY
                               ,TP.PRIORITY            AS PRIORITY
                        FROM    SCP_OPT_ENG_SHIPMENT_PLAN_SEMI_SNAPSHOT_SN A WITH (NOLOCK)
                            ------------------------------------------------------------------------
                            INNER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID
                                        FROM   SCM_MST_SITE WITH(NOLOCK) 
                                        WHERE  DIVISION_ID     = @V_DIVISION_ID
                                        AND    SITE_TYPE       = 'PLANT'     
                                        AND    OPERATION_GROUP = 'A' -- 소형은 Cell 출하를 CEll Biz 용 Demand 만 처리
                                        AND    VALID_YN        = 'Y'
                                    ) B
                                ON    A.FROM_SITE   = B.SCM_SITE_ID
                                AND   A.DIVISION_ID = B.DIVISION_ID
                            ------------------------------------------------------------------------
                            INNER JOIN SCP_MST_BOD_N_V BOD WITH(NOLOCK)
                                ON    A.DIVISION_ID = BOD.DIVISION_ID
                                AND   A.BOD_ID      = BOD.BOD_ID
                            ------------------------------------------------------------------------
                            -- 2025.07.15 Philsu Park: 소형 Shipment SEMI 에도 Priority 값 반영.
                            ------------------------------------------------------------------------
                            LEFT OUTER JOIN ( --TOSITE PRIORITY CONSTRAINT
                                            --SELECT   SEGMENT4   AS ITEM_ID
                                            --        ,SEGMENT5   AS TO_SITE
                                            --        ,SEGMENT6   AS PRIORITY
                                            --        ,ATTRIBUTE1 AS FROM_DATE
                                            --        ,ATTRIBUTE2 AS TO_DATE
                                            --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                            --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW'
                                            --AND     SEGMENT2    = @V_DIVISION_ID
                                            --AND     SEGMENT3    = @V_GROUP_ID
                                            --AND     VALID_YN    = 'Y'

                                            -- 2025.11.18 Minyong Lee : Sales Site Priority Lookup -> UI 전환
                                            SELECT  P.ITEM_ID       AS ITEM_ID
                                                  , P.SCM_SITE_ID   AS TO_SITE
												  , CONVERT(NVARCHAR,P.PRIO_RANK)     AS PRIORITY
                                                  , FROM_YYYYMMDD   AS FROM_DATE
                                                  , TO_YYYYMMDD     AS TO_DATE
                                            FROM    SCP_OPMZ_SALES_SITE_PRIORITY P WITH(NOLOCK)
                                                LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                                                    ON  P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                                    AND PG.VALID_YN = 'Y'
                                            WHERE   1=1
                                            AND     P.VALID_YN = 'Y'
                                            AND     P.DIVISION_ID = @V_DIVISION_ID
                                            AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                                            ) TP
                                ON  A.FROM_SITE     = TP.TO_SITE
                                AND A.ITEM_ID       = TP.ITEM_ID
                                AND A.YYYYMMDD BETWEEN TP.FROM_DATE AND TP.TO_DATE
                        ------------------------------------------------------------------------
                        WHERE   A.DIVISION_ID           = @V_DIVISION_ID
                        AND     A.plan_start_yyyymmdd   = @V_SCP_PLAN_DATE
                        -- AND   A.plan_type           = @V_SCP_PLAN_TYPE 
                        -- AND   A.seq                 = @V_SCP_PLAN_SEQ  
                        AND     A.measure               = 'SHIP_PLAN_AMEND'
                        AND     A.QTY                   > 0
                        AND     A.YYYYMMDD             >= @P_PLAN_NAME
                        AND     A.YYYYMMDD              < @V_PLAN_END_YYYYMMDD
                        AND     A.ITEM_ID              IN ( SELECT  DISTINCT ITEM_ID 
                                                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                            WHERE   PLAN_ID = @V_PLAN_ID
                                                            )
                        GROUP BY A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, A.ITEM_ID, A.YYYYMMDD, BOD.INCOTERMS, BOD.TRANSPORT_MODE, TP.PRIORITY
                        ) DEMAND
                    ------------------------------------------------------------------------
                    -- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
                    -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
                    -- 2025.11.10 Minyong Lee : 소형 Demand 제외 조건에 Stage 추가 적용에 따른 JOIN Depth 변경
                    ------------------------------------------------------------------------
                    LEFT JOIN   (
                                --SELECT  SEGMENT2   AS DIVISION_ID
                                --      , SEGMENT3   AS SCM_SITE_ID
                                --      , SEGMENT4   AS ITEM_ID
                                --      , SEGMENT5   AS GROUP_ID
                                --      , ATTRIBUTE1 AS STAGE
                                --      , CASE
                                --            WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                                --            ELSE ATTRIBUTE2
                                --        END AS START_DATE  -- PLAN 제외 시작일자
                                --      , CASE
                                --            WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                                --            ELSE ATTRIBUTE3
                                --        END AS END_DATE  -- PLAN 제외 끝일자
                                --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                                --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                                --AND     VALID_YN    = 'Y'
                                --AND     SEGMENT2    = @V_DIVISION_ID
                                --AND     SEGMENT5    = @V_GROUP_ID

                                -- 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환
                                SELECT  D.DIVISION_ID           AS DIVISION_ID
                                      , D.SCM_SITE_ID           AS SCM_SITE_ID
                                      , D.ITEM_ID               AS ITEM_ID
                                      , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                                      , D.STAGE                 AS STAGE
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
                        ON  DEMAND.SCM_SITE_ID   = DE.SCM_SITE_ID
                        AND DEMAND.ITEM_ID       = DE.ITEM_ID
                        AND ((DEMAND.DIVISION_ID = '40' AND DEMAND.STAGE = DE.STAGE) OR  -- 소형의 경우 JOIN 조건에 STAGE까지 고려
                             DEMAND.DIVISION_ID <> '40')
                -- DEMAND 제외 대상 처리
                WHERE   1=1
                AND     (ISNULL(DE.ITEM_ID, '') = '' OR                                                                         -- 수요 제외 대상이 아니거나
                         (ISNULL(DE.ITEM_ID, '') <> '' AND (DEMAND.DUE_DATE < DE.START_DATE OR DEMAND.DUE_DATE > DE.END_DATE))) -- 수요 제외 대상이어도 기간 범위 밖인 것
            END
        ELSE 
            BEGIN 

                INSERT INTO @DM_INS_TEMP
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
                SELECT   @V_PLAN_ID
                        ,DEMAND.SCM_SITE_ID+'::'+DEMAND.ITEM_ID+'::'+DEMAND.STAGE+'::'+DEMAND.DUE_DATE+'::'+TO_SITE+'::'+INCOTERMS+'::'+TRANSPORT_MODE+'::'+'REQ' AS DEMAND_ID
                        ,DEMAND.SCM_SITE_ID+'::'+DEMAND.ITEM_ID+'::'+DEMAND.STAGE                                AS BUFFER_ID
                        --,TO_SITE                                                            AS DEMAND_GROUP
                        -- Ship Frozen 내인 경우 'SF'
                        ,CASE WHEN SHIP_FROZEN = 'Y' THEN 'SF'
                            ELSE IIF(ISNULL(PRIORITY, '') = '', NULL, 'D'+PRIORITY)
                        END                                                                AS DEMAND_GROUP
                        ,DEMAND.DUE_DATE                                                    AS DUE_DATE
                        ,NULL                                                               AS TARGET_DATE
                        ,NULL                                                               AS SALES_CUTOFF_DATE
                        ,NULL                                                               AS EXPIRY_DATE
                        ,PRIORITY                                                           AS PRIORITY
                        -- Ship Frozen 내인 경우 ''
                        --,CASE WHEN SHIP_FROZEN = 'Y' THEN ''
                        --      ELSE NULL
                        -- END                                                                AS PRIORITY
                        ,QUANTITY                                                           AS QUANTITY
                        --,NULL                                                               AS PRIORITY_GROUP
                        -- Ship Frozen 내인 경우 'SF'
                        ,CASE WHEN SHIP_FROZEN = 'Y' THEN 'SF'
                            ELSE IIF(ISNULL(PRIORITY, '') = '', NULL, 'D'+PRIORITY)
                        END                                                                AS PRIORITY_GROUP
                        ,NULL                                                               AS CUSTOMER_ID
                        ,NULL                                                               AS ALLOW_SHORT
                        ,DEMAND.SCM_SITE_ID                                                 AS ATTRIBUTE1       
                        ,DEMAND.ITEM_ID                                                     AS ATTRIBUTE2
                        ,DEMAND.STAGE                                                       AS ATTRIBUTE3
                        ,INCOTERMS                                                          AS ATTRIBUTE4
                        ,NULL                                                               AS ATTRIBUTE5
                        ,TO_SITE                                                            AS ATTRIBUTE6
                        ,TRANSPORT_MODE                                                     AS ATTRIBUTE7
                        ,NULL                                                               AS ATTRIBUTE8
                        ,NULL                                                               AS ATTRIBUTE9
                        ,NULL                                                               AS ATTRIBUTE10
                        ,NULL                                                               AS ATTRIBUTE11
                        ,NULL                                                               AS ATTRIBUTE12
                        ,NULL                                                               AS ATTRIBUTE13
                        ,NULL                                                               AS ATTRIBUTE14
                        ,NULL                                                               AS ATTRIBUTE15
                FROM   (
                        SELECT A.DIVISION_ID        AS DIVISION_ID
                            ,A.FROM_SITE            AS SCM_SITE_ID
                            ,A.TO_SITE              AS TO_SITE
                            ,A.ITEM_ID              AS ITEM_ID
                            ,'CHAR'                 AS STAGE
                            --,'EXW'          AS INCOTERMS
                            ,BOD.INCOTERMS          AS INCOTERMS
                            ,BOD.TRANSPORT_MODE     AS TRANSPORT_MODE
                            ,A.YYYYMMDD             AS DUE_DATE  
                            ,CASE WHEN A.YYYYMMDD < @V_SHIP_FROZEN_DAY THEN 'Y'
                                  ELSE 'N'
                                  END               AS SHIP_FROZEN
                            ,SUM(A.QTY)             AS QUANTITY
                            ,TP.PRIORITY            AS PRIORITY
                        FROM SCP_ANL_SHIPMENT_PLAN_SEMI A WITH (NOLOCK)
                            ------------------------------------------------------------------------
                            INNER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID
                                        FROM   SCM_MST_SITE WITH (NOLOCK) 
                                        WHERE  DIVISION_ID     = @V_DIVISION_ID
                                        AND    SITE_TYPE       = 'PLANT'     
                                        AND    OPERATION_GROUP = 'A' -- 소형은 Cell 출하를 CEll Biz 용 Demand 만 처리
                                        AND    VALID_YN        = 'Y'

                                    ) B
                                ON    A.FROM_SITE   = B.SCM_SITE_ID
                                AND   A.DIVISION_ID = B.DIVISION_ID 
                            ------------------------------------------------------------------------
                            INNER JOIN SCP_MST_BOD_N_V BOD WITH (NOLOCK)
                                ON    A.DIVISION_ID = BOD.DIVISION_ID
                                AND   A.BOD_ID      = BOD.BOD_ID
                            ------------------------------------------------------------------------
                            -- 2025.07.15 Philsu Park: 소형 Shipment SEMI 에도 Priority 값 반영.
                            ------------------------------------------------------------------------
                            LEFT OUTER JOIN ( --TOSITE PRIORITY CONSTRAINT
                                            --SELECT   SEGMENT4   AS ITEM_ID
                                            --        ,SEGMENT5   AS TO_SITE
                                            --        ,SEGMENT6   AS PRIORITY
                                            --        ,ATTRIBUTE1 AS FROM_DATE
                                            --        ,ATTRIBUTE2 AS TO_DATE
                                            --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                            --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW'
                                            --AND     SEGMENT2    = @V_DIVISION_ID
                                            --AND     SEGMENT3    = @V_GROUP_ID
                                            --AND     VALID_YN    = 'Y'

                                            -- 2025.11.18 Minyong Lee : Sales Site Priority Lookup -> UI 전환
                                            SELECT  P.ITEM_ID       AS ITEM_ID
                                                  , P.SCM_SITE_ID   AS TO_SITE
												  , CONVERT(NVARCHAR,P.PRIO_RANK)     AS PRIORITY
                                                  , FROM_YYYYMMDD   AS FROM_DATE
                                                  , TO_YYYYMMDD     AS TO_DATE
                                            FROM    SCP_OPMZ_SALES_SITE_PRIORITY P WITH(NOLOCK)
                                                LEFT JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                                                    ON  P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                                    AND PG.VALID_YN = 'Y'
                                            WHERE   1=1
                                            AND     P.VALID_YN = 'Y'
                                            AND     P.DIVISION_ID = @V_DIVISION_ID
                                            AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                                            ) TP
                                ON  A.FROM_SITE     = TP.TO_SITE
                                AND A.ITEM_ID       = TP.ITEM_ID
                                AND A.YYYYMMDD BETWEEN TP.FROM_DATE AND TP.TO_DATE
                            ------------------------------------------------------------------------
                        WHERE A.DIVISION_ID         = @V_DIVISION_ID
                        AND   A.plan_start_yyyymmdd = @V_SCP_PLAN_DATE
                        AND   A.plan_type           = @V_SCP_PLAN_TYPE 
                        AND   A.seq                 = @V_SCP_PLAN_SEQ  
                        AND   A.measure             = 'SHIP_PLAN_AMEND'
                        AND   A.QTY                 > 0   
                        AND   A.YYYYMMDD            >= @P_PLAN_NAME  
                        AND   A.YYYYMMDD            < @V_PLAN_END_YYYYMMDD
                        AND   A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE   PLAN_ID = @V_PLAN_ID
                                        )
                        GROUP BY A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, A.ITEM_ID, A.YYYYMMDD, BOD.INCOTERMS, BOD.TRANSPORT_MODE, TP.PRIORITY
                        ) DEMAND
                    ------------------------------------------------------------------------
                    -- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
                    -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
                    -- 2025.11.10 Minyong Lee : 소형 Demand 제외 조건에 Stage 추가 적용에 따른 JOIN Depth 변경
                    ------------------------------------------------------------------------
                    LEFT JOIN   (
                                --SELECT  SEGMENT2   AS DIVISION_ID
                                --      , SEGMENT3   AS SCM_SITE_ID
                                --      , SEGMENT4   AS ITEM_ID
                                --      , SEGMENT5   AS GROUP_ID
                                --      , ATTRIBUTE1 AS STAGE
                                --      , CASE
                                --            WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                                --            ELSE ATTRIBUTE2
                                --        END AS START_DATE  -- PLAN 제외 시작일자
                                --      , CASE
                                --            WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                                --            ELSE ATTRIBUTE3
                                --        END AS END_DATE  -- PLAN 제외 끝일자
                                --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                                --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                                --AND     VALID_YN    = 'Y'
                                --AND     SEGMENT2    = @V_DIVISION_ID
                                --AND     SEGMENT5    = @V_GROUP_ID

                                -- 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환
                                SELECT  D.DIVISION_ID           AS DIVISION_ID
                                      , D.SCM_SITE_ID           AS SCM_SITE_ID
                                      , D.ITEM_ID               AS ITEM_ID
                                      , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                                      , D.STAGE                 AS STAGE
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
                        ON  DEMAND.SCM_SITE_ID   = DE.SCM_SITE_ID
                        AND DEMAND.ITEM_ID       = DE.ITEM_ID
                        AND ((DEMAND.DIVISION_ID = '40' AND DEMAND.STAGE = DE.STAGE) OR  -- 소형의 경우 JOIN 조건에 STAGE까지 고려
                             DEMAND.DIVISION_ID <> '40')
                -- DEMAND 제외 대상 처리
                WHERE   1=1
                AND     (ISNULL(DE.ITEM_ID, '') = '' OR                                                                         -- 수요 제외 대상이 아니거나
                         (ISNULL(DE.ITEM_ID, '') <> '' AND (DEMAND.DUE_DATE < DE.START_DATE OR DEMAND.DUE_DATE > DE.END_DATE))) -- 수요 제외 대상이어도 기간 범위 밖인 것
            END -- IF @V_DIVISION_ID = '40'

    ------------------------------------------------------------------------
    -- 2. 수요 묶음.
    ------------------------------------------------------------------------

    PRINT ('4. Demand Merge Type Update: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));
    ----------------------------------------------------------------------------
    -- 2025.06.09 Philsu Park
    -- Demand 뭉치기 대상 마킹을 위한 Temp Update.
    ----------------------------------------------------------------------------
    UPDATE  DM
    SET     DM.ATTRIBUTE15 = ISNULL(LK.DEMAND_MERGE_TYPE, 'X')
    FROM    @DM_INS_TEMP DM
    LEFT OUTER JOIN (
                        SELECT    SEGMENT2 AS DIVISION_ID
                                , SEGMENT3 AS PLAN_GROUP_ID
                                , SEGMENT4 AS SITE_ID
                                , SEGMENT5 AS STAGE
                                , SEGMENT6 AS LINE_ID
                                , SEGMENT7 AS ITEM_ID
                                , ATTRIBUTE1 AS DEMAND_MERGE_TYPE
                                , TRY_CAST(ATTRIBUTE2 AS INT) * 7 AS MERGE_VAL
                                , ATTRIBUTE3 AS DIO_VAL
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                        WHERE   1=1
                        AND     LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
                        AND     VALID_YN      = 'Y'
                        AND     SEGMENT2      = @V_DIVISION_ID
                        AND     SEGMENT3      = @V_GROUP_ID
                        ) LK
        ON  LK.SITE_ID      = DM.ATTRIBUTE1
        AND LK.ITEM_ID      = DM.ATTRIBUTE2
        AND LK.STAGE        = DM.ATTRIBUTE3
        AND DM.DUE_DATE    >= @V_PROD_FROZEN_END_YMD
    WHERE   DM.PLAN_ID      = @V_PLAN_ID
    ;


    PRINT ('4.1. Delete Item with quantity 0: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  
    --20251015/T.K.KIM/워크벤치에서 0으로 들어온 데이터는 원천에서 안 가져오게하고 삭제
    DELETE FROM @DM_INS_TEMP
    WHERE PLAN_ID = @V_PLAN_ID
    AND   QUANTITY = 0

    PRINT ('5. Demand Origin Backup: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  
    ----------------------------------------------------------------------------
    -- 1.3 Demand Origin Backup
    -- 2025.06.10 Philsu Park: 원본 DEMAND 를 백업한다.(동일 PLAN_ID로 삭제 후 INSERT)
    ----------------------------------------------------------------------------
    DELETE 
    FROM    SCP_OPT_ENG_DEMAND_ORIGIN_SN
    WHERE   PLAN_ID = @V_PLAN_ID
    ;
    
    INSERT INTO SCP_OPT_ENG_DEMAND_ORIGIN_SN
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
        SELECT   PLAN_ID
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
        FROM @DM_INS_TEMP DM
        WHERE 1=1
        AND DM.PLAN_ID  = @V_PLAN_ID
        ;

    
    PRINT ('6. Demand Insert NOT IN A, B, C: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  
    ----------------------------------------------------------------------------
    -- 1.4 Demand Insert
    -- 2025.06.09 Philsu Park: A Type은 별도 처리. 나머지는 기존대로 넣어줌.
    -- 2025.08.27 Philsu Park: C Type 추가.
    ------------------------------------------------------------------------
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
        SELECT PLAN_ID
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
        FROM @DM_INS_TEMP DM
        WHERE 1=1
        AND DM.PLAN_ID  = @V_PLAN_ID
        AND DM.ATTRIBUTE15 NOT IN ('A', 'B', 'C', 'D')
        ;

    PRINT ('7. Demand Insert TYpe A: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  

    
    ----------------------------------------------------------------------------
    -- 1.4 Demand Insert
    -- 2025.06.09 Philsu Park: A Type 별도 처리.
    -- 2025.08.25 Philsu Park: A Type의 value 기준을 주차가 아닌 일로 변경.(Due Date를 포함해야되서 Minus 1)
    ----------------------------------------------------------------------------
    SELECT @V_CNT = COUNT(*)
    FROM   @DM_INS_TEMP S
    WHERE 1=1
    AND S.PLAN_ID       = @V_PLAN_ID
    AND S.ATTRIBUTE15   = 'A'
    AND S.DUE_DATE     >= @V_PROD_FROZEN_END_YMD
    ;

    IF @V_CNT > 0 
        BEGIN 
            IF OBJECT_ID('TEMPDB..#DEMAND_TYPE_A') IS NOT NULL
            BEGIN 
                DROP TABLE  #DEMAND_TYPE_A;
            END;

            SELECT    ROW_NUMBER()OVER(PARTITION BY S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3 ORDER BY CM.BASIS_DATE) AS R_NUM
                    , CM.BASIS_DATE AS DEMAND_DATE
                    , LK.MERGE_VAL
                    , S.*
            INTO    #DEMAND_TYPE_A
            FROM    @DM_INS_TEMP S
            INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                ON  S.DUE_DATE  = CM.BASIS_YYYYMMDD
            INNER JOIN (SELECT    SEGMENT2                          AS DIVISION_ID
                                , SEGMENT3                          AS PLAN_GROUP_ID
                                , SEGMENT4                          AS SITE_ID
                                , SEGMENT5                          AS STAGE
                                , SEGMENT6                          AS LINE_ID
                                , SEGMENT7                          AS ITEM_ID
                                , ATTRIBUTE1                        AS DEMAND_MERGE_TYPE
                                , CAST(ATTRIBUTE2 AS INT) - 1       AS MERGE_VAL
                                -- , CAST(ATTRIBUTE2 AS INT) * 7       AS MERGE_VAL
                                , ATTRIBUTE3                        AS DIO_VAL
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
                        WHERE   1=1
                        AND     D.LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
                        AND     D.VALID_YN      = 'Y'
                        AND     D.ATTRIBUTE1    = 'A'
                        AND     D.SEGMENT2      = @V_DIVISION_ID
                        AND     D.SEGMENT3      = @V_GROUP_ID
                        ) LK
                ON  LK.SITE_ID  = S.ATTRIBUTE1
                AND LK.ITEM_ID  = S.ATTRIBUTE2
                AND LK.STAGE    = S.ATTRIBUTE3
            WHERE 1=1
            AND S.PLAN_ID       = @V_PLAN_ID
            AND S.ATTRIBUTE15   = 'A'
            AND S.DUE_DATE     >= @V_PROD_FROZEN_END_YMD
        ;

        WITH RECURSIVE_DEMAND AS (
                    SELECT    DM.DEMAND_DATE    AS GROUP_START_DATE
                            , 1                 AS GROUP_NO
                            , DM.DEMAND_DATE    AS DEMAND_DATE
                            , DM.R_NUM
                            , DM.MERGE_VAL
                            , DM.PLAN_ID
                            , DM.DEMAND_ID
                            , DM.BUFFER_ID
                            , DM.DEMAND_GROUP
                            , DM.DUE_DATE
                            , DM.TARGET_DATE
                            , DM.SALES_CUTOFF_DATE
                            , DM.EXPIRY_DATE
                            , DM.PRIORITY
                            , DM.QUANTITY
                            , DM.PRIORITY_GROUP
                            , DM.CUSTOMER_ID
                            , DM.ALLOW_SHORT
                            , DM.ATTRIBUTE1
                            , DM.ATTRIBUTE2
                            , DM.ATTRIBUTE3
                            , DM.ATTRIBUTE4, DM.ATTRIBUTE5
                            , DM.ATTRIBUTE6, DM.ATTRIBUTE7, DM.ATTRIBUTE8, DM.ATTRIBUTE9, DM.ATTRIBUTE10
                            , DM.ATTRIBUTE11, DM.ATTRIBUTE12, DM.ATTRIBUTE13, DM.ATTRIBUTE14, DM.ATTRIBUTE15
                    FROM    #DEMAND_TYPE_A DM
                    WHERE   DM.R_NUM = 1
                    UNION ALL
                    SELECT    CASE WHEN DATEDIFF(DAY, PREV.GROUP_START_DATE, DM.DEMAND_DATE) > DM.MERGE_VAL THEN DM.DEMAND_DATE
                                WHEN DATEDIFF(DAY, PREV.DEMAND_DATE, DM.DEMAND_DATE)     > DM.MERGE_VAL  THEN DM.DEMAND_DATE
                                ELSE PREV.GROUP_START_DATE
                                    END AS GROUP_START_DATE
                            , CASE WHEN DATEDIFF(DAY, PREV.GROUP_START_DATE, DM.DEMAND_DATE) > DM.MERGE_VAL THEN PREV.GROUP_NO + 1
                                    WHEN DATEDIFF(DAY, PREV.DEMAND_DATE, DM.DEMAND_DATE) > DM.MERGE_VAL THEN PREV.GROUP_NO + 1
                                    ELSE PREV.GROUP_NO
                                    END AS GROUP_NO
                            , DM.DEMAND_DATE
                            , DM.R_NUM
                            , DM.MERGE_VAL
                            , DM.PLAN_ID
                            , DM.DEMAND_ID
                            , DM.BUFFER_ID
                            , DM.DEMAND_GROUP
                            , DM.DUE_DATE
                            , DM.TARGET_DATE
                            , DM.SALES_CUTOFF_DATE
                            , DM.EXPIRY_DATE
                            , DM.PRIORITY
                            , DM.QUANTITY
                            , DM.PRIORITY_GROUP
                            , DM.CUSTOMER_ID
                            , DM.ALLOW_SHORT
                            , DM.ATTRIBUTE1
                            , DM.ATTRIBUTE2
                            , DM.ATTRIBUTE3
                            , DM.ATTRIBUTE4, DM.ATTRIBUTE5
                            , DM.ATTRIBUTE6, DM.ATTRIBUTE7, DM.ATTRIBUTE8, DM.ATTRIBUTE9, DM.ATTRIBUTE10
                            , DM.ATTRIBUTE11, DM.ATTRIBUTE12, DM.ATTRIBUTE13, DM.ATTRIBUTE14, DM.ATTRIBUTE15
                    FROM    #DEMAND_TYPE_A DM
                    INNER JOIN RECURSIVE_DEMAND PREV
                        ON DM.ATTRIBUTE1 = PREV.ATTRIBUTE1
                        AND DM.ATTRIBUTE2 = PREV.ATTRIBUTE2
                        AND DM.ATTRIBUTE3 = PREV.ATTRIBUTE3
                        AND DM.R_NUM        = PREV.R_NUM + 1
                    WHERE   1=1
                )
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
            SELECT    /* GROUP_NO
                    , GROUP_START_DATE */
                    FDM.PLAN_ID                                   AS PLAN_ID
                    , MIN(FDM.DEMAND_ID)                            AS DEMAND_ID
                    , MIN(FDM.BUFFER_ID)                            AS BUFFER_ID
                    , MIN(FDM.DEMAND_GROUP)                         AS DEMAND_GROUP
                    , CONVERT(NVARCHAR, MIN(FDM.DEMAND_DATE), 112)  AS DUE_DATE
                    , MIN(FDM.TARGET_DATE)                          AS TARGET_DATE
                    , MIN(FDM.SALES_CUTOFF_DATE)                    AS SALES_CUTOFF_DATE
                    , MIN(FDM.EXPIRY_DATE)                          AS EXPIRY_DATE
                    , MIN(FDM.PRIORITY)                             AS PRIORITY
                    , ROUND(SUM(FDM.QUANTITY), 0)                   AS QUANTITY
                    , MIN(FDM.PRIORITY_GROUP)                       AS PRIORITY_GROUP
                    , MIN(FDM.CUSTOMER_ID)                          AS CUSTOMER_ID
                    , MIN(FDM.ALLOW_SHORT)                          AS ALLOW_SHORT
                    , FDM.ATTRIBUTE1                                AS ATTRIBUTE1
                    , FDM.ATTRIBUTE2                                AS ATTRIBUTE2
                    , FDM.ATTRIBUTE3                                AS ATTRIBUTE3
                    , MIN(FDM.ATTRIBUTE4)                           AS ATTRIBUTE4
                    , MIN(FDM.ATTRIBUTE5)                           AS ATTRIBUTE5
                    , MIN(FDM.ATTRIBUTE6)                           AS ATTRIBUTE6
                    , MIN(FDM.ATTRIBUTE7)                           AS ATTRIBUTE7
                    , MIN(FDM.ATTRIBUTE8)                           AS ATTRIBUTE8
                    , MIN(FDM.ATTRIBUTE9)                           AS ATTRIBUTE9
                    , MIN(FDM.ATTRIBUTE10)                          AS ATTRIBUTE10
                    , MIN(FDM.ATTRIBUTE11)                          AS ATTRIBUTE11
                    , MIN(FDM.ATTRIBUTE12)                          AS ATTRIBUTE12
                    , MIN(FDM.ATTRIBUTE13)                          AS ATTRIBUTE13
                    , MIN(FDM.ATTRIBUTE14)                          AS ATTRIBUTE14
                    , MIN(FDM.ATTRIBUTE15)                          AS ATTRIBUTE15
            FROM    RECURSIVE_DEMAND FDM
            GROUP BY FDM.PLAN_ID, FDM.ATTRIBUTE1, FDM.ATTRIBUTE2, FDM.ATTRIBUTE3, FDM.GROUP_NO, FDM.GROUP_START_DATE
            OPTION  (MAXRECURSION 10000)
            ;
    END

    

    PRINT ('8. Demand Insert TYpe B: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  

    SELECT @V_CNT = COUNT(*)
    FROM   @DM_INS_TEMP S
    WHERE 1=1
    AND S.PLAN_ID       = @V_PLAN_ID
    AND S.ATTRIBUTE15   = 'B'
    AND S.DUE_DATE     >= @V_PROD_FROZEN_END_YMD
    ;

    IF @V_CNT > 0 
        BEGIN 
            ----------------------------------------------------------------------------
            -- 1.4 Demand Insert
            -- 2025.06.11 Philsu Park: B Type 별도 처리.
            -- 2025.06.18 Philsu Park: Due Date가 Plan 구간 바깥에 있으면 안되기 때문에 LEAST 처리.
            -- 2025.08.28 Philsu Park: DIO_QTY를 계산하는 첫달 찾는 로직은 FIRST_ORDER로 찾게 변경.(Frozen End월과 실제 계획 첫달의 Gap이 있는 경우 첫달 계획 차감하는 결함 보완)
            ----------------------------------------------------------------------------
            WITH DEMAND AS (
                    SELECT    DM.PLAN_ID
                            , CONCAT(DM.ATTRIBUTE1, '::', DM.ATTRIBUTE2, '::', DM.ATTRIBUTE3, '@', DM.ATTRIBUTE4, '@', DM.ATTRIBUTE5, '::', IIF(LEFT(@V_PROD_FROZEN_END_YMD, 6)=DM.PLAN_YYYYMM, MIN_PLAN_YYYYMMDD, CONCAT(DM.PLAN_YYYYMM, MERGE_VAL)), '::', '-', '::', DM.ATTRIBUTE8) AS DEMAND_ID
                            , DM.BUFFER_ID
                            , MIN(DM.DEMAND_GROUP)      AS DEMAND_GROUP
                            , DM.PLAN_YYYYMM            AS PLAN_YYYYMM
                            , IIF(LEFT(@V_PROD_FROZEN_END_YMD, 6)=DM.PLAN_YYYYMM, MIN_PLAN_YYYYMMDD, CONCAT(DM.PLAN_YYYYMM, MERGE_VAL)) AS DUE_DATE
                            , MIN(DM.TARGET_DATE)       AS TARGET_DATE
                            , MIN(DM.SALES_CUTOFF_DATE) AS SALES_CUTOFF_DATE
                            , MIN(DM.EXPIRY_DATE)       AS EXPIRY_DATE
                            , MIN(DM.PRIORITY)          AS PRIORITY
                            , SUM(DM.QUANTITY)          AS QUANTITY
                            , MAX(LK.DIO_VAL)           AS DIO_VAL
                            -- , ROUND(IIF(LEFT(@V_PROD_FROZEN_END_YMD, 6)=DM.PLAN_YYYYMM, 0, SUM(DM.QUANTITY)/30.42*MAX(DIO_VAL)), 0) AS DIO_QTY
                            , IIF(DM.MONTH_ORDER = 1, 0, SUM(CONVERT(FLOAT, DM.QUANTITY))/30.42*MAX(CONVERT(FLOAT, DIO_VAL))) AS DIO_QTY
                            , MIN(DM.PRIORITY_GROUP)    AS PRIORITY_GROUP
                            , MIN(DM.CUSTOMER_ID)       AS CUSTOMER_ID
                            , MIN(DM.ALLOW_SHORT)       AS ALLOW_SHORT
                            , DM.ATTRIBUTE1             AS ATTRIBUTE1
                            , DM.ATTRIBUTE2             AS ATTRIBUTE2
                            , DM.ATTRIBUTE3             AS ATTRIBUTE3
                            , DM.ATTRIBUTE4             AS ATTRIBUTE4
                            , DM.ATTRIBUTE5             AS ATTRIBUTE5
                            , MIN(DM.ATTRIBUTE6)        AS ATTRIBUTE6
                            , MIN(DM.ATTRIBUTE7)        AS ATTRIBUTE7
                            , DM.ATTRIBUTE8             AS ATTRIBUTE8
                            , MIN(DM.ATTRIBUTE9)        AS ATTRIBUTE9
                            , MIN(DM.ATTRIBUTE10)       AS ATTRIBUTE10
                            , MIN(DM.ATTRIBUTE11)       AS ATTRIBUTE11
                            , MIN(DM.ATTRIBUTE12)       AS ATTRIBUTE12
                            , MIN(DM.ATTRIBUTE13)       AS ATTRIBUTE13
                            , MIN(DM.ATTRIBUTE14)       AS ATTRIBUTE14
                            , MIN(DM.ATTRIBUTE15)       AS ATTRIBUTE15
                            , MIN(DM.PLAN_YYYYMM)OVER(PARTITION BY DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE3) AS START_YYYYMM
                            , MAX(DM.PLAN_YYYYMM)OVER(PARTITION BY DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE3) AS END_YYYYMM
                            , MIN(MERGE_VAL)            AS MERGE_VAL
                    FROM ( 
                            SELECT    S.*
                                    , CM.BASIS_YYYYMM AS PLAN_YYYYMM
                                    , CM.BASIS_DATE
                                    , MIN(S.DUE_DATE)OVER(PARTITION BY S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3, CM.BASIS_YYYYMM) MIN_PLAN_YYYYMMDD
                                    , DENSE_RANK()OVER(PARTITION BY S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3 ORDER BY CM.BASIS_YYYYMM) AS MONTH_ORDER
                                    -- , IIF(LEFT(S.DUE_DATE, 1, 6)='202505', MIN(S.DUE_DATE), LEFT(S.DUE_DATE)+LK.MERGE_VAL) AS DEMAND_DATE
                            FROM    @DM_INS_TEMP S
                            INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                                ON  S.DUE_DATE  = CM.BASIS_YYYYMMDD
                            WHERE   S.PLAN_ID   = @V_PLAN_ID
                            AND     S.DUE_DATE >= @V_PROD_FROZEN_END_YMD
                            AND     S.ATTRIBUTE15 = 'B'
                            ) DM
                    INNER JOIN (SELECT    SEGMENT2 AS DIVISION_ID
                                        , SEGMENT3 AS PLAN_GROUP_ID
                                        , SEGMENT4 AS SITE_ID
                                        , SEGMENT5 AS STAGE
                                        , SEGMENT6 AS LINE_ID
                                        , SEGMENT7 AS ITEM_ID
                                        , ATTRIBUTE1 AS DEMAND_MERGE_TYPE
                                        , RIGHT(REPLICATE('0', 1)+ATTRIBUTE2, 2) AS MERGE_VAL
                                        , CONVERT(NUMERIC(20,10), ATTRIBUTE3) AS DIO_VAL
                                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
                                WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
                                AND     D.VALID_YN      = 'Y'
                                AND     D.ATTRIBUTE1    = 'B'
                                AND     D.SEGMENT2      = @V_DIVISION_ID
                                AND     D.SEGMENT3      = @V_GROUP_ID
                                ) LK
                        ON  LK.SITE_ID  = DM.ATTRIBUTE1
                        AND LK.ITEM_ID  = DM.ATTRIBUTE2
                        AND LK.STAGE    = DM.ATTRIBUTE3
                    WHERE   1=1
                    GROUP BY  DM.PLAN_ID
                            , CONCAT(DM.ATTRIBUTE1, '::', DM.ATTRIBUTE2, '::', DM.ATTRIBUTE3, '@', DM.ATTRIBUTE4, '@', DM.ATTRIBUTE5, '::', IIF(LEFT(@V_PROD_FROZEN_END_YMD, 6)=DM.PLAN_YYYYMM, DM.MIN_PLAN_YYYYMMDD, CONCAT(DM.PLAN_YYYYMM, LK.MERGE_VAL)), '::', '-', '::', DM.ATTRIBUTE8)
                            , DM.BUFFER_ID
                            , DM.PLAN_YYYYMM
                            , IIF(LEFT(@V_PROD_FROZEN_END_YMD, 6)=DM.PLAN_YYYYMM, DM.MIN_PLAN_YYYYMMDD, CONCAT(DM.PLAN_YYYYMM, LK.MERGE_VAL))
                            , DM.ATTRIBUTE1
                            , DM.ATTRIBUTE2
                            , DM.ATTRIBUTE3
                            , DM.ATTRIBUTE4
                            , DM.ATTRIBUTE5
                            , DM.ATTRIBUTE8
                            , DM.MONTH_ORDER
                )
            , DEMAND_WITH_CAL AS (
                            SELECT *
                            FROM DEMAND
                            UNION ALL
                            SELECT  
                                    DM.PLAN_ID                            AS PLAN_ID
                                    , CONCAT(DM.ATTRIBUTE1, '::', DM.ATTRIBUTE2, '::', DM.ATTRIBUTE3, '@', DM.ATTRIBUTE4, '@', DM.ATTRIBUTE5, '::', CONCAT(CM.BASIS_YYYYMM, DM.MERGE_VAL), '::', '-', '::', DM.ATTRIBUTE8) AS DEMAND_ID
                                    , DM.BUFFER_ID                          AS BUFFER_ID
                                    , MIN(DM.DEMAND_GROUP)                  AS DEMAND_GROUP
                                    , CM.BASIS_YYYYMM                       AS PLAN_YYYYMM
                                    , CONCAT(CM.BASIS_YYYYMM, DM.MERGE_VAL) AS DUE_DATE
                                    , MIN(DM.TARGET_DATE)                   AS TARGET_DATE
                                    , MIN(DM.SALES_CUTOFF_DATE)             AS SALES_CUTOFF_DATE
                                    , MIN(DM.EXPIRY_DATE)                   AS EXPIRY_DATE
                                    , MIN(DM.PRIORITY)                      AS PRIORITY
                                    , 0                                     AS QUANTITY
                                    , MAX(DM.DIO_VAL)                       AS DIO_VAL
                                    , 0                                     AS DIO_QTY
                                    , MIN(DM.PRIORITY_GROUP)                AS PRIORITY_GROUP
                                    , MIN(DM.CUSTOMER_ID)                   AS CUSTOMER_ID
                                    , MIN(DM.ALLOW_SHORT)                   AS ALLOW_SHORT
                                    , DM.ATTRIBUTE1                         AS ATTRIBUTE1
                                    , DM.ATTRIBUTE2                         AS ATTRIBUTE2
                                    , DM.ATTRIBUTE3                         AS ATTRIBUTE3
                                    , DM.ATTRIBUTE4                         AS ATTRIBUTE4
                                    , DM.ATTRIBUTE5                         AS ATTRIBUTE5
                                    , MIN(DM.ATTRIBUTE6)                    AS ATTRIBUTE6
                                    , MIN(DM.ATTRIBUTE7)                    AS ATTRIBUTE7
                                    , DM.ATTRIBUTE8                         AS ATTRIBUTE8
                                    , MIN(DM.ATTRIBUTE9)                    AS ATTRIBUTE9
                                    , MIN(DM.ATTRIBUTE10)                   AS ATTRIBUTE10
                                    , MIN(DM.ATTRIBUTE11)                   AS ATTRIBUTE11
                                    , MIN(DM.ATTRIBUTE12)                   AS ATTRIBUTE12
                                    , MIN(DM.ATTRIBUTE13)                   AS ATTRIBUTE13
                                    , MIN(DM.ATTRIBUTE14)                   AS ATTRIBUTE14
                                    , MIN(DM.ATTRIBUTE15)                   AS ATTRIBUTE15
                                    , MIN(DM.START_YYYYMM)                  AS START_YYYYMM
                                    , MIN(DM.END_YYYYMM)                    AS END_YYYYMM
                                    , DM.MERGE_VAL                          AS MERGE_VAL
                            FROM    DEMAND DM
                            INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                                ON 1=1
                                AND CM.BASIS_YYYYMM  BETWEEN DM.START_YYYYMM AND DM.END_YYYYMM
                            WHERE   NOT EXISTS ( SELECT 1
                                                FROM   DEMAND DD
                                                WHERE  1=1
                                                AND     DD.PLAN_ID = DM.PLAN_ID
                                                AND     DD.BUFFER_ID = DM.BUFFER_ID
                                                AND     DD.PLAN_YYYYMM = CM.BASIS_YYYYMM)
                            GROUP BY DM.PLAN_ID, DM.BUFFER_ID, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE3, DM.ATTRIBUTE4, DM.ATTRIBUTE5, DM.ATTRIBUTE8, CM.BASIS_YYYYMM, DM.MERGE_VAL
                            )
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
                SELECT 
                    /* DM.QUANTITY AS ORG_QTY
                    , DM.PLAN_YYYYMM
                    , DM2.PLAN_YYYYMM
                    , DM2.DIO_QTY ADD_QTY
                    , DM.DIO_QTY MINUS_QTY
                    , DM.QUANTITY + ISNULL(DM2.DIO_QTY, 0) - ISNULL(DM.DIO_QTY, 0) AS ADJ_QTY
                    , DM.* */
                    FDM.PLAN_ID                                   AS PLAN_ID
                    , FDM.DEMAND_ID                                 AS DEMAND_ID
                    , FDM.BUFFER_ID                                 AS BUFFER_ID
                    , FDM.DEMAND_GROUP                              AS DEMAND_GROUP
                    , LEAST(@V_PLAN_END_YYYYMMDD_ORI, FDM.DUE_DATE) AS DUE_DATE
                    , FDM.TARGET_DATE                               AS TARGET_DATE
                    , FDM.SALES_CUTOFF_DATE                         AS SALES_CUTOFF_DATE
                    , FDM.EXPIRY_DATE                               AS EXPIRY_DATE
                    , FDM.PRIORITY                                  AS PRIORITY
                    , ROUND(FDM.QUANTITY + ISNULL(DM2.DIO_QTY, 0) - ISNULL(FDM.DIO_QTY, 0), 0) AS QUANTITY
                    , FDM.PRIORITY_GROUP                            AS PRIORITY_GROUP
                    , FDM.CUSTOMER_ID                               AS CUSTOMER_ID
                    , FDM.ALLOW_SHORT                               AS ALLOW_SHORT
                    , FDM.ATTRIBUTE1                                AS ATTRIBUTE1
                    , FDM.ATTRIBUTE2                                AS ATTRIBUTE2
                    , FDM.ATTRIBUTE3                                AS ATTRIBUTE3
                    , FDM.ATTRIBUTE4                                AS ATTRIBUTE4
                    , FDM.ATTRIBUTE5                                AS ATTRIBUTE5
                    , FDM.ATTRIBUTE6                                AS ATTRIBUTE6
                    , FDM.ATTRIBUTE7                                AS ATTRIBUTE7
                    , FDM.ATTRIBUTE8                                AS ATTRIBUTE8
                    , FDM.ATTRIBUTE9                                AS ATTRIBUTE9
                    , FDM.ATTRIBUTE10                               AS ATTRIBUTE10
                    , FDM.ATTRIBUTE11                               AS ATTRIBUTE11
                    , FDM.ATTRIBUTE12                               AS ATTRIBUTE12
                    , FDM.ATTRIBUTE13                               AS ATTRIBUTE13
                    , FDM.ATTRIBUTE14                               AS ATTRIBUTE14
                    , FDM.ATTRIBUTE15                               AS ATTRIBUTE15
                FROM    DEMAND_WITH_CAL FDM
                LEFT OUTER JOIN DEMAND_WITH_CAL DM2
                    ON  FDM.PLAN_ID = DM2.PLAN_ID
                    AND FDM.BUFFER_ID = DM2.BUFFER_ID
                    AND DATEADD(MONTH, 1, FDM.PLAN_YYYYMM+'01') = CONVERT(DATETIME, DM2.PLAN_YYYYMM+'01', 112)
                ;
        END

    ----------------------------------------------------------------------------
    -- 1.4 Demand Insert
    -- 2025.08.25 Philsu Park: C Type 추가.
    -- 2025.09.15 Philsu Park: Full Capa 입력값이 있으면 해당 값 활용, 없으면 Capa 정보에서 찾아옴.
    ----------------------------------------------------------------------------

    PRINT ('9. Demand Insert TYpe C: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  

    SELECT @V_CNT = COUNT(*)
    FROM   @DM_INS_TEMP S
    WHERE 1=1
    AND S.PLAN_ID       = @V_PLAN_ID
    AND S.ATTRIBUTE15   = 'C'
    AND S.DUE_DATE     >= @V_PROD_FROZEN_END_YMD
    ;

    IF @V_CNT > 0 
        BEGIN 

            IF OBJECT_ID('TEMPDB..#DEMAND_TYPE_C') IS NOT NULL
            BEGIN 
                DROP TABLE  #DEMAND_TYPE_C;
            END;
            
            
            SELECT    ROW_NUMBER()OVER(PARTITION BY S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3 ORDER BY CM.BASIS_DATE) AS R_NUM
                    , CM.BASIS_DATE AS DEMAND_DATE
                    , LK.MERGE_VAL
                    , CONVERT(NUMERIC, LK.MAX_DAYS) AS MAX_DAYS
                    , CONVERT(NUMERIC(30, 10), LK.FULL_CAPA)    AS FULL_CAPA
                    , CONVERT(NUMERIC(30, 10), S.QUANTITY)      AS QTY
                    , CONVERT(NUMERIC(30, 10), LK.DAILY_CAPA)   AS DAILY_CAPA
                    , S.*
            INTO    #DEMAND_TYPE_C
            FROM    @DM_INS_TEMP S
            INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                    ON  S.DUE_DATE  = CM.BASIS_YYYYMMDD
            INNER HASH JOIN (    
                        SELECT    SEGMENT2                                  AS DIVISION_ID
                                , SEGMENT3                                  AS PLAN_GROUP_ID
                                , SEGMENT4                                  AS SITE_ID
                                , SEGMENT5                                  AS STAGE
                                , SEGMENT6                                  AS LINE_ID
                                , SEGMENT7                                  AS ITEM_ID
                                , ATTRIBUTE1                                AS DEMAND_MERGE_TYPE
                                , CAST(ATTRIBUTE2 AS INT) - 1               AS MERGE_VAL
                                , CAST(ATTRIBUTE4 AS INT)                   AS MAX_DAYS
                                , IIF(ATTRIBUTE5 = '', CPA.FULL_CAPA * CAST(ATTRIBUTE2 AS INT), CONVERT(NUMERIC(20, 10), ATTRIBUTE5) * CAST(ATTRIBUTE2 AS INT))   AS FULL_CAPA
                                , IIF(ATTRIBUTE5 = '', CPA.FULL_CAPA, CONVERT(NUMERIC(20, 10), ATTRIBUTE5)) AS DAILY_CAPA
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
                        INNER JOIN ( 
                                --SELECT    ATTRIBUTE2    AS ITEM_ID
                                --        -- , SEGMENT4      AS SITE_ID
                                --        , 86400/CONVERT(FLOAT, MAX(ATTRIBUTE4)) AS FULL_CAPA
                                --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                --WHERE   LK.LOOKUP_TYPE  = 'SCP_OPT_MASTER_CAPA_TEMP'
                                --AND     LK.VALID_YN     = 'Y'
                                --AND     LK.SEGMENT2     = @V_DIVISION_ID
                                --GROUP BY  ATTRIBUTE2
                                        -- , SEGMENT4

                                -- 2025.10.21 Minyong Lee : Lookup -> UI Table 전환
                                SELECT	CP.ITEM_ID			AS ITEM_ID
                                      , MIN(CP.CAPA * (ISNULL(CP.PRDN_OPER_RT, 100) / 100)) AS FULL_CAPA -- ITEM 별 최소 FULL_CAPA
                                FROM	SCP_OPMZ_DDLY_CAPA CP WITH(NOLOCK)
                                WHERE	1=1
                                AND     CP.VALID_YN = 'Y'
                                AND		CP.DIVISION_ID = @V_DIVISION_ID
                                GROUP BY CP.ITEM_ID
                                ) CPA
                        ON  D.SEGMENT7 = CPA.ITEM_ID
                        -- AND D.SEGMENT4 = CPA.SITE_ID  -- 전극이랑 조립 사이트로 불일치해서 주석.
                        WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
                        AND     D.VALID_YN      = 'Y'
                        AND     D.ATTRIBUTE1    = 'C'
                        AND     D.SEGMENT2      = @V_DIVISION_ID
                        AND     D.SEGMENT3      = @V_GROUP_ID
                        ) LK
                ON  LK.SITE_ID  = S.ATTRIBUTE1
                AND LK.ITEM_ID  = S.ATTRIBUTE2
                AND LK.STAGE    = S.ATTRIBUTE3
            WHERE 1=1
            AND S.PLAN_ID       = @V_PLAN_ID
            AND S.ATTRIBUTE15   = 'C'
            AND S.DUE_DATE     >= @V_PROD_FROZEN_END_YMD
            
            PRINT ('9.1 Temp End. Recursive Start: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  

            WITH RECURSIVE_DEMAND AS (
                        SELECT    DM.DEMAND_DATE    AS GROUP_START_DATE
                                , 1                 AS GROUP_NO
                                , CONVERT(NUMERIC(30, 10), DM.QTY)            AS CUM_QTY
                                , DM.DEMAND_DATE    AS DEMAND_DATE
                                , DM.R_NUM
                                , DM.MERGE_VAL
                                , CONVERT(NUMERIC, DM.MAX_DAYS) MAX_DAYS
                                , DM.PLAN_ID
                                , DM.DEMAND_ID
                                , DM.BUFFER_ID
                                , DM.DEMAND_GROUP
                                , DM.DUE_DATE
                                , DM.TARGET_DATE
                                , DM.SALES_CUTOFF_DATE
                                , DM.EXPIRY_DATE
                                , DM.PRIORITY
                                , CONVERT(NUMERIC(30, 10), DM.QTY) AS QTY
                                , DM.PRIORITY_GROUP
                                , DM.CUSTOMER_ID
                                , DM.ALLOW_SHORT
                                , DM.ATTRIBUTE1
                                , DM.ATTRIBUTE2
                                , DM.ATTRIBUTE3
                                , DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                , DM.ATTRIBUTE6, DM.ATTRIBUTE7, DM.ATTRIBUTE8, DM.ATTRIBUTE9, DM.ATTRIBUTE10
                                , DM.ATTRIBUTE11, DM.ATTRIBUTE12, DM.ATTRIBUTE13, DM.ATTRIBUTE14, DM.ATTRIBUTE15
                                , DM.FULL_CAPA  AS FULL_CAPA
                                , DM.DAILY_CAPA AS DAILY_CAPA
                        FROM    #DEMAND_TYPE_C DM
                        WHERE   DM.R_NUM = 1
                        UNION ALL
                        SELECT    CASE  WHEN CONVERT(NUMERIC(30, 10), PREV.CUM_QTY + DM.QTY) > DM.FULL_CAPA THEN DM.DEMAND_DATE
                                        WHEN DATEDIFF(DAY, PREV.GROUP_START_DATE, DM.DEMAND_DATE) > DM.MAX_DAYS THEN DM.DEMAND_DATE
                                        WHEN DATEDIFF(DAY, PREV.DEMAND_DATE, DM.DEMAND_DATE)     > DM.MAX_DAYS  THEN DM.DEMAND_DATE
                                        ELSE PREV.GROUP_START_DATE
                                        END AS GROUP_START_DATE
                                , CASE  WHEN CONVERT(NUMERIC(30, 10), PREV.CUM_QTY + DM.QTY) > DM.FULL_CAPA THEN PREV.GROUP_NO + 1
                                        WHEN DATEDIFF(DAY, PREV.GROUP_START_DATE, DM.DEMAND_DATE) > DM.MAX_DAYS THEN PREV.GROUP_NO + 1
                                        WHEN DATEDIFF(DAY, PREV.DEMAND_DATE, DM.DEMAND_DATE) > DM.MAX_DAYS THEN PREV.GROUP_NO + 1
                                        ELSE PREV.GROUP_NO
                                        END AS GROUP_NO
                                -- , CONVERT(NUMERIC(30, 10), 1) CUM_QTY
                                , CASE WHEN CONVERT(NUMERIC(30, 10), PREV.CUM_QTY + DM.QTY) > DM.FULL_CAPA THEN CONVERT(NUMERIC(30, 10), DM.QTY)
                                        WHEN DATEDIFF(DAY, PREV.GROUP_START_DATE, DM.DEMAND_DATE) > DM.MAX_DAYS THEN CONVERT(NUMERIC(30, 10), DM.QTY)
                                        WHEN DATEDIFF(DAY, PREV.DEMAND_DATE, DM.DEMAND_DATE)     > DM.MAX_DAYS  THEN CONVERT(NUMERIC(30, 10), DM.QTY)
                                        ELSE CONVERT(NUMERIC(30, 10), PREV.CUM_QTY + DM.QTY)
                                        END AS CUM_QTY
                                , DM.DEMAND_DATE
                                , DM.R_NUM
                                , DM.MERGE_VAL
                                , DM.MAX_DAYS
                                , DM.PLAN_ID
                                , DM.DEMAND_ID
                                , DM.BUFFER_ID
                                , DM.DEMAND_GROUP
                                , DM.DUE_DATE
                                , DM.TARGET_DATE
                                , DM.SALES_CUTOFF_DATE
                                , DM.EXPIRY_DATE
                                , DM.PRIORITY
                                , DM.QTY
                                , DM.PRIORITY_GROUP
                                , DM.CUSTOMER_ID
                                , DM.ALLOW_SHORT
                                , DM.ATTRIBUTE1
                                , DM.ATTRIBUTE2
                                , DM.ATTRIBUTE3
                                , DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                , DM.ATTRIBUTE6, DM.ATTRIBUTE7, DM.ATTRIBUTE8, DM.ATTRIBUTE9, DM.ATTRIBUTE10
                                , DM.ATTRIBUTE11, DM.ATTRIBUTE12, DM.ATTRIBUTE13, DM.ATTRIBUTE14, DM.ATTRIBUTE15
                                , DM.FULL_CAPA  AS FULL_CAPA
                                , DM.DAILY_CAPA AS DAILY_CAPA
                        FROM    #DEMAND_TYPE_C DM
                        INNER JOIN RECURSIVE_DEMAND PREV
                                ON DM.ATTRIBUTE1 = PREV.ATTRIBUTE1
                                AND DM.ATTRIBUTE2 = PREV.ATTRIBUTE2
                                AND DM.ATTRIBUTE3 = PREV.ATTRIBUTE3
                                AND DM.R_NUM        = PREV.R_NUM + 1
                        WHERE   1=1
                        )
                , RESULT_TEMP AS 
                        (
                            SELECT    /* GROUP_NO
                                , GROUP_START_DATE
                                , CM.BASIS_YYYYMMDD AS PLAN_YYYYMMDD
                                , MAX(CUM_QTY/(MERGE_VAL+1)) AS DAILY_QTY
                                , MAX(MAX_DAYS) MAX_DAYS
                                , MAX(MERGE_VAL) MERGE_VAL
                                , MAX(FULL_CAPA) FULL_CAPA
                                , MAX(CUM_QTY) CUM_QTY
                                , MAX(FDM.DAILY_CAPA) DAILY_CAPA
                                ,  */
                                FDM.PLAN_ID                                   AS PLAN_ID
                                , MIN(FDM.DEMAND_ID)                            AS DEMAND_ID
                                , MIN(FDM.BUFFER_ID)                            AS BUFFER_ID
                                , MIN(FDM.DEMAND_GROUP)                         AS DEMAND_GROUP
                                , MIN(FDM.GROUP_START_DATE)                     AS DUE_DATE
                                , MIN(FDM.TARGET_DATE)                          AS TARGET_DATE
                                , MIN(FDM.SALES_CUTOFF_DATE)                    AS SALES_CUTOFF_DATE
                                , MIN(FDM.EXPIRY_DATE)                          AS EXPIRY_DATE
                                , MIN(FDM.PRIORITY)                             AS PRIORITY
                                -- , MAX(CUM_QTY/(MERGE_VAL+1))                    AS QUANTITY
                                , MAX(FDM.CUM_QTY)/LEAST(FLOOR(MAX(FDM.CUM_QTY/FDM.DAILY_CAPA))+1, MAX((FDM.MERGE_VAL+1))) AS QUANTITY
                                , MIN(FDM.PRIORITY_GROUP)                       AS PRIORITY_GROUP
                                , MIN(FDM.CUSTOMER_ID)                          AS CUSTOMER_ID
                                , MIN(FDM.ALLOW_SHORT)                          AS ALLOW_SHORT
                                , FDM.ATTRIBUTE1                                AS ATTRIBUTE1
                                , FDM.ATTRIBUTE2                                AS ATTRIBUTE2
                                , FDM.ATTRIBUTE3                                AS ATTRIBUTE3
                                , MIN(FDM.ATTRIBUTE4)                           AS ATTRIBUTE4
                                , MIN(FDM.ATTRIBUTE5)                           AS ATTRIBUTE5
                                , MIN(FDM.ATTRIBUTE6)                           AS ATTRIBUTE6
                                , MIN(FDM.ATTRIBUTE7)                           AS ATTRIBUTE7
                                , MIN(FDM.ATTRIBUTE8)                           AS ATTRIBUTE8
                                , MIN(FDM.ATTRIBUTE9)                           AS ATTRIBUTE9
                                , MIN(FDM.ATTRIBUTE10)                          AS ATTRIBUTE10
                                , MIN(FDM.ATTRIBUTE11)                          AS ATTRIBUTE11
                                , MIN(FDM.ATTRIBUTE12)                          AS ATTRIBUTE12
                                , MIN(FDM.ATTRIBUTE13)                          AS ATTRIBUTE13
                                , MIN(FDM.ATTRIBUTE14)                          AS ATTRIBUTE14
                                , MIN(FDM.ATTRIBUTE15)                          AS ATTRIBUTE15
                                , FDM.GROUP_START_DATE                          AS GROUP_START_DATE
                                , LEAST(FLOOR(MAX(FDM.CUM_QTY/FDM.DAILY_CAPA)), MAX((FDM.MERGE_VAL))) AS MERGE_VAL2
                        FROM    RECURSIVE_DEMAND FDM
                        GROUP BY FDM.PLAN_ID, FDM.ATTRIBUTE1, FDM.ATTRIBUTE2, FDM.ATTRIBUTE3, FDM.GROUP_NO, FDM.GROUP_START_DATE
                        )
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
                SELECT    RT.PLAN_ID
                        -- , RT.DEMAND_ID
                        , REPLACE(RT.DEMAND_ID, CONVERT(NVARCHAR, RT.GROUP_START_DATE, 112), CM.BASIS_YYYYMMDD) AS DEMAND_ID
                        , RT.BUFFER_ID
                        , RT.DEMAND_GROUP
                        , CM.BASIS_YYYYMMDD AS DUE_DATE
                        , RT.TARGET_DATE
                        , RT.SALES_CUTOFF_DATE
                        , RT.EXPIRY_DATE
                        , RT.PRIORITY
                        , RT.QUANTITY
                        , RT.PRIORITY_GROUP
                        , RT.CUSTOMER_ID
                        , RT.ALLOW_SHORT
                        , RT.ATTRIBUTE1
                        , RT.ATTRIBUTE2
                        , RT.ATTRIBUTE3
                        , RT.ATTRIBUTE4
                        , RT.ATTRIBUTE5
                        , RT.ATTRIBUTE6
                        , RT.ATTRIBUTE7
                        , RT.ATTRIBUTE8
                        , RT.ATTRIBUTE9
                        , RT.ATTRIBUTE10
                        , RT.ATTRIBUTE11
                        , RT.ATTRIBUTE12
                        , RT.ATTRIBUTE13
                        , RT.ATTRIBUTE14
                        , RT.ATTRIBUTE15
                FROM    RESULT_TEMP RT
                INNER JOIN SCM_SYS_CALENDAR_M CM
                        ON CM.BASIS_YYYYMMDD BETWEEN RT.GROUP_START_DATE AND DATEADD(DAY, RT.MERGE_VAL2, RT.GROUP_START_DATE)
                OPTION  (MAXRECURSION 0)
                ;
        END
    PRINT ('9.2 Demand Type C Recursive End: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  

    ----------------------------------------------------------------------------
    -- 1.5 Demand Insert
    -- 2026.03.09 Minyong Lee: D Type 추가.
    ----------------------------------------------------------------------------

    --PRINT ('10. Demand Insert Type D: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  

    --SELECT @V_CNT = COUNT(*)
    --FROM   @DM_INS_TEMP S
    --WHERE 1=1
    --AND S.PLAN_ID       = @V_PLAN_ID
    --AND S.ATTRIBUTE15   = 'D'
    --AND S.DUE_DATE     >= @V_PROD_FROZEN_END_YMD
    --;

    --IF @V_CNT > 0
    --    BEGIN
    --        IF OBJECT_ID('TEMPDB..#DEMAND_TYPE_D') IS NOT NULL
    --        BEGIN 
    --            DROP TABLE  #DEMAND_TYPE_D;
    --        END;
            
    --        SELECT  CM.DAYOFWEEK
    --              , LK.DEMAND_MERGE_DAY
    --              , CONVERT(NVARCHAR(8), DBO.FN_NEXT_DAY(DATEADD(DD, -7, CM.BASIS_END_DATE), LK.DEMAND_MERGE_DAY), 112) AS GROUP_START_DATE -- 전주 일요일 기준으로 다음 타겟 요일 = 금주의 타겟 요일
    --              , S.*
    --        INTO    #DEMAND_TYPE_D
    --        FROM    @DM_INS_TEMP S
    --            INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
    --                ON  S.DUE_DATE  = CM.BASIS_YYYYMMDD
    --            INNER JOIN (
    --                        SELECT    SEGMENT2 AS DIVISION_ID
    --                                , SEGMENT3 AS PLAN_GROUP_ID
    --                                , SEGMENT4 AS SITE_ID
    --                                , SEGMENT5 AS STAGE
    --                                , SEGMENT6 AS LINE_ID
    --                                , SEGMENT7 AS ITEM_ID
    --                                , ATTRIBUTE1 AS DEMAND_MERGE_TYPE
    --                                , ATTRIBUTE2 AS DEMAND_MERGE_DAY
    --                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
    --                        WHERE   LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
    --                        AND     VALID_YN      = 'Y'
    --                        AND     SEGMENT2      = @V_DIVISION_ID
    --                        AND     SEGMENT3      = @V_GROUP_ID
    --                        AND     ATTRIBUTE1    = 'D'
    --                        ) LK
    --                ON  LK.SITE_ID  = S.ATTRIBUTE1
    --                AND LK.ITEM_ID  = S.ATTRIBUTE2
    --                AND LK.STAGE    = S.ATTRIBUTE3
    --        WHERE   1=1
    --        AND     S.PLAN_ID       = @V_PLAN_ID
    --        AND     S.ATTRIBUTE15   = 'D'
    --        AND     S.DUE_DATE     >= @V_PROD_FROZEN_END_YMD

    --        -- 묶음 Target 일자가 Frozen 구간 내인 경우, Frozen 이후 일자에 반영
    --        UPDATE #DEMAND_TYPE_D
    --        SET GROUP_START_DATE = @V_PROD_FROZEN_END_YMD
    --        WHERE GROUP_START_DATE < @V_PROD_FROZEN_END_YMD

    --        INSERT INTO SCP_OPT_ENG_DEMAND_SN (
    --             PLAN_ID
    --            ,DEMAND_ID
    --            ,BUFFER_ID
    --            ,DEMAND_GROUP
    --            ,DUE_DATE
    --            ,TARGET_DATE
    --            ,SALES_CUTOFF_DATE
    --            ,EXPIRY_DATE
    --            ,PRIORITY
    --            ,QUANTITY
    --            ,PRIORITY_GROUP
    --            ,CUSTOMER_ID
    --            ,ALLOW_SHORT
    --            ,ATTRIBUTE1
    --            ,ATTRIBUTE2
    --            ,ATTRIBUTE3
    --            ,ATTRIBUTE4
    --            ,ATTRIBUTE5
    --            ,ATTRIBUTE6
    --            ,ATTRIBUTE7
    --            ,ATTRIBUTE8
    --            ,ATTRIBUTE9
    --            ,ATTRIBUTE10
    --            ,ATTRIBUTE11
    --            ,ATTRIBUTE12
    --            ,ATTRIBUTE13
    --            ,ATTRIBUTE14
    --            ,ATTRIBUTE15
    --        )
    --        SELECT  FDM.PLAN_ID                                   AS PLAN_ID
    --              , MIN(FDM.DEMAND_ID)                            AS DEMAND_ID
    --              , MIN(FDM.BUFFER_ID)                            AS BUFFER_ID
    --              , MIN(FDM.DEMAND_GROUP)                         AS DEMAND_GROUP
    --              , GROUP_START_DATE                              AS DUE_DATE
    --              , MIN(FDM.TARGET_DATE)                          AS TARGET_DATE
    --              , MIN(FDM.SALES_CUTOFF_DATE)                    AS SALES_CUTOFF_DATE
    --              , MIN(FDM.EXPIRY_DATE)                          AS EXPIRY_DATE
    --              , MIN(FDM.PRIORITY)                             AS PRIORITY
    --              , ROUND(SUM(FDM.QUANTITY), 0)                   AS QUANTITY
    --              , MIN(FDM.PRIORITY_GROUP)                       AS PRIORITY_GROUP
    --              , MIN(FDM.CUSTOMER_ID)                          AS CUSTOMER_ID
    --              , MIN(FDM.ALLOW_SHORT)                          AS ALLOW_SHORT
    --              , FDM.ATTRIBUTE1                                AS ATTRIBUTE1
    --              , FDM.ATTRIBUTE2                                AS ATTRIBUTE2
    --              , FDM.ATTRIBUTE3                                AS ATTRIBUTE3
    --              , MIN(FDM.ATTRIBUTE4)                           AS ATTRIBUTE4
    --              , MIN(FDM.ATTRIBUTE5)                           AS ATTRIBUTE5
    --              , MIN(FDM.ATTRIBUTE6)                           AS ATTRIBUTE6
    --              , MIN(FDM.ATTRIBUTE7)                           AS ATTRIBUTE7
    --              , MIN(FDM.ATTRIBUTE8)                           AS ATTRIBUTE8
    --              , MIN(FDM.ATTRIBUTE9)                           AS ATTRIBUTE9
    --              , MIN(FDM.ATTRIBUTE10)                          AS ATTRIBUTE10
    --              , MIN(FDM.ATTRIBUTE11)                          AS ATTRIBUTE11
    --              , MIN(FDM.ATTRIBUTE12)                          AS ATTRIBUTE12
    --              , MIN(FDM.ATTRIBUTE13)                          AS ATTRIBUTE13
    --              , MIN(FDM.ATTRIBUTE14)                          AS ATTRIBUTE14
    --              , MIN(FDM.ATTRIBUTE15)                          AS ATTRIBUTE15
    --        FROM    #DEMAND_TYPE_D FDM
    --        GROUP BY FDM.PLAN_ID, FDM.ATTRIBUTE1, FDM.ATTRIBUTE2, FDM.ATTRIBUTE3, FDM.GROUP_START_DATE
    --    END

    ------------------------------------------------------------------------
    -- 2. DEMAND GROUP
    ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- 2-1. DEMAND GROUP에 제품이 있고, 최소 하나 이상 등록된 SITE에 대해 모든 ITEM의 BUFFER를추가함
        ------------------------------------------------------------------------
    INSERT INTO SCP_OPT_ENG_DEMAND_SN (PLAN_ID,DEMAND_ID,BUFFER_ID,ATTRIBUTE13,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)
    SELECT PLAN_ID
          ,DEMAND_ID
          ,BUFFER_ID
          ,ATTRIBUTE13
          ,SCM_SITE_ID 
          ,ITEM_ID     
          ,STAGE       
          ,INCOTERMS   
          ,PROJECT_CODE
    FROM(
        SELECT @V_PLAN_ID                                                                                       AS PLAN_ID
               ,'DUMMY'+'::'+DG.SCM_SITE_ID+'::'+DG.ITEM_ID+'::'+DG.STAGE+'@'+DG.INCOTERMS+'@'+DG.PROJECT_CODE  AS DEMAND_ID
               ,DG.SCM_SITE_ID+'::'+DG.ITEM_ID+'::'+DG.STAGE+'@'+DG.INCOTERMS+'@'+DG.PROJECT_CODE               AS BUFFER_ID
               ,'GROUP_DEMAND'                                                                                  AS ATTRIBUTE13 -- 추후에 삭제를 위해
               ,DG.SCM_SITE_ID                                                                                  AS SCM_SITE_ID 
               ,DG.ITEM_ID                                                                                      AS ITEM_ID     
               ,DG.STAGE                                                                                        AS STAGE       
               ,DG.INCOTERMS                                                                                    AS INCOTERMS   
               ,DG.PROJECT_CODE                                                                                 AS PROJECT_CODE
        FROM(
            SELECT  DG.DEMAND_GROUP                                        AS DEMAND_GROUP
                   ,DG.SCM_SITE_ID                                         AS SCM_SITE_ID
                   ,DG.INCOTERMS                                           AS INCOTERMS
                   ,LU.SEGMENT3                                            AS ITEM_ID
                   ,CASE    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'        THEN 'PACKBIZ'
                            WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'        THEN 'MDLEBIZ'
                            WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ'
                            WHEN B.OPERATION_GROUP = 'A'    THEN 'CELLBIZ' 
                    ELSE '-' END                                           AS STAGE
                  ,DG.PROJECT_CODE                                         AS PROJECT_CODE
            FROM(
                SELECT  LU.SEGMENT4   AS DEMAND_GROUP
                       ,DM.ATTRIBUTE1 AS SCM_SITE_ID
                       ,DM.ATTRIBUTE4 AS INCOTERMS
                       ,DM.ATTRIBUTE5 AS PROJECT_CODE
                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL  LU WITH(NOLOCK)
                    LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                    ON  DM.PLAN_ID = @V_PLAN_ID
                    AND DM.ATTRIBUTE2 = LU.SEGMENT3
                    AND DM.ATTRIBUTE5 = LU.SEGMENT5
                WHERE   1=2 -- 2026-03-10, 제약제거
                AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                AND     LU.VALID_YN = 'Y'
                AND     LU.SEGMENT2 = @V_DIVISION_ID
                GROUP BY DM.ATTRIBUTE1, LU.SEGMENT4, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                ) DG
                    INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL  LU WITH(NOLOCK)
                    ON  1=2 -- 2026-03-10, 제약제거
                    AND DG.DEMAND_GROUP = LU.SEGMENT4
                    AND LU.VALID_YN     = 'Y'
                    AND DG.PROJECT_CODE = LU.SEGMENT5 --PROJECT추가
                    AND LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                    AND LU.SEGMENT2 = @V_DIVISION_ID
                    INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                                WHERE  DIVISION_ID = @V_DIVISION_ID  
                    			AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                                   OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                                      )
                               ) B
                    ON    LU.SEGMENT3   = B.ITEM_ID
                    AND   @V_DIVISION_ID= B.DIVISION_ID 
            )DG
        ) A
    WHERE DEMAND_ID IS NOT NULL

        ------------------------------------------------------------------------
        -- 2-2. 기존 DEMAND GROUP에 속한 DEMAND를 TEMP TABLE에 넣음 
        ------------------------------------------------------------------------
        INSERT INTO @DM_TEMP
        SELECT  PLAN_ID
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
               ,LU.SEGMENT4
        FROM    SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            ON  DM.PLAN_ID = @V_PLAN_ID
            AND DM.ATTRIBUTE2 = LU.SEGMENT3
            AND DM.ATTRIBUTE5 = LU.SEGMENT5
        WHERE   1=2 -- 2026-03-10, 제약제거
        AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
        AND     LU.VALID_YN = 'Y'
        AND     LU.SEGMENT2 = @V_DIVISION_ID
        ------------------------------------------------------------------------
        -- 2-3. 기존 DEMAND GROUP에 속한 DEMAND위 키중복 방지와 추후 삭제를 위한 UPDATE
        ------------------------------------------------------------------------
        UPDATE SCP_OPT_ENG_DEMAND_SN SET DEMAND_ID = 'D_'+SCP_OPT_ENG_DEMAND_SN.DEMAND_ID, ATTRIBUTE13 = 'GROUP_DEMAND'
        FROM SCP_OPT_ENG_DEMAND_SN
        INNER JOIN @DM_TEMP AS TMP
        ON  SCP_OPT_ENG_DEMAND_SN.PLAN_ID   = TMP.PLAN_ID
        AND SCP_OPT_ENG_DEMAND_SN.DEMAND_ID = TMP.DEMAND_ID
        ------------------------------------------------------------------------
        -- 2-4. 추가로 만든 GROUP에 대한 DEMAND INSERT
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_DEMAND_SN(
               PLAN_ID
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
        SELECT PLAN_ID             AS PLAN_ID
              ,DEMAND_ID           AS DEMAND_ID
              ,ATTRIBUTE1+'::'+GROUP_ID+'::'+ATTRIBUTE3+'@'+ATTRIBUTE4+'@'+ATTRIBUTE5 AS BUFFER_ID-- INCOTERMS 제외
              ,DEMAND_GROUP        AS DEMAND_GROUP
              ,DUE_DATE            AS DUE_DATE
              ,TARGET_DATE         AS TARGET_DATE
              ,SALES_CUTOFF_DATE   AS SALES_CUTOFF_DATE
              ,EXPIRY_DATE         AS EXPIRY_DATE
              ,PRIORITY            AS PRIORITY
              ,QUANTITY            AS QUANTITY
              ,PRIORITY_GROUP      AS PRIORITY_GROUP
              ,CUSTOMER_ID         AS CUSTOMER_ID
              ,ALLOW_SHORT         AS ALLOW_SHORT
              ,ATTRIBUTE1          AS ATTRIBUTE1 
              ,GROUP_ID            AS ATTRIBUTE2
              ,ATTRIBUTE3          AS ATTRIBUTE3
              ,ATTRIBUTE4          AS ATTRIBUTE4
              ,ATTRIBUTE5          AS ATTRIBUTE5
              ,ATTRIBUTE6          AS ATTRIBUTE6
              ,ATTRIBUTE7          AS ATTRIBUTE7
              ,ATTRIBUTE8          AS ATTRIBUTE8
              ,ATTRIBUTE9          AS ATTRIBUTE9
              ,ATTRIBUTE10         AS ATTRIBUTE10
              ,ATTRIBUTE11         AS ATTRIBUTE11
              ,'DEMAND_GROUP'      AS ATTRIBUTE12
              ,ATTRIBUTE13         AS ATTRIBUTE13
              ,ATTRIBUTE14         AS ATTRIBUTE14
              ,ATTRIBUTE15         AS ATTRIBUTE15
        FROM @DM_TEMP

    ------------------------------------------------------------------------
    -- 2. DEMAND Target Date Update
	--     2025.03.24 Bloack Target Date & Add Monlty Block for Speed
    -- 2025.07.24 Philsu Park: DemandTargetDate LOOKUP 관리형태를 YMD 로 변경.
    ------------------------------------------------------------------------
	
    UPDATE SCP_OPT_ENG_DEMAND_SN SET SCP_OPT_ENG_DEMAND_SN.TARGET_DATE = TD.TARGET_DATE
    FROM SCP_OPT_ENG_DEMAND_SN
    INNER JOIN (
                SELECT DM.DEMAND_ID
                      --,CASE WHEN TG.TYPE = 'MONTH' THEN CAL.LAST_MM_DAY
                      --      WHEN TG.TYPE = 'WEEK'  THEN CAL.LAST_WW_DAY
                      -- END AS TARGET_DATE
                      ,CASE WHEN DM.DEMAND_GROUP = 'SF' THEN NULL
                            WHEN TG.TYPE = 'MONTH' THEN IIF(CAL.LAST_MM_DAY>@V_PLAN_END_YYYYMMDD_ORI, @V_PLAN_END_YYYYMMDD_ORI,CAL.LAST_MM_DAY ) 
                            WHEN TG.TYPE = 'WEEK'  THEN IIF(CAL.LAST_WW_DAY>@V_PLAN_END_YYYYMMDD_ORI, @V_PLAN_END_YYYYMMDD_ORI,CAL.LAST_WW_DAY ) 
                       END AS TARGET_DATE
                FROM SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                INNER JOIN (
                            SELECT SITE_ID
                                  ,ITEM_ID
                                  ,FROM_YMD
                                  ,TO_YMD
                                  ,TYPE
                            FROM(
                                SELECT LU.SEGMENT3   AS SITE_ID
                                      ,LU.SEGMENT4   AS ITEM_ID
                                      ,IIF(LU.ATTRIBUTE1 = '', @V_PLAN_START_YYYYMMDD, LU.ATTRIBUTE1) AS FROM_YMD
                                      ,IIF(LU.ATTRIBUTE2 = '', @V_PLAN_END_YYYYMMDD_ORI, LU.ATTRIBUTE2) AS TO_YMD
                                      ,LU.SEGMENT5   AS TYPE

                                FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                    LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU2 WITH(NOLOCK)
                                        ON  1=2 -- 2026-03-10, 제약제거
                                        AND LU2.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND LU.SEGMENT1 = LU2.SEGMENT2
                                        AND LU.SEGMENT4 = LU2.SEGMENT3
                                        AND LU2.VALID_YN ='Y'
                                WHERE 1=1
                                AND   LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_DEMAND_TARGETDATE'
                                AND   LU.SEGMENT1 = @V_DIVISION_ID
                                AND   LU.SEGMENT2 = @V_GROUP_ID
                                AND   LU.VALID_YN  ='Y'
                                UNION ALL
                                SELECT LU.SEGMENT3   AS SITE_ID
                                      ,LU2.SEGMENT4  AS ITEM_ID
                                      ,IIF(LU.ATTRIBUTE1 = '', @V_PLAN_START_YYYYMMDD, LU.ATTRIBUTE1) AS FROM_YMD
                                      ,IIF(LU.ATTRIBUTE2 = '', @V_PLAN_END_YYYYMMDD_ORI, LU.ATTRIBUTE2) AS TO_YMD
                                      ,LU.SEGMENT5   AS TYPE
                                FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                    LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU2 WITH(NOLOCK)
                                        ON  1=2 -- 2026-03-10, 제약제거
                                        AND LU2.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND LU.SEGMENT1 = LU2.SEGMENT2
                                        AND LU.SEGMENT4 = LU2.SEGMENT3
                                        AND LU2.VALID_YN ='Y'
                                WHERE 1=1
                                AND   LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_DEMAND_TARGETDATE'
                                AND   LU.SEGMENT1 = @V_DIVISION_ID
                                AND   LU.SEGMENT2 = @V_GROUP_ID
                                AND   LU.VALID_YN  ='Y'
                                ) TG
                            WHERE SITE_ID IS NOT NULL
                            GROUP BY SITE_ID, ITEM_ID, FROM_YMD, TO_YMD, TYPE
                            ) TG
                ON  DM.PLAN_ID = @V_PLAN_ID
                AND DM.ATTRIBUTE1 = TG.SITE_ID
                AND DM.ATTRIBUTE2 = TG.ITEM_ID
                INNER JOIN (
                            SELECT   CAL.BASIS_YYYYMMDD
                                    ,CASE WHEN CONVERT(INT,CAL.ISO_WEEK) - @V_START_WEEK <0 THEN CONVERT(INT,CAL.ISO_WEEK)+52 - @V_START_WEEK
                                     ELSE CONVERT(INT,CAL.ISO_WEEK) - @V_START_WEEK
                                     END                                                                         AS PLAN_WEEK  
                                    ,CAL.BASIS_END_DATE                                                          AS LAST_WW_DAY
                                    ,CONVERT(NVARCHAR(8),DATEADD(DAY,-1,DATEADD(MONTH,1,BASIS_YYYYMM+'01')),112) AS LAST_MM_DAY
                            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK) 
                            WHERE   CAL.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD
                            AND     CAL.BASIS_YYYYMMDD <=  @V_PLAN_END_YYYYMMDD_ORI
                            ) CAL
                ON  DM.DUE_DATE = CAL.BASIS_YYYYMMDD
                AND CAL.BASIS_YYYYMMDD BETWEEN TG.FROM_YMD AND TG.TO_YMD
                ) TD
    ON  SCP_OPT_ENG_DEMAND_SN.PLAN_ID   = @V_PLAN_ID
    AND SCP_OPT_ENG_DEMAND_SN.DEMAND_ID = TD.DEMAND_ID
	

    ------------------------------------------------------------------------
    -- Data Insert End
    ------------------------------------------------------------------------


    ------------------------------------------------------------------------
    -- Data Delete
    -- 2025.08.12 Philsu Park: Workbench에서 0으로 들어온 케이스 제외.
    ------------------------------------------------------------------------
    DELETE  DT
    from    SCP_OPT_ENG_DEMAND_SN DT
    WHERE   DT.PLAN_ID  = @V_PLAN_ID
    AND     DT.QUANTITY = 0
    ;

	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------
      -- ERROR LOG
	------------------------------------------------------------------------
        SET @V_MESSAGE_TEXT = CAST('ERR_LINE : '+CONVERT(NVARCHAR(100),ERROR_LINE())+', ERR_MSG : '+ERROR_MESSAGE() AS NVARCHAR(MAX));
        --SET @V_MESSAGE_TEXT = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'ERROR',NULL,@V_MESSAGE_TEXT,NULL,@V_PLAN_ID
        ------------------------------------------------------------------------
        SELECT @V_DETAIL_DATE = GETDATE()
        ------------------------------------------------------------------------
        --EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,@V_DETAIL_DATE,NULL,@V_MESSAGE_TEXT,'ERROR'
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
        --EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL
    END
    ------------------------------------------------------------------------
  END;
