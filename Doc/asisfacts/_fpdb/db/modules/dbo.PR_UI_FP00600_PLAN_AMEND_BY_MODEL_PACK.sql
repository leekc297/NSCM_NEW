

/*
 * Program ID   : PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK
 * Description  : Plan Amend By Model(Pack)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/04/21   CYS				Initial Release UI통합
 --                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
 * 2024/11/28   leejsthira2     pack amend 완성공정 TEST 입력가능하도록 처리
 * 2026/06/08   kimcd           [PJ2026-50215] ESOC 각형 Pilot 라인 Multi-Stack 공정 FP 대응 Link 공정 추가
 * 2026/08/10   kimcd           [ES20260810] PL450 > PL500 공정 코드 변경
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK]
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

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK';
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
	DECLARE @p_shipment_opt	NVARCHAR(MAX);

	-- week
	DECLARE @p_bucket		NVARCHAR(MAX);
	DECLARE @p_week_info	NVARCHAR(MAX);
	DECLARE @p_month_info	NVARCHAR(MAX);
	
	-- table
	DECLARE @p_amend_table	NVARCHAR(MAX);
	DECLARE @p_amend_sales_table		NVARCHAR(MAX);
	DECLARE @p_amend_cutoff_boh_table	NVARCHAR(MAX);
	DECLARE @p_result_qty	NVARCHAR(MAX);

	DECLARE @v__save_auth	NVARCHAR(MAX);
	DECLARE @v__non_auth	NVARCHAR(MAX);
	DECLARE @v_user_id		NVARCHAR(MAX);

	DECLARE @v_instance_id	NVARCHAR(MAX);
	DECLARE @v_master_id	NVARCHAR(MAX);
	DECLARE @v_plan_id		NVARCHAR(MAX);
	DECLARE @v_plan_date	NVARCHAR(MAX);
	DECLARE @v_bucket_from	NVARCHAR(MAX);
	DECLARE @v_bucket_to	NVARCHAR(MAX);

	DECLARE @v_division_id	NVARCHAR(MAX);
	DECLARE @v_site_id		NVARCHAR(MAX);
	DECLARE @v_plant_id		NVARCHAR(MAX);
	DECLARE @v_factory_id	NVARCHAR(MAX);
	DECLARE @v_operation_id NVARCHAR(MAX);
	DECLARE @v_line_id		NVARCHAR(MAX);
	
	DECLARE @v_top_item_id	NVARCHAR(MAX);
	DECLARE @v_item_id		NVARCHAR(MAX);
	DECLARE @v_nick_name	NVARCHAR(MAX);
	DECLARE @v_prod_type	NVARCHAR(MAX);
	DECLARE @v_prodtype_id	NVARCHAR(MAX);
	DECLARE @v_cate_info	NVARCHAR(MAX);
	DECLARE @v_cell_group	NVARCHAR(MAX);
	DECLARE @v_shipment_opt	NVARCHAR(MAX);
	
	-- week
	DECLARE @v_bucket		NVARCHAR(MAX);
	DECLARE @v_week_info	NVARCHAR(MAX);
	DECLARE @v_month_info	NVARCHAR(MAX);
	

	DECLARE @tmp_column		NVARCHAR(MAX);
	DECLARE @dbg_txt		NVARCHAR(MAX);
	/*	Parameter Setting Start */
	
	SET @v_delimiter            = '^'  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	
	IF OBJECT_ID('tempdb..#TEMP_TABLE_SSP_BOH') IS NOT NULL
DROP TABLE #TEMP_TABLE_SSP_BOH

IF OBJECT_ID('tempdb..#TEMP_TABLE_MAIN_I') IS NOT NULL
DROP TABLE #TEMP_TABLE_MAIN_I

IF OBJECT_ID('tempdb..#TEMP_TABLE_BOH_2ND') IS NOT NULL
DROP TABLE #TEMP_TABLE_BOH_2ND

IF OBJECT_ID('tempdb..#TEMP_TABLE_MAIN_S') IS NOT NULL
DROP TABLE #TEMP_TABLE_MAIN_S

IF OBJECT_ID('tempdb..#TEMP_TABLE_MAIN_P') IS NOT NULL
DROP TABLE #TEMP_TABLE_MAIN_P

IF OBJECT_ID('tempdb..#TABLE_TABLE_MAIN_P_SUBT') IS NOT NULL
DROP TABLE #TABLE_TABLE_MAIN_P_SUBT

IF OBJECT_ID('tempdb..#TEMP_TABLE_DO_INFO') IS NOT NULL
DROP TABLE #TEMP_TABLE_DO_INFO

IF OBJECT_ID('tempdb..#TEMP_TABLE_T_MEMO') IS NOT NULL
DROP TABLE #TEMP_TABLE_T_MEMO

IF OBJECT_ID('tempdb..#TEMP_TABLE_SSP_INFO') IS NOT NULL
DROP TABLE #TEMP_TABLE_SSP_INFO


	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
		
		SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

		SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @in_columns , @v_delimiter , @mst_loop_cnt);
		
		IF @tmp_column = '_SAVE_AUTH' BEGIN
			SET @p__save_auth =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
			SET @p__non_auth =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);

		END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
			SET @p_instance_id =		[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
			SET @p_master_id =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
			SET @p_plan_date =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
			SET @p_plan_id =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
			SET @p_bucket_from =		[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
			SET @dbg_txt += @tmp_column
			SET @dbg_txt += @p_bucket_from
		END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
			SET @p_bucket_to =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);

		END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
			SET @p_division_id =		[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'SITE_ID' BEGIN
			SET @p_site_id =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
			SET @p_plant_id =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
			SET @p_factory_id =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
			SET @p_operation_id =		[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'LINE_ID' BEGIN
			SET @p_line_id =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		
		END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
			SET @p_top_item_id =		[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
			SET @p_item_id =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
			SET @p_nick_name =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'NICK_NAME_LT' BEGIN
			SET @p_nick_name =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'PROD_TYPE' BEGIN
			SET @p_prod_type =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
			END ELSE IF @tmp_column = 'PRODTYPE_ID' BEGIN
			SET @p_prod_type =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'CELL_GROUP' BEGIN
			SET @p_cell_group =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'SHIPMENT_OPT' BEGIN
			SET @p_shipment_opt =		[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);

		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =				[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
			SET @dbg_txt += @tmp_column
			SET @dbg_txt += @p_month_info
		
		END ELSE IF @tmp_column = 'CATE_INFO' BEGIN
			SET @p_cate_info =			[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);

		END ELSE IF @tmp_column = 'AMEND_TABLE' BEGIN
			SET @p_amend_table =		[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'AMEND_SALES_TABLE' BEGIN
			SET @p_amend_sales_table =  [dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'AMEND_CUTOFF_BOH_TABLE' BEGIN
			SET @p_amend_cutoff_boh_table =  [dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
		END ELSE IF @tmp_column = 'RESULT_QTY' BEGIN
			SET @p_result_qty =		[dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);
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

	IF ISNULL(@p_cate_info,'') <> '' BEGIN
		SET @mst_loop_cnt	= 0
		WHILE @mst_loop_cnt < @max_category_loop_cnt
		BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
			SET @mst_loop_cnt =  @mst_loop_cnt + 1
			SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info , @v_row_delimiter , @mst_loop_cnt)
			SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column , @sub_v_delimiter)

			IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_ID')   END
			IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_VALUE')   END

			IF @sub_param_0 = 'chk_total' AND @sub_param_1 = 'false' BEGIN
				SET @sub_total = 'WHERE 1=0' +char(10)
			END
			ELSE IF @sub_param_0 = 'chk_total' AND @sub_param_1 = 'true' BEGIN
				SET @sub_total = 'WHERE 1=1' +char(10)
			END 
			ELSE IF @sub_param_0 = 'chk_total_2' AND @sub_param_1 = 'false' BEGIN
				SET @total = 'WHERE 1=0' +char(10)
			END
			ELSE IF @sub_param_0 = 'chk_total_2' AND @sub_param_1 = 'true' BEGIN
				SET @total = 'WHERE 1=1' +char(10)
			END 
			ELSE IF @sub_param_0 = 'chk_ssp' AND @sub_param_1 = 'false' BEGIN
				SET @ssp_total = 'WHERE 1=0' +char(10)
			END
			ELSE IF @sub_param_0 = 'chk_ssp' AND @sub_param_1 = 'true' BEGIN
				SET @ssp_total = 'WHERE 1=1' +char(10)
			END 
		END -- WHILE
	END -- IF ISNULL(@p_cate_info,'') 
	exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@p_shipment_opt,'@p_shipment_opt',@runstart, @runend
	BEGIN

		SET	@v_dSql = ''

		--SELECT @v_dSql += N'	WITH SSP_BOH AS (' + char(10) -- fix remove 20221014
		SELECT @v_dSql += N'						SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FP_APPLY_ITEM_ID AS TOP_ITEM_ID                              ' + char(10)
		SELECT @v_dSql += N'								, SUM(STOCK_QTY) AS BOH_QTY                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'								, SUM(HOLD_QTY) AS HOLD_QTY                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'INTO #TEMP_TABLE_SSP_BOH' + char(10) -- fix added 20221014
		SELECT @v_dSql += N'						FROM    (                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'										-- 완성창고                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'										SELECT	A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID , A.FACTORY_ID, A.ITEM_ID, A.FP_APPLY_ITEM_ID                          ' + char(10)
		SELECT @v_dSql += N'												, A.FP_APPLY_OPERATION_ID                                                                                                   ' + char(10)
		SELECT @v_dSql += N'												, ISNULL( A.MODIFY_FP_APPLY_WIPQTY  ,A.FP_APPLY_WIPQTY)  AS STOCK_QTY                                                       ' + char(10)
		SELECT @v_dSql += N'												, CASE WHEN A.WIPHOLD_YN = ''Y'' THEN ISNULL( A.MODIFY_FP_APPLY_WIPQTY  ,A.FP_APPLY_WIPQTY) ELSE 0 END AS HOLD_QTY          ' + char(10)
		SELECT @v_dSql += N'										FROM	SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                  ' + char(10)
		SELECT @v_dSql += N'										WHERE	1=1                                                                                                                         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'										AND		CONVERT(VARCHAR, A.CUTOFF_DATE, 112) = '''+ @p_plan_date +'''                                                                         ' + char(10)
		SELECT @v_dSql += N'										AND		A.STOCK_TYPE  = ''WIP''                                                                                                     ' + char(10)
		SELECT @v_dSql += N'										AND		A.FP_APPLY_OPERATION_ID IN ( ''P5500'' , ''P9500''  , ''PL500'' )                                                           ' + char(10) --2026.08.10 kimcd [ES20260810] PL450 > PL500 공정 코드 변경. 2026/06/08 kimcd [PJ2026-50215] ESOC 각형 Pilot 라인 Multi-Stack 공정 FP 대응 Link 공정 추가
		SELECT @v_dSql += N'										UNION ALL                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'										-- 물류창고                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'										SELECT	A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID , A.FACTORY_ID, A.ITEM_ID, A.FP_APPLY_ITEM_ID                          ' + char(10)
		SELECT @v_dSql += N'												, ISNULL(A.FP_APPLY_OPERATION_ID , B.LAST_FLOW_ID) AS FP_APPLY_OPERATION_ID                                                 ' + char(10)
		SELECT @v_dSql += N'												, ISNULL(A.QTY2,0)  AS STOCK_QTY                                                                                            ' + char(10)
		SELECT @v_dSql += N'												, CASE WHEN A.WIPHOLD_YN = ''Y'' THEN ISNULL(A.QTY2,0) ELSE 0 END AS HOLD_QTY                                               ' + char(10)
		SELECT @v_dSql += N'										FROM	SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                  ' + char(10)
		SELECT @v_dSql += N'												INNER JOIN (                                                                                                                ' + char(10)
		SELECT @v_dSql += N'																SELECT  COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID,  RIGHT(FLOW_ID,5) AS LAST_FLOW_ID                        ' + char(10)
		SELECT @v_dSql += N'																FROM 	SCM_ITEM_M A                                                                                        ' + char(10)
		SELECT @v_dSql += N'																WHERE	1=1                                                                                                 ' + char(10)
		SELECT @v_dSql += N'																AND		A.ACTIVE_FLAG = ''Y''                                                                               ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'															) B                                                                                                             ' + char(10)
		SELECT @v_dSql += N'													ON   A.COMPANY_ID  		=  B.COMPANY_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'													AND  A.DIVISION_ID   	=  B.DIVISION_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'													AND  A.SITE_ID       	=  B.SITE_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'													AND  A.FP_APPLY_ITEM_ID	=  B.ITEM_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'										WHERE	1=1                                                                                                                         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'										AND		CONVERT(VARCHAR, A.CUTOFF_DATE, 112) = '''+ @p_plan_date +'''                                                                          ' + char(10)
		SELECT @v_dSql += N'										AND		A.STOCK_TYPE  = ''DW''                                                                                                      ' + char(10)
		-- 하드코딩 전환
		--SELECT @v_dSql += N'										AND		(A.STORAGE_ID >= ''5000'' AND A.STORAGE_ID < ''6000'' )                                                                     ' + char(10)
		SELECT @v_dSql += N'             AND		'+char(10)
		SELECT @v_dSql += N'(A.STORAGE_ID >= (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK'' AND SEGMENT1  = ''1'' AND ACTIVE_FLAG = ''Y'' AND ATTRIBUTE3=''MIN'') ' + char(10)
		SELECT @v_dSql += N'AND A.STORAGE_ID < (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK'' AND SEGMENT1  = ''1'' AND ACTIVE_FLAG = ''Y'' AND ATTRIBUTE3=''MAX'') )' +char(10)
		
		SELECT @v_dSql += N'						  		) A                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FP_APPLY_ITEM_ID                                            ' + char(10)
		--SELECT @v_dSql += N')' + char(10) -- fix remove 20221014
		--SELECT @v_dSql += N'	-- I : builing, location                                                                                                                                                ' + char(10)
		--SELECT @v_dSql += N', MAIN_I AS (' + char(10) -- fix remove 20221014
		SELECT @v_dSql += N'	  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	       , A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME                                                                                           ' + char(10)
		SELECT @v_dSql += N'	       , A.OPERATION_ID                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	       , A.FACTORY_ID, A.LOCATION                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	       , ISNULL(MAX(A.QTY),0) AS BOH_QTY                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS SSP_BOH                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS SSP_HOLD                                                                                                                                               ' + char(10)
		--SELECT @v_dSql += N', NULL AS SSP_BOH_QTY' + char(10) -- fix remove 20221014
		SELECT @v_dSql += N', CONVERT(VARCHAR(4000), NULL) AS SSP_BOH_QTY' + char(10) -- fix add 20221014
		--SELECT @v_dSql += N'	       , NULL AS PRODUCTION_TYPE' + char(10)-- fix remove 20221014
		SELECT @v_dSql += N', CONVERT(VARCHAR(60), NULL) AS PRODUCTION_TYPE' + char(10) -- fix add 20221014
		--SELECT @v_dSql += N'	       , NULL AS MARKET                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N', CONVERT(VARCHAR(60), NULL) AS MARKET' + char(10) -- fix add 20221014
		SELECT @v_dSql += N'	       , ''I'' AS PSI                                                                                                                                                   ' + char(10)
		--SELECT @v_dSql += N'	       , NULL AS LINE_ID                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N', CONVERT(VARCHAR(60), NULL) AS LINE_ID' + char(10) -- fix add 20221014
		--SELECT @v_dSql += N'	       , NULL AS LINE_NAME                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N', CONVERT(VARCHAR(300), NULL) AS LINE_NAME' + char(10) -- fix add 20221014
		--SELECT @v_dSql += N'	       , NULL AS ELECTRODE_TYPE                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N', CONVERT(VARCHAR(100), NULL) AS ELECTRODE_TYPE' + char(10) -- fix add 20221014
		SELECT @v_dSql += N'	       , ''EOH'' AS CATE                                                                                                                                                ' + char(10)
		
		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN		
				-- month info
				SET @mst_loop_cnt = 0;
			
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'			, NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					
					SET @mst_loop_cnt = @mst_loop_cnt + 1 ;
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
					IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 2)   END

					SELECT @v_dSql += N'				, SUM(CASE WHEN A.PLAN_WEEK<=''' + @sub_param_0 + ''' THEN (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' +@p_plan_date+''' THEN A.EOH_QTY ELSE 0 END) ELSE 0 END ) AS W' + TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) + char(10)  				
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- Day bucket
				SET @mst_loop_cnt = 0	
				
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN

					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = ''
					SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_bucket , @v_row_delimiter , @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END
					
					SELECT @v_dSql += N'			, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' THEN A.EOH_QTY ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +  char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		
		SELECT @v_dSql += N'	       , ''I'' AS CATEGORY_ID, 40 AS CATEGORY_ORDER                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	       , ''DATA'' AS DATA_TYPE                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS S_ROW' + char(10)
		SELECT @v_dSql += N'INTO #TEMP_TABLE_MAIN_I' + char(10) -- fix added 20221014
		SELECT @v_dSql += N'	  FROM   (                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	      SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	           , AA.TOP_ITEM_ID, AA.ITEM_ID, AA.ITEM_TYPE, AA.NICK_NAME, AA.PJT_GROUP_NAME                                                                                  ' + char(10)
		SELECT @v_dSql += N'	           , AA.OPERATION_ID                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	           , AA.FACTORY_ID, AA.LOCATION                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	           , AA.PLAN_DATE, E.ISO_YYYYWW AS PLAN_WEEK, E.WEEK_ENDDATE                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	           , D.QTY                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	           , CASE WHEN AA.PLAN_DATE = CONVERT(DATE,'''+ @p_plan_date +''') THEN (D.QTY - SALES_QTY + OUT_QTY) ELSE (0 - SALES_QTY + OUT_QTY) END AS EOH_QTY                        ' + char(10)
		SELECT @v_dSql += N'	      FROM (                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	               , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(C.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME               ' + char(10)
		SELECT @v_dSql += N'	               , A.OPERATION_ID                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	               , A.FACTORY_ID, A.LOCATION                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	               , A.PLAN_DATE                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	               , SUM(A.OUT_QTY)    AS OUT_QTY                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	               , SUM(A.SALES_QTY)  AS SALES_QTY                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	          FROM (                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	              SELECT A.INSTANCE_ID, A.FP_PLAN_ID                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	                   , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	                   , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	                   , A.OPERATION_ID                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	                   , A.FACTORY_ID, A.LOCATION                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	                   , A.PRODUCTION_TYPE, A.MARKET                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	                   , ''I'' AS PSI                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	                   , A.LINE_ID                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	                   , A.ELECTRODE_TYPE                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	                   , A.PLAN_DATE                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	                   , A.OUT_QTY                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	                   , 0 AS SALES_QTY                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	              FROM   '+ @p_amend_table +' A WITH(NOLOCK)      ' + char(10)
		SELECT @v_dSql += N'	              WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                                                                       ' + char(10)
		
		SELECT @v_dSql += N'	              AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	              AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                             ' + char(10)
		SELECT @v_dSql += N'	              AND    ISNULL(A.OUT_QTY,0) > 0                                                                                                                            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		

		SELECT @v_dSql += N'	              UNION ALL                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	              SELECT A.INSTANCE_ID, A.FP_PLAN_ID                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	                   , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	                   , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	                   , A.OPERATION_ID                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	                   , A.FACTORY_ID, A.LOCATION                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	                   , A.PRODUCTION_TYPE, A.MARKET                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	                   , ''I'' AS PSI                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	                   , A.LINE_ID                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	                   , A.ELECTRODE_TYPE                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	                   , A.PLAN_DATE                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	                   , 0 AS OUT_QTY                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	                   , A.SALES_QTY                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	              FROM   '+ @p_amend_sales_table +' A WITH(NOLOCK)                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	              WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	              AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	              AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                             ' + char(10)
		SELECT @v_dSql += N'	              AND    ISNULL(A.SALES_QTY,0) > 0                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	              AND    A.CATEGORY_ID = ''PLAN''                                                                                                                          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'	              -- 0 qty data create start                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	      				UNION ALL                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	      				SELECT DISTINCT A.INSTANCE_ID, A.FP_PLAN_ID                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	      						 , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                       ' + char(10)
		SELECT @v_dSql += N'	      						 , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	      						 , A.OPERATION_ID                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	      						 , A.FACTORY_ID, A.LOCATION                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	      						 , A.PRODUCTION_TYPE, A.MARKET                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	      						 , A.PSI                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	      						 , A.LINE_ID                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	      						 , A.ELECTRODE_TYPE                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	      						 , D.YYYYMMDD                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	      						 , A.OUT_QTY                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	      						 , A.SALES_QTY                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	      				FROM (                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	        					SELECT A.INSTANCE_ID, A.FP_PLAN_ID                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	          						 , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'	          						 , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE                                                                                             ' + char(10)
		SELECT @v_dSql += N'	          						 , A.OPERATION_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	          						 , A.FACTORY_ID, A.LOCATION                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	          						 , A.PRODUCTION_TYPE, A.MARKET                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	          						 , ''I'' AS PSI                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	          						 , A.LINE_ID                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	          						 , A.ELECTRODE_TYPE                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	          						 , A.PLAN_DATE                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'          						 , 0 AS OUT_QTY																					' + char(10)
		SELECT @v_dSql += N'          						 , 0 AS SALES_QTY                                                                               ' + char(10)
		SELECT @v_dSql += N'        					FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                                 ' + char(10)
		SELECT @v_dSql += N'        					WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                 ' + char(10)
		SELECT @v_dSql += N'        					AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                   ' + char(10)
		SELECT @v_dSql += N'        					AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                       ' + char(10)
		SELECT @v_dSql += N'        					AND    (A.OUT_QTY > 0 OR A.'+ @p_result_qty +' > 0 OR A.WPP_OUT_QTY > 0 OR A.MPP_OUT_QTY > 0)              ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'                  UNION ALL                                                                                                     ' + char(10)
		SELECT @v_dSql += N'        					SELECT A.INSTANCE_ID, A.FP_PLAN_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'          						 , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                           ' + char(10)
		SELECT @v_dSql += N'          						 , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE                                                     ' + char(10)
		SELECT @v_dSql += N'          						 , A.OPERATION_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'          						 , A.FACTORY_ID, A.LOCATION                                                                     ' + char(10)
		SELECT @v_dSql += N'          						 , A.PRODUCTION_TYPE, A.MARKET                                                                  ' + char(10)
		SELECT @v_dSql += N'          						 , ''I'' AS PSI                                                                                 ' + char(10)
		SELECT @v_dSql += N'          						 , A.LINE_ID																					' + char(10)
		SELECT @v_dSql += N'	          						 , A.ELECTRODE_TYPE                                                                         ' + char(10)
		SELECT @v_dSql += N'	          						 , A.PLAN_DATE                                                                              ' + char(10)
		SELECT @v_dSql += N'	          						 , 0 AS OUT_QTY                                                                             ' + char(10)
		SELECT @v_dSql += N'	          						 , 0 AS SALES_QTY                                                                           ' + char(10)
		SELECT @v_dSql += N'	        					FROM   '+ @p_amend_sales_table +' A WITH(NOLOCK)                                                       ' + char(10)
		SELECT @v_dSql += N'	        					WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                             ' + char(10)
		SELECT @v_dSql += N'	        					AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                               ' + char(10)
		SELECT @v_dSql += N'	        					AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                   ' + char(10)
		SELECT @v_dSql += N'	        					AND    ISNULL(A.SALES_QTY,0) > 0                                                                ' + char(10)
		SELECT @v_dSql += N'								AND    A.CATEGORY_ID = ''PLAN''                                            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'	      				) A                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	      				INNER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                    ' + char(10)
		SELECT @v_dSql += N'	      				ON     A.COMPANY_ID   = C.COMPANY_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'	      				AND    A.DIVISION_ID  = C.DIVISION_ID                                                                   ' + char(10)
		SELECT @v_dSql += N'	      				AND    A.SITE_ID      = C.SITE_ID                                                                       ' + char(10)
		SELECT @v_dSql += N'	      				AND    A.ITEM_ID      = C.ITEM_ID                                                                       ' + char(10) 	
		SELECT @v_dSql += N'      				AND	   C.ACTIVE_FLAG = ''Y''                                                                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'      				FULL OUTER JOIN TH_UIS_CAL D WITH(NOLOCK)                                                                   ' + char(10)
		SELECT @v_dSql += N'      				ON   0=0                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      				AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                 ' + char(10)
		SELECT @v_dSql += N'      				AND  D.YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                       ' + char(10)
		SELECT @v_dSql += N'          ) A                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'          INNER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                  ' + char(10)
		SELECT @v_dSql += N'          ON     A.COMPANY_ID   = C.COMPANY_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'          AND    A.DIVISION_ID  = C.DIVISION_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'          AND    A.SITE_ID      = C.SITE_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'          AND    A.TOP_ITEM_ID  = C.ITEM_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'          AND	 C.ACTIVE_FLAG = ''Y''                                                                                          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'          WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                                   ' + char(10)
		SELECT @v_dSql += N'          AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                                     ' + char(10)
		SELECT @v_dSql += N'          AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                           ' + char(10)
		SELECT @v_dSql += N'                 , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-''), ISNULL(C.PACK_PRODUCT_GROUP_CODE,''-'')    ' + char(10)
		SELECT @v_dSql += N'                 , A.OPERATION_ID                                                                                               ' + char(10)
		SELECT @v_dSql += N'                 , A.FACTORY_ID, A.LOCATION, A.PLAN_DATE                                                                        ' + char(10)
		SELECT @v_dSql += N'      ) AA                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      LEFT OUTER HASH JOIN (                                                                                                    ' + char(10)
		SELECT @v_dSql += N'          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                               ' + char(10)
		SELECT @v_dSql += N'               , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID                                                           ' + char(10)
		SELECT @v_dSql += N'               , SUM(A.QTY) AS QTY                                                                                              ' + char(10)
		SELECT @v_dSql += N'          FROM (                                                                                                                ' + char(10)
		SELECT @v_dSql += N'              SELECT DISTINCT                                                                                                   ' + char(10)
		SELECT @v_dSql += N'                     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                           ' + char(10)
		SELECT @v_dSql += N'                   , A.OPERATION_ID, A.LOCATION                                                                                 ' + char(10)
		SELECT @v_dSql += N'                   , A.ITEM_ID, A.TOP_ITEM_ID, 0 AS QTY                                                                         ' + char(10)
		SELECT @v_dSql += N'              FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                                               ' + char(10)
		SELECT @v_dSql += N'              WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                               ' + char(10)
		SELECT @v_dSql += N'              AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                                 ' + char(10)
		SELECT @v_dSql += N'              AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                     ' + char(10)
		SELECT @v_dSql += N'              UNION ALL                                                                                                         ' + char(10)
		SELECT @v_dSql += N'              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                           ' + char(10)
		SELECT @v_dSql += N'                   , A.OPERATION_ID, A.LOCATION                                                                                 ' + char(10)
		SELECT @v_dSql += N'                   , A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(A.MODIFY_QTY, A.QTY) AS QTY                                               ' + char(10)
		SELECT @v_dSql += N'              FROM   '+ @p_amend_cutoff_boh_table +' A WITH(NOLOCK)                                                                    ' + char(10)
		SELECT @v_dSql += N'              WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                               ' + char(10)
		SELECT @v_dSql += N'              AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                                 ' + char(10)
		SELECT @v_dSql += N'          ) A                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                             ' + char(10)
		SELECT @v_dSql += N'                 , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID                                                         ' + char(10)
		SELECT @v_dSql += N'      ) D                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      ON     AA.COMPANY_ID   = D.COMPANY_ID																						' + char(10)
		SELECT @v_dSql += N'	      AND    AA.DIVISION_ID  = D.DIVISION_ID                                                                                ' + char(10)  						
		SELECT @v_dSql += N'	      AND    AA.SITE_ID      = D.SITE_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'	      AND    AA.PLANT_ID     = D.PLANT_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'	      AND    AA.FACTORY_ID   = D.FACTORY_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'	      AND    AA.OPERATION_ID = D.OPERATION_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'	      AND    AA.LOCATION     = D.LOCATION                                                                                   ' + char(10)
		SELECT @v_dSql += N'	      AND    AA.ITEM_ID      = D.ITEM_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'	      AND    AA.TOP_ITEM_ID  = D.TOP_ITEM_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'	      INNER HASH JOIN (                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	          SELECT A.DT, B.YYYYMMDD AS WEEK_ENDDATE, A.ISO_YYYYWW                                                             ' + char(10)
		SELECT @v_dSql += N'	          FROM TH_UIS_CAL A WITH(NOLOCK)                                                                                    ' + char(10)
		SELECT @v_dSql += N'	          LEFT OUTER JOIN (                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	              SELECT ISO_YYYYWW, MAX(YYYYMMDD) AS YYYYMMDD                                                                  ' + char(10)
		SELECT @v_dSql += N'	              FROM   TH_UIS_CAL A WITH(NOLOCK)                                                                              ' + char(10)
		SELECT @v_dSql += N'	              WHERE  A.YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                       ' + char(10)
		SELECT @v_dSql += N'	              GROUP BY A.ISO_YYYYWW                                                                                         ' + char(10)
		SELECT @v_dSql += N'	          ) B                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	          ON  A.ISO_YYYYWW = B.ISO_YYYYWW                                                                                   ' + char(10)
		SELECT @v_dSql += N'	          WHERE  A.YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                           ' + char(10)
		SELECT @v_dSql += N'	      ) E                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	      ON     AA.PLAN_DATE    = E.DT                                                                                         ' + char(10)
		SELECT @v_dSql += N'	  ) A                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	  INNER JOIN (                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,                                                               ' + char(10)
		SELECT @v_dSql += N'	             A.ITEM_ID,                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	             (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME         ' + char(10)
		SELECT @v_dSql += N'	             	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                                  ' + char(10)
		SELECT @v_dSql += N'	             	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,                                                                 ' + char(10)
		SELECT @v_dSql += N'	             ISNULL(A.NICK_NAME,''-'') AS NICK_NAME                                                                         ' + char(10)
		SELECT @v_dSql += N'	      FROM	 SCM_ITEM_M A WITH(NOLOCK),                                                                                     ' + char(10)
		SELECT @v_dSql += N'	        		 SCM_ITEM_CLASS_M C WITH(NOLOCK)                                                                            ' + char(10)
		SELECT @v_dSql += N'	      WHERE	 1=1                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	      	AND		A.ACTIVE_FLAG = ''Y''                                                                                       ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	      AND	A.ITEM_CLASS  = C.CLASS_ID                                                                                      ' + char(10)
		SELECT @v_dSql += N'	  ) B                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	  ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                          ' + char(10)
		SELECT @v_dSql += N'	  AND A.DIVISION_ID = B.DIVISION_ID                                                                                         ' + char(10)
		SELECT @v_dSql += N'	  AND A.SITE_ID     = B.SITE_ID                                                                                             ' + char(10)
		SELECT @v_dSql += N'	  AND A.TOP_ITEM_ID = B.ITEM_ID                                                                                             ' + char(10)
		SELECT @v_dSql += N'	  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                               ' + char(10)
		SELECT @v_dSql += N'	         , A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME                                             ' + char(10)
		SELECT @v_dSql += N'	         , A.OPERATION_ID                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	         , A.FACTORY_ID, A.LOCATION																							' + char(10)	
		--SELECT @v_dSql += N'	)' + char(10) -- fix remove 20221014
		--SELECT @v_dSql += N'	, BOH_2ND AS (' + char(10) -- fix remove 20221014
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                   ' + char(10)
		SELECT @v_dSql += N'			, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME                                              ' + char(10)
		SELECT @v_dSql += N'			, A.OPERATION_ID                                                                                                    ' + char(10)
		SELECT @v_dSql += N'			, A.FACTORY_ID, A.LOCATION                                                                                          ' + char(10)
		SELECT @v_dSql += N'			, ISNULL(MAX(D.QTY),0) AS BOH_QTY                                                                                   ' + char(10)
		SELECT @v_dSql += N'			, NULL AS SSP_BOH                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			, NULL AS SSP_HOLD                                                                                                  ' + char(10)
		--SELECT @v_dSql += N'			, NULL AS SSP_BOH_QTY' + char(10) --fix remove 1014
		SELECT @v_dSql += N'			, CONVERT(VARCHAR(4000), NULL) AS SSP_BOH_QTY' + char(10) --fix added 1014
		SELECT @v_dSql += N'			, ''ZZZZZ'' AS PRODUCTION_TYPE, ''ZZZZZ'' AS MARKET                                                                 ' + char(10)
		SELECT @v_dSql += N'			, ''Act.'' AS PSI                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			, A.LINE_ID' + char(10)
		--SELECT @v_dSql += N'			, A.LINE_NAME' + char(10)--fix remove 1014
		SELECT @v_dSql += N'			, CONVERT(VARCHAR(300), NULL) AS LINE_NAME' + char(10) --fix added 1014
		SELECT @v_dSql += N'			, A.ELECTRODE_TYPE' + char(10)
		SELECT @v_dSql += N'			, B.CATEGORY_NAME AS CATE                                                                                           ' + char(10)
	
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

					SELECT @v_dSql += N'      			, SUM(CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''BOH_2ND_EXPECT'' THEN A.EXPECT_QTY	' + char(10)
					SELECT @v_dSql += N'              	 											 WHEN B.CATEGORY_ID=''BOH_2ND_ACTIVATED'' THEN 0	' + char(10)
					SELECT @v_dSql += N'              												 ELSE 0 END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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
					
					SELECT @v_dSql += N'      			, SUM(CASE WHEN C.ISO_YYYYWW=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''BOH_2ND_EXPECT'' THEN A.EXPECT_QTY      ' + char(10)
					SELECT @v_dSql += N'              	 												 WHEN B.CATEGORY_ID=''BOH_2ND_ACTIVATED'' THEN 0   ' + char(10)
					SELECT @v_dSql += N'              													 ELSE 0 END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) + char(10)
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
					
					SELECT @v_dSql += N'      			, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = '''+ @sub_param_0 +''' AND B.CATEGORY_ID=''BOH_2ND_EXPECT'' THEN A.EXPECT_QTY	' + char(10)
					SELECT @v_dSql += N'              	 		   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= '''+ @p_plan_date +''' AND B.CATEGORY_ID=''BOH_2ND_ACTIVATED'' THEN A.EXPECT_QTY - A.OUT_QTY	' + char(10)
					SELECT @v_dSql += N'              																		ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +  char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'			, B.CATEGORY_ID, B.CATEGORY_ORDER                                                   ' + char(10)
		SELECT @v_dSql += N'			, ''DATA'' AS DATA_TYPE                                                             ' + char(10)
		SELECT @v_dSql += N'			, NULL AS S_ROW                                                                     ' + char(10)
		SELECT @v_dSql += N'INTO #TEMP_TABLE_BOH_2ND' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	FROM (                                                                                      ' + char(10)
		SELECT @v_dSql += N'		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                 ' + char(10)
		SELECT @v_dSql += N'	      	 , AA.FIN_OPERATION_ID AS OPERATION_ID                                              ' + char(10)
		SELECT @v_dSql += N'	      	 , A.LINE_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'	      	 , AA.TOP_ITEM_ID																	' + char(10)																													
		SELECT @v_dSql += N'	      	 , AA.TOP_ITEM_ID AS ITEM_ID -- 완성공정 품번으로 변경										' + char(10)																										
		SELECT @v_dSql += N'	      	 , ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(C.PJT_GROUP_NAME,''-'') AS PJT_GROUP_NAME, ISNULL(B.LINE_NAME,''-'') AS LINE_NAME, B.LOCATION, B.ELECTRODE_TYPE, C.ITEM_TYPE				' + char(10)			
		SELECT @v_dSql += N'	      	 , (CASE WHEN CONVERT(VARCHAR, A.SECOND_OCV_EXP_DATE, 112) < '''+ @p_plan_date +''' THEN '''+ @p_plan_date +''' ELSE CONVERT(VARCHAR, A.SECOND_OCV_EXP_DATE, 112) END) AS PLAN_DATE -- 계획 이전 재고는 계획 당일 재고로 본다.	' + char(10)	
		SELECT @v_dSql += N'	      	 , ISNULL(A.FP_APPLY_WIPQTY,0) AS EXPECT_QTY																																				' + char(10)
		SELECT @v_dSql += N'	      	 , 0 AS OUT_QTY		' + char(10)
		SELECT @v_dSql += N'		FROM   SCM_STOCK_H_V A WITH(NOLOCK)																																								' + char(10)	
		SELECT @v_dSql += N'		INNER HASH JOIN (																																												' + char(10)				
		SELECT @v_dSql += N'	      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID, A.ITEM_ID, B.OPERATION_ID AS FIN_OPERATION_ID -- 최종 공정을 뽑기위한 과정	' + char(10)		
		SELECT @v_dSql += N'	      FROM   '+ @p_amend_table +' A WITH(NOLOCK), (																												' + char(10)															
		SELECT @v_dSql += N'								SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID      ' + char(10)
		SELECT @v_dSql += N'								FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                                                             ' + char(10)
		SELECT @v_dSql += N'								WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                            ' + char(10)
		SELECT @v_dSql += N'								AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                                                ' + char(10)
		SELECT @v_dSql += N'								AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'	              AND    A.OPERATION_ID IN (''P5500'',''P9500'',''PL500'')                                                                                                ' + char(10) --2026.08.10 kimcd [ES20260810] PL450 > PL500 공정 코드 변경.2026/06/08 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. Link 공정 추가
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'	              AND    (A.OUT_QTY > 0 OR A.MPP_OUT_QTY > 0 OR A.WPP_OUT_QTY > 0 OR A.RESULT_OUT_QTY > 0)  ' + char(10)
		SELECT @v_dSql += N'	      ) B                                                                                               ' + char(10)
		SELECT @v_dSql += N'	      WHERE  1=1                                                                                        ' + char(10)
		SELECT @v_dSql += N'				AND    A.COMPANY_ID  = B.COMPANY_ID                                                         ' + char(10)
		SELECT @v_dSql += N'				AND    A.DIVISION_ID = B.DIVISION_ID                                                        ' + char(10)
		SELECT @v_dSql += N'				AND    A.SITE_ID     = B.SITE_ID                                                            ' + char(10)
		SELECT @v_dSql += N'				AND    A.PLANT_ID    = B.PLANT_ID                                                           ' + char(10)
		SELECT @v_dSql += N'				AND    A.FACTORY_ID  = B.FACTORY_ID                                                         ' + char(10)
		SELECT @v_dSql += N'				AND    A.LINE_ID     = B.LINE_ID                                                            ' + char(10)
		SELECT @v_dSql += N'				AND    A.TOP_ITEM_ID = B.TOP_ITEM_ID                                                        ' + char(10)
		SELECT @v_dSql += N'	      AND    A.INSTANCE_ID = '''+ @p_master_id +'''                                                                ' + char(10)
		SELECT @v_dSql += N'	      AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                  ' + char(10)
		SELECT @v_dSql += N'	      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'	      AND    A.OPERATION_ID = ''P5200''                                                                 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'	      AND    (A.OUT_QTY > 0 OR A.'+ @p_result_qty +' > 0 OR A.WPP_OUT_QTY > 0 OR A.MPP_OUT_QTY > 0)                                    ' + char(10)
		SELECT @v_dSql += N'		) AA                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		ON  A.COMPANY_ID            = AA.COMPANY_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'		AND A.DIVISION_ID           = AA.DIVISION_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'		AND A.SITE_ID               = AA.SITE_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'		AND A.PLANT_ID              = AA.PLANT_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'		AND A.FACTORY_ID            = AA.FACTORY_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'		AND A.FP_APPLY_OPERATION_ID = AA.OPERATION_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'		AND A.LINE_ID               = AA.LINE_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'		AND A.FP_APPLY_ITEM_ID      = AA.ITEM_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'		LEFT OUTER HASH JOIN SCM_LINE_M B WITH(NOLOCK)                                                                              ' + char(10)
		SELECT @v_dSql += N'		ON  A.COMPANY_ID            = B.COMPANY_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'		AND A.DIVISION_ID           = B.DIVISION_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'		AND A.SITE_ID               = B.SITE_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'		AND A.PLANT_ID              = B.PLANT_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'		AND A.FACTORY_ID            = B.FACTORY_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'		AND AA.FIN_OPERATION_ID     = B.OPERATION_ID -- 최종공정 기준으로 line name 검색                                            ' + char(10)
		SELECT @v_dSql += N'		AND A.LINE_ID               = B.LINE_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'		INNER JOIN (                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	      		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID                                                   ' + char(10)
		SELECT @v_dSql += N'	      				, (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME    ' + char(10)
		SELECT @v_dSql += N'	      						    WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                           ' + char(10)
		SELECT @v_dSql += N'	      						    ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE                                                           ' + char(10)
		SELECT @v_dSql += N'	      				, ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME         ' + char(10)
		SELECT @v_dSql += N'	      		FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK)                                                   ' + char(10)
		SELECT @v_dSql += N'	      		WHERE  A.ITEM_CLASS  = C.CLASS_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'	      		AND    A.ACTIVE_FLAG = ''Y''                                                                                        ' + char(10)
		SELECT @v_dSql += N'	      		AND    C.USE_FLAG = ''Y''                                                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'		) C                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		ON    AA.COMPANY_ID  = C.COMPANY_ID                                                                                         ' + char(10)
		SELECT @v_dSql += N'		AND   AA.DIVISION_ID = C.DIVISION_ID                                                                                        ' + char(10)
		SELECT @v_dSql += N'		AND   AA.SITE_ID     = C.SITE_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'		AND   AA.TOP_ITEM_ID = C.ITEM_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'		WHERE CONVERT(CHAR(8), A.CUTOFF_DATE, 112) = '''+ @p_plan_date +'''                                                                    ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'		AND   A.STOCK_TYPE = ''WIP''                                ' + char(10)
		SELECT @v_dSql += N'		AND   A.FP_APPLY_OPERATION_ID = ''P5200''                   ' + char(10)
		SELECT @v_dSql += N'		AND   A.SECOND_OCV_EXP_DATE IS NOT NULL                     ' + char(10)
		SELECT @v_dSql += N'	    UNION ALL                                                                                                   ' + char(10)
		SELECT @v_dSql += N'		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, B.OPERATION_ID AS FIN_OPERATION_ID      ' + char(10)
		SELECT @v_dSql += N'				, A.LINE_ID, A.TOP_ITEM_ID, A.TOP_ITEM_ID AS ITEM_ID -- 완성공정 품번으로 변경                  ' + char(10)
		SELECT @v_dSql += N'				, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(C.PJT_GROUP_NAME,''-'') AS PJT_GROUP_NAME, ISNULL(D.LINE_NAME,''-'') AS LINE_NAME, A.LOCATION, A.ELECTRODE_TYPE, C.ITEM_TYPE   ' + char(10)
		SELECT @v_dSql += N'				, DATEADD(DAY, ISNULL(E.KEEP_DAYS, 0), A.PLAN_DATE) AS PLAN_DATE   ' + char(10)
		SELECT @v_dSql += N'				, A.OUT_QTY AS EXPECT_QTY, 0 AS OUT_QTY   ' + char(10)
		SELECT @v_dSql += N'		FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                         ' + char(10)
		SELECT @v_dSql += N'				INNER JOIN	(                                                                                 ' + char(10)		
		SELECT @v_dSql += N'									SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID  ' + char(10)
		SELECT @v_dSql += N'									FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                             ' + char(10)
		SELECT @v_dSql += N'									WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                            ' + char(10)
		SELECT @v_dSql += N'									AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                ' + char(10)
		SELECT @v_dSql += N'									AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'															      	              AND    A.OPERATION_ID IN (''P5500'',''P9500'',''PL500'')                                ' + char(10) --2026.08.10 kimcd [ES20260810] PL450 > PL500 공정 코드 변경.2026/06/08 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. Link 공정 추가
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'		      	              AND    (A.OUT_QTY > 0 OR A.MPP_OUT_QTY > 0 OR A.WPP_OUT_QTY > 0 OR A.RESULT_OUT_QTY > 0)             ' + char(10)
		SELECT @v_dSql += N'	    				) B                                                                                 ' + char(10)
		SELECT @v_dSql += N'				ON     1=1						                                                            ' + char(10)
		SELECT @v_dSql += N'				AND    A.COMPANY_ID  = B.COMPANY_ID                                                         ' + char(10)
		SELECT @v_dSql += N'				AND    A.DIVISION_ID = B.DIVISION_ID                                                        ' + char(10)
		SELECT @v_dSql += N'				AND    A.SITE_ID     = B.SITE_ID                                                            ' + char(10)
		SELECT @v_dSql += N'				AND    A.PLANT_ID    = B.PLANT_ID                                                           ' + char(10)
		SELECT @v_dSql += N'				AND    A.FACTORY_ID  = B.FACTORY_ID                                                         ' + char(10)
		SELECT @v_dSql += N'				AND    A.LINE_ID     = B.LINE_ID                                                            ' + char(10)
		SELECT @v_dSql += N'				AND    A.TOP_ITEM_ID = B.TOP_ITEM_ID                                                        ' + char(10)
		SELECT @v_dSql += N'		INNER JOIN (                                                                                        ' + char(10)
		SELECT @v_dSql += N'						SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID                   ' + char(10)
		SELECT @v_dSql += N'							 , (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME                   ' + char(10)
		SELECT @v_dSql += N'									 WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')  ' + char(10)
		SELECT @v_dSql += N'									 ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE                                  ' + char(10)
		SELECT @v_dSql += N'							 , ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME   ' + char(10)
		SELECT @v_dSql += N'						FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK)                   ' + char(10)
		SELECT @v_dSql += N'						WHERE  A.ITEM_CLASS  = C.CLASS_ID                                                   ' + char(10)
		SELECT @v_dSql += N'						AND    A.ACTIVE_FLAG = ''Y''                                                        ' + char(10)
		SELECT @v_dSql += N'						AND    C.USE_FLAG = ''Y''                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'			) C                                                                                                 ' + char(10)
		SELECT @v_dSql += N'			ON    A.COMPANY_ID  = C.COMPANY_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'			AND   A.DIVISION_ID = C.DIVISION_ID                                                                ' + char(10)
		SELECT @v_dSql += N'			AND   A.SITE_ID     = C.SITE_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'			AND   A.TOP_ITEM_ID = C.ITEM_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER HASH JOIN SCM_LINE_M D WITH(NOLOCK)                                                      ' + char(10)
		SELECT @v_dSql += N'			ON  A.COMPANY_ID            = D.COMPANY_ID                                                          ' + char(10)
		SELECT @v_dSql += N'			AND A.DIVISION_ID           = D.DIVISION_ID                                                         ' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID               = D.SITE_ID                                                             ' + char(10)
		SELECT @v_dSql += N'			AND A.PLANT_ID              = D.PLANT_ID                                                            ' + char(10)
		SELECT @v_dSql += N'			AND A.FACTORY_ID            = D.FACTORY_ID                                                          ' + char(10)
		SELECT @v_dSql += N'			AND B.OPERATION_ID			= D.OPERATION_ID -- 최종공정 기준으로 line name 검색                    ' + char(10)
		SELECT @v_dSql += N'			AND A.LINE_ID               = D.LINE_ID                                                             ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN (                                                       ' + char(10)
		SELECT @v_dSql += N'								SELECT A.ITEM_ID, MAX(A.KEEP_DAYS) AS KEEP_DAYS     ' + char(10)
		SELECT @v_dSql += N'								FROM   SCM_MMD_SECOND_OCV_SPEC_M A WITH(NOLOCK)     ' + char(10)
		SELECT @v_dSql += N'								WHERE  1=1     ' + char(10)
		SELECT @v_dSql += N'								AND    A.RUN_TIME = 1     ' + char(10)
		SELECT @v_dSql += N'								AND    A.OPERATION_ID = ''P5400''     ' + char(10)
		SELECT @v_dSql += N'								GROUP BY A.ITEM_ID     ' + char(10)
		SELECT @v_dSql += N'							 ) E    ' + char(10)
		SELECT @v_dSql += N'			ON  A.ITEM_ID            = E.ITEM_ID                                                          ' + char(10)
		SELECT @v_dSql += N'		WHERE  1=1                                                                                  ' + char(10)
		SELECT @v_dSql += N'		AND    A.INSTANCE_ID = '''+ @p_instance_id +'''                                             ' + char(10)
		SELECT @v_dSql += N'		AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                 ' + char(10)
		SELECT @v_dSql += N'		AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'														AND    A.OPERATION_ID = ''P5200''                                                         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'														AND    (A.OUT_QTY > 0 OR A.MPP_OUT_QTY > 0 OR A.WPP_OUT_QTY > 0 OR A.RESULT_OUT_QTY > 0)  ' + char(10)
		SELECT @v_dSql += N'		UNION ALL                                                   ' + char(10)
		SELECT @v_dSql += N'	  -- P5200 계획 기준으로 boh 2nd, activated 카테고리 정보 강제생성			' + char(10) 
		SELECT @v_dSql += N'	  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, C.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID, A.ITEM_ID													' + char(10) 
		SELECT @v_dSql += N'	       , ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(C.PJT_GROUP_NAME,''-'') AS PJT_GROUP_NAME, ISNULL(B.LINE_NAME,''-'') AS LINE_NAME, B.LOCATION, B.ELECTRODE_TYPE, C.ITEM_TYPE	' + char(10) 
		SELECT @v_dSql += N'	       , A.PLAN_DATE AS PLAN_DATE, 0 AS EXPECT_QTY													' + char(10) 
		SELECT @v_dSql += N'	       , CASE WHEN '''+ @p_plan_date +''' <= A.PLAN_DATE THEN A.OUT_QTY ELSE 0 END OUT_QTY													' + char(10) 
		SELECT @v_dSql += N'	  FROM (																																												' + char(10) 
		SELECT @v_dSql += N'	  		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.TOP_ITEM_ID, A.TOP_ITEM_ID AS ITEM_ID, '''+ @p_plan_date +''' AS PLAN_DATE, 0 AS OUT_QTY	' + char(10)
		SELECT @v_dSql += N'	  		FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	  		WHERE  1=1                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	  		AND    A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	  		AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	  		AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                                                 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'	  		AND    A.OPERATION_ID = ''P5200'' -- P5200 고정                                                                             ' + char (10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'	  		AND    (A.OUT_QTY > 0 OR A.MPP_OUT_QTY > 0 OR A.WPP_OUT_QTY > 0 OR A.RESULT_OUT_QTY > 0)                                    ' + char (10)
		SELECT @v_dSql += N'	  ) A                                                                                                                               ' + char (10)
		SELECT @v_dSql += N'	  INNER JOIN (                                                                                                                      ' + char (10)
		SELECT @v_dSql += N'	          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID                                                         ' + char (10)
		SELECT @v_dSql += N'	            	, (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME            ' + char (10)
		SELECT @v_dSql += N'	            	 		 WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                                      ' + char (10)
		SELECT @v_dSql += N'	            	 		 ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE                                                                      ' + char (10)
		SELECT @v_dSql += N'	              , ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME                   ' + char (10)
		SELECT @v_dSql += N'	              , SUBSTRING(A.FLOW_ID,1,5) AS OPERATION_ID                                                                            ' + char (10)
		SELECT @v_dSql += N'	          FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK)                                                         ' + char (10)
		SELECT @v_dSql += N'	          WHERE  A.ITEM_CLASS  = C.CLASS_ID                                                                                         ' + char (10)
		SELECT @v_dSql += N'	          AND    A.ACTIVE_FLAG = ''Y''                                                                                              ' + char (10)
		SELECT @v_dSql += N'	          AND    C.USE_FLAG = ''Y''                                                                                                 ' + char (10)
		SELECT @v_dSql += N'	          AND    A.FLOW_ID IS NOT NULL                                                                                              ' + char (10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'	  ) C                                                                                                                               ' + char (10)
		SELECT @v_dSql += N'	  ON  A.COMPANY_ID    = C.COMPANY_ID                                                                                                ' + char (10)
		SELECT @v_dSql += N'	  AND A.DIVISION_ID   = C.DIVISION_ID                                                                                               ' + char (10)
		SELECT @v_dSql += N'	  AND A.SITE_ID       = C.SITE_ID                                                                                                   ' + char(10)	
		SELECT @v_dSql += N'	  AND A.TOP_ITEM_ID   = C.ITEM_ID                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	  LEFT OUTER HASH JOIN SCM_LINE_M B WITH(NOLOCK)                                                                                    ' + char(10)
		SELECT @v_dSql += N'	  ON  A.COMPANY_ID    = B.COMPANY_ID                                                                                                ' + char(10)
		SELECT @v_dSql += N'	  AND A.DIVISION_ID   = B.DIVISION_ID                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  AND A.SITE_ID       = B.SITE_ID                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	  AND A.PLANT_ID      = B.PLANT_ID                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	  AND A.FACTORY_ID    = B.FACTORY_ID                                                                                                ' + char(10)
		SELECT @v_dSql += N'	  AND C.OPERATION_ID  = B.OPERATION_ID -- 최종공정 기준으로 line name 검색                                                          ' + char(10)
		SELECT @v_dSql += N'	  AND A.LINE_ID       = B.LINE_ID                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	) A                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	INNER JOIN (                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'			SELECT *                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'			FROM (                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	        	SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER                                                 ' + char(10)
		SELECT @v_dSql += N'	        	UNION ALL                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	        	SELECT ''BOH_2ND_EXPECT'' AS CATEGORY_ID, N''EXP_2nd OCV Complete'' AS CATEGORY_NAME, 97 AS CATEGORY_ORDER              ' + char(10)
		SELECT @v_dSql += N'	        	UNION ALL                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	        	SELECT ''BOH_2ND_ACTIVATED'' AS CATEGORY_ID, N''Activated'' AS CATEGORY_NAME, 99 AS CATEGORY_ORDER                      ' + char(10)
		SELECT @v_dSql += N'			) BB                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'			WHERE CATEGORY_ID <> ''X''                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	) B                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	ON 1=1                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	INNER JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                                                ' + char(10)
		SELECT @v_dSql += N'	ON A.PLAN_DATE = C.YYYYMMDD                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	LEFT OUTER HASH JOIN (                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                         ' + char(10)
		SELECT @v_dSql += N'			 , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'			 , SUM(A.QTY) AS QTY                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		FROM (                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'			SELECT DISTINCT                                                                                                             ' + char(10)
		SELECT @v_dSql += N'				   A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                     ' + char(10)
		SELECT @v_dSql += N'				 , A.OPERATION_ID, A.LOCATION                                                                                           ' + char(10)
		SELECT @v_dSql += N'				 , A.ITEM_ID, A.TOP_ITEM_ID, 0 AS QTY                                                                                   ' + char(10)
		SELECT @v_dSql += N'			FROM   FP_AMEND_PLAN_PACK_R A WITH(NOLOCK)                                                                                  ' + char(10)
		SELECT @v_dSql += N'			WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                                         ' + char(10)
		SELECT @v_dSql += N'			AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                                           ' + char(10)
		SELECT @v_dSql += N'			AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                               ' + char(10)
		SELECT @v_dSql += N'			UNION ALL                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                     ' + char(10)
		SELECT @v_dSql += N'				 , A.OPERATION_ID, A.LOCATION                                                                                           ' + char(10)
		SELECT @v_dSql += N'				 , A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(A.MODIFY_QTY, A.QTY) AS QTY                                                         ' + char(10)
		SELECT @v_dSql += N'			FROM   FP_AMEND_CUTOFF_BOH_R A WITH(NOLOCK)                                                                                 ' + char(10)
		SELECT @v_dSql += N'			WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                                         ' + char(10)
		SELECT @v_dSql += N'			AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                                           ' + char(10)
		SELECT @v_dSql += N'		) A                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                       ' + char(10)
		SELECT @v_dSql += N'				   , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID                                                               ' + char(10)
		SELECT @v_dSql += N'	) D                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	ON  A.COMPANY_ID   = D.COMPANY_ID                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	AND A.DIVISION_ID  = D.DIVISION_ID                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	AND A.SITE_ID      = D.SITE_ID                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	AND A.PLANT_ID     = D.PLANT_ID																			' + char(10)				
		SELECT @v_dSql += N'	AND A.FACTORY_ID   = D.FACTORY_ID                                                                       ' + char(10)
		SELECT @v_dSql += N'	AND A.OPERATION_ID = D.OPERATION_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'	AND A.LOCATION     = D.LOCATION                                                                         ' + char(10)
		SELECT @v_dSql += N'	AND A.ITEM_ID      = D.ITEM_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'	AND A.TOP_ITEM_ID  = D.TOP_ITEM_ID                                                                      ' + char(10)
		SELECT @v_dSql += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                             ' + char(10)
		SELECT @v_dSql += N'		     , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME                         ' + char(10)
		SELECT @v_dSql += N'		     , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE           ' + char(10)
		SELECT @v_dSql += N'		     , B.CATEGORY_NAME, B.CATEGORY_ID, B.CATEGORY_ORDER                                             ' + char(10)
		--SELECT @v_dSql += N'	) ' + char(10) -- fix remove 20221014
		--SELECT @v_dSql += N'	, MAIN_S AS (     ' + char(10)-- fix remove 20221014
		SELECT @v_dSql += N'	  -- S : builing, location, production type, market                                                     ' + char(10)
		SELECT @v_dSql += N'	  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                             ' + char(10)
		SELECT @v_dSql += N'	       , A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME                           ' + char(10)
		SELECT @v_dSql += N'	       , A.OPERATION_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'	       , A.FACTORY_ID, A.LOCATION                                                                       ' + char(10)
		SELECT @v_dSql += N'	       , ISNULL(A.BOH_QTY,0) AS BOH_QTY                                                                 ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS SSP_BOH                                                                                ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS SSP_HOLD                                                                               ' + char(10)
		--SELECT @v_dSql += N'	       , NULL AS SSP_BOH_QTY' + char(10) -- fix remove 1014
		SELECT @v_dSql += N'	       , CONVERT(VARCHAR(4000), NULL) AS SSP_BOH_QTY' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	       , A.PRODUCTION_TYPE, A.MARKET                                                                    ' + char(10)
		SELECT @v_dSql += N'	       , A.PSI                                                                                          ' + char(10)
		--SELECT @v_dSql += N'	       , A.LINE_ID' + char(10)-- fix remove 1014
		SELECT @v_dSql += N'	       , CONVERT(VARCHAR(60), A.LINE_ID) AS LINE_ID' + char(10) -- fix added 1014
		--SELECT @v_dSql += N'	       , NULL AS LINE_NAME' + char(10)-- fix remove 1014
		SELECT @v_dSql += N'	       , CONVERT(VARCHAR(300), NULL) AS LINE_NAME' + char(10) -- fix added 1014
		--SELECT @v_dSql += N'	       , A.ELECTRODE_TYPE' + char(10)-- fix remove 1014
		SELECT @v_dSql += N'	       , CONVERT(VARCHAR(100), A.ELECTRODE_TYPE) AS ELECTRODE_TYPE' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	       , A.CATE                                                                                         ' + char(10)
		
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

					SELECT @v_dSql += N'      			, A.M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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
				
					SELECT @v_dSql += N'      			, A.W' + TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) + char(10)
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
					
					SELECT @v_dSql += N'      			, A.D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +  char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	       , A.CATEGORY_ID, A.CATEGORY_ORDER                                                                ' + char(10)
		SELECT @v_dSql += N'	       , A.DATA_TYPE                                                                                    ' + char(10)
		SELECT @v_dSql += N'	       , A.S_ROW                                                                                        ' + char(10)
		SELECT @v_dSql += N'INTO #TEMP_TABLE_MAIN_S' + char(10) -- fix added
		SELECT @v_dSql += N'	  FROM (                                                                                                ' + char(10)
		SELECT @v_dSql += N'	              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                 ' + char(10)
		SELECT @v_dSql += N'	                   , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(C.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME	' + char(10)
		SELECT @v_dSql += N'	                   , A.OPERATION_ID			' + char(10)
		SELECT @v_dSql += N'	                   , A.FACTORY_ID, A.LOCATION						           	' + char(10)
		SELECT @v_dSql += N'	                   , D.QTY AS BOH_QTY                                           ' + char(10)
		SELECT @v_dSql += N'	                   , A.PRODUCTION_TYPE, A.MARKET                                ' + char(10)
		SELECT @v_dSql += N'	                   , ''S'' AS PSI                                               ' + char(10)
		SELECT @v_dSql += N'	                   , NULL AS LINE_ID                                            ' + char(10)
		SELECT @v_dSql += N'	                   , NULL AS ELECTRODE_TYPE                                     ' + char(10)
		SELECT @v_dSql += N'	                   , B.CATEGORY_NAME AS CATE                                    ' + char(10)

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

					SELECT @v_dSql += N'	            , SUM(CASE WHEN E.YYYYMM = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''SALES'' THEN A.SALES_QTY ELSE A.PAST_SALES_QTY END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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
					
					SELECT @v_dSql += N'	            , SUM(CASE WHEN E.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''SALES'' THEN A.SALES_QTY ELSE A.PAST_SALES_QTY END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) + char(10)
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
					
					SELECT @v_dSql += N'	            , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = '''+ @sub_param_0 +''' THEN (CASE WHEN B.CATEGORY_ID=''SALES'' THEN A.SALES_QTY ELSE A.PAST_SALES_QTY END) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +  char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	                   , B.CATEGORY_ID, B.CATEGORY_ORDER                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	                   , ''DATA'' AS DATA_TYPE                                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	                   , ROW_NUMBER() OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION                                                                         ' + char(10)
		SELECT @v_dSql += N'	                                        ORDER BY     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, B.CATEGORY_ORDER) AS S_ROW                ' + char(10)
		SELECT @v_dSql += N'	              FROM   (																								' + char(10)
		SELECT @v_dSql += N'				                  SELECT A.INSTANCE_ID, A.FP_PLAN_ID                                                    ' + char(10)
		SELECT @v_dSql += N'				                       , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                             ' + char(10)
		SELECT @v_dSql += N'				                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE                                       ' + char(10)
		SELECT @v_dSql += N'				                       , A.OPERATION_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'				                       , A.FACTORY_ID, A.LOCATION                                                       ' + char(10)
		SELECT @v_dSql += N'				                       , A.PRODUCTION_TYPE, A.MARKET                                                    ' + char(10)
		SELECT @v_dSql += N'				                       , ''S'' AS PSI                                                                   ' + char(10)
		SELECT @v_dSql += N'				                       , A.LINE_ID                                                                      ' + char(10)
		SELECT @v_dSql += N'				                       , A.ELECTRODE_TYPE                                                               ' + char(10)
		SELECT @v_dSql += N'				                       , A.PLAN_DATE                                                                    ' + char(10)
		SELECT @v_dSql += N'				                       , A.SALES_QTY                                                                    ' + char(10)
		SELECT @v_dSql += N'				                       , A.PAST_SALES_QTY                                                               ' + char(10)
		SELECT @v_dSql += N'				                  FROM   '+ @p_amend_sales_table +' A WITH(NOLOCK)                                             ' + char(10)
		SELECT @v_dSql += N'				                  WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                   ' + char(10)
		SELECT @v_dSql += N'				                  AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                     ' + char(10)
		SELECT @v_dSql += N'				                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''         ' + char(10)
		SELECT @v_dSql += N'								  AND    A.CATEGORY_ID = ''PLAN''                                            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'			                  AND   ( ISNULL(A.SALES_QTY,0) > 0 OR ISNULL(A.PAST_SALES_QTY,0) > 0)                      ' + char(10)
		SELECT @v_dSql += N'			                  UNION ALL                                                                                 ' + char(10)
		SELECT @v_dSql += N'			                  SELECT A.INSTANCE_ID, A.FP_PLAN_ID                                                        ' + char(10)
		SELECT @v_dSql += N'			                       , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                 ' + char(10)
		SELECT @v_dSql += N'			                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE                                           ' + char(10)
		SELECT @v_dSql += N'			                       , A.OPERATION_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'			                       , A.FACTORY_ID, A.LOCATION                                                           ' + char(10)
		SELECT @v_dSql += N'			                       , A.PRODUCTION_TYPE, A.MARKET                                                        ' + char(10)
		SELECT @v_dSql += N'			                       , ''S'' AS PSI                                                                       ' + char(10)
		SELECT @v_dSql += N'			                       , A.LINE_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'			                       , A.ELECTRODE_TYPE                                                                   ' + char(10)
		SELECT @v_dSql += N'			                       , A.PLAN_DATE                                                                        ' + char(10)
		SELECT @v_dSql += N'			                       , 0 AS SALES_QTY                                                                     ' + char(10)
		SELECT @v_dSql += N'			                       , 0 AS PAST_SALES_QTY                                                                ' + char(10)
		SELECT @v_dSql += N'			                  FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                       ' + char(10)
		SELECT @v_dSql += N'			                  WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                       ' + char(10)
		SELECT @v_dSql += N'			                  AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                         ' + char(10)
		SELECT @v_dSql += N'			                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''             ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'			                  AND    (A.OUT_QTY > 0 OR A.'+ @p_result_qty +' > 0 OR A.WPP_OUT_QTY > 0 OR A.MPP_OUT_QTY > 0)    ' + char(10)
		SELECT @v_dSql += N'              ) A                                                                                                       ' + char(10)
		SELECT @v_dSql += N'              INNER JOIN (                                                                                              ' + char(10)
		SELECT @v_dSql += N'      						SELECT ''SALES'' AS CATEGORY_ID, ''S'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER               ' + char(10)
		SELECT @v_dSql += N'      						UNION ALL                                                                                   ' + char(10)
		SELECT @v_dSql += N'      						SELECT ''PAST_SALES'' AS CATEGORY_ID, ''S(W-1)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER     ' + char(10)
		SELECT @v_dSql += N'            ) B                                                                                                         ' + char(10)
		SELECT @v_dSql += N'            ON 1=1                                                                                                      ' + char(10)
		SELECT @v_dSql += N'              INNER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                      ' + char(10)
		SELECT @v_dSql += N'              ON     A.COMPANY_ID   = C.COMPANY_ID                                                                      ' + char(10)
		SELECT @v_dSql += N'              AND    A.DIVISION_ID  = C.DIVISION_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'              AND    A.SITE_ID      = C.SITE_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'              AND    A.TOP_ITEM_ID  = C.ITEM_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'              AND		C.ACTIVE_FLAG = ''Y''                                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'              LEFT OUTER JOIN (                                                                     ' + char(10)
		SELECT @v_dSql += N'                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID           ' + char(10)
		SELECT @v_dSql += N'                       , A.OPERATION_ID, A.LOCATION                                                 ' + char(10)
		SELECT @v_dSql += N'                       , A.ITEM_ID, A.TOP_ITEM_ID, SUM(ISNULL(A.MODIFY_QTY, A.QTY)) AS QTY          ' + char(10)
		SELECT @v_dSql += N'                  FROM   '+ @p_amend_cutoff_boh_table +' A WITH(NOLOCK)                                    ' + char(10)
		SELECT @v_dSql += N'                  WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                               ' + char(10)
		SELECT @v_dSql += N'                  AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                 ' + char(10)
		SELECT @v_dSql += N'                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID         ' + char(10)
		SELECT @v_dSql += N'                         , A.OPERATION_ID, A.LOCATION                                               ' + char(10)
		SELECT @v_dSql += N'                         , A.ITEM_ID, A.TOP_ITEM_ID                                                 ' + char(10)
		SELECT @v_dSql += N'              ) D                                                                                   ' + char(10)
		SELECT @v_dSql += N'              ON     A.COMPANY_ID   = D.COMPANY_ID                                                  ' + char(10)
		SELECT @v_dSql += N'              AND    A.DIVISION_ID  = D.DIVISION_ID                                                 ' + char(10)
		SELECT @v_dSql += N'              AND    A.SITE_ID      = D.SITE_ID                                                     ' + char(10)
		SELECT @v_dSql += N'              AND    A.PLANT_ID     = D.PLANT_ID                                                    ' + char(10)
		SELECT @v_dSql += N'              AND    A.FACTORY_ID   = D.FACTORY_ID                                                  ' + char(10)
		SELECT @v_dSql += N'              AND    A.OPERATION_ID = D.OPERATION_ID                                                ' + char(10)
		SELECT @v_dSql += N'              AND    A.LOCATION     = D.LOCATION                                                    ' + char(10)
		SELECT @v_dSql += N'              AND    A.ITEM_ID      = D.ITEM_ID                                                     ' + char(10)
		SELECT @v_dSql += N'              AND    A.TOP_ITEM_ID  = D.TOP_ITEM_ID                                                 ' + char(10)
		SELECT @v_dSql += N'              INNER HASH JOIN TH_UIS_CAL E WITH(NOLOCK)                                             ' + char(10)
		SELECT @v_dSql += N'              	ON     A.PLAN_DATE    = E.DT                                                        ' + char(10)
		SELECT @v_dSql += N'              WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                   ' + char(10)
		SELECT @v_dSql += N'              AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                     ' + char(10)
		SELECT @v_dSql += N'              AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'	              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                           ' + char(10)
		SELECT @v_dSql += N'	                     , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-''), ISNULL(C.PACK_PRODUCT_GROUP_CODE,''-'')    ' + char(10)
		SELECT @v_dSql += N'	                     , A.OPERATION_ID                                                                                               ' + char(10)
		SELECT @v_dSql += N'	                     , A.FACTORY_ID, A.LOCATION                                                                                     ' + char(10)
		SELECT @v_dSql += N'	                     , A.PRODUCTION_TYPE, A.MARKET                                                                                  ' + char(10)
		SELECT @v_dSql += N'	                     , D.QTY                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	                     , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER                                                             ' + char(10)
		SELECT @v_dSql += N'	  ) A                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  INNER JOIN (                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,                                                                       ' + char(10)
		SELECT @v_dSql += N'	             A.ITEM_ID,                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	             (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME                 ' + char(10)
		SELECT @v_dSql += N'	             	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                                          ' + char(10)
		SELECT @v_dSql += N'	             	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,                                                                         ' + char(10)
		SELECT @v_dSql += N'	             ISNULL(A.NICK_NAME,''-'') AS NICK_NAME                                                                                 ' + char(10)
		SELECT @v_dSql += N'	      FROM	 SCM_ITEM_M A WITH(NOLOCK),                                                                                             ' + char(10)
		SELECT @v_dSql += N'	        		 SCM_ITEM_CLASS_M C WITH(NOLOCK)                                                                                    ' + char(10)
		SELECT @v_dSql += N'	      WHERE	 1=1                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	      AND	A.ITEM_CLASS  = C.CLASS_ID                                                                                              ' + char(10)
		SELECT @v_dSql += N'	      	AND		A.ACTIVE_FLAG = ''Y''                                                                                               ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	  ) B                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	  AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	  AND A.SITE_ID     = B.SITE_ID                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	  AND A.TOP_ITEM_ID = B.ITEM_ID                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	                                                                                                                                                                                    ' + char(10)
		--SELECT @v_dSql += N'	)' + char(10) -- fix remove 1014
		--SELECT @v_dSql += N'	, MAIN_P AS (' + char(10) -- fix remove 1014
		SELECT @v_dSql += N'	  -- P : builing, location, production type, market, line                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	       , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(C.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME                                   ' + char(10)
		SELECT @v_dSql += N'	       , A.OPERATION_ID                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	       , A.FACTORY_ID, A.LOCATION                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	       , ISNULL(MAX(F.QTY),0) AS BOH_QTY                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS SSP_BOH                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	       , NULL AS SSP_HOLD                                                                                                                                                           ' + char(10)
		--SELECT @v_dSql += N'	       , NULL AS SSP_BOH_QTY' + char(10)-- fix remove 1014
		SELECT @v_dSql += N'	       , CONVERT(VARCHAR(4000), NULL) AS SSP_BOH_QTY' + char(10) -- fix remove 1014
		SELECT @v_dSql += N'	       , A.PRODUCTION_TYPE, A.MARKET                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	       , ''P'' AS PSI                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	       , A.LINE_ID                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	       , ISNULL(E.LINE_NAME,''-'') AS LINE_NAME                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	       , A.ELECTRODE_TYPE                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	       , D.CATE_NAME AS CATE                                                                                                                                                        ' + char(10)

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

					SELECT @v_dSql += N'	    		, SUM(CASE WHEN G.YYYYMM = ''' + @sub_param_0 + ''' THEN (CASE WHEN D.CATE_ID = ''P_IN'' 		THEN A.IN_QTY	' + char(10)
					SELECT @v_dSql += N'	    																		  WHEN D.CATE_ID = ''P_OUT''		THEN A.OUT_QTY	' + char(10)
					SELECT @v_dSql += N'																				  WHEN D.CATE_ID = ''P_MPP_IN'' 	THEN A.MPP_IN_QTY	' + char(10)
					SELECT @v_dSql += N'																				  WHEN D.CATE_ID = ''P_MPP_OUT'' 	THEN A.MPP_OUT_QTY	' + char(10)
					SELECT @v_dSql += N'																				  WHEN D.CATE_ID = ''P_WPP_IN''	THEN A.WPP_IN_QTY	' + char(10)
					SELECT @v_dSql += N'																				  WHEN D.CATE_ID = ''P_WPP_OUT'' 	THEN A.WPP_OUT_QTY	' + char(10)
					SELECT @v_dSql += N'																				  WHEN D.CATE_ID = ''P_RESULT'' 	THEN A.RESULT_QTY	' + char(10)
					SELECT @v_dSql += N'																				  ELSE 0 END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'				, SUM(CASE WHEN G.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN (CASE WHEN D.CATE_ID = ''P_IN'' 	THEN A.IN_QTY	' + char(10)
					SELECT @v_dSql += N'	    																		  WHEN D.CATE_ID = ''P_OUT''		THEN A.OUT_QTY	' + char(10)
					SELECT @v_dSql += N'																				  WHEN D.CATE_ID = ''P_MPP_IN'' 	THEN A.MPP_IN_QTY	' + char(10)
					SELECT @v_dSql += N'																				  WHEN D.CATE_ID = ''P_MPP_OUT'' 	THEN A.MPP_OUT_QTY	' + char(10)
					SELECT @v_dSql += N'																				  WHEN D.CATE_ID = ''P_WPP_IN''	THEN A.WPP_IN_QTY	' + char(10)
					SELECT @v_dSql += N'																				  WHEN D.CATE_ID = ''P_WPP_OUT'' 	THEN A.WPP_OUT_QTY	' + char(10)
					SELECT @v_dSql += N'																				  WHEN D.CATE_ID = ''P_RESULT'' 	THEN A.RESULT_QTY	' + char(10)
					SELECT @v_dSql += N'																				  ELSE 0 END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) + char(10)
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

					SELECT @v_dSql += N'			, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = '''+ @sub_param_0 +''' THEN (CASE WHEN D.CATE_ID = ''P_IN'' 	THEN A.IN_QTY	' + char(10)
					SELECT @v_dSql += N'	   																		  WHEN D.CATE_ID = ''P_OUT''		THEN A.OUT_QTY	' + char(10)
					SELECT @v_dSql += N'																			  WHEN D.CATE_ID = ''P_MPP_IN'' 	THEN A.MPP_IN_QTY	' + char(10)
					SELECT @v_dSql += N'																			  WHEN D.CATE_ID = ''P_MPP_OUT'' 	THEN A.MPP_OUT_QTY	' + char(10)
					SELECT @v_dSql += N'																			  WHEN D.CATE_ID = ''P_WPP_IN''	THEN A.WPP_IN_QTY	' + char(10)
					SELECT @v_dSql += N'																			  WHEN D.CATE_ID = ''P_WPP_OUT'' 	THEN A.WPP_OUT_QTY	' + char(10)
					SELECT @v_dSql += N'																			  WHEN D.CATE_ID = ''P_RESULT'' 	THEN A.RESULT_QTY	' + char(10)
					SELECT @v_dSql += N'																			  ELSE 0 END) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +  char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	      , D.CATE_ID AS CATEGORY_ID                                                                            ' + char(10)
		SELECT @v_dSql += N'	      , D.CATE_ORDER AS CATEGORY_ORDER                                                                      ' + char(10)
		SELECT @v_dSql += N'	      , ''DATA'' AS DATA_TYPE                                                                               ' + char(10)
		SELECT @v_dSql += N'	      , NULL AS S_ROW                                                                                       ' + char(10)
		SELECT @v_dSql += N'INTO #TEMP_TABLE_MAIN_P' + char(10) -- fix added
		SELECT @v_dSql += N'	 FROM (                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	            SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                      ' + char(10)
		SELECT @v_dSql += N'	                   ,A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE                                                   ' + char(10)
		SELECT @v_dSql += N'	                   ,A.OPERATION_ID, A.FACTORY_ID, A.LOCATION                                                ' + char(10)
		SELECT @v_dSql += N'	                   ,A.PRODUCTION_TYPE, A.MARKET                                                             ' + char(10)
		SELECT @v_dSql += N'	                   ,A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE, SUM(A.IN_QTY) IN_QTY                   ' + char(10)
		SELECT @v_dSql += N'	                   ,SUM(A.OUT_QTY) OUT_QTY, SUM(A.RESULT_QTY) RESULT_QTY                                    ' + char(10)
		SELECT @v_dSql += N'	                   , SUM(A.MPP_IN_QTY) AS MPP_IN_QTY, SUM(A.MPP_OUT_QTY) AS MPP_OUT_QTY                     ' + char(10)
		SELECT @v_dSql += N'	                   , SUM(A.WPP_IN_QTY) AS WPP_IN_QTY, SUM(A.WPP_OUT_QTY) AS WPP_OUT_QTY                     ' + char(10)
		SELECT @v_dSql += N'	            FROM (                                                                                          ' + char(10)
		SELECT @v_dSql += N'		                SELECT A.INSTANCE_ID, A.FP_PLAN_ID                                                      ' + char(10)
		SELECT @v_dSql += N'		                     , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                               ' + char(10)
		SELECT @v_dSql += N'		                     , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE                                         ' + char(10)
		SELECT @v_dSql += N'		                     , A.OPERATION_ID                                                                   ' + char(10)
		SELECT @v_dSql += N'		                     , A.FACTORY_ID, A.LOCATION                                                         ' + char(10)
		SELECT @v_dSql += N'		                     , A.PRODUCTION_TYPE, A.MARKET                                                      ' + char(10)
		SELECT @v_dSql += N'		                     , ''P'' AS PSI                                                                     ' + char(10)
		SELECT @v_dSql += N'		                     , A.LINE_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'		                     , A.ELECTRODE_TYPE                                                                 ' + char(10)
		SELECT @v_dSql += N'		                     , A.PLAN_DATE                                                                      ' + char(10)
		SELECT @v_dSql += N'		                     , A.IN_QTY                                                                         ' + char(10)
		SELECT @v_dSql += N'		                     , A.OUT_QTY                                                                        ' + char(10)
		SELECT @v_dSql += N'		                     , A.MPP_IN_QTY                                                                     ' + char(10)
		SELECT @v_dSql += N'		                     , A.MPP_OUT_QTY                                                                    ' + char(10)
		SELECT @v_dSql += N'		                     , A.WPP_IN_QTY                                                                     ' + char(10)
		SELECT @v_dSql += N'		                     , A.WPP_OUT_QTY                                                                    ' + char(10)
		SELECT @v_dSql += N'		                     , A.'+ @p_result_qty +' AS RESULT_QTY                                                     ' + char(10)
		SELECT @v_dSql += N'		                FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                     ' + char(10)
		SELECT @v_dSql += N'		                WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                     ' + char(10)
		SELECT @v_dSql += N'		                AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                       ' + char(10)
		SELECT @v_dSql += N'		                AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'		                AND    (A.OUT_QTY > 0 OR A.'+ @p_result_qty +' > 0 OR A.WPP_OUT_QTY > 0 OR A.MPP_OUT_QTY > 0)      ' + char(10)
		SELECT @v_dSql += N'             ) A                                                                                                    ' + char(10)
		SELECT @v_dSql += N'             INNER JOIN (                                                                                           ' + char(10)
		SELECT @v_dSql += N'			                SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,                                 ' + char(10)
		SELECT @v_dSql += N'			                       A.ITEM_ID,																								' + char(10)
		SELECT @v_dSql += N'			                       (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME   ' + char(10)
		SELECT @v_dSql += N'			                       	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                              ' + char(10)
		SELECT @v_dSql += N'			                       	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,                                                             ' + char(10)
		SELECT @v_dSql += N'			                       ISNULL(A.NICK_NAME,''-'') AS NICK_NAME                                                                   ' + char(10)
		SELECT @v_dSql += N'			                FROM	 SCM_ITEM_M A WITH(NOLOCK),                                                                             ' + char(10)
		SELECT @v_dSql += N'					                  		 SCM_ITEM_CLASS_M C WITH(NOLOCK)                                                                ' + char(10)
		SELECT @v_dSql += N'					                WHERE	 A.ITEM_CLASS  = C.CLASS_ID                                                                     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'					                AND 	A.ACTIVE_FLAG = ''Y''															' + char(10)
		SELECT @v_dSql += N'		             			) B                                                                                         ' + char(10)
		SELECT @v_dSql += N'			             ON     A.COMPANY_ID  = B.COMPANY_ID                                                                ' + char(10)
		SELECT @v_dSql += N'			             AND    A.DIVISION_ID = B.DIVISION_ID                                                               ' + char(10)
		SELECT @v_dSql += N'			             AND    A.SITE_ID     = B.SITE_ID                                                                   ' + char(10)
		SELECT @v_dSql += N'			             AND    A.TOP_ITEM_ID = B.ITEM_ID                                                                   ' + char(10)
		SELECT @v_dSql += N'		             WHERE  A.INSTANCE_ID = '''+ @p_master_id +'''                                                                     ' + char(10)
		SELECT @v_dSql += N'		             AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                       ' + char(10)
		SELECT @v_dSql += N'		             AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                          ' + char(10)
		SELECT @v_dSql += N'		             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                            ' + char(10)
		SELECT @v_dSql += N'		                        ,A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE                                                      ' + char(10)
		SELECT @v_dSql += N'		                        ,A.OPERATION_ID, A.FACTORY_ID, A.LOCATION                                                   ' + char(10)
		SELECT @v_dSql += N'		                        ,A.PRODUCTION_TYPE, A.MARKET                                                                ' + char(10)
		SELECT @v_dSql += N'		                        ,A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE                                            ' + char(10)
		SELECT @v_dSql += N'          ) A                                                                                                               ' + char(10)
		SELECT @v_dSql += N'          INNER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                              ' + char(10)
		SELECT @v_dSql += N'				ON     1=1                                                                                                  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'				AND	C.ACTIVE_FLAG = ''Y''                                                                                   ' + char(10)
		SELECT @v_dSql += N'				AND	A.COMPANY_ID   = C.COMPANY_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'				AND	A.DIVISION_ID  = C.DIVISION_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'				AND	A.SITE_ID      = C.SITE_ID                                                                              ' + char(10)
		SELECT @v_dSql += N'				AND	A.TOP_ITEM_ID  = C.ITEM_ID                                                                              ' + char(10)
		SELECT @v_dSql += N'          INNER JOIN (                                                                                                      ' + char(10)
		SELECT @v_dSql += N'						 SELECT *                                                                                           ' + char(10)
		SELECT @v_dSql += N'			              FROM (                                                                                            ' + char(10)

		IF ISNULL(@p_cate_info,'') <> '' BEGIN

			SELECT @v_dSql += N'	SELECT 0 AS CATE_ORDER, '''' AS CATE_NAME, ''X'' AS CATE_ID '+char(10)

			SET @mst_loop_cnt	= 0 ;
			
  			WHILE @mst_loop_cnt < @max_category_loop_cnt
				BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
				SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가
				SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info , @v_row_delimiter , @mst_loop_cnt );
				
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column , @sub_v_delimiter)

				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_ID')   END
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_VALUE')   END
				
				IF @sub_param_0 = 'chk_mpp_inqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT 10 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''P_MPP_IN'' AS CATE_ID '+char(10)
				END ELSE IF @sub_param_0 = 'chk_mpp_outqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT 20 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''P_MPP_OUT'' AS CATE_ID '+char(10)
				END ELSE IF @sub_param_0 = 'chk_wpp_inqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT 30 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''P_WPP_IN'' AS CATE_ID '+char(10)
				END ELSE IF @sub_param_0 = 'chk_wpp_outqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT 40 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''P_WPP_OUT'' AS CATE_ID '+char(10)
				END ELSE IF @sub_param_0 = 'chk_inqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT 50 AS CATE_ORDER, ''Plan(In)'' AS CATE_NAME, ''P_IN'' AS CATE_ID '+char(10)
				END ELSE IF @sub_param_0 = 'chk_outqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT 60 AS CATE_ORDER, ''Plan(Out)'' AS CATE_NAME, ''P_OUT'' AS CATE_ID '+char(10)
				END ELSE IF @sub_param_0 = 'chk_result' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT 70 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT'' AS CATE_ID '+char(10)
				END ELSE IF @sub_param_0 = 'chk_memo' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT 80 AS CATE_ORDER, ''Memo'' AS CATE_NAME, ''P_MEMO'' AS CATE_ID '+char(10)
				END 

			END	-- END OF WHILE

		END ELSE BEGIN
			-- CATEGORY 정보 없는 경우임
			SELECT @v_dSql += N'    SELECT 10 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''P_MPP_IN'' AS CATE_ID			   ' + char(10)
			SELECT @v_dSql += N'    UNION ALL                                                                              ' + char(10)
			SELECT @v_dSql += N'    SELECT 20 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''P_MPP_OUT'' AS CATE_ID           ' + char(10)
			SELECT @v_dSql += N'    UNION ALL                                                                              ' + char(10)
			SELECT @v_dSql += N'    SELECT 30 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''P_WPP_IN'' AS CATE_ID             ' + char(10)
			SELECT @v_dSql += N'    UNION ALL                                                                              ' + char(10)
			SELECT @v_dSql += N'    SELECT 40 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''P_WPP_OUT'' AS CATE_ID           ' + char(10)
			SELECT @v_dSql += N'    UNION ALL                                                                              ' + char(10)
			SELECT @v_dSql += N'    SELECT 50 AS CATE_ORDER, ''Plan(In)'' AS CATE_NAME, ''P_IN'' AS CATE_ID                ' + char(10)
			SELECT @v_dSql += N'    UNION ALL                                                                              ' + char(10)
			SELECT @v_dSql += N'    SELECT 60 AS CATE_ORDER, ''Plan(Out)'' AS CATE_NAME, ''P_OUT'' AS CATE_ID              ' + char(10)
			SELECT @v_dSql += N'    UNION ALL                                                                              ' + char(10)
			SELECT @v_dSql += N'    SELECT 70 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT'' AS CATE_ID			   ' + char(10)
			SELECT @v_dSql += N'    UNION ALL '+char(10)
			SELECT @v_dSql += N'    SELECT 80 AS CATE_ORDER, ''Memo'' AS CATE_NAME, ''P_MEMO'' AS CATE_ID '+char(10)
 
		END	

		SELECT @v_dSql += N'			              ) A                                                                                               ' + char(10)
		SELECT @v_dSql += N'			              WHERE CATE_ID <> ''X''                                                                            ' + char(10)
		SELECT @v_dSql += N'          ) D                                                                                                               ' + char(10)
		SELECT @v_dSql += N'          	ON     1=1                                                                                                      ' + char(10)
		SELECT @v_dSql += N'          INNER JOIN SCM_LINE_M E WITH(NOLOCK)                                                                              ' + char(10)
		SELECT @v_dSql += N'	          ON     A.COMPANY_ID     = E.COMPANY_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'	          AND    A.DIVISION_ID    = E.DIVISION_ID                                                                       ' + char(10)
		SELECT @v_dSql += N'	          AND    A.SITE_ID        = E.SITE_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'	          AND    A.PLANT_ID       = E.PLANT_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'	          AND    A.FACTORY_ID     = E.FACTORY_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'	          AND    A.OPERATION_ID   = E.OPERATION_ID                                                                      ' + char(10)
		SELECT @v_dSql += N'	          AND    A.LINE_ID        = E.LINE_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'	          AND    A.ELECTRODE_TYPE = E.ELECTRODE_TYPE                                                                    ' + char(10)
		SELECT @v_dSql += N'	          AND	E.ACTIVE_FLAG = ''Y''                                                                                   ' + char(10)
		SELECT @v_dSql += N'          LEFT OUTER JOIN (                                                                                                 ' + char(10)
		SELECT @v_dSql += N'				            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                         ' + char(10)
		SELECT @v_dSql += N'				                 , A.OPERATION_ID, A.LOCATION                                                               ' + char(10)
		SELECT @v_dSql += N'				                 , A.ITEM_ID, A.TOP_ITEM_ID, SUM(ISNULL(A.MODIFY_QTY, A.QTY)) AS QTY                        ' + char(10)
		SELECT @v_dSql += N'				            FROM   '+ @p_amend_cutoff_boh_table +' A WITH(NOLOCK)                                                  ' + char(10)
		SELECT @v_dSql += N'				            WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                             ' + char(10)
		SELECT @v_dSql += N'				            AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                               ' + char(10)
		SELECT @v_dSql += N'				            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                       ' + char(10)
		SELECT @v_dSql += N'				                   , A.OPERATION_ID, A.LOCATION                                                             ' + char(10)
		SELECT @v_dSql += N'				                   , A.ITEM_ID, A.TOP_ITEM_ID                                                               ' + char(10)
		SELECT @v_dSql += N'          ) F                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	          ON  A.COMPANY_ID   = F.COMPANY_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'	          AND A.DIVISION_ID  = F.DIVISION_ID                                                                            ' + char(10)
		SELECT @v_dSql += N'	          AND A.SITE_ID      = F.SITE_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'	          AND A.PLANT_ID     = F.PLANT_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'	          AND A.FACTORY_ID   = F.FACTORY_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'	          AND A.OPERATION_ID = F.OPERATION_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'	          AND A.LOCATION     = F.LOCATION                                                                               ' + char(10)
		SELECT @v_dSql += N'	          AND A.ITEM_ID      = F.ITEM_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'	          AND A.TOP_ITEM_ID  = F.TOP_ITEM_ID                                                                            ' + char(10)
		SELECT @v_dSql += N'		  INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK)                                                                         ' + char(10)
		SELECT @v_dSql += N'          	ON  A.PLAN_DATE    = G.DT                                                                                       ' + char(10)
		SELECT @v_dSql += N'          WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID           ' + char(10)
		SELECT @v_dSql += N'	                 , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-''), ISNULL(C.PACK_PRODUCT_GROUP_CODE,''-'')	' + char(10)
		SELECT @v_dSql += N'	                 , A.OPERATION_ID                                                                                           	' + char(10)
		SELECT @v_dSql += N'	                 , A.FACTORY_ID, A.LOCATION                                                                                 	' + char(10)
		SELECT @v_dSql += N'	                 , A.PRODUCTION_TYPE, A.MARKET                                                                                  ' + char(10)
		SELECT @v_dSql += N'	                 , A.LINE_ID, ISNULL(E.LINE_NAME,''-'')                                                                         ' + char(10)
		SELECT @v_dSql += N'	                 , A.ELECTRODE_TYPE																		' + char(10)
		SELECT @v_dSql += N'	                 , D.CATE_NAME                                                                          ' + char(10)
		SELECT @v_dSql += N'	                 , D.CATE_ORDER, D.CATE_NAME, D.CATE_ID                                                 ' + char(10)

		--SELECT @v_dSql += N'	      )' + char(10) -- fix remove 1014
		--SELECT @v_dSql += N'	      , MAIN_P_SUBT AS (' + char(10)-- fix remove 1014

		SELECT @v_dSql += N'	          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                     ' + char(10)
		SELECT @v_dSql += N'	               , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME                   ' + char(10)
		SELECT @v_dSql += N'	               , A.OPERATION_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'	               , ''Total'' AS FACTORY_ID, NULL AS LOCATION                                              ' + char(10)
		SELECT @v_dSql += N'	               , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY                                                    ' + char(10)
		SELECT @v_dSql += N'	               , NULL AS SSP_BOH                                                                        ' + char(10)
		SELECT @v_dSql += N'	               , NULL AS SSP_HOLD                                                                       ' + char(10)
		--SELECT @v_dSql += N'	               , NULL AS SSP_BOH_QTY' + char(10) -- fix remove 1014
		--SELECT @v_dSql += N'	               , NULL AS PRODUCTION_TYPE' + char(10)+ char(10) -- fix remove 1014
		--SELECT @v_dSql += N'	               , NULL AS MARKET' + char(10)+ char(10) -- fix remove 1014
		SELECT @v_dSql += N'	               , CONVERT(NVARCHAR(4000), NULL) AS SSP_BOH_QTY' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	               , CONVERT(NVARCHAR(60), NULL) AS PRODUCTION_TYPE' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	               , CONVERT(NVARCHAR(60), NULL) AS MARKET' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	               , A.PSI                                                                                  ' + char(10)
		--SELECT @v_dSql += N'	               , NULL AS LINE_ID' + char(10)+ char(10) -- fix remove 1014
		--SELECT @v_dSql += N'	               , NULL AS LINE_NAME' + char(10)+ char(10) -- fix remove 1014
		--SELECT @v_dSql += N'	               , NULL AS ELECTRODE_TYPE' + char(10)+ char(10) -- fix remove 1014
		SELECT @v_dSql += N'	               , CONVERT(NVARCHAR(60), NULL) AS LINE_ID' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	               , CONVERT(NVARCHAR(300), NULL) AS LINE_NAME' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	               , CONVERT(NVARCHAR(100), NULL) AS ELECTRODE_TYPE' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	               , A.CATE                                                                                 ' + char(10)
		
		IF ISNULL(@p_bucket,'') <> '' BEGIN
			
			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SET @v_dSql += '               , SUM(M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SET @v_dSql += '               , SUM(W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @v_dSql += '               , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			
			END --end of @max_loop_cnt

		END -- end of isnull(@p_bucket,'') <> ''
	
		SELECT @v_dSql += N'	               , A.CATEGORY_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'	               , (CASE WHEN A.CATEGORY_ID=''P_IN'' THEN 600 WHEN A.CATEGORY_ID=''P_OUT'' THEN 700 ELSE 800 END) AS CATEGORY_ORDER   ' + char(10)	
		SELECT @v_dSql += N'	               , ''TOTAL'' AS DATA_TYPE                                                                                             ' + char(10)
		SELECT @v_dSql += N'	               , NULL AS S_ROW' + char(10)
		SELECT @v_dSql += N'INTO #TABLE_TABLE_MAIN_P_SUBT' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	          FROM (                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                             ' + char(10)
		SELECT @v_dSql += N'	                   , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME                                           ' + char(10)
		SELECT @v_dSql += N'	                   , A.OPERATION_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	                   , ''Total'' AS FACTORY_ID, NULL AS LOCATION                                                                      ' + char(10)
		SELECT @v_dSql += N'	                   , A.BOH_QTY                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	                   , NULL AS PRODUCTION_TYPE                                                                                        ' + char(10)
		SELECT @v_dSql += N'	                   , NULL AS MARKET																									' + char(10)
		SELECT @v_dSql += N'	                   , A.PSI                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	                   , NULL AS LINE_ID                                                                                                ' + char(10)
		SELECT @v_dSql += N'	                   , NULL AS LINE_NAME                                                                                              ' + char(10)
		SELECT @v_dSql += N'	                   , NULL AS ELECTRODE_TYPE                                                                                         ' + char(10)
		SELECT @v_dSql += N'	                   , A.CATE                                                                                                         ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SET @v_dSql += '               , SUM(M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SET @v_dSql += '               , SUM(W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @v_dSql += '               , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	                   , A.CATEGORY_ID                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	                   , (CASE WHEN A.CATEGORY_ID=''P_IN'' THEN 600 WHEN A.CATEGORY_ID=''P_OUT'' THEN 700 ELSE 800 END) AS CATEGORY_ORDER	             ' + char(10)
		SELECT @v_dSql += N'	                   , ''TOTAL'' AS DATA_TYPE             ' + char(10)
		SELECT @v_dSql += N'	                   , NULL AS S_ROW             ' + char(10)
		SELECT @v_dSql += N'	                   , ROW_NUMBER( ) OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME, A.OPERATION_ID, A.CATEGORY_ID, A.PSI, A.CATE             ' + char(10)
		SELECT @v_dSql += N'	                                         ORDER BY     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME, A.OPERATION_ID, A.CATEGORY_ID, A.PSI, A.CATE ) AS BOH_ROWNUM             ' + char(10)
		--SELECT @v_dSql += N'	              FROM MAIN_P A' + char(10) -- fix remove 1014
		SELECT @v_dSql += N'	              FROM #TEMP_TABLE_MAIN_P A' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                       ' + char(10)
		SELECT @v_dSql += N'	                     , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME     ' + char(10)
		SELECT @v_dSql += N'	                     , A.OPERATION_ID                                                           ' + char(10)
		SELECT @v_dSql += N'	                     , A.CATEGORY_ID                                                            ' + char(10)
		SELECT @v_dSql += N'	                     , A.PSI, A.CATE                                                            ' + char(10)
		SELECT @v_dSql += N'	                     , A.BOH_QTY                                                                ' + char(10)
		SELECT @v_dSql += N'	          ) A                                                                                   ' + char(10)
		SELECT @v_dSql += N'	          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                           ' + char(10)
		SELECT @v_dSql += N'	                 , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME         ' + char(10)
		SELECT @v_dSql += N'	                 , A.OPERATION_ID                                                               ' + char(10)
		SELECT @v_dSql += N'	                 , A.CATEGORY_ID                                                                ' + char(10)
		SELECT @v_dSql += N'	                 , A.PSI, A.CATE                                                                ' + char(10)
		--SELECT @v_dSql += N'	      )' + char(10) -- fix remove 1014
		--SELECT @v_dSql += N'	      , DO_INFO AS (' + char(10) -- fix remove 1014
		SELECT @v_dSql += N'	        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                               ' + char(10)
		SELECT @v_dSql += N'	             , A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, B.NICK_NAME, B.PJT_GROUP_NAME             ' + char(10)
		SELECT @v_dSql += N'	             , A.OPERATION_ID                                                                   ' + char(10)
		SELECT @v_dSql += N'	             , A.FACTORY_ID, ''-'' AS LOCATION                                                  ' + char(10)
		SELECT @v_dSql += N'	             , ISNULL(MAX(A.BOH_QTY),0) AS BOH_QTY                                              ' + char(10)
		SELECT @v_dSql += N'             , NULL AS SSP_BOH                                                                       													' + char(10)
		SELECT @v_dSql += N'             , NULL AS SSP_HOLD                                                                                                                         ' + char(10)
		--SELECT @v_dSql += N'             , NULL AS SSP_BOH_QTY' + char(10) -- fix remove 1014
		--SELECT @v_dSql += N'             , NULL AS PRODUCTION_TYPE' + char(10) -- fix remove 1014
		--SELECT @v_dSql += N'             , NULL AS MARKET' + char(10) -- fix remove 1014
		SELECT @v_dSql += N'             ,  CONVERT(NVARCHAR(4000),NULL)  AS SSP_BOH_QTY' + char(10) -- fix added 1014
		SELECT @v_dSql += N'             ,  CONVERT(NVARCHAR(60), NULL)  AS PRODUCTION_TYPE' + char(10) -- fix added 1014
		SELECT @v_dSql += N'             ,  CONVERT(NVARCHAR(60), NULL)  AS MARKET' + char(10) -- fix added 1014
		SELECT @v_dSql += N'             , ''DO'' AS PSI                                                                                                                            ' + char(10)
		--SELECT @v_dSql += N'             , NULL AS LINE_ID' + char(10) -- fix remove 1014
		--SELECT @v_dSql += N'             , NULL AS LINE_NAME' + char(10) -- fix remove 1014
		--SELECT @v_dSql += N'             , NULL AS ELECTRODE_TYPE' + char(10) -- fix remove 1014
		--SELECT @v_dSql += N'             , NULL AS CATE' + char(10) -- fix remove 1014
		SELECT @v_dSql += N'             ,  CONVERT(NVARCHAR(100), NULL)  AS LINE_ID' + char(10) -- fix added 1014
		SELECT @v_dSql += N'             ,  CONVERT(NVARCHAR(300), NULL)  AS LINE_NAME' + char(10) -- fix added 1014
		SELECT @v_dSql += N'             ,  CONVERT(NVARCHAR(300), NULL)  AS ELECTRODE_TYPE' + char(10) -- fix added 1014
		SELECT @v_dSql += N'             ,  CONVERT(NVARCHAR(100), NULL)  AS CATE' + char(10) -- fix added 1014

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

					SELECT @v_dSql += N'      			, SUM(CASE WHEN G.YYYYMM = ''' + @sub_param_0 + ''' THEN A.P_QTY ELSE 0 END) M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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
					
					SELECT @v_dSql += N'      			, SUM(CASE WHEN G.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN A.P_QTY ELSE 0 END) W' + TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) + char(10)
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
					
					SELECT @v_dSql += N'                , SUM(CASE WHEN G.YYYYMMDD = '''+ @sub_param_0 +''' THEN A.P_QTY ELSE 0 END) D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +  char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'             , ''DO'' AS CATEGORY_ID                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'             , 50 AS CATEGORY_ORDER                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'             , ''DATA'' AS DATA_TYPE                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'             , NULL AS S_ROW                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'INTO #TEMP_TABLE_DO_INFO' + char(10) -- fix added 1014
		SELECT @v_dSql += N'        FROM (                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'               , F.FACTORY_ID, F.OPERATION_ID                                                                                                           ' + char(10)
		SELECT @v_dSql += N'               , E.PACK_ITEM_ID AS TOP_ITEM_ID, E.P5000_ITEM AS ITEM_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'               , A.PLAN_DATE AS PLAN_DATE                                                                                                               ' + char(10)
		SELECT @v_dSql += N'               , ISNULL(B.QTY,0) AS BOH_QTY                                                                                                             ' + char(10)
		SELECT @v_dSql += N'               , A.QTY AS P_QTY                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'          FROM   FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)                                                                                                  ' + char(10)
		SELECT @v_dSql += N'          LEFT OUTER HASH JOIN (                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,                                                                                ' + char(10)
		SELECT @v_dSql += N'                     A.FP_APPLY_ITEM_ID AS ITEM_ID,                                                                                                     ' + char(10)
		SELECT @v_dSql += N'                     ISNULL(MAX(MODIFY_FP_APPLY_WIPQTY),SUM(A.FP_APPLY_WIPQTY)) AS QTY                                                                  ' + char(10)
		SELECT @v_dSql += N'              FROM   SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                         ' + char(10)
		SELECT @v_dSql += N'              WHERE  A.OPERATION_ID = ''P1000''                                                                                                         ' + char(10)
		SELECT @v_dSql += N'              AND    A.STOCK_STATUS = ''WAIT''                                                                                                          ' + char(10)
		SELECT @v_dSql += N'              AND    A.STORAGE_ID = ''MES''                                                                                                             ' + char(10)
		SELECT @v_dSql += N'              AND    CONVERT(VARCHAR, A.CUTOFF_DATE,112) = '''+ @p_plan_date +'''                                                                                  ' + char(10)
		--하드코딩 전환
		--SELECT @v_dSql += N'              AND    ((A.STORAGE_ID  BETWEEN ''1000'' AND ''1999'') OR (A.STORAGE_ID >= ''5000'' AND A.STORAGE_ID < ''6000'') OR (ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0))       ' + char(10)
		SELECT @v_dSql += N'AND ((A.STORAGE_ID >= (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK'' AND SEGMENT1  = ''2'' AND ACTIVE_FLAG = ''Y'' AND ATTRIBUTE3=''MIN'') ' + char(10)
		SELECT @v_dSql += N'AND A.STORAGE_ID < (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK'' AND SEGMENT1  = ''2'' AND ACTIVE_FLAG = ''Y'' AND ATTRIBUTE3=''MAX'') )' +char(10)
		SELECT @v_dSql += N'OR (A.STORAGE_ID >= (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK'' AND SEGMENT1  = ''1'' AND ACTIVE_FLAG = ''Y'' AND ATTRIBUTE3=''MIN'') ' + char(10)
		SELECT @v_dSql += N'AND A.STORAGE_ID < (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK'' AND SEGMENT1  = ''1'' AND ACTIVE_FLAG = ''Y'' AND ATTRIBUTE3=''MAX'') ) OR (ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0) )' +char(10)



		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FP_APPLY_ITEM_ID                               ' + char(10)
		SELECT @v_dSql += N'          ) B                                                                                                               ' + char(10)
		SELECT @v_dSql += N'          ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'          AND A.DIVISION_ID = B.DIVISION_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'          AND A.SITE_ID     = B.SITE_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'          AND A.PLANT_ID    = B.PLANT_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'          AND A.ITEM_ID     = B.ITEM_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'          INNER HASH JOIN (                                                                                                 ' + char(10)
		SELECT @v_dSql += N'              SELECT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID, A.SEGMENT3 AS SOC_ID, ATTRIBUTE3 AS SORT_ORDER       ' + char(10)
		SELECT @v_dSql += N'              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                    ' + char(10)
		SELECT @v_dSql += N'              WHERE  A.LOOKUP_TYPE_CODE = ''PACK_SOC''                                                                      ' + char(10)
		SELECT @v_dSql += N'              AND    A.ACTIVE_FLAG = ''Y''                                                                                  ' + char(10)
		SELECT @v_dSql += N'          ) DD                                                                                                              ' + char(10)
		SELECT @v_dSql += N'          ON  A.DIVISION_ID = DD.DIVISION_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'          AND A.SITE_ID     = DD.SITE_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'          AND A.SOC_ID      = DD.SOC_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'          INNER HASH JOIN (                                                                                                 ' + char(10)
		SELECT @v_dSql += N'              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                            ' + char(10)
		SELECT @v_dSql += N'                   , A.TOP_ITEM_ID AS PACK_ITEM_ID, A.ITEM_ID AS P5000_ITEM, A.CELL_ITEM_ID                                 ' + char(10)
		SELECT @v_dSql += N'              FROM   TH_BUF_PACK_BOM_INFO A                                                                                 ' + char(10)
		SELECT @v_dSql += N'          ) E                                                                                                               ' + char(10)
		SELECT @v_dSql += N'          ON  A.COMPANY_ID  = E.COMPANY_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'          AND A.DIVISION_ID = E.DIVISION_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'          AND A.SITE_ID     = E.SITE_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'          AND A.PLANT_ID    = E.PLANT_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'          AND A.ITEM_ID     = E.CELL_ITEM_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'          INNER HASH JOIN (                                                                                                 ' + char(10)
		SELECT @v_dSql += N'              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID              ' + char(10)
		SELECT @v_dSql += N'                            , A.TOP_ITEM_ID, A.ITEM_ID                                                                      ' + char(10)
		SELECT @v_dSql += N'              FROM (                                                                                                        ' + char(10)
		SELECT @v_dSql += N'                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                 ' + char(10)
		SELECT @v_dSql += N'                       , A.TOP_ITEM_ID, A.ITEM_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'                       , A.OPERATION_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'                       , A.FACTORY_ID                                                                                       ' + char(10)
		SELECT @v_dSql += N'                  FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                                       ' + char(10)
		SELECT @v_dSql += N'                  WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                       ' + char(10)
		SELECT @v_dSql += N'                  AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                         ' + char(10)
		SELECT @v_dSql += N'                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                             ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'                  AND    A.OPERATION_ID = ''P5000''                                                             ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'                  AND    (A.OUT_QTY > 0 OR A.'+ @p_result_qty +' > 0 OR A.WPP_OUT_QTY > 0 OR A.MPP_OUT_QTY > 0)        ' + char(10)
		SELECT @v_dSql += N'                  UNION ALL                                                                                     ' + char(10)
		SELECT @v_dSql += N'                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                     ' + char(10)
		SELECT @v_dSql += N'                       , A.TOP_ITEM_ID, A.ITEM_ID                                                               ' + char(10)
		SELECT @v_dSql += N'                       , A.OPERATION_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'                       , A.FACTORY_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'                  FROM   '+ @p_amend_sales_table +' A WITH(NOLOCK)                                                     ' + char(10)
		SELECT @v_dSql += N'                  WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                           ' + char(10)
		SELECT @v_dSql += N'                  AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                             ' + char(10)
		SELECT @v_dSql += N'                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                 ' + char(10)
		SELECT @v_dSql += N'				  AND    A.CATEGORY_ID = ''PLAN''                                            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'                  AND    A.OPERATION_ID = ''P5000''                                                             ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'                  AND    ISNULL(A.SALES_QTY,0) > 0                                                              ' + char(10)
		SELECT @v_dSql += N'              ) A                                                                                               ' + char(10)
		SELECT @v_dSql += N'              WHERE 1=1                                                                                         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'          ) F                                                                                                   ' + char(10)
		SELECT @v_dSql += N'          ON  A.COMPANY_ID   = F.COMPANY_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'          AND A.DIVISION_ID  = F.DIVISION_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'          AND A.SITE_ID      = F.SITE_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'          AND A.PLANT_ID     = F.PLANT_ID                                                                       ' + char(10)
		SELECT @v_dSql += N'          AND E.PACK_ITEM_ID = F.TOP_ITEM_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'          AND E.P5000_ITEM   = F.ITEM_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'          WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'          AND A.CATEGORY = ''MOVING''                                                                           ' + char(10)
		SELECT @v_dSql += N'        ) A                                                                                                     ' + char(10)
		SELECT @v_dSql += N'        INNER JOIN (                                                                                            ' + char(10)
		SELECT @v_dSql += N'            SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,                                             ' + char(10)
		SELECT @v_dSql += N'                   A.ITEM_ID,                                                                                   ' + char(10)
		SELECT @v_dSql += N'                   (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME	' + char(10)
		SELECT @v_dSql += N'                   	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                              ' + char(10)
		SELECT @v_dSql += N'                   	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,                                                             ' + char(10)
		SELECT @v_dSql += N'                   ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME        ' + char(10)
		SELECT @v_dSql += N'            FROM	 SCM_ITEM_M A WITH(NOLOCK),                                                                             ' + char(10)
		SELECT @v_dSql += N'              		 SCM_ITEM_CLASS_M C WITH(NOLOCK)                                                                        ' + char(10)
		SELECT @v_dSql += N'            WHERE	 A.ITEM_CLASS  = C.CLASS_ID                                                                             ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'        ) B                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'        ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'        AND A.DIVISION_ID = B.DIVISION_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'        AND A.SITE_ID     = B.SITE_ID                                                                                       ' + char(10)
		SELECT @v_dSql += N'        AND A.TOP_ITEM_ID = B.ITEM_ID																' + char(10)
		SELECT @v_dSql += N'        INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK)                                                   ' + char(10)
		SELECT @v_dSql += N'        ON  A.PLAN_DATE   = G.DT                                                                    ' + char(10)
		SELECT @v_dSql += N'        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                 ' + char(10)
		SELECT @v_dSql += N'               , A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, B.NICK_NAME, B.PJT_GROUP_NAME               ' + char(10)
		SELECT @v_dSql += N'               , A.OPERATION_ID, A.FACTORY_ID                                                       ' + char(10)
		--SELECT @v_dSql += N'      )' + char(10)-- fix remove 1014
		--SELECT @v_dSql += N'      , T_MEMO AS (' + char(10)-- fix remove 1014
		SELECT @v_dSql += N'      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID             ' + char(10)
		SELECT @v_dSql += N'		               , A.OPERATION_ID                                                             ' + char(10)
		SELECT @v_dSql += N'		               , A.LINE_ID, A.ELECTRODE_TYPE                                                ' + char(10)
		SELECT @v_dSql += N'		               , A.EQUIPMENT_ID                                                             ' + char(10)
		SELECT @v_dSql += N'		               , A.ITEM_ID, A.TOP_ITEM_ID                                                   ' + char(10)
		SELECT @v_dSql += N'		               , A.PRODUCTION_TYPE, A.MARKET                                                ' + char(10)
		
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
					
					SELECT @v_dSql += N'			    , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = '''+ @sub_param_0 +''' AND A.MEMO IS NOT NULL THEN ''Y'' ELSE NULL END) AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +'_MO  ' + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'INTO #TEMP_TABLE_T_MEMO' + char(10)-- fix added 1014
		SELECT @v_dSql += N'	          FROM FP_AMEND_MEMO_M A WITH(NOLOCK)                       ' + char(10)
		SELECT @v_dSql += N'	          WHERE 1=1                                                 ' + char(10)
		SELECT @v_dSql += N'	          AND    A.INSTANCE_ID  = '''+ @p_instance_id +'''                     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'		          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                     ' + char(10)
		SELECT @v_dSql += N'						, A.OPERATION_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'						, A.LINE_ID, A.ELECTRODE_TYPE                                                           ' + char(10)
		SELECT @v_dSql += N'						, A.EQUIPMENT_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'						, A.ITEM_ID, A.TOP_ITEM_ID                                                              ' + char(10)
		SELECT @v_dSql += N'						, A.PRODUCTION_TYPE, A.MARKET                                                           ' + char(10)
		--SELECT @v_dSql += N'	      )' + char(10) -- fix remove 1014
		--SELECT @v_dSql += N'	      , SSP_INFO AS (' + char(10) -- fix remove 1014
		SELECT @v_dSql += N'	          SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID                       ' + char(10)
		SELECT @v_dSql += N'	          		   , CASE WHEN (D.CATE_ID = ''I_SSP'' OR D.CATE_ID = ''I_SSP_SIMUL'') THEN A.TOP_ITEM_ID ELSE NULL END AS ITEM_ID            ' + char(10)
		SELECT @v_dSql += N'	          		   , B.ITEM_TYPE, B.NICK_NAME, B.PJT_GROUP_NAME                                             ' + char(10)
		SELECT @v_dSql += N'	          		   , CASE WHEN (D.CATE_ID = ''I_SSP'' OR D.CATE_ID = ''I_SSP_SIMUL'') THEN PP.OPERATION_ID ELSE NULL END AS OPERATION_ID     ' + char(10)
		--SELECT @v_dSql += N'		               --, NULL AS OPERATION_ID                                                                 ' + char(10)
		--SELECT @v_dSql += N'		               , NULL AS FACTORY_ID' + char(10)-- fix remove 1014
		SELECT @v_dSql += N'		               , CONVERT(NVARCHAR(60), NULL) AS FACTORY_ID' + char(10)-- fix added 1014
		SELECT @v_dSql += N'		               , ''-'' AS LOCATION                                                                      ' + char(10)
		SELECT @v_dSql += N'		               , NULL AS BOH_QTY                                                                        ' + char(10)
		SELECT @v_dSql += N'		               , ISNULL( MAX(A.BOH_QTY),0) AS SSP_BOH                                                   ' + char(10)
		SELECT @v_dSql += N'	             	   , NULL AS SSP_HOLD                                                                       ' + char(10)
		SELECT @v_dSql += N'	                   , CASE WHEN (D.CATE_ID = ''I_SSP'' OR D.CATE_ID = ''I_SSP_SIMUL'') THEN REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.BOH_QTY),0) AS MONEY),1),''.00'','''') 									' + char(10)
		SELECT @v_dSql += N'																			+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.HOLD_QTY) ,0) AS MONEY),1),''.00'','''') + '')''  ' + char(10)
		SELECT @v_dSql += N'							  ELSE NULL END AS SSP_BOH_QTY										' + char(10)
		--SELECT @v_dSql += N'		               , NULL AS PRODUCTION_TYPE' + char(10)-- fix remove 1014
		--SELECT @v_dSql += N'		               , NULL AS MARKET' + char(10)-- fix remove 1014
		SELECT @v_dSql += N'		               , CONVERT(NVARCHAR(60), NULL) AS PRODUCTION_TYPE' + char(10)-- fix added 1014
		SELECT @v_dSql += N'		               , CONVERT(NVARCHAR(60), NULL) AS MARKET' + char(10)-- fix added 1014
		SELECT @v_dSql += N'		               , CASE WHEN (D.CATE_ID = ''I_SSP'' OR D.CATE_ID = ''I_SSP_SIMUL'') THEN ''I'' ELSE NULL END AS PSI        ' + char(10)
		SELECT @v_dSql += N'		               --, NULL AS PSI                                                          ' + char(10)
		--SELECT @v_dSql += N'		               , NULL AS LINE_ID' + char(10)-- fix remove 1014
		--SELECT @v_dSql += N'		               , NULL AS LINE_NAME' + char(10)-- fix remove 1014
		--SELECT @v_dSql += N'		               , NULL AS ELECTRODE_TYPE' + char(10)-- fix remove 1014
		SELECT @v_dSql += N'		               , CONVERT(NVARCHAR(60), NULL)  AS LINE_ID' + char(10)-- fix added 1014
		SELECT @v_dSql += N'		               , CONVERT(NVARCHAR(300), NULL)  AS LINE_NAME' + char(10)-- fix added 1014
		SELECT @v_dSql += N'		               , CONVERT(NVARCHAR(100), NULL)  AS ELECTRODE_TYPE' + char(10)-- fix added 1014
		SELECT @v_dSql += N'		               , D.CATE_NAME AS CATE                                                    ' + char(10)

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
					SELECT @v_dSql += N'				, SUM(CASE WHEN G.YYYYMM = ''' + @sub_param_0 + ''' THEN ( CASE WHEN D.CATE_ID = ''SSP''	THEN A.SHIP_QTY	' + char(10)
					SELECT @v_dSql += N'																				WHEN D.CATE_ID = ''I_SSP''	THEN A.SSP_EOH_QTY 	' + char(10)
					SELECT @v_dSql += N'																				WHEN D.CATE_ID = ''SSP_SIMUL''	THEN A.SHIP_SIMUL_QTY 	' + char(10)
					SELECT @v_dSql += N'																				WHEN D.CATE_ID = ''I_SSP_SIMUL''	THEN A.SSP_SIMUL_EOH_QTY 	' + char(10)
					SELECT @v_dSql += N'																				ELSE 0 END ) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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
					SELECT @v_dSql += N'				, SUM(CASE WHEN G.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN ( CASE WHEN D.CATE_ID = ''SSP''	THEN A.SHIP_QTY	' + char(10)
					SELECT @v_dSql += N'																					WHEN D.CATE_ID = ''I_SSP''	THEN A.SSP_EOH_QTY 	' + char(10)
					SELECT @v_dSql += N'																					WHEN D.CATE_ID = ''SSP_SIMUL''	THEN A.SHIP_SIMUL_QTY 	' + char(10)
					SELECT @v_dSql += N'																					WHEN D.CATE_ID = ''I_SSP_SIMUL''	THEN A.SSP_SIMUL_EOH_QTY 	' + char(10)
					SELECT @v_dSql += N'																					ELSE 0 END ) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- Day bucket
				SET @mst_loop_cnt = 0	

				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN

					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = ''
					SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)

					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END
					SELECT @v_dSql += N'				, SUM(CASE WHEN A.SHIP_DATE <= '''+ @sub_param_0 +''' AND A.SHIP_DATE >= '''+ @p_plan_date +''' AND D.CATE_ID = ''I_SSP'' THEN A.SSP_EOH_QTY ' + char(10)
					SELECT @v_dSql += N'						   WHEN A.SHIP_DATE = '''+ @sub_param_0 +''' AND D.CATE_ID = ''SSP'' THEN A.SHIP_QTY ' +  char(10)
					SELECT @v_dSql += N'						   WHEN A.SHIP_DATE <= '''+ @sub_param_0 +''' AND A.SHIP_DATE >= '''+ @p_plan_date +''' AND D.CATE_ID = ''I_SSP_SIMUL'' THEN A.SSP_SIMUL_EOH_QTY ' + char(10)
					SELECT @v_dSql += N'						   WHEN A.SHIP_DATE = '''+ @sub_param_0 +''' AND D.CATE_ID = ''SSP_SIMUL'' THEN A.SHIP_SIMUL_QTY ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +  char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'        			, D.CATE_ID AS CATEGORY_ID                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'                    , D.CATE_ORDER AS CATEGORY_ORDER                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	                , ''DATA'' AS DATA_TYPE                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	                , NULL AS S_ROW                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'INTO #TEMP_TABLE_SSP_INFO  ' + char(10)-- fix added 1014
		SELECT @v_dSql += N'          FROM (                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'          			SELECT  A.COMPANY_ID                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'							 ,A.DIVISION_ID                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'							 ,A.SITE_ID                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'							 ,A.PLANT_ID                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'							 ,A.TOP_ITEM_ID                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'							 --,A.PRODUCTION_TYPE                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'							 ,A.SHIP_DATE                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'							 ,A.SHIP_QTY                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'							 ,A.BOH_QTY                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'							 ,A.HOLD_QTY                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'							 ,A.SHIP_SIMUL_QTY                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'							 , CASE WHEN A.SHIP_DATE = CONVERT(DATE,'''+ @p_plan_date +''') THEN (ISNULL(A.BOH_QTY,0) - ISNULL(SHIP_QTY,0) + ISNULL(OUT_QTY,0)) ELSE (0 - ISNULL(SHIP_QTY,0) + ISNULL(OUT_QTY,0)) END AS SSP_EOH_QTY              ' + char(10)
		SELECT @v_dSql += N'							 , CASE WHEN A.SHIP_DATE = CONVERT(DATE,'''+ @p_plan_date +''') THEN (ISNULL(A.BOH_QTY,0) - ISNULL(SHIP_SIMUL_QTY,0) + ISNULL(OUT_QTY,0)) ELSE (0 - ISNULL(SHIP_SIMUL_QTY,0) + ISNULL(OUT_QTY,0)) END AS SSP_SIMUL_EOH_QTY              ' + char(10)
		SELECT @v_dSql += N'					FROM (                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'								SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, TOP_ITEM_ID, A.SHIP_DATE	--, A.PRODUCTION_TYPE, A.SHIP_DATE                                              ' + char(10)
		SELECT @v_dSql += N'											, SUM(A.SHIP_QTY) AS SHIP_QTY                                                                                                            ' + char(10)
		SELECT @v_dSql += N'											, MAX(D.BOH_QTY) AS BOH_QTY                                                                                                              ' + char(10)
		SELECT @v_dSql += N'											, MAX(D.HOLD_QTY) AS HOLD_QTY                                                                                                            ' + char(10)
		SELECT @v_dSql += N'											, SUM(A.OUT_QTY) AS OUT_QTY                                                                                                              ' + char(10)
		SELECT @v_dSql += N'											, SUM(A.SHIP_SIMUL_QTY) AS SHIP_SIMUL_QTY                                                                                                ' + char(10)
		SELECT @v_dSql += N'								FROM (                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'							              	-- Shipment Plan 정보                                          ' + char(10)
		
		IF @p_shipment_opt = 'R' BEGIN
			SELECT @v_dSql += N'	-- 실시간 Shipment plan                                                                                                                                         ' + char(10)
			SELECT @v_dSql += N'											SELECT  A.COMPANY_ID                                                                                                                    ' + char(10)
			SELECT @v_dSql += N'											      , A.DIVISION_ID                                                                                                                   ' + char(10)
			SELECT @v_dSql += N'											      , A.SITE_ID                                                                                                                       ' + char(10)
			SELECT @v_dSql += N'											      , A.PLANT_ID                                                                                                                      ' + char(10)
			SELECT @v_dSql += N'											      , A.ITEM_ID AS TOP_ITEM_ID                                                                                                        ' + char(10)
			SELECT @v_dSql += N'											      , A.PRODUCTION_TYPE                                                                                                               ' + char(10)
			SELECT @v_dSql += N'											      , CONVERT(VARCHAR,A.SHIP_DATE,112) AS SHIP_DATE                                                                                   ' + char(10)
			SELECT @v_dSql += N'											      , ISNULL(A.SHIP_QTY,0) AS SHIP_QTY                                                                                                ' + char(10)
			SELECT @v_dSql += N'											      , 0 AS BOH_QTY, 0 AS HOLD_QTY, 0 AS OUT_QTY, 0 AS SHIP_SIMUL_QTY                                                                  ' + char(10)
			SELECT @v_dSql += N'											FROM    FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK)                                                                                      ' + char(10)
			
			-- fix mod 1017 start
			SELECT @v_dSql += N'INNER JOIN (' + char(10)
			SELECT @v_dSql += N'SELECT DIVISION_ID, SITE_ID, A.SHOP_GROUP_ID, MAX(SCP_PLAN_ID) AS SCP_PLAN_ID' + char(10)
			SELECT @v_dSql += N'FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK)' + char(10)
			SELECT @v_dSql += N'WHERE	 1=1' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SELECT @v_dSql += N'GROUP BY DIVISION_ID, SITE_ID, A.SHOP_GROUP_ID' + char(10)
			SELECT @v_dSql += N') AA' + char(10)
			SELECT @v_dSql += N'ON  A.DIVISION_ID   = AA.DIVISION_ID' + char(10)
			SELECT @v_dSql += N'AND   A.SITE_ID       = AA.SITE_ID' + char(10)
			SELECT @v_dSql += N'AND   A.SHOP_GROUP_ID = AA.SHOP_GROUP_ID' + char(10)
			SELECT @v_dSql += N'AND   A.SCP_PLAN_ID   = AA.SCP_PLAN_ID' + char(10)
			-- fix mod 1017 end

			
			
			
			SELECT @v_dSql += N'													INNER HASH JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)                                                                                     ' + char(10) -- fix remove 1014
			SELECT @v_dSql += N'													ON  A.SITE_ID          = C.SEGMENT2                                                                                                     ' + char(10)
			SELECT @v_dSql += N'													AND A.SHOP_GROUP_ID    = C.SEGMENT3                                                                                                     ' + char(10)
			SELECT @v_dSql += N'													AND A.DIVISION_ID      = C.SEGMENT5                                                                                                     ' + char(10)
			SELECT @v_dSql += N'													AND C.LOOKUP_TYPE_CODE = ''TARGET_INSTANCE''                                                                                            ' + char(10)
			SELECT @v_dSql += N'													AND C.SEGMENT1         = ''SCP SHIPPING TARGET''                                                                                        ' + char(10)
			SELECT @v_dSql += N'													AND C.ACTIVE_FLAG      = ''Y''                                                                                                          ' + char(10)
			SELECT @v_dSql += N'													AND C.SEGMENT4 		   = '''+ @p_master_id +'''                                                                                      ' + char(10)
			SELECT @v_dSql += N'											WHERE 1=1                                                                                                                               ' + char(10)
			--SELECT @v_dSql += N'											AND	EXISTS  (                                                                                                                           ' + char(10)
			--SELECT @v_dSql += N'														 SELECT 1                                                                                                                            ' + char(10)
			--SELECT @v_dSql += N'														 FROM (                                                                                                                              ' + char(10)
			--SELECT @v_dSql += N'																 SELECT DIVISION_ID, SITE_ID, A.SHOP_GROUP_ID, MAX(SCP_PLAN_ID) AS SCP_PLAN_ID                                                   ' + char(10)
			--SELECT @v_dSql += N'																 FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK)                                                                               ' + char(10)
			--SELECT @v_dSql += N'																	WHERE	 1=1			' + char(10)
			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			--SELECT @v_dSql += N'																     GROUP BY DIVISION_ID, SITE_ID, A.SHOP_GROUP_ID                                                                                  ' + char(10)
			--SELECT @v_dSql += N'																 ) AA                                                                                                                                ' + char(10)
			--SELECT @v_dSql += N'														 WHERE A.DIVISION_ID   = AA.DIVISION_ID                                                                                              ' + char(10)
			--SELECT @v_dSql += N'														 AND   A.SITE_ID       = AA.SITE_ID                                                                                                  ' + char(10)
			--SELECT @v_dSql += N'														 AND   A.SHOP_GROUP_ID = AA.SHOP_GROUP_ID                                                                                            ' + char(10)
			--SELECT @v_dSql += N'														 AND   A.SCP_PLAN_ID   = AA.SCP_PLAN_ID                                                                                              ' + char(10)
			--SELECT @v_dSql += N'														)                                                                                                                                       ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SELECT @v_dSql += N'											AND A.SHIP_QTY > 0                                                                                                                      ' + char(10)
			SELECT @v_dSql += N'							                AND CONVERT(VARCHAR, A.SHIP_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                      ' + char(10)
			SELECT @v_dSql += N'											AND EXISTS (                                                                                                                            ' + char(10)
			--SELECT @v_dSql += N'											    SELECT 1 FROM MAIN_P PP WITH(NOLOCK)' + char(10) -- fix remove 1014
			SELECT @v_dSql += N'											    SELECT 1 FROM #TEMP_TABLE_MAIN_P PP' + char(10) --fix add 1014
			SELECT @v_dSql += N'											    WHERE  A.COMPANY_ID  = PP.COMPANY_ID                                                                                                ' + char(10)
			SELECT @v_dSql += N'											    AND    A.DIVISION_ID = PP.DIVISION_ID                                                                                               ' + char(10)
			SELECT @v_dSql += N'											    AND    A.SITE_ID     = PP.SITE_ID                                                                                                   ' + char(10)
			SELECT @v_dSql += N'											    AND    A.ITEM_ID     = PP.TOP_ITEM_ID                                                                                               ' + char(10)
			SELECT @v_dSql += N'											)                                                                                                                                       ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql += N'	-- 계획 수립시점의 Shipment Plan                                                                                                                                ' + char(10)
			SELECT @v_dSql += N'												SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                           ' + char(10)
			SELECT @v_dSql += N'	  												 , A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.PLAN_DATE AS SHIP_DATE                                                   ' + char(10)
			SELECT @v_dSql += N'	  												 , ISNULL(A.SALES_QTY,0) AS SHIP_QTY                                                                            ' + char(10)
			SELECT @v_dSql += N'	  												 , 0 AS BOH_QTY                                                                                                 ' + char(10)
			SELECT @v_dSql += N'	  												 , 0 AS HOLD_QTY                                                                                                ' + char(10)
			SELECT @v_dSql += N'	  												 , 0 AS OUT_QTY                                                                                                 ' + char(10)
			SELECT @v_dSql += N'	  												 , 0 AS SHIP_SIMUL_QTY                                                                                          ' + char(10)
			SELECT @v_dSql += N'												FROM   '+ @p_amend_sales_table +' A WITH(NOLOCK)                                                               ' + char(10)
			SELECT @v_dSql += N'												WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                 ' + char(10)
			SELECT @v_dSql += N'												AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                   ' + char(10)
			SELECT @v_dSql += N'												AND	   CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                      ' + char(10)
			SELECT @v_dSql += N'												AND    ISNULL(A.SALES_QTY,0) > 0                                                                                    ' + char(10)
			SELECT @v_dSql += N'												AND    A.CATEGORY_ID = ''SHIPMENT''                                                                                 ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		END
		
		SELECT @v_dSql += N'							              	UNION ALL                                                                                                       ' + char(10)
		SELECT @v_dSql += N'							              	-- Plan(Out) 정보                                          ' + char(10)
		SELECT @v_dSql += N'											SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, (A.PLAN_DATE + 1) AS PLAN_DATE	' + char(10)
		SELECT @v_dSql += N'													, 0 AS SHIP_QTY                                                                                                         ' + char(10)
		SELECT @v_dSql += N'													, 0 AS BOH_QTY                                                                                                          ' + char(10)
		SELECT @v_dSql += N'													, 0 AS HOLD_QTY                                                                                                         ' + char(10)
		SELECT @v_dSql += N'													, A.OUT_QTY AS OUT_QTY                                                                                                  ' + char(10)
		SELECT @v_dSql += N'													, 0 AS SHIP_SIMUL_QTY                                                                                                 ' + char(10)
		SELECT @v_dSql += N'											FROM   '+ @p_amend_table +' A WITH(NOLOCK)																								' + char(10)
		SELECT @v_dSql += N'											WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                                             ' + char(10)
		SELECT @v_dSql += N'											AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                                               ' + char(10)
		SELECT @v_dSql += N'											AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +''' -- SSP EOH 계산시 과거계획수량 제외... 20191028     ' + char(10)
		SELECT @v_dSql += N'											AND    ISNULL(A.OUT_QTY,0) > 0                                                                                                  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'											AND    A.OPERATION_ID <> ''P5000''                                                                                              ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'							              	UNION ALL                                                                                                       ' + char(10)
		SELECT @v_dSql += N'							              	-- Shipment Plan(Simulation) 정보             ' + char(10)
		SELECT @v_dSql += N'											SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID		' + char(10)
  		SELECT @v_dSql += N'													, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.PLAN_DATE			' + char(10)
  		SELECT @v_dSql += N'													, 0 AS SHIP_QTY											' + char(10)
  		SELECT @v_dSql += N'													, 0 AS BOH_QTY											' + char(10)
  		SELECT @v_dSql += N'													, 0 AS HOLD_QTY											' + char(10)
  		SELECT @v_dSql += N'													, 0 AS OUT_QTY											' + char(10)
  		SELECT @v_dSql += N'													, A.SALES_QTY AS SHIP_SIMUL_QTY							' + char(10)
		SELECT @v_dSql += N'											FROM   '+ @p_amend_sales_table +' A WITH(NOLOCK)																								' + char(10)
		SELECT @v_dSql += N'											WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                                             ' + char(10)
		SELECT @v_dSql += N'											AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                                               ' + char(10)
		SELECT @v_dSql += N'											AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +'''     ' + char(10)
		SELECT @v_dSql += N'											AND    ISNULL(A.SALES_QTY,0) > 0                                                                                                  ' + char(10)
		SELECT @v_dSql += N'											AND    A.CATEGORY_ID = ''SHIPMENT_SIMUL''                                                                                 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'											-- Create 0                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'											UNION ALL                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'											SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE                                     ' + char(10)
		SELECT @v_dSql += N'											     , B.DT AS PLAN_DATE, 0 AS SHIP_QTY, 0 AS BOH_QTY, 0 AS HOLD_QTY, 0 AS OUT_QTY -- 데이터 없는 날짜구간 강제 생성            ' + char(10)
		SELECT @v_dSql += N'											     , 0 AS SHIP_SIMUL_QTY            ' + char(10)
		SELECT @v_dSql += N'											FROM (                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      											SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE                        ' + char(10)
		SELECT @v_dSql += N'  											FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                                                             ' + char(10)
		SELECT @v_dSql += N'  											WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''																		' + char(10)
		SELECT @v_dSql += N'  											AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                                       ' + char(10)
		SELECT @v_dSql += N'  											AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                           ' + char(10)
		SELECT @v_dSql += N'  											AND    ISNULL(A.OUT_QTY,0) > 0                                                                          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'  											AND    A.OPERATION_ID IN (''P9500'',''P5500'',''PL500'') -- 완성공정 기준                                         ' + char(10) --2026.08.10 kimcd [ES20260810] PL450 > PL500 공정 코드 변경.2026/06/08 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. Link 공정 추가
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'  									) A, TH_UIS_CAL B WITH(NOLOCK)                                                                                  ' + char(10)
		SELECT @v_dSql += N'  									WHERE B.YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                          ' + char(10)
		SELECT @v_dSql += N'								) A                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'								LEFT OUTER JOIN (                                                                                                   ' + char(10)
		SELECT @v_dSql += N'													SELECT DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, SUM(BOH_QTY) BOH_QTY, SUM(HOLD_QTY) HOLD_QTY    ' + char(10)
		--SELECT @v_dSql += N'													FROM SSP_BOH D WITH(NOLOCK)                                                                     ' + char(10) -- fix remove 1017
		SELECT @v_dSql += N'											FROM #TEMP_TABLE_SSP_BOH AS D' + char(10) -- fix add 1017
		SELECT @v_dSql += N'													GROUP BY DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID                                                ' + char(10)
		SELECT @v_dSql += N'											 ) D                                                                                                    ' + char(10)
		SELECT @v_dSql += N'								ON  A.DIVISION_ID 	= D.DIVISION_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'									AND A.SITE_ID 		= D.SITE_ID																					' + char(10)
		SELECT @v_dSql += N'									AND A.PLANT_ID 		= D.PLANT_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'									AND A.TOP_ITEM_ID	= D.ITEM_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'									WHERE 1=1                                                                                                       ' + char(10)
		SELECT @v_dSql += N'									GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, TOP_ITEM_ID, A.SHIP_DATE	--, A.PRODUCTION_TYPE, A.SHIP_DATE        ' + char(10)
		SELECT @v_dSql += N'					) A                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'					WHERE 1=1                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	      ) A                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	      INNER JOIN (                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	         SELECT 5 AS CATE_ORDER, ''Shipment Plan'' AS CATE_NAME, ''SSP'' AS CATE_ID                                                             ' + char(10)
		SELECT @v_dSql += N'	         UNION ALL                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	         SELECT 6 AS CATE_ORDER, ''Shipment Plan(Simulation)'' AS CATE_NAME, ''SSP_SIMUL'' AS CATE_ID             ' + char(10)
		SELECT @v_dSql += N'	         UNION ALL                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	         SELECT 50 AS CATE_ORDER, ''EOH(Shipment Plan)'' AS CATE_NAME, ''I_SSP'' AS CATE_ID                                                     ' + char(10)
		SELECT @v_dSql += N'	         UNION ALL                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	         SELECT 55 AS CATE_ORDER, ''EOH(Shipment Plan(Simulation))'' AS CATE_NAME, ''I_SSP_SIMUL'' AS CATE_ID				                    ' + char(10)
		SELECT @v_dSql += N'	      ) D                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	      ON    1=1                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	      INNER HASH JOIN (                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,                                                                               ' + char(10)
		SELECT @v_dSql += N'	                 A.ITEM_ID,                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	                 (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME                         ' + char(10)
		SELECT @v_dSql += N'	                 	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                                                  ' + char(10)
		SELECT @v_dSql += N'	                 	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,                                                                                 ' + char(10)
		SELECT @v_dSql += N'	                 ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME                              ' + char(10)
		SELECT @v_dSql += N'	          FROM	 SCM_ITEM_M A WITH(NOLOCK),                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	            	 SCM_ITEM_CLASS_M C WITH(NOLOCK)                                                                                                ' + char(10)
		SELECT @v_dSql += N'	          WHERE	 1=1                                                                                                                            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'	          AND	A.ITEM_CLASS  = C.CLASS_ID                                                                                                      ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'	      ) B                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	      ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	      AND A.DIVISION_ID = B.DIVISION_ID                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	      AND A.SITE_ID     = B.SITE_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	      AND A.TOP_ITEM_ID = B.ITEM_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	      INNER HASH JOIN (                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	          SELECT PP.COMPANY_ID, PP.DIVISION_ID, PP.SITE_ID, PP.TOP_ITEM_ID, MAX(PP.OPERATION_ID) AS OPERATION_ID                                ' + char(10)
		--SELECT @v_dSql += N'	          FROM   MAIN_P PP WITH(NOLOCK)' + char(10) -- fix remove 1014
		SELECT @v_dSql += N'	          FROM   #TEMP_TABLE_MAIN_P PP' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	          GROUP BY PP.COMPANY_ID, PP.DIVISION_ID, PP.SITE_ID, PP.TOP_ITEM_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'	      ) PP                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	      ON 	A.COMPANY_ID	= PP.COMPANY_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	      AND	A.DIVISION_ID 	= PP.DIVISION_ID                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	      AND	A.SITE_ID 		= PP.SITE_ID                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	      AND A.TOP_ITEM_ID 	= PP.TOP_ITEM_ID                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	      INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK)                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	        ON  1=1                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	        AND	A.SHIP_DATE    = G.DT                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, B.ITEM_TYPE, B.NICK_NAME, B.PJT_GROUP_NAME                    ' + char(10)
		SELECT @v_dSql += N'	      		 	 , CASE WHEN (D.CATE_ID = ''I_SSP'' OR D.CATE_ID = ''I_SSP_SIMUL'') THEN PP.OPERATION_ID ELSE NULL END                                                           ' + char(10)
		SELECT @v_dSql += N'	      			 , D.CATE_NAME, D.CATE_ID, D.CATE_ORDER                                                                                         ' + char(10)
		--SELECT @v_dSql += N'	  )' + char(10) -- fix remove 1017
		SELECT @v_dSql += N'	  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'	      , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME                                                    ' + char(10)
		SELECT @v_dSql += N'	      , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION                                                                                ' + char(10)
		SELECT @v_dSql += N'	      , A.BOH_QTY, A.SSP_BOH, A.SSP_HOLD, A.SSP_BOH_QTY                                                                         ' + char(10)
		SELECT @v_dSql += N'	      --, ''ZZZZZ'' AS PRODUCTION_TYPE, ''ZZZZZ'' AS MARKET                                                                     ' + char(10)
		SELECT @v_dSql += N'	      , (CASE WHEN A.PRODUCTION_TYPE = ''ZZZZZ'' THEN '''' ELSE A.PRODUCTION_TYPE END) AS PRODUCTION_TYPE                       ' + char(10)
		SELECT @v_dSql += N'	      , (CASE WHEN A.MARKET = ''ZZZZZ'' THEN '''' ELSE A.MARKET END) AS MARKET                                                  ' + char(10)
		SELECT @v_dSql += N'	      , A.PSI, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE                                                                         ' + char(10)
		SELECT @v_dSql += N'	      , A.CATE                                                                                                                  ' + char(10)
		
		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql += N'				, A.CATEGORY_ID, A.CATEGORY_ORDER, A.DATA_TYPE, S_ROW                                                               ' + char(10)
		SELECT @v_dSql += N'	      , DENSE_RANK() OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                       ' + char(10)
		SELECT @v_dSql += N'	                          ORDER BY     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID) AS LV1     ' + char(10)
		SELECT @v_dSql += N'	      , DENSE_RANK() OVER(ORDER BY A.FACTORY_ID, A.OPERATION_ID, A.TOP_ITEM_ID) AS LV2 -- 2nd OCV 용                            ' + char(10)
		SELECT @v_dSql += N'	      , DENSE_RANK() OVER(ORDER BY A.FACTORY_ID, A.TOP_ITEM_ID) AS LV3 -- boh_2nd 용                                            ' + char(10)
		
		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , C.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_MO ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'		   , CASE WHEN A.CATEGORY_ID = ''SSP_SIMUL'' THEN ''Y'' -- Shipment Plan(Simulation)                                                                       ' + char(10)
		SELECT @v_dSql += N'				  WHEN R.FACTORY_ID IS NULL THEN ''N''                                                                              ' + char(10)
		SELECT @v_dSql += N'				      WHEN RIGHT('''+ @p_plan_id +''',2) = ''00'' THEN ''N''                                                                                      ' + char(10)
		-- pack amend 완성공정 TEST 입력가능하도록 처리... 20241128
		--SELECT @v_dSql += N'		   		  WHEN (D.PRODUCTION_TYPE IS NULL OR (A.OPERATION_ID IN (''A3000'',''A9000'',''P5500'',''P9500'') AND A.PRODUCTION_TYPE = ''TEST'')) THEN ''N''              ' + char(10)
		SELECT @v_dSql += N'		          WHEN I.DIVISION_ID IS NOT NULL THEN ''Y''							' + char(10)
		SELECT @v_dSql += N'		          ELSE ''Y'' END AS EDIT_YN                                         ' + char(10)
		SELECT @v_dSql += N'		   , CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END AS ZERO_YN    ' + char(10)
		SELECT @v_dSql += N'	  FROM (                                                                        ' + char(10)
		--SELECT @v_dSql += N'	      SELECT * FROM SSP_INFO' + char(10) -- fix rem 1017
		SELECT @v_dSql += N'	      SELECT * FROM #TEMP_TABLE_SSP_INFO' + char(10)-- fix add 1017
		SELECT @v_dSql += @ssp_total
		SELECT @v_dSql += N'	      UNION ALL                                                                             ' + char(10)
		--SELECT @v_dSql += N'	      SELECT * FROM MAIN_S' + char(10)-- fix rem 1017
		SELECT @v_dSql += N'	      SELECT * FROM #TEMP_TABLE_MAIN_S' + char(10)-- fix add 1017
		SELECT @v_dSql += N'	      UNION ALL                                                                             ' + char(10)
		--SELECT @v_dSql += N'	      SELECT * FROM MAIN_P' + char(10) -- remove fix 1014
		SELECT @v_dSql += N'	      SELECT * FROM #TEMP_TABLE_MAIN_P' + char(10) -- fix added 1014
		SELECT @v_dSql += N'	      UNION ALL                                                                             ' + char(10)
		--SELECT @v_dSql += N'	      SELECT * FROM MAIN_I' + char(10)-- fix rem 1017
		SELECT @v_dSql += N'	      SELECT * FROM #TEMP_TABLE_MAIN_I' + char(10)-- fix add 1017
		SELECT @v_dSql += N'	      UNION ALL                                                                             ' + char(10)
		--SELECT @v_dSql += N'	      SELECT * FROM BOH_2ND' + char(10)-- fix rem 1017
		SELECT @v_dSql += N'	      SELECT * FROM #TEMP_TABLE_BOH_2ND' + char(10)-- fix add 1017
		SELECT @v_dSql += N'	      UNION ALL                                                                             ' + char(10)
		--SELECT @v_dSql += N'	      SELECT * FROM DO_INFO' + char(10)-- fix rem 1017
		SELECT @v_dSql += N'	      SELECT * FROM #TEMP_TABLE_DO_INFO' + char(10)-- fix add 1017
		SELECT @v_dSql += N'	      UNION ALL                                                                             ' + char(10)
		SELECT @v_dSql += N'	      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                             ' + char(10)
		SELECT @v_dSql += N'	           , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME           ' + char(10)
		SELECT @v_dSql += N'	           , A.OPERATION_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'	           , ''Total'' AS FACTORY_ID, NULL AS LOCATION                                      ' + char(10)
		SELECT @v_dSql += N'	           , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY                                            ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_BOH                                                                ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_HOLD                                                               ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_BOH_QTY                                                            ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS PRODUCTION_TYPE                                                        ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS MARKET                                                                 ' + char(10)
		SELECT @v_dSql += N'	           , A.PSI                                                                          ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS LINE_ID                                                                ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS LINE_NAME                                                              ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS ELECTRODE_TYPE                                                         ' + char(10)
		SELECT @v_dSql += N'	           , A.CATE                                                                         ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(M'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	           , ''S'' AS CATEGORY_ID, 400 AS CATEGORY_ORDER                                    ' + char(10)
		SELECT @v_dSql += N'	           , ''TOTAL'' AS DATA_TYPE                                                         ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS S_ROW                                                                  ' + char(10)
		--SELECT @v_dSql += N'	      FROM MAIN_S A' + char(10)-- fix rem 1017
		SELECT @v_dSql += N'	      FROM #TEMP_TABLE_MAIN_S A' + char(10)-- fix add 1017
		SELECT @v_dSql += @sub_total
		SELECT @v_dSql += N'	      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                           ' + char(10)
		SELECT @v_dSql += N'	             , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME         ' + char(10)
		SELECT @v_dSql += N'	             , A.OPERATION_ID                                                               ' + char(10)
		SELECT @v_dSql += N'	             , A.PSI, A.CATE                                                                ' + char(10)
		SELECT @v_dSql += N'	      UNION ALL                                                                             ' + char(10)
		--SELECT @v_dSql += N'	      SELECT * FROM MAIN_P_SUBT' + char(10)-- fix rem 1017
		--SELECT @v_dSql += N'	      SELECT * FROM #TABLE_TABLE_MAIN_P_SUBT' + char(10)-- fix add 1017
		SELECT @v_dSql += N'	      SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID, A.PLANT_ID' + char(10)
		SELECT @v_dSql += N', A.TOP_ITEM_ID,  A.ITEM_ID,A.ITEM_TYPE,  A.NICK_NAME,A.PJT_GROUP_NAME    ' +char(10)
	    SELECT @v_dSql += N', A.OPERATION_ID, A.FACTORY_ID,  ''-'' AS LOCATION' +char(10)
		SELECT @v_dSql += N', A.BOH_QTY, A.SSP_BOH,  A.SSP_HOLD,  A.SSP_BOH_QTY,  A.PRODUCTION_TYPE,  A.MARKET, A.PSI, A.LINE_ID,  A.LINE_NAME,  A.ELECTRODE_TYPE, A.CATE       ' +char(10)
		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N',A.M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) --+ char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N',A.W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) --+  char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += N', A.D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) --+ char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''
		SELECT @v_dSql += N', A.CATEGORY_ID, A.CATEGORY_ORDER , A.DATA_TYPE, A.S_ROW ' +char(10)
		SELECT @v_dSql += N'FROM #TABLE_TABLE_MAIN_P_SUBT A' + char(10)-- fix add 1017
		
		IF ISNULL(@p_cate_info,'') <> '' BEGIN
			SET @mst_loop_cnt	= 0
			WHILE @mst_loop_cnt < @max_category_loop_cnt
			BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info , @v_row_delimiter , @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column , @sub_v_delimiter)

				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_ID')   END
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_VALUE')   END

				IF @sub_param_0 = 'chk_total' AND @sub_param_1 = 'false' BEGIN
					SELECT @v_dSql += 'WHERE 1=0' +char(10)
					END
				ELSE IF @sub_param_0 = 'chk_total' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += 'WHERE 1=1' +char(10)
				END 

			END -- WHILE
		END -- IF ISNULL(@p_cate_info,'') 

		SELECT @v_dSql += N'	      UNION ALL                                                                             ' + char(10)
		SELECT @v_dSql += N'	      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                             ' + char(10)
		SELECT @v_dSql += N'	           , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME			' + char(10)
		SELECT @v_dSql += N'	           , A.OPERATION_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'	           , ''Total'' AS FACTORY_ID, NULL AS LOCATION                                      ' + char(10)
		SELECT @v_dSql += N'	           , SUM(A.BOH_QTY) AS  BOH_QTY                                                     ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_BOH                                                                ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_HOLD                                                               ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_BOH_QTY                                                            ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS PRODUCTION_TYPE                                                        ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS MARKET                                                                 ' + char(10)
		SELECT @v_dSql += N'	           , A.PSI                                                                          ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS LINE_ID                                                                ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS LINE_NAME                                                              ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS ELECTRODE_TYPE                                                         ' + char(10)
		SELECT @v_dSql += N'	           , A.CATE                                                                         ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	           , ''I'' AS CATEGORY_ID, 900 AS CATEGORY_ORDER                                    ' + char(10)
		SELECT @v_dSql += N'	           , ''TOTAL'' AS DATA_TYPE                                                         ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS S_ROW                                                                  ' + char(10)
		--SELECT @v_dSql += N'	      FROM MAIN_I A' + char(10)-- fix rem 1017
		SELECT @v_dSql += N'	      FROM #TEMP_TABLE_MAIN_I A' + char(10)-- fix add 1017
		SELECT @v_dSql += @sub_total
		SELECT @v_dSql += N'	      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                       ' + char(10)
		SELECT @v_dSql += N'	             , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME                                     ' + char(10)
		SELECT @v_dSql += N'	             , A.OPERATION_ID                                                                                           ' + char(10)
		SELECT @v_dSql += N'	             , A.CATEGORY_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'	             , A.PSI, A.CATE                                                                                            ' + char(10)
		SELECT @v_dSql += N'	      UNION ALL                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	      SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID                                 ' + char(10)
		SELECT @v_dSql += N'	           , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME    ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS OPERATION_ID                                                                                       ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS FACTORY_ID, NULL AS LOCATION                                                                       ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS BOH_QTY                                                                                            ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_BOH                                                                                            ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_HOLD                                                                                           ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_BOH_QTY                                                                                        ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS PRODUCTION_TYPE                                                                                    ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS MARKET                                                                                             ' + char(10)
		SELECT @v_dSql += N'	           , A.PSI                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS LINE_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS LINE_NAME                                                                                          ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS ELECTRODE_TYPE                                                                                     ' + char(10)
		SELECT @v_dSql += N'	           , A.CATE                                                                                                     ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(M'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	           , A.CATEGORY_ID                                                                                              ' + char(10)
		SELECT @v_dSql += N'	           , 550 AS CATEGORY_ORDER                                                                                      ' + char(10)
		SELECT @v_dSql += N'	           , ''TOTAL_2'' AS DATA_TYPE                                                                                   ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS S_ROW                                                                                              ' + char(10)
		--SELECT @v_dSql += N'	      FROM SSP_INFO A' + char(10)-- fix rem 1017
		SELECT @v_dSql += N'	      FROM #TEMP_TABLE_SSP_INFO A' + char(10)-- fix add 1017
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'	      GROUP BY A.PSI, A.CATE, A.CATEGORY_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'	      UNION ALL                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	      SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID                                 ' + char(10)
		SELECT @v_dSql += N'	           , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME    ' + char(10)
		SELECT @v_dSql += N'	           , A.OPERATION_ID AS OPERATION_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS FACTORY_ID, NULL AS LOCATION                                                                       ' + char(10)
		SELECT @v_dSql += N'	           , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY                                                                        ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_BOH                                                                                            ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_HOLD                                                                                           ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_BOH_QTY                                                                                        ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS PRODUCTION_TYPE                                                                                    ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS MARKET                                                                                             ' + char(10)
		SELECT @v_dSql += N'	           , A.PSI                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS LINE_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS LINE_NAME                                                                                          ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS ELECTRODE_TYPE                                                                                     ' + char(10)
		SELECT @v_dSql += N'	           , A.CATE                                                                                                     ' + char(10)
		
		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(M'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	           , A.CATEGORY_ID                                                                                              ' + char(10)
		SELECT @v_dSql += N'	           ,(	CASE WHEN A.CATEGORY_ID=''PAST_SALES'' THEN 100                                                         ' + char(10)
		SELECT @v_dSql += N'	           			 WHEN A.CATEGORY_ID=''SALES'' THEN 200                                                             	' + char(10) 	
		SELECT @v_dSql += N'	           			 ELSE 300 END) AS CATEGORY_ORDER                                                                    ' + char(10)
		SELECT @v_dSql += N'	           , ''TOTAL_2'' AS DATA_TYPE                                                                                   ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS S_ROW                                                                                              ' + char(10)
		--SELECT @v_dSql += N'	      FROM   MAIN_S A' + char(10)-- fix rem 1017
		SELECT @v_dSql += N'	      FROM   #TEMP_TABLE_MAIN_S A' + char(10)-- fix add 1017
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'	      GROUP BY A.OPERATION_ID, A.PSI, A.CATE, A.CATEGORY_ID                                                             ' + char(10)
		SELECT @v_dSql += N'	      UNION ALL                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	      SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID                                 ' + char(10)
		SELECT @v_dSql += N'	           , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME    ' + char(10)
		SELECT @v_dSql += N'	           , A.OPERATION_ID AS OPERATION_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS FACTORY_ID, NULL AS LOCATION                                                                       ' + char(10)
		SELECT @v_dSql += N'	           , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY                                                                        ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_BOH                                                                                            ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_HOLD                                                                                           ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_BOH_QTY                                                                                        ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS PRODUCTION_TYPE                                                                                    ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS MARKET                                                                                             ' + char(10)
		SELECT @v_dSql += N'	           , A.PSI                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS LINE_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS LINE_NAME                                                                                          ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS ELECTRODE_TYPE                                                                                     ' + char(10)
		SELECT @v_dSql += N'	           , A.CATE                                                                                                     ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(M'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	           , A.CATEGORY_ID, (	CASE WHEN A.CATEGORY_ID=''P_MPP_IN'' THEN 1000                                          ' + char(10)
		SELECT @v_dSql += N'	           							 WHEN A.CATEGORY_ID=''P_MPP_OUT'' THEN 2000                                         ' + char(10)
		SELECT @v_dSql += N'	           							 WHEN A.CATEGORY_ID=''P_WPP_IN'' THEN 3000                                          ' + char(10)
		SELECT @v_dSql += N'	           							 WHEN A.CATEGORY_ID=''P_WPP_OUT'' THEN 4000                                         ' + char(10)
		SELECT @v_dSql += N'	           							 WHEN A.CATEGORY_ID=''P_IN'' THEN 5000                                              ' + char(10)
		SELECT @v_dSql += N'	           							 WHEN A.CATEGORY_ID=''P_OUT'' THEN 6000                                             ' + char(10)
		SELECT @v_dSql += N'	           							 ELSE 7000 END) AS CATEGORY_ORDER                                                   ' + char(10)
		SELECT @v_dSql += N'	           , ''TOTAL_2'' AS DATA_TYPE, '''' AS S_ROW                                                                    ' + char(10)
		--SELECT @v_dSql += N'	      FROM MAIN_P_SUBT A' + char(10) -- fix rem 1017
		SELECT @v_dSql += N'	      FROM #TABLE_TABLE_MAIN_P_SUBT A' + char(10) -- fix add 1017
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'	      GROUP BY A.OPERATION_ID, A.PSI, A.CATE, A.CATEGORY_ID                                                             ' + char(10)
		SELECT @v_dSql += N'	      UNION ALL                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	      SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID                                 ' + char(10)
		SELECT @v_dSql += N'	           , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME    ' + char(10)
		SELECT @v_dSql += N'	           , A.OPERATION_ID AS OPERATION_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS FACTORY_ID, NULL AS LOCATION                                                                       ' + char(10)
		SELECT @v_dSql += N'	           , SUM(A.BOH_QTY) AS  BOH_QTY                                                                                 ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_BOH                                                                                            ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_HOLD                                                                                           ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS SSP_BOH_QTY                                                                                        ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS PRODUCTION_TYPE                                                                                    ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS MARKET                                                                                             ' + char(10)
		SELECT @v_dSql += N'	           , A.PSI                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS LINE_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS LINE_NAME                                                                                          ' + char(10)
		SELECT @v_dSql += N'	           , NULL AS ELECTRODE_TYPE                                                                                     ' + char(10)
		SELECT @v_dSql += N'	           , A.CATE                                                                                                     ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'           , A.CATEGORY_ID, 8000 AS CATEGORY_ORDER                                          ' + char(10)
		SELECT @v_dSql += N'           , ''TOTAL_2'' AS DATA_TYPE, '''' AS S_ROW                                        ' + char(10)
		--SELECT @v_dSql += N'      FROM   MAIN_I A' + char(10)-- fix rem 1017
		SELECT @v_dSql += N'      FROM   #TEMP_TABLE_MAIN_I A' + char(10) -- fix add 1017
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'      GROUP BY A.OPERATION_ID, A.PSI, A.CATE, A.CATEGORY_ID                                 ' + char(10)
		SELECT @v_dSql += N'    ) A                                                                                     ' + char(10)
		--SELECT @v_dSql += N'    LEFT OUTER JOIN T_MEMO C WITH(NOLOCK)' + char(10)-- fix rem 1017
		SELECT @v_dSql += N'    LEFT OUTER JOIN #TEMP_TABLE_T_MEMO AS C' + char(10)-- fix add 1017
		SELECT @v_dSql += N'    ON  A.COMPANY_ID      = C.COMPANY_ID                                                    ' + char(10)
		SELECT @v_dSql += N'    AND A.DIVISION_ID     = C.DIVISION_ID                                                   ' + char(10)
		SELECT @v_dSql += N'    AND A.SITE_ID         = C.SITE_ID                                                       ' + char(10)
		SELECT @v_dSql += N'    AND A.PLANT_ID        = C.PLANT_ID                                                      ' + char(10)
		SELECT @v_dSql += N'    AND A.FACTORY_ID      = C.FACTORY_ID                                                    ' + char(10)
		SELECT @v_dSql += N'    AND A.OPERATION_ID    = C.OPERATION_ID                                                  ' + char(10)
		SELECT @v_dSql += N'    AND A.LINE_ID         = C.LINE_ID                                                       ' + char(10)
		SELECT @v_dSql += N'    AND A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE                                                ' + char(10)
		SELECT @v_dSql += N'    AND A.PRODUCTION_TYPE = C.PRODUCTION_TYPE                                               ' + char(10)
		SELECT @v_dSql += N'    AND A.MARKET          = C.MARKET                                                        ' + char(10)
		SELECT @v_dSql += N'    AND A.TOP_ITEM_ID     = C.TOP_ITEM_ID                                                   ' + char(10)
		SELECT @v_dSql += N'    AND A.ITEM_ID         = C.ITEM_ID                                                       ' + char(10)
		SELECT @v_dSql += N'    LEFT OUTER JOIN                                                                         ' + char(10)
		SELECT @v_dSql += N'  	(                                                                                       ' + char(10)
		SELECT @v_dSql += N'        SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PRODUCTION_TYPE         ' + char(10)
		SELECT @v_dSql += N'        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)																												' + char(10)
		SELECT @v_dSql += N'	        WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''                                                                                                ' + char(10)
		SELECT @v_dSql += N'	        AND    A.ACTIVE_FLAG = ''Y''                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	  	) D                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	  	ON A.DIVISION_ID = D.DIVISION_ID                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	  	AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  	AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = D.PRODUCTION_TYPE      ' + char(10)
		SELECT @v_dSql += N'	    LEFT OUTER JOIN (                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	  			SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS SITE_ID, A.SEGMENT4 AS PLANT_ID, A.SEGMENT5 AS MODEL_ID     ' + char(10)
		SELECT @v_dSql += N'	  			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	  			WHERE  A.LOOKUP_TYPE_CODE = ''AMEND_VALIDATION_EXCEPTION''                                                                                      ' + char(10)
		SELECT @v_dSql += N'	  			AND    A.ACTIVE_FLAG      = ''Y''                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  			AND    A.SEGMENT1         = '''+ @p_master_id +'''                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		  ) I                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'		  ON  A.DIVISION_ID = I.DIVISION_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'		  AND A.SITE_ID     = I.SITE_ID                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		  AND A.PLANT_ID    = I.PLANT_ID                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		  AND A.TOP_ITEM_ID = I.MODEL_ID                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		  			LEFT OUTER JOIN (                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'							SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID                        ' + char(10)
		SELECT @v_dSql += N'							FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                          ' + char(10)
		SELECT @v_dSql += N'							WHERE	1=1                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'							AND		R.USER_ID	= '''+ @p_user_id +'''                                                                                                     ' + char(10)
		SELECT @v_dSql += N'							AND		R.SAVE_FLAG	= ''Y''                                                                                                         ' + char(10)
		SELECT @v_dSql += N'							AND		R.INSTANCE_ID = '''+ @p_master_id +'''                                                                                                 ' + char(10)
		SELECT @v_dSql += N'					) R                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'					ON		1=1                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'					AND		A.COMPANY_ID		= R.COMPANY_ID                                                                                                  ' + char(10)
		SELECT @v_dSql += N'					AND		A.DIVISION_ID		= R.DIVISION_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'					AND		A.SITE_ID			= R.SITE_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'					AND		A.PLANT_ID			= R.PLANT_ID                                                                                                    ' + char(10)
		SELECT @v_dSql += N'					AND		A.FACTORY_ID		= R.FACTORY_ID                                                                                                  ' + char(10)
		SELECT @v_dSql += N'					AND		A.OPERATION_ID		= R.OPERATION_ID                                                                                                ' + char(10)
		SELECT @v_dSql += N'					AND		A.LINE_ID			= R.LINE_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	    ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'	            ,ISNULL(A.OPERATION_ID,''ZZZZ'') DESC                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	            ,A.ITEM_ID, A.NICK_NAME                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	            ,A.ITEM_TYPE                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	            ,(CASE WHEN DATA_TYPE=''DATA'' THEN 1 ELSE 999 END)                                                                                             ' + char(10)
		SELECT @v_dSql += N'	            ,(CASE WHEN ( CATEGORY_ID=''I_SSP'' OR CATEGORY_ID=''I_SSP_SIMUL'' ) THEN 999 ELSE 1 END)                                                                                          ' + char(10)
		SELECT @v_dSql += N'	            ,A.FACTORY_ID, A.LOCATION                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	            ,(CASE WHEN CATEGORY_ID=''DO'' THEN 999 WHEN PSI=''I'' THEN 900 ELSE 1 END)                                                                     ' + char(10)
		SELECT @v_dSql += N'	            ,A.PRODUCTION_TYPE, A.MARKET                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	            ,(CASE WHEN CATEGORY_ID=''S'' THEN 1 ELSE 2 END)                                                                                                ' + char(10)
		SELECT @v_dSql += N'	            ,A.LINE_ID, A.ELECTRODE_TYPE, CATEGORY_ORDER                                                                                                    ' + char(10)
		
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

