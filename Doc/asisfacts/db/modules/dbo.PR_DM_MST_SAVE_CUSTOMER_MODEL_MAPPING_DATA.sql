
/*
 * Program ID   : PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA
 * Description  : CUSTOMER MODEL MAPPING DATA INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 12. 15    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA]

	-- Add the parameters for the stored procedure here
	@p_active_flag			    NVARCHAR(MAX),
	@p_division_id              NVARCHAR(MAX),
	@p_customer_project_code    NVARCHAR(MAX),
	@p_customer_model           NVARCHAR(MAX),
	@p_scm_site_id              NVARCHAR(MAX),
	@p_project_code             NVARCHAR(MAX),
	@p_item_id                  NVARCHAR(MAX),
	@p_valid_yn                 NVARCHAR(MAX),
	@p_customer_model_type      NVARCHAR(MAX),
	@p_convert_qty_pack         NVARCHAR(MAX),
	@p_convert_qty_module       NVARCHAR(MAX),
	@p_convert_qty_cell         NVARCHAR(MAX),
	@p_created_by               NVARCHAR(MAX),
	@p_creation_date            NVARCHAR(MAX),
	@p_last_updated_by          NVARCHAR(MAX),
	@p_last_update_date         NVARCHAR(MAX)
	/*
	@p_attribute1               NVARCHAR(MAX), 
	@p_attribute2               NVARCHAR(MAX),
	@p_attribute3               NVARCHAR(MAX),
	@p_attribute4               NVARCHAR(MAX),
	@p_attribute5               NVARCHAR(MAX),
	@p_attribute6               NVARCHAR(MAX),
	@p_attribute7               NVARCHAR(MAX),
	@p_attribute8               NVARCHAR(MAX),
	@p_attribute9               NVARCHAR(MAX),
	@p_attribute10              NVARCHAR(MAX)
	*/
	--@p_success_yn			NVARCHAR(1) OUTPUT

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);

	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;
	
    DECLARE  @v_active_flag            NVARCHAR(MAX);
    DECLARE  @V_DIVISION_ID            NVARCHAR(MAX);
    DECLARE  @V_CUSTOMER_PROJECT_CODE  NVARCHAR(MAX);
    DECLARE  @V_CUSTOMER_MODEL         NVARCHAR(MAX);
    DECLARE  @V_SCM_SITE_ID            NVARCHAR(MAX);
    DECLARE  @V_PROJECT_CODE           NVARCHAR(MAX);
    DECLARE  @V_ITEM_ID                NVARCHAR(MAX);
    DECLARE  @V_VALID_YN               NVARCHAR(MAX);
    DECLARE  @V_CUSTOMER_MODEL_TYPE    NVARCHAR(MAX);
    DECLARE  @V_CONVERT_QTY_PACK       NVARCHAR(MAX);
    DECLARE  @V_CONVERT_QTY_MODULE     NVARCHAR(MAX);
    DECLARE  @V_CONVERT_QTY_CELL       NVARCHAR(MAX);
    DECLARE  @V_CREATED_BY             NVARCHAR(MAX);
    DECLARE  @V_CREATION_DATE          NVARCHAR(MAX);
    DECLARE  @V_LAST_UPDATED_BY        NVARCHAR(MAX);
    DECLARE  @V_LAST_UPDATE_DATE       NVARCHAR(MAX);
    DECLARE  @V_ATTRIBUTE1             NVARCHAR(MAX);
    DECLARE  @V_ATTRIBUTE2             NVARCHAR(MAX);
    DECLARE  @V_ATTRIBUTE3             NVARCHAR(MAX);
    DECLARE  @V_ATTRIBUTE4             NVARCHAR(MAX);
    DECLARE  @V_ATTRIBUTE5             NVARCHAR(MAX);
    DECLARE  @V_ATTRIBUTE6             NVARCHAR(MAX);
    DECLARE  @V_ATTRIBUTE7             NVARCHAR(MAX);
    DECLARE  @V_ATTRIBUTE8             NVARCHAR(MAX);
    DECLARE  @V_ATTRIBUTE9             NVARCHAR(MAX);
    DECLARE  @V_ATTRIBUTE10            NVARCHAR(MAX);


	-- recv init
    SET  @v_active_flag            =  NULL;
    SET  @V_DIVISION_ID            =  NULL;
    SET  @V_CUSTOMER_PROJECT_CODE  =  NULL;
    SET  @V_CUSTOMER_MODEL         =  NULL;
    SET  @V_SCM_SITE_ID            =  NULL;
    SET  @V_PROJECT_CODE           =  NULL;
    SET  @V_ITEM_ID                =  NULL;
    SET  @V_VALID_YN               =  NULL;
    SET  @V_CUSTOMER_MODEL_TYPE    =  NULL;
    SET  @V_CONVERT_QTY_PACK       =  NULL;
    SET  @V_CONVERT_QTY_MODULE     =  NULL;
    SET  @V_CONVERT_QTY_CELL       =  NULL;
    SET  @V_CREATED_BY             =  NULL;
    SET  @V_CREATION_DATE          =  NULL;
    SET  @V_LAST_UPDATED_BY        =  NULL;
    SET  @V_LAST_UPDATE_DATE       =  NULL;
    SET  @V_ATTRIBUTE1             =  NULL;
    SET  @V_ATTRIBUTE2             =  NULL;
    SET  @V_ATTRIBUTE3             =  NULL;
    SET  @V_ATTRIBUTE4             =  NULL;
    SET  @V_ATTRIBUTE5             =  NULL;
    SET  @V_ATTRIBUTE6             =  NULL;
    SET  @V_ATTRIBUTE7             =  NULL;
    SET  @V_ATTRIBUTE8             =  NULL;
    SET  @V_ATTRIBUTE9             =  NULL;
    SET  @V_ATTRIBUTE10            =  NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


		-- 트랜잭션 (START)
		BEGIN TRANSACTION CUSTOMER_MODEL_MAPPING_DATA;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		SELECT @max_loop_cnt;
		
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		-- (0)
		BEGIN    
			
		SELECT @max_loop_cnt AS max_loop_cnt
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

  		    -- DISPLAY
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL] (@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
					  
				SET @V_DIVISION_ID = [dbo].[SCM_ARR_SPL_VAL](@P_DIVISION_ID, @v_delimiter , @mst_loop_cnt) ; 

				SET @V_CUSTOMER_PROJECT_CODE = [dbo].[SCM_ARR_SPL_VAL](@P_CUSTOMER_PROJECT_CODE, @v_delimiter , @mst_loop_cnt) ; 
	
				SET @V_CUSTOMER_MODEL = [dbo].[SCM_ARR_SPL_VAL](@P_CUSTOMER_MODEL, @v_delimiter , @mst_loop_cnt) ;    

				SET @V_SCM_SITE_ID = [dbo].[SCM_ARR_SPL_VAL](@P_SCM_SITE_ID, @v_delimiter , @mst_loop_cnt) ;    

				SET @V_PROJECT_CODE = [dbo].[SCM_ARR_SPL_VAL](@P_PROJECT_CODE, @v_delimiter , @mst_loop_cnt) ; 

				SET @V_ITEM_ID = [dbo].[SCM_ARR_SPL_VAL](@P_ITEM_ID, @v_delimiter, @mst_loop_cnt) ; 

				SET @V_VALID_YN = [dbo].[SCM_ARR_SPL_VAL](@P_VALID_YN, @v_delimiter, @mst_loop_cnt) ; 

				SET @V_CUSTOMER_MODEL_TYPE = [dbo].[SCM_ARR_SPL_VAL](@P_CUSTOMER_MODEL_TYPE, @v_delimiter, @mst_loop_cnt) ; 

				SET @V_CONVERT_QTY_PACK = [dbo].[SCM_ARR_SPL_VAL](@P_CONVERT_QTY_PACK, @v_delimiter, @mst_loop_cnt) ; 

				SET @V_CONVERT_QTY_MODULE = [dbo].[SCM_ARR_SPL_VAL](@P_CONVERT_QTY_MODULE, @v_delimiter, @mst_loop_cnt) ; 

				SET @V_CONVERT_QTY_CELL = [dbo].[SCM_ARR_SPL_VAL](@P_CONVERT_QTY_CELL, @v_delimiter, @mst_loop_cnt) ; 

				SET @V_CREATED_BY = [dbo].[SCM_ARR_SPL_VAL](@P_CREATED_BY, @v_delimiter, @mst_loop_cnt) ; 

				SET @V_LAST_UPDATED_BY = [dbo].[SCM_ARR_SPL_VAL](@P_LAST_UPDATED_BY, @v_delimiter, @mst_loop_cnt) ; 

				/*-- 확인용 변수값 DISPLAY 
				SELECT @v_active_flag AS v_active_flag
				SELECT @V_DIVISION_ID AS V_DIVISION_ID
				SELECT @V_CUSTOMER_PROJECT_CODE AS V_CUSTOMER_PROJECT_CODE
				SELECT @V_CUSTOMER_MODEL AS V_CUSTOMER_MODEL
				SELECT @V_SCM_SITE_ID AS V_SCM_SITE_ID
				SELECT @V_PROJECT_CODE AS V_PROJECT_CODE
				SELECT @V_ITEM_ID AS V_ITEM_ID
				SELECT @V_VALID_YN AS V_VALID_YN
				SELECT @V_CUSTOMER_MODEL_TYPE AS V_CUSTOMER_MODEL_TYPE
				SELECT @V_CONVERT_QTY_PACK AS V_CONVERT_QTY_PACK
				SELECT @V_CONVERT_QTY_MODULE AS V_CONVERT_QTY_MODULE
				SELECT @V_CONVERT_QTY_CELL AS V_CONVERT_QTY_CELL
				SELECT @V_CREATED_BY AS V_CREATED_BY
				SELECT @V_LAST_UPDATED_BY AS V_LAST_UPDATED_BY
				*/
						
			END

            /*--------- MULTI & SINGLE ROW START --------*/

	      -- (1) 
		  /*-- max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행하도록함 --*/
          IF       @mst_loop_cnt <= @max_loop_cnt  
		  BEGIN

			-- (2) 	 
            /* INSERT */
            IF @v_active_flag = 'I'

			BEGIN
			   -- INSERT 전 PK값 DELETE
			   DELETE 
				   FROM [dbo].[DM_MST_CUSTOMER_MODEL]
				   WHERE
						 [DIVISION_ID] = @v_division_id
					 AND [CUSTOMER_PROJECT_CODE] = @v_customer_project_code
					 AND [CUSTOMER_MODEL] = @v_customer_model
					 AND [SCM_SITE_ID] = @v_scm_site_id ;

			   -- INSERT 수행
				INSERT INTO [dbo].[DM_MST_CUSTOMER_MODEL] 
				   (
					[DIVISION_ID]
				   ,[CUSTOMER_PROJECT_CODE]
				   ,[CUSTOMER_MODEL]
				   ,[SCM_SITE_ID]
				   ,[PROJECT_CODE]
				   ,[ITEM_ID]
				   ,[VALID_YN]
				   ,[CUSTOMER_MODEL_TYPE]
				   ,[CONVERT_QTY_PACK]
				   ,[CONVERT_QTY_MODULE]
				   ,[CONVERT_QTY_CELL]
				   ,[CREATED_BY]
				   ,[CREATION_DATE]
				   ,[LAST_UPDATED_BY]
				   ,[LAST_UPDATE_DATE]
				   ,[ATTRIBUTE1]  
				   ,[ATTRIBUTE2]  
				   ,[ATTRIBUTE3]  
				   ,[ATTRIBUTE4]  
				   ,[ATTRIBUTE5]  
				   ,[ATTRIBUTE6]  
				   ,[ATTRIBUTE7]  
				   ,[ATTRIBUTE8]  
				   ,[ATTRIBUTE9]  
				   ,[ATTRIBUTE10] 
				   )
			 VALUES
				   (
    				  @v_division_id              
    				 ,@v_customer_project_code    
    				 ,@v_customer_model           
    				 ,@v_scm_site_id              
    				 ,@v_project_code             
    				 ,@v_item_id                  
    				 ,@v_valid_yn                 
    				 ,@v_customer_model_type      
    				 ,@v_convert_qty_pack         
    				 ,@v_convert_qty_module       
    				 ,@v_convert_qty_cell         
    				 ,@v_created_by               
    				 ,sysdatetime()                   
    				 ,@v_last_updated_by          
    				 ,sysdatetime()                 
					 ,NULL
					 ,NULL
					 ,NULL
					 ,NULL
					 ,NULL
					 ,NULL
					 ,NULL
					 ,NULL
					 ,NULL
					 ,NULL
    				 ) ;
				END
			-- (2) 	 
	
			-- (3) 	 
            /* UPDATE */
            IF @v_active_flag = 'M'


            BEGIN

				UPDATE [dbo].[DM_MST_CUSTOMER_MODEL]

				SET 
				[PROJECT_CODE] = @v_project_code
				,[ITEM_ID] = @v_item_id
			   ,[VALID_YN] = @v_valid_yn
			   ,[CUSTOMER_MODEL_TYPE] = @v_customer_model_type
			   ,[CONVERT_QTY_PACK] = @v_convert_qty_pack
			   ,[CONVERT_QTY_MODULE] = @v_convert_qty_module
			   ,[CONVERT_QTY_CELL] = @v_convert_qty_cell
			   ,[LAST_UPDATED_BY] = @v_last_updated_by
			   ,[LAST_UPDATE_DATE] = sysdatetime()
			   ,[ATTRIBUTE1] = NULL
			   ,[ATTRIBUTE2] = NULL
			   ,[ATTRIBUTE3] = NULL
			   ,[ATTRIBUTE4] = NULL
			   ,[ATTRIBUTE5] = NULL
			   ,[ATTRIBUTE6] = NULL
			   ,[ATTRIBUTE7] = NULL
			   ,[ATTRIBUTE8] = NULL
			   ,[ATTRIBUTE9] = NULL
			   ,[ATTRIBUTE10] = NULL

				WHERE
    				  [DIVISION_ID] = @v_division_id
				  AND [CUSTOMER_PROJECT_CODE] = @v_customer_project_code
				  AND [CUSTOMER_MODEL] = @v_customer_model
				  AND [SCM_SITE_ID] = @v_scm_site_id ;
			END
			-- (3) 	 
		
			-- (4) 	 
           /* DELETE */
           IF @v_active_flag = 'D'
           
		   BEGIN
           
			   DELETE 
			   FROM [dbo].[DM_MST_CUSTOMER_MODEL]
			   WHERE
					 [DIVISION_ID] = @v_division_id
				 AND [CUSTOMER_PROJECT_CODE] = @v_customer_project_code
				 AND [CUSTOMER_MODEL] = @v_customer_model
				 AND [SCM_SITE_ID] = @v_scm_site_id
		   END
			-- (4) 	 

				-- HISTORY INSERT
				BEGIN
					EXEC [dbo].PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST
        				 @v_division_id
        				,@v_customer_project_code
        				,@v_customer_model
        				,@v_scm_site_id
        				,@v_project_code
        				,@v_item_id
        				,@v_valid_yn
        				,@v_customer_model_type
        				,@v_convert_qty_pack
        				,@v_convert_qty_module
        				,@v_convert_qty_cell
        				,@v_created_by
				END

	      END
	      -- (1)	 
        END
		-- (0)

     -- IF @@TRANCOUNT > 0 
	-- 트랜잭션 (COMMIT)
		COMMIT WORK ;	

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	


	--------------------------------------------------------------	
  	BEGIN CATCH
	--------------------------------------------------------------	
  	  ROLLBACK TRANSACTION CUSTOMER_MODEL_MAPPING_DATA;

		-- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;						

  

