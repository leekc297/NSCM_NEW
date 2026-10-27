
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_GET_GM_PROD_BUFFER]
     @P_FP_PLAN_ID     NVARCHAR(50)
    ,@P_GM_A_PLAN_ID     NVARCHAR(50)
    ,@P_GM_E_PLAN_ID     NVARCHAR(50)
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
    DECLARE @V_GM_A_DIVISION_ID         NVARCHAR(50)
    DECLARE @V_GM_A_PLAN_START_YYYYMMDD NVARCHAR(8)
    DECLARE @V_GM_A_PLAN_END_YYYYMMDD   NVARCHAR(8)
    DECLARE @V_GM_A_PLAN_GROUP_ID       NVARCHAR(8)
    DECLARE @V_GM_E_DIVISION_ID         NVARCHAR(50)
    DECLARE @V_GM_E_PLAN_START_YYYYMMDD NVARCHAR(8)
    DECLARE @V_GM_E_PLAN_END_YYYYMMDD   NVARCHAR(8)
    DECLARE @V_GM_E_PLAN_GROUP_ID       NVARCHAR(8)

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
            --,ROWNUM	            NUMERIC(20, 10)
            ,QTY	            NUMERIC(20, 10)
            ,CRUD	            NVARCHAR(150)
            --,INSERT_ID          NVARCHAR(150)
            --,INSERT_TIME        DATETIME
            --,UPDATE_ID          NVARCHAR(150)
            --,UPDATE_TIME        DATETIME
            ,MEMO	            NVARCHAR(700)
			,WORKING_DAY 		NUMERIC(20, 10)
            ,XLS_YN NVARCHAR(10) -- added 2025-11-10
        )

    --GM_A INFORMATION
    SELECT  @V_GM_A_DIVISION_ID         = ATTRIBUTE1
           ,@V_GM_A_PLAN_GROUP_ID       = ATTRIBUTE2
           ,@V_GM_A_PLAN_START_YYYYMMDD = PLAN_START_DATE
           ,@V_GM_A_PLAN_END_YYYYMMDD   = PLAN_END_DATE
    FROM    SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK) 
    WHERE   PLAN_ID = @P_GM_A_PLAN_ID
    --GM_E INFORMATION
    SELECT  @V_GM_E_DIVISION_ID         = ATTRIBUTE1
           ,@V_GM_E_PLAN_GROUP_ID       = ATTRIBUTE2
           ,@V_GM_E_PLAN_START_YYYYMMDD = PLAN_START_DATE
           ,@V_GM_E_PLAN_END_YYYYMMDD   = PLAN_END_DATE
    FROM    SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK) 
    WHERE   PLAN_ID = @P_GM_E_PLAN_ID

    BEGIN TRY

        BEGIN
            ---------------------------------------------------------
            -- 2025.09.24 Philsu Park: 0보다 큰 대상만 조회하면 dummy 빠지니까 제약조건 주석처리.
            ---------------------------------------------------------
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
                        --, ROWNUM
                        , QTY
                        , CRUD
                        --, INSERT_ID
                        --, INSERT_TIME
                        --, UPDATE_ID
                        --, UPDATE_TIME
                        , MEMO
						, WORKING_DAY
                        , XLS_YN -- added 2025-11-10
                    )
            -- 조립 LINE/날짜 펼쳐서 SELECT
            SELECT  BS.INSTANCE_ID
                   ,BS.FP_PLAN_ID
                   ,BS.COMPANY_ID
                   ,BS.DIVISION_ID
                   ,BS.CATEGORY_ID
                   ,BS.SITE_ID
                   ,BS.PLANT_ID
                   ,BS.FACTORY_ID
                   ,BS.LOCATION
                   ,BS.OPERATION_ID
                   ,BS.LINE_ID
                   ,BS.ELECTRODE_TYPE
                   ,BS.EQUIPMENT_ID
                   ,BS.PLAN_DATE
                   ,BS.MODEL_ID
                   ,BS.ITEM_ID
                   ,BS.PRODUCTION_TYPE
                   ,BS.MARKET
                   ,BS.VERSION
                   ,BS.PLM_EC_NO
                   ,IIF(BS.PLAN_DATE = XLS.PLAN_DATE,XLS.CELL_OUT_QTY,0) AS CELL_OUT_QTY
                   ,BS.ITEM_TYPE
                   ,BS.SEQ
                   ,BS.CUSTOMER_ID
                   ,BS.BOH_QTY
                   ,BS.NICK_NAME
                   ,BS.LINE_NAME
                   ,BS.OPERATION_NAME
                   ,BS.MODE
                   ,BS.KEYS_MODEL
                   ,BS.INSTANCE_ID2
                   ,IIF(BS.PLAN_DATE = XLS.PLAN_DATE,XLS.QTY,0) AS QTY
                   ,BS.CRUD
                   ,BS.MEMO
				   ,IIF(BS.PLAN_DATE = XLS.PLAN_DATE,XLS.WORKING_DAY,0) AS WORKING_DAY
                   ,ISNULL(XLS.XLS_YN, BS.XLS_YN) AS XLS_YN -- added 2025-11-10
            FROM(
                SELECT  BS.INSTANCE_ID
                       ,BS.FP_PLAN_ID
                       ,BS.COMPANY_ID
                       ,BS.DIVISION_ID
                       ,BS.CATEGORY_ID
                       ,BS.SITE_ID
                       ,BS.PLANT_ID
                       ,BS.FACTORY_ID
                       ,BS.LOCATION
                       ,BS.OPERATION_ID
                       ,RE.LINE_ID
                       ,LN.ELECTRODE_TYPE
                       ,BS.EQUIPMENT_ID
                       ,CAL.BASIS_YYYYMMDD AS PLAN_DATE
                       ,BS.MODEL_ID
                       ,BS.ITEM_ID
                       ,BS.PRODUCTION_TYPE
                       ,BS.MARKET
                       ,BS.VERSION
                       ,BS.PLM_EC_NO
                       ,BS.ITEM_TYPE
                       ,BS.SEQ
                       ,BS.CUSTOMER_ID
                       ,BS.BOH_QTY
                       ,BS.NICK_NAME
                       ,LN.LINE_NAME
                       ,BS.OPERATION_NAME
                       ,BS.MODE
                       , CASE  WHEN BS.OPERATION_ID    = 'A5000' THEN 'Notching'
                               WHEN BS.OPERATION_ID    IN ('A7000','A8000') THEN 'L&S'
                               WHEN BS.OPERATION_ID    = 'A9000' THEN 'PKG'
                               WHEN BS.OPERATION_ID    = 'E2000' THEN 'Coating'
                               WHEN BS.OPERATION_ID    = 'E3000' THEN 'R/P'
                               WHEN BS.OPERATION_ID    = 'F6000' THEN 'EOL'
                               ELSE BS.OPERATION_ID
                        END
                        + IIF(LN.ELECTRODE_TYPE = '-','',' (' + LN.ELECTRODE_TYPE + ')')
                        + REPLACE(CONCAT('#', SUBSTRING( RE.LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', RE.LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
                        + RIGHT(BS.NICK_NAME,3)
                        AS KEYS_MODEL
                       ,BS.INSTANCE_ID2
                       ,BS.CRUD
                       ,BS.MEMO
                       ,'N' AS XLS_YN -- added 2025-11-10
                FROM(
                    SELECT  DISTINCT  XLS.INSTANCE_ID
                            , XLS.FP_PLAN_ID
                            , XLS.COMPANY_ID
                            , XLS.DIVISION_ID
                            , XLS.CATEGORY_ID
                            , XLS.SITE_ID
                            , XLS.PLANT_ID
                            , XLS.FACTORY_ID
                            , XLS.LOCATION
                            , XLS.OPERATION_ID
                            --, XLS.LINE_ID
                            , XLS.ELECTRODE_TYPE
                            , XLS.EQUIPMENT_ID
                            --, XLS.PLAN_DATE
                            , XLS.MODEL_ID
                            , XLS.ITEM_ID
                            , XLS.PRODUCTION_TYPE
                            , XLS.MARKET
                            , XLS.VERSION
                            , XLS.PLM_EC_NO
                            --, XLS.CELL_OUT_QTY
                            , XLS.ITEM_TYPE
                            , XLS.SEQ
                            , XLS.CUSTOMER_ID
                            , XLS.BOH_QTY
                            , XLS.NICK_NAME
                            --, XLS.LINE_NAME
                            , XLS.OPERATION_NAME
                            , XLS.MODE
                            --, XLS.KEYS_MODEL
                            , XLS.INSTANCE_ID2
                            --, XLS.ROWNUM
                            --, XLS.QTY
                            , XLS.CRUD
                            --, XLS.INSERT_ID
                            --, XLS.INSERT_TIME
                            --, XLS.UPDATE_ID
                            --, XLS.UPDATE_TIME
                            , XLS.MEMO
                    FROM    BUF_AMEND_PLAN_R_XLS XLS WITH(NOLOCK)
                        INNER JOIN (
                                    SELECT  RE.ATTRIBUTE15 AS LINE_ID
                                           ,LU.SEGMENT5    AS OPERATION_ID
                                    FROM    SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)
                                       INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LU WITH(NOLOCK)
                                           ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_STAGE_OPERATION_MAP'
                                           AND LU.VALID_YN    = 'Y'
                                           AND LU.SEGMENT1    = @V_GM_A_DIVISION_ID
                                           AND LU.SEGMENT2    = @V_GM_A_PLAN_GROUP_ID
                                           AND RE.STAGE       = LU.SEGMENT3
                                       LEFT OUTER JOIN (
                                                       SELECT  ATTRIBUTE3 AS STAGE
                                                       FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LU WITH(NOLOCK)
                                                       WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                                       AND     LU.SEGMENT2    = @V_GM_A_DIVISION_ID
                                                       AND     LU.SEGMENT3    = @V_GM_A_PLAN_GROUP_ID
                                                       AND     LU.VALID_YN    = 'Y'
                                                       GROUP BY ATTRIBUTE3
                                                      ) OCV
                                           ON  RE.STAGE = OCV.STAGE
                                    WHERE   RE.PLAN_ID = @P_GM_A_PLAN_ID
                                    AND     RE.RESOURCE_TYPE = 'LINE'
                                    AND     OCV.STAGE IS NULL
                                    GROUP BY RE.ATTRIBUTE15, LU.SEGMENT5
                                    ) RE
                            ON  XLS.LINE_ID = RE.LINE_ID
                            AND XLS.OPERATION_ID = RE.OPERATION_ID
                    WHERE   EXISTS (
                                    SELECT  1 
                                    FROM    SCM_FP_PLAN_H AS X WITH(NOLOCK)
                                    WHERE   X.INTG_PLAN_ID  = @P_FP_PLAN_ID
                                    AND     X.INSTANCE_ID   = XLS.INSTANCE_ID
                                    AND     X.PLAN_ID       = XLS.FP_PLAN_ID
                                    )       
                    -- AND     XLS.QTY > 0
                    ) BS
                    CROSS APPLY (
                                 SELECT  ATTRIBUTE15 AS LINE_ID
                                        --,STAGE       AS STAGE
                                 FROM    SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)
                                 WHERE   RE.PLAN_ID = @P_GM_A_PLAN_ID
                                 AND     RE.RESOURCE_TYPE = 'LINE'
                                 --GROUP BY ATTRIBUTE15, STAGE
                                 GROUP BY ATTRIBUTE15
                                 ) RE
                    INNER JOIN SCM_LINE_M LN WITH(NOLOCK)
                        ON  RE.LINE_ID        = LN.LINE_ID
                        AND LN.ACTIVE_FLAG    = 'Y'
                        AND LN.DIVISION_ID    = @V_GM_A_DIVISION_ID
                        AND BS.OPERATION_ID   = LN.OPERATION_ID
                    CROSS APPLY(
                                SELECT  BASIS_YYYYMMDD
                                FROM    SCM_SYS_CALENDAR_M_SN CAL WITH(NOLOCK)
                                WHERE   CAL.BASIS_YYYYMMDD >= @V_GM_A_PLAN_START_YYYYMMDD
                                AND     CAL.BASIS_YYYYMMDD < @V_GM_A_PLAN_END_YYYYMMDD
                                ) CAL
                ) BS
                LEFT OUTER JOIN(
                                SELECT    XLS.INSTANCE_ID
                                        , XLS.FP_PLAN_ID
                                        , XLS.COMPANY_ID
                                        , XLS.DIVISION_ID
                                        , XLS.CATEGORY_ID
                                        , XLS.SITE_ID
                                        , XLS.PLANT_ID
                                        , XLS.FACTORY_ID
                                        , XLS.LOCATION
                                        , XLS.OPERATION_ID
                                        , XLS.LINE_ID
                                        , XLS.ELECTRODE_TYPE
                                        , XLS.EQUIPMENT_ID
                                        , XLS.PLAN_DATE
                                        , XLS.MODEL_ID
                                        , XLS.ITEM_ID
                                        , XLS.PRODUCTION_TYPE
                                        , XLS.MARKET
                                        , XLS.VERSION
                                        , XLS.PLM_EC_NO
                                        , XLS.CELL_OUT_QTY
                                        , XLS.ITEM_TYPE
                                        , XLS.SEQ
                                        , XLS.CUSTOMER_ID
                                        , XLS.BOH_QTY
                                        , XLS.NICK_NAME
                                        , XLS.LINE_NAME
                                        , XLS.OPERATION_NAME
                                        , XLS.MODE
                                        , XLS.KEYS_MODEL
                                        , XLS.INSTANCE_ID2
                                        , XLS.ROWNUM
                                        , XLS.QTY
                                        , XLS.CRUD
                                        , XLS.MEMO
										, XLS.WORKING_DAY
                                        , 'Y' AS XLS_YN -- added 2025-11-10
                                FROM    BUF_AMEND_PLAN_R_XLS XLS WITH(NOLOCK)
                                WHERE   EXISTS (
                                                SELECT  1 
                                                FROM    SCM_FP_PLAN_H AS X WITH(NOLOCK)
                                                WHERE   X.INTG_PLAN_ID  = @P_FP_PLAN_ID
                                                AND     X.INSTANCE_ID   = XLS.INSTANCE_ID
                                                AND     X.PLAN_ID       = XLS.FP_PLAN_ID
                                                )    
                                ) XLS
                ON  BS.INSTANCE_ID     = XLS.INSTANCE_ID
                AND BS.FP_PLAN_ID      = XLS.FP_PLAN_ID
                AND BS.COMPANY_ID      = XLS.COMPANY_ID
                AND BS.DIVISION_ID     = XLS.DIVISION_ID
                AND BS.CATEGORY_ID     = XLS.CATEGORY_ID
                AND BS.SITE_ID         = XLS.SITE_ID
                AND BS.PLANT_ID        = XLS.PLANT_ID
                AND BS.FACTORY_ID      = XLS.FACTORY_ID
                AND BS.LOCATION        = XLS.LOCATION
                AND BS.OPERATION_ID    = XLS.OPERATION_ID
                AND BS.LINE_ID         = XLS.LINE_ID
                AND BS.ELECTRODE_TYPE  = XLS.ELECTRODE_TYPE
                AND BS.PLAN_DATE       = XLS.PLAN_DATE
                AND BS.MODEL_ID        = XLS.MODEL_ID
                AND BS.ITEM_ID         = XLS.ITEM_ID
                AND BS.PRODUCTION_TYPE = XLS.PRODUCTION_TYPE
                AND BS.MARKET          = XLS.MARKET
                AND BS.VERSION         = XLS.VERSION
                AND BS.PLM_EC_NO       = XLS.PLM_EC_NO
                AND BS.ITEM_TYPE       = XLS.ITEM_TYPE
                AND BS.SEQ             = XLS.SEQ
                AND BS.CUSTOMER_ID     = XLS.CUSTOMER_ID
                AND BS.BOH_QTY         = XLS.BOH_QTY
                AND BS.NICK_NAME       = XLS.NICK_NAME
                AND BS.LINE_NAME       = XLS.LINE_NAME
                AND BS.OPERATION_NAME  = XLS.OPERATION_NAME
                AND BS.MODE            = XLS.MODE
                --AND BS.KEYS_MODEL      = XLS.KEYS_MODEL
                AND BS.INSTANCE_ID2    = XLS.INSTANCE_ID2
                AND BS.CRUD            = XLS.CRUD
            UNION ALL
            -- 전극 LINE/날짜 펼쳐서 SELECT
            SELECT  BS.INSTANCE_ID
                   ,BS.FP_PLAN_ID
                   ,BS.COMPANY_ID
                   ,BS.DIVISION_ID
                   ,BS.CATEGORY_ID
                   ,BS.SITE_ID
                   ,BS.PLANT_ID
                   ,BS.FACTORY_ID
                   ,BS.LOCATION
                   ,BS.OPERATION_ID
                   ,BS.LINE_ID
                   ,BS.ELECTRODE_TYPE
                   ,BS.EQUIPMENT_ID
                   ,BS.PLAN_DATE
                   ,BS.MODEL_ID
                   ,BS.ITEM_ID
                   ,BS.PRODUCTION_TYPE
                   ,BS.MARKET
                   ,BS.VERSION
                   ,BS.PLM_EC_NO
                   ,IIF(BS.PLAN_DATE = XLS.PLAN_DATE,XLS.CELL_OUT_QTY,0) AS CELL_OUT_QTY
                   ,BS.ITEM_TYPE
                   ,BS.SEQ
                   ,BS.CUSTOMER_ID
                   ,BS.BOH_QTY
                   ,BS.NICK_NAME
                   ,BS.LINE_NAME
                   ,BS.OPERATION_NAME
                   ,BS.MODE
                   ,BS.KEYS_MODEL
                   ,BS.INSTANCE_ID2
                   ,IIF(BS.PLAN_DATE = XLS.PLAN_DATE,XLS.QTY,0) AS QTY
                   ,BS.CRUD
                   ,BS.MEMO
				   ,IIF(BS.PLAN_DATE = XLS.PLAN_DATE,XLS.WORKING_DAY,0) AS WORKING_DAY
                   ,ISNULL(XLS.XLS_YN, BS.XLS_YN) AS XLS_YN -- added 2025-11-10
            FROM(
                SELECT  BS.INSTANCE_ID
                       ,BS.FP_PLAN_ID
                       ,BS.COMPANY_ID
                       ,BS.DIVISION_ID
                       ,BS.CATEGORY_ID
                       ,BS.SITE_ID
                       ,BS.PLANT_ID
                       ,BS.FACTORY_ID
                       ,BS.LOCATION
                       ,BS.OPERATION_ID
                       ,RE.LINE_ID
                       ,LN.ELECTRODE_TYPE
                       ,LN.EQUIPMENT_ID
                       ,CAL.BASIS_YYYYMMDD AS PLAN_DATE
                       ,BS.MODEL_ID
                       ,BS.ITEM_ID
                       ,BS.PRODUCTION_TYPE
                       ,BS.MARKET
                       ,BS.VERSION
                       ,BS.PLM_EC_NO
                       ,BS.ITEM_TYPE
                       ,BS.SEQ
                       ,BS.CUSTOMER_ID
                       ,BS.BOH_QTY
                       ,BS.NICK_NAME
                       ,LN.LINE_NAME
                       ,BS.OPERATION_NAME
                       ,BS.MODE
                       , CASE  WHEN BS.OPERATION_ID    = 'A5000' THEN 'Notching'
                               WHEN BS.OPERATION_ID    IN ('A7000','A8000') THEN 'L&S'
                               WHEN BS.OPERATION_ID    = 'A9000' THEN 'PKG'
                               WHEN BS.OPERATION_ID    = 'E2000' THEN 'Coating'
                               WHEN BS.OPERATION_ID    = 'E3000' THEN 'R/P'
                               WHEN BS.OPERATION_ID    = 'F6000' THEN 'EOL'
                               ELSE BS.OPERATION_ID
                        END
                        + IIF(LN.ELECTRODE_TYPE = '-','',' (' + LN.ELECTRODE_TYPE + ')')
                        + REPLACE(CONCAT('#', SUBSTRING( RE.LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', RE.LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
                        + RIGHT(BS.NICK_NAME,3)
                        AS KEYS_MODEL
                       ,BS.INSTANCE_ID2
                       ,BS.CRUD
                       ,BS.MEMO
                       ,'N' AS XLS_YN -- added 2025-11-10
                FROM(
                    SELECT  DISTINCT  XLS.INSTANCE_ID
                            , XLS.FP_PLAN_ID
                            , XLS.COMPANY_ID
                            , XLS.DIVISION_ID
                            , XLS.CATEGORY_ID
                            , XLS.SITE_ID
                            , XLS.PLANT_ID
                            , XLS.FACTORY_ID
                            , XLS.LOCATION
                            , XLS.OPERATION_ID
                            --, XLS.LINE_ID
                            , XLS.ELECTRODE_TYPE
                            -- , XLS.EQUIPMENT_ID
                            --, XLS.PLAN_DATE
                            , XLS.MODEL_ID
                            , XLS.ITEM_ID
                            , XLS.PRODUCTION_TYPE
                            , XLS.MARKET
                            , XLS.VERSION
                            , XLS.PLM_EC_NO
                            --, XLS.CELL_OUT_QTY
                            , XLS.ITEM_TYPE
                            , XLS.SEQ
                            , XLS.CUSTOMER_ID
                            , XLS.BOH_QTY
                            , XLS.NICK_NAME
                            --, XLS.LINE_NAME
                            , XLS.OPERATION_NAME
                            , XLS.MODE
                            --, XLS.KEYS_MODEL
                            , XLS.INSTANCE_ID2
                            --, XLS.ROWNUM
                            --, XLS.QTY
                            , XLS.CRUD
                            --, XLS.INSERT_ID
                            --, XLS.INSERT_TIME
                            --, XLS.UPDATE_ID
                            --, XLS.UPDATE_TIME
                            , XLS.MEMO
                    FROM    BUF_AMEND_PLAN_R_XLS XLS WITH(NOLOCK)
                        INNER JOIN (
                                    SELECT  RE.ATTRIBUTE14 AS LINE_ID
                                           ,LU.SEGMENT5    AS OPERATION_ID
                                    FROM    SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)
                                       INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LU WITH(NOLOCK)
                                           ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_STAGE_OPERATION_MAP'
                                           AND LU.VALID_YN    = 'Y'
                                           AND LU.SEGMENT1    = @V_GM_E_DIVISION_ID
                                           AND LU.SEGMENT2    = @V_GM_E_PLAN_GROUP_ID
                                           AND RE.STAGE       = LU.SEGMENT3
                                       LEFT OUTER JOIN (
                                                       SELECT  ATTRIBUTE3 AS STAGE
                                                       FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL_SN LU WITH(NOLOCK)
                                                       WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                                       AND     LU.SEGMENT2    = @V_GM_E_DIVISION_ID
                                                       AND     LU.SEGMENT3    = @V_GM_E_PLAN_GROUP_ID
                                                       AND     LU.VALID_YN    = 'Y'
                                                       GROUP BY ATTRIBUTE3
                                                      ) OCV
                                           ON  RE.STAGE = OCV.STAGE
                                    WHERE   RE.PLAN_ID = @P_GM_E_PLAN_ID
                                    AND     RE.RESOURCE_TYPE = 'LINE'
                                    AND     OCV.STAGE IS NULL
                                    GROUP BY RE.ATTRIBUTE14, LU.SEGMENT5
                                    ) RE
                            ON  XLS.LINE_ID = RE.LINE_ID
                            AND XLS.OPERATION_ID = RE.OPERATION_ID
                    WHERE   EXISTS (
                                    SELECT  1 
                                    FROM    SCM_FP_PLAN_H AS X WITH(NOLOCK)
                                    WHERE   X.INTG_PLAN_ID  = @P_FP_PLAN_ID
                                    AND     X.INSTANCE_ID   = XLS.INSTANCE_ID
                                    AND     X.PLAN_ID       = XLS.FP_PLAN_ID
                                    )       
                    -- AND     XLS.QTY > 0
                    ) BS
                    CROSS APPLY (
                                 SELECT  ATTRIBUTE14 AS LINE_ID
                                 FROM    SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)
                                 WHERE   RE.PLAN_ID = @P_GM_E_PLAN_ID
                                 AND     RE.RESOURCE_TYPE = 'LINE'
                                 GROUP BY ATTRIBUTE14
                                 ) RE
                    INNER JOIN (
                                SELECT  ATTRIBUTE2  AS ITEM_ID
                                       ,ATTRIBUTE13 AS LINE_ID
                                       ,IIF(RIGHT(ATTRIBUTE15,1)='A','Anode','Cathode') AS ELECTRODE_TYPE
                                FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN WITH(NOLOCk) 
                                WHERE   PLAN_ID = @P_GM_E_PLAN_ID
                                AND     RESOURCE_CLASS_ID = 'LINE'
                                GROUP BY ATTRIBUTE2, ATTRIBUTE13, ATTRIBUTE15
                               )RR
                        ON  BS.ITEM_ID = RR.ITEM_ID
                        AND RE.LINE_ID = RR.LINE_ID
                    INNER JOIN (	SELECT  DISTINCT 
                                            SLM.LINE_ID, SLM.LINE_NAME, SLM.OPERATION_ID, SLM.ELECTRODE_TYPE, ISNULL(EQ.EQUIPMENT_ID, '-') AS EQUIPMENT_ID
                                    FROM    SCM_LINE_M SLM WITH(NOLOCK)
                                    LEFT OUTER JOIN SCM_EQUIPMENT_M EQ WITH(NOLOCK)
                                        ON  EQ.COMPANY_ID       = SLM.COMPANY_ID
                                        AND EQ.DIVISION_ID      = SLM.DIVISION_ID
                                        AND EQ.SITE_ID          = SLM.SITE_ID
                                        AND EQ.PLANT_ID         = SLM.PLANT_ID
                                        AND EQ.FACTORY_ID       = SLM.FACTORY_ID
                                        AND EQ.OPERATION_ID     = SLM.OPERATION_ID
                                        AND EQ.LINE_ID          = SLM.LINE_ID
                                        AND EQ.ACTIVE_FLAG      = 'Y'
                                        AND EQ.EQUIPMENT_TYPE   = 'M'
                                        AND EQ.OPERATION_ID     = 'E2000'
                                    WHERE   1=1
                                    AND     SLM.DIVISION_ID     = @V_GM_A_DIVISION_ID -- DIVISION_ID 질문
                                    AND     SLM.OPERATION_ID   IN ('E2000', 'A5000')
                                    AND     SLM.ACTIVE_FLAG     = 'Y'
                                    ) LN
                        ON  RE.LINE_ID        = LN.LINE_ID
                        AND BS.OPERATION_ID   = LN.OPERATION_ID
                        AND RR.ELECTRODE_TYPE = LN.ELECTRODE_TYPE
                    CROSS APPLY(
                                SELECT  BASIS_YYYYMMDD
                                FROM    SCM_SYS_CALENDAR_M_SN CAL WITH(NOLOCK)
                                WHERE   CAL.BASIS_YYYYMMDD >= @V_GM_E_PLAN_START_YYYYMMDD
                                AND     CAL.BASIS_YYYYMMDD < @V_GM_E_PLAN_END_YYYYMMDD
                                ) CAL
                ) BS
                LEFT OUTER JOIN(
                                SELECT    XLS.INSTANCE_ID
                                        , XLS.FP_PLAN_ID
                                        , XLS.COMPANY_ID
                                        , XLS.DIVISION_ID
                                        , XLS.CATEGORY_ID
                                        , XLS.SITE_ID
                                        , XLS.PLANT_ID
                                        , XLS.FACTORY_ID
                                        , XLS.LOCATION
                                        , XLS.OPERATION_ID
                                        , XLS.LINE_ID
                                        , XLS.ELECTRODE_TYPE
                                        , XLS.EQUIPMENT_ID
                                        , XLS.PLAN_DATE
                                        , XLS.MODEL_ID
                                        , XLS.ITEM_ID
                                        , XLS.PRODUCTION_TYPE
                                        , XLS.MARKET
                                        , XLS.VERSION
                                        , XLS.PLM_EC_NO
                                        , XLS.CELL_OUT_QTY
                                        , XLS.ITEM_TYPE
                                        , XLS.SEQ
                                        , XLS.CUSTOMER_ID
                                        , XLS.BOH_QTY
                                        , XLS.NICK_NAME
                                        , XLS.LINE_NAME
                                        , XLS.OPERATION_NAME
                                        , XLS.MODE
                                        , XLS.KEYS_MODEL
                                        , XLS.INSTANCE_ID2
                                        , XLS.ROWNUM
                                        , XLS.QTY
                                        , XLS.CRUD
                                        , XLS.MEMO
										, XLS.WORKING_DAY
                                        , 'Y' AS XLS_YN -- added 2025-11-10
                                FROM    BUF_AMEND_PLAN_R_XLS XLS WITH(NOLOCK)
                                WHERE   EXISTS (
                                                SELECT  1 
                                                FROM    SCM_FP_PLAN_H AS X WITH(NOLOCK)
                                                WHERE   X.INTG_PLAN_ID  = @P_FP_PLAN_ID
                                                AND     X.INSTANCE_ID   = XLS.INSTANCE_ID
                                                AND     X.PLAN_ID       = XLS.FP_PLAN_ID
                                                )    
                                ) XLS
                ON  BS.INSTANCE_ID     = XLS.INSTANCE_ID
                AND BS.FP_PLAN_ID      = XLS.FP_PLAN_ID
                AND BS.COMPANY_ID      = XLS.COMPANY_ID
                AND BS.DIVISION_ID     = XLS.DIVISION_ID
                AND BS.CATEGORY_ID     = XLS.CATEGORY_ID
                AND BS.SITE_ID         = XLS.SITE_ID
                AND BS.PLANT_ID        = XLS.PLANT_ID
                AND BS.FACTORY_ID      = XLS.FACTORY_ID
                AND BS.LOCATION        = XLS.LOCATION
                AND BS.OPERATION_ID    = XLS.OPERATION_ID
                AND BS.LINE_ID         = XLS.LINE_ID
                AND BS.ELECTRODE_TYPE  = XLS.ELECTRODE_TYPE
                AND BS.EQUIPMENT_ID    = XLS.EQUIPMENT_ID -- 2025.09.19 Philsu Park: 수량 중복 발생 방지.
                AND BS.PLAN_DATE       = XLS.PLAN_DATE
                AND BS.MODEL_ID        = XLS.MODEL_ID
                AND BS.ITEM_ID         = XLS.ITEM_ID
                AND BS.PRODUCTION_TYPE = XLS.PRODUCTION_TYPE
                AND BS.MARKET          = XLS.MARKET
                AND BS.VERSION         = XLS.VERSION
                AND BS.PLM_EC_NO       = XLS.PLM_EC_NO
                AND BS.ITEM_TYPE       = XLS.ITEM_TYPE
                AND BS.SEQ             = XLS.SEQ
                AND BS.CUSTOMER_ID     = XLS.CUSTOMER_ID
                AND BS.BOH_QTY         = XLS.BOH_QTY
                AND BS.NICK_NAME       = XLS.NICK_NAME
                AND BS.LINE_NAME       = XLS.LINE_NAME
                AND BS.OPERATION_NAME  = XLS.OPERATION_NAME
                AND BS.MODE            = XLS.MODE
                --AND BS.KEYS_MODEL      = XLS.KEYS_MODEL
                AND BS.INSTANCE_ID2    = XLS.INSTANCE_ID2
                AND BS.CRUD            = XLS.CRUD
                ;

            WITH F AS ( -- added WITH F, 2025-11-10
            SELECT    CASE  WHEN OPERATION_ID    = 'A5000' THEN 'Notching'
                            WHEN OPERATION_ID    IN ('A7000','A8000') THEN 'L&S'
                            WHEN OPERATION_ID    = 'A9000' THEN 'PKG'
                            WHEN OPERATION_ID    = 'E2000' THEN 'Coating'
                            WHEN OPERATION_ID    = 'E3000' THEN 'R/P'
                            WHEN OPERATION_ID    = 'F6000' THEN 'EOL'
                            ELSE OPERATION_ID
                        END
                        + IIF(ELECTRODE_TYPE = '-','',' (' + ELECTRODE_TYPE + ')')
                        + IIF(ISNULL(EQUIPMENT_ID, '-') = '-','',' (' + EQUIPMENT_ID + ')')
                        -- + ' (' + ISNULL(EQUIPMENT_ID, '-') + ')' -- 2025.09.19 Philsu Park: 전극 key.
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
                        + IIF(ISNULL(EQUIPMENT_ID, '-') = '-','',' (' + EQUIPMENT_ID + ')')
                        -- + ' (' + ISNULL(EQUIPMENT_ID, '-') + ')' -- 2025.09.19 Philsu Park: 전극 key.
                        + REPLACE(CONCAT('#', SUBSTRING( LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
                        + RIGHT(NICK_NAME,3)
                        AS KEYS_MODEL
                    , INSTANCE_ID2
                    /* -- blocked 2025-11-10
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
                                        ) AS ROWNUM */
                    , QTY
                    , CRUD
                    -- , INSERT_ID
                    -- , INSERT_TIME
                    -- , UPDATE_ID
                    -- , UPDATE_TIME
                    , NULL AS PREV_QTY
                    , IIF(ISNULL(MEMO, '') = '', 'NULL', MEMO) AS MEMO
					, WORKING_DAY
                    , XLS_YN -- added 2025-11-10
            FROM    @TMP_BUF_AMEND_PLAN_R_XLS
            -- START, 2025-11-10
            ), PF AS (
                SELECT F.*
                     , ROW_NUMBER() OVER(PARTITION BY F.KEYS ORDER BY F.XLS_YN DESC) AS KEY_RNK
                FROM   F
            )
             SELECT F.KEYS
                  , F.INSTANCE_ID
                  , F.FP_PLAN_ID
                  , F.COMPANY_ID
                  , F.DIVISION_ID
                  , F.CATEGORY_ID
                  , F.SITE_ID
                  , F.PLANT_ID
                  , F.FACTORY_ID
                  , F.LOCATION
                  , F.OPERATION_ID
                  , F.LINE_ID
                  , F.ELECTRODE_TYPE
                  , F.EQUIPMENT_ID
                  , F.PLAN_DATE
                  , F.MODEL_ID
                  , F.ITEM_ID
                  , F.PRODUCTION_TYPE
                  , F.MARKET
                  , F.VERSION
                  , F.PLM_EC_NO
                  , F.CELL_OUT_QTY
                  , F.ITEM_TYPE
                  , F.SEQ
                  , F.CUSTOMER_ID
                  , F.BOH_QTY
                  , F.NICK_NAME
                  , F.LINE_NAME
                  , F.OPERATION_NAME
                  , F.MODE
                  , F.KEYS_MODEL
                  , F.INSTANCE_ID2
                  , ROW_NUMBER() OVER(PARTITION BY INSTANCE_ID
                                      ORDER BY
                                               INSTANCE_ID
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
                  , F.QTY
                  , F.CRUD
                  , F.PREV_QTY
                  , F.MEMO
                  , F.WORKING_DAY
             FROM   PF F
             WHERE  F.KEY_RNK = 1
            ;
            -- END, 2025-11-10
        END
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
    
  END;
