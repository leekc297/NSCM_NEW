

CREATE PROCEDURE [dbo].[PR_XIF_MRP_INTRANSIT_R]

-- ================================================================================================
-- Program ID          : FP00672	Receive MRP_In_Transit
-- Program Name        : PR_XIF_MRP_INTRANSIT_R
-- Param               :
-- Batch Period        : 30 minute
-- Description         : MRP에서 관리하는 이동중 수량 수신
--
-- Source System       : MRP
-- Destination System  : FP SDB
-- Source Table        : LGCE_INF.DBO.XIF_MRP_INTRANSIT_R
-- Destination Table   : LGCE_FP_TR.DBO.FP_MRP_INTRANSIT_H
--
-- Create Date		   : 2020.05.06
-- Update Date		   : 2020.07.16 kimcd 1.1
--
-- Author              : kimcd
-- Version             : 1.0 initial creation
--                       1.1 2020-07-16 kimcd 수신 정보를 F로 시작하는 거래 조건 정보로 제한
-- ================================================================================================

-- PARAMETER
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MRP_INTRANSIT_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER       = 0

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
    DECLARE @ACCUM_DATE   NVARCHAR(50)
    DECLARE @PLANT_ID     NVARCHAR(50)


	DECLARE CUR_IF_MRP_ACCUM_DATE CURSOR FOR
		SELECT ACCUM_DATE
          FROM [SY_XIF_MRP_INTRANSIT_R]
         WHERE PROC_FLAG = 'N'
         GROUP BY ACCUM_DATE
        HAVING COUNT(1) = MAX(ACCUM_COUNT) -- 전체를 수신받지 못한 경우에는 처리하지 않음.
         ORDER BY ACCUM_DATE
		 ;


	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- ================================================
		-- 로직 추가 start
		-- ================================================
			OPEN CUR_IF_MRP_ACCUM_DATE;
			FETCH NEXT FROM CUR_IF_MRP_ACCUM_DATE INTO @ACCUM_DATE	

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					UPDATE [SY_XIF_MRP_INTRANSIT_R]
					SET PROC_FLAG = 'P'
					WHERE PROC_FLAG  = 'N'
					AND   ACCUM_DATE = @ACCUM_DATE;

					DECLARE CUR_IF_MRP_PLANT CURSOR FOR
						SELECT PLANT_CD
						  FROM [SY_XIF_MRP_INTRANSIT_R]
						 WHERE PROC_FLAG  = 'P'
						 AND   ACCUM_DATE = @ACCUM_DATE
						 GROUP BY ACCUM_DATE, PLANT_CD
						 ORDER BY ACCUM_DATE, PLANT_CD
						 ;

					OPEN CUR_IF_MRP_PLANT;
					FETCH NEXT FROM CUR_IF_MRP_PLANT INTO @PLANT_ID	

					WHILE (@@FETCH_STATUS = 0)
						BEGIN
						    DELETE [dbo].[FP_MRP_INTRANSIT_H]
							WHERE PLANT_ID = @PLANT_ID;

							INSERT INTO [dbo].[FP_MRP_INTRANSIT_H]
								(  [COMPANY_ID]
								  ,[DIVISION_ID]
								  ,[SITE_ID]
								  ,[PLANT_ID]
								  ,[BL_NO]
								  ,[BL_ITEM_NO]
								  ,[PO_NO]
								  ,[PO_ITEM_NO]
								  ,[SLOC_ID]
								  ,[ITEM_ID]
								  ,[VENDOR_CODE]
								  ,[INTRANSIT_QTY]
								  ,[HOUSE_BL_NO]
								  ,[BL_STAT_FLAG]
								  ,[BL_QTY]
								  ,[BL_CUSTOMS_QTY]
								  ,[BL_RECEIVE_QTY]
								  ,[ETA_DATE]
								  ,[BL_CURRENCY]
								  ,[BL_AMT]
								  ,[BL_AMT_PER_UNIT]
								  ,[BL_UOM]
								  ,[BL_REGISTER_DATE]
								  ,[BL_CHANGE_DATE]
								  ,[ATTRBT_1_VAL]
								  ,[ATTRBT_2_VAL]
								  ,[ATTRBT_3_VAL]
								  ,[ATTRBT_4_VAL]
								  ,[ATTRBT_5_VAL]
								  ,[INSERT_ID]
								  ,[INSERT_TIME]
								  ,[IF_SEQ]
								  ,[ACCUM_DATE])
							SELECT P.[COMPANY_ID]
								  ,P.[DIVISION_ID]
								  ,P.[SITE_ID]
								  ,P.[PLANT_ID]
								  ,A.[BL_NO]
								  ,A.[BL_ITEM_NO]
								  ,A.[PO_NO]
								  ,A.[PO_ITEM_NO]
								  ,A.[WH_CD]
								  ,A.[ITEM_CD]
								  ,A.[VNDR_CD]
								  ,A.[INTRAN_QTY]
								  ,A.[HOUSE_BL_NO]
								  ,A.[BL_STAT_FLAG]
								  ,A.[BL_QTY]
								  ,A.[BL_CSTM_QTY]
								  ,A.[BL_GR_QTY]
								  ,CONVERT(DATE, A.[ETA_DT], 112)
								  ,A.[BL_CUR_CD]
								  ,A.[BL_AMT]
								  ,A.[BL_AMT_PER_UNIT]
								  ,A.[BL_UOM]
								  ,CONVERT(DATE, A.[REG_DT], 112)
								  ,CONVERT(DATE, A.[CHNG_DT], 112)
								  ,A.[ATTRBT_1_VAL]
								  ,A.[ATTRBT_2_VAL]
								  ,A.[ATTRBT_3_VAL]
								  ,A.[ATTRBT_4_VAL]
								  ,A.[ATTRBT_5_VAL]
								  ,@v_proc_name
								  ,GETDATE() -- INSERT_TIME
								  ,A.[IF_SEQ]
								  ,A.[ACCUM_DATE]
							FROM   [dbo].[SY_XIF_MRP_INTRANSIT_R]  A (NOLOCK),
								   [dbo].[SCM_PLANT_M]             P (NOLOCK)
							WHERE A.PLANT_CD   = P.PLANT_ID
							AND   A.PROC_FLAG  = 'P'
							AND   A.ATTR_01 LIKE 'F%'   -- ATTR_01	Incoterms 2020-07-16 kimcd 거래조건 F인 경우만 in-transit으로 포함. D 조건은 SCP의 in-transit 정보 사용
							AND   A.ACCUM_DATE = @ACCUM_DATE
							AND   A.PLANT_CD   = @PLANT_ID;

							SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT

							FETCH NEXT FROM CUR_IF_MRP_PLANT INTO @PLANT_ID;
						END; -- OPEN CUR_IF_MRP_PLANT의 END

					CLOSE CUR_IF_MRP_PLANT;
					DEALLOCATE CUR_IF_MRP_PLANT;  

					UPDATE [SY_XIF_MRP_INTRANSIT_R]
					SET  PROC_FLAG = 'Y'
						,PROC_DATE = GETDATE()
					WHERE PROC_FLAG  = 'P'
					AND   ACCUM_DATE = @ACCUM_DATE;

					FETCH NEXT FROM CUR_IF_MRP_ACCUM_DATE INTO @ACCUM_DATE;
				END; -- OPEN CUR_IF_MRP_ACCUM_DATE의 END

			CLOSE CUR_IF_MRP_ACCUM_DATE;
			DEALLOCATE CUR_IF_MRP_ACCUM_DATE;  
		-- ================================================
		-- 로직 추가 end
		-- ================================================


		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		SELECT @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END;
