

/*
 * Program ID   : PR_UI_FP02841_PLAN_AMEND_ELEC_POST
 * Description  : Plan Amend Elec Post
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/03/10   CYS				Initial Release UI통합
 * 2023/04/18   KCH             SCM_STOCK_H -> SCM_STOCK_H_V 뷰로 변경
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02841_PLAN_AMEND_ELEC_POST]
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

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02841_PLAN_AMEND_ELEC_POST';
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
	DECLARE @p_curr_date	NVARCHAR(MAX);
	DECLARE @p_cate_info	NVARCHAR(MAX);
	DECLARE @p_confirm_area	NVARCHAR(MAX);
	DECLARE @p_plan_type	NVARCHAR(MAX);
	DECLARE @p_uom_type		NVARCHAR(MAX);
	DECLARE @p_elec_type	NVARCHAR(MAX);

	-- week
	DECLARE @p_bucket		NVARCHAR(MAX);
	DECLARE @p_week_info	NVARCHAR(MAX);
	DECLARE @p_month_info	NVARCHAR(MAX);
	
	-- table
	DECLARE @p_amend_table	NVARCHAR(MAX);
	DECLARE @p_amend_sales_table		NVARCHAR(MAX);
	DECLARE @p_amend_cutoff_boh_table	NVARCHAR(MAX);
	DECLARE @p_result_qty	NVARCHAR(MAX);
	
	DECLARE @p_inner_company_id	NVARCHAR(MAX);
	DECLARE @p_inner_division_id	NVARCHAR(MAX);
	DECLARE @p_inner_site_id		NVARCHAR(MAX);
	DECLARE @p_inner_plant_id		NVARCHAR(MAX);
	DECLARE @p_cal_type	NVARCHAR(MAX);
	DECLARE @p_unit		NVARCHAR(MAX);
	DECLARE @p_round_point		NVARCHAR(MAX);

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
		END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
			SET @p_plan_type  =			@tmp_value
		END ELSE IF @tmp_column = 'CONFIRM_AREA' BEGIN
			SET @p_confirm_area  =		@tmp_value
		END ELSE IF @tmp_column = 'CURR_DATE' BEGIN
			SET @p_curr_date =		@tmp_value
		END ELSE IF @tmp_column = 'UOM_TYPE' BEGIN
			SET @p_uom_type =		@tmp_value
		END ELSE IF @tmp_column = 'ELEC_TYPE' BEGIN
			SET @p_elec_type =		@tmp_value
		END ELSE IF @tmp_column = 'UNIT' BEGIN
			SET @p_unit =		@tmp_value
		END ELSE IF @tmp_column = 'ROUND_POINT' BEGIN
			SET @p_round_point =		@tmp_value

		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =				@tmp_value
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			@tmp_value
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			@tmp_value
		
		END ELSE IF @tmp_column = 'CATE_INFO' BEGIN
			SET @p_cate_info =			@tmp_value

		END ELSE IF @tmp_column = 'AMEND_TABLE' BEGIN
			SET @p_amend_table =		@tmp_value
		END ELSE IF @tmp_column = 'AMEND_SALES_TABLE' BEGIN
			SET @p_amend_sales_table =  @tmp_value
		END ELSE IF @tmp_column = 'AMEND_CUTOFF_BOH_TABLE' BEGIN
			SET @p_amend_cutoff_boh_table =  @tmp_value
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
			END
			ELSE IF @sub_param_0 = 'chk_total' AND @sub_param_1 = 'true' BEGIN
				SET @sub_total = 'WHERE 1=1' +char(10)
			END 
			ELSE IF @sub_param_0 = 'chk_total_2' AND @sub_param_1 = 'false' BEGIN
				SET @total = 'WHERE 1=0' +char(10)
			END
			ELSE IF @sub_param_0 = 'chk_total_2' AND @sub_param_1 = 'true' BEGIN
				SET @total = 'WHERE 1=1' +char(10)
			END 
			ELSE IF @sub_param_0 = 'chk_ssp' AND @sub_param_1 = 'false' BEGIN
				SET @ssp_total = 'WHERE 1=0' +char(10)
			END
			ELSE IF @sub_param_0 = 'chk_ssp' AND @sub_param_1 = 'true' BEGIN
				SET @ssp_total = 'WHERE 1=1' +char(10)
			END 
		END -- WHILE
	END -- IF ISNULL(@p_cate_info,'') 


	--SET @p_unit = 1000;
	IF @p_unit = 1 BEGIN
		SET @p_round_point = 0
	END
	
	BEGIN

		SELECT	DISTINCT  @p_inner_company_id = A.SEGMENT2
				, @p_inner_division_id = A.SEGMENT3
				, @p_inner_site_id = A.SEGMENT4
		FROM	SCM_SYS_LOOKUP_VALUE A                                                                                   
		WHERE	A.LOOKUP_TYPE_CODE = 'INSTANCE_INFO'                                                                     
		AND		A.ACTIVE_FLAG = 'Y'                                                                                      
		AND		A.SEGMENT1 IN	(                                                                                          
									SELECT	A.SEGMENT3                                                                               
									FROM	SCM_SYS_LOOKUP_VALUE A                                                                     
									WHERE	A.LOOKUP_TYPE_CODE = 'ELEC_ASSY_INSTANCE_MAP'                                              
									AND		A.SEGMENT3 = ''+ @p_instance_id +''                                                                   
									AND		A.ACTIVE_FLAG = 'Y'                                                                        
								)                       
		
		SELECT @p_cal_type = (CASE WHEN KEY_VALUE = 'Y' THEN 'HOLD' ELSE 'STD' END)
		FROM FP_INSTANCE_CONFIG_M
		WHERE 1=1
		AND INSTANCE_ID = ''+ @p_instance_id +''
		AND CATEGORY_ID = 'PLAN_CATEGORY'
		AND KEY_ID = 'HOLD_STOCK_PLAN'

		--SET @p_cal_type = 'HOLD'

		IF OBJECT_ID('tempdb..#DEFAULT_M_PER_ROLL') IS NOT NULL
			DROP TABLE #DEFAULT_M_PER_ROLL

		IF OBJECT_ID('tempdb..#LANE_T') IS NOT NULL
			DROP TABLE #LANE_T
		
		IF OBJECT_ID('tempdb..#STOCK_T') IS NOT NULL
			DROP TABLE #STOCK_T

		IF OBJECT_ID('tempdb..#MAIN_P') IS NOT NULL
			DROP TABLE #MAIN_P
		
		
		CREATE TABLE #MAIN_P
		(
			[COMPANY_ID] [nvarchar](30) NULL,
			[DIVISION_ID] [nvarchar](30) NULL,
			[SITE_ID] [nvarchar](30) NULL,
			[PLANT_ID] [nvarchar](30) NULL,
			[FACTORY_ID] [nvarchar](30) NULL,
			[ITEM_ID] [nvarchar](150) NULL,
			[NP_ITEM_ID] [nvarchar](150) NULL,
			[NICK_NAME] [nvarchar](50) NULL,
			[FLOW_ID] [nvarchar](150) NULL,
			[LEVEL_3_NAME] [nvarchar](150) NULL,
			[ELECTRODE_TYPE] [nvarchar](30) NULL,
			[PRODUCTION_TYPE] [nvarchar](30) NULL,
			[ATTR_TYPE] [nvarchar](30) NULL,
			[PLAN_DATE] [nvarchar](30) NULL,
			[CATEGORY_ID] [nvarchar](30) NULL,
			[CATEGORY_GROUP] [nvarchar](30) NULL,
			[QTY] numeric(20, 4) NULL DEFAULT ((0)),
			[IN_QTY] numeric(20, 4) NULL DEFAULT ((0)),
			[JR_BOH] numeric(20, 4) NULL DEFAULT ((0)),
			[RP_BOH] numeric(20, 4) NULL DEFAULT ((0)),
			[A_TYPE_BOH] numeric(20, 4) NULL DEFAULT ((0)),
			[B_TYPE_BOH] numeric(20, 4) NULL DEFAULT ((0)),
			[ASSY_BOH] numeric(20, 4) NULL DEFAULT ((0)),
			[JR_R_BOH] numeric(20, 4) NULL DEFAULT ((0)),
			[RP_R_BOH] numeric(20, 4) NULL DEFAULT ((0)),
			[A_TYPE_R_BOH] numeric(20, 4) NULL DEFAULT ((0)),
			[B_TYPE_R_BOH] numeric(20, 4) NULL DEFAULT ((0)),
			[ASSY_R_BOH] numeric(20, 4) NULL DEFAULT ((0)),
			[JR_BOH_HOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[RP_BOH_HOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[A_TYPE_BOH_HOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[B_TYPE_BOH_HOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[ASSY_BOH_HOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[JR_R_BOH_HOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[RP_R_BOH_HOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[A_TYPE_R_BOH_HOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[B_TYPE_R_BOH_HOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[ASSY_R_BOH_HOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[JR_BOH_ONLYHOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[RP_BOH_ONLYHOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[A_TYPE_BOH_ONLYHOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[B_TYPE_BOH_ONLYHOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[ASSY_BOH_ONLYHOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[JR_R_BOH_ONLYHOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[RP_R_BOH_ONLYHOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[A_TYPE_R_BOH_ONLYHOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[B_TYPE_R_BOH_ONLYHOLD] numeric(20, 4) NULL DEFAULT ((0)),
			[ASSY_R_BOH_ONLYHOLD] numeric(20, 4) NULL DEFAULT ((0))
		)

		

		BEGIN	-- #DEFAULT_M_PER_ROLL

			SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A. FACTORY_ID, A.ELECTRODE_TYPE
					, CASE WHEN X.ROLL_TYPE = 'J' THEN '-' ELSE ISNULL(B.ATTR_TYPE, 'B') END AS ATTR_TYPE
					, X.ROLL_TYPE
					, CASE WHEN X.ROLL_TYPE = 'J' AND SUM(PRE_RP_JR + PRE_ST_JR) > 0 THEN ROUND(SUM(PRE_RP_JR + PRE_ST_JR) / SUM(PRE_RP_JR_LOT + PRE_ST_JR_LOT) ,2)
						   WHEN X.ROLL_TYPE = 'P' AND SUM(POST_ST_PC) > 0 THEN ROUND(SUM(POST_ST_PC) / SUM(POST_ST_PC_LOT), 2)
						   ELSE NULL
					  END AS M_PER_ROLL
			INTO #DEFAULT_M_PER_ROLL
			FROM	(
						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A. FACTORY_ID, A.ITEM_ID 
								, IT.NICK_NAME, A.OPERATION_ID, A.FP_APPLY_OPERATION_ID
								, CASE WHEN CHARINDEX('ANODE', IT.SPEC) > 0 THEN 'ANODE' ELSE 'CATHODE' END AS ELECTRODE_TYPE
								, SUM(QTY) AS QTY, SUM(LOT_COUNT)AS LOT_COUNT

								, SUM(CASE WHEN FP_APPLY_OPERATION_ID = 'E2000' THEN A.QTY ELSE 0 END) AS PRE_RP_JR				                                                
								, SUM(CASE WHEN FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID <= 'E4000' THEN A.QTY ELSE 0 END) AS PRE_ST_JR
								, SUM(CASE WHEN FP_APPLY_OPERATION_ID IN ('E3000','E4000') AND OPERATION_ID > 'E4000'  THEN A.QTY ELSE 0 END) AS POST_ST_PC

								, SUM(CASE WHEN FP_APPLY_OPERATION_ID = 'E2000' THEN A.LOT_COUNT ELSE 0 END) AS PRE_RP_JR_LOT				                                                
								, SUM(CASE WHEN FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID <= 'E4000' THEN A.LOT_COUNT ELSE 0 END) AS PRE_ST_JR_LOT
								, SUM(CASE WHEN FP_APPLY_OPERATION_ID IN ('E3000','E4000') AND OPERATION_ID > 'E4000'  THEN A.LOT_COUNT ELSE 0 END) AS POST_ST_PC_LOT
						FROM SCM_STOCK_H_V A 
								INNER HASH JOIN SCM_ITEM_M IT WITH(NOLOCK)				                                                                                                                                                          
								ON 	1=1	
								AND IT.ACTIVE_FLAG = 'Y'		                                                                                                                                                                        
								AND A.COMPANY_ID = IT.COMPANY_ID 		                                                                                                                                          
								AND A.DIVISION_ID = IT.DIVISION_ID 		                                                                                                                                        
								AND A.SITE_ID = IT.SITE_ID 		                                                                                         
								AND A.ITEM_ID = IT.ITEM_ID
						WHERE CUTOFF_DATE = '' + @P_PLAN_DATE +''
						AND A.SITE_ID = ''+ @p_inner_site_id +''      
						AND	A.ITEM_ID LIKE 'APC%'					                                                                                                                                                
						AND	A.STOCK_TYPE = 'WIP'
						AND EXISTS (
										SELECT 1
										FROM (
												SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
												FROM SCM_FACTORY_M WITH(NOLOCK)
												WHERE 1=1
												AND SITE_ID = ''+ @p_inner_site_id +''      
												AND SHOP_GROUP_ID = 'E'
											) X
										WHERE 1=1
										AND A.COMPANY_ID = X.COMPANY_ID
										AND A.DIVISION_ID = X.DIVISION_ID
										AND A.SITE_ID = X.SITE_ID
										AND A.PLANT_ID = X.PLANT_ID
										AND A.FACTORY_ID = X.FACTORY_ID
									)
						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A. FACTORY_ID, A.ITEM_ID 
								,  IT.NICK_NAME, A.OPERATION_ID, A.FP_APPLY_OPERATION_ID
								, CASE WHEN CHARINDEX('ANODE', IT.SPEC) > 0 THEN 'ANODE' ELSE 'CATHODE' END
					) A
					LEFT OUTER JOIN (
									SELECT 	DISTINCT SEGMENT1 AS INSTANCE_ID, FII.COMPANY_ID, FII.DIVISION_ID, FII.SITE_ID, FII.PLANT_ID, SEGMENT2 AS ATTR_TYPE, SEGMENT3 AS ATTR_CATEGORY, SEGMENT4 AS ATTR_DEFINIT					
									FROM 	SCM_SYS_LOOKUP_VALUE LV	WITH(NOLOCK)					                                                                                                                                                  
											JOIN 	FP_INSTANCE_INFO_V FII			                                                                                                                                                  
											ON 	1=1			                                                                                                                                                                        
											AND 	LV.SEGMENT1 = FII.INSTANCE_ID 			                                                                                                                                               
									WHERE 	1=1						                                                                                                                                                                    
									AND 	LOOKUP_TYPE_CODE = 'E_POST_WH_ATTR_TYPE_DEFINIT'	
									AND		LV.ACTIVE_FLAG = 'Y'
					) B
					ON 	1=1						                                                                                                                                                                  
					AND 	A.NICK_NAME LIKE B.ATTR_DEFINIT
					JOIN (
							SELECT 'J' AS ROLL_TYPE UNION
							SELECT 'P' AS ROLL_TYPE 
					) X
					ON 1=1
			WHERE	1=1
			AND		ISNULL(FP_APPLY_OPERATION_ID,'') <> ''
			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A. FACTORY_ID,A.ELECTRODE_TYPE, CASE WHEN X.ROLL_TYPE = 'J' THEN '-' ELSE ISNULL(B.ATTR_TYPE, 'B') END, X.ROLL_TYPE

		END

		BEGIN	-- Temp Lane

				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ELECTRODE_TYPE, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE																							
						, LANE_QTY                                                                                                                                                                                                      
						, CASE WHEN ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH) = 0 THEN 1 ELSE ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH) END AS JUMBO_ROLL_LENGTH                                                                                                                                         
						, CASE WHEN ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH) = 0 THEN 1 ELSE ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH) END AS PC_ROLL_LENGTH                                                                                                                                                  
						, CASE WHEN ''+ @p_uom_type +'' = 'JR' THEN ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH)	
								ELSE  ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH) * LANE_QTY END AS M_PER_ROLL_QTY	

						, CASE WHEN ''+ @p_uom_type +'' = 'JR' THEN ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH)	
								ELSE  ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH) * LANE_QTY END AS JR_M_PER_ROLL_QTY	
						, CASE WHEN ''+ @p_uom_type +'' = 'JR' THEN ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH) / LANE_QTY
								ELSE  ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH)  END AS PC_M_PER_ROLL_QTY	
				INTO #LANE_T
				FROM (                                                                                                                                                                                                                  
						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE                                                                                                    
								,CASE WHEN A.ITEM_ID LIKE 'APCA%' THEN 'ANODE'                                                                                                                                                      
										WHEN A.ITEM_ID LIKE 'APCC%' THEN 'CATHODE'                                                                                                                                                    
									END AS ELECTRODE_TYPE                                                                                                                                                                                  
								--, MAX(CASE WHEN A.FLOW_ID = 'E2000E3000' THEN 1 ELSE ISNULL(B.LANE_QTY, ISNULL(C.LANE_QTY, ISNULL(D.LANE_QTY, E.LANE_QTY))) END) AS LANE_QTY
								, MAX(ISNULL(B.LANE_QTY, ISNULL(C.LANE_QTY, ISNULL(D.LANE_QTY, E.LANE_QTY)))) AS LANE_QTY
								, MAX( B.JUMBO_ROLL_LENGTH ) AS JUMBO_ROLL_LENGTH		                                                                                                                                                
								, MAX( B.PC_ROLL_LENGTH ) AS PC_ROLL_LENGTH		 
						FROM	(                                                                                                                                                                                                       
									SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID, A.ITEM_ID, C.FLOW_ID, C.NICK_NAME, ISNULL(E.ATTR_TYPE, 'B') AS ATTR_TYPE                                                 
									FROM	SCM_ITEM_LANE_M A  WITH(NOLOCK)                                                                                                                                                             
											INNER HASH JOIN(                                                                                                                                                                            
													SELECT DISTINCT COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                      
													FROM FP_INSTANCE_LINE_V A WITH(NOLOCK)                                                                                                                                              
													WHERE	1=1	                                                                                                                                                                        
													AND INSTANCE_ID = ''+ @p_instance_id +''                                                                                                                                                     
											)  B                                                                                                                                                                                        
											ON 1=1                                                                                                                                                                                      
											AND  B.COMPANY_ID 	= A.COMPANY_ID                                                                                                                                                          
											AND  B.DIVISION_ID 	= A.DIVISION_ID                                                                                                                                                         
											AND  B.SITE_ID 		= A.SITE_ID                                                                                                                                                             
											AND  B.PLANT_ID 	= A.PLANT_ID                                                                                                                                                            
											INNER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                                        
											ON 1=1                                                                                                                                                                                      
											AND  A.COMPANY_ID	= C.COMPANY_ID                                                                                                                                                          
											AND  A.DIVISION_ID	= C.DIVISION_ID                                                                                                                                                         
											AND  A.SITE_ID		= C.SITE_ID                                                                                                                                                             
											AND  A.ITEM_ID		= C.ITEM_ID                                                                                                                                                             
											AND  C.ACTIVE_FLAG = 'Y'                                                                                                                                                                  
											LEFT OUTER JOIN (							                                                                                                                                                                            
												SELECT 	DISTINCT SEGMENT1 AS INSTANCE_ID, FII.COMPANY_ID, FII.DIVISION_ID, FII.SITE_ID, FII.PLANT_ID, SEGMENT2 AS ATTR_TYPE, SEGMENT3 AS ATTR_CATEGORY, SEGMENT4 AS ATTR_DEFINIT					
												FROM 	SCM_SYS_LOOKUP_VALUE LV						                                                                                                                                                  
															JOIN 	FP_INSTANCE_INFO_V FII			                                                                                                                                                  
															ON 	1=1			                                                                                                                                                                        
															AND 	LV.SEGMENT1 = FII.INSTANCE_ID 			                                                                                                                                          
												WHERE 	1=1						                                                                                                                                                                    
												AND 		LOOKUP_TYPE_CODE = 'E_POST_WH_ATTR_TYPE_DEFINIT'					                                                                                                                      
											) E	                                                                                                                                                                                        
											ON 	1=1						                                                                                                                                                                
											AND C.NICK_NAME LIKE E.ATTR_DEFINIT	                                                                                                                                                        
									WHERE	1=1                                                                                                                                                                                         
									AND		A.SITE_ID = ''+ @p_inner_site_id +''                                                                                                                                                                 
									GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID, A.ITEM_ID, C.FLOW_ID, C.NICK_NAME, ISNULL(E.ATTR_TYPE, 'B')                                                            
								) A                                                                                                                                                                                                     
								LEFT OUTER JOIN (                                                                                                                                                                                       
									SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID 
											, MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY	
											, MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH
											, MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH    
									FROM SCM_ITEM_LANE_M A  WITH(NOLOCK)                                                                   																							    
									WHERE	1=1	                                                                                                                                                                                        
									AND		A.SITE_ID = ''+ @p_inner_site_id +''                                                                                                                                                                      
									AND  A.PROD_VERSION_TYPE = 'E3000E4000'                                                                                                                                                           
									GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                
								) B                                                                                                                                                                                                     
								ON 1=1                                                                                                                                                                                                  
								AND  B.COMPANY_ID 	= A.COMPANY_ID                                                                                                                                                                      
								AND  B.DIVISION_ID 	= A.DIVISION_ID                                                                                                                                                                     
								AND  B.SITE_ID 		= A.SITE_ID                                                                                                                                                                         
								AND  B.PLANT_ID 	= A.PLANT_ID                                                                                                                                                                        
								AND  B.FACTORY_ID 	= A.FACTORY_ID                                                                                                                                                                      
								AND  B.ITEM_ID 		= A.ITEM_ID	                                                                                                                                                                        
								LEFT OUTER JOIN (                                                                                                                                                                                       
									SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                  
											, MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY	
											, MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH
											, MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH    
									FROM SCM_ITEM_LANE_M A  WITH(NOLOCK)                                                                   																							    
									WHERE	1=1	                                                                                                                                                                                        
									AND		SITE_ID = ''+ @p_inner_site_id +''	                                                                                                                                                                        
									GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                
								) C                                                                                                                                                                                                     
								ON 1=1                                                                                                                                                                                                  
								AND  C.COMPANY_ID 	= A.COMPANY_ID                                                                                                                                                                      
								AND  C.DIVISION_ID 	= A.DIVISION_ID                                                                                                                                                                     
								AND  C.SITE_ID 		= A.SITE_ID                                                                                                                                                                         
								AND  C.PLANT_ID 	= A.PLANT_ID                                                                                                                                                                        
								AND  B.FACTORY_ID 	= A.FACTORY_ID                                                                                                                                                                      
								AND  C.ITEM_ID 		= A.ITEM_ID                                                                                                                                                                         
								LEFT OUTER JOIN (                                                                                                                                                                                       
									SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                                                
											, MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY	
											, MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH
											, MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH    
									FROM SCM_ITEM_LANE_M A  WITH(NOLOCK)                                                                   																							    
									WHERE	1=1	                                                                                                                                                                                        
									AND		A.SITE_ID = ''+ @p_inner_site_id +''                                                                                                                                                                      
									AND  A.PROD_VERSION_TYPE = 'E3000E4000'                                                                                                                                                           
									GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                                              
								) D                                                                                                                                                                                                     
								ON 1=1                                                                                                                                                                                                  
								AND  D.COMPANY_ID 	= A.COMPANY_ID                                                                                                                                                                      
								AND  D.DIVISION_ID 	= A.DIVISION_ID                                                                                                                                                                     
								AND  D.SITE_ID 		= A.SITE_ID                                                                                                                                                                         
								AND  D.PLANT_ID 	= A.PLANT_ID                                                                                                                                                                        
								AND  D.ITEM_ID 		= A.ITEM_ID	                                                                                                                                                                        
								LEFT OUTER JOIN (                                                                                                                                                                                       
									SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                                                
											, MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY	
											, MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH
											, MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH    
									FROM SCM_ITEM_LANE_M A  WITH(NOLOCK)                                                                   																							    
									WHERE	1=1	                                                                                                                                                                                        
									AND		SITE_ID = ''+ @p_inner_site_id +''	                                                                                                                                                                        
									GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                                              
								) E                                                                                                                                                                                                     
								ON 1=1                                                                                                                                                                                                  
								AND  E.COMPANY_ID 	= A.COMPANY_ID                                                                                                                                                                      
								AND  E.DIVISION_ID 	= A.DIVISION_ID                                                                                                                                                                     
								AND  E.SITE_ID 		= A.SITE_ID                                                                                                                                                                         
								AND  E.PLANT_ID 	= A.PLANT_ID                                                                                                                                                                        
								AND  E.ITEM_ID 		= A.ITEM_ID	                                                                                                                                                                        
						WHERE 1=1                                                                                                                                                                                                       
						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE                                                                                                  
					) A                                                                                                                                                                                                                 
					LEFT OUTER HASH JOIN (                                                                                                                                                                                              
							SELECT FACTORY_ID, ELECTRODE_TYPE, A.ATTR_TYPE                                                                                                                                                              
									, MAX(JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(PC_ROLL_LENGTH) AS PC_ROLL_LENGTH                                                                                                                
							FROM	(                                                                                                                                                                                                   
										SELECT FACTORY_ID, ELECTRODE_TYPE, B.ATTR_TYPE                                                                                                                                                  
												, CASE WHEN B.UOM_TYPE = 'JR' THEN JR_COL END AS JUMBO_ROLL_LENGTH                                                                                                                    
												, CASE WHEN B.UOM_TYPE = 'PC' AND B.ATTR_TYPE = 'A' THEN A_TYPE_COL                                                                                                                 
														WHEN B.UOM_TYPE = 'PC' AND B.ATTR_TYPE = 'B' THEN B_TYPE_COL                                                                                                                
														ELSE 0 END AS PC_ROLL_LENGTH                                                                                                                                                    
										FROM	(                                                                                                                                                                                       
													SELECT FACTORY_ID, ELECTRODE_TYPE, ISNULL([-],0) AS JR_COL, ISNULL([A],0) AS A_TYPE_COL, ISNULL([B],0) AS B_TYPE_COL	                                                            
													FROM(	
															SELECT	FACTORY_ID, ELECTRODE_TYPE,  ATTR_TYPE,  M_PER_ROLL AS ROLL_QTY
															FROM	#DEFAULT_M_PER_ROLL
															--SELECT	SEGMENT2 AS FACTORY_ID, 																					                                                        
															--		CASE WHEN SEGMENT3 = 'A' THEN 'ANODE'																	                                                        
															--				WHEN SEGMENT3 = 'C' THEN 'CATHODE' 																                                                        
															--				ELSE SEGMENT3 END AS ELECTRODE_TYPE    , SEGMENT4 AS ATTR_TYPE, ATTRIBUTE1 AS ROLL_QTY                                                                      
															--FROM	SCM_SYS_LOOKUP_VALUE A                                                                     					                                                        
															--WHERE	A.LOOKUP_TYPE_CODE = 'E_POST_JR_DEFAULT_DEFINIT'                                              			                                                        
															--AND		A.SEGMENT1 = ''+ @p_instance_id +''                                                                   				                                                        
															--AND		A.ACTIVE_FLAG = 'Y'              																			                                                        
														) AS RESULT																												                                                        
														PIVOT (																													                                                        
																MAX(ROLL_QTY) FOR ATTR_TYPE IN ([-], [A], [B])																		                                                    
														) AS PIV                                                                                                                                                                        
												) A                                                                                                                                                                                     
												JOIN (                                                                                                                                                                                  
														SELECT 'JR' AS UOM_TYPE , 'A' AS ATTR_TYPE UNION                                                                                                                            
														SELECT 'JR' AS UOM_TYPE , 'B' AS ATTR_TYPE UNION                                                                                                                            
														SELECT 'PC' AS UOM_TYPE , 'A' AS ATTR_TYPE UNION                                                                                                                            
														SELECT 'PC' AS UOM_TYPE , 'B' AS ATTR_TYPE                                                                                                                                  
													) B                                                                                                                                                                                 
												ON 1=1                                                                                                                                                                                  
										WHERE 1=1                                                                                                                                                                                       
							) A                                                                                                                                                                                                         
							GROUP BY FACTORY_ID, ELECTRODE_TYPE, A.ATTR_TYPE                                                                                                                                                            
						) B                                                                                                                                                                                                             
						ON 1=1                                                                                                                                                                                                          
						AND A.FACTORY_ID = B.FACTORY_ID                                                                                                                                                                                 
						AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE                                                                                                                                                                         
						AND A.ATTR_TYPE = B.ATTR_TYPE                                                                                                                                                                                   
				WHERE 1=1                                                                                                                                                                                                               
		
		END	-- TEMP LANE

		BEGIN -- TEMP STOCK

				WITH STOCK AS 																																																																																															
					(							                                                                                                                                                                            
							SELECT 	DISTINCT ST.ITEM_ID, IT.NICK_NAME, ISNULL(MP.ELEC_FACTORY_ID, ST.FACTORY_ID)  AS FACTORY_ID, ST.PRODUCTION_TYPE						                                                                                      
									, SUM(CASE WHEN ST.WIPHOLD_YN = 'N' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS TOTAL_QTY				                                                                                                                                                  
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'A%' AND ST.ELEC_POST_HOLD_YN = 'N' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS ASSY_PC				                                                                                                
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'N' AND FP_APPLY_OPERATION_ID = 'E2000' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS PRE_RP_JR 				                                                        
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'N' AND FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID <= 'E4000' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS PRE_ST_JR				                          
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'N' AND FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID > 'E4000'  THEN ST.FP_APPLY_WIPQTY 				                                                  
											   WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'N' AND FP_APPLY_OPERATION_ID = 'E4000' AND OPERATION_ID > 'E4000' THEN ST.FP_APPLY_WIPQTY                                                              
											   ELSE 0 END) AS POST_ST_PC                                                                                                                                                  
									, SUM(CASE WHEN ST.WIPHOLD_YN = 'N' THEN ST.LOT_COUNT ELSE 0 END) AS TOTAL_LOT_COUNT				                                                                                                                                      
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'A%' AND ST.ELEC_POST_HOLD_YN = 'N' THEN ST.LOT_COUNT  ELSE 0 END) AS ASSY_PC_R				                                                                                        
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'N' AND FP_APPLY_OPERATION_ID = 'E2000' THEN ST.LOT_COUNT ELSE 0 END) AS PRE_RP_JR_R				                                                
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'N' AND FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID <= 'E4000' THEN ST.LOT_COUNT ELSE 0 END) AS PRE_ST_JR_R				                  
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'N' AND FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID > 'E4000'  THEN ST.LOT_COUNT				                                              
											   WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'N' AND FP_APPLY_OPERATION_ID = 'E4000' AND OPERATION_ID > 'E4000' THEN ST.LOT_COUNT                                                        
											   ELSE 0 END) AS POST_ST_PC_R  
									, SUM(ST.FP_APPLY_WIPQTY) AS TOTAL_QTY_HOLD				                                                                                                                                                  
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'A%' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS ASSY_PC_HOLD				                                                                                                
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND FP_APPLY_OPERATION_ID = 'E2000' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS PRE_RP_JR_HOLD 				                                                        
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID <= 'E4000' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS PRE_ST_JR_HOLD				                          
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID > 'E4000'  THEN ST.FP_APPLY_WIPQTY 				                                                  
											   WHEN ST.FACTORY_ID LIKE 'E%' AND FP_APPLY_OPERATION_ID = 'E4000' AND OPERATION_ID > 'E4000' THEN ST.FP_APPLY_WIPQTY                                                              
											   ELSE 0 END) AS POST_ST_PC_HOLD                                                                                                                                                  
									, SUM(ST.LOT_COUNT) AS TOTAL_LOT_COUNT_HOLD				                                                                                                                                      
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'A%' THEN ST.LOT_COUNT  ELSE 0 END) AS ASSY_PC_R_HOLD				                                                                                        
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND FP_APPLY_OPERATION_ID = 'E2000' THEN ST.LOT_COUNT ELSE 0 END) AS PRE_RP_JR_R_HOLD				                                                
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID <= 'E4000' THEN ST.LOT_COUNT ELSE 0 END) AS PRE_ST_JR_R_HOLD				                  
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID > 'E4000'  THEN ST.LOT_COUNT				                                              
											   WHEN ST.FACTORY_ID LIKE 'E%' AND FP_APPLY_OPERATION_ID = 'E4000' AND OPERATION_ID > 'E4000' THEN ST.LOT_COUNT                                                        
											   ELSE 0 END) AS POST_ST_PC_R_HOLD 
									
									, SUM(CASE WHEN ST.WIPHOLD_YN = 'Y' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS TOTAL_QTY_ONLYHOLD				                                                                                                                                                  
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'A%' AND ST.ELEC_POST_HOLD_YN = 'Y' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS ASSY_PC_ONLYHOLD				                                                                                                
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'Y' AND FP_APPLY_OPERATION_ID = 'E2000' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS PRE_RP_JR_ONLYHOLD 				                                                        
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'Y' AND FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID <= 'E4000' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS PRE_ST_JR_ONLYHOLD				                          
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'Y' AND FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID > 'E4000'  THEN ST.FP_APPLY_WIPQTY 				                                                  
											   WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'Y' AND FP_APPLY_OPERATION_ID = 'E4000' AND OPERATION_ID > 'E4000' THEN ST.FP_APPLY_WIPQTY                                                              
											   ELSE 0 END) AS POST_ST_PC_ONLYHOLD                                                                                                                                                  
									, SUM(CASE WHEN ST.WIPHOLD_YN = 'Y' THEN ST.LOT_COUNT ELSE 0 END) AS TOTAL_LOT_COUNT_ONLYHOLD				                                                                                                                                      
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'A%' AND ST.ELEC_POST_HOLD_YN = 'Y' THEN ST.LOT_COUNT  ELSE 0 END) AS ASSY_PC_R_ONLYHOLD				                                                                                        
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'Y' AND FP_APPLY_OPERATION_ID = 'E2000' THEN ST.LOT_COUNT ELSE 0 END) AS PRE_RP_JR_R_ONLYHOLD				                                                
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'Y' AND FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID <= 'E4000' THEN ST.LOT_COUNT ELSE 0 END) AS PRE_ST_JR_R_ONLYHOLD				                  
									, SUM(CASE WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'Y' AND FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID > 'E4000'  THEN ST.LOT_COUNT				                                              
											   WHEN ST.FACTORY_ID LIKE 'E%' AND ST.ELEC_POST_HOLD_YN = 'Y' AND FP_APPLY_OPERATION_ID = 'E4000' AND OPERATION_ID > 'E4000' THEN ST.LOT_COUNT                                                        
											   ELSE 0 END) AS POST_ST_PC_R_ONLYHOLD  
							FROM 	SCM_STOCK_H_V ST WITH(NOLOCK)					                                                                                                                                                          
										INNER HASH JOIN SCM_ITEM_M IT WITH(NOLOCK)				                                                                                                                                                          
										ON 	1=1	
										AND IT.ACTIVE_FLAG = 'Y'		                                                                                                                                                                        
										AND ST.COMPANY_ID = IT.COMPANY_ID 		                                                                                                                                          
										AND ST.DIVISION_ID = IT.DIVISION_ID 		                                                                                                                                        
										AND ST.SITE_ID = IT.SITE_ID 		                                                                                                                                                
										AND ST.ITEM_ID = IT.ITEM_ID 		                                                                                                                                                
										LEFT OUTER JOIN (
												SELECT 	SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS ELEC_FACTORY_ID, SEGMENT4 AS ASSY_FACTORY_ID			                                                                                
												FROM 	SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)	                                                                                                                                                    
												WHERE 	1=1	                                                                                                                                                                    
												AND 	LOOKUP_TYPE_CODE = 'ELEC_POST_FACTORY_MAP'
												AND		ACTIVE_FLAG = 'Y'			
										) AS MP                                                                                                                     
										ON 	1=1			                                                                                                                                                                        
										AND 	(CASE WHEN ST.FACTORY_ID LIKE 'E%' THEN MP.ELEC_FACTORY_ID ELSE MP.ASSY_FACTORY_ID END) = ST.FACTORY_ID			                                                                  
										AND 	ST.FACTORY_ID = ASSY_FACTORY_ID			                                                                  
							WHERE 	1=1						                                                                                                                                                                    
							AND 		ST.CUTOFF_DATE = ''+ @p_plan_date +'' 					                                                                                                                                          
							AND 		ST.SITE_ID = ''+ @p_inner_site_id +''					                                                                                                                                                    
							AND 		ST.ITEM_ID LIKE 'APC%'					                                                                                                                                                
							AND 		ST.STOCK_TYPE = 'WIP'					                                                                                                                                                  
							AND 		IT.ACTIVE_FLAG = 'Y'					                                                                                                                                                  
							--AND			ST.WIPHOLD_YN = 'N'				                                                                                                                                                  
							GROUP BY ST.ITEM_ID, IT.NICK_NAME,  ISNULL(MP.ELEC_FACTORY_ID, ST.FACTORY_ID) , ST.PRODUCTION_TYPE				                                                                        
					)							                                                                                                                                                                            
									                                                                                                                                                                            
				, ATTR_TYPE AS 							                                                                                                                                                              
					(							                                                                                                                                                                            
						SELECT 	DISTINCT SEGMENT1 AS INSTANCE_ID, FII.COMPANY_ID, FII.DIVISION_ID, FII.SITE_ID, FII.PLANT_ID, SEGMENT2 AS ATTR_TYPE, SEGMENT3 AS ATTR_CATEGORY, SEGMENT4 AS ATTR_DEFINIT					
						FROM 	SCM_SYS_LOOKUP_VALUE LV	WITH(NOLOCK)					                                                                                                                                                  
								JOIN 	FP_INSTANCE_INFO_V FII			                                                                                                                                                  
								ON 	1=1			                                                                                                                                                                        
								AND 	LV.SEGMENT1 = FII.INSTANCE_ID 			                                                                                                                                          
						WHERE 	1=1						                                                                                                                                                                    
						AND 	LOOKUP_TYPE_CODE = 'E_POST_WH_ATTR_TYPE_DEFINIT'	
						AND		LV.ACTIVE_FLAG = 'Y'				                                                                                                                      
					)				
					SELECT	A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE, A.PRODUCTION_TYPE, ISNULL(B.LANE_QTY, 1) AS LANE_QTY                                                                                                  
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.TOTAL_QTY ELSE A.TOTAL_QTY / ISNULL(B.LANE_QTY, 1) END AS TOTAL_QTY                                                                                                           
							, A.TOTAL_LOT_COUNT                                                                                                            
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.JR_QTY ELSE A.JR_QTY / ISNULL(B.LANE_QTY, 1) END AS JR_QTY                                                                                                           
							, A.JR_QTY_LOT_COUNT                                                                                                            
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.ASSY_PC ELSE A.ASSY_PC / ISNULL(B.LANE_QTY, 1) END AS ASSY_PC              
							, A.ASSY_PC_R AS ASSY_PC_R              
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.PRE_RP_JR ELSE A.PRE_RP_JR / ISNULL(B.LANE_QTY, 1) END AS PRE_RP_JR              
							, A.PRE_RP_JR_R AS PRE_RP_JR_R              
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.PRE_ST_JR ELSE A.PRE_ST_JR / ISNULL(B.LANE_QTY, 1) END AS PRE_ST_JR              
							, A.PRE_ST_JR_R AS PRE_ST_JR_R              
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.POST_ST_PC ELSE A.POST_ST_PC / ISNULL(B.LANE_QTY, 1) END AS POST_ST_PC              
							, A.POST_ST_PC_R AS POST_ST_PC_R 
							
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.TOTAL_QTY_HOLD ELSE A.TOTAL_QTY_HOLD / ISNULL(B.LANE_QTY, 1) END AS TOTAL_QTY_HOLD                                                                                                           
							, A.TOTAL_LOT_COUNT_HOLD                                                                                                            
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.JR_QTY_HOLD ELSE A.JR_QTY_HOLD / ISNULL(B.LANE_QTY, 1) END AS JR_QTY_HOLD                                                                                                           
							, A.JR_QTY_LOT_COUNT_HOLD                                                                                                            
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.ASSY_PC_HOLD ELSE A.ASSY_PC_HOLD / ISNULL(B.LANE_QTY, 1) END AS ASSY_PC_HOLD              
							, A.ASSY_PC_R_HOLD AS ASSY_PC_R_HOLD              
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.PRE_RP_JR_HOLD ELSE A.PRE_RP_JR_HOLD / ISNULL(B.LANE_QTY, 1) END AS PRE_RP_JR_HOLD              
							, A.PRE_RP_JR_R_HOLD AS PRE_RP_JR_R_HOLD              
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.PRE_ST_JR_HOLD ELSE A.PRE_ST_JR_HOLD / ISNULL(B.LANE_QTY, 1) END AS PRE_ST_JR_HOLD              
							, A.PRE_ST_JR_R_HOLD AS PRE_ST_JR_R_HOLD              
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.POST_ST_PC_HOLD ELSE A.POST_ST_PC_HOLD / ISNULL(B.LANE_QTY, 1) END AS POST_ST_PC_HOLD              
							, A.POST_ST_PC_R_HOLD AS POST_ST_PC_R_HOLD   

							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.TOTAL_QTY_ONLYHOLD ELSE A.TOTAL_QTY_ONLYHOLD / ISNULL(B.LANE_QTY, 1) END AS TOTAL_QTY_ONLYHOLD                                                                                                           
							, A.TOTAL_LOT_COUNT_ONLYHOLD                                                                                                            
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.JR_QTY_ONLYHOLD ELSE A.JR_QTY_ONLYHOLD / ISNULL(B.LANE_QTY, 1) END AS JR_QTY_ONLYHOLD                                                                                                           
							, A.JR_QTY_LOT_COUNT_ONLYHOLD                                                                                                            
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.ASSY_PC_ONLYHOLD ELSE A.ASSY_PC_ONLYHOLD / ISNULL(B.LANE_QTY, 1) END AS ASSY_PC_ONLYHOLD              
							, A.ASSY_PC_R_ONLYHOLD AS ASSY_PC_R_ONLYHOLD              
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.PRE_RP_JR_ONLYHOLD ELSE A.PRE_RP_JR_ONLYHOLD / ISNULL(B.LANE_QTY, 1) END AS PRE_RP_JR_ONLYHOLD              
							, A.PRE_RP_JR_R_ONLYHOLD AS PRE_RP_JR_R_ONLYHOLD              
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.PRE_ST_JR_ONLYHOLD ELSE A.PRE_ST_JR_ONLYHOLD / ISNULL(B.LANE_QTY, 1) END AS PRE_ST_JR_ONLYHOLD              
							, A.PRE_ST_JR_R_ONLYHOLD AS PRE_ST_JR_R_ONLYHOLD              
							, CASE WHEN ''+ @p_uom_type +'' = 'PC' THEN A.POST_ST_PC_ONLYHOLD ELSE A.POST_ST_PC_ONLYHOLD / ISNULL(B.LANE_QTY, 1) END AS POST_ST_PC_ONLYHOLD              
							, A.POST_ST_PC_R_ONLYHOLD AS POST_ST_PC_R_ONLYHOLD 

					INTO	#STOCK_T
					FROM	(                                                                                                                                                                                        
								SELECT 	A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE									                                                                                                                                        
											, CASE WHEN B.ATTR_DEFINIT IS NULL THEN 'B' ELSE 'A' END AS ATTR_TYPE							                                                                                              
											, SUM(TOTAL_QTY) AS TOTAL_QTY							                                              
											, SUM(TOTAL_LOT_COUNT) AS TOTAL_LOT_COUNT							                                  
											, SUM(PRE_RP_JR)  AS JR_QTY	                                        
											, SUM(PRE_RP_JR_R)  AS JR_QTY_LOT_COUNT		                                  
											, SUM(ASSY_PC) AS ASSY_PC							                                                  
											, SUM(ASSY_PC_R) AS ASSY_PC_R							                                              
											, SUM(PRE_RP_JR) AS PRE_RP_JR							                                              
											, SUM(PRE_RP_JR_R) AS PRE_RP_JR_R							                                          
											, SUM(PRE_ST_JR) AS PRE_ST_JR							                                              
											, SUM(PRE_ST_JR_R) AS PRE_ST_JR_R							                                          
											, SUM(POST_ST_PC) AS POST_ST_PC							                                            
											, SUM(POST_ST_PC_R) AS POST_ST_PC_R	
											
											, SUM(TOTAL_QTY_HOLD) AS TOTAL_QTY_HOLD							                                              
											, SUM(TOTAL_LOT_COUNT_HOLD) AS TOTAL_LOT_COUNT_HOLD							                                  
											, SUM(PRE_RP_JR_HOLD)  AS JR_QTY_HOLD	                                        
											, SUM(PRE_RP_JR_R_HOLD)  AS JR_QTY_LOT_COUNT_HOLD		                                  
											, SUM(ASSY_PC_HOLD) AS ASSY_PC_HOLD							                                                  
											, SUM(ASSY_PC_R_HOLD) AS ASSY_PC_R_HOLD							                                              
											, SUM(PRE_RP_JR_HOLD) AS PRE_RP_JR_HOLD							                                              
											, SUM(PRE_RP_JR_R_HOLD) AS PRE_RP_JR_R_HOLD							                                          
											, SUM(PRE_ST_JR_HOLD) AS PRE_ST_JR_HOLD							                                              
											, SUM(PRE_ST_JR_R_HOLD) AS PRE_ST_JR_R_HOLD							                                          
											, SUM(POST_ST_PC_HOLD) AS POST_ST_PC_HOLD							                                            
											, SUM(POST_ST_PC_R_HOLD) AS POST_ST_PC_R_HOLD
											
											, SUM(TOTAL_QTY_ONLYHOLD) AS TOTAL_QTY_ONLYHOLD							                                              
											, SUM(TOTAL_LOT_COUNT_ONLYHOLD) AS TOTAL_LOT_COUNT_ONLYHOLD							                                  
											, SUM(PRE_RP_JR_ONLYHOLD)  AS JR_QTY_ONLYHOLD	                                        
											, SUM(PRE_RP_JR_R_ONLYHOLD)  AS JR_QTY_LOT_COUNT_ONLYHOLD		                                  
											, SUM(ASSY_PC_ONLYHOLD) AS ASSY_PC_ONLYHOLD							                                                  
											, SUM(ASSY_PC_R_ONLYHOLD) AS ASSY_PC_R_ONLYHOLD							                                              
											, SUM(PRE_RP_JR_ONLYHOLD) AS PRE_RP_JR_ONLYHOLD							                                              
											, SUM(PRE_RP_JR_R_ONLYHOLD) AS PRE_RP_JR_R_ONLYHOLD							                                          
											, SUM(PRE_ST_JR_ONLYHOLD) AS PRE_ST_JR_ONLYHOLD							                                              
											, SUM(PRE_ST_JR_R_ONLYHOLD) AS PRE_ST_JR_R_ONLYHOLD							                                          
											, SUM(POST_ST_PC_ONLYHOLD) AS POST_ST_PC_ONLYHOLD							                                            
											, SUM(POST_ST_PC_R_ONLYHOLD) AS POST_ST_PC_R_ONLYHOLD

								FROM 	STOCK A									                                                                                                                                                            
										LEFT OUTER JOIN ATTR_TYPE B							                                                                                                                                            
										ON 	1=1						                                                                                                                                                                  
										AND 	A.NICK_NAME LIKE B.ATTR_DEFINIT						                                                                                                                                    
								GROUP BY A.FACTORY_ID, ITEM_ID, NICK_NAME, A.PRODUCTION_TYPE, B.ATTR_DEFINIT 			                                                                                                
							) A                                                                                                                                                                                           
							LEFT OUTER JOIN #LANE_T B                                                                                                                                                                                           
							ON 1=1                                                                                                                                                                                        
							AND  B.FACTORY_ID 	= A.FACTORY_ID                                                                                                                                                            
							AND  B.ITEM_ID 		= A.ITEM_ID                                                                                                                                                                 
					WHERE 1=1                                                                                                                                                                                     
		                                                                                                                                                                        

		END --TEMP STOCK
		
		BEGIN  -- TEMP MAIN_P

			    SET	@v_dSql = ''                                                                                                             
				SELECT @v_dSql +=	N'	WITH ATTR_TYPE AS 																																																				' + char(10)							                                                                                                                                                              
				SELECT @v_dSql +=	N'	(							                                                                                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		SELECT 	DISTINCT SEGMENT1 AS INSTANCE_ID, FII.COMPANY_ID, FII.DIVISION_ID, FII.SITE_ID, FII.PLANT_ID, SEGMENT2 AS ATTR_TYPE, SEGMENT3 AS ATTR_CATEGORY, SEGMENT4 AS ATTR_DEFINIT					                        ' + char(10)
				SELECT @v_dSql +=	N'		FROM 	SCM_SYS_LOOKUP_VALUE LV						                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'				JOIN 	FP_INSTANCE_INFO_V FII			                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'				ON 	1=1			                                                                                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'				AND 	LV.SEGMENT1 = FII.INSTANCE_ID 			                                                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		WHERE 	1=1						                                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		AND 	LV.LOOKUP_TYPE_CODE = ''E_POST_WH_ATTR_TYPE_DEFINIT''					                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		AND 	LV.ACTIVE_FLAG = ''Y''					                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'	)                                                                                                                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'	INSERT INTO	#MAIN_P                                                                                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'	SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'			, A.ITEM_ID, A.NP_ITEM_ID  , A.NICK_NAME, A.FLOW_ID, A.LEVEL_3_NAME                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'			, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE                                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'			, A.CATEGORY_ID, A.CATEGORY_GROUP                                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'			, SUM(A.QTY) AS QTY   , SUM(A.IN_QTY) AS IN_QTY                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.PRE_RP_JR) AS JR_BOH                                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.PRE_ST_JR) AS RP_BOH                                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.POST_ST_PC) AS A_TYPE_BOH                                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.POST_ST_PC) AS B_TYPE_BOH                                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.ASSY_PC) AS ASSY_BOH                                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.PRE_RP_JR_R) AS JR_R_BOH                                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.PRE_ST_JR_R) AS RP_R_BOH                                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.POST_ST_PC_R) AS A_TYPE_R_BOH                                                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.POST_ST_PC_R) AS B_TYPE_R_BOH                                                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.ASSY_PC_R) AS ASSY_R_BOH                                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.PRE_RP_JR_HOLD) AS JR_BOH_HOLD                                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.PRE_ST_JR_HOLD) AS RP_BOH_HOLD                                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.POST_ST_PC_HOLD) AS A_TYPE_BOH_HOLD                                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.POST_ST_PC_HOLD) AS B_TYPE_BOH_HOLD                                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.ASSY_PC_HOLD) AS ASSY_BOH_HOLD                                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.PRE_RP_JR_R_HOLD) AS JR_R_BOH_HOLD                                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.PRE_ST_JR_R_HOLD) AS RP_R_BOH_HOLD                                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.POST_ST_PC_R_HOLD) AS A_TYPE_R_BOH_HOLD                                                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.POST_ST_PC_R_HOLD) AS B_TYPE_R_BOH_HOLD                                                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.ASSY_PC_R_HOLD) AS ASSY_R_BOH_HOLD                                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.PRE_RP_JR_ONLYHOLD) AS JR_BOH_ONLYHOLD                                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.PRE_ST_JR_ONLYHOLD) AS RP_BOH_ONLYHOLD                                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.POST_ST_PC_ONLYHOLD) AS A_TYPE_BOH_ONLYHOLD                                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.POST_ST_PC_ONLYHOLD) AS B_TYPE_BOH_ONLYHOLD                                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.ASSY_PC_ONLYHOLD) AS ASSY_BOH_ONLYHOLD                                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.PRE_RP_JR_R_ONLYHOLD) AS JR_R_BOH_ONLYHOLD                                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.PRE_ST_JR_R_ONLYHOLD) AS RP_R_BOH_ONLYHOLD                                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.POST_ST_PC_R_ONLYHOLD) AS A_TYPE_R_BOH_ONLYHOLD                                                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.POST_ST_PC_R_ONLYHOLD) AS B_TYPE_R_BOH_ONLYHOLD                                                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'			, MAX(B.ASSY_PC_R_ONLYHOLD) AS ASSY_R_BOH_ONLYHOLD                                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'	FROM	(	                                                                                                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'				SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'						, A.ITEM_ID, NULL AS NP_ITEM_ID , E.NICK_NAME, E.FLOW_ID, ISNULL(F.LEVEL_3_NAME,''-'') AS LEVEL_3_NAME                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'						, CASE WHEN A.ELECTRODE_TYPE = ''A'' THEN ''Anode''                                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'							   WHEN A.ELECTRODE_TYPE = ''C'' THEN ''Cathode''                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'							   ELSE A.ELECTRODE_TYPE END ELECTRODE_TYPE                                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'						, A.PRODUCTION_TYPE  AS PRODUCTION_TYPE                                                                                                                                                                              ' + char(10)
				--MOVING PLAN data 가 ed 에서 넘어오면 A type 아이템으로 넘어와 문제가 있어 하드코딩 함
				SELECT @v_dSql +=	N'						, CASE WHEN A.FACTORY_ID = ''EB'' THEN ''B'' ELSE ( CASE WHEN B.ATTR_DEFINIT IS NULL THEN ''B'' ELSE ''A'' END ) END AS ATTR_TYPE                        ' + char(10)
				SELECT @v_dSql +=	N'						, A.PLAN_DATE                                                                                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'						, A.CATEGORY_ID, A.CATEGORY_GROUP                                                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'						, CASE WHEN '''+ @p_uom_type +''' = ''JR'' THEN A.OUT_JR_QTY ELSE A.OUT_PC_QTY END AS QTY                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'						, CASE WHEN '''+ @p_uom_type +''' = ''JR'' THEN A.IN_JR_QTY ELSE A.IN_PC_QTY END AS IN_QTY                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'				FROM	(                                                                                                                                                                                                           ' + char(10)
				--SELECT @v_dSql +=	N'							-- 후공정 미래구간 : 계획, 실적                                                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'									, A.ITEM_ID, A.NP_ITEM_ID                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'									, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE                                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'									, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'									, SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) AS CATEGORY_ID                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'									, SUBSTRING(A.CATEGORY,0,2) AS CATEGORY_GROUP                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'									, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_JR_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   ELSE ROUND(A.OUT_JR_QTY,0) END AS OUT_JR_QTY                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'									, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_PC_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   ELSE ROUND(A.OUT_PC_QTY,0) END AS OUT_PC_QTY                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'									, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_JR_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   ELSE ROUND(A.IN_JR_QTY,0) END AS IN_JR_QTY                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'									, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_PC_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   ELSE ROUND(A.IN_PC_QTY,0) END AS IN_PC_QTY                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'							FROM   FP_ELECTRODE_POST_PLAN_H A WITH(NOLOCK)                                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'							WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'							AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                                                                                                           ' + char(10)
				--SELECT @v_dSql +=	N'							AND    A.CATEGORY  <> ''12-Moving Plan''                                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'							AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'							UNION ALL                                                                                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ATTB_4 AS FACTORY_ID                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'									, A.ITEM_ID, A.NP_ITEM_ID                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'									, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE                                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'									, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'									, SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) AS CATEGORY_ID                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'									, SUBSTRING(A.CATEGORY,0,2) AS CATEGORY_GROUP                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'									, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_JR_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   ELSE ROUND(A.OUT_JR_QTY,0) END AS OUT_JR_QTY                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'									, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_PC_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   ELSE ROUND(A.OUT_PC_QTY,0) END AS OUT_PC_QTY                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'									, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_JR_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   ELSE ROUND(A.IN_JR_QTY,0) END AS IN_JR_QTY                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'									, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_PC_QTY,0)                                                                      ' + char(10)
				SELECT @v_dSql +=	N'										   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										   ELSE ROUND(A.IN_PC_QTY,0) END AS IN_PC_QTY                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'							FROM   FP_ELECTRODE_POST_PLAN_H A WITH(NOLOCK)                                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'							WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'							AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'							AND    A.CATEGORY  = ''12-Moving Plan''                                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'							AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                  ' + char(10)
				--SELECT @v_dSql +=	N'							-- NOTCHING_RESULT / NOTCHING_RESULT : 과거                                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'							UNION ALL                                                                                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'							SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'									, A.ITEM_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE	                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'									, NULL AS ATTR_TYPE, A.PLAN_DATE	                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'									, A.CATEGORY_ID, A.CATEGORY_GROUP                                                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'									, ROUND(A.OUT_JR_QTY,0) AS OUT_JR_QTY	                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'									, ROUND(A.OUT_PC_QTY,0) AS OUT_PC_QTY	                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'									, ROUND(A.OUT_JR_QTY,0) AS IN_JR_QTY	                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'									, ROUND(A.OUT_PC_QTY,0) AS IN_PC_QTY	                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'							FROM	(                                                                                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'										SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		        								, A.ITEM_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.PLAN_DATE                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'		        								, A.CATEGORY_ID, A.CATEGORY_GROUP                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		        								, A.OUT_QTY / ISNULL(B.LANE_QTY,1) AS OUT_JR_QTY                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		        								, A.OUT_QTY AS OUT_PC_QTY                                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'			        					FROM	(                                                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'			        								SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, X.PLANT_ID, X.EPOST_FACTORY AS FACTORY_ID                                                                                       ' + char(10)              
				SELECT @v_dSql +=	N'	        												, B.CHILD_ITEM_ID AS ITEM_ID, A.ITEM_ID AS NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                               ' + char(10)                                                       
				SELECT @v_dSql +=	N'					        								, ''NOTCHING_PLAN'' AS CATEGORY_ID                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'															, ''10'' AS CATEGORY_GROUP                                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'															, CASE WHEN '''+ @p_uom_type +''' = ''UOM'' THEN SUM(A.PLAN_IN_QTY)                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'																	WHEN '''+ @p_uom_type +''' = ''PANCAKE'' THEN SUM(A.PLAN_IN_QTY) * B.CHILD_QTY / B.PARENT_QTY                                                                 ' + char(10)
				SELECT @v_dSql +=	N'																	WHEN '''+ @p_uom_type +''' = ''CELL'' THEN SUM(A.PLAN_IN_QTY) * B.CHILD_QTY / B.PARENT_QTY / DBO.FN_GET_REQ_QTY_MODEL( X.ASSY_PLANT, A.TOP_ITEM_ID,  B.CHILD_ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) )    ' + char(10)
				SELECT @v_dSql +=	N'																	ELSE SUM(A.PLAN_IN_QTY) * B.CHILD_QTY / B.PARENT_QTY                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'																	END	AS OUT_QTY                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'															--, SUM(A.PLAN_IN_QTY)*B.CHILD_QTY/B.PARENT_QTY AS OUT_QTY                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'													FROM 	FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'							        						INNER JOIN (                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'																		SELECT	SEGMENT1 AS EPOST_INSTANCE, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, SEGMENT2 AS EPOST_FACTORY                                           ' + char(10)                          
				SELECT @v_dSql +=	N'																				, SEGMENT3 AS ASSY_INSTANCE, SEGMENT4 AS ASSY_FACTORY, C.PLANT_ID AS ASSY_PLANT                                                                     ' + char(10)                              
				SELECT @v_dSql +=	N'																		FROM	SCM_SYS_LOOKUP_VALUE A,                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'																				SCM_FACTORY_M B,                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'																				SCM_FACTORY_M C                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'																		WHERE	1=1                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'																		AND		A.LOOKUP_TYPE_CODE = ''ELEC_POST_FACTORY_MAP''                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'																		AND		A.ACTIVE_FLAG	= ''Y''                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'																		AND		A.SEGMENT1		= '''+ @p_instance_id +'''                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'																		AND		A.SEGMENT2		= B.FACTORY_ID                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'																		AND		B.ACTIVE_FLAG	= ''Y''                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'																		AND		A.SEGMENT4		= C.FACTORY_ID                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'																		AND		C.ACTIVE_FLAG	= ''Y''                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'																	) X                                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'																ON 1=1                                                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'																AND		A.COMPANY_ID 	= X.COMPANY_ID                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'																AND		A.DIVISION_ID	= X.DIVISION_ID                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'																AND		A.SITE_ID		= X.SITE_ID                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'																AND		A.PLANT_ID		= X.ASSY_PLANT                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'																AND		A.FACTORY_ID	= X.ASSY_FACTORY ,                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'							        						SCM_BOM_M B WITH(NOLOCK),                                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'							        						SCM_ITEM_M C WITH(NOLOCK),                                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'							        						SCM_ITEM_CLASS_M D WITH(NOLOCK),                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'							        						SCM_ITEM_M E WITH(NOLOCK),                                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'							        						SCM_ITEM_CLASS_M F WITH(NOLOCK)                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'							        				WHERE 	1=1                                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	A.PLAN_TYPE		 = ''RELEASE''                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'							        				AND	A.OPERATION_ID	 = ''A5000''                                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'							        				AND	CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_plan_date +''' -1                                                                         ' + char(10)
				SELECT @v_dSql +=	N'							        				AND	A.PLAN_IN_QTY	 > 0                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'							        				AND	A.COMPANY_ID     = B.COMPANY_ID                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'							        				AND	A.DIVISION_ID    = B.DIVISION_ID                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	A.SITE_ID        = B.SITE_ID                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'							        				AND	A.COMPANY_ID     = C.COMPANY_ID                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	A.DIVISION_ID    = C.DIVISION_ID                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	A.SITE_ID        = C.SITE_ID                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'							        				AND	A.COMPANY_ID     = E.COMPANY_ID                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	A.DIVISION_ID    = E.DIVISION_ID                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	A.SITE_ID        = E.SITE_ID                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	A.ITEM_ID        = B.PARENT_ITEM_ID                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	B.PARENT_ITEM_ID = C.ITEM_ID                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	C.ITEM_CLASS     = D.CLASS_ID                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	D.LEVEL_2_NAME   IN (''NOTCHED PANCAKE'', ''JELLY ROLL'')                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	B.CHILD_ITEM_ID  = E.ITEM_ID                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	E.ITEM_CLASS     = F.CLASS_ID                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	F.LEVEL_2_NAME   = ''PANCAKE''                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	B.ACTIVE_FLAG    = ''Y''                                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	B.EFF_END_DATE >= '''+ @p_plan_date +'''                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'							        				AND 	(B.ALT_PRIORITY = 1 OR B.ALT_PRIORITY IS NULL)                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'							        				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, X.PLANT_ID, X.EPOST_FACTORY                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'															, A.ITEM_ID, B.CHILD_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, CONVERT(VARCHAR,A.PLAN_DATE,112)                                                                     ' + char(10)
				SELECT @v_dSql +=	N'															, B.CHILD_QTY, B.PARENT_QTY, A.TOP_ITEM_ID, X.ASSY_PLANT                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'											                                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'										) A                                                                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'										LEFT OUTER JOIN #LANE_T B                                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'											ON 1=1                                                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'											AND  B.COMPANY_ID 	= A.COMPANY_ID                                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'											AND  B.DIVISION_ID 	= A.DIVISION_ID                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'											AND  B.SITE_ID 		= A.SITE_ID                                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'											AND  B.PLANT_ID 	= A.PLANT_ID                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'											AND  B.FACTORY_ID 	= A.FACTORY_ID                                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'											AND  B.ITEM_ID 		= A.ITEM_ID                                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'								WHERE 1=1                                                                                                                                                                                           ' + char(10)
				--SELECT @v_dSql +=	N'								-- COATING_PLAN / ROLL_PRESS_PLAN / SLITTING_PLAN 과거 계획                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'								UNION ALL                                                                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'								SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    							, A.ITEM_ID AS ITEM_ID, ''-'' AS NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                             ' + char(10)                                           
				SELECT @v_dSql +=	N'		    							, CASE WHEN A.OPERATION_ID = ''E2000'' THEN ''COATING_PLAN''                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'		    							  	   WHEN A.OPERATION_ID = ''E3000'' THEN ''ROLL_PRESS_PLAN''                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    							  	   WHEN A.OPERATION_ID = ''E4000'' THEN ''SLITTING_PLAN''                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'		    							  END AS CATEGORY_ID                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'		    							, CASE WHEN A.OPERATION_ID = ''E2000'' THEN ''60''                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    							  	   WHEN A.OPERATION_ID = ''E3000'' THEN ''50''                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    							  	   WHEN A.OPERATION_ID = ''E4000'' THEN ''40''                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    							  END AS CATEGORY_GROUP                                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'										, SUM(A.JR_OUT_QTY) AS OUT_JR_QTY                                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'										, SUM(A.PLAN_QTY) AS OUT_PC_QTY                                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'								FROM 	FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'										INNER JOIN (                                                                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'														SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, SEGMENT2 AS EPOST_FACTORY                                                                               ' + char(10)                
				SELECT @v_dSql +=	N'														FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK),                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'																   SCM_FACTORY_M B WITH(NOLOCK),                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'																   SCM_FACTORY_M C WITH(NOLOCK)                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'														WHERE	1=1                                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'														AND		A.LOOKUP_TYPE_CODE = ''ELEC_POST_FACTORY_MAP''                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'														AND		A.ACTIVE_FLAG	= ''Y''                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'														AND		A.SEGMENT1		= '''+ @p_instance_id +'''                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'														AND		A.SEGMENT2		= B.FACTORY_ID                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'														AND		B.ACTIVE_FLAG	= ''Y''                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'														AND		A.SEGMENT4		= C.FACTORY_ID                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'														AND		C.ACTIVE_FLAG	= ''Y''                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'													) X                                                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'											ON 1=1                                                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'											AND		A.COMPANY_ID 	= X.COMPANY_ID                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'											AND		A.DIVISION_ID	= X.DIVISION_ID                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'											AND		A.SITE_ID		= X.SITE_ID                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'											AND		A.PLANT_ID		= X.PLANT_ID                                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'											AND		A.FACTORY_ID	= X.EPOST_FACTORY                                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'			        			WHERE 	1=1                                                                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'			        			AND 	A.PLAN_TYPE		 = ''RELEASE''                                                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'			        			AND		A.OPERATION_ID	 IN	(''E2000'', ''E3000'', ''E4000'')                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'			        			AND 	CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_plan_date +''' -1                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'			        			AND		A.PLAN_QTY	 > 0                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			        			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'										, A.ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, CONVERT(VARCHAR,A.PLAN_DATE,112)                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'										, CASE WHEN A.OPERATION_ID = ''E2000'' THEN ''COATING_PLAN''                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'	        							  	   WHEN A.OPERATION_ID = ''E3000'' THEN ''ROLL_PRESS_PLAN''                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'	        							  	   WHEN A.OPERATION_ID = ''E4000'' THEN ''SLITTING_PLAN''                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'	        							  END                                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'	        							, CASE WHEN A.OPERATION_ID = ''E2000'' THEN ''60''                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'	        							  	   WHEN A.OPERATION_ID = ''E3000'' THEN ''50''                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'	        							  	   WHEN A.OPERATION_ID = ''E4000'' THEN ''40''                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'	        							  END                                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'	        					                                                                                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'							) A                                                                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'					) A                                                                                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'					INNER HASH JOIN SCM_ITEM_M E WITH(NOLOCK)                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'					ON  A.COMPANY_ID  = E.COMPANY_ID                                                                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'					AND A.DIVISION_ID = E.DIVISION_ID                                                                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'					AND A.SITE_ID	  = E.SITE_ID                                                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'					AND A.ITEM_ID	  = E.ITEM_ID                                                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'					AND E.ACTIVE_FLAG = ''Y''                                                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'					INNER HASH JOIN SCM_ITEM_CLASS_M F WITH(NOLOCK)                                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'					ON  E.ITEM_CLASS = F.CLASS_ID                                                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'					AND F.USE_FLAG = ''Y''                                                                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'					LEFT OUTER JOIN ATTR_TYPE B							                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'					ON 	1=1						                                                                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'					AND 	E.NICK_NAME LIKE B.ATTR_DEFINIT					                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'				WHERE 1=1            							                                                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'			) A                                                                                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'			INNER JOIN (																								' + char(10)
				SELECT @v_dSql +=	N'							SELECT DISTINCT A.COMPANY_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID				' + char(10)
				SELECT @v_dSql +=	N'							FROM SCM_ITEM_LANE_M A WITH(NOLOCK)															' + char(10)
				SELECT @v_dSql +=	N'							WHERE 1=1																					' + char(10)
				SELECT @v_dSql +=	N'							AND A.SITE_ID = '''+ @p_inner_site_id +'''																		' + char(10)
				SELECT @v_dSql +=	N'							AND A.ACTIVE_FLAG = ''Y''																		' + char(10)
				SELECT @v_dSql +=	N'							AND A.PROD_VERSION_TYPE = ''E3000E4000''																		' + char(10)
				SELECT @v_dSql +=	N'						) C																								' + char(10)
				SELECT @v_dSql +=	N'						ON 1=1																							' + char(10)
				SELECT @v_dSql +=	N'						AND A.SITE_ID = C.SITE_ID																		' + char(10)
				SELECT @v_dSql +=	N'						AND A.PLANT_ID = C.PLANT_ID																		' + char(10)
				-- ED 동 데이타가 누락되어 임시로 막음
				SELECT @v_dSql +=	N'						--AND A.FACTORY_ID = C.FACTORY_ID																	' + char(10)
				SELECT @v_dSql +=	N'						AND A.ITEM_ID = C.ITEM_ID																		' + char(10)
				SELECT @v_dSql +=	N'			LEFT OUTER HASH JOIN (                                                                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'									SELECT *                                                                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'									FROM #STOCK_T                                                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'			) B                                                                                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'			ON 1=1                                                                                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'			AND A.FACTORY_ID = B.FACTORY_ID                                                                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'			AND A.ITEM_ID = B.ITEM_ID     ' + char(10)
				SELECT @v_dSql +=	N'			AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE     ' + char(10)
				SELECT @v_dSql +=	N'			AND A.ATTR_TYPE = B.ATTR_TYPE                                                                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'	WHERE	1=1                                                                                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'	--AND		A.QTY > 0                                                                                                                                                                                                           ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ELECTRODE_TYPE' , 'EQ', @p_elec_type))       + char(10)
				SELECT @v_dSql +=	N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'			, A.ITEM_ID, A.NP_ITEM_ID, A.NICK_NAME , A.FLOW_ID, A.LEVEL_3_NAME                                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'			, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE                                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'			, A.CATEGORY_ID, A.CATEGORY_GROUP                                                                                                                                                                                       ' + char(10)                                                                       
				
				 exec sp_executesql @v_dSql
		     
				 exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'MAIN_P SELECT',@runstart, @runend
				
		END  -- TEMP MAIN_P


		SET	@v_dSql = ''

		SELECT @v_dSql +=	N'	WITH ITEM_ATTR AS (																														' + char(10)
		SELECT @v_dSql +=	N'					SELECT  CASE WHEN B.ATTR_DEFINIT IS NULL THEN ''B'' ELSE ''A'' END AS ATTR_TYPE												' + char(10)
		SELECT @v_dSql +=	N'							, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.ITEM_NAME, A.NICK_NAME, A.ITEM_TYPE, A.ITEM_CLASS		' + char(10)
		SELECT @v_dSql +=	N'					FROM	SCM_ITEM_M A WITH(NOLOCK)																						' + char(10)
		SELECT @v_dSql +=	N'							LEFT OUTER JOIN (																								' + char(10)
		SELECT @v_dSql +=	N'												SELECT 	DISTINCT SEGMENT4 AS ATTR_DEFINIT													' + char(10)
		SELECT @v_dSql +=	N'												FROM 	SCM_SYS_LOOKUP_VALUE LV																' + char(10)
		SELECT @v_dSql +=	N'												WHERE 	1=1																					' + char(10)
		SELECT @v_dSql +=	N'												AND 	LOOKUP_TYPE_CODE = ''E_POST_WH_ATTR_TYPE_DEFINIT''									' + char(10)
		SELECT @v_dSql +=	N'							) B																												' + char(10)
		SELECT @v_dSql +=	N'							ON 	1=1																											' + char(10)
		SELECT @v_dSql +=	N'							AND 	A.NICK_NAME LIKE B.ATTR_DEFINIT																			' + char(10)
		SELECT @v_dSql +=	N'					WHERE 1=1																												' + char(10)
		SELECT @v_dSql +=	N'					AND		A.ACTIVE_FLAG = ''Y''																								' + char(10)
		SELECT @v_dSql +=	N'					AND		A.SITE_ID = '''+ @p_inner_site_id +'''																								' + char(10)
		SELECT @v_dSql +=	N'	)																																		' + char(10)
		SELECT @v_dSql +=	N'	, ATTR_TYPE AS 							                                                                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'	(							                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'		SELECT 	DISTINCT SEGMENT1 AS INSTANCE_ID, FII.COMPANY_ID, FII.DIVISION_ID, FII.SITE_ID, FII.PLANT_ID, SEGMENT2 AS ATTR_TYPE, SEGMENT3 AS ATTR_CATEGORY, SEGMENT4 AS ATTR_DEFINIT					' + char(10)	
		SELECT @v_dSql +=	N'		FROM 	SCM_SYS_LOOKUP_VALUE LV						                                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'					JOIN 	FP_INSTANCE_INFO_V FII			                                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'					ON 	1=1			                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'					AND 	LV.SEGMENT1 = FII.INSTANCE_ID 			                                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'		WHERE 	1=1						                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'		AND 		LOOKUP_TYPE_CODE = ''E_POST_WH_ATTR_TYPE_DEFINIT''					                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'	)							                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'	,WH_CAPA AS 																																																								' + char(10)																																																										
		SELECT @v_dSql +=	N'			(												                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'				SELECT 	  FA.DIVISION_ID											                                                                        ' + char(10)
		SELECT @v_dSql +=	N'					, FA.SITE_ID 											                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'					, FA.PLANT_ID 											                                                                                ' + char(10)
		SELECT @v_dSql +=	N'					, MAX(PW.FACTORY_ID) AS FACTORY_ID											                                                            ' + char(10)
		SELECT @v_dSql +=	N'					, MAX(PWR.MTRL_CLSS_CODE) AS ROLL_TYPE											                                                        ' + char(10)
		SELECT @v_dSql +=	N'					, MAX(PWR.ELECTRODE_TYPE) AS ELECTRODE_TYPE											                                                    ' + char(10)
		SELECT @v_dSql +=	N'					,  PW.WH_ID											                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'					, MAX(PW.WH_NAME) AS WH_NAME				 							                                                                  ' + char(10)
		SELECT @v_dSql +=	N'					, MAX(RW.ATTR_TYPE) AS ATTR_TYPE											                                                              ' + char(10)
		SELECT @v_dSql +=	N'					, COUNT(*) AS WH_CAPA											                                                                          ' + char(10)
		SELECT @v_dSql +=	N'					, SUM(RW.WH_TEMP_CAPA) AS WH_TEMP_CAPA											                                                        ' + char(10)
		SELECT @v_dSql +=	N'				FROM 	SCM_MMD_PRDT_WH_RACK_M AS PWR											                                                              ' + char(10)
		SELECT @v_dSql +=	N'					JOIN SCM_MMD_MCS_RACK_M AS MR 											                                                                ' + char(10)
		SELECT @v_dSql +=	N'						ON	1=1									                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'						AND 	PWR.RACK_ID = MR.RACK_ID 									                                                                  ' + char(10)
		SELECT @v_dSql +=	N'					JOIN SCM_MMD_PRDT_WH_M AS PW											                                                                  ' + char(10)
		SELECT @v_dSql +=	N'						ON 	1=1									                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'						AND 	PWR.WH_ID = PW.WH_ID 									                                                                      ' + char(10)
		SELECT @v_dSql +=	N'					LEFT OUTER JOIN SCM_ROLL_WAREHOUSE_M RW											                                                        ' + char(10)
		SELECT @v_dSql +=	N'						ON 	1=1									                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'						AND 	PW.WH_ID = RW.WH_ID 									                                                                      ' + char(10)
		SELECT @v_dSql +=	N'					JOIN SCM_FACTORY_M FA											                                                                          ' + char(10)
		SELECT @v_dSql +=	N'						ON 	1=1									                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'						AND 	PW.FACTORY_ID = FA.FACTORY_ID 									                                                            ' + char(10)
		SELECT @v_dSql +=	N'				WHERE 	1=1											                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'				AND 	PWR.USE_FLAG = ''Y''											                                                                      ' + char(10)  
		SELECT @v_dSql +=	N'				AND 	MR.USE_FLAG = ''Y''											                                                                        ' + char(10)  
		SELECT @v_dSql +=	N'				AND  	PW.USE_FLAG = ''Y''											                                                                        ' + char(10)  
		SELECT @v_dSql +=	N'				AND 	PW.FACTORY_ID IN (SELECT FACTORY_ID FROM SCM_FACTORY_M WHERE SITE_ID = '''+ @p_inner_site_id +''' AND SHOP_GROUP_ID = ''E'')			' + char(10)								
		SELECT @v_dSql +=	N'				GROUP BY FA.DIVISION_ID, FA.SITE_ID, FA.PLANT_ID, PW.WH_ID												                                    ' + char(10)
		SELECT @v_dSql +=	N'			)												                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'			, WH_CAPA_GROUP AS												                                                                              ' + char(10)
		SELECT @v_dSql +=	N'			(												                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'				SELECT 	DISTINCT  SEGMENT1 AS INSTANCE_ID											                                                        ' + char(10)
		SELECT @v_dSql +=	N'						, FII.COMPANY_ID 											                                                                            ' + char(10)
		SELECT @v_dSql +=	N'						, FII.DIVISION_ID 											                                                                          ' + char(10)
		SELECT @v_dSql +=	N'						, FII.SITE_ID 											                                                                              ' + char(10)
		SELECT @v_dSql +=	N'						, FII.PLANT_ID 											                                                                              ' + char(10)
		SELECT @v_dSql +=	N'						, SEGMENT2 AS FACTORY_ID											                                                                    ' + char(10)
		SELECT @v_dSql +=	N'						, SEGMENT3 AS ROLL_TYPE											                                                                      ' + char(10)
		SELECT @v_dSql +=	N'						, SEGMENT4 AS ELECTRODE_TYPE											                                                                ' + char(10)
		SELECT @v_dSql +=	N'						, SEGMENT5 AS ATTR_TYPE											                                                                      ' + char(10)
		SELECT @v_dSql +=	N'						, ATTRIBUTE2 AS ATTR_TYPE_NAME											                                                              ' + char(10)
		SELECT @v_dSql +=	N'						, ATTRIBUTE1 AS TEMP_CAPA											                                                                    ' + char(10)
		SELECT @v_dSql +=	N'						, ATTRIBUTE3 AS WH_GROUP_NAME											                                                                ' + char(10)
		SELECT @v_dSql +=	N'				FROM 	SCM_SYS_LOOKUP_VALUE	LV										                                                                    ' + char(10)
		SELECT @v_dSql +=	N'						INNER JOIN FP_INSTANCE_INFO_V FII											                                                            ' + char(10)
		SELECT @v_dSql +=	N'						ON 	1=1								                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'						AND	LV.SEGMENT1 = FII.INSTANCE_ID								                                                                  ' + char(10)
		SELECT @v_dSql +=	N'				WHERE 	1=1											                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'				AND 	LOOKUP_TYPE_CODE = ''E_POST_WH_CAPA_DEFINIT''											                                              ' + char(10)  
		SELECT @v_dSql +=	N'			)												                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'			, WH_CAPA_TOTAL AS (                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'						SELECT 	  WCG.WH_GROUP_NAME									                                                                      ' + char(10)
		SELECT @v_dSql +=	N'								, WCG.COMPANY_ID									                                                                            ' + char(10)
		SELECT @v_dSql +=	N'								, WCG.DIVISION_ID 									                                                                          ' + char(10)
		SELECT @v_dSql +=	N'								, WCG.SITE_ID 									                                                                              ' + char(10)
		SELECT @v_dSql +=	N'								, WCG.PLANT_ID 									                                                                              ' + char(10)
		SELECT @v_dSql +=	N'								, WCG.FACTORY_ID 									                                                                            ' + char(10)
		SELECT @v_dSql +=	N'								, WCG.ROLL_TYPE 									                                                                            ' + char(10)
		SELECT @v_dSql +=	N'								, (CASE WHEN WCG.ELECTRODE_TYPE = ''A'' OR WCG.ELECTRODE_TYPE = ''Anode''  THEN ''Anode'' ELSE ''Cathode'' END) AS ELECTRODE_TYPE     ' + char(10)
		SELECT @v_dSql +=	N'								, WCG.ATTR_TYPE                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'								, WCG.ATTR_TYPE_NAME									                                                                        ' + char(10)
		SELECT @v_dSql +=	N'								, SUM(ISNULL(WC.WH_CAPA,0)) AS WH_CAPA									                                                      ' + char(10)
		SELECT @v_dSql +=	N'								, ISNULL(WCG.TEMP_CAPA,0) AS TEMP_CAPA									                                                      ' + char(10)
		SELECT @v_dSql +=	N'								, SUM(ISNULL(WC.WH_CAPA,0)) + WCG.TEMP_CAPA AS TOTAL_WH_CAPA									                                ' + char(10)
		SELECT @v_dSql +=	N'						FROM 	WH_CAPA_GROUP WCG									                                                                          ' + char(10)
		SELECT @v_dSql +=	N'							LEFT  OUTER hash JOIN 	WH_CAPA WC								                                                              ' + char(10)
		SELECT @v_dSql +=	N'							ON 	1=1								                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'							AND 	WCG.FACTORY_ID = WC.FACTORY_ID								                                                            ' + char(10)
		SELECT @v_dSql +=	N'							AND 	WCG.ROLL_TYPE = WC.ROLL_TYPE 								                                                              ' + char(10)
		SELECT @v_dSql +=	N'							AND 	WCG.ELECTRODE_TYPE = WC.ELECTRODE_TYPE 								                                                    ' + char(10)
		SELECT @v_dSql +=	N'							AND 	WCG.ATTR_TYPE = WC.ATTR_TYPE 								                                                              ' + char(10)
		SELECT @v_dSql +=	N'						WHERE 	1=1									                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'						GROUP BY WCG.WH_GROUP_NAME										                                                                    ' + char(10)
		SELECT @v_dSql +=	N'	 						, WCG.COMPANY_ID									                                                                              ' + char(10)
		SELECT @v_dSql +=	N'							, WCG.DIVISION_ID 									                                                                            ' + char(10)
		SELECT @v_dSql +=	N'							, WCG.SITE_ID 									                                                                                ' + char(10)
		SELECT @v_dSql +=	N'							, WCG.PLANT_ID 									                                                                                ' + char(10)
		SELECT @v_dSql +=	N'							, WCG.FACTORY_ID 									                                                                              ' + char(10)
		SELECT @v_dSql +=	N'							, WCG.ROLL_TYPE 									                                                                              ' + char(10)
		SELECT @v_dSql +=	N'							, WCG.ELECTRODE_TYPE 									                                                                          ' + char(10)
		SELECT @v_dSql +=	N'							, WCG.ATTR_TYPE                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'							, WCG.ATTR_TYPE_NAME									                                                                          ' + char(10)
		SELECT @v_dSql +=	N'							, WCG.TEMP_CAPA 									                                                                              ' + char(10)
		SELECT @v_dSql +=	N'			)                  ' + char(10)
		SELECT @v_dSql +=	N'	,	WH_CAPA_PIVOT AS (                 ' + char(10)
		SELECT @v_dSql +=	N'				SELECT	A.FACTORY_ID, A.ELECTRODE_TYPE, A.JR_COL, A.A_TYPE_COL, A.B_TYPE_COL								' + char(10)
		SELECT @v_dSql +=	N'						, MAX(CASE WHEN JR_COL = B.ATTR_TYPE THEN B.WH_CAPA ELSE 0 END) AS JR_WH_CAPA						' + char(10)
		SELECT @v_dSql +=	N'						, MAX(CASE WHEN JR_COL = B.ATTR_TYPE THEN B.TEMP_CAPA ELSE 0 END) AS JR_TEMP_CAPA					' + char(10)
		SELECT @v_dSql +=	N'						, MAX(CASE WHEN JR_COL = B.ATTR_TYPE THEN B.TOTAL_WH_CAPA ELSE 0 END) AS JR_TOTAL_WH_CAPA			' + char(10)
		SELECT @v_dSql +=	N'						, MAX(CASE WHEN A_TYPE_COL = B.ATTR_TYPE THEN B.WH_CAPA ELSE 0 END) AS A_TYPE_WH_CAPA				' + char(10)
		SELECT @v_dSql +=	N'						, MAX(CASE WHEN A_TYPE_COL = B.ATTR_TYPE THEN B.TEMP_CAPA ELSE 0 END) AS A_TYPE_TEMP_CAPA			' + char(10)
		SELECT @v_dSql +=	N'						, MAX(CASE WHEN A_TYPE_COL = B.ATTR_TYPE THEN B.TOTAL_WH_CAPA ELSE 0 END) AS A_TYPE_TOTAL_WH_CAPA	' + char(10)
		SELECT @v_dSql +=	N'						, MAX(CASE WHEN B_TYPE_COL = B.ATTR_TYPE THEN B.WH_CAPA ELSE 0 END) AS B_TYPE_WH_CAPA				' + char(10)
		SELECT @v_dSql +=	N'						, MAX(CASE WHEN B_TYPE_COL = B.ATTR_TYPE THEN B.TEMP_CAPA ELSE 0 END) AS B_TYPE_TEMP_CAPA			' + char(10)
		SELECT @v_dSql +=	N'						, MAX(CASE WHEN B_TYPE_COL = B.ATTR_TYPE THEN B.TOTAL_WH_CAPA ELSE 0 END) AS B_TYPE_TOTAL_WH_CAPA	' + char(10)
		SELECT @v_dSql +=	N'				FROM (																										' + char(10)
		SELECT @v_dSql +=	N'						SELECT FACTORY_ID, ELECTRODE_TYPE, [-] AS JR_COL, [A] AS A_TYPE_COL, [B] AS B_TYPE_COL				' + char(10)
		SELECT @v_dSql +=	N'						FROM(																								' + char(10)
		SELECT @v_dSql +=	N'								SELECT FACTORY_ID, ELECTRODE_TYPE, ATTR_TYPE												' + char(10)
		SELECT @v_dSql +=	N'								FROM WH_CAPA_TOTAL																			' + char(10)
		SELECT @v_dSql +=	N'						) AS RESULT																							' + char(10)
		SELECT @v_dSql +=	N'						PIVOT (																								' + char(10)
		SELECT @v_dSql +=	N'							MAX(ATTR_TYPE) FOR ATTR_TYPE IN ([-], [A], [B])													' + char(10)
		SELECT @v_dSql +=	N'						) AS PIV																							' + char(10)
		SELECT @v_dSql +=	N'					) A																										' + char(10)
		SELECT @v_dSql +=	N'					, WH_CAPA_TOTAL B																						' + char(10)
		SELECT @v_dSql +=	N'				WHERE 1=1																									' + char(10)
		SELECT @v_dSql +=	N'				AND A.FACTORY_ID = B.FACTORY_ID																				' + char(10)
		SELECT @v_dSql +=	N'				AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE																		' + char(10)
		SELECT @v_dSql +=	N'				GROUP BY A.FACTORY_ID, A.ELECTRODE_TYPE, A.JR_COL, A.A_TYPE_COL, A.B_TYPE_COL								' + char(10)
		SELECT @v_dSql +=	N'			)                  ' + char(10)
		
		SELECT @v_dSql +=	N'	, MAIN_T AS (                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'				  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                        ' + char(10)
		SELECT @v_dSql +=	N'				       , A.ITEM_ID, A.NICK_NAME, A.FLOW_ID, A.NP_ITEM_ID    ' + char(10)
		SELECT @v_dSql +=	N'				       , A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE					' + char(10)
		SELECT @v_dSql +=	N'				       , A.LEVEL_3_NAME                                                              ' + char(10)
		SELECT @v_dSql +=	N'				  	   , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_GROUP                                      ' + char(10)
		--SELECT @v_dSql +=	N'				  	   , CONCAT( REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.JR_BOH / '+@p_unit+') ,0) AS MONEY),1),''.00'','''') 	, char(13),char(10),                                                                   ' + char(10)
		--SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.JR_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS JR_BOH                      ' + char(10)
		--SELECT @v_dSql +=	N'				  	   , CONCAT( REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.RP_BOH / '+@p_unit+') ,0) AS MONEY),1),''.00'','''') 	, char(13),char(10),                                                                   ' + char(10)
		--SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.RP_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS RP_BOH                      ' + char(10)
		--SELECT @v_dSql +=	N'				  	   , CASE WHEN A.ATTR_TYPE = ''A'' THEN                                                                    ' + char(10)
		--SELECT @v_dSql +=	N'				  											CONCAT( REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.A_TYPE_BOH / '+@p_unit+') ,0) AS MONEY),1),''.00'','''') 	, char(13),char(10),                                      ' + char(10)
		--SELECT @v_dSql +=	N'				  	   											+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.A_TYPE_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) ELSE ''-'' END AS A_TYPE_BOH                      ' + char(10)
		--SELECT @v_dSql +=	N'				  	   , CASE WHEN A.ATTR_TYPE = ''B'' THEN                                                                    ' + char(10)
		--SELECT @v_dSql +=	N'				  											CONCAT( REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.B_TYPE_BOH / '+@p_unit+') ,0) AS MONEY),1),''.00'','''')	, char(13),char(10),                                                                    ' + char(10)
		--SELECT @v_dSql +=	N'				  	   											+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.B_TYPE_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) ELSE ''-'' END  AS B_TYPE_BOH                      ' + char(10)
		--SELECT @v_dSql +=	N'				  	   , CONCAT( REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.ASSY_BOH / '+@p_unit+') ,0) AS MONEY),1),''.00'','''')  	, char(13),char(10),                                                                  ' + char(10)
		--SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.ASSY_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS ASSY_BOH                      ' + char(10)
		
		SELECT @v_dSql +=	N'				  	   , CONCAT( FORMAT( ISNULL( MAX(A.JR_BOH / '+@p_unit+') ,0) , ''#,###,##0.##'') , char(13),char(10),                                                                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.JR_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS JR_BOH                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CONCAT( FORMAT( ISNULL( MAX(A.RP_BOH / '+@p_unit+') ,0) , ''#,###,##0.##'') , char(13),char(10),                                                                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.RP_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS RP_BOH                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CASE WHEN A.ATTR_TYPE = ''A'' THEN                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				  											CONCAT( FORMAT( ISNULL( MAX(A.A_TYPE_BOH / '+@p_unit+') ,0) , ''#,###,##0.##'') , char(13),char(10),                                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   											+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.A_TYPE_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) ELSE ''-'' END AS A_TYPE_BOH                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CASE WHEN A.ATTR_TYPE = ''B'' THEN                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				  											CONCAT( FORMAT( ISNULL( MAX(A.B_TYPE_BOH / '+@p_unit+') ,0) , ''#,###,##0.##'') , char(13),char(10),                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				  	   											+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.B_TYPE_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) ELSE ''-'' END  AS B_TYPE_BOH                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CONCAT( FORMAT( ISNULL( MAX(A.ASSY_BOH / '+@p_unit+') ,0) , ''#,###,##0.##'') , char(13),char(10),                                                                  ' + char(10)
		SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.ASSY_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS ASSY_BOH                      ' + char(10)

		SELECT @v_dSql +=	N'				  	   , MAX(A.JR_BOH) AS JR_BOH_QTY                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.RP_BOH) AS RP_BOH_QTY                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.A_TYPE_BOH) AS A_TYPE_BOH_QTY                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.B_TYPE_BOH) AS B_TYPE_BOH_QTY                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.ASSY_BOH) AS ASSY_BOH_QTY                   ' + char(10)

		--SELECT @v_dSql +=	N'				  	   , CONCAT( REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.JR_BOH_ONLYHOLD / '+@p_unit+') ,0) AS MONEY),1),''.00'','''') 	, char(13),char(10),                                                                   ' + char(10)
		--SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.JR_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS JR_BOH_ONLYHOLD                      ' + char(10)
		--SELECT @v_dSql +=	N'				  	   , CONCAT( REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.RP_BOH_ONLYHOLD / '+@p_unit+') ,0) AS MONEY),1),''.00'','''') 	, char(13),char(10),                                                                   ' + char(10)
		--SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.RP_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS RP_BOH_ONLYHOLD                      ' + char(10)
		--SELECT @v_dSql +=	N'				  	   , CASE WHEN A.ATTR_TYPE = ''A'' THEN                                                                    ' + char(10)
		--SELECT @v_dSql +=	N'				  											CONCAT( REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.A_TYPE_BOH_ONLYHOLD / '+@p_unit+') ,0) AS MONEY),1),''.00'','''') 	, char(13),char(10),                                      ' + char(10)
		--SELECT @v_dSql +=	N'				  	   											+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.A_TYPE_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) ELSE ''-'' END AS A_TYPE_BOH_ONLYHOLD                      ' + char(10)
		--SELECT @v_dSql +=	N'				  	   , CASE WHEN A.ATTR_TYPE = ''B'' THEN                                                                    ' + char(10)
		--SELECT @v_dSql +=	N'				  											CONCAT( REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.B_TYPE_BOH_ONLYHOLD / '+@p_unit+') ,0) AS MONEY),1),''.00'','''')	, char(13),char(10),                                                                    ' + char(10)
		--SELECT @v_dSql +=	N'				  	   											+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.B_TYPE_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) ELSE ''-'' END  AS B_TYPE_BOH_ONLYHOLD                      ' + char(10)
		--SELECT @v_dSql +=	N'				  	   , CONCAT( REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.ASSY_BOH_ONLYHOLD / '+@p_unit+') ,0) AS MONEY),1),''.00'','''')  	, char(13),char(10),                                                                  ' + char(10)
		--SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.ASSY_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS ASSY_BOH_ONLYHOLD                      ' + char(10)
		
		SELECT @v_dSql +=	N'				  	   , CONCAT( FORMAT (ISNULL( MAX(A.JR_BOH_ONLYHOLD / '+@p_unit+') ,0), ''#,###,##0.##'')	, char(13),char(10),                                                                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.JR_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS JR_BOH_ONLYHOLD                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CONCAT( FORMAT (ISNULL( MAX(A.RP_BOH_ONLYHOLD / '+@p_unit+') ,0), ''#,###,##0.##'')	, char(13),char(10),                                                                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.RP_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS RP_BOH_ONLYHOLD                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CASE WHEN A.ATTR_TYPE = ''A'' THEN                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				  											CONCAT( FORMAT (ISNULL( MAX(A.A_TYPE_BOH_ONLYHOLD / '+@p_unit+') ,0), ''#,###,##0.##'')	, char(13),char(10),                                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   											+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.A_TYPE_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) ELSE ''-'' END AS A_TYPE_BOH_ONLYHOLD                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CASE WHEN A.ATTR_TYPE = ''B'' THEN                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				  											CONCAT( FORMAT (ISNULL( MAX(A.B_TYPE_BOH_ONLYHOLD / '+@p_unit+') ,0), ''#,###,##0.##'')	, char(13),char(10),                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				  	   											+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.B_TYPE_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) ELSE ''-'' END  AS B_TYPE_BOH_ONLYHOLD                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CONCAT( FORMAT (ISNULL( MAX(A.ASSY_BOH_ONLYHOLD / '+@p_unit+') ,0), ''#,###,##0.##'')	, char(13),char(10),                                                                  ' + char(10)
		SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.ASSY_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS ASSY_BOH_ONLYHOLD                      ' + char(10)
		
		SELECT @v_dSql +=	N'				  	   , MAX(A.JR_BOH_ONLYHOLD) AS JR_BOH_QTY_ONLYHOLD                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.RP_BOH_ONLYHOLD) AS RP_BOH_QTY_ONLYHOLD                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.A_TYPE_BOH_ONLYHOLD) AS A_TYPE_BOH_QTY_ONLYHOLD                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.B_TYPE_BOH_ONLYHOLD) AS B_TYPE_BOH_QTY_ONLYHOLD                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.ASSY_BOH_ONLYHOLD) AS ASSY_BOH_QTY_ONLYHOLD                  ' + char(10)

		SELECT @v_dSql +=	N'			           , NULL AS JR_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'			           , NULL AS A_TYPE_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'			           , NULL AS B_TYPE_WH_CAPA                                ' + char(10)

		SELECT @v_dSql +=   N'						, ''P'' AS PSI               ' + char(10)
		SELECT @v_dSql +=   N'						, ''DATA'' AS DATA_TYPE                                     ' + char(10)

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

					SELECT @v_dSql += N'                , SUM(CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' AND B.CATEGORY_ID = ''SLITTING_ROLL_PLAN'' AND A.CATEGORY_ID = ''SLITTING_PLAN''  THEN A.ROLL_QTY ' + char(10)
					SELECT @v_dSql += N'						   WHEN C.YYYYMM = ''' + @sub_param_0 + ''' AND B.CATEGORY_ID = ''ROLL_PRESS_ROLL_PLAN'' AND A.CATEGORY_ID = ''ROLL_PRESS_PLAN''  THEN A.ROLL_QTY ' + char(10)
					SELECT @v_dSql += N'                		   WHEN C.YYYYMM = ''' + @sub_param_0 + ''' AND B.CATEGORY_ID = A.CATEGORY_ID THEN A.QTY ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
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

					SELECT @v_dSql += N'                , SUM(CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' AND B.CATEGORY_ID = ''SLITTING_ROLL_PLAN'' AND A.CATEGORY_ID = ''SLITTING_PLAN''  THEN A.ROLL_QTY ' + char(10)
					SELECT @v_dSql += N'						   WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' AND B.CATEGORY_ID = ''ROLL_PRESS_ROLL_PLAN'' AND A.CATEGORY_ID = ''ROLL_PRESS_PLAN''  THEN A.ROLL_QTY ' + char(10)
					SELECT @v_dSql += N'                		   WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' AND B.CATEGORY_ID = A.CATEGORY_ID THEN A.QTY ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)

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

					SELECT @v_dSql += N'                , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' AND B.CATEGORY_ID = ''SLITTING_ROLL_PLAN'' AND A.CATEGORY_ID = ''SLITTING_PLAN''  THEN A.ROLL_QTY ' + char(10)
					SELECT @v_dSql += N'						   WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' AND B.CATEGORY_ID = ''ROLL_PRESS_ROLL_PLAN'' AND A.CATEGORY_ID = ''ROLL_PRESS_PLAN''  THEN A.ROLL_QTY ' + char(10)
					SELECT @v_dSql += N'                		   WHEN A.PLAN_DATE = ''' + @sub_param_0 + ''' AND B.CATEGORY_ID = A.CATEGORY_ID THEN A.QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''
		
		
		SELECT @v_dSql +=	N'							FROM (                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'									SELECT A.*                                                                                                       ' + char(10)
		--SELECT @v_dSql +=	N'											, ISNULL(F.LEVEL_3_NAME,''-'') AS LEVEL_3_NAME                                                     ' + char(10)
		SELECT @v_dSql +=	N'											, CEILING(A.QTY / ISNULL(S.M_PER_ROLL_QTY,1)) AS ROLL_QTY                                         ' + char(10)
		SELECT @v_dSql +=	N'									FROM	 #MAIN_P A                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'											 INNER HASH JOIN SCM_ITEM_M E WITH(NOLOCK)                                                                          ' + char(10)
		SELECT @v_dSql +=	N'											 ON  A.COMPANY_ID  = E.COMPANY_ID                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'											 AND A.DIVISION_ID = E.DIVISION_ID                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'											 AND A.SITE_ID	  = E.SITE_ID                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'											 AND A.ITEM_ID	  = E.ITEM_ID                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'											 AND E.ACTIVE_FLAG = ''Y''                                                                                            ' + char(10)
		--SELECT @v_dSql +=	N'											 INNER HASH JOIN SCM_ITEM_CLASS_M F WITH(NOLOCK)                                                                    ' + char(10)
		--SELECT @v_dSql +=	N'											 ON  E.ITEM_CLASS = F.CLASS_ID                                                                                      ' + char(10)
		--SELECT @v_dSql +=	N'											 AND F.USE_FLAG = ''Y''                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'											 LEFT OUTER HASH JOIN #LANE_T S WITH(NOLOCK)		' + char(10)                                                                      
		SELECT @v_dSql +=	N'											 ON  A.COMPANY_ID		= S.COMPANY_ID              ' + char(10)                                                                     
		SELECT @v_dSql +=	N'											 AND A.DIVISION_ID		= S.DIVISION_ID             ' + char(10)                                                                     
		SELECT @v_dSql +=	N'											 AND A.SITE_ID			= S.SITE_ID                 ' + char(10)  
		SELECT @v_dSql +=	N'											 AND A.PLANT_ID		= S.PLANT_ID                 ' + char(10)
		SELECT @v_dSql +=	N'											 AND A.FACTORY_ID		= S.FACTORY_ID 				' + char(10)
		SELECT @v_dSql +=	N'											 AND A.ELECTRODE_TYPE	= S.ELECTRODE_TYPE 			' + char(10)
		SELECT @v_dSql +=	N'											 AND A.ATTR_TYPE		= S.ATTR_TYPE 				' + char(10)
		SELECT @v_dSql +=	N'											 AND A.ITEM_ID			= S.ITEM_ID 				' + char(10)
		SELECT @v_dSql +=	N'									WHERE 1=1                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'									  AND NOT EXISTS (                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'														SELECT	1                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'														FROM	SCM_SYS_LOOKUP_VALUE AA                                                                                ' + char(10)
		SELECT @v_dSql +=	N'														WHERE	1=1                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'														AND		AA.LOOKUP_TYPE_CODE = ''E_POST_EXCEPT_PANCAKE''                                                          ' + char(10)
		SELECT @v_dSql +=	N'														AND		AA.ACTIVE_FLAG = ''Y''                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'														AND		AA.SEGMENT1 = '''+ @p_instance_id +'''                                                                              ' + char(10)
		SELECT @v_dSql +=	N'														AND		AA.SEGMENT2 = A.ITEM_ID                                                                                ' + char(10)
		SELECT @v_dSql +=	N'													 )                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'				      ) A                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'				      INNER JOIN (                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'							      	SELECT *                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'							      	FROM (                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'							      			SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER, '''' AS CATEGORY_GROUP										                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'	 										UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 										SELECT ''NOTCHING_PLAN'' AS CATEGORY_ID, ''NOTCHING PLAN'' AS CATEGORY_NAME, 130 AS CATEGORY_ORDER, ''130'' AS CATEGORY_GROUP                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'	 										UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'											SELECT ''INTRANSIT'' AS CATEGORY_ID, ''INTRANSIT'' AS CATEGORY_NAME, 100 AS CATEGORY_ORDER, ''100'' AS CATEGORY_GROUP                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'	 										UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'											SELECT ''SHIPMENT_PLAN'' AS CATEGORY_ID, ''SHIPMENT PLAN'' AS CATEGORY_NAME, 140 AS CATEGORY_ORDER, ''140'' AS CATEGORY_GROUP                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'	 										UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 										SELECT ''SLITTING_PLAN'' AS CATEGORY_ID, ''SLITTING PLAN'' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER, ''80'' AS CATEGORY_GROUP                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'	 										UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 										SELECT ''SLITTING_ROLL_PLAN'' AS CATEGORY_ID, ''SLITTING PLAN(Roll)'' AS CATEGORY_NAME, 90 AS CATEGORY_ORDER, ''90'' AS CATEGORY_GROUP                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'	 										UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 										SELECT ''ROLL_PRESS_PLAN'' AS CATEGORY_ID, ''ROLL PRESS PLAN'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER, ''40'' AS CATEGORY_GROUP                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'	 										UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 										SELECT ''ROLL_PRESS_ROLL_PLAN'' AS CATEGORY_ID, ''ROLL PRESS PLAN(Roll)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER, ''50'' AS CATEGORY_GROUP                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'	 										UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 										SELECT ''COATING_PLAN'' AS CATEGORY_ID, ''COATING PLAN'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER, ''10'' AS CATEGORY_GROUP                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'	 										UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 										SELECT ''MOVING_PLAN'' AS CATEGORY_ID, ''MOVING PLAN'' AS CATEGORY_NAME, 135 AS CATEGORY_ORDER, ''135'' AS CATEGORY_GROUP                ' + char(10)
		SELECT @v_dSql +=	N'					      				) BB                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'					      			WHERE CATEGORY_ID <> ''X''                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'				      ) B                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'				      ON 1=1                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'				      INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                          ' + char(10)
		SELECT @v_dSql +=	N'				      ON  A.PLAN_DATE = C.YYYYMMDD                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'				      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                          ' + char(10)
		SELECT @v_dSql +=	N'				             , A.ITEM_ID, A.NICK_NAME, A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.LEVEL_3_NAME                              ' + char(10)
		SELECT @v_dSql +=	N'				      	     , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_GROUP                                        ' + char(10)
		SELECT @v_dSql +=	N'				)                                                                                                                        ' + char(10)
		
		SELECT @v_dSql +=	N'	, MAIN_I AS (                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'				  SELECT /*+materialize*/ A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.FLOW_ID, A.NP_ITEM_ID                                        ' + char(10)
		--SELECT @v_dSql +=	N'				  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.FLOW_ID, A.NP_ITEM_ID                                        ' + char(10)
		SELECT @v_dSql +=	N'				       , A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.LEVEL_3_NAME                                                              ' + char(10)
		SELECT @v_dSql +=	N'				  	   , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.CATEGORY_GROUP                                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , A.JR_BOH , A.RP_BOH , A.A_TYPE_BOH , A.B_TYPE_BOH , A.ASSY_BOH                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , A.JR_BOH_QTY                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , A.RP_BOH_QTY                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , A.A_TYPE_BOH_QTY                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , A.B_TYPE_BOH_QTY                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , A.ASSY_BOH_QTY                   ' + char(10)

		SELECT @v_dSql +=	N'				  	   , A.JR_BOH_ONLYHOLD , A.RP_BOH_ONLYHOLD , A.A_TYPE_BOH_ONLYHOLD , A.B_TYPE_BOH_ONLYHOLD , A.ASSY_BOH_ONLYHOLD                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , A.JR_BOH_QTY_ONLYHOLD                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , A.RP_BOH_QTY_ONLYHOLD                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , A.A_TYPE_BOH_QTY_ONLYHOLD                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , A.B_TYPE_BOH_QTY_ONLYHOLD                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , A.ASSY_BOH_QTY_ONLYHOLD                   ' + char(10)
		SELECT @v_dSql +=	N'					   , A.JR_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'					   , A.A_TYPE_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'					   , A.B_TYPE_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'					   , A.PSI               ' + char(10)
		SELECT @v_dSql +=	N'					   , A.DATA_TYPE                                     ' + char(10)
		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
		
				-- month info
				SET @mst_loop_cnt = 0;
			
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'			, NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					
					SET @mst_loop_cnt = @mst_loop_cnt + 1 ;
				END		-- end of @mst_loop_cnt < @max_loop_cnt

				-- week info
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- Day bucket
				SET @mst_loop_cnt = 0	
				
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN

					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = ''
					SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_bucket , @v_row_delimiter , @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END
					
					SELECT @v_dSql += N'			, CASE WHEN A.CATEGORY_ID = ''EOH_ELEC_QTY'' AND D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) + ' < 0 THEN 0 ' +  char(10)
					SELECT @v_dSql += N'				   WHEN A.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) + ' < 0 THEN 0 ELSE D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +  ' END AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +  char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql +=	N'				FROM (                                    ' + char(10)
		SELECT @v_dSql +=	N'				  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                        ' + char(10)
		SELECT @v_dSql +=	N'				       , A.ITEM_ID, ISNULL(E.NICK_NAME,''-'') AS NICK_NAME, A.FLOW_ID, A.NP_ITEM_ID                                           ' + char(10)
		SELECT @v_dSql +=	N'				       , A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE                                           ' + char(10)
		SELECT @v_dSql +=	N'				       , ISNULL(F.LEVEL_3_NAME,''-'') AS LEVEL_3_NAME                                                              ' + char(10)
		SELECT @v_dSql +=	N'				  	   , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_GROUP                                      ' + char(10)


		SELECT @v_dSql +=	N'				  	   , CONCAT( FORMAT( ISNULL( MAX(A.JR_BOH / '+@p_unit+') ,0) , ''#,###,##0.##'') , char(13),char(10),                                                                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.JR_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS JR_BOH                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CONCAT( FORMAT( ISNULL( MAX(A.RP_BOH / '+@p_unit+') ,0) , ''#,###,##0.##'') , char(13),char(10),                                                                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.RP_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS RP_BOH                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CASE WHEN A.ATTR_TYPE = ''A'' THEN                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				  											CONCAT( FORMAT( ISNULL( MAX(A.A_TYPE_BOH / '+@p_unit+') ,0) , ''#,###,##0.##'') , char(13),char(10),                                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   											+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.A_TYPE_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) ELSE ''-'' END AS A_TYPE_BOH                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CASE WHEN A.ATTR_TYPE = ''B'' THEN                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				  											CONCAT( FORMAT( ISNULL( MAX(A.B_TYPE_BOH / '+@p_unit+') ,0) , ''#,###,##0.##'') , char(13),char(10),                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				  	   											+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.B_TYPE_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) ELSE ''-'' END  AS B_TYPE_BOH                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CONCAT( FORMAT( ISNULL( MAX(A.ASSY_BOH / '+@p_unit+') ,0) , ''#,###,##0.##'') , char(13),char(10),                                                                  ' + char(10)
		SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.ASSY_R_BOH) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS ASSY_BOH                      ' + char(10)

		SELECT @v_dSql +=	N'				  	   , MAX(A.JR_BOH) AS JR_BOH_QTY                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.RP_BOH) AS RP_BOH_QTY                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.A_TYPE_BOH) AS A_TYPE_BOH_QTY                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.B_TYPE_BOH) AS B_TYPE_BOH_QTY                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.ASSY_BOH) AS ASSY_BOH_QTY                   ' + char(10)

		SELECT @v_dSql +=	N'				  	   , CONCAT( FORMAT (ISNULL( MAX(A.JR_BOH_ONLYHOLD / '+@p_unit+') ,0), ''#,###,##0.##'')	, char(13),char(10),                                                                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.JR_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS JR_BOH_ONLYHOLD                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CONCAT( FORMAT (ISNULL( MAX(A.RP_BOH_ONLYHOLD / '+@p_unit+') ,0), ''#,###,##0.##'')	, char(13),char(10),                                                                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.RP_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS RP_BOH_ONLYHOLD                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CASE WHEN A.ATTR_TYPE = ''A'' THEN                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				  											CONCAT( FORMAT (ISNULL( MAX(A.A_TYPE_BOH_ONLYHOLD / '+@p_unit+') ,0), ''#,###,##0.##'')	, char(13),char(10),                                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   											+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.A_TYPE_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) ELSE ''-'' END AS A_TYPE_BOH_ONLYHOLD                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CASE WHEN A.ATTR_TYPE = ''B'' THEN                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				  											CONCAT( FORMAT (ISNULL( MAX(A.B_TYPE_BOH_ONLYHOLD / '+@p_unit+') ,0), ''#,###,##0.##'')	, char(13),char(10),                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				  	   											+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.B_TYPE_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) ELSE ''-'' END  AS B_TYPE_BOH_ONLYHOLD                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , CONCAT( FORMAT (ISNULL( MAX(A.ASSY_BOH_ONLYHOLD / '+@p_unit+') ,0), ''#,###,##0.##'')	, char(13),char(10),                                                                  ' + char(10)
		SELECT @v_dSql +=	N'				  	   		+ ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( MAX(A.ASSY_R_BOH_ONLYHOLD) ,0) AS MONEY),1),''.00'','''') + '')'' ) AS ASSY_BOH_ONLYHOLD                      ' + char(10)

		SELECT @v_dSql +=	N'				  	   , MAX(A.JR_BOH_ONLYHOLD) AS JR_BOH_QTY_ONLYHOLD                      ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.RP_BOH_ONLYHOLD) AS RP_BOH_QTY_ONLYHOLD                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.A_TYPE_BOH_ONLYHOLD) AS A_TYPE_BOH_QTY_ONLYHOLD                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.B_TYPE_BOH_ONLYHOLD) AS B_TYPE_BOH_QTY_ONLYHOLD                   ' + char(10)
		SELECT @v_dSql +=	N'				  	   , MAX(A.ASSY_BOH_ONLYHOLD) AS ASSY_BOH_QTY_ONLYHOLD                   ' + char(10)

		SELECT @v_dSql +=	N'					   , NULL AS JR_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'					   , NULL AS A_TYPE_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'					   , NULL AS B_TYPE_WH_CAPA                                ' + char(10)

		SELECT @v_dSql +=	N'						, ''I'' AS PSI               ' + char(10)
		SELECT @v_dSql +=	N'						, ''DATA'' AS DATA_TYPE                                     ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
		
				-- month info
				SET @mst_loop_cnt = 0;
			
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'			, NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					
					SET @mst_loop_cnt = @mst_loop_cnt + 1 ;
				END		-- end of @mst_loop_cnt < @max_loop_cnt

				-- week info
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- Day bucket
				SET @mst_loop_cnt = 0	
				
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN

					SET @mst_loop_cnt =  @mst_loop_cnt + 1
					SET @tmp_column = ''
					SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @p_bucket , @v_row_delimiter , @mst_loop_cnt)
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
					
					IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column , @sub_v_delimiter , 1)   END
					
					SELECT @v_dSql += N'			, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_JR_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_JR_QTY_A ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_JR_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_JR_QTY_B ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_JR_PRE_QTY'' THEN A.EOH_JR_PRE_QTY ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_JR_POST_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_JR_POST_QTY ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_JR_POST_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN 0 ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ASSY_QTY'' THEN A.EOH_ASSY_QTY ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_PC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_PC_QTY_A ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_PC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_PC_QTY_B ' + char(10)
						
					IF ''+ @sub_param_0 +'' <= '' + @p_plan_date + '' BEGIN
						SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A ' + char(10)
						SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B ' + char(10)
					END ELSE BEGIN
						-- 누적값으로 계산되어 더블 누적으로 계산
						--SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A + EOH_ASSY_QTY2 ' + char(10)
						--SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B + EOH_ASSY_QTY2 ' + char(10)
						SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A + (CASE WHEN EOH_ASSY_QTY > 0 THEN 0 ELSE EOH_ASSY_QTY END)  ' + char(10)
						SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B + (CASE WHEN EOH_ASSY_QTY > 0 THEN 0 ELSE EOH_ASSY_QTY END) ' + char(10)
					END

					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_JR_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_JR_QTY_A_HOLD ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_JR_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_JR_QTY_B_HOLD ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_JR_PRE_QTY_HOLD'' THEN A.EOH_JR_PRE_QTY_HOLD ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_JR_POST_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_JR_POST_QTY_HOLD ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_JR_POST_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000'' THEN 0 ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ASSY_QTY_HOLD'' THEN A.EOH_ASSY_QTY_HOLD ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_PC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_PC_QTY_A_HOLD ' + char(10)
					SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_PC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_PC_QTY_B_HOLD ' + char(10)
						
					IF ''+ @sub_param_0 +'' <= '' + @p_plan_date + '' BEGIN
						SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A_HOLD ' + char(10)
						SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B_HOLD ' + char(10)
					END ELSE BEGIN
						--SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A_HOLD + EOH_ASSY_QTY2_HOLD ' + char(10)
						--SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B_HOLD + EOH_ASSY_QTY2_HOLD ' + char(10)
						SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A_HOLD + (CASE WHEN EOH_ASSY_QTY_HOLD > 0 THEN 0 ELSE EOH_ASSY_QTY_HOLD END)  ' + char(10)
						SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B_HOLD + (CASE WHEN EOH_ASSY_QTY_HOLD > 0 THEN 0 ELSE EOH_ASSY_QTY_HOLD END) ' + char(10)
					END

					SELECT @v_dSql += N'					   ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +  char(10)
				END		-- end of @mst_loop_cnt < @max_loop_cnt

			END		--end of @max_loop_cnt

		END		-- end of isnull(@p_bucket,'') <> ''

		
		SELECT @v_dSql += N'	  FROM   (                                                         ' + char(10)
		SELECT @v_dSql +=	N'					SELECT	A.*                       ' + char(10)
		SELECT @v_dSql +=	N'							, (CASE WHEN SUM(EOH_ASSY_QTY) OVER ( PARTITION BY A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE ORDER BY A.PLAN_DATE) > 0 THEN 0                        ' + char(10)
		SELECT @v_dSql +=	N'									ELSE SUM(EOH_ASSY_QTY) OVER ( PARTITION BY A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE ORDER BY A.PLAN_DATE) END ) AS EOH_ASSY_QTY2                       ' + char(10)
		SELECT @v_dSql +=	N'							, (CASE WHEN SUM(EOH_ASSY_QTY_HOLD) OVER ( PARTITION BY A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE ORDER BY A.PLAN_DATE) > 0 THEN 0                        ' + char(10)
		SELECT @v_dSql +=	N'									ELSE SUM(EOH_ASSY_QTY_HOLD) OVER ( PARTITION BY A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE ORDER BY A.PLAN_DATE) END ) AS EOH_ASSY_QTY2_HOLD                       ' + char(10)
		SELECT @v_dSql +=	N'					FROM	(                       ' + char(10)
		SELECT @v_dSql +=	N'								SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, NULL AS PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE                       ' + char(10)
		SELECT @v_dSql +=	N'									, D.PRE_RP_JR AS JR_BOH, D.PRE_ST_JR AS RP_BOH, D.POST_ST_PC AS A_TYPE_BOH, D.POST_ST_PC AS B_TYPE_BOH, D.ASSY_PC AS ASSY_BOH																													 ' + char(10)               
		SELECT @v_dSql +=	N'									, D.PRE_RP_JR_R AS JR_R_BOH, D.PRE_ST_JR_R AS RP_R_BOH, D.POST_ST_PC_R AS A_TYPE_R_BOH, D.POST_ST_PC_R AS B_TYPE_R_BOH, D.ASSY_PC_R AS ASSY_R_BOH                    																			 ' + char(10)
		SELECT @v_dSql +=	N'									, D.PRE_RP_JR_HOLD AS JR_BOH_HOLD, D.PRE_ST_JR_HOLD AS RP_BOH_HOLD, D.POST_ST_PC_HOLD AS A_TYPE_BOH_HOLD, D.POST_ST_PC_HOLD AS B_TYPE_BOH_HOLD, D.ASSY_PC_HOLD AS ASSY_BOH_HOLD                    												 ' + char(10)
		SELECT @v_dSql +=	N'									, D.PRE_RP_JR_R_HOLD AS JR_R_BOH_HOLD, D.PRE_ST_JR_R_HOLD AS RP_R_BOH_HOLD, D.POST_ST_PC_R_HOLD AS A_TYPE_R_BOH_HOLD, D.POST_ST_PC_R_HOLD AS B_TYPE_R_BOH_HOLD, D.ASSY_PC_R_HOLD AS ASSY_R_BOH_HOLD												 ' + char(10)
		SELECT @v_dSql +=	N'									, D.PRE_RP_JR_ONLYHOLD AS JR_BOH_ONLYHOLD, D.PRE_ST_JR_ONLYHOLD AS RP_BOH_ONLYHOLD, D.POST_ST_PC_ONLYHOLD AS A_TYPE_BOH_ONLYHOLD, D.POST_ST_PC_ONLYHOLD AS B_TYPE_BOH_ONLYHOLD, D.ASSY_PC_ONLYHOLD AS ASSY_BOH_ONLYHOLD                    		 ' + char(10)
		SELECT @v_dSql +=	N'									, D.PRE_RP_JR_R_ONLYHOLD AS JR_R_BOH_ONLYHOLD, D.PRE_ST_JR_R_ONLYHOLD AS RP_R_BOH_ONLYHOLD, D.POST_ST_PC_R_ONLYHOLD AS A_TYPE_R_BOH_ONLYHOLD, D.POST_ST_PC_R_ONLYHOLD AS B_TYPE_R_BOH_ONLYHOLD, D.ASSY_PC_R_ONLYHOLD AS ASSY_R_BOH_ONLYHOLD		 ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR,0) + ISNULL(D.PRE_ST_JR,0) + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) END AS EOH_JR_QTY_A     ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_QTY_B     ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_PRE_QTY     ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_ST_JR,0) - ISNULL(SLITTING_PLAN,0) + ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 - ISNULL(SLITTING_PLAN,0) + ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_POST_QTY     ' + char(10)
		--SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) +ISNULL(D.ASSY_PC,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0)  - ISNULL(MOVING_PLAN,0)) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_PC_QTY_A	' + char(10)
		--SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) +ISNULL(D.ASSY_PC,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_PC_QTY_B	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) +ISNULL(D.ASSY_PC,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0)  ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) END AS EOH_PC_QTY_A	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) +ISNULL(D.ASSY_PC,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) END AS EOH_PC_QTY_B	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.ASSY_PC,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ' + char(10)
		SELECT @v_dSql +=	N'											WHEN A.PLAN_DATE < CONVERT(DATE, '''+ @p_plan_date +''') THEN 0 ELSE (0 - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0)) END AS EOH_ASSY_QTY' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_ELEC_QTY_A	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(MOVING_PLAN,0) ) END AS EOH_ELEC_QTY_B	' + char(10)

		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR_HOLD,0) + ISNULL(D.PRE_ST_JR_HOLD,0) + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) END AS EOH_JR_QTY_A_HOLD     ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR_HOLD,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_QTY_B_HOLD     ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR_HOLD,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_PRE_QTY_HOLD     ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_ST_JR_HOLD,0) - ISNULL(SLITTING_PLAN,0) + ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 - ISNULL(SLITTING_PLAN,0) + ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_POST_QTY_HOLD     ' + char(10)
		--SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) +ISNULL(D.ASSY_PC_HOLD,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_PC_QTY_A_HOLD	' + char(10)
		--SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) +ISNULL(D.ASSY_PC_HOLD,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_PC_QTY_B_HOLD	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) +ISNULL(D.ASSY_PC_HOLD,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) END AS EOH_PC_QTY_A_HOLD	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) +ISNULL(D.ASSY_PC_HOLD,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) END AS EOH_PC_QTY_B_HOLD	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.ASSY_PC_HOLD,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ' + char(10)
		SELECT @v_dSql +=	N'											WHEN A.PLAN_DATE < CONVERT(DATE, '''+ @p_plan_date +''') THEN 0 ELSE (0 - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0)) END AS EOH_ASSY_QTY_HOLD' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_ELEC_QTY_A_HOLD	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_ELEC_QTY_B_HOLD	' + char(10)

		SELECT @v_dSql +=	N'								FROM	(                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'											SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE                 ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_BOH, A.RP_BOH, A.A_TYPE_BOH, A.B_TYPE_BOH, A.ASSY_BOH                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_R_BOH, A.RP_R_BOH, A.A_TYPE_R_BOH, A.B_TYPE_R_BOH, A.ASSY_R_BOH                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_BOH_HOLD, A.RP_BOH_HOLD, A.A_TYPE_BOH_HOLD, A.B_TYPE_BOH_HOLD, A.ASSY_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_R_BOH_HOLD, A.RP_R_BOH_HOLD, A.A_TYPE_R_BOH_HOLD, A.B_TYPE_R_BOH_HOLD, A.ASSY_R_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_BOH_ONLYHOLD, A.RP_BOH_ONLYHOLD, A.A_TYPE_BOH_ONLYHOLD, A.B_TYPE_BOH_ONLYHOLD, A.ASSY_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_R_BOH_ONLYHOLD, A.RP_R_BOH_ONLYHOLD, A.A_TYPE_R_BOH_ONLYHOLD, A.B_TYPE_R_BOH_ONLYHOLD, A.ASSY_R_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, B.MOVING_FACTORY       ' + char(10)
		SELECT @v_dSql +=	N'													, SUM(NOTCHING_PLAN) AS NOTCHING_PLAN                                                                        ' + char(10)
		SELECT @v_dSql +=	N'													, SUM(COATING_PLAN) AS COATING_PLAN                                                                          ' + char(10)
		SELECT @v_dSql +=	N'													, SUM(INTRANSIT) AS INTRANSIT                                                                                ' + char(10)
		SELECT @v_dSql +=	N'													, SUM(SHIPMENT_PLAN) AS SHIPMENT_PLAN                                                                        ' + char(10)
		SELECT @v_dSql +=	N'													, SUM(SLITTING_PLAN) AS SLITTING_PLAN                                                                        ' + char(10)
		SELECT @v_dSql +=	N'													, SUM(ROLL_PRESS_PLAN) AS ROLL_PRESS_PLAN                                                                    ' + char(10)
		  --	case 1) EB -> ED 동으로 가는 Moving plan
		  --  EB동에서 moving plan(out) 만큼 EOH(P/C)에서 차감 /// ED동에서 moving plan(in) 만큼 EOH(P/C)에 더함
		  --case2) ED -> EB동으로 가는 moving plan
		  --  ED동에서 moving plan(out) 만큼 EOH(P/C)에서 차감 /// EB동에서 moving plan(in) 만큼 EOH(P/C)에 차감하지 않음, 전극 창고를 통하지 않고 즉시 ass(P/C)로 입고됨
		  --Case1은 coating – R/P – S/L (EB)  -> Rewinder(ED ) -> 조립 이동
		  --case2는 coating – R/P – S/L – Rewinder(EB) -> 조립 이동
		SELECT @v_dSql +=	N'													, SUM( CASE WHEN ISNULL(B.MOVING_FACTORY,'''') = '''' AND A.FACTORY_ID = ''EB'' THEN 0 WHEN ISNULL(B.MOVING_FACTORY,'''') = '''' THEN MOVING_PLAN * -1 ELSE MOVING_PLAN END) AS MOVING_PLAN    ' + char(10)
		SELECT @v_dSql +=	N'											FROM	(                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'										                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'														SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, NULL AS PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE        ' + char(10)
		SELECT @v_dSql +=	N'																, NULL AS JR_BOH, NULL AS RP_BOH, NULL AS A_TYPE_BOH, NULL AS B_TYPE_BOH, NULL AS ASSY_BOH															' + char(10)
		SELECT @v_dSql +=	N'																, NULL AS JR_R_BOH, NULL AS RP_R_BOH, NULL AS A_TYPE_R_BOH, NULL AS B_TYPE_R_BOH, NULL AS ASSY_R_BOH                    							' + char(10)
		SELECT @v_dSql +=	N'																, NULL AS JR_BOH_HOLD, NULL AS RP_BOH_HOLD, NULL AS A_TYPE_BOH_HOLD, NULL AS B_TYPE_BOH_HOLD, NULL AS ASSY_BOH_HOLD                    				' + char(10)
		SELECT @v_dSql +=	N'																, NULL AS JR_R_BOH_HOLD, NULL AS RP_R_BOH_HOLD, NULL AS A_TYPE_R_BOH_HOLD, NULL AS B_TYPE_R_BOH_HOLD, NULL AS ASSY_R_BOH_HOLD                    	' + char(10)
		SELECT @v_dSql +=	N'																, NULL AS JR_BOH_ONLYHOLD, NULL AS RP_BOH_ONLYHOLD, NULL AS A_TYPE_BOH_ONLYHOLD, NULL AS B_TYPE_BOH_ONLYHOLD, NULL AS ASSY_BOH_ONLYHOLD             ' + char(10)       
		SELECT @v_dSql +=	N'																, NULL AS JR_R_BOH_ONLYHOLD, NULL AS RP_R_BOH_ONLYHOLD, NULL AS A_TYPE_R_BOH_ONLYHOLD, NULL AS B_TYPE_R_BOH_ONLYHOLD, NULL AS ASSY_R_BOH_ONLYHOLD	' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''NOTCHING_PLAN'' THEN A.QTY ELSE 0 END AS NOTCHING_PLAN                   ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''COATING_PLAN'' THEN A.QTY ELSE 0 END AS COATING_PLAN                     ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''INTRANSIT'' THEN A.QTY ELSE 0 END AS INTRANSIT                           ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''SHIPMENT_PLAN'' THEN A.QTY ELSE 0 END AS SHIPMENT_PLAN                   ' + char(10)
		--SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''SLITTING_PLAN'' THEN A.QTY ELSE 0 END AS SLITTING_PLAN                   ' + char(10)
		--SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''ROLL_PRESS_PLAN'' THEN A.QTY ELSE 0 END AS ROLL_PRESS_PLAN               ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''SLITTING_PLAN'' THEN A.IN_QTY ELSE 0 END AS SLITTING_PLAN                   ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''ROLL_PRESS_PLAN'' THEN A.IN_QTY ELSE 0 END AS ROLL_PRESS_PLAN               ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''MOVING_PLAN'' THEN A.QTY ELSE 0 END AS MOVING_PLAN               ' + char(10)
		SELECT @v_dSql +=	N'														FROM	(                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'																	SELECT *                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'																	FROM	#MAIN_P A                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'																	WHERE	1=1                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'																) A                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'														WHERE	1=1                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'														UNION ALL																																													' + char(10)
		SELECT @v_dSql +=	N'														SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, NULL AS PRODUCTION_TYPE, A.ATTR_TYPE, '''+ @p_plan_date +''' AS PLAN_DATE     ' + char(10)   
		SELECT @v_dSql +=	N'																, NULL AS JR_BOH, NULL AS RP_BOH, NULL AS A_TYPE_BOH, NULL AS B_TYPE_BOH, NULL AS ASSY_BOH															' + char(10)
		SELECT @v_dSql +=	N'																, NULL AS JR_R_BOH, NULL AS RP_R_BOH, NULL AS A_TYPE_R_BOH, NULL AS B_TYPE_R_BOH, NULL AS ASSY_R_BOH                    							' + char(10)
		SELECT @v_dSql +=	N'																, NULL AS JR_BOH_HOLD, NULL AS RP_BOH_HOLD, NULL AS A_TYPE_BOH_HOLD, NULL AS B_TYPE_BOH_HOLD, NULL AS ASSY_BOH_HOLD                    				' + char(10)
		SELECT @v_dSql +=	N'																, NULL AS JR_R_BOH_HOLD, NULL AS RP_R_BOH_HOLD, NULL AS A_TYPE_R_BOH_HOLD, NULL AS B_TYPE_R_BOH_HOLD, NULL AS ASSY_R_BOH_HOLD                    	' + char(10)
		SELECT @v_dSql +=	N'																, NULL AS JR_BOH_ONLYHOLD, NULL AS RP_BOH_ONLYHOLD, NULL AS A_TYPE_BOH_ONLYHOLD, NULL AS B_TYPE_BOH_ONLYHOLD, NULL AS ASSY_BOH_ONLYHOLD             ' + char(10)       
		SELECT @v_dSql +=	N'																, NULL AS JR_R_BOH_ONLYHOLD, NULL AS RP_R_BOH_ONLYHOLD, NULL AS A_TYPE_R_BOH_ONLYHOLD, NULL AS B_TYPE_R_BOH_ONLYHOLD, NULL AS ASSY_R_BOH_ONLYHOLD	' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS NOTCHING_PLAN                   																																				' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS COATING_PLAN                     																																			' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS INTRANSIT                           																																			' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS SHIPMENT_PLAN                   																																				' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS SLITTING_PLAN                   																																				' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS ROLL_PRESS_PLAN               																																				' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS MOVING_PLAN               																																				' + char(10)
		SELECT @v_dSql +=	N'														FROM	(                                                                                                    																				' + char(10)
		SELECT @v_dSql +=	N'																	SELECT *                                                                                             																			' + char(10)
		SELECT @v_dSql +=	N'																	FROM	#MAIN_P A                                                                                       																			' + char(10)
		SELECT @v_dSql +=	N'																	WHERE	1=1                                                                                            																			' + char(10)
		SELECT @v_dSql +=	N'																) A                                                                                                    																				' + char(10)
		SELECT @v_dSql +=	N'														WHERE	1=1  																																												' + char(10)
		SELECT @v_dSql +=	N'													) A                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'													LEFT OUTER JOIN (																			 ' + char(10)
		SELECT @v_dSql +=	N'															SELECT DISTINCT A.FACTORY_ID, A.ITEM_ID, CASE WHEN A.ELECTRODE_TYPE = ''A'' THEN  ''ANODE'' ELSE ''CATHODE'' END AS ELECTRODE_TYPE, A.ATTB_4 AS MOVING_FACTORY	   ' + char(10)
		SELECT @v_dSql +=	N'															FROM FP_ELECTRODE_POST_PLAN_H A WITH(NOLOCK)																															   ' + char(10)
		SELECT @v_dSql +=	N'															WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'															AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'															AND    A.CATEGORY  = ''12-Moving Plan''                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'															AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'													) B																																												   ' + char(10)
		SELECT @v_dSql +=	N'													ON 1=1																																											   ' + char(10)
		SELECT @v_dSql +=	N'													AND		A.FACTORY_ID		= B.FACTORY_ID                                                                                                  									   ' + char(10)
		SELECT @v_dSql +=	N'													AND		A.ITEM_ID			= B.ITEM_ID                                                                                                 										   ' + char(10)
		SELECT @v_dSql +=	N'													AND		A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE                                                                                                     								   ' + char(10)
		SELECT @v_dSql +=	N'													--AND		A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE                                                                                                    							   ' + char(10)
		SELECT @v_dSql +=	N'													--AND		A.ATTR_TYPE			= B.ATTR_TYPE     																																	   ' + char(10)
		SELECT @v_dSql +=	N'											WHERE	1=1                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'											GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE              ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_BOH, A.RP_BOH, A.A_TYPE_BOH, A.B_TYPE_BOH, A.ASSY_BOH                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_R_BOH, A.RP_R_BOH, A.A_TYPE_R_BOH, A.B_TYPE_R_BOH, A.ASSY_R_BOH                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_BOH_HOLD, A.RP_BOH_HOLD, A.A_TYPE_BOH_HOLD, A.B_TYPE_BOH_HOLD, A.ASSY_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_R_BOH_HOLD, A.RP_R_BOH_HOLD, A.A_TYPE_R_BOH_HOLD, A.B_TYPE_R_BOH_HOLD, A.ASSY_R_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_BOH_ONLYHOLD, A.RP_BOH_ONLYHOLD, A.A_TYPE_BOH_ONLYHOLD, A.B_TYPE_BOH_ONLYHOLD, A.ASSY_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_R_BOH_ONLYHOLD, A.RP_R_BOH_ONLYHOLD, A.A_TYPE_R_BOH_ONLYHOLD, A.B_TYPE_R_BOH_ONLYHOLD, A.ASSY_R_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, B.MOVING_FACTORY       ' + char(10)
		SELECT @v_dSql +=	N'										) A                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'										 LEFT OUTER HASH JOIN (                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'												SELECT   A.FACTORY_ID, A.ITEM_ID, A.ATTR_TYPE						 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(PRE_RP_JR)             AS PRE_RP_JR            		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(PRE_ST_JR)             AS PRE_ST_JR            		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(POST_ST_PC)            AS POST_ST_PC           		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(ASSY_PC)               AS ASSY_PC              		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(PRE_RP_JR_R)           AS PRE_RP_JR_R          		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(PRE_ST_JR_R)           AS PRE_ST_JR_R          		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(POST_ST_PC_R)          AS POST_ST_PC_R         		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(ASSY_PC_R)             AS ASSY_PC_R            		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(PRE_RP_JR_HOLD)        AS PRE_RP_JR_HOLD       		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(PRE_ST_JR_HOLD)        AS PRE_ST_JR_HOLD       		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(POST_ST_PC_HOLD)       AS POST_ST_PC_HOLD      		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(ASSY_PC_HOLD)          AS ASSY_PC_HOLD         		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(PRE_RP_JR_R_HOLD)      AS PRE_RP_JR_R_HOLD     		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(PRE_ST_JR_R_HOLD)      AS PRE_ST_JR_R_HOLD     		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(POST_ST_PC_R_HOLD)     AS POST_ST_PC_R_HOLD    		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(ASSY_PC_R_HOLD)        AS ASSY_PC_R_HOLD       		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(PRE_RP_JR_ONLYHOLD)    AS PRE_RP_JR_ONLYHOLD   		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(PRE_ST_JR_ONLYHOLD)    AS PRE_ST_JR_ONLYHOLD   		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(POST_ST_PC_ONLYHOLD)   AS POST_ST_PC_ONLYHOLD  		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(ASSY_PC_ONLYHOLD)      AS ASSY_PC_ONLYHOLD     		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(PRE_RP_JR_R_ONLYHOLD)  AS PRE_RP_JR_R_ONLYHOLD 		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(PRE_ST_JR_R_ONLYHOLD)  AS PRE_ST_JR_R_ONLYHOLD 		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(POST_ST_PC_R_ONLYHOLD) AS POST_ST_PC_R_ONLYHOLD		 ' + char(10)
		SELECT @v_dSql +=	N'														, SUM(ASSY_PC_R_ONLYHOLD)    AS ASSY_PC_R_ONLYHOLD   		 ' + char(10)
		SELECT @v_dSql +=	N'												FROM #STOCK_T AS A  												 ' + char(10)
		SELECT @v_dSql +=	N'												GROUP BY A.FACTORY_ID, A.ITEM_ID, A.ATTR_TYPE						 ' + char(10)
		SELECT @v_dSql +=	N'											) D                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'										  ON 1=1                                                                                                           ' + char(10)
		--SELECT @v_dSql +=	N'										  AND A.COMPANY_ID = D.COMPANY_ID                                                                                  ' + char(10)
		--SELECT @v_dSql +=	N'										  AND A.DIVISION_ID = D.DIVISION_ID                                                                                ' + char(10)
		--SELECT @v_dSql +=	N'										  AND A.SITE_ID = D.SITE_ID                                                                                        ' + char(10)
		--SELECT @v_dSql +=	N'										  AND A.PLANT_ID = D.PLANT_ID                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'										  AND A.FACTORY_ID = D.FACTORY_ID                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'										  AND A.ITEM_ID = D.ITEM_ID                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'										  AND A.ATTR_TYPE = D.ATTR_TYPE                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'								WHERE	1=1                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'								UNION ALL	-- PRODUCTION TYPE 별 EOH	                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'								SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE AS PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE                       ' + char(10)
		SELECT @v_dSql +=	N'									, A.JR_BOH, A.RP_BOH, A.A_TYPE_BOH, A.B_TYPE_BOH, A.ASSY_BOH                    ' + char(10)
		SELECT @v_dSql +=	N'									, A.JR_R_BOH, A.RP_R_BOH, A.A_TYPE_R_BOH, A.B_TYPE_R_BOH, A.ASSY_R_BOH                    ' + char(10)
		SELECT @v_dSql +=	N'									, A.JR_BOH_HOLD, A.RP_BOH_HOLD, A.A_TYPE_BOH_HOLD, A.B_TYPE_BOH_HOLD, A.ASSY_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'									, A.JR_R_BOH_HOLD, A.RP_R_BOH_HOLD, A.A_TYPE_R_BOH_HOLD, A.B_TYPE_R_BOH_HOLD, A.ASSY_R_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'									, A.JR_BOH_ONLYHOLD, A.RP_BOH_ONLYHOLD, A.A_TYPE_BOH_ONLYHOLD, A.B_TYPE_BOH_ONLYHOLD, A.ASSY_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'									, A.JR_R_BOH_ONLYHOLD, A.RP_R_BOH_ONLYHOLD, A.A_TYPE_R_BOH_ONLYHOLD, A.B_TYPE_R_BOH_ONLYHOLD, A.ASSY_R_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR,0) + ISNULL(D.PRE_ST_JR,0) + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) END AS EOH_JR_QTY_A     ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_QTY_B     ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_PRE_QTY     ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_ST_JR,0) - ISNULL(SLITTING_PLAN,0) + ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 - ISNULL(SLITTING_PLAN,0) + ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_POST_QTY     ' + char(10)
		--SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) +ISNULL(D.ASSY_PC,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0)  - ISNULL(MOVING_PLAN,0)) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_PC_QTY_A	' + char(10)
		--SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) +ISNULL(D.ASSY_PC,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_PC_QTY_B	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) +ISNULL(D.ASSY_PC,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) END AS EOH_PC_QTY_A	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) +ISNULL(D.ASSY_PC,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) END AS EOH_PC_QTY_B	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.ASSY_PC,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ' + char(10)
		SELECT @v_dSql +=	N'											WHEN A.PLAN_DATE < CONVERT(DATE, '''+ @p_plan_date +''') THEN 0 ELSE (0 - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0)) END AS EOH_ASSY_QTY' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_ELEC_QTY_A	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(MOVING_PLAN,0) ) END AS EOH_ELEC_QTY_B	' + char(10)

		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR_HOLD,0) + ISNULL(D.PRE_ST_JR_HOLD,0) + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) END AS EOH_JR_QTY_A_HOLD     ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR_HOLD,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_QTY_B_HOLD     ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR_HOLD,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_PRE_QTY_HOLD     ' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_ST_JR_HOLD,0) - ISNULL(SLITTING_PLAN,0) + ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 - ISNULL(SLITTING_PLAN,0) + ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_POST_QTY_HOLD     ' + char(10)
		--SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) +ISNULL(D.ASSY_PC_HOLD,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_PC_QTY_A_HOLD	' + char(10)
		--SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) +ISNULL(D.ASSY_PC_HOLD,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_PC_QTY_B_HOLD	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) +ISNULL(D.ASSY_PC_HOLD,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) END AS EOH_PC_QTY_A_HOLD	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) +ISNULL(D.ASSY_PC_HOLD,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) END AS EOH_PC_QTY_B_HOLD	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.ASSY_PC_HOLD,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ' + char(10)
		SELECT @v_dSql +=	N'											WHEN A.PLAN_DATE < CONVERT(DATE, '''+ @p_plan_date +''') THEN 0 ELSE (0 - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0)) END AS EOH_ASSY_QTY_HOLD' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_ELEC_QTY_A_HOLD	' + char(10)
		SELECT @v_dSql +=	N'									,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_ELEC_QTY_B_HOLD	' + char(10)

		SELECT @v_dSql +=	N'								FROM	(                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'											SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE                 ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_BOH, A.RP_BOH, A.A_TYPE_BOH, A.B_TYPE_BOH, A.ASSY_BOH                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_R_BOH, A.RP_R_BOH, A.A_TYPE_R_BOH, A.B_TYPE_R_BOH, A.ASSY_R_BOH                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_BOH_HOLD, A.RP_BOH_HOLD, A.A_TYPE_BOH_HOLD, A.B_TYPE_BOH_HOLD, A.ASSY_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_R_BOH_HOLD, A.RP_R_BOH_HOLD, A.A_TYPE_R_BOH_HOLD, A.B_TYPE_R_BOH_HOLD, A.ASSY_R_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_BOH_ONLYHOLD, A.RP_BOH_ONLYHOLD, A.A_TYPE_BOH_ONLYHOLD, A.B_TYPE_BOH_ONLYHOLD, A.ASSY_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_R_BOH_ONLYHOLD, A.RP_R_BOH_ONLYHOLD, A.A_TYPE_R_BOH_ONLYHOLD, A.B_TYPE_R_BOH_ONLYHOLD, A.ASSY_R_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, B.MOVING_FACTORY       ' + char(10)
		SELECT @v_dSql +=	N'													, SUM(NOTCHING_PLAN) AS NOTCHING_PLAN                                                                        ' + char(10)
		SELECT @v_dSql +=	N'													, SUM(COATING_PLAN) AS COATING_PLAN                                                                          ' + char(10)
		SELECT @v_dSql +=	N'													, SUM(INTRANSIT) AS INTRANSIT                                                                                ' + char(10)
		SELECT @v_dSql +=	N'													, SUM(SHIPMENT_PLAN) AS SHIPMENT_PLAN                                                                        ' + char(10)
		SELECT @v_dSql +=	N'													, SUM(SLITTING_PLAN) AS SLITTING_PLAN                                                                        ' + char(10)
		SELECT @v_dSql +=	N'													, SUM(ROLL_PRESS_PLAN) AS ROLL_PRESS_PLAN                                                                    ' + char(10)
		  --	case 1) EB -> ED 동으로 가는 Moving plan
		  --  EB동에서 moving plan(out) 만큼 EOH(P/C)에서 차감 /// ED동에서 moving plan(in) 만큼 EOH(P/C)에 더함
		  --case2) ED -> EB동으로 가는 moving plan
		  --  ED동에서 moving plan(out) 만큼 EOH(P/C)에서 차감 /// EB동에서 moving plan(in) 만큼 EOH(P/C)에 차감하지 않음, 전극 창고를 통하지 않고 즉시 ass(P/C)로 입고됨
		  --Case1은 coating – R/P – S/L (EB)  -> Rewinder(ED ) -> 조립 이동
		  --case2는 coating – R/P – S/L – Rewinder(EB) -> 조립 이동
		SELECT @v_dSql +=	N'													, SUM( CASE WHEN ISNULL(B.MOVING_FACTORY,'''') = '''' AND A.FACTORY_ID = ''EB'' THEN 0 WHEN ISNULL(B.MOVING_FACTORY,'''') = '''' THEN MOVING_PLAN * -1 ELSE MOVING_PLAN END) AS MOVING_PLAN    ' + char(10)
		SELECT @v_dSql +=	N'											FROM	(                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'										                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'														SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE        ' + char(10)
		SELECT @v_dSql +=	N'																, A.JR_BOH, A.RP_BOH, A.A_TYPE_BOH, A.B_TYPE_BOH, A.ASSY_BOH                    ' + char(10)
		SELECT @v_dSql +=	N'																, A.JR_R_BOH, A.RP_R_BOH, A.A_TYPE_R_BOH, A.B_TYPE_R_BOH, A.ASSY_R_BOH                    ' + char(10)
		SELECT @v_dSql +=	N'																, A.JR_BOH_HOLD, A.RP_BOH_HOLD, A.A_TYPE_BOH_HOLD, A.B_TYPE_BOH_HOLD, A.ASSY_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'																, A.JR_R_BOH_HOLD, A.RP_R_BOH_HOLD, A.A_TYPE_R_BOH_HOLD, A.B_TYPE_R_BOH_HOLD, A.ASSY_R_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'																, A.JR_BOH_ONLYHOLD, A.RP_BOH_ONLYHOLD, A.A_TYPE_BOH_ONLYHOLD, A.B_TYPE_BOH_ONLYHOLD, A.ASSY_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'																, A.JR_R_BOH_ONLYHOLD, A.RP_R_BOH_ONLYHOLD, A.A_TYPE_R_BOH_ONLYHOLD, A.B_TYPE_R_BOH_ONLYHOLD, A.ASSY_R_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''NOTCHING_PLAN'' THEN A.QTY ELSE 0 END AS NOTCHING_PLAN                   ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''COATING_PLAN'' THEN A.QTY ELSE 0 END AS COATING_PLAN                     ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''INTRANSIT'' THEN A.QTY ELSE 0 END AS INTRANSIT                           ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''SHIPMENT_PLAN'' THEN A.QTY ELSE 0 END AS SHIPMENT_PLAN                   ' + char(10)
		--SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''SLITTING_PLAN'' THEN A.QTY ELSE 0 END AS SLITTING_PLAN                   ' + char(10)
		--SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''ROLL_PRESS_PLAN'' THEN A.QTY ELSE 0 END AS ROLL_PRESS_PLAN               ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''SLITTING_PLAN'' THEN A.IN_QTY ELSE 0 END AS SLITTING_PLAN                   ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''ROLL_PRESS_PLAN'' THEN A.IN_QTY ELSE 0 END AS ROLL_PRESS_PLAN               ' + char(10)
		SELECT @v_dSql +=	N'																, CASE WHEN CATEGORY_ID = ''MOVING_PLAN'' THEN A.QTY ELSE 0 END AS MOVING_PLAN               ' + char(10)
		SELECT @v_dSql +=	N'														FROM	(                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'																	SELECT *                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'																	FROM	#MAIN_P A                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'																	WHERE	1=1                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'																) A                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'														WHERE	1=1                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'														UNION ALL																																													' + char(10)
		SELECT @v_dSql +=	N'														SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, '''+ @p_plan_date +''' AS PLAN_DATE     ' + char(10)   
		SELECT @v_dSql +=	N'																, A.JR_BOH, A.RP_BOH, A.A_TYPE_BOH, A.B_TYPE_BOH, A.ASSY_BOH                    																									' + char(10)
		SELECT @v_dSql +=	N'																, A.JR_R_BOH, A.RP_R_BOH, A.A_TYPE_R_BOH, A.B_TYPE_R_BOH, A.ASSY_R_BOH                    																							' + char(10)
		SELECT @v_dSql +=	N'																, A.JR_BOH_HOLD, A.RP_BOH_HOLD, A.A_TYPE_BOH_HOLD, A.B_TYPE_BOH_HOLD, A.ASSY_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'																, A.JR_R_BOH_HOLD, A.RP_R_BOH_HOLD, A.A_TYPE_R_BOH_HOLD, A.B_TYPE_R_BOH_HOLD, A.ASSY_R_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'																, A.JR_BOH_ONLYHOLD, A.RP_BOH_ONLYHOLD, A.A_TYPE_BOH_ONLYHOLD, A.B_TYPE_BOH_ONLYHOLD, A.ASSY_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'																, A.JR_R_BOH_ONLYHOLD, A.RP_R_BOH_ONLYHOLD, A.A_TYPE_R_BOH_ONLYHOLD, A.B_TYPE_R_BOH_ONLYHOLD, A.ASSY_R_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS NOTCHING_PLAN                   																																				' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS COATING_PLAN                     																																			' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS INTRANSIT                           																																			' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS SHIPMENT_PLAN                   																																				' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS SLITTING_PLAN                   																																				' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS ROLL_PRESS_PLAN               																																				' + char(10)
		SELECT @v_dSql +=	N'																, 0 AS MOVING_PLAN               																																				' + char(10)
		SELECT @v_dSql +=	N'														FROM	(                                                                                                    																				' + char(10)
		SELECT @v_dSql +=	N'																	SELECT *                                                                                             																			' + char(10)
		SELECT @v_dSql +=	N'																	FROM	#MAIN_P A                                                                                       																			' + char(10)
		SELECT @v_dSql +=	N'																	WHERE	1=1                                                                                            																			' + char(10)
		SELECT @v_dSql +=	N'																) A                                                                                                    																				' + char(10)
		SELECT @v_dSql +=	N'														WHERE	1=1  																																												' + char(10)
		SELECT @v_dSql +=	N'													) A                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'													LEFT OUTER JOIN (																			 ' + char(10)
		SELECT @v_dSql +=	N'															SELECT DISTINCT A.FACTORY_ID, A.ITEM_ID, CASE WHEN A.ELECTRODE_TYPE = ''A'' THEN  ''ANODE'' ELSE ''CATHODE'' END AS ELECTRODE_TYPE, A.ATTB_4 AS MOVING_FACTORY	   ' + char(10)
		SELECT @v_dSql +=	N'															FROM FP_ELECTRODE_POST_PLAN_H A WITH(NOLOCK)																															   ' + char(10)
		SELECT @v_dSql +=	N'															WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'															AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'															AND    A.CATEGORY  = ''12-Moving Plan''                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'															AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'													) B																																												   ' + char(10)
		SELECT @v_dSql +=	N'													ON 1=1																																											   ' + char(10)
		SELECT @v_dSql +=	N'													AND		A.FACTORY_ID		= B.FACTORY_ID                                                                                                  									   ' + char(10)
		SELECT @v_dSql +=	N'													AND		A.ITEM_ID			= B.ITEM_ID                                                                                                 										   ' + char(10)
		SELECT @v_dSql +=	N'													AND		A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE                                                                                                     								   ' + char(10)
		SELECT @v_dSql +=	N'													--AND		A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE                                                                                                    							   ' + char(10)
		SELECT @v_dSql +=	N'													--AND		A.ATTR_TYPE			= B.ATTR_TYPE     																																	   ' + char(10)
		SELECT @v_dSql +=	N'											WHERE	1=1                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'											GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE              ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_BOH, A.RP_BOH, A.A_TYPE_BOH, A.B_TYPE_BOH, A.ASSY_BOH                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_R_BOH, A.RP_R_BOH, A.A_TYPE_R_BOH, A.B_TYPE_R_BOH, A.ASSY_R_BOH                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_BOH_HOLD, A.RP_BOH_HOLD, A.A_TYPE_BOH_HOLD, A.B_TYPE_BOH_HOLD, A.ASSY_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_R_BOH_HOLD, A.RP_R_BOH_HOLD, A.A_TYPE_R_BOH_HOLD, A.B_TYPE_R_BOH_HOLD, A.ASSY_R_BOH_HOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_BOH_ONLYHOLD, A.RP_BOH_ONLYHOLD, A.A_TYPE_BOH_ONLYHOLD, A.B_TYPE_BOH_ONLYHOLD, A.ASSY_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, A.JR_R_BOH_ONLYHOLD, A.RP_R_BOH_ONLYHOLD, A.A_TYPE_R_BOH_ONLYHOLD, A.B_TYPE_R_BOH_ONLYHOLD, A.ASSY_R_BOH_ONLYHOLD                    ' + char(10)
		SELECT @v_dSql +=	N'													, B.MOVING_FACTORY       ' + char(10)
		SELECT @v_dSql +=	N'										) A                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'										 LEFT OUTER HASH JOIN (                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'												SELECT *                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'												FROM #stock_t AS A                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'											) D                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'										  ON 1=1                                                                                                           ' + char(10)
		--SELECT @v_dSql +=	N'										  AND A.COMPANY_ID = D.COMPANY_ID                                                                                  ' + char(10)
		--SELECT @v_dSql +=	N'										  AND A.DIVISION_ID = D.DIVISION_ID                                                                                ' + char(10)
		--SELECT @v_dSql +=	N'										  AND A.SITE_ID = D.SITE_ID                                                                                        ' + char(10)
		--SELECT @v_dSql +=	N'										  AND A.PLANT_ID = D.PLANT_ID                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'										  AND A.FACTORY_ID = D.FACTORY_ID                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'										  AND A.ITEM_ID = D.ITEM_ID                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'										  AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE                                                                          ' + char(10)
		SELECT @v_dSql +=	N'										  AND A.ATTR_TYPE = D.ATTR_TYPE                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'								WHERE	1=1                                                                                                              ' + char(10)

		SELECT @v_dSql +=	N'						) A                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'					WHERE	1=1                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'			) A                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'			INNER JOIN (                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'			      	SELECT *                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'			      	FROM (                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'			      			SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER, '''' AS CATEGORY_GROUP										                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'	 						UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 						SELECT ''EOH_JR_QTY'' AS CATEGORY_ID, ''EOH(J/R)'' AS CATEGORY_NAME, 150 AS CATEGORY_ORDER, ''150'' AS CATEGORY_GROUP         ' + char(10)
		SELECT @v_dSql +=	N'	 						UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 						SELECT ''EOH_JR_PRE_QTY'' AS CATEGORY_ID, ''EOH(J/R - Pre RP)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER, ''20'' AS CATEGORY_GROUP         ' + char(10)
		SELECT @v_dSql +=	N'	 						UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 						SELECT ''EOH_JR_POST_QTY'' AS CATEGORY_ID, ''EOH(J/R - Post RP)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER, ''60'' AS CATEGORY_GROUP         ' + char(10)
		SELECT @v_dSql +=	N'	 						UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'							SELECT ''EOH_PC_QTY'' AS CATEGORY_ID, ''EOH(P/C)'' AS CATEGORY_NAME, 110 AS CATEGORY_ORDER, ''110'' AS CATEGORY_GROUP       ' + char(10)
		SELECT @v_dSql +=	N'	 						UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'							SELECT ''EOH_ASSY_QTY'' AS CATEGORY_ID, ''Assy EOH'' AS CATEGORY_NAME, 170 AS CATEGORY_ORDER, ''170'' AS CATEGORY_GROUP       ' + char(10)
		SELECT @v_dSql +=	N'	 						UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'							SELECT ''EOH_ELEC_QTY'' AS CATEGORY_ID, ''Elec EOH(P/C)'' AS CATEGORY_NAME, 190 AS CATEGORY_ORDER, ''190'' AS CATEGORY_GROUP       ' + char(10)
		SELECT @v_dSql +=	N'	 						UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 						SELECT ''EOH_JR_QTY_HOLD'' AS CATEGORY_ID, ''EOH(J/R) + Hold'' AS CATEGORY_NAME, 160 AS CATEGORY_ORDER, ''160'' AS CATEGORY_GROUP         ' + char(10)
		SELECT @v_dSql +=	N'	 						UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 						SELECT ''EOH_JR_PRE_QTY_HOLD'' AS CATEGORY_ID, ''EOH(J/R - Pre RP) + Hold'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER, ''30'' AS CATEGORY_GROUP         ' + char(10)
		SELECT @v_dSql +=	N'	 						UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'	 						SELECT ''EOH_JR_POST_QTY_HOLD'' AS CATEGORY_ID, ''EOH(J/R - Post RP) + Hold'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER, ''70'' AS CATEGORY_GROUP         ' + char(10)
		SELECT @v_dSql +=	N'	 						UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'							SELECT ''EOH_PC_QTY_HOLD'' AS CATEGORY_ID, ''EOH(P/C) + Hold'' AS CATEGORY_NAME, 120 AS CATEGORY_ORDER, ''120'' AS CATEGORY_GROUP       ' + char(10)
		SELECT @v_dSql +=	N'	 						UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'							SELECT ''EOH_ASSY_QTY_HOLD'' AS CATEGORY_ID, ''Assy EOH + Hold'' AS CATEGORY_NAME, 180 AS CATEGORY_ORDER, ''180'' AS CATEGORY_GROUP       ' + char(10)
		SELECT @v_dSql +=	N'	 						UNION ALL                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'							SELECT ''EOH_ELEC_QTY_HOLD'' AS CATEGORY_ID, ''Elec EOH(P/C) + Hold'' AS CATEGORY_NAME, 200 AS CATEGORY_ORDER, ''200'' AS CATEGORY_GROUP       ' + char(10)
		SELECT @v_dSql +=	N'			    				) BB                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'			    			WHERE CATEGORY_ID <> ''X''                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'			) B                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'			ON 1=1                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'			INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)                                                                          ' + char(10)
		SELECT @v_dSql +=	N'			ON  A.PLAN_DATE = C.YYYYMMDD                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'			INNER HASH JOIN SCM_ITEM_M E WITH(NOLOCK)                                                                          ' + char(10)
		SELECT @v_dSql +=	N'			ON  A.COMPANY_ID  = E.COMPANY_ID                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'			AND A.DIVISION_ID = E.DIVISION_ID                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'			AND A.SITE_ID	  = E.SITE_ID                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'			AND A.ITEM_ID	  = E.ITEM_ID                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'			AND E.ACTIVE_FLAG = ''Y''                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'			INNER HASH JOIN SCM_ITEM_CLASS_M F WITH(NOLOCK)                                                                    ' + char(10)
		SELECT @v_dSql +=	N'			ON  E.ITEM_CLASS = F.CLASS_ID                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'			AND F.USE_FLAG = ''Y''                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'			WHERE 1=1                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'			AND NOT EXISTS (                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'						SELECT	1                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'						FROM	SCM_SYS_LOOKUP_VALUE AA                                                                                ' + char(10)
		SELECT @v_dSql +=	N'						WHERE	1=1                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'						AND		AA.LOOKUP_TYPE_CODE = ''E_POST_EXCEPT_PANCAKE''                                                          ' + char(10)
		SELECT @v_dSql +=	N'						AND		AA.ACTIVE_FLAG = ''Y''                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'						AND		AA.SEGMENT1 = '''+ @p_instance_id +'''                                                                              ' + char(10)
		SELECT @v_dSql +=	N'						AND		AA.SEGMENT2 = A.ITEM_ID                                                                                ' + char(10)
		SELECT @v_dSql +=	N'					 )                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                          ' + char(10)
		SELECT @v_dSql +=	N'			       , A.ITEM_ID, ISNULL(E.NICK_NAME,''-''),  A.FLOW_ID, A.NP_ITEM_ID, ISNULL(F.LEVEL_3_NAME,''-'')                              ' + char(10)
		SELECT @v_dSql +=	N'					, A.ELECTRODE_TYPE, A.ATTR_TYPE , A.PRODUCTION_TYPE, A.ATTR_TYPE                                           ' + char(10)
		SELECT @v_dSql +=	N'				     , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_GROUP                                        ' + char(10)
		SELECT @v_dSql +=	N'			) A                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'		WHERE 1=1                                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'	)                                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'	                                                                                                                               ' + char(10)
		
		-- UNIT 지정
		SELECT @v_dSql +=	N'	SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                             ' + char(10)
		SELECT @v_dSql +=	N'			, A.ITEM_ID, A.NICK_NAME, A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE			' + char(10)
		SELECT @v_dSql +=	N'			, A.LEVEL_3_NAME                                                                 ' + char(10)
		SELECT @v_dSql +=	N'			, A.CATEGORY_ID ' + char(10)
		SELECT @v_dSql +=	N'		    , CASE WHEN A.CATEGORY_ID = ''MOVING_PLAN'' AND ISNULL(B.MOVING_FACTORY,'''') = '''' THEN ''MOVING Plan (In)''   ' + char(10)
		SELECT @v_dSql +=	N'				   WHEN A.CATEGORY_ID = ''MOVING_PLAN'' AND ISNULL(B.MOVING_FACTORY,'''') != '''' THEN ''MOVING Plan (Out)'' ELSE A.CATEGORY_NAME END AS CATEGORY_NAME  ' + char(10)
		SELECT @v_dSql +=	N'			, A.CATEGORY_ORDER	' + char(10)
		SELECT @v_dSql +=	N'			, A.CATEGORY_GROUP	' + char(10)
		SELECT @v_dSql +=	N'			, A.JR_BOH                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.RP_BOH                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.A_TYPE_BOH       																									' + char(10)
		SELECT @v_dSql +=	N'			, A.B_TYPE_BOH       																									' + char(10)
		SELECT @v_dSql +=	N'			, A.ASSY_BOH                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.JR_BOH_QTY                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.RP_BOH_QTY                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.A_TYPE_BOH_QTY                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.B_TYPE_BOH_QTY                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.ASSY_BOH_QTY                                ' + char(10)
	
		SELECT @v_dSql +=	N'			, A.JR_BOH_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.RP_BOH_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.A_TYPE_BOH_ONLYHOLD       																									' + char(10)
		SELECT @v_dSql +=	N'			, A.B_TYPE_BOH_ONLYHOLD       																									' + char(10)
		SELECT @v_dSql +=	N'			, A.ASSY_BOH_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.JR_BOH_QTY_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.RP_BOH_QTY_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.A_TYPE_BOH_QTY_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.B_TYPE_BOH_QTY_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.ASSY_BOH_QTY_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.JR_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.A_TYPE_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.B_TYPE_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.PSI                                    ' + char(10)
		SELECT @v_dSql +=	N'			, A.DATA_TYPE                                                         ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , CASE WHEN A.DATA_TYPE = ''DATA'' AND CATEGORY_ID NOT IN (''SLITTING_ROLL_PLAN'', ''ROLL_PRESS_ROLL_PLAN'') THEN ROUND(CONVERT(FLOAT, M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') / '+ @p_unit +', '+ @p_round_point +') ELSE M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' END AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , CASE WHEN A.DATA_TYPE = ''DATA'' AND CATEGORY_ID NOT IN (''SLITTING_ROLL_PLAN'', ''ROLL_PRESS_ROLL_PLAN'') THEN ROUND(CONVERT(FLOAT, W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') / '+ @p_unit +', '+ @p_round_point +') ELSE W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' END AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , CASE WHEN A.DATA_TYPE = ''DATA'' AND CATEGORY_ID NOT IN (''SLITTING_ROLL_PLAN'', ''ROLL_PRESS_ROLL_PLAN'') THEN ROUND(CONVERT(FLOAT, D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') / '+ @p_unit +', '+ @p_round_point +') ELSE D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' END AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql +=	N'			, A.JR_TEMP_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.A_TYPE_TEMP_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'			, A.B_TYPE_TEMP_CAPA                                ' + char(10)
		
		SELECT @v_dSql +=	N'			, A.ROLL_QTY                               														 ' + char(10)
		SELECT @v_dSql +=	N'			, A.JUMBO_ROLL_LENGTH                               														 ' + char(10)
		SELECT @v_dSql +=	N'			, A.PC_ROLL_LENGTH                               														 ' + char(10)
		SELECT @v_dSql +=	N'			, A.LANE_QTY                                														 ' + char(10)
		SELECT @v_dSql +=	N'			, A.M_PER_ROLL_QTY                                														 ' + char(10)
		SELECT @v_dSql +=	N'			, A.METER_PER_ROLL                                 														 ' + char(10)
		SELECT @v_dSql +=	N'		    , CASE WHEN A.CATEGORY_ID = ''MOVING_PLAN'' AND ISNULL(B.MOVING_FACTORY,'''') = '''' THEN ''N'' ELSE A.EDIT_YN END AS EDIT_YN                                         ' + char(10)
		SELECT @v_dSql +=	N'		    , B.MOVING_FACTORY                                         ' + char(10)
		
		SELECT @v_dSql +=	N'	FROM	(	' + char(10)

		SELECT @v_dSql +=	N'	SELECT	A.*	' + char(10)
		--SELECT @v_dSql +=	N'		   , CASE WHEN DATA_TYPE = ''DATA'' THEN ISNULL(C.ROLL_QTY, (CASE WHEN '''+ @p_uom_type +''' = ''JR'' THEN D.JR_COL			 ' + char(10)
		--SELECT @v_dSql +=	N'		   		  												          WHEN A.ATTR_TYPE = ''A'' THEN D.A_TYPE_COL				 ' + char(10)
		--SELECT @v_dSql +=	N'		   		  												          WHEN A.ATTR_TYPE = ''B'' THEN D.B_TYPE_COL				 ' + char(10)
		--SELECT @v_dSql +=	N'		   		  												          ELSE 1 END)	)											 ' + char(10)
		--SELECT @v_dSql +=	N'				  ELSE 0 																									 ' + char(10)
		--SELECT @v_dSql +=	N'				  END AS ROLL_QTY                                        														 ' + char(10)
		--SELECT @v_dSql +=	N'			, C.JUMBO_ROLL_LENGTH                                        														 ' + char(10)
		--SELECT @v_dSql +=	N'			, C.PC_ROLL_LENGTH                                        														 ' + char(10)
		--SELECT @v_dSql +=	N'			, C.LANE_QTY                                        														 ' + char(10)
		SELECT @v_dSql +=	N'			, 1 AS ROLL_QTY -- defalut 처리를 MAIN_ROLL 에서 하여 기본값으로 처리                               														 ' + char(10)
		SELECT @v_dSql +=	N'			, S.JUMBO_ROLL_LENGTH AS JUMBO_ROLL_LENGTH                               														 ' + char(10)
		SELECT @v_dSql +=	N'			, S.PC_ROLL_LENGTH AS PC_ROLL_LENGTH                               														 ' + char(10)
		SELECT @v_dSql +=	N'			, S.LANE_QTY                                														 ' + char(10)
		SELECT @v_dSql +=	N'			, S.M_PER_ROLL_QTY                                														 ' + char(10)
		SELECT @v_dSql +=	N'			, CONCAT(''JR : ''+ FORMAT( S.JR_M_PER_ROLL_QTY , ''#,###,##0.##'') , char(13)+char(10)    ' + char(10)
		SELECT @v_dSql +=	N'					+ ''PC : '' + FORMAT( S.PC_M_PER_ROLL_QTY , ''#,###,##0.##'') ) AS METER_PER_ROLL                      ' + char(10)


		SELECT @v_dSql +=	N'		   , CASE WHEN R.FACTORY_ID IS NULL THEN ''N''                                                                              ' + char(10)
		SELECT @v_dSql +=	N'				  WHEN '''+ @p_plan_type +''' = ''RELEASE'' THEN ''N''                                                                              ' + char(10)
		SELECT @v_dSql +=	N'				  WHEN '''+ @p_uom_type +''' != ''JR'' THEN ''N''              ' + char(10)
		SELECT @v_dSql +=	N'				  WHEN DATA_TYPE != ''DATA'' THEN ''N''                                                                              ' + char(10)
		SELECT @v_dSql +=	N'				  WHEN RIGHT('''+ @p_plan_id +''',2) = ''00'' THEN ''N''                   ' + char(10)
		SELECT @v_dSql +=	N'				  WHEN A.FLOW_ID = ''E2000E3000E4000'' AND ( CATEGORY_ID = ''SLITTING_PLAN'' OR CATEGORY_ID = ''ROLL_PRESS_PLAN'' OR CATEGORY_ID = ''MOVING_PLAN'')  THEN ''Y''        ' + char(10)
		SELECT @v_dSql +=	N'				  WHEN A.FLOW_ID = ''E2000E3000'' AND ( CATEGORY_ID = ''ROLL_PRESS_PLAN'' OR CATEGORY_ID = ''MOVING_PLAN'')  THEN ''Y''        ' + char(10)
		SELECT @v_dSql +=	N'		          ELSE ''N'' END AS EDIT_YN                                         ' + char(10)
		SELECT @v_dSql +=	N'		     , '''+ @p_cal_type +'''  AS CAL_TYPE                                         ' + char(10)
		SELECT @v_dSql +=	N'	FROM	(		' + char(10)
		SELECT @v_dSql +=	N'				SELECT *                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'						, NULL AS JR_TEMP_CAPA                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'						, NULL AS A_TYPE_TEMP_CAPA                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'						, NULL AS B_TYPE_TEMP_CAPA                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'				FROM MAIN_T  A                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'				WHERE 1=1                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'				AND NOT EXISTS (                                             ' + char(10)
		SELECT @v_dSql +=	N'									SELECT	1                                             ' + char(10)
		SELECT @v_dSql +=	N'									FROM	(                                             ' + char(10)
		SELECT @v_dSql +=	N'												SELECT	A.ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE           ' + char(10)
		SELECT @v_dSql +=	N'												FROM	(          ' + char(10)
		SELECT @v_dSql +=	N'															SELECT DISTINCT A.ITEM_ID, CASE WHEN A.ELECTRODE_TYPE = ''A'' THEN  ''ANODE'' ELSE ''CATHODE'' END AS ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, MAX(A.ATTB_4) AS MOVING_FACTORY	   ' + char(10)
		SELECT @v_dSql +=	N'															FROM FP_ELECTRODE_POST_PLAN_H A WITH(NOLOCK)																															   ' + char(10)
		SELECT @v_dSql +=	N'															WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'															AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                                                                                                           ' + char(10)
		--SELECT @v_dSql +=	N'															AND    A.CATEGORY  = ''12-Moving Plan''                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'															AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'															GROUP BY A.ITEM_ID, CASE WHEN A.ELECTRODE_TYPE = ''A'' THEN  ''ANODE'' ELSE ''CATHODE'' END, A.PRODUCTION_TYPE, A.ATTR_TYPE           ' + char(10)
		SELECT @v_dSql +=	N'														) A          ' + char(10)
		SELECT @v_dSql +=	N'												WHERE	1=1          ' + char(10)
		SELECT @v_dSql +=	N'												AND		ISNULL(A.MOVING_FACTORY,'''') = ''''          ' + char(10)
		SELECT @v_dSql +=	N'											) B													   ' + char(10)
		SELECT @v_dSql +=	N'									WHERE	1=1													 ' + char(10)
		SELECT @v_dSql +=	N'									AND		A.CATEGORY_ID		= ''MOVING_PLAN''               ' + char(10)
		SELECT @v_dSql +=	N'									AND		A.ITEM_ID			= B.ITEM_ID                  ' + char(10)
		SELECT @v_dSql +=	N'									AND		A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE           ' + char(10)
		SELECT @v_dSql +=	N'									AND		A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE           ' + char(10)
		SELECT @v_dSql +=	N'									AND		A.ATTR_TYPE			= B.ATTR_TYPE     			 ' + char(10)
		SELECT @v_dSql +=	N'								)                                            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))                + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                + char(10)	-- sub total 은 factory 기준
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LK', @p_nick_name))                + char(10)	-- sub total 은 factory 기준
		SELECT @v_dSql +=	N'				UNION ALL                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'				SELECT *                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'						, NULL AS JR_TEMP_CAPA                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'						, NULL AS A_TYPE_TEMP_CAPA                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'						, NULL AS B_TYPE_TEMP_CAPA                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'				FROM MAIN_I A                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'				WHERE 1=1                                                                                                                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))                + char(10)	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                + char(10)	-- sub total 은 factory 기준
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LK', @p_nick_name))                + char(10)	-- sub total 은 factory 기준
		SELECT @v_dSql +=	N'				UNION ALL                                                              ' + char(10)
		SELECT @v_dSql +=	N'				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                             ' + char(10)
		SELECT @v_dSql +=	N'						, NULL AS ITEM_ID, NULL AS NICK_NAME, NULL AS FLOW_ID, NULL AS NP_ITEM_ID, A.ELECTRODE_TYPE AS ELECTRODE_TYPE, NULL AS PRODUCTION_TYPE, NULL AS ATTR_TYPE			' + char(10)
		SELECT @v_dSql +=	N'						, A.LEVEL_3_NAME , A.CATEGORY_ID, A.CATEGORY_NAME ' + char(10)
		SELECT @v_dSql +=	N'						, A.CATEGORY_ORDER	' + char(10)
		SELECT @v_dSql +=	N'						, A.CATEGORY_GROUP	' + char(10)
		SELECT @v_dSql +=	N'						, CASE WHEN ISNULL(P.JR_COL,''X'') = ''X''  THEN ''-''	' + char(10)
		SELECT @v_dSql +=	N'							   ELSE CONCAT( ''Qty : '' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( SUM(K.JR_QTY)  / '+@p_unit+'  , 0) AS MONEY),1),''.00'','''')	, char(13),char(10),											' + char(10)		                           
		SELECT @v_dSql +=	N'								  	   	+ ''Load : '' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( SUM(K.JR_QTY_LOT_COUNT) / (CASE WHEN MAX(P.JR_WH_CAPA)+MAX(P.JR_TEMP_CAPA) = 0 THEN 1 ELSE MAX(P.JR_WH_CAPA)+MAX(P.JR_TEMP_CAPA) END) * 100 ,0) AS MONEY),1),''.00'','''') 	' + char(10)
		SELECT @v_dSql +=	N'										+ ''%'', char(13),char(10), ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(SUM(K.JR_QTY_LOT_COUNT),0) AS MONEY),1),''.00'','''') 		' + char(10)
		SELECT @v_dSql +=	N'										+ ''/'' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL((MAX(P.JR_WH_CAPA)+MAX(P.JR_TEMP_CAPA))  ,0) AS MONEY),1),''.00'','''') 		' + char(10)
		SELECT @v_dSql +=	N'										+ '')'' ) END AS JR_BOH       																									' + char(10)
		SELECT @v_dSql +=	N'						, ''-'' AS RP_BOH                                ' + char(10)
		SELECT @v_dSql +=	N'						, CASE WHEN ISNULL(P.A_TYPE_COL,''X'') = ''X''  THEN ''-''	' + char(10)
		SELECT @v_dSql +=	N'							   ELSE CONCAT( ''Qty : '' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( SUM(K.A_TOTAL_QTY) / '+@p_unit+' ,0) AS MONEY),1),''.00'','''')		, char(13),char(10),										' + char(10)		                           
		SELECT @v_dSql +=	N'								  	   	+ ''Load : '' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( SUM(K.A_TOTAL_LOT_COUNT) / (CASE WHEN MAX(P.A_TYPE_WH_CAPA)+MAX(P.A_TYPE_TEMP_CAPA) = 0 THEN 1 ELSE MAX(P.A_TYPE_WH_CAPA)+MAX(P.A_TYPE_TEMP_CAPA) END) * 100 ,0) AS MONEY),1),''.00'','''') 	' + char(10)
		SELECT @v_dSql +=	N'										+ ''%'' , char(13),char(10), ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(SUM(K.A_TOTAL_LOT_COUNT),0) AS MONEY),1),''.00'','''') 		' + char(10)
		SELECT @v_dSql +=	N'										+ ''/'' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL((MAX(P.A_TYPE_WH_CAPA)+MAX(P.A_TYPE_TEMP_CAPA))  ,0) AS MONEY),1),''.00'','''') 		' + char(10)
		SELECT @v_dSql +=	N'										+ '')'' ) END AS A_TYPE_BOH       																									' + char(10)
		SELECT @v_dSql +=	N'						, CASE WHEN ISNULL(P.B_TYPE_COL,''X'') = ''X''  THEN ''-''	' + char(10)
		SELECT @v_dSql +=	N'							   ELSE CONCAT( ''Qty : '' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( SUM(K.B_TOTAL_QTY) / '+@p_unit+'  ,0) AS MONEY),1),''.00'','''')	, char(13),char(10),											' + char(10)		                           
		SELECT @v_dSql +=	N'								  	   	+ ''Load : '' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( SUM(K.B_TOTAL_LOT_COUNT) / (CASE WHEN MAX(P.B_TYPE_WH_CAPA)+MAX(P.B_TYPE_TEMP_CAPA) = 0 THEN 1 ELSE MAX(P.B_TYPE_WH_CAPA)+MAX(P.B_TYPE_TEMP_CAPA) END) * 100 ,0) AS MONEY),1),''.00'','''') 	' + char(10)
		SELECT @v_dSql +=	N'										+ ''%'' , char(13),char(10), ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(SUM(K.B_TOTAL_LOT_COUNT),0) AS MONEY),1),''.00'','''') 		' + char(10)
		SELECT @v_dSql +=	N'										+ ''/'' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL((MAX(P.B_TYPE_WH_CAPA)+MAX(P.B_TYPE_TEMP_CAPA))  ,0) AS MONEY),1),''.00'','''') 		' + char(10)
		SELECT @v_dSql +=	N'										+ '')'' ) END AS B_TYPE_BOH       																									' + char(10)
		SELECT @v_dSql +=	N'						, ''-'' AS ASSY_BOH                                ' + char(10)
		SELECT @v_dSql +=	N'						, SUM(E.JR_R_BOH_QTY) AS JR_BOH_QTY                                ' + char(10)
		SELECT @v_dSql +=	N'						, SUM(E.RP_R_BOH_QTY) AS RP_BOH_QTY                                ' + char(10)
		SELECT @v_dSql +=	N'						, SUM(E.A_TYPE_R_BOH_QTY) AS A_TYPE_BOH_QTY                                ' + char(10)
		SELECT @v_dSql +=	N'						, SUM(E.B_TYPE_R_BOH_QTY) AS B_TYPE_BOH_QTY                                ' + char(10)
		SELECT @v_dSql +=	N'						, SUM(E.ASSY_R_BOH_QTY) AS ASSY_BOH_QTY                                ' + char(10)
		
		SELECT @v_dSql +=	N'						, CASE WHEN ISNULL(P.JR_COL,''X'') = ''X''  THEN ''-''	' + char(10)
		SELECT @v_dSql +=	N'							   ELSE CONCAT( ''Qty : '' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( SUM(K.JR_QTY_ONLYHOLD) / '+@p_unit+' ,0) AS MONEY),1),''.00'','''')	, char(13),char(10),											' + char(10)		                           
		SELECT @v_dSql +=	N'								  	   	+ ''Load : '' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( SUM(K.JR_QTY_LOT_COUNT_ONLYHOLD) / (CASE WHEN MAX(P.JR_WH_CAPA)+MAX(P.JR_TEMP_CAPA) = 0 THEN 1 ELSE MAX(P.JR_WH_CAPA)+MAX(P.JR_TEMP_CAPA) END) * 100 ,0) AS MONEY),1),''.00'','''') 	' + char(10)
		SELECT @v_dSql +=	N'										+ ''%'', char(13),char(10), ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(SUM(K.JR_QTY_LOT_COUNT_ONLYHOLD),0) AS MONEY),1),''.00'','''') 		' + char(10)
		SELECT @v_dSql +=	N'										+ ''/'' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL((MAX(P.JR_WH_CAPA)+MAX(P.JR_TEMP_CAPA))  ,0) AS MONEY),1),''.00'','''') 		' + char(10)
		SELECT @v_dSql +=	N'										+ '')'' ) END AS JR_BOH_ONLYHOLD       																									' + char(10)
		SELECT @v_dSql +=	N'						, ''-'' AS RP_BOH_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'						, CASE WHEN ISNULL(P.A_TYPE_COL,''X'') = ''X''  THEN ''-''	' + char(10)
		SELECT @v_dSql +=	N'							   ELSE CONCAT( ''Qty : '' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( SUM(K.A_TOTAL_QTY_ONLYHOLD) / '+@p_unit+' ,0) AS MONEY),1),''.00'','''')		, char(13),char(10),										' + char(10)		                           
		SELECT @v_dSql +=	N'								  	   	+ ''Load : '' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( SUM(K.A_TOTAL_LOT_COUNT_ONLYHOLD) / (CASE WHEN MAX(P.A_TYPE_WH_CAPA)+MAX(P.A_TYPE_TEMP_CAPA) = 0 THEN 1 ELSE MAX(P.A_TYPE_WH_CAPA)+MAX(P.A_TYPE_TEMP_CAPA) END) * 100 ,0) AS MONEY),1),''.00'','''') 	' + char(10)
		SELECT @v_dSql +=	N'										+ ''%'' , char(13),char(10), ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(SUM(K.A_TOTAL_LOT_COUNT_ONLYHOLD),0) AS MONEY),1),''.00'','''') 		' + char(10)
		SELECT @v_dSql +=	N'										+ ''/'' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL((MAX(P.A_TYPE_WH_CAPA)+MAX(P.A_TYPE_TEMP_CAPA))  ,0) AS MONEY),1),''.00'','''') 		' + char(10)
		SELECT @v_dSql +=	N'										+ '')'' ) END AS A_TYPE_BOH_ONLYHOLD       																									' + char(10)
		SELECT @v_dSql +=	N'						, CASE WHEN ISNULL(P.B_TYPE_COL,''X'') = ''X''  THEN ''-''	' + char(10)
		SELECT @v_dSql +=	N'							   ELSE CONCAT( ''Qty : '' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( SUM(K.B_TOTAL_QTY_ONLYHOLD) / '+@p_unit+' ,0) AS MONEY),1),''.00'','''')	, char(13),char(10),											' + char(10)		                           
		SELECT @v_dSql +=	N'								  	   	+ ''Load : '' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL( SUM(K.B_TOTAL_LOT_COUNT_ONLYHOLD) / (CASE WHEN MAX(P.B_TYPE_WH_CAPA)+MAX(P.B_TYPE_TEMP_CAPA) = 0 THEN 1 ELSE MAX(P.B_TYPE_WH_CAPA)+MAX(P.B_TYPE_TEMP_CAPA) END) * 100 ,0) AS MONEY),1),''.00'','''') 	' + char(10)
		SELECT @v_dSql +=	N'										+ ''%'' , char(13),char(10), ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(SUM(K.B_TOTAL_LOT_COUNT_ONLYHOLD),0) AS MONEY),1),''.00'','''') 		' + char(10)
		SELECT @v_dSql +=	N'										+ ''/'' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL((MAX(P.B_TYPE_WH_CAPA)+MAX(P.B_TYPE_TEMP_CAPA))  ,0) AS MONEY),1),''.00'','''') 		' + char(10)
		SELECT @v_dSql +=	N'										+ '')'' ) END AS B_TYPE_BOH_ONLYHOLD       																									' + char(10)
		SELECT @v_dSql +=	N'						, ''-'' AS ASSY_BOH_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'						, SUM(E.JR_R_BOH_QTY_ONLYHOLD) AS JR_BOH_QTY_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'						, SUM(E.RP_R_BOH_QTY_ONLYHOLD) AS RP_BOH_QTY_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'						, SUM(E.A_TYPE_R_BOH_QTY_ONLYHOLD) AS A_TYPE_BOH_QTY_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'						, SUM(E.B_TYPE_R_BOH_QTY_ONLYHOLD) AS B_TYPE_BOH_QTY_ONLYHOLD                                ' + char(10)
		SELECT @v_dSql +=	N'						, SUM(E.ASSY_R_BOH_QTY_ONLYHOLD) AS ASSY_BOH_QTY_ONLYHOLD                                ' + char(10)
		
		SELECT @v_dSql +=	N'						, MAX(P.JR_WH_CAPA) AS JR_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'						, MAX(P.A_TYPE_WH_CAPA) AS A_TYPE_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'						, MAX(P.B_TYPE_WH_CAPA) AS B_TYPE_WH_CAPA                                ' + char(10)

		SELECT @v_dSql +=	N'						, ''I'' AS PSI                                    ' + char(10)
		SELECT @v_dSql +=	N'						, ''TOTAL'' AS DATA_TYPE                                                         ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''

		SELECT @v_dSql +=	N'						, MAX(P.JR_TEMP_CAPA) AS JR_TEMP_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'						, MAX(P.A_TYPE_TEMP_CAPA) AS A_TYPE_TEMP_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'						, MAX(P.B_TYPE_TEMP_CAPA) AS B_TYPE_TEMP_CAPA                                ' + char(10)

		SELECT @v_dSql +=	N'		  FROM	(                               ' + char(10)
		
		
		SELECT @v_dSql +=	N'					SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.ELECTRODE_TYPE   ' + char(10)                                                                              
		SELECT @v_dSql +=	N'							, B.ATTR_TYPE AS  LEVEL_3_NAME                                                                 ' + char(10)
		SELECT @v_dSql +=	N'							, WH_GROUP_NAME1 AS CATEGORY_ID, B.WH_GROUP_NAME2  AS CATEGORY_NAME ' + char(10)
		SELECT @v_dSql +=	N'							, CASE WHEN B.ATTR_TYPE = ''-'' THEN 1	' + char(10)
		SELECT @v_dSql +=	N'								   WHEN B.ATTR_TYPE = ''A'' THEN 2	' + char(10)
		SELECT @v_dSql +=	N'								   WHEN B.ATTR_TYPE = ''B'' THEN 3	' + char(10)
		SELECT @v_dSql +=	N'								   ELSE 4 END   AS CATEGORY_ORDER	' + char(10)
		SELECT @v_dSql +=	N'							, B.STR AS CATEGORY_GROUP	' + char(10)
		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , NULL AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''
		SELECT @v_dSql +=	N'					FROM	MAIN_T A     			' + char(10)
		SELECT @v_dSql +=	N'							LEFT OUTER JOIN ( 							' + char(10)                                                                                                                                                                                  
		SELECT @v_dSql +=	N'								SELECT	B.* 			' + char(10)
		SELECT @v_dSql +=	N'										, CASE WHEN C.INT = 1 THEN ''TOTAL_LOAD''					' + char(10)
		SELECT @v_dSql +=	N'											   ELSE ''TOTAL_ROLL'' END WH_GROUP_NAME1					' + char(10)
		SELECT @v_dSql +=	N'										, CASE WHEN C.INT = 1 THEN CONCAT(B.WH_GROUP_NAME,''(%)'')					' + char(10)
		SELECT @v_dSql +=	N'											   ELSE CONCAT(B.WH_GROUP_NAME,''(Roll)'') END WH_GROUP_NAME2					' + char(10)
		SELECT @v_dSql +=	N'										, C.STR					' + char(10)
		SELECT @v_dSql +=	N'								FROM WH_CAPA_TOTAL B											' + char(10)
		SELECT @v_dSql +=	N'									 JOIN COPYT C												' + char(10)
		SELECT @v_dSql +=	N'									 ON 1=1												' + char(10)
		SELECT @v_dSql +=	N'									 AND INT < 3											' + char(10)
		SELECT @v_dSql +=	N'							) B											' + char(10)
		SELECT @v_dSql +=	N'							ON 1=1												' + char(10)
		SELECT @v_dSql +=	N'							AND A.FACTORY_ID = B.FACTORY_ID						' + char(10)
		SELECT @v_dSql +=	N'							AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE			' + char(10)
		SELECT @v_dSql +=	N'					WHERE	1=1	' + char(10)
		SELECT @v_dSql +=	N'					GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.ELECTRODE_TYPE          ' + char(10)          
		SELECT @v_dSql +=	N'							, B.ATTR_TYPE                                                                 ' + char(10)
		SELECT @v_dSql +=	N'							, WH_GROUP_NAME1, B.WH_GROUP_NAME2 ' + char(10)
		SELECT @v_dSql +=	N'							, CASE WHEN B.ATTR_TYPE = ''-'' THEN 1	' + char(10)
		SELECT @v_dSql +=	N'								   WHEN B.ATTR_TYPE = ''A'' THEN 2	' + char(10)
		SELECT @v_dSql +=	N'								   WHEN B.ATTR_TYPE = ''B'' THEN 3	' + char(10)
		SELECT @v_dSql +=	N'								   ELSE 4 END   	' + char(10)
		SELECT @v_dSql +=	N'							, B.STR	' + char(10)
		SELECT @v_dSql +=	N'					UNION ALL   ' + char(10)  
		SELECT @v_dSql +=	N'					SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.ELECTRODE_TYPE   ' + char(10)        
		SELECT @v_dSql +=	N'							, NULL AS LEVEL_3_NAME, A.CATEGORY_ID AS CATEGORY_ID, A.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_GROUP   ' + char(10)        
		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +')  / '+@p_unit+' AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +')  / '+@p_unit+' AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +')  / '+@p_unit+' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END -- end of @mst_loop_cnt < @max_loop_cnt
			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''
		SELECT @v_dSql +=	N'					FROM	MAIN_T A     			' + char(10)
		SELECT @v_dSql +=	N'							INNER JOIN (																													  ' + char(10) 
		SELECT @v_dSql +=	N'											SELECT ''COATING_PLAN'' AS CATEGORY_ID, 10 AS CATEGORY_ORDER, 10 AS CATEGORY_GROUP UNION	  ' + char(10) 
		SELECT @v_dSql +=	N'											SELECT ''ROLL_PRESS_PLAN'' AS CATEGORY_ID, 20 AS CATEGORY_ORDER, 20 AS CATEGORY_GROUP UNION	  ' + char(10) 
		SELECT @v_dSql +=	N'											SELECT ''SLITTING_PLAN'' AS CATEGORY_ID, 30 AS CATEGORY_ORDER, 30 AS CATEGORY_GROUP UNION	  ' + char(10) 
		SELECT @v_dSql +=	N'											SELECT ''NOTCHING_PLAN'' AS CATEGORY_ID, 40 AS CATEGORY_ORDER, 40 AS CATEGORY_GROUP			  ' + char(10) 
		SELECT @v_dSql +=	N'										) B																							  ' + char(10) 
		SELECT @v_dSql +=	N'							ON 1=1																									  ' + char(10) 
		SELECT @v_dSql +=	N'							AND A.CATEGORY_ID = B.CATEGORY_ID																		  ' + char(10) 
		SELECT @v_dSql +=	N'					WHERE	1=1	' + char(10)
		SELECT @v_dSql +=	N'					GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.ELECTRODE_TYPE          ' + char(10)   
		SELECT @v_dSql +=	N'							, A.CATEGORY_ID, A.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_GROUP   ' + char(10)        
		SELECT @v_dSql +=	N'				) A                                                 ' + char(10)
		SELECT @v_dSql +=	N'				INNER JOIN WH_CAPA_PIVOT P								' + char(10)                                                                                                                                                                                  
		SELECT @v_dSql +=	N'					ON 1=1												' + char(10)
		SELECT @v_dSql +=	N'					AND A.FACTORY_ID = P.FACTORY_ID						' + char(10)
		SELECT @v_dSql +=	N'					AND A.ELECTRODE_TYPE = P.ELECTRODE_TYPE			' + char(10)
		--SELECT @v_dSql +=	N'				LEFT OUTER HASH JOIN LANE_T C                                                 ' + char(10)
		--SELECT @v_dSql +=	N'				    ON 1=1                                                          ' + char(10)
		--SELECT @v_dSql +=	N'					AND A.PLANT_ID = C.PLANT_ID							' + char(10)
		--SELECT @v_dSql +=	N'					AND A.FACTORY_ID = C.FACTORY_ID						' + char(10)
		--SELECT @v_dSql +=	N'					AND A.ITEM_ID = C.ITEM_ID							' + char(10)
		SELECT @v_dSql +=	N'				LEFT OUTER HASH JOIN (									' + char(10)
		SELECT @v_dSql +=	N'					SELECT FACTORY_ID, ELECTRODE_TYPE, ITEM_ID			' + char(10)
		SELECT @v_dSql +=	N'							, MAX(JR_BOH) AS JR_BOH_QTY					' + char(10)
		SELECT @v_dSql +=	N'							, MAX(RP_BOH    ) AS RP_BOH_QTY         	' + char(10)
		SELECT @v_dSql +=	N'							, MAX(A_TYPE_BOH) AS A_TYPE_BOH_QTY     	' + char(10)
		SELECT @v_dSql +=	N'							, MAX(B_TYPE_BOH) AS B_TYPE_BOH_QTY     	' + char(10)
		SELECT @v_dSql +=	N'							, MAX(ASSY_BOH  ) AS ASSY_BOH_QTY 			' + char(10)
		SELECT @v_dSql +=	N'							, MAX(JR_R_BOH) AS JR_R_BOH_QTY				' + char(10)
		SELECT @v_dSql +=	N'							, MAX(RP_R_BOH    ) AS RP_R_BOH_QTY         ' + char(10)
		SELECT @v_dSql +=	N'							, MAX(A_TYPE_R_BOH) AS A_TYPE_R_BOH_QTY     ' + char(10)
		SELECT @v_dSql +=	N'							, MAX(B_TYPE_R_BOH) AS B_TYPE_R_BOH_QTY     ' + char(10)
		SELECT @v_dSql +=	N'							, MAX(ASSY_R_BOH  ) AS ASSY_R_BOH_QTY   	' + char(10)
		SELECT @v_dSql +=	N'							, MAX(JR_BOH_HOLD) AS JR_BOH_QTY_HOLD					' + char(10)
		SELECT @v_dSql +=	N'							, MAX(RP_BOH_HOLD    ) AS RP_BOH_QTY_HOLD         	' + char(10)
		SELECT @v_dSql +=	N'							, MAX(A_TYPE_BOH_HOLD) AS A_TYPE_BOH_QTY_HOLD     	' + char(10)
		SELECT @v_dSql +=	N'							, MAX(B_TYPE_BOH_HOLD) AS B_TYPE_BOH_QTY_HOLD     	' + char(10)
		SELECT @v_dSql +=	N'							, MAX(ASSY_BOH_HOLD  ) AS ASSY_BOH_QTY_HOLD 			' + char(10)
		SELECT @v_dSql +=	N'							, MAX(JR_R_BOH_HOLD) AS JR_R_BOH_QTY_HOLD				' + char(10)
		SELECT @v_dSql +=	N'							, MAX(RP_R_BOH_HOLD    ) AS RP_R_BOH_QTY_HOLD         ' + char(10)
		SELECT @v_dSql +=	N'							, MAX(A_TYPE_R_BOH_HOLD) AS A_TYPE_R_BOH_QTY_HOLD     ' + char(10)
		SELECT @v_dSql +=	N'							, MAX(B_TYPE_R_BOH_HOLD) AS B_TYPE_R_BOH_QTY_HOLD     ' + char(10)
		SELECT @v_dSql +=	N'							, MAX(ASSY_R_BOH_HOLD  ) AS ASSY_R_BOH_QTY_HOLD   	' + char(10)
		SELECT @v_dSql +=	N'							, MAX(JR_BOH_ONLYHOLD) AS JR_BOH_QTY_ONLYHOLD					' + char(10)
		SELECT @v_dSql +=	N'							, MAX(RP_BOH_ONLYHOLD    ) AS RP_BOH_QTY_ONLYHOLD         	' + char(10)
		SELECT @v_dSql +=	N'							, MAX(A_TYPE_BOH_ONLYHOLD) AS A_TYPE_BOH_QTY_ONLYHOLD     	' + char(10)
		SELECT @v_dSql +=	N'							, MAX(B_TYPE_BOH_ONLYHOLD) AS B_TYPE_BOH_QTY_ONLYHOLD     	' + char(10)
		SELECT @v_dSql +=	N'							, MAX(ASSY_BOH_ONLYHOLD  ) AS ASSY_BOH_QTY_ONLYHOLD 			' + char(10)
		SELECT @v_dSql +=	N'							, MAX(JR_R_BOH_ONLYHOLD) AS JR_R_BOH_QTY_ONLYHOLD				' + char(10)
		SELECT @v_dSql +=	N'							, MAX(RP_R_BOH_ONLYHOLD    ) AS RP_R_BOH_QTY_ONLYHOLD         ' + char(10)
		SELECT @v_dSql +=	N'							, MAX(A_TYPE_R_BOH_ONLYHOLD) AS A_TYPE_R_BOH_QTY_ONLYHOLD     ' + char(10)
		SELECT @v_dSql +=	N'							, MAX(B_TYPE_R_BOH_ONLYHOLD) AS B_TYPE_R_BOH_QTY_ONLYHOLD     ' + char(10)
		SELECT @v_dSql +=	N'							, MAX(ASSY_R_BOH_ONLYHOLD  ) AS ASSY_R_BOH_QTY_ONLYHOLD   	' + char(10)
		SELECT @v_dSql +=	N'					FROM #MAIN_P A										' + char(10)
		SELECT @v_dSql +=	N'					WHERE 1=1											' + char(10)
		SELECT @v_dSql +=	N'					GROUP BY FACTORY_ID, ELECTRODE_TYPE, ITEM_ID		' + char(10)
		SELECT @v_dSql +=	N'				) E														' + char(10)
		SELECT @v_dSql +=	N'				ON 1=1													' + char(10)
		SELECT @v_dSql +=	N'				AND E.FACTORY_ID = A.FACTORY_ID							' + char(10)
		SELECT @v_dSql +=	N'				AND E.ELECTRODE_TYPE = A.ELECTRODE_TYPE					' + char(10)
		SELECT @v_dSql +=	N'				AND E.ITEM_ID = A.ITEM_ID								' + char(10)
		SELECT @v_dSql +=	N'				LEFT OUTER HASH JOIN (																									' + char(10)                                                                 
		SELECT @v_dSql +=	N'										SELECT FACTORY_ID, ITEM_ID  																	' + char(10)
		SELECT @v_dSql +=	N'												, SUM(CASE WHEN ATTR_TYPE = ''A'' THEN POST_ST_PC ELSE 0 END) A_TOTAL_QTY					' + char(10)
		SELECT @v_dSql +=	N'												, SUM(CASE WHEN ATTR_TYPE = ''A'' THEN POST_ST_PC_R ELSE 0 END) A_TOTAL_LOT_COUNT		' + char(10)
		SELECT @v_dSql +=	N'												, SUM(CASE WHEN ATTR_TYPE = ''B'' THEN POST_ST_PC ELSE 0 END) B_TOTAL_QTY					' + char(10)
		SELECT @v_dSql +=	N'												, SUM(CASE WHEN ATTR_TYPE = ''B'' THEN POST_ST_PC_R ELSE 0 END) B_TOTAL_LOT_COUNT		' + char(10)
		SELECT @v_dSql +=	N'												, SUM(JR_QTY + PRE_ST_JR) AS JR_QTY																	' + char(10)
		SELECT @v_dSql +=	N'												, SUM(JR_QTY_LOT_COUNT + PRE_ST_JR_R) AS JR_QTY_LOT_COUNT												' + char(10)

		SELECT @v_dSql +=	N'												, SUM(CASE WHEN ATTR_TYPE = ''A'' THEN POST_ST_PC_HOLD ELSE 0 END) A_TOTAL_QTY_HOLD					' + char(10)
		SELECT @v_dSql +=	N'												, SUM(CASE WHEN ATTR_TYPE = ''A'' THEN POST_ST_PC_R_HOLD ELSE 0 END) A_TOTAL_LOT_COUNT_HOLD		' + char(10)
		SELECT @v_dSql +=	N'												, SUM(CASE WHEN ATTR_TYPE = ''B'' THEN POST_ST_PC_HOLD ELSE 0 END) B_TOTAL_QTY_HOLD					' + char(10)
		SELECT @v_dSql +=	N'												, SUM(CASE WHEN ATTR_TYPE = ''B'' THEN POST_ST_PC_R_HOLD ELSE 0 END) B_TOTAL_LOT_COUNT_HOLD		' + char(10)
		SELECT @v_dSql +=	N'												, SUM(JR_QTY_HOLD + PRE_ST_JR_HOLD) AS JR_QTY_HOLD																	' + char(10)
		SELECT @v_dSql +=	N'												, SUM(JR_QTY_LOT_COUNT_HOLD + PRE_ST_JR_R_HOLD) AS JR_QTY_LOT_COUNT_HOLD												' + char(10)

		SELECT @v_dSql +=	N'												, SUM(CASE WHEN ATTR_TYPE = ''A'' THEN POST_ST_PC_ONLYHOLD ELSE 0 END) A_TOTAL_QTY_ONLYHOLD					' + char(10)
		SELECT @v_dSql +=	N'												, SUM(CASE WHEN ATTR_TYPE = ''A'' THEN POST_ST_PC_R_ONLYHOLD ELSE 0 END) A_TOTAL_LOT_COUNT_ONLYHOLD		' + char(10)
		SELECT @v_dSql +=	N'												, SUM(CASE WHEN ATTR_TYPE = ''B'' THEN POST_ST_PC_ONLYHOLD ELSE 0 END) B_TOTAL_QTY_ONLYHOLD					' + char(10)
		SELECT @v_dSql +=	N'												, SUM(CASE WHEN ATTR_TYPE = ''B'' THEN POST_ST_PC_R_ONLYHOLD ELSE 0 END) B_TOTAL_LOT_COUNT_ONLYHOLD		' + char(10)
		SELECT @v_dSql +=	N'												, SUM(JR_QTY_ONLYHOLD + PRE_ST_JR_ONLYHOLD) AS JR_QTY_ONLYHOLD																	' + char(10)
		SELECT @v_dSql +=	N'												, SUM(JR_QTY_LOT_COUNT_ONLYHOLD + PRE_ST_JR_R_ONLYHOLD) AS JR_QTY_LOT_COUNT_ONLYHOLD												' + char(10)

		SELECT @v_dSql +=	N'										FROM #STOCK_T A     																				' + char(10)
		SELECT @v_dSql +=	N'										GROUP BY  FACTORY_ID, ITEM_ID																	' + char(10)
		SELECT @v_dSql +=	N'				) K                                                                                                         			' + char(10)
		SELECT @v_dSql +=	N'				ON 1=1                                                                                                          		' + char(10)
		SELECT @v_dSql +=	N'				AND A.FACTORY_ID = K.FACTORY_ID                                                                                     	' + char(10)
		SELECT @v_dSql +=	N'				AND A.ITEM_ID = K.ITEM_ID				' + char(10)
		--SELECT @v_dSql +=	@sub_total
		SELECT @v_dSql +=	N'	      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ELECTRODE_TYPE, A.LEVEL_3_NAME , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.CATEGORY_GROUP, P.JR_COL, P.A_TYPE_COL, P.B_TYPE_COL                ' + char(10)
		SELECT @v_dSql +=	N'	UNION ALL                                                              ' + char(10)
		SELECT @v_dSql +=	N'	      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                             ' + char(10)
		SELECT @v_dSql +=	N'	           , A.ITEM_ID AS ITEM_ID, NULL AS NICK_NAME, NULL AS FLOW_ID, NULL AS NP_ITEM_ID, A.ELECTRODE_TYPE AS ELECTRODE_TYPE, NULL AS PRODUCTION_TYPE, A.ATTR_TYPE AS ATTR_TYPE			' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS  LEVEL_3_NAME                                                                 ' + char(10)
		SELECT @v_dSql +=	N'	           , CATEGORY_ID AS CATEGORY_ID, CATEGORY_NAME AS CATEGORY_NAME, CATEGORY_ORDER AS CATEGORY_ORDER, CATEGORY_GROUP AS CATEGORY_GROUP ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS JR_BOH                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS RP_BOH                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS A_TYPE_BOH                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS B_TYPE_BOH                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS ASSY_BOH                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS JR_BOH_QTY                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS RP_BOH_QTY                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS A_TYPE_BOH_QTY                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS B_TYPE_BOH_QTY                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS ASSY_BOH_QTY                                                          ' + char(10)

		SELECT @v_dSql +=	N'	           , NULL AS JR_BOH_ONLYHOLD                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS RP_BOH_ONLYHOLD                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS A_TYPE_BOH_ONLYHOLD                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS B_TYPE_BOH_ONLYHOLD                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS ASSY_BOH_ONLYHOLD                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS JR_BOH_QTY_ONLYHOLD                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS RP_BOH_QTY_ONLYHOLD                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS A_TYPE_BOH_QTY_ONLYHOLD                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS B_TYPE_BOH_QTY_ONLYHOLD                                                          ' + char(10)
		SELECT @v_dSql +=	N'	           , NULL AS ASSY_BOH_QTY_ONLYHOLD                                                          ' + char(10)

		--SELECT @v_dSql +=	N'	           , NULL AS JR_BOH_HOLD                                                          ' + char(10)
		--SELECT @v_dSql +=	N'	           , NULL AS RP_BOH_HOLD                                                          ' + char(10)
		--SELECT @v_dSql +=	N'	           , NULL AS A_TYPE_BOH_HOLD                                                          ' + char(10)
		--SELECT @v_dSql +=	N'	           , NULL AS B_TYPE_BOH_HOLD                                                          ' + char(10)
		--SELECT @v_dSql +=	N'	           , NULL AS ASSY_BOH_HOLD                                                          ' + char(10)
		--SELECT @v_dSql +=	N'	           , NULL AS JR_BOH_QTY_HOLD                                                          ' + char(10)
		--SELECT @v_dSql +=	N'	           , NULL AS RP_BOH_QTY_HOLD                                                          ' + char(10)
		--SELECT @v_dSql +=	N'	           , NULL AS A_TYPE_BOH_QTY_HOLD                                                          ' + char(10)
		--SELECT @v_dSql +=	N'	           , NULL AS B_TYPE_BOH_QTY_HOLD                                                          ' + char(10)
		--SELECT @v_dSql +=	N'	           , NULL AS ASSY_BOH_QTY_HOLD                                                          ' + char(10)
		SELECT @v_dSql +=	N'			   , NULL AS JR_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'			   , NULL AS A_TYPE_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'			   , NULL AS B_TYPE_WH_CAPA                                ' + char(10)
		SELECT @v_dSql +=	N'	           , ''X'' AS PSI                                    ' + char(10)
		SELECT @v_dSql +=	N'	           , ''TOTAL_X'' AS DATA_TYPE                                                         ' + char(10)

		IF ISNULL(@p_bucket,'') <> '' BEGIN

			IF @max_loop_cnt > 0 BEGIN
				-- monthinfo
				SET @mst_loop_cnt = 0
				WHILE @mst_loop_cnt < @max_month_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END-- end of @mst_loop_cnt < @max_loop_cnt

				-- weekinfo
				SET @mst_loop_cnt = 0	
				WHILE @mst_loop_cnt < @max_week_loop_cnt
				BEGIN
					SELECT @v_dSql += N'	    	  , NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
  				END -- end of @mst_loop_cnt < @max_loop_cnt

				-- bucket
				SET @mst_loop_cnt = 0	
				SET @p_temp = ''
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN

					--IF @mst_loop_cnt = 0 BEGIN
					--	SET @p_temp += ' D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ' / ISNULL(C.ROLL_QTY,1)'
					--END ELSE BEGIN
					--	SET @p_temp += ' + D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' / ISNULL(C.ROLL_QTY,1)'
					--END

					--SELECT @v_dSql += N'	    	  , SUM('+ @p_temp + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)

					--SET @mst_loop_cnt =  @mst_loop_cnt + 1
					-- SUB Total 은 Hold 기준으로
					--IF @p_cal_type = 'HOLD' BEGIN
						SELECT @v_dSql += N'	    	  , SUM( CASE WHEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' < 0 THEN 0 ELSE (CASE WHEN '''+ @p_uom_type +''' = ''PC'' AND CATEGORY_ID = ''EOH_JR_QTY_HOLD'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' / ISNULL(A.LANE_QTY,1) / ISNULL(A.JUMBO_ROLL_LENGTH,1))		' + char(10)
						SELECT @v_dSql += N'	    	  																					   WHEN '''+ @p_uom_type +''' = ''JR'' AND CATEGORY_ID = ''EOH_JR_QTY_HOLD'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' / ISNULL(A.JUMBO_ROLL_LENGTH,1))							' + char(10)
						SELECT @v_dSql += N'	    	  																					   WHEN '''+ @p_uom_type +''' = ''PC'' AND CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' / ISNULL(A.PC_ROLL_LENGTH,1))							' + char(10)
						SELECT @v_dSql += N'	    	  																					   WHEN '''+ @p_uom_type +''' = ''JR'' AND CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' * ISNULL(A.LANE_QTY,1) / ISNULL(A.PC_ROLL_LENGTH,1))			' + char(10)
						SELECT @v_dSql += N'	    	  																					   ELSE D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' END ) END ) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + char(10)
					--END ELSE BEGIN
					--	--SELECT @v_dSql += N'	    	  , SUM( CASE WHEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' < 0 THEN 0 ELSE CEILING(D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' / ISNULL(C.ROLL_QTY,A.ROLL_QTY)) END ) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					--	SELECT @v_dSql += N'	    	  , SUM( CASE WHEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' < 0 THEN 0 ELSE (CASE WHEN '''+ @p_uom_type +''' = ''PC'' AND CATEGORY_ID = ''EOH_JR_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' / ISNULL(A.LANE_QTY,1) / ISNULL(A.JUMBO_ROLL_LENGTH,1))		' + char(10)
					--	SELECT @v_dSql += N'	    	  																					   WHEN '''+ @p_uom_type +''' = ''JR'' AND CATEGORY_ID = ''EOH_JR_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' / ISNULL(A.JUMBO_ROLL_LENGTH,1))							' + char(10)
					--	--SELECT @v_dSql += N'	    	  																					   WHEN '''+ @p_uom_type +''' = ''PC'' AND CATEGORY_ID = ''EOH_PC_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' / ISNULL(A.PC_ROLL_LENGTH,1))							' + char(10)
					--	--SELECT @v_dSql += N'	    	  																					   WHEN '''+ @p_uom_type +''' = ''JR'' AND CATEGORY_ID = ''EOH_PC_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' * ISNULL(A.LANE_QTY,1) / ISNULL(A.PC_ROLL_LENGTH,1))			' + char(10)
					--	SELECT @v_dSql += N'	    	  																					   WHEN '''+ @p_uom_type +''' = ''PC'' AND CATEGORY_ID = ''EOH_ELEC_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' / ISNULL(A.PC_ROLL_LENGTH,1))							' + char(10)
					--	SELECT @v_dSql += N'	    	  																					   WHEN '''+ @p_uom_type +''' = ''JR'' AND CATEGORY_ID = ''EOH_ELEC_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' * ISNULL(A.LANE_QTY,1) / ISNULL(A.PC_ROLL_LENGTH,1))			' + char(10)
					--	SELECT @v_dSql += N'	    	  																					   ELSE D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + ' END ) END ) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + char(10)
					--END
					SET @mst_loop_cnt =  @mst_loop_cnt + 1

				END		-- end of @mst_loop_cnt < @max_loop_cnt


			END --end of @max_loop_cnt
		END -- end of isnull(@p_bucket,'') <> ''
		
		SELECT @v_dSql +=	N'						, NULL AS JR_TEMP_CAPA                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'						, NULL AS A_TYPE_TEMP_CAPA                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'						, NULL AS B_TYPE_TEMP_CAPA                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'	      FROM                                                                         ' + char(10)
		SELECT @v_dSql +=	N'	      		(																	' + char(10)
		SELECT @v_dSql +=	N'	      			SELECT	A.* , C.LANE_QTY, C.JUMBO_ROLL_LENGTH, C.PC_ROLL_LENGTH						' + char(10)
		--SELECT @v_dSql +=	N'	      					, CASE WHEN '''+ @p_uom_type +''' = ''JR'' THEN D.JR_COL				' + char(10)
		--SELECT @v_dSql +=	N'	      						WHEN A.ATTR_TYPE = ''A'' THEN D.A_TYPE_COL			' + char(10)
		--SELECT @v_dSql +=	N'	      						WHEN A.ATTR_TYPE = ''B'' THEN D.B_TYPE_COL			' + char(10)
		--SELECT @v_dSql +=	N'	      						ELSE 1 END AS ROLL_QTY								' + char(10)
		SELECT @v_dSql +=	N'	      			FROM	MAIN_I A  												' + char(10)
		--SELECT @v_dSql +=	N'	      					LEFT OUTER HASH JOIN DEFAULT_ROLL D						' + char(10)
		--SELECT @v_dSql +=	N'	      					ON 1=1                                                  ' + char(10)        
		--SELECT @v_dSql +=	N'	      					AND  D.FACTORY_ID 	= A.FACTORY_ID                      ' + char(10)        
		--SELECT @v_dSql +=	N'	      					AND  D.ELECTRODE_TYPE 	= A.ELECTRODE_TYPE 				' + char(10)
		SELECT @v_dSql +=	N'							LEFT OUTER HASH JOIN #LANE_T C                                                 ' + char(10)
		SELECT @v_dSql +=	N'							ON 1=1                                                          ' + char(10)
		SELECT @v_dSql +=	N'							AND  C.COMPANY_ID 	= A.COMPANY_ID                              ' + char(10)
		SELECT @v_dSql +=	N'							AND  C.DIVISION_ID 	= A.DIVISION_ID                             ' + char(10)
		SELECT @v_dSql +=	N'							AND  C.SITE_ID 		= A.SITE_ID                                 ' + char(10)
		SELECT @v_dSql +=	N'							AND  C.PLANT_ID 	= A.PLANT_ID                                ' + char(10)
		SELECT @v_dSql +=	N'							AND  C.FACTORY_ID 	= A.FACTORY_ID                              ' + char(10)
		SELECT @v_dSql +=	N'							AND  C.ITEM_ID 		= A.ITEM_ID		' + char(10)
		--SELECT @v_dSql +=	N'							LEFT OUTER HASH JOIN MAIN_ROLL S WITH(NOLOCK)		' + char(10)	
		--SELECT @v_dSql +=	N'							ON  A.COMPANY_ID		= S.COMPANY_ID              ' + char(10)
		--SELECT @v_dSql +=	N'							AND A.DIVISION_ID		= S.DIVISION_ID             ' + char(10)
		--SELECT @v_dSql +=	N'							AND A.SITE_ID			= S.SITE_ID                 ' + char(10)
		--SELECT @v_dSql +=	N'							AND A.PLANT_ID			= S.PLANT_ID                 ' + char(10)
		--SELECT @v_dSql +=	N'							AND A.FACTORY_ID		= S.FACTORY_ID 				' + char(10)
		--SELECT @v_dSql +=	N'							AND A.ELECTRODE_TYPE	= S.ELECTRODE_TYPE 			' + char(10)
		--SELECT @v_dSql +=	N'							AND A.ATTR_TYPE			= S.ATTR_TYPE 				' + char(10)
		--SELECT @v_dSql +=	N'							AND A.ITEM_ID			= S.ITEM_ID 				' + char(10)
		SELECT @v_dSql +=	N'	      			WHERE	1=1														' + char(10)
		SELECT @v_dSql +=	N'					AND	A.PRODUCTION_TYPE IS NULL             ' + char(10)
		SELECT @v_dSql +=	N'	      		) A																	' + char(10)
		
		--SELECT @v_dSql +=	N'				INNER JOIN WH_CAPA_TOTAL B								' + char(10)                                                                                                                                                                                  
		--SELECT @v_dSql +=	N'					ON 1=1												' + char(10)
		--SELECT @v_dSql +=	N'					AND A.FACTORY_ID = B.FACTORY_ID						' + char(10)
		
		
		--SELECT @v_dSql +=	@sub_total
		SELECT @v_dSql +=	N'	      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.ELECTRODE_TYPE , A.ATTR_TYPE                             ' + char(10)
		SELECT @v_dSql +=	N'					, CATEGORY_ID, CATEGORY_NAME, CATEGORY_ORDER, CATEGORY_GROUP ' + char(10)
		SELECT @v_dSql +=	N'		) A ' + char(10)
		SELECT @v_dSql +=	N'		 ' + char(10)
		--SELECT @v_dSql +=	N'				LEFT OUTER HASH JOIN (                                                                                  ' + char(10)
		--SELECT @v_dSql +=	N'									SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, (CASE WHEN '''+ @p_uom_type +''' = ''JR'' THEN A.JUMBO_ROLL_LENGTH ELSE A.PC_ROLL_LENGTH END)  AS ROLL_QTY   ' + char(10)                                                                              
		--SELECT @v_dSql +=	N'											, A.JUMBO_ROLL_LENGTH	, A.PC_ROLL_LENGTH,  A.LANE_QTY		' + char(10)
		--SELECT @v_dSql +=	N'									FROM LANE_T A  WITH(NOLOCK)                                                                   																							' + char(10)
		--SELECT @v_dSql +=	N'									WHERE	1=1	' + char(10)
		--SELECT @v_dSql +=	N'							) C                                                 ' + char(10)
		--SELECT @v_dSql +=	N'				ON 1=1                                                          ' + char(10)
		--SELECT @v_dSql +=	N'				AND  C.COMPANY_ID 	= A.COMPANY_ID                              ' + char(10)
		--SELECT @v_dSql +=	N'				AND  C.DIVISION_ID 	= A.DIVISION_ID                             ' + char(10)
		--SELECT @v_dSql +=	N'				AND  C.SITE_ID 		= A.SITE_ID                                 ' + char(10)
		--SELECT @v_dSql +=	N'				AND  C.PLANT_ID 	= A.PLANT_ID                                ' + char(10)
		--SELECT @v_dSql +=	N'				AND  C.FACTORY_ID 	= A.FACTORY_ID                              ' + char(10)
		--SELECT @v_dSql +=	N'				AND  C.ITEM_ID 		= A.ITEM_ID		' + char(10)
		--SELECT @v_dSql +=	N'		  			LEFT OUTER HASH JOIN DEFAULT_ROLL D						 ' + char(10)
		--SELECT @v_dSql +=	N'		  					ON 1=1                                           ' + char(10)                
		--SELECT @v_dSql +=	N'		  					AND  D.FACTORY_ID 	= A.FACTORY_ID               ' + char(10)                
		--SELECT @v_dSql +=	N'		  					AND  D.ELECTRODE_TYPE 	= A.ELECTRODE_TYPE		 ' + char(10) 
		--SELECT @v_dSql +=	N'					LEFT OUTER HASH JOIN MAIN_ROLL S WITH(NOLOCK)		' + char(10)	
		--SELECT @v_dSql +=	N'					ON  A.COMPANY_ID		= S.COMPANY_ID              ' + char(10)
		--SELECT @v_dSql +=	N'					AND A.DIVISION_ID		= S.DIVISION_ID             ' + char(10)
		--SELECT @v_dSql +=	N'					AND A.SITE_ID			= S.SITE_ID                 ' + char(10)
		--SELECT @v_dSql +=	N'					AND A.PLANT_ID			= S.PLANT_ID                 ' + char(10)
		--SELECT @v_dSql +=	N'					AND A.FACTORY_ID		= S.FACTORY_ID 				' + char(10)
		--SELECT @v_dSql +=	N'					AND A.ELECTRODE_TYPE	= S.ELECTRODE_TYPE 			' + char(10)
		--SELECT @v_dSql +=	N'					AND A.ATTR_TYPE			= S.ATTR_TYPE 				' + char(10)
		--SELECT @v_dSql +=	N'					AND A.ITEM_ID			= S.ITEM_ID 				' + char(10)
		SELECT @v_dSql +=	N'					LEFT OUTER HASH JOIN #LANE_T S WITH(NOLOCK)		' + char(10)	
		SELECT @v_dSql +=	N'					ON  A.COMPANY_ID		= S.COMPANY_ID              ' + char(10)
		SELECT @v_dSql +=	N'					AND A.DIVISION_ID		= S.DIVISION_ID             ' + char(10)
		SELECT @v_dSql +=	N'					AND A.SITE_ID			= S.SITE_ID                 ' + char(10)
		SELECT @v_dSql +=	N'					AND A.PLANT_ID			= S.PLANT_ID                 ' + char(10)
		SELECT @v_dSql +=	N'					AND A.FACTORY_ID		= S.FACTORY_ID 				' + char(10)
		SELECT @v_dSql +=	N'					AND A.ELECTRODE_TYPE	= S.ELECTRODE_TYPE 			' + char(10)
		SELECT @v_dSql +=	N'					AND A.ATTR_TYPE			= S.ATTR_TYPE 				' + char(10)
		SELECT @v_dSql +=	N'					AND A.ITEM_ID			= S.ITEM_ID 				' + char(10)
		SELECT @v_dSql +=	N'		  			LEFT OUTER JOIN (                      ' + char(10)
		SELECT @v_dSql +=	N'							SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID							                        ' + char(10)
		SELECT @v_dSql +=	N'							FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'							WHERE	1=1                    ' + char(10)
		SELECT @v_dSql +=	N'							AND		R.USER_ID	= '''+ @p_user_id +'''                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'							AND		R.SAVE_FLAG	= ''Y''                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'							AND		R.INSTANCE_ID = '''+ @p_master_id +'''                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'					) R                                    ' + char(10)
		SELECT @v_dSql +=	N'					ON		1=1                            ' + char(10)
		SELECT @v_dSql +=	N'					AND		A.COMPANY_ID		= R.COMPANY_ID                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'					AND		A.DIVISION_ID		= R.DIVISION_ID                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'					AND		A.SITE_ID			= R.SITE_ID                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'					AND		A.PLANT_ID			= R.PLANT_ID                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'					AND		A.FACTORY_ID		= R.FACTORY_ID                                                                                                  ' + char(10)
		
		SELECT @v_dSql +=	N'				) A                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'				LEFT OUTER JOIN (																			 ' + char(10)
		SELECT @v_dSql +=	N'						SELECT DISTINCT A.FACTORY_ID, A.ITEM_ID, CASE WHEN A.ELECTRODE_TYPE = ''A'' THEN  ''ANODE'' ELSE ''CATHODE'' END AS ELECTRODE_TYPE, A.ATTR_TYPE, A.ATTB_4 AS MOVING_FACTORY	   ' + char(10)
		SELECT @v_dSql +=	N'						FROM FP_ELECTRODE_POST_PLAN_H A WITH(NOLOCK)																															   ' + char(10)
		SELECT @v_dSql +=	N'						WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'						AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'						AND    A.CATEGORY  = ''12-Moving Plan''                                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'						AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'				) B																																												   ' + char(10)
		SELECT @v_dSql +=	N'				ON 1=1																																											   ' + char(10)
		SELECT @v_dSql +=	N'				AND		A.FACTORY_ID		= B.FACTORY_ID                                                                                                  									   ' + char(10)
		SELECT @v_dSql +=	N'				AND		A.ITEM_ID			= B.ITEM_ID                                                                                                 										   ' + char(10)
		SELECT @v_dSql +=	N'				AND		A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE                                                                                                     								   ' + char(10)
		SELECT @v_dSql +=	N'				--AND		A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE                                                                                                    							   ' + char(10)
		SELECT @v_dSql +=	N'				AND		A.ATTR_TYPE			= B.ATTR_TYPE     																																	   ' + char(10)
		
		SELECT @v_dSql +=	N'		  WHERE 1=1                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'		  ORDER BY FACTORY_ID, NICK_NAME, ITEM_ID, ELECTRODE_TYPE, PRODUCTION_TYPE, DATA_TYPE, CATEGORY_ORDER, CATEGORY_GROUP	 ' + char(10)
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

