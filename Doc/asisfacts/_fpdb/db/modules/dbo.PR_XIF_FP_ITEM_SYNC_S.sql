

CREATE PROCEDURE [dbo].[PR_XIF_FP_ITEM_SYNC_S]

-- ================================================================================================
-- Program ID          : FP01629
-- Program Name        : PR_XIF_FP_ITEM_SYNC_S
-- Param               :
-- Batch Period        : 30 Min
-- Description         : SCM ITEM 변경정보 WA법인 FP로 동기화 전송
--
-- Source System       : FP
-- Destination System  : MES
-- Source Table        : SCM_ITEM_M
-- Destination Table   : XIF_FP_ITEM_SYNC_S
--
-- Create(Update) Date : 2023-06-14
-- Author              : JYJ
-- Version             : 1.0 Init
--                       1.1  2023-07-27 kimcd lookup join 제거. 품목은 전체 법인 정보를 전송     
--                       1.2  2025-01-02 chkim.68 MRP_USE_FLAG 전송  NERP
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_FP_ITEM_SYNC_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @ROWCOUNT    INTEGER = 0

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		    -- ================================================
		    -- 로직 추가 start
		    -- ================================================
			-- 실제 업무 Table의 정보를 삭제하면 안 됨.
			-- interface table만 삭제함..
			-- 1주일 만 유지
			DELETE FROM DBO.SY_XIF_FP_ITEM_S
			WHERE IF_SND_DATE < CAST( CONVERT(nvarchar(10), DATEADD( D, -7, GETDATE()), 120)+' 00:00:00'  AS DATETIME)
		    AND IF_FLAG = 'Y';

            INSERT INTO [dbo].[SY_XIF_FP_ITEM_S]
			(
                 [IF_SEQ]
                ,[IF_TYPE]
                ,[IF_ID]
                ,[IF_INS_DATE]
                ,[IF_FLAG]
                ,[IF_SND_DATE]
				,[COMPANY_ID]
                ,[DIVISION_ID]
                ,[SITE_ID]
                ,[ITEM_ID]
                ,[ITEM_NAME]
                ,[NICK_NAME]
                ,[ITEM_TYPE]
                ,[ITEM_CLASS_LEVEL_1]
                ,[ITEM_CLASS_LEVEL_2]
                ,[ITEM_CLASS_LEVEL_3]
                ,[ITEM_CLASS_LEVEL_4]
                ,[ITEM_CLASS]
                ,[ITEM_CLASS_NAME]
                ,[MATERIAL_CLASS]
                ,[MATERIAL_CLASS_NAME]
                ,[ELECTRODE_TYPE]
                ,[SIDE_TYPE]
                ,[ITEM_GROUP_ID]
                ,[SETUP_GROUP_ID_1]
                ,[SETUP_GROUP_ID_2]
                ,[SETUP_GROUP_ID_3]
                ,[FLOW_ID]
                ,[ERP_EOL]
                ,[SCP_EOL]
                ,[ITEM_UOM]
                ,[SPEC]
                ,[DEMAND_LOT_SIZE]
                ,[ITEM_ATTRIBUTE]
                ,[SETUP_ATTRIBUTE]
                ,[BATCH_RATIO_ID]
                ,[OUTSOURCING_FACTORY]
                ,[FINITE_TERM]
                ,[FINITE_TERM_UOM]
                ,[COATED_LENGTH]
                ,[UNCOATED_LENGTH]
                ,[LENGTH_UOM]
                ,[SLURRY_LOSS_RATE]
                ,[DESCRIPTION]
                ,[ACTIVE_FLAG]
                ,[UPDATE_ID]
                ,[UPDATE_TIME]
                ,[APPLIED_MODEL]
                ,[CELL_TYPE]
                ,[MAKE_AND_BUY]
                ,[COLOR_ATTRIBUTE]
                ,[FORMATION_FLOW_ID]
                ,[STANDARD_COST]
                ,[CURRENCY]
                ,[FORM_ATTRIBUTE]
                ,[ENERGE]
                ,[SCP_FLOW_ID]
                ,[SCP_OPERATION_GROUP]
                ,[SCP_OPERATION_GROUP_ID]
                ,[MDM_PROJECT_NAME]
                ,[MIN_CAPACITY]
                ,[MOBILE_MODEL_ID]
                ,[FORECAST_INFO_BIZ_TYPE]
                ,[FORECAST_INFO_PRODUCT_GROUP]
                ,[FORECAST_INFO_CELL_MODEL]
                ,[FORECAST_INFO_CELL_PACK_COUNT]
                ,[FORECAST_INFO_SPEC]
                ,[FORECAST_INFOR_VERSION]
                ,[DOE]
                ,[INSULATION_COATING]
                ,[PACK_PRODUCT_GROUP_CODE]
                ,[CELL_QUANTITY]
                ,[SCP_EXTRA_SPEC]
                ,[SCM_PIC]
                ,[REP_CUSTOMER]
                ,[MAKER]
                ,[EVAL_CLASS]
                ,[EVAL_CLASS_INFO]
                ,[FP_EXTRA_SPEC]
				,[ATTR_01] -- MRP_USE_FLAG를 ATTR_01로 전달
				,[MRP_USE_FLAG]
			)
           SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
           	   	  + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_FP_SEND_SEQ]))
           	   	  + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_FP_SEND_SEQ]))
           	   	  + CAST( NEXT VALUE FOR [dbo].[XIF_FP_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
               ,'S' AS IF_TYPE
               ,'OFP0' +'_' +'PFP0' +'_ITEM_SYNC'--,'OFP0' +'_' + SLV.ATTRIBUTE1 +'_ITEM_SYNC'
               ,GETDATE()        AS IF_INS_DATE
               ,'N'              AS IF_FLAG
               ,GETDATE()        AS IF_SND_DATE
               ,SIM.[COMPANY_ID]
               ,SIM.[DIVISION_ID]
               ,SIM.[SITE_ID]
               ,SIM.[ITEM_ID]
               ,SIM.[ITEM_NAME]
               ,SIM.[NICK_NAME]
               ,SIM.[ITEM_TYPE]
               ,SIM.[ITEM_CLASS_LEVEL_1]
               ,SIM.[ITEM_CLASS_LEVEL_2]
               ,SIM.[ITEM_CLASS_LEVEL_3]
               ,SIM.[ITEM_CLASS_LEVEL_4]
               ,SIM.[ITEM_CLASS]
               ,SIM.[ITEM_CLASS_NAME]
               ,SIM.[MATERIAL_CLASS]
               ,SIM.[MATERIAL_CLASS_NAME]
               ,SIM.[ELECTRODE_TYPE]
               ,SIM.[SIDE_TYPE]
               ,SIM.[ITEM_GROUP_ID]
               ,SIM.[SETUP_GROUP_ID_1]
               ,SIM.[SETUP_GROUP_ID_2]
               ,SIM.[SETUP_GROUP_ID_3]
               ,SIM.[FLOW_ID]
               ,SIM.[ERP_EOL]
               ,SIM.[SCP_EOL]
               ,SIM.[ITEM_UOM]
               ,SIM.[SPEC]
               ,SIM.[DEMAND_LOT_SIZE]
               ,SIM.[ITEM_ATTRIBUTE]
               ,SIM.[SETUP_ATTRIBUTE]
               ,SIM.[BATCH_RATIO_ID]
               ,SIM.[OUTSOURCING_FACTORY]
               ,SIM.[FINITE_TERM]
               ,SIM.[FINITE_TERM_UOM]
               ,SIM.[COATED_LENGTH]
               ,SIM.[UNCOATED_LENGTH]
               ,SIM.[LENGTH_UOM]
               ,SIM.[SLURRY_LOSS_RATE]
               ,SIM.[DESCRIPTION]
               ,SIM.[ACTIVE_FLAG]
               ,SIM.[UPDATE_ID]
               ,SIM.[UPDATE_TIME]
               ,SIM.[APPLIED_MODEL]
               ,SIM.[CELL_TYPE]
               ,SIM.[MAKE_AND_BUY]
               ,SIM.[COLOR_ATTRIBUTE]
               ,SIM.[FORMATION_FLOW_ID]
               ,SIM.[STANDARD_COST]
               ,SIM.[CURRENCY]
               ,SIM.[FORM_ATTRIBUTE]
               ,SIM.[ENERGE]
               ,SIM.[SCP_FLOW_ID]
               ,SIM.[SCP_OPERATION_GROUP]
               ,SIM.[SCP_OPERATION_GROUP_ID]
               ,SIM.[MDM_PROJECT_NAME]
               ,SIM.[MIN_CAPACITY]
               ,SIM.[MOBILE_MODEL_ID]
               ,SIM.[FORECAST_INFO_BIZ_TYPE]
               ,SIM.[FORECAST_INFO_PRODUCT_GROUP]
               ,SIM.[FORECAST_INFO_CELL_MODEL]
               ,SIM.[FORECAST_INFO_CELL_PACK_COUNT]
               ,SIM.[FORECAST_INFO_SPEC]
               ,SIM.[FORECAST_INFOR_VERSION]
               ,SIM.[DOE]
               ,SIM.[INSULATION_COATING]
               ,SIM.[PACK_PRODUCT_GROUP_CODE]
               ,SIM.[CELL_QUANTITY]
               ,SIM.[SCP_EXTRA_SPEC]
               ,SIM.[SCM_PIC]
               ,SIM.[REP_CUSTOMER]
               ,SIM.[MAKER]
               ,SIM.[EVAL_CLASS]
               ,SIM.[EVAL_CLASS_INFO]
               ,SIM.[FP_EXTRA_SPEC]
			   ,SIM.[MRP_USE_FLAG]
			   ,SIM.[MRP_USE_FLAG]
          FROM [dbo].[SCM_ITEM_M] SIM
            --INNER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  SLV WITH(NOLOCK)
            --ON   SLV.LOOKUP_TYPE_CODE = 'COMPANY_FP_SYSTEM_CODE'
            -- AND  SLV.SEGMENT1 = SIM.COMPANY_ID  -- 2023-07-27 kimcd lookup join 제거. 품목은 전체 법인 정보를 전송
            --AND  SLV.ACTIVE_FLAG = 'Y'
          WHERE  SIM.UPDATE_TIME > DATEADD( MI, -20, GETDATE())  --20분이내 변경데이타

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
