CREATE PROCEDURE [dbo].[PR_UI_FP00600_EXCEL]
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
/** 프로그램 ID   : PR_UI_FP00600_EXCEL                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP00600_EXCEL                                               **/
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
/** 2021/04/23   CYS				Initial Release UI통합                                    **/
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP00600_EXCEL';
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
	DECLARE @ssp_total	NVARCHAR(MAX);

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

	IF @p_sys_flag = 'EXCEL_ROW_IMPORT'	-- find_ExcelImport
	BEGIN
		
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID   								' + char(10)
		SELECT @v_dSql += N'		   , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME      ' + char(10)
		SELECT @v_dSql += N'		   , A.OPERATION_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'		   , A.FACTORY_ID, A.LOCATION                                                           ' + char(10)
		SELECT @v_dSql += N'		   , A.PRODUCTION_TYPE, A.MARKET                                                        ' + char(10)
		SELECT @v_dSql += N'		   , A.LINE_ID, A.ELECTRODE_TYPE, ISNULL(D.LINE_NAME,''-'') AS LINE_NAME                ' + char(10)
		SELECT @v_dSql += N'		   , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE                                    ' + char(10)
		SELECT @v_dSql += N'		   , A.OUT_QTY AS QTY                                                                   ' + char(10)
		SELECT @v_dSql += N'		   , A.DATE_SEQ AS SEQ                                                                  ' + char(10)
		SELECT @v_dSql += N'	FROM  	FP_AMEND_PLAN_PACK_R A WITH(NOLOCK)                                                 ' + char(10)
		SELECT @v_dSql += N'			INNER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                ' + char(10)
		SELECT @v_dSql += N'			ON     A.COMPANY_ID     = C.COMPANY_ID                                              ' + char(10)
		SELECT @v_dSql += N'			AND    A.DIVISION_ID    = C.DIVISION_ID                                             ' + char(10)
		SELECT @v_dSql += N'			AND    A.SITE_ID        = C.SITE_ID                                                 ' + char(10)
		SELECT @v_dSql += N'			AND    A.TOP_ITEM_ID    = C.ITEM_ID                                                 ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN SCM_LINE_M D WITH(NOLOCK)                                           ' + char(10)
		SELECT @v_dSql += N'			ON     A.COMPANY_ID     = D.COMPANY_ID                                              ' + char(10)
		SELECT @v_dSql += N'			AND    A.DIVISION_ID    = D.DIVISION_ID                                             ' + char(10)
		SELECT @v_dSql += N'			AND    A.SITE_ID        = D.SITE_ID                                                 ' + char(10)
		SELECT @v_dSql += N'			AND    A.PLANT_ID       = D.PLANT_ID                                                ' + char(10)
		SELECT @v_dSql += N'			AND    A.FACTORY_ID     = D.FACTORY_ID                                              ' + char(10)
		SELECT @v_dSql += N'			AND    A.OPERATION_ID   = D.OPERATION_ID                                            ' + char(10)
		SELECT @v_dSql += N'			AND    A.LINE_ID        = D.LINE_ID                                                 ' + char(10)
		SELECT @v_dSql += N'			AND    A.ELECTRODE_TYPE = D.ELECTRODE_TYPE                                          ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.INSTANCE_ID    = '''+ @p_master_id +'''                                            ' + char(10)
		SELECT @v_dSql += N'	AND    A.FP_PLAN_ID     = '''+ @p_plan_id +'''                                              ' + char(10)
		SELECT @v_dSql += N'	AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''             ' + char(10)
		SELECT @v_dSql += N'	AND    A.OUT_QTY > 0                                                                        ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += N'	--ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                             ' + char(10)
		SELECT @v_dSql += N'	--        ,A.TOP_ITEM_ID,A.OPERATION_ID DESC , A.ITEM_ID                                    ' + char(10)
		SELECT @v_dSql += N'	--        ,A.FACTORY_ID, A.LOCATION                                                         ' + char(10)
		SELECT @v_dSql += N'	--        ,A.PRODUCTION_TYPE, A.MARKET                                                      ' + char(10)
		SELECT @v_dSql += N'	--        ,A.LINE_ID, A.PLAN_DATE                                                           ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                 ' + char(10)
		SELECT @v_dSql += N'		, A.PLAN_DATE                                                                           ' + char(10)
		SELECT @v_dSql += N'		, A.PRODUCTION_TYPE                                                                     ' + char(10)
		SELECT @v_dSql += N'		, A.MARKET                                                                              ' + char(10)
		SELECT @v_dSql += N'		, A.TOP_ITEM_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'		, A.OPERATION_ID DESC                                                                   ' + char(10)
		SELECT @v_dSql += N'		, A.ITEM_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'		, A.LINE_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'		, A.ELECTRODE_TYPE                                                                      ' + char(10)

	END
	
	IF @p_sys_flag = 'EXCEL_COLUMN_IMPORT'	-- find_WeekCnt
	BEGIN

		SELECT @v_dSql += N'	SELECT 	A.*																																													' + char(10)
		SELECT @v_dSql += N'	FROM 	(                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			      SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'			           , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'			           , A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'			           , A.PRODUCTION_TYPE, A.MARKET, A.ITEM_TYPE                                                                                                                               ' + char(10)
		
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
					
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , '_DATE')   END
					--IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL]( @tmp_column , @sub_v_delimiter , 1)   END

					SELECT @v_dSql += N'			    , SUM(CONVERT(NUMERIC(25,10), CASE WHEN A.PLAN_DATE = '''+ @sub_param_0 +''' THEN A.QTY ELSE NULL END)) AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) + '_QTY  ' + char(10)
					SELECT @v_dSql += N'			    , SUM(CONVERT(NUMERIC(25,10), CASE WHEN A.PLAN_DATE = '''+ @sub_param_0 +''' THEN A.SEQ ELSE NULL END)) AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) + '_SEQ  ' + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'			      FROM 	(                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'					          SELECT A.INSTANCE_ID, A.FP_PLAN_ID                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'					               , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION                                                                               ' + char(10)
		SELECT @v_dSql += N'					               , A.OPERATION_ID, A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID                                                  ' + char(10)
		SELECT @v_dSql += N'					               , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME                                                                                           ' + char(10)
		SELECT @v_dSql += N'					               , A.PRODUCTION_TYPE, A.MARKET, B.ITEM_TYPE                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'					               , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE                                                                                                            ' + char(10)
		SELECT @v_dSql += N'					               , ROUND(A.OUT_QTY,2) AS QTY                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'					               , A.DATE_SEQ AS SEQ                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'					          FROM   	FP_AMEND_PLAN_PACK_R A WITH(NOLOCK)                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										LEFT OUTER JOIN (                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'										  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,                                                                                               ' + char(10)
		SELECT @v_dSql += N'										         A.ITEM_ID,                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										         (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME                                         ' + char(10)
		SELECT @v_dSql += N'										         	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                                                                  ' + char(10)
		SELECT @v_dSql += N'										         	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,                                                                                                 ' + char(10)
		SELECT @v_dSql += N'										         ISNULL(A.NICK_NAME,''-'') AS NICK_NAME                                                                                                         ' + char(10)
		SELECT @v_dSql += N'										  FROM	 SCM_ITEM_M A WITH(NOLOCK),                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										    		 SCM_ITEM_CLASS_M C WITH(NOLOCK)                                                                                                            ' + char(10)
		SELECT @v_dSql += N'										  WHERE	 A.ITEM_CLASS  = C.CLASS_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										) B                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										ON     A.COMPANY_ID     = B.COMPANY_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'										AND    A.DIVISION_ID    = B.DIVISION_ID                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'										AND    A.SITE_ID        = B.SITE_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										AND    A.TOP_ITEM_ID    = B.ITEM_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										INNER JOIN SCM_LINE_M C WITH(NOLOCK)                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'										ON     A.COMPANY_ID     = C.COMPANY_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'										AND    A.DIVISION_ID    = C.DIVISION_ID                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'										AND    A.SITE_ID        = C.SITE_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										AND    A.PLANT_ID       = C.PLANT_ID                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'										AND    A.FACTORY_ID     = C.FACTORY_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'										AND    A.OPERATION_ID   = C.OPERATION_ID                                                                                                                ' + char(10)
		SELECT @v_dSql += N'										AND    A.LINE_ID        = C.LINE_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE                                                                                                              ' + char(10)
		SELECT @v_dSql += N'							  WHERE  A.INSTANCE_ID    = '''+ @p_master_id +'''                                            ' + char(10)
		SELECT @v_dSql += N'							  AND    A.FP_PLAN_ID     = '''+ @p_plan_id +'''                                              ' + char(10)
		SELECT @v_dSql += N'					          AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                             ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += N'					           AND 	  A.OUT_QTY > 0                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'						) A                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'				GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'				     , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'				     , A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'				     , A.PRODUCTION_TYPE, A.MARKET, A.ITEM_TYPE                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'			) A                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN (                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'								SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                         ' + char(10)
		SELECT @v_dSql += N'								   , A.LOCATION, A.OPERATION_ID                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'								   , A.LINE_ID                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'								   , A.TOP_ITEM_ID, A.ITEM_ID                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'								   , MIN(A.LINE_SEQ) LINE_SEQ                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'								FROM (                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'										  SELECT A.INSTANCE_ID, A.FP_PLAN_ID                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'										       , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION                                                                   ' + char(10)
		SELECT @v_dSql += N'										       , A.OPERATION_ID, A.LINE_ID                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'										       , A.TOP_ITEM_ID, A.ITEM_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'										       , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE                                                                                                ' + char(10)
		SELECT @v_dSql += N'										       , A.DATE_SEQ                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										       , RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                     ' + char(10)
		SELECT @v_dSql += N'										                                 , A.LOCATION, A.OPERATION_ID                                                                                           ' + char(10)
		SELECT @v_dSql += N'										                                 , A.LINE_ID                                                                                                            ' + char(10)
		SELECT @v_dSql += N'										                      ORDER     BY CONVERT(VARCHAR, A.PLAN_DATE, 112), A.DATE_SEQ ) LINE_SEQ                                                            ' + char(10)
		SELECT @v_dSql += N'										  FROM   	FP_AMEND_PLAN_PACK_R A WITH(NOLOCK)                                                                                                         ' + char(10)
		SELECT @v_dSql += N'												  INNER JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                                                          ' + char(10)
		SELECT @v_dSql += N'												  ON     A.COMPANY_ID     = B.COMPANY_ID                                                                                                        ' + char(10)
		SELECT @v_dSql += N'												  AND    A.DIVISION_ID    = B.DIVISION_ID                                                                                                       ' + char(10)
		SELECT @v_dSql += N'												  AND    A.SITE_ID        = B.SITE_ID                                                                                                           ' + char(10)
		SELECT @v_dSql += N'												  AND    A.ITEM_ID        = B.ITEM_ID                                                                                                           ' + char(10)
		SELECT @v_dSql += N'												  INNER JOIN SCM_LINE_M C WITH(NOLOCK)                                                                                                          ' + char(10)
		SELECT @v_dSql += N'												  ON     A.COMPANY_ID     = C.COMPANY_ID                                                                                                        ' + char(10)
		SELECT @v_dSql += N'												  AND    A.DIVISION_ID    = C.DIVISION_ID                                                                                                       ' + char(10)
		SELECT @v_dSql += N'												  AND    A.SITE_ID        = C.SITE_ID                                                                                                           ' + char(10)
		SELECT @v_dSql += N'												  AND    A.PLANT_ID       = C.PLANT_ID                                                                                                          ' + char(10)
		SELECT @v_dSql += N'												  AND    A.FACTORY_ID     = C.FACTORY_ID                                                                                                        ' + char(10)
		SELECT @v_dSql += N'												  AND    A.OPERATION_ID   = C.OPERATION_ID                                                                                                      ' + char(10)
		SELECT @v_dSql += N'												  AND    A.LINE_ID        = C.LINE_ID                                                                                                           ' + char(10)
		SELECT @v_dSql += N'												  AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE                                                                                                    ' + char(10)
		SELECT @v_dSql += N'										WHERE  A.INSTANCE_ID    = '''+ @p_master_id +'''                                            ' + char(10)
		SELECT @v_dSql += N'										AND    A.FP_PLAN_ID     = '''+ @p_plan_id +'''                                              ' + char(10)
		SELECT @v_dSql += N'										AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                             ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += N'											AND 	  A.OUT_QTY > 0                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'											AND    ISNULL(A.DATE_SEQ, 0) <> 0                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'									) A                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'								GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                       ' + char(10)
		SELECT @v_dSql += N'									 , A.LOCATION, A.OPERATION_ID                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'									 , A.LINE_ID                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'							 		, A.TOP_ITEM_ID, A.ITEM_ID                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'				) B                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'				ON  A.COMPANY_ID      		= B.COMPANY_ID                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'				AND A.DIVISION_ID     = B.DIVISION_ID                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'				AND A.SITE_ID         = B.SITE_ID                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'				AND A.PLANT_ID        = B.PLANT_ID                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'				AND A.FACTORY_ID      = B.FACTORY_ID                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'				AND A.LOCATION        = B.LOCATION                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'				AND A.OPERATION_ID    = B.OPERATION_ID                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'				AND A.LINE_ID         = B.LINE_ID                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'				AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'				AND A.ITEM_ID         = B.ITEM_ID                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	--ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	--       , A.LOCATION, A.TOP_ITEM_ID , A.OPERATION_ID DESC, A.LINE_ID, B.LINE_SEQ, A.ELECTRODE_TYPE, A.EQUIPMENT_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'	--      , A.ITEM_ID                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	--       , A.PRODUCTION_TYPE, A.MARKET                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'		, A.TOP_ITEM_ID, A.PRODUCTION_TYPE , A.OPERATION_ID DESC,  A.ITEM_ID,  A.LINE_ID, A.ELECTRODE_TYPE                                                                                      ' + char(10)
		SELECT @v_dSql += N'	  , A.MARKET                                                                                                                                                                                ' + char(10)

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
