
--CREATE PROCEDURE [dbo].[PR_XIF_MES_SLURYY_BTCH_GR_S]
CREATE PROCEDURE [dbo].[PR_XIF_MES_SLURYY_BTCH_GR_S]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_MES_SLURYY_BTCH_GR_S
-- Param               :
-- Batch Period        : 6Hour
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : ERP
-- Source Table        : SCM_BATCH_M, HIS_BATCH_M
-- Destination Table   : XIF_MES_BTCH_GR_S
--
-- Create(Update) Date : 2017.06.21
-- Author              : PIYONG
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_SLURYY_BTCH_GR_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME    = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @data_s      INTEGER
	
	-- ================================================
    -- Declare start
	-- ================================================

	SET @ROWCOUNT = @@ROWCOUNT

	DECLARE @IFSEQNO            NVARCHAR(50);

	DECLARE @SHOPID				NVARCHAR(50);
	DECLARE @PRODID             NVARCHAR(50);
	DECLARE @BTCH_GR_ID         NVARCHAR(50);
	DECLARE @USE_FLAG			NVARCHAR(1);


	DECLARE CUR_SLURYY_BTCH CURSOR FOR
		SELECT PLANT_ID
			   ,ITEM_ID
			   ,BATCH_ID
			   ,FLAG
			   ,'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)
		 FROM (
				SELECT PLANT_ID
						,ITEM_ID
						,BATCH_ID
						,'Y' AS FLAG
					FROM SCM_BATCH_M M
					WHERE M.UPDATE_TIME >= ( 
											SELECT ISNULL(MAX(IF_INS_DATE), GETDATE()-1.5)
											FROM [dbo].[SY_XIF_MES_BTCH_GR_S] S
											WHERE S.SHOPID = M.PLANT_ID
												AND S.PRODID = M.ITEM_ID
												AND S.BTCH_GR_ID = M.BATCH_ID
										)
				UNION ALL
				SELECT PLANT_ID
						,ITEM_ID
						,BATCH_ID
						,'N' AS FLAG
					FROM HIS_BATCH_M H
					WHERE 1=1
					AND H.INSERT_TIME >= ( 
											SELECT MAX(IF_INS_DATE)
											FROM [dbo].[SY_XIF_MES_BTCH_GR_S] S
											WHERE S.SHOPID = H.PLANT_ID
												AND S.PRODID = H.ITEM_ID
												AND S.BTCH_GR_ID = H.BATCH_ID
										)
					AND NOT EXISTS (
									SELECT 1
										FROM SCM_BATCH_M M
										WHERE M.PLANT_ID = H.PLANT_ID
										AND M.ITEM_ID = H.ITEM_ID
										AND M.BATCH_ID = H.BATCH_ID
									)
			  )A

	
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
			OPEN CUR_SLURYY_BTCH;

			FETCH NEXT FROM CUR_SLURYY_BTCH INTO @SHOPID
												,@PRODID
												,@BTCH_GR_ID
												,@USE_FLAG
												,@IFSEQNO
			;


			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					MERGE INTO [dbo].[SY_XIF_MES_BTCH_GR_S] MBG
					USING (
							SELECT @IFSEQNO AS IFSEQNO
								   ,@SHOPID AS PLANT_ID
								   ,@PRODID AS ITEM_ID
								   ,@BTCH_GR_ID AS BATCH_ID
								   ,@USE_FLAG AS FLAG
					  
						  ) TEMP
					   ON (
							MBG.SHOPID = TEMP.PLANT_ID
							AND MBG.PRODID = TEMP.ITEM_ID
							AND MBG.BTCH_GR_ID = TEMP.BATCH_ID
						  ) 
					 WHEN MATCHED THEN
						UPDATE 
						   SET MBG.IF_FLAG = 'N'
							   ,MBG.IF_INS_DATE = GETDATE()
							   ,MBG.USE_FLAG = TEMP.FLAG
							   ,MBG.UPDUSER = @v_proc_name
							   ,MBG.UPDDTTM = GETDATE()
					 WHEN NOT MATCHED THEN
						INSERT (
							  [IF_SEQ]
							  ,[IF_TYPE]
							  ,[IF_ID]
							  ,[IF_INS_DATE]
							  ,[IF_FLAG]
							  ,[IF_SND_DATE]
							  ,[SHOPID]
							  ,[PRODID]
							  ,[BTCH_GR_ID]
							  ,[USE_FLAG]
							  ,[INSUSER]
							  ,[INSDTTM]
							  ,[UPDUSER]
							  ,[UPDDTTM]
						) VALUES ( 
							TEMP.IFSEQNO
							,'S'
							,'OFP0_OSC1_FP_BTCH_GR'
							,GETDATE()
							,'N'
							,GETDATE()
							,TEMP.PLANT_ID
							,TEMP.ITEM_ID
							,TEMP.BATCH_ID
							,TEMP.FLAG
							,@v_proc_name
							,GETDATE()
							,@v_proc_name
							,GETDATE()
						);

					FETCH NEXT FROM CUR_SLURYY_BTCH INTO @SHOPID
														,@PRODID
														,@BTCH_GR_ID
														,@USE_FLAG
														,@IFSEQNO
					;



				END;

			CLOSE CUR_SLURYY_BTCH;
			DEALLOCATE CUR_SLURYY_BTCH;  

		SET @v_temp1 = 'STEP END PROCEDURE'
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp1, NULL, @v_descr, @sysdate

	END CATCH

END;

