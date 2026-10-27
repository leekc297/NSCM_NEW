
CREATE PROCEDURE [dbo].[PR_XIF_DW_LOT_WIPHOLDHISTORY_U]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_DW_LOT_WIPHOLDHISTORY_U
-- Param               :
-- Batch Period        : 1Day
-- Description         : WIP.VLD_DATE, WIP.LANE_QTY, UNHOLD_SCHD_DATE
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : XIF_DW_LOT_R, XIF_DW_WIP_HOLD_HISTORY_R
-- Destination Table   : XIF_DW_WIP_R
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
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_LOT_WIPHOLDHISTORY_U'
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
		
		--UPDATE [LGCE_INF].[dbo].[XIF_DW_LOT_R] SET TRANSFER_FLAG = 'N' WHERE IFSEQNO = '20161111120010'
		IF @P_IFSEQNO = 'NULL'
		   SET @P_IFSEQNO = (SELECT MAX(IFSEQNO) FROM [dbo].[SY_XIF_DW_LOT_R] with(nolock)
							  WHERE TRANSFER_FLAG = 'N'
							)

		--UPDATE [LGCE_INF].[dbo].[XIF_DW_LOT_R] SET TRANSFER_FLAG = 'N' WHERE IFSEQNO = '20161130111446'

		UPDATE [dbo].[SY_XIF_DW_LOT_R]
		   SET TRANSFER_FLAG = 'P'
	     WHERE IFSEQNO       = @P_IFSEQNO
		   AND TRANSFER_FLAG = 'N'
		;

		UPDATE [dbo].[SY_XIF_DW_WIP_R]
		   SET VLD_DATE = (SELECT TOP 1 VLD_DATE 
		                     FROM [dbo].[SY_XIF_DW_LOT_R] A with(nolock)
		                    WHERE A.LOTID   = [dbo].[SY_XIF_DW_WIP_R].LOTID
							  AND A.IFSEQNO = @P_IFSEQNO
						  )
		      ,LANE_QTY = (SELECT TOP 1 LANE_QTY 
		                     FROM [dbo].[SY_XIF_DW_LOT_R] A with(nolock)
							WHERE A.LOTID   = [dbo].[SY_XIF_DW_WIP_R].LOTID
							  AND A.IFSEQNO = @P_IFSEQNO
						  )
			  ,MODIFY_USER_ID = 'PR_XIF_DW_LOT_WIPHOLDHISTORY_U'
			  ,MODIFY_DATE    = GETDATE()
	     WHERE IFSEQNO = (SELECT MAX(IFSEQNO) FROM [dbo].[SY_XIF_DW_WIP_R] with(nolock) )
		   
		;

		SET @ROWCOUNT = @@ROWCOUNT

		--SELECT * FROM [LGCE_INF].[dbo].[XIF_DW_WIP_R] WHERE IFSEQNO = '20161129140820'
		--AND VLD_DATE <> ''
		--AND LANE_QTY <> 0

		UPDATE [dbo].[SY_XIF_DW_LOT_R]
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



