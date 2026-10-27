
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )

CREATE PROCEDURE [dbo].[PR_UI_FP00623_PANCAKE_SIMUL_ELEC_TUNING]
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

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00623_PANCAKE_SIMUL_ELEC';
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
	DECLARE @p_release_flag NVARCHAR(MAX);
	DECLARE @p_chk_plan_id  NVARCHAR(MAX);
	DECLARE @p_uom_type		NVARCHAR(MAX);
	DECLARE @p_chk_total_include  NVARCHAR(MAX);
	DECLARE @p_unit			NVARCHAR(MAX);
	DECLARE @p_model		NVARCHAR(MAX);
	DECLARE @p_model_nick_name	NVARCHAR(MAX);
	DECLARE @p_cell_type	NVARCHAR(MAX);
	DECLARE @p_pancake_type	NVARCHAR(MAX);

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

			-- 계획, 배포 테이블 구분
			if @tmp_value = 'RELEASE' begin
				SET @p_amend_table = 'FP_AMEND_DAILY_PLAN_H'
			end
			else begin
				SET @p_amend_table = 'FP_AMEND_DAILY_PLAN_R'
			end

		END ELSE IF @tmp_column = 'CONFIRM_AREA' BEGIN
			SET @p_confirm_area  =		@tmp_value
		END ELSE IF @tmp_column = 'CURR_DATE_COL' BEGIN
			SET @p_curr_date_col =		@tmp_value
		END ELSE IF @tmp_column = 'RELEASE_FLAG' BEGIN
			SET @p_release_flag	=	@tmp_value ;
		END ELSE IF @tmp_column = 'CHK_PLAN_ID' BEGIN
			SET @p_chk_plan_id	=	@tmp_value ;
		END ELSE IF @tmp_column = 'UOM_TYPE' BEGIN
			SET @p_uom_type			=	@tmp_value ;
		END ELSE IF @tmp_column = 'CHK_TOTAL_INCLUDE' BEGIN
			SET @p_chk_total_include =	@tmp_value ;
		END ELSE IF @tmp_column = 'UNIT' BEGIN
			SET @p_unit			=	@tmp_value ;
		END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
			SET @p_model		=	@tmp_value ;
		END ELSE IF @tmp_column = 'MODEL_NICK_NAME' BEGIN
			SET @p_model_nick_name	=	@tmp_value ;
		END ELSE IF @tmp_column = 'CELL_TYPE' BEGIN
			SET @p_cell_type	=	@tmp_value ;
		END ELSE IF @tmp_column = 'PANCAKE_TYPE' BEGIN
			SET @p_pancake_type	=	@tmp_value ;

		
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
		/*
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
		*/
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
  -- 12/21
  SET @v_dSql += 'if object_id(''tempdb..#COATER_SITE'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #COATER_SITE'+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#ASSY_LINE'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ASSY_LINE'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#ITEM_CALC'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ITEM_CALC'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#COATER_PLAN'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #COATER_PLAN'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#ASSY_PLAN'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ASSY_PLAN'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#ITEM_LIST'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ITEM_LIST'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#FP_STOCH_H'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #FP_STOCH_H'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#ITEM_YIELD'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ITEM_YIELD'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#BASIS_BOH'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #BASIS_BOH'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#MAIN'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #MAIN'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#MAIN_I'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #MAIN_I'+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#INS_PLANT'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #INS_PLANT'+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#SHIP_INFO'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #SHIP_INFO'+ char(10)+ char(10)

  -- 12/21
  SET @v_dSql += 'SELECT DISTINCT A.DIVISION_ID, A.SITE_ID'+ char(10)
  SET @v_dSql += 'INTO #COATER_SITE'+ char(10)
  SET @v_dSql += 'FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'WHERE  A.OPERATION_ID = ''E2000'''+ char(10)
  SET @v_dSql += 'AND    A.INSTANCE_ID  = ''' + @p_instance_id + ''' '+ char(10)
  SET @v_dSql += ';'+ char(10)

  --SET @v_dSql += ''+ char(10)
  --SET @v_dSql += ''+ char(10)
  --SET @v_dSql += '-- 조립 노칭 라인 정보'+ char(10)
  SET @v_dSql += 'SELECT A.*'+ char(10)
  SET @v_dSql += 'INTO #ASSY_LINE'+ char(10)
  SET @v_dSql += 'FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'WHERE  A.OPERATION_ID = ''A5000'''+ char(10)
  SET @v_dSql += 'AND    A.INSTANCE_ID IN ('+ char(10)
  SET @v_dSql += '	SELECT A.SEGMENT2 AS ASSY_ID'+ char(10)
  SET @v_dSql += '	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_INSTANCE_MAP'''+ char(10)
  SET @v_dSql += '	AND    A.SEGMENT1 = ''' + @p_instance_id + ''''+ char(10)
  SET @v_dSql += ')'+ char(10)
  SET @v_dSql += ';'+ char(10)
  --SET @v_dSql += '-- 환산자 정보 : div-site-item 단위'+ char(10)
  SET @v_dSql += 'SELECT A.*'+ char(10)
  SET @v_dSql += 'INTO #ITEM_CALC'+ char(10)
  SET @v_dSql += 'FROM ('+ char(10)

  --  12/21
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ITEM_ID, VERSION, A.VALUE'+ char(10)
  --SET @v_dSql += '			--, PLANT_ID, FACTORY_ID'+ char(10)
  SET @v_dSql += '			, ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ITEM_ID'+ char(10)


--  SET @v_dSql += '	SELECT COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, VERSION, A.VALUE'+ char(10)
  --SET @v_dSql += '			--, PLANT_ID, FACTORY_ID'+ char(10)
--  SET @v_dSql += '			, ROW_NUMBER() OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID'+ char(10)

  SET @v_dSql += '	ORDER BY     PLANT_ID, FACTORY_ID, (CASE WHEN A.VERSION LIKE ''Z%'' THEN 9999 ELSE 1 END), VERSION DESC) AS ROW_NUM'+ char(10)
  SET @v_dSql += '	FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	WHERE  1=1'+ char(10)
  SET @v_dSql += '	AND    A.MAX_VER_FLAG = ''Y'''+ char(10)
  SET @v_dSql += '	AND    A.VALUE > 0'+ char(10)
  SET @v_dSql += '	AND    A.CATEGORY = ''Pancake (cell/m)'''+ char(10)
  SET @v_dSql += '	AND    A.OPERATION = ''E2000'''+ char(10)

  -- 12/21
  SET @v_dSql += '	AND    EXISTS ('+ char(10)
  SET @v_dSql += '		SELECT 1'+ char(10)
  SET @v_dSql += '		FROM   #COATER_SITE WW WITH(NOLOCK)'+ char(10)
  --SET @v_dSql += '		WHERE  A.DIVISION_ID = WW.DIVISION_ID'+ char(10)
  SET @v_dSql += '		WHERE  1=1'+ char(10)
  SET @v_dSql += '		AND    A.SITE_ID     = WW.SITE_ID'+ char(10)
  SET @v_dSql += '	)'+ char(10)

  --SET @v_dSql += '	AND    A.DIVISION_ID = ''81'''+ char(10)
  --SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --SET @v_dSql += '	AND    A.SITE_ID = ''A004'''+ char(10)
  --SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += ') A'+ char(10)
  SET @v_dSql += 'WHERE 1=1'+ char(10)
  SET @v_dSql += 'AND   ROW_NUM = 1'+ char(10)
  SET @v_dSql += ';'+ char(10)

  --SET @v_dSql += '--'+ char(10)
  SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, MIN(YIELD) AS YIELD'+ char(10)
  SET @v_dSql += 'INTO #ITEM_YIELD'+ char(10)
  SET @v_dSql += 'FROM   SCM_YIELD_M A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'WHERE  1=1'+ char(10)
  --SET @v_dSql += 'AND    A.DIVISION_ID = ''81'''+ char(10)
  --SET @v_dSql += 'AND    A.SITE_ID = ''A004'''+ char(10)
  --SET @v_dSql += 'AND    A.OPERATION_ID IN (''E3000'',''E4000'')'+ char(10)
  --SET @v_dSql += '--AND    A.ITEM_ID IN (''APCAN1437A'',''APCCA1494A'')'+ char(10)

  -- 12/21
  SET @v_dSql += 'AND    EXISTS ('+ char(10)
  SET @v_dSql += '	SELECT 1'+ char(10)
  SET @v_dSql += '	FROM   #COATER_SITE WW WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	WHERE  A.DIVISION_ID = WW.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND    A.SITE_ID     = WW.SITE_ID'+ char(10)
  SET @v_dSql += ')'+ char(10)


  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID ' , 'EQ', @p_site_id)) + char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID ' , 'EQ', @p_item_id)) + char(10)

--  SET @v_dSql += 'AND    A.MONTH >= ''202211'''+ char(10)
  SET @v_dSql += 'AND A.MONTH BETWEEN CONVERT(VARCHAR(6),'''+ @p_bucket_from +''') AND CONVERT(VARCHAR(6),'''+ @p_bucket_to +''')' + char(10)
  SET @v_dSql += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ITEM_ID, A.OPERATION_ID'+ char(10)
  SET @v_dSql += ';'+ char(10)

  --SET @v_dSql += '-- 전극 정보'+ char(10)
  --최종 배포 정보로 조회
  IF @p_release_flag = 'Y' BEGIN
	SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID AS PANCAKE_ITEM, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE '+ char(10)
	SET @v_dSql += '	 , SUM(ROUND(A.PLAN_QTY, 0)) AS PANCAKE_IN_QTY '+ char(10)
	SET @v_dSql += '	 , SUM(ROUND(A.CELL_OUT_QTY, 0)) AS CELL_IN_QTY '+ char(10)
	SET @v_dSql += '	 , SUM(ROUND(A.PLAN_QTY * ISNULL(Y1.YIELD,1) * ISNULL(Y2.YIELD,1), 0)) AS PANCAKE_IN_POST_QTY '+ char(10)
	SET @v_dSql += '	 , SUM(ROUND(A.CELL_OUT_QTY * ISNULL(Y1.YIELD,1) * ISNULL(Y2.YIELD,1), 0)) AS CELL_IN_POST_QTY '+ char(10)
	SET @v_dSql += 'INTO #COATER_PLAN'+ char(10)
	SET @v_dSql += 'FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) '+ char(10)
	SET @v_dSql += 'LEFT OUTER JOIN #ITEM_YIELD Y1 WITH(NOLOCK) '+ char(10)
	SET @v_dSql += 'ON 	1=1 '+ char(10)
	SET @v_dSql += 'AND	A.COMPANY_ID  = Y1.COMPANY_ID '+ char(10)
	SET @v_dSql += 'AND	A.DIVISION_ID = Y1.DIVISION_ID '+ char(10)
	SET @v_dSql += 'AND	A.SITE_ID     = Y1.SITE_ID '+ char(10)
	SET @v_dSql += 'AND A.ITEM_ID     = Y1.ITEM_ID '+ char(10)
	SET @v_dSql += 'AND Y1.OPERATION_ID = ''E3000'' '+ char(10)
	SET @v_dSql += 'LEFT OUTER JOIN #ITEM_YIELD Y2 WITH(NOLOCK) '+ char(10)
	SET @v_dSql += 'ON 	1=1 '+ char(10)
	SET @v_dSql += 'AND	A.COMPANY_ID  = Y2.COMPANY_ID '+ char(10)
	SET @v_dSql += 'AND	A.DIVISION_ID = Y2.DIVISION_ID '+ char(10)
	SET @v_dSql += 'AND	A.SITE_ID     = Y2.SITE_ID '+ char(10)
	SET @v_dSql += 'AND A.ITEM_ID     = Y2.ITEM_ID '+ char(10)
	SET @v_dSql += 'AND Y2.OPERATION_ID = ''E4000'' '+ char(10)
	SET @v_dSql += ', FP_INSTANCE_LINE_V B WITH(NOLOCK) '+ char(10)
	SET @v_dSql += 'WHERE  1=1 '+ char(10)
	SET @v_dSql += 'AND    A.COMPANY_ID     = B.COMPANY_ID '+ char(10)
	SET @v_dSql += 'AND    A.DIVISION_ID    = B.DIVISION_ID '+ char(10)
	SET @v_dSql += 'AND    A.SITE_ID        = B.SITE_ID '+ char(10)
	SET @v_dSql += 'AND    A.PLANT_ID       = B.PLANT_ID '+ char(10)
	SET @v_dSql += 'AND    A.FACTORY_ID     = B.FACTORY_ID '+ char(10)
	SET @v_dSql += 'AND    A.OPERATION_ID   = B.OPERATION_ID '+ char(10)
	SET @v_dSql += 'AND    A.LINE_ID        = B.LINE_ID '+ char(10)
	SET @v_dSql += 'AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE '+ char(10)
	SET @v_dSql += 'AND    B.INSTANCE_ID    = ''' + @p_instance_id + ''' '+ char(10)
	SET @v_dSql += 'AND    A.PLAN_TYPE      = ''RELEASE'' '+ char(10)
	SET @v_dSql += 'AND    A.OPERATION_ID   = ''E2000'' '+ char(10)
	SET @v_dSql += 'AND    A.PLAN_DATE BETWEEN CONVERT(DATE, ''' + @p_bucket_from + ''') AND CONVERT(DATE, ''' + @p_bucket_to + ''') '+ char(10)
	SET @v_dSql += 'AND    A.PLAN_QTY > 0 '+ char(10)
	SET @v_dSql += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE '+ char(10)
	SET @v_dSql += ';'+ char(10)+ char(10)

  END
  ELSE BEGIN
	SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID AS PANCAKE_ITEM, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE'+ char(10)
	--SET @v_dSql += '	 -- 각각 pancake, cell 수량'+ char(10)
	SET @v_dSql += '	 , SUM(ROUND(A.ADJUST_OUT_QTY_M, 0)) AS PANCAKE_IN_QTY'+ char(10)
	SET @v_dSql += '	 , SUM(ROUND(A.ADJUST_OUT_QTY_CELL, 0)) AS CELL_IN_QTY'+ char(10)
	SET @v_dSql += '	 , SUM(ROUND(A.ADJUST_OUT_QTY_M * ISNULL(Y1.YIELD,1) * ISNULL(Y2.YIELD,1), 0)) AS PANCAKE_IN_POST_QTY '+ char(10)
	SET @v_dSql += '	 , SUM(ROUND(A.ADJUST_OUT_QTY_CELL * ISNULL(Y1.YIELD,1) * ISNULL(Y2.YIELD,1), 0)) AS CELL_IN_POST_QTY '+ char(10)
	SET @v_dSql += 'INTO #COATER_PLAN'+ char(10)
	SET @v_dSql += 'FROM   ' + @p_amend_table + ' A WITH(NOLOCK)'+ char(10)
	SET @v_dSql += 'LEFT OUTER JOIN #ITEM_YIELD Y1 WITH(NOLOCK) '+ char(10)
	SET @v_dSql += 'ON 	1=1 '+ char(10)
	SET @v_dSql += 'AND	A.COMPANY_ID  = Y1.COMPANY_ID '+ char(10)
	SET @v_dSql += 'AND	A.DIVISION_ID = Y1.DIVISION_ID '+ char(10)
	SET @v_dSql += 'AND	A.SITE_ID     = Y1.SITE_ID '+ char(10)
	SET @v_dSql += 'AND   A.ITEM_ID     = Y1.ITEM_ID '+ char(10)
	SET @v_dSql += 'AND   Y1.OPERATION_ID = ''E3000'' '+ char(10)
	SET @v_dSql += 'LEFT OUTER JOIN #ITEM_YIELD Y2 WITH(NOLOCK) '+ char(10)
	SET @v_dSql += 'ON 	1=1 '+ char(10)
	SET @v_dSql += 'AND	A.COMPANY_ID  = Y2.COMPANY_ID '+ char(10)
	SET @v_dSql += 'AND	A.DIVISION_ID = Y2.DIVISION_ID '+ char(10)
	SET @v_dSql += 'AND	A.SITE_ID     = Y2.SITE_ID '+ char(10)
	SET @v_dSql += 'AND   A.ITEM_ID     = Y2.ITEM_ID '+ char(10)
	SET @v_dSql += 'AND   Y2.OPERATION_ID = ''E4000'' '+ char(10)
	SET @v_dSql += 'WHERE 1=1'+char(10)
	--INSTANCE_ID = ''PL_E_PRE'''+ char(10)
	SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
	--SET @v_dSql += 'AND    FP_PLAN_ID  = ''PL_E_PRE-20221205-02'''+ char(10)
	SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('FP_PLAN_ID' , 'EQ', @p_plan_id)) + char(10)
	SET @v_dSql += 'AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''''+ char(10)
	--SET @v_dSql += 'AND    A.OPERATION_ID = N''E2000'''+ char(10)
	--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
	  -- 12/21
	  SET @v_dSql += 'AND    EXISTS ('+ char(10)
	  SET @v_dSql += '	SELECT 1'+ char(10)
	  SET @v_dSql += '	FROM   #COATER_SITE WW WITH(NOLOCK)'+ char(10)
	  SET @v_dSql += '	WHERE  A.DIVISION_ID = WW.DIVISION_ID'+ char(10)
	  SET @v_dSql += '	AND    A.SITE_ID     = WW.SITE_ID'+ char(10)
	  SET @v_dSql += ')'+ char(10)
	  SET @v_dSql += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE'+ char(10)
	  SET @v_dSql += ';'+ char(10)+ char(10)

  END

  --SET @v_dSql += '-- 조립 정보'+ char(10)
  SET @v_dSql += 'SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID'+ char(10)
  SET @v_dSql += '     , B.CHILD_ITEM_ID AS PANCAKE_ITEM, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE'+ char(10)
  SET @v_dSql += '     , B.PARENT_QTY, B.CHILD_QTY, ISNULL(MAX(C.VALUE),1) AS CALC_QTY'+ char(10)
  SET @v_dSql += '	 , ROUND(SUM(PLAN_IN_QTY),0) AS PLAN_IN_QTY'+ char(10)
  --SET @v_dSql += '	 -- 각각 pancake, cell 수량'+ char(10)
  SET @v_dSql += '     , ROUND(SUM(PLAN_IN_QTY) * (B.CHILD_QTY/B.PARENT_QTY), 0) AS PANCAKE_IN_QTY'+ char(10)
  SET @v_dSql += '     , ROUND(SUM(PLAN_IN_QTY) * (B.CHILD_QTY/B.PARENT_QTY)*ISNULL(MAX(C.VALUE),1), 0) AS CELL_IN_QTY'+ char(10)
  SET @v_dSql += 'INTO #ASSY_PLAN'+ char(10)
  SET @v_dSql += 'FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'INNER JOIN #ASSY_LINE FF WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'ON  A.COMPANY_ID     = FF.COMPANY_ID'+ char(10)
  SET @v_dSql += 'AND A.DIVISION_ID    = FF.DIVISION_ID'+ char(10)
  SET @v_dSql += 'AND A.SITE_ID        = FF.SITE_ID'+ char(10)
  SET @v_dSql += 'AND A.PLANT_ID       = FF.PLANT_ID'+ char(10)
  SET @v_dSql += 'AND A.FACTORY_ID     = FF.FACTORY_ID'+ char(10)
  SET @v_dSql += 'AND A.OPERATION_ID   = FF.OPERATION_ID'+ char(10)
  SET @v_dSql += 'AND A.LINE_ID        = FF.LINE_ID'+ char(10)
  SET @v_dSql += 'AND A.ELECTRODE_TYPE = FF.ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += ', SCM_BOM_M B WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'LEFT OUTER JOIN #ITEM_CALC C WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'ON    1=1'+ char(10)
  SET @v_dSql += 'AND   B.COMPANY_ID    = C.COMPANY_ID'+ char(10)
  SET @v_dSql += 'AND   B.DIVISION_ID   = C.DIVISION_ID'+ char(10)
  SET @v_dSql += 'AND   B.SITE_ID       = C.SITE_ID'+ char(10)
  SET @v_dSql += 'AND   B.CHILD_ITEM_ID = C.ITEM_ID'+ char(10)
  SET @v_dSql += 'WHERE 1=1'+ char(10)
  SET @v_dSql += 'AND   A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += 'AND   A.SITE_ID     = B.SITE_ID'+ char(10)
  SET @v_dSql += 'AND   A.ITEM_ID     = B.PARENT_ITEM_ID'+ char(10)
  SET @v_dSql += 'AND   A.PLANT_ID    = B.PLANT_ID'+ char(10)
  --SET @v_dSql += '--AND   CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ''20221104'' AND ''20230122'''+ char(10)
  --SET @v_dSql += 'AND   CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ''20221205'' AND ''20230101'''+ char(10)
  SET @v_dSql += 'AND CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''''+ char(10)
  SET @v_dSql += 'AND   A.PLAN_TYPE = ''RELEASE'''+ char(10)
  SET @v_dSql += 'AND   B.EFF_END_DATE >= GETDATE()'+ char(10)
  SET @v_dSql += 'AND   A.OPERATION_ID = ''A5000'''+ char(10)
  SET @v_dSql += 'AND   (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0'+ char(10)

  -- 12/21
  SET @v_dSql += 'AND    EXISTS ('+ char(10)
  SET @v_dSql += '	SELECT 1'+ char(10)
  SET @v_dSql += '	FROM   #COATER_SITE WW WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	WHERE  A.DIVISION_ID = WW.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND    A.SITE_ID     = WW.SITE_ID'+ char(10)
  SET @v_dSql += ')'+ char(10)

  --SET @v_dSql += '--AND   B.CHILD_ITEM_ID IN (''APCAN1437A'',''APCCA1494A'')'+ char(10)
  SET @v_dSql += 'GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID'+ char(10)
  SET @v_dSql += '       , B.CHILD_ITEM_ID, PLAN_DATE, B.PARENT_QTY, B.CHILD_QTY'+ char(10)
  SET @v_dSql += ';'+ char(10)
  --SET @v_dSql += '/*'+ char(10)
  --SET @v_dSql += '-- 조회대상 아이템 : 조립+전극 item'+ char(10)
  --SET @v_dSql += 'SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, B.NICK_NAME, C.LEVEL_3_NAME AS PROD_NAME'+ char(10)
  --SET @v_dSql += 'INTO #ITEM_LIST'+ char(10)
  --SET @v_dSql += 'FROM ('+ char(10)
  --SET @v_dSql += '	SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PANCAKE_ITEM AS ITEM_ID'+ char(10)
  --SET @v_dSql += '	FROM   #COATER_PLAN'+ char(10)
  --SET @v_dSql += '	UNION'+ char(10)
  --SET @v_dSql += '	SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PANCAKE_ITEM AS ITEM_ID'+ char(10)
  --SET @v_dSql += '	FROM   #ASSY_PLAN'+ char(10)
  --SET @v_dSql += ') A'+ char(10)
  --SET @v_dSql += ', SCM_ITEM_M B WITH(NOLOCK)'+ char(10)
  --SET @v_dSql += ', SCM_ITEM_CLASS_M C WITH(NOLOCK)'+ char(10)
  --SET @v_dSql += 'WHERE 1=1'+ char(10)
  --SET @v_dSql += 'AND   A.COMPANY_ID  = B.COMPANY_ID'+ char(10)
  --SET @v_dSql += 'AND   A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  --SET @v_dSql += 'AND   A.SITE_ID     = B.SITE_ID'+ char(10)
  --SET @v_dSql += 'AND   A.ITEM_ID     = B.ITEM_ID'+ char(10)
  --SET @v_dSql += 'AND   B.ITEM_CLASS  = C.CLASS_ID'+ char(10)
  --SET @v_dSql += 'AND   C.LEVEL_2_CODE = ''APC'''+ char(10)
  --SET @v_dSql += 'AND   C.LEVEL_3_NAME != ''APCSR'''+ char(10)
  --SET @v_dSql += ';'+ char(10)
  --SET @v_dSql += '*/'+ char(10)
  --SET @v_dSql += '---------------------- 재고관련 시작 ----------------------------'+ char(10)
  SET @v_dSql += 'SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,STORAGE_ID,CUTOFF_DATE,SEQ'+ char(10)
  SET @v_dSql += '	 , STOCK_TYPE,ITEM_ID,LANE,PRODUCTION_TYPE,AVAILABLE_DATE,REMAIN_LEAD_TIME'+ char(10)
  SET @v_dSql += '	 , HOLDING_DATE,QTY,QTY_UOM,STOCK_STATUS,OPERATION_ID,LINE_ID,OUTSOURCING_FLAG'+ char(10)
  SET @v_dSql += '	 , OUTSOURCING_FACTORY,DESCRIPTION,FP_APPLY_OPERATION_ID'+ char(10)
  SET @v_dSql += '	 , FP_APPLY_ITEM_ID,FP_APPLY_WIPQTY,WIPHOLD_YN,WIP_TYPE_CODE,QTY2,MODIFY_FP_APPLY_WIPQTY'+ char(10)
  SET @v_dSql += '	 , MODIFY_DESCRIPTION,CAL_QTY,FORMATION_REWORK_TYPE,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME'+ char(10)
  SET @v_dSql += '	 , LOCATION,RELEASE_DUE_DATE,SHIP_AVAILABLE_DATE,LONG_TERM_QTY,MOVING_QTY'+ char(10)
  SET @v_dSql += '	 , CAPA_GRD_CODE,VLTG_GRD_CODE,RSST_GRD_CODE,DEFECT_QTY,PACK_MOVE_QTY,UNHOLD_EXP_DATE'+ char(10)
  SET @v_dSql += '	 , QMS_HOLD_YN,MES_MAP_SLOC,MES_HOLD_YN,MES_UNHOLD_DATE,QMS_HOLD_DATE,QMS_UNHOLD_EXP_DATE'+ char(10)
  SET @v_dSql += '	 , QMS_UNHOLD_DATE,SECOND_OCV_TIME,SECOND_OCV_EXP_DATE,LONG_TERM_FLAG,QLTY_NO_INSP_FLAG'+ char(10)
  SET @v_dSql += '	 , LOT_PACKING_TYPE,POSITION_CATEGORY,DETAIL_POSITION,LOT_COUNT,COATING_LINE_ID'+ char(10)
  SET @v_dSql += '	 , PACK_MOVE_FLAG,ELEC_POST_HOLD_YN,FROM_PLANT_ID'+ char(10)
  SET @v_dSql += '	 , A.WORK_REQUEST_MODEL_ID,A.VERSION'+ char(10)
  --SET @v_dSql += '	 , CASE WHEN A.VERSION = ''---'' AND PRODUCTION_TYPE = ''TEST'' THEN ''Z53'' ELSE ''043'' END AS VERSION'+ char(10)
  SET @v_dSql += '	 , PROD_SEQ'+ char(10)
  SET @v_dSql += '	 , PLM_EC_NO'+ char(10)
  SET @v_dSql += 'INTO #FP_STOCH_H'+ char(10)
  SET @v_dSql += 'FROM   SCM_STOCK_H_V A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'WHERE  1=1'+ char(10)
  --SET @v_dSql += 'AND    A.DIVISION_ID = ''81'''+ char(10)
  --SET @v_dSql += 'AND    A.SITE_ID = ''A004'''+ char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID ' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID ' , 'EQ', @p_item_id)) + char(10)
--  SET @v_dSql += 'AND    A.CUTOFF_DATE = ''2022-11-08'''+ char(10)
  SET @v_dSql += 'AND    A.CUTOFF_DATE = ''' + @p_plan_date +''''+ char(10)

  --12/21
  SET @v_dSql += 'AND    EXISTS ('+ char(10)
  SET @v_dSql += '	SELECT 1'+ char(10)
  SET @v_dSql += '	FROM   #COATER_SITE WW WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	WHERE  A.DIVISION_ID = WW.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND    A.SITE_ID     = WW.SITE_ID'+ char(10)
  SET @v_dSql += ')'+ char(10)

  --SET @v_dSql += '--AND    A.ITEM_ID IN (''APCAN1437A'',''APCCA1494A'')'+ char(10)
  SET @v_dSql += ';'+ char(10)

  ----------------------------------------------
  --= P/C ITEM을 입고받는 조립 PLANT ID 리스트 =--
  SET @v_dSql += 'SELECT A.INSTANCE_ID, A.DIVISION_ID, A.COMPANY_ID, A.SITE_ID, A.PLANT_ID, B.PLANT_ID AS ASSY_PLANT_ID, B.DIVISION_ID AS ASSY_DIVISION_ID '+ char(10)
  SET @v_dSql += 'INTO #INS_PLANT '+ char(10)
  SET @v_dSql += 'FROM ( '+ char(10)-- 전극 인스턴스 정보 --
  SET @v_dSql += '	SELECT DISTINCT INSTANCE_ID ,COMPANY_ID ,DIVISION_ID ,SITE_ID ,PLANT_ID '+ char(10)
  SET @v_dSql += '	FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '	WHERE  INSTANCE_TYPE = ''E'' '+ char(10)
  SET @v_dSql += ') A '+ char(10)
  SET @v_dSql += 'INNER JOIN ( '+ char(10) -- 전극 인스턴스의 조립 PLANT --
  SET @v_dSql += '	SELECT DISTINCT COMPANY_ID ,SITE_ID ,PLANT_ID , DIVISION_ID '+ char(10)
  SET @v_dSql += '	FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '	WHERE  INSTANCE_TYPE = ''A'' '+ char(10)
  SET @v_dSql += ') B '+ char(10)
  SET @v_dSql += 'ON    A.COMPANY_ID  =  B.COMPANY_ID '+ char(10)
  SET @v_dSql += 'AND   A.SITE_ID     =  B.SITE_ID '+ char(10)
  SET @v_dSql += 'WHERE A.INSTANCE_ID =  ''' + @p_instance_id + ''' '+ char(10)
  SET @v_dSql += '; '+ char(10)
  SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE '+ char(10)
  SET @v_dSql += '     , SUM(A.SHIP_QTY) AS SHIP_QTY, SUM(A.SHIP_IN_QTY) AS SHIP_IN_QTY '+ char(10)
  SET @v_dSql += '	 , ROUND(SUM(A.SHIP_QTY)*ISNULL(MAX(B.VALUE),1), 0) AS SHIP_CELL_QTY, ROUND(SUM(A.SHIP_IN_QTY)*ISNULL(MAX(B.VALUE),1), 0) AS SHIP_IN_CELL_QTY '+ char(10)
  SET @v_dSql += 'INTO #SHIP_INFO '+ char(10)
  SET @v_dSql += 'FROM ( '+ char(10)
					-- Shipment - 계획구간
					-- SSP Shipping Plan 으로 변경... 20200722
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.SHIP_DATE,112) AS PLAN_DATE '+ char(10)
  SET @v_dSql += '		 , ISNULL(SUM(A.SHIP_QTY),0) AS SHIP_QTY, 0 AS SHIP_IN_QTY '+ char(10)
  SET @v_dSql += '	FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '	INNER JOIN ( '+ char(10)
  SET @v_dSql += '		SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID '+ char(10)
  SET @v_dSql += '		FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '		WHERE  A.INSTANCE_ID = ''' + @p_instance_id + ''' '+ char(10)
  SET @v_dSql += '	) B '+ char(10)
  SET @v_dSql += '	ON  A.COMPANY_ID  = B.COMPANY_ID '+ char(10)
  SET @v_dSql += '	AND A.DIVISION_ID = B.DIVISION_ID '+ char(10)
  SET @v_dSql += '	AND A.SITE_ID     = B.SITE_ID '+ char(10)
  SET @v_dSql += '	AND A.PLANT_ID    = B.PLANT_ID '+ char(10)
  SET @v_dSql += '	WHERE CONVERT(VARCHAR,A.SHIP_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' '+ char(10)
  SET @v_dSql += '	AND		EXISTS ( '+ char(10)
  SET @v_dSql += '		SELECT 1 '+ char(10)
  SET @v_dSql += '		FROM   ( '+ char(10)
  SET @v_dSql += '			SELECT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, MAX(SCP_PLAN_ID) AS SCP_PLAN_ID '+ char(10)
  SET @v_dSql += '			FROM	 FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '			WHERE	 1=1 '+ char(10)
  SET @v_dSql += '			AND		 A.SHOP_GROUP_ID = ''E'' '+ char(10)
  SET @v_dSql += '			GROUP BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID '+ char(10)
  SET @v_dSql += '		) X '+ char(10)
  SET @v_dSql += '		WHERE	1=1 '+ char(10)
  SET @v_dSql += '		AND		X.DIVISION_ID = A.DIVISION_ID '+ char(10)
  SET @v_dSql += '		AND		X.SITE_ID     = A.SITE_ID '+ char(10)
  SET @v_dSql += '		AND		X.PLANT_ID    = A.PLANT_ID '+ char(10)
  SET @v_dSql += '		AND		X.SCP_PLAN_ID = A.SCP_PLAN_ID '+ char(10)
  SET @v_dSql += '	) '+ char(10)
  SET @v_dSql += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.SHIP_DATE,112) '+ char(10)
	-- Shipment - 과거구간
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.SHIP_DATE AS PLAN_DATE '+ char(10)
  SET @v_dSql += '		 , ISNULL(A.QTY,0) AS SHIP_QTY, 0 AS SHIP_IN_QTY '+ char(10)
  SET @v_dSql += '	FROM ( '+ char(10)
  SET @v_dSql += '		SELECT V.INSTANCE_ID AS INSTANCE_ID, '+ char(10)
  SET @v_dSql += '			   A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.SHIP_DATE, SUM(QTY) AS QTY '+ char(10)
  SET @v_dSql += '		FROM   SCM_SHIPPING_RESULT_H A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '		INNER JOIN FP_INSTANCE_PANCAKE_V V WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '		ON 1=1 '+ char(10)
  SET @v_dSql += '		AND	V.INSTANCE_ID 	= ''' + @p_instance_id + ''' '+ char(10)
  SET @v_dSql += '		AND	V.GUBUN			= ''ASSY'' '+ char(10)
  SET @v_dSql += '		AND	V.ACTIVE_FLAG	= ''Y'' '+ char(10)
  SET @v_dSql += '		AND	A.COMPANY_ID	= V.COMPANY_ID '+ char(10)
  SET @v_dSql += '		AND	A.DIVISION_ID	= V.DIVISION_ID '+ char(10)
  SET @v_dSql += '		AND A.SITE_ID		= V.SITE_ID '+ char(10)
  SET @v_dSql += '		AND A.PLANT_ID		= V.PLANT_ID , '+ char(10)
  SET @v_dSql += '		SCM_ITEM_M B WITH(NOLOCK), '+ char(10)
  SET @v_dSql += '		SCM_ITEM_CLASS_M C WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '		WHERE 1=1 '+ char(10)
  SET @v_dSql += '		AND   A.QTY > 0 '+ char(10)
  SET @v_dSql += '		AND 	A.COMPANY_ID = B.COMPANY_ID '+ char(10)
  SET @v_dSql += '		AND 	A.SITE_ID = B.SITE_ID '+ char(10)
  SET @v_dSql += '		AND 	A.DIVISION_ID = B.DIVISION_ID '+ char(10)
  --SET @v_dSql += '		AND 	A.PLANT_ID NOT IN (''3050'') '+ char(10)
  set @v_dSql += '    AND  A.PLANT_ID NOT in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00623_PANCAKE_SIMUL_ELEC_TUNING'' AND SEGMENT1  = ''0'' AND ACTIVE_FLAG = ''Y'')   ' + char(10)

  SET @v_dSql += '		AND 	A.ITEM_ID = B.ITEM_ID '+ char(10)
  SET @v_dSql += '		AND 	A.SHIP_DATE  <= ''' + @p_plan_date + ''' '+ char(10)
  SET @v_dSql += '		AND 	A.SHIP_DATE >= ''' + @p_bucket_from + ''' '+ char(10)
  SET @v_dSql += '		AND 	B.ACTIVE_FLAG = ''Y'' '+ char(10)
  SET @v_dSql += '		AND 	B.ITEM_CLASS = C.CLASS_ID '+ char(10)
  SET @v_dSql += '		AND 	C.LEVEL_2_NAME = ''Pancake'' '+ char(10)
  SET @v_dSql += '		GROUP BY V.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.SHIP_DATE '+ char(10)
  SET @v_dSql += '	) A '+ char(10)
	                -- Receipt Plan --
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.ETA_DATE AS PLAN_DATE '+ char(10)
  SET @v_dSql += '		 , 0 AS SHIP_QTY, ISNULL(A.QTY,0) AS SHIP_IN_QTY '+ char(10)
  SET @v_dSql += '	FROM ( '+ char(10)
  SET @v_dSql += '			SELECT A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.ETA_DATE,112) AS ETA_DATE, SUM(A.QTY) AS QTY '+ char(10)
  SET @v_dSql += '			FROM   ( '+ char(10)
  SET @v_dSql += '						SELECT ''' + @p_instance_id + ''' AS INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID '+ char(10)
  SET @v_dSql += '							 , (CASE WHEN ISNULL(A.ETA_DATE,'''') < ''' + @p_plan_date + ''' THEN ''' + @p_plan_date + ''' ELSE ISNULL(A.ETA_DATE,'''') END) AS ETA_DATE '+ char(10)
  SET @v_dSql += '							 , A.INTRANSIT_QTY AS QTY '+ char(10)
  SET @v_dSql += '						FROM   FP_MRP_INTRANSIT_H A WITH(NOLOCK), '+ char(10)
  SET @v_dSql += '							   SCM_ITEM_M B WITH(NOLOCK), '+ char(10)
  SET @v_dSql += '							   SCM_ITEM_CLASS_M C WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '						WHERE 1=1 '+ char(10)
  SET @v_dSql += '						AND   A.INTRANSIT_QTY > 0 '+ char(10)
  SET @v_dSql += '						AND   A.COMPANY_ID  = B.COMPANY_ID '+ char(10)
  SET @v_dSql += '						AND   A.DIVISION_ID = B.DIVISION_ID '+ char(10)
  SET @v_dSql += '						AND   A.SITE_ID     = B.SITE_ID '+ char(10)
  SET @v_dSql += '						AND   A.ITEM_ID     = B.ITEM_ID '+ char(10)
  SET @v_dSql += '						AND   B.ACTIVE_FLAG = ''Y'' '+ char(10)
  SET @v_dSql += '						AND   B.ITEM_CLASS  = C.CLASS_ID '+ char(10)
  SET @v_dSql += '						AND   C.LEVEL_2_NAME = ''Pancake'' '+ char(10)
  SET @v_dSql += '						AND	  EXISTS ( '+ char(10)
  SET @v_dSql += '								SELECT 1 '+ char(10)
  SET @v_dSql += '								FROM   FP_INSTANCE_PANCAKE_V V WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '								WHERE  1=1 '+ char(10)
  SET @v_dSql += '								AND	V.INSTANCE_ID = ''' + @p_instance_id + ''' '+ char(10)
  SET @v_dSql += '								AND	V.GUBUN       = ''RECEIPT'' '+ char(10)
  SET @v_dSql += '								AND	V.ACTIVE_FLAG	= ''Y'' '+ char(10)
  SET @v_dSql += '								AND	A.COMPANY_ID	= V.COMPANY_ID '+ char(10)
  SET @v_dSql += '								AND	A.DIVISION_ID	= V.DIVISION_ID '+ char(10)
  SET @v_dSql += '								AND A.SITE_ID		  = V.SITE_ID '+ char(10)
  SET @v_dSql += '						) '+ char(10)
  SET @v_dSql += '						UNION ALL '+ char(10)
	                                    --= Shipment_In List: 미래의 선적계획 =--
  SET @v_dSql += '						SELECT ''' + @p_instance_id + ''' AS INSTANCE_ID, V.COMPANY_ID, V.DIVISION_ID, A.TO_SITE_ID AS SITE_ID, V.PLANT_ID '+ char(10)
  SET @v_dSql += '							 , A.ITEM_ID, A.RECEIVE_YYYYMMDD AS ETA_DATE, A.SHIP_QTY AS QTY '+ char(10)
  SET @v_dSql += '						FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '						INNER JOIN #INS_PLANT V '+ char(10)
  SET @v_dSql += '						ON  1=1 '+ char(10)
  SET @v_dSql += '						AND A.TO_SITE_ID  = V.SITE_ID '+ char(10)
  SET @v_dSql += '						AND A.TO_PLANT_ID = V.ASSY_PLANT_ID '+ char(10)
  SET @v_dSql += '						WHERE	1=1 '+ char(10)
  SET @v_dSql += '						AND		EXISTS ( '+ char(10)
  SET @v_dSql += '							SELECT 1 '+ char(10)
  SET @v_dSql += '							FROM   ( '+ char(10)
  SET @v_dSql += '								SELECT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, MAX(SCP_PLAN_ID) AS SCP_PLAN_ID '+ char(10)
  SET @v_dSql += '								FROM	 FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '								WHERE	 1=1 '+ char(10)
  SET @v_dSql += '								AND		 A.SHOP_GROUP_ID = ''E'' '+ char(10)
  SET @v_dSql += '								GROUP BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID '+ char(10)
  SET @v_dSql += '							) X '+ char(10)
  SET @v_dSql += '							WHERE	1=1 '+ char(10)
  SET @v_dSql += '							AND		X.DIVISION_ID = A.DIVISION_ID '+ char(10)
  SET @v_dSql += '							AND		X.SITE_ID     = A.SITE_ID '+ char(10)
  SET @v_dSql += '							AND		X.PLANT_ID    = A.PLANT_ID '+ char(10)
  SET @v_dSql += '							AND		X.SCP_PLAN_ID = A.SCP_PLAN_ID '+ char(10)
  SET @v_dSql += '						) '+ char(10)
  SET @v_dSql += '						AND		A.PLANT_ID <> A.TO_PLANT_ID	'+ char(10) -- 같은건 to 가 외주로 가기 때문에 제외한다.
  SET @v_dSql += '						AND		A.SHIP_QTY > 0 '+ char(10)
  SET @v_dSql += '						AND		A.RECEIVE_YYYYMMDD >= ''' + @p_plan_date + ''' '+ char(10)  ---+ 미래의 선적계획만 가져온다.
  SET @v_dSql += '						UNION ALL '+ char(10)
                 						-- SCP INTRANSIT 정보 추가... 20200722
  SET @v_dSql += '						SELECT ''' + @p_instance_id + ''' AS INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, V.PLANT_ID, A.ITEM_ID '+ char(10)
  SET @v_dSql += '							 , CASE WHEN A.ETA_DATE < CONVERT(VARCHAR, ''' + @p_plan_date + ''',112) THEN CONVERT(VARCHAR, ''' + @p_plan_date + ''',112) ELSE A.ETA_DATE END ETA_DATE '+ char(10) --+ 만약 도착일자가 과거면 오늘날짜로 강제보정
  SET @v_dSql += '							 , DELIVERY_QTY AS QTY '+ char(10)
  SET @v_dSql += '						FROM   FP_SCM_IN_TRANSIT_H A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '							 , SCM_ITEM_M B WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '							 , SCM_ITEM_CLASS_M C WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '							 , #INS_PLANT V '+ char(10)
  SET @v_dSql += '						WHERE  A.DELIVERY_QTY > 0 '+ char(10)
  SET @v_dSql += '						AND    A.RESULT_DATE  = CONVERT(VARCHAR, DATEADD(DD, -1, CONVERT(DATE, ''' + @p_plan_date + ''') ),112) '+ char(10) --> D-1일로 조회해야 함.
  SET @v_dSql += '						AND    A.COMPANY_ID   = B.COMPANY_ID '+ char(10)
  SET @v_dSql += '						AND    A.DIVISION_ID  = B.DIVISION_ID '+ char(10)
  SET @v_dSql += '						AND    A.SITE_ID      = B.SITE_ID '+ char(10)
  SET @v_dSql += '						AND    A.ITEM_ID      = B.ITEM_ID '+ char(10)
  SET @v_dSql += '						AND    B.ACTIVE_FLAG  = ''Y'' '+ char(10)
  SET @v_dSql += '						AND    B.ITEM_CLASS   = C.CLASS_ID '+ char(10)
  SET @v_dSql += '						AND    C.LEVEL_2_NAME = ''Pancake'' '+ char(10)
  SET @v_dSql += '						AND    A.COMPANY_ID   = V.COMPANY_ID '+ char(10)
  SET @v_dSql += '						AND    A.SITE_ID      = V.SITE_ID '+ char(10)
  SET @v_dSql += '						AND    A.PLANT_ID     = V.ASSY_PLANT_ID '+ char(10)
  SET @v_dSql += '			) A '+ char(10)
  SET @v_dSql += '			WHERE 1=1 '+ char(10)
  SET @v_dSql += '			GROUP BY A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.ETA_DATE,112) '+ char(10)
  SET @v_dSql += '	) A '+ char(10)
  SET @v_dSql += ') A '+ char(10)
  SET @v_dSql += 'LEFT OUTER JOIN #ITEM_CALC B WITH(NOLOCK) '+ char(10)
  SET @v_dSql += 'ON    1=1 '+ char(10)
  SET @v_dSql += 'AND   A.COMPANY_ID  = B.COMPANY_ID '+ char(10)
  SET @v_dSql += 'AND   A.DIVISION_ID = B.DIVISION_ID '+ char(10)
  SET @v_dSql += 'AND   A.SITE_ID     = B.SITE_ID '+ char(10)
  SET @v_dSql += 'AND   A.ITEM_ID     = B.ITEM_ID '+ char(10)
  SET @v_dSql += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE '+ char(10)
  SET @v_dSql += '; '+ char(10)

  --SET @v_dSql += '-- select * from #ITEM_CALC'+ char(10)
  --SET @v_dSql += '-- SELECT * FROM #BASIS_BOH'+ char(10)
  SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROD_NAME, A.ITEM_ID, A.NICK_NAME, A.CATEGORY_ID, A.CATEGORY_NAME'+ char(10)
  SET @v_dSql += '	 , SUM(A.STOCK_QTY) AS STOCK_QTY'+ char(10)
  SET @v_dSql += '	 , SUM(A.REWORK_QTY) AS REWORK_QTY'+ char(10)
  SET @v_dSql += '	 , SUM(A.BOFORE_NT_QTY) AS BOFORE_NT_QTY'+ char(10)
  SET @v_dSql += '	 , SUM(A.PANCAKE_GOOD_QTY) AS PANCAKE_GOOD_QTY'+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = 1 THEN A.STOCK_QTY+A.BOFORE_NT_QTY ELSE 0 END) AS PANCAKE_GOOD_QTY2'+ char(10)
  SET @v_dSql += '	 , ROUND(SUM(A.STOCK_QTY)*ISNULL(MAX(B.VALUE),1), 0) AS STOCK_CELL_QTY'+ char(10)
  SET @v_dSql += '	 , ROUND(SUM(A.REWORK_QTY)*ISNULL(MAX(B.VALUE),1), 0) AS REWORK_CELL_QTY'+ char(10)
  SET @v_dSql += '	 , ROUND(SUM(A.BOFORE_NT_QTY)*ISNULL(MAX(B.VALUE),1), 0) AS BOFORE_NT_CELL_QTY'+ char(10)
  SET @v_dSql += '	 , ROUND(SUM(A.PANCAKE_GOOD_QTY)*ISNULL(MAX(B.VALUE),1), 0) AS PANCAKE_GOOD_CELL_QTY'+ char(10)
  SET @v_dSql += '	 , ROUND(SUM(CASE WHEN A.CATEGORY_ID = 1 THEN A.STOCK_QTY+A.BOFORE_NT_QTY ELSE 0 END)*ISNULL(MAX(B.VALUE),1), 0) AS PANCAKE_GOOD_CELL_QTY2'+ char(10)
  SET @v_dSql += 'INTO #BASIS_BOH'+ char(10)
  SET @v_dSql += 'FROM ('+ char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID'+ char(10)
  SET @v_dSql += '		 , C.LEVEL_3_NAME AS PROD_NAME'+ char(10)
  SET @v_dSql += '		 , A.WORK_REQUEST_MODEL_ID AS MODEL_ID'+ char(10)
  SET @v_dSql += '		 , A.ITEM_ID, B.NICK_NAME'+ char(10)
  SET @v_dSql += '		 , CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''TEST'' ELSE ''MASS'' END AS PRODUCTION_TYPE'+ char(10)
  SET @v_dSql += '		 , A.VERSION'+ char(10)
  SET @v_dSql += '		 , ''1'' AS CATEGORY_ID, ''1.GOOD'' AS CATEGORY_NAME'+ char(10)
  SET @v_dSql += '		 , ROUND(SUM(CASE WHEN A.OPERATION_ID IN (''E2000'',''E3000'') THEN A.QTY*A.LANE*ISNULL(Y1.YIELD,1)*ISNULL(Y2.YIELD,1)'+ char(10)
  SET @v_dSql += '		  		    WHEN A.OPERATION_ID = ''E4000'' AND LANE != 1 THEN A.QTY*A.LANE*ISNULL(Y1.YIELD,1)'+ char(10)
  SET @v_dSql += '		  		    WHEN A.OPERATION_ID = ''E4100'' THEN 0'+ char(10)
  SET @v_dSql += '		  		    WHEN A.OPERATION_ID = ''A5000'' THEN 0'+ char(10)
  SET @v_dSql += '		  		    ELSE A.QTY*A.LANE END),0) AS STOCK_QTY'+ char(10)
  SET @v_dSql += '		 , ROUND(SUM(CASE WHEN A.OPERATION_ID = ''E4100'' THEN A.QTY*A.LANE ELSE 0 END),0) AS REWORK_QTY'+ char(10)
  SET @v_dSql += '		 , ROUND(SUM(CASE WHEN A.OPERATION_ID = ''A5000'' THEN A.QTY*A.LANE ELSE 0 END),0) AS BOFORE_NT_QTY'+ char(10)
  SET @v_dSql += '		 , ROUND(SUM(CASE WHEN A.LANE = 1 THEN A.QTY*A.LANE ELSE 0 END),0) AS PANCAKE_GOOD_QTY'+ char(10)
  SET @v_dSql += '	FROM   #FP_STOCH_H A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	, SCM_ITEM_M B WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	LEFT OUTER JOIN #ITEM_YIELD Y1 WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	ON 	1=1'+ char(10)
  SET @v_dSql += '	AND	B.COMPANY_ID  = Y1.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND	B.DIVISION_ID = Y1.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND	B.SITE_ID     = Y1.SITE_ID'+ char(10)
  SET @v_dSql += '	AND B.ITEM_ID     = Y1.ITEM_ID'+ char(10)
  SET @v_dSql += '	AND Y1.OPERATION_ID = ''E3000'''+ char(10)
  SET @v_dSql += '	LEFT OUTER JOIN #ITEM_YIELD Y2 WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	ON 	1=1'+ char(10)
  SET @v_dSql += '	AND	B.COMPANY_ID  = Y2.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND	B.DIVISION_ID = Y2.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND	B.SITE_ID     = Y2.SITE_ID'+ char(10)
  SET @v_dSql += '	AND B.ITEM_ID     = Y2.ITEM_ID'+ char(10)
  SET @v_dSql += '	AND Y2.OPERATION_ID = ''E4000'''+ char(10)
  SET @v_dSql += '	, SCM_ITEM_CLASS_M C WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	WHERE 1=1'+ char(10)
  SET @v_dSql += '	AND   A.CUTOFF_DATE = ''' + @p_plan_date +''''+ char(10)
  SET @v_dSql += '	AND   A.STOCK_TYPE  = ''WIP'''+ char(10)
  SET @v_dSql += '	AND   A.COMPANY_ID  = B.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND   A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND   A.SITE_ID     = B.SITE_ID'+ char(10)
  SET @v_dSql += '	AND   A.ITEM_ID     = B.ITEM_ID'+ char(10)
  SET @v_dSql += '	AND   B.ITEM_CLASS  = C.CLASS_ID'+ char(10)
  SET @v_dSql += '	AND   C.LEVEL_2_CODE = ''APC'''+ char(10)
  SET @v_dSql += '	AND   C.LEVEL_3_NAME != ''APCSR'''+ char(10)
  SET @v_dSql += '	AND   A.WIPHOLD_YN = ''N'''+ char(10)
  SET @v_dSql += '	AND   A.COMPANY_ID = B.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND   A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND   A.SITE_ID = B.SITE_ID'+ char(10)
  SET @v_dSql += '	AND   A.ITEM_ID = B.ITEM_ID'+ char(10)
  SET @v_dSql += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID'+ char(10)
  SET @v_dSql += '		   , C.LEVEL_3_NAME'+ char(10)
  SET @v_dSql += '		   , A.WORK_REQUEST_MODEL_ID'+ char(10)
  SET @v_dSql += '		   , A.ITEM_ID, B.NICK_NAME'+ char(10)
  SET @v_dSql += '		   , CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''TEST'' ELSE ''MASS'' END'+ char(10)
  SET @v_dSql += '		   , A.VERSION'+ char(10)
  
  --SET @v_dSql += '	-----------------------------------------------------'+ char(10)
  SET @v_dSql += '	UNION ALL'+ char(10)
  SET @v_dSql += '	SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID'+ char(10)
  SET @v_dSql += '		  , C.LEVEL_3_NAME AS PROD_NAME'+ char(10)
  SET @v_dSql += '		  , A.WORK_REQUEST_MODEL_ID AS MODEL_ID'+ char(10)
  SET @v_dSql += '		  , A.ITEM_ID, B.NICK_NAME'+ char(10)
  SET @v_dSql += '		  , CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''TEST'' ELSE ''MASS'' END AS PRODUCTION_TYPE'+ char(10)
  SET @v_dSql += '		  , A.VERSION'+ char(10)
  SET @v_dSql += '		  , ''2'' AS CATEGORY_ID, ''2.Additional QMS Hold'' AS CATEGORY_NAME'+ char(10)
  SET @v_dSql += '		  , ROUND(SUM(CASE WHEN A.OPERATION_ID IN (''E2000'',''E3000'') THEN A.QTY*A.LANE*ISNULL(Y1.YIELD,1)*ISNULL(Y2.YIELD,1)'+ char(10)
  SET @v_dSql += '		    	  	 WHEN A.OPERATION_ID = ''E4000'' AND LANE != 1 THEN A.QTY*A.LANE*ISNULL(Y1.YIELD,1)'+ char(10)
  SET @v_dSql += '		    	  	 WHEN A.OPERATION_ID = ''E4100'' THEN 0'+ char(10)
  SET @v_dSql += '		    	  	 WHEN A.OPERATION_ID = ''A5000'' THEN 0'+ char(10)
  SET @v_dSql += '		    	  	 ELSE A.QTY*A.LANE END),0) AS STOCK_QTY'+ char(10)
  SET @v_dSql += '		  , ROUND(SUM(CASE WHEN A.OPERATION_ID = ''E4100'' THEN A.QTY*A.LANE ELSE 0 END),0) AS REWORK_QTY'+ char(10)
  SET @v_dSql += '		  , ROUND(SUM(CASE WHEN A.OPERATION_ID = ''A5000'' THEN A.QTY*A.LANE ELSE 0 END),0) AS BOFORE_NT_QTY'+ char(10)
  SET @v_dSql += '		  , 0 AS PANCAKE_GOOD_QTY '+ char(10)
  SET @v_dSql += '	FROM 	#FP_STOCH_H A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	, SCM_ITEM_M B WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	LEFT OUTER JOIN #ITEM_YIELD Y1 WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	ON 	1=1'+ char(10)
  SET @v_dSql += '	AND	B.COMPANY_ID    = Y1.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND	B.DIVISION_ID   = Y1.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND	B.SITE_ID       = Y1.SITE_ID'+ char(10)
  SET @v_dSql += '	AND B.ITEM_ID       = Y1.ITEM_ID'+ char(10)
  SET @v_dSql += '	AND Y1.OPERATION_ID = ''E3000'''+ char(10)
  SET @v_dSql += '	LEFT OUTER JOIN #ITEM_YIELD Y2 WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	ON 	1=1'+ char(10)
  SET @v_dSql += '	AND	B.COMPANY_ID    = Y2.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND	B.DIVISION_ID   = Y2.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND	B.SITE_ID       = Y2.SITE_ID'+ char(10)
  SET @v_dSql += '	AND B.ITEM_ID       = Y2.ITEM_ID'+ char(10)
  SET @v_dSql += '	AND Y2.OPERATION_ID = ''E4000'''+ char(10)
  SET @v_dSql += '	, SCM_ITEM_CLASS_M C WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	WHERE 	1=1'+ char(10)
  SET @v_dSql += '	AND 	A.CUTOFF_DATE = ''' + @p_plan_date +''''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID ' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += '	AND 	A.STOCK_TYPE = ''WIP'''+ char(10)
  SET @v_dSql += '	AND 	A.COMPANY_ID = B.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND 	A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND 	A.SITE_ID = B.SITE_ID'+ char(10)
  SET @v_dSql += '	AND 	A.ITEM_ID = B.ITEM_ID'+ char(10)
  SET @v_dSql += '	AND 	B.ITEM_CLASS = C.CLASS_ID'+ char(10)
  SET @v_dSql += '	AND 	C.LEVEL_2_CODE = ''APC'''+ char(10)
  SET @v_dSql += '	AND 	C.LEVEL_3_NAME != ''APCSR'''+ char(10)
  SET @v_dSql += '	AND 	A.WIPHOLD_YN = ''Y'''+ char(10)
  SET @v_dSql += '	AND 	A.QMS_HOLD_YN = ''Y'''+ char(10)
  SET @v_dSql += '	AND 	A.COMPANY_ID = B.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND 	A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND 	A.SITE_ID = B.SITE_ID'+ char(10)
  SET @v_dSql += '	AND 	A.ITEM_ID = B.ITEM_ID'+ char(10)
  SET @v_dSql += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID'+ char(10)
  SET @v_dSql += '		   , C.LEVEL_3_NAME'+ char(10)
  SET @v_dSql += '		   , A.WORK_REQUEST_MODEL_ID'+ char(10)
  SET @v_dSql += '		   , A.ITEM_ID, B.NICK_NAME'+ char(10)
  SET @v_dSql += '		   , CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''TEST'' ELSE ''MASS'' END'+ char(10)
  SET @v_dSql += '		   , A.VERSION'+ char(10)
  --SET @v_dSql += '	--------------------------------------------'+ char(10)
  SET @v_dSql += '	UNION ALL'+ char(10)
  SET @v_dSql += '	SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID'+ char(10)
  SET @v_dSql += '		  , C.LEVEL_3_NAME AS PROD_NAME'+ char(10)
  SET @v_dSql += '		  , A.WORK_REQUEST_MODEL_ID AS MODEL_ID'+ char(10)
  SET @v_dSql += '		  , A.ITEM_ID, B.NICK_NAME'+ char(10)
  SET @v_dSql += '		  , CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''TEST'' ELSE ''MASS'' END AS PRODUCTION_TYPE'+ char(10)
  SET @v_dSql += '		  , A.VERSION'+ char(10)
  SET @v_dSql += '		  , ''3'' AS CATEGORY_ID, ''3.GMES Hold'' AS CATEGORY_NAME'+ char(10)
  SET @v_dSql += '		  , ROUND(SUM(CASE WHEN A.OPERATION_ID IN (''E2000'',''E3000'') THEN A.QTY*A.LANE*ISNULL(Y1.YIELD,1)*ISNULL(Y2.YIELD,1)'+ char(10)
  SET @v_dSql += '		    	     WHEN A.OPERATION_ID = ''E4000'' AND LANE != 1 THEN A.QTY*A.LANE*ISNULL(Y1.YIELD,1)'+ char(10)
  SET @v_dSql += '		    	     WHEN A.OPERATION_ID = ''E4100'' THEN 0'+ char(10)
  SET @v_dSql += '		    	     WHEN A.OPERATION_ID = ''A5000'' THEN 0'+ char(10)
  SET @v_dSql += '		    	     ELSE A.QTY*A.LANE END),0) AS STOCK_QTY'+ char(10)
  SET @v_dSql += '		  , ROUND(SUM(CASE WHEN A.OPERATION_ID = ''E4100'' THEN A.QTY*A.LANE ELSE 0 END),0) AS REWORK_QTY'+ char(10)
  SET @v_dSql += '		  , ROUND(SUM(CASE WHEN A.OPERATION_ID = ''A5000'' THEN A.QTY*A.LANE ELSE 0 END),0) AS BOFORE_NT_QTY'+ char(10)
  SET @v_dSql += '		  , 0 AS PANCAKE_GOOD_QTY '+ char(10)
  SET @v_dSql += '	FROM 	#FP_STOCH_H A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	, SCM_ITEM_M B WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	LEFT OUTER JOIN #ITEM_YIELD Y1 WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	ON 	1=1'+ char(10)
  SET @v_dSql += '	AND	B.COMPANY_ID  = Y1.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND	B.DIVISION_ID = Y1.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND	B.SITE_ID     = Y1.SITE_ID'+ char(10)
  SET @v_dSql += '	AND B.ITEM_ID     = Y1.ITEM_ID'+ char(10)
  SET @v_dSql += '	AND Y1.OPERATION_ID = ''E3000'''+ char(10)
  SET @v_dSql += '	LEFT OUTER JOIN #ITEM_YIELD Y2 WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	ON 	1=1'+ char(10)
  SET @v_dSql += '	AND	B.COMPANY_ID  = Y2.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND	B.DIVISION_ID = Y2.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND	B.SITE_ID     = Y2.SITE_ID'+ char(10)
  SET @v_dSql += '	AND B.ITEM_ID     = Y2.ITEM_ID'+ char(10)
  SET @v_dSql += '	AND Y2.OPERATION_ID = ''E4000'''+ char(10)
  SET @v_dSql += '	, SCM_ITEM_CLASS_M C WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	WHERE 	1=1'+ char(10)
  SET @v_dSql += '	AND 	A.CUTOFF_DATE = ''' + @p_plan_date +''''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID ' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += '	AND 	A.STOCK_TYPE = ''WIP'''+ char(10)
  SET @v_dSql += '	AND 	A.COMPANY_ID = B.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND 	A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND 	A.SITE_ID = B.SITE_ID'+ char(10)
  SET @v_dSql += '	AND 	A.ITEM_ID = B.ITEM_ID'+ char(10)
  SET @v_dSql += '	AND 	B.ITEM_CLASS = C.CLASS_ID'+ char(10)
  SET @v_dSql += '	AND 	C.LEVEL_2_CODE = ''APC'''+ char(10)
  SET @v_dSql += '	AND 	C.LEVEL_3_NAME != ''APCSR'''+ char(10)
  SET @v_dSql += '	AND 	A.WIPHOLD_YN = ''Y'''+ char(10)
  SET @v_dSql += '	AND 	A.QMS_HOLD_YN != ''Y'''+ char(10)
  SET @v_dSql += '	AND 	A.MES_HOLD_YN = ''Y'''+ char(10)
  SET @v_dSql += '	AND 	A.COMPANY_ID = B.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND 	A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND 	A.SITE_ID = B.SITE_ID'+ char(10)
  SET @v_dSql += '	AND 	A.ITEM_ID = B.ITEM_ID'+ char(10)
  SET @v_dSql += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID'+ char(10)
  SET @v_dSql += '		   , C.LEVEL_3_NAME'+ char(10)
  SET @v_dSql += '		   , A.WORK_REQUEST_MODEL_ID'+ char(10)
  SET @v_dSql += '		   , A.ITEM_ID, B.NICK_NAME'+ char(10)
  SET @v_dSql += '		   , CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''TEST'' ELSE ''MASS'' END'+ char(10)
  SET @v_dSql += '		   , A.VERSION'+ char(10)
  SET @v_dSql += ') A'+ char(10)
  SET @v_dSql += 'LEFT OUTER JOIN #ITEM_CALC B WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'ON  1=1'+ char(10)
  SET @v_dSql += 'AND A.COMPANY_ID  = B.COMPANY_ID'+ char(10)
  SET @v_dSql += 'AND A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += 'AND A.SITE_ID     = B.SITE_ID'+ char(10)
  SET @v_dSql += 'AND A.ITEM_ID     = B.ITEM_ID'+ char(10)
  SET @v_dSql += 'WHERE 1=1 '+ char(10)
  SET @v_dSql += 'AND   A.VERSION IS NOT NULL '+ char(10)
  SET @v_dSql += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROD_NAME, A.ITEM_ID, A.NICK_NAME, A.CATEGORY_ID, A.CATEGORY_NAME'+ char(10)
  SET @v_dSql += ';'+ char(10)+char(10)
  --SET @v_dSql += '---------------------- 재고관련 끝 ----------------------------'+ char(10)

  SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, B.CATEGORY_ID'+ char(10)

  		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
		
				-- date info
				SET @mst_loop_cnt = 0;
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = ''
					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END
					--SET @v_dSql += '     , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID = ''1'' THEN A.ASSY_M_QTY ELSE A.ELEC_M_QTY END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10) -- -- cell 은 ELEC_CELL_QTY, ASSY_CELL_QTY'+ char(10)
					--SET @v_dSql += '     , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID = ''1'' THEN A.ASSY_CELL_QTY ELSE A.ELEC_CELL_QTY END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_CELL'+ char(10) -- -- cell 은 ELEC_CELL_QTY, ASSY_CELL_QTY'+ char(10)

					SET @v_dSql += '     , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID = ''100'' THEN A.ASSY_M_QTY '+ char(10)
					SET @v_dSql += '	                                                     WHEN B.CATEGORY_ID = ''200'' THEN A.ELEC_POST_M_QTY '+ char(10)
					SET @v_dSql += '														 WHEN B.CATEGORY_ID = ''300'' THEN A.ELEC_M_QTY '+ char(10)
					SET @v_dSql += '														 WHEN B.CATEGORY_ID = ''150'' THEN A.SHIP_QTY '+ char(10)
					SET @v_dSql += '														 WHEN B.CATEGORY_ID = ''500'' THEN A.SHIP_IN_QTY '+ char(10)
					SET @v_dSql += '														 ELSE 0 END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
					SET @v_dSql += '     , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID = ''100'' THEN A.ASSY_CELL_QTY '+ char(10)
					SET @v_dSql += '	                                                     WHEN B.CATEGORY_ID = ''200'' THEN A.ELEC_POST_CELL_QTY '+ char(10)
					SET @v_dSql += '														 WHEN B.CATEGORY_ID = ''300'' THEN A.ELEC_CELL_QTY '+ char(10)
					SET @v_dSql += '														 WHEN B.CATEGORY_ID = ''150'' THEN A.SHIP_CELL_QTY '+ char(10)
					SET @v_dSql += '														 WHEN B.CATEGORY_ID = ''500'' THEN A.SHIP_IN_CELL_QTY '+ char(10)
					SET @v_dSql += '														 ELSE 0 END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_CELL '+ char(10)

  				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt
		
		END		-- end of isnull(@p_bucket,'') <> ''
  
  SET @v_dSql += 'INTO #MAIN'+ char(10)
  SET @v_dSql += 'FROM ('+ char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '		 , SUM(A.ELEC_M_QTY) AS ELEC_M_QTY, SUM(A.ELEC_CELL_QTY) AS ELEC_CELL_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(A.ELEC_POST_M_QTY) AS ELEC_POST_M_QTY, SUM(A.ELEC_POST_CELL_QTY) AS ELEC_POST_CELL_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(A.ASSY_M_QTY) AS ASSY_M_QTY, SUM(A.ASSY_CELL_QTY) AS ASSY_CELL_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(A.SHIP_QTY) AS SHIP_QTY, SUM(A.SHIP_CELL_QTY) AS SHIP_CELL_QTY '+ char(10)
  SET @v_dSql += '		 , SUM(A.SHIP_IN_QTY) AS SHIP_IN_QTY, SUM(A.SHIP_IN_CELL_QTY) AS SHIP_IN_CELL_QTY '+ char(10)
  SET @v_dSql += '	FROM ('+ char(10)
  SET @v_dSql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PANCAKE_ITEM AS ITEM_ID, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '			 , A.PANCAKE_IN_QTY AS ELEC_M_QTY, A.CELL_IN_QTY AS ELEC_CELL_QTY'+ char(10)
  SET @v_dSql += '			 , A.PANCAKE_IN_POST_QTY AS ELEC_POST_M_QTY, A.CELL_IN_POST_QTY AS ELEC_POST_CELL_QTY'+ char(10)
  SET @v_dSql += '			 , 0 AS ASSY_M_QTY, 0 ASSY_CELL_QTY'+ char(10)
  SET @v_dSql += '			 , 0 AS SHIP_QTY, 0 AS SHIP_CELL_QTY '+ char(10)
  SET @v_dSql += '			 , 0 AS SHIP_IN_QTY, 0 AS SHIP_IN_CELL_QTY '+ char(10)
  SET @v_dSql += '		FROM   #COATER_PLAN A WITH(NOLOCK)'+ char(10) 
  SET @v_dSql += '		UNION ALL'+ char(10)
  SET @v_dSql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PANCAKE_ITEM AS ITEM_ID, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '			 , 0 AS ELEC_M_QTY, 0 AS ELEC_CELL_QTY'+ char(10)
  SET @v_dSql += '			 , 0 AS ELEC_POST_M_QTY, 0 AS ELEC_POST_CELL_QTY'+ char(10)
  SET @v_dSql += '			 , A.PANCAKE_IN_QTY AS ASSY_M_QTY, A.CELL_IN_QTY AS ASSY_CELL_QTY'+ char(10)
  SET @v_dSql += '			 , 0 AS SHIP_QTY, 0 AS SHIP_CELL_QTY '+ char(10)
  SET @v_dSql += '			 , 0 AS SHIP_IN_QTY, 0 AS SHIP_IN_CELL_QTY '+ char(10)
  SET @v_dSql += '		FROM   #ASSY_PLAN A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '		UNION ALL '+ char(10)
  SET @v_dSql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE '+ char(10)
  SET @v_dSql += '			 , 0 AS ELEC_M_QTY, 0 AS ELEC_CELL_QTY '+ char(10)
  SET @v_dSql += '			 , 0 AS ELEC_POST_M_QTY, 0 AS ELEC_POST_CELL_QTY'+ char(10)
  SET @v_dSql += '			 , 0 AS ASSY_M_QTY, 0 AS ASSY_CELL_QTY '+ char(10)
  SET @v_dSql += '			 , A.SHIP_QTY, A.SHIP_CELL_QTY '+ char(10)
  SET @v_dSql += '			 , A.SHIP_IN_QTY, A.SHIP_IN_CELL_QTY '+ char(10)
  SET @v_dSql += '		FROM   #SHIP_INFO A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '	) A'+ char(10)
  SET @v_dSql += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE'+ char(10)
  SET @v_dSql += ') A'+ char(10)
  SET @v_dSql += ', ('+ char(10)
  SET @v_dSql += '	SELECT ''100'' AS CATEGORY_ID '+ char(10)
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT ''200'' AS CATEGORY_ID '+ char(10)
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT ''300'' AS CATEGORY_ID '+ char(10)
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT ''150'' AS CATEGORY_ID '+ char(10)
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT ''500'' AS CATEGORY_ID '+ char(10)
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT ''700'' AS CATEGORY_ID '+ char(10)
  SET @v_dSql += ') B'+ char(10)
  SET @v_dSql += 'WHERE 1=1'+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID ' , 'EQ', @p_item_id)) + char(10)
  SET @v_dSql += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, B.CATEGORY_ID'+ char(10)
  SET @v_dSql += ';'+ char(10)
  --SET @v_dSql += '-- INVENTORY
  SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, ''600'' AS CATEGORY_ID'+ char(10)

   		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN
		
				-- date info
				SET @mst_loop_cnt = 0;
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = ''
					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END
  --SET @v_dSql += '     , SUM(CASE WHEN A.PLAN_DATE >= ''20221205'' AND A.PLAN_DATE <= ''20221205'' THEN A.EOH_QTY ELSE 0 END) AS D0 -- cell 은 EOH_CELL_QTY'+ char(10)
  --SET @v_dSql += '	 , SUM(CASE WHEN A.PLAN_DATE >= ''20221205'' AND A.PLAN_DATE <= ''20221206'' THEN A.EOH_QTY ELSE 0 END) AS D1'+ char(10)
  --SET @v_dSql += '	 , SUM(CASE WHEN A.PLAN_DATE >= ''20221205'' AND A.PLAN_DATE <= ''20221207'' THEN A.EOH_QTY ELSE 0 END) AS D2'+ char(10)
  --SET @v_dSql += '	 , SUM(CASE WHEN A.PLAN_DATE >= ''20221205'' AND A.PLAN_DATE <= ''20221208'' THEN A.EOH_QTY ELSE 0 END) AS D3'+ char(10)
  --SET @v_dSql += '	 , SUM(CASE WHEN A.PLAN_DATE >= ''20221205'' AND A.PLAN_DATE <= ''20221209'' THEN A.EOH_QTY ELSE 0 END) AS D4'+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.PLAN_DATE >= ''' + @p_plan_date + ''' AND A.PLAN_DATE <= ''' + @sub_param_0 + ''' THEN A.EOH_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10) 
  SET @v_dSql += '	 , SUM(CASE WHEN A.PLAN_DATE >= ''' + @p_plan_date + ''' AND A.PLAN_DATE <= ''' + @sub_param_0 + ''' THEN A.EOH_CELL_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_CELL'+ char(10) 
  				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt
		
		END		-- end of isnull(@p_bucket,'') <> ''

  SET @v_dSql += 'INTO #MAIN_I'+ char(10)
  SET @v_dSql += 'FROM ('+ char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE'+ char(10)
  -- 기존로직으로 되돌림
  SET @v_dSql += '		 , (CASE WHEN A.PLAN_DATE = ''' + @p_plan_date + ''' THEN (ISNULL(MAX(B.PANCAKE_GOOD_QTY2),0)) ELSE 0 END) + ISNULL(SUM(A.ELEC_M_QTY),0) - ISNULL(SUM(A.ASSY_M_QTY),0) AS EOH_QTY '+ char(10) -- pancake eoh
  SET @v_dSql += '		 , (CASE WHEN A.PLAN_DATE = ''' + @p_plan_date + ''' THEN (ISNULL(MAX(B.PANCAKE_GOOD_CELL_QTY2),0)) ELSE 0 END) + ISNULL(SUM(A.ELEC_CELL_QTY),0) - ISNULL(SUM(A.ASSY_CELL_QTY),0) AS EOH_CELL_QTY '+ char(10) -- cell eoh
  -- 팬케잌 완성품 기준으로만 계산... 롤백
  --SET @v_dSql += '		 , (CASE WHEN A.PLAN_DATE = ''' + @p_plan_date + ''' THEN (ISNULL(MAX(B.PANCAKE_GOOD_QTY),0)) ELSE 0 END) + ISNULL(SUM(A.ELEC_M_QTY),0) - ISNULL(SUM(A.ASSY_M_QTY),0) AS EOH_QTY '+ char(10) -- pancake eoh
  --SET @v_dSql += '		 , (CASE WHEN A.PLAN_DATE = ''' + @p_plan_date + ''' THEN (ISNULL(MAX(B.PANCAKE_GOOD_CELL_QTY),0)) ELSE 0 END) + ISNULL(SUM(A.ELEC_CELL_QTY),0) - ISNULL(SUM(A.ASSY_CELL_QTY),0) AS EOH_CELL_QTY '+ char(10) -- cell eoh
  /*
  SET @v_dSql += '		 , SUM(A.ELEC_M_QTY) AS ELEC_M_QTY--, SUM(A.ELEC_CELL_QTY) AS ELEC_CELL_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(A.ASSY_M_QTY) AS ASSY_M_QTY--, SUM(A.ASSY_CELL_QTY) AS ASSY_CELL_QTY'+ char(10)
  SET @v_dSql += '		 , (CASE WHEN A.PLAN_DATE = ''' + @p_plan_date + ''' THEN (ISNULL(MAX(B.STOCK_QTY),0) + ISNULL(MAX(B.BOFORE_NT_QTY),0)) ELSE 0 END) + ISNULL(SUM(A.ELEC_M_QTY),0) - ISNULL(SUM(A.ASSY_M_QTY),0) AS EOH_QTY -- pancake eoh'+ char(10)
  SET @v_dSql += '		 , (CASE WHEN A.PLAN_DATE = ''' + @p_plan_date + ''' THEN (ISNULL(MAX(B.STOCK_CELL_QTY),0) + ISNULL(MAX(B.BOFORE_NT_CELL_QTY),0)) ELSE 0 END) + ISNULL(SUM(A.ELEC_CELL_QTY),0) - ISNULL(SUM(A.ASSY_CELL_QTY),0) AS EOH_CELL_QTY -- cell eoh'+ char(10)
  */
  SET @v_dSql += '	FROM ('+ char(10)
  SET @v_dSql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PANCAKE_ITEM AS ITEM_ID, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '			 , A.PANCAKE_IN_QTY AS ELEC_M_QTY, A.CELL_IN_QTY AS ELEC_CELL_QTY'+ char(10)
  SET @v_dSql += '			 , 0 AS ASSY_M_QTY, 0 ASSY_CELL_QTY'+ char(10)
  SET @v_dSql += '		FROM   #COATER_PLAN A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '		UNION ALL'+ char(10)
  SET @v_dSql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PANCAKE_ITEM AS ITEM_ID, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '			 , 0 AS ELEC_M_QTY, 0 AS ELEC_CELL_QTY'+ char(10)
  SET @v_dSql += '			 , A.PANCAKE_IN_QTY AS ASSY_M_QTY, A.CELL_IN_QTY AS ASSY_CELL_QTY'+ char(10)
  SET @v_dSql += '		FROM   #ASSY_PLAN A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '		UNION ALL '+ char(10)
  SET @v_dSql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE '+ char(10)
  SET @v_dSql += '			 , 0 AS ELEC_M_QTY, 0 AS ELEC_CELL_QTY '+ char(10)
  SET @v_dSql += '			 , 0 AS ASSY_M_QTY, 0 AS ASSY_CELL_QTY '+ char(10)
  SET @v_dSql += '		FROM   #SHIP_INFO A WITH(NOLOCK)  '+ char(10)
  SET @v_dSql += '	) A'+ char(10)
  SET @v_dSql += '	LEFT OUTER JOIN #BASIS_BOH B WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	ON  B.CATEGORY_ID = ''1'''+ char(10)
  SET @v_dSql += '	AND A.COMPANY_ID  = B.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND A.SITE_ID     = B.SITE_ID'+ char(10)
  SET @v_dSql += '	AND A.ITEM_ID     = B.ITEM_ID'+ char(10)
  SET @v_dSql += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE'+ char(10)
  SET @v_dSql += ') A'+ char(10)
  SET @v_dSql += 'WHERE 1=1'+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID ' , 'EQ', @p_item_id)) + char(10)
  SET @v_dSql += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID'+ char(10)
  SET @v_dSql += ';' + char(10) --  -- SELECT * FROM #MAIN_I'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID'+ char(10)
  SET @v_dSql += '     , A.ITEM_ID, D.LEVEL_3_NAME AS PROD_NAME, C.NICK_NAME'+ char(10)
  SET @v_dSql += '     , A.CATEGORY_ID, CC.BOH_CATEGORY_NAME, CC.CATEGORY_NAME'+ char(10)
--  SET @v_dSql += '     , ISNULL(B.STOCK_QTY,0) AS STOCK_QTY, ISNULL(B.REWORK_QTY,0) AS REWORK_QTY, ISNULL(B.BOFORE_NT_QTY,0) AS BOFORE_NT_QTY, ISNULL(BB.PANCAKE_GOOD_QTY,0) AS PANCAKE_GOOD_QTY'+ char(10)

-- 12.27
  -- 1. GOOD
  SET @v_dSql += '     , ISNULL(B.GOOD_STOCK_QTY,0) AS GOOD_STOCK_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.GOOD_REWORK_QTY,0) AS GOOD_REWORK_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.GOOD_BOFORE_NT_QTY,0) AS GOOD_BOFORE_NT_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.GOOD_STOCK_CELL_QTY,0) AS GOOD_STOCK_CELL_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.GOOD_REWORK_CELL_QTY,0) AS GOOD_REWORK_CELL_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.GOOD_BOFORE_NT_CELL_QTY,0) AS GOOD_BOFORE_NT_CELL_QTY'+ char(10)
  -- 2. Additional QMS Hold
  SET @v_dSql += '     , ISNULL(B.QMS_STOCK_QTY,0) AS QMS_STOCK_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.QMS_REWORK_QTY,0) AS QMS_REWORK_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.QMS_BOFORE_NT_QTY,0) AS QMS_BOFORE_NT_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.QMS_STOCK_CELL_QTY,0) AS QMS_STOCK_CELL_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.QMS_REWORK_CELL_QTY,0) AS QMS_REWORK_CELL_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.QMS_BOFORE_NT_CELL_QTY,0) AS QMS_BOFORE_NT_CELL_QTY'+ char(10)
  -- 3. GMES Hold
  SET @v_dSql += '     , ISNULL(B.GMES_STOCK_QTY,0) AS GMES_STOCK_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.GMES_REWORK_QTY,0) AS GMES_REWORK_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.GMES_BOFORE_NT_QTY,0) AS GMES_BOFORE_NT_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.GMES_STOCK_CELL_QTY,0) AS GMES_STOCK_CELL_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.GMES_REWORK_CELL_QTY,0) AS GMES_REWORK_CELL_QTY'+ char(10)
  SET @v_dSql += '     , ISNULL(B.GMES_BOFORE_NT_CELL_QTY,0) AS GMES_BOFORE_NT_CELL_QTY'+ char(10)
  
  SET @v_dSql += '     , ISNULL(DD.RECEIPT_GOOD_QTY,0) AS RECEIPT_GOOD_QTY, ISNULL(DD.RECEIPT_GOOD_CELL_QTY,0) AS RECEIPT_GOOD_CELL_QTY '+ char(10)
  SET @v_dSql += '     , ISNULL(DD.RECEIPT_HOLD_QTY,0) AS RECEIPT_HOLD_QTY, ISNULL(DD.RECEIPT_HOLD_CELL_QTY,0) AS RECEIPT_HOLD_CELL_QTY '+ char(10)

  -- Pancake Good Stock'
  --SET @v_dSql += '     , (ISNULL(B.GOOD_STOCK_QTY,0) + ISNULL(B.GOOD_BOFORE_NT_QTY,0)) AS PANCAKE_GOOD_QTY'+ char(10)
  --SET @v_dSql += '     , (ISNULL(B.GOOD_STOCK_CELL_QTY,0) + ISNULL(B.GOOD_BOFORE_NT_CELL_QTY,0)) AS PANCAKE_GOOD_CELL_QTY'+ char(10)
  SET @v_dSql += '     , B.PANCAKE_GOOD_QTY, B.PANCAKE_GOOD_CELL_QTY'+ char(10)

  --SET @v_dSql += '	 --, ISNULL(B.STOCK_CELL_QTY,0) AS STOCK_CELL_QTY, ISNULL(B.REWORK_CELL_QTY,0) AS REWORK_CELL_QTY, ISNULL(B.BOFORE_NT_CELL_QTY,0) AS BOFORE_NT_CELL_QTY, ISNULL(BB.PANCAKE_GOOD_CELL_QTY,0) AS PANCAKE_GOOD_CELL_QTY'+ char(10)
   		IF ISNULL(@p_bucket,'') <> '' BEGIN
			IF @max_loop_cnt > 0 BEGIN

				SET @mst_loop_cnt = 0;
				-- date info
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = ''
					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_row_delimiter, @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END
  SET @v_dSql += '     , A.D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10) 
  SET @v_dSql += '     , A.D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_CELL'+ char(10) 
  --SET @v_dSql += '     , A.D1'+ char(10)
  --SET @v_dSql += '     , A.D2'+ char(10)
  --SET @v_dSql += '     , A.D3'+ char(10)
  --SET @v_dSql += '     , A.D4'+ char(10)
  				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt
		
		END		-- end of isnull(@p_bucket,'') <> ''
  SET @v_dSql += 'FROM ('+ char(10)
  SET @v_dSql += '	SELECT * FROM #MAIN A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	UNION ALL'+ char(10)
  SET @v_dSql += '	SELECT * FROM #MAIN_I A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += ') A'+ char(10)
  -- 12.27
  SET @v_dSql += 'LEFT OUTER JOIN ('+ char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROD_NAME, A.ITEM_ID, A.NICK_NAME'+ char(10)
  -- 1. GOOD'
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.STOCK_QTY ELSE 0 END) AS GOOD_STOCK_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.REWORK_QTY ELSE 0 END) AS GOOD_REWORK_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.BOFORE_NT_QTY ELSE 0 END) AS GOOD_BOFORE_NT_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.STOCK_CELL_QTY ELSE 0 END) AS GOOD_STOCK_CELL_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.REWORK_CELL_QTY ELSE 0 END) AS GOOD_REWORK_CELL_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.BOFORE_NT_CELL_QTY ELSE 0 END) AS GOOD_BOFORE_NT_CELL_QTY'+ char(10)
  -- 2. Additional QMS Hold'
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''2'' THEN A.STOCK_QTY ELSE 0 END) AS QMS_STOCK_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''2'' THEN A.REWORK_QTY ELSE 0 END) AS QMS_REWORK_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''2'' THEN A.BOFORE_NT_QTY ELSE 0 END) AS QMS_BOFORE_NT_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''2'' THEN A.STOCK_CELL_QTY ELSE 0 END) AS QMS_STOCK_CELL_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''2'' THEN A.REWORK_CELL_QTY ELSE 0 END) AS QMS_REWORK_CELL_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''2'' THEN A.BOFORE_NT_CELL_QTY ELSE 0 END) AS QMS_BOFORE_NT_CELL_QTY'+ char(10)
  -- 3. GMES Hold'
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''3'' THEN A.STOCK_QTY ELSE 0 END) AS GMES_STOCK_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''3'' THEN A.REWORK_QTY ELSE 0 END) AS GMES_REWORK_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''3'' THEN A.BOFORE_NT_QTY ELSE 0 END) AS GMES_BOFORE_NT_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''3'' THEN A.STOCK_CELL_QTY ELSE 0 END) AS GMES_STOCK_CELL_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''3'' THEN A.REWORK_CELL_QTY ELSE 0 END) AS GMES_REWORK_CELL_QTY'+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''3'' THEN A.BOFORE_NT_CELL_QTY ELSE 0 END) AS GMES_BOFORE_NT_CELL_QTY'+ char(10)
  -- Pancake Good Stock
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.PANCAKE_GOOD_QTY ELSE 0 END) AS PANCAKE_GOOD_QTY '+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.PANCAKE_GOOD_CELL_QTY ELSE 0 END) AS PANCAKE_GOOD_CELL_QTY '+ char(10)
  SET @v_dSql += '	FROM   #BASIS_BOH A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROD_NAME, A.ITEM_ID, A.NICK_NAME'+ char(10)
  SET @v_dSql += ') B'+ char(10)
  SET @v_dSql += 'ON  A.COMPANY_ID  = B.COMPANY_ID'+ char(10)
  SET @v_dSql += 'AND A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += 'AND A.SITE_ID     = B.SITE_ID'+ char(10)
  SET @v_dSql += 'AND A.ITEM_ID     = B.ITEM_ID'+ char(10)
  SET @v_dSql += 'LEFT OUTER JOIN ('+ char(10)

  SET @v_dSql += '	SELECT ''100'' AS CATEGORY_ID, ''GOOD'' AS BOH_CATEGORY_NAME, ''Assy'' AS CATEGORY_NAME '+ char(10)
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT ''200'' AS CATEGORY_ID, ''-'' AS BOH_CATEGORY_NAME, ''Coater Plan + Post Yield'' AS CATEGORY_NAME '+ char(10)
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT ''300'' AS CATEGORY_ID, ''Additional QMS Hold'' AS BOH_CATEGORY_NAME, ''Coater'' AS CATEGORY_NAME '+ char(10)
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT ''150'' AS CATEGORY_ID, ''-'' AS BOH_CATEGORY_NAME, ''Shipment Plan(Out)'' AS CATEGORY_NAME '+ char(10)
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT ''500'' AS CATEGORY_ID, ''-'' AS BOH_CATEGORY_NAME, ''Receipt(Plan+Intransit)'' AS CATEGORY_NAME '+ char(10)
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT ''600'' AS CATEGORY_ID, ''GMES Hold'' AS BOH_CATEGORY_NAME, ''Inventory'' AS CATEGORY_NAME '+ char(10)
  SET @v_dSql += '	UNION ALL '+ char(10)
  SET @v_dSql += '	SELECT ''700'' AS CATEGORY_ID, ''DIO'' AS BOH_CATEGORY_NAME, ''DIO'' AS CATEGORY_NAME '+ char(10)
  /*
  SET @v_dSql += '	SELECT ''1'' AS CATEGORY_ID, ''GOOD'' AS BOH_CATEGORY_NAME, ''Assy'' AS CATEGORY_NAME'+ char(10)
  SET @v_dSql += '	UNION ALL'+ char(10)
  SET @v_dSql += '	SELECT ''2'' AS CATEGORY_ID, ''Additional QMS Hold'' AS BOH_CATEGORY_NAME, ''Coater'' AS CATEGORY_NAME'+ char(10)
  SET @v_dSql += '	UNION ALL'+ char(10)
  SET @v_dSql += '	SELECT ''3'' AS CATEGORY_ID, ''GMES Hold'' AS BOH_CATEGORY_NAME, ''Inventory'' AS CATEGORY_NAME'+ char(10)
  SET @v_dSql += '	UNION ALL'+ char(10)
  SET @v_dSql += '	SELECT ''4'' AS CATEGORY_ID, ''DIO'' AS BOH_CATEGORY_NAME, ''DIO'' AS CATEGORY_NAME'+ char(10)
  */
  SET @v_dSql += ') CC'+ char(10)
  SET @v_dSql += 'ON 1=1'+ char(10)
  SET @v_dSql += 'AND  A.CATEGORY_ID = CC.CATEGORY_ID'+ char(10)

  -- 도입셀 재고 추가... 20230306
  SET @v_dSql += 'LEFT OUTER JOIN ( '+ char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID '+ char(10)
  SET @v_dSql += '	     , SUM(CASE WHEN B.STOCK_TYPE = ''GOOD'' THEN A.QTY ELSE 0 END) AS RECEIPT_GOOD_QTY '+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN B.STOCK_TYPE = ''GOOD'' THEN A.QTY ELSE 0 END)*ISNULL(MAX(C.VALUE),1) AS RECEIPT_GOOD_CELL_QTY '+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN B.STOCK_TYPE = ''HOLD'' THEN A.QTY ELSE 0 END) AS RECEIPT_HOLD_QTY '+ char(10)
  SET @v_dSql += '		 , SUM(CASE WHEN B.STOCK_TYPE = ''HOLD'' THEN A.QTY ELSE 0 END)*ISNULL(MAX(C.VALUE),1) AS RECEIPT_HOLD_CELL_QTY '+ char(10)
  SET @v_dSql += '	FROM   #FP_STOCH_H A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '	LEFT OUTER JOIN #ITEM_CALC C WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '	ON  1=1 '+ char(10)
  SET @v_dSql += '	AND A.COMPANY_ID  = C.COMPANY_ID '+ char(10)
  SET @v_dSql += '	AND A.DIVISION_ID = C.DIVISION_ID '+ char(10)
  SET @v_dSql += '	AND A.SITE_ID     = C.SITE_ID '+ char(10)
  SET @v_dSql += '	AND A.ITEM_ID     = C.ITEM_ID '+ char(10)
  SET @v_dSql += '	, ( '+ char(10)
  SET @v_dSql += '		SELECT A.SEGMENT2 AS SITE_ID, A.SEGMENT3 AS DIVISION_ID, A.SEGMENT4 AS PLANT_ID '+ char(10)
  SET @v_dSql += '			 , A.SEGMENT5 AS STORAGE_ID, A.ATTRIBUTE11 AS STOCK_TYPE '+ char(10)
  SET @v_dSql += '		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '		WHERE  1=1 '+ char(10)
  SET @v_dSql += '		AND    A.LOOKUP_TYPE_CODE = ''SIMULATION_BOH'' '+ char(10)
  SET @v_dSql += '		AND    A.SEGMENT1 = ''CELL_SIMULATION'' '+ char(10)
  --SET @v_dSql += '		AND    A.ACTIVE_FLAG = ''Y'' '+ char(10) -- 추후에 제거 예정
  SET @v_dSql += '		AND    A.ATTRIBUTE11 IN (''GOOD'',''HOLD'') '+ char(10)
  SET @v_dSql += '	) B '+ char(10)
  SET @v_dSql += '	WHERE 1=1 '+ char(10)
  SET @v_dSql += '	AND   A.DIVISION_ID = B.DIVISION_ID '+ char(10)
  SET @v_dSql += '	AND   A.SITE_ID     = B.SITE_ID '+ char(10)
  SET @v_dSql += '	AND   A.PLANT_ID    = B.PLANT_ID '+ char(10)
  SET @v_dSql += '	AND   A.STORAGE_ID  = B.STORAGE_ID '+ char(10)
  SET @v_dSql += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID '+ char(10)
  SET @v_dSql += ') DD '+ char(10)
  SET @v_dSql += 'ON   1=1 '+ char(10)
  SET @v_dSql += 'AND   A.COMPANY_ID  = DD.COMPANY_ID '+ char(10)
  SET @v_dSql += 'AND   A.DIVISION_ID = DD.DIVISION_ID '+ char(10)
  SET @v_dSql += 'AND   A.SITE_ID     = DD.SITE_ID '+ char(10)
  SET @v_dSql += 'AND   A.ITEM_ID     = DD.ITEM_ID '+ char(10)

  SET @v_dSql += ', SCM_ITEM_M C WITH(NOLOCK)'+ char(10)
  SET @v_dSql += ', SCM_ITEM_CLASS_M D WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'WHERE 1=1'+ char(10)
  SET @v_dSql += 'AND   A.COMPANY_ID  = C.COMPANY_ID'+ char(10)
  SET @v_dSql += 'AND   A.DIVISION_ID = C.DIVISION_ID'+ char(10)
  SET @v_dSql += 'AND   A.SITE_ID     = C.SITE_ID'+ char(10)
  SET @v_dSql += 'AND   A.ITEM_ID     = C.ITEM_ID'+ char(10)
  SET @v_dSql += 'AND   C.ITEM_CLASS  = D.CLASS_ID'+ char(10)
  SET @v_dSql += 'AND   D.LEVEL_2_CODE = ''APC'''+ char(10)
  SET @v_dSql += 'AND   D.LEVEL_3_NAME != ''APCSR'''+ char(10)
  --SET @v_dSql += '--and a.item_id = ''APCAN1437A'''+ char(10)
  SET @v_dSql += 'ORDER BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.CATEGORY_ID'+ char(10)
  SET @v_dSql += ';'+ char(10)

  --SET @v_dSql += '/*'+ char(10)
  --SET @v_dSql += ''+ char(10)
  --SET @v_dSql += '--   SELECT * FROM #BASIS_BOH'+ char(10)
  --SET @v_dSql += ''+ char(10)
  --SET @v_dSql += 'SELECT *'+ char(10)
  --SET @v_dSql += 'FROM   #BASIS_BOH A WITH(NOLOCK)'+ char(10)
  --SET @v_dSql += 'WHERE  A.CATEGORY_ID = ''1'''+ char(10)
  --SET @v_dSql += 'and item_id = ''APCAN1437A'''+ char(10)
  --SET @v_dSql += ''+ char(10)
  --SET @v_dSql += ''+ char(10)
  --SET @v_dSql += '*/'+ char(10)

  SET @v_dSql += 'if object_id(''tempdb..#COATER_SITE'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #COATER_SITE'+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#ASSY_LINE'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ASSY_LINE'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#ITEM_CALC'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ITEM_CALC'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#COATER_PLAN'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #COATER_PLAN'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#ASSY_PLAN'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ASSY_PLAN'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#ITEM_LIST'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ITEM_LIST'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#FP_STOCH_H'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #FP_STOCH_H'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#ITEM_YIELD'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ITEM_YIELD'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#BASIS_BOH'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #BASIS_BOH'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#MAIN'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #MAIN'+ char(10)
  --SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#MAIN_I'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #MAIN_I'+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#INS_PLANT'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #INS_PLANT'+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#SHIP_INFO'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #SHIP_INFO'+ char(10)+ char(10)

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
			     --select @v_dSql for xml path('')
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

