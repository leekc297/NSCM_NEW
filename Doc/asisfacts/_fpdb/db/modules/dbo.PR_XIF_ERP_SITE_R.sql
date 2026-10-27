
CREATE PROCEDURE [dbo].[PR_XIF_ERP_SITE_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_ERP_SITE_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_SITE_R
-- Destination Table   : SCM_SITE_M, SCM_COMPANY_M
--
-- Create(Update) Date : 2016.08.16
-- Author              : 김 석
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_SITE_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @COMPANY_ID   NVARCHAR(1000)
	DECLARE @COMPANY_NAME NVARCHAR(1000)
	DECLARE @SITE_ID      NVARCHAR(1000)
	DECLARE @SITE_NAME    NVARCHAR(1000)
	DECLARE @COUNTRY_ID   NVARCHAR(1000)
	DECLARE @VALID_YN     NVARCHAR(1000)


	DECLARE CUR_ERP_SITE CURSOR FOR
		SELECT COMPANY AS COMPANY_ID
		      ,COMPANY_NAME
		      ,SITE_ID
		      ,SITE_NAME
		      ,COUNTRY AS COUNTRY_ID
		      ,VALID_YN
		  FROM [dbo].[SY_XIF_ERP_SITE_R] X WITH(NOLOCK)
		 WHERE TRANSFER_FLAG = 'P'
		;

	SET @ROWCOUNT = @@ROWCOUNT

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
		
		 UPDATE [dbo].[SY_XIF_ERP_SITE_R]
			SET TRANSFER_FLAG = 'P'
			   ,TRANSFER_DATE = getdate()
		  WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'
		  
  
		  -- PARTNO 정보 추가
		  OPEN CUR_ERP_SITE;
		  FETCH NEXT FROM CUR_ERP_SITE INTO  @COMPANY_ID       
											,@COMPANY_NAME       
											,@SITE_ID       
											,@SITE_NAME       
											,@COUNTRY_ID      
											,@VALID_YN
											;             

		  WHILE (@@FETCH_STATUS = 0)
		  BEGIN
					MERGE INTO [dbo].[SCM_SITE_M] SSM
					USING ( SELECT @SITE_ID AS SITE_ID
						  ) XXX
					ON (      SSM.SITE_ID = XXX.SITE_ID
					      and SSM.COMPANY_ID = @COMPANY_ID 
					   )
					WHEN MATCHED THEN
						UPDATE SET   SSM.SITE_NAME     =  @SITE_NAME   
									,SSM.COUNTRY_ID    =  @COUNTRY_ID         
									,SSM.UPDATE_ID     =  @v_proc_name      
									,SSM.UPDATE_TIME   =  GETDATE()
					                
					WHEN NOT MATCHED THEN
						INSERT (     COMPANY_ID
								    ,COUNTRY_ID
									,SITE_ID
									,SITE_NAME
									,INSERT_ID
									,INSERT_TIME
									,UPDATE_ID
									,UPDATE_TIME
							   )
						VALUES (     @COMPANY_ID 
						            ,@COUNTRY_ID
						            ,@SITE_ID
						            ,@SITE_NAME     
									,@v_proc_name
									,GETDATE()
									,@v_proc_name
									,GETDATE()
							   );
							   
					MERGE INTO [dbo].[SCM_COMPANY_M] SSM
					USING ( SELECT @COMPANY_ID AS COMPANY_ID
						  ) XXX
					ON (      SSM.COMPANY_ID = XXX.COMPANY_ID
					   )
					WHEN MATCHED THEN
						UPDATE SET   SSM.COMPANY_NAME  =  @COMPANY_NAME   
									,SSM.UPDATE_ID     =  @v_proc_name      
									,SSM.UPDATE_TIME   =  GETDATE()
					                
					WHEN NOT MATCHED THEN
						INSERT (     COMPANY_ID
								    ,COMPANY_NAME
									,INSERT_ID
									,INSERT_TIME
									,UPDATE_ID
									,UPDATE_TIME
							   )
						VALUES (     @COMPANY_ID 
						            ,@COMPANY_NAME  
									,@v_proc_name
									,GETDATE()
									,@v_proc_name
									,GETDATE()
							   );							   
					  FETCH NEXT FROM CUR_ERP_SITE INTO  @COMPANY_ID       
														,@COMPANY_NAME       
														,@SITE_ID       
														,@SITE_NAME       
														,@COUNTRY_ID      
														,@VALID_YN
														;           

		  END;
		  CLOSE CUR_ERP_SITE;
		  DEALLOCATE CUR_ERP_SITE;      	  

		 UPDATE [dbo].[SY_XIF_ERP_SITE_R]
			SET TRANSFER_FLAG = 'Y'
			   ,TRANSFER_DATE = getdate()
		  WHERE TRANSFER_FLAG = 'P'  


		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



