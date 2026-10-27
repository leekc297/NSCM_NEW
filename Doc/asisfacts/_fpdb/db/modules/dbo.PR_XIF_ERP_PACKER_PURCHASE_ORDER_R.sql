
CREATE PROCEDURE [dbo].[PR_XIF_ERP_PACKER_PURCHASE_ORDER_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_ERP_PACKER_PURCHASE_ORDER_R
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : ERP XI
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_PACKER_PURCHASE_ORDER_R
-- Destination Table   : SCM_PACKER_PO_H
--
-- Create(Update) Date : 2016.08.16
-- Author              : 김 석
-- Version             : 1.0
-- ================================================================================================

-- ERP요청 SEQNO
@P_IFSEQNO NVARCHAR(50) = 'NULL'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_PACKER_PURCHASE_ORDER_R'
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
		  
		IF @P_IFSEQNO = 'NULL'
		   SET @P_IFSEQNO = (SELECT MAX(IFSEQNO) FROM [dbo].[SY_XIF_ERP_PACKER_PURCHASE_ORDER_R] WITH(NOLOCK)
							  WHERE TRANSFER_FLAG = 'N'
							)
	    --SELECT * FROM [LGCE_INF].[dbo].[XIF_ERP_PACKER_PURCHASE_ORDER_R] WHERE IFSEQNO = '2016100418210725'
		UPDATE [dbo].[SY_XIF_ERP_PACKER_PURCHASE_ORDER_R]
		   SET TRANSFER_FLAG = 'P'
	     WHERE IFSEQNO       = @P_IFSEQNO
		   AND TRANSFER_FLAG = 'N'
		;

		-- CUTOFF_DATE 기준으로 삭제
		DELETE FROM [dbo].[SCM_PACKER_PO_H]
         WHERE CUTOFF_DATE IN ( SELECT DISTINCT CAST(A.[WORK_DATE] AS DATETIME) AS CUTOFF_DATE
		                          FROM [dbo].[SY_XIF_ERP_PACKER_PURCHASE_ORDER_R] A WITH(NOLOCK)
	                             WHERE IFSEQNO       = @P_IFSEQNO
								 --WHERE IFSEQNO       = '2016100418152263'
		                           AND TRANSFER_FLAG = 'P'
			                 )
		;

		INSERT INTO [dbo].[SCM_PACKER_PO_H]
				   ([COMPANY_ID]
				   ,[DIVISION_ID]
				   ,[SITE_ID]
				   ,[PLANT_ID]
				   ,[CUTOFF_DATE]
				   ,[PO_NO]
				   ,[PO_SEQ]
				   ,[VENDOR_CODE]
				   ,[VENDOR_NAME]
				   ,[RSD]
				   ,[ETA]
				   ,[ITEM_ID]
				   ,[ITEM_NAME]
				   ,[PO_QTY]
				   ,[WH_IN_QTY]
				   ,[REMAIN_QTY]
				   ,[ACTIVE_FLAG]
				   ,[DESCRIPTION]
				   ,[INSERT_ID]
				   ,[INSERT_TIME]
				   ,[UPDATE_ID]
				   ,[UPDATE_TIME])
			SELECT DISTINCT
			       [COMPANY]
				  ,[DIVISION]
				  ,(SELECT MAX(SITE_ID) FROM [dbo].[SCM_PLANT_M] WHERE PLANT_ID = A.PLANT)
				  ,[PLANT]
				  ,[WORK_DATE]
				  ,[PO_NO]
				  ,[PO_SEQ]
				  ,[VENDOR_CODE]
				  ,[VENDOR_NAME]
				  ,[RSD]
				  ,[ETA]
				  ,[ITEM_ID]
				  ,[ITEM_NAME]
				  ,[QTY]
				  ,[WH_IN_QTY]
				  ,[REMAIN_QTY]
				  ,[VALID_YN]
				  ,NULL
				  ,'PR_XIF_ERP_PACKER_PURCHASE_ORDER_R'
				  ,GETDATE()
				  ,'PR_XIF_ERP_PACKER_PURCHASE_ORDER_R'
				  ,GETDATE()
			  FROM [dbo].[SY_XIF_ERP_PACKER_PURCHASE_ORDER_R] A WITH(NOLOCK)
			 WHERE [IFSEQNO]  = @P_IFSEQNO
			   AND TRANSFER_FLAG = 'P'
		;

		SET @ROWCOUNT = @@ROWCOUNT

		UPDATE [dbo].[SY_XIF_ERP_PACKER_PURCHASE_ORDER_R]
		   SET TRANSFER_FLAG = 'Y'
			  ,TRANSFER_DATE = GETDATE()
	     WHERE IFSEQNO       = @P_IFSEQNO
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



