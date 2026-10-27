

/*
 * Program ID   : PR_UI_FP01551_IN_HOUSE_REQUEST_PLAN
 * Description  : In-House Request Plan(Pack)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/05/28   CYS				Initial Release UI통합
 * 2022/10/19   LJS             조회 속도 개선
 * 2023/04/18   KCH             SCM_STOCK_H -> SCM_STOCK_H_V 뷰로 변경
 * 2023/06/08   LJS				활성화 분리
 --                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
*/

CREATE PROCEDURE [dbo].[PR_UI_FP01551_In_HOUSE_REQUEST_PLAN]
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

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP01551_IN_HOUSE_REQUEST_PLAN';
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
	DECLARE @p_is_ssp		NVARCHAR(MAX);
	DECLARE @p_inner_site_id		NVARCHAR(MAX);

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
	
	
	DECLARE @p_plant_id_cond nvarchar(100) = ''
	SET @p_plant_id_cond = (SELECT TOP 1 SEGMENT2  FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_UI_FP01551_In_HOUSE_REQUEST_PLAN' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')

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
		END ELSE IF @tmp_column = 'CELL_ITEM_ID' BEGIN
			SET @p_cell_item_id =		@tmp_value
		END ELSE IF @tmp_column = 'LINE_ASSIGN' BEGIN
			SET @p_line_assign =		@tmp_value
		
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

	-- cell assy code 추가... 20230608
	-- 활성화 분리 flag
	-- 2023-07-25 FROM CELL_PRODUCT_ASSY
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
		/*
		BEGIN
		      IF OBJECT_ID(
		      'tempdb..#TEMP_TABLE_01'
		      ) IS NOT NULL
		      
		      DROP TABLE 
		      #TEMP_TABLE_01
		      
		      IF OBJECT_ID(
		      'tempdb..#TEMP_TABLE_02'
		      ) IS NOT NULL
		      
		      DROP TABLE 
		      #TEMP_TABLE_02
		      
		END

		
		BEGIN
		
		      CREATE TABLE 
		      #TEMP_TABLE_01
		      (
		        	COMPANY_ID nvarchar(30) NOT NULL,
		        	DIVISION_ID nvarchar(30) NOT NULL,
		        	SITE_ID nvarchar(30) NOT NULL,
		        	PLANT_ID nvarchar(30) NOT NULL,
		        	GROUP_ITEM_ID nvarchar(150) NULL,
		        	ITEM_ID nvarchar(150) NULL,
		        	STOCK_FLAG nvarchar(10) NULL,
		        	QTY numeric(25, 10) NULL DEFAULT ((0)),
		        	TOTAL numeric(25, 10) NULL DEFAULT ((0)),
		        	AVAIL numeric(25, 10) NULL DEFAULT ((0)),
		        	HOLD numeric(25, 10) NULL DEFAULT ((0)),
		        	PACK_INTRANSIT numeric(25, 10) NULL DEFAULT ((0))
		      )
		      
		      CREATE TABLE 
		      #TEMP_TABLE_02
		      (
		        	COMPANY_ID nvarchar(30) NOT NULL,
		        	DIVISION_ID nvarchar(30) NOT NULL,
		        	SITE_ID nvarchar(30) NOT NULL,
		        	PLANT_ID nvarchar(30) NOT NULL,
		        	ITEM_ID nvarchar(150) NULL,
		        	CELL_ITEM_ID nvarchar(150) NULL,
		        	STORAGE_ID nvarchar(30) NULL,
		        	SOC_ID nvarchar(30) NULL,
		        	MARKET nvarchar(30) NULL,
		        	PLAN_DATE nvarchar(10) NULL,
		        	QTY numeric(25, 10) NULL DEFAULT ((0)),
		        	BOM_RATE numeric(25, 10) NULL DEFAULT ((0))
		      )
		
		END
		*/

		SELECT @p_is_ssp = ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = 'SSP' THEN 1 ELSE 0 END), 1)  
		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)       
		WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_STOCK_SOURCE'								
		AND    A.ACTIVE_FLAG = 'Y'														
		AND    A.SEGMENT1 = ''+ @p_instance_id +''

		SELECT @p_inner_site_id = MAX(SITE_ID)
		FROM FP_INSTANCE_INFO_V
		WHERE 1=1
		AND INSTANCE_ID = ''+ @p_instance_id +''


		SET	@v_dSql = ''

		--SELECT @v_dSql += N'	WITH INSTANCE_INFO AS (	' + char(10)
		--SELECT @v_dSql += N'		SELECT DISTINCT BB.COMPANY_ID, BB.DIVISION_ID, BB.SITE_ID, BB.PLANT_ID, BB.FACTORY_ID, BB. SHOP_GROUP_ID         ' + char(10)
		--SELECT @v_dSql += N'		FROM   FP_INSTANCE_FACTORY_M AA WITH(NOLOCK), SCM_FACTORY_M BB WITH(NOLOCK)       ' + char(10)
		--SELECT @v_dSql += N'		WHERE  AA.INSTANCE_ID  = '''+ @p_instance_id +'''  ' + char(10)
		--SELECT @v_dSql += N'		AND    AA.ACTIVE_FLAG  = ''Y''          ' + char(10)
		--SELECT @v_dSql += N'		AND    BB.ACTIVE_FLAG  = ''Y''          ' + char(10)
		--SELECT @v_dSql += N'		AND    AA.FACTORY_ID   = BB.FACTORY_ID  ' + char(10)
		--SELECT @v_dSql += N'	) ' + char(10)
		--SELECT @v_dSql += N'	INSERT INTO	#TEMP_TABLE_02  ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID													         ' + char(10)
		SELECT @v_dSql += N'           , A.ITEM_ID, A.CELL_ITEM_ID													  ' + char(10)
		SELECT @v_dSql += N'           , A.STORAGE_ID, A.SOC_ID													      ' + char(10)
		SELECT @v_dSql += N'           , A.MARKET, A.PLAN_DATE													      ' + char(10)
		SELECT @v_dSql += N'           , CASE WHEN (RANK() OVER (PARTITION BY A.PLANT_ID, A.ITEM_ID, A.PLAN_DATE ORDER BY ISNULL(X.LINE_PRIORITY,9), A.IDX ) ) = 1 THEN A.QTY ELSE 0 END AS QTY' + char(10)
		SELECT @v_dSql += N'           , A.BOM_RATE												 ' + char(10)
		SELECT @v_dSql += N'	FROM	(   ' + char(10)
		SELECT @v_dSql += N'	          	 SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID													        ' + char(10)
		SELECT @v_dSql += N'	                   , A.ITEM_ID, C.CHILD_ITEM_ID AS CELL_ITEM_ID													     ' + char(10)
		SELECT @v_dSql += N'	                   , CASE WHEN A.MARKET = ''D'' THEN B.DOMESTIC_SLOC_ID WHEN A.MARKET = ''E'' THEN B.EXPORT_SLOC_ID ELSE B.DOMESTIC_SLOC_ID END AS STORAGE_ID	' + char(10)							
		SELECT @v_dSql += N'	                   , NULL AS SOC_ID													  ' + char(10)
		SELECT @v_dSql += N'	                   , A.MARKET, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE													' + char(10)
		SELECT @v_dSql += N'	                   , (SUM(A.PLAN_IN_QTY) * MAX(C.BOM_RATE)) AS QTY --SUM(A.PLAN_IN) AS QTY													     ' + char(10)
		SELECT @v_dSql += N'	                   , C.BOM_RATE AS BOM_RATE, C.IDX							' + char(10)
		SELECT @v_dSql += N'	              FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK),													 ' + char(10)
		SELECT @v_dSql += N'	            		 SCM_LINE_M B WITH(NOLOCK),					 ' + char(10)
		SELECT @v_dSql += N'	            		 ( ' + char(10)
		SELECT @v_dSql += N'	            		 		SELECT SB.*     ' + char(10)
		SELECT @v_dSql += N'				            	FROM (          ' + char(10)
		-- #TEMP_TABLE_BOM_DETAIL 임시테이블 변경
		SELECT @v_dSql += N'									SELECT * ' + char(10)
		SELECT @v_dSql += N'									FROM   #TEMP_TABLE_BOM_DETAIL C ' + char(10)

		IF @p_instance_id = 'PL_PACK' BEGIN
			SELECT @v_dSql += N'									WHERE NOT EXISTS ( ' + char(10)
			SELECT @v_dSql += N'														SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS MODULE, A.SEGMENT3 AS CELL_GROUP_CODE ' + char(10)
			SELECT @v_dSql += N'														FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'														WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_TO_CELL_GROUP'' ' + char(10)
			SELECT @v_dSql += N'														AND	   A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'														AND	   C.SITE_ID = A.SEGMENT1 ' + char(10)
			SELECT @v_dSql += N'														AND	   C.PARENT_ITEM_ID = A.SEGMENT2 ' + char(10)
			SELECT @v_dSql += N'														AND	   C.CHILD_ITEM_ID = A.SEGMENT3 ' + char(10)
			SELECT @v_dSql += N'									) ' + char(10)
		END
		
		IF @p_instance_id = 'PL_PACK' BEGIN
			SELECT @v_dSql += N'									UNION ALL ' + char(10)
			SELECT @v_dSql += N'									SELECT * ' + char(10)
			SELECT @v_dSql += N'									FROM   #TEMP_TABLE_BOM_DETAIL C ' + char(10)
			SELECT @v_dSql += N'									WHERE  EXISTS ( ' + char(10)
			SELECT @v_dSql += N'														SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS MODULE, A.SEGMENT3 AS CELL_GROUP_CODE ' + char(10)
			SELECT @v_dSql += N'														FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'														WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_TO_CELL_GROUP'' ' + char(10)
			SELECT @v_dSql += N'														AND	   A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'														AND	   C.SITE_ID = A.SEGMENT1 ' + char(10)
			SELECT @v_dSql += N'														AND	   C.PARENT_ITEM_ID = A.SEGMENT2 ' + char(10)
			SELECT @v_dSql += N'														AND	   C.CHILD_ITEM_ID = A.SEGMENT3 ' + char(10)
			SELECT @v_dSql += N'									) ' + char(10)
		END

		/*
		SELECT @v_dSql += N'				            		 	SELECT SB.*       ' + char(10)
		SELECT @v_dSql += N'				            		 	FROM (  ' + char(10)
		SELECT @v_dSql += N'										      SELECT C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, MAX(C.CHILD_QTY/C.PARENT_QTY) AS BOM_RATE, C.ALT_PRIORITY   ' + char(10)
		SELECT @v_dSql += N'										      		 , RANK() OVER (PARTITION BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID ORDER BY  ISNULL(C.ALT_PRIORITY,99) * 10 ) AS IDX ' + char(10)
		SELECT @v_dSql += N'										      FROM 	(   ' + char(10)
		SELECT @v_dSql += N'																		SELECT	D.COMPANY_ID, D.DIVISION_ID, D.SITE_ID, D.ITEM_ID   ' + char(10)
		SELECT @v_dSql += N'																		FROM   ' + char(10)
		SELECT @v_dSql += N'																				SCM_ITEM_M D WITH(NOLOCK),											     ' + char(10)
		SELECT @v_dSql += N'																				SCM_ITEM_CLASS_M E WITH(NOLOCK)	         ' + char(10)
		SELECT @v_dSql += N'																		WHERE 1=1         ' + char(10)
		SELECT @v_dSql += N'																		AND	D.SITE_ID = '''+ @p_inner_site_id +'''       ' + char(10)
		SELECT @v_dSql += N'																	 	AND	EXISTS (      ' + char(10)
		SELECT @v_dSql += N'																						SELECT 	 1  ' + char(10)
		SELECT @v_dSql += N'																						FROM #TEMP_TABLE_INSTANCE_INFO AS X   ' + char(10)
		SELECT @v_dSql += N'																						WHERE 1=1   ' + char(10)
		SELECT @v_dSql += N'																						AND		D.COMPANY_ID	= X.COMPANY_ID      ' + char(10)
		SELECT @v_dSql += N'																						AND		D.DIVISION_ID	= X.DIVISION_ID     ' + char(10)
		SELECT @v_dSql += N'																						AND		D.SITE_ID		= X.SITE_ID         ' + char(10)
		SELECT @v_dSql += N'																					)     ' + char(10)
		SELECT @v_dSql += N'																		AND	 D.ITEM_CLASS = E.CLASS_ID         ' + char(10)
		SELECT @v_dSql += N'																		AND	 D.ACTIVE_FLAG = ''Y''  ' + char(10)
		SELECT @v_dSql += N'																		AND  E.LEVEL_3_NAME = ''CELL''         ' + char(10)
		SELECT @v_dSql += N'																	) D        ' + char(10)
		SELECT @v_dSql += N'														INNER HASH JOIN SCM_BOM_M C WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'														ON 1=1       ' + char(10)
		SELECT @v_dSql += N'														AND    C.COMPANY_ID = D.COMPANY_ID' + char(10)
		SELECT @v_dSql += N'														AND    C.DIVISION_ID = D.DIVISION_ID        ' + char(10)
		SELECT @v_dSql += N'														AND    C.SITE_ID = D.SITE_ID												' + char(10)
		SELECT @v_dSql += N'														AND    C.CHILD_ITEM_ID = D.ITEM_ID	        ' + char(10)
		SELECT @v_dSql += N'									      WHERE 1=1       ' + char(10)
		SELECT @v_dSql += N'									      AND	C.SITE_ID = '''+ @p_inner_site_id +'''       ' + char(10)
		SELECT @v_dSql += N'									      AND    C.EFF_END_DATE >= GETDATE()												        ' + char(10)
		SELECT @v_dSql += N'									      AND	EXISTS (  ' + char(10)
		SELECT @v_dSql += N'									      					SELECT 	1' + char(10)
		SELECT @v_dSql += N'									      					FROM	#TEMP_TABLE_INSTANCE_INFO AS X ' + char(10)
		SELECT @v_dSql += N'									      					WHERE	1=1        ' + char(10)
		SELECT @v_dSql += N'									      					AND		C.COMPANY_ID	= X.COMPANY_ID  ' + char(10)
		SELECT @v_dSql += N'									      					AND		C.DIVISION_ID	= X.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'									      					AND		C.SITE_ID		= X.SITE_ID     ' + char(10)
		SELECT @v_dSql += N'									      					AND		C.PLANT_ID		= X.PLANT_ID    ' + char(10)
		SELECT @v_dSql += N'									      				) ' + char(10)
		SELECT @v_dSql += N'									      --AND	  (C.ALT_PRIORITY IS NULL OR C.ALT_PRIORITY = ''1'')	       ' + char(10)

		IF @p_instance_id = 'PL_PACK' BEGIN
			SELECT @v_dSql += N'								            	AND NOT EXISTS (																									          ' + char(10)
			SELECT @v_dSql += N'																SELECT	A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS MODULE, A.SEGMENT3 AS CELL_GROUP_CODE       ' + char(10)
			SELECT @v_dSql += N'																FROM	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)    ' + char(10)
			SELECT @v_dSql += N'																WHERE	A.LOOKUP_TYPE_CODE = ''MODULE_TO_CELL_GROUP''    ' + char(10)
			SELECT @v_dSql += N'																AND	A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'																AND	C.SITE_ID = A.SEGMENT1' + char(10)
			SELECT @v_dSql += N'																AND	C.PARENT_ITEM_ID = A.SEGMENT2   ' + char(10)
			SELECT @v_dSql += N'																AND	C.CHILD_ITEM_ID = A.SEGMENT3    ' + char(10)
			SELECT @v_dSql += N'															)        ' + char(10)
		END
		
		SELECT @v_dSql += N'								      	GROUP BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, C.ALT_PRIORITY        ' + char(10)
		SELECT @v_dSql += N'								  ) SB          ' + char(10)
		SELECT @v_dSql += N'								  --WHERE SB.IDX = 1      ' + char(10)
		
		IF @p_instance_id = 'PL_PACK' BEGIN
			SELECT @v_dSql += N'												UNION ALL																											' + char(10)		
			SELECT @v_dSql += N'												SELECT SB.*          ' + char(10)
			SELECT @v_dSql += N'					            		 		FROM (    ' + char(10)
			SELECT @v_dSql += N'												      SELECT 	C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, MAX(C.CHILD_QTY/C.PARENT_QTY) AS BOM_RATE, C.ALT_PRIORITY  ' + char(10)   
			SELECT @v_dSql += N'												      		 	, RANK() OVER (PARTITION BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID ORDER BY  ISNULL(C.ALT_PRIORITY,99) * 10 ) AS IDX	' + char(10)   
			SELECT @v_dSql += N'												      FROM 		( ' + char(10)        
			SELECT @v_dSql += N'																					SELECT	D.COMPANY_ID, D.DIVISION_ID, D.SITE_ID, D.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'																					FROM  ' + char(10)
			SELECT @v_dSql += N'																							SCM_ITEM_M D WITH(NOLOCK),											   ' + char(10)
			SELECT @v_dSql += N'																							SCM_ITEM_CLASS_M E WITH(NOLOCK)	        ' + char(10)
			SELECT @v_dSql += N'																					WHERE 1=1       ' + char(10)
			SELECT @v_dSql += N'																					AND	D.SITE_ID = '''+ @p_inner_site_id +'''       ' + char(10)
			SELECT @v_dSql += N'																				 	AND	EXISTS (    ' + char(10)
			SELECT @v_dSql += N'																									SELECT 	 1 ' + char(10)
			SELECT @v_dSql += N'																									FROM #TEMP_TABLE_INSTANCE_INFO AS X ' + char(10)
			SELECT @v_dSql += N'																									WHERE 1=1  ' + char(10)
			SELECT @v_dSql += N'																									AND		D.COMPANY_ID	= X.COMPANY_ID    ' + char(10)
			SELECT @v_dSql += N'																									AND		D.DIVISION_ID	= X.DIVISION_ID   ' + char(10)
			SELECT @v_dSql += N'																									AND		D.SITE_ID		= X.SITE_ID       ' + char(10)
			SELECT @v_dSql += N'																								)   ' + char(10)
			SELECT @v_dSql += N'																					AND	 D.ITEM_CLASS = E.CLASS_ID       ' + char(10)
			SELECT @v_dSql += N'																					AND	 D.ACTIVE_FLAG = ''Y'' ' + char(10)  
			SELECT @v_dSql += N'																					AND  E.LEVEL_3_NAME = ''CELL''       ' + char(10)  
			SELECT @v_dSql += N'																				) D       ' + char(10)
			SELECT @v_dSql += N'																	INNER HASH JOIN SCM_BOM_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'																	ON 1=1     ' + char(10)
			SELECT @v_dSql += N'																	AND    C.COMPANY_ID = D.COMPANY_ID         ' + char(10)
			SELECT @v_dSql += N'																	AND    C.DIVISION_ID = D.DIVISION_ID       ' + char(10)
			SELECT @v_dSql += N'																	AND    C.SITE_ID = D.SITE_ID												         ' + char(10)
			SELECT @v_dSql += N'																	AND    C.CHILD_ITEM_ID = D.ITEM_ID	       ' + char(10)
			SELECT @v_dSql += N'										    		  WHERE 1=1      ' + char(10)
			SELECT @v_dSql += N'													  AND	C.SITE_ID = '''+ @p_inner_site_id +'''       ' + char(10)
			SELECT @v_dSql += N'										    		  AND    C.EFF_END_DATE >= GETDATE()												      ' + char(10)
			SELECT @v_dSql += N'										    		  AND	EXISTS ( ' + char(10)
			SELECT @v_dSql += N'										    		  					SELECT 	1         ' + char(10)
			SELECT @v_dSql += N'										    		  					FROM	#TEMP_TABLE_INSTANCE_INFO AS X ' + char(10)
			SELECT @v_dSql += N'										    		  					WHERE	1=1       ' + char(10)
			SELECT @v_dSql += N'										    		  					AND		C.COMPANY_ID	= X.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'										    		  					AND		C.DIVISION_ID	= X.DIVISION_ID' + char(10)
			SELECT @v_dSql += N'										    		  					AND		C.SITE_ID		= X.SITE_ID    ' + char(10)
			SELECT @v_dSql += N'										    		  					AND		C.PLANT_ID		= X.PLANT_ID   ' + char(10)
			SELECT @v_dSql += N'										    		  				)' + char(10)
			SELECT @v_dSql += N'												      --AND	  (C.ALT_PRIORITY IS NULL OR C.ALT_PRIORITY = ''1'')	     ' + char(10)    
			SELECT @v_dSql += N'													  AND 	 EXISTS (																							   ' + char(10)
			SELECT @v_dSql += N'																		SELECT	A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS MODULE, A.SEGMENT3 AS CELL_GROUP_CODE         ' + char(10)
			SELECT @v_dSql += N'																		FROM	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)      ' + char(10)
			SELECT @v_dSql += N'																		WHERE	A.LOOKUP_TYPE_CODE = ''MODULE_TO_CELL_GROUP''       ' + char(10)  
			SELECT @v_dSql += N'																		AND	A.ACTIVE_FLAG = ''Y''   ' + char(10)  
			SELECT @v_dSql += N'																		AND	C.SITE_ID = A.SEGMENT1  ' + char(10)
			SELECT @v_dSql += N'																		AND	C.PARENT_ITEM_ID = A.SEGMENT2      ' + char(10)
			SELECT @v_dSql += N'																		AND	C.CHILD_ITEM_ID = A.SEGMENT3       ' + char(10)
			SELECT @v_dSql += N'																	)' + char(10)
			SELECT @v_dSql += N'										    	      GROUP BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, C.ALT_PRIORITY    ' + char(10)
			SELECT @v_dSql += N'												  ) SB    ' + char(10)
			SELECT @v_dSql += N'												  --WHERE SB.IDX = 1														        ' + char(10)    
		END
		*/

		SELECT @v_dSql += N'							) SB     ' + char(10)
		SELECT @v_dSql += N'						WHERE	1=1  ' + char(10)
		SELECT @v_dSql += N'						   ' + char(10)
		SELECT @v_dSql += N'								     ' + char(10)
		SELECT @v_dSql += N'					 ) C						' + char(10)
		SELECT @v_dSql += N'          	 WHERE  1=1    ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'	          AND    A.OPERATION_ID IN (''P5000'', ''P5200'')        ' + char(10)
		--SELECT @v_dSql += N'	            AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' -1 AND '''+ @p_bucket_to +''' +1 --선행일자 때문에 앞 뒤로 하루씩 늘려준다.' + char(10)
		SELECT @v_dSql += N'	            AND    A.PLAN_DATE BETWEEN DATEADD(DAY, -1, CONVERT(DATETIME, ''' + @p_bucket_from + ''' + '' 00:00:00.000'')) AND DATEADD(DAY, 1, CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'')) ' + char(10)
		SELECT @v_dSql += N'	            AND	   A.PLAN_TYPE = ''RELEASE''' + char(10)
		SELECT @v_dSql += N'	            AND	   A.PLAN_IN_QTY > 0        ' + char(10)
		SELECT @v_dSql += N'          		AND    A.SITE_ID = B.SITE_ID													    ' + char(10)
		SELECT @v_dSql += N'                AND    A.DIVISION_ID = B.DIVISION_ID													       ' + char(10)
		SELECT @v_dSql += N'                --AND    A.OPERATION_ID = B.OPERATION_ID													   ' + char(10)
		SELECT @v_dSql += N'                AND    B.OPERATION_ID = (CASE WHEN A.PLANT_ID = ''' + @p_plant_id_cond + ''' THEN ''P5000'' ELSE ''P1000'' END)    ' + char(10)
		SELECT @v_dSql += N'                AND    A.LINE_ID = B.LINE_ID													    ' + char(10)
		SELECT @v_dSql += N'                AND    A.SITE_ID = C.SITE_ID													    ' + char(10)
		SELECT @v_dSql += N'                AND    A.DIVISION_ID = C.DIVISION_ID													       ' + char(10)
		SELECT @v_dSql += N'                AND    A.ITEM_ID = C.PARENT_ITEM_ID												    ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.CHILD_ITEM_ID' , 'LIKE', @p_cell_item_id)) + char(10)
		SELECT @v_dSql += N'          	    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID													        ' + char(10)
		SELECT @v_dSql += N'                       , A.ITEM_ID, C.CHILD_ITEM_ID, A.MARKET, CONVERT(VARCHAR,A.PLAN_DATE,112)													         ' + char(10)
		SELECT @v_dSql += N'                       , CASE WHEN A.MARKET = ''D'' THEN B.DOMESTIC_SLOC_ID WHEN A.MARKET = ''E'' THEN B.EXPORT_SLOC_ID ELSE B.DOMESTIC_SLOC_ID END  				' + char(10)				
		SELECT @v_dSql += N'                       , C.BOM_RATE, C.IDX      ' + char(10)
		SELECT @v_dSql += N'			) A ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN (        ' + char(10)
		SELECT @v_dSql += N'								SELECT 	A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.ITEM_ID AS ASSIGN_ITEM_ID, MONTH, MIN(PRIORITY) AS LINE_PRIORITY  ' + char(10)
		SELECT @v_dSql += N'								FROM   	SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)  ' + char(10)
		SELECT @v_dSql += N'								WHERE 	1=1     ' + char(10)
		SELECT @v_dSql += N'								 AND	A.SITE_ID = '''+ @p_inner_site_id +'''       ' + char(10)
		SELECT @v_dSql += N'								 AND	EXISTS (' + char(10)
		SELECT @v_dSql += N'	  												SELECT 	1        ' + char(10)
		SELECT @v_dSql += N'	  												FROM	#TEMP_TABLE_INSTANCE_INFO AS X ' + char(10)
		SELECT @v_dSql += N'	  												WHERE	1=1      ' + char(10)
		SELECT @v_dSql += N'	  												AND		A.COMPANY_ID	= X.COMPANY_ID' + char(10)
		SELECT @v_dSql += N'	  												AND		A.DIVISION_ID	= X.DIVISION_ID         ' + char(10)
		SELECT @v_dSql += N'	  												AND		A.SITE_ID		= X.SITE_ID   ' + char(10)
		SELECT @v_dSql += N'	  												AND		A.PLANT_ID		= X.PLANT_ID  ' + char(10)
		SELECT @v_dSql += N'	  											)         ' + char(10)
		SELECT @v_dSql += N'								AND 	OPERATION_ID = ''A9000''     ' + char(10)
		SELECT @v_dSql += N'								AND 	PRIORITY NOT IN (''0'',''9'')' + char(10)
		SELECT @v_dSql += N'								AND 	MONTH >= SUBSTRING(CONVERT(NVARCHAR,'''+ @p_plan_date +''',112),1,6)   ' + char(10)
		SELECT @v_dSql += N'								GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.ITEM_ID, MONTH         ' + char(10)
		SELECT @v_dSql += N'			) X ' + char(10)
		SELECT @v_dSql += N'				ON A.COMPANY_ID = X.COMPANY_ID  ' + char(10)
		SELECT @v_dSql += N'				AND A.DIVISION_ID = X.DIVISION_ID         ' + char(10)
		SELECT @v_dSql += N'				AND A.SITE_ID = X.SITE_ID       ' + char(10)
		SELECT @v_dSql += N'				AND A.PLANT_ID = X.PLANT_ID     ' + char(10)
		SELECT @v_dSql += N'				AND A.CELL_ITEM_ID  = X.ASSIGN_ITEM_ID    ' + char(10)
		SELECT @v_dSql += N'				AND SUBSTRING(CONVERT(NVARCHAR,A.PLAN_DATE,112),1,6) = X.MONTH ' + char(10)
		SELECT @v_dSql += N'	WHERE	1=1 ' + char(10)
		SELECT @v_dSql += N'	AND		EXISTS (	   ' + char(10)
		SELECT @v_dSql += N'						SELECT 	1    ' + char(10)
		SELECT @v_dSql += N'						FROM 	(    ' + char(10)
		SELECT @v_dSql += N'									SELECT 	COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID' + char(10)
		SELECT @v_dSql += N'									FROM 	FP_DEMAND_PACK_REQUIRE_CELL_H A WITH(NOLOCK)	        ' + char(10)
		SELECT @v_dSql += N'										WHERE 	1=1       ' + char(10)
		SELECT @v_dSql += N'										AND 	INSTANCE_ID = '''+ @p_instance_id +'''    ' + char(10)
		SELECT @v_dSql += N'										AND 	PLAN_ID = '''+ @p_plan_id +'''  ' + char(10)
		SELECT @v_dSql += N'										AND 	A.REQUIRE_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')        ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ITEM_ID' , 'LIKE', @p_cell_item_id)) + char(10)
		SELECT @v_dSql += N'										GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CELL_ITEM_ID      ' + char(10)
		SELECT @v_dSql += N'									) X         ' + char(10)
		SELECT @v_dSql += N'							WHERE 	1=1         ' + char(10)
		SELECT @v_dSql += N'							AND		A.COMPANY_ID = X.COMPANY_ID      ' + char(10)
		SELECT @v_dSql += N'							AND		A.DIVISION_ID = X.DIVISION_ID    ' + char(10)
		SELECT @v_dSql += N'							AND		A.SITE_ID = X.SITE_ID ' + char(10)
		SELECT @v_dSql += N'							AND		A.PLANT_ID = X.PLANT_ID          ' + char(10)
		SELECT @v_dSql += N'							AND		A.CELL_ITEM_ID = X.CELL_ITEM_ID  ' + char(10)
		SELECT @v_dSql += N'					   )   ' + char(10)

		--exec sp_executesql @v_dSql

		declare @v_tempSql nvarchar(max) = @v_dSql
		--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_tempSql,'tempDB',@runstart, @runend

		SET	@v_dSql = ''

		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_INSTANCE_INFO'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_INSTANCE_INFO ' + char(10)
		SELECT @v_dSql += N'' + char(10)
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_STOCK_T'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_STOCK_T ' + char(10)
		SELECT @v_dSql += N'' + char(10)
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_MAIN_S'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_MAIN_S ' + char(10)
		SELECT @v_dSql += N'' + char(10)
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_MAIN_P'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_MAIN_P ' + char(10)
		SELECT @v_dSql += N'' + char(10)
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_MAIN_I'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_MAIN_I ' + char(10)
		SELECT @v_dSql += N'' + char(10)
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_SUB_S'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_SUB_S ' + char(10)
		SELECT @v_dSql += N'' + char(10)
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_T_FLAG'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_T_FLAG ' + char(10)
		SELECT @v_dSql += N'' + char(10)
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_BOM_DETAIL'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_BOM_DETAIL ' + char(10)		
		SELECT @v_dSql += N'' + char(10)

		--SELECT @v_dSql += N'	WITH INSTANCE_INFO AS (			' + char(10)
		SELECT @v_dSql += N'			SELECT DISTINCT BB.COMPANY_ID, BB.DIVISION_ID, BB.SITE_ID, BB.PLANT_ID, BB.FACTORY_ID, BB. SHOP_GROUP_ID       ' + char(10)
		SELECT @v_dSql += N'			INTO   #TEMP_TABLE_INSTANCE_INFO       ' + char(10)
		SELECT @v_dSql += N'			FROM   FP_INSTANCE_FACTORY_M AA WITH(NOLOCK), SCM_FACTORY_M BB WITH(NOLOCK)    ' + char(10)
		SELECT @v_dSql += N'			WHERE  AA.INSTANCE_ID  = '''+ @p_instance_id +'''        ' + char(10)
		SELECT @v_dSql += N'			AND    AA.ACTIVE_FLAG  = ''Y''       ' + char(10)
		SELECT @v_dSql += N'			AND    BB.ACTIVE_FLAG  = ''Y''       ' + char(10)
		SELECT @v_dSql += N'			AND    AA.FACTORY_ID   = BB.FACTORY_ID        ' + char(10)
		--SELECT @v_dSql += N'	)           ' + char(10)
		
		---------------- BOM 임시 테이블 추가 -----------------------
		SELECT @v_dSql += N'SELECT C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, MAX(C.CHILD_QTY/C.PARENT_QTY) AS BOM_RATE, C.ALT_PRIORITY ' + char(10)
		SELECT @v_dSql += N'	 , RANK() OVER (PARTITION BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID ORDER BY  ISNULL(C.ALT_PRIORITY,99) * 10 ) AS IDX ' + char(10)
		SELECT @v_dSql += N'INTO #TEMP_TABLE_BOM_DETAIL ' + char(10)
		SELECT @v_dSql += N'FROM 	( ' + char(10)
		SELECT @v_dSql += N'						SELECT	D.COMPANY_ID, D.DIVISION_ID, D.SITE_ID, D.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'						FROM    SCM_ITEM_M D WITH(NOLOCK), ' + char(10)
		SELECT @v_dSql += N'								SCM_ITEM_CLASS_M E WITH(NOLOCK)	' + char(10)
		SELECT @v_dSql += N'						WHERE   1=1 ' + char(10)
		SELECT @v_dSql += N'						AND	D.SITE_ID = ''' + @p_inner_site_id + ''' ' + char(10)
		SELECT @v_dSql += N'						AND	EXISTS ( ' + char(10)
		SELECT @v_dSql += N'										SELECT 1 ' + char(10)
		SELECT @v_dSql += N'										FROM   #TEMP_TABLE_INSTANCE_INFO AS X ' + char(10)
		SELECT @v_dSql += N'										WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'										AND	   D.COMPANY_ID	 = X.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'										AND	   D.DIVISION_ID = X.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'										AND	   D.SITE_ID     = X.SITE_ID ' + char(10)
		SELECT @v_dSql += N'						) ' + char(10)
		SELECT @v_dSql += N'						AND	 D.ITEM_CLASS = E.CLASS_ID ' + char(10)
		SELECT @v_dSql += N'						AND	 D.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'						AND  E.LEVEL_3_NAME = ''CELL'' ' + char(10)
		SELECT @v_dSql += N') D ' + char(10)
		SELECT @v_dSql += N'INNER HASH JOIN SCM_BOM_M_V C WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON    1=1 ' + char(10)
		SELECT @v_dSql += N'AND   C.COMPANY_ID    = D.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND   C.DIVISION_ID   = D.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND   C.SITE_ID       = D.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND   C.CHILD_ITEM_ID = D.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'AND	  C.SITE_ID = ''' + @p_inner_site_id + ''' ' + char(10)
		SELECT @v_dSql += N'AND   C.EFF_END_DATE >= GETDATE() ' + char(10)
		SELECT @v_dSql += N'AND	EXISTS ( ' + char(10)
		SELECT @v_dSql += N'				SELECT 	1 ' + char(10)
		SELECT @v_dSql += N'				FROM	#TEMP_TABLE_INSTANCE_INFO AS X ' + char(10)
		SELECT @v_dSql += N'				WHERE	1=1 ' + char(10)
		SELECT @v_dSql += N'				AND		C.COMPANY_ID	= X.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'				AND		C.DIVISION_ID	= X.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'				AND		C.SITE_ID		= X.SITE_ID ' + char(10)
		SELECT @v_dSql += N'				AND		C.PLANT_ID		= X.PLANT_ID ' + char(10)
		SELECT @v_dSql += N') ' + char(10)
		SELECT @v_dSql += N'GROUP BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, C.ALT_PRIORITY ' + char(10)
		SELECT @v_dSql += N'' + char(10)+ char(10)
		
		--SELECT @v_dSql += N'	, STOCK_T AS (        ' + char(10)
		SELECT @v_dSql += N'	-- PACK     ' + char(10)
		--SELECT @v_dSql += N'			SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.EXPORT_SLOC_ID	, ''PACK'' AS STOCK_TYPE --, A.STOCK_TYPE     ' + char(10)
		SELECT @v_dSql += N'			SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) AS ITEM_ID, A.EXPORT_SLOC_ID	, ''PACK'' AS STOCK_TYPE --, A.STOCK_TYPE     ' + char(10) -- cell assy code 추가... 20230608
		SELECT @v_dSql += N'						, SUM(QTY) AS QTY        ' + char(10)
		SELECT @v_dSql += N'						, SUM(AVAIL_QTY) +  SUM(HOLD_QTY) AS TOTAL_QTY           ' + char(10)
		SELECT @v_dSql += N'						, SUM(AVAIL_QTY) AS AVAIL_QTY     ' + char(10)
		SELECT @v_dSql += N'						, SUM(HOLD_QTY) AS HOLD_QTY       ' + char(10)
		SELECT @v_dSql += N'						, SUM(AVAIL_CELL_QTY) +  SUM(HOLD_CELL_QTY) AS TOTAL_CELL_QTY      ' + char(10)
		SELECT @v_dSql += N'						, SUM(AVAIL_CELL_QTY) AS AVAIL_CELL_QTY     ' + char(10)
		SELECT @v_dSql += N'						, SUM(HOLD_CELL_QTY) AS HOLD_CELL_QTY       ' + char(10)
		SELECT @v_dSql += N'						, 0 AS AVAIL_CELL_LONG_QTY' + char(10)
		SELECT @v_dSql += N'						, 0 AS HOLD_CELL_LONG_QTY' + char(10)
		SELECT @v_dSql += N'						, SUM(PACK_INTRANSIT) AS INTRANSIT' + char(10)
		SELECT @v_dSql += N'			INTO    #TEMP_TABLE_STOCK_T' + char(10)
		SELECT @v_dSql += N'			FROM		( ' + char(10)
		SELECT @v_dSql += N'	SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID AS ITEM_ID, A.EXPORT_SLOC_ID, A.STOCK_TYPE																							' + char(10)
		--SELECT @v_dSql += N'				, ISNULL(MAX(MODIFY_QTY), SUM(A.QTY)) AS QTY	                                                                                                                                                            ' + char(10)
		--SELECT @v_dSql += N'				, ISNULL(ISNULL(MAX(BOH_MODIFY_QTY), SUM(A.BOH_QTY)),0) AS AVAIL_QTY		 --이전 BOH입력 가능하여 MODIFY 수량을 MAX 로 먼저 가져간다.                                                                    ' + char(10)
		--SELECT @v_dSql += N'				, ISNULL(ISNULL(MAX(HOLD_MODIFY_QTY), SUM(A.HOLD_QTY)),0) AS HOLD_QTY                                                                                                                                       ' + char(10)
		--SELECT @v_dSql += N'				, ISNULL(ISNULL(MAX(BOH_CELL_MODIFY_QTY), SUM(A.BOH_CELL_QTY)),0) AS AVAIL_CELL_QTY                                                                                                                         ' + char(10)
		--SELECT @v_dSql += N'				, ISNULL(ISNULL(MAX(HOLD_CELL_MODIFY_QTY), SUM(A.HOLD_CELL_QTY)),0) AS HOLD_CELL_QTY                                                                                                                        ' + char(10)
		--SELECT @v_dSql += N'				, ISNULL(SUM(A.PACK_INTRANSIT),0) AS PACK_INTRANSIT                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'				, ISNULL(SUM(A.QTY),0) AS QTY	                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'				, ISNULL(SUM(A.BOH_QTY),0) AS AVAIL_QTY		 --이전 BOH입력 가능하여 MODIFY 수량을 MAX 로 먼저 가져간다.                                                                    ' + char(10)
		SELECT @v_dSql += N'				, ISNULL(SUM(A.HOLD_QTY),0) AS HOLD_QTY                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'				, ISNULL(SUM(A.BOH_CELL_QTY),0) AS AVAIL_CELL_QTY                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'				, ISNULL(SUM(A.HOLD_CELL_QTY),0) AS HOLD_CELL_QTY                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'				, ISNULL(SUM(A.PACK_INTRANSIT),0) AS PACK_INTRANSIT              ' + char(10)
		SELECT @v_dSql += N'	FROM		(                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'						SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'									, A.FP_APPLY_ITEM_ID AS ITEM_ID, B.EXPORT_SLOC_ID                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'									, A.MODIFY_FP_APPLY_WIPQTY AS MODIFY_QTY                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'									, A.FP_APPLY_WIPQTY AS QTY                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'									, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS BOH_MODIFY_QTY         ' + char(10)
		SELECT @v_dSql += N'									, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y'' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS BOH_QTY                       ' + char(10)
		SELECT @v_dSql += N'									, CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_MODIFY_QTY                                                                                          ' + char(10)
		SELECT @v_dSql += N'									, CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.FP_APPLY_WIPQTY ELSE NULL END AS HOLD_QTY                                                                                                        ' + char(10)
		SELECT @v_dSql += N'									, 0 AS BOH_CELL_MODIFY_QTY                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'									, 0 AS BOH_CELL_QTY                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'									, 0 AS HOLD_CELL_MODIFY_QTY                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'									, 0 AS HOLD_CELL_QTY                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'									, 0 AS PACK_INTRANSIT                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'									, ''CMA'' AS STOCK_TYPE                                                                                                                                                                 ' + char(10)
		--SELECT @v_dSql += N'												FROM   SCM_STOCK_H_V A WITH(NOLOCK)' + char(10)
		--SELECT @v_dSql += N'														INNER JOIN ( --<V: LOOKUP에 STOCK POINT 참조 >--' + char(10)
		SELECT @v_dSql += N'												FROM   (' + char(10)
		SELECT @v_dSql += N'			    													SELECT B.LOOKUP_TYPE_CODE           ' + char(10)
		SELECT @v_dSql += N'			    															, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT         ' + char(10)
		SELECT @v_dSql += N'			    															, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS       ' + char(10)
		SELECT @v_dSql += N'			    													FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'			    													WHERE  B.ACTIVE_FLAG = ''Y''        ' + char(10)
		SELECT @v_dSql += N'			    													AND    B.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''' + char(10)
		SELECT @v_dSql += N'			    													AND    B.SEGMENT1         = ''IN_HOUSE_REQUEST''       ' + char(10)
		SELECT @v_dSql += N'														) V         ' + char(10)
		SELECT @v_dSql += N'														INNER HASH JOIN SCM_STOCK_H_V A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'															ON   1=1' + char(10)
		SELECT @v_dSql += N'															AND  A.DIVISION_ID		= V.DIVISION_ID     ' + char(10)
		SELECT @v_dSql += N'															AND  A.SITE_ID			= V.SITE_ID         ' + char(10)
		SELECT @v_dSql += N'															AND  A.PLANT_ID			= V.PLANT_ID        ' + char(10)
		SELECT @v_dSql += N'															AND  A.STOCK_TYPE		= V.STOCK_TYPE      ' + char(10)
		SELECT @v_dSql += N'															AND  A.OPERATION_ID		= V.STOCK_POINT     ' + char(10)
		SELECT @v_dSql += N'															AND  A.STOCK_STATUS		= V.STOCK_STATUS    ' + char(10)
		SELECT @v_dSql += N'															AND  V.PACK_BOH			= ''Y''' + char(10)
		SELECT @v_dSql += N'														LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)       ' + char(10)
		SELECT @v_dSql += N'														ON A.COMPANY_ID = B.COMPANY_ID     ' + char(10)
		SELECT @v_dSql += N'														AND A.DIVISION_ID = B.DIVISION_ID  ' + char(10)
		SELECT @v_dSql += N'														AND A.SITE_ID = B.SITE_ID' + char(10)
		SELECT @v_dSql += N'														AND A.PLANT_ID = B.PLANT_ID        ' + char(10)
		SELECT @v_dSql += N'														AND A.FACTORY_ID = B.FACTORY_ID    ' + char(10)
		SELECT @v_dSql += N'														--AND A.FP_APPLY_OPERATION_ID = B.OPERATION_ID  ' + char(10)
		SELECT @v_dSql += N'                                                        AND B.OPERATION_ID = (CASE WHEN A.PLANT_ID = ''' + @p_plant_id_cond + ''' THEN ''P5000'' ELSE ''P1000'' END)    ' + char(10)
		SELECT @v_dSql += N'														AND A.LINE_ID = B.LINE_ID' + char(10)
		SELECT @v_dSql += N'														AND B.ACTIVE_FLAG = ''Y''' + char(10)
		SELECT @v_dSql += N'												WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'												AND    A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''')    ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'									            --AND   A.OPERATION_ID = ''P1000''         ' + char(10)
		SELECT @v_dSql += N'									            --AND   A.STORAGE_ID  = ''MES''  ' + char(10)
		SELECT @v_dSql += N'									            --AND   A.STOCK_STATUS =  ''WAIT''         ' + char(10)
		SELECT @v_dSql += N'									            AND	  ( ISNULL(A.MODIFY_FP_APPLY_WIPQTY, 0) >=0 OR ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0 )            ' + char(10)
		SELECT @v_dSql += N'									            UNION ALL ' + char(10)
		SELECT @v_dSql += N'									            --INVENTORY 수량    ' + char(10)
		SELECT @v_dSql += N'									            SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, V.FACTORY_ID   ' + char(10)
		SELECT @v_dSql += N'															, A.FP_APPLY_ITEM_ID AS ITEM_ID, B.EXPORT_SLOC_ID     ' + char(10)
		SELECT @v_dSql += N'															, NULL AS MODIFY ' + char(10)
		SELECT @v_dSql += N'															, A.QTY2 AS QTY      ' + char(10)
		SELECT @v_dSql += N'															, NULL AS BOH_MODIFY       ' + char(10)
		SELECT @v_dSql += N'															, A.QTY2 AS BOH  ' + char(10)
		SELECT @v_dSql += N'															, NULL AS HOLD_MODIFY      ' + char(10)
		SELECT @v_dSql += N'															, A.DEFECT_QTY AS HOLD     ' + char(10)
		SELECT @v_dSql += N'															, 0 AS BOH_CELL_MODIFY     ' + char(10)
		SELECT @v_dSql += N'															, 0 AS BOH_CELL  ' + char(10)
		SELECT @v_dSql += N'															, 0 AS HOLD_CELL_MODIFY    ' + char(10)
		SELECT @v_dSql += N'															, 0 AS HOLD_CELL ' + char(10)
		SELECT @v_dSql += N'															, 0 AS PACK_INTRANSIT' + char(10)
		SELECT @v_dSql += N'															, ''CMA'' AS STOCK_TYPE        ' + char(10)
		--SELECT @v_dSql += N'												FROM   SCM_STOCK_H_V A WITH(NOLOCK)' + char(10)
		--SELECT @v_dSql += N'														INNER JOIN ( --<V: LOOKUP에 STOCK POINT 참조 >--' + char(10)
		SELECT @v_dSql += N'												FROM   ( ' + char(10)
		SELECT @v_dSql += N'			    													SELECT B.LOOKUP_TYPE_CODE           ' + char(10)
		SELECT @v_dSql += N'			    															, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT         ' + char(10)
		SELECT @v_dSql += N'			    															, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS       ' + char(10)
		SELECT @v_dSql += N'			    															, B.ATTRIBUTE6 AS FACTORY_ID, B.ATTRIBUTE7 AS LINE_ID    ' + char(10)
		SELECT @v_dSql += N'			    													FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'			    													WHERE  B.ACTIVE_FLAG = ''Y''        ' + char(10)
		SELECT @v_dSql += N'			    													AND    B.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''' + char(10)
		SELECT @v_dSql += N'			    													AND    B.SEGMENT1         = ''IN_HOUSE_REQUEST''       ' + char(10)
		SELECT @v_dSql += N'			    													AND    B.ATTRIBUTE1       = ''INVENTORY''     ' + char(10)
		SELECT @v_dSql += N'														) V         ' + char(10)
		SELECT @v_dSql += N'														INNER HASH JOIN SCM_STOCK_H_V A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'															ON   1=1' + char(10)
		SELECT @v_dSql += N'															AND  A.DIVISION_ID		= V.DIVISION_ID     ' + char(10)
		SELECT @v_dSql += N'															AND  A.SITE_ID			= V.SITE_ID         ' + char(10)
		SELECT @v_dSql += N'															AND  A.PLANT_ID			= V.PLANT_ID        ' + char(10)
		SELECT @v_dSql += N'															AND  A.STOCK_TYPE		= V.STOCK_TYPE      ' + char(10)
		SELECT @v_dSql += N'															AND  A.STORAGE_ID		= V.STOCK_POINT     ' + char(10)
		SELECT @v_dSql += N'															AND  V.PACK_BOH			= ''Y''' + char(10)
		SELECT @v_dSql += N'														LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)       ' + char(10)
		SELECT @v_dSql += N'														ON A.COMPANY_ID = B.COMPANY_ID     ' + char(10)
		SELECT @v_dSql += N'														AND A.DIVISION_ID = B.DIVISION_ID  ' + char(10)
		SELECT @v_dSql += N'														AND A.SITE_ID = B.SITE_ID' + char(10)
		SELECT @v_dSql += N'														AND A.PLANT_ID = B.PLANT_ID        ' + char(10)
		SELECT @v_dSql += N'														AND V.FACTORY_ID = B.FACTORY_ID    ' + char(10)
		SELECT @v_dSql += N'														--AND B.OPERATION_ID = ''P5000''   ' + char(10)
		SELECT @v_dSql += N'                                                        AND B.OPERATION_ID = (CASE WHEN A.PLANT_ID = ''' + @p_plant_id_cond + ''' THEN ''P5000'' ELSE ''P1000'' END)    ' + char(10)
		SELECT @v_dSql += N'														--AND A.FP_APPLY_OPERATION_ID = B.OPERATION_ID  ' + char(10)
		SELECT @v_dSql += N'														AND V.LINE_ID = B.LINE_ID' + char(10)
		SELECT @v_dSql += N'														AND B.ACTIVE_FLAG = ''Y''' + char(10)
		SELECT @v_dSql += N'												WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'												AND    A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''' )   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'									      UNION ALL       ' + char(10)
		SELECT @v_dSql += N'                        -- SSP 테이블 기준으로 변경.... 20210105    ' + char(10)
		SELECT @v_dSql += N'                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID         ' + char(10)
		SELECT @v_dSql += N'                             , A.ITEM_ID, A.TO_SLOC_ID AS EXPORT_SLOC_ID         ' + char(10)
		SELECT @v_dSql += N'                             , 0 AS MODIFY   ' + char(10)
		SELECT @v_dSql += N'                             , 0 AS QTY' + char(10)
		SELECT @v_dSql += N'                             , 0 AS BOH_MODIFY        ' + char(10)
		SELECT @v_dSql += N'                             , 0 AS BOH      ' + char(10)
		SELECT @v_dSql += N'                             , 0 AS HOLD_MODIFY       ' + char(10)
		SELECT @v_dSql += N'                             , 0 AS HOLD     ' + char(10)
		SELECT @v_dSql += N'                             , 0 AS BOH_CELL_MODIFY   ' + char(10)
		SELECT @v_dSql += N'                             , 0 AS BOH_CELL ' + char(10)
		SELECT @v_dSql += N'                             , 0 AS HOLD_CELL_MODIFY  ' + char(10)
		SELECT @v_dSql += N'                             , 0 AS HOLD_CELL' + char(10)
		SELECT @v_dSql += N'                             , A.PACK_MOVE_QTY AS PACK_INTRANSIT    ' + char(10)
		SELECT @v_dSql += N'                             , ''INTRNASIT'' AS STOCK_TYPE' + char(10)
		SELECT @v_dSql += N'                        FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'                        WHERE  1=1     ' + char(10)
		SELECT @v_dSql += N'                        AND    A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''')     ' + char(10)
		SELECT @v_dSql += N'                        AND    A.PACK_MOVE_QTY > 0        ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'							) A        ' + char(10)
		SELECT @v_dSql += N'							WHERE 1=1  ' + char(10)
		SELECT @v_dSql += N'							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.EXPORT_SLOC_ID, A.STOCK_TYPE  ' + char(10)
		SELECT @v_dSql += N'					) A   ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V H WITH(NOLOCK) ' + char(10) -- cell assy code 추가... 20230608
		SELECT @v_dSql += N'			ON  A.COMPANY_ID  = H.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.DIVISION_ID = H.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID     = H.SITE_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.ITEM_ID 	  = H.CELL_ASSY_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'			WHERE 1=1     ' + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID), A.EXPORT_SLOC_ID	--, A.STOCK_TYPE   ' + char(10) -- cell assy code 추가... 20230608
		--SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.EXPORT_SLOC_ID	--, A.STOCK_TYPE   ' + char(10)
		SELECT @v_dSql += N'			UNION ALL     ' + char(10)
		SELECT @v_dSql += N'			-- CELL     ' + char(10)
		--SELECT @v_dSql += N'			SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.EXPORT_SLOC_ID, ''CELL'' AS STOCK_TYPE	--, A.STOCK_TYPE      ' + char(10)
		SELECT @v_dSql += N'			SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID) AS ITEM_ID, A.EXPORT_SLOC_ID, ''CELL'' AS STOCK_TYPE	--, A.STOCK_TYPE      ' + char(10) -- cell assy code 추가... 20230608
		SELECT @v_dSql += N'						, SUM(QTY) AS QTY        ' + char(10)
		SELECT @v_dSql += N'						, SUM(AVAIL) +  SUM(HOLD) AS TOTAL           ' + char(10)
		SELECT @v_dSql += N'						, SUM(AVAIL) AS AVAIL     ' + char(10)
		SELECT @v_dSql += N'						, SUM(HOLD) AS HOLD       ' + char(10)
		SELECT @v_dSql += N'						, SUM(AVAIL_CELL) +  SUM(HOLD_CELL) + SUM(AVAIL_CELL_LONG_QTY) + SUM(HOLD_CELL_LONG_QTY) AS TOTAL_CELL      ' + char(10)
		SELECT @v_dSql += N'						, SUM(AVAIL_CELL) AS AVAIL_CELL     ' + char(10)
		SELECT @v_dSql += N'						, SUM(HOLD_CELL) AS HOLD_CELL       ' + char(10)
		SELECT @v_dSql += N'						, SUM(AVAIL_CELL_LONG_QTY) AS AVAIL_CELL_LONG_QTY		' + char(10)
		SELECT @v_dSql += N'						, SUM(HOLD_CELL_LONG_QTY) AS HOLD_CELL_LONG_QTY			' + char(10)
		SELECT @v_dSql += N'						, SUM(PACK_INTRANSIT) AS INTRANSIT' + char(10)
		SELECT @v_dSql += N'			FROM		( ' + char(10)
		SELECT @v_dSql += N'							SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID AS ITEM_ID, A.EXPORT_SLOC_ID--, A.STOCK_TYPE' + char(10)
		-- modify qty 보지 않아서 수정
		--SELECT @v_dSql += N'										, ISNULL(MAX(MODIFY), SUM(A.QTY)) AS QTY       ' + char(10)
		--SELECT @v_dSql += N'										, ISNULL(ISNULL(MAX(BOH_MODIFY), SUM(A.BOH)),0) AS AVAIL      ' + char(10)
		--SELECT @v_dSql += N'										, ISNULL(ISNULL(MAX(HOLD_MODIFY), SUM(A.HOLD)),0) AS HOLD     ' + char(10)
		--SELECT @v_dSql += N'										, ISNULL(ISNULL(MAX(BOH_CELL_MODIFY), SUM(A.BOH_CELL)),0) AS AVAIL_CELL' + char(10)
		--SELECT @v_dSql += N'										, ISNULL(ISNULL(MAX(HOLD_CELL_MODIFY), SUM(A.HOLD_CELL)),0) AS HOLD_CELL         ' + char(10)
		--SELECT @v_dSql += N'										, ISNULL(MAX(AVAIL_CELL_LONG_QTY),0) AS AVAIL_CELL_LONG_QTY         ' + char(10)
		--SELECT @v_dSql += N'										, ISNULL(MAX(HOLD_CELL_LONG_QTY),0) AS HOLD_CELL_LONG_QTY	         ' + char(10)
		--SELECT @v_dSql += N'										, ISNULL(SUM(A.PACK_INTRANSIT),0) AS PACK_INTRANSIT' + char(10)
		SELECT @v_dSql += N'										, ISNULL(SUM(A.QTY),0) AS QTY       ' + char(10)
		SELECT @v_dSql += N'										, ISNULL(SUM(A.BOH),0) AS AVAIL      ' + char(10)
		SELECT @v_dSql += N'										, ISNULL(SUM(A.HOLD),0) AS HOLD     ' + char(10)
		SELECT @v_dSql += N'										, ISNULL(SUM(A.BOH_CELL),0) AS AVAIL_CELL' + char(10)
		SELECT @v_dSql += N'										, ISNULL(SUM(A.HOLD_CELL),0) AS HOLD_CELL         ' + char(10)
		SELECT @v_dSql += N'										, ISNULL(SUM(AVAIL_CELL_LONG_QTY),0) AS AVAIL_CELL_LONG_QTY         ' + char(10)
		SELECT @v_dSql += N'										, ISNULL(SUM(HOLD_CELL_LONG_QTY),0) AS HOLD_CELL_LONG_QTY	         ' + char(10)
		--SELECT @v_dSql += N'										, ISNULL(MAX(AVAIL_CELL_LONG_QTY),0) AS AVAIL_CELL_LONG_QTY         ' + char(10)
		--SELECT @v_dSql += N'										, ISNULL(MAX(HOLD_CELL_LONG_QTY),0) AS HOLD_CELL_LONG_QTY	         ' + char(10)
		SELECT @v_dSql += N'										, ISNULL(SUM(A.PACK_INTRANSIT),0) AS PACK_INTRANSIT' + char(10)
		SELECT @v_dSql += N'							FROM		(        ' + char(10)
		SELECT @v_dSql += N'												SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID   ' + char(10)
		SELECT @v_dSql += N'															, A.FP_APPLY_ITEM_ID AS ITEM_ID, B.EXPORT_SLOC_ID     ' + char(10)
		SELECT @v_dSql += N'															, CASE WHEN '''+ @p_instance_id +''' = ''PL_PACK'' THEN 0 ELSE A.MODIFY_FP_APPLY_WIPQTY END AS MODIFY  ' + char(10)
		SELECT @v_dSql += N'															, CASE WHEN '''+ @p_instance_id +''' = ''PL_PACK'' THEN 0 ELSE A.FP_APPLY_WIPQTY END AS QTY      ' + char(10)
		SELECT @v_dSql += N'															, 0 AS BOH_MODIFY' + char(10)
		SELECT @v_dSql += N'															, 0 AS BOH       ' + char(10)
		SELECT @v_dSql += N'															, 0 AS HOLD_MODIFY         ' + char(10)
		SELECT @v_dSql += N'															, 0 AS HOLD      ' + char(10)
		--SELECT @v_dSql += N'															, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS BOH_CELL_MODIFY    ' + char(10)
		--SELECT @v_dSql += N'															, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y'' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS BOH_CELL        ' + char(10)
		--SELECT @v_dSql += N'															, CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_CELL_MODIFY          ' + char(10)
		--SELECT @v_dSql += N'															, CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.FP_APPLY_WIPQTY ELSE NULL END AS HOLD_CELL ' + char(10)
		--SELECT @v_dSql += N'															, 0 AS AVAIL_CELL_LONG_QTY		' + char(10)
		--SELECT @v_dSql += N'															, 0 AS HOLD_CELL_LONG_QTY		' + char(10)
		--SELECT @v_dSql += N'															, 0 AS PACK_INTRANSIT			' + char(10)
		SELECT @v_dSql += N'														, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND  ISNULL(WIPHOLD_YN,''N'') < > ''Y'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y'' AND  A.QLTY_NO_INSP_FLAG != ''Y'' AND A.LONG_TERM_FLAG !=  ''Y'' ' + char(10) 
		SELECT @v_dSql += N'				    											THEN A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS BOH_CELL_MODIFY                               																										   								   ' + char(10)
		SELECT @v_dSql += N'														, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND  ISNULL(WIPHOLD_YN,''N'') < > ''Y'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y'' AND  A.QLTY_NO_INSP_FLAG != ''Y'' AND A.LONG_TERM_FLAG !=  ''Y'' ' + char(10) 
		SELECT @v_dSql += N'				    											THEN A.FP_APPLY_WIPQTY  ELSE NULL END AS BOH_CELL                               																										   								   ' + char(10)
		SELECT @v_dSql += N'														, CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_CELL_MODIFY          																															   ' + char(10)
		SELECT @v_dSql += N'														, CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.FP_APPLY_WIPQTY ELSE NULL END AS HOLD_CELL 																																				   ' + char(10)
		SELECT @v_dSql += N'														, CASE WHEN ISNULL(A.LONG_TERM_FLAG, ''N'') = ''Y'' AND ISNULL(WIPHOLD_YN,''N'') != ''Y'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y'' THEN A.FP_APPLY_WIPQTY  ELSE NULL END  AS AVAIL_CELL_LONG_QTY										   ' + char(10)
		SELECT @v_dSql += N'														, CASE WHEN ISNULL(A.LONG_TERM_FLAG, ''N'') = ''Y'' AND ISNULL(WIPHOLD_YN,''N'') = ''Y'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y'' THEN A.FP_APPLY_WIPQTY  ELSE NULL END AS HOLD_CELL_LONG_QTY											   ' + char(10)
		SELECT @v_dSql += N'														, CASE WHEN ISNULL(A.PACK_MOVE_FLAG, ''N'') = ''Y'' AND ISNULL(WIPHOLD_YN,''N'') != ''Y'' THEN A.QTY2 ELSE NULL END AS PACK_INTRANSIT																									   ' + char(10)
		SELECT @v_dSql += N'															, ''CELL'' AS STOCK_TYPE       ' + char(10)
		--SELECT @v_dSql += N'												FROM   SCM_STOCK_H_V A WITH(NOLOCK)' + char(10)
		--SELECT @v_dSql += N'												INNER JOIN ( --<V: LOOKUP에 STOCK POINT 참조 >--        ' + char(10)
		--SELECT @v_dSql += N'	    													SELECT B.LOOKUP_TYPE_CODE      ' + char(10)
		--SELECT @v_dSql += N'	    															 , B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT      ' + char(10)
		--SELECT @v_dSql += N'	    															 , B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS    ' + char(10)
		--SELECT @v_dSql += N'	    													FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK) ' + char(10)
		--SELECT @v_dSql += N'	    													WHERE  B.ACTIVE_FLAG = ''Y''   ' + char(10)
		--SELECT @v_dSql += N'	    													AND    B.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''        ' + char(10)
		--SELECT @v_dSql += N'	    													AND    B.SEGMENT1         = ''IN_HOUSE_REQUEST''      ' + char(10)
		--SELECT @v_dSql += N'												) V       ' + char(10)
		--SELECT @v_dSql += N'												ON   1=1  ' + char(10)
		--SELECT @v_dSql += N'												AND  A.DIVISION_ID		= V.DIVISION_ID    ' + char(10)
		--SELECT @v_dSql += N'												AND  A.SITE_ID			= V.SITE_ID        ' + char(10)
		--SELECT @v_dSql += N'												AND  A.PLANT_ID			= V.PLANT_ID       ' + char(10)
		--SELECT @v_dSql += N'												AND  A.STOCK_TYPE		= V.STOCK_TYPE     ' + char(10)
		--SELECT @v_dSql += N'												AND  A.STORAGE_ID		= V.STOCK_POINT    ' + char(10)
		--SELECT @v_dSql += N'												AND  V.CELL_BOH			= ''Y''  ' + char(10)
		SELECT @v_dSql += N'												FROM ( --<V: LOOKUP에 STOCK POINT 참조 >--        ' + char(10)
		SELECT @v_dSql += N'	    													SELECT B.LOOKUP_TYPE_CODE      ' + char(10)
		SELECT @v_dSql += N'	    															 , B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT      ' + char(10)
		SELECT @v_dSql += N'	    															 , B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS    ' + char(10)
		SELECT @v_dSql += N'	    													FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	    													WHERE  B.ACTIVE_FLAG = ''Y''   ' + char(10)
		SELECT @v_dSql += N'	    													AND    B.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''        ' + char(10)
		SELECT @v_dSql += N'	    													AND    B.SEGMENT1         = ''IN_HOUSE_REQUEST''      ' + char(10)
		SELECT @v_dSql += N'												) V       ' + char(10)
		SELECT @v_dSql += N'												INNER HASH JOIN SCM_STOCK_H_V A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'												ON   1=1  ' + char(10)
		SELECT @v_dSql += N'												AND  A.DIVISION_ID		= V.DIVISION_ID    ' + char(10)
		SELECT @v_dSql += N'												AND  A.SITE_ID			= V.SITE_ID        ' + char(10)
		SELECT @v_dSql += N'												AND  A.PLANT_ID			= V.PLANT_ID       ' + char(10)
		SELECT @v_dSql += N'												AND  A.STOCK_TYPE		= V.STOCK_TYPE     ' + char(10)
		SELECT @v_dSql += N'												AND  A.OPERATION_ID		= V.STOCK_POINT    ' + char(10)
		SELECT @v_dSql += N'												--AND  A.STOCK_STATUS		= V.STOCK_STATUS    ' + char(10)
		SELECT @v_dSql += N'												AND  V.CELL_BOH			= ''Y''  ' + char(10)
		SELECT @v_dSql += N'												LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)  ' + char(10)
		SELECT @v_dSql += N'												ON  A.COMPANY_ID = B.COMPANY_ID  ' + char(10)
		SELECT @v_dSql += N'												AND A.DIVISION_ID = B.DIVISION_ID' + char(10)
		SELECT @v_dSql += N'												AND A.SITE_ID = B.SITE_ID        ' + char(10)
		SELECT @v_dSql += N'												AND A.PLANT_ID = B.PLANT_ID      ' + char(10)
		SELECT @v_dSql += N'												AND A.FACTORY_ID = B.FACTORY_ID  ' + char(10)
		SELECT @v_dSql += N'												--AND A.FP_APPLY_OPERATION_ID = B.OPERATION_ID          ' + char(10)
		SELECT @v_dSql += N'                                                AND B.OPERATION_ID = (CASE WHEN A.PLANT_ID = ''' + @p_plant_id_cond + ''' THEN ''P5000'' ELSE ''P1000'' END)    ' + char(10)
		SELECT @v_dSql += N'												AND A.LINE_ID = B.LINE_ID        ' + char(10)
		SELECT @v_dSql += N'												AND B.ACTIVE_FLAG = ''Y''        ' + char(10)
		SELECT @v_dSql += N'												WHERE  1=1' + char(10)
		SELECT @v_dSql += N'												AND    A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''')   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'						            --AND	  A.STOCK_TYPE = ''DW'' ' + char(10)
		SELECT @v_dSql += N'												--AND   A.STORAGE_ID  = ''-''    ' + char(10)
		SELECT @v_dSql += N'												AND	  ( ISNULL(A.MODIFY_FP_APPLY_WIPQTY, 0) >=0 OR ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0 )            ' + char(10)
		SELECT @v_dSql += N'												-- DW 재고가 아닌 조건           ' + char(10)
		SELECT @v_dSql += N'												AND NOT EXISTS (    ' + char(10)
		SELECT @v_dSql += N'  																	SELECT	1        ' + char(10)
		SELECT @v_dSql += N'  																	FROM	(' + char(10)
		SELECT @v_dSql += N'  																				SELECT ''DW'' AS STOCK_TYPE, ''-'' AS STORAGE_ID        ' + char(10)
		SELECT @v_dSql += N'                            															, (' + char(10)
		SELECT @v_dSql += N'                              																	SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = ''SSP'' THEN 1 ELSE 0 END), 1) AS IS_SSP' + char(10)
		SELECT @v_dSql += N'                              																	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)         ' + char(10)
		SELECT @v_dSql += N'                              																	WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_STOCK_SOURCE''           ' + char(10)
		SELECT @v_dSql += N'                              																	AND    A.ACTIVE_FLAG = ''Y''' + char(10)
		SELECT @v_dSql += N'                              																	AND    A.SEGMENT1 = '''+ @p_instance_id +'''        ' + char(10)
		SELECT @v_dSql += N'                            																) AS IS_SSP  ' + char(10)
		SELECT @v_dSql += N'  																			) AA  ' + char(10)
		SELECT @v_dSql += N'  																	WHERE A.STOCK_TYPE = AA.STOCK_TYPE     ' + char(10)
		SELECT @v_dSql += N'  																	AND   A.STORAGE_ID = AA.STORAGE_ID     ' + char(10)
		SELECT @v_dSql += N'  																	AND   1 = AA.IS_SSP            ' + char(10)
		SELECT @v_dSql += N'																)' + char(10)
		
		SELECT @v_dSql += N'												UNION ALL ' + char(10)
		SELECT @v_dSql += N'												-- SSP 재고 추가    ' + char(10)
		SELECT @v_dSql += N'												SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, NULL AS EXPORT_SLOC_ID  ' + char(10)
		SELECT @v_dSql += N'												  		, A.QTY AS MODIFY_QTY, A.QTY																									' + char(10)
  		SELECT @v_dSql += N'														, 0 AS BOH_MODIFY_QTY																											' + char(10)
  		SELECT @v_dSql += N'														, 0 AS BOH_QTY																													' + char(10)
  		SELECT @v_dSql += N'														, 0 AS HOLD_MODIFY_QTY																											' + char(10)
  		SELECT @v_dSql += N'														, 0 AS HOLD_QTY																													' + char(10)
  		SELECT @v_dSql += N'														, A.AVAIL_CELL_QTY AS BOH_CELL_MODIFY_QTY																						' + char(10)
  		SELECT @v_dSql += N'														, A.AVAIL_CELL_QTY AS BOH_CELL_QTY																								' + char(10)
  		SELECT @v_dSql += N'														, A.HOLD_CELL_QTY AS HOLD_CELL_MODIFY_QTY																						' + char(10)
  		SELECT @v_dSql += N'														, A.HOLD_CELL_QTY AS HOLD_CELL_QTY																								' + char(10)
  		SELECT @v_dSql += N'														, A.AVAIL_CELL_LONG_QTY																											' + char(10)
  		SELECT @v_dSql += N'														, A.HOLD_CELL_LONG_QTY																											' + char(10)
  		SELECT @v_dSql += N'														, 0 AS PACK_INTRANSIT																											' + char(10)
  		SELECT @v_dSql += N'														, ''CELL'' AS STOCK_TYPE																											' + char(10)
		SELECT @v_dSql += N'												FROM (																																	' + char(10)
		SELECT @v_dSql += N'														SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID												' + char(10)
  		SELECT @v_dSql += N'																, SUM(CASE WHEN HOLD = ''N'' AND LONG_TERM_FLAG = ''N'' AND '+@p_is_ssp+' = 1 THEN QTY ELSE 0 END) AS AVAIL_CELL_QTY -- 가용, 노장기			   ' + char(10)
  		SELECT @v_dSql += N'																, SUM(CASE WHEN HOLD = ''N'' AND LONG_TERM_FLAG != ''N'' THEN QTY ELSE 0  END) AS AVAIL_CELL_LONG_QTY  -- 가용, 장기		' + char(10)
  		SELECT @v_dSql += N'																, SUM(CASE WHEN HOLD != ''N'' AND LONG_TERM_FLAG = ''N'' AND '+@p_is_ssp+' = 1 THEN QTY ELSE 0  END) AS HOLD_CELL_QTY     -- 비가용, 노장기		  ' + char(10)
  		SELECT @v_dSql += N'																, SUM(CASE WHEN HOLD != ''N'' AND LONG_TERM_FLAG != ''N'' THEN QTY ELSE 0  END) AS HOLD_CELL_LONG_QTY      -- 비가용, 장기  ' + char(10)
  		SELECT @v_dSql += N'																, SUM(CASE WHEN '+@p_is_ssp+' = 1 THEN QTY ELSE 0 END) AS QTY -- 전체																								  ' + char(10)
		SELECT @v_dSql += N'														FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK)																						' + char(10)
		SELECT @v_dSql += N'														WHERE  1=1																														' + char(10)
		SELECT @v_dSql += N'    													AND   A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''') ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'    													AND   A.QTY > 0 ' + char(10)
		SELECT @v_dSql += N'    													GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'    										) A  ' + char(10)
		SELECT @v_dSql += N'    										--GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID     ' + char(10)
		
		SELECT @v_dSql += N'							) A        ' + char(10)
		SELECT @v_dSql += N'							WHERE 1=1  ' + char(10)
		SELECT @v_dSql += N'							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.EXPORT_SLOC_ID, A.STOCK_TYPE  ' + char(10)
		SELECT @v_dSql += N'					) A   ' + char(10)
		SELECT @v_dSql += N'					LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V H WITH(NOLOCK) ' + char(10) -- cell assy code 추가... 20230608
		SELECT @v_dSql += N'					ON  A.COMPANY_ID  = H.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'					AND A.DIVISION_ID = H.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'					AND A.SITE_ID     = H.SITE_ID ' + char(10)
		SELECT @v_dSql += N'					AND A.ITEM_ID 	  = H.CELL_ASSY_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'			WHERE 1=1     ' + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(H.CELL_PRODUCT_ITEM_ID, A.ITEM_ID), A.EXPORT_SLOC_ID	--, A.STOCK_TYPE   ' + char(10) -- cell assy code 추가... 20230608
		--SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.EXPORT_SLOC_ID	--, A.STOCK_TYPE   ' + char(10)
		--SELECT @v_dSql += N'	)           ' + char(10)
		
		
		--SELECT @v_dSql += N'	, MAIN_S AS (         ' + char(10)
		SELECT @v_dSql += N'        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID   ' + char(10)
		SELECT @v_dSql += N'             , A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME, A.CELL_ITEM_ID, ISNULL(C.NICK_NAME,''-'') AS CELL_NICK_NAME        ' + char(10)
		SELECT @v_dSql += N'             , NULL AS BOH_QTY         ' + char(10)
		SELECT @v_dSql += N'             , NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY            ' + char(10)
		SELECT @v_dSql += N'             , NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY       ' + char(10)
		SELECT @v_dSql += N'             , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY       ' + char(10)
		SELECT @v_dSql += N'             , NULL AS INTRANSIT       ' + char(10)
		SELECT @v_dSql += N'             , A.BOM_RATE ' + char(10)
		SELECT @v_dSql += N'             , A.STORAGE_ID            ' + char(10)
		SELECT @v_dSql += N'             , ''P(CMA)'' AS PSI, CONVERT(NVARCHAR(60), A.SOC_ID) AS SOC_ID, A.MARKET      ' + char(10)

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

					SELECT @v_dSql += N'      			, SUM(CASE WHEN D.YYYYMM = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE WHEN D.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

		SELECT @v_dSql += N'             , ''S'' AS CATEGORY_ID, 100 AS CATEGORY_ORDER' + char(10)
		SELECT @v_dSql += N'             , ''DATA'' AS DATA_TYPE   ' + char(10)
		SELECT @v_dSql += N'        INTO    #TEMP_TABLE_MAIN_S ' + char(10)
		SELECT @v_dSql += N'        FROM (  ' + char(10)
		--SELECT @v_dSql += N'					SELECT * FROM 	#TEMP_TABLE_02	   ' + char(10)
		--SELECT @v_dSql += N'					WHERE	1=1        ' + char(10)
		SELECT @v_dSql += @v_tempSql
		SELECT @v_dSql += N'   ' + char(10)
		SELECT @v_dSql += N'	        ) A ' + char(10)
		SELECT @v_dSql += N'	        INNER JOIN SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	        ON  1=1     ' + char(10)
		SELECT @v_dSql += N'			AND	B.SITE_ID = '''+ @p_inner_site_id +'''       ' + char(10)
		SELECT @v_dSql += N'			AND	A.COMPANY_ID  = B.COMPANY_ID     ' + char(10)
		SELECT @v_dSql += N'	        AND A.DIVISION_ID = B.DIVISION_ID    ' + char(10)
		SELECT @v_dSql += N'	        AND A.SITE_ID     = B.SITE_ID        ' + char(10)
		SELECT @v_dSql += N'	        AND A.ITEM_ID     = B.ITEM_ID        ' + char(10)
		SELECT @v_dSql += N'	        AND B.ACTIVE_FLAG = ''Y''  ' + char(10)
		SELECT @v_dSql += N'	        LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK)     ' + char(10)
		SELECT @v_dSql += N'	        ON  1=1     ' + char(10)
		SELECT @v_dSql += N'			AND	C.SITE_ID = '''+ @p_inner_site_id +'''       ' + char(10)
		SELECT @v_dSql += N'			AND	A.COMPANY_ID  = C.COMPANY_ID     ' + char(10)
		SELECT @v_dSql += N'	        AND A.DIVISION_ID = C.DIVISION_ID    ' + char(10)
		SELECT @v_dSql += N'	        AND A.SITE_ID     = C.SITE_ID        ' + char(10)
		SELECT @v_dSql += N'	        AND A.CELL_ITEM_ID = C.ITEM_ID       ' + char(10)
		SELECT @v_dSql += N'	        AND C.ACTIVE_FLAG = ''Y''  ' + char(10)
		SELECT @v_dSql += N'	        INNER HASH JOIN TH_UIS_CAL D WITH(NOLOCK)     ' + char(10)
		SELECT @v_dSql += N'	        ON  A.PLAN_DATE   = D.YYYYMMDD       ' + char(10)
		SELECT @v_dSql += N'	        WHERE 1=1     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'EQ', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID          ' + char(10)
		SELECT @v_dSql += N'	               , A.ITEM_ID, ISNULL(B.NICK_NAME,''-''), A.CELL_ITEM_ID, ISNULL(C.NICK_NAME,''-'')    ' + char(10)
		SELECT @v_dSql += N'	               , A.STORAGE_ID, A.SOC_ID, A.MARKET, A.BOM_RATE   ' + char(10)
		--SELECT @v_dSql += N'      )         ' + char(10)
		--SELECT @v_dSql += N'      , MAIN_P AS (       ' + char(10)
		SELECT @v_dSql += N'        	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID            ' + char(10)
		SELECT @v_dSql += N'	             , CONVERT(NVARCHAR(300), NULL) AS ITEM_ID, CONVERT(NVARCHAR(100), NULL) AS NICK_NAME, A.CELL_ITEM_ID, A.CELL_NICK_NAME    ' + char(10)
		SELECT @v_dSql += N'	             --, ISNULL(D.QTY,0) AS BOH  ' + char(10)
		SELECT @v_dSql += N'	             , ISNULL(D.QTY,0) AS BOH_QTY, ISNULL(D.TOTAL_QTY,0) AS TOTAL_QTY, ISNULL(D.AVAIL_QTY,0) AS AVAIL_QTY, ISNULL(D.HOLD_QTY,0) AS HOLD_QTY    ' + char(10)
		SELECT @v_dSql += N'	             , ISNULL(F.TOTAL_CELL_QTY,0) AS TOTAL_CELL_QTY, ISNULL(F.AVAIL_CELL_QTY,0) AS AVAIL_CELL_QTY, ISNULL(F.HOLD_CELL_QTY,0) AS HOLD_CELL_QTY   ' + char(10)
		SELECT @v_dSql += N'	             , ISNULL(F.AVAIL_CELL_LONG_QTY,0) AS AVAIL_CELL_LONG_QTY, ISNULL(F.HOLD_CELL_LONG_QTY,0) AS HOLD_CELL_LONG_QTY		' + char(10)
		SELECT @v_dSql += N'				 , ISNULL(D.INTRANSIT,0) AS INTRANSIT     ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS BOM_RATE    ' + char(10)
		SELECT @v_dSql += N'	             , A.STORAGE_ID, ''R(Cell Req.)'' AS PSI, A.SOC_ID, A.MARKET     ' + char(10)

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

					SELECT @v_dSql += N'      			, SUM(CASE WHEN E.YYYYMM = ''' + @sub_param_0 + ''' THEN (CASE WHEN A.SOC_ID = DD.SOC_ID THEN A.QTY ELSE 0 END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'      			, SUM(CASE WHEN E.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN (CASE WHEN A.SOC_ID = DD.SOC_ID THEN A.QTY ELSE 0 END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN (CASE WHEN A.SOC_ID = DD.SOC_ID THEN A.QTY ELSE 0 END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	             , ''P'' AS CATEGORY_ID, DD.SORT_ORDER AS CATEGORY_ORDER         ' + char(10)
		SELECT @v_dSql += N'	             , ''DATA'' AS DATA_TYPE         ' + char(10)
		SELECT @v_dSql += N'	        INTO    #TEMP_TABLE_MAIN_P ' + char(10)
		SELECT @v_dSql += N'	        FROM (        ' + char(10)
		SELECT @v_dSql += N'					          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID    ' + char(10)
		SELECT @v_dSql += N'				                   , NULL AS ITEM_ID, A.CELL_ITEM_ID, ISNULL(C.NICK_NAME,''-'') AS CELL_NICK_NAME ' + char(10)
		SELECT @v_dSql += N'				                   , A.STORAGE_ID, A.SOC_ID, A.MARKET            ' + char(10)
		SELECT @v_dSql += N'				                   , CONVERT(VARCHAR,A.REQUIRE_DATE,112) AS PLAN_DATE, A.REQUIRE_QTY AS QTY       ' + char(10)
		SELECT @v_dSql += N'					          FROM   FP_DEMAND_PACK_REQUIRE_CELL_H A WITH(NOLOCK)' + char(10)
		SELECT @v_dSql += N'					          		INNER JOIN SCM_ITEM_M C WITH(NOLOCK)         ' + char(10)
		SELECT @v_dSql += N'									ON  1=1     ' + char(10)
		SELECT @v_dSql += N'									AND	C.SITE_ID = '''+ @p_inner_site_id +'''       ' + char(10)
		SELECT @v_dSql += N'									AND	A.COMPANY_ID  = C.COMPANY_ID     ' + char(10)
		SELECT @v_dSql += N'							        AND A.DIVISION_ID  = C.DIVISION_ID           ' + char(10)
		SELECT @v_dSql += N'							        AND A.SITE_ID      = C.SITE_ID  ' + char(10)
		SELECT @v_dSql += N'							        AND A.CELL_ITEM_ID = C.ITEM_ID  ' + char(10)
		SELECT @v_dSql += N'							        AND C.ACTIVE_FLAG  = ''Y''      ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'EQ', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'					          WHERE  1=1         ' + char(10)
		SELECT @v_dSql += N'					          AND	 A.INSTANCE_ID = '''+ @p_instance_id +'''  ' + char(10)
		SELECT @v_dSql += N'					          AND	 A.PLAN_ID = '''+ @p_plan_id +'''' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'					          AND A.REQUIRE_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ITEM_ID' , 'LIKE', @p_cell_item_id)) + char(10)
		SELECT @v_dSql += N'					          UNION ALL' + char(10)
		SELECT @v_dSql += N'					          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID    ' + char(10)
		SELECT @v_dSql += N'				                   , NULL AS ITEM_ID, A.ITEM_ID AS CELL_ITEM_ID, ISNULL(C.NICK_NAME,''-'') AS CELL_NICK_NAME         ' + char(10)
		SELECT @v_dSql += N'				                   , A.STORAGE_ID, A.SOC_ID, A.MARKET            ' + char(10)
		SELECT @v_dSql += N'				                   , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.QTY AS QTY        ' + char(10)
		SELECT @v_dSql += N'					          FROM   FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)       ' + char(10)
		SELECT @v_dSql += N'					          		INNER JOIN SCM_ITEM_M C WITH(NOLOCK)         ' + char(10)
		SELECT @v_dSql += N'									ON  1=1     ' + char(10)
		SELECT @v_dSql += N'									AND	C.SITE_ID = '''+ @p_inner_site_id +'''       ' + char(10)
		SELECT @v_dSql += N'									AND	A.COMPANY_ID  = C.COMPANY_ID     ' + char(10)
		SELECT @v_dSql += N'							        AND A.DIVISION_ID  = C.DIVISION_ID           ' + char(10)
		SELECT @v_dSql += N'							        AND A.SITE_ID      = C.SITE_ID  ' + char(10)
		SELECT @v_dSql += N'							        AND A.ITEM_ID	   = C.ITEM_ID  ' + char(10)
		SELECT @v_dSql += N'							        AND C.ACTIVE_FLAG  = ''Y''      ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'EQ', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'					          WHERE 1=1' + char(10)
		SELECT @v_dSql += N'					          AND    A.CATEGORY = ''REQUEST''       ' + char(10)
		SELECT @v_dSql += N'					          AND	 A.INSTANCE_ID = '''+ @p_instance_id +'''  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'					          AND A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND DATEADD(DAY, -1, CONVERT(DATETIME,'''+ @p_plan_date +''') )        ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_cell_item_id)) + char(10)
		SELECT @v_dSql += N'			        ) A   ' + char(10)
		SELECT @v_dSql += N'			        INNER JOIN (       ' + char(10)
		SELECT @v_dSql += N'			          SELECT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID, A.SEGMENT3 AS SOC_ID, ATTRIBUTE3 AS SORT_ORDER        ' + char(10)
		SELECT @v_dSql += N'			          FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)    ' + char(10)
		SELECT @v_dSql += N'			          WHERE  A.LOOKUP_TYPE_CODE = ''PACK_SOC''      ' + char(10)
		SELECT @v_dSql += N'			          AND    A.ACTIVE_FLAG = ''Y''        ' + char(10)
		SELECT @v_dSql += N'			        ) DD  ' + char(10)
		SELECT @v_dSql += N'			        ON  A.DIVISION_ID = DD.DIVISION_ID    ' + char(10)
		SELECT @v_dSql += N'			        AND A.SITE_ID     = DD.SITE_ID        ' + char(10)
		SELECT @v_dSql += N'			        AND A.SOC_ID      = DD.SOC_ID' + char(10)
		SELECT @v_dSql += N'			        INNER HASH JOIN TH_UIS_CAL E WITH(NOLOCK)       ' + char(10)
		SELECT @v_dSql += N'			        ON  A.PLAN_DATE   = E.YYYYMMDD        ' + char(10)
		SELECT @v_dSql += N'		        	LEFT OUTER HASH JOIN (       ' + char(10)
		SELECT @v_dSql += N'							SELECT 	*  ' + char(10)
		SELECT @v_dSql += N'							FROM 	#TEMP_TABLE_STOCK_T AS A ' + char(10)
		SELECT @v_dSql += N'							WHERE	A.STOCK_TYPE = ''PACK''         ' + char(10)
		SELECT @v_dSql += N'			        ) D   ' + char(10)
		SELECT @v_dSql += N'			        ON  A.COMPANY_ID   = D.COMPANY_ID     ' + char(10)
		SELECT @v_dSql += N'			        AND A.DIVISION_ID  = D.DIVISION_ID    ' + char(10)
		SELECT @v_dSql += N'			        AND A.SITE_ID      = D.SITE_ID        ' + char(10)
		SELECT @v_dSql += N'			        AND A.PLANT_ID     = D.PLANT_ID       ' + char(10)
		SELECT @v_dSql += N'			        AND A.CELL_ITEM_ID = D.ITEM_ID        ' + char(10)
		SELECT @v_dSql += N'			        AND A.STORAGE_ID   = D.EXPORT_SLOC_ID ' + char(10)
		SELECT @v_dSql += N'			        LEFT OUTER HASH JOIN (       ' + char(10)
		SELECT @v_dSql += N'							SELECT 	*  ' + char(10)
		SELECT @v_dSql += N'							FROM 	#TEMP_TABLE_STOCK_T AS A ' + char(10)
		SELECT @v_dSql += N'							WHERE	A.STOCK_TYPE = ''CELL''         ' + char(10)
		SELECT @v_dSql += N'			        ) F   ' + char(10)
		SELECT @v_dSql += N'			        ON  A.COMPANY_ID   = F.COMPANY_ID     ' + char(10)
		SELECT @v_dSql += N'			        AND A.DIVISION_ID  = F.DIVISION_ID    ' + char(10)
		SELECT @v_dSql += N'			        AND A.SITE_ID      = F.SITE_ID        ' + char(10)
		SELECT @v_dSql += N'			        AND A.PLANT_ID     = F.PLANT_ID       ' + char(10)
		SELECT @v_dSql += N'			        AND A.CELL_ITEM_ID = F.ITEM_ID        ' + char(10)
		SELECT @v_dSql += N'	        WHERE 1=1     ' + char(10)
		SELECT @v_dSql += N'	        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID          ' + char(10)
		SELECT @v_dSql += N'	               , A.CELL_ITEM_ID, A.CELL_NICK_NAME     ' + char(10)
		SELECT @v_dSql += N'	               , A.STORAGE_ID, A.SOC_ID, A.MARKET, DD.SORT_ORDER' + char(10)
		SELECT @v_dSql += N'	               , ISNULL(D.QTY,0), ISNULL(D.TOTAL_QTY,0), ISNULL(D.AVAIL_QTY,0), ISNULL(D.HOLD_QTY,0)	' + char(10)
		SELECT @v_dSql += N'	               , ISNULL(F.TOTAL_CELL_QTY,0), ISNULL(F.AVAIL_CELL_QTY,0) , ISNULL(F.HOLD_CELL_QTY,0), ISNULL(D.INTRANSIT,0)      ' + char(10)
		SELECT @v_dSql += N'				   , ISNULL(F.AVAIL_CELL_LONG_QTY,0), ISNULL(F.HOLD_CELL_LONG_QTY,0)	' + char(10)
		--SELECT @v_dSql += N'      )         ' + char(10)
		--SELECT @v_dSql += N'      , MAIN_I AS (       ' + char(10)
		SELECT @v_dSql += N'	        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID            ' + char(10)
		SELECT @v_dSql += N'	             , CONVERT(NVARCHAR(300), NULL) AS ITEM_ID, CONVERT(NVARCHAR(100), NULL) AS NICK_NAME, A.CELL_ITEM_ID AS CELL_ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS CELL_NICK_NAME   ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS BOH_QTY     ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY        ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY   ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY   ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS INTRANSIT   ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS BOM_RATE    ' + char(10)
		SELECT @v_dSql += N'	             , A.STORAGE_ID AS STORAGE_ID    ' + char(10)
		SELECT @v_dSql += N'	             , D.PSI AS PSI        ' + char(10)
		SELECT @v_dSql += N'	             , CONVERT(NVARCHAR(60), NULL) AS SOC_ID, CONVERT(NVARCHAR(60), NULL) AS MARKET ' + char(10)

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

					SELECT @v_dSql += N'      			, NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'      			, NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE	WHEN A.PLAN_DATE <= ''' + @sub_param_0 + ''' AND A.PLAN_DATE >= '''+ @p_plan_date +''' AND D.PSI = ''EOH(+Intransit)'' THEN A.EOH_QTY ' + char(10)
					SELECT @v_dSql += N'                			WHEN A.PLAN_DATE <= ''' + @sub_param_0 + ''' AND A.PLAN_DATE >= '''+ @p_plan_date +''' AND D.PSI = ''EOH(Available)'' THEN A.EOH_AVAIL_QTY         ' + char(10)
					SELECT @v_dSql += N'                			WHEN A.PLAN_DATE <= ''' + @sub_param_0 + ''' AND A.PLAN_DATE >= '''+ @p_plan_date +''' AND D.PSI = ''EOH(Hold)'' THEN A.EOH_HOLD_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	             , ''I'' AS CATEGORY_ID' + char(10)
		SELECT @v_dSql += N'	             , D.CATEGORY_ORDER AS CATEGORY_ORDER     ' + char(10)
		SELECT @v_dSql += N'	             , ''DATA'' AS DATA_TYPE         ' + char(10)
		SELECT @v_dSql += N'	        INTO    #TEMP_TABLE_MAIN_I ' + char(10)
		SELECT @v_dSql += N'	        FROM (        ' + char(10)
		SELECT @v_dSql += N'		            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID    ' + char(10)
		SELECT @v_dSql += N'	                 	 , A.ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE, A.STORAGE_ID  ' + char(10)
		SELECT @v_dSql += N'	                 	 -- EOH(+Intransit) : BOH_AVAIL + Intransit - P(CMA) + R ' + char(10)
		SELECT @v_dSql += N'	                 	 -- EOH(Avail) : BOH_AVAIL - P(CMA) + R     ' + char(10)
		SELECT @v_dSql += N'	                 	 -- CWA 는 EOH 에 Intransit 가 포함되어 있음' + char(10)
		SELECT @v_dSql += N'		                 , (CASE WHEN A.PLAN_DATE = '''+ @p_plan_date +''' THEN (A.AVAIL_QTY + A.INTRANSIT - A.S_QTY + A.P_QTY) ELSE (0 - A.S_QTY + A.P_QTY) END) AS EOH_QTY        ' + char(10)
		SELECT @v_dSql += N'	                   	 , (CASE WHEN A.PLAN_DATE = '''+ @p_plan_date +''' THEN (A.AVAIL_QTY - A.S_QTY + A.P_QTY) ELSE (0 - A.S_QTY + A.P_QTY) END) AS EOH_AVAIL_QTY   ' + char(10)
		SELECT @v_dSql += N'	                   	 , (CASE WHEN A.PLAN_DATE = '''+ @p_plan_date +''' THEN (A.HOLD_QTY - A.INTRANSIT - A.S_QTY + A.P_QTY) ELSE (0 - A.S_QTY + A.P_QTY) END) AS EOH_HOLD_QTY    ' + char(10)
		SELECT @v_dSql += N'		            FROM (' + char(10)
		SELECT @v_dSql += N'					                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID           ' + char(10)
		SELECT @v_dSql += N'					                     , A.ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE, A.STORAGE_ID         ' + char(10)
		SELECT @v_dSql += N'					                     , SUM(S_QTY) AS S_QTY      ' + char(10)
		SELECT @v_dSql += N'					                     , SUM(P_QTY) AS P_QTY      ' + char(10)
		SELECT @v_dSql += N'					                     , MAX(BOH_QTY) AS BOH_QTY  ' + char(10)
		SELECT @v_dSql += N'					                     , MAX(AVAIL_QTY) AS AVAIL_QTY           ' + char(10)
		SELECT @v_dSql += N'					                     , MAX(HOLD_QTY) AS HOLD_QTY' + char(10)
		SELECT @v_dSql += N'					                     , MAX(INTRANSIT) AS INTRANSIT           ' + char(10)
		SELECT @v_dSql += N'					                FROM (       ' + char(10)
		SELECT @v_dSql += N'					                		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID													    ' + char(10)
		SELECT @v_dSql += N'								                   	, NULL AS ITEM_ID, A.CELL_ITEM_ID													          ' + char(10)
		SELECT @v_dSql += N'								                   	, A.PLAN_DATE													       ' + char(10)
		SELECT @v_dSql += N'								                   	, A.STORAGE_ID  ' + char(10)
		SELECT @v_dSql += N'								                   	, A.QTY AS S_QTY' + char(10)
		SELECT @v_dSql += N'								                   	, 0 AS P_QTY    ' + char(10)
		SELECT @v_dSql += N'							                        , 0 AS BOH_QTY  ' + char(10)
		SELECT @v_dSql += N'							                        , 0 AS AVAIL_QTY' + char(10)
		SELECT @v_dSql += N'							                        , 0 AS HOLD_QTY ' + char(10)
		SELECT @v_dSql += N'							                        , 0 AS INTRANSIT' + char(10)
		--SELECT @v_dSql += N'					                		FROM 	#TEMP_TABLE_02 A	' + char(10)
		--SELECT @v_dSql += N'											WHERE	1=1   ' + char(10)
		SELECT @v_dSql += N'							                       from ( ' + char(10)
		SELECT @v_dSql += @v_tempSql
		SELECT @v_dSql += N'							                       ) A ' + char(10)
		SELECT @v_dSql += N'																			     ' + char(10)
		SELECT @v_dSql += N'						                    UNION ALL     ' + char(10)
		SELECT @v_dSql += N'						                    SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
		SELECT @v_dSql += N'							                         , NULL AS ITEM_ID, A.CELL_ITEM_ID     ' + char(10)
		SELECT @v_dSql += N'							                         , CONVERT(VARCHAR, A.REQUIRE_DATE,112) AS PLAN_DATE' + char(10)
		SELECT @v_dSql += N'							                         , A.STORAGE_ID ' + char(10)
		SELECT @v_dSql += N'							                         , 0 AS S_QTY   ' + char(10)
		SELECT @v_dSql += N'							                         , SUM(A.REQUIRE_QTY) AS P_QTY         ' + char(10)
		SELECT @v_dSql += N'							                         , 0 AS BOH_QTY ' + char(10)
		SELECT @v_dSql += N'							                         , 0 AS AVAIL_QTY            ' + char(10)
		SELECT @v_dSql += N'							                         , 0 AS HOLD_QTY' + char(10)
		SELECT @v_dSql += N'							                         , 0 AS INTRANSIT            ' + char(10)
		SELECT @v_dSql += N'						                    FROM   	FP_DEMAND_PACK_REQUIRE_CELL_H A WITH(NOLOCK)        ' + char(10)
		SELECT @v_dSql += N'								                    INNER HASH JOIN (            ' + char(10)
		SELECT @v_dSql += N'														SELECT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID, A.SEGMENT3 AS SOC_ID, ATTRIBUTE3 AS SORT_ORDER          ' + char(10)
		SELECT @v_dSql += N'														FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)      ' + char(10)
		SELECT @v_dSql += N'														WHERE  A.LOOKUP_TYPE_CODE = ''PACK_SOC''        ' + char(10)
		SELECT @v_dSql += N'														AND    A.ACTIVE_FLAG = ''Y''       ' + char(10)
		SELECT @v_dSql += N'								                    ) DD  ' + char(10)
		SELECT @v_dSql += N'								                    ON  A.DIVISION_ID = DD.DIVISION_ID     ' + char(10)
		SELECT @v_dSql += N'								                    AND A.SITE_ID     = DD.SITE_ID         ' + char(10)
		SELECT @v_dSql += N'								                    AND A.SOC_ID      = DD.SOC_ID' + char(10)
		SELECT @v_dSql += N'								            WHERE  1=1    ' + char(10)
		SELECT @v_dSql += N'						                    AND	   A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
		SELECT @v_dSql += N'						                    AND	   A.PLAN_ID = '''+ @p_plan_id +'''         ' + char(10)
		SELECT @v_dSql += N'						                    AND A.REQUIRE_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ITEM_ID' , 'LIKE', @p_cell_item_id)) + char(10)
		SELECT @v_dSql += N'						                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'					                         		, A.CELL_ITEM_ID, CONVERT(VARCHAR, A.REQUIRE_DATE,112), A.STORAGE_ID   ' + char(10)
		SELECT @v_dSql += N'					                        UNION ALL     ' + char(10)
		SELECT @v_dSql += N'						                    SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
		SELECT @v_dSql += N'							                         , NULL AS ITEM_ID, A.CELL_ITEM_ID     ' + char(10)
		SELECT @v_dSql += N'							                         , '''+ @p_plan_date +''' AS PLAN_DATE  ' + char(10)
		SELECT @v_dSql += N'							                         , A.STORAGE_ID ' + char(10)
		SELECT @v_dSql += N'							                         , 0 AS S_QTY   ' + char(10)
		SELECT @v_dSql += N'							                         , 0 AS P_QTY   ' + char(10)
		SELECT @v_dSql += N'							                         , ISNULL(B.TOTAL_QTY,0) AS BOH_QTY    ' + char(10)
		SELECT @v_dSql += N'							                         , ISNULL(B.AVAIL_QTY,0) AS AVAIL_QTY  ' + char(10)
		SELECT @v_dSql += N'							                         , ISNULL(B.HOLD_QTY,0) AS HOLD_QTY    ' + char(10)
		SELECT @v_dSql += N'							                         , ISNULL(B.INTRANSIT,0) AS INTRANSIT  ' + char(10)
		SELECT @v_dSql += N'						                    FROM   	FP_DEMAND_PACK_REQUIRE_CELL_H A WITH(NOLOCK)        ' + char(10)
		SELECT @v_dSql += N'						                    		LEFT OUTER HASH JOIN (       ' + char(10)
		SELECT @v_dSql += N'															SELECT 	*            ' + char(10)
		SELECT @v_dSql += N'															FROM 	#TEMP_TABLE_STOCK_T AS A ' + char(10)
		SELECT @v_dSql += N'															WHERE	A.STOCK_TYPE = ''PACK''' + char(10)
		SELECT @v_dSql += N'						                    		) B   ' + char(10)
		SELECT @v_dSql += N'								                    ON  A.COMPANY_ID   = B.COMPANY_ID      ' + char(10)
		SELECT @v_dSql += N'								                    AND A.DIVISION_ID  = B.DIVISION_ID     ' + char(10)
		SELECT @v_dSql += N'								                    AND A.SITE_ID      = B.SITE_ID         ' + char(10)
		SELECT @v_dSql += N'								                    AND A.PLANT_ID     = B.PLANT_ID        ' + char(10)
		SELECT @v_dSql += N'								                    AND A.CELL_ITEM_ID = B.ITEM_ID         ' + char(10)
		SELECT @v_dSql += N'								                    AND A.STORAGE_ID   = B.EXPORT_SLOC_ID  ' + char(10)
		SELECT @v_dSql += N'								                    INNER HASH JOIN (            ' + char(10)
		SELECT @v_dSql += N'														SELECT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID, A.SEGMENT3 AS SOC_ID, ATTRIBUTE3 AS SORT_ORDER          ' + char(10)
		SELECT @v_dSql += N'														FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)      ' + char(10)
		SELECT @v_dSql += N'														WHERE  A.LOOKUP_TYPE_CODE = ''PACK_SOC''        ' + char(10)
		SELECT @v_dSql += N'														AND    A.ACTIVE_FLAG = ''Y''       ' + char(10)
		SELECT @v_dSql += N'								                    ) DD  ' + char(10)
		SELECT @v_dSql += N'								                    ON  A.DIVISION_ID = DD.DIVISION_ID     ' + char(10)
		SELECT @v_dSql += N'								                    AND A.SITE_ID     = DD.SITE_ID         ' + char(10)
		SELECT @v_dSql += N'								                    AND A.SOC_ID      = DD.SOC_ID' + char(10)
		SELECT @v_dSql += N'								            WHERE  1=1    ' + char(10)
		SELECT @v_dSql += N'						                    AND	   A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
		SELECT @v_dSql += N'						                    AND	   A.PLAN_ID = '''+ @p_plan_id +'''         ' + char(10)
		SELECT @v_dSql += N'						                    AND A.REQUIRE_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ITEM_ID' , 'LIKE', @p_cell_item_id)) + char(10)
		SELECT @v_dSql += N'						                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'					                         		, A.CELL_ITEM_ID, A.STORAGE_ID         ' + char(10)
		SELECT @v_dSql += N'					                         		, ISNULL(B.TOTAL_QTY,0), ISNULL(B.AVAIL_QTY,0), ISNULL(B.HOLD_QTY,0), ISNULL(B.INTRANSIT,0)   ' + char(10)
		SELECT @v_dSql += N'				                	) A' + char(10)
		SELECT @v_dSql += N'				                WHERE 1=1        ' + char(10)
		SELECT @v_dSql += N'				                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE, A.STORAGE_ID ' + char(10)
		SELECT @v_dSql += N'				            ) A        ' + char(10)
		SELECT @v_dSql += N'				        ) A            ' + char(10)
		SELECT @v_dSql += N'				        INNER JOIN SCM_ITEM_M B WITH(NOLOCK)        ' + char(10)
		SELECT @v_dSql += N'						ON  1=1     ' + char(10)
		SELECT @v_dSql += N'						AND	B.SITE_ID = '''+ @p_inner_site_id +'''       ' + char(10)
		SELECT @v_dSql += N'						AND	A.COMPANY_ID  = B.COMPANY_ID     ' + char(10)
		SELECT @v_dSql += N'				        AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'				        AND A.SITE_ID     = B.SITE_ID     ' + char(10)
		SELECT @v_dSql += N'				        AND A.CELL_ITEM_ID = B.ITEM_ID    ' + char(10)
		SELECT @v_dSql += N'				        AND B.ACTIVE_FLAG = ''Y''' + char(10)
		SELECT @v_dSql += N'				        INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'				        ON  A.PLAN_DATE   = C.YYYYMMDD    ' + char(10)
		SELECT @v_dSql += N'				        INNER JOIN (   ' + char(10)
		SELECT @v_dSql += N'			        		  SELECT ''EOH(Available)'' AS PSI, 9998 AS CATEGORY_ORDER     ' + char(10)
		SELECT @v_dSql += N'				              --UNION ALL        ' + char(10)
		SELECT @v_dSql += N'				              --SELECT ''EOH(Hold)'' AS PSI, 9999 AS CATEGORY_ORDER        ' + char(10)
		SELECT @v_dSql += N'				              UNION ALL' + char(10)
		SELECT @v_dSql += N'				              SELECT ''EOH(+Intransit)'' AS PSI, 10000 AS CATEGORY_ORDER   ' + char(10)
		SELECT @v_dSql += N'				        ) D            ' + char(10)
		SELECT @v_dSql += N'				        ON 1=1         ' + char(10)
		SELECT @v_dSql += N'	        WHERE 1=1     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID          ' + char(10)
		SELECT @v_dSql += N'               		, A.CELL_ITEM_ID, ISNULL(B.NICK_NAME,''-''), A.STORAGE_ID    ' + char(10)
		SELECT @v_dSql += N'               		, D.PSI, D.CATEGORY_ORDER    ' + char(10)
		--SELECT @v_dSql += N'      )         ' + char(10)
		--SELECT @v_dSql += N'      , SUB_S AS (        ' + char(10)
		SELECT @v_dSql += N'	        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID            ' + char(10)
		SELECT @v_dSql += N'	             , CONVERT(NVARCHAR(300), NULL) AS ITEM_ID, CONVERT(NVARCHAR(100), NULL) AS NICK_NAME, A.CELL_ITEM_ID AS CELL_ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS CELL_NICK_NAME   ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS BOH     ' + char(10)
		SELECT @v_dSql += N'             	 , NULL AS TOTAL, NULL AS AVAIL, NULL AS HOLD        ' + char(10)
		SELECT @v_dSql += N'             	 , NULL AS TOTAL_CELL, NULL AS AVAIL_CELL, NULL AS HOLD_CELL   ' + char(10)
		SELECT @v_dSql += N'             	 , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY   ' + char(10)
		SELECT @v_dSql += N'                 , NULL AS INTRANSIT, NULL AS BOM_RATE    ' + char(10)
		SELECT @v_dSql += N'	             , A.STORAGE_ID AS STORAGE_ID, ''Ship Result'' AS PSI, CONVERT(NVARCHAR(60), NULL) AS SOC_ID, CONVERT(NVARCHAR(60), NULL) AS MARKET ' + char(10)

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

					SELECT @v_dSql += N'				, SUM(CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' THEN A.SHIP ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'				, SUM(CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN A.SHIP ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'				, SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN A.SHIP ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	             , ''SS'' AS CATEGORY_ID, 9000 AS CATEGORY_ORDER    ' + char(10)
		SELECT @v_dSql += N'	             , ''DATA'' AS DATA_TYPE         ' + char(10)
		SELECT @v_dSql += N'      		INTO #TEMP_TABLE_SUB_S ' + char(10)
		SELECT @v_dSql += N'      		FROM (        ' + char(10)
		SELECT @v_dSql += N'					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID    ' + char(10)
		SELECT @v_dSql += N'						, A.ITEM_ID, A.ITEM_ID AS CELL_ITEM_ID      ' + char(10)
		SELECT @v_dSql += N'						, CONVERT(VARCHAR,A.SHIP_YYYYMMDD,112) AS PLAN_DATE	     ' + char(10)
		SELECT @v_dSql += N'						, A.STORAGE_ID ' + char(10)
		SELECT @v_dSql += N'						, A.QTY AS SHIP      ' + char(10)
		SELECT @v_dSql += N'					FROM SCM_FCS_SHIP_V A WITH(NOLOCK)    ' + char(10)
		SELECT @v_dSql += N'					WHERE 1=1          ' + char(10)
		SELECT @v_dSql += N'					AND   ISNULL(A.QTY,0) > 0    ' + char(10)
		SELECT @v_dSql += N'					AND   A.SHIP_YYYYMMDD BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')        ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'                    AND   A.BIZ_TYPE = ''P''     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_cell_item_id)) + char(10)
		SELECT @v_dSql += N'					AND  EXISTS (      ' + char(10)
		SELECT @v_dSql += N'									SELECT	1    ' + char(10)
		SELECT @v_dSql += N'									FROM	(    ' + char(10)
		SELECT @v_dSql += N'												SELECT distinct SA.COMPANY_ID, SA.DIVISION_ID, SA.SITE_ID, SA.PLANT_ID, SA.CELL_ITEM_ID AS ITEM_ID' + char(10)
		SELECT @v_dSql += N'												FROM   FP_DEMAND_PACK_REQUIRE_CELL_H SA    ' + char(10)
		SELECT @v_dSql += N'												WHERE  1=1' + char(10)
		SELECT @v_dSql += N'												AND	   SA.INSTANCE_ID = '''+ @p_instance_id +'''      ' + char(10)
		SELECT @v_dSql += N'												AND	   SA.PLAN_ID = '''+ @p_plan_id +'''    ' + char(10)
		SELECT @v_dSql += N'												AND    SA.REQUIRE_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')    ' + char(10)
		SELECT @v_dSql += N'			                   					UNION ALL ' + char(10)
		SELECT @v_dSql += N'												SELECT distinct SA.COMPANY_ID, SA.DIVISION_ID, SA.SITE_ID, SA.PLANT_ID, SA.ITEM_ID   ' + char(10)
		SELECT @v_dSql += N'												FROM  FP_CELL_INHOUSE_PLAN_H SA WITH(NOLOCK)            ' + char(10)
		SELECT @v_dSql += N'												WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'												AND	 SA.INSTANCE_ID = '''+ @p_instance_id +'''        ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('SA.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('SA.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('SA.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'												AND    SA.CATEGORY = ''REQUEST'' ' + char(10)
		SELECT @v_dSql += N'												AND SA.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND DATEADD(DAY, -1, CONVERT(DATETIME,'''+ @p_plan_date +'''))	' + char(10)
		SELECT @v_dSql += N'											) SA ' + char(10)
		SELECT @v_dSql += N'									WHERE	1=1  ' + char(10)
		SELECT @v_dSql += N'									AND    SA.COMPANY_ID 	= A.COMPANY_ID       ' + char(10)
		SELECT @v_dSql += N'									AND    SA.DIVISION_ID 	= A.DIVISION_ID      ' + char(10)
		SELECT @v_dSql += N'									AND    SA.SITE_ID 		= A.SITE_ID          ' + char(10)
		SELECT @v_dSql += N'									AND    SA.PLANT_ID 		= A.PLANT_ID         ' + char(10)
		SELECT @v_dSql += N'									AND    SA.ITEM_ID 		= A.ITEM_ID          ' + char(10)
		SELECT @v_dSql += N'								)      ' + char(10)
		SELECT @v_dSql += N'					UNION ALL          ' + char(10)
		SELECT @v_dSql += N'					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID    ' + char(10)
		SELECT @v_dSql += N'						, NULL AS ITEM_ID, A.CELL_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'						, CONVERT(VARCHAR,A.REQUIRE_DATE,112) AS PLAN_DATE       ' + char(10)
		SELECT @v_dSql += N'						, A.STORAGE_ID ' + char(10)
		SELECT @v_dSql += N'						, 0 AS SHIP' + char(10)
		SELECT @v_dSql += N'					FROM   FP_DEMAND_PACK_REQUIRE_CELL_H A WITH(NOLOCK)          ' + char(10)
		SELECT @v_dSql += N'					WHERE  1=1         ' + char(10)
		SELECT @v_dSql += N'					AND	   A.INSTANCE_ID = '''+ @p_instance_id +'''  ' + char(10)
		SELECT @v_dSql += N'          			AND	   A.PLAN_ID = '''+ @p_plan_id +''' ' + char(10)
		SELECT @v_dSql += N'					AND    A.REQUIRE_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''') ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ITEM_ID' , 'LIKE', @p_cell_item_id)) + char(10)
		SELECT @v_dSql += N'                    UNION ALL          ' + char(10)
		SELECT @v_dSql += N'                    SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID   ' + char(10)
		SELECT @v_dSql += N'							, NULL AS ITEM_ID, A.ITEM_ID AS CELL_ITEM_ID         ' + char(10)
		SELECT @v_dSql += N'							, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE      ' + char(10)
		SELECT @v_dSql += N'							, A.STORAGE_ID       ' + char(10)
		SELECT @v_dSql += N'							, 0 AS SHIP      ' + char(10)
		SELECT @v_dSql += N'			          FROM  FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'			          WHERE 1=1        ' + char(10)
		SELECT @v_dSql += N'			    ' + char(10)
		SELECT @v_dSql += N'			          AND	 A.INSTANCE_ID = '''+ @p_instance_id +'''' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'			          AND    A.CATEGORY = ''REQUEST''     ' + char(10)
		SELECT @v_dSql += N'			          AND A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND DATEADD(DAY, -1, CONVERT(DATETIME,'''+ @p_plan_date +'''))    ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_cell_item_id)) + char(10)
		SELECT @v_dSql += N'   ' + char(10)
		SELECT @v_dSql += N'	        ) A ' + char(10)
		SELECT @v_dSql += N'	        INNER JOIN SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	        ON  1=1     ' + char(10)
		SELECT @v_dSql += N'			AND	B.SITE_ID = '''+ @p_inner_site_id +'''       ' + char(10)
		SELECT @v_dSql += N'			AND	A.COMPANY_ID  = B.COMPANY_ID     ' + char(10)
		SELECT @v_dSql += N'	        AND A.DIVISION_ID = B.DIVISION_ID    ' + char(10)
		SELECT @v_dSql += N'	        AND A.SITE_ID     = B.SITE_ID        ' + char(10)
		SELECT @v_dSql += N'	        AND A.CELL_ITEM_ID     = B.ITEM_ID   ' + char(10)
		SELECT @v_dSql += N'	        AND B.ACTIVE_FLAG = ''Y''  ' + char(10)
		SELECT @v_dSql += N'	        INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)     ' + char(10)
		SELECT @v_dSql += N'	        ON  A.PLAN_DATE   = C.YYYYMMDD       ' + char(10)
		SELECT @v_dSql += N'	        WHERE 1=1     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID          ' + char(10)
		SELECT @v_dSql += N'               		, A.CELL_ITEM_ID, ISNULL(B.NICK_NAME,''-''), A.STORAGE_ID    ' + char(10)
		--SELECT @v_dSql += N'      )         ' + char(10)
		--SELECT @v_dSql += N'      , T_FLAG AS (       ' + char(10)
		SELECT @v_dSql += N'      		SELECT A.PLAN_ID, B.MAX_PLAN_ID      ' + char(10)
		SELECT @v_dSql += N'			      , CASE WHEN A.PLAN_ID <= B.MAX_PLAN_ID THEN ''N'' ELSE ''Y'' END AS CONFIRM_YN        ' + char(10)
		SELECT @v_dSql += N'			INTO    #TEMP_TABLE_T_FLAG ' + char(10)
		SELECT @v_dSql += N'			FROM SCM_FP_IN_HOUSE_PLAN_H A        ' + char(10)
		SELECT @v_dSql += N'			    , (       ' + char(10)
		SELECT @v_dSql += N'			        SELECT MAX(PLAN_ID) AS MAX_PLAN_ID    ' + char(10)
		SELECT @v_dSql += N'			        FROM SCM_FP_IN_HOUSE_PLAN_H A' + char(10)
		SELECT @v_dSql += N'			        WHERE 1=1          ' + char(10)
		SELECT @v_dSql += N'			        AND A.INSTANCE_ID = '''+ @p_instance_id +'''     ' + char(10)
		SELECT @v_dSql += N'			        AND A.CONFIRM_FLAG = ''Y''   ' + char(10)
		SELECT @v_dSql += N'			      ) B     ' + char(10)
		SELECT @v_dSql += N'			WHERE 1=1     ' + char(10)
		SELECT @v_dSql += N'			AND A.INSTANCE_ID = '''+ @p_instance_id +'''    ' + char(10)
		SELECT @v_dSql += N'			AND A.PLAN_ID = '''+ @p_plan_id +'''  ' + char(10)
		--SELECT @v_dSql += N'      )         ' + char(10)
		SELECT @v_dSql += N'      SELECT A.*' + char(10)
		SELECT @v_dSql += N'           , DENSE_RANK() OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_ITEM_ID ) AS LV1       ' + char(10)

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
					SELECT @v_dSql += N'       					WHEN A.PSI=''R(Cell Req.)'' THEN ( CASE WHEN ''' + @sub_param_0 + ''' >= '''+ @p_plan_date +''' AND G.CONFIRM_YN = ''Y'' AND R.PLANT_ID IS NOT NULL THEN ''#FFFF0055'' ELSE '''' END )   ' + char(10)
					SELECT @v_dSql += N'      					ELSE '''' END AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_BG ' + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'    	   , CASE WHEN F.ITEM_ID IS NULL THEN ''N'' ELSE ''Y'' END CHKYN         ' + char(10)
		SELECT @v_dSql += N'    	   , CASE WHEN A.DATA_TYPE = ''DATA'' THEN ISNULL(B.MOQ, 0) ELSE NULL END AS MOQ   ' + char(10)
		SELECT @v_dSql += N'    	   , CASE WHEN A.PSI=''R(Cell Req.)'' AND G.CONFIRM_YN = ''Y'' AND R.PLANT_ID IS NOT NULL THEN ''Y'' ELSE ''N'' END EDIT_YN  ' + char(10)
		SELECT @v_dSql += N'    	   , A.PSI AS MEASURE_ID	-- UI 맞춰서 추가  ' + char(10)
		SELECT @v_dSql += N'    	   , ISNULL(H.CELL_ASSY_ITEM_ID, ''-'') AS ASSY_ITEM_ID ' + char(10) -- cell assy code 추가... 20230608
		SELECT @v_dSql += N'      FROM (    ' + char(10)
		SELECT @v_dSql += N'        SELECT * FROM #TEMP_TABLE_MAIN_S           ' + char(10)
		SELECT @v_dSql += N'        UNION ALL         ' + char(10)
		SELECT @v_dSql += N'        SELECT * FROM #TEMP_TABLE_MAIN_P           ' + char(10)
		SELECT @v_dSql += N'        UNION ALL         ' + char(10)
		SELECT @v_dSql += N'        SELECT * FROM #TEMP_TABLE_SUB_S            ' + char(10)
		SELECT @v_dSql += N'        UNION ALL         ' + char(10)
		SELECT @v_dSql += N'        SELECT * FROM #TEMP_TABLE_MAIN_I           ' + char(10)
		SELECT @v_dSql += N'        UNION ALL         ' + char(10)
		SELECT @v_dSql += N'        SELECT  NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_ITEM_ID, NULL AS CELL_NICK_NAME     ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS BOH_QTY															' + char(10)
		SELECT @v_dSql += N'	             , NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY					' + char(10)
		SELECT @v_dSql += N'	             , NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY	' + char(10)
		SELECT @v_dSql += N'	             , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY					' + char(10)
		SELECT @v_dSql += N'	             , NULL AS INTRANSIT, NULL AS BOM_RATE    ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS STORAGE_ID, A.PSI, NULL AS SOC_ID, NULL AS MARKET     ' + char(10)

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

		SELECT @v_dSql += N'             , A.CATEGORY_ID           ' + char(10)
		SELECT @v_dSql += N'             , 10 AS CATEGORY_ORDER    ' + char(10)
		SELECT @v_dSql += N'             , ''TOTAL_2'' AS DATA_TYPE' + char(10)
		SELECT @v_dSql += N'        FROM   #TEMP_TABLE_MAIN_S AS A ' + char(10)
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'        GROUP BY A.PSI, A.CATEGORY_ID  ' + char(10)
		SELECT @v_dSql += N'        UNION ALL         ' + char(10)
		SELECT @v_dSql += N'        SELECT  NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_ITEM_ID, NULL AS CELL_NICK_NAME     ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS BOH_QTY     ' + char(10)
		SELECT @v_dSql += N'	         	 , NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY        ' + char(10)
		SELECT @v_dSql += N'	         	 , NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY   ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY    ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS INTRANSIT, NULL AS BOM_RATE    ' + char(10)
		SELECT @v_dSql += N'             	 , NULL AS STORAGE_ID, A.PSI, NULL AS SOC_ID, NULL AS MARKET     ' + char(10)

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
		
		SELECT @v_dSql += N'             , A.CATEGORY_ID           ' + char(10)
		SELECT @v_dSql += N'             , 20 AS CATEGORY_ORDER    ' + char(10)
		SELECT @v_dSql += N'             , ''TOTAL_2'' AS DATA_TYPE' + char(10)
		SELECT @v_dSql += N'        FROM   #TEMP_TABLE_MAIN_P AS A ' + char(10)
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'        GROUP BY A.PSI, A.SOC_ID, A.CATEGORY_ID  ' + char(10)
		SELECT @v_dSql += N'        UNION ALL         ' + char(10)
		SELECT @v_dSql += N'        SELECT  NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID ' + char(10)
		SELECT @v_dSql += N'             , NULL AS ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_ITEM_ID, NULL AS CELL_NICK_NAME         ' + char(10)
		SELECT @v_dSql += N'             	 , NULL AS BOH_QTY															' + char(10)
        SELECT @v_dSql += N'             	 , NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY					' + char(10)
        SELECT @v_dSql += N'             	 , NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY	' + char(10)
        SELECT @v_dSql += N'             	 , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY					' + char(10)
		SELECT @v_dSql += N'	             , NULL AS INTRANSIT, NULL AS BOM_RATE    ' + char(10)
		SELECT @v_dSql += N'             	 , NULL AS STORAGE_ID, A.PSI, NULL AS SOC_ID, NULL AS MARKET     ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(CONVERT(NUMERIC,A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +')) AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(CONVERT(NUMERIC,A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +')) AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
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

		SELECT @v_dSql += N'             , A.CATEGORY_ID           ' + char(10)
		SELECT @v_dSql += N'             , 30 AS CATEGORY_ORDER    ' + char(10)
		SELECT @v_dSql += N'             , ''TOTAL_2'' AS DATA_TYPE' + char(10)
		SELECT @v_dSql += N'        FROM   #TEMP_TABLE_SUB_S AS A  ' + char(10)
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'        GROUP BY A.PSI, A.CATEGORY_ID  ' + char(10)
		SELECT @v_dSql += N'        UNION ALL         ' + char(10)
		SELECT @v_dSql += N'        SELECT  NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID ' + char(10)
		SELECT @v_dSql += N'             , NULL AS ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_ITEM_ID, NULL AS CELL_NICK_NAME         ' + char(10)
		SELECT @v_dSql += N'             	 , NULL AS BOH_QTY															    ' + char(10)	
        SELECT @v_dSql += N'             	 , NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY					    ' + char(10)
        SELECT @v_dSql += N'             	 , NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY	    ' + char(10)
        SELECT @v_dSql += N'             	 , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY					    ' + char(10)
		SELECT @v_dSql += N'	             , NULL AS INTRANSIT, NULL AS BOM_RATE    ' + char(10)
		SELECT @v_dSql += N'             , NULL AS STORAGE_ID, A.PSI, NULL AS SOC_ID, NULL AS MARKET         ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(CONVERT(NUMERIC,A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +')) AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += '               , SUM(CONVERT(NUMERIC,A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +')) AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
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

		SELECT @v_dSql += N'             , A.CATEGORY_ID           ' + char(10)
		SELECT @v_dSql += N'             , 40 AS CATEGORY_ORDER    ' + char(10)
		SELECT @v_dSql += N'             , ''TOTAL_2'' AS DATA_TYPE' + char(10)
		SELECT @v_dSql += N'        FROM   #TEMP_TABLE_MAIN_I AS A ' + char(10)
		SELECT @v_dSql += @total
		SELECT @v_dSql += N'        GROUP BY A.PSI, A.CATEGORY_ID  ' + char(10)
		SELECT @v_dSql += N'      ) A       ' + char(10)
		SELECT @v_dSql += N'      LEFT OUTER HASH JOIN (           ' + char(10)
		SELECT @v_dSql += N'					          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID    ' + char(10)
		SELECT @v_dSql += N'				                   , A.CELL_ITEM_ID       ' + char(10)
		SELECT @v_dSql += N'				                   , A.STORAGE_ID, A.SOC_ID, A.MARKET            ' + char(10)
		SELECT @v_dSql += N'				                   , MAX(A.MOQ) AS MOQ    ' + char(10)
		SELECT @v_dSql += N'					          FROM   FP_DEMAND_PACK_REQUIRE_CELL_H A WITH(NOLOCK)' + char(10)
		SELECT @v_dSql += N'					          WHERE  1=1         ' + char(10)
		SELECT @v_dSql += N'					          AND	 A.INSTANCE_ID = '''+ @p_instance_id +'''  ' + char(10)
		SELECT @v_dSql += N'					          AND	 A.PLAN_ID = '''+ @p_plan_id +'''' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'					          AND	CONVERT(VARCHAR,A.REQUIRE_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ITEM_ID' , 'LIKE', @p_cell_item_id)) + char(10)
		SELECT @v_dSql += N'					          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_ITEM_ID, A.STORAGE_ID, A.SOC_ID, A.MARKET       ' + char(10)
		SELECT @v_dSql += N'      ) B       ' + char(10)
		SELECT @v_dSql += N'      ON  A.COMPANY_ID  	= B.COMPANY_ID       ' + char(10)
		SELECT @v_dSql += N'	  AND A.DIVISION_ID 	= B.DIVISION_ID      ' + char(10)
		SELECT @v_dSql += N'	  AND A.SITE_ID     	= B.SITE_ID' + char(10)
		SELECT @v_dSql += N'	  AND A.PLANT_ID     	= B.PLANT_ID         ' + char(10)
		SELECT @v_dSql += N'	  AND A.CELL_ITEM_ID 	= B.CELL_ITEM_ID     ' + char(10)
		SELECT @v_dSql += N'	  AND A.STORAGE_ID 		= B.STORAGE_ID       ' + char(10)
		SELECT @v_dSql += N'	  --AND A.SOC_ID 			= B.SOC_ID       ' + char(10)
		SELECT @v_dSql += N'	  --AND A.MARKET 			= B.MARKET       ' + char(10)
		SELECT @v_dSql += N'      LEFT OUTER HASH JOIN (           ' + char(10)
		SELECT @v_dSql += N'		              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'		              FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)          ' + char(10)
		SELECT @v_dSql += N'		              WHERE  1=1       ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'			          AND 	 A.PLAN_TYPE = ''RELEASE''    ' + char(10)
		SELECT @v_dSql += N'		              AND    (A.PLAN_IN_QTY <> 0 OR  A.PLAN_QTY <> 0)            ' + char(10)
		--SELECT @v_dSql += N'		              AND 	 CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +'''       ' + char(10)
		SELECT @v_dSql += N'		              AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_plan_date + ''' + '' 00:00:00.000'') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''' + '' 23:59:59.997'') ' + char(10)
		SELECT @v_dSql += N'		              AND  	 EXISTS (  ' + char(10)
		SELECT @v_dSql += N'		              					SELECT 1 ' + char(10)
		SELECT @v_dSql += N'										FROM (   ' + char(10)
		SELECT @v_dSql += N'													SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, C.OPERATION_ID            ' + char(10)
		SELECT @v_dSql += N'													FROM   FP_INSTANCE_FACTORY_M A, SCM_FACTORY_M B, FP_INSTANCE_OPERATION_V C       ' + char(10)
		SELECT @v_dSql += N'													WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''   ' + char(10)
		SELECT @v_dSql += N'													AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'													AND    A.FACTORY_ID	 = B.FACTORY_ID    ' + char(10)
		SELECT @v_dSql += N'													AND    B.COMPANY_ID  = C.COMPANY_ID    ' + char(10)
		SELECT @v_dSql += N'													AND    B.DIVISION_ID = C.DIVISION_ID   ' + char(10)
		SELECT @v_dSql += N'													AND    B.SITE_ID     = C.SITE_ID       ' + char(10)
		SELECT @v_dSql += N'													AND    C.INSTANCE_ID LIKE ''%FORM%''   ' + char(10)
		SELECT @v_dSql += N'												) AA      ' + char(10)
		SELECT @v_dSql += N'										WHERE 1=1' + char(10)
		SELECT @v_dSql += N'										AND	A.COMPANY_ID	= AA.COMPANY_ID      ' + char(10)
		SELECT @v_dSql += N'										AND	A.DIVISION_ID = AA.DIVISION_ID       ' + char(10)
		SELECT @v_dSql += N'										AND	A.SITE_ID	=	AA.SITE_ID           ' + char(10)
		SELECT @v_dSql += N'										AND	A.PLANT_ID	= AA.PLANT_ID            ' + char(10)
		SELECT @v_dSql += N'										AND	A.OPERATION_ID	= AA.OPERATION_ID    ' + char(10)
		SELECT @v_dSql += N'									)  ' + char(10)
		SELECT @v_dSql += N'		              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID            ' + char(10)
		SELECT @v_dSql += N'		) F     ' + char(10)
		SELECT @v_dSql += N'			ON  A.COMPANY_ID  	= F.COMPANY_ID   ' + char(10)
		SELECT @v_dSql += N'			AND A.DIVISION_ID 	= F.DIVISION_ID  ' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID     	= F.SITE_ID      ' + char(10)
		SELECT @v_dSql += N'			AND A.PLANT_ID     	= F.PLANT_ID     ' + char(10)
		SELECT @v_dSql += N'			AND A.CELL_ITEM_ID 	= F.ITEM_ID      ' + char(10)
		SELECT @v_dSql += N'		LEFT OUTER JOIN #TEMP_TABLE_T_FLAG G       ' + char(10)
		SELECT @v_dSql += N'		ON  1=1 ' + char(10)
		SELECT @v_dSql += N'		LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V H WITH(NOLOCK) ' + char(10)  -- cell assy code 추가... 20230608
		SELECT @v_dSql += N'		ON  A.COMPANY_ID  	= H.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'		AND A.DIVISION_ID 	= H.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'		AND A.SITE_ID     	= H.SITE_ID ' + char(10)
		SELECT @v_dSql += N'		AND A.CELL_ITEM_ID 	= H.CELL_PRODUCT_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'					LEFT OUTER JOIN (  ' + char(10)
		SELECT @v_dSql += N'							SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID         ' + char(10)
		SELECT @v_dSql += N'							FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)           ' + char(10)
		SELECT @v_dSql += N'							WHERE	1=1' + char(10)
		SELECT @v_dSql += N'							AND		R.USER_ID	= '''+ @p_user_id +'''         ' + char(10)
		SELECT @v_dSql += N'							AND		R.SAVE_FLAG	= ''Y''   ' + char(10)
		SELECT @v_dSql += N'					) R   ' + char(10)
		SELECT @v_dSql += N'					ON		1=1        ' + char(10)
		SELECT @v_dSql += N'					AND		A.COMPANY_ID		= R.COMPANY_ID      ' + char(10)
		SELECT @v_dSql += N'					AND		A.DIVISION_ID		= R.DIVISION_ID     ' + char(10)
		SELECT @v_dSql += N'					AND		A.SITE_ID			= R.SITE_ID         ' + char(10)
		SELECT @v_dSql += N'					AND		A.PLANT_ID			= R.PLANT_ID        ' + char(10)
		SELECT @v_dSql += N'	  WHERE 1=1 ' + char(10)

		IF @p_line_assign = 'Y' BEGIN
			SELECT @v_dSql += N'					AND    EXISTS ( SELECT 1 									 ' + char(10)
			SELECT @v_dSql += N'									FROM SCM_ITEM_LINE_ASSIGN_M AA WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql += N'									WHERE	1=1									 ' + char(10)
			SELECT @v_dSql += N'									AND		AA.SITE_ID = '''+ @p_inner_site_id +'''       ' + char(10)
			SELECT @v_dSql += N'									AND		AA.DIVISION_ID = A.DIVISION_ID		 ' + char(10)
			SELECT @v_dSql += N'									AND		AA.SITE_ID = A.SITE_ID				 ' + char(10)
			SELECT @v_dSql += N'									AND		AA.PLANT_ID = A.PLANT_ID			 ' + char(10)
			SELECT @v_dSql += N'									AND		AA.ITEM_ID = A.CELL_ITEM_ID		     ' + char(10)
			SELECT @v_dSql += N'									AND		AA.MONTH = CONVERT(VARCHAR(6), '''+ @p_plan_date +''')	' + char(10)
			SELECT @v_dSql += N'									AND		AA.PRIORITY NOT IN (0,9)			 ' + char(10)
			SELECT @v_dSql += N'									AND		AA.ACTIVE_FLAG = ''Y''				 ' + char(10)
			SELECT @v_dSql += N'								   )	         ' + char(10)
		END

		SELECT @v_dSql += N'      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID   ' + char(10)
		SELECT @v_dSql += N'             , A.CELL_ITEM_ID, A.STORAGE_ID      ' + char(10)
		SELECT @v_dSql += N'             , (CASE WHEN DATA_TYPE=''DATA'' THEN 1 ELSE 999 END)   ' + char(10)
		SELECT @v_dSql += N'             , (CASE WHEN A.CATEGORY_ID=''S'' THEN 1 WHEN A.CATEGORY_ID=''SS'' THEN 888 WHEN A.CATEGORY_ID=''I'' THEN 999 ELSE 100 END)           ' + char(10)
		SELECT @v_dSql += N'             , A.ITEM_ID, A.MARKET, A.CATEGORY_ORDER      ' + char(10)
		
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
	
	/*
	BEGIN
		    IF OBJECT_ID(
		    'tempdb..#TEMP_TABLE_01'
		    ) IS NOT NULL
		      
		    DROP TABLE 
		    #TEMP_TABLE_01
		      
		    IF OBJECT_ID(
		    'tempdb..#TEMP_TABLE_02'
		    ) IS NOT NULL
		      
		    DROP TABLE 
		    #TEMP_TABLE_02
		      
	END
	*/
  
END

