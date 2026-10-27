
CREATE PROCEDURE [dbo].[PR_XIF_FP_SCP_IN_TRANSIT_SYNC_S]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_FP_SCP_IN_TRANSIT_SYNC_S
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : OC FP SDB
-- Destination System  : WA FP SDB
-- Source Table        : FP_SCM_IN_TRANSIT_H
-- Destination Table   : SY_XIF_FP_SCP_IN_TRANSIT_SYNC_S
--
-- Create(Update) Date : 2023.07.27
-- Author              : KJS
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON
	
	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_FP_SCP_IN_TRANSIT_SYNC_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
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
		-- 로직 추가
			-- I/F 테이블 삭제
			DELETE 
			FROM	[dbo].[SY_XIF_FP_SCP_IN_TRANSIT_SYNC_S]
			WHERE	IF_INS_DATE < CAST(CONVERT(NVARCHAR(10), DATEADD(D, -7, GETDATE()), 120) + ' 00:00:00' AS DATETIME)
			
			-- I/F 정보 입력
		INSERT INTO SY_XIF_FP_SCP_IN_TRANSIT_SYNC_S
					( [IF_SEQ]
					,[IF_TYPE]
					,[IF_ID]
					,[IF_INS_DATE]
					,[IF_FLAG]
					,[IF_SND_DATE]
					,[RESULT_DATE]
					,[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[ITEM_ID]
					,[DELIVERY_QTY]
					,[ETA_DATE]
					,[PLANT_ISSUE_DATE]
					,[FROM_SCP_SITE_ID]
					,[FROM_PLANT_ID]
					,[UOM]
					,[TRANSPORT_MODE]
					,[GNRT_DTTM]
					,[ACCUM_COUNT] )
			SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3, 6)
           					+ REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_FP_SEND_SEQ]))
           					+ CAST( NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_FP_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
					,'S' AS IF_TYPE
					,'OFP0' +'_' + SLV.ATTRIBUTE1 +'_FP_SCP_IN_TRANSIT_SYNC'
					,GETDATE()        AS IF_INS_DATE
					,'N'              AS IF_FLAG
					,GETDATE()        AS IF_SND_DATE
					,SIT.[RESULT_DATE]
					,SIT.[COMPANY_ID]
					,SIT.[DIVISION_ID]
					,SIT.[SITE_ID]
					,SIT.[PLANT_ID]
					,SIT.[ITEM_ID]
					,SIT.[DELIVERY_QTY]
					,SIT.[ETA_DATE]
					,SIT.[PLANT_ISSUE_DATE]
					,SIT.[FROM_SCM_SITE_ID]
					,SIT.[FROM_PLANT_ID]
					,SIT.[UOM]
					,SIT.[TRANSPORT_MODE]
					,GETDATE() AS GNRT_DTTM
					,COUNT(*) OVER(PARTITION BY SIT.COMPANY_ID)   ACCUM_COUNT
			FROM    [dbo].[FP_SCM_IN_TRANSIT_H] SIT
					INNER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  SLV
						ON   SLV.LOOKUP_TYPE_CODE = 'COMPANY_FP_SYSTEM_CODE'
						AND  SLV.SEGMENT1 = SIT.COMPANY_ID
						AND  SLV.ACTIVE_FLAG = 'Y'
			WHERE  SIT.[RESULT_DATE] = CONVERT(NVARCHAR(8), GETDATE()-1, 112)

		-- ================================================
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


