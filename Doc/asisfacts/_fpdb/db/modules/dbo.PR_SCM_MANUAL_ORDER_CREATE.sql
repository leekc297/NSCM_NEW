

CREATE PROCEDURE [dbo].[PR_SCM_MANUAL_ORDER_CREATE]
AS
-- ================================================================================================
-- Program ID          : FP01950-Manual_Create_WO 화면 설계서에 포함됨
-- Program Name        : PR_SCM_MANUAL_ORDER_CREATE
-- Param               :
-- Batch Period        : 
-- Description         : 수작업 WO 형성에서 사용됨
--
-- Source System       : FP SDB
-- Destination System  : INF
-- Source Table        : SCM_MANUAL_WO_CREATE
-- Destination Table   : XIF_MES_WO_S, XIF_ERP_PRODUCTION_PLAN_S
--
-- Create(Update) Date : 2017.04.20
-- Update Date         : 2017.05.21  Version 2.0 임시 작업에서 정식 작업으로 전환
--						 2017.05.28  Version 2.1
--						 2017.07.03  Version 2.2
--						 2017.07.21  2.3
--						 2017.08.06  2.4
--                       2017.08.29  2.5
--						 2017.09.18	 2.6
--						 2017.09.19	 2.7
--						 2017.10.10	 2.8 PIYONG
--						 2017.10.18  2.9 PIYONG
--						 2017.10.26  3.0 PIYONG
--						 2017.11.06  3.1 PIYONG
--						 2017.11.10  3.2 PIYONG
--						 2017.11.21  3.3 PIYONG
--                       2018.01.09  3.4 kimcd
--                       2018.01.11  3.5 kimcd
--						 2018.03.06  3.6 kimcd
--                       2019.07.23  3.61 kimcd
--                       2020.07.27  3.62 kimcd
--                       2021.05.25  3.7  kimis
--                       2022.07.12  3.8  kimcd
--                       2022.12.06  3.9  kimcd
--                       2023.03.03  3.91  kimcd

-- Author              : 최영태
-- Version             : 1.0  최영태 임시 Table로 수작업 WO 형성 과정 구현
--						 2.0  일반 Table로 전환
--                       2.1  FP-058 2017.05.28  Top W/O 복사 과정 추가. kimcd
--						 2.2  @BATCH_ORDER_ID  추가 PIYONG
--						 2.3  @NEW_WORK_ORDER A004 조건 추가  PIYONG
--                       2.4  kimcd W/O ID와 Detail W/O를 무조건 1대1로 변경하고 같은 값으로 채번.
--                                  W/O ID 채번을 Operation의 ERP Code 사용으로 변경.
--                       2.5  오창 소형 조립 Pilot Instance 제외
--						 2.6  라인변경일경우 FACTORY, WORK_CENTER가 변경이 안돼 변수로 변경
--						 2.7  kimcd. 계획 변경의 경우 MES Plan 정보의 잔량을 다시 계산함.
--                                   자동 Rolling에 포함하기 위해, 신규 형성에서 과거 Plan ID 기준으로
--                                   I/F 정보를 전송한 형태로 추가 형성함.
--						 2.8 STATUS가DELETE, UPDATE일 경우 START_TIME이 미래이고 IN_QTY가 0이면 SY_XIF_ERP_PRODUCTION_PLAN_S와 SY_XIF_MES_WO_S의  PLAN_DATE, START_TIME, END_TIME을  GET_DATE()-1로 변경
--						 2.9 @FP_SLITING_PLANT_ID 조회 조건 변경 (COMPANY_ID, DIVISION_ID, PRIORITY, MONTH 조건 추가 ORDER BY CASE 추가)
--						 3.0 1)기 발행된 WO의 MES_SOURCE_GROUP 와 신규 WO의 MES_SOURCE_GROUP가 다른 경우 기 발행한 WO를 삭제
--						       ,FP_RELEASE_FIX_PLAN_H에  WO의 최근 릴리즈된 정보 수정
--						       ,FP_RELEASE_FIX_PLAN_H에 WO의 최근 릴리즈된 정보가 전송된 SY_XIF_MES_WO_S 데이터 수정

--							 2) ERP WO 전송 IFSEQNO 14자리에서 16자리로 변경
--						 3.1 ERP_PRODUCTION_PLAN_S IFSEQNO 중복 생성 불가 처리
--						 3.2 Plan Release Group 기준으로 최종릴리즈 버전 찾기
--						 3.3 MES_WO_S ATTR_12에 TOP_ITEM_ID 정보 추가
--                       3.4 Top Item Id 추가
--                       3.5 FP_PRODUCTION_PLAN_R에 정보 입력, Open Work Order에 정보 입력
--						 3.6 2018-03-06 kimcd work order 채번 rule 반영
--                       3.61 2019-07-23 kimcd scm item m 조인 조건에 company_id 추가
--                       3.62 2020-07-27 kimcd mixer 공정의 ATTR_01(Total Batch), ATTR_03(Total Batch Kg) 전송 정보 제거
--	                     3.7 2021-05-25 kimis ESNJ 6동 GMES DB 분리에 따른 변경
--                           동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
--                           라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
--	                     3.8 2022-07-12 kimcd 설비 정보 제거
--                       3.9 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
--                       3.91 2023-03-03 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송
--                       4.0 2023-11-01 FP Pjt. 스마트 팩토리 핵심 IT 품질 시스템 구축_FP영역 / PDS 전송 추가
--                       4.1 2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
--                       4.2 2024-04-03 KIMJS NERP PLANT_ID 변경에 따른 CONVERSION 반영
--                       4.3 2025-09-18 CYS 	[E20250918-001592] PDS 버전 -자리수 조치 요청건
--                       4.4 2026-08-04 kimcd   [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
-- ================================================================================================
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_MANUAL_ORDER_CREATE'
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
	
	DECLARE @WO_BASE_DATE			NVARCHAR(1000)
	DECLARE @FACTORY_ID				NVARCHAR(1000)
	DECLARE @LINE_ID				NVARCHAR(1000)
	DECLARE @OPERATION_ID			NVARCHAR(1000)
	DECLARE @EQUIPMENT_ID			NVARCHAR(50)
	DECLARE @ITEM_ID				NVARCHAR(1000)
	DECLARE @WORK_CENTER_ID			NVARCHAR(1000)
	DECLARE @WO_ID					NVARCHAR(1000)
	DECLARE @MO_ID					NVARCHAR(1000)
	DECLARE @ORDER_TYPE				NVARCHAR(1000)
	DECLARE @WO_TYPE				NVARCHAR(1000)
	DECLARE @PLAN_DATE				NVARCHAR(1000)
	DECLARE @START_TIME				NVARCHAR(1000)
	DECLARE @END_TIME				NVARCHAR(1000)
	DECLARE @IN_QTY					NUMERIC(10,3) --NVARCHAR(1000)
	DECLARE @OUT_QTY				NUMERIC(10,3) --NVARCHAR(1000)
	DECLARE @LANE_QTY				NUMERIC(10,3) --NVARCHAR(1000)
	DECLARE @BATCH_QTY				NUMERIC(20,10) 
	DECLARE @MARKET					NVARCHAR(1000)	
	DECLARE @UPDATE_PSN_ID			NVARCHAR(1000)

	DECLARE @INSTANCE_ID			NVARCHAR(1000)
	DECLARE @INSTANCE_DATE			NVARCHAR(1000)
	DECLARE @RELEASE_PLAN_ID		NVARCHAR(1000)
	DECLARE @AMEND_PLAN_ID			NVARCHAR(1000)
	DECLARE @DIVISION_ID			NVARCHAR(1000)
	DECLARE @COMPANY_ID				NVARCHAR(30)    -- FP-058 2017.05.30   kimcd 추가
	DECLARE @ELECTRODE_TYPE			NVARCHAR(1000)
	
	DECLARE @MES_LINE_ID			NVARCHAR(1000)	
	DECLARE @ERP_WORK_CENTER_ID		NVARCHAR(1000)	
	DECLARE @FP_LANE_QTY			float	
	DECLARE @NEW_WORK_ORDER			NVARCHAR(1000)	
	DECLARE @FP_PLANT_ID			NVARCHAR(1000)	
	DECLARE @FP_PLAN_ID				NVARCHAR(1000)	
	DECLARE @FP_SLITING_PLANT_ID	NVARCHAR(1000)
    DECLARE @MES_SLITING_PLANT_ID	NVARCHAR(1000)  -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영
	DECLARE @FP_SITE_ID				NVARCHAR(1000)	
	DECLARE @FP_WO_TYPE				NVARCHAR(1000)	
	DECLARE @UOM					NVARCHAR(1000)
	DECLARE @IFSQENO				NVARCHAR(100)		-- 2017-11-06 PIYONG 추가
	DECLARE @SEQ					INT	
	DECLARE @ASSIGN_VAL				INT	
	DECLARE @ASSIGN_ERP_VAL			INT	
	DECLARE @ORDER_TYPE_VAL			INT	
	DECLARE @BOM_VAL				INT
	DECLARE @FLOW_VAL				INT
	DECLARE @PERIOD_VAL				INT
	DECLARE @PAST_VAL				INT
	DECLARE @WO_SEQ					INT
	DECLARE @TOTAL_IN_QTY			NUMERIC(10,3)	
	DECLARE @TOTAL_OUT_QTY			NUMERIC(10,3)	
	DECLARE @STATUS					NVARCHAR(100)	
	DECLARE @BATCH_ORDER_ID			NVARCHAR(30)    -- 2017.07.03   PIYONG 추가
	DECLARE @RESULT_QTY				NUMERIC(15,3)   -- 2017-09-19 kimcd UPDATE용 실적 변수 추가
	DECLARE @BASE_HOUR				NVARCHAR(10)    -- 2017-09-19 kimcd UPDATE용 실적 취합용 기준 시간

	--기 발행된 WO의 MES_SOURCE_GROUP 와 신규 WO의 MES_SOURCE_GROUP가 다른 경우 기 발행한 WO의 정보의 정보 변수 시작
	DECLARE @BEFORE_IN_QTY			NUMERIC(18,5)   -- 2017.10.26   PIYONG 추가
	DECLARE @BEFORE_OUT_QTY			NUMERIC(18,5)   -- 2017.10.26   PIYONG 추가
	DECLARE @BEFORE_PLAN_DATE		NVARCHAR(30)    -- 2017.11.08   PIYONG 추가
	DECLARE @BEFORE_START_TIME		NVARCHAR(30)    -- 2017.11.08   PIYONG 추가
	DECLARE @BEFORE_END_TIME		NVARCHAR(30)    -- 2017.11.08   PIYONG 추가
	--기 발행된 WO의 MES_SOURCE_GROUP 와 신규 WO의 MES_SOURCE_GROUP가 다른 경우 기 발행한 WO의 정보의 정보 변수 끝

	DECLARE @TOP_ITEM_ID			NVARCHAR(150)   -- 2018-01-09 kimcd 최상위 품목 컬럼 추가
	DECLARE @WO_CUTOFF_DATE			DATETIME        -- 2018-01-11 kimcd open work order 최종 snapshot 정보 할당
	DECLARE @WORK_REQUEST_MODEL_ID  NVARCHAR(50)  -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
    DECLARE @VERSION                NVARCHAR(10)  -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
    DECLARE @PROD_SEQ               NVARCHAR(50)  -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
    DECLARE @PLM_EC_NO              NVARCHAR(50)  -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가

	DECLARE @ERR_MESSAGE            NVARCHAR(1000)	

	DECLARE @PDS_IFSEQNO			NVARCHAR(50) 

	DECLARE CUR_MANUAL_WO_LIST CURSOR FOR
			SELECT [SEQ]
			      ,[WO_BASE_DATE]
				  ,[STATUS]
			      ,[FACTORY_ID]
			      ,[LINE_ID]
			      ,[OPERATION_ID]
			      ,CASE WHEN [EQUIPMENT_ID] IS NULL OR [EQUIPMENT_ID] = '' THEN '-' ELSE [EQUIPMENT_ID] END AS EQUIPMENT_ID -- 2022-07-12 kimcd 설비 정보 제거
			      ,[ITEM_ID]
			      ,[WORK_CENTER_ID]
			      ,[WO_ID]
			      ,[MO_ID]
			      ,[ORDER_TYPE]
			      ,[WO_TYPE]
			   --   ,[PLAN_DATE]
			      ,[START_TIME]
			      ,[END_TIME]
			      ,ISNULL([IN_QTY],0)
			      ,ISNULL([OUT_QTY],0)
			      ,[LANE_QTY]
				  ,BATCH_QTY
			      ,[MARKET]
			      ,[UPDATE_PSN_ID]
				  -- 전극 공정은 동일 날짜에 여러 값이 있더라도 설비별 summary를 하면 안됨. WO 1개에 WO Detail이 1개 생성되어야 함.
				  -- kimcd 2017-08-06 모든 Order를  WO = WO_DETAIL로 변경
				  ,ROW_NUMBER() over ( partition by ( SELECT TOP 1 W.MES_LINE_ID
				                                        FROM DBO.SCM_LINE_M W WITH(NOLOCK)
					                                   WHERE W.FACTORY_ID   = A.FACTORY_ID
													   AND   W.LINE_ID      = A.LINE_ID   
													   AND   W.OPERATION_ID = A.OPERATION_ID
													   ORDER BY W.UPDATE_TIME DESC)  -- 2022-07-12 kimcd 설비에서 라인으로 기준 변경
					                                 , wo_base_date + cast( seq as nvarchar)
													 , [ITEM_ID]
													 , substring([START_TIME], 1,8)/*[PLAN_DATE]*/
													 , ISNULL( WO_ID , '' ) -- Update나 Delete 시에는 WO_ID 별로 처리 함. 2017.05.26
													 ORDER BY EQUIPMENT_ID DESC ) WO_SEQ
				  ,SUM(CAST(IN_QTY AS NUMERIC(10,3)) ) OVER ( PARTITION BY (  SELECT TOP 1 W.MES_LINE_ID
																			    FROM DBO.SCM_LINE_M W WITH(NOLOCK)
																			   WHERE W.FACTORY_ID   = A.FACTORY_ID
																			   AND   W.LINE_ID      = A.LINE_ID   
																			   AND   W.OPERATION_ID = A.OPERATION_ID
																			   ORDER BY W.UPDATE_TIME DESC)  -- 2022-07-12 kimcd 설비에서 라인으로 기준 변경
																		   , -- CASE WHEN SUBSTRING([OPERATION_ID], 1, 1) = 'E' THEN kimcd block 모든 Order를  WO = WO_DETAIL로 변경 2017-08-06
																						  WO_BASE_DATE + CAST( SEQ AS NVARCHAR)
																				--	ELSE [OPERATION_ID] END kimcd block 모든 Order를  WO = WO_DETAIL로 변경 2017-08-06
																		   , [ITEM_ID]
																		   , SUBSTRING([START_TIME], 1,8)/*[PLAN_DATE]*/
																		   , ISNULL( WO_ID , '' )
																			ORDER BY EQUIPMENT_ID) TOTAL_IN_QTY
				  ,SUM(CAST(OUT_QTY AS NUMERIC(10,3)) ) OVER ( PARTITION BY ( SELECT TOP 1 W.MES_LINE_ID
																			    FROM DBO.SCM_LINE_M W WITH(NOLOCK)
																			   WHERE W.FACTORY_ID   = A.FACTORY_ID
																			   AND   W.LINE_ID      = A.LINE_ID   
																			   AND   W.OPERATION_ID = A.OPERATION_ID
																			   ORDER BY W.UPDATE_TIME DESC)  -- 2022-07-12 kimcd 설비에서 라인으로 기준 변경
																		    , -- CASE WHEN SUBSTRING([OPERATION_ID], 1, 1) = 'E' THEN kimcd block 모든 Order를  WO = WO_DETAIL로 변경 2017-08-06
																					WO_BASE_DATE + CAST( SEQ AS NVARCHAR)
																			       -- ELSE [OPERATION_ID] END kimcd block 모든 Order를  WO = WO_DETAIL로 변경 2017-08-06
																			,[ITEM_ID]
																			,SUBSTRING([START_TIME], 1,8)/*[PLAN_DATE]*/
																			,ISNULL( WO_ID , '' )
																			ORDER BY EQUIPMENT_ID) TOTAL_OUT_QTY
				  ,A.TOP_ITEM_ID       -- 2018-01-09 kimcd 최상위 품목 컬럼 추가
				  ,A.WORK_REQUEST_MODEL_ID  -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
				  ,A.VERSION                -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
				  ,A.PROD_SEQ               -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
				  ,A.PLM_EC_NO              -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
			  FROM [dbo].[SCM_MANUAL_WO_CREATE] a WITH(NOLOCK)
			 where [PROCESSING_YN] = 'P'
             order by [WO_BASE_DATE], [OPERATION_ID], [ITEM_ID], substring([START_TIME], 1,8)/*[PLAN_DATE]*/ ,ROW_NUMBER() over ( partition by (  SELECT TOP 1 W.MES_LINE_ID
																																					FROM DBO.SCM_LINE_M W WITH(NOLOCK)
																																				   WHERE W.FACTORY_ID   = A.FACTORY_ID
																																				   AND   W.LINE_ID      = A.LINE_ID   
																																				   AND   W.OPERATION_ID = A.OPERATION_ID
																																				   ORDER BY W.UPDATE_TIME DESC)  -- 2022-07-12 kimcd 설비에서 라인으로 기준 변경
											                                                                                                  ,-- CASE WHEN SUBSTRING([OPERATION_ID], 1, 1) = 'E' THEN  kimcd block 모든 Order를  WO = WO_DETAIL로 변경 2017-08-06
																																			   wo_base_date + cast( seq as nvarchar)  -- ELSE [OPERATION_ID] END kimcd block 모든 Order를  WO = WO_DETAIL로 변경 2017-08-06
																																			  , [ITEM_ID]
																																			  , substring([START_TIME], 1,8)/*[PLAN_DATE]*/ 
																																			  , ISNULL( WO_ID , '' )
																																			  order by equipment_id  desc ) 
			;

	SET @ROWCOUNT = @@ROWCOUNT

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
			SET @PDS_IFSEQNO = CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR [dbo].[XIF_PDS_SEQ]),10)

			UPDATE [dbo].[SCM_MANUAL_WO_CREATE]
			  SET [PROCESSING_YN] = 'P'
			WHERE [PROCESSING_YN] = 'N'
			;

			SET @FP_PLAN_ID = 'MANUAL_ADJ_'+replace(replace( replace( convert(varchar, getdate(),120), ' ',''),':',''),'-','') + '-XX'
			
			OPEN CUR_MANUAL_WO_LIST;
			FETCH NEXT FROM CUR_MANUAL_WO_LIST INTO  @SEQ
			                                        ,@WO_BASE_DATE   
													,@STATUS 
													,@FACTORY_ID     
													,@LINE_ID        
													,@OPERATION_ID   
													,@EQUIPMENT_ID   
													,@ITEM_ID        
													,@WORK_CENTER_ID 
													,@WO_ID
													,@MO_ID
													,@ORDER_TYPE     
													,@WO_TYPE        
												--	,@PLAN_DATE      
													,@START_TIME     
													,@END_TIME       
													,@IN_QTY         
													,@OUT_QTY        
													,@LANE_QTY   
													,@BATCH_QTY    
													,@MARKET 
													,@UPDATE_PSN_ID
													,@WO_SEQ
													,@TOTAL_IN_QTY
													,@TOTAL_OUT_QTY
													,@TOP_ITEM_ID   -- 2018-01-09 kimcd 최상위 품목 컬럼 추가
													,@WORK_REQUEST_MODEL_ID  -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
													,@VERSION                -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
													,@PROD_SEQ               -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
													,@PLM_EC_NO              -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
																							;
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
			       IF @WO_SEQ = 1 
				     BEGIN

					    SET @ERP_WORK_CENTER_ID = null
						SET @MES_LINE_ID = null
						SET @FP_PLANT_ID = null
						SET @DIVISION_ID = null
						SET @COMPANY_ID  = null   -- FP-058 2017.05.30 kimcd 추가
						SET @INSTANCE_ID = null
						SET @RELEASE_PLAN_ID = null
						SET @AMEND_PLAN_ID = null
						SET @PLAN_DATE = null
						SET @ELECTRODE_TYPE = null
						SET @FP_LANE_QTY = null
						SET @BATCH_ORDER_ID = NULL	--2017.07.03 PIYONG 추가
						SET @RESULT_QTY = 0 --2017-09-19 kimcd 실적 수량 초기화
					 END
			
					SELECT TOP 1 @ERP_WORK_CENTER_ID = a.WORK_CENTER_ID, @MES_LINE_ID = a.MES_LINE_ID , @FP_PLANT_ID = a.PLANT_ID, @FP_SITE_ID = a.SITE_ID, @DIVISION_ID = a.DIVISION_ID
					       , @COMPANY_ID = A.COMPANY_ID -- FP-058 2017.05.30 kimcd 추가
					  from dbo.SCM_EQUIPMENT_M a with(nolock)
					 WHERE 1=1
					   and a.equipment_id = @EQUIPMENT_ID
					   and a.factory_id = @FACTORY_ID     -- 공용설비가 존재함.
					 ;
					 -- 2022-07-12 kimcd 설비 정보 제거 시작
					 IF @EQUIPMENT_ID IS NULL OR @EQUIPMENT_ID = '' OR @EQUIPMENT_ID = '-'
						  BEGIN
 							  SELECT TOP 1 @ERP_WORK_CENTER_ID = a.WORK_CENTER_ID, @MES_LINE_ID = a.MES_LINE_ID , @FP_PLANT_ID = a.PLANT_ID, @FP_SITE_ID = a.SITE_ID, @DIVISION_ID = a.DIVISION_ID
								   , @COMPANY_ID = A.COMPANY_ID -- FP-058 2017.05.30 kimcd 추가
							  FROM   DBO.SCM_LINE_M A with(nolock)
							  WHERE  1=1
							  AND    A.FACTORY_ID   = @FACTORY_ID
							  AND    A.LINE_ID      = @LINE_ID   
							  AND    A.OPERATION_ID = @OPERATION_ID
							  ORDER  BY A.UPDATE_TIME DESC
							 ;
						  END;
					 -- 2022-07-12 kimcd 설비 정보 제거 끝

					--2017.07.03 PIYONG 로직 변경
					--2017.11.10 PIYONG Plan Release Group 기준으로  최종 릴리즈 찾기
					SELECT @INSTANCE_ID = ZZ.INSTANCE_ID
						   ,@INSTANCE_DATE = ZZ.INSTANCE_DATE
						   ,@RELEASE_PLAN_ID = ZZ.RELEASE_PLAN_ID
						   ,@AMEND_PLAN_ID = ZZ.AMEND_PLAN_ID
				      FROM ( SELECT B.SITE_ID
									,A.INSTANCE_ID
									,A.INSTANCE_DATE
									,A.DIVISION_ID
									,B.FACTORY_ID
									,A.RELEASE_PLAN_ID
									,A.AMEND_PLAN_ID
									,A.PLAN_GROUP_ID
									,B.LINK_FACTORY_ID		--2017.11.10 PIYONG ADD
									,ROW_NUMBER() OVER ( PARTITION BY  DIVISION_ID, INSTANCE_TYPE, A.FACTORY_ID, A.PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) NUMS -- 마지막 RELEASE VERSION         
							   FROM [DBO].FP_RELEASE_PLAN_INFO_H  A 
								--2017.11.10 PIYONG Plan Release Group 기준으로  최종 릴리즈 찾기 시작
								-------------------------------------------------------------------------------------------------------------
									,( SELECT A.[INSTANCE_ID]
											  ,A.INSTANCE_TYPE
											  ,B.SITE_ID
											  ,B.FACTORY_ID
											  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
											  ,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
										 FROM  DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
											  ,DBO.SCM_FACTORY_M B WITH(NOLOCK)   
											  ,SCM_OPERATION_M   O WITH(NOLOCK)
											  ,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
											   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
															ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
														   AND MP.SEGMENT1 = SLV.SEGMENT1
														   AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
										WHERE A.FACTORY_ID = B.FACTORY_ID     
										  AND A.ACTIVE_FLAG = 'Y'     
										  AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
										  AND B.FACTORY_ID = @FACTORY_ID
										  AND B.SITE_ID = @FP_SITE_ID
										  AND A.INSTANCE_TYPE = O.INSTANCE_TYPE
										  AND B.COMPANY_ID = O.COMPANY_ID
										  AND B.DIVISION_ID = O.DIVISION_ID
										  AND B.SITE_ID = O.SITE_ID
										  AND O.OPERATION_ID = @OPERATION_ID
										  AND A.INSTANCE_ID != 'KR_CELL_M_P'
										  AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
										  AND SLV.SEGMENT1 = A.INSTANCE_ID
								-------------------------------------------------------------------------------------------------------------
									--2017.11.10 PIYONG Plan Release Group 기준으로  최종 릴리즈 찾기 끝
									) B      
							  WHERE A.INSTANCE_ID = B.INSTANCE_ID
								AND A.FACTORY_ID = B.LINK_FACTORY_ID
								AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
						   ) ZZ       
				     WHERE ZZ.NUMS = 1
						--2017.11.10 PIYONG ADD
						---------------------------------------------------------------------
					   AND EXISTS (SELECT 1 
								     FROM SCM_LINE_M   SLM WITH(NOLOCK)
								    WHERE SLM.FACTORY_ID   = ZZ.FACTORY_ID
								      AND SLM.LINE_ID      = @LINE_ID
								      AND SLM.OPERATION_ID = @OPERATION_ID
								      AND ( SLM.FACTORY_ID = ZZ.LINK_FACTORY_ID
								            OR SLM.MODEL_TYPE = ZZ.PLAN_GROUP_ID)) -- 해당 라인이 배포에 참여했는 지 검증한다.
						
						---------------------------------------------------------------------
				  -- 2018-01-11 kimcd 최종 open work order의 snapshot 일자 정보 추출
				  SELECT TOP 1  @BASE_HOUR = CONCAT(' ', SUBSTRING(V.SEGMENT2, 1, 2), ':',SUBSTRING(V.SEGMENT2, 3, 2), ':',SUBSTRING(V.SEGMENT2, 5, 2))
				  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
					  ,SCM_FACTORY_M                F  WITH(NOLOCK)
				  WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
				  AND V.ACTIVE_FLAG = 'Y'
				  AND V.SEGMENT1    = F.PLANT_ID
				  AND F.SITE_ID     = @FP_SITE_ID
				  AND F.FACTORY_ID  = @FACTORY_ID

				  SELECT @WO_CUTOFF_DATE = ISNULL(MAX(CUTOFF_DATE), CASE WHEN @BASE_HOUR > SUBSTRING(CONVERT(NVARCHAR(20), DBO.FN_SITE_TIME(@FP_SITE_ID), 120), 11, 9) THEN
																		CONVERT(DATE, DATEADD(D,-1,DBO.FN_SITE_TIME(@FP_SITE_ID)), 120)
																	ELSE
																		CONVERT(DATE, DBO.FN_SITE_TIME(@FP_SITE_ID), 120)
																	END )
				  FROM   [dbo].[FP_MES_WORK_ORDER_STATUS_H] WOS WITH(NOLOCK)
				  WHERE  WOS.COMPANY_ID  = @COMPANY_ID
				  AND    WOS.DIVISION_ID = @DIVISION_ID
				  AND    WOS.SITE_ID     = @FP_SITE_ID
				  AND    WOS.PLANT_ID    = @FP_PLANT_ID
				  AND    WOS.FACTORY_ID  = @FACTORY_ID
				  -- 2018-01-11 kimcd 최종 open work order의 snapshot 일자 정보 추출


				  -- 2017-09-19 kimcd 실적 취합용 추가 시작
				  -- 최종 릴리즈의 시업 시간 이전 실적을 취합
				  IF @STATUS = 'UPDATE'
				    BEGIN
						SELECT @RESULT_QTY = ISNULL( SUM(ISNULL(C.WIPQTY2_ED,0))
													+ SUM(ISNULL(CONVERT(NUMERIC(14,3), C.CNFM_DFCT_QTY2),0)) 
													+ SUM(ISNULL(CONVERT(NUMERIC(14,3), C.CNFM_LOSS_QTY2),0)) 
													+ SUM(ISNULL(CONVERT(NUMERIC(14,3), C.CNFM_PRDT_REQ_QTY2),0))
													+ SUM(ISNULL(CAST(C.SCRAP_QTY AS NUMERIC(14,3)),0))
													,0)
						FROM  DBO.SCM_MES_WIP_HISTORY_H C WITH(NOLOCK, INDEX(IDX1_SCM_MES_WIP_HISTORY_H))
						WHERE C.WOID = @WO_ID
						AND C.PRODID = @ITEM_ID
						AND C.PROCID = @OPERATION_ID
						AND C.WIP_TYPE_CODE IN ( 'OUT','INOUT' ,'PACKED', 'PROD')	-- PIYONG 2017-08-25 PROD 추가
						AND CAST(C.WIPDTTM_ED AS datetime) < CAST(SUBSTRING( CONVERT(VARCHAR,  CONVERT(DATE, @INSTANCE_DATE, 112), 120), 1,10 ) + @BASE_HOUR AS datetime)
					END;
				  -- 2017-09-19 kimcd 실적 취합용 추가 끝

/*					--2017.07.03 PIYONG 주석 처리
					select top 1 @INSTANCE_ID = a.INSTANCE_ID
					  from FP_INSTANCE_FACTORY_M a
						  ,SCM_OPERATION_M b
					 where a.FACTORY_ID = @FACTORY_ID
					   and b.OPERATION_ID = @OPERATION_ID
					   and a.INSTANCE_TYPE = b.INSTANCE_TYPE
					;

					--2017.07.03 PIYONG 주석 처리
					SELECT TOP 1 @INSTANCE_DATE = x.INSTANCE_DATE , @RELEASE_PLAN_ID = x.RELEASE_PLAN_ID, @AMEND_PLAN_ID = x.AMEND_PLAN_ID
					  FROM (
							 SELECT INSTANCE_ID, INSTANCE_DATE, RELEASE_PLAN_ID , AMEND_PLAN_ID
								  , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, DIVISION_ID, FACTORY_ID ORDER BY INSERT_TIME DESC ) NUMS
							   FROM [DBO].FP_RELEASE_PLAN_INFO_H WHERE INSTANCE_ID = @INSTANCE_ID  AND FACTORY_ID = @FACTORY_ID     
						   ) X
					WHERE X.NUMS = 1
					;
*/

					SET @PLAN_DATE = SUBSTRING(@START_TIME,1,8)+'000000'


					select TOP 1 @ELECTRODE_TYPE = ELECTRODE_TYPE
					  from dbo.SCM_ITEM_LINE_ASSIGN_M
					 where LINE_ID = @LINE_ID        
					   and ITEM_ID = @ITEM_ID        
					   and ACTIVE_FLAG = 'Y'
                    ;


			        IF @LANE_QTY is not null OR @LANE_QTY > 0 
					      SET @FP_LANE_QTY = @LANE_QTY       ;
					else
				          select top 1 @FP_LANE_QTY = lane_qty
			                from dbo.SCM_ITEM_LANE_M
			               where item_id    =  @ITEM_ID
			                 and factory_id =  @FACTORY_ID
			               ; 
			
			        SELECT top 1 @UOM = item_uom
			          FROM dbo.scm_item_m 
			         where item_id    =  @ITEM_ID  
			          ; 

					-- 2017.07.03 PIYONG 추가
					SELECT @BATCH_ORDER_ID = [BATCH_ID]
					  FROM [dbo].[SCM_BATCH_M]
					 WHERE [COMPANY_ID] = @COMPANY_ID
					   AND [DIVISION_ID] = @DIVISION_ID
					   AND [SITE_ID] = @FP_SITE_ID
					   AND [PLANT_ID] = @FP_PLANT_ID
					   AND [ITEM_ID] = @ITEM_ID
					;



					IF @WO_SEQ = 1 
					   begin    
					     select top 1 @NEW_WORK_ORDER = orders
					  from ( 
								select ISNULL ( (
												substring( max(wo), 1,9) + ( CASE WHEN len(cast( cast( substring( max(wo), 10,3) as numeric) + 1 as varchar) ) = 1 THEN '00'+ cast( cast( substring( max(wo), 10,3) as numeric) + 1 as varchar) 
																		WHEN len(cast( cast( substring( max(wo), 10,3) as numeric) + 1 as varchar) ) = 2 THEN '0'+ cast( cast( substring( max(wo), 10,3) as numeric) + 1 as varchar) 
										    										ELSE cast( cast( substring( max(wo), 10,3) as numeric) + 1 as varchar) END )
											  ),
											  case @FP_SITE_ID when 'A001' THEN 'K' WHEN 'A002' THEN 'C' WHEN 'A003' THEN 'A' WHEN 'A004' THEN 'P' WHEN 'A007' THEN 'D' ELSE 'X' END
																						   -- 2018-03-06 kimcd order type 제거 + ISNULL( (SELECT TOP 1 KEY_VALUE FROM dbo.FP_INSTANCE_CONFIG_M  WHERE INSTANCE_ID = 'COMMON' AND CATEGORY_ID = 'DEMAND_TYPE' AND KEY_ID = @ORDER_TYPE ), '1' )
																						   + substring(@START_TIME,3,2) +
																						 case substring(@START_TIME,5,2)
																						          when '01' then '1' when '02' then '2' when '03' then '3' when '04' then '4' when '05' then '5' when '06' then '6'
																								  when '07' then '7' when '08' then '8' when '09' then '9' when '10' then 'A' when '11' then 'B' when '12' then 'C' ELSE 'X' END
																						   +'0X'+
																						 /*case @OPERATION_ID when 'E0500' then 'PM' when 'E1000' then 'MX' when 'E2000' then 'CT' when 'E2300' then 'IC' when 'E2500' then 'HS' when 'E3000' then 'RP' when 'E3500' then 'TP' when 'E4000' then 'SL'
																									  when 'A5000' then 'NT' when 'A6000' then 'VD' when 'A7000' then 'LM' when 'A8000' then 'ST' when 'A9000' then 'PK' 
																									  when 'P5000' then 'CP' when 'P5500' then 'CM' when 'P9500' then 'BM' 
																									  ELSE 'XX' END kimcd 2017-08-06 Work Order 명 채번을 Operation 기반으로 하도록 전환*/
																						ISNULL( (SELECT TOP 1 ERP_OPERATION_ID FROM   DBO.SCM_OPERATION_M WITH(NOLOCK) WHERE  OPERATION_ID = @OPERATION_ID), 'XX')
																						   +'0001'
											   )    orders
								  from  [dbo].[SY_XIF_MES_WO_S] where wo like case @FP_SITE_ID when 'A001' THEN 'K' WHEN 'A002' THEN 'C' WHEN 'A003' THEN 'A' WHEN 'A004' THEN 'P' WHEN 'A007' THEN 'D' ELSE 'X' END
																						   -- 2018-03-06 kimcd order type 제거 + ISNULL( (SELECT TOP 1 KEY_VALUE FROM dbo.FP_INSTANCE_CONFIG_M  WITH(NOLOCK) WHERE INSTANCE_ID = 'COMMON' AND CATEGORY_ID = 'DEMAND_TYPE' AND KEY_ID = @ORDER_TYPE ), '1' )
																						   + substring(@START_TIME,3,2) +
																						 case substring(@START_TIME,5,2) when '01' then '1' when '02' then '2' when '03' then '3' when '04' then '4' when '05' then '5' when '06' then '6'
																								                         when '07' then '7' when '08' then '8' when '09' then '9' when '10' then 'A' when '11' then 'B' when '12' then 'C' ELSE 'X' END
																						   +'0X'+
																						 /*case @OPERATION_ID when 'E0500' then 'PM' when 'E1000' then 'MX' when 'E2000' then 'CT' when 'E2300' then 'IC' when 'E2500' then 'HS' when 'E3000' then 'RP' when 'E3500' then 'TP' when 'E4000' then 'SL'
																									        when 'A5000' then 'NT' when 'A6000' then 'VD' when 'A7000' then 'LM' when 'A8000' then 'ST' when 'A9000' then 'PK' 
																									        when 'P5000' then 'CP' when 'P5500' then 'CM' when 'P9500' then 'BM' 
																									        ELSE 'XX' END kimcd 2017-08-06 Work Order 명 채번을 Operation 기반으로 하도록 전환*/
																						 ISNULL( (SELECT TOP 1 ERP_OPERATION_ID FROM   DBO.SCM_OPERATION_M WITH(NOLOCK) WHERE  OPERATION_ID = @OPERATION_ID), 'XX')
																						   +'0%'

					       ) z
					     ;
                    end
					
			        select top 1 @ASSIGN_VAL = counta
						 from (
						      SELECT count(1) counta
						        FROM DBO.SCM_ITEM_LINE_ASSIGN_M la
						       WHERE la.ITEM_ID = @ITEM_ID
						         and la.LINE_ID = @LINE_ID
						       and la.ACTIVE_FLAG = 'Y' ) a
						     ;

                    select @FP_SLITING_PLANT_ID = CASE WHEN @OPERATION_ID  = 'E2000' THEN 
						                                  ISNULL( (
											                     SELECT TOP 1 Z.PLANT_ID
											                       FROM [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] Z
                                                                  WHERE Z.OPERATION_ID = 'E4000'
																	AND Z.COMPANY_ID   = @COMPANY_ID
																	AND Z.DIVISION_ID  = @DIVISION_ID
												                    AND Z.SITE_ID      = @FP_SITE_ID
											                        AND Z.ITEM_ID      = @ITEM_ID  
											                      ORDER BY Z.INSERT_TIME DESC 
											                    ),(
																	 --2017-10-19 PIYONG COMPANY_ID, DIVISION_ID, PRIORITY, MONTH 조건 추가 ORDER BY CASE 추가
																	 SELECT TOP 1 ILA.PLANT_ID
																	   FROM [DBO].[SCM_ITEM_LINE_ASSIGN_M] ILA
																	  WHERE ILA.OPERATION_ID = 'E4000'
  									  									AND ILA.COMPANY_ID   = @COMPANY_ID
																		AND ILA.DIVISION_ID  = @DIVISION_ID
																		AND ILA.SITE_ID      = @FP_SITE_ID
																		AND ILA.ITEM_ID      = @ITEM_ID  
																		AND ILA.ACTIVE_FLAG = 'Y'
																		AND ILA.PRIORITY != 9
																		AND ILA.MONTH >= CONVERT(NVARCHAR(6), GETDATE(),112)
																	  ORDER BY CASE WHEN @FP_PLANT_ID = ILA.PLANT_ID THEN 1 ELSE 2 END,  ILA.INSERT_TIME DESC  
											                    ) ) ELSE NULL END
							                           ;											     

                    select @MES_SLITING_PLANT_ID = CASE WHEN @OPERATION_ID  = 'E2000' THEN 
						                                  ISNULL( (
											                     SELECT TOP 1 F.MES_PLANT_ID  
											                       FROM [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] Z
                                                                  INNER JOIN SCM_FACTORY_M F WITH(NOLOCK)
                                                                     ON Z.COMPANY_ID = F.COMPANY_ID
                                                                    AND Z.FACTORY_ID = F.FACTORY_ID
                                                                  WHERE Z.OPERATION_ID = 'E4000'
																	AND Z.COMPANY_ID   = @COMPANY_ID
																	AND Z.DIVISION_ID  = @DIVISION_ID
												                    AND Z.SITE_ID      = @FP_SITE_ID
											                        AND Z.ITEM_ID      = @ITEM_ID  
											                      ORDER BY Z.INSERT_TIME DESC 
											                    ),(
																	 --2017-10-19 PIYONG COMPANY_ID, DIVISION_ID, PRIORITY, MONTH 조건 추가 ORDER BY CASE 추가
																	 SELECT TOP 1 F.MES_PLANT_ID
																	   FROM [DBO].[SCM_ITEM_LINE_ASSIGN_M] ILA
                                                                      INNER JOIN SCM_FACTORY_M F WITH(NOLOCK)
                                                                         ON ILA.COMPANY_ID = F.COMPANY_ID
                                                                        AND ILA.FACTORY_ID = F.FACTORY_ID
																	  WHERE ILA.OPERATION_ID = 'E4000'
  									  									AND ILA.COMPANY_ID   = @COMPANY_ID
																		AND ILA.DIVISION_ID  = @DIVISION_ID
																		AND ILA.SITE_ID      = @FP_SITE_ID
																		AND ILA.ITEM_ID      = @ITEM_ID  
																		AND ILA.ACTIVE_FLAG = 'Y'
																		AND ILA.PRIORITY != 9
																		AND ILA.MONTH >= CONVERT(NVARCHAR(6), GETDATE(),112)
																	  ORDER BY CASE WHEN @FP_PLANT_ID = ILA.PLANT_ID THEN 1 ELSE 2 END,  ILA.INSERT_TIME DESC  
											                    ) ) ELSE NULL END
							                           ;  -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 

			        select top 1 @ASSIGN_ERP_VAL = counta
						 from (
						      SELECT count(1) counta
						        FROM DBO.[SY_XIF_ERP_ITEM_LINE_ASSIGN_S] la
						       WHERE la.ITEM_ID = @ITEM_ID
						         and la.LINE_ID = @MES_LINE_ID
						       and la.ACTIVE_FLAG = 'Y' ) a
						     ;
			
			        select top 1 @BOM_VAL  = counta
						 from (
						      SELECT count(1) counta
						        FROM DBO.SCM_BOM_M bm
						       WHERE bm.parent_item_id = @ITEM_ID
						         and bm.plant_id  = @FP_PLANT_ID
						       and bm.ACTIVE_FLAG = 'Y' ) a
						     ;
						     
			        select top 1 @FLOW_VAL  = counta
						 from (
						      SELECT count(1) counta
						        FROM DBO.SCM_ITEM_M bm
							      ,dbo.scm_plant_m pm
						       WHERE bm.item_id  = @ITEM_ID
						         and bm.SITE_ID  = pm.SITE_ID -- 2019-07-23 kimcd item에 company id 추가하면서 site join한 table 오류 찾아서 수정함.
								 and bm.COMPANY_ID = pm.COMPANY_ID -- 2019-07-23 kimcd item에 company id 추가
							   and pm.PLANT_ID = @FP_PLANT_ID
						       and bm.ACTIVE_FLAG = 'Y' ) a
						     ;
			
			        select top 1 @PERIOD_VAL = counta
						 from (
						      SELECT CASE  WHEN @START_TIME > @END_TIME THEN 0
							             ELSE 1 END counta
							 ) a
			                 ;          
			
			        select top 1 @PAST_VAL  = counta
						 from (
						      SELECT CASE  WHEN convert( varchar, getdate() , 112) > convert( varchar, cast( substring( @START_TIME ,1,8) as datetime), 112 ) THEN 0
							             ELSE 1 END counta
							 ) a
			                 ; 

			        select top 1 @ORDER_TYPE_VAL  = counta
						 from (
						         SELECT COUNT(1) counta
								   FROM dbo.FP_INSTANCE_CONFIG_M  
								  WHERE INSTANCE_ID = 'COMMON' 
								    AND CATEGORY_ID = 'DEMAND_TYPE' 
									AND KEY_ID = @ORDER_TYPE
						      ) a
						     ;

                SET @FP_WO_TYPE = 'MO'

			    IF (select count(1) -- WO인 경우에
					  from dbo.SCM_OPERATION_M  a
				          ,dbo.SCM_FACTORY_M  b
					 where a.operation_id = @OPERATION_ID   
					   and a.WO_FLAG      = 'Y'
					   and a.SITE_ID      = b.SITE_ID
					   and a.DIVISION_ID  = b.DIVISION_ID
					   and a.ACTIVE_FLAG  = 'Y'
					   and a.ACTIVE_FLAG  = b.ACTIVE_FLAG
					   and b.FACTORY_ID   = @FACTORY_ID     ) > 0
						   SET @FP_WO_TYPE = 'WO'			

			    SET @ERR_MESSAGE = ''
			
				IF  @ASSIGN_VAL = 0  AND @FP_WO_TYPE = 'WO'  AND @WO_ID is null			-- WO 일 경우에만 BOM 전송 validation이 필요함. 
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'LINE ASSIGN 없음'
		
				IF  @ASSIGN_ERP_VAL = 0 AND @FP_WO_TYPE = 'WO'  AND @WO_ID is null			-- WO 일 경우에만 ERP 전송 validation이 필요함.
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'ERP LINE ASSIGN 전송 정보 없음'
				  			  
				IF  @BOM_VAL = 0 AND @FP_WO_TYPE = 'WO'  AND @WO_ID is null			-- WO 일 경우에만 BOM 전송 validation이 필요함. 
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'BOM 없음'	
				  
				IF  @FLOW_VAL = 0  AND @WO_ID is null
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'MES FLOW 없음'		-- FP-058 kimcd 2017-05-28 조회문으로 봐선.. operation flow를 찾아오지 못 함.?

				IF  @ORDER_TYPE_VAL = 0  AND @WO_ID is null
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'ORDER TYPE 확인필요'		
				  	
				IF  @PERIOD_VAL = 0  AND @WO_ID is null
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'시작일자가 종료일자보다 빠름'		

				IF  @PAST_VAL = 0 AND @WO_ID is null
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'시작일자가 오늘보다 과거임. 빠름'	
							  		  	  		   
                IF  @NEW_WORK_ORDER = '0'  AND @WO_ID is null
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'WO를 채번할 수 없습니다'
				
			
		    IF @ERR_MESSAGE != ''
			   begin
		                 UPDATE [dbo].[SCM_MANUAL_WO_CREATE]
		                    SET [PROCESSING_YN] = 'N'
		                       ,ERROR_MSG = 'ERROR' + @ERR_MESSAGE
							   ,update_date = getdate()
		                  WHERE SEQ = @SEQ
						    AND WO_BASE_DATE  = @WO_BASE_DATE   
               end 
			ELSE
						 begin

							SET @IFSQENO = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(26),GETDATE(),21),'-',''),':',''),' ',''),'.',''),1,16)

						    -- ADJUST 인 경우
						    IF @STATUS in ( 'UPDATE','DELETE') -- @MO_ID IS NOT NULL OR LEN(@MO_ID) > 0 
						      BEGIN
							    IF @WO_SEQ = 1  --( @WO_ID IS NOT NULL OR LEN(@WO_ID) > 0 ) AND @WO_SEQ = 1 
								   BEGIN

						      			-- ERP로 WO 변경 정보 생성 전송
											INSERT INTO [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S]
												   ([IFSEQNO]
												   ,[SEQ]
												   ,[FP_PLAN_ID]
												   ,[PLANT_ID]
												   ,[FACTORY_ID]
												   ,[LINE_ID]
												   ,[OPERATION_ID]
												   ,[BOM_VERSION_ID]
												   ,[WORK_CENTER_ID]
												   ,[ITEM_ID]
												   ,[DEMAND_ID]
												   ,[WORK_ORDER_ID]
												   ,[ORDER_TYPE]
												   ,[PLAN_DATE]
												   ,[START_TIME]
												   ,[END_TIME]
												   ,[PLAN_IN_QTY]
												   ,[PLAN_QTY]
												   ,[FIX_TYPE]
												   ,[TRANSFER_FLAG]
												   ,[TRANSFER_DATE]
												   ,[CREATE_USER_ID]
												   ,[CREATE_DATE]
												   ,[MODIFY_USER_ID]
												   ,[MODIFY_DATE]
												   ,[LANE_QTY]
												   ,[BATCH_ORDER_ID]
												   ,[SLITTER_PLANT]
												   ,[MARKET]
												   ,[ATTRIBUTE1]
												   ,[ATTRIBUTE2]
												   ,[ATTRIBUTE3]
												   ,[ATTRIBUTE4]
												   ,[ATTRIBUTE5]
												   ,[ATTRIBUTE6]
												   ,[ATTRIBUTE7]
												   ,[ATTRIBUTE8]
												   ,[ATTRIBUTE9]
												   ,[ATTRIBUTE10]
												   -- FP-058 kimcd 컬럼 추가 시작. 2017-05-28 
												   ,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
												   ,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
												   ,[FP_PLAN_QTY]  -- FP Plan 수량
												   ,[FP_SNAP_QTY]) -- FP 실적 수량
												   -- FP-058 kimcd 컬럼 추가 끝. 2017-05-28
											select @IFSQENO   -- [IFSEQNO] --2017-10-26 16자리로 변경
											      ,1 -- row_number() over ( order by line_id, item_id) --[SEQ]
												  ,ISNULL(@FP_PLAN_ID,FP_PLAN_ID) --[FP_PLAN_ID]
											      ,[PLANT_ID]
											      ,@FACTORY_ID AS [FACTORY_ID]						-- PIYONG 2017-09-18 변수로 변경
											      ,ISNULL(@MES_LINE_ID,LINE_ID) -- [LINE_ID]
											      ,[OPERATION_ID]
											      ,[BOM_VERSION_ID]
											      ,@ERP_WORK_CENTER_ID AS [WORK_CENTER_ID]			-- PIYONG 2017-09-18 변수로 변경
											      ,[ITEM_ID]
											      ,[DEMAND_ID]
											      ,a.[WORK_ORDER_ID]
											      ,ISNULL(@ORDER_TYPE, [ORDER_TYPE] )
												  ,CASE WHEN ISNULL(SUBSTRING(@START_TIME, 1, 8), PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE @TOTAL_IN_QTY END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN	      -- [PLAN_DATE]
															CONCAT(CONVERT(NVARCHAR(8),DATEADD(DAY, -1, GETDATE()), 112), '000000')
														 ELSE
															ISNULL(@PLAN_DATE, PLAN_DATE)
														  END AS PLAN_DATE										--2017-10-10  PIYONG  변경
												  ,CASE WHEN ISNULL(SUBSTRING(@START_TIME, 1, 8), PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE @TOTAL_IN_QTY END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN	      -- [START_TIME]
															CONCAT(CONVERT(NVARCHAR(8),DATEADD(DAY, -1, GETDATE()), 112), '060000')
														ELSE
															ISNULL(@START_TIME, START_TIME)
														END AS START_TIME										--2017-10-10  PIYONG  변경
												  ,CASE WHEN ISNULL(SUBSTRING(@START_TIME, 1, 8), PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE @TOTAL_IN_QTY END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN		  -- [END_TIME]
															CONCAT(CONVERT(NVARCHAR(8),DATEADD(DAY, -1, GETDATE()), 112), '061000')
														ELSE
															ISNULL(@END_TIME, END_TIME)
														END AS END_TIME											--2017-10-10  PIYONG  변경
											      ,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE ISNULL(@TOTAL_IN_QTY, PLAN_IN_QTY) END  -- [PLAN_IN_QTY]
											      ,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_OUT_QTY = 0 THEN PLAN_QTY ELSE ISNULL(@TOTAL_OUT_QTY, PLAN_QTY) END  -- [PLAN_QTY]
											      ,'Y' --[FIX_TYPE]
											      ,'N' --[TRANSFER_FLAG]
											      ,[TRANSFER_DATE]
											      ,[CREATE_USER_ID]
											      ,[CREATE_DATE]
											      ,@UPDATE_PSN_ID + '_MANUAL_ADJST' -- [MODIFY_USER_ID]
											      ,getdate() -- [MODIFY_DATE]
											      ,ISNULL(@FP_LANE_QTY, LANE_QTY) -- [LANE_QTY]
											      ,[BATCH_ORDER_ID]
											      ,ISNULL(@FP_SLITING_PLANT_ID, SLITTER_PLANT) --[SLITTER_PLANT]
											      ,ISNULL(@MARKET, MARKET) -- [MARKET]
											      ,[ATTRIBUTE1]
											      ,[ATTRIBUTE2]
											      ,[ATTRIBUTE3]
											      ,[ATTRIBUTE4]
											      ,[ATTRIBUTE5]
											      ,[ATTRIBUTE6]
											      ,[ATTRIBUTE7]
											      ,[ATTRIBUTE8]
											      ,[PLAN_IN_QTY]
											      ,[PLAN_QTY]
												   -- FP-058 kimcd 컬럼 추가 시작. 2017-05-28 
												  ,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
												  ,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
												  ,[FP_PLAN_QTY]  -- FP Plan 수량
												  ,[FP_SNAP_QTY]  -- FP 실적 수량
												   -- FP-058 kimcd 컬럼 추가 끝. 2017-05-28
											  from [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] a with(nolock)
					  							  ,(
												      select IFSEQNO, b.[WORK_ORDER_ID] , row_number() over( partition by [WORK_ORDER_ID] order by MODIFY_DATE desc) rownums
													    from [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] b
                                                       where  b.[WORK_ORDER_ID]  = @WO_ID 
												   ) x
											 where a.[WORK_ORDER_ID]  = x.WORK_ORDER_ID
											   and a.IFSEQNO          = x.IFSEQNO
											   and x.rownums          = 1
											 ;

											IF @INSTANCE_ID IS NOT NULL AND @INSTANCE_DATE IS NOT NULL
												BEGIN
													UPDATE [DBO].[FP_RELEASE_FIX_PLAN_H]
													   SET [PLAN_DATE]       = ISNULL(cast ( substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) as datetime)
																					  , PLAN_DATE)
														  ,[START_TIME]      = ISNULL(cast ( substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) as datetime)
																					 , START_TIME)
														  ,[END_TIME]        = ISNULL(cast ( substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) as datetime)
																					 , END_TIME)
														  ,[PLAN_QTY]        = CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_OUT_QTY = 0 THEN PLAN_QTY ELSE ISNULL(@TOTAL_OUT_QTY-ISNULL(@RESULT_QTY,0), PLAN_QTY) END  -- 2017-09-19 kimcd 실적 수량 제외.-@RESULT_QTY 로직 추가
														  ,[PLAN_IN_QTY]     = CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE ISNULL(@TOTAL_IN_QTY-ISNULL(@RESULT_QTY,0), PLAN_IN_QTY) END -- 2017-09-19 kimcd 실적 수량 제외.-@RESULT_QTY 로직 추가
														  ,[PRODUCTION_TYPE] = ISNULL(@ORDER_TYPE, [PRODUCTION_TYPE] )
														  ,[MARKET]          = ISNULL(@MARKET, MARKET)
														  ,[INSERT_ID]       = 'PR_SCM_MANUAL_ORDER_CREATE_MANUAL_WO_ADJ'
														  ,[INSERT_TIME]     = getdate()
														  ,[TOP_ITEM_ID]     = ISNULL(@TOP_ITEM_ID, [TOP_ITEM_ID])-- 2018-01-09 kimcd 최상위 품목 컬럼 추가
														  ,[WORK_REQUEST_MODEL_ID] = ISNULL(ISNULL(@WORK_REQUEST_MODEL_ID,[WORK_REQUEST_MODEL_ID]),'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														  ,[VERSION]   = ISNULL(ISNULL(@VERSION,[VERSION]),'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														  ,[PROD_SEQ]  = ISNULL(@PROD_SEQ,[PROD_SEQ]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														  ,[PLM_EC_NO] = ISNULL(ISNULL(@PLM_EC_NO,[PLM_EC_NO]),'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													 WHERE [INSTANCE_ID]   = @INSTANCE_ID
													   AND [INSTANCE_DATE] = @INSTANCE_DATE
													   AND [WORK_ORDER_ID] = @WO_ID
													;

													UPDATE [DBO].[FP_RELEASE_FULL_PLAN_H]
													   SET [PLAN_DATE]       = ISNULL(cast ( substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) as datetime)
																					  , PLAN_DATE)
														  ,[START_TIME]      = ISNULL(cast ( substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) as datetime)
																					 , START_TIME)
														  ,[END_TIME]        = ISNULL(cast ( substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) as datetime)
																					 , END_TIME)
														  ,[PLAN_QTY]        = CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_OUT_QTY = 0 THEN PLAN_QTY ELSE ISNULL(@TOTAL_OUT_QTY-ISNULL(@RESULT_QTY,0), PLAN_QTY) END  -- 2017-09-19 kimcd 실적 수량 제외.-@RESULT_QTY 로직 추가
														  ,[PLAN_IN_QTY]     = CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE ISNULL(@TOTAL_IN_QTY-ISNULL(@RESULT_QTY,0), PLAN_IN_QTY) END  -- 2017-09-19 kimcd 실적 수량 제외.-@RESULT_QTY 로직 추가
														  ,[PRODUCTION_TYPE] = ISNULL(@ORDER_TYPE, [PRODUCTION_TYPE] )
														  ,[MARKET]          = ISNULL(@MARKET, MARKET)
														  ,[INSERT_ID]       = 'PR_SCM_MANUAL_ORDER_CREATE_MANUAL_WO_ADJ'
														  ,[INSERT_TIME]     = getdate()
														  ,[TOP_ITEM_ID]     = ISNULL(@TOP_ITEM_ID, [TOP_ITEM_ID])-- 2018-01-09 kimcd 최상위 품목 컬럼 추가
														  ,[WORK_REQUEST_MODEL_ID] = ISNULL(ISNULL(@WORK_REQUEST_MODEL_ID,[WORK_REQUEST_MODEL_ID]),'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														  ,[VERSION]   = ISNULL(ISNULL(@VERSION,[VERSION]),'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														  ,[PROD_SEQ]  = ISNULL(@PROD_SEQ,[PROD_SEQ]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														  ,[PLM_EC_NO] = ISNULL(ISNULL(@PLM_EC_NO,[PLM_EC_NO]),'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													 WHERE [INSTANCE_ID]   = @INSTANCE_ID
													   AND [INSTANCE_DATE] = @INSTANCE_DATE
													   AND [WORK_ORDER_ID] = @WO_ID
													;
												END

                                            -- FP-058 kimcd 컬럼 추가 시작. 2017-05-30
											INSERT INTO [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S]
												   ([IFSEQNO]
												   ,[SEQ]
												   ,[FP_PLAN_ID]
												   ,[PLANT_ID]
												   ,[FACTORY_ID]
												   ,[LINE_ID]
												   ,[OPERATION_ID]
												   ,[BOM_VERSION_ID]
												   ,[WORK_CENTER_ID]
												   ,[ITEM_ID]
												   ,[DEMAND_ID]
												   ,[WORK_ORDER_ID]
												   ,[ORDER_TYPE]
												   ,[PLAN_DATE]
												   ,[START_TIME]
												   ,[END_TIME]
												   ,[PLAN_IN_QTY]
												   ,[PLAN_QTY]
												   ,[FIX_TYPE]
												   ,[TRANSFER_FLAG]
												   ,[TRANSFER_DATE]
												   ,[CREATE_USER_ID]
												   ,[CREATE_DATE]
												   ,[MODIFY_USER_ID]
												   ,[MODIFY_DATE]
												   ,[LANE_QTY]
												   ,[BATCH_ORDER_ID]
												   ,[SLITTER_PLANT]
												   ,[MARKET]
												   ,[ATTRIBUTE1]
												   ,[ATTRIBUTE2]
												   ,[ATTRIBUTE3]
												   ,[ATTRIBUTE4]
												   ,[ATTRIBUTE5]
												   ,[ATTRIBUTE6]
												   ,[ATTRIBUTE7]
												   ,[ATTRIBUTE8]
												   ,[ATTRIBUTE9]
												   ,[ATTRIBUTE10]
												   -- FP-058 kimcd 컬럼 추가 시작. 2017-05-28 
												   ,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
												   ,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
												   ,[FP_PLAN_QTY]  -- FP Plan 수량
												   ,[FP_SNAP_QTY]  -- FP 실적 수량
												   -- FP-058 kimcd 컬럼 추가 끝. 2017-05-28
												   )
											SELECT CONVERT(NVARCHAR(26),CONVERT(NUMERIC(18),@IFSQENO)+1)   -- [IFSEQNO] --2017-10-26 16자리로 변경 -- 2017-11-06 SEQ 중복 처리
											      ,1 -- row_number() over ( order by line_id, item_id) --[SEQ]
												  ,ISNULL(@FP_PLAN_ID,FP_PLAN_ID) --[FP_PLAN_ID]
											      ,[PLANT_ID]
											      ,@FACTORY_ID AS [FACTORY_ID]					-- PIYONG 2017-09-18 변수로 변경
											      ,ISNULL(@MES_LINE_ID,LINE_ID) -- [LINE_ID]
											      ,[OPERATION_ID]
											      ,[BOM_VERSION_ID]
											      ,@ERP_WORK_CENTER_ID AS [WORK_CENTER_ID]		-- PIYONG 2017-09-18 변수로 변경
											      ,[ITEM_ID]
											      ,[DEMAND_ID]
											      ,A.[WORK_ORDER_ID]
											      ,ISNULL(@ORDER_TYPE, [ORDER_TYPE] )
												  ,CASE WHEN ISNULL(SUBSTRING(@START_TIME,1,8), PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE @TOTAL_IN_QTY END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN	      -- [PLAN_DATE]
															CONCAT(CONVERT(NVARCHAR(8),DATEADD(DAY, -1, GETDATE()), 112), '000000')
														 ELSE
															ISNULL(@PLAN_DATE, PLAN_DATE)
														  END AS PLAN_DATE										--2017-10-10  PIYONG  변경
												  ,CASE WHEN ISNULL(SUBSTRING(@START_TIME,1,8), PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE @TOTAL_IN_QTY END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN	      -- [START_TIME]
															CONCAT(CONVERT(NVARCHAR(8),DATEADD(DAY, -1, GETDATE()), 112), '060000')
														ELSE
															ISNULL(@START_TIME, START_TIME)
														END AS START_TIME										--2017-10-10  PIYONG  변경
												  ,CASE WHEN ISNULL(SUBSTRING(@START_TIME,1,8), PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE @TOTAL_IN_QTY END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN		  -- [END_TIME]
															CONCAT(CONVERT(NVARCHAR(8),DATEADD(DAY, -1, GETDATE()), 112), '061000')
														ELSE
															ISNULL(@END_TIME, END_TIME)
														END AS END_TIME
											      ,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE ISNULL(@TOTAL_IN_QTY, PLAN_IN_QTY) END  -- [PLAN_IN_QTY]
											      ,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_OUT_QTY = 0 THEN PLAN_QTY ELSE ISNULL(@TOTAL_OUT_QTY, PLAN_QTY) END  -- [PLAN_QTY]
											      ,'Y' --[FIX_TYPE]
											      ,'N' --[TRANSFER_FLAG]
											      ,[TRANSFER_DATE]
											      ,[CREATE_USER_ID]
											      ,[CREATE_DATE]
											      ,@UPDATE_PSN_ID + '_MANUAL_ADJST' -- [MODIFY_USER_ID]
											      ,getdate() -- [MODIFY_DATE]
											      ,ISNULL(@FP_LANE_QTY, LANE_QTY) -- [LANE_QTY]
											      ,[BATCH_ORDER_ID]
											      ,ISNULL(@FP_SLITING_PLANT_ID, SLITTER_PLANT) --[SLITTER_PLANT]
											      ,ISNULL(@MARKET, MARKET) -- [MARKET]
											      ,[ATTRIBUTE1]
											      ,[ATTRIBUTE2]
											      ,[ATTRIBUTE3]
											      ,[ATTRIBUTE4]
											      ,[ATTRIBUTE5]
											      ,[ATTRIBUTE6]
											      ,[ATTRIBUTE7]
											      ,[ATTRIBUTE8]
											      ,[PLAN_IN_QTY]
											      ,[PLAN_QTY]
												   -- FP-058 kimcd 컬럼 추가 시작. 2017-05-28 
												  ,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
												  ,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
												  ,[FP_PLAN_QTY]  -- FP Plan 수량
												  ,[FP_SNAP_QTY]  -- FP 실적 수량
												   -- FP-058 kimcd 컬럼 추가 끝. 2017-05-28
											  from [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] a with(nolock)
					  							  ,(
												      select IFSEQNO, b.[WORK_ORDER_ID] , row_number() over( partition by [WORK_ORDER_ID] order by MODIFY_DATE desc) rownums
													    from [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] b
                                                       where  b.[WORK_ORDER_ID]  = ( SELECT TOP 1 C.LINK_WO
																					 FROM   [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] C
																					 WHERE  C.[WORK_ORDER_ID]  = @WO_ID 
																					 AND    C.LINK_WO IS NOT NULL )
												   ) x
											 where a.[WORK_ORDER_ID]  = x.WORK_ORDER_ID
											   and a.IFSEQNO          = x.IFSEQNO
											   and x.rownums          = 1
											 ;
											-- FP-058 kimcd 컬럼 추가 끝. 2017-05-30

                                   END

								--기 발행된 WO의 FACTORY_ID 와 @FACTORY_ID가 다른 경우 최종 수량이 0되므로 이전 수량, 날짜을 미리 구해 온다						
								-- 2017-11-08 
								SELECT @BEFORE_IN_QTY = IN_QTY
									   ,@BEFORE_OUT_QTY = OUT_QTY
									   ,@BEFORE_PLAN_DATE = PLAN_DATE
									   ,@BEFORE_START_TIME = START_TIME
									   ,@BEFORE_END_TIME= END_TIME
								  FROM (
										SELECT IN_QTY
											   ,OUT_QTY
											   ,PLAN_DATE
											   ,START_TIME
											   ,END_TIME
											   ,ROW_NUMBER() OVER( PARTITION BY B.WO ORDER BY IF_SEQ DESC) ROWNUMS
										  FROM [DBO].[SY_XIF_MES_WO_S] B
										 WHERE B.WO  = @WO_ID 
										   AND IF_ID != 'OFP0_OPLM_FP_WO'
										) x
								  WHERE ROWNUMS = 1
											

								   --2017-11-08 PIYONG  기 발행된 WO의 MES_SOURCE_GROUP 와 @FACTORY_ID의 MES_SOURCE_GROUP가 다른 경우 기 발행한 WO를 삭제   시작
								   ---------------------------------------------------------------------------------------------------------
								   ---------------------------------------------------------------------------------------------------------
								   ---------------------------------------------------------------------------------------------------------

								   -- 2021-05-25 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
									IF 'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,(SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = @FACTORY_ID)) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = @FACTORY_ID AND L.LINE_ID = @MES_LINE_ID ),'') +'_'+'FP_WO' != (
																																														 SELECT TOP 1 IF_ID
																																														   FROM [DBO].[SY_XIF_MES_WO_S] B
																																														  WHERE B.WO  = @WO_ID 
																																															AND IF_ID != 'OFP0_OPLM_FP_WO'
																																														  ORDER BY IF_SEQ DESC
																																														)
										BEGIN

											UPDATE [SY_XIF_MES_WO_S]
											   SET [LINE_ID] = ISNULL(@MES_LINE_ID, @LINE_ID)
												   ,[BUILNO]  = @FACTORY_ID
												   ,[EQUIPMENT_ID] = @EQUIPMENT_ID
												   ,ATTR_10 = @LINE_ID								-- 2017-11-08  PIYONG FP_LINE 추가
											  FROM (
													SELECT ROW_NUMBER() OVER ( PARTITION BY A.WO_DETAIL, A.LINE_ID  ORDER BY A.IF_SEQ DESC ) ROWNUMS
														   ,A.PLAN_ID, A.WO_DETAIL, A.LINE_ID, A.BUILNO, A.EQUIPMENT_ID
													  FROM [SY_XIF_MES_WO_S] A
														   ,[FP_RELEASE_FIX_PLAN_H] B
													 WHERE 1=1
													   AND A.WO = B.WORK_ORDER_ID
													   AND A.[PLAN_ID] = B.RELEASE_PLAN_ID
													   AND A.WO = @WO_ID
												   ) ZZ
											 WHERE [SY_XIF_MES_WO_S].PLAN_ID   = ZZ.PLAN_ID
											   AND [SY_XIF_MES_WO_S].WO_DETAIL = ZZ.WO_DETAIL
											   AND ZZ.ROWNUMS = 1
											;


											UPDATE FP_RELEASE_FIX_PLAN_H
											   SET LINE_ID			= @LINE_ID
											       ,FACTORY_ID		= @FACTORY_ID
												   ,EQUIPMENT_ID	= @EQUIPMENT_ID
												   ,UPDATE_ID		= 'PR_SCM_MANUAL_ORDER_CREATE'
												   ,UPDATE_TIME		= GETDATE()
											  FROM (
													 SELECT INSTANCE_DATE, B.WORK_ORDER_ID, B.RELEASE_PLAN_ID, ROW_NUMBER() OVER( PARTITION BY B.WORK_ORDER_ID ORDER BY INSTANCE_DATE DESC) ROWNUMS
													   FROM [DBO].[FP_RELEASE_FIX_PLAN_H] B
													  WHERE WORK_ORDER_ID = @WO_ID
												   ) x
											 WHERE FP_RELEASE_FIX_PLAN_H.WORK_ORDER_ID      = X.WORK_ORDER_ID
											   AND FP_RELEASE_FIX_PLAN_H.INSTANCE_DATE = X.INSTANCE_DATE
											   AND FP_RELEASE_FIX_PLAN_H.RELEASE_PLAN_ID    = X.RELEASE_PLAN_ID
											   AND X.ROWNUMS = 1											


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
													--,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
													,[ATTR_02]
													--,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
													,[ATTR_04]
													,[ATTR_05]
													,[ATTR_06]
													,[ATTR_07]
													,[ATTR_08]
													,[ATTR_09]
													,[ATTR_10]
													,[ATTR_11]
													,[ATTR_12]	--PIYONG 2017-11-21 ADD
													,[ATTR_30]  --@PDS_IFSEQNO
											)
											SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
													,[IF_TYPE]
													 -- 2021-05-25 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
													,'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,(SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = SOURCES.[BUILNO])) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = SOURCES.[BUILNO] AND L.LINE_ID = SOURCES.LINE_ID ),'') +'_'+'FP_WO' -- [IF_ID]
													,GETDATE() -- [IF_INS_DATE] 2020-07-27 kimcd 전송용 정보 형성 일자를 현재일로 입력
													,'N'  --[IF_FLAG]
													,NULL -- 2017-11-08 PIYONG NULL처리
													,NULL -- [RSLT_IF_SEQ]
													,NULL --[RSLT_PROC_FLAG]
													,NULL --[RSLT_PROC_MSG]
													,ISNULL(@FP_PLAN_ID, PLAN_ID) AS [PLAN_ID]
													,[PLANT_ID]
													,BUILNO
													,LINE_ID
													,[OPERATION_ID]
													,EQUIPMENT_ID
													,[ITEM_ID]
													,[DEMAND_ID]
													,SOURCES.[WO]
													,ISNULL(WO_TYPE, @FP_WO_TYPE )
													,SOURCES.[WO_DETAIL]
													,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@BEFORE_PLAN_DATE,1,10)), PLAN_DATE) > GETDATE() THEN	      -- [PLAN_DATE] -- 2017-11-08 PIYONG 다른 MES INSTANCE로 변경되는 경우. 기존 전송된 값 기준으로 판단하고 일자 과거 일자로 변경.
															CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 00:00:00')
														  ELSE
															ISNULL(@BEFORE_PLAN_DATE, PLAN_DATE)
													      END AS PLAN_DATE
												    ,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@BEFORE_START_TIME,1,10)), PLAN_DATE) > GETDATE() THEN		  -- [START_TIME] -- 2017-11-08 PIYONG 다른 MES INSTANCE로 변경되는 경우. 기존 전송된 값 기준으로 판단하고 일자 과거 일자로 변경.
															CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:00:00')
														  ELSE
															ISNULL(@BEFORE_START_TIME, START_TIME)
														  END AS START_TIME
												    ,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@BEFORE_START_TIME,1,10)), PLAN_DATE) > GETDATE() THEN	       -- [END_TIME]  -- 2017-11-08 PIYONG 다른 MES INSTANCE로 변경되는 경우. 기존 전송된 값 기준으로 판단하고 일자 과거 일자로 변경.
															CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:10:00')
														  ELSE
															ISNULL(@BEFORE_END_TIME, END_TIME)
														  END AS END_TIME
													,0  -- [IN_QTY]
													,0  -- [OUT_QTY]
													,[IS_RELEASE]
													,[CREATE_PSN_ID]
													,getdate() --[CREATE_DATE]
													,@UPDATE_PSN_ID + '_MANUAL_ADJST' -- [UPDATE_PSN_ID]
													,getdate() --[UPDATE_DATE]
													,[LANE_QTY]
													,[UNIT]
													,[ORDER_TYPE]
													,[BATCH_ORDER_ID]
													,[SLITTER_PLANT]
													,[MARKET]
													--,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
													,[ATTR_02]
													--,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
													,[ATTR_04]
													,[ATTR_05]
													,[ATTR_06]
													,[ATTR_07]
													,[ATTR_08]
													,[ATTR_09]
													,[ATTR_10]
													,[ATTR_11]
													,[ATTR_12] --PIYONG 2017-11-21 ADD
													,@PDS_IFSEQNO
												FROM [DBO].[SY_XIF_MES_WO_S] SOURCES
													,(
														SELECT IF_SEQ, B.WO, B.WO_DETAIL , ROW_NUMBER() OVER( PARTITION BY B.WO ORDER BY IF_SEQ DESC) ROWNUMS
															FROM [DBO].[SY_XIF_MES_WO_S] B
															WHERE B.WO  = @WO_ID 
															AND IF_ID != 'OFP0_OPLM_FP_WO'
													) x
												WHERE SOURCES.[WO]      = X.WO
												AND SOURCES.WO_DETAIL = X.WO_DETAIL
												AND SOURCES.IF_SEQ    = X.IF_SEQ
												AND X.ROWNUMS = 1
										END
								   --2017-11-08 PIYONG 기 발행된 WO의 MES_SOURCE_GROUP 와 @FACTORY_ID의 MES_SOURCE_GROUP가 다른 경우 기 발행한 WO를 삭제   종료
								   ---------------------------------------------------------------------------------------------------------
								   ---------------------------------------------------------------------------------------------------------
								   ---------------------------------------------------------------------------------------------------------

						      	-- MES로 MO 변경 정보 생성 전송
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
											,[ATTR_11] -- 2017-11-08 PIYONG 추가
											,[ATTR_12] --PIYONG 2017-11-21 ADD
											,[ATTR_17] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,[ATTR_18] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,[ATTR_19] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,[ATTR_20] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,[ATTR_30] -- @PDS_IFSEQNO
									) 
									select 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
											,[IF_TYPE]
											 -- 2021-05-25 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
											,'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,ISNULL(F.MES_SOURCE_GROUP,'') ) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = @FACTORY_ID AND L.LINE_ID = @MES_LINE_ID ),'') +'_'+'FP_WO' -- [IF_ID]
											,GETDATE() -- [IF_INS_DATE] 2020-07-27 kimcd 정보 전송 일자를 현재 시간으로 입력
											,'N' --[IF_FLAG]
											,NULL				-- 2017-11-08 PIYONG NULL 처리
											,NULL -- [RSLT_IF_SEQ]
											,NULL--[RSLT_PROC_FLAG]
											,NULL--[RSLT_PROC_MSG]
											,ISNULL(@FP_PLAN_ID, PLAN_ID) --[PLAN_ID]
											,SOURCES.[PLANT_ID]
											,@FACTORY_ID AS [BUILNO]			-- PIYONG 2017-09-18 변수로 변경
											,ISNULL(@MES_LINE_ID, LINE_ID) -- [LINE_ID]
											,[OPERATION_ID]
											,@EQUIPMENT_ID
											,SOURCES.[ITEM_ID]
											,[DEMAND_ID]
											,SOURCES.[WO]
											,ISNULL(@WO_TYPE, @FP_WO_TYPE )		-- NULL 2017-10-26 PIYONG
											,SOURCES.[WO_DETAIL]
											-- 일자 넣는 과정.. 수량 받아오는 것과 동일 로직으로 전환 필요 2017-11-07
											,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), @BEFORE_PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN	      -- [PLAN_DATE] 
													CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 00:00:00')
												ELSE
													ISNULL((substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) ), plan_date)
													END AS PLAN_DATE														--2017-10-26  PIYONG  변경
											,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), @BEFORE_PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN		  -- [START_TIME]
													CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:00:00')
												ELSE
													ISNULL((substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) ), start_time)
													END AS START_TIME														--2017-10-26  PIYONG  변경
											,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), @BEFORE_PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN	       -- [END_TIME]
													CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:10:00')
												ELSE
													ISNULL((substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) ), end_time)
													END AS END_TIME														--2017-10-26  PIYONG  변경
											,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END  -- [IN_QTY]					--2017-10-26 PIYONG  IN_QTY- > @BEFORE_IN_QTY 변경
											,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @OUT_QTY = 0 THEN @BEFORE_OUT_QTY ELSE ISNULL(@OUT_QTY, @BEFORE_OUT_QTY) END  -- [OUT_QTY]				--2017-10-26 PIYONG  OUT_QTY- > @@BEFORE_OUT_QTY 변경
											,[IS_RELEASE]
											,[CREATE_PSN_ID]
											,getdate() --[CREATE_DATE]
											,@UPDATE_PSN_ID + '_MANUAL_ADJST' -- [UPDATE_PSN_ID]
											,getdate() --[UPDATE_DATE]
											,ISNULL(@FP_LANE_QTY, LANE_QTY) -- [LANE_QTY]
											,[UNIT]
											,ISNULL(@ORDER_TYPE, [ORDER_TYPE] )
											,[BATCH_ORDER_ID]
											,ISNULL(@MES_SLITING_PLANT_ID, SLITTER_PLANT) --[SLITTER_PLANT]  -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
											,ISNULL(@MARKET, MARKET) -- [MARKET]
											-- ,CASE WHEN [OPERATION_ID] in ( 'E0500','E1000' ) THEN ISNULL(@BATCH_QTY,ATTR_01) ELSE null END  -- [ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
											,CASE WHEN [OPERATION_ID] in ( 'E0500','E1000' ) THEN ISNULL(@BATCH_QTY,ATTR_02) ELSE null END  -- [ATTR_02]
											-- ,CASE WHEN [OPERATION_ID] in ( 'E0500','E1000' ) THEN ISNULL(@IN_QTY,ATTR_03) ELSE null END  -- [ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
											,ISNULL(@MARKET, MARKET) -- [ATTR_04]
											,[ATTR_05]
											,[ATTR_06]
											,[ATTR_07]
											,[ATTR_08]
											,[ATTR_09]
											,@LINE_ID
											,[ATTR_11]
											,ISNULL(@TOP_ITEM_ID, [ATTR_12]) --PIYONG 2017-11-21 ADD 2018-01-09 kimcd 최상위 품목 컬럼 추가
											,CASE WHEN ISNULL(@WORK_REQUEST_MODEL_ID,[ATTR_17]) = '-' THEN NULL ELSE ISNULL(@WORK_REQUEST_MODEL_ID,[ATTR_17]) END -- 2023-03-03 kimcd NJ 버전 예외 처리 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,CASE WHEN ISNULL(@VERSION,[ATTR_18]) = '-' THEN NULL -- [E20250918-001592] PDS 적용 인스턴스에서 PLM 버전을 자르고 사용할 경우 예외 처리 PLM_VERSION_FLAG 으로 구분
												  -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_PDS_VERSION_M] outer join 추가. PDS VERSION table 우선 사용.
											      ELSE CASE WHEN  F.ELEC_VERSION_TYPE = 'FP' THEN ISNULL(@VERSION,[ATTR_18])
												            ELSE CASE WHEN ISNULL(Y.PLM_VERSION_FLAG,'N') = 'N' 
																	  AND  ISNULL ( ( SELECT TOP 1 'Y'
																					  FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  A WITH(NOLOCK)	
																					  WHERE 1=1
																					  AND A.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
																					  AND A.ACTIVE_FLAG = 'Y'
																					  AND A.SEGMENT1    =  @INSTANCE_ID ), 'N') = 'Y' THEN  ISNULL(ISNULL(PVM.[PDS_VERSION],@VERSION),[ATTR_18]) ELSE ISNULL(SUBSTRING(@VERSION,1,3),[ATTR_18]) END 
															END
											 END -- 2023-03-03 kimcd NJ 버전 예외 처리 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,ISNULL(@PROD_SEQ,[ATTR_19]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,ISNULL(@PLM_EC_NO,[ATTR_20]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,@PDS_IFSEQNO
										from [DBO].[SY_XIF_MES_WO_S] SOURCES
										     INNER JOIN SCM_FACTORY_M F  WITH(NOLOCK)
											     ON F.FACTORY_ID = @FACTORY_ID
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
															) Y
											ON	1=1
											AND @FACTORY_ID			= Y.FACTORY_ID
											AND SOURCES.ITEM_ID		= Y.ITEM_ID
											AND ISNULL(@WORK_REQUEST_MODEL_ID,[ATTR_17])	= Y.MODEL_ID
											AND ISNULL(@VERSION,[ATTR_18])					= Y.PROD_VERSION
											-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_PDS_VERSION_M] outer join 추가
											LEFT OUTER JOIN [dbo].[FP_PDS_VERSION_M]  PVM WITH(NOLOCK)
												ON 	PVM.[FACTORY_ID] = @FACTORY_ID
												AND PVM.[MODEL_ID]   = ISNULL(@WORK_REQUEST_MODEL_ID,SOURCES.[ATTR_17])
												AND PVM.[VERSION]    = ISNULL(@VERSION,SOURCES.[ATTR_18])
											,(
												SELECT IF_SEQ, B.WO, B.WO_DETAIL , ROW_NUMBER() OVER( PARTITION BY B.WO, B.WO_DETAIL ORDER BY IF_SEQ DESC) ROWNUMS -- 2017-11-08 PIYONG ROWNUM ORDER BY  IF_SEQ로 변경
												  FROM [DBO].[SY_XIF_MES_WO_S] B
												 WHERE B.WO  = @WO_ID 
--												   AND B.EQUIPMENT_ID = ISNULL( @EQUIPMENT_ID, B.EQUIPMENT_ID )		--2017-10-26 piyong 삭제
											) x
										where SOURCES.[WO]    = x.WO
										and sources.WO_DETAIL = x.WO_DETAIL
										and sources.IF_SEQ    = x.IF_SEQ
										and x.rownums = 1
									;


									-- FP-058 kimcd 수정 시작. 2017-05-28 
									UPDATE DBO.FP_MES_PRODUCTION_PLAN_M
									SET    [START_TIME]      = ISNULL(cast ( substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) as datetime)
																			, START_TIME)
											,[END_TIME]        = ISNULL(cast ( substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) as datetime)
																			, END_TIME)
											,[PLAN_QTY]        = CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_OUT_QTY = 0 THEN PLAN_QTY ELSE ISNULL(@TOTAL_OUT_QTY, PLAN_QTY) END
											,[PLAN_IN_QTY]     = CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE ISNULL(@TOTAL_IN_QTY, PLAN_IN_QTY) END
											,[PRODUCTION_TYPE] = ISNULL(@ORDER_TYPE, [PRODUCTION_TYPE] )
											,[MARKET]          = ISNULL(@MARKET, MARKET)
											,[WORK_REQUEST_MODEL_ID] = ISNULL(@WORK_REQUEST_MODEL_ID,[WORK_REQUEST_MODEL_ID]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,[VERSION]   = ISNULL(@VERSION,[VERSION]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,[PROD_SEQ]  = ISNULL(@PROD_SEQ,[PROD_SEQ]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,[PLM_EC_NO] = ISNULL(@PLM_EC_NO,[PLM_EC_NO]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,[UPDATE_ID]       = 'MANUAL_WO_ADJ'
											,[UPDATE_TIME]     = GETDATE() 
										from DBO.FP_MES_PRODUCTION_PLAN_M SOURCES
											,(
												SELECT IF_SEQ, B.WO, B.WO_DETAIL , ROW_NUMBER() OVER( PARTITION BY B.WO, B.WO_DETAIL ORDER BY IF_SEQ DESC) ROWNUMS --2017-11-08 ORDER BY UPDATE_DATE - >IF_SEQ 로 변경
												  FROM [DBO].[SY_XIF_MES_WO_S] B
												 WHERE B.WO  = @WO_ID 
--												   and b.EQUIPMENT_ID = ISNULL( @EQUIPMENT_ID, b.EQUIPMENT_ID )			--2017-10-26  piyong 삭제
											) x
										WHERE SOURCES.[WORK_ORDER_ID]     = X.WO
										AND SOURCES.[WORK_ORDER_SPL_ID] = X.WO_DETAIL
										AND X.ROWNUMS = 1

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
											,[ATTR_12] --PIYONG 2017-11-21 ADD
											,[ATTR_17] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,[ATTR_18] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,[ATTR_19] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,[ATTR_20] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,[ATTR_30] -- @PDS_IFSEQNO
									)
									select 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
											,[IF_TYPE]
											 -- 2021-05-25 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
											,'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,ISNULL(F.MES_SOURCE_GROUP,'')) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = SOURCES.[BUILNO] AND L.LINE_ID = @MES_LINE_ID ),'') +'_'+'FP_WO' -- [IF_ID]
											,GETDATE() -- [IF_INS_DATE] 2020-07-27 kimcd 전송 정보 형성 일자를 현재 시간으로 입력
											,'N' --[IF_FLAG]
											,NULL								-- PIYONG 2017-11-08 NULL 처리
											,NULL -- [RSLT_IF_SEQ]
											,NULL--[RSLT_PROC_FLAG]
											,NULL--[RSLT_PROC_MSG]
											,ISNULL(@FP_PLAN_ID, PLAN_ID) --[PLAN_ID]
											,SOURCES.[PLANT_ID]
											,@FACTORY_ID AS [BUILNO]			-- PIYONG 2017-09-18 변수로 변경
											,ISNULL(@MES_LINE_ID, LINE_ID) -- [LINE_ID]
											,[OPERATION_ID]
											,[EQUIPMENT_ID]
											,SOURCES.[ITEM_ID]
											,[DEMAND_ID]
											,SOURCES.[WO]
											,[WO_TYPE]
											,SOURCES.[WO_DETAIL]
											,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN IN_QTY ELSE @IN_QTY END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN	      -- [PLAN_DATE]
													CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 00:00:00')
												ELSE
													ISNULL((substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) ), plan_date)
												END AS PLAN_DATE														--2017-10-10  PIYONG  변경
											,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN IN_QTY ELSE @IN_QTY END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN		  -- [START_TIME]
													CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:00:00')
												ELSE
													ISNULL((substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) ), start_time)
												END AS START_TIME														--2017-10-10  PIYONG  변경
											,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN IN_QTY ELSE @IN_QTY END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN	       -- [END_TIME]
													CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:10:00')
												ELSE
													ISNULL((substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) ), end_time)
												END AS END_TIME
											,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END  -- [IN_QTY]
											,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @OUT_QTY = 0 THEN @BEFORE_OUT_QTY ELSE ISNULL(@OUT_QTY, @BEFORE_OUT_QTY) END  -- [OUT_QTY]
											,[IS_RELEASE]
											,[CREATE_PSN_ID]
											,getdate() --[CREATE_DATE]
											,@UPDATE_PSN_ID + '_MANUAL_ADJST' -- [UPDATE_PSN_ID]
											,getdate() --[UPDATE_DATE]
											,ISNULL(@FP_LANE_QTY, LANE_QTY) -- [LANE_QTY]
											,[UNIT]
											,ISNULL(@ORDER_TYPE, [ORDER_TYPE] )
											,[BATCH_ORDER_ID]
											,ISNULL(@MES_SLITING_PLANT_ID, SLITTER_PLANT) --[SLITTER_PLANT]  -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
											,ISNULL(@MARKET, MARKET) -- [MARKET]
											-- ,CASE WHEN [OPERATION_ID] in ( 'E0500','E1000' ) THEN ISNULL(@BATCH_QTY,ATTR_01) ELSE null END  -- [ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
											,CASE WHEN [OPERATION_ID] in ( 'E0500','E1000' ) THEN ISNULL(@BATCH_QTY,ATTR_02) ELSE null END  -- [ATTR_02]
											-- ,CASE WHEN [OPERATION_ID] in ( 'E0500','E1000' ) THEN ISNULL(@IN_QTY,ATTR_03) ELSE null END  -- [ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
											,ISNULL(@MARKET, MARKET) -- [ATTR_04]
											,[ATTR_05]
											,[ATTR_06]
											,[ATTR_07]
											,[ATTR_08]
											,[ATTR_09]
											,[ATTR_10]
											,[ATTR_11]
											,ISNULL(@TOP_ITEM_ID, [ATTR_12]) --PIYONG 2017-11-21 ADD	2018-01-09 kimcd 최상위 품목 컬럼 추가
											,CASE WHEN ISNULL(@WORK_REQUEST_MODEL_ID,[ATTR_17]) = '-' THEN NULL ELSE ISNULL(@WORK_REQUEST_MODEL_ID,[ATTR_17]) END -- 2023-03-03 kimcd NJ 버전 예외 처리 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,CASE WHEN ISNULL(@VERSION,[ATTR_18]) = '-' THEN NULL -- [E20250918-001592] PDS 적용 인스턴스에서 PLM 버전을 자르고 사용할 경우 예외 처리 PLM_VERSION_FLAG 으로 구분
												  -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_PDS_VERSION_M] outer join 추가. PDS VERSION table 우선 사용.
												  ELSE CASE WHEN  F.ELEC_VERSION_TYPE = 'FP' THEN ISNULL(@VERSION,[ATTR_18])
												            ELSE CASE WHEN ISNULL(Y.PLM_VERSION_FLAG,'N') = 'N' 
																	  AND  ISNULL ( ( SELECT TOP 1 'Y'
																					  FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  A WITH(NOLOCK)	
																					  WHERE 1=1
																					  AND A.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
																					  AND A.ACTIVE_FLAG = 'Y'
																					  AND A.SEGMENT1    =  @INSTANCE_ID ), 'N') = 'Y' THEN  ISNULL(ISNULL(PVM.[PDS_VERSION],@VERSION),[ATTR_18]) ELSE ISNULL(SUBSTRING(@VERSION,1,3),[ATTR_18]) END 
													        END
											 END -- 2023-03-03 kimcd NJ 버전 예외 처리 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,ISNULL(@PROD_SEQ,[ATTR_19]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,ISNULL(@PLM_EC_NO,[ATTR_20]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,@PDS_IFSEQNO
										from [DBO].[SY_XIF_MES_WO_S] SOURCES
										     INNER JOIN SCM_FACTORY_M F  WITH(NOLOCK) 
											     ON  F.FACTORY_ID = SOURCES.[BUILNO] -- 2023-03-03 kimcd NJ 전극 버전 전송 예외 처리
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
															) Y
											ON	1=1
											AND SOURCES.[BUILNO]	= Y.FACTORY_ID
											AND SOURCES.ITEM_ID		= Y.ITEM_ID
											AND ISNULL(@WORK_REQUEST_MODEL_ID,[ATTR_17])	= Y.MODEL_ID
											AND ISNULL(@VERSION,[ATTR_18])					= Y.PROD_VERSION
											-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_PDS_VERSION_M] outer join 추가
											LEFT OUTER JOIN [dbo].[FP_PDS_VERSION_M]  PVM WITH(NOLOCK)
												ON 	PVM.[FACTORY_ID] = @FACTORY_ID
												AND PVM.[MODEL_ID]   = ISNULL(@WORK_REQUEST_MODEL_ID,SOURCES.[ATTR_17])
												AND PVM.[VERSION]    = ISNULL(@VERSION,SOURCES.[ATTR_18])
											,(
												select b.IF_SEQ, b.wo, b.WO_DETAIL , row_number() over( partition by b.wo, b.WO_DETAIL order by b.IF_SEQ desc) rownums 	-- 2017-10-08 PIYONG row_number  ORDER BY IF_SEQ 수정
												from [DBO].[SY_XIF_MES_WO_S] b
													,[DBO].[SY_XIF_MES_WO_S] C
												where  b.ATTR_06 = c.wo
													and  b.ATTR_07 = c.WO_DETAIL
													and  b.PLAN_ID = c.plan_id
													and  b.if_id   = c.if_id
													and  c.if_id  != 'OFP0_OPLM_FP_WO'
													and  C.wo  = @WO_ID 
													and  C.EQUIPMENT_ID = CASE WHEN @EQUIPMENT_ID = '-' THEN b.EQUIPMENT_ID ELSE @EQUIPMENT_ID END -- 2022-07-12 kimcd 설비 정보 제거
											) x
										where SOURCES.[WO]      = x.WO
										and sources.WO_DETAIL = x.WO_DETAIL
										and sources.IF_SEQ    = x.IF_SEQ
										and x.rownums = 1
									;            	
									-- FP-058 kimcd 수정 끝. 2017-05-28 	

									-- 2018-01-11 kimcd 추가 시작
									-- open work order에 merge 수행
									MERGE [dbo].[FP_MES_WORK_ORDER_STATUS_H]  T
									USING ( SELECT   @COMPANY_ID        AS COMPANY_ID
													,@DIVISION_ID       AS DIVISION_ID
													,@FP_SITE_ID        AS FP_SITE_ID
													,@FP_PLANT_ID       AS FP_PLANT_ID
													,@FACTORY_ID        AS FACTORY_ID
													,@WO_CUTOFF_DATE    AS CUTOFF_DATE
													,SOURCES.[WO]
													,SOURCES.[WO_DETAIL]
													,SOURCES.[DEMAND_ID] 
													,ISNULL(@ORDER_TYPE, [ORDER_TYPE] ) AS PRODUCTION_TYPE
													,ISNULL(@WO_TYPE, @FP_WO_TYPE )     AS WO_TYPE
													,SOURCES.[ITEM_ID]
													,ISNULL(@TOP_ITEM_ID, [ATTR_12])    AS TOP_ITEM_ID
													,SOURCES.OPERATION_ID
													,@LINE_ID                           AS LINE_ID
													,'-'                                AS WORK_CENTER_ID
													,@EQUIPMENT_ID                      AS EQUIPMENT_ID
													,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), @BEFORE_PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN
															CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 00:00:00')
														ELSE
															ISNULL((substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) ), plan_date)
															END							AS PLAN_DATE
													,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), @BEFORE_PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN
															CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:00:00')
														ELSE
															ISNULL((substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) ), start_time)
															END							AS START_TIME
													,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), @BEFORE_PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN
															CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:10:00')
														ELSE
															ISNULL((substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) ), end_time)
															END							AS END_TIME
													,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END      AS IN_QTY
													,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @OUT_QTY = 0 THEN @BEFORE_OUT_QTY ELSE ISNULL(@OUT_QTY, @BEFORE_OUT_QTY) END  AS OUT_QTY
													,@RESULT_QTY        AS ACTUAL_QTY
													,@RESULT_QTY        AS ACTUAL_GOOD_QTY
													,0                  AS ACTUAL_SCRAP_QTY
													,'-'                AS RUNNING_FLAG   
													,'OPEN'             AS WO_STATUS
													,ISNULL(@MARKET, MARKET) AS MARKET
													,SOURCES.[BATCH_ORDER_ID]
													,ISNULL(@FP_LANE_QTY, LANE_QTY) AS [LANE_QTY]
													,'MANUAL_ADJST' AS INSERT_ID
													,GETDATE()		AS INSERT_TIME
											FROM [DBO].[SY_XIF_MES_WO_S] SOURCES
												,(  SELECT IF_SEQ, B.WO, B.WO_DETAIL , ROW_NUMBER() OVER( PARTITION BY B.WO, B.WO_DETAIL ORDER BY IF_SEQ DESC) ROWNUMS -- 2017-11-08 PIYONG ROWNUM ORDER BY  IF_SEQ로 변경
													FROM   [DBO].[SY_XIF_MES_WO_S] B
													WHERE  B.WO  = @WO_ID 
													) x
											WHERE SOURCES.[WO]      = x.WO
											AND   sources.WO_DETAIL = x.WO_DETAIL
											AND   sources.IF_SEQ    = x.IF_SEQ
											AND   ( sources.ATTR_05 = 'B' OR sources.ATTR_05 IS NULL )
											AND   x.rownums         = 1 ) B
									ON 	T.[WORK_ORDER_SPL_ID] = B.[WO_DETAIL]
									AND	T.[CUTOFF_DATE]		  = B.[CUTOFF_DATE]
									AND	T.[FACTORY_ID]		  = B.[FACTORY_ID]
									AND	T.[PLANT_ID]		  = B.[FP_PLANT_ID]
									AND	T.[SITE_ID]			  = B.[FP_SITE_ID]
									AND	T.[DIVISION_ID]		  = B.[DIVISION_ID]
									AND	T.[COMPANY_ID]		  = B.[COMPANY_ID]
									WHEN MATCHED THEN
										UPDATE SET 	 T.[FACTORY_ID]      = B.FACTORY_ID
													,T.[TOP_ITEM_ID]     = B.TOP_ITEM_ID
													,T.[LINE_ID]         = B.LINE_ID
													,T.[WORK_CENTER_ID]  = B.WORK_CENTER_ID
													,T.[EQUIPMENT_ID]    = B.EQUIPMENT_ID
													,T.[PLAN_DATE]       = B.PLAN_DATE
													,T.[PLAN_START_TIME] = B.START_TIME
													,T.[PLAN_END_TIME]   = B.END_TIME
													,T.[PLAN_IN_QTY]     = B.IN_QTY
													,T.[PLAN_QTY]        = B.OUT_QTY
													,T.[MARKET]          = B.MARKET
													,T.[BATCH_ORDER_ID]  = B.BATCH_ORDER_ID
													,T.[WORK_REQUEST_MODEL_ID] = ISNULL(@WORK_REQUEST_MODEL_ID,T.[WORK_REQUEST_MODEL_ID]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,T.[VERSION]         = ISNULL(@VERSION,T.[VERSION]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,T.[PROD_SEQ]        = ISNULL(@PROD_SEQ,T.[PROD_SEQ]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,T.[PLM_EC_NO]       = ISNULL(@PLM_EC_NO,T.[PLM_EC_NO]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,T.[LANE_QTY]        = B.LANE_QTY
													,T.[INSERT_ID]       = B.INSERT_ID
													,T.[INSERT_TIME]     = B.INSERT_TIME
									WHEN NOT MATCHED THEN
										  INSERT ([COMPANY_ID]
												 ,[DIVISION_ID]
												 ,[SITE_ID]
												 ,[PLANT_ID]
												 ,[FACTORY_ID]
												 ,[CUTOFF_DATE]
												 ,[WORK_ORDER_SPL_ID]
												 ,[WORK_ORDER_ID]
												 ,[DEMAND_ID]
												 ,[PRODUCTION_TYPE]
												 ,[ORDER_TYPE]
												 ,[ITEM_ID]
												 ,[TOP_ITEM_ID]
												 ,[OPERATION_ID]
												 ,[LINE_ID]
												 ,[WORK_CENTER_ID]
												 ,[EQUIPMENT_ID]
												 ,[PLAN_DATE]
												 ,[PLAN_START_TIME]
												 ,[PLAN_END_TIME]
												 ,[PLAN_IN_QTY]
												 ,[PLAN_QTY]
												 ,[ACTUAL_QTY]
												 ,[ACTUAL_GOOD_QTY]
												 ,[ACTUAL_SCRAP_QTY]
												 ,[RUNNING_FLAG]
												 ,[WO_STATUS]
												 ,[MARKET]
												 ,[BATCH_ORDER_ID]
												 ,[LANE_QTY]
												 ,[WORK_REQUEST_MODEL_ID] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												 ,[VERSION]    -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												 ,[PROD_SEQ]   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												 ,[PLM_EC_NO]  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												 ,[INSERT_ID]
												 ,[INSERT_TIME] )
										  VALUES (B.[COMPANY_ID]
												 ,B.[DIVISION_ID]
												 ,B.[FP_SITE_ID]
												 ,B.[FP_PLANT_ID]
												 ,B.[FACTORY_ID]
												 ,B.[CUTOFF_DATE]
												 ,B.[WO_DETAIL]
												 ,B.[WO]
												 ,B.[DEMAND_ID]
												 ,B.[PRODUCTION_TYPE]
												 ,B.[WO_TYPE]   -- ORDER_TYPE
												 ,B.[ITEM_ID]
												 ,B.[TOP_ITEM_ID]
												 ,B.[OPERATION_ID]
												 ,B.[LINE_ID]
												 ,B.[WORK_CENTER_ID]
												 ,B.[EQUIPMENT_ID]
												 ,B.[PLAN_DATE]
												 ,B.[START_TIME]
												 ,B.[END_TIME]
												 ,B.[IN_QTY]
												 ,B.[OUT_QTY]
												 ,B.[ACTUAL_QTY]
												 ,B.[ACTUAL_GOOD_QTY]
												 ,B.[ACTUAL_SCRAP_QTY]
												 ,B.[RUNNING_FLAG]
												 ,B.[WO_STATUS]
												 ,B.[MARKET]
												 ,B.[BATCH_ORDER_ID]
												 ,B.[LANE_QTY]
												 ,@WORK_REQUEST_MODEL_ID -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												 ,@VERSION    -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												 ,@PROD_SEQ   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												 ,@PLM_EC_NO  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												 ,B.[INSERT_ID]
												 ,B.[INSERT_TIME] );

									-- FP 결과에도 추가함.
									IF @INSTANCE_ID IS NOT NULL AND @INSTANCE_DATE IS NOT NULL
										MERGE [dbo].[FP_PRODUCTION_PLAN_R] T
										USING ( SELECT   ISNULL(@INSTANCE_ID, '-')  AS INSTANCE_ID
														,@RELEASE_PLAN_ID           AS RELEASE_PLAN_ID
														,@COMPANY_ID                AS COMPANY_ID
														,@DIVISION_ID               AS DIVISION_ID
														,@FP_SITE_ID                AS FP_SITE_ID
														,@FP_PLANT_ID               AS FP_PLANT_ID
														,@FACTORY_ID                AS FACTORY_ID
														,A.WO                       AS WORK_ORDER_ID
														,A.BATCH_ORDER_ID 
														,SUBSTRING(@FP_WO_TYPE,1,1) AS ORDER_TYPE
														,A.DEMAND_ID                AS SCP_TARGET_ID
														,A.DEMAND_ID                AS DEMAND_ID
														,A.ITEM_ID
														,ISNULL(@FP_LANE_QTY, A.LANE_QTY) AS LANE_QTY
														,ISNULL(@TOP_ITEM_ID, A.ATTR_12)  AS TOP_ITEM_ID
														,A.OPERATION_ID
														,@LINE_ID                   AS LINE_ID
														,@ELECTRODE_TYPE            AS ELECTRODE_TYPE
														,@ERP_WORK_CENTER_ID        AS ERP_WORK_CENTER_ID
														,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), @BEFORE_PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN
																CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 00:00:00')
															ELSE
																ISNULL((substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) ), plan_date)
																END							AS PLAN_DATE
														,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), @BEFORE_PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN
																CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:00:00')
															ELSE
																ISNULL((substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) ), start_time)
																END							AS START_TIME
														,CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), @BEFORE_PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN
																CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:10:00')
															ELSE
																ISNULL((substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) ), end_time)
																END							AS END_TIME
														,CASE WHEN (CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END) > ISNULL(@RESULT_QTY,0) THEN (CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END) - ISNULL(@RESULT_QTY,0) ELSE 0 END AS IN_QTY
														,CASE WHEN (CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @OUT_QTY = 0 THEN @BEFORE_OUT_QTY ELSE ISNULL(@OUT_QTY, @BEFORE_OUT_QTY) END) > ISNULL(@RESULT_QTY,0) THEN (CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @OUT_QTY = 0 THEN @BEFORE_OUT_QTY ELSE ISNULL(@OUT_QTY, @BEFORE_OUT_QTY) END) - ISNULL(@RESULT_QTY,0) ELSE 0 END  AS OUT_QTY
														,@UOM     AS [ITEM_UOM]
														,'N'      AS [FIX_TYPE]
														,ISNULL(@ORDER_TYPE, [ORDER_TYPE] ) AS PRODUCTION_TYPE
														,ISNULL(@MARKET, MARKET)            AS MARKET
														,(SELECT TOP 1 [WEEK] FROM [dbo].[SCM_SYS_CALENDAR_M] SC WITH(NOLOCK)
														  WHERE  DATE_ID = CASE WHEN ISNULL(CONVERT(DATE,SUBSTRING(@START_TIME,1,8)), @BEFORE_PLAN_DATE) > GETDATE() AND ( @STATUS = 'DELETE' OR ( @STATUS = 'UPDATE' AND CASE WHEN @IN_QTY = 0 THEN @BEFORE_IN_QTY ELSE ISNULL(@IN_QTY, @BEFORE_IN_QTY) END-ISNULL(@RESULT_QTY,0) <= 0 ) ) THEN
																				CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120)
																		   ELSE
																				ISNULL((substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2)), A.plan_date)
																		   END)             AS MFG_WEEK
														,@DIVISION_ID   AS [DEMAND_DIVISION_ID]
														,'MANUAL_ADJST' AS [INSERT_ID]
														,GETDATE()      AS  INSERT_TIME
												FROM [DBO].[SY_XIF_MES_WO_S] A
													,(  SELECT IF_SEQ, B.WO, B.WO_DETAIL , ROW_NUMBER() OVER( PARTITION BY B.WO, B.WO_DETAIL ORDER BY IF_SEQ DESC) ROWNUMS -- 2017-11-08 PIYONG ROWNUM ORDER BY  IF_SEQ로 변경
														FROM   [DBO].[SY_XIF_MES_WO_S] B
														WHERE  B.WO  = @WO_ID 
														) x
												WHERE A.[WO]      = X.WO
												AND   A.WO_DETAIL = X.WO_DETAIL
												AND   A.IF_SEQ    = X.IF_SEQ
												AND   ( A.ATTR_05 = 'B' OR A.ATTR_05 IS NULL )
												AND   X.ROWNUMS   = 1 ) B
										ON  T.[INSTANCE_ID]   = B.INSTANCE_ID
										AND T.[FP_PLAN_ID]    = B.RELEASE_PLAN_ID
										AND T.[COMPANY_ID]    = B.COMPANY_ID
										AND T.[DIVISION_ID]   = B.DIVISION_ID
										AND T.[SITE_ID]       = B.FP_SITE_ID
										AND T.[PLANT_ID]      = B.FP_PLANT_ID
										AND T.[WORK_ORDER_ID] = B.WORK_ORDER_ID
										WHEN MATCHED THEN
											UPDATE   SET   T.[FACTORY_ID]      = B.FACTORY_ID
														  ,T.[LANE_QTY]        = B.LANE_QTY
														  ,T.[TOP_ITEM_ID]     = B.TOP_ITEM_ID
														  ,T.[LINE_ID]         = B.LINE_ID
														  ,T.[ELECTRODE_TYPE]  = B.ELECTRODE_TYPE
														  ,T.[WORK_CENTER_ID]  = B.ERP_WORK_CENTER_ID
														  ,T.[PLAN_DATE]       = B.PLAN_DATE
														  ,T.[START_TIME]      = B.START_TIME
														  ,T.[END_TIME]        = B.END_TIME
														  ,T.[PLAN_QTY]        = B.IN_QTY
														  ,T.[PLAN_IN_QTY]     = B.OUT_QTY
														  ,T.[PRODUCTION_TYPE] = B.PRODUCTION_TYPE
														  ,T.[MARKET]          = B.MARKET
														  ,T.[MFG_WEEK]        = B.MFG_WEEK
														  ,T.[WORK_REQUEST_MODEL_ID] = ISNULL(ISNULL(@WORK_REQUEST_MODEL_ID,T.[WORK_REQUEST_MODEL_ID]),'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														  ,T.[VERSION]         = ISNULL(ISNULL(@VERSION,T.[VERSION]),'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														  ,T.[PROD_SEQ]        = ISNULL(@PROD_SEQ,T.[PROD_SEQ]) -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														  ,T.[PLM_EC_NO]       = ISNULL(ISNULL(@PLM_EC_NO,T.[PLM_EC_NO]),'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														  ,T.[INSERT_ID]       = B.INSERT_ID
														  ,T.[INSERT_TIME]     = B.INSERT_TIME
										WHEN NOT MATCHED THEN
											INSERT ( [INSTANCE_ID]
													,[FP_PLAN_ID]
													,[COMPANY_ID]
													,[DIVISION_ID]
													,[SITE_ID]
													,[PLANT_ID]
													,[FACTORY_ID]
													,[WORK_ORDER_ID]
													,[BATCH_ORDER_ID]
													,[ORDER_TYPE]
													,[SCP_TARGET_ID]
													,[DEMAND_ID]
													,[ITEM_ID]
													,[LANE_QTY]
													,[TOP_ITEM_ID]
													,[OPERATION_ID]
													,[LINE_ID]
													,[ELECTRODE_TYPE]
													,[WORK_CENTER_ID]
													,[PLAN_DATE]
													,[START_TIME]
													,[END_TIME]
													,[PLAN_QTY]
													,[PLAN_IN_QTY]
													,[ITEM_UOM]
													,[FIX_TYPE]
													,[PRODUCTION_TYPE]
													,[MARKET]
													,[MFG_WEEK]
													,[DEMAND_DIVISION_ID]
													,[WORK_REQUEST_MODEL_ID] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,[VERSION]    -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,[PROD_SEQ]   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,[PLM_EC_NO]  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,[INSERT_ID]
													,[INSERT_TIME] )
											VALUES ( B.[INSTANCE_ID]
													,B.[RELEASE_PLAN_ID]
													,B.[COMPANY_ID]
													,B.[DIVISION_ID]
													,B.[FP_SITE_ID]
													,B.[FP_PLANT_ID]
													,B.[FACTORY_ID]
													,B.[WORK_ORDER_ID]
													,B.[BATCH_ORDER_ID]
													,B.[ORDER_TYPE]
													,B.[SCP_TARGET_ID]
													,B.[DEMAND_ID]
													,B.[ITEM_ID]
													,B.[LANE_QTY]
													,B.[TOP_ITEM_ID]
													,B.[OPERATION_ID]
													,B.[LINE_ID]
													,B.[ELECTRODE_TYPE]
													,B.[ERP_WORK_CENTER_ID]
													,B.[PLAN_DATE]
													,B.[START_TIME]
													,B.[END_TIME]
													,B.OUT_QTY
													,B.IN_QTY
													,B.[ITEM_UOM]
													,B.[FIX_TYPE]
													,B.[PRODUCTION_TYPE]
													,B.[MARKET]
													,B.[MFG_WEEK]
													,B.[DEMAND_DIVISION_ID]
													,ISNULL(@WORK_REQUEST_MODEL_ID,'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,ISNULL(@VERSION,'-')    -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,@PROD_SEQ   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,ISNULL(@PLM_EC_NO,'-')  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,B.[INSERT_ID]
													,B.[INSERT_TIME] );
									-- 2018-01-11 kimcd 추가 끝


									UPDATE [dbo].[SCM_MANUAL_WO_CREATE]
										SET [PROCESSING_YN] = 'Y'
											,ERROR_MSG = 'SUCCESS'
											,work_center_id = @ERP_WORK_CENTER_ID
											,lane_qty = @FP_LANE_QTY
											,UPDATE_DATE = getdate()
										WHERE SEQ = @SEQ
										and WO_BASE_DATE = @WO_BASE_DATE
										;
						
						      END;  
						    -- 신규 추가인 경우
						  ELSE
						  BEGIN
							  -- 2018-01-09 kimcd 최상위 품목 컬럼 추가 시작
							  IF @TOP_ITEM_ID IS NULL
								  BEGIN
									  SELECT TOP 1 @TOP_ITEM_ID =  B.MODEL_ID
									  FROM   SCM_MODEL_COMP_TEMP B WITH(NOLOCK)
									  WHERE  B.COMPANY_ID    = @COMPANY_ID
									  AND    B.DIVISION_ID   = @DIVISION_ID
									  AND    B.SITE_ID       = @FP_SITE_ID
									  AND    B.PLANT_ID      = @FP_PLANT_ID 
									  AND    B.CHILD_ITEM_ID = @ITEM_ID
									  ORDER  BY B.NLEVEL
								  END;
							  -- 2018-01-09 kimcd 최상위 품목 컬럼 추가 끝

						        IF @FP_WO_TYPE = 'WO' AND @WO_SEQ = 1 
											BEGIN

												-- ERP로 WO 생성 정보 전송
														insert into [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S]
															   ([IFSEQNO]
															   ,[SEQ]
															   ,[FP_PLAN_ID]
															   ,[PLANT_ID]
															   ,[FACTORY_ID]
															   ,[LINE_ID]
															   ,[OPERATION_ID]
															   ,[BOM_VERSION_ID]
															   ,[WORK_CENTER_ID]
															   ,[ITEM_ID]
															   ,[DEMAND_ID]
															   ,[WORK_ORDER_ID]
															   ,[ORDER_TYPE]
															   ,[PLAN_DATE]
															   ,[START_TIME]
															   ,[END_TIME]
															   ,[PLAN_IN_QTY]
															   ,[PLAN_QTY]
															   ,[FIX_TYPE]
															   ,[TRANSFER_FLAG]
															   ,[TRANSFER_DATE]
															   ,[CREATE_USER_ID]
															   ,[CREATE_DATE]
															   ,[MODIFY_USER_ID]
															   ,[MODIFY_DATE]
															   ,[LANE_QTY]
															   ,[BATCH_ORDER_ID]
															   ,[SLITTER_PLANT]
															   ,[MARKET]
															   ,[ATTRIBUTE1]
															   ,[ATTRIBUTE2]
															   ,[ATTRIBUTE3]
															   ,[ATTRIBUTE4]
															   ,[ATTRIBUTE5]
															   ,[ATTRIBUTE6]
															   ,[ATTRIBUTE7]
															   ,[ATTRIBUTE8]
															   ,[ATTRIBUTE9]
															   ,[ATTRIBUTE10]
															   -- FP-058 kimcd 컬럼 추가 시작. 2017-05-30 
															   ,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
															   ,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
															   ,[FP_PLAN_QTY]  -- FP Plan 수량
															   ,[FP_SNAP_QTY]) -- FP 실적 수량
															   -- FP-058 kimcd 컬럼 추가 끝. 2017-05-30
														select CONVERT(NVARCHAR(26),CONVERT(NUMERIC(18),@IFSQENO)+2)   -- [IFSEQNO] --2017-10-26 16자리로 변경 -- 2017-11-06 SEQ 중복 처리
														      ,1 -- row_number() over ( order by line_id, item_id) --[SEQ]
															  ,@FP_PLAN_ID --[FP_PLAN_ID]
														      ,@FP_PLANT_ID -- [PLANT_ID]
														      ,@FACTORY_ID -- [FACTORY_ID]
														      ,@MES_LINE_ID -- [LINE_ID]
														      ,@OPERATION_ID   -- [OPERATION_ID]
														      ,NULL -- [BOM_VERSION_ID]
														      ,@ERP_WORK_CENTER_ID -- [WORK_CENTER_ID]
														      ,@ITEM_ID -- [ITEM_ID]
														      ,'MANUAL_INPUT_WO' -- [DEMAND_ID]
														      ,@NEW_WORK_ORDER -- [WORK_ORDER_ID]
														      ,ISNULL(@ORDER_TYPE,'MASS') -- [ORDER_TYPE]
														      ,@PLAN_DATE      --[PLAN_DATE]
														      ,@START_TIME
														      ,@END_TIME
														      ,@TOTAL_IN_QTY -- [PLAN_IN_QTY]
														      ,@TOTAL_OUT_QTY -- [PLAN_QTY]
														      ,'Y' --[FIX_TYPE]
														      ,'N' --[TRANSFER_FLAG]
														      ,null -- [TRANSFER_DATE]
														      ,'MANUAL_ADJST' -- [CREATE_USER_ID]
														      ,getdate() -- [CREATE_DATE]
														      ,'MANUAL_ADJST' -- [MODIFY_USER_ID]
														      ,getdate() -- [MODIFY_DATE]
														      ,@FP_LANE_QTY -- [LANE_QTY]
														      ,CASE WHEN @OPERATION_ID = 'E1000' OR  @OPERATION_ID = 'E0500' THEN
																		CASE WHEN @BATCH_ORDER_ID IS NULL THEN						--2017.07.03 PIYONG 추가
																				@ITEM_ID
																			 ELSE
																				@BATCH_ORDER_ID
																			 END
														            ELSE NULL
																	END -- [BATCH_ORDER_ID]
														      ,@FP_SLITING_PLANT_ID -- [SLITTER_PLANT]
														      ,@MARKET -- [MARKET]
														      ,null -- [ATTRIBUTE1]
														      ,null -- [ATTRIBUTE2]
														      ,null -- [ATTRIBUTE3]
														      ,null -- [ATTRIBUTE4]
														      ,null -- [ATTRIBUTE5]
														      ,null -- [ATTRIBUTE6]
														      ,null -- [ATTRIBUTE7]
														      ,null -- [ATTRIBUTE8]
														      ,null -- [ATTRIBUTE9]
														      ,null -- [ATTRIBUTE10]
															  -- FP-058 kimcd 추가 시작. 2017-05-30
															  ,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
																	 'B'
															   END AS TOP_BACK_IND -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
															  ,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
																	CASE WHEN @NEW_WORK_ORDER LIKE 'W%' OR @NEW_WORK_ORDER LIKE 'M%' THEN
																		SUBSTRING(@NEW_WORK_ORDER,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(@NEW_WORK_ORDER,6,2)) + 50) + SUBSTRING(@NEW_WORK_ORDER,8,10)
																	WHEN SUBSTRING(@NEW_WORK_ORDER,9,1) = '0' THEN
																		 CASE WHEN SUBSTRING(@NEW_WORK_ORDER,6,1) = 'X' THEN
																			 SUBSTRING(@NEW_WORK_ORDER,1,5) + 'Y' + SUBSTRING(@NEW_WORK_ORDER,7,10)
																		 ELSE
																			 SUBSTRING(@NEW_WORK_ORDER,1,4) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(@NEW_WORK_ORDER,5,2)) + 50) + SUBSTRING(@NEW_WORK_ORDER,7,10)
																		 END
																	ELSE
																		 CASE WHEN SUBSTRING(@NEW_WORK_ORDER,7,1) = 'X' THEN
																			 SUBSTRING(@NEW_WORK_ORDER,1,6) + 'Y' + SUBSTRING(@NEW_WORK_ORDER,8,10)
																		 ELSE
																			 SUBSTRING(@NEW_WORK_ORDER,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(@NEW_WORK_ORDER,6,2)) + 50) + SUBSTRING(@NEW_WORK_ORDER,8,10)
																		 END
																	END
																END AS LINK_WO      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO -- 2018-03-06 kimcd Top WO 연결정보 문장 재구성
															   ,@IN_QTY       AS FP_PLAN_QTY  -- FP Plan 수량
															   ,0             AS FP_SNAP_QTY  -- FP 실적 수량
														FROM   SCM_LINE_M SL WITH(NOLOCK) -- 2022-07-12 kimcd 설비 의존도 제거. 라인 Table 추가
															   LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M]  EQP WITH(NOLOCK)
	       														   ON  EQP.LINE_ID       = SL.LINE_ID        
																   AND EQP.PLANT_ID      = SL.PLANT_ID
																   AND EQP.DIVISION_ID   = SL.DIVISION_ID
																   AND EQP.COMPANY_ID	 = SL.COMPANY_ID
																   AND EQP.SITE_ID	     = SL.SITE_ID
																   AND EQP.ELECTRODE_TYPE = SL.ELECTRODE_TYPE
																   AND EQP.OPERATION_ID  = SL.OPERATION_ID
																   AND EQP.FACTORY_ID    = SL.FACTORY_ID
																   AND EQP.EQUIPMENT_ID = @EQUIPMENT_ID
																   AND EQP.OPERATION_ID = @OPERATION_ID
																   AND EQP.FACTORY_ID   = @FACTORY_ID
																   AND EQP.EQUIPMENT_TYPE = 'M'
																   AND EQP.ACTIVE_FLAG    = 'Y'
															   LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  EQPC WITH(NOLOCK)
																   ON  EQPC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_OP'
																   AND EQPC.SEGMENT1         = EQP.OPERATION_ID
																   AND EQPC.SEGMENT2         = EQP.COATER_EQPT_TYPE_CODE
																   AND EQPC.ACTIVE_FLAG      = 'Y'
															  ,[DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
															   LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  IMC WITH(NOLOCK)
																   ON  IMC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_ITEM_CLASS'
																   AND IMC.SEGMENT1         = IM.ITEM_CLASS
																   AND IMC.ACTIVE_FLAG      = 'Y'
													   WHERE  SL.LINE_ID       = @LINE_ID      -- 2022-07-12 kimcd 설비 의존도 제거. 라인 Table 추가        
													   AND	  SL.PLANT_ID      = @FP_PLANT_ID
													   AND	  SL.DIVISION_ID   = @DIVISION_ID
													   AND	  SL.COMPANY_ID	   = @COMPANY_ID
													   AND	  SL.SITE_ID	   = @FP_SITE_ID
													   AND	  SL.ELECTRODE_TYPE	= @ELECTRODE_TYPE
													   AND    SL.OPERATION_ID  = @OPERATION_ID
													   AND    SL.FACTORY_ID    = @FACTORY_ID
													   AND    SL.ACTIVE_FLAG   = 'Y'
													   AND    SL.COMPANY_ID    = IM.COMPANY_ID -- 2019-07-23 kimcd item에 company id 조건 추가
													   AND    IM.DIVISION_ID   = @DIVISION_ID
													   AND    IM.SITE_ID       = @FP_SITE_ID
													   AND    IM.ITEM_ID       = @ITEM_ID


														INSERT INTO [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S]
																   ([IFSEQNO]
																   ,[SEQ]
																   ,[FP_PLAN_ID]
																   ,[PLANT_ID]
																   ,[FACTORY_ID]
																   ,[LINE_ID]
																   ,[OPERATION_ID]
																   ,[BOM_VERSION_ID]
																   ,[WORK_CENTER_ID]
																   ,[ITEM_ID]
																   ,[DEMAND_ID]
																   ,[WORK_ORDER_ID]
																   ,[ORDER_TYPE]
																   ,[PLAN_DATE]
																   ,[START_TIME]
																   ,[END_TIME]
																   ,[PLAN_IN_QTY]
																   ,[PLAN_QTY]
																   ,[FIX_TYPE]
																   ,[TRANSFER_FLAG]
																   ,[TRANSFER_DATE]
																   ,[CREATE_USER_ID]
																   ,[CREATE_DATE]
																   ,[MODIFY_USER_ID]
																   ,[MODIFY_DATE]
																   ,[LANE_QTY]
																   ,[BATCH_ORDER_ID]
																   ,[SLITTER_PLANT]
																   ,[MARKET] -- 170208 Add
																   ,[ATTRIBUTE1]
																   ,[ATTRIBUTE2]
																   ,[ATTRIBUTE3]
																   ,[ATTRIBUTE4]
																   ,[ATTRIBUTE5]
																   ,[ATTRIBUTE6]
																   ,[ATTRIBUTE7]
																   ,[ATTRIBUTE8]
																   ,[ATTRIBUTE9]
																   ,[ATTRIBUTE10]
																   ,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
																   ,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
																   ,[FP_PLAN_QTY]  -- FP Plan 수량
																   ,[FP_SNAP_QTY]) -- FP 실적 수량
															SELECT CONVERT(NVARCHAR(26),CONVERT(NUMERIC(18),@IFSQENO)+3)   -- [IFSEQNO] --2017-10-26 16자리로 변경 -- 2017-11-06 SEQ 중복 처리
																   ,ROW_NUMBER() OVER( ORDER BY A.[FP_PLAN_ID], A.[PLANT_ID], A.[FACTORY_ID], A.[LINE_ID], A.[OPERATION_ID], A.[ITEM_ID], A.[WORK_ORDER_ID] ) AS SEQ
																   ,A.[FP_PLAN_ID]
																   ,A.[PLANT_ID]
																   ,A.[FACTORY_ID]
																   ,A.[LINE_ID]
																   ,A.[OPERATION_ID]
																   ,A.[BOM_VERSION_ID]
																   ,A.[WORK_CENTER_ID]
																   ,A.[ITEM_ID]
																   ,A.[DEMAND_ID]
																   ,A.[LINK_WO]    -- [WORK_ORDER_ID]
																   ,A.[ORDER_TYPE]
																   ,A.[PLAN_DATE]
																   ,A.[START_TIME]
																   ,A.[END_TIME]
																   ,A.[PLAN_IN_QTY]
																   ,A.[PLAN_QTY]
																   ,A.[FIX_TYPE]
																   ,A.[TRANSFER_FLAG]
																   ,A.[TRANSFER_DATE]
																   ,A.[CREATE_USER_ID]
																   ,A.[CREATE_DATE]
																   ,A.[MODIFY_USER_ID]
																   ,A.[MODIFY_DATE]
																   ,A.[LANE_QTY]
																   ,A.[BATCH_ORDER_ID]
																   ,A.[SLITTER_PLANT]
																   ,A.[MARKET]
																   ,A.[ATTRIBUTE1]
																   ,A.[ATTRIBUTE2]
																   ,A.[ATTRIBUTE3]
																   ,A.[ATTRIBUTE4]
																   ,A.[ATTRIBUTE5]
																   ,A.[ATTRIBUTE6]
																   ,A.[ATTRIBUTE7]
																   ,A.[ATTRIBUTE8]
																   ,A.[ATTRIBUTE9]
																   ,A.[ATTRIBUTE10]
																   ,'T'               -- [TOP_BACK_IND] 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
																   ,A.[WORK_ORDER_ID] -- [LINK_WO] 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
																   ,A.[FP_PLAN_QTY]   -- FP Plan 수량
																   ,A.[FP_SNAP_QTY]   -- FP 실적 수량
															FROM    [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] A WITH(NOLOCK)
															WHERE   A.[FP_PLAN_ID]    = @FP_PLAN_ID
															AND     A.[TOP_BACK_IND]  = 'B'
															AND     A.[WORK_ORDER_ID] = @NEW_WORK_ORDER;
													   -- FP-058 kimcd 추가 끝. 2017-05-30

													  IF @INSTANCE_ID IS NOT NULL AND @INSTANCE_DATE IS NOT NULL
													    begin
														INSERT INTO [DBO].[FP_RELEASE_FIX_PLAN_H]
															   ([INSTANCE_ID]
															   ,[INSTANCE_DATE]
															   ,[RELEASE_PLAN_ID]
															   ,[AMEND_PLAN_ID]
															   ,[DIVISION_ID]
															   ,[FACTORY_ID]
															   ,[WORK_ORDER_ID]
															   ,[ITEM_ID]
															   ,[LINE_ID]
															   ,[OPERATION_ID]
															   ,[ELECTRODE_TYPE]
															   ,[EQUIPMENT_ID]
															   ,[FIX_TYPE]
															   ,[PLAN_DATE]
															   ,[START_TIME]
															   ,[END_TIME]
															   ,[PLAN_QTY]
															   ,[PLAN_IN_QTY]
															   ,[PRODUCTION_TYPE]
															   ,[MARKET]
															   ,[BATCH_ORDER_ID]
															   ,[ACTUAL_FLAG]
															   ,[CLOSE_FLAG]
															   ,[TOP_ITEM_ID]  -- 2018-01-09 kimcd 최상위 품목 컬럼 추가
															   ,[WORK_REQUEST_MODEL_ID] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															   ,[VERSION]    -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															   ,[PROD_SEQ]   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															   ,[PLM_EC_NO]  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															   ,[INSERT_ID]
															   ,[INSERT_TIME])
														SELECT @INSTANCE_ID
															  ,@INSTANCE_DATE
															  ,@RELEASE_PLAN_ID
															  ,@AMEND_PLAN_ID
															  ,@DIVISION_ID
															  ,@FACTORY_ID 
															  ,@NEW_WORK_ORDER    
															  ,@ITEM_ID   
															  ,@LINE_ID   
															  ,@OPERATION_ID 
															  ,@ELECTRODE_TYPE 
															  ,CASE WHEN @INSTANCE_ID LIKE '%CELL%' OR @INSTANCE_ID LIKE '%PACK%' THEN
															              CASE WHEN @ELECTRODE_TYPE = '-' THEN @LINE_ID + '_' + @OPERATION_ID 
																		       ELSE  @LINE_ID + '_' + @OPERATION_ID + '_' + @ELECTRODE_TYPE   END
															        ELSE @EQUIPMENT_ID END --[EQUIPMENT_ID]  
															  ,'N'             
															  ,cast ( substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) as datetime)
															  ,cast ( substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) as datetime)
															  ,cast ( substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) as datetime)
															  ,@OUT_QTY
															  ,@IN_QTY
															  ,@ORDER_TYPE
															  ,@MARKET
															  ,CASE WHEN @OPERATION_ID = 'E1000' OR  @OPERATION_ID = 'E0500' THEN
																		CASE WHEN @BATCH_ORDER_ID IS NULL THEN						--2017.07.03 PIYONG 추가
																				@ITEM_ID
																			 ELSE
																				@BATCH_ORDER_ID
																			 END
														            ELSE NULL
																	END -- [BATCH_ORDER_ID]
															  ,'Y' -- ACTUAL_FLAG
															  ,'N' -- CLOSE_FLAG
															  ,@TOP_ITEM_ID  -- 2018-01-09 kimcd 최상위 품목 컬럼 추가
															  ,ISNULL(@WORK_REQUEST_MODEL_ID,'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															  ,ISNULL(@VERSION,'-')    -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															  ,@PROD_SEQ   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															  ,ISNULL(@PLM_EC_NO,'-')  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															  ,'MANUAL_WO_CREATION'
															  ,getdate()   -- [INSERT_TIME]
														  ;

														INSERT INTO [DBO].[FP_RELEASE_FULL_PLAN_H]
															   ([INSTANCE_ID]
															   ,[INSTANCE_DATE]
															   ,[RELEASE_PLAN_ID]
															   ,[AMEND_PLAN_ID]
															   ,[DIVISION_ID]
															   ,[FACTORY_ID]
															   ,[WORK_ORDER_ID]
															   ,[ITEM_ID]
															   ,[LINE_ID]
															   ,[OPERATION_ID]
															   ,[ELECTRODE_TYPE]
															   ,[EQUIPMENT_ID]
															   ,[FIX_TYPE]
															   ,[PLAN_DATE]
															   ,[START_TIME]
															   ,[END_TIME]
															   ,[PLAN_QTY]
															   ,[PLAN_IN_QTY]
															   ,[PRODUCTION_TYPE]
															   ,[MARKET]
															   ,[BATCH_ORDER_ID]
															   ,[ACTUAL_FLAG]
															   ,[CLOSE_FLAG]
															   ,[TOP_ITEM_ID]  -- 2018-01-09 kimcd 최상위 품목 컬럼 추가
															   ,[WORK_REQUEST_MODEL_ID] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															   ,[VERSION]    -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															   ,[PROD_SEQ]   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															   ,[PLM_EC_NO]  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															   ,[INSERT_ID]
															   ,[INSERT_TIME])
														SELECT @INSTANCE_ID -- [INSTANCE_ID]
															  ,@INSTANCE_DATE -- [INSTANCE_DATE]
															  ,@RELEASE_PLAN_ID -- [RELEASE_PLAN_ID]
															  ,@AMEND_PLAN_ID --[AMEND_PLAN_ID]
															  ,@DIVISION_ID -- [DIVISION_ID]
															  ,@FACTORY_ID -- [FACTORY_ID]
															  ,@NEW_WORK_ORDER --[WORK_ORDER_ID]
															  ,@ITEM_ID --[ITEM_ID]
															  ,@LINE_ID --[LINE_ID]
															  ,@OPERATION_ID --[OPERATION_ID]
															  ,@ELECTRODE_TYPE
															  ,CASE WHEN @INSTANCE_ID LIKE '%CELL%' OR @INSTANCE_ID LIKE '%PACK%' THEN
															              CASE WHEN @ELECTRODE_TYPE = '-' THEN @LINE_ID + '_' + @OPERATION_ID 
																		       ELSE  @LINE_ID + '_' + @OPERATION_ID + '_' + @ELECTRODE_TYPE   END
															        ELSE @EQUIPMENT_ID END --[EQUIPMENT_ID]   -- Cell Pack인 경우에는 Line_id와 Operation_id, Electrode_type 컬럼을 합쳐서 만듬.
															  ,'N' -- [FIX_TYPE]
															  ,cast ( substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) as datetime) -- [PLAN_DATE]
															  ,cast ( substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) as datetime) -- [START_TIME]
															  ,cast ( substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) as datetime) -- [END_TIME]
															  ,@OUT_QTY -- [PLAN_QTY]
															  ,@IN_QTY -- [PLAN_IN_QTY]
															  ,@ORDER_TYPE -- [PRODUCTION_TYPE]
															  ,@MARKET -- [MARKET]
															  ,CASE WHEN @OPERATION_ID = 'E1000' OR  @OPERATION_ID = 'E0500' THEN
																		CASE WHEN @BATCH_ORDER_ID IS NULL THEN						--2017.07.03 PIYONG 추가
																				@ITEM_ID
																			 ELSE
																				@BATCH_ORDER_ID
																			 END
														            ELSE NULL
																	END -- [BATCH_ORDER_ID]
                                                                ,'Y' -- ACTUAL_FLAG
															  ,'N' -- CLOSE_FLAG
															  ,@TOP_ITEM_ID -- 2018-01-09 kimcd 최상위 품목 컬럼 추가
															  ,ISNULL(@WORK_REQUEST_MODEL_ID,'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															  ,ISNULL(@VERSION,'-')    -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															  ,@PROD_SEQ   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															  ,ISNULL(@PLM_EC_NO,'-')  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
															  ,'MANUAL_WO_CREATION'
															  ,getdate()   -- [INSERT_TIME]
														;

														-- 2017-09-19 kimcd 추가 시작. 최종 Plan ID로 전송 정보 형성함. WO Rolling에 추가하기 위해.
														-- Open WO 기반으로 Rolling하면 의미 없음
														INSERT INTO [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S]
																   ([IFSEQNO]
																   ,[SEQ]
																   ,[FP_PLAN_ID]
																   ,[PLANT_ID]
																   ,[FACTORY_ID]
																   ,[LINE_ID]
																   ,[OPERATION_ID]
																   ,[BOM_VERSION_ID]
																   ,[WORK_CENTER_ID]
																   ,[ITEM_ID]
																   ,[DEMAND_ID]
																   ,[WORK_ORDER_ID]
																   ,[ORDER_TYPE]
																   ,[PLAN_DATE]
																   ,[START_TIME]
																   ,[END_TIME]
																   ,[PLAN_IN_QTY]
																   ,[PLAN_QTY]
																   ,[FIX_TYPE]
																   ,[TRANSFER_FLAG]
																   ,[TRANSFER_DATE]
																   ,[CREATE_USER_ID]
																   ,[CREATE_DATE]
																   ,[MODIFY_USER_ID]
																   ,[MODIFY_DATE]
																   ,[LANE_QTY]
																   ,[BATCH_ORDER_ID]
																   ,[SLITTER_PLANT]
																   ,[MARKET] -- 170208 Add
																   ,[ATTRIBUTE1]
																   ,[ATTRIBUTE2]
																   ,[ATTRIBUTE3]
																   ,[ATTRIBUTE4]
																   ,[ATTRIBUTE5]
																   ,[ATTRIBUTE6]
																   ,[ATTRIBUTE7]
																   ,[ATTRIBUTE8]
																   ,[ATTRIBUTE9]
																   ,[ATTRIBUTE10]
																   ,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
																   ,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
																   ,[FP_PLAN_QTY]  -- FP Plan 수량
																   ,[FP_SNAP_QTY]) -- FP 실적 수량
															SELECT  CONVERT(NVARCHAR(26),CONVERT(NUMERIC(18),@IFSQENO)+4)   -- [IFSEQNO] --2017-10-26 16자리로 변경 -- 2017-11-06 SEQ 중복 처리
																   ,ROW_NUMBER() OVER( ORDER BY A.[FP_PLAN_ID], A.[PLANT_ID], A.[FACTORY_ID], A.[LINE_ID], A.[OPERATION_ID], A.[ITEM_ID], A.[WORK_ORDER_ID] ) AS SEQ
																   ,@RELEASE_PLAN_ID
																   ,A.[PLANT_ID]
																   ,A.[FACTORY_ID]
																   ,A.[LINE_ID]
																   ,A.[OPERATION_ID]
																   ,A.[BOM_VERSION_ID]
																   ,A.[WORK_CENTER_ID]
																   ,A.[ITEM_ID]
																   ,A.[DEMAND_ID]
																   ,A.[WORK_ORDER_ID]
																   ,A.[ORDER_TYPE]
																   ,A.[PLAN_DATE]
																   ,A.[START_TIME]
																   ,A.[END_TIME]
																   ,A.[PLAN_IN_QTY]
																   ,A.[PLAN_QTY]
																   ,A.[FIX_TYPE]
																   ,'Y' -- A.[TRANSFER_FLAG]
																   ,A.[TRANSFER_DATE]
																   ,A.[CREATE_USER_ID]
																   ,A.[CREATE_DATE]
																   ,A.[MODIFY_USER_ID]
																   ,A.[MODIFY_DATE]
																   ,A.[LANE_QTY]
																   ,A.[BATCH_ORDER_ID]
																   ,A.[SLITTER_PLANT]
																   ,A.[MARKET]
																   ,A.[ATTRIBUTE1]
																   ,A.[ATTRIBUTE2]
																   ,A.[ATTRIBUTE3]
																   ,A.[ATTRIBUTE4]
																   ,A.[ATTRIBUTE5]
																   ,A.[ATTRIBUTE6]
																   ,A.[ATTRIBUTE7]
																   ,A.[ATTRIBUTE8]
																   ,A.[ATTRIBUTE9]
																   ,A.[ATTRIBUTE10]
																   ,A.[TOP_BACK_IND]  -- [TOP_BACK_IND] 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
																   ,A.[LINK_WO]       -- [LINK_WO] 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
																   ,A.[FP_PLAN_QTY]   -- FP Plan 수량
																   ,A.[FP_SNAP_QTY]   -- FP 실적 수량
															FROM    [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] A WITH(NOLOCK)
															WHERE   A.[FP_PLAN_ID]    = @FP_PLAN_ID
															AND     A.[WORK_ORDER_ID] = @NEW_WORK_ORDER;
														-- 2017-09-19 kimcd 추가 종료. 최종 Plan ID로 전송 정보 형성함. WO Rolling에 추가하기 위해
														end

											END 		
						--	END
										;

										-- MES로 MO 생성 정보 전송
											insert into [DBO].[SY_XIF_MES_WO_S]
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
													,[ATTR_12] --PIYONG 2017-11-21 ADD
													,[ATTR_17] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,[ATTR_18] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,[ATTR_19] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,[ATTR_20] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,[ATTR_30] -- @PDS_IFSEQNO
											)
											select 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
											      ,'S' --[IF_TYPE]
											       -- 2021-05-25 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
											      ,'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,ISNULL(F.MES_SOURCE_GROUP,'')) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = @FACTORY_ID AND L.LINE_ID = @MES_LINE_ID ),'') +'_'+'FP_WO' -- [IF_ID]
											      ,getdate() -- [IF_INS_DATE]
											      ,'N' --[IF_FLAG]
											      ,null --[IF_SND_DATE]
											      ,null -- [RSLT_IF_SEQ]
											      ,null--[RSLT_PROC_FLAG]
											      ,null--[RSLT_PROC_MSG]
											      ,@FP_PLAN_ID  -- [PLAN_ID]
											      ,F.MES_PLANT_ID  -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영
											      ,@FACTORY_ID -- [BUILNO]
											      ,@MES_LINE_ID -- [LINE_ID]
											      ,@OPERATION_ID   -- [OPERATION_ID]
											      ,@EQUIPMENT_ID -- [EQUIPMENT_ID]
											      ,@ITEM_ID -- [ITEM_ID]
											      ,'MANUAL_INPUT_WO' -- [DEMAND_ID]
											      ,@NEW_WORK_ORDER -- [WO]
											      ,@FP_WO_TYPE -- [WO_TYPE]
											      ,@NEW_WORK_ORDER -- + cast(@WO_SEQ as varchar) -- [WO_DETAIL]  kimcd 2017-08-06 WO = WO_DETAIL로 전환
											      ,substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) -- [PLAN_DATE]
											      ,substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) -- [START_TIME]
											      ,substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) -- [END_TIME]
											      ,@IN_QTY -- [IN_QTY]
											      ,@OUT_QTY -- [OUT_QTY]
											      ,'Y' -- [IS_RELEASE]
											      ,'MANUAL_ADJST' -- [CREATE_PSN_ID]
											      ,getdate() --[CREATE_DATE]
											      ,'MANUAL_ADJST' -- [UPDATE_PSN_ID]
											      ,getdate() --[UPDATE_DATE]
											      ,@FP_LANE_QTY -- [LANE_QTY]
											      ,@UOM
											      ,ISNULL(@ORDER_TYPE,'MASS') -- [ORDER_TYPE]
											      ,CASE WHEN @OPERATION_ID = 'E1000' OR  @OPERATION_ID = 'E0500'  THEN
															CASE WHEN @BATCH_ORDER_ID IS NULL THEN						--2017.07.03 PIYONG 추가
																	@ITEM_ID
																 ELSE
																	@BATCH_ORDER_ID
																 END
														ELSE NULL
														END -- [BATCH_ORDER_ID]
											      ,@MES_SLITING_PLANT_ID -- [SLITTER_PLANT]  -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
											      ,@MARKET -- [MARKET]
											      -- ,CASE WHEN @OPERATION_ID in ( 'E0500','E1000' ) THEN @BATCH_QTY ELSE null END  -- [ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
											      ,CASE WHEN @OPERATION_ID in ( 'E0500','E1000' ) THEN @BATCH_QTY ELSE null END  -- [ATTR_02]
											      -- ,CASE WHEN @OPERATION_ID in ( 'E0500','E1000' ) THEN @IN_QTY ELSE null END  -- [ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
											      ,@MARKET -- [ATTR_04]
												   -- FP-058 kimcd 추가 시작. 2017-05-30
												   ,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
															 'B'
														 END AS TOP_BACK_IND -- ATTR_05 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
												   ,RTRIM ( CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
															 	CASE WHEN @NEW_WORK_ORDER LIKE 'W%' OR @NEW_WORK_ORDER LIKE 'M%' THEN
																	SUBSTRING(@NEW_WORK_ORDER,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(@NEW_WORK_ORDER,6,2)) + 50) + SUBSTRING(@NEW_WORK_ORDER,8,10)
																WHEN SUBSTRING(@NEW_WORK_ORDER,9,1) = '0' THEN
																		CASE WHEN SUBSTRING(@NEW_WORK_ORDER,6,1) = 'X' THEN
																			SUBSTRING(@NEW_WORK_ORDER,1,5) + 'Y' + SUBSTRING(@NEW_WORK_ORDER,7,10)
																		ELSE
																			SUBSTRING(@NEW_WORK_ORDER,1,4) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(@NEW_WORK_ORDER,5,2)) + 50) + SUBSTRING(@NEW_WORK_ORDER,7,10)
																		END
																ELSE
																		CASE WHEN SUBSTRING(@NEW_WORK_ORDER,7,1) = 'X' THEN
																			SUBSTRING(@NEW_WORK_ORDER,1,6) + 'Y' + SUBSTRING(@NEW_WORK_ORDER,8,10)
																		ELSE
																			SUBSTRING(@NEW_WORK_ORDER,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(@NEW_WORK_ORDER,6,2)) + 50) + SUBSTRING(@NEW_WORK_ORDER,8,10)
																		END
																END
															 END) AS LINK_WO      -- ATTR_06 연계된 WO명 - TOP은 Back WO, Back은 TOP WO  -- 2018-03-06 kimcd Top WO 연결정보 문장 재구성
												   ,RTRIM ( CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
															 	CASE WHEN @NEW_WORK_ORDER LIKE 'W%' OR @NEW_WORK_ORDER LIKE 'M%' THEN
																	SUBSTRING(@NEW_WORK_ORDER,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(@NEW_WORK_ORDER,6,2)) + 50) + SUBSTRING(@NEW_WORK_ORDER,8,10)
																WHEN SUBSTRING(@NEW_WORK_ORDER,9,1) = '0' THEN
																		CASE WHEN SUBSTRING(@NEW_WORK_ORDER,6,1) = 'X' THEN
																			SUBSTRING(@NEW_WORK_ORDER,1,5) + 'Y' + SUBSTRING(@NEW_WORK_ORDER,7,10)
																		ELSE
																			SUBSTRING(@NEW_WORK_ORDER,1,4) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(@NEW_WORK_ORDER,5,2)) + 50) + SUBSTRING(@NEW_WORK_ORDER,7,10)
																		END
																ELSE
																		CASE WHEN SUBSTRING(@NEW_WORK_ORDER,7,1) = 'X' THEN
																			SUBSTRING(@NEW_WORK_ORDER,1,6) + 'Y' + SUBSTRING(@NEW_WORK_ORDER,8,10)
																		ELSE
																			SUBSTRING(@NEW_WORK_ORDER,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(@NEW_WORK_ORDER,6,2)) + 50) + SUBSTRING(@NEW_WORK_ORDER,8,10)
																		END
																END
															 END) AS DETAIL_LINK_WO      -- ATTR_07 연계된 Detail WO명 - TOP은 Back WO, Back은 TOP WO -- 2018-03-06 kimcd Top WO 연결정보 문장 재구성
												  ,@IN_QTY AS FP_PLAN_QTY  -- ATTR_08 FP Plan 수량
												  ,'0' AS FP_SNAP_QTY  -- ATTR_09 FP 실적 수량
											      ,@LINE_ID -- [ATTR_10] FP_LINE_ID - kimcd 2017-06-18
												  ,ISNULL(@TOP_ITEM_ID, @ITEM_ID)  -- ATTR_12  --PIYONG 2017-11-21 ADD -- 2018-01-09 kimcd 최상위 품목 컬럼 추가
												  ,CASE WHEN @WORK_REQUEST_MODEL_ID = '-' THEN NULL ELSE @WORK_REQUEST_MODEL_ID END -- -- 2023-03-03 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												  ,CASE WHEN @VERSION = '-' THEN NULL -- [E20250918-001592] PDS 적용 인스턴스에서 PLM 버전을 자르고 사용할 경우 예외 처리 PLM_VERSION_FLAG 으로 구분
												        -- 2026-08-04 [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_PDS_VERSION_M] outer join 추가. PDS VERSION table 우선 사용.
												  	    ELSE CASE WHEN F.ELEC_VERSION_TYPE = 'FP' THEN @VERSION
														          ELSE CASE WHEN ISNULL(Y.PLM_VERSION_FLAG,'N') = 'N'
																	        AND  ISNULL ( ( SELECT TOP 1 'Y'
																						    FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  A WITH(NOLOCK)	
																						    WHERE 1=1
																						    AND A.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
																						    AND A.ACTIVE_FLAG = 'Y'
																						    AND A.SEGMENT1    =  @INSTANCE_ID ), 'N') = 'Y' THEN ISNULL(PVM.[PDS_VERSION],@VERSION) ELSE SUBSTRING(@VERSION,1,3) END
																  END
												   END -- -- 2023-03-03 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												  ,@PROD_SEQ  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												  ,@PLM_EC_NO -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												  ,@PDS_IFSEQNO
										    FROM   SCM_LINE_M SL WITH(NOLOCK) -- 2022-07-12 kimcd 설비 의존도 제거. 라인 Table 추가
											       INNER JOIN SCM_FACTORY_M F  WITH(NOLOCK)
												        ON  F.FACTORY_ID  = @FACTORY_ID 
														AND SL.FACTORY_ID = F.FACTORY_ID  -- 2023-03-03 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송
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
																	) Y
													ON	1=1
													AND @FACTORY_ID		= Y.FACTORY_ID
													AND SL.FACTORY_ID	= Y.FACTORY_ID
													AND @ITEM_ID		= Y.ITEM_ID
													AND @WORK_REQUEST_MODEL_ID	= Y.MODEL_ID
													AND @VERSION		= Y.PROD_VERSION
												   LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M]  EQP WITH(NOLOCK)
	       												ON  EQP.LINE_ID       = SL.LINE_ID        
														AND EQP.PLANT_ID      = SL.PLANT_ID
														AND EQP.DIVISION_ID   = SL.DIVISION_ID
														AND EQP.COMPANY_ID	 = SL.COMPANY_ID
														AND EQP.SITE_ID	     = SL.SITE_ID
														AND EQP.ELECTRODE_TYPE = SL.ELECTRODE_TYPE
														AND EQP.OPERATION_ID  = SL.OPERATION_ID
														AND EQP.FACTORY_ID    = SL.FACTORY_ID
														AND EQP.EQUIPMENT_ID = @EQUIPMENT_ID
														AND EQP.OPERATION_ID = @OPERATION_ID
														AND EQP.FACTORY_ID   = @FACTORY_ID
														AND EQP.EQUIPMENT_TYPE = 'M'
														AND EQP.ACTIVE_FLAG    = 'Y'
													LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  EQPC WITH(NOLOCK)
														ON  EQPC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_OP'
														AND EQPC.SEGMENT1         = EQP.OPERATION_ID
														AND EQPC.SEGMENT2         = EQP.COATER_EQPT_TYPE_CODE
														AND EQPC.ACTIVE_FLAG      = 'Y'
													,[DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
													LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  IMC WITH(NOLOCK)
														ON  IMC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_ITEM_CLASS'
														AND IMC.SEGMENT1         = IM.ITEM_CLASS
														AND IMC.ACTIVE_FLAG      = 'Y'
 											-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_PDS_VERSION_M] outer join 추가
											LEFT OUTER JOIN [dbo].[FP_PDS_VERSION_M]  PVM WITH(NOLOCK)
												ON 	PVM.[FACTORY_ID] = @FACTORY_ID
												AND PVM.[MODEL_ID]   = @WORK_REQUEST_MODEL_ID
												AND PVM.[VERSION]    = @VERSION
											WHERE SL.LINE_ID       = @LINE_ID      -- 2022-07-12 kimcd 설비 의존도 제거. 라인 Table 추가        
											AND	  SL.PLANT_ID      = @FP_PLANT_ID
											AND	  SL.DIVISION_ID   = @DIVISION_ID
											AND	  SL.COMPANY_ID	   = @COMPANY_ID
											AND	  SL.SITE_ID	   = @FP_SITE_ID
											AND	  SL.ELECTRODE_TYPE	= @ELECTRODE_TYPE
											AND   SL.OPERATION_ID  = @OPERATION_ID
											AND   SL.FACTORY_ID    = @FACTORY_ID
											AND   SL.ACTIVE_FLAG   = 'Y'
											AND   SL.COMPANY_ID    = IM.COMPANY_ID -- 2019-07-23 kimcd item에 company id 조건 추가
											AND   IM.DIVISION_ID   = @DIVISION_ID
											AND   IM.SITE_ID       = @FP_SITE_ID
											AND   IM.ITEM_ID       = @ITEM_ID;


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
														,[MARKET]
														-- ,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
														,[ATTR_02]
														-- ,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
														,[ATTR_04]
														,[ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
														,[ATTR_06] -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
														,[ATTR_07] -- 연계된 Detail WO명 - TOP은 Back WO, Back은 TOP WO
														,[ATTR_08] -- FP Plan 수량
														,[ATTR_09] -- FP 실적 수량
														,[ATTR_10]
														,[ATTR_12]  --PIYONG 2017-11-21 ADD
														,[ATTR_17] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_18] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_19] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_20] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
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
														,[MARKET]					                                                                                                                                                                                                                            
														-- ,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
														,[ATTR_02]
														-- ,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
														,[ATTR_04]
														,'T'          -- [ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
														,[WO]         -- [ATTR_06] -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
														,[WO_DETAIL]  -- [ATTR_07] -- 연계된 Detail WO명 - TOP은 Back WO, Back은 TOP WO
														,[ATTR_08] -- FP Plan 수량
														,[ATTR_09] -- FP 실적 수량
														,[ATTR_10]
														,[ATTR_12]  --PIYONG 2017-11-21 ADD
														,[ATTR_17] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_18] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_19] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_20] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,@PDS_IFSEQNO
											FROM   [dbo].[SY_XIF_MES_WO_S] WITH(NOLOCK)
											WHERE  PLAN_ID = ISNULL(@FP_PLAN_ID,'0')
											AND    ATTR_05 = 'B'
											AND    WO      = @NEW_WORK_ORDER -- [WO]
											AND    WO_DETAIL = @NEW_WORK_ORDER /*+ cast(@WO_SEQ as varchar)*/ -- [WO_DETAIL]   kimcd 2017-08-06 WO = WO_DETAIL로 전환

											-- 2017-09-19 kimcd 추가 시작. 최종 Plan ID로 전송 정보 형성함. WO Rolling에 추가하기 위해.
											-- Open WO 기반으로 Rolling하면 의미 없음
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
														,[MARKET]
														--,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
														,[ATTR_02]
														--,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
														,[ATTR_04]
														,[ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
														,[ATTR_06] -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
														,[ATTR_07] -- 연계된 Detail WO명 - TOP은 Back WO, Back은 TOP WO
														,[ATTR_08] -- FP Plan 수량
														,[ATTR_09] -- FP 실적 수량
														,[ATTR_10]
														,[ATTR_12]  --PIYONG 2017-11-21 ADD
														,[ATTR_17] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_18] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_19] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_20] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_30] -- @PDS_IFSEQNO
											)
											SELECT       'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
														,[IF_TYPE]
														,[IF_ID]
														,[IF_INS_DATE]
														,'Y' --[IF_FLAG]
														,[IF_SND_DATE]
														,[RSLT_IF_SEQ]
														,[RSLT_PROC_FLAG]
														,[RSLT_PROC_MSG]
														,@RELEASE_PLAN_ID -- [PLAN_ID]
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
														--,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
														,[ATTR_02]
														--,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
														,[ATTR_04]
														,[ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
														,[ATTR_06] -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
														,[ATTR_07] -- 연계된 Detail WO명 - TOP은 Back WO, Back은 TOP WO
														,[ATTR_08] -- FP Plan 수량
														,[ATTR_09] -- FP 실적 수량
														,[ATTR_10] -- FP Line
														,ISNULL(@TOP_ITEM_ID, [ITEM_ID]) AS ATTR12 -- PIYONG 2017-11-21 ADD -- 2018-01-09 kimcd 최상위 품목 컬럼 추가
														,[ATTR_17] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_18] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_19] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,[ATTR_20] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,@PDS_IFSEQNO
											FROM   [dbo].[SY_XIF_MES_WO_S] WITH(NOLOCK)
											WHERE  PLAN_ID = ISNULL(@FP_PLAN_ID,'0')
											AND    WO      = @NEW_WORK_ORDER -- [WO]
											AND    WO_DETAIL = @NEW_WORK_ORDER /*+ cast(@WO_SEQ as varchar)*/ -- [WO_DETAIL]   kimcd 2017-08-06 WO = WO_DETAIL로 전환
											-- 2017-09-19 kimcd 추가 종료. 최종 Plan ID로 전송 정보 형성함. WO Rolling에 추가하기 위해.

											INSERT INTO DBO.FP_MES_PRODUCTION_PLAN_M
												([INSTANCE_ID]
												,[COMPANY_ID]
												,[DIVISION_ID]
												,[SITE_ID]
												,[PLANT_ID]
												,[FACTORY_ID]
												,[WORK_ORDER_SPL_ID]
												,[WORK_ORDER_ID]
												,[BATCH_ORDER_ID]
												,[ORDER_TYPE]
												,[ITEM_ID]
												,[LANE_QTY]
												,[LINE_ID]
												,[OPERATION_ID]
												,[ELECTRODE_TYPE]
												,[EQUIPMENT_ID]
												,[START_TIME]
												,[END_TIME]
												,[PLAN_QTY]
												,[PLAN_IN_QTY]
												,[BATCH_QTY]
												,[BATCH_SUM_QTY]
												,[FIX_TYPE]
												,[PRODUCTION_TYPE]
												,[SLIT_PLANT_ID]
												,[MARKET]
												,[ATTRIBUTE1]  -- FP-058 초기 계획 수량 kimcd 2017-05-25
												,[WORK_REQUEST_MODEL_ID] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												,[VERSION]    -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												,[PROD_SEQ]   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												,[PLM_EC_NO]  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												,[INSERT_FP_PLAN_ID]
												,[INSERT_ID]
												,[INSERT_TIME]
												,[UPDATE_FP_PLAN_ID]
												,[UPDATE_ID]
												,[UPDATE_TIME])
											SELECT ISNULL(@INSTANCE_ID, '-')
												  ,@COMPANY_ID
												  ,@DIVISION_ID
												  ,@FP_SITE_ID
												  ,@FP_PLANT_ID
												  ,@FACTORY_ID
												  ,@NEW_WORK_ORDER /*+ cast(@WO_SEQ as varchar) kimcd 2017-08-06 WO = WO_DETAIL로 전환 */
												  ,@NEW_WORK_ORDER
												  ,CASE WHEN @OPERATION_ID = 'E1000' OR  @OPERATION_ID = 'E0500'  THEN
															CASE WHEN @BATCH_ORDER_ID IS NULL THEN						--2017.07.03 PIYONG 추가
																	@ITEM_ID
																 ELSE
																	@BATCH_ORDER_ID
																 END
														ELSE NULL
														END -- [BATCH_ORDER_ID]
												  ,SUBSTRING(@FP_WO_TYPE,1,1) -- [ORDER_TYPE]
												  ,@ITEM_ID
												  ,@FP_LANE_QTY
												  ,@LINE_ID
												  ,@OPERATION_ID
												  ,@ELECTRODE_TYPE
												  ,@EQUIPMENT_ID
												  ,cast ( substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) as datetime) -- [START_TIME]
												  ,cast ( substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) as datetime) -- [END_TIME]
												  ,@OUT_QTY -- [PLAN_QTY]
												  ,@IN_QTY   -- [PLAN_IN_QTY]
												  ,CASE WHEN @OPERATION_ID in ( 'E0500','E1000' ) THEN @BATCH_QTY ELSE null END -- [BATCH_QTY]
											      ,CASE WHEN @OPERATION_ID in ( 'E0500','E1000' ) THEN @BATCH_QTY ELSE null END -- [BATCH_SUM_QTY]
												  ,'N' -- [FIX_TYPE]
												  ,@ORDER_TYPE -- [PRODUCTION_TYPE]
												  ,@FP_SLITING_PLANT_ID
												  ,@MARKET -- [MARKET]
												  ,@IN_QTY  -- [ATTRIBUTE1]
												  ,@WORK_REQUEST_MODEL_ID -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												  ,@VERSION   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												  ,@PROD_SEQ  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												  ,@PLM_EC_NO -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												  ,@FP_PLAN_ID  -- [INSERT_FP_PLAN_ID]
											      ,'MANUAL_ADJST' -- [INSERT_ID]
											      ,GETDATE() --[INSERT_TIME]
												  ,@FP_PLAN_ID  -- [UPDATE_FP_PLAN_ID]
											      ,'MANUAL_ADJST' -- [UPDATE_FP_PLAN_ID]
											      ,GETDATE() --[UPDATE_ID]
												  ;
										   -- FP-058 kimcd 추가 끝. 2017-05-30

										   -- 2018-01-11 kimcd 추가 시작
										   -- open work order에 추가 입력
										   INSERT INTO [dbo].[FP_MES_WORK_ORDER_STATUS_H]
												([COMPANY_ID]
												,[DIVISION_ID]
												,[SITE_ID]
												,[PLANT_ID]
												,[FACTORY_ID]
												,[CUTOFF_DATE]
												,[WORK_ORDER_SPL_ID]
												,[WORK_ORDER_ID]
												,[DEMAND_ID]
												,[PRODUCTION_TYPE]
												,[ORDER_TYPE]
												,[ITEM_ID]
												,[TOP_ITEM_ID]
												,[OPERATION_ID]
												,[LINE_ID]
												,[WORK_CENTER_ID]
												,[EQUIPMENT_ID]
												,[PLAN_DATE]
												,[PLAN_START_TIME]
												,[PLAN_END_TIME]
												,[PLAN_IN_QTY]
												,[PLAN_QTY]
												,[ACTUAL_QTY]
												,[ACTUAL_GOOD_QTY]
												,[ACTUAL_SCRAP_QTY]
												,[RUNNING_FLAG]
												,[WO_STATUS]
												,[MARKET]
												,[BATCH_ORDER_ID]
												,[LANE_QTY]
												,[WORK_REQUEST_MODEL_ID] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												,[VERSION]    -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												,[PROD_SEQ]   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												,[PLM_EC_NO]  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
												,[INSERT_ID]
												,[INSERT_TIME] )
											SELECT   @COMPANY_ID
													,@DIVISION_ID
													,@FP_SITE_ID
													,@FP_PLANT_ID
													,@FACTORY_ID
													,@WO_CUTOFF_DATE
													,@NEW_WORK_ORDER
													,@NEW_WORK_ORDER
													,'MANUAL_INPUT_WO'            -- [DEMAND_ID]
													,ISNULL(@ORDER_TYPE,'MASS')   -- [PRODUCTION_TYPE]
													,@FP_WO_TYPE                  -- [WO_TYPE]
													,@ITEM_ID
													,ISNULL(@TOP_ITEM_ID,@ITEM_ID)
													,@OPERATION_ID
													,@LINE_ID
													,'-' AS WORK_CENTER_ID
													,@EQUIPMENT_ID
													,substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) -- [PLAN_DATE]
													,substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) -- [START_TIME]
													,substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) -- [END_TIME]
													,@IN_QTY AS PLAN_IN_QTY
													,@IN_QTY AS PLAN_QTY
													,0 -- ACTUAL_QTY
													,0 -- ACTUAL_GOOD_QTY
													,0 -- ACTUAL_SCRAP_QTY
													,'-'     AS RUNNING_FLAG   
													,'OPEN'  AS WO_STATUS
													,@MARKET AS MARKET
													,CASE WHEN @OPERATION_ID = 'E1000' OR  @OPERATION_ID = 'E0500'  THEN
														 CASE WHEN @BATCH_ORDER_ID IS NULL THEN
															 @ITEM_ID
														 ELSE
															 @BATCH_ORDER_ID
														 END
													 ELSE NULL
													 END -- [BATCH_ORDER_ID]
													,@FP_LANE_QTY -- [LANE_QTY]
													,@WORK_REQUEST_MODEL_ID -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,@VERSION   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,@PROD_SEQ  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,@PLM_EC_NO -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													,'MANUAL_ADJST' -- [UPDATE_PSN_ID]
													,GETDATE()

										   -- Fix Plan 결과로 계획 입력
										   IF @INSTANCE_ID IS NOT NULL AND @INSTANCE_DATE IS NOT NULL
											   INSERT INTO [dbo].[FP_PRODUCTION_PLAN_R]
													(  [INSTANCE_ID]
													  ,[FP_PLAN_ID]
													  ,[COMPANY_ID]
													  ,[DIVISION_ID]
													  ,[SITE_ID]
													  ,[PLANT_ID]
													  ,[FACTORY_ID]
													  ,[WORK_ORDER_ID]
													  ,[BATCH_ORDER_ID]
													  ,[ORDER_TYPE]
													  ,[SCP_TARGET_ID]
													  ,[DEMAND_ID]
													  ,[ITEM_ID]
													  ,[LANE_QTY]
													  ,[TOP_ITEM_ID]
													  ,[OPERATION_ID]
													  ,[LINE_ID]
													  ,[ELECTRODE_TYPE]
													  ,[WORK_CENTER_ID]
													  ,[PLAN_DATE]
													  ,[START_TIME]
													  ,[END_TIME]
													  ,[PLAN_QTY]
													  ,[PLAN_IN_QTY]
													  ,[ITEM_UOM]
													  ,[FIX_TYPE]
													  ,[PRODUCTION_TYPE]
													  ,[MARKET]
													  ,[MFG_WEEK]
													  ,[DEMAND_DIVISION_ID]
													  ,[WORK_REQUEST_MODEL_ID] -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													  ,[VERSION]    -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													  ,[PROD_SEQ]   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													  ,[PLM_EC_NO]  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
													  ,[INSERT_ID]
													  ,[INSERT_TIME] )
												SELECT   ISNULL(@INSTANCE_ID, '-')
														,@RELEASE_PLAN_ID
														,@COMPANY_ID
														,@DIVISION_ID
														,@FP_SITE_ID
														,@FP_PLANT_ID
														,@FACTORY_ID
														,@NEW_WORK_ORDER
														,CASE WHEN @OPERATION_ID = 'E1000' OR  @OPERATION_ID = 'E0500'  THEN
															 CASE WHEN @BATCH_ORDER_ID IS NULL THEN
																 @ITEM_ID
															 ELSE
																 @BATCH_ORDER_ID
															 END
														 ELSE NULL
														 END -- [BATCH_ORDER_ID]
														,SUBSTRING(@FP_WO_TYPE,1,1)   -- [ORDER_TYPE]
														,'MANUAL_INPUT_WO'            -- [SCP_TARGET_ID]
														,'MANUAL_INPUT_WO'            -- [DEMAND_ID]
														,@ITEM_ID
														,@FP_LANE_QTY                 -- [LANE_QTY]
														,ISNULL(@TOP_ITEM_ID,@ITEM_ID)
														,@OPERATION_ID
														,@LINE_ID
														,@ELECTRODE_TYPE
														,@ERP_WORK_CENTER_ID
														,substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) -- [PLAN_DATE]
														,substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) -- [START_TIME]
														,substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) -- [END_TIME]
														,@OUT_QTY -- [OUT_QTY]
														,@IN_QTY  -- [IN_QTY]
														,@UOM     -- [ITEM_UOM]
														,'N'      -- [FIX_TYPE]
														,ISNULL(@ORDER_TYPE,'MASS')   -- [PRODUCTION_TYPE]
														,@MARKET AS MARKET
														,(SELECT TOP 1 [WEEK] FROM [dbo].[SCM_SYS_CALENDAR_M] SC WITH(NOLOCK)
														  WHERE  DATE_ID = substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2))-- MFG_WEEK
														,@DIVISION_ID   -- [DEMAND_DIVISION_ID]
														,ISNULL(@WORK_REQUEST_MODEL_ID,'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,ISNULL(@VERSION,'-')   -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,@PROD_SEQ  -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,ISNULL(@PLM_EC_NO,'-') -- 2022-12-06 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														,'MANUAL_ADJST' -- [INSERT_ID]
														,GETDATE()
											-- 2018-01-11 kimcd 추가 끝
										   
						                 UPDATE [dbo].[SCM_MANUAL_WO_CREATE]
						                    SET [PROCESSING_YN] = 'Y'
						                       ,ERROR_MSG = 'SUCCESS'
									           ,WO_ID = CASE WHEN (select count(1)
												                     from dbo.SCM_OPERATION_M  a
												                         ,dbo.SCM_FACTORY_M  b
											                        where a.operation_id = @OPERATION_ID   
												                      and a.WO_FLAG      = 'Y'
												                      and a.SITE_ID      = b.SITE_ID
												                      and a.DIVISION_ID  = b.DIVISION_ID
												                      and a.ACTIVE_FLAG  = 'Y'
												                      and a.ACTIVE_FLAG  = b.ACTIVE_FLAG
												                      and b.FACTORY_ID   = @FACTORY_ID     ) > 0 
												             THEN @NEW_WORK_ORDER ELSE NULL END
						     				   ,MO_ID = @NEW_WORK_ORDER -- + cast(@WO_SEQ as varchar) kimcd 2017-08-06 WO = WO_DETAIL로 전환
											   ,WO_TYPE = @FP_WO_TYPE
										       ,work_center_id = @ERP_WORK_CENTER_ID
										       ,lane_qty = @FP_LANE_QTY
										       ,ORDER_CREAT_DATE = getdate()
											   ,UPDATE_DATE = getdate()
						                  WHERE SEQ = @SEQ
										    and WO_BASE_DATE = @WO_BASE_DATE
						                   ;
						
						    end				
						
				end;
															  	
			FETCH NEXT FROM CUR_MANUAL_WO_LIST INTO  @SEQ
			                                        ,@WO_BASE_DATE   
													,@STATUS 
													,@FACTORY_ID     
													,@LINE_ID        
													,@OPERATION_ID   
													,@EQUIPMENT_ID   
													,@ITEM_ID        
													,@WORK_CENTER_ID 
													,@WO_ID          
													,@MO_ID          
													,@ORDER_TYPE     
													,@WO_TYPE        
												--	,@PLAN_DATE      
													,@START_TIME     
													,@END_TIME       
													,@IN_QTY         
													,@OUT_QTY        
													,@LANE_QTY      
													,@BATCH_QTY 
													,@MARKET 
													,@UPDATE_PSN_ID
													,@WO_SEQ
													,@TOTAL_IN_QTY
													,@TOTAL_OUT_QTY
													,@TOP_ITEM_ID -- 2018-01-09 kimcd 최상위 품목 컬럼 추가
													,@WORK_REQUEST_MODEL_ID  -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
													,@VERSION                -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
													,@PROD_SEQ               -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
													,@PLM_EC_NO              -- 2022-12-06 kimcd 전극 버전별 생산 계획 수립에 따른 전극 버전과 EC NO 정보 추가
													 ;
			END;
			
			CLOSE CUR_MANUAL_WO_LIST;
			DEALLOCATE CUR_MANUAL_WO_LIST;      
			
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
						, 'N'  --X.[IF_FLAG]                                                                                                  
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
					-- 하드코딩 G670
					where y.company_id in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_MANUAL_ORDER_CREATE' AND SEGMENT1  = 'COMPANY_COND' AND ACTIVE_FLAG='Y')
					  and x.ATTR_30 = @PDS_IFSEQNO
					;			

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		CLOSE CUR_MANUAL_WO_LIST;
		DEALLOCATE CUR_MANUAL_WO_LIST;    

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
  		SET @v_descr = ERROR_MESSAGE()																																												
	  	EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate																																												

	END CATCH

END
