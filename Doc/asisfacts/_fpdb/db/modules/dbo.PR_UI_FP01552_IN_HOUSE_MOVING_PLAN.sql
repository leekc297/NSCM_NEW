

/*
 * Program ID   : PR_UI_FP01552_IN_HOUSE_MOVING_PLAN
 * Description  : In-House Moving Plan(Pack)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/09/16   CYS				Initial Release UI통합
 * 2023/04/18   KCH             SCM_STOCK_H -> SCM_STOCK_H_V 로 VIEW 변경
 * 2023/06/12   LJS				cell assy code 추가
 */

CREATE PROCEDURE [dbo].[PR_UI_FP01552_IN_HOUSE_MOVING_PLAN]
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

	DECLARE @v_proc_name	nvarchar(100) = OBJECT_NAME(@@PROCID);
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
	DECLARE @p_cell_item_id	NVARCHAR(MAX);
	DECLARE @p_line_assign	NVARCHAR(MAX);
	DECLARE @p_group_item_id	NVARCHAR(MAX);
	DECLARE @p_pack_instance_id	NVARCHAR(MAX);
	DECLARE @p_confirm_pack_plan_id	NVARCHAR(MAX);
	DECLARE @p_pack_plan_id	NVARCHAR(MAX);
	DECLARE @p_curr_date	NVARCHAR(MAX);

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
	DECLARE @p_result	NVARCHAR(MAX);

	DECLARE @tmp_column		NVARCHAR(MAX);
	DECLARE @tmp_value		NVARCHAR(MAX);
	DECLARE @dbg_txt		NVARCHAR(MAX);
	DECLARE @p_temp			NVARCHAR(MAX);

	DECLARE @IS_CELL_ASSY NVARCHAR(MAX); -- 활성화 분리 적용 여부(Y : 적용, N : 비적용)

	/*	Parameter Setting Start */

	
--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += ' @P_SYS_TYPE	= ''' +ISNULL(@P_SYS_TYPE,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_SYS_FLAG	= ''' +ISNULL(@P_SYS_FLAG,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_SYS_GUBUN	= ''' +ISNULL(@P_SYS_GUBUN,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_USER_ID		= ''' +ISNULL(@P_USER_ID,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@in_columns	= ''' +ISNULL(@in_columns,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@in_row		= ''' +ISNULL(@in_row,'')		+ '''' + CHAR(10)
--SET @PARAMS += ',@opt_none		= ''' +ISNULL(@opt_none,'')		+ '''' + CHAR(10)

--IF @P_SYS_TYPE = 'SQL' BEGIN
--	SELECT @PARAMS AS SQL
--	RETURN
--END

	-- 활성화 분리 flag
	--SET @IS_CELL_ASSY = (
	--						SELECT (CASE WHEN MAX(B.SEGMENT1) IS NULL THEN 'N' ELSE 'Y' END) AS IS_CELL_ASSY
	--						FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)
	--						WHERE  B.ACTIVE_FLAG = 'Y'
	--						AND    B.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY'
	--						AND    B.SEGMENT1 IN (
	--							SELECT MAX(SITE_ID)
	--							FROM   FP_INSTANCE_INFO_V V WITH(NOLOCK)
	--							WHERE  V.INSTANCE_ID = @p_master_id
	--						) );

	-- TO
	SET @IS_CELL_ASSY = (
						SELECT (CASE WHEN MAX(B.SEGMENT1) IS NULL THEN 'N' ELSE 'Y' END) AS IS_CELL_ASSY
						FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)
						WHERE  B.ACTIVE_FLAG = 'Y'
						AND    B.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY_INSTANCE'
						AND    B.SEGMENT1 = @p_master_id
						);
	SET @runstart = GetDate()
	SET @v_dSql = '@IS_CELL_ASSY :: ' + @IS_CELL_ASSY
	exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag, '',@v_dSql, 'SELECT', @runstart, @runstart


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
		END ELSE IF @tmp_column = 'CELL_ITEM_ID' BEGIN
			SET @p_cell_item_id =		@tmp_value
		END ELSE IF @tmp_column = 'LINE_ASSIGN' BEGIN
			SET @p_line_assign =		@tmp_value
		END ELSE IF @tmp_column = 'GROUP_ITEM_ID' BEGIN
			SET @p_group_item_id =		@tmp_value
		END ELSE IF @tmp_column = 'PACK_INSTANCE_ID' BEGIN
			SET @p_pack_instance_id =		@tmp_value
		END ELSE IF @tmp_column = 'CONFIRM_PACK_PLAN_ID' BEGIN
			SET @p_confirm_pack_plan_id =		@tmp_value
		END ELSE IF @tmp_column = 'PACK_PLAN_ID' BEGIN
			SET @p_pack_plan_id =		@tmp_value
		END ELSE IF @tmp_column = 'CURR_DATE' BEGIN
			SET @p_curr_date =		@tmp_value

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
		END ELSE IF @tmp_column = 'RESULT' BEGIN
			SET @p_result =			@tmp_value
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

	SET @total = 'WHERE 1=1'

	BEGIN

		SET @v_dSql = ''

		SET @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_01'') IS NOT NULL ' + char(10)
		SET @v_dSql += N'DROP TABLE #TEMP_TABLE_01 ' + char(10)

		SET @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_02'') IS NOT NULL ' + char(10)
		SET @v_dSql += N'DROP TABLE #TEMP_TABLE_02 ' + char(10)

		SET @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_03'') IS NOT NULL ' + char(10)
		SET @v_dSql += N'DROP TABLE #TEMP_TABLE_03 ' + char(10)

		SET @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_04'') IS NOT NULL ' + char(10)
		SET @v_dSql += N'DROP TABLE #TEMP_TABLE_04 ' + char(10)

		SET @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_05'') IS NOT NULL ' + char(10)
		SET @v_dSql += N'DROP TABLE #TEMP_TABLE_05 ' + char(10)
				
		SET @v_dSql += N'IF OBJECT_ID(''tempdb..#INSTANCE_T'') IS NOT NULL ' + char(10)
		SET @v_dSql += N'DROP TABLE #INSTANCE_T ' + char(10)
			
		SET @v_dSql += N'IF OBJECT_ID(''tempdb..#T_CHECK'') IS NOT NULL ' + char(10)
		SET @v_dSql += N'DROP TABLE #T_CHECK ' + char(10)+ char(10)
		SET @v_dSql += N'IF OBJECT_ID(''tempdb..#MAIN_S'') IS NOT NULL  DROP TABLE #MAIN_S ' + char(10) --Tuning block_01
			
		-- INTO 절로 temp table 이 제대로 동작이 안되어 create 사용함.
		SET @v_dSql += N'CREATE TABLE #TEMP_TABLE_01 ' + char(10)
		SET @v_dSql += N'( ' + char(10)
		SET @v_dSql += N'	[COMPANY_ID] [nvarchar](30) NOT NULL, ' + char(10)
		SET @v_dSql += N'	[DIVISION_ID] [nvarchar](30) NOT NULL, ' + char(10)
		SET @v_dSql += N'	[SITE_ID] [nvarchar](30) NOT NULL, ' + char(10)
		SET @v_dSql += N'	[PLANT_ID] [nvarchar](30) NOT NULL, ' + char(10)
		SET @v_dSql += N'	[GROUP_ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		SET @v_dSql += N'	[ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		SET @v_dSql += N'	[STOCK_FLAG] [nvarchar](10) NULL, ' + char(10)
		SET @v_dSql += N'	[QTY] [numeric](25, 10) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[TOTAL_QTY] [numeric](25, 10) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[AVAIL_QTY] [numeric](25, 10) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[HOLD_QTY] [numeric](25, 10) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[AVAIL_CELL_LONG_QTY] numeric(25, 10) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[HOLD_CELL_LONG_QTY] numeric(25, 10) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[PACK_INTRANSIT] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
		SET @v_dSql += N') ' + char(10)+char(10)
			  
		SET @v_dSql += N'CREATE TABLE #TEMP_TABLE_03 ' + char(10)
		SET @v_dSql += N'( ' + char(10)
		SET @v_dSql += N'	[COMPANY_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[DIVISION_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[SITE_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[PLANT_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[REF_DIVISION_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[REF_SITE_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[REF_PLANT_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[GROUP_ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		SET @v_dSql += N'	[ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		SET @v_dSql += N'	[NICK_NAME] [nvarchar](150) NULL, ' + char(10)
		SET @v_dSql += N'	[BOH_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[TOTAL_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[AVAIL_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[HOLD_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[AVAIL_CELL_LONG_QTY] numeric(20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[HOLD_CELL_LONG_QTY] numeric(20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[INTRANSIT] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[STORAGE] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[PSI] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[SOC_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[MARKET] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[CATEGORY_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[CATEGORY_ORDER] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[DATA_TYPE] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[GROUP_ORDER] [nvarchar](30) NULL ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '	, [M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '	, [W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '	, [D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SET @v_dSql += N')' + char(10) + char(10)

		SET @v_dSql += N'CREATE TABLE #TEMP_TABLE_04 ' + char(10)
		SET @v_dSql += N'( ' + char(10)
		SET @v_dSql += N'	[COMPANY_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[DIVISION_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[SITE_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[PLANT_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[REF_DIVISION_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[REF_SITE_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[REF_PLANT_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[GROUP_ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		SET @v_dSql += N'	[ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		SET @v_dSql += N'	[NICK_NAME] [nvarchar](150) NULL, ' + char(10)
		SET @v_dSql += N'	[BOH_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[TOTAL_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[AVAIL_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[HOLD_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[AVAIL_CELL_LONG_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[HOLD_CELL_LONG_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[INTRANSIT] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'	[STORAGE] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[PSI] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[SOC_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[MARKET] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[CATEGORY_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[CATEGORY_ORDER] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[DATA_TYPE] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'	[GROUP_ORDER] [nvarchar](30) NULL ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '	, [M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '	, [W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '	, [D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SET @v_dSql += N') ' + char(10) + char(10)
		
		SET @v_dSql += N'	CREATE TABLE #TEMP_TABLE_05 ' + char(10)
		SET @v_dSql += N'	( ' + char(10)
		SET @v_dSql += N'		[COMPANY_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[DIVISION_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[SITE_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[PLANT_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[REF_DIVISION_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[REF_SITE_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[REF_PLANT_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[GROUP_ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		SET @v_dSql += N'		[ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		SET @v_dSql += N'		[NICK_NAME] [nvarchar](150) NULL, ' + char(10)
		SET @v_dSql += N'		[BOH_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'		[TOTAL_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'		[AVAIL_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'		[HOLD_QTY] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'		[AVAIL_CELL_LONG_QTY] numeric(20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'		[HOLD_CELL_LONG_QTY] numeric(20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'		[INTRANSIT] [numeric](20, 4) NULL DEFAULT ((0)), ' + char(10)
		SET @v_dSql += N'		[STORAGE] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[PSI] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[SOC_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[MARKET] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[CATEGORY_ID] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[CATEGORY_ORDER] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[DATA_TYPE] [nvarchar](30) NULL, ' + char(10)
		SET @v_dSql += N'		[GROUP_ORDER] [nvarchar](30) NULL ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '		, [M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '		, [W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '		, [D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SET @v_dSql += N'	) ' + char(10) + char(10)

		SET @v_dSql += N'CREATE TABLE #T_CHECK ' + char(10)
		SET @v_dSql += N'( ' + char(10)
		SET @v_dSql += N'	[COMPANY_ID] [nvarchar](30) NOT NULL, ' + char(10)
		SET @v_dSql += N'	[DIVISION_ID] [nvarchar](30) NOT NULL, ' + char(10)
		SET @v_dSql += N'	[SITE_ID] [nvarchar](30) NOT NULL, ' + char(10)
		SET @v_dSql += N'	[PLANT_ID] [nvarchar](30) NOT NULL, ' + char(10)
		SET @v_dSql += N'	[GROUP_ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		SET @v_dSql += N'	[ITEM_ID] [nvarchar](150) NULL ' + char(10) --Tuning block_02
		--SET @v_dSql += N'	MARKET [nvarchar](30) NULL ' + char(10) --Tuning block_02
		SET @v_dSql += N') ' + char(10) + char(10)

		SET @v_dSql += N'SELECT	DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID ' + char(10) --Tuning block_03
		SET @v_dSql += N'INTO	#INSTANCE_T ' + char(10)
		SET @v_dSql += N'FROM	SCM_FACTORY_M A WITH(NOLOCK) ' + char(10)
		SET @v_dSql += N'INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
		SET @v_dSql += N'ON  	A.FACTORY_ID=B.FACTORY_ID ' + char(10)
		SET @v_dSql += N'AND 	B.ACTIVE_FLAG = ''Y'' ' + char(10)
		SET @v_dSql += N'WHERE 	1=1 ' + char(10)
		SET @v_dSql += N'AND	A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SET @v_dSql += N'AND 	B.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SET @v_dSql += N'' + char(10) + char(10)
		

		SET @v_dSql += N'INSERT INTO #T_CHECK                                                                                                                                                                                                  ' + char(10)	
		SET @v_dSql += N'SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                                              ' + char(10)	
		SET @v_dSql += N'	                      , ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID) AS GROUP_ITEM_ID                                                                                                                                             ' + char(10)	
		SET @v_dSql += N'	                      , A.ITEM_ID                                                                                                                                                                                       ' + char(10)	
		--SET @v_dSql += N'	                      , A.MARKET' + char(10) --Tuning block_04
		SET @v_dSql += N'FROM (                                                                                                                                                                                                  ' + char(10)	
		SET @v_dSql += N'	        				SELECT A.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID                                                                                                                                       ' + char(10)	
		SET @v_dSql += N'						         , B.REF_DIVISION_ID, B.REF_SITE_ID, B.REF_PLANT_ID                                                                                                                                         ' + char(10)	
		SET @v_dSql += N'						         , A.CELL_ITEM_ID AS GROUP_ITEM_ID                                                                                                                                                          ' + char(10)	
		SET @v_dSql += N'						         , A.CELL_ITEM_ID AS ITEM_ID                                                                                                                                                                ' + char(10)	
		SET @v_dSql += N'						         , A.STORAGE_ID, A.SOC_ID, A.MARKET                                                                                                                                                         ' + char(10)	
		SET @v_dSql += N'						    FROM   FP_DEMAND_PACK_REQUIRE_FIX A WITH(NOLOCK)                                                                                                                                                ' + char(10)	
		SET @v_dSql += N'						    INNER JOIN (                                                                                                                                                                                    ' + char(10)	
		SET @v_dSql += N'						                SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID                                                                                              ' + char(10)	
		SET @v_dSql += N'						                      , A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID                                                                                  ' + char(10)	
		SET @v_dSql += N'						                FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                                          ' + char(10)	
		SET @v_dSql += N'						                WHERE  A.LOOKUP_TYPE_CODE = ''FORMATION_PACK_INSTANCE_MAP''                                                                                                                         ' + char(10)	
		SET @v_dSql += N'						                AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                                        ' + char(10)	
		SET @v_dSql += N'						    ) B                                                                                                                                                                                             ' + char(10)	
		SET @v_dSql += N'						    ON  A.DIVISION_ID  = B.REF_DIVISION_ID                                                                                                                                                          ' + char(10)	
		SET @v_dSql += N'						    AND A.SITE_ID      = B.REF_SITE_ID                                                                                                                                                              ' + char(10)	
		SET @v_dSql += N'						    AND A.PLANT_ID     = B.REF_PLANT_ID                                                                                                                                                             ' + char(10)	
		SET @v_dSql += N'						    WHERE  1=1                                                                                                                                                                                      ' + char(10)	
		SET @v_dSql += N'						    AND A.INSTANCE_ID = '''+ @p_pack_instance_id +'''                                                                                                                                                          ' + char(10)	
		SET @v_dSql += N'						    AND A.PLAN_ID = (SELECT DISTINCT PACK_CONFIRM_ID FROM SCM_FP_IN_HOUSE_PLAN_H A WITH(NOLOCK) WHERE INSTANCE_ID = '''+ @p_instance_id +'''  AND PLAN_ID =  '''+ @p_plan_id +''')                                        ' + char(10)	
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += N'							AND  CONVERT(VARCHAR,A.REQUIRE_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                                                                  ' + char(10)	
		SET @v_dSql += N'							UNION ALL                                                                                                                                                                                       ' + char(10)	
		SET @v_dSql += N'						    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                                       ' + char(10)	
		SET @v_dSql += N'						         , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                                                                                   ' + char(10)	
		SET @v_dSql += N'						         , A.ITEM_ID AS GROUP_ITEM_ID                                                                                                                                                               ' + char(10)	
		SET @v_dSql += N'						         , A.ITEM_ID                                                                                          ' + char(10)	
		SET @v_dSql += N'						         , A.STORAGE_ID, A.SOC_ID, A.MARKET                                                                                                                                                         ' + char(10)	
		SET @v_dSql += N'						   	FROM FP_CELL_DELIVERY_PLAN_H A WITH(NOLOCK)                                                                                                                                                     ' + char(10)	
		SET @v_dSql += N'						    WHERE  1=1                                                                                                                                                                                      ' + char(10)	
		SET @v_dSql += N'						    AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                               ' + char(10)	
		SET @v_dSql += N'						    AND A.PLAN_ID = '''+ @p_plan_id +'''                                                                                                                                                                       ' + char(10)	
		SET @v_dSql += N'						    AND CONVERT(VARCHAR,A.DELIVERY_DATE,112) BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +'''                                                                                                                    ' + char(10)	
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += N'							UNION ALL                                                                                                                                                                                       ' + char(10)	
		SET @v_dSql += N'						    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                                       ' + char(10)	
		SET @v_dSql += N'						         , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                                                                                   ' + char(10)	
		SET @v_dSql += N'						         , A.ITEM_ID AS GROUP_ITEM_ID                                                                                                                                                               ' + char(10)	
		SET @v_dSql += N'						         , A.ITEM_ID                                                                                                                                                                                ' + char(10)	
		SET @v_dSql += N'						         , A.STORAGE_ID, A.SOC_ID, A.MARKET                                                                                                                                                         ' + char(10)	
		SET @v_dSql += N'						    FROM FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)                                                                                                                                                      ' + char(10)	
		SET @v_dSql += N'						    WHERE  1=1                                                                                                                                                                                      ' + char(10)	
		SET @v_dSql += N'						    AND A.CATEGORY = ''MOVING''                                                     ' + char(10)	
		SET @v_dSql += N'						    AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                               ' + char(10)	
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += N'							AND CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_plan_date +''' - 1                                                                                                                  ' + char(10)	
		SET @v_dSql += N') A                                                                                                                                                                                                       ' + char(10)	
		SET @v_dSql += N'LEFT OUTER JOIN (                                                                                                                                                                                         ' + char(10)	
		SET @v_dSql += N'	                              SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER                                                                 ' + char(10)	
		SET @v_dSql += N'	                              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                                                ' + char(10)	
		SET @v_dSql += N'	                              WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                                                                                         ' + char(10)	
		SET @v_dSql += N'	                              AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                                              ' + char(10)	
		SET @v_dSql += N') B                                                                                                                                                                                                       ' + char(10)	
		SET @v_dSql += N'ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                                         ' + char(10)	
		SET @v_dSql += N'AND A.SITE_ID = B.SITE_ID                                                                                                                                                                                 ' + char(10)	
		SET @v_dSql += N'AND A.ITEM_ID = B.ITEM_ID                                                                                                                                                                                 ' + char(10)	
		SET @v_dSql += N'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                                               ' + char(10)	
		SET @v_dSql += N'        , ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID)                                                                                                                                                              ' + char(10)	
		SET @v_dSql += N'        , A.ITEM_ID                                                                                                                                                                                       ' + char(10)	
		--SET @v_dSql += N'        , A.MARKET' + char(10) --Tuning block_05
		SET @v_dSql += N'; ' + char(10)	+ char(10)

		-- STOCK_T
		SELECT @v_dSql += N'WITH STOCK_T AS ( ' + char(10)
		--SELECT @v_dSql += N'			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID AS GROUP_ITEM_ID, A.ITEM_ID, ''PACK'' AS STOCK_FLAG                                                                                                            ' + char(10)
		SELECT @v_dSql += N'			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) AS GROUP_ITEM_ID, ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) AS ITEM_ID, ''PACK'' AS STOCK_FLAG ' + char(10) -- cell assy code 추가... 20230612
		SELECT @v_dSql += N'					, SUM(QTY) AS QTY                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'					, SUM(AVAIL_QTY) + SUM(HOLD_QTY) + SUM(AVAIL_CELL_LONG_QTY) + SUM(HOLD_CELL_LONG_QTY) AS TOTAL_QTY                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'					, SUM(AVAIL_QTY) AS AVAIL_QTY                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'					, SUM(HOLD_QTY) AS HOLD_QTY                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'					, SUM(AVAIL_CELL_LONG_QTY) AS AVAIL_CELL_LONG_QTY                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'					, SUM(HOLD_CELL_LONG_QTY) AS HOLD_CELL_LONG_QTY                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'					, SUM(PACK_INTRANSIT) AS PACK_INTRANSIT                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'			FROM	(                                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'						SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.FACTORY_ID                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'									, ISNULL(MAX(MODIFY_QTY), SUM(A.QTY)) AS QTY                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'									, ISNULL(ISNULL(MAX(BOH_MODIFY_QTY), SUM(A.BOH_QTY)),0) AS AVAIL_QTY                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'									, ISNULL(ISNULL(MAX(HOLD_MODIFY_QTY), SUM(A.HOLD_QTY)),0) AS HOLD_QTY                                                                                                         ' + char(10)
		SELECT @v_dSql += N'									, ISNULL(MAX(AVAIL_CELL_LONG_QTY),0) AS AVAIL_CELL_LONG_QTY                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'									, ISNULL(MAX(HOLD_CELL_LONG_QTY),0) AS HOLD_CELL_LONG_QTY                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'									, ISNULL(SUM(A.PACK_INTRANSIT),0) AS PACK_INTRANSIT                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'						FROM		(                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'													A.FP_APPLY_ITEM_ID AS ITEM_ID                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'													, A.MODIFY_FP_APPLY_WIPQTY AS MODIFY_QTY                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'													, A.FP_APPLY_WIPQTY AS QTY                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'													, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS BOH_MODIFY_QTY             ' + char(10)
		SELECT @v_dSql += N'													, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y'' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS BOH_QTY                           ' + char(10)
		SELECT @v_dSql += N'													, CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_MODIFY_QTY                                                                                              ' + char(10)
		SELECT @v_dSql += N'													, CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.FP_APPLY_WIPQTY ELSE NULL END AS HOLD_QTY                                                                                                            ' + char(10)
		SELECT @v_dSql += N'													, 0 AS AVAIL_CELL_LONG_QTY                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'													, 0 AS HOLD_CELL_LONG_QTY                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'													, 0 AS PACK_INTRANSIT                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'										FROM   SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'										INNER JOIN ( --<V: LOOKUP에 STOCK POINT 참조 >--                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	    													SELECT B.LOOKUP_TYPE_CODE                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	    															, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                                    ' + char(10)
		SELECT @v_dSql += N'	    															, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS                                  ' + char(10)
		SELECT @v_dSql += N'	    													FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	    													WHERE  B.ACTIVE_FLAG = ''Y''                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	    													AND    B.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	    													AND    B.SEGMENT1         = ''IN_HOUSE_MOVING''                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										) V                                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										ON   1=1                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'										AND  A.DIVISION_ID		= V.DIVISION_ID                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'										AND  A.SITE_ID			= V.SITE_ID                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										AND  A.PLANT_ID			= V.PLANT_ID                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'										AND  A.STOCK_TYPE		= V.STOCK_TYPE                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'										AND  A.STORAGE_ID		= V.STOCK_POINT                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'										AND  V.CELL_BOH			= ''Y''                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'										WHERE  1=1                ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.CUTOFF_DATE = CONVERT(datetime,'''+ @p_plan_date +''')         ' + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'	              AND	   A.SITE_ID = (SELECT DISTINCT SITE_ID FROM #INSTANCE_T)                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	              AND	  ( ISNULL(A.MODIFY_FP_APPLY_WIPQTY, 0) >=0 OR ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0 )                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	              -- DW 재고가 아닌 조건                                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	              AND NOT EXISTS (                                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	                	SELECT 1                                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	                	FROM (                                                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	                		  SELECT ''DW'' AS STOCK_TYPE, ''-'' AS STORAGE_ID                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	                  		, (                                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	                    			SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = ''SSP'' THEN 1 ELSE 0 END), 1) AS IS_SSP                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	                    			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	                    			WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_STOCK_SOURCE''                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	                    			AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	                    			AND    A.SEGMENT1 = '''+ @p_instance_id +'''                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	                  		) AS IS_SSP                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	                	) AA                                                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	                	WHERE A.STOCK_TYPE = AA.STOCK_TYPE                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	                	AND   A.STORAGE_ID = AA.STORAGE_ID                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	                	AND   1=AA.IS_SSP                                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	              )                                                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	              UNION ALL                                                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	              -- SSP 재고 추가                                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'											   , A.QTY AS MODIFY_QTY, A.QTY                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'											 , A.AVAIL_CELL_QTY AS BOH_MODIFY_QTY                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'											 , A.AVAIL_CELL_QTY AS BOH_QTY                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'											 , A.HOLD_CELL_QTY AS HOLD_MODIFY_QTY                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'											 , A.HOLD_CELL_QTY AS HOLD_QTY                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'											 , A.AVAIL_CELL_LONG_QTY                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'											 , A.HOLD_CELL_LONG_QTY                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'											 , 0 AS PACK_INTRANSIT                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'										FROM (                                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'												SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                              ' + char(10)
		SELECT @v_dSql += N'													 , SUM(CASE WHEN HOLD = ''N'' AND LONG_TERM_FLAG = ''N'' THEN QTY ELSE 0 END) AS AVAIL_CELL_QTY -- 가용, 노장기                                                                             ' + char(10)
		SELECT @v_dSql += N'													 , SUM(CASE WHEN HOLD = ''N'' AND LONG_TERM_FLAG != ''N'' THEN QTY ELSE 0  END) AS AVAIL_CELL_LONG_QTY  -- 가용, 장기                                                                       ' + char(10)
		SELECT @v_dSql += N'													 , SUM(CASE WHEN HOLD != ''N'' AND LONG_TERM_FLAG = ''N'' THEN QTY ELSE 0  END) AS HOLD_CELL_QTY     -- 비가용, 노장기                                                                      ' + char(10)
		SELECT @v_dSql += N'													 , SUM(CASE WHEN HOLD != ''N'' AND LONG_TERM_FLAG != ''N'' THEN QTY ELSE 0  END) AS HOLD_CELL_LONG_QTY      -- 비가용, 장기                                                                 ' + char(10)
		SELECT @v_dSql += N'													 , SUM(QTY) AS QTY -- 전체                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'												FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK)                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'												WHERE  1=1                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'												AND    A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''') -- 시업시간 포함 현재날짜                                                                                                                  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'												AND    A.QTY > 0                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'												GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                            ' + char(10)
		SELECT @v_dSql += N'										) A                                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'						) A                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'			) A                                                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V H WITH(NOLOCK) ' + char(10) -- cell assy code 추가... 20230612
		SELECT @v_dSql += N'			ON  A.COMPANY_ID  = H.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.DIVISION_ID = H.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID     = H.SITE_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.ITEM_ID 	  = H.CELL_ASSY_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) ' + char(10) -- cell assy code 추가... 20230612
		--SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'			-- CELL                                                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'			UNION ALL                                                                                                                                                                                                                           ' + char(10)
		--SELECT @v_dSql += N'			SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.GROUP_ITEM_ID, A.GROUP_ITEM_ID AS ITEM_ID, ''CELL'' AS STOCK_FLAG                                                                                                     ' + char(10)
		SELECT @v_dSql += N'			SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(H.CELL_PRODUCT_ITEM_ID, A.GROUP_ITEM_ID) AS GROUP_ITEM_ID, ISNULL(H.CELL_PRODUCT_ITEM_ID, A.GROUP_ITEM_ID) AS ITEM_ID, ''CELL'' AS STOCK_FLAG ' + char(10) -- cell assy code 추가... 20230612
		SELECT @v_dSql += N'					, SUM(QTY) AS QTY                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'					, SUM(AVAIL_QTY) + SUM(HOLD_QTY) + SUM(AVAIL_CELL_LONG_QTY) + SUM(HOLD_CELL_LONG_QTY) AS TOTAL_QTY                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'					, SUM(AVAIL_QTY) AS AVAIL_QTY                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'					, SUM(HOLD_QTY) AS HOLD_QTY                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'					, SUM(AVAIL_CELL_LONG_QTY) AS AVAIL_CELL_LONG_QTY                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'					, SUM(HOLD_CELL_LONG_QTY) AS HOLD_CELL_LONG_QTY                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'					, SUM(PACK_INTRANSIT) AS PACK_INTRANSIT                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'			FROM	(                                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		        		SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.GROUP_ITEM_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'									, ISNULL(MAX(MODIFY_QTY), SUM(A.QTY)) AS QTY                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'									, ISNULL(ISNULL(MAX(BOH_MODIFY_QTY), SUM(A.BOH_QTY)),0) AS AVAIL_QTY                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'									, ISNULL(ISNULL(MAX(HOLD_MODIFY_QTY), SUM(A.HOLD_QTY)),0) AS HOLD_QTY                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'									, ISNULL(MAX(AVAIL_CELL_LONG_QTY),0) AS AVAIL_CELL_LONG_QTY                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'									, ISNULL(MAX(HOLD_CELL_LONG_QTY),0) AS HOLD_CELL_LONG_QTY                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'									, ISNULL(SUM(A.PACK_INTRANSIT),0) AS PACK_INTRANSIT                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'						FROM		(                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'												ISNULL(B.GROUP_ITEM_ID, A.FP_APPLY_ITEM_ID) AS GROUP_ITEM_ID                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'												, A.MODIFY_FP_APPLY_WIPQTY AS MODIFY_QTY                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'												, A.FP_APPLY_WIPQTY AS QTY                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'												, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS BOH_MODIFY_QTY                 ' + char(10)
		SELECT @v_dSql += N'												, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y'' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS BOH_QTY                               ' + char(10)
		SELECT @v_dSql += N'												, CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_MODIFY_QTY                                                                                                  ' + char(10)
		SELECT @v_dSql += N'												, CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.FP_APPLY_WIPQTY ELSE NULL END AS HOLD_QTY                                                                                                                ' + char(10)
		SELECT @v_dSql += N'												, 0 AS AVAIL_CELL_LONG_QTY                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'												, 0 AS HOLD_CELL_LONG_QTY                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'												, 0 AS PACK_INTRANSIT                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'										FROM   SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'												INNER JOIN ( --<V: LOOKUP에 STOCK POINT 참조 >--                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	    													SELECT B.LOOKUP_TYPE_CODE                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	    															, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                                    ' + char(10)
		SELECT @v_dSql += N'	    															, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS                                  ' + char(10)
		SELECT @v_dSql += N'	    													FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	    													WHERE  B.ACTIVE_FLAG = ''Y''                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	    													AND    B.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	    													AND    B.SEGMENT1         = ''IN_HOUSE_MOVING''                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'												) V                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'													ON   1=1                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'													AND  A.DIVISION_ID		= V.DIVISION_ID                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'													AND  A.SITE_ID			= V.SITE_ID                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'													AND  A.PLANT_ID			= V.PLANT_ID                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'													AND  A.STOCK_TYPE		= V.STOCK_TYPE                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'													AND  A.OPERATION_ID		= V.STOCK_POINT                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'													AND  A.STOCK_STATUS		= V.STOCK_STATUS                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'													AND  V.PACK_BOH			= ''Y''                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'												LEFT OUTER JOIN (                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'														SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER                                                               ' + char(10)
		SELECT @v_dSql += N'														FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'														WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'														AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'												) B                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'												ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'												AND A.SITE_ID = B.SITE_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'												AND A.ITEM_ID = B.ITEM_ID	                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'										WHERE  1=1                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.CUTOFF_DATE = CONVERT(datetime,'''+ @p_plan_date +''')         ' + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'	              AND	   A.SITE_ID = (SELECT DISTINCT SITE_ID FROM #INSTANCE_T)                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'			            				AND	  ( ISNULL(A.MODIFY_FP_APPLY_WIPQTY, 0) >=0 OR ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0 )                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'									    -- DW 재고가 아닌 조건                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'									    AND NOT EXISTS (                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'									      	SELECT 1                                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'									      	FROM (                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'									      		SELECT ''DW'' AS STOCK_TYPE, ''-'' AS STORAGE_ID                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'									      		, (                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'									        			SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = ''SSP'' THEN 1 ELSE 0 END), 1) AS IS_SSP                                                                                                     ' + char(10)
		SELECT @v_dSql += N'									        			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'									        			WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_STOCK_SOURCE''                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'									        			AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'									        			AND    A.SEGMENT1 = '''+ @p_instance_id +'''                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'									      		) AS IS_SSP                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'									      	) AA                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'									      	WHERE A.STOCK_TYPE = AA.STOCK_TYPE                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'									      	AND   A.STORAGE_ID = AA.STORAGE_ID                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'									      	AND   1=AA.IS_SSP                                                                                                     ' + char(10)
		SELECT @v_dSql += N'									    )                                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'									    UNION ALL                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'									    -- SSP 재고 추가                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'									    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'									         , SUM(A.MODIFY_QTY) AS MODIFY_QTY                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'									         , SUM(A.QTY) AS QTY                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'									         , SUM(A.BOH_MODIFY_QTY) AS BOH_MODIFY_QTY                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'									         , SUM(A.BOH_QTY) AS BOH_QTY                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'									         , SUM(A.HOLD_MODIFY_QTY) AS HOLD_MODIFY_QTY                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'									         , SUM(A.HOLD_QTY) AS HOLD_QTY                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'									         , SUM(A.PACK_INTRANSIT) AS PACK_INTRANSIT                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'												 , 0 AS HOLD_CELL_LONG_QTY                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'												 , 0 AS PACK_INTRANSIT                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'									    FROM (                                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'											        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                          ' + char(10)
		SELECT @v_dSql += N'											        	 , A.QTY AS MODIFY_QTY, A.QTY AS QTY                                                ' + char(10)
		SELECT @v_dSql += N'											        	 , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> ''Y'' THEN A.QTY ELSE 0 END AS BOH_MODIFY_QTY                                      ' + char(10)
		SELECT @v_dSql += N'											        	 , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> ''Y'' THEN A.QTY ELSE 0 END AS BOH_QTY                                             ' + char(10)
		SELECT @v_dSql += N'											        	 , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> ''Y'' THEN 0 ELSE A.QTY END AS HOLD_MODIFY_QTY                                     ' + char(10)
		SELECT @v_dSql += N'											        	 , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> ''Y'' THEN 0 ELSE A.QTY END AS HOLD_QTY                                            ' + char(10)
		SELECT @v_dSql += N'											        	 , 0 AS PACK_INTRANSIT                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'											        FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK)                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'			        										INNER JOIN ( --<V: LOOKUP에 STOCK POINT 참조 >--                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'								                                        	SELECT DISTINCT B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'								                                    		     --, B.SEGMENT5 AS STOCK_POINT, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS	' + char(10)
		SELECT @v_dSql += N'								                                    		FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'								                                    		WHERE  B.ACTIVE_FLAG = ''Y''                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'								                                    		AND    B.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'								                                    		AND    B.SEGMENT1         = ''IN_HOUSE_MOVING''                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'								                                    		AND    B.ATTRIBUTE4       = ''Y''                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'						                                    ) V                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'						                                    ON   1=1                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'						                                    AND  A.DIVISION_ID	= V.DIVISION_ID                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'						                                    AND  A.SITE_ID		= V.SITE_ID                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'						                                    AND  A.PLANT_ID		= V.PLANT_ID                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'						                                    --AND  A.STOCK_TYPE	= V.STOCK_TYPE                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'						                                    --AND  A.OPERATION_ID	= V.STOCK_POINT                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'						                                    --AND  A.STOCK_STATUS	= V.STOCK_STATUS                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'				                                    WHERE  1=(                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'				                                      			SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = ''SSP'' THEN 1 ELSE 0 END), 1) AS IS_SSP                                                                                             ' + char(10)
		SELECT @v_dSql += N'				                                      			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'				                                      			WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_STOCK_SOURCE''                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'				                                      			AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'				                                      			AND    A.SEGMENT1 = '''+ @p_instance_id +''' )                                                                                                                                             ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'		    				                        AND    A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''')                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	                                    			AND    A.QTY > 0                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	        			) A                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	        			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'										UNION ALL                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'												ISNULL(B.GROUP_ITEM_ID, A.FP_APPLY_ITEM_ID) AS GROUP_ITEM_ID                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'												, 0 AS MODIFY_QTY                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'												, 0 AS QTY                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'												, 0 AS BOH_MODIFY_QTY                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'												, 0 AS BOH_QTY                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'												, 0AS HOLD_MODIFY_QTY                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'												, 0 AS HOLD_QTY                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'												, 0 AS AVAIL_CELL_LONG_QTY                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'												, 0 AS HOLD_CELL_LONG_QTY                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'												, ISNULL(A.PACK_MOVE_QTY, 0) AS PACK_INTRANSIT                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'										FROM 	SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'												LEFT OUTER JOIN (                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'														SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER                                                             ' + char(10)
		SELECT @v_dSql += N'														FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'														WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'														AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'												) B                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'												ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'												AND A.SITE_ID = B.SITE_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'												AND A.ITEM_ID = B.ITEM_ID	                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'										WHERE 1=1                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.CUTOFF_DATE = CONVERT(datetime,'''+ @p_plan_date +''')         ' + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'	              AND	   A.SITE_ID = (SELECT DISTINCT SITE_ID FROM #INSTANCE_T)                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'										AND	  A.PACK_MOVE_QTY > 0                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'								) A                                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.GROUP_ITEM_ID                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'					) A                                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V H WITH(NOLOCK) ' + char(10) -- cell assy code 추가... 20230612
		SELECT @v_dSql += N'			ON  A.COMPANY_ID    = H.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.DIVISION_ID   = H.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID       = H.SITE_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.GROUP_ITEM_ID = H.CELL_ASSY_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(H.CELL_PRODUCT_ITEM_ID, A.GROUP_ITEM_ID) ' + char(10) -- cell assy code 추가... 20230612
		--SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.GROUP_ITEM_ID                                                                                                         ' + char(10)
		SELECT @v_dSql += N')                                                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'INSERT INTO	#TEMP_TABLE_01                                                                                ' + char(10)
		SELECT @v_dSql += N'SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.GROUP_ITEM_ID, A.ITEM_ID, A.STOCK_FLAG                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'			, QTY                                                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'			, TOTAL_QTY                                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'			, AVAIL_QTY                                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'			, HOLD_QTY                                                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'			, AVAIL_CELL_LONG_QTY                                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'			, HOLD_CELL_LONG_QTY                                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'			, PACK_INTRANSIT                                                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'FROM	STOCK_T A' + char(10)
		SELECT @v_dSql += N';' + char(10) + char(10)


		-- TEMP_TABLE_03
		SELECT @v_dSql += N'WITH T_PLAN AS ( ' + char(10)
		SELECT @v_dSql += N'							                    	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                               ' + char(10)	
		--SELECT @v_dSql += N'									                     , A.ITEM_ID                                                                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'									                     , ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) AS ITEM_ID ' + char(10) -- cell assy code 추가... 20230612
		SELECT @v_dSql += N'								                         --, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'								                         , CONVERT(VARCHAR, A.PLAN_DATE+(CASE WHEN ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) IS NULL OR ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) = 0 THEN 1 ELSE ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) END), 112) AS PLAN_DATE	' + char(10)	
		SELECT @v_dSql += N'								                         --, (SUM(A.PLAN_QTY) * MAX(CASE WHEN F.BOM_RATE IS NULL THEN 1 ELSE F.BOM_RATE END)) AS S_QTY                                                                      ' + char(10)	
		SELECT @v_dSql += N'								                         , SUM(A.PLAN_QTY) AS S_QTY                                                                                                                                         ' + char(10)	
		SELECT @v_dSql += N'								                         , 0 AS P_QTY                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'								                         , 0 AS R_QTY                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'								                         , 0 AS BOH_QTY                                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'								                         , 0 AS AVAIL_QTY                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'										                 , 0 AS HOLD_QTY                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'							                    	FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'	          												-- operation bod                                                                                                                                                ' + char(10)	
		SELECT @v_dSql += N'	          												LEFT OUTER JOIN (                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'	                                      							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, ''-'' AS ITEM_ID                                                             ' + char(10)	
		SELECT @v_dSql += N'	                                      								--, BB.BUFFER_TIME, ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') AS BUFFER_TIME_UOM                                                                        ' + char(10)	
		SELECT @v_dSql += N'	                                      								, MAX(CASE WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''MINUTE'' THEN CEILING(ISNULL(BB.BUFFER_TIME,0)/1440)                                      ' + char(10)	
		SELECT @v_dSql += N'	                                          									WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''HOUR''   THEN CEILING(ISNULL(BB.BUFFER_TIME,0)/24)                                           ' + char(10)	
		SELECT @v_dSql += N'	                                          									WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''DAY''    THEN CEILING(ISNULL(BB.BUFFER_TIME,0))                                              ' + char(10)	
		SELECT @v_dSql += N'	                                          									END)  MOVING_TIME_DAY                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'	                                      							FROM  SCM_OPERATION_MOVE_2_V A WITH(NOLOCK)                                                                                     ' + char(10)	
		SELECT @v_dSql += N'	                                      							LEFT OUTER JOIN SCM_OPERATION_MOVE_M BB WITH(NOLOCK)                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'	                                      							ON    A.COMPANY_ID    = BB.COMPANY_ID                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.DIVISION_ID   = BB.DIVISION_ID                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.SITE_ID       = BB.SITE_ID                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.PLANT_ID      = BB.PLANT_ID                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.FACTORY_ID    = BB.FACTORY_ID                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.OPERATION_ID  = BB.OPERATION_ID                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.MODEL_TYPE    = BB.MODEL_TYPE                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.LINE_ATTR_1   = BB.LINE_ATTR_1                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   ISNULL(BB.ACTIVE_FLAG, ''Y'') = ''Y''                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'	                                      							WHERE 1=1                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	                                                    AND   A.OPERATION_ID = ''F6000''                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'	                                                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID                                                                                         ' + char(10)	
		SELECT @v_dSql += N'	          												) B                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'	          												ON     A.COMPANY_ID   = B.COMPANY_ID                                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'	          												AND    A.DIVISION_ID  = B.DIVISION_ID                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'	          												AND    A.SITE_ID      = B.SITE_ID                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'	          												AND    A.PLANT_ID     = B.PLANT_ID                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'	          												AND    A.OPERATION_ID = B.OPERATION_ID                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'	          												-- item-operation bod                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'	          												LEFT OUTER JOIN (                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'	                                        						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.ITEM_ID                                                                    ' + char(10)	
		SELECT @v_dSql += N'	                                        									--, A.BUFFER_TIME, A.BUFFER_TIME_UOM                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'	                                        									, MAX(CASE WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''MINUTE'' THEN CEILING(ISNULL(A.BUFFER_TIME,0)/1440)                                ' + char(10)	
		SELECT @v_dSql += N'	                                        										   WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''HOUR''   THEN CEILING(ISNULL(A.BUFFER_TIME,0)/24)                                      ' + char(10)	
		SELECT @v_dSql += N'	                                        										   WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''DAY''    THEN CEILING(ISNULL(A.BUFFER_TIME,0))                                         ' + char(10)	
		SELECT @v_dSql += N'	                                        										   END) MOVING_TIME_DAY                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'	                                        						FROM   SCM_ITEM_FLOW_EXCEPT_M A WITH(NOLOCK)                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'	                                      							INNER JOIN SCM_OPERATION_MOVE_2_V BB WITH(NOLOCK)                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'	                                      							ON    A.COMPANY_ID    = BB.COMPANY_ID                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.DIVISION_ID   = BB.DIVISION_ID                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.SITE_ID       = BB.SITE_ID                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.PLANT_ID      = BB.PLANT_ID                              ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.FACTORY_ID    = BB.FACTORY_ID                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.OPERATION_ID  = BB.OPERATION_ID                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.MODEL_TYPE    = BB.MODEL_TYPE                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'	                                      							AND   A.LINE_ATTR_1   = BB.LINE_ATTR_1                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'	                                        						WHERE 1=1                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	                                                    AND   A.OPERATION_ID = ''F6000''                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'	                                                    AND   A.ACTIVE_FLAG = ''Y''                                                                                                                                         ' + char(10)	
		SELECT @v_dSql += N'	                                                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.ITEM_ID                                                                              ' + char(10)	
		SELECT @v_dSql += N'	          												) C                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'	          												ON     A.COMPANY_ID   = C.COMPANY_ID                                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'	          												AND    A.DIVISION_ID  = C.DIVISION_ID                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'	          												AND    A.SITE_ID      = C.SITE_ID                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'	          												AND    A.PLANT_ID     = C.PLANT_ID                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'	          												--AND    A.FACTORY_ID   = C.FACTORY_ID                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'	          												AND    A.OPERATION_ID = C.OPERATION_ID                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'	          												AND    A.ITEM_ID      = C.ITEM_ID                                               ' + char(10)	
		SELECT @v_dSql += N'							                    	/*                                                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'															LEFT OUTER JOIN (                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'											                        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.CELL_ITEM_ID, A.PARENT_QTY, A.CHILD_QTY                                ' + char(10)	
		SELECT @v_dSql += N'										                                 , (CASE WHEN A.PARENT_QTY IS NULL OR A.PARENT_QTY = 0 THEN 1 ELSE (A.CHILD_QTY/A.PARENT_QTY) END) AS BOM_RATE                                      ' + char(10)	
		SELECT @v_dSql += N'										                            FROM TH_BUF_PACK_BOM_INFO A                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'										                            WHERE 1=1                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'										                    ) F                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'										                    ON  A.COMPANY_ID   = F.COMPANY_ID                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'										                    AND A.DIVISION_ID  = F.DIVISION_ID                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'												            AND A.SITE_ID      = F.SITE_ID                                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'												            AND A.PLANT_ID     = F.PLANT_ID                                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'										                    AND A.ITEM_ID      = F.ITEM_ID                                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'										                    */                                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'							                    	LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V H WITH(NOLOCK) ' + char(10) -- cell assy code 추가... 20230612
		SELECT @v_dSql += N'							                    	ON  A.COMPANY_ID  = H.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'							                    	AND A.DIVISION_ID = H.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'							                    	AND A.SITE_ID     = H.SITE_ID ' + char(10)
		SELECT @v_dSql += N'							                    	AND A.ITEM_ID     = H.CELL_ASSY_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'							                    	WHERE  1=1                                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'							                    	AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                              ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'								                    AND	   A.SITE_ID = (SELECT DISTINCT SITE_ID FROM #INSTANCE_T)                                                                                                            ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'								                    AND    A.OPERATION_ID = ''F6000''                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'								                    AND	   A.PLAN_TYPE = ''RELEASE''                                                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'								                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                             ' + char(10)	
		--SELECT @v_dSql += N'							                     	    	 , A.ITEM_ID, CONVERT(VARCHAR, A.PLAN_DATE+(CASE WHEN ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) IS NULL OR ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) = 0 THEN 1 ELSE ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) END), 112)	' + char(10)	
		SELECT @v_dSql += N'							                     	    	 , ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID), CONVERT(VARCHAR, A.PLAN_DATE+(CASE WHEN ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) IS NULL OR ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) = 0 THEN 1 ELSE ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) END), 112)	' + char(10) -- cell assy code 추가... 20230612
		SELECT @v_dSql += N')                                                                                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'INSERT INTO	#TEMP_TABLE_03 ' + char(10)
		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)	
		SELECT @v_dSql += N'	             , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'	             , A.GROUP_ITEM_ID                                                                                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'	             --, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME                                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'	             , CASE WHEN D.PSI = ''EOH(+Hold)'' OR D.PSI = ''EOH(Available)'' OR D.PSI = ''EOH(Hold)'' THEN A.ITEM_ID ELSE NULL END AS ITEM_ID                                                                          ' + char(10)	
		SELECT @v_dSql += N'	             , CASE WHEN D.PSI = ''EOH(+Hold)'' OR D.PSI = ''EOH(Available)'' OR D.PSI = ''EOH(Hold)'' THEN ISNULL(A.NICK_NAME,''-'') ELSE NULL END AS NICK_NAME                                                        ' + char(10)	
		SELECT @v_dSql += N'	             , NULL AS BOH_QTY                                                                                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'	             , NULL AS TOTAL_QTY                                                                                                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'	             , NULL AS AVAIL_QTY  ' + char(10)	
		SELECT @v_dSql += N'	             , NULL AS HOLD_QTY                                                                                                                                                                                         ' + char(10)	
		SELECT @v_dSql += N'	             , NULL AS AVAIL_CELL_LONG_QTY                                                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'	             , NULL AS HOLD_CELL_LONG_QTY                                                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'	             , NULL AS INTRANSIT                                                                                                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'	             , NULL AS STORAGE_ID, D.PSI, NULL AS SOC_ID, NULL AS MARKET                                                                                                                                                ' + char(10)	
		-- >> week/month/day 컬럼 아래로 이동 (temptable 생성때문에)
		SELECT @v_dSql += N'	             , ''I'' AS CATEGORY_ID, D.CATEGORY_ORDER                                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'	             , ''DATA'' AS DATA_TYPE                                                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'	             --, CASE WHEN D.PSI = ''EOH'' OR D.PSI = ''EOH(Available)'' OR D.PSI = ''EOH(Hold)'' THEN ISNULL(CASE WHEN D.PSI = ''EOH(+Hold)'' OR D.PSI = ''EOH(Available)'' OR D.PSI = ''EOH(Hold)'' THEN E.SORT_ORDER ELSE NULL END,100) + 147 ELSE 999 END GROUP_ORDER	' + char(10)	
		SELECT @v_dSql += N'	             , CASE WHEN D.PSI = ''EOH'' OR D.PSI = ''EOH(Available)'' OR D.PSI = ''EOH(Hold)'' THEN ISNULL(CASE WHEN D.PSI = ''EOH(+Hold)'' OR D.PSI = ''EOH(Available)'' OR D.PSI = ''EOH(Hold)'' THEN A.SORT_ORDER ELSE NULL END,100) + 147 ELSE 999 END GROUP_ORDER	' + char(10)	
		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
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

					SELECT @v_dSql += N'	            , SUM(CASE WHEN A.PLAN_DATE <= ''' + @sub_param_0 + ''' AND A.PLAN_DATE >= '''+ @p_plan_date +''' AND D.PSI = ''EOH(+Hold)'' THEN A.EOH_QTY                  ' + char(10)	
					SELECT @v_dSql += N'	            		   WHEN A.PLAN_DATE <= ''' + @sub_param_0 + ''' AND A.PLAN_DATE >= '''+ @p_plan_date +''' AND D.PSI = ''EOH(Available)'' THEN A.EOH_AVAIL_QTY        ' + char(10)	
					SELECT @v_dSql += N'	            		   WHEN A.PLAN_DATE <= ''' + @sub_param_0 + ''' AND A.PLAN_DATE >= '''+ @p_plan_date +''' AND D.PSI = ''EOH(Hold)'' THEN A.EOH_HOLD_QTY              ' + char(10)	
					SELECT @v_dSql += N'	            		   WHEN A.PLAN_DATE <= ''' + @sub_param_0 + ''' AND A.PLAN_DATE >= '''+ @p_plan_date +''' AND D.PSI = ''Meet Qty'' THEN A.FILL_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)	
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		--SELECT @v_dSql += N'			INTO	#TEMP_TABLE_03                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'FROM (                                                                                                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'		            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'		            	   , A.GROUP_ITEM_ID                                                                                                                                                                                ' + char(10)	
		SELECT @v_dSql += N'		                   , A.ITEM_ID, A.PLAN_DATE                                                                                                                                                                         ' + char(10)	
		SELECT @v_dSql += N'		                   , ISNULL(B.NICK_NAME,''-'') AS NICK_NAME                                                                                                                                                         ' + char(10)	
		SELECT @v_dSql += N'		                   , (CASE WHEN A.PLAN_DATE = '''+ @p_plan_date +''' THEN (A.BOH_QTY + A.S_QTY - A.P_QTY) ELSE (0 + A.S_QTY - A.P_QTY) END) AS EOH_QTY                                                                         ' + char(10)	
		SELECT @v_dSql += N'		                   , (CASE WHEN A.PLAN_DATE = '''+ @p_plan_date +''' THEN (A.AVAIL_QTY + A.S_QTY - A.P_QTY) ELSE (0 + A.S_QTY - A.P_QTY) END) AS EOH_AVAIL_QTY                                                                 ' + char(10)	
		SELECT @v_dSql += N'		                   , (CASE WHEN A.PLAN_DATE = '''+ @p_plan_date +''' THEN (A.HOLD_QTY + A.S_QTY - A.P_QTY) ELSE (0 + A.S_QTY - A.P_QTY) END) AS EOH_HOLD_QTY                                                                   ' + char(10)	
		SELECT @v_dSql += N'		                   , (CASE WHEN A.PLAN_DATE = '''+ @p_plan_date +''' THEN (A.P_QTY - A.G_QTY) ELSE (A.P_QTY - A.G_QTY) END) AS FILL_QTY                                                                                        ' + char(10)	
		SELECT @v_dSql += N'		                   , A.SORT_ORDER                                                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'		            FROM (                                                                                                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'			                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'			                     , A.GROUP_ITEM_ID                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'			                     , A.ITEM_ID                                                                                                                                                                                ' + char(10)	
		SELECT @v_dSql += N'			                     , A.PLAN_DATE                                                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'			                     , SUM(S_QTY) AS S_QTY                                                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'			                     , SUM(P_QTY) AS P_QTY                                                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'			                     , SUM(R_QTY) AS R_QTY                                                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'			                     , SUM(G_QTY) AS G_QTY                                                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'			                     , MAX(BOH_QTY) AS BOH_QTY                                                                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'			                     , MAX(AVAIL_QTY) AS AVAIL_QTY                                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'			                     , MAX(HOLD_QTY) AS HOLD_QTY                                                                                                                                                                ' + char(10)	
		SELECT @v_dSql += N'			                     , MAX(SORT_ORDER) AS SORT_ORDER                                                                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'			                FROM (                                                                                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'					                		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'						  	                        , ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID) AS GROUP_ITEM_ID                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'						                            , A.ITEM_ID                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'						  	                        , A.PLAN_DATE                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'						                            , A.S_QTY                                                   ' + char(10)	
		SELECT @v_dSql += N'						  	                        , A.P_QTY                                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'						  	                        , A.R_QTY                                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'						  	                        , ISNULL(D.QTY,0) AS BOH_QTY                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'						  	                        , ISNULL(D.AVAIL_QTY,0) AS AVAIL_QTY                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'						  	                        , ISNULL(D.HOLD_QTY,0) AS HOLD_QTY                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'						                            , 0 AS G_QTY                                                                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'						                            , ISNULL(B.SORT_ORDER, 0) AS SORT_ORDER                                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'						                    FROM (                                                                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'													SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID																												' + char(10)
		SELECT @v_dSql += N'															, A.ITEM_ID																																						' + char(10)
		SELECT @v_dSql += N'															, A.PLAN_DATE																																					' + char(10)
		SELECT @v_dSql += N'															, S_QTY AS S_QTY																																				' + char(10)
		SELECT @v_dSql += N'															, 0 AS P_QTY																																					' + char(10)
		SELECT @v_dSql += N'															, 0 AS R_QTY																																					' + char(10)
		SELECT @v_dSql += N'															, 0 AS BOH_QTY																																					' + char(10)
		SELECT @v_dSql += N'															, 0 AS AVAIL_QTY																																				' + char(10)
		SELECT @v_dSql += N'															, 0 AS HOLD_QTY																																					' + char(10)
		SELECT @v_dSql += N'													FROM   T_PLAN A																																							' + char(10)
		SELECT @v_dSql += N'													UNION ALL																																								' + char(10)
		SELECT @v_dSql += N'													SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID																										' + char(10)
		SELECT @v_dSql += N'															, A.ITEM_ID																																						' + char(10)
		SELECT @v_dSql += N'															, '''+ @p_plan_date +''' AS PLAN_DATE																																		' + char(10)
		SELECT @v_dSql += N'															, 0 AS S_QTY																																					' + char(10)
		SELECT @v_dSql += N'															, 0 AS P_QTY																																					' + char(10)
		SELECT @v_dSql += N'															, 0 AS R_QTY																																					' + char(10)
		SELECT @v_dSql += N'															, 0 AS BOH_QTY																																					' + char(10)
		SELECT @v_dSql += N'															, 0 AS AVAIL_QTY																																				' + char(10)
		SELECT @v_dSql += N'															, 0 AS HOLD_QTY																																					' + char(10)
		SELECT @v_dSql += N'													FROM   T_PLAN A																																							' + char(10)
		SELECT @v_dSql += N'								                    UNION ALL                                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'								                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'										                   , A.ITEM_ID                                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'										                   , CONVERT(VARCHAR, A.PLAN_DATE,112) AS PLAN_DATE                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'										                   , 0 AS S_QTY                                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'										                   , SUM(CONVERT(NUMERIC(18,5),A.QTY)) AS P_QTY                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'										                   , 0 AS R_QTY                                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'										                   , 0 AS BOH_QTY	--ISNULL(B.QTY,0) AS BOH_QTY                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'										                   , 0 AS AVAIL_QTY	--ISNULL(B.AVAIL_QTY,0) AS AVAIL_QTY                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'										                   , 0 AS HOLD_QTY	--ISNULL(B.HOLD_QTY,0) AS HOLD_QTY                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'								                    FROM   (                                                                                                                                                                ' + char(10)	
		SELECT @v_dSql += N'														        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.SOC_ID, A.DELIVERY_DATE AS PLAN_DATE, A.DELIVERY_QTY AS QTY                         ' + char(10)	
		SELECT @v_dSql += N'														        FROM FP_CELL_DELIVERY_PLAN_H A WITH(NOLOCK)                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'														        WHERE  1=1                                                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'														        AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'											                    AND A.PLAN_ID = '''+ @p_plan_id +'''                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'											                    AND    A.DELIVERY_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                              ' + char(10)	
		SELECT @v_dSql += N'											                    UNION ALL                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'														        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.SOC_ID, A.PLAN_DATE, A.QTY                                                          ' + char(10)	
		SELECT @v_dSql += N'														        FROM FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'														        WHERE  1=1                                                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'														        AND A.CATEGORY = ''MOVING''                                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'														        AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                           ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'											                    AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND DATEADD(DAY, -1, CONVERT(DATETIME,'''+ @p_plan_date +'''))                                                ' + char(10)	
		SELECT @v_dSql += N'														        UNION ALL                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'														        -- 0 수량 구간 강제 추가... 20210114                                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'														        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.SOC_ID, B.DT AS PLAN_DATE, 0 AS QTY                                        ' + char(10)	
		SELECT @v_dSql += N'														        FROM (                                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'	      													        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.SOC_ID                                                                          ' + char(10)	
		SELECT @v_dSql += N'	      													        FROM FP_CELL_DELIVERY_PLAN_H A WITH(NOLOCK)                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'	      													        WHERE  1=1                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'	      													        AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                              ' + char(10)	
		SELECT @v_dSql += N'	      										                    AND A.PLAN_ID = '''+ @p_plan_id +'''                                                                                                                               ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	      										                    AND    A.DELIVERY_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                          ' + char(10)	
		SELECT @v_dSql += N'	      										                    UNION ALL                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'	      													        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.SOC_ID                                                                          ' + char(10)	
		SELECT @v_dSql += N'	      													        FROM FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'	      													        WHERE  1=1                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'	      													        AND A.CATEGORY = ''MOVING''                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'	      													        AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                       ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	      										                    AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND DATEADD(DAY, -1, CONVERT(DATETIME,'''+ @p_plan_date +'''))                                            ' + char(10)	
		SELECT @v_dSql += N'														        ) A, TH_UIS_CAL B WITH(NOLOCK)                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'														        WHERE 1=1                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'														        AND   B.YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'														   ) A                                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'														   INNER HASH JOIN (                                                                                                                                                ' + char(10)	
		SELECT @v_dSql += N'												                      SELECT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID, A.SEGMENT3 AS SOC_ID, ATTRIBUTE3 AS SORT_ORDER                                               ' + char(10)	
		SELECT @v_dSql += N'												                      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'												                      WHERE  A.LOOKUP_TYPE_CODE = ''PACK_SOC''                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'												                      AND    A.ACTIVE_FLAG = ''Y''                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'											              	) DD                                                                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'										                    ON  A.DIVISION_ID = DD.DIVISION_ID                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'										                    AND A.SITE_ID     = DD.SITE_ID                                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'										                    AND A.SOC_ID      = DD.SOC_ID                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'								                    WHERE  1=1                                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'								                    AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                              ' + char(10)	
		SELECT @v_dSql += N'								                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'								                         	, A.ITEM_ID                                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'								                         	, CONVERT(VARCHAR, A.PLAN_DATE,112)                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'									        ) A                                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'										    LEFT OUTER HASH JOIN (                                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'							                			SELECT * FROM 	#TEMP_TABLE_01 	                                                                                ' + char(10)	
		SELECT @v_dSql += N'														WHERE	1=1                                                                                                                                         ' + char(10)	
		SELECT @v_dSql += N'														AND		STOCK_FLAG = ''PACK''                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'											) D                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'										    ON  A.COMPANY_ID   = D.COMPANY_ID                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'										    AND A.DIVISION_ID  = D.DIVISION_ID                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'										    AND A.SITE_ID      = D.SITE_ID                                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'										    AND A.PLANT_ID     = D.PLANT_ID                                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'										    AND A.ITEM_ID 	   = D.ITEM_ID                                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'									        INNER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'									        ON  A.COMPANY_ID  = C.COMPANY_ID                                                                                                                                                ' + char(10)	
		SELECT @v_dSql += N'									        AND A.DIVISION_ID = C.DIVISION_ID                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'									        AND A.SITE_ID     = C.SITE_ID                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'									        AND A.ITEM_ID     = C.ITEM_ID                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'									        AND C.ACTIVE_FLAG = ''Y''                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'							                    LEFT OUTER JOIN (                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'								                        SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER                                           ' + char(10)	
		SELECT @v_dSql += N'								                        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'								                        WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'								                        AND    A.ACTIVE_FLAG = ''Y''                                                                                     ' + char(10)	
		SELECT @v_dSql += N'							                    ) B                                                                                                                                                                         ' + char(10)	
		SELECT @v_dSql += N'							                    ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'							                    AND A.SITE_ID = B.SITE_ID                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'							                    AND A.ITEM_ID = B.ITEM_ID                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'						                    UNION ALL                                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'						                    SELECT A.COMPANY_ID, A.DIVISION_ID , A.SITE_ID, A.PLANT_ID                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'							                      , ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID) AS GROUP_ITEM_ID                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'					                        	  --, ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID) AS ITEM_ID                                                                                                                         ' + char(10)	
		SELECT @v_dSql += N'					                        	  , A.ITEM_ID                                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'							                      , A.PLAN_DATE                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'						                          , A.S_QTY                                                                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'						                          , A.P_QTY                                                                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'							                      , 0 AS R_QTY                                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'					                       	      , A.BOH_QTY                                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'					                       	      , 0 AS AVAIL_QTY                                                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'					                       	      , 0 AS HOLD_QTY                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'					                              , A.R_QTY AS G_QTY                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'					                              , ISNULL(B.SORT_ORDER, 0) AS SORT_ORDER                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'					                        FROM (                                                                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'								                    SELECT A.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'												         	, A.CELL_ITEM_ID AS ITEM_ID                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'												         	, CONVERT(VARCHAR, A.REQUIRE_DATE, 112) AS PLAN_DATE                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'												           	, 0 AS S_QTY                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'									                       	, 0 AS P_QTY                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'										                   	, SUM(CONVERT(NUMERIC(18,5),A.REQUIRE_QTY)) AS R_QTY                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'								                       	   	, 0 AS BOH_QTY                                                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'												    FROM   FP_DEMAND_PACK_REQUIRE_FIX A WITH(NOLOCK)                                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'												    INNER JOIN (                                                                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'												                SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID                                                                      ' + char(10)	
		SELECT @v_dSql += N'												                      , A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID                                                          ' + char(10)	
		SELECT @v_dSql += N'												                FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'												                WHERE  A.LOOKUP_TYPE_CODE = ''FORMATION_PACK_INSTANCE_MAP''                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'												                AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                ' + char(10)	
		SELECT @v_dSql += N'												    ) B                                                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'												    ON  A.DIVISION_ID  = B.REF_DIVISION_ID                                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'												    AND A.SITE_ID      = B.REF_SITE_ID                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'												    AND A.PLANT_ID     = B.REF_PLANT_ID                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'												    WHERE  1=1                                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'												    AND 	A.INSTANCE_ID = '''+ @p_pack_instance_id +'''                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'												    --AND 	A.PLAN_ID = (SELECT DISTINCT PACK_CONFIRM_ID FROM SCM_FP_IN_HOUSE_PLAN_H A WITH(NOLOCK) WHERE INSTANCE_ID = INSTANCE_ID  AND PLAN_ID =  PLAN_ID)                ' + char(10)	
		SELECT @v_dSql += N'												    AND 	A.PLAN_ID = '''+ @p_confirm_pack_plan_id +'''                                                                                                                              ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'													AND    A.REQUIRE_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                         ' + char(10)	
		SELECT @v_dSql += N'													GROUP BY A.COMPANY_ID, B.DIVISION_ID , B.SITE_ID, B.PLANT_ID, A.CELL_ITEM_ID, CONVERT(VARCHAR, A.REQUIRE_DATE, 112)                                                     ' + char(10)	
		SELECT @v_dSql += N'								            ) A                                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'								            INNER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'									        ON  A.COMPANY_ID  = C.COMPANY_ID                                                                                                                                                ' + char(10)	
		SELECT @v_dSql += N'									        AND A.DIVISION_ID = C.DIVISION_ID                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'									        AND A.SITE_ID     = C.SITE_ID                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'									        AND A.ITEM_ID     = C.ITEM_ID                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'									        AND C.ACTIVE_FLAG = ''Y''                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'				                        LEFT OUTER JOIN (                                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'				                                        SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER                                           ' + char(10)	
		SELECT @v_dSql += N'				                                        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'				                                        WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'				                                        AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'				                        ) B                                                                                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'				                        ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'				                        AND A.SITE_ID = B.SITE_ID                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'				                        AND A.ITEM_ID = B.ITEM_ID                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'	                        		-- 0 QTY Data Create Start                                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'				                    UNION ALL                                                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'				                    SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'				                   	      , ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID) AS GROUP_ITEM_ID                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'			  	                   	     , A.ITEM_ID AS ITEM_ID                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'			  	                         , '''+ @p_plan_date +''' AS PLAN_DATE                                                                                                                                                         ' + char(10)	
		SELECT @v_dSql += N'			  	                         , 0 AS S_QTY                                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'			  	                         , 0 AS P_QTY                                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'			  	                         , 0 AS R_QTY                                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'			  	                         , 0 AS BOH_QTY                                                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'			  	                         , 0 AS AVAIL_QTY                                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'					                     , 0 AS HOLD_QTY                                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'			                             , 0 AS G_QTY                                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'			                             , ISNULL(B.SORT_ORDER, 0) AS SORT_ORDER                                                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'			                        FROM (                                                                                                                                                                                  ' + char(10)	
		SELECT @v_dSql += N'											SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                       ' + char(10)	
		--SELECT @v_dSql += N'												 , A.ITEM_ID	                                                                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'												 , ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) AS ITEM_ID ' + char(10) -- cell assy code 추가... 20230612
		SELECT @v_dSql += N'											FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'											LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V H WITH(NOLOCK) ' + char(10) -- cell assy code 추가... 20230612
		SELECT @v_dSql += N'											ON  A.COMPANY_ID  = H.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'											AND A.DIVISION_ID = H.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'											AND A.SITE_ID     = H.SITE_ID ' + char(10)
		SELECT @v_dSql += N'											AND A.ITEM_ID     = H.CELL_ASSY_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'											WHERE  1=1                                                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'											AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                    ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'					                        AND	   A.SITE_ID = (SELECT DISTINCT SITE_ID FROM #INSTANCE_T)                                                                                                                    ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'											AND    A.OPERATION_ID = ''F6000''                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'											AND	   A.PLAN_TYPE = ''RELEASE''                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'											GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                     ' + char(10)	
		--SELECT @v_dSql += N'													, A.ITEM_ID                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'													, ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) ' + char(10) -- cell assy code 추가... 20230612
		SELECT @v_dSql += N'											UNION ALL                                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'											SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'											FROM FP_CELL_DELIVERY_PLAN_H A WITH(NOLOCK)                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'												INNER JOIN (                                                                                                                                                                ' + char(10)	
		SELECT @v_dSql += N'														SELECT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID, A.SEGMENT3 AS SOC_ID, ATTRIBUTE3 AS SORT_ORDER                                                             ' + char(10)	
		SELECT @v_dSql += N'														FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'														WHERE  A.LOOKUP_TYPE_CODE = ''PACK_SOC''                                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'														AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'												) DD                                                                                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'												ON  A.DIVISION_ID = DD.DIVISION_ID                                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'												AND A.SITE_ID     = DD.SITE_ID                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'												AND A.SOC_ID      = DD.SOC_ID                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'											WHERE  1=1                                                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'											AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'											AND A.PLAN_ID = '''+ @p_plan_id +'''                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'					                        AND    A.DELIVERY_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                  ' + char(10)	
		SELECT @v_dSql += N'											GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'											UNION ALL                                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'											SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'											FROM FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'												INNER JOIN (                                                                                                                                                                ' + char(10)	
		SELECT @v_dSql += N'														SELECT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID, A.SEGMENT3 AS SOC_ID, ATTRIBUTE3 AS SORT_ORDER                                                             ' + char(10)	
		SELECT @v_dSql += N'														FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'														WHERE  A.LOOKUP_TYPE_CODE = ''PACK_SOC''                                                                                                                            ' + char(10)	
		SELECT @v_dSql += N'														AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'												) DD                                                                                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'												ON  A.DIVISION_ID = DD.DIVISION_ID                                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'												AND A.SITE_ID     = DD.SITE_ID                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'												AND A.SOC_ID      = DD.SOC_ID                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'											WHERE  1=1                                                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'											AND A.CATEGORY = ''MOVING''                                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'											AND A.INSTANCE_ID = '''+ @p_instance_id +'''           ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'					                        AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND DATEADD(DAY, -1, CONVERT(DATETIME,'''+ @p_plan_date +'''))                                                                  ' + char(10)	
		SELECT @v_dSql += N'					                        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'				                    ) A                                                                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'				                    INNER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'								        ON  A.COMPANY_ID  = C.COMPANY_ID                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'								        AND A.DIVISION_ID = C.DIVISION_ID                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'								        AND A.SITE_ID     = C.SITE_ID                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'								        AND A.ITEM_ID     = C.ITEM_ID                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'								        AND C.ACTIVE_FLAG = ''Y''                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'				                    LEFT OUTER JOIN (                                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'				  	                        SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER                                                       ' + char(10)	
		SELECT @v_dSql += N'				  	                        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                                      ' + char(10)	
		SELECT @v_dSql += N'				  	                        WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'				  	                        AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'			  	                    ) B                                                                    ' + char(10)	
		SELECT @v_dSql += N'				  	                    ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'				  	                    AND A.SITE_ID = B.SITE_ID                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'				  	                    AND A.ITEM_ID = B.ITEM_ID                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'		                    WHERE 	1=1                                                                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'		                    AND		A.COMPANY_ID IS NOT NULL                                                                                                                                                                ' + char(10)	
		SELECT @v_dSql += N'		                                                                                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'		                                                                                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'	                ) A                                                                                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'	                inner join #T_CHECK AA on 1 = 1 ' + char(10) --Tuning block_06
		SELECT @v_dSql += N'										AND A.COMPANY_ID  = AA.COMPANY_ID                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'										AND A.DIVISION_ID  = AA.DIVISION_ID                                                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'										AND A.SITE_ID  = AA.SITE_ID                                                                                                                                                         ' + char(10)	
		SELECT @v_dSql += N'										AND A.PLANT_ID  = AA.PLANT_ID                                                                                                                                               ' + char(10)	
		SELECT @v_dSql += N'										AND A.GROUP_ITEM_ID = AA.GROUP_ITEM_ID                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'										AND A.ITEM_ID  = AA.ITEM_ID                                                                                                                                                         ' + char(10)	
		SELECT @v_dSql += N'							WHERE 1 = 1' + char(10) --Tuning block_07
		SELECT @v_dSql += N'			                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                                     ' + char(10)	
		SELECT @v_dSql += N'				                	   , A.GROUP_ITEM_ID                                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'				                	   , A.ITEM_ID                                                                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'				                	   , A.PLAN_DATE                                                                                                                                                                        ' + char(10)	
		SELECT @v_dSql += N'	           		 ) A                                                                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'			            INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'				        ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'				        AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'				        AND A.SITE_ID     = B.SITE_ID                                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'				        AND A.ITEM_ID     = B.ITEM_ID                                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'				        AND B.ACTIVE_FLAG = ''Y''                                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'	            WHERE 1=1                                                                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N') A ' + char(10)	
		SELECT @v_dSql += N'INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += N'ON  A.PLAN_DATE   = C.YYYYMMDD                                                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'INNER JOIN (                                                                                                                                                                                                    ' + char(10)	
		SELECT @v_dSql += N'	        		  SELECT ''EOH(Available)'' AS PSI, 9998 AS CATEGORY_ORDER                                                                                                                                              ' + char(10)	
		SELECT @v_dSql += N'		              --UNION ALL                                                                                                                                                                                           ' + char(10)	
		SELECT @v_dSql += N'		              --SELECT ''EOH(Hold)'' AS PSI, 9999 AS CATEGORY_ORDER                                                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'		              UNION ALL                                                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'		              SELECT ''EOH(+Hold)'' AS PSI, 10000 AS CATEGORY_ORDER                                                                                                                                                 ' + char(10)	
		SELECT @v_dSql += N'		              UNION ALL                                                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'		              SELECT ''Meet Qty'' AS PSI, 20000 AS CATEGORY_ORDER                                                                                                                                                   ' + char(10)	
		SELECT @v_dSql += N') D                                                                                                                                                                                                             ' + char(10)	
		SELECT @v_dSql += N'ON 1=1                                                                                                                                                                                                          ' + char(10)	
		SELECT @v_dSql += N'WHERE 1=1                                                                                                                                                                                                       ' + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.GROUP_ITEM_ID' , 'LIKE', @p_group_item_id)) + char(10)
		SELECT @v_dSql += N'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                             ' + char(10)	
		SELECT @v_dSql += N'	   , A.GROUP_ITEM_ID ' + char(10)	
		SELECT @v_dSql += N'	   , CASE WHEN D.PSI = ''EOH(+Hold)'' OR D.PSI = ''EOH(Available)'' OR D.PSI = ''EOH(Hold)'' THEN A.ITEM_ID ELSE NULL END ' + char(10)	
		SELECT @v_dSql += N'	      , CASE WHEN D.PSI = ''EOH(+Hold)'' OR D.PSI = ''EOH(Available)'' OR D.PSI = ''EOH(Hold)'' THEN ISNULL(A.NICK_NAME,''-'') ELSE NULL END ' + char(10)	
		SELECT @v_dSql += N'	   , D.PSI, D.CATEGORY_ORDER ' + char(10)	
		--SELECT @v_dSql += N'	   -- , CASE WHEN D.PSI = ''EOH(+Hold)'' OR D.PSI = ''EOH(Available)'' OR D.PSI = ''EOH(Hold)'' THEN E.SORT_ORDER ELSE NULL END ' + char(10)	
		SELECT @v_dSql += N'	   , CASE WHEN D.PSI = ''EOH(+Hold)'' OR D.PSI = ''EOH(Available)'' OR D.PSI = ''EOH(Hold)'' THEN A.SORT_ORDER ELSE NULL END ' + char(10)	
		SELECT @v_dSql += N'; ' + char(10) + char(10)


		-- #TEMP_TABLE_04
		SELECT @v_dSql += N'INSERT INTO	#TEMP_TABLE_04 ' + char(10)
		SELECT @v_dSql += N'SELECT 	 A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'		   , A.REF_DIVISION_ID, A.REF_SITE_ID, A.REF_PLANT_ID ' + char(10)
		SELECT @v_dSql += N'		   , A.GROUP_ITEM_ID                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	       --, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	       , CASE WHEN A.PLAN_TYPE = ''PACK'' OR A.PLAN_TYPE = ''PREV_PACK'' THEN A.ITEM_ID ELSE A.ITEM_ID END AS ITEM_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'		   , CASE WHEN A.PLAN_TYPE = ''PACK'' OR A.PLAN_TYPE = ''PREV_PACK'' THEN ISNULL(A.NICK_NAME,''-'') ELSE ISNULL(A.NICK_NAME,''-'') END AS NICK_NAME                                                 ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS BOH_QTY                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS TOTAL_QTY                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS AVAIL_QTY                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS HOLD_QTY                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS AVAIL_CELL_LONG_QTY                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS HOLD_CELL_LONG_QTY                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS INTRANSIT                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	       , A.STORAGE_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	       , CASE WHEN A.PLAN_TYPE = ''PACK'' THEN ''R(Cell Req.)'' WHEN A.PLAN_TYPE = ''PREV_PACK'' THEN ''R(Prev Cell Req.)'' ELSE ''DO(Cell Deli.)'' END AS PSI                                      ' + char(10)
		SELECT @v_dSql += N'	       , A.SOC_ID, A.MARKET                                                                                                                                                                         ' + char(10)
		-- >> week/month/day 컬럼 아래로 이동 (temptable 생성때문에)
		SELECT @v_dSql += N'	       , ''P'' AS CATEGORY_ID,  CASE WHEN PLAN_TYPE = ''FORM'' THEN DD.SORT_ORDER + 2 WHEN PLAN_TYPE = ''PACK'' THEN DD.SORT_ORDER + 1 ELSE DD.SORT_ORDER END AS CATEGORY_ORDER                       ' + char(10)
		SELECT @v_dSql += N'	       , ''DATA'' AS DATA_TYPE                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	       , A.GROUP_ORDER                                                                                                                                                                                ' + char(10)
		
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

					SELECT @v_dSql += N'				, SUM(CASE WHEN E.YYYYMM = ''' + @sub_param_0 + ''' THEN (CASE WHEN A.SOC_ID = DD.SOC_ID THEN A.QTY ELSE 0 END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'				, SUM(CASE WHEN E.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN (CASE WHEN A.SOC_ID = DD.SOC_ID THEN A.QTY ELSE 0 END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'				, SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN (CASE WHEN A.SOC_ID = DD.SOC_ID THEN A.QTY ELSE 0 END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt
		
		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'FROM (                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'			SELECT  	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	                  , A.REF_DIVISION_ID, A.REF_SITE_ID, A.REF_PLANT_ID                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	                  , ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID) AS GROUP_ITEM_ID                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	                  , A.ITEM_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	                  , ISNULL(C.NICK_NAME,''-'') AS NICK_NAME                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	                  , A.STORAGE_ID                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	                  , A.PLAN_TYPE                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	                  , A.SOC_ID, A.MARKET                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	                  , A.PLAN_DATE                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	                  , A.QTY                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	                  , CASE WHEN PLAN_TYPE = ''FORM'' THEN ISNULL(B.SORT_ORDER,100) + 143  ELSE ISNULL(B.SORT_ORDER,100) + 142 END GROUP_ORDER                                                         ' + char(10)
		SELECT @v_dSql += N'	        FROM 	(                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	        				SELECT 	A.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'							         , B.REF_DIVISION_ID, B.REF_SITE_ID, B.REF_PLANT_ID                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'							         , A.CELL_ITEM_ID AS GROUP_ITEM_ID                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'							         , A.CELL_ITEM_ID AS ITEM_ID                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'							         , A.STORAGE_ID, A.SOC_ID, A.MARKET       ' + char(10)
		SELECT @v_dSql += N'							         , CONVERT(VARCHAR,A.REQUIRE_DATE,112) AS PLAN_DATE, A.REQUIRE_QTY AS QTY                                                                                           ' + char(10)
		SELECT @v_dSql += N'							         , ''PACK'' AS PLAN_TYPE                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'						      FROM   	FP_DEMAND_PACK_REQUIRE_FIX A WITH(NOLOCK)                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'								    INNER JOIN (                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'								                SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'								                      , A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID                                                      ' + char(10)
		SELECT @v_dSql += N'								                FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                              ' + char(10)
		SELECT @v_dSql += N'								                WHERE  A.LOOKUP_TYPE_CODE = ''FORMATION_PACK_INSTANCE_MAP''                                                                                             ' + char(10)
		SELECT @v_dSql += N'								                AND    A.ACTIVE_FLAG = ''Y''                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'								    ) B                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'								    ON  A.DIVISION_ID  = B.REF_DIVISION_ID                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'								    AND A.SITE_ID      = B.REF_SITE_ID                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'								    AND A.PLANT_ID     = B.REF_PLANT_ID                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'							    WHERE  1=1                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'							    AND 	A.INSTANCE_ID = '''+ @p_pack_instance_id +'''                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'							    -- AND 	A.PLAN_ID = (SELECT DISTINCT PACK_CONFIRM_ID FROM SCM_FP_IN_HOUSE_PLAN_H A WITH(NOLOCK) WHERE INSTANCE_ID = INSTANCE_ID  AND PLAN_ID =  PLAN_ID)                ' + char(10)
		SELECT @v_dSql += N'							    AND 	A.PLAN_ID = '''+ @p_confirm_pack_plan_id +'''                                                                                                                              ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'							AND  CONVERT(VARCHAR,A.REQUIRE_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                                              ' + char(10)
		SELECT @v_dSql += N'							UNION ALL                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'							SELECT 	A.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'							         , B.REF_DIVISION_ID, B.REF_SITE_ID, B.REF_PLANT_ID                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'							         , A.CELL_ITEM_ID AS GROUP_ITEM_ID                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'							         , A.CELL_ITEM_ID AS ITEM_ID                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'							         , A.STORAGE_ID, A.SOC_ID, A.MARKET                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'							         , CONVERT(VARCHAR,A.REQUIRE_DATE,112) AS PLAN_DATE, A.REQUIRE_QTY AS QTY                                                                                           ' + char(10)
		SELECT @v_dSql += N'							         , ''PREV_PACK'' AS PLAN_TYPE                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'						    FROM   	FP_DEMAND_PACK_REQUIRE_FIX A WITH(NOLOCK)                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'								    INNER JOIN (                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'								                SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'								                      , A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID                                                      ' + char(10)
		SELECT @v_dSql += N'								                FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                              ' + char(10)
		SELECT @v_dSql += N'								                WHERE  A.LOOKUP_TYPE_CODE = ''FORMATION_PACK_INSTANCE_MAP''                                                                                             ' + char(10)
		SELECT @v_dSql += N'								                AND    A.ACTIVE_FLAG = ''Y''                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'								    ) B                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'								    ON  A.DIVISION_ID  = B.REF_DIVISION_ID                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'								    AND A.SITE_ID      = B.REF_SITE_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'								    AND A.PLANT_ID     = B.REF_PLANT_ID                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'						    WHERE  1=1                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'						    AND 	A.INSTANCE_ID = '''+ @p_pack_instance_id +'''                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'						    AND 	A.PLAN_ID = (	SELECT	TOP 1 PLAN_ID                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'													FROM	SCM_FP_IN_HOUSE_PLAN_H A WITH(NOLOCK)                                                                                                       ' + char(10)
		SELECT @v_dSql += N'													WHERE	1=1                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'													AND 	INSTANCE_ID	= '''+ @p_pack_instance_id +'''                                                                                                            ' + char(10)
		SELECT @v_dSql += N'													AND 	CONFIRM_FLAG = ''Y''                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'													AND 	NOT EXISTS (                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'																			SELECT 	DISTINCT PACK_CONFIRM_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'																			FROM 	SCM_FP_IN_HOUSE_PLAN_H X WITH(NOLOCK)                                                                               ' + char(10)
		SELECT @v_dSql += N'																			WHERE 	X.INSTANCE_ID 	= '''+ @p_instance_id +'''                                                                                     ' + char(10)
		SELECT @v_dSql += N'																			AND 	X.PLAN_ID 		=  '''+ @p_plan_id +'''                                                                                        ' + char(10)
		SELECT @v_dSql += N'																			AND 	X.PACK_CONFIRM_ID 		= A.PLAN_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'																		)                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'													ORDER BY PLAN_ID DESC	)                                                                                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'							AND  CONVERT(VARCHAR,A.REQUIRE_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                                              ' + char(10)
		SELECT @v_dSql += N'							UNION ALL                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'						    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'						         , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'						         , A.ITEM_ID AS GROUP_ITEM_ID                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'						         , A.ITEM_ID                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'						         , A.STORAGE_ID, A.SOC_ID, A.MARKET                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'						         , CONVERT(VARCHAR,A.DELIVERY_DATE,112) AS PLAN_DATE, A.DELIVERY_QTY AS QTY                                                                                             ' + char(10)
		SELECT @v_dSql += N'						         , ''FORM'' AS PLAN_TYPE                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'						    FROM FP_CELL_DELIVERY_PLAN_H A WITH(NOLOCK)                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'						    WHERE  1=1                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'						    AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'						    AND A.PLAN_ID = '''+ @p_plan_id +'''                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'				    		AND CONVERT(VARCHAR,A.DELIVERY_DATE,112) BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +'''                                                                                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'							UNION ALL                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'						    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'						         , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'						         , A.ITEM_ID AS GROUP_ITEM_ID                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'						         , A.ITEM_ID                                          ' + char(10)
		SELECT @v_dSql += N'						         , A.STORAGE_ID, A.SOC_ID, A.MARKET                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'						         , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.QTY AS QTY                                                                                                          ' + char(10)
		SELECT @v_dSql += N'						         , ''FORM'' AS PLAN_TYPE                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'						    FROM FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'						    WHERE  1=1                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'						    AND A.CATEGORY = ''MOVING''                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'						    AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'							AND CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_plan_date +''' - 1                                                                                              ' + char(10)
		SELECT @v_dSql += N'		  ) A                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	      LEFT OUTER JOIN (                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	                      SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER                                                     ' + char(10)
		SELECT @v_dSql += N'	                      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	                      WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	                      AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	      ) B                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	      ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	      AND A.SITE_ID = B.SITE_ID                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	      AND A.ITEM_ID = B.ITEM_ID                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	      	INNER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		        ON  A.COMPANY_ID  = C.COMPANY_ID                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		        AND A.DIVISION_ID = C.DIVISION_ID                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'		        AND A.SITE_ID     = C.SITE_ID                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		        AND A.ITEM_ID     = C.ITEM_ID                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		        AND C.ACTIVE_FLAG = ''Y''                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'			WHERE 1=1                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'INNER JOIN (                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	  SELECT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID, A.SEGMENT3 AS SOC_ID, ATTRIBUTE3 AS SORT_ORDER                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	  WHERE  A.LOOKUP_TYPE_CODE = ''PACK_SOC''                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	  AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N') DD ' + char(10)
		SELECT @v_dSql += N'ON  A.DIVISION_ID = DD.DIVISION_ID                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'AND A.SITE_ID     = DD.SITE_ID                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'AND A.SOC_ID      = DD.SOC_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'INNER HASH JOIN TH_UIS_CAL E WITH(NOLOCK)                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'ON  A.PLAN_DATE   = E.YYYYMMDD                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'WHERE 1=1                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.GROUP_ITEM_ID' , 'LIKE', @p_group_item_id)) + char(10)
		SELECT @v_dSql += N'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	   , A.REF_DIVISION_ID, A.REF_SITE_ID, A.REF_PLANT_ID                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	   , A.GROUP_ITEM_ID                                                                                                                                                                          ' + char(10)
		--SELECT @v_dSql += N'	   --, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'')                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	   , CASE WHEN A.PLAN_TYPE = ''PACK'' OR A.PLAN_TYPE = ''PREV_PACK'' THEN A.ITEM_ID ELSE A.ITEM_ID END                                                                                        ' + char(10)
		SELECT @v_dSql += N'	   , CASE WHEN A.PLAN_TYPE = ''PACK'' OR A.PLAN_TYPE = ''PREV_PACK'' THEN ISNULL(A.NICK_NAME,''-'') ELSE ISNULL(A.NICK_NAME,''-'') END                                                        ' + char(10)
		SELECT @v_dSql += N'	   , A.STORAGE_ID                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	   , CASE WHEN A.PLAN_TYPE = ''PACK'' THEN ''R(Cell Req.)'' WHEN A.PLAN_TYPE = ''PREV_PACK'' THEN ''R(Prev Cell Req.)'' ELSE ''DO(Cell Deli.)'' END                                           ' + char(10)
		SELECT @v_dSql += N'	   , A.SOC_ID, A.MARKET,  CASE WHEN PLAN_TYPE = ''FORM'' THEN DD.SORT_ORDER + 2 WHEN PLAN_TYPE = ''PACK'' THEN DD.SORT_ORDER + 1 ELSE DD.SORT_ORDER END                                       ' + char(10)
		SELECT @v_dSql += N'	   , A.GROUP_ORDER                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'; ' + char(10) + char(10)


		-- #TEMP_TABLE_05
		SELECT @v_dSql += N'INSERT INTO	#TEMP_TABLE_05 ' + char(10)   
		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	         , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                                                                       ' + char(10)
		SELECT @v_dSql += N'	         , A.GROUP_ITEM_ID, A.ITEM_ID, ISNULL(A.NICK_NAME,''-'') AS NICK_NAME                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	         , NULL AS BOH_QTY                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	         , NULL AS TOTAL_QTY                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	         , NULL AS AVAIL_QTY                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	         , NULL AS HOLD_QTY                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	         , NULL AS AVAIL_CELL_LONG_QTY                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	         , NULL AS HOLD_CELL_LONG_QTY                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	         , NULL AS INTRANSIT                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	         , NULL AS STORAGE_ID                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	         , D.PSI AS PSI                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	         , NULL AS SOC_ID, NULL AS MARKET                                                                                                                                                   ' + char(10)
		-- >> week/month/day 컬럼 아래로 이동 (temptable 생성때문에)
		SELECT @v_dSql += N'	         , ''SS'' AS CATEGORY_ID                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	         , D.CATEGORY_ORDER                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	         , ''DATA'' AS DATA_TYPE                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	         , CASE WHEN D.PSI = ''Ship Result'' THEN MAX(A.SORT_ORDER) + 145 ELSE MAX(A.SORT_ORDER) + 146 END AS GROUP_ORDER                                                               ' + char(10)

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

					SELECT @v_dSql += N'				, SUM(CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' AND D.PSI = ''Ship Result'' THEN A.SHIP_QTY                                            ' + char(10)
					SELECT @v_dSql += N'				 		   WHEN C.YYYYMM = ''' + @sub_param_0 + ''' AND D.PSI = ''Shortage'' THEN A.SHORTAGE ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'				, SUM(CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' AND D.PSI = ''Ship Result'' THEN A.SHIP_QTY                                          ' + char(10)
					SELECT @v_dSql += N'				 		   WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' AND D.PSI = ''Shortage'' THEN A.SHORTAGE ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'				, SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' AND D.PSI = ''Ship Result'' THEN A.SHIP_QTY                                              ' + char(10)
					SELECT @v_dSql += N'				 		   WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' AND D.PSI = ''Shortage'' THEN A.SHORTAGE ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql += N'FROM (                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  					SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                              ' + char(10)
		SELECT @v_dSql += N'								, A.REF_DIVISION_ID, A.REF_SITE_ID, A.REF_PLANT_ID                                                                                                              ' + char(10)
		SELECT @v_dSql += N'								, A.GROUP_ITEM_ID, A.ITEM_ID                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'								, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'								, A.PLAN_DATE                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'								, A.SHIP_QTY                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'								, A.QTY                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'								, A.SHORTAGE                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'								, A.SORT_ORDER                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'						FROM	(                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'					      				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                               ' + char(10)
		SELECT @v_dSql += N'												, A.REF_DIVISION_ID, A.REF_SITE_ID, A.REF_PLANT_ID                                                                                              ' + char(10)
		SELECT @v_dSql += N'												, A.GROUP_ITEM_ID, A.ITEM_ID                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'												, A.PLAN_DATE                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'												, SUM(A.SHIP_QTY) AS SHIP_QTY                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'												, SUM(A.QTY) AS QTY                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'												, CASE WHEN A.PLAN_DATE < '''+ @p_curr_date +'''  THEN SUM(A.SHIP_QTY) - SUM(A.QTY) ELSE 0 END AS SHORTAGE                                                 ' + char(10)
		SELECT @v_dSql += N'												, MAX(A.SORT_ORDER) AS SORT_ORDER                                                                                                               ' + char(10)
		SELECT @v_dSql += N'										FROM (                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'								      				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'															, A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                            ' + char(10)
		SELECT @v_dSql += N'															, A.ITEM_ID AS GROUP_ITEM_ID                                                                                                        ' + char(10)
		SELECT @v_dSql += N'															, A.ITEM_ID                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'															, CONVERT(VARCHAR,A.DELIVERY_DATE,112) AS PLAN_DATE                                                                                 ' + char(10)
		SELECT @v_dSql += N'															, 0 AS SHIP_QTY                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'															, A.DELIVERY_QTY AS QTY                                                                                                             ' + char(10)
		SELECT @v_dSql += N'															, 0 AS SORT_ORDER                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'												    FROM 	FP_CELL_DELIVERY_PLAN_H A WITH(NOLOCK)                                                                                              ' + char(10)
		SELECT @v_dSql += N'												    WHERE  1=1                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'												    AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                           ' + char(10)
		SELECT @v_dSql += N'												    AND A.PLAN_ID = '''+ @p_plan_id +'''                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'													AND A.DELIVERY_DATE BETWEEN CONVERT(DATE,'''+ @p_plan_date +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                         ' + char(10)
		SELECT @v_dSql += N'													AND A.DELIVERY_QTY > 0                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'													UNION ALL                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'												    SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'															, A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                            ' + char(10)
		SELECT @v_dSql += N'															, A.ITEM_ID AS GROUP_ITEM_ID                                                                                                        ' + char(10)
		SELECT @v_dSql += N'															, A.ITEM_ID                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'															, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                     ' + char(10)
		SELECT @v_dSql += N'															, 0 AS SHIP_QTY                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'															, A.QTY AS QTY                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'															, 0 AS SORT_ORDER                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'												    FROM FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)                                                                                                  ' + char(10)
		SELECT @v_dSql += N'												    WHERE  1=1                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'												    AND A.CATEGORY = ''MOVING''                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'												    AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'													AND A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND DATEADD(DAY, -1, CONVERT(DATE,'''+ @p_plan_date +'''))                                         ' + char(10)
		SELECT @v_dSql += N'													AND A.QTY > 0                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'													UNION ALL                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'													SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'															, A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                            ' + char(10)
		SELECT @v_dSql += N'															, ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID) AS GROUP_ITEM_ID, A.ITEM_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'															, A.SHIP_YYYYMMDD AS PLAN_DATE	                                             ' + char(10)
		SELECT @v_dSql += N'															, A.QTY AS SHIP_QTY                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'															, 0 DO_QTY                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'															, ISNULL(B.SORT_ORDER,100) AS SORT_ORDER                                                                                            ' + char(10)
		SELECT @v_dSql += N'													FROM SCM_FCS_SHIP_V A WITH(NOLOCK)                                                                                                          ' + char(10)
		SELECT @v_dSql += N'														 LEFT OUTER JOIN (                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'									                            SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER       ' + char(10)
		SELECT @v_dSql += N'									                            FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                      ' + char(10)
		SELECT @v_dSql += N'									                            WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                               ' + char(10)
		SELECT @v_dSql += N'									                            AND    A.ACTIVE_FLAG = ''Y''                                                                                                    ' + char(10)
		SELECT @v_dSql += N'												          ) B                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'												          ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'												          AND A.SITE_ID = B.SITE_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'												          AND A.ITEM_ID = B.ITEM_ID                                                                                                             ' + char(10)
		--Tuning block_08 begin		 
		SELECT @v_dsql += '														inner join #INSTANCE_T T on 1  = 1' + char(10)
		SELECT @v_dsql += '															AND 	A.COMPANY_ID = T.COMPANY_ID' + char(10)
		SELECT @v_dsql += '															AND 	A.DIVISION_ID = T.DIVISION_ID' + char(10)
		SELECT @v_dsql += '															AND 	A.SITE_ID = T.SITE_ID' + char(10)
		SELECT @v_dsql += '															AND 	A.PLANT_ID = T.PLANT_ID' + char(10)
		SELECT @v_dsql += '														inner join (' + char(10)
		SELECT @v_dsql += '															SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID,  B.ITEM_ID' + char(10)
		SELECT @v_dsql += '															FROM   #TEMP_TABLE_04 B WITH(NOLOCK)' + char(10)
		SELECT @v_dsql += '															group by B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID,  B.ITEM_ID' + char(10)
		SELECT @v_dsql += '														) T2 on 1 = 1' + char(10)
		SELECT @v_dsql += '															AND A.COMPANY_ID = T2.COMPANY_ID' + char(10)
		SELECT @v_dsql += '															AND A.DIVISION_ID = T2.DIVISION_ID' + char(10)
		SELECT @v_dsql += '															AND A.SITE_ID = T2.SITE_ID' + char(10)
		SELECT @v_dsql += '															AND A.PLANT_ID = T2.PLANT_ID' + char(10)
		SELECT @v_dsql += '															AND A.ITEM_ID = T2.ITEM_ID' + char(10)
		SELECT @v_dsql += '													WHERE 1=1' + char(10)
		SELECT @v_dsql += '								                    AND   A.BIZ_TYPE = ''P''' + char(10)
		SELECT @v_dsql += '								                    AND   A.SHIP_YYYYMMDD BETWEEN ''20231031'' AND ''20231120''' + char(10)
		SELECT @v_dsql += '								                    AND   ISNULL(A.QTY,0) > 0' + char(10)
		--Tuning block_08 end
		SELECT @v_dSql += N'													UNION ALL                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'													SELECT A.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'												         , B.REF_DIVISION_ID, B.REF_SITE_ID, B.REF_PLANT_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'												         , ISNULL(C.GROUP_ITEM_ID, A.ITEM_ID)  AS GROUP_ITEM_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'												         , A.ITEM_ID AS ITEM_ID                                                           ' + char(10)
		SELECT @v_dSql += N'												         , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                        ' + char(10)
		SELECT @v_dSql += N'												         , 0 AS SHIP_QTY                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'												         , 0 DO_QTY                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'												         , ISNULL(C.SORT_ORDER,100) AS SORT_ORDER                                                                                               ' + char(10)
		SELECT @v_dSql += N'												    FROM   FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)                                                                                                ' + char(10)
		SELECT @v_dSql += N'														    INNER JOIN (                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'														                SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID                                  ' + char(10)
		SELECT @v_dSql += N'														                      , A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID                      ' + char(10)
		SELECT @v_dSql += N'														                FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                              ' + char(10)
		SELECT @v_dSql += N'														                WHERE  A.LOOKUP_TYPE_CODE = ''FORMATION_PACK_INSTANCE_MAP''                                                             ' + char(10)
		SELECT @v_dSql += N'														                AND    A.ACTIVE_FLAG = ''Y''                                                                                            ' + char(10)
		SELECT @v_dSql += N'														    ) B                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'														    ON  A.DIVISION_ID  = B.REF_DIVISION_ID                                                                                              ' + char(10)
		SELECT @v_dSql += N'														    AND A.SITE_ID      = B.REF_SITE_ID                                                                                                  ' + char(10)
		SELECT @v_dSql += N'														    AND A.PLANT_ID     = B.REF_PLANT_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'														    LEFT OUTER JOIN (                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'										                        SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER       ' + char(10)
		SELECT @v_dSql += N'										                        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                      ' + char(10)
		SELECT @v_dSql += N'										                        WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                               ' + char(10)
		SELECT @v_dSql += N'										                        AND    A.ACTIVE_FLAG = ''Y''                                                                                                    ' + char(10)
		SELECT @v_dSql += N'													        ) C                                              ' + char(10)
		SELECT @v_dSql += N'													        ON  A.DIVISION_ID = C.DIVISION_ID                                                                                                   ' + char(10)
		SELECT @v_dSql += N'													        AND A.SITE_ID = C.SITE_ID                                                                                                           ' + char(10)
		SELECT @v_dSql += N'													        AND A.ITEM_ID = C.ITEM_ID                                                                                                           ' + char(10)
		SELECT @v_dSql += N'												    WHERE  1=1                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'												    AND A.CATEGORY = ''REQUEST''                                                                                                                ' + char(10)
		SELECT @v_dSql += N'												    AND A.INSTANCE_ID = '''+ @p_pack_instance_id +'''                                                                                                      ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'								                    AND  A.PLAN_DATE BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                                      ' + char(10)
		SELECT @v_dSql += N'													UNION ALL                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'													SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'												         , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                               ' + char(10)
		SELECT @v_dSql += N'												         , ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID) AS GROUP_ITEM_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'												         , A.ITEM_ID                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'												         , CONVERT(VARCHAR,A.DELIVERY_DATE,112) AS PLAN_DATE                                                                                    ' + char(10)
		SELECT @v_dSql += N'												         , 0 AS SHIP_QTY                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'												         , 0 DO_QTY                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'												         , ISNULL(B.SORT_ORDER,100) AS SORT_ORDER                                                                                               ' + char(10)
		SELECT @v_dSql += N'													FROM   FP_CELL_DELIVERY_PLAN_H A WITH(NOLOCK)                                                                                               ' + char(10)
		SELECT @v_dSql += N'															 LEFT OUTER JOIN (                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'										                            SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER   ' + char(10)
		SELECT @v_dSql += N'										                            FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                  ' + char(10)
		SELECT @v_dSql += N'										                            WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                           ' + char(10)
		SELECT @v_dSql += N'										                            AND    A.ACTIVE_FLAG = ''Y''                                                                                                ' + char(10)
		SELECT @v_dSql += N'													          ) B                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'													          ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'													          AND A.SITE_ID = B.SITE_ID                                                                                                         ' + char(10)
		SELECT @v_dSql += N'													          AND A.ITEM_ID = B.ITEM_ID                                                                                                         ' + char(10)
		SELECT @v_dSql += N'													WHERE  1=1                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'													AND	   A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                        ' + char(10)
		SELECT @v_dSql += N'								          			AND	   A.PLAN_ID = '''+ @p_plan_id +'''                                                                                                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'								                    AND    A.DELIVERY_DATE BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +'''                                                                                  ' + char(10)
		SELECT @v_dSql += N'								                    UNION ALL                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'													SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'												         , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                               ' + char(10)
		SELECT @v_dSql += N'												         , ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID) AS GROUP_ITEM_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'												         , A.ITEM_ID                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'												         , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                        ' + char(10)
		SELECT @v_dSql += N'												         , 0 AS SHIP_QTY                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'												         , 0 DO_QTY                                                                                        ' + char(10)
		SELECT @v_dSql += N'												         , ISNULL(B.SORT_ORDER,100) AS SORT_ORDER                                                                                               ' + char(10)
		SELECT @v_dSql += N'													FROM   FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)                                                                                                ' + char(10)
		SELECT @v_dSql += N'															 LEFT OUTER JOIN (                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'										                            SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER   ' + char(10)
		SELECT @v_dSql += N'										                            FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                  ' + char(10)
		SELECT @v_dSql += N'										                            WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                           ' + char(10)
		SELECT @v_dSql += N'										                            AND    A.ACTIVE_FLAG = ''Y''                                                                                                ' + char(10)
		SELECT @v_dSql += N'													          ) B                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'													          ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'													          AND A.SITE_ID = B.SITE_ID                                                                                                         ' + char(10)
		SELECT @v_dSql += N'													          AND A.ITEM_ID = B.ITEM_ID                                                                                                         ' + char(10)
		SELECT @v_dSql += N'													WHERE  1=1                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'													AND A.CATEGORY = ''MOVING''                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'													AND	   A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                        ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'								                    AND    A.PLAN_DATE BETWEEN CONVERT(DATE, '''+ @p_bucket_from +''') AND DATEADD(DAY, -1, CONVERT(DATE, '''+ @p_plan_date +'''))                                    ' + char(10)
		SELECT @v_dSql += N'											) A                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'											INNER JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                                                                ' + char(10)
		SELECT @v_dSql += N'										        ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                                                ' + char(10)
		SELECT @v_dSql += N'										        AND A.DIVISION_ID = B.DIVISION_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'										        AND A.SITE_ID     = B.SITE_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'										        AND A.ITEM_ID     = B.ITEM_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'										        AND B.ACTIVE_FLAG = ''Y''                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'									WHERE 1=1                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'									GROUP BY	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                              ' + char(10)
		SELECT @v_dSql += N'												, A.REF_DIVISION_ID, A.REF_SITE_ID, A.REF_PLANT_ID                                                                                              ' + char(10)
		SELECT @v_dSql += N'												, A.GROUP_ITEM_ID, A.ITEM_ID, A.PLAN_DATE                                                                                                       ' + char(10)
		SELECT @v_dSql += N'							) A                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'							INNER JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'						        ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'						        AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'						        AND A.SITE_ID     = B.SITE_ID                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'						        AND A.ITEM_ID     = B.ITEM_ID                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'						        AND B.ACTIVE_FLAG = ''Y''                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'							inner join #T_CHECK AA on 1 = 1 ' + char(10) --Tuning block_09
		SELECT @v_dSql += N'										AND A.COMPANY_ID  = AA.COMPANY_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'										AND A.DIVISION_ID  = AA.DIVISION_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										AND A.SITE_ID  = AA.SITE_ID                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'										AND A.PLANT_ID  = AA.PLANT_ID                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'										AND A.GROUP_ITEM_ID = AA.GROUP_ITEM_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'										AND A.ITEM_ID  = AA.ITEM_ID                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'					WHERE 1 = 1 ' + char(10) --Tuning block_10
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N') A                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'ON  A.PLAN_DATE   = C.YYYYMMDD                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'INNER JOIN (                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		  SELECT ''Ship Result'' AS PSI, 90000 AS CATEGORY_ORDER                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'          UNION ALL                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'          SELECT ''Shortage'' AS PSI, 91000 AS CATEGORY_ORDER                                                                                                                       ' + char(10)
		SELECT @v_dSql += N') D                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'ON 1=1                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'WHERE 1=1                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.GROUP_ITEM_ID' , 'LIKE', @p_group_item_id)) + char(10)
		SELECT @v_dSql += N'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'       , A.GROUP_ITEM_ID, A.ITEM_ID, ISNULL(A.NICK_NAME,''-'') ' + char(10)
		--SELECT @v_dSql += N'       --, A.SORT_ORDER ' + char(10)
		SELECT @v_dSql += N'       , D.PSI, D.CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'; ' + char(10) + char(10)


		-- MAIN
		SET @v_dSql += N'select * into #MAIN_S from (' + char(10) --Tuning block_11
		SET @v_dSql += N'				SELECT 	 A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                         ' + char(10)
		SET @v_dSql += N'				       , A.REF_DIVISION_ID, A.REF_SITE_ID, A.REF_PLANT_ID                                                                                                                           ' + char(10)
		SET @v_dSql += N'				       , A.GROUP_ITEM_ID                                                                                                                                                            ' + char(10)
		SET @v_dSql += N'				       , CASE WHEN A.PSI = ''P(FORM)'' OR A.PSI = ''Result'' THEN A.ITEM_ID ELSE NULL END AS ITEM_ID                                                                                ' + char(10)
		SET @v_dSql += N'				 	   , CASE WHEN A.PSI = ''P(FORM)'' OR A.PSI = ''Result'' THEN ISNULL(B.NICK_NAME,''-'') ELSE NULL END AS NICK_NAME                                                              ' + char(10)
		SET @v_dSql += N'				 	   , NULL AS BOH_QTY                                                                                                                                                            ' + char(10)
		SET @v_dSql += N'				 	   , A.TOTAL_QTY                                                                                                                                    ' + char(10)
		SET @v_dSql += N'				       , A.AVAIL_QTY                                                                                                                                                                ' + char(10)
		SET @v_dSql += N'				       , A.HOLD_QTY                                                                                                                                                                 ' + char(10)
		SET @v_dSql += N'				       , A.AVAIL_CELL_LONG_QTY, A.HOLD_CELL_LONG_QTY                                                                                                                                ' + char(10)
		SET @v_dSql += N'				       , A.INTRANSIT                                                                                                                                                                ' + char(10)
		SET @v_dSql += N'					   , A.STORAGE_ID, A.PSI, A.SOC_ID, A.MARKET                                                                                                                                    ' + char(10)
		SET @v_dSql += N'				     , ''S'' AS CATEGORY_ID, CASE WHEN A.PSI = ''P(CMA)'' THEN 110  ELSE 100 END AS CATEGORY_ORDER                                                                                  ' + char(10)
		SET @v_dSql += N'				   	 , ''DATA'' AS DATA_TYPE                                                                                                                                                        ' + char(10)
		SET @v_dSql += N'				   	 , A.GROUP_ORDER                                                                                                                                                                ' + char(10)

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
					
					SELECT @v_dSql += N'      			, SUM(CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SET @v_dSql += N'			    FROM (                                                                                                                                                                              ' + char(10)
		SET @v_dSql += N'			        	SELECT   A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                 ' + char(10)
		SET @v_dSql += N'						         , A.REF_DIVISION_ID, A.REF_SITE_ID, A.REF_PLANT_ID                                                                                                                 ' + char(10)
		SET @v_dSql += N'						         , A.GROUP_ITEM_ID, A.ITEM_ID                                                                                                                                       ' + char(10)
		SET @v_dSql += N'						         , A.STORAGE_ID, A.SOC_ID                                                                                                                                           ' + char(10)
		SET @v_dSql += N'						         , A.MARKET, A.PLAN_DATE                                                                                                                                            ' + char(10)
		SET @v_dSql += N'						         , A.PSI                                                                                                                                                            ' + char(10)
		SET @v_dSql += N'						         , A.QTY                                                                                                                                                            ' + char(10)
		SET @v_dSql += N'						         , A.GROUP_ORDER                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'						         , CASE WHEN A.PSI = ''P(CMA)'' THEN E.TOTAL_QTY ELSE D.TOTAL_QTY END AS TOTAL_QTY                                                                                  ' + char(10)
		SET @v_dSql += N'						         , CASE WHEN A.PSI = ''P(CMA)'' THEN E.AVAIL_QTY ELSE D.AVAIL_QTY END AS AVAIL_QTY                                                                                  ' + char(10)
		SET @v_dSql += N'						         , CASE WHEN A.PSI = ''P(CMA)'' THEN E.HOLD_QTY ELSE D.HOLD_QTY END AS HOLD_QTY                                                                                     ' + char(10)
		SET @v_dSql += N'						         , CASE WHEN A.PSI = ''P(CMA)'' THEN E.AVAIL_CELL_LONG_QTY  ELSE D.AVAIL_CELL_LONG_QTY  END AS AVAIL_CELL_LONG_QTY                                                  ' + char(10)
		SET @v_dSql += N'						         , CASE WHEN A.PSI = ''P(CMA)'' THEN E.HOLD_CELL_LONG_QTY  ELSE D.HOLD_CELL_LONG_QTY  END AS HOLD_CELL_LONG_QTY                                                     ' + char(10)
		SET @v_dSql += N'						         , CASE WHEN A.PSI = ''P(CMA)'' THEN ISNULL(E.PACK_INTRANSIT,0) ELSE NULL END AS INTRANSIT                                                                          ' + char(10)
		SET @v_dSql += N'						FROM (                                                                                                                                                                      ' + char(10)
		SET @v_dSql += N'		        				SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                      ' + char(10)
		SET @v_dSql += N'		      					         , A.REF_DIVISION_ID, A.REF_SITE_ID, A.REF_PLANT_ID                      ' + char(10)
		SET @v_dSql += N'		      					         , ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID) AS GROUP_ITEM_ID                                                                                                  ' + char(10)
		SET @v_dSql += N'								         , A.ITEM_ID                                                                                                                                            ' + char(10)
		SET @v_dSql += N'								         , A.STORAGE_ID, A.SOC_ID                                                                                                                               ' + char(10)
		SET @v_dSql += N'								         , A.MARKET, A.PLAN_DATE                                                                                                                                ' + char(10)
		SET @v_dSql += N'								         , A.PSI, A.QTY                                                                                                                                         ' + char(10)
		SET @v_dSql += N'								         , CASE WHEN A.PSI = ''P(CMA)'' THEN 110 WHEN A.PSI = ''Result'' THEN ISNULL(B.SORT_ORDER, 100) + 141 ELSE ISNULL(B.SORT_ORDER, 100) + 140 END AS GROUP_ORDER	' + char(10)
		SET @v_dSql += N'		          				FROM(                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'								   		SELECT A.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID                                                                                               ' + char(10)
		SET @v_dSql += N'								             , B.REF_DIVISION_ID, B.REF_SITE_ID, B.REF_PLANT_ID                                                                                                 ' + char(10)
		SET @v_dSql += N'								             , C.CHILD_ITEM_ID AS ITEM_ID                                                                                                                       ' + char(10)
		SET @v_dSql += N'								             , CAST(NULL AS VARCHAR) STORAGE_ID, CAST(NULL AS VARCHAR) SOC_ID ' + char(10) --Tuning block_12
		SET @v_dSql += N'								             , A.MARKET, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                          ' + char(10)
		SET @v_dSql += N'								             , ''P(CMA)'' AS PSI                                                                                                                                ' + char(10)
		SET @v_dSql += N'								             , SUM(A.PLAN_IN_QTY) AS QTY                                                                                                                        ' + char(10)
		SET @v_dSql += N'								        FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                                                                                       ' + char(10)
		SET @v_dSql += N'										        INNER JOIN (                                                                                                                                    ' + char(10)
		SET @v_dSql += N'										                    SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID                                              ' + char(10)
		SET @v_dSql += N'										                          , A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID                                  ' + char(10)
		SET @v_dSql += N'										                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                          ' + char(10)
		SET @v_dSql += N'										                    WHERE  A.LOOKUP_TYPE_CODE = ''FORMATION_PACK_INSTANCE_MAP''                            ' + char(10)
		SET @v_dSql += N'										                    AND    A.ACTIVE_FLAG = ''Y''                                                                                                        ' + char(10)
		SET @v_dSql += N'										        ) B                                                                                                                                             ' + char(10)
		SET @v_dSql += N'										        ON  A.DIVISION_ID  = B.REF_DIVISION_ID                                                                                                          ' + char(10)
		SET @v_dSql += N'										        AND A.SITE_ID      = B.REF_SITE_ID                                                                                                              ' + char(10)
		SET @v_dSql += N'										        AND A.PLANT_ID     = B.REF_PLANT_ID                                                                                                             ' + char(10)
		SET @v_dSql += N'								        	, (                                                                                                                                                 ' + char(10)
		SET @v_dSql += N'											      SELECT C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID													                        ' + char(10)
		SET @v_dSql += N'											      FROM 	SCM_BOM_M_V C WITH(NOLOCK),											                                                                    ' + char(10)
		SET @v_dSql += N'											        	SCM_ITEM_M D WITH(NOLOCK),											                                                                    ' + char(10)
		SET @v_dSql += N'											        	SCM_ITEM_CLASS_M E WITH(NOLOCK)	                                                                                                        ' + char(10)
		SET @v_dSql += N'											      WHERE 1=1                                                                                                                                     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SET @v_dSql += N'												  AND	 C.SITE_ID = (SELECT DISTINCT SITE_ID FROM #INSTANCE_T)                                                                                  ' + char(10)
		SET @v_dSql += N'											      AND    C.EFF_END_DATE >= GETDATE()												                                                            ' + char(10)
		SET @v_dSql += N'											      AND	 (C.ALT_PRIORITY IS NULL OR C.ALT_PRIORITY = ''1'')	                                                                                    ' + char(10)
		SET @v_dSql += N'											      AND    C.COMPANY_ID = D.COMPANY_ID                                                                                                            ' + char(10)
		SET @v_dSql += N'											      AND    C.DIVISION_ID = D.DIVISION_ID                                                                                                          ' + char(10)
		SET @v_dSql += N'											      AND    C.SITE_ID = D.SITE_ID												                                                                    ' + char(10)
		SET @v_dSql += N'												  AND    C.CHILD_ITEM_ID = D.ITEM_ID												                                                            ' + char(10)
		SET @v_dSql += N'												  AND    C.SITE_ID = D.SITE_ID													                                                                ' + char(10)
		SET @v_dSql += N'												  AND    C.DIVISION_ID = D.DIVISION_ID													                                                        ' + char(10)
		SET @v_dSql += N'												  AND	 D.ITEM_CLASS = E.CLASS_ID												                                                                ' + char(10)
		SET @v_dSql += N'												  AND 	 E.LEVEL_3_NAME = ''CELL''			                               ' + char(10)
		SET @v_dSql += N'												  GROUP BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID                                                                          ' + char(10)
		SET @v_dSql += N'											   ) C	                                                                                                                                            ' + char(10)
		SET @v_dSql += N'										WHERE  1=1                                                                                                                                              ' + char(10)
		SET @v_dSql += N'										AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += N'											AND    A.OPERATION_ID IN (''P5000'',''P5200'') --bom 하위 P5200 공정 추가... 20210119                                                                   ' + char(10)
		SET @v_dSql += N'										AND	   A.PLAN_TYPE = ''RELEASE''                                                                                                                            ' + char(10)
		SET @v_dSql += N'										AND    A.SITE_ID = C.SITE_ID                                                                                                                                ' + char(10)
		SET @v_dSql += N'										AND    A.DIVISION_ID = C.DIVISION_ID                                                                                                                        ' + char(10)
		SET @v_dSql += N'										AND    A.ITEM_ID = C.PARENT_ITEM_ID                                                                                                                         ' + char(10)
		SET @v_dSql += N'										GROUP BY A.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID                                                                                                 ' + char(10)
		SET @v_dSql += N'										       , B.REF_DIVISION_ID, B.REF_SITE_ID, B.REF_PLANT_ID                                                                                                   ' + char(10)
		SET @v_dSql += N'										       , C.CHILD_ITEM_ID, A.MARKET, CONVERT(VARCHAR,A.PLAN_DATE,112)                                                                                        ' + char(10)
		SET @v_dSql += N'			          					UNION ALL                                                                                                                                                   ' + char(10)
		SET @v_dSql += N'			          					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                   ' + char(10)
		SET @v_dSql += N'										     , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                                               ' + char(10)
		--SET @v_dSql += N'										     , A.ITEM_ID                                                                                                                                            ' + char(10)
		SET @v_dSql += N'										     , ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) AS ITEM_ID ' + char(10) -- cell assy code 추가... 20230612
		SET @v_dSql += N'										     , NULL AS STORAGE_ID, NULL AS SOC_ID                                                                                                                   ' + char(10)
		SET @v_dSql += N'										     , A.MARKET, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                              ' + char(10)
		SET @v_dSql += N'										     , ''P(FORM)'' AS PSI                                                                                                                                   ' + char(10)
		SET @v_dSql += N'										     , SUM(A.PLAN_QTY) AS QTY                                                                                                                               ' + char(10)
		SET @v_dSql += N'										FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                                                                                           ' + char(10)
		SET @v_dSql += N'										LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V H WITH(NOLOCK) ' + char(10) -- cell assy code 추가... 20230612
		SET @v_dSql += N'										ON  A.COMPANY_ID  = H.COMPANY_ID ' + char(10)
		SET @v_dSql += N'										AND A.DIVISION_ID = H.DIVISION_ID ' + char(10)
		SET @v_dSql += N'										AND A.SITE_ID     = H.SITE_ID ' + char(10)
		SET @v_dSql += N'										AND A.ITEM_ID     = H.CELL_ASSY_ITEM_ID ' + char(10)
		SET @v_dSql += N'										WHERE  1=1                                                                                                                                                  ' + char(10)
		SET @v_dSql += N'										AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += N'										AND	   A.SITE_ID = (SELECT DISTINCT SITE_ID FROM #INSTANCE_T)                                                                                                ' + char(10)
		SET @v_dSql += N'										AND    A.OPERATION_ID = ''F6000''                                                                                                                           ' + char(10)
		SET @v_dSql += N'										AND	   A.PLAN_TYPE = ''RELEASE''                                                                                                                            ' + char(10)
		SET @v_dSql += N'										GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                 ' + char(10)
		--SET @v_dSql += N'										       , A.ITEM_ID, A.MARKET, CONVERT(VARCHAR,A.PLAN_DATE,112)                                                                                              ' + char(10)
		SET @v_dSql += N'										       , ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID), A.MARKET, CONVERT(VARCHAR,A.PLAN_DATE,112) ' + char(10) -- cell assy code 추가... 20230612
		SET @v_dSql += N'										UNION ALL                                                                                                                                                   ' + char(10)
		SET @v_dSql += N'			          					SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                  ' + char(10)
		SET @v_dSql += N'										         , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                                           ' + char(10)
		--SET @v_dSql += N'										         , A.ITEM_ID                                                                                                                                        ' + char(10)
		SET @v_dSql += N'										         , ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) AS ITEM_ID ' + char(10) -- cell assy code 추가... 20230612
		SET @v_dSql += N'										         , NULL AS STORAGE_ID, NULL AS SOC_ID                                                                                                               ' + char(10)
		SET @v_dSql += N'										         , A.MARKET, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                          ' + char(10)
		SET @v_dSql += N'										         , ''Result'' AS PSI                                                                                                                                ' + char(10)
		SET @v_dSql += N'										         , SUM(A.ACTUAL_GOOD_QTY) AS QTY                                                                                                                    ' + char(10)
		SET @v_dSql += N'										FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)                                                                                ' + char(10)
		SET @v_dSql += N'										LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V H WITH(NOLOCK) ' + char(10) -- cell assy code 추가... 20230612
		SET @v_dSql += N'										ON  A.COMPANY_ID  = H.COMPANY_ID ' + char(10)
		SET @v_dSql += N'										AND A.DIVISION_ID = H.DIVISION_ID ' + char(10)
		SET @v_dSql += N'										AND A.SITE_ID     = H.SITE_ID ' + char(10)
		SET @v_dSql += N'										AND A.ITEM_ID     = H.CELL_ASSY_ITEM_ID ' + char(10)
		SET @v_dSql += N'										WHERE  1=1                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += N'										AND	   A.SITE_ID = (SELECT DISTINCT SITE_ID FROM #INSTANCE_T)                                                                                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += N'										AND    A.OPERATION_ID = ''F6000''                                                                                                                           ' + char(10)
		SET @v_dSql += N'										AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                               ' + char(10)
		SET @v_dSql += N'										AND    A.ACTUAL_GOOD_QTY > 0                                                                                                                                ' + char(10)
		SET @v_dSql += N'										GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                 ' + char(10)
		--SET @v_dSql += N'										       	, A.ITEM_ID, A.MARKET, CONVERT(VARCHAR,A.PLAN_DATE,112)                                                                                             ' + char(10)
		SET @v_dSql += N'										       	, ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID), A.MARKET, CONVERT(VARCHAR,A.PLAN_DATE,112) ' + char(10) -- cell assy code 추가... 20230612
		SET @v_dSql += N'										UNION ALL                                                                                                                                                   ' + char(10)
		SET @v_dSql += N'										SELECT A.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID                                                                                                   ' + char(10)
		SET @v_dSql += N'										     , B.REF_DIVISION_ID, B.REF_SITE_ID, B.REF_PLANT_ID                                                                                                     ' + char(10)
		SET @v_dSql += N'										     , ISNULL(C.GROUP_ITEM_ID, A.ITEM_ID) AS ITEM_ID                                                                                                        ' + char(10)
		SET @v_dSql += N'										     , NULL AS STORAGE_ID, NULL AS SOC_ID, A.MARKET                                                                                                         ' + char(10)
		SET @v_dSql += N'										     , '''+ @p_bucket_from +''' AS PLAN_DATE, ''P(CMA)'' AS PSI, 0 AS QTY                                                                                              ' + char(10)
		SET @v_dSql += N'										FROM   FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)                                                                                                                ' + char(10)
		SET @v_dSql += N'										INNER JOIN (                                                                                                                                                ' + char(10)
		SET @v_dSql += N'										            SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID                                                          ' + char(10)
		SET @v_dSql += N'										                  , A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID                                              ' + char(10)
		SET @v_dSql += N'										            FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)               ' + char(10)
		SET @v_dSql += N'										            WHERE  A.LOOKUP_TYPE_CODE = ''FORMATION_PACK_INSTANCE_MAP''                                                                                     ' + char(10)
		SET @v_dSql += N'										            AND    A.ACTIVE_FLAG = ''Y''                                                                                                                    ' + char(10)
		SET @v_dSql += N'										) B                                                                                                                                                         ' + char(10)
		SET @v_dSql += N'										ON  A.DIVISION_ID  = B.REF_DIVISION_ID                                                                                                                      ' + char(10)
		SET @v_dSql += N'										AND A.SITE_ID      = B.REF_SITE_ID                                                                                                                          ' + char(10)
		SET @v_dSql += N'										AND A.PLANT_ID     = B.REF_PLANT_ID                                                                                                                         ' + char(10)
		SET @v_dSql += N'										INNER JOIN (                                                                                                                                                ' + char(10)
		SET @v_dSql += N'										  SELECT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID, A.SEGMENT3 AS SOC_ID, ATTRIBUTE3 AS SORT_ORDER                                                   ' + char(10)
		SET @v_dSql += N'										  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                ' + char(10)
		SET @v_dSql += N'										  WHERE  A.LOOKUP_TYPE_CODE = ''PACK_SOC''                                                                                                                  ' + char(10)
		SET @v_dSql += N'										  AND    A.ACTIVE_FLAG = ''Y''                                                                                                                              ' + char(10)
		SET @v_dSql += N'										) DD                                                                                                                                                        ' + char(10)
		SET @v_dSql += N'										ON  A.DIVISION_ID = DD.DIVISION_ID                                                                                                                          ' + char(10)
		SET @v_dSql += N'										AND A.SITE_ID     = DD.SITE_ID                                                                                                                              ' + char(10)
		SET @v_dSql += N'										AND A.SOC_ID      = DD.SOC_ID                                                                                                                               ' + char(10)
		SET @v_dSql += N'										LEFT OUTER JOIN (                                                                                                                                           ' + char(10)
		SET @v_dSql += N'														SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID                                 ' + char(10)
		SET @v_dSql += N'														FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                  ' + char(10)
		SET @v_dSql += N'														WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                                           ' + char(10)
		SET @v_dSql += N'														AND    A.ACTIVE_FLAG = ''Y''                                                                                                                ' + char(10)
		SET @v_dSql += N'														UNION                                                                                                                                      ' + char(10)
		SET @v_dSql += N'														SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT4 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID                                 ' + char(10)
		SET @v_dSql += N'														FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                  ' + char(10)
		SET @v_dSql += N'														WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                                           ' + char(10)
		SET @v_dSql += N'														AND    A.ACTIVE_FLAG = ''Y''                                                                                                                ' + char(10)
		SET @v_dSql += N'    									) C                                                                                                                                                         ' + char(10)
		SET @v_dSql += N'    									ON  A.DIVISION_ID = C.DIVISION_ID                                                                                                                           ' + char(10)
		SET @v_dSql += N'    									AND A.SITE_ID = C.SITE_ID                                                                                                                                   ' + char(10)
		SET @v_dSql += N'    									AND A.ITEM_ID = C.ITEM_ID	                                                                                                                                ' + char(10)
		SET @v_dSql += N'										WHERE  1=1                                                                                                                                                  ' + char(10)
		SET @v_dSql += N'										AND A.CATEGORY = ''REQUEST''                                                                                                                                ' + char(10)
		SET @v_dSql += N'										AND A.INSTANCE_ID = '''+ @p_pack_instance_id +'''                                                                                                                      ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.REF_PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += N'	        							AND CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                                  ' + char(10)
		SET @v_dSql += N'										UNION ALL                                                                                                                                                   ' + char(10)
		SET @v_dSql += N'										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                   ' + char(10)
		SET @v_dSql += N'										     , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                                               ' + char(10)
		SET @v_dSql += N'										     , ISNULL(B.ITEM_ID, A.ITEM_ID) AS ITEM_ID                                                                                                              ' + char(10)
		SET @v_dSql += N'										     , NULL AS STORAGE_ID, NULL AS SOC_ID, A.MARKET                                                                                                         ' + char(10)
		SET @v_dSql += N'										     , '''+ @p_bucket_from +''' AS PLAN_DATE, ''P(FORM)'' AS PSI, 0 AS QTY                                                             ' + char(10)
		SET @v_dSql += N'										FROM FP_CELL_DELIVERY_PLAN_H A WITH(NOLOCK)                                                                                                                 ' + char(10)
		SET @v_dSql += N'										LEFT OUTER JOIN (                                                                                                                                           ' + char(10)
		SET @v_dSql += N'										      SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID                                           ' + char(10)
		SET @v_dSql += N'										      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                            ' + char(10)
		SET @v_dSql += N'										      WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                                                     ' + char(10)
		SET @v_dSql += N'										      AND    A.ACTIVE_FLAG = ''Y''                                                                                                                          ' + char(10)
		SET @v_dSql += N'										 ) B                                                                                                                                                        ' + char(10)
		SET @v_dSql += N'    									ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                                           ' + char(10)
		SET @v_dSql += N'    									AND A.SITE_ID = B.SITE_ID                                                                                                                                   ' + char(10)
		SET @v_dSql += N'    									AND A.ITEM_ID = B.GROUP_ITEM_ID	                                                                                                                            ' + char(10)
		SET @v_dSql += N'										WHERE  1=1                                                                                                                                                  ' + char(10)
		SET @v_dSql += N'										AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                           ' + char(10)
		SET @v_dSql += N'										AND A.PLAN_ID = '''+ @p_plan_id +'''                                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += N'										AND CONVERT(VARCHAR,A.DELIVERY_DATE,112) BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +'''                                                                                ' + char(10)
		SET @v_dSql += N'										UNION ALL                                                                                                                                                   ' + char(10)
		SET @v_dSql += N'										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                   ' + char(10)
		SET @v_dSql += N'										     , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID                                                               ' + char(10)
		SET @v_dSql += N'										     , ISNULL(B.ITEM_ID, A.ITEM_ID) AS ITEM_ID               ' + char(10)
		SET @v_dSql += N'										     , NULL AS STORAGE_ID, NULL AS SOC_ID, A.MARKET                                                                                                         ' + char(10)
		SET @v_dSql += N'										     , '''+ @p_bucket_from +''' AS PLAN_DATE, ''P(FORM)'' AS PSI, 0 AS QTY                                                                                             ' + char(10)
		SET @v_dSql += N'										FROM FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)                                                                                                                  ' + char(10)
		SET @v_dSql += N'										LEFT OUTER JOIN (                                                                                                                                           ' + char(10)
		SET @v_dSql += N'										      SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID                                           ' + char(10)
		SET @v_dSql += N'										      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                            ' + char(10)
		SET @v_dSql += N'										      WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                                                     ' + char(10)
		SET @v_dSql += N'										      AND    A.ACTIVE_FLAG = ''Y''                                                                                                                          ' + char(10)
		SET @v_dSql += N'										 ) B                                                                                                                                                        ' + char(10)
		SET @v_dSql += N'    									ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                                           ' + char(10)
		SET @v_dSql += N'    									AND A.SITE_ID = B.SITE_ID                                                                                                                                   ' + char(10)
		SET @v_dSql += N'    									AND A.ITEM_ID = B.GROUP_ITEM_ID	                                                                                                                            ' + char(10)
		SET @v_dSql += N'										WHERE  1=1                                                                                                                                                  ' + char(10)
		SET @v_dSql += N'										AND A.CATEGORY = ''MOVING''                                                                                                                                 ' + char(10)
		SET @v_dSql += N'										AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += N'										AND CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_plan_date +''' - 1                                                                              ' + char(10)
		SET @v_dSql += N'					) A                                                                                                                                                                 ' + char(10)
		SET @v_dSql += N'					LEFT OUTER JOIN (                                                                                                                                                   ' + char(10)
		SET @v_dSql += N'		                              SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER                         ' + char(10)
		SET @v_dSql += N'		                              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                        ' + char(10)
		SET @v_dSql += N'		                              WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                                                                                                 ' + char(10)
		SET @v_dSql += N'		                              AND    A.ACTIVE_FLAG = ''Y''                                                                                                                      ' + char(10)
		SET @v_dSql += N'		                            ) B                                                                                                                                                 ' + char(10)
		SET @v_dSql += N'		            ON  A.DIVISION_ID = B.DIVISION_ID                                                                                                                                   ' + char(10)
		SET @v_dSql += N'		            AND A.SITE_ID = B.SITE_ID                                                                                                                                           ' + char(10)
		SET @v_dSql += N'		            AND A.ITEM_ID = B.ITEM_ID	                                                                                                                                        ' + char(10)
		SET @v_dSql += N'	            inner join #T_CHECK AA on 1 = 1 ' + char(10) --Tuning block_13
		SET @v_dSql += N'								AND A.COMPANY_ID  = AA.COMPANY_ID                                                                                                                       ' + char(10)
		SET @v_dSql += N'								AND A.DIVISION_ID  = AA.DIVISION_ID                                                                                                                     ' + char(10)
		SET @v_dSql += N'								AND A.SITE_ID  = AA.SITE_ID                                                                                                                             ' + char(10)
		SET @v_dSql += N'								AND A.PLANT_ID  = AA.PLANT_ID                                                                                                                           ' + char(10)
		SET @v_dSql += N'								AND ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID) = AA.GROUP_ITEM_ID                                                                                               ' + char(10)
		SET @v_dSql += N'								AND A.ITEM_ID  = AA.ITEM_ID                                                                                                                             ' + char(10)
		SET @v_dSql += N'				WHERE 1 = 1 ' + char(10) --Tuning block_14
		SET @v_dSql += N'		      ) A                                                                                                                                                                       ' + char(10)
		SET @v_dSql += N'	         --     INNER JOIN (                                                                                                                                                        ' + char(10)
		SET @v_dSql += N'		     --         SELECT ''P(FORM)'' AS PSI, 100 AS CATEGORY_ORDER                                                                                                                ' + char(10)
		SET @v_dSql += N'		     --         UNION ALL                                                                                                                                                       ' + char(10)
		SET @v_dSql += N'		     --         SELECT ''P(CMA)'' AS PSI, 110 AS CATEGORY_ORDER                                                                                                                 ' + char(10)
		SET @v_dSql += N'	         --    ) B                                                                                                                                                                  ' + char(10)
		SET @v_dSql += N'	         --     ON 1=1                                                                                                                                                              ' + char(10)
		SET @v_dSql += N'	         		LEFT OUTER HASH JOIN (                                                                                                                                              ' + char(10)
		SET @v_dSql += N'	         				SELECT * FROM 	#TEMP_TABLE_01 	                                                                                        ' + char(10)
		SET @v_dSql += N'	         				WHERE	1=1                                                                                                                                                 ' + char(10)
		SET @v_dSql += N'	         				AND		STOCK_FLAG = ''PACK''                                                                                                                               ' + char(10)
		SET @v_dSql += N'			        ) D                                                                                                                                                                 ' + char(10)
		SET @v_dSql += N'			        ON  A.COMPANY_ID   = D.COMPANY_ID                                                                                                                                   ' + char(10)
		SET @v_dSql += N'			        AND A.DIVISION_ID  = D.DIVISION_ID                                                                                                                                  ' + char(10)
		SET @v_dSql += N'			        AND A.SITE_ID      = D.SITE_ID                                                                                                                                      ' + char(10)
		SET @v_dSql += N'			        AND A.PLANT_ID     = D.PLANT_ID                                                                                                                                     ' + char(10)
		SET @v_dSql += N'			        AND A.ITEM_ID 	   = D.ITEM_ID                                                                                                                                      ' + char(10)
		SET @v_dSql += N'			        AND A.PSI 		   IN (''P(FORM)'',''Result'')                                                                                                                      ' + char(10)
		SET @v_dSql += N'			        LEFT OUTER HASH JOIN (                                                                                                                                              ' + char(10)
		SET @v_dSql += N'			        		SELECT * FROM 	#TEMP_TABLE_01 	                                                                                        ' + char(10)
		SET @v_dSql += N'	         				WHERE	1=1                                                                                                                                                 ' + char(10)
		SET @v_dSql += N'	         				AND		STOCK_FLAG = ''CELL''                                                                                                                               ' + char(10)
		SET @v_dSql += N'			        ) E                                                                                                                                                                 ' + char(10)
		SET @v_dSql += N'			        ON  A.COMPANY_ID   = E.COMPANY_ID                                                                                                                                   ' + char(10)
		SET @v_dSql += N'			        AND A.DIVISION_ID  = E.DIVISION_ID                                                                                                                                  ' + char(10)
		SET @v_dSql += N'			        AND A.SITE_ID      = E.SITE_ID                                                                                                                                      ' + char(10)
		SET @v_dSql += N'			        AND A.PLANT_ID     = E.PLANT_ID                                                                                                                                     ' + char(10)
		SET @v_dSql += N'			        AND A.GROUP_ITEM_ID = E.GROUP_ITEM_ID                                                                                                                               ' + char(10)
		SET @v_dSql += N'			        AND A.PSI = ''P(CMA)''                                                                                                                                              ' + char(10)
		SET @v_dSql += N'	 	    ) A                                                                                                                                                                         ' + char(10)
		SET @v_dSql += N'	INNER JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'	ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                                                                                        ' + char(10)
		SET @v_dSql += N'	AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                       ' + char(10)
		SET @v_dSql += N'	AND A.SITE_ID     = B.SITE_ID                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'	AND A.ITEM_ID     = B.ITEM_ID                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'	AND B.ACTIVE_FLAG = ''Y''                                                                                                                                                               ' + char(10)
		SET @v_dSql += N'	INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                                                                                               ' + char(10)
		SET @v_dSql += N'	ON  A.PLAN_DATE   = C.YYYYMMDD                                                                                                                                                          ' + char(10)
		SET @v_dSql += N'	WHERE 1=1                                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.GROUP_ITEM_ID' , 'LIKE', @p_group_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SET @v_dSql += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                             ' + char(10)
		SET @v_dSql += N'	       , A.REF_DIVISION_ID, A.REF_SITE_ID, A.REF_PLANT_ID                                                                                                                               ' + char(10)
		SET @v_dSql += N'	       , A.GROUP_ITEM_ID                                                                                                                                                                ' + char(10)
		SET @v_dSql += N'	       --, A.ITEM_ID, ISNULL(B.NICK_NAME,''-''), ISNULL(D.QTY,0)                                                                                                                        ' + char(10)
		SET @v_dSql += N'	       , CASE WHEN A.PSI = ''P(FORM)'' OR A.PSI = ''Result'' THEN A.ITEM_ID ELSE NULL END                                                                                               ' + char(10)
		SET @v_dSql += N'	       , CASE WHEN A.PSI = ''P(FORM)'' OR A.PSI = ''Result'' THEN ISNULL(B.NICK_NAME,''-'') ELSE NULL END                                                                               ' + char(10)
		SET @v_dSql += N'	       --, CASE WHEN A.PSI = ''P(FORM)'' THEN ISNULL(D.QTY,0) ELSE ISNULL(E.QTY,0) END                                                                                                  ' + char(10)
		SET @v_dSql += N'	       , A.TOTAL_QTY                                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'	       , A.AVAIL_QTY                                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'	       , A.HOLD_QTY                                                                                                                                                                     ' + char(10)
		SET @v_dSql += N'	       , A.AVAIL_CELL_LONG_QTY, A.HOLD_CELL_LONG_QTY                                                                                                                                    ' + char(10)
		SET @v_dSql += N'	       , A.INTRANSIT                                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'	       , A.STORAGE_ID, A.PSI, A.SOC_ID, A.MARKET                                                                                                                                        ' + char(10)
		SET @v_dSql += N'	       , A.GROUP_ORDER                                                                                                                                                                  ' + char(10)
		SET @v_dSql += N'	) A; ' + char(10) --Tuning block_15
		SET @v_dSql += N'with MAIN_P AS (' + char(10) --Tuning block_15
		SET @v_dSql += N'		SELECT	*                                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'		FROM   #TEMP_TABLE_04 A WITH(NOLOCK)                                                                                                               ' + char(10)
		SET @v_dSql += N'	)                                                                                                                                                                                       ' + char(10)
		SET @v_dSql += N'	, MAIN_I AS (                                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'		SELECT	*                                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'		FROM   #TEMP_TABLE_03 A WITH(NOLOCK)                                                                                                               ' + char(10)
		SET @v_dSql += N'	)                                                                                                                                                                                       ' + char(10)
		SET @v_dSql += N'	, SUB_S AS (                                                                                                                                                                            ' + char(10)
		SET @v_dSql += N'		SELECT	*                                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'		FROM   #TEMP_TABLE_05 A WITH(NOLOCK)                                                                                                               ' + char(10)
		SET @v_dSql += N'	)                                                                                                                                                                                       ' + char(10)
		SET @v_dSql += N'	SELECT A.*                                                                                                                                                                              ' + char(10)
		SET @v_dSql += N'	   , DENSE_RANK() OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.GROUP_ITEM_ID ) AS LV1                                                                           ' + char(10)
		SET @v_dSql += N'	   , MAX(A.STORAGE_ID) OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ) AS ERPSLOC                                                                    ' + char(10)
		SET @v_dSql += N'	   , CASE WHEN A.DATA_TYPE = ''DATA'' AND CHARINDEX(''DO'',PSI) > 0 AND R.PLANT_ID IS NOT NULL AND S.CONFIRM_YN = ''Y'' THEN ''Y'' ELSE ''N'' END AS E_YN                               ' + char(10)
		SET @v_dSql += N'	   , CASE WHEN A.DATA_TYPE = ''DATA'' AND A.ITEM_ID IS NOT NULL THEN ISNULL(B.MOQ, 0) ELSE NULL END AS MOQ                                                                              ' + char(10)
		SET @v_dSql += N'	   , CASE WHEN R.PLANT_ID IS NULL THEN ''N'' ELSE ''Y'' END EDIT_YN                                                                                                                     ' + char(10)
		SET @v_dSql += N'	   , ISNULL(T.CELL_ASSY_ITEM_ID, ''-'') AS ASSY_ITEM_ID ' + char(10) -- cell assy code 추가... 20230612

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

					SELECT @v_dSql += N'				, CASE	WHEN A.DATA_TYPE=''TOTAL_2'' THEN ''#FFBA85''         ' + char(10)
					SELECT @v_dSql += N'						WHEN A.DATA_TYPE=''TOTAL'' THEN ''#FFE5C2'' ' + char(10)
					SELECT @v_dSql += N'       					WHEN ''' + @sub_param_0 + ''' >= '''+ @p_plan_date +''' THEN ( CASE WHEN A.DATA_TYPE = ''DATA'' AND R.PLANT_ID IS NOT NULL AND PSI = ''DO(Cell Deli.)'' AND S.CONFIRM_YN = ''Y'' THEN ''#FFFF0055'' ELSE '''' END )    ' + char(10)
					SELECT @v_dSql += N'      					ELSE '''' END AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_BG ' + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SET @v_dSql += N'	FROM (                                                                                                                                                                                  ' + char(10)
		SET @v_dSql += N'			SELECT * FROM #MAIN_S' + char(10) --Tuning block_16
		SET @v_dSql += N'			UNION ALL                                                                                                                                                                               ' + char(10)
		SET @v_dSql += N'			SELECT * FROM MAIN_P                                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'			UNION ALL                                                                                                                                                                               ' + char(10)
		SET @v_dSql += N'			SELECT * FROM SUB_S                                                                                                                                                                     ' + char(10)
		SET @v_dSql += N'			UNION ALL                                                                                                                                                                               ' + char(10)
		SET @v_dSql += N'			SELECT * FROM MAIN_I                                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'			    UNION ALL                                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'			SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID                                                                                                       ' + char(10)
		SET @v_dSql += N'				   , NULL AS REF_DIVISION_ID, NULL AS REF_SITE_ID, NULL AS REF_PLANT_ID                                                                                                             ' + char(10)
		SET @v_dSql += N'			     , NULL AS GROUP_ITEM_ID, NULL AS ITEM_ID, NULL AS NICK_NAME                                                                                                                        ' + char(10)
		SET @v_dSql += N'			     , NULL AS BOH_QTY, NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                          ' + char(10)
		SET @v_dSql += N'			     , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY                                                                                                                          ' + char(10)
		SET @v_dSql += N'			     , NULL AS INTRANSIT, NULL AS STORAGE_ID, A.PSI, NULL AS SOC_ID, NULL AS MARKET                                                                                                     ' + char(10)
		SET @v_dSql += N'			     , A.CATEGORY_ID                                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'			     , 10 AS CATEGORY_ORDER                                                                                                                                                             ' + char(10)
		SET @v_dSql += N'			     , ''TOTAL_2'' AS DATA_TYPE                                                                                                                                                         ' + char(10)
		SET @v_dSql += N'			     , 10 AS GROUP_SORT                                                                                                                                                                 ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SET @v_dSql += N'			FROM   #MAIN_S A ' + char(10) --Tuning block_17
		SELECT @v_dSql += @total
		SET @v_dSql += N'			GROUP BY A.PSI, A.CATEGORY_ID                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'			UNION ALL                                                                                                                                                                               ' + char(10)
		SET @v_dSql += N'			SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID                                                                                                       ' + char(10)
		SET @v_dSql += N'				   , NULL AS REF_DIVISION_ID, NULL AS REF_SITE_ID, NULL AS REF_PLANT_ID                                                                                                             ' + char(10)
		SET @v_dSql += N'			     , NULL AS GROUP_ITEM_ID, NULL AS ITEM_ID, NULL AS NICK_NAME                                                                                                                        ' + char(10)
		SET @v_dSql += N'			     , NULL AS BOH_QTY, NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                          ' + char(10)
		SET @v_dSql += N'			     , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY                                                                                                                          ' + char(10)
		SET @v_dSql += N'			     , NULL AS INTRANSIT, NULL AS STORAGE_ID, A.PSI, A.SOC_ID, NULL AS MARKET                                                                                                           ' + char(10)
		SET @v_dSql += N'			     , A.CATEGORY_ID                                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'			     , 20 AS CATEGORY_ORDER                                                                                                                                                             ' + char(10)
		SET @v_dSql += N'			     , ''TOTAL_2'' AS DATA_TYPE                                                                                                                                                         ' + char(10)
		SET @v_dSql += N'			     , 20 AS GROUP_SORT                                                                                                                                                                 ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SET @v_dSql += N'			FROM   MAIN_P A                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += @total
		SET @v_dSql += N'			GROUP BY A.PSI, A.SOC_ID, A.CATEGORY_ID                                                                                                                                                 ' + char(10)
		SET @v_dSql += N'			UNION ALL                                                                                                                                                                               ' + char(10)
		SET @v_dSql += N'			SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID                                                                                                       ' + char(10)
		SET @v_dSql += N'			     , NULL AS REF_DIVISION_ID, NULL AS REF_SITE_ID, NULL AS REF_PLANT_ID                                                                                                               ' + char(10)
		SET @v_dSql += N'			     , NULL AS GROUP_ITEM_ID, NULL AS ITEM_ID, NULL AS NICK_NAME                                                                                                                        ' + char(10)
		SET @v_dSql += N'			     , NULL AS BOH_QTY, NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                          ' + char(10)
		SET @v_dSql += N'			     , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY                                  ' + char(10)
		SET @v_dSql += N'			     , NULL AS INTRANSIT, NULL AS STORAGE_ID, A.PSI, NULL AS SOC_ID, NULL AS MARKET                                                                                                     ' + char(10)
		SET @v_dSql += N'			     , A.CATEGORY_ID                                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'			     , 30 AS CATEGORY_ORDER                                                                                                                                                             ' + char(10)
		SET @v_dSql += N'			     , ''TOTAL_2'' AS DATA_TYPE                                                                                                                                                         ' + char(10)
		SET @v_dSql += N'			     , 30 AS GROUP_SORT                                                                                                                                                                 ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(CONVERT(NUMERIC, A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +')) AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(CONVERT(NUMERIC, A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +')) AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SET @v_dSql += N'			FROM   SUB_S A                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += @total
		SET @v_dSql += N'			GROUP BY A.PSI, A.CATEGORY_ID                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'			UNION ALL                                                                                                                                                                               ' + char(10)
		SET @v_dSql += N'			SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID                                                                                                       ' + char(10)
		SET @v_dSql += N'			     , NULL AS REF_DIVISION_ID, NULL AS REF_SITE_ID, NULL AS REF_PLANT_ID                                                                                                               ' + char(10)
		SET @v_dSql += N'			     , NULL AS GROUP_ITEM_ID, NULL AS ITEM_ID, NULL AS NICK_NAME                                                                                                                        ' + char(10)
		SET @v_dSql += N'			     , NULL AS BOH_QTY, NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                          ' + char(10)
		SET @v_dSql += N'			     , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY                                                                                                                          ' + char(10)
		SET @v_dSql += N'			     , NULL AS INTRANSIT, NULL AS STORAGE_ID, A.PSI, NULL AS SOC_ID, NULL AS MARKET                                                                                                     ' + char(10)
		SET @v_dSql += N'			     , A.CATEGORY_ID                                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'			     , 40 AS CATEGORY_ORDER                                                                                                                                                             ' + char(10)
		SET @v_dSql += N'			     , ''TOTAL_2'' AS DATA_TYPE                                                                                                                                                         ' + char(10)
		SET @v_dSql += N'			     , 40 AS GROUP_SORT                                                                                                                                                                 ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(CONVERT(NUMERIC, A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +')) AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(CONVERT(NUMERIC, A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +')) AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		
		SET @v_dSql += N'			FROM   MAIN_I A                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += @total
		SET @v_dSql += N'			GROUP BY A.PSI, A.CATEGORY_ID                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'	) A                                                                                                                                                                                     ' + char(10)
		SET @v_dSql += N'		      LEFT OUTER JOIN (                                                                                                                                                             ' + char(10)
		SET @v_dSql += N'		      					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                   ' + char(10)
		SET @v_dSql += N'							         , A.ITEM_ID                                                                                                                                            ' + char(10)
		SET @v_dSql += N'							         , A.STORAGE_ID, A.SOC_ID, A.MARKET                                                                                                                     ' + char(10)
		SET @v_dSql += N'							         , MAX(A.MOQ) AS MOQ                                                                                                                                    ' + char(10)
		SET @v_dSql += N'							    FROM FP_CELL_DELIVERY_PLAN_H A WITH(NOLOCK)                                                                                                                 ' + char(10)
		SET @v_dSql += N'							    WHERE  1=1                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += N'								AND CONVERT(VARCHAR,A.DELIVERY_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                              ' + char(10)
		SET @v_dSql += N'								GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                 ' + char(10)
		SET @v_dSql += N'							         , A.ITEM_ID                                                                                                                                            ' + char(10)
		SET @v_dSql += N'							         , A.STORAGE_ID, A.SOC_ID, A.MARKET                                                                                                                     ' + char(10)
		SET @v_dSql += N'			  ) B                                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'			  ON  A.COMPANY_ID  	= B.COMPANY_ID                                                                                                                                          ' + char(10)
		SET @v_dSql += N'			  AND A.DIVISION_ID 	= B.DIVISION_ID                                                                                                                                         ' + char(10)
		SET @v_dSql += N'			  AND A.SITE_ID     	= B.SITE_ID                                                                                                                                             ' + char(10)
		SET @v_dSql += N'			  AND A.PLANT_ID     	= B.PLANT_ID                                                                                                                                            ' + char(10)
		SET @v_dSql += N'			  AND A.ITEM_ID 		= B.ITEM_ID                                                                                                                                             ' + char(10)
		SET @v_dSql += N'			  AND A.STORAGE_ID 		= B.STORAGE_ID                                                                                                                                          ' + char(10)
		SET @v_dSql += N'			  AND A.SOC_ID 			= B.SOC_ID                                                                                                                                              ' + char(10)
		SET @v_dSql += N'			  --AND A.MARKET 			= B.MARKET                                                                                                                                          ' + char(10)
		SET @v_dSql += N'			  LEFT OUTER JOIN (                                                                                                                                                             ' + char(10)
		SET @v_dSql += N'						SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID                                                                                                 ' + char(10)
		SET @v_dSql += N'						FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                                                          ' + char(10)
		SET @v_dSql += N'						WHERE	1=1                                                                                                                                                         ' + char(10)
		SET @v_dSql += N'						AND		R.USER_ID	= '''+ @p_user_id +'''                                                                                                                                     ' + char(10)
		SET @v_dSql += N'						AND		R.SAVE_FLAG	= ''Y''                                                                                                                                         ' + char(10)
		SET @v_dSql += N'				) R                                                                                                                                                                         ' + char(10)
		SET @v_dSql += N'				ON		1=1                                                                                                                                                                 ' + char(10)
		SET @v_dSql += N'				AND		A.COMPANY_ID		= R.COMPANY_ID                                                                                                                                  ' + char(10)
		SET @v_dSql += N'				AND		A.DIVISION_ID		= R.DIVISION_ID                                                                                                                                 ' + char(10)
		SET @v_dSql += N'				AND		A.SITE_ID			= R.SITE_ID                                                                                                                                     ' + char(10)
		SET @v_dSql += N'				AND		A.PLANT_ID			= R.PLANT_ID                                                                                                                                    ' + char(10)
		SET @v_dSql += N'			LEFT OUTER JOIN (                                                                                                                                                               ' + char(10)
		SET @v_dSql += N'						SELECT A.PLAN_ID, B.MAX_PLAN_ID                                                                                                                                     ' + char(10)
		SET @v_dSql += N'						      , CASE WHEN A.PLAN_ID <= B.MAX_PLAN_ID THEN ''N'' ELSE ''Y'' END AS CONFIRM_YN                                                                                ' + char(10)
		SET @v_dSql += N'						FROM SCM_FP_IN_HOUSE_PLAN_H A                                                                                                                                       ' + char(10)
		SET @v_dSql += N'						    , (                                                                                                                                                             ' + char(10)
		SET @v_dSql += N'						        SELECT MAX(PLAN_ID) AS MAX_PLAN_ID                                                                                                                          ' + char(10)
		SET @v_dSql += N'						        FROM SCM_FP_IN_HOUSE_PLAN_H A                                                                                                                               ' + char(10)
		SET @v_dSql += N'						        WHERE 1=1                                                                                                                                                   ' + char(10)
		SET @v_dSql += N'						        AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                           ' + char(10)
		SET @v_dSql += N'						        AND A.CONFIRM_FLAG = ''Y''                                                            ' + char(10)
		SET @v_dSql += N'						      ) B                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'						WHERE 1=1                                                                                                                                                           ' + char(10)
		SET @v_dSql += N'						AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                   ' + char(10)
		SET @v_dSql += N'						AND A.PLAN_ID = '''+ @p_plan_id +'''                                                                                                                                           ' + char(10)
		SET @v_dSql += N'			) S                                                                                                                                                                             ' + char(10)
		SET @v_dSql += N'				ON 1=1                                                                                                                                                                      ' + char(10)
		-- cell assy code 추가... 20230612
		SET @v_dSql += N'	LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V T WITH(NOLOCK) ' + char(10)
		SET @v_dSql += N'	ON 1=1 ' + char(10)
		SET @v_dSql += N'	AND A.COMPANY_ID  = T.COMPANY_ID ' + char(10)
		SET @v_dSql += N'	AND A.DIVISION_ID = T.DIVISION_ID ' + char(10)
		SET @v_dSql += N'	AND A.SITE_ID     = T.SITE_ID ' + char(10)
		SET @v_dSql += N'	AND A.ITEM_ID     = T.CELL_PRODUCT_ITEM_ID ' + char(10)
		
		SET @v_dSql += N'	WHERE 1=1                                                                                                                                                                               ' + char(10)
		
		IF @p_line_assign = 'Y' BEGIN
			SELECT @v_dSql += N'					AND    EXISTS ( SELECT 1 									 ' + char(10)
			SELECT @v_dSql += N'									FROM SCM_ITEM_LINE_ASSIGN_M AA WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql += N'									WHERE	1=1									 ' + char(10)
			SELECT @v_dSql += N'									AND		AA.DIVISION_ID = A.DIVISION_ID		 ' + char(10)
			SELECT @v_dSql += N'									AND		AA.SITE_ID = A.SITE_ID				 ' + char(10)
			SELECT @v_dSql += N'									AND		AA.PLANT_ID = A.PLANT_ID			 ' + char(10)
			SELECT @v_dSql += N'									AND		AA.ITEM_ID = A.GROUP_ITEM_ID	     ' + char(10)
			SELECT @v_dSql += N'									AND		AA.MONTH = CONVERT(VARCHAR(6), '''+ @p_plan_date +''')	' + char(10)
			SELECT @v_dSql += N'									AND		AA.PRIORITY NOT IN (0,9)			 ' + char(10)
			SELECT @v_dSql += N'									AND		AA.ACTIVE_FLAG = ''Y''				 ' + char(10)
			SELECT @v_dSql += N'								   )	         ' + char(10)
		END

		SET @v_dSql += N'	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                             ' + char(10)
		SET @v_dSql += N'	     , A.GROUP_ITEM_ID                                                                                                                                                                  ' + char(10)
		SET @v_dSql += N'	     , (CASE WHEN A.CATEGORY_ID=''S'' THEN 1 WHEN A.CATEGORY_ID=''P'' THEN 2 WHEN A.CATEGORY_ID=''SS'' THEN 3WHEN A.CATEGORY_ID=''I'' THEN 999 ELSE 100 END)                            ' + char(10)
		SET @v_dSql += N'	     , A.STORAGE_ID                                                                                                                                                                     ' + char(10)
		SET @v_dSql += N'	     , A.GROUP_ORDER                                                                                                                                                                    ' + char(10)
		SET @v_dSql += N'	     , A.CATEGORY_ORDER                                                                                                                                                                 ' + char(10)
		SET @v_dSql += N'	     , A.ITEM_ID                                                                                                                                                                        ' + char(10)
		SET @v_dSql += N'	     --, (CASE WHEN DATA_TYPE=''DATA'' THEN 1 ELSE 999 END)                                                                                                                             ' + char(10)
		SET @v_dSql += N'	     --, (CASE WHEN A.CATEGORY_ID=''S'' THEN 1 WHEN A.CATEGORY_ID=''I'' THEN 999 ELSE 100 END)                                                                                          ' + char(10)
		SET @v_dSql += N'	     --, A.STORAGE_ID, A.MARKET, A.CATEGORY_ORDER                                                                                                                                       ' + char(10)

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
				--select @v_dSql
	             exec sp_executesql @v_dSql
		     COMMIT TRAN
		END TRY
        BEGIN CATCH
             ROLLBACK
        END CATCH
	    SET @runend = GetDate()
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend

    END
	
	BEGIN
		    IF OBJECT_ID('tempdb..#TEMP_TABLE_01') IS NOT NULL
		    DROP TABLE #TEMP_TABLE_01
		    
			IF OBJECT_ID('tempdb..#TEMP_TABLE_02') IS NOT NULL
		    DROP TABLE #TEMP_TABLE_02

			IF OBJECT_ID('tempdb..#TEMP_TABLE_03') IS NOT NULL
		    DROP TABLE #TEMP_TABLE_03

			IF OBJECT_ID('tempdb..#TEMP_TABLE_04') IS NOT NULL
		    DROP TABLE #TEMP_TABLE_04

			IF OBJECT_ID('tempdb..#TEMP_TABLE_05') IS NOT NULL
		    DROP TABLE #TEMP_TABLE_05
		  
		  IF OBJECT_ID('tempdb..#MAIN_S') IS NOT NULL  DROP TABLE #MAIN_S

		--IF OBJECT_ID('TEMP_TABLE_01') IS NOT NULL
		--      DROP TABLE TEMP_TABLE_01
		--IF OBJECT_ID('TEMP_TABLE_03') IS NOT NULL
		--      DROP TABLE TEMP_TABLE_03
		--IF OBJECT_ID('TEMP_TABLE_04') IS NOT NULL
		--      DROP TABLE TEMP_TABLE_04
		--IF OBJECT_ID('TEMP_TABLE_05') IS NOT NULL
		--      DROP TABLE TEMP_TABLE_05
  
	END
  
END

