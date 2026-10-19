

--EXEC PR_SCP_OPT_ENG_INPUT_DEMAND 'PLAN_ID_001'
CREATE   PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_DEMAND]
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_DEMAND';
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

	-- 2026.07.27 Minyong Lee : [E20260715-001109] 최적화 엔진 Demand Netting 및 수요 우선순위 기능 요청
    -- [RTF Pegging]
    DECLARE @V_PEG_TYPE           NVARCHAR(1);
    DECLARE @V_NET_START_YYYYMMDD NVARCHAR(8);
    DECLARE @V_RTF_PLAN_SEQ       NVARCHAR(8);

    -- [Demand Priority]
    DECLARE @V_DMD_PRIO_YN  NVARCHAR(1);
    DECLARE @V_DP_NEAR_DAYS INT;

    -- [신규 우선순위 방식] RTF Pegging / Demand Priority 중 하나라도 설정 시 'Y'
    DECLARE @V_NEW_PRIO_YN  NVARCHAR(1);

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
    SELECT  SEGMENT3 AS SALES_SITE_ID
           ,SEGMENT4 AS ITEM_ID
    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
    AND     SEGMENT1 = @V_DIVISION_ID
    AND     SEGMENT2 = @V_GROUP_ID
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
    -- [신규 우선순위 방식] 제약 설정 로드 (Plan Group 단위)
    --   RTF Pegging  : SCP_OPT_ENG_RTF_PEGGING          (Type A/B/C)
    --   Demand Prio  : SCP_OPT_ENG_CONST_DEMAND_PRIORITY
    --   두 룩업은 항상 함께 사용하는 것이 전제이며, 하나라도 설정되면 아래 기존 제약을 무력화한다.
    --     SCP_OPMZ_SALES_SITE_PRIORITY / SCP_OPT_ELEC_DEMAND_BUNDLE / SCP_OPT_ENG_CONST_DEMAND_TARGETDATE
    --   (한쪽만 설정된 것은 설정 오류이며, PRIORITY_GROUP 의 '-' 로 식별 가능하게 한다)
    ------------------------------------------------------------------------
    SELECT  @V_PEG_TYPE = MAX(SEGMENT3)
    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_RTF_PEGGING'
    AND     SEGMENT1    = @V_DIVISION_ID
    AND     SEGMENT2    = @V_GROUP_ID
    AND     VALID_YN    = 'Y'
    ;

    SELECT  @V_DMD_PRIO_YN = CASE WHEN COUNT(*) > 0 THEN 'Y' ELSE 'N' END
    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_PRIORITY'
    AND     SEGMENT1    = @V_DIVISION_ID
    AND     SEGMENT2    = @V_GROUP_ID
    AND     VALID_YN    = 'Y'
    ;

    SET     @V_NEW_PRIO_YN = CASE WHEN @V_PEG_TYPE IS NOT NULL OR @V_DMD_PRIO_YN = 'Y' THEN 'Y' ELSE 'N' END;

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
            
        WHERE   DA.VERSION_NO      = @V_DM_MAX_VERSION
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
        OPTION (RECOMPILE) ;
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
                         ,TP.PRIORITY          AS PRIORITY
                         , A.FCST_TYPE                                                                  AS FCST_TYPE
                         , A.PROJECT_CODE                                                               AS PROJECT_CODE
                         , A.CELL_PROD_SITE_ID                                                          AS CELL_PROD_SITE_ID
                   FROM DM_PLN_NET_DEMAND A WITH (NOLOCK)
                   ------------------------------------------------------------------------
                       INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                   FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                                   WHERE  DIVISION_ID = @V_DIVISION_ID  
	    				        AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                                      OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                                         )
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
                   --AND     A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
                   --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                   --                   WHERE   PLAN_ID = @V_PLAN_ID
                   --                 )
                   --소형 생산지 구분을 위한 분리
                   AND ((@V_DIVISION_ID = '40'
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
                   ) 
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
			 OPTION (RECOMPILE) ;
    ------------------------------------------------------------------------
    -- 2. Shipment Plan Semi => Demand Insert : 소형 - Cell Plant 의 CHAR Stage에 Demand 처리
    -- 2025.05.07 Philsu Park: SHIPTMENT_SNAPSHOT_COUNT > 0 일 때는 해당 데이터 사용, 아닐때는 기존 로직으로 분기.
    ------------------------------------------------------------------------
    IF @V_DIVISION_ID = '40'
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
						 		 OPTION (RECOMPILE) ;
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
        OPTION (RECOMPILE) ;
            END -- IF @V_DIVISION_ID = '40'


    ------------------------------------------------------------------------
    -- 2. 수요 묶음.
    ------------------------------------------------------------------------

    PRINT ('4. Demand Merge Type Update: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));
    ----------------------------------------------------------------------------
    -- 2025.06.09 Philsu Park
    -- Demand 뭉치기 대상 마킹을 위한 Temp Update.
    -- [RTF Pegging] Pegging 적용 Plan Group 의 고객향 수요(STAGE '%BIZ')는 수요 묶음 미적용(양립 불가) → 'X' 마킹
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
                        WHERE   LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
                        AND     VALID_YN      = 'Y'
                        AND     SEGMENT2      = @V_DIVISION_ID
                        AND     SEGMENT3      = @V_GROUP_ID
                        ) LK
        ON  LK.SITE_ID      = DM.ATTRIBUTE1
        AND LK.ITEM_ID      = DM.ATTRIBUTE2
        AND LK.STAGE        = DM.ATTRIBUTE3
        AND DM.DUE_DATE    >= @V_PROD_FROZEN_END_YMD
        AND @V_NEW_PRIO_YN = 'N'   -- 신규 우선순위 방식 적용 시 수요 묶음 전면 미적용
    WHERE   DM.PLAN_ID      = @V_PLAN_ID
    ;


    PRINT ('4.0. Site Move Demand Adjust: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));
    ----------------------------------------------------------------------------
    -- 2026.08.13 Minyong Lee : [E20260818-000193] [최적화 알고리즘] 사이트간 물량 이관 반영
    --   룩업(SCP_OPT_ENG_CONST_SITE_MOVE) x 이관실행 확정분(SCP_SNRO_PLAN_STE_TRSF_M_SN) 기반
    --   기준 플랜 : 현재 플랜과 같은 PLAN 주차 + FROM Plan Group 의 MAX(EGN_PLAN_ID) 1건
    --              (차감/증량 양측이 같은 기준 플랜을 참조하므로 총량 정합 보장)
    --   처리 순서 : 선차감(내 그룹=SEG6) -> 후증량(내 그룹=SEG1). ORIGIN 백업 전 반영.
    --   매칭 키   : SEG6=FROM그룹, SEG1=TO그룹(OPMZ_PLAN_GR_NM), SEG3=TO_STE_ID, SEG9=FERT_CD
    --              매칭 실패 행은 스킵(로그 없음).
    --   위치      : [신규 우선순위 방식] 블록보다 앞에 배치 - 증량 수요도 Demand Priority
    --              (PRIORITY/PRIORITY_GROUP 계산) 및 후속 RTF Pegging(CF/NF)을 동일하게 적용받기 위함.
    --              (신규 우선순위 미적용 그룹에서는 증량 수요의 PRIORITY 계열이 NULL 로 유지됨)
    --   * 소형(40) 전용. 자동차(81) 미적용. (전극은 PR_SCP_OPT_ENG_EE_INPUT_DEMAND 에 별도 반영)
    ----------------------------------------------------------------------------
    IF @V_DIVISION_ID = '40'
    BEGIN
        IF OBJECT_ID('TEMPDB..#SM_TRSF_RESOLVED') IS NOT NULL DROP TABLE #SM_TRSF_RESOLVED;
        IF OBJECT_ID('TEMPDB..#SM_MINUS_MARK')    IS NOT NULL DROP TABLE #SM_MINUS_MARK;

        -- 차감 발생 행 기록 (프로시저 말미에 DEMAND_SN.UPDATE_ID='SITE_MOVE' 마킹용)
        CREATE TABLE #SM_MINUS_MARK (DEMAND_ID NVARCHAR(200) NOT NULL);

        ------------------------------------------------------------------------
        -- 4.0.1 기준 플랜 해석 + 룩업 매칭
        --   (디버깅: #SM_TRSF_RESOLVED 만 조회하면 현재 플랜에 적용되는 세팅 전체 확인 가능)
        ------------------------------------------------------------------------
        SELECT  BP.EGN_PLAN_ID
               ,BP.FROM_PLAN_GROUP
               ,TRSF.OPMZ_PLAN_GR_NM                                                   AS TO_PLAN_GROUP
               ,TRSF.PLAN_YYWK
               ,WK.WEEK_START
               ,WK.WEEK_END
               ,TRSF.FERT_CD
               ,CONVERT(NUMERIC(20,10), ISNULL(TRSF.NEW_FROM_QTY, TRSF.FROM_PSBL_QTY)) AS MOVE_QTY
               ,LU.SEGMENT2                                                            AS TO_SITE_DEMAND
               ,LU.SEGMENT3                                                            AS TO_SITE_SUPPLY
               ,LU.SEGMENT4                                                            AS TO_ITEM
               -- SEG5 = '-' 는 SUFFIX 없음(가상코드 미생성, 기존 코드 SEG4 로 증량)
               ,IIF(ISNULL(LU.SEGMENT5, '-') = '-', '', LU.SEGMENT5)                   AS ITEM_SUFFIX
               ,LU.SEGMENT4 + IIF(ISNULL(LU.SEGMENT5, '-') = '-', '', LU.SEGMENT5)     AS VIRTUAL_ITEM
               ,LU.SEGMENT7                                                            AS FROM_SITE_DEMAND
               ,LU.SEGMENT8                                                            AS FROM_SITE_SUPPLY
               ,ISNULL(TRY_CAST(LU.ATTRIBUTE1 AS INT), 0)                              AS LT_OFFSET_WEEK
               -- 증량 반영일: 이동 주차에서 ATTB1 주 선행한 월요일.
               -- 2026.08.14 : 반영일이 계획시작(PSD) 이전이면 구간 이탈로 보고 미반영 (4.0.3 에서 제외. PSD 클리핑 방식 폐기)
               ,CONVERT(NVARCHAR(8), DATEADD(DAY, -7 * ISNULL(TRY_CAST(LU.ATTRIBUTE1 AS INT), 0), CONVERT(DATE, WK.WEEK_START, 112)), 112) AS PLUS_DUE_DATE
        INTO    #SM_TRSF_RESOLVED
        FROM    SCP_SNRO_PLAN_STE_TRSF_M_SN TRSF WITH(NOLOCK)
        INNER JOIN (
                    -- 현재 플랜과 같은 PLAN 주차(ISO 주차 기준)의 FROM Plan Group 별 MAX(EGN_PLAN_ID)
                    SELECT  PGM.OPMZ_PLAN_GR_NAME AS FROM_PLAN_GROUP
                           ,MAX(T.EGN_PLAN_ID)    AS EGN_PLAN_ID
                    FROM   (SELECT DISTINCT EGN_PLAN_ID
                            FROM   SCP_SNRO_PLAN_STE_TRSF_M_SN WITH(NOLOCK)
                            WHERE  CHO_YN = 'Y' AND FROM_YN = 'Y') T
                    INNER JOIN SCP_OPMZ_PLAN_M PM WITH(NOLOCK)
                        ON  PM.OPMZ_PLAN_ID = T.EGN_PLAN_ID
                    INNER JOIN SCP_OPMZ_PLAN_GR_M PGM WITH(NOLOCK)
                        ON  PM.OPMZ_PLAN_GR_ID = PGM.OPMZ_PLAN_GR_ID
                    INNER JOIN SCM_SYS_CALENDAR_M C1 WITH(NOLOCK)
                        ON  C1.BASIS_YYYYMMDD = PM.PLAN_START_YYYYMMDD
                    INNER JOIN SCM_SYS_CALENDAR_M C2 WITH(NOLOCK)
                        ON  C2.BASIS_YYYYMMDD = @V_PLAN_START_YYYYMMDD
                        AND C2.ISO_YYYYWW     = C1.ISO_YYYYWW      -- 같은 PLAN 주차
                    GROUP BY PGM.OPMZ_PLAN_GR_NAME
                   ) BP
            ON  TRSF.EGN_PLAN_ID = BP.EGN_PLAN_ID
        INNER JOIN (
                    -- 수요 증감에 필요한 키(SEG1~9, ATTB1)만 DISTINCT.
                    -- 금지호기(ATTB2~4)만 다른 다건 룩업(예. COATING/ELEC_POST 이중 차단 세팅)이
                    -- 있어도 수요가 배수로 잡히지 않도록 함. 금지호기는 SITE_MOVE 프로시저에서 합집합 처리.
                    SELECT  DISTINCT
                            SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                           ,SEGMENT6, SEGMENT7, SEGMENT8, SEGMENT9, ATTRIBUTE1
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SITE_MOVE'
                    AND     VALID_YN    = 'Y'
                   ) LU
            ON  LU.SEGMENT6    = BP.FROM_PLAN_GROUP      -- FROM Plan Group
            AND LU.SEGMENT1    = TRSF.OPMZ_PLAN_GR_NM    -- TO Plan Group
            AND LU.SEGMENT3    = TRSF.TO_STE_ID          -- TO 생산 사이트
            AND LU.SEGMENT9    = TRSF.FERT_CD            -- 차감 모델
        INNER JOIN (
                    SELECT  ISO_YYYYWW
                           ,MIN(BASIS_YYYYMMDD) AS WEEK_START   -- 해당 주차 월요일
                           ,MAX(BASIS_YYYYMMDD) AS WEEK_END
                    FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK)
                    GROUP BY ISO_YYYYWW
                   ) WK
            ON  WK.ISO_YYYYWW = TRSF.PLAN_YYWK
        WHERE   TRSF.CHO_YN  = 'Y'
        AND     TRSF.FROM_YN = 'Y'
        AND     ISNULL(TRSF.NEW_FROM_QTY, TRSF.FROM_PSBL_QTY) > 0
        AND     (BP.FROM_PLAN_GROUP = @V_GROUP_ID OR TRSF.OPMZ_PLAN_GR_NM = @V_GROUP_ID)  -- 내가 차감 또는 증량 당사자
        ;

        ------------------------------------------------------------------------
        -- 4.0.2 수요 차감 (내 그룹 = FROM Plan Group)
        --   대상: ATTRIBUTE2(ITEM) = FERT_CD, DUE_DATE 가 이동 주차(월~일) 내. DEMAND_GROUP 무관.
        --   순서: SEG7 사이트 선차감 -> 그 외 사이트 사전식. 사이트 내 DUE_DATE, DEMAND_ID 오름차순.
        --   부족 시 0까지만 차감(로그/이월 없음). 0이 된 행은 후속 4.1 로직이 삭제.
        --   * 같은 (주차,모델) 풀에 SEG7 이 서로 다른 룩업이 공존하면 MIN(SEG7)을 선차감 사이트로
        --     사용함 (실사용상 비대상 케이스로 판단, 발생 시 별도 검토 필요)
        ------------------------------------------------------------------------
        ;WITH DED AS (
            SELECT  PLAN_YYWK
                   ,WEEK_START
                   ,WEEK_END
                   ,FERT_CD
                   ,MIN(FROM_SITE_DEMAND) AS FIRST_SITE
                   ,SUM(MOVE_QTY)         AS DED_QTY
            FROM    #SM_TRSF_RESOLVED
            WHERE   FROM_PLAN_GROUP = @V_GROUP_ID
            GROUP BY PLAN_YYWK, WEEK_START, WEEK_END, FERT_CD
        )
        , ALLOC AS (
            SELECT  DM.DEMAND_ID
                   ,DM.QUANTITY
                   ,DED.DED_QTY
                   ,SUM(DM.QUANTITY) OVER (PARTITION BY DED.PLAN_YYWK, DED.FERT_CD
                                           ORDER BY IIF(DM.ATTRIBUTE1 = DED.FIRST_SITE, 0, 1)  -- SEG7 선차감
                                                   ,DM.ATTRIBUTE1                              -- 이후 사이트 사전식
                                                   ,DM.DUE_DATE
                                                   ,DM.DEMAND_ID
                                           ROWS UNBOUNDED PRECEDING) AS CUM_QTY
            FROM    @DM_INS_TEMP DM
            INNER JOIN DED
                ON  DM.ATTRIBUTE2 = DED.FERT_CD
                AND DM.DUE_DATE  >= DED.WEEK_START
                AND DM.DUE_DATE  <= DED.WEEK_END
            WHERE   DM.PLAN_ID = @V_PLAN_ID
        )
        UPDATE  ALLOC
        SET     QUANTITY = CASE WHEN CUM_QTY <= DED_QTY THEN 0            -- 전량 차감
                                ELSE CUM_QTY - DED_QTY END                -- 부분 차감 (잔여량)
        OUTPUT  INSERTED.DEMAND_ID INTO #SM_MINUS_MARK (DEMAND_ID)
        WHERE   CUM_QTY - QUANTITY < DED_QTY                              -- 실제 차감 발생 행만
        ;

        ------------------------------------------------------------------------
        -- 4.0.3 수요 증량 (내 그룹 = TO Plan Group)
        --   기존 행 유무와 무관하게 항상 별도 행 INSERT. 가상코드(SEG4+SEG5) 기준.
        --   STAGE/INCOTERMS/PROJECT 는 동일 (TO 수요 사이트, 원본 모델)의 기존 수요 행에서 상속.
        --   (ITEM_SITE 는 본 프로시저 이후에 생성되므로 참조 불가 -> 수요 행이 원천 데이터)
        --   TO 사이트에 원본 모델(SEG4)의 기존 수요가 없으면 '-' 로 생성 (확정)
        ------------------------------------------------------------------------
        INSERT INTO @DM_INS_TEMP
            (PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
            ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
            ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
            ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
            )
        SELECT  @V_PLAN_ID
               ,RSV.TO_SITE_DEMAND+'::'+RSV.VIRTUAL_ITEM+'::'+GRD.STAGE+'@'+GRD.INCOTERMS+'@'+GRD.PROJECT_CODE
                    +'::'+RSV.PLUS_DUE_DATE+'::-::SITE_MOVE::'+RSV.FROM_SITE_DEMAND    AS DEMAND_ID
               ,RSV.TO_SITE_DEMAND+'::'+RSV.VIRTUAL_ITEM+'::'+GRD.STAGE+'@'+GRD.INCOTERMS+'@'+GRD.PROJECT_CODE
                                                                                       AS BUFFER_ID
               -- 2026.09.03 Minyong Lee : 구방식(TOSITE_PRIORITY) 분기 대응 - 우선순위 3종을 기존 모델
               --   수요에서 상속 (기존 수요 부재 시 NULL). 신규 우선순위 분기에서는 후속 UPDATE 가 전 행을
               --   재산출하므로 이 상속값은 구방식일 때만 효력이 남음.
               ,GRD0.DEMAND_GROUP                                                      AS DEMAND_GROUP
               ,RSV.PLUS_DUE_DATE                                                      AS DUE_DATE
               ,NULL                                                                   AS TARGET_DATE
               ,NULL                                                                   AS SALES_CUTOFF_DATE
               ,NULL                                                                   AS EXPIRY_DATE
               ,GRD0.PRIORITY                                                          AS PRIORITY
               ,SUM(RSV.MOVE_QTY)                                                      AS QUANTITY
               ,GRD0.PRIORITY_GROUP                                                    AS PRIORITY_GROUP
               ,NULL                                                                   AS CUSTOMER_ID
               ,NULL                                                                   AS ALLOW_SHORT
               ,RSV.TO_SITE_DEMAND                                                     AS ATTRIBUTE1
               ,RSV.VIRTUAL_ITEM                                                       AS ATTRIBUTE2
               ,GRD.STAGE                                                              AS ATTRIBUTE3
               ,GRD.INCOTERMS                                                          AS ATTRIBUTE4
               ,GRD.PROJECT_CODE                                                       AS ATTRIBUTE5
               ,NULL                                                                   AS ATTRIBUTE6
               ,NULL                                                                   AS ATTRIBUTE7
               ,'SITE_MOVE'                                                            AS ATTRIBUTE8
               ,NULL                                                                   AS ATTRIBUTE9
               ,NULL                                                                   AS ATTRIBUTE10
               ,NULL                                                                   AS ATTRIBUTE11
               ,NULL                                                                   AS ATTRIBUTE12
               ,NULL                                                                   AS ATTRIBUTE13
               ,NULL                                                                   AS ATTRIBUTE14
               -- 'X' = 뭉치기 비대상 표준값. 최종 INSERT 의 ATTRIBUTE15 NOT IN ('A','B','C','D') 필터가
               -- NULL 을 탈락시키므로(3치 논리) NULL 불가 - 반드시 'X' 로 세팅해야 DEMAND_SN 에 반영됨
               ,'X'                                                                    AS ATTRIBUTE15
        FROM    #SM_TRSF_RESOLVED RSV
        OUTER APPLY (
                    SELECT  TOP 1
                            D2.ATTRIBUTE3 AS STAGE
                           ,D2.ATTRIBUTE4 AS INCOTERMS
                           ,D2.ATTRIBUTE5 AS PROJECT_CODE
                           -- 2026.09.03 Minyong Lee : 우선순위 3종도 같은 행에서 상속 (구방식 분기용)
                           ,D2.PRIORITY
                           ,D2.PRIORITY_GROUP
                           ,D2.DEMAND_GROUP
                    FROM    @DM_INS_TEMP D2
                    WHERE   D2.PLAN_ID    = @V_PLAN_ID
                    AND     D2.ATTRIBUTE1 = RSV.TO_SITE_DEMAND
                    AND     D2.ATTRIBUTE2 = RSV.TO_ITEM
                    ORDER BY D2.ATTRIBUTE3, D2.ATTRIBUTE4, D2.ATTRIBUTE5, D2.DUE_DATE  -- 결정적 선택
                    ) GRD0
        CROSS APPLY (
                    SELECT  ISNULL(GRD0.STAGE       , '-') AS STAGE                    -- 기존 수요 부재 시 '-'
                           ,ISNULL(GRD0.INCOTERMS   , '-') AS INCOTERMS
                           ,ISNULL(GRD0.PROJECT_CODE, '-') AS PROJECT_CODE
                    ) GRD
        WHERE   RSV.TO_PLAN_GROUP = @V_GROUP_ID
        AND     RSV.PLUS_DUE_DATE >= @V_PLAN_START_YYYYMMDD   -- 계획구간 이전으로 선행된 수량은 미반영 (구간 이탈)
        GROUP BY RSV.TO_SITE_DEMAND, RSV.VIRTUAL_ITEM, RSV.PLUS_DUE_DATE, RSV.FROM_SITE_DEMAND
                ,GRD.STAGE, GRD.INCOTERMS, GRD.PROJECT_CODE
                ,GRD0.PRIORITY, GRD0.PRIORITY_GROUP, GRD0.DEMAND_GROUP
        ;

    END -- IF @V_DIVISION_ID = '40' (SITE_MOVE 수요 증감)

	-- 2026.07.27 Minyong Lee : [E20260715-001109] 최적화 엔진 Demand Netting 및 수요 우선순위 기능 요청
    ----------------------------------------------------------------------------
    -- [신규 우선순위 방식] 기존 SALES_SITE_PRIORITY 로직 전면 무력화 + 신규 기준 세팅
    --   DEMAND_GROUP : NULL / PRIORITY : 1   (수요 유형 무관 공통)
    --   PRIORITY_GROUP
    --     - 고객향 수요(STAGE '%BIZ') : <Lv>::<NEAR|FAR>::<STAGE>
    --                                   (+ RTF Pegging 미적용 시 '::-' , 적용 시 Pegging 에서 '::Y|N')
    --         Lv       : 룩업 4키(ITEM+TO_SITE+PROJECT+STAGE) 정확 일치 시 ATTRIBUTE2, 미일치 시 3순위
    --         NEAR/FAR : DATEDIFF(DAY, PSD, DUE) < 기준일수 → NEAR
    --                    기준일수 = (PLAN_GR+ITEM) MAX(ATTRIBUTE1), ITEM 미등록 시 PLAN_GR MAX(ATTRIBUTE1)
    --     - 외주패커향 수요(그 외)     : 'P'  (신규 우선순위 그룹 체계의 대상이 아니므로 엔진에서 별도 처리)
    ----------------------------------------------------------------------------
    IF @V_NEW_PRIO_YN = 'Y'
    BEGIN
        IF OBJECT_ID('TEMPDB..#DP_LK')  IS NOT NULL DROP TABLE #DP_LK;
        IF OBJECT_ID('TEMPDB..#DP_DAY') IS NOT NULL DROP TABLE #DP_DAY;

        SELECT  SEGMENT3 AS ITEM_ID, SEGMENT4 AS TO_SITE, SEGMENT5 AS PROJECT_CODE, SEGMENT6 AS STAGE
              , MIN(ATTRIBUTE2)                  AS PRIORITY_LVL     -- 중복 등록 시 상위(작은) 순위
              , MAX(TRY_CAST(ATTRIBUTE1 AS INT)) AS NEAR_DAYS
        INTO    #DP_LK
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_PRIORITY'
        AND     SEGMENT1    = @V_DIVISION_ID
        AND     SEGMENT2    = @V_GROUP_ID
        AND     VALID_YN    = 'Y'
        GROUP BY SEGMENT3, SEGMENT4, SEGMENT5, SEGMENT6
        ;

        SELECT  ITEM_ID, MAX(NEAR_DAYS) AS NEAR_DAYS
        INTO    #DP_DAY
        FROM    #DP_LK GROUP BY ITEM_ID
        ;
        SELECT  @V_DP_NEAR_DAYS = MAX(NEAR_DAYS) FROM #DP_LK;

        UPDATE  DM
        SET     DM.DEMAND_GROUP   = NULL
              , DM.PRIORITY       = 1
              , DM.ATTRIBUTE6     = CASE WHEN @V_DMD_PRIO_YN = 'Y' AND DM.ATTRIBUTE3 LIKE '%BIZ' THEN NF.NEAR_FAR   ELSE DM.ATTRIBUTE6 END
              , DM.ATTRIBUTE7     = CASE WHEN @V_DMD_PRIO_YN = 'Y' AND DM.ATTRIBUTE3 LIKE '%BIZ' THEN DM.ATTRIBUTE3 ELSE DM.ATTRIBUTE7 END
              , DM.PRIORITY_GROUP =
                    CASE WHEN DM.ATTRIBUTE3 NOT LIKE '%BIZ'
                         THEN 'P'                                              -- 외주패커향 수요
                         ELSE ( CASE WHEN @V_DMD_PRIO_YN = 'Y'
                                     THEN ISNULL(LK.PRIORITY_LVL,'3') + '::' + NF.NEAR_FAR + '::' + DM.ATTRIBUTE3
                                     ELSE '-::-::-' END )
                            -- 2026.09.03 Minyong Lee : SITE_MOVE 증량 수요는 전주 약속물량이 아니므로
                            --   약속여부 'N' 고정 (RTF Pegging 분할 대상에서도 제외 - #NET_DMD 필터 참조)
                            + ( CASE WHEN @V_PEG_TYPE IS NULL THEN '::-'
                                     WHEN DM.ATTRIBUTE8 = 'SITE_MOVE' THEN '::N'
                                     ELSE '' END )
                    END
        FROM    @DM_INS_TEMP DM
        -- 2026.09.03 Minyong Lee : SITE_MOVE 가상코드는 원본모델로 역매핑하여 우선순위 룩업(Lv/기준일수)을
        --   원본과 동일 기준으로 매칭 (NEAR/FAR 판정 자체는 증량 행의 DUE_DATE 기준)
        LEFT JOIN (SELECT DISTINCT SEGMENT4 + SEGMENT5 AS VIRT_ITEM, SEGMENT4 AS ORIG_ITEM
                   FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                   WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SITE_MOVE' AND VALID_YN = 'Y'
                   AND    ISNULL(SEGMENT5, '-') <> '-') SM
            ON  SM.VIRT_ITEM  = DM.ATTRIBUTE2
            AND DM.ATTRIBUTE8 = 'SITE_MOVE'
        LEFT JOIN #DP_LK LK
            ON  LK.ITEM_ID      = ISNULL(SM.ORIG_ITEM, DM.ATTRIBUTE2)
            AND LK.TO_SITE      = DM.ATTRIBUTE1
            AND LK.PROJECT_CODE = DM.ATTRIBUTE5
            AND LK.STAGE        = DM.ATTRIBUTE3
        LEFT JOIN #DP_DAY D
            ON  D.ITEM_ID       = ISNULL(SM.ORIG_ITEM, DM.ATTRIBUTE2)
        CROSS APPLY ( SELECT CASE WHEN DATEDIFF(DAY, CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD, 112), CONVERT(DATETIME, DM.DUE_DATE, 112))
                                       < ISNULL(D.NEAR_DAYS, @V_DP_NEAR_DAYS)
                                  THEN 'NEAR' ELSE 'FAR' END AS NEAR_FAR ) NF
        WHERE   DM.PLAN_ID = @V_PLAN_ID
        ;

        IF OBJECT_ID('TEMPDB..#DP_LK')  IS NOT NULL DROP TABLE #DP_LK;
        IF OBJECT_ID('TEMPDB..#DP_DAY') IS NOT NULL DROP TABLE #DP_DAY;
    END


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

    
    ------------------------------------------------------------------------
	-- 2026.07.27 Minyong Lee : [E20260715-001109] 최적화 엔진 Demand Netting 및 수요 우선순위 기능 요청
    -- RTF Pegging (고객향 수요 = STAGE 가 'BIZ' 로 끝나는 수요 대상) START
    --   룩업 SCP_OPT_ENG_RTF_PEGGING 에 설정된 Plan Group 만 수행. Type A/B/C 공통 로직.
    --   전주 FN RTF(FG/ALLOCATION) 와 이번주 고객향 수요를 Pegging 하여 CF/NF 로 분리. (반제품 CHAR 등은 제외)
    ------------------------------------------------------------------------
    IF @V_PEG_TYPE IS NOT NULL
    BEGIN
        -- 팀별 BOUNDARY (A/C: '-' 1건 / B: 팀별 다건 + '-')
        IF OBJECT_ID('TEMPDB..#PEG_CFG') IS NOT NULL DROP TABLE #PEG_CFG;
        SELECT SEGMENT4 AS TEAM, ATTRIBUTE1 AS BOUNDARY
        INTO   #PEG_CFG
        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_RTF_PEGGING'
        AND    SEGMENT1    = @V_DIVISION_ID
        AND    SEGMENT2    = @V_GROUP_ID
        AND    VALID_YN    = 'Y'
        ;

        -- 품목→팀 매핑 (Type B). 키 = DIV + TO_SITE + ITEM. 룩업 미등록/NULL 팀은 제거 → '-' 폴백
        IF OBJECT_ID('TEMPDB..#TEAM_ITEM') IS NOT NULL DROP TABLE #TEAM_ITEM;
        CREATE TABLE #TEAM_ITEM ( DIVISION_ID NVARCHAR(20), TEAM NVARCHAR(200), SCM_SITE_ID NVARCHAR(200), ITEM_ID NVARCHAR(200) );
        IF @V_PEG_TYPE = 'B'
        BEGIN
            INSERT INTO #TEAM_ITEM (DIVISION_ID, TEAM, SCM_SITE_ID, ITEM_ID)
            SELECT DISTINCT A.DIVISION_ID, TEAM.DEPT_NAME_KO, A.SCM_SITE_ID, A.ITEM_ID
            FROM   SCM_MST_SITE_ITEM A WITH(NOLOCK)
            LEFT JOIN (
                        SELECT B.USER_ID, C.DEPT_NAME_KO
                        FROM   SCM_MST_SSO_USER_INFO B WITH(NOLOCK)
                            INNER JOIN SCM_MST_SSO_DEPT_INFO C WITH(NOLOCK)
                                ON B.DEPT_ID = C.DEPT_ID
                      ) AS TEAM
                ON TEAM.USER_ID IN (SELECT TOP 1 token FROM OPTENG_SCP.DBO.STRING_TOKEN(A.owner, ','))
            WHERE  A.DIVISION_ID = @V_DIVISION_ID
            ;
            DELETE TI
            FROM   #TEAM_ITEM TI
            WHERE  TI.TEAM IS NULL
            OR     NOT EXISTS (SELECT 1 FROM #PEG_CFG C WHERE C.TEAM = TI.TEAM)
            ;
        END

        SET @V_NET_START_YYYYMMDD = CONVERT(NVARCHAR(8), DATEADD(DD, -7, @V_PLAN_START_YYYYMMDD), 112);

        SELECT @V_RTF_PLAN_SEQ = MAX(PLAN_SEQ)
        FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
        WHERE  DIVISION_ID = @V_DIVISION_ID AND PLAN_START_YYYYMMDD = @V_NET_START_YYYYMMDD AND PLAN_TYPE = 'FN'
        ;

        -- 전주 FN 완제품 RTF (FG/ALLOCATION). VMI 사이트 INCOTERMS→'DAP'
        --   BOUNDARY 를 경계로 앞(F: ~BOUNDARY) / 뒤(B: BOUNDARY~계획마지막) 세그먼트로 나눠 구간별 독립 pegging
        --   NET_END(세그먼트 종료) = F: BOUNDARY / B: 계획마지막일
        IF OBJECT_ID('TEMPDB..#RTF_N') IS NOT NULL DROP TABLE #RTF_N;
        SELECT BASE_KEY, BND, RTF_DATE, SUM(RTF_QTY) AS RTF_QTY
        INTO   #RTF_N
        FROM (
            SELECT R.RTF_DATE, R.RTF_QTY
                 , ( CASE WHEN @V_PEG_TYPE='B' AND R.TEAM<>'-' THEN '-' ELSE R.TO_SITE END ) + '::'
                 + ( CASE WHEN @V_PEG_TYPE='C' THEN LEFT(R.ITEM_ID,12) ELSE R.ITEM_ID END ) + '::'
                 + ( CASE WHEN @V_PEG_TYPE='C' THEN R.INCOTERMS ELSE '-' END ) + '::'
                 + ( CASE WHEN @V_PEG_TYPE='C' THEN R.PROJECT_CODE ELSE '-' END ) AS BASE_KEY
                 , ( CASE WHEN CFG.BOUNDARY < @V_PLAN_END_YYYYMMDD_ORI THEN CFG.BOUNDARY ELSE @V_PLAN_END_YYYYMMDD_ORI END ) AS BND
            FROM (
                    SELECT A.YYYYMMDD AS RTF_DATE, A.QTY AS RTF_QTY, A.TO_SITE, A.ITEM_ID
                         , CASE WHEN ISNULL(MSE.VMI_YN,'N')='Y' THEN 'DAP' ELSE A.INCOTERMS END AS INCOTERMS
                         , A.PROJECT_CODE
                         , ISNULL(TI.TEAM,'-') AS TEAM
                    FROM   SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
                    LEFT JOIN SCM_MST_SITE MSE WITH(NOLOCK)
                        ON MSE.DIVISION_ID=A.DIVISION_ID AND MSE.SCM_SITE_ID=A.TO_SITE AND MSE.SITE_TYPE='SALES' AND MSE.VALID_YN='Y' AND MSE.VMI_YN='Y'
                    LEFT JOIN #TEAM_ITEM TI
                        ON @V_PEG_TYPE='B' AND TI.DIVISION_ID=A.DIVISION_ID AND TI.SCM_SITE_ID=A.TO_SITE AND TI.ITEM_ID=A.ITEM_ID
                    WHERE  A.DIVISION_ID         = @V_DIVISION_ID
                    AND    A.PLAN_START_YYYYMMDD = @V_NET_START_YYYYMMDD
                    AND    A.PLAN_TYPE           = 'FN'
                    AND    A.SEQ                 = @V_RTF_PLAN_SEQ
                    AND    A.MEASURE             = 'ALLOCATION'
                    AND    A.QTY                 > 0
                    AND    A.YYYYMMDD          >= @V_NET_START_YYYYMMDD
                    AND    A.YYYYMMDD          <= @V_PLAN_END_YYYYMMDD_ORI
                    AND    A.ITEM_ID + A.TO_SITE IN (SELECT DISTINCT ITEM_ID + SCM_SITE_ID FROM SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK) WHERE PLAN_ID = @V_PLAN_ID)
                 ) R
            LEFT JOIN #PEG_CFG CFG ON CFG.TEAM = R.TEAM
        ) Y
        GROUP BY BASE_KEY, BND, RTF_DATE
        ;

        -- 전주 구간 실적 (RTF_SYS_RP)[전주월, 계획시작) : 날짜 매칭 없이 키별 합계만 사용
        IF OBJECT_ID('TEMPDB..#ACT_N') IS NOT NULL DROP TABLE #ACT_N;
        SELECT BASE_KEY, SUM(ACT_QTY) AS ACT_QTY
        INTO   #ACT_N
        FROM (
            SELECT ( CASE WHEN @V_PEG_TYPE='B' AND M.TEAM<>'-' THEN '-' ELSE M.TO_SITE END ) + '::'
                 + ( CASE WHEN @V_PEG_TYPE='C' THEN LEFT(M.ITEM_ID,12) ELSE M.ITEM_ID END ) + '::'
                 + ( CASE WHEN @V_PEG_TYPE='C' THEN M.INCOTERMS ELSE '-' END ) + '::'
                 + ( CASE WHEN @V_PEG_TYPE='C' THEN M.PROJECT_CODE ELSE '-' END ) AS BASE_KEY
                 , M.QTY AS ACT_QTY
            FROM (
                    SELECT MK.SCM_SITE_ID AS TO_SITE, MK.ITEM_ID
                         , CASE WHEN ISNULL(MSE.VMI_YN,'N')='Y' THEN 'DAP' ELSE MK.INCOTERMS END AS INCOTERMS
                         , MK.PROJECT_CODE, MK.QTY, ISNULL(TI.TEAM,'-') AS TEAM
                    FROM   DM_PLN_MKT_FCST_RESULT MK WITH(NOLOCK)
                    LEFT JOIN SCM_MST_SITE MSE WITH(NOLOCK)
                        ON MSE.DIVISION_ID=MK.DIVISION_ID AND MSE.SCM_SITE_ID=MK.SCM_SITE_ID AND MSE.SITE_TYPE='SALES' AND MSE.VALID_YN='Y' AND MSE.VMI_YN='Y'
                    LEFT JOIN #TEAM_ITEM TI
                        ON @V_PEG_TYPE='B' AND TI.DIVISION_ID=MK.DIVISION_ID AND TI.SCM_SITE_ID=MK.SCM_SITE_ID AND TI.ITEM_ID=MK.ITEM_ID
                    WHERE  MK.MEASURE='RTF_SYS_RP' AND MK.DIVISION_ID=@V_DIVISION_ID
                    AND    MK.YYYYMMDD >= @V_NET_START_YYYYMMDD AND MK.YYYYMMDD < @V_PLAN_START_YYYYMMDD
                    AND    MK.ITEM_ID + MK.SCM_SITE_ID IN (SELECT DISTINCT ITEM_ID + SCM_SITE_ID FROM SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK) WHERE PLAN_ID = @V_PLAN_ID)
                 ) M
        ) Y
        GROUP BY BASE_KEY
        ;

        -- 전주 구간 선정산 : NET_QTY = 전주 RTF 합 - 전주 실적 합
        IF OBJECT_ID('TEMPDB..#ADJ') IS NOT NULL DROP TABLE #ADJ;
        SELECT R.BASE_KEY, R.BND
             , SUM(CASE WHEN R.RTF_DATE < @V_PLAN_START_YYYYMMDD THEN R.RTF_QTY ELSE 0 END) - ISNULL(MAX(A.ACT_QTY),0) AS NET_QTY
             , CASE WHEN @V_PLAN_START_YYYYMMDD <= R.BND THEN 'F' ELSE 'B' END AS SEG_ST
        INTO   #ADJ
        FROM   #RTF_N R
        LEFT JOIN #ACT_N A ON A.BASE_KEY = R.BASE_KEY
        GROUP BY R.BASE_KEY, R.BND
        ;

        -- 최종 RTF = 계획구간 RTF(잔량<0 이면 해당 세그먼트 앞날짜부터 선차감) + 잔량>0 을 계획시작일에 가산
        IF OBJECT_ID('TEMPDB..#NET_RTF') IS NOT NULL DROP TABLE #NET_RTF;
        ;WITH CUM AS (
            SELECT R.BASE_KEY, R.BND, R.RTF_DATE, R.RTF_QTY
                 , CASE WHEN R.RTF_DATE <= R.BND THEN 'F' ELSE 'B' END AS SEG
                 , SUM(R.RTF_QTY) OVER (PARTITION BY R.BASE_KEY, CASE WHEN R.RTF_DATE <= R.BND THEN 'F' ELSE 'B' END
                                        ORDER BY R.RTF_DATE ROWS UNBOUNDED PRECEDING) AS R_END
            FROM   #RTF_N R
            WHERE  R.RTF_DATE >= @V_PLAN_START_YYYYMMDD
        )
        SELECT NET_KEY, SEG, NET_END, RTF_DATE, SUM(RTF_QTY) AS RTF_QTY
        INTO   #NET_RTF
        FROM (
            SELECT C.SEG + '::' + C.BASE_KEY AS NET_KEY, C.SEG
                 , CASE WHEN C.SEG='F' THEN C.BND ELSE @V_PLAN_END_YYYYMMDD_ORI END AS NET_END
                 , C.RTF_DATE
                 , CASE WHEN ISNULL(A.NET_QTY,0) < 0 AND A.SEG_ST = C.SEG
                        THEN CASE WHEN C.R_END + A.NET_QTY <= 0        THEN 0
                                  WHEN C.R_END + A.NET_QTY < C.RTF_QTY THEN C.R_END + A.NET_QTY
                                  ELSE C.RTF_QTY END
                        ELSE C.RTF_QTY END AS RTF_QTY
            FROM   CUM C
            LEFT JOIN #ADJ A ON A.BASE_KEY = C.BASE_KEY
            UNION ALL
            SELECT A.SEG_ST + '::' + A.BASE_KEY, A.SEG_ST
                 , CASE WHEN A.SEG_ST='F' THEN A.BND ELSE @V_PLAN_END_YYYYMMDD_ORI END
                 , @V_PLAN_START_YYYYMMDD, A.NET_QTY
            FROM   #ADJ A
            WHERE  A.NET_QTY > 0
        ) Z
        WHERE  Z.RTF_QTY > 0
        GROUP BY NET_KEY, SEG, NET_END, RTF_DATE
        ;

        -- DEMAND : 이번주 수요(@DM_INS_TEMP), 계획시작 ~ 계획마지막
        --          (실적은 위 전주 선정산에서 이미 반영되어 여기서는 사용하지 않음)
        IF OBJECT_ID('TEMPDB..#NET_DMD') IS NOT NULL DROP TABLE #NET_DMD;
        SELECT W.*
        INTO   #NET_DMD
        FROM (
            SELECT Z.*
                 , CASE WHEN Z.DUE_DATE <= Z.BND THEN 'F' ELSE 'B' END AS SEG
                 , CASE WHEN Z.DUE_DATE <= Z.BND THEN 'F' ELSE 'B' END + '::' + Z.BASE_KEY AS NET_KEY
                 , CASE WHEN Z.DUE_DATE <= Z.BND THEN Z.BND ELSE @V_PLAN_END_YYYYMMDD_ORI END AS NET_END
            FROM (
                SELECT R.*
                     , ( CASE WHEN @V_PEG_TYPE='B' AND R.TEAM<>'-' THEN '-' ELSE R.TO_SITE END ) + '::'
                     + ( CASE WHEN @V_PEG_TYPE='C' THEN LEFT(R.ITEM_ID,12) ELSE R.ITEM_ID END ) + '::'
                     + ( CASE WHEN @V_PEG_TYPE='C' THEN R.INCOTERMS ELSE '-' END ) + '::'
                     + ( CASE WHEN @V_PEG_TYPE='C' THEN R.PROJECT_CODE ELSE '-' END ) AS BASE_KEY
                     , ( CASE WHEN CFG.BOUNDARY < @V_PLAN_END_YYYYMMDD_ORI THEN CFG.BOUNDARY ELSE @V_PLAN_END_YYYYMMDD_ORI END ) AS BND
                FROM (
                        SELECT 'DMD' AS SRC, T.PLAN_ID, T.DEMAND_ID, T.BUFFER_ID, T.DEMAND_GROUP, T.DUE_DATE
                             , T.SALES_CUTOFF_DATE, T.EXPIRY_DATE, T.PRIORITY, T.QUANTITY, T.PRIORITY_GROUP, T.CUSTOMER_ID, T.ALLOW_SHORT
                             , T.ATTRIBUTE1, T.ATTRIBUTE2, T.ATTRIBUTE3, T.ATTRIBUTE4, T.ATTRIBUTE5
                             , T.ATTRIBUTE6, T.ATTRIBUTE7, T.ATTRIBUTE8, T.ATTRIBUTE9, T.ATTRIBUTE10
                             , T.ATTRIBUTE11, T.ATTRIBUTE12, T.ATTRIBUTE13, T.ATTRIBUTE14, T.ATTRIBUTE15
                             , T.ATTRIBUTE1 AS TO_SITE, T.ATTRIBUTE2 AS ITEM_ID, T.ATTRIBUTE4 AS INCOTERMS, T.ATTRIBUTE5 AS PROJECT_CODE
                             , ISNULL(TI.TEAM,'-') AS TEAM
                        FROM   @DM_INS_TEMP T
                        LEFT JOIN #TEAM_ITEM TI
                            ON @V_PEG_TYPE='B' AND TI.DIVISION_ID=@V_DIVISION_ID AND TI.SCM_SITE_ID=T.ATTRIBUTE1 AND TI.ITEM_ID=T.ATTRIBUTE2
                        WHERE  T.PLAN_ID = @V_PLAN_ID AND T.ATTRIBUTE3 LIKE '%BIZ'
                        AND    T.DUE_DATE >= @V_PLAN_START_YYYYMMDD AND T.DUE_DATE <= @V_PLAN_END_YYYYMMDD_ORI
                        -- 2026.09.03 Minyong Lee : SITE_MOVE 증량 수요는 전주 약속물량이 아니므로 pegging 제외
                        --   (약속여부 'N' 은 신규 우선순위 UPDATE 에서 고정 부여. RTF 는 원본 수요가 전량 사용)
                        AND    ISNULL(T.ATTRIBUTE8, '') <> 'SITE_MOVE'
                     ) R
                LEFT JOIN #PEG_CFG CFG ON CFG.TEAM = R.TEAM
                 ) Z
             ) W
        ;

        -- Pegging + Netting : Demand·RTF 누적구간 겹침 → CF조각(RTF마다, TARGET=RTF일) / NF조각(초과분, TARGET=NET_END)
        IF OBJECT_ID('TEMPDB..#NET_RESULT') IS NOT NULL DROP TABLE #NET_RESULT;
        ;WITH
        DMD  AS ( SELECT D.*, SUM(D.QUANTITY) OVER (PARTITION BY D.NET_KEY ORDER BY D.DUE_DATE, D.DEMAND_ID ROWS UNBOUNDED PRECEDING) AS D_END FROM #NET_DMD D ),
        DMD2 AS ( SELECT *, (D_END - QUANTITY) AS D_START FROM DMD ),
        RTF  AS ( SELECT R.NET_KEY, R.RTF_DATE, R.RTF_QTY, SUM(R.RTF_QTY) OVER (PARTITION BY R.NET_KEY ORDER BY R.RTF_DATE ROWS UNBOUNDED PRECEDING) AS R_END FROM #NET_RTF R ),
        RTF2 AS ( SELECT *, (R_END - RTF_QTY) AS R_START FROM RTF ),
        RTOT AS ( SELECT NET_KEY, SUM(RTF_QTY) AS R_TOTAL FROM #NET_RTF GROUP BY NET_KEY ),
        PIECES AS (
            SELECT D.SRC, D.PLAN_ID, D.DEMAND_ID, D.BUFFER_ID, D.DEMAND_GROUP, D.DUE_DATE
                 , D.SALES_CUTOFF_DATE, D.EXPIRY_DATE, D.PRIORITY, D.PRIORITY_GROUP, D.CUSTOMER_ID, D.ALLOW_SHORT
                 , D.ATTRIBUTE1, D.ATTRIBUTE2, D.ATTRIBUTE3, D.ATTRIBUTE4, D.ATTRIBUTE5
                 , D.ATTRIBUTE6, D.ATTRIBUTE7, D.ATTRIBUTE8, D.ATTRIBUTE9, D.ATTRIBUTE10
                 , D.ATTRIBUTE11, D.ATTRIBUTE12, D.ATTRIBUTE13, D.ATTRIBUTE14, D.ATTRIBUTE15, D.TEAM, D.SEG
                 , 'CF' AS DM_TYPE, R.RTF_DATE AS TGT_DATE
                 , (LEAST(D.D_END, R.R_END) - GREATEST(D.D_START, R.R_START)) AS PIECE_QTY
            FROM DMD2 D INNER JOIN RTF2 R ON R.NET_KEY = D.NET_KEY AND D.D_START < R.R_END AND R.R_START < D.D_END
            UNION ALL
            SELECT D.SRC, D.PLAN_ID, D.DEMAND_ID, D.BUFFER_ID, D.DEMAND_GROUP, D.DUE_DATE
                 , D.SALES_CUTOFF_DATE, D.EXPIRY_DATE, D.PRIORITY, D.PRIORITY_GROUP, D.CUSTOMER_ID, D.ALLOW_SHORT
                 , D.ATTRIBUTE1, D.ATTRIBUTE2, D.ATTRIBUTE3, D.ATTRIBUTE4, D.ATTRIBUTE5
                 , D.ATTRIBUTE6, D.ATTRIBUTE7, D.ATTRIBUTE8, D.ATTRIBUTE9, D.ATTRIBUTE10
                 , D.ATTRIBUTE11, D.ATTRIBUTE12, D.ATTRIBUTE13, D.ATTRIBUTE14, D.ATTRIBUTE15, D.TEAM, D.SEG
                 , 'NF' AS DM_TYPE, D.NET_END AS TGT_DATE
                 , (D.D_END - GREATEST(D.D_START, ISNULL(T.R_TOTAL,0))) AS PIECE_QTY
            FROM DMD2 D LEFT JOIN RTOT T ON T.NET_KEY = D.NET_KEY
            WHERE D.D_END > ISNULL(T.R_TOTAL,0)
        )
        SELECT P.PLAN_ID
             , P.DEMAND_ID + '::' + P.TGT_DATE + '::' + P.DM_TYPE AS DEMAND_ID
             , P.BUFFER_ID, P.DEMAND_GROUP, P.DUE_DATE
             , CASE WHEN P.TGT_DATE < P.DUE_DATE THEN P.DUE_DATE ELSE P.TGT_DATE END AS TARGET_DATE   -- target 이 due 이전이면 due 로 보정
             , P.SALES_CUTOFF_DATE, P.EXPIRY_DATE, P.PRIORITY, P.PIECE_QTY AS QUANTITY
             -- [신규 우선순위 방식] PRIORITY_GROUP 마지막 자리(약속여부) : CF→Y / NF→N
             , P.PRIORITY_GROUP + '::' + CASE WHEN P.DM_TYPE = 'CF' THEN 'Y' ELSE 'N' END AS PRIORITY_GROUP
             , P.CUSTOMER_ID, P.ALLOW_SHORT
             , P.ATTRIBUTE1, P.ATTRIBUTE2, P.ATTRIBUTE3, P.ATTRIBUTE4, P.ATTRIBUTE5
             , P.ATTRIBUTE6, P.ATTRIBUTE7, P.ATTRIBUTE8
             , CASE WHEN @V_PEG_TYPE='B' AND P.TEAM<>'-' THEN P.TEAM ELSE P.ATTRIBUTE9 END AS ATTRIBUTE9   -- 팀 pegging 시 팀명 마킹
             , P.ATTRIBUTE10
             , P.ATTRIBUTE11, P.ATTRIBUTE12, P.ATTRIBUTE13, P.ATTRIBUTE14, P.ATTRIBUTE15
             , P.SRC, P.SEG, P.DM_TYPE, P.TGT_DATE AS PEG_DATE   -- 검증용
        INTO #NET_RESULT
        FROM PIECES P
        WHERE P.PIECE_QTY > 0
        ;

        -- @DM_INS_TEMP 재구성 : pegging 대상(고객향 수요) 원본 제거 후 CF/NF 조각 삽입
        DELETE T
        FROM   @DM_INS_TEMP T
        WHERE  T.DEMAND_ID IN (SELECT DEMAND_ID FROM #NET_DMD WHERE SRC = 'DMD')
        ;
        INSERT INTO @DM_INS_TEMP
            (PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE
            ,SALES_CUTOFF_DATE, EXPIRY_DATE, PRIORITY, QUANTITY, PRIORITY_GROUP
            ,CUSTOMER_ID, ALLOW_SHORT
            ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
            ,ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
            ,ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15)
        SELECT PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE
            ,SALES_CUTOFF_DATE, EXPIRY_DATE, PRIORITY, QUANTITY, PRIORITY_GROUP
            ,CUSTOMER_ID, ALLOW_SHORT
            ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
            ,ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
            ,ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
        FROM   #NET_RESULT
        WHERE  DUE_DATE >= @V_PLAN_START_YYYYMMDD
        ;

        IF OBJECT_ID('TEMPDB..#PEG_CFG')    IS NOT NULL DROP TABLE #PEG_CFG;
        IF OBJECT_ID('TEMPDB..#TEAM_ITEM')  IS NOT NULL DROP TABLE #TEAM_ITEM;
        IF OBJECT_ID('TEMPDB..#RTF_N')      IS NOT NULL DROP TABLE #RTF_N;
        IF OBJECT_ID('TEMPDB..#ACT_N')      IS NOT NULL DROP TABLE #ACT_N;
        IF OBJECT_ID('TEMPDB..#ADJ')        IS NOT NULL DROP TABLE #ADJ;
        IF OBJECT_ID('TEMPDB..#NET_RTF')    IS NOT NULL DROP TABLE #NET_RTF;
        IF OBJECT_ID('TEMPDB..#NET_DMD')    IS NOT NULL DROP TABLE #NET_DMD;
        IF OBJECT_ID('TEMPDB..#NET_RESULT') IS NOT NULL DROP TABLE #NET_RESULT;
    END
    ------------------------------------------------------------------------
    -- RTF Pegging (고객향 수요 = STAGE 가 'BIZ' 로 끝나는 수요 대상) END
    ------------------------------------------------------------------------

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
                        WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
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

    PRINT ('10. Demand Insert Type D: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  

    SELECT @V_CNT = COUNT(*)
    FROM   @DM_INS_TEMP S
    WHERE 1=1
    AND S.PLAN_ID       = @V_PLAN_ID
    AND S.ATTRIBUTE15   = 'D'
    AND S.DUE_DATE     >= @V_PROD_FROZEN_END_YMD
    ;

    IF @V_CNT > 0
        BEGIN
            IF OBJECT_ID('TEMPDB..#DEMAND_TYPE_D') IS NOT NULL
            BEGIN 
                DROP TABLE  #DEMAND_TYPE_D;
            END;
            
            SELECT  CM.DAYOFWEEK
                  , LK.DEMAND_MERGE_DAY
                  , CONVERT(NVARCHAR(8), DBO.FN_NEXT_DAY(DBO.FN_NEXT_DAY(DATEADD(DD, -8, CM.BASIS_DATE), 'SUN'), LK.DEMAND_MERGE_DAY), 112) AS GROUP_START_DATE -- 전주 일요일 기준으로 다음 타겟 요일 = 금주의 타겟 요일
                  , S.*
            INTO    #DEMAND_TYPE_D
            FROM    @DM_INS_TEMP S
                INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                    ON  S.DUE_DATE  = CM.BASIS_YYYYMMDD
                INNER JOIN (
                            SELECT    SEGMENT2 AS DIVISION_ID
                                    , SEGMENT3 AS PLAN_GROUP_ID
                                    , SEGMENT4 AS SITE_ID
                                    , SEGMENT5 AS STAGE
                                    , SEGMENT6 AS LINE_ID
                                    , SEGMENT7 AS ITEM_ID
                                    , ATTRIBUTE1 AS DEMAND_MERGE_TYPE
                                    , ATTRIBUTE2 AS DEMAND_MERGE_DAY
                            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                            WHERE   LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
                            AND     VALID_YN      = 'Y'
                            AND     SEGMENT2      = @V_DIVISION_ID
                            AND     SEGMENT3      = @V_GROUP_ID
                            AND     ATTRIBUTE1    = 'D'
                            ) LK
                    ON  LK.SITE_ID  = S.ATTRIBUTE1
                    AND LK.ITEM_ID  = S.ATTRIBUTE2
                    AND LK.STAGE    = S.ATTRIBUTE3
            WHERE   1=1
            AND     S.PLAN_ID       = @V_PLAN_ID
            AND     S.ATTRIBUTE15   = 'D'
            AND     S.DUE_DATE     >= @V_PROD_FROZEN_END_YMD

            -- 묶음 Target 일자가 Frozen 구간 내인 경우, Frozen 이후 일자에 반영
            UPDATE #DEMAND_TYPE_D
            SET GROUP_START_DATE = @V_PROD_FROZEN_END_YMD
            WHERE GROUP_START_DATE < @V_PROD_FROZEN_END_YMD

            INSERT INTO SCP_OPT_ENG_DEMAND_SN (
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
            SELECT  FDM.PLAN_ID                                   AS PLAN_ID
                  , MIN(FDM.DEMAND_ID)                            AS DEMAND_ID
                  , MIN(FDM.BUFFER_ID)                            AS BUFFER_ID
                  , MIN(FDM.DEMAND_GROUP)                         AS DEMAND_GROUP
                  , GROUP_START_DATE                              AS DUE_DATE
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
            FROM    #DEMAND_TYPE_D FDM
            GROUP BY FDM.PLAN_ID, FDM.ATTRIBUTE1, FDM.ATTRIBUTE2, FDM.ATTRIBUTE3, FDM.GROUP_START_DATE
        END

    ------------------------------------------------------------------------
    -- 2. DEMAND GROUP
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    -- START 2025-12-15 jongykim2: Demand Group Master
    IF OBJECT_ID('TEMPDB..#DEMAND_GROUP_T') IS NOT NULL
    BEGIN 
        DROP TABLE  #DEMAND_GROUP_T;
    END;
    SELECT T2.DIVISION_ID AS SEGMENT2
         , T2.ITEM_ID AS SEGMENT3
         , T.GROUP_NAME AS SEGMENT4
         , T2.PROJECT_CODE AS SEGMENT5
    INTO   #DEMAND_GROUP_T
    FROM   SCP_MST_ITEM_GROUP T WITH(NOLOCK)
    INNER JOIN SCP_MST_ITEM_GROUP_DETAIL T2 WITH(NOLOCK)
    ON     T2.DIVISION_ID = T.DIVISION_ID
    AND    T2.GROUP_ID = T.GROUP_ID
    WHERE  1 = 1
    AND    T.DIVISION_ID = @V_DIVISION_ID
    AND    T.VALID_YN = 'Y'
    AND    ISNULL(T.ATTRIBUTE1, 'N') <> 'Y'
    AND    T2.VALID_YN = 'Y'
    ;
    -- END 2025-12-15 jongykim2:
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
                /*FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL  LU WITH(NOLOCK)
                    LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                    ON  DM.PLAN_ID = @V_PLAN_ID
                    AND DM.ATTRIBUTE2 = LU.SEGMENT3
                    AND DM.ATTRIBUTE5 = LU.SEGMENT5
                WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                AND     LU.VALID_YN = 'Y'
                AND     LU.SEGMENT2 = @V_DIVISION_ID*/ -- blocked 2025-12-15 jongykim2
                -- START 2025-12-15 jongykim2: Demand Group Master
                FROM    #DEMAND_GROUP_T LU WITH(NOLOCK)
                    LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                    ON  DM.PLAN_ID = @V_PLAN_ID
                    AND DM.ATTRIBUTE2 = LU.SEGMENT3
                    AND DM.ATTRIBUTE5 = LU.SEGMENT5
                -- END 2025-12-15 jongykim2: Demand Group Master
                GROUP BY DM.ATTRIBUTE1, LU.SEGMENT4, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                ) DG
                    /*INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL  LU WITH(NOLOCK)
                    ON  DG.DEMAND_GROUP = LU.SEGMENT4
                    AND LU.VALID_YN     = 'Y'
                    AND DG.PROJECT_CODE = LU.SEGMENT5 --PROJECT추가
                    AND LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                    AND LU.SEGMENT2 = @V_DIVISION_ID*/ -- blocked 2025-12-15 jongykim2
                    -- START 2025-12-15 jongykim2: Demand Group Master
                    INNER JOIN #DEMAND_GROUP_T LU WITH(NOLOCK)
                    ON  DG.DEMAND_GROUP = LU.SEGMENT4
                    AND DG.PROJECT_CODE = LU.SEGMENT5
                    -- END 2025-12-15 jongykim2: Demand Group Master
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
            /*INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            ON  DM.PLAN_ID = @V_PLAN_ID
            AND DM.ATTRIBUTE2 = LU.SEGMENT3
            AND DM.ATTRIBUTE5 = LU.SEGMENT5
        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
        AND     LU.VALID_YN = 'Y'
        AND     LU.SEGMENT2 = @V_DIVISION_ID*/ -- blocked 2025-12-15 jongykim2
            -- START 2025-12-15 jongykim2: Demand Group Master
            INNER JOIN #DEMAND_GROUP_T LU WITH(NOLOCK)
            ON  DM.PLAN_ID = @V_PLAN_ID
            AND DM.ATTRIBUTE2 = LU.SEGMENT3
            AND DM.ATTRIBUTE5 = LU.SEGMENT5
            -- END 2025-12-15 jongykim2
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
	
    -- 신규 우선순위 방식 적용 시 Target Date 룩업 미적용 (Pegging 이 정한 Target Date 유지)
    IF @V_NEW_PRIO_YN = 'N'
    BEGIN

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
                                    /*LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU2 WITH(NOLOCK)
                                        ON  LU2.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND LU.SEGMENT1 = LU2.SEGMENT2
                                        AND LU.SEGMENT4 = LU2.SEGMENT3
                                        AND LU2.VALID_YN ='Y'*/ -- blocked 2025-12-15 jongykim2
                                    -- START 2025-12-15 jongykim2: Demand Group Master
                                    LEFT OUTER JOIN #DEMAND_GROUP_T LU2 WITH(NOLOCK)
                                        ON  1 = 1
                                        AND LU.SEGMENT1 = LU2.SEGMENT2
                                        AND LU.SEGMENT4 = LU2.SEGMENT3
                                    -- END 2025-12-15 jongykim2: Demand Group Master
                                WHERE LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_DEMAND_TARGETDATE'
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
                                    /*LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU2 WITH(NOLOCK)
                                        ON  LU2.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND LU.SEGMENT1 = LU2.SEGMENT2
                                        AND LU.SEGMENT4 = LU2.SEGMENT3
                                        AND LU2.VALID_YN ='Y'*/ -- blocked 2025-12-15 jongykim2
                                    -- START 2025-12-15 jongykim2: Demand Group Master
                                    LEFT OUTER JOIN #DEMAND_GROUP_T LU2 WITH(NOLOCK)
                                        ON  1 = 1
                                        AND LU.SEGMENT1 = LU2.SEGMENT2
                                        AND LU.SEGMENT4 = LU2.SEGMENT3
                                    -- END 2025-12-15 jongykim2: Demand Group Master
                                WHERE LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_DEMAND_TARGETDATE'
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
    ;

    END -- IF @V_NEW_PRIO_YN = 'N'
	

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

    ----------------------------------------------------------------------------
    -- 2026.08.13 Minyong Lee : [E20260818-000193] [최적화 알고리즘] 사이트간 물량 이관 반영
    --   @DM_INS_TEMP 에는 INSERT_ID/UPDATE_ID 컬럼이 없어 최종 반영 후 마킹.
    --   증량 행: INSERT_ID/UPDATE_ID = 'SITE_MOVE' (ATTRIBUTE8 = 'SITE_MOVE' 기준)
    --   차감 행: UPDATE_ID = 'SITE_MOVE'           (#SM_MINUS_MARK 기준)
    --   * 뭉치기(MERGE)로 DEMAND_ID 가 재구성된 차감 행은 마킹이 누락될 수 있음(디버그 보조용)
    ----------------------------------------------------------------------------
    IF @V_DIVISION_ID = '40'
    BEGIN
        UPDATE  SCP_OPT_ENG_DEMAND_SN
        SET     INSERT_ID = 'SITE_MOVE'
               ,UPDATE_ID = 'SITE_MOVE'
        WHERE   PLAN_ID    = @V_PLAN_ID
        AND     ATTRIBUTE8 = 'SITE_MOVE'
        ;

        IF OBJECT_ID('TEMPDB..#SM_MINUS_MARK') IS NOT NULL
        BEGIN
            UPDATE  DT
            SET     DT.UPDATE_ID = 'SITE_MOVE'
            FROM    SCP_OPT_ENG_DEMAND_SN DT
            INNER JOIN #SM_MINUS_MARK MK
                ON  DT.DEMAND_ID = MK.DEMAND_ID
            WHERE   DT.PLAN_ID = @V_PLAN_ID
            ;
            DROP TABLE #SM_MINUS_MARK;
        END

        IF OBJECT_ID('TEMPDB..#SM_TRSF_RESOLVED') IS NOT NULL DROP TABLE #SM_TRSF_RESOLVED;
    END

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
