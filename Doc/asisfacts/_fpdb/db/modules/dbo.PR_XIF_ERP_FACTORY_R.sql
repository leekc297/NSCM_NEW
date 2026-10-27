
CREATE PROCEDURE [dbo].[PR_XIF_ERP_FACTORY_R]

-- ================================================================================================
-- Program ID          : FP00520
-- Program Name        : PR_XIF_ERP_FACTORY_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_PLANT_R
-- Destination Table   : SCM_DIVISION_M, SCM_PLANT_M, SCM_FACTORY_M
--
-- Create(Update) Date : 2022.03.24
-- Author              : 김 석
-- Version             : 1.0
--                       1.1 2022-03-24 kimcd 가상 Division 사용에 따른 수정
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_FACTORY_R'
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
	DECLARE @COMPANY         NVARCHAR(1000)
	DECLARE @DIVISION        NVARCHAR(1000)
	DECLARE @PLANT_ID        NVARCHAR(1000)
	DECLARE @PLANT_NAME      NVARCHAR(1000)
	DECLARE @DIVISION_DESC   NVARCHAR(1000)
	DECLARE @SITE_ID         NVARCHAR(1000)
	DECLARE @BUILDING        NVARCHAR(1000)
	DECLARE @BUILDING_NAME   NVARCHAR(1000)
	DECLARE @VALID           NVARCHAR(1000)

	DECLARE CUR_ERP_PLANT CURSOR FOR
		SELECT DISTINCT 
			   COMPANY
			  ,ISNULL(PD.PSEUDO_DIVISION_ID, DIVISION) AS DIVISION  -- 2022-03-24 kimcd 가상 Division 로직 추가
			  ,DIVISION_DESC
			  ,SITE_ID
			  ,X.PLANT_ID
			  ,PLANT_NAME
		  FROM [dbo].[SY_XIF_ERP_PLANT_R] X WITH(NOLOCK)
				LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-24 kimcd 가상 Division 로직 추가
					ON PD.PLANT_ID = X.PLANT_ID
		 WHERE TRANSFER_FLAG = 'P';

	DECLARE CUR_ERP_FACTORY CURSOR FOR
		SELECT COMPANY
			  ,ISNULL(PD.PSEUDO_DIVISION_ID, DIVISION) AS DIVISION  -- 2022-03-24 kimcd 가상 Division 로직 추가
			  ,SITE_ID
			  ,X.PLANT_ID
			  ,BUILDING
			  ,BUILDING_NAME
			  ,VALID_YN
		  FROM [dbo].[SY_XIF_ERP_PLANT_R] X WITH(NOLOCK)
				LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-24 kimcd 가상 Division 로직 추가
					ON PD.PLANT_ID = X.PLANT_ID
		 WHERE TRANSFER_FLAG = 'P';

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
		
		 UPDATE [dbo].[SY_XIF_ERP_PLANT_R]
			SET TRANSFER_FLAG = 'P'
			   ,TRANSFER_DATE = getdate()
		  WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'
		  
  
		  -- SITE 정보 추가
		  OPEN CUR_ERP_PLANT;
		  FETCH NEXT FROM CUR_ERP_PLANT INTO  @COMPANY
										     ,@DIVISION
											 ,@DIVISION_DESC
										     ,@SITE_ID
											 ,@PLANT_ID
										     ,@PLANT_NAME;
		  WHILE (@@FETCH_STATUS = 0)
		  BEGIN

				-- Division 정보 추가
				MERGE INTO [dbo].[SCM_DIVISION_M] A
				USING ( SELECT @COMPANY        AS COMPANY
							  ,@DIVISION       AS DIVISION
							  ,@DIVISION_DESC  AS DIVISION_DESC
						) B
				ON (    A.COMPANY_ID  = B.COMPANY
					AND A.DIVISION_ID = B.DIVISION
					)
				WHEN MATCHED THEN
					UPDATE SET A.DIVISION_NAME = B.DIVISION_DESC
							  ,A.UPDATE_ID     = @v_proc_name
							  ,A.UPDATE_TIME   = GETDATE()
					                
				WHEN NOT MATCHED THEN
					INSERT ([COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[DIVISION_NAME]
						   ,[DESCRIPTION]
						   ,[INSERT_ID]
						   ,[INSERT_TIME]
						   ,[UPDATE_ID]
						   ,[UPDATE_TIME]
							)
					VALUES ( B.COMPANY
					        ,B.DIVISION
							,B.DIVISION_DESC
							,NULL
							,@v_proc_name
							,GETDATE()
							,@v_proc_name
							,GETDATE()
							);
							
				MERGE INTO [dbo].[SCM_PLANT_M] SSM
				USING ( SELECT @COMPANY          AS COMPANY
								,@DIVISION       AS DIVISION
								,@SITE_ID        AS SITE_ID
								,@PLANT_ID       AS PLANT_ID
						) XXX
				ON (  SSM.COMPANY_ID       = XXX.COMPANY
					AND SSM.DIVISION_ID    = XXX.DIVISION
					AND SSM.SITE_ID        = XXX.SITE_ID
					AND SSM.PLANT_ID       = XXX.PLANT_ID
					)
				WHEN MATCHED THEN
					UPDATE SET           SSM.COMPANY_ID   = @COMPANY
										,SSM.DIVISION_ID  = @DIVISION
										,SSM.PLANT_NAME   = @PLANT_NAME
										,SSM.UPDATE_ID    = @v_proc_name
										,SSM.UPDATE_TIME  = GETDATE()
					                
				WHEN NOT MATCHED THEN
					INSERT ( COMPANY_ID
												,DIVISION_ID
												,SITE_ID
												,PLANT_ID
												,PLANT_NAME
												,INSERT_ID
												,INSERT_TIME
												,UPDATE_ID
												,UPDATE_TIME
							)
					VALUES ( @COMPANY
												,@DIVISION
												,@SITE_ID
												,@PLANT_ID
												,@PLANT_NAME
												,@v_proc_name
												,GETDATE()
												,@v_proc_name
												,GETDATE()
							);
														  	
					FETCH NEXT FROM CUR_ERP_PLANT INTO   @COMPANY
														,@DIVISION
														,@DIVISION_DESC
														,@SITE_ID
														,@PLANT_ID
														,@PLANT_NAME
														;
		  END;
		  CLOSE CUR_ERP_PLANT;
		  DEALLOCATE CUR_ERP_PLANT;      

		  -- FACTORY 정보 추가
		  OPEN CUR_ERP_FACTORY;
		  FETCH NEXT FROM CUR_ERP_FACTORY INTO   @COMPANY
												,@DIVISION
												,@SITE_ID
												,@PLANT_ID
												,@BUILDING
												,@BUILDING_NAME
												,@VALID
												;
		  WHILE (@@FETCH_STATUS = 0)
		  BEGIN
					MERGE INTO [dbo].[SCM_FACTORY_M] A
					USING ( SELECT @COMPANY       AS COMPANY_ID
					              ,@DIVISION      AS DIVISION_ID
								  ,@SITE_ID       AS SITE_ID
								  ,@PLANT_ID      AS PLANT_ID
					              ,@BUILDING      AS FACTORY_ID
								  ,@BUILDING_NAME AS FACTORY_NAME
						  ) B
					 ON A.COMPANY_ID  = B.COMPANY_ID
					  --   AND A.DIVISION_ID = B.DIVISION_ID
						 --AND A.SITE_ID     = B.SITE_ID
						 --AND A.PLANT_ID    = B.PLANT_ID
				    AND A.FACTORY_ID  = B.FACTORY_ID
					   
					WHEN MATCHED THEN
						UPDATE SET A.FACTORY_NAME   = B.FACTORY_NAME
						          ,A.DIVISION_ID    = B.DIVISION_ID
								  ,A.SITE_ID        = B.SITE_ID
								  ,A.PLANT_ID       = B.PLANT_ID
								  ,A.UPDATE_ID      = @v_proc_name
								  ,A.UPDATE_TIME    = GETDATE()
					                
					WHEN NOT MATCHED THEN
						INSERT ( COMPANY_ID
								,DIVISION_ID
								,SITE_ID
								,PLANT_ID
								,FACTORY_ID
								,FACTORY_NAME
								,INSERT_ID
								,INSERT_TIME
								,UPDATE_ID
								,UPDATE_TIME
							   )
						VALUES ( B.COMPANY_ID
								,B.DIVISION_ID
								,B.SITE_ID
								,B.PLANT_ID
								,B.FACTORY_ID
								,B.FACTORY_NAME
								,@v_proc_name
								,GETDATE()
								,@v_proc_name
								,GETDATE()
							   ); 
					  FETCH NEXT FROM CUR_ERP_FACTORY INTO   @COMPANY
											              	,@DIVISION
											            	,@SITE_ID
											            	,@PLANT_ID
											            	,@BUILDING
												            ,@BUILDING_NAME
											            	,@VALID
															; 
		  END;
		  CLOSE CUR_ERP_FACTORY;
		  DEALLOCATE CUR_ERP_FACTORY;         	  

		 UPDATE [dbo].[SY_XIF_ERP_PLANT_R]
			SET TRANSFER_FLAG = 'Y'
			   ,TRANSFER_DATE = GETDATE()
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


