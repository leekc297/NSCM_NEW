
CREATE PROCEDURE [dbo].[PR_XIF_PLM_PRODUCTION_PLAN_S]
--ALTER PROCEDURE [dbo].[PR_XIF_PLM_PRODUCTION_PLAN_S]

-- ================================================================================================
-- Program ID          : FP03510
-- Program Name        : PR_XIF_PLM_PRODUCTION_PLAN_S
-- Param               :
-- Batch Period        : 15 Minute
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF
-- Source Table        : FP_DAILY_PRODUCTION_PLAN_R
-- Destination Table   : XIF_PLM_PRODUCTION_PLAN_S
--
-- Create(Update) Date : 2022.03.28
-- Update Date         : 2022.11.17  leeseongmin  5.15
--
-- Author              : piyong
-- Version             : 1.0  2018-11-28  piyong initial creation
--                       1.1  2022-03-28  kimcd  가상 Division 사용에 따른 수정
--                       1.2  2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
-- ================================================================================================

-- PARAM PLAN_ID
--@P_FP_PLAN_ID NVARCHAR(50) = NULL
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PLM_PRODUCTION_PLAN_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER	  = 0

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @if_id_code             NVARCHAR(50)  = 'OFP0_OPLM_DSV_FP_PLM_001'
	DECLARE @send_if_seq            NVARCHAR(50)
	DECLARE @send_date              NVARCHAR(50)
	DECLARE @if_seq_next            BIGINT

	DECLARE CUR_PLAN_ID CURSOR FOR
		SELECT A.INSTANCE_ID
			  ,A.RELEASE_PLAN_ID
			  ,A.PLAN_GROUP_ID
		FROM  (	SELECT A.INSTANCE_ID
					  ,A.RELEASE_PLAN_ID
					  ,A.PLAN_GROUP_ID
				FROM   DBO.SCM_FP_PLAN_GROUP_DETAIL_H A
				WHERE  MES_TRANSFER_FLAG = 'Y'
				AND    PLAN_DATE >= CONVERT(NVARCHAR(8), DATEADD(DD, -1, GETDATE()),112) 
				UNION ALL
				SELECT A.INSTANCE_ID
					  ,A.RELEASE_PLAN_ID
					  ,'-' AS PLAN_GROUP_ID
				FROM   DBO.SCM_FP_PLAN_DETAIL_H A
				WHERE  MES_TRANSFER_FLAG = 'Y'
				AND    PLAN_DATE >= CONVERT(NVARCHAR(8), DATEADD(DD, -1, GETDATE()),112)) A
		WHERE   NOT EXISTS (SELECT 1 
							FROM    [dbo].[SY_XIF_PLM_PRODUCTION_PLAN_S] B WITH(NOLOCK)
							WHERE   B.FP_PLAN_ID = A.RELEASE_PLAN_ID
							AND     B.INSTANCE_ID = A.INSTANCE_ID);

	DECLARE @INSTANCE_ID       NVARCHAR(30)      
	DECLARE @RELEASE_PLAN_ID   NVARCHAR(30)
	DECLARE @PLAN_GROUP_ID     NVARCHAR(30)
	-- ================================================
    -- Declare end
	-- ================================================

	SET @send_date = 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
--		SET @v_temp1 = 'DELETE [dbo].[SY_XIF_PLM_PRODUCTION_PLAN_S]'
--		DELETE FROM [dbo].[SY_XIF_PLM_PRODUCTION_PLAN_S]
--		WHERE  FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0');


		OPEN CUR_PLAN_ID
		FETCH NEXT FROM CUR_PLAN_ID INTO @INSTANCE_ID
										,@RELEASE_PLAN_ID
										,@PLAN_GROUP_ID
		WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN
			INSERT INTO [DBO].[SY_XIF_PLM_PRODUCTION_PLAN_S] 
				(
				  [IF_SEQ]
				  ,[IF_TYPE]
				  ,[IF_ID]
				  ,[IF_INS_DATE]
				  ,[IF_FLAG]
				  ,[IF_SND_DATE]
				  ,[INSTANCE_ID]
				  ,[FP_PLAN_ID]
				  ,[COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[WORK_ORDER_SPL_ID]
				  ,[WORK_ORDER_ID]
				  ,[PLAN_DATE]
				  ,[DEMAND_ID]
				  ,[ITEM_ID]
				  ,[TOP_ITEM_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[START_TIME]
				  ,[END_TIME]
				  ,[PLAN_QTY]
				  ,[PLAN_IN_QTY]
				  ,[ITEM_UOM]
				  ,[ROLL_IN_QTY]
				  ,[ROLL_OUT_QTY]
				  ,[PRODUCTION_TYPE]
				  ,[FP_PRODUCTION_TYPE]
				  ,[FIX_TYPE]
				  ,[TOTAL_WORKING_TIME]
				  ,[INSERT_ID]
				  ,[INSERT_DTTM]
				  ,[ATTRIBUTE1]   -- PLAN_GOUP_ID
				  ,[ATTRIBUTE2]   -- fp plan id별 전송 record count
				  ,[ATTRIBUTE3]   -- leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				  ,[ATTRIBUTE4]   -- leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				  ,[ATTRIBUTE5]   -- leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				  ,[ATTRIBUTE6]   -- leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				)
				SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
					   ,'I'            AS IF_TYPE
					   ,@if_id_code   AS IF_ID
					   ,GETDATE()     AS IF_INS_DATE
					   ,'N'           AS IF_FLAG
					   ,NULL          AS IF_SND_DATE
				       ,A.[INSTANCE_ID]
					   ,A.[FP_PLAN_ID]
					   ,A.[COMPANY_ID]
					   ,ISNULL(PD.ORIGINAL_DIVISION_ID, A.[DIVISION_ID]) -- 2022-03-28 kimcd 가상 Division 사용에 따른 로직 분기
					   ,A.[SITE_ID]
					   ,A.[PLANT_ID]
					   ,A.[FACTORY_ID]
					   ,A.[WORK_ORDER_SPL_ID]
					   ,A.[WORK_ORDER_ID]
					   ,A.[PLAN_DATE]
					   ,A.[DEMAND_ID]
					   ,A.[ITEM_ID]
					   ,A.[TOP_ITEM_ID]
					   ,A.[OPERATION_ID]
					   ,A.[LINE_ID]
					   ,A.[ELECTRODE_TYPE]
					   ,A.[START_TIME]
					   ,A.[END_TIME]
					   ,A.[PLAN_QTY]
					   ,A.[PLAN_IN_QTY]
					   ,A.[ITEM_UOM]
					   ,A.[ROLL_IN_QTY]
					   ,A.[ROLL_OUT_QTY]
					   ,A.[PRODUCTION_TYPE]
					   ,A.[FP_PRODUCTION_TYPE]
					   ,A.[FIX_TYPE]
					   ,A.[TOTAL_WORKING_TIME]
					   ,'PR_XIF_PLM_PRODUCTION_PLAN_S'  AS [INSERT_ID]
					   ,GETDATE() AS [INSERT_DTTM]
					   ,@PLAN_GROUP_ID -- ATTR_01 -- PLAN_GOUP_ID
				       ,COUNT(*) OVER (PARTITION BY FP_PLAN_ID) -- ATTR_02  fp plan id별 전송 record count
					   ,A.[WORK_REQUEST_MODEL_ID]   -- leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					   ,A.[VERSION]                 -- leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					   ,A.[PROD_SEQ]                -- leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					   ,A.[PLM_EC_NO]               -- leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리

				  FROM (
						SELECT PP.INSTANCE_ID
							  ,PP.FP_PLAN_ID
							  ,PP.COMPANY_ID
							  ,PP.DIVISION_ID
							  ,PP.SITE_ID
							  ,PP.PLANT_ID
							  ,PP.FACTORY_ID
							  ,PP.WORK_ORDER_SPL_ID
							  ,MAX(PP.WORK_ORDER_ID) AS WORK_ORDER_ID
							  ,PP.PLAN_DATE
							  ,MAX(PP.DEMAND_ID) AS DEMAND_ID
							  ,MAX(PP.ITEM_ID) AS ITEM_ID
							  ,MAX(PP.TOP_ITEM_ID) AS TOP_ITEM_ID
							  ,MAX(PP.OPERATION_ID) AS OPERATION_ID
							  ,MAX(PP.LINE_ID) AS LINE_ID
							  ,MAX(PP.ELECTRODE_TYPE) AS ELECTRODE_TYPE
							  ,MAX(PP.START_TIME) AS START_TIME
							  ,MAX(PP.END_TIME) AS END_TIME
							  ,SUM(PLAN_QTY)    AS PLAN_QTY
							  ,SUM(PLAN_IN_QTY) AS PLAN_IN_QTY
							  ,MAX(PP.ITEM_UOM) AS ITEM_UOM
							  ,SUM(PP.ROLL_IN_QTY)    AS ROLL_IN_QTY
							  ,SUM(PP.ROLL_OUT_QTY) AS ROLL_OUT_QTY
							  ,MAX(PP.PRODUCTION_TYPE) AS PRODUCTION_TYPE
							  ,MAX(PP.FP_PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE
							  ,MAX(PP.FIX_TYPE) AS FIX_TYPE
							  ,MAX(PP.TOTAL_WORKING_TIME) AS TOTAL_WORKING_TIME
							  ,MAX(WORK_REQUEST_MODEL_ID) AS WORK_REQUEST_MODEL_ID   -- leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							  ,MAX([VERSION]) AS [VERSION]                           -- leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							  ,MAX(PROD_SEQ) AS PROD_SEQ                             -- leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							  ,MAX(PLM_EC_NO) AS PLM_EC_NO                           -- leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						 FROM FP_DAILY_PRODUCTION_PLAN_R PP WITH(NOLOCK)
						WHERE PP.FP_PLAN_ID  = @RELEASE_PLAN_ID
						  AND PP.INSTANCE_ID = @INSTANCE_ID
						GROUP BY  PP.INSTANCE_ID
							  ,PP.FP_PLAN_ID
							  ,PP.COMPANY_ID
							  ,PP.DIVISION_ID
							  ,PP.SITE_ID
							  ,PP.PLANT_ID
							  ,PP.FACTORY_ID
							  ,PP.WORK_ORDER_SPL_ID
							  ,PP.PLAN_DATE
					   ) A
					LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-28 kimcd 가상 Division 로직 추가
						ON PD.PLANT_ID = A.PLANT_ID

			SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT

			FETCH NEXT FROM CUR_PLAN_ID INTO @INSTANCE_ID
											,@RELEASE_PLAN_ID
											,@PLAN_GROUP_ID

		END;  -- WHILE @@FETCH_STATUS = 0

        CLOSE CUR_PLAN_ID;
        DEALLOCATE CUR_PLAN_ID;   -- 메모리 해제
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
