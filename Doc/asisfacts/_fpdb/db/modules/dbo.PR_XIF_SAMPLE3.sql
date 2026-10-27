
CREATE PROCEDURE [dbo].[PR_XIF_SAMPLE3]

-- ================================================================================================
-- Program ID          : FP00520
-- Program Name        : PR_XIF_SAMPLE3
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : RCCP
-- Destination System  : FP SDB
-- Source Table        : LG_EXP_PROD
-- Destination Table   : TH_MST_DEMAND
--
-- Create(Update) Date : 2022.01.01
-- Author              : FP Pjt.
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SAMPLE3'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- 중복실행방지
    DECLARE @Result INT;


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))


	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY	
	
		BEGIN TRAN

		-- 이 방식은 Logging이 애매함(PR_XIF_LOG)
		EXEC @Result = sp_getapplock
			@Resource = @v_proc_name,    -- 고유 이름
			@LockMode = 'Exclusive',
			@LockOwner = 'Transaction',
			@LockTimeout = 0; -- 즉시 실패 (대기 안함)

		IF @Result >= 0
		BEGIN
			-- ================================================
			-- 로직 추가


			WAITFOR DELAY '0:0:10'  --10초 대기
			-- ================================================
		END
		ELSE
		BEGIN
			PRINT N'Procedure is already running.';
			ROLLBACK TRAN;

		END
		
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		IF @@TRANCOUNT > 0
			ROLLBACK TRAN

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH


 END



