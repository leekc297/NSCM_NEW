
/**************************************************************************************************
 * Program ID  : PR_SCP_ANL_DIO_REPORT_VERSION_DELETE
 * Description :  DIO REPORT VERSION DELETE
 * Execute     : EXECUTE PR_SCP_ANL_DIO_REPORT_VERSION_DELETE 
						 @P_DIVISION_ID = '81'
						,@P_PLAN_START_YYYYMMDD= '20220328' 
						,@P_PLAN_TYPE = 'FN'
						,@P_SEQ = 1
						,@P_VER = 1
						,@P_CREATED_BY = 'vadabi3'
 * Program History      
 *==================================================================================================     
 *   Date		In Charge	Description      
 *==================================================================================================      
 * 2022/08/19	vadabi3	Initial Release
****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_SCP_ANL_DIO_REPORT_VERSION_DELETE]  
	@P_DIVISION_ID		         	NVARCHAR(30), 
	@P_PLAN_START_YYYYMMDD			NVARCHAR(8),
	@P_PLAN_TYPE					NVARCHAR(8),
	@P_SEQ                     		NVARCHAR(8),
	@P_VER                     		NVARCHAR(8),
	@P_CREATED_BY                   NVARCHAR(150)
AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;

	---------------------------------------------------------------------------------------------------------
	-- LOG START
	---------------------------------------------------------------------------------------------------------
	DECLARE @RETURN  AS NVARCHAR(10) = '0';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_DIO_REPORT_VERSIO_DELETE'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30);		-- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = ISNULL(@P_CREATED_BY,''); 

	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure  ##########';     
    SET @v_description = @P_DIVISION_ID + ' : ' + @P_PLAN_START_YYYYMMDD   + ' : ' + @P_PLAN_TYPE + ' : ' + @P_SEQ + ' : ' + @P_VER + ' : ' + @P_CREATED_BY ;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL;

	BEGIN
		PRINT '--------------------------------- -';
		PRINT '@P_DIVISION_ID			=' +@P_DIVISION_ID
		PRINT '@P_PLAN_START_YYYYMMDD	=' +@P_PLAN_START_YYYYMMDD;
		PRINT '@P_PLAN_TYPE				=' +@P_PLAN_TYPE;
		PRINT '@P_SEQ					= ' +@P_SEQ;
		PRINT '@P_VER					= ' + CONVERT(VARCHAR(10), ISNULL(@P_VER, 1));
		PRINT '@P_CREATED_BY			= ' + @P_CREATED_BY;
		PRINT '----------------------------------';
	END;
	
    BEGIN TRY
    BEGIN
		---------------------------------------------------------------------------------------------------------
		-- STEP 1 데이터 존재여부 체크
		---------------------------------------------------------------------------------------------------------
		 SELECT @n_log_count = count(*)
		   FROM SCP_ANL_DIO_REPORT_VERSION V WITH(NOLOCK)
	      WHERE V.DIVISION_ID			= @P_DIVISION_ID
			AND V.PLAN_START_YYYYMMDD   = @P_PLAN_START_YYYYMMDD
			AND V.PLAN_TYPE			    = @P_PLAN_TYPE
			AND V.SEQ					= @P_SEQ
			AND V.VER					= @P_VER

		IF @n_log_count = 0  
			BEGIN
				SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
									 REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                
				SET @v_log_type = N'SKIP';                  
				SET @v_log_message = N'SKIP : NO DATA';                  
				SET @v_description = N'['+ @v_exec_time + ']';             
				SET @d_event_date = SYSDATETIME()  ;  
	
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
										  ,@p_log_type      =@v_log_type                  
										  ,@p_log_count     =@n_log_count                   
										  ,@p_log_message   =@v_log_message                   
										  ,@p_description   =@v_description                   
										  ,@p_event_date    =@d_event_date                   
										  ,@p_user_id       =@v_batch_user                  
										  ;                  
				RETURN 0;   
		END

		---------------------------------------------------------------------------------------------------------
		-- STEP 2 SCP_ANL_DIO_REPORT_VERSION > VER_STATUS = 'D'
		---------------------------------------------------------------------------------------------------------
		  UPDATE SCP_ANL_DIO_REPORT_VERSION
		    SET VER_STATUS = 'P'
	      WHERE DIVISION_ID			= @P_DIVISION_ID
			AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
			AND PLAN_TYPE		    = @P_PLAN_TYPE
			AND SEQ					= @P_SEQ
			AND VER					= @P_VER
		---------------------------------------------------------------------------------------------------------
		    SET @n_log_count = @@ROWCOUNT;
			SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
									REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                
			SET @v_log_type = N'STEP';                  
			SET @v_log_message = N'STEP 2 SCP_ANL_DIO_REPORT_VERSION > VER_STATUS = D';                  
			SET @v_description = N'['+ @v_exec_time + ']';             
			SET @d_event_date = SYSDATETIME()  ;  
	
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
										,@p_log_type      =@v_log_type                  
										,@p_log_count     =@n_log_count                   
										,@p_log_message   =@v_log_message                   
										,@p_description   =@v_description                   
										,@p_event_date    =@d_event_date                   
										,@p_user_id       =@v_batch_user                  
										;  






		---------------------------------------------------------------------------------------------------------
		--  STEP 3 DELETE FROM SCP_ANL_DIO_REPORT
		---------------------------------------------------------------------------------------------------------
	    DELETE FROM SCP_ANL_DIO_REPORT
			  WHERE DIVISION_ID			= @P_DIVISION_ID
				AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
				AND PLAN_TYPE		    = @P_PLAN_TYPE
				AND SEQ					= @P_SEQ
				AND VER					= @P_VER
		---------------------------------------------------------------------------------------------------------
		    SET @n_log_count = @@ROWCOUNT;
			SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
									REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                
			SET @v_log_type = N'STEP';                  
			SET @v_log_message = N'STEP 3 DELETE FROM SCP_ANL_DIO_REPORT';                  
			SET @v_description = N'['+ @v_exec_time + ']';             
			SET @d_event_date = SYSDATETIME()  ;  
	
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
										,@p_log_type      =@v_log_type                  
										,@p_log_count     =@n_log_count                   
										,@p_log_message   =@v_log_message                   
										,@p_description   =@v_description                   
										,@p_event_date    =@d_event_date                   
										,@p_user_id       =@v_batch_user                  
										;  



		---------------------------------------------------------------------------------------------------------
		--  SCP_ANL_PSI_GLOBAL ?
		---------------------------------------------------------------------------------------------------------
				
		---------------------------------------------------------------------------------------------------------
		--  STEP 4 DELETE FROM SCP_ANL_DIO_REPORT_DETAIL
		---------------------------------------------------------------------------------------------------------
	    DELETE FROM SCP_ANL_DIO_REPORT_DETAIL
			  WHERE DIVISION_ID			= @P_DIVISION_ID
				AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
				AND PLAN_TYPE		    = @P_PLAN_TYPE
				AND SEQ					= @P_SEQ
				AND VER					= @P_VER
		---------------------------------------------------------------------------------------------------------
		    SET @n_log_count = @@ROWCOUNT;
			SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
									REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                
			SET @v_log_type = N'STEP';                  
			SET @v_log_message = N'STEP 4 DELETE FROM SCP_ANL_DIO_REPORT_DETAIL';                  
			SET @v_description = N'['+ @v_exec_time + ']';             
			SET @d_event_date = SYSDATETIME()  ;  
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
										,@p_log_type      =@v_log_type                  
										,@p_log_count     =@n_log_count                   
										,@p_log_message   =@v_log_message                   
										,@p_description   =@v_description                   
										,@p_event_date    =@d_event_date                   
										,@p_user_id       =@v_batch_user                  
										;  

		---------------------------------------------------------------------------------------------------------
		-- STEP 5-1  DELETE FROM SCP_ANL_DIO_REPORT_H
		---------------------------------------------------------------------------------------------------------
	    DELETE FROM SCP_ANL_DIO_REPORT_H
			  WHERE DIVISION_ID			= @P_DIVISION_ID
				AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
				AND PLAN_TYPE		    = @P_PLAN_TYPE
				AND SEQ					= @P_SEQ
				AND VER					= @P_VER

		---------------------------------------------------------------------------------------------------------
		    SET @n_log_count = @@ROWCOUNT;
			SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
									REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                
			SET @v_log_type = N'STEP';                  
			SET @v_log_message = N'STEP 5-1 DELETE FROM SCP_ANL_DIO_REPORT_H';                  
			SET @v_description = N'['+ @v_exec_time + ']';             
			SET @d_event_date = SYSDATETIME()  ;  
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name    =@v_program_name                  
										,@p_log_type      =@v_log_type                  
										,@p_log_count     =@n_log_count                   
										,@p_log_message   =@v_log_message                   
										,@p_description   =@v_description                   
										,@p_event_date    =@d_event_date                   
										,@p_user_id       =@v_batch_user                  
	
		---------------------------------------------------------------------------------------------------------
		-- STEP 5-2  INSERT SCP_ANL_DIO_REPORT_H
		---------------------------------------------------------------------------------------------------------
		/* 불필요
	INSERT  INTO  SCP_ANL_DIO_REPORT_H (   
					                     DIVISION_ID
										,PLAN_START_YYYYMMDD
										,PLAN_TYPE
										,SEQ
										,VER
										,NICK_NAME
										,PLANT_ID
										,FROM_SITE
										,TO_SITE
										,END_CUSTOMER
										,ITEM_ID
										,CELL_ITEM_ID
										,VERSION
										,CREATED_BY
										,CREATION_DATE
										,LAST_UPDATED_BY
										,LAST_UPDATE_DATE
										)
								 SELECT  @P_DIVISION_ID
										,@P_PLAN_START_YYYYMMDD
										,@P_PLAN_TYPE
										,@P_SEQ
										,@P_VER
										,'DELETE'
										,'DELETE'
										,'DELETE'
										,'DELETE'
										,'DELETE'
										,'DELETE'
										,'DELETE'
										,@P_VER
										,@P_CREATED_BY
										,SYSDATETIME()
										,@P_CREATED_BY
										,SYSDATETIME()
		*/
		---------------------------------------------------------------------------------------------------------
		    SET @n_log_count = @@ROWCOUNT;
			SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
									REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                
			SET @v_log_type = N'STEP';                  
			SET @v_log_message = N'STEP 5-2  INSERT SCP_ANL_DIO_REPORT_H';                  
			SET @v_description = N'['+ @v_exec_time + ']';             
			SET @d_event_date = SYSDATETIME()  ;  
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name    =@v_program_name                  
										,@p_log_type      =@v_log_type                  
										,@p_log_count     =@n_log_count                   
										,@p_log_message   =@v_log_message                   
										,@p_description   =@v_description                   
										,@p_event_date    =@d_event_date                   
										,@p_user_id       =@v_batch_user    



		---------------------------------------------------------------------------------------------------------
		--  STEP 6 DELETE FROM SCP_ANL_DIO_CYCLE_INVENTORY
		---------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_ANL_DIO_CYCLE_INVENTORY
			  WHERE DIVISION_ID			= @P_DIVISION_ID
				AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
				AND PLAN_TYPE		    = @P_PLAN_TYPE
				AND SEQ					= @P_SEQ
				AND VER					= @P_VER

		---------------------------------------------------------------------------------------------------------
		    SET @n_log_count = @@ROWCOUNT;
			SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
									REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                
			SET @v_log_type = N'STEP';                  
			SET @v_log_message = N'STEP 6 DELETE FROM SCP_ANL_DIO_CYCLE_INVENTORY';                  
			SET @v_description = N'['+ @v_exec_time + ']';             
			SET @d_event_date = SYSDATETIME()  ;  
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
										,@p_log_type      =@v_log_type                  
										,@p_log_count     =@n_log_count                   
										,@p_log_message   =@v_log_message                   
										,@p_description   =@v_description                   
										,@p_event_date    =@d_event_date                   
										,@p_user_id       =@v_batch_user                  
										;  



		---------------------------------------------------------------------------------------------------------
		-- STEP 7 DELETE FROM SCP_ANL_DIO_REPORT_DETAIL_AGING -- 20220823 추가 
		---------------------------------------------------------------------------------------------------------
		DELETE FROM SCP_ANL_DIO_REPORT_DETAIL_AGING
				WHERE DIVISION_ID			= @P_DIVISION_ID
				AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
				AND PLAN_TYPE		    = @P_PLAN_TYPE
				AND SEQ					= @P_SEQ
				AND VER					= @P_VER

		---------------------------------------------------------------------------------------------------------
		    SET @n_log_count = @@ROWCOUNT;
			SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
									REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                
			SET @v_log_type = N'STEP';                  
			SET @v_log_message = N'STEP 7 DELETE FROM SCP_ANL_DIO_REPORT_DETAIL_AGING';                  
			SET @v_description = N'['+ @v_exec_time + ']';             
			SET @d_event_date = SYSDATETIME()  ;  
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
										,@p_log_type      =@v_log_type                  
										,@p_log_count     =@n_log_count                   
										,@p_log_message   =@v_log_message                   
										,@p_description   =@v_description                   
										,@p_event_date    =@d_event_date                   
										,@p_user_id       =@v_batch_user                  
										;  

		---------------------------------------------------------------------------------------------------------
		-- STEP 8 DELETE FROM SCP_ANL_DIO_REPORT_VERSION
		---------------------------------------------------------------------------------------------------------
		DELETE FROM SCP_ANL_DIO_REPORT_VERSION
				WHERE DIVISION_ID			= @P_DIVISION_ID
				AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
				AND PLAN_TYPE		    = @P_PLAN_TYPE
				AND SEQ					= @P_SEQ
				AND VER					= @P_VER

		---------------------------------------------------------------------------------------------------------
		    SET @n_log_count = @@ROWCOUNT;
			SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
									REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                
			SET @v_log_type = N'STEP';                  
			SET @v_log_message = N'STEP 8 DELETE FROM SCP_ANL_DIO_REPORT_VERSION';                  
			SET @v_description = N'['+ @v_exec_time + ']';             
			SET @d_event_date = SYSDATETIME()  ;  
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
										,@p_log_type      =@v_log_type                  
										,@p_log_count     =@n_log_count                   
										,@p_log_message   =@v_log_message                   
										,@p_description   =@v_description                   
										,@p_event_date    =@d_event_date                   
										,@p_user_id       =@v_batch_user                  
										;  
		SET @RETURN = '1';
		SELECT @RETURN AS RESULT;

     END;     
     END TRY

     BEGIN CATCH     

	---------------------------------------------------------------------------------------------------------
	-- LOG ERROR
	---------------------------------------------------------------------------------------------------------
	   DELETE SCP_ANL_DIO_REPORT_VERSION
		WHERE DIVISION_ID		  = @P_DIVISION_ID
		  AND PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
		  AND PLAN_TYPE			  = @P_PLAN_TYPE
		  AND SEQ				  = @P_SEQ
		  AND VER				  = @P_VER
		  AND VER_STATUS		  = 'P' 
		  ;

      SET @v_log_type = N'ERROR';                  
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
      SET @d_event_date = SYSDATETIME();                  
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                                ,@p_log_type      =@v_log_type                  
                                ,@p_log_count     =@n_log_count                   
                                ,@p_log_message   =@v_log_message                   
                                ,@p_description   =@v_description                   
                                ,@p_event_date    =@d_event_date                   
                                ,@p_user_id       =@v_batch_user                  
                                ;                  
       PRINT @@ERROR    
	   PRINT @v_log_message + ' : ' + @v_description;
      return -1      
    END CATCH;  


	---------------------------------------------------------------------------------------------------------
	-- LOG END
	---------------------------------------------------------------------------------------------------------
    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                                
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'########## END of procedure  ##########';                  
    SET @v_description = N'['+ @v_exec_time + ']';             
    SET @d_event_date = SYSDATETIME()  ;  
	
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
   return 1      
END 

