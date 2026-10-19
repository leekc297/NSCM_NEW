

/*
 * Program ID   : SCP0100_GET_GLOBAL_PSI_REPORT_MM_DATAONLY
 * Description  : GLOBAL PSI 조회
 * Program History
 *================================================================================================================================================
 *   Date       In Charge                           Description
 *================================================================================================================================================
 * 2023/10/12   hwyoon        V1.1.0                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2023/11/20   vadabi3                             PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - DIO 관련 정책 적용
 * 2023/11/23   vadabi3                             PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - A/S 정책
 * 2023/12/01   vadabi3                             PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Product Level 참조 개선 / rep_cell_item_id
 * 2023/12/18   vadabi3                             PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Operation Group Sort
 * 2023/12/19   vadabi3                             PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Operation 이슈 적용
 * 2023/12/19   vadabi3                             PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Pack/Cell 이슈
 * 2024/01/18   chaan         V1.2.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 조회오류 수정 및 개선
 * 2024/01/26   chaan         V1.2.2                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 로직 개선
 * 2024/01/30   chaan         V1.2.3                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 조회 오류 수정 - 중복 데이터 제거
 *                                                                                                              - Transport Lookup 타입 오류 수정 (TRANSPORT_MODE_CODE -> TRANSPORT_MODE_CODE_CODE)
 * 2024/02/21   chaan         V1.2.4                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - CELL_GROUP 없는 경우(CELL_GROUP 과 REP_CELL_ITEM_ID 가 같은 경우) CELL_GROUP_SORT_ORDER_NO 적용
 * 2024.08.21   cys     							고도화 (개선 및 재고 통제 프로세스 적용)	- Global PSI New 개선_재고통제프로세스관련.xlsx 개발 목록 참조(PI 김도형 선임)
========================================================================================================================================================== */

--CREATE PROCEDURE [dbo].[SCP0100_GET_GLOBAL_PSI_REPORT_MM_DATAONLY]
CREATE PROCEDURE [dbo].[SCP0100_GET_GLOBAL_PSI_REPORT_MM_DATAONLY_0804_ORG_dev]
	  @p_from_yyyymmdd			NVARCHAR(8)
	, @p_to_yyyymmdd			NVARCHAR(8)
	, @p_division_id            NVARCHAR(30)
	, @p_item_id				NVARCHAR(MAX)
	, @p_nick_name				NVARCHAR(MAX)
	, @p_from_site				NVARCHAR(MAX)
	, @p_to_site				NVARCHAR(MAX)
	, @p_plan_start_yyyymmdd	NVARCHAR(8)
	, @p_plan_type				NVARCHAR(50)
	, @p_user_id				NVARCHAR(MAX)
	, @p_bucket				    NVARCHAR(10)
	, @p_cell_group			    NVARCHAR(MAX)
	, @p_project			    NVARCHAR(MAX)
	, @p_search_level			NVARCHAR(MAX)
	, @p_chk_cell_qty			NVARCHAR(1)
	, @p_chk_as			        NVARCHAR(1)
	, @debug_mode				NVARCHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--DECLARE @p_from_yyyymmdd			NVARCHAR(8)			= N'20240101';
	--DECLARE @p_to_yyyymmdd				NVARCHAR(8)			= N'20240331';
	--DECLARE @p_division_id				NVARCHAR(30)		= N'81';
	--DECLARE @p_item_id					NVARCHAR(MAX)		= N'';
	--DECLARE @p_nick_name				NVARCHAR(MAX)		= N'';
	--DECLARE @p_from_site				NVARCHAR(MAX)		= N'';
	--DECLARE @p_to_site					NVARCHAR(MAX)		= N'';
	--DECLARE @p_plan_start_yyyymmdd		NVARCHAR(8)			= N'20240122';
	--DECLARE @p_plan_type				NVARCHAR(50)		= N'FN';
	--DECLARE @p_user_id					NVARCHAR(MAX)		= N'iamarock';
	--DECLARE @p_bucket				    NVARCHAR(10)		= N'MONTHLY';
	--DECLARE @p_cell_group			    NVARCHAR(MAX)		= N'';
	--DECLARE @p_project					NVARCHAR(MAX)		= N'';
	----DECLARE @p_search_level				NVARCHAR(MAX)		= N'DETAIL';
	--DECLARE @p_search_level				NVARCHAR(MAX)		= N'CELL_GROUP';
	----DECLARE @p_search_level				NVARCHAR(MAX)		= N'PRODUCT_LEVEL1';
	----DECLARE @p_search_level				NVARCHAR(MAX)		= N'PRODUCT_LEVEL2';
	----DECLARE @p_search_level				NVARCHAR(MAX)		= N'PRODUCT_LEVEL3';
	--DECLARE @p_chk_cell_qty				NVARCHAR(1)			= N'Y';
	--DECLARE @p_chk_as			        NVARCHAR(1)			= N'N';
	--DECLARE @debug_mode					NVARCHAR(1)			= N'F';


    DECLARE @p_program_id               NVARCHAR(MAX)		= 'SCP0100';
    DECLARE @p_sheet_name               NVARCHAR(MAX)		= 'Global PSI NEW';

    DECLARE @v_sheet_name               NVARCHAR(MAX)       = '';

    IF @p_search_level IN('DETAIL', 'AUTO')
    BEGIN
        SET @v_sheet_name       = 'REPORT';
    END
    ELSE
    BEGIN
        SET @v_sheet_name       = 'SEARCH_LEVEL';
    END

--PRINT CONCAT('@v_sheet_name : ', @v_sheet_name);return;


    DECLARE @v_final_cols 		        NVARCHAR(MAX)       = '';
    DECLARE @v_final_order_cols 		NVARCHAR(MAX)       = '';
    DECLARE @v_final_sum_cols           NVARCHAR(MAX)       = '';
    DECLARE @v_final_sum_wheres         NVARCHAR(MAX)       = '';
	DECLARE @v_day_cols					NVARCHAR(MAX)       = '';
	DECLARE @v_qty_cols				    NVARCHAR(MAX)       = '';

	SELECT    @v_final_cols         = @v_final_cols         + ',' + COLUMN_NAME
            , @v_final_order_cols   = @v_final_order_cols   + ',' + COLUMN_NAME
	FROM    dbo.FN_GET_REPORT_USER_COLUMNS(@p_program_id, @v_sheet_name, @p_user_id);

--PRINT CONCAT('@v_final_cols : ',        @v_final_cols);
--PRINT CONCAT('@v_final_order_cols : ',  @v_final_order_cols);return;

    SET @v_final_cols       = SUBSTRING(@v_final_cols, 2, LEN(@v_final_cols)-1);
    SET @v_final_cols       = REPLACE(@v_final_cols, 'MEASURE_NAME',    'SORT_ORDER_NO,MEASURE_NAME');
    SET @v_final_cols       = REPLACE(@v_final_cols, ',CELL_GROUP',    ',CELL_GROUP_SORT_ORDER_NO,CELL_GROUP');


    SET @v_final_order_cols = SUBSTRING(@v_final_order_cols, 2, LEN(@v_final_order_cols)-1);

    SET @v_final_order_cols = REPLACE(@v_final_order_cols, ',MEASURE_GROUP',  '');
    SET @v_final_order_cols = REPLACE(@v_final_order_cols, 'MEASURE_NAME',    'SORT_ORDER_NO,MEASURE_NAME');
    SET @v_final_order_cols = REPLACE(@v_final_order_cols, 'OPERATION_GROUP', 'OPERATION_GROUP DESC');
    SET @v_final_order_cols = REPLACE(@v_final_order_cols, 'OPERATION_ID',    'OPERATION_ID DESC');
    SET @v_final_order_cols = REPLACE(@v_final_order_cols, ',CELL_GROUP',    ',CELL_GROUP_SORT_ORDER_NO,CELL_GROUP');
	
	IF @p_search_level IN ('CELL_GROUP', 'CELL_GROUP_DETAIL')
	BEGIN
		SET @v_final_order_cols = REPLACE(@v_final_order_cols, 'DIVISION_ID',    'DIVISION_ID,INV_SORT');
		SET @v_final_order_cols = REPLACE(@v_final_order_cols, ',CELL_GROUP_SORT_ORDER_NO',    '');	-- inv_sort 가 추가되어 필요없어짐
	END

    IF @p_search_level IN('DETAIL', 'AUTO')
    BEGIN
        SET @v_final_cols       = @v_final_cols       + ',DISPLAY_SEQ';
        SET @v_final_order_cols = @v_final_order_cols + ',DISPLAY_SEQ';
    END

    PRINT CONCAT('@v_final_order_cols : ', @v_final_order_cols);
    PRINT CONCAT('@v_final_cols : ', @v_final_cols);
--return;

    DECLARE @arr_item_id				VARCHAR(MAX);
	DECLARE @arr_from_site				VARCHAR(MAX);
	DECLARE @arr_to_site				VARCHAR(MAX);

	SELECT @arr_item_id     = ISNULL(@arr_item_id   + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_item_id,',')
    SELECT @arr_from_site   = ISNULL(@arr_from_site + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_from_site,',')
    SELECT @arr_to_site     = ISNULL(@arr_to_site   + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_to_site,',')

    DECLARE @v_from_yyyymmdd            NVARCHAR(8)     =   '';
    DECLARE @v_to_yyyymmdd              NVARCHAR(8)     =   '';
    DECLARE @v_from_yyyymm		        NVARCHAR(8)     =   '';
    DECLARE @v_to_yyyymm		        NVARCHAR(8)     =   '';
    DECLARE @v_from_result              NVARCHAR(8)     =   '';
    DECLARE @v_to_result                NVARCHAR(8)     =   '';
    DECLARE @v_from_ww			        NVARCHAR(8)     =   '';
    DECLARE @v_to_ww			        NVARCHAR(8)     =   '';

	DECLARE @v_sql		                NVARCHAR(MAX);


--TESTING : OK
--select * from dbo.FN_GET_REPORT_TERM_INFO(@p_plan_start_yyyymmdd, @p_from_yyyymmdd, @p_to_yyyymmdd);return;

    SELECT	  @v_from_yyyymmdd		= PLAN_FROM_YYYYMMDD
			, @v_to_yyyymmdd		= PLAN_TO_YYYYMMDD
			, @v_from_yyyymm		= PLAN_FROM_YYYYMM
			, @v_to_yyyymm			= PLAN_TO_YYYYMM
			, @v_from_result		= RESULT_FROM_YYYYMMDD
			, @v_to_result			= RESULT_TO_YYYYMMDD
			, @v_from_ww			= PLAN_PARTIAL_FROM_WW
			, @v_to_ww				= PLAN_PARTIAL_TO_WW
	FROM	dbo.FN_GET_REPORT_TERM_INFO(@p_plan_start_yyyymmdd, @p_from_yyyymmdd, @p_to_yyyymmdd);


	PRINT 'v_from_yyyymmdd =' +@v_from_yyyymmdd;
	PRINT 'v_to_yyyymmdd =' +@v_to_yyyymmdd;
	PRINT 'v_from_result =' +@v_from_result;
	PRINT 'v_to_result =' +@v_to_result	;
	PRINT 'v_from_yyyymm =' +@v_from_yyyymm;
	PRINT 'v_to_yyyymm =' +@v_to_yyyymm	;
--return;


	--################################################################################################################
	-- #tblSCP0100_MEASURE
	--################################################################################################################
	IF OBJECT_ID('tempdb..#tblSCP0100_MEASURE') IS NOT NULL
		DROP TABLE #tblSCP0100_MEASURE;

	;WITH USER_MEASURES AS (
			--- user별 설정한 조회 대상 measure
			SELECT UM.COLUMN_NAME			AS MEASURE_UI
				  ,M.COLUMN_LABEL_NAME		AS MEASURE_NAME
				  ,M.SMALL_CLASS_LABEL_NAME	AS MEASURE_GROUP
				  ,UM.SORT_ORDER_NO
			 FROM SCM_MST_TITLESET_USER UM WITH(NOLOCK)
				  INNER JOIN SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
						  ON M.PROGRAM_ID = @p_program_id
						 AND M.SHEET_NAME =@p_sheet_name
						 AND M.VALID_YN = 'Y'
						 AND M.COLUMN_NAME = UM.COLUMN_NAME
			WHERE 1=1
			  AND UM.USER_ID = @P_USER_ID
			  AND UM.PROGRAM_ID = @p_program_id
			  AND UM.SHEET_NAME = @p_sheet_name
	)
	,TARGET_MEASURES AS (
			--- user별 설정한 조회 대상 measure
			SELECT UM.MEASURE_UI
				  ,UM.MEASURE_NAME
				  ,UM.MEASURE_GROUP
				  ,UM.SORT_ORDER_NO
			  FROM USER_MEASURES UM  WITH(NOLOCK)
			UNION ALL
			--- user별 설정한 measure정보가 없을 경우 default measure를 보여준다.
			SELECT M.COLUMN_NAME		AS MEASURE_UI
				  ,M.COLUMN_LABEL_NAME	AS MEASURE_NAME
				  ,M.SMALL_CLASS_LABEL_NAME	AS MEASURE_GROUP
				  ,M.SORT_ORDER_NO
			 FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
			WHERE 1=1
			  AND M.PROGRAM_ID = @p_program_id
			  AND M.SHEET_NAME = @p_sheet_name
			  AND M.VALID_YN   = 'Y'
			  AND M.DEFAULT_FLAG = 'Y'
			  AND NOT EXISTS (SELECT 1
							   FROM USER_MEASURES WITH(NOLOCK)
							  WHERE 1=1
							  )
	)

	SELECT *
	INTO #tblSCP0100_MEASURE
	FROM TARGET_MEASURES WITH(NOLOCK)

	IF @p_chk_as = 'N'
	BEGIN
	    DELETE FROM #tblSCP0100_MEASURE WHERE MEASURE_GROUP = 'AS Sales PSI'
	END

	IF OBJECT_ID('tempdb..#tblSCP0100_MEASURE1') IS NOT NULL
		DROP TABLE #tblSCP0100_MEASURE1;

	-- 빈 table 생성
	SELECT  *
	INTO    #tblSCP0100_MEASURE1
	FROM    #tblSCP0100_MEASURE
	WHERE   1<>1

	IF @p_search_level = 'DETAIL'
    BEGIN
        INSERT INTO #tblSCP0100_MEASURE1
		SELECT  *
		FROM    #tblSCP0100_MEASURE
		WHERE   MEASURE_UI NOT IN ('PACK_PROD','CELL_PROD')
    END
    ELSE
    BEGIN
		INSERT INTO #tblSCP0100_MEASURE1
        SELECT  *
		FROM    #tblSCP0100_MEASURE
		WHERE   MEASURE_UI NOT IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN','PACK_PROD','CELL_PROD')
    END

--TESTING : OK
--select * from #tblSCP0100_MEASURE1;return;

	IF OBJECT_ID('tempdb..#tblSCP0100_MEASURE2') IS NOT NULL
		DROP TABLE #tblSCP0100_MEASURE2;

	SELECT  *
	INTO    #tblSCP0100_MEASURE2
	FROM    #tblSCP0100_MEASURE
	WHERE   MEASURE_UI IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')

--TESTING : OK
--select * from #tblSCP0100_MEASURE2;return;

	IF OBJECT_ID('tempdb..#tblSCP0100_MEASURE3') IS NOT NULL
		DROP TABLE #tblSCP0100_MEASURE3;

	SELECT  *
	INTO    #tblSCP0100_MEASURE3
	FROM    #tblSCP0100_MEASURE
	WHERE   MEASURE_UI IN ('PACK_PROD', 'CELL_PROD')

--TESTING : OK
--select * from #tblSCP0100_MEASURE;
--select * from #tblSCP0100_MEASURE1;
--select * from #tblSCP0100_MEASURE2;
--select * from #tblSCP0100_MEASURE3;return;


	--################################################################################################################
	-- #tblSCP0100_ProductLevel
	--################################################################################################################

	IF OBJECT_ID('tempdb..#tblSCP0100_ProductLevel') IS NOT NULL
		DROP TABLE #tblSCP0100_ProductLevel;

		SELECT    DIVISION_ID
			    , ITEM_ID
			    , FLOW_ID
			    , CASE
                    WHEN FLOW_ID = 'A9000'    THEN 'CELL'
                    WHEN FLOW_ID = 'P5500'    THEN 'MODULE'
					WHEN FLOW_ID = 'P5000'    THEN 'MODULE'
					WHEN FLOW_ID = 'P5200'    THEN 'MODULE'
                    WHEN FLOW_ID = 'P9500'    THEN 'PACK'
                    ELSE ''--P5000
                    END AS BIZ_TYPE
				,GROUP_CODE6
				,GROUP_CODE7
				,GROUP_CODE5
			    ,FINISHED_PRODUCT        AS BASIC_FINISHED_PRODUCT
		INTO #tblSCP0100_ProductLevel
		FROM SCP_MST_FINAL_ITEM A WITH(NOLOCK)
		--WHERE DIVISION_ID			=  @P_DIVISION_ID
		WHERE 1=1
		AND (
	   			(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   		)---@@@
	   	AND  DIVISION_ID LIKE '81%'---@@@

	--################################################################################################################
	-- #tblSCP0100_OPERATION
	--################################################################################################################

	IF OBJECT_ID('tempdb..#tblSCP0100_OPERATION') IS NOT NULL
		DROP TABLE #tblSCP0100_OPERATION;

		SELECT    DIVISION_ID
			    , ITEM_ID
			    , MAX(FLOW_ID) AS FLOW_ID
			    , CASE
                    WHEN MAX(FLOW_ID) = 'A9000'    THEN 'CELL'
                    WHEN MAX(FLOW_ID) = 'P5500'    THEN 'MODULE'
					WHEN MAX(FLOW_ID) = 'P5000'    THEN 'MODULE'
					WHEN MAX(FLOW_ID) = 'P5200'    THEN 'MODULE'
                    WHEN MAX(FLOW_ID) = 'P9500'    THEN 'PACK'
                    ELSE ''--P5000
                    END AS OPERATION
	    INTO #tblSCP0100_OPERATION
		FROM SCM_MST_ITEM_SN A WITH(NOLOCK)
		WHERE 1=1
		AND (
	   			(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   		)---고도화
	   	AND  DIVISION_ID LIKE '81%'---고도화
		and ACTIVE_FLAG = 'Y'
		and scp_operation_group != 'E'
		group by  DIVISION_ID,item_id


	--################################################################################################################
	--#tblSCP0100_Raw
	--################################################################################################################
	IF OBJECT_ID('tempdb..#tblSCP0100_Raw') IS NOT NULL
		DROP TABLE #tblSCP0100_Raw;

	SELECT	  MM.PLAN_START_YYYYMMDD
			, MM.DIVISION_ID
			, MM.YYYYMM
			, MM.ITEM_ID
			, CASE 
				WHEN MM.MEASURE = 'DIO' THEN 'P' 
				ELSE MM.OPERATION_GROUP
			  END AS OPERATION_GROUP
			, MM.MEASURE
			, MM.FROM_SITE
			, MM.TO_SITE
			, MM.INCOTERMS
			, MM.VARIOUS_KEY
			, MM.REP_CELL_ITEM_ID
			, MM.CELL_GROUP
            --, IIF(MM.MEASURE = 'DIO' OR MM.CELL_GROUP = MM.REP_CELL_ITEM_ID, 2, 1) AS CELL_GROUP_SORT_ORDER_NO
            --, IIF(MM.MEASURE <> 'DIO' AND MM.CELL_GROUP = MM.REP_CELL_ITEM_ID, 2, 1) AS CELL_GROUP_SORT_ORDER_NO
            , IIF(MM.ATTRIBUTE10 = 'Y', 1, 2) AS CELL_GROUP_SORT_ORDER_NO
			, MM.QTY
			, MM.FROM_BOH_QTY
			, MM.TO_BOH_QTY
			, MM.CELL_CF
			, MM.ATTRIBUTE3
			, CASE
				WHEN LV.GROUP_CODE6 = '' THEN '-'
				ELSE ISNULL(LV.GROUP_CODE6,'-')
			  END AS PRODUCT_LEVEL1
			, CASE
				WHEN LV.GROUP_CODE7 = '' THEN '-'
				ELSE ISNULL(LV.GROUP_CODE7,'-')
			  END AS PRODUCT_LEVEL2
			, CASE
				WHEN LV.GROUP_CODE5 = '' THEN '-'
				ELSE ISNULL(LV.GROUP_CODE5,'-')
			  END AS PRODUCT_LEVEL3
			--,ISNULL(LV.FLOW_ID,'-') AS FLOW_ID
			--,ISNULL(LV.FLOW_ID,'-') AS OPERATION_ID
			, ISNULL(OP.FLOW_ID,'-') AS FLOW_ID
			, ISNULL(OP.FLOW_ID,'-') AS OPERATION_ID
			, ISNULL(OP.OPERATION,'-') AS OPERATION_NAME
			, CASE 
				WHEN @p_chk_cell_qty = 'Y' AND QTY IS NOT NULL AND CELL_CF IS NOT NULL THEN ISNULL(QTY,0) * ISNULL(CELL_CF,0)
				ELSE QTY
			  END AS CELL_QTY
			--, isnull(qty,0) as cell_qty
			, CONVERT(NUMERIC,ISNULL(MM.ATTRIBUTE8,999)) AS INV_SORT
	INTO	#tblSCP0100_Raw
	FROM	SCP_RPT_GLOBAL_PSI_MD_MM MM WITH(NOLOCK)
			LEFT JOIN #tblSCP0100_ProductLevel LV ON 
					MM.DIVISION_ID	= LV.DIVISION_ID
				AND MM.attribute3	= LV.ITEM_ID
			-- AND MM.REP_CELL_ITEM_ID  	= LV.ITEM_ID
			LEFT JOIN #tblSCP0100_OPERATION OP ON 
					MM.DIVISION_ID	= OP.DIVISION_ID
				AND MM.item_id		= OP.ITEM_ID
	WHERE	1=1
		AND MM.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
		--AND MM.DIVISION_ID			= @p_division_id
		AND (
		  		(@p_division_id IS NULL OR  @p_division_id='' ) 
		  		OR MM.DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
		  	)---고도화
		AND  MM.DIVISION_ID LIKE '81%'---고도화
		AND MM.YYYYMM BETWEEN @v_from_yyyymm AND @v_to_yyyymm
		------ AND (( @p_operation_id	IS NULL OR @p_operation_id	= '') OR A.FLOW_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_operation_id	, ',')))
		------ AND (( @p_nickname		IS NULL OR @p_nickname		= '') OR A.NICK_NAME				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_nickname		, ',')))
		AND (( @p_item_id		IS NULL OR @p_item_id		= '') OR MM.ITEM_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id, ',')))
		AND (( @p_from_site		IS NULL OR @p_from_site		= '') OR MM.FROM_SITE		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site, ',')))
		AND (( @p_to_site		IS NULL OR @p_to_site		= '') OR MM.TO_SITE			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_to_site, ',')))
		AND (( @p_project		IS NULL OR @p_project		= '') OR MM.VARIOUS_KEY		LIKE '%' + @p_project + '%')
		AND (( @p_cell_group	IS NULL OR @p_cell_group	= '') OR MM.CELL_GROUP		LIKE '%' + @p_cell_group + '%')

		AND measure <> 'SEMI_WHIN'		-- 2025-05-12 Global PSI NEW WH_IN SEMI의 변경 (SCP_ANL_PSI_GLOBAL 데이터를 사용하지 않음)
		
		;

--TESTING : OK
--select * from SCP_RPT_GLOBAL_PSI_MD_MM MM WITH(NOLOCK)
--WHERE 1=1
--		AND MM.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
--		AND MM.DIVISION_ID			= @p_division_id
--		AND MM.YYYYMM BETWEEN @v_from_yyyymm AND @v_to_yyyymm
--		AND (( @p_item_id		IS NULL OR @p_item_id		= '') OR MM.ITEM_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id, ',')))
--		AND (( @p_from_site		IS NULL OR @p_from_site		= '') OR MM.FROM_SITE		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site, ',')))
--		AND (( @p_to_site		IS NULL OR @p_to_site		= '') OR MM.TO_SITE			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_to_site, ',')))
--		AND (( @p_project		IS NULL OR @p_project		= '') OR MM.VARIOUS_KEY		LIKE '%' + @p_project + '%')
--		AND (( @p_cell_group	IS NULL OR @p_cell_group	= '') OR MM.CELL_GROUP		LIKE '%' + @p_cell_group + '%');
--return;
--select * from #tblSCP0100_Raw;return;
--select * from #tblSCP0100_Raw where CELL_GROUP = 'ACEH1079I-A1T032';return;


	IF OBJECT_ID('tempdb..#tblSCP0100_CELL_GROUP_SORT_ORDER') IS NOT NULL
        DROP TABLE #tblSCP0100_CELL_GROUP_SORT_ORDER;

    SELECT    CELL_GROUP
            , MEASURE
            , CELL_GROUP_SORT_ORDER_NO
			, MAX(INV_SORT) AS INV_SORT
    INTO    #tblSCP0100_CELL_GROUP_SORT_ORDER
    FROM    #tblSCP0100_Raw
    GROUP BY  CELL_GROUP
            , MEASURE
            , CELL_GROUP_SORT_ORDER_NO;

--TESTING : NOK
--select * from #tblSCP0100_Raw;
--select * from #tblSCP0100_CELL_GROUP_SORT_ORDER;return;
	
	--################################################################################################################
	--#tblSCP0100_DIO_Detail_Raw
	--################################################################################################################
	IF OBJECT_ID('tempdb..#tblSCP0100_DIO_Detail_Raw') IS NOT NULL
		DROP TABLE #tblSCP0100_DIO_Detail_Raw;

	SELECT	  MM.PLAN_START_YYYYMMDD
			, MM.DIVISION_ID
			, MM.YYYYMM
			, MM.ITEM_ID
			, MM.OPERATION_GROUP	--, CASE WHEN MM.MEASURE = 'DIO_CELL' THEN 'A' ELSE 'P' END AS OPERATION_GROUP
			, MM.MEASURE
			, MM.FROM_SITE
			, MM.TO_SITE
			, MM.INCOTERMS
			, MM.VARIOUS_KEY
			, MM.REP_CELL_ITEM_ID
			, MM.CELL_GROUP
            --, IIF(MM.MEASURE = 'DIO' OR MM.CELL_GROUP = MM.REP_CELL_ITEM_ID, 2, 1) AS CELL_GROUP_SORT_ORDER_NO
            --, IIF(MM.MEASURE <> 'DIO' AND MM.CELL_GROUP = MM.REP_CELL_ITEM_ID, 2, 1) AS CELL_GROUP_SORT_ORDER_NO
            , IIF(MM.ATTRIBUTE10 = 'Y', 1, 2) AS CELL_GROUP_SORT_ORDER_NO
			, MM.QTY
			, MM.FROM_BOH_QTY
			, MM.TO_BOH_QTY
			, MM.CELL_CF
			, MM.ATTRIBUTE3
			, MM.PRODUCT_LEVEL1
			, MM.PRODUCT_LEVEL2
			, MM.PRODUCT_LEVEL3
			--,ISNULL(LV.FLOW_ID,'-') AS FLOW_ID
			--,ISNULL(LV.FLOW_ID,'-') AS OPERATION_ID
			, ISNULL(OP.FLOW_ID,'-') AS FLOW_ID
			, ISNULL(OP.FLOW_ID,'-') AS OPERATION_ID
			, ISNULL(OP.OPERATION,'-') AS OPERATION_NAME
			, CASE 
				WHEN @p_chk_cell_qty = 'Y' AND QTY IS NOT NULL AND CELL_CF IS NOT NULL THEN ISNULL(QTY,0) * ISNULL(CELL_CF,0)
				ELSE QTY
			  END AS CELL_QTY
			  , CONVERT(NUMERIC,ISNULL(MM.ATTRIBUTE8,999)) AS INV_SORT
	INTO	#tblSCP0100_DIO_Detail_Raw
	FROM	SCP_RPT_GLOBAL_PSI_MD_DETAIL_MM MM WITH(NOLOCK)
			LEFT JOIN #tblSCP0100_OPERATION OP ON 
					MM.DIVISION_ID	= OP.DIVISION_ID
				AND MM.item_id		= OP.ITEM_ID
	WHERE	1=1
		AND MM.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
		--AND MM.DIVISION_ID			= @p_division_id
		AND (
		  		(@p_division_id IS NULL OR  @p_division_id='' ) 
		  		OR MM.DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
		  	)---고도화
		AND  MM.DIVISION_ID LIKE '81%'---고도화
		AND MM.YYYYMM BETWEEN @v_from_yyyymm AND @v_to_yyyymm
		------ AND (( @p_operation_id	IS NULL OR @p_operation_id	= '') OR A.FLOW_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_operation_id	, ',')))
		------ AND (( @p_nickname		IS NULL OR @p_nickname		= '') OR A.NICK_NAME				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_nickname		, ',')))
		--AND (( @p_item_id		IS NULL OR @p_item_id		= '') OR MM.ITEM_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id, ',')))
		--AND (( @p_from_site		IS NULL OR @p_from_site		= '') OR MM.FROM_SITE		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site, ',')))
		--AND (( @p_to_site		IS NULL OR @p_to_site		= '') OR MM.TO_SITE			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_to_site, ',')))
		--AND (( @p_project		IS NULL OR @p_project		= '') OR MM.VARIOUS_KEY		LIKE '%' + @p_project + '%')
		AND (( @p_cell_group	IS NULL OR @p_cell_group	= '') OR MM.CELL_GROUP		LIKE '%' + @p_cell_group + '%');

		INSERT INTO    #tblSCP0100_CELL_GROUP_SORT_ORDER
	SELECT    CELL_GROUP
            , MEASURE
            , CELL_GROUP_SORT_ORDER_NO
			, MAX(INV_SORT) AS INV_SORT
    FROM    #tblSCP0100_DIO_Detail_Raw
    GROUP BY  CELL_GROUP
            , MEASURE
            , CELL_GROUP_SORT_ORDER_NO;

	--################################################################################################################
	--#tblSCP0100_DayCols
	--################################################################################################################
	IF OBJECT_ID('tempdb..#tblSCP0100_DayCols') IS NOT NULL
		DROP TABLE #tblSCP0100_DayCols;

	 	SELECT A.*
		INTO #tblSCP0100_DayCols
		FROM
		(
					SELECT  'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
					       ,MAX(A.BASIS_YYYYMM)  AS YYYYMM
						   ,MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
					  FROM  [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
					 WHERE  A.BASIS_YYYYMMDD  BETWEEN  @p_from_yyyymmdd AND @p_to_yyyymmdd
				  GROUP BY  A.BASIS_YYYYMM, A.MONTH_NAME
		) A

		SELECT    @v_day_cols          = @v_day_cols         + ',' + YYYYMMDD + CHAR(10)
                , @v_final_sum_cols    = @v_final_sum_cols   + ',MAX(' + YYYYMMDD + ') AS ' + YYYYMMDD
                , @v_final_sum_wheres  = @v_final_sum_wheres + 'ISNULL(' + YYYYMMDD + ', 0) <> 0 OR '
		FROM    #tblSCP0100_DayCols AS A
		ORDER BY sort_order_no;


        SET @v_final_sum_cols = SUBSTRING(@v_final_sum_cols, 2, LEN(@v_final_sum_cols) - 1);

        SET @v_final_sum_wheres = SUBSTRING(@v_final_sum_wheres, 1, LEN(@v_final_sum_wheres) - 3); -- 맨 뒤 ' OR ' 삭제

        SET @v_final_sum_wheres = N' AND
                                   (
                                      (MEASURE_UI     IN (''AS_INV'',''CELL_CHAR_AVAILABLE'',''CELL_EOH'',''CELL_FORM_PROGRESS'',''INTRANSIT'',''PACK_CELL_EOH'',''PACK_EOH'',''SEMI_INTRANSIT'',''TO_SITE_EOH''))
                                       OR 
                                      (MEASURE_UI NOT IN (''AS_INV'',''CELL_CHAR_AVAILABLE'',''CELL_EOH'',''CELL_FORM_PROGRESS'',''INTRANSIT'',''PACK_CELL_EOH'',''PACK_EOH'',''SEMI_INTRANSIT'',''TO_SITE_EOH''))
                                         AND (' + @v_final_sum_wheres + ')
                                   )';

PRINT CONCAT('@v_final_sum_cols : ',   @v_final_sum_cols);
PRINT CONCAT('@v_final_sum_wheres : ', @v_final_sum_wheres);
--return;

set @v_final_sum_wheres = '';
	--################################################################################################################
	--#tblSCP0100_TRANSPORT_MODE_CODE
	--################################################################################################################
	IF OBJECT_ID('tempdb..#tblSCP0100_TRANSPORT_MODE_CODE') IS NOT NULL
		DROP TABLE #tblSCP0100_TRANSPORT_MODE_CODE;

	SELECT	  SEGMENT1 AS CODE
			, SEGMENT2 AS  NAME
			, DISPLAY_SEQ
	INTO	#tblSCP0100_TRANSPORT_MODE_CODE
	FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	WHERE	1=1
		AND LOOKUP_TYPE = 'TRANSPORT_MODE_CODE'
		AND VALID_YN	= 'Y';

	--####################################################
	-- #tblSCP0100_LINE
	--####################################################
	IF OBJECT_ID('tempdb..#tblSCP0100_LINE') IS NOT NULL
		DROP TABLE #tblSCP0100_LINE;

	     SELECT YYYYMM
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,OPERATION_ID
			   ,PRODUCT_LEVEL1
			   ,PRODUCT_LEVEL2
			   ,PRODUCT_LEVEL3
			   ,ITEM_ID
			   ,TO_SITE
			   ,FROM_SITE
			   ,INCOTERMS
			   ,MEASURE
			   ,VARIOUS_KEY
		   INTO #tblSCP0100_LINE
	       FROM #tblSCP0100_Raw
	      WHERE 1 = 1
	        AND MEASURE in ('PACK_PROD', 'CELL_PROD')
			AND VARIOUS_KEY IS NOT NULL
			AND VARIOUS_KEY != ''
	   GROUP BY YYYYMM
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,OPERATION_ID
			   ,PRODUCT_LEVEL1
			   ,PRODUCT_LEVEL2
			   ,PRODUCT_LEVEL3
			   ,ITEM_ID
			   ,TO_SITE
			   ,FROM_SITE
			   ,INCOTERMS
			   ,MEASURE
			   ,VARIOUS_KEY

--TESTING : OK
--select * from #tblSCP0100_Raw;return
--select * from #tblSCP0100_LINE;return;


--################################################################################################################
-- 1, AUTO
--################################################################################################################
IF @p_search_level = 'AUTO'
BEGIN
			declare @p_sheet_name2 nvarchar(max) = 'REPORT'
			declare @col_list nvarchar(max) = ''
			declare @col_list2 nvarchar(max) = ''
			declare @col_list_auto nvarchar(max) = ''
			declare @col_where nvarchar(max) = ''
			declare @col_where_count nvarchar(max) = ''
			declare @mEXEC_AUTO nvarchar(max) = ''

			------------------------------
			-- #tblSCP0100_USER_COLS
			------------------------------
	IF OBJECT_ID('tempdb..#tblSCP0100_USER_COLS') IS NOT NULL
		DROP TABLE #tblSCP0100_USER_COLS;

			SELECT CASE WHEN b.column_name = 'MEASURE_NAME' THEN 'MEASURE'
			            ELSE b.column_name
						END AS column_name
				 , b.column_label_name
				 , U.SORT_ORDER_NO
			 INTO #tblSCP0100_USER_COLS
			 FROM scm_mst_sheet_columns b  WITH(NOLOCK)
	   INNER JOIN scm_mst_titleset_user u  WITH(NOLOCK) ON u.program_id = b.program_id
														AND u.sheet_name = b.sheet_name
														AND u.column_name = b.column_name
														AND u.user_id = @p_user_id
		    WHERE   b.program_id             = @p_program_id
			  AND   b.sheet_name             = @p_sheet_name2
			  AND   b.valid_yn				 = 'Y'
			  AND   b.visible_flag           = 'Y'
			  AND	ISNULL(b.ATTRIBUTE6,'Y') <>'N'
			  AND   b.column_name NOT IN ('MEASURE_GROUP', 'MEASURE', 'MEASURE_NAME', 'VARIOUS_KEY', 'CELL_CF')
			ORDER BY U.SORT_ORDER_NO;

			declare @cntVarious int = 0
			SELECT @cntVarious = count(*) from #tblSCP0100_USER_COLS where column_name = 'VARIOUS_KEY'
			IF @cntVarious = 0
			BEGIN
				DELETE FROM #tblSCP0100_TRANSPORT_MODE_CODE
			END

			------------------------------
			-- #tblSCP0100_USER_COLS 검증
			------------------------------
			SELECT @col_list		= STUFF((SELECT ', ' + column_name FROM #tblSCP0100_USER_COLS ORDER BY SORT_ORDER_NO FOR XML PATH('')  ),1,1,'')
			SELECT @col_list2		= STUFF((SELECT ', ' + concat('L.',column_name) FROM #tblSCP0100_USER_COLS ORDER BY SORT_ORDER_NO FOR XML PATH('')  ),1,1,'')
			SELECT @col_list_auto	= STUFF((SELECT ', ' + column_name FROM #tblSCP0100_USER_COLS WHERE column_name != 'OPERATION_GROUP' ORDER BY SORT_ORDER_NO FOR XML PATH('')  ),1,1,'')
			SELECT @col_where		= STUFF((SELECT '  AND ' + concat('L.',column_name , ' = T.', column_name) FROM #tblSCP0100_USER_COLS ORDER BY SORT_ORDER_NO FOR XML PATH('')  ),1,1,'')
			SELECT @col_where_count	= STUFF((SELECT '  AND ' + concat('A.',column_name , ' = ', column_name) FROM #tblSCP0100_USER_COLS ORDER BY SORT_ORDER_NO FOR XML PATH('')  ),1,1,'')


	 --********************************************************************************
	 --#@v_qty_cols
	 --********************************************************************************
	SELECT  @v_qty_cols    = @v_qty_cols + N'
                ,  (
                        SELECT TOP 1 
                                QTY
						FROM    #tblSCP0100_QTY_AUTO B
						WHERE   1=1
						        ' + @col_where_count + N'
							AND A.MEASURE_UI   = B.MEASURE_UI
							AND B.YYYYMM = ''' + YYYYMM + ''')  AS ' + YYYYMMDD
		FROM    #tblSCP0100_DayCols AS A
		ORDER BY SORT_ORDER_NO;

		SET @v_day_cols = RIGHT(@v_day_cols, LEN(@v_day_cols)-1);
		SET @v_qty_cols = RIGHT(@v_qty_cols, LEN(@v_qty_cols)-1);


		 --********************************************************************************
		 --#tblSCP0100_QTY_AUTO / RESULT
		 --********************************************************************************
			SET @v_sql = N'
	        IF OBJECT_ID(''tempdb..#tblSCP0100_QTY_AUTO'') IS NOT NULL
		        DROP TABLE #tblSCP0100_QTY_AUTO;

			 SELECT YYYYMM
				   ,' + @col_list + '
				   ,MEASURE           AS MEASURE_UI
				   ,SUM(CELL_QTY)     AS QTY
				   ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
				   ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			   INTO #tblSCP0100_QTY_AUTO
			   FROM #tblSCP0100_Raw
		   GROUP BY YYYYMM
				   ,' + @col_list + '
				   ,MEASURE;


		   CREATE INDEX IDX_TMP_LIST_QTY_AUTO ON #tblSCP0100_QTY_AUTO ( ' + @col_list + ' );

	        IF OBJECT_ID(''tempdb..#tblSCP0100_RAW_CELL_CF'') IS NOT NULL
		        DROP TABLE #tblSCP0100_RAW_CELL_CF;

			 SELECT ' + @col_list + '
				    ,MEASURE
				    ,VARIOUS_KEY
				    ,MAX(CELL_CF) AS CELL_CF
            INTO    #tblSCP0100_RAW_CELL_CF
			FROM #tblSCP0100_Raw L
			GROUP BY ' + @col_list + '
			        ,MEASURE
			        ,VARIOUS_KEY;

		SELECT   DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', OPERATION_GROUP) AS OPERATION_GROUP
		        ,' + @col_list_auto + '
				,CASE WHEN OPERATION_GROUP = ''A'' AND MEASURE_GROUP = ''Sales PSI'' THEN ''Cell Sales PSI''
				      ELSE MEASURE_GROUP
					  END AS MEASURE_GROUP
				,A.MEASURE_UI
				,A.MEASURE_NAME
				,CASE WHEN OPERATION_GROUP = ''A'' AND MEASURE_GROUP = ''Sales PSI'' THEN SORT_ORDER_NO + 20
				      ELSE SORT_ORDER_NO
					  END AS SORT_ORDER_NO
				,CODE
				,VARIOUS_KEY
				,DISPLAY_SEQ
				,CELL_CF
			   ' + @v_qty_cols + N'
		FROM
		(
				-----------------------------------------------
	 			 SELECT ' + @col_list + '
					   ,MG.MEASURE_GROUP AS MEASURE_GROUP
					   ,MG.MEASURE_UI    AS MEASURE_UI
					   ,MG.MEASURE_NAME  AS MEASURE_NAME
					   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO
				       ,CONVERT(NVARCHAR, NULL) AS CODE           -- UNION 시 NULL이면 에러 유발하므로 형변환
					   ,''-'' AS VARIOUS_KEY
					   ,1 AS DISPLAY_SEQ
					   ,CELL_CF
				   FROM #tblSCP0100_RAW_CELL_CF L
			 INNER JOIN #tblSCP0100_MEASURE1 MG ON L.MEASURE = MG.MEASURE_UI

			 -----------------------------------------------
			 UNION
	 			 SELECT ' + @col_list + '
					   ,MG.MEASURE_GROUP AS MEASURE_GROUP
					   ,MG.MEASURE_UI    AS MEASURE_UI
					   ,MG.MEASURE_NAME  AS MEASURE_NAME
					   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO
					   ,T.CODE
					   ,T.NAME AS VARIOUS_KEY
					   ,T.DISPLAY_SEQ
					   ,CELL_CF
				   FROM #tblSCP0100_RAW_CELL_CF L
			 INNER JOIN #tblSCP0100_MEASURE2 MG ON L.MEASURE = MG.MEASURE_UI
			 INNER JOIN #tblSCP0100_TRANSPORT_MODE_CODE T ON L.VARIOUS_KEY = T.CODE

			 -----------------------------------------------
			 UNION
	 			 SELECT ' + @col_list2 + '
					   ,MG.MEASURE_GROUP AS MEASURE_GROUP
					   ,MG.MEASURE_UI    AS MEASURE_UI
					   ,MG.MEASURE_NAME  AS MEASURE_NAME
					   ,MG.SORT_ORDER_NO AS SORT_ORDER_NO
					   ,T.VARIOUS_KEY AS LINE
					   ,T.VARIOUS_KEY AS VARIOUS_KEY
					   ,1 AS DISPLAY_SEQ
					   ,CELL_CF
				   FROM #tblSCP0100_RAW_CELL_CF L
			 INNER JOIN #tblSCP0100_MEASURE3 MG ON L.MEASURE = MG.MEASURE_UI
			 INNER JOIN #tblSCP0100_LINE T ON 1 = 1
							       ' + @col_where + '
								   AND MG.MEASURE_UI		= T.MEASURE

		) DATA
	   WHERE MEASURE_UI NOT IN (''DIO'')
	   ORDER BY ' + @col_list + '
	          ,SORT_ORDER_NO
			  ,DISPLAY_SEQ
			  ,VARIOUS_KEY
			';

END

--################################################################################################################
-- 1, DETAIL
--################################################################################################################
ELSE IF @p_search_level = 'DETAIL'
BEGIN

	 --********************************************************************************
	 --#tblSCP0100_QTY_DETAIL
	 --********************************************************************************
	IF OBJECT_ID('tempdb..#tblSCP0100_QTY_DETAIL') IS NOT NULL
		DROP TABLE #tblSCP0100_QTY_DETAIL;

		 SELECT YYYYMM
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,OPERATION_ID
			   ,PRODUCT_LEVEL1
			   ,PRODUCT_LEVEL2
			   ,PRODUCT_LEVEL3
			   ,ITEM_ID
			   ,TO_SITE
			   ,FROM_SITE
			   ,VARIOUS_KEY
			   ,INCOTERMS
			   ,MEASURE AS MEASURE_UI
			   ,SUM(CELL_QTY)     AS QTY
			   ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
			   ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			   ,MAX(CELL_CF)      AS CELL_CF
		   INTO #tblSCP0100_QTY_DETAIL
		   FROM #tblSCP0100_Raw
	   GROUP BY YYYYMM
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,OPERATION_ID
			   ,PRODUCT_LEVEL1
			   ,PRODUCT_LEVEL2
			   ,PRODUCT_LEVEL3
			   ,ITEM_ID
			   ,TO_SITE
			   ,FROM_SITE
			   ,VARIOUS_KEY
			   ,INCOTERMS
			   ,MEASURE;


   CREATE INDEX IDX_TMP_LIST_QTY5 ON #tblSCP0100_QTY_DETAIL (
                                                    YYYYMM
												   ,DIVISION_ID
												   ,CELL_GROUP
												   ,OPERATION_GROUP
												   ,OPERATION_ID
												   ,PRODUCT_LEVEL1
												   ,PRODUCT_LEVEL2
												   ,PRODUCT_LEVEL3
												   ,ITEM_ID
												   ,TO_SITE
												   ,FROM_SITE
												   ,VARIOUS_KEY
												   ,INCOTERMS
												   ,MEASURE_UI
												   );
--TESTING : OK
--select * from #tblSCP0100_QTY_DETAIL;return;

	 --********************************************************************************
	 --@v_qty_cols
	 --********************************************************************************
		SELECT  @v_qty_cols    = @v_qty_cols + N'
                ,  (
                        SELECT  QTY
		                FROM    #tblSCP0100_QTY_DETAIL B
						WHERE   1=1
                            AND B.DIVISION_ID		= A.DIVISION_ID
							AND B.CELL_GROUP		= A.CELL_GROUP
							AND B.OPERATION_GROUP	= A.OPERATION_GROUP
							AND B.OPERATION_ID		= A.OPERATION_ID
							AND B.PRODUCT_LEVEL1	= A.PRODUCT_LEVEL1
							AND B.PRODUCT_LEVEL2	= A.PRODUCT_LEVEL2
							AND B.PRODUCT_LEVEL3	= A.PRODUCT_LEVEL3
							AND B.ITEM_ID			= A.ITEM_ID
							AND B.TO_SITE			= A.TO_SITE
							AND B.FROM_SITE			= A.FROM_SITE
							AND B.VARIOUS_KEY		= A.VARIOUS_KEY
							AND B.INCOTERMS			= A.INCOTERMS
							AND B.MEASURE_UI		= A.MEASURE_UI
							AND B.YYYYMM = ''' + YYYYMM + ''')  AS ' + YYYYMMDD
		FROM    #tblSCP0100_DayCols AS A
		ORDER BY SORT_ORDER_NO;


		SET @v_day_cols = RIGHT(@v_day_cols, LEN(@v_day_cols)-1);
		SET @v_qty_cols = RIGHT(@v_qty_cols, LEN(@v_qty_cols)-1);


	 --********************************************************************************
	 --RESULT
	 --********************************************************************************
	 --********************************************************************************
        SET @v_sql = N'
    	IF OBJECT_ID(''tempdb..#tblSCP0100_RAW_CELL_CF'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_RAW_CELL_CF;

		SELECT	  DIVISION_ID
				, CELL_GROUP
				, OPERATION_GROUP
				, OPERATION_ID
				, ITEM_ID
				, TO_SITE
				, FROM_SITE
				, INCOTERMS
				, PRODUCT_LEVEL1
				, PRODUCT_LEVEL2
				, PRODUCT_LEVEL3
				, MEASURE
				, VARIOUS_KEY
				, MAX(CELL_CF) AS CELL_CF
		INTO	#tblSCP0100_RAW_CELL_CF
		FROM	#tblSCP0100_Raw
		GROUP BY  DIVISION_ID
				, CELL_GROUP
				, OPERATION_GROUP
				, OPERATION_ID
				, ITEM_ID
				, TO_SITE
				, FROM_SITE
				, INCOTERMS
				, PRODUCT_LEVEL1
				, PRODUCT_LEVEL2
				, PRODUCT_LEVEL3
				, MEASURE
				, VARIOUS_KEY;

--TESTING : OK
--select * from #tblSCP0100_RAW_CELL_CF;return;

    	IF OBJECT_ID(''tempdb..#tblSCP0100_ALL_MEASURE_UI'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_ALL_MEASURE_UI;

		SELECT	  L.DIVISION_ID
				, L.CELL_GROUP
				, L.OPERATION_GROUP
				, L.OPERATION_ID
				, L.ITEM_ID
				, L.TO_SITE
				, L.FROM_SITE
				, L.INCOTERMS
				, L.PRODUCT_LEVEL1
				, L.PRODUCT_LEVEL2
				, L.PRODUCT_LEVEL3
				, L.CELL_CF
				, MG.MEASURE_GROUP          AS MEASURE_GROUP
				, MG.MEASURE_UI             AS MEASURE_UI
				, MG.MEASURE_NAME           AS MEASURE_NAME
				, MG.SORT_ORDER_NO          AS SORT_ORDER_NO
				, CONVERT(NVARCHAR, NULL)   AS CODE           -- UNION 시 NULL이면 에러 유발하므로 형변환
--TESTING				, CONVERT(NVARCHAR, NULL) AS VARIOUS_KEY    -- UNION 시 NULL이면 에러 유발하므로 형변환
				, L.VARIOUS_KEY   --TESTING
				, 1 AS DISPLAY_SEQ
		INTO	#tblSCP0100_ALL_MEASURE_UI
				   FROM #tblSCP0100_RAW_CELL_CF L
				INNER JOIN #tblSCP0100_MEASURE1 MG ON
						L.MEASURE = MG.MEASURE_UI;

--TESTING : OK
--select * from #tblSCP0100_RAW_CELL_CF;
--select * from #tblSCP0100_MEASURE1;
--select * from #tblSCP0100_ALL_MEASURE_UI;return;


    	IF OBJECT_ID(''tempdb..#tblSCP0100_ALL_VARIOUS_KEY'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_ALL_VARIOUS_KEY;

		SELECT	  L.DIVISION_ID
				, L.CELL_GROUP
				, L.OPERATION_GROUP
				, L.OPERATION_ID
				, L.ITEM_ID
				, L.TO_SITE
				, L.FROM_SITE
				, L.INCOTERMS
				, L.PRODUCT_LEVEL1
				, L.PRODUCT_LEVEL2
				, L.PRODUCT_LEVEL3
				, L.CELL_CF
				, MG.MEASURE_GROUP AS MEASURE_GROUP
				, MG.MEASURE_UI    AS MEASURE_UI
				, MG.MEASURE_NAME  AS MEASURE_NAME
				, MG.SORT_ORDER_NO AS SORT_ORDER_NO
				, T.CODE
--TESTING				, T.NAME           AS VARIOUS_KEY
                , T.CODE           AS VARIOUS_KEY
				, T.DISPLAY_SEQ
		INTO	#tblSCP0100_ALL_VARIOUS_KEY
				   FROM #tblSCP0100_RAW_CELL_CF L
				INNER JOIN #tblSCP0100_MEASURE2 MG ON
						L.MEASURE = MG.MEASURE_UI
				INNER JOIN #tblSCP0100_TRANSPORT_MODE_CODE T ON
						L.VARIOUS_KEY = T.CODE;

--TESTING : OK
--select * from #tblSCP0100_RAW_CELL_CF;
--select * from #tblSCP0100_MEASURE2;
--select * from #tblSCP0100_TRANSPORT_MODE_CODE;
--select * from #tblSCP0100_ALL_VARIOUS_KEY;return;


    	IF OBJECT_ID(''tempdb..#tblSCP0100_ALL_DISPLAY_SEQ'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_ALL_DISPLAY_SEQ;

		SELECT	  L.DIVISION_ID
				, L.CELL_GROUP
				, L.OPERATION_GROUP
				, L.OPERATION_ID
				, L.ITEM_ID
				, L.TO_SITE
				, L.FROM_SITE
				, L.INCOTERMS
				, L.PRODUCT_LEVEL1
				, L.PRODUCT_LEVEL2
				, L.PRODUCT_LEVEL3
				, L.CELL_CF
				, M.MEASURE_GROUP   AS MEASURE_GROUP
				, M.MEASURE_UI      AS MEASURE_UI
				, M.MEASURE_NAME    AS MEASURE_NAME
				, M.SORT_ORDER_NO   AS SORT_ORDER_NO
				, T.VARIOUS_KEY AS CODE
				, T.VARIOUS_KEY     AS VARIOUS_KEY
				, 1                 AS DISPLAY_SEQ
		INTO	#tblSCP0100_ALL_DISPLAY_SEQ
		FROM	#tblSCP0100_RAW_CELL_CF L
				INNER JOIN #tblSCP0100_MEASURE3 M ON
						L.MEASURE		= M.MEASURE_UI
				INNER JOIN #tblSCP0100_LINE T ON
						L.DIVISION_ID		= T.DIVISION_ID
					AND L.CELL_GROUP		= T.CELL_GROUP
					AND L.OPERATION_GROUP	= T.OPERATION_GROUP
					AND L.OPERATION_ID		= T.OPERATION_ID
					AND L.PRODUCT_LEVEL1	= T.PRODUCT_LEVEL1
					AND L.PRODUCT_LEVEL2	= T.PRODUCT_LEVEL2
					AND L.PRODUCT_LEVEL3	= T.PRODUCT_LEVEL3
					AND L.ITEM_ID			= T.ITEM_ID
					AND L.TO_SITE			= T.TO_SITE
					AND L.FROM_SITE			= T.FROM_SITE
					AND L.INCOTERMS			= T.INCOTERMS
					AND M.MEASURE_UI		= T.MEASURE;

--TESTING : OK
--select * from #tblSCP0100_ALL_MEASURE_UI;--return;
--select * from #tblSCP0100_ALL_VARIOUS_KEY;--return;
--select * from #tblSCP0100_ALL_DISPLAY_SEQ;return;



    	IF OBJECT_ID(''tempdb..#tblSCP0100_ALL'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_ALL;

        --빈테이블 생성
        SELECT  *
        INTO    #tblSCP0100_ALL
        FROM    #tblSCP0100_ALL_MEASURE_UI
        WHERE   1<>1;

        INSERT INTO #tblSCP0100_ALL
		SELECT	*
		FROM	#tblSCP0100_ALL_MEASURE_UI;

        INSERT INTO #tblSCP0100_ALL
		SELECT	*
		FROM	#tblSCP0100_ALL_VARIOUS_KEY;

        INSERT INTO #tblSCP0100_ALL
		SELECT	*
		FROM	#tblSCP0100_ALL_DISPLAY_SEQ;

--TESTING : OK
--select * from #tblSCP0100_ALL;return;
--select * from #tblSCP0100_QTY_DETAIL;return;

    	IF OBJECT_ID(''tempdb..#tblSCP0100_FINAL'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_FINAL;

		SELECT	  A.DIVISION_ID
				, A.CELL_GROUP
				, CASE
                    WHEN OPERATION_GROUP = ''A'' AND MEASURE_GROUP = ''Sales PSI'' THEN ''Cell Sales PSI''
				    ELSE A.MEASURE_GROUP
				  END AS MEASURE_GROUP
				, A.MEASURE_UI
				, A.MEASURE_NAME
				, CASE
					WHEN OPERATION_GROUP = ''A'' AND MEASURE_GROUP = ''Sales PSI'' THEN A.SORT_ORDER_NO + 20
					ELSE A.SORT_ORDER_NO
				  END AS SORT_ORDER_NO
				, CS.CELL_GROUP_SORT_ORDER_NO
				, A.FROM_SITE
				, A.TO_SITE
				, A.OPERATION_GROUP
				, A.OPERATION_ID
				, A.PRODUCT_LEVEL1
				, A.PRODUCT_LEVEL2
				, A.PRODUCT_LEVEL3
				, A.VARIOUS_KEY
				, A.INCOTERMS
				, A.ITEM_ID
				, A.CELL_CF
				, A.CODE
				, A.DISPLAY_SEQ
               ' + @v_qty_cols + N'
		INTO	#tblSCP0100_FINAL
		FROM	#tblSCP0100_ALL A
			    INNER JOIN #tblSCP0100_CELL_GROUP_SORT_ORDER CS ON
                        A.CELL_GROUP = CS.CELL_GROUP
                    AND A.MEASURE_UI = CS.MEASURE
		WHERE	1=1
			--AND MEASURE_UI NOT IN (''DIO'')
			AND MEASURE_UI NOT LIKE ''%DIO%''
	   --ORDER BY DIVISION_ID
			 --  ,CELL_GROUP
			 --  ,SORT_ORDER_NO
			 --  ,FROM_SITE
			 --  ,TO_SITE
			 --  ,PRODUCT_LEVEL1
			 --  ,PRODUCT_LEVEL2
			 --  ,PRODUCT_LEVEL3
			 --  ,OPERATION_GROUP DESC
			 --  ,OPERATION_ID
			 --  ,VARIOUS_KEY
			 --  ,INCOTERMS
			 --  ,ITEM_ID
			 --  ,DISPLAY_SEQ;

--TESTING : OK
--select * from #tblSCP0100_ALL;
--select * from #tblSCP0100_QTY_DETAIL;return;

        SELECT   ' + @v_final_cols + N'
                ,' + @v_final_sum_cols + N'
        FROM    #tblSCP0100_FINAL
        WHERE   1=1' + N'
            ' + @v_final_sum_wheres + N'
        GROUP BY ' + @v_final_cols + N'
        ORDER BY ' + @v_final_order_cols + ';
		';


END


--################################################################################################################
-- 1, CELL_GROUP
--################################################################################################################
ELSE IF @p_search_level = 'CELL_GROUP'
BEGIN


	 --********************************************************************************
	 --#tblSCP0100_QTY_CELL_GROUP
	 --********************************************************************************
	IF OBJECT_ID('tempdb..#tblSCP0100_QTY_CELL_GROUP') IS NOT NULL
		DROP TABLE #tblSCP0100_QTY_CELL_GROUP;

	SELECT	  YYYYMM
			, DIVISION_ID
			, CELL_GROUP
			, MEASURE AS MEASURE_UI
			, SUM(CELL_QTY)          AS QTY
			, SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
			, SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			, MAX(CELL_CF )     AS CELL_CF
	INTO	#tblSCP0100_QTY_CELL_GROUP
	FROM	#tblSCP0100_Raw
	GROUP BY	  YYYYMM
				, DIVISION_ID
				, CELL_GROUP
				, MEASURE;

--TESTING : OK
--select * from #tblSCP0100_QTY_CELL_GROUP;return;


   CREATE INDEX IDX_tblSCP0100_QTY_CELL_GROUP ON #tblSCP0100_QTY_CELL_GROUP (
														 YYYYMM
													   , DIVISION_ID
													   , CELL_GROUP
													   , MEASURE_UI
												   );


	 --********************************************************************************
	 --#@v_qty_cols
	 --********************************************************************************
		SELECT  @v_qty_cols    = @v_qty_cols + N'
               ,  (
                    SELECT  QTY
		            FROM    #tblSCP0100_QTY_CELL_GROUP B
					WHERE   1=1
                        AND L.DIVISION_ID   = B.DIVISION_ID
					    AND L.CELL_GROUP    = B.CELL_GROUP
					    AND MG.MEASURE_UI   = B.MEASURE_UI
					    AND YYYYMM          = ''' + YYYYMM + ''')  AS ' + YYYYMMDD
		FROM    #tblSCP0100_DayCols AS A
		ORDER BY sort_order_no;


		SET @v_day_cols = RIGHT(@v_day_cols, LEN(@v_day_cols)-1);
		SET @v_qty_cols = RIGHT(@v_qty_cols, LEN(@v_qty_cols)-1);

	 --********************************************************************************
	 --RESULT
	 --********************************************************************************
        SET @v_sql = N'
    	IF OBJECT_ID(''tempdb..#tblSCP0100_RAW_CELL_CF'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_RAW_CELL_CF;

        SELECT    DIVISION_ID
                , CELL_GROUP
                , MEASURE
        INTO   #tblSCP0100_RAW_CELL_CF
        FROM    #tblSCP0100_Raw L
        GROUP BY  DIVISION_ID
                , CELL_GROUP
                , MEASURE;

    	IF OBJECT_ID(''tempdb..#tblSCP0100_FINAL'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_FINAL;

        SELECT	  L.DIVISION_ID
				, L.CELL_GROUP
				, MG.MEASURE_GROUP
				, MG.MEASURE_UI
				, MG.MEASURE_NAME
                , MG.SORT_ORDER_NO
                , CS.CELL_GROUP_SORT_ORDER_NO
				, ''-'' AS OPERATION_GROUP
				, ''-'' AS OPERATION_ID
				, ''-'' AS ITEM_ID
				, ''-'' AS TO_SITE
				, ''-'' AS FROM_SITE
				, ''-'' AS INCOTERMS
				, ''-'' AS VARIOUS_KEY
				, ''-'' AS PRODUCT_LEVEL1
				, ''-'' AS PRODUCT_LEVEL2
				, ''-'' AS PRODUCT_LEVEL3
				, 1 AS CELL_CF
				, L.MEASURE
				' + @v_qty_cols + N'
				, CS.INV_SORT
		INTO	#tblSCP0100_FINAL
        FROM	#tblSCP0100_RAW_CELL_CF L
				INNER JOIN #tblSCP0100_MEASURE MG ON
						L.MEASURE = MG.MEASURE_UI
						--AND MG.MEASURE_UI NOT LIKE ''%DIO_%''
				INNER JOIN #tblSCP0100_CELL_GROUP_SORT_ORDER CS ON
                        L.CELL_GROUP = CS.CELL_GROUP
                    AND L.MEASURE    = CS.MEASURE;
        --ORDER BY L.DIVISION_ID
        --  ,L.CELL_GROUP
        --  ,MG.SORT_ORDER_NO;

--TESTING : OK
--select * from #tblSCP0100_RAW_CELL_CF;
--select * from #tblSCP0100_QTY_CELL_GROUP
--select * from #tblSCP0100_CELL_GROUP_SORT_ORDER;
--select * from #tblSCP0100_FINAL;return;

        SELECT   ' + @v_final_cols + N'
                ,' + @v_final_sum_cols + N'
				,MAX(INV_SORT) AS INV_SORT
        FROM    #tblSCP0100_FINAL
        WHERE   1=1' + N'
            ' + @v_final_sum_wheres + N'
        GROUP BY ' + @v_final_cols + N'
        ORDER BY ' + @v_final_order_cols + ' ;
		';
END
--################################################################################################################
-- 1-1, CELL_GROUP_DETAIL	고도화
--################################################################################################################
ELSE IF @p_search_level = 'CELL_GROUP_DETAIL'
BEGIN
	 --********************************************************************************
	 --#tblSCP0100_QTY_CELL_GROUP_DETAIL
	 --********************************************************************************
	IF OBJECT_ID('tempdb..#tblSCP0100_QTY_CELL_GROUP_DETAIL') IS NOT NULL
		DROP TABLE #tblSCP0100_QTY_CELL_GROUP_DETAIL;

		 SELECT YYYYMM
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,PRODUCT_LEVEL1
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
			   ,MEASURE AS MEASURE_UI
			   ,SUM(CELL_QTY)          AS QTY
			   ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
			   ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			   ,MAX(CELL_CF )     AS CELL_CF
		   INTO #tblSCP0100_QTY_CELL_GROUP_DETAIL
		   FROM #tblSCP0100_Raw
		   WHERE 1=1
		   AND MEASURE NOT IN ('DIO_SALES','DIO_PACK','DIO_CELL')
	   GROUP BY YYYYMM
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,PRODUCT_LEVEL1
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
			   ,MEASURE;
		
		INSERT INTO #tblSCP0100_QTY_CELL_GROUP_DETAIL
		SELECT YYYYMM
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,PRODUCT_LEVEL1
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
			   ,MEASURE AS MEASURE_UI
			   ,SUM(CELL_QTY)          AS QTY
			   ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
			   ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			   ,MAX(CELL_CF )     AS CELL_CF
		   FROM #tblSCP0100_DIO_Detail_Raw
	   GROUP BY YYYYMM
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,PRODUCT_LEVEL1
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
			   ,MEASURE;

   CREATE INDEX IDX_tblSCP0100_QTY_CELL_GROUP_DETAIL ON #tblSCP0100_QTY_CELL_GROUP_DETAIL (
                                                    YYYYMM
												   ,DIVISION_ID
												   ,CELL_GROUP
												   ,PRODUCT_LEVEL1
												   ,OPERATION_GROUP
												   ,PRODUCT_LEVEL2
												   ,MEASURE_UI
												   );

	 --********************************************************************************
	 --#@v_qty_cols
	 --********************************************************************************
		SELECT  @v_qty_cols    = @v_qty_cols + N'
                                                        ,  (SELECT QTY
		                                                    FROM #tblSCP0100_QTY_CELL_GROUP_DETAIL B
															WHERE L.DIVISION_ID		= B.DIVISION_ID
															AND L.CELL_GROUP		= B.CELL_GROUP
															AND L.PRODUCT_LEVEL1	= B.PRODUCT_LEVEL1
															AND L.OPERATION_GROUP	= B.OPERATION_GROUP
															AND L.PRODUCT_LEVEL2	= B.PRODUCT_LEVEL2
															AND MG.MEASURE_UI		= B.MEASURE_UI
															AND YYYYMM = ''' + YYYYMM + ''')  AS ' + YYYYMMDD
		FROM    #tblSCP0100_DayCols AS A
		ORDER BY sort_order_no;


		SET @v_day_cols = RIGHT(@v_day_cols, LEN(@v_day_cols)-1);
		SET @v_qty_cols = RIGHT(@v_qty_cols, LEN(@v_qty_cols)-1);

	 --********************************************************************************
	 --RESULT
	 --********************************************************************************
        SET @v_sql = N'
    	IF OBJECT_ID(''tempdb..#tblSCP0100_RAW_CELL_CF'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_RAW_CELL_CF;

		 SELECT DIVISION_ID
			   ,CELL_GROUP
			   ,PRODUCT_LEVEL1
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
			   ,MEASURE
        INTO   #tblSCP0100_RAW_CELL_CF
		FROM #tblSCP0100_Raw L
		GROUP BY DIVISION_ID
			    ,CELL_GROUP
				,PRODUCT_LEVEL1
				,OPERATION_GROUP
			    ,PRODUCT_LEVEL2
				,MEASURE;
		
		INSERT INTO   #tblSCP0100_RAW_CELL_CF
		SELECT DIVISION_ID
			   ,CELL_GROUP
			   ,PRODUCT_LEVEL1
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
			   ,MEASURE
		FROM #tblSCP0100_DIO_Detail_Raw L
		GROUP BY DIVISION_ID
			    ,CELL_GROUP
				,PRODUCT_LEVEL1
				,OPERATION_GROUP
			    ,PRODUCT_LEVEL2
				,MEASURE;

    	IF OBJECT_ID(''tempdb..#tblSCP0100_FINAL'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_FINAL;

	 	 SELECT   L.DIVISION_ID
                , L.CELL_GROUP
				, L.PRODUCT_LEVEL1
				, CASE WHEN CHARINDEX(''DIO'',OPERATION_GROUP) > 0  THEN  OPERATION_GROUP + ''(Lv1)''
					   WHEN MEASURE_UI = ''DIO''
				      THEN DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',''C'')
				      ELSE DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',L.OPERATION_GROUP)
					  END AS OPERATION_GROUP
			    , L.PRODUCT_LEVEL2
                , MG.MEASURE_GROUP
                , MG.MEASURE_UI
                , MG.MEASURE_NAME
                , MG.SORT_ORDER_NO
                , CS.CELL_GROUP_SORT_ORDER_NO
			    , ''-'' AS OPERATION_ID
			    , ''-'' AS ITEM_ID
			    , ''-'' AS TO_SITE
			    , ''-'' AS FROM_SITE
			    , ''-'' AS INCOTERMS
			    , ''-'' AS VARIOUS_KEY
			    , ''-'' AS PRODUCT_LEVEL3
			    , 1 AS CELL_CF
			    , L.MEASURE
			  ' + @v_qty_cols + N'
			    , CS.INV_SORT
    	INTO   #tblSCP0100_FINAL
		FROM    #tblSCP0100_RAW_CELL_CF L
                INNER JOIN #tblSCP0100_MEASURE MG ON L.MEASURE = MG.MEASURE_UI
	                AND MG.MEASURE_UI NOT IN (''DIO'')
				INNER JOIN #tblSCP0100_CELL_GROUP_SORT_ORDER CS ON
                        L.CELL_GROUP = CS.CELL_GROUP
                    AND L.MEASURE    = CS.MEASURE;
	   --ORDER BY L.DIVISION_ID
			 --  ,L.CELL_GROUP
			 --  ,OPERATION_GROUP DESC
			 --  ,L.PRODUCT_LEVEL2
			 --  ,MG.SORT_ORDER_NO;

        SELECT   ' + @v_final_cols + N'
                ,' + @v_final_sum_cols + N'
				, MAX(INV_SORT) AS INV_SORT
        FROM    #tblSCP0100_FINAL
        WHERE   1=1' + N'
            ' + @v_final_sum_wheres + N'
        GROUP BY ' + @v_final_cols + N'
		ORDER BY DIVISION_ID, INV_SORT, CELL_GROUP_SORT_ORDER_NO,CELL_GROUP,PRODUCT_LEVEL1
				, (CASE WHEN MEASURE_GROUP LIKE ''SALES%'' THEN 1
					   WHEN MEASURE_GROUP LIKE ''PACK%'' THEN 2
					   WHEN MEASURE_GROUP LIKE ''CELL%'' THEN 3
					   ELSE 4 END)
				   , (CASE WHEN CHARINDEX(OPERATION_GROUP,''Lv1'') > 0 THEN 3 
							   WHEN OPERATION_GROUP = ''PACK'' THEN 1	ELSE 2 END )
				--, OPERATION_GROUP DESC
				, PRODUCT_LEVEL2, SORT_ORDER_NO, MEASURE_NAME
		';
END


--################################################################################################################
-- 2, PRODUCT_LEVEL1
--################################################################################################################
ELSE IF @p_search_level = 'PRODUCT_LEVEL1'
BEGIN

	 --********************************************************************************
	 --#tblSCP0100_QTY_PRODUCT_LEVEL1
	 --********************************************************************************
	IF OBJECT_ID('tempdb..#tblSCP0100_QTY_PRODUCT_LEVEL1') IS NOT NULL
		DROP TABLE #tblSCP0100_QTY_PRODUCT_LEVEL1;

		 SELECT YYYYMM
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL1
			   ,MEASURE AS MEASURE_UI
			   ,SUM(CELL_QTY)          AS QTY
			   ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
			   ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			   ,MAX(CELL_CF )     AS CELL_CF
		   INTO #tblSCP0100_QTY_PRODUCT_LEVEL1
		   FROM #tblSCP0100_Raw
	   GROUP BY YYYYMM
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL1
			   ,MEASURE;


   CREATE INDEX IDX_tblSCP0100_QTY_PRODUCT_LEVEL1 ON #tblSCP0100_QTY_PRODUCT_LEVEL1 (
                                                    YYYYMM
												   ,DIVISION_ID
												   ,CELL_GROUP
												   ,OPERATION_GROUP
												   ,PRODUCT_LEVEL1
												   ,MEASURE_UI
												   );

	 --********************************************************************************
	 --#tblSCP0100_DayCols
	 --********************************************************************************
		SELECT  @v_qty_cols    = @v_qty_cols + N'
               ,  (SELECT QTY
		           FROM    #tblSCP0100_QTY_PRODUCT_LEVEL1 
		           WHERE   L.DIVISION_ID	= DIVISION_ID
		               AND L.CELL_GROUP		= CELL_GROUP
		               AND L.OPERATION_GROUP= OPERATION_GROUP
		               AND L.PRODUCT_LEVEL1	= PRODUCT_LEVEL1
		               AND MG.MEASURE_UI	= MEASURE_UI
		               AND YYYYMM = ''' + YYYYMM + ''')  AS ' + YYYYMMDD
		FROM    #tblSCP0100_DayCols AS A
		ORDER BY sort_order_no;


		SET @v_day_cols = RIGHT(@v_day_cols, LEN(@v_day_cols)-1);
		SET @v_qty_cols = RIGHT(@v_qty_cols, LEN(@v_qty_cols)-1);

	 --********************************************************************************
	 --RESULT
	 --********************************************************************************
        SET @v_sql = N'
    	IF OBJECT_ID(''tempdb..#tblSCP0100_RAW_CELL_CF'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_RAW_CELL_CF;

		 SELECT DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL1
			   ,MEASURE
        INTO   #tblSCP0100_RAW_CELL_CF
		FROM #tblSCP0100_Raw L
		GROUP BY DIVISION_ID
			    ,CELL_GROUP
				,OPERATION_GROUP
			   ,PRODUCT_LEVEL1
				,MEASURE;

    	IF OBJECT_ID(''tempdb..#tblSCP0100_FINAL'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_FINAL;

	 	 SELECT   L.DIVISION_ID
                , L.CELL_GROUP
                , CASE WHEN MEASURE_UI = ''DIO''
				      THEN DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',''C'')
				      ELSE DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',L.OPERATION_GROUP)
					  END AS OPERATION_GROUP
                , L.PRODUCT_LEVEL1
                , MG.MEASURE_GROUP
                , MG.MEASURE_UI
                , MG.MEASURE_NAME
                , MG.SORT_ORDER_NO
                , CS.CELL_GROUP_SORT_ORDER_NO
                , ''-'' AS OPERATION_ID
                , ''-'' AS ITEM_ID
                , ''-'' AS TO_SITE
                , ''-'' AS FROM_SITE
                , ''-'' AS INCOTERMS
                , ''-'' AS VARIOUS_KEY
                , ''-'' AS PRODUCT_LEVEL2
                , ''-'' AS PRODUCT_LEVEL3
                , 1 AS CELL_CF
                , L.MEASURE
			   ' + @v_qty_cols + N'
    	INTO   #tblSCP0100_FINAL
		   FROM #tblSCP0100_RAW_CELL_CF L
	 INNER JOIN #tblSCP0100_MEASURE MG ON L.MEASURE = MG.MEASURE_UI
	                          -- AND MG.MEASURE_UI NOT IN (''DIO'')
							   AND MG.MEASURE_UI NOT LIKE ''%DIO%''
				INNER JOIN #tblSCP0100_CELL_GROUP_SORT_ORDER CS ON
                        L.CELL_GROUP = CS.CELL_GROUP
                    AND L.MEASURE    = CS.MEASURE;
	   --ORDER BY L.DIVISION_ID
			 --  ,L.CELL_GROUP
			 --  ,OPERATION_GROUP DESC
			 --  ,L.PRODUCT_LEVEL1
			 --  ,MG.SORT_ORDER_NO;

        SELECT   ' + @v_final_cols + N'
                ,' + @v_final_sum_cols + N'
        FROM    #tblSCP0100_FINAL
        WHERE   1=1' + N'
            ' + @v_final_sum_wheres + N'
        GROUP BY ' + @v_final_cols + N'
        ORDER BY ' + @v_final_order_cols + ';
		';

END


--################################################################################################################
-- 3, PRODUCT_LEVEL2
--################################################################################################################
ELSE IF @p_search_level = 'PRODUCT_LEVEL2'
BEGIN
	 --********************************************************************************
	 --#tblSCP0100_QTY_PRODUCT_LEVEL2
	 --********************************************************************************
	IF OBJECT_ID('tempdb..#tblSCP0100_QTY_PRODUCT_LEVEL2') IS NOT NULL
		DROP TABLE #tblSCP0100_QTY_PRODUCT_LEVEL2;

		 SELECT YYYYMM
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
			   ,MEASURE AS MEASURE_UI
			   ,SUM(CELL_QTY)          AS QTY
			   ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
			   ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
			   ,MAX(CELL_CF )     AS CELL_CF
		   INTO #tblSCP0100_QTY_PRODUCT_LEVEL2
		   FROM #tblSCP0100_Raw
	   GROUP BY YYYYMM
		       ,DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
			   ,MEASURE;


   CREATE INDEX IDX_tblSCP0100_QTY_PRODUCT_LEVEL2 ON #tblSCP0100_QTY_PRODUCT_LEVEL2 (
                                                    YYYYMM
												   ,DIVISION_ID
												   ,CELL_GROUP
												   ,OPERATION_GROUP
												   ,PRODUCT_LEVEL2
												   ,MEASURE_UI
												   );

	 --********************************************************************************
	 --#@v_qty_cols
	 --********************************************************************************
		SELECT  @v_qty_cols    = @v_qty_cols + N'
                                                        ,  (SELECT QTY
		                                                    FROM #tblSCP0100_QTY_PRODUCT_LEVEL2 B
															WHERE L.DIVISION_ID		= B.DIVISION_ID
															AND L.CELL_GROUP		= B.CELL_GROUP
															AND L.OPERATION_GROUP	= B.OPERATION_GROUP
															AND L.PRODUCT_LEVEL2	= B.PRODUCT_LEVEL2
															AND MG.MEASURE_UI		= B.MEASURE_UI
															AND YYYYMM = ''' + YYYYMM + ''')  AS ' + YYYYMMDD
		FROM    #tblSCP0100_DayCols AS A
		ORDER BY sort_order_no;


		SET @v_day_cols = RIGHT(@v_day_cols, LEN(@v_day_cols)-1);
		SET @v_qty_cols = RIGHT(@v_qty_cols, LEN(@v_qty_cols)-1);

	 --********************************************************************************
	 --RESULT
	 --********************************************************************************
        SET @v_sql = N'
    	IF OBJECT_ID(''tempdb..#tblSCP0100_RAW_CELL_CF'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_RAW_CELL_CF;

		 SELECT DIVISION_ID
			   ,CELL_GROUP
			   ,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
			   ,MEASURE
        INTO   #tblSCP0100_RAW_CELL_CF
		FROM #tblSCP0100_Raw L
		GROUP BY DIVISION_ID
			    ,CELL_GROUP
				,OPERATION_GROUP
			   ,PRODUCT_LEVEL2
				,MEASURE;

    	IF OBJECT_ID(''tempdb..#tblSCP0100_FINAL'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_FINAL;

	 	 SELECT   L.DIVISION_ID
                , L.CELL_GROUP
                , CASE WHEN MEASURE_UI = ''DIO''
				      THEN DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',''C'')
				      ELSE DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',L.OPERATION_GROUP)
					  END AS OPERATION_GROUP
			    , L.PRODUCT_LEVEL2
                , MG.MEASURE_GROUP
                , MG.MEASURE_UI
                , MG.MEASURE_NAME
                , MG.SORT_ORDER_NO
                , CS.CELL_GROUP_SORT_ORDER_NO
			    , ''-'' AS OPERATION_ID
			    , ''-'' AS ITEM_ID
			    , ''-'' AS TO_SITE
			    , ''-'' AS FROM_SITE
			    , ''-'' AS INCOTERMS
			    , ''-'' AS VARIOUS_KEY
			    , ''-'' AS PRODUCT_LEVEL1
			    , ''-'' AS PRODUCT_LEVEL3
			    , 1 AS CELL_CF
			    , L.MEASURE
			  ' + @v_qty_cols + N'
    	INTO   #tblSCP0100_FINAL
		FROM    #tblSCP0100_RAW_CELL_CF L
                INNER JOIN #tblSCP0100_MEASURE MG ON L.MEASURE = MG.MEASURE_UI
	                --AND MG.MEASURE_UI NOT IN (''DIO'')
					AND MEASURE_UI NOT LIKE ''%DIO%''
				INNER JOIN #tblSCP0100_CELL_GROUP_SORT_ORDER CS ON
                        L.CELL_GROUP = CS.CELL_GROUP
                    AND L.MEASURE    = CS.MEASURE;
	   --ORDER BY L.DIVISION_ID
			 --  ,L.CELL_GROUP
			 --  ,OPERATION_GROUP DESC
			 --  ,L.PRODUCT_LEVEL2
			 --  ,MG.SORT_ORDER_NO;

        SELECT   ' + @v_final_cols + N'
                ,' + @v_final_sum_cols + N'
        FROM    #tblSCP0100_FINAL
        WHERE   1=1' + N'
            ' + @v_final_sum_wheres + N'
        GROUP BY ' + @v_final_cols + N'
        ORDER BY ' + @v_final_order_cols + ';
		';
END


--################################################################################################################
-- 34, PRODUCT_LEVEL3
--################################################################################################################
ELSE IF @p_search_level = 'PRODUCT_LEVEL3'
BEGIN

	 --********************************************************************************
	 --#tblSCP0100_QTY_PRODUCT_LEVEL3
	 --********************************************************************************
	IF OBJECT_ID('tempdb..#tblSCP0100_QTY_PRODUCT_LEVEL3') IS NOT NULL
		DROP TABLE #tblSCP0100_QTY_PRODUCT_LEVEL3;

    --chaan INDEX 생성시 size overflow 오류로 컬럼 사이즈 지정함
    SELECT    CONVERT(NVARCHAR(20), YYYYMM)             AS YYYYMM
            , CONVERT(NVARCHAR(100), DIVISION_ID)       AS DIVISION_ID
            , CONVERT(NVARCHAR(100), CELL_GROUP)        AS CELL_GROUP
            , CONVERT(NVARCHAR(100), OPERATION_GROUP)   AS OPERATION_GROUP
            , CONVERT(NVARCHAR(100), PRODUCT_LEVEL1)    AS PRODUCT_LEVEL1
            , CONVERT(NVARCHAR(100), PRODUCT_LEVEL2)    AS PRODUCT_LEVEL2
            , CONVERT(NVARCHAR(100), PRODUCT_LEVEL3)    AS PRODUCT_LEVEL3
            , CONVERT(NVARCHAR(100), MEASURE)           AS MEASURE_UI
            , SUM(CELL_QTY)                             AS QTY
            , SUM(FROM_BOH_QTY)                         AS FROM_BOH_QTY
            , SUM(TO_BOH_QTY)                           AS TO_BOH_QTY
            , MAX(CELL_CF )                             AS CELL_CF
    INTO    #tblSCP0100_QTY_PRODUCT_LEVEL3
    FROM    #tblSCP0100_Raw
    GROUP BY  YYYYMM
            , DIVISION_ID
            , CELL_GROUP
            , OPERATION_GROUP
            , PRODUCT_LEVEL1
            , PRODUCT_LEVEL2
            , PRODUCT_LEVEL3
            , MEASURE;


   CREATE INDEX IDX_tblSCP0100_QTY_PRODUCT_LEVEL3 ON #tblSCP0100_QTY_PRODUCT_LEVEL3 (
                                                    YYYYMM
												   ,DIVISION_ID
												   ,CELL_GROUP
												   ,OPERATION_GROUP
												   ,PRODUCT_LEVEL1
												   ,PRODUCT_LEVEL2
												   ,PRODUCT_LEVEL3
												   ,MEASURE_UI
												   );
--TESTING : OK
--select * from #tblSCP0100_QTY_PRODUCT_LEVEL3;return;

	 --********************************************************************************
	 --#@v_qty_cols
	 --********************************************************************************
		SELECT  @v_qty_cols    = @v_qty_cols + N'
                                                    ,  (
                                                            SELECT QTY
		                                                    FROM    #tblSCP0100_QTY_PRODUCT_LEVEL3 B
															WHERE   1=1
                                                                AND L.DIVISION_ID		= B.DIVISION_ID
															    AND L.CELL_GROUP		= B.CELL_GROUP
															    AND L.OPERATION_GROUP	= B.OPERATION_GROUP
											                    AND L.PRODUCT_LEVEL1	= B.PRODUCT_LEVEL1
											                    AND L.PRODUCT_LEVEL2	= B.PRODUCT_LEVEL2
												                AND L.PRODUCT_LEVEL3	= B.PRODUCT_LEVEL3
															    AND MG.MEASURE_UI		= B.MEASURE_UI
												AND YYYYMM              = ''' + YYYYMM + ''')  AS ' + YYYYMMDD
		FROM    #tblSCP0100_DayCols AS A
		ORDER BY SORT_ORDER_NO;


		SET @v_day_cols = RIGHT(@v_day_cols, LEN(@v_day_cols)-1);
		SET @v_qty_cols = RIGHT(@v_qty_cols, LEN(@v_qty_cols)-1);

	 --********************************************************************************
	 --RESULT
	 --********************************************************************************
        SET @v_sql = N'
    	IF OBJECT_ID(''tempdb..#tblSCP0100_RAW_CELL_CF'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_RAW_CELL_CF;

        SELECT    DIVISION_ID
                , CELL_GROUP
                , OPERATION_GROUP
                , PRODUCT_LEVEL1
                , PRODUCT_LEVEL2
                , PRODUCT_LEVEL3
                , MEASURE
        INTO    #tblSCP0100_RAW_CELL_CF
        FROM    #tblSCP0100_Raw L
        GROUP BY      DIVISION_ID
                    , CELL_GROUP
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL1
                    , PRODUCT_LEVEL2
                    , PRODUCT_LEVEL3
                    , MEASURE;

    	IF OBJECT_ID(''tempdb..#tblSCP0100_FINAL'') IS NOT NULL
	    	DROP TABLE #tblSCP0100_FINAL;

        SELECT    L.DIVISION_ID
                , L.CELL_GROUP
                , CASE
                    WHEN MEASURE_UI = ''DIO'' THEN DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',''C'')
                    ELSE DBO.FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'',L.OPERATION_GROUP)
                    END             AS OPERATION_GROUP
                , L.PRODUCT_LEVEL1
                , L.PRODUCT_LEVEL2
                , L.PRODUCT_LEVEL3
                , MG.MEASURE_GROUP
                , MG.MEASURE_UI
                , MG.MEASURE_NAME
                , MG.SORT_ORDER_NO
                , CS.CELL_GROUP_SORT_ORDER_NO
                , ''-''             AS OPERATION_ID
                , ''-''             AS ITEM_ID
                , ''-''             AS TO_SITE
                , ''-''             AS FROM_SITE
                , ''-''             AS INCOTERMS
                , ''-''             AS VARIOUS_KEY
                , 1 AS CELL_CF
                , L.MEASURE
               ' + @v_qty_cols + N'
    	INTO   #tblSCP0100_FINAL
        FROM    #tblSCP0100_RAW_CELL_CF L
                INNER JOIN #tblSCP0100_MEASURE MG ON
                        L.MEASURE = MG.MEASURE_UI
                    --AND MG.MEASURE_UI NOT IN (''DIO'')
					AND MG.MEASURE_UI NOT LIKE ''%DIO%''
                INNER JOIN #tblSCP0100_CELL_GROUP_SORT_ORDER CS ON
                        L.CELL_GROUP = CS.CELL_GROUP
                    AND L.MEASURE    = CS.MEASURE;
        --ORDER BY      L.DIVISION_ID
        --            , L.CELL_GROUP
        --            , OPERATION_GROUP DESC
        --            , L.PRODUCT_LEVEL1
        --            , L.PRODUCT_LEVEL2
        --            , L.PRODUCT_LEVEL3
        --            , MG.SORT_ORDER_NO;

--TESTING : OK
--select * from #tblSCP0100_QTY_PRODUCT_LEVEL3;
--select * from #tblSCP0100_RAW_CELL_CF;
--select * from #tblSCP0100_MEASURE;
--select * from #tblSCP0100_FINAL;return;


        SELECT   ' + @v_final_cols + N'
                ,' + @v_final_sum_cols + N'
        FROM    #tblSCP0100_FINAL
        WHERE   1=1' + N'
            ' + @v_final_sum_wheres + N'
        GROUP BY ' + @v_final_cols + N'
        ORDER BY ' + @v_final_order_cols + ';
		';
END


--TESTING : OK
--exec debug_log @v_sql, 'T';--return;

	EXEC (@v_sql);


	IF OBJECT_ID('tempdb..#tblSCP0100_ALL') IS NOT NULL
		DROP TABLE #tblSCP0100_ALL;
	IF OBJECT_ID('tempdb..#tblSCP0100_ALL_DISPLAY_SEQ') IS NOT NULL
		DROP TABLE #tblSCP0100_ALL_DISPLAY_SEQ;
	IF OBJECT_ID('tempdb..#tblSCP0100_ALL_MEASURE_UI') IS NOT NULL
		DROP TABLE #tblSCP0100_ALL_MEASURE_UI;
	IF OBJECT_ID('tempdb..#tblSCP0100_ALL_VARIOUS_KEY') IS NOT NULL
		DROP TABLE #tblSCP0100_ALL_VARIOUS_KEY;
	IF OBJECT_ID('tempdb..#tblSCP0100_DayCols') IS NOT NULL
		DROP TABLE #tblSCP0100_DayCols;
	IF OBJECT_ID('tempdb..#tblSCP0100_FINAL') IS NOT NULL
		DROP TABLE #tblSCP0100_FINAL;
	IF OBJECT_ID('tempdb..#tblSCP0100_LINE') IS NOT NULL
		DROP TABLE #tblSCP0100_LINE;
	IF OBJECT_ID('tempdb..#tblSCP0100_MEASURE1') IS NOT NULL
		DROP TABLE #tblSCP0100_MEASURE1;
	IF OBJECT_ID('tempdb..#tblSCP0100_MEASURE2') IS NOT NULL
		DROP TABLE #tblSCP0100_MEASURE2;
	IF OBJECT_ID('tempdb..#tblSCP0100_MEASURE3') IS NOT NULL
		DROP TABLE #tblSCP0100_MEASURE3;
	IF OBJECT_ID('tempdb..#tblSCP0100_MEASURE') IS NOT NULL
		DROP TABLE #tblSCP0100_MEASURE;
	IF OBJECT_ID('tempdb..#tblSCP0100_OPERATION') IS NOT NULL
		DROP TABLE #tblSCP0100_OPERATION;
	IF OBJECT_ID('tempdb..#tblSCP0100_ProductLevel') IS NOT NULL
		DROP TABLE #tblSCP0100_ProductLevel;
	IF OBJECT_ID('tempdb..#tblSCP0100_QTY_AUTO') IS NOT NULL
		DROP TABLE #tblSCP0100_QTY_AUTO;
	IF OBJECT_ID('tempdb..#tblSCP0100_QTY_DETAIL') IS NOT NULL
		DROP TABLE #tblSCP0100_QTY_DETAIL;
	IF OBJECT_ID('tempdb..#tblSCP0100_QTY_PRODUCT_LEVEL1') IS NOT NULL
		DROP TABLE #tblSCP0100_QTY_PRODUCT_LEVEL1;
	IF OBJECT_ID('tempdb..#tblSCP0100_QTY_PRODUCT_LEVEL2') IS NOT NULL
		DROP TABLE #tblSCP0100_QTY_PRODUCT_LEVEL2;
	IF OBJECT_ID('tempdb..#tblSCP0100_QTY_PRODUCT_LEVEL3') IS NOT NULL
		DROP TABLE #tblSCP0100_QTY_PRODUCT_LEVEL3;
	IF OBJECT_ID('tempdb..#tblSCP0100_RAW_CELL_CF') IS NOT NULL
		DROP TABLE #tblSCP0100_RAW_CELL_CF;
	IF OBJECT_ID('tempdb..#tblSCP0100_Raw') IS NOT NULL
		DROP TABLE #tblSCP0100_Raw;
	IF OBJECT_ID('tempdb..#tblSCP0100_TRANSPORT_MODE_CODE') IS NOT NULL
		DROP TABLE #tblSCP0100_TRANSPORT_MODE_CODE;
	IF OBJECT_ID('tempdb..#tblSCP0100_USER_COLS') IS NOT NULL
		DROP TABLE #tblSCP0100_USER_COLS;
	IF OBJECT_ID('tempdb..#tblSCP0100_QTY_CELL_GROUP') IS NOT NULL
		DROP TABLE #tblSCP0100_QTY_CELL_GROUP;
	IF OBJECT_ID('tempdb..#tblSCP0100_DIO_Detail_Raw') IS NOT NULL
		DROP TABLE #tblSCP0100_DIO_Detail_Raw;
		
END
