
/*
 * Program ID   : PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK
 * Description  : Plan Amend By Line(Pack)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/05/12   CYS				Initial Release UI통합
 * 2022/08/31   CYS				속도개선
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK_NEW]
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

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK';
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

	-- week
	DECLARE @p_bucket		NVARCHAR(MAX);
	DECLARE @p_week_info	NVARCHAR(MAX);
	DECLARE @p_month_info	NVARCHAR(MAX);
	
	-- table
	DECLARE @p_amend_table	NVARCHAR(MAX);
	DECLARE @p_amend_sales_table		NVARCHAR(MAX);
	DECLARE @p_amend_cutoff_boh_table	NVARCHAR(MAX);
	DECLARE @p_amend_util_table	NVARCHAR(MAX);
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
	DECLARE @p_plan_type	NVARCHAR(MAX);

	-- week
	DECLARE @v_bucket		NVARCHAR(MAX);
	DECLARE @v_week_info	NVARCHAR(MAX);
	DECLARE @v_month_info	NVARCHAR(MAX);
	

	DECLARE @tmp_column		NVARCHAR(MAX);
	DECLARE @tmp_value		NVARCHAR(MAX);
	DECLARE @dbg_txt		NVARCHAR(MAX);
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
			SET @dbg_txt += @tmp_column
			SET @dbg_txt += @p_bucket_from
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
			SET @p_nick_name =			@tmp_value
		END ELSE IF @tmp_column = 'PROD_TYPE' BEGIN
			SET @p_prod_type =			@tmp_value
		END ELSE IF @tmp_column = 'PRODTYPE_ID' BEGIN
			SET @p_prod_type =			@tmp_value
		END ELSE IF @tmp_column = 'CELL_GROUP' BEGIN
			SET @p_cell_group =			@tmp_value
		END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
			SET @p_plan_type  =			@tmp_value

		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =				@tmp_value
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			@tmp_value
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			@tmp_value
			SET @dbg_txt += @tmp_column
			SET @dbg_txt += @p_month_info
		
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

	DECLARE @category_chk		integer = 0;
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
				SET @capa_total = 'WHERE 1=0' +char(10)
			END
			ELSE IF @sub_param_0 = 'chk_total' AND @sub_param_1 = 'true' BEGIN
				SET @sub_total = 'WHERE 1=1' +char(10)
				SET @capa_total = 'WHERE 1=1' +char(10)
			END 
			ELSE IF @sub_param_0 = 'chk_total_2' AND @sub_param_1 = 'false' BEGIN
				SET @total = 'WHERE 1=0' +char(10)
			END
			ELSE IF @sub_param_0 = 'chk_total_2' AND @sub_param_1 = 'true' BEGIN
				SET @total = 'WHERE 1=1' +char(10)
			END 
			ELSE IF @sub_param_0 = 'chk_capa' AND @sub_param_1 = 'false' BEGIN
				SET @capa_total = 'WHERE 1=0' +char(10)
			END
			ELSE IF @sub_param_0 = 'chk_capa' AND @sub_param_1 = 'true' BEGIN
				SET @capa_total = 'WHERE 1=1' +char(10)
			END 

		END -- WHILE
	END -- IF ISNULL(@p_cate_info,'') 
	
	
	BEGIN

		SET	@v_dSql = ''

		BEGIN

			SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#MAIN'') IS NOT NULL ' + char(10)
			SELECT @v_dSql += N'DROP TABLE #MAIN ' + char(10)

			SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#BOH_2ND'') IS NOT NULL  ' + char(10)
			SELECT @v_dSql += N'DROP TABLE #BOH_2ND ' + char(10)

			SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#CAPA_VALUE'') IS NOT NULL ' + char(10)
			SELECT @v_dSql += N'DROP TABLE #CAPA_VALUE ' + char(10)

			SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#T_MEMO'') IS NOT NULL ' + char(10)
			SELECT @v_dSql += N'DROP TABLE #T_MEMO ' + char(10)

		END


--if object_id('tempdb..#MAIN') is not null
--	drop table #MAIN

--	CREATE TABLE [dbo].#MAIN (
--	[COMPANY_ID] [nvarchar](30) NOT NULL,
--	[DIVISION_ID] [nvarchar](30) NOT NULL,
--	[SITE_ID] [nvarchar](30) NOT NULL,
--	[PLANT_ID] [nvarchar](30) NOT NULL,
--	[FACTORY_ID] [nvarchar](30) NOT NULL,
--	[LOCATION] [nvarchar](100)  NULL,
--	[OPERATION_ID] [nvarchar](30) NULL,
--	[LINE_ID] [nvarchar](30) NULL,
--	[LINE_NAME] [nvarchar](150) NOT NULL,
--	[ELECTRODE_TYPE] [nvarchar](50) NULL,
--	[EQUIPMENT_ID] [varchar](1) NOT NULL,
--	[ITEM_ID] [nvarchar](150) NOT NULL,
--	[TOP_ITEM_ID] [nvarchar](150) NOT NULL,
--	[NICK_NAME] [nvarchar](50) NOT NULL,
--	[PJT_GROUP_NAME] [nvarchar](200) NOT NULL,
--	[PRODUCTION_TYPE] [nvarchar](30) NOT NULL,
--	[MARKET] [nvarchar](30) NOT NULL,
--	[ITEM_TYPE] [nvarchar](150) NULL,
--	[CATE] [nvarchar](20) NOT NULL,
--	[M0_QTY] [numeric](38, 10) NULL,
--	[M0_COLOR] [varchar](20) NULL,
--	[M1_QTY] [numeric](38, 10) NULL,
--	[M1_COLOR] [varchar](20) NULL,
--	[W0_QTY] [numeric](38, 10) NULL,
--	[W0_COLOR] [varchar](20) NULL,
--	[W1_QTY] [numeric](38, 10) NULL,
--	[W1_COLOR] [varchar](20) NULL,
--	[W2_QTY] [numeric](38, 10) NULL,
--	[W2_COLOR] [varchar](20) NULL,
--	[W3_QTY] [numeric](38, 10) NULL,
--	[W3_COLOR] [varchar](20) NULL,
--	[D0_QTY] [numeric](38, 10) NULL,
--	[D0_COLOR] [varchar](20) NULL,
--	[D1_QTY] [numeric](38, 10) NULL,
--	[D1_COLOR] [varchar](20) NULL,
--	[D2_QTY] [numeric](38, 10) NULL,
--	[D2_COLOR] [varchar](20) NULL,
--	[D3_QTY] [numeric](38, 10) NULL,
--	[D3_COLOR] [varchar](20) NULL,
--	[D4_QTY] [numeric](38, 10) NULL,
--	[D4_COLOR] [varchar](20) NULL,
--	[D5_QTY] [numeric](38, 10) NULL,
--	[D5_COLOR] [varchar](20) NULL,
--	[D6_QTY] [numeric](38, 10) NULL,
--	[D6_COLOR] [varchar](20) NULL,
--	[D7_QTY] [numeric](38, 10) NULL,
--	[D7_COLOR] [varchar](20) NULL,
--	[D8_QTY] [numeric](38, 10) NULL,
--	[D8_COLOR] [varchar](20) NULL,
--	[D9_QTY] [numeric](38, 10) NULL,
--	[D9_COLOR] [varchar](20) NULL,
--	[D10_QTY] [numeric](38, 10) NULL,
--	[D10_COLOR] [varchar](20) NULL,
--	[D11_QTY] [numeric](38, 10) NULL,
--	[D11_COLOR] [varchar](20) NULL,
--	[D12_QTY] [numeric](38, 10) NULL,
--	[D12_COLOR] [varchar](20) NULL,
--	[D13_QTY] [numeric](38, 10) NULL,
--	[D13_COLOR] [varchar](20) NULL,
--	[D14_QTY] [numeric](38, 10) NULL,
--	[D14_COLOR] [varchar](20) NULL,
--	[D15_QTY] [numeric](38, 10) NULL,
--	[D15_COLOR] [varchar](20) NULL,
--	[D16_QTY] [numeric](38, 10) NULL,
--	[D16_COLOR] [varchar](20) NULL,
--	[D17_QTY] [numeric](38, 10) NULL,
--	[D17_COLOR] [varchar](20) NULL,
--	[D18_QTY] [numeric](38, 10) NULL,
--	[D18_COLOR] [varchar](20) NULL,
--	[D19_QTY] [numeric](38, 10) NULL,
--	[D19_COLOR] [varchar](20) NULL,
--	[D20_QTY] [numeric](38, 10) NULL,
--	[D20_COLOR] [varchar](20) NULL,
--	[D21_QTY] [numeric](38, 10) NULL,
--	[D21_COLOR] [varchar](20) NULL,
--	[D22_QTY] [numeric](38, 10) NULL,
--	[D22_COLOR] [varchar](20) NULL,
--	[D23_QTY] [numeric](38, 10) NULL,
--	[D23_COLOR] [varchar](20) NULL,
--	[D24_QTY] [numeric](38, 10) NULL,
--	[D24_COLOR] [varchar](20) NULL,
--	[D25_QTY] [numeric](38, 10) NULL,
--	[D25_COLOR] [varchar](20) NULL,
--	[D26_QTY] [numeric](38, 10) NULL,
--	[D26_COLOR] [varchar](20) NULL,
--	[D27_QTY] [numeric](38, 10) NULL,
--	[D27_COLOR] [varchar](20) NULL,
--	[CATEGORY_ID] [varchar](17) NOT NULL,
--	[CATEGORY_ORDER] [int] NOT NULL,
--	[DATA_TYPE] [varchar](4) NOT NULL
--   ) 



		--SELECT @v_dSql += N'	WITH MAIN AS (         																																		' + char(10)																			
		--SELECT @v_dSql += N'					insert into #MAIN                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'					SELECT 	A.*                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'					INTO	#MAIN                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'					FROM 	(                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'						      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                           ' + char(10)
		SELECT @v_dSql += N'						           , A.LOCATION, A.OPERATION_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'						           , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE                                                                                   ' + char(10)
		SELECT @v_dSql += N'						           , A.EQUIPMENT_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'						           , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME                                                                    ' + char(10)
		SELECT @v_dSql += N'						           , A.PRODUCTION_TYPE, A.MARKET                                                                                                ' + char(10)
		SELECT @v_dSql += N'						           , A.ITEM_TYPE                                                                                                                ' + char(10)
		SELECT @v_dSql += N'						           , B.CATEGORY_NAME AS CATE                                                                                                    ' + char(10)

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

					SELECT @v_dSql += N'				, SUM(CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' THEN ( CASE WHEN B.CATEGORY_ID=''P_IN'' THEN A.IN_QTY    ' + char(10)
					SELECT @v_dSql += N'				                                                 				WHEN B.CATEGORY_ID=''P_OUT'' THEN A.OUT_QTY           ' + char(10)
					SELECT @v_dSql += N'				                                                   				WHEN B.CATEGORY_ID=''W_IN'' THEN A.WPP_IN_QTY        ' + char(10)
					SELECT @v_dSql += N'																				WHEN B.CATEGORY_ID=''W_OUT'' THEN A.WPP_OUT_QTY        ' + char(10)
					SELECT @v_dSql += N'				                                                   				WHEN B.CATEGORY_ID=''M_IN'' THEN A.MPP_IN_QTY        ' + char(10)
					SELECT @v_dSql += N'																				WHEN B.CATEGORY_ID=''M_OUT'' THEN A.MPP_OUT_QTY        ' + char(10)
					SELECT @v_dSql += N'																				WHEN B.CATEGORY_ID=''RESULT'' THEN A.RESULT_QTY        ' + char(10)
					SELECT @v_dSql += N'				                                             		ELSE 0 END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY  ' + char(10)
					SELECT @v_dSql += N'				, '''' AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR  ' + char(10)
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

					SELECT @v_dSql += N'				, SUM(CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN ( CASE WHEN B.CATEGORY_ID=''P_IN'' THEN A.IN_QTY          ' + char(10)
					SELECT @v_dSql += N'				                                                 					WHEN B.CATEGORY_ID=''P_OUT'' THEN A.OUT_QTY           ' + char(10)
					SELECT @v_dSql += N'				                                                   					WHEN B.CATEGORY_ID=''W_IN'' THEN A.WPP_IN_QTY        ' + char(10)
					SELECT @v_dSql += N'																					WHEN B.CATEGORY_ID=''W_OUT'' THEN A.WPP_OUT_QTY        ' + char(10)
					SELECT @v_dSql += N'				                                                   					WHEN B.CATEGORY_ID=''M_IN'' THEN A.MPP_IN_QTY        ' + char(10)
					SELECT @v_dSql += N'																					WHEN B.CATEGORY_ID=''M_OUT'' THEN A.MPP_OUT_QTY        ' + char(10)
					SELECT @v_dSql += N'																					WHEN B.CATEGORY_ID=''RESULT'' THEN A.RESULT_QTY        ' + char(10)
					SELECT @v_dSql += N'				                                             			ELSE 0 END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY  ' + char(10)
					SELECT @v_dSql += N'				, '''' AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR  ' + char(10)
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

					SELECT @v_dSql += N'				, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = '''+ @sub_param_0 +''' THEN ( CASE WHEN B.CATEGORY_ID=''P_IN'' THEN A.IN_QTY          ' + char(10)
					SELECT @v_dSql += N'				                                                 					WHEN B.CATEGORY_ID=''P_OUT'' THEN A.OUT_QTY           ' + char(10)
					SELECT @v_dSql += N'				                                                   					WHEN B.CATEGORY_ID=''W_IN'' THEN A.WPP_IN_QTY        ' + char(10)
					SELECT @v_dSql += N'																					WHEN B.CATEGORY_ID=''W_OUT'' THEN A.WPP_OUT_QTY        ' + char(10)
					SELECT @v_dSql += N'				                                                   					WHEN B.CATEGORY_ID=''M_IN'' THEN A.MPP_IN_QTY        ' + char(10)
					SELECT @v_dSql += N'																					WHEN B.CATEGORY_ID=''M_OUT'' THEN A.MPP_OUT_QTY        ' + char(10)
					SELECT @v_dSql += N'																					WHEN B.CATEGORY_ID=''RESULT'' THEN A.RESULT_QTY        ' + char(10)
					SELECT @v_dSql += N'				                                             			ELSE 0 END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY  ' + char(10)
					SELECT @v_dSql += N'				, '''' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR  ' + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'					    			 , B.CATEGORY_ID, B.CATEGORY_ORDER                                                                                          ' + char(10)
		SELECT @v_dSql += N'					           		, ''DATA'' AS DATA_TYPE                                                                                                     ' + char(10)
		SELECT @v_dSql += N'					      	FROM 	(                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'										SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                ' + char(10)
		SELECT @v_dSql += N'												, A.LOCATION, A.OPERATION_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'												, A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE                                           ' + char(10)
		SELECT @v_dSql += N'												, A.EQUIPMENT_ID                                                                                                ' + char(10)
		SELECT @v_dSql += N'												, A.PLAN_DATE                                                                                                   ' + char(10)
		SELECT @v_dSql += N'												, A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME, ISNULL(B.PJT_GROUP_NAME,''-'') AS PJT_GROUP_NAME                   ' + char(10)
		SELECT @v_dSql += N'												, A.PRODUCTION_TYPE                                                                                             ' + char(10)
		SELECT @v_dSql += N'												, A.MARKET                                                                                                      ' + char(10)
		SELECT @v_dSql += N'												, B.ITEM_TYPE                                                                                                   ' + char(10)
		SELECT @v_dSql += N'												, A.PLAN_TYPE                                                                                                   ' + char(10)
		SELECT @v_dSql += N'												, A.SEQ                                                                                                         ' + char(10)
		SELECT @v_dSql += N'												, A.IN_QTY                                                                                                      ' + char(10)
		SELECT @v_dSql += N'												, A.OUT_QTY                                                                                                     ' + char(10)
		SELECT @v_dSql += N'												, A.RESULT_QTY                                                                                                  ' + char(10)
		SELECT @v_dSql += N'				          						, A.MPP_IN_QTY, A.MPP_OUT_QTY                                                                                   ' + char(10)
		SELECT @v_dSql += N'				          						, A.WPP_IN_QTY, A.WPP_OUT_QTY                                                                                   ' + char(10)
		SELECT @v_dSql += N'					           			FROM 	(                                                                                                               ' + char(10)
		SELECT @v_dSql += N'						               				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                     ' + char(10)
		SELECT @v_dSql += N'										                   , A.LOCATION, A.OPERATION_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'										                   , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE                                                     ' + char(10)
		SELECT @v_dSql += N'										                   , '''' AS EQUIPMENT_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'										                   , A.PLAN_DATE                                                                                        ' + char(10)
		SELECT @v_dSql += N'										                   , A.TOP_ITEM_ID, A.ITEM_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'										                   , A.PRODUCTION_TYPE                                                                                  ' + char(10)
		SELECT @v_dSql += N'										                   , A.MARKET                                                                                           ' + char(10)
		SELECT @v_dSql += N'										                   , ''DPP'' AS PLAN_TYPE                                                                               ' + char(10)
		SELECT @v_dSql += N'								                           , DATE_SEQ AS SEQ                                                                                    ' + char(10)
		SELECT @v_dSql += N'								                           , A.IN_QTY                                                                                           ' + char(10)
		SELECT @v_dSql += N'								                           , A.OUT_QTY                                                                                          ' + char(10)
		SELECT @v_dSql += N'								                           , A.RESULT_OUT_QTY AS RESULT_QTY                                                                     ' + char(10)
		SELECT @v_dSql += N'	          									 		   , A.MPP_IN_QTY, A.MPP_OUT_QTY                                                                        ' + char(10)
		SELECT @v_dSql += N'	          									 		   , A.WPP_IN_QTY, A.WPP_OUT_QTY                                                                        ' + char(10)
		SELECT @v_dSql += N'							              			FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                                         ' + char(10)
		SELECT @v_dSql += N'													WHERE  INSTANCE_ID      = '''+ @p_instance_id +'''                                                          ' + char(10)
		SELECT @v_dSql += N'													AND    FP_PLAN_ID       = '''+ @p_plan_id +'''                                                              ' + char(10)
		--SELECT @v_dSql += N'													AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''       ' + char(10)
		SELECT @v_dSql += N'													AND    A.PLAN_DATE BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''       ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'													AND    (A.OUT_QTY > 0 OR A.MPP_OUT_QTY > 0 OR A.WPP_OUT_QTY > 0 OR A.RESULT_OUT_QTY > 0)                    ' + char(10)
		SELECT @v_dSql += N'												) A                                                                                                             ' + char(10)
		SELECT @v_dSql += N'								      			INNER JOIN (                                                                                                    ' + char(10)
		SELECT @v_dSql += N'									                          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,                                           ' + char(10)
		SELECT @v_dSql += N'									                                 A.ITEM_ID,                                                                                 ' + char(10)
		SELECT @v_dSql += N'									                                 (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME            ' + char(10)
		SELECT @v_dSql += N'									                                 	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')              ' + char(10)
		SELECT @v_dSql += N'									                                 	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,                                             ' + char(10)
		SELECT @v_dSql += N'									                                 ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME                 ' + char(10)
		SELECT @v_dSql += N'									                          FROM	 SCM_ITEM_M A WITH(NOLOCK),                                                                 ' + char(10)
		SELECT @v_dSql += N'									                            		 SCM_ITEM_CLASS_M C WITH(NOLOCK)                                                        ' + char(10)
		SELECT @v_dSql += N'									                          WHERE	 A.ITEM_CLASS  = C.CLASS_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'																AND 	A.ACTIVE_FLAG = ''Y''															' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'														) B                                                                                                     ' + char(10)
		SELECT @v_dSql += N'												ON     A.COMPANY_ID     = B.COMPANY_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'												AND    A.DIVISION_ID    = B.DIVISION_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'												AND    A.SITE_ID        = B.SITE_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'												AND    A.TOP_ITEM_ID    = B.ITEM_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'												INNER JOIN SCM_LINE_M C WITH(NOLOCK)                                                                            ' + char(10)
		SELECT @v_dSql += N'												ON     A.COMPANY_ID     = C.COMPANY_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'												AND    A.DIVISION_ID    = C.DIVISION_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'												AND    A.SITE_ID        = C.SITE_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'												AND    A.PLANT_ID       = C.PLANT_ID                                                                            ' + char(10)
		SELECT @v_dSql += N'												AND    A.FACTORY_ID     = C.FACTORY_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'												AND    A.OPERATION_ID   = C.OPERATION_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'												AND    A.LINE_ID        = C.LINE_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'				              					AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE                                                                      ' + char(10)
		SELECT @v_dSql += N'										WHERE 1=1                                                                                                               ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'									) A                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'			          				INNER JOIN (                                                                                                                ' + char(10)
		--SELECT @v_dSql += N'			          				cross JOIN (                                                                                                                ' + char(10)
		SELECT @v_dSql += N'			          								SELECT 	*                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			          								FROM 	(                                                                                                   ' + char(10)

		IF ISNULL(@p_cate_info,'') <> '' BEGIN

			SELECT @v_dSql += N'	SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER '+char(10)

			SET @mst_loop_cnt	= 0 ;
			
  			WHILE @mst_loop_cnt < @max_category_loop_cnt
				BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
				SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가
				SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info , @v_row_delimiter , @mst_loop_cnt );
				
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column , @sub_v_delimiter)

				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_ID')   END
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_VALUE')   END
				
				-- 화면에서 mpp/wpp category 를 하나만 선택했을 경우 다른 category 값을 알 수 없어 쌍으로 다니도록 변경

				IF @sub_param_0 = 'chk_mpp_inqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER '+char(10)
				END ELSE IF (@sub_param_0 = 'chk_mpp_outqty' AND @sub_param_1 = 'true') OR ( @sub_param_0 = 'chk_wpp_outqty' AND @sub_param_1 = 'true' )  BEGIN
					IF @category_chk = 0 BEGIN
						SELECT @v_dSql += N'    UNION ALL '+char(10)
						SELECT @v_dSql += N'    SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER '+char(10)
						SELECT @v_dSql += N'    UNION ALL '+char(10)
						SELECT @v_dSql += N'    SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER '+char(10)
					END
					SET @category_chk = @category_chk+1
				END ELSE IF @sub_param_0 = 'chk_wpp_inqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER '+char(10)
				END ELSE IF @sub_param_0 = 'chk_inqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER '+char(10)
				END ELSE IF @sub_param_0 = 'chk_outqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER '+char(10)
				END ELSE IF @sub_param_0 = 'chk_result' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER '+char(10)
				END 

				/*
				IF @sub_param_0 = 'chk_mpp_inqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER '+char(10)
				END ELSE IF @sub_param_0 = 'chk_mpp_outqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER '+char(10)
				END ELSE IF @sub_param_0 = 'chk_wpp_inqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER '+char(10)
				END ELSE IF @sub_param_0 = 'chk_wpp_outqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER '+char(10)
				END ELSE IF @sub_param_0 = 'chk_inqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER '+char(10)
				END ELSE IF @sub_param_0 = 'chk_outqty' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER '+char(10)
				END ELSE IF @sub_param_0 = 'chk_result' AND @sub_param_1 = 'true' BEGIN
					SELECT @v_dSql += N'    UNION ALL '+char(10)
					SELECT @v_dSql += N'    SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER '+char(10)
				END 
				*/

			END	-- END OF WHILE

		END ELSE BEGIN
			-- CATEGORY 정보 없는 경우임
			SELECT @v_dSql += N'	SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER				       ' + char(10)
			SELECT @v_dSql += N'	UNION ALL                                                                                              ' + char(10)
			SELECT @v_dSql += N'	SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER                   ' + char(10)
			SELECT @v_dSql += N'	UNION ALL                                                                                              ' + char(10)
			SELECT @v_dSql += N'	SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER                     ' + char(10)
			SELECT @v_dSql += N'	UNION ALL                                                                                              ' + char(10)
			SELECT @v_dSql += N'	SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER                   ' + char(10)
			SELECT @v_dSql += N'	UNION ALL                                                                                              ' + char(10)
			SELECT @v_dSql += N'	SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER                    ' + char(10)
			SELECT @v_dSql += N'	UNION ALL                                                                                              ' + char(10)
			SELECT @v_dSql += N'	SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER                  ' + char(10)
			SELECT @v_dSql += N'	UNION ALL                                                                                              ' + char(10)
			SELECT @v_dSql += N'	SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER                    ' + char(10)
		END	
		SELECT @v_dSql += N'    UNION ALL '+char(10)
		SELECT @v_dSql += N'    SELECT ''P_MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER '+char(10)

		SELECT @v_dSql += N'					          								) BB                                                                                                ' + char(10)
		SELECT @v_dSql += N'	                								WHERE CATEGORY_ID <> ''X''                                                                                  ' + char(10)
		SELECT @v_dSql += N'			          							) B                                                                                                             ' + char(10)
		SELECT @v_dSql += N'												ON 1=1                                                                                                          ' + char(10)
--		SELECT @v_dSql += N'												INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                       ' + char(10)
		SELECT @v_dSql += N'												INNER JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                       ' + char(10)
		SELECT @v_dSql += N'												ON  A.PLAN_DATE = C.DT                                                                                          ' + char(10)
		SELECT @v_dSql += N'									GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                   ' + char(10)
		SELECT @v_dSql += N'											, A.LOCATION, A.OPERATION_ID                                                                                        ' + char(10)
		SELECT @v_dSql += N'											, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE                                                                          ' + char(10)
		SELECT @v_dSql += N'											, A.EQUIPMENT_ID                                                                                                    ' + char(10)
		SELECT @v_dSql += N'											, A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME                                                           ' + char(10)
		SELECT @v_dSql += N'											, A.PRODUCTION_TYPE, A.MARKET, A.ITEM_TYPE                                                                          ' + char(10)
		SELECT @v_dSql += N'											, B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER                                                                  ' + char(10)
		SELECT @v_dSql += N'		    					) A                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'		    			WHERE	1 = 1                                                                                                                           ' + char(10)
		--SELECT @v_dSql += N'				)	-- WITH AS END                                                                                                                              ' + char(10)


--if object_id('tempdb..#CAPA_VALUE') is not null
--	drop table #CAPA_VALUE







		--SELECT @v_dSql += N'	, CAPA_VALUE AS (                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'			      		SELECT 	*                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'			      		into #CAPA_VALUE                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'			      		FROM	(                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'					  		         SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, NULL AS EQUIPMENT_ID, A.ELECTRODE_TYPE                 ' + char(10)
		SELECT @v_dSql += N'							               , '''+ @p_bucket_from +''' AS PLAN_DATE                                                                                         ' + char(10)
		SELECT @v_dSql += N'							               , NULL AS OFF_TIME                                                                                                   ' + char(10)
		SELECT @v_dSql += N'							               , NULL AS SETUP_TIME                                                                                                 ' + char(10)
		SELECT @v_dSql += N'							               , NULL AS UTILIZATION                                                                                                ' + char(10)
		SELECT @v_dSql += N'							          FROM    '+ @p_amend_table +' A WITH(NOLOCK)                                                                                      ' + char(10)
		SELECT @v_dSql += N'									          INNER hash JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                              ' + char(10)
		SELECT @v_dSql += N'									          ON     A.COMPANY_ID     = B.COMPANY_ID                                                                            ' + char(10)
		SELECT @v_dSql += N'									          AND    A.DIVISION_ID    = B.DIVISION_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'									          AND    A.SITE_ID        = B.SITE_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'									          AND    A.ITEM_ID        = B.ITEM_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'							          WHERE  INSTANCE_ID      = '''+ @p_instance_id +'''                                                                        ' + char(10)
		SELECT @v_dSql += N'							          AND    FP_PLAN_ID       = '''+ @p_plan_id +'''                                                                            ' + char(10)
		SELECT @v_dSql += N'							          AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'EQ', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'									GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE                 ' + char(10)
		SELECT @v_dSql += N'									UNION ALL                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'									SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, NULL AS EQUIPMENT_ID, A.ELECTRODE_TYPE                  ' + char(10)
		SELECT @v_dSql += N'											, CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE                                                                   ' + char(10)
		SELECT @v_dSql += N'											, SUM(A.OFF_TIME) AS OFF_TIME                                                                                       ' + char(10)
		SELECT @v_dSql += N'											, SUM(A.SETUP_TIME) AS SETUP_TIME                                                                                   ' + char(10)
		SELECT @v_dSql += N'											, AVG(A.UTILIZATION) AS UTILIZATION                                                                                 ' + char(10)
		SELECT @v_dSql += N'									FROM   '+ @p_amend_util_table +' A WITH(NOLOCK)                                                                             ' + char(10)
		SELECT @v_dSql += N'									WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                             ' + char(10)
		SELECT @v_dSql += N'									AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                                 ' + char(10)
		SELECT @v_dSql += N'									AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                       ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'									AND    EXISTS (                                                                                                             ' + char(10)
		SELECT @v_dSql += N'										              SELECT 1                                                                                                  ' + char(10)
		SELECT @v_dSql += N'										              FROM   '+ @p_amend_table +' AAA WITH(NOLOCK), SCM_ITEM_M BBB WITH(NOLOCK)                                        ' + char(10)
		SELECT @v_dSql += N'										              WHERE  AAA.COMPANY_ID   = BBB.COMPANY_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'										              AND    AAA.DIVISION_ID  = BBB.DIVISION_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'										              AND    AAA.SITE_ID      = BBB.SITE_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'										              AND    AAA.ITEM_ID      = BBB.ITEM_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'										              AND    A.COMPANY_ID     = AAA.COMPANY_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'										              AND    A.DIVISION_ID    = AAA.DIVISION_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'										              AND    A.SITE_ID        = AAA.SITE_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'										              AND    A.PLANT_ID       = AAA.PLANT_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'										              AND    A.FACTORY_ID     = AAA.FACTORY_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'										              AND    A.LOCATION       = AAA.LOCATION                                                                    ' + char(10)
		SELECT @v_dSql += N'										              AND    A.OPERATION_ID   = AAA.OPERATION_ID                                                                ' + char(10)
		SELECT @v_dSql += N'										              AND    A.LINE_ID        = AAA.LINE_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'										              AND    A.ELECTRODE_TYPE = AAA.ELECTRODE_TYPE                                                              ' + char(10)
		SELECT @v_dSql += N'										              --AND    A.EQUIPMENT_ID   = AAA.EQUIPMENT_ID                                                              ' + char(10)
		SELECT @v_dSql += N'										              AND    CONVERT(VARCHAR, AAA.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''   ' + char(10)
		SELECT @v_dSql += N'										              AND    AAA.INSTANCE_ID  = '''+ @p_instance_id +'''                                                        ' + char(10)
		SELECT @v_dSql += N'										              AND    AAA.FP_PLAN_ID   = '''+ @p_plan_id +'''                                                            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('BBB.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('BBB.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'			          							)                                                                                                               ' + char(10)
		SELECT @v_dSql += N'							          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE                    ' + char(10)
		SELECT @v_dSql += N'							                 , CONVERT(VARCHAR, A.PLAN_DATE, 112)                                                                               ' + char(10)
		SELECT @v_dSql += N'			       				) A                                                                                                                             ' + char(10)
		SELECT @v_dSql += @sub_total
		--SELECT @v_dSql += N'	      		)	-- capa with end                                                                                                                            ' + char(10)

--if object_id('tempdb..#T_MEMO') is not null
--	drop table #T_MEMO








		--SELECT @v_dSql += N'	      , T_MEMO AS (                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                             ' + char(10)
		SELECT @v_dSql += N'							       , A.OPERATION_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'							       , A.LINE_ID, A.ELECTRODE_TYPE                                                                                                ' + char(10)
		SELECT @v_dSql += N'							       , A.EQUIPMENT_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'							       , A.ITEM_ID, A.TOP_ITEM_ID                                                                                                   ' + char(10)
		SELECT @v_dSql += N'							       , A.PRODUCTION_TYPE, A.MARKET                                                                                                ' + char(10)
		
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
					
					SELECT @v_dSql += N'						, MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = '''+ @sub_param_0 +''' AND A.MEMO IS NOT NULL THEN ''Y'' ELSE NULL END) AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +'_MO  ' + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt
			
			END --end of @max_loop_cnt

		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'							into #T_MEMO                                                                                                ' + char(10)
		SELECT @v_dSql += N'							FROM FP_AMEND_MEMO_M A WITH(NOLOCK)                                                                                                 ' + char(10)
		SELECT @v_dSql += N'							WHERE 1=1                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'							AND    A.INSTANCE_ID  = '''+ @p_instance_id +'''                                                                                    ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                           ' + char(10)
		SELECT @v_dSql += N'								, A.OPERATION_ID                                                                                                                ' + char(10)
		SELECT @v_dSql += N'								, A.LINE_ID, A.ELECTRODE_TYPE                                                                                                   ' + char(10)
		SELECT @v_dSql += N'								, A.EQUIPMENT_ID                                                                                                                ' + char(10)
		SELECT @v_dSql += N'								, A.ITEM_ID, A.TOP_ITEM_ID                                                                                                      ' + char(10)
		SELECT @v_dSql += N'								, A.PRODUCTION_TYPE, A.MARKET                                                                                                   ' + char(10)
		--SELECT @v_dSql += N'	      	) -- memo with end                                                                                                                                  ' + char(10)


--if object_id('tempdb..#BOH_2ND') is not null
--	drop table #BOH_2ND

--		CREATE TABLE [dbo].#BOH_2ND (
--	[COMPANY_ID] [nvarchar](30) NOT NULL,
--	[DIVISION_ID] [nvarchar](30) NOT NULL,
--	[SITE_ID] [nvarchar](30) NOT NULL,
--	[PLANT_ID] [nvarchar](30) NOT NULL,
--	[FACTORY_ID] [nvarchar](30) NOT NULL,
--	[LOCATION] [nvarchar](100) NULL,
--	[OPERATION_ID] [nvarchar](30) NULL,
--	[LINE_ID] [nvarchar](30) NULL,
--	[LINE_NAME] [nvarchar](150) NOT NULL,
--	[ELECTRODE_TYPE] [nvarchar](50) NULL,
--	[EQUIPMENT_ID] [varchar](1) NOT NULL,
--	[ITEM_ID] [nvarchar](150) NOT NULL,
--	[TOP_ITEM_ID] [nvarchar](150) NOT NULL,
--	[NICK_NAME] [nvarchar](50) NOT NULL,
--	[PJT_GROUP_NAME] [nvarchar](200) NOT NULL,
--	[PRODUCTION_TYPE] [nvarchar](30) NOT NULL,
--	[MARKET] [nvarchar](30) NOT NULL,
--	[ITEM_TYPE] [nvarchar](150) NULL,
--	[CATE] [nvarchar](20) NOT NULL,
--	[M0_QTY] [numeric](38, 10) NULL,
--	[M0_COLOR] [varchar](20) NULL,
--	[M1_QTY] [numeric](38, 10) NULL,
--	[M1_COLOR] [varchar](20) NULL,
--	[W0_QTY] [numeric](38, 10) NULL,
--	[W0_COLOR] [varchar](20) NULL,
--	[W1_QTY] [numeric](38, 10) NULL,
--	[W1_COLOR] [varchar](20) NULL,
--	[W2_QTY] [numeric](38, 10) NULL,
--	[W2_COLOR] [varchar](20) NULL,
--	[W3_QTY] [numeric](38, 10) NULL,
--	[W3_COLOR] [varchar](20) NULL,
--	[D0_QTY] [numeric](38, 10) NULL,
--	[D0_COLOR] [varchar](20) NULL,
--	[D1_QTY] [numeric](38, 10) NULL,
--	[D1_COLOR] [varchar](20) NULL,
--	[D2_QTY] [numeric](38, 10) NULL,
--	[D2_COLOR] [varchar](20) NULL,
--	[D3_QTY] [numeric](38, 10) NULL,
--	[D3_COLOR] [varchar](20) NULL,
--	[D4_QTY] [numeric](38, 10) NULL,
--	[D4_COLOR] [varchar](20) NULL,
--	[D5_QTY] [numeric](38, 10) NULL,
--	[D5_COLOR] [varchar](20) NULL,
--	[D6_QTY] [numeric](38, 10) NULL,
--	[D6_COLOR] [varchar](20) NULL,
--	[D7_QTY] [numeric](38, 10) NULL,
--	[D7_COLOR] [varchar](20) NULL,
--	[D8_QTY] [numeric](38, 10) NULL,
--	[D8_COLOR] [varchar](20) NULL,
--	[D9_QTY] [numeric](38, 10) NULL,
--	[D9_COLOR] [varchar](20) NULL,
--	[D10_QTY] [numeric](38, 10) NULL,
--	[D10_COLOR] [varchar](20) NULL,
--	[D11_QTY] [numeric](38, 10) NULL,
--	[D11_COLOR] [varchar](20) NULL,
--	[D12_QTY] [numeric](38, 10) NULL,
--	[D12_COLOR] [varchar](20) NULL,
--	[D13_QTY] [numeric](38, 10) NULL,
--	[D13_COLOR] [varchar](20) NULL,
--	[D14_QTY] [numeric](38, 10) NULL,
--	[D14_COLOR] [varchar](20) NULL,
--	[D15_QTY] [numeric](38, 10) NULL,
--	[D15_COLOR] [varchar](20) NULL,
--	[D16_QTY] [numeric](38, 10) NULL,
--	[D16_COLOR] [varchar](20) NULL,
--	[D17_QTY] [numeric](38, 10) NULL,
--	[D17_COLOR] [varchar](20) NULL,
--	[D18_QTY] [numeric](38, 10) NULL,
--	[D18_COLOR] [varchar](20) NULL,
--	[D19_QTY] [numeric](38, 10) NULL,
--	[D19_COLOR] [varchar](20) NULL,
--	[D20_QTY] [numeric](38, 10) NULL,
--	[D20_COLOR] [varchar](20) NULL,
--	[D21_QTY] [numeric](38, 10) NULL,
--	[D21_COLOR] [varchar](20) NULL,
--	[D22_QTY] [numeric](38, 10) NULL,
--	[D22_COLOR] [varchar](20) NULL,
--	[D23_QTY] [numeric](38, 10) NULL,
--	[D23_COLOR] [varchar](20) NULL,
--	[D24_QTY] [numeric](38, 10) NULL,
--	[D24_COLOR] [varchar](20) NULL,
--	[D25_QTY] [numeric](38, 10) NULL,
--	[D25_COLOR] [varchar](20) NULL,
--	[D26_QTY] [numeric](38, 10) NULL,
--	[D26_COLOR] [varchar](20) NULL,
--	[D27_QTY] [numeric](38, 10) NULL,
--	[D27_COLOR] [varchar](20) NULL,
--	[CATEGORY_ID] [varchar](17) NOT NULL,
--	[CATEGORY_ORDER] [int] NOT NULL,
--	[DATA_TYPE] [varchar](4) NOT NULL
--   )






		--SELECT @v_dSql += N'	      , BOH_2ND AS (                                                                                                                                        ' + char(10)
		--SELECT @v_dSql += N'				        	insert into #BOH_2ND                                ' + char(10)
		SELECT @v_dSql += N'				        	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID                                 ' + char(10)
		SELECT @v_dSql += N'				        		 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, '''' AS EQUIPMENT_ID                                                               ' + char(10)
		SELECT @v_dSql += N'				        		 , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME                                                                      ' + char(10)
		SELECT @v_dSql += N'				        		 , ''ZZZZZ'' AS PRODUCTION_TYPE, ''ZZZZZ'' AS MARKET, A.ITEM_TYPE                                                               ' + char(10)
		SELECT @v_dSql += N'				        		 , B.CATEGORY_NAME AS CATE                                                                                                      ' + char(10)

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

					SELECT @v_dSql += N'				, SUM( CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''BOH_2ND_EXPECT'' THEN A.EXPECT_QTY    ' + char(10)
					SELECT @v_dSql += N'				        	WHEN B.CATEGORY_ID = ''BOH_2ND_ACTIVATED'' THEN 0                    ' + char(10)
					SELECT @v_dSql += N'				        	ELSE 0 END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_QTY   ' + char(10)
					SELECT @v_dSql += N'				, '''' AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_COLOR   ' + char(10)
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
					
					SELECT @v_dSql += N'				, SUM( CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''BOH_2ND_EXPECT'' THEN A.EXPECT_QTY    ' + char(10)
					SELECT @v_dSql += N'				        	WHEN B.CATEGORY_ID = ''BOH_2ND_ACTIVATED'' THEN 0                    ' + char(10)
					SELECT @v_dSql += N'				        	ELSE 0 END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_QTY   ' + char(10)
					SELECT @v_dSql += N'				, '''' AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_COLOR   ' + char(10)
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
					SELECT @v_dSql += N'              																		ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +'_QTY   ' + char(10)
					SELECT @v_dSql += N'				, '''' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_COLOR   ' + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'				        		 , B.CATEGORY_ID, B.CATEGORY_ORDER, ''DATA'' AS DATA_TYPE                                                                       ' + char(10)
		SELECT @v_dSql += N'				        	INTO	#BOH_2ND                                ' + char(10)
		SELECT @v_dSql += N'				        	FROM	(                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'						        		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                 ' + char(10)
		SELECT @v_dSql += N'						        			    , AA.FIN_OPERATION_ID AS OPERATION_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'						        			    , A.LINE_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'						        			    , AA.TOP_ITEM_ID                                                                                                ' + char(10)
		SELECT @v_dSql += N'						        			    , AA.TOP_ITEM_ID AS ITEM_ID -- 완성공정 품번으로 변경                                                           ' + char(10)
		SELECT @v_dSql += N'						        			    , ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(C.PJT_GROUP_NAME,''-'') AS PJT_GROUP_NAME, ISNULL(B.LINE_NAME,''-'') AS LINE_NAME, B.LOCATION, B.ELECTRODE_TYPE, C.ITEM_TYPE      ' + char(10)
		SELECT @v_dSql += N'						        			    , (CASE WHEN CONVERT(VARCHAR, A.SECOND_OCV_EXP_DATE, 112) < '''+ @p_plan_date +''' THEN '''+ @p_plan_date +''' ELSE CONVERT(VARCHAR, A.SECOND_OCV_EXP_DATE, 112) END) AS PLAN_DATE -- 계획 이전 재고는 계획 당일 재고로 본다. ' + char(10)
		SELECT @v_dSql += N'						        			    , ISNULL(A.FP_APPLY_WIPQTY,0) AS EXPECT_QTY                                                                     ' + char(10)
		SELECT @v_dSql += N'	      										, 0 AS OUT_QTY		' + char(10)
		SELECT @v_dSql += N'						        		FROM   SCM_STOCK_H_V A WITH(NOLOCK)                                                                                       ' + char(10)
		SELECT @v_dSql += N'						        				INNER HASH JOIN (                                                                                               ' + char(10)
		SELECT @v_dSql += N'											        				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID, A.ITEM_ID   ' + char(10)
		SELECT @v_dSql += N'											        						, B.OPERATION_ID AS FIN_OPERATION_ID -- 최종 공정을 뽑기위한 과정                   ' + char(10)
		SELECT @v_dSql += N'											        				FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                         ' + char(10)
		SELECT @v_dSql += N'											        						, (                                                                                 ' + char(10)
		SELECT @v_dSql += N'											        							SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID  ' + char(10)
		SELECT @v_dSql += N'											        							FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                             ' + char(10)
		SELECT @v_dSql += N'											        							WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                            ' + char(10)
		SELECT @v_dSql += N'											        							AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                ' + char(10)
		SELECT @v_dSql += N'											        							AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'															      	              AND    A.OPERATION_ID IN (''P5500'',''P9500'')                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'															      	              AND    (A.OUT_QTY > 0 OR A.MPP_OUT_QTY > 0 OR A.WPP_OUT_QTY > 0 OR A.RESULT_OUT_QTY > 0)             ' + char(10)
		SELECT @v_dSql += N'	    																	) B                                                                                 ' + char(10)
		SELECT @v_dSql += N'											        				WHERE  1=1                                                                                  ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.COMPANY_ID  = B.COMPANY_ID                                                         ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.DIVISION_ID = B.DIVISION_ID                                                        ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.SITE_ID     = B.SITE_ID                                                            ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.PLANT_ID    = B.PLANT_ID                                                           ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.FACTORY_ID  = B.FACTORY_ID                                                         ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.LINE_ID     = B.LINE_ID                                                            ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.TOP_ITEM_ID = B.TOP_ITEM_ID                                                        ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.INSTANCE_ID = '''+ @p_instance_id +'''                                             ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                 ' + char(10)
		SELECT @v_dSql += N'											        				AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'														              AND    A.OPERATION_ID = ''P5200''                                                         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'														              AND    (A.OUT_QTY > 0 OR A.MPP_OUT_QTY > 0 OR A.WPP_OUT_QTY > 0 OR A.RESULT_OUT_QTY > 0)  ' + char(10)
		SELECT @v_dSql += N'											        		) AA                                                                                                ' + char(10)
		SELECT @v_dSql += N'											        		ON  A.COMPANY_ID            = AA.COMPANY_ID                                                         ' + char(10)
		SELECT @v_dSql += N'											        		AND A.DIVISION_ID           = AA.DIVISION_ID                                                        ' + char(10)
		SELECT @v_dSql += N'											        		AND A.SITE_ID               = AA.SITE_ID                                                            ' + char(10)
		SELECT @v_dSql += N'											        		AND A.PLANT_ID              = AA.PLANT_ID                                                           ' + char(10)
		SELECT @v_dSql += N'											        		AND A.FACTORY_ID            = AA.FACTORY_ID                                                         ' + char(10)
		SELECT @v_dSql += N'											        		AND A.FP_APPLY_OPERATION_ID = AA.OPERATION_ID                                                       ' + char(10)
		SELECT @v_dSql += N'											        		AND A.LINE_ID               = AA.LINE_ID                                                            ' + char(10)
		SELECT @v_dSql += N'											        		AND A.FP_APPLY_ITEM_ID      = AA.ITEM_ID                                                            ' + char(10)
		SELECT @v_dSql += N'											        		LEFT OUTER HASH JOIN SCM_LINE_M B WITH(NOLOCK)                                                      ' + char(10)
		SELECT @v_dSql += N'											        		ON  A.COMPANY_ID            = B.COMPANY_ID                                                          ' + char(10)
		SELECT @v_dSql += N'											        		AND A.DIVISION_ID           = B.DIVISION_ID                                                         ' + char(10)
		SELECT @v_dSql += N'											        		AND A.SITE_ID               = B.SITE_ID                                                             ' + char(10)
		SELECT @v_dSql += N'											        		AND A.PLANT_ID              = B.PLANT_ID                                                            ' + char(10)
		SELECT @v_dSql += N'											        		AND A.FACTORY_ID            = B.FACTORY_ID                                                          ' + char(10)
		SELECT @v_dSql += N'											        		AND AA.FIN_OPERATION_ID     = B.OPERATION_ID -- 최종공정 기준으로 line name 검색                    ' + char(10)
		SELECT @v_dSql += N'											        		AND A.LINE_ID               = B.LINE_ID                                                             ' + char(10)
		SELECT @v_dSql += N'											        		INNER JOIN (                                                                                        ' + char(10)
		SELECT @v_dSql += N'													        				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID                   ' + char(10)
		SELECT @v_dSql += N'													        					 , (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME                   ' + char(10)
		SELECT @v_dSql += N'													        							 WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')  ' + char(10)
		SELECT @v_dSql += N'													        							 ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE                                  ' + char(10)
		SELECT @v_dSql += N'													        					 , ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME   ' + char(10)
		SELECT @v_dSql += N'													        				FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK)                   ' + char(10)
		SELECT @v_dSql += N'													        				WHERE  A.ITEM_CLASS  = C.CLASS_ID                                                   ' + char(10)
		SELECT @v_dSql += N'													        				AND    A.ACTIVE_FLAG = ''Y''                                                        ' + char(10)
		SELECT @v_dSql += N'													        				AND    C.USE_FLAG = ''Y''                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'											        		) C                                                                                                 ' + char(10)
		SELECT @v_dSql += N'											        		ON    AA.COMPANY_ID  = C.COMPANY_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'											        		AND   AA.DIVISION_ID = C.DIVISION_ID                                                                ' + char(10)
		SELECT @v_dSql += N'											        		AND   AA.SITE_ID     = C.SITE_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'											        		AND   AA.TOP_ITEM_ID = C.ITEM_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'									        		WHERE CONVERT(CHAR(8), A.CUTOFF_DATE, 112) = '''+ @p_plan_date +'''                                         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'									        		AND   A.STOCK_TYPE = ''WIP''                                                                                ' + char(10)
		SELECT @v_dSql += N'									        		AND   A.FP_APPLY_OPERATION_ID = ''P5200''                                                                   ' + char(10)
		SELECT @v_dSql += N'									        		AND   A.SECOND_OCV_EXP_DATE IS NOT NULL                                                                     ' + char(10)
		SELECT @v_dSql += N'	        										UNION ALL                                                                                                   ' + char(10)
		SELECT @v_dSql += N'											        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, B.OPERATION_ID AS FIN_OPERATION_ID      ' + char(10)
		SELECT @v_dSql += N'											        		, A.LINE_ID, A.TOP_ITEM_ID, A.TOP_ITEM_ID AS ITEM_ID -- 완성공정 품번으로 변경                  ' + char(10)
		SELECT @v_dSql += N'											        		, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(C.PJT_GROUP_NAME,''-'') AS PJT_GROUP_NAME, ISNULL(D.LINE_NAME,''-'') AS LINE_NAME, A.LOCATION, A.ELECTRODE_TYPE, C.ITEM_TYPE   ' + char(10)
		SELECT @v_dSql += N'											        		, DATEADD(DAY, ISNULL(E.KEEP_DAYS, 0), A.PLAN_DATE) AS PLAN_DATE   ' + char(10)
		SELECT @v_dSql += N'											        		, A.OUT_QTY AS EXPECT_QTY, 0 AS OUT_QTY   ' + char(10)
		SELECT @v_dSql += N'											        FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                         ' + char(10)
		SELECT @v_dSql += N'											        		INNER JOIN	(                                                                                 ' + char(10)		
		SELECT @v_dSql += N'											        							SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID  ' + char(10)
		SELECT @v_dSql += N'											        							FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                             ' + char(10)
		SELECT @v_dSql += N'											        							WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                            ' + char(10)
		SELECT @v_dSql += N'											        							AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                ' + char(10)
		SELECT @v_dSql += N'											        							AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'															      	              AND    A.OPERATION_ID IN (''P5500'',''P9500'')                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'															      	              AND    (A.OUT_QTY > 0 OR A.MPP_OUT_QTY > 0 OR A.WPP_OUT_QTY > 0 OR A.RESULT_OUT_QTY > 0)             ' + char(10)
		SELECT @v_dSql += N'	    																	) B                                                                                 ' + char(10)
		SELECT @v_dSql += N'											        				ON     1=1						                                                            ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.COMPANY_ID  = B.COMPANY_ID                                                         ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.DIVISION_ID = B.DIVISION_ID                                                        ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.SITE_ID     = B.SITE_ID                                                            ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.PLANT_ID    = B.PLANT_ID                                                           ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.FACTORY_ID  = B.FACTORY_ID                                                         ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.LINE_ID     = B.LINE_ID                                                            ' + char(10)
		SELECT @v_dSql += N'											        				AND    A.TOP_ITEM_ID = B.TOP_ITEM_ID                                                        ' + char(10)
		SELECT @v_dSql += N'											        		INNER JOIN (                                                                                        ' + char(10)
		SELECT @v_dSql += N'													        				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID                   ' + char(10)
		SELECT @v_dSql += N'													        					 , (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME                   ' + char(10)
		SELECT @v_dSql += N'													        							 WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')  ' + char(10)
		SELECT @v_dSql += N'													        							 ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE                                  ' + char(10)
		SELECT @v_dSql += N'													        					 , ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME   ' + char(10)
		SELECT @v_dSql += N'													        				FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK)                   ' + char(10)
		SELECT @v_dSql += N'													        				WHERE  A.ITEM_CLASS  = C.CLASS_ID                                                   ' + char(10)
		SELECT @v_dSql += N'													        				AND    A.ACTIVE_FLAG = ''Y''                                                        ' + char(10)
		SELECT @v_dSql += N'													        				AND    C.USE_FLAG = ''Y''                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'											        		) C                                                                                                 ' + char(10)
		SELECT @v_dSql += N'											        		ON    A.COMPANY_ID  = C.COMPANY_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'											        		AND   A.DIVISION_ID = C.DIVISION_ID                                                                ' + char(10)
		SELECT @v_dSql += N'											        		AND   A.SITE_ID     = C.SITE_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'											        		AND   A.TOP_ITEM_ID = C.ITEM_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'											        		LEFT OUTER HASH JOIN SCM_LINE_M D WITH(NOLOCK)                                                      ' + char(10)
		SELECT @v_dSql += N'											        		ON  A.COMPANY_ID            = D.COMPANY_ID                                                          ' + char(10)
		SELECT @v_dSql += N'											        		AND A.DIVISION_ID           = D.DIVISION_ID                                                         ' + char(10)
		SELECT @v_dSql += N'											        		AND A.SITE_ID               = D.SITE_ID                                                             ' + char(10)
		SELECT @v_dSql += N'											        		AND A.PLANT_ID              = D.PLANT_ID                                                            ' + char(10)
		SELECT @v_dSql += N'											        		AND A.FACTORY_ID            = D.FACTORY_ID                                                          ' + char(10)
		SELECT @v_dSql += N'											        		AND B.OPERATION_ID			= D.OPERATION_ID -- 최종공정 기준으로 line name 검색                    ' + char(10)
		SELECT @v_dSql += N'											        		AND A.LINE_ID               = D.LINE_ID                                                             ' + char(10)
		SELECT @v_dSql += N'											        		LEFT OUTER JOIN (                                                       ' + char(10)
		SELECT @v_dSql += N'											        							SELECT A.ITEM_ID, MAX(A.KEEP_DAYS) AS KEEP_DAYS     ' + char(10)
		SELECT @v_dSql += N'											        							FROM   SCM_MMD_SECOND_OCV_SPEC_M A WITH(NOLOCK)     ' + char(10)
		SELECT @v_dSql += N'											        							WHERE  1=1     ' + char(10)
		SELECT @v_dSql += N'											        							AND    A.RUN_TIME = 1     ' + char(10)
		SELECT @v_dSql += N'											        							AND    A.OPERATION_ID = ''P5400''     ' + char(10)
		SELECT @v_dSql += N'											        							GROUP BY A.ITEM_ID     ' + char(10)
		SELECT @v_dSql += N'											        						 ) E    ' + char(10)
		SELECT @v_dSql += N'											        		ON  A.ITEM_ID            = E.ITEM_ID                                                          ' + char(10)
		SELECT @v_dSql += N'											        	WHERE  1=1                                                                                  ' + char(10)
		SELECT @v_dSql += N'											        	AND    A.INSTANCE_ID = '''+ @p_instance_id +'''                                             ' + char(10)
		SELECT @v_dSql += N'											        	AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                 ' + char(10)
		SELECT @v_dSql += N'											        	AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''   ' + char(10)
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

		SELECT @v_dSql += N'	        										UNION ALL                                                                                                   ' + char(10)
		SELECT @v_dSql += N'										            -- P5200 계획 기준으로 boh 2nd, activated 카테고리 정보 강제생성                                            ' + char(10)
		SELECT @v_dSql += N'										            SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, C.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID, A.ITEM_ID                   ' + char(10)
		SELECT @v_dSql += N'										                 , ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(C.PJT_GROUP_NAME,''-'') AS PJT_GROUP_NAME, ISNULL(B.LINE_NAME,''-'') AS LINE_NAME, B.LOCATION, B.ELECTRODE_TYPE, C.ITEM_TYPE                  ' + char(10)
		SELECT @v_dSql += N'										                 , A.PLAN_DATE AS PLAN_DATE, 0 AS EXPECT_QTY															' + char(10)
		SELECT @v_dSql += N'														 , CASE WHEN '''+ @p_plan_date +''' <= A.PLAN_DATE THEN A.OUT_QTY ELSE 0 END OUT_QTY					' + char(10) 
		SELECT @v_dSql += N'										            FROM	(                                                                                                   ' + char(10)
		SELECT @v_dSql += N'											            		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.TOP_ITEM_ID, A.TOP_ITEM_ID AS ITEM_ID, '''+ @p_plan_date +''' AS PLAN_DATE, 0 AS OUT_QTY        ' + char(10)
		SELECT @v_dSql += N'											            		FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                      ' + char(10)
		SELECT @v_dSql += N'											            		WHERE  1=1                                                                                      ' + char(10)
		SELECT @v_dSql += N'											            		AND    A.INSTANCE_ID = '''+ @p_instance_id +'''                                                 ' + char(10)
		SELECT @v_dSql += N'											            		AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                     ' + char(10)
		SELECT @v_dSql += N'											            		AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'											            		AND    A.OPERATION_ID = ''P5200'' -- P5200 고정                                                 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'																AND    (A.OUT_QTY > 0 OR A.MPP_OUT_QTY > 0 OR A.WPP_OUT_QTY > 0 OR A.RESULT_OUT_QTY > 0)        ' + char(10)
		SELECT @v_dSql += N'	            											) A                                                                                                 ' + char(10)
		SELECT @v_dSql += N'												            INNER JOIN (                                                                                        ' + char(10)
		SELECT @v_dSql += N'														                    SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID                   ' + char(10)
		SELECT @v_dSql += N'														                    	 , (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME                   ' + char(10)
		SELECT @v_dSql += N'														                    	 		 WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')  ' + char(10)
		SELECT @v_dSql += N'														                    	 		 ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE                                  ' + char(10)
		SELECT @v_dSql += N'														                    	 , ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME   ' + char(10)
		SELECT @v_dSql += N'														            			 , SUBSTRING(A.FLOW_ID,1,5) AS OPERATION_ID                                     ' + char(10)
		SELECT @v_dSql += N'														                    FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK)                   ' + char(10)
		SELECT @v_dSql += N'														                    WHERE  A.ITEM_CLASS  = C.CLASS_ID                                                   ' + char(10)
		SELECT @v_dSql += N'														                    AND    A.ACTIVE_FLAG = ''Y''                                                        ' + char(10)
		SELECT @v_dSql += N'														                    AND    C.USE_FLAG = ''Y''                                                           ' + char(10)
		SELECT @v_dSql += N'														                    AND    A.FLOW_ID IS NOT NULL                                                        ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_PRODUCT_GROUP_CODE' , 'LIKE', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'												            ) C                                                                                                 ' + char(10)
		SELECT @v_dSql += N'												            ON  A.COMPANY_ID    = C.COMPANY_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'												            AND A.DIVISION_ID   = C.DIVISION_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'												            AND A.SITE_ID       = C.SITE_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'												            AND A.TOP_ITEM_ID   = C.ITEM_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'												            LEFT OUTER HASH JOIN SCM_LINE_M B WITH(NOLOCK)                                                      ' + char(10)
		SELECT @v_dSql += N'												            ON  A.COMPANY_ID    = B.COMPANY_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'												            AND A.DIVISION_ID   = B.DIVISION_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'												            AND A.SITE_ID       = B.SITE_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'												            AND A.PLANT_ID      = B.PLANT_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'												            AND A.FACTORY_ID    = B.FACTORY_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'												            AND C.OPERATION_ID  = B.OPERATION_ID -- 최종공정 기준으로 line name 검색                            ' + char(10)
		SELECT @v_dSql += N'												            AND A.LINE_ID       = B.LINE_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'	        								) A                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'								        	INNER JOIN (                                                                                                        ' + char(10)
		SELECT @v_dSql += N'											        		SELECT *                                                                                            ' + char(10)
		SELECT @v_dSql += N'											        		FROM (                                                                                              ' + char(10)
		SELECT @v_dSql += N'											        				SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER                     ' + char(10)
		SELECT @v_dSql += N'											        				UNION ALL                                                                                   ' + char(10)
		SELECT @v_dSql += N'											        				SELECT ''BOH_2ND_EXPECT'' AS CATEGORY_ID, N''EXP_2nd OCV Complete'' AS CATEGORY_NAME, 97 AS CATEGORY_ORDER         ' + char(10)
		SELECT @v_dSql += N'											        				UNION ALL                                                                                   ' + char(10)
		SELECT @v_dSql += N'											        				SELECT ''BOH_2ND_ACTIVATED'' AS CATEGORY_ID, N''Activated'' AS CATEGORY_NAME, 99 AS CATEGORY_ORDER                 ' + char(10)
		SELECT @v_dSql += N'											        		) BB                                                                                                ' + char(10)
		SELECT @v_dSql += N'											        		WHERE CATEGORY_ID <> ''X''                                                                          ' + char(10)
		SELECT @v_dSql += N'								        	) B                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'								        	ON 1=1                                                                                                              ' + char(10)
		SELECT @v_dSql += N'								        	INNER JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                                ' + char(10)
		SELECT @v_dSql += N'								        	ON A.PLAN_DATE = C.YYYYMMDD                                                                                         ' + char(10)
		SELECT @v_dSql += N'					        	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID                           ' + char(10)
		SELECT @v_dSql += N'					        		   , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE                                                                               ' + char(10)
		SELECT @v_dSql += N'					        		   , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME, A.ITEM_TYPE                                                   ' + char(10)
		SELECT @v_dSql += N'					        		   , B.CATEGORY_NAME, B.CATEGORY_ID, B.CATEGORY_ORDER                                                                       ' + char(10)
		--SELECT @v_dSql += N'	      		)                                                                                                                                               ' + char(10)






		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID                                                         ' + char(10)
		SELECT @v_dSql += N'		   , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID                                                                                           ' + char(10)
		SELECT @v_dSql += N'		   , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME                                                                                            ' + char(10)
		SELECT @v_dSql += N'		   , (CASE WHEN A.PRODUCTION_TYPE = ''ZZZZZ'' THEN NULL ELSE A.PRODUCTION_TYPE END) AS PRODUCTION_TYPE                                                  ' + char(10)
		SELECT @v_dSql += N'		   , (CASE WHEN A.MARKET = ''ZZZZZ'' THEN NULL ELSE A.MARKET END) AS MARKET                                                                             ' + char(10)
		SELECT @v_dSql += N'		   , A.ITEM_TYPE,A.CATE                                                                                                                                 ' + char(10)
		
		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY ' + char(10)
					SELECT @v_dSql += '               , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_COLOR ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'				, A.CATEGORY_ID, A.CATEGORY_ORDER                                                                                                               ' + char(10)
		SELECT @v_dSql += N'				, A.DATA_TYPE                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'				, DENSE_RANK() OVER(ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID) AS LV1    ' + char(10)
		SELECT @v_dSql += N'				, DENSE_RANK() OVER(ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID) AS LV2 -- 2nd OCV 용                   ' + char(10)
		SELECT @v_dSql += N'				, DENSE_RANK() OVER(ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.TOP_ITEM_ID) AS LV3 -- OCV2_BOH     ' + char(10)
		SELECT @v_dSql += N'				, B.APPLIED_MODEL                                                                                                                               ' + char(10)
		
		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , C.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_MO ' + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'				, CASE WHEN R.FACTORY_ID IS NULL THEN ''N''                                                                                                     ' + char(10)
		SELECT @v_dSql += N'				      WHEN RIGHT('''+ @p_plan_id +''',2) = ''00'' THEN ''N''                                                                                      ' + char(10)
		SELECT @v_dSql += N'				      WHEN ''RELEASE'' = '''+ @p_plan_type +''' THEN ''Y''                                                                                      ' + char(10)
		SELECT @v_dSql += N'				      WHEN ( D.PRODUCTION_TYPE IS NULL OR (A.OPERATION_ID IN (''A3000'',''A9000'',''P5500'',''P9500'') AND A.PRODUCTION_TYPE = ''TEST'')) THEN ''N''                   ' + char(10)
		SELECT @v_dSql += N'				      WHEN I.DIVISION_ID IS NOT NULL THEN ''Y''                                                                                                 ' + char(10)
		--SELECT @v_dSql += N'				      WHEN H.ITEM_ID IS NULL THEN ''N''                                                                                                         ' + char(10) -- FP 타겟 없이 계획 수립
		SELECT @v_dSql += N'				      ELSE ''Y'' END AS EDIT_YN                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	   			, CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END AS ZERO_YN                                                                           ' + char(10)
		SELECT @v_dSql += N'	FROM	(                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'				SELECT * FROM #MAIN                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'				UNION ALL                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'				SELECT * FROM #BOH_2ND                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'				UNION ALL                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	          	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID                                             ' + char(10)
		SELECT @v_dSql += N'		                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID                                                              ' + char(10)
		SELECT @v_dSql += N'		                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME                                                        ' + char(10)
		SELECT @v_dSql += N'		                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE                                                                             ' + char(10)
		SELECT @v_dSql += N'		                ,A.CATE                                                                                                                                 ' + char(10)

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

		SELECT @v_dSql += N'		          			,A.CATEGORY_ID, A.CATEGORY_ORDER                                                                                                    ' + char(10)
		SELECT @v_dSql += N'		                ,''TOTAL'' AS DATA_TYPE                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'		          FROM   #MAIN A                                                                                                                                 ' + char(10)
		SELECT @v_dSql += @sub_total
		SELECT @v_dSql += N'		          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE            ' + char(10)
		SELECT @v_dSql += N'		                  ,A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER                                                                                              ' + char(10)
		SELECT @v_dSql += N'		          -- Off Calendar, Setup                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		          UNION ALL                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'		          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID                                           ' + char(10)
		SELECT @v_dSql += N'		                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID                                                              ' + char(10)
		SELECT @v_dSql += N'		                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME                                                        ' + char(10)
		SELECT @v_dSql += N'		                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE                                                                             ' + char(10)
		SELECT @v_dSql += N'		                ,B.CATEGORY_NAME AS CATE                                                                                                                ' + char(10)

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

					SELECT @v_dSql += N'		        , SUM( CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_QTY	' + char(10)
					SELECT @v_dSql += N'		        , NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_COLOR      ' + char(10)
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
					
					SELECT @v_dSql += N'		        , SUM( CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_QTY	' + char(10)
					SELECT @v_dSql += N'		        , NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_COLOR      ' + char(10)
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
					
					SELECT @v_dSql += N'		        , SUM( CASE WHEN C.YYYYMMDD = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_QTY	' + char(10)
					SELECT @v_dSql += N'		        , NULL AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_COLOR      ' + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'		          			,B.CATEGORY_ID, B.CATEGORY_ORDER                                                                                                    ' + char(10)
		SELECT @v_dSql += N'		                ,''TOTAL'' AS DATA_TYPE                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'		          FROM   #CAPA_VALUE A                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'				          INNER JOIN (                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'				              SELECT ''OFF'' AS CATEGORY_ID, ''Off Cal.'' AS CATEGORY_NAME, 100 AS CATEGORY_ORDER                                               ' + char(10)
		SELECT @v_dSql += N'				              UNION ALL                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'				              SELECT ''SETUP'' AS CATEGORY_ID, ''M/C(min)'' AS CATEGORY_NAME, 200 AS CATEGORY_ORDER                                             ' + char(10)
		SELECT @v_dSql += N'				          ) B                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'				          ON 1=1                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'				          INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                                             ' + char(10)
		SELECT @v_dSql += N'				          ON  A.PLAN_DATE = C.YYYYMMDD                                                                                                          ' + char(10)
		SELECT @v_dSql += @sub_total
		SELECT @v_dSql += N'		          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE            ' + char(10)
		SELECT @v_dSql += N'		                  ,B.CATEGORY_NAME, B.CATEGORY_ID, B.CATEGORY_ORDER                                                                                     ' + char(10)
		SELECT @v_dSql += N'		          -- Capa                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'		          UNION ALL                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'		          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID                                           ' + char(10)
		SELECT @v_dSql += N'		                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID                                                              ' + char(10)
		SELECT @v_dSql += N'		                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME                                                        ' + char(10)
		SELECT @v_dSql += N'		                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE                                                                             ' + char(10)
		SELECT @v_dSql += N'		               ,''Load(%)'' AS CATE                                                                                                                     ' + char(10)

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

					SELECT @v_dSql += N'		        , CEILING(AVG(CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_QTY             ' + char(10)
					SELECT @v_dSql += N'		        , CASE WHEN (CEILING(AVG(CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END  AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_COLOR        ' + char(10)
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
					
					SELECT @v_dSql += N'		        , CEILING(AVG(CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_QTY             ' + char(10)
					SELECT @v_dSql += N'		        , CASE WHEN (CEILING(AVG(CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END  AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_COLOR        ' + char(10)
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
					
					SELECT @v_dSql += N'		        , CEILING(AVG(CASE WHEN C.YYYYMMDD = ''' + @sub_param_0 + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_QTY             ' + char(10)
					SELECT @v_dSql += N'		        , CASE WHEN (CEILING(AVG(CASE WHEN C.YYYYMMDD = ''' + @sub_param_0 + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END  AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_COLOR        ' + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'		          			,''CAPA'' AS CATEGORY_ID, 300 AS CATEGORY_ORDER                                                                                     ' + char(10)
		SELECT @v_dSql += N'							,''TOTAL'' AS DATA_TYPE                                                                                                             ' + char(10)
		SELECT @v_dSql += N'		          FROM   #CAPA_VALUE A                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'				          INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                                             ' + char(10)
		SELECT @v_dSql += N'				          ON  A.PLAN_DATE = C.YYYYMMDD                                                                                                          ' + char(10)
		SELECT @v_dSql += @capa_total
		SELECT @v_dSql += N'		          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE            ' + char(10)
		SELECT @v_dSql += N'		          -- Total                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'		          UNION ALL                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'		          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, A.OPERATION_ID AS OPERATION_ID              ' + char(10)
		SELECT @v_dSql += N'		                ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID                                                  ' + char(10)
		SELECT @v_dSql += N'		                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME                                                        ' + char(10)
		SELECT @v_dSql += N'		                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE                                                                             ' + char(10)
		SELECT @v_dSql += N'		                ,A.CATE                                                                                                                                 ' + char(10)
		
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

		SELECT @v_dSql += N'		          			,A.CATEGORY_ID, A.CATEGORY_ORDER                                                                                                    ' + char(10)
		SELECT @v_dSql += N'		                ,''TOTAL_2'' AS DATA_TYPE                                                                                                               ' + char(10)
		SELECT @v_dSql += N'		           FROM   #MAIN A                                                                                                                                ' + char(10)
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'		          GROUP BY A.OPERATION_ID, A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER                                                                              ' + char(10)
		SELECT @v_dSql += N'			) A                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                                                           ' + char(10)
		SELECT @v_dSql += N'			ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'			AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID     = B.SITE_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'			AND A.ITEM_ID     = B.ITEM_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN #T_MEMO C WITH(NOLOCK)                                                                                                               ' + char(10)
		SELECT @v_dSql += N'			ON  A.COMPANY_ID      = C.COMPANY_ID                                                                                                                ' + char(10)
		SELECT @v_dSql += N'			AND A.DIVISION_ID     = C.DIVISION_ID                                                                                                               ' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID         = C.SITE_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			AND A.PLANT_ID        = C.PLANT_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'			AND A.FACTORY_ID      = C.FACTORY_ID                                                                                                                ' + char(10)
		SELECT @v_dSql += N'			AND A.OPERATION_ID    = C.OPERATION_ID                                                                                                              ' + char(10)
		SELECT @v_dSql += N'			AND A.LINE_ID         = C.LINE_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			AND A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE                                                                                                            ' + char(10)
		SELECT @v_dSql += N'			AND A.PRODUCTION_TYPE = C.PRODUCTION_TYPE                                                                                                           ' + char(10)
		SELECT @v_dSql += N'			AND A.MARKET          = C.MARKET                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'			AND A.TOP_ITEM_ID     = C.TOP_ITEM_ID                                                                                                               ' + char(10)
		SELECT @v_dSql += N'			AND A.ITEM_ID         = C.ITEM_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'			(                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'				SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PRODUCTION_TYPE                                                                     ' + char(10)
		SELECT @v_dSql += N'				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                      ' + char(10)
		SELECT @v_dSql += N'				WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''                                                                                            ' + char(10)
		SELECT @v_dSql += N'				AND    A.ACTIVE_FLAG = ''Y''                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'			) D                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'			ON A.DIVISION_ID = D.DIVISION_ID                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'			AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE                                                                                                           ' + char(10)
		SELECT @v_dSql += N'			AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = D.PRODUCTION_TYPE  ' + char(10)
--		SELECT @v_dSql += N'			LEFT OUTER HASH JOIN (                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN (                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'							          SELECT DISTINCT H.*                                                                                                       ' + char(10)
		SELECT @v_dSql += N'							          FROM (                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'												SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                   ' + char(10)
		SELECT @v_dSql += N'												--, A.MARKET, (CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''S-TEST'' ELSE A.PRODUCTION_TYPE END) AS PRODUCTION_TYPE                   ' + char(10)
		SELECT @v_dSql += N'												FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)                                                                ' + char(10)
		SELECT @v_dSql += N'												WHERE  EXISTS (                                                                                                 ' + char(10)
		SELECT @v_dSql += N'					    							SELECT 1                                                                                                    ' + char(10)
		SELECT @v_dSql += N'					    							FROM (                                                                                                      ' + char(10)
		SELECT @v_dSql += N'					        							SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, A.SHOP_GROUP_ID                     ' + char(10)
		SELECT @v_dSql += N'					        							FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                                                             ' + char(10)
		SELECT @v_dSql += N'					        							     , SCM_FACTORY_M B WITH(NOLOCK)                                                                     ' + char(10)
		SELECT @v_dSql += N'					        							WHERE  A.INSTANCE_ID = '''+ @p_master_id +'''                                                                      ' + char(10)
		SELECT @v_dSql += N'					        							AND    A.FACTORY_ID  = B.FACTORY_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'					        							AND    A.ACTIVE_FLAG = ''Y''                                                                            ' + char(10)
		SELECT @v_dSql += N'					        							AND    B.ACTIVE_FLAG = ''Y''                                                                            ' + char(10)
		SELECT @v_dSql += N'					    							) X                                                                                                         ' + char(10)
		SELECT @v_dSql += N'					    							WHERE 1=1                                                                                                   ' + char(10)
		SELECT @v_dSql += N'					    							AND   A.COMPANY_ID    = X.COMPANY_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'					    							AND   A.DIVISION_ID   = X.DIVISION_ID                                                                       ' + char(10)
		SELECT @v_dSql += N'					    							AND   A.SITE_ID       = X.SITE_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'					    							AND   A.PLANT_ID      = X.PLANT_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'					    							AND   A.SHOP_GROUP_ID = X.SHOP_GROUP_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'												)                                                                                                               ' + char(10)
		SELECT @v_dSql += N'												AND A.MFG_WEEK IN (                                                                                             ' + char(10)
		SELECT @v_dSql += N'												    SELECT DISTINCT ISO_YYYYWW                                                                                  ' + char(10)
		SELECT @v_dSql += N'												    FROM   TH_UIS_CAL A WITH(NOLOCK)                                                                            ' + char(10)
		SELECT @v_dSql += N'												    WHERE  A.YYYYMMDD <= CONVERT(VARCHAR, (CONVERT(DATETIME,'''+ @p_plan_date +''') + ( ( ( SELECT MAX(ISNULL(A.ATTRIBUTE13,10)) AS ENGINE_PLAN_PER_WEEK               ' + char(10)
		SELECT @v_dSql += N'												    																	       	 FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              ' + char(10)
		SELECT @v_dSql += N'												    																	       	 WHERE A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''            ' + char(10)
		SELECT @v_dSql += N'												    																	       	 AND A.SEGMENT1 = '''+ @p_master_id +''' ) -1 ) * 7 ) ), 112)     ' + char(10)
		SELECT @v_dSql += N'												)                                                                                                               ' + char(10)
		SELECT @v_dSql += N'												UNION ALL                                                                                                       ' + char(10)
		SELECT @v_dSql += N'												SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                   ' + char(10)
		SELECT @v_dSql += N'												--, ISNULL(A.MARKET,''D'') AS MARKET, A.PRODUCTION_TYPE                                                         ' + char(10)
		SELECT @v_dSql += N'												FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK)                                                           ' + char(10)
		SELECT @v_dSql += N'												WHERE  A.DUE_DATE <= CONVERT(DATETIME, CONVERT(DATETIME,'''+ @p_plan_date +''') + ( ( ( SELECT MAX(ISNULL(A.ATTRIBUTE13,10)) AS ENGINE_PLAN_PER_WEEK                   ' + char(10)
		SELECT @v_dSql += N'																															 FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                  ' + char(10)
		SELECT @v_dSql += N'																															 WHERE A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                ' + char(10)
		SELECT @v_dSql += N'																															 AND A.SEGMENT1 = '''+ @p_master_id +''' ) -1 ) * 7 ), 112)           ' + char(10)
		SELECT @v_dSql += N'								          ) H                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'							      ) H                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'			ON  A.COMPANY_ID  = H.COMPANY_ID                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'			AND A.DIVISION_ID = H.DIVISION_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID     = H.SITE_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'			AND A.PLANT_ID    = H.PLANT_ID                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'			--AND A.MARKET      = H.MARKET                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'			AND A.TOP_ITEM_ID = H.ITEM_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'			--AND A.PRODUCTION_TYPE = H.PRODUCTION_TYPE                                                                                                         ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN (                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'				  SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS SITE_ID, A.SEGMENT4 AS PLANT_ID, A.SEGMENT5 AS MODEL_ID   ' + char(10)
		SELECT @v_dSql += N'				  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                    ' + char(10)
		SELECT @v_dSql += N'				  WHERE  A.LOOKUP_TYPE_CODE = ''AMEND_VALIDATION_EXCEPTION''                                                                                    ' + char(10)
		SELECT @v_dSql += N'				  AND    A.ACTIVE_FLAG      = ''Y''                                                                                                             ' + char(10)
		SELECT @v_dSql += N'				  AND    A.SEGMENT1         = '''+ @p_master_id +'''                                                                                                       ' + char(10)
		SELECT @v_dSql += N'			) I                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'			ON  A.DIVISION_ID = I.DIVISION_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID     = I.SITE_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'			AND A.PLANT_ID    = I.PLANT_ID                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'			AND A.TOP_ITEM_ID = I.MODEL_ID                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN (                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'					SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID                                ' + char(10)
		SELECT @v_dSql += N'					FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                                  ' + char(10)
		SELECT @v_dSql += N'					WHERE	1=1                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'					AND		R.USER_ID	= '''+ @p_user_id +'''                                                                                                             ' + char(10)
		SELECT @v_dSql += N'					AND		R.SAVE_FLAG	= ''Y''                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'					AND		R.INSTANCE_ID = '''+ @p_master_id +'''                                                                                                         ' + char(10)
		SELECT @v_dSql += N'			) R                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'			ON		1=1                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'			AND		A.COMPANY_ID		= R.COMPANY_ID                                                                                                          ' + char(10)
		SELECT @v_dSql += N'			AND		A.DIVISION_ID		= R.DIVISION_ID                                                                                                         ' + char(10)
		SELECT @v_dSql += N'			AND		A.SITE_ID			= R.SITE_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'			AND		A.PLANT_ID			= R.PLANT_ID                                                                                                            ' + char(10)
		SELECT @v_dSql += N'			AND		A.FACTORY_ID		= R.FACTORY_ID                                                                                                          ' + char(10)
		SELECT @v_dSql += N'			AND		A.OPERATION_ID		= R.OPERATION_ID                                                                                                        ' + char(10)
		SELECT @v_dSql += N'			AND		A.LINE_ID			= R.LINE_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION                                                                       ' + char(10)
		SELECT @v_dSql += N'	     , A.LINE_ID                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'		     , (CASE WHEN A.TOP_ITEM_ID IS NOT NULL THEN A.TOP_ITEM_ID ELSE ''ZZZZZ'' END)                                                                      ' + char(10)
		SELECT @v_dSql += N'		     , A.OPERATION_ID DESC                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		     , (CASE WHEN A.CATEGORY_ID LIKE ''BOH_2ND%'' THEN 999 ELSE 1 END) -- SORT OCV2                                                                     ' + char(10)
		SELECT @v_dSql += N'		     , A.ITEM_ID                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		     , A.PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE                                                                                                    ' + char(10)
		SELECT @v_dSql += N'		     , A.CATEGORY_ORDER                                                                                                                                 ' + char(10)
		
		
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


