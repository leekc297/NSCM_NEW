

/*
 * Program ID   : PR_UI_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN
 * Description  : Cell Simulation(Pack)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/08/09   CYS				Initial Release UI통합
 * 2023/04/18   KCH             SCM_STOCK_H -> SCM_STOCK_H_V 뷰로 변경
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
 */

CREATE PROCEDURE [dbo].[PR_UI_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN]
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

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN';
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
	DECLARE @p_curr_date	NVARCHAR(MAX);
	DECLARE @p_cell_code	NVARCHAR(MAX);
	DECLARE @p_cell_group_code	NVARCHAR(MAX);
	DECLARE @p_line_assign	NVARCHAR(MAX);

	DECLARE @p_form_instance_id	NVARCHAR(MAX);
	DECLARE @p_form_plan_id		NVARCHAR(MAX);
	DECLARE @p_pack_instance_id	NVARCHAR(MAX);
	DECLARE @p_pack_plan_id		NVARCHAR(MAX);
	DECLARE @p_pack_plant_id	NVARCHAR(MAX);
	DECLARE @p_pack_factory_id	NVARCHAR(MAX);
	DECLARE @p_cell_plant_id	NVARCHAR(MAX);
	DECLARE @p_cell_factory_id	NVARCHAR(MAX);

	DECLARE @p_rel_pack		NVARCHAR(MAX);
	DECLARE @p_rel_form		NVARCHAR(MAX);
	
		
	
	DECLARE @p_plant_id_cond nvarchar(100) = ''
	SET @p_plant_id_cond = (SELECT TOP 1 SEGMENT2  FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_UI_FP01559_IN_HOUSE_REQUEST_MO_PLAN' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')

	

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
			SET @p_release_flag  =		@tmp_value
		END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
			SET @p_model_id  =			@tmp_value
		END ELSE IF @tmp_column = 'MODEL_NICK_NAME' BEGIN
			SET @p_model_nick_name  =	@tmp_value
		END ELSE IF @tmp_column = 'CURR_DATE' BEGIN
			SET @p_curr_date  =			@tmp_value
		END ELSE IF @tmp_column = 'PACK_INSTANCE_ID' BEGIN
			SET @p_pack_instance_id  =	@tmp_value
		END ELSE IF @tmp_column = 'CELL_CODE' BEGIN
			SET @p_cell_code =			@tmp_value
		

		END ELSE IF @tmp_column = 'CELL_GROUP_CODE' BEGIN
			SET @p_cell_group_code  =		@tmp_value
		END ELSE IF @tmp_column = 'LINE_ASSIGN' BEGIN
			SET @p_line_assign  =	@tmp_value
		END ELSE IF @tmp_column = 'REL_PACK' BEGIN
			SET @p_rel_pack  =		@tmp_value
		END ELSE IF @tmp_column = 'REL_FORM' BEGIN
			SET @p_rel_form  =		@tmp_value
		
		END ELSE IF @tmp_column = 'FORM_INSTANCE_ID' BEGIN
			SET @p_form_instance_id  =	@tmp_value
		END ELSE IF @tmp_column = 'FORM_PLAN_ID' BEGIN
			SET @p_form_plan_id  =		@tmp_value
		END ELSE IF @tmp_column = 'PACK_PLAN_ID' BEGIN
			SET @p_pack_plan_id =		@tmp_value
		END ELSE IF @tmp_column = 'PACK_PLANT_ID' BEGIN
			SET @p_pack_plant_id =		@tmp_value
		END ELSE IF @tmp_column = 'PACK_FACTORY_ID' BEGIN
			SET @p_pack_factory_id =	@tmp_value
		END ELSE IF @tmp_column = 'CELL_PLANT_ID' BEGIN
			SET @p_cell_plant_id =		@tmp_value
		END ELSE IF @tmp_column = 'CELL_FACTORY_ID' BEGIN
			SET @p_cell_factory_id =	@tmp_value

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

	BEGIN
		
		BEGIN
		    IF OBJECT_ID( 'tempdb..#STOCK_T' ) IS NOT NULL
			DROP TABLE #STOCK_T
        
			IF OBJECT_ID( 'tempdb..#REQUEST_P_CMA' ) IS NOT NULL
			DROP TABLE #REQUEST_P_CMA
		END

		
		BEGIN
		
		      CREATE TABLE 
		      #TEMP_TABLE_01
		      (
		        	COMPANY_ID nvarchar(30) NOT NULL,
		        	DIVISION_ID nvarchar(30) NOT NULL,
		        	SITE_ID nvarchar(30) NOT NULL,
		        	PLANT_ID nvarchar(30) NOT NULL,
		        	ITEM_ID nvarchar(150) NULL,
		        	CATEGORY_ID nvarchar(30) NULL,
					FROM_INSTANCE nvarchar(30) NULL,
					PLAN_DATE nvarchar(30) NULL,
		        	QTY numeric(25, 10) NULL DEFAULT ((0))
		      )

			CREATE TABLE #STOCK_T
			(
				[COMPANY_ID] [nvarchar](30) NOT NULL,
				[DIVISION_ID] [nvarchar](30) NOT NULL,
				[SITE_ID] [nvarchar](30) NOT NULL,
				[PLANT_ID] [nvarchar](30) NOT NULL,
				[FACTORY_ID] [nvarchar](30) NOT NULL,
				[ITEM_ID] [nvarchar](150) NULL,
				[STOCK_TYPE] [nvarchar](10) NULL,
				[QTY] [numeric](25, 10) NULL DEFAULT ((0)),
				[TOTAL_QTY] [numeric](25, 10) NULL DEFAULT ((0)),
				[AVAIL_QTY] [numeric](25, 10) NULL DEFAULT ((0)),
				[HOLD_QTY] [numeric](25, 10) NULL DEFAULT ((0)),
				[TOTAL_CELL_QTY] [numeric](25, 10) NULL DEFAULT ((0)),
				[AVAIL_CELL_QTY] [numeric](25, 10) NULL DEFAULT ((0)),
				[HOLD_CELL_QTY] [numeric](25, 10) NULL DEFAULT ((0)),
				[AVAIL_CELL_LONG_QTY] [numeric](25, 10) NULL DEFAULT ((0)),
				[HOLD_CELL_LONG_QTY] [numeric](25, 10) NULL DEFAULT ((0)),
				[INTRANSIT] [numeric](25, 10) NULL DEFAULT ((0))
			)
		      
			CREATE TABLE #REQUEST_P_CMA
			(
				[COMPANY_ID] [nvarchar](30) NOT NULL,
				[DIVISION_ID] [nvarchar](30) NOT NULL,
				[SITE_ID] [nvarchar](30) NOT NULL,
				[PLANT_ID] [nvarchar](30) NOT NULL,
				[FACTORY_ID] [nvarchar](30) NOT NULL,
				[ITEM_ID] [nvarchar](150) NULL,
				[CELL_ITEM_ID] [nvarchar](150) NULL,
				[PLAN_DATE] [nvarchar](8) NULL,
				[QTY] [numeric](25, 10) NULL DEFAULT ((0)),
				[BOM_RATE] [numeric](25, 10) NULL
			)
		
		END

		SET	@v_dSql = ''

		SELECT @v_dSql +=	N'	  INSERT INTO #STOCK_T																																																				' + char(10)
		SELECT @v_dSql +=	N'		-- pack                                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, ''PACK'' AS STOCK_TYPE                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'				 , SUM(QTY) AS QTY                                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'				 , SUM(AVAIL_QTY) +  SUM(HOLD_QTY) AS TOTAL_QTY                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'				 , SUM(AVAIL_QTY) AS AVAIL_QTY                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'				 , SUM(HOLD_QTY) AS HOLD_QTY                                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'         , 0 AS TOTAL_CELL_QTY                                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'         , 0 AS AVAIL_CELL_QTY                                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'         , 0 AS HOLD_CELL_QTY                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'         , 0 as AVAIL_CELL_LONG_QTY                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'         , 0 as HOLD_CELL_LONG_QTY                                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'         , SUM(PACK_INTRANSIT) AS INTRANSIT                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'		FROM   (                                                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID AS ITEM_ID, A.EXPORT_SLOC_ID, A.STOCK_TYPE                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'								 , ISNULL(MAX(MODIFY_QTY), SUM(A.QTY)) AS QTY	                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'								 , ISNULL(ISNULL(MAX(BOH_MODIFY_QTY), SUM(A.BOH_QTY)),0) AS AVAIL_QTY		 --이전 BOH입력 가능하여 MODIFY 수량을 MAX 로 먼저 가져간다.                                                                ' + char(10)
		SELECT @v_dSql +=	N'								 , ISNULL(ISNULL(MAX(HOLD_MODIFY_QTY), SUM(A.HOLD_QTY)),0) AS HOLD_QTY                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'								 , ISNULL(ISNULL(MAX(BOH_CELL_MODIFY_QTY), SUM(A.BOH_CELL_QTY)),0) AS AVAIL_CELL_QTY                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'								 , ISNULL(ISNULL(MAX(HOLD_CELL_MODIFY_QTY), SUM(A.HOLD_CELL_QTY)),0) AS HOLD_CELL_QTY                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'								 , ISNULL(SUM(A.PACK_INTRANSIT),0) AS PACK_INTRANSIT                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'						FROM   (                                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'											SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'												 , A.FP_APPLY_ITEM_ID AS ITEM_ID, B.EXPORT_SLOC_ID                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'												 , A.MODIFY_FP_APPLY_WIPQTY AS MODIFY_QTY                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'												 , A.FP_APPLY_WIPQTY AS QTY                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'												 , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS BOH_MODIFY_QTY        ' + char(10)
		SELECT @v_dSql +=	N'												 , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y'' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS BOH_QTY                      ' + char(10)
		SELECT @v_dSql +=	N'												 , CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_MODIFY_QTY                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'												 , CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.FP_APPLY_WIPQTY ELSE NULL END AS HOLD_QTY                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS BOH_CELL_MODIFY_QTY                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS BOH_CELL_QTY                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS HOLD_CELL_MODIFY_QTY                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS HOLD_CELL_QTY                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS PACK_INTRANSIT                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'												 , ''CMA'' AS STOCK_TYPE                                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'											FROM   SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'											INNER JOIN ( --<V: LOOKUP에 STOCK POINT 참조 >--                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'		    											SELECT B.LOOKUP_TYPE_CODE                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'			    												 , B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                               ' + char(10)
		SELECT @v_dSql +=	N'			    												 , B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS                             ' + char(10)
		SELECT @v_dSql +=	N'		    											FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                                                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'		    											WHERE  B.ACTIVE_FLAG = ''Y''                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'		    											AND    B.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'		    											AND    B.SEGMENT1         = ''IN_HOUSE_REQUEST''                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'											) V                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'											ON   1=1                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'											AND  A.DIVISION_ID		= V.DIVISION_ID                                                                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'											AND  A.SITE_ID			= V.SITE_ID                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'											AND  A.PLANT_ID			= V.PLANT_ID                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'											AND  A.STOCK_TYPE		= V.STOCK_TYPE                                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'											AND  A.OPERATION_ID		= V.STOCK_POINT                                                                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'											AND  A.STOCK_STATUS		= V.STOCK_STATUS                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'											AND  V.PACK_BOH			= ''Y''                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'											LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'											ON  A.COMPANY_ID   = B.COMPANY_ID                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'											AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'											AND A.SITE_ID     = B.SITE_ID                                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'											AND A.PLANT_ID    = B.PLANT_ID                                                                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'											AND A.FACTORY_ID  = B.FACTORY_ID                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'											--AND A.FP_APPLY_OPERATION_ID = B.OPERATION_ID                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'                                            AND B.OPERATION_ID = (CASE WHEN A.PLANT_ID = ''' + @p_plant_id_cond + ''' THEN ''P5000'' ELSE ''P1000'' END)    ' + char(10)
		SELECT @v_dSql +=	N'											AND A.LINE_ID = B.LINE_ID                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'											AND B.ACTIVE_FLAG = ''Y''                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'											WHERE 1=1                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'											AND   A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_curr_date +''') -- 시업시간 포함 현재날짜                                                                                                               ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql +=	N'					            AND	  ( ISNULL(A.MODIFY_FP_APPLY_WIPQTY, 0) >=0 OR ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0 )                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'					            UNION ALL                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'					            --INVENTORY 수량                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'					            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, V.FACTORY_ID                                                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'												 , A.FP_APPLY_ITEM_ID AS ITEM_ID, B.EXPORT_SLOC_ID                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'												 , NULL AS MODIFY_QTY                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'												 , A.QTY2 AS QTY                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'												 , NULL AS BOH_MODIFY_QTY                                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'												 , A.QTY2 AS BOH_QTY                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'												 , NULL AS HOLD_MODIFY_QTY                                                                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'												 , A.DEFECT_QTY AS HOLD_QTY                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS BOH_CELL_MODIFY_QTY                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS BOH_CELL_QTY                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS HOLD_CELL_MODIFY_QTY                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS HOLD_CELL_QTY                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS PACK_INTRANSIT                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'												 , ''CMA'' AS STOCK_TYPE                                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'										FROM   SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'										INNER JOIN ( --<V: LOOKUP에 STOCK POINT 참조 >--                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'	    										SELECT B.LOOKUP_TYPE_CODE                                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'	    											 , B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                                           ' + char(10)
		SELECT @v_dSql +=	N'	    											 , B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS                                         ' + char(10)
		SELECT @v_dSql +=	N'	    											 , B.ATTRIBUTE6 AS FACTORY_ID, B.ATTRIBUTE7 AS LINE_ID                                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'	    										FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'	    										WHERE  B.ACTIVE_FLAG = ''Y''                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'	    										AND    B.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''                                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'	    										AND    B.SEGMENT1         = ''IN_HOUSE_REQUEST''                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'	    										AND    B.ATTRIBUTE1       = ''INVENTORY''                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'										) V                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'										ON   1=1                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'										AND  A.DIVISION_ID  = V.DIVISION_ID                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'										AND  A.SITE_ID			= V.SITE_ID                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'										AND  A.PLANT_ID			= V.PLANT_ID                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'										AND  A.STOCK_TYPE		= V.STOCK_TYPE                                                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'										AND  A.STORAGE_ID		= V.STOCK_POINT                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'										AND  V.PACK_BOH			= ''Y''                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'										LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'										AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'										AND A.SITE_ID     = B.SITE_ID                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'										AND A.PLANT_ID    = B.PLANT_ID                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'										AND V.FACTORY_ID  = B.FACTORY_ID                                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'										--AND B.OPERATION_ID = ''P5000''                                                                                                                                                                ' + char(10)
		--SELECT @v_dSql +=	N'										AND B.OPERATION_ID = (CASE WHEN A.PLANT_ID = ''G388'' THEN ''P5000'' ELSE ''P1000'' END)                                                                                                        ' + char(10)
		SELECT @v_dSql +=   N'                                      AND    B.OPERATION_ID = (CASE WHEN A.PLANT_ID = ''' + @p_plant_id_cond + ''' THEN ''P5000'' ELSE ''P1000'' END)    ' + char(10)
		SELECT @v_dSql +=	N'										--AND A.FP_APPLY_OPERATION_ID = B.OPERATION_ID                                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'										AND V.LINE_ID = B.LINE_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										AND B.ACTIVE_FLAG = ''Y''                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										WHERE 1=1                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										AND   A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_curr_date +''') -- 시업시간 포함 현재날짜                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql +=	N'										AND   V.FACTORY_ID IS NOT NULL -- 동 필수                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										UNION ALL                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										-- SSP 테이블 기준으로 변경.... 20210105                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'												 , A.ITEM_ID, A.TO_SLOC_ID AS EXPORT_SLOC_ID                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS MODIFY_QTY                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS QTY                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS BOH_MODIFY_QTY                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS BOH_QTY                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS HOLD_MODIFY_QTY                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS HOLD_QTY                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS BOH_CELL_MODIFY_QTY                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS BOH_CELL_QTY                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS HOLD_CELL_MODIFY_QTY                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'												 , 0 AS HOLD_CELL_QTY                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'												 , A.PACK_MOVE_QTY AS PACK_INTRANSIT                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'												 , ''INTRNASIT'' AS STOCK_TYPE                                                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'										FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK)                                                                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'										WHERE  1=1                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'										AND    A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_curr_date +''') -- 시업시간 포함 현재날짜                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'										AND    A.PACK_MOVE_QTY > 0                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql +=	N'			) A                                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'			WHERE 1=1                                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.EXPORT_SLOC_ID, A.STOCK_TYPE                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'	) A                                                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'	WHERE 1=1                                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'	-- CELL                                                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'	UNION ALL                                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, ''CELL'' AS STOCK_TYPE --, A.STOCK_TYPE                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'			 , SUM(QTY) AS QTY                                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'			 , SUM(AVAIL_QTY) +  SUM(HOLD_QTY) AS TOTAL_QTY                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'			 , SUM(AVAIL_QTY) AS AVAIL_QTY                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'			 , SUM(HOLD_QTY) AS HOLD_QTY                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'			 , SUM(AVAIL_CELL_QTY) + SUM(HOLD_CELL_QTY) + SUM(AVAIL_CELL_LONG_QTY) + SUM(HOLD_CELL_LONG_QTY) AS TOTAL_CELL_QTY                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'			 , SUM(AVAIL_CELL_QTY) AS AVAIL_CELL_QTY                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'			 , SUM(HOLD_CELL_QTY) AS HOLD_CELL_QTY                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'			 , SUM(AVAIL_CELL_LONG_QTY) AS AVAIL_CELL_LONG_QTY                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'			 , SUM(HOLD_CELL_LONG_QTY) AS HOLD_CELL_LONG_QTY                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'			 , SUM(PACK_INTRANSIT) AS INTRANSIT                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'	FROM   (                                                                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID AS ITEM_ID, A.EXPORT_SLOC_ID--, A.STOCK_TYPE                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'							 , ISNULL(MAX(MODIFY_QTY), SUM(A.QTY)) AS QTY                                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'							 , ISNULL(ISNULL(MAX(BOH_MODIFY_QTY), SUM(A.BOH_QTY)),0) AS AVAIL_QTY                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'							 , ISNULL(ISNULL(MAX(HOLD_MODIFY_QTY), SUM(A.HOLD_QTY)),0) AS HOLD_QTY                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'							 , ISNULL(ISNULL(MAX(BOH_CELL_MODIFY_QTY), SUM(A.BOH_CELL_QTY)),0) AS AVAIL_CELL_QTY                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'							 , ISNULL(ISNULL(MAX(HOLD_CELL_MODIFY_QTY), SUM(A.HOLD_CELL_QTY)),0) AS HOLD_CELL_QTY                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'							 , ISNULL(MAX(AVAIL_CELL_LONG_QTY),0) AS AVAIL_CELL_LONG_QTY                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'							 , ISNULL(MAX(HOLD_CELL_LONG_QTY),0) AS HOLD_CELL_LONG_QTY                                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'							 , ISNULL(SUM(A.PACK_INTRANSIT),0) AS PACK_INTRANSIT                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'					FROM   (                                                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'											 , A.FP_APPLY_ITEM_ID AS ITEM_ID, B.EXPORT_SLOC_ID                                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'											 , CASE WHEN '''+ @p_pack_instance_id +''' = ''PL_PACK'' THEN 0 ELSE A.MODIFY_FP_APPLY_WIPQTY END AS MODIFY_QTY                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'											 , CASE WHEN '''+ @p_pack_instance_id +''' = ''PL_PACK'' THEN 0 ELSE A.FP_APPLY_WIPQTY END AS QTY                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'											 , 0 AS BOH_MODIFY_QTY                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'											 , 0 AS BOH_QTY                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'											 , 0 AS HOLD_MODIFY_QTY                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'											 , 0 AS HOLD_QTY                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'											 , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS BOH_CELL_MODIFY_QTY       ' + char(10)
		SELECT @v_dSql +=	N'											 , CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> ''Y'' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS BOH_CELL_QTY                     ' + char(10)
		SELECT @v_dSql +=	N'											 , CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_CELL_MODIFY_QTY                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'											 , CASE WHEN WIPHOLD_YN = ''Y'' THEN  A.FP_APPLY_WIPQTY ELSE NULL END AS HOLD_CELL_QTY                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'											 , 0 AS AVAIL_CELL_LONG_QTY                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'											 , 0 AS HOLD_CELL_LONG_QTY                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'											 , 0 AS PACK_INTRANSIT                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'											 , ''CELL'' AS STOCK_TYPE                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'										FROM   SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'										INNER JOIN ( --<V: LOOKUP에 STOCK POINT 참조 >--                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'													SELECT B.LOOKUP_TYPE_CODE                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'														 , B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                                       ' + char(10)
		SELECT @v_dSql +=	N'														 , B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS                                     ' + char(10)
		SELECT @v_dSql +=	N'													FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'													WHERE  B.ACTIVE_FLAG = ''Y''                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'													AND    B.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'													AND    B.SEGMENT1         = ''IN_HOUSE_REQUEST''                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'										) V                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'										ON   1=1                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'										AND  A.DIVISION_ID		= V.DIVISION_ID                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'										AND  A.SITE_ID			= V.SITE_ID                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'										AND  A.PLANT_ID			= V.PLANT_ID                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'										AND  A.STOCK_TYPE		= V.STOCK_TYPE                                                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'										AND  A.STORAGE_ID		= V.STOCK_POINT                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'										AND  V.CELL_BOH			= ''Y''                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'										LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										ON  A.COMPANY_ID = B.COMPANY_ID                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'										AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'										AND A.SITE_ID = B.SITE_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										AND A.PLANT_ID = B.PLANT_ID                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'										AND A.FACTORY_ID = B.FACTORY_ID                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'										--AND A.FP_APPLY_OPERATION_ID = B.OPERATION_ID                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'                                        AND B.OPERATION_ID = (CASE WHEN A.PLANT_ID = ''' + @p_plant_id_cond + ''' THEN ''P5000'' ELSE ''P1000'' END)    ' + char(10)
		SELECT @v_dSql +=	N'										AND A.LINE_ID = B.LINE_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										AND B.ACTIVE_FLAG = ''Y''                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										WHERE  1=1                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql +=	N'										AND    A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_curr_date +''') -- 시업시간 포함 현재날짜                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'										AND	   ( ISNULL(A.MODIFY_FP_APPLY_WIPQTY, 0) >=0 OR ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0 )                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'										-- DW 재고가 아닌 조건                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'										AND NOT EXISTS (                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'												SELECT 1                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'												FROM (                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'													  SELECT ''DW'' AS STOCK_TYPE, ''-'' AS STORAGE_ID                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'                      									, (                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'                        										SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = ''SSP'' THEN 1 ELSE 0 END), 1) AS IS_SSP                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'                        										FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'                        										WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_STOCK_SOURCE''                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'                        										AND    A.ACTIVE_FLAG = ''Y''                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'                        										AND    A.SEGMENT1 = '''+ @p_pack_instance_id +'''                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'                      									) AS IS_SSP                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'												) AA                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'												WHERE A.STOCK_TYPE = AA.STOCK_TYPE                                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'												AND   A.STORAGE_ID = AA.STORAGE_ID                                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'												AND   1=AA.IS_SSP                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										)                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'										UNION ALL                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										-- SSP 재고 추가                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, NULL AS EXPORT_SLOC_ID                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'											 , A.QTY AS MODIFY_QTY, A.QTY                                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'											 , 0 AS BOH_MODIFY_QTY                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'											 , 0 AS BOH_QTY                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'											 , 0 AS HOLD_MODIFY_QTY                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'											 , 0 AS HOLD_QTY                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'											 , A.AVAIL_CELL_QTY AS BOH_CELL_MODIFY_QTY                                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'											 , A.AVAIL_CELL_QTY AS BOH_CELL_QTY                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'											 , A.HOLD_CELL_QTY AS HOLD_CELL_MODIFY_QTY                                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'											 , A.HOLD_CELL_QTY AS HOLD_CELL_QTY                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'											 , A.AVAIL_CELL_LONG_QTY                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'											 , A.HOLD_CELL_LONG_QTY                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'											 , 0 AS PACK_INTRANSIT                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'											 , ''CELL'' AS STOCK_TYPE                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'										FROM (                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'												SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'													 , SUM(CASE WHEN HOLD = ''N'' AND LONG_TERM_FLAG = ''N'' THEN QTY ELSE 0 END) AS AVAIL_CELL_QTY -- 가용, 노장기                                                                     ' + char(10)
		SELECT @v_dSql +=	N'													 , SUM(CASE WHEN HOLD = ''N'' AND LONG_TERM_FLAG != ''N'' THEN QTY ELSE 0  END) AS AVAIL_CELL_LONG_QTY  -- 가용, 장기                                                               ' + char(10)
		SELECT @v_dSql +=	N'													 , SUM(CASE WHEN HOLD != ''N'' AND LONG_TERM_FLAG = ''N'' THEN QTY ELSE 0  END) AS HOLD_CELL_QTY     -- 비가용, 노장기                                                              ' + char(10)
		SELECT @v_dSql +=	N'													 , SUM(CASE WHEN HOLD != ''N'' AND LONG_TERM_FLAG != ''N'' THEN QTY ELSE 0  END) AS HOLD_CELL_LONG_QTY      -- 비가용, 장기                                                         ' + char(10)
		SELECT @v_dSql +=	N'													 , SUM(QTY) AS QTY -- 전체                                                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'												FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK)                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'												WHERE  1=1                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'												AND    A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_curr_date +''') -- 시업시간 포함 현재날짜                                                                                                          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10);
		SELECT @v_dSql +=	N'												AND    A.QTY > 0                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'												GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'										) A                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'						) A                                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'						WHERE 1=1                                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.EXPORT_SLOC_ID, A.STOCK_TYPE                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'	) A                                                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'	WHERE 1=1                                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                                                ' + char(10)

		DECLARE @v_tempSql nvarchar(max) = @v_dSql
		
		EXEC SP_EXECUTESQL @v_dSql

		--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_tempSql,'SELECT a',@runstart, @runend
		
		SET	@v_dSql = ''

		SELECT @v_dSql += N'	INSERT INTO #REQUEST_P_CMA																																										' + char(10)			
		SELECT @v_dSql += N'	  	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID -- pack 동                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	    		 , A.ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	    		 , CASE WHEN (RANK() OVER (PARTITION BY A.PLANT_ID, A.ITEM_ID, A.PLAN_DATE ORDER BY ISNULL(X.LINE_PRIORITY,9), A.IDX ) ) = 1 THEN A.QTY ELSE 0 END AS QTY                           ' + char(10)
		SELECT @v_dSql += N'	    		 , A.BOM_RATE                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	  	FROM   (                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	  					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	  						 , A.ITEM_ID, C.CHILD_ITEM_ID AS CELL_ITEM_ID                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  						 , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                                                        ' + char(10)
		
		IF @p_rel_pack = 'Y' BEGIN
			SELECT @v_dSql += N'	  						  , (SUM(A.PLAN_IN_QTY) * MAX(C.BOM_RATE)) AS QTY                                                                                 ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql += N'	  						  , (SUM(A.IN_QTY) * MAX(C.BOM_RATE)) AS QTY                                                                                      ' + char(10)
		END

		SELECT @v_dSql += N'	  						 , C.BOM_RATE AS BOM_RATE, C.IDX                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	  						 , A.FACTORY_ID                                                                                                                                                         ' + char(10)
		
		IF @p_rel_pack = 'Y' BEGIN
			SELECT @v_dSql += N'	  				FROM FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK),                                                                                 ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql += N'	  				FROM FP_AMEND_PLAN_PACK_R A WITH(NOLOCK),                                                                                      ' + char(10)
		END
		
		SELECT @v_dSql += N'	  						   SCM_LINE_M B WITH(NOLOCK),                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  						   (                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	  		            SELECT SB.*                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	  								FROM (                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'					            		SELECT SB.*                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'					            		FROM (                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	  												SELECT C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, MAX(C.CHILD_QTY/C.PARENT_QTY) AS BOM_RATE, C.ALT_PRIORITY                   ' + char(10)
		SELECT @v_dSql += N'	  											       , RANK() OVER (PARTITION BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID ORDER BY ISNULL(C.ALT_PRIORITY,99) * 10 ) AS IDX                      ' + char(10)
		SELECT @v_dSql += N'	  												FROM   SCM_BOM_M C WITH(NOLOCK)                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	  												INNER HASH JOIN (                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  																	SELECT D.COMPANY_ID, D.DIVISION_ID, D.SITE_ID, D.ITEM_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'	  																	FROM   SCM_ITEM_M D WITH(NOLOCK),                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  																		     SCM_ITEM_CLASS_M E WITH(NOLOCK)                                                                                    ' + char(10)
		SELECT @v_dSql += N'	  																	WHERE 1=1                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('D.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('D.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql += N'	  																	AND	 D.ITEM_CLASS = E.CLASS_ID                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  																	AND	 D.ACTIVE_FLAG = ''Y''                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	  																	AND  E.LEVEL_3_NAME = ''CELL''                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  												) D                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	  												ON    1=1                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	  												AND   C.COMPANY_ID = D.COMPANY_ID                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  												AND   C.DIVISION_ID = D.DIVISION_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	  												AND   C.SITE_ID = D.SITE_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	  												AND   C.CHILD_ITEM_ID = D.ITEM_ID                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  												WHERE 1=1                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	  												AND   C.EFF_END_DATE >= GETDATE()                                                                                                               ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.PLANT_ID' , 'EQ', @p_pack_plant_id)) + char(10);
		SELECT @v_dSql += N'	  												AND NOT EXISTS (                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	    													SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS MODULE, A.SEGMENT3 AS CELL_GROUP_CODE                                                       ' + char(10)
		SELECT @v_dSql += N'	    													FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                              ' + char(10)
		SELECT @v_dSql += N'	    													WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_TO_CELL_GROUP''                                                                                    ' + char(10)
		SELECT @v_dSql += N'	    													AND	   A.ACTIVE_FLAG = ''Y''                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	    													AND	   C.SITE_ID = A.SEGMENT1                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	    													AND	   C.PARENT_ITEM_ID = A.SEGMENT2                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	    													AND	   C.CHILD_ITEM_ID = A.SEGMENT3                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	  												)                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  												GROUP BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, C.ALT_PRIORITY                                                            ' + char(10)
		SELECT @v_dSql += N'	  										) SB                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	  										UNION ALL                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  										SELECT SB.*                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	  										FROM   (                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	  												SELECT 	C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, MAX(C.CHILD_QTY/C.PARENT_QTY) AS BOM_RATE, C.ALT_PRIORITY                  ' + char(10)
		SELECT @v_dSql += N'	  	      											, RANK() OVER (PARTITION BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID ORDER BY  ISNULL(C.ALT_PRIORITY,99) * 10 ) AS IDX                    ' + char(10)
		SELECT @v_dSql += N'	  												FROM 	SCM_BOM_M C WITH(NOLOCK)                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	  												INNER HASH JOIN (                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  																	SELECT D.COMPANY_ID, D.DIVISION_ID, D.SITE_ID, D.ITEM_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'	  																	FROM   SCM_ITEM_M D WITH(NOLOCK),                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  																		     SCM_ITEM_CLASS_M E WITH(NOLOCK)                                                                                    ' + char(10)
		SELECT @v_dSql += N'	  																	WHERE  1=1                                                                                                                  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('D.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('D.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql += N'	  																	AND	 D.ITEM_CLASS = E.CLASS_ID                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  																	AND	 D.ACTIVE_FLAG = ''Y''                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	  																	AND  E.LEVEL_3_NAME = ''CELL''                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  												) D                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	  												ON     1=1                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	  												AND    C.COMPANY_ID = D.COMPANY_ID                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  												AND    C.DIVISION_ID = D.DIVISION_ID                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	  												AND    C.SITE_ID = D.SITE_ID                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	  												AND    C.CHILD_ITEM_ID = D.ITEM_ID                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  												WHERE  1=1                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	  												AND    C.EFF_END_DATE >= GETDATE()                                                                                                              ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.PLANT_ID' , 'EQ', @p_pack_plant_id)) + char(10);
		SELECT @v_dSql += N'	  												AND 	 EXISTS (                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  																SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS MODULE, A.SEGMENT3 AS CELL_GROUP_CODE                                               ' + char(10)
		SELECT @v_dSql += N'	  																FROM	 SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                    ' + char(10)
		SELECT @v_dSql += N'	  																WHERE	 A.LOOKUP_TYPE_CODE = ''MODULE_TO_CELL_GROUP''                                                                          ' + char(10)
		SELECT @v_dSql += N'	  																AND	   A.ACTIVE_FLAG = ''Y''                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	  																AND	   C.SITE_ID = A.SEGMENT1                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	  																AND	   C.PARENT_ITEM_ID = A.SEGMENT2                                                                                            ' + char(10)
		SELECT @v_dSql += N'	  																AND	   C.CHILD_ITEM_ID = A.SEGMENT3                                                                                             ' + char(10)
		SELECT @v_dSql += N'	  												)                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  												GROUP BY C.DIVISION_ID, C.SITE_ID, C.PARENT_ITEM_ID, C.CHILD_ITEM_ID, C.ALT_PRIORITY                                                            ' + char(10)
		SELECT @v_dSql += N'	  											) SB                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	  								) SB                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	  								WHERE	1=1                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	  						) C                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	  						WHERE  1=1                                                                                                                                                              ' + char(10)
		
		IF @p_rel_pack = 'Y' BEGIN
			SELECT @v_dSql += N'	  						  AND	   A.PLAN_TYPE = ''RELEASE''                                                                                 ' + char(10)
			SELECT @v_dSql += N'	  						  AND	   A.PLAN_IN_QTY > 0                                                                                 ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql += N'	  						  AND	   A.INSTANCE_ID = '''+ @p_pack_instance_id +'''                                                                                             ' + char(10)
			SELECT @v_dSql += N'	  						  AND	   A.FP_PLAN_ID = '''+ @p_pack_plan_id +'''                                                                                                  ' + char(10)
			SELECT @v_dSql += N'	  						  AND	   A.IN_QTY > 0                                                                                                                                      ' + char(10)
		END

		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql += N'	  						AND    A.OPERATION_ID IN (''P5000'', ''P5200'')                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	  						AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' -1 AND '''+ @p_bucket_to +''' +1 --선행일자 때문에 앞 뒤로 하루씩 늘려준다.                                          ' + char(10)
		SELECT @v_dSql += N'	  						AND    A.SITE_ID = B.SITE_ID                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	  						AND    A.DIVISION_ID = B.DIVISION_ID                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	  						--AND    A.OPERATION_ID = B.OPERATION_ID                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'                            AND    B.OPERATION_ID = (CASE WHEN A.PLANT_ID = ''' + @p_plant_id_cond + ''' THEN ''P5000'' ELSE ''P1000'' END)    ' + char(10)
		SELECT @v_dSql += N'	  						AND    A.LINE_ID = B.LINE_ID                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	  						AND    A.SITE_ID = C.SITE_ID                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	  						AND    A.DIVISION_ID = C.DIVISION_ID                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	  						AND    A.ITEM_ID = C.PARENT_ITEM_ID                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	  						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	      								, A.ITEM_ID, C.CHILD_ITEM_ID, A.MARKET, CONVERT(VARCHAR,A.PLAN_DATE,112)                                                                                    ' + char(10)
		SELECT @v_dSql += N'	      								, C.BOM_RATE, C.IDX                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	      								, A.FACTORY_ID                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  	) A                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	  	LEFT OUTER JOIN (                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  				SELECT 	A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.ITEM_ID AS ASSIGN_ITEM_ID, MONTH, MIN(PRIORITY) AS LINE_PRIORITY                                               ' + char(10)
		SELECT @v_dSql += N'	  				FROM   	SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	  				WHERE 	1=1                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_pack_plant_id)) + char(10);
		SELECT @v_dSql += N'	  				AND 	OPERATION_ID = ''A9000''                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	  				AND 	PRIORITY NOT IN (''0'',''9'')                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  				AND 	MONTH >= SUBSTRING(CONVERT(NVARCHAR,'''+ @p_plan_date +''',112),1,6)                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	  				GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID, A.ITEM_ID, MONTH                                                                                                ' + char(10)
		SELECT @v_dSql += N'	  	) X                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	  	ON  A.COMPANY_ID   = X.COMPANY_ID                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  	AND A.DIVISION_ID  = X.DIVISION_ID                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	  	AND A.SITE_ID      = X.SITE_ID                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  	AND A.PLANT_ID     = X.PLANT_ID                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	  	AND A.CELL_ITEM_ID = X.ASSIGN_ITEM_ID                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	  	AND SUBSTRING(CONVERT(NVARCHAR,A.PLAN_DATE,112),1,6) = X.MONTH                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  	WHERE	1=1                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	  	AND   A.QTY > 0                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ITEM_ID' , 'LIKE', @p_cell_code)) + char(10);
		SELECT @v_dSql += N'	  	AND	EXISTS (                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	  				SELECT 1                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	  				FROM   (                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'	              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID AS CELL_ITEM_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'									FROM   FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'						      WHERE  1=1                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'									AND    A.CATEGORY = ''REQUEST''                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'									AND    A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                                            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_pack_plant_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_FACTORY_ID' , 'EQ', @p_pack_factory_id)) + char(10);
		SELECT @v_dSql += N'	  				) X                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	  				WHERE 1=1                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	  				AND		A.COMPANY_ID   = X.COMPANY_ID                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	  				AND		A.DIVISION_ID  = X.DIVISION_ID                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	  				AND		A.SITE_ID      = X.SITE_ID                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  				AND		A.PLANT_ID     = X.PLANT_ID                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	  				AND		A.CELL_ITEM_ID = X.CELL_ITEM_ID                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	  	)                                                                                                                                                                                           ' + char(10)


		DECLARE @v_tempSql2 nvarchar(max) = @v_dSql
		
		EXEC SP_EXECUTESQL @v_dSql

		--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_tempSql2,'SELECT a',@runstart, @runend


		SET	@v_dSql = ''

		SELECT @v_dSql += N'      WITH MAIN_REQUEST_S AS (																																														' + char(10)
		SELECT @v_dSql += N'              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ''-'' AS CELL_FACTORY_ID, A.FACTORY_ID AS PACK_FACTORY_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'                   , A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME, A.CELL_ITEM_ID, ISNULL(C.NICK_NAME,''-'') AS CELL_NICK_NAME                                                                                 ' + char(10)
		SELECT @v_dSql += N'                   , NULL AS BOH_QTY                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'                   , NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'                   , NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'                   , NULL AS INTRANSIT                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'                   , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'                   , A.BOM_RATE                                                                                                                                                                                     ' + char(10)
		
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

		SELECT @v_dSql += N'                   , ''REQUEST_S'' AS CATEGORY_ID, ''P(CMA)'' AS CATEGORY_NAME, ''REQUEST'' AS CATEGORY_TYPE, 100 AS CATEGORY_ORDER                                                                                 ' + char(10)
		SELECT @v_dSql += N'                   , ''DATA'' AS DATA_TYPE                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'            FROM #REQUEST_P_CMA A                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	    INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	    ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'      	    AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      	    AND A.SITE_ID     = B.SITE_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	    AND A.ITEM_ID     = B.ITEM_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	    AND B.ACTIVE_FLAG = ''Y''                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	    INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	    ON  A.COMPANY_ID  = C.COMPANY_ID                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'      	    AND A.DIVISION_ID = C.DIVISION_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      	    AND A.SITE_ID     = C.SITE_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	    AND A.CELL_ITEM_ID = C.ITEM_ID                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      	    AND C.ACTIVE_FLAG = ''Y''                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	    INNER HASH JOIN TH_UIS_CAL D WITH(NOLOCK)                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	    ON  A.PLAN_DATE   = D.YYYYMMDD                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      	    WHERE 1=1                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	    AND   A.QTY > 0                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'      	    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'                   , A.ITEM_ID, ISNULL(B.NICK_NAME,''-''), A.CELL_ITEM_ID, ISNULL(C.NICK_NAME,''-'')                                                                                                                ' + char(10)
		SELECT @v_dSql += N'                   , A.BOM_RATE                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'      )                                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      -- P : R(Cell Req.)                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      , MAIN_REQUEST_P AS (                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      	    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ''-'' AS CELL_FACTORY_ID, A.PACK_FACTORY_ID                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      				 , NULL AS ITEM_ID, NULL AS NICK_NAME, A.ITEM_ID AS CELL_ITEM_ID, ISNULL(C.NICK_NAME,''-'') AS CELL_NICK_NAME                                                                                   ' + char(10)
		SELECT @v_dSql += N'      				 , ISNULL(D.QTY,0) AS BOH_QTY                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      				 , ISNULL(D.TOTAL_QTY,0) AS TOTAL_QTY, ISNULL(D.AVAIL_QTY,0) AS AVAIL_QTY, ISNULL(D.HOLD_QTY,0) AS HOLD_QTY                                                                                     ' + char(10)
		SELECT @v_dSql += N'      				 , NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'      				 , ISNULL(D.INTRANSIT,0) AS INTRANSIT                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      				 , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      				 , NULL AS BOM_RATE                                                                                                                                                                             ' + char(10)
		
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
					
					SELECT @v_dSql += N'      			, SUM(CASE WHEN E.YYYYMM = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE WHEN E.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

		SELECT @v_dSql += N'      				 , ''REQUEST_P'' AS CATEGORY_ID, ''R(Cell Req.)'' AS CATEGORY_NAME, ''REQUEST'' AS CATEGORY_TYPE, 200 AS CATEGORY_ORDER                                                                         ' + char(10)
		SELECT @v_dSql += N'      				 , ''DATA'' AS DATA_TYPE                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'      	    FROM  FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      			INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			ON  A.COMPANY_ID  = C.COMPANY_ID                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      			AND A.DIVISION_ID = C.DIVISION_ID                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      			AND A.SITE_ID     = C.SITE_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      			AND A.ITEM_ID     = C.ITEM_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      			AND C.ACTIVE_FLAG = ''Y''                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			INNER HASH JOIN TH_UIS_CAL E WITH(NOLOCK)                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			ON  A.PLAN_DATE   = E.YYYYMMDD                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      		  LEFT OUTER HASH JOIN (                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      					SELECT *                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      					FROM   #STOCK_T A                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      					WHERE  A.STOCK_TYPE = ''PACK''                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      			) D                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      			ON  A.COMPANY_ID   = D.COMPANY_ID                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      			AND A.DIVISION_ID  = D.DIVISION_ID                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      			AND A.SITE_ID      = D.SITE_ID                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      			AND A.PLANT_ID     = D.PLANT_ID                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'      			AND A.PACK_FACTORY_ID = D.FACTORY_ID                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      			AND A.ITEM_ID      = D.ITEM_ID                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      	    WHERE 1=1                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	    AND   A.QTY > 0                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      			AND   A.CATEGORY = ''REQUEST''                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      			AND   A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                                                                                 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_pack_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_FACTORY_ID' , 'EQ', @p_pack_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_cell_code)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'      	    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      				   , A.ITEM_ID, ISNULL(C.NICK_NAME,''-'')                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      				   , ISNULL(D.QTY,0)                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      				   , ISNULL(D.TOTAL_QTY,0), ISNULL(D.AVAIL_QTY,0), ISNULL(D.HOLD_QTY,0)                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      				   , ISNULL(D.INTRANSIT,0)                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      )                                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      , MAIN_REQUEST_I AS (                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      	        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ''-'' AS CELL_FACTORY_ID, A.FACTORY_ID AS PACK_FACTORY_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'            				 , NULL AS ITEM_ID, NULL AS NICK_NAME, A.CELL_ITEM_ID AS CELL_ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS CELL_NICK_NAME                                                                      ' + char(10)
		SELECT @v_dSql += N'            				 , NULL AS BOH_QTY                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'            				 , NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'            				 , NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY                                                                                                                ' + char(10)
		SELECT @v_dSql += N'            				 , NULL AS INTRANSIT                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'            				 , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'            				 , NULL AS BOM_RATE                                                                                                                                                                     ' + char(10)
		
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

					SELECT @v_dSql += N'                , SUM(CASE	WHEN A.PLAN_DATE <= ''' + @sub_param_0 + ''' AND A.PLAN_DATE >= '''+ @p_curr_date +''' AND D.CATEGORY_ID = ''REQUEST_I'' THEN A.EOH_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql += N'      	             , D.CATEGORY_ID, D.CATEGORY_NAME, D.CATEGORY_TYPE, D.CATEGORY_ORDER                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      	             , ''DATA'' AS DATA_TYPE                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'      	        FROM (                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      		            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'      	                 	 , A.ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      		                 -- Pack_EOH(Avail.+Intran.)                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      		                 , (CASE WHEN A.PLAN_DATE = '''+ @p_curr_date +''' THEN (A.AVAIL_QTY + A.INTRANSIT - A.S_QTY + A.P_QTY) ELSE (0 - A.S_QTY + A.P_QTY) END) AS EOH_QTY -- 시업시간 포함 현재날짜                     ' + char(10)
		SELECT @v_dSql += N'      					      FROM (                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      					                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'      					                     , A.ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      					                     , SUM(S_QTY) AS S_QTY                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      					                     , SUM(P_QTY) AS P_QTY                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      					                     , MAX(BOH_QTY) AS BOH_QTY                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      					                     , MAX(AVAIL_QTY) AS AVAIL_QTY                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      					                     , MAX(HOLD_QTY) AS HOLD_QTY                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      					                     , MAX(INTRANSIT) AS INTRANSIT                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      					                FROM (                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'        					                		-- S : P(CMA)                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'        											        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'                                            , NULL AS ITEM_ID, A.CELL_ITEM_ID                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'                                            , A.PLAN_DATE                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'                                            , A.QTY AS S_QTY                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'                                            , 0 AS P_QTY                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'                                            , 0 AS BOH_QTY                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'                                            , 0 AS AVAIL_QTY                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'                                            , 0 AS HOLD_QTY                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'                                            , 0 AS INTRANSIT                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'        					                		FROM   #REQUEST_P_CMA A                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'                											WHERE  1=1                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'                											-- P : R(Cell Req.)                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'      						                    UNION ALL                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      						                    SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID AS FACTORY_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'        							                      , NULL AS ITEM_ID, A.ITEM_ID AS CELL_ITEM_ID                                                                                                              ' + char(10)
		SELECT @v_dSql += N'        							                      , CONVERT(VARCHAR, A.PLAN_DATE,112) AS PLAN_DATE                                                                                                          ' + char(10)
		SELECT @v_dSql += N'        							                      , 0 AS S_QTY                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'        							                      , SUM(A.QTY) AS P_QTY                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'        							                      , 0 AS BOH_QTY                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'        							                      , 0 AS AVAIL_QTY                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'        							                      , 0 AS HOLD_QTY                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'        							                      , 0 AS INTRANSIT                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'                											FROM  FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                ' + char(10)
		SELECT @v_dSql += N'                								      WHERE 1=1                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'                								      AND   A.QTY > 0                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'                											AND   A.CATEGORY = ''REQUEST''                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'                											AND   A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                                     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_pack_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_FACTORY_ID' , 'EQ', @p_pack_factory_id)) + char(10)
		SELECT @v_dSql += N'        						                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'        					                         	 , A.ITEM_ID, CONVERT(VARCHAR, A.PLAN_DATE,112)                                                                                                             ' + char(10)
		SELECT @v_dSql += N'                											-- BOH : AVAIL_QTY, INTRANSIT                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'                											UNION ALL                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'        						                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID AS FACTORY_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'        												           , NULL AS ITEM_ID, A.ITEM_ID AS CELL_ITEM_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'        							                     , '''+ @p_curr_date +''' AS PLAN_DATE -- 계획일자                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'        							                     , 0 AS S_QTY                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'        							                     , 0 AS P_QTY                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'        							                     , ISNULL(B.TOTAL_QTY,0) AS BOH_QTY                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'        							                     , ISNULL(B.AVAIL_QTY,0) AS AVAIL_QTY                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'        							                     , ISNULL(B.HOLD_QTY,0) AS HOLD_QTY                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'        							                     , ISNULL(B.INTRANSIT,0) AS INTRANSIT                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'        						                  FROM (                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'        						                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID AS PACK_FACTORY_ID, A.CELL_ITEM_ID AS ITEM_ID                                ' + char(10)
		SELECT @v_dSql += N'        						                      FROM   #REQUEST_P_CMA A                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'        						                      WHERE  1=1                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'        						                      UNION ALL                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'        						                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID, A.ITEM_ID                                                              ' + char(10)
		SELECT @v_dSql += N'        						                      FROM   FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'        						                      WHERE  1=1                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'              								            AND    A.QTY > 0                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'              								            AND    A.CATEGORY = ''REQUEST''                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'            						                  AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_pack_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_FACTORY_ID' , 'EQ', @p_pack_factory_id)) + char(10)
		SELECT @v_dSql += N'        						                  ) A                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'        						                  LEFT OUTER HASH JOIN (                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'                    												SELECT *                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'                    												FROM   #STOCK_T A                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'                    												WHERE  A.STOCK_TYPE = ''PACK''                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'        						                  ) B                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'                											ON  A.COMPANY_ID   = B.COMPANY_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'                											AND A.DIVISION_ID  = B.DIVISION_ID                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'                											AND A.SITE_ID      = B.SITE_ID                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'                											AND A.PLANT_ID     = B.PLANT_ID                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'                											AND A.PACK_FACTORY_ID = B.FACTORY_ID                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'                											AND A.ITEM_ID      = B.ITEM_ID                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'          								            WHERE 1=1                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'        						                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID, A.ITEM_ID                                                                         ' + char(10)
		SELECT @v_dSql += N'        												             , ISNULL(B.TOTAL_QTY,0), ISNULL(B.AVAIL_QTY,0), ISNULL(B.HOLD_QTY,0), ISNULL(B.INTRANSIT,0)                                                    ' + char(10)
		SELECT @v_dSql += N'      				                ) A                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      				                WHERE 1=1                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ITEM_ID' , 'LIKE', @p_cell_code)) + char(10)
		SELECT @v_dSql += N'      				                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE                                                               ' + char(10)
		SELECT @v_dSql += N'      				    ) A                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      			) A                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      			INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      			AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      			AND A.SITE_ID     = B.SITE_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      			AND A.CELL_ITEM_ID = B.ITEM_ID                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      			AND B.ACTIVE_FLAG = ''Y''                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			ON  A.PLAN_DATE   = C.YYYYMMDD                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      			INNER JOIN (                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'      					SELECT ''REQUEST_I'' AS CATEGORY_ID, ''Pack_EOH(Avail.+Intran.)'' AS CATEGORY_NAME, ''REQUEST'' AS CATEGORY_TYPE, 10000 AS CATEGORY_ORDER                                                   ' + char(10)
		SELECT @v_dSql += N'      			) D                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      			ON 1=1                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	    WHERE 1=1                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'      	    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, a.factory_id                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'                   , A.CELL_ITEM_ID, ISNULL(B.NICK_NAME,''-'')                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'                   , D.CATEGORY_ID, D.CATEGORY_NAME, D.CATEGORY_TYPE, D.CATEGORY_ORDER                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      )                                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      , MAIN_MOVING_S AS (                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_FACTORY_ID, A.PACK_FACTORY_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS ITEM_ID, NULL AS NICK_NAME                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      		 , A.ITEM_ID AS CELL_ITEM_ID, ISNULL(C.NICK_NAME,''-'') AS CELL_NICK_NAME                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS BOH_QTY                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS INTRANSIT                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS BOM_RATE                                                                                                                                                                                     ' + char(10)
		
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
					
					SELECT @v_dSql += N'      			, SUM(CASE WHEN E.YYYYMM = ''' + @sub_param_0 + ''' THEN (CASE WHEN F.CATEGORY_ID = ''MOVING_S'' THEN A.QTY WHEN F.CATEGORY_ID = ''MOVING_S_SHIP'' THEN A.SHIP_QTY ELSE 0 END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE WHEN E.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN (CASE WHEN F.CATEGORY_ID = ''MOVING_S'' THEN A.QTY WHEN F.CATEGORY_ID = ''MOVING_S_SHIP'' THEN A.SHIP_QTY ELSE 0 END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' THEN (CASE WHEN F.CATEGORY_ID = ''MOVING_S'' THEN A.QTY WHEN F.CATEGORY_ID = ''MOVING_S_SHIP'' THEN A.SHIP_QTY ELSE 0 END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'      		 , F.CATEGORY_ID, F.CATEGORY_NAME, F.CATEGORY_TYPE, F.CATEGORY_ORDER                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      		 , ''DATA'' AS DATA_TYPE                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      	FROM (                                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      			-- DO(Cell Deli.)                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_FACTORY_ID, A.PACK_FACTORY_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'      				 , A.ITEM_ID, A.PLAN_DATE, A.QTY, 0 AS SHIP_QTY                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      			FROM (                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      					-- DO(Cell Deli.)                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_FACTORY_ID, A.PACK_FACTORY_ID                                                                                             ' + char(10)
		SELECT @v_dSql += N'      					   	 , A.ITEM_ID , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.QTY                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'      					FROM  FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      					WHERE 1=1                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      					AND   A.QTY > 0                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      					AND   A.CATEGORY = ''MOVING''                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      					AND   A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                                                                         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_FACTORY_ID' , 'EQ', @p_cell_factory_id)) + char(10)
		SELECT @v_dSql += N'      			) A                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      			WHERE 1=1                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			-- Ship Result                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      			UNION ALL                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      				 , CASE WHEN A.STORAGE_ID = ''210P'' THEN ''A5''                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      						WHEN A.STORAGE_ID = ''220P'' THEN ''A6''                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      						ELSE ''-''                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      				   END AS CELL_FACTORY_ID                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      				 , CASE WHEN A.STORAGE_ID = ''210P'' THEN ''P7''                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      						WHEN A.STORAGE_ID = ''220P'' THEN ''P8''                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      						WHEN A.STORAGE_ID = ''230P'' THEN ''PA''                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      						ELSE ''-'' END AS PACK_FACTORY_ID                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      				 , A.ITEM_ID, A.SHIP_YYYYMMDD AS PLAN_DATE                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      				 , 0 AS QTY, A.QTY AS SHIP_QTY                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      			FROM  SCM_FCS_SHIP_V A WITH(NOLOCK)                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      			WHERE 1=1                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += N'      			AND   A.BIZ_TYPE = ''P''                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      			AND   A.SHIP_YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      			AND   ISNULL(A.QTY,0) > 0                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	) A                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      	INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	ON  A.COMPANY_ID  = C.COMPANY_ID                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      	AND A.DIVISION_ID = C.DIVISION_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	AND A.SITE_ID     = C.SITE_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	AND A.ITEM_ID     = C.ITEM_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	AND C.ACTIVE_FLAG = ''Y''                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	INNER HASH JOIN TH_UIS_CAL E WITH(NOLOCK)                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	ON  A.PLAN_DATE   = E.YYYYMMDD                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	INNER JOIN (                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'        		SELECT ''MOVING_S'' AS CATEGORY_ID, ''DO(Cell Deli.)'' AS CATEGORY_NAME, ''MOVING'' AS CATEGORY_TYPE, 200000 AS CATEGORY_ORDER                                                                      ' + char(10)
		SELECT @v_dSql += N'        		UNION ALL                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'        		SELECT ''MOVING_S_SHIP'' AS CATEGORY_ID, ''Ship Result'' AS CATEGORY_NAME, ''MOVING'' AS CATEGORY_TYPE, 200000 AS CATEGORY_ORDER                                                                    ' + char(10)
		SELECT @v_dSql += N'      	) F                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      	ON 1=1                                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      	WHERE 1=1                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_cell_code)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'      	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_FACTORY_ID, A.PACK_FACTORY_ID                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      		   , A.ITEM_ID, ISNULL(C.NICK_NAME,''-'')                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      		   , F.CATEGORY_ID, F.CATEGORY_NAME, F.CATEGORY_TYPE, F.CATEGORY_ORDER                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      )                                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      , MAIN_MOVING_P AS (                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID AS CELL_FACTORY_ID, NULL AS PACK_FACTORY_ID                                                                                         ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS ITEM_ID, NULL AS NICK_NAME, A.ITEM_ID AS CELL_ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS CELL_NICK_NAME                                                                                        ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS BOH_QTY, NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			, E.TOTAL_CELL_QTY, E.AVAIL_CELL_QTY, E.HOLD_CELL_QTY                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      			, E.INTRANSIT AS INTRANSIT                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      			, E.AVAIL_CELL_LONG_QTY, E.HOLD_CELL_LONG_QTY                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS BOM_RATE                                                                                                                                                                                  ' + char(10)
		
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
					
					SELECT @v_dSql += N'      			, SUM(CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

		SELECT @v_dSql += N'      			, ''MOVING_P'' AS CATEGORY_ID, ''P(FORM)'' AS CATEGORY_NAME, ''MOVING'' AS CATEGORY_TYPE, 100000 AS CATEGORY_ORDER, ''DATA'' AS DATA_TYPE                                                           ' + char(10)
		SELECT @v_dSql += N'      	FROM (                                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'						-- 활성화 계획 정보                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'  							 , A.ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                                                             ' + char(10)
		
		IF @p_rel_form = 'Y' BEGIN
			SELECT @v_dSql += N'  							   , SUM(A.PLAN_QTY) AS QT                                                                                                                                                            ' + char(10)
			SELECT @v_dSql += N'  					    FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                                                                                                                     ' + char(10)
			SELECT @v_dSql += N'  					    WHERE 1=1                                                                                                                                                                             ' + char(10)
			SELECT @v_dSql += N'  					    AND   A.PLAN_QTY > 0                                                                                                                                                                  ' + char(10)
			SELECT @v_dSql += N'  					    AND	  A.PLAN_TYPE = ''RELEASE''                                                                                                                                                       ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql += N'  					      , SUM(A.OUT_QTY) AS QT                                                                                                                                                             ' + char(10)
			SELECT @v_dSql += N'  					    FROM   FP_AMEND_PLAN_FORM_R A WITH(NOLOCK)                                                                                                                                            ' + char(10)
			SELECT @v_dSql += N'  					    WHERE 1=1                                                                                                                                                                             ' + char(10)
			SELECT @v_dSql += N'  					    AND   A.INSTANCE_ID = '''+ @p_form_instance_id +'''                                                                                                                              ' + char(10)
			SELECT @v_dSql += N'  					    AND   A.FP_PLAN_ID = '''+ @p_form_plan_id +'''                                                                                                                                   ' + char(10)
			SELECT @v_dSql += N'  					    AND   A.OUT_QTY > 0                                                                                                                                                                   ' + char(10)
		END

		SELECT @v_dSql += N'						AND   A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                                 ' + char(10)
		SELECT @v_dSql += N'						AND   A.OPERATION_ID = ''F6000''                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_cell_factory_id)) + char(10)
		SELECT @v_dSql += N'						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'							     , A.ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112)                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      	) A                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      	INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	ON  A.COMPANY_ID  = B.COMPANY_ID                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      	AND A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	AND A.SITE_ID     = B.SITE_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	AND A.ITEM_ID     = B.ITEM_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	AND B.ACTIVE_FLAG = ''Y''                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	ON  A.PLAN_DATE   = C.YYYYMMDD                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	LEFT OUTER HASH JOIN (                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'        		SELECT * FROM #STOCK_T A                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'        		WHERE 1=1                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'        		AND	  STOCK_TYPE = ''CELL''                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      	) E                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      	ON  A.COMPANY_ID   = E.COMPANY_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	AND A.DIVISION_ID  = E.DIVISION_ID                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      	AND A.SITE_ID      = E.SITE_ID                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	AND A.PLANT_ID     = E.PLANT_ID                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      	AND A.FACTORY_ID   = E.FACTORY_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	AND A.ITEM_ID      = E.ITEM_ID                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	WHERE 1=1                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_cell_code)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'      	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      		     , A.ITEM_ID, ISNULL(B.NICK_NAME,''-'')                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      		     , E.TOTAL_CELL_QTY, E.AVAIL_CELL_QTY, E.HOLD_CELL_QTY, E.INTRANSIT                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      		     , E.AVAIL_CELL_LONG_QTY, E.HOLD_CELL_LONG_QTY                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      )                                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      , MAIN_MOVING_I AS (                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID AS CELL_FACTORY_ID, NULL AS PACK_FACTORY_ID                                                                                         ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS ITEM_ID, NULL AS NICK_NAME, A.ITEM_ID AS CELL_ITEM_ID, ISNULL(C.NICK_NAME,''-'') AS CELL_NICK_NAME                                                                                        ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS BOH_QTY, NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS TOTAL_CELL_QTY                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS AVAIL_CELL_QTY                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS HOLD_CELL_QTY                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS INTRANSIT                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS BOM_RATE                                                                                                                                                                                  ' + char(10)
		
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

					SELECT @v_dSql += N'                , SUM(CASE	WHEN A.PLAN_DATE <= ''' + @sub_param_0 + ''' AND A.PLAN_DATE >= '''+ @p_curr_date +''' THEN A.EOH_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql += N'      			, ''MOVING_I'' AS CATEGORY_ID, ''Form_EOH(Avail.)'' AS CATEGORY_NAME, ''MOVING'' AS CATEGORY_TYPE, 400000 AS CATEGORY_ORDER                                                                         ' + char(10)
		SELECT @v_dSql += N'      			, ''DATA'' AS DATA_TYPE                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      	FROM (                                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      				   , A.ITEM_ID, A.PLAN_DATE                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'      				   , A.AVAIL_QTY, A.P_FORM_QTY, A.DO_QTY                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'      				   , (CASE WHEN A.PLAN_DATE = '''+ @p_curr_date +''' THEN A.AVAIL_QTY + A.P_FORM_QTY - A.DO_QTY ELSE 0 + A.P_FORM_QTY - A.DO_QTY END) AS EOH_QTY                                                           ' + char(10)
		SELECT @v_dSql += N'      			FROM  (                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      				-- P : P(FORM)                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      					   , A.ITEM_ID                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      					   --, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'      					   , CONVERT(VARCHAR, A.PLAN_DATE+(CASE WHEN ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) IS NULL OR ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) = 0 THEN 1 ELSE ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) END), 112) AS PLAN_DATE	' + char(10)
		SELECT @v_dSql += N'      					   , A.QTY AS P_FORM_QTY, 0 AS DO_QTY, 0 AS AVAIL_QTY                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      				FROM (                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      						-- 활성화 계획 정보                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'      						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      							   , A.ITEM_ID, A.PLAN_DATE                                                                                                                                                         ' + char(10)
		
		IF @p_rel_form = 'Y' BEGIN
			SELECT @v_dSql += N'            				  , SUM(A.PLAN_QTY) AS QT                                                                                                                                                ' + char(10)
			SELECT @v_dSql += N'            				FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                                                                                                         ' + char(10)
			SELECT @v_dSql += N'            				WHERE 1=1                                                                                                                                                                 ' + char(10)
			SELECT @v_dSql += N'            				AND   A.PLAN_QTY > 0                                                                                                                                                      ' + char(10)
			SELECT @v_dSql += N'            				AND	  A.PLAN_TYPE = ''RELEASE''                                                                                                                                           ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql += N'  							  , SUM(A.OUT_QTY) AS QT                                                                                                                                                             ' + char(10)
			SELECT @v_dSql += N'  							FROM   FP_AMEND_PLAN_FORM_R A WITH(NOLOCK)                                                                                                                                            ' + char(10)
			SELECT @v_dSql += N'  							WHERE 1=1                                                                                                                                                                             ' + char(10)
			SELECT @v_dSql += N'  							AND   A.INSTANCE_ID = '''+ @p_form_instance_id +'''                                                                                                                              ' + char(10)
			SELECT @v_dSql += N'  							AND   A.FP_PLAN_ID = '''+ @p_form_plan_id +'''                                                                                                                                   ' + char(10)
			SELECT @v_dSql += N'  							AND   A.OUT_QTY > 0                                                                                                                                                                   ' + char(10)
		END

		SELECT @v_dSql += N'      						AND   A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                             ' + char(10)
		SELECT @v_dSql += N'      						AND   A.OPERATION_ID = ''F6000''                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_cell_factory_id)) + char(10)
		SELECT @v_dSql += N'      						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      							   	 , A.ITEM_ID, A.PLAN_DATE                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      				) A                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'							-- operation bod                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'							LEFT OUTER JOIN (                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'          							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ''-'' AS ITEM_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'          								--, BB.BUFFER_TIME, ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') AS BUFFER_TIME_UOM                                                                                                ' + char(10)
		SELECT @v_dSql += N'          								, MAX(CASE WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''MINUTE'' THEN CEILING(ISNULL(BB.BUFFER_TIME,0)/1440)                                                              ' + char(10)
		SELECT @v_dSql += N'              									WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''HOUR''   THEN CEILING(ISNULL(BB.BUFFER_TIME,0)/24)                                                                   ' + char(10)
		SELECT @v_dSql += N'              									WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''DAY''    THEN CEILING(ISNULL(BB.BUFFER_TIME,0))                                                                      ' + char(10)
		SELECT @v_dSql += N'              									END)  MOVING_TIME_DAY                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'          							FROM  SCM_OPERATION_MOVE_2_V A WITH(NOLOCK)                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'          							LEFT OUTER JOIN SCM_OPERATION_MOVE_M BB WITH(NOLOCK)                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'          							ON    A.COMPANY_ID    = BB.COMPANY_ID                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'          							AND   A.DIVISION_ID   = BB.DIVISION_ID                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'          							AND   A.SITE_ID       = BB.SITE_ID                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'          							AND   A.PLANT_ID      = BB.PLANT_ID                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'          							AND   A.FACTORY_ID    = BB.FACTORY_ID                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'          							AND   A.OPERATION_ID  = BB.OPERATION_ID                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'          							AND   A.MODEL_TYPE    = BB.MODEL_TYPE                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'          							AND   A.LINE_ATTR_1   = BB.LINE_ATTR_1                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'          							AND   ISNULL(BB.ACTIVE_FLAG, ''Y'') = ''Y''                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'          							WHERE 1=1                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += N'                        AND   A.OPERATION_ID = ''F6000''                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'                        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'							) B                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'							ON     A.COMPANY_ID   = B.COMPANY_ID                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'							AND    A.DIVISION_ID  = B.DIVISION_ID                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'							AND    A.SITE_ID      = B.SITE_ID                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'							AND    A.PLANT_ID     = B.PLANT_ID                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'							-- item-operation bod                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'							LEFT OUTER JOIN (                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'            						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                            ' + char(10)
		SELECT @v_dSql += N'            									--, A.BUFFER_TIME, A.BUFFER_TIME_UOM                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'            									, MAX(CASE WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''MINUTE'' THEN CEILING(ISNULL(A.BUFFER_TIME,0)/1440)                                                        ' + char(10)
		SELECT @v_dSql += N'            										   WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''HOUR''   THEN CEILING(ISNULL(A.BUFFER_TIME,0)/24)                                                              ' + char(10)
		SELECT @v_dSql += N'            										   WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''DAY''    THEN CEILING(ISNULL(A.BUFFER_TIME,0))                                                                 ' + char(10)
		SELECT @v_dSql += N'            										   END) MOVING_TIME_DAY                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'            						FROM   SCM_ITEM_FLOW_EXCEPT_M A WITH(NOLOCK)                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'          							INNER JOIN SCM_OPERATION_MOVE_2_V BB WITH(NOLOCK)                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'          							ON    A.COMPANY_ID    = BB.COMPANY_ID                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'          							AND   A.DIVISION_ID   = BB.DIVISION_ID                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'          							AND   A.SITE_ID       = BB.SITE_ID                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'          							AND   A.PLANT_ID      = BB.PLANT_ID                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'          							AND   A.FACTORY_ID    = BB.FACTORY_ID                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'          							AND   A.OPERATION_ID  = BB.OPERATION_ID                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'          							AND   A.MODEL_TYPE    = BB.MODEL_TYPE                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'          							AND   A.LINE_ATTR_1   = BB.LINE_ATTR_1                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'            						WHERE 1=1                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += N'                        AND   A.OPERATION_ID = ''F6000''                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'                        AND   A.ACTIVE_FLAG = ''Y''                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'                        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'							) C                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'							ON     A.COMPANY_ID   = C.COMPANY_ID                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'							AND    A.DIVISION_ID  = C.DIVISION_ID                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'							AND    A.SITE_ID      = C.SITE_ID                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'							AND    A.PLANT_ID     = C.PLANT_ID                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'							AND    A.ITEM_ID      = C.ITEM_ID                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      				WHERE 1=1                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      				-- S : DO(Cell Deli.)                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      				UNION ALL                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_FACTORY_ID AS FACTORY_ID                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      					   , A.ITEM_ID, A.PLAN_DATE                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      					   , 0 AS P_FORM_QTY, SUM(A.QTY) AS DO_QTY, 0 AS AVAIL_QTY                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      				FROM (                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      						-- DO(Cell Deli.)                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_FACTORY_ID, A.PACK_FACTORY_ID                                                                                         ' + char(10)
		SELECT @v_dSql += N'      							 , A.ITEM_ID , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.QTY                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      						FROM  FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      						WHERE 1=1                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      						AND   A.QTY > 0                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      						AND   A.CATEGORY = ''MOVING''                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      						AND   A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                                                                     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_cell_factory_id)) + char(10)
		SELECT @v_dSql += N'      				) A                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_FACTORY_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      					     , A.ITEM_ID, A.PLAN_DATE                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      				-- I : Form_EOH(Avail.)                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      				UNION ALL                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      					 , A.ITEM_ID, '''+ @p_curr_date +''' AS PLAN_DATE                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      					 , 0 AS P_FORM_QTY, 0 AS DO_QTY, ISNULL(E.AVAIL_CELL_QTY,0) AS AVAIL_QTY                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      				FROM (                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      						SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                             ' + char(10)
		
		IF @p_rel_form = 'Y' BEGIN
			SELECT @v_dSql += N'      						    FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                                                                                                              ' + char(10)
			SELECT @v_dSql += N'      						    WHERE  1=1                                                                                                                                                                    ' + char(10)
			SELECT @v_dSql += N'      						    AND    A.PLAN_QTY > 0                                                                                                                                                         ' + char(10)
			SELECT @v_dSql += N'      						    AND	   A.PLAN_TYPE = ''RELEASE''                                                                                                                                              ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql += N'  							FROM   FP_AMEND_PLAN_FORM_R A WITH(NOLOCK)                                                                                                                                            ' + char(10)
			SELECT @v_dSql += N'  							WHERE 1=1                                                                                                                                                                             ' + char(10)
			SELECT @v_dSql += N'  							AND   A.INSTANCE_ID = '''+ @p_form_instance_id +'''                                                                                                                              ' + char(10)
			SELECT @v_dSql += N'  							AND   A.FP_PLAN_ID = '''+ @p_form_plan_id +'''                                                                                                                                   ' + char(10)
			SELECT @v_dSql += N'  							AND   A.OUT_QTY > 0                                                                                                                                                                   ' + char(10)
		END

		SELECT @v_dSql += N'      						AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                            ' + char(10)
		SELECT @v_dSql += N'      						AND    A.OPERATION_ID = ''F6000''                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_cell_factory_id)) + char(10)
		SELECT @v_dSql += N'      						UNION                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      						SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_FACTORY_ID AS FACTORY_ID, A.ITEM_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'      						FROM   FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      						WHERE  1=1                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      						AND    A.QTY > 0                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'      						AND    A.CATEGORY = ''MOVING''                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      						AND    A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                                                                    ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_FACTORY_ID' , 'EQ', @p_cell_factory_id)) + char(10)
		SELECT @v_dSql += N'      				) A                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      				LEFT OUTER HASH JOIN (                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'        					SELECT * FROM #STOCK_T A                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'        					WHERE 1=1                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'        					AND	  STOCK_TYPE = ''CELL''                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      				) E                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      				ON  A.COMPANY_ID   = E.COMPANY_ID                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      				AND A.DIVISION_ID  = E.DIVISION_ID                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      				AND A.SITE_ID      = E.SITE_ID                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      				AND A.PLANT_ID     = E.PLANT_ID                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      				AND A.FACTORY_ID   = E.FACTORY_ID                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      				AND A.ITEM_ID      = E.ITEM_ID                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      			) A                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      	) A                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      	INNER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'      	ON  A.COMPANY_ID  = C.COMPANY_ID                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      	AND A.DIVISION_ID = C.DIVISION_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	AND A.SITE_ID     = C.SITE_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	AND A.ITEM_ID     = C.ITEM_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	AND C.ACTIVE_FLAG = ''Y''                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	WHERE 1=1                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_cell_code)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'      	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	  	   , A.ITEM_ID, ISNULL(C.NICK_NAME,''-'')                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      )                                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      SELECT A.*                                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'           , J.CELL_GROUP                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'           , DENSE_RANK() OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_ITEM_ID ) AS LV1                                                                                                ' + char(10)
		SELECT @v_dSql += N'           , (CASE WHEN A.CATEGORY_ID = ''REQUEST_P'' AND R.PLANT_ID IS NOT NULL THEN ''Y''                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'	                 WHEN A.CATEGORY_ID = ''MOVING_S'' AND R2.PLANT_ID IS NOT NULL THEN ''Y''                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	                 ELSE ''N'' END) AS EDIT_YN                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'      FROM (                                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'      	-- request                                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      	SELECT * FROM MAIN_REQUEST_S A                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	UNION ALL                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	SELECT * FROM MAIN_REQUEST_P A                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	UNION ALL                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	SELECT * FROM MAIN_REQUEST_I A                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	-- moving                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	UNION ALL                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	SELECT * FROM MAIN_MOVING_P A                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	UNION ALL                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	SELECT * FROM MAIN_MOVING_S A                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	UNION ALL                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	SELECT * FROM MAIN_MOVING_I A                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	-- TOTAL 영역                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	UNION ALL                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	-- R(Cell Req.)                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, NULL AS CELL_FACTORY_ID, NULL AS PACK_FACTORY_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS ITEM_ID, NULL AS NICK_NAME, A.ITEM_ID AS CELL_ITEM_ID, ISNULL(C.NICK_NAME,''-'') AS CELL_NICK_NAME                                                                                           ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS BOH_QTY                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS INTRANSIT                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      		 , NULL AS BOM_RATE                                                                                                                                                                                     ' + char(10)
		
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
					
					SELECT @v_dSql += N'      			, SUM(CASE WHEN E.YYYYMM = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE WHEN E.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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
		
		SELECT @v_dSql += N'      		 , ''TOTAL_R_CELL_REQ'' AS CATEGORY_ID, ''R(Cell Req.)'' AS CATEGORY_NAME, ''TOTAL'' AS CATEGORY_TYPE, 1000000 AS CATEGORY_ORDER                                                                        ' + char(10)
		SELECT @v_dSql += N'      		 , ''TOTAL'' AS DATA_TYPE                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	FROM  FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      	INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	ON  A.COMPANY_ID  = C.COMPANY_ID                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      	AND A.DIVISION_ID = C.DIVISION_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	AND A.SITE_ID     = C.SITE_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	AND A.ITEM_ID     = C.ITEM_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	AND C.ACTIVE_FLAG = ''Y''                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	INNER HASH JOIN TH_UIS_CAL E WITH(NOLOCK)                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	ON  A.PLAN_DATE   = E.YYYYMMDD                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	WHERE 1=1                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	AND   A.QTY > 0                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      	AND   A.CATEGORY = ''REQUEST''                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	AND   A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                                                                                         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_pack_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_FACTORY_ID' , 'EQ', @p_pack_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_cell_code)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'      	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, ISNULL(C.NICK_NAME,''-'')                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	UNION ALL                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	-- DO(Cell Deli.)                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, NULL AS CELL_FACTORY_ID, NULL AS PACK_FACTORY_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS ITEM_ID, NULL AS NICK_NAME                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      			, A.ITEM_ID AS CELL_ITEM_ID, ISNULL(C.NICK_NAME,''-'') AS CELL_NICK_NAME                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS BOH_QTY                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      			, ISNULL(F.TOTAL_CELL_QTY,0) AS TOTAL_CELL_QTY, ISNULL(F.AVAIL_CELL_QTY,0) AS AVAIL_CELL_QTY, ISNULL(F.HOLD_CELL_QTY,0) AS HOLD_CELL_QTY                                                            ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS INTRANSIT                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      			, ISNULL(F.AVAIL_CELL_LONG_QTY,0) AS AVAIL_CELL_LONG_QTY, ISNULL(F.HOLD_CELL_LONG_QTY,0) AS HOLD_CELL_LONG_QTY                                                                                      ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS BOM_RATE                                                                                                                                                                                  ' + char(10)
		
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
					
					SELECT @v_dSql += N'      			, SUM(CASE WHEN E.YYYYMM = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE WHEN E.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

		SELECT @v_dSql += N'      			, ''TOTAL_DO_CELL_DELI'' AS CATEGORY_ID, ''DO(Cell Deli.)'' AS CATEGORY_NAME, ''TOTAL'' AS CATEGORY_TYPE, 2000000 AS CATEGORY_ORDER                                                                 ' + char(10)
		SELECT @v_dSql += N'      			, ''TOTAL'' AS DATA_TYPE                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      	FROM (                                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'  					-- DO(Cell Deli.)                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'  					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_FACTORY_ID, A.PACK_FACTORY_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'  						   , A.ITEM_ID , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.QTY                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'  					FROM  FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'  					WHERE 1=1                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'  					AND   A.QTY > 0                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'  					AND   A.CATEGORY = ''MOVING''                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'  					AND   A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                                                                             ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_FACTORY_ID' , 'EQ', @p_cell_factory_id)) + char(10)
		SELECT @v_dSql += N'      	) A                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      	INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	ON  A.COMPANY_ID  = C.COMPANY_ID                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      	AND A.DIVISION_ID = C.DIVISION_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	AND A.SITE_ID     = C.SITE_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	AND A.ITEM_ID     = C.ITEM_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	AND C.ACTIVE_FLAG = ''Y''                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	INNER HASH JOIN TH_UIS_CAL E WITH(NOLOCK)                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	ON  A.PLAN_DATE   = E.YYYYMMDD                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	LEFT OUTER HASH JOIN (                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'        		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'        			   , SUM(A.TOTAL_CELL_QTY) AS TOTAL_CELL_QTY, SUM(A.AVAIL_CELL_QTY) AS AVAIL_CELL_QTY, SUM(A.HOLD_CELL_QTY) AS HOLD_CELL_QTY                                                                    ' + char(10)
		SELECT @v_dSql += N'        			   , SUM(A.AVAIL_CELL_LONG_QTY) AS AVAIL_CELL_LONG_QTY                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'        			   , SUM(A.HOLD_CELL_LONG_QTY) AS HOLD_CELL_LONG_QTY                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'        		FROM   #STOCK_T A                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'        		-- 기준 테이블에 존재하는 재고정보만 조회                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'        		, (                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      					SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_FACTORY_ID, A.ITEM_ID                                                                                            ' + char(10)
		SELECT @v_dSql += N'      					FROM  FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      					WHERE 1=1                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      					AND   A.QTY > 0                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      					AND   A.CATEGORY = ''MOVING''                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      					AND   A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                                                                         ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_FACTORY_ID' , 'EQ', @p_cell_factory_id)) + char(10)
		SELECT @v_dSql += N'        		) B                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'        		WHERE  1=1                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'        		AND    A.COMPANY_ID  = B.COMPANY_ID                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'        		AND    A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'        		AND    A.SITE_ID     = B.SITE_ID                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'        		AND    A.PLANT_ID    = B.PLANT_ID                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'        		AND    A.FACTORY_ID  = B.CELL_FACTORY_ID                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'        		AND    A.ITEM_ID     = B.ITEM_ID                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'        		AND	   A.STOCK_TYPE  = ''CELL''                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'        		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	) F                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      	ON  A.COMPANY_ID   = F.COMPANY_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	AND A.DIVISION_ID  = F.DIVISION_ID                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      	AND A.SITE_ID      = F.SITE_ID                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	AND A.PLANT_ID     = F.PLANT_ID                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      	--AND A.CELL_FACTORY_ID = F.FACTORY_ID                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      	AND A.ITEM_ID      = F.ITEM_ID                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	WHERE 1=1                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_cell_code)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'      	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      		   , A.ITEM_ID, ISNULL(C.NICK_NAME,''-'')                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      		   , ISNULL(F.TOTAL_CELL_QTY,0), ISNULL(F.AVAIL_CELL_QTY,0), ISNULL(F.HOLD_CELL_QTY,0)                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      		   , ISNULL(F.AVAIL_CELL_LONG_QTY,0), ISNULL(F.HOLD_CELL_LONG_QTY,0)                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      	UNION ALL                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	-- Meet Qty                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, NULL AS CELL_FACTORY_ID, A.PACK_FACTORY_ID                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS ITEM_ID, NULL AS NICK_NAME                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      			, A.ITEM_ID AS CELL_ITEM_ID, ISNULL(C.NICK_NAME,''-'') AS CELL_NICK_NAME                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS BOH_QTY                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS INTRANSIT                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			, NULL AS BOM_RATE                                                                                                                                                                                  ' + char(10)
		
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
					
					SELECT @v_dSql += N'      			, SUM(CASE WHEN E.YYYYMM = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE WHEN E.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN A.QTY ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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
		
		SELECT @v_dSql += N'      			, ''TOTAL_MEET_QTY'' AS CATEGORY_ID, ''Meet QTY'' AS CATEGORY_NAME, ''TOTAL'' AS CATEGORY_TYPE, 3000000 AS CATEGORY_ORDER                                                                           ' + char(10)
		SELECT @v_dSql += N'      			, ''TOTAL'' AS DATA_TYPE                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      	FROM (                                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID, A.ITEM_ID, A.PLAN_DATE                                                                                                ' + char(10)
		SELECT @v_dSql += N'      				 , SUM(ISNULL(A.DO_QTY,0) - ISNULL(A.R_QTY,0)) AS QTY                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      			FROM (                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      				--R(Cell Req.)                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      					   , A.ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, SUM(A.QTY) AS R_QTY, 0 AS DO_QTY                                                                                             ' + char(10)
		SELECT @v_dSql += N'      				FROM  FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'      				WHERE 1=1                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      				AND   A.QTY > 0                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      				AND   A.CATEGORY = ''REQUEST''                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      				AND   A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                                                                             ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_pack_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_FACTORY_ID' , 'EQ', @p_pack_factory_id)) + char(10)
		SELECT @v_dSql += N'      				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      					     , A.ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112)                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      				UNION ALL                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      				-- DO(Cell Deli.)                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      					   , A.ITEM_ID, A.PLAN_DATE, 0 AS R_QTY, SUM(A.QTY) AS DO_QTY                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      				FROM (                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_FACTORY_ID, A.PACK_FACTORY_ID                                                                                         ' + char(10)
		SELECT @v_dSql += N'      							   , A.ITEM_ID , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.QTY                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      						FROM  FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      						WHERE 1=1                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      						AND   A.QTY > 0                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      						AND   A.CATEGORY = ''MOVING''                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      						AND   A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                                                                     ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_FACTORY_ID' , 'EQ', @p_cell_factory_id)) + char(10)
		SELECT @v_dSql += N'      				) A                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      				WHERE 1=1                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'      				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      					   , A.ITEM_ID, A.PLAN_DATE                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      			) A                                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID, A.ITEM_ID, A.PLAN_DATE                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	) A                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      	INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	ON  A.COMPANY_ID  = C.COMPANY_ID                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      	AND A.DIVISION_ID = C.DIVISION_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	AND A.SITE_ID     = C.SITE_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	AND A.ITEM_ID     = C.ITEM_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      	AND C.ACTIVE_FLAG = ''Y''                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	INNER HASH JOIN TH_UIS_CAL E WITH(NOLOCK)                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	ON  A.PLAN_DATE   = E.YYYYMMDD                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	WHERE 1=1                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_cell_code)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'      	GROUP BY  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PACK_FACTORY_ID                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      			, A.ITEM_ID, ISNULL(C.NICK_NAME,''-'')                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	UNION ALL                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	-- Form_EOH(Avail.) : 대상 품번만 조회하고 실계산은 ui에서 처리.... 조회시간 감당이 안됨                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'      	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, NULL AS CELL_FACTORY_ID, NULL AS PACK_FACTORY_ID, NULL AS ITEM_ID, NULL AS NICK_NAME                                                    ' + char(10)
		SELECT @v_dSql += N'      		, A.CELL_ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS CELL_NICK_NAME                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      		, NULL AS BOH_QTY, NULL AS TOTAL_QTY, NULL AS AVAIL_QTY, NULL AS HOLD_QTY                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      		, NULL AS TOTAL_CELL_QTY, NULL AS AVAIL_CELL_QTY, NULL AS HOLD_CELL_QTY, NULL AS INTRANSIT                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      		, NULL AS AVAIL_CELL_LONG_QTY, NULL AS HOLD_CELL_LONG_QTY                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      		, NULL AS BOM_RATE                                                                                                                                                                                      ' + char(10)
		
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

					SELECT @v_dSql += N'                , 0 AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , 0 AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql += N'      		, ''TOTAL_EOH'' AS CATEGORY_ID, ''Form_EOH(Avail.)'' AS CATEGORY_NAME, ''TOTAL'' AS CATEGORY_TYPE, 4000000 AS CATEGORY_ORDER, ''TOTAL'' AS DATA_TYPE                                                    ' + char(10)
		SELECT @v_dSql += N'      	FROM (                                                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'        		-- DO(Cell Deli.)                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'        		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID AS CELL_ITEM_ID                                                                                                       ' + char(10)
		SELECT @v_dSql += N'        		FROM  FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'        		WHERE 1=1                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'        		AND   A.QTY > 0                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'        		AND   A.CATEGORY = ''MOVING''                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'        		AND   A.PLAN_DATE BETWEEN CONVERT(DATE,'''+ @p_bucket_from +''') AND CONVERT(DATE,'''+ @p_bucket_to +''')                                                                                                                 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_pack_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PACK_FACTORY_ID' , 'EQ', @p_pack_factory_id)) + char(10)
		SELECT @v_dSql += N'            -- P(Form)                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'            UNION                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'  					SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID AS CELL_ITEM_ID                                                                                                   ' + char(10)
		
		IF @p_rel_form = 'Y' BEGIN
			SELECT @v_dSql += N'  					    FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                                                                                                                     ' + char(10)
			SELECT @v_dSql += N'  					    WHERE  1=1                                                                                                                                                                            ' + char(10)
			SELECT @v_dSql += N'  					    AND    A.PLAN_QTY > 0                                                                                                                                                                 ' + char(10)
			SELECT @v_dSql += N'  					    AND	   A.PLAN_TYPE = ''RELEASE''                                                                                                                                                      ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql += N'  					    FROM   FP_AMEND_PLAN_FORM_R A WITH(NOLOCK)                                                                                                                                            ' + char(10)
			SELECT @v_dSql += N'  					    WHERE  1=1                                                                                                                                                                            ' + char(10)
			SELECT @v_dSql += N'  					    AND    A.INSTANCE_ID = '''+ @p_form_instance_id +'''                                                                                                                             ' + char(10)
			SELECT @v_dSql += N'  					    AND    A.FP_PLAN_ID = '''+ @p_form_plan_id +'''                                                                                                                                  ' + char(10)
			SELECT @v_dSql += N'  					    AND    A.OUT_QTY > 0                                                                                                                                                                  ' + char(10)
		END

		SELECT @v_dSql += N'  					AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                                    ' + char(10)
		SELECT @v_dSql += N'  					AND    A.OPERATION_ID = ''F6000''                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_cell_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_FACTORY_ID' , 'EQ', @p_cell_factory_id)) + char(10)
		SELECT @v_dSql += N'      	) A                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      	INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'      	ON  A.COMPANY_ID   = B.COMPANY_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      	AND A.DIVISION_ID  = B.DIVISION_ID                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      	AND A.SITE_ID      = B.SITE_ID                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	AND A.CELL_ITEM_ID = B.ITEM_ID                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      	AND B.ACTIVE_FLAG  = ''Y''                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'      	WHERE 1=1                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_cell_code)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'      ) A                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      ON  A.COMPANY_ID   = J.COMPANY_ID                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      AND A.DIVISION_ID  = J.DIVISION_ID                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      AND A.SITE_ID      = J.SITE_ID                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      AND A.CELL_ITEM_ID = J.ITEM_ID                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      LEFT OUTER HASH JOIN (                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'            SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'            FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'            WHERE  1=1                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'            AND	   R.USER_ID   = '''+ @p_user_id +'''                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'            AND	   R.SAVE_FLAG = ''Y''                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'            AND    R.INSTANCE_ID = '''+ @p_pack_instance_id +'''                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      ) R                                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'      ON  A.COMPANY_ID  = R.COMPANY_ID                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'      AND A.DIVISION_ID = R.DIVISION_ID                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      AND A.SITE_ID     = R.SITE_ID                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'      AND A.PLANT_ID    = R.PLANT_ID                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      AND A.PACK_FACTORY_ID = R.FACTORY_ID                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      LEFT OUTER HASH JOIN (                                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'            SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'            FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'            WHERE  1=1                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'            AND	   R.USER_ID   = '''+ @p_user_id +'''                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'            AND	   R.SAVE_FLAG = ''Y''                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'            AND    R.INSTANCE_ID = '''+ @p_form_instance_id +'''                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      ) R2                                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'      ON  A.COMPANY_ID  = R2.COMPANY_ID                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'      AND A.DIVISION_ID = R2.DIVISION_ID                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'      AND A.SITE_ID     = R2.SITE_ID                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'      AND A.PLANT_ID    = R2.PLANT_ID                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'      AND A.CELL_FACTORY_ID = R2.FACTORY_ID                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'      WHERE 1=1                                                                                                                                                                                                     ' + char(10)
		
		IF @p_line_assign = 'Y' BEGIN
			SELECT @v_dSql += N'          AND    EXISTS ( SELECT 1                                                                                                                                                                    ' + char(10)
			SELECT @v_dSql += N'          					FROM  SCM_ITEM_LINE_ASSIGN_M AA WITH(NOLOCK)                                                                                                                              ' + char(10)
			SELECT @v_dSql += N'          					WHERE 1=1                                                                                                                                                                 ' + char(10)
			SELECT @v_dSql += N'          					AND		AA.DIVISION_ID = A.DIVISION_ID                                                                                                                                    ' + char(10)
			SELECT @v_dSql += N'          					AND		AA.SITE_ID     = A.SITE_ID                                                                                                                                        ' + char(10)
			SELECT @v_dSql += N'          					AND		AA.PLANT_ID    = A.PLANT_ID                                                                                                                                       ' + char(10)
			SELECT @v_dSql += N'          					AND		AA.ITEM_ID     = A.CELL_ITEM_ID                                                                                                                                   ' + char(10)
			SELECT @v_dSql += N'          					AND		AA.MONTH       = CONVERT(VARCHAR(6), '''+ @p_plan_date +''')                                                                                                   ' + char(10)
			SELECT @v_dSql += N'          					AND		AA.PRIORITY NOT IN (0,9)                                                                                                                                          ' + char(10)
			SELECT @v_dSql += N'          					AND		AA.ACTIVE_FLAG = ''Y''                                                                                                                                            ' + char(10)
			SELECT @v_dSql += N'          )                                                                                                                                                                                           ' + char(10)
		END
		
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('J.CELL_GROUP' , 'LIKE', @p_cell_group_code)) + char(10)
		SELECT @v_dSql += N'      ORDER BY A.PLANT_ID, J.CELL_GROUP, A.CELL_ITEM_ID                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'             , (CASE WHEN CATEGORY_TYPE = ''REQUEST'' THEN 1 WHEN CATEGORY_TYPE = ''MOVING'' THEN 2 ELSE 999 END)                                                                                                   ' + char(10)
		SELECT @v_dSql += N'             , (CASE WHEN CATEGORY_TYPE = ''REQUEST'' THEN PACK_FACTORY_ID ELSE ''ZZZZZZZZZZZ'' END)                                                                                                                ' + char(10)
		SELECT @v_dSql += N'             , (CASE WHEN CATEGORY_TYPE = ''MOVING'' THEN CELL_FACTORY_ID END)                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'             , (CASE WHEN CATEGORY_TYPE = ''MOVING'' THEN CATEGORY_ORDER END)                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'             , (CASE WHEN CATEGORY_TYPE = ''MOVING'' THEN PACK_FACTORY_ID END)                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'             , (CASE WHEN CATEGORY_ID = ''MOVING_S'' THEN 1 WHEN CATEGORY_ID = ''MOVING_S_SHIP'' THEN 2 END) -- moving - 동일 팩 동의 카테고리 안에서 순서 정리                                                     ' + char(10)
		SELECT @v_dSql += N'             , A.CATEGORY_ORDER                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'             , (CASE WHEN CATEGORY_TYPE = ''TOTAL'' THEN PACK_FACTORY_ID ELSE ''ZZZZZZZZZZZ'' END)                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'             , A.ITEM_ID                                                                                                                                                                                            ' + char(10)
		
		
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
		IF OBJECT_ID( 'tempdb..#STOCK_T' ) IS NOT NULL
		DROP TABLE #STOCK_T
        
		IF OBJECT_ID( 'tempdb..#REQUEST_P_CMA' ) IS NOT NULL
		DROP TABLE #REQUEST_P_CMA
	END
  
END

