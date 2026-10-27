CREATE PROCEDURE [dbo].[PR_UI_FP01551_ETC]
	@p_sys_type			NVARCHAR(MAX),  
	@p_sys_flag			NVARCHAR(MAX),
	@p_sys_gubun		NVARCHAR(MAX),  
	@p_user_id			NVARCHAR(MAX),
	@in_columns			NVARCHAR(MAX),
	@in_row				NVARCHAR(MAX),
	@opt_none			NVARCHAR(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP01551_ETC                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP01551_ETC                                               **/
/** 설 명         :                                                                           **/
/** Version       :				                                                              **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                               **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021/05/28   CYS				Initial Release UI통합                                    **/
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP01551_ETC';
	DECLARE @runstart		DATETIME;
	DECLARE @runend			DATETIME;
	DECLARE @v_dSql			NVARCHAR(MAX) ='';
	DECLARE @STRLEN			NVARCHAR(MAX);
	DECLARE @v_Err			NVARCHAR(MAX);
	DECLARE @v_Log			NVARCHAR(MAX); 

	DECLARE @v_delimiter    NVARCHAR(1);
	DECLARE @max_loop_cnt	INTEGER = 0;
	DECLARE @mst_loop_cnt	INTEGER = 0;

	DECLARE @p__save_auth	NVARCHAR(MAX);
	DECLARE @p__non_auth	NVARCHAR(MAX);

	-- filter

	DECLARE @p_company_id	NVARCHAR(MAX);
	DECLARE @p_instance_id	NVARCHAR(MAX);
	DECLARE @p_master_id	NVARCHAR(MAX);
	DECLARE @p_plan_date	NVARCHAR(MAX);
	DECLARE @p_plan_id		NVARCHAR(MAX);
	DECLARE @p_bucket_from	NVARCHAR(MAX);
	DECLARE @p_bucket_to	NVARCHAR(MAX);

	DECLARE @p_division_id	NVARCHAR(MAX);
	DECLARE @p_site_id		NVARCHAR(MAX);
	DECLARE @p_plant_id		NVARCHAR(MAX);
	DECLARE @p_factory_id	NVARCHAR(MAX);
	DECLARE @p_operation_id NVARCHAR(MAX);
	DECLARE @p_line_id		NVARCHAR(MAX);
	
	DECLARE @p_top_item_id	NVARCHAR(MAX);
	DECLARE @p_item_id		NVARCHAR(MAX);
	DECLARE @p_nick_name	NVARCHAR(MAX);
	DECLARE @p_prod_type	NVARCHAR(MAX);
	DECLARE @p_prodtype_id	NVARCHAR(MAX);
	DECLARE @p_cate_info	NVARCHAR(MAX);
	DECLARE @p_cell_group	NVARCHAR(MAX);
	DECLARE @p_user_lt		NVARCHAR(MAX);
	DECLARE @p_plan_type	NVARCHAR(MAX);
	DECLARE @p_all_line		NVARCHAR(MAX);
	DECLARE @p_confirm_area	NVARCHAR(MAX);
	DECLARE @p_amend_main_flag	NVARCHAR(MAX);
	DECLARE @p_past_plan_type	NVARCHAR(MAX);
	DECLARE @p_in_active	NVARCHAR(MAX);
	DECLARE @p_amend_instance	NVARCHAR(MAX);
	DECLARE @p_storage_id	NVARCHAR(MAX);
	DECLARE @p_cell_item_id	NVARCHAR(MAX);
	DECLARE @p_soc_id		NVARCHAR(MAX);
	DECLARE @p_market		NVARCHAR(MAX);
	DECLARE @p_date			NVARCHAR(MAX);
	DECLARE @p_electrode_type	NVARCHAR(MAX);
	DECLARE @p_location		NVARCHAR(MAX);
	DECLARE @p_program_id	NVARCHAR(MAX);
	DECLARE @p_sheet_name	NVARCHAR(MAX);

	-- week
	DECLARE @p_bucket		NVARCHAR(MAX);
	DECLARE @p_week_info	NVARCHAR(MAX);
	DECLARE @p_month_info	NVARCHAR(MAX);

	-- table
	DECLARE @p_amend_table	NVARCHAR(MAX);
	DECLARE @p_amend_sales_table		NVARCHAR(MAX);
	DECLARE @p_amend_cutoff_boh_table	NVARCHAR(MAX);
	DECLARE @p_amend_bor_table			NVARCHAR(MAX);
	DECLARE @p_result_qty	NVARCHAR(MAX);

	DECLARE @tmp_column		NVARCHAR(MAX);
	DECLARE @tmp_value		NVARCHAR(MAX);
	DECLARE @dbg_txt		NVARCHAR(MAX);
	
	
	DECLARE @p_plant_id_cond nvarchar(100) = ''
	SET @p_plant_id_cond = (SELECT TOP 1 SEGMENT2  FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_UI_FP01552_ETC' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')
	

	SET @v_delimiter            = '^'  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	
	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
		
		SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

		SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @in_columns , @v_delimiter , @mst_loop_cnt);
		SET @tmp_value	= [dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);

		IF @tmp_column = '_SAVE_AUTH' BEGIN
			SET @p__save_auth =			@tmp_value ;
		END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
			SET @p__non_auth =			@tmp_value ;
		
		END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
			SET @p_company_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
			SET @p_instance_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
			SET @p_master_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
			SET @p_plan_date =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
			SET @p_plan_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
			SET @p_bucket_from =		@tmp_value ;
		END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
			SET @p_bucket_to =			@tmp_value ;

		END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
			SET @p_division_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'SITE_ID' BEGIN
			SET @p_site_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
			SET @p_plant_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
			SET @p_factory_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
			SET @p_operation_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'LINE_ID' BEGIN
			SET @p_line_id =			@tmp_value ;
		
		END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
			SET @p_top_item_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
			SET @p_item_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
			SET @p_nick_name =			@tmp_value ;
		END ELSE IF @tmp_column = 'PROD_TYPE' BEGIN
			SET @p_prod_type =			@tmp_value ;
		END ELSE IF @tmp_column = 'CELL_GROUP' BEGIN
			SET @p_cell_group =			@tmp_value ;
		END ELSE IF @tmp_column = 'USER_LT'	   BEGIN
			SET @p_user_lt =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
			SET @p_plan_type =			@tmp_value ;
		END ELSE IF @tmp_column = 'ALL_LINE' BEGIN
			SET @p_all_line =			@tmp_value ;
		END ELSE IF @tmp_column = 'CONFIRM_AREA' BEGIN
			SET @p_confirm_area =		@tmp_value ;
		END ELSE IF @tmp_column = 'AMEND_MAIN_FLAG' BEGIN
			SET @p_amend_main_flag =	@tmp_value ;
		END ELSE IF @tmp_column = 'PAST_PLAN_TYPE' BEGIN
			SET @p_past_plan_type  =	@tmp_value ;
		END ELSE IF @tmp_column = 'IN_ACTIVE' BEGIN
			SET @p_in_active	=		@tmp_value ;	
		END ELSE IF @tmp_column = 'AMEND_INSTANCE' BEGIN
			SET @p_amend_instance	=		@tmp_value ;	
		END ELSE IF @tmp_column = 'STORAGE_ID' BEGIN
			SET @p_storage_id	=		@tmp_value ;
		END ELSE IF @tmp_column = 'CELL_ITEM_ID' BEGIN
			SET @p_cell_item_id	=		@tmp_value ;
		END ELSE IF @tmp_column = 'SOC_ID' BEGIN
			SET @p_soc_id	=		@tmp_value ;
		END ELSE IF @tmp_column = 'MARKET' BEGIN
			SET @p_market	=		@tmp_value ;
		END ELSE IF @tmp_column = 'DATE' BEGIN
			SET @p_date	=		@tmp_value ;
		END ELSE IF @tmp_column = 'ELECTRODE_TYPE' BEGIN
			SET @p_electrode_type	=		@tmp_value ;
		END ELSE IF @tmp_column = 'LOCATION' BEGIN
			SET @p_location	=		@tmp_value ;
		END ELSE IF @tmp_column = 'PROGRAM_ID' BEGIN
			SET @p_program_id	=	@tmp_value ;
		END ELSE IF @tmp_column = 'SHEET_NAME' BEGIN
			SET @p_sheet_name	=	@tmp_value ;

		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =				@tmp_value ;
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			@tmp_value ;
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			@tmp_value ;
		
		END ELSE IF @tmp_column = 'AMEND_TABLE' BEGIN
			SET @p_amend_table =		@tmp_value ;
		END ELSE IF @tmp_column = 'AMEND_SALES_TABLE' BEGIN
			SET @p_amend_sales_table =  @tmp_value ;
		END ELSE IF @tmp_column = 'AMEND_CUTOFF_BOH_TABLE' BEGIN
			SET @p_amend_cutoff_boh_table =  @tmp_value ;
		END ELSE IF @tmp_column = 'AMEND_BOR_TABLE' BEGIN
			SET @p_amend_bor_table =  @tmp_value ;
		END ELSE IF @tmp_column = 'RESULT_QTY' BEGIN
			SET @p_result_qty =		@tmp_value ;
		END

	END
	/*	Parameter Setting End */

	/* Loop Settting */

	DECLARE @sub_mst_loop_cnt integer = 0
	DECLARE @sub_max_loop_cnt integer = 0
	DECLARE @sub_tmp_column NVARCHAR(MAX);
	DECLARE @sub_param_0 NVARCHAR(MAX);
	DECLARE @sub_param_1 NVARCHAR(MAX);
	DECLARE @sub_param_2 NVARCHAR(MAX);
	DECLARE @sub_param_3 NVARCHAR(MAX);
	DECLARE @sub_param_4 NVARCHAR(MAX);

	DECLARE @sub_total	NVARCHAR(MAX);
	DECLARE @total		NVARCHAR(MAX);
	DECLARE @capa_total	NVARCHAR(MAX);

	DECLARE @v_row_delimiter	NVARCHAR(2);
	DECLARE @sub_v_delimiter	NVARCHAR(2);

	DECLARE @max_day_loop_cnt	integer = 0;
	DECLARE @max_week_loop_cnt	integer = 0;
	DECLARE @max_month_loop_cnt	integer = 0;
	DECLARE @max_category_loop_cnt	integer = 0;
	
	SET @v_row_delimiter	= '!';  -- row column 데이터 구분자
	SET @sub_v_delimiter	= '#';  -- column  데이타 구분자 (추후 변경)

	SET @max_loop_cnt		= [dbo].[SCM_ARR_SPL_CNT](@p_bucket		, @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
	SET @max_week_loop_cnt	= [dbo].[SCM_ARR_SPL_CNT](@p_week_info	, @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
	SET @max_month_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
	SET @max_category_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단

	SET	@v_dSql = '';

	IF @p_sys_flag = 'INSTANCE'	-- findInstanceList_common
	BEGIN
		
		SELECT @v_dSql += '	SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER			' + char(10)
		SELECT @v_dSql += '	   , B.ATTRIBUTE3 AS USE_WOW_STATUS                                             ' + char(10)
		SELECT @v_dSql += '	   , B.ATTRIBUTE1 AS CONFIRM_AREA                                               ' + char(10)
		SELECT @v_dSql += '	   , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID                                            ' + char(10)
		SELECT @v_dSql += '	FROM (                                                                          ' + char(10)
		SELECT @v_dSql += '	SELECT DISTINCT INSTANCE_ID                                                     ' + char(10)
		SELECT @v_dSql += '	FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)                                       ' + char(10)
		SELECT @v_dSql += '	WHERE  USER_ID = '''+ @p_user_id +'''                                                      ' + char(10)
		IF @p__save_auth = 'Y' BEGIN
		SELECT @v_dSql += '		AND    A.SAVE_FLAG = ''Y''		                   ' + char(10)
		END
		SELECT @v_dSql += '	) A, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)                                        ' + char(10)
		SELECT @v_dSql += '	WHERE A.INSTANCE_ID      = B.SEGMENT1                                           ' + char(10)
		SELECT @v_dSql += '	AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                      ' + char(10)
		SELECT @v_dSql += '	AND   B.SEGMENT1 IN (                                                           ' + char(10)
		SELECT @v_dSql += '	  SELECT INSTANCE_ID                                                            ' + char(10)
		SELECT @v_dSql += '	  FROM FP_AMEND_UI_V                                                            ' + char(10)
		SELECT @v_dSql += '	  WHERE 1=1                                                                     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AMEND_UI_NAME' , 'EQ', @p_amend_instance)) + char(10)
		SELECT @v_dSql += '	  AND USE_FLAG = ''Y''                                                          ' + char(10)
		SELECT @v_dSql += '	)                                                                               ' + char(10)
		SELECT @v_dSql += '	AND   NOT EXISTS (                                                              ' + char(10)
		SELECT @v_dSql += '				SELECT 1                                                            ' + char(10)
		SELECT @v_dSql += '				FROM   SCM_SYS_LOOKUP_VALUE DD WITH(NOLOCK)                         ' + char(10)
		SELECT @v_dSql += '				WHERE  1=1                                                          ' + char(10)
		SELECT @v_dSql += '				AND    A.INSTANCE_ID = DD.SEGMENT2 -- PACK                          ' + char(10)
		SELECT @v_dSql += '				AND    DD.LOOKUP_TYPE_CODE = ''INHOUSE_CELL_INTEG_UI''              ' + char(10)
		SELECT @v_dSql += '				AND    DD.ACTIVE_FLAG = ''Y''                                       ' + char(10)
		SELECT @v_dSql += '	)                                                                               ' + char(10)
		SELECT @v_dSql += '	ORDER BY B.SORT_ORDER                                                           ' + char(10)

	END
	
	IF @p_sys_flag = 'WEEK_CNT'	-- find_WeekCnt
	BEGIN

		SELECT @v_dSql += N'	SELECT ISO_YYYYWW AS WEEK															' + char(10)
		SELECT @v_dSql += N'	   , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS WEEK_NAME   ' + char(10)
		SELECT @v_dSql += N'	   , COUNT(*) AS WEEK_COUNT                                                         ' + char(10)
		SELECT @v_dSql += N'	   , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS W_VALUE ' + char(10)
		SELECT @v_dSql += N'	   , ''1'' AS IS_DAY_VIEW                                                           ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                               ' + char(10)
		SELECT @v_dSql += N'	WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @p_bucket_from +''', 112)                   ' + char(10)
		SELECT @v_dSql += N'	AND    CAL.DT <= CONVERT(DATETIME, '''+ @p_bucket_to +''', 112)                     ' + char(10)
		SELECT @v_dSql += N'	GROUP BY ISO_YYYYWW                                                                 ' + char(10)
		SELECT @v_dSql += N'	ORDER BY ISO_YYYYWW                                                                 ' + char(10)

	END

	IF @p_sys_flag = 'DATE_MAP'	-- find_DateMap
	BEGIN

		SELECT @v_dSql += N'	SELECT (CASE WHEN YYYYMMDD >= '''+ @p_plan_date +''' THEN ''Y'' ELSE ''N'' END) AS IS_PLAN									' + char(10)
		SELECT @v_dSql += N'		    ,''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS D_VALUE                           ' + char(10)
		SELECT @v_dSql += N'		    ,YYYYMMDD AS _DATE                                                                                      ' + char(10)
		SELECT @v_dSql += N'		    ,ISO_YYYYWW AS _WEEK                                                                                    ' + char(10)
		SELECT @v_dSql += N'		    ,MONTH AS _MONTH                                                                                        ' + char(10)
		SELECT @v_dSql += N'		    ,SUBSTRING(YYYYMMDD,1,4) + ''-'' + SUBSTRING(YYYYMMDD,5,2) + ''-'' + SUBSTRING(YYYYMMDD,7,2) + '' ''    ' + char(10)
		SELECT @v_dSql += N'		    +(CASE WHEN DAY_SEQ=2 THEN ''(Mon.)''                                                                   ' + char(10)
		SELECT @v_dSql += N'		           WHEN DAY_SEQ=3 THEN ''(Tue.)''                                                                   ' + char(10)
		SELECT @v_dSql += N'		           WHEN DAY_SEQ=4 THEN ''(Wed.)''                                                                   ' + char(10)
		SELECT @v_dSql += N'		           WHEN DAY_SEQ=5 THEN ''(Thu.)''                                                                   ' + char(10)
		SELECT @v_dSql += N'		           WHEN DAY_SEQ=6 THEN ''(Fri.)''                                                                   ' + char(10)
		SELECT @v_dSql += N'		           WHEN DAY_SEQ=7 THEN ''(Sat.)''                                                                   ' + char(10)
		SELECT @v_dSql += N'		           ELSE ''(SUN.)'' END)                                                                             ' + char(10)
		SELECT @v_dSql += N'		    AS _DATE_TXT                                                                                            ' + char(10)
		SELECT @v_dSql += N'		    ,DAY_SEQ                                                                                                ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL A WITH(NOLOCK)                                                                                ' + char(10)
		SELECT @v_dSql += N'	WHERE  YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                     ' + char(10)
		SELECT @v_dSql += N'	ORDER BY YYYYMMDD                                                                                               ' + char(10)

	END

	IF @p_sys_flag = 'MONTH_CNT'	-- find_MonthCnt
	BEGIN

		SELECT @v_dSql += N'	SELECT 	YYYYMM AS MONTH																	' + char(10)
		SELECT @v_dSql += N'	   		, SUBSTRING(YYYYMM,1,4) + ''-'' +                                               ' + char(10)
		SELECT @v_dSql += N'		     (CASE WHEN MONTH = ''01'' THEN ''Jan''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''02'' THEN ''Feb''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''03'' THEN ''Mar''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''04'' THEN ''Apr''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''05'' THEN ''May''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''06'' THEN ''Jun''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''07'' THEN ''Jul''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''08'' THEN ''Aug''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''09'' THEN ''Sep''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''10'' THEN ''Oct''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''11'' THEN ''Nov''                                         ' + char(10)
		SELECT @v_dSql += N'		           ELSE ''Dec'' END) AS MONTH_NAME                                          ' + char(10)
		SELECT @v_dSql += N'		   , COUNT(*) AS MONTH_COUNT                                                        ' + char(10)
		SELECT @v_dSql += N'		   , ''M'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMM))-1) AS M_VALUE     ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                                   ' + char(10)
		SELECT @v_dSql += N'	WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @p_bucket_from +''', 112)                       ' + char(10)
		SELECT @v_dSql += N'	AND    CAL.DT <= CONVERT(DATETIME, '''+ @p_bucket_to +''', 112)                         ' + char(10)
		SELECT @v_dSql += N'	GROUP BY YYYYMM, MONTH                                                                  ' + char(10)
		SELECT @v_dSql += N'	ORDER BY YYYYMM                                                                         ' + char(10)

	END

	IF @p_sys_flag = 'BUCKET_INFO'	-- find_bukInfo
	BEGIN

		SELECT @v_dSql += N'	SELECT A.*                                                                                                         		' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'			  SELECT YYYYMMDD AS _DATE                                                                                      ' + char(10)
		SELECT @v_dSql += N'			        ,SUBSTRING(YYYYMMDD,1,4) + ''-'' + SUBSTRING(YYYYMMDD,5,2) + ''-'' + SUBSTRING(YYYYMMDD,7,2) + '' ''    ' + char(10)
		SELECT @v_dSql += N'			        +(CASE WHEN DAY_SEQ=2 THEN ''(Mon)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=3 THEN ''(Tue)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=4 THEN ''(Wed)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=5 THEN ''(Thu)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=6 THEN ''(Fri)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=7 THEN ''(Sat)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               ELSE ''(SUN)'' END)                                                                              ' + char(10)
		SELECT @v_dSql += N'			        AS _NAME                                                                                                ' + char(10)
		SELECT @v_dSql += N'			        , 1 AS _COUNT                                                                                           ' + char(10)
		SELECT @v_dSql += N'			        ,''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS _VALUE                            ' + char(10)
		SELECT @v_dSql += N'			        , 1 AS _DATE_SEQ                                                                                        ' + char(10)
		SELECT @v_dSql += N'			        , ISO_YYYYWW AS WEEK_SEQ                                                                                ' + char(10)
		SELECT @v_dSql += N'			        , ''D'' AS _TYPE                                                                                        ' + char(10)
		SELECT @v_dSql += N'			  FROM   TH_UIS_CAL A WITH(NOLOCK)                                                                              ' + char(10)
		SELECT @v_dSql += N'			  WHERE  YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                   ' + char(10)
		SELECT @v_dSql += N'			  UNION ALL                                                                                                     ' + char(10)
		SELECT @v_dSql += N'			  SELECT ISO_YYYYWW AS _DATE                                                                                    ' + char(10)
		SELECT @v_dSql += N'			       , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS _NAME                               ' + char(10)
		SELECT @v_dSql += N'			       , COUNT(*) AS _COUNT                                                                                     ' + char(10)
		SELECT @v_dSql += N'			       , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS _VALUE                          ' + char(10)
		SELECT @v_dSql += N'			       , 1 AS _DATE_SEQ                                                                                         ' + char(10)
		SELECT @v_dSql += N'			       , ISO_YYYYWW AS WEEK_SEQ                                                                                 ' + char(10)
		SELECT @v_dSql += N'			       , ''W'' AS _TYPE                                                                                         ' + char(10)
		SELECT @v_dSql += N'			  FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                                                         ' + char(10)
		SELECT @v_dSql += N'			  WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @p_bucket_from +''', 112)                                             ' + char(10)
		SELECT @v_dSql += N'			  AND    CAL.DT <= CONVERT(DATETIME, '''+ @p_bucket_to +''', 112)                                               ' + char(10)
		SELECT @v_dSql += N'			  GROUP BY ISO_YYYYWW                                                                                           ' + char(10)
		SELECT @v_dSql += N'		) A                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	ORDER BY WEEK_SEQ, (CASE WHEN _TYPE = ''W'' THEN 1 ELSE 2 END), _DATE                                                   ' + char(10)

	END

	IF @p_sys_flag = 'BUCKET_INFO_LVL1'	-- find_bukInfo_LVL1
	BEGIN

		SELECT @v_dSql += N'	SELECT 	A.*																												' + char(10)
		SELECT @v_dSql += N'	FROM 	(                                                                                                               ' + char(10)
		SELECT @v_dSql += N'			  SELECT YYYYMMDD AS _DATE                                                                                      ' + char(10)
		SELECT @v_dSql += N'			        ,SUBSTRING(YYYYMMDD,1,4) + ''-'' + SUBSTRING(YYYYMMDD,5,2) + ''-'' + SUBSTRING(YYYYMMDD,7,2) + '' ''    ' + char(10)
		SELECT @v_dSql += N'			        +(CASE WHEN DAY_SEQ=2 THEN ''(Mon)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=3 THEN ''(Tue)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=4 THEN ''(Wed)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=5 THEN ''(Thu)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=6 THEN ''(Fri)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=7 THEN ''(Sat)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               ELSE ''(SUN)'' END)                                                                              ' + char(10)
		SELECT @v_dSql += N'			        AS _NAME                                                                                                ' + char(10)
		SELECT @v_dSql += N'			        , 1 AS _COUNT                                                                                           ' + char(10)
		SELECT @v_dSql += N'			        ,''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS _VALUE                            ' + char(10)
		SELECT @v_dSql += N'			        , 1 AS _DATE_SEQ                                                                                        ' + char(10)
		SELECT @v_dSql += N'			        , ISO_YYYYWW AS WEEK_SEQ                                                                                ' + char(10)
		SELECT @v_dSql += N'			        , ''D'' AS _TYPE                                                                                        ' + char(10)
		SELECT @v_dSql += N'			  FROM   TH_UIS_CAL A WITH(NOLOCK)                                                                              ' + char(10)
		SELECT @v_dSql += N'			  WHERE  YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                         ' + char(10)
		SELECT @v_dSql += N'			  UNION ALL                                                                                                     ' + char(10)
		SELECT @v_dSql += N'			  SELECT ISO_YYYYWW AS _DATE                                                                                    ' + char(10)
		SELECT @v_dSql += N'			       , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS _NAME                               ' + char(10)
		SELECT @v_dSql += N'			       , COUNT(*) AS _COUNT                                                                                     ' + char(10)
		SELECT @v_dSql += N'			       , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS _VALUE                          ' + char(10)
		SELECT @v_dSql += N'			       , 1 AS _DATE_SEQ                                                                                         ' + char(10)
		SELECT @v_dSql += N'			       , ISO_YYYYWW AS WEEK_SEQ                                                                                 ' + char(10)
		SELECT @v_dSql += N'			       , ''W'' AS _TYPE                                                                                         ' + char(10)
		SELECT @v_dSql += N'			  FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                                                         ' + char(10)
		SELECT @v_dSql += N'			  WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @p_bucket_from +''', 112)                                                        ' + char(10)
		SELECT @v_dSql += N'			  AND    CAL.DT <= CONVERT(DATETIME, '''+ @p_bucket_to +''', 112)                                                          ' + char(10)
		SELECT @v_dSql += N'			  GROUP BY ISO_YYYYWW                                                                                           ' + char(10)
		SELECT @v_dSql += N'			) A                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	ORDER BY WEEK_SEQ, (CASE WHEN _TYPE = ''W'' THEN 1 ELSE 2 END), _DATE                                                   ' + char(10)
	
	END

	IF @p_sys_flag = 'PLAN_INFO'	-- findFpPlan_info
	BEGIN

		SELECT @v_dSql += N'	WITH RELEASE_PLAN AS (                           																																									' + char(10)
		SELECT @v_dSql += N'							  SELECT DISTINCT                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'							         A.INSTANCE_ID                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'							        ,A.RELEASE_PLAN_ID AS PLAN_ID                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'							        ,STUFF(( SELECT '','' + FACTORY_ID                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'							                 FROM   FP_RELEASE_PLAN_INFO_H B                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'							                 WHERE  A.INSTANCE_ID     = B.INSTANCE_ID                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'							                 AND    A.INSTANCE_DATE   = B.INSTANCE_DATE                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'							                 AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'							                 FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'							        ,A.PLAN_GROUP_ID                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'							        ,A.INSTANCE_DATE AS PLAN_DATE                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'							  FROM   FP_RELEASE_PLAN_INFO_H A                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'							  WHERE  1=1                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_DATE' , 'EQ', @p_plan_date)) + char(10)
		SELECT @v_dSql += N'						)                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	SELECT 	A.PLAN_ID AS CODE, SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS NAME                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_ID                                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_TYPE                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_START_TIME                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_HORIZON                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_HORIZON_UOM                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		    ,A.DEMAND_HORIZON                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		    ,A.DEMAND_HORIZON_UOM                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'		    ,A.CONFIG_SET_ID                                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'		    ,A.BASIS_PLAN_ID                                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'		    ,A.DEMAND_PLAN_ID                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		    ,A.SCP_PLAN_ID                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_WEEK                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'		    --,CONVERT(VARCHAR(8), DATEADD(DAY,-28, A.PLAN_START_TIME), 112) AS PLAN_START_DATE                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		    --,CONVERT(VARCHAR(8), DATEADD(DAY, 55, A.PLAN_START_TIME), 112) AS PLAN_END_DATE                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		    ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @p_plan_date +''')) AS PLAN_START_DATE                                                        ' + char(10)
		SELECT @v_dSql += N'		    ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @p_plan_date +''')))), 112) AS PLAN_END_DATE     ' + char(10)
		SELECT @v_dSql += N'		    ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @p_plan_date +''')) AS DEFAULT_START_DATE                                                     ' + char(10)
		SELECT @v_dSql += N'		    ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @p_plan_date +''')))), 112) AS DEFAULT_END_DATE  ' + char(10)
		SELECT @v_dSql += N'		    ,A.INSTANCE_ID                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		    ,A.SITE_ID                                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'		    ,A.DESCRIPTION                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_TYPE                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'		    ,CASE WHEN A.RELEASE_FLAG = ''Y'' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'		    ,CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		    ,CASE WHEN A.RELEASE_FLAG = ''Y''                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		    	  THEN (SELECT DISTINCT SA.DESCRIPTION FROM SCM_FP_PLAN_H SA WHERE A.INSTANCE_ID = SA.INSTANCE_ID AND A.BASIS_PLAN_ID = SA.PLAN_ID )                                                                    ' + char(10)
		SELECT @v_dSql += N'		    	  ELSE A.DESCRIPTION END AS DESCS                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'		    ,SUBSTRING(BASIS_PLAN_ID,CHARINDEX(''-'',BASIS_PLAN_ID)+1,11) AS BASIC_VERSION                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		    ,C.FACTORY_LT                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'		    ,(CASE WHEN PLAN_TYPE = ''RELEASE'' THEN ''Y''	 WHEN RIGHT(A.PLAN_ID,2) = ''00'' THEN ''Y'' ELSE ''N'' END) AS READ_ONLY  ' + char(10)
		SELECT @v_dSql += N'	FROM   	SCM_FP_PLAN_H A WITH(NOLOCK)                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN RELEASE_PLAN C WITH(NOLOCK)                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'			ON  A.INSTANCE_ID = C.INSTANCE_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'			AND A.PLAN_ID = C.PLAN_ID                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1                                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CONVERT(VARCHAR(8), PLAN_START_TIME, 112)' , 'EQ', @p_plan_date)) + char(10)
		--IF @p_plan_date <> '' BEGIN
		--	SELECT @v_dSql += N'	AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = '''+ @p_plan_date +'''                                                                                                                                                    ' + char(10)
		--END
		SELECT @v_dSql += N'	ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC                                                                                                                                                ' + char(10)

	END
	
	IF @p_sys_flag = 'RELEASE_PLAN_INFO'	-- find_releasePlanList
	BEGIN

		SELECT @v_dSql += N'	WITH T_CONFIRM AS (																																' + char(10)
		SELECT @v_dSql += N'	      		SELECT CONFIRM_DATE, CONFIRM_ID, CONFIRM_PLAN_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'				FROM (                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'				    SELECT CONVERT(VARCHAR(25),A.CONFIRM_TIME ,120) AS CONFIRM_DATE, A.UPDATE_ID AS CONFIRM_ID, A.PLAN_ID AS CONFIRM_PLAN_ID        ' + char(10)
		SELECT @v_dSql += N'				          , ROW_NUMBER( )                                                                                                           ' + char(10)
		SELECT @v_dSql += N'				          	OVER( PARTITION BY A.INSTANCE_ID ORDER BY CONFIRM_TIME DESC ) AS ROW_NUM                                                ' + char(10)
		SELECT @v_dSql += N'				    FROM  SCM_FP_IN_HOUSE_PLAN_H A WITH(NOLOCK)                                                                                     ' + char(10)
		SELECT @v_dSql += N'				    WHERE INSTANCE_ID = '''+ @p_instance_id +'''                                                                                    ' + char(10)
		SELECT @v_dSql += N'				    AND CONFIRM_FLAG = ''Y''                                                                                                        ' + char(10)
		SELECT @v_dSql += N'				) A                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'				WHERE ROW_NUM = 1                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	)                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	SELECT A.INSTANCE_ID, A.PLAN_ID, A.CONFIRM_FLAG                                                                                                 ' + char(10)
		SELECT @v_dSql += N'		  , CONVERT(VARCHAR, '''+ @p_plan_date +''', 112)  AS PLAN_START_DATE                                                                       ' + char(10)
		SELECT @v_dSql += N'	      ,(SELECT CONVERT(VARCHAR,CONVERT(DATETIME,DATED7) + 29,112) FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @p_plan_date +''')) AS PLAN_END_DATE	' + char(10)
		SELECT @v_dSql += N'	      , A.INSERT_ID                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	  	  , A.INSERT_TIME                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	      , A.UPDATE_ID                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	      , A.UPDATE_TIME                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	      , A.CONFIRM_TIME                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	      , A.DESCRIPTION                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	      , CASE WHEN YEAR(ISNULL(A.FIX_DATE,GETDATE())) < ''2018'' THEN NULL ELSE CONVERT(VARCHAR, A.FIX_DATE, 23) END AS FIX_DATE                 ' + char(10)
		SELECT @v_dSql += N'	      , C.CONFIRM_DATE                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	      , C.CONFIRM_ID                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	      , C.CONFIRM_PLAN_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	      , ( SELECT (CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < (FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'') + AA.BASIS_START_TIME) THEN CONVERT(VARCHAR,DATEADD(DD,-1,FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'')),112) 	' + char(10)
		SELECT @v_dSql += N'						   ELSE FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'') END) AS CURR_DATE                                                 ' + char(10)
		SELECT @v_dSql += N'		  	  FROM   FP_INSTANCE_START_TIME_V AA                                                                                                    ' + char(10)
		SELECT @v_dSql += N'		      WHERE  AA.INSTANCE_ID = A.INSTANCE_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'		    ) AS CUR_DATE                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	FROM SCM_FP_IN_HOUSE_PLAN_H A WITH(NOLOCK)                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	  LEFT OUTER JOIN T_CONFIRM C                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	  ON 1=1                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	  	 , (                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'			SELECT DISTINCT B.INSTANCE_ID, B.SITE_ID                                                                                                ' + char(10)
		SELECT @v_dSql += N'	      	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                               ' + char(10)
		SELECT @v_dSql += N'	      	WHERE  B.USER_ID     = '''+ @p_user_id +'''                                                                                             ' + char(10)
		SELECT @v_dSql += N'		  ) B                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.INSTANCE_ID = B.INSTANCE_ID                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	AND   A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	AND   SUBSTRING(A.PLAN_ID,1,8) = '''+ @p_plan_date +'''                                                                                         ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A.PLAN_ID DESC                                                                                                                         ' + char(10)

	END
	
	IF @p_sys_flag = 'PLAN_DATE'	-- find_planDate
	BEGIN

		SELECT @v_dSql += N'	SELECT CONVERT(VARCHAR, '''+ @p_plan_date +''', 112) AS PLAN_DATE															' + char(10)
        SELECT @v_dSql += N'	   , CONVERT(VARCHAR, DATEADD(WK, DATEDIFF(WK,0,CONVERT(DATETIME,'''+ @p_plan_date +''')), 0), 112)  AS PLAN_START_DATE		' + char(10)
        SELECT @v_dSql += N'	   , CONVERT(VARCHAR, DATEADD(WK, DATEDIFF(WK,0,CONVERT(DATETIME,'''+ @p_plan_date +''') + 30), 0), 112) AS PLAN_END_DATE	' + char(10)

	END

	IF @p_sys_flag = 'LIST_DATA'	-- find_ListData
	BEGIN

		SELECT @v_dSql += N'	SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID 			' + char(10)
		SELECT @v_dSql += N'	    , A.CELL_ITEM_ID                                                                ' + char(10)
		SELECT @v_dSql += N'	    , A.STORAGE_ID, A.SOC_ID, A.MARKET                                              ' + char(10)
		SELECT @v_dSql += N'	    , CONVERT(VARCHAR,A.REQUIRE_DATE,112) AS REQUIRE_DATE                           ' + char(10)
		SELECT @v_dSql += N'	    , A.REQUIRE_QTY                                                                 ' + char(10)
		SELECT @v_dSql += N'	FROM    FP_DEMAND_PACK_REQUIRE_CELL_H A WITH(NOLOCK)                                ' + char(10)
		SELECT @v_dSql += N'	WHERE   1=0                                                                         ' + char(10)
		SELECT @v_dSql += N'	AND	CONVERT(VARCHAR,A.REQUIRE_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''       ' + char(10)
		SELECT @v_dSql += N'	AND	A.INSTANCE_ID = '''+ @p_instance_id +'''                                        ' + char(10)
		SELECT @v_dSql += N'	AND	A.PLAN_ID = '''+ @p_plan_date +'''                                              ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                         ' + char(10)
		SELECT @v_dSql += N'	     , A.CELL_ITEM_ID                                                               ' + char(10)
		SELECT @v_dSql += N'	     , A.STORAGE_ID, A.SOC_ID, A.MARKET, A.REQUIRE_DATE                             ' + char(10)

	END

	IF @p_sys_flag = 'BOM_RATE'	-- find_BomRate
	BEGIN

		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_ITEM_ID, A.CELL_ITEM_ID, A.PARENT_QTY, A.CHILD_QTY   		' + char(10)
		SELECT @v_dSql += N'	   , (CASE WHEN A.PARENT_QTY IS NULL OR A.PARENT_QTY = 0 THEN 1 ELSE (A.CHILD_QTY/A.PARENT_QTY) END) AS BOM_RATE            ' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	      SELECT DISTINCT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                   ' + char(10)
		SELECT @v_dSql += N'	     , A.PARENT_ITEM_ID AS PACK_ITEM_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'	     , A.CHILD_ITEM_ID AS CELL_ITEM_ID                                                                                      ' + char(10)
		SELECT @v_dSql += N'	     , A.PARENT_QTY, A.CHILD_QTY                                                                                            ' + char(10)
		SELECT @v_dSql += N'	     , RANK( ) OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID     ' + char(10)
		SELECT @v_dSql += N'	                           ORDER BY     A.KEY_DATE DESC ) AS KEY_CNT                                                        ' + char(10)
		SELECT @v_dSql += N'	     , A.KEY_DATE                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_BOM_M A WITH(NOLOCK),                                                                                            ' + char(10)
		SELECT @v_dSql += N'	  		 SCM_ITEM_M B WITH(NOLOCK),                                                                                         ' + char(10)
		SELECT @v_dSql += N'	  		 SCM_ITEM_CLASS_M C WITH(NOLOCK),                                                                                   ' + char(10)
		SELECT @v_dSql += N'	  		 SCM_ITEM_M D WITH(NOLOCK),                                                                                         ' + char(10)
		SELECT @v_dSql += N'	  		 SCM_ITEM_CLASS_M E WITH(NOLOCK)                                                                                    ' + char(10)
		SELECT @v_dSql += N'	WHERE  CONVERT(VARCHAR, A.EFF_START_DATE, 112) <= CONVERT(VARCHAR, dbo.SYSDATE1(), 112)                                     ' + char(10)
		SELECT @v_dSql += N'	AND    CONVERT(VARCHAR, A.EFF_END_DATE, 112) > CONVERT(VARCHAR, dbo.SYSDATE1(), 112)                                        ' + char(10)
		SELECT @v_dSql += N'	AND    BOM_VERSION_ID = 1                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	AND 	 A.PARENT_ITEM_ID = B.ITEM_ID                                                                                       ' + char(10)
		SELECT @v_dSql += N'	AND 	 B.ITEM_CLASS = C.CLASS_ID                                                                                          ' + char(10)
		SELECT @v_dSql += N'	AND 	 C.LEVEL_2_CODE = ''AMD''                                                                                           ' + char(10)
		SELECT @v_dSql += N'	AND 	 A.CHILD_ITEM_ID = D.ITEM_ID                                                                                        ' + char(10)
		SELECT @v_dSql += N'	AND 	 D.ITEM_CLASS = E.CLASS_ID                                                                                          ' + char(10)
		SELECT @v_dSql += N'	AND 	 E.LEVEL_3_NAME = ''CELL''                                                                                          ' + char(10)
		SELECT @v_dSql += N'	) A                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	WHERE A.KEY_CNT = 1                                                                                                         ' + char(10)

	END

	IF @p_sys_flag = 'ITEM_CMA'	-- find_ItemCMA
	BEGIN

		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID																														' + char(10)							
		SELECT @v_dSql += N'	       , A.TOP_ITEM_ID AS MODEL, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME             																	                ' + char(10)
		SELECT @v_dSql += N'	       , A.STORAGE_ID, A.LINE_ID, A.MARKET, A.LINE_NAME																		                                                    ' + char(10)
		
		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
		
				-- Day bucket
				SET @mst_loop_cnt = 0	

				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = ''
					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END

					SELECT @v_dSql += N'	  			, SUM(CONVERT(NUMERIC(25,10), CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN A.PLAN_QTY ELSE 0 END)) AS  D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY   ' + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	FROM (             																	                                                                                            ' + char(10)
		SELECT @v_dSql += N'		SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,														                                            ' + char(10)
		SELECT @v_dSql += N'					A.TOP_ITEM_ID, A.ITEM_ID, A.MARKET, A.LINE_ID,B.LINE_NAME,													                                                    ' + char(10)
		SELECT @v_dSql += N'					CASE WHEN A.MARKET = ''D'' THEN B.DOMESTIC_SLOC_ID WHEN A.MARKET = ''E'' THEN B.EXPORT_SLOC_ID ELSE B.DOMESTIC_SLOC_ID END AS STORAGE_ID,						' + char(10)							
		SELECT @v_dSql += N'				    A.PLAN_DATE, A.PLAN_QTY, A.PLAN_IN_QTY													                                                                        ' + char(10)
		SELECT @v_dSql += N'		FROM 	FP_DAILY_PRODUCTIOIN_PLAN_H A,														                                                                                ' + char(10)
		SELECT @v_dSql += N'				  SCM_LINE_M B													                                                                                                    ' + char(10)
		SELECT @v_dSql += N'		WHERE 	1=1														                                                                                                            ' + char(10)
		SELECT @v_dSql += N'		AND 	A.SITE_ID = B.SITE_ID														                                                                                        ' + char(10)
		SELECT @v_dSql += N'		AND 	A.DIVISION_ID = B.DIVISION_ID														                                                                                ' + char(10)
		SELECT @v_dSql += N'		AND 	A.PLANT_ID = B.PLANT_ID														                                                                                        ' + char(10)
		SELECT @v_dSql += N'		AND 	A.FACTORY_ID = B.FACTORY_ID	                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		--AND 	A.OPERATION_ID = B.OPERATION_ID													                                                                                    ' + char(10)
		-- 하드코딩 'G388'
		SELECT @v_dSql += N'         AND   B.OPERATION_ID = (CASE WHEN A.PLANT_ID = ''' + @p_plant_id_cond + ''' THEN ''P5000'' ELSE ''P1000'' END)    ' + char(10)
		SELECT @v_dSql += N'		AND 	A.LINE_ID = B.LINE_ID	                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'		AND    B.ACTIVE_FLAG = ''Y''														                                                                                        ' + char(10)
		SELECT @v_dSql += N'		AND 	A.PLAN_TYPE = ''RELEASE''														                                                                                    ' + char(10)
		SELECT @v_dSql += N'		AND    	CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''       ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	    AND    A.OPERATION_ID = ''P5000''                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	    AND 	A.ITEM_ID = '''+ @p_item_id +'''														                                                                            ' + char(10)
		SELECT @v_dSql += N'		AND 	CASE WHEN A.MARKET = ''D'' THEN B.DOMESTIC_SLOC_ID WHEN A.MARKET = ''E'' THEN B.EXPORT_SLOC_ID ELSE B.DOMESTIC_SLOC_ID END = '''+ @p_storage_id +'''                ' + char(10)
		SELECT @v_dSql += N'	    											                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	) A															                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	INNER JOIN SCM_ITEM_M B WITH(NOLOCK)															                                                                                ' + char(10)
		SELECT @v_dSql += N'	ON  A.COMPANY_ID  = B.COMPANY_ID																	                                                                            ' + char(10)
		SELECT @v_dSql += N'	AND A.DIVISION_ID = B.DIVISION_ID																	                                                                            ' + char(10)
		SELECT @v_dSql += N'	AND A.SITE_ID     = B.SITE_ID																	                                                                                ' + char(10)
		SELECT @v_dSql += N'	AND A.ITEM_ID     = B.ITEM_ID																	                                                                                ' + char(10)
		SELECT @v_dSql += N'	AND B.ACTIVE_FLAG = ''Y''																	                                                                                    ' + char(10)
		SELECT @v_dSql += N'	INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)																	                                                                    ' + char(10)
		SELECT @v_dSql += N'	ON  A.PLAN_DATE   = C.YYYYMMDD                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	INNER JOIN SCM_LINE_M D WITH(NOLOCK)                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	ON     A.COMPANY_ID     = D.COMPANY_ID                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	AND    A.DIVISION_ID    = D.DIVISION_ID                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	AND    A.SITE_ID        = D.SITE_ID                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLANT_ID       = D.PLANT_ID                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	AND    A.LINE_ID        = D.LINE_ID																	                                                                            ' + char(10)
		SELECT @v_dSql += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID																	                                                    ' + char(10)
		SELECT @v_dSql += N'	   , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'')             																	                                        ' + char(10)
		SELECT @v_dSql += N'	   , A.STORAGE_ID, A.LINE_ID, A.MARKET, A.LINE_NAME		                                                                                                                        ' + char(10)

	END

	IF @p_sys_flag = 'CONFIRM_INFO'	-- find_ConfirmInfo
	BEGIN

		SELECT @v_dSql += N'	SELECT CONFIRM_DATE, CONFIRM_ID																	' + char(10)
		SELECT @v_dSql += N'	FROM (																							' + char(10)
		SELECT @v_dSql += N'		SELECT CONVERT(VARCHAR(25),A.CONFIRM_TIME ,120) AS CONFIRM_DATE, A.UPDATE_ID AS CONFIRM_ID	' + char(10)
		SELECT @v_dSql += N'				, ROW_NUMBER( )     																' + char(10)
		SELECT @v_dSql += N'				OVER( PARTITION BY A.INSTANCE_ID ORDER BY CONFIRM_TIME DESC ) AS ROW_NUM			' + char(10)
		SELECT @v_dSql += N'		FROM  SCM_FP_IN_HOUSE_PLAN_H A WITH(NOLOCK)													' + char(10)
		SELECT @v_dSql += N'		WHERE INSTANCE_ID = '''+ @p_instance_id +'''												' + char(10)
		SELECT @v_dSql += N'		AND CONFIRM_FLAG = ''Y''																	' + char(10)
		SELECT @v_dSql += N'	) A																								' + char(10)
		SELECT @v_dSql += N'	WHERE ROW_NUM = 1																				' + char(10)

	END

	IF @p_sys_flag = 'CALCULATION_LIST'	-- find_CalculationList
	BEGIN

		SELECT @v_dSql += N'	SELECT A.INSTANCE_ID, A.PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_ITEM_ID, B.NICK_NAME, ''0'' AS _CHK_ITEM										' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'		SELECT A.INSTANCE_ID, A.PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_ITEM_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'		FROM   FP_DEMAND_PACK_REQUIRE_CELL_H A WITH(NOLOCK)                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'		WHERE  CONVERT(VARCHAR,A.REQUIRE_DATE,112) >= CONVERT(VARCHAR, '''+ @p_plan_date +''',112)                                                                          ' + char(10)
		SELECT @v_dSql += N'		AND	 A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'		AND	 A.PLAN_ID = '''+ @p_plan_id +'''                                                                                                                               ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ITEM_ID' , 'LIKE', @p_cell_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	    UNION ALL                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		SELECT '''+ @p_instance_id +''' AS INSTANCE_ID, '''+ @p_plan_id +''' AS PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_ITEM_ID                            ' + char(10)
		SELECT @v_dSql += N'		FROM (                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID													                                                ' + char(10)
		SELECT @v_dSql += N'	                   , A.ITEM_ID, C.CHILD_ITEM_ID AS CELL_ITEM_ID													                                                        ' + char(10)
		SELECT @v_dSql += N'	                FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK),													                                                    ' + char(10)
		SELECT @v_dSql += N'	            		 SCM_LINE_M B WITH(NOLOCK),					                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	            		 (                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	            		 	SELECT SB.*                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	            		 	FROM (                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'							      SELECT C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, MAX(C.CHILD_QTY/C.PARENT_QTY) AS BOM_RATE, C.ALT_PRIORITY             ' + char(10)
		SELECT @v_dSql += N'							      		 , RANK() OVER (PARTITION BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID ORDER BY  ISNULL(C.ALT_PRIORITY,99) * 10 ) AS IDX           ' + char(10)
		SELECT @v_dSql += N'							      FROM SCM_BOM_M C WITH(NOLOCK),											                                                                ' + char(10)
		SELECT @v_dSql += N'							        	 SCM_ITEM_M D WITH(NOLOCK),											                                                                ' + char(10)
		SELECT @v_dSql += N'							        	 SCM_ITEM_CLASS_M E WITH(NOLOCK)	                                                                                                ' + char(10)
		SELECT @v_dSql += N'							      WHERE 1=1                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'							      AND    C.EFF_END_DATE >= GETDATE()												                                                        ' + char(10)
		SELECT @v_dSql += N'							      --AND	  (C.ALT_PRIORITY IS NULL OR C.ALT_PRIORITY = ''1'')	                                                                            ' + char(10)
		SELECT @v_dSql += N'							      AND    C.COMPANY_ID = D.COMPANY_ID                                                                                                        ' + char(10)
		SELECT @v_dSql += N'							      AND    C.DIVISION_ID = D.DIVISION_ID                                                                                                      ' + char(10)
		SELECT @v_dSql += N'							      AND    C.SITE_ID = D.SITE_ID												                                                                ' + char(10)
		SELECT @v_dSql += N'							      AND    C.CHILD_ITEM_ID = D.ITEM_ID												                                                        ' + char(10)
		SELECT @v_dSql += N'							      AND    C.SITE_ID = D.SITE_ID													                                                            ' + char(10)
		SELECT @v_dSql += N'							      AND    C.DIVISION_ID = D.DIVISION_ID													                                                    ' + char(10)
		SELECT @v_dSql += N'							      AND	 D.ITEM_CLASS = E.CLASS_ID                                                                                                          ' + char(10)
		SELECT @v_dSql += N'							      AND 	 E.LEVEL_3_NAME = ''CELL''                                                                                                          ' + char(10)

		IF @p_instance_id = 'PL_PACK' BEGIN
			SELECT @v_dSql += N'						            	AND NOT EXISTS (																									                ' + char(10)
			SELECT @v_dSql += N'														SELECT	A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS MODULE, A.SEGMENT3 AS CELL_GROUP_CODE                                  ' + char(10)
			SELECT @v_dSql += N'														FROM	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                         ' + char(10)
			SELECT @v_dSql += N'														WHERE	A.LOOKUP_TYPE_CODE = ''MODULE_TO_CELL_GROUP''                                                               ' + char(10)
			SELECT @v_dSql += N'														AND	A.ACTIVE_FLAG = ''Y''                                                                                           ' + char(10)
			SELECT @v_dSql += N'														AND	C.SITE_ID = A.SEGMENT1                                                                                          ' + char(10)
			SELECT @v_dSql += N'														AND	C.PARENT_ITEM_ID = A.SEGMENT2                                                                                   ' + char(10)
			SELECT @v_dSql += N'														AND	C.CHILD_ITEM_ID = A.SEGMENT3                                                                                    ' + char(10)
			SELECT @v_dSql += N'													)                                                                                                                       ' + char(10)
		END

		SELECT @v_dSql += N'							      GROUP BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, C.ALT_PRIORITY                                                      ' + char(10)
		SELECT @v_dSql += N'							  ) SB                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'							  WHERE SB.IDX = 1                                                                                                                              ' + char(10)

		IF @p_instance_id = 'PL_PACK' BEGIN
			SELECT @v_dSql += N'											UNION ALL																														' + char(10)				
			SELECT @v_dSql += N'											SELECT SB.*                                                                                                                     ' + char(10)        
			SELECT @v_dSql += N'				            		 		FROM (                                                                                                                          ' + char(10)        
			SELECT @v_dSql += N'											      SELECT C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, MAX(C.CHILD_QTY/C.PARENT_QTY) AS BOM_RATE, C.ALT_PRIORITY		' + char(10)     
			SELECT @v_dSql += N'											      		 , RANK() OVER (PARTITION BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID ORDER BY  ISNULL(C.ALT_PRIORITY,99) * 10 ) AS IDX 	' + char(10)  
			SELECT @v_dSql += N'											      FROM SCM_BOM_M C WITH(NOLOCK),											                                                ' + char(10)        
			SELECT @v_dSql += N'											        	 SCM_ITEM_M D WITH(NOLOCK),											                                                ' + char(10)        
			SELECT @v_dSql += N'											        	 SCM_ITEM_CLASS_M E WITH(NOLOCK)	                                                                                ' + char(10)        
			SELECT @v_dSql += N'											      WHERE 1=1                                                                                                                 ' + char(10)        
			SELECT @v_dSql += N'											      AND    C.EFF_END_DATE >= GETDATE()												                                        ' + char(10)        
			SELECT @v_dSql += N'											      --AND	  (C.ALT_PRIORITY IS NULL OR C.ALT_PRIORITY = ''1'')	                                                            ' + char(10)            
			SELECT @v_dSql += N'											      AND    C.COMPANY_ID = D.COMPANY_ID                                                                                        ' + char(10)        
			SELECT @v_dSql += N'											      AND    C.DIVISION_ID = D.DIVISION_ID                                                                                      ' + char(10)        
			SELECT @v_dSql += N'											      AND    C.SITE_ID = D.SITE_ID												                                                ' + char(10)        
			SELECT @v_dSql += N'											      AND    C.CHILD_ITEM_ID = D.ITEM_ID												                                        ' + char(10)        
			SELECT @v_dSql += N'											      AND    C.SITE_ID = D.SITE_ID													                                            ' + char(10)        
			SELECT @v_dSql += N'											      AND    C.DIVISION_ID = D.DIVISION_ID													                                    ' + char(10)        
			SELECT @v_dSql += N'											      AND	 D.ITEM_CLASS = E.CLASS_ID                                                                                          ' + char(10)        
			SELECT @v_dSql += N'											      AND 	 E.LEVEL_3_NAME = ''CELL''                                                                                          ' + char(10)          
			SELECT @v_dSql += N'												  AND 	 EXISTS (																							                ' + char(10)        
			SELECT @v_dSql += N'																	SELECT	A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS MODULE, A.SEGMENT3 AS CELL_GROUP_CODE                      ' + char(10)        
			SELECT @v_dSql += N'																	FROM	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                             ' + char(10)        
			SELECT @v_dSql += N'																	WHERE	A.LOOKUP_TYPE_CODE = ''MODULE_TO_CELL_GROUP''                                                   ' + char(10)          
			SELECT @v_dSql += N'																	AND	A.ACTIVE_FLAG = ''Y''                                                                               ' + char(10)          
			SELECT @v_dSql += N'																	AND	C.SITE_ID = A.SEGMENT1                                                                              ' + char(10)        
			SELECT @v_dSql += N'																	AND	C.PARENT_ITEM_ID = A.SEGMENT2                                                                       ' + char(10)        
			SELECT @v_dSql += N'																	AND	C.CHILD_ITEM_ID = A.SEGMENT3                                                                        ' + char(10)        
			SELECT @v_dSql += N'																)                                                                                                           ' + char(10)        
			SELECT @v_dSql += N'									    	      GROUP BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, C.ALT_PRIORITY                                      ' + char(10)        
			SELECT @v_dSql += N'											  ) SB                                                                                                                          ' + char(10)        
			SELECT @v_dSql += N'											  WHERE SB.IDX = 1														                                                        ' + char(10)        
		END

		SELECT @v_dSql += N'						 ) C						                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	          	 WHERE  1=1                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'		          AND    A.OPERATION_ID IN (''P5000'', ''P5200'')                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		            AND    CONVERT(VARCHAR,A.PLAN_DATE,112) >= CONVERT(VARCHAR, '''+ @p_plan_date +''',112)                                                                 ' + char(10)
		SELECT @v_dSql += N'		            AND	   A.PLAN_TYPE = ''RELEASE''                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	          		AND    A.SITE_ID = B.SITE_ID													                                                                        ' + char(10)
		SELECT @v_dSql += N'	                AND    A.DIVISION_ID = B.DIVISION_ID													                                                                ' + char(10)
		SELECT @v_dSql += N'	                AND    A.OPERATION_ID = B.OPERATION_ID													                                                                ' + char(10)
		SELECT @v_dSql += N'	                AND    A.LINE_ID = B.LINE_ID													                                                                        ' + char(10)
		SELECT @v_dSql += N'	                AND    A.SITE_ID = C.SITE_ID													                                                                        ' + char(10)
		SELECT @v_dSql += N'	                AND    A.DIVISION_ID = C.DIVISION_ID													                                                                ' + char(10)
		SELECT @v_dSql += N'	                AND    A.ITEM_ID = C.PARENT_ITEM_ID												                                                                        ' + char(10)
		SELECT @v_dSql += N'	          	    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID													                                            ' + char(10)
		SELECT @v_dSql += N'	                       , A.ITEM_ID, C.CHILD_ITEM_ID	                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	           ) A										                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		) A                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'		INNER JOIN SCM_ITEM_M B WITH(NOLOCK)															                                                                    ' + char(10)
		SELECT @v_dSql += N'	    ON  A.COMPANY_ID    = B.COMPANY_ID																	                                                                ' + char(10)
		SELECT @v_dSql += N'	    AND A.DIVISION_ID   = B.DIVISION_ID																	                                                                ' + char(10)
		SELECT @v_dSql += N'	    AND A.SITE_ID       = B.SITE_ID																	                                                                    ' + char(10)
		SELECT @v_dSql += N'	    AND A.CELL_ITEM_ID  = B.ITEM_ID																	                                                                    ' + char(10)
		SELECT @v_dSql += N'	    AND B.ACTIVE_FLAG = ''Y''								                                                                                                            ' + char(10)
		SELECT @v_dSql += N'		WHERE 1=1                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		AND    EXISTS (                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'				        	SELECT 1                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'				        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                       ' + char(10)
		SELECT @v_dSql += N'				        	WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'				        	AND    A.DIVISION_ID = B.DIVISION_ID                                                                                                            ' + char(10)
		SELECT @v_dSql += N'				        	AND    A.SITE_ID     = B.SITE_ID                                                                                                                ' + char(10)
		SELECT @v_dSql += N'				        	AND    A.PLANT_ID	 = B.PLANT_ID                                                                                                               ' + char(10)
		SELECT @v_dSql += N'				        	AND    B.USER_ID     = '''+ @p_user_id +'''                                                                                                     ' + char(10)
		SELECT @v_dSql += N'				        	AND	   B.SAVE_FLAG	 = ''Y''                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'				      	)                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	    GROUP BY A.INSTANCE_ID, A.PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_ITEM_ID, B.NICK_NAME                                                  ' + char(10)
		SELECT @v_dSql += N'		ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_ITEM_ID			                                                                                ' + char(10)

	END

	IF @p_sys_flag = 'NICK_NAME'	-- find_FPNickName
	BEGIN

		SELECT @v_dSql += N'	SELECT DISTINCT ISNULL(B.NICK_NAME,''-'') AS CODE, ISNULL(B.NICK_NAME,''-'') AS NAME 							' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, C.CHILD_ITEM_ID AS CELL_ITEM_ID                       ' + char(10)
		SELECT @v_dSql += N'	  FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK),                                                            ' + char(10)
		SELECT @v_dSql += N'	    		 SCM_LINE_M B WITH(NOLOCK),                                                                         ' + char(10)
		SELECT @v_dSql += N'	    		 SCM_BOM_M C WITH(NOLOCK),                                                                          ' + char(10)
		SELECT @v_dSql += N'	    		 SCM_ITEM_M D WITH(NOLOCK),                                                                         ' + char(10)
		SELECT @v_dSql += N'	    		 SCM_ITEM_CLASS_M E WITH(NOLOCK)                                                                    ' + char(10)
		SELECT @v_dSql += N'	  WHERE  A.PLAN_TYPE = ''RELEASE''                                                                              ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	  AND    A.OPERATION_ID IN (''P5000'', ''P5200'')                                                               ' + char(10)
		SELECT @v_dSql += N'	  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                 ' + char(10)
		SELECT @v_dSql += N'	  AND    A.SITE_ID      = B.SITE_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'	  AND    A.DIVISION_ID  = B.DIVISION_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'	  AND    A.OPERATION_ID = B.OPERATION_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'	  AND    A.LINE_ID      = B.LINE_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'	  AND    A.SITE_ID      = C.SITE_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'	  AND    A.DIVISION_ID  = C.DIVISION_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'	  AND    C.EFF_END_DATE >= GETDATE()                                                                            ' + char(10)
		SELECT @v_dSql += N'	  AND    A.ITEM_ID = C.PARENT_ITEM_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'	  AND	   (C.ALT_PRIORITY IS NULL OR C.ALT_PRIORITY = ''1'')                                                   ' + char(10)
		SELECT @v_dSql += N'	  AND    C.COMPANY_ID     = D.COMPANY_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'	  AND    C.DIVISION_ID    = D.DIVISION_ID                                                                       ' + char(10)
		SELECT @v_dSql += N'	  AND    C.SITE_ID        = D.SITE_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'	  AND    C.CHILD_ITEM_ID  = D.ITEM_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'	  AND    C.SITE_ID        = D.SITE_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'	  AND    C.DIVISION_ID    = D.DIVISION_ID                                                                       ' + char(10)
		SELECT @v_dSql += N'	  AND	   D.ITEM_CLASS     = E.CLASS_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'	  AND 	 E.LEVEL_3_NAME   = ''Cell''                                                                            ' + char(10)
		SELECT @v_dSql += N'	                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	  UNION ALL                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.CELL_ITEM_ID                                        ' + char(10)
		SELECT @v_dSql += N'	  FROM (                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_ITEM_ID, SOC_ID                ' + char(10)
		SELECT @v_dSql += N'	      FROM   FP_DEMAND_PACK_REQUIRE_CELL_H A WITH(NOLOCK)                                                       ' + char(10)
		SELECT @v_dSql += N'	      WHERE  1=1                                                                                                ' + char(10)
		SELECT @v_dSql += N'	      AND	   A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                    ' + char(10)
		SELECT @v_dSql += N'	      AND	A.PLAN_ID = '''+ @p_plan_id +'''                                                                               ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	      AND CONVERT(VARCHAR,A.REQUIRE_DATE,112) BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +'''                               ' + char(10)
		SELECT @v_dSql += N'	      UNION ALL                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID AS CELL_ITEM_ID, SOC_ID     ' + char(10)
		SELECT @v_dSql += N'	      FROM   FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)                                                              ' + char(10)
		SELECT @v_dSql += N'	      WHERE  1=1                                                                                                ' + char(10)
		SELECT @v_dSql += N'	      AND	   A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                    ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	      AND CONVERT(VARCHAR, A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_plan_date +''' - 1                           ' + char(10)
		SELECT @v_dSql += N'	  ) A                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  INNER JOIN (                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	      SELECT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID, A.SEGMENT3 AS SOC_ID, ATTRIBUTE3 AS SORT_ORDER   ' + char(10)
		SELECT @v_dSql += N'	      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                ' + char(10)
		SELECT @v_dSql += N'	      WHERE  A.LOOKUP_TYPE_CODE = ''PACK_SOC''                                                                  ' + char(10)
		SELECT @v_dSql += N'	      AND    A.ACTIVE_FLAG = ''Y''                                                                              ' + char(10)
		SELECT @v_dSql += N'	  ) DD                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	  ON  A.DIVISION_ID = DD.DIVISION_ID                                                                            ' + char(10)
		SELECT @v_dSql += N'	  AND A.SITE_ID     = DD.SITE_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'	  AND A.SOC_ID      = DD.SOC_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'	) A, SCM_ITEM_M B WITH(NOLOCK)                                                                                  ' + char(10)
		SELECT @v_dSql += N'	WHERE A.COMPANY_ID   = B.COMPANY_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'	AND   A.DIVISION_ID  = B.DIVISION_ID                                                                            ' + char(10)
		SELECT @v_dSql += N'	AND   A.SITE_ID      = B.SITE_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'	AND   A.CELL_ITEM_ID = B.ITEM_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'	ORDER BY ISNULL(B.NICK_NAME,''-'')                                                                              ' + char(10)

	END

	IF @p_sys_flag = 'CONFIRM_FLAG'	-- find_ConfirmFlag
	BEGIN
		
		SELECT @v_dSql += N'	SELECT A.PLAN_ID, B.MAX_PLAN_ID														' + char(10)				
		SELECT @v_dSql += N'		    , CASE WHEN A.PLAN_ID <= B.MAX_PLAN_ID THEN ''N'' ELSE ''Y'' END AS CONFIRM_YN	' + char(10)
		SELECT @v_dSql += N'	FROM SCM_FP_IN_HOUSE_PLAN_H A														' + char(10)
		SELECT @v_dSql += N'		, (																				' + char(10)
		SELECT @v_dSql += N'		    SELECT MAX(PLAN_ID) AS MAX_PLAN_ID											' + char(10)
		SELECT @v_dSql += N'		    FROM SCM_FP_IN_HOUSE_PLAN_H A												' + char(10)
		SELECT @v_dSql += N'		    WHERE 1=1																	' + char(10)
		SELECT @v_dSql += N'		    AND A.INSTANCE_ID = '''+ @p_instance_id +'''											' + char(10)
		SELECT @v_dSql += N'		    AND A.CONFIRM_FLAG = ''Y''													' + char(10)
		SELECT @v_dSql += N'		    ) B																			' + char(10)
		SELECT @v_dSql += N'	WHERE 1=1																			' + char(10)
		SELECT @v_dSql += N'	AND A.INSTANCE_ID = '''+ @p_instance_id +'''													' + char(10)
		SELECT @v_dSql += N'	AND A.PLAN_ID = '''+ @p_plan_id +'''															' + char(10)

	END

	IF @p_sys_flag = 'CONFIRM_HISTORY'	-- find_ConfirmHis
	BEGIN
		
		SELECT @v_dSql += N'	SELECT CONVERT(VARCHAR(25),A.CONFIRM_TIME ,120) AS CONFIRM_DATE, A.UPDATE_ID AS CONFIRM_ID, A.PLAN_ID AS CONFIRM_PLAN_ID	' + char(10)
		SELECT @v_dSql += N'			, ROW_NUMBER() OVER( PARTITION BY A.INSTANCE_ID ORDER BY CONFIRM_TIME DESC ) AS ROW_NUM								' + char(10)
		SELECT @v_dSql += N'	FROM  SCM_FP_IN_HOUSE_PLAN_H A WITH(NOLOCK)																					' + char(10)
		SELECT @v_dSql += N'	WHERE INSTANCE_ID = '''+ @p_instance_id +'''																				' + char(10)
		SELECT @v_dSql += N'	AND CONFIRM_FLAG = ''Y''		' + char(10)

	END

	IF @p_sys_flag = 'SITE_DATE'	-- find_Site_Date
	BEGIN
		
		SELECT @v_dSql += N'	SELECT (CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < (FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'') + A.BASIS_START_TIME) THEN CONVERT(VARCHAR,DATEADD(DD,-1,FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'')),112) 	' + char(10)
		SELECT @v_dSql += N'					ELSE FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'') END) AS CUR_DATE	' + char(10)
		SELECT @v_dSql += N'	FROM   FP_INSTANCE_START_TIME_V A	' + char(10)
		SELECT @v_dSql += N'	INNER JOIN (										' + char(10)
		SELECT @v_dSql += N'		SELECT 	DISTINCT INSTANCE_ID, SITE_ID			' + char(10)
		SELECT @v_dSql += N'		FROM 	FP_INSTANCE_OPERATION_V					' + char(10)
		SELECT @v_dSql += N'		WHERE 	INSTANCE_ID = '''+ @p_instance_id +'''				' + char(10)
		SELECT @v_dSql += N'	) B													' + char(10)
		SELECT @v_dSql += N'	ON 1=1												' + char(10)
		SELECT @v_dSql += N'	WHERE  A.INSTANCE_ID = B.INSTANCE_ID				' + char(10)

	END

	IF @p_sys_flag = 'CHECK_MASTER_INFO'	-- find_checkMasterInfo
	BEGIN
		
		SELECT @v_dSql += N'	SELECT ''Y'' AS _FLAG															' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                          ' + char(10)
		SELECT @v_dSql += N'	  SELECT F.INSTANCE_ID, F.FACTORY_ID                                            ' + char(10)
		SELECT @v_dSql += N'	        , (SELECT TOP 1 F.FACTORY_ID                                            ' + char(10)
		SELECT @v_dSql += N'	           FROM SCM_FACTORY_M            SF WITH(NOLOCK)                        ' + char(10)
		SELECT @v_dSql += N'	             ,SCM_SYS_LOOKUP_VALUE       SLV WITH(NOLOCK)                       ' + char(10)
		SELECT @v_dSql += N'	             ,SCM_DAILY_PRODUCT_RESULT_H P WITH(NOLOCK)                         ' + char(10)
		SELECT @v_dSql += N'	           WHERE  SF.FACTORY_ID   = F.FACTORY_ID                                ' + char(10)
		SELECT @v_dSql += N'	           AND    SF.ACTIVE_FLAG  = ''Y''                                       ' + char(10)
		SELECT @v_dSql += N'	           AND    SLV.LOOKUP_TYPE_CODE = ''FORMATION_MMD_ROUTE_CONVERT''        ' + char(10)
		SELECT @v_dSql += N'	           AND    SLV.SEGMENT1    = SF.SITE_ID                                  ' + char(10)
		SELECT @v_dSql += N'	           AND    SLV.SEGMENT2    = SF.DIVISION_ID                              ' + char(10)
		SELECT @v_dSql += N'	           AND    SLV.SEGMENT4    = SF.COMPANY_ID                               ' + char(10)
		SELECT @v_dSql += N'	           AND    SLV.ACTIVE_FLAG = ''Y''                                       ' + char(10)
		SELECT @v_dSql += N'	           AND    P.COMPANY_ID    = SF.COMPANY_ID                               ' + char(10)
		SELECT @v_dSql += N'	           AND    P.DIVISION_ID   = SF.DIVISION_ID                              ' + char(10)
		SELECT @v_dSql += N'	           AND    P.SITE_ID       = SF.SITE_ID                                  ' + char(10)
		SELECT @v_dSql += N'	           AND    P.PLANT_ID      = SF.PLANT_ID                                 ' + char(10)
		SELECT @v_dSql += N'	           AND    P.FACTORY_ID    = SF.FACTORY_ID                               ' + char(10)
		SELECT @v_dSql += N'	           AND    P.OPERATION_ID  = RIGHT(SLV.ATTRIBUTE1,5)                     ' + char(10)
		SELECT @v_dSql += N'	           AND    P.UPDATE_TIME   > '''+ @p_plan_date +''' )  AS UF -- 계획 수립일 조건    ' + char(10)
		SELECT @v_dSql += N'	  FROM   FP_INSTANCE_FACTORY_M F WITH(NOLOCK)                                   ' + char(10)
		SELECT @v_dSql += N'	  WHERE  F.INSTANCE_ID IN (                                                     ' + char(10)
		SELECT @v_dSql += N'	         SELECT  A.SEGMENT1 AS FORM_INSTANCE_ID                                 ' + char(10)
		SELECT @v_dSql += N'	         FROM    SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                            ' + char(10)
		SELECT @v_dSql += N'	         WHERE   A.LOOKUP_TYPE_CODE = ''FORMATION_PACK_INSTANCE_MAP''           ' + char(10)
		SELECT @v_dSql += N'	         AND     A.ACTIVE_FLAG      = ''Y''                                     ' + char(10)
		SELECT @v_dSql += N'	         AND     A.SEGMENT2         = '''+ @p_master_id +''' -- 선택한 pack instance       ' + char(10)
		SELECT @v_dSql += N'	  )                                                                             ' + char(10)
		SELECT @v_dSql += N'	  AND    F.ACTIVE_FLAG = ''Y''                                                  ' + char(10)
		SELECT @v_dSql += N'	  AND    F.FACTORY_ID NOT IN (SELECT SEGMENT1 FROM SCM_SYS_LOOKUP_VALUE WHERE LOOKUP_TYPE_CODE = ''ABNORMAL_FACTORY'' AND ACTIVE_FLAG = ''Y'')	' + char(10)
		SELECT @v_dSql += N'	) A                                                                             ' + char(10)
		SELECT @v_dSql += N'	HAVING COUNT(A.FACTORY_ID) = COUNT(A.UF)                                        ' + char(10)

	END


	IF @p_sys_flag = 'ITEM_LIST'	-- find_ItemList - add line
	BEGIN
		
		SELECT @v_dSql += N'	SELECT DISTINCT C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.CHILD_ITEM_ID AS CELL_ITEM_ID, D.NICK_NAME	' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_BOM_M C WITH(NOLOCK)                                                                                     ' + char(10)
		SELECT @v_dSql += N'	   , SCM_ITEM_M D WITH(NOLOCK)                                                                                      ' + char(10)
		SELECT @v_dSql += N'	   , SCM_ITEM_CLASS_M E WITH(NOLOCK)                                                                                ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1                                                                                                          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.CHILD_ITEM_ID' , 'LIKE', @p_cell_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('D.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	AND    C.EFF_END_DATE >= GETDATE()                                                                                  ' + char(10)
		SELECT @v_dSql += N'	AND    C.CHILD_ITEM_ID = D.ITEM_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'	AND    D.ITEM_CLASS = E.CLASS_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'	AND    E.LEVEL_3_NAME = ''CELL''                                                                                    ' + char(10)
		SELECT @v_dSql += N'	AND NOT EXISTS (                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	                SELECT 1                                                                                            ' + char(10)
		SELECT @v_dSql += N'	                FROM   SCM_SYS_LOOKUP_VALUE SA WITH(NOLOCK)                                                         ' + char(10)
		SELECT @v_dSql += N'	                WHERE  SA.LOOKUP_TYPE_CODE = ''FORMATION_PACK_EXCEPT_ITEM''                                         ' + char(10)
		SELECT @v_dSql += N'	                AND    SA.ACTIVE_FLAG = ''Y''                                                                       ' + char(10)
		SELECT @v_dSql += N'	                AND    SA.SEGMENT1 = C.COMPANY_ID                                                                   ' + char(10)
		SELECT @v_dSql += N'	                AND    SA.SEGMENT2 = C.DIVISION_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'	                AND    SA.SEGMENT3 = C.SITE_ID                                                                      ' + char(10)
		SELECT @v_dSql += N'	                AND    SA.SEGMENT4 = C.PLANT_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'	                AND    SA.SEGMENT5 = C.CHILD_ITEM_ID                                                                ' + char(10)
		SELECT @v_dSql += N'	             )                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	ORDER BY C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.CHILD_ITEM_ID, D.NICK_NAME                           ' + char(10)

	END


	IF @p_sys_flag = 'STORAGE'	-- find_Storage - add line
	BEGIN
		
		SELECT @v_dSql += N'	SELECT A.*                                                                            																' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.DOMESTIC_SLOC_ID AS STORAGE_ID                                                ' + char(10)
		SELECT @v_dSql += N'	      --, CASE WHEN A.MARKET = ''D'' THEN A.DOMESTIC_SLOC_ID WHEN A.MARKET = ''E'' THEN A.EXPORT_SLOC_ID ELSE A.DOMESTIC_SLOC_ID END AS STORAGE_ID  ' + char(10)
		SELECT @v_dSql += N'	  FROM  SCM_LINE_M A WITH(NOLOCK)                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	  WHERE  1=1                                                                                                                                        ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'		AND    A.OPERATION_ID = ''P1000''                                                                                                               ' + char(10)
		SELECT @v_dSql += N'		AND    A.ACTIVE_FLAG    = ''Y''                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'		UNION                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.EXPORT_SLOC_ID AS STORAGE_ID                                                  ' + char(10)
		SELECT @v_dSql += N'	      --, CASE WHEN A.MARKET = ''D'' THEN A.DOMESTIC_SLOC_ID WHEN A.MARKET = ''E'' THEN A.EXPORT_SLOC_ID ELSE A.DOMESTIC_SLOC_ID END AS STORAGE_ID  ' + char(10)
		SELECT @v_dSql += N'	  FROM  SCM_LINE_M A WITH(NOLOCK)                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	  WHERE  1=1                                                                                                                                        ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'		AND    A.OPERATION_ID = ''P1000''                                                                                                               ' + char(10)
		SELECT @v_dSql += N'		AND    A.ACTIVE_FLAG    = ''Y''                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	) A                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	WHERE A.STORAGE_ID IS NOT NULL                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.STORAGE_ID                                                                           ' + char(10)

	END

	IF @p_sys_flag = 'DUP'	-- find_dup - add line
	BEGIN
		
		SELECT @v_dSql += N'	SELECT COUNT(*) AS CNT										' + char(10)
		SELECT @v_dSql += N'	FROM   FP_DEMAND_PACK_REQUIRE_CELL_H A WITH(NOLOCK)			' + char(10)
		SELECT @v_dSql += N'	WHERE  A.INSTANCE_ID    = '''+ @p_instance_id +'''    ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLAN_ID    	= '''+ @p_plan_id +'''    ' + char(10)
		SELECT @v_dSql += N'	AND    A.DIVISION_ID    = '''+ @p_division_id +'''    ' + char(10)
		SELECT @v_dSql += N'	AND    A.SITE_ID        = '''+ @p_site_id +'''    ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLANT_ID       = '''+ @p_plant_id +'''    ' + char(10)
		SELECT @v_dSql += N'	AND    A.CELL_ITEM_ID   = '''+ @p_cell_item_id+'''    ' + char(10)
		SELECT @v_dSql += N'	AND    A.STORAGE_ID     = '''+ @p_storage_id +'''    ' + char(10)
		SELECT @v_dSql += N'	AND    A.SOC_ID 		= '''+ @p_soc_id +'''    ' + char(10)
		SELECT @v_dSql += N'	AND    A.MARKET         = '''+ @p_market +'''    ' + char(10)
		SELECT @v_dSql += N'	AND    CONVERT(VARCHAR, A.REQUIRE_DATE, 112) = '''+ @p_date +'''		' + char(10)
		SELECT @v_dSql += N'	AND    A.REQUIRE_QTY > 0									' + char(10)

	END

	IF @p_sys_flag = 'TARGET_INFO'	-- find_targetInfo - add line
	BEGIN
		
		SELECT @v_dSql += N'	SELECT A.*																																					' + char(10)								
		SELECT @v_dSql += N'		, ( CASE WHEN A.OPERATION_ID=''A9000'' THEN ( CASE WHEN G.ITEM_ID IS NULL THEN ''RCCP or Test Target'' ELSE '''' END ) ELSE '''' END ) AS MSG1          ' + char(10)
		SELECT @v_dSql += N'	  , ( CASE WHEN H.MARKET IS NULL THEN ''SCP or Test Target-Market'' ELSE '''' END ) AS MSG2                                                                 ' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	  SELECT '''+ @p_instance_id +''' AS INSTANCE_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	  	  , '''+ @p_plan_id +''' AS PLAN_ID                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	      , (SELECT COMPANY_ID FROM SCM_FACTORY_M FF WHERE FF.FACTORY_ID = '''+ @p_factory_id +''' AND FF.ACTIVE_FLAG = ''Y'') AS COMPANY_ID                               ' + char(10)
		SELECT @v_dSql += N'	      , '''+ @p_division_id +''' AS DIVISION_ID, '''+ @p_site_id +''' AS SITE_ID, '''+ @p_plant_id +''' AS PLANT_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'	      , '''+ @p_item_id +''' AS ITEM_ID, '''+ @p_operation_id +''' AS OPERATION_ID, '''+ @p_factory_id +''' AS FACTORY_ID, '''+ @p_location +''' AS LOCATION                                            ' + char(10)
		SELECT @v_dSql += N'	      , '''+ @p_prod_type +''' AS PRODUCTION_TYPE, '''+ @p_market +''' AS MARKET                                                                                            ' + char(10)
		SELECT @v_dSql += N'	      , '''+ @p_line_id +''' AS LINE_ID, '''+ @p_electrode_type +''' AS ELECTRODE_TYPE                                                                                            ' + char(10)
		SELECT @v_dSql += N'	      , '''+ @p_top_item_id +''' AS TOP_ITEM_ID                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	) A                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	LEFT OUTER JOIN (                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  SELECT DISTINCT INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'	  FROM   FP_INSTANCE_ITEM_V                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	) G                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	ON  A.INSTANCE_ID = G.INSTANCE_ID                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	AND A.COMPANY_ID  = G.COMPANY_ID                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	AND A.DIVISION_ID = G.DIVISION_ID                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	AND A.SITE_ID     = G.SITE_ID                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	AND A.PLANT_ID    = G.PLANT_ID                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	AND A.ITEM_ID     = G.ITEM_ID                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	LEFT OUTER JOIN (                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID                                           ' + char(10)
		SELECT @v_dSql += N'				FROM   FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A WITH(NOLOCK)                                                                                          ' + char(10)
		SELECT @v_dSql += N'				WHERE  (A.DIVISION_ID+A.SCP_PLAN_ID) IN (SELECT A.DIVISION_ID+MAX(A.SCP_PLAN_ID) AS SCP_PLAN_ID FROM FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A WITH(NOLOCK) GROUP BY A.DIVISION_ID)	' + char(10)
		SELECT @v_dSql += N'				UNION ALL                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID                                 ' + char(10)
		SELECT @v_dSql += N'				FROM   FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H A WITH(NOLOCK)                                                                                          ' + char(10)
		SELECT @v_dSql += N'				WHERE  A.SCP_PLAN_ID = (SELECT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID FROM FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H A WITH(NOLOCK))                            ' + char(10)
		SELECT @v_dSql += N'				UNION ALL                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID                                 ' + char(10)
		SELECT @v_dSql += N'				FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK)                                                                                           ' + char(10)
		SELECT @v_dSql += N'				WHERE  A.DUE_DATE >= (SELECT CONVERT(DATETIME,CONVERT(VARCHAR,PLAN_START_TIME,112))                                                             ' + char(10)
		SELECT @v_dSql += N'				                      FROM   SCM_FP_PLAN_H                                                                                                      ' + char(10)
		SELECT @v_dSql += N'				                      WHERE  PLAN_ID = '''+ @p_plan_id +''' )                                                                                           ' + char(10)
		SELECT @v_dSql += N'				UNION ALL                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'				SELECT  DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID                                ' + char(10)
		SELECT @v_dSql += N'				FROM   FP_DAILY_INSTANCE_DEMAND_H A                                                                                                             ' + char(10)
		SELECT @v_dSql += N'				WHERE  1=1                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'				AND   INSTANCE_ID = CASE WHEN '''+ @p_instance_id +''' = ''KR_E_PRE_A'' OR '''+ @p_instance_id +''' = ''KR_E_PRE_M'' THEN ''KR_E_PRE''                                ' + char(10)
		SELECT @v_dSql += N'				                    ELSE '''+ @p_instance_id +''' END                                                                                                      ' + char(10)
		SELECT @v_dSql += N'				AND   INSTANCE_DATE = SUBSTRING('''+ @p_plan_id +''',CHARINDEX(''-'','''+ @p_plan_id +''',1)+1,8)                                                               ' + char(10)
		SELECT @v_dSql += N'				AND   CONVERT(VARCHAR, INSTANCE_DATE,102) = ( SELECT CONVERT(VARCHAR, PLAN_START_TIME,102)                                                      ' + char(10)
		SELECT @v_dSql += N'			                                                FROM   SCM_FP_PLAN_H                                                                                ' + char(10)
		SELECT @v_dSql += N'			                                                WHERE  PLAN_ID = '''+ @p_plan_id +'''                                                                       ' + char(10)
		SELECT @v_dSql += N'			                                            	)                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	) H                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	ON  A.COMPANY_ID  = H.COMPANY_ID                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	AND A.DIVISION_ID = H.DIVISION_ID                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	AND A.SITE_ID     = H.SITE_ID                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	AND A.PLANT_ID    = H.PLANT_ID                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	AND A.MARKET      = H.MARKET                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	AND A.TOP_ITEM_ID = H.ITEM_ID                                                                                                                               ' + char(10)

	END

	IF @p_sys_flag = 'HEADER_TITLE'	
	BEGIN
		
		 SELECT @v_dSql += N'	SELECT   C.PROGRAM_ID																			' + char(10)
		 SELECT @v_dSql += N'			, C.SHEET_NAME																			' + char(10)
		 SELECT @v_dSql += N'			, C.COLUMN_NAME																			' + char(10)
		 SELECT @v_dSql += N'			, C.COLUMN_LABEL_NAME																	' + char(10)
		 SELECT @v_dSql += N'			, C.SORT_ORDER_NO        	' + char(10)
		 SELECT @v_dSql += N'			, C.DATA_SORT_METHOD_CODE																' + char(10)
		 SELECT @v_dSql += N'			, C.SMALL_CLASS_LABEL_NAME																' + char(10)
		 SELECT @v_dSql += N'			, C.LARGE_CLASS_LABEL_NAME																' + char(10)
		 SELECT @v_dSql += N'			, '''' AS DAY_CODE																		' + char(10)
		 SELECT @v_dSql += N'			, C.FIXED_FLAG																			' + char(10)
		 SELECT @v_dSql += N'			, C.COLUMN_WIDTH																		' + char(10)
		 SELECT @v_dSql += N'			, C.CELL_CONTROL_OBJECT_TYPE_CODE														' + char(10)
		 SELECT @v_dSql += N'			, C.CELL_COMBO_DATA_TYPE																' + char(10)
		 SELECT @v_dSql += N'			, C.DATA_SCALE_NUMBER																	' + char(10)
		 SELECT @v_dSql += N'			, C.DATA_MAX_LENGTH																		' + char(10)
		 SELECT @v_dSql += N'			, C.HORIZONTAL_ALIGN_CODE																' + char(10)
		 SELECT @v_dSql += N'			, C.UPPERCASE_APPLY_FLAG																' + char(10)
		 SELECT @v_dSql += N'			, C.VISIBLE_FLAG																		' + char(10)
		 SELECT @v_dSql += N'			, C.DEFAULT_FLAG																		' + char(10)
		 SELECT @v_dSql += N'			, C.USER_SELECTABLE_FLAG																' + char(10)
		 SELECT @v_dSql += N'			, C.VALID_YN																			' + char(10)
		 SELECT @v_dSql += N'			, C.DIVISION_ID																			' + char(10)
		 SELECT @v_dSql += N'	FROM   [DBO].[SY_SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)											' + char(10)
		 SELECT @v_dSql += N'	WHERE  1 = 1    																				' + char(10)
		 SELECT @v_dSql += N'	AND    C.PROGRAM_ID  = '''+ @p_program_id +'''																' + char(10)
		 SELECT @v_dSql += N'	AND    C.SHEET_NAME  = '''+ @p_sheet_name +'''																	' + char(10)
		 SELECT @v_dSql += N'	AND    C.DEFAULT_FLAG = ''Y''																		' + char(10)
		 SELECT @v_dSql += N'	AND    C.VALID_YN     = ''Y'' 																	' + char(10)

	END

	IF @p_sys_type = 'SQL'
    BEGIN
			
			DECLARE @log_id INTEGER = 0
			EXEC	@log_id = PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'sql',@runstart, @runend

			SELECT	QUERY_VALUE 
			FROM	TH_UIS_SQL_LOG WITH(NOLOCK)  
			WHERE	PROG_ID = @v_proc_name AND JOB_TYPE = @p_sys_type AND INST_SEQ = @log_id
			ORDER BY QUERY_SEQ ASC

    END ELSE BEGIN

		SET @runstart = GetDate()
		BEGIN TRY
		     BEGIN TRAN
	             exec sp_executesql @v_dSql
		     COMMIT TRAN
		END TRY
        BEGIN CATCH
             ROLLBACK
        END CATCH
	    SET @runend = GetDate()
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend

    END
	
  
END
