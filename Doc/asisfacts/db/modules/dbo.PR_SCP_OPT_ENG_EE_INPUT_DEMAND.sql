

CREATE   PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_INPUT_DEMAND]
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
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_INPUT_DEMAND';
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
    DECLARE @V_CNT              INT;

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

    DECLARE @V_SINGLE_PLAN_TYPE     NVARCHAR(1);
    DECLARE @V_PLAN_GROUP_ORG       NVARCHAR(20);

    -- 2026.04.24 Minyong Lee : 조립계획 대신 SHIP SEMI를 수요로 사용하는 모델 관리방식 하드코딩에서 lookup 사용으로 변경
    DECLARE @SHIP_SEMI_DEMAND TABLE(
        TO_SITE     NVARCHAR(200) NOT NULL,
        ITEM_ID     NVARCHAR(200) NOT NULL
    )
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

    -- 2026.06.22 Minyong Lee : Frozen 룩업 -> UI 적용 누락 건 반영
 --   SELECT  @V_PROD_FROZEN = CONVERT(INT, SEGMENT4)
	--FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
	--WHERE   LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN'
	--AND     VALID_YN    = 'Y'
	--AND     SEGMENT1    = @V_DIVISION_ID
	--AND     SEGMENT2    = @V_GROUP_ID
 --   AND     SEGMENT3    = @V_SCP_PLAN_TYPE

    -- PRINT ISNULL(@V_PROD_FROZEN, 0);

    --SET @V_PROD_FROZEN_DAY = CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(@V_PROD_FROZEN, 0), @V_SCP_PLAN_DATE ),112); 

    SELECT  @V_PROD_FROZEN_DAY = FROZEN_END_DATE
    FROM    SCP_OPT_ENG_FROZEN_MASTER_SN M WITH(NOLOCK)
    WHERE   M.PLAN_ID  = @V_PLAN_ID
    AND     M.STAGE = 'COATING'
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
	
    DECLARE @V_PLAN_START_YYYYMM NVARCHAR(6);
    DECLARE @V_PLAN_END_YYYYMM   NVARCHAR(6);
	
    SELECT @V_PLAN_START_YYYYMM = LEFT(PLAN_START_DATE,6)
            ,@V_PLAN_END_YYYYMM   = LEFT(PLAN_END_DATE,6)
    FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
    WHERE  PLAN_ID = @V_PLAN_ID;

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

    -- 2026.04.24 Minyong Lee : 조립계획 대신 SHIP SEMI를 수요로 사용하는 모델 관리방식 하드코딩에서 lookup 사용으로 변경
    INSERT INTO @SHIP_SEMI_DEMAND (
        TO_SITE,
        ITEM_ID
    )
    SELECT  SEGMENT2 AS TO_SITE
          , SEGMENT3 AS ITEM_ID
    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
    WHERE   LOOKUP_TYPE = 'SCP_OPT_ELEC_DEMAND_TO_SHIP_SEMI'
    AND     SEGMENT1 = @V_DIVISION_ID
    AND     SEGMENT4 = @V_GROUP_ID
    AND     VALID_YN = 'Y'

    ------------------------------------------------------------------------
    -- Data Insert Start
    ------------------------------------------------------------------------

    BEGIN

    PRINT ('0. Workbench: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));
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
    SELECT   @V_PLAN_ID
            ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE+'::'+DUE_DATE+'::'+'-'+'::'+FCST_TYPE AS DEMAND_ID
            ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE         AS BUFFER_ID
            ,INCOTERMS+'@'+'D'+CONVERT(NVARCHAR,PRIORITY)                               AS DEMAND_GROUP
            ,DUE_DATE                                                                   AS DUE_DATE
            ,NULL                                                                       AS TARGET_DATE
            ,NULL                                                                       AS SALES_CUTOFF_DATE
            ,NULL                                                                       AS EXPIRY_DATE
            ,PRIORITY                                                                   AS PRIORITY
            ,QUANTITY                                                                   AS QUANTITY
            ,'D'+CONVERT(NVARCHAR,PRIORITY)                                             AS PRIORITY_GROUP
            ,NULL                                                                       AS CUSTOMER_ID
            ,NULL                                                                       AS ALLOW_SHORT
            ,SCM_SITE_ID                                                                AS ATTRIBUTE1       
            ,ITEM_ID                                                                    AS ATTRIBUTE2
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
    FROM(
	SELECT DA.SCM_SITE_ID  AS SCM_SITE_ID
		  ,DA.ITEM_ID      AS ITEM_ID
		  ,'ELECBIZ'       AS STAGE
		  ,CASE WHEN ISNULL(MSE.VMI_YN, 'N' ) = 'Y' THEN 'DAP' ELSE DA.INCOTERMS END AS INCOTERMS
		  ,DA.DUE_DATE     AS DUE_DATE
		  ,SUM(DA.CHG_QTY) AS QUANTITY
          -- 2026.08.03 Minyong Lee : [E20260731-001733] [전극 최적화 알고리즘] 전극 모델 수요 우선순위 적용을 위한 Demand 파일 변경요청
		  ,ISNULL(TP.PRIORITY, 3) AS PRIORITY -- TARGETBIZ와 동일하게 ISNULL 처리/20251107/T.H.KIM/성재 책임님 요청
		  ,DA.FCST_TYPE    AS FCST_TYPE
		  ,DA.PROJECT_CODE AS PROJECT_CODE
    FROM    SCP_OPMZ_DMD_ADJ DA WITH(NOLOCK)
	    INNER JOIN #DEMAND_VERSION D
	        ON    DA.DIVISION_ID     = D.DIVISION_ID
	        AND   DA.CUTOFF_YYYYMMDD = D.CUTOFF_YYYYMMDD 
	        AND   DA.VERSION_NO      = D.VERSION_NO 
	    ------------------------------------------------------------------------
	    INNER JOIN (SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, A.OPERATION_GROUP, A.FLOW_ID, A.ATTRIBUTE8
	    			FROM   SCP_MST_FINAL_ITEM A WITH (NOLOCK) 

	    			INNER JOIN #DIVISION D WITH(NOLOCK)
	    			ON A.DIVISION_ID = D.DIVISION_ID

	    			WHERE  1=1 --DIVISION_ID = @V_DIVISION_ID 
	    			AND    A.OPERATION_GROUP IN ('E') 
	    		   ) B
	        ON    DA.ITEM_ID     = B.ITEM_ID
	        AND   DA.DIVISION_ID = B.DIVISION_ID 
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
	    ------------------------------------------------------------------------
	    LEFT OUTER JOIN( --TOSITE PRIORITY CONSTRAINT
	    				--SELECT  SEGMENT4   AS ITEM_ID 
	    				--	   ,SEGMENT5   AS TO_SITE
	    				--	   ,SEGMENT6   AS PRIORITY
	    				--	   ,ATTRIBUTE1 AS FROM_DATE
	    				--	   ,ATTRIBUTE2 AS TO_DATE
	    				--FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	    				--WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW'
	    				--AND     SEGMENT2    = @V_DIVISION_ID -- 전극 사업부 'EE'
         --               AND     SEGMENT3    = @V_GROUP_ID
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
                            INNER JOIN  (
                                        SELECT  DISTINCT ITEM_ID
                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE   PLAN_ID = @V_PLAN_ID
                                        ) MDL
                                ON  P.ITEM_ID = MDL.ITEM_ID
                        WHERE   1=1
                        AND     P.VALID_YN = 'Y'
                        AND     P.DIVISION_ID = @V_DIVISION_ID
                        AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
	    			   ) TP
	    ON  DA.SCM_SITE_ID = TP.TO_SITE
	    AND DA.ITEM_ID     = TP.ITEM_ID
	    AND DA.DUE_DATE BETWEEN TP.FROM_DATE AND TP.TO_DATE
	WHERE 1=1 
	AND DA.DUE_DATE >= @P_PLAN_NAME  
	AND DA.DUE_DATE <  @V_PLAN_END_YYYYMMDD
	AND CONCAT(DA.SCM_SITE_ID, DA.ITEM_ID) 
		IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
			FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
			WHERE  PLAN_ID = @V_PLAN_ID
		   ) 
	GROUP BY DA.SCM_SITE_ID, DA.ITEM_ID, DA.INCOTERMS, DA.DUE_DATE, TP.PRIORITY, DA.FCST_TYPE, DA.PROJECT_CODE, MSE.VMI_YN
    ) AD

    PRINT ('1. NET Demand: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));
    ------------------------------------------------------------------------
    -- 1.1 DM TEMP INSERT
    -- 양극일 경우 일반 로직, 음극일 경우 양극 RTF를 DEMAND로 넣는다.
    ------------------------------------------------------------------------
    -- IF NOT(@V_DIVISION_ID = 'EE' AND RIGHT(@V_PLAN_ID,2)='_A') -- 음극이 아닌 경우
    -- 2025.05.09 Philsu Park: 음극 분기 제거(ELSE 구문)에 따른 조건문 분기 주석 처리.
    --                         음극이든 양극이든 동일 Rule로 생성.
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
    FROM(
        SELECT   @V_PLAN_ID                                                                 AS PLAN_ID
                ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE+'::'+DUE_DATE+'::'+'-'+'::'+FCST_TYPE AS DEMAND_ID
                ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE         AS BUFFER_ID
                ,INCOTERMS+'@'+'D'+CONVERT(NVARCHAR,PRIORITY)                               AS DEMAND_GROUP
                ,DUE_DATE                                                                   AS DUE_DATE
                ,NULL                                                                       AS TARGET_DATE
                ,NULL                                                                       AS SALES_CUTOFF_DATE
                ,NULL                                                                       AS EXPIRY_DATE
                ,PRIORITY                                                                   AS PRIORITY
                ,QUANTITY                                                                   AS QUANTITY
                ,'D'+CONVERT(NVARCHAR,PRIORITY)                                             AS PRIORITY_GROUP
                ,NULL                                                                       AS CUSTOMER_ID
                ,NULL                                                                       AS ALLOW_SHORT
                ,SCM_SITE_ID                                                                AS ATTRIBUTE1       
                ,ITEM_ID                                                                    AS ATTRIBUTE2
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
	    		SELECT A.SCM_SITE_ID  AS SCM_SITE_ID
	    			  ,A.ITEM_ID      AS ITEM_ID
	    			  ,'ELECBIZ'                                                                    AS STAGE
	    			  ,CASE WHEN ISNULL(MSE.VMI_YN, 'N' ) = 'Y' THEN 'DAP' ELSE A.INCOTERMS END     AS INCOTERMS
	    			  ,A.ATTRIBUTE1                                                                 AS DUE_DATE
	    			  ,SUM(A.QTY)                                                                   AS QUANTITY
                      -- 2026.08.03 Minyong Lee : [E20260731-001733] [전극 최적화 알고리즘] 전극 모델 수요 우선순위 적용을 위한 Demand 파일 변경요청
	    			  ,ISNULL(TP.PRIORITY, 3)                                                       AS PRIORITY -- TARGETBIZ와 동일하게 ISNULL 처리/20251107/T.H.KIM/성재 책임님 요청
	    			  ,A.FCST_TYPE                                                                  AS FCST_TYPE
	    			  ,A.PROJECT_CODE                                                               AS PROJECT_CODE
	    		FROM DM_PLN_NET_DEMAND A WITH (NOLOCK)	
	    				------------------------------------------------------------------------
	    				INNER JOIN #DEMAND_VERSION D
	    				ON    A.DIVISION_ID     = D.DIVISION_ID
	    				AND   A.CUTOFF_YYYYMMDD = D.CUTOFF_YYYYMMDD 
	    				AND   A.VERSION_NO      = D.VERSION_NO 
	    				------------------------------------------------------------------------
	    				INNER JOIN (SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, A.OPERATION_GROUP, A.FLOW_ID, A.ATTRIBUTE8
	    							FROM   SCP_MST_FINAL_ITEM A WITH (NOLOCK) 

	    							INNER JOIN #DIVISION D WITH(NOLOCK)
	    							ON A.DIVISION_ID = D.DIVISION_ID

	    							WHERE  1=1 --DIVISION_ID = @V_DIVISION_ID 
	    							AND    A.OPERATION_GROUP IN ('E') 
	    						   ) B
	    				ON    A.ITEM_ID     = B.ITEM_ID
	    				AND   A.DIVISION_ID = B.DIVISION_ID 
	    				------------------------------------------------------------------------
	    				LEFT JOIN ( -- VMI 대상 SITE 조회
	    							SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.VMI_YN 
	    							FROM   SCM_MST_SITE A WITH (NOLOCK)

	    							INNER JOIN #DIVISION D WITH(NOLOCK)
	    							ON A.DIVISION_ID = D.DIVISION_ID

	    							WHERE  1=1 --DIVISION_ID = @V_DIVISION_ID 
	    							AND    A.SITE_TYPE   = 'SALES'
	    							AND    A.VALID_YN    = 'Y'
	    							AND    A.VMI_YN      = 'Y'
	    							) MSE
	    				ON   A.DIVISION_ID      = MSE.DIVISION_ID
	    				AND  A.SCM_SITE_ID      = MSE.SCM_SITE_ID 
	    				------------------------------------------------------------------------
	    				LEFT OUTER JOIN(--TOSITE PRIORITY CONSTRAINT
                                        --SELECT   SEGMENT4   AS ITEM_ID 
                                        --        ,SEGMENT5   AS TO_SITE
                                        --        ,SEGMENT6   AS PRIORITY
                                        --        ,ATTRIBUTE1 AS FROM_DATE
                                        --        ,ATTRIBUTE2 AS TO_DATE
                                        --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                        --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW'
                                        --AND     SEGMENT2    = @V_DIVISION_ID -- 전극 사업부 'EE'
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
                                            INNER JOIN  (
                                                        SELECT  DISTINCT ITEM_ID
                                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                        WHERE   PLAN_ID = @V_PLAN_ID
                                                        ) MDL
                                                ON  P.ITEM_ID = MDL.ITEM_ID
                                        WHERE   1=1
                                        AND     P.VALID_YN = 'Y'
                                        AND     P.DIVISION_ID = @V_DIVISION_ID
                                        AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
	    							   ) TP
	    				ON  A.SCM_SITE_ID = TP.TO_SITE
	    				AND A.ITEM_ID     = TP.ITEM_ID
	    				AND A.ATTRIBUTE1 BETWEEN TP.FROM_DATE AND TP.TO_DATE
	    				------------------------------------------------------------------------
	    		WHERE 1=1 
	    		AND A.ATTRIBUTE1        >= @P_PLAN_NAME  
	    		AND A.ATTRIBUTE1        <  @V_PLAN_END_YYYYMMDD
	    		AND A.QTY            >  0  
                /************************* 
                대상 프로젝트 ITEM 필터링 
                *************************/
	    		AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
	    			IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
	    				FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
	    				WHERE  PLAN_ID = @V_PLAN_ID
	    			   ) 
	    					--------------------------
	    		GROUP BY A.SCM_SITE_ID, A.ITEM_ID, MSE.VMI_YN, A.INCOTERMS, A.ATTRIBUTE1
	    			   , B.FLOW_ID, B.OPERATION_GROUP, TP.PRIORITY, A.FCST_TYPE,A.PROJECT_CODE
	    		) DEMAND
        ) DM
    LEFT OUTER JOIN @DM_INS_TEMP DI
        ON  DM.PLAN_ID   = DI.PLAN_ID
        AND DM.DEMAND_ID = DI.DEMAND_ID
    WHERE DI.PLAN_ID IS NULL

    PRINT ('2. Prod Plan + Ship Semi: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));
    ------------------------------------------------------------------------
    -- 1.2. Production Plan => Demand Insert : Cell ASSY 생산 계획을 노칭 기준으로 Demand 처리
	-- > 노칭에 전극 Item 으로 Demand 처리하도록 BOM 및 조립 총 수율 적용하여 변경되도록 수정 필요함
    -- 2025.09.01 Philsu Park: APCAN2049A의 수요는 Shipment Semi에서 반영(전극 실수요 기준)
	-- 2025.10.21 Philsu Park: ITEM 변환 룩업 등록된 경우, 변환되는 ITEM의 수율이 반영될 수 있게 수정.
    -- 2026.04.24 Minyong Lee : 조립계획 대신 SHIP SEMI를 수요로 사용하는 모델 관리방식 하드코딩에서 lookup 사용으로 변경
    ------------------------------------------------------------------------	

	-- START 2025.10.22 jongykim2: Workbench - Elec. Demand
	IF OBJECT_ID('TEMPDB..#DMD_ELEC') IS NOT NULL
	BEGIN 
		DROP TABLE  #DMD_ELEC;
	END;
	SELECT A.DIVISION_ID
		 , A.PLAN_START_YYYYMMDD
		 , A.PLAN_TYPE
		 , A.SEQ
		 , A.PLANT_SITE_ID AS SCM_SITE_ID
		 , A.OPERATION_ID
		 , A.LINE_ID
		 , A.ITEM_ID
		 , A.YYYYMMDD
		 , A.QTY
		 , A.CHG_QTY
	INTO   #DMD_ELEC
	FROM   SCP_OPMZ_DMD_ELEC A WITH(NOLOCK)
	INNER JOIN 	@T_SCP_PLAN XX -- SCP 최신 Plan
	ON  A.DIVISION_ID         = XX.DIVISION_ID
	AND A.PLAN_START_YYYYMMDD = XX.PLAN_START_YYYYMMDD
	AND A.PLAN_TYPE           = XX.PLAN_TYPE
	AND A.SEQ                 = XX.PLAN_SEQ
	;
	-- END 2025.10.22 jongykim2: Workbench - Elec. Demand

	-- START 2025.10.23 jongykim2: Capa - Yield(Elec)
	IF OBJECT_ID('TEMPDB..#MST_YIELD_T') IS NOT NULL
	BEGIN 
		DROP TABLE  #MST_YIELD_T;
	END;
	WITH DIVISION_T AS (
		SELECT 'EE' ELEC_DIVISION_ID
			 , T.DIVISION_ID
		FROM   #DIVISION T WITH(NOLOCK)
	)
	SELECT YE.DIVISION_ID
		 , MS.SCM_SITE_ID
		 , YE.ITEM_ID
		 , YE.YYYYMM
		 , CASE WHEN MS.OPERATION_GROUP = 'A' THEN YE.ASSY
				WHEN MS.OPERATION_GROUP = 'E' THEN YE.ELEC_POST
		   END AS YIELD
		 , YE.VALID_YN
	INTO   #MST_YIELD_T
	FROM   SCP_OPMZ_YLD_ELEC YE WITH(NOLOCK)
	INNER JOIN DIVISION_T D
	ON     D.ELEC_DIVISION_ID = YE.DIVISION_ID
	INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
	ON      MS.DIVISION_ID = D.DIVISION_ID
	AND     MS.PLANT_ID = YE.PLANT_ID
	WHERE 	MS.SITE_TYPE 		= 'PLANT'
	AND 	MS.OPERATION_GROUP  IN ('A', 'E')
	AND 	MS.VALID_YN 		= 'Y'
	AND     YE.DIVISION_ID      = @V_DIVISION_ID
	;
	-- END 2025.10.23 jongykim2: Capa - Yield(Elec)

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
            ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE+'::'+DUE_DATE+'::'+'-'+'::'+FCST_TYPE AS DEMAND_ID
            ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'@'+INCOTERMS+'@'+PROJECT_CODE         AS BUFFER_ID
            ,INCOTERMS+'@'+'D'+CONVERT(NVARCHAR,PRIORITY)                               AS DEMAND_GROUP
            ,DUE_DATE                                                                   AS DUE_DATE
            ,NULL                                                                       AS TARGET_DATE
            ,NULL                                                                       AS SALES_CUTOFF_DATE
            ,NULL                                                                       AS EXPIRY_DATE
            ,PRIORITY                                                                   AS PRIORITY
            ,QUANTITY                                                                   AS QUANTITY
            ,'D'+CONVERT(NVARCHAR,PRIORITY)                                             AS PRIORITY_GROUP
            ,NULL                                                                       AS CUSTOMER_ID
            ,NULL                                                                       AS ALLOW_SHORT
            ,SCM_SITE_ID                                                                AS ATTRIBUTE1       
            ,ITEM_ID                                                                    AS ATTRIBUTE2
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
            ,PLAN_VERSION                                                               AS ATTRIBUTE14
            ,NULL                                                                       AS ATTRIBUTE15
    FROM   (
			
			-- START 2025.10.22 jongykim2: Workbench - Elec. Demand ---------------------------------------------------------
			-- 요청사항:
			-- 전극 Demand 집계 시 Workbench 등록된 대상은 Workbench 값을 기준으로 반영, 그 외에는 기존 Logic대로 반영 요청.
			-- Input Data에는 0값은 반영하면 안되므로 Workbench 에 0으로 반영한 경우, 원래 계획을 제외하는 처리만 해준다.
			-----------------------------------------------------------------------------------------------------------------
			SELECT A.SCM_SITE_ID        AS SCM_SITE_ID
				  ,B.CHILD_ITEM_ID      AS ITEM_ID
				  ,'TARGETBIZ'     AS STAGE
				  ,'DAP'                AS INCOTERMS  -- Cell Plant 노칭에 처리하므로 DAP 로 처리
				  ,A.YYYYMMDD           AS DUE_DATE
				  --,CASE WHEN ISNULL(TT.YIELD, 0) = 0 THEN SUM( (A.QTY * ISNULL(B.ACCUMULATED_CHILD_QTY, 1)) )  
				  --      ELSE SUM( (A.QTY * ISNULL(B.ACCUMULATED_CHILD_QTY, 1)) / TT.YIELD )  
				  -- END AS QUANTITY
                  ,CASE WHEN ISNULL(TT.YIELD, 0) = 0 THEN SUM( (A.CHG_QTY * ISNULL(B.USAGE, 1)) )
				        ELSE SUM( (A.CHG_QTY * ISNULL(B.USAGE, 1)) / TT.YIELD )
				   END AS QUANTITY
                   -- 2026.08.03 Minyong Lee : [E20260731-001733] [전극 최적화 알고리즘] 전극 모델 수요 우선순위 적용을 위한 Demand 파일 변경요청
				  ,ISNULL(TP.PRIORITY, 3) AS PRIORITY
				  --,A.LINE_ID            AS FCST_TYPE
				  ,'-'                  AS FCST_TYPE
				  ,'-'                  AS PROJECT_CODE
                  ,'PROD_PLAN'          AS PLAN_VERSION
			FROM #DMD_ELEC A WITH(NOLOCK)
            INNER JOIN 	@T_SCP_PLAN XX -- Workbench - Elec. Demand
				ON  A.DIVISION_ID         = XX.DIVISION_ID
				AND A.PLAN_START_YYYYMMDD = XX.PLAN_START_YYYYMMDD
				AND A.PLAN_TYPE           = XX.PLAN_TYPE
				AND A.SEQ                 = XX.PLAN_SEQ
            INNER JOIN SCM_MST_SITE FS WITH (NOLOCK) 
                ON  A.DIVISION_ID      = FS.DIVISION_ID
                AND A.SCM_SITE_ID      = FS.SCM_SITE_ID
                AND FS.SITE_TYPE       = 'PLANT'
                AND FS.OPERATION_GROUP = 'A'
                AND FS.VALID_YN        = 'Y'
            INNER JOIN SCM_MST_ITEM_SN ITM WITH(NOLOCK)
                ON  ITM.COMPANY_ID  = FS.COMPANY_ID
                AND ITM.DIVISION_ID = FS.DIVISION_ID
                AND ITM.SITE_ID     = FS.SITE_ID
                AND ITM.ITEM_ID     = A.ITEM_ID
				---- Cell -> Elec BOM
    --            INNER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH (NOLOCK) 
    --            ON  A.DIVISION_ID        = B.DIVISION_ID
    --            AND FS.PLANT_ID          = B.PLANT_ID
    --            AND A.ITEM_ID            = B.MODEL_ID -- ASSY Item
    --            AND B.OPERATION_GROUP_ID = 'E'        -- Child Item : 전극
            /*INNER JOIN SCP_MST_BOM_ELEC B WITH(NOLOCK)
                ON  A.DIVISION_ID = B.DIVISION_ID
                AND A.ITEM_ID     = B.PARENT_ITEM_ID -- ASSY Item
                AND B.SCP_YN      = 'Y'*/ -- blocked 2025-12-19
            -- added 2025-12-19
            INNER JOIN SCP_OPT_ENG_BOM_ELEC_SN B WITH(NOLOCK)
                ON  B.PLAN_ID     = @V_PLAN_ID
                AND A.DIVISION_ID = B.DIVISION_ID
                AND A.ITEM_ID     = B.PARENT_ITEM_ID
                AND B.SCP_YN      = 'Y'
				 -- LOOKUP 등록 조립 총 수율 사용
				LEFT OUTER JOIN(
						/*전극 */ 
						-- START 2025.10.23 jongykim2: Capa - Yield(Elec)
						-- -----------------------------------------------------
						-- 요청사항: 전극 수율 관리 룩업을 UI Table로 교체
						-- Lookup Table: SCP_OPMZ_LOOKUP_MASTER_DETAIL
						-- Lookup Type: SCP_OPT_MASTER_YIELD
						-- Table: SCP_OPMZ_YLD_ELEC
						-- ------------------------------------------------------
						SELECT	  LU.SCM_SITE_ID
								, NULL        AS LINE_ID
								-- , LU.SEGMENT4 AS ITEM_ID
								,LK.SEGMENT3 AS ITEM_ID
								, LU.YYYYMM AS MONTH
								, 0 AS LT
								, MAX(CONVERT(FLOAT, LU.YIELD)) AS YIELD -- 조립 총수율
						FROM	#MST_YIELD_T LU WITH(NOLOCK)
						INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
							ON 	LK.LOOKUP_TYPE = 'SCP_OPT_ELEC_ITEM_TRANSFER'
							AND LK.SEGMENT2     = @V_GROUP_ID
							AND LK.VALID_YN     = 'Y'
							AND LK.SEGMENT4 	= LU.ITEM_ID
						WHERE  	1 = 1
						AND     LU.VALID_YN     = 'Y'
						AND     TRY_CAST(LU.YIELD AS FLOAT) > 0
						AND    	LU.DIVISION_ID    = @V_DIVISION_ID
						AND    	LU.YYYYMM BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
						GROUP BY LU.SCM_SITE_ID, LK.SEGMENT3, LU.YYYYMM
						UNION ALL
						SELECT	  LU.SCM_SITE_ID
								, NULL        AS LINE_ID
								, LU.ITEM_ID
								-- ,LU..SEGMENT3 AS ITEM_ID
								, LU.YYYYMM AS MONTH
								, 0 AS LT
								, MAX(CONVERT(FLOAT, LU.YIELD)) AS YIELD -- 조립 총수율
						FROM	#MST_YIELD_T LU WITH(NOLOCK)
						WHERE  	1 = 1
						AND    	LU.VALID_YN    = 'Y'
						AND     TRY_CAST(LU.YIELD AS FLOAT) > 0
						AND    	LU.DIVISION_ID    = @V_DIVISION_ID
						AND    	LU.YYYYMM BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
						AND 	NOT EXISTS (
											SELECT 	1
											FROM  	SCP_OPMZ_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
											WHERE 	L.LOOKUP_TYPE = 'SCP_OPT_ELEC_ITEM_TRANSFER'
											AND 	L.SEGMENT2     = @V_GROUP_ID
											AND 	L.VALID_YN     = 'Y'
											AND 	L.SEGMENT3 	= LU.ITEM_ID
											)
						GROUP BY LU.SCM_SITE_ID, LU.ITEM_ID, LU.YYYYMM
						-- END 2025.10.23 jongykim2: Capa - Yield(Elec)
						/* -- BLOCKED 2025.10.23 jongykim2: Capa - Yield(Elec)
						SELECT	  LU.SEGMENT2 AS SCM_SITE_ID
								, NULL        AS LINE_ID
								-- , LU.SEGMENT4 AS ITEM_ID
								,LK.SEGMENT3 AS ITEM_ID
								, LU.SEGMENT5 AS MONTH
								, 0 AS LT
								, MAX(CONVERT(FLOAT, LU.ATTRIBUTE1)) AS YIELD -- 조립 총수율
						FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
						INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
							ON 	LK.LOOKUP_TYPE = 'SCP_OPT_ELEC_ITEM_TRANSFER'
							AND LK.SEGMENT2     = @V_GROUP_ID
							AND LK.VALID_YN     = 'Y'
							AND LK.SEGMENT4 	= LU.SEGMENT4
						WHERE  	LU.LOOKUP_TYPE = 'SCP_OPT_MASTER_YIELD'
						AND    	LU.VALID_YN    = 'Y'
						AND    	LU.SEGMENT1    = @V_DIVISION_ID
						AND    	LU.SEGMENT5 BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
						GROUP BY LU.SEGMENT2, LK.SEGMENT3, LU.SEGMENT5
						UNION ALL
						SELECT	  LU.SEGMENT2 AS SCM_SITE_ID
								, NULL        AS LINE_ID
								, LU.SEGMENT4 AS ITEM_ID
								-- ,LU..SEGMENT3 AS ITEM_ID
								, LU.SEGMENT5 AS MONTH
								, 0 AS LT
								, MAX(CONVERT(FLOAT, LU.ATTRIBUTE1)) AS YIELD -- 조립 총수율
						FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
						WHERE  	LU.LOOKUP_TYPE = 'SCP_OPT_MASTER_YIELD'
						AND    	LU.VALID_YN    = 'Y'
						AND    	LU.SEGMENT1    = @V_DIVISION_ID
						AND    	LU.SEGMENT5 BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
						AND 	NOT EXISTS (
											SELECT 	1
											FROM  	SCP_OPMZ_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
											WHERE 	L.LOOKUP_TYPE = 'SCP_OPT_ELEC_ITEM_TRANSFER'
											AND 	L.SEGMENT2     = @V_GROUP_ID
											AND 	L.VALID_YN     = 'Y'
											AND 	L.SEGMENT3 	= LU.SEGMENT4
											)
						GROUP BY LU.SEGMENT2, LU.SEGMENT4, LU.SEGMENT5 */
						/* SELECT LU.SEGMENT2 AS SCM_SITE_ID
							 , NULL        AS LINE_ID
							 , LU.SEGMENT4 AS ITEM_ID
							 , LU.SEGMENT5 AS MONTH
							 , 0 AS LT
							 , MAX(CONVERT(FLOAT, ATTRIBUTE1)) AS YIELD -- 조립 총수율
						 
						FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
						WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_MASTER_YIELD'
						AND    LU.VALID_YN    = 'Y'
						AND    LU.SEGMENT1    = @V_DIVISION_ID
						AND    LU.SEGMENT5 BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
						GROUP BY LU.SEGMENT2, LU.SEGMENT4, LU.SEGMENT5 */
					) TT
				ON  A.SCM_SITE_ID   = TT.SCM_SITE_ID
				AND B.CHILD_ITEM_ID = TT.ITEM_ID -- LOOKUP 에 전극 ITem 기준으로 등록됨
				AND A.YYYYMMDD      LIKE TT.MONTH+'%'
            LEFT OUTER JOIN( --TOSITE PRIORITY CONSTRAINT
                            --SELECT   SEGMENT4   AS ITEM_ID 
                            --        ,SEGMENT5   AS TO_SITE
                            --        ,SEGMENT6   AS PRIORITY
                            --        ,ATTRIBUTE1 AS FROM_DATE
                            --        ,ATTRIBUTE2 AS TO_DATE
                            --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                            --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW'
                            --AND     SEGMENT2    = @V_DIVISION_ID -- 전극 사업부 'EE'
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
                                INNER JOIN  (
                                            SELECT  DISTINCT ITEM_ID
                                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                            WHERE   PLAN_ID = @V_PLAN_ID
                                            ) MDL
                                    ON  P.ITEM_ID = MDL.ITEM_ID
                            WHERE   1=1
                            AND     P.VALID_YN = 'Y'
                            AND     P.DIVISION_ID = @V_DIVISION_ID
                            AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                            ) TP
                ON  A.SCM_SITE_ID   = TP.TO_SITE
                AND B.CHILD_ITEM_ID = TP.ITEM_ID
                AND A.YYYYMMDD BETWEEN TP.FROM_DATE AND TP.TO_DATE

				-- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
				-- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
				LEFT JOIN (
       --                     SELECT  SEGMENT2   AS DIVISION_ID
							--	 , SEGMENT3   AS SCM_SITE_ID
							--	 , SEGMENT4   AS ITEM_ID
							--	 , SEGMENT5   AS GROUP_ID
							--	 , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
							--	        ELSE ATTRIBUTE2
							--	   END AS START_DATE  -- PLAN 제외 시작일자
       --                          , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
							--	        ELSE ATTRIBUTE3
							--	   END AS END_DATE  -- PLAN 제외 끝일자
							--FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
							--WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
							--AND    VALID_YN    = 'Y'
							--AND    SEGMENT2    = @V_DIVISION_ID
							--AND    SEGMENT5    = @V_GROUP_ID
							--AND    ATTRIBUTE1  = 'ASSY' -- CELL PLAN 제외

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
                                INNER JOIN  (
                                            SELECT  DISTINCT ITEM_ID
                                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                            WHERE   PLAN_ID = @V_PLAN_ID
                                            ) MDL
                                    ON  D.ITEM_ID = MDL.ITEM_ID
                            WHERE   1=1
                            AND     D.VALID_YN = 'Y'
                            AND     D.DIVISION_ID = @V_DIVISION_ID
                            AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                            --AND     D.STAGE = 'TARGETBIZ'
						  ) DE
				ON  A.SCM_SITE_ID = DE.SCM_SITE_ID
				AND A.ITEM_ID     = DE.ITEM_ID
			WHERE 1=1
			AND   A.YYYYMMDD           >= @P_PLAN_NAME  -- 당주 Plan name
			AND   A.YYYYMMDD           <  @V_PLAN_END_YYYYMMDD        
			AND   A.CHG_QTY            >  0
			AND   A.OPERATION_ID       IN ('A3000','A9000')
			
			-- DEMAND 제외 대상 처리
			-- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
			AND  (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
			  OR (ISNULL(DE.ITEM_ID, '') <> '' AND (A.YYYYMMDD < DE.START_DATE OR A.YYYYMMDD > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
			     )
			-- 2025.09.01 Philsu Park: DEMAND 제외 대상 처리2 - APCAN2049A는 Shipment Semi에서 가져오는 것으로 처리.
            -- 2025.09.17 Philsu Park: Shipment Semi 케이스 추가.(백선우 책임님 요청 - 오창꺼만 빼주세요.)
            -- 2026.04.24 Minyong Lee : 조립계획 대신 SHIP SEMI를 수요로 사용하는 모델 관리방식 하드코딩에서 lookup 사용으로 변경
            --AND   B.CHILD_ITEM_ID NOT IN ('APCAN2049A')
            --and   CONCAT(A.SCM_SITE_ID, B.CHILD_ITEM_ID) NOT IN (   SELECT 'HQ08-AAPCCA2504A'
            --                                                        UNION ALL
            --                                                        SELECT 'HQ08-AAPCAN2394A' 
            --                                                        )
            AND  A.SCM_SITE_ID + '||' + B.CHILD_ITEM_ID NOT IN (
                                                                SELECT TO_SITE + '||' + ITEM_ID
                                                                FROM @SHIP_SEMI_DEMAND
                                                                )
            /************************* 
            대상 프로젝트 ITEM 필터링 
            *************************/
			AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
				IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
					FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
					WHERE  PLAN_ID = @V_PLAN_ID
				   )
			--GROUP BY A.SCM_SITE_ID, B.CHILD_ITEM_ID, A.LINE_ID, A.YYYYMMDD, ISNULL(TT.YIELD, 0)
            -- 2026.08.03 Minyong Lee : [E20260731-001733] [전극 최적화 알고리즘] 전극 모델 수요 우선순위 적용을 위한 Demand 파일 변경요청
			GROUP BY A.SCM_SITE_ID, B.CHILD_ITEM_ID, A.YYYYMMDD, ISNULL(TT.YIELD, 0), ISNULL(TP.PRIORITY, 3)
			-- END 2025.10.22 jongykim2: Workbench - Elec. Demand
			UNION ALL
			SELECT A.SCM_SITE_ID        AS SCM_SITE_ID
				  ,B.CHILD_ITEM_ID      AS ITEM_ID
				  ,'TARGETBIZ'     AS STAGE
				  ,'DAP'                AS INCOTERMS  -- Cell Plant 노칭에 처리하므로 DAP 로 처리
				  ,A.YYYYMMDD           AS DUE_DATE
				  --,CASE WHEN ISNULL(TT.YIELD, 0) = 0 THEN SUM( (A.QTY * ISNULL(B.ACCUMULATED_CHILD_QTY, 1)) )  
				  --      ELSE SUM( (A.QTY * ISNULL(B.ACCUMULATED_CHILD_QTY, 1)) / TT.YIELD )  
				  -- END AS QUANTITY
                  ,CASE WHEN ISNULL(TT.YIELD, 0) = 0 THEN SUM( (A.QTY * ISNULL(B.USAGE, 1)) )
				        ELSE SUM( (A.QTY * ISNULL(B.USAGE, 1)) / TT.YIELD )
				   END AS QUANTITY
                   -- 2026.08.03 Minyong Lee : [E20260731-001733] [전극 최적화 알고리즘] 전극 모델 수요 우선순위 적용을 위한 Demand 파일 변경요청
				  ,ISNULL(TP.PRIORITY, 3) AS PRIORITY
				  --,A.LINE_ID            AS FCST_TYPE
				  ,'-'                  AS FCST_TYPE
				  ,'-'                  AS PROJECT_CODE
                  ,'PROD_PLAN'          AS PLAN_VERSION
			FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
            INNER JOIN 	@T_SCP_PLAN XX -- SCP 최신 Plan
				ON  A.DIVISION_ID         = XX.DIVISION_ID
				AND A.PLAN_START_YYYYMMDD = XX.PLAN_START_YYYYMMDD
				AND A.PLAN_TYPE           = XX.PLAN_TYPE
				AND A.SEQ                 = XX.PLAN_SEQ
            INNER JOIN SCM_MST_SITE FS WITH (NOLOCK) 
                ON  A.DIVISION_ID      = FS.DIVISION_ID
                AND A.SCM_SITE_ID      = FS.SCM_SITE_ID
                AND FS.SITE_TYPE       = 'PLANT'
                AND FS.OPERATION_GROUP = 'A'
                AND FS.VALID_YN        = 'Y'
            INNER JOIN SCM_MST_ITEM_SN ITM WITH(NOLOCK)
                ON  ITM.COMPANY_ID  = FS.COMPANY_ID
                AND ITM.DIVISION_ID = FS.DIVISION_ID
                AND ITM.SITE_ID     = FS.SITE_ID
                AND ITM.ITEM_ID     = A.ITEM_ID
				---- Cell -> Elec BOM
    --            INNER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH (NOLOCK) 
    --            ON  A.DIVISION_ID        = B.DIVISION_ID
    --            AND FS.PLANT_ID          = B.PLANT_ID
    --            AND A.ITEM_ID            = B.MODEL_ID -- ASSY Item
    --            AND B.OPERATION_GROUP_ID = 'E'        -- Child Item : 전극
            /*INNER JOIN SCP_MST_BOM_ELEC B WITH(NOLOCK)
                ON  A.DIVISION_ID = B.DIVISION_ID
                AND A.ITEM_ID     = B.PARENT_ITEM_ID -- ASSY Item
                AND B.SCP_YN      = 'Y'*/ -- blocked 2025-12-19
            -- added 2025-12-19
            INNER JOIN SCP_OPT_ENG_BOM_ELEC_SN B WITH(NOLOCK)
                ON  B.PLAN_ID     = @V_PLAN_ID
                AND A.DIVISION_ID = B.DIVISION_ID
                AND A.ITEM_ID     = B.PARENT_ITEM_ID
                AND B.SCP_YN      = 'Y'
				 -- LOOKUP 등록 조립 총 수율 사용
				LEFT OUTER JOIN(
						/*전극 */ 
						-- START 2025.10.23 jongykim2: Capa - Yield(Elec)
						-- -----------------------------------------------------
						-- 요청사항: 전극 수율 관리 룩업을 UI Table로 교체
						-- Lookup Table: SCP_OPMZ_LOOKUP_MASTER_DETAIL
						-- Lookup Type: SCP_OPT_MASTER_YIELD
						-- Table: SCP_OPMZ_YLD_ELEC
						-- ------------------------------------------------------
						SELECT	  LU.SCM_SITE_ID
								, NULL        AS LINE_ID
								-- , LU.SEGMENT4 AS ITEM_ID
								,LK.SEGMENT3 AS ITEM_ID
								, LU.YYYYMM AS MONTH
								, 0 AS LT
								, MAX(CONVERT(FLOAT, LU.YIELD)) AS YIELD -- 조립 총수율
						FROM	#MST_YIELD_T LU WITH(NOLOCK)
						INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
							ON 	LK.LOOKUP_TYPE = 'SCP_OPT_ELEC_ITEM_TRANSFER'
							AND LK.SEGMENT2     = @V_GROUP_ID
							AND LK.VALID_YN     = 'Y'
							AND LK.SEGMENT4 	= LU.ITEM_ID
						WHERE  	1 = 1
						AND     LU.VALID_YN     = 'Y'
						AND     TRY_CAST(LU.YIELD AS FLOAT) > 0
						AND    	LU.DIVISION_ID    = @V_DIVISION_ID
						AND    	LU.YYYYMM BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
						GROUP BY LU.SCM_SITE_ID, LK.SEGMENT3, LU.YYYYMM
						UNION ALL
						SELECT	  LU.SCM_SITE_ID
								, NULL        AS LINE_ID
								, LU.ITEM_ID
								-- ,LU..SEGMENT3 AS ITEM_ID
								, LU.YYYYMM AS MONTH
								, 0 AS LT
								, MAX(CONVERT(FLOAT, LU.YIELD)) AS YIELD -- 조립 총수율
						FROM	#MST_YIELD_T LU WITH(NOLOCK)
						WHERE  	1 = 1
						AND    	LU.VALID_YN    = 'Y'
						AND     TRY_CAST(LU.YIELD AS FLOAT) > 0
						AND    	LU.DIVISION_ID    = @V_DIVISION_ID
						AND    	LU.YYYYMM BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
						AND 	NOT EXISTS (
											SELECT 	1
											FROM  	SCP_OPMZ_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
											WHERE 	L.LOOKUP_TYPE = 'SCP_OPT_ELEC_ITEM_TRANSFER'
											AND 	L.SEGMENT2     = @V_GROUP_ID
											AND 	L.VALID_YN     = 'Y'
											AND 	L.SEGMENT3 	= LU.ITEM_ID
											)
						GROUP BY LU.SCM_SITE_ID, LU.ITEM_ID, LU.YYYYMM
						-- END 2025.10.23 jongykim2: Capa - Yield(Elec)
						/* -- BLOCKED 2025.10.23 jongykim2: Capa - Yield(Elec)
						SELECT	  LU.SEGMENT2 AS SCM_SITE_ID
								, NULL        AS LINE_ID
								-- , LU.SEGMENT4 AS ITEM_ID
								,LK.SEGMENT3 AS ITEM_ID
								, LU.SEGMENT5 AS MONTH
								, 0 AS LT
								, MAX(CONVERT(FLOAT, LU.ATTRIBUTE1)) AS YIELD -- 조립 총수율
						FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
						INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
							ON 	LK.LOOKUP_TYPE = 'SCP_OPT_ELEC_ITEM_TRANSFER'
							AND LK.SEGMENT2     = @V_GROUP_ID
							AND LK.VALID_YN     = 'Y'
							AND LK.SEGMENT4 	= LU.SEGMENT4
						WHERE  	LU.LOOKUP_TYPE = 'SCP_OPT_MASTER_YIELD'
						AND    	LU.VALID_YN    = 'Y'
						AND    	LU.SEGMENT1    = @V_DIVISION_ID
						AND    	LU.SEGMENT5 BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
						GROUP BY LU.SEGMENT2, LK.SEGMENT3, LU.SEGMENT5
						UNION ALL
						SELECT	  LU.SEGMENT2 AS SCM_SITE_ID
								, NULL        AS LINE_ID
								, LU.SEGMENT4 AS ITEM_ID
								-- ,LU..SEGMENT3 AS ITEM_ID
								, LU.SEGMENT5 AS MONTH
								, 0 AS LT
								, MAX(CONVERT(FLOAT, LU.ATTRIBUTE1)) AS YIELD -- 조립 총수율
						FROM	SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
						WHERE  	LU.LOOKUP_TYPE = 'SCP_OPT_MASTER_YIELD'
						AND    	LU.VALID_YN    = 'Y'
						AND    	LU.SEGMENT1    = @V_DIVISION_ID
						AND    	LU.SEGMENT5 BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
						AND 	NOT EXISTS (
											SELECT 	1
											FROM  	SCP_OPMZ_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
											WHERE 	L.LOOKUP_TYPE = 'SCP_OPT_ELEC_ITEM_TRANSFER'
											AND 	L.SEGMENT2     = @V_GROUP_ID
											AND 	L.VALID_YN     = 'Y'
											AND 	L.SEGMENT3 	= LU.SEGMENT4
											)
						GROUP BY LU.SEGMENT2, LU.SEGMENT4, LU.SEGMENT5 */
						/* SELECT LU.SEGMENT2 AS SCM_SITE_ID
							 , NULL        AS LINE_ID
							 , LU.SEGMENT4 AS ITEM_ID
							 , LU.SEGMENT5 AS MONTH
							 , 0 AS LT
							 , MAX(CONVERT(FLOAT, ATTRIBUTE1)) AS YIELD -- 조립 총수율
						 
						FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
						WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_MASTER_YIELD'
						AND    LU.VALID_YN    = 'Y'
						AND    LU.SEGMENT1    = @V_DIVISION_ID
						AND    LU.SEGMENT5 BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
						GROUP BY LU.SEGMENT2, LU.SEGMENT4, LU.SEGMENT5 */
					) TT
				ON  A.SCM_SITE_ID   = TT.SCM_SITE_ID
				AND B.CHILD_ITEM_ID = TT.ITEM_ID -- LOOKUP 에 전극 ITem 기준으로 등록됨
				AND A.YYYYMMDD      LIKE TT.MONTH+'%'
            LEFT OUTER JOIN( --TOSITE PRIORITY CONSTRAINT
                            --SELECT   SEGMENT4   AS ITEM_ID 
                            --        ,SEGMENT5   AS TO_SITE
                            --        ,SEGMENT6   AS PRIORITY
                            --        ,ATTRIBUTE1 AS FROM_DATE
                            --        ,ATTRIBUTE2 AS TO_DATE
                            --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                            --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW'
                            --AND     SEGMENT2    = @V_DIVISION_ID -- 전극 사업부 'EE'
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
                                INNER JOIN  (
                                            SELECT  DISTINCT ITEM_ID
                                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                            WHERE   PLAN_ID = @V_PLAN_ID
                                            ) MDL
                                    ON  P.ITEM_ID = MDL.ITEM_ID
                            WHERE   1=1
                            AND     P.VALID_YN = 'Y'
                            AND     P.DIVISION_ID = @V_DIVISION_ID
                            AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                            ) TP
                ON  A.SCM_SITE_ID   = TP.TO_SITE
                AND B.CHILD_ITEM_ID = TP.ITEM_ID
                AND A.YYYYMMDD BETWEEN TP.FROM_DATE AND TP.TO_DATE

				-- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
				-- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
				LEFT JOIN (
       --                     SELECT  SEGMENT2   AS DIVISION_ID
							--	 , SEGMENT3   AS SCM_SITE_ID
							--	 , SEGMENT4   AS ITEM_ID
							--	 , SEGMENT5   AS GROUP_ID
							--	 , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
							--	        ELSE ATTRIBUTE2
							--	   END AS START_DATE  -- PLAN 제외 시작일자
       --                          , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
							--	        ELSE ATTRIBUTE3
							--	   END AS END_DATE  -- PLAN 제외 끝일자
							--FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
							--WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
							--AND    VALID_YN    = 'Y'
							--AND    SEGMENT2    = @V_DIVISION_ID
							--AND    SEGMENT5    = @V_GROUP_ID
							--AND    ATTRIBUTE1  = 'ASSY' -- CELL PLAN 제외

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
                                INNER JOIN  (
                                            SELECT  DISTINCT ITEM_ID
                                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                            WHERE   PLAN_ID = @V_PLAN_ID
                                            ) MDL
                                    ON  D.ITEM_ID = MDL.ITEM_ID
                            WHERE   1=1
                            AND     D.VALID_YN = 'Y'
                            AND     D.DIVISION_ID = @V_DIVISION_ID
                            AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                            --AND     D.STAGE = 'TARGETBIZ'
						  ) DE
				ON  A.SCM_SITE_ID = DE.SCM_SITE_ID
				AND A.ITEM_ID     = DE.ITEM_ID
			WHERE 1=1
			AND   A.MEASURE             = 'PROD_PLAN_AMEND'
			AND   A.YYYYMMDD           >= @P_PLAN_NAME  -- 당주 Plan name
			AND   A.YYYYMMDD           <  @V_PLAN_END_YYYYMMDD        
			AND   A.QTY                >  0
			AND   A.OPERATION_ID       IN ('A3000','A9000')
			
			-- DEMAND 제외 대상 처리
			-- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
			AND  (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
			  OR (ISNULL(DE.ITEM_ID, '') <> '' AND (A.YYYYMMDD < DE.START_DATE OR A.YYYYMMDD > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
			     )
			-- 2025.09.01 Philsu Park: DEMAND 제외 대상 처리2 - APCAN2049A는 Shipment Semi에서 가져오는 것으로 처리.
            -- 2025.09.17 Philsu Park: Shipment Semi 케이스 추가.(백선우 책임님 요청 - 오창꺼만 빼주세요.)
            -- 2026.04.24 Minyong Lee : 조립계획 대신 SHIP SEMI를 수요로 사용하는 모델 관리방식 하드코딩에서 lookup 사용으로 변경
            --AND   B.CHILD_ITEM_ID NOT IN ('APCAN2049A')
            --and   CONCAT(A.SCM_SITE_ID, B.CHILD_ITEM_ID) NOT IN (   SELECT 'HQ08-AAPCCA2504A'
            --                                                        UNION ALL
            --                                                        SELECT 'HQ08-AAPCAN2394A' 
            --                                                        )
            AND  A.SCM_SITE_ID + '||' + B.CHILD_ITEM_ID NOT IN (
                                                                SELECT TO_SITE + '||' + ITEM_ID
                                                                FROM @SHIP_SEMI_DEMAND
                                                                )
            /************************* 
            대상 프로젝트 ITEM 필터링 
            *************************/
			AND CONCAT(A.SCM_SITE_ID, A.ITEM_ID) 
				IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
					FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
					WHERE  PLAN_ID = @V_PLAN_ID
				   )
			-- 2025.10.22 jongykim2: START
			AND NOT EXISTS (
				SELECT 'X'
				FROM   #DMD_ELEC T WITH(NOLOCK)
				WHERE  1 = 1
				AND    T.DIVISION_ID = A.DIVISION_ID
				AND    T.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
				AND    T.PLAN_TYPE = A.PLAN_TYPE
				AND    T.SEQ = A.SEQ
				AND    T.SCM_SITE_ID = A.SCM_SITE_ID
				AND    T.ITEM_ID = A.ITEM_ID
				AND    T.LINE_ID = A.LINE_ID
				AND    T.OPERATION_ID = A.OPERATION_ID
				AND    T.YYYYMMDD = A.YYYYMMDD
			)
			-- 2025.10.22 jongykim2: END
			--GROUP BY A.SCM_SITE_ID, B.CHILD_ITEM_ID, A.LINE_ID, A.YYYYMMDD, ISNULL(TT.YIELD, 0)
            -- 2026.08.03 Minyong Lee : [E20260731-001733] [전극 최적화 알고리즘] 전극 모델 수요 우선순위 적용을 위한 Demand 파일 변경요청
			GROUP BY A.SCM_SITE_ID, B.CHILD_ITEM_ID, A.YYYYMMDD, ISNULL(TT.YIELD, 0), ISNULL(TP.PRIORITY, 3)
            UNION ALL
            ----------------------------------------------------------------------------
            -- 2025.09.01 Philsu Park
            -- APCAN2049A는 Shipment Semi에서 가져오는 것으로 처리.
            -- 2025.09.17 Philsu Park: 'APCCA2504A', 'APCAN2394A' 추가(특이 BIZ), Priority 적용
            -- 2026.04.24 Minyong Lee : 조립계획 대신 SHIP SEMI를 수요로 사용하는 모델 관리방식 하드코딩에서 lookup 사용으로 변경
            ----------------------------------------------------------------------------
            SELECT   A.TO_SITE              AS SCM_SITE_ID
                    ,A.ITEM_ID              AS ITEM_ID
                    ,'TARGETBIZ'            AS STAGE
                    ,'DAP'                  AS INCOTERMS  -- Cell Plant 노칭에 처리하므로 DAP 로 처리
                    ,A.YYYYMMDD             AS DUE_DATE
                    ,SUM(A.QTY)             AS QUANTITY
                    -- 2026.08.03 Minyong Lee : [E20260731-001733] [전극 최적화 알고리즘] 전극 모델 수요 우선순위 적용을 위한 Demand 파일 변경요청
                    ,ISNULL(TP.PRIORITY, 3) AS PRIORITY
                    ,'-'                    AS FCST_TYPE
                    ,'-'                    AS PROJECT_CODE
                    ,'SHIP_SEMI'            AS PLAN_VERSION
            FROM   SCP_ANL_SHIPMENT_PLAN_SEMI A WITH(NOLOCK)
            INNER JOIN (
                        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.PLAN_SEQ 
                        FROM  (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
                                    , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_TYPE_ORDER DESC ) AS PLAN_RANK
                                FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
                                WHERE  1=1
                                AND    DIVISION_ID = @V_DIVISION_ID
                                ) A   
                        WHERE PLAN_RANK = 1 ) XX
                ON     A.DIVISION_ID         = XX.DIVISION_ID
                AND    A.PLAN_START_YYYYMMDD = XX.PLAN_START_YYYYMMDD
                AND    A.PLAN_TYPE           = XX.PLAN_TYPE
                AND    A.SEQ                 = XX.PLAN_SEQ
            LEFT OUTER JOIN( --TOSITE PRIORITY CONSTRAINT
                            --SELECT   SEGMENT4   AS ITEM_ID 
                            --        ,SEGMENT5   AS TO_SITE
                            --        ,SEGMENT6   AS PRIORITY
                            --        ,ATTRIBUTE1 AS FROM_DATE
                            --        ,ATTRIBUTE2 AS TO_DATE
                            --FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                            --WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW'
                            --AND     SEGMENT2    = @V_DIVISION_ID -- 전극 사업부 'EE'
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
                                INNER JOIN  (
                                            SELECT  DISTINCT ITEM_ID
                                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                            WHERE   PLAN_ID = @V_PLAN_ID
                                            ) MDL
                                    ON  P.ITEM_ID = MDL.ITEM_ID
                            WHERE   1=1
                            AND     P.VALID_YN = 'Y'
                            AND     P.DIVISION_ID = @V_DIVISION_ID
                            AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                            ) TP
                ON  A.TO_SITE   = TP.TO_SITE
                AND A.ITEM_ID = TP.ITEM_ID
                AND A.YYYYMMDD BETWEEN TP.FROM_DATE AND TP.TO_DATE
            WHERE 1=1
            -- 2025.09.17 Philsu Park: Shipment Semi 케이스 추가.(백선우 책임님 요청)
            -- 2026.04.24 Minyong Lee : 조립계획 대신 SHIP SEMI를 수요로 사용하는 모델 관리방식 하드코딩에서 lookup 사용으로 변경
            -- AND   A.ITEM_ID IN ('APCAN2049A', 'APCCA2504A', 'APCAN2394A')
            --AND   (
            --        A.ITEM_ID IN ('APCAN2049A')
            --OR 
            --   CONCAT(A.TO_SITE, A.ITEM_ID) IN ( SELECT 'HQ08-AAPCCA2504A'
            --                                        UNION ALL
            --                                        SELECT 'HQ08-AAPCAN2394A' 
            --                                        )
            --        )
            AND  A.TO_SITE + '||' + A.ITEM_ID IN (
                                                            SELECT TO_SITE + '||' + ITEM_ID
                                                            FROM @SHIP_SEMI_DEMAND
                                                            )
            AND   A.MEASURE    = 'SHIP_PLAN_AMEND'
            AND   A.QTY        > 0
            AND   A.YYYYMMDD  >= @P_PLAN_NAME  -- 당주 Plan name
			AND   A.YYYYMMDD   <  @V_PLAN_END_YYYYMMDD
            -- 2026.08.03 Minyong Lee : [E20260731-001733] [전극 최적화 알고리즘] 전극 모델 수요 우선순위 적용을 위한 Demand 파일 변경요청
            GROUP BY A.TO_SITE, A.ITEM_ID, A.YYYYMMDD, ISNULL(TP.PRIORITY, 3)
		  ) DEMAND 
    WHERE 1=1
    /************************* 
    대상 프로젝트 ITEM 필터링 
    *************************/
    AND   DEMAND.ITEM_ID IN (SELECT DISTINCT ITEM_ID
    	  	                 FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
    	  	                 WHERE  PLAN_ID = @V_PLAN_ID
    	                    )
    ;
    
    PRINT ('3. Elec Item Transfer: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));
    ----------------------------------------------------------------------------
    -- 2025.06.10 Philsu Park
    -- 전극 ITEM CODE 변환대상 AFTER_CORRECT 말고 여기서 처리.(MERGE를 위해...)
    ----------------------------------------------------------------------------
    UPDATE  DM
    SET      DM.DEMAND_ID  = DM.ATTRIBUTE1+'::'+LU.SEGMENT4+'::'+DM.ATTRIBUTE3+'@'+DM.ATTRIBUTE4+'@'+DM.ATTRIBUTE5+'::'+DM.DUE_DATE+'::-::'+DM.ATTRIBUTE8
            ,DM.BUFFER_ID  = DM.ATTRIBUTE1+'::'+LU.SEGMENT4+'::'+DM.ATTRIBUTE3+'@'+DM.ATTRIBUTE4+'@'+DM.ATTRIBUTE5
            ,DM.ATTRIBUTE2 = LU.SEGMENT4
            ,DM.ATTRIBUTE13 = 'ELEC_ITEM_TRANSFER'
    FROM    @DM_INS_TEMP DM
    INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        ON  LU.LOOKUP_TYPE  = 'SCP_OPT_ELEC_ITEM_TRANSFER'
        AND LU.SEGMENT2     = @V_GROUP_ID
        AND LU.VALID_YN     = 'Y'
        AND DM.ATTRIBUTE2   = LU.SEGMENT3
        AND LU.SEGMENT5    IN ('DEMAND','-')
    WHERE   1=1
    AND     DM.PLAN_ID  = @V_PLAN_ID
    ;

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
                        WHERE   LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
                        AND     VALID_YN      = 'Y'
                        AND     SEGMENT2      = @V_DIVISION_ID
                        AND     SEGMENT3      = @V_GROUP_ID
                        ) LK
        ON  LK.SITE_ID      = DM.ATTRIBUTE1
        AND LK.ITEM_ID      = DM.ATTRIBUTE2
        AND LK.STAGE        = DM.ATTRIBUTE3
        AND DM.DUE_DATE    >= @V_PROD_FROZEN_DAY
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
    --   * 전극(EE) 전용 프로시저이므로 DIVISION 가드 불필요. (소형은 PR_SCP_OPT_ENG_INPUT_DEMAND)
    ----------------------------------------------------------------------------
    IF OBJECT_ID('TEMPDB..#SM_TRSF_RESOLVED') IS NOT NULL DROP TABLE #SM_TRSF_RESOLVED;
    IF OBJECT_ID('TEMPDB..#SM_MINUS_MARK')    IS NOT NULL DROP TABLE #SM_MINUS_MARK;

    -- 차감 발생 행 기록 (프로시저 말미에 DEMAND_SN.UPDATE_ID='SITE_MOVE' 마킹용)
    CREATE TABLE #SM_MINUS_MARK (DEMAND_ID NVARCHAR(200) NOT NULL);

    ----------------------------------------------------------------------------
    -- 4.0.1 기준 플랜 해석 + 룩업 매칭
    --   (디버깅: #SM_TRSF_RESOLVED 만 조회하면 현재 플랜에 적용되는 세팅 전체 확인 가능)
    ----------------------------------------------------------------------------
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

    ----------------------------------------------------------------------------
    -- 4.0.2 수요 차감 (내 그룹 = FROM Plan Group)
    --   대상: ATTRIBUTE2(ITEM) = FERT_CD, DUE_DATE 가 이동 주차(월~일) 내. DEMAND_GROUP 무관.
    --   순서: SEG7 사이트 선차감 -> 그 외 사이트 사전식. 사이트 내 DUE_DATE, DEMAND_ID 오름차순.
    --   부족 시 0까지만 차감(로그/이월 없음). 0이 된 행은 후속 4.1 로직이 삭제.
    --   * 같은 (주차,모델) 풀에 SEG7 이 서로 다른 룩업이 공존하면 MIN(SEG7)을 선차감 사이트로
    --     사용함 (실사용상 비대상 케이스로 판단, 발생 시 별도 검토 필요)
    ----------------------------------------------------------------------------
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

    ----------------------------------------------------------------------------
    -- 4.0.3 수요 증량 (내 그룹 = TO Plan Group)
    --   기존 행 유무와 무관하게 항상 별도 행 INSERT. 가상코드(SEG4+SEG5) 기준.
    --   STAGE/INCOTERMS/PROJECT 는 동일 (TO 수요 사이트, 원본 모델)의 기존 수요 행에서 상속.
    --   (ITEM_SITE 는 본 프로시저 이후에 생성되므로 참조 불가 -> 수요 행이 원천 데이터)
    --   TO 사이트에 원본 모델(SEG4)의 기존 수요가 없으면 '-' 로 생성 (확정)
    ----------------------------------------------------------------------------
    INSERT INTO @DM_INS_TEMP
        (PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
        ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
        ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
        ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
        )
    SELECT  @V_PLAN_ID
           ,RSV.TO_SITE_DEMAND+'::'+RSV.VIRTUAL_ITEM+'::'+GRD.STAGE+'@'+GRD.INCOTERMS+'@'+GRD.PROJECT_CODE
                +'::'+RSV.PLUS_DUE_DATE+'::-::SITE_MOVE'                           AS DEMAND_ID
           ,RSV.TO_SITE_DEMAND+'::'+RSV.VIRTUAL_ITEM+'::'+GRD.STAGE+'@'+GRD.INCOTERMS+'@'+GRD.PROJECT_CODE
                                                                                   AS BUFFER_ID
           -- 2026.09.03 Minyong Lee : PRIORITY/PRIORITY_GROUP/DEMAND_GROUP 도 기존 모델 수요에서 상속
           -- (기존 수요 부재 시 폴백: EE 기본 PRIORITY=3, PRIORITY_GROUP='D3', DEMAND_GROUP=INCOTERMS+'@D3')
           ,GRD.DEMAND_GROUP                                                       AS DEMAND_GROUP
           ,RSV.PLUS_DUE_DATE                                                      AS DUE_DATE
           ,NULL                                                                   AS TARGET_DATE
           ,NULL                                                                   AS SALES_CUTOFF_DATE
           ,NULL                                                                   AS EXPIRY_DATE
           ,GRD.PRIORITY                                                           AS PRIORITY
           ,SUM(RSV.MOVE_QTY)                                                      AS QUANTITY
           ,GRD.PRIORITY_GROUP                                                     AS PRIORITY_GROUP
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
           -- 'X' = 뭉치기 비대상 표준값. 최종 INSERT 의 ATTRIBUTE15 NOT IN ('A','B','C') 필터가
           -- NULL 을 탈락시키므로(3치 논리) NULL 불가 - 반드시 'X' 로 세팅해야 DEMAND_SN 에 반영됨
           ,'X'                                                                    AS ATTRIBUTE15
    FROM    #SM_TRSF_RESOLVED RSV
    OUTER APPLY (
                SELECT  TOP 1
                        D2.ATTRIBUTE3 AS STAGE
                       ,D2.ATTRIBUTE4 AS INCOTERMS
                       ,D2.ATTRIBUTE5 AS PROJECT_CODE
                       -- 2026.09.03 Minyong Lee : 우선순위 3종도 같은 행에서 상속
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
                       -- 2026.09.03 Minyong Lee : 기존 수요 부재 시 EE 기본값 폴백
                       ,ISNULL(GRD0.PRIORITY      , 3)    AS PRIORITY
                       ,ISNULL(GRD0.PRIORITY_GROUP, 'D3') AS PRIORITY_GROUP
                       ,ISNULL(GRD0.DEMAND_GROUP  , ISNULL(GRD0.INCOTERMS, '-') + '@' + 'D3') AS DEMAND_GROUP
                ) GRD
    WHERE   RSV.TO_PLAN_GROUP = @V_GROUP_ID
    AND     RSV.PLUS_DUE_DATE >= @V_PLAN_START_YYYYMMDD   -- 계획구간 이전으로 선행된 수량은 미반영 (구간 이탈)
    -- DEMAND_ID 에서 FROM_SITE 접미 제거됨에 따라 GROUP BY 에서도 FROM_SITE_DEMAND 제외 (동일 DEMAND_ID 중복 행 방지)
    GROUP BY RSV.TO_SITE_DEMAND, RSV.VIRTUAL_ITEM, RSV.PLUS_DUE_DATE
            ,GRD.STAGE, GRD.INCOTERMS, GRD.PROJECT_CODE
            ,GRD.PRIORITY, GRD.PRIORITY_GROUP, GRD.DEMAND_GROUP
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
        -- DEMAND 제외 대상 전극 ITEM 정보 : WHERE 절에서 제외 조건 처리
        -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
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
                        INNER JOIN  (
                                    SELECT  DISTINCT ITEM_ID
                                    FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                    WHERE   PLAN_ID = @V_PLAN_ID
                                    ) MDL
                            ON  D.ITEM_ID = MDL.ITEM_ID
                    WHERE   1=1
                    AND     D.VALID_YN = 'Y'
                    AND     D.DIVISION_ID = @V_DIVISION_ID
                    AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                    --AND     D.STAGE <> 'TARGETBIZ'
                    ) DE
        ON  DM.ATTRIBUTE1 = DE.SCM_SITE_ID
        AND DM.ATTRIBUTE2 = DE.ITEM_ID
        WHERE 1=1
        AND DM.PLAN_ID  = @V_PLAN_ID
        -- DEMAND 제외 대상 처리
        -- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
        AND (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
            OR (ISNULL(DE.ITEM_ID, '') <> '' AND (DM.DUE_DATE < DE.START_DATE OR DM.DUE_DATE > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
            )
        ;
    
    PRINT ('6. Demand Insert NOT IN A, B, C: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  
    ----------------------------------------------------------------------------
    -- 1.4 Demand Insert
    -- 2025.06.09 Philsu Park: A Type은 별도 처리. 나머지는 기존대로 넣어줌.
    -- 2025.08.27 Philsu Park: C Type 추가.
	-- 2025.10.21 Philsu Park: Key 중복 에러 방지를 위한 Group By 처리.
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
            ,MIN(DEMAND_GROUP)	AS DEMAND_GROUP
            ,DUE_DATE
            ,MIN(TARGET_DATE)	AS TARGET_DATE
            ,MIN(SALES_CUTOFF_DATE)	AS SALES_CUTOFF_DATE
            ,MIN(EXPIRY_DATE) 	AS EXPIRY_DATE
            ,PRIORITY
            ,SUM(QUANTITY) AS QUANTITY
            ,PRIORITY_GROUP
            ,MIN(CUSTOMER_ID) AS CUSTOMER_ID
            ,MIN(ALLOW_SHORT) AS ALLOW_SHORT
            ,ATTRIBUTE1
            ,ATTRIBUTE2
            ,ATTRIBUTE3
            ,ATTRIBUTE4
            ,ATTRIBUTE5
            ,ATTRIBUTE6
            ,ATTRIBUTE7
            ,ATTRIBUTE8
            ,MIN(ATTRIBUTE9) AS ATTRIBUTE9
            ,MIN(ATTRIBUTE10) AS ATTRIBUTE10
            ,MIN(ATTRIBUTE11) AS ATTRIBUTE11
            ,MIN(ATTRIBUTE12) AS ATTRIBUTE12
            ,MIN(ATTRIBUTE13) AS ATTRIBUTE13
            ,MIN(ATTRIBUTE14) AS ATTRIBUTE14
            ,MIN(ATTRIBUTE15) AS ATTRIBUTE15
        FROM @DM_INS_TEMP DM
        -- DEMAND 제외 대상 전극 ITEM 정보 : WHERE 절에서 제외 조건 처리
        -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
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
                        INNER JOIN  (
                                    SELECT  DISTINCT ITEM_ID
                                    FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                    WHERE   PLAN_ID = @V_PLAN_ID
                                    ) MDL
                            ON  D.ITEM_ID = MDL.ITEM_ID
                    WHERE   1=1
                    AND     D.VALID_YN = 'Y'
                    AND     D.DIVISION_ID = @V_DIVISION_ID
                    AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                    --AND     D.STAGE <> 'TARGETBIZ'
                    ) DE
        ON  DM.ATTRIBUTE1 = DE.SCM_SITE_ID
        AND DM.ATTRIBUTE2 = DE.ITEM_ID
        WHERE 1=1
        AND DM.PLAN_ID  = @V_PLAN_ID
        -- DEMAND 제외 대상 처리
        -- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
        AND (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
            OR (ISNULL(DE.ITEM_ID, '') <> '' AND (DM.DUE_DATE < DE.START_DATE OR DM.DUE_DATE > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
            )
        AND DM.ATTRIBUTE15 NOT IN ('A', 'B', 'C')
		GROUP BY PLAN_ID
            ,DEMAND_ID
            ,BUFFER_ID
            ,DUE_DATE
            ,PRIORITY
            ,PRIORITY_GROUP
            ,ATTRIBUTE1
            ,ATTRIBUTE2
            ,ATTRIBUTE3
            ,ATTRIBUTE4
            ,ATTRIBUTE5
            ,ATTRIBUTE6
            ,ATTRIBUTE7
            ,ATTRIBUTE8
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
    AND S.DUE_DATE     >= @V_PROD_FROZEN_DAY
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
            -- DEMAND 제외 대상 전극 ITEM 정보 : WHERE 절에서 제외 조건 처리
            -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
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
                            INNER JOIN  (
                                        SELECT  DISTINCT ITEM_ID
                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE   PLAN_ID = @V_PLAN_ID
                                        ) MDL
                                ON  D.ITEM_ID = MDL.ITEM_ID
                        WHERE   1=1
                        AND     D.VALID_YN = 'Y'
                        AND     D.DIVISION_ID = @V_DIVISION_ID
                        AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                        --AND     D.STAGE <> 'TARGETBIZ'
                        ) DE
                ON  S.ATTRIBUTE1 = DE.SCM_SITE_ID
                AND S.ATTRIBUTE2 = DE.ITEM_ID
            WHERE 1=1
            AND S.PLAN_ID       = @V_PLAN_ID
            AND S.ATTRIBUTE15   = 'A'
            AND S.DUE_DATE     >= @V_PROD_FROZEN_DAY
            -- DEMAND 제외 대상 처리
            -- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
            AND (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
                OR (ISNULL(DE.ITEM_ID, '') <> '' AND (S.DUE_DATE < DE.START_DATE OR S.DUE_DATE > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
                )
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
    AND S.DUE_DATE     >= @V_PROD_FROZEN_DAY
    ;

    IF @V_CNT > 0 
        BEGIN 

            IF OBJECT_ID('TEMPDB..#DEMAND_TYPE_B') IS NOT NULL
            BEGIN 
                DROP TABLE  #DEMAND_TYPE_B;
            END;

            SELECT    S.*
                    , CM.BASIS_YYYYMM AS PLAN_YYYYMM
                    , CM.BASIS_DATE
                    , MIN(S.DUE_DATE)OVER(PARTITION BY S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3, CM.BASIS_YYYYMM) MIN_PLAN_YYYYMMDD
                    , DENSE_RANK()OVER(PARTITION BY S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3 ORDER BY CM.BASIS_YYYYMM) AS MONTH_ORDER
            INTO    #DEMAND_TYPE_B
            FROM    @DM_INS_TEMP S
            INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                ON  S.DUE_DATE  = CM.BASIS_YYYYMMDD
            WHERE   S.PLAN_ID   = @V_PLAN_ID
            AND     S.DUE_DATE >= @V_PROD_FROZEN_DAY
            AND     S.ATTRIBUTE15 = 'B'
            ;
            ----------------------------------------------------------------------------
            -- 1.4 Demand Insert
            -- 2025.06.11 Philsu Park: B Type 별도 처리.
            -- 2025.06.18 Philsu Park: Due Date가 Plan 구간 바깥에 있으면 안되기 때문에 LEAST 처리.
            -- 2025.08.28 Philsu Park: DIO_QTY를 계산하는 첫달 찾는 로직은 FIRST_ORDER로 찾게 변경.(Frozen End월과 실제 계획 첫달의 Gap이 있는 경우 첫달 계획 차감하는 결함 보완)
            -- 2025.09.23 Philsu Park: 속도 이슈로 Type B 대상도 temp로 만들어서 돌려줌.
            ----------------------------------------------------------------------------
            WITH DEMAND AS (
                    SELECT    DM.PLAN_ID
                            , CONCAT(DM.ATTRIBUTE1, '::', DM.ATTRIBUTE2, '::', DM.ATTRIBUTE3, '@', DM.ATTRIBUTE4, '@', DM.ATTRIBUTE5, '::', IIF(LEFT(@V_PROD_FROZEN_DAY, 6)=DM.PLAN_YYYYMM, MIN_PLAN_YYYYMMDD, CONCAT(DM.PLAN_YYYYMM, MERGE_VAL)), '::', '-', '::', DM.ATTRIBUTE8) AS DEMAND_ID
                            , DM.BUFFER_ID
                            , MIN(DM.DEMAND_GROUP)      AS DEMAND_GROUP
                            , DM.PLAN_YYYYMM            AS PLAN_YYYYMM
                            , IIF(LEFT(@V_PROD_FROZEN_DAY, 6)=DM.PLAN_YYYYMM, MIN_PLAN_YYYYMMDD, CONCAT(DM.PLAN_YYYYMM, MERGE_VAL)) AS DUE_DATE
                            , MIN(DM.TARGET_DATE)       AS TARGET_DATE
                            , MIN(DM.SALES_CUTOFF_DATE) AS SALES_CUTOFF_DATE
                            , MIN(DM.EXPIRY_DATE)       AS EXPIRY_DATE
                            , MIN(DM.PRIORITY)          AS PRIORITY
                            , SUM(DM.QUANTITY)          AS QUANTITY
                            , MAX(LK.DIO_VAL)           AS DIO_VAL
                            -- , ROUND(IIF(LEFT(@V_PROD_FROZEN_DAY, 6)=DM.PLAN_YYYYMM, 0, SUM(DM.QUANTITY)/30.42*MAX(DIO_VAL)), 0) AS DIO_QTY
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
                    FROM #DEMAND_TYPE_B DM
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
                            , CONCAT(DM.ATTRIBUTE1, '::', DM.ATTRIBUTE2, '::', DM.ATTRIBUTE3, '@', DM.ATTRIBUTE4, '@', DM.ATTRIBUTE5, '::', IIF(LEFT(@V_PROD_FROZEN_DAY, 6)=DM.PLAN_YYYYMM, DM.MIN_PLAN_YYYYMMDD, CONCAT(DM.PLAN_YYYYMM, LK.MERGE_VAL)), '::', '-', '::', DM.ATTRIBUTE8)
                            , DM.BUFFER_ID
                            , DM.PLAN_YYYYMM
                            , IIF(LEFT(@V_PROD_FROZEN_DAY, 6)=DM.PLAN_YYYYMM, DM.MIN_PLAN_YYYYMMDD, CONCAT(DM.PLAN_YYYYMM, LK.MERGE_VAL))
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
    AND S.DUE_DATE     >= @V_PROD_FROZEN_DAY
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
                                --        -- , SEGMENT4

                                -- 2025.10.21 Minyong Lee : Lookup -> UI Table 전환
                                SELECT	CP.ITEM_ID			AS ITEM_ID
                                      , 86400 / MAX(CONVERT(FLOAT, 60 / (CONVERT(NUMERIC(20, 10), CONVERT(FLOAT, CP.M_MIN)) * (ISNULL(CP.PRDN_OPER_RT, 100) / 100))) / CONVERT(FLOAT, CP.LANE * IIF(CP.WIDE_YN = 'Y', 2 , 1))) AS FULL_CAPA
                                FROM	SCP_OPMZ_DDLY_CAPA CP WITH(NOLOCK)
                                WHERE	1=1
                                AND     CP.VALID_YN = 'Y'
                                AND		CP.DIVISION_ID = @V_DIVISION_ID
                                AND     CONVERT(NUMERIC(20, 10), CONVERT(FLOAT, CP.M_MIN)) > 0
                                AND     CP.LANE > 0
                                AND     CP.WIDE_YN IS NOT NULL
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
            -- DEMAND 제외 대상 전극 ITEM 정보 : WHERE 절에서 제외 조건 처리
            -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
            LEFT JOIN ( 
                        --SELECT    SEGMENT2   AS DIVISION_ID
                        --        , SEGMENT3   AS SCM_SITE_ID
                        --        , SEGMENT4   AS ITEM_ID
                        --        , SEGMENT5   AS GROUP_ID
                        --        , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                        --        ELSE ATTRIBUTE2
                        --        END AS START_DATE  -- PLAN 제외 시작일자
                        --        , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                        --        ELSE ATTRIBUTE3
                        --        END AS END_DATE  -- PLAN 제외 끝일자
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
                            INNER JOIN  (
                                        SELECT  DISTINCT ITEM_ID
                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                        WHERE   PLAN_ID = @V_PLAN_ID
                                        ) MDL
                                ON  D.ITEM_ID = MDL.ITEM_ID
                        WHERE   1=1
                        AND     D.VALID_YN = 'Y'
                        AND     D.DIVISION_ID = @V_DIVISION_ID
                        AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                        --AND     D.STAGE <> 'TARGETBIZ'
                        ) DE
                ON  S.ATTRIBUTE1 = DE.SCM_SITE_ID
                AND S.ATTRIBUTE2 = DE.ITEM_ID
            WHERE 1=1
            AND S.PLAN_ID       = @V_PLAN_ID
            AND S.ATTRIBUTE15   = 'C'
            AND S.DUE_DATE     >= @V_PROD_FROZEN_DAY
            -- DEMAND 제외 대상 처리
            -- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
            AND (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
                OR (ISNULL(DE.ITEM_ID, '') <> '' AND (S.DUE_DATE < DE.START_DATE OR S.DUE_DATE > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
                )
            ;
            
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
                SELECT PLAN_ID
                      ,DEMAND_ID
                      ,BUFFER_ID
                      ,DEMAND_GROUP
                      ,DUE_DATE
                      ,TARGET_DATE
                      ,SALES_CUTOFF_DATE
                      ,EXPIRY_DATE
                      ,PRIORITY
                      ,SUM(QUANTITY) AS SUM -- 수요가 충분히 큰 경우 여러 줄이 생길 수 있으므로 SUM -> 이사님 LOOKUP 파일에 예시가 들어져있음.
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
                FROM(
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
                    ) A 
                WHERE 1=1
                GROUP BY PLAN_ID,DEMAND_ID,BUFFER_ID,DEMAND_GROUP,DUE_DATE,TARGET_DATE,SALES_CUTOFF_DATE,EXPIRY_DATE,PRIORITY,PRIORITY_GROUP,CUSTOMER_ID,ALLOW_SHORT,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                        ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                OPTION  (MAXRECURSION 0)
                ;
        END
    PRINT ('9.2 Demand Type C Recursive End: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  

    PRINT ('10. Demand Target_Date Update: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  
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
                                        ON  LU2.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND LU.SEGMENT1 = LU2.SEGMENT2
                                        AND LU.SEGMENT4 = LU2.SEGMENT3
                                        AND LU2.VALID_YN ='Y'
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
                                    LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU2 WITH(NOLOCK)
                                        ON  LU2.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND LU.SEGMENT1 = LU2.SEGMENT2
                                        AND LU.SEGMENT4 = LU2.SEGMENT3
                                        AND LU2.VALID_YN ='Y'
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
	
    END -- 음극 외 일반 로직 종료
    ------------------------------------------------------------------------
    -- Data Insert End
    ------------------------------------------------------------------------
    PRINT ('11. Delete Demand Qty 0: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));  
    ------------------------------------------------------------------------
    -- Data Delete
    -- 2025.08.12 Philsu Park: Workbench에서 0으로 들어온 케이스 제외.
    ------------------------------------------------------------------------
    DELETE  DT
    from    SCP_OPT_ENG_DEMAND_SN DT
    WHERE   DT.PLAN_ID  = @V_PLAN_ID
    AND     DT.QUANTITY = 0
    ;
    /* 
    -- 2025.05.09 Philsu Park: 음극용 Demand 분기 로직 제거. Demand는 동일 Rule로 양극과 로직 통합.
	ELSE
        BEGIN
            ------------------------------------------------------------------------
            -- 음극 전극용 DEMAND 생성
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
                ,ATTRIBUTE1
                ,ATTRIBUTE2
                ,ATTRIBUTE3
                ,ATTRIBUTE4
                ,ATTRIBUTE5
                )
	        SELECT	 SUBSTRING(SOPR.PLAN_ID,0, CHARINDEX('_C',SOPR.PLAN_ID ))+'_A'      AS PLAN_ID
	        		,SITE+'::'+BOM.ANODE_ITEM_ID+'::TARGETBIZ@DAP@-'+'::'+DATE+'::-::-' AS DEMAND_ID
	        		,SITE+'::'+BOM.ANODE_ITEM_ID+'::TARGETBIZ@DAP@-'				    AS BUFFER_ID
	        		,SOPR.C1														    AS DEMAND_GROUP
	        		,SOPR.DATE														    AS DUE_DATE
	        		,NULL															    AS TARGET_DATE
	        		,NULL															    AS SALES_CUTOFF_DATE
	        		,NULL															    AS EXPIRY_DATE
	        		,1																    AS PRIORITY
	        		,SUM(SOPR.QTY*BOM.CAL_USAGE)									    AS QUANTITY
	        		,'D1'															    AS PRIORITY_GROUP
	        		,SOPR.SITE														    AS ATTRIBUTE1
	        		,BOM.ANODE_ITEM_ID												    AS ATTRIBUTE2
	        		,'TARGETBIZ'													    AS ATTRIBUTE3
	        		,'DAP'															    AS ATTRIBUTE4
	        		,'-'			 												    AS ATTRIBUTE4
	        FROM	SCP_OPT_ENG_OUT_PLAN_RESULT_SN SOPR WITH(NOLOCK)
	        		LEFT OUTER JOIN (   SELECT AD.CHILD_ITEM_ID  AS ANODE_ITEM_ID
	        								  ,CD.CHILD_ITEM_ID  AS CHATHODE_ITEM_ID
	        								  ,CD.USAGE/AD.USAGE AS CAL_USAGE        -- CATHODE 소요량/ ANODE 소요량
	        							FROM(   SELECT PARENT_ITEM_ID ,CHILD_ITEM_ID,USAGE
	        									FROM SCP_MST_BOM_ELEC WITh(NOLOCK)
	        									WHERE PARENT_ITEM_ID IN ( SELECT PARENT_ITEM_ID 
	        															  FROM  SCP_MST_BOM_ELEC BE WITH(NOLOCK)
	        																	INNER JOIN ( SELECT DISTINCT ITEM_ID
            																				FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
            																				WHERE  PLAN_ID = SUBSTRING(@V_PLAN_ID,1,LEN(@V_PLAN_ID)-2)+'_C'
                                                                                            ) ML
	        																		ON BE.PARENT_ITEM_ID = ML.ITEM_ID)
	        									AND SCP_YN = 'Y'
	        									AND ELECTRODE_TYPE = 'ANODE'
	        								) AD
	        									INNER JOIN ( SELECT PARENT_ITEM_ID,CHILD_ITEM_ID,USAGE
	        												 FROM SCP_MST_BOM_ELEC WITh(NOLOCK)
	        												 WHERE PARENT_ITEM_ID IN ( SELECT PARENT_ITEM_ID 
	        																		  FROM SCP_MST_BOM_ELEC BE WITH(NOLOCK)
	        																				INNER JOIN(
	        																						  SELECT DISTINCT ITEM_ID
                            																		  FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                            																		  WHERE  PLAN_ID = SUBSTRING(@V_PLAN_ID,1,LEN(@V_PLAN_ID)-2)+'_C'
	        																						  ) ML
	        																					ON BE.PARENT_ITEM_ID = ML.ITEM_ID)
	        												AND SCP_YN = 'Y'
	        												AND ELECTRODE_TYPE = 'CATHODE'
	        											 ) CD
	        									ON AD.PARENT_ITEM_ID = CD.PARENT_ITEM_ID
	        							GROUP BY AD.CHILD_ITEM_ID,CD.CHILD_ITEM_ID,AD.USAGE,CD.USAGE )  BOM
	        			ON SOPR.ITEM = BOM.CHATHODE_ITEM_ID
	        WHERE	1=1
	        AND     PLAN_ID = SUBSTRING(@V_PLAN_ID,1,LEN(@V_PLAN_ID)-2)+'_C'
	        AND		TYPE =  'RTF'
	        GROUP BY SOPR.PLAN_ID, BOM.ANODE_ITEM_ID, SOPR.C1, SOPR.DATE, SOPR.SITE
        END */

	IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
	BEGIN 
		DROP TABLE  #DIVISION;
	END;

	IF OBJECT_ID('TEMPDB..#DEMAND_VERSION') IS NOT NULL
	BEGIN 
		DROP TABLE  #DEMAND_VERSION;
	END;

    IF OBJECT_ID('TEMPDB..#DEMAND_TYPE_A') IS NOT NULL
    BEGIN 
        DROP TABLE  #DEMAND_TYPE_A;
    END;

    IF OBJECT_ID('TEMPDB..#DEMAND_TYPE_B') IS NOT NULL
    BEGIN 
        DROP TABLE  #DEMAND_TYPE_B;
    END;

    

    IF OBJECT_ID('TEMPDB..#DEMAND_TYPE_C') IS NOT NULL
    BEGIN 
        DROP TABLE  #DEMAND_TYPE_C;
    END;


    ----------------------------------------------------------------------------
    -- 2026.08.13 Minyong Lee : [E20260818-000193] [최적화 알고리즘] 사이트간 물량 이관 반영
    --   @DM_INS_TEMP 에는 INSERT_ID/UPDATE_ID 컬럼이 없어 최종 반영 후 마킹.
    --   증량 행: INSERT_ID/UPDATE_ID = 'SITE_MOVE' (ATTRIBUTE8 = 'SITE_MOVE' 기준)
    --   차감 행: UPDATE_ID = 'SITE_MOVE'           (#SM_MINUS_MARK 기준)
    --   * 뭉치기(MERGE)로 DEMAND_ID 가 재구성된 차감 행은 마킹이 누락될 수 있음(디버그 보조용)
    ----------------------------------------------------------------------------
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
