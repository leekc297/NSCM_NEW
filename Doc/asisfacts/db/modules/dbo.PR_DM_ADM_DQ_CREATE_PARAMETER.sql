
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_PARAMETER
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 01. 04    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_ADM_DQ_CREATE_PARAMETER]

	-- Add the parameters for the stored procedure here
	@p_active_flag            NVARCHAR(MAX),    

	@p_DQ_ID                  NVARCHAR(MAX),    
	@p_PARAMETER_ID           NVARCHAR(MAX),
	@p_PARAMETER_TYPE         NVARCHAR(MAX),
	@p_OPERATION_ID           NVARCHAR(MAX),
	@p_VALID_YN               NVARCHAR(MAX),
	@p_SEQNO                  NVARCHAR(MAX),
	@p_REP_YN                 NVARCHAR(MAX),
	@p_CREATED_BY             NVARCHAR(MAX),
	@p_LAST_UPDATED_BY        NVARCHAR(MAX)
	--@p_CREATION_DATE          NVARCHAR(MAX),
	--@p_LAST_UPDATE_DATE       NVARCHAR(MAX),


	--  EXEC PR_DM_ADM_DQ_CREATE_PARAMETER @p_active_flag='M', @p_DQ_ID='27', @p_PARAMETER_ID='DIVISION_ID', @p_PARAMETER_TYPE='Text', @p_OPERATION_ID='', @p_VALID_YN='Y', @p_SEQNO='3', @p_REP_YN='', @p_CREATED_BY='20140001', @p_LAST_UPDATED_BY='20140001'


AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_ADM_DQ_CREATE_PARAMETER';
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
		BEGIN TRANSACTION DQ_CREATE_PARAMETER;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
	BEGIN
			-- (2) 	 
            /* INSERT 수행인경우 */
            IF @p_active_flag = 'I'

			   BEGIN
				
			   -- INSERT전 PK값 삭제
			   DELETE 
			   FROM [dbo].[SCM_ADM_DQ_PARAMETER]
			   WHERE
					   [DQ_ID]             =   @p_DQ_ID          
				   AND [PARAMETER_ID]      =   @p_PARAMETER_ID     

				-- INSERT 수행
        		--SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_ADM_DQ_PARAMETER
				INSERT INTO [dbo].[SCM_ADM_DQ_PARAMETER] 
				   (
					  [DQ_ID]
					 ,[PARAMETER_ID]
					 ,[PARAMETER_TYPE]
					 ,[OPERATION_ID]
					 ,[VALID_YN]
					 ,[REP_YN]
					 ,[CREATED_BY]
					 ,[CREATION_DATE]
					 ,[LAST_UPDATED_BY]
					 ,[LAST_UPDATE_DATE]
					 , ATTRIBUTE1
					   )
			 VALUES
				   (
    				  @p_DQ_ID         
    				 ,@P_PARAMETER_ID     
    				 ,@P_PARAMETER_TYPE    
    				 ,@P_OPERATION_ID     
    				 ,@P_VALID_YN       
    				 ,@P_REP_YN      
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
			
            UPDATE [dbo].[SCM_ADM_DQ_PARAMETER]

            SET 
                [DQ_ID]            =   @p_DQ_ID           
               ,[PARAMETER_ID]     =   @p_PARAMETER_ID
               ,[PARAMETER_TYPE]   =   @p_PARAMETER_TYPE
               ,[OPERATION_ID]     =   @p_OPERATION_ID
               ,[VALID_YN]         =   @p_VALID_YN
               ,[REP_YN]           =   @p_REP_YN
               --,[CREATED_BY]       =   @p_CREATED_BY
               ,[LAST_UPDATED_BY]  =   @p_LAST_UPDATED_BY
               ,[LAST_UPDATE_DATE] =   sysdatetime()
			   , ATTRIBUTE1 = @p_SEQNO

            WHERE
                   [DQ_ID]             =   @p_DQ_ID          
               AND [PARAMETER_ID]      =   @p_PARAMETER_ID     
			END
			-- (3) 	 
		
			-- (4) 	 
           /* DELETE */
           IF @p_active_flag = 'D'
           
		   BEGIN
           
		   DELETE 
           FROM [dbo].[SCM_ADM_DQ_PARAMETER]
           WHERE
                   [DQ_ID]             =   @p_DQ_ID          
               AND [PARAMETER_ID]      =   @p_PARAMETER_ID     
		   END
			-- (4) 	 

			--HISTORY INSERT
			BEGIN
				EXEC [dbo].PR_DM_ADM_DQ_CREATE_PARAMETER_HIST
					 @p_DQ_ID
					,@p_PARAMETER_ID
					,@p_PARAMETER_TYPE
					,@p_OPERATION_ID
					,@p_VALID_YN
					,@p_REP_YN
					,@p_CREATED_BY
					,@p_LAST_UPDATED_BY
			END

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
		ROLLBACK TRANSACTION DQ_CREATE_PARAMETER;
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
