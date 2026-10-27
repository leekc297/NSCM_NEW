

/*
 * Program ID   : PR_UI_FP00611_PLAN_BY_LINE_ASSY
 * Description  : Plan By Line(Assy)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/05/24   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00611_PLAN_BY_LINE_ASSY_TUNING]
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
	DECLARE @p_nick_name_lt	NVARCHAR(MAX);
	DECLARE @p_prod_type	NVARCHAR(MAX);
	DECLARE @p_prodtype_id	NVARCHAR(MAX);
	DECLARE @p_cate_info	NVARCHAR(MAX);
	DECLARE @p_cell_group	NVARCHAR(MAX);
	DECLARE @p_confirm_area	NVARCHAR(MAX);
	DECLARE @p_curr_date_col NVARCHAR(MAX);
	DECLARE @p_plan_type	NVARCHAR(MAX);

	DECLARE @p_curr_date_gap	NVARCHAR(MAX); -- 인스턴스별 현재일자를 구한다.

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
	DECLARE @tmp_GAP_lastCol	NVARCHAR(MAX); -- Gap(WPP) week, month 막날 용

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
		END ELSE IF @tmp_column = 'NICK_NAME_LT' BEGIN
			SET @p_nick_name_lt =		@tmp_value
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
	DECLARE @chk_gap	NVARCHAR(MAX);
	DECLARE @chk_gapWPP	NVARCHAR(MAX);

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

			-- GAP 카테고리 체크 여부
			IF @sub_param_0 = 'chk_gap' BEGIN
				IF @sub_param_1 = 'true' BEGIN
					SET @chk_gap = 'WHERE 1 =1' +char(10)
				END ELSE BEGIN
					SET @chk_gap = 'WHERE 1 =0' +char(10)
				END
			END 

			-- GAP(WPP) 카테고리 체크 여부
			IF @sub_param_0 = 'chk_gapWPP' BEGIN
				IF @sub_param_1 = 'true' BEGIN
					SET @chk_gapWPP = 'WHERE 1= 1' +char(10)
				END ELSE BEGIN
					SET @chk_gapWPP = 'WHERE 1= 0' +char(10)
				END
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

		-- GAP(WPP) 추가
		SELECT @v_dSql += N'if object_id(''tempdb..#MAIN_ITEM_WPP_GAP'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #MAIN_ITEM_WPP_GAP ' + char(10)
		SELECT @v_dSql += N'if object_id(''tempdb..#MAIN_GAP_WPP'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #MAIN_GAP_WPP ' + char(10)
		-- 임시테이블 추가
		SELECT @v_dSql += N'if object_id(''tempdb..#MAIN'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #MAIN ' + char(10)
		SELECT @v_dSql += N'if object_id(''tempdb..#MAIN_GAP'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #MAIN_GAP ' + char(10)
		SELECT @v_dSql += N'if object_id(''tempdb..#T_RELEASE'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #T_RELEASE ' + char(10)
		SELECT @v_dSql += N'if object_id(''tempdb..#T_RELEASE2'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #T_RELEASE2 ' + char(10)
		SELECT @v_dSql += N'if object_id(''tempdb..#FP_CELL_GROUP_V'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #FP_CELL_GROUP_V ' + char(10)
		-- 조회속도 관련 raw data 임시테이블 처리... 20231005
		SELECT @v_dSql += N'if object_id(''tempdb..#SCM_DAILY_PRODUCT_RESULT_H'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #SCM_DAILY_PRODUCT_RESULT_H ' + char(10)
		SELECT @v_dSql += N'if object_id(''tempdb..#FP_DAILY_PRODUCTIOIN_PLAN_H'') is not null ' + char(10)
		SELECT @v_dSql += N'	drop table #FP_DAILY_PRODUCTIOIN_PLAN_H ' + char(10)+char(10)
		SELECT @v_dSql += N'if object_id(''tempdb..#CATEGORY_ITEM'') is not null drop table #CATEGORY_ITEM' + char(10)
		/*
		-- cell group 정보 :: 속드 느려서 원복
		SELECT @v_dSql += N'SELECT J.COMPANY_ID, J.DIVISION_ID, J.SITE_ID, J.ITEM_ID, J.CELL_GROUP ' + char(10)
		SELECT @v_dSql += N'INTO   #FP_CELL_GROUP_V ' + char(10)
		SELECT @v_dSql += N'FROM   FP_CELL_GROUP_V J WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('J.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('J.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		*/
		SELECT @v_dSql += N'; ' + char(10)
--TUNING begin block_01
SELECT @v_dsql += 'select * into #CATEGORY_ITEM from (' + char(10)
SELECT @v_dsql += 'select ''P_IN'' CATEGORY_ID, ''UOM'' MEASURE_ID, ''DPP'' PLAN_TYPE, 1 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''P_IN'' CATEGORY_ID, ''CELL'' MEASURE_ID, ''DPP'' PLAN_TYPE, 0 IN_QTY, 1 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''P_OUT'' CATEGORY_ID, ''UOM'' MEASURE_ID, ''DPP'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 1 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''P_OUT'' CATEGORY_ID, ''CELL'' MEASURE_ID, ''DPP'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 1 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += '' + char(10)
SELECT @v_dsql += 'select ''W_IN'' CATEGORY_ID, ''UOM'' MEASURE_ID, ''WPP'' PLAN_TYPE, 1 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''W_IN'' CATEGORY_ID, ''CELL'' MEASURE_ID, ''WPP'' PLAN_TYPE, 0 IN_QTY, 1 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''W_OUT'' CATEGORY_ID, ''UOM'' MEASURE_ID, ''WPP'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 1 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''W_OUT'' CATEGORY_ID, ''CELL'' MEASURE_ID, ''WPP'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 1 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += '' + char(10)
SELECT @v_dsql += 'select ''M_IN'' CATEGORY_ID, ''UOM'' MEASURE_ID, ''MPP'' PLAN_TYPE, 1 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''M_IN'' CATEGORY_ID, ''CELL'' MEASURE_ID, ''MPP'' PLAN_TYPE, 0 IN_QTY, 1 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''M_OUT'' CATEGORY_ID, ''UOM'' MEASURE_ID, ''MPP'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 1 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''M_OUT'' CATEGORY_ID, ''CELL'' MEASURE_ID, ''MPP'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 1 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += '' + char(10)
SELECT @v_dsql += 'select ''RESULT'' CATEGORY_ID, ''UOM'' MEASURE_ID, ''2_FIELDS'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 1 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''RESULT'' CATEGORY_ID, ''CELL'' MEASURE_ID, ''2_FIELDS'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 1 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''RESULT_EXP'' CATEGORY_ID, ''UOM'' MEASURE_ID, ''2_FIELDS'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 1 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''RESULT_EXP'' CATEGORY_ID, ''CELL'' MEASURE_ID, ''2_FIELDS'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 1 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += '' + char(10)
SELECT @v_dsql += 'select ''CUT'' CATEGORY_ID, '''' MEASURE_ID, ''1_FIELD'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 1 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''TARGET'' CATEGORY_ID, '''' MEASURE_ID, ''1_FIELD'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 1 TARGET_QTY, 0 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''OFFTIME'' CATEGORY_ID, '''' MEASURE_ID, ''1_FIELD'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 1 OFF_TIME union all ' + char(10)
SELECT @v_dsql += 'select ''MEMO'' CATEGORY_ID, '''' MEASURE_ID, ''1_FIELD'' PLAN_TYPE, 0 IN_QTY, 0 CELL_IN_QTY, 0 OUT_QTY, 0 CELL_OUT_QTY, 0 RESULT_QTY, 0 RESULT_QTY_CELL, 0 RESULT_QTY2, 0 RESULT_QTY2_CELL, 0 CUT_QTY, 0 TARGET_QTY, 0 OFF_TIME' + char(10)
SELECT @v_dsql += ') A;' + char(10)
--TUNING end block_01
		SELECT @v_dSql += N'' + char(10)
		-- 조회속도 관련 raw data 임시테이블 처리... 20231005
		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'	 , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'	 , A.FP_PRODUCTION_TYPE, A.MARKET, A.PLM_EC_NO, A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'	 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'	 , A.ACTUAL_GOOD_QTY, A.CELL_OUT_QTY ' + char(10)
		SELECT @v_dSql += N'INTO   #SCM_DAILY_PRODUCT_RESULT_H ' + char(10)
		SELECT @v_dSql += N'FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, (SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01'')) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'AND    (A.CELL_OUT_QTY + A.ACTUAL_GOOD_QTY) > 0 ' + char(10)
		SELECT @v_dSql += N'; ' + char(10)
		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'     , A.LOCATION, A.OPERATION_ID , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'     , A.FP_PRODUCTION_TYPE, A.MARKET, A.PLM_EC_NO, A.PLAN_DATE, A.PLAN_TYPE ' + char(10)
		SELECT @v_dSql += N'     , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'     , A.PLAN_IN_QTY, A.PLAN_QTY ' + char(10)
		SELECT @v_dSql += N'     , A.CELL_IN_QTY, A.CELL_OUT_QTY ' + char(10)
		SELECT @v_dSql += N'INTO   #FP_DAILY_PRODUCTIOIN_PLAN_H ' + char(10)
		SELECT @v_dSql += N'FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, (SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01'')) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		SELECT @v_dSql += N'AND	   A.PLAN_TYPE IN ( ''RELEASE'', ''WPP'', ''MPP'' ) ' + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += N'' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'AND    (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0 ' + char(10)
		SELECT @v_dSql += N'; ' + char(10)+ char(10)

		-- 조회되는 아이템-날짜 세트 : 1일 부터의 구간을 가생성
		SELECT @v_dSql += N'SELECT A.* ' + char(10)
		SELECT @v_dSql += N'     , B.YYYYMMDD AS PLAN_DATE, B.ISO_YYYYWW AS PLAN_WEEK, B.YYYYMM AS PLAN_MONTH ' + char(10)
		SELECT @v_dSql += N'     , ISNULL(D.OPERATION_NAME,''-'') AS OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'     , ISNULL(C.LINE_NAME,''-'') AS LINE_NAME ' + char(10)
		SELECT @v_dSql += N'     , ISNULL(BB.NICK_NAME,''-'') AS NICK_NAME, BB.ITEM_TYPE ' + char(10)
		SELECT @v_dSql += N'	 , J.CELL_GROUP ' + char(10)
		SELECT @v_dSql += N'INTO #MAIN_ITEM_WPP_GAP ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'		 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'		 , A.MARKET, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	FROM   #SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10) -- 조회 날짜 구간
		/*
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		*/
		SELECT @v_dSql += N'	AND    (A.CELL_OUT_QTY + A.ACTUAL_GOOD_QTY) > 0 ' + char(10)
		SELECT @v_dSql += N'	UNION ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'		 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'		 , A.MARKET, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	FROM   #FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10) -- 조회 날짜 구간
		SELECT @v_dSql += N'	AND    A.PLAN_TYPE IN (''WPP'', ''RELEASE'') ' + char(10) -- WPP 는 WPP(Out) 품번, RELEASE 는 미래실적 품번 때문에 가져옴(미래실적의 경우, 엄밀히 말하면 당일이후 날짜의 품번만 가져와야하나 별도로 가져오기 애매하므로 일단 같이 가져온다... 문제되면 분리해서 하단에 union all 로 붙여야할듯)
		/*
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		*/
		SELECT @v_dSql += N'	AND    (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0 ' + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'INNER JOIN ( ' + char(10)
		SELECT @v_dSql += N'		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)
		SELECT @v_dSql += N'				A.ITEM_ID, ' + char(10)
		SELECT @v_dSql += N'				(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
		SELECT @v_dSql += N'	                  WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
		SELECT @v_dSql += N'	                  ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, ' + char(10)
		SELECT @v_dSql += N'				ISNULL(A.NICK_NAME,''-'') AS NICK_NAME  ' + char(10)
		SELECT @v_dSql += N'		FROM   SCM_ITEM_M A WITH(NOLOCK), ' + char(10)
		SELECT @v_dSql += N'	           SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'		WHERE  A.ITEM_CLASS  = C.CLASS_ID ' + char(10)
		SELECT @v_dSql += N'		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N') BB ' + char(10)
		SELECT @v_dSql += N'ON     A.COMPANY_ID     = BB.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.DIVISION_ID    = BB.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.SITE_ID        = BB.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.TOP_ITEM_ID    = BB.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'INNER JOIN SCM_LINE_M C WITH(NOLOCK)  ' + char(10)
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
		SELECT @v_dSql += N'INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)  ' + char(10)
		SELECT @v_dSql += N'ON     A.COMPANY_ID     = J.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.DIVISION_ID    = J.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.SITE_ID        = J.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.TOP_ITEM_ID    = J.ITEM_ID ' + char(10)
		SELECT @v_dSql += N', TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
		--SELECT @v_dSql += N'WHERE 1=1 ' + char(10)
		SELECT @v_dSql += @chk_gapWPP + char(10) -- 카테고리 체크여부에 따른 처리
		SELECT @v_dSql += N'AND   B.YYYYMMDD BETWEEN (SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01'') AND ''' + @p_bucket_to + ''' ' + char(10) -- 시작일의 월의 1일부터 구간이 잡힘
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('J.CELL_GROUP' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'; ' + char(10)+char(10)

		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'     , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'     , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'     , A.EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'     , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'     , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
		SELECT @v_dSql += N'     , A.ITEM_TYPE ' + char(10)
		SELECT @v_dSql += N'     , A.CATE ' + char(10)
		SELECT @v_dSql += N'     , A.MEASURE_NAME ' + char(10)
     
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
						SELECT @v_dSql += ' , ' + @tmp_GAP_lastCol

						SELECT @v_dSql += ' AS ' + @p_temp + '_QTY ' + char(10)
						SELECT @v_dSql += ' , NULL AS ' + @p_temp + '_COLOR ' + char(10)
					END 

					SET @tmp_GAP_lastCol = @sub_param_0 -- 각 주의 마지막 일자만 저장

					-- 마지막 week 정보를 넣어준다.
					IF @mst_loop_cnt = @max_day2_week_month_loop_cnt BEGIN
						SELECT @v_dSql += ' , ' + @tmp_GAP_lastCol
						
						SELECT @v_dSql += ' AS ' + @sub_param_1 + '_QTY ' + char(10)
						SELECT @v_dSql += ' , NULL AS ' + @sub_param_1 + '_COLOR ' + char(10)
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
					
					SELECT @v_dSql += '     , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ' AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '     , NULL AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)

					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'     , A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'     , A.DATA_TYPE ' + char(10)
		SELECT @v_dSql += N'INTO #MAIN_GAP_WPP ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'		 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'		 , '''' AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'		 , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
		SELECT @v_dSql += N'		 , A.ITEM_TYPE ' + char(10)
		SELECT @v_dSql += N'		 , B.CATEGORY_NAME AS CATE ' + char(10)
		SELECT @v_dSql += N'		 , B.MEASURE_NAME AS MEASURE_NAME ' + char(10)

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
					
					SELECT @v_dSql += N'		 , SUM(CASE WHEN A.PLAN_DATE >= (SUBSTRING(''' + @sub_param_0 + ''',1,6)+''01'') AND A.PLAN_DATE <= ''' + @sub_param_0 + ''' THEN ( CASE WHEN B.CATEGORY_ID=''GAP_WPP'' AND B.MEASURE_ID=''UOM''  THEN A.GAP_QTY ' + char(10)
					SELECT @v_dSql += N'	  																											   WHEN B.CATEGORY_ID=''GAP_WPP'' AND B.MEASURE_ID=''CELL'' THEN A.GAP_CELL_QTY ' + char(10)
					SELECT @v_dSql += N'	  																											   ELSE 0 END )ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ' ' + char(10)

				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N' 		 , B.CATEGORY_ID, B.MEASURE_ID, B.CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N' 		 , ''DATA'' AS DATA_TYPE ' + char(10)
		SELECT @v_dSql += N'	FROM ( ' + char(10)
		SELECT @v_dSql += N'		SELECT A.* ' + char(10) 
		SELECT @v_dSql += N'			 , ISNULL(B.GAP_QTY,0) AS GAP_QTY ' + char(10)
		SELECT @v_dSql += N'			 , ISNULL(B.GAP_CELL_QTY,0) AS GAP_CELL_QTY ' + char(10)
		SELECT @v_dSql += N'		FROM #MAIN_ITEM_WPP_GAP A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'		LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'				 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'				 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'				 , A.EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'				 , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'				 , A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME ' + char(10)
		SELECT @v_dSql += N'				 , A.PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'				 , A.MARKET, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'				 , SUM(ISNULL(A.RESULT_QTY,0)) - SUM(ISNULL(A.OUT_QTY,0)) AS GAP_QTY ' + char(10)
		SELECT @v_dSql += N'				 , ROUND(SUM(ISNULL(A.RESULT_QTY_CELL,0)),0) - ROUND(SUM(ISNULL(A.CELL_OUT_QTY,0)),0) AS GAP_CELL_QTY ' + char(10)
		SELECT @v_dSql += N'			FROM ( ' + char(10)
											-- WPP
		SELECT @v_dSql += N'				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'					 , '''' AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'					 , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME ' + char(10)
		SELECT @v_dSql += N'					 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'					 , A.MARKET, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'					 , ISNULL(A.PLAN_QTY,0) AS OUT_QTY ' + char(10)
		SELECT @v_dSql += N'					 , ISNULL(A.CELL_OUT_QTY,0) AS CELL_OUT_QTY ' + char(10)
		SELECT @v_dSql += N'					 , 0 AS RESULT_QTY ' + char(10)
		SELECT @v_dSql += N'					 , 0 AS RESULT_QTY_CELL ' + char(10)
		SELECT @v_dSql += N'				FROM   #FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'				WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, (SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01'')) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10) -- 시작일자 월의 1일부터 뽑는다.
		SELECT @v_dSql += N'				AND    A.PLAN_TYPE = ''WPP'' ' + char(10)
		/*
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		*/
		SELECT @v_dSql += N'				AND    (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0 ' + char(10)
		SELECT @v_dSql += N'				UNION ALL ' + char(10)
											-- Result 과거 : 과거시작일자 월의 1일부터 당일이전 일자(과거)까지
		SELECT @v_dSql += N'				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'					 , '''' AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'					 , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME ' + char(10)
		SELECT @v_dSql += N'					 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'					 , A.MARKET, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'					 , 0 AS CELL_IN_QTY ' + char(10)
		SELECT @v_dSql += N'					 , 0 AS CELL_OUT_QTY ' + char(10)
		SELECT @v_dSql += N'					 , A.ACTUAL_GOOD_QTY AS RESULT_QTY ' + char(10)
		SELECT @v_dSql += N'					 , A.CELL_OUT_QTY AS RESULT_QTY_CELL ' + char(10)
		SELECT @v_dSql += N'				FROM   #SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'				WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, (SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01'')) AND CONVERT(DATETIME, ''' + @p_curr_date_gap + ''')-1 ' + char(10) -- 과거 : 시작일자 월의 1일부터 당일(인스턴스 기준)이전 일자(과거)까지
		/*
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		*/
		SELECT @v_dSql += N'				AND    (A.CELL_OUT_QTY + A.ACTUAL_GOOD_QTY) > 0 ' + char(10)
		SELECT @v_dSql += N'				UNION ALL ' + char(10)
											-- Result 미래 : 당일부터 end date 까지
		SELECT @v_dSql += N'				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'					 , '''' AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'					 , A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'					 , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME ' + char(10)
		SELECT @v_dSql += N'					 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'					 , A.MARKET, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'					 , 0 AS CELL_IN_QTY ' + char(10)
		SELECT @v_dSql += N'					 , 0 AS CELL_OUT_QTY ' + char(10)
		SELECT @v_dSql += N'					 , ISNULL(A.PLAN_QTY,0) AS RESULT_QTY ' + char(10)
		SELECT @v_dSql += N'					 , ISNULL(A.CELL_OUT_QTY,0) AS RESULT_QTY_CELL ' + char(10)
		SELECT @v_dSql += N'				FROM   #FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'				WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_curr_date_gap + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10) -- 미래 : 당일(인스턴스 기준)부터 end date 까지
		SELECT @v_dSql += N'				AND    A.PLAN_TYPE = ''RELEASE'' ' + char(10)
		/*
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		*/
		SELECT @v_dSql += N'				AND    (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0 ' + char(10)
		SELECT @v_dSql += N'			) A ' + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'				   , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'				   , A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME ' + char(10)
		SELECT @v_dSql += N'				   , A.PRODUCTION_TYPE, A.MARKET, A.PLM_EC_NO ' + char(10)
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
		SELECT @v_dSql += N'			SELECT * ' + char(10)
		SELECT @v_dSql += N'			FROM ( ' + char(10)
		SELECT @v_dSql += N'				SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 0 AS CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'				UNION ALL ' + char(10)
		SELECT @v_dSql += N'				SELECT ''GAP_WPP'' AS CATEGORY_ID, ''Accu. GAP(WPP)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 155 AS CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'				UNION ALL ' + char(10)
		SELECT @v_dSql += N'				SELECT ''GAP_WPP'' AS CATEGORY_ID, ''Accu. GAP(WPP)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 156 AS CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'			) BB ' + char(10)
		SELECT @v_dSql += N'			WHERE CATEGORY_ID <> ''X'' ' + char(10)
		SELECT @v_dSql += N'	) B ' + char(10)
		SELECT @v_dSql += N'	ON 1=1 ' + char(10)
		SELECT @v_dSql += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID  ' + char(10)
		SELECT @v_dSql += N'		  , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'		  , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'		  , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'		  , A.PRODUCTION_TYPE, A.MARKET, A.ITEM_TYPE ' + char(10)
		SELECT @v_dSql += N'		  , B.CATEGORY_ID, B.CATEGORY_NAME, B.MEASURE_ID, B.MEASURE_NAME, B.CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'; ' + char(10)+ char(10)

		--SELECT @v_dSql += N'	  WITH MAIN AS (    																																																											' + char(10)	
		--SELECT @v_dSql += N'	  		SELECT A.*                                                ' + char(10)
		--SELECT @v_dSql += N'	  		FROM (                                                    ' + char(10)
		SELECT @v_dSql += N'		          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID          ' + char(10)
		SELECT @v_dSql += N'		               , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'		               , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE     ' + char(10)
		SELECT @v_dSql += N'		               , A.EQUIPMENT_ID                               ' + char(10)
		SELECT @v_dSql += N'		               , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'		               , A.PRODUCTION_TYPE, A.MARKET                  ' + char(10)
		SELECT @v_dSql += N'		               , A.ITEM_TYPE                                  ' + char(10)
		SELECT @v_dSql += N'		               , B.CATEGORY_NAME AS CATE                      ' + char(10)
		SELECT @v_dSql += N'		               , B.MEASURE_NAME AS MEASURE_NAME               ' + char(10)
		
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

					SELECT @v_dSql += N'			    , SUM(CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' THEN (A.IN_QTY * T.IN_QTY + A.CELL_IN_QTY*T.CELL_IN_QTY + A.OUT_QTY*T.OUT_QTY + A.CELL_OUT_QTY * T.CELL_OUT_QTY' + char(10)
					SELECT @v_dSql += N'					+ A.RESULT_QTY * T.RESULT_QTY +  A.RESULT_QTY_CELL * T.RESULT_QTY_CELL + A.RESULT_QTY2 * T.RESULT_QTY2' + char(10)
					SELECT @v_dSql += N'					+ A.RESULT_QTY2_CELL * T.RESULT_QTY2_CELL + CEILING( A.CUT_QTY * T.CUT_QTY) +  A.TARGET_QTY * T.TARGET_QTY +  A.OFF_TIME * T.OFF_TIME) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY  ' + char(10)
					--SELECT @v_dSql += N'			                                                 						ELSE 0 END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY  ' + char(10)
					SELECT @v_dSql += N'			    , NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR  ' + char(10)
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

					SELECT @v_dSql += N'			    , SUM(CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN (A.IN_QTY * T.IN_QTY + A.CELL_IN_QTY*T.CELL_IN_QTY + A.OUT_QTY*T.OUT_QTY + A.CELL_OUT_QTY * T.CELL_OUT_QTY ' + char(10)
					SELECT @v_dSql += N'					+ A.RESULT_QTY * T.RESULT_QTY +  A.RESULT_QTY_CELL * T.RESULT_QTY_CELL + A.RESULT_QTY2 * T.RESULT_QTY2' + char(10)
					SELECT @v_dSql += N'					+ A.RESULT_QTY2_CELL * T.RESULT_QTY2_CELL + CEILING( A.CUT_QTY * T.CUT_QTY) +  A.TARGET_QTY * T.TARGET_QTY +  A.OFF_TIME * T.OFF_TIME) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY  ' + char(10)
					--SELECT @v_dSql += N'			                                                 						ELSE 0 END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY  ' + char(10)
					SELECT @v_dSql += N'			    , NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR  ' + char(10)
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
					
					SELECT @v_dSql += N'			    , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN (A.IN_QTY * T.IN_QTY + A.CELL_IN_QTY*T.CELL_IN_QTY + A.OUT_QTY*T.OUT_QTY + A.CELL_OUT_QTY * T.CELL_OUT_QTY' + char(10)
					SELECT @v_dSql += N'					+ A.RESULT_QTY * T.RESULT_QTY +  A.RESULT_QTY_CELL * T.RESULT_QTY_CELL + A.RESULT_QTY2 * T.RESULT_QTY2 ' + char(10)
					SELECT @v_dSql += N'					+ A.RESULT_QTY2_CELL * T.RESULT_QTY2_CELL + CEILING( A.CUT_QTY * T.CUT_QTY) +  A.TARGET_QTY * T.TARGET_QTY +  A.OFF_TIME * T.OFF_TIME) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY  ' + char(10)
					--SELECT @v_dSql += N'			                                                 						ELSE 0 END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY  ' + char(10)
					SELECT @v_dSql += N'			    , NULL AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR  ' + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		SELECT @v_dSql += N'		        			 , B.CATEGORY_ID, B.MEASURE_ID, B.CATEGORY_ORDER                       ' + char(10)
		SELECT @v_dSql += N'		               , ''DATA'' AS DATA_TYPE                        ' + char(10)
		SELECT @v_dSql += N'		          INTO #MAIN ' + char(10)
		SELECT @v_dSql += N'		          FROM (                                              ' + char(10)
		SELECT @v_dSql += N'		              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID      ' + char(10)
		SELECT @v_dSql += N'		                   , A.LOCATION, A.OPERATION_ID, ISNULL(D.OPERATION_NAME,''-'') AS OPERATION_NAME                                                      ' + char(10)
		SELECT @v_dSql += N'		                   , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE   ' + char(10)
		SELECT @v_dSql += N'		                   , A.EQUIPMENT_ID                           ' + char(10)
		SELECT @v_dSql += N'		                   , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE' + char(10)
		SELECT @v_dSql += N'		                   , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME, J.CELL_GROUP, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'		                   , A.PRODUCTION_TYPE                        ' + char(10)
		SELECT @v_dSql += N'		                   , A.MARKET                                 ' + char(10)
		SELECT @v_dSql += N'		                   , B.ITEM_TYPE                              ' + char(10)
		SELECT @v_dSql += N'		                   , A.PLAN_TYPE                              ' + char(10)
		SELECT @v_dSql += N'		                   , A.SEQ                                    ' + char(10)
		SELECT @v_dSql += N'		                   , A.IN_QTY                                 ' + char(10)
		SELECT @v_dSql += N'		                   , A.OUT_QTY                                ' + char(10)
		SELECT @v_dSql += N'		                   , A.CELL_IN_QTY                            ' + char(10)
		SELECT @v_dSql += N'		                   , A.CELL_OUT_QTY                           ' + char(10)
		SELECT @v_dSql += N'		                   , A.RESULT_QTY_CELL                        ' + char(10)
		SELECT @v_dSql += N'		                   , A.RESULT_QTY                             ' + char(10)
		SELECT @v_dSql += N'		                   , A.TARGET_QTY                             ' + char(10)
		SELECT @v_dSql += N'		                   , A.OFF_TIME                               ' + char(10)
		SELECT @v_dSql += N'		                   , A.CUT_QTY                                ' + char(10)
		SELECT @v_dSql += N'		                   , A.RESULT_QTY2_CELL, A.RESULT_QTY2 ' + char(10) -- Result(Exp.)
		SELECT @v_dSql += N'				           FROM (                                     ' + char(10)
		SELECT @v_dSql += N'					                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                    ' + char(10)
		SELECT @v_dSql += N'	                                , A.LOCATION, A.OPERATION_ID      ' + char(10)
		SELECT @v_dSql += N'	                                , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE               ' + char(10)
		SELECT @v_dSql += N'	                                , '''' AS EQUIPMENT_ID            ' + char(10)
		SELECT @v_dSql += N'	                                , A.PLAN_DATE                     ' + char(10)
		SELECT @v_dSql += N'	                                , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	                                , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE                      ' + char(10)
		SELECT @v_dSql += N'	                                , A.MARKET                        ' + char(10)
		SELECT @v_dSql += N'	                                , CASE WHEN A.PLAN_TYPE = ''RELEASE'' THEN ''DPP'' ELSE A.PLAN_TYPE END AS PLAN_TYPE                                       ' + char(10)
		SELECT @v_dSql += N'	                                , '''' SEQ                        ' + char(10)
		SELECT @v_dSql += N'	                                , ISNULL(A.PLAN_IN_QTY,0) AS IN_QTY                            ' + char(10)
		SELECT @v_dSql += N'	                                , ISNULL(A.PLAN_QTY,0) AS OUT_QTY ' + char(10)
		SELECT @v_dSql += N'	                                , ISNULL(A.CELL_IN_QTY,0) AS CELL_IN_QTY                       ' + char(10)
		SELECT @v_dSql += N'	                                , ISNULL(A.CELL_OUT_QTY,0) AS CELL_OUT_QTY                     ' + char(10)
		SELECT @v_dSql += N'	                                , 0 RESULT_QTY_CELL               ' + char(10)
		SELECT @v_dSql += N'	                                , 0 RESULT_QTY                    ' + char(10)
		SELECT @v_dSql += N'	                                , 0 TARGET_QTY                    ' + char(10)
		SELECT @v_dSql += N'	                                , 0 OFF_TIME                      ' + char(10)
		-- cut, 미래실적 정보 통합... 20230822
		--SELECT @v_dSql += N'	                                , 0 CUT_QTY                       ' + char(10)
		--SELECT @v_dSql += N'	                                , 0 AS RESULT_QTY2_CELL, 0 AS RESULT_QTY2 ' + char(10) -- Result(Exp.)
		SELECT @v_dSql += N'	                                , CASE WHEN A.PLAN_TYPE = ''RELEASE'' AND A.OPERATION_ID = ''A5000'' THEN ( ' + char(10)
		SELECT @v_dSql += N'	                                	ISNULL(( SELECT TOP 1 (A.PLAN_IN_QTY * B.CHILD_QTY/B.PARENT_QTY)/(PC_ROLL_LENGTH*LANE_QTY) ' + char(10)
		SELECT @v_dSql += N'	                                			  FROM   SCM_ITEM_M	I WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	                                				   , SCM_BOM_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	                                				   , SCM_ITEM_LANE_M IL WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	                                			  WHERE I.COMPANY_ID  = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   I.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   I.SITE_ID     = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   I.ITEM_ID     = B.CHILD_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   B.CHILD_ITEM_ID LIKE ''APC%'' ' + char(10)                  
		SELECT @v_dSql += N'	                                			  AND   A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   A.SITE_ID     = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   A.PLANT_ID    = B.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   A.ITEM_ID     = B.PARENT_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   B.EFF_START_DATE <= GETDATE() ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   B.EFF_END_DATE   > GETDATE() ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   I.ITEM_UOM = ''M'' ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   IL.ITEM_ID = B.CHILD_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   IL.PC_ROLL_LENGTH IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   IL.PC_ROLL_LENGTH > 0 ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   IL.LANE_QTY > 0 ' + char(10)
		SELECT @v_dSql += N'	                                			  AND   IL.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'	                                			  ORDER BY (CASE WHEN IL.DIVISION_ID = B.DIVISION_ID THEN 1 ELSE 2 END) ' + char(10)
		SELECT @v_dSql += N'	                                					  ,(CASE WHEN IL.COMPANY_ID = B.COMPANY_ID THEN 1 ELSE 2 END) ' + char(10)
		SELECT @v_dSql += N'	                                					  ,(CASE WHEN IL.SITE_ID = B.SITE_ID THEN 1 ELSE 2 END) ' + char(10)
		SELECT @v_dSql += N'	                                					  ,PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += N'	                                					  ,LANE_QTY) ' + char(10)
		SELECT @v_dSql += N'	                                		,(SELECT TOP 1 A.CELL_IN_QTY/(SELECT  TOP 1 VALUE AS CELL_M ' + char(10)
		SELECT @v_dSql += N'	                                  																	FROM SCM_ITEM_CONV_CALC_M C WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	                                  																	WHERE  C.MAX_VER_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'	                                  																	AND    ISNULL(C.VALUE, 0) > 0 ' + char(10)
		SELECT @v_dSql += N'	                                  																	AND    C.CATEGORY     = ''Pancake (cell/m)'' ' + char(10)
		SELECT @v_dSql += N'	                                  																	AND    C.OPERATION    = ''E2000'' ' + char(10)
		SELECT @v_dSql += N'	                                  																	AND    C.ITEM_ID      = B.CHILD_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'	                                  																	ORDER BY (CASE WHEN C.DIVISION_ID  = B.DIVISION_ID THEN 1 ELSE 2 END) ' + char(10)
		SELECT @v_dSql += N'	                                  																			,(CASE WHEN C.COMPANY_ID = B.COMPANY_ID THEN 1 ELSE 2 END) ' + char(10)
		SELECT @v_dSql += N'	                                  																			,(CASE WHEN C.SITE_ID = B.SITE_ID THEN 1 ELSE 2 END) ' + char(10)
		SELECT @v_dSql += N'	                                  																			,(CASE WHEN A.FP_PRODUCTION_TYPE LIKE ''%TEST'' THEN ' + char(10)
		SELECT @v_dSql += N'	                                  																						(CASE WHEN C.VERSION_TYPE = ''TEST'' THEN 1 ELSE 2 END) ' + char(10)
		SELECT @v_dSql += N'	                                  																					ELSE ' + char(10)
		SELECT @v_dSql += N'	                                  																					  (CASE WHEN C.VERSION_TYPE = ''TEST'' THEN 2 ELSE 1 END) ' + char(10)
		SELECT @v_dSql += N'	                                  																					END ) ' + char(10)
		SELECT @v_dSql += N'	                                      																			,(CASE WHEN C.MODEL_ID	  = A.TOP_ITEM_ID THEN 1 ELSE 2 END) ' + char(10)
		SELECT @v_dSql += N'	                                      																			,C.MODEL_ID ' + char(10)
		SELECT @v_dSql += N'	                                      																			,( CASE WHEN C.VERSION  LIKE ''Z%'' THEN REPLACE(C.VERSION, ''Z'', ''/'') ELSE C.VERSION END ) DESC )/( PC_ROLL_LENGTH*LANE_QTY) ' + char(10)
		SELECT @v_dSql += N'	                                										FROM   SCM_ITEM_M	I WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	                                										   , SCM_BOM_M		B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	                                										   , SCM_ITEM_LANE_M IL WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	                                										WHERE  I.COMPANY_ID  = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'	                                										AND    I.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'	                                										AND    I.SITE_ID     = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'	                                										AND    I.ITEM_ID     = B.CHILD_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'	                                										AND    B.CHILD_ITEM_ID LIKE ''APC%'' ' + char(10)
		SELECT @v_dSql += N'	                                										AND    A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'	                                										AND    A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'	                                										AND    A.SITE_ID     = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'	                                										AND    A.PLANT_ID    = B.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'	                                										AND    A.ITEM_ID     = B.PARENT_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'	                                										AND    B.EFF_START_DATE <= GETDATE() ' + char(10)
		SELECT @v_dSql += N'	                                										AND    B.EFF_END_DATE  > GETDATE() ' + char(10)
		SELECT @v_dSql += N'	                                										AND    I.ITEM_UOM != ''M'' ' + char(10)
		SELECT @v_dSql += N'	                                										AND    IL.ITEM_ID = B.CHILD_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'	                                										AND    IL.PC_ROLL_LENGTH IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'	                                										AND    IL.PC_ROLL_LENGTH > 0 ' + char(10)
		SELECT @v_dSql += N'	                                										AND    IL.LANE_QTY > 0 ' + char(10)
		SELECT @v_dSql += N'	                                										AND    IL.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'	                                										ORDER BY (CASE WHEN IL.DIVISION_ID = B.DIVISION_ID THEN 1 ELSE 2 END) ' + char(10)
		SELECT @v_dSql += N'	                                				  ,(CASE WHEN IL.COMPANY_ID = B.COMPANY_ID THEN 1 ELSE 2 END) ' + char(10)
		SELECT @v_dSql += N'	                                				  ,(CASE WHEN IL.SITE_ID = B.SITE_ID THEN 1 ELSE 2 END) ' + char(10)
		SELECT @v_dSql += N'	                                				  ,PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += N'	                                				  ,LANE_QTY ) ) ) ELSE 0 END AS CUT_QTY ' + char(10)
		SELECT @v_dSql += N'	                                , (CASE WHEN A.PLAN_DATE >= CONVERT(DATETIME, ''' + @p_curr_date_gap + ''') AND A.PLAN_TYPE = ''RELEASE'' THEN A.CELL_OUT_QTY ELSE 0 END) AS RESULT_QTY2_CELL ' + char(10)
		SELECT @v_dSql += N'	                                , (CASE WHEN A.PLAN_DATE >= CONVERT(DATETIME, ''' + @p_curr_date_gap + ''') AND A.PLAN_TYPE = ''RELEASE'' THEN A.PLAN_QTY ELSE 0 END) AS RESULT_QTY2 ' + char(10)
		SELECT @v_dSql += N'			                    FROM	#FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                    ' + char(10)
		SELECT @v_dSql += N'			      		        WHERE	1=1                          ' + char(10)
		--SELECT @v_dSql += N'			                    AND		CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                ' + char(10)
		SELECT @v_dSql += N'			      		        AND		A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		SELECT @v_dSql += N'			                    AND		A.PLAN_TYPE IN ( ''RELEASE'', ''WPP'', ''MPP'' )            ' + char(10)
		/*
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		*/
		SELECT @v_dSql += N'						              AND   (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0          ' + char(10)
		/*
		-- 위에 통합
		SELECT @v_dSql += N'						              UNION ALL                       ' + char(10)
		SELECT @v_dSql += N'						              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                  ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.LOCATION, A.OPERATION_ID                            ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE        ' + char(10)
		SELECT @v_dSql += N'			      		                   , '''' AS EQUIPMENT_ID     ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.PLAN_DATE              ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME           ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE               ' + char(10)
		SELECT @v_dSql += N'			      		                   , A.MARKET                 ' + char(10)
		SELECT @v_dSql += N'			      		                   , CASE WHEN A.PLAN_TYPE = ''RELEASE'' THEN ''DPP'' ELSE A.PLAN_TYPE END AS PLAN_TYPE                                ' + char(10)
		SELECT @v_dSql += N'			      		                   , '''' SEQ                 ' + char(10)
		SELECT @v_dSql += N'			      		                   , 0 AS IN_QTY              ' + char(10)
		SELECT @v_dSql += N'			      		                   , 0 AS OUT_QTY             ' + char(10)
		SELECT @v_dSql += N'			      		                   , 0 AS CELL_IN_QTY         ' + char(10)
		SELECT @v_dSql += N'			      		                   , 0 AS CELL_OUT_QTY        ' + char(10)
		SELECT @v_dSql += N'			      		                   , 0 RESULT_QTY_CELL        ' + char(10)
		SELECT @v_dSql += N'			      		                   , 0 RESULT_QTY             ' + char(10)
		SELECT @v_dSql += N'			      		                   , 0 TARGET_QTY             ' + char(10)
		SELECT @v_dSql += N'			      		                   , 0 OFF_TIME               ' + char(10)
		SELECT @v_dSql += N'	      		                     -- 대치관련 처리... 20200409     ' + char(10)
		SELECT @v_dSql += N'	      		                     , ISNULL(( SELECT TOP 1 (A.PLAN_IN_QTY * B.CHILD_QTY/B.PARENT_QTY)/(PC_ROLL_LENGTH*LANE_QTY)                              ' + char(10)
		SELECT @v_dSql += N'	                                          FROM   SCM_ITEM_M	I WITH(NOLOCK)                     ' + char(10)
		SELECT @v_dSql += N'	                                               , SCM_BOM_M B WITH(NOLOCK)                      ' + char(10)
		SELECT @v_dSql += N'	                                               , SCM_ITEM_LANE_M IL WITH(NOLOCK)               ' + char(10)
		SELECT @v_dSql += N'	                                          WHERE I.COMPANY_ID  = B.COMPANY_ID                   ' + char(10)
		SELECT @v_dSql += N'	                                          AND   I.DIVISION_ID = B.DIVISION_ID                  ' + char(10)
		SELECT @v_dSql += N'	                                          AND   I.SITE_ID     = B.SITE_ID                      ' + char(10)
		SELECT @v_dSql += N'	                                          AND   I.ITEM_ID     = B.CHILD_ITEM_ID                ' + char(10)
		SELECT @v_dSql += N'	                                          AND   B.CHILD_ITEM_ID LIKE ''APC%''                  ' + char(10)
		SELECT @v_dSql += N'	                                          AND   A.COMPANY_ID  = B.COMPANY_ID                   ' + char(10)
		SELECT @v_dSql += N'	                                          AND   A.DIVISION_ID = B.DIVISION_ID                  ' + char(10)
		SELECT @v_dSql += N'	                                          AND   A.SITE_ID     = B.SITE_ID                      ' + char(10)
		SELECT @v_dSql += N'	                                          AND   A.PLANT_ID    = B.PLANT_ID                     ' + char(10)
		SELECT @v_dSql += N'	                                          AND   A.ITEM_ID     = B.PARENT_ITEM_ID               ' + char(10)
		SELECT @v_dSql += N'	                                          AND   B.EFF_START_DATE <= GETDATE()                  ' + char(10)
		SELECT @v_dSql += N'	                                          AND   B.EFF_END_DATE   > GETDATE()                   ' + char(10)
		SELECT @v_dSql += N'	                                          AND   I.ITEM_UOM = ''M''' + char(10)
		SELECT @v_dSql += N'	                                          AND   IL.ITEM_ID = B.CHILD_ITEM_ID                   ' + char(10)
		SELECT @v_dSql += N'	                                          AND   IL.PC_ROLL_LENGTH IS NOT NULL                  ' + char(10)
		SELECT @v_dSql += N'	                                          AND   IL.PC_ROLL_LENGTH > 0                          ' + char(10)
		SELECT @v_dSql += N'	                                          AND   IL.LANE_QTY > 0   ' + char(10)
		SELECT @v_dSql += N'	                                          AND   IL.ACTIVE_FLAG = ''Y''                         ' + char(10)
		SELECT @v_dSql += N'	                                          ORDER BY (CASE WHEN IL.DIVISION_ID = B.DIVISION_ID THEN 1 ELSE 2 END)                                            ' + char(10)
		SELECT @v_dSql += N'	                                                  ,(CASE WHEN IL.COMPANY_ID = B.COMPANY_ID THEN 1 ELSE 2 END)                                              ' + char(10)
		SELECT @v_dSql += N'	                                                  ,(CASE WHEN IL.SITE_ID = B.SITE_ID THEN 1 ELSE 2 END)                                                    ' + char(10)
		SELECT @v_dSql += N'	                                                  ,PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += N'	                                                  ,LANE_QTY)      ' + char(10)
		SELECT @v_dSql += N'	                                    ,(SELECT TOP 1 A.CELL_IN_QTY/(SELECT  TOP 1 VALUE AS CELL_M' + char(10)
		SELECT @v_dSql += N'	                                  																FROM SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)                   ' + char(10)
		SELECT @v_dSql += N'	                                  																WHERE  C.MAX_VER_FLAG = ''Y''                              ' + char(10)
		SELECT @v_dSql += N'	                                  																AND    ISNULL(C.VALUE, 0) > 0                              ' + char(10)
		SELECT @v_dSql += N'	                                  																AND    C.CATEGORY     = ''Pancake (cell/m)''               ' + char(10)
		SELECT @v_dSql += N'	                                  																AND    C.OPERATION    = ''E2000''                          ' + char(10)
		SELECT @v_dSql += N'	                                  																AND    C.ITEM_ID      = B.CHILD_ITEM_ID                    ' + char(10)
		SELECT @v_dSql += N'	                                  																ORDER BY (CASE WHEN C.DIVISION_ID  = B.DIVISION_ID THEN 1 ELSE 2 END)  ' + char(10)
		SELECT @v_dSql += N'	                                  																        ,(CASE WHEN C.COMPANY_ID = B.COMPANY_ID THEN 1 ELSE 2 END)     ' + char(10)
		SELECT @v_dSql += N'	                                  																        ,(CASE WHEN C.SITE_ID = B.SITE_ID THEN 1 ELSE 2 END)           ' + char(10)
		SELECT @v_dSql += N'	                                  																        ,(CASE WHEN A.FP_PRODUCTION_TYPE LIKE ''%TEST'' THEN           ' + char(10)
		SELECT @v_dSql += N'	                                  																					(CASE WHEN C.VERSION_TYPE = ''TEST'' THEN 1 ELSE 2 END)                         ' + char(10)
		SELECT @v_dSql += N'	                                  																				ELSE                                       ' + char(10)
		SELECT @v_dSql += N'	                                  																				  (CASE WHEN C.VERSION_TYPE = ''TEST'' THEN 2 ELSE 1 END)                           ' + char(10)
		SELECT @v_dSql += N'	                                  																				END )                                      ' + char(10)
		SELECT @v_dSql += N'	                                      																		,(CASE WHEN C.MODEL_ID	  = A.TOP_ITEM_ID THEN 1 ELSE 2 END)                            ' + char(10)
		SELECT @v_dSql += N'	                                      																		,C.MODEL_ID                                    ' + char(10)
		SELECT @v_dSql += N'	                                      																		,( CASE WHEN C.VERSION  LIKE ''Z%'' THEN REPLACE(C.VERSION, ''Z'', ''/'') ELSE C.VERSION END ) DESC )/( PC_ROLL_LENGTH*LANE_QTY)                    ' + char(10)
		SELECT @v_dSql += N'	      																FROM   SCM_ITEM_M	I WITH(NOLOCK)                                                     ' + char(10)
		SELECT @v_dSql += N'	      		  														   , SCM_BOM_M		B WITH(NOLOCK)                                                     ' + char(10)
		SELECT @v_dSql += N'	      															       , SCM_ITEM_LANE_M IL WITH(NOLOCK)                                                   ' + char(10)
		SELECT @v_dSql += N'	      																WHERE  I.COMPANY_ID  = B.COMPANY_ID                                                    ' + char(10)
		SELECT @v_dSql += N'	      																AND    I.DIVISION_ID = B.DIVISION_ID                                                   ' + char(10)
		SELECT @v_dSql += N'	      																AND    I.SITE_ID     = B.SITE_ID                                                       ' + char(10)
		SELECT @v_dSql += N'	      																AND    I.ITEM_ID     = B.CHILD_ITEM_ID                                                 ' + char(10)
		SELECT @v_dSql += N'	      																AND    B.CHILD_ITEM_ID LIKE ''APC%''                                                   ' + char(10)
		SELECT @v_dSql += N'	      																AND    A.COMPANY_ID  = B.COMPANY_ID                                                    ' + char(10)
		SELECT @v_dSql += N'	      																AND    A.DIVISION_ID = B.DIVISION_ID                                                   ' + char(10)
		SELECT @v_dSql += N'	      																AND    A.SITE_ID     = B.SITE_ID                                                       ' + char(10)
		SELECT @v_dSql += N'	      																AND    A.PLANT_ID    = B.PLANT_ID                                                      ' + char(10)
		SELECT @v_dSql += N'	      																AND    A.ITEM_ID     = B.PARENT_ITEM_ID                                                ' + char(10)
		SELECT @v_dSql += N'	      																AND    B.EFF_START_DATE <= GETDATE()                                                   ' + char(10)
		SELECT @v_dSql += N'	      																AND    B.EFF_END_DATE  > GETDATE()                                                     ' + char(10)
		SELECT @v_dSql += N'	      																AND    I.ITEM_UOM != ''M'' ' + char(10)
		SELECT @v_dSql += N'	      																AND    IL.ITEM_ID = B.CHILD_ITEM_ID                                                    ' + char(10)
		SELECT @v_dSql += N'	      																AND    IL.PC_ROLL_LENGTH IS NOT NULL                                                   ' + char(10)
		SELECT @v_dSql += N'	      																AND    IL.PC_ROLL_LENGTH > 0                                                           ' + char(10)
		SELECT @v_dSql += N'	      																AND    IL.LANE_QTY > 0     ' + char(10)
		SELECT @v_dSql += N'	      																AND    IL.ACTIVE_FLAG = ''Y''                                                          ' + char(10)
		SELECT @v_dSql += N'	      																ORDER BY (CASE WHEN IL.DIVISION_ID = B.DIVISION_ID THEN 1 ELSE 2 END)                  ' + char(10)
		SELECT @v_dSql += N'	                                              ,(CASE WHEN IL.COMPANY_ID = B.COMPANY_ID THEN 1 ELSE 2 END)                                                  ' + char(10)
		SELECT @v_dSql += N'	                                              ,(CASE WHEN IL.SITE_ID = B.SITE_ID THEN 1 ELSE 2 END)                                                        ' + char(10)
		SELECT @v_dSql += N'	                                              ,PC_ROLL_LENGTH     ' + char(10)
		SELECT @v_dSql += N'	                                              ,LANE_QTY )	)  AS CUT_QTY                      ' + char(10)
		SELECT @v_dSql += N'	                                , 0 AS RESULT_QTY2_CELL, 0 AS RESULT_QTY2 ' + char(10) -- Result(Exp.)
		SELECT @v_dSql += N'			                    FROM 	 FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                ' + char(10)
		SELECT @v_dSql += N'			                    WHERE  1=1                          ' + char(10)
		SELECT @v_dSql += N'			                    AND    A.PLAN_TYPE = ''RELEASE''                       ' + char(10)
		--SELECT @v_dSql += N'			                    AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                ' + char(10)
		SELECT @v_dSql += N'			      		        AND		A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'			                    AND    A.OPERATION_ID = ''A5000''                                     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'			                    AND    (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0         ' + char(10)
		*/
		-- Result : 과거 구간
		SELECT @v_dSql += N'			                    UNION ALL ' + char(10)
		SELECT @v_dSql += N'			                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                      ' + char(10)
		SELECT @v_dSql += N'				      		         , A.LOCATION, A.OPERATION_ID                        ' + char(10)
		SELECT @v_dSql += N'				      		         , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE    ' + char(10)
		SELECT @v_dSql += N'				      		         , '''' AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'				      		         , A.PLAN_DATE          ' + char(10)
		SELECT @v_dSql += N'				      		         , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'				      		         , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE           ' + char(10)
		SELECT @v_dSql += N'				      		         , A.MARKET             ' + char(10)
		SELECT @v_dSql += N'				      		         , ''RESULT'' AS PLAN_TYPE                           ' + char(10)
		SELECT @v_dSql += N'			  	      		         , '''' SEQ               ' + char(10)
		SELECT @v_dSql += N'			  	      		         , 0 AS IN_QTY            ' + char(10)
		SELECT @v_dSql += N'			  	      		         , 0 AS OUT_QTY           ' + char(10)
		SELECT @v_dSql += N'			  	      		         , 0 AS CELL_IN_QTY       ' + char(10)
		SELECT @v_dSql += N'			  	      		         , 0 AS CELL_OUT_QTY      ' + char(10)
		SELECT @v_dSql += N'			  	      		         , A.CELL_OUT_QTY AS RESULT_QTY_CELL                   ' + char(10) -- result
		SELECT @v_dSql += N'			  	                     , A.ACTUAL_GOOD_QTY AS RESULT_QTY                     ' + char(10)
		SELECT @v_dSql += N'			  	                     , 0 AS TARGET_QTY        ' + char(10)
		SELECT @v_dSql += N'			  	                     , 0 OFF_TIME             ' + char(10)
		SELECT @v_dSql += N'			  	                     , 0 CUT_QTY              ' + char(10)
		SELECT @v_dSql += N'	                                 , A.CELL_OUT_QTY AS RESULT_QTY2_CELL ' + char(10) -- Result(+Exp.)
		SELECT @v_dSql += N'	                                 , A.ACTUAL_GOOD_QTY AS RESULT_QTY2 ' + char(10) -- Result(+Exp.)
		SELECT @v_dSql += N'			                    FROM #SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)                   ' + char(10)
		SELECT @v_dSql += N'			                    WHERE  1=1                        ' + char(10)
		--SELECT @v_dSql += N'			                    AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
		SELECT @v_dSql += N'			      		        AND	   A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		/*
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		*/
		SELECT @v_dSql += N'			                    AND 	(A.CELL_OUT_QTY + A.ACTUAL_GOOD_QTY) > 0 ' + char(10)
		/*
		-- 위에 통합
		-- Result(Exp.) : 미래 구간 :: 계획수량으로 보여줌
		SELECT @v_dSql += N'			                    UNION ALL ' + char(10)
		SELECT @v_dSql += N'			                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'			                    	 , A.LOCATION, A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'			                    	 , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'				      		         , '''' AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'				      		         , A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'			                    	 , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME ' + char(10)
		SELECT @v_dSql += N'			                    	 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'			                    	 , A.MARKET ' + char(10)
		SELECT @v_dSql += N'				      		         , ''RESULT'' AS PLAN_TYPE ' + char(10)
		SELECT @v_dSql += N'			  	      		         , '''' SEQ               ' + char(10)
		SELECT @v_dSql += N'			  	      		         , 0 AS IN_QTY            ' + char(10)
		SELECT @v_dSql += N'			  	      		         , 0 AS OUT_QTY           ' + char(10)
		SELECT @v_dSql += N'			  	      		         , 0 AS CELL_IN_QTY       ' + char(10)
		SELECT @v_dSql += N'			  	      		         , 0 AS CELL_OUT_QTY      ' + char(10)
		SELECT @v_dSql += N'			  	      		         , 0 AS RESULT_QTY_CELL ' + char(10)
		SELECT @v_dSql += N'			  	                     , 0 AS RESULT_QTY ' + char(10)
		SELECT @v_dSql += N'			  	                     , 0 AS TARGET_QTY        ' + char(10)
		SELECT @v_dSql += N'			  	                     , 0 OFF_TIME             ' + char(10)
		SELECT @v_dSql += N'			  	                     , 0 CUT_QTY              ' + char(10)
		SELECT @v_dSql += N'			  	                     , A.CELL_OUT_QTY AS RESULT_QTY2_CELL ' + char(10)  -- Result(Exp.)
		SELECT @v_dSql += N'			  	                     , A.PLAN_QTY AS RESULT_QTY2 ' + char(10)  -- Result(Exp.)
		SELECT @v_dSql += N'			                    FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			                    WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'			                    AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_curr_date_gap + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10) -- 당일부터 end date 까지
		SELECT @v_dSql += N'			                    AND    A.PLAN_TYPE = ''RELEASE'' ' + char(10)
		SELECT @v_dSql += N'			                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'			                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'			                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'			                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'			                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'			                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'			                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += N'			                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += N'			                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'			                    AND    (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0 ' + char(10)
		*/
		SELECT @v_dSql += N'			                    UNION ALL                       ' + char(10)
		SELECT @v_dSql += N'			                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'			                                , A.LOCATION, A.OPERATION_ID                           ' + char(10)
		SELECT @v_dSql += N'			                                , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE       ' + char(10)
		SELECT @v_dSql += N'			                                , A.EQUIPMENT_ID          ' + char(10)
		SELECT @v_dSql += N'			                                , B.OFF_DATE AS PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'			                                , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'			                                , A.PRODUCTION_TYPE       ' + char(10)
		SELECT @v_dSql += N'			                                , A.MARKET                ' + char(10)
		SELECT @v_dSql += N'			                                , ''OFFTIME'' AS PLAN_TYPE' + char(10)
		SELECT @v_dSql += N'			                                , '''' SEQ                ' + char(10)
		SELECT @v_dSql += N'			                                , 0 AS IN_QTY             ' + char(10)
		SELECT @v_dSql += N'			                                , 0 AS OUT_QTY            ' + char(10)
		SELECT @v_dSql += N'			                                , 0 AS CELL_IN_QTY        ' + char(10)
		SELECT @v_dSql += N'			                                , 0 AS CELL_OUT_QTY       ' + char(10)
		SELECT @v_dSql += N'			                                , 0 AS RESULT_QTY_CELL    ' + char(10)
		SELECT @v_dSql += N'			                                , 0 AS RESULT_QTY         ' + char(10)
		SELECT @v_dSql += N'			                                , 0 AS TARGET_QTY         ' + char(10)
		SELECT @v_dSql += N'			                                , B.OFF_TIME AS OFF_TIME  ' + char(10)
		SELECT @v_dSql += N'			                                , 0 AS CUT_QTY            ' + char(10)
		SELECT @v_dSql += N'			                                , 0 AS RESULT_QTY2_CELL, 0 AS RESULT_QTY2 ' + char(10) -- Result(Exp.)
		SELECT @v_dSql += N'			                    FROM ( ' + char(10)
		SELECT @v_dSql += N'													SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE            ' + char(10)
		SELECT @v_dSql += N'		                                         		, '''' AS EQUIPMENT_ID                     ' + char(10)
		SELECT @v_dSql += N'		                                         		, A.TOP_ITEM_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'													FROM #FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)  ' + char(10)
		SELECT @v_dSql += N'													WHERE  1=1          ' + char(10)
		--SELECT @v_dSql += N'													AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                    ' + char(10)
		SELECT @v_dSql += N'													AND	   A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		SELECT @v_dSql += N'													AND    A.PLAN_TYPE IN ( ''RELEASE'', ''WPP'', ''MPP'' )                                            ' + char(10)
		/*
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		*/
		SELECT @v_dSql += N'													AND   (A.PLAN_IN_QTY + A.PLAN_QTY + A.CELL_IN_QTY + A.CELL_OUT_QTY) > 0                          ' + char(10)
		SELECT @v_dSql += N'													UNION ' + char(10)
		SELECT @v_dSql += N'													SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'			                                               		, '''' AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'			                                               		, A.TOP_ITEM_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'													FROM  #SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)  ' + char(10)
		SELECT @v_dSql += N'													WHERE  1=1          ' + char(10)
		--SELECT @v_dSql += N'													AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
		SELECT @v_dSql += N'													AND	   A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		/*
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		*/
		SELECT @v_dSql += N'													AND 	(A.CELL_OUT_QTY + A.ACTUAL_GOOD_QTY) > 0 ' + char(10)
		SELECT @v_dSql += N'			                    ) A                     ' + char(10)
		SELECT @v_dSql += N'			                    LEFT OUTER JOIN ' + char(10)
		SELECT @v_dSql += N'			                    ( ' + char(10)
		SELECT @v_dSql += N'				                                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'				                                            , A.OFF_DATE, A.OFF_TIME_TERM AS OFF_TIME ' + char(10)
		SELECT @v_dSql += N'				                                      FROM   SCM_OFF_CALENDAR_LINE_V A WITH(NOLOCK)' + char(10)
		SELECT @v_dSql += N'				                                      WHERE  1=1 ' + char(10)
		--SELECT @v_dSql += N'				                                      AND    CONVERT(VARCHAR, A.OFF_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                           ' + char(10)
		SELECT @v_dSql += N'				                                      AND    A.OFF_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''')' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'			                    ) B                     ' + char(10)
		SELECT @v_dSql += N'			                    ON    A.COMPANY_ID     = B.COMPANY_ID                ' + char(10)
		SELECT @v_dSql += N'			                    AND   A.DIVISION_ID    = B.DIVISION_ID               ' + char(10)
		SELECT @v_dSql += N'			                    AND   A.SITE_ID        = B.SITE_ID                   ' + char(10)
		SELECT @v_dSql += N'			                    AND   A.PLANT_ID       = B.PLANT_ID                  ' + char(10)
		SELECT @v_dSql += N'			                    AND   A.FACTORY_ID     = B.FACTORY_ID                ' + char(10)
		SELECT @v_dSql += N'			                    AND   A.OPERATION_ID   = B.OPERATION_ID              ' + char(10)
		SELECT @v_dSql += N'			                    AND   A.LINE_ID        = B.LINE_ID                   ' + char(10)
		SELECT @v_dSql += N'			                    AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE            ' + char(10)
		SELECT @v_dSql += N'			                    WHERE B.OFF_DATE IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'					      ) A                                         ' + char(10)
		SELECT @v_dSql += N'					      INNER JOIN (                                ' + char(10)
		SELECT @v_dSql += N'	                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,                  ' + char(10)
		SELECT @v_dSql += N'	                             A.ITEM_ID,                           ' + char(10)
		SELECT @v_dSql += N'	                             (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME                        ' + char(10)
		SELECT @v_dSql += N'	                             	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                                                 ' + char(10)
		SELECT @v_dSql += N'	                             	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,                    ' + char(10)
		SELECT @v_dSql += N'	                             ISNULL(A.NICK_NAME,''-'') AS NICK_NAME                            ' + char(10)
		SELECT @v_dSql += N'	                      FROM	 SCM_ITEM_M A WITH(NOLOCK),           ' + char(10)
		SELECT @v_dSql += N'	                        		 SCM_ITEM_CLASS_M C WITH(NOLOCK)  ' + char(10)
		SELECT @v_dSql += N'	                      WHERE	 A.ITEM_CLASS  = C.CLASS_ID           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	                ) B                                               ' + char(10)
		SELECT @v_dSql += N'	                ON     A.COMPANY_ID     = B.COMPANY_ID            ' + char(10)
		SELECT @v_dSql += N'			              AND    A.DIVISION_ID    = B.DIVISION_ID     ' + char(10)
		SELECT @v_dSql += N'			              AND    A.SITE_ID        = B.SITE_ID         ' + char(10)
		SELECT @v_dSql += N'			              AND    A.TOP_ITEM_ID    = B.ITEM_ID         ' + char(10)
		SELECT @v_dSql += N'			              INNER JOIN SCM_LINE_M C WITH(NOLOCK)        ' + char(10)
		SELECT @v_dSql += N'			              ON     A.COMPANY_ID     = C.COMPANY_ID      ' + char(10)
		SELECT @v_dSql += N'			              AND    A.DIVISION_ID    = C.DIVISION_ID     ' + char(10)
		SELECT @v_dSql += N'			              AND    A.SITE_ID        = C.SITE_ID         ' + char(10)
		SELECT @v_dSql += N'			              AND    A.PLANT_ID       = C.PLANT_ID        ' + char(10)
		SELECT @v_dSql += N'			              AND    A.FACTORY_ID     = C.FACTORY_ID      ' + char(10)
		SELECT @v_dSql += N'			              AND    A.OPERATION_ID   = C.OPERATION_ID    ' + char(10)
		SELECT @v_dSql += N'			              AND    A.LINE_ID        = C.LINE_ID         ' + char(10)
		SELECT @v_dSql += N'			              AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE  ' + char(10)
		SELECT @v_dSql += N'			              INNER JOIN SCM_OPERATION_M D WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'	                ON     A.COMPANY_ID     = D.COMPANY_ID            ' + char(10)
		SELECT @v_dSql += N'			              AND    A.DIVISION_ID    = D.DIVISION_ID     ' + char(10)
		SELECT @v_dSql += N'			              AND    A.SITE_ID        = D.SITE_ID         ' + char(10)
		SELECT @v_dSql += N'			              AND    A.OPERATION_ID   = D.OPERATION_ID    ' + char(10)
		SELECT @v_dSql += N'	                INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)    ' + char(10)
		SELECT @v_dSql += N'	                ON  A.COMPANY_ID  = J.COMPANY_ID                  ' + char(10)
		SELECT @v_dSql += N'	                AND A.DIVISION_ID = J.DIVISION_ID                 ' + char(10)
		SELECT @v_dSql += N'	                AND A.SITE_ID     = J.SITE_ID                     ' + char(10)
		SELECT @v_dSql += N'	                AND A.TOP_ITEM_ID = J.ITEM_ID                     ' + char(10)
		SELECT @v_dSql += N'			              WHERE  1=1                                  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name_lt)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('J.CELL_GROUP' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'		          ) A                                                 ' + char(10)
		SELECT @v_dSql += N'		          INNER JOIN (                                        ' + char(10)
		SELECT @v_dSql += N'		          			SELECT *                                  ' + char(10)
		SELECT @v_dSql += N'		          			FROM (                                    ' + char(10)

		DECLARE @bMppIn		NVARCHAR(1) = 'N';
		DECLARE @bMppOut	NVARCHAR(1) = 'N';
		DECLARE @bWppIn		NVARCHAR(1) = 'N';
		DECLARE @bWppOut	NVARCHAR(1) = 'N';
		DECLARE @bDppIn		NVARCHAR(1) = 'N';
		DECLARE @bDppOut	NVARCHAR(1) = 'N';
		DECLARE @bResult	NVARCHAR(1) = 'N';
		DECLARE @bResultExp	NVARCHAR(1) = 'N';
		DECLARE @bCell		NVARCHAR(1) = 'N';
		DECLARE @bUom		NVARCHAR(1) = 'N';
		DECLARE @bTotal		NVARCHAR(1) = 'N';
		DECLARE @bSubTotal	NVARCHAR(1) = 'N';
		DECLARE @bCapa		NVARCHAR(1) = 'N';
		DECLARE @bTarget	NVARCHAR(1) = 'N';
		DECLARE @bMemo		NVARCHAR(1) = 'Y';
		DECLARE @bOffTime	NVARCHAR(1) = 'N';
		DECLARE @bCut		NVARCHAR(1) = 'N';
		DECLARE @bGap		NVARCHAR(1) = 'N';
		
		IF ISNULL(@p_cate_info,'') <> '' BEGIN

			SET @mst_loop_cnt	= 0 ;
			
  			WHILE @mst_loop_cnt < @max_category_loop_cnt
				BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
				SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가
				SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info , @v_row_delimiter , @mst_loop_cnt );
				
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column , @sub_v_delimiter)

				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_ID')   END
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_VALUE')   END

				IF @sub_param_0 = 'chk_mpp_inqty' AND @sub_param_1 = 'true' BEGIN
					SET @bMppIn = 'Y';
				END ELSE IF @sub_param_0 = 'chk_mpp_outqty' AND @sub_param_1 = 'true' BEGIN
					SET @bMppOut = 'Y';
				END ELSE IF @sub_param_0 = 'chk_wpp_inqty' AND @sub_param_1 = 'true' BEGIN
					SET @bWppIn = 'Y';
				END ELSE IF @sub_param_0 = 'chk_wpp_outqty' AND @sub_param_1 = 'true' BEGIN
					SET @bWppOut = 'Y';
				END ELSE IF @sub_param_0 = 'chk_inqty' AND @sub_param_1 = 'true' BEGIN
					SET @bDppIn = 'Y';
				END ELSE IF @sub_param_0 = 'chk_outqty' AND @sub_param_1 = 'true' BEGIN
					SET @bDppOut = 'Y';
				END ELSE IF @sub_param_0 = 'chk_result' AND @sub_param_1 = 'true' BEGIN
					SET @bResult = 'Y';
				END ELSE IF @sub_param_0 = 'chk_resultExp' AND @sub_param_1 = 'true' BEGIN
					SET @bResultExp = 'Y';
				END ELSE IF @sub_param_0 = 'chk_cell' AND @sub_param_1 = 'true' BEGIN
					SET @bCell = 'Y';
				END ELSE IF @sub_param_0 = 'chk_uom' AND @sub_param_1 = 'true' BEGIN
					SET @bUom = 'Y';
				END ELSE IF @sub_param_0 = 'chk_total' AND @sub_param_1 = 'true' BEGIN
					SET @bTotal = 'Y';
				END ELSE IF @sub_param_0 = 'chk_subTotal' AND @sub_param_1 = 'true' BEGIN
					SET @bSubTotal = 'Y';
				END ELSE IF @sub_param_0 = 'chk_capa' AND @sub_param_1 = 'true' BEGIN
					SET @bCapa = 'Y';
				END ELSE IF @sub_param_0 = 'chk_target' AND @sub_param_1 = 'true' BEGIN
					SET @bTarget = 'Y';
				END ELSE IF @sub_param_0 = 'chk_memo' AND @sub_param_1 = 'true' BEGIN
					SET @bMemo = 'Y';
				END ELSE IF @sub_param_0 = 'chk_offtime' AND @sub_param_1 = 'true' BEGIN
					SET @bOffTime = 'Y';
				END ELSE IF @sub_param_0 = 'chk_cut' AND @sub_param_1 = 'true' BEGIN
					SET @bCut = 'Y';
				END ELSE IF @sub_param_0 = 'chk_gap' AND @sub_param_1 = 'true' BEGIN
					SET @bGap = 'Y';
				END
			
			END	-- END OF WHILE
				
			SELECT @v_dSql += N'	SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 0 AS CATEGORY_ORDER   ' + char(10)
				
			IF @bMppIn = 'Y' AND @bCell = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 20 AS CATEGORY_ORDER                        ' + char(10)
			END IF @bMppIn = 'Y' AND @bUom = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 30 AS CATEGORY_ORDER                          ' + char(10)
			END IF @bMppOut = 'Y' AND @bCell = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 40 AS CATEGORY_ORDER                      ' + char(10)
			END IF @bMppOut = 'Y' AND @bUom = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 50 AS CATEGORY_ORDER                        ' + char(10)
			END IF @bWppIn = 'Y' AND @bCell = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 60 AS CATEGORY_ORDER                        ' + char(10)
			END IF @bWppIn = 'Y' AND @bUom = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 70 AS CATEGORY_ORDER                          ' + char(10)
			END IF @bWppOut = 'Y' AND @bCell = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 80 AS CATEGORY_ORDER                      ' + char(10)
			END IF @bWppOut = 'Y' AND @bUom = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 90 AS CATEGORY_ORDER                        ' + char(10)
			END IF @bDppIn = 'Y' AND @bCell = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 100 AS CATEGORY_ORDER                      ' + char(10)
			END IF @bDppIn = 'Y' AND @bUom = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 110 AS CATEGORY_ORDER                        ' + char(10)
			END IF @bDppOut = 'Y' AND @bCell = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 120 AS CATEGORY_ORDER                    ' + char(10)
			END IF @bDppOut = 'Y' AND @bUom = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 130 AS CATEGORY_ORDER                      ' + char(10)
			END IF @bResult = 'Y' AND @bCell = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 140 AS CATEGORY_ORDER                      ' + char(10)
			END IF @bResult = 'Y' AND @bUom = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 150 AS CATEGORY_ORDER                        ' + char(10)
			-- Result(Exp.)
			END IF @bResultExp = 'Y' AND @bCell = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''RESULT_EXP'' AS CATEGORY_ID, ''Result(+Exp.)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 151 AS CATEGORY_ORDER                      ' + char(10)
			END IF @bResultExp = 'Y' AND @bUom = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''RESULT_EXP'' AS CATEGORY_ID, ''Result(+Exp.)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 152 AS CATEGORY_ORDER                        ' + char(10)
			
			END IF @bCut = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''CUT'' AS CATEGORY_ID, ''Cut'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 158 AS CATEGORY_ORDER       ' + char(10)
			END IF @bTarget = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''TARGET'' AS CATEGORY_ID, ''Target'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 10 AS CATEGORY_ORDER  ' + char(10)
			END IF @bOffTime = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''OFFTIME'' AS CATEGORY_ID, ''Off Cal.'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 160 AS CATEGORY_ORDER                           ' + char(10)
			END IF @bMemo = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 170 AS CATEGORY_ORDER     ' + char(10)
			END

		END ELSE BEGIN
			-- CATEGORY 정보 없는 경우임
			SELECT @v_dSql += N'	SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 20 AS CATEGORY_ORDER 	' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 30 AS CATEGORY_ORDER    ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 35 AS CATEGORY_ORDER      ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 40 AS CATEGORY_ORDER  ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 50 AS CATEGORY_ORDER    ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 60 AS CATEGORY_ORDER    ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 70 AS CATEGORY_ORDER      ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 80 AS CATEGORY_ORDER  ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 90 AS CATEGORY_ORDER    ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 100 AS CATEGORY_ORDER  ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 110 AS CATEGORY_ORDER    ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 120 AS CATEGORY_ORDER' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 130 AS CATEGORY_ORDER  ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 140 AS CATEGORY_ORDER  ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 150 AS CATEGORY_ORDER    ' + char(10)
			-- Result(Exp.)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''RESULT_EXP'' AS CATEGORY_ID, ''Result(+Exp.)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 151 AS CATEGORY_ORDER    ' + char(10)
			SELECT @v_dSql += N'	UNION ALL          ' + char(10)
			SELECT @v_dSql += N'	SELECT ''RESULT_EXP'' AS CATEGORY_ID, ''Result(+Exp.)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 152 AS CATEGORY_ORDER    ' + char(10)

			SELECT @v_dSql += N'	UNION ALL                               ' + char(10)
			SELECT @v_dSql += N'	SELECT ''CUT'' AS CATEGORY_ID, ''Cut'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 155 AS CATEGORY_ORDER         ' + char(10)
			SELECT @v_dSql += N'	UNION ALL                               ' + char(10)
			SELECT @v_dSql += N'	SELECT ''TARGET'' AS CATEGORY_ID, ''Target'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 10 AS CATEGORY_ORDER    ' + char(10)
			SELECT @v_dSql += N'	UNION ALL                               ' + char(10)
			SELECT @v_dSql += N'	SELECT ''OFFTIME'' AS CATEGORY_ID, ''Off Cal.'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 160 AS CATEGORY_ORDER' + char(10)
			SELECT @v_dSql += N'	UNION ALL                               ' + char(10)
			SELECT @v_dSql += N'	SELECT ''MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 160 AS CATEGORY_ORDER       ' + char(10)
		END	

		SELECT @v_dSql += N'	            ) BB                                                  ' + char(10)
		SELECT @v_dSql += N'	            WHERE CATEGORY_ID <> ''X''                            ' + char(10)
		SELECT @v_dSql += N'		          ) B                                                 ' + char(10)
		SELECT @v_dSql += N'		          ON 1=1                                              ' + char(10)		
		SELECT @v_dSql += N'		          left join #CATEGORY_ITEM T on B.CATEGORY_ID = T.CATEGORY_ID and (B.MEASURE_ID = T.MEASURE_ID and (A.PLAN_TYPE = T.PLAN_TYPE or T.PLAN_TYPE = ''2_FIELDS'') or T.PLAN_TYPE = ''1_FIELD'')' + char(10) --TUNING begin block_02
		SELECT @v_dSql += N'		          INNER JOIN TH_UIS_CAL C WITH(NOLOCK)           ' + char(10)
		SELECT @v_dSql += N'		          ON  A.PLAN_DATE = C.YYYYMMDD ' + char(10)
		SELECT @v_dSql += N'		          AND C.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
		SELECT @v_dSql += N'	         	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID          ' + char(10)
		SELECT @v_dSql += N'	             , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME       ' + char(10)
		SELECT @v_dSql += N'	             , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE           ' + char(10)
		SELECT @v_dSql += N'	             , A.EQUIPMENT_ID                                     ' + char(10)
		SELECT @v_dSql += N'	             , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	             , A.PRODUCTION_TYPE, A.MARKET, A.ITEM_TYPE           ' + char(10)
		SELECT @v_dSql += N'	             , B.CATEGORY_ID, B.CATEGORY_NAME, B.MEASURE_ID, B.MEASURE_NAME, B.CATEGORY_ORDER  ' + char(10)
		SELECT @v_dSql += N'; ' + char(10)+ char(10)
		--SELECT @v_dSql += N'		    		) A                                               ' + char(10)
		--SELECT @v_dSql += N'	  )   ' + char(10)
		--SELECT @v_dSql += N'	  -- [C20200213-000397]FP 생산계획 대비 실적 차이수량 집계를 통한 Off-line 계획수립 업무 Zero화' + char(10)
		--SELECT @v_dSql += N'	  , MAIN_GAP AS (                                                 ' + char(10)
		SELECT @v_dSql += N'	    	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                ' + char(10)
		SELECT @v_dSql += N'	    			, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME    ' + char(10)
		SELECT @v_dSql += N'	    			, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE        ' + char(10)
		SELECT @v_dSql += N'	    			, A.EQUIPMENT_ID                                  ' + char(10)
		SELECT @v_dSql += N'	    			, A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	    			, A.PRODUCTION_TYPE, A.MARKET                     ' + char(10)
		SELECT @v_dSql += N'	    			, A.ITEM_TYPE                                     ' + char(10)
		SELECT @v_dSql += N'	    			, A.CATE                                          ' + char(10)
		SELECT @v_dSql += N'	    			, A.MEASURE_NAME                                  ' + char(10)
		
		IF ISNULL(@p_day2_week_month_info,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				SET @p_temp = ''

				WHILE @mst_loop_cnt < @max_day2_week_month_loop_cnt
				BEGIN
					
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = [dbo].[SCM_ARR_SPL_VAL]( @p_day2_week_month_info, @v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'D_COL')   END
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'M_COL')   END

					-- 주차변경 전 alias 를 넣어준다.
					IF @p_temp <> '' AND @p_temp <> @sub_param_1 BEGIN
						SELECT @v_dSql += ' AS ' + @p_temp + '_QTY ' + char(10)
						SELECT @v_dSql += ' , NULL AS ' + @p_temp + '_COLOR ' + char(10)
					END 

					-- 일자별 합계
					IF @p_temp <> @sub_param_1 BEGIN
					
						SELECT @v_dSql += ' , ' + @sub_param_0;

					END ELSE BEGIN
						SELECT @v_dSql += ' + ' + @sub_param_0;
					END

					-- 마지막 month 정보를 넣어준다.
					IF @mst_loop_cnt = @max_day2_week_month_loop_cnt BEGIN
						SELECT @v_dSql += ' AS ' + @sub_param_1 + '_QTY ' + char(10)
						SELECT @v_dSql += ' , NULL AS ' + @sub_param_1 + '_COLOR ' + char(10)
					END 
					
					SET @p_temp = @sub_param_1; -- month 정보를 넣어준다.
				
				END-- end of @mst_loop_cnt < @max_loop_cnt

				---- weekinfo
				SET @mst_loop_cnt = 0
				SET @p_temp = ''
				WHILE @mst_loop_cnt < @max_day2_week_month_loop_cnt
				BEGIN
					
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = [dbo].[SCM_ARR_SPL_VAL]( @p_day2_week_month_info, @v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'D_COL')   END
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'W_COL')   END

					-- 주차변경 전 alias 를 넣어준다.
					IF @p_temp <> '' AND @p_temp <> @sub_param_1 BEGIN
						SELECT @v_dSql += ' AS ' + @p_temp + '_QTY ' + char(10)
						SELECT @v_dSql += ' , NULL AS ' + @p_temp + '_COLOR ' + char(10)
					END 

					-- 일자별 합계
					IF @p_temp <> @sub_param_1 BEGIN
					
						SELECT @v_dSql += ' , ' + @sub_param_0;

					END ELSE BEGIN
						SELECT @v_dSql += ' + ' + @sub_param_0;
					END

					-- 마지막 month 정보를 넣어준다.
					IF @mst_loop_cnt = @max_day2_week_month_loop_cnt BEGIN
						SELECT @v_dSql += ' AS ' + @sub_param_1 + '_QTY ' + char(10)
						SELECT @v_dSql += ' , NULL AS ' + @sub_param_1 + '_COLOR ' + char(10)
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
					
					SELECT @v_dSql += '               , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ' AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , NULL AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''
		
		

		SELECT @v_dSql += N'	    			, A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER   ' + char(10)
		SELECT @v_dSql += N'	    			, A.DATA_TYPE                                     ' + char(10)
		SELECT @v_dSql += N'	    	INTO #MAIN_GAP ' + char(10)
		SELECT @v_dSql += N'	    	FROM (                                                    ' + char(10)
		SELECT @v_dSql += N'	    		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID            ' + char(10)
		SELECT @v_dSql += N'	      			, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME    ' + char(10)
		SELECT @v_dSql += N'	      			, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE        ' + char(10)
		SELECT @v_dSql += N'	      			, A.EQUIPMENT_ID                                  ' + char(10)
		SELECT @v_dSql += N'	      			, A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	      			, A.PRODUCTION_TYPE, A.MARKET                     ' + char(10)
		SELECT @v_dSql += N'	      			, A.ITEM_TYPE                                     ' + char(10)
		SELECT @v_dSql += N'	      			, A.CATE                                          ' + char(10)
		SELECT @v_dSql += N'	      			, A.MEASURE_NAME                                  ' + char(10)

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
		SELECT @v_dSql += N'	      			, A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER   ' + char(10)
		SELECT @v_dSql += N'	      			, A.DATA_TYPE                                     ' + char(10)
		SELECT @v_dSql += N'	    		FROM (                                                ' + char(10)
		SELECT @v_dSql += N'	          			SELECT A.*                                    ' + char(10)
		SELECT @v_dSql += N'	          			FROM (                                        ' + char(10)
		SELECT @v_dSql += N'	    					  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                          ' + char(10)
		SELECT @v_dSql += N'	    						   , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME                  ' + char(10)
		SELECT @v_dSql += N'	    						   , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE                      ' + char(10)
		SELECT @v_dSql += N'	    						   , A.EQUIPMENT_ID                   ' + char(10)
		SELECT @v_dSql += N'	    						   , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	    						   , A.PRODUCTION_TYPE, A.MARKET      ' + char(10)
		SELECT @v_dSql += N'	    						   , A.ITEM_TYPE                      ' + char(10)
		SELECT @v_dSql += N'	    						   , B.CATEGORY_NAME AS CATE          ' + char(10)
		SELECT @v_dSql += N'	    						   , B.MEASURE_NAME AS MEASURE_NAME   ' + char(10)
		
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
					
					SELECT @v_dSql += N'	  			, SUM(CASE WHEN A.PLAN_DATE <= ''' + @sub_param_0 + ''' AND A.PLAN_DATE >= D.INSTANCE_DATE THEN ( CASE 	WHEN B.CATEGORY_ID=''GAP'' AND B.MEASURE_ID=''UOM'' THEN A.GAP_QTY	' + char(10)
					SELECT @v_dSql += N'	  																															WHEN B.CATEGORY_ID=''GAP'' AND B.MEASURE_ID=''CELL'' THEN A.GAP_CELL_QTY	' + char(10)
					SELECT @v_dSql += N'	  																															ELSE 0 END )ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)

				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql += N'	    						   , B.CATEGORY_ID, B.MEASURE_ID, B.CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'	    						   , ''DATA'' AS DATA_TYPE ' + char(10)
		SELECT @v_dSql += N'	    					  FROM ( ' + char(10)
		SELECT @v_dSql += N'	    								SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                ' + char(10)
		SELECT @v_dSql += N'	        									, A.LOCATION, A.OPERATION_ID, ISNULL(D.OPERATION_NAME,''-'') AS OPERATION_NAME                                 ' + char(10)
		SELECT @v_dSql += N'	        									, A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE                                          ' + char(10)
		SELECT @v_dSql += N'	        									, A.EQUIPMENT_ID      ' + char(10)
		SELECT @v_dSql += N'	        									, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'	        									, A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME, J.CELL_GROUP, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	        									, A.PRODUCTION_TYPE   ' + char(10)
		SELECT @v_dSql += N'	        									, A.MARKET            ' + char(10)
		SELECT @v_dSql += N'	        									, B.ITEM_TYPE         ' + char(10)
		SELECT @v_dSql += N'	        									, A.PLAN_TYPE         ' + char(10)
		SELECT @v_dSql += N'	        									, A.SEQ               ' + char(10)
		SELECT @v_dSql += N'	        									, A.IN_QTY            ' + char(10)
		SELECT @v_dSql += N'	        									, A.OUT_QTY           ' + char(10)
		SELECT @v_dSql += N'	        									, A.CELL_IN_QTY       ' + char(10)
		SELECT @v_dSql += N'	        									, A.CELL_OUT_QTY      ' + char(10)
		SELECT @v_dSql += N'	        									, A.RESULT_QTY_CELL   ' + char(10)
		SELECT @v_dSql += N'	        									, A.RESULT_QTY        ' + char(10)
		SELECT @v_dSql += N'	        									, A.TARGET_QTY        ' + char(10)
		SELECT @v_dSql += N'	        									, A.OFF_TIME          ' + char(10)
		SELECT @v_dSql += N'	        									, A.CUT_QTY           ' + char(10)
		SELECT @v_dSql += N'	        									, A.GAP_QTY           ' + char(10)
		SELECT @v_dSql += N'	        									, A.GAP_CELL_QTY      ' + char(10)
		SELECT @v_dSql += N'	    							   FROM (                         ' + char(10)
		SELECT @v_dSql += N'	    										-- 생산실적 차질분 계산                            ' + char(10)
		SELECT @v_dSql += N'	    										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                ' + char(10)
		SELECT @v_dSql += N'	              										, A.LOCATION, A.OPERATION_ID               ' + char(10)
		SELECT @v_dSql += N'	              										, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'	              										, A.EQUIPMENT_ID                           ' + char(10)
		SELECT @v_dSql += N'	              										, A.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'	              										, A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	              										, A.PRODUCTION_TYPE                        ' + char(10)
		SELECT @v_dSql += N'	              										, A.MARKET    ' + char(10)
		SELECT @v_dSql += N'	              										, A.PLAN_TYPE ' + char(10)
		SELECT @v_dSql += N'	              										, '''' AS SEQ ' + char(10)
		SELECT @v_dSql += N'	              										, 0 AS IN_QTY ' + char(10)
		SELECT @v_dSql += N'	              										, 0 AS OUT_QTY' + char(10)
		SELECT @v_dSql += N'	              										, 0 AS CELL_IN_QTY                         ' + char(10)
		SELECT @v_dSql += N'	              										, 0 AS CELL_OUT_QTY                        ' + char(10)
		SELECT @v_dSql += N'	              										, 0 AS RESULT_QTY_CELL                     ' + char(10)
		SELECT @v_dSql += N'	              										, 0 AS RESULT_QTY                          ' + char(10)
		SELECT @v_dSql += N'	              										, 0 AS TARGET_QTY                          ' + char(10)
		SELECT @v_dSql += N'	              										, 0 AS OFF_TIME                            ' + char(10)
		SELECT @v_dSql += N'	              										, 0 AS CUT_QTY' + char(10)
		SELECT @v_dSql += N'	              										, SUM(ISNULL(A.RESULT_QTY,0)) - SUM(ISNULL(A.OUT_QTY,0)) AS GAP_QTY                                    ' + char(10)
		SELECT @v_dSql += N'	              										, ROUND(SUM(ISNULL(A.RESULT_QTY_CELL,0)),0) - ROUND(SUM(ISNULL(A.CELL_OUT_QTY,0)),0) AS GAP_CELL_QTY   ' + char(10)
		SELECT @v_dSql += N'	    										FROM (                ' + char(10)
		SELECT @v_dSql += N'	    											  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                  ' + char(10)
		SELECT @v_dSql += N'	        													, A.LOCATION, A.OPERATION_ID       ' + char(10)
		SELECT @v_dSql += N'	        													, A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE                                               ' + char(10)
		SELECT @v_dSql += N'	        													, '''' AS EQUIPMENT_ID             ' + char(10)
		SELECT @v_dSql += N'	        													, A.PLAN_DATE                      ' + char(10)
		SELECT @v_dSql += N'	        													, A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	        													, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE                                                      ' + char(10)
		SELECT @v_dSql += N'	        													, A.MARKET                         ' + char(10)
		SELECT @v_dSql += N'	        													, ''DPP'' AS PLAN_TYPE             ' + char(10)
		SELECT @v_dSql += N'	        													, ISNULL(A.PLAN_QTY,0) AS OUT_QTY  ' + char(10)
		SELECT @v_dSql += N'	        													, ISNULL(A.CELL_OUT_QTY,0) AS CELL_OUT_QTY                                                     ' + char(10)
		SELECT @v_dSql += N'	        													, 0 AS RESULT_QTY                  ' + char(10)
		SELECT @v_dSql += N'	        													, 0 AS RESULT_QTY_CELL             ' + char(10)
		SELECT @v_dSql += N'	    											  FROM   #FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                                        ' + char(10)
		SELECT @v_dSql += N'	    											  WHERE  1=1      ' + char(10)
		--SELECT @v_dSql += N'														AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                ' + char(10)
		SELECT @v_dSql += N'														AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		SELECT @v_dSql += N'														AND    A.PLAN_TYPE = ''RELEASE''      ' + char(10)
		/*
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		*/
		SELECT @v_dSql += N'														AND   (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0                ' + char(10)
		SELECT @v_dSql += N'	    											  UNION ALL       ' + char(10)
		SELECT @v_dSql += N'	    											  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                  ' + char(10)
		SELECT @v_dSql += N'	        												  , A.LOCATION, A.OPERATION_ID         ' + char(10)
		SELECT @v_dSql += N'	        												  , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE                                                 ' + char(10)
		SELECT @v_dSql += N'	        												  , '''' AS EQUIPMENT_ID               ' + char(10)
		SELECT @v_dSql += N'	        												  , A.PLAN_DATE                        ' + char(10)
		SELECT @v_dSql += N'	        												  , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	        												  , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE                                                        ' + char(10)
		SELECT @v_dSql += N'	        												  , A.MARKET                           ' + char(10)
		SELECT @v_dSql += N'	        												  , ''DPP'' AS PLAN_TYPE               ' + char(10)
		SELECT @v_dSql += N'	        												  , 0 AS CELL_IN_QTY                   ' + char(10)
		SELECT @v_dSql += N'	        												  , 0 AS CELL_OUT_QTY                  ' + char(10)
		SELECT @v_dSql += N'	        												  , A.ACTUAL_GOOD_QTY AS RESULT_QTY    ' + char(10)
		SELECT @v_dSql += N'	        												  , A.CELL_OUT_QTY AS RESULT_QTY_CELL  ' + char(10)
		SELECT @v_dSql += N'	    											  FROM   #SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)                                                         ' + char(10)
		SELECT @v_dSql += N'	    											  WHERE  1=1      ' + char(10)
		--SELECT @v_dSql += N'													  AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                ' + char(10)
		SELECT @v_dSql += N'													  AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
		/*
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		*/
		SELECT @v_dSql += N'														AND 	(A.CELL_OUT_QTY + A.ACTUAL_GOOD_QTY) > 0                   ' + char(10)
		SELECT @v_dSql += N'	    										) A                   ' + char(10)
		SELECT @v_dSql += N'	    										-- 확정시점 가져오기  ' + char(10)
		
		IF @p_confirm_area = 'BUILDING' BEGIN
			SELECT @v_dSql += N'			                        INNER JOIN (                ' + char(10)
			SELECT @v_dSql += N'			                                    								SELECT A.FACTORY_ID, CONVERT(DATETIME,A.INSTANCE_DATE) AS INSTANCE_DATE    ' + char(10)
			SELECT @v_dSql += N'			                                    								FROM (         ' + char(10)
			SELECT @v_dSql += N'			                                    									SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME                           ' + char(10)
			SELECT @v_dSql += N'			                                    										 , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM                     ' + char(10)
			SELECT @v_dSql += N'			                                    									FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                           ' + char(10)
			SELECT @v_dSql += N'			                                    									WHERE  1=1                   ' + char(10)
			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'			                                    									AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'			                                    									AND    A.FACTORY_ID IN (                                               ' + char(10)
			SELECT @v_dSql += N'			                                      										SELECT DISTINCT B.FACTORY_ID                                   ' + char(10)
			SELECT @v_dSql += N'			                                      										FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                    ' + char(10)
			SELECT @v_dSql += N'			                                      										INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)                        ' + char(10)
			SELECT @v_dSql += N'			                                      										ON    A.FACTORY_ID  = B.FACTORY_ID                             ' + char(10)
			SELECT @v_dSql += N'			                                      										AND   A.ACTIVE_FLAG = ''Y''                                    ' + char(10)
			SELECT @v_dSql += N'			                                      										AND   B.ACTIVE_FLAG = ''Y''                                    ' + char(10)
			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'			                                      										AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
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
			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'		                                                  		AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'		                                                  		AND    A.PLAN_GROUP_ID IN (' + char(10)
			SELECT @v_dSql += N'		                                                  				SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID                                    ' + char(10)
			SELECT @v_dSql += N'		                                                  				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                     ' + char(10)
			SELECT @v_dSql += N'		                                                  				WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''                        ' + char(10)
			SELECT @v_dSql += N'		                                                  				AND    A.ACTIVE_FLAG = ''Y''                                                   ' + char(10)
			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'		                                                  				AND    A.SEGMENT1 = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'		                                                  		)                          ' + char(10)
			SELECT @v_dSql += N'		                                                  	) A                            ' + char(10)
			SELECT @v_dSql += N'		                                                  	WHERE A.ROW_NUM = 1            ' + char(10)
			SELECT @v_dSql += N'		                                                  ) B   ' + char(10)
			SELECT @v_dSql += N'		                                                  ON    C.MODEL_TYPE = B.PLAN_GROUP_ID                                                           ' + char(10)
			SELECT @v_dSql += N'		                                                  WHERE A.PLAN_DATE >= B.INSTANCE_DATE                                                           ' + char(10)
		END
		
		SELECT @v_dSql += N'	  									GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                              ' + char(10)
		SELECT @v_dSql += N'	  										 , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID                            ' + char(10)
		SELECT @v_dSql += N'	  										 , A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	  										 , A.PRODUCTION_TYPE, A.MARKET, A.PLAN_TYPE            ' + char(10)
		SELECT @v_dSql += N'								  ) A                                 ' + char(10)
		SELECT @v_dSql += N'								  INNER JOIN (                        ' + char(10)
		SELECT @v_dSql += N'										SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,                    ' + char(10)
		SELECT @v_dSql += N'										       A.ITEM_ID,                             ' + char(10)
		SELECT @v_dSql += N'										       (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME                          ' + char(10)
		SELECT @v_dSql += N'										       	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                                                     ' + char(10)
		SELECT @v_dSql += N'										       	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,                        ' + char(10)
		SELECT @v_dSql += N'										       ISNULL(A.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
		SELECT @v_dSql += N'										FROM	 SCM_ITEM_M A WITH(NOLOCK),           ' + char(10)
		SELECT @v_dSql += N'										  		 SCM_ITEM_CLASS_M C WITH(NOLOCK)      ' + char(10)
		SELECT @v_dSql += N'										WHERE	 A.ITEM_CLASS  = C.CLASS_ID           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	  							) B                                   ' + char(10)
		SELECT @v_dSql += N'	  							ON     A.COMPANY_ID     = B.COMPANY_ID' + char(10)
		SELECT @v_dSql += N'	  							AND    A.DIVISION_ID    = B.DIVISION_ID                            ' + char(10)
		SELECT @v_dSql += N'	  							AND    A.SITE_ID        = B.SITE_ID   ' + char(10)
		SELECT @v_dSql += N'	  							AND    A.TOP_ITEM_ID    = B.ITEM_ID   ' + char(10)
		SELECT @v_dSql += N'	  							INNER JOIN SCM_LINE_M C WITH(NOLOCK)  ' + char(10)
		SELECT @v_dSql += N'	  							ON     A.COMPANY_ID     = C.COMPANY_ID' + char(10)
		SELECT @v_dSql += N'	  							AND    A.DIVISION_ID    = C.DIVISION_ID                            ' + char(10)
		SELECT @v_dSql += N'	  							AND    A.SITE_ID        = C.SITE_ID   ' + char(10)
		SELECT @v_dSql += N'	  							AND    A.PLANT_ID       = C.PLANT_ID  ' + char(10)
		SELECT @v_dSql += N'	  							AND    A.FACTORY_ID     = C.FACTORY_ID' + char(10)
		SELECT @v_dSql += N'	  							AND    A.OPERATION_ID   = C.OPERATION_ID                           ' + char(10)
		SELECT @v_dSql += N'	  							AND    A.LINE_ID        = C.LINE_ID   ' + char(10)
		SELECT @v_dSql += N'	  							AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE                         ' + char(10)
		SELECT @v_dSql += N'	  							INNER JOIN SCM_OPERATION_M D WITH(NOLOCK)                          ' + char(10)
		SELECT @v_dSql += N'	  							ON     A.COMPANY_ID     = D.COMPANY_ID' + char(10)
		SELECT @v_dSql += N'	  							AND    A.DIVISION_ID    = D.DIVISION_ID                            ' + char(10)
		SELECT @v_dSql += N'	  							AND    A.SITE_ID        = D.SITE_ID   ' + char(10)
		SELECT @v_dSql += N'	  							AND    A.OPERATION_ID   = D.OPERATION_ID                           ' + char(10)
		SELECT @v_dSql += N'	  							INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)    ' + char(10)
		SELECT @v_dSql += N'	  							ON     A.COMPANY_ID     = J.COMPANY_ID            ' + char(10)
		SELECT @v_dSql += N'	  							AND    A.DIVISION_ID    = J.DIVISION_ID           ' + char(10)
		SELECT @v_dSql += N'	  							AND    A.SITE_ID        = J.SITE_ID               ' + char(10)
		SELECT @v_dSql += N'	  							AND    A.TOP_ITEM_ID    = J.ITEM_ID               ' + char(10)
		--SELECT @v_dSql += N'	  							WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'	  							' + @chk_gap + char(10) -- 카테고리 체크 여부에 따른 처리
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('J.CELL_GROUP' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'						  ) A                                         ' + char(10)
		SELECT @v_dSql += N'						  INNER JOIN (                                ' + char(10)
		SELECT @v_dSql += N'	                SELECT *                                          ' + char(10)
		SELECT @v_dSql += N'	                FROM (                                            ' + char(10)
		
		IF ISNULL(@p_cate_info,'') <> '' BEGIN

			SELECT @v_dSql += N'	SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 0 AS CATEGORY_ORDER   ' + char(10)
			
			IF @bGap = 'Y' AND @bCell = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''GAP'' AS CATEGORY_ID, ''Accu. GAP'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 153 AS CATEGORY_ORDER   ' + char(10)
			END IF @bGap = 'Y' AND @bUom = 'Y' BEGIN
				SELECT @v_dSql += N'	UNION ALL                 ' + char(10)
				SELECT @v_dSql += N'	SELECT ''GAP'' AS CATEGORY_ID, ''Accu. GAP'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 154 AS CATEGORY_ORDER     ' + char(10)
			END

		END ELSE BEGIN
			
			SELECT @v_dSql += N'	      SELECT ''GAP'' AS CATEGORY_ID, ''Accu. GAP'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 153 AS CATEGORY_ORDER       ' + char(10)
			SELECT @v_dSql += N'	      UNION ALL  ' + char(10)
			SELECT @v_dSql += N'	      SELECT ''GAP'' AS CATEGORY_ID, ''Accu. GAP'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 154 AS CATEGORY_ORDER         ' + char(10)

		END
		
		SELECT @v_dSql += N'	                ) BB                                              ' + char(10)
		SELECT @v_dSql += N'	                WHERE CATEGORY_ID <> ''X''                        ' + char(10)
		SELECT @v_dSql += N'						  ) B                                         ' + char(10)
		SELECT @v_dSql += N'						  ON 1=1                                      ' + char(10)
		SELECT @v_dSql += N'						  INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'						  ON  A.PLAN_DATE = C.YYYYMMDD ' + char(10)
		SELECT @v_dSql += N'						  -- 확정시점 가져오기 ' + char(10)

		IF @p_confirm_area = 'BUILDING' BEGIN
			SELECT @v_dSql += N'	                INNER JOIN (                                ' + char(10)
			SELECT @v_dSql += N'	                                        SELECT A.FACTORY_ID, A.INSTANCE_DATE             ' + char(10)
			SELECT @v_dSql += N'	                                        FROM (              ' + char(10)
			SELECT @v_dSql += N'	                                            SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME                    ' + char(10)
			SELECT @v_dSql += N'	                                            , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM                   ' + char(10)
			SELECT @v_dSql += N'	                                            FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'	                                            WHERE  1=1                                                     ' + char(10)
			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'	                                            AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'	                                            AND    A.FACTORY_ID IN (                     ' + char(10)
			SELECT @v_dSql += N'	                                                SELECT DISTINCT B.FACTORY_ID             ' + char(10)
			SELECT @v_dSql += N'	                                                FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                                                          ' + char(10)
			SELECT @v_dSql += N'	                                                INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql += N'	                                                ON    A.FACTORY_ID  = B.FACTORY_ID       ' + char(10)
			SELECT @v_dSql += N'	                                                AND   A.ACTIVE_FLAG = ''Y''              ' + char(10)
			SELECT @v_dSql += N'	                                                AND   B.ACTIVE_FLAG = ''Y''              ' + char(10)
			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'	                                                AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
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
			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'	                                                AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'	                                          		AND    A.PLAN_GROUP_ID IN (            ' + char(10)
			SELECT @v_dSql += N'	                                          				SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID                                                ' + char(10)
			SELECT @v_dSql += N'	                                          				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                 ' + char(10)
			SELECT @v_dSql += N'	                                          				WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''                                    ' + char(10)
			SELECT @v_dSql += N'	                                          				AND    A.ACTIVE_FLAG = ''Y''   ' + char(10)
			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @p_instance_id)) + char(10)
			SELECT @v_dSql += N'	                                          				AND    A.SEGMENT1 = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'	                                          		)         ' + char(10)
			SELECT @v_dSql += N'	                                          	) A           ' + char(10)
			SELECT @v_dSql += N'	                                          	WHERE A.ROW_NUM = 1                        ' + char(10)
			SELECT @v_dSql += N'	                                          ) D               ' + char(10)
			SELECT @v_dSql += N'	                                          ON    E.MODEL_TYPE = D.PLAN_GROUP_ID           ' + char(10)
		END
		
		SELECT @v_dSql += N'	            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID          ' + char(10)
		SELECT @v_dSql += N'	                  , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME  ' + char(10)
		SELECT @v_dSql += N'	                  , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE      ' + char(10)
		SELECT @v_dSql += N'	                  , A.EQUIPMENT_ID                                ' + char(10)
		SELECT @v_dSql += N'	                  , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	                  , A.PRODUCTION_TYPE, A.MARKET, A.ITEM_TYPE      ' + char(10)
		SELECT @v_dSql += N'	                  , B.CATEGORY_ID, B.CATEGORY_NAME, B.MEASURE_ID, B.MEASURE_NAME, B.CATEGORY_ORDER                                                         ' + char(10)
		SELECT @v_dSql += N'				) A                                                   ' + char(10)
		SELECT @v_dSql += N'			) A                                                       ' + char(10)
		SELECT @v_dSql += N'		) A                                                           ' + char(10)
		SELECT @v_dSql += N'; ' + char(10)
		--SELECT @v_dSql += N'	 )     ' + char(10)
		--SELECT @v_dSql += N'	, T_RELEASE AS (                                                    ' + char(10)
		--SELECT @v_dSql += N'	SELECT A.FACTORY_ID                                               ' + char(10)

		--IF ISNULL(@p_bucket,'') <> '' BEGIN
		--	IF @max_loop_cnt > 0 BEGIN
		--		-- Day bucket
		--		SET @mst_loop_cnt = 0	

		--		WHILE @mst_loop_cnt < @max_loop_cnt
		--		BEGIN

		--			SET @mst_loop_cnt =  @mst_loop_cnt + 1
		--			SET @tmp_column = ''
		--			SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_row_delimiter, @mst_loop_cnt)
		--			SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)

		--			IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END
		--			--IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 3)   END
					
		--			SELECT @v_dSql += N'	            , MAX(CASE WHEN CONVERT(VARCHAR,A.RELEASE_DATE,112) = ''' + @sub_param_0 + ''' THEN ''Y'' ELSE NULL END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_BG    ' + char(10)

		--		END		-- end of @mst_loop_cnt < @max_loop_cnt

		--	END		--end of @max_loop_cnt

		--END		-- end of isnull(@p_bucket,'') <> ''

		--SELECT @v_dSql += N'	INTO #T_RELEASE ' + char(10)

		--SELECT @v_dSql += N'	)      ' + char(10)
		SELECT @v_dSql += N'	SELECT A.*                                                          ' + char(10)
		
		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN

					SELECT @v_dSql += N'	         ,	CASE WHEN A.DATA_TYPE=''TOTAL_2'' THEN ''#FFBA85''                         ' + char(10)
					SELECT @v_dSql += N'	          		   WHEN A.DATA_TYPE=''TOTAL'' THEN ''#FFE5C2''                         ' + char(10)
					--SELECT @v_dSql += N'	          		   WHEN A.DATA_TYPE=''DATA'' THEN (CASE WHEN F.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_BG = ''Y'' THEN ''#FFFFE6'' ELSE '''' END )                              ' + char(10)
					SELECT @v_dSql += N'	          		   ELSE '''' END AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_BG         ' + char(10)

					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	FROM (  ' + char(10)
		SELECT @v_dSql += N'	  SELECT * FROM #MAIN                                              ' + char(10)
		SELECT @v_dSql += N'	  UNION ALL                                                       ' + char(10)
		SELECT @v_dSql += N'	  SELECT * FROM #MAIN_GAP                                          ' + char(10)
		SELECT @v_dSql += N'	  UNION ALL ' + char(10)
		SELECT @v_dSql += N'	  SELECT * FROM #MAIN_GAP_WPP MGW WITH(NOLOCK) ' + char(10) -- gap(WPP) 추가
		SELECT @v_dSql += N'	  UNION ALL                                                       ' + char(10)
		SELECT @v_dSql += N'	  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME                                    ' + char(10)
		SELECT @v_dSql += N'	        ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID             ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_GROUP, NULL AS PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE                            ' + char(10)
		SELECT @v_dSql += N'	        ,A.CATE                                                   ' + char(10)
		SELECT @v_dSql += N'	        ,A.MEASURE_NAME                                           ' + char(10)

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
		
		SELECT @v_dSql += N'	  			,A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER        ' + char(10)
		SELECT @v_dSql += N'	        ,''TOTAL'' AS DATA_TYPE                                   ' + char(10)
		SELECT @v_dSql += N'	  FROM   #MAIN A                                                   ' + char(10)
		SELECT @v_dSql += @sub_total
		SELECT @v_dSql += N'	  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME, A.LINE_ID, A.ELECTRODE_TYPE     ' + char(10)
		SELECT @v_dSql += N'	          ,A.CATE, A.MEASURE_NAME, A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER               ' + char(10)
		SELECT @v_dSql += N'	  UNION ALL                                                       ' + char(10)
		SELECT @v_dSql += N'	  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME                                    ' + char(10)
		SELECT @v_dSql += N'	        ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID             ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_GROUP, NULL AS PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE                            ' + char(10)
		SELECT @v_dSql += N'	        ,A.CATE                                                   ' + char(10)
		SELECT @v_dSql += N'	        ,A.MEASURE_NAME                                           ' + char(10)

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

		SELECT @v_dSql += N'	  			,A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER        ' + char(10)
		SELECT @v_dSql += N'	        ,''TOTAL'' AS DATA_TYPE                                   ' + char(10)
		SELECT @v_dSql += N'	  FROM   #MAIN_GAP A                                               ' + char(10)
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'	  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME, A.LINE_ID, A.ELECTRODE_TYPE     ' + char(10)
		SELECT @v_dSql += N'	          ,A.CATE, A.MEASURE_NAME, A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER               ' + char(10)
		-- gap(WPP) 추가
		SELECT @v_dSql += N'	  UNION ALL ' + char(10)
		SELECT @v_dSql += N'	  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'	        ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_GROUP, NULL AS PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE ' + char(10)
		SELECT @v_dSql += N'	        ,A.CATE ' + char(10)
		SELECT @v_dSql += N'	        ,A.MEASURE_NAME ' + char(10)

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
		
		SELECT @v_dSql += N'	        , A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'	        , ''TOTAL'' AS DATA_TYPE ' + char(10)
		SELECT @v_dSql += N'	  FROM   #MAIN_GAP_WPP A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	  ' + @sub_total
		SELECT @v_dSql += N'	  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME, A.LINE_ID, A.ELECTRODE_TYPE     ' + char(10)
		SELECT @v_dSql += N'	          ,A.CATE, A.MEASURE_NAME, A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER               ' + char(10)
		SELECT @v_dSql += N'	  UNION ALL                                                       ' + char(10)
		SELECT @v_dSql += N'	  SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, A.OPERATION_ID AS OPERATION_ID, A.OPERATION_NAME                         ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_GROUP, NULL AS PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE                            ' + char(10)
		SELECT @v_dSql += N'	        ,A.CATE                                                   ' + char(10)
		SELECT @v_dSql += N'	        ,A.MEASURE_NAME                                           ' + char(10)
		
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

		SELECT @v_dSql += N'	  			,A.CATEGORY_ID, A.MEASURE_NAME, A.CATEGORY_ORDER      ' + char(10)
		SELECT @v_dSql += N'	        ,''TOTAL_2'' AS DATA_TYPE                                 ' + char(10)
		SELECT @v_dSql += N'	  FROM   #MAIN A                                                   ' + char(10)
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'	  GROUP BY A.OPERATION_ID, A.OPERATION_NAME, A.CATE, A.CATEGORY_ID, A.MEASURE_NAME, A.MEASURE_ID, A.CATEGORY_ORDER                                         ' + char(10)
		SELECT @v_dSql += N'	  UNION ALL                                                       ' + char(10)
		SELECT @v_dSql += N'	  SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, A.OPERATION_ID AS OPERATION_ID, A.OPERATION_NAME                         ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_GROUP, NULL AS PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE                            ' + char(10)
		SELECT @v_dSql += N'	        ,A.CATE                                                   ' + char(10)
		SELECT @v_dSql += N'	        ,A.MEASURE_NAME                                           ' + char(10)
		
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
		
		SELECT @v_dSql += N'	  			,A.CATEGORY_ID, A.MEASURE_NAME, A.CATEGORY_ORDER      ' + char(10)
		SELECT @v_dSql += N'	        ,''TOTAL_2'' AS DATA_TYPE                                 ' + char(10)
		SELECT @v_dSql += N'	  FROM   #MAIN_GAP A                                               ' + char(10)
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'	  GROUP BY A.OPERATION_ID, A.OPERATION_NAME, A.CATE, A.CATEGORY_ID, A.MEASURE_NAME, A.MEASURE_ID, A.CATEGORY_ORDER                                         ' + char(10)
		-- gap(WPP) 추가
		SELECT @v_dSql += N'	  UNION ALL ' + char(10)
		SELECT @v_dSql += N'	  SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, A.OPERATION_ID AS OPERATION_ID, A.OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_GROUP, NULL AS PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	        ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE ' + char(10)
		SELECT @v_dSql += N'	        ,A.CATE ' + char(10)
		SELECT @v_dSql += N'	        ,A.MEASURE_NAME ' + char(10)
		
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
		
		SELECT @v_dSql += N'	  			,A.CATEGORY_ID, A.MEASURE_NAME, A.CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'	        ,''TOTAL_2'' AS DATA_TYPE ' + char(10)
		SELECT @v_dSql += N'	  FROM   #MAIN_GAP_WPP A WITH(NOLOCK)' + char(10)
		SELECT @v_dSql += N'	  ' + @total
		SELECT @v_dSql += N'	  GROUP BY A.OPERATION_ID, A.OPERATION_NAME, A.CATE, A.CATEGORY_ID, A.MEASURE_NAME, A.MEASURE_ID, A.CATEGORY_ORDER ' + char(10)

		SELECT @v_dSql += N'	) A     ' + char(10)
		SELECT @v_dSql += N'	LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)                           ' + char(10)
		SELECT @v_dSql += N'	ON A.COMPANY_ID      = B.COMPANY_ID                                ' + char(10)
		SELECT @v_dSql += N'	AND A.DIVISION_ID     = B.DIVISION_ID                               ' + char(10)
		SELECT @v_dSql += N'	AND A.SITE_ID         = B.SITE_ID                                   ' + char(10)
		SELECT @v_dSql += N'	AND A.PLANT_ID        = B.PLANT_ID                                  ' + char(10)
		SELECT @v_dSql += N'	AND A.FACTORY_ID      = B.FACTORY_ID                                ' + char(10)
		SELECT @v_dSql += N'	AND A.OPERATION_ID    = B.OPERATION_ID                              ' + char(10)
		SELECT @v_dSql += N'	AND A.LINE_ID         = B.LINE_ID                                   ' + char(10)
		SELECT @v_dSql += N'	AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE                            ' + char(10)
		--SELECT @v_dSql += N'	LEFT OUTER JOIN #T_RELEASE F WITH(NOLOCK)                            ' + char(10)
		--SELECT @v_dSql += N'	ON  (CASE WHEN '''+ @p_confirm_area +''' = ''BUILDING'' THEN A.FACTORY_ID ELSE B.MODEL_TYPE END) = F.FACTORY_ID                                                         ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION            ' + char(10)
		SELECT @v_dSql += N'	     , A.LINE_ID                                                  ' + char(10)
		SELECT @v_dSql += N'	     , (CASE WHEN A.TOP_ITEM_ID IS NOT NULL THEN A.TOP_ITEM_ID ELSE ''ZZZZZ'' END)             ' + char(10)
		SELECT @v_dSql += N'	     , A.OPERATION_ID DESC                                        ' + char(10)
		SELECT @v_dSql += N'	     , A.EQUIPMENT_ID, A.ITEM_ID, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'	     , A.PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE              ' + char(10)
		SELECT @v_dSql += N'	     , A.CATEGORY_ORDER                                           ' + char(10)

		
		SELECT @v_dSql += N'SELECT FACTORY_ID, RELEASE_DATE	INTO #T_RELEASE2 ' + char(10)
		SELECT @v_dSql += N'	FROM (' + char(10)
		SELECT @v_dSql += N'	  SELECT A.FACTORY_ID, CONVERT(VARCHAR,B.INSERT_TIME,112) AS RELEASE_DATE                      ' + char(10)
		SELECT @v_dSql += N'	  FROM (                                                          ' + char(10)
		SELECT @v_dSql += N'	    SELECT A.INSTANCE_ID, A.RELEASE_PLAN_ID AS PLAN_ID, ''BUILDING'' AS CONFIRM_AREA           ' + char(10)
		SELECT @v_dSql += N'	         , A.FACTORY_ID, A.INSERT_TIME                            ' + char(10)
		SELECT @v_dSql += N'	         , DENSE_RANK() OVER(PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) SORT_ORDER ' + char(10)
		SELECT @v_dSql += N'	    FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                  ' + char(10)
		SELECT @v_dSql += N'	    , (                                                           ' + char(10)
		SELECT @v_dSql += N'	      SELECT DISTINCT A.INSTANCE_ID, A.FACTORY_ID                 ' + char(10)
		SELECT @v_dSql += N'	      FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                 ' + char(10)
		SELECT @v_dSql += N'	      WHERE  A.ACTIVE_FLAG = ''Y''                                ' + char(10)
		SELECT @v_dSql += N'	      AND    A.INSTANCE_ID = '''+ @p_instance_id +'''                        ' + char(10)
		SELECT @v_dSql += N'	    ) B                                                           ' + char(10)
		SELECT @v_dSql += N'	    WHERE  A.INSTANCE_ID  = B.INSTANCE_ID                         ' + char(10)
		SELECT @v_dSql += N'	    AND    A.FACTORY_ID   = B.FACTORY_ID                          ' + char(10)
		SELECT @v_dSql += N'	    AND    A.INSTANCE_ID  = '''+ @p_instance_id +'''                         ' + char(10)
		SELECT @v_dSql += N'	  ) A ' + char(10)
		SELECT @v_dSql += N'	  , SCM_FP_PLAN_H B WITH(NOLOCK)                                  ' + char(10)
		SELECT @v_dSql += N'	  WHERE A.INSTANCE_ID  = B.INSTANCE_ID                            ' + char(10)
		SELECT @v_dSql += N'	  AND   A.PLAN_ID      = B.PLAN_ID                                ' + char(10)
		SELECT @v_dSql += N'	  AND   A.SORT_ORDER   = 1                                        ' + char(10)
		SELECT @v_dSql += N'	  AND   A.CONFIRM_AREA IN (                                       ' + char(10)
		SELECT @v_dSql += N'	    SELECT MAX(A.ATTRIBUTE1) AS CONFIRM_AREA                      ' + char(10)
		SELECT @v_dSql += N'	    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                    ' + char(10)
		SELECT @v_dSql += N'	    WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                   ' + char(10)
		SELECT @v_dSql += N'	    AND    A.SEGMENT1         = '''+ @p_instance_id +'''                     ' + char(10)
		SELECT @v_dSql += N'	    AND    A.ACTIVE_FLAG      = ''Y''                             ' + char(10)
		SELECT @v_dSql += N'	  )   ' + char(10)
		SELECT @v_dSql += N'	  UNION ALL                                                       ' + char(10)
		SELECT @v_dSql += N'	  SELECT A.PLAN_GROUP_ID AS FACTORY_ID, CONVERT(VARCHAR,B.INSERT_TIME,112) AS RELEASE_DATE     ' + char(10)
		SELECT @v_dSql += N'	  FROM (                                                          ' + char(10)
		SELECT @v_dSql += N'	  	SELECT A.INSTANCE_ID, A.RELEASE_PLAN_ID AS PLAN_ID, ''PLAN GROUP'' AS CONFIRM_AREA         ' + char(10)
		SELECT @v_dSql += N'	  		   , A.PLAN_GROUP_ID, A.INSERT_TIME                       ' + char(10)
		SELECT @v_dSql += N'	  	     , DENSE_RANK() OVER(PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) SORT_ORDER                                                          ' + char(10)
		SELECT @v_dSql += N'	  	FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                  ' + char(10)
		SELECT @v_dSql += N'	  	, (                                                           ' + char(10)
		SELECT @v_dSql += N'	  		SELECT A.SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS PLAN_GROUP_ID                            ' + char(10)
		SELECT @v_dSql += N'	  		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                ' + char(10)
		SELECT @v_dSql += N'	  		WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''   ' + char(10)
		SELECT @v_dSql += N'	  		AND    A.SEGMENT1		      = '''+ @p_instance_id +'''             ' + char(10)
		SELECT @v_dSql += N'	  		AND    A.ACTIVE_FLAG	    = ''Y''                       ' + char(10)
		SELECT @v_dSql += N'	  	) B                                                           ' + char(10)
		SELECT @v_dSql += N'	  	WHERE  A.INSTANCE_ID   = B.INSTANCE_ID                        ' + char(10)
		SELECT @v_dSql += N'	  	AND    A.PLAN_GROUP_ID = B.PLAN_GROUP_ID                      ' + char(10)
		SELECT @v_dSql += N'	  	AND    A.INSTANCE_ID   = '''+ @p_instance_id +'''                        ' + char(10)
		SELECT @v_dSql += N'	  ) A ' + char(10)
		SELECT @v_dSql += N'	  , SCM_FP_PLAN_H B WITH(NOLOCK)                                  ' + char(10)
		SELECT @v_dSql += N'	  WHERE A.INSTANCE_ID  = B.INSTANCE_ID                            ' + char(10)
		SELECT @v_dSql += N'	  AND   A.PLAN_ID      = B.PLAN_ID                                ' + char(10)
		SELECT @v_dSql += N'	  AND   A.SORT_ORDER   = 1                                        ' + char(10)
		SELECT @v_dSql += N'	  AND   A.CONFIRM_AREA IN (                                       ' + char(10)
		SELECT @v_dSql += N'	  	SELECT MAX(A.ATTRIBUTE1) AS CONFIRM_AREA                      ' + char(10)
		SELECT @v_dSql += N'	  	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                    ' + char(10)
		SELECT @v_dSql += N'	  	WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                   ' + char(10)
		SELECT @v_dSql += N'	  	AND    A.SEGMENT1         = '''+ @p_instance_id +'''                     ' + char(10)
		SELECT @v_dSql += N'	  	AND    A.ACTIVE_FLAG      = ''Y''                             ' + char(10)
		SELECT @v_dSql += N'	  )   ' + char(10)
		SELECT @v_dSql += N'	) A   ' + char(10)
		--SELECT @v_dSql += N'	GROUP BY A.FACTORY_ID                                             ' + char(10)
		SELECT @v_dSql += N'	GROUP BY A.FACTORY_ID,A.RELEASE_DATE' + char(10)
		SELECT @v_dSql += N'; ' + char(10)
		SELECT @v_dSql += N'SELECT * FROM #T_RELEASE2' + char(10)
		
		-- 임시 테이블 삭제
		BEGIN
			
			SELECT @v_dSql += N'; ' + char(10)+ char(10)
			SELECT @v_dSql += N'if object_id(''tempdb..#MAIN_ITEM_WPP_GAP'') is not null ' + char(10)
			SELECT @v_dSql += N'	drop table #MAIN_ITEM_WPP_GAP ' + char(10)
			SELECT @v_dSql += N'if object_id(''tempdb..#MAIN_GAP_WPP'') is not null ' + char(10)
			SELECT @v_dSql += N'	drop table #MAIN_GAP_WPP ' + char(10)
			-- 임시테이블 추가
			SELECT @v_dSql += N'if object_id(''tempdb..#MAIN'') is not null ' + char(10)
			SELECT @v_dSql += N'	drop table #MAIN ' + char(10)
			SELECT @v_dSql += N'if object_id(''tempdb..#MAIN_GAP'') is not null ' + char(10)
			SELECT @v_dSql += N'	drop table #MAIN_GAP ' + char(10)
			SELECT @v_dSql += N'if object_id(''tempdb..#T_RELEASE'') is not null ' + char(10)
			SELECT @v_dSql += N'	drop table #T_RELEASE ' + char(10)
			SELECT @v_dSql += N'if object_id(''tempdb..#T_RELEASE2'') is not null ' + char(10)
			SELECT @v_dSql += N'	drop table #T_RELEASE2 ' + char(10)
			SELECT @v_dSql += N'if object_id(''tempdb..#FP_CELL_GROUP_V'') is not null ' + char(10)
			SELECT @v_dSql += N'	drop table #FP_CELL_GROUP_V ' + char(10)
			-- 조회속도 관련 raw data 임시테이블 처리... 20231005
			SELECT @v_dSql += N'if object_id(''tempdb..#SCM_DAILY_PRODUCT_RESULT_H'') is not null ' + char(10)
			SELECT @v_dSql += N'	drop table #SCM_DAILY_PRODUCT_RESULT_H ' + char(10)
			SELECT @v_dSql += N'if object_id(''tempdb..#FP_DAILY_PRODUCTIOIN_PLAN_H'') is not null ' + char(10)
			SELECT @v_dSql += N'	drop table #FP_DAILY_PRODUCTIOIN_PLAN_H ' + char(10)
			SELECT @v_dSql += N'if object_id(''tempdb..#CATEGORY_ITEM'') is not null drop table #CATEGORY_ITEM' + char(10)

			SELECT @v_dSql += N' ; ' + char(10)

		END

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

