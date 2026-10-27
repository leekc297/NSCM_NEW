
CREATE PROCEDURE [dbo].[PR_XIF_MES_CELL_SHIPMENT_R]

-- ================================================================================================
-- Program ID          : FP00977
-- Program Name        : PR_XIF_MES_CELL_SHIPMENT_R
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_CELL_SHIPMENT_R
-- Destination Table   : FP_MES_CELL_SHIPMENT_H
--
-- Create(Update) Date : 2020.01.06
-- Author              : PIYONG
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_CELL_SHIPMENT_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @IF_ID			NVARCHAR(50)
	DECLARE @ACCUM_DATE     NVARCHAR(8)

	DECLARE SHIP_CUR CURSOR FOR
		SELECT IF_ID, ACCUM_DATE
		  FROM [SY_XIF_MES_CELL_SHIPMENT_R]
		 WHERE PROC_FLAG = 'N'
		   AND SHIPMENT_ID != 'NO_CELL_SHIPMENT'
		 GROUP BY IF_ID
			   , ACCUM_DATE
		HAVING COUNT(*) = MAX(ACCUM_COUNT)
		 ORDER BY IF_ID, ACCUM_DATE


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			OPEN SHIP_CUR
			FETCH NEXT FROM SHIP_CUR INTO @IF_ID
										  ,@ACCUM_DATE
		    ;

			WHILE (@@FETCH_STATUS = 0)			
				BEGIN
					UPDATE [SY_XIF_MES_CELL_SHIPMENT_R]
					  SET PROC_FLAG = 'P'
					WHERE PROC_FLAG = 'N'
					  AND IF_ID			= @IF_ID
					  AND ACCUM_DATE	= @ACCUM_DATE


					MERGE INTO FP_MES_CELL_SHIPMENT_H A				--  SHIPMENT_ID 기준으로 MERGE
					USING (
							SELECT ISNULL(D.[COMPANY_ID], F.COMPANY_ID) AS COMPANY_ID
								   ,ISNULL(D.[DIVISION_ID], F.[DIVISION_ID] ) AS [DIVISION_ID]
								   ,ISNULL(D.[SITE_ID], F.[SITE_ID] ) AS [SITE_ID]
								   ,ISNULL(D.[PLANT_ID], F.[PLANT_ID] ) AS [PLANT_ID]
								   ,ISNULL(D.[FACTORY_ID], F.[FACTORY_ID] ) AS [FACTORY_ID]
   								   ,C.[OPERATOR_ID]
								   ,C.[SHIPMENT_ID]
								   ,C.[SHIPPING_STATUS]
								   ,C.[ITEM_ID]
								   ,C.[QTY]
								   ,C.[PLT_QTY]
								   ,C.[SHIPPING_DESTINATION]
								   ,C.[SHIPMENT_DATE]
								   ,C.[SHIP_SLOC]
								   ,C.[RECEIVE_SLOC]
								   ,C.ATTRIBUTE1 AS PALLET_ID
							  FROM [SY_XIF_MES_CELL_SHIPMENT_R] C
								   LEFT OUTER JOIN [SCM_MMD_LINE_M] D				--SCM_MMD_LINE_M  JOIN
												 ON C.LINE_ID = D.LINE_ID
								   LEFT OUTER JOIN SCM_FACTORY_M F
												 ON C.ATTRIBUTE3 = F.FACTORY_ID
							 WHERE PROC_FLAG	= 'P'
							   AND IF_ID		= @IF_ID
							   AND ACCUM_DATE	= @ACCUM_DATE 
		  					   AND SHIPMENT_ID  != 'NO_CELL_SHIPMENT'
						  ) B
					   ON (
							A.[SHIPMENT_ID]		= B.[SHIPMENT_ID]
							AND A.[PALLET_ID]	= B.[PALLET_ID]
						  )
					 WHEN MATCHED THEN
						UPDATE 
						   SET [COMPANY_ID]			= B.[COMPANY_ID]
							,A.[DIVISION_ID]		= B.[DIVISION_ID]
							,A.[SITE_ID]			= B.[SITE_ID]
							,A.[PLANT_ID]			= B.[PLANT_ID]
							,A.[FACTORY_ID]			= B.[FACTORY_ID]
							,A.[SHIPPING_STATUS]	= B.[SHIPPING_STATUS]
							,A.[ITEM_ID]			= B.[ITEM_ID]
							,A.[QTY]				= B.[QTY]
							,A.[PLT_QTY]			= B.[PLT_QTY]
							,A.[SHIPTO_ID]			= B.[SHIPPING_DESTINATION]
							,A.[SHIPMENT_DATE]		= B.[SHIPMENT_DATE]
							,A.[SHIP_SLOC]			= B.[SHIP_SLOC]
							,A.[RECEIVE_SLOC]		= B.[RECEIVE_SLOC]
							,A.[OPERATOR_ID]		= B.[OPERATOR_ID]
							,A.[UPDATE_ID]			= 'PR_XIF_MES_CELL_SHIPMENT_R'
							,A.[UPDATE_TIME]		= GETDATE()
					 WHEN NOT MATCHED THEN
						INSERT (
							[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[SHIPMENT_ID]
							,[PALLET_ID]
							,[SHIPPING_STATUS]
							,[ITEM_ID]
							,[QTY]
							,[PLT_QTY]
							,[SHIPTO_ID]
							,[SHIPMENT_DATE]
							,[SHIP_SLOC]
							,[RECEIVE_SLOC]
							,[OPERATOR_ID]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
						) VALUES (
							B.[COMPANY_ID]
							,B.[DIVISION_ID]
							,B.[SITE_ID]
							,B.[PLANT_ID]
							,B.[FACTORY_ID]
							,B.[SHIPMENT_ID]
							,B.[PALLET_ID]
							,B.[SHIPPING_STATUS]
							,B.[ITEM_ID]
							,B.[QTY]
							,B.[PLT_QTY]
							,B.[SHIPPING_DESTINATION]
							,B.[SHIPMENT_DATE]
							,B.[SHIP_SLOC]
							,B.[RECEIVE_SLOC]
							,B.[OPERATOR_ID]
							,'PR_XIF_MES_CELL_SHIPMENT_R'
							,GETDATE()
							,'PR_XIF_MES_CELL_SHIPMENT_R'
							,GETDATE()
						)
					;


					UPDATE [SY_XIF_MES_CELL_SHIPMENT_R]
					  SET PROC_FLAG = 'Y'
					WHERE PROC_FLAG = 'P'
					  AND IF_ID			= @IF_ID
					  AND ACCUM_DATE	= @ACCUM_DATE


					FETCH NEXT FROM SHIP_CUR INTO @IF_ID
												  ,@ACCUM_DATE
					;
				END

			CLOSE SHIP_CUR;
			DEALLOCATE SHIP_CUR;


			UPDATE [SY_XIF_MES_CELL_SHIPMENT_R]
			   SET PROC_FLAG	= 'Y'
			 WHERE PROC_FLAG	= 'N'
			   AND SHIPMENT_ID	= 'NO_CELL_SHIPMENT'

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



