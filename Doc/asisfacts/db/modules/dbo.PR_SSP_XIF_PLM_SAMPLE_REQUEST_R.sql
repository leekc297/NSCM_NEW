
/***************************************************************************************************
 * Program ID   : PR_SSP_XIF_PLM_SAMPLE_REQUEST_R 
 * Description  : PLM 소형 샘플 출하 품의 진행 상태 수신
 * OutTable     : XIF_PLM_SAMPLE_REQUEST_R (I/F Table)
 * Execute      : EXEC PR_SSP_XIF_PLM_SAMPLE_REQUEST_R
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20210801     SSP Pjt.       Create.
 *
****************************************************************************************************/
 
CREATE PROCEDURE [dbo].[PR_SSP_XIF_PLM_SAMPLE_REQUEST_R]
     @IF_ID                     NVARCHAR(50)
    ,@O_ERRFLAG                 NVARCHAR(50)  OUTPUT
    ,@O_ERRDESC                 NVARCHAR(200) OUTPUT
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

	-- LOG 용 변수 설정  
    DECLARE @v_batch_user			NVARCHAR(150) = N'ssp_batch'; 
    DECLARE @v_program_name			NVARCHAR(150) = N'PR_SSP_XIF_PLM_SAMPLE_REQUEST_R';  
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...  
    DECLARE @n_log_count			INTEGER = 0;  
    DECLARE @v_log_message			NVARCHAR(1000);  
    DECLARE @v_description			NVARCHAR(500);      --상세설명   
    DECLARE @v_table_id				NVARCHAR(150) = N'XIF_PLM_SAMPLE_REQUEST_R'; --테이블 필수  
    DECLARE @d_event_date			DATETIME;  
    DECLARE @v_insert_cnt			INTEGER = 0; 
	DECLARE @v_insert_sum			INTEGER = 0; 

	DECLARE @TAB_XIF_PLM_SAMPLE_REQUEST_R TABLE
    (
	    TID								INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        IF_SEQ							nvarchar(50),
		CONFIRM_ID						nvarchar(50),
        PLM_REQ_NO						nvarchar(50),
        PLM_REQ_STATUS					nvarchar(50),
        QMS_OQC_REQ_ID					nvarchar(50),
        QMS_OQC_INSP_ID					nvarchar(50),
        QMS_OQC_INSP_RESULT				nvarchar(50)
    );

	DECLARE @INX		INT	= 0;
    DECLARE @MAX_NUM	INT	= 0;

	-----------------------------------------------------------
	-- PREPROCESSING
	-----------------------------------------------------------
	SET @IF_ID						= 'OPLM_OSCM_SAMPLE_REQUEST';
	SET @O_ERRFLAG					= ''
	SET @O_ERRDESC					= '' 

	-----------------------------------------------------------
	-- START LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'START';  
    SET @v_log_message	= N'########## Start of procedure ##########';  
    SET @v_description	= @v_program_name + ':' + N' XIF_PLM_SAMPLE_REQUEST_R_S INSERT LOGIC';  
    SET @d_event_date	= SYSDATETIME();  

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name  
                              ,@p_log_type      = @v_log_type  
                              ,@p_log_count     = @n_log_count   
                              ,@p_log_message   = @v_log_message   
                              ,@p_description   = @v_description   
                              ,@p_event_date    = @d_event_date   
                              ,@p_user_id       = @v_batch_user  
                              ;
    
    BEGIN TRY


		/*****************************************************
		 *	        
		 *****************************************************/

		INSERT INTO @TAB_XIF_PLM_SAMPLE_REQUEST_R
		     ( IF_SEQ
			 , CONFIRM_ID          
			 , PLM_REQ_NO			
			 , PLM_REQ_STATUS		
			 , QMS_OQC_REQ_ID		
			 , QMS_OQC_INSP_ID		
			 , QMS_OQC_INSP_RESULT	
			 )
        SELECT IF_SEQ
		     , CONFIRM_ID          
			 , PLM_REQ_NO			
			 , PLM_REQ_STATUS		
			 , QMS_OQC_REQ_ID		
			 , QMS_OQC_INSP_ID		
			 , CASE WHEN QMS_OQC_INSP_RESULT = 'P' THEN 'Pass' 
			        WHEN QMS_OQC_INSP_RESULT = 'F' THEN 'Fail'
					ELSE QMS_OQC_INSP_RESULT END
	      FROM XIF_PLM_SAMPLE_REQUEST_R_SN with(nolock)
		 WHERE PROC_FLAG = 'N'
		   AND IF_ID = @IF_ID
		 ORDER BY 
		       IF_SEQ
		 ;


		SELECT @INX			= 1
			  ,@MAX_NUM		= COUNT(*)
		  FROM @TAB_XIF_PLM_SAMPLE_REQUEST_R

        DECLARE @IF_SEQ							NVARCHAR(50)
		DECLARE @CONFIRM_ID						NVARCHAR(50)
        DECLARE @PLM_REQ_NO						NVARCHAR(50)
        DECLARE @PLM_REQ_STATUS					NVARCHAR(50)
        DECLARE @QMS_OQC_REQ_ID					NVARCHAR(50)
        DECLARE @QMS_OQC_INSP_ID				NVARCHAR(50)
        DECLARE @QMS_OQC_INSP_RESULT			NVARCHAR(50)

		WHILE @INX <= @MAX_NUM
		BEGIN

		    SELECT 
				   @IF_SEQ					= IF_SEQ				
				  ,@CONFIRM_ID				= CONFIRM_ID			
				  ,@PLM_REQ_NO				= PLM_REQ_NO			
				  ,@PLM_REQ_STATUS			= PLM_REQ_STATUS		
				  ,@QMS_OQC_REQ_ID			= QMS_OQC_REQ_ID		
				  ,@QMS_OQC_INSP_ID			= QMS_OQC_INSP_ID	
				  ,@QMS_OQC_INSP_RESULT		= QMS_OQC_INSP_RESULT
			  FROM @TAB_XIF_PLM_SAMPLE_REQUEST_R 
			 WHERE TID						= @INX

			UPDATE C
			   SET ATTRIBUTE2				= @PLM_REQ_NO
				 , ATTRIBUTE3				= @PLM_REQ_STATUS
				 , ATTRIBUTE4				= @QMS_OQC_REQ_ID
				 , ATTRIBUTE5				= @QMS_OQC_INSP_ID
				 , ATTRIBUTE6				= @QMS_OQC_INSP_RESULT
			  FROM SSP_ANL_SHIP_CONFIRM AS C WITH(NOLOCK)
			 WHERE C.CONFIRM_ID				= @CONFIRM_ID
				 ;

			SET @INX = @INX + 1

		END


        UPDATE X
		   SET PROC_FLAG = 'Y'
		  FROM XIF_PLM_SAMPLE_REQUEST_R_SN AS X WITH(NOLOCK)
		       JOIN @TAB_XIF_PLM_SAMPLE_REQUEST_R AS T
			ON X.IF_SEQ = T.IF_SEQ
			;

		SET @v_insert_cnt = @@ROWCOUNT;
		SET @v_insert_sum = @v_insert_sum + @v_insert_cnt;


 		-----------------------------------------------------------
		-- TXN LOG
		-----------------------------------------------------------
		SET @v_log_type		= N'TXN';    --로그타입  
		SET @n_log_count	= @v_insert_cnt; -- @@ROWCOUNT;
		SET @v_log_message	= N'INSERT INTO '+ @v_table_id;  
		SET @d_event_date	= SYSDATETIME();
		SET @v_description	= N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121)  ;
					 
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name  
								  ,@p_log_type      =@v_log_type  
								  ,@p_log_count     =@n_log_count   
								  ,@p_log_message   =@v_log_message   
								  ,@p_description   =@v_description   
								  ,@p_event_date    =@d_event_date   
								  ,@p_user_id       =@v_batch_user  
								  ;  
      

    END TRY

    BEGIN CATCH 
 		-----------------------------------------------------------
		-- ERROR LOG
		-----------------------------------------------------------
		SET @v_log_type		= N'ERROR';  
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));  
		SET @v_description	= N'ERROR_LINE : ' + STR(ERROR_LINE());  
		SET @d_event_date	= SYSDATETIME();  
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name  
								  ,@p_log_type      =@v_log_type  
								  ,@p_log_count     =@n_log_count   
								  ,@p_log_message   =@v_log_message   
								  ,@p_description   =@v_description   
								  ,@p_event_date    =@d_event_date   
								  ,@p_user_id       =@v_batch_user  
								  ;  

    END CATCH;

	-- Interface History Data Deleting
    DELETE FROM dbo.XIF_PLM_SAMPLE_REQUEST_R_SN
	 WHERE IF_RCV_DATE < convert(datetime, convert(varchar, getdate(), 112)) - 30
	   AND PROC_FLAG = 'Y'

 	-----------------------------------------------------------
	-- END LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'END';  
    SET @v_log_message	= N'########## END of procedure ##########';  
    SET @v_description	= N'';  
    SET @d_event_date	= SYSDATETIME();  
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name  
							  ,@p_log_type      =@v_log_type  
							  ,@p_log_count     =@v_insert_sum   
							  ,@p_log_message   =@v_log_message   
							  ,@p_description   =@v_description   
							  ,@p_event_date    =@d_event_date   
							  ,@p_user_id       =@v_batch_user  
							  ;  

END;
