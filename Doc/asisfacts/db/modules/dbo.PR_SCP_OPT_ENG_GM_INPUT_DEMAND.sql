

--EXEC PR_SCP_OPT_ENG_GM_INPUT_DEMAND 'PLAN_ID_001'
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_INPUT_DEMAND]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.07.07 Philsu Park: Initial Release
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_INPUT_DEMAND';
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

    DECLARE @V_SCP_PLAN_DATE       NVARCHAR(8)
    DECLARE @V_SCP_PLAN_TYPE       NVARCHAR(8)
    DECLARE @V_SCP_PLAN_SEQ        NVARCHAR(8)

    DECLARE @V_PLAN_END_YYYYMMDD_ORI	NVARCHAR(20) = CONVERT(NVARCHAR(8), DATEADD(DAY,-1,@V_PLAN_END_YYYYMMDD),112);

    DECLARE @V_SHIPMENT_SNAP_CNT INT;
    DECLARE @V_QTY_PER_CONTAINER INT;

    ------------------------------------------------------------------------ 
    --DEMAND ROLLING 변수
	------------------------------------------------------------------------
    DECLARE @V_DM_RL_START_DATE  NVARCHAR(8)
    DECLARE @V_TODAY             NVARCHAR(8)
    DECLARE @V_ROLLING_YN        NVARCHAR(1)

    --출하 실적 임시 테이블 -> UI 데이터를 가져오기 위해 UI 로직 적용
    -- DECLARE @SHIP_RESULT_TEMP TABLE(
    --  DIVISION_ID    NVARCHAR(100)
    -- ,CONFIRM_ID     NVARCHAR(100)
    -- ,ERP_SO_NO      NVARCHAR(100)
    -- ,YYYYMMDD       NVARCHAR(8)
    -- ,TRANSPORT_MODE NVARCHAR(100)
    -- ,INCOTERMS      NVARCHAR(100)
    -- ,PROJECT_CODE   NVARCHAR(100)
    -- ,ETA_DATE       NVARCHAR(100)
    -- ,ETD_DATE       NVARCHAR(100)
    -- ,FROM_SITE      NVARCHAR(100)
    -- ,TO_SITE        NVARCHAR(100)
    -- ,ITEM_ID        NVARCHAR(100)
    -- ,RESULT_QTY     NUMERIC(20,10)
    -- )

    --DEMAND ROLLING 임시테이블
    DECLARE @DM_RL_TEMP TABLE(
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
	
	-- MKT Fcst 실적 테이블
    DECLARE @DM_RESULT_TEMP TABLE(
                                 SCM_SITE_ID   NVARCHAR(200)
                                ,ITEM_ID      NVARCHAR(200)
                                ,INCOTERMS    NVARCHAR(200)
                                ,PROJECT_CODE NVARCHAR(200)
                                ,DM_QTY       NUMERIC(20,10)
                                )

    --DEMAND ROLLING 누적 계산 테이블
    DECLARE @DM_RL_SUM_TEMP TABLE(
                                 TO_SITE_ID   NVARCHAR(200)
                                ,ITEM_ID      NVARCHAR(200)
                                ,INCOTERMS    NVARCHAR(200)
                                ,PROJECT_CODE NVARCHAR(200)
                                --,FCST_TYPE    NVARCHAR(200)
                                ,DM_QTY       NUMERIC(20,10)
                                ,SHIP_QTY     NUMERIC(20,10)
                                ,QTY          NUMERIC(20,10)
                                )
    ------------------------------------------------------------------------ 
    --DEMAND ROLLING 변수 끝
	------------------------------------------------------------------------

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

	/* SELECT  @V_SHIP_FROZEN = SEGMENT4
	FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
	WHERE   LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN'
	AND     VALID_YN    = 'Y'
	AND     SEGMENT1    = @V_DIVISION_ID
	AND     SEGMENT2    = @V_GROUP_ID
    --AND     SEGMENT3    = 'PR' --임시
    AND     SEGMENT3    = @V_SCP_PLAN_TYPE

	SET @V_SHIP_FROZEN_DAY = CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(@V_SHIP_FROZEN, 0), @V_SCP_PLAN_DATE ),112); */
  
    ------------------------------------------------------------------------
    -- Set Param for Demand
    ------------------------------------------------------------------------
    SELECT  @MAX_TUESDAY = MAX(BASIS_YYYYMMDD)
    FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK) 
    --WHERE   BASIS_YYYYMMDD <= CONVERT(NVARCHAR(8),GETDATE(),112)
    WHERE   BASIS_YYYYMMDD <= @V_PLAN_START_YYYYMMDD
    AND     DAYOFWEEK = 'TUE'

    SELECT @P_PLAN_NAME          = @V_PLAN_START_YYYYMMDD; --CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    SELECT @D_PLAN_NAME          = CONVERT(DATETIME, @P_PLAN_NAME) ;--= CONVERT(CHAR(8), DATEADD(DD, -6, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 화요일 YYYYMMDD
    --SELECT @V_DEMAND_CUTOFF_DAY  = ISNULL(MAX(P.CUTOFF_YYYYMMDD),@MAX_TUESDAY)
    --                                --, CONVERT(CHAR(8), DATEADD(DD, -6, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) -- 당주 화요일 YYYYMMDD
    --                                FROM   DM_PLN_NET_DEMAND P WITH(NOLOCK)
    --                                WHERE  P.DIVISION_ID      = @V_DIVISION_ID 
    --                                AND    P.CUTOFF_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -3, @D_PLAN_NAME), 112) -- 월요일 기준 최근 3일 이내									
    --                                AND    P.CUTOFF_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, +6, @D_PLAN_NAME), 112) -- 해당 주차 일요일 이전
    SELECT @V_DEMAND_CUTOFF_DAY  =  MAX(P.CUTOFF_YYYYMMDD)
                                    FROM   DM_PLN_NET_DEMAND P WITH(NOLOCK)
                                    WHERE  P.DIVISION_ID      = @V_DIVISION_ID 							
                                    AND    P.CUTOFF_YYYYMMDD <= @V_PLAN_START_YYYYMMDD 
                                    AND    P.CUTOFF_YYYYMMDD >= CONVERT(NVARCHAR(8), DATEADD(DD, -28, @MAX_TUESDAY), 112)
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
    -- DEMAND ROLLING 변수 설정
    ------------------------------------------------------------------------
    SELECT  @V_DM_RL_START_DATE = (SELECT  BASIS_YYYYMMDD
                                   FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK)
                                   WHERE   ISO_YYYYWW = (
                                                        SELECT  ISO_YYYYWW
                                                        FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK)
                                                        WHERE   BASIS_YYYYMMDD = @V_DEMAND_CUTOFF_DAY
                                                        )
                                   AND     DAYOFWEEK = 'MON')
    
    
    SELECT  @V_TODAY = CONVERT(NVARCHAR(8),GETDATE(),112)
    SELECT  @V_ROLLING_YN = ATTRIBUTE1
    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_GM_ONOFF_TEMP'
    AND     SEGMENT1 = @V_DIVISION_ID
    AND     SEGMENT2 = @V_GROUP_ID 
    AND     VALID_YN = 'Y'

    SELECT TOP 1 @V_QTY_PER_CONTAINER = CONVERT(INT, LK.ATTRIBUTE1)
    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
    WHERE   LK.LOOKUP_TYPE = 'SCP_OPT_ENG_SHIP_LOT_SIZE_NEW'
    AND     LK.VALID_YN = 'Y'
    AND     LK.SEGMENT1 = @V_DIVISION_ID
    AND     LK.SEGMENT2 = @V_GROUP_ID
    AND     LK.SEGMENT3 = 'CON'

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
    -- LOOKUP에서 ROLLING 사용여부 Y인 경우 적용
    IF @V_ROLLING_YN = 'Y'
    BEGIN

		------------------------------------------------------------------------
        -- 2025.10.24 Philsu Park: 실적을 출하실적이 아닌 매출실적 기준으로 반영
        ------------------------------------------------------------------------
		INSERT INTO @DM_RESULT_TEMP
			(
				 SCM_SITE_ID
				,ITEM_ID
				,INCOTERMS
				,PROJECT_CODE
				,DM_QTY
				)
			SELECT    F.SCM_SITE_ID
					, F.ITEM_ID
					, F.INCOTERMS
					, F.PROJECT_CODE
					, SUM(F.QTY) AS DM_QTY
			FROM 	DM_PLN_MKT_FCST_RESULT F WITH(NOLOCK)
			WHERE 	F.MEASURE       = 'RTF_SYS_RP'
			AND 	F.DIVISION_ID 	= @V_DIVISION_ID
			AND 	F.YYYYMMDD     >= @V_DM_RL_START_DATE
			AND 	F.YYYYMMDD      < @V_PLAN_START_YYYYMMDD
			AND 	F.QTY 			> 0
			AND 	EXISTS	(
							SELECT 1
							FROM 	SCP_OPT_ENG_MODEL_LIST_N_SN N WITH(NOLOCK)
							WHERE 	N.PLAN_ID 		= @V_PLAN_ID
							AND 	N.SCM_SITE_ID 	= F.SCM_SITE_ID
							AND 	N.ITEM_ID		= F.ITEM_ID
							)
			GROUP BY F.SCM_SITE_ID, F.ITEM_ID, F.INCOTERMS, F.PROJECT_CODE
		;

        ------------------------------------------------------------------------
        -- 0. UI 기준으로 출하 실적을 임시테이블에 담음
        ------------------------------------------------------------------------
        /* INSERT INTO @SHIP_RESULT_TEMP
		SELECT  E.DIVISION_ID             AS DIVISION_ID
		,       E.CONFIRM_ID              AS CONFIRM_ID
		,       E.ORDER_NO				  AS ERP_SO_NO 
		,       E.EXFACTORY_DATE          AS YYYYMMDD
		,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
		,       E.INCOTERMS				  AS INCOTERMS
        ,       E.PROJECT_CODE            AS PROJECT_CODE
		,		E.ETA_DATE				  AS ETA_DATE
		,		E.ETD_DATE				  AS ETD_DATE
		,		E.FROM_SCM_SITE_ID		  AS FROM_SITE
		,		E.TO_SCM_SITE_ID		  AS TO_SITE
		,		E.ITEM_ID				  AS ITEM_ID
		,       SUM(E.EXFACTORY_QTY )     AS RESULT_QTY 
		FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
				ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
			AND L.VALID_YN = 'Y'
			AND L.SEGMENT1    = E.SSP_TYPE
		JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
			ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID
		   AND E.DIVISION_ID	= S.DIVISION_ID
		   AND S.SITE_TYPE		= 'PLANT'
		JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)
			ON E.ITEM_ID		= T.ITEM_ID
		   AND E.DIVISION_ID	= T.DIVISION_ID
		   AND S.COMPANY_ID		= T.COMPANY_ID
		   AND T.ITEM_TYPE		NOT IN ('Q','R')
		WHERE 1=1
		AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
		AND   E.CONFIRM_ID       LIKE 'C%'
        AND   E.EXFACTORY_DATE  >= @V_DM_RL_START_DATE
        AND   E.EXFACTORY_DATE   < @V_PLAN_START_YYYYMMDD
        AND   E.DIVISION_ID      = @V_DIVISION_ID
		GROUP BY E.DIVISION_ID 
		,        E.CONFIRM_ID
		,        E.ORDER_NO
		,        E.EXFACTORY_DATE
		,        E.TRANSPORT_MODE
		,        E.INCOTERMS		
        ,        E.PROJECT_CODE
		,		 E.ETA_DATE		
		,		 E.ETD_DATE
		,		 E.FROM_SCM_SITE_ID	
		,		 E.TO_SCM_SITE_ID	
		,		 E.ITEM_ID
		UNION ALL
		-- ERP 출하실적에서 CONFIRM_ID 없는 실적 
		SELECT  E.DIVISION_ID                         AS DIVISION_ID
		,       '-'                                   AS CONFIRM_ID
		,       E.ORDER_NO				              AS ERP_SO_NO 
		,       E.EXFACTORY_DATE                      AS YYYYMMDD
		,       E.TRANSPORT_MODE		              AS TRANSPORT_MODE
		,       E.INCOTERMS				              AS INCOTERMS
        ,       E.PROJECT_CODE                        AS PROJECT_CODE
		,		E.ETA_DATE				              AS ETA_DATE
		,		E.ETD_DATE				              AS ETD_DATE
		,       E.FROM_SCM_SITE_ID                    AS FROM_SITE                                                                    
        ,       ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID) AS TO_SITE   
		,       E.ITEM_ID                             AS ITEM_ID
		,       SUM(E.EXFACTORY_QTY )                 AS QTY  
		FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
		JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
			ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
		   AND E.DIVISION_ID	= S.DIVISION_ID				 
		   AND S.SITE_TYPE		= 'PLANT'					 				 
		JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
			ON E.ITEM_ID		= T.ITEM_ID					 
		   AND E.DIVISION_ID	= T.DIVISION_ID				 
		   AND S.COMPANY_ID		= T.COMPANY_ID				 
		   AND T.ITEM_TYPE		NOT IN ('Q','R')
		JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
			ON F.ITEM_ID = E.ITEM_ID 
			AND F.DIVISION_ID = E.DIVISION_ID
		JOIN   SCM_MST_SITE FS WITH(NOLOCK)
			ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
			AND FS.DIVISION_ID = E.DIVISION_ID 
			-- AND ISNULL(FS.OSP_YN,'N') <> 'Y' --- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN <> 'Y' 조건제외)
		-- 2020.09.18 김광희 책임 요청으로 주석처리
		-- 2021.04.15 김광희 책임 요청으로 주석해제
		JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
			ON L.LOOKUP_TYPE = 'ERP_ORDER_TYPE' -- LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 
		AND L.VALID_YN = 'Y'
		AND L.SEGMENT1    = E.ORDER_TYPE_CODE 	
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
				ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
			AND L3.SEGMENT1    = E.DIVISION_ID 
			AND L3.SEGMENT2    = E.SOLDTO_CODE
			AND L3.SEGMENT3    = E.SHIPTO_CODE					    
		WHERE 1=1
		AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
		AND   ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
        AND   E.EXFACTORY_DATE  >= @V_DM_RL_START_DATE
        AND   E.EXFACTORY_DATE   < @V_PLAN_START_YYYYMMDD
        AND   E.DIVISION_ID      = @V_DIVISION_ID
		--[C20210330-000402]
		--AND   E.FROM_SCM_SITE_ID IS NOT NULL 
		--AND   E.TO_SCM_SITE_ID IS NOT NULL 
		AND   E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외 
		--[C20200403-000062]
		AND   E.STORAGE_ID NOT IN (SELECT SEGMENT1 
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
								WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
									AND VALID_YN = 'Y'
								)	-- 사외 창고 제외 LOOKUP 관리
		--AND   E.ORDER_TYPE_CODE  IN ('ZEF','ZEFC','ZEML','ZEMM','ZEX','ZFD','ZFR','ZKB','ZMM','ZOR','ZFDC','ZKM') -- 해당 ORDER_TYPE만 대상으로 함 
		GROUP BY E.DIVISION_ID
		,        E.ORDER_NO
		,        E.FROM_SCM_SITE_ID                                                                           
		,        ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID) 
		,        E.ITEM_ID
		,        E.EXFACTORY_DATE
		,        E.TRANSPORT_MODE
		,        E.INCOTERMS		
        ,        E.PROJECT_CODE
		,		 E.ETA_DATE		
		,		 E.ETD_DATE
		,		 E.FROM_SCM_SITE_ID	
		,		 E.TO_SCM_SITE_ID	 */
        ------------------------------------------------------------------------
        -- 1. DEMAND를 CUTOFF DATE -1일, 즉 월요일부터 가져와서 임시테이블에 담는다.
        ------------------------------------------------------------------------
        INSERT INTO @DM_RL_TEMP
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
                ,SCM_SITE_ID+'::'+DEMAND.ITEM_ID+'::'+STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE+'::'+DUE_DATE+'::'+'-'+'::'+FCST_TYPE+IIF(CPS.ITEM_ID IS NULL,'','::'+DEMAND.CELL_PROD_SITE_ID) AS DEMAND_ID
                ,SCM_SITE_ID+'::'+DEMAND.ITEM_ID+'::'+STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE+IIF(CPS.ITEM_ID IS NULL,'','::'+DEMAND.CELL_PROD_SITE_ID)                                       AS BUFFER_ID
                ,INCOTERMS+'@'+'D'+PRIORITY                                                 AS DEMAND_GROUP
                ,DUE_DATE                                                                   AS DUE_DATE
                ,NULL                                                                       AS TARGET_DATE
                ,NULL                                                                       AS SALES_CUTOFF_DATE
                ,NULL                                                                       AS EXPIRY_DATE
                ,PRIORITY                                                                   AS PRIORITY
                ,QUANTITY                                                                   AS QUANTITY
                ,'D'+PRIORITY                                                               AS PRIORITY_GROUP
                ,NULL                                                                       AS CUSTOMER_ID
                ,NULL                                                                       AS ALLOW_SHORT
                ,SCM_SITE_ID                                                                AS ATTRIBUTE1       
                ,DEMAND.ITEM_ID                                                             AS ATTRIBUTE2
                ,STAGE                                                                      AS ATTRIBUTE3
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
        FROM   (
        SELECT   A.SCM_SITE_ID  AS SCM_SITE_ID
                ,A.ITEM_ID      AS ITEM_ID
                ,CASE   WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'        THEN 'PACKBIZ'
                        WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'        THEN 'MDLEBIZ'
                        WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ'
                        WHEN B.OPERATION_GROUP = 'A'    THEN 'CELLBIZ' 
                 ELSE '-' END                                                               AS STAGE
                ,CASE WHEN ISNULL(MSE.VMI_YN, 'N' ) = 'Y' THEN 'DAP' ELSE A.INCOTERMS END   AS INCOTERMS
              ,A.ATTRIBUTE1                                                                 AS DUE_DATE
              ,SUM(A.QTY)                                                                   AS QUANTITY
              ,TP.PRIORITY                                                                  AS PRIORITY
              ,A.FCST_TYPE                                                                  AS FCST_TYPE
              ,A.PROJECT_CODE                                                               AS PROJECT_CODE
              ,A.CELL_PROD_SITE_ID                                                          AS CELL_PROD_SITE_ID
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
                LEFT OUTER JOIN( --TOSITE PRIORITY CONSTRAINT
                                SELECT  SEGMENT3   AS ITEM_ID 
                                       ,SEGMENT4   AS TO_SITE
                                       ,SEGMENT5   AS PRIORITY
                                       ,ATTRIBUTE1 AS FROM_DATE
                                       ,ATTRIBUTE2 AS TO_DATE
                                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY'
                                AND     SEGMENT2    = @V_DIVISION_ID
                                AND     VALID_YN    = 'Y'
                               ) TP
                ON  A.SCM_SITE_ID = TP.TO_SITE
                AND A.ITEM_ID     = TP.ITEM_ID
                AND A.ATTRIBUTE1 BETWEEN TP.FROM_DATE AND TP.TO_DATE
                ------------------------------------------------------------------------
                -- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
                -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
                ------------------------------------------------------------------------
                LEFT JOIN ( 
                            --SELECT  SEGMENT2   AS DIVISION_ID
                            --        , SEGMENT3   AS SCM_SITE_ID
                            --        , SEGMENT4   AS ITEM_ID
                            --        , SEGMENT5   AS GROUP_ID
                            --        , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                            --            ELSE ATTRIBUTE2
                            --        END AS START_DATE  -- PLAN 제외 시작일자
                            --        , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                            --            ELSE ATTRIBUTE3
                            --        END AS END_DATE  -- PLAN 제외 끝일자
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
                ON  A.SCM_SITE_ID   = DE.SCM_SITE_ID
                AND A.ITEM_ID       = DE.ITEM_ID
                ------------------------------------------------------------------------
        WHERE A.DIVISION_ID     =  @V_DIVISION_ID
        AND A.CUTOFF_YYYYMMDD   =  @V_DEMAND_CUTOFF_DAY
        AND A.VERSION_NO        =  @V_DM_MAX_VERSION
        AND A.ATTRIBUTE1        >= @V_DM_RL_START_DATE
        AND A.ATTRIBUTE1        <  @V_PLAN_END_YYYYMMDD
        AND A.QTY               >  0
        -- DEMAND 제외 대상 처리
	    -- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
        AND (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
            OR (ISNULL(DE.ITEM_ID, '') <> '' AND (A.ATTRIBUTE1 < DE.START_DATE OR A.ATTRIBUTE1 > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
            )
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
        --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        --                   WHERE   PLAN_ID = @V_PLAN_ID
        --                 )
        --소형 생산지 구분을 위한 분리
        AND (   (@V_DIVISION_ID = '40' 
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
        GROUP BY A.SCM_SITE_ID, A.ITEM_ID, MSE.VMI_YN, A.INCOTERMS, A.ATTRIBUTE1
               , B.FLOW_ID, B.OPERATION_GROUP, TP.PRIORITY, A.FCST_TYPE,A.PROJECT_CODE,A.CELL_PROD_SITE_ID
        ) DEMAND
            LEFT OUTER JOIN @CELL_PROD_SITE CPS 
                ON  1=1
                AND DEMAND.SCM_SITE_ID = CPS.SALES_SITE_ID
                AND DEMAND.ITEM_ID     = CPS.ITEM_ID

        /* BLOCKED 2025.10.30 jongykim2: 백업 위치 Rolling 이후로 변경
        ------------------------------------------------------------------------
        -- 1-1. 원본 데이터를 백업 테이블에 저장
        ------------------------------------------------------------------------
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
            FROM @DM_RL_TEMP DM */

        ------------------------------------------------------------------------
        -- 2. DM 누적합과 SSP 누적합을 빼서 계산 된 수량을 구함
		-- 2025.10.24 Philsu Park: 출하실적 대신 매출실적으로 계산 처리.
        ------------------------------------------------------------------------
        INSERT INTO @DM_RL_SUM_TEMP
        SELECT TO_SITE_ID
              ,ITEM_ID
              ,INCOTERMS
              ,PROJECT_CODE
              --,FCST_TYPE
              ,DM_QTY
              ,SHIP_QTY
              ,DM_QTY - SHIP_QTY AS QTY --양수면 DEMAND가 더 많은 경우, 음수면 SHIPMENT가 더 많은 경우
        FROM(
            SELECT TO_SITE_ID
                  ,ITEM_ID
                  ,INCOTERMS
                  ,PROJECT_CODE
                  --,FCST_TYPE
                  ,SUM(DM_QTY)   AS DM_QTY
                  ,SUM(SHIP_QTY) AS SHIP_QTY
            FROM(
                --DM CUTOFF DATE -1일 이후 ~ 오늘 이전 DEMAND 합계 
                SELECT  ATTRIBUTE1    AS TO_SITE_ID
                       ,ATTRIBUTE2    AS ITEM_ID
                       ,ATTRIBUTE4    AS INCOTERMS
                       ,ATTRIBUTE5    AS PROJECT_CODE
                       --,ATTRIBUTE8    AS FCST_TYPE
                       ,SUM(QUANTITY) AS DM_QTY
                       ,0             AS SHIP_QTY
                FROM    @DM_RL_TEMP 
                WHERE   DUE_DATE >= @V_DM_RL_START_DATE
                AND     DUE_DATE <  @V_PLAN_START_YYYYMMDD
                GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE8
                --DM과 SSP 단독으로 있는 경우를 고려해서 UNION ALL 합친 후 계산함
                UNION ALL
				SELECT    SCM_SITE_ID
						, ITEM_ID
						, INCOTERMS
						, PROJECT_CODE
						, 0 			AS DEMAND_QTY
						, SUM(DM_QTY) 	AS SHIP_QTY
				FROm 	@DM_RESULT_TEMP
				GROUP BY  SCM_SITE_ID
						, ITEM_ID
						, INCOTERMS
						, PROJECT_CODE
				
                --DM CUTOFF DATE -1일 이후 ~ 오늘 이전 SSP 합계 
                /* SELECT TO_SITE      AS TO_SITE     
                      ,ITEM_ID      AS ITEM_ID     
                      ,INCOTERMS    AS INCOTERMS   
                      ,PROJECT_CODE AS PROJECT_CODE
                      --,FCST_TYPE    AS FCST_TYPE   
                      ,0            AS DEMAND_QTY
                      ,SUM(QTY)     AS SHIP_QTY
                FROM(
                     SELECT  SRT.TO_SITE
                            ,SRT.ITEM_ID
                            ,SRT.INCOTERMS
                            ,SRT.PROJECT_CODE
                            --,IIF(SSP.FCST_TYPE='-','MPS',SSP.FCST_TYPE) AS FCST_TYPE
                            ,SRT.YYYYMMDD
                            ,SRT.RESULT_QTY  AS QTY
                     FROM    @SHIP_RESULT_TEMP SRT 
                         INNER JOIN (
                                     SELECT ML1.FROM_SITE_ID
                                           ,ML1.ITEM_ID
                                           ,ML2.TO_SITE_ID
                                     FROM(
                                         SELECT  SCM_SITE_ID AS FROM_SITE_ID
                                                ,ITEM_ID
                                         FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)  
                                         WHERE   PLAN_ID = @V_PLAN_ID
                                         AND     STAGE NOT LIKE N'%BIZ'
                                         GROUP BY SCM_SITE_ID, ITEM_ID
                                         ) ML1
                                         INNER JOIN(
                                                   SELECT  SCM_SITE_ID AS TO_SITE_ID
                                                          ,ITEM_ID
                                                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)  
                                                   WHERE   PLAN_ID = @V_PLAN_ID
                                                   AND     STAGE LIKE N'%BIZ'
                                                   GROUP BY SCM_SITE_ID, ITEM_ID
                                                   )ML2
                                             ON  ML1.ITEM_ID = ML2.ITEM_ID
                                    ) ML
                             ON  SRT.FROM_SITE = ML.FROM_SITE_ID
                             AND SRT.ITEM_ID   = ML.ITEM_ID
                             AND SRT.TO_SITE   = ML.TO_SITE_ID
                     ) SRT
                GROUP BY TO_SITE,ITEM_ID,INCOTERMS,PROJECT_CODE */
                )PL
            GROUP BY TO_SITE_ID, ITEM_ID, INCOTERMS, PROJECT_CODE
            ) LA

        ------------------------------------------------------------------------
        -- 3. 계산 된 값이 +인 경우 DEMAND가 더 많았다는 결과이므로 DUE_DATE가 가장 빠른 날짜에 더해줌
        ------------------------------------------------------------------------
        UPDATE  @DM_RL_TEMP
        SET     QUANTITY = DR.QUANTITY + DRS.QTY
        FROM    @DM_RL_TEMP DR
            INNER JOIN(
                      SELECT  ATTRIBUTE1
                             ,ATTRIBUTE2
                             ,ATTRIBUTE4
                             ,ATTRIBUTE5
                             ,ATTRIBUTE8
                             ,MIN(DUE_DATE) AS MIN_DUE_DATE
                      FROM    @DM_RL_TEMP
                      WHERE   DUE_DATE >= @V_PLAN_START_YYYYMMDD
                      GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE8
                      )MD
                ON  DR.ATTRIBUTE1 = MD.ATTRIBUTE1
                AND DR.ATTRIBUTE2 = MD.ATTRIBUTE2
                AND DR.ATTRIBUTE4 = MD.ATTRIBUTE4
                AND DR.ATTRIBUTE5 = MD.ATTRIBUTE5
                AND DR.ATTRIBUTE8 = MD.ATTRIBUTE8
                AND DR.DUE_DATE   = MD.MIN_DUE_DATE
            INNER JOIN @DM_RL_SUM_TEMP DRS
                ON  DR.ATTRIBUTE1 = DRS.TO_SITE_ID
                AND DR.ATTRIBUTE2 = DRS.ITEM_ID
                AND DR.ATTRIBUTE4 = DRS.INCOTERMS
                AND DR.ATTRIBUTE5 = DRS.PROJECT_CODE
                --AND DR.ATTRIBUTE8 = DRS.FCST_TYPE
        WHERE   DRS.QTY > 0

        ------------------------------------------------------------------------
        -- 4. 계산 된 값이 -인 경우 SHIPMENT가 더 많았다는 결과이므로 DUE_DATE가 가장 빠른 날짜부터 DEMAND 수량을 빼 줌
        ------------------------------------------------------------------------
        UPDATE T
        SET    T.QUANTITY = UPD.CAL_QTY
              --,ATTRIBUTE10 = 'TEST'
        FROM @DM_RL_TEMP T
        INNER JOIN(
                       SELECT TO_SITE_ID
                             ,ITEM_ID
                             ,INCOTERMS
                             ,PROJECT_CODE
                             ,FCST_TYPE
                             ,DUE_DATE
                             ,QUANTITY
                             ,CUMULATIVE_QUANTITY
                             ,QTY
                             ,CAL_QTY AS ORI_CAL_QTY
                             ,IIF(CAL_QTY<0,0,CAL_QTY) AS CAL_QTY
                       FROM(
                           SELECT TO_SITE_ID
                                 ,ITEM_ID
                                 ,INCOTERMS
                                 ,PROJECT_CODE
                                 ,FCST_TYPE
                                 ,DUE_DATE
                                 ,QUANTITY
                                 ,CUMULATIVE_QUANTITY
                                 ,QTY
                                 ,CAL_QTY
                                 ,ROW_NUMBER() OVER(PARTITION BY TO_SITE_ID,ITEM_ID,INCOTERMS,PROJECT_CODE,FCST_TYPE, CASE WHEN CAL_QTY > 0 THEN 1 ELSE 0 END ORDER BY DUE_DATE) AS RN -- 음수와 양수 중 첫 번째 날짜 데이터만 가져오기 위해
                           FROM(
                               SELECT DR.TO_SITE_ID
                                     ,DR.ITEM_ID
                                     ,DR.INCOTERMS
                                     ,DR.PROJECT_CODE
                                     ,DR.FCST_TYPE
                                     ,DR.DUE_DATE
                                     ,DR.QUANTITY
                                     ,DR.CUMULATIVE_QUANTITY
                                     ,DRS.QTY
                                     ,DR.CUMULATIVE_QUANTITY + DRS.QTY AS CAL_QTY
                               FROM(
                                   SELECT  ATTRIBUTE1 AS TO_SITE_ID
                                          ,ATTRIBUTE2 AS ITEM_ID
                                          ,ATTRIBUTE4 AS INCOTERMS
                                          ,ATTRIBUTE5 AS PROJECT_CODE
                                          ,ATTRIBUTE8 AS FCST_TYPE
                                          ,DUE_DATE   AS DUE_DATE
                                          ,QUANTITY   AS QUANTITY
                                          ,SUM (QUANTITY) OVER(PARTITION BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE8 ORDER BY DUE_DATE) AS CUMULATIVE_QUANTITY
                                   FROM    @DM_RL_TEMP
                                   WHERE   DUE_DATE >= @V_PLAN_START_YYYYMMDD
                                   ) DR
                                   INNER JOIN @DM_RL_SUM_TEMP DRS
                                       ON  DR.TO_SITE_ID   = DRS.TO_SITE_ID
                                       AND DR.ITEM_ID      = DRS.ITEM_ID
                                       AND DR.INCOTERMS    = DRS.INCOTERMS
                                       AND DR.PROJECT_CODE = DRS.PROJECT_CODE
                                       --AND DR.FCST_TYPE    = DRS.FCST_TYPE
                               WHERE DRS.QTY < 0
                               ) CAL
                           ) RN
                       WHERE RN = 1
                   ) UPD
        ON  T.ATTRIBUTE1   = UPD.TO_SITE_ID
        AND T.ATTRIBUTE2   = UPD.ITEM_ID
        AND T.ATTRIBUTE4   = UPD.INCOTERMS
        AND T.ATTRIBUTE5   = UPD.PROJECT_CODE
        AND T.ATTRIBUTE8   = UPD.FCST_TYPE
        AND T.DUE_DATE     = UPD.DUE_DATE

        ------------------------------------------------------------------------
        -- 5. DEMAND 본 테이블에 INSERT
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
        FROM    @DM_RL_TEMP
        WHERE   QUANTITY > 0
        AND     DUE_DATE >= @V_PLAN_START_YYYYMMDD

    END
    -- LOOKUP에서 ROLLING 사용여부 N인 경우 원래대로 적용
    ELSE IF @V_ROLLING_YN = 'N'
    BEGIN
        ------------------------------------------------------------------------
        -- 1. DM Demand Insert
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
        SELECT   @V_PLAN_ID
                ,SCM_SITE_ID+'::'+DEMAND.ITEM_ID+'::'+STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE+'::'+DUE_DATE+'::'+'-'+'::'+FCST_TYPE+IIF(CPS.ITEM_ID IS NULL,'','::'+DEMAND.CELL_PROD_SITE_ID) AS DEMAND_ID
                ,SCM_SITE_ID+'::'+DEMAND.ITEM_ID+'::'+STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE+IIF(CPS.ITEM_ID IS NULL,'','::'+DEMAND.CELL_PROD_SITE_ID)                                       AS BUFFER_ID
                ,INCOTERMS+'@'+'D'+PRIORITY                                                 AS DEMAND_GROUP
                ,DUE_DATE                                                                   AS DUE_DATE
                ,NULL                                                                       AS TARGET_DATE
                ,NULL                                                                       AS SALES_CUTOFF_DATE
                ,NULL                                                                       AS EXPIRY_DATE
                ,PRIORITY                                                                   AS PRIORITY
                ,QUANTITY                                                                   AS QUANTITY
                ,'D'+PRIORITY                                                               AS PRIORITY_GROUP
                ,NULL                                                                       AS CUSTOMER_ID
                ,NULL                                                                       AS ALLOW_SHORT
                ,SCM_SITE_ID                                                                AS ATTRIBUTE1       
                ,DEMAND.ITEM_ID                                                             AS ATTRIBUTE2
                ,STAGE                                                                      AS ATTRIBUTE3
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
        FROM   (
        SELECT   A.SCM_SITE_ID  AS SCM_SITE_ID
                ,A.ITEM_ID      AS ITEM_ID
                ,CASE   WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'        THEN 'PACKBIZ'
                        WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'        THEN 'MDLEBIZ'
                        WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ'
                        WHEN B.OPERATION_GROUP = 'A'    THEN 'CELLBIZ' 
                 ELSE '-' END                                                               AS STAGE
                ,CASE WHEN ISNULL(MSE.VMI_YN, 'N' ) = 'Y' THEN 'DAP' ELSE A.INCOTERMS END   AS INCOTERMS
              ,A.ATTRIBUTE1                                                                 AS DUE_DATE
              ,SUM(A.QTY)                                                                   AS QUANTITY
              ,TP.PRIORITY                                                                  AS PRIORITY
              ,A.FCST_TYPE                                                                  AS FCST_TYPE
              ,A.PROJECT_CODE                                                               AS PROJECT_CODE
              ,A.CELL_PROD_SITE_ID                                                          AS CELL_PROD_SITE_ID
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
                LEFT OUTER JOIN( --TOSITE PRIORITY CONSTRAINT
                                SELECT  SEGMENT3   AS ITEM_ID 
                                       ,SEGMENT4   AS TO_SITE
                                       ,SEGMENT5   AS PRIORITY
                                       ,ATTRIBUTE1 AS FROM_DATE
                                       ,ATTRIBUTE2 AS TO_DATE
                                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY'
                                AND     SEGMENT2    = @V_DIVISION_ID
                                AND     VALID_YN    = 'Y'
                               ) TP
                ON  A.SCM_SITE_ID = TP.TO_SITE
                AND A.ITEM_ID     = TP.ITEM_ID
                AND A.ATTRIBUTE1 BETWEEN TP.FROM_DATE AND TP.TO_DATE
                ------------------------------------------------------------------------
                -- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
                -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
                ------------------------------------------------------------------------
                LEFT JOIN ( 
                            --SELECT  SEGMENT2   AS DIVISION_ID
                            --        , SEGMENT3   AS SCM_SITE_ID
                            --        , SEGMENT4   AS ITEM_ID
                            --        , SEGMENT5   AS GROUP_ID
                            --        , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                            --            ELSE ATTRIBUTE2
                            --        END AS START_DATE  -- PLAN 제외 시작일자
                            --        , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                            --            ELSE ATTRIBUTE3
                            --        END AS END_DATE  -- PLAN 제외 끝일자
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
                ON  A.SCM_SITE_ID   = DE.SCM_SITE_ID
                AND A.ITEM_ID       = DE.ITEM_ID
                ------------------------------------------------------------------------
        WHERE A.DIVISION_ID     =  @V_DIVISION_ID
        AND A.CUTOFF_YYYYMMDD   =  @V_DEMAND_CUTOFF_DAY
        AND A.VERSION_NO        =  @V_DM_MAX_VERSION
        AND A.ATTRIBUTE1        >= @P_PLAN_NAME
        AND A.ATTRIBUTE1        <  @V_PLAN_END_YYYYMMDD
        AND A.QTY               >  0
        -- DEMAND 제외 대상 처리
    	-- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
        AND (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
            OR (ISNULL(DE.ITEM_ID, '') <> '' AND (A.ATTRIBUTE1 < DE.START_DATE OR A.ATTRIBUTE1 > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
            )
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
        --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        --                   WHERE   PLAN_ID = @V_PLAN_ID
        --                 )
        --소형 생산지 구분을 위한 분리
        AND (   (@V_DIVISION_ID = '40' 
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
        GROUP BY A.SCM_SITE_ID, A.ITEM_ID, MSE.VMI_YN, A.INCOTERMS, A.ATTRIBUTE1
               , B.FLOW_ID, B.OPERATION_GROUP, TP.PRIORITY, A.FCST_TYPE,A.PROJECT_CODE,A.CELL_PROD_SITE_ID
        ) DEMAND
            LEFT OUTER JOIN @CELL_PROD_SITE CPS 
                ON  1=1
                AND DEMAND.SCM_SITE_ID = CPS.SALES_SITE_ID
                AND DEMAND.ITEM_ID     = CPS.ITEM_ID
    END

        -- START 2025.10.31 jongykim2: 백업 위치 Rolling 이후로 변경
        ------------------------------------------------------------------------
        -- 1-1. 원본 데이터를 백업 테이블에 저장
        ------------------------------------------------------------------------
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
            FROM @DM_RL_TEMP DM;
            -- END 2025.10.31 jongykim2

 --   ------------------------------------------------------------------------
 --   -- 1. DM Demand Insert
 --   ------------------------------------------------------------------------
 --   INSERT INTO SCP_OPT_ENG_DEMAND_SN
 --       (PLAN_ID
 --       ,DEMAND_ID
 --       ,BUFFER_ID
 --       ,DEMAND_GROUP
 --       ,DUE_DATE
 --       ,TARGET_DATE
 --       ,SALES_CUTOFF_DATE
 --       ,EXPIRY_DATE
 --       ,PRIORITY
 --       ,QUANTITY
 --       ,PRIORITY_GROUP
 --       ,CUSTOMER_ID
 --       ,ALLOW_SHORT
 --       ,ATTRIBUTE1
 --       ,ATTRIBUTE2
 --       ,ATTRIBUTE3
 --       ,ATTRIBUTE4
 --       ,ATTRIBUTE5
 --       ,ATTRIBUTE6
 --       ,ATTRIBUTE7
 --       ,ATTRIBUTE8
 --       ,ATTRIBUTE9
 --       ,ATTRIBUTE10
 --       ,ATTRIBUTE11
 --       ,ATTRIBUTE12
 --       ,ATTRIBUTE13
 --       ,ATTRIBUTE14
 --       ,ATTRIBUTE15
 --       )
 --   SELECT   @V_PLAN_ID
 --           ,SCM_SITE_ID+'::'+DEMAND.ITEM_ID+'::'+STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE+'::'+DUE_DATE+'::'+'-'+'::'+FCST_TYPE+IIF(CPS.ITEM_ID IS NULL,'','::'+DEMAND.CELL_PROD_SITE_ID) AS DEMAND_ID
 --           ,SCM_SITE_ID+'::'+DEMAND.ITEM_ID+'::'+STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE+IIF(CPS.ITEM_ID IS NULL,'','::'+DEMAND.CELL_PROD_SITE_ID)                                       AS BUFFER_ID
 --           ,INCOTERMS+'@'+'D'+PRIORITY                                                 AS DEMAND_GROUP
 --           ,DUE_DATE                                                                   AS DUE_DATE
 --           ,NULL                                                                       AS TARGET_DATE
 --           ,NULL                                                                       AS SALES_CUTOFF_DATE
 --           ,NULL                                                                       AS EXPIRY_DATE
 --           ,PRIORITY                                                                   AS PRIORITY
 --           ,QUANTITY                                                                   AS QUANTITY
 --           ,'D'+PRIORITY                                                               AS PRIORITY_GROUP
 --           ,NULL                                                                       AS CUSTOMER_ID
 --           ,NULL                                                                       AS ALLOW_SHORT
 --           ,SCM_SITE_ID                                                                AS ATTRIBUTE1       
 --           ,DEMAND.ITEM_ID                                                             AS ATTRIBUTE2
 --           ,STAGE                                                                      AS ATTRIBUTE3
 --           ,INCOTERMS                                                                  AS ATTRIBUTE4
 --           ,PROJECT_CODE                                                               AS ATTRIBUTE5
 --           ,NULL                                                                       AS ATTRIBUTE6
 --           ,NULL                                                                       AS ATTRIBUTE7
 --           ,FCST_TYPE                                                                  AS ATTRIBUTE8
 --           ,NULL                                                                       AS ATTRIBUTE9
 --           ,NULL                                                                       AS ATTRIBUTE10
 --           ,NULL                                                                       AS ATTRIBUTE11
 --           ,NULL                                                                       AS ATTRIBUTE12
 --           ,NULL                                                                       AS ATTRIBUTE13
 --           ,NULL                                                                       AS ATTRIBUTE14
 --           ,NULL                                                                       AS ATTRIBUTE15
 --   FROM   (
 --   SELECT   A.SCM_SITE_ID  AS SCM_SITE_ID
 --           ,A.ITEM_ID      AS ITEM_ID
 --           ,CASE   WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'        THEN 'PACKBIZ'
 --                   WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'        THEN 'MDLEBIZ'
 --                   WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ'
 --                   WHEN B.OPERATION_GROUP = 'A'    THEN 'CELLBIZ' 
 --            ELSE '-' END                                                               AS STAGE
 --           ,CASE WHEN ISNULL(MSE.VMI_YN, 'N' ) = 'Y' THEN 'DAP' ELSE A.INCOTERMS END   AS INCOTERMS
 --         ,A.ATTRIBUTE1                                                                 AS DUE_DATE
 --         ,SUM(A.QTY)                                                                   AS QUANTITY
 --         ,TP.PRIORITY                                                                  AS PRIORITY
 --         ,A.FCST_TYPE                                                                  AS FCST_TYPE
 --         ,A.PROJECT_CODE                                                               AS PROJECT_CODE
 --         ,A.CELL_PROD_SITE_ID                                                          AS CELL_PROD_SITE_ID
 --   FROM DM_PLN_NET_DEMAND A WITH (NOLOCK)
 --           ------------------------------------------------------------------------
 --           INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
 --                       FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
 --                       WHERE  DIVISION_ID = @V_DIVISION_ID  
	--					AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
 --                          OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
 --                             )
 --                      ) B
 --           ON    A.ITEM_ID     = B.ITEM_ID
 --           AND   A.DIVISION_ID = B.DIVISION_ID 
 --           ------------------------------------------------------------------------
 --           LEFT JOIN ( -- VMI 대상 SITE 조회
 --                       SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN 
 --                       FROM   SCM_MST_SITE  WITH (NOLOCK)
 --                       WHERE  DIVISION_ID = @V_DIVISION_ID 
 --                           AND SITE_TYPE   = 'SALES'
 --                           AND  VALID_YN    = 'Y'
 --                           AND  VMI_YN      = 'Y'
 --                       ) MSE
 --           ON   A.DIVISION_ID      = MSE.DIVISION_ID
 --           AND  A.SCM_SITE_ID      = MSE.SCM_SITE_ID 
 --           ------------------------------------------------------------------------
 --           LEFT OUTER JOIN( --TOSITE PRIORITY CONSTRAINT
 --                           SELECT  SEGMENT3   AS ITEM_ID 
 --                                  ,SEGMENT4   AS TO_SITE
 --                                  ,SEGMENT5   AS PRIORITY
 --                                  ,ATTRIBUTE1 AS FROM_DATE
 --                                  ,ATTRIBUTE2 AS TO_DATE
 --                           FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
 --                           WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY'
 --                           AND     SEGMENT2    = @V_DIVISION_ID
 --                           AND     VALID_YN    = 'Y'
 --                          ) TP
 --           ON  A.SCM_SITE_ID = TP.TO_SITE
 --           AND A.ITEM_ID     = TP.ITEM_ID
 --           AND A.ATTRIBUTE1 BETWEEN TP.FROM_DATE AND TP.TO_DATE
 --           ------------------------------------------------------------------------
 --           -- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
 --           -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
 --           ------------------------------------------------------------------------
 --           LEFT JOIN ( SELECT  SEGMENT2   AS DIVISION_ID
 --                               , SEGMENT3   AS SCM_SITE_ID
 --                               , SEGMENT4   AS ITEM_ID
 --                               , SEGMENT5   AS GROUP_ID
 --                               , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
 --                                   ELSE ATTRIBUTE2
 --                               END AS START_DATE  -- PLAN 제외 시작일자
 --                               , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
 --                                   ELSE ATTRIBUTE3
 --                               END AS END_DATE  -- PLAN 제외 끝일자
 --                       FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
 --                       WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
 --                       AND    VALID_YN    = 'Y'
 --                       AND    SEGMENT2    = @V_DIVISION_ID
 --                       AND    SEGMENT5    = @V_GROUP_ID
 --                       ) DE
 --           ON  A.SCM_SITE_ID   = DE.SCM_SITE_ID
 --           AND A.ITEM_ID       = DE.ITEM_ID
 --           ------------------------------------------------------------------------
 --   WHERE A.DIVISION_ID     =  @V_DIVISION_ID
 --   AND A.CUTOFF_YYYYMMDD   =  @V_DEMAND_CUTOFF_DAY
 --   AND A.VERSION_NO        =  @V_DM_MAX_VERSION
 --   AND A.ATTRIBUTE1        >= @P_PLAN_NAME
 --   AND A.ATTRIBUTE1        <  @V_PLAN_END_YYYYMMDD
 --   AND A.QTY               >  0
 --   -- DEMAND 제외 대상 처리
	---- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
 --   AND (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
 --       OR (ISNULL(DE.ITEM_ID, '') <> '' AND (A.ATTRIBUTE1 < DE.START_DATE OR A.ATTRIBUTE1 > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
 --       )
 --   --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
 --   --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
 --   --                   WHERE   PLAN_ID = @V_PLAN_ID
 --   --                 )
 --   --소형 생산지 구분을 위한 분리
 --   AND (   (@V_DIVISION_ID = '40' 
 --                                  --상현 책임님 요청으로 SALES SITE는 MEDEL LIST를 고려하지 않도록 수정/20250526/김태현선임
 --                                  --AND CONCAT(A.SCM_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID)
 --                                  --                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
 --                                  --                                        WHERE   PLAN_ID = @V_PLAN_ID 
 --                                  --                                       )
 --                                  AND CONCAT(A.CELL_PROD_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT(SCM_SITE_ID,ITEM_ID)
 --                                                                                FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)					
 --                                                                                WHERE   PLAN_ID = @V_PLAN_ID
 --                                                                                )
 --           )
 --        OR (@V_DIVISION_ID != '40' AND  A.ITEM_ID IN (SELECT DISTINCT ITEM_ID 
 --                                                      FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
 --                                                      WHERE   PLAN_ID = @V_PLAN_ID
 --                                                     )
 --           )
 --      )
 --               --------------------------
 --   GROUP BY A.SCM_SITE_ID, A.ITEM_ID, MSE.VMI_YN, A.INCOTERMS, A.ATTRIBUTE1
 --          , B.FLOW_ID, B.OPERATION_GROUP, TP.PRIORITY, A.FCST_TYPE,A.PROJECT_CODE,A.CELL_PROD_SITE_ID
 --   ) DEMAND
 --       LEFT OUTER JOIN @CELL_PROD_SITE CPS 
 --           ON  1=1
 --           AND DEMAND.SCM_SITE_ID = CPS.SALES_SITE_ID
 --           AND DEMAND.ITEM_ID     = CPS.ITEM_ID

    ------------------------------------------------------------------------
    -- 2. Shipment Plan Semi => Demand Insert : 소형 - Cell Plant 의 CHAR Stage에 Demand 처리
    -- 2025.05.07 Philsu Park: SHIPTMENT_SNAPSHOT_COUNT > 0 일 때는 해당 데이터 사용, 아닐때는 기존 로직으로 분기.
    ------------------------------------------------------------------------
    /* IF @V_DIVISION_ID = '40'
        IF @V_SHIPMENT_SNAP_CNT > 0
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
                SELECT   @V_PLAN_ID
                        ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+DUE_DATE+'::'+TO_SITE+'::'+INCOTERMS+'::'+TRANSPORT_MODE+'::'+'REQ' AS DEMAND_ID
                        ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE                                AS BUFFER_ID
                        --,TO_SITE                                                            AS DEMAND_GROUP
                        -- Ship Frozen 내인 경우 'SF'
                        ,CASE WHEN SHIP_FROZEN = 'Y' THEN 'SF'
                            ELSE NULL
                        END                                                                AS DEMAND_GROUP
                        ,DUE_DATE                                                           AS DUE_DATE
                        ,NULL                                                               AS TARGET_DATE
                        ,NULL                                                               AS SALES_CUTOFF_DATE
                        ,NULL                                                               AS EXPIRY_DATE
                        ,NULL                                                               AS PRIORITY
                        -- Ship Frozen 내인 경우 ''
                        --,CASE WHEN SHIP_FROZEN = 'Y' THEN ''
                        --      ELSE NULL
                        -- END                                                                AS PRIORITY
                        ,QUANTITY                                                           AS QUANTITY
                        --,NULL                                                               AS PRIORITY_GROUP
                        -- Ship Frozen 내인 경우 'SF'
                        ,CASE WHEN SHIP_FROZEN = 'Y' THEN 'SF'
                            ELSE NULL
                        END                                                                AS PRIORITY_GROUP
                        ,NULL                                                               AS CUSTOMER_ID
                        ,NULL                                                               AS ALLOW_SHORT
                        ,SCM_SITE_ID                                                        AS ATTRIBUTE1       
                        ,ITEM_ID                                                            AS ATTRIBUTE2
                        ,STAGE                                                              AS ATTRIBUTE3
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
                FROM   (
                        SELECT A.FROM_SITE    AS SCM_SITE_ID
                            ,A.TO_SITE      AS TO_SITE
                            ,A.ITEM_ID      AS ITEM_ID
                            ,'CHAR'         AS STAGE
                            --,'EXW'          AS INCOTERMS
                            ,BOD.INCOTERMS       AS INCOTERMS
                            ,BOD.TRANSPORT_MODE  AS TRANSPORT_MODE
                            ,A.YYYYMMDD     AS DUE_DATE  
                            ,CASE WHEN A.YYYYMMDD < @V_SHIP_FROZEN_DAY THEN 'Y'
                                    ELSE 'N'
                            END AS SHIP_FROZEN
                            ,SUM(A.QTY)     AS QUANTITY
                        FROM SCP_OPT_ENG_SHIPMENT_PLAN_SEMI_SNAPSHOT_SN A WITH (NOLOCK)
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
                        -- DEMAND 제외 대상 ITEM 정보 : WHERE 절에서 제외 조건 처리
                        -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
                        ------------------------------------------------------------------------
                        LEFT JOIN ( SELECT  SEGMENT2   AS DIVISION_ID
                                            , SEGMENT3   AS SCM_SITE_ID
                                            , SEGMENT4   AS ITEM_ID
                                            , SEGMENT5   AS GROUP_ID
                                            , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                                                ELSE ATTRIBUTE2
                                            END AS START_DATE  -- PLAN 제외 시작일자
                                            , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                                                ELSE ATTRIBUTE3
                                            END AS END_DATE  -- PLAN 제외 끝일자
                                    FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                                    WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                                    AND    VALID_YN    = 'Y'
                                    AND    SEGMENT2    = @V_DIVISION_ID
                                    AND    SEGMENT5    = @V_GROUP_ID
                                    ) DE
                            ON  A.FROM_SITE = DE.SCM_SITE_ID
                            AND A.ITEM_ID   = DE.ITEM_ID
                        ------------------------------------------------------------------------
                        WHERE   A.DIVISION_ID           = @V_DIVISION_ID
                        AND     A.plan_start_yyyymmdd   = @V_SCP_PLAN_DATE
                        -- AND   A.plan_type           = @V_SCP_PLAN_TYPE 
                        -- AND   A.seq                 = @V_SCP_PLAN_SEQ  
                        AND     A.measure               = 'SHIP_PLAN_AMEND'
                        AND     A.QTY                   > 0
                        AND     A.YYYYMMDD             >= @P_PLAN_NAME
                        AND     A.YYYYMMDD              < @V_PLAN_END_YYYYMMDD
                        -- DEMAND 제외 대상 처리
                        -- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
                        AND     (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
                            OR  (ISNULL(DE.ITEM_ID, '') <> '' AND (A.YYYYMMDD < DE.START_DATE OR A.YYYYMMDD > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
                                )
                        AND     A.ITEM_ID              IN ( SELECT  DISTINCT ITEM_ID 
                                                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                            WHERE   PLAN_ID = @V_PLAN_ID
                                                            )
                        GROUP BY A.FROM_SITE, A.TO_SITE, A.ITEM_ID, A.YYYYMMDD, BOD.INCOTERMS, BOD.TRANSPORT_MODE
                        ) DEMAND 
            END
        ELSE 
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
                SELECT   @V_PLAN_ID
                        ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+DUE_DATE+'::'+TO_SITE+'::'+INCOTERMS+'::'+TRANSPORT_MODE+'::'+'REQ' AS DEMAND_ID
                        ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE                                AS BUFFER_ID
                        --,TO_SITE                                                            AS DEMAND_GROUP
                        -- Ship Frozen 내인 경우 'SF'
                        ,CASE WHEN SHIP_FROZEN = 'Y' THEN 'SF'
                            ELSE NULL
                        END                                                                AS DEMAND_GROUP
                        ,DUE_DATE                                                           AS DUE_DATE
                        ,NULL                                                               AS TARGET_DATE
                        ,NULL                                                               AS SALES_CUTOFF_DATE
                        ,NULL                                                               AS EXPIRY_DATE
                        ,NULL                                                               AS PRIORITY
                        -- Ship Frozen 내인 경우 ''
                        --,CASE WHEN SHIP_FROZEN = 'Y' THEN ''
                        --      ELSE NULL
                        -- END                                                                AS PRIORITY
                        ,QUANTITY                                                           AS QUANTITY
                        --,NULL                                                               AS PRIORITY_GROUP
                        -- Ship Frozen 내인 경우 'SF'
                        ,CASE WHEN SHIP_FROZEN = 'Y' THEN 'SF'
                            ELSE NULL
                        END                                                                AS PRIORITY_GROUP
                        ,NULL                                                               AS CUSTOMER_ID
                        ,NULL                                                               AS ALLOW_SHORT
                        ,SCM_SITE_ID                                                        AS ATTRIBUTE1       
                        ,ITEM_ID                                                            AS ATTRIBUTE2
                        ,STAGE                                                              AS ATTRIBUTE3
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
                        SELECT A.FROM_SITE    AS SCM_SITE_ID
                            ,A.TO_SITE      AS TO_SITE
                            ,A.ITEM_ID      AS ITEM_ID
                            ,'CHAR'         AS STAGE
                            --,'EXW'          AS INCOTERMS
                            ,BOD.INCOTERMS       AS INCOTERMS
                            ,BOD.TRANSPORT_MODE  AS TRANSPORT_MODE
                            ,A.YYYYMMDD     AS DUE_DATE  
                            ,CASE WHEN A.YYYYMMDD < @V_SHIP_FROZEN_DAY THEN 'Y'
                                    ELSE 'N'
                            END AS SHIP_FROZEN
                            ,SUM(A.QTY)     AS QUANTITY
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
                        -- DEMAND 제외 대상 ITEM 정보 : WHERE 절에서 제외 조건 처리
                        -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
                        ------------------------------------------------------------------------
                        LEFT JOIN ( SELECT  SEGMENT2   AS DIVISION_ID
                                            , SEGMENT3   AS SCM_SITE_ID
                                            , SEGMENT4   AS ITEM_ID
                                            , SEGMENT5   AS GROUP_ID
                                            , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                                                ELSE ATTRIBUTE2
                                            END AS START_DATE  -- PLAN 제외 시작일자
                                            , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                                                ELSE ATTRIBUTE3
                                            END AS END_DATE  -- PLAN 제외 끝일자
                                    FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                                    WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                                    AND    VALID_YN    = 'Y'
                                    AND    SEGMENT2    = @V_DIVISION_ID
                                    AND    SEGMENT5    = @V_GROUP_ID
                                    ) DE
                            ON  A.FROM_SITE = DE.SCM_SITE_ID
                            AND A.ITEM_ID   = DE.ITEM_ID
                        ------------------------------------------------------------------------
                        WHERE A.DIVISION_ID         = @V_DIVISION_ID
                        AND   A.plan_start_yyyymmdd = @V_SCP_PLAN_DATE
                        AND   A.plan_type           = @V_SCP_PLAN_TYPE 
                        AND   A.seq                 = @V_SCP_PLAN_SEQ  
                        AND   A.measure             = 'SHIP_PLAN_AMEND'
                        AND   A.QTY                 > 0   
                        AND   A.YYYYMMDD            >= @P_PLAN_NAME  
                        AND   A.YYYYMMDD            < @V_PLAN_END_YYYYMMDD
                        -- DEMAND 제외 대상 처리
                        -- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
                        AND     (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
                            OR  (ISNULL(DE.ITEM_ID, '') <> '' AND (A.YYYYMMDD < DE.START_DATE OR A.YYYYMMDD > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
                                )
                        AND   A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID 
                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE   PLAN_ID = @V_PLAN_ID
                                        )
                        GROUP BY A.FROM_SITE, A.TO_SITE, A.ITEM_ID, A.YYYYMMDD, BOD.INCOTERMS, BOD.TRANSPORT_MODE

                        ) DEMAND
                        
            END -- IF @V_DIVISION_ID = '40'
     */
    ------------------------------------------------------------------------
    -- 2. DEMAND GROUP
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
        ;

        
        ------------------------------------------------------------------------
        -- 2-4. 추가로 만든 GROUP에 대한 DEMAND INSERT
        -- 2025.09.19 Philsu Park: Group Demand 에 대한 수요 평준화 작업 후 반영
        ------------------------------------------------------------------------
        -- 기존 Group Demand를 ORG에 백업.
        /* -- BLOCKED 2025.10.31 jongykim2: 필요시 개방할 것
        INSERT INTO SCP_OPT_ENG_DEMAND_ORIGIN_SN(
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
              ,'GROUP_BK::'+DEMAND_ID           AS DEMAND_ID
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
        ;
        */
        


        WITH CALENDAR AS (
                            SELECT    CAL.BASIS_YYYYMM AS PLAN_YYYYMM
                                    , CAL.BASIS_YYYYMMDD AS PLAN_YYYYMMDD
                                    , COUNT(*)OVER(PARTITION BY CAL.BASIS_YYYYMM) AS AVAIL_DAYS
                            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
                            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD_ORI
                            AND     NOT EXISTS ( 
                                                    --SELECT    SEGMENT5   AS INCOTERMS
                                                    --        , ATTRIBUTE1 AS BOD_ID
                                                    --        , ATTRIBUTE2 AS FROM_SITE
                                                    --        , ATTRIBUTE3 AS TO_SITE
                                                    --        , ATTRIBUTE4 AS TRANSPORT_MODE
                                                    --        , ATTRIBUTE5 AS FROM_DATE
                                                    --        , ATTRIBUTE6 AS TO_DATE
                                                    --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                                                    --WHERE   LK.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_BOD_BLOCKING'
                                                    --AND     LK.SEGMENT2     = @V_DIVISION_ID
                                                    --AND     LK.SEGMENT3     = @V_GROUP_ID
                                                    --AND     LK.VALID_YN     = 'Y'
                                                    --AND     CAL.BASIS_YYYYMMDD >= LK.ATTRIBUTE5
                                                    --AND     CAL.BASIS_YYYYMMDD <= LK.ATTRIBUTE6

                                                -- 2026.04.29 Minyong Lee : Lookup -> UI 전환 (BOD Blocking)
                                                SELECT    BE.BOD_ID                 AS BOD_ID
                                                        , BE.BOD_EX_FROM_YYYYMMDD   AS FROM_DATE
                                                        , BE.BOD_EX_TO_YYYYMMDD     AS TO_DATE
                                                FROM    SCP_OPMZ_BOD_EXCLUDED_ITEM BE WITH(NOLOCK)
                                                WHERE   1=1
                                                AND     BE.DIVISION_ID      = @V_DIVISION_ID
                                                AND     BE.VALID_YN         = 'Y'
                                                AND     CAL.BASIS_YYYYMMDD  >= BE.BOD_EX_FROM_YYYYMMDD
                                                AND     CAL.BASIS_YYYYMMDD  <= BE.BOD_EX_TO_YYYYMMDD
                                                )
                            )
            , DEMAND_ORG AS (
                                SELECT    CM.BASIS_YYYYMM                   AS BASIS_YYYYMM
                                        , MAX(D.DEMAND_ID)                  AS DEMAND_ID
                                        -- , D.BUFFER_ID                       AS BUFFER_ID
                                        , D.ATTRIBUTE1+'::'+D.GROUP_ID+'::'+D.ATTRIBUTE3+'@'+D.ATTRIBUTE4+'@'+D.ATTRIBUTE5 AS BUFFER_ID
                                        , D.ATTRIBUTE1, D.GROUP_ID AS ATTRIBUTE2, D.ATTRIBUTE3, D.ATTRIBUTE4, D.ATTRIBUTE5, D.ATTRIBUTE8, 'DEMAND_GROUP' AS ATTRIBUTE12
                                        , SUM(D.QUANTITY)                   AS MONTHLY_TOTAL_QTY
                                        , SUM(D.QUANTITY) / @V_QTY_PER_CONTAINER           AS MON_CNTR_QTY
                                        , CONVERT(NUMERIC(20, 10), @V_QTY_PER_CONTAINER)   AS QTY_PER_CNTR
                                FROM    @DM_TEMP D
                                INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                                ON  CM.BASIS_YYYYMMDD = D.DUE_DATE
                                GROUP BY CM.BASIS_YYYYMM, D.GROUP_ID, D.ATTRIBUTE1, D.ATTRIBUTE3, D.ATTRIBUTE4, D.ATTRIBUTE5, D.ATTRIBUTE8
                            )
            -- 2026.05.22 Minyong Lee : GM조립 Demand 수량 LOT_SIZE로 평준화 로직 오류 수정
            --, MAIN AS       ( 
            --                    SELECT    DM.DEMAND_ID
            --                            , DM.BUFFER_ID
            --                            , DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE3, DM.ATTRIBUTE4, DM.ATTRIBUTE5, DM.ATTRIBUTE8, DM.ATTRIBUTE12
            --                            , CM.PLAN_YYYYMM
            --                            , CM.PLAN_YYYYMMDD
            --                            , DM.MON_CNTR_QTY
            --                            , DM.MON_CNTR_QTY - CONVERT(NUMERIC(20, 10), (FLOOR(ROUND(DM.MON_CNTR_QTY / CM.AVAIL_DAYS, 0)) * CM.AVAIL_DAYS)) AS REMAIN_CNTR_QTY
            --                            -- , FLOOR(DM.MON_CNTR_QTY - CONVERT(NUMERIC(20, 10), (FLOOR(ROUND(DM.MON_CNTR_QTY / CM.AVAIL_DAYS, 0)) * CM.AVAIL_DAYS))) AS REMAIN_CNTR_INT_QTY
            --                            , CASE  WHEN FLOOR(DM.MON_CNTR_QTY - CONVERT(NUMERIC(20, 10), (FLOOR(ROUND(DM.MON_CNTR_QTY / CM.AVAIL_DAYS, 0)) * CM.AVAIL_DAYS))) > 0 
            --                                    THEN FLOOR(DM.MON_CNTR_QTY - CONVERT(NUMERIC(20, 10), (FLOOR(ROUND(DM.MON_CNTR_QTY / CM.AVAIL_DAYS, 0)) * CM.AVAIL_DAYS)))
            --                                    ELSE FLOOR(DM.MON_CNTR_QTY - CONVERT(NUMERIC(20, 10), (FLOOR(ROUND(DM.MON_CNTR_QTY / CM.AVAIL_DAYS, 0)) * CM.AVAIL_DAYS))) + 1
            --                                    END AS REMAIN_CNTR_INT_QTY -- 일자별 1/N 하고 남는 컨테이너 잔량 정수값. 음수인 경우 +1 처리 필요.
            --                            , (DM.MON_CNTR_QTY - CONVERT(NUMERIC(20, 10), (FLOOR(ROUND(DM.MON_CNTR_QTY / CM.AVAIL_DAYS, 0)) * CM.AVAIL_DAYS)))
            --                            - CONVERT(NUMERIC(20, 10), 
            --                                        CASE    WHEN FLOOR(DM.MON_CNTR_QTY - CONVERT(NUMERIC(20, 10), (FLOOR(ROUND(DM.MON_CNTR_QTY / CM.AVAIL_DAYS, 0)) * CM.AVAIL_DAYS))) > 0 
            --                                                THEN FLOOR(DM.MON_CNTR_QTY - CONVERT(NUMERIC(20, 10), (FLOOR(ROUND(DM.MON_CNTR_QTY / CM.AVAIL_DAYS, 0)) * CM.AVAIL_DAYS)))
            --                                                ELSE FLOOR(DM.MON_CNTR_QTY - CONVERT(NUMERIC(20, 10), (FLOOR(ROUND(DM.MON_CNTR_QTY / CM.AVAIL_DAYS, 0)) * CM.AVAIL_DAYS))) + 1
            --                                                END) AS REMAIN_CNTR_DEC_QTY -- 일자별 1/N 하고 남는 컨테이너 잔량 소수값
            --                            , FLOOR(ROUND(DM.MON_CNTR_QTY / CM.AVAIL_DAYS, 0)) AS DAILY_CNTR_QTY -- 일자별 1/N 컨테이너 수량
            --                            , CM.AVAIL_DAYS     -- 월별 가용일자
            --                            , DM.QTY_PER_CNTR   -- 컨테이너 대당 수량
            --                            , ROW_NUMBER()OVER(PARTITION BY DM.BUFFER_ID, CM.PLAN_YYYYMM, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE3, DM.ATTRIBUTE4, DM.ATTRIBUTE5, DM.ATTRIBUTE8 ORDER BY PLAN_YYYYMMDD DESC)     AS R_NUM_DESC
            --                            , ROW_NUMBER()OVER(PARTITION BY DM.BUFFER_ID, CM.PLAN_YYYYMM, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE3, DM.ATTRIBUTE4, DM.ATTRIBUTE5, DM.ATTRIBUTE8 ORDER BY PLAN_YYYYMMDD)          AS R_NUM_ASC
            --                    FROM    DEMAND_ORG DM
            --                    INNER JOIN CALENDAR CM
            --                            ON CM.PLAN_YYYYMM = DM.BASIS_YYYYMM
            --                    WHERE   1=1
            --                    )
            --, FINAL AS      (
            --                    SELECT    DEMAND_ID
            --                            , BUFFER_ID
            --                            , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE8, ATTRIBUTE12
            --                            , PLAN_YYYYMM
            --                            , PLAN_YYYYMMDD
            --                            , MON_CNTR_QTY
            --                            , REMAIN_CNTR_QTY
            --                            , REMAIN_CNTR_INT_QTY
            --                            , REMAIN_CNTR_DEC_QTY
            --                            , DAILY_CNTR_QTY
            --                            , R_NUM_DESC
            --                            , R_NUM_ASC
            --                            , AVAIL_DAYS
            --                            , CASE WHEN REMAIN_CNTR_QTY > 0 THEN IIF(REMAIN_CNTR_INT_QTY - R_NUM_ASC < 0, 0, 1)
            --                                    ELSE IIF(R_NUM_DESC + REMAIN_CNTR_INT_QTY > 0, 0, -1) END AS ADD_INT_QTY
            --                            -- , IIF(R_NUM_DESC + REMAIN_CNTR_INT_QTY > 0, 0, -1) AS ADD_INT_QTY
            --                            , IIF(R_NUM_ASC = AVAIL_DAYS, REMAIN_CNTR_DEC_QTY, 0) AS ADD_DEC_QTY
            --                            -- , QTY_PER_CNTR * (CONVERT(NUMERIC(20, 10), DAILY_CNTR_QTY) + CONVERT(NUMERIC(20, 10), IIF(R_NUM_DESC + REMAIN_CNTR_INT_QTY > 0, 0, -1)) + IIF(R_NUM_ASC = AVAIL_DAYS, REMAIN_CNTR_DEC_QTY, 0)) AS FINAL_QTY
            --                            /* , QTY_PER_CNTR * (CONVERT(NUMERIC(20, 10), DAILY_CNTR_QTY) + CONVERT(NUMERIC(20, 10), CASE WHEN REMAIN_CNTR_QTY > 0 THEN IIF(REMAIN_CNTR_INT_QTY - R_NUM_ASC < 0, 0, 1)
            --                                    ELSE IIF(R_NUM_DESC + REMAIN_CNTR_INT_QTY > 0, 0, -1) END) + IIF(R_NUM_ASC = AVAIL_DAYS, REMAIN_CNTR_DEC_QTY, 0)) AS FINAL_QTY */
            --                            -- 산식: 올림처리(컨테이너 대당 수량 * (일자별 수량 +/- 잔량 정수 +/- 잔량 소수))
            --                            , CEILING(QTY_PER_CNTR * (CONVERT(NUMERIC(20, 10), DAILY_CNTR_QTY) + CONVERT(NUMERIC(20, 10), CASE WHEN REMAIN_CNTR_QTY > 0 THEN IIF(REMAIN_CNTR_INT_QTY - R_NUM_ASC < 0, 0, 1)
            --                                    ELSE IIF(R_NUM_DESC + REMAIN_CNTR_INT_QTY > 0, 0, -1) END) + IIF(R_NUM_ASC = AVAIL_DAYS, REMAIN_CNTR_DEC_QTY, 0))) AS FINAL_QTY
            --                            -- , IIF(AVAIL_DAYS = R_NUM_DES)
            --                    FROM    MAIN
            --                    WHERE   1=1
            --                    )
            ---- and     REMAIN_CNTR_QTY > 0
            , MAIN AS       ( 
                                SELECT    DM.DEMAND_ID
                                        , DM.BUFFER_ID
                                        , DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE3, DM.ATTRIBUTE4, DM.ATTRIBUTE5, DM.ATTRIBUTE8, DM.ATTRIBUTE12
                                        , CM.PLAN_YYYYMM
                                        , CM.PLAN_YYYYMMDD
                                        , DM.MONTHLY_TOTAL_QTY
                                        , DM.MON_CNTR_QTY
                                        , FLOOR(DM.MON_CNTR_QTY / CM.AVAIL_DAYS) AS MAX_COM_CNTR_QTY -- 하루에 동일하게 들어갈 수 있는 컨테이너 수량
                                        , DM.MON_CNTR_QTY - (CONVERT(FLOAT, FLOOR(DM.MON_CNTR_QTY / CM.AVAIL_DAYS)) * CM.AVAIL_DAYS) AS REMAIN_CNTR_QTY
                                        , CM.AVAIL_DAYS     -- 월별 가용일자
                                        , DM.QTY_PER_CNTR   -- 컨테이너 대당 수량
                                        , ROW_NUMBER()OVER(PARTITION BY DM.BUFFER_ID, CM.PLAN_YYYYMM, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE3, DM.ATTRIBUTE4, DM.ATTRIBUTE5, DM.ATTRIBUTE8 ORDER BY PLAN_YYYYMMDD DESC)     AS R_NUM_DESC
                                        , ROW_NUMBER()OVER(PARTITION BY DM.BUFFER_ID, CM.PLAN_YYYYMM, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE3, DM.ATTRIBUTE4, DM.ATTRIBUTE5, DM.ATTRIBUTE8 ORDER BY PLAN_YYYYMMDD)          AS R_NUM_ASC
                                FROM    DEMAND_ORG DM
                                INNER JOIN CALENDAR CM
                                        ON CM.PLAN_YYYYMM = DM.BASIS_YYYYMM
                                WHERE   1=1
                                )
            , FINAL AS      (
                                SELECT  MA.DEMAND_ID
                                      , MA.BUFFER_ID
                                      , MA.ATTRIBUTE1, MA.ATTRIBUTE2, MA.ATTRIBUTE3, MA.ATTRIBUTE4, MA.ATTRIBUTE5, MA.ATTRIBUTE8, MA.ATTRIBUTE12
                                      , MA.PLAN_YYYYMM
                                      , MA.PLAN_YYYYMMDD
                                      , MA.MONTHLY_TOTAL_QTY
                                      , MA.MON_CNTR_QTY
                                      , MA.MAX_COM_CNTR_QTY
                                      , MA.REMAIN_CNTR_QTY
                                      , MA.AVAIL_DAYS
                                      , MA.QTY_PER_CNTR
                                      , MA.R_NUM_ASC
                                      , CASE
                                            WHEN FLOOR(MA.REMAIN_CNTR_QTY)  >= MA.R_NUM_ASC THEN 1
                                            WHEN CEILING(MA.REMAIN_CNTR_QTY) = MA.R_NUM_ASC THEN 2
                                            ELSE 3
                                        END AS TYPE
                                      , CASE
                                            WHEN FLOOR(MA.REMAIN_CNTR_QTY)  >= MA.R_NUM_ASC THEN (MA.MAX_COM_CNTR_QTY + 1) * MA.QTY_PER_CNTR
                                            WHEN CEILING(MA.REMAIN_CNTR_QTY) = MA.R_NUM_ASC THEN (MA.MAX_COM_CNTR_QTY * MA.QTY_PER_CNTR) + MA.MONTHLY_TOTAL_QTY - (FLOOR(MA.MON_CNTR_QTY) * MA.QTY_PER_CNTR)
                                            ELSE MA.MAX_COM_CNTR_QTY * MA.QTY_PER_CNTR
                                        END AS FINAL_QTY
                                FROM    MAIN MA
                            )
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
                SELECT    @V_PLAN_ID        AS PLAN_ID
                        , CONCAT(SUBSTRING(DEMAND_ID, 1, CHARINDEX('::', DEMAND_ID, CHARINDEX('::', DEMAND_ID)+1)+1), ATTRIBUTE3, '@', ATTRIBUTE4, '@', ATTRIBUTE5, '::', PLAN_YYYYMMDD, '::-::', ATTRIBUTE8) AS DEMAND_ID
                        , BUFFER_ID         AS BUFFER_ID
                        , NULL              AS DEMAND_GROUP
                        , PLAN_YYYYMMDD     AS DUE_DATE
                        , NULL              AS TARGET_DATE
                        , NULL              AS SALES_CUTOFF_DATE
                        , NULL              AS EXPIRY_DATE
                        , NULL              AS PRIORITY
                        , SUM(FINAL_QTY)    AS QUANTITY
                        , NULL              AS PRIORITY_GROUP
                        , NULL              AS CUSTOMER_ID
                        , NULL              AS ALLOW_SHORT
                        , ATTRIBUTE1        AS ATTRIBUTE1
                        , ATTRIBUTE2        AS ATTRIBUTE2
                        , ATTRIBUTE3        AS ATTRIBUTE3
                        , ATTRIBUTE4        AS ATTRIBUTE4
                        , ATTRIBUTE5        AS ATTRIBUTE5
                        , NULL              AS ATTRIBUTE6
                        , NULL              AS ATTRIBUTE7
                        , ATTRIBUTE8        AS ATTRIBUTE8
                        , NULL              AS ATTRIBUTE9
                        , NULL              AS ATTRIBUTE10
                        , NULL              AS ATTRIBUTE11
                        , ATTRIBUTE12       AS ATTRIBUTE12
                        , NULL              AS ATTRIBUTE13
                        , NULL              AS ATTRIBUTE14
                        , 'DEMAND_EQUALIZE' AS ATTRIBUTE15
                FROM    FINAL
                WHERE   FINAL_QTY > 0
                GROUP BY  DEMAND_ID
                        , BUFFER_ID
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE8, ATTRIBUTE12
                        , PLAN_YYYYMM
                        , PLAN_YYYYMMDD
            ;
        /* INSERT INTO SCP_OPT_ENG_DEMAND_SN(
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
        FROM @DM_TEMP */

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
	

    ------------------------------------------------------------------------
    -- Data Insert End
    ------------------------------------------------------------------------
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
