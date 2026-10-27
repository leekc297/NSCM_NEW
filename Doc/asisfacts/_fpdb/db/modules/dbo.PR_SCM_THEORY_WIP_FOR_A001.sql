
CREATE PROCEDURE [dbo].[PR_SCM_THEORY_WIP_FOR_A001]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_THEORY_WIP_FOR_A001
-- Param               :
-- Batch Period        : 1일 1회
-- Description         : PR_SCM_THEORY_WIP 작업의 A001 호출용
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : SCM_BASE_STOCK_H, SCM_MES_WIP_HISTORY_H
-- Destination Table   : 이론재고 SCM_STOCK_H.CAL_QTY
-- 이동 유형
--              MOVE_AREA : 동일 PLANT 동간이동 EX) A1 -> A2, E5 -> E6
--              MOVE_LINE : 라인간 이동
--              MOVE_MTRL : 자재 이동
--              MOVE_PROC : 동일 PLANT, 동 공정이동 EX) 310A -> 310B, 310N -> 310M
--              MOVE_SHOP : PLANT 이동 EX) A041 -> A040, G452 -> G451
--              RETURN_MTRL : 자재 반품
--              RETURN_SHOP : PLANT 반품 EX) A040 -> A041, G451 -> G452
--
-- Create Date		   : 2017.09.04
-- Update Date		   : 2019.10.01

-- Author              : KIMCD
-- Version             : 1.0
--                       1.1 2019-10-01 kimcd 매개변수에 시업시간 추가
-- ================================================================================================

-- PARAMETER
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_THEORY_WIP_FOR_A001'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()
	DECLARE	@return_value int

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY
		-- ================================================
		-- 로직 추가 start
		-- ================================================						
		EXEC	@return_value = [dbo].[PR_SCM_THEORY_WIP]
				@P_SITE_ID = N'A001',
				@P_BASIS_START_TIME = N'060000'  -- 2019-10-01 kimcd 매개변수에 시업시간 추가

		IF @return_value != 0
			BEGIN
				RAISERROR ('Error in PR_SCM_THEORY_WIP @P_SITE_ID = N''A001''', -- Message text.
							16, -- Severity.
							1 -- State.
							);
			END;


		-- ================================================
		-- 로직 추가 end
		-- ================================================
		
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', 1, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		SELECT @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
