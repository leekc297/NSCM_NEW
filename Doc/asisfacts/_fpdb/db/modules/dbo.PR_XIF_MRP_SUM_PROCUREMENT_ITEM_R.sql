
CREATE PROCEDURE [dbo].[PR_XIF_MRP_SUM_PROCUREMENT_ITEM_R]

-- ================================================================================================
-- Program ID          : FP00224
-- Program Name        : PR_XIF_MRP_SUM_PROCUREMENT_ITEM_R
-- Param               :
-- Batch Period        : 30분 단위
-- Description         :
--
-- Source System       : MRP
-- Destination System  : FP SDB
-- Source Table        : XIF_MRP_SUM_PROCUREMENT_ITEM_R
-- Destination Table   : FP_MRP_SUM_PROCURE_ITEM_M
--
-- Create(Update) Date : 2021.05.07

-- Author              : 김 춘 동
-- Version             : 1.0 2021-05-07 초기 형성
-- ================================================================================================
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MRP_SUM_PROCUREMENT_ITEM_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @PLANT_ID        NVARCHAR(30)
	DECLARE @ITEM_ID         NVARCHAR(50)
	DECLARE @OTHER_PLANT_ID  NVARCHAR(30)
	DECLARE @ACTIVE_FLAG     NVARCHAR(1)

	DECLARE CUR_SUM_PRPC CURSOR FOR
		SELECT SPI.PLANT_ID
			  ,SPI.ITEM_ID
			  ,SPI.OTHER_PLANT_ID
			  ,SPI.ACTIVE_FLAG
		FROM   SY_XIF_MRP_SUM_PROCUREMENT_ITEM_R  SPI (NOLOCK)
		WHERE  SPI.PROC_FLAG = 'P';

	SET @ROWCOUNT = @@ROWCOUNT

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- ================================================
		-- 로직 추가 start
		-- ================================================
		 UPDATE [dbo].[SY_XIF_MRP_SUM_PROCUREMENT_ITEM_R]
			SET PROC_FLAG = 'P'
			   ,PROC_DATE = GETDATE()
		  WHERE ISNULL(PROC_FLAG,'N') = 'N'

		  OPEN CUR_SUM_PRPC;
		  FETCH NEXT FROM CUR_SUM_PRPC INTO  @PLANT_ID
											,@ITEM_ID
											,@OTHER_PLANT_ID
											,@ACTIVE_FLAG;
		  WHILE (@@FETCH_STATUS = 0)
		  BEGIN
				MERGE INTO [dbo].[FP_MRP_SUM_PROCURE_ITEM_M] SPI
				USING ( SELECT   @PLANT_ID         AS PLANT_ID
								,@ITEM_ID          AS ITEM_ID
								,@OTHER_PLANT_ID   AS OTHER_PLANT_ID
								,@ACTIVE_FLAG      AS ACTIVE_FLAG
              			) XXX
				ON ( 	SPI.[PLANT_ID]       = XXX.[PLANT_ID]
					AND	SPI.[ITEM_ID]        = XXX.[ITEM_ID]
					AND	SPI.[OTHER_PLANT_ID] = XXX.[OTHER_PLANT_ID]
				)
				WHEN MATCHED THEN
					UPDATE SET ACTIVE_FLAG     = XXX.ACTIVE_FLAG
              				  ,UPDATE_ID       = @v_proc_name
              				  ,UPDATE_TIME     = GETDATE()     
				WHEN NOT MATCHED THEN
              		INSERT ( [PLANT_ID]
							,[ITEM_ID]
							,[OTHER_PLANT_ID]
							,[ACTIVE_FLAG]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
              				)
              		VALUES ( XXX.PLANT_ID
							,XXX.ITEM_ID
							,XXX.OTHER_PLANT_ID
							,XXX.ACTIVE_FLAG
              				,@v_proc_name         
              				,GETDATE()            
              				,@v_proc_name       
              				,GETDATE()       
              				);						   	

			  FETCH NEXT FROM CUR_SUM_PRPC INTO  @PLANT_ID
												,@ITEM_ID
												,@OTHER_PLANT_ID
												,@ACTIVE_FLAG;

		  END;
		  CLOSE CUR_SUM_PRPC;
		  DEALLOCATE CUR_SUM_PRPC;

		 UPDATE [dbo].[SY_XIF_MRP_SUM_PROCUREMENT_ITEM_R]
			SET PROC_FLAG = 'Y'
			   ,PROC_DATE = GETDATE()
		  WHERE PROC_FLAG = 'P'
		-- ================================================
		-- 로직 추가 end
		-- ================================================

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
		CLOSE CUR_SUM_PRPC;
		DEALLOCATE CUR_SUM_PRPC;

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END

