
/*----------------------------------------------------------------------------------------------
* Date          In Charge       Description                                                         
*----------------------------------------------------------------------------------------------
* 2025.09.02    Philsu Park     Initial Release
****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_INPUT_ASSIGN_MODEL_LIST]
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
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_INPUT_ASSIGN_MODEL_LIST';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_PLAN_START_YYYYMM    NVARCHAR(6) = LEFT(@V_PLAN_START_YYYYMMDD, 6);
    DECLARE @V_PLAN_END_YYYYMM      NVARCHAR(6) = LEFT(@V_PLAN_END_YYYYMMDD, 6);
    DECLARE @V_MAX_TUESDAY          NVARCHAR(8);
    DECLARE @D_PLAN_NAME            DATETIME;
    DECLARE @V_DEMAND_CUTOFF_DAY    NVARCHAR(8);
    DECLARE @V_DM_MAX_VERSION       NVARCHAR(50);
    DECLARE @V_SINGLE_PLAN_TYPE     NVARCHAR(1);
    DECLARE @V_PLAN_GROUP_ORG       NVARCHAR(20);

    -- 셀 생산지 버퍼 추가
    DECLARE @DEMAND_ORDER TABLE(
        DIVISION_ID NVARCHAR(100)
      , VERSION_NO  NVARCHAR(100)
      , CUTOFF_YYYYMMDD NVARCHAR(8)
      , R_NUM       INT
    )
    
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

        IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
            BEGIN 
                DROP TABLE  #DIVISION;
            END;

        IF OBJECT_ID('TEMPDB..#ELEC_MODEL_LIST') IS NOT NULL
            BEGIN 
                DROP TABLE  #ELEC_MODEL_LIST;
            END;

        IF OBJECT_ID('TEMPDB..#BIZ_ITEM_LIST') IS NOT NULL
            BEGIN 
                DROP TABLE  #BIZ_ITEM_LIST;
            END;

        IF OBJECT_ID('TEMPDB..#ELEC_BIZ_ITEM_LIST') IS NOT NULL
            BEGIN 
                DROP TABLE  #ELEC_BIZ_ITEM_LIST;
            END;

        ------------------------------------------------------------------------
        -- Origin Division
        ------------------------------------------------------------------------
        SELECT  DIVISION_ID
		INTO    #DIVISION
		FROM    SCM_MST_DIVISION WITH(NOLOCK)
		WHERE  VALID_YN     = 'Y'
		AND    ATTRIBUTE3  <> 'EE'
		AND    ATTRIBUTE4   = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) -- 전극 Division 변수
		;

        ------------------------------------------------------------------------  	
        -- Set Param For Find latest demand version.
        ------------------------------------------------------------------------  
        SELECT  @V_MAX_TUESDAY = MAX(BASIS_YYYYMMDD)
        FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK) 
        WHERE   BASIS_YYYYMMDD <= CONVERT(NVARCHAR(8),GETDATE(),112)
        AND     DAYOFWEEK       = 'TUE'
        ;

        SELECT @D_PLAN_NAME          = CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD);
        SELECT @V_DEMAND_CUTOFF_DAY  = ISNULL(MAX(P.CUTOFF_YYYYMMDD),@V_MAX_TUESDAY)
                                        FROM   DM_PLN_NET_DEMAND P WITH(NOLOCK)
                                        INNER JOIN #DIVISION DIV
                                            ON DIV.DIVISION_ID = P.DIVISION_ID
                                        WHERE  1=1 
                                        -- AND     P.DIVISION_ID      = @V_DIVISION_ID 
                                        AND    P.CUTOFF_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -3, @D_PLAN_NAME), 112) -- 월요일 기준 최근 3일 이내									
                                        AND    P.CUTOFF_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, +6, @D_PLAN_NAME), 112) -- 해당 주차 일요일 이전
        ------------------------------------------------------------------------
        /* SELECT  @V_DM_MAX_VERSION = MAX(P.VERSION_NO)
        FROM    DM_PLN_NET_DEMAND P WITH(NOLOCK)
        INNER JOIN #DIVISION DIV
            ON DIV.DIVISION_ID = P.DIVISION_ID
        WHERE   P.CUTOFF_YYYYMMDD  = @V_DEMAND_CUTOFF_DAY
        ; */

        INSERT INTO @DEMAND_ORDER
        SELECT    DIVISION_ID
                , VERSION_NO
                , CUTOFF_YYYYMMDD
                , R_NUM
        FROM (
                SELECT    P.DIVISION_ID
                        , P.VERSION_NO
                        , P.CUTOFF_YYYYMMDD
                        , ROW_NUMBER()OVER(PARTITION BY P.DIVISION_ID ORDER BY CUTOFF_YYYYMMDD DESC, VERSION_NO DESC) AS R_NUM
                FROM   DM_PLN_NET_DEMAND P WITH(NOLOCK)
                INNER JOIN #DIVISION DIV
                    ON DIV.DIVISION_ID = P.DIVISION_ID
                WHERE  1=1 
                -- AND     P.DIVISION_ID      = @V_DIVISION_ID 
                AND    P.CUTOFF_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -3, @D_PLAN_NAME), 112) -- 월요일 기준 최근 3일 이내
                AND    P.CUTOFF_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, +6, @D_PLAN_NAME), 112) -- 해당 주차 일요일 이전
                ) DM
        WHERE   DM.R_NUM = 1
        ;

		------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------
		
        ------------------------------------------------------------------------
		-- 1. STAGE: COATING(ELEC_POST는 동일 ITEM 이므로 제외)
        -- FLOW_ID 기준으로 LINE_ASSIGN에서 추출.
        ------------------------------------------------------------------------
        --1. GROUP에 해당하는 전극 ITEM 추출.
        WITH PLAN_GROUP AS (
                            SELECT    GR.OPMZ_PLAN_GR_NAME  AS PLAN_GROUP_NAME
                                    , T.OPMZ_PLAN_GR_ID     AS PLAN_GROUP_ID
                                    , T.LINE_ID             AS LINE_ID
                                    , T.OPERATION_ID        AS OPERATION_ID
                                    , T.FACTORY_ID          AS FACTORY_ID
                                    , T.PLANT_ID            AS PLANT_ID
                                    , T.ITEM_ID             AS ITEM_ID
                            FROM    SCP_OPMZ_PLAN_GR_LINE_M T WITH(NOLOCK)
                            INNER JOIN SCP_OPMZ_PLAN_GR_M  GR WITH(NOLOCK)
                                ON  T.OPMZ_PLAN_GR_ID       = GR.OPMZ_PLAN_GR_ID
                            INNER JOIN SCM_LINE_M_SN LM     WITH(NOLOCK)
                                ON  LM.PLANT_ID         = T.PLANT_ID
                                AND LM.FACTORY_ID       = T.FACTORY_ID
                                AND LM.LINE_ID          = T.LINE_ID
                                AND LM.OPERATION_ID     = T.OPERATION_ID
                                AND LM.ACTIVE_FLAG      = 'Y'
                                -- AND LM.ELECTRODE_TYPE   = CASE WHEN 'Y' = 'Y' THEN  'Cathode'
                            WHERE   GR.OPMZ_PLAN_GR_NAME    = @V_PLAN_GROUP_ORG -- PLAN_GROUP이 양극 또는 음극인 경우 원래 Plan Group으로 찾아와야 함.
                            AND     T.VALID_YN              = 'Y'
                            AND     LM.ELECTRODE_TYPE LIKE IIF(@V_SINGLE_PLAN_TYPE = '-', '%%', CONCAT(@V_SINGLE_PLAN_TYPE, '%')) -- 양음극 특정 Type인 경우 해당하는 Line정보만 추출
                    )
        -- 위 정의된 라인 기준으로 Item List 추출.
        SELECT    @V_PLAN_ID            AS PLAN_ID
                , ST.SCM_SITE_ID        AS SCM_SITE_ID
                , ILA.COMPANY_ID        AS COMPANY_ID
                , ILA.DIVISION_ID       AS DIVISION_ID
                , ILA.SITE_ID           AS SITE_ID
                , ILA.ITEM_ID           AS ITEM_ID
                , CASE  WHEN ILA.OPERATION_ID = 'E2000' THEN 'COATING'   -- COATING
                        WHEN ILA.OPERATION_ID = 'A9000' THEN 'TARGETBIZ'  -- LAMI, HALF LAMI
                        ELSE '-' END    AS STAGE
                , ILA.PLANT_ID          AS PLANT_ID
                , ILA.OPERATION_ID      AS OPERATION_ID
        INTO    #ELEC_MODEL_LIST
        FROM    SCM_MST_ITEM_LINE_ASSIGN_SN ILA WITH(NOLOCK)
        INNER JOIN #DIVISION DIV
            ON  ILA.DIVISION_ID = DIV.DIVISION_ID
        INNER JOIN PLAN_GROUP GRP
            ON  ILA.LINE_ID         = GRP.LINE_ID
            AND ILA.OPERATION_ID    = GRP.OPERATION_ID
            AND ILA.FACTORY_ID      = GRP.FACTORY_ID
            AND ILA.PLANT_ID        = GRP.PLANT_ID
            AND ILA.ITEM_ID         = IIF(GRP.ITEM_ID='-', ILA.ITEM_ID, GRP.ITEM_ID)  -- ITEM 명시 안되어있으면 ASSIGN 전체.
        INNER JOIN (
                    SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                    FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
                    WHERE  1=1
                    ) FNL
            ON  ILA.DIVISION_ID = FNL.DIVISION_ID
            AND ILA.ITEM_ID     = FNL.ITEM_ID
        INNER  JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
            ON  1=1
            AND ILA.COMPANY_ID  = SIM.COMPANY_ID
            AND ILA.DIVISION_ID = SIM.DIVISION_ID
            AND ILA.SITE_ID 	= SIM.SITE_ID
            AND ILA.ITEM_ID 	= SIM.ITEM_ID
            AND SIM.ACTIVE_FLAG = 'Y'
        LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)
            ON  ILA.DIVISION_ID     = ST.DIVISION_ID
            AND ILA.PLANT_ID        = ST.PLANT_ID
            AND ILA.SITE_ID         = ST.SITE_ID
            AND ST.OPERATION_GROUP  = FNL.OPERATION_GROUP
            AND ST.VALID_YN         = 'Y'
        WHERE   1=1
        AND     ILA.MONTH         BETWEEN @V_PLAN_START_YYYYMM AND @V_PLAN_END_YYYYMM
        AND     ILA.ACTIVE_FLAG         = 'Y'
        AND     ILA.PRIORITY           <> 9                       -- 신재욱 책임님 요청. 9순위 제외
        GROUP BY  ST.SCM_SITE_ID
                , ILA.ITEM_ID
                , ILA.OPERATION_ID
                , ILA.PLANT_ID
                , ILA.COMPANY_ID
                , ILA.DIVISION_ID
                , ILA.SITE_ID
        ;

        ------------------------------------------------------------------------
		-- 1. STAGE: TARGETBIZ
        -- FLOW_ID 기준으로 LINE_ASSIGN에서 추출.
        -- 2025.09.25 Philsu Park: 조립 - 전극 Site Mapping 정보(SITE_INFO) 동일 COMPANY 하위 2개 이상의 PLANT 반영되게 수정.
        ------------------------------------------------------------------------
        WITH SITE_INFO AS (
                /* SELECT    S.DIVISION_ID, S.COMPANY_ID, S.SITE_ID, S.CITY
                        , MAX(IIF(S.OPERATION_GROUP = 'A', S.SCM_SITE_ID, ''))  AS ASY_SITE_ID
                        , MAX(IIF(S.OPERATION_GROUP = 'A', S.PLANT_ID, ''))     AS ASY_PLANT_ID
                        , MAX(IIF(S.OPERATION_GROUP = 'E', S.SCM_SITE_ID, ''))  AS ELEC_SITE_ID
                        , MAX(IIF(S.OPERATION_GROUP = 'E', S.PLANT_ID, ''))     AS ELEC_PLANT_ID
                FROM    SCM_MST_SITE S WITH(NOLOCK)
                INNER JOIN #DIVISION DIV
                    ON  DIV.DIVISION_ID     = S.DIVISION_ID
                WHERE   S.OPERATION_GROUP  IN ('A', 'E')
                AND     S.VALID_YN          = 'Y'
                GROUP BY S.DIVISION_ID, S.COMPANY_ID, S.SITE_ID, S.CITY */
                SELECT    S.DIVISION_ID, S.COMPANY_ID, S.SITE_ID, S.CITY
                        , MAX(IIF(S.OPERATION_GROUP = 'A', S.SCM_SITE_ID, ''))  AS ASY_SITE_ID
                        , MAX(IIF(S.OPERATION_GROUP = 'A', S.PLANT_ID, ''))     AS ASY_PLANT_ID
                        , MAX(IIF(S.OPERATION_GROUP = 'E', S.SCM_SITE_ID, ''))  AS ELEC_SITE_ID
                        , MAX(IIF(S.OPERATION_GROUP = 'E', S.PLANT_ID, ''))     AS ELEC_PLANT_ID
                FROM    SCM_MST_SITE S WITH(NOLOCK)
                INNER JOIN #DIVISION DIV
                    ON  DIV.DIVISION_ID     = S.DIVISION_ID
                WHERE   S.OPERATION_GROUP  IN ('A', 'E')
                AND     S.VALID_YN          = 'Y'
                AND     S.SITE_TYPE         = 'PLANT'
                AND     S.OSP_YN            = 'N'
                GROUP BY S.DIVISION_ID, S.COMPANY_ID, S.SITE_ID, S.CITY
                HAVING MAX(IIF(S.OPERATION_GROUP = 'A', S.PLANT_ID, '')) <> MAX(IIF(S.OPERATION_GROUP = 'E', S.PLANT_ID, ''))
                AND     MAX(IIF(S.OPERATION_GROUP = 'E', S.PLANT_ID, '')) != ''
                UNION
                SELECT    S.DIVISION_ID, S.COMPANY_ID, S.SITE_ID, S.CITY
                        , MAX(IIF(S.OPERATION_GROUP = 'A', S.SCM_SITE_ID, ''))  AS ASY_SITE_ID
                        , MAX(IIF(S.OPERATION_GROUP = 'A', S.PLANT_ID, ''))     AS ASY_PLANT_ID
                        , MAX(IIF(S.OPERATION_GROUP = 'E', S.SCM_SITE_ID, ''))  AS ELEC_SITE_ID
                        , MAX(IIF(S.OPERATION_GROUP = 'E', S.PLANT_ID, ''))     AS ELEC_PLANT_ID
                FROM    SCM_MST_SITE S WITH(NOLOCK)
                INNER JOIN #DIVISION DIV
                    ON  DIV.DIVISION_ID     = S.DIVISION_ID
                WHERE   S.OPERATION_GROUP  IN ('A', 'E')
                AND     S.VALID_YN          = 'Y'
                AND     S.SITE_TYPE         = 'PLANT'
                AND     S.OSP_YN            = 'N'
                GROUP BY S.DIVISION_ID, S.COMPANY_ID, S.SITE_ID, S.CITY, S.PLANT_ID
                HAVING MAX(IIF(S.OPERATION_GROUP = 'A', S.PLANT_ID, '')) = MAX(IIF(S.OPERATION_GROUP = 'E', S.PLANT_ID, ''))
                )
        SELECT    @V_PLAN_ID            AS PLAN_ID
                , EL.ASY_SITE_ID        AS SCM_SITE_ID
                , BOM.PARENT_ITEM_ID    AS ITEM_ID
                , 'TARGETBIZ'           AS STAGE
        INTO    #BIZ_MODEL_LIST
        FROM    SCP_MST_BOM_ELEC BOM WITH(NOLOCK)
        INNER JOIN (
                    SELECT    LI.COMPANY_ID
                            , LI.DIVISION_ID
                            , LI.SITE_ID
                            , LI.PLANT_ID
                            , LI.ITEM_ID
                            , ST.ASY_SITE_ID
                    FROM   #ELEC_MODEL_LIST  LI
                    INNER JOIN SITE_INFO    ST
                    ON 1=1
                    AND LI.COMPANY_ID   = ST.COMPANY_ID
                    AND LI.DIVISION_ID  = ST.DIVISION_ID
                    AND LI.SITE_ID      = ST.SITE_ID
                    AND LI.PLANT_ID     = ST.ELEC_PLANT_ID
                    AND LI.SCM_SITE_ID  = ST.ELEC_SITE_ID
                        ) EL 
            ON  EL.DIVISION_ID = BOM.DIVISION_ID
            AND EL.ITEM_ID     = BOM.CHILD_ITEM_ID
        WHERE   BOM.SCP_YN = 'Y'
        AND     EXISTS (
                        SELECT  1 
                        FROM    SCM_ITEM_M_SN ITM
                        WHERE   1=1 
                        AND     ITM.COMPANY_ID  = EL.COMPANY_ID
                        -- AND     ITM.DIVISION_ID = BOM.DIVISION_ID
                        AND     ITM.SITE_ID     = EL.SITE_ID
                        AND     ITM.ITEM_ID     = BOM.PARENT_ITEM_ID
                        AND     ITM.ITEM_CLASS  = 'ES1901' -- Cell Assy.
                        )
        GROUP BY EL.ASY_SITE_ID, BOM.PARENT_ITEM_ID
        UNION
        SELECT    @V_PLAN_ID    AS PLAN_ID
                , SEGMENT2      AS SITE_ID
                , SEGMENT3      AS ITEM_ID
                , 'TARGETBIZ'   AS STAGE
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   LK.LOOKUP_TYPE  = 'SCP_OPT_ELEC_DEMAND_SITE'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = @V_DIVISION_ID
        AND     LK.SEGMENT4     = @V_GROUP_ID
        ;

        ------------------------------------------------------------------------
		-- 6. STAGE: ELEC_BIZ: 
        ------------------------------------------------------------------------
        SELECT    DISTINCT
                  @V_PLAN_ID                AS PLAN_ID
                , A.SCM_SITE_ID             AS SCM_SITE_ID
                , A.ITEM_ID                 AS ITEM_ID
                -- , IIF(B.OPERATION_GROUP = 'A', 'ELECBIZ', '-') AS ITEM_STAGE
                , 'ELECBIZ'                 AS STAGE
        INTO #ELEC_BIZ_MODEL_LIST
        FROM DM_PLN_NET_DEMAND A WITH(NOLOCK)
        INNER JOIN @DEMAND_ORDER DM
            ON  DM.DIVISION_ID      = A.DIVISION_ID
            AND DM.VERSION_NO       = A.VERSION_NO
            AND DM.CUTOFF_YYYYMMDD  = A.CUTOFF_YYYYMMDD
        INNER JOIN #DIVISION DIV
            ON A.DIVISION_ID = DIV.DIVISION_ID
        INNER JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID
                     FROM   #ELEC_MODEL_LIST
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
                    WHERE  1=1
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
                        INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN MDL WITH(NOLOCK)
                            ON  MDL.PLAN_ID = @V_PLAN_ID
                            --AND D.SCM_SITE_ID = MDL.SCM_SITE_ID
                            AND D.ITEM_ID = MDL.ITEM_ID
                    WHERE   1=1
                    AND     D.VALID_YN = 'Y'
                    AND     D.DIVISION_ID = @V_DIVISION_ID
                    AND     PG.OPMZ_PLAN_GR_NAME = @V_PLAN_GROUP_ORG
                    ) DE
        ON  A.SCM_SITE_ID   = DE.SCM_SITE_ID
        AND A.ITEM_ID       = DE.ITEM_ID
                ------------------------------------------------------------------------
        WHERE 1=1 
        -- AND A.CUTOFF_YYYYMMDD   =  @V_DEMAND_CUTOFF_DAY
        -- AND A.VERSION_NO        =  @V_DM_MAX_VERSION
        AND A.ATTRIBUTE1        >= @V_PLAN_START_YYYYMMDD  
        AND A.ATTRIBUTE1        <  @V_PLAN_END_YYYYMMDD
        AND A.QTY               >  0
        AND (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
                OR (ISNULL(DE.ITEM_ID, '') <> '' AND (A.ATTRIBUTE1 < DE.START_DATE OR A.ATTRIBUTE1 > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
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
              )
            -- COATING
            SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, STAGE
            FROM    #ELEC_MODEL_LIST
            UNION
            SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, STAGE
            FROM    #BIZ_MODEL_LIST
            UNION
            SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, STAGE
            FROM    #ELEC_BIZ_MODEL_LIST
        ;
        
        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------

        IF OBJECT_ID('TEMPDB..#ELEC_MODEL_LIST') IS NOT NULL
            BEGIN 
                DROP TABLE  #ELEC_MODEL_LIST;
            END;

        IF OBJECT_ID('TEMPDB..#BIZ_ITEM_LIST') IS NOT NULL
            BEGIN 
                DROP TABLE  #BIZ_ITEM_LIST;
            END;

        IF OBJECT_ID('TEMPDB..#ELEC_BIZ_ITEM_LIST') IS NOT NULL
            BEGIN 
                DROP TABLE  #ELEC_BIZ_ITEM_LIST;
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
