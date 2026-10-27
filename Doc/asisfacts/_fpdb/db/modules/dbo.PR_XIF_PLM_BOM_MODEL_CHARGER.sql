
CREATE PROCEDURE [dbo].[PR_XIF_PLM_BOM_MODEL_CHARGER]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_PLM_BOM_MODEL_CHARGER
-- Param               :
-- Batch Period        : 1 DAILY
-- Description         :
--
-- Source System       : PLM
-- Destination System  : FP SDB
-- Source Table        : XIF_PLM_BOM_MODEL_CHARGER
-- Destination Table   : FP_BOM_ITEM_CHARGER
--
-- Create(Update) Date : 2018.01.23
-- Author              : PIYONG
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PLM_BOM_MODEL_CHARGER'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			UPDATE [dbo].[SY_XIF_PLM_BOM_MODEL_CHARGER_R]
			   SET PROC_FLAG = 'P'
			 WHERE PROC_FLAG = 'N'


			MERGE INTO FP_BOM_ITEM_CHARGER A
			 USING (
					 SELECT MODEL_ID
							,MODEL_USER
							,MODEL_USER_ID
							,MODEL_STATUS_CD
							,MODEL_VER_CODE
							,SPPL_YN
							,BOM_YN
					   FROM [dbo].[SY_XIF_PLM_BOM_MODEL_CHARGER_R]
					  WHERE PROC_FLAG = 'P'
				   ) B
				ON ( A.ITEM_ID = B.MODEL_ID )
			  WHEN MATCHED THEN
					UPDATE SET A.ITEM_STATUS = B.MODEL_STATUS_CD
							   ,A.ITEM_USER = B.MODEL_USER
							   ,A.MAIL_ID = B.MODEL_USER_ID
							   ,A.ITEM_VER_CODE = B.MODEL_VER_CODE
							   ,A.SPPL_YN = B.SPPL_YN
							   ,A.BOM_YN = B.BOM_YN
							   ,A.UPDATE_TIME = GETDATE()
							   ,A.UPDATE_ID = 'PR_XIF_PLM_BOM_MODEL_CHARGER'
			  WHEN NOT MATCHED THEN
				INSERT (
					[ITEM_ID]
				    ,[ITEM_STATUS]
					,[ITEM_VER_CODE]
					,[ITEM_USER]
				    ,[MAIL_ID]
				    ,[SPPL_YN]
				    ,[BOM_YN]
				    ,[INSERT_TIME]
				    ,[INSERT_ID]
				    ,[UPDATE_TIME]
				    ,[UPDATE_ID]
				) VALUES (
					B.MODEL_ID
				    ,B.MODEL_STATUS_CD
					,B.MODEL_VER_CODE
					,B.MODEL_USER
				    ,B.MODEL_USER_ID
				    ,B.[SPPL_YN]
				    ,B.[BOM_YN]
				    , GETDATE()
				    , 'PR_XIF_PLM_BOM_MODEL_CHARGER'
				    , GETDATE()
				    , 'PR_XIF_PLM_BOM_MODEL_CHARGER'
				);

			UPDATE [dbo].[SY_XIF_PLM_BOM_MODEL_CHARGER_R]
			   SET PROC_FLAG = 'Y'
			 WHERE PROC_FLAG = 'P'

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



