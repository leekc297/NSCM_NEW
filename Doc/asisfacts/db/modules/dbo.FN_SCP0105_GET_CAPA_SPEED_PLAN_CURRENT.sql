
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
    * Program ID   : FN_SCP0105_GET_CAPA_SPEED_PLAN_CURRENT
    * Description  : CAPA LINE ASSING
    * Program History
    *================================================================================================================================================
    * Date         In Charge                          Description
    *================================================================================================================================================
    * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
    */

--CREATE FUNCTION [dbo].[FN_SCP0105_GET_CAPA_SPEED_PLAN_CURRENT]
CREATE FUNCTION [dbo].[FN_SCP0105_GET_CAPA_SPEED_PLAN_CURRENT]
(
	  @p_version			NVARCHAR(10)
	, @p_version_seq		TINYINT
	, @p_prog_stat			NVARCHAR(1)
	, @p_division_id		NVARCHAR(MAX)
	, @p_site_id			NVARCHAR(MAX)
	, @p_plant_id  			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_operation_id		NVARCHAR(MAX)
	, @p_item_id		    NVARCHAR(MAX)
    , @p_electrode_type		NVARCHAR(MAX)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
)
RETURNS @TBL_RES TABLE
--DECLARE @TBL_RES TABLE
(
		  VER_ID					NVARCHAR(10)	NOT NULL
		, VER_SEQ					TINYINT			NOT NULL
		, DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, ITEM_ID					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, SPEED_UNIT_GROUP			NVARCHAR(30)	NOT NULL
		, MSR_TP_CD					NVARCHAR(50)	NOT NULL
		, YYYYMM					NVARCHAR(6)		NOT NULL
		, PFRSLT_QTY				NUMERIC(20, 10)
		, BASE_QTY					NUMERIC(20, 10)
		, QTY						NUMERIC(20, 10)
		, ELTR_QTY					NUMERIC(20, 10)
		, MMS_CF					NUMERIC(20, 10)
		, UI_UPD_YN					NVARCHAR(1)
		, PROG_STAT					NVARCHAR(2)
)
BEGIN
    --SET NOCOUNT ON;

	------DECLARE @p_version			NVARCHAR(10)		= N'202403'
	------DECLARE @p_version_seq		TINYINT             = 1;
	------DECLARE @p_prog_stat		NVARCHAR(1)         = N'0'; -- '0' : Current, '1' : 1st Cutoff, '2' : 2nd Cutoff
	------DECLARE @p_division_id		NVARCHAR(MAX)		= N'81';
	------DECLARE @p_site_id			NVARCHAR(MAX)		= N'A003';
	------DECLARE @p_plant_id  		NVARCHAR(MAX)		= N'G382';
	------DECLARE @p_factory_id		NVARCHAR(MAX)		= N'A4';
	------DECLARE @p_line_id			NVARCHAR(MAX)		= N'A4A04';
	------DECLARE @p_operation_id		NVARCHAR(MAX)		= N'A5000';
	------DECLARE @p_item_id		    NVARCHAR(MAX)		= N'TEST DUMMY!!';
	--------DECLARE @p_item_id		    NVARCHAR(MAX)		= N'A7';
	------DECLARE @p_electrode_type	NVARCHAR(MAX)		= N'Anode';
	------DECLARE @p_program_id		NVARCHAR(100)		= N'SCP0105';
	------DECLARE @p_sheet_name		NVARCHAR(100)		= N'MAIN';
 ------   DECLARE @p_user_id			NVARCHAR(30)		= N'iamarock';
 ------   DECLARE @debug_mode			NVARCHAR(1)			= N'F';

	--DECLARE @p_version			NVARCHAR(10)		= N'202404'
	--DECLARE @p_version_seq		TINYINT             = 1;
	--DECLARE @p_prog_stat		NVARCHAR(1)         = N'0'; -- '0' : Current, '1' : 1st Cutoff, '2' : 2nd Cutoff
	--DECLARE @p_division_id		NVARCHAR(MAX)		= N'81';
	--DECLARE @p_site_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_plant_id  		NVARCHAR(MAX)		= N'';
	--DECLARE @p_factory_id		NVARCHAR(MAX)		= N'';
	--DECLARE @p_line_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_operation_id		NVARCHAR(MAX)		= N'';
	--DECLARE @p_item_id		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_electrode_type	NVARCHAR(MAX)		= N'';
	--DECLARE @p_program_id		NVARCHAR(100)		= N'SCP0105';
	--DECLARE @p_sheet_name		NVARCHAR(100)		= N'MAIN';
 --   DECLARE @p_user_id			NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			NVARCHAR(1)			= N'F';



    DECLARE @v_from_yyyy        NVARCHAR(8)			= N'';

    SET @v_from_yyyy        = SUBSTRING(@p_version, 1, 4);



	DECLARE @tblSCP0105_DATE_COLS TABLE
    (
		  COLUMN_NAME					NVARCHAR(200)
		, COLUMN_LABEL_NAME				NVARCHAR(200)
		, SMALL_CLASS_LABEL_NAME		NVARCHAR(200)
		, LARGE_CLASS_LABEL_NAME		NVARCHAR(200)
		, DAY_CODE						NVARCHAR(200)
		, SORT_ORDER_NO					NVARCHAR(200)
	)

    INSERT INTO @tblSCP0105_DATE_COLS
    SELECT	  COLUMN_NAME
			, COLUMN_LABEL_NAME
			, SMALL_CLASS_LABEL_NAME
			, LARGE_CLASS_LABEL_NAME
			, DAY_CODE
			, SORT_ORDER_NO
	FROM	dbo.FN_SCP0104_GET_SPREAD_TITLE(@p_version, @p_program_id, @p_sheet_name) A;

--TESTING : NOK
--select * from @tblSCP0105_DATE_COLS;return;

	DECLARE @v_to_yyyy			NVARCHAR(4)			= '';

    SELECT  @v_to_yyyy  = MAX(SMALL_CLASS_LABEL_NAME)
    FROM    @tblSCP0105_DATE_COLS;

--PRINT CONCAT('@v_to_yyyy : ', @v_to_yyyy);

	 --   DECLARE @tblSCP0105_MEASURE TABLE
		--(
		--	  MEASURE						NVARCHAR(200)
  --          , MEASURE_NAME					NVARCHAR(200)
  --          , SORT_ORDER_NO					NVARCHAR(200)
		--)

--TESTING : NOK
--select * from @tblSCP0105_MEASURE;return;

        --INSERT INTO @tblSCP0105_MEASURE
        --SELECT    MEASURE
        --        , MEASURE_NAME
        --        , SORT_ORDER_NO
        --FROM     [dbo].[FN_SCP0105_GET_CAPA_MEASURE](@p_program_Id, @p_sheet_name);

--TESTING : NOK
--select * from @tblSCP0105_MEASURE;return;


	    DECLARE @tblSCP0105_SPEED_UNIT_ALL TABLE
		(
			  UNIT_GROUP						NVARCHAR(200)
			, OPERATION_ID						NVARCHAR(200)
			, MSR_TP_CD							NVARCHAR(200)
			, LINE_TYPE							NVARCHAR(200)
			, UNIT_GROUP_SEQ					NVARCHAR(200)
			, DISPLAY_SEQ						NVARCHAR(200)
		)

        INSERT INTO @tblSCP0105_SPEED_UNIT_ALL
        SELECT    A.SEGMENT1        AS UNIT_GROUP
                , A.SEGMENT2        AS OPERATION_ID
                , A.SEGMENT3        AS MSR_TP_CD
                , A.SEGMENT4        AS LINE_TYPE
                , A.SEGMENT5        AS UNIT_GROUP_SEQ
                , A.DISPLAY_SEQ
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
			--AND SEGMENT1 = 'SCP'
            AND A.LOOKUP_TYPE  = 'OPERATION_SPEED_UNIT'
            AND A.VALID_YN  = 'Y';

--TESTING : NOK
--select * from @tblSCP0105_SPEED_UNIT_ALL;return;


	    DECLARE @tblSCP0105_SPEED_UNIT_GROUP TABLE
		(
			  UNIT_GROUP            NVARCHAR(200)
            , DISPLAY_SEQ           NVARCHAR(200)
            , UNIT_GROUP_SEQ        NVARCHAR(200)
		)

        INSERT INTO @tblSCP0105_SPEED_UNIT_GROUP
        SELECT    A.UNIT_GROUP
                , MIN(A.DISPLAY_SEQ)    AS DISPLAY_SEQ
                , MAX(UNIT_GROUP_SEQ)   AS UNIT_GROUP_SEQ
        FROM    @tblSCP0105_SPEED_UNIT_ALL A
        GROUP BY A.UNIT_GROUP
        ORDER BY MIN(A.DISPLAY_SEQ);

--TESTING : NOK
--select * from @tblSCP0105_SPEED_UNIT_GROUP;return;


--PRINT CONCAT('@p_prog_stat : ', @p_prog_stat);
--return;


    --PRINT N'GET - RESULT - BEGIN';
    DECLARE @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_RESULT TABLE
	(
		  DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, SPEED_UNIT_GROUP			NVARCHAR(30)	NOT NULL
		, MSR_TP_CD					NVARCHAR(50)	NOT NULL
		, EQP_NBU					NUMERIC(20, 10)
		, EQP_SPED					NUMERIC(20, 10)
	)

    INSERT INTO @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_RESULT
    SELECT    A.DIVISION_ID                 AS DIVISION_ID
            , A.COMPANY_ID                  AS COMPANY_ID
            , A.SITE_ID                     AS SITE_ID
            , A.PLANT_ID                    AS PLANT_ID
            , A.FACTORY_ID                  AS FACTORY_ID
            , A.LINE_ID                     AS LINE_ID
            , A.OPERATION_ID                AS OPERATION_ID
            , A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
            , A.MDL_NM                      AS NICK_NAME
            , B.UNIT_GROUP                  AS SPEED_UNIT_GROUP
            , UPPER(A.EQP_SPED_UNIT_CD)     AS EQP_SPED_UNIT_CD
            , AVG(A.EQP_NBU)                AS EQP_NBU
            , AVG(A.EQP_SPED)               AS EQP_SPED
            --, A.PFRSLT_YM                   AS YYYYMM
    FROM    SCM_DNM_EQP_SPED_MMLY A WITH(NOLOCK)
            LEFT JOIN (
                            SELECT    UNIT_GROUP
                                    , MSR_TP_CD
                            FROM    @tblSCP0105_SPEED_UNIT_ALL
                            WHERE   1=1
                            GROUP BY UNIT_GROUP
                                    , MSR_TP_CD
                        ) B ON
                    A.EQP_SPED_UNIT_CD  = MSR_TP_CD
    WHERE   1=1
        AND SUBSTRING(PFRSLT_YM, 1, 4) >= @v_from_yyyy
        AND SUBSTRING(PFRSLT_YM, 1, 4) <= @v_to_yyyy
		AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		--AND ((@p_item_id	    IS NULL OR @p_item_id   		= '') OR (A.ITEM_ID LIKE '%' + @p_item_id + '%') OR (A.NICK_NAME LIKE '%' + @p_item_id + '%'))
		AND ((@p_item_id	    IS NULL OR @p_item_id	        = '') OR A.MDL_NM         IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_item_id, ',')))
    GROUP BY  A.DIVISION_ID
            , A.COMPANY_ID
            , A.SITE_ID
            , A.PLANT_ID
            , A.FACTORY_ID
            , A.LINE_ID
            , A.OPERATION_ID
            , A.ELTR_LN_TP_CD
            , A.MDL_NM
            , B.UNIT_GROUP
            , A.EQP_SPED_UNIT_CD;
    --PRINT N'GET - RESULT - END';

--TESTING : NOK
--select * from @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_RESULT;return;


    --PRINT N'GET - BASE - BEGIN';
    DECLARE @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE TABLE
	(
		  DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, SPEED_UNIT_GROUP			NVARCHAR(30)	NOT NULL
		, MSR_TP_CD					NVARCHAR(50)	NOT NULL
		, EQP_NBU					NUMERIC(20, 10)
		, EQP_SPED					NUMERIC(20, 10)
		, UI_UPD_YN					NVARCHAR(1)
	)

    INSERT INTO @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE
    SELECT    A.DIVISION_ID                 AS DIVISION_ID
            , A.COMPANY_ID                  AS COMPANY_ID
            , A.SITE_ID                     AS SITE_ID
            , A.PLANT_ID                    AS PLANT_ID
            , A.FACTORY_ID                  AS FACTORY_ID
            , A.LINE_ID                     AS LINE_ID
            , A.OPERATION_ID                AS OPERATION_ID
            , A.MDL_NM                      AS NICK_NAME
            , A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
            , B.UNIT_GROUP                  AS SPEED_UNIT_GROUP
            , UPPER(A.EQP_SPED_UNIT_CD)     AS MSR_TP_CD
            , A.EQP_NBU
            , A.EQP_SPED
            , A.UI_UPD_YN
    FROM    SCP_MST_MDL_EQP_SPED A WITH(NOLOCK)
            LEFT JOIN (
                            SELECT    UNIT_GROUP
                                    , MSR_TP_CD
                            FROM    @tblSCP0105_SPEED_UNIT_ALL
                            WHERE   1=1
                            GROUP BY UNIT_GROUP
                                    , MSR_TP_CD
                        ) B ON
                    A.EQP_SPED_UNIT_CD  = MSR_TP_CD
    WHERE   1=1
        AND A.USE_YN = 'Y'
		AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		--AND ((@p_item_id	    IS NULL OR @p_item_id   		= '') OR (A.ITEM_ID LIKE '%' + @p_item_id + '%') OR (A.NICK_NAME LIKE '%' + @p_item_id + '%'))
		AND ((@p_item_id	    IS NULL OR @p_item_id	        = '') OR A.MDL_NM         IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_item_id, ',')))

--TESTING : NOK
--select * from SCP_MST_MDL_EQP_SPED where MDL_NM = 'TEST DUMMY!!';
--select * from @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_RESULT;--return;
--select * from @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE;return;


    DECLARE @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE_UI_UPD_YN TABLE
	(
		  DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, UI_UPD_YN					NVARCHAR(1)
	)

    INSERT INTO @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE_UI_UPD_YN
    SELECT    DIVISION_ID
            , COMPANY_ID
            , SITE_ID
            , PLANT_ID
            , FACTORY_ID
            , LINE_ID
            , OPERATION_ID
            , ELTR_LN_TP_CD
            , NICK_NAME
            , MAX(UI_UPD_YN)    AS UI_UPD_YN
    FROM    @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE
    WHERE   1=1
    GROUP BY  DIVISION_ID
            , COMPANY_ID
            , SITE_ID
            , PLANT_ID
            , FACTORY_ID
            , LINE_ID
            , OPERATION_ID
            , ELTR_LN_TP_CD
            , NICK_NAME
--TESTING : NOK
--select * from @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE_UI_UPD_YN;return;
    --PRINT N'GET - BASE - END';

    --PRINT N'GET - CF - BEGIN';
    DECLARE @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_CF TABLE
	(
		  NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, ELTR_QTY					NUMERIC(20, 10)
		, ELTR_PCH_LEN					NUMERIC(20, 10)
	)

    INSERT INTO @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_CF
    SELECT    A.NICK_NM               AS NICK_NAME
            , A.ELTR_LN_TP_CD
            , A.ELTR_QTY
            , A.ELTR_PCH_LEN
    FROM    SCP_MST_MDL_ELTR_QTY A WITH(NOLOCK)
    WHERE   1=1
        AND USE_YN = 'Y'
		AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		--AND ((@p_item_id	    IS NULL OR @p_item_id   		= '') OR (A.ITEM_ID LIKE '%' + @p_item_id + '%') OR (A.NICK_NAME LIKE '%' + @p_item_id + '%'))
		AND ((@p_item_id	    IS NULL OR @p_item_id	        = '') OR A.NICK_NM        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_item_id, ',')))
    --PRINT N'GET - CF - END';

--TESTING : NOK
--select * from @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_CF;return;

    DECLARE @tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN TABLE
    (
		  VER_ID					NVARCHAR(10)	NOT NULL
		, VER_SEQ					TINYINT			NOT NULL
		, DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, ITEM_ID					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
    )

    INSERT INTO @tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN
	SELECT	  @p_version        AS VER_ID   
			, @p_version_seq    AS VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.ITEM_ID
			, A.NICK_NAME
    FROM    SCP_MST_CAPA_LINE_ASSIGN A WITH(NOLOCK)
    WHERE   1=1
        AND VALID_YN = 'Y'
    GROUP BY  A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.ITEM_ID
			, A.NICK_NAME;

--TESTING : NOK
--select * from @tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN;return;

	DECLARE @tblSCP0105_RAW_ALL_TEMP TABLE
	(
		  VER_ID					NVARCHAR(10)	NOT NULL
		, VER_SEQ					TINYINT			NOT NULL
		, DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, ITEM_ID					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, MSR_TP_CD					NVARCHAR(50)	NOT NULL
		, YYYYMM					NVARCHAR(6)		NOT NULL
		, PFRSLT_QTY				NUMERIC(20, 10)
		, BASE_QTY					NUMERIC(20, 10)
		, QTY						NUMERIC(20, 10)
	)

    INSERT INTO @tblSCP0105_RAW_ALL_TEMP
	SELECT	  @p_version        AS VER_ID
			, @p_version_seq    AS VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.ITEM_ID
			, A.NICK_NAME
            , A.MSR_TP_CD
			, A.YYYYMM
            , NULL                                AS PFRSLT_QTY
            , A.BASE_QTY
            , A.QTY
	FROM	SCP_MST_CAPA_SPEED_PLAN A WITH(NOLOCK)
            JOIN @tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN B ON
					    A.DIVISION_ID		= B.DIVISION_ID
				    AND A.COMPANY_ID		= B.COMPANY_ID
				    AND A.SITE_ID			= B.SITE_ID
				    AND A.PLANT_ID			= B.PLANT_ID
				    AND A.FACTORY_ID		= B.FACTORY_ID
				    AND A.LINE_ID			= B.LINE_ID
				    AND A.OPERATION_ID		= B.OPERATION_ID
				    AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
                    AND A.NICK_NAME         = B.NICK_NAME
	WHERE	1=1
		AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		--AND ((@p_item_id	    IS NULL OR @p_item_id   		= '') OR (A.ITEM_ID LIKE '%' + @p_item_id + '%') OR (A.NICK_NAME LIKE '%' + @p_item_id + '%'))
		AND (((@p_item_id	    IS NULL OR @p_item_id	        = '') OR A.ITEM_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_item_id, ',')))
                                                                      OR A.NICK_NAME      IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_item_id, ',')))
--TESTING : NOK
--select * from @tblSCP0105_RAW_ALL_TEMP WHERE YYYYMM = '202404';return;


	DECLARE @tblSCP0105_RAW_ALL TABLE
	(
		  VER_ID					NVARCHAR(10)	NOT NULL
		, VER_SEQ					TINYINT			NOT NULL
		, DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, ITEM_ID					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, SPEED_UNIT_GROUP			NVARCHAR(30)	NOT NULL
		, MSR_TP_CD					NVARCHAR(50)	NOT NULL
		, YYYYMM					NVARCHAR(6)		NOT NULL
		, PFRSLT_QTY				NUMERIC(20, 10)
		, BASE_QTY					NUMERIC(20, 10)
		, QTY						NUMERIC(20, 10)
	)

    INSERT INTO @tblSCP0105_RAW_ALL
	SELECT	  A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.ITEM_ID
			, A.NICK_NAME
            , G.UNIT_GROUP                              AS SPEED_UNIT_GROUP
            --, A.MSR_TP_CD
	        , CASE
			    WHEN G.UNIT_GROUP = 'EQP_SPED' THEN
				    CASE
					    WHEN A.OPERATION_ID = 'A5000'									THEN 'MMS'
					    WHEN A.OPERATION_ID = 'A7000'									THEN 'CPM'
					    WHEN A.OPERATION_ID = 'A8000' AND A.ELTR_LN_TP_CD = 'Folding'	THEN 'PPM_AVG'
					    ELSE 'TTT'
				    END
                WHEN G.UNIT_GROUP = 'PPM' THEN 'PPM'
			    ELSE A.MSR_TP_CD
		        END AS MSR_TP_CD
			, A.YYYYMM
            , A.PFRSLT_QTY                                AS PFRSLT_QTY
            , A.BASE_QTY
            , A.QTY
	FROM	@tblSCP0105_RAW_ALL_TEMP A
            JOIN @tblSCP0105_SPEED_UNIT_GROUP G ON
                    1=1

--TESTING : NOK
--select * from SCP_MST_CAPA_SPEED_PLAN;
--select * from @tblSCP0105_RAW_ALL;return;
--select * from @tblSCP0105_SPEED_UNIT_GROUP;return;
--select * from @tblSCP0105_RAW_ALL_TEMP WHERE YYYYMM = '202404' AND ELTR_LN_TP_CD = 'Anode';--return;
--select * from @tblSCP0105_RAW_ALL WHERE YYYYMM = '202404';return;

    DECLARE @tblSCP0105_RAW_KEYS TABLE
	(
		  VER_ID					NVARCHAR(10)	NOT NULL
		, VER_SEQ					TINYINT			NOT NULL
		, DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, ITEM_ID					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, SPEED_UNIT_GROUP			NVARCHAR(30)	NOT NULL
		, MSR_TP_CD					NVARCHAR(50)	NOT NULL
		, YYYYMM					NVARCHAR(6)		NOT NULL
	)

        INSERT INTO @tblSCP0105_RAW_KEYS
	    SELECT	  A.VER_ID
			    , A.VER_SEQ
			    , A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.ITEM_ID
			    , A.NICK_NAME
                , A.SPEED_UNIT_GROUP
		        , A.MSR_TP_CD
			    , A.YYYYMM
	    FROM	@tblSCP0105_RAW_ALL A
        WHERE   1=1
                AND (A.SPEED_UNIT_GROUP  = 'EQP_NBU'    AND A.MSR_TP_CD IN ('EQP_NBU') OR
                     A.SPEED_UNIT_GROUP  = 'PPM'        AND A.MSR_TP_CD IN ('PPM') OR
                     A.SPEED_UNIT_GROUP  = 'EQP_SPED'   AND A.MSR_TP_CD IN ('MMS', 'CPM', 'PPM_AVG', 'TTT'))
        GROUP BY  A.VER_ID
			    , A.VER_SEQ
			    , A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.ITEM_ID
			    , A.NICK_NAME
                , A.SPEED_UNIT_GROUP
		        , A.MSR_TP_CD
			    , A.YYYYMM

--TESTING : NOK
--select * from @tblSCP0105_RAW_KEYS WHERE NICK_NAME = 'TEST DUMMY!!' and YYYYMM = '202403';
--select * from @tblSCP0105_RAW_KEYS WHERE YYYYMM = '202404';return;


    DECLARE @tblSCP0105_RAW_TEMP TABLE
	(
		  VER_ID					NVARCHAR(10)	NOT NULL
		, VER_SEQ					TINYINT			NOT NULL
		, DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, ITEM_ID					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, SPEED_UNIT_GROUP			NVARCHAR(30)	NOT NULL
		, MSR_TP_CD					NVARCHAR(50)	NOT NULL
		, YYYYMM					NVARCHAR(6)		NOT NULL
		, BASE_QTY					NUMERIC(20, 10)
		, R_PFRSLT_QTY				NUMERIC(20, 10)
		, B_BASE_QTY				NUMERIC(20, 10)
		, R_PFRSLT_SPEED			NUMERIC(20, 10)
		, B_BASE_SPEED				NUMERIC(20, 10)
		, ELTR_QTY					NUMERIC(20, 10)
		, ELTR_PCH_LEN				NUMERIC(20, 10)
		, MMS_CF					NUMERIC(20, 10)
		, QTY						NUMERIC(20, 10)
		, UI_UPD_YN					NVARCHAR(1)
	)

    INSERT INTO @tblSCP0105_RAW_TEMP
	SELECT	  A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.ITEM_ID
			, A.NICK_NAME
            , A.SPEED_UNIT_GROUP
	        , A.MSR_TP_CD
			, A.YYYYMM
            , X.BASE_QTY
            , R.EQP_NBU                                 AS R_PFRSLT_QTY
            , B.EQP_NBU                                 AS B_BASE_QTY
            , R.EQP_SPED                                AS R_PFRSLT_SPEED
            , B.EQP_SPED                                AS B_BASE_SPEED
            , Q.ELTR_QTY                                AS ELTR_QTY
            , Q.ELTR_PCH_LEN                            AS ELTR_PCH_LEN
            , Q.ELTR_QTY * Q.ELTR_PCH_LEN               AS MMS_CF
            , X.QTY
			, ISNULL(BU.UI_UPD_YN, 'Y')                 AS UI_UPD_YN
	FROM	@tblSCP0105_RAW_KEYS A
            LEFT JOIN @tblSCP0105_RAW_ALL_TEMP X ON
				    A.VER_ID				= X.VER_ID
                AND A.VER_SEQ				= X.VER_SEQ
                AND A.DIVISION_ID			= X.DIVISION_ID
                AND A.COMPANY_ID			= X.COMPANY_ID
                AND A.SITE_ID				= X.SITE_ID
                AND A.PLANT_ID				= X.PLANT_ID
                AND A.FACTORY_ID			= X.FACTORY_ID
                AND A.LINE_ID				= X.LINE_ID
                AND A.OPERATION_ID			= X.OPERATION_ID
                AND A.ELTR_LN_TP_CD			= X.ELTR_LN_TP_CD
                AND A.ITEM_ID				= X.ITEM_ID
                AND A.NICK_NAME				= X.NICK_NAME
                AND A.MSR_TP_CD				= X.MSR_TP_CD
                AND A.YYYYMM				= X.YYYYMM
			LEFT JOIN @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_RESULT R ON
					A.DIVISION_ID		                            = R.DIVISION_ID
				AND A.COMPANY_ID		                            = R.COMPANY_ID
				AND A.SITE_ID			                            = R.SITE_ID
				AND A.PLANT_ID			                            = R.PLANT_ID
				AND A.FACTORY_ID		                            = R.FACTORY_ID
				AND A.LINE_ID			                            = R.LINE_ID
				AND A.OPERATION_ID		                            = R.OPERATION_ID
				AND IIF(A.ITEM_ID = '-', A.NICK_NAME, A.ITEM_ID)    = R.NICK_NAME
				AND A.ELTR_LN_TP_CD	                                = R.ELTR_LN_TP_CD
                --AND A.SPEED_UNIT_GROUP                              = R.SPEED_UNIT_GROUP
                --AND A.MSR_TP_CD                                     = R.MSR_TP_CD
			LEFT JOIN @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE B ON
					A.DIVISION_ID		                            = B.DIVISION_ID
				AND A.COMPANY_ID		                            = B.COMPANY_ID
				AND A.SITE_ID			                            = B.SITE_ID
				AND A.PLANT_ID			                            = B.PLANT_ID
				AND A.FACTORY_ID		                            = B.FACTORY_ID
				AND A.LINE_ID			                            = B.LINE_ID
				AND A.OPERATION_ID		                            = B.OPERATION_ID
				AND IIF(A.ITEM_ID = '-', A.NICK_NAME, A.ITEM_ID)    = B.NICK_NAME
				AND A.ELTR_LN_TP_CD	                                = B.ELTR_LN_TP_CD
                --AND A.SPEED_UNIT_GROUP                              = B.SPEED_UNIT_GROUP
                --AND A.MSR_TP_CD                                     = B.MSR_TP_CD
            LEFT JOIN @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_CF Q ON
					IIF(A.ITEM_ID = '-', A.NICK_NAME, A.ITEM_ID)    = Q.NICK_NAME
                AND A.ELTR_LN_TP_CD = Q.ELTR_LN_TP_CD
			LEFT JOIN @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE_UI_UPD_YN BU ON
					A.DIVISION_ID		                            = BU.DIVISION_ID
				AND A.COMPANY_ID		                            = BU.COMPANY_ID
				AND A.SITE_ID			                            = BU.SITE_ID
				AND A.PLANT_ID			                            = BU.PLANT_ID
				AND A.FACTORY_ID		                            = BU.FACTORY_ID
				AND A.LINE_ID			                            = BU.LINE_ID
				AND A.OPERATION_ID		                            = BU.OPERATION_ID
				AND IIF(A.ITEM_ID = '-', A.NICK_NAME, A.ITEM_ID)    = BU.NICK_NAME
				AND A.ELTR_LN_TP_CD	                                = BU.ELTR_LN_TP_CD

--TESTING : NOK
--select * from @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_RESULT;
--select * from @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE;
--select * from @tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_CF;
--select * from @tblSCP0105_RAW_TEMP WHERE YYYYMM = '202404';return;

    DECLARE @tblSCP0105_RAW_TEMP_QTY TABLE
	(
		  VER_ID					NVARCHAR(10)	NOT NULL
		, VER_SEQ					TINYINT			NOT NULL
		, DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, ITEM_ID					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, SPEED_UNIT_GROUP			NVARCHAR(30)	NOT NULL
		, MSR_TP_CD					NVARCHAR(50)	NOT NULL
		, YYYYMM					NVARCHAR(6)		NOT NULL
		, R_PFRSLT_QTY				NUMERIC(20, 10)
		, B_BASE_QTY				NUMERIC(20, 10)
		, R_PFRSLT_SPEED			NUMERIC(20, 10)
		, B_BASE_SPEED				NUMERIC(20, 10)
		, ELTR_QTY					NUMERIC(20, 10)
		, ELTR_PCH_LEN				NUMERIC(20, 10)
		, MMS_CF					NUMERIC(20, 10)
		, QTY						NUMERIC(20, 10)
		, UI_UPD_YN					NVARCHAR(1)
	)

	INSERT INTO @tblSCP0105_RAW_TEMP_QTY
	SELECT	  A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.ITEM_ID
			, A.NICK_NAME
			, A.SPEED_UNIT_GROUP
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.R_PFRSLT_QTY
			, A.B_BASE_QTY
			, A.R_PFRSLT_SPEED
			, A.B_BASE_SPEED
			, A.ELTR_QTY
			, A.ELTR_PCH_LEN
			, A.MMS_CF
			, A.QTY
			, A.UI_UPD_YN
	FROM    @tblSCP0105_RAW_TEMP A
	WHERE   1=1
		AND A.SPEED_UNIT_GROUP = 'EQP_NBU';

--TESTING : NOK
--select * from @tblSCP0105_RAW_TEMP_QTY WHERE YYYYMM = '202404';return;

    DECLARE @tblSCP0105_RAW_TEMP_SPEED TABLE
	(
		  VER_ID					NVARCHAR(10)	NOT NULL
		, VER_SEQ					TINYINT			NOT NULL
		, DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, ITEM_ID					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, SPEED_UNIT_GROUP			NVARCHAR(30)	NOT NULL
		, MSR_TP_CD					NVARCHAR(50)	NOT NULL
		, YYYYMM					NVARCHAR(6)		NOT NULL
		, R_PFRSLT_QTY				NUMERIC(20, 10)
		, B_BASE_QTY				NUMERIC(20, 10)
		, R_PFRSLT_SPEED			NUMERIC(20, 10)
		, B_BASE_SPEED				NUMERIC(20, 10)
		, ELTR_QTY					NUMERIC(20, 10)
		, ELTR_PCH_LEN				NUMERIC(20, 10)
		, MMS_CF					NUMERIC(20, 10)
		, SPEED						NUMERIC(20, 10)
		, UI_UPD_YN					NVARCHAR(1)
	)

	INSERT INTO @tblSCP0105_RAW_TEMP_SPEED
	SELECT	  A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.ITEM_ID
			, A.NICK_NAME
			, A.SPEED_UNIT_GROUP
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.R_PFRSLT_QTY
			, A.B_BASE_QTY
			, A.R_PFRSLT_SPEED
			, A.B_BASE_SPEED
			, A.ELTR_QTY
			, A.ELTR_PCH_LEN
			, A.MMS_CF
			, ISNULL(A.QTY, B_BASE_SPEED)                             AS SPEED
			, A.UI_UPD_YN
	FROM    @tblSCP0105_RAW_TEMP A
	WHERE   1=1
		AND A.SPEED_UNIT_GROUP = 'EQP_SPED';

--TESTING : NOK
--select * from @tblSCP0105_RAW_TEMP_SPEED WHERE YYYYMM = '202404';return;


    DECLARE @tblSCP0105_RAW_TEMP1 TABLE
	(
		  VER_ID					NVARCHAR(10)	NOT NULL
		, VER_SEQ					TINYINT			NOT NULL
		, DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, ITEM_ID					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, SPEED_UNIT_GROUP			NVARCHAR(30)	NOT NULL
		, MSR_TP_CD					NVARCHAR(50)	NOT NULL
		, YYYYMM					NVARCHAR(6)		NOT NULL
		, PFRSLT_QTY				NUMERIC(20, 10)
		, BASE_QTY					NUMERIC(20, 10)
		, QTY						NUMERIC(20, 10)
		, ELTR_QTY					NUMERIC(20, 10)
		, MMS_CF					NUMERIC(20, 10)
		, SPEED						NUMERIC(20, 10)
		, EQP_NBU					NUMERIC(20, 10)
		, UI_UPD_YN					NVARCHAR(1)
	)

	INSERT INTO @tblSCP0105_RAW_TEMP1
	SELECT	  A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.ITEM_ID
			, A.NICK_NAME
            , A.SPEED_UNIT_GROUP
			, A.MSR_TP_CD
			, A.YYYYMM
            , CASE 
                WHEN A.SPEED_UNIT_GROUP = 'EQP_SPED' THEN A.R_PFRSLT_SPEED
                WHEN A.SPEED_UNIT_GROUP = 'EQP_NBU'  THEN A.R_PFRSLT_QTY
                ELSE --PPM
                    CASE
                        WHEN A.OPERATION_ID = 'A5000'									THEN --'MMS'
                            ((A.R_PFRSLT_SPEED * 60) / IIF(A.MMS_CF = 0, 1, A.MMS_CF)) * A.R_PFRSLT_QTY
                        WHEN A.OPERATION_ID = 'A7000'									THEN --'CPM'
                            A.R_PFRSLT_SPEED / IIF(A.ELTR_QTY = 0, 1, A.ELTR_QTY) *  A.R_PFRSLT_QTY
                        WHEN A.OPERATION_ID = 'A8000' AND A.ELTR_LN_TP_CD = 'Folding'	THEN --'PPM_AVG'
                            NULL
                        ELSE                                                                 --'TTT'
                            60 / IIF(A.R_PFRSLT_SPEED = 0, 1, A.R_PFRSLT_SPEED)  * A.R_PFRSLT_QTY
                    END
                END AS PFRSLT_QTY
            , CASE --UI_UPD_YN = 'Y'이면 Speed Plan 저장된 값, 아니면 Base 실시간 조회값
                WHEN A.UI_UPD_YN = 'Y' THEN A.BASE_QTY
                ELSE
                    CASE 
                        WHEN A.SPEED_UNIT_GROUP = 'EQP_SPED' THEN A.B_BASE_SPEED
                        WHEN A.SPEED_UNIT_GROUP = 'EQP_NBU'  THEN A.B_BASE_QTY
                        ELSE --PPM
                            CASE
                                WHEN A.OPERATION_ID = 'A5000'									THEN --'MMS'
                                    ((A.B_BASE_SPEED * 60) / IIF(A.MMS_CF = 0, 1, A.MMS_CF)) * A.B_BASE_QTY
                                WHEN A.OPERATION_ID = 'A7000'									THEN --'CPM'
                                    A.B_BASE_SPEED / IIF(A.ELTR_QTY = 0, 1, A.ELTR_QTY) *  A.B_BASE_QTY
                                WHEN A.OPERATION_ID = 'A8000' AND A.ELTR_LN_TP_CD = 'Folding'	THEN --'PPM_AVG'
                                    NULL
                                ELSE                                                                 --'TTT'
                                    60 / IIF(A.B_BASE_SPEED = 0, 1, A.B_BASE_SPEED) * A.B_BASE_QTY
                            END
                    END
                END AS BASE_QTY
            , CASE --UI_UPD_YN = 'Y'이면 Speed Plan 저장된 값, 아니면  실시간 조회값
                WHEN A.UI_UPD_YN = 'Y' THEN A.QTY
                ELSE
                    CASE 
                        WHEN A.SPEED_UNIT_GROUP = 'EQP_SPED' THEN S.SPEED
                        WHEN A.SPEED_UNIT_GROUP = 'EQP_NBU'  THEN Q.QTY
                        ELSE --PPM
                            CASE
                                WHEN A.OPERATION_ID = 'A5000'									THEN --'MMS'
                                    ((S.SPEED * 60) / IIF(A.MMS_CF = 0, 1, A.MMS_CF)) * Q.QTY
                                WHEN A.OPERATION_ID = 'A7000'									THEN --'CPM'
                                    S.SPEED / IIF(A.ELTR_QTY = 0, 1, A.ELTR_QTY) * Q.QTY
                                WHEN A.OPERATION_ID = 'A8000' AND A.ELTR_LN_TP_CD = 'Folding'	THEN --'PPM_AVG'
                                    NULL
                                ELSE                                                                 --'TTT'
                                    60 / IIF(S.SPEED = 0, 1, S.SPEED) * Q.QTY
                            END
                    END
              END AS QTY
            , A.ELTR_QTY
            , A.MMS_CF
            , S.SPEED
            , Q.QTY AS EQP_NBU
            , A.UI_UPD_YN
    FROM    @tblSCP0105_RAW_TEMP A
            LEFT JOIN @tblSCP0105_RAW_TEMP_QTY Q ON
				    A.VER_ID		    = Q.VER_ID
				AND A.VER_SEQ		    = Q.VER_SEQ
				AND A.DIVISION_ID		= Q.DIVISION_ID
				AND A.COMPANY_ID		= Q.COMPANY_ID
				AND A.SITE_ID			= Q.SITE_ID
				AND A.PLANT_ID			= Q.PLANT_ID
				AND A.FACTORY_ID		= Q.FACTORY_ID
				AND A.LINE_ID			= Q.LINE_ID
				AND A.OPERATION_ID		= Q.OPERATION_ID
				AND A.ELTR_LN_TP_CD	    = Q.ELTR_LN_TP_CD
				AND A.NICK_NAME	        = Q.NICK_NAME
				AND A.YYYYMM	        = Q.YYYYMM
            LEFT JOIN @tblSCP0105_RAW_TEMP_SPEED S ON
				    A.VER_ID		    = S.VER_ID
				AND A.VER_SEQ		    = S.VER_SEQ
				AND A.DIVISION_ID		= S.DIVISION_ID
				AND A.COMPANY_ID		= S.COMPANY_ID
				AND A.SITE_ID			= S.SITE_ID
				AND A.PLANT_ID			= S.PLANT_ID
				AND A.FACTORY_ID		= S.FACTORY_ID
				AND A.LINE_ID			= S.LINE_ID
				AND A.OPERATION_ID		= S.OPERATION_ID
				AND A.ELTR_LN_TP_CD	    = S.ELTR_LN_TP_CD
				AND A.NICK_NAME	        = S.NICK_NAME
				AND A.YYYYMM	        = S.YYYYMM
            --JOIN @tblSCP0105_MEASURE M ON
            --        A.MSR_TP_CD    = M.MEASURE;

--TESTING : NOK
--SELECT 260.0000000000 / 32.0000000000 * 11.0000000000
--select (1000.0000000000 * 60) / (3158.1000000000 * 2.0000000000)
--select * from @tblSCP0105_RAW_TEMP WHERE YYYYMM = '202404';
--select * from @tblSCP0105_RAW_TEMP_QTY WHERE YYYYMM = '202404';
--select * from @tblSCP0105_RAW_TEMP_SPEED WHERE YYYYMM = '202404';
--select * from @tblSCP0105_RAW_TEMP1 WHERE YYYYMM = '202404';return;

	DECLARE @tblSCP0105_RAW_TEMP2 TABLE
	(
		  VER_ID					NVARCHAR(10)	NOT NULL
		, VER_SEQ					TINYINT			NOT NULL
		, DIVISION_ID				NVARCHAR(30)	NOT NULL
		, COMPANY_ID				NVARCHAR(30)	NOT NULL
		, SITE_ID					NVARCHAR(30)	NOT NULL
		, PLANT_ID					NVARCHAR(30)	NOT NULL
		, FACTORY_ID				NVARCHAR(30)	NOT NULL
		, LINE_ID					NVARCHAR(30)	NOT NULL
		, OPERATION_ID				NVARCHAR(30)	NOT NULL
		, ELTR_LN_TP_CD				NVARCHAR(30)	NOT NULL
		, ITEM_ID					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, NICK_NAME					NVARCHAR(100)	NOT NULL DEFAULT '-'
		, SPEED_UNIT_GROUP			NVARCHAR(30)	NOT NULL
		, MSR_TP_CD					NVARCHAR(50)	NOT NULL
		, YYYYMM					NVARCHAR(6)		NOT NULL
		, UI_UPD_YN					NVARCHAR(1)
		, PFRSLT_QTY				NUMERIC(20, 10)
		, BASE_QTY					NUMERIC(20, 10)
		, QTY						NUMERIC(20, 10)
		, ELTR_QTY					NUMERIC(20, 10)
		, MMS_CF					NUMERIC(20, 10)
	)

	INSERT INTO @tblSCP0105_RAW_TEMP2
	SELECT	  A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.ITEM_ID
			, A.NICK_NAME
			, A.SPEED_UNIT_GROUP
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.UI_UPD_YN
			, AVG(ISNULL(A.PFRSLT_QTY, 0.0)) AS PFRSLT_QTY
			, AVG(ISNULL(A.BASE_QTY, 0.0))   AS BASE_QTY
			, AVG(ISNULL(A.QTY, 0.0))        AS QTY
			, AVG(ISNULL(A.ELTR_QTY, 0.0))   AS ELTR_QTY
			, AVG(ISNULL(A.MMS_CF, 0.0))     AS MMS_CF
	FROM    @tblSCP0105_RAW_TEMP1 A
	GROUP BY  A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.ITEM_ID
			, A.NICK_NAME
			, A.SPEED_UNIT_GROUP
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.UI_UPD_YN
--TESTING : NOK
--select * from @tblSCP0105_RAW_TEMP1 WHERE NICK_NAME = 'TEST DUMMY!!' AND YYYYMM = '202403';
--select * from @tblSCP0105_RAW_TEMP2 WHERE NICK_NAME = 'TEST DUMMY!!' AND YYYYMM = '202403';
--select * from @tblSCP0105_RAW_TEMP2 WHERE NICK_NAME = 'TEST DUMMY!!' and YYYYMM = '202403';
--select * from @tblSCP0105_RAW_TEMP2 WHERE YYYYMM = '202404';return;


        INSERT INTO @TBL_RES
	    SELECT	  A.VER_ID
			    , A.VER_SEQ
			    , A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.ITEM_ID
			    , A.NICK_NAME
                , A.SPEED_UNIT_GROUP
			    , A.MSR_TP_CD
			    , A.YYYYMM
                , A.PFRSLT_QTY
                , A.BASE_QTY
                , A.QTY
                , A.ELTR_QTY
                , A.MMS_CF
                , A.UI_UPD_YN
			    , CONVERT(NVARCHAR(2), @p_prog_stat) AS PROG_STAT
        FROM    @tblSCP0105_RAW_TEMP2 A
			    LEFT JOIN SCP_MST_CAPA_LINE B WITH(NOLOCK) ON
				        A.DIVISION_ID		= B.DIVISION_ID
				    AND A.COMPANY_ID		= B.COMPANY_ID
				    AND A.SITE_ID			= B.SITE_ID
				    AND A.PLANT_ID			= B.PLANT_ID
				    AND A.FACTORY_ID		= B.FACTORY_ID
				    AND A.LINE_ID			= B.LINE_ID
				    AND A.OPERATION_ID		= B.OPERATION_ID
				    AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
        WHERE   1=1
            --AND (A.SPEED_UNIT_GROUP  = 'EQP_NBU'    AND A.MSR_TP_CD IN ('EQP_NBU') OR
            --     A.SPEED_UNIT_GROUP  = 'PPM'        AND A.MSR_TP_CD IN ('PPM') OR
            --     A.SPEED_UNIT_GROUP  = 'EQP_SPED'   AND A.MSR_TP_CD IN ('MMS', 'CPM', 'PPM_AVG', 'TTT'))



--TESTING : NOK
--select * from @tblSCP0105_RAW --WHERE YYYYMM <= '202404';return;
--select * from @TBL_RES WHERE YYYYMM = '202404';return;


    RETURN;
END

