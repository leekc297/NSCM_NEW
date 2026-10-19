/*
 * Program ID   : [SCP0084_SAVE_REASON_FOR_LONG_TERM_INVENTORY]
 * Description  : Save the reason for long term inventory
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/7/22   Haru			Adding new function for saving the reason for long term inventory 
 * 2024/8/14   tanvq1		Adding logic for Delete records Scenario
 */
CREATE PROCEDURE [dbo].[SCP0084_SAVE_REASON_FOR_LONG_TERM_INVENTORY_NEW]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_yyyymm				NVARCHAR(MAX),
	@p_plant_id				NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_item_id				NVARCHAR(MAX),
	@p_charg				NVARCHAR(MAX),
	@p_devaluation_age		NVARCHAR(MAX),
	@p_occr_rsn_cd			NVARCHAR(MAX),
	@p_occr_rsn_ctn			NVARCHAR(MAX),
	@p_exht_tp_cd			NVARCHAR(MAX),
	@p_exht_tp_ctn			NVARCHAR(MAX),
	@p_plan_yyyymm			NVARCHAR(MAX),
	@p_qty					NVARCHAR(MAX),
	@p_user_id				NVARCHAR(MAX)
AS

BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag			NVARCHAR(MAX);
	DECLARE @recv_yyyymm				NVARCHAR(MAX);
	DECLARE @recv_plant_id				NVARCHAR(MAX);
	DECLARE @recv_division_id			NVARCHAR(MAX);
	DECLARE @recv_item_id				NVARCHAR(MAX);
	DECLARE @recv_charg					NVARCHAR(MAX);
	DECLARE @recv_devaluation_age		NVARCHAR(MAX);
	DECLARE @recv_occr_rsn_cd			NVARCHAR(MAX);
	DECLARE @recv_occr_rsn_ctn			NVARCHAR(MAX);
	DECLARE @recv_exht_tp_cd			NVARCHAR(MAX);
	DECLARE @recv_exht_tp_ctn			NVARCHAR(MAX);
	DECLARE @recv_plan_yyyymm			NVARCHAR(MAX);
	DECLARE @recv_qty					NVARCHAR(MAX);
	DECLARE @recv_user_id				NVARCHAR(MAX);

	SET @recv_active_flag = NULL;
	SET @recv_yyyymm = NULL;
	SET @recv_plant_id = NULL;
	SET @recv_division_id = NULL;
	SET @recv_item_id = NULL;
	SET @recv_charg = NULL;
	SET @recv_devaluation_age = NULL;
	SET @recv_occr_rsn_cd = NULL;	 
	SET @recv_occr_rsn_ctn = NULL;	
	SET @recv_exht_tp_cd = NULL;	
	SET @recv_exht_tp_ctn = NULL;	
	SET @recv_plan_yyyymm = NULL;	
	SET @recv_qty = NULL;	
	SET @recv_user_id = NULL;
		
	SET @recv_active_flag = @p_active_flag;
	SET @recv_yyyymm = @p_yyyymm;
	SET @recv_plant_id = @p_plant_id;
	SET @recv_division_id = @p_division_id;
	SET @recv_item_id = @p_item_id;
	SET @recv_charg = @p_charg;
	SET @recv_devaluation_age = @p_devaluation_age;
	SET @recv_occr_rsn_cd = @p_occr_rsn_cd;	 
	SET @recv_occr_rsn_ctn = @p_occr_rsn_ctn;	
	SET @recv_exht_tp_cd = @p_exht_tp_cd;	
	SET @recv_exht_tp_ctn = @p_exht_tp_ctn;	
	SET @recv_plan_yyyymm = @p_plan_yyyymm;	
	SET @recv_qty = @p_qty;	
	SET @recv_user_id = @p_user_id;	
	
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_yyyymm				NVARCHAR(MAX);
	DECLARE @v_plant_id				NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_charg				NVARCHAR(MAX);
	DECLARE @v_devaluation_age		NVARCHAR(MAX);
	DECLARE @v_occr_rsn_cd			NVARCHAR(MAX);
	DECLARE @v_occr_rsn_ctn			NVARCHAR(MAX);
	DECLARE @v_exht_tp_cd			NVARCHAR(MAX);
	DECLARE @v_exht_tp_ctn			NVARCHAR(MAX);
	DECLARE @v_plan_yyyymm			NVARCHAR(MAX);
	DECLARE @v_qty					numeric(30,8);
	DECLARE @v_user_id				NVARCHAR(MAX);
	--DECLARE @v_occr_rsn_cd_item		NVARCHAR(MAX);
	--DECLARE @v_exht_tp_cd_item		NVARCHAR(MAX);
	DECLARE @v_qty_item				NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_yyyymm = NULL;
	SET @v_plant_id = NULL;
	SET @v_division_id = NULL;
	SET @v_item_id = NULL;
	SET @v_charg = NULL;
	SET @v_devaluation_age = NULL;
	SET @v_occr_rsn_cd = NULL;	 
	SET @v_occr_rsn_ctn = NULL;	
	SET @v_exht_tp_cd = NULL;	
	SET @v_exht_tp_ctn = NULL;	
	SET @v_plan_yyyymm = NULL;	
	--SET @v_qty = NULL;	 

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '|'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	--DECLARE @is_bulk_insert     INTEGER = 0; --Value: 1 = TRUE, 0 = FALSE

	CREATE TABLE #InputTable(
	  [YYYYMM]				NVARCHAR(6),
      [PLANT_ID]			NVARCHAR(12),
      [DIVISION_ID]			NVARCHAR(30),
      [ITEM_ID]				NVARCHAR(54),
      [CHARG]				NVARCHAR(30),
      [DEVALUATION_AGE]		NVARCHAR(30),
      [OCCR_RSN_CD]			NVARCHAR(20),
      [OCCR_RSN_CTN]		NVARCHAR(200),
      [EXHT_TP_CD]			NVARCHAR(20),
      [EXHT_TP_CTN]			NVARCHAR(200),
      [PLAN_YYYYMM]			NVARCHAR(6),
      [QTY]					NUMERIC(30,8),
	  [USER_ID]				NVARCHAR(150)
	);
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0084_SAVE_REASON_FOR_LONG_TERM_INVENTORY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	-- 트렌젝션 시작
	BEGIN TRAN;
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	

		BEGIN TRY

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		SELECT    @max_loop_cnt;
		--IF (@max_loop_cnt >= 1) SET @is_bulk_insert = 1;
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_active_flag

				SET @v_yyyymm = [dbo].[SCM_ARR_SPL_VAL](@p_yyyymm, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_yyyymm

				SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_plant_id
					  
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_division_id

				SET @v_item_id = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_item_id

				SET @v_charg = [dbo].[SCM_ARR_SPL_VAL](@p_charg, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_charg

				SET @v_devaluation_age = [dbo].[SCM_ARR_SPL_VAL](@p_devaluation_age, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_devaluation_age

				SET @v_occr_rsn_cd = [dbo].[SCM_ARR_SPL_VAL](@p_occr_rsn_cd, @v_delimiter , @mst_loop_cnt);
				--IF  (@v_occr_rsn_cd_item IS NULL OR  @v_occr_rsn_cd_item = '')
				--	BEGIN 
				--		SET @v_occr_rsn_cd = NULL
				--	END
				--ELSE 
				--	BEGIN
				--		SELECT @v_occr_rsn_cd = segment1
				--								from   SCM_ADM_LOOKUP_MASTER_DETAIL
				--								where  lookup_type = 'SCM_LGTM_OCCR_RSN_CD'
				--								AND    VALID_YN = 'Y' 
				--								AND attribute1 LIKE N'%'+@v_occr_rsn_cd_item+'%'  ;  
				--	END

				SET @v_occr_rsn_ctn = [dbo].[SCM_ARR_SPL_VAL](@p_occr_rsn_ctn, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_occr_rsn_ctn

				SET  @v_exht_tp_cd = [dbo].[SCM_ARR_SPL_VAL](@p_exht_tp_cd, @v_delimiter , @mst_loop_cnt);
				--IF (@v_exht_tp_cd_item IS NULL OR @v_exht_tp_cd_item = '')
				--	BEGIN 
				--		SET @v_exht_tp_cd = NULL
				--	END
				--ELSE 
				--	BEGIN
				--		SELECT @v_exht_tp_cd = segment1
				--								from   SCM_ADM_LOOKUP_MASTER_DETAIL
				--								where  lookup_type = 'SCM_LGTM_EXHT_TP_CD'
				--								AND    VALID_YN = 'Y' 
				--								AND attribute1 LIKE N'%'+@v_exht_tp_cd_item+'%' ;
				--	END

				SET @v_exht_tp_ctn = [dbo].[SCM_ARR_SPL_VAL](@p_exht_tp_ctn, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_exht_tp_ctn

				SET @v_plan_yyyymm = [dbo].[SCM_ARR_SPL_VAL](@p_plan_yyyymm, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_plan_yyyymm
				
				SET @v_qty_item	 = [dbo].[SCM_ARR_SPL_VAL](@p_qty, @v_delimiter, @mst_loop_cnt)
				IF  @v_qty_item	<> 'NULL' AND @v_qty_item	<> ''
					BEGIN
						SET @v_qty = CAST (@v_qty_item AS numeric ); 
						--SELECT @v_qty
					END
				ELSE
					BEGIN
						SET @v_qty = 0
						--SELECT @v_qty
					END

				SET @v_user_id = [dbo].[SCM_ARR_SPL_VAL](@p_user_id, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_user_id
						
			END
			
			IF @mst_loop_cnt > 0 
				BEGIN 		
					MERGE INTO [dbo].[SCP_ANL_LGTM_INV_EXHT_PLAN] A
					USING (
							SELECT 
								@v_yyyymm			as yyyymm,
								@v_plant_id			as plant_id,
								@v_division_id		as division_id, 
								@v_item_id			as item_id, 
								@v_charg			as charg,
								@v_devaluation_age	as devaluation_age,
								--@v_occr_rsn_cd		as occr_rsn_cd, 
								--@v_exht_tp_cd		as exht_tp_cd,
								@v_plan_yyyymm		as plan_yyyymm
						  ) B
					ON(
							    A.yyyymm			= B.yyyymm
							AND A.plant_id			= B.plant_id
							AND A.division_id		= B.division_id
							AND A.item_id			= B.item_id
							AND A.charg				= B.charg
							AND A.devaluation_age	= B.devaluation_age
							--AND A.occr_rsn_cd		= B.occr_rsn_cd
							--AND A.exht_tp_cd		= B.exht_tp_cd
							AND A.plan_yyyymm		= B.plan_yyyymm
					  )			
					WHEN MATCHED AND (@v_qty = 0  OR (@v_occr_rsn_cd IS NULL AND  @v_exht_tp_cd IS NULL)) THEN	
							 DELETE
					WHEN MATCHED AND @v_qty <> 0  AND (@v_occr_rsn_cd IS NOT NULL AND  @v_exht_tp_cd IS NOT NULL)THEN	
							 UPDATE SET 
										occr_rsn_ctn		= @v_occr_rsn_ctn
									   ,exht_tp_ctn			= @v_exht_tp_ctn 
									   ,qty					= @v_qty
									   ,last_updated_by		= @v_user_id
									   ,last_update_date	= sysdatetime()
									   ,occr_rsn_cd			= @v_occr_rsn_cd
									   ,exht_tp_cd			= @v_exht_tp_cd						
					WHEN NOT MATCHED AND @v_occr_rsn_cd IS NOT NULL AND  @v_exht_tp_cd IS NOT NULL AND @v_qty <> 0
					THEN  

						 INSERT (   yyyymm
								  ,plant_id
								  ,division_id
								  ,item_id
								  ,charg
								  ,devaluation_age
								  ,occr_rsn_cd
								  ,occr_rsn_ctn
								  ,exht_tp_cd
								  ,exht_tp_ctn
								  ,plan_yyyymm
								  ,qty
								  ,created_by
								  ,create_date
								  ,last_updated_by
								  ,last_update_date
								)
						 VALUES (   @v_yyyymm
								   ,@v_plant_id
								   ,@v_division_id 
								   ,@v_item_id
								   ,@v_charg
								   ,@v_devaluation_age
								   ,@v_occr_rsn_cd
								   ,@v_occr_rsn_ctn
								   ,@v_exht_tp_cd
								   ,@v_exht_tp_ctn
								   ,@v_plan_yyyymm
								   ,@v_qty
								   ,@v_user_id
								   ,sysdatetime()
								   ,@v_user_id
								   ,sysdatetime()
								);
			  END



			ELSE    --단일 ROW 일때
			 
				BEGIN        
					SET @v_active_flag = @p_active_flag        
					SET @p_active_flag = NULL 

					SET @v_yyyymm = @p_yyyymm        
					SET @p_yyyymm = NULL 

					SET @v_plant_id = @p_plant_id        
					SET @p_plant_id = NULL 

					SET @v_division_id = @p_division_id        
					SET @p_division_id = NULL     
					
					SET @v_item_id = @p_item_id        
					SET @p_item_id = NULL    

					SET @v_charg = @p_charg       
					SET @p_charg = NULL  

					SET @v_devaluation_age = @p_devaluation_age 
					SET @p_devaluation_age = NULL

					SET @v_occr_rsn_cd = @p_occr_rsn_cd
					--IF (@p_occr_rsn_cd IS NULL OR @p_occr_rsn_cd = '')
					--	BEGIN 
					--		SET @v_occr_rsn_cd = NULL
					--	END
					--ELSE
					--	BEGIN
					--		select @v_occr_rsn_cd = segment1
					--							from   SCM_ADM_LOOKUP_MASTER_DETAIL
					--							where  lookup_type = 'SCM_LGTM_OCCR_RSN_CD'
					--							AND    VALID_YN = 'Y' 
					--							AND attribute1 LIKE N'%'+@p_occr_rsn_cd+'%'  ; 
					--	END

					SET @p_occr_rsn_cd = NULL

					SET @v_occr_rsn_ctn = @p_occr_rsn_ctn 
					SET @p_occr_rsn_ctn = NULL

					SET @v_exht_tp_cd = @p_exht_tp_cd
					--IF (@p_exht_tp_cd IS NULL OR @p_exht_tp_cd = '')
					--	BEGIN 
					--		SET @v_exht_tp_cd = NULL
					--	END
					--ELSE
					--	BEGIN
					--		SELECT @v_exht_tp_cd = segment1
					--							from   SCM_ADM_LOOKUP_MASTER_DETAIL
					--							where  lookup_type = 'SCM_LGTM_EXHT_TP_CD'
					--							AND    VALID_YN = 'Y' AND attribute1 LIKE N'%'+@p_exht_tp_cd+'%'
					--	END
					SET @p_exht_tp_cd = NULL

					SET @v_exht_tp_ctn = @p_exht_tp_ctn 
					SET @p_exht_tp_ctn = NULL

					SET @v_plan_yyyymm = @p_plan_yyyymm 
					SET @p_plan_yyyymm = NULL
															
					IF @p_qty <> 'NULL' AND @p_qty<> ''
						BEGIN
							SET @v_qty = CAST (@p_qty AS numeric)
						END
					ELSE
						BEGIN
							SET @v_qty = 0
						END

					SET @v_user_id = @p_user_id 
					SET @p_user_id = NULL
					
					MERGE INTO [dbo].[SCP_ANL_LGTM_INV_EXHT_PLAN] A
					USING (
							SELECT 
								@v_yyyymm			as yyyymm,
								@v_plant_id			as plant_id,
								@v_division_id		as division_id, 
								@v_item_id			as item_id, 
								@v_charg			as charg,
								@v_devaluation_age	as devaluation_age,
								--@v_occr_rsn_cd		as occr_rsn_cd, 
								--@v_exht_tp_cd		as exht_tp_cd,
								@v_plan_yyyymm		as plan_yyyymm
						  ) B
					ON(
							    A.yyyymm			= B.yyyymm
							AND A.plant_id			= B.plant_id
							AND A.division_id		= B.division_id
							AND A.item_id			= B.item_id
							AND A.charg				= B.charg
							AND A.devaluation_age	= B.devaluation_age
							--AND A.occr_rsn_cd		= B.occr_rsn_cd
							--AND A.exht_tp_cd		= B.exht_tp_cd
							AND A.plan_yyyymm		= B.plan_yyyymm
					  )		
					WHEN MATCHED AND (@v_qty = 0  OR (@v_occr_rsn_cd IS NULL AND  @v_exht_tp_cd IS NULL)) THEN	
							DELETE
					WHEN MATCHED AND @v_qty <> 0  AND (@v_occr_rsn_cd IS NOT NULL AND  @v_exht_tp_cd IS NOT NULL) THEN
						 UPDATE SET 
									occr_rsn_ctn	= @v_occr_rsn_ctn
								   ,exht_tp_ctn		= @v_exht_tp_ctn 
								   ,qty				= @v_qty
								   ,last_updated_by  = @v_user_id
								   ,last_update_date = sysdatetime()
								   ,occr_rsn_cd		= @v_occr_rsn_cd
								   ,exht_tp_cd		= @v_exht_tp_cd
					    
					WHEN NOT MATCHED AND 
						 ((@v_occr_rsn_cd IS NOT NULL AND  @v_exht_tp_cd IS NOT NULL AND @v_qty <> 0) OR  
						  (@v_occr_rsn_cd IS NOT NULL AND  @v_exht_tp_cd IS NOT NULL))
					THEN  

						 INSERT (   yyyymm
								  ,plant_id
								  ,division_id
								  ,item_id
								  ,charg
								  ,devaluation_age
								  ,occr_rsn_cd
								  ,occr_rsn_ctn
								  ,exht_tp_cd
								  ,exht_tp_ctn
								  ,plan_yyyymm
								  ,qty
								  ,created_by
								  ,create_date
								  ,last_updated_by
								  ,last_update_date
								)
						 VALUES (   @v_yyyymm
								   ,@v_plant_id
								   ,@v_division_id 
								   ,@v_item_id
								   ,@v_charg
								   ,@v_devaluation_age
								   ,@v_occr_rsn_cd
								   ,@v_occr_rsn_ctn
								   ,@v_exht_tp_cd
								   ,@v_exht_tp_ctn
								   ,@v_plan_yyyymm
								   ,@v_qty
								   ,@v_user_id
								   ,sysdatetime()
								   ,@v_user_id
								   ,sysdatetime()
								);
				END
			END		

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
			COMMIT TRAN;

			DROP TABLE #InputTable;
			-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code;

		END TRY

		BEGIN CATCH
		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
			VALUES (ERROR_PROCEDURE()
				   ,'ERROR'
				   ,NULL
				   ,ERROR_MESSAGE()
				   ,NULL
				   ,SYSDATETIME()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE());

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;
		END CATCH;
	END;





