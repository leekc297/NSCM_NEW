
                                                                                                                                                                                                                                                                     
CREATE           PROCEDURE [dbo].[PR_XIF_MES_WO_S_20251229]
                                                                                                                                                                                                                                                                     
-- ================================================================================================                                                                                                                                                                  
-- Program ID          : FP02020
-- Program Name        : PR_XIF_MES_WO_S                                                                                                                                                                                                                             
-- Param               :                                                                                                                                                                                                                                             
-- Batch Period        : 1 Day                                                                                                                                                                                                                                       
-- Description         :                                                                                                                                                                                                                                             
--                                                                                                                                                                                                                                                                   
-- Source System       : FP SDB                                                                                                                                                                                                                                      
-- Destination System  : INF                                                                                                                                                                                                                                     
-- Source Table        : FP_PRODUCTION_PLAN_EQUIPMENT_R                                                                                                                                                                                                              
-- Destination Table   : XIF_MES_WO_S                                                                                                                                                                                                                                
--                                                                                                                                                                                                                                                                   
-- Create(Update) Date : 2016.09.08
-- Update Date         : 2017.04.06  Version 2.1
--						 2017.04.07  Version 2.2
--						 2017.06.14  PIYONG 3.3
--					     2017.06.23  PIYONG 3.5
--					     2017.07.13  PIYONG 3.6
--						 2017.08.21  PIYONG 4.0
--						 2017.08.25	 PIYONG 4.1
--						 2017.09.28  PIYONG 4.2
--						 2017.10.19  PIYONG 4.3
--						 2017.10.18  PIYONG 5.0
--						 2017.11.21  PIYONG 5.1
--                       2018.03.06  kimcd  5.2
--                       2018.04.09  kimcd  5.3
--                       2018.04.28  kimcd  5.4
--                       2018.07.05  kimcd  5.5
--                       2018.07.25  kimcd  5.6
--						 2018.12.19  PIYONG 5.7
--                       2019.06.07  kimcd  5.8
--						 2019.06.10  PIYONG 5.9
--						 2019.07.18  PIYONG 5.91
--                       2019.10.01  kimcd  5.11
--                       2020.07.27  kimcd  5.12
--                       2021.06.16  kimis  5.13
--                       2022.07.30  kimcd  5.14
--                       2022.11.17  leeseongmin  5.15
--                       2023.03.02  kimcd  5.16

-- Author              : 김 석                                                                                                                                                                                                                                         
-- Version             : 1.1  kimcd add 'OFP0_OPLM_FP_WO' 작업지시서 생산 계획 전송 2017-01-03  
--						 2.1  piyong add OPERATION_ID CHEK 김춘동 차장님 요청으로 FP_PRODUCTION_PLAN_EQUIPMENT_R 테이블에서
--						                                   OPERATION_ID가 'E1000','E0500'일 경우 BATCH_ORDER_ID가 '-' 또는 NULL 확인
--														   조건에 참 이면 XIF_ERP_DW_LOG에 저장 거짓이면 데이터 전송
--                       2.2 W/O 검증을 위해 IF_FLAG X로 입력하도록 변경
--                       3.0 2017-04-09 when send work order to mes.. maintain mes work order master.
--                       3.1 FP-058 2017.05.24  Top W/O 복사 과정 추가. kimcd
--                       3.2 kimcd 실적 받는 Table을 수신 원천으로 변경
--						 3.3 실적 합산시 ADD_QTY 추가
--                       3.4 FP LINE 추가 전송 2017-06-16
--						 3.5 실적수량 조회시 ADD_QTY 삭제  양품 수량에 이미 포함되어 있음
--                       3.6 실적 실적 수량 조회 조건 추가
--						 4.0 엑셀업로드 구분 로직 추가
--							 PLM 전송 로직 주석
--						 4.1 SCM_MES_WIP_HISTORY_H 의 WIP_TYPE_CODE 조건에  PROD 추가
--						 4.2 계획수량이 0이고, PLANT_DATE가 미래일 경우 PLAN_DATE, START_TIME, END_TIME의 날짜를 GET_DATE()-1 변경
--						 4.3 SLIT_PLANT_ID 조회 조건 추가
--						 5.0 기 발행된 WO의 MES_SOURCE_GROUP 와 @P_FP_PLAN_ID의 MES_SOURCE_GROUP 가 다른 경우 기 발행한 WO를 삭제
--						 5.1 TOP_ITEM_ID  ATTR_12에 추가 정보 송신
--                       5.2 2018-03-06 kimcd work order id 채번 rule 변경에 따른 Top, Back work order id 연결 로직 수정
--                       5.3 2018-04-09 kimcd work order master에 FP PRODUCTION TYPE 정보 추가
--                       5.4 2018-04-28 kimcd work order master 관리하고 변경 사항이 있는 경우만 전송함.
--                       5.5 2018-07-05 kimcd VD용 최초 테스트 WO 컬럼 추가 - ATTRIBUTE14
--                                            한국 Cell S-TEST 노칭은 첫 테스트 WO로 표시
--                       5.6 2018-07-25 kimcd fp production type null 처리
--						 5.7 발생한 실적 수량의 양품만 적용
--                       5.8 2019-06-07 kimcd SCM_ITEM_M에 COMPANY_ID 조인 누락에 따른 오류 보완
--						 5.9 MES와 FP 실적 동기화 처리
--							 - WO 수량을 0으로 계획을 만들었으나 MES에서 이미 투입하여 실적이 발생했을 경우, 투입수량으로 WO 수량을 변경
--						 5.91 WO 수량 생성시 정수로 변경하는 로직(CEILING) 추가
--						 5.10 FMCS 에 ROLL (광폭 포함) 수량을 조회하기 위해 ATTR_15 -> JR_IN_QTY, ATTR_16 -> JR_OUT_QTY 추가 송신
--							  BATCH_SUM_QTY 데이터 정확성이 떨어져 송신 하지 않음
--                       5.11 2019-10-01 kimcd mes line 추출하는 로직에 factory_id 추가
--                       5.12 2020-07-27 kimcd mixer 공정의 ATTR_01(Total Batch), ATTR_03(Total Batch Kg) 전송 정보 제거
--                       5.13 2021-06-09 kimis ESNJ 6동 GMES DB 분리에 따른 변경
--                                       동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
--                                       라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
--                       5.14 2022-07-30 kimcd 설비 정보 Option 화에 따른 수정
--                       5.15 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
--                       5.16 2023-03-02 kimcd  NJ 전극의 경우 FP 전극 버전 그대로 전송
--                       5.2  2023-11-01 FP Pjt. 스마트 팩토리 핵심 IT 품질 시스템 구축_FP영역 / PDS 전송 추가 / ATTR_30 프로그램내에서만 사용
--                                         attr_18 elec/assy version 
--                       5.3  2024-04-03 KIMJS NERP PLANT_ID 변경에 따른 CONVERSION 반영 및 하드코딩 제거
--                       5.31 2024-11-20 CHKIM.68 SCM_CODE_LOOKUP_VALUE의 루프낭비이슈 (WA.FP 장애 -- 프로시저 처리 속도지연) 관련하여 OPERATION_ID 하드코딩 처리 원복)
--						 5.4  2025-09-18 yschoithira 	[E20250918-001409] PDS 버전 -자리수 조치 요청건
--						 5.5  2025-12-15 yschoithira	[E20251205-001628] ESMI4동 ESS, 자동차 라인 MES DB통합에 따른 기능개선 건
-- ================================================================================================                                                                                                                                                                  

-- PARAM PLAN_ID
@P_FP_PLAN_ID NVARCHAR(50) = NULL

AS 

BEGIN     
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                     
	-- LOG 용 변수 설정                                                                                                                                                                                                                                                   
	DECLARE @v_proc_name			NVARCHAR(100) = 'PR_XIF_MES_WO_S'                                                                                                                                                                                                            
	DECLARE @v_descr				NVARCHAR(250)                                                                                                                                                                                                                                
	DECLARE @v_count				INTEGER	  = 0                                                                                                                                                                                                                            
	DECLARE @sysdate				DATETIME     = GETDATE()  
	
	DECLARE @ROWCOUNT				INTEGER                                                                                                                                                                                                                  
									                                                                                                                                                                                                                                            
	-- ERROR_LINE					                                                                                                                                                                                                                                            
	DECLARE @v_temp1				NVARCHAR(1000)                                                                                                                                                                                                                               
	DECLARE @v_temp2				NVARCHAR(1000)                                                                                                                                                                                                                               
                                  
	-- ================================================                                                                                                                                                                                                              
    -- Declare start                                                                                                                                                                                                                                                 
	-- ================================================
	DECLARE @chk_operration			INTEGER	  = 0                                                                                                                                                                                                                
	DECLARE @PDS_IFSEQNO			NVARCHAR(50) 
                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                     
	-- ================================================                                                                                                                                                                                                              
    -- Declare end                                                                                                                                                                                                                                                   
	-- ================================================                                                                                                                                                                                                              
	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))                                                                                                                                                
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))                                                                                                                                                
                                                                                                                                                                                                                                                                     
	-- Start 로그는 무조건 남김                                                                                                                                                                                                                                              
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate                                                                                                                                
                                                                                                                                                                                                                                                                     
	BEGIN TRY				   
                                                             
		BEGIN TRAN    
		
		SET @PDS_IFSEQNO	= CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR [dbo].[XIF_PDS_SEQ]),10)
		-- ================================================                                                                                                                                                                                                          
		-- 로직 추가 start                                                                                                                                                                                                                                               
		-- ================================================   
		
			SET @chk_operration = ( SELECT COUNT(*)
								      FROM DBO.FP_PRODUCTION_PLAN_EQUIPMENT_R
								     --WHERE OPERATION_ID IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'OPERATION_MULTI' AND ACTIVE_FLAG = 'Y')  -- 2024-04-03 OPERATION_ID E0500, E1000 하드코딩 제거
									  WHERE OPERATION_ID IN ('E1000','E0500')--LOOKUP 제거
								       AND (BATCH_ORDER_ID = '-' OR BATCH_ORDER_ID IS NULL)
								       AND FP_PLAN_ID =  @P_FP_PLAN_ID );

			IF @chk_operration > 0
				BEGIN
					RAISERROR ('Error Slurry do not have batch order.', -- Message text.
							   16, -- Severity.
							   1 -- State.
							   );
				END;

            ----------------------------------------------------------------------------------------------------------------------------
			-- add start kimcd 2017-04-09 manage mes work order master
			SET @chk_operration = ( SELECT COUNT(*)
								      FROM DBO.FP_MES_PRODUCTION_PLAN_M A WITH(NOLOCK)
									      ,DBO.FP_PRODUCTION_PLAN_EQUIPMENT_R SOURCES WITH(NOLOCK)
								     WHERE A.[WORK_ORDER_SPL_ID] = SOURCES.[WORK_ORDER_SPL_ID]
			                         AND   A.[WORK_ORDER_ID]     = SOURCES.[WORK_ORDER_ID] 
				                     AND   SOURCES.[FP_PLAN_ID]  = ISNULL(@P_FP_PLAN_ID,'0')
									 AND   A.[ITEM_ID]          != SOURCES.[ITEM_ID]);

			IF @chk_operration > 0
				BEGIN
					RAISERROR ('Error at Work Order reschedule. item or batch order changed.', -- Message text.
							   16, -- Severity.
							   1 -- State.
							   );
				END;

			IF ( ISNULL(@chk_operration, 0) = 0 )
				BEGIN                                         
					DELETE FROM [dbo].[SY_XIF_MES_WO_S]
					 WHERE PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')

					--기 발행된 WO의 MES_SOURCE_GROUP 와신규 WO의 MES_SOURCE_GROUP가 다른 경우 기 발행한 WO를 삭제 로직 시작
					--------------------------------------------------------------------------------------------------------------------------------
					--------------------------------------------------------------------------------------------------------------------------------
					--------------------------------------------------------------------------------------------------------------------------------
					/*IF (SELECT COUNT(*)
						  FROM (
								SELECT B.IF_ID, B.WO, B.WO_DETAIL, B.BUILNO , E.FACTORY_ID, ROW_NUMBER() OVER( PARTITION BY B.WO ORDER BY IF_SEQ DESC) ROWNUMS
								       ,B.LINE_ID   --2021-06-16 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : MES LINE ID 추가  
								  FROM [DBO].[SY_XIF_MES_WO_S] B
								 INNER JOIN (
											 SELECT WORK_ORDER_ID AS WO, WORK_ORDER_SPL_ID AS WO_DETAIL , FACTORY_ID
											   FROM FP_PRODUCTION_PLAN_EQUIPMENT_R
											  WHERE FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
											 ) E
										  ON (B.WO = E.WO
 											  AND B.WO_DETAIL = E.WO_DETAIL											
											 )
								 WHERE IF_ID != 'OFP0_OPLM_FP_WO'
							   ) A
						 WHERE ROWNUMS  = 1
						   --2021-06-16 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
						   --AND A.IF_ID != ('OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = A.FACTORY_ID ),'') +'_'+'FP_WO')		) > 0 
						   AND A.IF_ID != ('OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,(SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = A.BUILNO)) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = A.BUILNO AND L.LINE_ID = A.LINE_ID ),'') +'_'+'FP_WO')		) > 0 

						BEGIN
						  
							INSERT INTO [DBO].[SY_XIF_MES_WO_S]
								([IF_SEQ]
								,[IF_TYPE]
								,[IF_ID]
								,[IF_INS_DATE]
								,[IF_FLAG]
								,[IF_SND_DATE]
								,[RSLT_IF_SEQ]
								,[RSLT_PROC_FLAG]
								,[RSLT_PROC_MSG]
								,[PLAN_ID]
								,[PLANT_ID]
								,[BUILNO]
								,[LINE_ID]
								,[OPERATION_ID]
								,[EQUIPMENT_ID]
								,[ITEM_ID]
								,[DEMAND_ID]
								,[WO]
								,[WO_TYPE]
								,[WO_DETAIL]
								,[PLAN_DATE]
								,[START_TIME]
								,[END_TIME]
								,[IN_QTY]
								,[OUT_QTY]
								,[IS_RELEASE]
								,[CREATE_PSN_ID]
								,[CREATE_DATE]
								,[UPDATE_PSN_ID]
								,[UPDATE_DATE]
								,[LANE_QTY]
								,[UNIT]
								,[ORDER_TYPE]
								,[BATCH_ORDER_ID]
								,[SLITTER_PLANT]
								,[MARKET]
								-- ,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
								,[ATTR_02]
								-- ,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
								,[ATTR_04]
								,[ATTR_05]
								,[ATTR_06]
								,[ATTR_07]
								,[ATTR_08]
								,[ATTR_09]
								,[ATTR_10]
								,[ATTR_11]
								,[ATTR_12] -- PIYONG 2017-11-21 TOP_ITEM_ID
							)
							SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
									,[IF_TYPE]
									--2021-06-16 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
									--,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = A.[BUILNO] ),'') +'_'+'FP_WO' -- [IF_ID]
									,[IF_ID] -- 기존 Interface ID 유지
									,GETDATE() -- [IF_INS_DATE] 2020-07-27 kimcd 전송 정보 형성일을 오늘로 입력
									,'X' --[IF_FLAG]
									,NULL -- 2017-11-07 PIYONG NULL 처리
									,NULL -- [RSLT_IF_SEQ]
									,NULL--[RSLT_PROC_FLAG]
									,NULL--[RSLT_PROC_MSG]
									,@P_FP_PLAN_ID AS [PLAN_ID]
									,[PLANT_ID]
									,[BUILNO]
									,[LINE_ID]
									,[OPERATION_ID]
									,[EQUIPMENT_ID]
									,[ITEM_ID]
									,[DEMAND_ID]
									,A.[WO]
									,[WO_TYPE]
									,A.[WO_DETAIL]
									,CASE WHEN A.PLAN_DATE > GETDATE() THEN									   -- 기 발생한 wo의 계획 일자가 현재보다 크면 과거 처리
											CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 00:00:00')
										  ELSE
											A.PLAN_DATE
										  END AS PLAN_DATE														--2017-11-08  PIYONG  변경
									,CASE WHEN A.PLAN_DATE > GETDATE() THEN									   -- 기 발생한 wo의 계획 일자가 현재보다 크면 시작일자를 과거 처리
											CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:00:00')
										   ELSE
											 A.START_TIME
										   END AS START_TIME													--2017-11-08  PIYONG  변경
									,CASE WHEN A.PLAN_DATE > GETDATE() THEN										-- 기 발생한 wo의 계획 일자가 현재보다 크면 시작일자를 과거 처리
											CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:10:00')
											  ELSE
											A.END_TIME
										  END AS END_TIME														--2017-11-08  PIYONG  변경
									,0  -- [IN_QTY]
									,0  -- [OUT_QTY]
									,[IS_RELEASE]
									,[CREATE_PSN_ID]
									,getdate() --[CREATE_DATE]
									,'PR_XIF_MES_WO_S_MANUAL_DEL' -- [UPDATE_PSN_ID]
									,getdate() --[UPDATE_DATE]
									,[LANE_QTY]
									,[UNIT]
									,[ORDER_TYPE]
									,[BATCH_ORDER_ID]
									,[SLITTER_PLANT]
									,[MARKET]
									-- ,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
									,[ATTR_02]
									-- ,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
									,[ATTR_04]
									,[ATTR_05]
									,[ATTR_06]
									,[ATTR_07]
									,[ATTR_08]
									,[ATTR_09]
									,[ATTR_10]
									,[ATTR_11]
									,[ATTR_12] -- PIYONG 2017-11-21 TOP_ITEM_ID
							   FROM ( 
									 SELECT SOURCES.*
								       FROM [DBO].[SY_XIF_MES_WO_S] SOURCES
								            ,(
												SELECT IF_SEQ
														, B.WO
														, B.WO_DETAIL
														, B.BUILNO AS FACTORY_ID
														, ROW_NUMBER() OVER( PARTITION BY B.WO ORDER BY IF_SEQ DESC) ROWNUMS
														, B.LINE_ID     --2021-06-16 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : MES LINE ID 추가
												   FROM [DBO].[SY_XIF_MES_WO_S] B
														INNER JOIN (SELECT WORK_ORDER_ID AS WO
																		   , WORK_ORDER_SPL_ID AS WO_DETAIL
																		   , FACTORY_ID
																	  FROM FP_PRODUCTION_PLAN_EQUIPMENT_R
																	WHERE FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
																	) E
																ON (B.WO = E.WO
 																	AND B.WO_DETAIL = E.WO_DETAIL											
																	)
												 WHERE B.IF_ID != 'OFP0_OPLM_FP_WO'
											) x
									  WHERE SOURCES.WO      = X.WO
										AND SOURCES.WO_DETAIL = X.WO_DETAIL
										AND SOURCES.IF_SEQ    = X.IF_SEQ
										AND X.ROWNUMS = 1
										--2021-06-16 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
										--AND SOURCES.IF_ID != ('OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = X.FACTORY_ID ),'') +'_'+'FP_WO')										
										AND SOURCES.IF_ID != ('OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,(SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = X.FACTORY_ID)) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = X.FACTORY_ID AND L.LINE_ID = X.LINE_ID ),'') +'_'+'FP_WO')										
									)A

						END*/
					--기 발행된 WO의 MES_SOURCE_GROUP 와신규 WO의 MES_SOURCE_GROUP가 다른 경우 기 발행한 WO를 삭제 로직 끝
					--------------------------------------------------------------------------------------------------------------------------------
					--------------------------------------------------------------------------------------------------------------------------------
					--------------------------------------------------------------------------------------------------------------------------------

					-- 신규 발행                                                                                                                                                                 
					INSERT INTO [dbo].[SY_XIF_MES_WO_S]
								 ( [IF_SEQ]                                                                                                                                                                                                                                  
								,[IF_TYPE]                                                                                                                                                                                                                                   
								,[IF_ID]                                                                                                   
								,[IF_INS_DATE]                                                                  
								,[IF_FLAG]                                                                                                                                                                                                                                   
								,[IF_SND_DATE]                                                                                                                                                                                                       
								,[RSLT_IF_SEQ]                                                                      
								,[RSLT_PROC_FLAG]                                                                                                                                                                                                                            
								,[RSLT_PROC_MSG]                                                                                                                                                                                                                             
								,[PLAN_ID]                                                                                                                                                                                                                                   
								,[PLANT_ID]                                                                                                                                                                                                                                  
								,[BUILNO]                                                                                                                                                                                                                                    
								,[LINE_ID]                                                                                                                                                                                                                                   
								,[OPERATION_ID]                                                                                                                                                                                                                              
								,[EQUIPMENT_ID]                                                                                                                                                                                                                              
								,[ITEM_ID]                                                                                                                                                                                                                                   
								,[DEMAND_ID]                                                                                                                                                                                                                                 
								,[WO]                                                                                                                                                                                                                                        
								,[WO_TYPE]                                                   
								,[WO_DETAIL]                                                                                                                                                                                                                                 
								,[PLAN_DATE]                                                                                         
								,[START_TIME]                                                                                                                                                                                                                                
								,[END_TIME]                                                                                      
								,[IN_QTY]                                                                                                                                                                                                                                    
								,[OUT_QTY]                                                  
								,[IS_RELEASE]                                                                                                                                      
								,[CREATE_PSN_ID]                                                                                                                                                                                                                             
								,[CREATE_DATE]                                                                                                                                                                                                                               
								,[UPDATE_PSN_ID]                                                                                                                                                                                                                             
								,[UPDATE_DATE]                                                                                                                                                                                                                               
								,[LANE_QTY]                                                                                                                                                                                                                                  
								,[UNIT]                                                                                                                                                                                                                                      
								,[ORDER_TYPE]    
								,[BATCH_ORDER_ID]
								,[SLITTER_PLANT]						                                                                                                                                                                                                                            
								-- ,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
								,[ATTR_02]                                                                                                                                                                                                                                   
								-- ,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
								,[ATTR_04]
								-- FP-058 부가 정보 전송 시작 kimcd 2017-05-25
								,[ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
								,[ATTR_06] -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
								,[ATTR_07] -- 연계된 Detail WO명 - TOP은 Back WO, Back은 TOP WO
								,[ATTR_08] -- FP Plan 수량
								,[ATTR_09] -- FP 실적 수량
								-- FP-058 부가 정보 전송 끝 kimcd 2017-05-25
								,[ATTR_10] -- kimcd 2017-06-16 fp line id
								,[ATTR_11] -- PIYONG 2017-08-21 PILOT 여부
								,[ATTR_12] -- PIYONG 2017-11-21 TOP_ITEM_ID
								,[ATTR_13] -- 2018-04-28 kimcd 테스트 수요용 work order 중 첫 공정 work order 구분자
								,[ATTR_14] -- 2018-07-05 kimcd VD 공정이 테스트 수요용 work order 중 첫 공정 work order 구분자
								,[ATTR_15] -- 2019-08-21 PIYONG ADD ROLL_INPUT_QTY
								,[ATTR_16] -- 2019-08-21 PIYONG ADD ROLL_END_QTY
								,[ATTR_17] -- WORK_REQUEST_MODEL_ID
								,[ATTR_18] -- VERSION
								,[ATTR_19] -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_20] -- PLM_EC_NO
								,[ATTR_30] -- @PDS_IFSEQNO
						)
						SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
						-- SELECT  ''
								,'S'   -- IF_TYPE     
								--2021-06-16 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영                                                                                                                                                                              
								--,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = D.FACTORY_ID ),'') +'_'+'FP_WO'
								,'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,ISNULL(F.MES_SOURCE_GROUP,'')) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = D.FACTORY_ID AND L.LINE_ID = D.MES_LINE_ID ), ISNULL(F.MES_SOURCE_GROUP,'')) +'_'+'FP_WO'	-- [E20251205-001628] 동/라인 정보가 다를 경우가 발생하여 최종 View MES_SOURCE_GROUP 사용
								-- 2023-03-02 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송하기 위해 FACTORY 조회 방식 변경
								,GETDATE()   -- IF_INS_DATE
								,'X'  -- IF_FLAG
								,NULL  -- IF_SND_DATE
								,NULL  -- RSLT_IF_SEQ
								,NULL  -- RSLT_PROC_FLAG
								,NULL  -- RSLT_PROC_MSG
								,D.FP_PLAN_ID  -- PLAN_ID
								,F.MES_PLANT_ID  -- PLANT_ID -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
								,F.FACTORY_ID  -- BUILNO	-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄
								,D.MES_LINE_ID
								,D.OPERATION_ID
								,D.EQUIPMENT_ID
								,D.ITEM_ID
								,D.DEMAND_ID
								,D.WORK_ORDER_ID
								,D.WO_TYPE
								,D.WORK_ORDER_SPL_ID
								,D.PLAN_DATE
								,D.START_TIME
								,D.END_TIME
								,D.IN_QTY
								,D.OUT_QTY
								,D.FIX_TYPE
								,'PR_XIF_MES_WO_S' AS CREATE_USER_ID
							   ,GETDATE() AS CREATE_DATE
							   ,'PR_XIF_MES_WO_S' AS MODIFY_USER_ID
							   ,GETDATE() AS MODIFY_DATE
								,D.LANE_QTY
								,D.ITEM_UOM
								,D.PRODUCTION_TYPE
								,D.BATCH_ORDER_ID
								,D.SLIT_PLANT_ID
								-- ,NULL AS BATCH_SUM_QTY 2020-07-27 kimcd total batch 수 정보 전송 제거 -- 2019-08-21 PIYONG CHANGE 데이터가 맞지않아서 전송하지 않음 D.BATCH_SUM_QTY -> NULL
								,D.BATCH_QTY
								-- ,D.ATTR_03 2020-07-27 kimcd total batch kg 정보 전송 제거
								,D.MARKET
								,D.TOP_BACK_IND
								,D.LINK_WO
								,D.DETAIL_LINK_WO
								,D.FP_PLAN_QTY
								,D.FP_SNAP_QTY
								,D.LINE_ID
								,D.PILOT_YN
								,D.TOP_ITEM_ID
								,D.ATTR_13
								,D.ATTR_14
								,D.JR_IN_QTY		-- 2019-08-21 PIYONG ADD
								,D.JR_OUT_QTY		-- 2019-08-21 PIYONG ADD
								,CASE WHEN D.WORK_REQUEST_MODEL_ID = '-' THEN NULL ELSE D.WORK_REQUEST_MODEL_ID END -- 2023-03-02 kimcd NJ 버전 예외 처리 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,CASE WHEN D.[VERSION] = '-' THEN NULL 
									  -- ELSE CASE WHEN F.ELEC_VERSION_TYPE = 'FP' THEN D.[VERSION] ELSE SUBSTRING(D.[VERSION],1,3) END 
									  ELSE CASE WHEN F.ELEC_VERSION_TYPE = 'FP' AND ISNULL(X.PLM_VERSION_FLAG,'N') = 'N' THEN D.[VERSION] ELSE SUBSTRING(D.[VERSION],1,3) END 
									  END -- VERSION	-- [E20250918-001409] PDS 적용 인스턴스에서 PLM 버전을 자르고 사용할 경우 예외 처리 PLM_VERSION_FLAG 으로 구분
								,D.PROD_SEQ               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,D.PLM_EC_NO   --	,case when f.shop_group_id = 'A' then D.[VERSION] else '-'  end as assy_version
								,@PDS_IFSEQNO
						  FROM (
								SELECT C.FP_PLAN_ID  -- PLAN_ID
										,C.PLANT_ID  -- PLANT_ID
										,C.FACTORY_ID  -- BUILNO
										,C.MES_LINE_ID
										,C.OPERATION_ID
										,C.EQUIPMENT_ID
										,C.ITEM_ID
										,C.DEMAND_ID
										,C.WORK_ORDER_ID
										,C.WO_TYPE
										,C.WORK_ORDER_SPL_ID
										,C.PLAN_DATE
										,C.START_TIME
										,C.END_TIME
										,CASE WHEN C.FP_PLAN_QTY = 0 THEN														-- 계획 수량이 0 이면
												CASE WHEN ISNULL(C.ATTRIBUTE9, 'N' ) = 'N' THEN									-- WO CLOSE 여부
														--2019-07-18 PIYONG ADD CEILING 
														CEILING( ISNULL(CAST(C.ATTRIBUTE10 AS NUMERIC(25,10)) , 0 ) * ISNULL((			-- MES 투입 수량 * 계획 일자 수율
																																SELECT [YIELD]
																																  FROM SCM_YIELD_M WITH(NOLOCK)
																																 WHERE [COMPANY_ID] = C.COMPANY_ID
																																   AND [DIVISION_ID] = C.DIVISION_ID
																																   AND [SITE_ID] = C.SITE_ID
																																   AND [PLANT_ID] = C.PLANT_ID
																																   AND [FACTORY_ID] = C.FACTORY_ID 
																																   AND [OPERATION_ID] = C.OPERATION_ID
																																   AND [LINE_ID] = C.LINE_ID
																																   AND [ITEM_ID] =C.ITEM_ID
																																   AND [MONTH] = (
																																					SELECT YEAR+MONTH
																																					  FROM [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK)
																																					 WHERE DATE_ID = C.PLAN_DATE
																																				)
																															 ), 1 )
																)
													 ELSE 0
													 END 
											  ELSE 
												C.IN_QTY
											  END IN_QTY
										,CASE WHEN C.FP_PLAN_QTY = 0 THEN
												CASE WHEN ISNULL(C.ATTRIBUTE9, 'N' ) = 'N' THEN 
														--2019-07-18 PIYONG ADD CEILING 
														CEILING( ISNULL(CAST(C.ATTRIBUTE10 AS NUMERIC(25,10)) , 0 ) * ISNULL((
																																SELECT [YIELD]
																																  FROM SCM_YIELD_M WITH(NOLOCK)
																																 WHERE [COMPANY_ID] = C.COMPANY_ID
																																   AND [DIVISION_ID] = C.DIVISION_ID
																																   AND [SITE_ID] = C.SITE_ID
																																   AND [PLANT_ID] = C.PLANT_ID
																																   AND [FACTORY_ID] = C.FACTORY_ID 
																																   AND [OPERATION_ID] = C.OPERATION_ID
																																   AND [LINE_ID] = C.LINE_ID
																																   AND [ITEM_ID] =C.ITEM_ID
																																   AND [MONTH] = (
																																					SELECT YEAR+MONTH
																																					  FROM [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK)
																																					 WHERE DATE_ID = C.PLAN_DATE
																																				)
																															 ), 1 )
																)
													 ELSE 0
													 END 
											  ELSE 
												C.OUT_QTY
											  END OUT_QTY
										,C.FIX_TYPE
										,C.LANE_QTY
										,C.ITEM_UOM
										,C.PRODUCTION_TYPE
										,C.BATCH_ORDER_ID
										,C.SLIT_PLANT_ID
										-- ,C.BATCH_SUM_QTY 2020-07-27 kimcd total batch 수 정보 전송 제거
										,C.BATCH_QTY
										-- ,C.ATTR_03 2020-07-27 kimcd total batch kg 정보 전송 제거
										,C.MARKET
										,C.TOP_BACK_IND
										,C.LINK_WO
										,C.DETAIL_LINK_WO
										,C.FP_PLAN_QTY
										,C.FP_SNAP_QTY
										,C.LINE_ID
										,C.PILOT_YN
										,C.TOP_ITEM_ID
										,C.ATTR_13
										,C.ATTR_14
										,C.ELECTRODE_TYPE
										,C.FP_PRODUCTION_TYPE
										,C.JR_IN_QTY			-- 2019-08-21 PIYONG ADD
										,C.JR_OUT_QTY			-- 2019-08-21 PIYONG ADD
										,C.WORK_REQUEST_MODEL_ID  -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
										,C.[VERSION]              -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
										,C.PROD_SEQ               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
										,C.PLM_EC_NO              -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								   FROM (
											SELECT SOURCES.FP_PLAN_ID  -- PLAN_ID
												   ,SOURCES.COMPANY_ID
												   ,SOURCES.DIVISION_ID
												   ,SOURCES.SITE_ID
												   ,SOURCES.PLANT_ID  -- PLANT_ID
												   ,SOURCES.FACTORY_ID  -- BUILNO
												--,LINE_ID  -- LINE_ID
												   ,CASE WHEN SOURCES.INSTANCE_ID = 'KR_PACK' THEN SOURCES.LINE_ID
														 WHEN SOURCES.B_ATTRIBUTE1 IS NOT NULL THEN
															(
																SELECT TOP 1 ISNULL(CASE WHEN C.MES_LINE_ID = '' THEN NULL ELSE C.MES_LINE_ID END, SOURCES.LINE_ID) FROM [dbo].[SCM_LINE_M] C WITH(NOLOCK)  -- 2022-07-30 kimcd 설비 정보 Option 화에 따라 기준 Table을 Line으로 변경
																 WHERE C.COMPANY_ID = SOURCES.B_ATTRIBUTE1
																   AND C.DIVISION_ID = SOURCES.B_ATTRIBUTE2
																   AND C.SITE_ID = SOURCES.SITE_ID
																   AND C.PLANT_ID = SOURCES.B_ATTRIBUTE3
																   AND C.LINE_ID = SOURCES.LINE_ID
																   AND C.OPERATION_ID = SOURCES.OPERATION_ID
																   AND C.ELECTRODE_TYPE = SOURCES.ELECTRODE_TYPE
															)
														 ELSE (
																ISNULL(SOURCES.MES_LINE_ID
																, (SELECT TOP 1 ISNULL(CASE WHEN C.MES_LINE_ID = '' THEN NULL ELSE C.MES_LINE_ID END, SOURCES.LINE_ID) FROM [dbo].[SCM_LINE_M] C WITH(NOLOCK)  -- 2022-07-30 kimcd 설비 정보 Option 화에 따라 기준 Table을 Line으로 변경
																 WHERE C.COMPANY_ID = SOURCES.COMPANY_ID
																   AND C.DIVISION_ID = SOURCES.DIVISION_ID
																   AND C.SITE_ID = SOURCES.SITE_ID
																   AND C.PLANT_ID = SOURCES.PLANT_ID
																   AND C.FACTORY_ID = SOURCES.FACTORY_ID -- 2019-10-01 kimcd 동 정보 검증 추가
																   AND C.LINE_ID = SOURCES.LINE_ID
																   AND C.OPERATION_ID = SOURCES.OPERATION_ID
																   AND C.ELECTRODE_TYPE = SOURCES.ELECTRODE_TYPE))
															  )
														 END AS MES_LINE_ID                                                                                                                                                                                                                        
												   ,SOURCES.OPERATION_ID  -- OPERATION_ID                                                                                                                                                                                                        
												   ,SOURCES.EQUIPMENT_ID  -- EQUIPMENT_ID                                                                                                                                                                                                        
												   ,SOURCES.ITEM_ID  -- ITEM_ID                                                                                                                                                                                                                  
												   ,SOURCES.DEMAND_ID  -- DEMAND_ID                                              
												   ,SOURCES.WORK_ORDER_ID  -- WO                                                                                                                                                                                                                 
												   ,CASE WHEN SOURCES.ORDER_TYPE = 'W' THEN 'WO'                                                                                 
														 WHEN SOURCES.ORDER_TYPE = 'M' THEN 'MO'                                                                                                                                                                                                 
														 END  AS  WO_TYPE                                                                                                                                                                                                                      
												   ,SOURCES.WORK_ORDER_SPL_ID  -- WO_DETAIL    
												   ,CASE WHEN SOURCES.PLAN_DATE > GETDATE() AND SOURCES.PLAN_IN_QTY = 0 THEN -- 계획 일자가 과거이고 계획 수량이 0 이면 계획 일자를 과거 처리
															CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 00:00:00')
														 ELSE
															CONVERT(NVARCHAR(50), SOURCES.PLAN_DATE, 120) 
														 END AS PLAN_DATE              --2017-09-28  PIYONG  변경
												   ,CASE WHEN SOURCES.PLAN_DATE > GETDATE() AND SOURCES.PLAN_IN_QTY = 0 THEN -- 계획 일자가 과거이고 계획 수량이 0 이면 시작 일자를 과거 처리
															CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:00:00')
														 ELSE
															CONVERT(NVARCHAR(50), SOURCES.START_TIME, 120) 
														 END AS START_TIME             --2017-09-28  PIYONG  변경
												   ,CASE WHEN SOURCES.PLAN_DATE > GETDATE() AND SOURCES.PLAN_IN_QTY  = 0 THEN -- 계획 일자가 과거이고 계획 수량이 0 이면 종료 일자를 과거 처리
															CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:10:00')
														 ELSE
															CONVERT(NVARCHAR(50), SOURCES.END_TIME, 120) 
														 END AS END_TIME              --2017-09-28  PIYONG  변경
												   ,SOURCES.IN_QTY
												   ,SOURCES.OUT_QTY
												   ,SOURCES.FIX_TYPE                                                                                                                                                                                                            
												   ,SOURCES.LANE_QTY  -- LANE_QTY                                                                                                                                                                                                                
												   ,SOURCES.ITEM_UOM
												   ,SOURCES.PRODUCTION_TYPE  -- ORDER_TYPE
												   ,SOURCES.[BATCH_ORDER_ID]
												   ,SOURCES.[SLIT_PLANT_ID]
												   -- ,SOURCES.BATCH_SUM_QTY  2020-07-27 kimcd total batch 수 정보 전송 제거 -- ATTR_01 BATCH ORDER 기준 BATCH 수
												   ,SOURCES.BATCH_QTY      -- ATTR_02 WORK ORDER 기준 W/O별 BATCH 수                                                                                                                                                                                                                    
												   -- 2020-07-27 kimcd total batch kg 정보 전송 제거
												   -- ,CASE WHEN SOURCES.BATCH_ORDER_ID != '-' THEN 
													--		SUM(SOURCES.PLAN_IN_QTY) OVER (PARTITION BY SOURCES.BATCH_ORDER_ID)
													--	 END  AS ATTR_03 --  BATCH ORDER 별 계획 수량의 합   
												   ,ISNULL(SOURCES.MARKET,'D') AS MARKET	--   170208 Add                                                                                                                                                                                                                  
												   ,SOURCES.TOP_BACK_IND					-- ATTR_05 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
												   ,SOURCES.LINK_WO							-- ATTR_06 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
												   ,SOURCES.DETAIL_LINK_WO					-- ATTR_07 연계된 Detail WO명 - TOP은 Back WO, Back은 TOP WO
												   ,SOURCES.PLAN_QTY AS FP_PLAN_QTY			-- ATTR_08 FP Plan 수량  아웃 수량 기준으로 변경 PLAN_IN_QTY -> PLAN_QTY
												   ,SOURCES.FP_SNAP_QTY						-- ATTR_09 FP 실적 수량 kimcd add end 2017-06-03
												   ,SOURCES.LINE_ID							-- ATTR_10 kimcd 2017-06-16 fp line id
												   ,SOURCES.PILOT_YN
												   ,SOURCES.TOP_ITEM_ID						--PIYONG 2017-11-21 추가
												   ,CASE WHEN MWSX.[WORK_ORDER_SPL_ID] IS NULL THEN   --  2018-07-05 kimcd 한국 Cell S-TEST 노칭은 첫 테스트 WO로 표시
															(  SELECT TOP 1 'Y'
																 FROM SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
																WHERE SLV.LOOKUP_TYPE_CODE = 'FIRST_TEST_WO'
																  AND SLV.SEGMENT1         = SOURCES.INSTANCE_ID
																  AND SLV.SEGMENT2         = SOURCES.FP_PRODUCTION_TYPE
																  AND SLV.SEGMENT3         = SOURCES.OPERATION_ID
																  AND SLV.ACTIVE_FLAG      = 'Y'
															)
														 ELSE 
															MWSX.ATTRIBUTE6
														 END AS ATTR_13-- 2018-04-28 kimcd 테스트 수요용 work order 중 첫 공정 work order 구분자
												   ,MWSX.ATTRIBUTE7 AS ATTR_14 -- 2018-07-05 kimcd VD용 최초 테스트 WO 컬럼 추가 - ATTRIBUTE14
												   ,SOURCES.FP_PRODUCTION_TYPE
												   ,SOURCES.ELECTRODE_TYPE
						   						   ,MWSX.ATTRIBUTE9					-- 2019-06-10 PIYONG ADD MES WO CLOSE 여부
												   ,MWSX.ATTRIBUTE10				-- 2019-06-10 PIYONG ADD MES WO 투입 수량
												   ,SOURCES.JR_IN_QTY				-- 2019-08-21 PIYONG ADD
												   ,SOURCES.JR_OUT_QTY				-- 2019-08-21 PIYONG ADD
												   ,SOURCES.WORK_REQUEST_MODEL_ID   -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												   ,SOURCES.[VERSION]               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												   ,SOURCES.PROD_SEQ                -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												   ,SOURCES.PLM_EC_NO               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리

											  FROM (
													 SELECT SOURCES.INSTANCE_ID
															,SOURCES.COMPANY_ID
															,SOURCES.DIVISION_ID
															,SOURCES.SITE_ID
															,SOURCES.FP_PLAN_ID  -- PLAN_ID                                                                                                                                                                                                               
															,SOURCES.PLANT_ID  -- PLANT_ID                                                                                                                                                                                                                
															,SOURCES.FACTORY_ID  -- BUILNO                                                                                                                                                                                                                
															,B.ATTRIBUTE1   AS B_ATTRIBUTE1
															,B.ATTRIBUTE2   AS B_ATTRIBUTE2
															,B.ATTRIBUTE3   AS B_ATTRIBUTE3
															,SOURCES.OPERATION_ID  -- OPERATION_ID                                                                                                                                                                                                        
															,SOURCES.EQUIPMENT_ID  -- EQUIPMENT_ID   
															,SOURCES.ELECTRODE_TYPE                                                                                                                                                                                                     
															,SOURCES.ITEM_ID  -- ITEM_ID                                                                                                                                   
															,SOURCES.DEMAND_ID  -- DEMAND_ID                                                                                                                                                                                                              
															,SOURCES.WORK_ORDER_ID  -- WO                                                                                       
															,SOURCES.ORDER_TYPE                                                                                                                                                                                                                  
															,SOURCES.WORK_ORDER_SPL_ID  -- WO_DETAIL    
															,SOURCES.PLAN_IN_QTY
															,SOURCES.PLAN_QTY				--2019-06-10 PIYONG ADD
															,SOURCES.PLAN_DATE             --2017-09-28  PIYONG  변경
															,SOURCES.START_TIME             --2017-09-28  PIYONG  변경
															,SOURCES.END_TIME             --2017-09-28  PIYONG  변경
															,SOURCES.PLAN_QTY +  ( SELECT ISNULL( SUM(ISNULL(W.WIPQTY2_ED,0))  -- 2018-12-19 PIYONG 완성수량을 IN 수량 컬럼에 전송
																							--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_DFCT_QTY2),0))		--2018-12-19 PIYONG DEL
																							--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_LOSS_QTY2),0))		--2018-12-19 PIYONG DEL
																							--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_PRDT_REQ_QTY2),0))	--2018-12-19 PIYONG DEL
																							--	+ SUM(ISNULL(CAST(W.SCRAP_QTY AS NUMERIC(14,3)),0))				--2018-12-19 PIYONG DEL
																								,0)
																					 FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK)
																					WHERE W.WOID   = SOURCES.WORK_ORDER_ID
																					  AND W.PROCID = SOURCES.OPERATION_ID
																					  AND W.WIP_TYPE_CODE in ( 'OUT','INOUT','PACKED', 'PROD') -- PIYONG 2017-08-25 PROD 추가
																					  AND W.WO_DETL_ID = SOURCES.WORK_ORDER_SPL_ID
																				  )								AS IN_QTY
															,SOURCES.PLAN_QTY    +  ( SELECT ISNULL( SUM(ISNULL(W.WIPQTY2_ED,0))
																							--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_DFCT_QTY2),0))		--2018-12-19 PIYONG DEL
																							--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_LOSS_QTY2),0))		--2018-12-19 PIYONG DEL
																							--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_PRDT_REQ_QTY2),0))	--2018-12-19 PIYONG DEL
																							--	+ SUM(ISNULL(CAST(W.SCRAP_QTY AS NUMERIC(14,3)),0))				--2018-12-19 PIYONG DEL
																								,0)
																						FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK)
																					   WHERE W.WOID   = SOURCES.WORK_ORDER_ID
																						 AND W.PROCID = SOURCES.OPERATION_ID
																						 AND W.WIP_TYPE_CODE in ( 'OUT','INOUT','PACKED', 'PROD') -- PIYONG 2017-08-25 PROD 추가
																						 AND W.WO_DETL_ID = SOURCES.WORK_ORDER_SPL_ID
																					)							AS OUT_QTY
															,CASE WHEN SOURCES.FIX_TYPE = 'F' THEN 'Y'
																  WHEN SOURCES.FIX_TYPE = 'N' THEN 'Y'
																  WHEN SOURCES.FIX_TYPE = 'P' THEN '-'
																  ELSE FIX_TYPE 
																  END											AS FIX_TYPE                                                                                                                                                                                                            
															,SOURCES.LANE_QTY  -- LANE_QTY                                                                                                                                                                                                                
															,IM.ITEM_UOM
															,SOURCES.PRODUCTION_TYPE  -- ORDER_TYPE
															,SOURCES.[BATCH_ORDER_ID]
															-- SLIT_PLANT_ID 를 구하는 로직 변경 req by kcd 170412                                                                                                       
															--,CASE WHEN SOURCES.[OPERATION_ID] IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'OPERATION_A' AND ACTIVE_FLAG = 'Y') THEN  -- 2024-04-03 OPERATION_ID E2000 하드코딩 제거
															,CASE WHEN SOURCES.[OPERATION_ID] ='E2000' THEN--하드코딩 원복
																	ISNULL( (
																				SELECT TOP 1 F.MES_PLANT_ID  -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
																				  FROM [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] Z
                                                                                 INNER JOIN SCM_FACTORY_M F WITH(NOLOCK)
                                                                                    ON Z.COMPANY_ID = F.COMPANY_ID
                                                                                   AND Z.FACTORY_ID = F.FACTORY_ID
																				 --WHERE Z.OPERATION_ID IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'OPERATION_B' AND ACTIVE_FLAG = 'Y')  -- 2024-04-03 OPERATION_ID E4000 하드코딩 제거
																				 WHERE Z.OPERATION_ID = 'E4000' -- 하드코딩 원복
																				   AND Z.COMPANY_ID   = SOURCES.COMPANY_ID
																				   AND Z.DIVISION_ID  = SOURCES.DIVISION_ID
																				   AND Z.SITE_ID      = SOURCES.SITE_ID
																				   AND Z.ITEM_ID      = SOURCES.ITEM_ID 
																				 ORDER BY Z.INSERT_TIME DESC 
																			),(
																				SELECT TOP 1 F.MES_PLANT_ID  -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
																				  FROM [DBO].[SCM_ITEM_LINE_ASSIGN_M] ILA WITH(NOLOCK)
                                                                                 INNER JOIN SCM_FACTORY_M F WITH(NOLOCK)
                                                                                    ON ILA.COMPANY_ID = F.COMPANY_ID
                                                                                   AND ILA.FACTORY_ID = F.FACTORY_ID
																				 --WHERE ILA.OPERATION_ID IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'OPERATION_B' AND ACTIVE_FLAG = 'Y')  -- 2024-04-03 OPERATION_ID E4000 하드코딩 제거
																				 WHERE ILA.OPERATION_ID = 'E4000'  -- 2024-04-03 OPERATION_ID E4000 하드코딩 제거
																				   AND ILA.COMPANY_ID   = SOURCES.COMPANY_ID
																				   AND ILA.DIVISION_ID  = SOURCES.DIVISION_ID
																				   AND ILA.SITE_ID      = SOURCES.SITE_ID
																				   AND ILA.ITEM_ID      = SOURCES.ITEM_ID 
																				   AND ILA.ACTIVE_FLAG = 'Y'
																				   AND ILA.PRIORITY != 9           --2017-10-19 PIYONG ADD
																				   AND ILA.MONTH >= CONVERT(NVARCHAR(6), GETDATE(),112)      --2017-10-19 PIYONG ADD
																				 ORDER BY CASE WHEN EQP.PLANT_ID = ILA.PLANT_ID THEN 1 ELSE 2 END --2017-10-19 PIYONG ADD
																						,ILA.INSERT_TIME DESC
																			)
																		  )
																  ELSE NULL END  AS [SLIT_PLANT_ID]
															-- ,SOURCES.BATCH_SUM_QTY   2020-07-27 kimcd total batch 수 정보 전송 제거 -- ATTR_01 BATCH ORDER 기준 BATCH 수                                                                                                                                                                                                            
															,SOURCES.BATCH_QTY      -- ATTR_02 WORK ORDER 기준 W/O별 BATCH 수                                                                                                                                                                                                                    
															,SOURCES.MARKET   -- ATTR_04  170208 Add                                                                                                                                                                                                                  
															,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
																	'B'
																  END AS TOP_BACK_IND -- ATTR_05 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
															,RTRIM ( CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
																			CASE WHEN SOURCES.WORK_ORDER_ID LIKE 'W%' OR SOURCES.WORK_ORDER_ID LIKE 'M%' THEN
																					SUBSTRING(SOURCES.WORK_ORDER_ID,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WORK_ORDER_ID,6,2)) + 50) + SUBSTRING(SOURCES.WORK_ORDER_ID,8,10)
																				WHEN SUBSTRING(SOURCES.WORK_ORDER_ID,9,1) = '0' THEN
																					CASE WHEN SUBSTRING(SOURCES.WORK_ORDER_ID,6,1) = 'X' THEN
																							SUBSTRING(SOURCES.WORK_ORDER_ID,1,5) + 'Y' + SUBSTRING(SOURCES.WORK_ORDER_ID,7,10)
																						ELSE
																							SUBSTRING(SOURCES.WORK_ORDER_ID,1,4) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WORK_ORDER_ID,5,2)) + 50) + SUBSTRING(SOURCES.WORK_ORDER_ID,7,10)
																						END
																				ELSE
																					CASE WHEN SUBSTRING(SOURCES.WORK_ORDER_ID,7,1) = 'X' THEN
																						SUBSTRING(SOURCES.WORK_ORDER_ID,1,6) + 'Y' + SUBSTRING(SOURCES.WORK_ORDER_ID,8,10)
																					ELSE
																						SUBSTRING(SOURCES.WORK_ORDER_ID,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WORK_ORDER_ID,6,2)) + 50) + SUBSTRING(SOURCES.WORK_ORDER_ID,8,10)
																					END
																				END -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 TOP, Back 로직 WO 로직 수정
																		  END) AS LINK_WO      -- ATTR_06 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
															,RTRIM ( CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
																			CASE WHEN SOURCES.WORK_ORDER_SPL_ID LIKE 'W%' OR SOURCES.WORK_ORDER_SPL_ID LIKE 'M%' THEN
																					SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,6,2)) + 50) + SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,8,10)
																				 WHEN SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,9,1) = '0' THEN
																					CASE WHEN SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,6,1) = 'X' THEN
																						SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,1,5) + 'Y' + SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,7,10)
																					ELSE
																						SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,1,4) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,5,2)) + 50) + SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,7,10)
																					END
																				 ELSE
																					CASE WHEN SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,7,1) = 'X' THEN
																						SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,1,6) + 'Y' + SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,8,10)
																					ELSE
																						SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,6,2)) + 50) + SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,8,10)
																					END
																				 END -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 TOP, Back 로직 WO 로직 수정
																			END
																												) AS DETAIL_LINK_WO		-- ATTR_07 연계된 Detail WO명 - TOP은 Back WO, Back은 TOP WO
															,( SELECT ISNULL( SUM(ISNULL(W.WIPQTY2_ED,0))
																	--	  + SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_DFCT_QTY2),0))		--2018-12-19 PIYONG DEL 
																	--	  + SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_LOSS_QTY2),0))		--2018-12-19 PIYONG DEL 
																	--	  + SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_PRDT_REQ_QTY2),0))	--2018-12-19 PIYONG DEL
																	--	  + SUM(ISNULL(CAST(W.SCRAP_QTY AS NUMERIC(14,3)),0))			--2018-12-19 PIYONG DEL
																			,0)
																 FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK)
																WHERE W.WOID   = SOURCES.WORK_ORDER_ID
																  AND W.PROCID = SOURCES.OPERATION_ID
																  AND W.WIP_TYPE_CODE in ( 'OUT','INOUT','PACKED', 'PROD') -- PIYONG 2017-08-25 PROD 추가
																  AND W.WO_DETL_ID = SOURCES.WORK_ORDER_SPL_ID
																												) AS FP_SNAP_QTY		-- ATTR_09 FP 실적 수량 kimcd add end 2017-06-03
															-- FP-058 kimcd 추가 끝. 2017-05-24                                                                                                                                                                                                               
															,SOURCES.LINE_ID  -- ATTR_10 kimcd 2017-06-16 fp line id
															--PIYONG 2017-08-21 4.0 엑셀업로드 구분
															,CASE WHEN INSTANCE_ID = 'KR_CELL_M_P' THEN 'Y' END AS PILOT_YN
															,SOURCES.TOP_ITEM_ID  --PIYONG 2017-11-21 추가
															,ISNULL(SOURCES.FP_PRODUCTION_TYPE, SOURCES.PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE -- 2018-07-25 KIMCD FP PRODUCTION TYPE NULL 처리
															,SOURCES.JR_IN_QTY		-- 2019-08-21 PIYONG ADD
															,SOURCES.JR_OUT_QTY		-- 2019-08-21 PIYONG ADD
															,EQP.MES_LINE_ID
															,SOURCES.WORK_REQUEST_MODEL_ID  -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															,SOURCES.[VERSION]              -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															,SOURCES.PROD_SEQ               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															,SOURCES.PLM_EC_NO              -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													   FROM FP_PRODUCTION_PLAN_EQUIPMENT_R SOURCES WITH(NOLOCK)
													   LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  B WITH(NOLOCK)
																	ON B.LOOKUP_TYPE_CODE = 'BOM_ADD_FOR_RES_SHARE'
																   AND B.SEGMENT1         = SOURCES.PLANT_ID
																   AND B.ACTIVE_FLAG      = 'Y'
															-- FP-058 kimcd 추가 시작. 2017-05-24 
													   LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M]  EQP WITH(NOLOCK)
																	ON EQP.EQUIPMENT_ID = SOURCES.EQUIPMENT_ID
																   AND EQP.OPERATION_ID = SOURCES.OPERATION_ID
																   AND EQP.FACTORY_ID   = SOURCES.FACTORY_ID
																   AND EQP.EQUIPMENT_TYPE = 'M'
																   AND EQP.ACTIVE_FLAG    = 'Y'
													   LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  EQPC WITH(NOLOCK)
																	ON EQPC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_OP'
																   AND EQPC.SEGMENT1         = EQP.OPERATION_ID
																   AND EQPC.SEGMENT2         = EQP.COATER_EQPT_TYPE_CODE
																   AND EQPC.ACTIVE_FLAG      = 'Y'
													   LEFT OUTER JOIN [DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
																	ON IM.DIVISION_ID  = SOURCES.DIVISION_ID
																   AND IM.SITE_ID      = SOURCES.SITE_ID
																   AND IM.ITEM_ID      = SOURCES.ITEM_ID
																   AND IM.COMPANY_ID   = SOURCES.COMPANY_ID -- 2019-06-07 kimcd error fix.
													   LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  IMC WITH(NOLOCK)
																	ON IMC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_ITEM_CLASS'
																   AND IMC.SEGMENT1         = IM.ITEM_CLASS
																   AND IMC.ACTIVE_FLAG      = 'Y'
															-- FP-058 kimcd 추가 끝. 2017-05-24 
													  WHERE SOURCES.FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
													  AND SOURCES.PLAN_DATE > DATEADD(DAY, -7, GETDATE())	--@@@ 한달 전 수율 적용이 안되어 전송 구간 조정
																													 ) SOURCES
											  LEFT OUTER JOIN DBO.FP_MES_PRODUCTION_PLAN_M MWSX WITH(NOLOCK)  -- 2018-07-05 kimcd VD용 최초 테스트 WO 컬럼 추가하기 위해 OUTER JOIN으로 변경
														   ON MWSX.[WORK_ORDER_ID]     = SOURCES.WORK_ORDER_ID
														  AND MWSX.[WORK_ORDER_SPL_ID] = SOURCES.WORK_ORDER_SPL_ID
									   ) C
							   ) D
							   INNER JOIN FP_MES_FACTORY_M_V AS F		-- [E20251205-001628] VIEW 변경 
							   ON F.ORG_FACTORY_ID = D.FACTORY_ID 		
							   --INNER JOIN SCM_FACTORY_M AS F
							   --ON F.FACTORY_ID = D.FACTORY_ID -- 2023-03-02 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송
							   LEFT OUTER JOIN (		-- [E20250918-001409] ADD PLM 버전을 체크위함
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
																		AND A.SEGMENT1 IN ( SELECT DISTINCT INSTANCE_ID FROM SCM_FP_PLAN_H  WITH(NOLOCK) WHERE PLAN_ID =  ISNULL(@P_FP_PLAN_ID,'0') )
															) X
															ON 1=1
															AND A.COMPANY_ID = X.COMPANY_ID
															AND A.DIVISION_ID = X.DIVISION_ID
															AND A.SITE_ID = X.SITE_ID
															AND A.PLANT_ID = X.PLANT_ID
															AND A.FACTORY_ID = X.FACTORY_ID
													WHERE 1=1
													AND A.INSERT_ID LIKE '%PLM_WO%'	-- PLM/PDS 버전 구분이 여의치 않아 insert id 로 처리 (추후 변경 필요)
												) X
								ON	1=1
								AND D.PLANT_ID		= X.PLANT_ID
								AND D.FACTORY_ID	= X.FACTORY_ID
								AND D.ITEM_ID		= X.ITEM_ID
								AND D.WORK_REQUEST_MODEL_ID	= X.MODEL_ID
								AND D.VERSION		= X.PROD_VERSION
						 WHERE NOT EXISTS (
										    SELECT 1
											  FROM DBO.FP_MES_PRODUCTION_PLAN_M MWS WITH(NOLOCK)
											 WHERE MWS.[WORK_ORDER_ID]			= D.WORK_ORDER_ID
											   AND MWS.[WORK_ORDER_SPL_ID]		= D.WORK_ORDER_SPL_ID
											   AND ISNULL(MWS.BATCH_ORDER_ID,'-') = ISNULL( D.BATCH_ORDER_ID,'-') 
											   AND ISNULL(MWS.LANE_QTY, 0)   = ISNULL( D.LANE_QTY,0) 
											   AND MWS.LINE_ID					= D.LINE_ID  
											   AND MWS.OPERATION_ID				= D.OPERATION_ID
											   AND ISNULL(MWS.ELECTRODE_TYPE, '-') = ISNULL( D.ELECTRODE_TYPE, '-')
											   AND MWS.EQUIPMENT_ID				= D.EQUIPMENT_ID
											   AND MWS.START_TIME				= D.START_TIME
											   AND MWS.END_TIME					= D.END_TIME
											   AND MWS.PLAN_QTY					= D.OUT_QTY
											   AND MWS.PLAN_IN_QTY				= D.IN_QTY
											   AND MWS.PRODUCTION_TYPE			= D.PRODUCTION_TYPE
											   AND MWS.MARKET					= D.MARKET
											   AND ISNULL(MWS.ATTRIBUTE3, '-')	= ISNULL(D.PILOT_YN, '-')-- PILOT 여부
											   AND ISNULL(MWS.ATTRIBUTE4, '-')	= ISNULL(D.TOP_ITEM_ID, '-')-- TOP ITEM ID
											   AND ISNULL(MWS.ATTRIBUTE5, '-')	= D.FP_PRODUCTION_TYPE -- FP Demand Type
											   AND MWS.WORK_REQUEST_MODEL_ID    = D.WORK_REQUEST_MODEL_ID    -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											   AND MWS.[VERSION]                = D.[VERSION]                -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											   AND ISNULL(MWS.PROD_SEQ, '-')    = ISNULL(D.PROD_SEQ, '-')    -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											   AND MWS.PLM_EC_NO                = D.PLM_EC_NO                -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
										 )
							--AND  EXISTS (	--@@@
							--				SELECT 1
							--				  FROM DBO.FP_MES_PRODUCTION_PLAN_M MWS WITH(NOLOCK)
							--				 WHERE MWS.[WORK_ORDER_ID]	= D.WORK_ORDER_ID
							--				   AND MWS.START_TIME		> DATEADD(DAY, -7, GETDATE())
							--			)
		
					SET @ROWCOUNT = @@ROWCOUNT

					--  FP-058 kimcd 추가 시작. 2017-05-24 
					INSERT INTO [dbo].[SY_XIF_MES_WO_S]                                                                                                   
								 ( [IF_SEQ]                                                                                                                                                                                                                                  
								,[IF_TYPE]                                                      
								,[IF_ID]                                                                                                                                                                                                                                     
								,[IF_INS_DATE]                                                                                                                                                                                                                               
								,[IF_FLAG]                                                                                                                                                                                                                                   
								,[IF_SND_DATE]                                                                                                                                     
								,[RSLT_IF_SEQ]         
								,[RSLT_PROC_FLAG]                                                                                                                         
								,[RSLT_PROC_MSG]                                                                                                        
								,[PLAN_ID]                                                                                                                                                                                                                                   
								,[PLANT_ID]                                                                                                                                                                                                                                  
								,[BUILNO]                                                                                                                                                                                                                                    
								,[LINE_ID]                                                                                                                                                                                                                                   
								,[OPERATION_ID]                                                                                                                                                                                                                              
								,[EQUIPMENT_ID]                                                                                                                                                                                                                              
								,[ITEM_ID]                                                   
								,[DEMAND_ID]                                                                                                                                                                                                                                 
								,[WO]                                                                                                                                                                                                                                        
								,[WO_TYPE]                                                                             
								,[WO_DETAIL]                                                                                                                                                                                                                                 
								,[PLAN_DATE]                                                                                                                                                                                                                                 
								,[START_TIME]                                                                                                                                                                                                                                
								,[END_TIME]      
								,[IN_QTY]                                                                                                                                                                                                                                    
								,[OUT_QTY]                                                                                                                                                                                                                                   
								,[IS_RELEASE]                     
								,[CREATE_PSN_ID]                                                                                                     
								,[CREATE_DATE]                                                                                                                                                                                                                               
								,[UPDATE_PSN_ID]                                                                                                                                                                               
								,[UPDATE_DATE]                                                                                                                                                                                                                               
								,[LANE_QTY]                                                                                                                                                                                                                                  
								,[UNIT]   
								,[ORDER_TYPE]    
								,[BATCH_ORDER_ID]
								,[SLITTER_PLANT]
								,[ATTR_01]
								,[ATTR_02]
								,[ATTR_03]
								,[ATTR_04]
								,[ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
								,[ATTR_06] -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
								,[ATTR_07] -- 연계된 Detail WO명 - TOP은 Back WO, Back은 TOP WO
								,[ATTR_08] -- FP Plan 수량
								,[ATTR_09] -- FP 실적 수량
								,[ATTR_10] -- fp line id
								,[ATTR_12] -- TOP_ITEM_ID
								,[ATTR_13] -- 2018-04-28 kimcd 테스트 수요용 work order 중 첫 공정 work order 구분자
								,[ATTR_14] -- 2018-07-05 kimcd VD 공정이 테스트 수요용 work order 중 첫 공정 work order 구분자
								,[ATTR_15] -- 2019-08-21 PIYONG ADD ROLL_INPUT_QTY
								,[ATTR_16] -- 2019-08-21 PIYONG ADD ROLL_END_QTY
								,[ATTR_17] -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_18] -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_19] -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_20] -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_30] -- @PDS_IFSEQNO
					)
					SELECT       'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
								,[IF_TYPE]
								,[IF_ID]
								,[IF_INS_DATE]
								,[IF_FLAG]
								,[IF_SND_DATE]
								,[RSLT_IF_SEQ]
								,[RSLT_PROC_FLAG]
								,[RSLT_PROC_MSG]
								,[PLAN_ID]
								,[PLANT_ID]
								,[BUILNO]
								,[LINE_ID]
								,[OPERATION_ID]
								,[EQUIPMENT_ID]
								,[ITEM_ID]
								,[DEMAND_ID]
								,[ATTR_06] -- [WO]
								,[WO_TYPE]
								,[ATTR_07] -- [WO_DETAIL]
								,[PLAN_DATE]
								,[START_TIME]
								,[END_TIME]
								,[IN_QTY]
								,[OUT_QTY]
								,[IS_RELEASE]
								,[CREATE_PSN_ID]
								,[CREATE_DATE]
								,[UPDATE_PSN_ID]
								,[UPDATE_DATE]
								,[LANE_QTY]
								,[UNIT]
								,[ORDER_TYPE]
								,[BATCH_ORDER_ID]
								,[SLITTER_PLANT]					                                                                                                                                                                                                                            
								,[ATTR_01]
								,[ATTR_02]
								,[ATTR_03]
								,[ATTR_04]
								,'T'          -- [ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
								,[WO]         -- [ATTR_06] -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
								,[WO_DETAIL]  -- [ATTR_07] -- 연계된 Detail WO명 - TOP은 Back WO, Back은 TOP WO
								,[ATTR_08] -- FP Plan 수량
								,[ATTR_09] -- FP 실적 수량
								,[ATTR_10] -- fp line id
								,[ATTR_12] -- TOP_ITEM_ID
								,[ATTR_13] -- 2018-04-28 kimcd 테스트 work order 중 첫번째 work order 구분자
								,[ATTR_14] -- 2018-07-05 kimcd VD 공정이 테스트 수요용 work order 중 첫 공정 work order 구분자
								,[ATTR_15] -- 2019-08-21 PIYONG ADD ROLL_INPUT_QTY
								,[ATTR_16] -- 2019-08-21 PIYONG ADD ROLL_END_QTY
								,[ATTR_17] -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_18] -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_19] -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_20] -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,@PDS_IFSEQNO
					FROM   [dbo].[SY_XIF_MES_WO_S] WITH(NOLOCK)
					WHERE  PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
					AND    ATTR_05 = 'B'

					SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
					--  FP-058 kimcd 추가 끝. 2017-05-24 


			-- PDS 전송
			INSERT INTO SY_XIF_PDS_WO_S
                        ( [IF_SEQ]                                                                             
						, [IF_TYPE]                                                                                                                                                                                                                                   
						, [IF_ID]                                                                                                                                                                                                                                     
						, [IF_INS_DATE]                                                                                                                                                                                                                               
						, [IF_FLAG]                                                                                                                                                                                                                                   
						, [IF_SND_DATE]                                                                                                                                                                                                                        
						, [RSLT_IF_SEQ]                                                                                                                                                                                                                               
						, [RSLT_PROC_FLAG]                                                                                                                                                                                                                            
						, [RSLT_PROC_MSG]                                                                                                                                                                                                                             
						, [PLAN_ID]                                                                                                                                      
						, [PLANT_ID]                                                                                                                                                                                                                                  
						, [BUILNO]                                                                                                                                                                                                                                    
						, [LINE_ID]                                                     
						, [OPERATION_ID]                                                                                                                                                                                                                              
						, [EQUIPMENT_ID]                                                                                                                                                                                                            
						, [ITEM_ID]            
						, [DEMAND_ID]             
						, [WO]                                                                                                                                                                                                                                        
						, [WO_TYPE]                                                                                                                                                                                                                                   
						, [WO_DETAIL]                                                                                                                                                                                                                                 
						, [PLAN_DATE]                                                                                                                                                                                                                                 
						, [START_TIME]                                                                                                                                                                                                                                
						, [END_TIME]                                                                                                                                                                                          
						, [IN_QTY]                                                                                                                                                                                                                                    
						, [OUT_QTY]                                                                                                                                                                                                                                   
						, [IS_RELEASE]                                                                                                                                                                                                                                
						, [CREATE_PSN_ID]                                                                
						, [CREATE_DATE]                                                                                                                                                                                                                               
						, [UPDATE_PSN_ID]                                                                                                                                                                                                                             
						, [UPDATE_DATE]                                                                                                                                                                                                                               
						, [LANE_QTY]                                                                        
						, [UNIT]                                                                                                                                                                                                                                      
						, [ORDER_TYPE]    
						, [BATCH_ORDER_ID]
						, [SLITTER_PLANT]
						, [MARKET]
						, [ATTR_01]
						, [ATTR_02]
						, [ATTR_03]
						, [ATTR_04]
						, [ATTR_05] 
						, [ATTR_06] 
						, [ATTR_07] 
						, [ATTR_08] 
						, [ATTR_09] 
						, [ATTR_10]
						, [ATTR_11]							  
						, [ATTR_12] 
						, [ATTR_13] 
						, [ATTR_14] 
						, [ATTR_15] 
						, [ATTR_16] 
						, [ATTR_17] 
						, [ATTR_18] 
						, [ATTR_19] 
						, [ATTR_20] 
						)
					SELECT 
						  X.[IF_SEQ]                         
						, X.[IF_TYPE]                                                                                                  
						, 'OFP0_GPDS_FP_WO' --X.[IF_ID]                                                                                                    
						, X.[IF_INS_DATE]                                                                                              
						, 'X'  --X.[IF_FLAG]                                                                                                  
						, NULL --X.[IF_SND_DATE]                                                                                              
						, X.[RSLT_IF_SEQ]                                                                                              
						, X.[RSLT_PROC_FLAG]                                                                                           
						, X.[RSLT_PROC_MSG]                          
						, X.[PLAN_ID]                                                                                                  
						, X.[PLANT_ID]                                                                                                 
						, X.[BUILNO]                                                                                                   
						, X.[LINE_ID]                                                                                                  
						, X.[OPERATION_ID]                                                                                             
						, X.[EQUIPMENT_ID]                                                                                             
						, X.[ITEM_ID]                                                                                                  
						, X.[DEMAND_ID]                                                                                                
						, X.[WO]                                                                                                       
						, X.[WO_TYPE]                                            
						, X.[WO_DETAIL]                                                                                                
						, X.[PLAN_DATE]                                                                                                
						, X.[START_TIME]                                                                                               
						, X.[END_TIME]                                                                                                 
						, X.[IN_QTY]                                                                                                   
						, X.[OUT_QTY]                                                                                                  
						, X.[IS_RELEASE]                                                                                               
						, X.[CREATE_PSN_ID]                                                                                            
						, X.[CREATE_DATE]                                                                                     
						, X.[UPDATE_PSN_ID]                                                                                            
						, X.[UPDATE_DATE]                                                                                              
						, X.[LANE_QTY]                                                                                                 
						, X.[UNIT]                      
						, X.[ORDER_TYPE]    
						, X.[BATCH_ORDER_ID]
						, X.[SLITTER_PLANT]
						, X.[MARKET]
						, X.[ATTR_01]
						, X.[ATTR_02]
						, X.[ATTR_03]
						, X.[ATTR_04]
						, X.[ATTR_05] 
						, X.[ATTR_06] 
						, X.[ATTR_07] 
						, X.[ATTR_08] 
						, X.[ATTR_09] 
						, X.[ATTR_10] 
						, X.[ATTR_11] 
						, X.[ATTR_12] 
						, X.[ATTR_13] 
						, X.[ATTR_14] 
						, X.[ATTR_15] 
						, X.[ATTR_16] 
						, X.[ATTR_17] 
						, X.[ATTR_18] 
						, X.[ATTR_19] 
						, X.[ATTR_20] 
					FROM SY_XIF_MES_WO_S as x with(nolock)
						 join scm_factory_m as y with(nolock)
					  on x.[BUILNO] = y.factory_id
					     join [DBO].[SCM_SYS_LOOKUP_VALUE] AS W WITH(NOLOCK)
					  ON W.LOOKUP_TYPE_CODE = 'PDS_COMPANY'
					 AND W.SEGMENT1 = Y.COMPANY_ID
					 AND W.SEGMENT2 = Y.PLANT_ID
					 AND W.ACTIVE_FLAG = 'Y'
				   where 1 = 1  -- y.company_id = 'G670'  -> LOOKUP으로 변경
					 AND x.ATTR_30 = @PDS_IFSEQNO
					;

					-- ================================================                                                                                                                                                                                                          
					-- 로직 추가 end                                                                                                                                                                                                                                          
					-- ================================================
				END
			ELSE
				BEGIN
					INSERT [dbo].[SY_XIF_ERP_DW_LOG](
							  IFSEQNO,
							  SERVICE_NAME, 
							  LOG_COUNT,
							  IF_TYPE,
							  INSERT_DATE,
							  LOG_MSR,
							  LOG_TYPE,
							  CREATE_USER_ID,
							  CREATE_DATE
					 ) VALUES (
							 replace(convert(varchar(8), GETDATE(), 112)+convert(varchar(8), GETDATE(), 114), ':','') ,
							  @v_proc_name, 
							  @chk_operration,
							  'ERROR',
							  GETDATE(),
							  @P_FP_PLAN_ID+'   OPERATION_ID( E1000, E0500) DATA CHEK', 
							  'ERROR', 
							  'SYSTEM',
							  SYSDATETIME()
					)
				END


		
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
