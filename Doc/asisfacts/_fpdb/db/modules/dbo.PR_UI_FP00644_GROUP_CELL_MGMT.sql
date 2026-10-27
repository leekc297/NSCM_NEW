CREATE PROCEDURE [dbo].[PR_UI_FP00644_GROUP_CELL_MGMT]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @in_columns nvarchar(MAX),
  @in_row nvarchar(MAX),
  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP00644_GROUP_CELL_MGMT                                   **/
/** 프로그램 명   : Procedure PR_UI_FP00644_GROUP_CELL_MGMT                         **/
/** 설 명         :           **/
/** Version       : 1.5.0(Auto)                                                               **/
/**                           **/
/** Argument                  **/
/**                           **/
/** [검색 조건]               **/
/**                           **/
/** [Biz Logic]               **/
/**                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**==========================================================================================**/
/** 2023-01-31     CYS      Initial Setting                                                   **/
/** 2023-03-06     CYS      하단 표시 - 상단 Use 'N' 하단 색 표시 및 USE 정보 N으로 표기, New item의 경우는 Use Null 및 색표시               **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00644_GROUP_CELL_MGMT
*/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @STRLEN nvarchar(max)
	DECLARE @runstart datetime
	DECLARE @runend datetime
	DECLARE @v_dSql nvarchar(max)
	DECLARE @v_Err nvarchar(max)
	DECLARE @v_Log nvarchar(max) 
	DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00644_GROUP_CELL_MGMT'
	DECLARE @v_delimiter          NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	
	DECLARE @p_pack_instance_id nvarchar(max) = ''
	DECLARE @p_assy_instance_id nvarchar(max) = ''
	DECLARE @p_form_instance_id nvarchar(max) = ''
	DECLARE @p_is_rel_pack nvarchar(max) = ''
	DECLARE @p_is_rel_form nvarchar(max) = ''
	DECLARE @p_is_rel_assy nvarchar(max) = ''
		
	DECLARE @p_pack_item_id nvarchar(max) = ''
	DECLARE @p_pack_nick_name nvarchar(max) = ''
	DECLARE @p_cell_item_id nvarchar(max) = ''
	DECLARE @p_cell_nick_name nvarchar(max) = ''

	DECLARE @p_bucket_from nvarchar(max) = ''
	DECLARE @p_bucket_to nvarchar(max) = ''
	DECLARE @p_plan_date nvarchar(max) = ''
	DECLARE @p_bucket nvarchar(max) = ''
	DECLARE @p_param nvarchar(max) = ''
	DECLARE @p_queryset1 nvarchar(max) = ''

	DECLARE @INSTANCE_LT nvarchar(max) = ''
	
	DECLARE @PACK_AMEND_TABLE  nvarchar(max) = ''
	DECLARE @PACK_AMEND_SALES_TABLE  nvarchar(max) = ''
	DECLARE @CELL_AMEND_SALES_TABLE  nvarchar(max) = ''
	DECLARE @FORM_AMEND_TABLE  nvarchar(max) = ''
	DECLARE @CELL_AMEND_TABLE  nvarchar(max) = ''

	DECLARE @v_pack_instance_id nvarchar(max)
	DECLARE @v_assy_instance_id nvarchar(max)
	DECLARE @v_bucket_from nvarchar(max)
	DECLARE @v_bucket_to nvarchar(max)
	DECLARE @v_plan_date nvarchar(max)
	DECLARE @v_is_rel_pack nvarchar(max)
	DECLARE @v_pack_item_id nvarchar(max)
	DECLARE @v_pack_nick_name nvarchar(max)
	DECLARE @v_form_instance_id nvarchar(max)
	DECLARE @v_is_rel_form nvarchar(max)
	DECLARE @v_assy_item_id nvarchar(max)
	DECLARE @v_assy_nick_name nvarchar(max)
	DECLARE @v_is_rel_assy nvarchar(max)
	DECLARE @v_user_id nvarchar(max)
	DECLARE @v_bucket nvarchar(max)
	DECLARE @v_param nvarchar(max)
	DECLARE @v_queryset1 nvarchar(max)
	DECLARE @p_basisdate nvarchar(max)
	DECLARE @p_basistime nvarchar(max)

	--DECLARE BASE PARAMETER START END



	DECLARE @p__save_auth	NVARCHAR(MAX);
	DECLARE @p__non_auth	NVARCHAR(MAX);

	-- filter

	DECLARE @p_instance_id	NVARCHAR(MAX);
	DECLARE @p_master_id	NVARCHAR(MAX);
	--DECLARE @p_plan_date	NVARCHAR(MAX);
	DECLARE @p_plan_id		NVARCHAR(MAX);
	--DECLARE @p_bucket_from	NVARCHAR(MAX);
	--DECLARE @p_bucket_to	NVARCHAR(MAX);
	DECLARE @p_division_id	NVARCHAR(MAX);
	DECLARE @p_site_id		NVARCHAR(MAX);
	DECLARE @p_plant_id		NVARCHAR(MAX);
	DECLARE @p_new_item		NVARCHAR(MAX);

	DECLARE @p_cell_id		NVARCHAR(MAX);
	DECLARE @p_cell_name	NVARCHAR(MAX);
	DECLARE @p_group_cell_id	NVARCHAR(MAX);
	DECLARE @p_group_cell_name	NVARCHAR(MAX);
	DECLARE @p_model_id		NVARCHAR(MAX);

	
	DECLARE @p_sub_company_id	NVARCHAR(MAX);
	DECLARE @p_sub_division_id	NVARCHAR(MAX);
	DECLARE @p_sub_site_id		NVARCHAR(MAX);
	DECLARE @p_sub_plant_id		NVARCHAR(MAX);
	DECLARE @p_sub_group_cell_id NVARCHAR(MAX);



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
		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =				@tmp_value

		END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
			SET @p_division_id =		@tmp_value
		END ELSE IF @tmp_column = 'SITE_ID' BEGIN
			SET @p_site_id =			@tmp_value
		END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
			SET @p_plant_id =			@tmp_value
		END ELSE IF @tmp_column = 'NEW_ITEM' BEGIN
			SET @p_new_item =			@tmp_value

		END ELSE IF @tmp_column = 'CELL_ID' BEGIN
			SET @p_cell_id =			@tmp_value
		END ELSE IF @tmp_column = 'CELL_NAME' BEGIN
			SET @p_cell_name =			@tmp_value
		END ELSE IF @tmp_column = 'GROUP_CELL_ID' BEGIN
			SET @p_group_cell_id =			@tmp_value
		END ELSE IF @tmp_column = 'GROUP_CELL_NAME' BEGIN
			SET @p_group_cell_name =			@tmp_value
		END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
			SET @p_model_id =			@tmp_value
		
		END ELSE IF @tmp_column = 'SUB_COMPANY_ID' BEGIN
			SET @p_sub_company_id =		@tmp_value
		END ELSE IF @tmp_column = 'SUB_DIVISION_ID' BEGIN
			SET @p_sub_division_id =		@tmp_value
		END ELSE IF @tmp_column = 'SUB_SITE_ID' BEGIN
			SET @p_sub_site_id =			@tmp_value
		END ELSE IF @tmp_column = 'SUB_PLANT_ID' BEGIN
			SET @p_sub_plant_id =		@tmp_value
		END ELSE IF @tmp_column = 'SUB_GROUP_CELL_ID' BEGIN
			SET @p_sub_group_cell_id =			@tmp_value

		END

	END
	/*	Parameter Setting End */

--	DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += 'P_SYS_TYPE:' +ISNULL(@P_SYS_TYPE,'') +CHAR(10)
--SET @PARAMS += 'P_SYS_FLAG:' +ISNULL(@P_SYS_FLAG,'') +CHAR(10)
--SET @PARAMS += 'P_SYS_GUBUN:' +ISNULL(@P_SYS_GUBUN,'') +CHAR(10)
--SET @PARAMS += 'P_USER_ID:' +ISNULL(@P_USER_ID,'') +CHAR(10)
--SET @PARAMS += 'IN_COLUMNS:' +ISNULL(@IN_COLUMNS,'') +CHAR(10)
--SET @PARAMS += 'IN_ROW:' +ISNULL(@IN_ROW,'') +CHAR(10)
--SET @PARAMS += 'OPT_NONE:' +ISNULL(@OPT_NONE,'') +CHAR(10)
--SELECT @PARAMS AS SQL
--RETURN

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
	--SET @max_week_loop_cnt	= [dbo].[SCM_ARR_SPL_CNT](@p_week_info	, @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
	--SET @max_month_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
	--SET @max_category_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단

	--Optional Parameter Part END

	
	SET	@v_dSql = ''
	
	BEGIN
		
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#T_SCP_TARGET_MODEL'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #T_SCP_TARGET_MODEL ' + char(10)
		SELECT @v_dSql += N'	;				' + char(10)

		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#T_TARGET_CELL_GROUP'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #T_TARGET_CELL_GROUP ' + char(10)
		SELECT @v_dSql += N'	;				' + char(10)

		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#T_PRODUCT_RESULT_CELL'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #T_PRODUCT_RESULT_CELL ' + char(10)
		SELECT @v_dSql += N'	;				' + char(10)
		
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#T_BASIS_MODEL_GROUP_CELL'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #T_BASIS_MODEL_GROUP_CELL ' + char(10)
		SELECT @v_dSql += N'	;				' + char(10)

	END

	IF @p_sys_flag IN ('SUB_ALL', 'MAIN')  BEGIN
	
		SELECT @v_dSql +=	'	SELECT 	COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID,ITEM_ID AS MODEL_ID																				' + char(10)
		SELECT @v_dSql +=	'	INTO	#T_SCP_TARGET_MODEL																				' + char(10)
		SELECT @v_dSql +=	'	FROM	(																																			' + char(10)
		SELECT @v_dSql +=	'				SELECT 	COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SCP_PLAN_ID , ITEM_ID, MFG_WEEK														' + char(10)
		SELECT @v_dSql +=	'						, RANK() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, MFG_WEEK ORDER BY SCP_PLAN_ID DESC) AS RNK     ' + char(10)          
		SELECT @v_dSql +=	'				FROM 	FP_WEEKLY_DEMAND_PRODUCT_H	A WITH(NOLOCK)                                                                                        ' + char(10)                    
		SELECT @v_dSql +=	'				WHERE 	1=1	  																															' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))       + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))       + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)
		SELECT @v_dSql +=	'				AND 	SHOP_GROUP_ID = ''P''     																										' + char(10)
		SELECT @v_dSql +=	'				AND 	SCP_PLAN_ID >= (																												' + char(10)
		SELECT @v_dSql +=	'											SELECT MIN(SCP_PLAN_ID) AS SCP_PLAN_ID																		' + char(10)
		SELECT @v_dSql +=	'											FROM SCM_SCP_PLAN_H WITH(NOLOCK)																			' + char(10)
		SELECT @v_dSql +=	'											WHERE 1=1																									' + char(10)
		SELECT @v_dSql +=	'											AND SCP_PLAN_TYPE = ''PRODUCT''																				' + char(10)
		SELECT @v_dSql +=	'											AND PLAN_START_TIME >= DATEADD(YEAR, -1, GETDATE())															' + char(10)
		SELECT @v_dSql +=	'										)																												' + char(10)
		SELECT @v_dSql +=	'				AND 	PRODUCTION_TYPE IN (''MASS'',''D-SAMPLE'')    																					' + char(10)
		SELECT @v_dSql +=	'			) A																																			' + char(10)
		SELECT @v_dSql +=	'	WHERE	1=1																																			' + char(10)
		SELECT @v_dSql +=	'	AND		RNK = 1																																		' + char(10)
		SELECT @v_dSql +=	'	GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID																						' + char(10)
		SELECT @v_dSql +=	'	;																' + char(10)
	
	END ELSE IF @p_sys_flag = 'SUB' BEGIN
	
		--SELECT @v_dSql +=	'	SELECT 	'''+ @p_sub_company_id +''' AS COMPANY_ID , '''+ @p_sub_division_id +''' AS DIVISION_ID, '''+ @p_sub_site_id +''' AS SITE_ID, '''+ @p_sub_plant_id +''' AS PLANT_ID, '''+ @p_sub_group_cell_id +''' AS MODEL_ID																				' + char(10)
		--SELECT @v_dSql +=	'	INTO	#T_SCP_TARGET_MODEL																				' + char(10)
		--SELECT @v_dSql +=	'	;																' + char(10)

		SELECT @v_dSql +=	'	SELECT 	COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID,ITEM_ID AS MODEL_ID																				' + char(10)
		SELECT @v_dSql +=	'	INTO	#T_SCP_TARGET_MODEL																				' + char(10)
		SELECT @v_dSql +=	'	FROM	(																																			' + char(10)
		SELECT @v_dSql +=	'				SELECT 	COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SCP_PLAN_ID , ITEM_ID, MFG_WEEK														' + char(10)
		SELECT @v_dSql +=	'						, RANK() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, MFG_WEEK ORDER BY SCP_PLAN_ID DESC) AS RNK     ' + char(10)          
		SELECT @v_dSql +=	'				FROM 	FP_WEEKLY_DEMAND_PRODUCT_H	A WITH(NOLOCK)                                                                                        ' + char(10)                    
		SELECT @v_dSql +=	'				WHERE 	1=1	  																															' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))       + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))       + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)
		SELECT @v_dSql +=	'				AND 	SHOP_GROUP_ID = ''P''     																										' + char(10)
		SELECT @v_dSql +=	'				AND 	SCP_PLAN_ID >= (																												' + char(10)
		SELECT @v_dSql +=	'											SELECT MIN(SCP_PLAN_ID) AS SCP_PLAN_ID																		' + char(10)
		SELECT @v_dSql +=	'											FROM SCM_SCP_PLAN_H WITH(NOLOCK)																			' + char(10)
		SELECT @v_dSql +=	'											WHERE 1=1																									' + char(10)
		SELECT @v_dSql +=	'											AND SCP_PLAN_TYPE = ''PRODUCT''																				' + char(10)
		SELECT @v_dSql +=	'											AND PLAN_START_TIME >= DATEADD(YEAR, -1, GETDATE())															' + char(10)
		SELECT @v_dSql +=	'										)																												' + char(10)
		SELECT @v_dSql +=	'				AND 	PRODUCTION_TYPE IN (''MASS'',''D-SAMPLE'')    																					' + char(10)
		SELECT @v_dSql +=	'			) A																																			' + char(10)
		SELECT @v_dSql +=	'	WHERE	1=1																																			' + char(10)
		SELECT @v_dSql +=	'	AND		RNK = 1																																		' + char(10)
		SELECT @v_dSql +=	'	GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID																						' + char(10)
		SELECT @v_dSql +=	'	;																' + char(10)

	END
	

	IF @p_sys_flag = 'MAIN' BEGIN
			
			SELECT @v_dSql +=	'	SELECT 	A.COMPANY_ID								' + char(10)                                                                                                                      
			SELECT @v_dSql +=	'			, A.DIVISION_ID                             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, A.SITE_ID                                 ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, A.PLANT_ID                                ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, A.PARENT_ITEM_ID AS MODEL_ID              ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, A.CHILD_ITEM_ID AS MODULE_ID              ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, C.NICK_NAME AS MODULE_NAME              ' + char(10)
			SELECT @v_dSql +=	'			, A.ALT_ID AS MODULE_ALT_ID                 ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, A.ALT_PRIORITY AS MODULE_ALT_PRIORITY     ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, E.CHILD_ITEM_ID AS CELL_ID                ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, E.ALT_ID AS CELL_ALT_ID                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, E.ALT_PRIORITY AS CELL_ALT_PRIORITY       ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, F.DOE AS BASIS_CELL_ID                    ' + char(10) 
			SELECT @v_dSql +=	'			, F.NICK_NAME AS CELL_NAME                ' + char(10)  
			SELECT @v_dSql +=	'	INTO	#T_TARGET_CELL_GROUP				' + char(10)
			SELECT @v_dSql +=	'	FROM 	SCM_BOM_M A	WITH(NOLOCK),	                ' + char(10)                                                                                                          
			SELECT @v_dSql +=	'			#T_SCP_TARGET_MODEL B	WITH(NOLOCK),       ' + char(10)                                                                                                                
			SELECT @v_dSql +=	'			SCM_ITEM_M C	WITH(NOLOCK),               ' + char(10)                                                                                                              
			SELECT @v_dSql +=	'			SCM_ITEM_CLASS_M D	WITH(NOLOCK),           ' + char(10)                                                                                                            
			SELECT @v_dSql +=	'			SCM_BOM_M E	WITH(NOLOCK),                   ' + char(10)                                                                                                           
			SELECT @v_dSql +=	'			SCM_ITEM_M F	WITH(NOLOCK),               ' + char(10)                                                                                                              
			SELECT @v_dSql +=	'			SCM_ITEM_CLASS_M G	WITH(NOLOCK)            ' + char(10)                                                                                                            
			SELECT @v_dSql +=	'	WHERE 	1=1											' + char(10)
			SELECT @v_dSql +=	'	AND 		A.ACTIVE_FLAG = ''Y''   				' + char(10)
			SELECT @v_dSql +=	'	AND 		A.EFF_END_DATE >= GETDATE()             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.COMPANY_ID = B.COMPANY_ID             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.DIVISION_ID = B.DIVISION_ID           ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.SITE_ID = B.SITE_ID                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.PLANT_ID = B.PLANT_ID                 ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.PARENT_ITEM_ID = B.MODEL_ID           ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.COMPANY_ID = C.COMPANY_ID             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.DIVISION_ID = C.DIVISION_ID           ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.SITE_ID = C.SITE_ID                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.CHILD_ITEM_ID = C.ITEM_ID             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		C.ACTIVE_FLAG = ''Y''                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		C.ITEM_CLASS = D.CLASS_ID               ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		D.LEVEL_3_NAME LIKE ''%Module%'' 		' + char(10)
			SELECT @v_dSql +=	'	AND 		E.ACTIVE_FLAG = ''Y''     				' + char(10)
			SELECT @v_dSql +=	'	AND 		E.EFF_END_DATE >= GETDATE()             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.COMPANY_ID = E.COMPANY_ID             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.DIVISION_ID = E.DIVISION_ID           ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.SITE_ID = E.SITE_ID                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.PLANT_ID = E.PLANT_ID                 ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.CHILD_ITEM_ID = E.PARENT_ITEM_ID      ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		E.COMPANY_ID = F.COMPANY_ID             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		E.DIVISION_ID = F.DIVISION_ID           ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		E.SITE_ID = F.SITE_ID                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		E.CHILD_ITEM_ID = F.ITEM_ID             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		F.ACTIVE_FLAG = ''Y''                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		F.ITEM_CLASS = G.CLASS_ID               ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		G.LEVEL_3_NAME = ''Cell''    			' + char(10)
			SELECT @v_dSql +=	'	;																' + char(10)+ char(10)

			-- cell assy item 기준으로 검색하여 cell product item 을 검색한다.
			SELECT @v_dSql +=	'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.CELL_PRODUCT_ITEM_ID AS ITEM_ID ' + char(10)
			SELECT @v_dSql +=	'INTO	#T_PRODUCT_RESULT_CELL ' + char(10)
			SELECT @v_dSql +=	'FROM ( ' + char(10)
			SELECT @v_dSql +=	'	SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql +=	'	FROM 	SCM_DAILY_PRODUCT_RESULT_H A	WITH(NOLOCK), ' + char(10)
			SELECT @v_dSql +=	'			SCM_ITEM_M B	WITH(NOLOCK), ' + char(10)
			SELECT @v_dSql +=	'			SCM_ITEM_CLASS_M C	WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql +=	'	WHERE 	1=1 ' + char(10)
			SELECT @v_dSql +=	'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))       + char(10)
			SELECT @v_dSql +=	'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))       + char(10)
			SELECT @v_dSql +=	'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)
			SELECT @v_dSql +=	'	AND 	A.PLAN_DATE >= DATEADD(YEAR, -1, GETDATE()) ' + char(10)
			SELECT @v_dSql +=	'	AND 	A.COMPANY_ID = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql +=	'	AND 	A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql +=	'	AND 	A.SITE_ID = B.SITE_ID ' + char(10)
			SELECT @v_dSql +=	'	AND 	A.ITEM_ID = B.ITEM_ID ' + char(10)
			SELECT @v_dSql +=	'	AND 	B.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql +=	'	AND 	B.ITEM_CLASS = C.CLASS_ID ' + char(10)
			SELECT @v_dSql +=	'	AND 	C.LEVEL_3_NAME = ''Cell Assembly'' ' + char(10)
			SELECT @v_dSql +=	'	AND 	A.PRODUCTION_TYPE IN (''MASS'',''D-SAMPLE'') ' + char(10)
			SELECT @v_dSql +=	'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql +=	') A ' + char(10)
			SELECT @v_dSql +=	'INNER JOIN FP_CELL_ASSY_PRODUCT_MAP_V B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql +=	'ON  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql +=	'AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql +=	'AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql +=	'AND A.ITEM_ID     = B.CELL_ASSY_ITEM_ID ' + char(10)
			SELECT @v_dSql +=	'; ' + char(10)+ char(10)
			/*
			SELECT @v_dSql +=	'		SELECT 	DISTINCT A.COMPANY_ID 	                                             ' + char(10)
			SELECT @v_dSql +=	'				, A.DIVISION_ID                                                          ' + char(10)
			SELECT @v_dSql +=	'				, A.SITE_ID                                                              ' + char(10)
			SELECT @v_dSql +=	'				, A.PLANT_ID                                                             ' + char(10)
			SELECT @v_dSql +=	'				, A.ITEM_ID                                                              ' + char(10)
			SELECT @v_dSql +=	'				, B.APPLIED_MODEL                                                        ' + char(10)
			SELECT @v_dSql +=	'		INTO	#T_PRODUCT_RESULT_CELL			' + char(10)
			SELECT @v_dSql +=	'		FROM 	SCM_DAILY_PRODUCT_RESULT_H A	WITH(NOLOCK),	                                         ' + char(10)
			SELECT @v_dSql +=	'				SCM_ITEM_M B	WITH(NOLOCK),                                                            ' + char(10)
			SELECT @v_dSql +=	'				SCM_ITEM_CLASS_M C	WITH(NOLOCK)                                                       ' + char(10)
			SELECT @v_dSql +=	'		WHERE 	1=1	                                                                 ' + char(10)
			--SELECT @v_dSql +=	'		WHERE 	1=0	                                                                 ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))       + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))       + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)

			SELECT @v_dSql +=	'		AND 	A.PLAN_DATE >= DATEADD(YEAR, -1, GETDATE())            ' + char(10)
			SELECT @v_dSql +=	'		AND 	A.COMPANY_ID = B.COMPANY_ID                                          ' + char(10)
			SELECT @v_dSql +=	'		AND 	A.DIVISION_ID = B.DIVISION_ID                                        ' + char(10)
			SELECT @v_dSql +=	'		AND 	A.SITE_ID = B.SITE_ID                                                ' + char(10)
			SELECT @v_dSql +=	'		AND 	A.ITEM_ID = B.ITEM_ID                                                ' + char(10)
			SELECT @v_dSql +=	'		AND 	B.ACTIVE_FLAG = ''Y''                                                ' + char(10)
			SELECT @v_dSql +=	'		AND 	B.ITEM_CLASS = C.CLASS_ID                                            ' + char(10)
			SELECT @v_dSql +=	'		AND 	C.LEVEL_3_NAME = ''Cell''                                            ' + char(10)
			SELECT @v_dSql +=	'		AND 	A.PRODUCTION_TYPE IN (''MASS'',''D-SAMPLE'')                         ' + char(10)
			SELECT @v_dSql +=	'	;																' + char(10)
			*/
			SELECT @v_dSql +=	'		WITH CELL_LIST AS		                                                                                                                            ' + char(10)
			SELECT @v_dSql +=	'		(		                                                                                                                                          ' + char(10)
			SELECT @v_dSql +=	'		SELECT 	DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID 	                                                                        ' + char(10)
			SELECT @v_dSql +=	'				, A.ITEM_ID AS CELL_ID                                                                                                                    ' + char(10)
			SELECT @v_dSql +=	'				, ''RESULT'' AS CATEGORY_ID                                                                                                               ' + char(10)
			SELECT @v_dSql +=	'				, CASE WHEN B.MODEL_ID LIKE ''%MEB%'' THEN ''MEB'' ELSE ''NORMAL'' END AS MEB_FLAG                                                        ' + char(10)
			SELECT @v_dSql +=	'				, RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ORDER BY CASE WHEN B.MODEL_ID LIKE ''%MEB%'' THEN 1 ELSE 2 END) AS RNK	' + char(10)
			SELECT @v_dSql +=	'		FROM 	#T_PRODUCT_RESULT_CELL A	                                                                                                                  ' + char(10)
			SELECT @v_dSql +=	'			LEFT OUTER JOIN #T_TARGET_CELL_GROUP B	 	WITH(NOLOCK)                                                                                                       ' + char(10)
			SELECT @v_dSql +=	'			ON 	1=1                                                                                                                                     ' + char(10)
			SELECT @v_dSql +=	'			AND 	A.COMPANY_ID = B.COMPANY_ID                                                                                                           ' + char(10)
			SELECT @v_dSql +=	'			AND 	A.DIVISION_ID = B.DIVISION_ID                                                                                                         ' + char(10)
			SELECT @v_dSql +=	'			AND 	A.SITE_ID = B.SITE_ID                                                                                                                 ' + char(10)
			SELECT @v_dSql +=	'			AND 	A.PLANT_ID = B.PLANT_ID                                                                                                               ' + char(10)
			SELECT @v_dSql +=	'			AND 	A.ITEM_ID  = B.CELL_ID                                                                                                                ' + char(10)
			SELECT @v_dSql +=	'		WHERE 	1=1	                                                                                                                                  ' + char(10)
			SELECT @v_dSql +=	'		UNION ALL		                                                                                                                                  ' + char(10)
			SELECT @v_dSql +=	'		SELECT 	DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID 	                                                                        ' + char(10)
			SELECT @v_dSql +=	'				, A.CELL_ID                                                                                                                               ' + char(10)
			SELECT @v_dSql +=	'				, ''TARGET'' AS CATEGORY_ID                                                                                                               ' + char(10)
			SELECT @v_dSql +=	'				, CASE WHEN A.MODEL_ID LIKE ''%MEB%'' THEN ''MEB'' ELSE ''NORMAL'' END AS MEB_FLAG                                                        ' + char(10)
			SELECT @v_dSql +=	'				, RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_ID ORDER BY CASE WHEN A.MODEL_ID LIKE ''%MEB%'' THEN 1 ELSE 2 END) AS RNK	' + char(10)
			SELECT @v_dSql +=	'		FROM 	#T_TARGET_CELL_GROUP A	                                                                                                                    ' + char(10)
			SELECT @v_dSql +=	'		WHERE 	1=1	                                                                                                                                  ' + char(10)
			SELECT @v_dSql +=	'		)		                                                                                                                                          ' + char(10)
			SELECT @v_dSql +=	'	SELECT 	  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID	 ' + char(10)
			--SELECT @v_dSql +=	'			, A.GROUP_CELL_ID, B.NICK_NAME AS GROUP_CELL_NAME        ' + char(10)                                                                  	
			SELECT @v_dSql +=	'			, CASE WHEN A.NEW_ITEM_FLAG = ''Y'' THEN NULL ELSE A.GROUP_CELL_ID END AS GROUP_CELL_ID	       ' + char(10)                                                                  	
			SELECT @v_dSql +=	'			, CASE WHEN A.NEW_ITEM_FLAG = ''Y'' THEN NULL ELSE B.NICK_NAME END AS GROUP_CELL_NAME	     ' + char(10)
			SELECT @v_dSql +=	'			, A.BASIS_CODE											 ' + char(10)
			SELECT @v_dSql +=	'			, A.USE_FLAG											 ' + char(10)
			SELECT @v_dSql +=	'			, A.CELL_ID, A.CELL_NAME								 ' + char(10)
			SELECT @v_dSql +=	'			, C.CELL_ASSY_ITEM_ID ' + char(10) -- cell assy item 추가... 20230705
			SELECT @v_dSql +=	'			, A.NEW_ITEM_FLAG										 ' + char(10)
			SELECT @v_dSql +=	'			, A.DESCRIPTION											 ' + char(10)
			SELECT @v_dSql +=	'			, A.UPDATE_ID, A.UPDATE_TIME							 ' + char(10)
			SELECT @v_dSql +=	'			, A.EDIT_YN												 ' + char(10)
			SELECT @v_dSql +=	'	FROM	(														 ' + char(10)
			SELECT @v_dSql +=	'				SELECT 	DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID		                                                                          ' + char(10)
			SELECT @v_dSql +=	'						, CASE WHEN A.MEB_FLAG LIKE ''MEB'' THEN ISNULL(D.GROUP_CELL_ID,A.CELL_ID) ELSE ISNULL(D.GROUP_CELL_ID, C.DOE) END AS GROUP_CELL_ID	        ' + char(10)
			SELECT @v_dSql +=	'						, C.DOE AS BASIS_CODE	                                                                                                                      ' + char(10)
			SELECT @v_dSql +=	'						, CASE WHEN D.ITEM_ID IS NULL THEN '''' ELSE ISNULL(D.USE_FLAG,''N'') END AS USE_FLAG	                                                                                                    ' + char(10)
			SELECT @v_dSql +=	'						, A.CELL_ID	                                                                                                                                ' + char(10)
			SELECT @v_dSql +=	'						, C.NICK_NAME AS CELL_NAME	                                                                                                                              ' + char(10)
			SELECT @v_dSql +=	'						, CASE WHEN D.ITEM_ID IS NULL THEN ''Y'' ELSE ''N'' END AS NEW_ITEM_FLAG	                                                                  ' + char(10)
			SELECT @v_dSql +=	'						, D.DESCRIPTION	                                                                                                                            ' + char(10)
			SELECT @v_dSql +=	'						, D.UPDATE_ID	                                                                                                                              ' + char(10)
			SELECT @v_dSql +=	'						, D.UPDATE_TIME 	                                                                                                                          ' + char(10)
			SELECT @v_dSql +=	'						, (CASE WHEN R.PLANT_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN 	                                                                                                                          ' + char(10)
			SELECT @v_dSql +=	'				FROM 	CELL_LIST A		                                                                                                                            ' + char(10)
			SELECT @v_dSql +=	'						LEFT OUTER JOIN (                                                                                                                           ' + char(10)
			SELECT @v_dSql +=	'								SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID         ' + char(10)
			SELECT @v_dSql +=	'								FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                     ' + char(10)
			SELECT @v_dSql +=	'								WHERE  R.USER_ID   = '''+ @p_user_id +'''                                                ' + char(10)
			SELECT @v_dSql +=	'								AND    R.SAVE_FLAG = ''Y''                                                    ' + char(10)
			SELECT @v_dSql +=	'						) R                                                                              ' + char(10)
			SELECT @v_dSql +=	'						ON   A.COMPANY_ID   = R.COMPANY_ID                                               ' + char(10)
			SELECT @v_dSql +=	'						AND  A.DIVISION_ID  = R.DIVISION_ID                                                                                ' + char(10)
			SELECT @v_dSql +=	'						AND  A.SITE_ID      = R.SITE_ID                                                                                    ' + char(10)
			SELECT @v_dSql +=	'						AND  A.PLANT_ID     = R.PLANT_ID                                                                                    ' + char(10)
			SELECT @v_dSql +=	'						LEFT OUTER JOIN SCM_GROUP_CELL_M D WITH(NOLOCK)                                                                                                        ' + char(10)
			SELECT @v_dSql +=	'						ON 	1=1                                                                                                                                     ' + char(10)
			SELECT @v_dSql +=	'						AND 	A.COMPANY_ID = D.COMPANY_ID                                                                                                           ' + char(10)
			SELECT @v_dSql +=	'						AND 	A.DIVISION_ID = D.DIVISION_ID                                                                                                         ' + char(10)
			SELECT @v_dSql +=	'						AND 	A.SITE_ID = D.SITE_ID                                                                                                                 ' + char(10)
			SELECT @v_dSql +=	'						AND 	A.CELL_ID = D.ITEM_ID,                                                                                                                ' + char(10)
			SELECT @v_dSql +=	'						SCM_ITEM_M C WITH(NOLOCK)	                                                                                                                              ' + char(10)
			SELECT @v_dSql +=	'				WHERE 	1=1		                                                                                                                                  ' + char(10)
			
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))       + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))       + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)
			
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ID' , 'LIKE', @p_cell_id))       + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_cell_name))       + char(10)

			SELECT @v_dSql +=	'				AND 		A.RNK = 1	                                                                                                                              ' + char(10)
			SELECT @v_dSql +=	'				AND 		C.ACTIVE_FLAG = ''Y''	                                                                                                                  ' + char(10)
			SELECT @v_dSql +=	'				AND 		A.COMPANY_ID = C.COMPANY_ID	                                                                                                            ' + char(10)
			SELECT @v_dSql +=	'				AND 		A.DIVISION_ID = C.DIVISION_ID	                                                                                                          ' + char(10)
			SELECT @v_dSql +=	'				AND 		A.SITE_ID = C.SITE_ID	                                                                                                                  ' + char(10)
			SELECT @v_dSql +=	'				AND 		A.CELL_ID = C.ITEM_ID	                                                                                                                  ' + char(10)
			SELECT @v_dSql +=	'			) A										' + char(10)
			SELECT @v_dSql +=	'			LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)	' + char(10)
			SELECT @v_dSql +=	'			ON 1=1									' + char(10)
			SELECT @v_dSql +=	'			AND B.ACTIVE_FLAG = ''Y''	                ' + char(10)                                                                                                  
			SELECT @v_dSql +=	'			AND A.COMPANY_ID = B.COMPANY_ID	        ' + char(10)                                                                                                    
			SELECT @v_dSql +=	'			AND A.DIVISION_ID = B.DIVISION_ID	    ' + char(10)                                                                                                      
			SELECT @v_dSql +=	'			AND A.SITE_ID = B.SITE_ID	            ' + char(10)                                                                                                      
			SELECT @v_dSql +=	'			AND A.GROUP_CELL_ID = B.ITEM_ID	            ' + char(10)                                                                                                      
			-- cell assy item 추가... 20230705
			SELECT @v_dSql +=	'	LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql +=	'	ON  1=1 ' + char(10)
			SELECT @v_dSql +=	'	AND A.COMPANY_ID    = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql +=	'	AND A.DIVISION_ID   = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql +=	'	AND A.SITE_ID       = C.SITE_ID ' + char(10)
			SELECT @v_dSql +=	'	AND A.CELL_ID       = C.CELL_PRODUCT_ITEM_ID ' + char(10)
			SELECT @v_dSql +=	'	WHERE	1=1										' + char(10)
			
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NEW_ITEM_FLAG' , 'EQ', @p_new_item))       + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ID' , 'LIKE', @p_group_cell_id))       + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_group_cell_name))       + char(10)
			--SELECT @v_dSql +=	'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_ID, C.DOE, A.MEB_FLAG, D.GROUP_CELL_ID, D.USE_FLAG, D.DESCRIPTION			      ' + char(10)
			--SELECT @v_dSql +=	'			, D.UPDATE_ID, D.UPDATE_TIME, D.ITEM_ID, C.NICK_NAME                                                                                        ' + char(10)
			SELECT @v_dSql +=	'	ORDER BY SITE_ID, PLANT_ID, NEW_ITEM_FLAG DESC, GROUP_CELL_ID, BASIS_CODE, CELL_ID                                                                                         ' + char(10)
	
	END	ELSE IF @p_sys_flag = 'SUB' BEGIN

					
			SELECT @v_dSql +=	'	SELECT 	A.COMPANY_ID								' + char(10)                                                                                                                      
			SELECT @v_dSql +=	'			, A.DIVISION_ID                             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, A.SITE_ID                                 ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, A.PLANT_ID                                ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, A.PARENT_ITEM_ID AS MODEL_ID              ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, A.CHILD_ITEM_ID AS MODULE_ID              ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, C.NICK_NAME AS MODULE_NAME              ' + char(10)
			SELECT @v_dSql +=	'			, A.ALT_ID AS MODULE_ALT_ID                 ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, A.ALT_PRIORITY AS MODULE_ALT_PRIORITY     ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, E.CHILD_ITEM_ID AS CELL_ID                ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, E.ALT_ID AS CELL_ALT_ID                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, E.ALT_PRIORITY AS CELL_ALT_PRIORITY       ' + char(10)                                                                                              
			SELECT @v_dSql +=	'			, F.DOE AS BASIS_CELL_ID                    ' + char(10) 
			SELECT @v_dSql +=	'			, F.NICK_NAME AS CELL_NAME                ' + char(10)  
			SELECT @v_dSql +=	'			, CASE WHEN H.GROUP_CELL_ID IS NULL AND A.PARENT_ITEM_ID LIKE ''%MEB%'' THEN E.CHILD_ITEM_ID 	                                  ' + char(10)
			SELECT @v_dSql +=	'					WHEN H.GROUP_CELL_ID IS NULL AND A.PARENT_ITEM_ID NOT LIKE ''%MEB%'' THEN F.DOE                                             ' + char(10)
			SELECT @v_dSql +=	'					ELSE H.GROUP_CELL_ID END AS GROUP_CELL_ID                                                                                   ' + char(10)
			SELECT @v_dSql +=	'			,  ISNULL(H.USE_FLAG, NULL) AS GROUP_USE_FLAG                                                                                 ' + char(10)
			SELECT @v_dSql +=	'	INTO	#T_BASIS_MODEL_GROUP_CELL				' + char(10)
			SELECT @v_dSql +=	'	FROM 	SCM_BOM_M A	WITH(NOLOCK),	                ' + char(10)                                                                                                          
			SELECT @v_dSql +=	'			#T_SCP_TARGET_MODEL B	WITH(NOLOCK),       ' + char(10)                                                                                                                
			SELECT @v_dSql +=	'			SCM_ITEM_M C	WITH(NOLOCK),               ' + char(10)                                                                                                              
			SELECT @v_dSql +=	'			SCM_ITEM_CLASS_M D	WITH(NOLOCK),           ' + char(10)                                                                                                            
			SELECT @v_dSql +=	'			SCM_BOM_M E	WITH(NOLOCK),                   ' + char(10)                                                                                                           
			SELECT @v_dSql +=	'			SCM_ITEM_M F	WITH(NOLOCK)               ' + char(10)  
			SELECT @v_dSql +=	'			LEFT OUTER JOIN SCM_GROUP_CELL_M H WITH(NOLOCK)	 ' + char(10)
			SELECT @v_dSql +=	'			ON 	1=1                                          ' + char(10)
			SELECT @v_dSql +=	'			AND 	F.COMPANY_ID = H.COMPANY_ID                ' + char(10)
			SELECT @v_dSql +=	'			AND 	F.DIVISION_ID = H.DIVISION_ID              ' + char(10)
			SELECT @v_dSql +=	'			AND 	F.SITE_ID = H.SITE_ID                      ' + char(10)
			SELECT @v_dSql +=	'			AND 	F.ITEM_ID = H.ITEM_ID,                     ' + char(10)
			SELECT @v_dSql +=	'			SCM_ITEM_CLASS_M G	WITH(NOLOCK)            ' + char(10)                                                                                                            
			SELECT @v_dSql +=	'	WHERE 	1=1											' + char(10)
			SELECT @v_dSql +=	'	AND 		A.ACTIVE_FLAG = ''Y''   				' + char(10)
			SELECT @v_dSql +=	'	AND 		A.EFF_END_DATE >= GETDATE()             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.COMPANY_ID = B.COMPANY_ID             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.DIVISION_ID = B.DIVISION_ID           ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.SITE_ID = B.SITE_ID                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.PLANT_ID = B.PLANT_ID                 ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.PARENT_ITEM_ID = B.MODEL_ID           ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.COMPANY_ID = C.COMPANY_ID             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.DIVISION_ID = C.DIVISION_ID           ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.SITE_ID = C.SITE_ID                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.CHILD_ITEM_ID = C.ITEM_ID             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		C.ACTIVE_FLAG = ''Y''                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		C.ITEM_CLASS = D.CLASS_ID               ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		D.LEVEL_3_NAME LIKE ''%Module%'' 		' + char(10)
			SELECT @v_dSql +=	'	AND 		E.ACTIVE_FLAG = ''Y''     				' + char(10)
			SELECT @v_dSql +=	'	AND 		E.EFF_END_DATE >= GETDATE()             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.COMPANY_ID = E.COMPANY_ID             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.DIVISION_ID = E.DIVISION_ID           ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.SITE_ID = E.SITE_ID                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.PLANT_ID = E.PLANT_ID                 ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		A.CHILD_ITEM_ID = E.PARENT_ITEM_ID      ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		E.COMPANY_ID = F.COMPANY_ID             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		E.DIVISION_ID = F.DIVISION_ID           ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		E.SITE_ID = F.SITE_ID                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		E.CHILD_ITEM_ID = F.ITEM_ID             ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		F.ACTIVE_FLAG = ''Y''                   ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		F.ITEM_CLASS = G.CLASS_ID               ' + char(10)                                                                                              
			SELECT @v_dSql +=	'	AND 		G.LEVEL_3_NAME = ''Cell''    			' + char(10)
			SELECT @v_dSql +=	'	;																' + char(10)

			SELECT @v_dSql +=	'	WITH MODEL_GROUP_CELL AS			                                                                                                              ' + char(10)
			SELECT @v_dSql +=	'		(			                                                                                                                                ' + char(10)
			SELECT @v_dSql +=	'			SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID		                                                                              ' + char(10)
			SELECT @v_dSql +=	'					, A.MODEL_ID, B.NICK_NAME AS MODEL_NAME, A.GROUP_CELL_ID, C.NICK_NAME AS GROUP_CELL_NAME	                                                                                                      ' + char(10)
			SELECT @v_dSql +=	'			FROM 	#T_BASIS_MODEL_GROUP_CELL A		                                 ' + char(10)
			SELECT @v_dSql +=	'					INNER JOIN SCM_ITEM_M B WITH(NOLOCK)	 ' + char(10)
			SELECT @v_dSql +=	'					ON 	1=1                                          ' + char(10)
			SELECT @v_dSql +=	'					AND B.ACTIVE_FLAG = ''Y''                     ' + char(10)
			SELECT @v_dSql +=	'					AND A.COMPANY_ID = B.COMPANY_ID                ' + char(10)
			SELECT @v_dSql +=	'					AND A.DIVISION_ID = B.DIVISION_ID              ' + char(10)
			SELECT @v_dSql +=	'					AND A.SITE_ID = B.SITE_ID                      ' + char(10)
			SELECT @v_dSql +=	'					AND A.MODEL_ID = B.ITEM_ID                     ' + char(10)
			SELECT @v_dSql +=	'					LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK)	 ' + char(10)
			SELECT @v_dSql +=	'					ON 	1=1                                          ' + char(10)
			SELECT @v_dSql +=	'					AND C.ACTIVE_FLAG = ''Y''                     ' + char(10)
			SELECT @v_dSql +=	'					AND A.COMPANY_ID = C.COMPANY_ID                ' + char(10)
			SELECT @v_dSql +=	'					AND A.DIVISION_ID = C.DIVISION_ID              ' + char(10)
			SELECT @v_dSql +=	'					AND A.SITE_ID = C.SITE_ID                      ' + char(10)
			SELECT @v_dSql +=	'					AND A.GROUP_CELL_ID = C.ITEM_ID                     ' + char(10)
			SELECT @v_dSql +=	'		)			                                                                                                                                ' + char(10)
			SELECT @v_dSql +=	'	SELECT	DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID 			                                                                        ' + char(10)
			SELECT @v_dSql +=	'			, A.GROUP_CELL_ID, A.GROUP_CELL_NAME, A.MODEL_ID, A.MODEL_NAME		                                                                                      ' + char(10)
			SELECT @v_dSql +=	'			, B.MODULE_ID, B.MODULE_NAME, B.CELL_ID, B.CELL_NAME		                                                                                            ' + char(10)
			--SELECT @v_dSql +=	'			, CASE WHEN A.GROUP_CELL_ID = B.GROUP_CELL_ID THEN ''Y'' ELSE ''N'' END AS SAME_GROUP_CELL_FLAG		                                  ' + char(10)
			--SELECT @v_dSql +=	'			, CASE WHEN A.GROUP_CELL_ID = B.GROUP_CELL_ID THEN ''Y'' ELSE NULL END AS USE_FLAG		                                  ' + char(10)
			SELECT @v_dSql +=	'			, CASE WHEN A.GROUP_CELL_ID = B.GROUP_CELL_ID AND GROUP_USE_FLAG = ''Y'' THEN ''Y'' ELSE ''N'' END AS SAME_GROUP_CELL_FLAG		                                  ' + char(10)
			SELECT @v_dSql +=	'			, B.GROUP_USE_FLAG AS USE_FLAG		                                  ' + char(10)
			SELECT @v_dSql +=	'	FROM 	MODEL_GROUP_CELL A,			                                                                                                          ' + char(10)
			SELECT @v_dSql +=	'			#T_BASIS_MODEL_GROUP_CELL B		                                                                                                        ' + char(10)
			SELECT @v_dSql +=	'	WHERE 	1=1			                                                                                                                        ' + char(10)
			
			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'LIKE', @p_division_id))       + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_sub_division_id))       + char(10)

			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'LIKE', @p_site_id))       + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_sub_site_id))       + char(10)

			--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'LIKE', @p_plant_id))       + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_sub_plant_id))       + char(10)
			
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.GROUP_CELL_ID' , 'EQ', @p_sub_group_cell_id))       + char(10)

			SELECT @v_dSql +=	'	AND 	A.COMPANY_ID = B.COMPANY_ID		                                                                                                    ' + char(10)
			SELECT @v_dSql +=	'	AND 	A.DIVISION_ID = B.DIVISION_ID		                                                                                                  ' + char(10)
			SELECT @v_dSql +=	'	AND 	A.SITE_ID = B.SITE_ID		                                                                                                          ' + char(10)
			SELECT @v_dSql +=	'	AND 	A.PLANT_ID = B.PLANT_ID		                                                                                                        ' + char(10)
			SELECT @v_dSql +=	'	AND 	A.MODEL_ID = B.MODEL_ID		                                                                                                        ' + char(10)
			SELECT @v_dSql +=	'	ORDER BY 	A.GROUP_CELL_ID, A.MODEL_ID, B.MODULE_ID, B.CELL_ID			                                                                      ' + char(10)


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
