
CREATE PROCEDURE [dbo].[PR_XIF_MES_TOTAL_BATCH_S]

-- ================================================================================================
-- Program ID          : FP02633
-- Program Name        : PR_XIF_MES_TOTAL_BATCH_S
-- Param               :
-- Batch Period        : 15 MINUTE
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF
-- Source Table        : FP_PRODUCTION_PLAN_BATCH_H
-- Destination Table   : XIF_MES_DAILY_PP_S
--
-- Create Date		   : 2019.08.23
-- Update Date		   : 2023.03.03
-- Author              : piyong
-- Version             : 1.0
--	                     1.1 2021-06-09 kimis ESNJ 6동 GMES DB 분리에 따른 변경
--                           동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
--                           라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
--                       1.2 2022-08-10 kimcd 설비 정보 필수 정보에서 제거
--                       1.3 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
--                       1.4 2023-03-03 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송
--                       1.5 2024-04-04 KIMJS NERP PLANT_ID 변경에 따른 CONVERSION 반영
--                       1.6 2025-09-18 CYS	  [E20250918-001592] PDS 버전 -자리수 조치 요청건
--						 1.7 2025-12-15   yschoithira	[E20251205-001628] ESMI4동 ESS, 자동차 라인 MES DB통합에 따른 기능개선 건
--                       1.8 2026-08-04 kimcd  [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
-- ================================================================================================

-- PARAM

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_TOTAL_BATCH_S'
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
	DECLARE @send_if_seq            NVARCHAR(50)
	DECLARE @send_date              NVARCHAR(50)
	DECLARE @if_seq_next            BIGINT
	DECLARE @local_time				NVARCHAR(20)

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

			INSERT INTO [dbo].[SY_XIF_MES_TOTAL_BATCH_S] (
				[IF_SEQ]
				  ,[IF_TYPE]
				  ,[IF_ID]
				  ,[IF_INS_DATE]
				  ,[IF_FLAG]
				  ,[IF_SND_DATE]
				  ,[PLANT_ID]
				  ,[BUILNO]
				  ,[LINE_ID]
				  ,[OPERATION_ID]
				  ,[EQUIPMENT_ID]
				  ,[TOP_ITEM_ID]
				  ,[ITEM_ID]
				  ,[PRODUCTION_TYPE]
				  ,[MARKET]
				  ,[PLAN_DATE]
				  ,[SEQ]
				  ,[TOTAL_BATCH]
				  ,[CREATE_PSN_ID]
				  ,[CREATE_DATE]
				  ,[UPDATE_PSN_ID]
				  ,[UPDATE_DATE]
				  ,ATTR_01  -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				  ,ATTR_02  -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				  ,ATTR_03  -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				  ,ATTR_04  -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
			)
							
			SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
			 --SELECT ''
				   ,'I'                -- IF_TYPE
				   --,'OFP0'+'_'+( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F WHERE F.FACTORY_ID = M.FACTORY_ID ) +'_FP_TOTAL_BATCH'    -- IF_ID
                   --2021-06-09 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
				   /* -- [E20251205-001628] LINE 기준으로 먼저 보고 View 기준으로 */
				   ,'OFP0'+'_'+ ISNULL( (SELECT ISNULL(L.MES_SOURCE_GROUP,ISNULL(F.MES_SOURCE_GROUP,'') ) 
						   				 FROM SCM_MMD_LINE_M L  WITH(NOLOCK) 
						   				 WHERE L.FACTORY_ID = M.FACTORY_ID 
										   AND L.LINE_ID = (ISNULL( ( SELECT TOP 1 C.MES_LINE_ID 
										   								FROM [dbo].[SCM_LINE_M] C (NOLOCK)  -- 2022-08-10 kimcd MES LINE 조회 기준을 라인으로 수정
													                   WHERE C.COMPANY_ID   = M.COMPANY_ID
														                 AND C.DIVISION_ID  = M.DIVISION_ID
														                 AND C.SITE_ID      = M.SITE_ID
														                 AND C.PLANT_ID     = M.PLANT_ID
																		 AND C.FACTORY_ID   = M.FACTORY_ID
														                 AND C.LINE_ID      = M.LINE_ID
														                 AND C.OPERATION_ID = M.OPERATION_ID
																		 AND C.ELECTRODE_TYPE = M.ELECTRODE_TYPE
																		 AND C.ACTIVE_FLAG  = 'Y' ), M.LINE_ID)) 
											), ( SELECT ISNULL(F.FCS_SOURCE_GROUP,'')
												FROM FP_MES_FACTORY_M_V F WITH(NOLOCK) 
												WHERE F.ORG_FACTORY_ID = M.FACTORY_ID)
										) +'_FP_TOTAL_BATCH'    -- IF_ID
				   ,GETDATE()          -- IF_INS_DATE
				   ,'N'                -- IF_FLAG
				   ,NULL               -- IF_SND_DATE
				   ,F.MES_PLANT_ID  -- 2024-04-04 NERP PLANT_ID 변경에 따른 CONVERSION 반영
				   ,F.FACTORY_ID				-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄	--,M.[FACTORY_ID]
				   ,M.[LINE_ID]
				   ,M.[OPERATION_ID]
				   ,M.[EQUIPMENT_ID]
				   ,M.[TOP_ITEM_ID]
				   ,M.[ITEM_ID]
			       ,M.[PRODUCTION_TYPE]
				   ,[MARKET]
				   ,CONVERT(NVARCHAR(8), M.PLAN_DATE, 112 )
   				   ,M.SEQ
				   ,[TOTAL_BATCH]
				   ,'PR_XIF_MES_TOTAL_BATCH_S' AS CREATE_PSN_ID
				   ,GETDATE() AS CREATE_DATE
				   ,'PR_XIF_MES_TOTAL_BATCH_S' AS UPDATE_PSN_ID
				   ,GETDATE() AS UPDATE_DATE
				   ,CASE WHEN M.[WORK_REQUEST_MODEL_ID] = '-' THEN NULL ELSE M.[WORK_REQUEST_MODEL_ID] END  AS [WORK_REQUEST_MODEL_ID] -- 2023-03-03 kimcd NJ 1동 FP 버전 전송 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				   ,CASE WHEN M.[VERSION] = '-' THEN NULL -- [E20250918-001592] PDS 적용 인스턴스에서 PLM 버전을 자르고 사용할 경우 예외 처리 PLM_VERSION_FLAG 으로 구분
					     -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_PDS_VERSION_M] outer join 추가. PDS VERSION table 우선 사용.
				   		 ELSE CASE WHEN F.ELEC_VERSION_TYPE = 'FP'  THEN M.[VERSION]
						           ELSE CASE WHEN ISNULL(X.PLM_VERSION_FLAG,'N') = 'N'
								   AND  ISNULL ( (  SELECT TOP 1 'Y'
													FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  SLVC WITH(NOLOCK)	
															INNER JOIN FP_INSTANCE_INFO_V FIIC 
															ON 1=1
															AND SLVC.SEGMENT1 = FIIC.INSTANCE_ID
															INNER JOIN FP_INSTANCE_FACTORY_M FIVC 
															ON 1=1
															AND SLVC.SEGMENT1 = FIVC.INSTANCE_ID
													WHERE 1=1
													AND SLVC.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
													AND SLVC.ACTIVE_FLAG = 'Y'
													AND FIVC.FACTORY_ID  = M.FACTORY_ID ), 'N') = 'Y' 
								   THEN ISNULL(PVM.[PDS_VERSION],M.[VERSION]) ELSE SUBSTRING(M.[VERSION],1,3) END 
								   END
				    END AS [VERSION] -- 2023-03-03 kimcd NJ 1동 FP 버전 전송 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				   ,M.PROD_SEQ               -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				   ,M.PLM_EC_NO              -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리													
			  FROM FP_PRODUCTION_PLAN_BATCH_H M
			       --INNER JOIN SCM_FACTORY_M F WITH(NOLOCK)
			  	   INNER JOIN FP_MES_FACTORY_M_V F WITH(NOLOCK)			-- [E20251205-001628] VIEW 변경 
				       ON F.ORG_FACTORY_ID = M.FACTORY_ID 	 -- [E20251205-001628] Column 변경 	-- 2023-03-03 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송
				   LEFT OUTER JOIN ( -- [E20250918-001592] ADD PLM 버전을 체크위함
										SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID, A.ITEM_ID, A.PROD_VERSION, X.PLM_VERSION_FLAG
										FROM FP_PROD_VERSION_M A WITH(NOLOCK)
												INNER JOIN (
															SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, ISNULL(A.ATTRIBUTE2, 'N') AS PLM_VERSION_FLAG
																	, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, C.FACTORY_ID
															FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  A WITH(NOLOCK)	
																	INNER JOIN FP_INSTANCE_INFO_V B 
																	ON 1=1
																	AND A.SEGMENT1 = B.INSTANCE_ID
																	INNER JOIN FP_INSTANCE_FACTORY_M C  WITH(NOLOCK)
																	ON 1=1
																	AND A.SEGMENT1 = C.INSTANCE_ID
															WHERE 1=1
															AND A.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
															AND A.ACTIVE_FLAG = 'Y'
															AND A.ATTRIBUTE2 = 'Y'		--PLM_VERSION_FLAG
															--AND A.SEGMENT1 IN ( SELECT DISTINCT INSTANCE_ID FROM SCM_FP_PLAN_H WHERE PLAN_ID =  '0' )
												) X
												ON 1=1
												AND A.COMPANY_ID	= X.COMPANY_ID
												AND A.DIVISION_ID	= X.DIVISION_ID
												AND A.SITE_ID		= X.SITE_ID
												AND A.PLANT_ID		= X.PLANT_ID
												AND A.FACTORY_ID	= X.FACTORY_ID
										WHERE 1=1
										AND A.INSERT_ID LIKE '%PLM_WO%'	-- PLM/PDS 버전 구분이 여의치 않아 insert id 로 처리 (추후 변경 필요)
									) X
					ON	1=1
					AND M.COMPANY_ID	= X.COMPANY_ID
					AND M.DIVISION_ID	= X.DIVISION_ID
					AND M.SITE_ID		= X.SITE_ID
					AND M.FACTORY_ID	= X.FACTORY_ID
					AND M.ITEM_ID		= X.ITEM_ID
					AND M.WORK_REQUEST_MODEL_ID	= X.MODEL_ID
					AND M.VERSION		= X.PROD_VERSION
				-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_PDS_VERSION_M] outer join 추가
                LEFT OUTER JOIN [dbo].[FP_PDS_VERSION_M]  PVM WITH(NOLOCK)
					ON 	PVM.[FACTORY_ID] = M.[FACTORY_ID]
					AND PVM.[MODEL_ID]   = M.[WORK_REQUEST_MODEL_ID]
					AND PVM.[VERSION]    = M.[VERSION]
			 WHERE M.UPDATE_TIME  >=  DATEADD ( MINUTE, -30,  GETDATE() )
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
