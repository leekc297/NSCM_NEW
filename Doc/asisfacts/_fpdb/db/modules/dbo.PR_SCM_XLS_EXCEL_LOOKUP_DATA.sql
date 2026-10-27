
CREATE PROCEDURE [dbo].[PR_SCM_XLS_EXCEL_LOOKUP_DATA]
-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_XLS_EXCEL_LOOKUP_DATA
-- Param               : 
-- Batch Period        : On-Line
-- Description         : 
-- 
-- Source System       : FP SDB
-- Destination System  : EXCEL
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2019.08.19
-- Update Date         : 
--						

-- Author              : PIYONG
-- Version             : 1.0 최초작성

-- ================================================================================================
    @P_OPERATION      NVARCHAR(40)  = 'ELEC'
AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_XLS_EXCEL_LOOKUP_DATA'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @OPERATION   NVARCHAR(40);

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate


	BEGIN TRY				
	    SET @OPERATION = @P_OPERATION

		SELECT SEGMENT2 AS VERSION, ATTRIBUTE1 AS RELEASE_DATE , VALUE_DESCRIPTION
		FROM DBO.SCM_SYS_LOOKUP_VALUE WITH (NOLOCK)  
		WHERE LOOKUP_TYPE_CODE ='FP_SIMULATOR_VER'
		AND SEGMENT1           = @OPERATION -- 공정 구분
		AND ACTIVE_FLAG        ='Y' 
		ORDER BY SEGMENT2


			-- ================================================
			-- 로직 추가 end
			-- ================================================

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
