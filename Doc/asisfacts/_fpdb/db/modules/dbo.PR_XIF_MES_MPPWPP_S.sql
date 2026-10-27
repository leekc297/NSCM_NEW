
CREATE PROCEDURE [dbo].[PR_XIF_MES_MPPWPP_S]

-- ================================================================================================
-- Program ID          : FP01629
-- Program Name        : PR_XIF_MES_MPPWPP_S
-- Param               :
-- Batch Period        : 1DAY
-- Description         :
--
-- Source System       : FP
-- Destination System  : MES
-- Source Table        : FP_MPP_WPP_BASE_PLAN_H, FP_MPP_WPP_BASE_PLAN_M
-- Destination Table   : XIF_MES_MPPWPP_S, XIF_MES_MPPWPP_DETAIL_S
--
-- Create(Update) Date : 2023-03-03
-- Author              : PIYONG
-- Version             : 1.0
--                       1.1 2017-11-14 kimcd FP_MPP_WPP_BASE_PLAN_H.PLAN_GROUP_ID
--                                            FP_MPP_WPP_BASE_PLAN_M.MARKET
--                                            컬럼 추가에 따른 전송 컬럼 추가
--                       1.2 2019-01-18 kimcd 조립의 MPP WPP 계획을 전극 Plant에 전송. 전송 record count도 전송
--							 2019-08-27 PIYONG 전극 [ROLL_IN_QTY], [JR_IN_QTY], [CELL_IN_QTY], [BATCH_IN_QTY] 수량 추가
--                       1.3 2021-06-08 ESNJ 6동 GMES DB 분리에 따른 변경
--                           동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
--                           라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
--						 1.4 2022-03-28 kimcd 가상 Division 사용에 따른 보완
--						 1.5 2022-08-08 kimcd 설비 정보 Option화에 따른 수정
--						 1.6 2022-11-01 kimcd 전극 version, ec no 추가 전송
--                       1.7 2023-03-03 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송
--                       1.8 2024-04-03 KIMJS NERP PLANT_ID 변경에 따른 CONVERSION 반영 
--                       1.9 2024-09-18 CYS	  [E20250918-001592] PDS 버전 -자리수 조치 요청건
--						 2.0 2025-12-15	yschoithira	  	[E20251205-001628] ESMI4동 ESS, 자동차 라인 MES DB통합에 따른 기능개선 건
--                       2.1 2026-08-04 kimcd     [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_MPPWPP_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	--변수 설정
	DECLARE @MASTER_IF_SEQ		NVARCHAR(50)
	DECLARE @PLAN_WEEK			NVARCHAR(10)
	DECLARE @PLAN_REVISION		NVARCHAR(100)
	DECLARE @COMPANY_ID			NVARCHAR(30)
	DECLARE @DIVISION_ID		NVARCHAR(30)
	DECLARE @SITE_ID			NVARCHAR(30)
	DECLARE @PLANT_ID			NVARCHAR(30)
	DECLARE @FACTORY_ID			NVARCHAR(30)
	DECLARE @INSTANCE_ID		NVARCHAR(30)
	DECLARE @WPP				NVARCHAR(10)
	DECLARE @MPP				NVARCHAR(10)
	DECLARE @PLAN_DESCRIPTION	NVARCHAR(150)
	DECLARE @PLAN_GROUP_ID      NVARCHAR(30)   -- 2017-11-14 kimcd FP PLAN GROUP - 제품 특성 구분자 추가 전송

	-- FP_MPP_WPP_BASE_PLAN_H 테이블에서 2일전 데이터 중 XIF_MES_MPPWPP_S에 존재하지 않는 PLAN_REVISION 데이터 만 전송
	DECLARE CUR_PLAN CURSOR FOR
		SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
					  + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]))
					  + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)
			   ,M.PLAN_WEEK
			   ,M.PLAN_REVISION
			   ,M.COMPANY_ID
			   ,M.DIVISION_ID
			   ,M.SITE_ID
			   ,M.PLANT_ID
			   ,M.FACTORY_ID
			   ,M.INSTANCE_ID
			   ,M.WPP
			   ,M.MPP
			   ,M.PLAN_DESCRIPTION
			   ,M.PLAN_GROUP_ID  -- 2017-11-14 kimcd FP PLAN GROUP - 제품 특성 구분자 추가 전송
		  FROM [dbo].FP_MPP_WPP_BASE_PLAN_H M
		 WHERE M.UPDATE_TIME >   CAST( CONVERT(nvarchar(10), DATEADD( D, -2, GETDATE()), 120)+' 00:00:00'  AS DATETIME)
		   AND NOT EXISTS ( SELECT 1
							  FROM DBO.[SY_XIF_MES_MPPWPP_S] B
							 WHERE B.[PLAN_WEEK]     = M.[PLAN_WEEK]
							   AND B.[PLAN_REVISION] = M.[PLAN_REVISION]  -- PLAN WEEK + PLAN REVISION이 업무 기본 Table의 key
						  )

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================

			-- 실제 업무 Table의 정보를 삭제하면 안 됨.
			-- interface table만 삭제함..
			-- 1주일 만 유지
			DELETE FROM DBO.SY_XIF_MES_MPPWPP_DETAIL_S
			 WHERE IF_SND_DATE < CAST( CONVERT(nvarchar(10), DATEADD( D, -7, GETDATE()), 120)+' 00:00:00'  AS DATETIME)
			   AND IF_FLAG = 'Y'
									
			;

			-- 1주일 만 유지
			DELETE FROM DBO.SY_XIF_MES_MPPWPP_S
			 WHERE IF_SND_DATE <  CAST( CONVERT(nvarchar(10), DATEADD( D, -7, GETDATE()), 120)+' 00:00:00'  AS DATETIME)
			   AND IF_FLAG = 'Y'
			;


			--  최근 2일 데이터 가져와서 INF 테이블에 존재하지 않는 데이터만 전송
			OPEN CUR_PLAN;
			
			FETCH NEXT FROM CUR_PLAN INTO @MASTER_IF_SEQ
										  ,@PLAN_WEEK
										  ,@PLAN_REVISION
										  ,@COMPANY_ID
										  ,@DIVISION_ID
										  ,@SITE_ID
										  ,@PLANT_ID
										  ,@FACTORY_ID
										  ,@INSTANCE_ID
										  ,@WPP
										  ,@MPP
										  ,@PLAN_DESCRIPTION
										  ,@PLAN_GROUP_ID  -- 2017-11-14 kimcd FP PLAN GROUP - 제품 특성 구분자 추가 전송

			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					-- MASTER TABLE
					INSERT INTO [dbo].[SY_XIF_MES_MPPWPP_S]
						   ([IF_SEQ]
						   ,[IF_TYPE]
						   ,[IF_ID]
						   ,[IF_INS_DATE]
						   ,[IF_FLAG]
						   ,[IF_SND_DATE]
						   ,[PLAN_WEEK]
						   ,[PLAN_REVISION]
						   ,[COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[FACTORY_ID]
						   ,[INSTANCE_ID]
						   ,[WPP]
						   ,[MPP]
						   ,[PLAN_DESCRIPTION]
						   ,[INSERT_ID]
						   ,[INSERT_TIME]
						   ,[UPDATE_ID]
						   ,[UPDATE_TIME]
						   ,[ATTR_01])  -- 2017-11-14 kimcd FP PLAN GROUP - 제품 특성 구분자 추가 전송

					SELECT @MASTER_IF_SEQ   -- IF_SEQ
						   ,'S'
						   ,M.IF_ID
						   ,GETDATE()
						   ,'N'
						   ,GETDATE()
						   ,@PLAN_WEEK
						   ,@PLAN_REVISION
						   ,@COMPANY_ID
						   ,ISNULL(PD.ORIGINAL_DIVISION_ID, ISNULL(M.MES_DIVISION_ID, @DIVISION_ID))  -- [E20251205-001628] division 정보도 변경 됨 -- 2022-03-28 kimcd 가상 Division 로직 추가
						   ,@SITE_ID
						   ,M.MES_PLANT_ID  -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
						   ,ISNULL(M.MES_FACTORY_ID, @FACTORY_ID) -- [E20251205-001628] factory 정보도 변경 됨
						   ,@INSTANCE_ID
						   ,@WPP
						   ,@MPP
						   ,@PLAN_DESCRIPTION
						   ,'SYSTEM'
						   ,GETDATE()
						   ,'SYSTEM'
						   ,GETDATE()
						   ,@PLAN_GROUP_ID -- 2017-11-14 kimcd FP PLAN GROUP - 제품 특성 구분자 추가 전송
					--FROM   (SELECT DISTINCT 'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM DBO.SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = M.FACTORY_ID ),'') +'_'+'FP_MPPWPP' AS IF_ID
					--2021-06-09 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
					FROM   (    /* -- [E20251205-001628] LINE 기준으로 먼저 보고 View 기준으로 */
								SELECT DISTINCT 'OFP0'+'_'+ISNULL(	( SELECT ISNULL(L.MES_SOURCE_GROUP,(SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM FP_MES_FACTORY_M_V F WITH(NOLOCK) WHERE F.ORG_FACTORY_ID = M.FACTORY_ID)) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = M.FACTORY_ID 
										                                    AND L.LINE_ID = (ISNULL( (SELECT TOP 1 C.MES_LINE_ID FROM [dbo].[SCM_LINE_M] C WITH(NOLOCK)  -- 2022-08-08 kimcd 설비 정보 Option화에 LINE으로 테이블 수정
												                                               WHERE C.COMPANY_ID = @COMPANY_ID
													                                             AND C.DIVISION_ID = @DIVISION_ID
													                                             AND C.SITE_ID = @SITE_ID
													                                             AND C.PLANT_ID = @PLANT_ID
																								 AND C.FACTORY_ID = M.FACTORY_ID
													                                             AND C.LINE_ID = M.LINE_ID
													                                             AND C.OPERATION_ID = M.OPERATION_ID
																								 AND C.ACTIVE_FLAG = 'Y'), M.LINE_ID))
						       										), ISNULL( (SELECT	ISNULL(F.MES_SOURCE_GROUP,'') 
																				 FROM	FP_MES_FACTORY_M_V F WITH(NOLOCK) 
																				 WHERE	F.ORG_FACTORY_ID = M.FACTORY_ID )
						       													,'')) +'_'+'FP_MPPWPP' AS IF_ID
	                                   , F.MES_PLANT_ID  -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
	                                   , F.DIVISION_ID AS MES_DIVISION_ID	  -- [E20251205-001628] 
	                                   , F.FACTORY_ID  AS MES_FACTORY_ID	  -- [E20251205-001628] 
						         FROM  DBO.FP_MPP_WPP_BASE_PLAN_M  M WITH(NOLOCK)
								       INNER JOIN FP_MES_FACTORY_M_V F WITH(NOLOCK)		-- [E20251205-001628] VIEW 변경 
										  ON  F.COMPANY_ID 	   = M.COMPANY_ID
										 AND  F.ORG_FACTORY_ID = M.FACTORY_ID  			-- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영  -- [E20251205-001628] Column 변경 
	                            --INNER  JOIN SCM_FACTORY_M F WITH(NOLOCK)
	                            --   ON  F.COMPANY_ID = M.COMPANY_ID
	                            --  AND  F.FACTORY_ID = M.FACTORY_ID  -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
						        WHERE  PLAN_REVISION = @PLAN_REVISION
						          AND  PLAN_WEEK     = @PLAN_WEEK 
					          ) M -- 2017-11-14 kimcd FP PLAN GROUP 배포할 경우 대비 공장 정보 조회
						   LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-28 kimcd 가상 Division 로직 추가
								   ON PD.PLANT_ID = M.MES_PLANT_ID
								--ON PD.PLANT_ID = @PLANT_ID


					--DETAIL
					INSERT INTO [dbo].[SY_XIF_MES_MPPWPP_DETAIL_S] (
						[IF_SEQ]
						,[IF_TYPE]
						,[IF_ID]
						,[IF_INS_DATE]
						,[IF_FLAG]
						,[IF_SND_DATE]
						,[MASTER_IF_SEQ]
						,[PLAN_WEEK]
						,[PLAN_REVISION]
						,[COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[FACTORY_ID]
						,[LINE_ID]
						,[OPERATION_ID]
						,[EQUIPMENT_ID]
						,[PRODUCTION_TYPE]
						,[ITEM_ID]
						,[PLAN_DATE]
						,[PLAN_QTY]
						,[INSERT_ID]
						,[INSERT_TIME]
						,[UPDATE_ID]
						,[UPDATE_TIME]
						,[ATTR_01]			-- 2017-11-14 kimcd MARKET - 수출/내수 구분자 추가 전송
						,[ATTR_02]			-- 2019-01-18 kimcd plan week, plan revision, factory 기준 전송된 record count
						,[PANCAKE_IN_QTY]		-- 2019-08-27 PIYONG ADD	Pancake Meter 투입
						,[PANCAKE_OUT_QTY]		-- 2019-08-27 PIYONG ADD	Pancake Meter 완성
						,[BATCH_IN_QTY]		-- 2019-08-27 PIYONG ADD	Batch 투입 수
						,[BATCH_OUT_QTY]	-- 2019-08-27 PIYONG ADD	Batch 완성 수
						,[CELL_IN_QTY]		-- 2019-08-27 PIYONG ADD	Cell 환산 투입 수
						,[CELL_OUT_QTY]		-- 2019-08-27 PIYONG ADD	Cell 환산 완성 수
						,[JR_IN_QTY]		-- 2019-08-27 PIYONG ADD	Jumbo Roll 투입 수
						,[JR_OUT_QTY]		-- 2019-08-27 PIYONG ADD	Jumbo Roll 완성 수
						,[ATTR_03]	-- 작업의뢰서 모델
						,[ATTR_04]  -- 작업의뢰서 버전
						,[ATTR_05]	-- 작업의뢰서 버전별 차수
						,[ATTR_06]	-- PLM EC NO 2022-11-01 kimcd 전극 version, ec no 추가 전송
					)
					--2021-06-09 kimis ESNJ 6동 GMES DB 분리에 따른 변경
					SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
						   	  + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]))
						   	  + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
						   ,S.IF_TYPE
						   ,S.IF_ID
						   ,S.IF_INS_DATE
						   ,S.IF_FLAG
						   ,S.IF_SND_DATE
						   ,S.MASTER_IF_SEQ
						   ,S.PLAN_WEEK
						   ,S.PLAN_REVISION
						   ,S.COMPANY_ID
						   ,ISNULL(PD.ORIGINAL_DIVISION_ID, S.DIVISION_ID)  -- 2022-03-28 kimcd 가상 Division 로직 추가
						   ,S.SITE_ID
						   ,S.PLANT_ID
						   ,S.FACTORY_ID
						   ,S.LINE_ID
						   ,S.OPERATION_ID
						   ,S.EQUIPMENT_ID
						   ,S.PRODUCTION_TYPE
						   ,S.ITEM_ID
						   ,S.PLAN_DATE
						   ,S.PLAN_QTY
						   ,S.INSERT_ID
						   ,S.INSERT_TIME
						   ,S.UPDATE_ID
						   ,S.UPDATE_TIME
						   ,S.MARKET
						   ,COUNT(*) OVER (PARTITION BY S.IF_ID, S.FACTORY_ID ) --2021-06-09 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : IF_ID, FACTORY_ID 기준으로 COUNT
   						   ,S.ROLL_IN_QTY		
						   ,S.ROLL_QTY		
						   ,S.BATCH_IN_QTY	
						   ,S.BATCH_QTY		
						   ,S.CELL_IN_QTY		
						   ,S.CELL_QTY		
						   ,S.JR_IN_QTY		
						   ,S.JR_QTY			
						   ,S.[WORK_REQUEST_MODEL_ID]  -- ATTR_03	작업의뢰서 모델
						   ,S.[VERSION]    -- 2023-03-03 kimcd NJ 1동 FP 버전 전송  ATTR_04	작업의뢰서 버전
						   ,S.[PROD_SEQ]               -- ATTR_05	작업의뢰서 버전별 차수
						   ,S.[PLM_EC_NO]              -- ATTR_06	PLM EC NO 2022-11-01 kimcd 전극 version, ec no 추가 전송
					FROM
							( 
								SELECT --'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
								   --	  + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]))
								   --	  + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
								   'S' AS IF_TYPE
								   --,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM DBO.SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = M.FACTORY_ID ),'') +'_'+'FP_MPPWPP'
								   --2021-06-09 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
								    /* -- [E20251205-001628] LINE 기준으로 먼저 보고 View 기준으로 */
								   ,'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,ISNULL(F.MES_SOURCE_GROUP,'') ) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = M.FACTORY_ID 
											                                    AND L.LINE_ID = (ISNULL( (SELECT TOP 1 C.MES_LINE_ID FROM [dbo].[SCM_LINE_M] C -- 2022-08-08 kimcd 설비 정보 Option화에 LINE으로 테이블 수정
													                                               WHERE C.COMPANY_ID = @COMPANY_ID
														                                             AND C.DIVISION_ID = @DIVISION_ID
														                                             AND C.SITE_ID = @SITE_ID
														                                             AND C.PLANT_ID = @PLANT_ID
																									 AND C.FACTORY_ID = M.FACTORY_ID
														                                             AND C.LINE_ID = M.LINE_ID
														                                             AND C.OPERATION_ID = M.OPERATION_ID
																									 AND C.ACTIVE_FLAG = 'Y'), M.LINE_ID))
								     					),	ISNULL( (SELECT	ISNULL(F.MES_SOURCE_GROUP,'') 
																	 FROM	FP_MES_FACTORY_M_V F WITH(NOLOCK) 
																	 WHERE	F.ORG_FACTORY_ID = M.FACTORY_ID )
						       										,'')) +'_'+'FP_MPPWPP' AS IF_ID
								   ,GETDATE()        AS IF_INS_DATE
								   ,'N'              AS IF_FLAG
								   ,GETDATE()        AS IF_SND_DATE
								   ,@MASTER_IF_SEQ   AS MASTER_IF_SEQ
								   ,PLAN_WEEK
								   ,PLAN_REVISION
								   ,M.COMPANY_ID
								   ,F.DIVISION_ID	-- [E20251205-001628] 변경 된 DIVISION_ID 정보를 보냄	--,M.DIVISION_ID
								   ,M.SITE_ID
								   ,F.MES_PLANT_ID   AS PLANT_ID  -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
								   ,F.FACTORY_ID	-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄	--,M.FACTORY_ID
								   ,LINE_ID
								   ,OPERATION_ID
								   ,EQUIPMENT_ID
								   ,PRODUCTION_TYPE
								   ,M.ITEM_ID
								   ,PLAN_DATE
								   ,PLAN_QTY
								   ,'SYSTEM'         AS INSERT_ID
								   ,GETDATE()        AS INSERT_TIME
								   ,'SYSTEM'         AS UPDATE_ID
								   ,GETDATE()        AS UPDATE_TIME
								   ,MARKET -- 2017-11-14 kimcd MARKET - 수출/내수 구분자 추가 전송
								   --,COUNT(*) OVER (PARTITION BY FACTORY_ID) -- 2019-01-18 kimcd plan week, plan revision, factory 기준 전송된 record count
		   						   ,ROLL_IN_QTY		-- 2019-08-27 PIYONG ADD	Pancake Meter 투입
								   ,ROLL_QTY		-- 2019-08-27 PIYONG ADD	Pancake Meter 완성
								   ,BATCH_IN_QTY	-- 2019-08-27 PIYONG ADD	Batch 투입 수
								   ,BATCH_QTY		-- 2019-08-27 PIYONG ADD	Batch 완성 수
								   ,CELL_IN_QTY		-- 2019-08-27 PIYONG ADD	Cell 환산 투입 수
								   ,CELL_QTY		-- 2019-08-27 PIYONG ADD	Cell 환산 완성 수
								   ,JR_IN_QTY		-- 2019-08-27 PIYONG ADD	Jumbo Roll 투입 수
								   ,JR_QTY			-- 2019-08-27 PIYONG ADD	Jumbo Roll 완성 수
								   ,CASE WHEN M.[WORK_REQUEST_MODEL_ID] = '-' THEN NULL ELSE M.[WORK_REQUEST_MODEL_ID] END  AS [WORK_REQUEST_MODEL_ID] -- 2023-03-03 kimcd NJ 1동 FP 버전 전송 ATTR_03	작업의뢰서 모델
								   ,CASE WHEN M.[VERSION] = '-' THEN NULL -- [E20250918-001592] PDS 적용 인스턴스에서 PLM 버전을 자르고 사용할 경우 예외 처리 PLM_VERSION_FLAG 으로 구분
								         -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_PDS_VERSION_M] outer join 추가. PDS VERSION table 우선 사용.
								   		 ELSE CASE WHEN F.ELEC_VERSION_TYPE = 'FP' THEN M.[VERSION]
										           ELSE CASE WHEN ISNULL(X.PLM_VERSION_FLAG,'N') = 'N'
												   AND  ISNULL ( ( SELECT TOP 1 'Y'
																FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  A WITH(NOLOCK)	
																WHERE 1=1
																AND A.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
																AND A.ACTIVE_FLAG = 'Y'
																AND A.SEGMENT1    =  @INSTANCE_ID ), 'N') = 'Y' 
												   THEN ISNULL( PVM.[PDS_VERSION], M.[VERSION]) ELSE SUBSTRING(M.[VERSION],1,3) END 
												   END
								    END AS [VERSION] -- 2023-03-03 kimcd NJ 1동 FP 버전 전송 ATTR_04	작업의뢰서 버전
								   ,M.[PROD_SEQ]               -- ATTR_05	작업의뢰서 버전별 차수
								   ,M.[PLM_EC_NO]              -- ATTR_06	PLM EC NO 2022-11-01 kimcd 전극 version, ec no 추가 전송
							  FROM DBO.FP_MPP_WPP_BASE_PLAN_M  M WITH(NOLOCK)
							  		INNER JOIN FP_MES_FACTORY_M_V F WITH(NOLOCK)		-- [E20251205-001628] VIEW 변경 
									   ON  F.ORG_FACTORY_ID = M.FACTORY_ID  			-- 2023-03-03 kimcd NJ 1동은 FP 버전 그대로 전송  -- [E20251205-001628] Column 변경 
							       --INNER JOIN SCM_FACTORY_M F WITH(NOLOCK)
								   --    ON F.FACTORY_ID = M.FACTORY_ID  -- 2023-03-03 kimcd NJ 1동은 FP 버전 그대로 전송
								   LEFT OUTER JOIN (	-- [E20250918-001592] ADD PLM 버전을 체크위함
														SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID, A.ITEM_ID, A.PROD_VERSION, X.PLM_VERSION_FLAG
														FROM FP_PROD_VERSION_M A WITH(NOLOCK)
																INNER JOIN (
																			SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, ISNULL(A.ATTRIBUTE2, 'N') AS PLM_VERSION_FLAG
																					, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, C.FACTORY_ID
																			FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  A WITH(NOLOCK)	
																					INNER JOIN FP_INSTANCE_INFO_V B 
																					ON 1=1
																					AND A.SEGMENT1 = B.INSTANCE_ID
																					INNER JOIN FP_INSTANCE_FACTORY_M C 
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
							 WHERE PLAN_REVISION = @PLAN_REVISION
							   AND PLAN_WEEK = @PLAN_WEEK 
						) S
						LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-28 kimcd 가상 Division 로직 추가
							ON PD.PLANT_ID = S.PLANT_ID
					 ;

/*					-- 2019-01-18 kimcd winder, notching 계획을 전극 공장에도 전송 추가 시작
					-- MASTER TABLE
					INSERT INTO [dbo].[SY_XIF_MES_MPPWPP_S]
						   ([IF_SEQ]
						   ,[IF_TYPE]
						   ,[IF_ID]
						   ,[IF_INS_DATE]
						   ,[IF_FLAG]
						   ,[IF_SND_DATE]
						   ,[PLAN_WEEK]
						   ,[PLAN_REVISION]
						   ,[COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[FACTORY_ID]
						   ,[INSTANCE_ID]
						   ,[WPP]
						   ,[MPP]
						   ,[PLAN_DESCRIPTION]
						   ,[INSERT_ID]
						   ,[INSERT_TIME]
						   ,[UPDATE_ID]
						   ,[UPDATE_TIME]
						   ,[ATTR_01])  -- 2017-11-14 kimcd FP PLAN GROUP - 제품 특성 구분자 추가 전송
					SELECT @MASTER_IF_SEQ   -- IF_SEQ
						   ,'S'
						   ,M.IF_ID
						   ,GETDATE()
						   ,'N'
						   ,GETDATE()
						   ,@PLAN_WEEK
						   ,@PLAN_REVISION
						   ,@COMPANY_ID
						   ,@DIVISION_ID
						   ,@SITE_ID
						   ,@PLANT_ID
						   ,@FACTORY_ID
						   ,@INSTANCE_ID
						   ,@WPP
						   ,@MPP
						   ,@PLAN_DESCRIPTION
						   ,'SYSTEM'
						   ,GETDATE()
						   ,'SYSTEM'
						   ,GETDATE()
						   ,@PLAN_GROUP_ID -- 2017-11-14 kimcd FP PLAN GROUP - 제품 특성 구분자 추가 전송
					FROM   (SELECT DISTINCT 'OFP0'+'_'+ISNULL(F2.MES_SOURCE_GROUP,'') +'_'+'FP_MPPWPP' AS IF_ID
					        FROM   DBO.SCM_FACTORY_M  F2 WITH(NOLOCK)
								  ,DBO.SCM_FACTORY_M  F1 WITH(NOLOCK)
								  ,DBO.FP_MPP_WPP_BASE_PLAN_M  M WITH(NOLOCK)
					        WHERE  F2.COMPANY_ID   = F1.COMPANY_ID
							AND    F2.DIVISION_ID  = F1.DIVISION_ID
							AND    F2.SITE_ID      = F1.SITE_ID
							AND    F2.PLANT_ID    != F1.PLANT_ID
							AND    F1.COMPANY_ID   = M.COMPANY_ID
							AND    F1.DIVISION_ID  = M.DIVISION_ID
							AND    F1.SITE_ID      = M.SITE_ID
							AND    F1.PLANT_ID     = M.PLANT_ID
							AND    F1.FACTORY_ID   = M.FACTORY_ID
							AND    M.PLAN_REVISION = @PLAN_REVISION
					        AND    M.PLAN_WEEK     = @PLAN_WEEK
							AND    M.OPERATION_ID IN  ( SELECT SLV.SEGMENT1 
														FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														WHERE  SLV.LOOKUP_TYPE_CODE = 'FP_OPERATION'
														AND    ATTRIBUTE8 = 'Y') ) M -- 2017-11-14 kimcd FP PLAN GROUP 배포할 경우 대비 공장 정보 조회

					--DETAIL
					INSERT INTO [dbo].[SY_XIF_MES_MPPWPP_DETAIL_S]
							   ([IF_SEQ]
							   ,[IF_TYPE]
							   ,[IF_ID]
							   ,[IF_INS_DATE]
							   ,[IF_FLAG]
							   ,[IF_SND_DATE]
							   ,[MASTER_IF_SEQ]
							   ,[PLAN_WEEK]
							   ,[PLAN_REVISION]
							   ,[COMPANY_ID]
							   ,[DIVISION_ID]
							   ,[SITE_ID]
							   ,[PLANT_ID]
							   ,[FACTORY_ID]
							   ,[LINE_ID]
							   ,[OPERATION_ID]
							   ,[EQUIPMENT_ID]
							   ,[PRODUCTION_TYPE]
							   ,[ITEM_ID]
							   ,[PLAN_DATE]
							   ,[PLAN_QTY]
							   ,[INSERT_ID]
							   ,[INSERT_TIME]
							   ,[UPDATE_ID]
							   ,[UPDATE_TIME]
							   ,[ATTR_01] -- 2017-11-14 kimcd MARKET - 수출/내수 구분자 추가 전송
							   ,[ATTR_02] ) -- 2019-01-18 kimcd plan week, plan revision, factory 기준 전송된 record count
					SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
								  + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]))
								  + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
						   ,'S'
						   ,'OFP0'+'_'+ISNULL(A.MES_SOURCE_GROUP,'') +'_'+'FP_MPPWPP'
						   ,GETDATE()
						   ,'N'
						   ,GETDATE()
						   ,@MASTER_IF_SEQ
						   ,A.PLAN_WEEK
						   ,A.PLAN_REVISION
						   ,A.COMPANY_ID
						   ,A.DIVISION_ID
						   ,A.SITE_ID
						   ,A.PLANT_ID
						   ,A.FACTORY_ID
						   ,A.LINE_ID
						   ,A.OPERATION_ID
						   ,A.EQUIPMENT_ID
						   ,A.PRODUCTION_TYPE
						   ,A.ITEM_ID
						   ,A.PLAN_DATE
						   ,A.PLAN_QTY
						   ,'SYSTEM'
						   ,GETDATE()
						   ,'SYSTEM'
						   ,GETDATE()
						   ,A.MARKET -- 2017-11-14 kimcd MARKET - 수출/내수 구분자 추가 전송
						   ,COUNT(*) OVER (PARTITION BY A.FACTORY_ID) -- 2019-01-18 kimcd plan week, plan revision, factory 기준 전송된 record count
					FROM  ( SELECT DISTINCT 
								   F2.MES_SOURCE_GROUP
								  ,M.PLAN_WEEK
								  ,M.PLAN_REVISION
								  ,M.COMPANY_ID
								  ,M.DIVISION_ID
								  ,M.SITE_ID
								  ,M.PLANT_ID
								  ,M.FACTORY_ID
								  ,M.LINE_ID
								  ,M.OPERATION_ID
								  ,M.EQUIPMENT_ID
								  ,M.PRODUCTION_TYPE
								  ,M.ITEM_ID
								  ,M.PLAN_DATE
								  ,M.PLAN_QTY
								  ,M.MARKET
							FROM DBO.SCM_FACTORY_M  F2 WITH(NOLOCK)
							    ,DBO.SCM_FACTORY_M  F1 WITH(NOLOCK)
								,DBO.FP_MPP_WPP_BASE_PLAN_M  M WITH(NOLOCK)
							WHERE  F2.COMPANY_ID   = F1.COMPANY_ID
							AND    F2.DIVISION_ID  = F1.DIVISION_ID
							AND    F2.SITE_ID      = F1.SITE_ID
							AND    F2.PLANT_ID    != F1.PLANT_ID
							AND    F1.COMPANY_ID   = M.COMPANY_ID
							AND    F1.DIVISION_ID  = M.DIVISION_ID
							AND    F1.SITE_ID      = M.SITE_ID
							AND    F1.PLANT_ID     = M.PLANT_ID
							AND    F1.FACTORY_ID   = M.FACTORY_ID
							AND    M.PLAN_REVISION = @PLAN_REVISION
							AND    M.PLAN_WEEK     = @PLAN_WEEK
							AND    M.OPERATION_ID IN  ( SELECT SLV.SEGMENT1 
														FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														WHERE  SLV.LOOKUP_TYPE_CODE = 'FP_OPERATION'
														AND    ATTRIBUTE8 = 'Y') ) A
					 ;
					 -- 2019-01-18 kimcd winder, notching 계획을 전극 공장에도 전송 추가 끝
					 */
		
					FETCH NEXT FROM CUR_PLAN INTO @MASTER_IF_SEQ
												  ,@PLAN_WEEK
												  ,@PLAN_REVISION
												  ,@COMPANY_ID
												  ,@DIVISION_ID
												  ,@SITE_ID
												  ,@PLANT_ID
												  ,@FACTORY_ID
												  ,@INSTANCE_ID
												  ,@WPP
												  ,@MPP
												  ,@PLAN_DESCRIPTION
												  ,@PLAN_GROUP_ID -- 2017-11-14 kimcd FP PLAN GROUP - 제품 특성 구분자 추가 전송
					;

				END

				CLOSE CUR_PLAN;
				DEALLOCATE CUR_PLAN;

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
