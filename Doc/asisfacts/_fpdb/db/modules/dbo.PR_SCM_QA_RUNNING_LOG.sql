
CREATE PROCEDURE [dbo].[PR_SCM_QA_RUNNING_LOG]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_QA_RUNNING_LOG
-- Param               :
-- Batch Period        : 2 Min
-- Description         : QA DB의 SCM_SITE_M을 조회함으로써 DB가 정상 작동중인지 판단하기 위함
--
-- Source System       : SCM QA
-- Destination System  : SCM DEV
-- Source Table        : "10.34.222.230,1433".LGCE_FPDEV_TR.DBO.SCM_SITE_M
-- Destination Table   : LGCE_INFDEV.dbo.XIF_LOG_HISTORY
--
-- Create(Update) Date : 2024.02.29
-- Author              : 김진수
-- Version             : 1.0 init
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_QA_RUNNING_LOG'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

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
		-- 로직 추가 start
		-- ================================================
		
		 SELECT * 
         FROM "10.34.222.230,1433".LGCE_FPDEV_TR.DBO.SCM_SITE_M

         SET @ROWCOUNT = @@ROWCOUNT

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



