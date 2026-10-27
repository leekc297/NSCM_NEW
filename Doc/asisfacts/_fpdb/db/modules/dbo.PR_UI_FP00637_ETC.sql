CREATE PROCEDURE [dbo].[PR_UI_FP00637_ETC]
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
/** 프로그램 ID   : PR_UI_FP00637_ETC                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP00637_ETC                                               **/
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
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP00637_ETC';
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
	DECLARE @p_history_yn	NVARCHAR(MAX);
	DECLARE @p_table_name	NVARCHAR(MAX);
	DECLARE @p_sim_plan_id	NVARCHAR(MAX);
	DECLARE @p_sel_plan_date NVARCHAR(MAX);
	DECLARE @p_sel_item_id NVARCHAR(MAX);
	DECLARE @p_sel_line_id NVARCHAR(MAX);

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
	
	--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@in_columns,'xx',@runstart, @runend
	--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@in_row,'xx2',@runstart, @runend
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
		END ELSE IF @tmp_column = 'AMEND_INSTANCE' BEGIN
			SET @p_amend_instance	=	@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
			SET @p_plan_id =			@tmp_value
			SET @p_sim_plan_id =		@tmp_value
		END ELSE IF @tmp_column = 'SEL_PLAN_DATE' BEGIN
			SET @p_sel_plan_date =		@tmp_value
		END ELSE IF @tmp_column = 'SEL_LINE_ID' BEGIN
			SET @p_sel_line_id =		@tmp_value
		END ELSE IF @tmp_column = 'SEL_ITEM_ID' BEGIN
			SET @p_sel_item_id =		@tmp_value

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

	SELECT	@p_history_yn = ISNULL(HISTORY_YN, 'N')
	FROM	FP_SIM_PLAN_H
	WHERE	1=1
	AND		PROGRAM_TYPE = 'PACK_SIMUL'
	AND		INSTANCE_ID = @p_instance_id
	AND		SIM_PLAN_ID = @p_plan_id
	;
	
	IF @p_history_yn = 'Y' BEGIN
		SET @p_table_name = 'FP_SIM_MATERIAL_PACK_H'
	END ELSE BEGIN
		SET @p_table_name = 'FP_SIM_MATERIAL_PACK_R'
	END

	
	SET	@v_dSql = '';
	
	IF @p_sys_flag = 'INSTANCE'	-- findInstanceList_common
	BEGIN

		SELECT @v_dSql += N'	SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER					' + char(10)	
		SELECT @v_dSql += N'	   , B.ATTRIBUTE3 AS USE_WOW_STATUS                                                     ' + char(10)
		SELECT @v_dSql += N'	   , B.ATTRIBUTE1 AS CONFIRM_AREA                                                       ' + char(10)
		SELECT @v_dSql += N'	   , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID                                                    ' + char(10)
		SELECT @v_dSql += N'	   , C.SITE_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                  ' + char(10)
		SELECT @v_dSql += N'			SELECT DISTINCT A.INSTANCE_ID                                                   ' + char(10)
		SELECT @v_dSql += N'			FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)                                       ' + char(10)
		SELECT @v_dSql += N'			WHERE  USER_ID = '''+ @p_user_id +'''                                           ' + char(10)
		SELECT @v_dSql += N'		) A, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK), (                                         ' + char(10)
		SELECT @v_dSql += N'		  SELECT B.INSTANCE_ID, MAX(A.SITE_ID) AS SITE_ID                                   ' + char(10)
		SELECT @v_dSql += N'		  FROM   SCM_FACTORY_M A WITH(NOLOCK), FP_INSTANCE_FACTORY_M B WITH(NOLOCK)         ' + char(10)
		SELECT @v_dSql += N'		  WHERE  A.FACTORY_ID  = B.FACTORY_ID                                               ' + char(10)
		SELECT @v_dSql += N'		  AND    A.ACTIVE_FLAG = ''Y''                                                      ' + char(10)
		SELECT @v_dSql += N'		  AND    B.ACTIVE_FLAG = ''Y''                                                      ' + char(10)
		SELECT @v_dSql += N'		  GROUP BY B.INSTANCE_ID                                                            ' + char(10)
		SELECT @v_dSql += N'		  ) C                                                                               ' + char(10)
		SELECT @v_dSql += N'	WHERE A.INSTANCE_ID      = B.SEGMENT1                                                   ' + char(10)
		SELECT @v_dSql += N'	AND   A.INSTANCE_ID      = C.INSTANCE_ID                                                ' + char(10)
		SELECT @v_dSql += N'	AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                              ' + char(10)
		SELECT @v_dSql += N'	AND   B.SEGMENT1 IN (                                                                   ' + char(10)
		SELECT @v_dSql += N'			SELECT INSTANCE_ID                                                              ' + char(10)
		SELECT @v_dSql += N'			FROM   FP_AMEND_UI_V                                                            ' + char(10)
		SELECT @v_dSql += N'			WHERE  AMEND_UI_NAME = '''+ @p_amend_instance +'''                              ' + char(10)
		SELECT @v_dSql += N'			AND    USE_FLAG = ''Y''                                                         ' + char(10)
		SELECT @v_dSql += N'	)                                                                                       ' + char(10)
		SELECT @v_dSql += N'	AND   B.SEGMENT1 IN (''PL_PACK'', ''US_PACK'', ''KR_PACK'', ''CN_PACK'')                ' + char(10)
		SELECT @v_dSql += N'	ORDER BY B.SORT_ORDER                                                                   ' + char(10)

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
		
		SELECT @v_dSql += N'	SELECT A.SIM_PLAN_ID AS CODE, SUBSTRING(A.SIM_PLAN_ID,CHARINDEX(''-'',A.SIM_PLAN_ID)+1,12) AS NAME                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	    ,A.SIM_PLAN_ID AS PLAN_ID                                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	    ,A.PLAN_TYPE                                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	    ,A.PLAN_DATE                                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	    ,A.PLAN_START_TIME                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	    ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @p_plan_date +''')) AS PLAN_START_DATE                                                            ' + char(10)
		--SELECT @v_dSql += N'	    ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @p_plan_date +''')))), 112) AS PLAN_END_DATE         ' + char(10)
		SELECT @v_dSql += N'	    ,CONVERT(VARCHAR, A.PLAN_END_TIME, 112) AS PLAN_END_DATE         ' + char(10)
		SELECT @v_dSql += N'	    ,A.INSTANCE_ID                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	    ,A.SITE_ID                                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	    ,A.DESCRIPTION                                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	    ,ISNULL(A.HISTORY_YN, ''N'') AS HISTORY_YN                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	    ,A.INSERT_ID                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	    ,CONVERT(VARCHAR, A.INSERT_DTTM, 120) AS INSERT_DTTM                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	    ,A.UPDATE_ID                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	    ,CONVERT(VARCHAR, A.UPDATE_DTTM, 120) AS UPDATE_DTTM                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	FROM   FP_SIM_PLAN_H A WITH(NOLOCK)                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	WHERE 1=1                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	--AND   A.PLAN_TYPE <> ''RELEASE''                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	AND 	CHARINDEX(''-000'',A.SIM_PLAN_ID) = 0                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CONVERT(VARCHAR(8), CONVERT(DATE, A.PLAN_DATE), 112)' , 'EQ', @p_plan_date)) + char(10)
		SELECT @v_dSql += N'	ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.SIM_PLAN_ID DESC                                                                                                                                                ' + char(10)

	END

	IF @p_sys_flag = 'ISPAST'	-- find_isPast
	BEGIN
		SELECT @v_dSql += N'	SELECT AA.*                                                                                                         																												' + char(10)
		SELECT @v_dSql += N'		   , (SELECT DATED1 FROM TH_UIS_CALENDAR T1 WITH(NOLOCK) WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = AA.CURR_DATE)) AS PLAN_START_DATE                                                        ' + char(10)
		SELECT @v_dSql += N'		   , CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR _T2 WITH(NOLOCK) WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = AA.CURR_DATE)))), 112) AS PLAN_END_DATE   ' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		  SELECT A.BASIS_START_TIME                                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'				   , CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < CONVERT(VARCHAR,dbo.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME                                                                          ' + char(10)
		SELECT @v_dSql += N'						  THEN CONVERT(VARCHAR, DATEADD(DD,-1,dbo.FN_SITE_TIME(B.SITE_ID)), 112)                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'						  ELSE CONVERT(VARCHAR, dbo.FN_SITE_TIME(B.SITE_ID), 112) END AS CURR_DATE                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'		  FROM   FP_INSTANCE_START_TIME_V A, (                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'				  		SELECT MAX(B.SITE_ID) AS SITE_ID                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'				  		FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK)                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'				  		WHERE  A.FACTORY_ID = B.FACTORY_ID                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'				  		AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'				  		AND    B.ACTIVE_FLAG = ''Y''                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'				  		AND    A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'				  ) B                                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'		  WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	) AA                                                                                                                                                                                                                                ' + char(10)
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
		SELECT @v_dSql += N'				  SELECT CASE WHEN FORMAT(DBO.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < CONVERT(VARCHAR,DBO.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME      ' + char(10)
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
	
	IF @p_sys_flag = 'LINE_CODE_LIST'	-- findLineCode_List
	BEGIN
		SELECT @v_dSql += N'	SELECT 	A.LINE_ID AS CODE																													' + char(10)	
		SELECT @v_dSql += N'	   		, ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END) AS NAME    ' + char(10)
		SELECT @v_dSql += N'	FROM   	SCM_LINE_M A WITH(NOLOCK)                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	WHERE 	A.ACTIVE_FLAG = ''Y''                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	AND    EXISTS (                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'		        	SELECT 1                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                       ' + char(10)
		SELECT @v_dSql += N'		        	WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                                             ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.DIVISION_ID = B.DIVISION_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.SITE_ID     = B.SITE_ID                                                                                                ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.PLANT_ID	 = B.PLANT_ID                                                                                               ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.FACTORY_ID  = B.FACTORY_ID                                                                                             ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.OPERATION_ID = B.OPERATION_ID                                                                                          ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.LINE_ID 	 = B.LINE_ID                                                                                                ' + char(10)
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
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		
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
			IF @p_instance_id = 'PL_PACK' BEGIN
				SELECT @v_dSql += N'	  AND A.MODEL_TYPE IN (                                                                                                                ' + char(10)
				SELECT @v_dSql += N'	      SELECT AA.SEGMENT2 FROM SCM_SYS_LOOKUP_VALUE AA WITH(NOLOCK)                                                                       ' + char(10)
				SELECT @v_dSql += N'	      WHERE  AA.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''                                                                    ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.ATTRIBUTE6' , 'EQ', @p_user_lt)) + char(10)
				SELECT @v_dSql += N'	  )                                                                                                                                 ' + char(10)
			END ELSE BEGIN
				SELECT @v_dSql += N'	  AND A.LINE_ID IN (                                                                                                                ' + char(10)
				SELECT @v_dSql += N'	      SELECT DISTINCT LINE_ID                                                                                                       ' + char(10)
				SELECT @v_dSql += N'	      FROM   FP_USER_LINE_GROUP_M AA WITH(NOLOCK)                                                                                   ' + char(10)
				SELECT @v_dSql += N'	      WHERE  AA.INSTANCE_ID = '''+ @p_instance_id +'''		                                                                        ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.USER_ID' , 'EQ', @p_user_lt)) + char(10)
				SELECT @v_dSql += N'	  )                                                                                                                                 ' + char(10)
			END
		END
		/*
		IF @p_plan_type = 'RELEASE' AND @p_confirm_area = 'PLAN GROUP' BEGIN
			SELECT @v_dSql += N'	        AND A.MODEL_TYPE IN (                                                                                                       ' + char(10)
			SELECT @v_dSql += N'	            SELECT KK.PLAN_GROUP_ID                                                                                                 ' + char(10)
			SELECT @v_dSql += N'	            FROM   FP_RELEASE_PLAN_INFO_H KK WITH(NOLOCK)                                                                           ' + char(10)
			SELECT @v_dSql += N'	            WHERE  KK.INSTANCE_ID = '''+ @p_master_id +'''                                                                     ' + char(10)
			SELECT @v_dSql += N'	            AND    KK.RELEASE_PLAN_ID = '''+ @p_plan_id +'''                                                                   ' + char(10)
			SELECT @v_dSql += N'	        )                                                                                                                           ' + char(10)
		END
		*/
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

	IF @p_sys_flag = 'DATE_TEMP'	-- find_date_tmp
	BEGIN

		SELECT @v_dSql += N'	SELECT '''+ @p_plan_date +''' AS PLAN_DATE                                    			' + char(10)
		SELECT @v_dSql += N'	       , '''+ @p_plan_date +''' AS PLAN_START_DATE                                     ' + char(10)
		SELECT @v_dSql += N'	       , (	SELECT 	CONVERT(VARCHAR,CONVERT(DATETIME,DATED7) + 29,112)      ' + char(10)
		SELECT @v_dSql += N'	       		FROM 	TH_UIS_CALENDAR K WITH(NOLOCK)                          ' + char(10)
		SELECT @v_dSql += N'	       		WHERE 	D0 = (                                                  ' + char(10)
		SELECT @v_dSql += N'	       						SELECT 	ISO_YYYYWW                              ' + char(10)
		SELECT @v_dSql += N'	       						FROM 	TH_UIS_CAL A WITH(NOLOCK)               ' + char(10)
		SELECT @v_dSql += N'	       						WHERE 	YYYYMMDD = '''+ @p_plan_date +'''                  ' + char(10)
		SELECT @v_dSql += N'	       					)                                                   ' + char(10)
		SELECT @v_dSql += N'	       	 ) AS PLAN_END_DATE                                                 ' + char(10)
	
	END

	IF @p_sys_flag = 'CELL_CODE'	-- find_date_tmp
	BEGIN
		
		SELECT @v_dSql += N'	SELECT MAX(ATTB_03) AS CELL_CODE				' + char(10)
		SELECT @v_dSql += N'	FROM '+ @p_table_name +'						' + char(10)
		SELECT @v_dSql += N'	WHERE 1=1										' + char(10)
		SELECT @v_dSql += N'	AND SIM_PLAN_ID = '''+ @p_plan_id +'''		' + char(10)
		SELECT @v_dSql += N'	AND ITEM_ID = '''+ @p_sel_item_id +'''				' + char(10)
		SELECT @v_dSql += N'	AND LINE_ID = '''+ @p_sel_line_id +'''				' + char(10)
		SELECT @v_dSql += N'	AND PLAN_DATE = '''+ @p_sel_plan_date +'''		' + char(10)
		--SELECT @v_dSql += N'	AND PLAN_DATE = CONVERT(VARCHAR,'''+ @p_sel_plan_date +''',112)		' + char(10)
	
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
