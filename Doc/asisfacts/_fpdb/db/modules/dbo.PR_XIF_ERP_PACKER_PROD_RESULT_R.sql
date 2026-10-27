
CREATE PROCEDURE [dbo].[PR_XIF_ERP_PACKER_PROD_RESULT_R]

-- ================================================================================================
-- Program ID          : FP00720
-- Program Name        : PR_XIF_ERP_PACKER_PROD_RESULT_R
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : ERP XI
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_PACKER_PROD_RESULT_R
-- Destination Table   : SCM_PRODUCT_RESULT_H -> SCM_PACKER_PROD_RESULT_H 
--
-- Create Date		   : 2016.08.16
-- Update Date		   : 2017.04.21 1.1  PIYONG
--					   : 2019.05.10 2.0  PIYONG
--					   : 2022.03.24 2.1  kimcd

-- Author              : 김 석
-- Version             : 1.0
--                     : 1.1 SCM_PRODUCT_RESULT_H DELETE TERMS ADD
--						 2.0 SCM_PRODUCT_RESULT_H 삭제로 인한 SCM_PACKER_PROD_RESULT_H로 변경
--                       2.1 2022-03-24 kimcd 가상 Division 사용하여 로직 수정
-- ================================================================================================

-- ERP요청 SEQNO
@P_IFSEQNO NVARCHAR(50) = 'NULL'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_PACKER_PROD_RESULT_R'
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
	--DECLARE @COMPANY     NVARCHAR(1000)
	DECLARE @ifseqno     NVARCHAR(30) = @P_IFSEQNO;


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
			SET @ifseqno = @P_IFSEQNO;
		  
			IF @ifseqno = 'NULL' OR @ifseqno IS NULL
			   SET @ifseqno = (
								 SELECT MAX(IFSEQNO)
								   FROM [dbo].[SY_XIF_ERP_PACKER_PROD_RESULT_R] WITH(NOLOCK)
								  WHERE TRANSFER_FLAG = 'N'
								)

			UPDATE [dbo].[SY_XIF_ERP_PACKER_PROD_RESULT_R]
			   SET TRANSFER_FLAG = 'P'
			 WHERE IFSEQNO       = @ifseqno
			   AND TRANSFER_FLAG = 'N'
			;

			MERGE INTO SCM_PACKER_PROD_RESULT_H A
			USING (
					SELECT [COMPANY]
						   ,ISNULL(PD.[PSEUDO_DIVISION_ID], [DIVISION]) AS DIVISION  -- 2022-03-24 kimcd 가상 Division 로직 추가
						   ,[SITE_ID]
						   ,[VENDOR_CODE] AS [PLANT_ID]
						   ,[VENDOR_CODE] AS [FACTORY_ID]
						   ,[ITEM_ID]
						   ,CAST([GOOD_QTY] AS NUMERIC(20,10)) AS [QTY]
						   ,CAST([PROD_DATE] AS DATETIME) AS [PRODUCT_DATE]
						   ,'MASS' AS [PRODUCTION_TYPE]
					  FROM [dbo].[SY_XIF_ERP_PACKER_PROD_RESULT_R] A WITH(NOLOCK)
							LEFT OUTER JOIN [DBO].[SCM_PSEUDO_DIVISION_M] PD WITH(NOLOCK)  -- 2022-03-24 kimcd 가상 Division 로직 추가
								ON  PD.[PLANT_ID] = A.[VENDOR_CODE]
					 WHERE [IFSEQNO]  = @ifseqno
					   AND [TRANSFER_FLAG] = 'P'
				  ) B
			   ON (
					A.[COMPANY_ID] = B.[COMPANY]
					AND A.[DIVISION_ID] = B.[DIVISION]
					AND A.[SITE_ID] = B.[SITE_ID]
					AND A.[PLANT_ID] = B.[PLANT_ID]
					AND A.[FACTORY_ID] = B.[FACTORY_ID]
					AND A.[ITEM_ID] = B.[ITEM_ID]
					AND A.[PRODUCT_DATE] = B.[PRODUCT_DATE]
				  )
			 WHEN MATCHED THEN
				UPDATE
				   SET A.[QTY] = B.[QTY]
					  ,A.UPDATE_ID = 'PR_XIF_ERP_PACKER_PROD_RESULT_R'
					  ,A.UPDATE_TIME = GETDATE()
			 WHEN NOT MATCHED THEN
				INSERT (
				   [COMPANY_ID]
				   ,[DIVISION_ID]
				   ,[SITE_ID]
				   ,[PLANT_ID]
				   ,[FACTORY_ID]
				   ,[ITEM_ID]
				   ,[QTY]
				   ,[PRODUCT_DATE]
				   ,[PRODUCTION_TYPE]
				   ,[INSERT_ID]
				   ,[INSERT_TIME]
				   ,[UPDATE_ID]
				   ,[UPDATE_TIME]
				) VALUES (
					B.[COMPANY]
				   ,B.[DIVISION]
				   ,B.[SITE_ID]
				   ,B.[PLANT_ID]
				   ,B.[FACTORY_ID]
				   ,B.[ITEM_ID]
				   ,B.[QTY]
				   ,B.[PRODUCT_DATE]
				   ,B.[PRODUCTION_TYPE]
				   ,'PR_XIF_ERP_PACKER_PROD_RESULT_R'
				   ,GETDATE()
				   ,'PR_XIF_ERP_PACKER_PROD_RESULT_R'
				   ,GETDATE()
				)
			;

			SET @ROWCOUNT = @@ROWCOUNT

			UPDATE [dbo].[SY_XIF_ERP_PACKER_PROD_RESULT_R]
			   SET TRANSFER_FLAG = 'Y'
				  ,TRANSFER_DATE = GETDATE()
			 WHERE IFSEQNO       = @ifseqno
			   AND TRANSFER_FLAG = 'P'
			;


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



