
/*----------------------------------------------------------------------------------------------
* Date          In Charge       Description                                                         
*----------------------------------------------------------------------------------------------
* 2025.07.07    Philsu Park     Initial Release
****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GM_INPUT_ASSIGN_MODEL_LIST]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.05.28 Philsu Park Initial Release.
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_GM_INPUT_ASSIGN_MODEL_LIST';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_PLAN_START_YYYYMM   NVARCHAR(6) = LEFT(@V_PLAN_START_YYYYMMDD, 6);
    DECLARE @V_PLAN_END_YYYYMM     NVARCHAR(6) = LEFT(@V_PLAN_END_YYYYMMDD, 6);
    DECLARE @V_MAX_TUESDAY          NVARCHAR(8);
    DECLARE @D_PLAN_NAME            DATETIME;
    DECLARE @V_DEMAND_CUTOFF_DAY    NVARCHAR(8);
    DECLARE @V_DM_MAX_VERSION       NVARCHAR(50);



    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    ------------------------------------------------------------------------  	
	-- Set Param For Find latest demand version.
	------------------------------------------------------------------------  
    SELECT  @V_MAX_TUESDAY = MAX(BASIS_YYYYMMDD)
    FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK) 
    WHERE   BASIS_YYYYMMDD <= @V_PLAN_START_YYYYMMDD
    AND     DAYOFWEEK       = 'TUE'
    ;

    SELECT @D_PLAN_NAME          = CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD);
    SELECT @V_DEMAND_CUTOFF_DAY  =  MAX(P.CUTOFF_YYYYMMDD)
                                    FROM   DM_PLN_NET_DEMAND P WITH(NOLOCK)
                                    WHERE  P.DIVISION_ID      = @V_DIVISION_ID 							
                                    AND    P.CUTOFF_YYYYMMDD <= @V_PLAN_START_YYYYMMDD 
                                    AND    P.CUTOFF_YYYYMMDD >= CONVERT(NVARCHAR(8), DATEADD(DD, -28, @V_MAX_TUESDAY), 112)
    ------------------------------------------------------------------------
    SELECT  @V_DM_MAX_VERSION = MAX(P.VERSION_NO)
    FROM    DM_PLN_NET_DEMAND P WITH(NOLOCK)
    WHERE   P.DIVISION_ID      = @V_DIVISION_ID
    AND     P.CUTOFF_YYYYMMDD  = @V_DEMAND_CUTOFF_DAY
    ;

    ------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
	--BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------  
	BEGIN TRY

        IF OBJECT_ID('TEMPDB..#STK_MODEL_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #STK_MODEL_LIST;
		END;

		IF OBJECT_ID('TEMPDB..#ASSY_MODEL_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #ASSY_MODEL_LIST;
		END;

		IF OBJECT_ID('TEMPDB..#DEGAS_MODEL_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #DEGAS_MODEL_LIST;
		END;

        IF OBJECT_ID('TEMPDB..#EOL_MODEL_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #EOL_MODEL_LIST;
		END;

		IF OBJECT_ID('TEMPDB..#CHAR_MODEL_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #CHAR_MODEL_LIST;
		END;

		IF OBJECT_ID('TEMPDB..#BIZ_MODEL_LIST') IS NOT NULL
		BEGIN 
			DROP TABLE  #BIZ_MODEL_LIST;
		END;

        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------
		-- 1. STAGE: STK
        -- STK는 룩업 ITEM 정보 기반으로 1레벨 하위 BOM 에서 찾아옴.
        ------------------------------------------------------------------------
        SELECT    @V_PLAN_ID            AS PLAN_ID
                , ST.SCM_SITE_ID        AS SCM_SITE_ID
                , BOM.CHILD_ITEM_ID     AS ITEM_ID
                , CONCAT('STK', '@', LK.LINE_SIDE) AS ITEM_STAGE
                , 'STK'                 AS ORG_STAGE
                , BOM.DIVISION_ID       AS DIVISION_ID
                , BOM.PLANT_ID          AS PLANT_ID
        INTO    #STK_MODEL_LIST
        FROM    SCM_MST_BOM_ENG_SN BOM WITH(NOLOCK)
        INNER JOIN SCM_ITEM_M_SN SIM
            ON  1=1
            AND BOM.COMPANY_ID  = SIM.COMPANY_ID
            AND BOM.DIVISION_ID = SIM.DIVISION_ID
            AND BOM.SITE_ID 	= SIM.SITE_ID
            AND BOM.CHILD_ITEM_ID = SIM.ITEM_ID
            AND SIM.ACTIVE_FLAG = 'Y'
        INNER JOIN SCM_MST_SITE ST WITH(NOLOCK)
            ON  BOM.DIVISION_ID         = ST.DIVISION_ID
            AND BOM.PLANT_ID            = ST.PLANT_ID
            AND BOM.SITE_ID             = ST.SITE_ID
            AND ST.OPERATION_GROUP      = 'A'  -- 조립만.
            AND ST.VALID_YN             = 'Y'
        INNER JOIN (SELECT    SEGMENT3 AS SCM_SITE_ID
                            , SEGMENT4 AS ITEM_ID
                            , SEGMENT5 AS LINE_SIDE
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                    WHERE   LOOKUP_TYPE  = 'SCP_OPT_ENG_GM_ITEM'
                    AND     VALID_YN     = 'Y'
                    AND     SEGMENT1     = @V_DIVISION_ID
                    AND     SEGMENT2     = @V_GROUP_ID
                    ) LK
            ON  ST.SCM_SITE_ID      = LK.SCM_SITE_ID
            AND BOM.PARENT_ITEM_ID  = LK.ITEM_ID
        LEFT OUTER JOIN SCM_MST_ALTER_BOM_V B WITH(NOLOCK)
            ON  BOM.DIVISION_ID    = B.DIVISION_ID
            AND BOM.SITE_ID        = B.SITE_ID
            AND BOM.PLANT_ID       = B.PLANT_ID
            AND BOM.PARENT_ITEM_ID = B.PARENT_ITEM_ID
            AND BOM.CHILD_ITEM_ID  = B.CHILD_ITEM_ID
        WHERE   BOM.DIVISION_ID     = @V_DIVISION_ID
        AND     BOM.EFF_END_DATE   >= @V_PLAN_START_YYYYMMDD
        AND     SIM.FLOW_ID         = 'A8000'  -- STK
        AND     BOM.CHILD_QTY       >  0
        AND     BOM.ACTIVE_FLAG     = 'Y'
        AND    (BOM.ALT_ID IS NULL 
                OR (BOM.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NULL AND ISNULL(BOM.ALT_PRIORITY, 1) = 1)
                OR (BOM.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NOT NULL AND B.SCP_PLAN_YN = 'Y'))
        ;
        ------------------------------------------------------------------------
		-- 2. STAGE: ASSY
        -- ASSY는 FLOW_ID 기준으로 LINE_ASSIGN에서 추출.
        ------------------------------------------------------------------------
        WITH PLAN_GROUP AS (
                    SELECT    GR.OPMZ_PLAN_GR_NAME  AS PLAN_GROUP_NAME
                            , T.OPMZ_PLAN_GR_ID     AS PLAN_GROUP_ID
                            , T.LINE_ID             AS LINE_ID
                            , T.OPERATION_ID        AS OPERATION_ID
                            , T.FACTORY_ID          AS FACTORY_ID
                            , T.PLANT_ID            AS PLANT_ID
                            , T.ITEM_ID             AS ITEM_ID
                    FROM    SCP_OPMZ_PLAN_GR_LINE_M T WITH(NOLOCK)
                    INNER JOIN SCP_OPMZ_PLAN_GR_M GR WITH(NOLOCK)
                        ON  T.OPMZ_PLAN_GR_ID       = GR.OPMZ_PLAN_GR_ID
                    WHERE   GR.OPMZ_PLAN_GR_NAME    = @V_GROUP_ID
                    AND     T.VALID_YN              = 'Y'
                    )
        SELECT    @V_PLAN_ID            AS PLAN_ID
                , ST.SCM_SITE_ID        AS SCM_SITE_ID
                , ILA.ITEM_ID           AS ITEM_ID
                , CONCAT('ASSY', '@', LK.LINE_SIDE) AS ITEM_STAGE
                , 'ASSY'                AS ORG_STAGE
                , ILA.DIVISION_ID       AS DIVISION_ID
                , ILA.PLANT_ID          AS PLANT_ID
        INTO    #ASSY_MODEL_LIST
        FROM    SCM_MST_ITEM_LINE_ASSIGN_SN ILA WITH(NOLOCK)
        INNER JOIN (SELECT    SEGMENT4 AS ITEM_ID
                            , SEGMENT5 AS LINE_SIDE
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                    WHERE   LOOKUP_TYPE  = 'SCP_OPT_ENG_GM_ITEM'
                    AND     VALID_YN     = 'Y'
                    AND     SEGMENT1     = @V_DIVISION_ID
                    AND     SEGMENT2     = @V_GROUP_ID
                    ) LK
            ON  ILA.ITEM_ID = LK.ITEM_ID
        INNER JOIN PLAN_GROUP GRP
            ON  ILA.LINE_ID         = GRP.LINE_ID
            AND ILA.OPERATION_ID    = GRP.OPERATION_ID
            AND ILA.FACTORY_ID      = GRP.FACTORY_ID
            AND ILA.PLANT_ID        = GRP.PLANT_ID
            AND ILA.ITEM_ID         = IIF(GRP.ITEM_ID='-', ILA.ITEM_ID, GRP.ITEM_ID)  -- item 명시 안되어있으면 assign 전체.
        INNER JOIN SCM_ITEM_M_SN SIM
            ON  1=1
            AND ILA.COMPANY_ID  = SIM.COMPANY_ID
            AND ILA.DIVISION_ID = SIM.DIVISION_ID
            AND ILA.SITE_ID 	= SIM.SITE_ID
            AND ILA.ITEM_ID 	= SIM.ITEM_ID
            AND SIM.ACTIVE_FLAG = 'Y'
        LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)
            ON  ILA.DIVISION_ID         = ST.DIVISION_ID
            AND ILA.PLANT_ID            = ST.PLANT_ID
            AND ILA.SITE_ID             = ST.SITE_ID
            AND ST.OPERATION_GROUP      = 'A'  -- 조립만.
            AND ST.VALID_YN             = 'Y'
        WHERE   1=1
        AND     ILA.DIVISION_ID         = @V_DIVISION_ID
        AND     ILA.MONTH         BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
        AND     ILA.ACTIVE_FLAG         = 'Y'
        AND     ILA.PRIORITY           <> 9                       -- 신재욱 책임님 요청. 9순위 제외.
        AND     SIM.FLOW_ID             = 'A9000'  -- STK, ASSY 공정만.
        GROUP BY  ST.SCM_SITE_ID
                , ILA.ITEM_ID
                , LK.LINE_SIDE
                , ILA.DIVISION_ID
                , ILA.PLANT_ID
        ;

        ------------------------------------------------------------------------
		-- 3. STAGE: DEGAS: ASSY -> A_DEGAS, B_DEGAS 모델 변경없이 동일.
        ------------------------------------------------------------------------
        SELECT    @V_PLAN_ID    AS PLAN_ID
                , SCM_SITE_ID   AS SCM_SITE_ID
                , ITEM_ID       AS ITEM_ID
                , CONCAT('A_DEGAS', RIGHT(ITEM_STAGE, 2)) AS ITEM_STAGE
                , 'A_DEGAS'     AS ORG_STAGE
                , DIVISION_ID   AS DIVISION_ID
                , PLANT_ID      AS PLANT_ID
        INTO    #DEGAS_MODEL_LIST
        FROM    #ASSY_MODEL_LIST
        WHERE   ITEM_STAGE LIKE 'ASSY%'
        UNION ALL
        SELECT    @V_PLAN_ID    AS PLAN_ID
                , SCM_SITE_ID   AS SCM_SITE_ID
                , ITEM_ID       AS ITEM_ID
                , CONCAT('B_DEGAS', RIGHT(ITEM_STAGE, 2)) AS ITEM_STAGE
                , 'B_DEGAS'     AS ORG_STAGE
                , DIVISION_ID   AS DIVISION_ID
                , PLANT_ID      AS PLANT_ID
        FROM    #ASSY_MODEL_LIST
        WHERE   ITEM_STAGE LIKE 'ASSY%'
        ;

        ------------------------------------------------------------------------
		-- 4. STAGE: EOL: B_DEGAS -> EOL 모델 변경없이 동일.
        ------------------------------------------------------------------------
        SELECT    @V_PLAN_ID    AS PLAN_ID
                , SCM_SITE_ID   AS SCM_SITE_ID
                , ITEM_ID       AS ITEM_ID
                , CONCAT('EOL', RIGHT(ITEM_STAGE, 2)) AS ITEM_STAGE
                , 'EOL'         AS ORG_STAGE
                , DIVISION_ID   AS DIVISION_ID
                , PLANT_ID      AS PLANT_ID
        INTO    #EOL_MODEL_LIST
        FROM    #DEGAS_MODEL_LIST
        WHERE   ITEM_STAGE LIKE 'B_DEGAS%'
        ;

        ------------------------------------------------------------------------
		-- 5. STAGE: CHAR: EOL 기준으로 PROD 모델 Mapping 정보를 찾아옴.
        ------------------------------------------------------------------------
        SELECT    @V_PLAN_ID            AS PLAN_ID
                , ST.SCM_SITE_ID        AS SCM_SITE_ID
                , PRD.ITEM_ID_PROD      AS ITEM_ID
                , 'CHAR'                AS ITEM_STAGE
                , 'CHAR'                AS ORG_STAGE
                , PRD.DIVISION_ID       AS DIVISION_ID
                , PRD.PLANT_ID          AS PLANT_ID
        INTO    #CHAR_MODEL_LIST
        FROM    SCP_MST_CELL_PROD_ASSY_MAP PRD WITH(NOLOCK)
        INNER JOIN #EOL_MODEL_LIST AG
            ON  AG.DIVISION_ID  = PRD.DIVISION_ID
            AND AG.PLANT_ID     = PRD.PLANT_ID
            AND AG.ITEM_ID      = PRD.ITEM_ID_ASSY
        LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)
            ON  PRD.DIVISION_ID         = ST.DIVISION_ID
            AND PRD.PLANT_ID            = ST.PLANT_ID
            AND ST.OPERATION_GROUP      = 'A'
            AND ST.VALID_YN             = 'Y'
        WHERE   1=1 
        AND     PRD.CELL_TYPE   = 'CA1'
        AND     PRD.VALID_YN    = 'Y'
        /* AND     EXISTS ( SELECT 1
                        FROM   #EOL_MODEL_LIST AG
                        WHERE  AG.DIVISION_ID  = PRD.DIVISION_ID
                        AND    AG.PLANT_ID     = PRD.PLANT_ID
                        AND    AG.ITEM_ID      = PRD.ITEM_ID_ASSY
                        ) */
        GROUP BY  ST.SCM_SITE_ID
                , PRD.ITEM_ID_PROD
                , PRD.DIVISION_ID
                , PRD.PLANT_ID
        ;

        ------------------------------------------------------------------------
		-- 6. STAGE: BIZ: CHAR 기준으로 NET Demand에서 각 Site 별 모델 정보를 추출.
        ------------------------------------------------------------------------
        SELECT    DISTINCT
                  @V_PLAN_ID                AS PLAN_ID
                , A.SCM_SITE_ID             AS SCM_SITE_ID
                , A.ITEM_ID                 AS ITEM_ID
                , IIF(B.OPERATION_GROUP = 'A', 'CELLBIZ', '-') AS ITEM_STAGE
                , 'CELLBIZ'                 AS ORG_STAGE
        INTO #BIZ_MODEL_LIST
        FROM DM_PLN_NET_DEMAND A WITH(NOLOCK)
        INNER JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID
                     FROM   #CHAR_MODEL_LIST
                    --  UNION
                    --  SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID
                    --  FROM   #ASSY_MODEL_LIST
                    --  WHERE  ITEM_STAGE IN ('MDLE', 'PACK')
                    --  AND    DIVISION_ID != '40'
                    ) CM
            ON  A.DIVISION_ID   = CM.DIVISION_ID
            AND A.ITEM_ID       = CM.ITEM_ID
            -- AND A.CELL_PROD_SITE_ID = IIF(@V_DIVISION_ID = '40', CM.SCM_SITE_ID, A.CELL_PROD_SITE_ID)
        ------------------------------------------------------------------------
        INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                    FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                    WHERE  ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리
                        OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                            )
                    ) B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND A.ITEM_ID     = B.ITEM_ID
        ------------------------------------------------------------------------
        /* LEFT OUTER JOIN( --TOSITE PRIORITY CONSTRAINT
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
        AND A.ATTRIBUTE1 BETWEEN TP.FROM_DATE AND TP.TO_DATE */
        ------------------------------------------------------------------------
        -- DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리
        -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
        ------------------------------------------------------------------------
        LEFT JOIN ( 
                    --SELECT  SEGMENT2   AS DIVISION_ID
                    --        , SEGMENT3   AS SCM_SITE_ID
                    --        , SEGMENT4   AS ITEM_ID
                    --        , SEGMENT5   AS GROUP_ID
                    --        , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
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
        AND A.ATTRIBUTE1        >= @V_PLAN_START_YYYYMMDD  
        AND A.ATTRIBUTE1        <  @V_PLAN_END_YYYYMMDD
        AND A.QTY               >  0
        AND (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
                OR (ISNULL(DE.ITEM_ID, '') <> '' AND (A.ATTRIBUTE1 < DE.START_DATE OR A.ATTRIBUTE1 > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
                )
        ;

        INSERT INTO #BIZ_MODEL_LIST
            (   
                  PLAN_ID
                , SCM_SITE_ID
                , ITEM_ID
                , ITEM_STAGE
                , ORG_STAGE
            )
        SELECT    CH.PLAN_ID
                , BZ.SCM_SITE_ID
                , CH.ITEM_ID
                , 'CELLBIZ' AS ITEM_STAGE
                , 'CELLBIZ' AS ORG_STAGE
        FROM    #CHAR_MODEL_LIST CH
        INNER JOIN (SELECT DISTINCT SCM_SITE_ID
                    FROM    #BIZ_MODEL_LIST ) BZ
            ON  1=1
        WHERE   1=1
        AND     NOT EXISTS (
                            SELECT  1 
                            FROM    #BIZ_MODEL_LIST BIZ
                            WHERE   BIZ.PLAN_ID     = CH.PLAN_ID
                            AND     BIZ.SCM_SITE_ID = BZ.SCM_SITE_ID
                            AND     BIZ.ITEM_ID     = CH.ITEM_ID
                            )
        ;

		-----------------------------------------------------
		-- 6. 최종 Model List INSERT : 중복 제외를 위해 UNION 적용
		-----------------------------------------------------
        INSERT INTO SCP_OPT_ENG_MODEL_LIST_N_SN
              (PLAN_ID
              ,SCM_SITE_ID
              ,ITEM_ID
              ,STAGE
              ,ITEM_CLASS_ID
              )
        -- STK Model
        SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE, ORG_STAGE
        FROM    #STK_MODEL_LIST STK WITH(NOLOCK)
        
		-- ASSY Model
        UNION 
        SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE, ORG_STAGE
        FROM    #ASSY_MODEL_LIST LV WITH(NOLOCK)

		-- ASY_AGING
		UNION
		SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE, ORG_STAGE
		FROM    #DEGAS_MODEL_LIST A WITH(NOLOCK)

        -- EOL
		UNION
		SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE, ORG_STAGE
		FROM    #EOL_MODEL_LIST A WITH(NOLOCK)

		-- PACK/MDLE 기준 CHAR Model
		UNION
		SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE, ORG_STAGE
		FROM    #CHAR_MODEL_LIST A WITH(NOLOCK)

        -- BIZ Model
		UNION
		SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE, ORG_STAGE
		FROM    #BIZ_MODEL_LIST A WITH(NOLOCK)

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
