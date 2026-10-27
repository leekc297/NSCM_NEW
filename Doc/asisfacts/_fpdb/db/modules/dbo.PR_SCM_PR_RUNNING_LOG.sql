
CREATE PROCEDURE [dbo].[PR_SCM_PR_RUNNING_LOG]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_PR_RUNNING_LOG
-- Param               :
-- Batch Period        : 2 Min
-- Description         : SCM FP 운영 DB의 SCM_SITE_M을 조회 후 로그를 남겨 WA DB가 정상 작동중인지 판단함
--
-- Source System       : SCM FP
-- Destination System  : SCM FP
-- Source Table        : "10.34.220.88,7433".LGCE_FP_TR.DBO.SCM_SITE_M
-- Destination Table   : LGCE_INFDEV.dbo.XIF_LOG_HISTORY
--
-- Create(Update) Date : 2025.05.07
-- Author              : 김진수
-- Version             : 1.0 init
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_PR_RUNNING_LOG'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @CHECK_SCMFP  INTEGER

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
		
        SELECT @CHECK_SCMFP = COUNT(*) 
          FROM "10.34.220.88,7433".LGCE_FP_TR.DBO.SCM_SITE_M WITH(NOLOCK)

        IF @CHECK_SCMFP IS NULL
            RAISERROR('Failed to read SCM FP DB.', 16, 1);

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @CHECK_SCMFP, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



