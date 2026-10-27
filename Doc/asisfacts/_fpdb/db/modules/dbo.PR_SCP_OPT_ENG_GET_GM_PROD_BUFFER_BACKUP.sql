
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GET_GM_PROD_BUFFER_BACKUP]
     @P_FP_PLAN_ID     NVARCHAR(50)
AS 
BEGIN

    SET ARITHABORT ON;
    SET ANSI_NULLS ON;
    SET QUOTED_IDENTIFIER ON;
	SET NOCOUNT ON;

	-------------------------------------------------------------------------------------
	-- SET Parameter
	-------------------------------------------------------------------------------------
    -- DECLARE @V_INSTANCE_ID              NVARCHAR(50) = @FP_INSTANCE_ID;
    -- DECLARE @V_PLAN_ID                  NVARCHAR(50) = @P_SCP_OPT_PLAN_ID;
    -- DECLARE @V_PLAN_TYPE                NVARCHAR(50) = @P_PLAN_TYPE;
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
    -------------------------------------------------------------------------------------
    -- 쿼리 속도 개선을 위한 임시테이블 생성 
    /* DECLARE @OPERATION_TEMP TABLE(
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
    ) */

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
        )

    BEGIN TRY

        BEGIN
            INSERT INTO @TMP_BUF_AMEND_PLAN_R_XLS
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
                FROM    BUF_AMEND_PLAN_R_XLS XLS WITH(NOLOCK)
                WHERE   EXISTS (
                                SELECT  1 
                                FROM    SCM_FP_PLAN_H AS X WITH(NOLOCK)
                                WHERE   X.INTG_PLAN_ID  = @P_FP_PLAN_ID
                                AND     X.INSTANCE_ID   = XLS.INSTANCE_ID
                                AND     X.PLAN_ID       = XLS.FP_PLAN_ID
                                )
                ;


            SELECT    CASE  WHEN OPERATION_ID    = 'A5000' THEN 'Notching'
                            WHEN OPERATION_ID    IN ('A7000','A8000') THEN 'L&S'
                            WHEN OPERATION_ID    = 'A9000' THEN 'PKG'
                            WHEN OPERATION_ID    = 'E2000' THEN 'Coating'
                            WHEN OPERATION_ID    = 'E3000' THEN 'R/P'
                            WHEN OPERATION_ID    = 'F6000' THEN 'EOL'
                            ELSE OPERATION_ID
                        END
                        + IIF(ELECTRODE_TYPE = '-','',' (' + ELECTRODE_TYPE + ')')
                        + REPLACE(CONCAT('#', SUBSTRING( LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
                        + RIGHT(NICK_NAME,3)
                        + FORMAT(PLAN_DATE,'yyyy-MM-dd')
                        + ITEM_ID
                        AS KEYS
                    , INSTANCE_ID
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
                    --, EQUIPMENT_ID
					, CASE WHEN EQUIPMENT_ID IS NULL THEN '-' ELSE EQUIPMENT_ID END AS EQUIPMENT_ID
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
                    --, MODE
					, CASE WHEN MODE IS NULL OR MODE = '' THEN '-' ELSE MODE END AS MODE
                    , CASE  WHEN OPERATION_ID    = 'A5000' THEN 'Notching'
                            WHEN OPERATION_ID    IN ('A7000','A8000') THEN 'L&S'
                            WHEN OPERATION_ID    = 'A9000' THEN 'PKG'
                            WHEN OPERATION_ID    = 'E2000' THEN 'Coating'
                            WHEN OPERATION_ID    = 'E3000' THEN 'R/P'
                            WHEN OPERATION_ID    = 'F6000' THEN 'EOL'
                            ELSE OPERATION_ID
                        END
                        + IIF(ELECTRODE_TYPE = '-','',' (' + ELECTRODE_TYPE + ')')
                        + REPLACE(CONCAT('#', SUBSTRING( LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
                        + RIGHT(NICK_NAME,3)
                        AS KEYS_MODEL
                    , INSTANCE_ID2
                    , row_number() over(partition by INSTANCE_ID
                                       order by INSTANCE_ID           
			                                 , FP_PLAN_ID 
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
                                        ) AS ROWNUM
                    , QTY
                    , CRUD
                    -- , INSERT_ID
                    -- , INSERT_TIME
                    -- , UPDATE_ID
                    -- , UPDATE_TIME
                    , NULL AS PREV_QTY
                    , MEMO
            FROM    @TMP_BUF_AMEND_PLAN_R_XLS
            ;
        END
        -------------------------------------------------------------------------------------
        -- Set Planning Info
        -------------------------------------------------------------------------------------
        /* SELECT  @V_PLAN_START_YYYYMMDD  = PLAN_START_DATE
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
        AND     P.CUTOFF_YYYYMMDD  = @V_DEMAND_CUTOFF_DAY */

        -------------------------------------------------------------------------------------
        -- 2025.08.28 Philsu Park
        -- PROD INSERT.
        -------------------------------------------------------------------------------------
        /* BEGIN

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
                )
                SELECT    OPR.INSTANCE_ID                           AS INSTANCE_ID
                        , OPR.FP_PLAN_ID                            AS FP_PLAN_ID
                        , ST.COMPANY_ID                             AS COMPANY_ID
                        , ST.DIVISION_ID                            AS DIVISION_ID
                        , 'PLAN'                                    AS CATEGORY_ID
                        , ST.PLANT_ID                               AS PLANT_ID
                        , '-'                                       AS LOCATION
                        , OPR.OPERATION_ID                          AS OPERATION_ID
                        , ISNULL(RE.ATTRIBUTE14, RE.ATTRIBUTE15)    AS LINE_ID
                        , OP.START_DATE                             AS PLAN_DATE
                        , OP.ITEM_ID                                AS ITEM_ID
                        , 'MASS'                                    AS PRODUCTION_TYPE
                        , 'D'                                       AS MARKET
                        , '-'                                       AS VERSION
                        , '-'                                       AS PLM_EC_NO
                        , SUM(CONVERT(NUMERIC(20,10), OP.OUT_QTY))  AS CELL_OUT_QTY
                        , '-'                                       AS ITEM_TYPE
                        , 1                                         AS SEQ
                        , '-'                                       AS CUSTOMER_ID
                        , ''                                        AS BOH_QTY
                        , MAX(OPR.OPERATION_NAME)                   AS OPERATION_NAME
                        , ''                                        AS MODE
                        , ''                                        AS KEYS_MODEL
                        , OPR.INSTANCE_ID                           AS INSTANCE_ID2
                        , NULL                                      AS ROWNUM
                        , SUM(CONVERT(NUMERIC(20,10), OP.OUT_QTY))  AS QTY      -- 최적화 계획 수량을 CELL로 환산해서 넣음. * 실제 테이블에 넣을 때 각 품목 UOM으로 환산해서 넣어야 한다.
                        , ''                                        AS CRUD     -- 공란으로 형성
                        , 'PROD_INSERT'
                        , CURRENT_TIMESTAMP
                        , NULL                                      AS MEMO   -- MEMO는 기존 값 보완하여 입력
                FROM    SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN OP WITH(NOLOCK)
                INNER JOIN ( 
                            SELECT    PRODUCTION_ORDER_ID
                                    , PRODUCTION_LINE_ID
                                    , PLAN_ID
                            FROM    SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_SN WITH(NOLOCK) 
                            WHERE   PLAN_ID = @V_PLAN_ID
                            GROUP BY PRODUCTION_ORDER_ID, PRODUCTION_LINE_ID, PLAN_ID
                            ) PG
                    ON  OP.PLAN_ID             = PG.PLAN_ID
                    AND OP.PRODUCTION_ORDER_ID = PG.PRODUCTION_ORDER_ID
                INNER JOIN SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)
                    ON  OP.PLAN_ID              = RE.PLAN_ID
                    AND PG.PRODUCTION_LINE_ID   = RE.RESOURCE_ID
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
                        , OP.SITE_ID, OP.ITEM_ID, OP.GRADE, OP.START_DATE, ISNULL(RE.ATTRIBUTE14, RE.ATTRIBUTE15)
                ;

            PRINT ('LINE MST UPDATE START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            UPDATE S
            SET       S.SITE_ID         = LM.SITE_ID
                    , S.FACTORY_ID      = LM.FACTORY_ID
                    , S.ELECTRODE_TYPE  = LM.ELECTRODE_TYPE
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

            UPDATE S
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
                    , S.QTY             = S.QTY * BOM.MAX_USAGE
                    , S.CELL_OUT_QTY    = S.CELL_OUT_QTY * BOM.MAX_USAGE
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

            UPDATE  S
            SET       S.QTY = S.QTY * BOM.MAX_USAGE
                    , S.CELL_OUT_QTY    = S.CELL_OUT_QTY * BOM.MAX_USAGE
                    , S.UPDATE_ID       = ISNULL(S.UPDATE_ID, '') + '/NND'
                    , S.UPDATE_TIME     = CURRENT_TIMESTAMP
            FROM    @TMP_BUF_AMEND_PLAN_R_XLS S
            INNER JOIN #BOM_NND BOM
                ON S.ITEM_ID = BOM.CHILD_ITEM_ID
            ;

            PRINT ('DAILY CAPA CALC START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            IF OBJECT_ID('TEMPDB..#CAPA') IS NOT NULL
                BEGIN 
                    DROP TABLE  #CAPA;
                END;

            SELECT    LK.SEGMENT3   AS PLANT_ID
                    -- , LK.SEGMENT4   AS PLANT_SITE_ID
                    , LK.SEGMENT5   AS OPERATION_ID
                    , LK.ATTRIBUTE1 AS LINE_ID
                    , LK.ATTRIBUTE2 AS ITEM_ID
                    , LK.ATTRIBUTE3 AS PLAN_YYYYMM
                    -- , LK.ATTRIBUTE4 AS TACT_TIME
                    , MAX(86400.0/LK.ATTRIBUTE4)   AS DAILY_QTY
            INTO    #CAPA
            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LK WITH(NOLOCK)
            WHERE   LK.LOOKUP_TYPE  = 'SCP_OPT_MASTER_CAPA_TEMP'
            AND     LK.VALID_YN     = 'Y'
            AND     LK.SEGMENT2     = @V_DIVISION_ID
            GROUP BY LK.SEGMENT3, LK.SEGMENT5, LK.ATTRIBUTE1, LK.ATTRIBUTE2, LK.ATTRIBUTE3

            /* WITH CAPA AS (
                SELECT    LK.SEGMENT3   AS PLANT_ID
                        -- , LK.SEGMENT4   AS PLANT_SITE_ID
                        , LK.SEGMENT5   AS OPERATION_ID
                        , LK.ATTRIBUTE1 AS LINE_ID
                        , LK.ATTRIBUTE2 AS ITEM_ID
                        , LK.ATTRIBUTE3 AS PLAN_YYYYMM
                        -- , LK.ATTRIBUTE4 AS TACT_TIME
                        , MAX(86400.0/LK.ATTRIBUTE4)   AS DAILY_QTY
                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LK WITH(NOLOCK)
                WHERE   LK.LOOKUP_TYPE  = 'SCP_OPT_MASTER_CAPA_TEMP'
                AND     LK.VALID_YN     = 'Y'
                AND     LK.SEGMENT2     = @V_DIVISION_ID
                GROUP BY LK.SEGMENT3, LK.SEGMENT5, LK.ATTRIBUTE1, LK.ATTRIBUTE2, LK.ATTRIBUTE3
                ) */
            UPDATE S
            SET       S.CELL_OUT_QTY = S.QTY/CP.DAILY_QTY
                    , S.UPDATE_ID       = ISNULL(S.UPDATE_ID, '') + '/CP'
                    , S.UPDATE_TIME     = CURRENT_TIMESTAMP
            FROM    @TMP_BUF_AMEND_PLAN_R_XLS S
            INNER JOIN SCM_SYS_CALENDAR_M_SN CM WITH(NOLOCK)
                ON  S.PLAN_DATE = CM.BASIS_DATE
            INNER JOIN #CAPA CP
                ON  CP.PLANT_ID     = S.PLANT_ID
                AND CP.OPERATION_ID = S.OPERATION_ID
                AND CP.LINE_ID      = S.LINE_ID
                AND CP.ITEM_ID      = S.ITEM_ID
                AND CP.PLAN_YYYYMM  = CM.BASIS_YYYYMM
            ;

            PRINT ('PROD DELETE START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            DELETE  X
            FROM    BUF_AMEND_PLAN_R_XLS X
            WHERE   1=1
            AND     EXISTS (
                            SELECT  1
                            FROM    @TMP_BUF_AMEND_PLAN_R_XLS S
                            WHERE   X.OPERATION_ID = S.OPERATION_ID
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
                FROM    @TMP_BUF_AMEND_PLAN_R_XLS
                ;
        END */

        /* BEGIN


            PRINT ('SHIP DELETE START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            DELETE  X
            FROM    BUF_AMEND_PLAN_SSP_R_XLS X
            WHERE   1=1
            AND     EXISTS (
                            SELECT  1
                            FROM    SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN  OS WITH(NOLOCK)
                            WHERE   1=1
                            AND     OS.PLAN_ID      = @V_PLAN_ID
                            AND     OS.ITEM_ID      = X.ITEM_ID
                            AND     OS.TO_SITE_ID   = X.SCM_SITE_ID
                            AND     X.MEASURE       = 'SHIP_REQ'
                            )

            PRINT ('SHIP INSERT START: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

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
                FROM(
                    SELECT   DIV.DIVISION_ID    AS DIVISION_ID
                            ,OS.ITEM_ID         AS ITEM_ID
                            ,OS.FROM_SITE_ID    AS FROM_SITE
                            ,OS.TO_SITE_ID      AS TO_SITE
                            ,OS.TRANSPORT_MODE  AS TRANSPORT_MODE
                            ,ISNULL(BOD.ATTRIBUTE7, BD.ATTRIBUTE7)     AS BOD_ID
                            ,ISNULL(BOD.ATTRIBUTE6, BD.ATTRIBUTE6)     AS INCOTERMS
                            ,OS.DEPARTURE_DATE  AS YYYYMMDD
                            ,OS.ARRIVAL_DATE    AS ARRIVAL_DATE
                            ,OS.QTY             AS QTY
                            ,TS.ATTRIBUTE2      AS PROJECT_CODE
                            ,DM.FCST_TYPE       AS FCST_TYPE
                            ,ST.SITE_TYPE       AS SITE_TYPE
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
                    INNER JOIN SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK)
                        ON  BOD.PLAN_ID = @V_PLAN_ID
                        AND OS.BOD_ID   = BOD.BOD_ID
                    INNER JOIN SCP_OPT_ENG_PLAN_MASTER_SN PM WITH(NOLOCK)
                        ON  OS.PLAN_ID = PM.PLAN_ID
                    INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN FS WITH(NOLOCK)
                        ON  OS.PLAN_ID       = FS.PLAN_ID
                        AND OS.FROM_BUFFER_ID = FS.BUFFER_ID
                    INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN TS WITH(NOLOCK)
                        ON  OS.PLAN_ID      = TS.PLAN_ID
                        AND OS.TO_BUFFER_ID = TS.BUFFER_ID
                    LEFT OUTER JOIN SCP_OPT_ENG_BOD_SN BD WITH(NOLOCK)
                        ON  BD.PLAN_ID = @V_PLAN_ID
                        AND OS.FROM_BUFFER_ID   = BD.TO_BUFFER_ID
                        and OS.TRANSPORT_MODE   = BD.TRANSPORT_MODE
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
        END  */
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
        RAISERROR(@V_MESSAGE_TEXT, 16,1)
    END CATCH
    /* 
	-------------------------------------------------------------------------------------
	IF @V_PLAN_TYPE = 'PRODUCTION'
	-------------------------------------------------------------------------------------
    BEGIN
        SELECT SITE_ID
              ,ITEM_ID
              ,GRADE
              ,PLAN_DATE
              ,LINE_ID
              ,OUT_QTY
              ,LV.OPERATION_ID
        FROM(
             SELECT  OP.SITE_ID										AS SITE_ID
             		,OP.ITEM_ID										AS ITEM_ID
             		,OP.GRADE										AS GRADE
             		,OP.START_DATE									AS PLAN_DATE
             		,ISNULL(RE.ATTRIBUTE14, RE.ATTRIBUTE15)			AS LINE_ID
                    ,SIS.STAGE                                      AS STAGE
             		--,LV.OPERATION_ID								AS OPERATION_ID
             		,SUM(CONVERT(NUMERIC(20,10), OP.OUT_QTY))   AS OUT_QTY
             FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN OP WITH(NOLOCK) 
             	LEFT OUTER JOIN ( SELECT PRODUCTION_ORDER_ID 
             							,PRODUCTION_LINE_ID
             							,PLAN_ID
             					FROM   SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_SN WITH(NOLOCK) 
             					WHERE  PLAN_ID = @V_PLAN_ID
             					GROUP BY PRODUCTION_ORDER_ID, PRODUCTION_LINE_ID, PLAN_ID
             					) PG
             		ON  OP.PLAN_ID             = PG.PLAN_ID 
             		AND OP.PRODUCTION_ORDER_ID = PG.PRODUCTION_ORDER_ID
             	INNER JOIN SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)
             		ON  OP.PLAN_ID = RE.PLAN_ID
             		AND PG.PRODUCTION_LINE_ID = RE.RESOURCE_ID
             	INNER JOIN SCP_OPT_ENG_PLAN_MASTER_SN PM WITH(NOLOCK)
             		ON  OP.PLAN_ID = PM.PLAN_ID
             	INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
             		ON  OP.PLAN_ID = SIS.PLAN_ID
             		AND OP.PRODUCED_BUFFER_ID = SIS.BUFFER_ID

             WHERE OP.PLAN_ID = @V_PLAN_ID
             AND   PG.PLAN_ID IS NOT NULL
             GROUP BY OP.SITE_ID,OP.ITEM_ID,OP.GRADE,OP.START_DATE,ISNULL(RE.ATTRIBUTE14, RE.ATTRIBUTE15),SIS.STAGE
             	--,LV.OPERATION_ID
             ) OP
             	LEFT OUTER JOIN @OPERATION_TEMP LV
             	    ON  @V_DIVISION_ID   = LV.DIVISION_ID -- DIVISION
             	    AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP -- PLAN GR
             	    AND OP.STAGE	     = LV.STAGE 
    END

	-------------------------------------------------------------------------------------
	ELSE IF @V_RESULT_TYPE = 'SHIPMENT'   
	-------------------------------------------------------------------------------------
    BEGIN
        SELECT ITEM_ID
              ,FROM_SITE
              ,TO_SITE
              ,BOD_ID
			  ,TRANSPORT_MODE
			  ,INCOTERMS
			  ,DEPARTURE_DATE
			  ,ARRIVAL_DATE
              ,SUM(CONVERT(NUMERIC(30,10), QTY)) AS SHIP_QTY
        FROM(
            SELECT OS.ITEM_ID         AS ITEM_ID
                  ,OS.FROM_SITE_ID    AS FROM_SITE
                  ,OS.TO_SITE_ID      AS TO_SITE
                  ,OS.TRANSPORT_MODE  AS TRANSPORT_MODE
                  ,BOD.ATTRIBUTE7     AS BOD_ID
                  ,BOD.ATTRIBUTE6     AS INCOTERMS
				  ,OS.DEPARTURE_DATE  AS DEPARTURE_DATE 
				  ,OS.ARRIVAL_DATE    AS ARRIVAL_DATE 
                  ,OS.QTY             AS QTY
                  --,@V_DIVISION_ID    AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                  --,@V_DIVISION_ID    AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                  --,NULL              AS ELECTRODE_TYPE
                  --,BOD.ATTRIBUTE8    AS BOD_TYPE
            FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN  OS WITH(NOLOCK)
                INNER JOIN SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK) 
                    ON  BOD.PLAN_ID = @V_PLAN_ID
                    AND OS.BOD_ID   = BOD.BOD_ID
        	    INNER JOIN SCP_OPT_ENG_PLAN_MASTER_SN PM WITH(NOLOCK)
        	    	ON  OS.PLAN_ID = PM.PLAN_ID
        	    INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN FS WITH(NOLOCK)
        	    	ON  OS.PLAN_ID       = FS.PLAN_ID
        	    	AND OS.FROM_BUFFER_ID = FS.BUFFER_ID
        	    INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN TS WITH(NOLOCK)
        	    	ON  OS.PLAN_ID      = TS.PLAN_ID
        	    	AND OS.TO_BUFFER_ID = TS.BUFFER_ID
            WHERE 1=1
            --AND BOD.ATTRIBUTE8 = 'PLANT'  --SALES는 FG에 넣고 PLANT만 SEMI에 넣으면 됨.
            AND OS.PLAN_ID = @V_PLAN_ID
        ) A 
		WHERE 1=1
		AND   BOD_ID IS NOT NULL
        GROUP BY ITEM_ID
				,FROM_SITE
				,TO_SITE
				,BOD_ID
				,TRANSPORT_MODE
				,INCOTERMS
				,DEPARTURE_DATE
				,ARRIVAL_DATE
    END
	
	-------------------------------------------------------------------------------------
	ELSE IF @V_RESULT_TYPE = 'ALL'   
        -------------------------------------------------------------------------------------
        -- PRODUCTION RESULT
        -------------------------------------------------------------------------------------
        --PRINT 'Prod Result Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        INSERT INTO @RESULT_TEMP
        -------------------------------------------------------------------------------------
        SELECT  'PRODUCTION_RESULT'						AS TYPE
            ,SMS.SCM_SITE_ID							AS SCM_SITE_ID
            ,PRLT.ITEM_ID								AS ITEM_ID
            ,OT.STAGE									AS STAGE
            ,CONVERT(NVARCHAR,PRLT.PLAN_DATE,112)		AS PRODUCTION_DATE
            ,PRLT.LINE_ID								AS LINE_ID
            ,SUM(PRLT.PLAN_QTY)						AS QTY
            ,PRLT.OPERATION_ID						AS OPEARATION_ID
            ,''										AS FROM_SITE
            ,''										AS TO_SITE
            ,''										AS BOD_ID
            ,''										AS TRANSPORT_MODE
            ,''										AS INCOTERMS
            ,''										AS DEPARTURE_DATE
            ,''										AS ARRIVAL_DATE
        FROM    IF_FP_RELEASE_PLAN_V PRLT WITH(NOLOCK)
                LEFT OUTER JOIN @OPERATION_TEMP OT
                    ON PRLT.OPERATION_ID = OT.OPERATION_ID
                INNER JOIN @DIVISION DIV 
                    ON PRLT.DIVISION_ID = DIV.DIVISION_ID
                LEFT OUTER JOIN SY_SCM_MST_SITE SMS WITH(NOLOCK)
                    ON  PRLT.DIVISION_ID = SMS.DIVISION_ID
                    AND PRLT.PLANT_ID    = SMS.PLANT_ID
        WHERE   1=1
        AND     PRLT.PLAN_QTY            >  0   
        AND     PRLT.PLAN_DATE           >= @V_PLAN_START_MONTH_DAY
        AND     PRLT.PLAN_DATE           <  @V_PLAN_START_YYYYMMDD
        AND     PRLT.ITEM_ID             IN (SELECT DISTINCT ITEM_ID
                                            FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                            WHERE  PLAN_ID = @V_PLAN_ID
                                            )
        AND     PRLT.LINE_ID IN (SELECT DISTINCT ATTRIBUTE15
                                FROM    SCP_OPT_ENG_RESOURCE_SN WITH(NOLOCK)
                                WHERE   PLAN_ID			= @V_PLAN_ID
                                AND     RESOURCE_TYPE	= 'LINE'
                                )
        GROUP BY SMS.SCM_SITE_ID, PRLT.ITEM_ID, OT.STAGE, PRLT.PLAN_DATE, PRLT.LINE_ID, PRLT.OPERATION_ID						
        -------------------------------------------------------------------------------------
        --PRINT 'Prod Result End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        --PRINT 'Prod Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        -- PRODUCTION PLAN
        -------------------------------------------------------------------------------------
        INSERT INTO @RESULT_TEMP
        -------------------------------------------------------------------------------------
        SELECT 'PRODUCTION_PLAN'        AS TYPE
            ,PLN.SITE_ID				AS SITE_ID
            ,PLN.ITEM_ID				AS ITEM_ID
            ,PLN.STAGE				AS STAGE
            ,PLN.PRODUCTION_DATE		AS PRODUCTION_DATE
            ,PLN.LINE_ID				AS LINE_ID
            ,PLN.QTY					AS QTY
            ,LV.OPERATION_ID			AS OPEARATION_ID
            ,''						AS FROM_SITE
            ,''						AS TO_SITE
            ,''						AS BOD_ID
            ,''						AS TRANSPORT_MODE
            ,''						AS INCOTERMS
            ,''						AS DEPARTURE_DATE
            ,''						AS ARRIVAL_DATE
        FROM(
            SELECT   OP.SITE_ID										AS SITE_ID
                    ,OP.ITEM_ID										AS ITEM_ID
                    ,OP.GRADE										AS GRADE
                    ,OP.START_DATE									AS PRODUCTION_DATE
                    ,ISNULL(RE.ATTRIBUTE14, RE.ATTRIBUTE15)			AS LINE_ID
                    ,SIS.STAGE                                      AS STAGE
                    --,LV.OPERATION_ID								AS OPERATION_ID
                    ,SUM(CONVERT(NUMERIC(20,10), OP.OUT_QTY))		AS QTY
                FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN OP WITH(NOLOCK) 
                LEFT OUTER JOIN ( SELECT PRODUCTION_ORDER_ID 
                                        ,PRODUCTION_LINE_ID
                                        ,PLAN_ID
                                FROM   SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_SN WITH(NOLOCK) 
                                WHERE  PLAN_ID = @V_PLAN_ID
                                GROUP BY PRODUCTION_ORDER_ID, PRODUCTION_LINE_ID, PLAN_ID
                                ) PG
                    ON  OP.PLAN_ID             = PG.PLAN_ID 
                    AND OP.PRODUCTION_ORDER_ID = PG.PRODUCTION_ORDER_ID
                INNER JOIN SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)
                    ON  OP.PLAN_ID = RE.PLAN_ID
                    AND PG.PRODUCTION_LINE_ID = RE.RESOURCE_ID
                INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                    ON  OP.PLAN_ID = SIS.PLAN_ID
                    AND OP.PRODUCED_BUFFER_ID = SIS.BUFFER_ID
                WHERE OP.PLAN_ID = @V_PLAN_ID
                AND   PG.PLAN_ID IS NOT NULL
                GROUP BY OP.SITE_ID, OP.ITEM_ID, OP.GRADE, OP.START_DATE, ISNULL(RE.ATTRIBUTE14, RE.ATTRIBUTE15), SIS.STAGE
                --,LV.OPERATION_ID
                ) PLN
                LEFT OUTER JOIN @OPERATION_TEMP LV
                    ON  @V_DIVISION_ID   = LV.DIVISION_ID -- DIVISION
                    AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP -- PLAN GR
                    AND PLN.STAGE	     = LV.STAGE 
        -------------------------------------------------------------------------------------
        --PRINT 'Prod Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        --PRINT 'Ship Result Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        -- SHIPMENT RESULT
        -------------------------------------------------------------------------------------
        INSERT INTO @RESULT_TEMP
        -------------------------------------------------------------------------------------
        SELECT 'SHIPMENT_RESULT'					AS TYPE
            ,SSP.FROM_SITE						AS SCM_SITE_ID
            ,SSP.ITEM_ID							AS ITEM_ID
            ,SIS.STAGE							AS STAGE
            ,''									AS PRODUCTION_dATE
            ,''									AS LINE_ID
            ,SUM(SSP.QTY)							AS QTY
            ,''									AS OPERATION_ID
            ,SSP.FROM_SITE						AS FROM_SITE
            ,SSP.TO_SITE							AS TO_SITE
            ,SSP.BOD_ID							AS BOD_ID
            ,SSP.TRANSPORT_MODE					AS TRANSPORT_MODE
            ,SSP.INCOTERMS						AS INCOTERMS
            ,SSP.YYYYMMDD							AS DEPARTURE_DATE
            ,CONVERT(NVARCHAR,SSP.ETA_DATE,112)	AS ARRIVAL_DATE
        FROM   SCM_DNM_SSP_PLAN_V_SN SSP WITH(NOLOCK)
            INNER JOIN @DIVISION DIV 
                ON SSP.DIVISION_ID = DIV.DIVISION_ID
            LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                ON   PLAN_ID = @V_PLAN_ID
                AND  SIS.SITE_ID = SSP.FROM_SITE
                AND  SIS.ITEM_ID = SSP.ITEM_ID
        WHERE  SSP.YYYYMMDD		>= @V_PLAN_START_MONTH_DAY
        AND    SSP.YYYYMMDD     <  @V_PLAN_START_YYYYMMDD
        AND    SSP.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                WHERE  PLAN_ID = @V_PLAN_ID
                                )
        GROUP BY SSP.FROM_SITE, SSP.ITEM_ID, SIS.STAGE, SSP.FROM_SITE, SSP.TO_SITE, SSP.BOD_ID, SSP.TRANSPORT_MODE, SSP.INCOTERMS, SSP.YYYYMMDD, SSP.ETA_DATE
        -------------------------------------------------------------------------------------
        --PRINT 'Ship Result End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        --PRINT 'Ship Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        -- SHIPMENT PLAN
        -------------------------------------------------------------------------------------
        INSERT INTO @RESULT_TEMP
        -------------------------------------------------------------------------------------
        SELECT 'SHIPMENT_PLAN'						AS TYPE
            ,SITE_ID								AS SITE_ID
            ,ITEM_ID								AS ITEM_ID
            ,STAGE								AS STAGE
            ,''									AS PRODUCTION_dATE
            ,''									AS LINE_ID
            ,SUM(CONVERT(NUMERIC(30,10), QTY))	AS QTY
            ,''									AS OPERATION_ID
            ,FROM_SITE							AS FROM_SITE
            ,TO_SITE								AS TO_SITE	
            ,BOD_ID								AS BOD_ID
            ,TRANSPORT_MODE						AS TRANSPORT_MODE
            ,INCOTERMS							AS INCOTERMS
            ,DEPARTURE_DATE						AS DEPARTURE_DATE
            ,ARRIVAL_DATE							AS ARRIVAL_DATE
        FROM(
            SELECT   FS.SITE_ID         AS SITE_ID
                    ,OS.ITEM_ID         AS ITEM_ID
                    ,FS.STAGE			AS STAGE
                    ,OS.FROM_SITE_ID    AS FROM_SITE
                    ,OS.TO_SITE_ID      AS TO_SITE
                    ,OS.TRANSPORT_MODE  AS TRANSPORT_MODE
                    ,BOD.ATTRIBUTE7     AS BOD_ID
                    ,BOD.ATTRIBUTE6     AS INCOTERMS
                    ,OS.DEPARTURE_DATE  AS DEPARTURE_DATE 
                    ,OS.ARRIVAL_DATE    AS ARRIVAL_DATE 
                    ,OS.QTY             AS QTY
            FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN  OS WITH(NOLOCK)
                INNER JOIN SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK) 
                    ON  BOD.PLAN_ID = @V_PLAN_ID
                    AND OS.BOD_ID   = BOD.BOD_ID
                INNER JOIN SCP_OPT_ENG_PLAN_MASTER_SN PM WITH(NOLOCK)
                    ON  OS.PLAN_ID = PM.PLAN_ID
                INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN FS WITH(NOLOCK)
                    ON  OS.PLAN_ID       = FS.PLAN_ID
                    AND OS.FROM_BUFFER_ID = FS.BUFFER_ID
                INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN TS WITH(NOLOCK)
                    ON  OS.PLAN_ID      = TS.PLAN_ID
                    AND OS.TO_BUFFER_ID = TS.BUFFER_ID
            WHERE 1=1
            AND OS.PLAN_ID = @V_PLAN_ID
        ) A 
        WHERE 1=1
        AND   BOD_ID IS NOT NULL
        GROUP BY SITE_ID, ITEM_ID, STAGE, FROM_SITE, TO_SITE, BOD_ID, TRANSPORT_MODE, INCOTERMS ,DEPARTURE_DATE ,ARRIVAL_DATE
        -------------------------------------------------------------------------------------
        --PRINT 'Ship Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        --PRINT 'FCSST Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        -- MKTFCST PLAN
        -------------------------------------------------------------------------------------
        INSERT INTO @RESULT_TEMP
        -------------------------------------------------------------------------------------
        SELECT 'MKTFCST'		AS TYPE
            ,A.SCM_SITE_ID	AS SCM_SITE_ID
            ,A.ITEM_ID		AS ITEM_ID
            ,SIS.STAGE		AS STAGE 
            ,A.YYYYMMDD		AS PRODUCTION_DATE
            ,''				AS LINE_ID
            ,SUM(A.QTY)		AS QTY
            ,''				AS OPERATION_ID
            ,''				AS FROM_SITE
            ,''				AS TO_STE
            ,''				AS BOD_ID
            ,''				AS TRANSPORT_MODE
            ,A.INCOTERMS		AS INCOTERMS
            ,''				AS DEPARTURE_DATE
            ,''				AS ARRIVAL_DATE
        FROM DM_PLN_NET_DEMAND_SN A WITH (NOLOCK)
            LEFT JOIN ( SELECT   SEGMENT2   AS DIVISION_ID
                                , SEGMENT3   AS SCM_SITE_ID
                                , SEGMENT4   AS ITEM_ID
                                , SEGMENT5   AS GROUP_ID
                                , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                                    ELSE ATTRIBUTE2
                                END AS START_DATE  -- PLAN 제외 시작일자
                                , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                                    ELSE ATTRIBUTE3
                                END AS END_DATE  -- PLAN 제외 끝일자
                        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LV WITH(NOLOCK)
                        WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                        AND    VALID_YN    = 'Y'
                        AND    SEGMENT2    = @V_DIVISION_ID
                        AND    SEGMENT5    = @V_PLAN_GROUP_ID
                        ) DE
                ON  A.SCM_SITE_ID   = DE.SCM_SITE_ID
                AND A.ITEM_ID       = DE.ITEM_ID
            LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIS WITH(NOLOCK)
                ON   PLAN_ID = @V_PLAN_ID
                AND  SIS.SITE_ID = A.SCM_SITE_ID
                AND  SIS.ITEM_ID = A.ITEM_ID
        ------------------------------------------------------------------------
            WHERE 1=1
            AND A.CUTOFF_YYYYMMDD   =  @V_DEMAND_CUTOFF_DAY
            AND A.VERSION_NO        =  @V_DM_MAX_VERSION
            AND A.ATTRIBUTE1        >= @V_PLAN_START_YYYYMMDD
            AND A.ATTRIBUTE1        <  @V_PLAN_END_YYYYMMDD
            AND A.QTY               >  0
            AND (ISNULL(DE.ITEM_ID, '') = ''
                OR (ISNULL(DE.ITEM_ID, '') <> '' AND (A.ATTRIBUTE1 < DE.START_DATE OR A.ATTRIBUTE1 > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
                )
            AND  A.ITEM_ID IN (SELECT DISTINCT ITEM_ID 
                                FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                            WHERE   PLAN_ID = @V_PLAN_ID
                                )
            GROUP BY  A.SCM_SITE_ID, A.ITEM_ID, SIS.STAGE, A.YYYYMMDD, A.INCOTERMS
        -------------------------------------------------------------------------------------
        --PRINT 'FKTFCST Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        --PRINT 'INVENTORY Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        -- INVENTORY
        -------------------------------------------------------------------------------------
        INSERT INTO @RESULT_TEMP
        -------------------------------------------------------------------------------------
        SELECT 'INVENTORY'		AS TYPE
            ,ATTRIBUTE1		AS SCM_SITE_ID
            ,ATTRIBUTE2		AS ITEM_ID
            ,ATTRIBUTE3		AS STAGE
            ,EFFECTIVE_DATE  AS PRODUCTION_DATE
            ,''				AS LINE_ID
            ,QUANTITY		AS QTY
            ,LV.OPERATION_ID AS OPERATION_ID
            ,''				AS FROM_SITE
            ,''				AS TO_SITE
            ,''				AS BOD_ID
            ,''				AS TRANSPRT_MODE
            ,''				AS INCOTERMS 
            ,''				AS DEPARTURE_DATE
            ,''				AS ARRIVAL_DATE
        FROM   SCP_OPT_ENG_INCOMING_STOCK_SN EIS WITH(NOLOCK)
                LEFT OUTER JOIN @OPERATION_TEMP LV
                    ON  @V_DIVISION_ID   = LV.DIVISION_ID -- DIVISION
                    AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP -- PLAN GR
                    AND EIS.ATTRIBUTE3	 = LV.STAGE 
        WHERE  PLAN_ID		= @V_PLAN_ID
        AND    ATTRIBUTE3	NOT IN ( 'MATERIAL_CONST','TRAY','-'  )
        -------------------------------------------------------------------------------------
        --PRINT 'INVENTORY Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        --PRINT 'TACT_TIME Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        -- TACT_TIME
        -------------------------------------------------------------------------------------
        INSERT INTO @RESULT_TEMP
        -------------------------------------------------------------------------------------
        SELECT   DISTINCT 
                'TACT_TIME'			AS TYPE 
                ,ERR.ATTRIBUTE1		AS SCM_SITE_ID
                ,ERR.ATTRIBUTE2		AS ITEM_ID
                ,ERR.ATTRIBUTE3		AS STAGE
                ,ERR.ATTRIBUTE14	AS PRODUCTION_DATE
                ,ERR.ATTRIBUTE15	AS LINE_ID
                ,ERR.LOAD_PER		AS QTY
                ,LV.OPERATION_ID	AS OPERATION_ID
                ,''					AS FROM_SITE
                ,''					AS TO_SITE
                ,''					AS BOD_ID
                ,''					AS TRANSPRT_MODE
                ,''					AS INCOTERMS 
                ,''					AS DEPARTURE_DATE
                ,''					AS ARRIVAL_DATE
        FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN ERR WITH(NOLOCK)
                LEFT OUTER JOIN @OPERATION_TEMP LV
                    ON  @V_DIVISION_ID   = LV.DIVISION_ID
                    AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP
                    AND ERR.ATTRIBUTE3	 = LV.STAGE 
        WHERE  ERR.PLAN_ID			 = @V_PLAN_ID
        AND    ERR.RESOURCE_CLASS_ID = 'LINE'
        -------------------------------------------------------------------------------------
        --PRINT 'TACT_TIME Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        --PRINT 'YIELD Plan Start : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------
        -- YIELD
        -------------------------------------------------------------------------------------
        INSERT INTO @RESULT_TEMP
        -------------------------------------------------------------------------------------
        SELECT  DISTINCT 
                'YIELD'			AS TYPE 
                ,ER.ATTRIBUTE1		AS SCM_SITE_ID
                ,ER.ATTRIBUTE2		AS ITEM_ID
                ,ER.ATTRIBUTE3		AS STAGE
                ,ER.ATTRIBUTE14		AS PRODUCTION_DATE
                ,ER.ATTRIBUTE15		AS LINE_ID
                ,ER.YIELD			AS QTY
                ,LV.OPERATION_ID	AS OPERATION_ID
                ,''					AS FROM_SITE
                ,''					AS TO_SITE
                ,''					AS BOD_ID
                ,''					AS TRANSPRT_MODE
                ,''					AS INCOTERMS 
                ,''					AS DEPARTURE_DATE
                ,''					AS ARRIVAL_DATE
        FROM   SCP_OPT_ENG_ROUTING_SN ER WITH(NOLOCK)
            LEFT OUTER JOIN @OPERATION_TEMP LV
                    ON  @V_DIVISION_ID   = LV.DIVISION_ID 
                    AND @V_PLAN_GROUP_ID = LV.PLAN_GROUP
                    AND ER.ATTRIBUTE3	 = LV.STAGE 
        WHERE  ER.PLAN_ID     = @V_PLAN_ID
        AND    ER.ATTRIBUTE3  NOT IN ( 'MATERIAL_CONST','TRAY','-'  )
        -------------------------------------------------------------------------------------
        --PRINT 'YIELD Plan End : '+ CONVERT(NVARCHAR,GETDATE(), 120)
        -------------------------------------------------------------------------------------


	-------------------------------------------------------------------------------------
	-- Final Select
	-------------------------------------------------------------------------------------
	SELECT   TYPE			
			,SCM_SITE_ID	
			,ITEM_ID		
			,STAGE			
			,PRODUCTION_DATE
			,LINE_ID		
			,QTY			
			,OPERATION_ID	
			,FROM_SITE		
			,TO_SITE		
			,BOD_ID			
			,TRANSPORT_MODE	
			,INCOTERMS		
	        ,DEPARTURE_DATE	
		    ,ARRIVAL_DATE	
	FROM   @RESULT_TEMP
	-------------------------------------------------------------------------------------
    */
  END;
