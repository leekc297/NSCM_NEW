
CREATE PROCEDURE [dbo].[PR_XIF_EXE_TEST]

-- ================================================================================================
-- Program ID          : FP00520
-- Program Name        : PR_XIF_SAMPLE
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
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_EXE_TEST'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)


    DECLARE @Result INT;

    EXEC @Result = sp_getapplock
        @Resource = 'PR_XIF_EXE_TEST',  -- 고유 이름
        @LockMode = 'Exclusive',
        @LockOwner = 'Session',
        @LockTimeout = 0; -- 즉시 실패 (대기 안함)

    IF @Result < 0
    BEGIN
        PRINT N'이미 실행 중입니다.';
        RETURN;
    END



	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))



	-- Start 로그는 무조건 남김
	--EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY	
	



		BEGIN TRAN
		-- ================================================
        -- 실제 업무 로직
        PRINT N'프로시저 실행 시작';
        WAITFOR DELAY '00:00:05'; -- 예시 작업
        PRINT N'프로시저 실행 완료';
		-- ================================================
		COMMIT TRAN

		--EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		--EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

    EXEC sp_releaseapplock
        @Resource = 'PR_XIF_EXE_TEST',
        @LockOwner = 'Session';

 END



