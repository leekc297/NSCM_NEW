
CREATE PROCEDURE [dbo].[PR_XIF_ERP_PRODUCTION_PLAN_S_TEST]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_ERP_PRODUCTION_PLAN_S
-- Param               :
-- Batch Period        : 1 Day
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF DEV
-- Source Table        : FP_PRODUCTION_PLAN_R
-- Destination Table   : XIF_ERP_PRODUCTION_PLAN_R
--
-- Create(Update) Date : 2016.09.08
-- Author              : 김 석
-- Version             : 1.0
-- ================================================================================================

-- ERP요청 SEQNO
@P_FP_PLAN_ID NVARCHAR(50) = NULL

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_PRODUCTION_PLAN_S_TEST'
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
	DECLARE @IFSEQNO     NVARCHAR(50)


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

		-- ERP 수신 IFSEQNO 형식과 맞춤
		SET @IFSEQNO = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','')

		SELECT * FROM [LGCE_INF].[dbo].[XIF_ERP_PRODUCTION_PLAN_S]
		;

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



