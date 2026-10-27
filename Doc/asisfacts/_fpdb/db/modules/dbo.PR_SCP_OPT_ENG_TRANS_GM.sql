
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_TRANS_GM]
     @P_FP_ASSY_PLAN_ID     NVARCHAR(50)
    ,@P_FP_ASSY_INSTANCE_ID NVARCHAR(50)
    ,@P_FP_FORM_PLAN_ID     NVARCHAR(50)    -- 활성화. 조립일 때만 들어온다.
    ,@P_FP_FORM_INSTANCE_ID NVARCHAR(50)    -- 활성화. 조립일 때만 들어온다.
    ,@P_FP_ELEC_PLAN_ID     NVARCHAR(50)
    ,@P_FP_ELEC_INSTANCE_ID NVARCHAR(50)
    ,@P_SCP_OPT_PLAN_ID     NVARCHAR(50)
    ,@P_PLAN_TYPE           NVARCHAR(50)
    ,@P_USER_ID             NVARCHAR(100)
AS 
BEGIN

    SET ARITHABORT ON;
    SET ANSI_NULLS ON;
    SET QUOTED_IDENTIFIER ON;
	SET NOCOUNT ON;

    ------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_OPT_ENG_TRANS_GM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	-------------------------------------------------------------------------------------
	-- SET Parameter
	-------------------------------------------------------------------------------------
    -- DECLARE @V_INSTANCE_ID              NVARCHAR(50) = @FP_INSTANCE_ID;
    DECLARE @V_PLAN_ID                  NVARCHAR(50) = @P_SCP_OPT_PLAN_ID;
    DECLARE @V_PLAN_TYPE                NVARCHAR(50) = @P_PLAN_TYPE;
    -- DECLARE @V_FP_FOR_PLAN_ID           NVARCHAR(50) = @FP_FOR_PLAN_ID;
    -- DECLARE @V_FP_FOR_PLAN_INSTANCE_ID  NVARCHAR(50) = @FP_FOR_INSTANCE_ID;
    DECLARE @V_PLAN_START_YYYYMMDD      NVARCHAR(8)
    DECLARE @V_PLAN_END_YYYYMMDD        NVARCHAR(8)
    DECLARE @V_DIVISION_ID              NVARCHAR(50)
    DECLARE @V_PLAN_GROUP_ID            NVARCHAR(8)

	DECLARE @V_PLAN_START_MONTH_DAY NVARCHAR(8)

	DECLARE @MAX_TUESDAY NVARCHAR(8)
	DECLARE @V_DM_MAX_VERSION NVARCHAR(50)
    DECLARE @P_PLAN_NAME         NVARCHAR(8) 
    DECLARE @D_PLAN_NAME         DATETIME 
	DECLARE @V_DEMAND_CUTOFF_DAY NVARCHAR(8)

    DECLARE @V_MESSAGE_TEXT NVARCHAR(1000);
	
	DECLARE @V_FP_PLAN_ID NVARCHAR(100);
    -------------------------------------------------------------------------------------
    -- 쿼리 속도 개선을 위한 임시테이블 생성 
    DECLARE @OPERATION_TEMP TABLE(
         STAGE          NVARCHAR(100)
        ,OPERATION_ID   NVARCHAR(100)
        ,OPERATION_NAME NVARCHAR(100)
        ,INSTANCE_ID    NVARCHAR(100)
        ,FP_PLAN_ID     NVARCHAR(100)
        )
	-------------------------------------------------------------------------------------
	DECLARE @DIVISION TABLE(
         DIVISION_ID  NVARCHAR(100)
        )
	-------------------------------------------------------------------------------------
	DECLARE @RESULT_TEMP TABLE(
     TYPE				NVARCHAR(100)
    ,SCM_SITE_ID		NVARCHAR(100)
    ,ITEM_ID			NVARCHAR(100)
    ,STAGE				NVARCHAR(100)
    ,PRODUCTION_DATE	NVARCHAR(100)
    ,LINE_ID			NVARCHAR(100)
    ,QTY				NUMERIC(20,10)
    ,OPERATION_ID		NVARCHAR(100)
    ,FROM_SITE			NVARCHAR(100)
    ,TO_SITE			NVARCHAR(100)
    ,BOD_ID				NVARCHAR(100)
    ,TRANSPORT_MODE		NVARCHAR(100)
    ,INCOTERMS			NVARCHAR(100)
    ,DEPARTURE_DATE		NVARCHAR(100)
    ,ARRIVAL_DATE		NVARCHAR(100)
    )

    DECLARE @TMP_BUF_AMEND_PLAN_R_XLS TABLE
        (
            INSTANCE_ID	        NVARCHAR(150)
            ,FP_PLAN_ID	        NVARCHAR(150)
            ,COMPANY_ID	        NVARCHAR(150)
            ,DIVISION_ID	    NVARCHAR(150)
            ,CATEGORY_ID	    NVARCHAR(150)
            ,SITE_ID	        NVARCHAR(150)
            ,PLANT_ID	        NVARCHAR(150)
            ,FACTORY_ID	        NVARCHAR(150)
            ,LOCATION	        NVARCHAR(150)
            ,OPERATION_ID	    NVARCHAR(150)
            ,LINE_ID	        NVARCHAR(150)
            ,ELECTRODE_TYPE	    NVARCHAR(150)
            ,EQUIPMENT_ID	    NVARCHAR(150)
            ,PLAN_DATE	        DATETIME
            ,MODEL_ID	        NVARCHAR(150)
            ,ITEM_ID	        NVARCHAR(150)
            ,PRODUCTION_TYPE	NVARCHAR(150)
            ,MARKET	            NVARCHAR(150)
            ,VERSION	        NVARCHAR(150)
            ,PLM_EC_NO	        NVARCHAR(150)
            ,CELL_OUT_QTY	    NUMERIC(20, 10)
            ,ITEM_TYPE	        NVARCHAR(150)
            ,SEQ	            NUMERIC(20, 10)
            ,CUSTOMER_ID	    NVARCHAR(150)
            ,BOH_QTY	        NVARCHAR(150)
            ,NICK_NAME	        NVARCHAR(150)
            ,LINE_NAME	        NVARCHAR(150)
            ,OPERATION_NAME	    NVARCHAR(150)
            ,MODE	            NVARCHAR(150)
            ,KEYS_MODEL	        NVARCHAR(150)
            ,INSTANCE_ID2	    NVARCHAR(150)
            ,ROWNUM	            NUMERIC(20, 10)
            ,QTY	            NUMERIC(20, 10)
            ,CRUD	            NVARCHAR(150)
            ,INSERT_ID          NVARCHAR(150)
            ,INSERT_TIME        DATETIME
            ,UPDATE_ID          NVARCHAR(150)
            ,UPDATE_TIME        DATETIME
            ,MEMO	            NVARCHAR(700)
			,WORKING_DAY 		NUMERIC(20, 10)
        )

    DECLARE @TMP_BUF_AMEND_PLAN_SSP_R_XLS TABLE
        (
              DIVISION_ID       NVARCHAR(30)
            , PROJECT_CODE      NVARCHAR(50)
            , SCM_SITE_ID       NVARCHAR(30)
            , ITEM_ID           NVARCHAR(50)
            , FCST_TYPE         NVARCHAR(20)
            , INCOTERMS         NVARCHAR(10)
            , TRANSPORT_MODE    NVARCHAR(10)
            , BOD_ID            NVARCHAR(150)
            , MEASURE           NVARCHAR(50)
            , PLANT_SITE_ID     NVARCHAR(50)
            , SITE_TYPE         NVARCHAR(10)
            , YYYYMMDD          NVARCHAR(8)
            , QTY               NUMERIC(20, 10)
            , CREATED_BY        NVARCHAR(150)
            , CREATION_DATE     DATETIME
            , LAST_UPDATED_BY   NVARCHAR(150)
            , LAST_UPDATE_DATE  DATETIME
            , JOB_USER_ID       NVARCHAR(50)
            , JOB_TIME          DATETIME
            , JOB_TYPE          NVARCHAR(50)
            , JOB_SEQ           INT
            , JOB_ORDER         INT
            , ATTRIBUTE2        NVARCHAR(150)
        )

    DECLARE @OUT_ITEM TABLE(
		 TYPE				NVARCHAR(200)
		,ITEM_ID			NVARCHAR(200)	
		)

	-------------------------------------------------------------------------------------
	DECLARE @DAILY_CAPA TABLE(
		 OPERATION_ID		NVARCHAR(200)
		,LINE_ID			NVARCHAR(200)
		,ITEM_ID			NVARCHAR(200)			
		,PLAN_YYYYMM		NVARCHAR(200)
		,DAILY_QTY			NVARCHAR(200)
		)

    BEGIN TRY

        ------------------------------------------------------------------------
        -- LOG 시작
        ------------------------------------------------------------------------
        SET @v_log_type = 'START';
        SET @v_log_message = '########## Start of procedure ##########';
        -- SET @v_description = 'START_' + @V_PROGRAM_NAME+'@'+@PLAN_START_YYYYMMDD+'@'+@V_PLAN_ID
        SET @d_event_date = SYSDATETIME();
        -- EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------  
        -------------------------------------------------------------------------------------
        -- Set Planning Info
        -------------------------------------------------------------------------------------
        SELECT  @V_PLAN_START_YYYYMMDD  = PLAN_START_DATE
            ,@V_PLAN_END_YYYYMMDD    = PLAN_END_DATE
            ,@V_DIVISION_ID          = ATTRIBUTE1
            ,@V_PLAN_GROUP_ID        = ATTRIBUTE2
            ,@V_PLAN_START_MONTH_DAY = CONVERT(NVARCHAR, DATEADD(DAY, 1- DAY(CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),CONVERT(DATETIME, @V_PLAN_START_YYYYMMDD)),112)
        FROM    SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        WHERE   PLAN_ID = @V_PLAN_ID
        ;

        -------------------------------------------------------------------------------------
        -- Set Division for Elec Plan
        -------------------------------------------------------------------------------------
        INSERT INTO  @DIVISION
        SELECT DIVISION_ID 
        FROM   SCM_MST_DIVISION_SN WITH(NOLOCK)
        WHERE  VALID_YN = 'Y'
        AND    ATTRIBUTE3 <> 'EE'
        AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION_SN WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID )
        ;
        
        -------------------------------------------------------------------------------------
        -- Set Operation Map
        -------------------------------------------------------------------------------------
        INSERT INTO @OPERATION_TEMP
        SELECT	 LV.SEGMENT3 AS STAGE
                ,LV.SEGMENT5 AS OPERATION_ID
                ,MAX(OM.OPERATION_NAME) AS OPERATION_NAME
                ,CASE WHEN LV.SEGMENT5 = 'E2000' THEN @P_FP_ELEC_INSTANCE_ID
                    WHEN LV.SEGMENT5 = 'F6000' THEN @P_FP_FORM_INSTANCE_ID
                    ELSE @P_FP_ASSY_INSTANCE_ID
                    END    AS INSTANCE_ID
                ,CASE WHEN LV.SEGMENT5 = 'E2000' THEN @P_FP_ELEC_PLAN_ID
                    WHEN LV.SEGMENT5 = 'F6000' THEN @P_FP_FORM_PLAN_ID
                    ELSE @P_FP_ASSY_PLAN_ID
                    END    AS FP_PLAN_ID
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LV WITH(NOLOCK)
        INNER JOIN @DIVISION DIV
            ON  1=1
        INNER JOIN SCM_OPERATION_M OM WITH(NOLOCK)
            ON  OM.DIVISION_ID  = DIV.DIVISION_ID
            AND OM.OPERATION_ID = LV.SEGMENT5
        WHERE   LV.LOOKUP_TYPE = 'SCP_OPT_ENG_STAGE_OPERATION_MAP'
        AND     LV.SEGMENT1    = @V_DIVISION_ID
        AND     LV.SEGMENT2    = @V_PLAN_GROUP_ID
        AND     LV.VALID_YN    = 'Y'
        GROUP BY  LV.SEGMENT3
                , LV.SEGMENT5
        ;
        
        -------------------------------------------------------------------------------------
        -- Set Version info fo FCST
        -------------------------------------------------------------------------------------
        SELECT  @MAX_TUESDAY = MAX(BASIS_YYYYMMDD)
        FROM    SCM_SYS_CALENDAR_M_SN WITH(NOLOCK) 
        WHERE   BASIS_YYYYMMDD <= CONVERT(NVARCHAR(8),GETDATE(),112)
        AND     DAYOFWEEK = 'TUE'

        SELECT @P_PLAN_NAME          = @V_PLAN_START_YYYYMMDD;
        SELECT @D_PLAN_NAME          = CONVERT(DATETIME, @P_PLAN_NAME);
        SELECT @V_DEMAND_CUTOFF_DAY  = ISNULL(MAX(P.CUTOFF_YYYYMMDD),@MAX_TUESDAY)
                                        FROM   DM_PLN_NET_DEMAND_SN P WITH(NOLOCK)
                                        WHERE  P.DIVISION_ID      = @V_DIVISION_ID 
                                        AND    P.CUTOFF_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -3, @D_PLAN_NAME), 112)
                                        AND    P.CUTOFF_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, +6, @D_PLAN_NAME), 112)
        
        SELECT  @V_DM_MAX_VERSION = MAX(P.VERSION_NO)
        FROM    DM_PLN_NET_DEMAND_SN P WITH(NOLOCK)
        WHERE   P.DIVISION_ID      = @V_DIVISION_ID 
        AND     P.CUTOFF_YYYYMMDD  = @V_DEMAND_CUTOFF_DAY
        ;

		 -------------------------------------------------------------------------------------
        -- Set FP_PLAN_ID
        -------------------------------------------------------------------------------------
		SELECT @V_FP_PLAN_ID = MAX(INTG_PLAN_ID)
		FROM   SCM_FP_PLAN_H WITH(NOLOCK)
		WHERE  PLAN_ID IN ( @P_FP_ASSY_PLAN_ID, @P_FP_FORM_PLAN_ID, @P_FP_ELEC_PLAN_ID )
		;


        INSERT INTO @OUT_ITEM
        EXEC PR_SCP_OPT_ENG_RESULT @V_FP_PLAN_ID, @V_PLAN_ID, 'ITEM'
        ;

		-------------------------------------------------------------------------------------
		-- Set Daily CAPA
		-- 2025.09.10 Philsu Park: 룩업의 Tact Time 값 Numeric으로 Type Casting.
		-- 2025.09.12 Philsu Park: Engine Input 기반으로 출처 변경
		-- 2025.09.15 Philsu Park: 수율 역산 처리(Load_Per 값 자체가 수율 먹은채로 엔진 수행되고 있어서)
		-------------------------------------------------------------------------------------
		INSERT INTO @DAILY_CAPA
		SELECT    LK.SEGMENT5       AS OPERATION_ID
				, IIF(@V_DIVISION_ID LIKE 'EE%', R.ATTRIBUTE13, R.ATTRIBUTE15)     AS LINE_ID
				, R.ATTRIBUTE2      AS ITEM_ID
				, R.ATTRIBUTE14     AS PLAN_YYYYMM
				-- , 86400/R.LOAD_PER  AS DAILY_QTY
				--, 86400/(MAX(R.LOAD_PER)/MAX(RT.YIELD))  AS DAILY_QTY
                , IIF(MAX(RT.YIELD)=0,0, 86400/(MAX(R.LOAD_PER)/MAX(RT.YIELD))) AS DAILY_QTY
		FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN R WITH(NOLOCK)
		INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LK WITH(NOLOCK)
			ON  LK.LOOKUP_TYPE  = 'SCP_OPT_ENG_STAGE_OPERATION_MAP' 
			AND LK.SEGMENT1     = @V_DIVISION_ID
			AND LK.SEGMENT2     = @V_PLAN_GROUP_ID
			AND LK.VALID_YN     = 'Y'
			AND LK.SEGMENT3     = R.ATTRIBUTE3
		LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN RT
			ON  R.PLAN_ID    = RT.PLAN_ID
			AND R.ROUTING_ID = RT.ROUTING_ID
			AND R.OP_SEQ	 = RT.OP_SEQ
		LEFT OUTER JOIN (
						SELECT  ATTRIBUTE3 AS STAGE
						FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LU WITH(NOLOCK)
						WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
						AND     LU.SEGMENT2    = @V_DIVISION_ID
						AND     LU.SEGMENT3    = @V_PLAN_GROUP_ID
						AND     LU.VALID_YN    = 'Y'
						GROUP BY ATTRIBUTE3
					) OCV
			ON  LK.SEGMENT3 = OCV.STAGE
		WHERE   R.PLAN_ID           = @V_PLAN_ID
		AND     R.RESOURCE_CLASS_ID = 'LINE'
		AND     OCV.STAGE IS NULL -- 2nd OCV STAGE는 대상이 아님
		GROUP BY LK.SEGMENT5, IIF(@V_DIVISION_ID LIKE 'EE%', R.ATTRIBUTE13, R.ATTRIBUTE15), R.ATTRIBUTE2, R.ATTRIBUTE14
		;

        -------------------------------------------------------------------------------------
        -- 2025.08.28 Philsu Park
        -- PROD INSERT.
        -- 2025.09.17 Philsu Park: 특정 공정 ROUND 처리.
        -- 2025.09.23 Philsu Park: F6000은 PRODUCTION_TYPE '-'로 반영(백선우 책임님 요청)
        -- 2025.09.23 Philsu Park: 계획 없는 모델 BUF 에 추가 반영(ASSY 만 일단 적용)
        -------------------------------------------------------------------------------------
        BEGIN

            PRINT ('PROD INSERT START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));
            -- 속도 이슈로 임시테이블에 일단 담아서 추가 정보 업데이트.
            INSERT INTO @TMP_BUF_AMEND_PLAN_R_XLS
                (
                    INSTANCE_ID
                    , FP_PLAN_ID
                    , COMPANY_ID
                    , DIVISION_ID
                    , CATEGORY_ID
                    , PLANT_ID
                    , LOCATION
                    , OPERATION_ID
                    , LINE_ID
                    , ELECTRODE_TYPE
                    , EQUIPMENT_ID
                    , PLAN_DATE
                    , ITEM_ID
                    , PRODUCTION_TYPE
                    , MARKET
                    , VERSION
                    , PLM_EC_NO
                    , CELL_OUT_QTY
                    , ITEM_TYPE
                    , SEQ
                    , CUSTOMER_ID
                    , BOH_QTY
                    , OPERATION_NAME
                    , MODE
                    , KEYS_MODEL
                    , INSTANCE_ID2
                    , ROWNUM
                    , QTY
                    , CRUD
                    , INSERT_ID
                    , INSERT_TIME
                    , MEMO
					, WORKING_DAY
                )
                SELECT    OPR.INSTANCE_ID                               AS INSTANCE_ID
                        , OPR.FP_PLAN_ID                                AS FP_PLAN_ID
                        , ST.COMPANY_ID                                 AS COMPANY_ID
                        , ST.DIVISION_ID                                AS DIVISION_ID
                        , 'PLAN'                                        AS CATEGORY_ID
                        , ST.PLANT_ID                                   AS PLANT_ID
                        , '-'                                           AS LOCATION
                        , OPR.OPERATION_ID                              AS OPERATION_ID
                        , IBR.LINE_ORG                                  AS LINE_ID
                        , CASE  WHEN CHARINDEX('@', IBR.LINE_ID) > 0 THEN 
                                CASE WHEN SUBSTRING(IBR.LINE_ID, CHARINDEX('@', IBR.LINE_ID)+1, 1) = 'A' THEN 'Anode'
                                     WHEN SUBSTRING(IBR.LINE_ID, CHARINDEX('@', IBR.LINE_ID)+1, 1) = 'C' THEN 'Cathode'
                                     ELSE NULL END
                          ELSE  NULL END 						        AS ELECTRODE_TYPE
                        , '-'                                           AS EQUIPMENT_ID
                        , OP.START_DATE                                 AS PLAN_DATE
                        , OP.ITEM_ID                                    AS ITEM_ID
                        , IIF(OPR.OPERATION_ID = 'F6000', '-', 'MASS')  AS PRODUCTION_TYPE
                        , 'D'                                           AS MARKET
                        , '-'                                           AS VERSION
                        , '-'                                           AS PLM_EC_NO
                        , CASE WHEN OPR.OPERATION_ID IN ('A8000', 'F6000', 'A9000') THEN ROUND(SUM(CONVERT(NUMERIC(20,10), OP.OUT_QTY)), 0) ELSE SUM(CONVERT(NUMERIC(20,10), OP.OUT_QTY)) END AS CELL_OUT_QTY
                        , '-'                                           AS ITEM_TYPE
                        , 1                                             AS SEQ
                        , '-'                                           AS CUSTOMER_ID
                        , ''                                            AS BOH_QTY
                        , MAX(OPR.OPERATION_NAME)                       AS OPERATION_NAME
                        , ''                                            AS MODE
                        , ''                                            AS KEYS_MODEL
                        , OPR.INSTANCE_ID                               AS INSTANCE_ID2
                        , NULL                                          AS ROWNUM
                        , SUM(CONVERT(NUMERIC(20,10), OP.OUT_QTY))      AS QTY      	-- 최적화 계획 수량을 CELL로 환산해서 넣음. * 실제 테이블에 넣을 때 각 품목 UOM으로 환산해서 넣어야 한다.
                        , ''                                            AS CRUD     	-- 공란으로 형성
                        , 'PROD_INSERT'                                 AS INSERT_ID
                        , CURRENT_TIMESTAMP                             AS INSERT_TIME
                        , NULL                                          AS MEMO   		-- MEMO는 기존 값 보완하여 입력
						, NULL 											AS WORKING_DAY	-- 2025.10.21 Phislu Park: 추가 컬럼. 셀 환산 전에 업데이트.
                FROM    SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN OP WITH(NOLOCK)
                INNER JOIN ( 
                            SELECT  B.ROUTING_BOM_MAPPING_ID
                                    , IIF(CHARINDEX('@', R.ATTRIBUTE15) > 0, LEFT(R.ATTRIBUTE15, CHARINDEX('@', R.ATTRIBUTE15)-1), R.ATTRIBUTE15) AS LINE_ORG
                                    ,  R.ATTRIBUTE15 AS LINE_ID
                            FROM    SCP_OPT_ENG_ITEM_BOM_ROUTING_SN B WITH(NOLOCK)
                            INNER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN R WITH(NOLOCK)
                                ON  R.PLAN_ID           = B.PLAN_ID
                                AND R.ROUTING_ID        = B.ROUTING_ID
                                AND R.RESOURCE_CLASS_ID = 'LINE'
                                --  AND    R.OP_SEQ = 0
                            WHERE   B.PLAN_ID = @V_PLAN_ID
                            AND     R.RESOURCE_ID IS NOT NULL
                        ) IBR
                    ON  OP.ROUTING_BOM_MAPPING_ID = IBR.ROUTING_BOM_MAPPING_ID
                INNER JOIN SCP_OPT_ENG_PLAN_MASTER_SN PM WITH(NOLOCK)
                    ON  OP.PLAN_ID  = PM.PLAN_ID
                INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                    ON  OP.PLAN_ID              = SIS.PLAN_ID
                    AND OP.PRODUCED_BUFFER_ID   = SIS.BUFFER_ID
                INNER JOIN @OPERATION_TEMP OPR
                    ON  OPR.STAGE = SIS.STAGE
                INNER JOIN @DIVISION DIV
                    ON  1=1
                INNER JOIN SY_SCM_MST_SITE ST WITH(NOLOCK)
                    ON  ST.DIVISION_ID  = DIV.DIVISION_ID
                    AND ST.SCM_SITE_ID  = SIS.SITE_ID
                    AND ST.VALID_YN     = 'Y'
                WHERE   OP.PLAN_ID      = @V_PLAN_ID
                GROUP BY  OPR.INSTANCE_ID, OPR.FP_PLAN_ID, OPR.OPERATION_ID
                        , ST.COMPANY_ID, ST.DIVISION_ID, ST.PLANT_ID
                        , OP.SITE_ID, OP.ITEM_ID, OP.GRADE, OP.START_DATE
                        , IBR.LINE_ORG
                        , CASE  WHEN CHARINDEX('@', IBR.LINE_ID) > 0 THEN 
                                CASE WHEN SUBSTRING(IBR.LINE_ID, CHARINDEX('@', IBR.LINE_ID)+1, 1) = 'A' THEN 'Anode'
                                     WHEN SUBSTRING(IBR.LINE_ID, CHARINDEX('@', IBR.LINE_ID)+1, 1) = 'C' THEN 'Cathode'
                                     ELSE NULL END
                          ELSE  NULL END
                UNION
                SELECT    OPR.INSTANCE_ID                               AS INSTANCE_ID
                        , OPR.FP_PLAN_ID                                AS FP_PLAN_ID
                        , ST.COMPANY_ID                                 AS COMPANY_ID
                        , ST.DIVISION_ID                                AS DIVISION_ID
                        , 'PLAN'                                        AS CATEGORY_ID
                        , ST.PLANT_ID                                   AS PLANT_ID
                        , '-'                                           AS LOCATION
                        , OPR.OPERATION_ID                              AS OPERATION_ID
                        , IIF(CHARINDEX('@', R.ATTRIBUTE15) > 0, LEFT(R.ATTRIBUTE15, CHARINDEX('@', R.ATTRIBUTE15)-1), R.ATTRIBUTE15) AS LINE_ID
                        , CASE  WHEN CHARINDEX('@', R.ATTRIBUTE15) > 0 THEN 
                                CASE WHEN SUBSTRING(R.ATTRIBUTE15, CHARINDEX('@', R.ATTRIBUTE15)+1, 1) = 'A' THEN 'Anode'
                                    WHEN SUBSTRING(R.ATTRIBUTE15, CHARINDEX('@', R.ATTRIBUTE15)+1, 1) = 'C' THEN 'Cathode'
                                    ELSE NULL END
                        ELSE  NULL END                                  AS ELECTRODE_TYPE
                        , '-'                                           AS EQUIPMENT_ID
                        , @V_PLAN_START_YYYYMMDD                        AS PLAN_DATE
                        , IBR.ATTRIBUTE2                                AS ITEM_ID
                        , IIF(OPR.OPERATION_ID = 'F6000', '-', 'MASS')  AS PRODUCTION_TYPE
                        , 'D'                                           AS MARKET
                        , '-'                                           AS VERSION
                        , '-'                                           AS PLM_EC_NO
                        , 0                                             AS CELL_OUT_QTY
                        , '-'                                           AS ITEM_TYPE
                        , 1                                             AS SEQ
                        , '-'                                           AS CUSTOMER_ID
                        , ''                                            AS BOH_QTY
                        , MAX(OPR.OPERATION_NAME)                       AS OPERATION_NAME
                        , ''                                            AS MODE
                        , ''                                            AS KEYS_MODEL
                        , OPR.INSTANCE_ID                               AS INSTANCE_ID2
                        , NULL                                          AS ROWNUM
                        , 0                                             AS QTY      	-- 최적화 계획 수량을 CELL로 환산해서 넣음. * 실제 테이블에 넣을 때 각 품목 UOM으로 환산해서 넣어야 한다.
                        , ''                                            AS CRUD     	-- 공란으로 형성
                        , 'PROD_INSERT_DUMMY'                           AS INSERT_ID
                        , CURRENT_TIMESTAMP                             AS INSERT_TIME
                        , NULL                                          AS MEMO   		-- MEMO는 기존 값 보완하여 입력
						, NULL											AS WORKING_DAY 	-- 2025.10.21 Phislu Park: 추가 컬럼. 셀 환산 전에 업데이트.
                FROM    SCP_OPT_ENG_ITEM_BOM_ROUTING_SN IBR WITH(NOLOCK)
                INNER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN R WITH(NOLOCK)
                    ON  R.PLAN_ID           = IBR.PLAN_ID
                    AND R.ROUTING_ID        = IBR.ROUTING_ID
                    AND R.RESOURCE_CLASS_ID = 'LINE'
                INNER JOIN SCP_OPT_ENG_PLAN_MASTER_SN PM WITH(NOLOCK)
                    ON  IBR.PLAN_ID  = PM.PLAN_ID
                INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                    ON  IBR.PLAN_ID     = SIS.PLAN_ID
                    AND IBR.BUFFER_ID   = SIS.BUFFER_ID
                INNER JOIN @DIVISION DIV
                    ON  1=1
                INNER JOIN @OPERATION_TEMP OPR
                    ON  OPR.STAGE = SIS.STAGE
                INNER JOIN SY_SCM_MST_SITE ST WITH(NOLOCK)
                    ON  ST.DIVISION_ID  = DIV.DIVISION_ID
                    AND ST.SCM_SITE_ID  = SIS.SITE_ID
                    AND ST.VALID_YN     = 'Y'
                WHERE   IBR.PLAN_ID      = @V_PLAN_ID
                AND     IBR.ATTRIBUTE3  = 'ASSY'  -- 조립 ONLY.
                AND     R.RESOURCE_ID IS NOT NULL
                AND     EXISTS ( 
                                SELECT 1
                                FROM   @OUT_ITEM OT
                                WHERE  OT.ITEM_ID = IBR.ATTRIBUTE2 
                                )
                AND     NOT EXISTS (
                                    SELECT  1 
                                    FROM    SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN OP WITH(NOLOCK)
                                    WHERE   PLAN_ID = @V_PLAN_ID
                                    AND     PRODUCED_BUFFER_ID = IBR.BUFFER_ID
                                    )
                GROUP BY  OPR.INSTANCE_ID, OPR.FP_PLAN_ID, OPR.OPERATION_ID
                        , ST.COMPANY_ID, ST.DIVISION_ID, ST.PLANT_ID
                        , IBR.ATTRIBUTE1
                        , IBR.ATTRIBUTE2
                        , IBR.ATTRIBUTE4--, OP.START_DATE
                        , IIF(CHARINDEX('@', R.ATTRIBUTE15) > 0, LEFT(R.ATTRIBUTE15, CHARINDEX('@', R.ATTRIBUTE15)-1), R.ATTRIBUTE15)
                        , CASE  WHEN CHARINDEX('@', R.ATTRIBUTE15) > 0 THEN 
                                CASE WHEN SUBSTRING(R.ATTRIBUTE15, CHARINDEX('@', R.ATTRIBUTE15)+1, 1) = 'A' THEN 'Anode'
                                    WHEN SUBSTRING(R.ATTRIBUTE15, CHARINDEX('@', R.ATTRIBUTE15)+1, 1) = 'C' THEN 'Cathode'
                                    ELSE NULL END
                        ELSE  NULL END
                ;

            PRINT ('LINE MST UPDATE START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            UPDATE S
            SET       S.SITE_ID         = LM.SITE_ID
                    , S.FACTORY_ID      = LM.FACTORY_ID
                    , S.ELECTRODE_TYPE  = IIF(ISNULL(S.ELECTRODE_TYPE, '') = '', LM.ELECTRODE_TYPE, S.ELECTRODE_TYPE)
                    , S.LINE_NAME       = LM.LINE_NAME
                    , S.UPDATE_ID       = ISNULL(S.UPDATE_ID, '') + '/LINE'
                    , S.UPDATE_TIME     = CURRENT_TIMESTAMP
            FROM    @TMP_BUF_AMEND_PLAN_R_XLS S
            INNER JOIN SCM_LINE_M LM WITH(NOLOCK)
                ON  LM.COMPANY_ID   = S.COMPANY_ID
                AND LM.DIVISION_ID  = S.DIVISION_ID
                AND LM.PLANT_ID     = S.PLANT_ID
                AND LM.OPERATION_ID = S.OPERATION_ID
                AND LM.LINE_ID      = S.LINE_ID
                AND LM.ACTIVE_FLAG  = 'Y'
            ;

            PRINT ('ITEM MST UPDATE START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            UPDATE  S
            SET       S.MODEL_ID    = ITM.APPLIED_MODEL
                    , S.NICK_NAME   = ITM.NICK_NAME
                    , S.UPDATE_ID   = ISNULL(S.UPDATE_ID, '') + '/ITEM'
                    , S.UPDATE_TIME = CURRENT_TIMESTAMP
            FROM    @TMP_BUF_AMEND_PLAN_R_XLS S
            INNER JOIN SCM_ITEM_M ITM WITH(NOLOCK)
                ON  ITM.COMPANY_ID  = S.COMPANY_ID
                AND ITM.DIVISION_ID = S.DIVISION_ID
                AND ITM.SITE_ID     = S.SITE_ID
                AND ITM.ITEM_ID     = S.ITEM_ID
            ;

            -- 2025.09.19 Philsu Park: 전극의 경우, Model 및 Version 정보를 별도 원천에서 업데이트.
            UPDATE  S
            SET       S.MODEL_ID    = M.MODEL_ID
                    , S.VERSION     = M.VERSION
                    , S.UPDATE_ID   = ISNULL(S.UPDATE_ID, '') + '/EE_ITM'
                    , S.UPDATE_TIME = CURRENT_TIMESTAMP
            FROM    @TMP_BUF_AMEND_PLAN_R_XLS S
            INNER JOIN FP_OPT_PLAN_VERSION_CHANGE_M m with(nolock)
                ON  M.COMPANY_ID    = S.COMPANY_ID
                AND M.DIVISION_ID   = S.DIVISION_ID
                AND M.SITE_ID       = S.SITE_ID
                AND M.PLANT_ID      = S.PLANT_ID
                AND M.FACTORY_ID    = S.FACTORY_ID
                AND M.LINE_ID       = S.LINE_ID 
                AND M.OPERATION_ID  = S.OPERATION_ID
                AND M.ITEM_ID       = S.ITEM_ID
            WHERE S.OPERATION_ID = 'E2000'
            ;

			UPDATE 	S
			SET 	S.WORKING_DAY = S.QTY / CP.DAILY_QTY
			FROM    @TMP_BUF_AMEND_PLAN_R_XLS S
            LEFT OUTER JOIN @DAILY_CAPA CP
                ON  CP.OPERATION_ID  = S.OPERATION_ID
				AND CP.LINE_ID       = S.LINE_ID 
                AND CP.ITEM_ID       = S.ITEM_ID
				AND CP.PLAN_YYYYMM 	 = LEFT(CONVERT(NVARCHAR, S.PLAN_DATE, 112), 6)
            -- WHERE S.OPERATION_ID = 'E2000'
            ;

			

            PRINT ('COATING CALC START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));
			
            -- COATING 공정은 장비정보 추가 업데이트.
            WITH BOM_ELEC AS 
                (
                    -- Elec to Cell 환산 #1: 81_UC 기준 1개건 말고는 전부 소요량 일치하므로 max로 사용
                    SELECT  B.CHILD_ITEM_ID, MAX(B.USAGE) MAX_USAGE
                    FROM    SCP_MST_BOM_ELEC_SN B WITH(NOLOCK)
                    INNER JOIN @DIVISION DIV
                        ON  B.DIVISION_ID = DIV.DIVISION_ID
                    WHERE   B.SCP_YN        = 'Y'
                    -- AND     B.DIVISION_ID   = '81_UC'
                    GROUP BY B.CHILD_ITEM_ID
                )
            UPDATE  S
            SET       S.EQUIPMENT_ID    = ISNULL(EQ.EQUIPMENT_ID, '-')
                    , S.QTY             = S.QTY / BOM.MAX_USAGE
                    , S.CELL_OUT_QTY    = S.CELL_OUT_QTY / BOM.MAX_USAGE
                    , S.UPDATE_ID       = ISNULL(S.UPDATE_ID, '') + '/EQ'
                    , S.UPDATE_TIME     = CURRENT_TIMESTAMP
            FROM    @TMP_BUF_AMEND_PLAN_R_XLS S
            INNER JOIN BOM_ELEC BOM
                ON S.ITEM_ID = BOM.CHILD_ITEM_ID
            LEFT OUTER JOIN SCM_EQUIPMENT_M EQ WITH(NOLOCK)
                ON  EQ.COMPANY_ID       = S.COMPANY_ID
                AND EQ.DIVISION_ID      = S.DIVISION_ID
                AND EQ.SITE_ID          = S.SITE_ID
                AND EQ.PLANT_ID         = S.PLANT_ID
                AND EQ.FACTORY_ID       = S.FACTORY_ID
                AND EQ.OPERATION_ID     = S.OPERATION_ID
                AND EQ.LINE_ID          = S.LINE_ID
                AND EQ.ACTIVE_FLAG      = 'Y'
                AND EQ.EQUIPMENT_TYPE   = 'M'
                AND EQ.OPERATION_ID     = 'E2000'
            WHERE   EQ.OPERATION_ID IS NOT NULL
            ;

            PRINT ('NND BOM START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            IF OBJECT_ID('TEMPDB..#BOM_NND') IS NOT NULL
                BEGIN 
                    DROP TABLE  #BOM_NND;
                END;

            SELECT  MM.CHILD_ITEM_ID, MAX(MM.ACCUM_CHILD_QTY) AS MAX_USAGE
            INTO    #BOM_NND
            FROM ( 
                    SELECT  A.MODEL_ID, A.CHILD_ITEM_ID, SUM(A.ACCUMULATED_CHILD_QTY) ACCUM_CHILD_QTY
                    FROM    SCM_MODEL_COMP_EFFECTIVE_DATE A WITH(NOLOCK) --SCM_MODEL_COMP_EFFECTIVE_DATE
                    INNER JOIN @DIVISION DIV
                        ON  A.DIVISION_ID = DIV.DIVISION_ID
                    INNER JOIN SCM_ITEM_M IC WITH (NOLOCK)
                        ON  A.COMPANY_ID     = IC.COMPANY_ID
                        AND A.DIVISION_ID    = IC.DIVISION_ID
                        AND A.SITE_ID        = IC.SITE_ID
                        AND A.CHILD_ITEM_ID  = IC.ITEM_ID
                        AND IC.ACTIVE_FLAG    = 'Y'
                    LEFT OUTER JOIN SCM_MST_ALTER_BOM_V_SN ABM WITH(NOLOCK)  --SCM_MST_ALTER_BOM_V
                        ON  A.DIVISION_ID    = ABM.DIVISION_ID
                        AND A.SITE_ID        = ABM.SITE_ID
                        AND A.PLANT_ID       = ABM.PLANT_ID
                        AND A.PARENT_ITEM_ID = ABM.PARENT_ITEM_ID
                        AND A.CHILD_ITEM_ID  = ABM.CHILD_ITEM_ID
                    WHERE   1=1
                    -- AND     A.DIVISION_ID = '81_UC'
                    AND     ISNULL(A.PARENT_ITEM_ID, '*') != '*'
                    AND     A.EFF_END_DATE > CONVERT(DATE, @V_PLAN_START_YYYYMMDD, 112)
                    AND     IC.FLOW_ID LIKE 'A5000%'  -- NND
                    AND   (A.ALT_ID IS NULL 
                            OR (A.ALT_ID IS NOT NULL AND ABM.SCP_PLAN_YN IS NULL AND ISNULL(A.ALT_PRIORITY, 'N') = 'Y')
                            OR (A.ALT_ID IS NOT NULL AND ABM.SCP_PLAN_YN IS NOT NULL AND ABM.SCP_PLAN_YN = 'Y'))
                    GROUP BY A.MODEL_ID, A.CHILD_ITEM_ID
                    ) MM
            GROUP BY CHILD_ITEM_ID
            ;
			
            PRINT ('NND UPDATE START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            -- 2025.09.17 Philsu Park: NND 정수화 처리.
            UPDATE  S
            SET       S.QTY = ROUND(S.QTY / BOM.MAX_USAGE, 0)
                    , S.CELL_OUT_QTY    = ROUND(S.CELL_OUT_QTY / BOM.MAX_USAGE, 0)
                    , S.UPDATE_ID       = ISNULL(S.UPDATE_ID, '') + '/NND'
                    , S.UPDATE_TIME     = CURRENT_TIMESTAMP
            FROM    @TMP_BUF_AMEND_PLAN_R_XLS S
            INNER JOIN #BOM_NND BOM
                ON S.ITEM_ID = BOM.CHILD_ITEM_ID
            ;
			
            PRINT ('A8000 DUMMY START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            -----------------------------------------------------------------------------
            -- 2025.09.24 Philsu Park: A8000의 경우, Calendar Join해서 전구간 확장 처리.
            -- START
            -----------------------------------------------------------------------------
            IF OBJECT_ID('TEMPDB..#TMP_BUF_AMEND_PLAN_R_XLS') IS NOT NULL
                BEGIN 
                    DROP TABLE  #TMP_BUF_AMEND_PLAN_R_XLS;
                END;

            IF OBJECT_ID('TEMPDB..#TMP_BUF_AMEND_PLAN_R_DUMMY') IS NOT NULL
                BEGIN 
                    DROP TABLE  #TMP_BUF_AMEND_PLAN_R_DUMMY;
                END;

            SELECT  *
            INTO    #TMP_BUF_AMEND_PLAN_R_XLS
            FROM    @TMP_BUF_AMEND_PLAN_R_XLS
            WHERE   OPERATION_ID = 'A8000'
            ;

            SELECT    XLS.INSTANCE_ID           AS INSTANCE_ID
                    , XLS.FP_PLAN_ID            AS FP_PLAN_ID
                    , XLS.COMPANY_ID            AS COMPANY_ID
                    , XLS.DIVISION_ID           AS DIVISION_ID
                    , XLS.CATEGORY_ID           AS CATEGORY_ID
                    , XLS.SITE_ID               AS SITE_ID
                    , XLS.PLANT_ID              AS PLANT_ID
                    , XLS.FACTORY_ID            AS FACTORY_ID
                    , MAX(XLS.LOCATION)         AS LOCATION
                    , XLS.OPERATION_ID          AS OPERATION_ID
                    , XLS.LINE_ID               AS LINE_ID
                    , MAX(XLS.ELECTRODE_TYPE)   AS ELECTRODE_TYPE
                    , MAX(XLS.EQUIPMENT_ID)     AS EQUIPMENT_ID
                    , CAL.BASIS_YYYYMMDD        AS PLAN_YYYYMMDD
                    , XLS.MODEL_ID
                    , XLS.ITEM_ID
                    , XLS.PRODUCTION_TYPE
                    , MAX(XLS.MARKET)           AS MARKET
                    , MAX(XLS.VERSION)          AS VERSION
                    , MAX(XLS.PLM_EC_NO)        AS PLM_EC_NO
                    , MAX(XLS.ITEM_TYPE)        AS ITEM_TYPE
                    , MAX(XLS.SEQ)              AS SEQ
                    , MAX(XLS.CUSTOMER_ID)      AS CUSTOMER_ID
                    , MAX(XLS.NICK_NAME)        AS NICK_NAME
                    , MAX(XLS.LINE_NAME)        AS LINE_NAME
                    , MAX(XLS.OPERATION_NAME)   AS OPERATION_NAME
                    , MAX(XLS.MODE)             AS MODE
                    , MAX(XLS.KEYS_MODEL)       AS KEYS_MODEL
                    , MAX(XLS.INSTANCE_ID2)     AS INSTANCE_ID2
                    , MAX(XLS.ROWNUM)           AS ROWNUM
            INTO    #TMP_BUF_AMEND_PLAN_R_DUMMY
            FROM    #TMP_BUF_AMEND_PLAN_R_XLS XLS
            INNER JOIN SCM_SYS_CALENDAR_M_SN CAL
                ON  CAL.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
            WHERE   1=1--XLS.OPERATION_ID = 'A8000'
            GROUP BY  XLS.INSTANCE_ID
                    , XLS.FP_PLAN_ID
                    , XLS.COMPANY_ID
                    , XLS.DIVISION_ID
                    , XLS.CATEGORY_ID
                    , XLS.SITE_ID
                    , XLS.PLANT_ID
                    , XLS.FACTORY_ID
                    , XLS.OPERATION_ID
                    , XLS.LINE_ID
                    , CAL.BASIS_YYYYMMDD
                    , XLS.MODEL_ID
                    , XLS.ITEM_ID
                    , XLS.PRODUCTION_TYPE
            ;

            DELETE 
            FROM    @TMP_BUF_AMEND_PLAN_R_XLS
            WHERE   OPERATION_ID = 'A8000'
            ;

            INSERT INTO @TMP_BUF_AMEND_PLAN_R_XLS
                ( INSTANCE_ID
                , FP_PLAN_ID
                , COMPANY_ID
                , DIVISION_ID
                , CATEGORY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LOCATION
                , OPERATION_ID
                , LINE_ID
                , ELECTRODE_TYPE
                , EQUIPMENT_ID
                , PLAN_DATE
                , MODEL_ID
                , ITEM_ID
                , PRODUCTION_TYPE
                , MARKET
                , VERSION
                , PLM_EC_NO
                , CELL_OUT_QTY
                , ITEM_TYPE
                , SEQ
                , CUSTOMER_ID
                , BOH_QTY
                , NICK_NAME
                , LINE_NAME
                , OPERATION_NAME
                , MODE
                , KEYS_MODEL
                , INSTANCE_ID2
                , ROWNUM
                , QTY
                , CRUD
                , INSERT_ID
                , INSERT_TIME
                , UPDATE_ID
                , UPDATE_TIME
                , MEMO
				, WORKING_DAY)
                SELECT    PLN.INSTANCE_ID                           AS INSTANCE_ID
                        , PLN.FP_PLAN_ID                            AS FP_PLAN_ID
                        , PLN.COMPANY_ID                            AS COMPANY_ID
                        , PLN.DIVISION_ID                           AS DIVISION_ID
                        , PLN.CATEGORY_ID                           AS CATEGORY_ID
                        , PLN.SITE_ID                               AS SITE_ID
                        , PLN.PLANT_ID                              AS PLANT_ID
                        , PLN.FACTORY_ID                            AS FACTORY_ID
                        , MAX(PLN.LOCATION)                         AS LOCATION
                        , PLN.OPERATION_ID                          AS OPERATION_ID
                        , PLN.LINE_ID                               AS LINE_ID
                        , MAX(PLN.ELECTRODE_TYPE)                   AS ELECTRODE_TYPE
                        , MAX(PLN.EQUIPMENT_ID)                     AS EQUIPMENT_ID
                        , CONVERT(DATETIME, PLN.PLAN_YYYYMMDD, 110) AS PLAN_YYYYMMDD
                        , PLN.MODEL_ID                              AS MODEL_ID
                        , PLN.ITEM_ID                               AS ITEM_ID
                        , PLN.PRODUCTION_TYPE                       AS PRODUCTION_TYPE
                        , MAX(PLN.MARKET)                           AS MARKET
                        , MAX(PLN.VERSION)                          AS VERSION
                        , MAX(PLN.PLM_EC_NO)                        AS PLM_EC_NO
                        , SUM(ISNULL(XLS.CELL_OUT_QTY, 0))          AS CELL_OUT_QTY
                        , MAX(PLN.ITEM_TYPE)                        AS ITEM_TYPE
                        , MAX(PLN.SEQ)                              AS SEQ
                        , MAX(PLN.CUSTOMER_ID)                      AS CUSTOMER_ID
                        , MAX(ISNULL(XLS.BOH_QTY, ''))              AS BOH_QTY
                        , MAX(PLN.NICK_NAME)                        AS NICK_NAME
                        , MAX(PLN.LINE_NAME)                        AS LINE_NAME
                        , MAX(PLN.OPERATION_NAME)                   AS OPERATION_NAME
                        , MAX(PLN.MODE)                             AS MODE
                        , MAX(PLN.KEYS_MODEL)                       AS KEYS_MODEL
                        , MAX(PLN.INSTANCE_ID2)                     AS INSTANCE_ID2
                        , MAX(PLN.ROWNUM)                           AS ROWNUM
                        , SUM(ISNULL(XLS.QTY, 0))                   AS QTY
                        , MAX(ISNULL(XLS.CRUD, ''))                 AS CRUD
                        , 'PROD_INSERT'                             AS INSERT_ID
                        , CURRENT_TIMESTAMP                         AS INSERT_TIME
                        , 'PROD_INSERT'                             AS UPDATE_ID
                        , CURRENT_TIMESTAMP                         AS UPDATE_TIME
                        , NULL                                      AS MEMO
						, MAX(XLS.WORKING_DAY)						AS WORKING_DAY
                FROM    #TMP_BUF_AMEND_PLAN_R_DUMMY PLN
                LEFT OUTER JOIN #TMP_BUF_AMEND_PLAN_R_XLS XLS
                    ON  XLS.INSTANCE_ID     = PLN.INSTANCE_ID
                    AND XLS.FP_PLAN_ID      = PLN.FP_PLAN_ID
                    AND XLS.COMPANY_ID      = PLN.COMPANY_ID
                    AND XLS.DIVISION_ID     = PLN.DIVISION_ID
                    AND XLS.CATEGORY_ID     = PLN.CATEGORY_ID
                    AND XLS.SITE_ID         = PLN.SITE_ID
                    AND XLS.PLANT_ID        = PLN.PLANT_ID
                    AND XLS.FACTORY_ID      = PLN.FACTORY_ID
                    AND XLS.LOCATION        = PLN.LOCATION
                    AND XLS.OPERATION_ID    = PLN.OPERATION_ID
                    AND XLS.LINE_ID         = PLN.LINE_ID
                    AND XLS.MODEL_ID        = PLN.MODEL_ID
                    AND XLS.ITEM_ID         = PLN.ITEM_ID
                    AND XLS.PRODUCTION_TYPE = PLN.PRODUCTION_TYPE
                    AND CONVERT(NVARCHAR, XLS.PLAN_DATE, 112) = PLN.PLAN_YYYYMMDD
                GROUP BY      PLN.INSTANCE_ID
                            , PLN.FP_PLAN_ID
                            , PLN.COMPANY_ID
                            , PLN.DIVISION_ID
                            , PLN.CATEGORY_ID
                            , PLN.SITE_ID
                            , PLN.PLANT_ID
                            , PLN.FACTORY_ID
                            , PLN.OPERATION_ID
                            , PLN.LINE_ID
                            , PLN.PLAN_YYYYMMDD
                            , PLN.MODEL_ID
                            , PLN.ITEM_ID
                            , PLN.PRODUCTION_TYPE
                ;

            IF OBJECT_ID('TEMPDB..#TMP_BUF_AMEND_PLAN_R_XLS') IS NOT NULL
                BEGIN 
                    DROP TABLE  #TMP_BUF_AMEND_PLAN_R_XLS;
                END;

            IF OBJECT_ID('TEMPDB..#TMP_BUF_AMEND_PLAN_R_DUMMY') IS NOT NULL
                BEGIN 
                    DROP TABLE  #TMP_BUF_AMEND_PLAN_R_DUMMY;
                END;
            -----------------------------------------------------------------------------
            -- 2025.09.24 Philsu Park: A8000의 경우, Calendar Join해서 전구간 확장 처리.
            -- END
            -----------------------------------------------------------------------------

            PRINT ('A8000 DUMMY END: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            PRINT ('PROD DELETE START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            DELETE  X
            FROM    BUF_AMEND_PLAN_R_XLS X
            WHERE   1=1
            AND     EXISTS (
                            SELECT  1
                            FROM    @TMP_BUF_AMEND_PLAN_R_XLS S
                            WHERE   S.INSTANCE_ID = X.INSTANCE_ID
                            AND     S.FP_PLAN_ID = X.FP_PLAN_ID
                            AND     X.OPERATION_ID = S.OPERATION_ID
                            -- WHERE   X.OPERATION_ID = S.OPERATION_ID
                            )
            ;

            -- select *
            -- from    @TMP_BUF_AMEND_PLAN_R_XLS
            -- ;

            PRINT ('PROD INSERT START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            INSERT INTO BUF_AMEND_PLAN_R_XLS
                (
                    INSTANCE_ID
                    , FP_PLAN_ID
                    , COMPANY_ID
                    , DIVISION_ID
                    , CATEGORY_ID
                    , SITE_ID
                    , PLANT_ID
                    , FACTORY_ID
                    , LOCATION
                    , OPERATION_ID
                    , LINE_ID
                    , ELECTRODE_TYPE
                    , EQUIPMENT_ID
                    , PLAN_DATE
                    , MODEL_ID
                    , ITEM_ID
                    , PRODUCTION_TYPE
                    , MARKET
                    , VERSION
                    , PLM_EC_NO
                    , CELL_OUT_QTY
                    , ITEM_TYPE
                    , SEQ
                    , CUSTOMER_ID
                    , BOH_QTY
                    , NICK_NAME
                    , LINE_NAME
                    , OPERATION_NAME
                    , MODE
                    , KEYS_MODEL
                    , INSTANCE_ID2
                    , ROWNUM
                    , QTY
                    , CRUD
                    , INSERT_ID
                    , INSERT_TIME
                    , UPDATE_ID
                    , UPDATE_TIME
                    , MEMO
					, WORKING_DAY
                )
                SELECT    INSTANCE_ID
                        , FP_PLAN_ID
                        , COMPANY_ID
                        , DIVISION_ID
                        , CATEGORY_ID
                        , SITE_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LOCATION
                        , OPERATION_ID
                        , LINE_ID
                        , ELECTRODE_TYPE
                        , EQUIPMENT_ID
                        , PLAN_DATE
                        , MODEL_ID
                        , ITEM_ID
                        , PRODUCTION_TYPE
                        , MARKET
                        , VERSION
                        , PLM_EC_NO
                        , ROUND(CELL_OUT_QTY,0)
                        , ITEM_TYPE
                        , SEQ
                        , CUSTOMER_ID
                        , BOH_QTY
                        , NICK_NAME
                        , LINE_NAME
                        , OPERATION_NAME
                        , MODE
                        , KEYS_MODEL
                        , INSTANCE_ID2
                        , ROWNUM
                        , ROUND(QTY,0)
                        , CRUD
                        , INSERT_ID + '::' + @V_PLAN_ID
                        , INSERT_TIME
                        , UPDATE_ID
                        , UPDATE_TIME
                        , MEMO
						, WORKING_DAY
                FROM    @TMP_BUF_AMEND_PLAN_R_XLS
                ;
        END

    IF @V_PLAN_GROUP_ID = 'GM1_A'
        BEGIN


            PRINT ('SHIP DELETE START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            -- 2025.10.15 Philsu Park: 다시 계획 없는 모델이 남아버리는 현상이 있어 일단 stage 단위로 게획수립일자 이후로 삭제 후 생성하는 걸로 적용.
            DELETE  X
            FROM    BUF_AMEND_PLAN_SSP_R_XLS X
            WHERE   1=1
            /* AND     EXISTS ( SELECT 1
                             FROM   @OPERATION_TEMP OP
                             WHERE  OP.STAGE = X.ATTRIBUTE2
                             AND    X.YYYYMMDD >= @V_PLAN_START_YYYYMMDD
                             ) */
            AND     EXISTS (
                            SELECT  1
                            FROM    SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN  OS WITH(NOLOCK)
                            INNER JOIN (
                                SELECT    PLAN_ID
                                        , FROM_BUFFER_ID
                                        , TO_BUFFER_ID
                                        , TRANSPORT_MODE
                                        , ATTRIBUTE3
                                        , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                                FROM    SCP_OPT_ENG_BOD_SN WITH(NOLOCK)
                                WHERE   PLAN_ID         = @V_PLAN_ID
                                AND     ATTRIBUTE8      = 'SALES'  -- CELLBIZ -> DEMAND GR로 보내는 출하는 제외
                                AND     ATTRIBUTE7     <> 'DUMMY' -- CELLBIZ -> DEMAND GR로 보내는 출하는 제외
                                AND     TRANSPORT_MODE != 'PALLET'
                                GROUP BY  PLAN_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, ATTRIBUTE3, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                                ) BOD
                                ON  OS.PLAN_ID          = BOD.PLAN_ID
                                AND OS.FROM_BUFFER_ID   = BOD.FROM_BUFFER_ID
                                AND OS.TO_BUFFER_ID     = BOD.TO_BUFFER_ID
                                AND OS.TRANSPORT_MODE   = BOD.TRANSPORT_MODE
                            WHERE   1=1
                            AND     OS.PLAN_ID      = @V_PLAN_ID
                            AND     BOD.ATTRIBUTE3  = X.ATTRIBUTE2
                            AND     X.MEASURE       = 'SHIP_REQ'
                            AND     X.YYYYMMDD     >= @V_PLAN_START_YYYYMMDD
                            )

            PRINT ('SHIP INSERT START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            INSERT INTO @TMP_BUF_AMEND_PLAN_SSP_R_XLS
                (
                      DIVISION_ID
                    , PROJECT_CODE   -- 최적화에 존재하는 정보로 그대로 넣으면 됨
                    , SCM_SITE_ID    -- to site
                    , ITEM_ID        -- 제품
                    , FCST_TYPE      -- MPS, AS, ASF 등 실제 값 입력 
                    , INCOTERMS      -- 
                    , TRANSPORT_MODE -- 
                    , BOD_ID         --
                    , MEASURE 
                    , PLANT_SITE_ID   -- from site 
                    , SITE_TYPE       -- [SCM_SITE_ID] SITE 유형
                    , YYYYMMDD 
                    , QTY
                    , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE
                    , JOB_USER_ID
                    , JOB_TIME
                    , JOB_TYPE    -- EXCEL
                    , JOB_SEQ     -- 1
                    , JOB_ORDER   -- NULL
                    , ATTRIBUTE2
                )
                SELECT    DIVISION_ID       AS DIVISION_ID
                        , PROJECT_CODE      AS PROJECT_CODE
                        , TO_SITE           AS SCM_SITE_ID
                        , ITEM_ID           AS ITEM_ID
                        , ISNULL(FCST_TYPE, 'MPS') AS FCST_TYPE
                        , INCOTERMS         AS INCOTERMS
                        , TRANSPORT_MODE    AS TRANSPORT_MODE
                        , BOD_ID            AS BOD_ID
                        , 'SHIP_REQ'        AS MEASURE
                        , FROM_SITE         AS PLANT_SITE_ID
                        , SITE_TYPE         AS SITE_TYPE
                        , YYYYMMDD          AS YYYYMMDD
                        , SUM(CONVERT(NUMERIC(30,10), QTY)) AS QTY
                        , 'SHIPMENT_INSERT' AS CREATED_BY
                        , CURRENT_TIMESTAMP AS CREATION_DATE
                        , 'SHIPMENT_INSERT' AS LAST_UPDATED_BY
                        , CURRENT_TIMESTAMP AS LAST_UPDATE_DATE
                        , 'SHIPMENT_INSERT' AS JOB_USER_ID
                        , CURRENT_TIMESTAMP AS JOB_TIME
                        , 'EXCEL'           AS JOB_TYPE
                        , 1                 AS JOB_SEQ
                        , NULL              AS JOB_ORDER
                        , MIN(STAGE)        AS STAGE
                FROM(
                    ------------------------------------------------------------------------
                    -- 2025.10.15 Philsu Park 
                    -- 1. BOD에서 DUMMY 는 제외하고 실제 출하 계획만 가져올 수 있게 반영.
                    -- 2. Scheduled Move의 경우 BOD_ID가 없기 때문에 From To Buffer + Transport Mode로 Join 처리.
                    ------------------------------------------------------------------------
                    SELECT   DIV.DIVISION_ID    AS DIVISION_ID
                            ,OS.ITEM_ID         AS ITEM_ID
                            ,OS.FROM_SITE_ID    AS FROM_SITE
                            ,OS.TO_SITE_ID      AS TO_SITE
                            ,OS.TRANSPORT_MODE  AS TRANSPORT_MODE
                            ,BOD.ATTRIBUTE7     AS BOD_ID
                            ,BOD.ATTRIBUTE6     AS INCOTERMS
                            ,OS.DEPARTURE_DATE  AS YYYYMMDD
                            ,OS.ARRIVAL_DATE    AS ARRIVAL_DATE
                            ,OS.QTY             AS QTY
                            ,TS.ATTRIBUTE2      AS PROJECT_CODE
                            ,DM.FCST_TYPE       AS FCST_TYPE
                            ,ST.SITE_TYPE       AS SITE_TYPE
                            ,BOD.ATTRIBUTE3     AS STAGE
                            --,@V_DIVISION_ID    AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                            --,@V_DIVISION_ID    AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                            --,NULL              AS ELECTRODE_TYPE
                            --,BOD.ATTRIBUTE8    AS BOD_TYPE
                    FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN  OS WITH(NOLOCK)
                    INNER JOIN @DIVISION DIV
                        ON  1=1
                    INNER JOIN SY_SCM_MST_SITE ST WITH(NOLOCK)
                        ON  ST.DIVISION_ID = DIV.DIVISION_ID
                        and ST.SCM_SITE_ID = OS.TO_SITE_ID
                    INNER JOIN (
                                SELECT    PLAN_ID
                                        , FROM_BUFFER_ID
                                        , TO_BUFFER_ID
                                        , TRANSPORT_MODE
                                        , ATTRIBUTE3
                                        , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                                FROM    SCP_OPT_ENG_BOD_SN WITH(NOLOCK)
                                WHERE   PLAN_ID         = @V_PLAN_ID
                                AND     ATTRIBUTE8      = 'SALES'  -- CELLBIZ -> DEMAND GR로 보내는 출하는 제외
                                AND     ATTRIBUTE7     <> 'DUMMY' -- CELLBIZ -> DEMAND GR로 보내는 출하는 제외
                                AND     TRANSPORT_MODE != 'PALLET'
                                GROUP BY  PLAN_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, ATTRIBUTE3, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                                ) BOD
                        ON  OS.PLAN_ID          = BOD.PLAN_ID
                        AND OS.FROM_BUFFER_ID   = BOD.FROM_BUFFER_ID
                        AND OS.TO_BUFFER_ID     = BOD.TO_BUFFER_ID
                        AND OS.TRANSPORT_MODE   = BOD.TRANSPORT_MODE
                    INNER JOIN SCP_OPT_ENG_PLAN_MASTER_SN PM WITH(NOLOCK)
                        ON  OS.PLAN_ID = PM.PLAN_ID
                    INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN FS WITH(NOLOCK)
                        ON  OS.PLAN_ID       = FS.PLAN_ID
                        AND OS.FROM_BUFFER_ID = FS.BUFFER_ID
                    INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN TS WITH(NOLOCK)
                        ON  OS.PLAN_ID      = TS.PLAN_ID
                        AND OS.TO_BUFFER_ID = TS.BUFFER_ID
                    LEFT OUTER JOIN (
                                        SELECT  BUFFER_ID, ATTRIBUTE8 AS FCST_TYPE
                                        FROM    SCP_OPT_ENG_DEMAND_SN TS WITH(NOLOCK)
                                        WHERE   PLAN_ID = @V_PLAN_ID
                                        GROUP BY BUFFER_ID, ATTRIBUTE8
                                    ) DM
                        ON  OS.TO_BUFFER_ID = DM.BUFFER_ID
                    WHERE 1=1
                    --AND BOD.ATTRIBUTE8 = 'PLANT'  --SALES는 FG에 넣고 PLANT만 SEMI에 넣으면 됨.
                    AND OS.PLAN_ID = @V_PLAN_ID
                ) A 
                WHERE 1=1
                -- AND   BOD_ID IS NOT NULL
                GROUP BY DIVISION_ID
                        ,PROJECT_CODE
                        ,ITEM_ID
                        ,ISNULL(FCST_TYPE, 'MPS')
                        ,INCOTERMS
                        ,TRANSPORT_MODE
                        ,BOD_ID
                        ,FROM_SITE
                        ,SITE_TYPE
                        ,YYYYMMDD
                        ,TO_SITE
            ;

            -- 2025.09.17 Philsu Park: NND 정수화 처리.
            UPDATE  S
            SET       S.QTY                 = ROUND(S.QTY / BOM.MAX_USAGE, 0)
                    , S.LAST_UPDATED_BY     = ISNULL(S.LAST_UPDATED_BY, '') + '/NND'
                    , S.LAST_UPDATE_DATE    = CURRENT_TIMESTAMP
            FROM    @TMP_BUF_AMEND_PLAN_SSP_R_XLS S
            INNER JOIN #BOM_NND BOM
                ON S.ITEM_ID = BOM.CHILD_ITEM_ID
            WHERE   S.ATTRIBUTE2 = 'NND'  -- NND Only.
            ;

            INSERT INTO BUF_AMEND_PLAN_SSP_R_XLS
                (
                      DIVISION_ID
                    , PROJECT_CODE   -- 최적화에 존재하는 정보로 그대로 넣으면 됨
                    , SCM_SITE_ID    -- to site
                    , ITEM_ID        -- 제품
                    , FCST_TYPE      -- MPS, AS, ASF 등 실제 값 입력 
                    , INCOTERMS      -- 
                    , TRANSPORT_MODE -- 
                    , BOD_ID         --
                    , MEASURE 
                    , PLANT_SITE_ID   -- from site 
                    , SITE_TYPE       -- [SCM_SITE_ID] SITE 유형
                    , YYYYMMDD 
                    , QTY
                    , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE
                    , JOB_USER_ID
                    , JOB_TIME
                    , JOB_TYPE    -- EXCEL
                    , JOB_SEQ     -- 1
                    , JOB_ORDER   -- NULL
                    , ATTRIBUTE2
                )
                SELECT  DIVISION_ID     
                       ,PROJECT_CODE    
                       ,SCM_SITE_ID     
                       ,ITEM_ID         
                       ,FCST_TYPE       
                       ,INCOTERMS       
                       ,TRANSPORT_MODE  
                       ,BOD_ID          
                       ,MEASURE         
                       ,PLANT_SITE_ID   
                       ,SITE_TYPE       
                       ,YYYYMMDD        
                       ,ROUND(QTY,0)
                       ,CREATED_BY      
                       ,CREATION_DATE   
                       ,LAST_UPDATED_BY 
                       ,LAST_UPDATE_DATE
                       ,JOB_USER_ID     
                       ,JOB_TIME        
                       ,JOB_TYPE        
                       ,JOB_SEQ         
                       ,JOB_ORDER       
                       ,ATTRIBUTE2 
                FROM    @TMP_BUF_AMEND_PLAN_SSP_R_XLS
            ;
                
        END 

        PRINT 'OK'
        SELECT 'OK' as ret, '' as msg;

    END TRY

    BEGIN CATCH
        SET @V_MESSAGE_TEXT = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        ------------------------------------------------------------------------
        -- EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'ERROR',NULL,@V_MESSAGE_TEXT,NULL,@V_PLAN_ID
        ------------------------------------------------------------------------
        -- SELECT @V_DETAIL_DATE = GETDATE()
        ------------------------------------------------------------------------
        -- EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,@V_DETAIL_DATE,NULL,@V_MESSAGE_TEXT,'ERROR'
        ------------------------------------------------------------------------
        PRINT 'NG'
        SELECT 'NG' as ret, @V_MESSAGE_TEXT as msg;        

        RAISERROR(@V_MESSAGE_TEXT, 16,1)
    END CATCH
    
  END;
