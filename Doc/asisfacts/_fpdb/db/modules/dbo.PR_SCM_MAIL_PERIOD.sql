-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_MAIL_PERIOD
-- Param               :
-- Batch Period        : realtime
-- Description         :
--
-- Source 
-- Destina
-- Source 
-- Destina
--
-- Create(Update) Date : 2017.02.14
-- Author              : 
-- Version             : 1.1   Initial Creation

-- =============================================================================
CREATE PROCEDURE [dbo].[PR_SCM_MAIL_PERIOD]
AS
--------------------------------------------------------------------------------
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_MAIL_PERIOD'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @MAIL_CONTENTS_COUNT    NVARCHAR(4000)	

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

		DECLARE @MAIL_PKEY             NVARCHAR(100)
		DECLARE @MAIL_DESCRIPTION      NVARCHAR(500)
		DECLARE @MAIL_SUBJECT          NVARCHAR(500)
		DECLARE @MAIL_BODY             NVARCHAR(4000)
		DECLARE @MAIL_CHECK_QUERY      NVARCHAR(4000)
		DECLARE @MAIL_QUERY            NVARCHAR(4000)
		DECLARE @ATTACH_FILE_NAME      NVARCHAR(4000)
		DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(4000)
		DECLARE @MAIL_ERR_INTERVAL     NVARCHAR(500)	
		DECLARE @MAIL_INTERVAL_PERIOD  NVARCHAR(500)
		DECLARE @MAIL_INTERVAL_TIME    NVARCHAR(500)
		DECLARE @MAIL_INTERVAL_DAYOFWK  NVARCHAR(500)
		DECLARE @MAIL_QUERY2           NVARCHAR(4000)		
		DECLARE @vTBL_COUNTS           INTEGER
		DECLARE @ROWCOUNT              INTEGER
		DECLARE @SQL                   NVARCHAR(4000)	
		
		DECLARE @vTBL_MAIL_CONTENTS TABLE
		(
			vMAIL_CONTENTS    NVARCHAR(4000)	
		)

    --CURSOR 메일링대상정보
    DECLARE CUR_MAIL CURSOR FOR
    SELECT   [MAIL_PKEY]
			,[MAIL_DESCRIPTION]
			,[MAIL_SUBJECT]
			,[MAIL_BODY]
			,[MAIL_CHECK_QUERY]
			,[MAIL_QUERY]
			,[ATTACH_FILE_NAME]
			,[MAIL_RECEIVER_LIST]
			,[MAIL_ERROR_INTERVAL]
			,[MAIL_INTERVAL_PERIOD]
			,[MAIL_INTERVAL_TIME]
			,[MAIL_INTERVAL_DAYOFWK]
    FROM   [SCM_MAILING_LIST_M] AS CMLN
    WHERE  ISNULL(CMLN.MAIL_DATETIME,GETDATE()) <= GETDATE()
      AND  ISNULL(VALID_YN,'Y') = 'Y'
    ;
	   ----------------------------------------------------------------------------
	   
	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate
	   
	   BEGIN TRY
		      BEGIN TRANSACTION;
		      ------------------------------------------------------------------------
		      OPEN CUR_MAIL;
        FETCH NEXT FROM CUR_MAIL
		            INTO  @MAIL_PKEY          
						 ,@MAIL_DESCRIPTION   
						 ,@MAIL_SUBJECT       
						 ,@MAIL_BODY         
						 ,@MAIL_CHECK_QUERY 
						 ,@MAIL_QUERY         
						 ,@ATTACH_FILE_NAME   
						 ,@MAIL_RECEIVER_LIST 
						 ,@MAIL_ERR_INTERVAL
						 ,@MAIL_INTERVAL_PERIOD
						 ,@MAIL_INTERVAL_TIME     
						 ,@MAIL_INTERVAL_DAYOFWK 
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
		         

			INSERT INTO @vTBL_MAIL_CONTENTS           
		    EXEC sp_executesql @MAIL_CHECK_QUERY;
			

			SELECT TOP 1
                  @MAIL_CONTENTS_COUNT = vMAIL_CONTENTS
              FROM   @vTBL_MAIL_CONTENTS;

			  SELECT @MAIL_CONTENTS_COUNT
		    --------------------------------------------------------------------
            IF ( upper( ISNULL(@MAIL_CONTENTS_COUNT,'FALSE') ) = 'TRUE' ) -- Mailing 필요시
				BEGIN
					INSERT
					INTO    dbo.SCM_MAILING_H
						  (  [MAIL_PKEY]
							,[MAIL_SEQ]
							,[MAIL_DATETIME]
							,[MAIL_SUBJECT]
							,[MAIL_BODY]
							,[MAIL_QUERY]
							,[ATTACH_FILE_NAME]
							,[MAIL_RECEIVER_LIST]
							,[MAIL_PROFILE_NAME]
							,[MAIL_SEND_FLAG]
							,[MESSAGE]
							,[CREATE_USER_ID]
							,[CREATE_DATE]
							,[MODIFY_USER_ID]
							,[MODIFY_DATE]
						  )
					VALUES( @MAIL_PKEY     
						   , NEXT VALUE FOR SEQ_SCM_MAIL
						   ,NULL     
						   ,@MAIL_SUBJECT       
						   ,@MAIL_BODY
						   ,@MAIL_QUERY         
						   ,@ATTACH_FILE_NAME   
						   ,@MAIL_RECEIVER_LIST 
						   ,'FP_MAIL_TEST'
						   ,'N'
						   ,NULL  
						   ,@v_proc_name
						   ,getdate()
						   ,@v_proc_name
						   ,getdate()
						  );

	  			  SELECT 'INSERT SCM_MAILING_H' AS LOG
			--------------------------------------------------------------------
				--다음 메일 발송 일시 Setting
				SET @SQL = 'UPDATE SCM_MAILING_LIST_M ' + CHAR(10) +
						   'SET    MAIL_DATETIME     = ' + CASE WHEN @MAIL_ERR_INTERVAL IS NOT NULL THEN
																	 'DATEADD(MI,'+ @MAIL_ERR_INTERVAL+',GETDATE()) '
																ELSE 'DATEADD(MM,360,GETDATE()) ' -- 30분 단위 Default
														   END + CHAR(10) +
						   '     , MODIFY_USER_ID    = ''' + @v_proc_name + '''' + CHAR(10) +
						   '     , MODIFY_DATE       = GETDATE() ' + CHAR(10) +
						   'WHERE  MAIL_PKEY         = ''' + @MAIL_PKEY + '''';


				EXEC sp_executesql @SQL;
  			  SELECT 'SEND MAIL' AS LOG, @MAIL_PKEY
          	--------------------------------------------------------------------
				END
            ELSE         -- Mailing 불필요시
			    BEGIN
			--------------------------------------------------------------------
				--다음 메일 발송 일시 Setting
				SET @SQL = 'UPDATE SCM_MAILING_LIST_M ' + CHAR(10) +
						   'SET    MAIL_DATETIME     = ' + CASE WHEN @MAIL_INTERVAL_PERIOD = 'DAILY'   THEN 'DATEADD(HH, '+@MAIL_INTERVAL_TIME +'/*시간*/,  Dateadd( D, 1, DATEADD(D, DATEDIFF(D,0,GETDATE()), 0 /*요일 0:월요일 1:화요일*/) ) ) '
						                                        WHEN @MAIL_INTERVAL_PERIOD = 'WEEKLY'  THEN 'DATEADD(HH, '+@MAIL_INTERVAL_TIME +'/*시간*/,  Dateadd( D, 7, DATEADD(wk, DATEDIFF(wk,0,GETDATE()), '+@MAIL_INTERVAL_DAYOFWK+' /*요일 0:월요일 1:화요일*/) ) ) '
																WHEN @MAIL_INTERVAL_PERIOD = 'MINUTE'  THEN 'DATEADD(MI,'+ @MAIL_INTERVAL_TIME+',GETDATE()) '
															--	WHEN @MAIL_INTERVAL_PERIOD = 'MONTHLY' THEN 'DATEADD(MM,360,GETDATE()) '
																ELSE  'DATEADD(MM,360,GETDATE()) ' -- 6시간 단위 Default
														   END + CHAR(10) +
						   '     , MODIFY_USER_ID    = ''' + @v_proc_name + '''' + CHAR(10) +
						   '     , MODIFY_DATE       = GETDATE() ' + CHAR(10) +
						   'WHERE  MAIL_PKEY         = ''' + @MAIL_PKEY + '''';
				

				EXEC sp_executesql @SQL;


          	--------------------------------------------------------------------			    
			   END 

			DELETE FROM @vTBL_MAIL_CONTENTS;

            FETCH NEXT FROM CUR_MAIL
		                INTO  @MAIL_PKEY          
							 ,@MAIL_DESCRIPTION   
							 ,@MAIL_SUBJECT       
							 ,@MAIL_BODY         
							 ,@MAIL_CHECK_QUERY 
							 ,@MAIL_QUERY         
							 ,@ATTACH_FILE_NAME   
							 ,@MAIL_RECEIVER_LIST 
							 ,@MAIL_ERR_INTERVAL
							 ,@MAIL_INTERVAL_PERIOD
							 ,@MAIL_INTERVAL_TIME      
							 ,@MAIL_INTERVAL_DAYOFWK
        END;
        CLOSE CUR_MAIL;
        DEALLOCATE CUR_MAIL;

		-- ================================================
		-- 로직 추가 end
		-- ================================================        
		    COMMIT TRAN

	 	    EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
	
   	END TRY
	   ----------------------------------------------------------------------------
			BEGIN CATCH
				CLOSE CUR_MAIL;
				DEALLOCATE CUR_MAIL;
		
			    ROLLBACK TRAN
				-- 에러나도 로그는 인서트
				SET @v_descr = ERROR_MESSAGE()

				EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	   END CATCH
	   ----------------------------------------------------------------------------
END
--******************************************************************************
--PROGRAM END
--******************************************************************************






