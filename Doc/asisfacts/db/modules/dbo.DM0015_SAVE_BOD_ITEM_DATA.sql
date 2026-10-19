/****************************************************************************************************/
/* Program ID  : [DM0015_SAVE_BOD_ITEM_DATA]														*/
/* Description : SCM_MST_BOD_ITEM INSERT														*/
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/01/16  JJH			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DM0015_SAVE_BOD_ITEM_DATA]
	@p_active_flag		NVARCHAR(MAX),
	@p_valid_yn			NVARCHAR(MAX),
	@p_division_id		NVARCHAR(MAX),
	@p_bod_id			NVARCHAR(MAX),
	@p_item_id			NVARCHAR(MAX),
	@p_eff_start_date	NVARCHAR(MAX),
	@p_lot_size			NVARCHAR(MAX),
	@p_frozen_period	NVARCHAR(MAX),
	@p_eff_end_date		NVARCHAR(MAX),
	@p_user_id			NVARCHAR(MAX)


AS

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @recv_valid_yn		NVARCHAR(MAX);
	SET @recv_valid_yn = NULL;		
	SET @recv_valid_yn = @p_active_flag;

	DECLARE	@v_active_flag		NVARCHAR(MAX);
	DECLARE @v_valid_yn			NVARCHAR(MAX);
	DECLARE @v_division_id		NVARCHAR(MAX);
	DECLARE @v_bod_id			NVARCHAR(MAX);
	DECLARE @v_item_id			NVARCHAR(MAX);
	DECLARE @v_eff_start_date	NVARCHAR(MAX);
	DECLARE @v_lot_size			NVARCHAR(MAX);
	DECLARE @v_frozen_period	NVARCHAR(MAX);
	DECLARE @v_eff_end_date		NVARCHAR(MAX);
	DECLARE @v_user_id			NVARCHAR(MAX);
	
	SET @v_active_flag		= NULL;
	SET @v_valid_yn			= NULL;
	SET @v_division_id		=NULL;
	SET @v_bod_id			=NULL;
	SET @v_item_id			=NULL;
	SET @v_eff_start_date	=NULL;
	SET @v_lot_size			=NULL;
	SET @v_frozen_period	=NULL;
	SET @v_eff_end_date		=NULL;
	SET @v_user_id			=NULL;
	

	-- 자식 프로시저 성공/에러 셋팅
	--DECLARE	@v_OK_description		NVARCHAR(1200);	
	

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DM0015_SAVE_BOD_ITEM_DATA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 시작 LOG  (END)
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN DM0015_SAVE_BOD_ITEM_DATA;
	
	BEGIN TRY

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_valid_yn, @v_delimiter);    
		--SELECT    @max_loop_cnt;
		--	WHILE LEN(@p_valid_yn) > 0
		WHILE LEN(@recv_valid_yn) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			
		
			
			IF @mst_loop_cnt > 0 

				BEGIN       
				
				

				SET  @v_valid_yn		=[dbo].[SCM_ARR_SPL_VAL](  @p_valid_yn			, @v_delimiter, @mst_loop_cnt) ;	
				
				
				SET  @v_division_id		=[dbo].[SCM_ARR_SPL_VAL](  @p_division_id			, @v_delimiter, @mst_loop_cnt) ;	
				SET  @v_bod_id			=[dbo].[SCM_ARR_SPL_VAL](  @p_bod_id				, @v_delimiter, @mst_loop_cnt) ;
				SET  @v_item_id			=[dbo].[SCM_ARR_SPL_VAL](  @p_item_id				, @v_delimiter, @mst_loop_cnt) ;	
				SET  @v_eff_start_date	=SUBSTRING(REPLACE([dbo].[SCM_ARR_SPL_VAL](  @p_eff_start_date		, @v_delimiter, @mst_loop_cnt),'-',''),1,8) ;	
				SET  @v_lot_size		=[dbo].[SCM_ARR_SPL_VAL](  @p_lot_size				, @v_delimiter, @mst_loop_cnt) ;	
				SET  @v_frozen_period	=[dbo].[SCM_ARR_SPL_VAL](  @p_frozen_period			, @v_delimiter, @mst_loop_cnt) ;	
				SET  @v_eff_end_date	=SUBSTRING(REPLACE([dbo].[SCM_ARR_SPL_VAL](  @p_eff_end_date			, @v_delimiter, @mst_loop_cnt),'-',''),1,8) ;	
				SET  @v_user_id			=[dbo].[SCM_ARR_SPL_VAL](	@p_user_id				, @v_delimiter, @mst_loop_cnt) ;	


				--HISTORY INSERT

				EXEC [dbo].[PR_DM_MST_BOD_ITEM_HIST]

					@v_division_id,
					@v_bod_id,
					@v_item_id,
					@v_eff_start_date,
					@v_lot_size,
					@v_frozen_period,
					@v_eff_end_date,
					@v_valid_yn,
					@v_user_id
									
					--SELECT @v_OK_description;
					--@v_OK_description OUTPUT

			 
					MERGE INTO [dbo].[SCM_MST_BOD_ITEM] A
					USING (
							SELECT 
								@v_division_id	as division_id, 
								@v_bod_id		as bod_id,
								@v_item_id		as item_id
						  ) B
					ON(
							    A.division_id  = B.division_id
							AND A.bod_id	   = B.bod_id
							AND A.item_id	   = B.item_id
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
								DIVISION_ID				  =    		@v_division_id		,
								BOD_ID					  =	   		@v_bod_id		   	,
								ITEM_ID					  =	   		@v_item_id		   	,
								EFF_START_DATE			  =	   		@v_eff_start_date		,
								LOT_SIZE				  =	   		@v_lot_size			   	,
								FROZEN_PERIOD			  =	   		@v_frozen_period			   	,
								EFF_END_DATE			  =	   		@v_eff_end_date	   	,		    
								VALID_YN				  =	     	@v_valid_yn	   	,
								LAST_UPDATED_BY			  =	   		@v_user_id		   	,
								LAST_UPDATE_DATE		  =			getdate()		

					WHEN NOT MATCHED THEN

						 INSERT (	DIVISION_ID		  ,
									BOD_ID			  ,
									ITEM_ID			  ,
									EFF_START_DATE	  ,
									LOT_SIZE		  ,
									FROZEN_PERIOD	  ,
									EFF_END_DATE	  ,
									VALID_YN		  ,
									CREATED_BY		  ,
									CREATION_DATE	  ,
									LAST_UPDATED_BY	  ,
									LAST_UPDATE_DATE  

								)
						 VALUES (	@v_division_id		,
									@v_bod_id		   	,
									@v_item_id		   	,
									@v_eff_start_date		,
									@v_lot_size			   	,
									@v_frozen_period			   	,
									@v_eff_end_date	   	,		    
									@v_valid_yn	   	,
									@v_user_id		   	,
									getdate()			,
									@v_user_id		   	,
									getdate()		
									
									
								  
								);

			  END

			ELSE    --단일 ROW 일때
			 
				BEGIN        

					SET  @v_valid_yn		=  @p_valid_yn			;
																	;
																	;
					SET  @v_division_id		=  @p_division_id		;	
					SET  @v_bod_id			=  @p_bod_id			;
					SET  @v_item_id			=  @p_item_id			;	
					SET  @v_eff_start_date	=  SUBSTRING(REPLACE(@p_eff_start_date,'-',''),1,8)	;	
					SET  @v_lot_size		=  @p_lot_size			;	
					SET  @v_frozen_period	=  @p_frozen_period		;	
					SET  @v_eff_end_date	=  SUBSTRING(REPLACE(@p_eff_end_date,'-',''),1,8)		;	
					SET  @v_user_id			=	@p_user_id			;	
			 
			
				--HISTORY INSERT

				EXEC [dbo].[PR_DM_MST_BOD_ITEM_HIST]

					@v_division_id,
					@v_bod_id,
					@v_item_id,
					@v_eff_start_date,
					@v_lot_size,
					@v_frozen_period,
					@v_eff_end_date,
					@v_valid_yn,
					@v_user_id
									
					--SELECT @v_OK_description;
					--@v_OK_description OUTPUT


					MERGE INTO [dbo].[SCM_MST_BOD_ITEM] A
					USING (
							SELECT 
								@v_division_id	as division_id, 
								@v_bod_id		as bod_id,
								@v_item_id		as item_id
						  ) B
					ON(
							    A.division_id  = B.division_id
							AND A.bod_id	   = B.bod_id
							AND A.item_id	   = B.item_id
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
								DIVISION_ID				  =    		@v_division_id		,
								BOD_ID					  =	   		@v_bod_id		   	,
								ITEM_ID					  =	   		@v_item_id		   	,
								EFF_START_DATE			  =	   		@v_eff_start_date		,
								LOT_SIZE				  =	   		@v_lot_size			   	,
								FROZEN_PERIOD			  =	   		@v_frozen_period			   	,
								EFF_END_DATE			  =	   		@v_eff_end_date		   	,		    
								VALID_YN				  =	     	@v_valid_yn	   	,
								LAST_UPDATED_BY			  =	   		@v_user_id		   	,
								LAST_UPDATE_DATE		  =			getdate()		

					WHEN NOT MATCHED THEN

						 INSERT (	DIVISION_ID		  ,
									BOD_ID			  ,
									ITEM_ID			  ,
									EFF_START_DATE	  ,
									LOT_SIZE		  ,
									FROZEN_PERIOD	  ,
									EFF_END_DATE	  ,
									VALID_YN		  ,
									CREATED_BY		  ,
									CREATION_DATE	  ,
									LAST_UPDATED_BY	  ,
									LAST_UPDATE_DATE  

								)
						 VALUES (	@v_division_id		,
									@v_bod_id		   	,
									@v_item_id		   	,
									@v_eff_start_date	,
									@v_lot_size			   	,
									@v_frozen_period			   	,
									@v_eff_end_date	   	,		    
									@v_valid_yn	   	,
									@v_user_id		   	,
									getdate()			,
									@v_user_id		   	,
									getdate()		
									
									
								  
								);

				END
			END
			
			COMMIT  ;	
		END TRY
				

	BEGIN CATCH

		ROLLBACK TRAN DM0015_SAVE_BOD_ITEM_DATA ;	-- ROLLBACK
		
		-- ERROR LOG
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		-- 자식 프로시저 에러발생 원인분석
		--IF @v_OK_description <> 'OK'
		--SET @v_log_message = CAST(@v_OK_description AS NVARCHAR(1000));

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

    END CATCH;

	--select 'success'

		-- 종료 LOG
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


  END;						

  

