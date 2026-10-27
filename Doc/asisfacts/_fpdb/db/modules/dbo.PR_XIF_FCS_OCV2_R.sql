
CREATE PROCEDURE [dbo].[PR_XIF_FCS_OCV2_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_FCS_OCV2_R
-- Param               :
-- Batch Period        : 1DAY
-- Description         :
--
-- Source System       : DW
-- Destination System  : FP SDB
-- Source Table        : XIF_FCS_OCV2_PROD_R, XIF_FCS_OCV2_DATE_R
-- Destination Table   : SCM_FCS_SHIPPING_TERM_M, SCM_FCS_OCV2_H

--
-- Create Date		   : 2018.02.22
-- Update Date		   : 2019.04.17 PIYONG

-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 출하 대기 기간 테이블에 동일 ITEM의 대기 기간이 변경 되었을때 수정이 아닌 신규 로 생성되어 CURSOR  추가
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_FCS_OCV2_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)


	DECLARE @SKUKEY     NVARCHAR(150)
	DECLARE @OWNRKY     NVARCHAR(20)
	DECLARE @OCV2_VALID_DAYS     NVARCHAR(10)
	DECLARE @CREDAT     NVARCHAR(10)
	DECLARE @CRETIM     NVARCHAR(10)
	DECLARE @CREUSR     NVARCHAR(1000)
	DECLARE @LMODAT     NVARCHAR(10)
	DECLARE @LMOTIM     NVARCHAR(10)
	DECLARE @LMOUSR     NVARCHAR(1000)

	DECLARE @IFSEQNO	NVARCHAR(250);

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			SET @IFSEQNO = (
							SELECT MAX(IFSEQNO)
							  FROM SY_XIF_FCS_OCV2_PROD_R
							 WHERE [TRANSFER_FLAG] = 'N'
							)

			UPDATE SY_XIF_FCS_OCV2_PROD_R
			   SET [TRANSFER_FLAG] = 'P'
			 WHERE IFSEQNO = @IFSEQNO

			--2019-04-17 PIYONG ADD
			DECLARE CUR_SHIPPING_TERM CURSOR FOR
				SELECT [SKUKEY]
					   ,[OWNRKY]
					   ,[OCV2_VALID_DAYS]
					   ,[CREDAT]
					   ,[CRETIM]
					   ,[CREUSR]
					   ,[LMODAT]
					   ,[LMOTIM]
					   ,[LMOUSR]
				  FROM SY_XIF_FCS_OCV2_PROD_R
				 WHERE [TRANSFER_FLAG] = 'P'
				 ORDER BY CREATE_DATE
						,[LMODAT]
						,[LMOTIM]

			OPEN CUR_SHIPPING_TERM
            FETCH NEXT FROM CUR_SHIPPING_TERM INTO @SKUKEY
												   ,@OWNRKY
												   ,@OCV2_VALID_DAYS
												   ,@CREDAT
												   ,@CRETIM
												   ,@CREUSR
												   ,@LMODAT
												   ,@LMOTIM
												   ,@LMOUSR

			WHILE @@FETCH_STATUS = 0
				BEGIN

					MERGE INTO DBO.SCM_FCS_SHIPPING_TERM_M A
					USING (
							SELECT @SKUKEY AS SKUKEY
							   ,@OWNRKY AS OWNRKY
							   ,@OCV2_VALID_DAYS AS OCV2_VALID_DAYS
							   ,@CREDAT AS CREDAT
							   ,@CRETIM AS CRETIM
							   ,@CREUSR AS CREUSR
							   ,@LMODAT AS LMODAT
							   ,@LMOTIM AS LMOTIM
							   ,@LMOUSR AS LMOUSR

						  ) B
					   ON ( A.[ITEM_ID]		= B.[SKUKEY]
							AND A.[OWNR]	= B.[OWNRKY] )
					WHEN MATCHED THEN
						UPDATE 
						   SET A.[SHIPPING_TERM_DATE] = B.[OCV2_VALID_DAYS]         
							  ,A.[CREDATE]			= CONVERT(datetime, SUBSTRING([CREDAT], 1, 4)+'-'+SUBSTRING([CREDAT], 5, 2)+'-'+SUBSTRING([CREDAT], 7, 2)+' '
																		+SUBSTRING([CRETIM], 1, 2)+':'+SUBSTRING([CRETIM], 3, 2)+':'+SUBSTRING([CRETIM], 5, 2), 120)
							  ,A.[CREUSR]			= B.[CREUSR]
							  ,A.[LMODATE]			= CONVERT(datetime, SUBSTRING([LMODAT], 1, 4)+'-'+SUBSTRING([LMODAT], 5, 2)+'-'+SUBSTRING([LMODAT], 7, 2)+' '
																		+SUBSTRING([LMOTIM], 1, 2)+':'+SUBSTRING([LMOTIM], 3, 2)+':'+SUBSTRING([LMOTIM], 5, 2), 120)
							  ,A.[LMOUSR]			= B.[LMOUSR] 
							  ,A.[UPDATE_ID]		= 'PR_XIF_FCS_OCV2_R'
							  ,A.[UPDATE_TIME]		= GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
							[ITEM_ID]
							,[OWNR]
							,[SHIPPING_TERM_DATE]
							,[CREDATE]
							,[CREUSR]
							,[LMODATE]
							,[LMOUSR]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
						) VALUES(
							B.[SKUKEY]
							,B.[OWNRKY]
							,B.[OCV2_VALID_DAYS]
							,CONVERT(datetime, SUBSTRING([CREDAT], 1, 4)+'-'+SUBSTRING([CREDAT], 5, 2)+'-'+SUBSTRING([CREDAT], 7, 2)+' '
																		+SUBSTRING([CRETIM], 1, 2)+':'+SUBSTRING([CRETIM], 3, 2)+':'+SUBSTRING([CRETIM], 5, 2), 120)
							,B.[CREUSR]
							,CONVERT(datetime, SUBSTRING([LMODAT], 1, 4)+'-'+SUBSTRING([LMODAT], 5, 2)+'-'+SUBSTRING([LMODAT], 7, 2)+' '
																		+SUBSTRING([LMOTIM], 1, 2)+':'+SUBSTRING([LMOTIM], 3, 2)+':'+SUBSTRING([LMOTIM], 5, 2), 120)
							,B.[LMOUSR]
							,'PR_XIF_FCS_OCV2_R'
							,GETDATE()
							,'PR_XIF_FCS_OCV2_R'
							,GETDATE()
						)
					;

					FETCH NEXT FROM CUR_SHIPPING_TERM INTO @SKUKEY
														   ,@OWNRKY
														   ,@OCV2_VALID_DAYS
														   ,@CREDAT
														   ,@CRETIM
														   ,@CREUSR
														   ,@LMODAT
														   ,@LMOTIM
														   ,@LMOUSR

				END
			CLOSE CUR_SHIPPING_TERM;
	        DEALLOCATE CUR_SHIPPING_TERM;   -- 메모리 해제


			UPDATE SY_XIF_FCS_OCV2_PROD_R
			   SET [TRANSFER_FLAG] = 'Y'
			 WHERE [TRANSFER_FLAG] = 'P'


			SET @IFSEQNO = (SELECT MAX(IFSEQNO)
							  FROM SY_XIF_FCS_OCV2_DATE_R
							 WHERE [TRANSFER_FLAG] = 'N'
							)

			MERGE INTO DBO.SCM_FCS_OCV2_H A
			USING (
					SELECT DISTINCT [PALLET_ID]
						   ,[LOT_ID]
						   ,[OCV2_DATE]
					  FROM SY_XIF_FCS_OCV2_DATE_R
					 WHERE IFSEQNO = @IFSEQNO
				  ) B
			   ON ( A.[PALLET_ID]	= B.[PALLET_ID]
					AND A.[LOT_ID]	= B.[LOT_ID] )
			WHEN MATCHED THEN
				UPDATE 
				   SET A.[OCV2_DATE] = B.[OCV2_DATE]         
					  ,A.[UPDATE_ID]		= 'PR_XIF_FCS_OCV2_R'
					  ,A.[UPDATE_TIME]		= GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[PALLET_ID]
					,[LOT_ID]
					,[OCV2_DATE]
					,[INSERT_ID]
					,[INSERT_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
				) VALUES(
					B.[PALLET_ID]
				    ,B.[LOT_ID]
				    ,B.[OCV2_DATE]
				    ,'PR_XIF_FCS_OCV2_R'
				    ,GETDATE()
				    ,'PR_XIF_FCS_OCV2_R'
				    ,GETDATE()
				)
			;

			UPDATE SY_XIF_FCS_OCV2_DATE_R
			   SET [TRANSFER_FLAG] = 'Y'
			 WHERE IFSEQNO = @IFSEQNO

		COMMIT TRAN



		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
