


CREATE PROCEDURE [dbo].[PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY]
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

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY';
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
	  -- 12/21
  SET @v_dSql += 'if object_id(''tempdb..#COATER_SITE'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #COATER_SITE'+ char(10)
    SET @v_dSql += 'if object_id(''tempdb..#ASSY_LINE'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ASSY_LINE'+ char(10)
	  SET @v_dSql += 'if object_id(''tempdb..#ITEM_CALC'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ITEM_CALC'+ char(10)
--  SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#FP_STOCH_H'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #FP_STOCH_H'+ char(10)
--  SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#ITEM_YIELD'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #ITEM_YIELD'+ char(10)
--  SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'if object_id(''tempdb..#BASIS_BOH'') is not null'+ char(10)
  SET @v_dSql += '	DROP TABLE #BASIS_BOH'+ char(10)

    -- 12/21
  SET @v_dSql += 'SELECT DISTINCT A.DIVISION_ID, A.SITE_ID'+ char(10)
  SET @v_dSql += 'INTO #COATER_SITE'+ char(10)
  SET @v_dSql += 'FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'WHERE  A.OPERATION_ID = ''E2000'' '+ char(10)
  SET @v_dSql += 'AND    A.INSTANCE_ID  = ''' + @p_instance_id + ''' '+ char(10)
  SET @v_dSql += ';'+ char(10)

--  SET @v_dSql += ''+ char(10)
--  SET @v_dSql += '--'+ char(10)
  SET @v_dSql += 'SELECT A.*'+ char(10)
  SET @v_dSql += 'INTO #ITEM_CALC'+ char(10)
  SET @v_dSql += 'FROM ('+ char(10)
    --  12/21
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ITEM_ID, VERSION, A.VALUE'+ char(10)
  --SET @v_dSql += '			--, PLANT_ID, FACTORY_ID'+ char(10)
  SET @v_dSql += '			, ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ITEM_ID'+ char(10)

  --SET @v_dSql += '	SELECT COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, VERSION, A.VALUE'+ char(10)
--  SET @v_dSql += '			--, PLANT_ID, FACTORY_ID'+ char(10)
  --SET @v_dSql += '			, ROW_NUMBER() OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID'+ char(10)
  SET @v_dSql += '								ORDER BY     PLANT_ID, FACTORY_ID, (CASE WHEN A.VERSION LIKE ''Z%'' THEN 9999 ELSE 1 END), VERSION DESC) AS ROW_NUM'+ char(10)
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
  SET @v_dSql += '		WHERE  A.DIVISION_ID = WW.DIVISION_ID'+ char(10)
  SET @v_dSql += '		AND    A.SITE_ID     = WW.SITE_ID'+ char(10)
  SET @v_dSql += '	)'+ char(10)
--  SET @v_dSql += '	AND    A.DIVISION_ID = ''81'''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
--  SET @v_dSql += '	AND    A.SITE_ID = ''A004'''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID ' , 'EQ', @p_site_id)) + char(10)

  SET @v_dSql += ') A'+ char(10)
  SET @v_dSql += 'WHERE 1=1'+ char(10)
  SET @v_dSql += 'AND   ROW_NUM = 1'+ char(10)
  SET @v_dSql += ';'+ char(10)
--  SET @v_dSql += '--'+ char(10)
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

    -- 12/21
  SET @v_dSql += 'AND    EXISTS ('+ char(10)
  SET @v_dSql += '	SELECT 1'+ char(10)
  SET @v_dSql += '	FROM   #COATER_SITE WW WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	WHERE  A.DIVISION_ID = WW.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND    A.SITE_ID     = WW.SITE_ID'+ char(10)
  SET @v_dSql += ')'+ char(10)
--  SET @v_dSql += 'AND    A.DIVISION_ID = ''81'''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --SET @v_dSql += 'AND    A.SITE_ID = ''A004'''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID ' , 'EQ', @p_site_id)) + char(10)

  SET @v_dSql += 'AND    A.CUTOFF_DATE = '''+ @p_plan_date+''''+ char(10)
	SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID ' , 'EQ', @p_item_id)) + char(10)
--  SET @v_dSql += '--AND    A.ITEM_ID IN (''APCAN1437A'',''APCCA1494A'')'+ char(10)
  SET @v_dSql += ';'+ char(10)
--  SET @v_dSql += '--'+ char(10)
  SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, MIN(YIELD) AS YIELD'+ char(10)
  SET @v_dSql += 'INTO #ITEM_YIELD'+ char(10)
  SET @v_dSql += 'FROM   SCM_YIELD_M A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'WHERE  1=1'+ char(10)
  -- 12/21
  SET @v_dSql += 'AND    EXISTS ('+ char(10)
  SET @v_dSql += '	SELECT 1'+ char(10)
  SET @v_dSql += '	FROM   #COATER_SITE WW WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '	WHERE  A.DIVISION_ID = WW.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND    A.SITE_ID     = WW.SITE_ID'+ char(10)
  SET @v_dSql += ')'+ char(10)
--  SET @v_dSql += 'AND    A.DIVISION_ID = ''81'''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
--  SET @v_dSql += 'AND    A.SITE_ID = ''A004'''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID ' , 'EQ', @p_site_id)) + char(10)

  SET @v_dSql += 'AND    A.OPERATION_ID IN (''E3000'',''E4000'')'+ char(10)
  --SET @v_dSql += '--AND    A.ITEM_ID IN (''APCAN1437A'',''APCCA1494A'')'+ char(10)
--  SET @v_dSql += 'AND    A.MONTH >= ''202211'''+ char(10)
  SET @v_dSql += 'AND A.MONTH BETWEEN CONVERT(VARCHAR(6),'''+ @p_bucket_from +''') AND CONVERT(VARCHAR(6),'''+ @p_bucket_to +''')' + char(10)

  SET @v_dSql += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ITEM_ID, A.OPERATION_ID'+ char(10)
  SET @v_dSql += ';'+ char(10)
  --SET @v_dSql += '--'+ char(10)
  SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROD_NAME, A.ITEM_ID, A.NICK_NAME, A.VERSION, A.CATEGORY_ID, A.CATEGORY_NAME, A.MODEL_ID '+ char(10)
  SET @v_dSql += '     , SUM(A.STOCK_QTY) AS STOCK_QTY'+ char(10)
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
  SET @v_dSql += '		 , ''1'' AS CATEGORY_ID, ''GOOD'' AS CATEGORY_NAME'+ char(10)
  SET @v_dSql += '		 , ROUND(SUM(CASE WHEN A.OPERATION_ID IN (''E2000'',''E3000'') THEN A.QTY*A.LANE*ISNULL(Y1.YIELD,1)*ISNULL(Y2.YIELD,1)'+ char(10)
  SET @v_dSql += '		  		          WHEN A.OPERATION_ID = ''E4000'' AND LANE != 1 THEN A.QTY*A.LANE*ISNULL(Y1.YIELD,1)'+ char(10)
  SET @v_dSql += '		  		          WHEN A.OPERATION_ID = ''E4100'' THEN 0'+ char(10)
  SET @v_dSql += '		  		          WHEN A.OPERATION_ID = ''A5000'' THEN 0'+ char(10)
  SET @v_dSql += '		  		          ELSE A.QTY*A.LANE END),0) AS STOCK_QTY'+ char(10)
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
  SET @v_dSql += 'AND    A.CUTOFF_DATE = '''+ @p_plan_date+''''+ char(10)

  -- 12/21
  --SET @v_dSql += 'AND    EXISTS ('+ char(10)
  --SET @v_dSql += '	SELECT 1'+ char(10)
  --SET @v_dSql += '	FROM   #COATER_SITE WW WITH(NOLOCK)'+ char(10)
  --SET @v_dSql += '	WHERE  A.DIVISION_ID = WW.DIVISION_ID'+ char(10)
  --SET @v_dSql += '	AND    A.SITE_ID     = WW.SITE_ID'+ char(10)
  --SET @v_dSql += ')'+ char(10)

--  SET @v_dSql += '	AND   A.SITE_ID     = ''A004'''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID ' , 'EQ', @p_site_id)) + char(10)
--  SET @v_dSql += '	AND   A.DIVISION_ID = ''81'''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += '	AND   A.STOCK_TYPE  = ''WIP'''+ char(10)
  SET @v_dSql += '	AND   A.COMPANY_ID  = B.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND   A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND   A.SITE_ID     = B.SITE_ID'+ char(10)
  SET @v_dSql += '	AND   A.ITEM_ID     = B.ITEM_ID'+ char(10)
  SET @v_dSql += '	AND   B.ITEM_CLASS  = C.CLASS_ID'+ char(10)
  SET @v_dSql += '	AND   C.LEVEL_2_CODE = ''APC'''+ char(10)
  SET @v_dSql += '	AND   C.LEVEL_3_NAME != ''APCSR'''+ char(10)
  --SET @v_dSql += '	AND   B.NICK_NAME = ''E78-C03'''+ char(10)
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
  SET @v_dSql += '		  , ''2'' AS CATEGORY_ID, ''Additional QMS Hold'' AS CATEGORY_NAME'+ char(10)
  SET @v_dSql += '		  , ROUND(SUM(CASE WHEN A.OPERATION_ID IN (''E2000'',''E3000'') THEN A.QTY*A.LANE*ISNULL(Y1.YIELD,1)*ISNULL(Y2.YIELD,1)'+ char(10)
  SET @v_dSql += '		    	  	       WHEN A.OPERATION_ID = ''E4000'' AND LANE != 1 THEN A.QTY*A.LANE*ISNULL(Y1.YIELD,1)'+ char(10)
  SET @v_dSql += '		    	  	       WHEN A.OPERATION_ID = ''E4100'' THEN 0'+ char(10)
  SET @v_dSql += '		    	  	       WHEN A.OPERATION_ID = ''A5000'' THEN 0'+ char(10)
  SET @v_dSql += '		    	  	       ELSE A.QTY*A.LANE END),0) AS STOCK_QTY'+ char(10)
  SET @v_dSql += '		  , ROUND(SUM(CASE WHEN A.OPERATION_ID = ''E4100'' THEN A.QTY*A.LANE ELSE 0 END),0) AS REWORK_QTY'+ char(10)
  SET @v_dSql += '		  , ROUND(SUM(CASE WHEN A.OPERATION_ID = ''A5000'' THEN A.QTY*A.LANE ELSE 0 END),0) AS BOFORE_NT_QTY'+ char(10)
  SET @v_dSql += '		  , 0 AS PANCAKE_GOOD_QTY'+ char(10)
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

  ---- 12/21
  --SET @v_dSql += 'AND    EXISTS ('+ char(10)
  --SET @v_dSql += '	SELECT 1'+ char(10)
  --SET @v_dSql += '	FROM   #COATER_SITE WW WITH(NOLOCK)'+ char(10)
  --SET @v_dSql += '	WHERE  A.DIVISION_ID = WW.DIVISION_ID'+ char(10)
  --SET @v_dSql += '	AND    A.SITE_ID     = WW.SITE_ID'+ char(10)
  --SET @v_dSql += ')'+ char(10)
  SET @v_dSql += 'AND    A.CUTOFF_DATE = '''+ @p_plan_date+''''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID ' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += '	AND 	A.STOCK_TYPE = ''WIP'''+ char(10)
  SET @v_dSql += '	AND 	A.COMPANY_ID = B.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND 	A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND 	A.SITE_ID = B.SITE_ID'+ char(10)
  SET @v_dSql += '	AND 	A.ITEM_ID = B.ITEM_ID'+ char(10)
  SET @v_dSql += '	AND 	B.ITEM_CLASS = C.CLASS_ID'+ char(10)
  SET @v_dSql += '	AND 	C.LEVEL_2_CODE = ''APC'''+ char(10)
  SET @v_dSql += '	AND 	C.LEVEL_3_NAME != ''APCSR'''+ char(10)
--  SET @v_dSql += '	--AND 	B.NICK_NAME = ''E78-C03'''+ char(10)
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
  SET @v_dSql += '		  , ''3'' AS CATEGORY_ID, ''GMES Hold'' AS CATEGORY_NAME'+ char(10)
  SET @v_dSql += '		  , ROUND(SUM(CASE WHEN A.OPERATION_ID IN (''E2000'',''E3000'') THEN A.QTY*A.LANE*ISNULL(Y1.YIELD,1)*ISNULL(Y2.YIELD,1)'+ char(10)
  SET @v_dSql += '		    	     WHEN A.OPERATION_ID = ''E4000'' AND LANE != 1 THEN A.QTY*A.LANE*ISNULL(Y1.YIELD,1)'+ char(10)
  SET @v_dSql += '		    	     WHEN A.OPERATION_ID = ''E4100'' THEN 0'+ char(10)
  SET @v_dSql += '		    	     WHEN A.OPERATION_ID = ''A5000'' THEN 0'+ char(10)
  SET @v_dSql += '		    	     ELSE A.QTY*A.LANE END),0) AS STOCK_QTY'+ char(10)
  SET @v_dSql += '		  , ROUND(SUM(CASE WHEN A.OPERATION_ID = ''E4100'' THEN A.QTY*A.LANE ELSE 0 END),0) AS REWORK_QTY'+ char(10)
  SET @v_dSql += '		  , ROUND(SUM(CASE WHEN A.OPERATION_ID = ''A5000'' THEN A.QTY*A.LANE ELSE 0 END),0) AS BOFORE_NT_QTY'+ char(10)
  SET @v_dSql += '		  , 0 AS PANCAKE_GOOD_QTY'+ char(10)
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
  SET @v_dSql += '	AND    A.CUTOFF_DATE = '''+ @p_plan_date+''''+ char(10)

  -- 12/21
  SET @v_dSql += '	AND    EXISTS ('+ char(10)
  SET @v_dSql += '		SELECT 1'+ char(10)
  SET @v_dSql += '		FROM   #COATER_SITE WW WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '		WHERE  A.DIVISION_ID = WW.DIVISION_ID'+ char(10)
  SET @v_dSql += '		AND    A.SITE_ID     = WW.SITE_ID'+ char(10)
  SET @v_dSql += '	)'+ char(10)

--  SET @v_dSql += '	AND 	A.SITE_ID = ''A004'''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID ' , 'EQ', @p_site_id)) + char(10)
--  SET @v_dSql += '	AND 	A.DIVISION_ID = ''81'''+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += '	AND 	A.STOCK_TYPE = ''WIP'''+ char(10)
  SET @v_dSql += '	AND 	A.COMPANY_ID = B.COMPANY_ID'+ char(10)
  SET @v_dSql += '	AND 	A.DIVISION_ID = B.DIVISION_ID'+ char(10)
  SET @v_dSql += '	AND 	A.SITE_ID = B.SITE_ID'+ char(10)
  SET @v_dSql += '	AND 	A.ITEM_ID = B.ITEM_ID'+ char(10)
  SET @v_dSql += '	AND 	B.ITEM_CLASS = C.CLASS_ID'+ char(10)
  SET @v_dSql += '	AND 	C.LEVEL_2_CODE = ''APC'''+ char(10)
  SET @v_dSql += '	AND 	C.LEVEL_3_NAME != ''APCSR'''+ char(10)
--  SET @v_dSql += '	AND 	B.NICK_NAME = ''E78-C03'''+ char(10)
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
  SET @v_dSql += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROD_NAME, A.ITEM_ID, A.NICK_NAME, A.VERSION, A.CATEGORY_ID, A.CATEGORY_NAME, A.MODEL_ID'+ char(10)
  SET @v_dSql += ';'+ char(10)
  --SET @v_dSql += ''+ char(10)
  --SET @v_dSql += ''+ char(10)
  /*
  SET @v_dSql += 'SELECT *'+ char(10)
  SET @v_dSql += 'FROM   #BASIS_BOH A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += 'ORDER BY COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, VERSION, CATEGORY_ID'+ char(10)
  */
  SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROD_NAME, A.ITEM_ID, A.NICK_NAME, A.VERSION '+ char(10)
  -- 1.GOOD
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.STOCK_QTY ELSE 0 END) AS GOOD_STOCK_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.REWORK_QTY ELSE 0 END) AS GOOD_REWORK_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.BOFORE_NT_QTY ELSE 0 END) AS GOOD_BOFORE_NT_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.STOCK_CELL_QTY ELSE 0 END) AS GOOD_STOCK_CELL_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.REWORK_CELL_QTY ELSE 0 END) AS GOOD_REWORK_CELL_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.BOFORE_NT_CELL_QTY ELSE 0 END) AS GOOD_BOFORE_NT_CELL_QTY '+ char(10)
  -- 2.Additional QMS Hold
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''2'' THEN A.STOCK_QTY ELSE 0 END) AS QMS_STOCK_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''2'' THEN A.REWORK_QTY ELSE 0 END) AS QMS_REWORK_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''2'' THEN A.BOFORE_NT_QTY ELSE 0 END) AS QMS_BOFORE_NT_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''2'' THEN A.STOCK_CELL_QTY ELSE 0 END) AS QMS_STOCK_CELL_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''2'' THEN A.REWORK_CELL_QTY ELSE 0 END) AS QMS_REWORK_CELL_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''2'' THEN A.BOFORE_NT_CELL_QTY ELSE 0 END) AS QMS_BOFORE_NT_CELL_QTY '+ char(10)
  -- 3.GMES Hold
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''3'' THEN A.STOCK_QTY ELSE 0 END) AS GMES_STOCK_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''3'' THEN A.REWORK_QTY ELSE 0 END) AS GMES_REWORK_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''3'' THEN A.BOFORE_NT_QTY ELSE 0 END) AS GMES_BOFORE_NT_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''3'' THEN A.STOCK_CELL_QTY ELSE 0 END) AS GMES_STOCK_CELL_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''3'' THEN A.REWORK_CELL_QTY ELSE 0 END) AS GMES_REWORK_CELL_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''3'' THEN A.BOFORE_NT_CELL_QTY ELSE 0 END) AS GMES_BOFORE_NT_CELL_QTY '+ char(10)
  -- Pancake Good Stock
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.PANCAKE_GOOD_QTY ELSE 0 END) AS PANCAKE_GOOD_QTY '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.PANCAKE_GOOD_CELL_QTY ELSE 0 END) AS PANCAKE_GOOD_CELL_QTY '+ char(10)
  --- eoh 계산용
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.PANCAKE_GOOD_QTY2 ELSE 0 END) AS PANCAKE_GOOD_QTY2 '+ char(10)
  SET @v_dSql += '	 , SUM(CASE WHEN A.CATEGORY_ID = ''1'' THEN A.PANCAKE_GOOD_CELL_QTY2 ELSE 0 END) AS PANCAKE_GOOD_CELL_QTY2 '+ char(10)
  -- item - version 별 모델정보 리스트 추가
  SET @v_dSql += '	 , STUFF(( '+ char(10)
  SET @v_dSql += '	 		SELECT '', '' + AA.MODEL_ID '+ char(10)
  SET @v_dSql += '	 		FROM ( ' + char(10)
  SET @v_dSql += '	 			SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.VERSION, A.MODEL_ID ' + char(10)
  SET @v_dSql += '	 			FROM   #BASIS_BOH A WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '	 		) AA ' + char(10)
  SET @v_dSql += '	 		WHERE  A.COMPANY_ID  = AA.COMPANY_ID '+ char(10)
  SET @v_dSql += '	 		AND    A.DIVISION_ID = AA.DIVISION_ID '+ char(10)
  SET @v_dSql += '	 		AND    A.SITE_ID     = AA.SITE_ID '+ char(10)
  SET @v_dSql += '	 		AND    A.ITEM_ID     = AA.ITEM_ID '+ char(10)
  SET @v_dSql += '	 		AND    A.VERSION     = AA.VERSION '+ char(10)
  SET @v_dSql += '	 		FOR XML PATH('''')) , 1, 2, '''' ) AS WORK_REQUEST_MODEL_LT '+ char(10)
  SET @v_dSql += 'FROM   #BASIS_BOH A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += 'WHERE 1=1 '+ char(10)
  SET @v_dSql += 'AND   VERSION IS NOT NULL '+ char(10)
  SET @v_dSql += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROD_NAME, A.ITEM_ID, A.NICK_NAME, A.VERSION '+ char(10)
  SET @v_dSql += ';'+ char(10)


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

