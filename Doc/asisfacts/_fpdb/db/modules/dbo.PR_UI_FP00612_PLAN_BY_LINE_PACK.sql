 



/*
 * Program ID   : PR_UI_FP00612_PLAN_BY_LINE_PACK
 * Description  : Plan By Line(Pack)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/05/27   CYS				Initial Release UI통합
 * 2022/10/20   LJS             조회속도 개선
 * 2026-05-13   SYngsn          E20260421-000487 acc gap - weeksum error - plan by line ( fomation)
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00612_PLAN_BY_LINE_PACK]
	@p_sys_type			NVARCHAR(MAX),  
	@p_sys_flag			NVARCHAR(MAX),
	@p_sys_gubun		NVARCHAR(MAX),  
	@p_user_id			NVARCHAR(MAX),
	@in_columns			NVARCHAR(MAX),
	@in_row				NVARCHAR(MAX),
	@opt_none			NVARCHAR(5) = 'N'
WITH EXEC AS CALLER
AS

   
BEGIN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00612_PLAN_BY_LINE_PACK';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			NVARCHAR(MAX)='';
	
	DECLARE @STRLEN			NVARCHAR(MAX);
	DECLARE @v_Err			NVARCHAR(MAX);
	DECLARE @v_Log			NVARCHAR(MAX);
	DECLARE @v_delimiter	nvarchar(1);
	DECLARE @max_loop_cnt	integer = 0;
	DECLARE @mst_loop_cnt	integer = 0;
	
	DECLARE @p__save_auth	NVARCHAR(MAX);
	DECLARE @p__non_auth	NVARCHAR(MAX);

	-- filter

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
	DECLARE @p_confirm_area	NVARCHAR(MAX);
	DECLARE @p_curr_date_col NVARCHAR(MAX);
	DECLARE @p_plan_type	NVARCHAR(MAX);
	DECLARE @p_pjt_group_name	NVARCHAR(MAX);
	DECLARE @p_curr_date_gap	NVARCHAR(MAX); -- 인스턴스별 현재일자를 구한다.
	DECLARE @tmp_GAP_lastCol	NVARCHAR(MAX); -- Gap(WPP) week, month 막날 용
	-- week
	DECLARE @p_bucket		NVARCHAR(MAX);
	DECLARE @p_week_info	NVARCHAR(MAX);
	DECLARE @p_month_info	NVARCHAR(MAX);
	DECLARE @p_day2_week_month_info	NVARCHAR(MAX);

	-- table
	DECLARE @p_amend_table	NVARCHAR(MAX);
	DECLARE @p_amend_sales_table		NVARCHAR(MAX);
	DECLARE @p_amend_cutoff_boh_table	NVARCHAR(MAX);
	DECLARE @p_amend_util_table	NVARCHAR(MAX);
	DECLARE @p_result_qty	NVARCHAR(MAX);

	DECLARE @tmp_column		NVARCHAR(MAX);
	DECLARE @tmp_value		NVARCHAR(MAX);
	DECLARE @dbg_txt		NVARCHAR(MAX);
	DECLARE @p_temp			NVARCHAR(MAX);

	/*	Parameter Setting Start */
	
	SET @v_delimiter            = '^'  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	
	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
		
		SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

		SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @in_columns , @v_delimiter , @mst_loop_cnt );
		SET @tmp_value	= [dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt );
		
		IF @tmp_column = '_SAVE_AUTH' BEGIN
			SET @p__save_auth =			@tmp_value
		END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
			SET @p__non_auth =			@tmp_value

		END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
			SET @p_instance_id =		@tmp_value
		END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
			SET @p_master_id =			@tmp_value
		END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
			SET @p_plan_date =			@tmp_value
		END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
			SET @p_plan_id =			@tmp_value
		END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
			SET @p_bucket_from =		@tmp_value
		END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
			SET @p_bucket_to =			@tmp_value

		END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
			SET @p_division_id =		@tmp_value
		END ELSE IF @tmp_column = 'SITE_ID' BEGIN
			SET @p_site_id =			@tmp_value
		END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
			SET @p_plant_id =			@tmp_value
		END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
			SET @p_factory_id =			@tmp_value
		END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
			SET @p_operation_id =		@tmp_value
		END ELSE IF @tmp_column = 'LINE_ID' BEGIN
			SET @p_line_id =			@tmp_value
		
		END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
			SET @p_top_item_id =		@tmp_value
		END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
			SET @p_item_id =			@tmp_value
		END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
			SET @p_nick_name =			@tmp_value
		END ELSE IF @tmp_column = 'PROD_TYPE' BEGIN
			SET @p_prod_type =			@tmp_value
		END ELSE IF @tmp_column = 'CELL_GROUP' BEGIN
			SET @p_cell_group =			@tmp_value
		END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
			SET @p_plan_type  =			@tmp_value
		END ELSE IF @tmp_column = 'CONFIRM_AREA' BEGIN
			SET @p_confirm_area  =		@tmp_value
		END ELSE IF @tmp_column = 'CURR_DATE_COL' BEGIN
			SET @p_curr_date_col =		@tmp_value
		END ELSE IF @tmp_column = 'PJT_GROUP_NAME' BEGIN
			SET @p_pjt_group_name =		@tmp_value

		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =				@tmp_value
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			@tmp_value
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			@tmp_value
		END ELSE IF @tmp_column = 'DAY2_WEEK_MONTH' BEGIN
			SET @p_day2_week_month_info =			@tmp_value
		
		END ELSE IF @tmp_column = 'CATE_INFO' BEGIN
			SET @p_cate_info =			@tmp_value

		END ELSE IF @tmp_column = 'AMEND_TABLE' BEGIN
			SET @p_amend_table =		@tmp_value
		END ELSE IF @tmp_column = 'AMEND_SALES_TABLE' BEGIN
			SET @p_amend_sales_table =  @tmp_value
		END ELSE IF @tmp_column = 'AMEND_CUTOFF_BOH_TABLE' BEGIN
			SET @p_amend_cutoff_boh_table =  @tmp_value
		END ELSE IF @tmp_column = 'AMEND_UTIL_TABLE' BEGIN
			SET @p_amend_util_table =	@tmp_value
		END ELSE IF @tmp_column = 'RESULT_QTY' BEGIN
			SET @p_result_qty =			@tmp_value
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
	DECLARE @max_day2_week_month_loop_cnt	integer = 0;
	DECLARE @max_category_loop_cnt	integer = 0;
	
	SET @v_row_delimiter	= '!';  -- row column 데이터 구분자
	SET @sub_v_delimiter	= '#';  -- column  데이타 구분자 (추후 변경)

	SET @max_loop_cnt		= [dbo].[SCM_ARR_SPL_CNT](@p_bucket		, @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
	SET @max_week_loop_cnt	= [dbo].[SCM_ARR_SPL_CNT](@p_week_info	, @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
	SET @max_month_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
	SET @max_day2_week_month_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day2_week_month_info , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
	SET @max_category_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단

	

	IF ISNULL(@p_cate_info,'') <> '' BEGIN
		SET @mst_loop_cnt	= 0
		WHILE @mst_loop_cnt < @max_category_loop_cnt
		BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
			SET @mst_loop_cnt =  @mst_loop_cnt + 1
			SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info , @v_row_delimiter , @mst_loop_cnt)
			SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column , @sub_v_delimiter)

			IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_ID')   END
			IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_VALUE')   END

			IF @sub_param_0 = 'chk_subTotal' AND @sub_param_1 = 'false' BEGIN
				SET @sub_total = 'WHERE 1=0' +char(10)
			END
			
			IF @sub_param_0 = 'chk_subTotal' AND @sub_param_1 = 'true' BEGIN
				SET @sub_total = 'WHERE 1=1' +char(10)
			END 

			IF @sub_param_0 = 'chk_total' AND @sub_param_1 = 'false' BEGIN
				SET @total = 'WHERE 1=0' +char(10)
			END 
			
			IF @sub_param_0 = 'chk_total' AND @sub_param_1 = 'true' BEGIN
				SET @total = 'WHERE 1=1' +char(10)
			END 
			
		END -- WHILE
	END -- IF ISNULL(@p_cate_info,'') 

	
	BEGIN

		SET	@v_dSql = ''

		SET @p_curr_date_gap = (
				 SELECT CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,'yyyyMMddHHmmss') < CONVERT(VARCHAR,DBO.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME
							  THEN CONVERT(VARCHAR, DATEADD(DD,-1,DBO.FN_SITE_TIME(B.SITE_ID)), 112) 
							  ELSE CONVERT(VARCHAR, DBO.FN_SITE_TIME(B.SITE_ID), 112) END AS CURR_DATE 
				  FROM   FP_INSTANCE_START_TIME_V A,
				  (
						  SELECT MAX(B.SITE_ID) AS SITE_ID 
						  FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK)
						  WHERE  A.FACTORY_ID = B.FACTORY_ID 
						  AND    A.ACTIVE_FLAG = 'Y'
						  AND    B.ACTIVE_FLAG = 'Y'
						  AND    A.INSTANCE_ID = @p_instance_id
				  ) B
				  WHERE  A.INSTANCE_ID = @p_instance_id
			  )

		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_MAIN'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_MAIN ' + char(10)
		SELECT @v_dSql += N'' + char(10)
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_MAIN_GAP'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_MAIN_GAP ' + char(10)
		SELECT @v_dSql += N'' + char(10)
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_T_RELEASE'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_T_RELEASE ' + char(10) + char(10)
		-- GAP(WPP) 추가
		SELECT @v_dSql += N'if object_id(''tempdb..#MAIN_ITEM_WPP_GAP'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #MAIN_ITEM_WPP_GAP ' + char(10)
		SELECT @v_dSql += N'if object_id(''tempdb..#MAIN_GAP_WPP'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #MAIN_GAP_WPP ' + char(10) + char(10)
		-- 속도개선... 20231023
		SELECT @v_dSql += N'if object_id(''tempdb..#SCM_DAILY_PRODUCT_RESULT_H'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #SCM_DAILY_PRODUCT_RESULT_H ' + char(10)
		SELECT @v_dSql += N'if object_id(''tempdb..#FP_DAILY_PRODUCTIOIN_PLAN_H'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #FP_DAILY_PRODUCTIOIN_PLAN_H ' + char(10)+ char(10)
		
		-- 속도개선... 20231023
		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'     , A.TOP_ITEM_ID, A.ITEM_ID , A.FP_PRODUCTION_TYPE, A.MARKET ' + char(10)
		SELECT @v_dSql += N'     , A.ACTUAL_GOOD_QTY ' + char(10)
		SELECT @v_dSql += N'INTO  #SCM_DAILY_PRODUCT_RESULT_H ' + char(10)
		SELECT @v_dSql += N'FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01 00:00:00.000'', 121) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'', 121) ' + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'AND    A.ACTUAL_GOOD_QTY > 0 ' + char(10)
		SELECT @v_dSql += N'; ' + char(10)
		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'     , A.TOP_ITEM_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE, A.MARKET, A.PLAN_TYPE ' + char(10)
		SELECT @v_dSql += N'     , A.PLAN_QTY, A.PLAN_IN_QTY ' + char(10)
		SELECT @v_dSql += N'INTO  #FP_DAILY_PRODUCTIOIN_PLAN_H ' + char(10)
		SELECT @v_dSql += N'FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, (SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01'')) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		SELECT @v_dSql += N'AND    A.PLAN_TYPE IN ( ''RELEASE'', ''MPP'', ''WPP'' ) ' + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id))
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'AND    ( A.PLAN_QTY + A.PLAN_IN_QTY ) > 0 ' + char(10)
		SELECT @v_dSql += N'; ' + char(10) + char(10)

		-- GAP(WPP) 추가
		-- 조회되는 아이템-날짜 세트 : 1일 부터의 구간을 가생성
		SELECT @v_dSql += N'SELECT A.* ' + char(10)
		SELECT @v_dSql += N'     , B.YYYYMMDD AS PLAN_DATE, B.ISO_YYYYWW AS PLAN_WEEK, B.YYYYMM AS PLAN_MONTH ' + char(10)
		SELECT @v_dSql += N'     , ISNULL(D.OPERATION_NAME,''-'') AS OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'     , ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, '''' AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'     , ISNULL(BB.NICK_NAME,''-'') AS NICK_NAME, BB.ITEM_TYPE, ISNULL(BB.PJT_GROUP_NAME,''-'') AS PJT_GROUP_NAME ' + char(10)
		SELECT @v_dSql += N'INTO #MAIN_ITEM_WPP_GAP ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'		 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'		 , A.MARKET ' + char(10)
		SELECT @v_dSql += N'	FROM   #SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''' + '' 00:00:00.000'', 121) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'', 121) ' + char(10)
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id))
		--SELECT @v_dSql += N'	AND    A.ACTUAL_GOOD_QTY > 0 ' + char(10)
		SELECT @v_dSql += N'	UNION ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'		 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'		 , A.MARKET ' + char(10)
		SELECT @v_dSql += N'	FROM    #FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE   1=1 ' + char(10)
		SELECT @v_dSql += N'	AND     A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''' + '' 00:00:00.000'', 121) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'', 121) ' + char(10)
		SELECT @v_dSql += N'	AND 	A.PLAN_TYPE IN (''WPP'', ''RELEASE'') ' + char(10) -- WPP 는 WPP(Out) 품번, RELEASE 는 미래실적 품번 때문에 가져옴(미래실적의 경우, 엄밀히 말하면 당일이후 날짜의 품번만 가져와야하나 별도로 가져오기 애매하므로 일단 같이 가져온다... 문제되면 분리해서 하단에 union all 로 붙여야할듯)
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id))
		--SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id))
		--SELECT @v_dSql += N'	AND 	( A.PLAN_QTY + A.PLAN_IN_QTY ) > 0 ' + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'INNER JOIN ( ' + char(10)
		SELECT @v_dSql += N'		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)
		SELECT @v_dSql += N'				A.ITEM_ID, ' + char(10)
		SELECT @v_dSql += N'				(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
		SELECT @v_dSql += N'	                  WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
		SELECT @v_dSql += N'	                  ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, ' + char(10)
		SELECT @v_dSql += N'				ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME ' + char(10)
		SELECT @v_dSql += N'		FROM   SCM_ITEM_M A WITH(NOLOCK), ' + char(10)
		SELECT @v_dSql += N'	           SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'		WHERE  A.ITEM_CLASS  = C.CLASS_ID ' + char(10)
		SELECT @v_dSql += N'		AND      A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'		AND      C.USE_FLAG    = ''Y'' ' + char(10)
		SELECT @v_dSql += N'		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
		SELECT @v_dSql += N'		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_pjt_group_name)) + char(10)
		SELECT @v_dSql += N') BB ' + char(10)
		SELECT @v_dSql += N'ON     A.COMPANY_ID     = BB.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.DIVISION_ID    = BB.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.SITE_ID        = BB.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.TOP_ITEM_ID     = BB.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'INNER JOIN SCM_LINE_M C WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON     A.COMPANY_ID     = C.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.DIVISION_ID    = C.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.SITE_ID        = C.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.PLANT_ID       = C.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.FACTORY_ID     = C.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.OPERATION_ID   = C.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.LINE_ID        = C.LINE_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'INNER JOIN SCM_OPERATION_M D WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON     A.COMPANY_ID     = D.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.DIVISION_ID    = D.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.SITE_ID        = D.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.OPERATION_ID   = D.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N', TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'AND   B.YYYYMMDD BETWEEN (SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01'') AND ''' + @p_bucket_to + ''' ' + char(10)-- 시작일의 월의 첫날부터
		SELECT @v_dSql += N'OPTION (FORCE ORDER) ' + char(10)
		SELECT @v_dSql += N'; ' + char(10)+char(10)

		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'     , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'     , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'     , A.EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'     , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME ' + char(10)
		SELECT @v_dSql += N'     , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
		SELECT @v_dSql += N'     , A.ITEM_TYPE ' + char(10)
		SELECT @v_dSql += N'     , A.CATE ' + char(10)

		IF ISNULL(@p_day2_week_month_info,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo : 월별 막날 값이 필요
				SET @mst_loop_cnt = 0
				SET @p_temp = ''
				SET @tmp_GAP_lastCol = ''

				WHILE @mst_loop_cnt < @max_day2_week_month_loop_cnt
				BEGIN
					
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = [dbo].[SCM_ARR_SPL_VAL]( @p_day2_week_month_info, @v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'D_COL')   END -- D0, D1
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'M_COL')   END -- M0, M1

					-- 주차변경 전 alias 를 넣어준다.
					IF @p_temp <> '' AND @p_temp <> @sub_param_1 BEGIN
						SELECT @v_dSql += ' , ' + @tmp_GAP_lastCol

						SELECT @v_dSql += ' AS ' + @p_temp + '_QTY ' + char(10)
						SELECT @v_dSql += ' , NULL AS ' + @p_temp + '_COLOR ' + char(10)
					END 

					SET @tmp_GAP_lastCol = @sub_param_0 -- 각 월의 마지막 일자만 저장

					-- 마지막 month 정보를 넣어준다.
					IF @mst_loop_cnt = @max_day2_week_month_loop_cnt BEGIN
						SELECT @v_dSql += ' , ' + @tmp_GAP_lastCol
						
						SELECT @v_dSql += ' AS ' + @sub_param_1 + '_QTY ' + char(10)
						SELECT @v_dSql += ' , NULL AS ' + @sub_param_1 + '_COLOR ' + char(10)
					END 

					SET @p_temp = @sub_param_1; -- month 정보를 넣어준다.
				
				END-- end of @mst_loop_cnt < @max_loop_cnt

				---- weekinfo : 주별 막날 값이 필요
				SET @mst_loop_cnt = 0
				SET @p_temp = ''
				WHILE @mst_loop_cnt < @max_day2_week_month_loop_cnt
				BEGIN
					
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = [dbo].[SCM_ARR_SPL_VAL]( @p_day2_week_month_info, @v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'D_COL')   END -- D0, D1
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'W_COL')   END -- W0, W1

					-- 주차변경 전 alias 를 넣어준다.
					IF @p_temp <> '' AND @p_temp <> @sub_param_1 BEGIN
						SELECT @v_dSql += '	 , ' + @tmp_GAP_lastCol

						SELECT @v_dSql += ' AS ' + @p_temp + '_QTY ' + char(10)
						SELECT @v_dSql += '	 , NULL AS ' + @p_temp + '_COLOR ' + char(10)
					END 

					SET @tmp_GAP_lastCol = @sub_param_0 -- 각 주의 마지막 일자만 저장

					-- 마지막 week 정보를 넣어준다.
					IF @mst_loop_cnt = @max_day2_week_month_loop_cnt BEGIN
						SELECT @v_dSql += ' , ' + @tmp_GAP_lastCol
						
						SELECT @v_dSql += ' AS ' + @sub_param_1 + '_QTY ' + char(10)
						SELECT @v_dSql += '	 , NULL AS ' + @sub_param_1 + '_COLOR ' + char(10)
					END 
					
					SET @p_temp = @sub_param_1; -- month 정보를 넣어준다.
				
				END-- end of @mst_loop_cnt < @max_loop_cnt


			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					
					SELECT @v_dSql += '	 , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ' AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '	 , NULL AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)

					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''


		SELECT @v_dSql += N'	 , A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'	 , A.DATA_TYPE ' + char(10)
		SELECT @v_dSql += N'INTO #MAIN_GAP_WPP ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'		 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'		 , A.EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME ' + char(10)
		SELECT @v_dSql += N'		 , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
		SELECT @v_dSql += N'		 , A.ITEM_TYPE ' + char(10)
		SELECT @v_dSql += N'		 , B.CATEGORY_NAME AS CATE ' + char(10)

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
					
					SELECT @v_dSql += N'		 , SUM(CASE WHEN A.PLAN_DATE >= (SUBSTRING(''' + @sub_param_0 + ''',1,6)+''01'') AND A.PLAN_DATE <= ''' + @sub_param_0 + ''' THEN A.GAP_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ' ' + char(10)

				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'		 , B.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'		 , ''DATA'' AS DATA_TYPE ' + char(10)
		SELECT @v_dSql += N'	FROM ( ' + char(10)
		SELECT @v_dSql += N'		SELECT A.* ' + char(10)
		SELECT @v_dSql += N'			 , ISNULL(B.GAP_QTY,0) AS GAP_QTY ' + char(10)
		SELECT @v_dSql += N'		FROM #MAIN_ITEM_WPP_GAP A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'		LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'				 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'				 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'				 , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'				 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'				 , A.PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'				 , A.MARKET ' + char(10)
		SELECT @v_dSql += N'				 , SUM(ISNULL(A.RESULT_QTY,0)) - SUM(ISNULL(A.OUT_QTY,0)) AS GAP_QTY ' + char(10)
		SELECT @v_dSql += N'			FROM ( ' + char(10)
						                    -- WPP(OUT) : 1일부터 시작해서 end date 까지
		SELECT @v_dSql += N'				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'					 , A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'					 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'					 , A.MARKET ' + char(10)
		SELECT @v_dSql += N'					 , ISNULL(A.PLAN_QTY,0) AS OUT_QTY ' + char(10)
		SELECT @v_dSql += N'					 , 0 AS RESULT_QTY ' + char(10)
		SELECT @v_dSql += N'				FROM   #FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'				WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, (SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01'')) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		SELECT @v_dSql += N'				AND    A.PLAN_TYPE = ''WPP'' ' + char(10)
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id))
		--SELECT @v_dSql += N'				AND    ( A.PLAN_QTY + A.PLAN_IN_QTY ) > 0 ' + char(10)
											-- 실적 과거 : 1일부터 시작해서 당일 이전 까지
		SELECT @v_dSql += N'				UNION ALL ' + char(10)
		SELECT @v_dSql += N'				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'					 , A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'					 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'					 , A.MARKET ' + char(10)
		SELECT @v_dSql += N'					 , 0 AS OUT_QTY ' + char(10)
		SELECT @v_dSql += N'					 , A.ACTUAL_GOOD_QTY AS RESULT_QTY ' + char(10)
		SELECT @v_dSql += N'				FROM   #SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'				WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01 00:00:00.000'', 121) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'', 121) ' + char(10)
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id))
		--SELECT @v_dSql += N'				AND    A.ACTUAL_GOOD_QTY > 0 ' + char(10)
											-- 실적 미래 : 당일 부터 시작해서 end date 까지
		SELECT @v_dSql += N'				UNION ALL ' + char(10)
		SELECT @v_dSql += N'				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'					 , A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'					 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'					 , A.MARKET ' + char(10)
		SELECT @v_dSql += N'					 , 0 AS OUT_QTY ' + char(10)
		SELECT @v_dSql += N'					 , ISNULL(A.PLAN_QTY,0) AS RESULT_QTY ' + char(10)
		SELECT @v_dSql += N'				FROM   #FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'				WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_curr_date_gap + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		SELECT @v_dSql += N'				AND    A.PLAN_TYPE = ''RELEASE'' ' + char(10)
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id))
		--SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id))
		--SELECT @v_dSql += N'				AND    ( A.PLAN_QTY + A.PLAN_IN_QTY ) > 0 ' + char(10)
		SELECT @v_dSql += N'			) A ' + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'					, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'					, A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'					, A.PRODUCTION_TYPE, A.MARKET ' + char(10)
		SELECT @v_dSql += N'		) B ' + char(10)
		SELECT @v_dSql += N'		ON  1=1 ' + char(10)
		SELECT @v_dSql += N'		AND A.COMPANY_ID      = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'		AND A.DIVISION_ID     = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'		AND A.SITE_ID         = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'		AND A.PLANT_ID        = B.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'		AND A.FACTORY_ID      = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'		AND A.LOCATION        = B.LOCATION ' + char(10)
		SELECT @v_dSql += N'		AND A.OPERATION_ID    = B.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'		AND A.LINE_ID         = B.LINE_ID ' + char(10)
		SELECT @v_dSql += N'		AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'		AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'		AND A.ITEM_ID         = B.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'		AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'		AND A.MARKET          = B.MARKET ' + char(10)
		SELECT @v_dSql += N'		AND A.PLAN_DATE       = B.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'	) A ' + char(10)
		SELECT @v_dSql += N'	INNER JOIN ( ' + char(10)
		SELECT @v_dSql += N'		SELECT * ' + char(10)
		SELECT @v_dSql += N'		FROM ( ' + char(10)
		SELECT @v_dSql += N'			SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'			UNION ALL ' + char(10)
		SELECT @v_dSql += N'			SELECT ''GAP_WPP'' AS CATEGORY_ID, ''Accu. GAP(WPP)'' AS CATEGORY_NAME, 76 AS CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'		) BB ' + char(10)
		SELECT @v_dSql += N'		WHERE CATEGORY_ID <> ''X'' ' + char(10)
		SELECT @v_dSql += N'	) B ' + char(10)
		SELECT @v_dSql += N'	ON 1=1 ' + char(10)
		SELECT @v_dSql += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'		   , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'		   , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'		   , A.EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'		   , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME ' + char(10)
		SELECT @v_dSql += N'		   , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
		SELECT @v_dSql += N'		   , A.ITEM_TYPE, B.CATEGORY_NAME ' + char(10)
		SELECT @v_dSql += N'		   , B.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'OPTION (FORCE ORDER) ' + char(10)
		SELECT @v_dSql += N'; ' + char(10) + char(10)

		--SELECT @v_dSql += N'      WITH MAIN AS (																		 ' + char(10)
		SELECT @v_dSql += N'      		SELECT A.*                   ' + char(10)
		SELECT @v_dSql += N'      		INTO #TEMP_TABLE_MAIN ' + char(10)
		SELECT @v_dSql += N'      		FROM (    ' + char(10)
		SELECT @v_dSql += N'		          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID     ' + char(10)
		SELECT @v_dSql += N'		               , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME        ' + char(10)
		SELECT @v_dSql += N'		               , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE            ' + char(10)
		SELECT @v_dSql += N'		               , A.EQUIPMENT_ID  ' + char(10)
		SELECT @v_dSql += N'		               , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME              ' + char(10)
		SELECT @v_dSql += N'		               , A.PRODUCTION_TYPE, A.MARKET      ' + char(10)
		SELECT @v_dSql += N'		               , A.ITEM_TYPE     ' + char(10)
		SELECT @v_dSql += N'		               , B.CATEGORY_NAME AS CATE          ' + char(10)
		
		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
		
				-- month info
				SET @mst_loop_cnt = 0;
					
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SET @mst_loop_cnt = @mst_loop_cnt + 1 ;
					SET @tmp_column = '';
					SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_month_info , @v_row_delimiter , @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column , @sub_v_delimiter)

					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END

					SELECT @v_dSql += N'		        , SUM(CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' THEN (CASE	WHEN B.CATEGORY_ID=''P_IN'' AND A.PLAN_TYPE=''DPP'' THEN A.IN_QTY ' + char(10)
					SELECT @v_dSql += N'		                                                         				WHEN B.CATEGORY_ID=''P_OUT'' AND A.PLAN_TYPE=''DPP'' THEN A.OUT_QTY    ' + char(10)
					SELECT @v_dSql += N'		                                                             			WHEN B.CATEGORY_ID=''W_IN'' AND A.PLAN_TYPE=''WPP'' THEN A.IN_QTY       ' + char(10)
					SELECT @v_dSql += N'																				WHEN B.CATEGORY_ID=''W_OUT'' AND A.PLAN_TYPE=''WPP'' THEN A.OUT_QTY         ' + char(10)
					SELECT @v_dSql += N'		                                                             			WHEN B.CATEGORY_ID=''M_IN'' AND A.PLAN_TYPE=''MPP'' THEN A.IN_QTY       ' + char(10)
					SELECT @v_dSql += N'																				WHEN B.CATEGORY_ID=''M_OUT'' AND A.PLAN_TYPE=''MPP'' THEN A.OUT_QTY         ' + char(10)
					SELECT @v_dSql += N'																				WHEN B.CATEGORY_ID=''RESULT'' AND A.PLAN_TYPE=''RESULT'' THEN A.RESULT_QTY  ' + char(10)
					SELECT @v_dSql += N'																				WHEN B.CATEGORY_ID=''RESULT_EXP'' THEN A.RESULT_QTY2 ' + char(10) -- Result(+Exp.)
					SELECT @v_dSql += N'																				WHEN B.CATEGORY_ID=''OFFTIME'' AND A.PLAN_TYPE=''OFFTIME'' THEN A.OFF_TIME  ' + char(10)
					SELECT @v_dSql += N'																				WHEN B.CATEGORY_ID=''MEMO'' THEN NULL   ' + char(10)
					SELECT @v_dSql += N'		                                                     					ELSE 0 END) ELSE (CASE WHEN B.CATEGORY_ID=''MEMO'' THEN NULL ELSE 0 END) END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY  ' + char(10)
					SELECT @v_dSql += N'		        , NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR  ' + char(10)

				END		-- end of @mst_loop_cnt < @max_loop_cnt

				-- week info
				SET @mst_loop_cnt = 0	
				
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = '';
					SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_week_info , @v_row_delimiter , @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column , @sub_v_delimiter)

					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END

					SELECT @v_dSql += N'		        , SUM(CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN (CASE	WHEN B.CATEGORY_ID=''P_IN'' AND A.PLAN_TYPE=''DPP'' THEN A.IN_QTY       ' + char(10)
					SELECT @v_dSql += N'		                                                         					WHEN B.CATEGORY_ID=''P_OUT'' AND A.PLAN_TYPE=''DPP'' THEN A.OUT_QTY        ' + char(10)
					SELECT @v_dSql += N'		                                                                     		WHEN B.CATEGORY_ID=''W_IN'' AND A.PLAN_TYPE=''WPP'' THEN A.IN_QTY   ' + char(10)
					SELECT @v_dSql += N'																					WHEN B.CATEGORY_ID=''W_OUT'' AND A.PLAN_TYPE=''WPP'' THEN A.OUT_QTY       ' + char(10)
					SELECT @v_dSql += N'		                                                                     		WHEN B.CATEGORY_ID=''M_IN'' AND A.PLAN_TYPE=''MPP'' THEN A.IN_QTY   ' + char(10)
					SELECT @v_dSql += N'																					WHEN B.CATEGORY_ID=''M_OUT'' AND A.PLAN_TYPE=''MPP'' THEN A.OUT_QTY       ' + char(10)
					SELECT @v_dSql += N'																					WHEN B.CATEGORY_ID=''RESULT'' AND A.PLAN_TYPE=''RESULT'' THEN A.RESULT_QTY                   ' + char(10)
					SELECT @v_dSql += N'																					WHEN B.CATEGORY_ID=''RESULT_EXP'' THEN A.RESULT_QTY2 ' + char(10) -- Result(+Exp.)
					SELECT @v_dSql += N'																					WHEN B.CATEGORY_ID=''OFFTIME'' AND A.PLAN_TYPE=''OFFTIME'' THEN A.OFF_TIME  ' + char(10)
					SELECT @v_dSql += N'																					WHEN B.CATEGORY_ID=''MEMO'' THEN NULL   ' + char(10)
					SELECT @v_dSql += N'		                                                         					ELSE 0 END) ELSE (CASE WHEN B.CATEGORY_ID=''MEMO'' THEN NULL ELSE 0 END) END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY  ' + char(10)
					SELECT @v_dSql += N'		        , NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR  ' + char(10)
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- Day bucket
				SET @mst_loop_cnt = 0	

				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = ''
					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END

					--SELECT @v_dSql += N'		        , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @sub_param_0 + ''' THEN (CASE	WHEN B.CATEGORY_ID=''P_IN'' AND A.PLAN_TYPE=''DPP'' THEN A.IN_QTY         ' + char(10)
					SELECT @v_dSql += N'		        , SUM(CASE WHEN C.YYYYMMDD = ''' + @sub_param_0 + ''' THEN (CASE	WHEN B.CATEGORY_ID=''P_IN'' AND A.PLAN_TYPE=''DPP'' THEN A.IN_QTY         ' + char(10)
					SELECT @v_dSql += N'																										WHEN B.CATEGORY_ID=''P_OUT'' AND A.PLAN_TYPE=''DPP'' THEN A.OUT_QTY   ' + char(10)
					SELECT @v_dSql += N'																										WHEN B.CATEGORY_ID=''W_IN'' AND A.PLAN_TYPE=''WPP'' THEN A.IN_QTY     ' + char(10)
					SELECT @v_dSql += N'																										WHEN B.CATEGORY_ID=''W_OUT'' AND A.PLAN_TYPE=''WPP'' THEN A.OUT_QTY   ' + char(10)
					SELECT @v_dSql += N'																										WHEN B.CATEGORY_ID=''M_IN'' AND A.PLAN_TYPE=''MPP'' THEN A.IN_QTY     ' + char(10)
					SELECT @v_dSql += N'																										WHEN B.CATEGORY_ID=''M_OUT'' AND A.PLAN_TYPE=''MPP'' THEN A.OUT_QTY   ' + char(10)
					SELECT @v_dSql += N'																										WHEN B.CATEGORY_ID=''RESULT'' AND A.PLAN_TYPE=''RESULT'' THEN A.RESULT_QTY               ' + char(10)
					SELECT @v_dSql += N'																										WHEN B.CATEGORY_ID=''RESULT_EXP'' THEN A.RESULT_QTY2 ' + char(10) -- Result(+Exp.)
					SELECT @v_dSql += N'																										WHEN B.CATEGORY_ID=''OFFTIME'' AND A.PLAN_TYPE=''OFFTIME'' THEN A.OFF_TIME  ' + char(10)
					SELECT @v_dSql += N'																										WHEN B.CATEGORY_ID=''MEMO'' THEN NULL   ' + char(10)
					SELECT @v_dSql += N'																										ELSE 0 END) ELSE (CASE WHEN B.CATEGORY_ID=''MEMO'' THEN NULL ELSE 0 END) END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY  ' + char(10)
					SELECT @v_dSql += N'		        , NULL AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR  ' + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql += N'		        			 , B.CATEGORY_ID, B.CATEGORY_ORDER               ' + char(10)
		SELECT @v_dSql += N'		               , ''DATA'' AS DATA_TYPE            ' + char(10)
		SELECT @v_dSql += N'		          FROM (                 ' + char(10)
		SELECT @v_dSql += N'		              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'		                   , A.LOCATION, A.OPERATION_ID, ISNULL(D.OPERATION_NAME,''-'') AS OPERATION_NAME              ' + char(10)
		SELECT @v_dSql += N'		                   , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE    ' + char(10)
		SELECT @v_dSql += N'		                   , A.EQUIPMENT_ID               ' + char(10)
		SELECT @v_dSql += N'		                   , A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'		                   , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME, ISNULL(B.PJT_GROUP_NAME,''-'') AS PJT_GROUP_NAME     ' + char(10)
		SELECT @v_dSql += N'		                   , A.PRODUCTION_TYPE            ' + char(10)
		SELECT @v_dSql += N'		                   , A.MARKET    ' + char(10)
		SELECT @v_dSql += N'		                   , B.ITEM_TYPE ' + char(10)
		SELECT @v_dSql += N'		                   , A.PLAN_TYPE ' + char(10)
		SELECT @v_dSql += N'		                   , A.SEQ       ' + char(10)
		SELECT @v_dSql += N'		                   , A.IN_QTY    ' + char(10)
		SELECT @v_dSql += N'		                   , A.OUT_QTY   ' + char(10)
		SELECT @v_dSql += N'		                   , A.RESULT_QTY                 ' + char(10)
		SELECT @v_dSql += N'		                   , A.OFF_TIME  ' + char(10)
		SELECT @v_dSql += N'		                   , A.RESULT_QTY2  ' + char(10) -- Result(+Exp.)
		SELECT @v_dSql += N'				           FROM (        ' + char(10)
		SELECT @v_dSql += N'			                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID            ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.LOCATION, A.OPERATION_ID      ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE   ' + char(10)
		SELECT @v_dSql += N'			      		                   , '''' AS EQUIPMENT_ID            ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.PLAN_DATE  ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME      ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE          ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.MARKET     ' + char(10)
		SELECT @v_dSql += N'			      		                   , CASE WHEN A.PLAN_TYPE = ''RELEASE'' THEN ''DPP'' ELSE A.PLAN_TYPE END AS PLAN_TYPE         ' + char(10)
		SELECT @v_dSql += N'			      		                   , '''' SEQ     ' + char(10)
		SELECT @v_dSql += N'			                               , CASE WHEN A.PLAN_TYPE = ''WPP'' THEN A.PLAN_IN_QTY ELSE A.PLAN_IN_QTY END  AS IN_QTY       ' + char(10)
		SELECT @v_dSql += N'			                               , CASE WHEN A.PLAN_TYPE = ''WPP'' THEN A.PLAN_QTY ELSE A.PLAN_QTY END  AS OUT_QTY            ' + char(10)
		SELECT @v_dSql += N'			                               , 0 RESULT_QTY ' + char(10)
		SELECT @v_dSql += N'			                               , 0 AS OFF_TIME                   ' + char(10)
		SELECT @v_dSql += N'			                               , 0 AS RESULT_QTY2 ' + char(10) -- Result(+Exp.)
		SELECT @v_dSql += N'			                        FROM #FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)           ' + char(10)
		SELECT @v_dSql += N'			                        WHERE  1=1          ' + char(10)
		--SELECT @v_dSql += N'			                        AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''    ' + char(10)
		SELECT @v_dSql += N'			                        AND     A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''' + '' 00:00:00.000'', 121) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'', 121) ' + char(10)
		SELECT @v_dSql += N'			                        AND 	A.PLAN_TYPE IN ( ''RELEASE'', ''MPP'', ''WPP'' )  ' + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		--SELECT @v_dSql += N'						              AND 	  ( A.PLAN_QTY + A.PLAN_IN_QTY ) > 0              ' + char(10)
		SELECT @v_dSql += N'						            UNION ALL             ' + char(10)
		SELECT @v_dSql += N'			                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID            ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.LOCATION, A.OPERATION_ID      ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE   ' + char(10)
		SELECT @v_dSql += N'			      		                   , '''' AS EQUIPMENT_ID            ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.PLAN_DATE  ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME      ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE          ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.MARKET     ' + char(10)
		SELECT @v_dSql += N'			      		                   , ''RESULT'' AS PLAN_TYPE         ' + char(10)
		SELECT @v_dSql += N'		  	      		                 , '''' SEQ       ' + char(10)
		SELECT @v_dSql += N'		  	      		                 , 0 AS IN_QTY    ' + char(10)
		SELECT @v_dSql += N'		  	      		                 , 0 AS OUT_QTY   ' + char(10)
		SELECT @v_dSql += N'		  	                             , A.ACTUAL_GOOD_QTY AS RESULT_QTY   ' + char(10) -- result
		SELECT @v_dSql += N'		  	                             , 0 AS OFF_TIME  ' + char(10)
		SELECT @v_dSql += N'		  	                             , A.ACTUAL_GOOD_QTY AS RESULT_QTY2 ' + char(10) -- Result(+Exp.)
		SELECT @v_dSql += N'			                        FROM #SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)            ' + char(10)
		SELECT @v_dSql += N'			      		            WHERE  1=1          ' + char(10)
		--SELECT @v_dSql += N'			                        AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''    ' + char(10)
		SELECT @v_dSql += N'			                        AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''' + '' 00:00:00.000'', 121) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'', 121) ' + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		--SELECT @v_dSql += N'						              AND 		A.ACTUAL_GOOD_QTY > 0        ' + char(10)
																-- 미래 실적 : 계획수량
		SELECT @v_dSql += N'			      		            UNION ALL ' + char(10)
		SELECT @v_dSql += N'			      		            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'			      		                   , '''' AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.MARKET ' + char(10)
		SELECT @v_dSql += N'			      		                   , ''RESULT_EXP'' AS PLAN_TYPE ' + char(10) -- Result(+Exp.)
		SELECT @v_dSql += N'		  	      		                 , '''' SEQ ' + char(10)
		SELECT @v_dSql += N'		  	      		                 , 0 AS IN_QTY ' + char(10)
		SELECT @v_dSql += N'		  	      		                 , 0 AS OUT_QTY ' + char(10)
		SELECT @v_dSql += N'		  	                             , 0 AS RESULT_QTY ' + char(10)
		SELECT @v_dSql += N'		  	                             , 0 AS OFF_TIME ' + char(10)
		SELECT @v_dSql += N'		  	                             , A.PLAN_QTY AS RESULT_QTY2 ' + char(10) -- Result(+Exp.)
		SELECT @v_dSql += N'			      		            FROM   #FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			      		            WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'			      		            AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_curr_date_gap + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		SELECT @v_dSql += N'			      		            AND    A.PLAN_TYPE = ''RELEASE'' ' + char(10)
		--SELECT @v_dSql += N'			                        ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		--SELECT @v_dSql += N'			                        ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += N'			                        ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		--SELECT @v_dSql += N'			                        ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		--SELECT @v_dSql += N'			                        ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		--SELECT @v_dSql += N'			                        ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		--SELECT @v_dSql += N'			                        ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		--SELECT @v_dSql += N'			                        ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		--SELECT @v_dSql += N'			                        ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		--SELECT @v_dSql += N'			      		            AND    ( A.PLAN_QTY + A.PLAN_IN_QTY ) > 0 ' + char(10)
		SELECT @v_dSql += N'						              UNION ALL           ' + char(10)
		SELECT @v_dSql += N'						              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID          ' + char(10)
		SELECT @v_dSql += N'				      		                   , A.LOCATION, A.OPERATION_ID  ' + char(10)
		SELECT @v_dSql += N'				      		                   , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE     ' + char(10)
		SELECT @v_dSql += N'				      		                   , A.EQUIPMENT_ID              ' + char(10)
		SELECT @v_dSql += N'				      		                   , B.OFF_DATE AS PLAN_DATE     ' + char(10)
		SELECT @v_dSql += N'				      		                   , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME  ' + char(10)
		SELECT @v_dSql += N'				      		                   , A.PRODUCTION_TYPE           ' + char(10)
		SELECT @v_dSql += N'				      		                   , A.MARKET ' + char(10)
		SELECT @v_dSql += N'				      		                   , ''OFFTIME'' AS PLAN_TYPE    ' + char(10)
		SELECT @v_dSql += N'				      		                   , '''' SEQ ' + char(10)
		SELECT @v_dSql += N'				      		                   , 0 AS IN_QTY                 ' + char(10)
		SELECT @v_dSql += N'		  	      		                 	   , 0 AS OUT_QTY                ' + char(10)
		SELECT @v_dSql += N'		  	      		                       , 0 AS RESULT_QTY             ' + char(10)
		SELECT @v_dSql += N'		  	                             	   , B.OFF_TIME AS OFF_TIME      ' + char(10)
		SELECT @v_dSql += N'		  	      		                       , 0 AS RESULT_QTY2 ' + char(10) -- Result(+Exp.)
		SELECT @v_dSql += N'				                          FROM (          ' + char(10)
		SELECT @v_dSql += N'				                                  	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET	' + char(10)
		SELECT @v_dSql += N'      												FROM (                   ' + char(10)
		SELECT @v_dSql += N'						                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE             ' + char(10)
		SELECT @v_dSql += N'		                                                       		, '''' AS EQUIPMENT_ID    ' + char(10)
		SELECT @v_dSql += N'		                                                       		, A.TOP_ITEM_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET   ' + char(10)
		SELECT @v_dSql += N'						                                      FROM #FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)          ' + char(10)
		SELECT @v_dSql += N'						                                      WHERE  1=1     ' + char(10)
		--SELECT @v_dSql += N'										                      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''       ' + char(10)
		SELECT @v_dSql += N'										                      AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''' + '' 00:00:00.000'', 121) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'', 121) ' + char(10)
		SELECT @v_dSql += N'										                      AND    A.PLAN_TYPE IN ( ''RELEASE'', ''WPP'', ''MPP'' )  ' + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		--SELECT @v_dSql += N'												               AND   (A.PLAN_IN_QTY + A.PLAN_QTY) > 0                  ' + char(10)
		SELECT @v_dSql += N'												              UNION ALL      ' + char(10)
		SELECT @v_dSql += N'						                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE             ' + char(10)
		SELECT @v_dSql += N'		                                                       		, '''' AS EQUIPMENT_ID    ' + char(10)
		SELECT @v_dSql += N'		                                                       		, A.TOP_ITEM_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET   ' + char(10)
		SELECT @v_dSql += N'						                                      FROM #SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)           ' + char(10)
		SELECT @v_dSql += N'						                                      WHERE  1=1     ' + char(10)
		--SELECT @v_dSql += N'										                      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''       ' + char(10)
		SELECT @v_dSql += N'										                      AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''' + '' 00:00:00.000'', 121) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'', 121) ' + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		--SELECT @v_dSql += N'												              AND 	(A.ACTUAL_GOOD_QTY) > 0   ' + char(10)
		SELECT @v_dSql += N'										          ) A     ' + char(10)
		SELECT @v_dSql += N'											      WHERE 1=1                  ' + char(10)
		SELECT @v_dSql += N'											      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET	' + char(10)
		SELECT @v_dSql += N'					                          ) A         ' + char(10)
		SELECT @v_dSql += N'					                          LEFT OUTER JOIN                ' + char(10)
		SELECT @v_dSql += N'					                          (           ' + char(10)
		SELECT @v_dSql += N'				                                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE     ' + char(10)
		SELECT @v_dSql += N'				                                            , CONVERT(VARCHAR, A.OFF_DATE, 112) AS OFF_DATE, A.OFF_TIME_TERM AS OFF_TIME            ' + char(10)
		SELECT @v_dSql += N'				                                      FROM   SCM_OFF_CALENDAR_LINE_V A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'				                                      INNER JOIN SCM_LINE_M B WITH(NOLOCK)    ' + char(10)
		SELECT @v_dSql += N'				                                      ON     A.COMPANY_ID     = B.COMPANY_ID  ' + char(10)
		SELECT @v_dSql += N'				                                      AND    A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'				                                      AND    A.SITE_ID        = B.SITE_ID     ' + char(10)
		SELECT @v_dSql += N'				                                      AND    A.PLANT_ID       = B.PLANT_ID    ' + char(10)
		SELECT @v_dSql += N'				                                      AND    A.FACTORY_ID     = B.FACTORY_ID  ' + char(10)
		SELECT @v_dSql += N'				                                      AND    A.OPERATION_ID   = B.OPERATION_ID      ' + char(10)
		SELECT @v_dSql += N'				                                      AND    A.LINE_ID        = B.LINE_ID     ' + char(10)
		SELECT @v_dSql += N'				                                      AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE    ' + char(10)
		SELECT @v_dSql += N'				                                      WHERE  B.ACTIVE_FLAG    = ''Y''         ' + char(10)
		--SELECT @v_dSql += N'				                                      AND    CONVERT(VARCHAR, A.OFF_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''    ' + char(10)
		SELECT @v_dSql += N'				                                      AND    A.OFF_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''' + '' 00:00:00.000'', 121) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'', 121) ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'					                          ) B         ' + char(10)
		SELECT @v_dSql += N'					                          ON    A.COMPANY_ID     = B.COMPANY_ID           ' + char(10)
		SELECT @v_dSql += N'					                          AND   A.DIVISION_ID    = B.DIVISION_ID          ' + char(10)
		SELECT @v_dSql += N'					                          AND   A.SITE_ID        = B.SITE_ID              ' + char(10)
		SELECT @v_dSql += N'					                          AND   A.PLANT_ID       = B.PLANT_ID             ' + char(10)
		SELECT @v_dSql += N'					                          AND   A.FACTORY_ID     = B.FACTORY_ID           ' + char(10)
		SELECT @v_dSql += N'					                          AND   A.OPERATION_ID   = B.OPERATION_ID         ' + char(10)
		SELECT @v_dSql += N'					                          AND   A.LINE_ID        = B.LINE_ID              ' + char(10)
		SELECT @v_dSql += N'					                          AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE       ' + char(10)
		SELECT @v_dSql += N'					      ) A            ' + char(10)
		SELECT @v_dSql += N'					      INNER JOIN (   ' + char(10)
		SELECT @v_dSql += N'			                          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)
		SELECT @v_dSql += N'			                                 A.ITEM_ID,   ' + char(10)
		SELECT @v_dSql += N'			                                 (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
		SELECT @v_dSql += N'			                                 	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')              ' + char(10)
		SELECT @v_dSql += N'			                                 	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,   ' + char(10)
		SELECT @v_dSql += N'			                                 ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME      ' + char(10)
		SELECT @v_dSql += N'			                          FROM	 SCM_ITEM_M A WITH(NOLOCK),      ' + char(10)
		SELECT @v_dSql += N'			                            		 SCM_ITEM_CLASS_M C WITH(NOLOCK)              ' + char(10)
		SELECT @v_dSql += N'			                          WHERE	 A.ITEM_CLASS  = C.CLASS_ID      ' + char(10)
		SELECT @v_dSql += N'			                          AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'			                          AND    C.USE_FLAG    = ''Y'' ' + char(10)
		SELECT @v_dSql += N'			                          ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
		SELECT @v_dSql += N'			                          ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_pjt_group_name)) + char(10)
		SELECT @v_dSql += N'                    	  ) B            ' + char(10)
		SELECT @v_dSql += N'                    	  ON     A.COMPANY_ID     = B.COMPANY_ID             ' + char(10)
		SELECT @v_dSql += N'			              AND    A.DIVISION_ID    = B.DIVISION_ID            ' + char(10)
		SELECT @v_dSql += N'			              AND    A.SITE_ID        = B.SITE_ID                ' + char(10)
		SELECT @v_dSql += N'			              AND    A.TOP_ITEM_ID    = B.ITEM_ID                ' + char(10)
		SELECT @v_dSql += N'			              INNER JOIN SCM_LINE_M C WITH(NOLOCK)               ' + char(10)
		SELECT @v_dSql += N'			              ON     A.COMPANY_ID     = C.COMPANY_ID             ' + char(10)
		SELECT @v_dSql += N'			              AND    A.DIVISION_ID    = C.DIVISION_ID            ' + char(10)
		SELECT @v_dSql += N'			              AND    A.SITE_ID        = C.SITE_ID                ' + char(10)
		SELECT @v_dSql += N'			              AND    A.PLANT_ID       = C.PLANT_ID               ' + char(10)
		SELECT @v_dSql += N'			              AND    A.FACTORY_ID     = C.FACTORY_ID             ' + char(10)
		SELECT @v_dSql += N'			              AND    A.OPERATION_ID   = C.OPERATION_ID           ' + char(10)
		SELECT @v_dSql += N'			              AND    A.LINE_ID        = C.LINE_ID                ' + char(10)
		SELECT @v_dSql += N'			              AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE         ' + char(10)
		SELECT @v_dSql += N'			              INNER JOIN SCM_OPERATION_M D WITH(NOLOCK)          ' + char(10)
		SELECT @v_dSql += N'                    	  ON     A.COMPANY_ID     = D.COMPANY_ID             ' + char(10)
		SELECT @v_dSql += N'			              AND    A.DIVISION_ID    = D.DIVISION_ID            ' + char(10)
		SELECT @v_dSql += N'			              AND    A.SITE_ID        = D.SITE_ID                ' + char(10)
		SELECT @v_dSql += N'			              AND    A.OPERATION_ID   = D.OPERATION_ID           ' + char(10)
		SELECT @v_dSql += N'			              WHERE 1=1      ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PJT_GROUP_NAME' , 'LIKE', @p_pjt_group_name)) + char(10)
		SELECT @v_dSql += N'		          ) A ' + char(10)
		SELECT @v_dSql += N'		          INNER JOIN (           ' + char(10)
		SELECT @v_dSql += N'		          		SELECT *         ' + char(10)
		SELECT @v_dSql += N'		          			FROM (       ' + char(10)

		DECLARE @bGap		NVARCHAR(1) = 'N';
		
		IF ISNULL(@p_cate_info,'') <> '' BEGIN

			SET @mst_loop_cnt	= 0 ;
			
			SELECT @v_dSql += N'	SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER              ' + char(10)

  			WHILE @mst_loop_cnt < @max_category_loop_cnt
				BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
				
					SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가
					SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info , @v_row_delimiter , @mst_loop_cnt );
				
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column , @sub_v_delimiter)

					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_ID')   END
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_VALUE')   END

					IF @sub_param_0 = 'chk_mpp_inqty' AND @sub_param_1 = 'true' BEGIN
						SELECT @v_dSql += N'		UNION ALL            ' + char(10)
						SELECT @v_dSql += N'		SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER          ' + char(10)
					END ELSE IF @sub_param_0 = 'chk_mpp_outqty' AND @sub_param_1 = 'true' BEGIN
						SELECT @v_dSql += N'		UNION ALL            ' + char(10)
						SELECT @v_dSql += N'		SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER        ' + char(10)
					END ELSE IF @sub_param_0 = 'chk_wpp_inqty' AND @sub_param_1 = 'true' BEGIN
						SELECT @v_dSql += N'		UNION ALL            ' + char(10)
						SELECT @v_dSql += N'		SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER          ' + char(10)
					END ELSE IF @sub_param_0 = 'chk_wpp_outqty' AND @sub_param_1 = 'true' BEGIN
						SELECT @v_dSql += N'		UNION ALL            ' + char(10)
						SELECT @v_dSql += N'		SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER        ' + char(10)
					END ELSE IF @sub_param_0 = 'chk_inqty' AND @sub_param_1 = 'true' BEGIN
						SELECT @v_dSql += N'		UNION ALL            ' + char(10)
						SELECT @v_dSql += N'		SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER         ' + char(10)
					END ELSE IF @sub_param_0 = 'chk_outqty' AND @sub_param_1 = 'true' BEGIN
						SELECT @v_dSql += N'		UNION ALL            ' + char(10)
						SELECT @v_dSql += N'		SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER       ' + char(10)
					END ELSE IF @sub_param_0 = 'chk_result' AND @sub_param_1 = 'true' BEGIN
						SELECT @v_dSql += N'		UNION ALL            ' + char(10)
						SELECT @v_dSql += N'		SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER         ' + char(10)
					-- Result(+Exp.)
					END ELSE IF @sub_param_0 = 'chk_resultExp' AND @sub_param_1 = 'true' BEGIN 
						SELECT @v_dSql += N'		UNION ALL            ' + char(10)
						SELECT @v_dSql += N'		SELECT ''RESULT_EXP'' AS CATEGORY_ID, ''Result(+Exp.)'' AS CATEGORY_NAME, 71 AS CATEGORY_ORDER         ' + char(10)
					END ELSE IF @sub_param_0 = 'chk_offtime' AND @sub_param_1 = 'true' BEGIN
						SELECT @v_dSql += N'		UNION ALL            ' + char(10)
						SELECT @v_dSql += N'		SELECT ''OFFTIME'' AS CATEGORY_ID, ''Off Cal.'' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER      ' + char(10)
					END ELSE IF @sub_param_0 = 'chk_memo' AND @sub_param_1 = 'true' BEGIN
						SELECT @v_dSql += N'		UNION ALL            ' + char(10)
						SELECT @v_dSql += N'		SELECT ''MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, 90 AS CATEGORY_ORDER ' + char(10)
					END ELSE IF @sub_param_0 = 'chk_gap' AND @sub_param_1 = 'true' BEGIN
						SET @bGap = 'Y'
					END
			
			END	-- END OF WHILE
			
		END ELSE BEGIN
			-- CATEGORY 정보 없는 경우임
			
			SELECT @v_dSql += N'	SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER				               ' + char(10)
			SELECT @v_dSql += N'	UNION ALL             ' + char(10)
			SELECT @v_dSql += N'	SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER         ' + char(10)
			SELECT @v_dSql += N'	UNION ALL             ' + char(10)
			SELECT @v_dSql += N'	SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER           ' + char(10)
			SELECT @v_dSql += N'	UNION ALL             ' + char(10)
			SELECT @v_dSql += N'	SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER         ' + char(10)
			SELECT @v_dSql += N'	UNION ALL             ' + char(10)
			SELECT @v_dSql += N'	SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER          ' + char(10)
			SELECT @v_dSql += N'	UNION ALL             ' + char(10)
			SELECT @v_dSql += N'	SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER        ' + char(10)
			SELECT @v_dSql += N'	UNION ALL             ' + char(10)
			SELECT @v_dSql += N'	SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER          ' + char(10)
			SELECT @v_dSql += N'	UNION ALL            ' + char(10)
			SELECT @v_dSql += N'	SELECT ''RESULT_EXP'' AS CATEGORY_ID, ''Result(+Exp.)'' AS CATEGORY_NAME, 71 AS CATEGORY_ORDER         ' + char(10)
			SELECT @v_dSql += N'	UNION ALL            ' + char(10)
			SELECT @v_dSql += N'	SELECT ''OFFTIME'' AS CATEGORY_ID, ''Off Cal.'' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER      ' + char(10)
			SELECT @v_dSql += N'	UNION ALL             ' + char(10)
			SELECT @v_dSql += N'	SELECT ''MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, 90 AS CATEGORY_ORDER  ' + char(10)
		END	

		SELECT @v_dSql += N'				          ) BB           ' + char(10)
		SELECT @v_dSql += N'                	WHERE CATEGORY_ID <> ''X''            ' + char(10)
		SELECT @v_dSql += N'                	  ' + char(10)
		SELECT @v_dSql += N'		          ) B ' + char(10)
		SELECT @v_dSql += N'		          ON 1=1                 ' + char(10)
		SELECT @v_dSql += N'		          INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)                  ' + char(10)
		SELECT @v_dSql += N'		          ON  A.PLAN_DATE = C.DT ' + char(10)
		SELECT @v_dSql += N'             	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID     ' + char(10)
		SELECT @v_dSql += N'                 , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME              ' + char(10)
		SELECT @v_dSql += N'                 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE                  ' + char(10)
		SELECT @v_dSql += N'                 , A.EQUIPMENT_ID        ' + char(10)
		SELECT @v_dSql += N'                 , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME   ' + char(10)
		SELECT @v_dSql += N'                 , A.PRODUCTION_TYPE, A.MARKET, A.ITEM_TYPE                  ' + char(10)
		SELECT @v_dSql += N'                 , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER          ' + char(10)
		SELECT @v_dSql += N'		    		) A                  ' + char(10)
		SELECT @v_dSql += N'		  		      ' + char(10)
		--SELECT @v_dSql += N'      )   ' + char(10)
		SELECT @v_dSql += N'      -- [C20200213-000397]FP 생산계획 대비 실적 차이수량 집계를 통한 Off-line 계획수립 업무 Zero화 ' + char(10)
		--SELECT @v_dSql += N'      , MAIN_GAP AS ( ' + char(10)
		SELECT @v_dSql += N'          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID             ' + char(10)
		SELECT @v_dSql += N'                , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME               ' + char(10)
		SELECT @v_dSql += N'                , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE                   ' + char(10)
		SELECT @v_dSql += N'                , A.EQUIPMENT_ID         ' + char(10)
		SELECT @v_dSql += N'                , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME    ' + char(10)
		SELECT @v_dSql += N'                , A.PRODUCTION_TYPE, A.MARKET             ' + char(10)
		SELECT @v_dSql += N'                , A.ITEM_TYPE            ' + char(10)
		SELECT @v_dSql += N'                , A.CATE                 ' + char(10)

		IF ISNULL(@p_day2_week_month_info,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				SET @p_temp = ''
				DECLARE @p_temp2 NVARCHAR(100) = '' --E20260421-000487

				WHILE @mst_loop_cnt < @max_day2_week_month_loop_cnt
				BEGIN
					
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = [dbo].[SCM_ARR_SPL_VAL]( @p_day2_week_month_info, @v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'D_COL')   END
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'M_COL')   END

					-- 주차변경 전 alias 를 넣어준다.
					IF @p_temp <> '' AND @p_temp <> @sub_param_1 BEGIN
						SELECT @v_dSql += ' , ' + @p_temp2 + ' AS ' + @p_temp + '_QTY ' + char(10) --E20260421-000487
						SELECT @v_dSql += ' , NULL AS ' + @p_temp + '_COLOR ' + char(10)
					END 

					/*
					-- 일자별 합계
					IF @p_temp <> @sub_param_1 BEGIN
					
						SELECT @v_dSql += ' , ' + @sub_param_0;

					END ELSE BEGIN
						SELECT @v_dSql += ' + ' + @sub_param_0;
					END
					*/

					-- 마지막 month 정보를 넣어준다.
					IF @mst_loop_cnt = @max_day2_week_month_loop_cnt BEGIN
						SELECT @v_dSql += ' , ' + @sub_param_0 + ' AS ' + @sub_param_1 + '_QTY ' + char(10) --E20260421-000487
						SELECT @v_dSql += ' , NULL AS ' + @sub_param_1 + '_COLOR ' + char(10)
					END 
					
					SET @p_temp = @sub_param_1; -- month 정보를 넣어준다.
					SET @p_temp2 = @sub_param_0;--E20260421-000487  
				
				END-- end of @mst_loop_cnt < @max_loop_cnt

				---- weekinfo
				SET @mst_loop_cnt = 0
				SET @p_temp = ''
				SET @p_temp2 = ''--E20260421-000487
				WHILE @mst_loop_cnt < @max_day2_week_month_loop_cnt
				BEGIN
					
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = [dbo].[SCM_ARR_SPL_VAL]( @p_day2_week_month_info, @v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'D_COL')   END
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'W_COL')   END

					-- 주차변경 전 alias 를 넣어준다.
					IF @p_temp <> '' AND @p_temp <> @sub_param_1 BEGIN
						SELECT @v_dSql += ' , ' + @p_temp2 + ' AS ' + @p_temp + '_QTY ' + char(10)--E20260421-000487
						SELECT @v_dSql += ' , NULL AS ' + @p_temp + '_COLOR ' + char(10)
					END 

					/*
					-- 일자별 합계
					IF @p_temp <> @sub_param_1 BEGIN
					
						SELECT @v_dSql += ' , ' + @sub_param_0;

					END ELSE BEGIN
						SELECT @v_dSql += ' + ' + @sub_param_0;
					END
					*/

					-- 마지막 month 정보를 넣어준다.
					IF @mst_loop_cnt = @max_day2_week_month_loop_cnt BEGIN
						SELECT @v_dSql += ' , ' + @sub_param_0 + ' AS ' + @sub_param_1 + '_QTY ' + char(10)--E20260421-000487
						SELECT @v_dSql += ' , NULL AS ' + @sub_param_1 + '_COLOR ' + char(10)
					END 
					
					SET @p_temp = @sub_param_1; -- month 정보를 넣어준다.
					SET @p_temp2 = @sub_param_0;  --E20260421-000487
				
				END-- end of @mst_loop_cnt < @max_loop_cnt


			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					
					SELECT @v_dSql += '               , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ' AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'                , A.CATEGORY_ID, A.CATEGORY_ORDER         ' + char(10)
		SELECT @v_dSql += N'                , A.DATA_TYPE            ' + char(10)
		SELECT @v_dSql += N'          INTO #TEMP_TABLE_MAIN_GAP ' + char(10)
		SELECT @v_dSql += N'          FROM (      ' + char(10)
		SELECT @v_dSql += N'                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID     ' + char(10)
		SELECT @v_dSql += N'                        , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME       ' + char(10)
		SELECT @v_dSql += N'                        , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE           ' + char(10)
		SELECT @v_dSql += N'                        , A.EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'                        , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME             ' + char(10)
		SELECT @v_dSql += N'                        , A.PRODUCTION_TYPE, A.MARKET     ' + char(10)
		SELECT @v_dSql += N'                        , A.ITEM_TYPE    ' + char(10)
		SELECT @v_dSql += N'                        , A.CATE         ' + char(10)

		DECLARE @p_curr_date NVARCHAR(10) = ''

		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- bucket
				SET @mst_loop_cnt = 0

				IF @p_curr_date_col = '' BEGIN
					
					WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						SELECT @v_dSql += '               , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ' AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END -- end of @mst_loop_cnt < @max_loop_cnt

				END ELSE BEGIN	--@p_curr_date_col
					
					
					SET @tmp_column = [dbo].[SCM_ARR_SPL_VAL]( @p_curr_date_col, @sub_v_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_curr_date_col, @sub_v_delimiter)
					IF @sub_max_loop_cnt > 0 BEGIN   SET @p_curr_date =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @p_curr_date_col , @sub_max_loop_cnt, @sub_v_delimiter , 'CURR_DATE')   END

					exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@p_curr_date,'@p_curr_date',@runstart, @runend

					WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						
						SET @tmp_column = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket, @v_row_delimiter, @mst_loop_cnt)
						SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					
						IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , '_DATE')   END
						
						IF @p_curr_date > @sub_param_0 BEGIN
							SELECT @v_dSql += '               , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ' AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						END ELSE BEGIN
							SELECT @v_dSql += '               , 0 AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						END

						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END -- end of @mst_loop_cnt < @max_loop_cnt

				END -- @p_curr_date_col

			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'                        , A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'                        , A.DATA_TYPE    ' + char(10)
		SELECT @v_dSql += N'            			FROM (           ' + char(10)
		SELECT @v_dSql += N'                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'                            , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME   ' + char(10)
		SELECT @v_dSql += N'                            , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE       ' + char(10)
		SELECT @v_dSql += N'                            , A.EQUIPMENT_ID              ' + char(10)
		SELECT @v_dSql += N'                            , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME         ' + char(10)
		SELECT @v_dSql += N'                            , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
		SELECT @v_dSql += N'                            , A.ITEM_TYPE                 ' + char(10)
		SELECT @v_dSql += N'                            , B.CATEGORY_NAME AS CATE     ' + char(10)

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
					
					SELECT @v_dSql += N'	  			, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''' + @sub_param_0 + ''' AND A.PLAN_DATE >= D.INSTANCE_DATE THEN A.GAP_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)

				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'                            , B.CATEGORY_ID, B.CATEGORY_ORDER                ' + char(10)
		SELECT @v_dSql += N'                            , ''DATA'' AS DATA_TYPE       ' + char(10)
		SELECT @v_dSql += N'                      FROM (             ' + char(10)
		SELECT @v_dSql += N'                            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'                                  , A.LOCATION, A.OPERATION_ID, ISNULL(D.OPERATION_NAME,''-'') AS OPERATION_NAME       ' + char(10)
		SELECT @v_dSql += N'                                  , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE                ' + char(10)
		SELECT @v_dSql += N'                                  , A.EQUIPMENT_ID        ' + char(10)
		SELECT @v_dSql += N'                                  , A.PLAN_DATE           ' + char(10)
		SELECT @v_dSql += N'                                  , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME, ISNULL(B.PJT_GROUP_NAME,''-'') AS PJT_GROUP_NAME                 ' + char(10)
		SELECT @v_dSql += N'                                  , A.PRODUCTION_TYPE     ' + char(10)
		SELECT @v_dSql += N'                                  , A.MARKET              ' + char(10)
		SELECT @v_dSql += N'                                  , B.ITEM_TYPE           ' + char(10)
		SELECT @v_dSql += N'                                  , A.PLAN_TYPE           ' + char(10)
		SELECT @v_dSql += N'                                  , A.GAP_QTY             ' + char(10)
		SELECT @v_dSql += N'                            FROM (       ' + char(10)
		SELECT @v_dSql += N'                                -- 생산실적 차질분 계산   ' + char(10)
		SELECT @v_dSql += N'                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                ' + char(10)
		SELECT @v_dSql += N'                                      , A.LOCATION, A.OPERATION_ID           ' + char(10)
		SELECT @v_dSql += N'                                      , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE              ' + char(10)
		SELECT @v_dSql += N'                                      , A.EQUIPMENT_ID    ' + char(10)
		SELECT @v_dSql += N'                                      , A.PLAN_DATE       ' + char(10)
		SELECT @v_dSql += N'                                      , A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME                 ' + char(10)
		SELECT @v_dSql += N'                                      , A.PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'                                      , A.MARKET          ' + char(10)
		SELECT @v_dSql += N'                                      , A.PLAN_TYPE       ' + char(10)
		SELECT @v_dSql += N'                                      , SUM(ISNULL(A.RESULT_QTY,0)) - SUM(ISNULL(A.OUT_QTY,0)) AS GAP_QTY              ' + char(10)
		SELECT @v_dSql += N'                                FROM (   ' + char(10)
		SELECT @v_dSql += N'                                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID            ' + char(10)
		SELECT @v_dSql += N'                                          , A.LOCATION, A.OPERATION_ID       ' + char(10)
		SELECT @v_dSql += N'                                          , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE    ' + char(10)
		SELECT @v_dSql += N'                                          , '''' AS EQUIPMENT_ID             ' + char(10)
		SELECT @v_dSql += N'                                          , A.PLAN_DATE   ' + char(10)
		SELECT @v_dSql += N'                                          , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME       ' + char(10)
		SELECT @v_dSql += N'                                          , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE           ' + char(10)
		SELECT @v_dSql += N'                                          , A.MARKET      ' + char(10)
		SELECT @v_dSql += N'                                          , ''DPP'' AS PLAN_TYPE             ' + char(10)
		SELECT @v_dSql += N'                                          , A.PLAN_QTY AS OUT_QTY            ' + char(10)
		SELECT @v_dSql += N'                                          , 0 AS RESULT_QTY                  ' + char(10)
		SELECT @v_dSql += N'                                    FROM  #FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)          ' + char(10)
		SELECT @v_dSql += N'                                    WHERE  1=1            ' + char(10)
		--SELECT @v_dSql += N'                                    AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''    ' + char(10)
		SELECT @v_dSql += N'			                        AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''' + '' 00:00:00.000'', 121) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'', 121) ' + char(10)
		SELECT @v_dSql += N'                                    AND    A.PLAN_TYPE = ''RELEASE''         ' + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		--SELECT @v_dSql += N'                                    AND 	  A.PLAN_QTY > 0                 ' + char(10)
		SELECT @v_dSql += N'                                    UNION ALL             ' + char(10)
		SELECT @v_dSql += N'                                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID            ' + char(10)
		SELECT @v_dSql += N'                                          , A.LOCATION, A.OPERATION_ID       ' + char(10)
		SELECT @v_dSql += N'                                          , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE    ' + char(10)
		SELECT @v_dSql += N'                                          , '''' AS EQUIPMENT_ID             ' + char(10)
		SELECT @v_dSql += N'                                          , A.PLAN_DATE   ' + char(10)
		SELECT @v_dSql += N'                                          , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME       ' + char(10)
		SELECT @v_dSql += N'                                          , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE           ' + char(10)
		SELECT @v_dSql += N'                                          , A.MARKET      ' + char(10)
		SELECT @v_dSql += N'                                          , ''RESULT'' AS PLAN_TYPE          ' + char(10)
		SELECT @v_dSql += N'                                          , 0 AS OUT_QTY  ' + char(10)
		SELECT @v_dSql += N'                                          , A.ACTUAL_GOOD_QTY AS RESULT_QTY  ' + char(10)
		SELECT @v_dSql += N'                                    FROM   #SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)          ' + char(10)
		SELECT @v_dSql += N'                                    WHERE  1=1            ' + char(10)
		--SELECT @v_dSql += N'                                    AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''    ' + char(10)
		SELECT @v_dSql += N'			                        AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''' + '' 00:00:00.000'', 121) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'', 121) ' + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		--SELECT @v_dSql += N'                                    AND 		A.ACTUAL_GOOD_QTY > 0        ' + char(10)
		SELECT @v_dSql += N'            										) A   ' + char(10)
		SELECT @v_dSql += N'            										-- 확정시점 가져오기     ' + char(10)

		IF @p_confirm_area = 'BUILDING' BEGIN
			SELECT @v_dSql += N'			                        INNER JOIN (                ' + char(10)
			SELECT @v_dSql += N'			                                    								SELECT A.FACTORY_ID, CONVERT(DATETIME,A.INSTANCE_DATE) AS INSTANCE_DATE    ' + char(10)
			SELECT @v_dSql += N'			                                    								FROM (         ' + char(10)
			SELECT @v_dSql += N'			                                    									SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME                           ' + char(10)
			SELECT @v_dSql += N'			                                    										 , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM                     ' + char(10)
			SELECT @v_dSql += N'			                                    									FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                           ' + char(10)
			SELECT @v_dSql += N'			                                    									WHERE  1=1                   ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'			                                    									AND    A.FACTORY_ID IN (                                               ' + char(10)
			SELECT @v_dSql += N'			                                      										SELECT DISTINCT B.FACTORY_ID                                   ' + char(10)
			SELECT @v_dSql += N'			                                      										FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                    ' + char(10)
			SELECT @v_dSql += N'			                                      										INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)                        ' + char(10)
			SELECT @v_dSql += N'			                                      										ON    A.FACTORY_ID  = B.FACTORY_ID                             ' + char(10)
			SELECT @v_dSql += N'			                                      										AND   A.ACTIVE_FLAG = ''Y''                                    ' + char(10)
			SELECT @v_dSql += N'			                                      										AND   B.ACTIVE_FLAG = ''Y''                                    ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'			                                    									)          ' + char(10)
			SELECT @v_dSql += N'			                                    								) A            ' + char(10)
			SELECT @v_dSql += N'			                                    								WHERE A.ROW_NUM = 1                                                        ' + char(10)
			SELECT @v_dSql += N'			                                    							) B                ' + char(10)
			SELECT @v_dSql += N'			                                    							ON    A.FACTORY_ID = B.FACTORY_ID                                              ' + char(10)
			SELECT @v_dSql += N'			                                    							WHERE A.PLAN_DATE >= B.INSTANCE_DATE                                           ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql += N'			                      -- plan group 단위          ' + char(10)
			SELECT @v_dSql += N'			                        INNER JOIN SCM_LINE_M C WITH(NOLOCK)                     ' + char(10)
			SELECT @v_dSql += N'			                                                  ON  A.COMPANY_ID     = C.COMPANY_ID                                                        ' + char(10)
			SELECT @v_dSql += N'			                                                  AND A.DIVISION_ID    = C.DIVISION_ID                                                       ' + char(10)
			SELECT @v_dSql += N'			                                                  AND A.SITE_ID        = C.SITE_ID                                                           ' + char(10)
			SELECT @v_dSql += N'			                                                  AND A.PLANT_ID       = C.PLANT_ID                                                          ' + char(10)
			SELECT @v_dSql += N'			                                                  AND A.FACTORY_ID     = C.FACTORY_ID                                                        ' + char(10)
			SELECT @v_dSql += N'			                                                  AND A.OPERATION_ID   = C.OPERATION_ID                                                      ' + char(10)
			SELECT @v_dSql += N'			                                                  AND A.LINE_ID        = C.LINE_ID                                                           ' + char(10)
			SELECT @v_dSql += N'			                                                  AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE                                                    ' + char(10)
			SELECT @v_dSql += N'			                                                  INNER JOIN (                   ' + char(10)
			SELECT @v_dSql += N'			                                                  	SELECT A.PLAN_GROUP_ID, A.INSTANCE_DATE                                                ' + char(10)
			SELECT @v_dSql += N'			                                                  	FROM (                     ' + char(10)
			SELECT @v_dSql += N'			                                                  		SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.PLAN_GROUP_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME       ' + char(10)
			SELECT @v_dSql += N'			                                                  			 , ROW_NUMBER() OVER (PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM ' + char(10)
			SELECT @v_dSql += N'			                                                  		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                                       ' + char(10)
			SELECT @v_dSql += N'		                                                  		WHERE  1=1                                   ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'		                                                  		AND    A.PLAN_GROUP_ID IN (' + char(10)
			SELECT @v_dSql += N'		                                                  				SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID                                    ' + char(10)
			SELECT @v_dSql += N'		                                                  				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                     ' + char(10)
			SELECT @v_dSql += N'		                                                  				WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''                        ' + char(10)
			SELECT @v_dSql += N'		                                                  				AND    A.ACTIVE_FLAG = ''Y''                                                   ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'		                                                  		)                          ' + char(10)
			SELECT @v_dSql += N'		                                                  	) A                            ' + char(10)
			SELECT @v_dSql += N'		                                                  	WHERE A.ROW_NUM = 1            ' + char(10)
			SELECT @v_dSql += N'		                                                  ) B   ' + char(10)
			SELECT @v_dSql += N'		                                                  ON    C.MODEL_TYPE = B.PLAN_GROUP_ID                                                           ' + char(10)
			SELECT @v_dSql += N'		                                                  WHERE A.PLAN_DATE >= B.INSTANCE_DATE                                                           ' + char(10)
		END

		SELECT @v_dSql += N'      			                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID          ' + char(10)
		SELECT @v_dSql += N'                                       , A.LOCATION, A.OPERATION_ID          ' + char(10)
		SELECT @v_dSql += N'                                       , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID   ' + char(10)
		SELECT @v_dSql += N'                                       , A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME   ' + char(10)
		SELECT @v_dSql += N'                                       , A.PRODUCTION_TYPE, A.MARKET, A.PLAN_TYPE             ' + char(10)
		SELECT @v_dSql += N'      			                ) A      ' + char(10)
		SELECT @v_dSql += N'                            INNER JOIN ( ' + char(10)
		SELECT @v_dSql += N'                              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID     ' + char(10)
		SELECT @v_dSql += N'                                   , (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME         ' + char(10)
		SELECT @v_dSql += N'                                           WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')       ' + char(10)
		SELECT @v_dSql += N'                                           ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE              ' + char(10)
		SELECT @v_dSql += N'                                   , ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME  ' + char(10)
		SELECT @v_dSql += N'                              FROM	 SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK)     ' + char(10)
		SELECT @v_dSql += N'                              WHERE	 A.ITEM_CLASS  = C.CLASS_ID              ' + char(10)
		SELECT @v_dSql += N'                              AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'                              AND    C.USE_FLAG    = ''Y'' ' + char(10)
		SELECT @v_dSql += N'                              ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
		SELECT @v_dSql += N'                              ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_pjt_group_name)) + char(10)
		SELECT @v_dSql += N'                            ) B          ' + char(10)
		SELECT @v_dSql += N'                            ON     A.COMPANY_ID     = B.COMPANY_ID           ' + char(10)
		SELECT @v_dSql += N'                            AND    A.DIVISION_ID    = B.DIVISION_ID          ' + char(10)
		SELECT @v_dSql += N'                            AND    A.SITE_ID        = B.SITE_ID              ' + char(10)
		SELECT @v_dSql += N'                            AND    A.TOP_ITEM_ID    = B.ITEM_ID              ' + char(10)
		SELECT @v_dSql += N'                            INNER JOIN SCM_LINE_M C WITH(NOLOCK)             ' + char(10)
		SELECT @v_dSql += N'                            ON     A.COMPANY_ID     = C.COMPANY_ID           ' + char(10)
		SELECT @v_dSql += N'                            AND    A.DIVISION_ID    = C.DIVISION_ID          ' + char(10)
		SELECT @v_dSql += N'                            AND    A.SITE_ID        = C.SITE_ID              ' + char(10)
		SELECT @v_dSql += N'                            AND    A.PLANT_ID       = C.PLANT_ID             ' + char(10)
		SELECT @v_dSql += N'                            AND    A.FACTORY_ID     = C.FACTORY_ID           ' + char(10)
		SELECT @v_dSql += N'                            AND    A.OPERATION_ID   = C.OPERATION_ID         ' + char(10)
		SELECT @v_dSql += N'                            AND    A.LINE_ID        = C.LINE_ID              ' + char(10)
		SELECT @v_dSql += N'                            AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE       ' + char(10)
		SELECT @v_dSql += N'                            INNER JOIN SCM_OPERATION_M D WITH(NOLOCK)        ' + char(10)
		SELECT @v_dSql += N'                            ON     A.COMPANY_ID     = D.COMPANY_ID           ' + char(10)
		SELECT @v_dSql += N'                            AND    A.DIVISION_ID    = D.DIVISION_ID          ' + char(10)
		SELECT @v_dSql += N'                            AND    A.SITE_ID        = D.SITE_ID              ' + char(10)
		SELECT @v_dSql += N'                            AND    A.OPERATION_ID   = D.OPERATION_ID         ' + char(10)
		SELECT @v_dSql += N'                            WHERE  1=1   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PJT_GROUP_NAME' , 'LIKE', @p_pjt_group_name)) + char(10)
		SELECT @v_dSql += N'                        ) A              ' + char(10)
		SELECT @v_dSql += N'                        INNER JOIN (     ' + char(10)
		SELECT @v_dSql += N'                            SELECT *     ' + char(10)
		SELECT @v_dSql += N'                            FROM (       ' + char(10)
		
		IF ISNULL(@p_cate_info,'') <> '' BEGIN

			SELECT @v_dSql += N'                                SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER                ' + char(10)
			IF @bGap = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''GAP'' AS CATEGORY_ID, ''Accu. Gap'' AS CATEGORY_NAME, 75 AS CATEGORY_ORDER   ' + char(10)
			END

		END ELSE BEGIN
			SELECT @v_dSql += N'	      SELECT ''GAP'' AS CATEGORY_ID, ''Accu. Gap'' AS CATEGORY_NAME, 75 AS CATEGORY_ORDER       ' + char(10)
		END

		SELECT @v_dSql += N'                            ) BB         ' + char(10)
		SELECT @v_dSql += N'                            WHERE CATEGORY_ID <> ''X''    ' + char(10)
		SELECT @v_dSql += N'                        ) B              ' + char(10)
		SELECT @v_dSql += N'                        ON 1=1           ' + char(10)
		SELECT @v_dSql += N'                        INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)            ' + char(10)
		SELECT @v_dSql += N'                        ON  A.PLAN_DATE = C.DT            ' + char(10)
		SELECT @v_dSql += N'                        -- 확정시점 가져오기              ' + char(10)

		IF @p_confirm_area = 'BUILDING' BEGIN
			SELECT @v_dSql += N'	                INNER JOIN (                                ' + char(10)
			SELECT @v_dSql += N'	                                        SELECT A.FACTORY_ID, A.INSTANCE_DATE             ' + char(10)
			SELECT @v_dSql += N'	                                        FROM (              ' + char(10)
			SELECT @v_dSql += N'	                                            SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME                    ' + char(10)
			SELECT @v_dSql += N'	                                            , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM                   ' + char(10)
			SELECT @v_dSql += N'	                                            FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'	                                            WHERE  1=1                                                     ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'	                                            AND    A.FACTORY_ID IN (                     ' + char(10)
			SELECT @v_dSql += N'	                                                SELECT DISTINCT B.FACTORY_ID             ' + char(10)
			SELECT @v_dSql += N'	                                                FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                                                          ' + char(10)
			SELECT @v_dSql += N'	                                                INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql += N'	                                                ON    A.FACTORY_ID  = B.FACTORY_ID       ' + char(10)
			SELECT @v_dSql += N'	                                                AND   A.ACTIVE_FLAG = ''Y''              ' + char(10)
			SELECT @v_dSql += N'	                                                AND   B.ACTIVE_FLAG = ''Y''              ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'	                                            )               ' + char(10)
			SELECT @v_dSql += N'	                                        ) A                 ' + char(10)
			SELECT @v_dSql += N'	                                        WHERE A.ROW_NUM = 1 ' + char(10)
			SELECT @v_dSql += N'	                                    ) D                     ' + char(10)
			SELECT @v_dSql += N'	                                    ON    A.FACTORY_ID = D.FACTORY_ID                    ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql += N'	                INNER JOIN SCM_LINE_M E WITH(NOLOCK)        ' + char(10)
			SELECT @v_dSql += N'	                                          ON  A.COMPANY_ID     = E.COMPANY_ID            ' + char(10)
			SELECT @v_dSql += N'	                                          AND A.DIVISION_ID    = E.DIVISION_ID           ' + char(10)
			SELECT @v_dSql += N'	                                          AND A.SITE_ID        = E.SITE_ID               ' + char(10)
			SELECT @v_dSql += N'	                                          AND A.PLANT_ID       = E.PLANT_ID              ' + char(10)
			SELECT @v_dSql += N'	                                          AND A.FACTORY_ID     = E.FACTORY_ID            ' + char(10)
			SELECT @v_dSql += N'	                                          AND A.OPERATION_ID   = E.OPERATION_ID          ' + char(10)
			SELECT @v_dSql += N'	                                          AND A.LINE_ID        = E.LINE_ID               ' + char(10)
			SELECT @v_dSql += N'	                                          AND A.ELECTRODE_TYPE = E.ELECTRODE_TYPE        ' + char(10)
			SELECT @v_dSql += N'	                                          INNER JOIN (      ' + char(10)
			SELECT @v_dSql += N'	                                          	SELECT A.PLAN_GROUP_ID, A.INSTANCE_DATE    ' + char(10)
			SELECT @v_dSql += N'	                                          	FROM (        ' + char(10)
			SELECT @v_dSql += N'	                                          		SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.PLAN_GROUP_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME           ' + char(10)
			SELECT @v_dSql += N'	                                          			 , ROW_NUMBER() OVER (PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM     ' + char(10)
			SELECT @v_dSql += N'	                                          		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                                                       ' + char(10)
			SELECT @v_dSql += N'	                                          		WHERE  1=1                                              ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'	                                          		AND    A.PLAN_GROUP_ID IN (            ' + char(10)
			SELECT @v_dSql += N'	                                          				SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID                                                ' + char(10)
			SELECT @v_dSql += N'	                                          				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                 ' + char(10)
			SELECT @v_dSql += N'	                                          				WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''                                    ' + char(10)
			SELECT @v_dSql += N'	                                          				AND    A.ACTIVE_FLAG = ''Y''   ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'	                                          		)         ' + char(10)
			SELECT @v_dSql += N'	                                          	) A           ' + char(10)
			SELECT @v_dSql += N'	                                          	WHERE A.ROW_NUM = 1                        ' + char(10)
			SELECT @v_dSql += N'	                                          ) D               ' + char(10)
			SELECT @v_dSql += N'	                                          ON    E.MODEL_TYPE = D.PLAN_GROUP_ID           ' + char(10)
		END

		SELECT @v_dSql += N'                        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID   ' + char(10)
		SELECT @v_dSql += N'                              , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'                              , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE     ' + char(10)
		SELECT @v_dSql += N'                              , A.EQUIPMENT_ID            ' + char(10)
		SELECT @v_dSql += N'                              , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME       ' + char(10)
		SELECT @v_dSql += N'                              , A.PRODUCTION_TYPE, A.MARKET                  ' + char(10)
		SELECT @v_dSql += N'                              , A.ITEM_TYPE, B.CATEGORY_NAME                 ' + char(10)
		SELECT @v_dSql += N'                              , B.CATEGORY_ID, B.CATEGORY_ORDER              ' + char(10)
		SELECT @v_dSql += N'          			  ) A                ' + char(10)
		SELECT @v_dSql += N'          ) A         ' + char(10)
		--SELECT @v_dSql += N'      )   ' + char(10)
		--SELECT @v_dSql += N'      , T_RELEASE AS (                   ' + char(10)
		SELECT @v_dSql += N'        SELECT A.FACTORY_ID              ' + char(10)

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
					
					SELECT @v_dSql += N'	            , MAX(CASE WHEN CONVERT(VARCHAR,A.RELEASE_DATE,112) = ''' + @sub_param_0 + ''' THEN ''Y'' ELSE NULL END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_BG    ' + char(10)

				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql += N'        INTO #TEMP_TABLE_T_RELEASE ' + char(10) 
		SELECT @v_dSql += N'        FROM (        ' + char(10)
		SELECT @v_dSql += N'          SELECT A.FACTORY_ID, CONVERT(VARCHAR,B.INSERT_TIME,112) AS RELEASE_DATE             ' + char(10)
		SELECT @v_dSql += N'          FROM (      ' + char(10)
		SELECT @v_dSql += N'            SELECT A.INSTANCE_ID, A.RELEASE_PLAN_ID AS PLAN_ID, ''BUILDING'' AS CONFIRM_AREA  ' + char(10)
		SELECT @v_dSql += N'                 , A.FACTORY_ID, A.INSERT_TIME            ' + char(10)
		SELECT @v_dSql += N'                 , DENSE_RANK() OVER(PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) SORT_ORDER                 ' + char(10)
		SELECT @v_dSql += N'            FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)  ' + char(10)
		SELECT @v_dSql += N'            , (       ' + char(10)
		SELECT @v_dSql += N'              SELECT DISTINCT A.INSTANCE_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'              FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'              WHERE  A.ACTIVE_FLAG = ''Y''                ' + char(10)
		SELECT @v_dSql += N'              AND    A.INSTANCE_ID = '''+ @p_instance_id +'''        ' + char(10)
		SELECT @v_dSql += N'            ) B       ' + char(10)
		SELECT @v_dSql += N'            WHERE  A.INSTANCE_ID  = B.INSTANCE_ID         ' + char(10)
		SELECT @v_dSql += N'            AND    A.FACTORY_ID   = B.FACTORY_ID          ' + char(10)
		SELECT @v_dSql += N'            AND    A.INSTANCE_ID  = '''+ @p_instance_id +'''         ' + char(10)
		SELECT @v_dSql += N'          ) A         ' + char(10)
		SELECT @v_dSql += N'          , SCM_FP_PLAN_H B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'          WHERE A.INSTANCE_ID  = B.INSTANCE_ID            ' + char(10)
		SELECT @v_dSql += N'          AND   A.PLAN_ID      = B.PLAN_ID                ' + char(10)
		SELECT @v_dSql += N'          AND   A.SORT_ORDER   = 1       ' + char(10)
		SELECT @v_dSql += N'          AND   A.CONFIRM_AREA IN (      ' + char(10)
		SELECT @v_dSql += N'            SELECT MAX(A.ATTRIBUTE1) AS CONFIRM_AREA      ' + char(10)
		SELECT @v_dSql += N'            FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)    ' + char(10)
		SELECT @v_dSql += N'            WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''   ' + char(10)
		SELECT @v_dSql += N'            AND    A.SEGMENT1         = '''+ @p_instance_id +'''     ' + char(10)
		SELECT @v_dSql += N'            AND    A.ACTIVE_FLAG      = ''Y''             ' + char(10)
		SELECT @v_dSql += N'          )           ' + char(10)
		SELECT @v_dSql += N'        ) A           ' + char(10)
		SELECT @v_dSql += N'        GROUP BY A.FACTORY_ID            ' + char(10)
		--SELECT @v_dSql += N'      )   ' + char(10)
		SELECT @v_dSql += N'      SELECT A.*      ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN

					SELECT @v_dSql += N'	         ,	CASE WHEN A.DATA_TYPE=''TOTAL_2'' THEN ''#FFBA85''                         ' + char(10)
					SELECT @v_dSql += N'	          		   WHEN A.DATA_TYPE=''TOTAL'' THEN ''#FFE5C2''                         ' + char(10)
					SELECT @v_dSql += N'	          		   WHEN A.DATA_TYPE=''DATA'' THEN (CASE WHEN F.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_BG = ''Y'' THEN ''#FFFFE6'' ELSE '''' END )                              ' + char(10)
					SELECT @v_dSql += N'	          		   ELSE '''' END AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_BG         ' + char(10)

					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'      FROM (          ' + char(10)
		SELECT @v_dSql += N'          SELECT * FROM #TEMP_TABLE_MAIN             ' + char(10)
		SELECT @v_dSql += N'          UNION ALL   ' + char(10)
		SELECT @v_dSql += N'          SELECT * FROM #TEMP_TABLE_MAIN_GAP         ' + char(10)
		SELECT @v_dSql += N'          UNION ALL ' + char(10)
		SELECT @v_dSql += N'          SELECT * FROM #MAIN_GAP_WPP ' + char(10)
		SELECT @v_dSql += N'          UNION ALL   ' + char(10)
		SELECT @v_dSql += N'          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME         ' + char(10)
		SELECT @v_dSql += N'                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID    ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME    ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE  ' + char(10)
		SELECT @v_dSql += N'                ,A.CATE                  ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'          			,A.CATEGORY_ID, A.CATEGORY_ORDER      ' + char(10)
		SELECT @v_dSql += N'                ,''TOTAL'' AS DATA_TYPE  ' + char(10)
		SELECT @v_dSql += N'          FROM   #TEMP_TABLE_MAIN A ' + char(10)
		SELECT @v_dSql += @sub_total
		SELECT @v_dSql += N'          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME, A.LINE_ID, A.ELECTRODE_TYPE         ' + char(10)
		SELECT @v_dSql += N'                  ,A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER                   ' + char(10)
		SELECT @v_dSql += N'          UNION ALL   ' + char(10)
		SELECT @v_dSql += N'          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME         ' + char(10)
		SELECT @v_dSql += N'                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID    ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME    ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE  ' + char(10)
		SELECT @v_dSql += N'                ,A.CATE                  ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'          			,A.CATEGORY_ID, A.CATEGORY_ORDER      ' + char(10)
		SELECT @v_dSql += N'                ,''TOTAL'' AS DATA_TYPE  ' + char(10)
		SELECT @v_dSql += N'          FROM   #TEMP_TABLE_MAIN_GAP A  ' + char(10)
		SELECT @v_dSql += @sub_total
		SELECT @v_dSql += N'          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME, A.LINE_ID, A.ELECTRODE_TYPE         ' + char(10)
		SELECT @v_dSql += N'                  ,A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER                   ' + char(10)
		SELECT @v_dSql += N'          UNION ALL   ' + char(10)
		SELECT @v_dSql += N'          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME         ' + char(10)
		SELECT @v_dSql += N'                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID    ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME    ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE  ' + char(10)
		SELECT @v_dSql += N'                ,A.CATE                  ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'          			,A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'                ,''TOTAL'' AS DATA_TYPE ' + char(10)
		SELECT @v_dSql += N'          FROM   #MAIN_GAP_WPP A ' + char(10)
		SELECT @v_dSql += @sub_total
		SELECT @v_dSql += N'          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'                  ,A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)

		SELECT @v_dSql += N'          -- Total    ' + char(10)
		SELECT @v_dSql += N'          UNION ALL   ' + char(10)
		SELECT @v_dSql += N'          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, A.OPERATION_ID AS OPERATION_ID, A.OPERATION_NAME     ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID                 ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME    ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE  ' + char(10)
		SELECT @v_dSql += N'                ,A.CATE                  ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'          			,A.CATEGORY_ID, A.CATEGORY_ORDER      ' + char(10)
		SELECT @v_dSql += N'                ,''TOTAL_2'' AS DATA_TYPE                 ' + char(10)
		SELECT @v_dSql += N'          FROM   #TEMP_TABLE_MAIN A ' + char(10)
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'          GROUP BY A.OPERATION_ID, A.OPERATION_NAME, A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER  ' + char(10)
		SELECT @v_dSql += N'          UNION ALL   ' + char(10)
		SELECT @v_dSql += N'          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, A.OPERATION_ID AS OPERATION_ID, A.OPERATION_NAME     ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID                 ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME    ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE  ' + char(10)
		SELECT @v_dSql += N'                ,A.CATE                  ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'          			,A.CATEGORY_ID, A.CATEGORY_ORDER      ' + char(10)
		SELECT @v_dSql += N'                ,''TOTAL_2'' AS DATA_TYPE                 ' + char(10)
		SELECT @v_dSql += N'          FROM   #TEMP_TABLE_MAIN_GAP A ' + char(10)
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'          GROUP BY A.OPERATION_ID, A.OPERATION_NAME, A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER  ' + char(10)
		SELECT @v_dSql += N'          UNION ALL   ' + char(10)
		SELECT @v_dSql += N'          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, A.OPERATION_ID AS OPERATION_ID, A.OPERATION_NAME     ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID                 ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME    ' + char(10)
		SELECT @v_dSql += N'                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE  ' + char(10)
		SELECT @v_dSql += N'                ,A.CATE                  ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'          			,A.CATEGORY_ID, A.CATEGORY_ORDER      ' + char(10)
		SELECT @v_dSql += N'                ,''TOTAL_2'' AS DATA_TYPE                 ' + char(10)
		SELECT @v_dSql += N'          FROM   #MAIN_GAP_WPP A ' + char(10)
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'          GROUP BY A.OPERATION_ID, A.OPERATION_NAME, A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER  ' + char(10)
		SELECT @v_dSql += N'      ) A ' + char(10)
		SELECT @v_dSql += N'      LEFT OUTER JOIN #TEMP_TABLE_T_RELEASE F WITH(NOLOCK)            ' + char(10)
		SELECT @v_dSql += N'      ON 1=1          ' + char(10)
		SELECT @v_dSql += N'      AND A.FACTORY_ID = F.FACTORY_ID    ' + char(10)
		SELECT @v_dSql += N'      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION   ' + char(10)
		SELECT @v_dSql += N'             , A.LINE_ID                 ' + char(10)
		SELECT @v_dSql += N'             , (CASE WHEN A.TOP_ITEM_ID IS NOT NULL THEN A.TOP_ITEM_ID ELSE ''ZZZZZ'' END)    ' + char(10)
		SELECT @v_dSql += N'             , A.OPERATION_ID DESC       ' + char(10)
		SELECT @v_dSql += N'             , A.EQUIPMENT_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'             , A.PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE                 ' + char(10)
		SELECT @v_dSql += N'             , A.CATEGORY_ORDER ; ' + char(10)+ char(10)

		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_MAIN'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_MAIN ' + char(10)
		SELECT @v_dSql += N'' + char(10)
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_MAIN_GAP'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_MAIN_GAP ' + char(10)
		SELECT @v_dSql += N'' + char(10)
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_T_RELEASE'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_T_RELEASE ' + char(10)
		SELECT @v_dSql += N'if object_id(''tempdb..#MAIN_ITEM_WPP_GAP'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #MAIN_ITEM_WPP_GAP ' + char(10)
		SELECT @v_dSql += N'if object_id(''tempdb..#MAIN_GAP_WPP'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #MAIN_GAP_WPP ' + char(10) + char(10)
		-- 속도개선... 20231023
		SELECT @v_dSql += N'if object_id(''tempdb..#SCM_DAILY_PRODUCT_RESULT_H'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #SCM_DAILY_PRODUCT_RESULT_H ' + char(10)
		SELECT @v_dSql += N'if object_id(''tempdb..#FP_DAILY_PRODUCTIOIN_PLAN_H'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #FP_DAILY_PRODUCTIOIN_PLAN_H ' + char(10)+ char(10)
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

