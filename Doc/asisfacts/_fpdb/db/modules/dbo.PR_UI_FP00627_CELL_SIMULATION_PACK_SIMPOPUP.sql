

/*
 * Program ID   : PR_UI_FP00627_CELL_SIMULATION_PACK_SIMPOPUP
 * Description  : Cell Simulation(Pack)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/08/09   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00627_CELL_SIMULATION_PACK_SIMPOPUP]
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

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00627_CELL_SIMULATION_PACK_SIMPOPUP';
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
	DECLARE @p_plan_type	NVARCHAR(MAX);

	DECLARE @p_release_flag	NVARCHAR(MAX);
	DECLARE @p_model_id		NVARCHAR(MAX);
	DECLARE @p_model_nick_name	NVARCHAR(MAX);
	DECLARE @p_formation_instance_id	NVARCHAR(MAX);
	DECLARE @p_sim_plan_id	NVARCHAR(MAX);
	DECLARE @p_history_yn	NVARCHAR(MAX);
	DECLARE @v_eol_d1_rate	NVARCHAR(MAX);
	DECLARE @v_eol_d2_rate	NVARCHAR(MAX);
	
	-- week
	DECLARE @p_bucket		NVARCHAR(MAX);
	DECLARE @p_week_info	NVARCHAR(MAX);
	DECLARE @p_month_info	NVARCHAR(MAX);
	
	-- table
	DECLARE @p_table_name	NVARCHAR(MAX);
	
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
		END ELSE IF @tmp_column = 'RELEASE_FLAG' BEGIN
			SET @p_release_flag  =			@tmp_value
		END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
			SET @p_model_id  =			@tmp_value
		END ELSE IF @tmp_column = 'MODEL_NICK_NAME' BEGIN
			SET @p_model_nick_name  =			@tmp_value
		END ELSE IF @tmp_column = 'FORM_INS' BEGIN
			SET @p_formation_instance_id  =			@tmp_value
		END ELSE IF @tmp_column = 'SIM_PLAN_ID' BEGIN
			SET @p_sim_plan_id  =			@tmp_value

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

		END ELSE IF @tmp_column = 'TABLE_NAME' BEGIN
			SET @p_table_name	=		@tmp_value
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

	--IF ISNULL(@p_cate_info,'') <> '' BEGIN
	--	SET @mst_loop_cnt	= 0
	--	WHILE @mst_loop_cnt < @max_category_loop_cnt
	--	BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	--		SET @mst_loop_cnt =  @mst_loop_cnt + 1
	--		SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info , @v_row_delimiter , @mst_loop_cnt)
	--		SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column , @sub_v_delimiter)

	--		IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_ID')   END
	--		IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column , @sub_max_loop_cnt, @sub_v_delimiter , 'MEA_VALUE')   END

	--		IF @sub_param_0 = 'chk_total' AND @sub_param_1 = 'false' BEGIN
	--			SET @sub_total = 'WHERE 1=0' +char(10)
	--			SET @capa_total = 'WHERE 1=0' +char(10)
	--		END
	--		ELSE IF @sub_param_0 = 'chk_total' AND @sub_param_1 = 'true' BEGIN
	--			SET @sub_total = 'WHERE 1=1' +char(10)
	--			SET @capa_total = 'WHERE 1=1' +char(10)
	--		END 
	--		ELSE IF @sub_param_0 = 'chk_total_2' AND @sub_param_1 = 'false' BEGIN
	--			SET @total = 'WHERE 1=0' +char(10)
	--		END
	--		ELSE IF @sub_param_0 = 'chk_total_2' AND @sub_param_1 = 'true' BEGIN
	--			SET @total = 'WHERE 1=1' +char(10)
	--		END 
	--		ELSE IF @sub_param_0 = 'chk_capa' AND @sub_param_1 = 'false' BEGIN
	--			SET @capa_total = 'WHERE 1=0' +char(10)
	--		END
	--		ELSE IF @sub_param_0 = 'chk_capa' AND @sub_param_1 = 'true' BEGIN
	--			SET @capa_total = 'WHERE 1=1' +char(10)
	--		END 

	--	END -- WHILE
	--END -- IF ISNULL(@p_cate_info,'') 
	
	SET @p_plan_id = CASE WHEN LEN(ISNULL(@p_plan_id,'')) = 0 THEN '' ELSE @p_plan_id END

	SET @p_sim_plan_id = @p_plan_id ;

	SELECT	@p_history_yn = ISNULL(HISTORY_YN, 'N')
	FROM	FP_SIM_PLAN_H
	WHERE	1=1
	AND		PROGRAM_TYPE = 'PACK_SIMUL'
	AND		INSTANCE_ID = @p_instance_id
	AND		SIM_PLAN_ID = @p_sim_plan_id

	IF @p_history_yn = 'Y' BEGIN
		SET @p_table_name = 'FP_SIM_MATERIAL_PACK_H'
	END ELSE BEGIN
		SET @p_table_name = 'FP_SIM_MATERIAL_PACK_R'
	END

	

	BEGIN
		
		--BEGIN
		--      IF OBJECT_ID(
		--      'tempdb..#TEMP_TABLE_01'
		--      ) IS NOT NULL
		      
		--      DROP TABLE 
		--      #TEMP_TABLE_01
		--END

		
		--BEGIN
		
		--      CREATE TABLE 
		--      #TEMP_TABLE_01
		--      (
		--        	COMPANY_ID nvarchar(30) NOT NULL,
		--        	DIVISION_ID nvarchar(30) NOT NULL,
		--        	SITE_ID nvarchar(30) NOT NULL,
		--        	PLANT_ID nvarchar(30) NOT NULL,
		--        	ITEM_ID nvarchar(150) NULL,
		--        	CATEGORY_ID nvarchar(30) NULL,
		--			FROM_INSTANCE nvarchar(30) NULL,
		--			PLAN_DATE nvarchar(30) NULL,
		--        	RECEIPT_QTY numeric(25, 10) NULL DEFAULT ((0))
		--      )
		
		--END

		BEGIN
			SELECT 	@v_eol_d1_rate = ATTRIBUTE1, @v_eol_d2_rate = ATTRIBUTE2 
			FROM 	SCM_SYS_LOOKUP_VALUE
			WHERE	1=1
			AND 	LOOKUP_TYPE_CODE = 'CELL_SIMUL_EOL_PLAN'
			AND 	SEGMENT1 = @p_instance_id
		END

		
		SET	@v_dSql = ''
		
		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_01'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_01 ' + char(10)
		SELECT @v_dSql += N' ; ' + char(10)

		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#CELL_ITEM_V'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #CELL_ITEM_V ' + char(10)
		SELECT @v_dSql += N' ; ' + char(10)

		SELECT @v_dSql += N'	SELECT	COMPANY_ID, DIVISION_ID, SITE_ID, PARENT_ITEM_ID AS CELL_PRODUCT, CHILD_ITEM_ID AS CELL_ASSY, FLAG									' + char(10)					
		SELECT @v_dSql += N'	INTO	#CELL_ITEM_V 																														' + char(10)
		SELECT @v_dSql += N'	FROM (																																		' + char(10)
		SELECT @v_dSql += N'			SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, ''NEW'' AS FLAG							' + char(10)
		SELECT @v_dSql += N'			FROM	SCM_MODEL_COMP_TEMP_V A WITH(NOLOCK)																						' + char(10)
		SELECT @v_dSql += N'				  , SCM_ITEM_M B WITH(NOLOCK)																									' + char(10)
		SELECT @v_dSql += N'			WHERE 1=1																															' + char(10)
		SELECT @v_dSql += N'			AND	A.SITE_ID = ( SELECT MAX(SITE_ID) AS SITE_ID																					' + char(10)
		SELECT @v_dSql += N'							  FROM SY_FP_INSTANCE_INFO_V																						' + char(10)
		SELECT @v_dSql += N'							  WHERE 1=1																											' + char(10)
		SELECT @v_dSql += N'							  AND INSTANCE_ID = '''+ @p_instance_id +''')																						' + char(10)					
		SELECT @v_dSql += N'			AND A.MODEL_ID = A.PARENT_ITEM_ID																									' + char(10)
		SELECT @v_dSql += N'			AND A.COMPANY_ID = B.COMPANY_ID																										' + char(10)
		SELECT @v_dSql += N'			AND A.DIVISION_ID = B.DIVISION_ID																									' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID = B.SITE_ID																											' + char(10)
		SELECT @v_dSql += N'			AND A.CHILD_ITEM_ID = B.ITEM_ID																										' + char(10)
		SELECT @v_dSql += N'			AND B.ACTIVE_FLAG = ''Y''																												' + char(10)
		SELECT @v_dSql += N'			AND B.ITEM_CLASS  = ''ES1901''																										' + char(10)
		SELECT @v_dSql += N'			UNION ALL																															' + char(10)
		SELECT @v_dSql += N'			SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID , A.PARENT_ITEM_ID, A.PARENT_ITEM_ID AS CHILD_ITEM_ID, ''ORG'' AS FLAG			' + char(10)
		SELECT @v_dSql += N'			FROM	SCM_MODEL_COMP_TEMP_V A WITH(NOLOCK)																						' + char(10)
		SELECT @v_dSql += N'				  , SCM_ITEM_M B WITH(NOLOCK)																									' + char(10)
		SELECT @v_dSql += N'				  , SCM_ITEM_CLASS_M C WITH(NOLOCK)																								' + char(10)
		SELECT @v_dSql += N'			WHERE 1=1																															' + char(10)
		SELECT @v_dSql += N'			AND	A.SITE_ID = ( SELECT MAX(SITE_ID) AS SITE_ID																					' + char(10)
		SELECT @v_dSql += N'							  FROM SY_FP_INSTANCE_INFO_V																						' + char(10)
		SELECT @v_dSql += N'							  WHERE 1=1																											' + char(10)
		SELECT @v_dSql += N'							  AND INSTANCE_ID = '''+ @p_instance_id +''')																						' + char(10)						
		SELECT @v_dSql += N'			AND A.MODEL_ID = A.PARENT_ITEM_ID																									' + char(10)
		SELECT @v_dSql += N'			AND A.COMPANY_ID = B.COMPANY_ID																										' + char(10)
		SELECT @v_dSql += N'			AND A.DIVISION_ID = B.DIVISION_ID																									' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID = B.SITE_ID																											' + char(10)
		SELECT @v_dSql += N'			AND A.PARENT_ITEM_ID = B.ITEM_ID																									' + char(10)
		SELECT @v_dSql += N'			AND B.ACTIVE_FLAG = ''Y''																												' + char(10)
		SELECT @v_dSql += N'			AND B.ITEM_CLASS = C.CLASS_ID																										' + char(10)
		SELECT @v_dSql += N'			AND C.LEVEL_1_NAME LIKE ''%Model%''																									' + char(10)
		SELECT @v_dSql += N'			AND C.LEVEL_3_NAME LIKE ''%Cell%''																									' + char(10)
		SELECT @v_dSql += N'		) A																																		' + char(10)
		SELECT @v_dSql += N'	WHERE 1=1																																	' + char(10)
		SELECT @v_dSql += N'	;																																			' + char(10)

	
		SELECT @v_dSql += N'	WITH ASSY_PLAN AS (																																									' + char(10);	
		SELECT @v_dSql += N'	        	SELECT A.*                  ' + char(10);
		SELECT @v_dSql += N'	        	FROM (                      ' + char(10);
		SELECT @v_dSql += N'	        		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE                       ' + char(10);
		SELECT @v_dSql += N'	                 , RELEASE_PLAN_ID, INSERT_TIME                      ' + char(10);
		SELECT @v_dSql += N'	                 , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END)             ' + char(10);
		SELECT @v_dSql += N'	                						         ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM     ' + char(10);
		SELECT @v_dSql += N'	        		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)         ' + char(10);
		SELECT @v_dSql += N'	        		WHERE  A.INSTANCE_DATE <= '''+ @p_plan_date +'''                ' + char(10);
		SELECT @v_dSql += N'	        	) A ' + char(10);
		SELECT @v_dSql += N'	        	WHERE A.ROW_NUM = 1         ' + char(10);
		SELECT @v_dSql += N'	        	AND   A.INSTANCE_ID = '''+ @p_instance_id +'''                      ' + char(10);
		--SELECT @v_dSql += N'	        	-- 동 혹은 plan group 에 해당하는 값의 plan 만 가져옴    ' + char(10);
		SELECT @v_dSql += N'	    			AND   A.RELEASE_VALUE IN (                           ' + char(10);
		SELECT @v_dSql += N'	    					SELECT DISTINCT (CASE WHEN A.ATTRIBUTE1 = ''BUILDING'' THEN B.FACTORY_ID  ' + char(10);
		SELECT @v_dSql += N'	    								          WHEN A.ATTRIBUTE1 = ''PLAN GROUP'' THEN C.PLAN_GROUP_ID                     ' + char(10);
		SELECT @v_dSql += N'	    								          ELSE B.FACTORY_ID END) AS RELEASE_VALUE             ' + char(10);
		SELECT @v_dSql += N'	    					FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)   ' + char(10);
		SELECT @v_dSql += N'	    					LEFT OUTER HASH JOIN (                       ' + char(10);
		SELECT @v_dSql += N'	    						SELECT A.INSTANCE_ID, FACTORY_ID         ' + char(10);
		SELECT @v_dSql += N'	    						FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                           ' + char(10);
		SELECT @v_dSql += N'	    						WHERE  A.ACTIVE_FLAG = ''Y''             ' + char(10);
		SELECT @v_dSql += N'	    					) B             ' + char(10);
		SELECT @v_dSql += N'	    					ON  A.SEGMENT1 = B.INSTANCE_ID               ' + char(10);
		SELECT @v_dSql += N'	    					LEFT OUTER HASH JOIN (                       ' + char(10);
		SELECT @v_dSql += N'	    						SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS PLAN_GROUP_ID         ' + char(10);
		SELECT @v_dSql += N'	    						FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                            ' + char(10);
		SELECT @v_dSql += N'	    						WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''               ' + char(10);
		SELECT @v_dSql += N'	    						AND    A.ACTIVE_FLAG = ''Y''             ' + char(10);
		SELECT @v_dSql += N'	    					) C             ' + char(10);
		SELECT @v_dSql += N'	    					ON    A.SEGMENT1 = C.INSTANCE_ID             ' + char(10);
		SELECT @v_dSql += N'	    					WHERE A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''   ' + char(10);
		SELECT @v_dSql += N'	    					AND   A.ACTIVE_FLAG = ''Y''                  ' + char(10);
		SELECT @v_dSql += N'	    					AND   A.SEGMENT1    = '''+ @p_instance_id +'''          ' + char(10);
		SELECT @v_dSql += N'	    			)                       ' + char(10);
		
		IF @p_release_flag = 'Y' BEGIN
			SELECT @v_dSql += N'	        	AND   1=1                    ' + char(10);
		END ELSE BEGIN
			SELECT @v_dSql += N'	        	AND   1=0                    ' + char(10);
		END
		
		
		SELECT @v_dSql += N'	          UNION ALL       ' + char(10);
		SELECT @v_dSql += N'	          SELECT '''+ @p_master_id +''' AS INSTANCE_ID, ''-'' AS RELEASE_VALUE, '''+ @p_plan_id +''' AS RELEASE_PLAN_ID, NULL AS INSERT_TIME, 1 AS ROW_NM      ' + char(10);

		IF @p_release_flag = 'Y' BEGIN
			SELECT @v_dSql += N'	        	WHERE   1=0                    ' + char(10);
		END ELSE BEGIN
			SELECT @v_dSql += N'	        	WHERE   1=1                    ' + char(10);
		END

		SELECT @v_dSql += N'	      )         ' + char(10);
		
		--SELECT @v_dSql += N'	      INSERT INTO #TEMP_TABLE_01  ' + char(10)
	
		SELECT @v_dSql += N'	      SELECT *  ' + char(10);
		SELECT @v_dSql += N'	      INTO #TEMP_TABLE_01  ' + char(10)
		SELECT @v_dSql += N'	      FROM (    ' + char(10);
		--SELECT @v_dSql += N'	          -- Receipt(In-house)          ' + char(10);
		SELECT @v_dSql += N'	          SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, ''INHOUSE'' AS CATEGORY_ID, '''' AS FROM_INSTANCE, A.PLAN_DATE, SUM(QTY) AS RECEIPT_QTY            ' + char(10);
		SELECT @v_dSql += N'	          FROM    (                     ' + char(10);
		SELECT @v_dSql += N'	    		          SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                ' + char(10);
		SELECT @v_dSql += N'	    			               , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID   ' + char(10);
		SELECT @v_dSql += N'	    			               , ISNULL(LV.GROUP_ITEM_ID , ISNULL(VV.CELL_PRODUCT, A.ITEM_ID) ) AS ITEM_ID                 ' + char(10);
		SELECT @v_dSql += N'	    			               , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.QTY AS QTY      ' + char(10);
		SELECT @v_dSql += N'	    			               , ''FORM'' AS PLAN_TYPE               ' + char(10);
		SELECT @v_dSql += N'	    			               , A.STORAGE_ID                        ' + char(10);
		SELECT @v_dSql += N'	    		          FROM	  FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)  ' + char(10);
		SELECT @v_dSql += N'	      							LEFT OUTER JOIN #CELL_ITEM_V VV	-- 활성화 코드 분리 관련 추가 @@@	' + char(10)
		SELECT @v_dSql += N'	      							ON 1=1									' + char(10)
		SELECT @v_dSql += N'	      							AND	A.COMPANY_ID    =  VV.COMPANY_ID    ' + char(10)          
	    SELECT @v_dSql += N'	      							AND A.DIVISION_ID   =  VV.DIVISION_ID   ' + char(10)          
	    SELECT @v_dSql += N'	      							AND A.SITE_ID       =  VV.SITE_ID		' + char(10)
		SELECT @v_dSql += N'	      							AND A.ITEM_ID		=  VV.CELL_ASSY		' + char(10)
		SELECT @v_dSql += N'	    				          LEFT OUTER JOIN (                      ' + char(10);
		SELECT @v_dSql += N'	    								              SELECT SEGMENT1 AS SITE_ID , SEGMENT2 AS DIVISION_ID , SEGMENT3 AS GROUP_ITEM_ID , SEGMENT4 AS ITEM_ID                            ' + char(10);
		SELECT @v_dSql += N'	    								              FROM   SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK)     ' + char(10);
		SELECT @v_dSql += N'	    								              WHERE  LV.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''                      ' + char(10);
		SELECT @v_dSql += N'	    								              AND    LV.ACTIVE_FLAG      = ''Y''              ' + char(10);
		SELECT @v_dSql += N'	    				          ) LV      ' + char(10);
		SELECT @v_dSql += N'	    				          ON   1=1  ' + char(10);
		SELECT @v_dSql += N'	    					          AND   A.SITE_ID     = LV.SITE_ID   ' + char(10);
		SELECT @v_dSql += N'	    					          AND   A.DIVISION_ID = LV.DIVISION_ID                            ' + char(10);
		SELECT @v_dSql += N'	    					          AND   ISNULL(VV.CELL_PRODUCT, A.ITEM_ID)     = LV.ITEM_ID   ' + char(10);
		SELECT @v_dSql += N'	    		          WHERE A.CATEGORY    = ''MOVING''               ' + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_formation_instance_id)) + char(10)
		SELECT @v_dSql += N'	    		          AND   CONVERT(VARCHAR,A.PLAN_DATE,112) >=  CONVERT(VARCHAR, DATEADD(DAY, -1, CONVERT(DATE, '''+ @p_plan_date +''') ), 112)                        ' + char(10);
		SELECT @v_dSql += N'	    		          AND 	EXISTS (    ' + char(10);
		SELECT @v_dSql += N'	    					              SELECT 1                       ' + char(10);
		SELECT @v_dSql += N'	    					              FROM (                         ' + char(10);
		SELECT @v_dSql += N'	    						                 SELECT INSTANCE_ID, MAX(PLAN_ID) AS PLAN_ID          ' + char(10);
		SELECT @v_dSql += N'	    						                 FROM   SCM_FP_IN_HOUSE_PLAN_H A WITH(NOLOCK)         ' + char(10);
		SELECT @v_dSql += N'	    						                 WHERE  CONFIRM_FLAG = ''Y''                          ' + char(10);
		SELECT @v_dSql += N'	    						                 GROUP BY INSTANCE_ID    ' + char(10);
		SELECT @v_dSql += N'	    					              		)  AA                    ' + char(10);
		SELECT @v_dSql += N'	    					              WHERE AA.INSTANCE_ID = A.INSTANCE_ID                        ' + char(10);
		SELECT @v_dSql += N'	    					              AND  AA.PLAN_ID      = A.CONFIRM_ID                         ' + char(10);
		SELECT @v_dSql += N'	    		          				)   ' + char(10);
		SELECT @v_dSql += N'	          ) A   ' + char(10);
		SELECT @v_dSql += N'	    	  	INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)                ' + char(10);
		SELECT @v_dSql += N'	    		  ON     A.COMPANY_ID  = B.COMPANY_ID                    ' + char(10);
		SELECT @v_dSql += N'	    		  AND    A.DIVISION_ID = B.DIVISION_ID                   ' + char(10);
		SELECT @v_dSql += N'	    		  AND    A.SITE_ID     = B.SITE_ID                       ' + char(10);
		SELECT @v_dSql += N'	    		  AND    A.ITEM_ID     = B.ITEM_ID                       ' + char(10);
		SELECT @v_dSql += N'	      			AND    B.ACTIVE_FLAG  = ''Y''               ' + char(10)
		SELECT @v_dSql += N'	        	-- model, model nick name 조건이 입력되었을경우... receipt 쪽은 plan 쪽에서 조건을 간접적으로 끌어와서 사용   ' + char(10);
		SELECT @v_dSql += N'	    			INNER HASH JOIN (       ' + char(10);
		SELECT @v_dSql += N'										SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID , A.ATTB_03 AS CELL_ITEM_ID	' + char(10) 
		SELECT @v_dSql += N'										FROM   '+ @p_table_name +' A WITH(NOLOCK)              																				' + char(10)
		SELECT @v_dSql += N'										INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)       																						' + char(10)
		SELECT @v_dSql += N'										ON     A.COMPANY_ID   = C.COMPANY_ID            																						' + char(10)
		SELECT @v_dSql += N'										AND    A.DIVISION_ID  = C.DIVISION_ID           																						' + char(10)
		SELECT @v_dSql += N'										AND    A.SITE_ID      = C.SITE_ID               																						' + char(10)
		SELECT @v_dSql += N'										AND    A.MODEL_ID  = C.ITEM_ID               																							' + char(10)
		SELECT @v_dSql += N'										AND    C.ACTIVE_FLAG  = ''Y''  																											' + char(10)
		SELECT @v_dSql += N'										WHERE 1=1																																' + char(10)
		SELECT @v_dSql += N'										AND A.SIM_PLAN_ID = '''+ @p_sim_plan_id +'''																							' + char(10)
		SELECT @v_dSql += N'	      								AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                        ' + char(10)
		SELECT @v_dSql += N'										AND A.OPERATION_ID IN (''P5000'', ''P5200'')																							' + char(10)
		SELECT @v_dSql += N'	      								AND    A.SIM_IN_QTY > 0                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'LIKE_R', @p_model_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE_R', @p_model_nick_name)) + char(10)
		SELECT @v_dSql += N'	    			) C                     ' + char(10);
		SELECT @v_dSql += N'	          ON  A.COMPANY_ID  = C.COMPANY_ID                           ' + char(10);
		SELECT @v_dSql += N'	          AND A.DIVISION_ID = C.DIVISION_ID                          ' + char(10);
		SELECT @v_dSql += N'	          AND A.SITE_ID     = C.SITE_ID ' + char(10);
		SELECT @v_dSql += N'	          AND A.ITEM_ID     = C.CELL_ITEM_ID                         ' + char(10);
		SELECT @v_dSql += N'	    	    WHERE  1=1                  ' + char(10);
		SELECT @v_dSql += N'	    	    AND    A.PLAN_DATE BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10);
		SELECT @v_dSql += N'	    	    AND    A.QTY > 0            ' + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE_R', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE_R', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	    	    GROUP BY  A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.ITEM_ID , A.PLAN_DATE                     ' + char(10);
		SELECT @v_dSql += N'	          UNION ALL                     ' + char(10);
		--SELECT @v_dSql += N'	          -- Receipt(PLAN+INTRANSIT)    ' + char(10);
		SELECT @v_dSql += N'	          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ISNULL(D.PLANT_ID, A.PLANT_ID) AS PLANT_ID, A.CELL_CODE AS ITEM_ID, A.FROM_SITE AS CATEGORY_ID, M2.INSTANCE_ID AS FROM_INSTANCE, A.PLAN_DATE, SUM(QTY) AS RECEIPT_QTY	' + char(10);
		SELECT @v_dSql += N'	          FROM   (                      ' + char(10);
		--SELECT @v_dSql += N'	        			---- CATEGORY : Receipt(Intransit) ----          ' + char(10);
		SELECT @v_dSql += N'	        			SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.ITEM_ID AS CELL_CODE                 ' + char(10);
		SELECT @v_dSql += N'	    	    				 , B.SITE_ID        AS FROM_SITE         ' + char(10);
		SELECT @v_dSql += N'	    	    				 , B.PLANT_ID       AS FROM_PLANT_ID     ' + char(10);
		--SELECT @v_dSql += N'	    	    				 --, CONVERT(VARCHAR,A.ETA_DATE,112) AS PLAN_DATE                     ' + char(10);
		--SELECT @v_dSql += N'	    	    				 		--+ 과거일자는 당일 보정	' + char(10);
		SELECT @v_dSql += N'	    	    				 , CASE WHEN A.ETA_DATE < CONVERT(VARCHAR, '''+ @p_plan_date +''',112) THEN CONVERT(VARCHAR, '''+ @p_plan_date +''',112) ELSE CONVERT(VARCHAR,A.ETA_DATE,112) END PLAN_DATE 	' + char(10);
		SELECT @v_dSql += N'	    	    				 , A.INTRANSIT_QTY  AS QTY               ' + char(10);
		SELECT @v_dSql += N'	    	    				 , B.COMPANY_ID     AS FROM_COMPANY_ID   ' + char(10);
		SELECT @v_dSql += N'	    	    		FROM   FP_MRP_INTRANSIT_H A WITH(NOLOCK)         ' + char(10);
		SELECT @v_dSql += N'	    	    		INNER JOIN (   ' + char(10);
		--SELECT @v_dSql += N'	    	    					 ---/ FROM PLANT : 연결된 COMPANY_ID 의 모든 PLANT (활성화 plant 와의 연결은 아래 FP_INSTANCE_INFO_V 에서 찾음) /---   ' + char(10);
		SELECT @v_dSql += N'	      	    			SELECT DISTINCT A.COMPANY_ID, A.SITE_ID, A.PLANT_ID                       ' + char(10);
		SELECT @v_dSql += N'	      	    			FROM   SCM_PLANT_M A WITH(NOLOCK)            ' + char(10);
		SELECT @v_dSql += N'	    	    		) B                 ' + char(10);
		SELECT @v_dSql += N'	    	    		ON  A.VENDOR_CODE = B.COMPANY_ID                 ' + char(10);
		SELECT @v_dSql += N'	    	    		WHERE 1=1           ' + char(10);
		SELECT @v_dSql += N'	    	    		AND   A.INTRANSIT_QTY > 0                        ' + char(10);
		SELECT @v_dSql += N'	    	    		AND   EXISTS (      ' + char(10);
		SELECT @v_dSql += N'	    	    						SELECT 1                         ' + char(10);
		SELECT @v_dSql += N'	    	    						FROM   FP_INSTANCE_INFO_V V WITH(NOLOCK)                      ' + char(10);
		SELECT @v_dSql += N'	    	    						WHERE  V.INSTANCE_ID = '''+ @p_instance_id +'''                          ' + char(10);
		SELECT @v_dSql += N'	    	    						AND    A.COMPANY_ID  = V.COMPANY_ID                           ' + char(10);
		SELECT @v_dSql += N'	    	    						AND    A.DIVISION_ID = V.DIVISION_ID                          ' + char(10);
		SELECT @v_dSql += N'	    	    						AND    A.SITE_ID     = V.SITE_ID ' + char(10);
		SELECT @v_dSql += N'	    	    						AND    A.PLANT_ID    = V.PLANT_ID' + char(10);
		SELECT @v_dSql += N'	    	    		)                   ' + char(10);
		SELECT @v_dSql += N'	        			UNION ALL           ' + char(10);
		--SELECT @v_dSql += N'	        		  -- SCP Intransit 추가... 20200729                  ' + char(10);
		SELECT @v_dSql += N'	        			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID AS CELL_CODE                     ' + char(10);
		SELECT @v_dSql += N'	    		             , B.SITE_ID    AS FROM_SITE                 ' + char(10);
		SELECT @v_dSql += N'	    		             , B.PLANT_ID   AS FROM_PLANT_ID             ' + char(10);
		--SELECT @v_dSql += N'	    		            --+ 과거일자는 당일 보정            ' + char(10);
		SELECT @v_dSql += N'	    		             , CASE WHEN A.ETA_DATE < CONVERT(VARCHAR, '''+ @p_plan_date +''',112) THEN CONVERT(VARCHAR, '''+ @p_plan_date +''',112) ELSE A.ETA_DATE END PLAN_DATE    ' + char(10);
		SELECT @v_dSql += N'	    		             , A.DELIVERY_QTY AS QTY                     ' + char(10);
		SELECT @v_dSql += N'	    		             , B.COMPANY_ID AS FROM_COMPANY_ID           ' + char(10);
		SELECT @v_dSql += N'	        			FROM   FP_SCM_IN_TRANSIT_H A WITH(NOLOCK)        ' + char(10);
		SELECT @v_dSql += N'	        			INNER JOIN (          ' + char(10);
		--SELECT @v_dSql += N'	        						 ---/ FROM PLANT  /---               ' + char(10);
		SELECT @v_dSql += N'	      		        	SELECT DISTINCT A.COMPANY_ID, A.SITE_ID, A.PLANT_ID                       ' + char(10);
		SELECT @v_dSql += N'	      		        	FROM   SCM_PLANT_M A WITH(NOLOCK)            ' + char(10);
		SELECT @v_dSql += N'	        			) B                 ' + char(10);
		SELECT @v_dSql += N'	        			ON  A.FROM_PLANT_ID = B.PLANT_ID                 ' + char(10);
		SELECT @v_dSql += N'	        			WHERE 1=1           ' + char(10);
		SELECT @v_dSql += N'	        			AND   A.RESULT_DATE  = CONVERT(VARCHAR, DATEADD(DD, -1, CONVERT(DATE, '''+ @p_plan_date +''') ),112)             ' + char(10);
		SELECT @v_dSql += N'	        			AND   A.DELIVERY_QTY > 0                         ' + char(10);
		SELECT @v_dSql += N'	        			AND    EXISTS (     ' + char(10);
		SELECT @v_dSql += N'	      		        	SELECT 1        ' + char(10);
		SELECT @v_dSql += N'	      		        	FROM   FP_INSTANCE_INFO_V V WITH(NOLOCK)     ' + char(10);
		SELECT @v_dSql += N'	      		        	WHERE  V.INSTANCE_ID = '''+ @p_instance_id +'''         ' + char(10);
		SELECT @v_dSql += N'	      		        	AND    A.COMPANY_ID  = V.COMPANY_ID          ' + char(10);
		SELECT @v_dSql += N'	      		        	AND    A.DIVISION_ID = V.DIVISION_ID         ' + char(10);
		SELECT @v_dSql += N'	      		        	AND    A.SITE_ID     = V.SITE_ID             ' + char(10);
		SELECT @v_dSql += N'	      		        	AND    A.PLANT_ID    = V.PLANT_ID            ' + char(10);
		SELECT @v_dSql += N'	        			)                   ' + char(10);
		SELECT @v_dSql += N'	        			UNION ALL           ' + char(10);
		--SELECT @v_dSql += N'	           	----  CATEGORY : Receipt(SSP) 셀 출하계획 ----           ' + char(10);
		SELECT @v_dSql += N'	    				SELECT 	A.CUSTOMER_ID AS COMPANY_ID              ' + char(10);
		SELECT @v_dSql += N'	    		  				 , A.DIVISION_ID                         ' + char(10);
		SELECT @v_dSql += N'	    		  				 , A.TO_SITE_ID  AS SITE_ID              ' + char(10);
		SELECT @v_dSql += N'	    		  				 , A.TO_PLANT_ID AS PLANT_ID             ' + char(10);
		SELECT @v_dSql += N'	    		  				 , A.ITEM_ID AS CELL_CODE                ' + char(10);
		SELECT @v_dSql += N'	    		  				 , A.SITE_ID AS FROM_SITE_ID             ' + char(10);
		SELECT @v_dSql += N'	    		  				 , A.PLANT_ID AS FROM_PLANT_ID           ' + char(10);
		SELECT @v_dSql += N'	    		  				 , A.RECEIVE_YYYYMMDD  AS PLAN_DATE      ' + char(10);
		SELECT @v_dSql += N'	    		  				 , A.SHIP_QTY     AS  QTY                ' + char(10);
		SELECT @v_dSql += N'	    		  				 , A.COMPANY_ID  AS FROM_COMPANY_ID      ' + char(10);
		SELECT @v_dSql += N'	    				FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK)' + char(10);
		SELECT @v_dSql += N'	    				WHERE  1=1          ' + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE_R', @p_item_id)) + char(10)
		SELECT @v_dSql += N'	    				AND   EXISTS (      ' + char(10);
		SELECT @v_dSql += N'	    			      				SELECT 1                         ' + char(10);
		SELECT @v_dSql += N'	    			      				FROM (                           ' + char(10);
		SELECT @v_dSql += N'	    			        					SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID            ' + char(10);
		SELECT @v_dSql += N'	    			        					FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)           ' + char(10);
		SELECT @v_dSql += N'	    				        					INNER HASH JOIN SCM_FACTORY_M B WITH(NOLOCK)      ' + char(10);
		SELECT @v_dSql += N'	    				        					ON     A.FACTORY_ID  = B.FACTORY_ID               ' + char(10);
		SELECT @v_dSql += N'	    			        					WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                  ' + char(10);
		SELECT @v_dSql += N'	    			        					AND    A.ACTIVE_FLAG = ''Y''                          ' + char(10);
		SELECT @v_dSql += N'	    			        					AND    B.ACTIVE_FLAG = ''Y''                          ' + char(10);
		SELECT @v_dSql += N'	    			      				) AA' + char(10);
		SELECT @v_dSql += N'	    			      				WHERE A.CUSTOMER_ID = AA.COMPANY_ID                           ' + char(10);
		SELECT @v_dSql += N'	    			      				AND   A.DIVISION_ID = AA.DIVISION_ID                          ' + char(10);
		SELECT @v_dSql += N'	    			      				AND   A.TO_SITE_ID  = AA.SITE_ID ' + char(10);
		SELECT @v_dSql += N'	    			      				AND   A.TO_PLANT_ID = AA.PLANT_ID' + char(10);
		SELECT @v_dSql += N'	    	    					)       ' + char(10);
		SELECT @v_dSql += N'	    				AND    A.SHOP_GROUP_ID = ''A''                   ' + char(10);
		SELECT @v_dSql += N'	    				AND    A.SCP_PLAN_ID = (                         ' + char(10);
		SELECT @v_dSql += N'	    	    									 SELECT MAX(SCP_PLAN_ID)                          ' + char(10);
		SELECT @v_dSql += N'	    	    									 FROM  FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10);
		SELECT @v_dSql += N'	    	    									 		INNER HASH JOIN (                         ' + char(10);
		SELECT @v_dSql += N'	    			        										SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID                     ' + char(10);
		SELECT @v_dSql += N'	    			        										FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)               ' + char(10);
		SELECT @v_dSql += N'	    			        										INNER HASH JOIN SCM_FACTORY_M B WITH(NOLOCK)              ' + char(10);
		SELECT @v_dSql += N'	    			        										ON     A.FACTORY_ID  = B.FACTORY_ID                       ' + char(10);
		SELECT @v_dSql += N'	    			        										WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                      ' + char(10);
		SELECT @v_dSql += N'	    			        										AND    A.ACTIVE_FLAG = ''Y''      ' + char(10);
		SELECT @v_dSql += N'	    			        										AND    B.ACTIVE_FLAG = ''Y''      ' + char(10);
		SELECT @v_dSql += N'	    			    									 ) B         ' + char(10);
		SELECT @v_dSql += N'	    			    									 ON    A.CUSTOMER_ID = B.COMPANY_ID       ' + char(10);
		SELECT @v_dSql += N'	    			    									 AND   A.DIVISION_ID = B.DIVISION_ID      ' + char(10);
		SELECT @v_dSql += N'	    			    									 AND   A.TO_SITE_ID  = B.SITE_ID          ' + char(10);
		SELECT @v_dSql += N'	    			    									 AND   A.TO_PLANT_ID = B.PLANT_ID         ' + char(10);
		SELECT @v_dSql += N'	    	    									 WHERE A.SHOP_GROUP_ID = ''A''      ' + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE_R', @p_item_id)) + char(10)
		--SELECT @v_dSql += N'	    	    									 WHERE A.SHOP_GROUP_ID = ''A''   ---+ CELL 출하   ' + char(10);
		--SELECT @v_dSql += N'	    	    									 --GROUP BY A.CUSTOMER_ID, A.DIVISION_ID, A.TO_SITE_ID , A.TO_PLANT_ID, A.SHOP_GROUP_ID                ' + char(10);
		SELECT @v_dSql += N'	    	    								)                        ' + char(10);
		SELECT @v_dSql += N'	      			) A                     ' + char(10);
		SELECT @v_dSql += N'	      			LEFT OUTER JOIN (				' + char(10);
		--SELECT @v_dSql += N'	      									-- Hazel Park Plant mapping 시켜줌' + char(10);
		SELECT @v_dSql += N'	    								SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID' + char(10);
		SELECT @v_dSql += N'	    										, A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID               ' + char(10);
		SELECT @v_dSql += N'	    								FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                    ' + char(10);
		SELECT @v_dSql += N'	    								WHERE  A.LOOKUP_TYPE_CODE = ''FORMATION_PACK_INSTANCE_MAP''   ' + char(10);
		SELECT @v_dSql += N'	    								AND    A.ACTIVE_FLAG = ''Y''     ' + char(10);
		SELECT @v_dSql += N'	    								AND	   A.SEGMENT4 = ''DU''       ' + char(10);
		SELECT @v_dSql += N'	    		    ) D                     ' + char(10);
		SELECT @v_dSql += N'	    				ON  A.DIVISION_ID  	= D.REF_DIVISION_ID          ' + char(10);
		SELECT @v_dSql += N'	    				AND A.SITE_ID      	= D.REF_SITE_ID              ' + char(10);
		SELECT @v_dSql += N'	    				AND A.PLANT_ID     	= D.REF_PLANT_ID             ' + char(10);
		SELECT @v_dSql += N'	      			INNER JOIN (       ' + char(10);
		--SELECT @v_dSql += N'	      						--- FROM INSTANCE 정보 검색용 ---       ' + char(10);
		SELECT @v_dSql += N'	    							SELECT DISTINCT INSTANCE_ID , COMPANY_ID, DIVISION_ID , SITE_ID, PLANT_ID                 ' + char(10);
		SELECT @v_dSql += N'	    							FROM   FP_INSTANCE_INFO_V            ' + char(10);
		SELECT @v_dSql += N'	    							WHERE  INSTANCE_ID  LIKE ''%FORM%''  ' + char(10);
		SELECT @v_dSql += N'	    			  ) M2                  ' + char(10);
		SELECT @v_dSql += N'	    				ON 1=1              ' + char(10);
		SELECT @v_dSql += N'	    				AND  A.DIVISION_ID  = M2.DIVISION_ID             ' + char(10);
		SELECT @v_dSql += N'	    				AND  A.FROM_SITE  =  M2.SITE_ID                  ' + char(10);
		SELECT @v_dSql += N'	    				AND  A.FROM_PLANT_ID = M2.PLANT_ID               ' + char(10);
		SELECT @v_dSql += N'	    	  		INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)            ' + char(10);
		SELECT @v_dSql += N'	  		  		ON     A.COMPANY_ID  = B.COMPANY_ID                  ' + char(10);
		SELECT @v_dSql += N'	  		  		AND    A.DIVISION_ID = B.DIVISION_ID                 ' + char(10);
		SELECT @v_dSql += N'	  		  		AND    A.SITE_ID     = B.SITE_ID                     ' + char(10);
		SELECT @v_dSql += N'	  		  		AND    A.CELL_CODE   = B.ITEM_ID                     ' + char(10);
		SELECT @v_dSql += N'	  		  		AND		 B.ACTIVE_FLAG = ''Y''                       ' + char(10);
		SELECT @v_dSql += N'	          	-- model, model nick name 조건이 입력되었을경우... receipt 쪽은 plan 쪽에서 조건을 간접적으로 끌어와서 사용   ' + char(10);
		SELECT @v_dSql += N'	      			INNER HASH JOIN (       ' + char(10);
		SELECT @v_dSql += N'										SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID , A.ATTB_03 AS CELL_ITEM_ID	' + char(10) 
		SELECT @v_dSql += N'										FROM   '+ @p_table_name +' A WITH(NOLOCK)              																				' + char(10)
		SELECT @v_dSql += N'										INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)       																						' + char(10)
		SELECT @v_dSql += N'										ON     A.COMPANY_ID   = C.COMPANY_ID            																						' + char(10)
		SELECT @v_dSql += N'										AND    A.DIVISION_ID  = C.DIVISION_ID           																						' + char(10)
		SELECT @v_dSql += N'										AND    A.SITE_ID      = C.SITE_ID               																						' + char(10)
		SELECT @v_dSql += N'										AND    A.MODEL_ID  = C.ITEM_ID               																							' + char(10)
		SELECT @v_dSql += N'										AND    C.ACTIVE_FLAG  = ''Y''  																											' + char(10)
		SELECT @v_dSql += N'										WHERE 1=1																																' + char(10)
		SELECT @v_dSql += N'										AND A.SIM_PLAN_ID = '''+ @p_sim_plan_id +'''																							' + char(10)
		SELECT @v_dSql += N'	      								AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                        ' + char(10)
		SELECT @v_dSql += N'										AND A.OPERATION_ID IN (''P5000'', ''P5200'')																							' + char(10)
		SELECT @v_dSql += N'	      								AND    A.SIM_IN_QTY > 0                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'LIKE_R', @p_model_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE_R', @p_model_nick_name)) + char(10)
		SELECT @v_dSql += N'	      			) C                     ' + char(10);
		SELECT @v_dSql += N'	            ON  A.COMPANY_ID  = C.COMPANY_ID                         ' + char(10);
		SELECT @v_dSql += N'	            AND A.DIVISION_ID = C.DIVISION_ID                        ' + char(10);
		SELECT @v_dSql += N'	            AND A.SITE_ID     = C.SITE_ID                            ' + char(10);
		SELECT @v_dSql += N'	            AND A.CELL_CODE   = C.CELL_ITEM_ID                       ' + char(10);
		SELECT @v_dSql += N'	        		WHERE  1=1              ' + char(10);
		SELECT @v_dSql += N'	        		AND    A.PLAN_DATE BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                          ' + char(10);
		SELECT @v_dSql += N'	        		AND		 A.QTY > 0      ' + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_CODE' , 'LIKE_R', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE_R', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	        		GROUP BY  A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , ISNULL(D.PLANT_ID, A.PLANT_ID) , A.CELL_CODE , A.FROM_SITE , M2.INSTANCE_ID , A.PLAN_DATE                      ' + char(10);
		SELECT @v_dSql += N'	      ) A       ' + char(10);
		SELECT @v_dSql += N'	 ;      ' + char(10);

		--EXEC SP_EXECUTESQL @v_dSql
		--DECLARE @v_tempSql nvarchar(max) = @v_dSql
		--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_tempSql,'SELECT a',@runstart, @runend
		
		--SET	@v_dSql = ''

		SELECT @v_dSql += N'	      WITH ASSY_PLAN AS (           																																									' + char(10)																					
		SELECT @v_dSql += N'	        	SELECT A.*             ' + char(10)
		SELECT @v_dSql += N'	        	FROM (                 ' + char(10)
		SELECT @v_dSql += N'	        		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE                  ' + char(10)
		SELECT @v_dSql += N'	                 , RELEASE_PLAN_ID, INSERT_TIME                 ' + char(10)
		SELECT @v_dSql += N'	                 , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END)        ' + char(10)
		SELECT @v_dSql += N'	                						         ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM                        ' + char(10)
		SELECT @v_dSql += N'	        		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)    ' + char(10)
		SELECT @v_dSql += N'	        		WHERE  A.INSTANCE_DATE <= '''+ @p_plan_date +'''           ' + char(10)
		SELECT @v_dSql += N'	        	) A                    ' + char(10)
		SELECT @v_dSql += N'	        	WHERE A.ROW_NUM = 1    ' + char(10)
		SELECT @v_dSql += N'	        	AND   A.INSTANCE_ID = '''+ @p_instance_id +'''                 ' + char(10)
		SELECT @v_dSql += N'	        	-- 동 혹은 plan group 에 해당하는 값의 plan 만 가져옴                       ' + char(10)
		SELECT @v_dSql += N'	    			AND   A.RELEASE_VALUE IN (                      ' + char(10)
		SELECT @v_dSql += N'	    					SELECT DISTINCT (CASE WHEN A.ATTRIBUTE1 = ''BUILDING'' THEN B.FACTORY_ID                     ' + char(10)
		SELECT @v_dSql += N'	    								          WHEN A.ATTRIBUTE1 = ''PLAN GROUP'' THEN C.PLAN_GROUP_ID                ' + char(10)
		SELECT @v_dSql += N'	    								          ELSE B.FACTORY_ID END) AS RELEASE_VALUE   ' + char(10)
		SELECT @v_dSql += N'	    					FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                      ' + char(10)
		SELECT @v_dSql += N'	    					LEFT OUTER HASH JOIN (                  ' + char(10)
		SELECT @v_dSql += N'	    						SELECT A.INSTANCE_ID, FACTORY_ID    ' + char(10)
		SELECT @v_dSql += N'	    						FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                 ' + char(10)
		SELECT @v_dSql += N'	    						WHERE  A.ACTIVE_FLAG = ''Y''        ' + char(10)
		SELECT @v_dSql += N'	    					) B        ' + char(10)
		SELECT @v_dSql += N'	    					ON  A.SEGMENT1 = B.INSTANCE_ID          ' + char(10)
		SELECT @v_dSql += N'	    					LEFT OUTER HASH JOIN (                  ' + char(10)
		SELECT @v_dSql += N'	    						SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS PLAN_GROUP_ID                            ' + char(10)
		SELECT @v_dSql += N'	    						FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                  ' + char(10)
		SELECT @v_dSql += N'	    						WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''     ' + char(10)
		SELECT @v_dSql += N'	    						AND    A.ACTIVE_FLAG = ''Y''        ' + char(10)
		SELECT @v_dSql += N'	    					) C        ' + char(10)
		SELECT @v_dSql += N'	    					ON    A.SEGMENT1 = C.INSTANCE_ID        ' + char(10)
		SELECT @v_dSql += N'	    					WHERE A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                      ' + char(10)
		SELECT @v_dSql += N'	    					AND   A.ACTIVE_FLAG = ''Y''             ' + char(10)
		SELECT @v_dSql += N'	    					AND   A.SEGMENT1    = '''+ @p_instance_id +'''     ' + char(10)
		SELECT @v_dSql += N'	    			)                  ' + char(10)
		
		IF @p_release_flag = 'Y' BEGIN
			SELECT @v_dSql += N'	        	AND   1=1                    ' + char(10);
		END ELSE BEGIN
			SELECT @v_dSql += N'	        	AND   1=0                    ' + char(10);
		END
		
		SELECT @v_dSql += N'	          UNION ALL                ' + char(10)
		SELECT @v_dSql += N'	          SELECT '''+ @p_instance_id +''' AS INSTANCE_ID, ''-'' AS RELEASE_VALUE, '''+ @p_plan_id +''' AS RELEASE_PLAN_ID, NULL AS INSERT_TIME, 1 AS ROW_NM             ' + char(10)
		
		IF @p_release_flag = 'Y' BEGIN
			SELECT @v_dSql += N'	        	WHERE   1=0                    ' + char(10);
		END ELSE BEGIN
			SELECT @v_dSql += N'	        	WHERE   1=1                    ' + char(10);
		END

		SELECT @v_dSql += N'	      )                            ' + char(10)
		SELECT @v_dSql += N'	      , BOH_INFO AS (              ' + char(10)
		SELECT @v_dSql += N'	      	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ISNULL(D.PLANT_ID, A.PLANT_ID) AS PLANT_ID, A.ITEM_ID         ' + char(10)
		SELECT @v_dSql += N'	           	 , ISNULL(SUM(GOOD_QTY),0) AS GOOD_QTY              ' + char(10)
		SELECT @v_dSql += N'	          	 , ISNULL(SUM(HOLD_QTY),0) AS HOLD_QTY              ' + char(10)
		SELECT @v_dSql += N'	           	 , ISNULL(SUM(INTRANSIT_QTY),0) AS INTRANSIT_QTY    ' + char(10)
		SELECT @v_dSql += N'	           	 , ISNULL(SUM(GOOD_CELL_QTY),0) AS GOOD_CELL_QTY    ' + char(10)
		SELECT @v_dSql += N'	           	 , ISNULL(SUM(HOLD_CELL_QTY),0) AS HOLD_CELL_QTY    ' + char(10)
		SELECT @v_dSql += N'	           	 , ISNULL(SUM(UNINSPEC_CELL_QTY),0) AS UNINSPEC_CELL_QTY    ' + char(10)
		SELECT @v_dSql += N'	           	 , ISNULL(SUM(BOX_PACKING_CELL_QTY),0) AS BOX_PACKING_CELL_QTY    ' + char(10)
		SELECT @v_dSql += N'	           	 , ISNULL(SUM(LONG_TERM_CELL_QTY),0) AS LONG_TERM_CELL_QTY    ' + char(10)
		SELECT @v_dSql += N'	      	FROM (                     ' + char(10)
		SELECT @v_dSql += N'		      	      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID  ' + char(10)
		SELECT @v_dSql += N'		      	           , ISNULL(ISNULL(MAX(GOOD_MODIFY_QTY), SUM(A.GOOD_QTY)),0) AS GOOD_QTY                         ' + char(10)
		SELECT @v_dSql += N'		      	           , ISNULL(ISNULL(MAX(HOLD_MODIFY_QTY), SUM(A.HOLD_QTY)),0) AS HOLD_QTY                         ' + char(10)
		SELECT @v_dSql += N'		      	           , 0 AS INTRANSIT_QTY                     ' + char(10)
		SELECT @v_dSql += N'		      	           , 0 AS GOOD_CELL_QTY, 0 AS HOLD_CELL_QTY ' + char(10)
		SELECT @v_dSql += N'		      	           , 0 AS UNINSPEC_CELL_QTY, 0 AS BOX_PACKING_CELL_QTY, 0 AS LONG_TERM_CELL_QTY ' + char(10)
		SELECT @v_dSql += N'		      	      FROM (           ' + char(10)
		SELECT @v_dSql += N'			                	--- P1000 대기재고 ---              ' + char(10)
		SELECT @v_dSql += N'			                	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(C.SEGMENT3 , ISNULL(VV.CELL_PRODUCT, A.FP_APPLY_ITEM_ID)) AS ITEM_ID           ' + char(10)
		SELECT @v_dSql += N'			                	     , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y''  THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS GOOD_QTY   ' + char(10)
		SELECT @v_dSql += N'			                	     , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN < > ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS GOOD_MODIFY_QTY                 ' + char(10)
		SELECT @v_dSql += N'			                	     , CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.FP_APPLY_WIPQTY ELSE NULL END AS HOLD_QTY    ' + char(10)
		SELECT @v_dSql += N'			                	     , CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_MODIFY_QTY                   ' + char(10)
		SELECT @v_dSql += N'			                	FROM   SCM_STOCK_H_V A WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'	      							   LEFT OUTER JOIN #CELL_ITEM_V VV	-- 활성화 코드 분리 관련 추가 @@@	' + char(10)
		SELECT @v_dSql += N'	      							   ON 1=1									' + char(10)
		SELECT @v_dSql += N'	      							   AND	A.COMPANY_ID    =  VV.COMPANY_ID    ' + char(10)          
	    SELECT @v_dSql += N'	      							   AND A.DIVISION_ID   =  VV.DIVISION_ID   ' + char(10)          
	    SELECT @v_dSql += N'	      							   AND A.SITE_ID       =  VV.SITE_ID		' + char(10)
		SELECT @v_dSql += N'	      							   AND A.FP_APPLY_ITEM_ID =  VV.CELL_ASSY		' + char(10)
		SELECT @v_dSql += N'	            					   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)             ' + char(10)
		SELECT @v_dSql += N'	            					   ON  C.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''   ---> 대치품은 cell_group으로 item_id 삼는다.' + char(10)
		SELECT @v_dSql += N'	            					   AND A.SITE_ID          = C.SEGMENT1     ' + char(10)
		SELECT @v_dSql += N'	            					   AND ISNULL(VV.CELL_PRODUCT, A.FP_APPLY_ITEM_ID) = C.SEGMENT4     ' + char(10)
		SELECT @v_dSql += N'			                	WHERE A.CUTOFF_DATE  = CONVERT(DATE,'''+ @p_plan_date +''')   --->  시업시간 기준 INSTANCE DATE     ' + char(10)
		SELECT @v_dSql += N'			                	AND   A.OPERATION_ID =  ''P1000''   ' + char(10)
		SELECT @v_dSql += N'			                	AND   A.STORAGE_ID   =  ''MES''     ' + char(10)
		SELECT @v_dSql += N'			                	AND   A.STOCK_STATUS =  ''WAIT''         --+ 10/17추가      ' + char(10)
		SELECT @v_dSql += N'			                	AND   EXISTS (                      ' + char(10)
		SELECT @v_dSql += N'						                  		SELECT 1            ' + char(10)
		SELECT @v_dSql += N'						                  		FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK)' + char(10)
		SELECT @v_dSql += N'						                  		WHERE  FF.FACTORY_ID  = A.FACTORY_ID        ' + char(10)
		SELECT @v_dSql += N'						                  		AND    FF.INSTANCE_ID = '''+ @p_instance_id +'''       ' + char(10)
		SELECT @v_dSql += N'						                  		AND    FF.ACTIVE_FLAG = ''Y''               ' + char(10)
		SELECT @v_dSql += N'						                	 )                      ' + char(10)
		SELECT @v_dSql += N'		            		) A        ' + char(10)
		SELECT @v_dSql += N'		            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID  ' + char(10)
		SELECT @v_dSql += N'	            	UNION ALL          ' + char(10)
		SELECT @v_dSql += N'	            	--- STORAGE_ID 1000번대 재고. factory_id가 없음. ---                    ' + char(10)
		SELECT @v_dSql += N'	            	SELECT A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID, ISNULL(C.SEGMENT3 , ISNULL(VV.CELL_PRODUCT, A.FP_APPLY_ITEM_ID)) AS ITEM_ID                     ' + char(10)
		SELECT @v_dSql += N'	            	       , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND ISNULL(WIPHOLD_YN,''N'') <> ''Y'' THEN  A.QTY2  ELSE NULL END AS GOOD_QTY             ' + char(10)
		SELECT @v_dSql += N'	            	       , CASE WHEN ISNULL(WIPHOLD_YN,''N'') = ''Y''  THEN  A.QTY2 ELSE NULL END AS HOLD_QTY            ' + char(10)
		SELECT @v_dSql += N'	              		   , 0 AS INTRANSIT_QTY                       ' + char(10)
		SELECT @v_dSql += N'	              		   , 0 AS GOOD_CELL_QTY, 0 AS HOLD_CELL_QTY   ' + char(10)
		SELECT @v_dSql += N'		      	           , 0 AS UNINSPEC_CELL_QTY, 0 AS BOX_PACKING_CELL_QTY, 0 AS LONG_TERM_CELL_QTY ' + char(10)
		SELECT @v_dSql += N'	            	FROM   SCM_STOCK_H_V A WITH(NOLOCK)               ' + char(10)
		SELECT @v_dSql += N'	      				   LEFT OUTER JOIN #CELL_ITEM_V VV	-- 활성화 코드 분리 관련 추가 @@@	' + char(10)
		SELECT @v_dSql += N'	      				   ON 1=1									' + char(10)
		SELECT @v_dSql += N'	      				   AND	A.COMPANY_ID    =  VV.COMPANY_ID    ' + char(10)          
	    SELECT @v_dSql += N'	      				   AND A.DIVISION_ID   =  VV.DIVISION_ID   ' + char(10)          
	    SELECT @v_dSql += N'	      				   AND A.SITE_ID       =  VV.SITE_ID		' + char(10)
		SELECT @v_dSql += N'	      				   AND A.FP_APPLY_ITEM_ID =  VV.CELL_ASSY		' + char(10)
		SELECT @v_dSql += N'	            		   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)             ' + char(10)
		SELECT @v_dSql += N'	            		   ON  C.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''   ---> 대치품은 cell_group으로 item_id 삼는다.' + char(10)
		SELECT @v_dSql += N'	            		   AND A.SITE_ID          = C.SEGMENT1     ' + char(10)
		SELECT @v_dSql += N'	            	WHERE A.CUTOFF_DATE  = CONVERT(DATE,'''+ @p_plan_date +''')   --->  시업시간 기준 INSTANCE DATE                 ' + char(10)
		SELECT @v_dSql += N'	            	AND   SUBSTRING (A.STORAGE_ID, 1, 1)  = ''1''   ' + char(10)
		--SELECT @v_dSql += N'	            	---> INSTANCE 기준                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += N'	            	AND   EXISTS (     ' + char(10)
		SELECT @v_dSql += N'				              		SELECT 1                        ' + char(10)
		SELECT @v_dSql += N'				              		FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK), SCM_FACTORY_M F2 WITH(NOLOCK)          ' + char(10)
		SELECT @v_dSql += N'				              		WHERE  FF.FACTORY_ID  = F2.FACTORY_ID                   ' + char(10)
		SELECT @v_dSql += N'				              		AND    F2.SITE_ID     = A.SITE_ID                       ' + char(10)
		SELECT @v_dSql += N'				              		AND    FF.INSTANCE_ID = '''+ @p_instance_id +''' ---> INSTANCE 기준' + char(10)
		SELECT @v_dSql += N'				              		AND    FF.ACTIVE_FLAG = ''Y''   ' + char(10)
		SELECT @v_dSql += N'				            	)      ' + char(10)
		--SELECT @v_dSql += N'	            	UNION ALL          ' + char(10)
		--SELECT @v_dSql += N'	            	--- DW 이동재고 ---' + char(10)
		--SELECT @v_dSql += N'	            	-- SSP 테이블 기준으로 변경.... 20210105        ' + char(10)
		--SELECT @v_dSql += N'	              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(C.SEGMENT3, ITEM_ID) AS ITEM_ID      ' + char(10)
		--SELECT @v_dSql += N'	              	 , 0 AS GOOD_QTY, 0 AS HOLD_QTY                 ' + char(10)
		--SELECT @v_dSql += N'	              	 , ISNULL(A.PACK_MOVE_QTY ,0) AS INTRANSIT_QTY  ' + char(10)
		--SELECT @v_dSql += N'	              	 , 0 AS GOOD_CELL_QTY, 0 AS HOLD_CELL_QTY       ' + char(10)
		--SELECT @v_dSql += N'		      	           , 0 AS UNINSPEC_CELL_QTY, 0 AS BOX_PACKING_CELL_QTY, 0 AS LONG_TERM_CELL_QTY ' + char(10)
		--SELECT @v_dSql += N'	              FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK)       ' + char(10)
		--SELECT @v_dSql += N'	              LEFT OUTER JOIN  SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)                      ' + char(10)
		--SELECT @v_dSql += N'	              ON     C.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''   ---> 대치품은 cell_group으로 item_id 삼는다.       ' + char(10)
		--SELECT @v_dSql += N'	              AND    A.SITE_ID = C.SEGMENT1                     ' + char(10)
		--SELECT @v_dSql += N'	              AND    A.ITEM_ID = C.SEGMENT4                     ' + char(10)
		--SELECT @v_dSql += N'	              WHERE  1=1           ' + char(10)
		--SELECT @v_dSql += N'	              AND    A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''')                      ' + char(10)
		--SELECT @v_dSql += N'	              AND    A.PACK_MOVE_QTY > 0                        ' + char(10)
		--SELECT @v_dSql += N'	              AND   EXISTS (       ' + char(10)
		--SELECT @v_dSql += N'	              			    SELECT 1                            ' + char(10)
		--SELECT @v_dSql += N'	              			    FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK), SCM_FACTORY_M F2 WITH(NOLOCK)              ' + char(10)
		--SELECT @v_dSql += N'	              			    WHERE  FF.FACTORY_ID  = F2.FACTORY_ID                       ' + char(10)
		--SELECT @v_dSql += N'	              			    AND    F2.SITE_ID     = A.SITE_ID   ' + char(10)
		--SELECT @v_dSql += N'	              			    AND    FF.INSTANCE_ID = '''+ @p_instance_id +''' ---> INSTANCE 기준    ' + char(10)
		--SELECT @v_dSql += N'	              			    AND    FF.ACTIVE_FLAG = ''Y''       ' + char(10)
		--SELECT @v_dSql += N'	              )                    ' + char(10)
		SELECT @v_dSql += N'	            	UNION ALL          ' + char(10)
		SELECT @v_dSql += N'	            	/**** BOH(CELL) 재고 ****/                      ' + char(10)
		SELECT @v_dSql += N'	            	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID    ' + char(10)
		SELECT @v_dSql += N'	            	     , 0 AS GOOD_QTY, 0 AS HOLD_QTY                 ' + char(10)
		SELECT @v_dSql += N'	            	     , SUM(A.INTRANSIT_QTY)  AS INTRANSIT_QTY		                      ' + char(10)
		SELECT @v_dSql += N'	            	     , SUM(A.BOH_QTY)  AS GOOD_CELL_QTY		                      ' + char(10)
		SELECT @v_dSql += N'	            	     , SUM(A.HOLD_QTY) AS HOLD_CELL_QTYAS			              ' + char(10)
		SELECT @v_dSql += N'	            	     , SUM(A.UNINSPEC_BOH_QTY) AS UNINSPEC_CELL_QTY	              ' + char(10)
		SELECT @v_dSql += N'	            	     , SUM(A.BOX_PACKING_BOH_QTY) AS BOX_PACKING_CELL_QTY         ' + char(10)
		SELECT @v_dSql += N'	            	     , SUM(A.LONG_TERM_BOH_QTY) AS LONG_TERM_CELL_QTY         ' + char(10)
		SELECT @v_dSql += N'	            	FROM   (           ' + char(10)
		SELECT @v_dSql += N'	            			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                      ' + char(10)
		SELECT @v_dSql += N'	            					, ISNULL(C.SEGMENT3 , ISNULL(VV.CELL_PRODUCT, A.FP_APPLY_ITEM_ID)) AS ITEM_ID          ' + char(10)
		SELECT @v_dSql += N'	            					, A.WIPHOLD_YN                         ' + char(10)		
		SELECT @v_dSql += N'	            					, CASE WHEN ISNULL(A.PACK_MOVE_FLAG, ''N'') = ''Y'' THEN A.FP_APPLY_WIPQTY  ELSE NULL END AS INTRANSIT_QTY        ' + char(10)
		SELECT @v_dSql += N'	            					, CASE WHEN A.LOT_PACKING_TYPE <> ''UI'' AND  A.QLTY_NO_INSP_FLAG != ''Y'' AND CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112)	AND WIPHOLD_YN <> ''Y'' AND A.LONG_TERM_FLAG = ''N'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y'' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS BOH_QTY        ' + char(10)
		SELECT @v_dSql += N'	            					, CASE WHEN A.LOT_PACKING_TYPE = ''UI'' AND  A.QLTY_NO_INSP_FLAG <> ''Y'' AND CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112)	AND WIPHOLD_YN <> ''Y'' AND A.LONG_TERM_FLAG =  ''N'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y'' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS BOX_PACKING_BOH_QTY        ' + char(10)
																						---------------------------------GOOD_BOX_PACKING_CELL_QTY------------------------
		SELECT @v_dSql += N'	            					, CASE WHEN WIPHOLD_YN = ''Y'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y''  THEN  A.FP_APPLY_WIPQTY ELSE NULL END AS HOLD_QTY        ' + char(10)
		SELECT @v_dSql += N'	            					, CASE WHEN A.QLTY_NO_INSP_FLAG = ''Y'' AND WIPHOLD_YN = ''N'' 	AND A.LONG_TERM_FLAG =  ''N'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y'' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS UNINSPEC_BOH_QTY         ' + char(10)
		SELECT @v_dSql += N'	            					, CASE WHEN ISNULL(A.LONG_TERM_FLAG, ''N'') = ''Y'' AND WIPHOLD_YN = ''N'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y'' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS LONG_TERM_BOH_QTY        ' + char(10)
		
		SELECT @v_dSql += N'	            					, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN < > ''Y'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS BOH_MODIFY_QTY                    ' + char(10)
		SELECT @v_dSql += N'	            					, CASE WHEN WIPHOLD_YN = ''Y'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_MODIFY_QTY                     ' + char(10)
				
		SELECT @v_dSql += N'	            			FROM   SCM_STOCK_H_V A WITH(NOLOCK)       ' + char(10)
		SELECT @v_dSql += N'	      							LEFT OUTER JOIN #CELL_ITEM_V VV	-- 활성화 코드 분리 관련 추가 @@@	' + char(10)
		SELECT @v_dSql += N'	      							ON 1=1									' + char(10)
		SELECT @v_dSql += N'	      							AND	A.COMPANY_ID    =  VV.COMPANY_ID    ' + char(10)          
	    SELECT @v_dSql += N'	      							AND A.DIVISION_ID   =  VV.DIVISION_ID   ' + char(10)          
	    SELECT @v_dSql += N'	      							AND A.SITE_ID       =  VV.SITE_ID		' + char(10)
		SELECT @v_dSql += N'	      							AND A.FP_APPLY_ITEM_ID =  VV.CELL_ASSY		' + char(10)
		SELECT @v_dSql += N'	            					LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)             ' + char(10)
		SELECT @v_dSql += N'	            					ON  C.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''   ---> 대치품은 cell_group으로 item_id 삼는다.' + char(10)
		SELECT @v_dSql += N'	            					AND A.SITE_ID          = C.SEGMENT1     ' + char(10)
		SELECT @v_dSql += N'	            					AND ISNULL(VV.CELL_PRODUCT, A.FP_APPLY_ITEM_ID) = C.SEGMENT4     ' + char(10)
		SELECT @v_dSql += N'	            			WHERE EXISTS (                          ' + char(10)
		SELECT @v_dSql += N'	            	            SELECT 1                            ' + char(10)
		SELECT @v_dSql += N'	            	            FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK)                ' + char(10)
		SELECT @v_dSql += N'	            	            WHERE  FF.FACTORY_ID  = A.FACTORY_ID' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('FF.INSTANCE_ID' , 'EQ', @p_formation_instance_id)) + char(10)
		SELECT @v_dSql += N'	            	            AND    FF.ACTIVE_FLAG = ''Y''       ' + char(10)
		SELECT @v_dSql += N'	            	        )          ' + char(10)
		SELECT @v_dSql += N'							 AND 0=( -- 인스턴스별 SSP 재고 사용여부 : SSP 이면 stock 쪽은 비활성화' + char(10)
		SELECT @v_dSql += N'							 			SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = ''SSP'' THEN 1 ELSE 0 END), 1) AS IS_SSP      ' + char(10)
		SELECT @v_dSql += N'							 			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                  ' + char(10)
		SELECT @v_dSql += N'							 			WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_STOCK_SOURCE''       ' + char(10)
		SELECT @v_dSql += N'							 			AND    A.ACTIVE_FLAG = ''Y''        ' + char(10)
		SELECT @v_dSql += N'							 			AND    A.SEGMENT1 = '''+ @p_instance_id +''' ) ' + char(10)
		SELECT @v_dSql += N'	            			AND   A.CUTOFF_DATE  = CONVERT(DATE,'''+ @p_plan_date +''') --->  시업시간 기준 INSTANCE DATE           ' + char(10)
		--SELECT @v_dSql += N'	            			AND   (A.STOCK_TYPE  = ''DW'' AND A.STORAGE_ID = ''-'' )   --- 재고 검색조건                 ' + char(10)
		SELECT @v_dSql += N'	            			AND   A.STOCK_TYPE  = ''WIP''  --- 재고 검색조건                 ' + char(10)
		SELECT @v_dSql += N'	            			AND   ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0 ' + char(10)
		SELECT @v_dSql += N'	            	    UNION ALL      ' + char(10)
		SELECT @v_dSql += N'	              		-- SSP 재고 정보                            ' + char(10)
		SELECT @v_dSql += N'	              		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.WIPHOLD_YN ' + char(10)
		SELECT @v_dSql += N'	              		     , 0 AS INTRANSIT_QTY            ' + char(10)
		SELECT @v_dSql += N'	              		     , 0 AS BOX_PACKING_BOH_QTY            ' + char(10)
		SELECT @v_dSql += N'	              		     , 0 AS UNINSPEC_BOH_QTY            ' + char(10)
		SELECT @v_dSql += N'	              		     , 0 AS LONG_TERM_BOH_QTY            ' + char(10)
		SELECT @v_dSql += N'	              		     , SUM(A.BOH_QTY) AS BOH_QTY            ' + char(10)
		SELECT @v_dSql += N'	              		     , SUM(A.HOLD_QTY) AS HOLD_QTY          ' + char(10)
		SELECT @v_dSql += N'	              		     , SUM(A.BOH_MODIFY_QTY) AS BOH_MODIFY_QTY                      ' + char(10)
		SELECT @v_dSql += N'	              		     , SUM(A.HOLD_MODIFY_QTY) AS HOLD_MODIFY_QTY                    ' + char(10)
		SELECT @v_dSql += N'	              		FROM (         ' + char(10)
		SELECT @v_dSql += N'	                  		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, ISNULL(C.SEGMENT3, ISNULL(VV.CELL_PRODUCT, A.ITEM_ID)) AS ITEM_ID           ' + char(10)
		SELECT @v_dSql += N'	                    			 , A.HOLD AS WIPHOLD_YN         ' + char(10)
		SELECT @v_dSql += N'	                    			 , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> ''Y'' THEN A.QTY ELSE 0 END AS BOH_QTY                            ' + char(10)
		SELECT @v_dSql += N'	                    			 , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> ''Y'' THEN 0 ELSE A.QTY END AS HOLD_QTY                           ' + char(10)
		SELECT @v_dSql += N'	                    			 , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> ''Y'' THEN A.QTY ELSE 0 END AS BOH_MODIFY_QTY                     ' + char(10)
		SELECT @v_dSql += N'	                    			 , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> ''Y'' THEN 0 ELSE A.QTY END AS HOLD_MODIFY_QTY                    ' + char(10)
		SELECT @v_dSql += N'	                  		FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK)                     ' + char(10)
		SELECT @v_dSql += N'	      							LEFT OUTER JOIN #CELL_ITEM_V VV	-- 활성화 코드 분리 관련 추가 @@@	' + char(10)
		SELECT @v_dSql += N'	      							ON 1=1									' + char(10)
		SELECT @v_dSql += N'	      							AND	A.COMPANY_ID    =  VV.COMPANY_ID    ' + char(10)          
	    SELECT @v_dSql += N'	      							AND A.DIVISION_ID   =  VV.DIVISION_ID   ' + char(10)          
	    SELECT @v_dSql += N'	      							AND A.SITE_ID       =  VV.SITE_ID		' + char(10)
		SELECT @v_dSql += N'	      							AND A.ITEM_ID		=  VV.CELL_ASSY		' + char(10)
		SELECT @v_dSql += N'									LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)               ' + char(10)
		SELECT @v_dSql += N'									ON    C.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP''   ---> 대치품은 cell_group으로 item_id 삼는다.' + char(10)
		SELECT @v_dSql += N'									AND   A.SITE_ID          = C.SEGMENT1     ' + char(10)
		SELECT @v_dSql += N'									AND   ISNULL(VV.CELL_PRODUCT, A.ITEM_ID) = C.SEGMENT4     ' + char(10)
		SELECT @v_dSql += N'	                  		WHERE EXISTS (                          ' + char(10)
		SELECT @v_dSql += N'	            	            SELECT 1                            ' + char(10)
		SELECT @v_dSql += N'	            	            FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK)                ' + char(10)
		SELECT @v_dSql += N'	            	            WHERE  FF.FACTORY_ID  = A.FACTORY_ID' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('FF.INSTANCE_ID' , 'EQ', @p_formation_instance_id)) + char(10)
		SELECT @v_dSql += N'	            	            AND    FF.ACTIVE_FLAG = ''Y''       ' + char(10)
		SELECT @v_dSql += N'	                	    )          ' + char(10)
		SELECT @v_dSql += N'	                      AND 1=( -- 인스턴스별 SSP 재고 사용여부 : SSP 이면 SSP 쪽 활성화  ' + char(10)
		SELECT @v_dSql += N'	                      			SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = ''SSP'' THEN 1 ELSE 0 END), 1) AS IS_SSP  ' + char(10)
		SELECT @v_dSql += N'	                      			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              ' + char(10)
		SELECT @v_dSql += N'	                      			WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_STOCK_SOURCE''   ' + char(10)
		SELECT @v_dSql += N'	                      			AND    A.ACTIVE_FLAG = ''Y''    ' + char(10)
		SELECT @v_dSql += N'	                      			AND    A.SEGMENT1 = '''+ @p_instance_id +''' )                     ' + char(10)
		SELECT @v_dSql += N'	                  		AND   A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''')             ' + char(10)
		SELECT @v_dSql += N'	                  		AND   A.QTY > 0                         ' + char(10)
		SELECT @v_dSql += N'	                  ) A              ' + char(10)
		SELECT @v_dSql += N'	                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.WIPHOLD_YN ' + char(10)
		SELECT @v_dSql += N'	            	) A                ' + char(10)
		SELECT @v_dSql += N'	            	WHERE 1=1          ' + char(10)
		SELECT @v_dSql += N'	            	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID  ' + char(10)
		SELECT @v_dSql += N'	      		) A                    ' + char(10)
		SELECT @v_dSql += N'	  			LEFT OUTER JOIN (														-- Hazel Park Plant mapping 시켜줌                            ' + char(10)
		SELECT @v_dSql += N'									SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID                            ' + char(10)
		SELECT @v_dSql += N'											, A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID              ' + char(10)
		SELECT @v_dSql += N'									FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              ' + char(10)
		SELECT @v_dSql += N'									WHERE  A.LOOKUP_TYPE_CODE = ''FORMATION_PACK_INSTANCE_MAP''                          ' + char(10)
		SELECT @v_dSql += N'									AND    A.ACTIVE_FLAG = ''Y''    ' + char(10)
		SELECT @v_dSql += N'									AND	   A.SEGMENT4 = ''DU''      ' + char(10)
		SELECT @v_dSql += N'				) D                    ' + char(10)
		SELECT @v_dSql += N'					ON  A.DIVISION_ID  	= D.REF_DIVISION_ID         ' + char(10)
		SELECT @v_dSql += N'					AND A.SITE_ID      	= D.REF_SITE_ID             ' + char(10)
		SELECT @v_dSql += N'					AND A.PLANT_ID     	= D.REF_PLANT_ID            ' + char(10)
		SELECT @v_dSql += N'	      	WHERE 1=1                  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE_R', @p_item_id)) + char(10)
		SELECT @v_dSql += N'	      	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ISNULL(D.PLANT_ID, A.PLANT_ID), A.ITEM_ID                   ' + char(10)
		SELECT @v_dSql += N'	      )                            ' + char(10)
		SELECT @v_dSql += N'	      -- category : ''Plan''       ' + char(10)
		SELECT @v_dSql += N'	      , MAIN_P AS (                ' + char(10)
		SELECT @v_dSql += N'	          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                     ' + char(10)
		SELECT @v_dSql += N'	      		  , A.ITEM_ID, A.TOP_ITEM_ID                        ' + char(10)
		SELECT @v_dSql += N'	      		  , ISNULL((D.GOOD_CELL_QTY + D.HOLD_CELL_QTY + D.UNINSPEC_CELL_QTY + D.BOX_PACKING_CELL_QTY + D.LONG_TERM_CELL_QTY ),0) AS BOH_QTY                ' + char(10)
		SELECT @v_dSql += N'	      		  , ISNULL(D.GOOD_CELL_QTY,0) AS BOH_CELL_GOOD_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		  , ISNULL(D.HOLD_CELL_QTY,0) AS BOH_CELL_HOLD_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		  , ISNULL(D.UNINSPEC_CELL_QTY,0) AS BOH_CELL_UNINSPEC_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		  , ISNULL(D.BOX_PACKING_CELL_QTY,0) AS BOH_CELL_BOX_PACKING_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		  , ISNULL(D.LONG_TERM_CELL_QTY,0) AS BOH_CELL_LONG_TERM_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		  , ISNULL((D.GOOD_QTY + D.HOLD_QTY + D.INTRANSIT_QTY),0) AS BOH_PACK_QTY   ' + char(10)
		SELECT @v_dSql += N'	      		  , ISNULL(D.GOOD_QTY,0) AS BOH_PACK_GOOD_QTY       ' + char(10)
		SELECT @v_dSql += N'	      		  , ISNULL(D.HOLD_QTY,0) AS BOH_PACK_HOLD_QTY       ' + char(10)
		SELECT @v_dSql += N'	      		  , ISNULL(D.INTRANSIT_QTY,0) AS BOH_INTRANSIT_HOLD_QTY                     ' + char(10)
		SELECT @v_dSql += N'	      		  , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.FROM_CATEGORY       ' + char(10)
		SELECT @v_dSql += N'	      		  , ''DATA'' AS DATA_TYPE                           ' + char(10)
		
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

					SELECT @v_dSql += N'      			, 0 AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'      			, 0 AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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
					
					SELECT @v_dSql += N'                , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN ( CASE WHEN B.CATEGORY_ID = ''PLAN'' THEN ROUND(A.OUT_QTY,0) ELSE 0 END ) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql += N'	          FROM (                   ' + char(10)
		
		SELECT @v_dSql += N'	      			-- Coater - Cell/Pack Plan                      ' + char(10)

	    SELECT @v_dSql += N'					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID AS TOP_ITEM_ID, C.NICK_NAME AS TOP_NICK_NAME						' + char(10)          
		SELECT @v_dSql += N'							, A.ATTB_03 AS ITEM_ID, B.NICK_NAME AS NICK_NAME, A.ITEM_ID AS PACK_ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE      ' + char(10) 
		SELECT @v_dSql += N'							, SUM(ISNULL(A.SIM_IN_QTY,0) * A.ATTB_04) AS OUT_QTY, SUM(ISNULL(A.PLAN_IN_QTY, 0)) AS PACK_IN_QTY 								' + char(10)
		SELECT @v_dSql += N'					FROM   '+ @p_table_name +' A WITH(NOLOCK)              																				' + char(10)
		SELECT @v_dSql += N'					INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)       																						' + char(10)
		SELECT @v_dSql += N'					ON     A.COMPANY_ID   = B.COMPANY_ID            																						' + char(10)
		SELECT @v_dSql += N'					AND    A.DIVISION_ID  = B.DIVISION_ID           																						' + char(10)
		SELECT @v_dSql += N'					AND    A.SITE_ID      = B.SITE_ID               																						' + char(10)
		SELECT @v_dSql += N'					AND    A.ATTB_03 = B.ITEM_ID               																								' + char(10)
		SELECT @v_dSql += N'					AND    B.ACTIVE_FLAG  = ''Y''      																										' + char(10)
		SELECT @v_dSql += N'					INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)       																						' + char(10)
		SELECT @v_dSql += N'					ON     A.COMPANY_ID   = C.COMPANY_ID            																						' + char(10)
		SELECT @v_dSql += N'					AND    A.DIVISION_ID  = C.DIVISION_ID           																						' + char(10)
		SELECT @v_dSql += N'					AND    A.SITE_ID      = C.SITE_ID               																						' + char(10)
		SELECT @v_dSql += N'					AND    A.MODEL_ID  = C.ITEM_ID               																							' + char(10)
		SELECT @v_dSql += N'					AND    C.ACTIVE_FLAG  = ''Y''  																											' + char(10)
		SELECT @v_dSql += N'					WHERE 1=1																																' + char(10)
		SELECT @v_dSql += N'					AND A.SIM_PLAN_ID = '''+ @p_sim_plan_id +'''																							' + char(10)
		SELECT @v_dSql += N'	      			AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                        ' + char(10)
		SELECT @v_dSql += N'					AND A.OPERATION_ID IN (''P5000'', ''P5200'')																							' + char(10)
		SELECT @v_dSql += N'	      			AND    A.SIM_IN_QTY > 0                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ATTB_03' , 'LIKE_R', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE_R', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_CODE' , 'LIKE_R', @p_model_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE_R', @p_model_nick_name)) + char(10)
		SELECT @v_dSql += N'					GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID, C.NICK_NAME              										' + char(10)
		SELECT @v_dSql += N'							, A.ATTB_03, B.NICK_NAME, A.ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112)              										' + char(10)

		SELECT @v_dSql += N'	          ) A                      ' + char(10)
		SELECT @v_dSql += N'	          INNER JOIN (             ' + char(10)
		SELECT @v_dSql += N'	          		SELECT *           ' + char(10)
		SELECT @v_dSql += N'	          		FROM (             ' + char(10)
		SELECT @v_dSql += N'	          			SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER, '''' AS FROM_CATEGORY   ' + char(10)
		SELECT @v_dSql += N'	          			UNION ALL      ' + char(10)
		SELECT @v_dSql += N'	          			SELECT ''PLAN'' AS CATEGORY_ID, ''Pack Plan'' AS CATEGORY_NAME, 5 AS CATEGORY_ORDER, '''' AS FROM_CATEGORY                    ' + char(10)
		SELECT @v_dSql += N'	          			--UNION ALL    ' + char(10)
		SELECT @v_dSql += N'	          			--SELECT ''INV'' AS CATEGORY_ID, ''Inventory'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER, '''' AS FROM_CATEGORY                  ' + char(10)
		SELECT @v_dSql += N'	          		) BB               ' + char(10)
		SELECT @v_dSql += N'	          		WHERE CATEGORY_ID < > ''X''                     ' + char(10)
		SELECT @v_dSql += N'	          ) B                      ' + char(10)
		SELECT @v_dSql += N'	          ON 1=1                   ' + char(10)
		SELECT @v_dSql += N'	          INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)             ' + char(10)
		SELECT @v_dSql += N'	          ON  A.PLAN_DATE = C.YYYYMMDD                          ' + char(10)
		SELECT @v_dSql += N'	        	LEFT OUTER HASH JOIN BOH_INFO D                     ' + char(10)
		SELECT @v_dSql += N'	        	ON  A.COMPANY_ID  = D.COMPANY_ID                    ' + char(10)
		SELECT @v_dSql += N'	        	AND A.DIVISION_ID = D.DIVISION_ID                   ' + char(10)
		SELECT @v_dSql += N'	        	AND A.SITE_ID     = D.SITE_ID                       ' + char(10)
		SELECT @v_dSql += N'	        	AND A.PLANT_ID    = D.PLANT_ID                      ' + char(10)
		SELECT @v_dSql += N'	        	AND A.ITEM_ID     = D.ITEM_ID                       ' + char(10)
		SELECT @v_dSql += N'	        	WHERE 1=1              ' + char(10)
		SELECT @v_dSql += N'	        	GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.ITEM_ID, A.TOP_ITEM_ID                       ' + char(10)	
		SELECT @v_dSql += N'	        			, D.GOOD_CELL_QTY, D.HOLD_CELL_QTY, D.UNINSPEC_CELL_QTY, D.BOX_PACKING_CELL_QTY, D.LONG_TERM_CELL_QTY, D.GOOD_QTY, D.HOLD_QTY, D.INTRANSIT_QTY              ' + char(10)
		SELECT @v_dSql += N'	                 , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.FROM_CATEGORY    ' + char(10)
		SELECT @v_dSql += N'	      )                            ' + char(10)
		SELECT @v_dSql += N'	      -- Shipment result, EOL Plan, Production result           ' + char(10)
		SELECT @v_dSql += N'	      , RESULT_INFO AS (           ' + char(10)
		SELECT @v_dSql += N'	      	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                       ' + char(10)
		SELECT @v_dSql += N'	      		 , A.ITEM_ID, NULL AS TOP_ITEM_ID                   ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL((D.GOOD_CELL_QTY + D.HOLD_CELL_QTY + D.UNINSPEC_CELL_QTY + D.BOX_PACKING_CELL_QTY + D.LONG_TERM_CELL_QTY),0) AS BOH_QTY                 ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(D.GOOD_CELL_QTY,0) AS BOH_CELL_GOOD_QTY   ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(D.HOLD_CELL_QTY,0) AS BOH_CELL_HOLD_QTY   ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(D.UNINSPEC_CELL_QTY,0) AS BOH_CELL_UNINSPEC_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(D.BOX_PACKING_CELL_QTY,0) AS BOH_CELL_BOX_PACKING_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(D.LONG_TERM_CELL_QTY,0) AS BOH_CELL_LONG_TERM_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL((D.GOOD_QTY + D.HOLD_QTY + D.INTRANSIT_QTY),0) AS BOH_PACK_QTY    ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(D.GOOD_QTY,0) AS BOH_PACK_GOOD_QTY        ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(D.HOLD_QTY,0) AS BOH_PACK_HOLD_QTY        ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(D.INTRANSIT_QTY,0) AS BOH_INTRANSIT_HOLD_QTY                      ' + char(10)
		SELECT @v_dSql += N'	      		 , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, NULL AS FROM_CATEGORY  ' + char(10)
		SELECT @v_dSql += N'	      		 , ''DATA'' AS DATA_TYPE                            ' + char(10)
		
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

					SELECT @v_dSql += N'      			, 0 AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'      			, 0 AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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
					
					SELECT @v_dSql += N'                , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN ( CASE WHEN B.CATEGORY_ID = A.CATEGORY_ID THEN ROUND(A.QTY,0) ELSE 0 END ) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql += N'	      	FROM (                     ' + char(10)
		SELECT @v_dSql += N'	      		-- Production Result : 특성 생산 실적               ' + char(10)
		SELECT @v_dSql += N'	      		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(VV.CELL_PRODUCT, A.ITEM_ID) AS ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, SUM(A.ACTUAL_GOOD_QTY) AS QTY, ''PRODUCTION_RESULT'' AS CATEGORY_ID   ' + char(10)
		SELECT @v_dSql += N'	      		FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)    ' + char(10)
		SELECT @v_dSql += N'	      				LEFT OUTER JOIN #CELL_ITEM_V VV	-- 활성화 코드 분리 관련 추가 @@@	' + char(10)
		SELECT @v_dSql += N'	      				ON 1=1									' + char(10)
		SELECT @v_dSql += N'	      				AND	A.COMPANY_ID    =  VV.COMPANY_ID    ' + char(10)          
	    SELECT @v_dSql += N'	      				AND A.DIVISION_ID   =  VV.DIVISION_ID   ' + char(10)          
	    SELECT @v_dSql += N'	      				AND A.SITE_ID       =  VV.SITE_ID		' + char(10)
		SELECT @v_dSql += N'	      				AND A.ITEM_ID       =  VV.CELL_ASSY		' + char(10)
		SELECT @v_dSql += N'	      		INNER HASH JOIN (      ' + char(10)
		SELECT @v_dSql += N'	      			--- PACK에 연결된 특성 INSTANCE의 속성정보 ---  ' + char(10)
		SELECT @v_dSql += N'	      			SELECT DISTINCT INSTANCE_ID, COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID                           ' + char(10)
		SELECT @v_dSql += N'	      			FROM   FP_INSTANCE_INFO_V V WITH(NOLOCK)        ' + char(10)
		SELECT @v_dSql += N'	      			WHERE  1=1                     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('V.INSTANCE_ID' , 'EQ', @p_formation_instance_id)) + char(10)
		SELECT @v_dSql += N'	      		) B                    ' + char(10)
		SELECT @v_dSql += N'	      		ON     A.COMPANY_ID    =  B.COMPANY_ID              ' + char(10)
		SELECT @v_dSql += N'	      		AND    A.DIVISION_ID   =  B.DIVISION_ID             ' + char(10)
		SELECT @v_dSql += N'	      		AND    A.SITE_ID       =  B.SITE_ID                 ' + char(10)
		SELECT @v_dSql += N'	      		AND    A.PLANT_ID      =  B.PLANT_ID                ' + char(10)
		SELECT @v_dSql += N'	      		WHERE  1=1             ' + char(10)
		SELECT @v_dSql += N'	      		AND    A.OPERATION_ID  =  ''F6000''                 ' + char(10)
		SELECT @v_dSql += N'	      		AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                            ' + char(10)
		SELECT @v_dSql += N'	      		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(VV.CELL_PRODUCT, A.ITEM_ID), CONVERT(VARCHAR,A.PLAN_DATE,112) ' + char(10)
		SELECT @v_dSql += N'	      		-- Shipment Result     ' + char(10)
		SELECT @v_dSql += N'	      		UNION ALL              ' + char(10)
		SELECT @v_dSql += N'	      		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.SHIP_YYYYMMDD AS PLAN_DATE, SUM(QTY) AS QTY, ''SHIPMENT_RESULT'' AS CATEGORY_ID       ' + char(10)
		SELECT @v_dSql += N'	      		FROM   SCM_FCS_SHIP_V A WITH(NOLOCK), (             ' + char(10)
		SELECT @v_dSql += N'	      			SELECT  DISTINCT COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID          ' + char(10)
		SELECT @v_dSql += N'	      			FROM    FP_INSTANCE_INFO_V V WITH(NOLOCK)       ' + char(10)
		SELECT @v_dSql += N'	      			WHERE  V.INSTANCE_ID = '''+ @p_instance_id +''' ---> 선택한 인스턴스.              ' + char(10)
		SELECT @v_dSql += N'	      		) B                    ' + char(10)
		SELECT @v_dSql += N'	      		WHERE A.COMPANY_ID    =  B.COMPANY_ID               ' + char(10)
		SELECT @v_dSql += N'	      		AND   A.DIVISION_ID   =  B.DIVISION_ID              ' + char(10)
		SELECT @v_dSql += N'	      		AND   A.SITE_ID       =  B.SITE_ID                  ' + char(10)
		SELECT @v_dSql += N'	      		AND   A.PLANT_ID      =  B.PLANT_ID                 ' + char(10)
		SELECT @v_dSql += N'	      		AND   A.BIZ_TYPE      =  ''P''                      ' + char(10)
		SELECT @v_dSql += N'	      		AND   ISNULL(A.QTY,0) >  0              --- (-)실적 걸러냄.                 ' + char(10)
		SELECT @v_dSql += N'	      		AND   A.SHIP_YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                 ' + char(10)
		SELECT @v_dSql += N'	      		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.SHIP_YYYYMMDD                  ' + char(10)
		SELECT @v_dSql += N'	      		-- EOL Plan            ' + char(10)
		SELECT @v_dSql += N'	      		UNION ALL              ' + char(10)
		/*
		SELECT @v_dSql += N'	      		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, SUM(OUT_QTY) AS QTY, ''EOL_PLAN'' AS CATEGORY_ID                      ' + char(10)
		SELECT @v_dSql += N'	      		FROM   FP_AMEND_PLAN_FORM_H A WITH(NOLOCK)          ' + char(10)
		SELECT @v_dSql += N'	      		INNER HASH JOIN (      ' + char(10)
		SELECT @v_dSql += N'	      				--== FORMATION의 LAST RELEASE PLAN ID 검색 ==--                     ' + char(10)
		SELECT @v_dSql += N'	      				SELECT A.INSTANCE_ID, A.RELEASE_PLAN_ID, A.AMEND_PLAN_ID, A.FACTORY_ID, A.PLAN_GROUP_ID, A.INSTANCE_DATE, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID                       ' + char(10)
		SELECT @v_dSql += N'	      				FROM (         ' + char(10)
		SELECT @v_dSql += N'	      						SELECT A.INSTANCE_ID, A.RELEASE_PLAN_ID, A.AMEND_PLAN_ID, A.FACTORY_ID, A.PLAN_GROUP_ID, A.INSTANCE_DATE              ' + char(10)
		SELECT @v_dSql += N'	      							   , DENSE_RANK() OVER(PARTITION BY A.INSTANCE_ID, A.FACTORY_ID ORDER BY INSTANCE_DATE DESC, RELEASE_PLAN_ID ASC ) AS RNK                 ' + char(10)
		SELECT @v_dSql += N'	      						FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                ' + char(10)
		SELECT @v_dSql += N'	      						WHERE  1=1          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_formation_instance_id)) + char(10)
		SELECT @v_dSql += N'	      						AND    A.INSTANCE_DATE <= '''+ @p_plan_date +'''  --->  INSTACNE_DATE  ' + char(10)
		SELECT @v_dSql += N'	      				)  A, (        ' + char(10)
		SELECT @v_dSql += N'	      						SELECT DISTINCT INSTANCE_ID , COMPANY_ID, DIVISION_ID , SITE_ID, PLANT_ID                ' + char(10)
		SELECT @v_dSql += N'	      						FROM   FP_INSTANCE_INFO_V           ' + char(10)
		SELECT @v_dSql += N'	      				) B            ' + char(10)
		SELECT @v_dSql += N'	      				WHERE A.RNK = 1' + char(10)
		SELECT @v_dSql += N'	      				AND   A.INSTANCE_ID = B.INSTANCE_ID         ' + char(10)
		SELECT @v_dSql += N'	      		) M                    ' + char(10)
		SELECT @v_dSql += N'	      		ON    A.INSTANCE_ID     = M.INSTANCE_ID             ' + char(10)
		SELECT @v_dSql += N'	      		AND   A.FP_PLAN_ID      = M.RELEASE_PLAN_ID         ' + char(10)
		SELECT @v_dSql += N'	      		AND   A.DIVISION_ID     = M.DIVISION_ID             ' + char(10)
		SELECT @v_dSql += N'	      		AND   A.FACTORY_ID      = M.FACTORY_ID              ' + char(10)
		SELECT @v_dSql += N'	      		WHERE A.OPERATION_ID    = ''F6000''    --- 특성공정코드                     ' + char(10)
		SELECT @v_dSql += N'	      		AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''' + char(10)
		SELECT @v_dSql += N'	      		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) ' + char(10)
		*/
		SELECT @v_dSql += N'	      		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(VV.CELL_PRODUCT, A.ITEM_ID) AS ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, SUM(PLAN_QTY) AS QTY, ''EOL_PLAN'' AS CATEGORY_ID                      ' + char(10)
		SELECT @v_dSql += N'	      					FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                      ' + char(10)
		SELECT @v_dSql += N'	      				LEFT OUTER JOIN #CELL_ITEM_V VV	-- 활성화 코드 분리 관련 추가 @@@	' + char(10)
		SELECT @v_dSql += N'	      				ON 1=1									' + char(10)
		SELECT @v_dSql += N'	      				AND	A.COMPANY_ID    =  VV.COMPANY_ID    ' + char(10)          
	    SELECT @v_dSql += N'	      				AND A.DIVISION_ID   =  VV.DIVISION_ID   ' + char(10)          
	    SELECT @v_dSql += N'	      				AND A.SITE_ID       =  VV.SITE_ID		' + char(10)
		SELECT @v_dSql += N'	      				AND A.ITEM_ID       =  VV.CELL_ASSY		' + char(10)
		SELECT @v_dSql += N'									INNER  JOIN (														' + char(10)
		SELECT @v_dSql += N'										SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID		' + char(10)
		SELECT @v_dSql += N'										FROM   FP_INSTANCE_INFO_V										' + char(10)
		SELECT @v_dSql += N'										WHERE 1=1														' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('INSTANCE_ID' , 'EQ', @p_formation_instance_id)) + char(10)
		SELECT @v_dSql += N'									) B																	' + char(10)
		SELECT @v_dSql += N'									ON 1=1																' + char(10)
		SELECT @v_dSql += N'									AND A.COMPANY_ID = B.COMPANY_ID										' + char(10)
		SELECT @v_dSql += N'									AND A.DIVISION_ID = B.DIVISION_ID									' + char(10)
		SELECT @v_dSql += N'									AND A.SITE_ID = B.SITE_ID											' + char(10)
		SELECT @v_dSql += N'									AND A.PLANT_ID = B.PLANT_ID											' + char(10)
		SELECT @v_dSql += N'							WHERE  1=1																	' + char(10)
		SELECT @v_dSql += N'	      					AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                 ' + char(10)
		SELECT @v_dSql += N'							AND    A.PLAN_TYPE =  ''RELEASE''						' + char(10)
		SELECT @v_dSql += N'							AND    A.OPERATION_ID =  ''F6000''						' + char(10)
		SELECT @v_dSql += N'							AND    A.PLAN_QTY > 0						' + char(10)
		SELECT @v_dSql += N'	      		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(VV.CELL_PRODUCT, A.ITEM_ID), CONVERT(VARCHAR,A.PLAN_DATE,112) ' + char(10)
		SELECT @v_dSql += N'	      	) A                        ' + char(10)
		SELECT @v_dSql += N'	      	INNER JOIN (               ' + char(10)
		SELECT @v_dSql += N'	      		SELECT *               ' + char(10)
		SELECT @v_dSql += N'	      		FROM (                 ' + char(10)
		SELECT @v_dSql += N'	      				SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER                          ' + char(10)
		SELECT @v_dSql += N'	      				UNION ALL      ' + char(10)
		SELECT @v_dSql += N'	      				SELECT ''SHIPMENT_RESULT'' AS CATEGORY_ID, ''Shipment Result'' AS CATEGORY_NAME, 12 AS CATEGORY_ORDER                         ' + char(10)
		SELECT @v_dSql += N'	      				UNION ALL      ' + char(10)
		SELECT @v_dSql += N'	      				SELECT ''EOL_PLAN'' AS CATEGORY_ID, ''EOL Plan'' AS CATEGORY_NAME, 15 AS CATEGORY_ORDER          ' + char(10)
		SELECT @v_dSql += N'	      				UNION ALL      ' + char(10)
		SELECT @v_dSql += N'	      				SELECT ''PRODUCTION_RESULT'' AS CATEGORY_ID, ''Production Result'' AS CATEGORY_NAME, 17 AS CATEGORY_ORDER                     ' + char(10)
		SELECT @v_dSql += N'	      		) BB                   ' + char(10)
		SELECT @v_dSql += N'	      		WHERE BB.CATEGORY_ID < > ''X''                      ' + char(10)
		SELECT @v_dSql += N'	      	) B                        ' + char(10)
		SELECT @v_dSql += N'	      	ON 1=1                     ' + char(10)
		SELECT @v_dSql += N'	      	INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)               ' + char(10)
		SELECT @v_dSql += N'	      	ON  A.PLAN_DATE   = C.YYYYMMDD                          ' + char(10)
		SELECT @v_dSql += N'	      	LEFT OUTER HASH JOIN BOH_INFO D                         ' + char(10)
		SELECT @v_dSql += N'	      	ON  A.COMPANY_ID  = D.COMPANY_ID                        ' + char(10)
		SELECT @v_dSql += N'	      	AND A.DIVISION_ID = D.DIVISION_ID                       ' + char(10)
		SELECT @v_dSql += N'	      	AND A.SITE_ID     = D.SITE_ID                           ' + char(10)
		SELECT @v_dSql += N'	      	AND A.PLANT_ID    = D.PLANT_ID                          ' + char(10)
		SELECT @v_dSql += N'	      	AND A.ITEM_ID     = D.ITEM_ID                           ' + char(10)
		SELECT @v_dSql += N'	      	WHERE 1=1                  ' + char(10)
		SELECT @v_dSql += N'	      	AND   EXISTS (             ' + char(10)
		SELECT @v_dSql += N'	      		SELECT 1 FROM (        ' + char(10)
		SELECT @v_dSql += N'										SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID , A.ATTB_03 AS CELL_ITEM_ID	' + char(10) 
		SELECT @v_dSql += N'										FROM   '+ @p_table_name +' A WITH(NOLOCK)              																				' + char(10)
		SELECT @v_dSql += N'	              						INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'	              						ON     A.COMPANY_ID   = B.COMPANY_ID        ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.DIVISION_ID  = B.DIVISION_ID       ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.SITE_ID      = B.SITE_ID           ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.ATTB_03	  = B.ITEM_ID           ' + char(10)
		SELECT @v_dSql += N'	      								AND    B.ACTIVE_FLAG  = ''Y''               ' + char(10)
		SELECT @v_dSql += N'	              						INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'	              						ON     A.COMPANY_ID   = C.COMPANY_ID        ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.DIVISION_ID  = C.DIVISION_ID       ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.SITE_ID      = C.SITE_ID           ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.MODEL_ID   = C.ITEM_ID           ' + char(10)
		SELECT @v_dSql += N'	      								AND    C.ACTIVE_FLAG  = ''Y''               ' + char(10)
		SELECT @v_dSql += N'										WHERE 1=1																																' + char(10)
		SELECT @v_dSql += N'										AND A.SIM_PLAN_ID = '''+ @p_sim_plan_id +'''																							' + char(10)
		SELECT @v_dSql += N'	      								AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                        ' + char(10)
		SELECT @v_dSql += N'										AND A.OPERATION_ID IN (''P5000'', ''P5200'')																							' + char(10)
		SELECT @v_dSql += N'	      								AND    A.SIM_IN_QTY > 0                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ATTB_03' , 'LIKE_R', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE_R', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'LIKE_R', @p_model_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE_R', @p_model_nick_name)) + char(10)
		SELECT @v_dSql += N'	      		) AA                   ' + char(10)
		SELECT @v_dSql += N'	      		WHERE A.COMPANY_ID  = AA.COMPANY_ID                 ' + char(10)
		SELECT @v_dSql += N'	      		AND   A.DIVISION_ID = AA.DIVISION_ID                ' + char(10)
		SELECT @v_dSql += N'	      		AND   A.SITE_ID     = AA.SITE_ID                    ' + char(10)
		SELECT @v_dSql += N'	      		AND   A.ITEM_ID     = AA.CELL_ITEM_ID               ' + char(10)
		SELECT @v_dSql += N'	      	)                          ' + char(10)
		SELECT @v_dSql += N'	      	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID   ' + char(10)
		SELECT @v_dSql += N'	        		, D.GOOD_CELL_QTY, D.HOLD_CELL_QTY, D.UNINSPEC_CELL_QTY, D.BOX_PACKING_CELL_QTY, D.LONG_TERM_CELL_QTY,D.GOOD_QTY, D.HOLD_QTY, D.INTRANSIT_QTY              ' + char(10)
		SELECT @v_dSql += N'	      			, B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER                       ' + char(10)
		SELECT @v_dSql += N'	      )                            ' + char(10)
		SELECT @v_dSql += N'	      , MAIN_R AS (                ' + char(10)
		SELECT @v_dSql += N'	           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                    ' + char(10)
		SELECT @v_dSql += N'	                , A.ITEM_ID, NULL AS TOP_ITEM_ID                ' + char(10)
		SELECT @v_dSql += N'	                , ISNULL((D.GOOD_CELL_QTY + D.HOLD_CELL_QTY + D.UNINSPEC_CELL_QTY + D.BOX_PACKING_CELL_QTY + D.LONG_TERM_CELL_QTY), 0) AS BOH_QTY             ' + char(10)
		SELECT @v_dSql += N'	                , ISNULL(D.GOOD_CELL_QTY, 0) AS BOH_CELL_GOOD_QTY                       ' + char(10)
		SELECT @v_dSql += N'	                , ISNULL(D.HOLD_CELL_QTY, 0) AS BOH_CELL_HOLD_QTY                       ' + char(10)
		SELECT @v_dSql += N'	      		    , ISNULL(D.UNINSPEC_CELL_QTY,0) AS BOH_CELL_UNINSPEC_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		    , ISNULL(D.BOX_PACKING_CELL_QTY,0) AS BOH_CELL_BOX_PACKING_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		    , ISNULL(D.LONG_TERM_CELL_QTY,0) AS BOH_CELL_LONG_TERM_QTY  ' + char(10)
		SELECT @v_dSql += N'	                , ISNULL((D.GOOD_QTY + D.HOLD_QTY + D.INTRANSIT_QTY), 0) AS BOH_PACK_QTY' + char(10)
		SELECT @v_dSql += N'	                , ISNULL(D.GOOD_QTY, 0) AS BOH_PACK_GOOD_QTY    ' + char(10)
		SELECT @v_dSql += N'	                , ISNULL(D.HOLD_QTY, 0) AS BOH_PACK_HOLD_QTY    ' + char(10)
		SELECT @v_dSql += N'	                , ISNULL(D.INTRANSIT_QTY, 0) AS BOH_INTRANSIT_HOLD_QTY                  ' + char(10)
		SELECT @v_dSql += N'	                , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.FROM_CATEGORY     ' + char(10)
		SELECT @v_dSql += N'	                , ''DATA'' AS DATA_TYPE                         ' + char(10)
		
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

					SELECT @v_dSql += N'      			, 0 AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'      			, 0 AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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
					
					SELECT @v_dSql += N'                , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN ( CASE WHEN B.CATEGORY_ID = A.CATEGORY_ID AND B.FROM_INSTANCE = A.FROM_INSTANCE THEN ROUND(A.RECEIPT_QTY,0) ELSE 0 END ) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'	          FROM  #TEMP_TABLE_01  A' + char(10)
		--SELECT @v_dSql += N'	          FROM  (		' + char(10)
		--SELECT @v_dSql += @v_tempSql
		--SELECT @v_dSql += N'					) A		' + char(10)
		SELECT @v_dSql += N'	    			INNER JOIN (       ' + char(10)
		SELECT @v_dSql += N'	    					SELECT *   ' + char(10)
		SELECT @v_dSql += N'	    					FROM (     ' + char(10)
		SELECT @v_dSql += N'	    							SELECT 	''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER, '''' AS FROM_CATEGORY, '''' FROM_INSTANCE                       ' + char(10)
		SELECT @v_dSql += N'	    							UNION ALL                       ' + char(10)
		SELECT @v_dSql += N'	    							SELECT 	''INHOUSE'' AS CATEGORY_ID, ''Moving Plan'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER, '''' AS FROM_CATEGORY, '''' AS FROM_INSTANCE  ' + char(10)
		SELECT @v_dSql += N'	    							UNION ALL                       ' + char(10)
		SELECT @v_dSql += N'	    							SELECT	A.SEGMENT2 AS CATEGORY_ID, A.SEGMENT3 AS CATEGORY_NAME, A.SEGMENT4 AS CATEGORY_ORDER, A.SEGMENT5 AS FROM_CATEGORY, A.ATTRIBUTE1 AS FROM_INSTANCE               ' + char(10)
		SELECT @v_dSql += N'	    							FROM	SCM_SYS_LOOKUP_VALUE A  ' + char(10)
		SELECT @v_dSql += N'	    							WHERE	A.LOOKUP_TYPE_CODE = ''CELL_SIMULATION_INTRANSIT_INFO''                      ' + char(10)
		SELECT @v_dSql += N'	    							AND		A.SEGMENT1 = '''+ @p_instance_id +'''                      ' + char(10)
		SELECT @v_dSql += N'	    							AND		A.ACTIVE_FLAG = ''Y''   ' + char(10)
		SELECT @v_dSql += N'	    						) BB   ' + char(10)
		SELECT @v_dSql += N'	    					WHERE BB.CATEGORY_ID < > ''X''          ' + char(10)
		SELECT @v_dSql += N'	    			) B                ' + char(10)
		SELECT @v_dSql += N'	           ON 1=1                  ' + char(10)
		/*
		SELECT @v_dSql += N'	           {                       ' + char(10)
		SELECT @v_dSql += N'	            // hash join 오류로 인한 hint 동적 처리             ' + char(10)
		SELECT @v_dSql += N'	            var sql = "";          ' + char(10)
		SELECT @v_dSql += N'	            var sHash = "HASH";    ' + char(10)
		SELECT @v_dSql += N'	            // 하나라도 널이 아니면 hash 걸면 안됨              ' + char(10)
		SELECT @v_dSql += N'	            if(($data.ITEM_ID         != null && $data.ITEM_ID != "")                   ' + char(10)
		SELECT @v_dSql += N'	            || ($data.NICK_NAME       != null && $data.NICK_NAME != "")                 ' + char(10)
		SELECT @v_dSql += N'	            || ($data.MODEL_ID        != null && $data.MODEL_ID != "")                  ' + char(10)
		SELECT @v_dSql += N'	            || ($data.MODEL_NICK_NAME != null && $data.MODEL_NICK_NAME != ""))  sHash = "";                          ' + char(10)
		SELECT @v_dSql += N'	      ' + char(10)
		SELECT @v_dSql += N'	            sql;                   ' + char(10)
		SELECT @v_dSql += N'	      ' + char(10)
		SELECT @v_dSql += N'	           	//hash 제외            ' + char(10)
		SELECT @v_dSql += N'	           }                       ' + char(10)
		*/
		SELECT @v_dSql += N'	           INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)            ' + char(10)
		SELECT @v_dSql += N'	           ON  A.PLAN_DATE   = C.YYYYMMDD                       ' + char(10)
		SELECT @v_dSql += N'	           LEFT OUTER HASH JOIN BOH_INFO D                      ' + char(10)
		SELECT @v_dSql += N'	           ON  A.COMPANY_ID  = D.COMPANY_ID                     ' + char(10)
		SELECT @v_dSql += N'	           AND A.DIVISION_ID = D.DIVISION_ID                    ' + char(10)
		SELECT @v_dSql += N'	           AND A.SITE_ID     = D.SITE_ID                        ' + char(10)
		SELECT @v_dSql += N'	           AND A.PLANT_ID    = D.PLANT_ID                       ' + char(10)
		SELECT @v_dSql += N'	           AND A.ITEM_ID     = D.ITEM_ID                        ' + char(10)
		SELECT @v_dSql += N'	           WHERE 1=1               ' + char(10)
		SELECT @v_dSql += N'	           AND   A.RECEIPT_QTY > 0 ' + char(10)
		SELECT @v_dSql += N'	           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID             ' + char(10)
		SELECT @v_dSql += N'	        			, D.GOOD_CELL_QTY, D.HOLD_CELL_QTY, D.UNINSPEC_CELL_QTY, D.BOX_PACKING_CELL_QTY, D.LONG_TERM_CELL_QTY, D.GOOD_QTY, D.HOLD_QTY, D.INTRANSIT_QTY              ' + char(10)
		SELECT @v_dSql += N'	                  , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.FROM_CATEGORY   ' + char(10)
		SELECT @v_dSql += N'	      )                            ' + char(10)
		SELECT @v_dSql += N'	      , MAIN_I AS (                ' + char(10)
		SELECT @v_dSql += N'	      	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                       ' + char(10)
		SELECT @v_dSql += N'	      		 , A.ITEM_ID, NULL AS TOP_ITEM_ID                   ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(A.BOH_QTY,0) AS BOH_QTY                   ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(A.BOH_CELL_GOOD_QTY,0) AS BOH_CELL_GOOD_QTY                       ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(A.BOH_CELL_HOLD_QTY,0) AS BOH_CELL_HOLD_QTY                       ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(A.BOH_CELL_UNINSPEC_QTY,0) AS BOH_CELL_UNINSPEC_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(A.BOH_CELL_BOX_PACKING_QTY,0) AS BOH_CELL_BOX_PACKING_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(A.BOH_CELL_LONG_TERM_QTY,0) AS BOH_CELL_LONG_TERM_QTY  ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(A.BOH_PACK_QTY,0) AS BOH_PACK_QTY         ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(A.BOH_PACK_GOOD_QTY,0) AS BOH_PACK_GOOD_QTY                       ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(A.BOH_PACK_HOLD_QTY,0) AS BOH_PACK_HOLD_QTY                       ' + char(10)
		SELECT @v_dSql += N'	      		 , ISNULL(A.BOH_INTRANSIT_HOLD_QTY,0) AS BOH_INTRANSIT_HOLD_QTY             ' + char(10)
		SELECT @v_dSql += N'	      		 , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, NULL AS FROM_CATEGORY  ' + char(10)
		SELECT @v_dSql += N'	      		 , ''DATA'' AS DATA_TYPE                            ' + char(10)
		
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

					SELECT @v_dSql += N'      			, 0 AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'      			, 0 AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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
					
					SELECT @v_dSql += N'                , SUM(CASE WHEN A.PLAN_DATE <= ''' + @sub_param_0 + ''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' THEN ( CASE WHEN B.CATEGORY_ID = ''EOH_MOVING''		  THEN A.EOH_MOVING_QTY ' + char(10) 
							SELECT @v_dSql += N'	                        		 				       WHEN B.CATEGORY_ID = ''EOH_MOVING_HOLD''     THEN A.EOH_MOVING_HOLD_QTY	' + char(10)
							SELECT @v_dSql += N'	                        		 				       WHEN B.CATEGORY_ID = ''EOH_EOL''             THEN A.EOH_EOL_QTY    ' + char(10)
							SELECT @v_dSql += N'	                        		 				       WHEN B.CATEGORY_ID = ''EOH_EOL_UNINSPECTION_QTY'' THEN A.EOH_EOL_UNINSPECTION_QTY    ' + char(10)
							SELECT @v_dSql += N'	                        		 				       WHEN B.CATEGORY_ID = ''EOH_EOL_HOLD''        THEN A.EOH_EOL_HOLD_QTY	' + char(10)
							SELECT @v_dSql += N'	                        		 				       WHEN B.CATEGORY_ID = ''EOH_CELL_TOTAL''      THEN A.EOH_CELL_TOTAL_QTY	' + char(10)
							SELECT @v_dSql += N'	                        		 				       WHEN B.CATEGORY_ID = ''EOH_CELL_TOTAL_HOLD'' THEN A.EOH_CELL_TOTAL_HOLD_QTY	' + char(10)
							SELECT @v_dSql += N'	                        		 				  ELSE 0 END ) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql += N'	      	FROM (                     ' + char(10)
		SELECT @v_dSql += N'	      		SELECT A.*             ' + char(10)
		SELECT @v_dSql += N'					       , (B.GOOD_CELL_QTY + B.HOLD_CELL_QTY + B.UNINSPEC_CELL_QTY + B.BOX_PACKING_CELL_QTY + B.LONG_TERM_CELL_QTY) AS BOH_QTY                 ' + char(10)
		SELECT @v_dSql += N'					       , B.GOOD_CELL_QTY AS BOH_CELL_GOOD_QTY   ' + char(10)
		SELECT @v_dSql += N'					       , B.HOLD_CELL_QTY AS BOH_CELL_HOLD_QTY   ' + char(10)
		SELECT @v_dSql += N'	      				   , B.UNINSPEC_CELL_QTY AS BOH_CELL_UNINSPEC_QTY  ' + char(10)
		SELECT @v_dSql += N'	      				   , B.BOX_PACKING_CELL_QTY AS BOH_CELL_BOX_PACKING_QTY  ' + char(10)
		SELECT @v_dSql += N'	      				   , B.LONG_TERM_CELL_QTY AS BOH_CELL_LONG_TERM_QTY  ' + char(10)
		SELECT @v_dSql += N'					       , (B.GOOD_QTY + B.HOLD_QTY + B.INTRANSIT_QTY) AS BOH_PACK_QTY    ' + char(10)
		SELECT @v_dSql += N'					       , B.GOOD_QTY AS BOH_PACK_GOOD_QTY        ' + char(10)
		SELECT @v_dSql += N'					       , B.HOLD_QTY AS BOH_PACK_HOLD_QTY        ' + char(10)
		SELECT @v_dSql += N'					       , B.INTRANSIT_QTY AS BOH_INTRANSIT_HOLD_QTY                      ' + char(10)
		--SELECT @v_dSql += N'					       -- EOH(Moving)      : BOH(P)_GOOD               + 당일Moving plan + 당일Receipt(Plan+Intransit) - 당일Pack Plan            ' + char(10)
		SELECT @v_dSql += N'					       , CASE WHEN A.PLAN_DATE = CONVERT(DATE,'''+ @p_plan_date +''') THEN (ISNULL(B.GOOD_QTY,0) + MOVING_QTY + RECEIPT_QTY - PLAN_QTY)      ' + char(10)
		SELECT @v_dSql += N'						                            ELSE (0                    + MOVING_QTY + RECEIPT_QTY - PLAN_QTY) END AS EOH_MOVING_QTY      ' + char(10)
		--SELECT @v_dSql += N'					       -- EOH(Moving)_Hold : BOH(P)_GOOD + BOH(P)_HOLD + 당일Moving plan + D-1Receipt(Plan+Intransit) - 당일Pack Plan            ' + char(10)
		SELECT @v_dSql += N'					       , CASE WHEN A.PLAN_DATE = CONVERT(DATE,'''+ @p_plan_date +''') THEN (ISNULL(B.GOOD_QTY,0) + ISNULL(B.HOLD_QTY,0) + MOVING_QTY + RECEIPT_QTY - PLAN_QTY)       ' + char(10)
		SELECT @v_dSql += N'						                            ELSE (0              + MOVING_QTY + RECEIPT_QTY - PLAN_QTY) END AS EOH_MOVING_HOLD_QTY       ' + char(10)
		--SELECT @v_dSql += N'					       -- EOH_Pack(EOL) : BOH(C)_GOOD  + BOH(P)_GOOD + D-1_EOL_PLAN + D-1 Receipt(Plan+Intransit) - 당일Pack Plan   ' + char(10)
		SELECT @v_dSql += N'					       , CASE WHEN A.PLAN_DATE = CONVERT(DATE,'''+ @p_plan_date +''') THEN (ISNULL(B.GOOD_CELL_QTY,0) + ISNULL(B.GOOD_QTY,0) + EOL_QTY + RECEIPT_QTY - PLAN_QTY)     ' + char(10)
		SELECT @v_dSql += N'	        					                    ELSE (0                   + EOL_QTY + RECEIPT_QTY - PLAN_QTY) END AS EOH_EOL_QTY             ' + char(10)
		--SELECT @v_dSql += N'					       -- EOH_Pack(EOL[+Hold + Box pkg]) : BOH(C)_GOOD  + BOH(P)_GOOD + BOH(C)_uninspection + BOH(C)_Hold + BOH(C)_Box pkg  + BOH(C)_Long Term + D-1_EOL_PLAN + D-1 Receipt(Plan+Intransit) - 당일Pack Plan                          ' + char(10)
		SELECT @v_dSql += N'					       , CASE WHEN A.PLAN_DATE = CONVERT(DATE,'''+ @p_plan_date +''') THEN (ISNULL(B.GOOD_CELL_QTY,0) + ISNULL(B.HOLD_CELL_QTY,0)  + ISNULL(B.UNINSPEC_CELL_QTY,0) + ISNULL(B.BOX_PACKING_CELL_QTY,0)  + ISNULL(B.LONG_TERM_CELL_QTY,0) + ISNULL(B.GOOD_QTY,0) + ISNULL(B.HOLD_QTY,0) + EOL_QTY + RECEIPT_QTY - PLAN_QTY)            ' + char(10)
		SELECT @v_dSql += N'	        				                      ELSE (0                 + EOL_QTY + RECEIPT_QTY - PLAN_QTY) END AS EOH_EOL_HOLD_QTY	' + char(10)
		--SELECT @v_dSql += N'					       -- EOH_Pack(EOL[Uninspection]) : BOH(C)_GOOD  + BOH(P)_GOOD + BOH(C)_uninspection + D-1_EOL_PLAN + 당일 Receipt(Plan+Intransit) - 당일Pack Plan                    ' + char(10)
		SELECT @v_dSql += N'					       , CASE WHEN A.PLAN_DATE = CONVERT(DATE,'''+ @p_plan_date +''') THEN (ISNULL(B.GOOD_CELL_QTY,0) + ISNULL(B.UNINSPEC_CELL_QTY,0) + ISNULL(B.GOOD_QTY,0)  + EOL_QTY + RECEIPT_QTY - PLAN_QTY)            ' + char(10)
		SELECT @v_dSql += N'	        				                      ELSE (0                 + EOL_QTY + RECEIPT_QTY - PLAN_QTY) END AS EOH_EOL_UNINSPECTION_QTY	' + char(10)
		--SELECT @v_dSql += N'					       -- EOH_Cell(Total)        : BOH(C)_GOOD               + [버림(전일EOL_PLAN*0.5) + 올림(당일EOL_PLAN*0.5)] - 당일Moving Plan' + char(10)
		SELECT @v_dSql += N'					       , CASE WHEN A.PLAN_DATE = CONVERT(DATE,'''+ @p_plan_date +''') THEN (ISNULL(B.GOOD_CELL_QTY,0) + EOL_QTY - MOVING_QTY)                ' + char(10)
		SELECT @v_dSql += N'	        					                    ELSE (0                         + EOL_QTY - MOVING_QTY) END AS EOH_CELL_TOTAL_QTY            ' + char(10)
		--SELECT @v_dSql += N'					       -- EOH_Cell(Total[+Hold]) : BOH(C)_GOOD + BOH(C)_HOLD + [버림(전일EOL_PLAN*0.5) + 올림(당일EOL_PLAN*0.5)] - 당일Moving Plan' + char(10)
		SELECT @v_dSql += N'					       , CASE WHEN A.PLAN_DATE = CONVERT(DATE,'''+ @p_plan_date +''') THEN (ISNULL(B.GOOD_CELL_QTY,0) + ISNULL(B.HOLD_CELL_QTY,0) + EOL_QTY - MOVING_QTY)            ' + char(10)
		SELECT @v_dSql += N'	        					                    ELSE (0                        + EOL_QTY - MOVING_QTY) END AS EOH_CELL_TOTAL_HOLD_QTY        ' + char(10)
		SELECT @v_dSql += N'	      		FROM (                 ' + char(10)
		SELECT @v_dSql += N'	      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID    ' + char(10)
		SELECT @v_dSql += N'	      				 , E.DT AS PLAN_DATE --A.PLAN_DATE          ' + char(10)
		SELECT @v_dSql += N'	      				 , E.ISO_YYYYWW' + char(10)
		SELECT @v_dSql += N'	      				 , E.WEEK_ENDDATE                           ' + char(10)
		SELECT @v_dSql += N'	      				 , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.MOVING_QTY ELSE 0 END)  AS MOVING_QTY                 ' + char(10)
		SELECT @v_dSql += N'	      				 , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.RECEIPT_QTY ELSE 0 END) AS RECEIPT_QTY                ' + char(10)
		SELECT @v_dSql += N'	      				 , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.PLAN_QTY ELSE 0 END)    AS PLAN_QTY                   ' + char(10)
		SELECT @v_dSql += N'	      				 , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.EOL_QTY ELSE 0 END)     AS EOL_QTY                    ' + char(10)
		SELECT @v_dSql += N'	      			FROM (             ' + char(10)
		SELECT @v_dSql += N'	      					SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.ITEM_ID, CONVERT(VARCHAR,DATEADD(DAY, 1, CONVERT(DATE, A.PLAN_DATE)), 112) AS PLAN_DATE        ' + char(10)
		SELECT @v_dSql += N'								       , SUM(CASE WHEN A.CATEGORY_ID = ''INHOUSE'' THEN A.RECEIPT_QTY ELSE 0 END) AS MOVING_QTY                       ' + char(10)
		SELECT @v_dSql += N'								       , SUM(CASE WHEN A.CATEGORY_ID = ''INHOUSE'' THEN 0 ELSE A.RECEIPT_QTY END) AS RECEIPT_QTY                      ' + char(10)
		SELECT @v_dSql += N'								       , 0 AS PLAN_QTY, 0 AS EOL_QTY' + char(10)
		SELECT @v_dSql += N'	      					FROM   #TEMP_TABLE_01 A        ' + char(10)
		--SELECT @v_dSql += N'	          FROM  (		' + char(10)
		--SELECT @v_dSql += @v_tempSql
		--SELECT @v_dSql += N'					) A		' + char(10)
		SELECT @v_dSql += N'	      					WHERE  RECEIPT_QTY > 0                  ' + char(10)
		SELECT @v_dSql += N'	      					AND    A.PLAN_DATE BETWEEN CONVERT(VARCHAR, DATEADD(DAY, -1, CONVERT(DATE,'''+ @p_bucket_from +''')), 112) AND '''+ @p_bucket_to +'''                        ' + char(10)
		SELECT @v_dSql += N'	      					GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.ITEM_ID, CONVERT(VARCHAR,DATEADD(DAY, 1, CONVERT(DATE, A.PLAN_DATE)), 112)      ' + char(10)
		SELECT @v_dSql += N'	      					--- Plan   ' + char(10)
		SELECT @v_dSql += N'	      					-- Coater - Cell/Pack Plan              ' + char(10)
		SELECT @v_dSql += N'	      					UNION ALL  ' + char(10)
		SELECT @v_dSql += N'	      					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID       ' + char(10)
		SELECT @v_dSql += N'	      						   , A.ATTB_03 AS ITEM_ID      ' + char(10)
		SELECT @v_dSql += N'	      						   , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE          ' + char(10)
		SELECT @v_dSql += N'	      						   , 0 AS MOVING_QTY, 0 AS RECEIPT_QTY                      ' + char(10)
		SELECT @v_dSql += N'	      						   , SUM(ISNULL(A.SIM_IN_QTY,0) * A.ATTB_04) AS PLAN_QTY                  ' + char(10)
		SELECT @v_dSql += N'	      						   , 0 AS EOL_QTY                   ' + char(10)
		SELECT @v_dSql += N'							FROM   '+ @p_table_name +' A WITH(NOLOCK)              																				' + char(10)
		SELECT @v_dSql += N'	              			INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'	              			ON     A.COMPANY_ID   = B.COMPANY_ID        ' + char(10)
		SELECT @v_dSql += N'	              			AND    A.DIVISION_ID  = B.DIVISION_ID       ' + char(10)
		SELECT @v_dSql += N'	              			AND    A.SITE_ID      = B.SITE_ID           ' + char(10)
		SELECT @v_dSql += N'	              			AND    A.ATTB_03	  = B.ITEM_ID           ' + char(10)
		SELECT @v_dSql += N'	      					AND    B.ACTIVE_FLAG  = ''Y''               ' + char(10)
		SELECT @v_dSql += N'	              			INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'	              			ON     A.COMPANY_ID   = C.COMPANY_ID        ' + char(10)
		SELECT @v_dSql += N'	              			AND    A.DIVISION_ID  = C.DIVISION_ID       ' + char(10)
		SELECT @v_dSql += N'	              			AND    A.SITE_ID      = C.SITE_ID           ' + char(10)
		SELECT @v_dSql += N'	              			AND    A.MODEL_ID   = C.ITEM_ID           ' + char(10)
		SELECT @v_dSql += N'	      					AND    C.ACTIVE_FLAG  = ''Y''               ' + char(10)
		SELECT @v_dSql += N'							WHERE 1=1																																' + char(10)
		SELECT @v_dSql += N'							AND A.SIM_PLAN_ID = '''+ @p_sim_plan_id +'''																							' + char(10)
		SELECT @v_dSql += N'	      					AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                        ' + char(10)
		SELECT @v_dSql += N'							AND A.OPERATION_ID IN (''P5000'', ''P5200'')																							' + char(10)
		SELECT @v_dSql += N'	      					AND    A.SIM_IN_QTY > 0                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ATTB_03' , 'LIKE_R', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE_R', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'LIKE_R', @p_model_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE_R', @p_model_nick_name)) + char(10)
		SELECT @v_dSql += N'	      					GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID     ' + char(10)
		SELECT @v_dSql += N'	              				 , A.ATTB_03, CONVERT(VARCHAR,A.PLAN_DATE,112)         ' + char(10)

		SELECT @v_dSql += N'							    -- EOL Plan : 버림(전일EOL_PLAN*0.5)' + char(10)
		SELECT @v_dSql += N'	      					UNION ALL  ' + char(10)
		SELECT @v_dSql += N'	      					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(VV.CELL_PRODUCT, A.ITEM_ID) AS ITEM_ID, CONVERT(VARCHAR, DATEADD(DAY, 1, A.PLAN_DATE) ,112) AS PLAN_DATE     ' + char(10)
		SELECT @v_dSql += N'							         , 0 AS MOVING_QTY, 0 AS RECEIPT_QTY, 0 AS PLAN_QTY     ' + char(10)
		SELECT @v_dSql += N'							         , FLOOR(SUM(PLAN_QTY) * CONVERT(NUMERIC(10,2),'+ @v_eol_d2_rate +') ) AS EOL_QTY                     ' + char(10)
		SELECT @v_dSql += N'	      					FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                      ' + char(10)
		SELECT @v_dSql += N'	      							LEFT OUTER JOIN #CELL_ITEM_V VV	-- 활성화 코드 분리 관련 추가 @@@	' + char(10)
		SELECT @v_dSql += N'	      							ON 1=1									' + char(10)
		SELECT @v_dSql += N'	      							AND	A.COMPANY_ID    =  VV.COMPANY_ID    ' + char(10)          
	    SELECT @v_dSql += N'	      							AND A.DIVISION_ID   =  VV.DIVISION_ID   ' + char(10)          
	    SELECT @v_dSql += N'	      							AND A.SITE_ID       =  VV.SITE_ID		' + char(10)
		SELECT @v_dSql += N'	      							AND A.ITEM_ID       =  VV.CELL_ASSY		' + char(10)
		SELECT @v_dSql += N'									INNER  JOIN (														' + char(10)
		SELECT @v_dSql += N'										SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID		' + char(10)
		SELECT @v_dSql += N'										FROM   FP_INSTANCE_INFO_V										' + char(10)
		SELECT @v_dSql += N'										WHERE 1=1														' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('INSTANCE_ID' , 'EQ', @p_formation_instance_id)) + char(10)
		SELECT @v_dSql += N'									) B																	' + char(10)
		SELECT @v_dSql += N'									ON 1=1																' + char(10)
		SELECT @v_dSql += N'									AND A.COMPANY_ID = B.COMPANY_ID										' + char(10)
		SELECT @v_dSql += N'									AND A.DIVISION_ID = B.DIVISION_ID									' + char(10)
		SELECT @v_dSql += N'									AND A.SITE_ID = B.SITE_ID											' + char(10)
		SELECT @v_dSql += N'									AND A.PLANT_ID = B.PLANT_ID											' + char(10)
		SELECT @v_dSql += N'							WHERE  1=1																	' + char(10)
		SELECT @v_dSql += N'	      					AND   A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND DATEADD(DAY, -1, CONVERT(DATE,'''+ @p_bucket_to +'''))           ' + char(10)
		SELECT @v_dSql += N'							AND    A.PLAN_TYPE =  ''RELEASE''						' + char(10)
		SELECT @v_dSql += N'							AND    A.OPERATION_ID =  ''F6000''						' + char(10)
		SELECT @v_dSql += N'							AND    A.PLAN_QTY > 0						' + char(10)
		SELECT @v_dSql += N'	      					AND   EXISTS (                          ' + char(10)
		SELECT @v_dSql += N'	      						SELECT 1 FROM (                     ' + char(10)
		SELECT @v_dSql += N'										SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID , A.ATTB_03 AS CELL_ITEM_ID	' + char(10) 
		SELECT @v_dSql += N'										FROM   '+ @p_table_name +' A WITH(NOLOCK)              																				' + char(10)
		SELECT @v_dSql += N'	              						INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'	              						ON     A.COMPANY_ID   = B.COMPANY_ID        ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.DIVISION_ID  = B.DIVISION_ID       ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.SITE_ID      = B.SITE_ID           ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.ATTB_03	  = B.ITEM_ID           ' + char(10)
		SELECT @v_dSql += N'	      								AND    B.ACTIVE_FLAG  = ''Y''               ' + char(10)
		SELECT @v_dSql += N'	              						INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'	              						ON     A.COMPANY_ID   = C.COMPANY_ID        ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.DIVISION_ID  = C.DIVISION_ID       ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.SITE_ID      = C.SITE_ID           ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.MODEL_ID   = C.ITEM_ID           ' + char(10)
		SELECT @v_dSql += N'	      								AND    C.ACTIVE_FLAG  = ''Y''               ' + char(10)
		SELECT @v_dSql += N'										WHERE 1=1																																' + char(10)
		SELECT @v_dSql += N'										AND A.SIM_PLAN_ID = '''+ @p_sim_plan_id +'''																							' + char(10)
		SELECT @v_dSql += N'	      								AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                        ' + char(10)
		SELECT @v_dSql += N'										AND A.OPERATION_ID IN (''P5000'', ''P5200'')																							' + char(10)
		SELECT @v_dSql += N'	      								AND    A.SIM_IN_QTY > 0                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ATTB_03' , 'LIKE_R', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE_R', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'LIKE_R', @p_model_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE_R', @p_model_nick_name)) + char(10)
		SELECT @v_dSql += N'	      						) AA   ' + char(10)
		SELECT @v_dSql += N'	      						WHERE A.COMPANY_ID  = AA.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'	      						AND   A.DIVISION_ID = AA.DIVISION_ID' + char(10)
		SELECT @v_dSql += N'	      						AND   A.SITE_ID     = AA.SITE_ID    ' + char(10)
		SELECT @v_dSql += N'	      						AND   A.ITEM_ID     = AA.CELL_ITEM_ID                       ' + char(10)
		SELECT @v_dSql += N'	      					)          ' + char(10)
		SELECT @v_dSql += N'	      					GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(VV.CELL_PRODUCT, A.ITEM_ID) , CONVERT(VARCHAR, DATEADD(DAY, 1, A.PLAN_DATE) ,112)         ' + char(10)
		SELECT @v_dSql += N'							    -- EOL Plan : 올림(당일EOL_PLAN*0.5)' + char(10)
		SELECT @v_dSql += N'	      					UNION ALL  ' + char(10)
		SELECT @v_dSql += N'	      					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(VV.CELL_PRODUCT, A.ITEM_ID) AS ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE       ' + char(10)
		SELECT @v_dSql += N'							         , 0 AS MOVING_QTY, 0 AS RECEIPT_QTY, 0 AS PLAN_QTY     ' + char(10)
		SELECT @v_dSql += N'							         , CEILING(SUM(PLAN_QTY) * CONVERT(NUMERIC(10,2), '+ @v_eol_d1_rate +')) AS EOL_QTY                   ' + char(10)
		SELECT @v_dSql += N'	      					FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                      ' + char(10)
		SELECT @v_dSql += N'	      							LEFT OUTER JOIN #CELL_ITEM_V VV	-- 활성화 코드 분리 관련 추가 @@@	' + char(10)
		SELECT @v_dSql += N'	      							ON 1=1									' + char(10)
		SELECT @v_dSql += N'	      							AND	A.COMPANY_ID    =  VV.COMPANY_ID    ' + char(10)          
	    SELECT @v_dSql += N'	      							AND A.DIVISION_ID   =  VV.DIVISION_ID   ' + char(10)          
	    SELECT @v_dSql += N'	      							AND A.SITE_ID       =  VV.SITE_ID		' + char(10)
		SELECT @v_dSql += N'	      							AND A.ITEM_ID       =  VV.CELL_ASSY		' + char(10)
		SELECT @v_dSql += N'									INNER  JOIN (														' + char(10)
		SELECT @v_dSql += N'										SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID		' + char(10)
		SELECT @v_dSql += N'										FROM   FP_INSTANCE_INFO_V										' + char(10)
		SELECT @v_dSql += N'										WHERE 1=1														' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('INSTANCE_ID' , 'EQ', @p_formation_instance_id)) + char(10)
		SELECT @v_dSql += N'									) B																	' + char(10)
		SELECT @v_dSql += N'									ON 1=1																' + char(10)
		SELECT @v_dSql += N'									AND A.COMPANY_ID = B.COMPANY_ID										' + char(10)
		SELECT @v_dSql += N'									AND A.DIVISION_ID = B.DIVISION_ID									' + char(10)
		SELECT @v_dSql += N'									AND A.SITE_ID = B.SITE_ID											' + char(10)
		SELECT @v_dSql += N'									AND A.PLANT_ID = B.PLANT_ID											' + char(10)
		SELECT @v_dSql += N'							WHERE  1=1																	' + char(10)
		SELECT @v_dSql += N'	      					AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                 ' + char(10)
		SELECT @v_dSql += N'							AND    A.PLAN_TYPE =  ''RELEASE''						' + char(10)
		SELECT @v_dSql += N'							AND    A.OPERATION_ID =  ''F6000''						' + char(10)
		SELECT @v_dSql += N'							AND    A.PLAN_QTY > 0						' + char(10)
		SELECT @v_dSql += N'	      					AND   EXISTS (                          ' + char(10)
		SELECT @v_dSql += N'	      						SELECT 1 FROM (                     ' + char(10)
		SELECT @v_dSql += N'										SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID , A.ATTB_03 AS CELL_ITEM_ID	' + char(10) 
		SELECT @v_dSql += N'										FROM   '+ @p_table_name +' A WITH(NOLOCK)              																				' + char(10)
		SELECT @v_dSql += N'	              						INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'	              						ON     A.COMPANY_ID   = B.COMPANY_ID        ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.DIVISION_ID  = B.DIVISION_ID       ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.SITE_ID      = B.SITE_ID           ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.ATTB_03	  = B.ITEM_ID           ' + char(10)
		SELECT @v_dSql += N'	      								AND    B.ACTIVE_FLAG  = ''Y''               ' + char(10)
		SELECT @v_dSql += N'	              						INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)   ' + char(10)
		SELECT @v_dSql += N'	              						ON     A.COMPANY_ID   = C.COMPANY_ID        ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.DIVISION_ID  = C.DIVISION_ID       ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.SITE_ID      = C.SITE_ID           ' + char(10)
		SELECT @v_dSql += N'	              						AND    A.MODEL_ID   = C.ITEM_ID           ' + char(10)
		SELECT @v_dSql += N'	      								AND    C.ACTIVE_FLAG  = ''Y''               ' + char(10)
		SELECT @v_dSql += N'										WHERE 1=1																																' + char(10)
		SELECT @v_dSql += N'										AND A.SIM_PLAN_ID = '''+ @p_sim_plan_id +'''																							' + char(10)
		SELECT @v_dSql += N'	      								AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                        ' + char(10)
		SELECT @v_dSql += N'										AND A.OPERATION_ID IN (''P5000'', ''P5200'')																							' + char(10)
		SELECT @v_dSql += N'	      								AND    A.SIM_IN_QTY > 0                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ATTB_03' , 'LIKE_R', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE_R', @p_nick_name)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'LIKE_R', @p_model_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE_R', @p_model_nick_name)) + char(10)

		SELECT @v_dSql += N'	      						) AA   ' + char(10)
		SELECT @v_dSql += N'	      						WHERE A.COMPANY_ID  = AA.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'	      						AND   A.DIVISION_ID = AA.DIVISION_ID' + char(10)
		SELECT @v_dSql += N'	      						AND   A.SITE_ID     = AA.SITE_ID    ' + char(10)
		SELECT @v_dSql += N'	      						AND   A.ITEM_ID     = AA.CELL_ITEM_ID                       ' + char(10)
		SELECT @v_dSql += N'	      					)          ' + char(10)
		SELECT @v_dSql += N'	      					GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(VV.CELL_PRODUCT, A.ITEM_ID) , CONVERT(VARCHAR,A.PLAN_DATE,112)                  ' + char(10)
		SELECT @v_dSql += N'	      			) A                ' + char(10)
		SELECT @v_dSql += N'	      			INNER JOIN (       ' + char(10)
		SELECT @v_dSql += N'	        				SELECT A.* , B.YYYYMMDD AS WEEK_ENDDATE ' + char(10)
		SELECT @v_dSql += N'	        				FROM TH_UIS_CAL A WITH(NOLOCK)          ' + char(10)
		SELECT @v_dSql += N'	        				INNER HASH JOIN TH_UIS_CAL B WITH(NOLOCK)                       ' + char(10)
		SELECT @v_dSql += N'	        				ON    A.ISO_YYYYWW = B.ISO_YYYYWW       ' + char(10)
		SELECT @v_dSql += N'	        				WHERE CONVERT(VARCHAR,A.DT,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                        ' + char(10)
		SELECT @v_dSql += N'	        				AND   B.DAY_SEQ = ''1''                 ' + char(10)
		SELECT @v_dSql += N'	      			) E                ' + char(10)
		SELECT @v_dSql += N'	      			ON 1=1             ' + char(10)
		SELECT @v_dSql += N'	      			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID  ' + char(10)
		SELECT @v_dSql += N'	      				   , E.DT, E.ISO_YYYYWW, E.WEEK_ENDDATE     ' + char(10)
		SELECT @v_dSql += N'	      		) A                    ' + char(10)
		SELECT @v_dSql += N'	      		LEFT OUTER HASH JOIN BOH_INFO B                     ' + char(10)
		SELECT @v_dSql += N'	      		ON  A.COMPANY_ID  = B.COMPANY_ID                    ' + char(10)
		SELECT @v_dSql += N'	      		AND A.DIVISION_ID = B.DIVISION_ID                   ' + char(10)
		SELECT @v_dSql += N'	      		AND A.SITE_ID     = B.SITE_ID                       ' + char(10)
		SELECT @v_dSql += N'	      		AND A.PLANT_ID    = B.PLANT_ID                      ' + char(10)
		SELECT @v_dSql += N'	      		AND A.ITEM_ID     = B.ITEM_ID                       ' + char(10)
		SELECT @v_dSql += N'	      	) A                        ' + char(10)
		SELECT @v_dSql += N'	      	INNER JOIN (               ' + char(10)
		SELECT @v_dSql += N'	      			SELECT *           ' + char(10)
		SELECT @v_dSql += N'	      			FROM (             ' + char(10)
		SELECT @v_dSql += N'	      	          		SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER                      ' + char(10)
		SELECT @v_dSql += N'	      	          		UNION ALL  ' + char(10)
		SELECT @v_dSql += N'	      	          		SELECT ''EOH_MOVING'' AS CATEGORY_ID, ''EOH_Pack(Moving)'' AS CATEGORY_NAME, 100 AS CATEGORY_ORDER                        ' + char(10)
		SELECT @v_dSql += N'	      	          		UNION ALL  ' + char(10)
		SELECT @v_dSql += N'	      	          		SELECT ''EOH_MOVING_HOLD'' AS CATEGORY_ID, ''EOH_Pack(Moving[+Hold])'' AS CATEGORY_NAME, 200 AS CATEGORY_ORDER            ' + char(10)
		SELECT @v_dSql += N'	      	          		UNION ALL  ' + char(10)
		SELECT @v_dSql += N'	      	          		SELECT ''EOH_EOL'' AS CATEGORY_ID, ''EOH_Pack(EOL)'' AS CATEGORY_NAME, 300 AS CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'	      	          		UNION ALL  ' + char(10)
		SELECT @v_dSql += N'	      	          		SELECT ''EOH_EOL_UNINSPECTION_QTY'' AS CATEGORY_ID, ''EOH_Pack(EOL[Uninspection])'' AS CATEGORY_NAME, 400 AS CATEGORY_ORDER ' + char(10)
		SELECT @v_dSql += N'	      	          		UNION ALL  ' + char(10)
		SELECT @v_dSql += N'	      	          		SELECT ''EOH_EOL_HOLD'' AS CATEGORY_ID, ''EOH_Pack(EOL[+Hold + Box pkg + Long Term])'' AS CATEGORY_NAME, 500 AS CATEGORY_ORDER                  ' + char(10)
		SELECT @v_dSql += N'	      	          		UNION ALL  ' + char(10)
		SELECT @v_dSql += N'	      	          		SELECT ''EOH_CELL_TOTAL'' AS CATEGORY_ID, ''EOH_Cell(Total)'' AS CATEGORY_NAME, 600 AS CATEGORY_ORDER                     ' + char(10)
		SELECT @v_dSql += N'	      	          		UNION ALL  ' + char(10)
		SELECT @v_dSql += N'	      	          		SELECT ''EOH_CELL_TOTAL_HOLD'' AS CATEGORY_ID, ''EOH_Cell(Total[+Hold])'' AS CATEGORY_NAME, 700 AS CATEGORY_ORDER         ' + char(10)
		SELECT @v_dSql += N'	      			) BB               ' + char(10)
		SELECT @v_dSql += N'	      			WHERE BB.CATEGORY_ID < > ''X''                  ' + char(10)
		SELECT @v_dSql += N'	      	) B                        ' + char(10)
		SELECT @v_dSql += N'	      	ON 1=1                     ' + char(10)
		SELECT @v_dSql += N'	      	INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)               ' + char(10)
		SELECT @v_dSql += N'	      	ON  A.PLAN_DATE = C.YYYYMMDD                            ' + char(10)
		SELECT @v_dSql += N'	      	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID		               ' + char(10)
		SELECT @v_dSql += N'	      			, A.BOH_QTY, A.BOH_PACK_QTY, A.BOH_PACK_GOOD_QTY, A.BOH_PACK_HOLD_QTY, A.BOH_INTRANSIT_HOLD_QTY             ' + char(10)
		SELECT @v_dSql += N'	      			, A.BOH_CELL_GOOD_QTY, A.BOH_CELL_HOLD_QTY , A.BOH_CELL_UNINSPEC_QTY, A.BOH_CELL_BOX_PACKING_QTY, A.BOH_CELL_LONG_TERM_QTY            ' + char(10)
		SELECT @v_dSql += N'	      			, B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER                       ' + char(10)
		SELECT @v_dSql += N'	      )                            ' + char(10)
		SELECT @v_dSql += N'	 SELECT	A.*		 ' + char(10)
		SELECT @v_dSql += N'	 FROM		(	 ' + char(10)
		SELECT @v_dSql += N'	      SELECT A.*, B.NICK_NAME, C.NICK_NAME AS MODEL_NICK_NAME , ISNULL(J.PACK_PRODUCT_GROUP_CODE, K.CELL_GROUP ) AS CELL_GROUP  ' + char(10)
		SELECT @v_dSql += N'	      FROM (                       ' + char(10)
		SELECT @v_dSql += N'	        	SELECT * FROM MAIN_P   ' + char(10)
		SELECT @v_dSql += N'	        	-- Pack Sum            ' + char(10)
		SELECT @v_dSql += N'	        	UNION ALL              ' + char(10)
		SELECT @v_dSql += N'	        	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, NULL AS TOP_ITEM_ID  ' + char(10)
		SELECT @v_dSql += N'	        			, A.BOH_QTY, A.BOH_CELL_GOOD_QTY, A.BOH_CELL_HOLD_QTY , A.BOH_CELL_UNINSPEC_QTY, A.BOH_CELL_BOX_PACKING_QTY, A.BOH_CELL_LONG_TERM_QTY ' + char(10)
		SELECT @v_dSql += N'	        			, A.BOH_PACK_QTY, A.BOH_PACK_GOOD_QTY, A.BOH_PACK_HOLD_QTY, A.BOH_INTRANSIT_HOLD_QTY	' + char(10)
		SELECT @v_dSql += N'	          			, ''PLAN_TOT'' AS CATEGORY_ID, ''Pack Plan Sum'' AS CATEGORY_NAME, 7 AS CATEGORY_ORDER, NULL AS FROM_CATEGORY, A.DATA_TYPE         ' + char(10)
		
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
		
		SELECT @v_dSql += N'	        	FROM   MAIN_P A        ' + char(10)
		SELECT @v_dSql += N'	        	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'	        			, A.BOH_QTY, A.BOH_CELL_GOOD_QTY, A.BOH_CELL_HOLD_QTY , A.BOH_CELL_UNINSPEC_QTY, A.BOH_CELL_BOX_PACKING_QTY, A.BOH_CELL_LONG_TERM_QTY ' + char(10)
		SELECT @v_dSql += N'	        			, A.BOH_PACK_QTY, A.BOH_PACK_GOOD_QTY, A.BOH_PACK_HOLD_QTY, A.BOH_INTRANSIT_HOLD_QTY, A.DATA_TYPE	' + char(10)
		SELECT @v_dSql += N'		        UNION ALL              ' + char(10)
		SELECT @v_dSql += N'		        SELECT * FROM RESULT_INFO                           ' + char(10)
		SELECT @v_dSql += N'	        	UNION ALL              ' + char(10)
		SELECT @v_dSql += N'	        	SELECT * FROM MAIN_R   ' + char(10)
		SELECT @v_dSql += N'	        	UNION ALL              ' + char(10)
		SELECT @v_dSql += N'	        	SELECT * FROM MAIN_I   ' + char(10)
		SELECT @v_dSql += N'	      ) A                          ' + char(10)
		SELECT @v_dSql += N'	      LEFT OUTER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)            ' + char(10)
		SELECT @v_dSql += N'	      ON  A.COMPANY_ID  = B.COMPANY_ID                          ' + char(10)
		SELECT @v_dSql += N'	      AND A.DIVISION_ID = B.DIVISION_ID                         ' + char(10)
		SELECT @v_dSql += N'	      AND A.SITE_ID     = B.SITE_ID' + char(10)
		SELECT @v_dSql += N'	      AND A.ITEM_ID     = B.ITEM_ID' + char(10)
		SELECT @v_dSql += N'	      AND    B.ACTIVE_FLAG  = ''Y''               ' + char(10)
		SELECT @v_dSql += N'	      LEFT OUTER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)            ' + char(10)
		SELECT @v_dSql += N'	      ON  A.COMPANY_ID  = C.COMPANY_ID                          ' + char(10)
		SELECT @v_dSql += N'	      AND A.DIVISION_ID = C.DIVISION_ID                         ' + char(10)
		SELECT @v_dSql += N'	      AND A.SITE_ID     = C.SITE_ID' + char(10)
		SELECT @v_dSql += N'	      AND A.TOP_ITEM_ID = C.ITEM_ID' + char(10)
		SELECT @v_dSql += N'	      AND    C.ACTIVE_FLAG  = ''Y''               ' + char(10)
		SELECT @v_dSql += N'		  LEFT OUTER HASH  JOIN (           ' + char(10) 
		SELECT @v_dSql += N'								SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PACK_PRODUCT_GROUP_CODE , B.ITEM_ID		' + char(10)
		SELECT @v_dSql += N'								FROM SCM_ITEM_M A WITH(NOLOCK), FP_CELL_GROUP_V B													' + char(10)
		SELECT @v_dSql += N'								WHERE 1=1																							' + char(10)
		SELECT @v_dSql += N'								AND A.ACTIVE_FLAG = ''Y''																			' + char(10)
		SELECT @v_dSql += N'								AND A.COMPANY_ID = B.COMPANY_ID																		' + char(10)
		SELECT @v_dSql += N'								AND A.DIVISION_ID = B.DIVISION_ID																	' + char(10)
		SELECT @v_dSql += N'								AND A.SITE_ID = B.SITE_ID																			' + char(10)
		SELECT @v_dSql += N'								AND A.NICK_NAME = B.CELL_GROUP																		' + char(10)
		SELECT @v_dSql += N'								AND A.PACK_PRODUCT_GROUP_CODE IS NOT NULL															' + char(10)
		SELECT @v_dSql += N'								GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PACK_PRODUCT_GROUP_CODE, B.ITEM_ID		' + char(10)
		SELECT @v_dSql += N'			) J          ' + char(10) 
		SELECT @v_dSql += N'		  ON  A.COMPANY_ID   = J.COMPANY_ID                              ' + char(10)        
		SELECT @v_dSql += N'		  AND A.DIVISION_ID  = J.DIVISION_ID                             ' + char(10)        
		SELECT @v_dSql += N'		  AND A.SITE_ID      = J.SITE_ID                                 ' + char(10)        
		SELECT @v_dSql += N'		  AND A.ITEM_ID		 = J.ITEM_ID                                 ' + char(10)  
		SELECT @v_dSql += N'	      LEFT OUTER HASH JOIN FP_CELL_GROUP_V K WITH(NOLOCK)            ' + char(10)
		SELECT @v_dSql += N'	      ON  A.COMPANY_ID  = K.COMPANY_ID                          ' + char(10)
		SELECT @v_dSql += N'	      AND A.DIVISION_ID = K.DIVISION_ID                         ' + char(10)
		SELECT @v_dSql += N'	      AND A.SITE_ID     = K.SITE_ID' + char(10)
		SELECT @v_dSql += N'	      AND A.ITEM_ID		= K.ITEM_ID' + char(10)
		SELECT @v_dSql += N'	) A		' + char(10)
		SELECT @v_dSql += N'	WHERE 1=1		' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_GROUP' , 'LIKE_R', @p_cell_group)) + char(10)
		SELECT @v_dSql += N'	      ORDER BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, CATEGORY_ORDER, TOP_ITEM_ID                      ' + char(10)
		SELECT @v_dSql += N'	 ;                      ' + char(10)

		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP_TABLE_01'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #TEMP_TABLE_01 ' + char(10)
		SELECT @v_dSql += N' ; ' + char(10)

		SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#CELL_ITEM_V'') IS NOT NULL ' + char(10)
		SELECT @v_dSql += N'DROP TABLE #CELL_ITEM_V ' + char(10)
		SELECT @v_dSql += N' ; ' + char(10)
		
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
		IF OBJECT_ID(
		'tempdb..#TEMP_TABLE_01'
		) IS NOT NULL
		      
		DROP TABLE 
		#TEMP_TABLE_01
	END
  
END

