

/*
 * Program ID   : PR_UI_FP00637_MATERIAL_CELL_SIMULATION_PACK
 * Description  : Material Cell Simulation(Pack)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/09/07   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00637_MATERIAL_CELL_SIMULATION_PACK]
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

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00637_MATERIAL_CELL_SIMULATION_PACK';
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
	DECLARE @p_sim_plan_id	NVARCHAR(MAX);
	DECLARE @p_bucket_from	NVARCHAR(MAX);
	DECLARE @p_bucket_to	NVARCHAR(MAX);

	DECLARE @p_division_id	NVARCHAR(MAX);
	DECLARE @p_site_id		NVARCHAR(MAX);
	DECLARE @p_plant_id		NVARCHAR(MAX);
	DECLARE @p_factory_id	NVARCHAR(MAX);
	DECLARE @p_operation_id NVARCHAR(MAX);
	DECLARE @p_line_id		NVARCHAR(MAX);
	
	DECLARE @p_pjt_group_name	NVARCHAR(MAX);
	DECLARE @p_top_item_id	NVARCHAR(MAX);
	DECLARE @p_model_id		NVARCHAR(MAX);
	DECLARE @p_model_name	NVARCHAR(MAX);
	DECLARE @p_item_id		NVARCHAR(MAX);
	DECLARE @p_nick_name	NVARCHAR(MAX);
	DECLARE @p_history_yn	NVARCHAR(MAX);
	DECLARE @p_table_name	NVARCHAR(MAX);

	DECLARE @p_cate_info	NVARCHAR(MAX);
	
	-- week
	DECLARE @p_bucket		NVARCHAR(MAX);
	DECLARE @p_week_info	NVARCHAR(MAX);
	DECLARE @p_month_info	NVARCHAR(MAX);
	
	-- table
	
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
			SET @p_sim_plan_id =		@tmp_value
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
		END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
			SET @p_model_id =		@tmp_value
		END ELSE IF @tmp_column = 'MODEL_NAME' BEGIN
			SET @p_model_name =		@tmp_value
		END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
			SET @p_item_id =			@tmp_value
		END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
			SET @p_nick_name =			@tmp_value
		END ELSE IF @tmp_column = 'PJT_GROUP_NAME' BEGIN
			SET @p_pjt_group_name =		@tmp_value

		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =				@tmp_value
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			@tmp_value
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			@tmp_value
		
		END ELSE IF @tmp_column = 'CATE_INFO' BEGIN
			SET @p_cate_info =			@tmp_value

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
		
		SELECT	@p_history_yn = ISNULL(HISTORY_YN, 'N')
		FROM	FP_SIM_PLAN_H
		WHERE	1=1
		AND		PROGRAM_TYPE = 'PACK_SIMUL'
		AND		INSTANCE_ID = @p_instance_id
		AND		SIM_PLAN_ID = @p_sim_plan_id
		;

		IF @p_history_yn = 'Y' BEGIN
			SET @p_table_name = 'FP_SIM_MATERIAL_PACK_H'
		END ELSE BEGIN
			SET @p_table_name = 'FP_SIM_MATERIAL_PACK_R'
		END


		SET	@v_dSql = ''

		SELECT @v_dSql += N'	SELECT	A.*																																																		' + char(10)																																																						
		SELECT @v_dSql += N'			, CASE  WHEN A.OPERATION_ID NOT IN (''P5000'', ''P5200'') AND R.FACTORY_ID IS NOT NULL THEN ''Y'' ELSE ''N'' END AS EDIT_YN											' + char(10)	
		
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

					SELECT @v_dSql += N'				, CASE WHEN D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_AVAIL_QTY < D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_PLAN_QTY THEN ''#FFE6E6'' ELSE NULL END AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_AVAIL_COLOR        ' + char(10)          
					SELECT @v_dSql += N'				, CASE WHEN A.OPERATION_ID IN (''P5000'', ''P5200'') AND D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_CELL_QTY < D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_PLAN_QTY THEN ''#F0F8FF'' ELSE NULL END AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_CELL_COLOR        ' + char(10)          
					SELECT @v_dSql += N'				, CASE WHEN D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_MAT_QTY < D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_PLAN_QTY THEN ''#F0F8FF'' ELSE NULL END AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_MAT_COLOR        ' + char(10)          

				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''


		SELECT @v_dSql += N'	FROM	(                                                                                                                                                                                                       ' + char(10)        
		SELECT @v_dSql += N'				SELECT	A.*                                                                                                                                                                                         ' + char(10)        
		SELECT @v_dSql += N'						, E.OPERATION_NAME                                                                                                                                                                          ' + char(10)        
		SELECT @v_dSql += N'						, H.LINE_NAME                                                                                                                                                                               ' + char(10)        
		SELECT @v_dSql += N'						, ISNULL(J.CELL_GROUP, ISNULL(F.PACK_PRODUCT_GROUP_CODE, ''-'')) AS CELL_GROUP                                                                                                              ' + char(10)          
		SELECT @v_dSql += N'						, F.NICK_NAME AS MODEL_NICK_NAME                                                                                                                                                            ' + char(10)        
		SELECT @v_dSql += N'						, G.NICK_NAME AS NICK_NAME                                                                                                                                                                  ' + char(10)        
		SELECT @v_dSql += N'						,''DATA'' AS DATA_TYPE                                                                                                                                                                      ' + char(10)          
		SELECT @v_dSql += N'						, DENSE_RANK() OVER(ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, PRODUCTION_TYPE, A.MODEL_ID, A.ITEM_ID) AS LV1                                     ' + char(10)        
		SELECT @v_dSql += N'				FROM	(                                                                                                                                                                                           ' + char(10)        
		
		/*
		SELECT @v_dSql += N'							SELECT	INSTANCE_ID, SIM_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, MODEL_ID, ITEM_ID, CELL_CODE                        ' + char(10)        

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

					SELECT @v_dSql += N'				, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @sub_param_0 + ''' THEN A.SIM_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_PLAN_QTY        ' + char(10)          
					SELECT @v_dSql += N'				, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @sub_param_0 + ''' THEN A.CELL_SIM_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_CELL_QTY        ' + char(10)          
					SELECT @v_dSql += N'				, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @sub_param_0 + ''' THEN A.MATERIAL_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_MAT_QTY          ' + char(10)          
					SELECT @v_dSql += N'				, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @sub_param_0 + ''' THEN A.AVAILBLE_QTY2 ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_AVAIL_QTY      ' + char(10)          

				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql += N'							FROM    (                                                                                                                                                                               ' + char(10)        
		--SELECT @v_dSql += N'										SELECT INSTANCE_ID, SIM_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, MODEL_ID, ITEM_ID, PLAN_DATE  ' + char(10)        
		--SELECT @v_dSql += N'												, [PLAN] AS PLAN_QTY, [CELL] AS CELL_QTY, [MAT] AS MAT_QTY, [AVAIL] AS AVAIL_QTY                                                                                    ' + char(10)        
		--SELECT @v_dSql += N'										FROM (                                                                                                                                                                      ' + char(10)        
		SELECT @v_dSql += N'												SELECT	A.INSTANCE_ID, A.SIM_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.PRODUCTION_TYPE       ' + char(10)                                  
		SELECT @v_dSql += N'															, A.MODEL_ID, A.ITEM_ID, A.CATEGORY_ID, A.PLAN_DATE , C.CHILD_ITEM_ID AS CELL_CODE       ' + char(10)                                  
		SELECT @v_dSql += N'															, B.SIM_QTY, B.PLAN_IN_QTY, B.PLAN_QTY, ROUND(A.CELL_SIM_QTY / A.BOM_RATE, 1) AS CELL_SIM_QTY , ROUND(A.MATERIAL_QTY / A.BOM_RATE, 1) AS MATERIAL_QTY , MIN_AVAILBLE_QTY AS AVAILBLE_QTY2      ' + char(10)              
		--SELECT @v_dSql += N'														, CASE WHEN A.OPERATION_ID = ''P5000'' AND A.CELL_SIM_QTY <= A.MATERIAL_QTY THEN A.CELL_SIM_QTY ELSE A.MATERIAL_QTY END AS  AVAILBLE_QTY2        ' + char(10)        
		SELECT @v_dSql += N'												FROM FP_SIM_MATERIAL_PACK_R A WITH(NOLOCK)                                                                                                                          ' + char(10)        
		SELECT @v_dSql += N'														LEFT OUTER JOIN (																												' + char(10)	
		SELECT @v_dSql += N'																			SELECT DISTINCT CT.COMPANY_ID, CT.DIVISION_ID, CT.SITE_ID, CT.PLANT_ID, CT.MODEL_ID, CT.CHILD_ITEM_ID		' + char(10)
		SELECT @v_dSql += N'																			FROM   SCM_MODEL_COMP_TEMP CT WITH(NOLOCK)																	' + char(10)
		SELECT @v_dSql += N'																				 , SCM_ITEM_M  SI WITH(NOLOCK)																			' + char(10)
		SELECT @v_dSql += N'																				 , SCM_ITEM_CLASS_M IC WITH(NOLOCK)																		' + char(10)
		SELECT @v_dSql += N'																			WHERE  CT.CHILD_COMPANY_ID  = SI.COMPANY_ID																	' + char(10)
		SELECT @v_dSql += N'																			AND    CT.CHILD_DIVISION_ID = SI.DIVISION_ID																' + char(10)
		SELECT @v_dSql += N'																			AND    CT.CHILD_SITE_ID     = SI.SITE_ID																	' + char(10)
		SELECT @v_dSql += N'																			AND    CT.CHILD_ITEM_ID     = SI.ITEM_ID																	' + char(10)
		SELECT @v_dSql += N'																			AND    SI.ITEM_CLASS        = IC.CLASS_ID																	' + char(10)
		SELECT @v_dSql += N'																			AND    SI.ACTIVE_FLAG       = ''Y''																			' + char(10)
		SELECT @v_dSql += N'																			AND    IC.USE_FLAG          = ''Y''																			' + char(10)
		SELECT @v_dSql += N'																			AND    ISNULL(SI.ITEM_TYPE,''H'') IN (''P'',''Q'',''H'')															' + char(10)
		SELECT @v_dSql += N'																			AND    CT.ALT_PRIORITY = ''Y''																				' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CT.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CT.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CT.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += N'																			AND	   SI.FLOW_ID LIKE ''%A9000%''																				' + char(10)
		SELECT @v_dSql += N'														) C																																' + char(10)
		SELECT @v_dSql += N'														ON 1=1																															' + char(10)
		SELECT @v_dSql += N'														AND A.COMPANY_ID = C.COMPANY_ID																									' + char(10)
		SELECT @v_dSql += N'														AND A.DIVISION_ID = C.DIVISION_ID																								' + char(10)
		SELECT @v_dSql += N'														AND A.SITE_ID = C.SITE_ID																										' + char(10)
		SELECT @v_dSql += N'														AND A.PLANT_ID = C.PLANT_ID																										' + char(10)
		SELECT @v_dSql += N'														AND A.MODEL_ID = C.MODEL_ID																										' + char(10)
		SELECT @v_dSql += N'												,(																																		' + char(10)	
		SELECT @v_dSql += N'													SELECT	A.*       ' + char(10)                                  
		SELECT @v_dSql += N'															, RANK() OVER (PARTITION BY INSTANCE_ID, SIM_PLAN_ID, FACTORY_ID, LINE_ID, MODEL_ID ORDER BY OPERATION_ID DESC) AS RAK		' + char(10)
		SELECT @v_dSql += N'															, MIN(CASE WHEN A.OPERATION_ID IN (''P5000'', ''P5200'') AND A.CELL_SIM_QTY <= A.MATERIAL_QTY THEN A.CELL_SIM_QTY ELSE A.MATERIAL_QTY END)		' + char(10)
		SELECT @v_dSql += N'																OVER (PARTITION BY INSTANCE_ID, SIM_PLAN_ID, FACTORY_ID, LINE_ID, MODEL_ID, PLAN_DATE) AS MIN_AVAILBLE_QTY		' + char(10)
		SELECT @v_dSql += N'													FROM FP_SIM_MATERIAL_PACK_R A WITH(NOLOCK)                                                                                          ' + char(10)                                
		SELECT @v_dSql += N'													WHERE 1=1                                                                                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SIM_PLAN_ID' , 'EQ', @p_plan_id)) + char(10)
		SELECT @v_dSql += N'													AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'LIKE_R', @p_model_id)) + char(10)
		SELECT @v_dSql += N'												) B																																		' + char(10)
		SELECT @v_dSql += N'												WHERE 1=1                                                                                                                                                           ' + char(10)        
		SELECT @v_dSql += N'												AND A.INSTANCE_ID = B.INSTANCE_ID				' + char(10)
		SELECT @v_dSql += N'												AND A.SIM_PLAN_ID = B.SIM_PLAN_ID				' + char(10)
		SELECT @v_dSql += N'												AND A.COMPANY_ID = B.COMPANY_ID					' + char(10)
		SELECT @v_dSql += N'												AND A.DIVISION_ID = B.DIVISION_ID				' + char(10)
		SELECT @v_dSql += N'												AND A.SITE_ID = B.SITE_ID						' + char(10)
		SELECT @v_dSql += N'												AND A.PLANT_ID = B.PLANT_ID						' + char(10)
		SELECT @v_dSql += N'												AND A.FACTORY_ID = B.FACTORY_ID					' + char(10)
		SELECT @v_dSql += N'												AND A.LINE_ID = B.LINE_ID						' + char(10)
		SELECT @v_dSql += N'												AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE		' + char(10)
		SELECT @v_dSql += N'												AND A.MODEL_ID = B.MODEL_ID						' + char(10)
		SELECT @v_dSql += N'												AND A.PLAN_DATE = B.PLAN_DATE					' + char(10)
		SELECT @v_dSql += N'												AND B.RAK = 1									' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SIM_PLAN_ID' , 'EQ', @p_plan_id)) + char(10)
		SELECT @v_dSql += N'												AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'LIKE_R', @p_model_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE_R', @p_item_id)) + char(10)
		--SELECT @v_dSql += N'										) A                                                                                                                                                                         ' + char(10)        
		--SELECT @v_dSql += N'										PIVOT( SUM(SIM_QTY)  FOR CATEGORY_ID IN ( [PLAN], [CELL], [MAT], [AVAIL] )  ) AS PVT                                                                                        ' + char(10)        
		SELECT @v_dSql += N'									) A                                                                                                                                                                             ' + char(10)        
		SELECT @v_dSql += N'							WHERE 1=1                                                                                                                                                                               ' + char(10)        
		SELECT @v_dSql += N'							GROUP BY INSTANCE_ID, SIM_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, MODEL_ID, ITEM_ID, CELL_CODE                      ' + char(10)       

		*/

		SELECT @v_dSql += N'							SELECT	INSTANCE_ID, SIM_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, MODEL_ID, ITEM_ID, CELL_CODE                        ' + char(10)        

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

					SELECT @v_dSql += N'				, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @sub_param_0 + ''' THEN A.SIM_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_PLAN_QTY        ' + char(10)          
					SELECT @v_dSql += N'				, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @sub_param_0 + ''' THEN A.CELL_SIM_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_CELL_QTY        ' + char(10)          
					SELECT @v_dSql += N'				, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @sub_param_0 + ''' THEN A.MATERIAL_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_MAT_QTY          ' + char(10)          
					SELECT @v_dSql += N'				, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @sub_param_0 + ''' THEN A.AVAILABLE_QTY2 ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_AVAIL_QTY      ' + char(10)          

				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql += N'							FROM    (                                                                                                                                                                               ' + char(10)        
		--SELECT @v_dSql += N'										SELECT INSTANCE_ID, SIM_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, MODEL_ID, ITEM_ID, PLAN_DATE  ' + char(10)        
		--SELECT @v_dSql += N'												, [PLAN] AS PLAN_QTY, [CELL] AS CELL_QTY, [MAT] AS MAT_QTY, [AVAIL] AS AVAIL_QTY                                                                                    ' + char(10)        
		--SELECT @v_dSql += N'										FROM (                                                                                                                                                                      ' + char(10)        
		SELECT @v_dSql += N'												SELECT	A.INSTANCE_ID, A.SIM_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.PRODUCTION_TYPE       ' + char(10)                                  
		SELECT @v_dSql += N'															, A.MODEL_ID, A.ITEM_ID, A.CATEGORY_ID, A.PLAN_DATE  , NULL AS CELL_CODE --, A.ATTB_03 AS CELL_CODE      --, C.CHILD_ITEM_ID AS CELL_CODE       ' + char(10)                                                         
		SELECT @v_dSql += N'															, A.UI_SIM_QTY AS SIM_QTY, A.UI_SIM_QTY AS PLAN_QTY, A.UI_CELL_SIM_QTY AS CELL_SIM_QTY , A.UI_MATERIAL_QTY AS MATERIAL_QTY, A.UI_AVAILABLE_QTY AS AVAILABLE_QTY2      ' + char(10)              
		--SELECT @v_dSql += N'														, CASE WHEN A.OPERATION_ID = ''P5000'' AND A.CELL_SIM_QTY <= A.MATERIAL_QTY THEN A.CELL_SIM_QTY ELSE A.MATERIAL_QTY END AS  AVAILBLE_QTY2        ' + char(10)        
		SELECT @v_dSql += N'												FROM '+ @p_table_name +' A WITH(NOLOCK)                                                                                                                          ' + char(10)    
		--SELECT @v_dSql += N'														LEFT OUTER JOIN (																												' + char(10)	
		--SELECT @v_dSql += N'																			SELECT DISTINCT CT.COMPANY_ID, CT.DIVISION_ID, CT.SITE_ID, CT.PLANT_ID, CT.MODEL_ID, CT.CHILD_ITEM_ID		' + char(10)
		--SELECT @v_dSql += N'																			FROM   SCM_MODEL_COMP_TEMP CT WITH(NOLOCK)																	' + char(10)
		--SELECT @v_dSql += N'																				 , SCM_ITEM_M  SI WITH(NOLOCK)																			' + char(10)
		--SELECT @v_dSql += N'																				 , SCM_ITEM_CLASS_M IC WITH(NOLOCK)																		' + char(10)
		--SELECT @v_dSql += N'																			WHERE  CT.CHILD_COMPANY_ID  = SI.COMPANY_ID																	' + char(10)
		--SELECT @v_dSql += N'																			AND    CT.CHILD_DIVISION_ID = SI.DIVISION_ID																' + char(10)
		--SELECT @v_dSql += N'																			AND    CT.CHILD_SITE_ID     = SI.SITE_ID																	' + char(10)
		--SELECT @v_dSql += N'																			AND    CT.CHILD_ITEM_ID     = SI.ITEM_ID																	' + char(10)
		--SELECT @v_dSql += N'																			AND    SI.ITEM_CLASS        = IC.CLASS_ID																	' + char(10)
		--SELECT @v_dSql += N'																			AND    SI.ACTIVE_FLAG       = ''Y''																			' + char(10)
		--SELECT @v_dSql += N'																			AND    IC.USE_FLAG          = ''Y''																			' + char(10)
		--SELECT @v_dSql += N'																			AND    ISNULL(SI.ITEM_TYPE,''H'') IN (''P'',''Q'',''H'')															' + char(10)
		--SELECT @v_dSql += N'																			AND    CT.ALT_PRIORITY = ''Y''																				' + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CT.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CT.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CT.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		--SELECT @v_dSql += N'																			AND	   SI.FLOW_ID LIKE ''%A9000%''																				' + char(10)
		--SELECT @v_dSql += N'														) C																																' + char(10)
		--SELECT @v_dSql += N'														ON 1=1																															' + char(10)
		--SELECT @v_dSql += N'														AND A.COMPANY_ID = C.COMPANY_ID																									' + char(10)
		--SELECT @v_dSql += N'														AND A.DIVISION_ID = C.DIVISION_ID																								' + char(10)
		--SELECT @v_dSql += N'														AND A.SITE_ID = C.SITE_ID																										' + char(10)
		--SELECT @v_dSql += N'														AND A.PLANT_ID = C.PLANT_ID																										' + char(10)
		--SELECT @v_dSql += N'														AND A.MODEL_ID = C.MODEL_ID																										' + char(10)
		SELECT @v_dSql += N'												WHERE	1 = 1                                                                                                                   ' + char(10)        

		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SIM_PLAN_ID' , 'EQ', @p_plan_id)) + char(10)
		SELECT @v_dSql += N'												AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ID' , 'LIKE_R', @p_model_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE_R', @p_item_id)) + char(10)

		SELECT @v_dSql += N'									) A                                                                                                                                                                             ' + char(10)        
		SELECT @v_dSql += N'							WHERE 1=1                                                                                                                                                                               ' + char(10)        
		SELECT @v_dSql += N'							GROUP BY INSTANCE_ID, SIM_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, MODEL_ID, ITEM_ID , CELL_CODE                     ' + char(10)       

		SELECT @v_dSql += N'						) A                                                                                                                                                                                         ' + char(10)        
		SELECT @v_dSql += N'						LEFT OUTER HASH JOIN SCM_OPERATION_M E WITH(NOLOCK)                                                                                                                                         ' + char(10)        
		SELECT @v_dSql += N'						ON  A.COMPANY_ID   = E.COMPANY_ID                                                                                                                                                           ' + char(10)        
		SELECT @v_dSql += N'						AND A.DIVISION_ID  = E.DIVISION_ID                                                                                                                                                          ' + char(10)        
		SELECT @v_dSql += N'						AND A.SITE_ID      = E.SITE_ID                                                                                                                                                              ' + char(10)        
		SELECT @v_dSql += N'						AND A.OPERATION_ID = E.OPERATION_ID                                                                                                                                                         ' + char(10)        
		SELECT @v_dSql += N'						LEFT OUTER  HASH JOIN SCM_LINE_M H WITH(NOLOCK)                                                                                                                                             ' + char(10)        
		SELECT @v_dSql += N'						ON  A.COMPANY_ID   = H.COMPANY_ID                                                                                                                                                           ' + char(10)        
		SELECT @v_dSql += N'						AND A.DIVISION_ID  = H.DIVISION_ID                                                                                                                                                          ' + char(10)        
		SELECT @v_dSql += N'						AND A.SITE_ID      = H.SITE_ID                                                                                                                                                              ' + char(10)        
		SELECT @v_dSql += N'						AND A.PLANT_ID	   = H.PLANT_ID                                                                                                                                                             ' + char(10)        
		SELECT @v_dSql += N'						AND A.FACTORY_ID   = H.FACTORY_ID                                                                                                                                                           ' + char(10)        
		SELECT @v_dSql += N'						AND A.OPERATION_ID = H.OPERATION_ID                                                                                                                                                         ' + char(10)        
		SELECT @v_dSql += N'						AND A.LINE_ID      = H.LINE_ID                                                                                                                                                              ' + char(10)        
		SELECT @v_dSql += N'						AND H.ACTIVE_FLAG  = ''Y''                                                                                                                                                                  ' + char(10)          
		SELECT @v_dSql += N'						LEFT OUTER HASH  JOIN SCM_ITEM_M F WITH(NOLOCK)                                                                                                                                             ' + char(10)        
		SELECT @v_dSql += N'						ON  A.COMPANY_ID   = F.COMPANY_ID                                                                                                                                                           ' + char(10)        
		SELECT @v_dSql += N'						AND A.DIVISION_ID  = F.DIVISION_ID                                                                                                                                                          ' + char(10)        
		SELECT @v_dSql += N'						AND A.SITE_ID      = F.SITE_ID                                                                                                                                                              ' + char(10)        
		SELECT @v_dSql += N'						AND A.MODEL_ID     = F.ITEM_ID                                                                                                                                                              ' + char(10)        
		SELECT @v_dSql += N'						AND F.ACTIVE_FLAG  = ''Y''                                                                                                                                                                  ' + char(10)          
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('F.NICK_NAME' , 'LIKE_R', @p_model_name)) + char(10)
		SELECT @v_dSql += N'						LEFT OUTER HASH  JOIN SCM_ITEM_M G WITH(NOLOCK)                                                                                                                                             ' + char(10)        
		SELECT @v_dSql += N'						ON  A.COMPANY_ID   = G.COMPANY_ID                                                                                                                                                           ' + char(10)        
		SELECT @v_dSql += N'						AND A.DIVISION_ID  = G.DIVISION_ID                                                                                                                                                          ' + char(10)        
		SELECT @v_dSql += N'						AND A.SITE_ID      = G.SITE_ID                                                                                                                                                              ' + char(10)        
		SELECT @v_dSql += N'						AND A.ITEM_ID      = G.ITEM_ID                                                                                                                                                              ' + char(10)        
		SELECT @v_dSql += N'						AND G.ACTIVE_FLAG  = ''Y''                                                                                                                                                                  ' + char(10)          
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('G.NICK_NAME' , 'LIKE_R', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'						LEFT OUTER HASH  JOIN FP_CELL_GROUP_V J WITH(NOLOCK)                                                                                                                                        ' + char(10)        
		SELECT @v_dSql += N'						ON  A.COMPANY_ID   = J.COMPANY_ID                                                                                                                                                           ' + char(10)        
		SELECT @v_dSql += N'						AND A.DIVISION_ID  = J.DIVISION_ID                                                                                                                                                          ' + char(10)        
		SELECT @v_dSql += N'						AND A.SITE_ID      = J.SITE_ID                                                                                                                                                              ' + char(10)        
		SELECT @v_dSql += N'						AND A.MODEL_ID     = J.ITEM_ID                                                                                                                                                              ' + char(10)        
		SELECT @v_dSql += N'				WHERE 1=1                                                                                                                                                                                           ' + char(10)        
		SELECT @v_dSql += N'			) A                                                                                                                                                                                                     ' + char(10)        
		SELECT @v_dSql += N'			LEFT OUTER JOIN (																																														' + char(10)
		SELECT @v_dSql += N'									SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID																	' + char(10)
		SELECT @v_dSql += N'									FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)																																		' + char(10)
		SELECT @v_dSql += N'									WHERE	1=1																																										' + char(10)
		SELECT @v_dSql += N'									AND		R.USER_ID	= '''+ @p_user_id +'''																																					' + char(10)
		SELECT @v_dSql += N'									AND		R.SAVE_FLAG	= ''Y''																																						' + char(10)
		SELECT @v_dSql += N'									AND     R.INSTANCE_ID  = '''+ @p_instance_id +'''																																				' + char(10)
		SELECT @v_dSql += N'			) R																																																		' + char(10)
		SELECT @v_dSql += N'			ON		1=1																																																' + char(10)
		SELECT @v_dSql += N'			AND		A.COMPANY_ID		= R.COMPANY_ID																																								' + char(10)
		SELECT @v_dSql += N'			AND		A.DIVISION_ID		= R.DIVISION_ID																																								' + char(10)
		SELECT @v_dSql += N'			AND		A.SITE_ID			= R.SITE_ID																																									' + char(10)
		SELECT @v_dSql += N'			AND		A.PLANT_ID			= R.PLANT_ID																																								' + char(10)
		SELECT @v_dSql += N'			AND		A.FACTORY_ID		= R.FACTORY_ID																																								' + char(10)
		SELECT @v_dSql += N'			AND		A.OPERATION_ID		= R.OPERATION_ID																																							' + char(10)
		SELECT @v_dSql += N'			AND		A.LINE_ID			= R.LINE_ID																																									' + char(10)
		SELECT @v_dSql += N'	WHERE	1=1                                                                                                                                                                                                     ' + char(10)        
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_GROUP' , 'LIKE_R', @p_pjt_group_name)) + char(10)
		SELECT @v_dSql += N'	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID, A.LINE_ID, A.OPERATION_ID DESC, A.ITEM_ID                                                                ' + char(10)        
		
		
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

