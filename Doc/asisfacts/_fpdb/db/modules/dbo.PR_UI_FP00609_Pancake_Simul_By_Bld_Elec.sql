

/*
 * Program ID   : PR_UI_FP00609_Pancake_Simul_By_Bld_Elec
 * Description  : Pancake Simul By Bld(Elec.)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/12/20   LJS				Initial Release UI통합
 */

--CREATE
CREATE
PROCEDURE [dbo].[PR_UI_FP00609_Pancake_Simul_By_Bld_Elec]
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

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00609_Pancake_Simul_By_Bld_Elec';
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

	DECLARE @p_amend_instance	NVARCHAR(MAX); -- AMEND_INSTANCE
	DECLARE @p_instance_id	NVARCHAR(MAX); -- INSTANCE_ID
	DECLARE @p_master_id	NVARCHAR(MAX); -- MASTER_ID
	DECLARE @p_plan_date	NVARCHAR(MAX); -- PLAN_DATE
	DECLARE @p_curr_date	NVARCHAR(MAX); -- CURR_DATE
	DECLARE @p_plan_id		NVARCHAR(MAX); -- PLAN_ID
	DECLARE @p_bucket_from	NVARCHAR(MAX); -- BUCKET_FROM
	DECLARE @p_bucket_to	NVARCHAR(MAX); -- BUCKET_TO

	DECLARE @p_factory_id	NVARCHAR(MAX);  -- FACTORY_ID --> 멀티콤보
	DECLARE @p_release_flag  NVARCHAR(MAX); -- RELEASE_FLAG
	DECLARE @p_cell_type     NVARCHAR(MAX); -- CELL_TYPE
	DECLARE @p_pancake_type  NVARCHAR(MAX); -- PANCAKE_TYPE
	DECLARE @p_uom_type      NVARCHAR(MAX); -- UOM_TYPE
	DECLARE @p_unit          NVARCHAR(MAX); -- UNIT
	DECLARE @p_round_point   NVARCHAR(MAX); -- ROUND_POINT
	DECLARE @p_plan_type     NVARCHAR(MAX); -- PLAN_TYPE
	DECLARE @p_description   NVARCHAR(MAX); -- DESCRIPTION
	DECLARE @p_read_only     NVARCHAR(MAX); -- READ_ONLY
	DECLARE @p_plan_name     NVARCHAR(MAX); -- PLAN_NAME
	DECLARE @p_chk_planid    NVARCHAR(MAX); -- CHK_PLANID
	
	DECLARE @p_model_id					NVARCHAR(MAX); -- MODEL_ID
	DECLARE @p_model_nick_name			NVARCHAR(MAX); -- MODEL_NICK_NAME
	DECLARE @p_model_nick_name_top		NVARCHAR(MAX); -- MODEL_NICK_NAME_TOP
	DECLARE @p_model_nick_name_list		NVARCHAR(MAX); -- MODEL_NICK_NAME_LIST
	DECLARE @p_item_id					NVARCHAR(MAX); -- ITEM_ID
	DECLARE @p_nick_name				NVARCHAR(MAX); -- NICK_NAME

	DECLARE @p_chk_total_include	NVARCHAR(MAX); -- CHK_TOTAL_INCLUDE
	
	DECLARE @p_cate_info	NVARCHAR(MAX);

	/*
	DECLARE @p_top_item_id	NVARCHAR(MAX);
	DECLARE @p_item_id		NVARCHAR(MAX);
	DECLARE @p_nick_name	NVARCHAR(MAX);
	DECLARE @p_prod_type	NVARCHAR(MAX);
	DECLARE @p_prodtype_id	NVARCHAR(MAX);
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
	*/

	-- week
	DECLARE @p_bucket		NVARCHAR(MAX); -- day
	DECLARE @p_week_info	NVARCHAR(MAX); -- week
	DECLARE @p_month_info	NVARCHAR(MAX); -- month
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

		END ELSE IF @tmp_column = 'AMEND_INSTANCE' BEGIN
			SET @p_amend_instance =		@tmp_value
		END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
			SET @p_instance_id =		@tmp_value
		END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
			SET @p_master_id =			@tmp_value
		END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
			SET @p_plan_date =			@tmp_value
		END ELSE IF @tmp_column = 'CURR_DATE' BEGIN
			SET @p_curr_date =			@tmp_value
		END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
			SET @p_plan_id =			@tmp_value
		END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
			SET @p_bucket_from =		@tmp_value
		END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
			SET @p_bucket_to =			@tmp_value

		END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
			SET @p_factory_id	=		@tmp_value
		END ELSE IF @tmp_column = 'RELEASE_FLAG' BEGIN
			SET @p_release_flag =		@tmp_value
		END ELSE IF @tmp_column = 'CELL_TYPE' BEGIN
			SET @p_cell_type =			@tmp_value
		END ELSE IF @tmp_column = 'PANCAKE_TYPE' BEGIN
			SET @p_pancake_type =		@tmp_value
		END ELSE IF @tmp_column = 'UOM_TYPE' BEGIN
			SET @p_uom_type		=		@tmp_value
		END ELSE IF @tmp_column = 'UNIT' BEGIN
			SET @p_unit			=		@tmp_value
		END ELSE IF @tmp_column = 'ROUND_POINT' BEGIN
			SET @p_round_point	=		@tmp_value
		END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
			SET @p_plan_type	=		@tmp_value
		END ELSE IF @tmp_column = 'DESCRIPTION' BEGIN
			SET @p_description	=		@tmp_value
		END ELSE IF @tmp_column = 'READ_ONLY' BEGIN
			SET @p_read_only	=		@tmp_value
		END ELSE IF @tmp_column = 'PLAN_NAME' BEGIN
			SET @p_plan_name	=		@tmp_value
		END ELSE IF @tmp_column = 'CHK_PLANID' BEGIN
			SET @p_chk_planid	=		@tmp_value

		END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
			SET @p_model_id		=		@tmp_value
		END ELSE IF @tmp_column = 'MODEL_NICK_NAME' BEGIN
			SET @p_model_nick_name=		@tmp_value
		END ELSE IF @tmp_column = 'MODEL_NICK_NAME_TOP' BEGIN
			--SET @p_model_nick_name_top = @tmp_value
			SET @p_model_nick_name_top =  [dbo].[SCM_ARR_SPL_VAL]( @in_row, @v_delimiter, @mst_loop_cnt );
		END ELSE IF @tmp_column = 'MODEL_NICK_NAME_LIST' BEGIN
			SET @p_model_nick_name_list	= @tmp_value
		END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
			SET @p_item_id		=		@tmp_value
		END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
			SET @p_nick_name	=		@tmp_value
		END ELSE IF @tmp_column = 'CHK_TOTAL_INCLUDE' BEGIN
			SET @p_chk_total_include = @tmp_value

		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =				@tmp_value
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			@tmp_value
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			@tmp_value
		END ELSE IF @tmp_column = 'DAY2_WEEK_MONTH' BEGIN
			SET @p_day2_week_month_info = @tmp_value
		
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

		if @p_plan_id is null or @p_plan_id = ''
		begin
			set @p_plan_id = ''
		end

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

		SET	@v_dSql = '' 
		
		-- drop temp table
		BEGIN

			SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_01'') IS NOT NULL ' + char(10)
			SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_01 ' + char(10)

			SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_02'') IS NOT NULL  ' + char(10)
			SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_02 ' + char(10)

			SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#SCM_BOM'') IS NOT NULL ' + char(10)
			SELECT @v_dSql += N'DROP TABLE #SCM_BOM ' + char(10)

			SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#ASSY_MODEL_2'') IS NOT NULL ' + char(10)
			SELECT @v_dSql += N'DROP TABLE #ASSY_MODEL_2 ' + char(10)

		END

		-- #SCM_BOM 데이터 삽입 
		BEGIN
			
			SELECT @v_dSql += N'------------------ insert into #SCM_BOM ' + char(10)
			SELECT @v_dSql += N'SELECT * ' + char(10)
			SELECT @v_dSql += N'INTO #SCM_BOM ' + char(10)
			SELECT @v_dSql += N'FROM ( ' + char(10)
			-- 1. 노칭 하위 코터가 line assign 기준으로 명확히 검색 가능한 케이스
			SELECT @v_dSql += N'		      		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.PARENT_QTY, A.PARENT_UOM, A.CHILD_ITEM_ID, A.CHILD_QTY, A.CHILD_UOM, ' + char(10)
			SELECT @v_dSql += N'		      				A.ALT_ID, A.ALT_PRIORITY, A.EFF_START_DATE, A.EFF_END_DATE, B.FACTORY_ID, B.ASSY_FACTORY_ID, B.MONTH, B.PRIORITY, ' + char(10)
			SELECT @v_dSql += N'		      				RANK() OVER ( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.PARENT_QTY ' + char(10)
			SELECT @v_dSql += N'		      										 , A.EFF_START_DATE, A.EFF_END_DATE, B.FACTORY_ID, B.ASSY_FACTORY_ID, B.MONTH ' + char(10)
			SELECT @v_dSql += N'		      							  ORDER BY CASE WHEN B.PRIORITY IS NULL THEN 9 ELSE 1 END, ISNULL(A.ALT_PRIORITY, 1), ISNULL(B.PRIORITY, 9) ) AS RNK ' + char(10)
			SELECT @v_dSql += N'		      		FROM   SCM_BOM_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'				    INNER JOIN ( ' + char(10)
			SELECT @v_dSql += N'				          	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.FACTORY_ID, A.ITEM_ID,  A.MONTH, A.PRIORITY, B.ASSY_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'				          	FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'						    INNER HASH JOIN ( ' + char(10)
			SELECT @v_dSql += N'									SELECT SEGMENT1 AS ASSY_FACTORY_ID, SEGMENT2 AS ELEC_FACTORY_ID' + char(10)
			SELECT @v_dSql += N'									FROM   SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)' + char(10)
			SELECT @v_dSql += N'									WHERE  1=1' + char(10)
			SELECT @v_dSql += N'									AND    LOOKUP_TYPE_CODE = ''ELEC_ASSY_FACTORY_MAP'' ' + char(10)
			SELECT @v_dSql += N'									AND    ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'				          	) B ' + char(10)
			SELECT @v_dSql += N'				          	ON    1=1 ' + char(10)
			SELECT @v_dSql += N'				          	AND   A.FACTORY_ID = B.ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'				          	WHERE 1=1 ' + char(10)
			SELECT @v_dSql += N'				          	AND   A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'				          	AND   A.MONTH BETWEEN SUBSTRING(''' + @p_bucket_from + ''',1,6) AND SUBSTRING(''' + @p_bucket_to + ''',1,6) ' + char(10)
			SELECT @v_dSql += N'				          	AND   A.PRIORITY NOT IN (0,9) ' + char(10)
			SELECT @v_dSql += N'				    ) B ' + char(10)
			SELECT @v_dSql += N'				    ON    1=1 ' + char(10)
			SELECT @v_dSql += N'				    AND   A.COMPANY_ID     = B.COMPANY_ID' + char(10)
			SELECT @v_dSql += N'				    AND   A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'				    AND   A.SITE_ID        = B.SITE_ID' + char(10)
			SELECT @v_dSql += N'				    AND   A.CHILD_ITEM_ID  = B.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'				    AND   B.MONTH <  = CONVERT(VARCHAR(6),A.EFF_END_DATE,112), ' + char(10)
			SELECT @v_dSql += N'		      		TH_UIS_CAL C WITH(NOLOCK), ' + char(10)
			SELECT @v_dSql += N'		      		( SELECT  * FROM FP_INSTANCE_PANCAKE_V WITH(NOLOCK) WHERE INSTANCE_ID = ''' + @p_instance_id + ''' AND GUBUN= ''BOM'' AND ACTIVE_FLAG = ''Y'' ) E ' + char(10)
			SELECT @v_dSql += N'		      		, SCM_ITEM_M CC WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'		      		, SCM_ITEM_CLASS_M DD WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'		      		, SCM_ITEM_M EE WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'		      		, SCM_ITEM_CLASS_M FF WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'		      		WHERE 1=1 ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.COMPANY_ID     = E.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.DIVISION_ID    = E.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.SITE_ID        = E.SITE_ID ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.PLANT_ID       = E.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.ACTIVE_FLAG    = ''Y'' ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.EFF_START_DATE = C.DT ' + char(10)
			SELECT @v_dSql += N'		      		AND  C.YEAR + C.MONTH < = ISNULL(B.MONTH, C.YEAR + C.MONTH) ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.COMPANY_ID     = CC.COMPANY_ID' + char(10)
			SELECT @v_dSql += N'		      		AND  A.DIVISION_ID    = CC.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.SITE_ID        = CC.SITE_ID ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.PARENT_ITEM_ID = CC.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'		      		AND  CC.ITEM_CLASS    = DD.CLASS_ID ' + char(10)
			SELECT @v_dSql += N'		      		AND  DD.LEVEL_2_NAME IN (''Notched Pancake'', ''Jelly Roll'') ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.COMPANY_ID     = EE.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.DIVISION_ID    = EE.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.SITE_ID        = EE.SITE_ID' + char(10)
			SELECT @v_dSql += N'		      		AND  A.CHILD_ITEM_ID  = EE.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'		      		AND  EE.ITEM_CLASS    = FF.CLASS_ID ' + char(10)
			SELECT @v_dSql += N'		      		AND  FF.LEVEL_2_NAME  = ''Pancake'' ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.EFF_START_DATE<= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'		      		AND  A.EFF_END_DATE   > ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'    ) A ' + char(10)
			SELECT @v_dSql += N'    WHERE 1=1 ' + char(10)
			SELECT @v_dSql += N'    AND   A.RNK = 1 ' + char(10)
			-- 2. 코터가 line assign 기준으로 검색 불가 : 순수 bom 검색
			SELECT @v_dSql += N'    UNION ALL ' + char(10)
			SELECT @v_dSql += N'	SELECT * ' + char(10)
			SELECT @v_dSql += N'	FROM ( ' + char(10)
			SELECT @v_dSql += N'        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.PARENT_QTY, A.PARENT_UOM ' + char(10)
			SELECT @v_dSql += N'            	, A.CHILD_ITEM_ID, A.CHILD_QTY, A.CHILD_UOM, A.ALT_ID, A.ALT_PRIORITY, A.EFF_START_DATE, A.EFF_END_DATE ' + char(10)
			SELECT @v_dSql += N'            	, NULL AS FACTORY_ID, NULL AS ASSY_FACTORY_ID, NULL AS MONTH, NULL AS PRIORITY ' + char(10)
			SELECT @v_dSql += N'            	, RANK() OVER ( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.PARENT_QTY, A.EFF_START_DATE, A.EFF_END_DATE ' + char(10)
			SELECT @v_dSql += N'            		      		ORDER BY     ISNULL(A.ALT_PRIORITY,1), a.child_item_id ) AS RNK ' + char(10) -- alt priority + coater item 순 랭크
			SELECT @v_dSql += N'        FROM   SCM_BOM_M A WITH(NOLOCK)' + char(10)
			SELECT @v_dSql += N'        ,( SELECT  * FROM FP_INSTANCE_PANCAKE_V WITH(NOLOCK) WHERE INSTANCE_ID = ''' + @p_instance_id + ''' AND GUBUN= ''BOM'' AND ACTIVE_FLAG = ''Y'' ) E' + char(10)
			SELECT @v_dSql += N'        , SCM_ITEM_M CC WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'        , SCM_ITEM_CLASS_M DD WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'        , SCM_ITEM_M EE WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'        , SCM_ITEM_CLASS_M FF WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'        WHERE  1=1 ' + char(10)
			SELECT @v_dSql += N'        AND  A.COMPANY_ID     = E.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'        AND  A.DIVISION_ID    = E.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'        AND  A.SITE_ID        = E.SITE_ID ' + char(10)
			SELECT @v_dSql += N'        AND  A.PLANT_ID       = E.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'        AND  A.ACTIVE_FLAG    = ''Y'' ' + char(10)
			SELECT @v_dSql += N'        AND  A.COMPANY_ID     = CC.COMPANY_ID' + char(10)
			SELECT @v_dSql += N'        AND  A.DIVISION_ID    = CC.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'        AND  A.SITE_ID        = CC.SITE_ID ' + char(10)
			SELECT @v_dSql += N'        AND  A.PARENT_ITEM_ID = CC.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'        AND  CC.ITEM_CLASS    = DD.CLASS_ID ' + char(10)
			SELECT @v_dSql += N'        AND  DD.LEVEL_2_NAME IN (''Notched Pancake'', ''Jelly Roll'') ' + char(10)
			SELECT @v_dSql += N'        AND  A.COMPANY_ID     = EE.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'        AND  A.DIVISION_ID    = EE.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'        AND  A.SITE_ID        = EE.SITE_ID ' + char(10)
			SELECT @v_dSql += N'        AND  A.CHILD_ITEM_ID  = EE.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'        AND  EE.ITEM_CLASS    = FF.CLASS_ID ' + char(10)
			SELECT @v_dSql += N'        AND  FF.LEVEL_2_NAME  = ''Pancake'' ' + char(10)
			SELECT @v_dSql += N'        AND  A.EFF_START_DATE<= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'        AND  A.EFF_END_DATE   > ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N') A ' + char(10)
			SELECT @v_dSql += N'WHERE 1=1' + char(10)
			SELECT @v_dSql += N'AND A.RNK = 1' + char(10)
			SELECT @v_dSql += N'OPTION (FORCE ORDER) ' + char(10)
			SELECT @v_dSql += N'; ' + char(10)
				
			--EXEC SP_EXECUTESQL @v_dSql;
			--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SCM_BOM',@runstart, @runend

		END

		-- #ASSY_MODEL_2 데이터 삽입
		BEGIN
			--SET	@v_dSql = '' -- 이놈 주석막으면 SQL 에 내용 담김
			SELECT @v_dSql += N'------------------ insert into #ASSY_MODEL_2 ' + char(10)
			SELECT @v_dSql += N'WITH INSTANCE_T AS ( ' + char(10)
			SELECT @v_dSql += N'  		SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'  		FROM   SCM_FACTORY_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'  		INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'  		ON    A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'  		AND   B.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'  		WHERE A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'  		AND   B.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			SELECT @v_dSql += N', COATER_PLAN AS ( ' + char(10)
			SELECT @v_dSql += N'    SELECT A.* ' + char(10)
			SELECT @v_dSql += N'    FROM ( ' + char(10)
			SELECT @v_dSql += N'	        SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE ' + char(10)
			SELECT @v_dSql += N'	                , RELEASE_PLAN_ID, INSERT_TIME ' + char(10)
			SELECT @v_dSql += N'	                , ROW_NUMBER() OVER( PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END)' + char(10)
			SELECT @v_dSql += N'            	                		 ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM ' + char(10)
			SELECT @v_dSql += N'	        FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'	        WHERE  A.INSTANCE_DATE <= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'    ) A ' + char(10)
			SELECT @v_dSql += N'    WHERE A.ROW_NUM = 1 ' + char(10)
			SELECT @v_dSql += N'    AND   A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)

			IF ISNULL(@p_release_flag,'N') = 'Y' BEGIN SELECT @v_dSql += N'    AND   1=1 ' + char(10) END
			ELSE BEGIN                                 SELECT @v_dSql += N'    AND   1=0 ' + char(10) END

			SELECT @v_dSql += N'    UNION ALL ' + char(10)
			SELECT @v_dSql += N'    SELECT A.INSTANCE_ID, ''-'' AS RELEASE_VALUE, A.PLAN_ID AS RELEASE_PLAN_ID, A.INSERT_TIME, 1 AS ROW_NM ' + char(10)
			SELECT @v_dSql += N'    FROM   SCM_FP_PLAN_H A WITH(NOLOCK) ' + char(10)

			IF ISNULL(@p_release_flag,'N') = 'Y' BEGIN SELECT @v_dSql += N'    WHERE   1=0 ' + char(10) END
			ELSE BEGIN                                 SELECT @v_dSql += N'    WHERE   1=1 ' + char(10) END

			SELECT @v_dSql += N'    AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'    AND    A.PLAN_ID     = ''' + @p_plan_id + ''' ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			SELECT @v_dSql += N', ASSY_PLAN AS ( ' + char(10)
			SELECT @v_dSql += N'    SELECT A.* ' + char(10)
			SELECT @v_dSql += N'    FROM (' + char(10)
			SELECT @v_dSql += N'	        SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE ' + char(10)
			SELECT @v_dSql += N'	                , RELEASE_PLAN_ID, INSERT_TIME ' + char(10)
			SELECT @v_dSql += N'	                , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) ' + char(10)
			SELECT @v_dSql += N'	                					ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM ' + char(10)
			SELECT @v_dSql += N'	        FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'	        WHERE  A.INSTANCE_ID IN (   SELECT A.SEGMENT2 AS ASSY_ID ' + char(10)
			SELECT @v_dSql += N'              							FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'              							WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_INSTANCE_MAP'' ' + char(10)
			SELECT @v_dSql += N'              							AND    A.SEGMENT1 = ''' + @p_instance_id + ''' ) ' + char(10)
			
			
			IF ISNULL(@p_release_flag,'N') = 'Y' OR ISNULL(@p_chk_planid,'N') = 'Y'  BEGIN
				SELECT @v_dSql += N'    AND  A.INSTANCE_DATE <= ''' + @p_plan_date + ''' ' + char(10) 
			END
			ELSE BEGIN
				SELECT @v_dSql += N'    AND  A.INSERT_TIME <= ( SELECT INSERT_TIME FROM COATER_PLAN ) ' + char(10) 
			END
			
			SELECT @v_dSql += N'    ) A' + char(10)
			SELECT @v_dSql += N'    WHERE A.ROW_NUM = 1' + char(10)
			-- 현재 배포단위 기준으로만 id 가져오도록 조건추가(building or plan group)... 20201125
			-- RELEASE_VALUE
			SELECT @v_dSql += N'    AND   A.RELEASE_VALUE IN ( ' + char(10)
			SELECT @v_dSql += N'    				SELECT DISTINCT ISNULL(B.FACTORY_ID, C.PLAN_GROUP_ID) AS RELEASE_VALUE ' + char(10)
			SELECT @v_dSql += N'    				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'    				LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'    						SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS FACTORY_ID, ''BUILDING'' AS CONFIRM_AREA' + char(10)
			SELECT @v_dSql += N'    						FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'    						WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_FACTORY_RELEASE_TERM'' ' + char(10)
			SELECT @v_dSql += N'    						AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'    				) B ' + char(10)
			SELECT @v_dSql += N'    				ON  A.SEGMENT1     = B.INSTANCE_ID ' + char(10)
			SELECT @v_dSql += N'    				AND A.ATTRIBUTE1   = B.CONFIRM_AREA ' + char(10)
			SELECT @v_dSql += N'    				LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'    						SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID,A.SEGMENT2 AS PLAN_GROUP_ID, ''PLAN GROUP'' AS CONFIRM_AREA ' + char(10)
			SELECT @v_dSql += N'    						FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'    						WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
			SELECT @v_dSql += N'    						AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'    				) C ' + char(10)
			SELECT @v_dSql += N'    				ON  A.SEGMENT1     = C.INSTANCE_ID ' + char(10)
			SELECT @v_dSql += N'    				AND A.ATTRIBUTE1   = C.CONFIRM_AREA ' + char(10)
			SELECT @v_dSql += N'    				WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
			SELECT @v_dSql += N'    				AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'    				AND    A.SEGMENT1 IN ( ' + char(10)
			SELECT @v_dSql += N'    						SELECT A.SEGMENT2 AS ASSY_ID ' + char(10)
			SELECT @v_dSql += N'    						FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'    						WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_INSTANCE_MAP'' ' + char(10)
			SELECT @v_dSql += N'    						AND    A.SEGMENT1 = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'    				) ' + char(10)
			SELECT @v_dSql += N'    ) ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			-- 전극의 model, np item 정보 조회 : 조립계획 bom 및 수량큰 품번 기준
			SELECT @v_dSql += N'SELECT * ' + char(10)
			SELECT @v_dSql += N'INTO #ASSY_MODEL_2 ' + char(10)
			SELECT @v_dSql += N'FROM	( ' + char(10)
			SELECT @v_dSql += N'				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.CHILD_ITEM_ID AS ITEM_ID ' + char(10)
			SELECT @v_dSql += N'							, A.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'							, A.ITEM_ID AS NPC_ITEM_ID ' + char(10)
			SELECT @v_dSql += N'							, A.TOP_ITEM_ID ' + char(10)
			SELECT @v_dSql += N'							, A.QTY ' + char(10)
			SELECT @v_dSql += N'							, C.APPLIED_MODEL AS NPC_APPLIED_MODEL ' + char(10)
			SELECT @v_dSql += N'							, E.APPLIED_MODEL AS PC_APPLIED_MODEL ' + char(10)
			SELECT @v_dSql += N'							, DENSE_RANK() OVER ( PARTITION BY  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.CHILD_ITEM_ID ' + char(10)
			SELECT @v_dSql += N'												  ORDER BY QTY DESC , (CASE WHEN A.TOP_ITEM_ID = C.APPLIED_MODEL THEN 1 WHEN A.TOP_ITEM_ID = E.APPLIED_MODEL THEN 2 ELSE 3 END) ) AS RNK ' + char(10)
			SELECT @v_dSql += N'				FROM ( ' + char(10)
			SELECT @v_dSql += N'						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'								, SUM(A.IN_QTY) AS QTY, ''' + @p_plan_date + ''' AS PLAN_DATE, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'						FROM   FP_AMEND_PLAN_CELL_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'						WHERE  1=1 ' + char(10)
			SELECT @v_dSql += N'						AND    EXISTS ( ' + char(10)
			SELECT @v_dSql += N'								SELECT 1' + char(10)
			SELECT @v_dSql += N'								FROM   ASSY_PLAN CC ' + char(10)
			SELECT @v_dSql += N'								WHERE  A.INSTANCE_ID = CC.INSTANCE_ID ' + char(10)
			SELECT @v_dSql += N'								AND    A.FP_PLAN_ID  = CC.RELEASE_PLAN_ID' + char(10)
			SELECT @v_dSql += N'						) ' + char(10)
			SELECT @v_dSql += N'						AND   A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
			SELECT @v_dSql += N'						AND   A.IN_QTY > 0 ' + char(10)
			SELECT @v_dSql += N'						AND   A.OPERATION_ID IN ( ''A2000'',''A5000'' ) ' + char(10)
			SELECT @v_dSql += N'						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'				) A ' + char(10)
			SELECT @v_dSql += N'				,#SCM_BOM B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'				,SCM_ITEM_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'				,SCM_ITEM_CLASS_M D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'				,SCM_ITEM_M E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'				,SCM_ITEM_CLASS_M F WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'				WHERE 1=1' + char(10)
			SELECT @v_dSql += N'				AND		A.COMPANY_ID     = B.COMPANY_ID' + char(10)
			SELECT @v_dSql += N'				AND		A.DIVISION_ID    = B.DIVISION_ID' + char(10)
			SELECT @v_dSql += N'				AND 	A.SITE_ID        = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'				AND 	A.PLANT_ID       = B.PLANT_ID' + char(10)
			SELECT @v_dSql += N'				AND		A.COMPANY_ID     = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'				AND 	A.DIVISION_ID    = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'				AND 	A.SITE_ID        = C.SITE_ID ' + char(10)
			SELECT @v_dSql += N'				AND		A.COMPANY_ID     = E.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'				AND 	A.DIVISION_ID    = E.DIVISION_ID' + char(10)
			SELECT @v_dSql += N'				AND 	A.SITE_ID        = E.SITE_ID ' + char(10)
			SELECT @v_dSql += N'				AND 	A.ITEM_ID        = B.PARENT_ITEM_ID ' + char(10)
			SELECT @v_dSql += N'				AND 	B.PARENT_ITEM_ID = C.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'				AND 	C.ITEM_CLASS     = D.CLASS_ID ' + char(10)
			SELECT @v_dSql += N'				AND 	D.LEVEL_2_NAME IN (''Notched Pancake'', ''Jelly Roll'') ' + char(10)
			SELECT @v_dSql += N'				AND 	B.CHILD_ITEM_ID  = E.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'				AND 	E.ITEM_CLASS     = F.CLASS_ID ' + char(10)
			SELECT @v_dSql += N'				AND 	F.LEVEL_2_NAME   = ''Pancake'' ' + char(10)
			SELECT @v_dSql += N'				AND 	B.EFF_START_DATE<= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'				AND 	B.EFF_END_DATE   > ''' + @p_plan_date + ''' ' + char(10)

			IF CHARINDEX('_M',@p_instance_id) <> 0 BEGIN
				SELECT @v_dSql += N'				AND  	A.FACTORY_ID     = ISNULL(B.ASSY_FACTORY_ID, A.FACTORY_ID) ' + char(10)
				SELECT @v_dSql += N'				AND  	CONVERT(VARCHAR(6),A.PLAN_DATE,112) = ISNULL(B.MONTH, CONVERT(VARCHAR(6),A.PLAN_DATE,112)) ' + char(10)
			END ELSE BEGIN
				SELECT @v_dSql += N'				AND  	A.FACTORY_ID     = ISNULL(B.ASSY_FACTORY_ID, A.FACTORY_ID) ' + char(10)
				SELECT @v_dSql += N'				AND  	CONVERT(VARCHAR(6),A.PLAN_DATE,112) = ISNULL(B.MONTH, CONVERT(VARCHAR(6),A.PLAN_DATE,112)) ' + char(10)
			END

			SELECT @v_dSql += N') A ' + char(10)
			SELECT @v_dSql += N'WHERE RNK = 1 ' + char(10)
			--SELECT @v_dSql += N'OPTION (FORCE ORDER) ' + char(10)
			SELECT @v_dSql += N'; ' + char(10)

			--EXEC SP_EXECUTESQL @v_dSql;

			--declare @v_tempSql nvarchar(max);
			--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'ASSY_MODEL_2',@runstart, @runend
				
		END


		-- insert #TEMP_TABLE_01
		BEGIN

			--SET	@v_dSql = ''
		    -- INSTANCE_T
			SELECT @v_dSql += N'------------------ insert into #TEMP_TABLE_01 ' + char(10)
			SELECT @v_dSql += N'WITH INSTANCE_T AS ( ' + char(10)
			SELECT @v_dSql += N'  		SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'  		FROM   SCM_FACTORY_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'  		INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'  		ON    A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'  		AND   B.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'  		WHERE A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'  		AND   B.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			-- COATER PLAN
			SELECT @v_dSql += N', COATER_PLAN AS ( ' + char(10)
			SELECT @v_dSql += N'    SELECT A.* ' + char(10)
			SELECT @v_dSql += N'    FROM ( ' + char(10)
			SELECT @v_dSql += N'	        SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE ' + char(10)
			SELECT @v_dSql += N'	                , RELEASE_PLAN_ID, INSERT_TIME ' + char(10)
			SELECT @v_dSql += N'	                , ROW_NUMBER() OVER( PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END)' + char(10)
			SELECT @v_dSql += N'            	                		 ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM ' + char(10)
			SELECT @v_dSql += N'	        FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'	        WHERE  A.INSTANCE_DATE <= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'    ) A ' + char(10)
			SELECT @v_dSql += N'    WHERE A.ROW_NUM = 1 ' + char(10)
			SELECT @v_dSql += N'    AND   A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)

			IF ISNULL(@p_release_flag,'N') = 'Y' BEGIN SELECT @v_dSql += N'    AND   1=1 ' + char(10) END
			ELSE BEGIN                                 SELECT @v_dSql += N'    AND   1=0 ' + char(10) END

			SELECT @v_dSql += N'    UNION ALL ' + char(10)
			SELECT @v_dSql += N'    SELECT A.INSTANCE_ID, ''-'' AS RELEASE_VALUE, A.PLAN_ID AS RELEASE_PLAN_ID, A.INSERT_TIME, 1 AS ROW_NM ' + char(10)
			SELECT @v_dSql += N'    FROM   SCM_FP_PLAN_H A WITH(NOLOCK) ' + char(10)

			IF ISNULL(@p_release_flag,'N') = 'Y' BEGIN SELECT @v_dSql += N'    WHERE   1=0 ' + char(10) END
			ELSE BEGIN                                 SELECT @v_dSql += N'    WHERE   1=1 ' + char(10) END

			SELECT @v_dSql += N'    AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'    AND    A.PLAN_ID     = ''' + @p_plan_id + ''' ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			-- ASSY PLAN
			SELECT @v_dSql += N', ASSY_PLAN AS ( ' + char(10)
			SELECT @v_dSql += N'    SELECT A.* ' + char(10)
			SELECT @v_dSql += N'    FROM (' + char(10)
			SELECT @v_dSql += N'	        SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE ' + char(10)
			SELECT @v_dSql += N'	                , RELEASE_PLAN_ID, INSERT_TIME ' + char(10)
			SELECT @v_dSql += N'	                , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) ' + char(10)
			SELECT @v_dSql += N'	                					ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM ' + char(10)
			SELECT @v_dSql += N'	        FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'	        WHERE  A.INSTANCE_ID IN (   SELECT A.SEGMENT2 AS ASSY_ID ' + char(10)
			SELECT @v_dSql += N'              							FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'              							WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_INSTANCE_MAP'' ' + char(10)
			SELECT @v_dSql += N'              							AND    A.SEGMENT1 = ''' + @p_instance_id + ''' ) ' + char(10)
			
			
			IF ISNULL(@p_release_flag,'N') = 'Y' OR ISNULL(@p_chk_planid,'N') = 'Y'  BEGIN
				SELECT @v_dSql += N'    AND  A.INSTANCE_DATE <= ''' + @p_plan_date + ''' ' + char(10) 
			END
			ELSE BEGIN
				SELECT @v_dSql += N'    AND  A.INSERT_TIME <= ( SELECT INSERT_TIME FROM COATER_PLAN ) ' + char(10) 
			END
			
			SELECT @v_dSql += N'    ) A' + char(10)
			SELECT @v_dSql += N'    WHERE A.ROW_NUM = 1' + char(10)
			-- 현재 배포단위 기준으로만 id 가져오도록 조건추가(building or plan group)... 20201125
			-- RELEASE_VALUE
			SELECT @v_dSql += N'    AND   A.RELEASE_VALUE IN ( ' + char(10)
			SELECT @v_dSql += N'    				SELECT DISTINCT ISNULL(B.FACTORY_ID, C.PLAN_GROUP_ID) AS RELEASE_VALUE ' + char(10)
			SELECT @v_dSql += N'    				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'    				LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'    						SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS FACTORY_ID, ''BUILDING'' AS CONFIRM_AREA' + char(10)
			SELECT @v_dSql += N'    						FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'    						WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_FACTORY_RELEASE_TERM'' ' + char(10)
			SELECT @v_dSql += N'    						AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'    				) B ' + char(10)
			SELECT @v_dSql += N'    				ON  A.SEGMENT1     = B.INSTANCE_ID ' + char(10)
			SELECT @v_dSql += N'    				AND A.ATTRIBUTE1   = B.CONFIRM_AREA ' + char(10)
			SELECT @v_dSql += N'    				LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'    						SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID,A.SEGMENT2 AS PLAN_GROUP_ID, ''PLAN GROUP'' AS CONFIRM_AREA ' + char(10)
			SELECT @v_dSql += N'    						FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'    						WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
			SELECT @v_dSql += N'    						AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'    				) C ' + char(10)
			SELECT @v_dSql += N'    				ON  A.SEGMENT1     = C.INSTANCE_ID ' + char(10)
			SELECT @v_dSql += N'    				AND A.ATTRIBUTE1   = C.CONFIRM_AREA ' + char(10)
			SELECT @v_dSql += N'    				WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
			SELECT @v_dSql += N'    				AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'    				AND    A.SEGMENT1 IN ( ' + char(10)
			SELECT @v_dSql += N'    						SELECT A.SEGMENT2 AS ASSY_ID ' + char(10)
			SELECT @v_dSql += N'    						FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'    						WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_INSTANCE_MAP'' ' + char(10)
			SELECT @v_dSql += N'    						AND    A.SEGMENT1 = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'    				) ' + char(10)
			SELECT @v_dSql += N'    ) ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			-- OPERATION_YIELD
			SELECT @v_dSql += N', OPERATION_YIELD AS ( ' + char(10)
			SELECT @v_dSql += N'	SELECT COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , FACTORY_ID  , ITEM_ID , MONTH ' + char(10)
			SELECT @v_dSql += N'		, (CASE WHEN A.Y3 IS NULL OR A.Y3 = 0 THEN 1 ELSE A.Y3 END) AS Y3 ' + char(10)
			SELECT @v_dSql += N'		, (CASE WHEN A.Y4 IS NULL OR A.Y4 = 0 THEN 1 ELSE A.Y4 END) AS Y4 ' + char(10)
			SELECT @v_dSql += N'	FROM ( ' + char(10)
			SELECT @v_dSql += N'      		SELECT COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , FACTORY_ID  , ITEM_ID , MONTH ' + char(10)
			SELECT @v_dSql += N'      				, MIN(CASE WHEN OPERATION_ID = ''E3000'' THEN YIELD ELSE 1 END) AS Y3 ' + char(10)
			SELECT @v_dSql += N'      				, MIN(CASE WHEN OPERATION_ID = ''E4000'' THEN YIELD ELSE 1 END) AS Y4 ' + char(10)
			SELECT @v_dSql += N'      		FROM ( ' + char(10)
			SELECT @v_dSql += N'      				SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID, A.ITEM_ID , A.MONTH , A.OPERATION_ID,  MIN(A.YIELD) AS YIELD ' + char(10)
			SELECT @v_dSql += N'      				FROM   SCM_YIELD_M A WITH(NOLOCK), INSTANCE_T B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'      				WHERE  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'      				AND	   A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'      				AND	   A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'      				AND	   A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'      				AND    A.OPERATION_ID IN (''E3000'', ''E4000'') ' + char(10)
			SELECT @v_dSql += N'      				AND    A.MONTH BETWEEN CONVERT(VARCHAR(6),''' + @p_bucket_from + ''') AND CONVERT(VARCHAR(6),''' + @p_bucket_to + ''') ' + char(10)
			SELECT @v_dSql += N'      				GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID, A.ITEM_ID , A.MONTH , A.OPERATION_ID ' + char(10)
			SELECT @v_dSql += N'      		) A ' + char(10)
			SELECT @v_dSql += N'      		WHERE 1=1 ' + char(10)
			SELECT @v_dSql += N'      		GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MONTH ' + char(10)
			SELECT @v_dSql += N'	) A ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			-- MAIN_A
			SELECT @v_dSql += N', MAIN_A AS ( ' + char(10)
			SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql += N'			, A.COATER_QTY, A.BATCH_IN_QTY, A.POST_QTY, A.ASSY_QTY' + char(10)
			SELECT @v_dSql += N'			, B.PLANT_ID, B.TOP_ITEM_ID, B.NPC_ITEM_ID ' + char(10)
			SELECT @v_dSql += N'			, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MARKET, A.PRODUCTION_TYPE, A.EQUIPMENT_ID, A.LINE_NAME, A.PROD_VERSION_TYPE, A.ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'	FROM ( ' + char(10)
			        -- Coater
			        -- 3. COATER : FACTORY, OPERATION, LINE, ELEC, MARKET, PRODUCTION TYPE
			        -- 2. POST : -
			SELECT @v_dSql += N'			        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql += N'			        		, (CASE WHEN A.FACTORY_ID = C.ELEC_FAC THEN A.COATER_QTY ELSE 0 END) AS COATER_QTY ' + char(10)
			SELECT @v_dSql += N'			        		, (CASE WHEN A.FACTORY_ID = C.ELEC_FAC THEN A.BATCH_IN_QTY ELSE 0 END) AS BATCH_IN_QTY ' + char(10)
			SELECT @v_dSql += N'			        		, (CASE WHEN A.FACTORY_ID = C.ELEC_FAC THEN A.POST_QTY ELSE 0 END) AS POST_QTY ' + char(10)
			SELECT @v_dSql += N'			        		, A.ASSY_QTY ' + char(10)
			SELECT @v_dSql += N'			        		, A.PLANT_ID, A.TOP_ITEM_ID, A.NPC_ITEM_ID' + char(10)
			SELECT @v_dSql += N'			        		, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MARKET, A.PRODUCTION_TYPE' + char(10)
			SELECT @v_dSql += N'			        		, A.EQUIPMENT_ID, A.LINE_NAME, A.PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'			        		, A.FACTORY_ID AS ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'			        FROM ( ' + char(10)
			SELECT @v_dSql += N'    			        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE ' + char(10)

			-- Panckae M
			IF @p_uom_type = 'PANCAKE' BEGIN
				
				SELECT @v_dSql += N'    								, SUM(CEILING(ISNULL(A.ADJUST_OUT_QTY_M,0))) AS COATER_QTY ' + char(10)
				SELECT @v_dSql += N'    								, SUM(A.ADJUST_IN_QTY_BATCH) AS BATCH_IN_QTY ' + char(10)
				SELECT @v_dSql += N'    								, SUM(CEILING(ISNULL(A.ADJUST_OUT_QTY_M,0)) * ISNULL(B.Y3,1) * ISNULL(B.Y4,1) ) AS POST_QTY ' + char(10)
			END
			-- Jumbo Roll M
			ELSE IF @p_uom_type = 'JUMBO_ROLL' BEGIN
				
				SELECT @v_dSql += N'    								, SUM(CEILING(ISNULL(A.ADJUST_OUT_QTY_JR,0))) AS COATER_QTY ' + char(10)
				SELECT @v_dSql += N'    								, SUM(A.ADJUST_IN_QTY_BATCH) AS BATCH_IN_QTY ' + char(10)
				SELECT @v_dSql += N'    								, SUM(CEILING(ISNULL(A.ADJUST_OUT_QTY_JR,0)) * ISNULL(B.Y3,1) * ISNULL(B.Y4,1) ) AS POST_QTY ' + char(10)
			END
			-- CELL
			ELSE BEGIN
				
				SELECT @v_dSql += N'    								, SUM(CEILING(ISNULL(A.ADJUST_OUT_QTY_CELL,0))) AS COATER_QTY ' + char(10)
				SELECT @v_dSql += N'    								, SUM(A.ADJUST_IN_QTY_BATCH) AS BATCH_IN_QTY ' + char(10)
				SELECT @v_dSql += N'    								, SUM(CEILING(ISNULL(A.ADJUST_OUT_QTY_CELL,0)) * ISNULL(B.Y3,1) * ISNULL(B.Y4,1) ) AS POST_QTY ' + char(10)

			END

			SELECT @v_dSql += N'    			        			, 0 AS ASSY_QTY ' + char(10)
			SELECT @v_dSql += N'    			        			, 0 AS BOH_QTY, NULL AS PLANT_ID, NULL AS TOP_ITEM_ID, NULL AS NPC_ITEM_ID' + char(10)
			SELECT @v_dSql += N'    			        			, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MARKET, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql += N'    			        			, A.EQUIPMENT_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, ISNULL(C.PROD_VERSION_TYPE,''GENERAL'') AS PROD_VERSION_TYPE ' + char(10)

			IF @p_release_flag = 'Y' OR @p_plan_type = 'RELEASE' BEGIN
				
				SELECT @v_dSql += N'    			        FROM   FP_AMEND_DAILY_PLAN_H A WITH(NOLOCK) ' + char(10)
			END
			ELSE BEGIN
				
				SELECT @v_dSql += N'    			        FROM   FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK) ' + char(10)
			END

			SELECT @v_dSql += N'    			        LEFT OUTER HASH JOIN OPERATION_YIELD B ' + char(10)
			SELECT @v_dSql += N'    			        ON 	  A.COMPANY_ID   = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'    			        AND	  A.DIVISION_ID  = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'    			        AND	  A.SITE_ID      = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    			        AND	  A.PLANT_ID     = B.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'    			        AND	  A.FACTORY_ID   = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'    			        AND	  A.ITEM_ID      = B.ITEM_ID' + char(10)
			SELECT @v_dSql += N'    			        AND	  CONVERT(VARCHAR(6),A.PLAN_DATE,112)  = B.MONTH ' + char(10)
			SELECT @v_dSql += N'    			        LEFT OUTER HASH JOIN SCM_LINE_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'    			        ON    A.COMPANY_ID     = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'    			        AND   A.DIVISION_ID    = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'    			        AND   A.SITE_ID        = C.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    			        AND   A.PLANT_ID       = C.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'    			        AND   A.FACTORY_ID     = C.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'    			        AND   A.OPERATION_ID   = C.OPERATION_ID ' + char(10)
			SELECT @v_dSql += N'    			        AND   A.LINE_ID        = C.LINE_ID ' + char(10)
			SELECT @v_dSql += N'    			        AND   A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql += N'    			        WHERE A.INSTANCE_ID  = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'    			        AND   A.FP_PLAN_ID IN ( SELECT RELEASE_PLAN_ID FROM COATER_PLAN) ' + char(10)
			SELECT @v_dSql += N'    			        AND   A.OPERATION_ID = ''E2000'' ' + char(10)
			SELECT @v_dSql += N'    			        AND	  A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''' ) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' ) ' + char(10)
			SELECT @v_dSql += N'    			        AND   A.ADJUST_IN_QTY_BATCH > 0 ' + char(10)
			SELECT @v_dSql += N'    			        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) ' + char(10)
			SELECT @v_dSql += N'    			        		, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MARKET, A.PRODUCTION_TYPE, A.EQUIPMENT_ID, C.LINE_NAME, C.PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'			        ) A ' + char(10)
			SELECT @v_dSql += N'			        LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'							SELECT DISTINCT A.FACTORY_ID AS ELEC_FAC ' + char(10)
			SELECT @v_dSql += N'							FROM   SCM_FACTORY_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N' 							WHERE  1=1 ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql += N'			        ) C' + char(10)
			--ON A.FACTORY_ID = C.ELEC_FAC
			SELECT @v_dSql += N'			        ON 1=1' + char(10)
			SELECT @v_dSql += N'			        UNION ALL' + char(10)
			        -- Assy - 계획구간
			        -- 1. ASSY : FACTORY, MARKET, PRODUCTION_TYPE
			SELECT @v_dSql += N'			        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql += N'							, A.COATER_QTY, A.BATCH_IN_QTY, A.POST_QTY ' + char(10)
							-- 계획수량 없는 전극 동의 BOH를 강제로 표시하기 위한 처리... 전극 동 매칭되지않을 경우, 0 수량으로 데이터 강제 생성
			SELECT @v_dSql += N'							, (CASE WHEN A.FACTORY_ID = ISNULL(C.ASSY_FAC, A.FACTORY_ID) THEN A.ASSY_QTY ELSE 0 END) AS ASSY_QTY ' + char(10)
			SELECT @v_dSql += N'							, A.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'							, A.TOP_ITEM_ID, A.NPC_ITEM_ID ' + char(10)
			SELECT @v_dSql += N'							, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MARKET, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql += N'							, A.EQUIPMENT_ID, A.LINE_NAME, A.PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'							, C.ELEC_FAC AS ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'			        FROM ( ' + char(10)
			SELECT @v_dSql += N'    		        	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    		        			, ISNULL(B.CHILD_ITEM_ID, ISNULL(C.CHILD_ITEM_ID, D.CHILD_ITEM_ID)) AS ITEM_ID ' + char(10)
			SELECT @v_dSql += N'    		        			, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql += N'          		        		, 0 AS COATER_QTY, 0 AS BATCH_IN_QTY, 0 AS POST_QTY ' + char(10)

			IF @p_uom_type = 'CELL' BEGIN

				SELECT @v_dSql += N'          		        		, SUM(A.CELL_IN_QTY) AS ASSY_QTY ' + char(10)
			END
			ELSE IF @p_uom_type = 'PANCAKE' BEGIN
				
				SELECT @v_dSql += N'          		        		, SUM(A.IN_QTY * (ISNULL(B.CHILD_QTY, ISNULL(C.CHILD_QTY, D.CHILD_QTY)) / ISNULL(B.PARENT_QTY, ISNULL(C.PARENT_QTY, D.PARENT_QTY))) ) AS ASSY_QTY ' + char(10)
			END
			ELSE BEGIN
				
				SELECT @v_dSql += N'          		        		, SUM(A.IN_QTY * (ISNULL(B.CHILD_QTY, ISNULL(C.CHILD_QTY, D.CHILD_QTY)) / ISNULL(B.PARENT_QTY, ISNULL(C.PARENT_QTY, D.PARENT_QTY))) / ISNULL(G.LANE_QTY, 1) )  AS ASSY_QTY ' + char(10)
			END
			
			SELECT @v_dSql += N'          		        	, 0 AS BOH_QTY, A.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'          		        	, A.TOP_ITEM_ID, A.ITEM_ID AS NPC_ITEM_ID ' + char(10)
			SELECT @v_dSql += N'          		        	, A.FACTORY_ID, NULL AS OPERATION_ID, NULL AS LINE_ID, NULL AS ELECTRODE_TYPE, A.MARKET, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql += N'          		        	, NULL AS EQUIPMENT_ID, NULL AS LINE_NAME, NULL AS PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'    		        	FROM 	FP_AMEND_PLAN_CELL_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'    		        	LEFT OUTER JOIN ' + char(10)

			IF CHARINDEX('_M',@p_instance_id) <> 0 BEGIN
				
				SELECT @v_dSql += N'#SCM_BOM B WITH(NOLOCK) ' + char(10)
			END
			ELSE BEGIN
				
				SELECT @v_dSql += N'#SCM_BOM B WITH(NOLOCK) ' + char(10)
			END

			SELECT @v_dSql += N'						ON      1=1 ' + char(10)
			SELECT @v_dSql += N'						AND		A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'						AND		A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'						AND 	A.SITE_ID        = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'						AND     A.PLANT_ID       = B.PLANT_ID' + char(10)
			SELECT @v_dSql += N'						AND 	A.ITEM_ID        = B.PARENT_ITEM_ID ' + char(10)
			SELECT @v_dSql += N'						AND 	B.EFF_START_DATE <= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'						AND 	B.EFF_END_DATE    > ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'						AND  	A.FACTORY_ID = B.ASSY_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'						AND  	CONVERT(VARCHAR(6),A.PLAN_DATE,112) = B.MONTH ' + char(10)
			SELECT @v_dSql += N'    		        	LEFT OUTER JOIN ' + char(10)

			IF CHARINDEX('_M',@p_instance_id) <> 0 BEGIN
				
				SELECT @v_dSql += N'#SCM_BOM C WITH(NOLOCK) ' + char(10)
			END
			ELSE BEGIN
				
				SELECT @v_dSql += N'#SCM_BOM C WITH(NOLOCK) ' + char(10)
			END

			SELECT @v_dSql += N'						ON      1=1 ' + char(10)
			SELECT @v_dSql += N'						AND		A.COMPANY_ID     = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'						AND		A.DIVISION_ID    = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'						AND 	A.SITE_ID        = C.SITE_ID ' + char(10)
			SELECT @v_dSql += N'						AND     A.PLANT_ID       = C.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'						AND 	A.ITEM_ID        = C.PARENT_ITEM_ID ' + char(10)
			SELECT @v_dSql += N'						AND 	C.EFF_START_DATE <= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'						AND 	C.EFF_END_DATE    > ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'						AND     C.ASSY_FACTORY_ID IS NULL ' + char(10)
			SELECT @v_dSql += N'						AND     C.MONTH IS NULL ' + char(10)
			SELECT @v_dSql += N'						LEFT OUTER JOIN SCM_BOM_M D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'						ON      1=1 ' + char(10)
			SELECT @v_dSql += N'						AND		A.COMPANY_ID     = D.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'						AND		A.DIVISION_ID    = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'						AND 	A.SITE_ID        = D.SITE_ID ' + char(10)
			SELECT @v_dSql += N'						AND     A.PLANT_ID       = D.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'						AND 	A.ITEM_ID        = D.PARENT_ITEM_ID ' + char(10)
			SELECT @v_dSql += N'						AND 	D.EFF_START_DATE <= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'						AND 	D.EFF_END_DATE    > ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'						AND 	(D.ALT_PRIORITY IS NULL OR D.ALT_PRIORITY = 1) ' + char(10)
			SELECT @v_dSql += N'						AND 	D.CHILD_ITEM_ID LIKE ''APC%'' ' + char(10)
			SELECT @v_dSql += N'						AND 	C.CHILD_ITEM_ID = D.CHILD_ITEM_ID ' + char(10)
			SELECT @v_dSql += N'                      	LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql += N'								SELECT A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, MIN(LANE_QTY) AS LANE_QTY ' + char(10)
			SELECT @v_dSql += N'								FROM   SCM_ITEM_LANE_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'								WHERE  A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'								GROUP BY A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'						) G ' + char(10)
			SELECT @v_dSql += N'						ON  1=1 ' + char(10)
			SELECT @v_dSql += N'						AND A.SITE_ID 	 = G.SITE_ID ' + char(10)
			SELECT @v_dSql += N'						AND A.PLANT_ID 	 = G.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'						AND A.FACTORY_ID = G.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'						AND ISNULL(B.CHILD_ITEM_ID, ISNULL(C.CHILD_ITEM_ID, D.CHILD_ITEM_ID)) = G.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'    		        	WHERE EXISTS ( ' + char(10)
			SELECT @v_dSql += N'    	        				SELECT 1 ' + char(10)
			SELECT @v_dSql += N'    	        				FROM   ASSY_PLAN CC ' + char(10)
			SELECT @v_dSql += N'    	        				WHERE  A.INSTANCE_ID = CC.INSTANCE_ID ' + char(10)
			SELECT @v_dSql += N'    	        				AND    A.FP_PLAN_ID  = CC.RELEASE_PLAN_ID ' + char(10)
			SELECT @v_dSql += N'    		    		) ' + char(10)
			SELECT @v_dSql += N'    		        	AND A.OPERATION_ID IN ( ''A5000'',''A2000'' ) ' + char(10)
			SELECT @v_dSql += N'    		        	AND	A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10)
			SELECT @v_dSql += N'    		        	AND	A.IN_QTY > 0 ' + char(10)
			SELECT @v_dSql += N'    		        	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID ' + char(10)
			SELECT @v_dSql += N'          		        		, A.ITEM_ID, ISNULL(B.CHILD_ITEM_ID, ISNULL(C.CHILD_ITEM_ID, D.CHILD_ITEM_ID)) ' + char(10)
			SELECT @v_dSql += N'          		        		, A.PLAN_DATE, A.FACTORY_ID, A.MARKET, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql += N'    					) A ' + char(10)
			SELECT @v_dSql += N'			        	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'								SELECT JJ.SEGMENT1 AS ASSY_FAC, JJ.SEGMENT2 AS ELEC_FAC ' + char(10)
			SELECT @v_dSql += N'								FROM   SCM_SYS_LOOKUP_VALUE JJ WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'								WHERE  JJ.LOOKUP_TYPE_CODE = ''ELEC_ASSY_FACTORY_MAP'' ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('JJ.SEGMENT2' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql += N'			        	) C ' + char(10)
			        	--ON A.FACTORY_ID = C.ASSY_FAC
			SELECT @v_dSql += N'			        	ON 1=1 ' + char(10)
			SELECT @v_dSql += N'	) A ' + char(10)
			SELECT @v_dSql += N'	LEFT OUTER HASH JOIN #ASSY_MODEL_2 B ' + char(10)
			SELECT @v_dSql += N'	ON  1=1 ' + char(10)
	--AND A.COMPANY_ID  = B.COMPANY_ID
	--AND A.DIVISION_ID = (CASE WHEN B.DIVISION_ID = '82' THEN '81' ELSE B.DIVISION_ID END)
			SELECT @v_dSql += N'	AND (CASE WHEN A.DIVISION_ID = ''82'' THEN ''81'' ELSE A.DIVISION_ID END) = (CASE WHEN B.DIVISION_ID = ''82'' THEN ''81'' ELSE B.DIVISION_ID END) ' + char(10)
			SELECT @v_dSql += N'	AND A.SITE_ID     = B.SITE_ID' + char(10)
			SELECT @v_dSql += N'	AND A.ITEM_ID     = B.ITEM_ID' + char(10)
			SELECT @v_dSql += N'	WHERE	1=1' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
			SELECT @v_dSql += N') ' + char(10)
			--SELECT @v_dSql += N'INSERT INTO #TEMP_TABLE_01 ' + char(10)
			SELECT @v_dSql += N'SELECT * INTO #TEMP_TABLE_01 FROM MAIN_A ' + char(10)
			--SELECT @v_dSql += N'OPTION (FORCE ORDER) ' + char(10)
			SELECT @v_dSql += N'; ' + char(10)

			--EXEC SP_EXECUTESQL @v_dSql;
			--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'insert 1',@runstart, @runend

		END

		-- insert #TEMP_TABLE_02
		BEGIN
			
			--SET	@v_dSql = '' -- 이놈 주석막으면 SQL 에 내용 담김
			SELECT @v_dSql += N'------------------ insert into #TEMP_TABLE_02 ' + char(10)
			SELECT @v_dSql += N'WITH MAIN_A AS ( ' + char(10)
			SELECT @v_dSql += N'    SELECT * FROM #TEMP_TABLE_01 ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			-- ASSY
			SELECT @v_dSql += N', MAIN AS ( ' + char(10)
			SELECT @v_dSql += N'	SELECT A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'        , A.ITEM_ID, ISNULL(E.NICK_NAME,''-'') AS NICK_NAME, E.ITEM_TYPE, ISNULL(E.APPLIED_MODEL, A.ITEM_ID) AS MODEL_T, E.ITEM_CLASS  ' + char(10)
			SELECT @v_dSql += N'        , A.PLANT_ID, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ELEC_FACTORY_ID, NULL AS APPLIED_MODEL ' + char(10)
			SELECT @v_dSql += N'        , A.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'        , NULL AS OPERATION_ID, NULL AS LINE_ID, NULL AS ELECTRODE_TYPE, A.MARKET, A.PRODUCTION_TYPE, A.EQUIPMENT_ID, NULL AS LINE_NAME, NULL AS PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'        , ''ASSY'' AS CATEGORY_ID, ''Assy Plan(Notching)'' CATEGORY_NAME, 10 CATEGORY_ORDER, 10 CATEGORY_ORDER_LV1, ''UOM Type'' AS MEASURE ' + char(10)
			SELECT @v_dSql += N'  		, ''DATA'' AS DATA_TYPE ' + char(10)
			SELECT @v_dSql += N'  		, ''N'' AS IS_ROLE ' + char(10)

			IF ISNULL(@p_bucket,'') <> '' BEGIN
				
				IF @max_loop_cnt > 0 BEGIN
					
					-- monthinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						
						SELECT @v_dSql += N'  		, 0 AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END

					-- weekinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						
						SELECT @v_dSql += N'  		, 0 AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END

					-- bucket
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						SET @tmp_column = ''
						SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_row_delimiter, @mst_loop_cnt)
						SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
						IF @sub_max_loop_cnt > 0 BEGIN	SET @sub_param_0 = [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END

						SELECT @v_dSql += N'  		, SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN (ROUND(A.ASSY_QTY,0)) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				/*
						for(var i = 0; i < list.size(); i++) {
							sql+=", SUM(CASE WHEN A.PLAN_DATE = '" + list[i].VALUE + "' THEN (ROUND(A.ASSY_QTY,0)) ELSE 0 END) AS D" + i + "\r\n";
						}
				*/

					END

				END --end of @max_loop_cnt
			END -- end of isnull(@p_bucket,'') <> ''

			SELECT @v_dSql += N'  	FROM  MAIN_A A ' + char(10)
			SELECT @v_dSql += N'  	INNER HASH JOIN SCM_ITEM_M E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'  	ON  A.DIVISION_ID = E.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'  	AND A.SITE_ID     = E.SITE_ID ' + char(10)
			SELECT @v_dSql += N'  	AND A.ITEM_ID     = E.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'  	AND E.COMPANY_ID  = (SELECT DISTINCT COMPANY_ID FROM FP_INSTANCE_OPERATION_V VV WITH(NOLOCK) WHERE INSTANCE_ID = ''' + @p_instance_id + ''' ) ' + char(10)
			SELECT @v_dSql += N'  	AND E.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'  	WHERE A.ASSY_QTY > 0 ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
			SELECT @v_dSql += N'  	GROUP BY A.DIVISION_ID, A.SITE_ID, E.APPLIED_MODEL, A.ITEM_ID, E.ITEM_CLASS, ISNULL(E.NICK_NAME,''-''), E.ITEM_TYPE ' + char(10)
			SELECT @v_dSql += N'  			, A.PLANT_ID, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'  			, A.FACTORY_ID, A.MARKET, A.PRODUCTION_TYPE, A.EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql += N'  	UNION ALL ' + char(10)
			-- 3. COATER, COATER_BATCH : FACTORY, OPERATION, LINE, ELEC, MARKET, PRODUCTION TYPE
			SELECT @v_dSql += N'  	SELECT A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'        , A.ITEM_ID, ISNULL(E.NICK_NAME,''-'') AS NICK_NAME, E.ITEM_TYPE, ISNULL(E.APPLIED_MODEL, A.ITEM_ID) AS MODEL_T, E.ITEM_CLASS ' + char(10)
			SELECT @v_dSql += N'        , A.PLANT_ID, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ELEC_FACTORY_ID, ISNULL(E.APPLIED_MODEL,''-'') AS APPLIED_MODEL ' + char(10)
			SELECT @v_dSql += N'        , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MARKET, A.PRODUCTION_TYPE, A.EQUIPMENT_ID, A.LINE_NAME, A.PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'        , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_ORDER_LV1, B.MEASURE ' + char(10)
			SELECT @v_dSql += N'   		, ''DATA'' AS DATA_TYPE' + char(10)
			SELECT @v_dSql += N'  		, (CASE WHEN R.FACTORY_ID IS NOT NULL THEN ''Y'' ELSE ''N'' END) AS IS_ROLE ' + char(10)

			IF ISNULL(@p_bucket,'') <> '' BEGIN
				
				IF @max_loop_cnt > 0 BEGIN
					
					-- monthinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						
						SELECT @v_dSql += N'        , 0 AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END

					-- weekinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						
						SELECT @v_dSql += N'        , 0 AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END

					-- bucket
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						SET @tmp_column = ''
						SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_row_delimiter, @mst_loop_cnt)
						SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
						IF @sub_max_loop_cnt > 0 BEGIN	SET @sub_param_0 = [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END
						
						SELECT @v_dSql += N'  		, SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID = ''COATER_BATCH'' THEN ROUND(CONVERT(NUMERIC(20,5),A.BATCH_IN_QTY),3) ' + char(10)
						SELECT @v_dSql += N'  		                                                                  WHEN B.CATEGORY_ID = ''COATER''       THEN ROUND(CONVERT(NUMERIC(20,5),A.COATER_QTY),0) ELSE 0 END ) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
						
					END

				END --end of @max_loop_cnt
			END -- end of isnull(@p_bucket,'') <> ''

			SELECT @v_dSql += N'  	FROM MAIN_A A ' + char(10)
			SELECT @v_dSql += N'  	INNER JOIN ( ' + char(10)
			SELECT @v_dSql += N'      	SELECT * ' + char(10)
			SELECT @v_dSql += N'      	FROM ( ' + char(10)
			SELECT @v_dSql += N'          	SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER, 0 AS CATEGORY_ORDER_LV1, NULL AS MEASURE ' + char(10)
			SELECT @v_dSql += N'          	UNION ALL  ' + char(10)
			SELECT @v_dSql += N'          	SELECT ''COATER_BATCH'' AS CATEGORY_ID, ''Coater Plan'' AS CATEGORY_NAME, 25 AS CATEGORY_ORDER, 30 AS CATEGORY_ORDER_LV1, ''Batch'' AS MEASURE ' + char(10)
			SELECT @v_dSql += N'          	UNION ALL  ' + char(10)
			SELECT @v_dSql += N'          	SELECT ''COATER'' AS CATEGORY_ID, ''Coater Plan'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER, 30 AS CATEGORY_ORDER_LV1, ''UOM Type'' AS MEASURE ' + char(10)
			SELECT @v_dSql += N'      	) BB ' + char(10)
			SELECT @v_dSql += N'      	WHERE CATEGORY_ID <> ''X'' ' + char(10)
			SELECT @v_dSql += N'  	) B ' + char(10)
			SELECT @v_dSql += N'  	ON 1=1 ' + char(10)
			SELECT @v_dSql += N'  	INNER HASH JOIN SCM_ITEM_M E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'  	ON  A.DIVISION_ID = E.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'  	AND A.SITE_ID     = E.SITE_ID ' + char(10)
			SELECT @v_dSql += N'  	AND A.ITEM_ID     = E.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'  	AND E.COMPANY_ID  = (SELECT DISTINCT COMPANY_ID FROM FP_INSTANCE_OPERATION_V VV WITH(NOLOCK) WHERE INSTANCE_ID = ''' + @p_instance_id + ''') ' + char(10)
			SELECT @v_dSql += N'  	AND E.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'  	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'  			SELECT DISTINCT R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID, R.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql += N'  			FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'  			WHERE  R.USER_ID     = ''' + @p_user_id + ''' ' + char(10)
			SELECT @v_dSql += N'  			AND	   R.SAVE_FLAG   = ''Y'' ' + char(10)
			SELECT @v_dSql += N'  			AND	   R.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'  	) R ' + char(10)
			SELECT @v_dSql += N'  	ON	A.FACTORY_ID     = R.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'  	AND	A.OPERATION_ID   = R.OPERATION_ID ' + char(10)
			SELECT @v_dSql += N'  	AND	A.LINE_ID        = R.LINE_ID ' + char(10)
			SELECT @v_dSql += N'  	AND	A.ELECTRODE_TYPE = R.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql += N'  	WHERE A.FACTORY_ID LIKE ''E%'' ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
			SELECT @v_dSql += N'  	GROUP BY A.DIVISION_ID, A.SITE_ID, E.APPLIED_MODEL, A.ITEM_ID, E.ITEM_CLASS, ISNULL(E.NICK_NAME,''-''), E.ITEM_TYPE ' + char(10)
			SELECT @v_dSql += N'  			, A.PLANT_ID, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'  			, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MARKET, A.PRODUCTION_TYPE, A.EQUIPMENT_ID, A.LINE_NAME, A.PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'  			, B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.MEASURE, B.CATEGORY_ORDER_LV1, R.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'  	UNION ALL ' + char(10)
			-- POST, SHIP, SHIP_IN, INV
			SELECT @v_dSql += N'  	SELECT A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'        , A.ITEM_ID, ISNULL(E.NICK_NAME,''-'') AS NICK_NAME, E.ITEM_TYPE, ISNULL(E.APPLIED_MODEL, A.ITEM_ID) AS MODEL_T, E.ITEM_CLASS ' + char(10)
			SELECT @v_dSql += N'        , A.PLANT_ID, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ELEC_FACTORY_ID, NULL AS APPLIED_MODEL ' + char(10)
			SELECT @v_dSql += N'        , NULL AS FACTORY_ID, NULL AS OPERATION_ID, NULL AS LINE_ID, NULL AS ELECTRODE_TYPE, NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS EQUIPMENT_ID, NULL AS LINE_NAME, NULL AS PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'        , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_ORDER_LV1, B.MEASURE ' + char(10)
			SELECT @v_dSql += N'  		, ''DATA'' AS DATA_TYPE ' + char(10)
			SELECT @v_dSql += N'  		, ''N'' AS IS_ROLE ' + char(10)

			IF ISNULL(@p_bucket,'') <> '' BEGIN
				
				IF @max_loop_cnt > 0 BEGIN
					
					-- monthinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						
						SELECT @v_dSql += N'        , 0 AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END

					-- weekinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						
						SELECT @v_dSql += N'        , 0 AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END

					-- bucket
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						SET @tmp_column = ''
						SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_row_delimiter, @mst_loop_cnt)
						SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
						IF @sub_max_loop_cnt > 0 BEGIN	SET @sub_param_0 = [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END
						
						SELECT @v_dSql += N'  		, SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID = ''POST''    THEN ROUND(A.POST_QTY,0) ' + char(10)
						SELECT @v_dSql += N'  		                                                                  WHEN B.CATEGORY_ID = ''INV''     THEN 0 ELSE 0 END ) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)

						/*
						for(var i = 0; i < list.size(); i++) {
							sql+=", SUM(CASE WHEN A.PLAN_DATE = '" + list[i].VALUE + "' THEN (CASE WHEN B.CATEGORY_ID = 'POST'    THEN ROUND(A.POST_QTY,0)\r\n"
							sql+="                                                    WHEN B.CATEGORY_ID = 'INV'     THEN 0 ELSE 0 END ) ELSE 0 END) AS D" + i + "\r\n"
						}
						*/
						
					END

				END --end of @max_loop_cnt
			END -- end of isnull(@p_bucket,'') <> ''

			SELECT @v_dSql += N'  	FROM MAIN_A A ' + char(10)
			SELECT @v_dSql += N'  	INNER JOIN ( ' + char(10)
			SELECT @v_dSql += N'		SELECT * ' + char(10)
			SELECT @v_dSql += N'		FROM ( ' + char(10)
			SELECT @v_dSql += N'			SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER, 0 AS CATEGORY_ORDER_LV1, NULL AS MEASURE ' + char(10)
			SELECT @v_dSql += N'			UNION ALL  ' + char(10)
			SELECT @v_dSql += N'			SELECT ''POST'' AS CATEGORY_ID, ''Coater Plan + Post Yield'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER, 20 AS CATEGORY_ORDER_LV1, ''UOM Type'' AS MEASURE ' + char(10)
			SELECT @v_dSql += N'			UNION ALL  ' + char(10)
			SELECT @v_dSql += N'			SELECT ''INV'' AS CATEGORY_ID, ''Inventory'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER, 60 AS CATEGORY_ORDER_LV1, ''UOM Type'' AS MEASURE ' + char(10)
			SELECT @v_dSql += N'		) BB ' + char(10)
			SELECT @v_dSql += N'		WHERE CATEGORY_ID <> ''X'' ' + char(10)
			SELECT @v_dSql += N'  	) B ' + char(10)
			SELECT @v_dSql += N'  	ON 1=1 ' + char(10)
			SELECT @v_dSql += N'  	INNER HASH JOIN SCM_ITEM_M E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'  	ON  A.DIVISION_ID = E.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'  	AND A.SITE_ID     = E.SITE_ID ' + char(10)
			SELECT @v_dSql += N'  	AND A.ITEM_ID     = E.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'  	AND E.COMPANY_ID  = (SELECT DISTINCT COMPANY_ID FROM FP_INSTANCE_OPERATION_V VV WITH(NOLOCK) WHERE INSTANCE_ID = ''' + @p_instance_id + ''') ' + char(10)
			SELECT @v_dSql += N'  	AND E.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'  	WHERE 1=1 ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
			SELECT @v_dSql += N'  	GROUP BY A.DIVISION_ID, A.SITE_ID, E.APPLIED_MODEL, A.ITEM_ID, E.ITEM_CLASS, ISNULL(E.NICK_NAME,''-''), E.ITEM_TYPE ' + char(10)
			SELECT @v_dSql += N'  			, A.PLANT_ID, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'  			, B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_ORDER_LV1, B.MEASURE ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			--SELECT @v_dSql += N'INSERT INTO #TEMP_TABLE_02 ' + char(10)
			SELECT @v_dSql += N'SELECT * INTO #TEMP_TABLE_02 FROM MAIN A ' + char(10)
			--SELECT @v_dSql += N'OPTION (FORCE ORDER) ' + char(10)
			SELECT @v_dSql += N'; ' + char(10)

			--EXEC SP_EXECUTESQL @v_dSql;
			--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'insert 2',@runstart, @runend

		END

		-- 4. 최종 조회
		BEGIN
			
			--SET	@v_dSql = '' -- 이놈 주석막으면 SQL 에 내용 담김
			SELECT @v_dSql += N'------------------ final select ' + char(10)
			SELECT @v_dSql += N'WITH INSTANCE_T AS ( ' + char(10)
			SELECT @v_dSql += N'  		SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'  		FROM   SCM_FACTORY_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'  		INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'  		ON    A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'  		AND   B.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'  		WHERE A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'  		AND   B.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			SELECT @v_dSql += N', OPERATION_YIELD AS ( ' + char(10)
			SELECT @v_dSql += N'        SELECT COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , FACTORY_ID, ITEM_ID , MONTH ' + char(10)
			SELECT @v_dSql += N'            , (CASE WHEN A.Y3 IS NULL OR A.Y3 = 0 THEN 1 ELSE A.Y3 END) AS Y3 ' + char(10)
			SELECT @v_dSql += N'            , (CASE WHEN A.Y4 IS NULL OR A.Y4 = 0 THEN 1 ELSE A.Y4 END) AS Y4 ' + char(10)
			SELECT @v_dSql += N'        FROM ( ' + char(10)
			SELECT @v_dSql += N'      			SELECT COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , FACTORY_ID, ITEM_ID , MONTH ' + char(10)
			SELECT @v_dSql += N'      				 , MIN(CASE WHEN OPERATION_ID = ''E3000'' THEN YIELD ELSE 1 END) AS Y3 ' + char(10)
			SELECT @v_dSql += N'      				 , MIN(CASE WHEN OPERATION_ID = ''E4000'' THEN YIELD ELSE 1 END) AS Y4 ' + char(10)
			SELECT @v_dSql += N'      			FROM ( ' + char(10)
			SELECT @v_dSql += N'      						SELECT   A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID, A.ITEM_ID , A.MONTH , A.OPERATION_ID,  MIN(A.YIELD) AS YIELD ' + char(10)
			SELECT @v_dSql += N'      						FROM 	 SCM_YIELD_M A WITH(NOLOCK), INSTANCE_T B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'      						WHERE    A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'      						AND		 A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'      						AND		 A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'      						AND		 A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'      						AND 	 A.OPERATION_ID IN (''E3000'', ''E4000'') ' + char(10)
			SELECT @v_dSql += N'      						AND 	 A.MONTH BETWEEN CONVERT(VARCHAR(6),''' + @p_bucket_from + ''') AND CONVERT(VARCHAR(6),''' + @p_bucket_to + ''') ' + char(10)
			SELECT @v_dSql += N'      						GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID, A.ITEM_ID , A.MONTH , A.OPERATION_ID ' + char(10)
			SELECT @v_dSql += N'      			) A ' + char(10)
			SELECT @v_dSql += N'      			WHERE 1=1' + char(10)
			SELECT @v_dSql += N'      			GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MONTH ' + char(10)
			SELECT @v_dSql += N'        ) A ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			SELECT @v_dSql += N', STOCK_T AS ( ' + char(10)
			SELECT @v_dSql += N'    SELECT B.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'        	, (CASE WHEN C.JR_BEFORE = ''Y'' THEN 2000 WHEN C.JR_AFTER = ''Y'' THEN 3000 ELSE 9999 END) AS OPERATION_ID ' + char(10)
			SELECT @v_dSql += N'        	, A.WIPHOLD_YN, A.ITEM_ID, A.CUTOFF_DATE ' + char(10)
			SELECT @v_dSql += N'        	, (CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) THEN ISNULL(A.SSP_QTY,0) ELSE 0 END) AS BOH_QTY ' + char(10)
			SELECT @v_dSql += N'        	, (CASE WHEN WIPHOLD_YN = ''Y'' THEN ISNULL(A.SSP_QTY,0) ELSE 0 END) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'        	, A.STOCK_TYPE ' + char(10)
			SELECT @v_dSql += N'    FROM  IF_FP_SCM_STOCK_V A WITH(NOLOCK), ( ' + char(10)
			SELECT @v_dSql += N'		SELECT * FROM FP_INSTANCE_PANCAKE_V WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'		WHERE INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'		AND   GUBUN= ''BOM'' ' + char(10)
			SELECT @v_dSql += N'		AND   ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'    ) B ' + char(10)
			SELECT @v_dSql += N'    , (' + char(10)
			SELECT @v_dSql += N'        SELECT A.SEGMENT3 AS DIVISION_ID, A.SEGMENT2 AS SITE_ID, A.SEGMENT4 AS PLANT_ID, A.SEGMENT5 AS STOCK_POINT ' + char(10)
			SELECT @v_dSql += N'             , A.ATTRIBUTE1 AS STOCK_TYPE, A.ATTRIBUTE8 AS JR_BEFORE, A.ATTRIBUTE9 AS JR_AFTER, A.ATTRIBUTE10 AS PANCAKE ' + char(10)
			SELECT @v_dSql += N'        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'        WHERE  A.LOOKUP_TYPE_CODE = ''SIMULATION_BOH'' ' + char(10)
			SELECT @v_dSql += N'        AND    A.SEGMENT1 = ''PANCAKE_SIMUL_BY_BLD'' ' + char(10)
			SELECT @v_dSql += N'        AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'    ) C ' + char(10)
			SELECT @v_dSql += N'    WHERE A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'    AND   A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'    AND   A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    AND   A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'    AND   A.DIVISION_ID = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'    AND   A.SITE_ID     = C.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    AND   A.PLANT_ID    = C.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'    AND   A.STOCK_TYPE  = C.STOCK_TYPE' + char(10)
			-- erp 재고 : STORAGE_ID, mes 재고 : FP_APPLY_OPERATION_ID
			SELECT @v_dSql += N'    AND   (CASE WHEN A.STOCK_TYPE = ''INVENTORY'' THEN A.STORAGE_ID WHEN A.STOCK_TYPE = ''WIP'' THEN A.FP_APPLY_OPERATION_ID ELSE NULL END) = C.STOCK_POINT ' + char(10)
			SELECT @v_dSql += N'    AND   A.CUTOFF_DATE BETWEEN CONVERT(DATE,''' + @p_bucket_from + ''')  AND CONVERT(DATE,''' + @p_plan_date + ''' ) ' + char(10)
			SELECT @v_dSql += N'    AND   A.ITEM_ID LIKE ''APC%'' ' + char(10)
			SELECT @v_dSql += N'    AND   A.SSP_QTY > 0 ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			SELECT @v_dSql += N', MAIN AS ( ' + char(10)
			SELECT @v_dSql += N'    SELECT * FROM #TEMP_TABLE_02 ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			SELECT @v_dSql += N', MAIN_T AS ( ' + char(10)
			SELECT @v_dSql += N'    SELECT A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'        , A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE, A.MODEL, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ITEM_CLASS ' + char(10)
			SELECT @v_dSql += N'        , A.ELEC_FACTORY_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MARKET, A.PRODUCTION_TYPE, A.EQUIPMENT_ID, A.APPLIED_MODEL, A.LINE_NAME, A.PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'        , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.CATEGORY_ORDER_LV1, A.MEASURE ' + char(10)
			
			IF @p_uom_type = 'PANCAKE' BEGIN
				
				SELECT @v_dSql += N'     , 0 AS PREV_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING( A.POST_BOH_QTY ) / ' + @p_unit + ' AS POST_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING( A.BOH_QTY ) / ' + @p_unit + ' AS BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING( A.PC_BOH_QTY ) / ' + @p_unit + ' AS PC_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING( A.JR_BOH_QTY ) / ' + @p_unit + ' AS JR_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING( A.JR_AFTER_BOH_QTY ) / ' + @p_unit + ' AS JR_AFTER_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , 0 AS ERP_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING( ISNULL(H.BOH_QTY,0) ) / ' + @p_unit + ' AS ERP_BOH_QTY2 ' + char(10)
				SELECT @v_dSql += N'     , CEILING( A.HOLD_QTY ) / ' + @p_unit + ' AS HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING( A.PC_HOLD_QTY ) / ' + @p_unit + ' AS PC_HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING( A.JR_HOLD_QTY ) / ' + @p_unit + ' AS JR_HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING( A.JR_AFTER_HOLD_QTY ) / ' + @p_unit + ' AS JR_AFTER_HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , 0 AS ERP_HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING( ISNULL(H.HOLD_QTY,0) ) / ' + @p_unit + ' AS ERP_HOLD_QTY2 ' + char(10)

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

							SELECT @v_dSql += N'	            , CASE WHEN A.CATEGORY_ID IN (''COATER_BATCH'',''INV'') THEN ROUND(CONVERT(NUMERIC(20,5),D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '), ' + @p_round_point + ') ELSE CEILING(CONVERT(NUMERIC(20,5),D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ')) END / ' + @p_unit + ' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
							
						END		-- end of @mst_loop_cnt < @max_loop_cnt

					END		--end of @max_loop_cnt

				END		-- end of isnull(@p_bucket,'') <> ''

			END -- end of @p_uom_type = 'PANCAKE'
			
			ELSE IF @p_uom_type = 'JUMBO_ROLL' BEGIN
				
				SELECT @v_dSql += N'     , 0 AS PREV_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING(A.POST_BOH_QTY/ (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END) / ' + @p_unit + ') AS POST_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING(A.BOH_QTY/ (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END) / ' + @p_unit + ') AS BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING(A.PC_BOH_QTY/ (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END) / ' + @p_unit + ') AS PC_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING(A.JR_BOH_QTY/ (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END) / ' + @p_unit + ') AS JR_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING(A.JR_AFTER_BOH_QTY/ (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END) / ' + @p_unit + ') AS JR_AFTER_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , 0 AS ERP_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING(ISNULL(H.BOH_QTY,0)/ (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END) / ' + @p_unit + ') AS ERP_BOH_QTY2 ' + char(10)
				SELECT @v_dSql += N'     , CEILING(A.HOLD_QTY/ (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END) / ' + @p_unit + ') AS HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING(A.PC_HOLD_QTY/ (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END) / ' + @p_unit + ') AS PC_HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING(A.JR_HOLD_QTY/ (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END) / ' + @p_unit + ') AS JR_HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING(A.JR_AFTER_HOLD_QTY/ (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END) / ' + @p_unit + ') AS JR_AFTER_HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , 0 AS ERP_HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , CEILING(ISNULL(H.HOLD_QTY,0)/ (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END) / ' + @p_unit + ') AS ERP_HOLD_QTY2 ' + char(10)

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

							SELECT @v_dSql += N'	            , (CASE WHEN A.CATEGORY_ID IN (''COATER_BATCH'',''INV'') THEN ROUND(CONVERT(NUMERIC(20,5),D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '), ' + @p_round_point + ' ) ' + char(10)
							SELECT @v_dSql += N'	                    WHEN A.CATEGORY_ID IN (''COATER'',''POST'') THEN CEILING(CONVERT(NUMERIC(20,5),D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ')) ' + char(10)
							SELECT @v_dSql += N'	                    ELSE CEILING(CONVERT(NUMERIC(20,5),D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ') / CONVERT(FLOAT, CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1.0 ELSE G.LANE_QTY END)) END) / ' + @p_unit + ' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)

						END		-- end of @mst_loop_cnt < @max_loop_cnt

					END		--end of @max_loop_cnt

				END		-- end of isnull(@p_bucket,'') <> ''

			END -- end of @p_uom_type = 'JUMBO_ROLL'

			-- CELL
			ELSE BEGIN

				SELECT @v_dSql += N'     , 0 AS PREV_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , ISNULL( CEILING( A.POST_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ), CEILING( A.POST_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ) ) / ' + @p_unit + ' AS POST_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , ISNULL( CEILING( A.BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ), CEILING( A.BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ) ) / ' + @p_unit + ' AS BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , ISNULL( CEILING( A.PC_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ), CEILING( A.PC_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ) ) / ' + @p_unit + ' AS PC_BOH_QTY' + char(10)
				SELECT @v_dSql += N'     , ISNULL( CEILING( A.JR_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ), CEILING( A.JR_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ) ) / ' + @p_unit + ' AS JR_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , ISNULL( CEILING( A.JR_AFTER_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ), CEILING( A.JR_AFTER_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ) ) / ' + @p_unit + ' AS JR_AFTER_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , 0 AS ERP_BOH_QTY ' + char(10)
				SELECT @v_dSql += N'     , ISNULL( CEILING( ISNULL(H.BOH_QTY,0) / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ), CEILING( ISNULL(H.BOH_QTY,0) / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ) ) / ' + @p_unit + ' AS ERP_BOH_QTY2 ' + char(10)
				SELECT @v_dSql += N'     , ISNULL( CEILING( A.HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ), CEILING( A.HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ) ) / ' + @p_unit + ' AS HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , ISNULL( CEILING( A.PC_HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ), CEILING( A.PC_HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ) ) / ' + @p_unit + ' AS PC_HOLD_QTY' + char(10)
				SELECT @v_dSql += N'     , ISNULL( CEILING( A.JR_HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ), CEILING( A.JR_HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ) ) / ' + @p_unit + ' AS JR_HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , ISNULL( CEILING( A.JR_AFTER_HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ), CEILING( A.JR_HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ) ) / ' + @p_unit + ' AS JR_AFTER_HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , 0 AS ERP_HOLD_QTY ' + char(10)
				SELECT @v_dSql += N'     , ISNULL( CEILING( ISNULL(H.HOLD_QTY,0) / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ), CEILING( ISNULL(H.HOLD_QTY,0) / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ''' + @p_plan_date + ''' ) ) ) / ' + @p_unit + ' AS ERP_HOLD_QTY2 ' + char(10)

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

							SELECT @v_dSql += N'	            , (CASE WHEN A.CATEGORY_ID IN (''COATER_BATCH'',''INV'') THEN ROUND(CONVERT(NUMERIC(20,5),D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '), ' + @p_round_point + ') ' + char(10)
							SELECT @v_dSql += N'	                    ELSE CEILING(CONVERT(NUMERIC(20,5),D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ')) END) / ' + @p_unit + ' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)

						END		-- end of @mst_loop_cnt < @max_loop_cnt

					END		--end of @max_loop_cnt

				END		-- end of isnull(@p_bucket,'') <> ''

			END -- end ELSE

			SELECT @v_dSql += N'        , A.DATA_TYPE, A.IS_ROLE ' + char(10)
			SELECT @v_dSql += N'        , B.LEVEL_3_NAME AS MODEL_LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql += N'        , (CASE WHEN D.LEVEL_4_NAME = ''-'' THEN D.LEVEL_2_NAME ELSE D.LEVEL_4_NAME END) AS MODEL_CLASS_NAME ' + char(10)
			SELECT @v_dSql += N'        , ISNULL(C.NICK_NAME,''-'') AS MODEL_NICK_NAME ' + char(10)
			SELECT @v_dSql += N'        , C.ITEM_CLASS AS MODEL_CLASS ' + char(10)
			SELECT @v_dSql += N'        , ISNULL(A.LT,1) AS LT ' + char(10)
			SELECT @v_dSql += N'    FROM   ( ' + char(10)
			SELECT @v_dSql += N'			SELECT A.* ' + char(10)
			SELECT @v_dSql += N'				, ISNULL(A.TOP_ITEM_ID, A.MODEL_T) AS MODEL ' + char(10)
			SELECT @v_dSql += N'				, ISNULL(D.BOH_QTY,0) AS BOH_QTY, ISNULL(D.PREV_BOH_QTY,0) AS PREV_BOH_QTY, ISNULL(D.PC_BOH_QTY,0) AS PC_BOH_QTY, ISNULL(D.JR_BOH_QTY,0) AS JR_BOH_QTY, ISNULL(D.JR_AFTER_BOH_QTY,0) AS JR_AFTER_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'				, ISNULL(D.HOLD_QTY,0) AS HOLD_QTY, ISNULL(D.PC_HOLD_QTY,0) AS PC_HOLD_QTY, ISNULL(D.JR_HOLD_QTY,0) AS JR_HOLD_QTY, ISNULL(D.JR_AFTER_HOLD_QTY,0) AS JR_AFTER_HOLD_QTY, ISNULL(D.POST_BOH_QTY,0) AS POST_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'				, CASE WHEN CEILING( ( ISNULL(F.LT,0) + ISNULL( ISNULL(G.LT, E.LT) , 0 ) ) / 1440 ) < 1 THEN 1 ELSE CEILING( ( ISNULL(F.LT,0) + ISNULL( ISNULL(G.LT, E.LT) , 0 ) ) / 1440 ) END AS LT ' + char(10)
			SELECT @v_dSql += N'			FROM   MAIN A ' + char(10)
			SELECT @v_dSql += N'			LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql += N'						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ISNULL(B.ELEC_FACTORY_ID, A.FACTORY_ID) AS FACTORY_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'							 , 0 AS PREV_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'							 , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,''' + @p_plan_date + ''') THEN BOH_QTY ELSE 0 END) AS BOH_QTY ' + char(10)
			SELECT @v_dSql += N'							 , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,''' + @p_plan_date + ''') THEN POST_BOH_QTY ELSE 0 END) AS POST_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'							 , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,''' + @p_plan_date + ''') THEN PC_BOH_QTY ELSE 0 END) AS PC_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'							 , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,''' + @p_plan_date + ''') THEN JR_BOH_QTY ELSE 0 END) AS JR_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'							 , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,''' + @p_plan_date + ''') THEN JR_AFTER_BOH_QTY ELSE 0 END) AS JR_AFTER_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'							 , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,''' + @p_plan_date + ''') THEN HOLD_QTY ELSE 0 END) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'							 , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,''' + @p_plan_date + ''') THEN JR_HOLD_QTY ELSE 0 END) AS JR_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'							 , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,''' + @p_plan_date + ''') THEN JR_AFTER_HOLD_QTY ELSE 0 END) AS JR_AFTER_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'							 , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,''' + @p_plan_date + ''') THEN PC_HOLD_QTY ELSE 0 END) AS PC_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'						FROM ( ' + char(10)
			SELECT @v_dSql += N'									SELECT A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'										    , CONVERT(VARCHAR,A.CUTOFF_DATE,112) AS CUTOFF_DATE , A.OPERATION_ID ' + char(10)
			SELECT @v_dSql += N'										    , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY ' + char(10)
			SELECT @v_dSql += N'											, CASE WHEN A.OPERATION_ID = 2000 THEN  ISNULL(SUM(A.BOH_QTY),0) * ISNULL(C.Y3,1) * ISNULL(C.Y4,1) ' + char(10)
			SELECT @v_dSql += N'												   WHEN A.OPERATION_ID = 3000 THEN  ISNULL(SUM(A.BOH_QTY),0) * ISNULL(C.Y4,1) ' + char(10)
			SELECT @v_dSql += N'												   ELSE ISNULL(SUM(A.BOH_QTY),0) END POST_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'											, CASE WHEN A.OPERATION_ID < 3000 THEN  ISNULL(SUM(A.BOH_QTY),0) ELSE 0 END AS JR_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'											, CASE WHEN A.OPERATION_ID = 3000 THEN  ISNULL(SUM(A.BOH_QTY),0) ELSE 0 END AS JR_AFTER_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'											, CASE WHEN A.OPERATION_ID > 3000 THEN  ISNULL(SUM(A.BOH_QTY),0) ELSE 0 END AS PC_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'											, CASE WHEN A.WIPHOLD_YN = ''Y'' THEN  ISNULL(SUM(A.HOLD_QTY),0) ELSE 0 END AS HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'											, CASE WHEN A.WIPHOLD_YN = ''Y'' AND A.OPERATION_ID < 3000 THEN  ISNULL(SUM(A.HOLD_QTY),0) ELSE 0 END AS JR_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'											, CASE WHEN A.WIPHOLD_YN = ''Y'' AND A.OPERATION_ID = 3000 THEN  ISNULL(SUM(A.HOLD_QTY),0) ELSE 0 END AS JR_AFTER_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'											, CASE WHEN A.WIPHOLD_YN = ''Y'' AND A.OPERATION_ID > 3000 THEN  ISNULL(SUM(A.HOLD_QTY),0) ELSE 0 END AS PC_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'									FROM 	STOCK_T A ' + char(10)
			SELECT @v_dSql += N'									LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql += N'											SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, MONTH, MIN(Y3) AS Y3, MIN(Y4) AS Y4 ' + char(10)
			SELECT @v_dSql += N'											FROM   OPERATION_YIELD ' + char(10)
			SELECT @v_dSql += N'											GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, MONTH ' + char(10)
			SELECT @v_dSql += N'									) C ' + char(10)
			SELECT @v_dSql += N'									ON  A.COMPANY_ID  = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'									AND A.DIVISION_ID = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'									AND A.SITE_ID     = C.SITE_ID ' + char(10)
			SELECT @v_dSql += N'									AND A.PLANT_ID    = C.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'									AND	A.ITEM_ID     = C.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'									AND CONVERT(VARCHAR(6), A.CUTOFF_DATE, 112) = C.MONTH ' + char(10)
			SELECT @v_dSql += N'									WHERE A.CUTOFF_DATE = CONVERT(DATE,''' + @p_plan_date + ''') ' + char(10)
			SELECT @v_dSql += N'									AND   A.STOCK_TYPE  = ''WIP'' ' + char(10)
			SELECT @v_dSql += N'									GROUP BY A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, CONVERT(VARCHAR,A.CUTOFF_DATE,112), A.OPERATION_ID, A.WIPHOLD_YN, C.Y3, C.Y4 ' + char(10)
			SELECT @v_dSql += N'						) A ' + char(10)
			SELECT @v_dSql += N'						LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'  								SELECT A.SEGMENT1 AS ASSY_FACTORY_ID, MAX(A.SEGMENT2) AS ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'  								FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'  								WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_FACTORY_MAP'' ' + char(10)
			SELECT @v_dSql += N'  								AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'  								GROUP BY A.SEGMENT1 ' + char(10)
			SELECT @v_dSql += N'						) B ' + char(10)
			SELECT @v_dSql += N'						ON  A.FACTORY_ID = B.ASSY_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'						WHERE 1=1 ' + char(10)
			SELECT @v_dSql += N'						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ISNULL(B.ELEC_FACTORY_ID, A.FACTORY_ID), A.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'			) D ' + char(10)
			SELECT @v_dSql += N'			ON    A.DIVISION_ID     = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'			AND   A.SITE_ID         = D.SITE_ID ' + char(10)
			SELECT @v_dSql += N'			AND   A.ELEC_FACTORY_ID = D.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'			AND   A.ITEM_ID         = D.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'			LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql += N'						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, MAX(A.TRANSPORT_TIME) AS LT ' + char(10)
			SELECT @v_dSql += N'						FROM   SCM_BOD_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'						WHERE  A.FROM_OPERATION_ID = ''E4000'' ' + char(10)
			SELECT @v_dSql += N'						AND	   A.TO_OPERATION_ID   = ''A5000'' ' + char(10)
			SELECT @v_dSql += N'						AND    EXISTS ( ' + char(10)
			SELECT @v_dSql += N'							SELECT 1 ' + char(10)
			SELECT @v_dSql += N'							FROM   INSTANCE_T B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'							WHERE  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'							AND    A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'							AND    A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'						) ' + char(10)
			SELECT @v_dSql += N'						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'			) F ' + char(10)
			SELECT @v_dSql += N'			ON	A.DIVISION_ID = F.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'			AND A.SITE_ID     = F.SITE_ID ' + char(10)
			SELECT @v_dSql += N'			LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql += N'						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'							 , MAX( CASE WHEN A.OPERATION_LEAD_TIME_UOM = ''DAY'' THEN ISNULL(OPERATION_LEAD_TIME,0) * 24 * 60 ' + char(10)
			SELECT @v_dSql += N'										 WHEN A.OPERATION_LEAD_TIME_UOM = ''HOUR'' THEN ISNULL(OPERATION_LEAD_TIME,0) * 60 ' + char(10)
			SELECT @v_dSql += N'										 ELSE ISNULL(OPERATION_LEAD_TIME,0) END ) AS LT ' + char(10)
			SELECT @v_dSql += N'						FROM   SCM_OPERATION_MOVE_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'						WHERE  A.OPERATION_ID IN (''E2000'', ''E3000'') ' + char(10)
			SELECT @v_dSql += N'						AND	   A.OPERATION_LEAD_TIME IS NOT NULL ' + char(10)
			SELECT @v_dSql += N'						AND    EXISTS ( ' + char(10)
			SELECT @v_dSql += N'							SELECT 1 ' + char(10)
			SELECT @v_dSql += N'							FROM   INSTANCE_T B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'							WHERE  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'							AND    A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'							AND    A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'						) ' + char(10)
			SELECT @v_dSql += N'						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'			) E ' + char(10)
			SELECT @v_dSql += N'			ON	A.DIVISION_ID = E.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'			AND A.SITE_ID     = E.SITE_ID ' + char(10)
			SELECT @v_dSql += N'			LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql += N'						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'						 	 , MAX( CASE WHEN A.OPERATION_LEAD_TIME_UOM = ''DAY'' THEN ISNULL(OPERATION_LEAD_TIME,0) * 24 * 60 ' + char(10)
			SELECT @v_dSql += N'										 WHEN A.OPERATION_LEAD_TIME_UOM = ''HOUR'' THEN ISNULL(OPERATION_LEAD_TIME,0) * 60 ' + char(10)
			SELECT @v_dSql += N'										 ELSE ISNULL(OPERATION_LEAD_TIME,0) END ) AS LT ' + char(10)
			SELECT @v_dSql += N'						FROM   SCM_ITEM_FLOW_EXCEPT_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'						WHERE  A.OPERATION_LEAD_TIME IS NOT NULL ' + char(10)
			SELECT @v_dSql += N'						AND    A.OPERATION_ID IN (''E2000'', ''E3000'') ' + char(10)
			SELECT @v_dSql += N'						AND    EXISTS ( ' + char(10)
			SELECT @v_dSql += N'							SELECT 1 ' + char(10)
			SELECT @v_dSql += N'							FROM   INSTANCE_T B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'							WHERE  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'							AND    A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'							AND    A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'						) ' + char(10)
			SELECT @v_dSql += N'						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID  ' + char(10)
			SELECT @v_dSql += N'			) G ' + char(10)
			SELECT @v_dSql += N'			ON	A.DIVISION_ID = G.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'			AND A.SITE_ID     = G.SITE_ID ' + char(10)
			SELECT @v_dSql += N'			AND A.ITEM_ID     = G.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'			WHERE 1=1 ' + char(10)
			SELECT @v_dSql += N'    ) A ' + char(10)
			SELECT @v_dSql += N'    LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql += N'			SELECT * ' + char(10)
			SELECT @v_dSql += N'			FROM   FP_INSTANCE_PANCAKE_V WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'			WHERE  INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'			AND    GUBUN       = ''ASSY'' ' + char(10)
			SELECT @v_dSql += N'			AND    ACTIVE_FLAG = ''Y''  ' + char(10)
			SELECT @v_dSql += N'    ) F ' + char(10)
			SELECT @v_dSql += N'    ON  A.DIVISION_ID = F.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'    AND A.SITE_ID 	  = F.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql += N'			SELECT A.FACTORY_ID, A.ITEM_ID, MAX(LANE_QTY) AS LANE_QTY ' + char(10)
			SELECT @v_dSql += N'			FROM   SCM_ITEM_LANE_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'			WHERE  A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'			GROUP BY A.FACTORY_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'    ) G ' + char(10)
			SELECT @v_dSql += N'    ON  A.ELEC_FACTORY_ID = G.FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'    AND A.ITEM_ID         = G.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'    LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'			SELECT A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, SUM(BOH_QTY) AS BOH_QTY, SUM(HOLD_QTY) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      		FROM   STOCK_T A ' + char(10)
			SELECT @v_dSql += N'      		WHERE  A.STOCK_TYPE = ''INVENTORY'' ' + char(10)
			SELECT @v_dSql += N'      		GROUP BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'    ) H ' + char(10)
			SELECT @v_dSql += N'    ON  1=1 ' + char(10)
			SELECT @v_dSql += N'    AND A.DIVISION_ID = H.DIVISION_ID' + char(10)
			SELECT @v_dSql += N'    AND A.SITE_ID     = H.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    AND A.ITEM_ID     = H.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'    , SCM_ITEM_CLASS_M B WITH(NOLOCK), ' + char(10)
			SELECT @v_dSql += N'    ( ' + char(10)
			SELECT @v_dSql += N'    		SELECT DISTINCT A.SITE_ID, A.ITEM_ID, A.ITEM_CLASS, A.NICK_NAME  ' + char(10)
			SELECT @v_dSql += N'    		FROM   SCM_ITEM_M A WITH(NOLOCK), INSTANCE_T B ' + char(10)
			SELECT @v_dSql += N'    		WHERE  A.SITE_ID = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    ) C , ' + char(10)
			SELECT @v_dSql += N'    SCM_ITEM_CLASS_M D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'    WHERE  A.ITEM_CLASS  = B.CLASS_ID ' + char(10)
			SELECT @v_dSql += N'    AND    A.MODEL       = C.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'    AND    A.SITE_ID     = C.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    AND    C.ITEM_CLASS  = D.CLASS_ID ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL' , 'LIKE', @p_model_id)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(C.NICK_NAME,''-'')' , 'LIKE', @p_model_nick_name)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(C.NICK_NAME,''-'')' , 'EQ', @p_model_nick_name_top)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('(CASE WHEN D.LEVEL_4_NAME = ''-'' THEN D.LEVEL_2_NAME ELSE D.LEVEL_4_NAME END)' , 'EQ', @p_cell_type)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.LEVEL_3_NAME' , 'EQ', @p_pancake_type)) + char(10)
			SELECT @v_dSql += N') ' + char(10)
			SELECT @v_dSql += N', INS_PLANT AS ( ' + char(10)
			--= P/C ITEM을 입고받는 조립 PLANT ID 리스트 =--
			SELECT @v_dSql += N'    SELECT  A.INSTANCE_ID, A.DIVISION_ID, A.COMPANY_ID, A.SITE_ID, A.PLANT_ID, B.PLANT_ID AS ASSY_PLANT_ID, B.DIVISION_ID AS ASSY_DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'    FROM ( ' + char(10)
			SELECT @v_dSql += N'      		SELECT DISTINCT INSTANCE_ID ,COMPANY_ID ,DIVISION_ID ,SITE_ID ,PLANT_ID  ' + char(10)
			SELECT @v_dSql += N'      		FROM   FP_INSTANCE_INFO_V A ' + char(10)
			SELECT @v_dSql += N'      		WHERE  INSTANCE_TYPE = ''E'' ' + char(10)
			SELECT @v_dSql += N'    ) A  ' + char(10)
			SELECT @v_dSql += N'    INNER JOIN ( ' + char(10)
			SELECT @v_dSql += N'      		SELECT DISTINCT COMPANY_ID ,SITE_ID ,PLANT_ID , DIVISION_ID  ' + char(10)
			SELECT @v_dSql += N'      		FROM   FP_INSTANCE_INFO_V A ' + char(10)
			SELECT @v_dSql += N'      		WHERE  INSTANCE_TYPE = ''A'' ' + char(10)
			SELECT @v_dSql += N'    ) B ' + char(10)
			SELECT @v_dSql += N'    ON    A.COMPANY_ID  =  B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'    AND   A.SITE_ID     =  B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    WHERE A.INSTANCE_ID =  ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N') ' + char(10)
			SELECT @v_dSql += N'SELECT A.* ' + char(10)
			SELECT @v_dSql += N'        , DENSE_RANK() OVER( ORDER BY A.DIVISION_ID, A.SITE_ID, A.MODEL, A.ITEM_ID ) AS MODEL_ITEM_RANK ' + char(10)
			SELECT @v_dSql += N'FROM ( ' + char(10)
			SELECT @v_dSql += N'    SELECT * ' + char(10)
			SELECT @v_dSql += N'            , DENSE_RANK() OVER(ORDER BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID,A.ELEC_FACTORY_ID) AS ITEM_RANK ' + char(10)
			SELECT @v_dSql += N'            , (CASE WHEN A.CATEGORY_ID = ''INV'' THEN ''#F5FFE1'' WHEN A.CATEGORY_ID = ''COATER_BATCH'' AND A.IS_ROLE = ''Y'' THEN ''#FFFF0055'' ELSE ''#FFFFFFFF'' END) AS D0_BACK ' + char(10)
			SELECT @v_dSql += N'    FROM   MAIN_T A ' + char(10)
			SELECT @v_dSql += N'    UNION ALL ' + char(10)
			-- Sub Total : Assy Plan(Notching)
			SELECT @v_dSql += N'	SELECT A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'        , A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE ' + char(10)
			SELECT @v_dSql += N'        , A.MODEL, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ITEM_CLASS ' + char(10)
			SELECT @v_dSql += N'        , NULL AS ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'        , NULL AS FACTORY_ID, A.OPERATION_ID, NULL AS LINE_ID, NULL AS ELECTRODE_TYPE, NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS EQUIPMENT_ID, NULL AS APPLIED_MODEL, NULL AS LINE_NAME, NULL AS PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'        , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.CATEGORY_ORDER_LV1, A.MEASURE ' + char(10)
			SELECT @v_dSql += N'        , 0 AS PREV_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.POST_BOH_QTY ) + MAX( B.ERP_BOH_QTY ) AS POST_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.BOH_QTY ) + MAX( B.ERP_BOH_QTY ) AS BOH_QTY ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.PC_BOH_QTY ) AS PC_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.JR_BOH_QTY ) AS JR_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.JR_AFTER_BOH_QTY ) AS JR_AFTER_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.ERP_BOH_QTY ) AS ERP_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.ERP_BOH_QTY ) AS ERP_BOH_QTY2 ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.HOLD_QTY ) + MAX( B.ERP_HOLD_QTY ) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.PC_HOLD_QTY ) AS PC_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.JR_HOLD_QTY ) AS JR_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.JR_AFTER_HOLD_QTY ) AS JR_AFTER_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.ERP_HOLD_QTY ) AS ERP_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'        , MAX( B.ERP_HOLD_QTY ) AS ERP_HOLD_QTY2 ' + char(10)

			IF ISNULL(@p_bucket,'') <> '' BEGIN
				IF @max_loop_cnt > 0 BEGIN
				
					-- monthinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						SELECT @v_dSql += '    			 , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END-- end of @mst_loop_cnt < @max_loop_cnt

					-- weekinfo
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						SELECT @v_dSql += '    			 , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
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

						SELECT @v_dSql += N'    			 , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)

					END		-- end of @mst_loop_cnt < @max_loop_cnt

				END		--end of @max_loop_cnt

			END		-- end of isnull(@p_bucket,'') <> ''

			SELECT @v_dSql += N'        , ''TOTAL'' AS DATA_TYPE ' + char(10)
			SELECT @v_dSql += N'        , ''N'' AS IS_ROLE ' + char(10)
			SELECT @v_dSql += N'        , A.MODEL_LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql += N'        , NULL AS MODEL_CLASS_NAME ' + char(10)
			SELECT @v_dSql += N'        , NULL AS MODEL_NICK_NAME ' + char(10)
			SELECT @v_dSql += N'        , NULL AS MODEL_CLASS ' + char(10)
			SELECT @v_dSql += N'        , A.LT ' + char(10)
			SELECT @v_dSql += N'        , 9999 AS ITEM_RANK' + char(10)
			SELECT @v_dSql += N'        , ''#FFE5C2'' AS D0_BACK ' + char(10)
			SELECT @v_dSql += N'    FROM MAIN_T A ' + char(10)
			SELECT @v_dSql += N'    LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'        SELECT A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.MODEL ' + char(10)
			SELECT @v_dSql += N'			, SUM( A.POST_BOH_QTY ) / 1 AS POST_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'			, SUM( A.BOH_QTY ) / 1 AS BOH_QTY ' + char(10)
			SELECT @v_dSql += N'			, SUM( A.PC_BOH_QTY ) / 1 AS PC_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'			, SUM( A.JR_BOH_QTY ) / 1 AS JR_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'			, SUM( A.JR_AFTER_BOH_QTY ) / 1 AS JR_AFTER_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'			, MAX( A.ERP_BOH_QTY2 ) / 1 AS ERP_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'			, SUM( A.HOLD_QTY ) / 1 AS HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'			, SUM( A.PC_HOLD_QTY ) / 1 AS PC_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'			, SUM( A.JR_HOLD_QTY ) / 1 AS JR_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'			, SUM( A.JR_AFTER_HOLD_QTY ) / 1 AS JR_AFTER_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'			, MAX( A.ERP_HOLD_QTY2 ) / 1 AS ERP_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'        FROM   MAIN_T A ' + char(10)
			SELECT @v_dSql += N'        WHERE  A.CATEGORY_ID = ''INV'' ' + char(10)
			SELECT @v_dSql += N'        GROUP BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.MODEL ' + char(10)
			SELECT @v_dSql += N'    ) B ' + char(10)
			SELECT @v_dSql += N'    ON  1=1 ' + char(10)
			SELECT @v_dSql += N'    AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'    AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    AND A.ITEM_ID     = B.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'    AND A.MODEL       = B.MODEL ' + char(10)
			SELECT @v_dSql += N'    ' + @sub_total + char(10) -- WHERE 1=1 or 1=0
			SELECT @v_dSql += N'    AND	  CATEGORY_ID IN (''ASSY'') ' + char(10)
			SELECT @v_dSql += N'    GROUP BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE, A.MODEL, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ITEM_CLASS, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql += N'      			, A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.CATEGORY_ORDER_LV1, A.MEASURE, A.MODEL_LEVEL_3_NAME, A.LT ' + char(10)
			-- Sub Total : Coater Plan + Post Yield, Inventory
			SELECT @v_dSql += N'    UNION ALL ' + char(10)
			SELECT @v_dSql += N'    SELECT A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'      		, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE ' + char(10)
			SELECT @v_dSql += N'      		, A.MODEL, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ITEM_CLASS, NULL AS ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'      		, NULL AS FACTORY_ID, A.OPERATION_ID, NULL AS LINE_ID, NULL AS ELECTRODE_TYPE, NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS EQUIPMENT_ID, NULL AS APPLIED_MODEL, NULL AS LINE_NAME, NULL AS PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'      		, A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.CATEGORY_ORDER_LV1, A.MEASURE ' + char(10)
			SELECT @v_dSql += N'      		, 0 AS PREV_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, SUM( A.POST_BOH_QTY ) / 1 + MAX( A.ERP_BOH_QTY2 ) AS POST_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, SUM( A.BOH_QTY ) + MAX( A.ERP_BOH_QTY2 ) AS BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, SUM( A.PC_BOH_QTY ) / 1 AS PC_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, SUM( A.JR_BOH_QTY ) / 1 AS JR_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, SUM( A.JR_AFTER_BOH_QTY ) / 1 AS JR_AFTER_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.ERP_BOH_QTY2 ) AS ERP_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.ERP_BOH_QTY2 ) AS ERP_BOH_QTY2 ' + char(10)
			SELECT @v_dSql += N'      		, SUM( A.HOLD_QTY ) + MAX( A.ERP_HOLD_QTY2 ) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      		, SUM( A.PC_HOLD_QTY ) / 1 AS PC_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      		, SUM( A.JR_HOLD_QTY ) / 1 AS JR_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      		, SUM( A.JR_AFTER_HOLD_QTY ) / 1 AS JR_AFTER_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.ERP_HOLD_QTY2 ) AS ERP_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.ERP_HOLD_QTY2 ) AS ERP_HOLD_QTY2 ' + char(10)
			
			IF ISNULL(@p_bucket,'') <> '' BEGIN
				IF @max_loop_cnt > 0 BEGIN
					
					-- monthinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						SELECT @v_dSql += '    			 , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END-- end of @mst_loop_cnt < @max_loop_cnt

					-- weekinfo
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						SELECT @v_dSql += '    			 , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
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

						SELECT @v_dSql += N'    			 , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ') / ' + @p_unit + ' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)

					END		-- end of @mst_loop_cnt < @max_loop_cnt

				END		--end of @max_loop_cnt

			END		-- end of isnull(@p_bucket,'') <> ''
			
			SELECT @v_dSql += N'      		, ''TOTAL'' AS DATA_TYPE ' + char(10)
			SELECT @v_dSql += N'      		, ''N'' AS IS_ROLE ' + char(10)
			SELECT @v_dSql += N'      		, A.MODEL_LEVEL_3_NAME AS MODEL_LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql += N'      		, NULL AS MODEL_CLASS_NAME ' + char(10)
			SELECT @v_dSql += N'      		, NULL AS MODEL_NICK_NAME ' + char(10)
			SELECT @v_dSql += N'      		, NULL AS MODEL_CLASS ' + char(10)
			SELECT @v_dSql += N'      		, A.LT ' + char(10)
			SELECT @v_dSql += N'      		, 9999 AS ITEM_RANK ' + char(10)
			SELECT @v_dSql += N'      		, ''#FFE5C2'' AS D0_BACK ' + char(10)
			SELECT @v_dSql += N'    FROM  MAIN_T A ' + char(10)
			SELECT @v_dSql += N'    ' + @sub_total + char(10) -- WHERE 1=1 or 1=0
			SELECT @v_dSql += N'    AND	  CATEGORY_ID IN ( ''POST'',''INV'' ) ' + char(10)
			SELECT @v_dSql += N'    GROUP BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE, A.MODEL, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ITEM_CLASS, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql += N'      		    , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.CATEGORY_ORDER_LV1, A.MEASURE, A.MODEL_LEVEL_3_NAME, A.LT ' + char(10)
			-- Shipment Plan(Out), Receipt(Plan+Intransit)
			SELECT @v_dSql += N'    UNION ALL ' + char(10)
			SELECT @v_dSql += N'    SELECT A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'      		, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE ' + char(10)
			SELECT @v_dSql += N'      		, A.MODEL, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ITEM_CLASS, NULL AS ELEC_FACTORY_ID' + char(10)
			SELECT @v_dSql += N'      		, NULL AS FACTORY_ID, A.OPERATION_ID, NULL AS LINE_ID, NULL AS ELECTRODE_TYPE, NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS EQUIPMENT_ID, NULL AS APPLIED_MODEL, NULL AS LINE_NAME, NULL AS PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'      		, B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_ORDER_LV1, B.MEASURE ' + char(10)
			SELECT @v_dSql += N'      		, 0 AS PREV_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.POST_BOH_QTY ) / 1 + MAX( A.ERP_BOH_QTY ) AS POST_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.BOH_QTY ) + MAX( A.ERP_BOH_QTY ) AS BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.PC_BOH_QTY ) / 1 AS PC_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.JR_BOH_QTY ) / 1 AS JR_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.JR_AFTER_BOH_QTY ) / 1 AS JR_AFTER_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.ERP_BOH_QTY ) AS ERP_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.ERP_BOH_QTY ) AS ERP_BOH_QTY2 ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.HOLD_QTY ) + MAX( A.ERP_HOLD_QTY ) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.PC_HOLD_QTY ) / 1 AS PC_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.JR_HOLD_QTY ) / 1 AS JR_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.JR_AFTER_HOLD_QTY ) / 1 AS JR_AFTER_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.ERP_HOLD_QTY ) AS ERP_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      		, MAX( A.ERP_HOLD_QTY ) AS ERP_HOLD_QTY2 ' + char(10)

			IF ISNULL(@p_bucket,'') <> '' BEGIN
				IF @max_loop_cnt > 0 BEGIN
					
					-- monthinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						SELECT @v_dSql += '    			 , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END-- end of @mst_loop_cnt < @max_loop_cnt

					-- weekinfo
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						SELECT @v_dSql += '    			 , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
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

						SELECT @v_dSql += N'    			 , MAX(CASE WHEN B.CATEGORY_ID = ''SHIP_IN'' THEN (CASE WHEN C.PLAN_DATE = ''' + @sub_param_0 + ''' THEN ISNULL(C.RECEIPT_IN_QTY,0) ELSE 0 END) ' + char(10)
						SELECT @v_dSql += N'    			                                             ELSE (CASE WHEN D.PLAN_DATE = ''' + @sub_param_0 + ''' THEN ISNULL(D.SHIP_OUT_QTY,0) ELSE 0 END) END) / ' + @p_unit + ' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)

					END		-- end of @mst_loop_cnt < @max_loop_cnt

				END		--end of @max_loop_cnt

			END		-- end of isnull(@p_bucket,'') <> ''

			SELECT @v_dSql += N'      		, ''TOTAL'' AS DATA_TYPE ' + char(10)
			SELECT @v_dSql += N'      		, ''N'' AS IS_ROLE' + char(10)
			SELECT @v_dSql += N'      		, A.MODEL_LEVEL_3_NAME AS MODEL_LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql += N'      		, NULL AS MODEL_CLASS_NAME ' + char(10)
			SELECT @v_dSql += N'      		, NULL AS MODEL_NICK_NAME ' + char(10)
			SELECT @v_dSql += N'      		, NULL AS MODEL_CLASS ' + char(10)
			SELECT @v_dSql += N'      		, A.LT ' + char(10)
			SELECT @v_dSql += N'      		, 9999 AS ITEM_RANK ' + char(10)
			SELECT @v_dSql += N'      		, ''#FFE5C2'' AS D0_BACK ' + char(10)
			SELECT @v_dSql += N'    FROM ( ' + char(10)
			SELECT @v_dSql += N'      		SELECT A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'            	, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE ' + char(10)
			SELECT @v_dSql += N'            	, A.MODEL, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ITEM_CLASS, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql += N'            	, SUM( A.POST_BOH_QTY ) / 1 AS POST_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'            	, SUM( A.BOH_QTY ) / 1 AS BOH_QTY ' + char(10)
			SELECT @v_dSql += N'            	, SUM( A.PC_BOH_QTY ) / 1 AS PC_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'            	, SUM( A.JR_BOH_QTY ) / 1 AS JR_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'            	, SUM( A.JR_AFTER_BOH_QTY ) / 1 AS JR_AFTER_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'            	, MAX( A.ERP_BOH_QTY2 ) / 1 AS ERP_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'            	, SUM( A.HOLD_QTY ) / 1 AS HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'            	, SUM( A.PC_HOLD_QTY ) / 1 AS PC_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'            	, SUM( A.JR_HOLD_QTY ) / 1 AS JR_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'            	, SUM( A.JR_AFTER_HOLD_QTY ) / 1 AS JR_AFTER_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'            	, MAX( A.ERP_HOLD_QTY2 ) / 1 AS ERP_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'            	, MAX( A.LT ) AS LT ' + char(10)
			SELECT @v_dSql += N'            	, A.MODEL_LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql += N'      		FROM  MAIN_T A ' + char(10)
			SELECT @v_dSql += N'      		WHERE A.CATEGORY_ID = ''INV'' ' + char(10)
			SELECT @v_dSql += N'      		GROUP BY A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'            	   , A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE ' + char(10)
			SELECT @v_dSql += N'            	   , A.MODEL, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ITEM_CLASS, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql += N'            	   , A.MODEL_LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql += N'    ) A ' + char(10)
			SELECT @v_dSql += N'    INNER JOIN ( ' + char(10)
			SELECT @v_dSql += N'        	SELECT * ' + char(10)
			SELECT @v_dSql += N'        	FROM ( ' + char(10)
			SELECT @v_dSql += N'          		SELECT ''SHIP'' AS CATEGORY_ID, ''Shipment Plan(Out)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER, 40 AS CATEGORY_ORDER_LV1, ''UOM Type'' AS MEASURE ' + char(10)
			SELECT @v_dSql += N'          		UNION ALL ' + char(10)
			SELECT @v_dSql += N'          		SELECT ''SHIP_IN'' AS CATEGORY_ID, ''Receipt(Plan+Intransit)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER, 50 AS CATEGORY_ORDER_LV1, ''UOM Type'' AS MEASURE ' + char(10)
			SELECT @v_dSql += N'        	) BB ' + char(10)
			SELECT @v_dSql += N'        	WHERE CATEGORY_ID <> ''X'' ' + char(10)
			SELECT @v_dSql += N'    ) B ' + char(10)
			SELECT @v_dSql += N'    ON 1=1 ' + char(10)
			-- INTRANSIT + SHIP_IN
			SELECT @v_dSql += N'    LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'      	SELECT A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.PLAN_DATE ' + char(10)
			
			IF @p_uom_type = 'PANCAKE' BEGIN
				SELECT @v_dSql += N'             , SUM(QTY) AS RECEIPT_IN_QTY ' + char(10)
			END
			ELSE IF @p_uom_type = 'JUMBO_ROLL' BEGIN
				SELECT @v_dSql += N'             , CEILING(CONVERT(NUMERIC(20,5),SUM(A.QTY)) / (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END)) AS RECEIPT_IN_QTY ' + char(10)
			END
			-- CELL
			ELSE BEGIN
				SELECT @v_dSql += N'             , ISNULL( CONVERT(NUMERIC(20,5),CEILING( SUM(A.QTY) / dbo.FN_GET_REQ_QTY_MODEL( A.PLANT_ID, B.APPLIED_MODEL, A.ITEM_ID, A.PLAN_DATE ))) ' + char(10)
				SELECT @v_dSql += N'                     , CONVERT(NUMERIC(20,5),CEILING( SUM(A.QTY) / dbo.FN_GET_REQ_QTY_MODEL( ''''        , B.APPLIED_MODEL, A.ITEM_ID, A.PLAN_DATE ))) ) AS RECEIPT_IN_QTY ' + char(10)
			END

			SELECT @v_dSql += N'      	FROM   ( ' + char(10)
			--= Intransit List : 출발하고 도착지로 이동중인 물량 =--
			SELECT @v_dSql += N'          	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, V.PLANT_ID ' + char(10) --- 도착지 정보
			SELECT @v_dSql += N'          			, A.PLANT_ID AS ASSY_PLANT_ID ' + char(10) --- 도착지 정보  --+ P/C ITEM을 입고받는 ASSY_PLANT정보
			SELECT @v_dSql += N'          			, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'          			, CASE WHEN A.ETA_DATE < CONVERT(VARCHAR, ''' + @p_plan_date + ''',112) THEN CONVERT(VARCHAR, ''' + @p_plan_date + ''',112) ELSE A.ETA_DATE END PLAN_DATE ' + char(10) --+ 만약 도착일자가 과거면 오늘날짜로 강제보정
			SELECT @v_dSql += N'          			, A.INTRANSIT_QTY AS QTY ' + char(10)
			SELECT @v_dSql += N'          			, ''INTRANSIT'' AS GBN ' + char(10)
			SELECT @v_dSql += N'          	FROM   FP_MRP_INTRANSIT_H A WITH(NOLOCK) ' + char(10) ---/ PANCAKE 코드 필터용 /---
			SELECT @v_dSql += N'          	INNER JOIN ( ' + char(10)
			SELECT @v_dSql += N'          			SELECT CC.COMPANY_ID, CC.DIVISION_ID, CC.SITE_ID, CC.ITEM_ID, RIGHT(CC.FLOW_ID, 5) AS FLOW_ID, EE.LEVEL_3_NAME, EE.LEVEL_3_CODE ' + char(10)
			SELECT @v_dSql += N'          			FROM   SCM_ITEM_M CC WITH(NOLOCK), SCM_ITEM_CLASS_M EE WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'          			WHERE  CC.ITEM_CLASS   =  EE.CLASS_ID ' + char(10)
			SELECT @v_dSql += N'          			AND	   EE.USE_FLAG     = ''Y'' ' + char(10)
			SELECT @v_dSql += N'          			AND	   CC.ACTIVE_FLAG  = ''Y'' ' + char(10)
			SELECT @v_dSql += N'          			AND    EE.LEVEL_2_NAME = ''Pancake'' ' + char(10)
			SELECT @v_dSql += N'          			AND	   CC.FLOW_ID IS NOT NULL ' + char(10)
			SELECT @v_dSql += N'          	) C ' + char(10)
			SELECT @v_dSql += N'          	ON  1=1' + char(10)
			SELECT @v_dSql += N'          	AND A.COMPANY_ID  =  C.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'          	AND A.DIVISION_ID =  C.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'          	AND A.SITE_ID     =  C.SITE_ID ' + char(10)
			SELECT @v_dSql += N'          	AND A.ITEM_ID     =  C.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'          	INNER JOIN INS_PLANT V WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'          	ON  1=1 ' + char(10)
			SELECT @v_dSql += N'          	AND A.COMPANY_ID  = V.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'          	AND A.SITE_ID     = V.SITE_ID ' + char(10)
			SELECT @v_dSql += N'          	AND A.PLANT_ID    = V.ASSY_PLANT_ID ' + char(10)
			SELECT @v_dSql += N'          	WHERE  A.INTRANSIT_QTY > 0 ' + char(10)
			SELECT @v_dSql += N'      		UNION ALL ' + char(10)
			-- SCP INTRANSIT 정보 추가... 20200722
			SELECT @v_dSql += N'          	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, V.PLANT_ID, A.PLANT_ID AS ASSY_PLANT_ID, A.ITEM_ID' + char(10)
			SELECT @v_dSql += N'          		 , CASE WHEN A.ETA_DATE < CONVERT(VARCHAR, ''' + @p_plan_date + ''',112) THEN CONVERT(VARCHAR, ''' + @p_plan_date + ''',112) ELSE A.ETA_DATE END PLAN_DATE ' + char(10) --+ 만약 도착일자가 과거면 오늘날짜로 강제보정
			SELECT @v_dSql += N'          		 , DELIVERY_QTY AS QTY ' + char(10)
			SELECT @v_dSql += N'          		 , ''INTRANSIT''  AS GBN ' + char(10)
			SELECT @v_dSql += N'          	FROM   FP_SCM_IN_TRANSIT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'      		     , SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'      		     , SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'      		     , INS_PLANT V ' + char(10)
			SELECT @v_dSql += N'          	WHERE  A.DELIVERY_QTY > 0 ' + char(10)
			SELECT @v_dSql += N'          	AND    A.RESULT_DATE  = CONVERT(VARCHAR, DATEADD(DD, -1, CONVERT(DATE, ''' + @p_plan_date + ''') ),112) ' + char(10)  --> D-1일로 조회해야 함.
			SELECT @v_dSql += N'          	AND    A.COMPANY_ID   = B.COMPANY_ID' + char(10)
			SELECT @v_dSql += N'          	AND    A.DIVISION_ID  = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'          	AND    A.SITE_ID      = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'          	AND    A.ITEM_ID      = B.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'          	AND    B.ACTIVE_FLAG  = ''Y'' ' + char(10)
			SELECT @v_dSql += N'          	AND    B.ITEM_CLASS   = C.CLASS_ID' + char(10)
			SELECT @v_dSql += N'          	AND    C.LEVEL_2_NAME = ''Pancake'' ' + char(10)
			SELECT @v_dSql += N'          	AND    A.COMPANY_ID   = V.COMPANY_ID' + char(10)
			SELECT @v_dSql += N'          	AND    A.SITE_ID      = V.SITE_ID ' + char(10)
			SELECT @v_dSql += N'          	AND    A.PLANT_ID     = V.ASSY_PLANT_ID ' + char(10)
			SELECT @v_dSql += N'      		UNION ALL' + char(10)
			--= Shipment_In List: 미래의 선적계획 =--
			SELECT @v_dSql += N'      		SELECT 	V.COMPANY_ID, V.DIVISION_ID, A.TO_SITE_ID AS SITE_ID, V.PLANT_ID, A.TO_PLANT_ID AS ASSY_PLANT_ID, A.ITEM_ID, A.RECEIVE_YYYYMMDD AS PLAN_DATE, A.SHIP_QTY, ''SHIP_IN''  AS GBN ' + char(10)
			SELECT @v_dSql += N'			FROM	FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'			INNER JOIN INS_PLANT V ' + char(10)
			SELECT @v_dSql += N'			ON  1=1 ' + char(10)
			SELECT @v_dSql += N'			AND A.TO_SITE_ID = V.SITE_ID ' + char(10)
			SELECT @v_dSql += N'			AND A.TO_PLANT_ID = V.ASSY_PLANT_ID ' + char(10)
			SELECT @v_dSql += N'			WHERE	1=1 ' + char(10)
			SELECT @v_dSql += N'			AND		EXISTS ( ' + char(10)
			SELECT @v_dSql += N'						SELECT X.DIVISION_ID, X.SITE_ID, X.PLANT_ID, X.SCP_PLAN_ID ' + char(10)
			SELECT @v_dSql += N'						FROM   ( ' + char(10)
			SELECT @v_dSql += N'							SELECT	A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, MAX(SCP_PLAN_ID) AS SCP_PLAN_ID ' + char(10)
			SELECT @v_dSql += N'							FROM	FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'							WHERE	1=1 ' + char(10)
			SELECT @v_dSql += N'							AND		A.SHOP_GROUP_ID = ''E'' ' + char(10)
			SELECT @v_dSql += N'							GROUP BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'						) X ' + char(10)
			SELECT @v_dSql += N'						WHERE	1=1 ' + char(10)
			SELECT @v_dSql += N'						AND		X.DIVISION_ID	= A.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'						AND		X.SITE_ID		= A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'						AND		X.PLANT_ID		= A.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'						AND		X.SCP_PLAN_ID	= A.SCP_PLAN_ID ' + char(10)
			SELECT @v_dSql += N'			)' + char(10)
			SELECT @v_dSql += N'			AND		A.PLANT_ID <> A.TO_PLANT_ID ' + char(10)	-- 같은건 to 가 외주로 가기 때문에 제외한다.
			SELECT @v_dSql += N'			AND		A.SHIP_QTY  >  0 ' + char(10)
			SELECT @v_dSql += N'			AND		A.RECEIVE_YYYYMMDD >= ''' + @p_plan_date + ''' ' + char(10)   ---+ 미래의 선적계획만 가져온다.
			SELECT @v_dSql += N'      	) A ' + char(10)
			SELECT @v_dSql += N'        INNER JOIN SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'        ON  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'        AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'        AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'        AND A.ITEM_ID     = B.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'        LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql += N'            SELECT A.PLANT_ID, A.ITEM_ID, MAX(LANE_QTY) AS LANE_QTY ' + char(10)
			SELECT @v_dSql += N'            FROM   SCM_ITEM_LANE_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'            WHERE  A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'            GROUP BY A.PLANT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'        ) G ' + char(10)
			SELECT @v_dSql += N'        ON  A.PLANT_ID = G.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'        AND A.ITEM_ID  = G.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'      	WHERE 1=1 ' + char(10)
			SELECT @v_dSql += N'      	GROUP BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.PLAN_DATE, B.APPLIED_MODEL, G.LANE_QTY ' + char(10)
			SELECT @v_dSql += N'    ) C ' + char(10)
			SELECT @v_dSql += N'    ON  1=1 ' + char(10)
			SELECT @v_dSql += N'    AND A.DIVISION_ID = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'    AND A.SITE_ID     = C.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    AND A.ITEM_ID     = C.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'    LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'      		SELECT Z.DIVISION_ID, Z.SITE_ID, Z.ITEM_ID, Z.PLAN_DATE ' + char(10)
			
			IF @p_uom_type = 'PANCAKE' BEGIN
				SELECT @v_dSql += N'      		     , SUM(ISNULL(Z.SHIP_QTY,0))  AS SHIP_OUT_QTY ' + char(10)
			END
			ELSE IF @p_uom_type = 'JUMBO_ROLL' BEGIN
				SELECT @v_dSql += N'      		     , CEILING(CONVERT(NUMERIC(20,5),SUM(ISNULL(Z.SHIP_QTY,0))) / (CASE WHEN G.LANE_QTY IS NULL OR G.LANE_QTY = 0 THEN 1 ELSE G.LANE_QTY END)) AS SHIP_OUT_QTY ' + char(10)
			END
			-- CELL
			ELSE BEGIN
				SELECT @v_dSql += N'      		     , ISNULL( CONVERT(NUMERIC(20,5),CEILING( SUM(ISNULL(Z.SHIP_QTY,0)) / dbo.FN_GET_REQ_QTY_MODEL( Z.PLANT_ID, B.APPLIED_MODEL, Z.ITEM_ID, Z.PLAN_DATE ))) ' + char(10)
				SELECT @v_dSql += N'      		     ,         CONVERT(NUMERIC(20,5),CEILING( SUM(ISNULL(Z.SHIP_QTY,0)) / dbo.FN_GET_REQ_QTY_MODEL( ''''        , B.APPLIED_MODEL, Z.ITEM_ID, Z.PLAN_DATE ))) ) AS SHIP_OUT_QTY ' + char(10)
			END

			SELECT @v_dSql += N'      		FROM ( ' + char(10) --== SHIP_OUT DATA LIST... SSP Shipping Plan 으로 변경... 20200722
			SELECT @v_dSql += N'                SELECT ''' + @p_instance_id + ''' AS INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, CONVERT(VARCHAR,A.SHIP_DATE,112) AS PLAN_DATE, A.SHIP_QTY ' + char(10)
			SELECT @v_dSql += N'                FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'                INNER JOIN ( ' + char(10)
			SELECT @v_dSql += N'                    SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
			SELECT @v_dSql += N'                    FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'                    WHERE  A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N'                ) B ' + char(10)
			SELECT @v_dSql += N'                ON  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'                AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'                AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'                AND A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'                WHERE CONVERT(VARCHAR,A.SHIP_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql += N'                AND	  EXISTS ( ' + char(10)
			SELECT @v_dSql += N'      				SELECT X.DIVISION_ID, X.SITE_ID, X.PLANT_ID, X.SCP_PLAN_ID ' + char(10)
			SELECT @v_dSql += N'      				FROM (' + char(10)
			SELECT @v_dSql += N'      					SELECT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, MAX(SCP_PLAN_ID) AS SCP_PLAN_ID ' + char(10)
			SELECT @v_dSql += N'      					FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'      					WHERE  1=1 ' + char(10)
			SELECT @v_dSql += N'      					AND	   A.SHOP_GROUP_ID = ''E'' ' + char(10)
			SELECT @v_dSql += N'      					GROUP BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'      				) X ' + char(10)
			SELECT @v_dSql += N'      				WHERE	1=1 ' + char(10)
			SELECT @v_dSql += N'      				AND		X.DIVISION_ID = A.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'      				AND		X.SITE_ID     = A.SITE_ID ' + char(10)
			SELECT @v_dSql += N'      				AND		X.PLANT_ID    = A.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'      				AND		X.SCP_PLAN_ID = A.SCP_PLAN_ID ' + char(10)
			SELECT @v_dSql += N'				) ' + char(10)
			SELECT @v_dSql += N'      		) Z ' + char(10)
			SELECT @v_dSql += N'			INNER JOIN SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'			ON  Z.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'			AND Z.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'			AND Z.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'			AND Z.ITEM_ID     = B.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'			LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql += N'				SELECT A.PLANT_ID, A.ITEM_ID, MAX(LANE_QTY) AS LANE_QTY ' + char(10)
			SELECT @v_dSql += N'				FROM   SCM_ITEM_LANE_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'				WHERE  A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'				GROUP BY A.PLANT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'			) G ' + char(10)
			SELECT @v_dSql += N'			ON  Z.PLANT_ID = G.PLANT_ID ' + char(10)
			SELECT @v_dSql += N'			AND Z.ITEM_ID  = G.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'      		GROUP BY Z.DIVISION_ID, Z.SITE_ID, Z.PLANT_ID, Z.ITEM_ID, Z.PLAN_DATE, B.APPLIED_MODEL, G.LANE_QTY ' + char(10)
			SELECT @v_dSql += N'    ) D ' + char(10)
			SELECT @v_dSql += N'    ON  1=1 ' + char(10)
			SELECT @v_dSql += N'    AND A.DIVISION_ID = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'    AND A.SITE_ID     = D.SITE_ID ' + char(10)
			SELECT @v_dSql += N'    AND A.ITEM_ID     = D.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'    ' + @sub_total + char(10) -- WHERE 1=1 or 1=0
			SELECT @v_dSql += N'    GROUP BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE, A.MODEL, A.TOP_ITEM_ID, A.NPC_ITEM_ID, A.ITEM_CLASS, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql += N'      	   , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_ORDER_LV1, B.MEASURE, A.MODEL_LEVEL_3_NAME, A.LT ' + char(10)
			-- Total
			SELECT @v_dSql += N'    UNION ALL ' + char(10)
			SELECT @v_dSql += N'    SELECT NULL AS DIVISION_ID, NULL AS SITE_ID ' + char(10)
			SELECT @v_dSql += N'          	, NULL AS ITEM_ID, NULL AS NICK_NAME, NULL AS ITEM_TYPE ' + char(10)
			SELECT @v_dSql += N'          	, NULL AS MODEL, NULL AS TOP_ITEM_ID, NULL AS NPC_ITEM_ID, NULL AS ITEM_CLASS, NULL AS ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql += N'          	, NULL AS FACTORY_ID, NULL AS OPERATION_ID, NULL AS LINE_ID, NULL AS ELECTRODE_TYPE, NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS EQUIPMENT_ID, NULL AS APPLIED_MODEL, NULL AS LINE_NAME, NULL AS PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += N'          	, A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.CATEGORY_ORDER_LV1, A.MEASURE ' + char(10)
			SELECT @v_dSql += N'          	, 0 AS PREV_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'          	, B.POST_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'          	, B.BOH_QTY + B.ERP_BOH_QTY AS BOH_QTY ' + char(10)
			SELECT @v_dSql += N'          	, B.PC_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'          	, B.JR_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'          	, B.JR_AFTER_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'          	, B.ERP_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'          	, B.ERP_BOH_QTY AS ERP_BOH_QTY2 ' + char(10)
			SELECT @v_dSql += N'          	, B.HOLD_QTY + B.ERP_HOLD_QTY AS HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'          	, B.PC_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'          	, B.JR_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'          	, B.JR_AFTER_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'          	, B.ERP_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'          	, B.ERP_HOLD_QTY AS ERP_HOLD_QTY2 ' + char(10)

			IF ISNULL(@p_bucket,'') <> '' BEGIN
				IF @max_loop_cnt > 0 BEGIN
					
					-- monthinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						SELECT @v_dSql += '    			 , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END-- end of @mst_loop_cnt < @max_loop_cnt

					-- weekinfo
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						SELECT @v_dSql += '    			 , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
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

						SELECT @v_dSql += N'    		 , A.D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)

					END		-- end of @mst_loop_cnt < @max_loop_cnt

				END		--end of @max_loop_cnt

			END		-- end of isnull(@p_bucket,'') <> ''

			SELECT @v_dSql += N'          	, ''TOTAL_2'' AS DATA_TYPE ' + char(10)
			SELECT @v_dSql += N'          	, ''N'' AS IS_ROLE ' + char(10)
			SELECT @v_dSql += N'          	, NULL AS MODEL_LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql += N'          	, NULL AS MODEL_CLASS_NAME ' + char(10)
			SELECT @v_dSql += N'          	, NULL AS MODEL_NICK_NAME ' + char(10)
			SELECT @v_dSql += N'          	, NULL AS MODEL_CLASS ' + char(10)
			SELECT @v_dSql += N'          	, NULL AS LT ' + char(10)
			SELECT @v_dSql += N'          	, 9999 AS ITEM_RANK ' + char(10)
			SELECT @v_dSql += N'          	, ''#FFBA85'' AS D0_BACK ' + char(10)
			SELECT @v_dSql += N'    FROM   ( ' + char(10)
			SELECT @v_dSql += N'        SELECT A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.CATEGORY_ORDER_LV1, A.MEASURE ' + char(10)

			IF ISNULL(@p_bucket,'') <> '' BEGIN
				IF @max_loop_cnt > 0 BEGIN
					
					-- monthinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						SELECT @v_dSql += '    			 , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END-- end of @mst_loop_cnt < @max_loop_cnt

					-- weekinfo
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						SELECT @v_dSql += '    			 , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
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

						SELECT @v_dSql += N'    		 , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ') / ' + @p_unit + ' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)

					END		-- end of @mst_loop_cnt < @max_loop_cnt

				END		--end of @max_loop_cnt

			END		-- end of isnull(@p_bucket,'') <> ''

			SELECT @v_dSql += N'        FROM  MAIN_T A ' + char(10)
			SELECT @v_dSql += N'        ' + @total + char(10) -- WHERE 1=1 or 1=0
			IF @p_chk_total_include <> 'Y' BEGIN	SELECT @v_dSql += N'        AND 1=0 ' + char(10)	END

			SELECT @v_dSql += N'        AND	  CATEGORY_ID <> ''INV'' ' + char(10)
			SELECT @v_dSql += N'        GROUP BY A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.CATEGORY_ORDER_LV1, A.MEASURE ' + char(10)
			SELECT @v_dSql += N'    ) A ' + char(10)
			SELECT @v_dSql += N'    LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'      		SELECT SUM( A.POST_BOH_QTY ) / 1 AS POST_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      			 , SUM( A.BOH_QTY ) / 1 AS BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      			 , SUM( A.PC_BOH_QTY ) / 1 AS PC_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      			 , SUM( A.JR_BOH_QTY ) / 1 AS JR_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      			 , SUM( A.JR_AFTER_BOH_QTY ) / 1 AS JR_AFTER_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      			 , SUM( A.ERP_BOH_QTY2 ) / 1 AS ERP_BOH_QTY ' + char(10)
			SELECT @v_dSql += N'      			 , SUM( A.HOLD_QTY ) / 1 AS HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      			 , SUM( A.PC_HOLD_QTY ) / 1 AS PC_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      			 , SUM( A.JR_HOLD_QTY ) / 1 AS JR_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      			 , SUM( A.JR_AFTER_HOLD_QTY ) / 1 AS JR_AFTER_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      			 , SUM( A.ERP_HOLD_QTY2 ) / 1 AS ERP_HOLD_QTY ' + char(10)
			SELECT @v_dSql += N'      		FROM   MAIN_T A ' + char(10)
			SELECT @v_dSql += N'      		WHERE  A.CATEGORY_ID = ''INV'' ' + char(10)
			SELECT @v_dSql += N'    ) B ' + char(10)
			SELECT @v_dSql += N'    ON 1=1 ' + char(10)
			SELECT @v_dSql += N') A ' + char(10)
			SELECT @v_dSql += N'ORDER BY A.DIVISION_ID, A.SITE_ID, A.MODEL, A.MODEL_LEVEL_3_NAME, A.ITEM_CLASS, A.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'        , (CASE WHEN A.DATA_TYPE = ''DATA'' THEN 1 ELSE A.CATEGORY_ORDER END), A.ELEC_FACTORY_ID, A.CATEGORY_ORDER_LV1 ' + char(10)
			SELECT @v_dSql += N'        , (CASE WHEN A.CATEGORY_ID = ''ASSY'' THEN A.FACTORY_ID ELSE ''ZZZZZ'' END) ' + char(10)
			SELECT @v_dSql += N'        , A.MARKET, A.PRODUCTION_TYPE, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql += N'        , A.CATEGORY_ORDER, A.MEASURE ' + char(10)

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
	
	BEGIN
		IF OBJECT_ID('tempdb..#TEMP_TABLE_01') IS NOT NULL
		DROP TABLE #TEMP_TABLE_01
		    
		IF OBJECT_ID('tempdb..#TEMP_TABLE_02') IS NOT NULL
		DROP TABLE #TEMP_TABLE_02

		IF OBJECT_ID('tempdb..#SCM_BOM') IS NOT NULL
		DROP TABLE #SCM_BOM

		IF OBJECT_ID('tempdb..#ASSY_MODEL_2') IS NOT NULL
		DROP TABLE #ASSY_MODEL_2

	END
  
END

