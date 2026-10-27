
CREATE     PROCEDURE [dbo].[PR_XIF_MES_INPUT_WO_R]

-- ================================================================================================
-- Program ID          : FP00852
-- Program Name        : PR_XIF_MES_INPUT_WO_R
-- Param               :
-- Batch Period        : 2Hour
-- Description         :
--
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_INPUT_WO_R
-- Destination Table   : FP_MES_PRODUCTION_PLAN_M
--
-- Create Date		   : 2019.02.27
-- Update Date		   : 2019.03.15  1.1 PIYONG
--						 2019.05.20  1.2 PIYONG
--						 2025-09-17  1.3 CYS

-- Author              : PIYONG

-- Version             : 1.0
--						 1.1 WO CLOSE 여부 추가
--						 1.2 투입 수량 수신 추가
--                       1.3 2025-10-19 CYS    	[20251019-000000] W/O 과실적 방지 관련 - 과실적 Flag, next W/O 추가 
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_XIF_MES_INPUT_WO_R'
	DECLARE @v_descr		NVARCHAR(250)
	DECLARE @v_count		INTEGER	   = 0
	DECLARE @sysdate		DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1		NVARCHAR(1000)
	DECLARE @v_temp2		NVARCHAR(1000)

	DECLARE @IF_ID			NVARCHAR(50)
	DECLARE @ACCUM_DATE		NVARCHAR(50)

	DECLARE CUR_IF_MES_INPUT_WO CURSOR FOR

	SELECT IF_ID, ACCUM_DATE
		  FROM SY_XIF_MES_INPUT_WO_R
		 WHERE PROC_FLAG = 'P'
		 GROUP BY IF_ID, ACCUM_DATE
		HAVING ( COUNT(1) = MAX(ACCUM_COUNT)  OR ( COUNT(1) = 1 AND MAX(ACCUM_COUNT) = 0 ) )  -- 전체를 수신받지 못한 경우에는 처리하지 않음.
		 ORDER BY IF_ID, ACCUM_DATE

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			UPDATE SY_XIF_MES_INPUT_WO_R
			   SET PROC_FLAG = 'P'
			 WHERE PROC_FLAG = 'N'

			 
			OPEN CUR_IF_MES_INPUT_WO;
			FETCH NEXT FROM CUR_IF_MES_INPUT_WO INTO @IF_ID
												     ,@ACCUM_DATE
		    ;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					UPDATE A
				       SET ATTRIBUTE8 = CASE WHEN A.ATTRIBUTE8 IS NULL THEN B.INPUT_DATE ELSE A.ATTRIBUTE8 END
						   ,ATTRIBUTE9 = B.WO_CLOSE_YN															--2019-03-15 PIYONG ADD
						   ,ATTRIBUTE10 = CAST(B.ACTUAL_QTY AS NVARCHAR(200))		-- ACTUAL QTY				--2019-05-20 PIYONG ADD
						   ,ATTRIBUTE11 = CAST(B.ACTUAL_QTY - SCRAP_QTY	AS NVARCHAR(200)) -- 양품(총 투입-불량)	--2019-05-20 PIYONG ADD
						   ,ATTRIBUTE12 = B.NEXT_WO_FLAG				-- [20251019-000000] 과발행 대상 Flag ADD
						   ,ATTRIBUTE13 = B.NEXT_WORK_ORDER_ID			-- [20251019-000000] 다음 W/O ADD
					  FROM FP_MES_PRODUCTION_PLAN_M A
						   ,(
							 SELECT CONVERT(NVARCHAR(20), MIN(EIODTTM), 120 ) AS INPUT_DATE
									, AREAID AS FACTORY_ID
								    , WO_DETL_ID AS WORK_ORDER_ID
									, ATTR_01 AS WO_CLOSE_YN													--2019-03-15 PIYONG ADD
									, SUM( CONVERT(numeric(20,5),ATTR_02) ) AS ACTUAL_QTY	-- 총 투입 (양품 + 불량)		--2019-05-20 PIYONG ADD
									, SUM( CONVERT(numeric(20,5),ATTR_03) ) AS SCRAP_QTY	-- 불량 (LOSS + SCRAP QTY)	--2019-05-20 PIYONG ADD
									, MAX(ATTR_04) AS NEXT_WO_FLAG 				-- [20251019-000000] 과실적 대상 Flag ADD
									, MAX(ATTR_05) AS NEXT_WORK_ORDER_ID 		-- [20251019-000000] 다음 W/O ADD
							   FROM SY_XIF_MES_INPUT_WO_R
							  WHERE PROC_FLAG = 'P'
							    AND IF_ID = @IF_ID
							    AND ACCUM_DATE = @ACCUM_DATE
							  GROUP BY AREAID
									, WO_DETL_ID
									, ATTR_01																	-- 2019-03-15 PIYONG ADD
						  ) B
					WHERE A.FACTORY_ID = B.FACTORY_ID
					  AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
					  AND A.WORK_ORDER_SPL_ID = B.WORK_ORDER_ID
					;
				
					-- [20251019-000000] ADD 과실적 관련 계산 Table 적재
					INSERT INTO FP_WO_BALANCE_M
					(
						IF_ID, ACCUM_DATE, WORK_ORDER_ID, NEXT_WORK_ORDER_ID, NEXT_WO_FLAG, INSERT_ID, INSERT_DTTM, UPDATE_ID, UPDATE_DTTM
					)
					SELECT 	IF_ID, ACCUM_DATE, WORK_ORDER_ID, NEXT_WORK_ORDER_ID, NEXT_WO_FLAG
						   ,@v_proc_name AS INSERT_ID, GETDATE() AS INSERT_DTTM, @v_proc_name AS UPDATE_ID, GETDATE() AS UPDATE_DTTM
					FROM	(
								SELECT IF_ID, ACCUM_DATE, WO_DETL_ID AS WORK_ORDER_ID
									, MAX(ATTR_04) AS NEXT_WO_FLAG 				-- [20251019-000000] 과실적 대상 Flag ADD
									, MAX(ATTR_05) AS NEXT_WORK_ORDER_ID 		-- [20251019-000000] 다음 W/O ADD
								FROM SY_XIF_MES_INPUT_WO_R WITH(NOLOCK)
								WHERE 1=1
								AND PROC_FLAG 	= 'P'
								AND IF_ID		= @IF_ID
							    AND ACCUM_DATE 	= @ACCUM_DATE
								and ATTR_04 	= 'Y'		-- NEXT_WO_FLAG
								GROUP BY IF_ID, ACCUM_DATE, WO_DETL_ID
							) A 
					WHERE 	1=1
					AND 	NOT EXISTS (
											SELECT 	1
											FROM	FP_WO_BALANCE_M X WITH(NOLOCK)
											WHERE 	1=1
											AND 	A.IF_ID			=	X.IF_ID
											AND 	A.ACCUM_DATE	=	X.ACCUM_DATE
											AND 	A.WORK_ORDER_ID	=	X.WORK_ORDER_ID
										)
					;
				
					FETCH NEXT FROM CUR_IF_MES_INPUT_WO INTO @IF_ID        
														     ,@ACCUM_DATE
					;
				END;


			CLOSE CUR_IF_MES_INPUT_WO;
			DEALLOCATE CUR_IF_MES_INPUT_WO;

			UPDATE SY_XIF_MES_INPUT_WO_R
			   SET PROC_FLAG = 'Y'
			 WHERE PROC_FLAG = 'P'
				
			
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
		
		ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



