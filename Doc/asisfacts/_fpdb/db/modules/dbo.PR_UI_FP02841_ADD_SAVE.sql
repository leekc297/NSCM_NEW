

/*
 * Program ID   : PR_UI_FP02841_ADD_SAVE
 * Description  : DOMESTIC MODEL MASTER
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/02/05   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02841_ADD_SAVE]
	@p_sys_type			NVARCHAR(MAX),  
	@p_sys_flag			NVARCHAR(MAX),
	@p_sys_gubun		NVARCHAR(MAX),  
	@p_user_id			NVARCHAR(MAX),
	@in_columns			NVARCHAR(MAX),
	@in_row				NVARCHAR(MAX),
	@opt_none			NVARCHAR(5) = 'N'
WITH EXEC AS CALLER
AS
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- commit 된 데이타만 사용
    SET NOCOUNT ON    -- 처리 결과 건수                                                                                                                                                                                                                                               
	SET XACT_ABORT ON -- trasaction 처리

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02841_ADD_SAVE';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	DECLARE @v_log_message	NVARCHAR(MAX) = '';
	DECLARE @max_loop_cnt	INTEGER = 0; 
	DECLARE @mst_loop_cnt	        INTEGER = 0;
	DECLARE @recv_active_flag       NVARCHAR(MAX);		
	DECLARE @p_new_seq		NVARCHAR(MAX);

	DECLARE @p_instance_id			NVARCHAR(MAX);
	DECLARE @p_master_id			NVARCHAR(MAX);
	DECLARE @p_fp_plan_id			NVARCHAR(MAX);
	DECLARE @p_plan_id				NVARCHAR(MAX);
	DECLARE @p_company_id           NVARCHAR(MAX);
	DECLARE @p_division_id          NVARCHAR(MAX);
	DECLARE @p_site_id              NVARCHAR(MAX);
	DECLARE @p_plant_id             NVARCHAR(MAX);
	DECLARE @p_factory_id           NVARCHAR(MAX);
	
	DECLARE @p_item_id				NVARCHAR(MAX);  
	DECLARE @p_production_type		NVARCHAR(MAX);
	DECLARE @p_electrode_type		NVARCHAR(MAX);
	DECLARE @p_category_id			NVARCHAR(MAX);
	DECLARE @p_wh_type				NVARCHAR(MAX);
	DECLARE @p_plan_date			NVARCHAR(MAX);
	DECLARE @p_out_qty				NVARCHAR(MAX);

	DECLARE @p_unit					INTEGER = 0;
	DECLARE @p_round_point			INTEGER = 0;
	DECLARE @result_val				NUMERIC(20,10);

	DECLARE @p_active_flag          NVARCHAR(MAX);
	DECLARE @p_delimiter            NVARCHAR(1);

	DECLARE @tmp_column		NVARCHAR(MAX);
	DECLARE @tmp_value		NVARCHAR(MAX);
	DECLARE @dbg_txt		NVARCHAR(MAX);

	SET @recv_active_flag       = @p_sys_flag;
	SET @p_delimiter            = '^';  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @p_delimiter); -- 프로시저 LOOP 길이를 판단 

	SET @p_delimiter            = '^'  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @p_delimiter) -- 프로시저 LOOP 길이를 판단
	
	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
		
		SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

		SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @in_columns , @p_delimiter , @mst_loop_cnt);
		SET @tmp_value	= [dbo].[SCM_ARR_SPL_VAL]( @in_row , @p_delimiter , @mst_loop_cnt);

		IF @tmp_column = 'NEW_SEQ' BEGIN
			SET @p_new_seq		=	@tmp_value ;
		END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
			SET @p_company_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
			SET @p_instance_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
			SET @p_master_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'FP_PLAN_ID' BEGIN
			SET @p_fp_plan_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
			SET @p_plan_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
			SET @p_plan_date =			@tmp_value ;
		END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
			SET @p_company_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
			SET @p_division_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'SITE_ID' BEGIN
			SET @p_site_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
			SET @p_plant_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
			SET @p_factory_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
			SET @p_item_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PRODUCTION_TYPE' BEGIN
			SET @p_production_type =	@tmp_value ;
		END ELSE IF @tmp_column = 'OUT_QTY' BEGIN
			SET @p_out_qty		   =	@tmp_value ;
		END ELSE IF @tmp_column = 'ELECTRODE_TYPE' BEGIN
			SET @p_electrode_type  =	@tmp_value ;
		END ELSE IF @tmp_column = 'WH_TYPE' BEGIN
			SET @p_wh_type	   =	@tmp_value ;
		END ELSE IF @tmp_column = 'CATEGORY_ID' BEGIN
			SET @p_category_id	=	@tmp_value ;
		END ELSE IF @tmp_column = 'UNIT' BEGIN
			SET @p_unit			=	@tmp_value ;
		END ELSE IF @tmp_column = 'ROUND_POINT' BEGIN
			SET @p_round_point	=	@tmp_value ;

		END

	END
	/*	Parameter Setting End */

	IF OBJECT_ID('TEMPDB..#TMP_FP02841_SAVE_DATA') IS NOT NULL
		DROP TABLE #TMP_FP02841_SAVE_DATA;

	CREATE TABLE #TMP_FP02841_SAVE_DATA
	(
		  INSTANCE_ID		NVARCHAR(30)
		, FP_PLAN_ID		NVARCHAR(30)
		, COMPANY_ID		NVARCHAR(30)
		, DIVISION_ID		NVARCHAR(30)
		, SITE_ID			NVARCHAR(30)
		, PLANT_ID			NVARCHAR(30)
		, FACTORY_ID		NVARCHAR(30)
		, ELECTRODE_TYPE	NVARCHAR(30)
		, PRODUCTION_TYPE	NVARCHAR(30)
		, ITEM_ID			NVARCHAR(150)
		, NP_ITEM_ID		NVARCHAR(150)
		, ATTR_TYPE			NVARCHAR(30)
		, CATEGORY_ID		NVARCHAR(30)
		, PLAN_DATE			DATETIME
		, IN_QTY			NUMERIC(20,10)
		, OUT_QTY			NUMERIC(20,10)
		, IN_JR_QTY			NUMERIC(20,10)
		, OUT_JR_QTY		NUMERIC(20,10)
		, IN_PC_QTY			NUMERIC(20,10)
		, OUT_PC_QTY		NUMERIC(20,10)
		, USER_ID			NVARCHAR(150)
	)

	--SET @result_val =  (@p_out_qty * @p_unit);

	BEGIN TRY
		BEGIN TRAN		
			
			BEGIN
				INSERT INTO #TMP_FP02841_SAVE_DATA
				(
					  INSTANCE_ID
					, FP_PLAN_ID
					, COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, ELECTRODE_TYPE
					, PRODUCTION_TYPE
					, ITEM_ID
					, NP_ITEM_ID
					, ATTR_TYPE
					, CATEGORY_ID
					, PLAN_DATE
					, IN_JR_QTY
					, OUT_JR_QTY
					, USER_ID
				)
				SELECT	@p_INSTANCE_ID
					  , @p_FP_PLAN_ID
					  , @p_COMPANY_ID
					  , @p_DIVISION_ID
					  , @p_SITE_ID
					  , @p_PLANT_ID
					  , @p_FACTORY_ID
					  , CASE WHEN @p_ELECTRODE_TYPE = 'Anode' THEN 'A'
							 WHEN @p_ELECTRODE_TYPE = 'Cathode' THEN 'C'
							 ELSE @p_ELECTRODE_TYPE END AS ELECTRODE_TYPE
					  ,@p_production_type AS PRODUCTION_TYPE -- @p_PRODUCTION_TYPE
					  , @p_ITEM_ID
					  , NULL AS NP_ITEM_ID
					  , @p_wh_type
					  , CASE WHEN @p_category_id = 'SLITTING_PLAN' THEN '21-Slitting Plan'
							 WHEN @p_category_id = 'ROLL_PRESS_PLAN' THEN '31-Roll Press Plan'
							 ELSE @p_category_id END AS CATEGORY_ID
					  , @p_PLAN_DATE
					  , (@p_out_qty * @p_unit)
					  , (@p_out_qty * @p_unit)
					  , @p_user_id
				 ;
			END

			
			BEGIN 
				
				-- Pancke 수량으로 환산
				UPDATE A
				SET		IN_PC_QTY = IN_JR_QTY * ISNULL(B.LANE_QTY,1)
					  , OUT_PC_QTY = OUT_JR_QTY * ISNULL(B.LANE_QTY,1)
				FROM	#TMP_FP02841_SAVE_DATA A
						LEFT OUTER JOIN (                                                                                  
											SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, MAX( A.LANE_QTY ) AS LANE_QTY                                                                                 
											FROM SCM_ITEM_LANE_M A WITH(NOLOCK)                                                                  
											GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                          
										) B                                                                                        
						ON 1=1                                                                                           
						AND  B.COMPANY_ID 	= A.COMPANY_ID                                                               
						AND  B.DIVISION_ID 	= A.DIVISION_ID                                                              
						AND  B.SITE_ID 		= A.SITE_ID                                                                    
						AND  B.PLANT_ID 	= A.PLANT_ID                                                                   
						AND  B.FACTORY_ID 	= A.FACTORY_ID                                                               
						AND  B.ITEM_ID 		= A.ITEM_ID   
				;

				BEGIN

					MERGE INTO FP_ELECTRODE_POST_PLAN_H M
					USING (
								SELECT	  INSTANCE_ID
										, FP_PLAN_ID
										, COMPANY_ID
										, DIVISION_ID
										, SITE_ID
										, PLANT_ID
										, FACTORY_ID
										, ELECTRODE_TYPE
										, PRODUCTION_TYPE
										, ITEM_ID
										, NP_ITEM_ID
										, ATTR_TYPE
										, CATEGORY_ID
										, PLAN_DATE
										, IN_QTY
										, OUT_QTY
										, IN_JR_QTY
										, OUT_JR_QTY
										, IN_PC_QTY
										, OUT_PC_QTY
										, USER_ID
								 FROM	#TMP_FP02841_SAVE_DATA
								 WHERE	1=1
								 --AND	SEQ = @p_new_seq
							) B
							 ON 1=1
							AND M.FP_PLAN_ID		= B.FP_PLAN_ID
							AND M.COMPANY_ID		= B.COMPANY_ID
							AND M.DIVISION_ID		= B.DIVISION_ID
							AND M.SITE_ID			= B.SITE_ID
							AND M.PLANT_ID			= B.PLANT_ID
							AND M.FACTORY_ID		= B.FACTORY_ID
							AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
							AND M.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
							AND M.ITEM_ID			= B.ITEM_ID
							AND M.CATEGORY			= B.CATEGORY_ID
							AND CONVERT(VARCHAR,M.PLAN_DATE,112)	= CONVERT(VARCHAR,B.PLAN_DATE,112)

					WHEN NOT MATCHED THEN
						INSERT (
									  INSTANCE_ID
									, FP_PLAN_ID
									, COMPANY_ID
									, DIVISION_ID
									, SITE_ID
									, PLANT_ID
									, FACTORY_ID
									, ELECTRODE_TYPE
									, PRODUCTION_TYPE
									, ITEM_ID
									, NP_ITEM_ID
									, ATTR_TYPE
									, CATEGORY
									, PLAN_DATE
									, IN_QTY
									, OUT_QTY
									, IN_JR_QTY
									, OUT_JR_QTY
									, IN_PC_QTY
									, OUT_PC_QTY
									, INSERT_ID		, INSERT_TIME		, UPDATE_ID , UPDATE_TIME
								)
						VALUES  (
									  B.INSTANCE_ID
									, B.FP_PLAN_ID
									, B.COMPANY_ID
									, B.DIVISION_ID
									, B.SITE_ID
									, B.PLANT_ID
									, B.FACTORY_ID
									, B.ELECTRODE_TYPE
									, B.PRODUCTION_TYPE
									, B.ITEM_ID
									, B.NP_ITEM_ID
									, B.ATTR_TYPE
									, B.CATEGORY_ID
									, CONVERT(VARCHAR,B.PLAN_DATE,112)
									, B.IN_QTY
									, B.OUT_QTY
									, B.IN_JR_QTY
									, B.OUT_JR_QTY
									, B.IN_PC_QTY
									, B.OUT_PC_QTY
					 			    , B.USER_ID	, GETDATE()		, B.USER_ID	, GETDATE()
								);

						INSERT INTO HIS_ELECTRODE_POST_PLAN_H (
									  INSTANCE_ID
									, FP_PLAN_ID
									, COMPANY_ID
									, DIVISION_ID
									, SITE_ID
									, PLANT_ID
									, FACTORY_ID
									, ELECTRODE_TYPE
									, PRODUCTION_TYPE
									, ITEM_ID
									, NP_ITEM_ID
									, ATTR_TYPE
									, CATEGORY
									, PLAN_DATE
									, IN_QTY
									, OUT_QTY
									, IN_JR_QTY
									, OUT_JR_QTY
									, IN_PC_QTY
									, OUT_PC_QTY
									, INSERT_ID, INSERT_TIME
									, UPDATE_ID, UPDATE_TIME
									, JOB_USER_ID, JOB_TIME, JOB_TYPE
				            )
				            SELECT	  M.INSTANCE_ID
									, M.FP_PLAN_ID
									, M.COMPANY_ID
									, M.DIVISION_ID
									, M.SITE_ID
									, M.PLANT_ID
									, M.FACTORY_ID
									, M.ELECTRODE_TYPE
									, M.PRODUCTION_TYPE
									, M.ITEM_ID
									, M.NP_ITEM_ID
									, M.ATTR_TYPE
									, M.CATEGORY
									, M.PLAN_DATE
									, M.IN_QTY
									, M.OUT_QTY
									, M.IN_JR_QTY
									, M.OUT_JR_QTY
									, M.IN_PC_QTY
									, M.OUT_PC_QTY
									, M.INSERT_ID, M.INSERT_TIME
									, M.UPDATE_ID, M.UPDATE_TIME
									, @p_user_id AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'ADD' AS JOB_TYPE
				            FROM	FP_ELECTRODE_POST_PLAN_H M WITH(NOLOCK) ,
									#TMP_FP02841_SAVE_DATA B
							WHERE	1=1
							AND	M.COMPANY_ID		= B.COMPANY_ID
							AND M.DIVISION_ID		= B.DIVISION_ID
							AND M.SITE_ID			= B.SITE_ID
							AND M.PLANT_ID			= B.PLANT_ID
							AND M.FACTORY_ID		= B.FACTORY_ID
							AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
							AND M.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
							AND M.ITEM_ID			= B.ITEM_ID
							AND M.CATEGORY			= B.CATEGORY_ID
							AND M.PLAN_DATE			= B.PLAN_DATE
							--AND CONVERT(VARCHAR,M.PLAN_DATE,112)	= B.PLAN_DATE
				            ;
				END

				IF @p_sys_type = 'SQL'
				BEGIN
					select @v_dSql as [QUERY_VALUE]
				END ELSE BEGIN
					SET @runstart = GetDate()
					--BEGIN TRY
					--		BEGIN TRAN
					--			exec sp_executesql @v_dSql
					--		COMMIT TRAN
					--END TRY
					--BEGIN CATCH
					--		ROLLBACK
					--END CATCH
					SET @runend = GetDate()
					exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@p_new_seq,'SAVE',@runstart, @runend
				END

		END
 		
		-- 트랜잭션 (COMMIT)
		COMMIT TRAN
		
		-- 수행결과 성공여부 RETURN
		IF @p_sys_type <> 'SQL'
			SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	

	END TRY

	BEGIN CATCH                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                     
		ROLLBACK TRAN                                                                                                                                                                                                                                                 
		-- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
		SET @v_log_message = ERROR_MESSAGE()
		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_log_message,'excute',@runstart, @runend
        
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		
	END CATCH   
END

