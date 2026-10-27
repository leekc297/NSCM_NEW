                                                                                                                                                                 
CREATE PROCEDURE [dbo].[PR_XIF_SCP_PRODTARGET_R]
                                                                                                                                                                 
-- ================================================================================================                                                              
-- Program ID          : FP00520                                                                                                                                      
-- Program Name        : PR_XIF_SCP_PRODTARGET_R                                                                                                                
-- Param               :                                                                                                                                         
-- Batch Period        : 15 MINUTE                                                                                                                                   
-- Description         :                                                                                                                                         
--                                                                                                                                                               
-- Source System       : SCP                                                                                                                                    
-- Destination System  : FP SDB                                                                                                                                  
-- Source Table        : XIF_SCP_PROD_TARGET_R                                                                                                                  
-- Destination Table   : FP_WEEKLY_DEMAND_PRODUCT_H                                                                                                              
--                                                                                                                                                               
-- Create Date         : 2018.04.26
-- Update Date		   : 2018.06.11 1.1 PIYONG
--                       2018.06.20 1.2 kimcd
--                       2018.06.29 1.3 kimcd
--						 2018.07.23 1.4 PIYONG
--						 2018.08.02	1.5 PIYONG
--						 2018.08.30 1.6 PIYONG
--						 2018.09.17 1.7 PIYONG 
--						 2018.10.11 1.8 PIYONG
--						 2018.11.12 1.9 PIYONG
--						 2018.11.27 1.10 PIYONG
--						 2018.12.10 2.0 PIYONG
--						 2018.12.17 2.1 PIYONG
--                       2019.01.07 2.2 kimcd
--						 2019.01.09 2.3 PIYONG
--						 2019.04.19 2.4 PIYONG
--						 2019.05.29 2.5 PIYONG
--						 2019.06.21 2.6 PIYONG
--						 2019.06.25 3.0 PIYONG
--						 2019.07.15 3.1 PIYONG
--						 2019.08.07 3.2 PIYONG
--						 2019.08.19 3.3 PIYONG
--						 2019.09.26 3.4 PIYONG
--                       2019.10.03 3.5 kimcd
--						 2019.10.15 3.6 PIYONG
--                       2019.10.23 3.7 KIMCD
--                       2019.11.26 3.8 kimcd
--                       2019.11.27 3.81 kimcd
--						 2020.01.14 3.82 PIYONG
--						 2020.03.11 3.83 PIYONG
--						 2020.12.17 3.84 kimcd
--						 2021.08.12 3.9 kimcd
--						 2021.11.19 4.0 kimcd
--						 2022.03.29 4.1 kimcd
--                       2022.12.26 4.2 leeseongmin
--                       2023.04.06 4.4 kimcd

--
-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 PLAN_TYPE FN 추가
--						 FP_WEEKLY_DEMAND_PRODUCT_H 데이터 생성 시 GROUP BY 조건 추가
--                       2018-06-20 kimcd 기존 생산 Target의 Production Type과 Market을 기준으로 
--                                        신규 수신한 생산 Target의 정보 변경함.
--                                        주별 첫번재 계획 제외 로직 주석 처리
--                       2018-06-29 kimcd 기존 정보 기준으로 Production Type 동기화 기준을
--                                        Demand ID에서 Demand ID 조건 중 Production Type, Market을 제외
--						 1.4 DIVISION 별 메일 발송
--						 1.5 PLANT 별 DEMAND TYPE MAPPING
--						 1.6 전극일 경우 일자별 GROUP BY, TARGET일자보다 개발일정이 클경우 PRODUCTION_TYPE을 DEVELOP으로 변경
--						 1.7 CNA PRODUCTION_TYPE 조회 조건 추가
--						 1.8 전극 PRODUCTION_TYPE 로직 변경
--							 A002 MARKET 값이 없을 경우 조건없이 'E' (CASE ->  'E')
--						 1.9 CASE WHEN B.SEGMENT3 = '40' THEN'DEVELOP' ELSE 'D-SAMPLE' END 주석 처리
--						 1.10 PILOT_LINE  LOOK_UP에 ATTRIBUTE2이 Y일 경우  일자로 데이터 생성 로직 추가
--						 2.0 PRODUCTION_TYPE 적용 로직 변경
--							 오창 자동차(전극 말고) 만 PV -> SEPCIAL 
--							 소형,PACK의 경우값이 없으면  -> MASS
--											 값이 존재하면-> D-SAMPLE
--						 2.1 PRODUCTION_TYPE 적용 로직 변경
--							 PACK 만 적용
--                       2.2 2019-01-07 kimcd TEST 수요는 기존 수요 유형 유지
--						 2.3 2019-01-09 PIYONG 전극 개발단계 PLANT 조건 추가 (장현석선임 요청)
--						 2.4 2019-04-19 PIYONG FP_PLM_PJT_SCHEDULE_R 테이블 조회시 PJT_STATUS != 'Drop'	조건 추가
--											  DIVISION_ID 가 81,82 일경우 PLAN_TYPE이 MA 만 수신
--						 2.5 2019-05-29 PIYONG SCM_SCP_PLAN_H  PLAN_WEEK 컬럼 단자리 주차 생성시 0 생성되도록 변경
--						 2.6 전극 PRODUCTION_TYPE 생성시 장현석책임 요청으로 적용모델 기준으로 변경
--							- 개발 단계에 없을 경우 MASS로 적용
--						 3.0 전극 PRODUCTION_TYPE 생성시 FP_PLM_PJT_MODEL_MASTER 이용
--							FP_PLM_PJT_MODEL_MASTER에 없는 전극 ITEM_ID  FP_PLM_PJT_MODEL_MASTER에 생성 로직 추가
--						 3.1 전극을 제외 DIVISINO 40,81,82 은 MAIN 만 수신
--						 3.2 정인천책임 요청으로 오창만 PV일때 SPECIAL 생성
--						 3.3 정인천책임 요청으로 PACK 공정 수요 유형 설정 변경
--						 3.4 CELL PRODUCTION_TYPE  생성시 JPT 적용
--                       3.5 2019-10-03 kimcd 전극 수신 작업에 WITH(INDEX(IDX01_XIF_SCP_PROD_TARGET_R)) index hint 추가
--						 3.6 장현석책임 요청으로 CELL 공정 수요 유형 설정 변경
--                       3.7 2019-10-23 kimcd 전극, 그외로 IF문 추가하여 전극 공정과 그 외 공정 문장이 중복 수행되는 것 막음
--                       3.8 2019-11-26 kimcd 전극. 주 기준으로 변경. 기존 Order Type은 TEST인 경우만 유지
--                       3.81 2019-11-27 kimcd Order Type을 법인, 공정 무관하게 개발 단계 Master 기준으로 변경함. 개발 단계 없으면 SCP 수요 유형 사용
--                       3.82 PRODUCTION_TYPE IN ('SPECIAL', 'D-SAMPLE') 일때 오창, 빈강 SPECIAL 나머진 D-SAMPLE 생성 --장현석 책임 요청
--						 3.83 PRODUCTION_TYPE = 'SPECIAL' 일때 오창, 빈강 SPECIAL 나머진 D-SAMPLE 생성 --장현석 책임 요청
--                       3.84 2020-12-17 kimcd 작업 속도 문제로 with절로 lookup 조회 과정을 분리함 
--                       3.9 2021-08-12 kimcd TEST 수요의 경우 전주 Target을 이번 주에 추가 형성. 다른 수요 유형의 SCP Target은 수량 감소시킴 
--						 4.0 2021-11-19 kimcd P5200 공정 품목의 경우 Pegging 제품으로 수신
--						 4.1 2022-03-29 kimcd 가상 Division 반영 로직 수정
--                       4.2 2022-12-26 leeseongmin SCP Target의 생산타입을 유지하는 로직 개선 (D-SAMPLE)
--                       4.3 2023-02-28 kimcd 소형 PRE, 자동차 MAIN 수신으로 변경
--                       4.4 2023-04-06 kimcd 소형 PRE, 자동차 MAIN 수신을 Option으로 변경
-- ================================================================================================                                                              
                                                                                                                                                                 
AS                                                                                                                                                               
                                                                                                                                                                 
BEGIN                                                                                                                                                            
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                                                                                               
    SET NOCOUNT ON                                                                                                                                               
	SET XACT_ABORT ON                                                                                                                                            
                                                                                                                                                                 
	-- LOG 용 변수 설정                                                                                                                                               
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SCP_PRODTARGET_R'                                                                                               
	DECLARE @v_descr     NVARCHAR(250)                                                                                                                            
	DECLARE @v_count     INTEGER	   = 0                                                                                                                        
	DECLARE @sysdate     DATETIME      = GETDATE()       
	
	DECLARE @ROWCOUNT    INTEGER
	DECLARE @ROWCOUNT1   INTEGER
	                                                                                                          
	-- ERROR_LINE                                                                                                                                                
	DECLARE @v_temp1     NVARCHAR(1000)                                                                                                                           
	DECLARE @v_temp2     NVARCHAR(1000)                                                                                                                           
                                                                                                                                                                 
	-- ================================================                                                                                                          
    -- Declare start                                                                                                                                             
	-- ================================================                                                                                                          
	DECLARE @PROC_FLAG_CHK  NUMERIC(10,0)
	DECLARE @DIVISION_NAME	NVARCHAR(150)	-- 2018-07-13 PIYONG ADD

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

		SET @PROC_FLAG_CHK = (
								SELECT COUNT(PROC_FLAG)
								  FROM [dbo].[SY_XIF_SCP_PROD_TARGET_R]
								 WHERE ISNULL(PROC_FLAG,'N') = 'N'
								   AND PLAN_TYPE IN ( 'PR','MA', 'FN')	--2018-06-11 PIYONG FN ADD  -- 2023-02-28 kimcd 소형 PRE, 자동차 MAIN 수신으로 변경. PRE 추가
							)

		IF @PROC_FLAG_CHK > 0

			BEGIN

				DECLARE @CNT_CHK			NUMERIC(10,0) = 0
				DECLARE @V_PLAN_WEEK		NVARCHAR(50)
				DECLARE @V_SCP_PLAN_ID		NVARCHAR(50)
				DECLARE @DIVISION			NVARCHAR(50)
				DECLARE @C_DIVISION			NVARCHAR(50)
				DECLARE @SHOP_GROUP         NVARCHAR(50)  -- 2019-10-23 kimcd add 공정군 구분


				DECLARE CUR_DIVISION CURSOR FOR
					SELECT DIVISION, MAX(PLAN_WEEK) AS PLAN_WEEK, MAX(OPERATION_GROUP) AS SHOP_GROUP_ID -- 2019-10-23 kimcd add 공정군 구분
					  FROM [dbo].[SY_XIF_SCP_PROD_TARGET_R]
					 WHERE ISNULL(PROC_FLAG,'N') = 'N'
					   AND PLAN_TYPE IN ( 'PR','MA', 'FN')	--2018-06-11 PIYONG FN ADD -- 2023-02-28 kimcd 소형 PRE, 자동차 MAIN 수신으로 변경. PRE 추가
					 GROUP BY DIVISION
				
				OPEN CUR_DIVISION
				FETCH NEXT FROM CUR_DIVISION INTO @DIVISION
												, @V_PLAN_WEEK
												, @SHOP_GROUP  -- 2019-10-23 kimcd add 공정군 구분


				WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
				BEGIN

					IF OBJECT_ID('tempdb..#BEFORE_SCP_PLAN_ID') IS NOT NULL
						DROP TABLE #BEFORE_SCP_PLAN_ID

					SELECT DISTINCT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID
							, DIVISION_ID
							, SHOP_GROUP_ID							--2018-08-30 PIYONG ADD
					  INTO #BEFORE_SCP_PLAN_ID
					  FROM [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H] WITH(NOLOCK)
					 -- WHERE SHOP_GROUP_ID IN ('P', 'A')  			-- 2019-01-07 kimcd 조립 공정도 추가 함. 2018-12-17 PIYONG ADD --PACK 데이터만 적용
					 -- 2019-11-26 kimcd 전극도 변경하기 위해 조건 삭제
					 GROUP BY DIVISION_ID
						   , SHOP_GROUP_ID							--2018-08-30 PIYONG ADD


					-- ================================================================================================                                                                                                      
					-- @V_SCP_PLAN_ID 구하기                                                                                                                               
					-- ================================================================================================
					SET @V_SCP_PLAN_ID = @V_PLAN_WEEK;


					SET @CNT_CHK = (
									SELECT COUNT(1) -- 값이 0 보다 크면 수행을 하면 안됨.
									  FROM (
											SELECT (
													SELECT COUNT(1)
													  FROM [dbo].[SY_XIF_SCP_PROD_TARGET_R] A
													 WHERE A.PLAN_WEEK = @V_PLAN_WEEK
													   AND A.DIVISION  = @DIVISION
													   AND A.PLAN_TYPE IN ( 'PR','MA', 'FN')			--2018-06-11 PIYONG FN ADD -- 2023-02-28 kimcd 소형 PRE, 자동차 MAIN 수신으로 변경. PRE 추가
													   AND ISNULL(A.PROC_FLAG,'N') = 'N'
													   AND A.DIVISION         = W.SEGMENT1
													   AND A.OPERATION_GROUP  = W.SEGMENT2
													   AND A.PLANT_ID		  = W.SEGMENT4
													) COUNTS
													,W.SEGMENT1
											   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
											  WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
												AND ATTRIBUTE2 = 'Y'
												AND ACTIVE_FLAG = 'Y'
										   ) X
									 WHERE COUNTS = 0
									   AND SEGMENT1 IN (
														SELECT DISTINCT DIVISION
														  FROM [dbo].[SY_XIF_SCP_PROD_TARGET_R] A
														 WHERE A.PLAN_WEEK = @V_PLAN_WEEK
														   AND A.DIVISION  = @DIVISION
														   AND ISNULL(A.PROC_FLAG,'N') = 'N'
														   AND A.PLAN_TYPE IN ( 'PR','MA', 'FN')		--2018-06-11 PIYONG FN ADD -- 2023-02-28 kimcd 소형 PRE, 자동차 MAIN 수신으로 변경. PRE 추가
													   )
									)
					SET @CNT_CHK = 0
					IF @CNT_CHK = 0

						BEGIN                                                                                                                                                
		             
							IF @SHOP_GROUP  = 'E' -- 2019-10-23 kimcd add 공정군 구분		
								BEGIN
							------------------------------------------------------------------------------------------------------------------
							--2018-08-30 PIYONG ADD

								-- SCP Target 전극 정보를 수신하여 SDB에 적재
								WITH WW AS  (
    											SELECT W.ATTRIBUTE1
    													,W.SEGMENT4  PLANT
    													,W.SEGMENT3
    													,W.SEGMENT2  OPERATION_GROUP
    													,W.SEGMENT1  DIVISION
														,W.ATTRIBUTE5
														,CONVERT(NVARCHAR(8),(
																				SELECT MAX( WEEKSTART_DATE )
																					FROM [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK)
																					WHERE DATE_ID = DATEADD( WW, CONVERT(INT, W.ATTRIBUTE5), CONVERT( DATE, GETDATE(), 120) )
																				), 112) AS MAX_WEEK
														,MAX(W.ATTRIBUTE8) AS ATTRIBUTE8, MAX(W.ATTRIBUTE9) AS ATTRIBUTE9, MAX(W.ATTRIBUTE10) AS ATTRIBUTE10  -- 2023-04-06 kimcd 수신할 SCP Plan 유형 추가
    												FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
    												WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
    												AND W.ATTRIBUTE2 = 'Y'    
													GROUP BY W.ATTRIBUTE1
    													,W.SEGMENT4
    													,W.SEGMENT3
    													,W.SEGMENT2
    													,W.SEGMENT1
														,W.ATTRIBUTE5
    										)  -- 2020-12-17 kimcd lookup 일자 찾는 작업을 분리함.
								INSERT INTO [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H]
								(
									COMPANY_ID
									,DIVISION_ID
									,SITE_ID
									,PLANT_ID
									,OPERATION_ID
									,SHOP_GROUP_ID
									,SCP_PLAN_ID
									,SCP_TARGET_ID
									,ITEM_ID
									,MFG_WEEK
									,MFG_DATE
									,MFG_QTY
									,CHG_QTY
									,PRODUCTION_TYPE
									,SAMPLE_FROM_DATE
									,SAMPLE_TO_DATE
									,LINE_ID
									,PRIORITY
									,PERIOD_TYPE
									,CONFIRM_TYPE
									,DEMAND_TYPE
									,MARKET
									,INSERT_ID
									,INSERT_TIME
									,UPDATE_ID
									,UPDATE_TIME
								)
								SELECT COMPANY_ID
									   ,DIVISION
									   ,SITE_ID
									   ,PLANT_ID					
									   ,A.OPERATION_ID
									   ,SHOP_GROUP_ID                           
									   ,@V_SCP_PLAN_ID	AS SCP_PLAN_ID
									   ,A.DIVISION+'^'+A.SITE_CODE+'^'+MFG_WEEK+'^'+ITEM_ID+'^'+LINE_ID+'^'+OPERATION_ID+'^'+PRODUCTION_TYPE+'^'+MARKET AS SCP_TARGET_ID
									   -- 2019-11-26 kimcd Target ID를 일자에서 주로 변경 ,A.DIVISION+'^'+A.SITE_CODE+'^'+YYYYMMDD+'^'+ITEM_ID+'^'+LINE_ID+'^'+OPERATION_ID+'^'+PRODUCTION_TYPE+'^'+MARKET AS SCP_TARGET_ID
									   ,ITEM_ID
									   ,MFG_WEEK
									   ,MIN(YYYYMMDD)   AS YYYYMMDD -- 2019-11-26 kimcd 일자 group by 조건에서 제외 주 기준으로 정보 형성
									   ,SUM(MFG_QTY)	AS MFG_QTY
									   ,NULL            AS CHG_QTY                                                                                                             
									   ,PRODUCTION_TYPE                                                                                                     
									   ,NULL            AS SAMPLE_FROM_DATE                                                                                                    
									   ,NULL            AS SAMPLE_TO_DATE    
									   ,LINE_ID                                                                                                             
									   ,MAX(PRIORITY )  AS PRIORITY
									   ,NULL	        AS PERIOD_TYPE                                                                                                         
									   ,NULL            AS CONFIRM_TYPE                                                                                                        
									   ,NULL            AS DEMAND_TYPE
									   ,MARKET
									   ,'PR_XIF_SCP_PRODTARGET_R' AS INSERT_ID                                                                                                   
									   ,GETDATE() AS INSERT_TIME                                                                                                         
									   ,'PR_XIF_SCP_PRODTARGET_R' AS UPDATE_ID                                                                                                   
									   ,GETDATE() AS UPDATE_TIME    
								  FROM (		                                                                                                                                                 
										SELECT COMPANY_ID
											   ,DIVISION
											   ,SITE_ID                                                                                                                        
											   ,PLANT_ID
											   ,SITE_CODE
											   ,OPERATION_ID
											   ,SHOP_GROUP_ID
											   ,ITEM_ID
											   ,MFG_WEEK
											   ,YYYYMMDD
											   ,MFG_QTY
											   ,PRODUCTION_TYPE
											   ,LINE_ID
											   ,PRIORITY
											   ,CASE WHEN SITE_ID = 'A002'  THEN 
														ISNULL( ( SELECT MMM.DEFAULT_MARKET 
																	FROM SCM_MODEL_MARKET_M  MMM  WITH(NOLOCK)
																   WHERE MMM.COMPANY_ID  = AA.COMPANY_ID
																	 AND MMM.DIVISION_ID = AA.DIVISION
																	 AND MMM.SITE_ID     = AA.SITE_ID
																	 AND MMM.ITEM_ID     = AA.ITEM_ID
																	 AND MMM.PRODUCTION_TYPE = AA.PRODUCTION_TYPE		--2018-09-17 PIYONG 조건 추가
																	 AND ISNULL(MMM.ACTIVE_FLAG,'N') = 'Y'
																),  'E' --CASE WHEN AA.MARKET = '-' THEN 'D' ELSE AA.MARKET END	-- 2018-10-10 PIYONG  CASE WHEN AA.MARKET = '-' THEN 'D' ELSE AA.MARKET END -> 'E'
															  )
													 ELSE
														CASE WHEN AA.MARKET = '-' THEN 'D' ELSE AA.MARKET END
													 END																		AS MARKET
										  FROM (									
												SELECT P.COMPANY_ID
													   ,B.SEGMENT3 AS DIVISION
													   ,P.SITE_ID                                                                                                                        
													   ,A.PLANT_ID					AS PLANT_ID
													   ,A.SITE_CODE
													   ,A.OPERATION_ID
													   ,A.OPERATION_GROUP			AS SHOP_GROUP_ID
													   ,ITEM_ID
													   ,( SELECT TOP 1 WEEK
															FROM [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK)
															WHERE DATE_ID = CONVERT( DATETIME, A.PROD_WEEK, 112)	) AS MFG_WEEK
													   ,A.YYYYMMDD
													   ,PROD_QTY        AS MFG_QTY
													   /*	--2019-06-26 PIYONG DEL
													   ,CASE WHEN ( SELECT MAX(PJT_PROGRESS_STEP)
																	  FROM [FP_PLM_PJT_SCHEDULE_R] PS WITH(NOLOCK)
																	 WHERE PS.[MODEL_NAME] IN  (SELECT CE.[APPLIED_MODEL]										--2019-06-21 PIYONG CHANGE [MODEL_ID] -> [APPLIED_MODEL]
																								  FROM [SCM_ITEM_M]  CE WITH(NOLOCK)							--2019-06-21 PIYONG CHANGE [SCM_MODEL_COMP_EFFECTIVE_DATE] -> [SCM_ITEM_M]
																								 WHERE CE.[ITEM_ID] = A.ITEM_ID									--2019-06-21 PIYONG CHANGE [[CHILD_ITEM_ID]] -> [ITEM_ID]
																								)
																	   AND PS.DIVISION_ID = B.SEGMENT3
																	   AND PS.PJT_STATUS != 'Drop'										) IS NOT NULL THEN
															--	CASE WHEN B.SEGMENT3 = '40' THEN'DEVELOP' ELSE 'D-SAMPLE' END									--2018-11-12 PIYONG DEL
																	CASE ( SELECT MAX(PJT_STATUS)
																			 FROM [FP_PLM_PJT_SCHEDULE_R] PS WITH(NOLOCK)
																			WHERE PS.[MODEL_NAME] IN  (SELECT CE.[APPLIED_MODEL]
																										 FROM [SCM_ITEM_M]  CE WITH(NOLOCK)
																										WHERE CE.[ITEM_ID] = A.ITEM_ID
																										)
																			  AND PS.DIVISION_ID = B.SEGMENT3
																			  AND PS.PJT_STATUS != 'Drop'	) WHEN 'Complete' THEN
																													'MASS'
																											  ELSE
																												CASE ( SELECT MAX(PJT_PROGRESS_STEP)
																														 FROM [FP_PLM_PJT_SCHEDULE_R] PS WITH(NOLOCK)
																														WHERE PS.[MODEL_NAME] IN (SELECT CE.[APPLIED_MODEL]
																																					FROM [SCM_ITEM_M]  CE WITH(NOLOCK)
																																				   WHERE CE.[ITEM_ID] = A.ITEM_ID
																																				 )
																														  AND PS.DIVISION_ID = B.SEGMENT3
																														  AND PS.PJT_STATUS != 'Drop'	) WHEN 'PV' THEN
																																							CASE WHEN B.SEGMENT3 = '81' THEN
																																									'SPECIAL'
																																								 ELSE
																																									'D-SAMPLE'
																																								 END
																																						  ELSE
																																							'D-SAMPLE'
																																						  END
																											  END
															 ELSE 'MASS' END
														  														AS PRODUCTION_TYPE
														*/
														------------------------------------------------------------------------------------------------------------
														--2019-06-26 PIYONG ADD
														,ISNULL( (
																	SELECT CASE WHEN PRODUCTION_TYPE ='SPECIAL' THEN		-- 2019-08-07 PIYONG ADD 정인천책임 요청으로 오창만 PV일때 SPECIAL 생성--2020-01-14 빈강 추가 --2020-03-11 장현석 책임 요청 SPECIAL 만 적용
																	            -- 2019-11-27 kimcd  1=2 AND 조건 추가 무조건 개발 유형 값 사용	--2020-01-14 PIYONG DEL
																					--CASE WHEN A.PLANT_ID IN ( 'A041', 'G632' ) THEN
																					CASE WHEN A.PLANT_ID IN ( 'HQ07', 'G632' ) THEN

																							'SPECIAL'
																						 ELSE
																							'D-SAMPLE'
																						 END
																				ELSE
																					PRODUCTION_TYPE
																				END AS PRODUCTION_TYPE
																	  FROM [FP_PLM_PJT_MODEL_MASTER] PS WITH(NOLOCK)
																	 WHERE PS.MODEL_ID IN (
																							SELECT CE.[APPLIED_MODEL]
																							  FROM [SCM_ITEM_M]  CE WITH(NOLOCK)
																							 WHERE CE.[ITEM_ID] = A.ITEM_ID
																						  )
																	   AND PS.DIVISION_ID = B.SEGMENT3
																	   AND ( PS.PJT_STATUS_ID IS NULL OR PS.PJT_STATUS_ID NOT IN ( 'Drop'	,'Holding' ,'Planning Holding' )  ) )	--2020-03-11 PIYONG IS NULL 조건 ADD
																	, ISNULL( ( SELECT TOP 1 W.ATTRIBUTE2
																				FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
																				WHERE  W.LOOKUP_TYPE_CODE = 'SCP_DEMAND_TYPE_MAPPING'
																				AND    W.ACTIVE_FLAG      = 'Y'
																				AND    W.SEGMENT1         = A.ORDER_TYPE
																				AND    W.SEGMENT2         = A.PLANT_ID)
																				, 'MASS') )		AS PRODUCTION_TYPE -- 2019-11-27 kimcd order type을 SCP 기준으로 우선 적용
														--2019-06-26 PIYONG ADD END
														------------------------------------------------------------------------------------------------------------
														,PRODUCTION_LINE AS LINE_ID                                                                                                             
														,PRIORITY                                                                                                             
														,A.MARKET
												   FROM [dbo].[SY_XIF_SCP_PROD_TARGET_R] A WITH(INDEX(IDX01_XIF_SCP_PROD_TARGET_R)) -- 2019-10-03 kimcd index hint 추가
														,WW  B -- 2020-12-17 kimcd lookup을 with 절로 분리
	/*													--2019-06-21 PIYONG  DEL
														,(
														  SELECT SEGMENT1					-- 2019-03-12 PIYONG CHANGE * -> SEGMENT1, SEGMENT2, ATTRIBUTE2
																 , SEGMENT2
																 , ATTRIBUTE2
															FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
														   WHERE W.LOOKUP_TYPE_CODE = 'SCP_DEMAND_TYPE_MAPPING'
															 AND ACTIVE_FLAG = 'Y'
															 AND ATTRIBUTE2 IS NOT NULL		-- 2019-03-12 PIYONG ADD
														) C
	*/
														,[SCM_PLANT_M] P WITH (NOLOCK)  -- 2019-10-23 kimcd nolock 추가
												  WHERE A.PLAN_WEEK = @V_PLAN_WEEK
													AND A.DIVISION  = @DIVISION
													AND A.OPERATION_GROUP = 'E'
													--AND A.PLAN_TYPE IN ( 'MA', 'FN')
													AND A.PLAN_TYPE IN ( B.ATTRIBUTE8, B.ATTRIBUTE9, B.ATTRIBUTE10 )  -- 2023-04-06 kimcd 수신할 SCP Plan 유형 추가
													AND ISNULL(A.PROC_FLAG,'N') = 'N'
													AND A.OPERATION_GROUP  = B.OPERATION_GROUP 
													AND A.PLANT_ID		   = B.PLANT 
													AND A.DIVISION         = B.DIVISION
													------------------------------------------------------------------------------------------------------------------------------------------------
													-- 2020-02-24 PIYONG ADD
													AND A.PROD_WEEK < B.MAX_WEEK -- 2020-12-17 kimcd with절로 조건을 빼서 일자 범위 조건 설정
													-- 2020-02-24 PIYONG ADD END
													------------------------------------------------------------------------------------------------------------------------------------------------
	--												AND A.ORDER_TYPE	   = C.SEGMENT1					--2019-06-21 PIYONG  DEL
	--												AND A.PLANT_ID		   = C.SEGMENT2					--2019-06-21 PIYONG  DEL
													AND A.ATTR_01		   = P.DIVISION_ID
													AND A.PLANT_ID		   = P.PLANT_ID
													AND EXISTS (
																SELECT TOP 1 1 -- 2019-10-23 kimcd TOP 1 추가
																FROM   SCM_OPERATION_M O WITH(NOLOCK)
																WHERE  O.COMPANY_ID   = P.COMPANY_ID
																AND    O.DIVISION_ID  = P.DIVISION_ID
																AND    O.SITE_ID      = P.SITE_ID
																AND    O.OPERATION_ID = A.OPERATION_ID
																AND    O.ACTIVE_FLAG  = 'Y'
																AND    O.OPERATION_ID NOT LIKE 'F%'
															   )
											) AA
									   )A
								 GROUP BY COMPANY_ID
									   ,DIVISION
									   ,SITE_ID
									   ,PLANT_ID
									   ,SITE_CODE
									   ,OPERATION_ID
									   ,SHOP_GROUP_ID
									   ,ITEM_ID
									   ,MFG_WEEK
									   -- ,YYYYMMDD 2019-11-26 kimcd group by 조건에서 일자 제거 주 기준으로 정보 형성
									   ,PRODUCTION_TYPE
									   ,LINE_ID
									   ,MARKET

								--2018-08-30 PIYONG ADD
								------------------------------------------------------------------------------------------------------------------
								;
								SET @ROWCOUNT1 = @@ROWCOUNT
							END;
						ELSE --  @SHOP_GROUP E가 아닌 경우 -- 2019-10-23 kimcd add 공정군 구분
							BEGIN
								-- SCP Target 전극 제외한 정보를 수신하여 SDB에 적재
								WITH WW AS  (
    											SELECT W.ATTRIBUTE1
    													,W.SEGMENT4  PLANT
    													,W.SEGMENT3
    													,W.SEGMENT2  OPERATION_GROUP
    													,W.SEGMENT1  DIVISION
														,W.ATTRIBUTE5
														,CONVERT(NVARCHAR(8),(
																				SELECT MAX( WEEKSTART_DATE )
																					FROM [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK)
																					WHERE DATE_ID = DATEADD( WW, CONVERT(INT, W.ATTRIBUTE5), CONVERT( DATE, GETDATE(), 120) )
																				), 112) AS MAX_WEEK
														,MAX(W.ATTRIBUTE8) AS ATTRIBUTE8, MAX(W.ATTRIBUTE9) AS ATTRIBUTE9, MAX(W.ATTRIBUTE10) AS ATTRIBUTE10  -- 2023-04-06 kimcd 수신할 SCP Plan 유형 추가
    												FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
    												WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
    												AND W.ATTRIBUTE2 = 'Y'    
													GROUP BY W.ATTRIBUTE1
    													,W.SEGMENT4
    													,W.SEGMENT3
    													,W.SEGMENT2
    													,W.SEGMENT1
														,W.ATTRIBUTE5
    										)  -- 2020-12-17 kimcd lookup 찾는 조건을 with 절로 뺌
								INSERT INTO [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H]
								(
									COMPANY_ID
									,DIVISION_ID
									,SITE_ID
									,PLANT_ID
									,OPERATION_ID
									,SHOP_GROUP_ID
									,SCP_PLAN_ID
									,SCP_TARGET_ID
									,ITEM_ID
									,MFG_WEEK
									,MFG_DATE
									,MFG_QTY
									,CHG_QTY
									,PRODUCTION_TYPE
									,SAMPLE_FROM_DATE
									,SAMPLE_TO_DATE
									,LINE_ID
									,PRIORITY
									,PERIOD_TYPE
									,CONFIRM_TYPE
									,DEMAND_TYPE
									,MARKET
									,INSERT_ID
									,INSERT_TIME
									,UPDATE_ID
									,UPDATE_TIME
								)
								--  2018-06-11  GROUP BY로 한번더 조회
								SELECT COMPANY_ID
									   ,DIVISION
									   ,SITE_ID
									   ,PLANT_ID					
									   ,A.OPERATION_ID
									   ,SHOP_GROUP_ID                           
									   ,@V_SCP_PLAN_ID	AS SCP_PLAN_ID
									   ,A.DIVISION+'^'+A.SITE_CODE+'^'+ISNULL(YYYYMMDD,MFG_WEEK)+'^'+ITEM_ID+'^'+LINE_ID+'^'+OPERATION_ID+'^'+PRODUCTION_TYPE+'^'+MARKET AS SCP_TARGET_ID	--2018-11-27 PIYONG 수정 MG_WEEK ->ISNULL(YYYYMMDD,MFG_WEEK)
									   ,ITEM_ID
									   ,MFG_WEEK
									   ,YYYYMMDD
									   ,SUM(MFG_QTY)	AS MFG_QTY
									   ,NULL            AS CHG_QTY                                                                                                             
									   ,PRODUCTION_TYPE                                                                                                     
									   ,NULL            AS SAMPLE_FROM_DATE                                                                                                    
									   ,NULL            AS SAMPLE_TO_DATE    
									   ,LINE_ID                                                                                                             
									   ,MAX(PRIORITY )  AS PRIORITY
									   ,NULL	        AS PERIOD_TYPE                                                                                                         
									   ,NULL            AS CONFIRM_TYPE                                                                                                        
									   ,NULL            AS DEMAND_TYPE
									   ,MARKET
									   ,'PR_XIF_SCP_PRODTARGET_R' AS INSERT_ID                                                                                                   
									   ,GETDATE() AS INSERT_TIME                                                                                                         
									   ,'PR_XIF_SCP_PRODTARGET_R' AS UPDATE_ID                                                                                                   
									   ,GETDATE() AS UPDATE_TIME    
								  FROM (
										SELECT COMPANY_ID
												,DIVISION
												,SITE_ID                                                                                                                        
												,PLANT_ID
												,SITE_CODE
												,OPERATION_ID
												,SHOP_GROUP_ID
												,ITEM_ID
												,MFG_WEEK
												,YYYYMMDD
												,MFG_QTY
												,PRODUCTION_TYPE
												,LINE_ID
												,PRIORITY                                                                                                             
												,CASE WHEN SITE_ID = 'A002'  THEN 
														ISNULL( ( SELECT MMM.DEFAULT_MARKET 
																	FROM SCM_MODEL_MARKET_M  MMM  WITH(NOLOCK)
																	WHERE MMM.COMPANY_ID  = AA.COMPANY_ID
																		AND MMM.DIVISION_ID = AA.DIVISION
																		AND MMM.SITE_ID     = AA.SITE_ID
																		AND MMM.ITEM_ID     = AA.ITEM_ID
																		AND MMM.PRODUCTION_TYPE = AA.PRODUCTION_TYPE
																		AND ISNULL(MMM.ACTIVE_FLAG,'N') = 'Y' -- 2018-01-04 kimcd 조건 추가
																	),  'E' --CASE WHEN AA.MARKET = '-' THEN 'D' ELSE AA.MARKET END	-- 2018-10-10 PIYONG  CASE WHEN AA.MARKET = '-' THEN 'D' ELSE AA.MARKET END -> 'E'
																)
													  ELSE
														CASE WHEN MARKET = '-' THEN 'D' ELSE MARKET END
													  END																				  AS MARKET
										  FROM (
													SELECT P.COMPANY_ID
															,B.SEGMENT3 AS DIVISION					-- 2018-08-16 PIYONG CHANGE A.DIVISION -> B.SEGMENT3
															,P.SITE_ID                                                                                                                        
															,A.PLANT_ID					AS PLANT_ID
															,A.SITE_CODE
															,CASE WHEN A.OPERATION_ID = 'P5200' THEN
																(SELECT TOP 1 I.FLOW_ID
																 FROM   SCM_ITEM_M I (NOLOCK)
																 WHERE  I.COMPANY_ID  = P.COMPANY_ID
																 AND    I.SITE_ID     = P.SITE_ID
																 AND    I.DIVISION_ID = P.DIVISION_ID
																 AND    I.ITEM_ID     = A.ATTR_02)
															 ELSE A.OPERATION_ID END   AS OPERATION_ID -- 2021-11-19 kimcd P5200 품목의 제품의 공정으로 변경
															,A.OPERATION_GROUP			AS SHOP_GROUP_ID
												--		   ,@V_SCP_PLAN_ID				AS SCP_PLAN_ID
												--		   ,TARGET_ID					AS SCP_TARGET_ID
															,CASE WHEN A.OPERATION_ID = 'P5200' THEN A.ATTR_02 ELSE A.ITEM_ID END   AS ITEM_ID -- 2021-11-19 kimcd P5200 품목을 제품으로 전환
															,( SELECT TOP 1 WEEK
																 FROM [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK)					-- TH_UIS_CAL 테이블에서 SCM_SYS_CALENDAR_M 테이블로 변경
																WHERE DATE_ID = CONVERT( DATETIME, A.PROD_WEEK, 112)	) AS MFG_WEEK
															-----------------------------------------------------------------------------------------------------------------------------------------
															-- 2018-11-27 PILOT LINE 일자로 생성
															,CASE WHEN PRODUCTION_LINE IN (
																							SELECT SEGMENT2
																							  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
																							 WHERE LOOKUP_TYPE_CODE = 'PILOT_LINE'
																							   AND ISNULL(ATTRIBUTE2, 'N') = 'Y'
																							   AND ACTIVE_FLAG = 'Y'
																							   AND A.OPERATION_ID = SEGMENT3
																							) THEN
																	A.YYYYMMDD
																END AS YYYYMMDD
															-- 2018-11-27 PILOT LINE 일자로 생성 끝
															-----------------------------------------------------------------------------------------------------------------------------------------
															,CASE WHEN A.OPERATION_ID = 'P5200' THEN 
															    ( A.PROD_QTY / (SELECT TOP 1 BOM.CHILD_QTY/BOM.PARENT_QTY
																				FROM   SCM_BOM_M BOM (NOLOCK)
																				WHERE  BOM.COMPANY_ID     = P.COMPANY_ID
																				AND    BOM.DIVISION_ID    = P.DIVISION_ID
																				AND    BOM.SITE_ID        = P.SITE_ID
																				AND    BOM.PLANT_ID       = P.PLANT_ID
																				AND    BOM.PARENT_ITEM_ID = A.ATTR_02 -- 상위 품목
																				AND    BOM.CHILD_ITEM_ID  = A.ITEM_ID
																				AND    BOM.EFF_START_DATE <= A.YYYYMMDD
																				AND    BOM.EFF_END_DATE   >  A.YYYYMMDD ) )
															 ELSE PROD_QTY  END      AS MFG_QTY -- 2021-11-19 kimcd P5200 품목의 제품의 대당 소요량으로 변경                                                                                                         
												--		   ,NULL            AS CHG_QTY
												--		   ,C.ATTRIBUTE2	AS PRODUCTION_TYPE				--2018-12-10 PIYONG DEL
														   /*
															 CASE WHEN A.OPERATION_GROUP = 'P' THEN			--2018-12-17 PIYONG ADD PACK은 개발단계 미 적용
												--					C.ATTRIBUTE2
																	------------------------------------------------------------------------------------------------------------
																	--2019-08-19 PIYONG ADD
																	ISNULL( (
																			SELECT CASE WHEN PJT_PROGRESS_STEP_ID = 'PV' THEN		-- 오창만 PV일때 SPECIAL 생성
																							CASE WHEN A.PLANT_ID IN ( 'A040', 'A050' ) THEN
																									PRODUCTION_TYPE
																								 ELSE
																									'D-SAMPLE'
																								 END
																						ELSE
																							PRODUCTION_TYPE
																						END AS PRODUCTION_TYPE
																			  FROM [FP_PLM_PJT_MODEL_MASTER] PS WITH(NOLOCK)
																			 WHERE PS.MODEL_ID  = A.ITEM_ID
																			   AND PS.DIVISION_ID = B.SEGMENT3
																			   AND PS.PJT_STATUS_ID NOT IN ( 'Drop'	,'Holding' ,'Planning Holding' ) ), 'MASS')
																	--2019-08-19 PIYONG ADD END
																	------------------------------------------------------------------------------------------------------------
																 ELSE
																 /*
																	-- 2019-09-26 PIYON DEL
																	CASE WHEN ( SELECT MAX(PJT_PROGRESS_STEP)
																				  FROM [FP_PLM_PJT_SCHEDULE_R] PS WITH(NOLOCK)
																				 WHERE PS.[MODEL_NAME] = A.ITEM_ID
																				   AND PS.DIVISION_ID = B.DIVISION
																				   AND PS.PJT_STATUS != 'Drop'															--2019-04-19 PIYONG ADD
																																					) IS NULL THEN
																				'MASS'
																		  WHEN ( SELECT MAX(PJT_PROGRESS_STEP)
																				   FROM [FP_PLM_PJT_SCHEDULE_R] PS WITH(NOLOCK)
																				  WHERE PS.[MODEL_NAME] = A.ITEM_ID
																					AND PS.DIVISION_ID = B.DIVISION
																					AND PS.PJT_STATUS != 'Drop'															--2019-04-19 PIYONG ADD
																																							) = 'PV' AND B.PLANT IN ( 'A040' ) THEN
																						'SPECIAL'
																		   ELSE
																				'D-SAMPLE'
																			END
																	*/
																	------------------------------------------------------------------------------------------------------------
																	-- 2019-09-26 PIYON ADD
																	ISNULL( (
																			SELECT CASE WHEN PJT_PROGRESS_STEP_ID = 'PV' THEN		-- 오창만 PV일때 SPECIAL 생성
																							CASE WHEN A.PLANT_ID IN ( 'A040', 'A050') THEN
																									'SPECIAL'
																								 ELSE
																									'D-SAMPLE'
																								 END
																						ELSE
																							PRODUCTION_TYPE
																						END AS PRODUCTION_TYPE
																			  FROM [FP_PLM_PJT_MODEL_MASTER] PS WITH(NOLOCK)
																			 WHERE PS.MODEL_ID  = A.ITEM_ID
																			   AND PS.DIVISION_ID = B.SEGMENT3
																			   AND PS.PJT_STATUS_ID NOT IN ( 'Drop'	,'Holding' ,'Planning Holding' ) ), 'MASS')
																	-- 2019-09-26 PIYON ADD END
																	------------------------------------------------------------------------------------------------------------
																
																 END
														*/ ,ISNULL( (
																		SELECT CASE WHEN PRODUCTION_TYPE = 'SPECIAL' THEN		-- 2019-10-15 PIYONG CHANGE 오창이 아닌 PV일때 D-SAMPLE 생성 --2020-01-14 빈강 추가 --2020-03-11 PIYONG 장현석 책임 요청 SPECIAL 만 적용
																		            -- 2019-11-27 kimcd  1=2 AND 조건 추가 무조건 개발 유형 값 사용	--2020-01-14 PIYONG DEL
																						--CASE WHEN A.PLANT_ID IN ( 'A040', 'A050', 'G631', 'G634') THEN
																						CASE WHEN A.PLANT_ID IN ( 'HQ07', 'HQ08', 'G631', 'G634') THEN
																						
																								'SPECIAL'
																							 ELSE
																								'D-SAMPLE'
																							 END
																					ELSE
																						PRODUCTION_TYPE
																					END AS PRODUCTION_TYPE
																		  FROM [FP_PLM_PJT_MODEL_MASTER] PS WITH(NOLOCK)
																		 WHERE PS.MODEL_ID  = A.ITEM_ID
																		   AND PS.DIVISION_ID = B.SEGMENT3
																		   AND ( PS.PJT_STATUS_ID IS NULL OR PS.PJT_STATUS_ID NOT IN ( 'Drop'	,'Holding' ,'Planning Holding' ) ) )	--2020-03-11 PIYONG IS NULL 조건 ADD
																	,     ISNULL((SELECT TOP 1 W.ATTRIBUTE2
																		          FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
																				  WHERE  W.LOOKUP_TYPE_CODE = 'SCP_DEMAND_TYPE_MAPPING'
																				  AND    W.ACTIVE_FLAG      = 'Y'
																				  AND    W.SEGMENT1         = A.ORDER_TYPE
																				  AND    W.SEGMENT2         = A.PLANT_ID)
																				, 'MASS') )		AS PRODUCTION_TYPE -- 2019-11-27 kimcd order type을 SCP 기준으로 우선 적용
												--		   ,NULL            AS SAMPLE_FROM_DATE                                                                                                    
												--		   ,NULL            AS SAMPLE_TO_DATE                                                                                                      
															,PRODUCTION_LINE AS LINE_ID                                                                                                             
															,PRIORITY                                                                                                             
												--		   ,NULL	        AS PERIOD_TYPE                                                                                                         
												--		   ,NULL            AS CONFIRM_TYPE                                                                                                        
												--		   ,NULL            AS DEMAND_TYPE
															,A.MARKET
													  FROM [dbo].[SY_XIF_SCP_PROD_TARGET_R] A 
														   ,WW B -- 2020-12-17 kimcd lookup 찾는 문장을 with절로 뺌
															/*
															--2019-08-19 PIYONG DEL 정인천책임 요청으로 기준테이블 변경
															,(SELECT SEGMENT1					-- 2019-03-12 PIYONG CHANGE * -> SEGMENT1, SEGMENT2, ATTRIBUTE2
																	 , SEGMENT2
																	 , ATTRIBUTE2
																FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
															   WHERE W.LOOKUP_TYPE_CODE = 'SCP_DEMAND_TYPE_MAPPING'
																 AND ACTIVE_FLAG = 'Y'
																 AND ATTRIBUTE2 IS NOT NULL		-- 2019-03-12 PIYONG ADD
															) C
															*/
															,[SCM_PLANT_M] P
													 WHERE A.PLAN_WEEK = @V_PLAN_WEEK
													   AND A.DIVISION  = @DIVISION
													   AND A.OPERATION_GROUP != 'E'				-- 2018-08-30 PIYONG ADD
													   --AND ( ( A.PLAN_TYPE = 'FN' AND @DIVISION = '81_UC' ) OR ( A.PLAN_TYPE = 'MA' AND @DIVISION IN ('81','82') ) OR ( A.PLAN_TYPE = 'PR' AND @DIVISION = '40' ) )	-- 2021-11-19 kimcd 81 Division은 FN 수신
													   AND A.PLAN_TYPE IN  ( B.ATTRIBUTE8, B.ATTRIBUTE9, B.ATTRIBUTE10 )  -- 2023-04-06 kimcd 수신할 SCP Plan 유형 추가
													   -- 2023-02-28 kimcd 소형 PRE, 자동차 MAIN 수신으로 변경
													   -- AND A.PLAN_TYPE = 'MA'					--2018-06-11 PIYONG FN ADD --2019-04-19 PIYONG CHANGE -- 2019-07-15 PIYONG  MA만 받도록 변경
													   ------------------------------------------------------------------------------------------------------------------------------------------------
													   -- 2020-02-24 PIYONG ADD
													   AND A.PROD_WEEK < B.MAX_WEEK -- 2020-12-17 kimcd lookup, 일자 조회하는 과정을 with 절로 뺌
														-- 2020-02-24 PIYONG ADD END
														------------------------------------------------------------------------------------------------------------------------------------------------
													   AND ISNULL(A.PROC_FLAG,'N')	= 'N'
													   AND A.OPERATION_GROUP		= B.OPERATION_GROUP 
													   AND A.PLANT_ID		= B.PLANT 
													   AND A.DIVISION		= B.DIVISION
												--	   AND A.ORDER_TYPE		= C.SEGMENT1		--2019-08-19 PIYONG DEL 정인천책임 요청으로 기준테이블 변경
												--	   AND A.PLANT_ID		= C.SEGMENT2		--2019-08-19 PIYONG DEL 정인천책임 요청으로 기준테이블 변경
													   AND A.ATTR_01		= P.DIVISION_ID		-- 2018-08-16 PIYONG ADD
													   AND A.PLANT_ID		= P.PLANT_ID
													   AND EXISTS (SELECT 1
																	FROM   SCM_OPERATION_M O WITH(NOLOCK)
																	WHERE  O.COMPANY_ID   = P.COMPANY_ID
																	AND    O.DIVISION_ID  = P.DIVISION_ID
																	AND    O.SITE_ID      = P.SITE_ID
																	AND    O.OPERATION_ID = A.OPERATION_ID
																	AND    O.ACTIVE_FLAG  = 'Y'
																	AND    O.OPERATION_ID NOT LIKE 'F%' )
											   ) AA
									   )A
								 --------------------------------------
								 --  2018-06-11  GROUP BY로 한번더 조회
								 GROUP BY COMPANY_ID
									   ,DIVISION
									   ,SITE_ID
									   ,PLANT_ID
									   ,SITE_CODE
									   ,OPERATION_ID
									   ,SHOP_GROUP_ID
									   ,ITEM_ID
									   ,MFG_WEEK
									   ,YYYYMMDD		-- 2018-11-27 PIYONG ADD
									   ,PRODUCTION_TYPE
									   ,LINE_ID
									   ,MARKET
								 --------------------------------------
								;              

								SET @ROWCOUNT = @@ROWCOUNT

							END;-- @SHOP_GROUP  -- 2019-10-23 kimcd add 공정군 구분

							--------------------------------------------------------------------------------------------------------------------------
							-- 신규로 생성되기전 변경이 있는 데이터에 PRODUCTION_TYPE, MARKET 값을 신규SCP_PLAN_ID에 적용 시작
							-- 매주 첫번째 물동 이면 SCM_MODEL_MARKET_M 기준으로 복사 로직 추가
							-------------------------------------------------------------------------------------------------------------------------
							-- 이번주 첫 물동 이후 들어온 수신된 MARKET 정보 변경						
							-- 2019-11-16 kimcd 전극도 TEST유지하기 위해 조립, Pack 위치에서 전체 위치로 한 단계 올림.
							/*-- 2021-08-12 로직 막음 시작
							DECLARE CUR_MARKET_U CURSOR FOR
								SELECT DISTINCT A.DIVISION_ID
									FROM FP_WEEKLY_DEMAND_PRODUCT_H A
									WHERE SCP_PLAN_ID = @V_SCP_PLAN_ID
									AND A.DIVISION_ID IN (	-- 2018-08-30 PIYONG CHANGE
															SELECT SEGMENT3
																FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
																WHERE LOOKUP_TYPE_CODE = 'SCP_PLANT'
																AND ATTRIBUTE2 = 'Y' 
																AND SEGMENT1 = @DIVISION
														)

									/* 2018-06-20 kimcd 주별 첫 수신 제외 조건 주석 처리
									AND NOT EXISTS ( SELECT 1
														FROM [dbo].[SY_XIF_SCP_PROD_TARGET_R] B WITH(NOLOCK)
														WHERE ISNULL(PROC_FLAG,'N') = 'N'
														AND B.DIVISION = A.DIVISION_ID
														AND B.PLAN_WEEK = SUBSTRING(@V_SCP_PLAN_ID, 1, 8)+'_001' ) */

							OPEN CUR_MARKET_U;
							FETCH NEXT FROM CUR_MARKET_U INTO @C_DIVISION
							;             

							WHILE (@@FETCH_STATUS = 0)
								BEGIN

									UPDATE A
										SET PRODUCTION_TYPE =   CASE WHEN A.DIVISION_ID = '40' THEN
										                            CASE WHEN A.[SHOP_GROUP_ID] = 'P' OR (A.[SHOP_GROUP_ID] = 'A' AND B.PRODUCTION_TYPE = 'TEST') THEN
																	    B.PRODUCTION_TYPE
																    ELSE A.PRODUCTION_TYPE END -- 2019-01-07 kimcd 조립 공정(A)인 경우 TEST 정보만 복사
																ELSE
																    CASE WHEN B.PRODUCTION_TYPE = 'TEST' THEN
																	    B.PRODUCTION_TYPE
																    ELSE A.PRODUCTION_TYPE END -- 2019-11-26 kimcd 소형의 경우 기존 로직 유지, 자동차는 TEST만 기존 Order Type 유지
																END
										--   ,MARKET = B.MARKET						-- 2018-10-11 PIYONG  DEL
										FROM FP_WEEKLY_DEMAND_PRODUCT_H A
											,(SELECT [COMPANY_ID]
													,H.[DIVISION_ID]
													,[SITE_ID]
													,[PLANT_ID]
													,H.[SHOP_GROUP_ID]
													-- 2018-06-29 kimcd 조건변경 추가 시작
													,[MFG_WEEK]
													,[ITEM_ID]
													,[LINE_ID]
													,[OPERATION_ID]
													-- 2018-06-29 kimcd 조건변경 추가 끝
										  		-- ,[SCP_TARGET_ID]  2018-06-29 kimcd 컬럼 제거
													,MAX(PRODUCTION_TYPE)   AS PRODUCTION_TYPE
													,MAX(MARKET)            AS MARKET
												FROM FP_WEEKLY_DEMAND_PRODUCT_H H
													INNER JOIN #BEFORE_SCP_PLAN_ID SP
															ON (
																	H.SCP_PLAN_ID = SP.SCP_PLAN_ID
																	AND H.DIVISION_ID = SP.DIVISION_ID
																	AND H.SHOP_GROUP_ID = SP.SHOP_GROUP_ID				--2018-08-30 PIYONG ADD
																)
												WHERE H.DIVISION_ID = @C_DIVISION
												-----------------------------------------------------------------------------------------------
								  				--2018-08-30 PIYONG ADD
												AND H.SHOP_GROUP_ID IN (
																		SELECT OPERATION_GROUP
																			FROM [dbo].[SY_XIF_SCP_PROD_TARGET_R]
																			WHERE PLAN_TYPE IN ('FN', 'MA') -- 2019-11-26 kimcd FN도 포함. 전극 계획위해 2019-07-15 PIYONG  MA만 받도록 변경
																			--( (PLAN_TYPE = 'FN' AND @DIVISION NOT IN ('81', '82') ) OR PLAN_TYPE = 'MA' ) --2019-04-19 PIYONG CHANG PLAN_TYPE IN ( 'MA', 'FN') -> ( (PLAN_TYPE = 'FN' AND DIVISION NOT IN ('81', '82')  ) OR PLAN_TYPE = 'MA' )
																			AND PLAN_WEEK = @V_SCP_PLAN_ID
																			AND DIVISION = @DIVISION
																			GROUP BY OPERATION_GROUP
																		)
												--2018-08-30 PIYONG ADD
												-----------------------------------------------------------------------------------------------
												-- 2018-06-29 kimcd 조건변경 추가 시작
												GROUP BY  [COMPANY_ID]
														,H.[DIVISION_ID]
														,[SITE_ID]
														,[PLANT_ID]
														,H.[SHOP_GROUP_ID]
														,[MFG_WEEK]
														,[ITEM_ID]
														,[LINE_ID]
														,[OPERATION_ID]
												-- 2018-06-29 kimcd GROUP BY 추가 끝
																										) B
										WHERE SCP_PLAN_ID = @V_SCP_PLAN_ID
											AND A.[COMPANY_ID] = B.[COMPANY_ID]
											AND A.[DIVISION_ID] = B.[DIVISION_ID]
											AND A.[SITE_ID] = B.[SITE_ID]
											AND A.[PLANT_ID] = B.[PLANT_ID]
											AND A.[SHOP_GROUP_ID] = B.[SHOP_GROUP_ID]
											-- 2018-06-29 kimcd 조건 변경 추가 시작
											AND A.[MFG_WEEK]     = B.[MFG_WEEK]
											AND A.[ITEM_ID]      = B.[ITEM_ID]
											AND A.[LINE_ID]      = B.[LINE_ID]
											AND A.[OPERATION_ID] = B.[OPERATION_ID]
											-- 2018-06-29 kimcd 조건 변경 추가 끝
											-- AND A.[SCP_TARGET_ID] = B.[SCP_TARGET_ID]  2018-06-29 kimcd 조건 제거
									
									FETCH NEXT FROM CUR_MARKET_U INTO @C_DIVISION
									;              

									END;

							CLOSE CUR_MARKET_U;
							DEALLOCATE CUR_MARKET_U;
							-- 2021-08-12 로직 막음 끝 */
							--------------------------------------------------------------------------------------------------------------------------
							-- 신규로 생성되기전 변경이 있는 데이터에 PRODUCTION_TYPE, MARKET 값을 신규SCP_PLAN_ID에 적용 끝
							--------------------------------------------------------------------------------------------------------------------------

							-- 2021-08-12 kimcd TEST 수요에 대해서 기존 주차 Demand를 당주로 복사하는 과정 시작
							-- 소형과 기존 물동 정보를 검토한 결과 기존 로직을 대체하면 부작용 예상됨
							-- 법인, 공정, 사업부별로 Option 적용하여 로직 수행하도록 보완함
							DECLARE @K_MFG_WEEK        NVARCHAR(6)
							DECLARE @X_COMPANY_ID      NVARCHAR(30)
							DECLARE @X_DIVISION_ID     NVARCHAR(30)
							DECLARE @X_SITE_ID         NVARCHAR(30)
							DECLARE @X_PLANT_ID        NVARCHAR(30)
							DECLARE @X_SHOP_GROUP_ID   NVARCHAR(1)
							DECLARE @X_SCP_TARGET_ID   NVARCHAR(150)
							DECLARE @X_MARKET          NVARCHAR(10)
							DECLARE @X_ITEM_ID         NVARCHAR(150)
							DECLARE @X_MFG_WEEK        NVARCHAR(10)
							DECLARE @X_MFG_QTY         NUMERIC(20,10)
							DECLARE @X_PRODUCTION_TYPE NVARCHAR(30)
							DECLARE @X_LINE_ID         NVARCHAR(30)
							DECLARE @X_PRIORITY        NVARCHAR(100)
							DECLARE @X_OPERATION_ID    NVARCHAR(30)
							DECLARE @X_MFG_DATE        NVARCHAR(8)
							DECLARE @T_SCP_TARGET_ID   NVARCHAR(150)
							DECLARE @T_MFG_QTY         NUMERIC(20,10)

							SELECT TOP 1 @K_MFG_WEEK =  WEEK FROM [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE DATE_ID = CONVERT( DATE, GETDATE())

							DECLARE CUR_TEST_DEMAND CURSOR FOR
								SELECT H.[COMPANY_ID]
									  ,H.[DIVISION_ID]
									  ,H.[SITE_ID]
									  ,H.[PLANT_ID]
									  ,H.[SHOP_GROUP_ID]
									  ,MAX(H.[SCP_TARGET_ID]) AS SCP_TARGET_ID
									  ,H.[MARKET]
									  ,H.[ITEM_ID]
									  ,H.[MFG_WEEK]
									  ,SUM(H.[MFG_QTY])       AS MFG_QTY
									  ,H.[PRODUCTION_TYPE]
									  ,H.[LINE_ID]
									  ,MAX(H.[PRIORITY])      AS PRIORITY
									  ,MAX(H.[OPERATION_ID])  AS OPERATION_ID
									  ,MAX(H.[MFG_DATE])      AS MFG_DATE
								FROM FP_WEEKLY_DEMAND_PRODUCT_H H
									INNER JOIN (   SELECT W.ATTRIBUTE1 AS COMPANY_ID
    													, W.SEGMENT4  AS PLANT_ID
    													, W.SEGMENT3  AS DIVISION_ID
    													, W.SEGMENT2  AS SHOP_GROUP_ID
    												FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
    												WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
    												AND   W.ATTRIBUTE2 = 'Y' -- SCP Target 형성
													AND   W.ATTRIBUTE6 = 'Y' -- TEST 유형 추가 형성
													GROUP BY W.ATTRIBUTE1
    														,W.SEGMENT4
    														,W.SEGMENT3
    														,W.SEGMENT2
    											)  W
									ON ( H.COMPANY_ID = W.COMPANY_ID
										AND H.PLANT_ID = W.PLANT_ID
										AND H.DIVISION_ID = W.DIVISION_ID
										AND H.SHOP_GROUP_ID = W.SHOP_GROUP_ID )
									INNER JOIN #BEFORE_SCP_PLAN_ID SP
									ON ( H.SCP_PLAN_ID = SP.SCP_PLAN_ID
										AND H.DIVISION_ID = SP.DIVISION_ID
										AND H.SHOP_GROUP_ID = SP.SHOP_GROUP_ID )
								WHERE H.DIVISION_ID IN ( SELECT SEGMENT3
														 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
														 WHERE  LOOKUP_TYPE_CODE = 'SCP_PLANT'
														 AND    ATTRIBUTE2 = 'Y' 
														 AND    SEGMENT1 = @DIVISION )
								AND H.SHOP_GROUP_ID IN ( SELECT OPERATION_GROUP
														 FROM   [dbo].[SY_XIF_SCP_PROD_TARGET_R]
													 	 -- WHERE  ( PLAN_TYPE = 'MA' OR OPERATION_GROUP = 'E' OR DIVISION = '81' ) -- 2021-11-19 kimcd 81 Division은 FN 수신
  													     WHERE 1 = 1
														 --		(   ( PLAN_TYPE = 'FN' AND @DIVISION = '81_UC' ) OR ( PLAN_TYPE = 'MA' AND @DIVISION IN ('81','82') ) 
														 --		OR ( PLAN_TYPE = 'PR' AND @DIVISION = '40' ) OR (OPERATION_GROUP = 'E' AND PLAN_TYPE IN ( 'MA', 'FN'))  )	
														 AND    PLAN_TYPE IN ( SELECT LV.ATTRIBUTE8
																			   FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] LV WITH(NOLOCK)
																			   WHERE  LV.LOOKUP_TYPE_CODE = 'SCP_PLANT'
																			   AND    LV.ATTRIBUTE2 = 'Y' 
																			   AND    LV.SEGMENT1 = @DIVISION
																			   UNION
																			   SELECT LV.ATTRIBUTE9
																			   FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] LV WITH(NOLOCK)
																			   WHERE  LV.LOOKUP_TYPE_CODE = 'SCP_PLANT'
																			   AND    LV.ATTRIBUTE2 = 'Y' 
																			   AND    LV.SEGMENT1 = @DIVISION
																			   UNION
																			   SELECT LV.ATTRIBUTE10
																			   FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] LV WITH(NOLOCK)
																			   WHERE  LV.LOOKUP_TYPE_CODE = 'SCP_PLANT'
																			   AND    LV.ATTRIBUTE2 = 'Y' 
																			   AND    LV.SEGMENT1 = @DIVISION
																			   ) -- 2023-04-06 kimcd 사업부별 plan type 별로 대상 제한
														 -- 2023-02-28 kimcd 소형 PRE, 자동차 MAIN 수신으로 변경
														 AND    PLAN_WEEK = @V_SCP_PLAN_ID
														 AND    DIVISION = @DIVISION
														 GROUP  BY OPERATION_GROUP )
								AND H.PRODUCTION_TYPE = 'TEST'
								AND H.MFG_WEEK       >= @K_MFG_WEEK
								AND NOT EXISTS (SELECT 1 
												FROM   FP_WEEKLY_DEMAND_PRODUCT_H C
												WHERE  C.SCP_PLAN_ID    = @V_SCP_PLAN_ID
												AND C.[COMPANY_ID]      = H.[COMPANY_ID]
												AND C.[DIVISION_ID]     = H.[DIVISION_ID]
												AND C.[SITE_ID]         = H.[SITE_ID]
												AND C.[PLANT_ID]        = H.[PLANT_ID]
												AND C.[SHOP_GROUP_ID]   = H.[SHOP_GROUP_ID]
												AND C.[MFG_WEEK]        = H.[MFG_WEEK]
												AND C.[ITEM_ID]         = H.[ITEM_ID]
												AND C.[LINE_ID]         = H.[LINE_ID]
												AND C.[PRODUCTION_TYPE] = 'TEST')
								GROUP BY H.[COMPANY_ID]
										,H.[DIVISION_ID]
										,H.[SITE_ID]
										,H.[PLANT_ID]
										,H.[SHOP_GROUP_ID]
										,H.[MARKET]
										,H.[MFG_WEEK]
										,H.[ITEM_ID]
										,H.[LINE_ID]
										,H.[PRODUCTION_TYPE]

							OPEN CUR_TEST_DEMAND;
							FETCH NEXT FROM CUR_TEST_DEMAND INTO @X_COMPANY_ID
							                                   , @X_DIVISION_ID
							                                   , @X_SITE_ID
							                                   , @X_PLANT_ID
							                                   , @X_SHOP_GROUP_ID
							                                   , @X_SCP_TARGET_ID
							                                   , @X_MARKET
							                                   , @X_ITEM_ID
							                                   , @X_MFG_WEEK
							                                   , @X_MFG_QTY
							                                   , @X_PRODUCTION_TYPE
							                                   , @X_LINE_ID
							                                   , @X_PRIORITY
							                                   , @X_OPERATION_ID
							                                   , @X_MFG_DATE

							WHILE (@@FETCH_STATUS = 0)
								BEGIN
									INSERT INTO [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H]
									(
										 COMPANY_ID
										,DIVISION_ID
										,SITE_ID
										,PLANT_ID
										,SHOP_GROUP_ID
										,SCP_PLAN_ID
										,SCP_TARGET_ID
										,MARKET
										,ITEM_ID
										,MFG_WEEK
										,MFG_QTY
										,PRODUCTION_TYPE
										,LINE_ID
										,PRIORITY
										,OPERATION_ID
										,MFG_DATE
										,INSERT_ID
										,INSERT_TIME
										,UPDATE_ID
										,UPDATE_TIME
									)
									VALUES( @X_COMPANY_ID
							              , @X_DIVISION_ID
							              , @X_SITE_ID
							              , @X_PLANT_ID
							              , @X_SHOP_GROUP_ID
										  , @V_SCP_PLAN_ID
							              , CASE WHEN RIGHT(@X_SCP_TARGET_ID,2) = '_C' THEN @X_SCP_TARGET_ID ELSE @X_SCP_TARGET_ID + '_C' END
							              , @X_MARKET
							              , @X_ITEM_ID
							              , @X_MFG_WEEK
							              , @X_MFG_QTY
							              , @X_PRODUCTION_TYPE
							              , @X_LINE_ID
							              , @X_PRIORITY
							              , @X_OPERATION_ID
							              , @X_MFG_DATE
									      , 'PR_XIF_SCP_PRODTARGET_R'
									      , GETDATE()
									      , 'PR_XIF_SCP_PRODTARGET_R'
									      , GETDATE()
									      );

									DECLARE CUR_WEEK_PLAN CURSOR FOR
										SELECT T.SCP_TARGET_ID
											  ,T.MFG_QTY
										FROM  [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H] T
										WHERE T.[SCP_PLAN_ID]   = @V_SCP_PLAN_ID
										AND T.[COMPANY_ID]      = @X_COMPANY_ID
										AND T.[DIVISION_ID]     = @X_DIVISION_ID
										AND T.[SITE_ID]         = @X_SITE_ID
										AND T.[PLANT_ID]        = @X_PLANT_ID
										AND T.[SHOP_GROUP_ID]   = @X_SHOP_GROUP_ID
										AND T.[MFG_WEEK]        = @X_MFG_WEEK
										AND T.[ITEM_ID]         = @X_ITEM_ID
										AND T.[LINE_ID]         = @X_LINE_ID
										AND T.[PRODUCTION_TYPE] != 'TEST'
										ORDER BY [PRODUCTION_TYPE]

									OPEN CUR_WEEK_PLAN
									FETCH NEXT FROM CUR_WEEK_PLAN INTO   @T_SCP_TARGET_ID
																		,@T_MFG_QTY
									WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
										BEGIN			
											IF @T_MFG_QTY >= @X_MFG_QTY
												BEGIN
													UPDATE [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H]
														SET MFG_QTY = @T_MFG_QTY - @X_MFG_QTY
															,UPDATE_ID = 'PR_XIF_SCP_PRODTARGET_R'
															,UPDATE_TIME =  GETDATE()
													WHERE [SCP_PLAN_ID]   = @V_SCP_PLAN_ID
													AND   [COMPANY_ID]    = @X_COMPANY_ID
													AND   [DIVISION_ID]   = @X_DIVISION_ID
													AND   [SITE_ID]       = @X_SITE_ID
													AND   [PLANT_ID]      = @X_PLANT_ID
													AND   [SHOP_GROUP_ID] = @X_SHOP_GROUP_ID
													AND   [MFG_WEEK]      = @X_MFG_WEEK
													AND   [ITEM_ID]       = @X_ITEM_ID
													AND   [LINE_ID]       = @X_LINE_ID
													AND   [SCP_TARGET_ID] = @T_SCP_TARGET_ID
													SET @X_MFG_QTY = 0;
													BREAK;
												END;
											ELSE
												BEGIN
													SET @X_MFG_QTY = @X_MFG_QTY - @T_MFG_QTY;
													UPDATE [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H]
														SET MFG_QTY = 0
															,UPDATE_ID = 'PR_XIF_SCP_PRODTARGET_R'
															,UPDATE_TIME =  GETDATE()
													WHERE [SCP_PLAN_ID]   = @V_SCP_PLAN_ID
													AND   [COMPANY_ID]    = @X_COMPANY_ID
													AND   [DIVISION_ID]   = @X_DIVISION_ID
													AND   [SITE_ID]       = @X_SITE_ID
													AND   [PLANT_ID]      = @X_PLANT_ID
													AND   [SHOP_GROUP_ID] = @X_SHOP_GROUP_ID
													AND   [MFG_WEEK]      = @X_MFG_WEEK
													AND   [ITEM_ID]       = @X_ITEM_ID
													AND   [LINE_ID]       = @X_LINE_ID
													AND   [SCP_TARGET_ID] = @T_SCP_TARGET_ID
												END;

											FETCH NEXT FROM CUR_WEEK_PLAN INTO   @T_SCP_TARGET_ID
																				,@T_MFG_QTY

										END  -- WHILE @@FETCH_STATUS = 0  CUR_WEEK_PLAN
				
									CLOSE CUR_WEEK_PLAN;
									DEALLOCATE CUR_WEEK_PLAN;   -- 메모리 해제
									
									
								FETCH NEXT FROM CUR_TEST_DEMAND INTO  @X_COMPANY_ID
																	, @X_DIVISION_ID
																	, @X_SITE_ID
																	, @X_PLANT_ID
																	, @X_SHOP_GROUP_ID
																	, @X_SCP_TARGET_ID
																	, @X_MARKET
																	, @X_ITEM_ID
																	, @X_MFG_WEEK
																	, @X_MFG_QTY
																	, @X_PRODUCTION_TYPE
																	, @X_LINE_ID
																	, @X_PRIORITY
																	, @X_OPERATION_ID
																	, @X_MFG_DATE

							END;   -- WHILE @@FETCH_STATUS = 0  CUR_TEST_DEMAND6

							CLOSE CUR_TEST_DEMAND;
							DEALLOCATE CUR_TEST_DEMAND;
							-- 2021-08-12 kimcd TEST 수요에 대해서 기존 주차 Demand를 당주로 복사하는 과정 끝



							-- 2022-12-26 leeseongmin SCP Target의 생산타입을 유지하는 로직 개선 (D-SAMPLE)
							-- 2022-12-26 leeseongmin D-SAMPLE 수요에 대해서 기존 주차 Demand를 당주로 복사하는 과정 시작
							DECLARE CUR_D_SAMPE_DEMAND CURSOR FOR
								SELECT H.[COMPANY_ID]
									  ,H.[DIVISION_ID]
									  ,H.[SITE_ID]
									  ,H.[PLANT_ID]
									  ,H.[SHOP_GROUP_ID]
									  ,MAX(H.[SCP_TARGET_ID]) AS SCP_TARGET_ID
									  ,H.[MARKET]
									  ,H.[ITEM_ID]
									  ,H.[MFG_WEEK]
									  ,SUM(H.[MFG_QTY])       AS MFG_QTY
									  ,H.[PRODUCTION_TYPE]
									  ,H.[LINE_ID]
									  ,MAX(H.[PRIORITY])      AS PRIORITY
									  ,MAX(H.[OPERATION_ID])  AS OPERATION_ID
									  ,MAX(H.[MFG_DATE])      AS MFG_DATE
								FROM FP_WEEKLY_DEMAND_PRODUCT_H H
									INNER JOIN (   SELECT W.ATTRIBUTE1 AS COMPANY_ID
    													, W.SEGMENT4  AS PLANT_ID
    													, W.SEGMENT3  AS DIVISION_ID
    													, W.SEGMENT2  AS SHOP_GROUP_ID
    												FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
    												WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
    												AND   W.ATTRIBUTE2 = 'Y' -- SCP Target 형성
													AND   W.ATTRIBUTE7 = 'Y' -- D-SAMPLE 유형 추가 형성
													GROUP BY W.ATTRIBUTE1
    														,W.SEGMENT4
    														,W.SEGMENT3
    														,W.SEGMENT2
    											)  W
									ON ( H.COMPANY_ID = W.COMPANY_ID
										AND H.PLANT_ID = W.PLANT_ID
										AND H.DIVISION_ID = W.DIVISION_ID
										AND H.SHOP_GROUP_ID = W.SHOP_GROUP_ID )
									INNER JOIN #BEFORE_SCP_PLAN_ID SP
									ON ( H.SCP_PLAN_ID = SP.SCP_PLAN_ID
										AND H.DIVISION_ID = SP.DIVISION_ID
										AND H.SHOP_GROUP_ID = SP.SHOP_GROUP_ID )
								WHERE H.DIVISION_ID IN ( SELECT SEGMENT3
														 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
														 WHERE  LOOKUP_TYPE_CODE = 'SCP_PLANT'
														 AND    ATTRIBUTE2 = 'Y' 
														 AND    SEGMENT1 = @DIVISION )
								AND H.SHOP_GROUP_ID IN ( SELECT OPERATION_GROUP
														 FROM   [dbo].[SY_XIF_SCP_PROD_TARGET_R]
													 	 -- WHERE  ( PLAN_TYPE = 'MA' OR OPERATION_GROUP = 'E' OR DIVISION = '81' )
  													     WHERE 1= 1
														 --(   ( PLAN_TYPE = 'FN' AND @DIVISION = '81_UC' ) OR ( PLAN_TYPE = 'MA' AND @DIVISION IN ('81','82') ) 
														 --		OR ( PLAN_TYPE = 'PR' AND @DIVISION = '40' ) OR (OPERATION_GROUP = 'E' AND PLAN_TYPE IN ( 'MA', 'FN'))  )	
														 -- 2023-02-28 kimcd 소형 PRE, 자동차 MAIN 수신으로 변경
														 AND    PLAN_TYPE IN ( SELECT LV.ATTRIBUTE8
																			   FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] LV WITH(NOLOCK)
																			   WHERE  LV.LOOKUP_TYPE_CODE = 'SCP_PLANT'
																			   AND    LV.ATTRIBUTE2 = 'Y' 
																			   AND    LV.SEGMENT1 = @DIVISION
																			   UNION
																			   SELECT LV.ATTRIBUTE9
																			   FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] LV WITH(NOLOCK)
																			   WHERE  LV.LOOKUP_TYPE_CODE = 'SCP_PLANT'
																			   AND    LV.ATTRIBUTE2 = 'Y' 
																			   AND    LV.SEGMENT1 = @DIVISION
																			   UNION
																			   SELECT LV.ATTRIBUTE10
																			   FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] LV WITH(NOLOCK)
																			   WHERE  LV.LOOKUP_TYPE_CODE = 'SCP_PLANT'
																			   AND    LV.ATTRIBUTE2 = 'Y' 
																			   AND    LV.SEGMENT1 = @DIVISION
																			   ) -- 2023-04-06 kimcd 사업부별 plan type 별로 대상 제한
														 AND    PLAN_WEEK = @V_SCP_PLAN_ID
														 AND    DIVISION = @DIVISION
														 GROUP  BY OPERATION_GROUP )
								AND H.PRODUCTION_TYPE = 'D-SAMPLE'
								AND H.MFG_WEEK       >= @K_MFG_WEEK
								AND NOT EXISTS (SELECT 1 
												FROM   FP_WEEKLY_DEMAND_PRODUCT_H C
												WHERE  C.SCP_PLAN_ID    = @V_SCP_PLAN_ID
												AND C.[COMPANY_ID]      = H.[COMPANY_ID]
												AND C.[DIVISION_ID]     = H.[DIVISION_ID]
												AND C.[SITE_ID]         = H.[SITE_ID]
												AND C.[PLANT_ID]        = H.[PLANT_ID]
												AND C.[SHOP_GROUP_ID]   = H.[SHOP_GROUP_ID]
												AND C.[MFG_WEEK]        = H.[MFG_WEEK]
												AND C.[ITEM_ID]         = H.[ITEM_ID]
												AND C.[LINE_ID]         = H.[LINE_ID]
												AND C.[PRODUCTION_TYPE] = 'D-SAMPLE')
								GROUP BY H.[COMPANY_ID]
										,H.[DIVISION_ID]
										,H.[SITE_ID]
										,H.[PLANT_ID]
										,H.[SHOP_GROUP_ID]
										,H.[MARKET]
										,H.[MFG_WEEK]
										,H.[ITEM_ID]
										,H.[LINE_ID]
										,H.[PRODUCTION_TYPE]

							OPEN CUR_D_SAMPE_DEMAND;
							FETCH NEXT FROM CUR_D_SAMPE_DEMAND INTO @X_COMPANY_ID
							                                   , @X_DIVISION_ID
							                                   , @X_SITE_ID
							                                   , @X_PLANT_ID
							                                   , @X_SHOP_GROUP_ID
							                                   , @X_SCP_TARGET_ID
							                                   , @X_MARKET
							                                   , @X_ITEM_ID
							                                   , @X_MFG_WEEK
							                                   , @X_MFG_QTY
							                                   , @X_PRODUCTION_TYPE
							                                   , @X_LINE_ID
							                                   , @X_PRIORITY
							                                   , @X_OPERATION_ID
							                                   , @X_MFG_DATE

							WHILE (@@FETCH_STATUS = 0)
								BEGIN
									INSERT INTO [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H]
									(
										 COMPANY_ID
										,DIVISION_ID
										,SITE_ID
										,PLANT_ID
										,SHOP_GROUP_ID
										,SCP_PLAN_ID
										,SCP_TARGET_ID
										,MARKET
										,ITEM_ID
										,MFG_WEEK
										,MFG_QTY
										,PRODUCTION_TYPE
										,LINE_ID
										,PRIORITY
										,OPERATION_ID
										,MFG_DATE
										,INSERT_ID
										,INSERT_TIME
										,UPDATE_ID
										,UPDATE_TIME
									)
									VALUES( @X_COMPANY_ID
							              , @X_DIVISION_ID
							              , @X_SITE_ID
							              , @X_PLANT_ID
							              , @X_SHOP_GROUP_ID
										  , @V_SCP_PLAN_ID
							              , CASE WHEN RIGHT(@X_SCP_TARGET_ID,2) = '_C' THEN @X_SCP_TARGET_ID ELSE @X_SCP_TARGET_ID + '_C' END
							              , @X_MARKET
							              , @X_ITEM_ID
							              , @X_MFG_WEEK
							              , @X_MFG_QTY
							              , @X_PRODUCTION_TYPE
							              , @X_LINE_ID
							              , @X_PRIORITY
							              , @X_OPERATION_ID
							              , @X_MFG_DATE
									      , 'PR_XIF_SCP_PRODTARGET_R'
									      , GETDATE()
									      , 'PR_XIF_SCP_PRODTARGET_R'
									      , GETDATE()
									      );

									DECLARE CUR_WEEK_PLAN_DS CURSOR FOR
										SELECT T.SCP_TARGET_ID
											  ,T.MFG_QTY
										FROM  [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H] T
										WHERE T.[SCP_PLAN_ID]   = @V_SCP_PLAN_ID
										AND T.[COMPANY_ID]      = @X_COMPANY_ID
										AND T.[DIVISION_ID]     = @X_DIVISION_ID
										AND T.[SITE_ID]         = @X_SITE_ID
										AND T.[PLANT_ID]        = @X_PLANT_ID
										AND T.[SHOP_GROUP_ID]   = @X_SHOP_GROUP_ID
										AND T.[MFG_WEEK]        = @X_MFG_WEEK
										AND T.[ITEM_ID]         = @X_ITEM_ID
										AND T.[LINE_ID]         = @X_LINE_ID
										AND T.[PRODUCTION_TYPE] != 'TEST' 
										AND T.[PRODUCTION_TYPE] != 'D-SAMPLE' 
										ORDER BY [PRODUCTION_TYPE]

									OPEN CUR_WEEK_PLAN_DS
									FETCH NEXT FROM CUR_WEEK_PLAN_DS INTO   @T_SCP_TARGET_ID
																		,@T_MFG_QTY
									WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
										BEGIN			
											IF @T_MFG_QTY >= @X_MFG_QTY
												BEGIN
													UPDATE [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H]
														SET MFG_QTY = @T_MFG_QTY - @X_MFG_QTY
															,UPDATE_ID = 'PR_XIF_SCP_PRODTARGET_R'
															,UPDATE_TIME =  GETDATE()
													WHERE [SCP_PLAN_ID]   = @V_SCP_PLAN_ID
													AND   [COMPANY_ID]    = @X_COMPANY_ID
													AND   [DIVISION_ID]   = @X_DIVISION_ID
													AND   [SITE_ID]       = @X_SITE_ID
													AND   [PLANT_ID]      = @X_PLANT_ID
													AND   [SHOP_GROUP_ID] = @X_SHOP_GROUP_ID
													AND   [MFG_WEEK]      = @X_MFG_WEEK
													AND   [ITEM_ID]       = @X_ITEM_ID
													AND   [LINE_ID]       = @X_LINE_ID
													AND   [SCP_TARGET_ID] = @T_SCP_TARGET_ID
													SET @X_MFG_QTY = 0;
													BREAK;
												END;
											ELSE
												BEGIN
													SET @X_MFG_QTY = @X_MFG_QTY - @T_MFG_QTY;
													UPDATE [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H]
														SET MFG_QTY = 0
															,UPDATE_ID = 'PR_XIF_SCP_PRODTARGET_R'
															,UPDATE_TIME =  GETDATE()
													WHERE [SCP_PLAN_ID]   = @V_SCP_PLAN_ID
													AND   [COMPANY_ID]    = @X_COMPANY_ID
													AND   [DIVISION_ID]   = @X_DIVISION_ID
													AND   [SITE_ID]       = @X_SITE_ID
													AND   [PLANT_ID]      = @X_PLANT_ID
													AND   [SHOP_GROUP_ID] = @X_SHOP_GROUP_ID
													AND   [MFG_WEEK]      = @X_MFG_WEEK
													AND   [ITEM_ID]       = @X_ITEM_ID
													AND   [LINE_ID]       = @X_LINE_ID
													AND   [SCP_TARGET_ID] = @T_SCP_TARGET_ID
												END;

											FETCH NEXT FROM CUR_WEEK_PLAN_DS INTO   @T_SCP_TARGET_ID
																				,@T_MFG_QTY

										END  -- WHILE @@FETCH_STATUS = 0  CUR_WEEK_PLAN_DS
				
									CLOSE CUR_WEEK_PLAN_DS;
									DEALLOCATE CUR_WEEK_PLAN_DS;   -- 메모리 해제
									
									
								FETCH NEXT FROM CUR_D_SAMPE_DEMAND INTO  @X_COMPANY_ID
																	, @X_DIVISION_ID
																	, @X_SITE_ID
																	, @X_PLANT_ID
																	, @X_SHOP_GROUP_ID
																	, @X_SCP_TARGET_ID
																	, @X_MARKET
																	, @X_ITEM_ID
																	, @X_MFG_WEEK
																	, @X_MFG_QTY
																	, @X_PRODUCTION_TYPE
																	, @X_LINE_ID
																	, @X_PRIORITY
																	, @X_OPERATION_ID
																	, @X_MFG_DATE

							END;   -- WHILE @@FETCH_STATUS = 0 

							CLOSE CUR_D_SAMPE_DEMAND;
							DEALLOCATE CUR_D_SAMPE_DEMAND;
							-- 2022-12-26 leeseongmin D_SAMPE 수요에 대해서 기존 주차 Demand를 당주로 복사하는 과정 끝


							MERGE INTO [DBO].[SCM_SCP_PLAN_H] A
							USING (
								   SELECT @V_SCP_PLAN_ID AS SCP_PLAN_ID,
										  'PRODUCT' AS SCP_PLAN_TYPE,
										  CONVERT(DATETIME, SUBSTRING(@V_SCP_PLAN_ID, 1, 8)) AS PLAN_START_TIME,
										  200 AS PLAN_HORIZON,
										  200 AS DEMAND_HORIZON,
										  SUBSTRING(@V_SCP_PLAN_ID, 1, 4) +
											REPLICATE('0', 2 - LEN(DATEPART(WW, SUBSTRING(@V_SCP_PLAN_ID, 1, 8)) )) +
														 CAST(DATEPART(WW, SUBSTRING(@V_SCP_PLAN_ID, 1, 8)			)  AS VARCHAR)  AS PLAN_WEEK	--2019-05-29 PIYONG CHANGE 단자리 주차앞에 0 생성하도록 변경
								  ) B
							ON (
								A.SCP_PLAN_ID = B.SCP_PLAN_ID
							   )
							WHEN MATCHED THEN
								UPDATE SET  A.[SCP_PLAN_TYPE]     = B.[SCP_PLAN_TYPE]
										   ,A.[PLAN_START_TIME]   = B.[PLAN_START_TIME]
										   ,A.[PLAN_HORIZON]      = B.[PLAN_HORIZON]
										   ,A.[DEMAND_HORIZON]    = B.[DEMAND_HORIZON]
										   ,A.UPDATE_ID           = 'PR_XIF_SCP_PRODTARGET_R'
										   ,A.UPDATE_TIME         = GETDATE()

							WHEN NOT MATCHED THEN
								INSERT ([SCP_PLAN_ID]
									   ,[SCP_PLAN_TYPE]
									   ,[PLAN_START_TIME]
									   ,[PLAN_HORIZON]
									   ,[DEMAND_HORIZON]
									   ,[PLAN_WEEK]
									   ,[INSERT_ID]
									   ,[INSERT_TIME]
									   ,[UPDATE_ID]
									   ,[UPDATE_TIME]
							   ) VALUES (
										B.SCP_PLAN_ID,
										B.SCP_PLAN_TYPE,
										B.PLAN_START_TIME,
										B.PLAN_HORIZON,
										B.DEMAND_HORIZON,
										B.PLAN_WEEK,
										'PR_XIF_SCP_PRODTARGET_R',
										GETDATE(),
										'PR_XIF_SCP_PRODTARGET_R',
										GETDATE()
							   )
							;


							------------------------------------------------------------------------------
							--2019-06-26 PIYONG ADD PJT 개발단계 MASTER 없는 정보 생성
							--IF @DIVISION = 'EE' 
							IF @SHOP_GROUP = 'E' -- 2022-03-29 kimcd 조건을 Division에서 공정 군으로 변경
								BEGIN
									INSERT INTO [FP_PLM_PJT_MODEL_MASTER](
										[DIVISION_ID]
										,[MODEL_ID]
										,[PRODUCTION_TYPE]
										,[INSERT_TIME]
										,[INSERT_ID]
										,[UPDATE_TIME]
										,[UPDATE_ID]
									)
									SELECT DISTINCT I.DIVISION_ID
										   ,I.APPLIED_MODEL
										   ,'MASS'
										   ,GETDATE()
										   ,'PR_XIF_PLM_PJT_SCHEDULE_R'
										   ,GETDATE()
										   ,'PR_XIF_PLM_PJT_SCHEDULE_R'
									  FROM [DBO].[SCM_ITEM_M] I WITH(NOLOCK)
										   ,[DBO].[FP_WEEKLY_DEMAND_PRODUCT_H] WDP WITH(NOLOCK)
									 WHERE I.COMPANY_ID = WDP.COMPANY_ID
									   AND I.DIVISION_ID = WDP.DIVISION_ID
									   AND I.SITE_ID = WDP.SITE_ID
									   AND I.ITEM_ID = WDP.ITEM_ID
									   AND I.APPLIED_MODEL IS NOT NULL
									   AND I.ITEM_ID LIKE 'APC%'
									   AND WDP.SCP_PLAN_ID = @V_PLAN_WEEK
									   AND WDP.SHOP_GROUP_ID = 'E'
									   AND WDP.PRODUCTION_TYPE = 'MASS'
									   AND WDP.UPDATE_ID = 'PR_XIF_SCP_PRODTARGET_R'
									   AND NOT EXISTS (
														SELECT 1
														  FROM [FP_PLM_PJT_MODEL_MASTER] PMM WITH(NOLOCK)
														 WHERE PMM.DIVISION_ID	= I.DIVISION_ID
														   AND PMM.MODEL_ID		= I.APPLIED_MODEL
													   )
								END
							--2019-06-26 PIYONG ADD END
							------------------------------------------------------------------------------


							IF @ROWCOUNT > 0 OR @ROWCOUNT1 > 0 	--2018-08-30 PIYONG   @ROWCOUNT1 ADD
								BEGIN
									-- 2018-07-13 PIYONG ADD
									SET @DIVISION_NAME = (
															SELECT TOP 1 DIVISION_NAME
															  FROM SCM_DIVISION_M
															 WHERE DIVISION_ID = @DIVISION
															 ORDER BY DIVISION_NAME
														)

									-- 2018-08-16 PIYONG ADD
									-- IF @DIVISION = 'EE'
									IF @SHOP_GROUP = 'E' -- 2022-03-29 kimcd 조건을 Division에서 공정 군으로 변경
										BEGIN
											SET @DIVISION_NAME = @DIVISION + ' Electrode'
										END

									INSERT INTO dbo.SCM_MAILING_H
									(   [MAIL_PKEY]
										,[MAIL_SEQ]
										,[MAIL_DATETIME]
										,[MAIL_SUBJECT]
										,[MAIL_BODY]
										,[MAIL_QUERY]
										,[ATTACH_FILE_NAME]
										,[MAIL_RECEIVER_LIST]
										,[MAIL_PROFILE_NAME]
										,[MAIL_SEND_FLAG]
										,[MESSAGE]
										,[CREATE_USER_ID]
										,[CREATE_DATE]
										,[MODIFY_USER_ID]
										,[MODIFY_DATE]
									)
									SELECT [MAIL_PKEY]
											, NEXT VALUE FOR SEQ_SCM_MAIL
											, NULL
											,REPLACE([MAIL_SUBJECT],'@DIVISION_NAME',@DIVISION_NAME)											-- 2018-07-13 PIYONG CHANGE
											,REPLACE( REPLACE([MAIL_BODY],'@V_SCP_PLAN_ID',@V_SCP_PLAN_ID) ,'@DIVISION_NAME',@DIVISION_NAME)	-- 2018-07-13 PIYONG CHANGE
											,[MAIL_QUERY]
											,[ATTACH_FILE_NAME]
											,[MAIL_RECEIVER_LIST]+ ISNULL(	-- 2018-07-03 PIYONG CHANGE
																			(
																				SELECT ATTRIBUTE1
																				  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
																				 WHERE LOOKUP_TYPE_CODE = 'TARGET_INFO_MAIL'
																				   AND SEGMENT1 ='SCP_PROD'
																				   AND SEGMENT3 = @DIVISION
																				   AND ACTIVE_FLAG = 'Y'
																			)
																			, ';')
											,'FP_MAIL'
											,'N'
											,NULL  
											,@v_proc_name
											,getdate()
											,@v_proc_name
											,getdate()
									   FROM [SCM_MAILING_LIST_M]
									  WHERE MAIL_PKEY = 'SCP_PROD'+@DIVISION

								END


							UPDATE [dbo].[SY_XIF_SCP_PROD_TARGET_R]
							   SET PROC_FLAG = 'Y'
								  ,PROC_DATE = GETDATE()
							 WHERE ISNULL(PROC_FLAG,'N') = 'N'
 							   AND PLAN_WEEK = @V_PLAN_WEEK
							   AND DIVISION = @DIVISION
							;


						END

					FETCH NEXT FROM CUR_DIVISION INTO @DIVISION
													, @V_PLAN_WEEK
													, @SHOP_GROUP  -- 2019-10-23 kimcd add 공정군 구분


				END  -- WHILE @@FETCH_STATUS = 0  CUR_DIVISION
				CLOSE CUR_DIVISION;
				DEALLOCATE CUR_DIVISION;   -- 메모리 해제

			END
                                                                            
                                                                                                           
                                                                                                                                                                 
                                                                                                                                                                 
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
                                                                                                                                                                 


