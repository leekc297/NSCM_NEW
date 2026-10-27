CREATE PROCEDURE [dbo].[PR_UI_FP00611_ETC_TEST2]
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
/** 프로그램 ID   : PR_UI_FP00611_ETC                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP00611_ETC                                               **/
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
/** 2021/05/18   CYS				Initial Release UI통합                                    **/
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP00611_ETC';
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
	
	SET @v_delimiter            = '^'  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	
	SELECT @in_row as in_cols
	RETURN 1

	exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@in_columns,'xx',@runstart, @runend

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
			SET @dbg_txt += @tmp_column
			SET @dbg_txt += @p_bucket_from
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
			
		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =				@tmp_value ;
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			@tmp_value ;
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			@tmp_value ;
			SET @dbg_txt += @tmp_column
			SET @dbg_txt += @p_month_info

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

		SELECT @v_dSql += N'	SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER			' + char(10)
		SELECT @v_dSql += N'	   , B.ATTRIBUTE3 AS USE_WOW_STATUS                                     ' + char(10)
		SELECT @v_dSql += N'	   , B.ATTRIBUTE1 AS CONFIRM_AREA                                       ' + char(10)
		SELECT @v_dSql += N'	   , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID                                    ' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                  ' + char(10)
		SELECT @v_dSql += N'	  		SELECT DISTINCT B.INSTANCE_ID                                   ' + char(10)
		SELECT @v_dSql += N'	      	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                       ' + char(10)
		SELECT @v_dSql += N'	      	WHERE  B.USER_ID     = '''+ @p_user_id +'''                     ' + char(10)
		SELECT @v_dSql += N'		) A, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)                            ' + char(10)
		SELECT @v_dSql += N'	WHERE A.INSTANCE_ID      = B.SEGMENT1                                   ' + char(10)
		SELECT @v_dSql += N'	AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                              ' + char(10)
		SELECT @v_dSql += N'	AND   B.SEGMENT1 IN (                                                   ' + char(10)
		SELECT @v_dSql += N'		  SELECT INSTANCE_ID                                                ' + char(10)
		SELECT @v_dSql += N'	      FROM FP_AMEND_UI_V                                                ' + char(10)
		SELECT @v_dSql += N'	      WHERE 1=1                                                         ' + char(10)
		SELECT @v_dSql += N'	      AND AMEND_UI_NAME IN (''PSI_AMEND_CELL'',''PSI_AMEND_POUCH'')     ' + char(10)
		SELECT @v_dSql += N'	      AND USE_FLAG = ''Y''                                              ' + char(10)
		SELECT @v_dSql += N'	)                                                                       ' + char(10)
		SELECT @v_dSql += N'	ORDER BY B.SORT_ORDER                                                   ' + char(10)

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
		SELECT @v_dSql += N'			  WHERE  YYYYMMDD BETWEEN #BUCKET_FROM# AND #BUCKET_TO#                                                         ' + char(10)
		SELECT @v_dSql += N'			  UNION ALL                                                                                                     ' + char(10)
		SELECT @v_dSql += N'			  SELECT ISO_YYYYWW AS _DATE                                                                                    ' + char(10)
		SELECT @v_dSql += N'			       , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS _NAME                               ' + char(10)
		SELECT @v_dSql += N'			       , COUNT(*) AS _COUNT                                                                                     ' + char(10)
		SELECT @v_dSql += N'			       , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS _VALUE                          ' + char(10)
		SELECT @v_dSql += N'			       , 1 AS _DATE_SEQ                                                                                         ' + char(10)
		SELECT @v_dSql += N'			       , ISO_YYYYWW AS WEEK_SEQ                                                                                 ' + char(10)
		SELECT @v_dSql += N'			       , ''W'' AS _TYPE                                                                                         ' + char(10)
		SELECT @v_dSql += N'			  FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                                                         ' + char(10)
		SELECT @v_dSql += N'			  WHERE  CAL.DT >= CONVERT(DATETIME, #BUCKET_FROM#, 112)                                                        ' + char(10)
		SELECT @v_dSql += N'			  AND    CAL.DT <= CONVERT(DATETIME, #BUCKET_TO#, 112)                                                          ' + char(10)
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

	IF @p_sys_flag = 'PLANNER_LIST'	-- findPlanner_List
	BEGIN
		SELECT @v_dSql += N'	SELECT 	DISTINCT A.USER_ID AS CODE, ISNULL(B.USER_NAME,''-'') + '' ('' + A.USER_ID + '')'' AS NAME			' + char(10)
		SELECT @v_dSql += N'	   		, (CASE WHEN A.USER_ID = '''+ @p_user_id +''' THEN ''Y'' ELSE ''N'' END) AS DEFAULT_CHECK           ' + char(10)
		SELECT @v_dSql += N'	FROM   FP_USER_LINE_GROUP_M A WITH(NOLOCK)                                                                  ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK)                                                   ' + char(10)
		SELECT @v_dSql += N'			ON     A.USER_ID = B.USER_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                             ' + char(10)
		SELECT @v_dSql += N'	ORDER BY NAME                                                                                          ' + char(10)
	END
	
	IF @p_sys_flag = 'LINE_CODE_LIST'	-- findLineCode_List
	BEGIN
		SELECT @v_dSql += N'	SELECT 	A.LINE_ID AS CODE																													' + char(10)	
		SELECT @v_dSql += N'	   		, ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END) AS NAME    ' + char(10)
		SELECT @v_dSql += N'	FROM   	SCM_LINE_M A WITH(NOLOCK)                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	WHERE 	1=1                                                                                                                   ' + char(10)
		IF @p_in_active != 'Y' BEGIN
			SELECT @v_dSql += N'	AND 	A.ACTIVE_FLAG = ''Y''                                                                                                                   ' + char(10)
		END
		SELECT @v_dSql += N'	AND    EXISTS (                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'		        	SELECT 1                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                       ' + char(10)
		SELECT @v_dSql += N'		        	WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                                             ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.DIVISION_ID = B.DIVISION_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.SITE_ID     = B.SITE_ID                                                                                                ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.PLANT_ID	 = B.PLANT_ID                                                                                               ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.FACTORY_ID  = B.FACTORY_ID                                                                                             ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.OPERATION_ID = B.OPERATION_ID                                                                                          ' + char(10)
		IF @p_in_active != 'Y' BEGIN
			SELECT @v_dSql += N'				AND    A.LINE_ID 	 = B.LINE_ID                                                                                                                  ' + char(10)
		END
		SELECT @v_dSql += N'		        	AND    B.USER_ID     = '''+ @p_user_id +'''                                                                                     ' + char(10)
		SELECT @v_dSql += N'		      	)                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	AND   EXISTS (                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'					  SELECT 1                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'					  FROM 	(                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'						      SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID                                          ' + char(10)
		SELECT @v_dSql += N'						      FROM  SCM_FACTORY_M A WITH(NOLOCK)                                                                                    ' + char(10)
		SELECT @v_dSql += N'						      INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                                                                       ' + char(10)
		SELECT @v_dSql += N'						      ON    A.FACTORY_ID=B.FACTORY_ID                                                                                       ' + char(10)
		SELECT @v_dSql += N'						      WHERE 1=1                                                                                                             ' + char(10)
		SELECT @v_dSql += N'						      AND   B.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                   ' + char(10)
		SELECT @v_dSql += N'						      AND   A.ACTIVE_FLAG = ''Y''                                                                                           ' + char(10)
		SELECT @v_dSql += N'						      AND   B.ACTIVE_FLAG = ''Y''                                                                                           ' + char(10)
		SELECT @v_dSql += N'					  		) C                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'					  WHERE C.COMPANY_ID=A.COMPANY_ID                                                                                               ' + char(10)
		SELECT @v_dSql += N'					  AND C.DIVISION_ID=A.DIVISION_ID                                                                                               ' + char(10)
		SELECT @v_dSql += N'					  AND C.SITE_ID=A.SITE_ID                                                                                                       ' + char(10)
		SELECT @v_dSql += N'					  AND C.PLANT_ID=A.PLANT_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'					  AND C.FACTORY_ID=A.FACTORY_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'				)                                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @p_company_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		
		IF @p_instance_id <> '' AND @p_instance_id IS NOT NULL BEGIN
			SELECT @v_dSql += N'	  AND EXISTS ( SELECT  1                                                                                                            ' + char(10)
			SELECT @v_dSql += N'	               FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)                                                                        ' + char(10)
			SELECT @v_dSql += N'	     				   WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                                 ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.SEGMENT1         = '''+ @p_instance_id +'''                                                                 ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.ACTIVE_FLAG      = ''Y''                                                                             ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.ATTRIBUTE1       = ''BUILDING''                                                                      ' + char(10)
			SELECT @v_dSql += N'	          		 UNION ALL                                                                                                        ' + char(10)
			SELECT @v_dSql += N'	          		 SELECT  1                                                                                                        ' + char(10)
			SELECT @v_dSql += N'	               FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),                                                                       ' + char(10)
			SELECT @v_dSql += N'	          		         SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)                                                                    ' + char(10)
			SELECT @v_dSql += N'	          		 WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                                   ' + char(10)
			SELECT @v_dSql += N'	          		 AND 	   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''                                                     ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.SEGMENT1         = LV2.SEGMENT1                                                                      ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.SEGMENT1         = '''+ @p_instance_id +'''                                                                 ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.ACTIVE_FLAG      = ''Y''                                                                             ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.ATTRIBUTE1       = ''PLAN GROUP''                                                                    ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) )                                               ' + char(10)
		END
		
		IF @p_all_line <> 'Y' BEGIN
			SELECT @v_dSql += N'	  AND A.LINE_ID IN (                                                                                                                ' + char(10)
			SELECT @v_dSql += N'	      SELECT DISTINCT LINE_ID                                                                                                       ' + char(10)
			SELECT @v_dSql += N'	      FROM   FP_USER_LINE_GROUP_M AA WITH(NOLOCK)                                                                                   ' + char(10)
			SELECT @v_dSql += N'	      WHERE  AA.INSTANCE_ID = '''+ @p_instance_id +'''		                                                                        ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.USER_ID' , 'EQ', @p_user_lt)) + char(10)
			SELECT @v_dSql += N'	  )                                                                                                                                 ' + char(10)
		END

		IF @p_instance_id <> '' AND @p_instance_id IS NOT NULL BEGIN
			SELECT @v_dSql += N'	AND EXISTS (																					' + char(10)																		
			SELECT @v_dSql += N'				SELECT 1	                                                                        ' + char(10)
			SELECT @v_dSql += N'				FROM FP_INSTANCE_LINE_V AA						                                    ' + char(10)
			SELECT @v_dSql += N'				WHERE ( AA.INSTANCE_ID IN ( SELECT A.SEGMENT2					                    ' + char(10)
			SELECT @v_dSql += N'										   	FROM SCM_SYS_LOOKUP_VALUE A 					        ' + char(10)
			SELECT @v_dSql += N'											WHERE A.LOOKUP_TYPE_CODE = ''INSTANCE_AMEND_LINE_VIEW'' ' + char(10)					
			SELECT @v_dSql += N'											AND A.SEGMENT1 = '''+ @p_instance_id +''' 	)			' + char(10)
			SELECT @v_dSql += N'						OR AA.INSTANCE_ID = '''+ @p_instance_id +''' 	)		                    ' + char(10)
			SELECT @v_dSql += N'				  AND A.DIVISION_ID = AA.DIVISION_ID				                                ' + char(10)
			SELECT @v_dSql += N'				  AND A.SITE_ID     = AA.SITE_ID				                                    ' + char(10)
			SELECT @v_dSql += N'				  AND A.PLANT_ID    = AA.PLANT_ID				                                    ' + char(10)
			SELECT @v_dSql += N'				  AND A.FACTORY_ID  = AA.FACTORY_ID				                                    ' + char(10)
			SELECT @v_dSql += N'				  AND A.OPERATION_ID= AA.OPERATION_ID			                                    ' + char(10)
			SELECT @v_dSql += N'				  AND A.LINE_ID = AA.LINE_ID					                                    ' + char(10)
			SELECT @v_dSql += N'				)												                                    ' + char(10)
		END
		
		SELECT @v_dSql += N'	GROUP BY A.LINE_ID, A.LINE_NAME                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A.LINE_ID                                                                                                                              ' + char(10)
	END
	
	IF @p_sys_flag = 'OPERATION_CODE'	-- findOperationCode_common
	BEGIN
		SELECT @v_dSql += N'	SELECT DISTINCT A.OPERATION_ID AS CODE                              	' + char(10)
		SELECT @v_dSql += N'			, ''('' + A.OPERATION_ID + '')'' + B.OPERATION_NAME AS NAME     ' + char(10)
		SELECT @v_dSql += N'	   		, A.AMEND_MAIN_FLAG                                             ' + char(10)
		SELECT @v_dSql += N'	FROM	FP_INSTANCE_OPERATION_V A                                       ' + char(10)
		SELECT @v_dSql += N'		  , SCM_OPERATION_M B                                               ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.COMPANY_ID   = B.COMPANY_ID                                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.DIVISION_ID  = B.DIVISION_ID                                   ' + char(10)
		SELECT @v_dSql += N'	AND    A.SITE_ID      = B.SITE_ID                                       ' + char(10)
		SELECT @v_dSql += N'	AND    A.OPERATION_ID = B.OPERATION_ID                                  ' + char(10)
		SELECT @v_dSql += N'	AND    A.INSTANCE_ID  = '''+ @p_instance_id +'''                                   ' + char(10)
		SELECT @v_dSql += N'	AND    EXISTS (                                                         ' + char(10)
		SELECT @v_dSql += N'		        	SELECT 1                                                ' + char(10)
		SELECT @v_dSql += N'		        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)               ' + char(10)
		SELECT @v_dSql += N'		        	WHERE  A.COMPANY_ID  = B.COMPANY_ID                     ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.DIVISION_ID = B.DIVISION_ID                    ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.SITE_ID     = B.SITE_ID                        ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.OPERATION_ID = B.OPERATION_ID                  ' + char(10)
		SELECT @v_dSql += N'		        	AND    B.USER_ID     = '''+ @p_user_id +'''                        ' + char(10)
		SELECT @v_dSql += N'		      	)                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'	AND   A.AMEND_FLAG = ''Y''                                              ' + char(10)
		
		IF @p_amend_main_flag = 'N' BEGIN
			SELECT @v_dSql += N'	  AND   A.AMEND_MAIN_FLAG = ''Y''	                           ' + char(10)
		END
		
		SELECT @v_dSql += N'	ORDER BY A.OPERATION_ID DESC                                            ' + char(10)
	END
		
	IF @p_sys_flag = 'SYNC_CALCUL'	-- find_SyncCalcul
	BEGIN
		SELECT @v_dSql += N'	SELECT A.SEGMENT1 AS INSTANCE_ID, A.ATTRIBUTE5 AS PSI_CAL_STATUS  	' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_SYS_LOOKUP_VALUE A                                       ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                         ' + char(10)
		SELECT @v_dSql += N'	AND    A.ACTIVE_FLAG = ''Y''                                        ' + char(10)
		SELECT @v_dSql += N'	AND    A.SEGMENT1 = '''+ @p_master_id +'''                          ' + char(10)
	END
		
	
			
	IF @p_sys_flag = 'PROD_TYPE'	-- find_FPProdType
	BEGIN

		SELECT @v_dSql += N'	SELECT  DISTINCT A.ATTRIBUTE2 AS CODE, A.ATTRIBUTE2 AS NAME	' + char(10)
		SELECT @v_dSql += N'	FROM    SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                         ' + char(10)
		SELECT @v_dSql += N'	WHERE   A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''               ' + char(10)
		SELECT @v_dSql += N'	AND     A.ACTIVE_FLAG = ''Y''                                       ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @p_division_id)) + char(10)

		IF @p_instance_id = 'KR_CELL' BEGIN
			SELECT @v_dSql += N'	UNION ALL SELECT ''M/C'' AS CODE, ''M/C'' AS NAME   ' + char(10)
		END

	END
			
	IF @p_sys_flag = 'NICK_NAME'	-- find_FPNickName
	BEGIN

		SELECT @v_dSql += N'	SELECT DISTINCT ISNULL(B.NICK_NAME,''-'') AS CODE, ISNULL(B.NICK_NAME,''-'') AS NAME					' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                          ' + char(10)
		SELECT @v_dSql += N'			  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID     ' + char(10)
		SELECT @v_dSql += N'		      FROM FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                                       ' + char(10)
		SELECT @v_dSql += N'		      WHERE  1=1                                                                                            ' + char(10)
		SELECT @v_dSql += N'		      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                       ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'		      UNION ALL                                                                                             ' + char(10)
		SELECT @v_dSql += N'		      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID     ' + char(10)
		SELECT @v_dSql += N'		      FROM SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)                                                        ' + char(10)
		SELECT @v_dSql += N'		      WHERE  1=1                                                                                            ' + char(10)
		SELECT @v_dSql += N'		      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                       ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'		) A                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		INNER JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                        ' + char(10)
		SELECT @v_dSql += N'		ON     A.COMPANY_ID     = B.COMPANY_ID                                                                      ' + char(10)
		SELECT @v_dSql += N'		AND    A.DIVISION_ID    = B.DIVISION_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'		AND    A.SITE_ID        = B.SITE_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'		AND    A.ITEM_ID        = B.ITEM_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'	ORDER BY ISNULL(B.NICK_NAME,''-'')		                                                                        ' + char(10)

	END

	IF @p_sys_flag = 'PLAN_INFO_2'	-- find_planInfo
	BEGIN

		SELECT @v_dSql += N'	SELECT TOP 1 A.RELEASE_ID AS CREATOR, CONVERT(VARCHAR, A.RELEASE_TIME, 120) AS CREATION, A.DESCRIPTION AS DESCRIPTION	' + char(10)
		SELECT @v_dSql += N'	FROM SCM_FP_PLAN_H A WITH(NOLOCK)                                                                                       ' + char(10)
		SELECT @v_dSql += N'	WHERE   1=1                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	AND    A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                         ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLAN_TYPE = ''RELEASE''                                                                                        ' + char(10)
		SELECT @v_dSql += N'	ORDER BY RELEASE_TIME DESC                                                                                              ' + char(10)

	END

	IF @p_sys_flag = 'MEA_MEMO'	-- find_MeaMemo
	BEGIN

		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID     		' + char(10)	
		SELECT @v_dSql += N'	       , A.OPERATION_ID                                                         	' + char(10)
		SELECT @v_dSql += N'	       , A.LINE_ID, A.ELECTRODE_TYPE                                            	' + char(10)
		SELECT @v_dSql += N'	       , A.EQUIPMENT_ID                                                         	' + char(10)
		SELECT @v_dSql += N'	       , A.ITEM_ID, A.TOP_ITEM_ID                                               	' + char(10)
		SELECT @v_dSql += N'	       , A.PRODUCTION_TYPE, A.MARKET                                            	' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = ''
					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END

					SELECT @v_dSql += N'	          , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @sub_param_0 + ''' THEN A.MEMO ELSE NULL END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_MEMO 	' + char(10)
					
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	FROM FP_AMEND_MEMO_M A WITH(NOLOCK)                                             	' + char(10)
		SELECT @v_dSql += N'	WHERE 1=1                                                                     	' + char(10)
		SELECT @v_dSql += N'	AND    A.INSTANCE_ID  = '''+ @p_instance_id +'''                                           	' + char(10)
		SELECT @v_dSql += N'	AND	CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''   	' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID       	' + char(10)
		SELECT @v_dSql += N'		, A.OPERATION_ID                                                            	' + char(10)
		SELECT @v_dSql += N'		, A.LINE_ID, A.ELECTRODE_TYPE                                               	' + char(10)
		SELECT @v_dSql += N'		, A.EQUIPMENT_ID                                                            	' + char(10)
		SELECT @v_dSql += N'		, A.ITEM_ID, A.TOP_ITEM_ID                                                  	' + char(10)
		SELECT @v_dSql += N'		, A.PRODUCTION_TYPE, A.MARKET                                               	' + char(10)

	END

	IF @p_sys_flag = 'DAY2_WEEK_MONTH'	-- find_day2WeekAndMonth
	BEGIN
	exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'','cc','dd',@runstart, @runend
		SELECT @v_dSql += N'	SELECT ''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS D_COL 		' + char(10)
		SELECT @v_dSql += N'		   , ''W'' + CONVERT(VARCHAR,(DENSE_RANK() OVER(ORDER BY ISO_YYYYWW))-1) AS W_COL   ' + char(10)
		SELECT @v_dSql += N'		   , ''M'' + CONVERT(VARCHAR,(DENSE_RANK() OVER(ORDER BY YYYYMM))-1) AS M_COL       ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL A WITH(NOLOCK)                                                        ' + char(10)
		SELECT @v_dSql += N'	WHERE  YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''             ' + char(10)
		
	END

	IF @p_sys_flag = 'CURR_DATE_COL'	-- find_currDateCol
	BEGIN

		SELECT @v_dSql += N'	SELECT A.D_COL, B.CURR_DATE                                                                      																	' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		    SELECT ''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS D_COL                                                                           ' + char(10)
		SELECT @v_dSql += N'		         , A.YYYYMMDD AS D_VALUE                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'		    FROM   TH_UIS_CAL A WITH(NOLOCK)                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'		    WHERE A.YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                                ' + char(10)
		SELECT @v_dSql += N'	) A                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	INNER JOIN (                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'				  SELECT CASE WHEN FORMAT(DBO.FN_SITE_TIME(B.SITE_ID) ,''YYYYMMDDHHMMSS'') < CONVERT(VARCHAR,DBO.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME      ' + char(10)
		SELECT @v_dSql += N'				              THEN CONVERT(VARCHAR, DATEADD(DD,-1,DBO.FN_SITE_TIME(B.SITE_ID)), 112)                                                                    ' + char(10)
		SELECT @v_dSql += N'				              ELSE CONVERT(VARCHAR, DBO.FN_SITE_TIME(B.SITE_ID), 112) END AS CURR_DATE                                                                  ' + char(10)
		SELECT @v_dSql += N'				  FROM   FP_INSTANCE_START_TIME_V A,                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'				  		(                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'					      SELECT MAX(B.SITE_ID) AS SITE_ID                                                                                                              ' + char(10)
		SELECT @v_dSql += N'					      FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK)                                                                     ' + char(10)
		SELECT @v_dSql += N'					      WHERE  A.FACTORY_ID = B.FACTORY_ID                                                                                                            ' + char(10)
		SELECT @v_dSql += N'					      AND    A.ACTIVE_FLAG = ''Y''                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'					      AND    B.ACTIVE_FLAG = ''Y''                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'					      AND    A.INSTANCE_ID = '''+ @p_instance_id +'''			                                                                                    ' + char(10)
		SELECT @v_dSql += N'				  		) B                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'				  WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	) B                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	ON    A.D_VALUE = B.CURR_DATE                                                                                                                                       ' + char(10)

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
