/****************************************************************************************************/
/* Program ID  : [DMF0004_SAVE_SALES_SITE_BUCKET_DATA]                                              */
/* Description : BUCKET COVERSION 저장, 수정, 삭제													*/
/* Usage       : Procedure 작성 시 참조하세요!														*/
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/12/05  Songdh       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트	*/
/* 2022/10/24  ROSIA27		[C20221024-000510]DM UI 소스 정리 요청									*/
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0004_SAVE_SALES_SITE_BUCKET_DATA]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_Incoterms            NVARCHAR(MAX),
	@p_yyyymmdd				NVARCHAR(MAX),
	@p_bucket_per			NVARCHAR(MAX),
	@p_conversion_type		NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;
	
	DECLARE @recv_active_flag			NVARCHAR(MAX);
	DECLARE @recv_division_id			NVARCHAR(MAX);
	DECLARE @recv_scm_site_id			NVARCHAR(MAX);
	DECLARE @recv_Incoterms  			NVARCHAR(MAX);
	DECLARE @recv_yyyymmdd				NVARCHAR(MAX);
	DECLARE @recv_bucket_per			NVARCHAR(MAX);
	DECLARE @recv_conversion_type		NVARCHAR(MAX);
	--DECLARE	@v_OK_description			NVARCHAR(1200);	-- 자식 프로시저 성공/에러 셋팅

	SET @recv_active_flag = NULL;
	SET @recv_division_id = NULL;
	SET @recv_scm_site_id = NULL;
	SET @recv_Incoterms = NULL;
	SET @recv_yyyymmdd = NULL;
	SET @recv_bucket_per = NULL;
	SET @recv_conversion_type = NULL;	 
		
	SET @recv_active_flag = @p_active_flag;
	SET @recv_division_id = @p_division_id;
	SET @recv_scm_site_id = @p_scm_site_id;
	SET @recv_Incoterms = @p_Incoterms;
	SET @recv_yyyymmdd = @p_yyyymmdd;
	SET @recv_bucket_per = @p_bucket_per;
	SET @recv_conversion_type = @p_conversion_type;
	
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_scm_site_id			NVARCHAR(MAX);
	DECLARE @v_Incoterms			NVARCHAR(MAX);
	DECLARE @v_yyyymmdd				NVARCHAR(MAX);
	DECLARE @v_bucket_per			NVARCHAR(MAX);
	DECLARE @v_conversion_type		NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_scm_site_id = NULL;
	SET @v_Incoterms = NULL;
	SET @v_yyyymmdd = NULL;
	SET @v_bucket_per = NULL;
	SET @v_conversion_type = NULL;	 
	SET @v_created_by = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0004_SAVE_SALES_SITE_BUCKET_DATA';
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

	BEGIN TRANSACTION SALES_SITE_BUCKET_DATA;
	
		BEGIN TRY
		--DECLARE @results TABLE (    
		--						active_flag			NVARCHAR(MAX)
		--					   ,division_id			NVARCHAR(MAX)
		--					   ,scm_site_id			NVARCHAR(MAX)
		--					   ,yyyymmdd			NVARCHAR(MAX)
		--					   ,bucket_per			NVARCHAR(MAX)
		--					   ,conversion_type	    NVARCHAR(MAX)
		--						) 
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		--SELECT    @max_loop_cnt;

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
					  
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_division_id

				SET @v_scm_site_id = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_scm_site_id

				SET @v_Incoterms = [dbo].[SCM_ARR_SPL_VAL](@p_Incoterms, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_Incoterms

				SET @v_yyyymmdd = [dbo].[SCM_ARR_SPL_VAL](@p_yyyymmdd, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_yyyymmdd

				SET @v_bucket_per = [dbo].[SCM_ARR_SPL_VAL](@p_bucket_per, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_bucket_per

				SET @v_conversion_type = [dbo].[SCM_ARR_SPL_VAL](@p_conversion_type, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_conversion_type

				SET @v_created_by = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_created_by
						
			END
			
			IF @mst_loop_cnt > 0			--SELECT 	@n_active_flag

				BEGIN       
				
					--SELECT @n_active_flag,'active_flag'
					--SELECT @v_active_flag;
					--SELECT @recv_active_flag;       
					--SELECT @p_active_flag;        
					--SELECT @v_division_id;      
					--SELECT @recv_division_id;      
					--SELECT @p_division_id; 
					--SELECT @v_scm_site_id;    
					--SELECT @p_scm_site_id;  
					--SELECT @v_yyyymmdd;    
					--SELECT @p_yyyymmdd;   
				--	--SELECT @v_conversion_type;     
				--	--SELECT @p_conversion_type;

					--SELECT @v_bucket_per		-- 30
					--SELECT @recv_bucket_per		-- 5^5^60
					--SELECT CONVERT(INT,  REPLACE(@v_bucket_per,@v_delimiter,''))		-- 30
					--SELECT CONVERT(INT,  REPLACE(CAST(@v_bucket_per AS NVARCHAR(10)),@v_delimiter,'' )
					--SELECT CONVERT(INT, @v_bucket_per);  
		 

				--HISTORY INSERT

				EXEC	[dbo].[PR_DM_MST_BUCKET_CONVERSION_HIST]	--@return_value = [dbo].[PR_DM_MST_BUCKET_CONVERSION_HIST]
						@v_division_id,
						@v_scm_site_id,
						@v_Incoterms,
						@v_yyyymmdd,		
						@v_bucket_per,
						@v_conversion_type,
						@v_created_by

						--SELECT @v_OK_description;
						--@v_OK_description OUTPUT

			 
					MERGE INTO [dbo].[dm_mst_bucket_conversion] A
					USING (
							SELECT 
								@v_division_id	as division_id, 
								@v_scm_site_id	as scm_site_id, 
								@v_Incoterms    as Incoterms,
								@v_yyyymmdd		as yyyymmdd
						  ) B
					ON(
							    A.division_id = B.division_id
							AND A.scm_site_id = B.scm_site_id
							AND A.Incoterms   = B.Incoterms
							AND A.yyyymmdd    = B.yyyymmdd
					  )
					WHEN MATCHED THEN
						 UPDATE SET --bucket_per		 = CONVERT(INT,  CAST(@v_bucket_per AS NVARCHAR(10)))
									bucket_per		 = @v_bucket_per
								   ,last_updated_by  = @v_created_by
								   ,last_update_date = sysdatetime()
					                
					WHEN NOT MATCHED THEN

						 INSERT (  division_id
								  ,project_code
								  ,scm_site_id
								  ,Incoterms
								  ,item_id
								  ,yyyymmdd
								  ,bucket_per
								  ,conversion_type
								  ,valid_yn
								  ,created_by
								  ,creation_date
								  ,last_updated_by
								  ,last_update_date
								)
						 VALUES (   @v_division_id
								   ,'***'
								   ,@v_scm_site_id 
								   ,@v_Incoterms
								   ,'***'
								   ,@v_yyyymmdd
								   ,@v_bucket_per
								   --,CONVERT(INT,  CAST(@v_bucket_per AS NVARCHAR(10)))
								   --,CONVERT(INT,  REPLACE(@v_bucket_per,@v_delimiter,''))
								   ,@v_conversion_type
								   ,'Y'
								   ,@v_created_by
								   ,sysdatetime()
								   ,@v_created_by
								   ,sysdatetime()
								);

			  END



			ELSE    --단일 ROW 일때
			 
				BEGIN        
					SET @v_active_flag = @p_active_flag        
					SET @p_active_flag = NULL       
					SET @v_division_id = @p_division_id        
					SET @p_division_id = NULL      
					SET @v_scm_site_id = @p_scm_site_id        
					SET @p_scm_site_id = NULL    
					SET @v_Incoterms = @p_Incoterms
					SET @p_Incoterms = NULL
					SET @v_yyyymmdd = @p_yyyymmdd       
					SET @p_yyyymmdd = NULL  
					SET @v_bucket_per = @p_bucket_per 
					SET @p_bucket_per = NULL
					SET @v_conversion_type = @p_conversion_type 
					SET @p_conversion_type = NULL
					SET @v_created_by = @p_created_by 
					SET @p_created_by = NULL

					--SELECT @n_active_flag,'active_flag'
					--SELECT @n_division_id
					--SELECT @n_scm_site_id
					--SELECT @n_yyyymmdd
					--SELECT @n_bucket_per
					--SELECT @n_conversion_type
					----SELECT			@v_division_id
					----			   ,'***'
					----			   ,@v_scm_site_id 
					----			   ,'***'
					----			   ,@v_yyyymmdd
					----			   ,@v_bucket_per
					----			   ,@v_conversion_type
					----			   ,'Y'
					----			   ,'system'
					----			   ,sysdatetime()
					----			   ,'system'
					----			   ,sysdatetime()
					
					EXEC	[dbo].[PR_DM_MST_BUCKET_CONVERSION_HIST]	--@return_value = [dbo].[PR_DM_MST_BUCKET_CONVERSION_HIST]
						@v_division_id,
						@v_scm_site_id,
						@v_Incoterms,
						@v_yyyymmdd,		
						@v_bucket_per,
						@v_conversion_type,
						@v_created_by

						--SELECT @v_OK_description;
						--@v_OK_description OUTPUT

					MERGE INTO [dbo].[dm_mst_bucket_conversion] A
					USING (
							SELECT @v_division_id as division_id, 
							       @v_scm_site_id as scm_site_id, 
								   @v_Incoterms as Incoterms, 
								   @v_yyyymmdd as yyyymmdd
						  ) B
					ON(
							    A.division_id = B.division_id
							AND A.scm_site_id = B.scm_site_id
							AND A.Incoterms   = B.Incoterms
							AND A.yyyymmdd    = B.yyyymmdd
					  )
					WHEN MATCHED THEN
						 UPDATE SET bucket_per		 = @v_bucket_per
								   ,last_updated_by  = @v_created_by
								   ,last_update_date = sysdatetime()
					    
					WHEN NOT MATCHED THEN

						 INSERT (  division_id
								  ,project_code
								  ,scm_site_id
								  ,Incoterms
								  ,item_id
								  ,yyyymmdd
								  ,bucket_per
								  ,conversion_type
								  ,valid_yn
								  ,created_by
								  ,creation_date
								  ,last_updated_by
								  ,last_update_date
								)
						 VALUES (   @v_division_id
								   ,'***'
								   ,@v_scm_site_id 
								   ,@v_Incoterms
								   ,'***'
								   ,@v_yyyymmdd
								   ,@v_bucket_per
								   ,@v_conversion_type
								   ,'Y'
								   ,@v_created_by
								   ,sysdatetime()
								   ,@v_created_by
								   ,sysdatetime()
								);
				END
			END

			--SET @v_log_type = 'END';
			--SET @v_log_message = '########## END of procedure ##########';
			--SET @v_description = '';
			--SET @d_event_date = SYSDATETIME();

			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
	    COMMIT ;

		END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION SALES_SITE_BUCKET_DATA ;	

		  -- ERROR LOG
		  SET @v_log_type = 'ERROR';
		  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		  SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		  SET @d_event_date = SYSDATETIME();

		  --IF @v_OK_description <> 'OK'
		  --SET @v_log_message = CAST(@v_OK_description AS NVARCHAR(1000));
		  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

	END CATCH;

	--SELECT 'success'

	-- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



	END;
