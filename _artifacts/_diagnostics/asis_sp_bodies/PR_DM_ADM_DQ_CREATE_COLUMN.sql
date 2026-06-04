
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_COLUMN
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_COLUMN' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 01. 04    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_ADM_DQ_CREATE_COLUMN]

	-- Add the parameters for the stored procedure here
	@p_active_flag            NVARCHAR(MAX),    
	@p_DQ_ID                  NVARCHAR(MAX),    
	@p_COLUMN_NAME            NVARCHAR(MAX),
	@p_VALUE_YN               NVARCHAR(MAX),
	@p_VALUE_TYPE             NVARCHAR(MAX),
	@p_VALID_YN               NVARCHAR(MAX),
	@p_SEQNO                  NVARCHAR(MAX),
	@p_CREATED_BY             NVARCHAR(MAX),
	--@p_CREATION_DATE          NVARCHAR(MAX),
	@p_LAST_UPDATED_BY        NVARCHAR(MAX)
	--@p_LAST_UPDATE_DATE       NVARCHAR(MAX),

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_ADM_DQ_CREATE_COLUMN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION PR_DM_ADM_DQ_CREATE_COLUMN;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

			-- (2) 	 
            /* INSERT */
            IF @p_active_flag = 'I'

               -- INSERT전 PK값 DELETE
			   BEGIN
           
				   DELETE 
				   FROM [dbo].[SCM_ADM_DQ_COLUMN]
				   WHERE
						   [DQ_ID]             =   @p_DQ_ID          
					   AND [COLUMN_NAME]       =   @p_COLUMN_NAME       

                -- INSERT 수행
				INSERT INTO [dbo].[SCM_ADM_DQ_COLUMN] 
				   (
					  [DQ_ID]
					 ,[COLUMN_NAME]
					 ,[VALUE_YN]
					 ,[VALUE_TYPE]
					 ,[VALID_YN]
					 ,[CREATED_BY]
					 ,[CREATION_DATE]
					 ,[LAST_UPDATED_BY]
					 ,[LAST_UPDATE_DATE]
					 , ATTRIBUTE1
					   )
				 VALUES
					   (
    					  @p_DQ_ID
    					 ,@P_COLUMN_NAME
    					 ,@P_VALUE_YN        
    					 ,@P_VALUE_TYPE      
    					 ,@P_VALID_YN        
    					 ,@P_CREATED_BY      
    					 ,sysdatetime()   
						 ,@P_LAST_UPDATED_BY 
						 ,sysdatetime()
						 , @p_SEQNO
    					 )
					END
			-- (2) 	 
	
			-- (3) 	 
            /* UPDATE */
            IF @p_active_flag = 'M'

			   BEGIN
					UPDATE [dbo].[SCM_ADM_DQ_COLUMN]

					SET 
						[DQ_ID]            =   @p_DQ_ID           
					   ,[COLUMN_NAME]      =   @P_COLUMN_NAME
					   ,[VALUE_YN]         =   @p_VALUE_YN
					   ,[VALUE_TYPE]       =   @p_VALUE_TYPE
					   ,[VALID_YN]         =   @p_VALID_YN
					   --,[CREATED_BY]       =   @p_CREATED_BY
					   ,[LAST_UPDATED_BY]  =   @p_LAST_UPDATED_BY
					   ,[LAST_UPDATE_DATE] =   sysdatetime()
					   , ATTRIBUTE1 = @p_SEQNO

					WHERE
						   [DQ_ID]             =   @p_DQ_ID          
					   AND [COLUMN_NAME]       =   @p_COLUMN_NAME       
				END
			-- (3) 	 
		
			-- (4) 	 
           /* DELETE */
           IF @p_active_flag = 'D'
           
			   BEGIN
           
				   DELETE 
				   FROM [dbo].[SCM_ADM_DQ_COLUMN]
				   WHERE
						   [DQ_ID]             =   @p_DQ_ID          
					   AND [COLUMN_NAME]       =   @p_COLUMN_NAME       
			   END
			-- (4) 	 

			--HISTORY INSERT
			BEGIN
				EXEC [dbo].PR_DM_ADM_DQ_CREATE_COLUMN_HIST
					 @p_DQ_ID           
					,@p_COLUMN_NAME     
					,@p_VALUE_YN        
					,@p_VALUE_TYPE      
					,@p_VALID_YN        
					,@p_CREATED_BY      
					,@p_LAST_UPDATED_BY 
			END

     -- IF @@TRANCOUNT > 0 

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION PR_DM_ADM_DQ_CREATE_COLUMN;

      -- ROLLBACK
      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

