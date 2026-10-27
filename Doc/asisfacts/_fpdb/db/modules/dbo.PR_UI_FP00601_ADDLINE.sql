
CREATE PROCEDURE [dbo].[PR_UI_FP00601_ADDLINE]
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
/** 프로그램 ID   : PR_UI_FP00601_ADDLINE                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP00601_ADDLINE                                               **/
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
/** 2026/06/08   kimcd      [PJ2026-50215] ESOC 각형 Pilot 라인 Multi-Stack 공정 FP 대응       **/
/**                         공정 Hard Coding에서 PL450 추가                                    **/
/** 2026/08/10   kimcd      [ES20260810] PL450 > PL500 공정 코드 변경                          **/
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP00601_ADDLINE';
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
	DECLARE @p_date			NVARCHAR(MAX);
	DECLARE @p_model_id		NVARCHAR(MAX);
	DECLARE @p_market		NVARCHAR(MAX);
	DECLARE @p_out_qty		NVARCHAR(MAX);

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
		END ELSE IF @tmp_column = 'DATE' BEGIN
			SET @p_date			   =	@tmp_value ;
		END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
			SET @p_model_id		   =	@tmp_value ;
		END ELSE IF @tmp_column = 'MARKET' BEGIN
			SET @p_market		   =	@tmp_value ;
		END ELSE IF @tmp_column = 'OUT_QTY' BEGIN
			SET @p_out_qty		   =	@tmp_value ;
		END ELSE IF @tmp_column = 'PRODUCTION_TYPE' BEGIN
			SET @p_prod_type	   =	@tmp_value ;

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

	IF @p_sys_flag = 'ITEM_LIST'	-- find_ItemList
	BEGIN
		
		SELECT @v_dSql += N'	WITH INST_OP AS (																															' + char(10)	
		SELECT @v_dSql += N'						SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID                                                  ' + char(10)
		SELECT @v_dSql += N'						FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK)                                           ' + char(10)
		SELECT @v_dSql += N'						WHERE  A.COMPANY_ID   = B.COMPANY_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'						AND    A.DIVISION_ID  = B.DIVISION_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'						AND    A.SITE_ID      = B.SITE_ID                                                                                       ' + char(10)
		SELECT @v_dSql += N'						AND    A.OPERATION_ID = B.OPERATION_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'						AND    A.INSTANCE_ID  = '''+ @p_instance_id +'''                                                                                   ' + char(10)
		SELECT @v_dSql += N'						AND    A.AMEND_FLAG   = ''Y''                                                                                           ' + char(10)
		SELECT @v_dSql += N'						AND    B.ACTIVE_FLAG  = ''Y''                                                                                           ' + char(10)
		SELECT @v_dSql += N'					)                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	,CTE_NODE	(	                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'					COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,KEY_DATE                                               ' + char(10)
		SELECT @v_dSql += N'					,EFF_START_DATE,EFF_END_DATE,PARENT_QTY,PARENT_UOM,CHILD_QTY,CHILD_UOM                                                      ' + char(10)
		SELECT @v_dSql += N'					,PARENT_ITEM_TYPE,PARENT_ITEM_CLASS,PARENT_NICK_NAME,PARENT_LEVEL_2_CODE,PARENT_LEVEL_3_NAME,PARENT_LEVEL_4_NAME            ' + char(10)
		SELECT @v_dSql += N'					,CHILD_ITEM_TYPE,CHILD_ITEM_CLASS,CHILD_NICK_NAME,CHILD_LEVEL_2_CODE,CHILD_LEVEL_3_NAME,CHILD_LEVEL_4_NAME                  ' + char(10)
		SELECT @v_dSql += N'					,NLEVEL,NPATH,ROOT, FLOW_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'				)                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'				AS (                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'						SELECT 	A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID,A.KEY_DATE                     ' + char(10)
		SELECT @v_dSql += N'								, A.EFF_START_DATE,A.EFF_END_DATE,A.PARENT_QTY,A.PARENT_UOM,A.CHILD_QTY,A.CHILD_UOM                             ' + char(10)
		SELECT @v_dSql += N'								, PD1.ITEM_TYPE AS PARENT_ITEM_TYPE                                                                             ' + char(10)
		SELECT @v_dSql += N'								, PD1.ITEM_CLASS AS PARENT_ITEM_CLASS                                                                           ' + char(10)
		SELECT @v_dSql += N'								, PD1.NICK_NAME AS PARENT_NICK_NAME                                                                             ' + char(10)
		SELECT @v_dSql += N'								, PDC1.LEVEL_2_CODE AS PARENT_LEVEL_2_CODE                                                                      ' + char(10)
		SELECT @v_dSql += N'								, PDC1.LEVEL_3_NAME AS PARENT_LEVEL_3_NAME                                                                      ' + char(10)
		SELECT @v_dSql += N'								, PDC1.LEVEL_4_NAME AS PARENT_LEVEL_4_NAME                                                                      ' + char(10)
		SELECT @v_dSql += N'								, PD2.ITEM_TYPE AS CHILD_ITEM_TYPE                                                                              ' + char(10)
		SELECT @v_dSql += N'								, PD2.ITEM_CLASS AS CHILD_ITEM_CLASS                                                                            ' + char(10)
		SELECT @v_dSql += N'								, PD2.NICK_NAME AS CHILD_NICK_NAME                                                                              ' + char(10)
		SELECT @v_dSql += N'								, PDC2.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE                                                                       ' + char(10)
		SELECT @v_dSql += N'								, PDC2.LEVEL_3_NAME AS CHILD_LEVEL_3_NAME                                                                       ' + char(10)
		SELECT @v_dSql += N'								, PDC2.LEVEL_4_NAME AS CHILD_LEVEL_4_NAME                                                                       ' + char(10)
		SELECT @v_dSql += N'								, 1 AS NLEVEL,CONVERT(VARCHAR(100),PARENT_ITEM_ID+''/''+CHILD_ITEM_ID) AS NPATH,PARENT_ITEM_ID AS ROOT          ' + char(10)
		SELECT @v_dSql += N'								, PD1.FLOW_ID                                                                                                   ' + char(10)
		SELECT @v_dSql += N'						FROM 	SCM_BOM_M A WITH(NOLOCK)                                                                                        ' + char(10)
		SELECT @v_dSql += N'								INNER JOIN SCM_ITEM_M PD1 WITH(NOLOCK)                                                                          ' + char(10)
		SELECT @v_dSql += N'								ON  A.COMPANY_ID     = PD1.COMPANY_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'								AND A.DIVISION_ID    = PD1.DIVISION_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'								AND A.SITE_ID        = PD1.SITE_ID                                                                              ' + char(10)
		SELECT @v_dSql += N'								AND A.PARENT_ITEM_ID = PD1.ITEM_ID                                                                              ' + char(10)
		SELECT @v_dSql += N'								INNER JOIN SCM_ITEM_CLASS_M PDC1 WITH(NOLOCK)                                                                   ' + char(10)
		SELECT @v_dSql += N'								ON PD1.ITEM_CLASS = PDC1.CLASS_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'								INNER JOIN SCM_ITEM_M PD2 WITH(NOLOCK)                                                                          ' + char(10)
		SELECT @v_dSql += N'								ON  A.COMPANY_ID    = PD2.COMPANY_ID                                                                            ' + char(10)
		SELECT @v_dSql += N'								AND A.DIVISION_ID   = PD2.DIVISION_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'								AND A.SITE_ID       = PD2.SITE_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'								AND A.CHILD_ITEM_ID = PD2.ITEM_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'								INNER JOIN SCM_ITEM_CLASS_M PDC2 WITH(NOLOCK)                                                                   ' + char(10)
		SELECT @v_dSql += N'								ON PD2.ITEM_CLASS=PDC2.CLASS_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'								, INST_OP D                                                                                                     ' + char(10)
		SELECT @v_dSql += N'						WHERE 1=1                                                                                                               ' + char(10)
		SELECT @v_dSql += N'						AND   A.COMPANY_ID  = D.COMPANY_ID                                                                                      ' + char(10)
		SELECT @v_dSql += N'						AND   A.DIVISION_ID = D.DIVISION_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'						AND   A.SITE_ID     = D.SITE_ID                                                                                         ' + char(10)
		SELECT @v_dSql += N'						AND   PD1.FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%''                                                                   ' + char(10)
		SELECT @v_dSql += N'						AND   A.EFF_START_DATE <= '''+ @p_date +'''                                                                                        ' + char(10)
		SELECT @v_dSql += N'						AND   A.EFF_END_DATE   >  '''+ @p_date +'''                                                                                        ' + char(10)
		SELECT @v_dSql += N'						AND   A.ACTIVE_FLAG    = ''Y''                                                                                          ' + char(10)
		SELECT @v_dSql += N'						AND   PD1.ACTIVE_FLAG  = ''Y''                                                                                          ' + char(10)
		SELECT @v_dSql += N'						AND   PDC1.USE_FLAG    = ''Y''                                                                                          ' + char(10)
		SELECT @v_dSql += N'						AND   PD2.ACTIVE_FLAG  = ''Y''                                                                                          ' + char(10)
		SELECT @v_dSql += N'						AND   PDC2.USE_FLAG    = ''Y''                                                                                          ' + char(10)
		SELECT @v_dSql += N'						UNION ALL                                                                                                               ' + char(10)
		SELECT @v_dSql += N'						SELECT 	A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID,A.KEY_DATE                     ' + char(10)
		SELECT @v_dSql += N'								, A.EFF_START_DATE,A.EFF_END_DATE,A.PARENT_QTY,A.PARENT_UOM,A.CHILD_QTY,A.CHILD_UOM                             ' + char(10)
		SELECT @v_dSql += N'								, PD1.ITEM_TYPE AS PARENT_ITEM_TYPE                                                                             ' + char(10)
		SELECT @v_dSql += N'								, PD1.ITEM_CLASS AS PARENT_ITEM_CLASS                                                                           ' + char(10)
		SELECT @v_dSql += N'								, PD1.NICK_NAME AS PARENT_NICK_NAME                                                                             ' + char(10)
		SELECT @v_dSql += N'								, PDC1.LEVEL_2_CODE AS PARENT_LEVEL_2_CODE                                                                      ' + char(10)
		SELECT @v_dSql += N'								, PDC1.LEVEL_3_NAME AS PARENT_LEVEL_3_NAME                                                                      ' + char(10)
		SELECT @v_dSql += N'								, PDC1.LEVEL_4_NAME AS PARENT_LEVEL_4_NAME                                                                      ' + char(10)
		SELECT @v_dSql += N'								, PD2.ITEM_TYPE AS CHILD_ITEM_TYPE                                                                              ' + char(10)
		SELECT @v_dSql += N'								, PD2.ITEM_CLASS AS CHILD_ITEM_CLASS                                                                            ' + char(10)
		SELECT @v_dSql += N'								, PD2.NICK_NAME AS CHILD_NICK_NAME                                                                              ' + char(10)
		SELECT @v_dSql += N'								, PDC2.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE                                                                       ' + char(10)
		SELECT @v_dSql += N'								, PDC2.LEVEL_3_NAME AS CHILD_LEVEL_3_NAME                                                                       ' + char(10)
		SELECT @v_dSql += N'								, PDC2.LEVEL_4_NAME AS CHILD_LEVEL_4_NAME                                                                       ' + char(10)
		SELECT @v_dSql += N'								, NLEVEL+1 AS NLEVEL ,CONVERT(VARCHAR(100),NPATH+''/''+A.CHILD_ITEM_ID) AS NPATH,ROOT                           ' + char(10)
		SELECT @v_dSql += N'								, PD1.FLOW_ID                                                                                                   ' + char(10)
		SELECT @v_dSql += N'						FROM 	SCM_BOM_M A WITH(NOLOCK)                                                                                        ' + char(10)
		SELECT @v_dSql += N'								INNER JOIN CTE_NODE B                                                                                           ' + char(10)
		SELECT @v_dSql += N'								ON  A.PARENT_ITEM_ID = B.CHILD_ITEM_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'								AND A.COMPANY_ID     = B.COMPANY_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'								AND A.DIVISION_ID    = B.DIVISION_ID                                                                            ' + char(10)
		SELECT @v_dSql += N'								AND A.SITE_ID        = B.SITE_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'								INNER JOIN SCM_ITEM_M PD1 WITH(NOLOCK)                                                                          ' + char(10)
		SELECT @v_dSql += N'								ON  A.COMPANY_ID     = PD1.COMPANY_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'								AND A.DIVISION_ID    = PD1.DIVISION_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'								AND A.SITE_ID        = PD1.SITE_ID                                                                              ' + char(10)
		SELECT @v_dSql += N'								AND A.PARENT_ITEM_ID = PD1.ITEM_ID                                                                              ' + char(10)
		SELECT @v_dSql += N'								INNER JOIN SCM_ITEM_CLASS_M PDC1 WITH(NOLOCK)                                                                   ' + char(10)
		SELECT @v_dSql += N'								ON  PD1.ITEM_CLASS = PDC1.CLASS_ID                                                                              ' + char(10)
		SELECT @v_dSql += N'								INNER JOIN SCM_ITEM_M PD2 WITH(NOLOCK)                                                                          ' + char(10)
		SELECT @v_dSql += N'								ON  A.COMPANY_ID    = PD2.COMPANY_ID                                                                            ' + char(10)
		SELECT @v_dSql += N'								AND A.DIVISION_ID   = PD2.DIVISION_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'								AND A.SITE_ID       = PD2.SITE_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'								AND A.CHILD_ITEM_ID = PD2.ITEM_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'								INNER JOIN SCM_ITEM_CLASS_M PDC2 WITH(NOLOCK)                                                                   ' + char(10)
		SELECT @v_dSql += N'								ON  PD2.ITEM_CLASS=PDC2.CLASS_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'								, INST_OP D                                                                                                     ' + char(10)
		SELECT @v_dSql += N'						WHERE 1=1                                                                                                               ' + char(10)
		SELECT @v_dSql += N'						AND   A.COMPANY_ID  = D.COMPANY_ID                                                                                      ' + char(10)
		SELECT @v_dSql += N'						AND   A.DIVISION_ID = D.DIVISION_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'						AND   A.SITE_ID     = D.SITE_ID                                                                                         ' + char(10)
		SELECT @v_dSql += N'						AND   PD1.FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%''                                                                   ' + char(10)
		SELECT @v_dSql += N'						AND   A.EFF_START_DATE <= '''+ @p_date +''' -- 입력일자 기준으로 ECO 일자 지정                                                     ' + char(10)
		SELECT @v_dSql += N'						AND   A.EFF_END_DATE   >  '''+ @p_date +'''                                                                                        ' + char(10)
		SELECT @v_dSql += N'						AND   PD1.ACTIVE_FLAG  = ''Y''                                                                                          ' + char(10)
		SELECT @v_dSql += N'						AND   PDC1.USE_FLAG    = ''Y''                                                                                          ' + char(10)
		SELECT @v_dSql += N'						AND   PD2.ACTIVE_FLAG  = ''Y''                                                                                          ' + char(10)
		SELECT @v_dSql += N'						AND   PDC2.USE_FLAG    = ''Y''                                                                                          ' + char(10)
		SELECT @v_dSql += N'				   )                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	SELECT 	DISTINCT A.*                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	FROM 	(                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'				SELECT DISTINCT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ROOT AS MODEL_ID, A.PARENT_ITEM_ID AS ITEM_ID                           ' + char(10)
		SELECT @v_dSql += N'					 , A.PARENT_NICK_NAME AS NICK_NAME                                                                                          ' + char(10)
		SELECT @v_dSql += N'					 , (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND  ISNULL(A.PARENT_LEVEL_4_NAME, ''-'') = ''-'' THEN A.PARENT_LEVEL_3_NAME    ' + char(10)
		SELECT @v_dSql += N'							 WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(A.PARENT_LEVEL_4_NAME, ''-'')                                       ' + char(10)
		SELECT @v_dSql += N'							 ELSE A.PARENT_LEVEL_3_NAME END) AS ITEM_TYPE                                                                       ' + char(10)
		SELECT @v_dSql += N'				FROM   CTE_NODE A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK)                                                                       ' + char(10)
		SELECT @v_dSql += N'				WHERE  1=1                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'				AND    A.COMPANY_ID  = B.COMPANY_ID                                                                                             ' + char(10)
		SELECT @v_dSql += N'				AND    A.DIVISION_ID = B.DIVISION_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'				AND    A.SITE_ID     = B.SITE_ID                                                                                                ' + char(10)
		SELECT @v_dSql += N'				AND    A.ROOT        = B.ITEM_ID                                                                                                ' + char(10)
		SELECT @v_dSql += N'				--AND    B.ITEM_TYPE   = ''P''                                                                                                  ' + char(10)
		SELECT @v_dSql += N'				AND    RIGHT(B.FLOW_ID,5) IN (''P5500'',''P9500'',''PL500'')                                                                    ' + char(10)
		-- 2026.08.10 kimcd [ES20260810] PL450 > PL500 공정 코드 변경. 2026.06.08 kimcd [PJ2026-50215] ESOC 각형 Pilot 라인 Multi-Stack 공정 FP 대응 공정 Hard Coding에서 PL450 추가
		SELECT @v_dSql += N'				AND    EXISTS ( SELECT 1                                                                                                        ' + char(10)
		SELECT @v_dSql += N'				        				FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                               ' + char(10)
		SELECT @v_dSql += N'				        				WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'				        				AND    A.DIVISION_ID = B.DIVISION_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'				        				AND    A.SITE_ID     = B.SITE_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'				        				AND    B.USER_ID     = '''+ @p_user_id +'''                                                                        ' + char(10)
		SELECT @v_dSql += N'				        				AND	   B.SAVE_FLAG	 = ''Y'' )                                                                          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ROOT' , 'LIKE', @p_model_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PARENT_ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PARENT_NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'			) A                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	ORDER BY DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, ITEM_ID, NICK_NAME, ITEM_TYPE                                                            ' + char(10)

	END
	
	IF @p_sys_flag = 'ITEM_LIST_TEST'	-- find_ItemList_byTEST
	BEGIN

		SELECT @v_dSql += N'	SELECT 	DISTINCT A.*																													' + char(10)
		SELECT @v_dSql += N'	FROM	(                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'				-- TEST 타입 : item 기준 item                                                                                               ' + char(10)
		SELECT @v_dSql += N'				SELECT 	DISTINCT A.DIVISION_ID, A.SITE_ID, B.PLANT_ID                                                                       ' + char(10)
		SELECT @v_dSql += N'						, UPPER('''+ @p_item_id +''') AS MODEL_ID                                                                                      ' + char(10)
		SELECT @v_dSql += N'						, UPPER('''+ @p_item_id +''') AS ITEM_ID, A.NICK_NAME                                                                          ' + char(10)
		SELECT @v_dSql += N'						, (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND  ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME           ' + char(10)
		SELECT @v_dSql += N'								WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                                       ' + char(10)
		SELECT @v_dSql += N'								ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE                                                                       ' + char(10)
		SELECT @v_dSql += N'				FROM   	SCM_ITEM_M A WITH(NOLOCK)                                                                                           ' + char(10)
		SELECT @v_dSql += N'						INNER HASH JOIN (                                                                                                   ' + char(10)
		SELECT @v_dSql += N'								SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                          ' + char(10)
		SELECT @v_dSql += N'								FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)                                                                   ' + char(10)
		SELECT @v_dSql += N'								WHERE  1=1                                                                                                  ' + char(10)
		SELECT @v_dSql += N'								AND    A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                        ' + char(10)
		SELECT @v_dSql += N'								AND    A.SAVE_FLAG   = ''Y''                                                                                ' + char(10)
		SELECT @v_dSql += N'								AND    A.USER_ID     = '''+ @p_user_id +'''                                                                            ' + char(10)
		SELECT @v_dSql += N'						) B                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'						ON     A.COMPANY_ID = B.COMPANY_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'						AND    A.DIVISION_ID = B.DIVISION_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'						AND    A.SITE_ID = B.SITE_ID                                                                                        ' + char(10)
		SELECT @v_dSql += N'						INNER JOIN SCM_ITEM_CLASS_M C WITH(NOLOCK)                                                                          ' + char(10)
		SELECT @v_dSql += N'						ON     A.ITEM_CLASS = C.CLASS_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'				WHERE  1=1                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'				AND    '''+ @p_prod_type +''' IN (''TEST'',''D-TEST'',''E-TEST'')                                                                ' + char(10)
		SELECT @v_dSql += N'				AND    RIGHT(A.FLOW_ID,5) IN (''P5500'',''P9500'',''P5000'',''P5200'',''PL500'')                                            ' + char(10)
		-- 2026.08.10 kimcd [ES20260810] PL450 > PL500 공정 코드 변경. 2026.06.08 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. 공정 Hard Coding에서 PL450 추가
		SELECT @v_dSql += N'				AND    A.ITEM_ID = '''+ @p_item_id +'''                                                                                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'				-- TEST 타입 : model 기준 item                                                                                              ' + char(10)
		SELECT @v_dSql += N'				UNION ALL                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'				SELECT 	DISTINCT A.DIVISION_ID, A.SITE_ID, B.PLANT_ID                                                                       ' + char(10)
		SELECT @v_dSql += N'						, UPPER('''+ @p_model_id +''') AS MODEL_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'						, UPPER('''+ @p_model_id +''') AS ITEM_ID, A.NICK_NAME                                                                         ' + char(10)
		SELECT @v_dSql += N'						, (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND  ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME           ' + char(10)
		SELECT @v_dSql += N'								WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                                       ' + char(10)
		SELECT @v_dSql += N'								ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE                                                                       ' + char(10)
		SELECT @v_dSql += N'				FROM   SCM_ITEM_M A WITH(NOLOCK)                                                                                            ' + char(10)
		SELECT @v_dSql += N'						INNER HASH JOIN (                                                                                                   ' + char(10)
		SELECT @v_dSql += N'											SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                              ' + char(10)
		SELECT @v_dSql += N'											FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)                                                       ' + char(10)
		SELECT @v_dSql += N'											WHERE  1=1                                                                                      ' + char(10)
		SELECT @v_dSql += N'											AND    A.INSTANCE_ID = '''+ @p_instance_id +'''                                                            ' + char(10)
		SELECT @v_dSql += N'											AND    A.SAVE_FLAG   = ''Y''                                                                    ' + char(10)
		SELECT @v_dSql += N'											AND    A.USER_ID     = '''+ @p_user_id +'''                                                                ' + char(10)
		SELECT @v_dSql += N'										) B                                                                                                 ' + char(10)
		SELECT @v_dSql += N'						ON     A.COMPANY_ID = B.COMPANY_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'						AND    A.DIVISION_ID = B.DIVISION_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'						AND    A.SITE_ID = B.SITE_ID                                                                                        ' + char(10)
		SELECT @v_dSql += N'						INNER JOIN SCM_ITEM_CLASS_M C WITH(NOLOCK)                                                                          ' + char(10)
		SELECT @v_dSql += N'						ON     A.ITEM_CLASS = C.CLASS_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'				WHERE  1=1                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'				AND    '''+ @p_prod_type +''' IN (''TEST'',''D-TEST'',''E-TEST'')                                                                ' + char(10)
		SELECT @v_dSql += N'				AND    RIGHT(A.FLOW_ID,5) IN (''P5500'',''P9500'',''P5000'',''P5200'',''PL500'')                                            ' + char(10)
		-- 2026.08.10 kimcd [ES20260810] PL450 > PL500 공정 코드 변경. 2026.06.08 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. 공정 Hard Coding에서 PL450 추가
		SELECT @v_dSql += N'				AND    A.ITEM_ID = '''+ @p_model_id +'''                                                                                               ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'			) A                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	ORDER BY DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, ITEM_ID, NICK_NAME, ITEM_TYPE                                                        ' + char(10)

	END

	IF @p_sys_flag = 'INSTANCE_TYPE'	-- find_instanceType
	BEGIN
		
		SELECT @v_dSql += N'	SELECT ISNULL(ATTRIBUTE1,''BUILDING'') AS CONFIRM_AREA   ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)               ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''              ' + char(10)
		SELECT @v_dSql += N'	AND    A.SEGMENT1 = '''+ @p_instance_id +'''             ' + char(10)

	END	

	IF @p_sys_flag = 'LINE_LIST'	-- find_LineList
	BEGIN
		
		SELECT @v_dSql += N'	SELECT DISTINCT 																		' + char(10)	
		SELECT @v_dSql += N'	     A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                 ' + char(10)
		SELECT @v_dSql += N'	   , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE                                        ' + char(10)
		SELECT @v_dSql += N'	   , ISNULL(B.LINE_NAME,''-'') AS LINE_NAME                                             ' + char(10)
		SELECT @v_dSql += N'	   , B.LOCATION                                                                         ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)                                            ' + char(10)
		SELECT @v_dSql += N'	INNER JOIN SCM_LINE_M B WITH(NOLOCK)                                                    ' + char(10)
		SELECT @v_dSql += N'	ON     A.COMPANY_ID     = B.COMPANY_ID                                                  ' + char(10)
		SELECT @v_dSql += N'	AND    A.DIVISION_ID    = B.DIVISION_ID                                                 ' + char(10)
		SELECT @v_dSql += N'	AND    A.SITE_ID        = B.SITE_ID                                                     ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLANT_ID       = B.PLANT_ID                                                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.FACTORY_ID     = B.FACTORY_ID                                                  ' + char(10)
		SELECT @v_dSql += N'	AND    A.OPERATION_ID   = B.OPERATION_ID                                                ' + char(10)
		SELECT @v_dSql += N'	AND    A.LINE_ID        = B.LINE_ID                                                     ' + char(10)
		SELECT @v_dSql += N'	AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE                                              ' + char(10)
		IF @p_confirm_area = 'PLAN GROUP' BEGIN
			SELECT @v_dSql += N'	INNER JOIN                               ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql += N'	LEFT OUTER JOIN                          ' + char(10)
		END
		SELECT @v_dSql += N'	(                                                                                       ' + char(10)
		SELECT @v_dSql += N'	  SELECT A.SEGMENT2 AS PLAN_GROUP_ID                                                    ' + char(10)
		SELECT @v_dSql += N'	  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                            ' + char(10)
		SELECT @v_dSql += N'	  WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''                               ' + char(10)
		SELECT @v_dSql += N'	  AND    A.ACTIVE_FLAG = ''Y''                                                          ' + char(10)
		SELECT @v_dSql += N'	  and    A.SEGMENT1    = '''+ @p_instance_id +'''                                                  ' + char(10)
		SELECT @v_dSql += N'	) C                                                                                     ' + char(10)
		SELECT @v_dSql += N'	ON     B.MODEL_TYPE     = C.PLAN_GROUP_ID                                               ' + char(10)
		SELECT @v_dSql += N'	INNER JOIN (                                                                            ' + char(10)
		SELECT @v_dSql += N'	  SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID                ' + char(10)
		SELECT @v_dSql += N'	  FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK)         ' + char(10)
		SELECT @v_dSql += N'	  WHERE  A.COMPANY_ID   = B.COMPANY_ID                                                  ' + char(10)
		SELECT @v_dSql += N'	  AND    A.DIVISION_ID  = B.DIVISION_ID                                                 ' + char(10)
		SELECT @v_dSql += N'	  AND    A.SITE_ID      = B.SITE_ID                                                     ' + char(10)
		SELECT @v_dSql += N'	  AND    A.OPERATION_ID = B.OPERATION_ID                                                ' + char(10)
		SELECT @v_dSql += N'	  AND    A.INSTANCE_ID  = '''+ @p_instance_id +'''                                                 ' + char(10)
		SELECT @v_dSql += N'	  AND 	 B.DIVISION_ID  = '''+ @p_division_id +'''                                                 ' + char(10)
		SELECT @v_dSql += N'	  AND    B.SITE_ID      = '''+ @p_site_id +'''                                                     ' + char(10)
		SELECT @v_dSql += N'	  AND    A.AMEND_FLAG   = ''Y''                                                         ' + char(10)
		SELECT @v_dSql += N'	  AND    B.ACTIVE_FLAG  = ''Y''                                                         ' + char(10)
		SELECT @v_dSql += N'	) D                                                                                     ' + char(10)
		SELECT @v_dSql += N'	ON     A.COMPANY_ID     = D.COMPANY_ID                                                  ' + char(10)
		SELECT @v_dSql += N'	AND    A.DIVISION_ID    = D.DIVISION_ID                                                 ' + char(10)
		SELECT @v_dSql += N'	AND    A.SITE_ID        = D.SITE_ID                                                     ' + char(10)
		SELECT @v_dSql += N'	AND    A.OPERATION_ID   = D.OPERATION_ID                                                ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.DIVISION_ID    = '''+ @p_division_id +'''                                                 ' + char(10)
		SELECT @v_dSql += N'	AND    A.SITE_ID        = '''+ @p_site_id +'''                                                     ' + char(10)
		--SELECT @v_dSql += N'	AND    A.PLANT_ID       = '''+ @p_plant_id +'''                                                    ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10) 
		SELECT @v_dSql += N'	AND    A.ITEM_ID        = '''+ @p_item_id +'''                                          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'LIKE', @p_line_id)) + char(10)
		SELECT @v_dSql += N'	AND    A.ACTIVE_FLAG    = ''Y''                                                         ' + char(10)
		SELECT @v_dSql += N'	AND    B.ACTIVE_FLAG    = ''Y''                                                         ' + char(10)
		SELECT @v_dSql += N'	AND    A.MONTH          = SUBSTRING(CONVERT(VARCHAR,dbo.SYSDATE1(),112),1,6)            ' + char(10)
		SELECT @v_dSql += N'	AND		 A.PRIORITY NOT IN (''0'',''9'')                                                ' + char(10)
		SELECT @v_dSql += N'	AND    EXISTS (                                                                         ' + char(10)
		SELECT @v_dSql += N'		        	SELECT 1                                                                ' + char(10)
		SELECT @v_dSql += N'		        	FROM   FP_USER_ROLE_INFO_V BB WITH(NOLOCK)                              ' + char(10)
		SELECT @v_dSql += N'		        	WHERE  A.COMPANY_ID     = BB.COMPANY_ID                                 ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.DIVISION_ID    = BB.DIVISION_ID                                ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.SITE_ID        = BB.SITE_ID                                    ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.PLANT_ID       = BB.PLANT_ID                                   ' + char(10)
		SELECT @v_dSql += N'				    AND    A.FACTORY_ID     = BB.FACTORY_ID                                 ' + char(10)
		SELECT @v_dSql += N'				    AND    A.OPERATION_ID   = BB.OPERATION_ID                               ' + char(10)
		SELECT @v_dSql += N'				    AND    A.LINE_ID        = BB.LINE_ID                                    ' + char(10)
		SELECT @v_dSql += N'		        	AND    BB.USER_ID       = '''+ @p_user_id +'''                                     ' + char(10)
		SELECT @v_dSql += N'		        	AND	   BB.SAVE_FLAG	  = ''Y''                                           ' + char(10)
		SELECT @v_dSql += N'			    )                                                                           ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, LINE_NAME, LOCATION                   ' + char(10)

	END	
	
	IF @p_sys_flag = 'DUP'	-- find_dup
	BEGIN
		
		SELECT @v_dSql += N'	SELECT COUNT(*) AS CNT  								' + char(10)	
		SELECT @v_dSql += N'	FROM   FP_AMEND_PLAN_PACK_R A WITH(NOLOCK)              ' + char(10)

		

		SELECT @v_dSql += N'	WHERE  A.INSTANCE_ID     = '''+ @p_instance_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.FP_PLAN_ID      = '''+ @p_plan_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.DIVISION_ID     = '''+ @p_division_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.SITE_ID         = '''+ @p_site_id +'''                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLANT_ID        = '''+ @p_plant_id +'''                   ' + char(10)
		SELECT @v_dSql += N'	AND    A.ITEM_ID         = '''+ @p_item_id +'''                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.TOP_ITEM_ID     = '''+ @p_top_item_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.OPERATION_ID    = '''+ @p_operation_id +'''               ' + char(10)
		SELECT @v_dSql += N'	AND    A.FACTORY_ID      = '''+ @p_factory_id +'''                 ' + char(10)
		SELECT @v_dSql += N'	AND    A.PRODUCTION_TYPE = '''+ @p_prod_type +'''            ' + char(10)
		SELECT @v_dSql += N'	AND    A.MARKET          = '''+ @p_market +'''                     ' + char(10)
		SELECT @v_dSql += N'	AND    A.LINE_ID         = '''+ @p_line_id +'''                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.ELECTRODE_TYPE  = ''-''                          ' + char(10)
		SELECT @v_dSql += N'	AND    CONVERT(VARCHAR, A.PLAN_DATE, 112)    = '''+ @p_date +'''   ' + char(10)
		SELECT @v_dSql += N'	AND	 A.OUT_QTY > 0                                      ' + char(10)

	END	
	
	exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'','TEST','SELECT',@runstart, @runend
	exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@p_prod_type,'SELECT',@runstart, @runend
	IF @p_sys_flag = 'LINE_DUP'	-- find_LineAdd_dup //mppwpp
	BEGIN
		
		SELECT @v_dSql += N'	SELECT COUNT(*) AS CNT  								' + char(10)	
		SELECT @v_dSql += N'	FROM   FP_AMEND_PLAN_PACK_H A WITH(NOLOCK)              ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.INSTANCE_ID     = '''+ @p_instance_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.FP_PLAN_ID      = '''+ @p_plan_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.DIVISION_ID     = '''+ @p_division_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.SITE_ID         = '''+ @p_site_id +'''                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLANT_ID        = '''+ @p_plant_id +'''                   ' + char(10)
		SELECT @v_dSql += N'	AND    A.ITEM_ID         = '''+ @p_item_id +'''                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.TOP_ITEM_ID     = '''+ @p_top_item_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.OPERATION_ID    = '''+ @p_operation_id +'''               ' + char(10)
		SELECT @v_dSql += N'	AND    A.FACTORY_ID      = '''+ @p_factory_id +'''                 ' + char(10)
		SELECT @v_dSql += N'	AND    A.PRODUCTION_TYPE = '''+ @p_prod_type +'''            ' + char(10)
		SELECT @v_dSql += N'	AND    A.MARKET          = '''+ @p_market +'''                     ' + char(10)
		SELECT @v_dSql += N'	AND    A.LINE_ID         = '''+ @p_line_id +'''                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.ELECTRODE_TYPE  = ''-''                          ' + char(10)
		SELECT @v_dSql += N'	AND    CONVERT(VARCHAR, A.PLAN_DATE, 112)    = '''+ @p_date +'''   ' + char(10)
		SELECT @v_dSql += N'	AND	   A.'+ @p_out_qty +' > 0                                      ' + char(10)
		--IF @p_out_qty = 'MPP_OUT_QTY' BEGIN
		--	SELECT @v_dSql += N'	AND	 A.MPP_OUT_QTY > 0                                      ' + char(10)
		--END ELSE BEGIN
		--	SELECT @v_dSql += N'	AND	 A.WPP_OUT_QTY > 0                                      ' + char(10)
		--END

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
