
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE
 * Description  : Dynamic DQ_TEXT Register Batch (INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 01. 04    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_ADM_DQ_CREATE]

	-- Add the parameters for the stored procedure here
	@p_active_flag              NVARCHAR(MAX),    
	@p_DQ_ID                    NVARCHAR(MAX),
	@p_DIVISION_ID              NVARCHAR(MAX),
	@p_DQ_NAME                  NVARCHAR(MAX),
	@p_DESCRIPTION              NVARCHAR(MAX),
	@p_DQ_TEXT                  NVARCHAR(MAX),
	@p_VALID_YN                 NVARCHAR(MAX),
	@p_ADMIN_ONLY_YN            NVARCHAR(MAX),
	@p_CREATED_BY               NVARCHAR(MAX),
	--@p_CREATION_DATE            NVARCHAR(MAX),
	@p_LAST_UPDATED_BY          NVARCHAR(MAX)
	--@p_LAST_UPDATE_DATE         NVARCHAR(MAX)

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_ADM_DQ_CREATE';
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
		BEGIN TRANSACTION PR_DM_ADM_DQ_CREATE;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
			--HISTORY INSERT
			BEGIN
				EXEC [dbo].PR_DM_ADM_DQ_CREATE_HIST
					 @p_DQ_ID             
					,@p_DIVISION_ID    
					,@p_DQ_NAME        
					,@p_DESCRIPTION    
					,@p_DQ_TEXT
					,@p_VALID_YN       
					,@p_ADMIN_ONLY_YN  
					,@p_CREATED_BY     
					,@p_LAST_UPDATED_BY
			END

			-- (2) 	 
            /* INSERT */
            IF @p_active_flag = 'I'

			BEGIN
        	SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_ADM_DQ_LIST
            INSERT INTO [dbo].[SCM_ADM_DQ_LIST] 
               (
                [DQ_ID]
               ,[DIVISION_ID]
               ,[DQ_NAME]
               ,[DESCRIPTION]
               ,[DQ_TEXT]
               ,[VALID_YN]
               ,[ADMIN_ONLY_YN]
               ,[CREATED_BY]
               ,[CREATION_DATE]
               ,[LAST_UPDATED_BY]
               ,[LAST_UPDATE_DATE]
               )
         VALUES
               (
    	          @n_history_seq         
    	         ,@p_DIVISION_ID   
    	         ,@p_DQ_NAME       
    	         ,@p_DESCRIPTION          
    	         ,cast (@p_DQ_TEXT as NVARCHAR(MAX))
    	         ,@p_VALID_YN      
    	         ,@p_ADMIN_ONLY_YN 
    	         ,@p_CREATED_BY    
    	         ,sysdatetime()                   
    	         ,@p_last_updated_by          
    	         ,sysdatetime()                 
    	         )
			END
			-- (2) 	 
	
			-- (3) 	 
            /* UPDATE */
            IF @p_active_flag = 'M'

            BEGIN
				UPDATE [dbo].[SCM_ADM_DQ_LIST]
				SET 
					[DQ_ID]             =   @p_DQ_ID          
				   ,[DIVISION_ID]       =   @p_DIVISION_ID    
				   ,[DQ_NAME]           =   @p_DQ_NAME        
				   ,[DESCRIPTION]       =   @p_DESCRIPTION           
				   ,[DQ_TEXT]             =   cast (@p_DQ_TEXT as NVARCHAR(MAX))
				   ,[VALID_YN]          =   @p_VALID_YN       
				   ,[ADMIN_ONLY_YN]     =   @p_ADMIN_ONLY_YN  
				   --,[CREATED_BY]        =   @p_CREATED_BY     
				   ,[LAST_UPDATED_BY]   =   @p_last_updated_by
				   ,[LAST_UPDATE_DATE]  =   sysdatetime()     

				WHERE
					   [DQ_ID]             =   @p_DQ_ID          
			END
			-- (3) 	 
		
			-- (4) 	 
           /* DELETE */
           IF @p_active_flag = 'D'
           
		   BEGIN
			   DELETE 
			   FROM [dbo].[SCM_ADM_DQ_LIST]
			   WHERE
					   [DQ_ID]             =   @p_DQ_ID          
 		   END
			-- (4) 	 

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
		ROLLBACK TRANSACTION PR_DM_ADM_DQ_CREATE;

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
	  SELECT 'success' AS CODE, @n_history_seq AS SEQNO
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

