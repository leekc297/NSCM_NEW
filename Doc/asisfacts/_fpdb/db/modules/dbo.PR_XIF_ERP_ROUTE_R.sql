
CREATE PROCEDURE [dbo].[PR_XIF_ERP_ROUTE_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_ERP_ROUTE_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_ROUTE_R
-- Destination Table   : SCM_ITEM_LINE_ASSIGN_ERP
--
-- Create(Update) Date : 2022.03.28
-- Author              : 김 석
-- Version             : 1.0 2016.08.16 최초 형성
--                       1.1 2022.03.28 kimcd 가상 Division 사용에 따른 수정
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_ROUTE_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME    = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @COMPANY          NVARCHAR(1000)
	DECLARE @DIVISION         NVARCHAR(1000)
	DECLARE @SITE_ID          NVARCHAR(1000)
	DECLARE @ITEM_ID          NVARCHAR(1000)
	DECLARE @PLANT_ID         NVARCHAR(1000)
	DECLARE @PROD_VERSION     NVARCHAR(1000)
	DECLARE @EFF_START_DATE   NVARCHAR(1000)
	DECLARE @EFF_END_DATE     NVARCHAR(1000)
	DECLARE @WORK_CENTER_ID   NVARCHAR(1000)
	DECLARE @LINE_CODE        NVARCHAR(1000)
	DECLARE @OPERATION        NVARCHAR(1000)
	DECLARE @PRIORITY         NVARCHAR(1000)
	DECLARE @VALID_YN         NVARCHAR(1000)
	DECLARE @BOM_VERSION      NVARCHAR(1000)



	DECLARE CUR_ERP_ROUTE CURSOR FOR
		SELECT COMPANY
					,ISNULL(PD.PSEUDO_DIVISION_ID, X.[DIVISION]) AS DIVISION   -- 2022-03-24 kimcd 가상 Division 로직 추가
					,SITE_ID
					,ITEM_ID
					,X.PLANT_ID
					,PROD_VERSION
					,EFF_START_DATE
					,EFF_END_DATE
					,WORK_CENTER_ID
					,LINE_CODE
					,OPERATION
					,PRIORITY
					,ISNULL(VALID_YN, 'Y') AS VALID_YN
					,BOM_VERSION
		  FROM [dbo].[SY_XIF_ERP_ROUTE_R] X WITH(NOLOCK)
		  		LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-24 kimcd 가상 Division 로직 추가
					ON PD.PLANT_ID = X.PLANT_ID
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
		
		 UPDATE [dbo].[SY_XIF_ERP_ROUTE_R]
			SET TRANSFER_FLAG = 'P'
			   ,TRANSFER_DATE = getdate()
		  WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'
		  AND   WORK_CENTER_ID IS NOT NULL
		  
  
		  -- PARTNO 정보 추가
		  OPEN CUR_ERP_ROUTE;
		  FETCH NEXT FROM CUR_ERP_ROUTE INTO   @COMPANY       
																					,@DIVISION      
																					,@SITE_ID       
																					,@ITEM_ID       
																					,@PLANT_ID      
																					,@PROD_VERSION  
																					,@EFF_START_DATE
																					,@EFF_END_DATE  
																					,@WORK_CENTER_ID
																					,@LINE_CODE     
																					,@OPERATION     
																					,@PRIORITY      
																					,@VALID_YN      
																					,@BOM_VERSION   
																					 ;             
		
		  WHILE (@@FETCH_STATUS = 0)
		  BEGIN
					MERGE INTO [LGCE_FPDEV_TR].[dbo].[SCM_ITEM_LINE_ASSIGN_ERP] SILM
					USING ( SELECT @COMPANY         AS COMPANY_ID
					              ,@DIVISION        AS DIVISION_ID
					              ,@SITE_ID         AS SITE_ID
					              ,@PLANT_ID        AS PLANT_ID
					              ,@ITEM_ID         AS ITEM_ID
					              ,@PROD_VERSION    AS PROD_VERSION					              
					              ,@BOM_VERSION     AS BOM_VERSION  
								  ,@WORK_CENTER_ID  AS WORK_CENTER_ID 
						  ) XXX
					ON (      
					          SILM.COMPANY_ID       =  XXX.COMPANY_ID
					      AND SILM.DIVISION_ID      =  XXX.DIVISION_ID
					      AND SILM.SITE_ID          =  XXX.SITE_ID
					      AND SILM.PLANT_ID         =  XXX.PLANT_ID
					      AND SILM.ITEM_ID          =  XXX.ITEM_ID						  
					      AND SILM.PROD_VERSION     =  XXX.PROD_VERSION
						  AND SILM.BOM_VERSION      =  XXX.BOM_VERSION
						  AND SILM.WORK_CENTER_ID   =  XXX.WORK_CENTER_ID
					   )
					WHEN MATCHED THEN
						UPDATE SET SILM.COMPANY_ID    =  @COMPANY 
											,SILM.DIVISION_ID   =  @DIVISION   
											,SILM.PRIORITY      =  @PRIORITY   
											,SILM.START_TIME    =  @EFF_START_DATE
											,SILM.END_TIME      =  @EFF_END_DATE          
											,SILM.ACTIVE_FLAG   =  @VALID_YN                     
											,SILM.UPDATE_ID     =  @v_proc_name      
											,SILM.UPDATE_TIME   =  GETDATE()
					                
					WHEN NOT MATCHED THEN
						INSERT (   COMPANY_ID
											,DIVISION_ID
											,SITE_ID
											,PLANT_ID
											,FACTORY_ID
											--,SHOP_ID
											,ITEM_ID
											,OPERATION_ID
											,PROD_VERSION
											,BOM_VERSION
											,LINE_ID
											,WORK_CENTER_ID
											,PRIORITY
											,START_TIME
											,END_TIME              
											,DESCR              
											,ACTIVE_FLAG              
											,INSERT_ID              
											,INSERT_TIME              
											,UPDATE_ID              
											,UPDATE_TIME       
							   )
						VALUES (   @COMPANY
								    	,@DIVISION
										,@SITE_ID
										,@PLANT_ID
									    ,substring(@WORK_CENTER_ID,1,2)
											--,substring(@WORK_CENTER_ID,1,1)
											,@ITEM_ID     
											,substring(@WORK_CENTER_ID,7,2)
											,@PROD_VERSION  
											,@BOM_VERSION  
											,substring(@WORK_CENTER_ID,1,4)
											,@WORK_CENTER_ID
											,@PRIORITY   
											,@EFF_START_DATE
											,@EFF_END_DATE                     
											,NULL              
											,@VALID_YN       
									,@v_proc_name
									,GETDATE()
									,@v_proc_name
									,GETDATE()
							   );  	
					  FETCH NEXT FROM CUR_ERP_ROUTE INTO   @COMPANY       
																					,@DIVISION      
																					,@SITE_ID       
																					,@ITEM_ID       
																					,@PLANT_ID      
																					,@PROD_VERSION  
																					,@EFF_START_DATE
																					,@EFF_END_DATE  
																					,@WORK_CENTER_ID
																					,@LINE_CODE     
																					,@OPERATION     
																					,@PRIORITY      
																					,@VALID_YN      
																					,@BOM_VERSION   
																					 ;             

		  END;
		  CLOSE CUR_ERP_ROUTE;
		  DEALLOCATE CUR_ERP_ROUTE;      	  

		 UPDATE [dbo].[SY_XIF_ERP_ROUTE_R]
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


