
CREATE PROCEDURE [dbo].[PR_XIF_PLM_ITEM_CONV_CALC_R_nff]

-- ================================================================================================
-- Program ID          : FP03032
-- Program Name        : PR_XIF_PLM_ITEM_CONV_CALC_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : PLM
-- Destination System  : FP SDB
-- Source Table        : XIF_PLM_WO_INSP_SPEC_R
-- Destination Table   : 
--
-- Create Date		   : 2018.11.27
-- Update Date		   : 2019.03.11 1.1 PIYONG
--						 2019.03.29 1.2 PIYONG
--						 2019.04.26 2.0 PIYONG
--						 2019.06.18 2.1 PIYONG
--						 2019.07.16 2.2 PIYONG
--						 2019.07.25 2.3 PIYONG
--						 2019.08.20 2.4 PIYONG
--						 2020.01.14 3.0 PIYONG
--						 2020.02.19 4.0 PIYONG
--						 2020.03.27 4.1 PIYONG
--                       2020.07.10 4.2 kimcd
--                       2020.08.20 4.3 kimcd
--                       2020.11.09 4.4 kimcd
--                       2020.12.10 4.5 kimcd
--                       2021.01.12 4.6 kimcd
--                       2021.02.17 4.7 kimcd
--                       2021.04.12 4.8 kimcd
--                       2021.06.24 4.9 kimcd
--                       2021.12.28 4.91 kimcd
--                       2022.01.07 5.0 kimcd
--                       2022.04.14 5.1 김현
--                       2022.04.26 5.2 kimcd
--                       2022.07.28 5.3 leeseongmin
--                       2022.09.05 5.4 leeseongmin.  AND  CONVERT(NUMERIC(10,2), VALUE1) > 0 추가 보완
--                       2022.12.02 5.5 kimcd

-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 Jumbo Roll (cell/m) POUCH 소요량 GROUP BY 변경
--						 1.2 LANE 수 생성시 M_BATCH 기준으로 존재하는 데이터만 생성
--						 2.0 I/F TABLE을 직접 사용하지 않고 TEMP 테이블에 적재 하여 사용 ( SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC)
--							 PR_XIF_PLM_WO_INSP_SPEC_R 프로시져 와 동일한 테이블를 사용하여 환산자를 생성하는데
--							 수신 시점에 따라 정보 생성 누락이 발생 하여 TEMP테이블 사용
--						 2.1 작업의뢰 수신 시점보다 PANCAKE MASTER 등록이 늦은 데이터 포함
--						 2.2 BOM이 변경된 MODEL 재 생성되도록  대상에 추가
--						 2.3 .P VERSION 뒤에 PREWETTING LINE 붙힘
--						 2.4 폴란드 파우치 더블레이어 반제품인 경우 고형분량이 적은 반제품만 적용
--						 3.0 CNA (EA) 제외 한 정보 생성
--						 4.0 미래구간 ITEM 생성을 위한 테이블 변경 [SCM_MODEL_COMP_TEMP] -> [SCM_MODEL_COMP_EFFECTIVE_DATE]
--						 4.1 자동차 모델을 소형으로 등록할 경우 CMODEL_CODE LIKE 'ACEN%' -> LEFT(A.CMODEL_CODE, 1) = 'A' 변경
--                       4.2 2020-07-10 kimcd 적용일자 정보 추가 형성. 차수 정보 추가
--                       4.3 2020-08-20 kimcd ED동 PROD VERSION에 .A 사용에 따른 수정
--                       4.4 2020-11-09 kimcd CNB 환산자 수신 제거 - PR_XIF_PLM_CONVERSION_RATE_R 에서 수행
--                                            CNJ 환산자 로직 수정 - E7동 Margine 로직 수정. DLD TOP COATING 사용
--                       4.5 2020-12-10 kimcd CNJ Double Layer의 경우 Top만 Loading량 사용하도록 조정
--                       4.6 2021-01-12 kimcd FN_GET_REQ_QTY_MODEL 대당 소요량 추출하는 함수 수정
--                       4.7 2021-02-17 kimcd 전체 자동차, ESS는 작업의뢰서 환산자 직접 수신
--                       4.8 2021-04-12 kimcd 소형 작업의뢰의 전체 Coating 폭 기반으로 환산자 계산하도록 수정
--                       4.9 2021-06-24 kimcd 4.8 2021-04-12 kimcd 소형 작업의뢰의 전체 Coating 폭 기반으로 환산자 계산하는 로직 주석 처리
--                                            C20210626-000019ESNJ 광폭 음극 라인 DLD 모델 공형분 적용 로직을 변경 요청 건
--                                            남경 소형 전극에 대해서 원,각형 Double의 경우 고형분량 top, coating은 loading량 산출하고 2로 나눔
--                       4.91 2021-12-28 kimcd 4.91 남경 소형 전극 E7,EE동 DLD 예외 로직 주석 처리
--                       5.0  2022-01-07 kimcd 5.0 남경 소형 전극 E7동 파우치 DLD 예외 로직 제거
--                       5.1  2022-04-14 김현 [C20220328-000596]NFF Cylindrical 유형 환산자 형성 로직 추가
--                       5.2  2022-04-26 kimcd 5.2 가상 Division 사용에 따른 로직 보완
--                       5.3  2022-07-28 leeseongmin [CSR :C20220715-000237 ]NFF Cylindrical / 원, 각 형 / 파우치 각각 분리 NFF 로직수정작업 
--                       5.4  2022-09-05 leeseongmin [CSR :C20220905-000588 ]Pouch center와 side 폭이 같으면 코팅영역수 패턴으로 수식적용 - 값이없을 경우 LANE값 사용
--                            2022-10-20 kimcd       Coating 폭 수 0으로 수신되는 경우 로직 보완  AND  CONVERT(NUMERIC(10,2), VALUE1) > 0
--                       5.5  2022-12-02 kimcd 전극 버전별 생산 계획 수립하기 위해 환산자 버전별 가용 라인 정보 자동 형성
--                       5.6  2023-06-17 FP Pjt. #POUCH_CELL_M : 버전별 차수가 복수일 경우 높은 차수 선택
--                       5.7  2023-10-20 FP Pjt. #LANE_INFO : LANE_QTY > 0 조건 추가
--						 5.8  2023-06-17 FP Pjt. #POUCH_M_BATCH : 버전별 차수가 복수일 경우 높은 차수 선택
--                       5.9  2024-04-01 FP Pjt. NFF 신코드 반영
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PLM_ITEM_CONV_CALC_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	declare @v_err_check nvarchar(1000)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			/*	--2019-04-26 PIYONG DEL
			UPDATE B
			   SET B.PROC_FLAG = 'N'
			  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R] B
			 WHERE B.IF_RCV_DATE > GETDATE()-1



			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'P'
			 WHERE PRODID IS NOT NULL
			   AND CELLTYPE = 'POUCH'
			   AND PROC_FLAG = 'N'

			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'N'
			 WHERE CELLTYPE = 'POUCH'
			   AND PRODID IS NOT NULL
			   --AND PROC_FLAG = 'P'
			   AND SPEC_ITEM_ID IN ( 
									'I-A009-SPEC-002'
									,'I-A009-SPEC-002B'
									,'I-A014-SPECA-002'
									,'I-A014-SPECA-002B'
									,'I-E009-SPECE-002'
									,'I-E014-SPECA-002'
									,'I-P014-SPEC-001'
									,'I-P014-SPEC-001B'
									,'I-P009-SPEC-001'
									,'I-P009-SPEC-001B'
									)  
				AND VALUE2 IN ( N'-' )
			*/

			---------------------------------------------------------------------------
			--2019-04-26 PIYONG ADD
			SELECT [IF_SEQ]
				  ,[IF_TYPE]
				  ,[IF_ID]
				  ,[IF_RCV_DATE]
				  ,[PROC_FLAG]
				  ,[PROC_DATE]
				  ,[PROC_MSG]
				  ,[WO_ID]
				  ,[CELLTYPE]
				  ,[CMODEL_CODE]
				  ,[PROD_VER_CODE]
				  ,[PRODID]
				  ,[AREA_ID]
				  ,[AREA_NAME]
				  ,[PROC_ID]
				  ,[PROC_NAME]
				  ,[SEQ_ID]
				  ,[INSP_ITEM_ID]
				  ,[SPEC_ITEM_ID]
				  ,[SPEC_ITEM_NAME]
				  ,[UNIT]
				  ,[VALUE1]
				  ,[VALUE2]
				  ,[VALUE3]
				  ,[VALUE4]
				  ,[VALUE5]
				  ,[CREATE_USER_ID]
				  ,[CREATE_DATE]
				  ,[MODIFY_USER_ID]
				  ,[MODIFY_DATE]
				  ,ISNULL([ATTR_01], '00') AS [ATTR_01] -- 2020-07-10 kimcd 컬럼명 명시 - 차수 설정용
				  ,[ATTR_02]
				  ,[ATTR_03]
				  ,[ATTR_04]
				  ,ISNULL([ATTR_05], '2000-01-01' ) AS [ATTR_05] -- 2020-07-10 kimcd 컬럼명 명시 - 적용일자 설정용
				  ,[ATTR_06]
				  ,[ATTR_07]
				  ,[ATTR_08]
				  ,[ATTR_09]
				  ,[ATTR_10]
				  ,[ATTR_11]
				  ,[ATTR_12]
				  ,[ATTR_13]
				  ,[ATTR_14]
				  ,[ATTR_15]
				  ,[ATTR_16]
				  ,[ATTR_17]
				  ,[ATTR_18]
				  ,[ATTR_19]
				  ,[ATTR_20] -- 2020-07-10 kimcd 컬럼명 명시 - 차수, 적용일자 설정용
			  INTO #PLM_ITEM_CONV_CALC
			  FROM (
					SELECT *
					  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
					 WHERE PRODID IS NOT NULL
  					   AND IF_RCV_DATE >= DATEADD(HOUR, -1,GETDATE())
   					   AND PROC_ID IN ( 'E1000', 'E2000' )
					---------------------------------------------------------------------------
					-- 2019-06-18 PIYONG ADD
					UNION 
					SELECT P2.*
					  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R] P2
							,( 
								SELECT CMODEL_CODE, AREA_ID
			   					  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R] P
									   ,(
											SELECT ITEM_ID, FACTORY_ID
			   								  FROM [SCM_ITEM_LANE_M] WITH(NOLOCK)
											 WHERE UPDATE_TIME >= DATEADD(HOUR, -1,GETDATE() )
											 GROUP BY ITEM_ID, FACTORY_ID			
										) L
								  WHERE P.PRODID = L.ITEM_ID
									AND P.AREA_ID = L.FACTORY_ID
								  GROUP BY CMODEL_CODE, AREA_ID
							) A
					  WHERE P2.CMODEL_CODE = A.CMODEL_CODE
						AND P2.AREA_ID = A.AREA_ID
					-- 2019-06-18 PIYONG ADD  END
					---------------------------------------------------------------------------
					---------------------------------------------------------------------------
					-- 2019-07-16 PIYONG ADD
					UNION
					SELECT *
					  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
					 WHERE CMODEL_CODE IN (
											SELECT ISNULL(I.APPLIED_MODEL, I.ITEM_ID )
											  FROM SCM_ITEM_M I
												   , (
														SELECT [COMPANY_ID]
																, [DIVISION_ID]
																, [SITE_ID]
																, [PARENT_ITEM_ID] AS ITEM_ID
														  FROM [dbo].[SCM_BOM_M] WITH(NOLOCK)
														 WHERE UPDATE_TIME >= DATEADD(HOUR, -1,GETDATE())
														   AND [KEY_DATE]  >= CONVERT(NVARCHAR(8), GETDATE()-1,112)
														 GROUP BY [COMPANY_ID]
																, [DIVISION_ID]
																, [SITE_ID]
																, [PARENT_ITEM_ID]
												   ) B
											 WHERE I.[COMPANY_ID] = B.[COMPANY_ID]
											   AND I.[DIVISION_ID] = B.[DIVISION_ID]
											   AND I.[SITE_ID] = B.[SITE_ID]
											   AND I.ITEM_ID = B.ITEM_ID
											 GROUP BY ISNULL(I.APPLIED_MODEL, I.ITEM_ID )
										  )
					-- 2019-07-16 PIYONG ADD  END
					---------------------------------------------------------------------------
				   ) B
			  WHERE  B.AREA_ID NOT IN (SELECT F.FACTORY_ID FROM SCM_FACTORY_M F (NOLOCK) WHERE F.DIVISION_ID IN ('81','82')
									   UNION ALL
									   SELECT F.FACTORY_ID 
									   FROM   SCM_FACTORY_M F (NOLOCK),
										      SCM_PSEUDO_DIVISION_M PD (NOLOCK)
									   WHERE  F.PLANT_ID = PD.PLANT_ID
									   AND    PD.ORIGINAL_DIVISION_ID IN ('81','82'))  -- 2022-04-26 kimcd 가상 Division 조건 추가
			  -- 2021-02-17 kimcd 전체 자동차, ESS는 작업의뢰서 환산자 직접 수신
			  -- 2020-11-09 kimcd CNB 환산자 수신 제거 - PR_XIF_PLM_CONVERSION_RATE_R 에서 수행

			  DELETE FROM #PLM_ITEM_CONV_CALC
			   WHERE CELLTYPE = 'POUCH'
			     AND PRODID IS NOT NULL
			     AND SPEC_ITEM_ID IN ( 
										'I-A009-SPEC-002'
										,'I-A009-SPEC-002B'
										,'I-A014-SPECA-002'
										,'I-A014-SPECA-002B'
										,'I-E009-SPECE-002'
										,'I-E014-SPECA-002'
										,'I-P014-SPEC-001'
										,'I-P014-SPEC-001B'
										,'I-P009-SPEC-001'
										,'I-P009-SPEC-001B'
									 )  
				 AND VALUE2 = N'-'

			--2019-04-26 PIYONG ADD END
			---------------------------------------------------------------------------
			  DELETE FROM #PLM_ITEM_CONV_CALC
			   WHERE CELLTYPE = 'NFF Cylindrical'
			     AND PRODID IS NOT NULL
			     AND SPEC_ITEM_ID IN ( 'I-M004-SPEC-001'
				                      ,'I-M004-SPECA-001'
									  ,'I-M009-SPECE-001'
									  ,'I-M014-SPECA-001'
									  ,'I-M004-SPECA-003'
									  ,'I-M014-SPECA-004' --'I-M014-SPECA-003'
									 )  
				 AND VALUE2 = N'-'	-- 2022-04-14 김현 [C20220328-000596] NFF Cylindrical 환산자 형성


			--코터 기준 LANE 수
			SELECT [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID] AS AREA_ID
				  ,[ITEM_ID] AS PRODID
				  ,MAX([LANE_QTY]) AS LANE_CNT
				  ,PROD_VERSION_TYPE
		      INTO #LANE_INFO
			  FROM [SCM_ITEM_LANE_M]
			 WHERE [ACTIVE_FLAG] = 'Y'
			   AND [FACTORY_ID] NOT IN ( 'EA' )
   			   AND [FACTORY_ID] NOT IN (SELECT F.FACTORY_ID FROM SCM_FACTORY_M F (NOLOCK) WHERE F.DIVISION_ID IN ('81','82')
										UNION ALL
									    SELECT F.FACTORY_ID 
									    FROM   SCM_FACTORY_M F (NOLOCK),
										       SCM_PSEUDO_DIVISION_M PD (NOLOCK)
									    WHERE  F.PLANT_ID = PD.PLANT_ID
									    AND    PD.ORIGINAL_DIVISION_ID IN ('81','82'))  -- 2022-04-26 kimcd 가상 Division 조건 추가
			       -- 2021-02-17 kimcd 전체 자동차, ESS는 작업의뢰서 환산자 직접 수신
			       -- 2020-11-09 kimcd CNB 환산자 수신 제거 - PR_XIF_PLM_CONVERSION_RATE_R 에서 수행
			   AND LANE_QTY > 0
			 GROUP BY [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[ITEM_ID]
				  ,PROD_VERSION_TYPE


			--믹서 기준 POUCH  고형분 생성
			SELECT COMPANY_ID
				   ,DIVISION_ID
				   ,SITE_ID
				   ,PLANT_ID
				   ,CMODEL_CODE
				   ,PROD_VER_CODE
				   ,ATTR_01 --  차수
				   ,PRODID
				   ,AREA_ID
				   ,ATTR_10 -- 더블레이어	--2019-07-18 PIYONG ADD
				   ,Solids_amount--고형분
			  INTO #POUCH_MIX_INFO
			  FROM (
					SELECT DISTINCT AA.COMPANY_ID
						   ,AA.DIVISION_ID
						   ,AA.SITE_ID
						   ,AA.PLANT_ID
						   ,AA.CMODEL_CODE
						   ,AA.PROD_VER_CODE
						   ,AA.ATTR_01 --  차수
						   ,AA.PRODID
						   ,AA.AREA_ID
						   ,AA.WO_ID
						   ,AA.ATTR_10 -- 더블레이어	--2019-07-18 PIYONG ADD
						   ,AA.Solids_amount--고형분
					  FROM (
							SELECT F.COMPANY_ID
									,F.DIVISION_ID
									,F.SITE_ID
									,F.PLANT_ID
									,CMODEL_CODE
									,PROD_VER_CODE
									,ATTR_01 --  차수
									,PRODID
									,AREA_ID
									,WO_ID
									,ATTR_10 -- 더블레이어	--2019-07-18 PIYONG ADD
									--,SUM( CONVERT( FLOAT, REPLACE( Solids_amount, ',', '') ) ) AS Solids_amount--고형분
									-- 2020-12-10 kimcd E7동 double layer인 경우 Top만 사용
									,SUM( /* 2022-01-07 kimcd E7동 파우치 DLD 예외 로직 제거 CASE WHEN ATTR_10 = 'Y' AND AREA_ID = 'E7' AND ATTR_11 = 'B' THEN 0 ELSE */
									      CONVERT( FLOAT, REPLACE( Solids_amount, ',', '') ) /*END*/ ) AS Solids_amount--고형분
							  FROM (
									 SELECT CMODEL_CODE
											,PROD_VER_CODE
											,PRODID
											,AREA_ID
											,WO_ID
											,ATTR_01 --  차수
											,ATTR_10 -- 더블레이어	--2019-07-18 PIYONG ADD
											,VALUE1 AS Solids_amount--고형분
											,ATTR_11 -- T, B Top, Back 구분 2020-12-10 kimcd E7동 double layer인 경우 Top만 사용
											,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
																			,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																				  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																				  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN 'S'
																				  WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																				  ELSE '-' END
																			,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
																	ORDER BY PROD_VER_CODE DESC
																			,ISNULL( ATTR_01, '00') DESC
																			,WO_ID DESC
																			,CASE WHEN UNIT != 'KG' AND VALUE2 IS NOT NULL THEN 1 ELSE 2 END
																			,IF_SEQ DESC														) NUM
									   FROM #PLM_ITEM_CONV_CALC				--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
									  WHERE CELLTYPE = 'POUCH'
										AND ATTR_04 IS NULL
										AND PROC_ID = 'E1000'			--2020-03-27 PIYONG ADD
										AND UNIT = 'KG' 
										AND SPEC_ITEM_ID IN (
															'I-P001-SPEC-016_1'
															,'I-P002-SPEC-009_1'
															,'I-E001-SPEC-016_1'
															,'I-E002-SPEC-009_1'
															,'I-A002-SPEC-009_1'
															,'I-A001-SPEC-016_1'
															,'I-A002-SPEC-009_1'
															)
								--		AND ISNULL(ATTR_08, 'N') = 'N'		--2019-07-18 PIYONG DEL 대치만 등록하는 경도 있음
								--	    AND PROC_FLAG = 'P'					--2019-04-26 PIYONG DEL
 								--		AND CMODEL_CODE ='MDP386283A10'
								--		AND AREA_ID = 'E2'
								--		AND PROD_VER_CODE = '001'
								--		AND PRODID= 'ASLAN0563A'
									UNION ALL
									SELECT CMODEL_CODE
											, CASE WHEN AREA_ID = 'EA' THEN
													CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
															CONCAT(PROD_VER_CODE,'2')
														  ELSE
															CONCAT(PROD_VER_CODE,'3')
															END
													ELSE
														PROD_VER_CODE
												  END PROD_VER_CODE
											,PRODID
											,AREA_ID
											,WO_ID
											,ATTR_01 --  차수
											,ATTR_10 -- 더블레이어	--2019-07-18 PIYONG ADD
											,VALUE1 AS Solids_amount--고형분
											,ATTR_11 -- T, B Top, Back 구분 2020-12-10 kimcd E7동 double layer인 경우 Top만 사용
											,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
																			,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																				  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																				  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN 'S'
																				  WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																				  ELSE '-' END
																			,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
																		ORDER BY PROD_VER_CODE DESC
																			,ISNULL( ATTR_01, '00') DESC
																			,WO_ID DESC
																			,CASE WHEN UNIT != 'KG' AND VALUE2 IS NOT NULL THEN 1 ELSE 2 END
																			,IF_SEQ DESC														) NUM
									  FROM #PLM_ITEM_CONV_CALC				--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
									 WHERE CELLTYPE = 'POUCH'
									   AND ATTR_04 IS NOT NULL
									   AND PROC_ID = 'E1000'			--2020-03-27 PIYONG ADD
									   AND UNIT = 'KG' 
									   AND SPEC_ITEM_ID IN (
															'I-P001-SPEC-016_1'
															,'I-P002-SPEC-009_1'
															,'I-E001-SPEC-016_1'
															,'I-E002-SPEC-009_1'
															,'I-A002-SPEC-009_1'
															,'I-A001-SPEC-016_1'
															,'I-A002-SPEC-009_1'
															)
									) A
							  INNER JOIN SCM_FACTORY_M F
									  ON A.AREA_ID = F.FACTORY_ID
							  WHERE A.NUM = 1
							  GROUP BY CMODEL_CODE
									 ,PROD_VER_CODE
									 ,ATTR_01 --  차수
									 ,PRODID
									 ,AREA_ID
									 ,F.COMPANY_ID
									 ,F.DIVISION_ID
									 ,F.SITE_ID
									 ,F.PLANT_ID
									 ,WO_ID
									 ,ATTR_10 -- 더블레이어	--2019-07-18 PIYONG ADD

						   )AA
				   ) AAA
			 WHERE Solids_amount IS NOT  NULL
			   AND AREA_ID NOT IN ( 'EA' )


			--코터 기준 POUCH  코팅폭, Loading 생성
			SELECT COMPANY_ID
				   ,DIVISION_ID
				   ,SITE_ID
				   ,AA.PLANT_ID
				   ,CMODEL_CODE
				   ,PROD_VER_CODE
				   ,ATTR_01 --  차수
				   ,PROD_VERSION_TYPE
				   ,VERSION_TYPE
				   ,PRODID
				   ,AREA_ID
			--	   ,Solids_amount		--2020-03-27 PIYONG DEL
				   ,COATING_WIDTH
				   ,LANE_CNT
				   ,Loading
			--	   ,B_Loading			--2020-03-27 PIYONG DEL
				   ,[DBO].[FN_SITE_TIME] ( SITE_ID ) AS EFF_END_DATE
				   ,APPLY_DATE  -- 2020-07-10 kimcd ATTR_05 적용일자 추가
			  INTO #POUCH_COT_INFO
			  FROM (
					---------------------------------------------------------------------------------------------------------------------------
					---------------------------------------------------------------------------------------------------------------------------
					-------------------------------------			POUCH 양면				---------------------------------------------------
					---------------------------------------------------------------------------------------------------------------------------
					---------------------------------------------------------------------------------------------------------------------------
					SELECT A.COMPANY_ID
						   ,A.DIVISION_ID
						   ,A.SITE_ID
						   ,A.PLANT_ID
						   ,A.CMODEL_CODE
						   ,A.PROD_VER_CODE
						   ,A.ATTR_01 --  차수
						   ,CASE  LEFT(PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE
						   ,L.PROD_VERSION_TYPE
						   ,A.PRODID
						   ,A.AREA_ID
					--	   ,A.Solids_amount																							-- 2020-03-27 PIYONG DEL
						   ,A.COATING_WIDTH_CENTER 
						   ,A.COATING_WIDTH_SIDE
						   ,L.LANE_CNT
						   ,CASE WHEN A.COATING_WIDTH IS NOT NULL THEN
									CASE WHEN RIGHT(A.PROD_VER_CODE, '1') = 'W' AND A.AREA_ID = 'E7' THEN
											A.COATING_WIDTH -- + 20 2020-11-09 kimcd E7 코팅폭 산출 로직 수정
										 WHEN RIGHT(A.PROD_VER_CODE, '1') != 'W' AND A.AREA_ID = 'E7' THEN
											CASE WHEN A.CMODEL_CODE LIKE 'E%' THEN A.COATING_WIDTH ELSE A.COATING_WIDTH + 10 END -- 2020-11-09 kimcd E7 코팅폭 산출 로직 수정
										 ELSE
											A.COATING_WIDTH
										 END
								  ELSE
									CASE WHEN A.AREA_ID  != 'E4' THEN
											CASE WHEN A.COATING_WIDTH_CENTER = A.COATING_WIDTH_SIDE THEN							-- 중앙 폭 과 사이드 폭이 같을 경우
															CASE WHEN  RIGHT(A.PROD_VER_CODE, '1') = 'W' AND A.AREA_ID = 'E7' THEN
															( A.COATING_WIDTH_CENTER * CASE WHEN A.LANE_CNT_P IS NULL THEN L.LANE_CNT ELSE A.LANE_CNT_P END ) -- + 20  2020-11-09 kimcd E7 코팅폭 산출 로직 수정 (코팅패턴)  --2022-09-05 leeseongmin [CSR :C20220905-000588]
														 WHEN  RIGHT(A.PROD_VER_CODE, '1') != 'W' AND A.AREA_ID = 'E7' THEN
															CASE WHEN A.CMODEL_CODE LIKE 'E%' THEN ( A.COATING_WIDTH_CENTER * CASE WHEN A.LANE_CNT_P IS NULL THEN L.LANE_CNT ELSE A.LANE_CNT_P END ) ELSE ( A.COATING_WIDTH_CENTER * CASE WHEN A.LANE_CNT_P IS NULL THEN L.LANE_CNT ELSE A.LANE_CNT_P END ) + 10 END --(코탕패턴)  --2022-09-05 leeseongmin [CSR :C20220905-000588]
																-- 2020-11-09 kimcd E7 코팅폭 산출 로직 수정
														 ELSE
															( A.COATING_WIDTH_CENTER * CASE WHEN A.LANE_CNT_P IS NULL THEN L.LANE_CNT ELSE A.LANE_CNT_P END ) + 10
														 END
												 WHEN A.COATING_WIDTH_CENTER IS NOT NULL AND ( A.COATING_WIDTH_SIDE IS NULL OR A.COATING_WIDTH_SIDE = 0 ) THEN		-- 중앙 폭만 있고 광폭이 아닐 경우
													CASE WHEN  RIGHT(A.PROD_VER_CODE, '1') = 'W' AND A.AREA_ID = 'E7' THEN
															( A.COATING_WIDTH_CENTER * L.LANE_CNT ) -- + 20 2020-11-09 kimcd E7 코팅폭 산출 로직 수정
														 WHEN  RIGHT(A.PROD_VER_CODE, '1') != 'W' AND A.AREA_ID = 'E7' THEN
															 CASE WHEN A.CMODEL_CODE LIKE 'E%' THEN ( A.COATING_WIDTH_CENTER * L.LANE_CNT ) ELSE ( A.COATING_WIDTH_CENTER * L.LANE_CNT ) + 10 END
															   -- 2020-11-09 kimcd E7 코팅폭 산출 로직 수정
														 WHEN A.CMODEL_CODE LIKE 'ACE%' AND A.AREA_ID = 'E3' THEN					-- 자동차 모델을 오창소형2동에서 하는 모델일 경우
															A.COATING_WIDTH_CENTER  + 10
														 ELSE
															( A.COATING_WIDTH_CENTER * L.LANE_CNT ) + 10
														 END
												 ELSE
													CASE WHEN  RIGHT(A.PROD_VER_CODE, '1') = 'W' AND A.AREA_ID = 'E7' THEN
															( ( A.COATING_WIDTH_CENTER * ( L.LANE_CNT -1 )) + ( ISNULL(A.COATING_WIDTH_SIDE, 0 ) * 2 ) ) --+ 20  2020-11-09 kimcd E7 코팅폭 산출 로직 수정
														 WHEN  RIGHT(A.PROD_VER_CODE, '1') != 'W' AND A.AREA_ID = 'E7' THEN
															 CASE WHEN A.CMODEL_CODE LIKE 'E%' THEN ( ( A.COATING_WIDTH_CENTER * ( L.LANE_CNT -1 )) + ( ISNULL(A.COATING_WIDTH_SIDE, 0 ) * 2 ) )
															 ELSE ( ( A.COATING_WIDTH_CENTER * ( L.LANE_CNT -1 )) + ( ISNULL(A.COATING_WIDTH_SIDE, 0 ) * 2 ) ) + 10 END
															 -- 2020-11-09 kimcd E7 코팅폭 산출 로직 수정
														 ELSE
															( ( A.COATING_WIDTH_CENTER * ( L.LANE_CNT -1 )) + ( ISNULL(A.COATING_WIDTH_SIDE, 0 ) * 2 ) ) + 10
														 END
												 END
										  ELSE
											CASE WHEN A.COATING_WIDTH_CENTER IS NOT NULL AND  A.COATING_WIDTH_SIDE IS NULL THEN		-- 중앙 폭만 있고 광폭일 경우
													( A.COATING_WIDTH_CENTER * L.LANE_CNT )  + 20
												 WHEN A.COATING_WIDTH_CENTER = A.COATING_WIDTH_SIDE THEN							-- 중앙 폭과 사이드 폭이 같고 광폭일 경우
													( ( A.COATING_WIDTH_CENTER * L.LANE_CNT )  + 20 )
												 WHEN A.COATING_WIDTH_CENTER IS NOT NULL AND  A.COATING_WIDTH_SIDE IS NOT NULL THEN	-- 중앙 폭, 사이드 폭이 있고 광폭일 경우
													( ( ( A.COATING_WIDTH_CENTER * ( L.LANE_CNT -1 )) + ( ISNULL(A.COATING_WIDTH_SIDE, 0 ) * 2 ) ) + 20 ) 
												 END
										 END
								 END COATING_WIDTH
					--	   ,CASE WHEN ATTR_10 = 'Y' AND A.AREA_ID = 'EA' AND Loading > BACK_Loading THEN Loading - BACK_Loading  ELSE A.Loading END Loading
							-----------------------------------------------------------------------------------------------------------------------------------
							-- 2020-03-27 PIYIONG CHANGE
						  ,CASE WHEN A.DIVISION_ID = '81' THEN
									CASE WHEN A.AREA_ID = 'EC' AND BACK_Loading != 0 THEN
											BACK_Loading
										 WHEN ATTR_10 = 'Y' AND A.AREA_ID = 'EA' AND Loading > BACK_Loading THEN
											Loading - BACK_Loading  
										 ELSE
											Loading
										 END
								WHEN A.DIVISION_ID = '40' AND LEFT(A.CMODEL_CODE, 1) = 'A' THEN
									Loading
								-- 2022-01-07 kimcd E7동 파우치 DLD 예외 로직 제거 WHEN A.AREA_ID = 'E7' AND A.ATTR_10 = 'Y' AND A.PRODID LIKE 'APCA%' THEN
								--	Loading  -- 2020-12-10 kimcd E7동 double layer인 경우 Top만 사용
								ELSE
									Loading + CASE WHEN A.AREA_ID = 'E7' AND A.ATTR_10 = 'Y' AND A.PRODID LIKE 'APCA%' AND BACK_Loading = 0 THEN Loading ELSE BACK_Loading END
									-- 2022-01-07 kimcd E7동 파우치 DLD 예외 로직 변경. bottom에 coating 없는 경우 대비용
								END AS Loading
					--	   ,A.B_Loading						-- 2020-03-27 PIYONG DEL
							-- 2020-03-27 PIYIONG CHANGE END
							-----------------------------------------------------------------------------------------------------------------------------------
						  ,APPLY_DATE  -- 2020-07-10 kimcd ATTR_05 적용일자 추가
					  FROM (
							SELECT F.COMPANY_ID
								   ,F.DIVISION_ID
								   ,F.SITE_ID
								   ,F.PLANT_ID
								   ,CMODEL_CODE
								   ,PROD_VER_CODE
								   ,ATTR_01 --  차수
							--	   ,VERSION_TYPE			-- 2020-03-23 PIYONG DEL
								   ,PLM_FACTORY_CODE
								   ,PRODID
								   ,AREA_ID
								   ,MAX( CONVERT( FLOAT, LANE_CNT_P)) as  LANE_CNT_P --2022-09-05 leeseongmin [CSR :C20220905-000588 ]
							--	   ,SUM( CONVERT( FLOAT, REPLACE( Solids_amount, ',', '') ) ) AS Solids_amount--고형분														-- 2020-03-27 DEL
								   ,SUM( CONVERT( FLOAT, REPLACE( COATING_WIDTH, ',', '') ) ) AS COATING_WIDTH--코팅폭 (㎜/Lane)
								   ,SUM( CONVERT( FLOAT, REPLACE( COATING_WIDTH_CENTER, ',', '') ) ) AS COATING_WIDTH_CENTER--코팅폭 (㎜/Lane)
								   ,SUM( CONVERT( FLOAT, REPLACE( COATING_WIDTH_SIDE, ',', '') ) ) AS COATING_WIDTH_SIDE--코팅폭 (㎜/Lane)
								   ,SUM( CONVERT( FLOAT, REPLACE(REPLACE(ISNULL (REPLACE( Loading, ',', ''), 0 ), char(13), ''), char(10), '') )) AS Loading -- Loading (㎎/25㎠)
								   ,SUM( CONVERT( FLOAT, REPLACE(REPLACE(ISNULL (REPLACE( BACK_Loading, ',', ''), 0 ), char(13), ''), char(10), '') ) )  AS BACK_Loading	-- BACK_Loading (㎜/Lane)
							--	   ,SUM( CONVERT( float, replace(replace(ISNULL (REPLACE( BOTTOM_LOADING, ',', ''), 0 ), char(13), ''), char(10), '') ) ) AS B_Loading		-- 2020-03-27 PIYONG DEL
								   ,ATTR_10	--	더블레이어 여부
								   ,MAX(A.ATTR_05)   AS APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
							  FROM (
									SELECT CMODEL_CODE
										   ,PROD_VER_CODE
										   ,ATTR_01 --  차수
									--	   ,CASE  LEFT(PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE					-- 2020-03-23 PIYONG DEL
										   ,ATTR_04 AS PLM_FACTORY_CODE
										   ,PRODID
										   ,AREA_ID
										   ,CASE WHEN SPEC_ITEM_ID IN ('I-P009-SPEC-P01' 
										                               ,'I-P014-SPEC-P01' ) AND VALUE1 IS NOT NULL AND  CONVERT(NUMERIC(10,2), VALUE1) > 0 THEN VALUE1 ELSE NULL END AS LANE_CNT_P --2022-09-05 leeseongmin [CSR :C20220905-000588]
																	   -- 2022-10-20 kimcd       Coating 폭 수 0으로 수신되는 경우 로직 보완
										   ,CASE /*WHEN SPEC_ITEM_ID IN ( 'I-P014-SPEC-019', 'I-P009-SPEC-019') AND ATTR_05 >= '2019-07-01' THEN
										   		CASE WHEN CHARINDEX('(',VALUE1 ) > 0 THEN
													CASE WHEN ISNUMERIC(RTRIM( SUBSTRING(VALUE1, 1 , CHARINDEX('(',VALUE1 ) -1) )) = 1 THEN 
													    CASE WHEN CONVERT(NUMERIC, RTRIM( SUBSTRING(VALUE1, 1 , CHARINDEX('(',VALUE1 ) -1) )) > 0 THEN RTRIM( SUBSTRING(VALUE1, 1 , CHARINDEX('(',VALUE1 ) -1) ) END
													END
												ELSE
													CASE WHEN ISNUMERIC(VALUE1) = 1 THEN 
														CASE WHEN CONVERT(NUMERIC,VALUE1) > 0 THEN VALUE1 END
													END
												END -- 2021-04-12 kimcd total coating 속성 추가 2021-06-24 kimcd 주석 처리 */
										   WHEN SPEC_ITEM_ID IN ( 
																			'I-E009-SPEC1E-003'
																			,'I-E009-SPEC1E-005'
																			,'I-E009-SPEC1E-007'
																			,'I-E009-SPEC1E-009'
																			,'I-A009-SPEC1E-003'
																			,'I-A009-SPEC1E-005'
																			,'I-A009-SPEC1E-007'
																			,'I-A009-SPEC1E-009'
																			,'I-A014-SPEC2-003'
																			,'I-A014-SPEC2-005'
																			,'I-A014-SPEC2-007'
																			,'I-A014-SPEC2-009'
																			,'I-E014-SPEC2-003'
																			,'I-E014-SPEC2-005'
																			,'I-E014-SPEC2-007'
																			,'I-E014-SPEC2-009'
																								) THEN 
														CASE WHEN CHARINDEX('(',VALUE2 ) > 0 THEN
																RTRIM( SUBSTRING(VALUE2, 1 , CHARINDEX('(',VALUE2 ) -1) )
															 ELSE
																VALUE2
															 END
																														END AS COATING_WIDTH--코팅폭 (㎜/Lane)
										   ,CASE WHEN SPEC_ITEM_ID IN ( 
																		'I-P014-SPEC-004'
																		,'I-P009-SPEC-004'
																		,'I-P014-SPEC-004'
																		,'I-P009-SPEC-004'
																							) AND VALUE2 IS NOT NULL THEN 
														CASE WHEN CHARINDEX('(',VALUE2 ) > 0 THEN
																RTRIM( SUBSTRING(VALUE2, 1 , CHARINDEX('(',VALUE2 ) -1) )
															 ELSE
																VALUE2
															 END
																														END AS COATING_WIDTH_CENTER--코팅 중앙 폭 (㎜/Lane)
										   ,CASE WHEN SPEC_ITEM_ID IN ( 
																		'I-P009-SPEC-005'
																		,'I-P014-SPEC-005'
																		,'I-P014-SPEC-005'
																		,'I-P009-SPEC-005'
																							) AND VALUE2 IS NOT NULL THEN 
														CASE WHEN CHARINDEX('(',VALUE2 ) > 0 THEN
																RTRIM( SUBSTRING(VALUE2, 1 , CHARINDEX('(',VALUE2 ) -1) )
															 ELSE
																VALUE2
															 END
																														END AS COATING_WIDTH_SIDE--코팅 사이드 폭 (㎜/Lane)
										   ,CASE WHEN ( SPEC_ITEM_ID IN ( 
																			'I-A009-SPEC-002'
																			,'I-A014-SPECA-002'
																			,'I-E009-SPECE-002'
																			,'I-E014-SPECA-002'
																			,'I-P014-SPEC-001'
																			,'I-P009-SPEC-001'
																								) -- OR
															/*	-- 2020-03-27 PIYONG DEL
															 ( CMODEL_CODE NOT LIKE 'ACEN%' AND SPEC_ITEM_ID IN ( 
																													'I-A009-SPEC-002B'
																													,'I-A014-SPECA-002B'
																													,'I-P014-SPEC-001B'
																													,'I-P009-SPEC-001B'
																																		)
															)	*/
														) AND VALUE2 NOT IN ( N'-' ) THEN
														CASE WHEN CHARINDEX('±',VALUE2 ) > 1THEN
																SUBSTRING(VALUE2 , 0, CHARINDEX(N'±',VALUE2 ) )
															ELSE
																 VALUE2
															END
																														 END AS Loading -- Loading (㎎/25㎠)
										   ,CASE WHEN ( SPEC_ITEM_ID IN ( 
																		 'I-A009-SPEC-002B'
																		 ,'I-A014-SPECA-002B'
																		 ,'I-P014-SPEC-001B'					-- 2020-03-27 PIYONG ADD
																		 ,'I-P009-SPEC-001B'					-- 2020-03-27 PIYONG ADD
																								)
														) AND VALUE2 NOT IN ( N'-', N'.' ) THEN
													CASE WHEN CHARINDEX('±',VALUE2 ) > 1THEN
															SUBSTRING(VALUE2 , 0, CHARINDEX(N'±',VALUE2 ) )
														 ELSE
															VALUE2
														 END
																														 END AS BACK_Loading -- BACK_Loading (㎎/25㎠)
										/*	-- 2020-03-27 PIYONG DEL
										   ,CASE WHEN SPEC_ITEM_ID IN ( 'I-A014-SPECA-001B') AND VALUE2 NOT IN ( N'-' ) AND AREA_ID = 'EC'THEN
													CASE WHEN CHARINDEX('±',VALUE2 ) > 1THEN
															SUBSTRING(VALUE2 , 0, CHARINDEX(N'±',VALUE2 ) )
														 ELSE
															VALUE2
														 END
																														 END AS BOTTOM_LOADING	*/
										   ,ATTR_10																							 -- 더블 레이어 여부
										   ,ATTR_05 -- 2020-07-10 kimcd ATTR_05 APPLY_DATE 적용일자 추가
										   ,SPEC_ITEM_ID
										   ,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
																		 ,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																			   WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																			   WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN 'S'
																			   WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																			   ELSE '-' END
																		 ,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
																   ORDER BY PROD_VER_CODE DESC
																		 ,ISNULL( ATTR_01, '00') DESC
																		 ,WO_ID DESC
																		 ,CASE WHEN UNIT != 'KG' AND VALUE2 IS NOT NULL THEN 1 ELSE 2 END
																		 ,IF_SEQ DESC														) NUM
									  FROM #PLM_ITEM_CONV_CALC			--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
								     WHERE CELLTYPE = 'POUCH'
									   AND ATTR_04 IS NULL
									   AND PROC_ID = 'E2000'			--2020-03-27 PIYONG ADD
							   --	   AND PROC_FLAG = 'P'				--2019-04-26 PIYONG DEL
									UNION ALL
									SELECT CMODEL_CODE
										   ,CASE WHEN AREA_ID = 'EA' THEN
													CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
															CONCAT(PROD_VER_CODE,'2')
														 ELSE
															CONCAT(PROD_VER_CODE,'3')
														 END
												  ELSE
													PROD_VER_CODE
												  END PROD_VER_CODE
										   ,ATTR_01 --  차수
									--	   ,CASE  LEFT(PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE						-- 2020-03-23 PIYONG DEL
										   ,ATTR_04 AS PLM_FACTORY_CODE
										   ,PRODID
										   ,AREA_ID
										   ,CASE WHEN SPEC_ITEM_ID IN ('I-P009-SPEC-P01' 
										                               ,'I-P014-SPEC-P01' ) AND VALUE1 IS NOT NULL AND  CONVERT(NUMERIC(10,2), VALUE1) > 0 THEN VALUE1 ELSE NULL END AS LANE_CNT_P --2022-09-05 leeseongmin [CSR :C20220905-000588]
																	   -- 2022-10-20 kimcd       Coating 폭 수 0으로 수신되는 경우 로직 보완
										   /*	-- 2020-03-27 PIYONG DEL
										   ,CASE WHEN UNIT = 'KG' AND SPEC_ITEM_ID IN (
																						'I-P001-SPEC-016_1'
																						,'I-P001-SPEC-016_2'
																						,'I-P002-SPEC-009_1'
																						,'I-P002-SPEC-009_2'
																						,'I-E001-SPEC-016_1'
																						,'I-E001-SPEC-016_2'
																						,'I-E002-SPEC-009_1'
																						,'I-E002-SPEC-009_2'
																						,'I-A002-SPEC-009_1'
																						,'I-A002-SPEC-009_2'
																						,'I-A001-SPEC-016_1'
																						,'I-A001-SPEC-016_2'
																						,'I-A002-SPEC-009_1'
																						,'I-A002-SPEC-009_2'
																											) THEN VALUE1 END AS Solids_amount--고형분	*/
											,CASE /*WHEN SPEC_ITEM_ID IN ( 'I-P014-SPEC-019', 'I-P009-SPEC-019') AND ATTR_05 >= '2019-07-01' THEN
										   		CASE WHEN CHARINDEX('(',VALUE1 ) > 0 THEN
													CASE WHEN ISNUMERIC(RTRIM( SUBSTRING(VALUE1, 1 , CHARINDEX('(',VALUE1 ) -1) )) = 1 THEN 
													    CASE WHEN CONVERT(NUMERIC, RTRIM( SUBSTRING(VALUE1, 1 , CHARINDEX('(',VALUE1 ) -1) )) > 0 THEN RTRIM( SUBSTRING(VALUE1, 1 , CHARINDEX('(',VALUE1 ) -1) ) END
													END
												ELSE
													CASE WHEN ISNUMERIC(VALUE1) = 1 THEN 
														CASE WHEN CONVERT(NUMERIC,VALUE1) > 0 THEN VALUE1 END
													END
												END -- 2021-04-12 kimcd total coating 속성 추가 2021-06-24 kimcd 주석 처리 */
										   WHEN SPEC_ITEM_ID IN ( 
																			'I-E009-SPEC1E-003'
																			,'I-E009-SPEC1E-005'
																			,'I-E009-SPEC1E-007'
																			,'I-E009-SPEC1E-009'
																			,'I-A009-SPEC1E-003'
																			,'I-A009-SPEC1E-005'
																			,'I-A009-SPEC1E-007'
																			,'I-A009-SPEC1E-009'
																			,'I-A014-SPEC2-003'
																			,'I-A014-SPEC2-005'
																			,'I-A014-SPEC2-007'
																			,'I-A014-SPEC2-009'
																			,'I-E014-SPEC2-003'
																			,'I-E014-SPEC2-005'
																			,'I-E014-SPEC2-007'
																			,'I-E014-SPEC2-009'
																								) THEN 
														CASE WHEN CHARINDEX('(',VALUE2 ) > 0 THEN
																RTRIM( SUBSTRING(VALUE2, 1 , CHARINDEX('(',VALUE2 ) -1) )
															 ELSE
																VALUE2
															 END
																														END AS COATING_WIDTH--코팅폭 (㎜/Lane)
											,CASE WHEN SPEC_ITEM_ID IN ( 
																			'I-P014-SPEC-004'
																			,'I-P009-SPEC-004'
																			,'I-P014-SPEC-004'
																			,'I-P009-SPEC-004'
																								) AND VALUE2 IS NOT NULL THEN 
														CASE WHEN CHARINDEX('(',VALUE2 ) > 0 THEN
																RTRIM( SUBSTRING(VALUE2, 1 , CHARINDEX('(',VALUE2 ) -1) )
															 ELSE
																VALUE2
															 END
																														END AS COATING_WIDTH_CENTER--코팅 중앙 폭 (㎜/Lane)
										    ,CASE WHEN SPEC_ITEM_ID IN ( 
																		'I-P009-SPEC-005'
																		,'I-P014-SPEC-005'
																		,'I-P014-SPEC-005'
																		,'I-P009-SPEC-005'
																							) AND VALUE2 IS NOT NULL THEN 
														CASE WHEN CHARINDEX('(',VALUE2 ) > 0 THEN
																RTRIM( SUBSTRING(VALUE2, 1 , CHARINDEX('(',VALUE2 ) -1) )
															 ELSE
																VALUE2
															 END
																														END AS COATING_WIDTH_SIDE--코팅 사이드 폭 (㎜/Lane)
											,CASE WHEN ( SPEC_ITEM_ID IN ( 
																			'I-A009-SPEC-002'
																			,'I-A014-SPECA-002'
																			,'I-E009-SPECE-002'
																			,'I-E014-SPECA-002'
																			,'I-P014-SPEC-001'
																			,'I-P009-SPEC-001'
																								)
															 
														) AND VALUE2 NOT IN ( N'-' ) THEN
														CASE WHEN CHARINDEX('±',VALUE2 ) > 1THEN
																SUBSTRING(VALUE2 , 0, CHARINDEX(N'±',VALUE2 ) )
															ELSE
																 VALUE2
															END
																														 END AS Loading -- Loading (㎎/25㎠)
										   ,CASE WHEN ( SPEC_ITEM_ID IN ( 
																		 'I-A009-SPEC-002B'
																		 ,'I-A014-SPECA-002B'
																		 ,'I-P014-SPEC-001B'					-- 2020-03-27 PIYONG ADD
																		 ,'I-P009-SPEC-001B'					-- 2020-03-27 PIYONG ADD
																								)
														) AND VALUE2 NOT IN ( N'-' ) THEN
													CASE WHEN CHARINDEX('±',VALUE2 ) > 1THEN
															SUBSTRING(VALUE2 , 0, CHARINDEX(N'±',VALUE2 ) )
														 ELSE
															VALUE2
														 END
																														 END AS BACK_Loading -- BACK_Loading (㎎/25㎠)
										/*	-- 2020-03-27 PIYONG DEL
										   ,CASE WHEN SPEC_ITEM_ID IN ( 'I-A014-SPECA-001B') AND VALUE2 NOT IN ( N'-' ) AND AREA_ID = 'EC'THEN
													CASE WHEN CHARINDEX('±',VALUE2 ) > 1THEN
															SUBSTRING(VALUE2 , 0, CHARINDEX(N'±',VALUE2 ) )
														 ELSE
															VALUE2
														 END
																														 END AS BOTTOM_LOADING	*/
										   ,ATTR_10																							 -- 더블 레이어 여부
										   ,ATTR_05 -- 2020-07-10 kimcd ATTR_05 APPLY_DATE 적용일자 추가
										   ,SPEC_ITEM_ID
										   ,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
																		 ,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																			   WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																			   WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN 'S'
																			   WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																			   ELSE '-' END
																		 ,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
															       ORDER BY PROD_VER_CODE DESC
																		 ,ISNULL( ATTR_01, '00') DESC
																		 ,WO_ID DESC
																		 ,CASE WHEN UNIT != 'KG' AND VALUE2 IS NOT NULL THEN 1 ELSE 2 END
																		 ,IF_SEQ DESC														) NUM
									  FROM #PLM_ITEM_CONV_CALC			--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
								     WHERE CELLTYPE = 'POUCH'
									   AND ATTR_04 IS NOT NULL
									   AND PROC_ID = 'E2000'			--2020-03-27 PIYONG ADD
								--	   AND PROC_FLAG = 'P'				--2019-04-26 PIYONG DEL
								   ) A
								   INNER JOIN SCM_FACTORY_M F
										   ON A.AREA_ID = F.FACTORY_ID
										WHERE NUM =1
								--	     AND CMODEL_CODE ='ACEN4069I-A1'
								--		 AND AREA_ID = 'E4'
								--		 AND PROD_VER_CODE = '014'
									   GROUP BY CMODEL_CODE
											,PROD_VER_CODE
											,ATTR_01 --  차수
								--			,VERSION_TYPE			-- 2020-03-23 PIYONG DEL
											,PLM_FACTORY_CODE
											,PRODID
											,AREA_ID
											,F.COMPANY_ID
											,F.DIVISION_ID
											,F.SITE_ID
											,F.PLANT_ID
											,ATTR_10	--	더블레이어 여부
						   ) A
						   INNER JOIN SCM_SYS_LOOKUP_VALUE SSLV
								   ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
								  AND SEGMENT4 = A.AREA_ID
								  AND SEGMENT5 = ISNULL(A.PLM_FACTORY_CODE, '-')
						   INNER JOIN #LANE_INFO L
								   ON A.COMPANY_ID		= L.COMPANY_ID
								  AND A.DIVISION_ID		= L.DIVISION_ID
								  AND A.SITE_ID			= L.SITE_ID
								  AND A.PLANT_ID		= L.PLANT_ID
								  AND A.AREA_ID			= L.AREA_ID
								  AND A.PRODID			= L.PRODID
								  AND SSLV.ATTRIBUTE1   = L.PROD_VERSION_TYPE
					---------------------------------------------------------------------------------------------------------------------------
					---------------------------------------------------------------------------------------------------------------------------
					-------------------------------------			POUCH 단면				---------------------------------------------------
					---------------------------------------------------------------------------------------------------------------------------
					---------------------------------------------------------------------------------------------------------------------------
					UNION ALL
					SELECT A.COMPANY_ID
						   ,A.DIVISION_ID
						   ,A.SITE_ID
						   ,A.PLANT_ID
						   ,A.CMODEL_CODE
						   ,A.PROD_VER_CODE
						   ,A.ATTR_01 --  차수
						   ,CASE  LEFT(PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE
						   ,L.PROD_VERSION_TYPE
						   ,A.PRODID
						   ,A.AREA_ID
					--	   ,A.Solids_amount																							-- 2020-03-27 PIYONG DEL
						   ,A.COATING_WIDTH_CENTER 
						   ,A.COATING_WIDTH_SIDE
						   ,L.LANE_CNT
						   ,CASE WHEN A.COATING_WIDTH IS NOT NULL THEN
									CASE WHEN RIGHT(A.PROD_VER_CODE, '1') = 'W' AND A.AREA_ID = 'E7' THEN
											A.COATING_WIDTH -- + 20 2020-11-09 kimcd E7 코팅폭 산출 로직 수정
										 WHEN RIGHT(A.PROD_VER_CODE, '1') != 'W' AND A.AREA_ID = 'E7' THEN
											CASE WHEN A.CMODEL_CODE LIKE 'E%' THEN A.COATING_WIDTH ELSE A.COATING_WIDTH + 10 END
												-- 2020-11-09 kimcd E7 코팅폭 산출 로직 수정
										 ELSE
											A.COATING_WIDTH
										 END
								  ELSE
									CASE WHEN A.AREA_ID != 'E4' THEN
											CASE WHEN A.COATING_WIDTH_CENTER = A.COATING_WIDTH_SIDE THEN							-- 중앙 폭 과 사이드 폭이 같을 경우
												CASE WHEN  RIGHT(A.PROD_VER_CODE, '1') = 'W' AND A.AREA_ID = 'E7' THEN
															( A.COATING_WIDTH_CENTER * CASE WHEN A.LANE_CNT_P IS NULL THEN L.LANE_CNT ELSE A.LANE_CNT_P END ) -- + 20  2020-11-09 kimcd E7 코팅폭 산출 로직 수정 (코팅패턴)  --2022-09-05 leeseongmin [CSR :C20220905-000588]
														 WHEN  RIGHT(A.PROD_VER_CODE, '1') != 'W' AND A.AREA_ID = 'E7' THEN
															CASE WHEN A.CMODEL_CODE LIKE 'E%' THEN ( A.COATING_WIDTH_CENTER * CASE WHEN A.LANE_CNT_P IS NULL THEN L.LANE_CNT ELSE A.LANE_CNT_P END ) ELSE ( A.COATING_WIDTH_CENTER * CASE WHEN A.LANE_CNT_P IS NULL THEN L.LANE_CNT ELSE A.LANE_CNT_P END ) + 10 END --(코탕패턴)  --2022-09-05 leeseongmin [CSR :C20220905-000588]
																-- 2020-11-09 kimcd E7 코팅폭 산출 로직 수정
														 ELSE
															( A.COATING_WIDTH_CENTER * CASE WHEN A.LANE_CNT_P IS NULL THEN L.LANE_CNT ELSE A.LANE_CNT_P END ) + 10
														 END
												 WHEN A.COATING_WIDTH_CENTER IS NOT NULL AND ( A.COATING_WIDTH_SIDE IS NULL OR A.COATING_WIDTH_SIDE = 0 ) THEN		-- 중앙 폭만 있고 광폭이 아닐 경우
													CASE WHEN  RIGHT(A.PROD_VER_CODE, '1') = 'W' AND A.AREA_ID = 'E7' THEN
															( A.COATING_WIDTH_CENTER * L.LANE_CNT ) -- + 20  2020-11-09 kimcd E7 코팅폭 산출 로직 수정
														 WHEN  RIGHT(A.PROD_VER_CODE, '1') != 'W' AND A.AREA_ID = 'E7' THEN
														     CASE WHEN A.CMODEL_CODE LIKE 'E%' THEN ( A.COATING_WIDTH_CENTER * L.LANE_CNT ) ELSE ( A.COATING_WIDTH_CENTER * L.LANE_CNT ) + 10 END
																-- 2020-11-09 kimcd E7 코팅폭 산출 로직 수정
														 WHEN A.CMODEL_CODE LIKE 'ACE%' AND A.AREA_ID = 'E3' THEN					-- 자동차 모델을 오창소형2동에서 하는 모델일 경우
															A.COATING_WIDTH_CENTER  + 10
														 ELSE
															( A.COATING_WIDTH_CENTER * L.LANE_CNT ) + 10
														 END
												 ELSE
													CASE WHEN  RIGHT(A.PROD_VER_CODE, '1') = 'W' AND A.AREA_ID = 'E7' THEN
															( ( A.COATING_WIDTH_CENTER * ( L.LANE_CNT -1 )) + ( ISNULL(A.COATING_WIDTH_SIDE, 0 ) * 2 ) ) -- + 20  2020-11-09 kimcd E7 코팅폭 산출 로직 수정
														 WHEN  RIGHT(A.PROD_VER_CODE, '1') != 'W' AND A.AREA_ID = 'E7' THEN
														    CASE WHEN A.CMODEL_CODE LIKE 'E%' THEN
															    ( ( A.COATING_WIDTH_CENTER * ( L.LANE_CNT -1 )) + ( ISNULL(A.COATING_WIDTH_SIDE, 0 ) * 2 ) )
															ELSE ( ( A.COATING_WIDTH_CENTER * ( L.LANE_CNT -1 )) + ( ISNULL(A.COATING_WIDTH_SIDE, 0 ) * 2 ) ) + 10 END
																-- 2020-11-09 kimcd E7 코팅폭 산출 로직 수정
														 ELSE
															( ( A.COATING_WIDTH_CENTER * ( L.LANE_CNT -1 )) + ( ISNULL(A.COATING_WIDTH_SIDE, 0 ) * 2 ) ) + 10
														 END
												 END
										  ELSE
											CASE WHEN A.COATING_WIDTH_CENTER IS NOT NULL AND  A.COATING_WIDTH_SIDE IS NULL THEN		-- 중앙 폭만 있고 광폭일 경우
													( ( A.COATING_WIDTH_CENTER * L.LANE_CNT )  + 10 )
												 WHEN A.COATING_WIDTH_CENTER = A.COATING_WIDTH_SIDE THEN							-- 중앙 폭과 사이드 폭이 같고 광폭일 경우
													( ( A.COATING_WIDTH_CENTER * L.LANE_CNT )  + 10 )
												 WHEN A.COATING_WIDTH_CENTER IS NOT NULL AND  A.COATING_WIDTH_SIDE IS NOT NULL THEN	-- 중앙 폭, 사이드 폭이 있고 광폭일 경우
													( ( ( A.COATING_WIDTH_CENTER * ( L.LANE_CNT -1 )) + ( ISNULL(A.COATING_WIDTH_SIDE, 0 ) * 2 ) ) + 10 )
												 END
										 END
								 END COATING_WIDTH
					--	   ,CASE WHEN ATTR_10 = 'Y' AND A.AREA_ID = 'EA' AND Loading > BACK_Loading THEN Loading - BACK_Loading  ELSE A.Loading END Loading
							--------------------------------------------------------------------------------------------------------------------------------------------------
							-- 2020-03-27 PIYIONG CHANGE
							,CASE WHEN A.DIVISION_ID = '81' THEN
									CASE WHEN A.AREA_ID = 'EC' AND BACK_Loading != 0 THEN
											BACK_Loading
										 WHEN ATTR_10 = 'Y' AND A.AREA_ID = 'EA' AND Loading > BACK_Loading THEN
											Loading - BACK_Loading  
										 ELSE
											Loading
										 END
									WHEN A.DIVISION_ID = '40' AND LEFT(A.CMODEL_CODE, 1) = 'A' THEN
										Loading
									-- 2022-01-07 kimcd E7동 파우치 DLD 예외 로직 제거 WHEN A.AREA_ID = 'E7' AND A.ATTR_10 = 'Y' AND A.PRODID LIKE 'APCA%' THEN
									--	Loading  -- 2020-12-10 kimcd E7동 double layer인 경우 Top만 사용
									ELSE
										Loading + CASE WHEN A.AREA_ID = 'E7' AND A.ATTR_10 = 'Y' AND A.PRODID LIKE 'APCA%' AND BACK_Loading = 0 THEN Loading ELSE BACK_Loading END
										-- 2022-01-07 kimcd E7동 파우치 DLD 예외 로직 변경. bottom에 coating 없는 경우 대비용
									END AS Loading
					--	   ,NULL AS B_Loading	-- 2020-03-27 PIYONG DEL
							-- 2020-03-27 PIYIONG CHANGE END
							--------------------------------------------------------------------------------------------------------------------------------------------------
						   ,APPLY_DATE -- 2020-07-10 kimcd ATTR_05 APPLY_DATE 적용일자 추가
					  FROM (
							SELECT F.COMPANY_ID
								   ,F.DIVISION_ID
								   ,F.SITE_ID
								   ,F.PLANT_ID
								   ,CMODEL_CODE
								   ,PROD_VER_CODE
								   ,ATTR_01 --  차수
							--	   ,VERSION_TYPE			--2020-03-23 PIYONG DEL
								   ,PLM_FACTORY_CODE
								   ,PRODID
								   ,AREA_ID
								   ,MAX( CONVERT( FLOAT, LANE_CNT_P)) as  LANE_CNT_P --2022-09-05 leeseongmin [CSR :C20220905-000588 ]
							--	   ,SUM( CONVERT( FLOAT, REPLACE( Solids_amount, ',', '') ) ) AS Solids_amount													--고형분		-- 2020-03-27 PIYONG DEL
								   ,SUM( CONVERT( FLOAT, REPLACE( COATING_WIDTH, ',', '') ) ) AS COATING_WIDTH													--코팅폭 (㎜/Lane)
								   ,SUM( CONVERT( FLOAT, REPLACE( COATING_WIDTH_CENTER, ',', '') ) ) AS COATING_WIDTH_CENTER									--코팅폭 (㎜/Lane)
								   ,SUM( CONVERT( FLOAT, REPLACE( COATING_WIDTH_SIDE, ',', '') ) ) AS COATING_WIDTH_SIDE										--코팅폭 (㎜/Lane)
								   ,SUM( CONVERT( FLOAT, REPLACE(REPLACE(ISNULL (REPLACE( Loading, ',', ''), 0 ), char(13), ''), char(10), '') )) AS Loading	-- Loading (㎎/25㎠)
								   ,SUM( CONVERT( FLOAT, REPLACE(REPLACE(ISNULL (REPLACE( BACK_Loading, ',', ''), 0 ), char(13), ''), char(10), '') ) )  AS BACK_Loading	-- BACK_Loading (㎜/Lane)
								   ,ATTR_10	--	더블레이어 여부
								   ,MAX(A.ATTR_05)  AS APPLY_DATE -- 2020-07-10 kimcd ATTR_05 APPLY_DATE 적용일자 추가
							  FROM (
									SELECT CMODEL_CODE
										   ,PROD_VER_CODE
										   ,ATTR_01 --  차수
									--	   ,CASE  LEFT(PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE				-- 2020-03-23 PIYONG DEL
										   ,ATTR_04 AS PLM_FACTORY_CODE
										   ,ATTR_07 AS PRODID --단면 반제품 코드
										   ,AREA_ID
										   ,CASE WHEN SPEC_ITEM_ID IN ('I-P009-SPEC-P01' 
										                               ,'I-P014-SPEC-P01' ) AND VALUE1 IS NOT NULL AND  CONVERT(NUMERIC(10,2), VALUE1) > 0 THEN VALUE1 ELSE NULL END AS LANE_CNT_P --2022-09-05 leeseongmin [CSR :C20220905-000588]
																	   -- 2022-10-20 kimcd       Coating 폭 수 0으로 수신되는 경우 로직 보완
										   /*	-- 2020-03-27 PIYONG DEL
										   ,CASE WHEN UNIT = 'KG' AND SPEC_ITEM_ID IN (
																						'I-P001-SPEC-016_1'
																						,'I-P001-SPEC-016_2'
																						,'I-P002-SPEC-009_1'
																						,'I-P002-SPEC-009_2'
																						,'I-E001-SPEC-016_1'
																						,'I-E001-SPEC-016_2'
																						,'I-E002-SPEC-009_1'
																						,'I-E002-SPEC-009_2'
																						,'I-A002-SPEC-009_1'
																						,'I-A002-SPEC-009_2'
																						,'I-A001-SPEC-016_1'
																						,'I-A001-SPEC-016_2'
																						,'I-A002-SPEC-009_1'
																						,'I-A002-SPEC-009_2'
																											) THEN VALUE1 END AS Solids_amount--고형분	*/
										   ,CASE /* WHEN SPEC_ITEM_ID IN ( 'I-P014-SPEC-019', 'I-P009-SPEC-019') AND ATTR_05 >= '2019-07-01' THEN
										   		CASE WHEN CHARINDEX('(',VALUE1 ) > 0 THEN
													CASE WHEN ISNUMERIC(RTRIM( SUBSTRING(VALUE1, 1 , CHARINDEX('(',VALUE1 ) -1) )) = 1 THEN 
													    CASE WHEN CONVERT(NUMERIC, RTRIM( SUBSTRING(VALUE1, 1 , CHARINDEX('(',VALUE1 ) -1) )) > 0 THEN RTRIM( SUBSTRING(VALUE1, 1 , CHARINDEX('(',VALUE1 ) -1) ) END
													END
												ELSE
													CASE WHEN ISNUMERIC(VALUE1) = 1 THEN 
														CASE WHEN CONVERT(NUMERIC,VALUE1) > 0 THEN VALUE1 END
													END
												END -- 2021-04-12 kimcd total coating 속성 추가 2021-06-24 kimcd 주석 처리 */
										   WHEN SPEC_ITEM_ID IN ( 
																			'I-E009-SPEC1E-003'
																			,'I-E009-SPEC1E-005'
																			,'I-E009-SPEC1E-007'
																			,'I-E009-SPEC1E-009'
																			,'I-A009-SPEC1E-003'
																			,'I-A009-SPEC1E-005'
																			,'I-A009-SPEC1E-007'
																			,'I-A009-SPEC1E-009'
																			,'I-A014-SPEC2-003'
																			,'I-A014-SPEC2-005'
																			,'I-A014-SPEC2-007'
																			,'I-A014-SPEC2-009'
																			,'I-E014-SPEC2-003'
																			,'I-E014-SPEC2-005'
																			,'I-E014-SPEC2-007'
																			,'I-E014-SPEC2-009'

																								) THEN 
														CASE WHEN CHARINDEX('(',VALUE2 ) > 0 THEN
																RTRIM( SUBSTRING(VALUE2, 1 , CHARINDEX('(',VALUE2 ) -1) )
															 ELSE
																VALUE2
															 END
																														END AS COATING_WIDTH		--코팅폭 (㎜/Lane)
											,CASE WHEN SPEC_ITEM_ID IN ( 
																		'I-P014-SPEC-004'
																		,'I-P009-SPEC-004'
																		,'I-P014-SPEC-004'
																		,'I-P009-SPEC-004'
																							) AND VALUE2 IS NOT NULL THEN 
														CASE WHEN CHARINDEX('(',VALUE2 ) > 0 THEN
																RTRIM( SUBSTRING(VALUE2, 1 , CHARINDEX('(',VALUE2 ) -1) )
															 ELSE
																VALUE2
															 END
																														END AS COATING_WIDTH_CENTER	--코팅 중앙 폭 (㎜/Lane)
											,CASE WHEN SPEC_ITEM_ID IN ( 
																		'I-P009-SPEC-005'
																		,'I-P014-SPEC-005'
																		,'I-P014-SPEC-005'
																		,'I-P009-SPEC-005'
																							) AND VALUE2 IS NOT NULL THEN 
														CASE WHEN CHARINDEX('(',VALUE2 ) > 0 THEN
																RTRIM( SUBSTRING(VALUE2, 1 , CHARINDEX('(',VALUE2 ) -1) )
															 ELSE
																VALUE2
															 END
																														END AS COATING_WIDTH_SIDE	--코팅 사이드 폭 (㎜/Lane)
											,CASE WHEN ( SPEC_ITEM_ID IN ( 
																			'I-A009-SPEC-002'
																			,'I-A014-SPECA-002'
																			,'I-E009-SPECE-002'
																			,'I-E014-SPECA-002'
																			,'I-P014-SPEC-001'
																			,'I-P009-SPEC-001'
																								)
														) AND VALUE2 NOT IN ( N'-' ) THEN
														CASE WHEN CHARINDEX('±',VALUE2 ) > 1THEN
																SUBSTRING(VALUE2 , 0, CHARINDEX(N'±',VALUE2 ) )
															ELSE
																 VALUE2
															END
																														 END AS Loading				-- Loading (㎎/25㎠)
										   ,CASE WHEN ( SPEC_ITEM_ID IN ( 
																		 'I-A009-SPEC-002B'
																		 ,'I-A014-SPECA-002B'
																		 ,'I-P014-SPEC-001B'					-- 2020-03-27 PIYONG ADD
																		 ,'I-P009-SPEC-001B'					-- 2020-03-27 PIYONG ADD
																								)
														) AND VALUE2 NOT IN ( N'-' ) THEN
													CASE WHEN CHARINDEX('±',VALUE2 ) > 1THEN
															SUBSTRING(VALUE2 , 0, CHARINDEX(N'±',VALUE2 ) )
														 ELSE
															VALUE2
														 END
																														 END AS BACK_Loading		-- BACK_Loading (㎎/25㎠)
										   ,ATTR_10																									-- 더블 레이어 여부
										   ,ATTR_05  -- 2020-07-10 kimcd ATTR_05 APPLY_DATE 적용일자 추가
										   ,SPEC_ITEM_ID
										   ,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
																		 ,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																			   WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																			   WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN 'S'
																			   WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																			   ELSE '-' END
																		 ,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
																   ORDER BY PROD_VER_CODE DESC
																		 ,ISNULL( ATTR_01, '00') DESC
																		 ,WO_ID DESC
																		 ,CASE WHEN UNIT != 'KG' AND VALUE2 IS NOT NULL THEN 1 ELSE 2 END
																		 ,IF_SEQ DESC														) NUM
									  FROM #PLM_ITEM_CONV_CALC			--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
								     WHERE CELLTYPE = 'POUCH'
							  --	   AND PROC_FLAG = 'P'				--2019-04-26 PIYONG DEL
									   AND ATTR_04 IS NULL
									   AND ATTR_07 IS NOT NULL
									   AND PROC_ID = 'E2000'			--2020-03-27 PIYONG ADD
									UNION ALL
									SELECT CMODEL_CODE
										   ,CASE WHEN AREA_ID = 'EA' THEN
													CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
															CONCAT(PROD_VER_CODE,'2')
														 ELSE
															CONCAT(PROD_VER_CODE,'3')
														 END
												  ELSE
													PROD_VER_CODE
												  END PROD_VER_CODE
										   ,ATTR_01 --  차수
									--	   ,CASE  LEFT(PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE				-- 2020-03-23 PIYONG DEL
										   ,ATTR_04 AS PLM_FACTORY_CODE
										   ,ATTR_07 AS PRODID
										   ,AREA_ID
										   ,CASE WHEN SPEC_ITEM_ID IN ('I-P009-SPEC-P01' 
										                               ,'I-P014-SPEC-P01' ) AND VALUE1 IS NOT NULL AND  CONVERT(NUMERIC(10,2), VALUE1) > 0 THEN VALUE1 ELSE NULL END AS LANE_CNT_P --2022-09-05 leeseongmin [CSR :C20220905-000588]
																	   -- 2022-10-20 kimcd       Coating 폭 수 0으로 수신되는 경우 로직 보완
										   /*	-- 2020-03-27 PIYONG DEL
										   ,CASE WHEN UNIT = 'KG' AND SPEC_ITEM_ID IN (
																						'I-P001-SPEC-016_1'
																						,'I-P001-SPEC-016_2'
																						,'I-P002-SPEC-009_1'
																						,'I-P002-SPEC-009_2'
																						,'I-E001-SPEC-016_1'
																						,'I-E001-SPEC-016_2'
																						,'I-E002-SPEC-009_1'
																						,'I-E002-SPEC-009_2'
																						,'I-A002-SPEC-009_1'
																						,'I-A002-SPEC-009_2'
																						,'I-A001-SPEC-016_1'
																						,'I-A001-SPEC-016_2'
																						,'I-A002-SPEC-009_1'
																						,'I-A002-SPEC-009_2'
																											) THEN VALUE1 END AS Solids_amount	--고형분	*/
											,CASE /* WHEN SPEC_ITEM_ID IN ( 'I-P014-SPEC-019', 'I-P009-SPEC-019') AND ATTR_05 >= '2019-07-01' THEN
										   		CASE WHEN CHARINDEX('(',VALUE1 ) > 0 THEN
													CASE WHEN ISNUMERIC(RTRIM( SUBSTRING(VALUE1, 1 , CHARINDEX('(',VALUE1 ) -1) )) = 1 THEN 
													    CASE WHEN CONVERT(NUMERIC, RTRIM( SUBSTRING(VALUE1, 1 , CHARINDEX('(',VALUE1 ) -1) )) > 0 THEN RTRIM( SUBSTRING(VALUE1, 1 , CHARINDEX('(',VALUE1 ) -1) ) END
													END
												ELSE
													CASE WHEN ISNUMERIC(VALUE1) = 1 THEN 
														CASE WHEN CONVERT(NUMERIC,VALUE1) > 0 THEN VALUE1 END
													END
												END -- 2021-04-12 kimcd total coating 속성 추가 2021-06-24 kimcd 주석 처리 */
										   WHEN SPEC_ITEM_ID IN ( 
																			'I-E009-SPEC1E-003'
																			,'I-E009-SPEC1E-005'
																			,'I-E009-SPEC1E-007'
																			,'I-E009-SPEC1E-009'
																			,'I-A009-SPEC1E-003'
																			,'I-A009-SPEC1E-005'
																			,'I-A009-SPEC1E-007'
																			,'I-A009-SPEC1E-009'
																			,'I-A014-SPEC2-003'
																			,'I-A014-SPEC2-005'
																			,'I-A014-SPEC2-007'
																			,'I-A014-SPEC2-009'
																			,'I-E014-SPEC2-003'
																			,'I-E014-SPEC2-005'
																			,'I-E014-SPEC2-007'
																			,'I-E014-SPEC2-009'
																								) THEN 
														CASE WHEN CHARINDEX('(',VALUE2 ) > 0 THEN
																RTRIM( SUBSTRING(VALUE2, 1 , CHARINDEX('(',VALUE2 ) -1) )
															 ELSE
																VALUE2
															 END
																														END AS COATING_WIDTH	--코팅폭 (㎜/Lane)
											,CASE WHEN SPEC_ITEM_ID IN ( 
																			'I-P014-SPEC-004'
																			,'I-P009-SPEC-004'
																			,'I-P014-SPEC-004'
																			,'I-P009-SPEC-004'
																								) AND VALUE2 IS NOT NULL THEN 
														CASE WHEN CHARINDEX('(',VALUE2 ) > 0 THEN
																RTRIM( SUBSTRING(VALUE2, 1 , CHARINDEX('(',VALUE2 ) -1) )
															 ELSE
																VALUE2
															 END
																														END AS COATING_WIDTH_CENTER	--코팅 중앙 폭 (㎜/Lane)
											,CASE WHEN SPEC_ITEM_ID IN ( 
																		'I-P009-SPEC-005'
																		,'I-P014-SPEC-005'
																		,'I-P014-SPEC-005'
																		,'I-P009-SPEC-005'
																							) AND VALUE2 IS NOT NULL THEN 
														CASE WHEN CHARINDEX('(',VALUE2 ) > 0 THEN
																RTRIM( SUBSTRING(VALUE2, 1 , CHARINDEX('(',VALUE2 ) -1) )
															 ELSE
																VALUE2
															 END
																														END AS COATING_WIDTH_SIDE	--코팅 사이드 폭 (㎜/Lane)
											,CASE WHEN ( SPEC_ITEM_ID IN ( 
																			'I-A009-SPEC-002'
																			,'I-A014-SPECA-002'
																			,'I-E009-SPECE-002'
																			,'I-E014-SPECA-002'
																			,'I-P014-SPEC-001'
																			,'I-P009-SPEC-001'
																								)
														) AND VALUE2 NOT IN ( N'-' ) THEN
														CASE WHEN CHARINDEX('±',VALUE2 ) > 1THEN
																SUBSTRING(VALUE2 , 0, CHARINDEX(N'±',VALUE2 ) )
															ELSE
																 VALUE2
															END
																														 END AS Loading				-- Loading (㎎/25㎠)
										   ,CASE WHEN ( SPEC_ITEM_ID IN ( 
																		 'I-A009-SPEC-002B'
																		 ,'I-A014-SPECA-002B'
																		 ,'I-P014-SPEC-001B'					-- 2020-03-27 PIYONG ADD
																		 ,'I-P009-SPEC-001B'					-- 2020-03-27 PIYONG ADD
																								)
														) AND VALUE2 NOT IN ( N'-' ) THEN
													CASE WHEN CHARINDEX('±',VALUE2 ) > 1THEN
															SUBSTRING(VALUE2 , 0, CHARINDEX(N'±',VALUE2 ) )
														 ELSE
															VALUE2
														 END
																														 END AS BACK_Loading -- BACK_Loading (㎎/25㎠)
										   ,ATTR_10																							 -- 더블 레이어 여부
										   ,ATTR_05 -- 2020-07-10 kimcd ATTR_05 APPLY_DATE 적용일자 추가
										   ,SPEC_ITEM_ID
										   ,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
																		 ,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																			   WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																			   WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN 'S'
																			   WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																			   ELSE '-' END
																		 ,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
															       ORDER BY PROD_VER_CODE DESC
																		 ,ISNULL( ATTR_01, '00') DESC
																		 ,WO_ID DESC
																		 ,CASE WHEN UNIT != 'KG' AND VALUE2 IS NOT NULL THEN 1 ELSE 2 END
																		 ,IF_SEQ DESC														) NUM
									  FROM #PLM_ITEM_CONV_CALC			--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
								     WHERE CELLTYPE = 'POUCH'
								 --	   AND PROC_FLAG = 'P'				--2019-04-26 PIYONG DEL
									   AND ATTR_04 IS NOT NULL
									   AND ATTR_07 IS NOT NULL
									   AND PROC_ID = 'E2000'			--2020-03-27 PIYONG ADD
								   ) A
								   INNER JOIN SCM_FACTORY_M F
										   ON A.AREA_ID = F.FACTORY_ID
										WHERE NUM =1
								--	     AND CMODEL_CODE ='MIF409858B11'
								--		 AND AREA_ID = 'E4'
								--		 AND PROD_VER_CODE = '014'
									   GROUP BY CMODEL_CODE
											,PROD_VER_CODE
											,ATTR_01 --  차수
										--	,VERSION_TYPE				-- 2020-03-03 PIYONG DEL
											,PLM_FACTORY_CODE
											,PRODID
											,AREA_ID
											,F.COMPANY_ID
											,F.DIVISION_ID
											,F.SITE_ID
											,F.PLANT_ID
											,ATTR_10	--	더블레이어 여부

						   ) A
						   INNER JOIN SCM_SYS_LOOKUP_VALUE SSLV
								   ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
								  AND SEGMENT4 = A.AREA_ID
								  AND SEGMENT5 = ISNULL(A.PLM_FACTORY_CODE, '-')
						   INNER JOIN #LANE_INFO L
								   ON A.COMPANY_ID		= L.COMPANY_ID
								  AND A.DIVISION_ID		= L.DIVISION_ID
								  AND A.SITE_ID			= L.SITE_ID
								  AND A.PLANT_ID		= L.PLANT_ID
								  AND A.AREA_ID			= L.AREA_ID
								  AND A.PRODID			= L.PRODID
								  AND SSLV.ATTRIBUTE1   = L.PROD_VERSION_TYPE
				   ) AA
			 WHERE 1=1 --Solids_amount IS  NULL		--2020-03-27 PIYONG DEL
			   AND COATING_WIDTH IS NOT NULL
			   AND Loading > 0
			   AND AREA_ID NOT IN ( 'EA' )



			--JUMBO_ROLL(M/BATCH)
			SELECT MAX(COMPANY_ID) AS COMPANY_ID
					,MAX(DIVISION_ID) AS DIVISION_ID
					,MAX(SITE_ID) AS SITE_ID
					,MAX(PLANT_ID) AS PLANT_ID
					,[MODEL_CODE]
					,MAX([PROJECT_NAME]) AS [PROJECT_NAME]
					,[ITEM_ID]
					,[VERSION]
					,ATTR_01 --  차수
					,[FACTORY_ID]
					,[OPERATION_ID]
					,SUM([VALUE1]) AS [VALUE1]
					,MAX([ACCT_NAME]) AS [ACCT_NAME]
					,MAX(PROD_VERSION_TYPE) AS PROD_VERSION_TYPE
					,MAX(VERSION_TYPE) AS VERSION_TYPE
					,MAX(APPLY_DATE) AS APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가		
			  INTO #POUCH_M_BATCH
			  FROM (
					SELECT COMPANY_ID
						   ,DIVISION_ID
						   ,SITE_ID
						   ,PLANT_ID
						   ,MODEL_CODE
						   ,PROJECT_NAME
						   ,ITEM_ID
						   ,[VERSION]
						   ,ATTR_01 --  차수
						   ,FACTORY_ID
						   ,OPERATION_ID
						   ,MIX_PRODID
				           ,ATTR_10 -- 더블레이어
						   ,PROD_VERSION_TYPE
						   ,VERSION_TYPE
   						   ,Solids_amount
						   ,COATING_WIDTH
						   ,Loading
						   ,VALUE1
						   ,ACCT_NAME
						   ,APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,ROW_NUMBER() OVER( PARTITION BY COMPANY_ID
															,DIVISION_ID
															,SITE_ID
															,PLANT_ID
															,MODEL_CODE
															,PROJECT_NAME
															,ITEM_ID
															,[VERSION]
															,ATTR_01 --  차수
															,FACTORY_ID
															,OPERATION_ID
															,MIX_PRODID
															,Solids_amount
															,COATING_WIDTH
															,Loading
															,VALUE1
															,ACCT_NAME
															,PROD_VERSION_TYPE
															,VERSION_TYPE
															,ATTR_10 -- 더블레이어
												   ORDER BY ALT_ID, ALT_PRIORITY ) AS NUM 
					  FROM (
					---------------------------------------------------------------------------------------------------------------------------
					---------------------------------------------------------------------------------------------------------------------------
					-------------------------------------			POUCH 양면				---------------------------------------------------
					---------------------------------------------------------------------------------------------------------------------------
					---------------------------------------------------------------------------------------------------------------------------
							SELECT DISTINCT P.COMPANY_ID
								   ,P.DIVISION_ID
								   ,P.SITE_ID
								   ,P.PLANT_ID
								   ,C.CMODEL_CODE AS [MODEL_CODE]
								   ,ISNULL(M.NICK_NAME, MM.NICK_NAME ) AS [PROJECT_NAME]
								   ,P.PRODID AS [ITEM_ID]
								   ,C.PROD_VER_CODE AS [VERSION]
								   ,P.ATTR_01 --  차수
								   ,C.AREA_ID AS [FACTORY_ID]
								   ,'E2000' AS OPERATION_ID
								   ,C.PRODID AS MIX_PRODID
								   ,C.Solids_amount
								   ,COATING_WIDTH
								   ,Loading
								   ,Solids_amount / ( COATING_WIDTH * 2 * Loading / 25 ) * POWER(10,5) AS [VALUE1]
								   ,(SELECT ATTRIBUTE1
										FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
										WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
										AND SEGMENT1 = 'm/batch'
										AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
									,P.PROD_VERSION_TYPE
									,P.VERSION_TYPE
									,B.ALT_ID
									,B.ALT_PRIORITY
									,C.ATTR_10 -- 더블레이어
									,P.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가		
							  FROM (
									SELECT DISTINCT M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.AREA_ID, M.CMODEL_CODE, M.PRODID, I.CHILD_ITEM_ID
											, PROD_VER_CODE
											, ATTR_01 --  차수
											, VERSION_TYPE
											, PROD_VERSION_TYPE
											, COATING_WIDTH, Loading
											, M.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
									  FROM #POUCH_COT_INFO AS M
									 INNER JOIN [SCM_MODEL_COMP_EFFECTIVE_DATE] I				-- 2020-02-19 PIYONG CHANGE [SCM_MODEL_COMP_TEMP] -> [SCM_MODEL_COMP_EFFECTIVE_DATE]
											 ON 1=1 
									--	    AND M.COMPANY_ID	= I.CHILD_COMPANY_ID
									--	    AND M.DIVISION_ID	= I.CHILD_DIVISION_ID
									--		AND M.SITE_ID		= I.CHILD_SITE_ID
									--		AND M.PLANT_ID		= I.CHILD_PLANT_ID
											AND M.PRODID		= I.PARENT_ITEM_ID
											AND M.CMODEL_CODE = I.MODEL_ID
									 WHERE I.CHILD_ITEM_ID LIKE 'ASL%'
									   AND I.EFF_END_DATE > M.EFF_END_DATE
									   AND M.PRODID NOT LIKE 'APCCS%'
									   AND M.AREA_ID NOT IN ( 'EA', 'EB', 'EC','ED' )			--2019-08-20 PIYONG ADD CNA, 'CNB',폴란드 제외

									) P 
							  INNER JOIN #POUCH_MIX_INFO C
									  ON P.COMPANY_ID		= C.COMPANY_ID
									 AND P.DIVISION_ID		= C.DIVISION_ID
									 AND P.SITE_ID			= C.SITE_ID
									 AND P.PLANT_ID			= C.PLANT_ID
									 AND P.AREA_ID			= C.AREA_ID
									 AND P.CMODEL_CODE		= C.CMODEL_CODE
									 AND P.CHILD_ITEM_ID	= C.PRODID
									 AND P.PROD_VER_CODE	= C.PROD_VER_CODE
									 AND ISNULL(P.ATTR_01, '00')	= ISNULL(C.ATTR_01, '00')
							  INNER JOIN SCM_BOM_M B
									  ON B.COMPANY_ID		= P.COMPANY_ID
									 AND B.DIVISION_ID		= P.DIVISION_ID
									 AND B.SITE_ID			= P.SITE_ID
									 AND B.PLANT_ID			= P.PLANT_ID
									 AND B.PARENT_ITEM_ID	= P.PRODID
									 AND B.CHILD_ITEM_ID	= P.CHILD_ITEM_ID
									 AND B.EFF_START_DATE  <= GETDATE()
									 AND B.EFF_END_DATE	   >= GETDATE()
							  LEFT OUTER JOIN SCM_ITEM_M M					--NICK_NAME
										   ON P.COMPANY_ID	= M.COMPANY_ID
										  AND P.DIVISION_ID	= M.DIVISION_ID
										  AND P.CMODEL_CODE	= M.[ITEM_ID]
							  LEFT OUTER JOIN SCM_ITEM_M MM					--NICK_NAME
										   ON P.COMPANY_ID		= MM.COMPANY_ID
										  AND P.DIVISION_ID		= MM.DIVISION_ID
										  AND P.PRODID			= MM.[ITEM_ID]
							------------------------------------------------------------------------------------------------------------------------------------
							--2019-08-20 PIYONG ADD CNA
							UNION ALL
							SELECT COMPANY_ID
								   , DIVISION_ID
								   , SITE_ID
								   , PLANT_ID
								   , [MODEL_CODE]
								   , [PROJECT_NAME]
								   , [ITEM_ID]
								   , [VERSION]
								   , ATTR_01 --  차수
								   , [FACTORY_ID]
								   , OPERATION_ID
								   , MIX_PRODID
								   , Solids_amount
								   , COATING_WIDTH
								   , Loading
								   , Solids_amount / ( COATING_WIDTH * 2 * Loading / 25 ) * POWER(10,5) AS [VALUE1]
								   , [ACCT_NAME]
								   , PROD_VERSION_TYPE
								   , VERSION_TYPE
								   , ALT_ID
								   , ALT_PRIORITY
								   , ATTR_10 -- 더블레이어
								   , APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
							  FROM (
									SELECT DISTINCT P.COMPANY_ID
										   ,P.DIVISION_ID
										   ,P.SITE_ID
										   ,P.PLANT_ID
										   ,C.CMODEL_CODE AS [MODEL_CODE]
										   ,ISNULL(M.NICK_NAME, MM.NICK_NAME) AS [PROJECT_NAME]
										   ,P.PRODID AS [ITEM_ID]
										   ,C.PROD_VER_CODE AS [VERSION]
										   ,P.ATTR_01 --  차수
										   ,C.AREA_ID AS [FACTORY_ID]
										   ,'E2000' AS OPERATION_ID
										   ,C.PRODID AS MIX_PRODID
										   ,C.Solids_amount
										   ,COATING_WIDTH
										   ,Loading
										   ,ROW_NUMBER() OVER (PARTITION BY C.CMODEL_CODE, P.PRODID, C.PROD_VER_CODE, P.ATTR_01
																   ORDER BY C.CMODEL_CODE, P.PRODID, C.PROD_VER_CODE, P.ATTR_01 DESC, B.ALT_ID
																		 , B.ALT_PRIORITY, C.ATTR_10, Solids_amount DESC						  ) AS NUM
										   ,(SELECT ATTRIBUTE1
											   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
											  WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
												AND SEGMENT1 = 'm/batch'
												AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
										   ,P.PROD_VERSION_TYPE
										   ,P.VERSION_TYPE
										   ,B.ALT_ID
										   ,B.ALT_PRIORITY
										   ,C.ATTR_10 -- 더블레이어
										   ,P.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
									  FROM (
											SELECT DISTINCT M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.AREA_ID, M.CMODEL_CODE, M.PRODID, I.CHILD_ITEM_ID
												   , PROD_VER_CODE
												   , ATTR_01 --  차수
												   , VERSION_TYPE
												   , PROD_VERSION_TYPE
												   , COATING_WIDTH, Loading
												   , M.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
											  FROM #POUCH_COT_INFO M
											 INNER JOIN [SCM_MODEL_COMP_EFFECTIVE_DATE] I		-- 2020-02-19 PIYONG CHANGE [SCM_MODEL_COMP_TEMP] -> [SCM_MODEL_COMP_EFFECTIVE_DATE]
													 ON 1=1 
											--	    AND M.COMPANY_ID	= I.CHILD_COMPANY_ID
											--	    AND M.DIVISION_ID	= I.CHILD_DIVISION_ID
											--		AND M.SITE_ID		= I.CHILD_SITE_ID
											--		AND M.PLANT_ID		= I.CHILD_PLANT_ID
													AND M.PRODID		= I.PARENT_ITEM_ID
													AND M.CMODEL_CODE = I.MODEL_ID
											 WHERE I.CHILD_ITEM_ID LIKE 'ASL%'
											   AND I.EFF_END_DATE > M.EFF_END_DATE
											   AND M.PRODID NOT LIKE 'APCCS%'
											   AND M.AREA_ID = 'EA'
											) P 
									  INNER JOIN #POUCH_MIX_INFO C
											  ON P.COMPANY_ID		= C.COMPANY_ID
											 AND P.DIVISION_ID		= C.DIVISION_ID
											 AND P.SITE_ID			= C.SITE_ID
											 AND P.PLANT_ID			= C.PLANT_ID
											 AND P.AREA_ID			= C.AREA_ID
											 AND P.CMODEL_CODE		= C.CMODEL_CODE
											 AND P.CHILD_ITEM_ID	= C.PRODID
											 AND P.PROD_VER_CODE	= C.PROD_VER_CODE
											 AND ISNULL(P.ATTR_01, '00')	= ISNULL(C.ATTR_01, '00')
									  INNER JOIN SCM_BOM_M B
											  ON B.COMPANY_ID		= P.COMPANY_ID
											 AND B.DIVISION_ID		= P.DIVISION_ID
											 AND B.SITE_ID			= P.SITE_ID
											 AND B.PLANT_ID			= P.PLANT_ID
											 AND B.PARENT_ITEM_ID	= P.PRODID
											 AND B.CHILD_ITEM_ID	= P.CHILD_ITEM_ID
											 AND B.EFF_START_DATE  <= GETDATE()
											 AND B.EFF_END_DATE	   >= GETDATE()
									  LEFT OUTER JOIN SCM_ITEM_M M					--NICK_NAME
												   ON P.COMPANY_ID	= M.COMPANY_ID
												  AND P.DIVISION_ID	= M.DIVISION_ID
												  AND P.CMODEL_CODE	= M.[ITEM_ID]
									  LEFT OUTER JOIN SCM_ITEM_M MM					--NICK_NAME
												   ON P.COMPANY_ID		= MM.COMPANY_ID
												  AND P.DIVISION_ID		= MM.DIVISION_ID
												  AND P.PRODID			= MM.[ITEM_ID]
								   ) A
							 WHERE NUM = 1
							--2019-08-20 PIYONG ADD CNA
 							------------------------------------------------------------------------------------------------------------------------------------
							------------------------------------------------------------------------------------------------------------------------------------
							--2019-08-20 PIYONG ADD CNB, 폴란드
							UNION ALL
							SELECT COMPANY_ID
								   , DIVISION_ID
								   , SITE_ID
								   , PLANT_ID
								   , [MODEL_CODE]
								   , [PROJECT_NAME]
								   , [ITEM_ID]
								   , [VERSION]
								   , ATTR_01 --  차수
								   , [FACTORY_ID]
								   , OPERATION_ID
								   , MIX_PRODID
								   , Solids_amount
								   , COATING_WIDTH
								   , Loading
							--	   , Solids_amount / ( COATING_WIDTH * 2 * CASE WHEN [FACTORY_ID] = 'EC' AND B_Loading != 0 THEN B_Loading ELSE Loading END / 25 ) * POWER(10,5) AS [VALUE1]
								   , Solids_amount / ( COATING_WIDTH * 2 * Loading / 25 ) * POWER(10,5) AS [VALUE1]
								   , [ACCT_NAME]
								   , PROD_VERSION_TYPE
								   , VERSION_TYPE
								   , ALT_ID
								   , ALT_PRIORITY
								   , ATTR_10 -- 더블레이어
								   , APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
							  FROM (
									SELECT DISTINCT P.COMPANY_ID
										   ,P.DIVISION_ID
										   ,P.SITE_ID
										   ,P.PLANT_ID
										   ,C.CMODEL_CODE AS [MODEL_CODE]
										   ,ISNULL(M.NICK_NAME, MM.NICK_NAME) AS [PROJECT_NAME]
										   ,P.PRODID AS [ITEM_ID]
										   ,C.PROD_VER_CODE AS [VERSION]
										   ,P.ATTR_01 --  차수
										   ,C.AREA_ID AS [FACTORY_ID]
										   ,'E2000' AS OPERATION_ID
										   ,C.PRODID AS MIX_PRODID
										   ,C.Solids_amount
										   ,COATING_WIDTH
										   ,Loading
										   ,ROW_NUMBER() OVER (PARTITION BY C.CMODEL_CODE,C.AREA_ID, P.PRODID, C.PROD_VER_CODE, P.ATTR_01
																   ORDER BY C.CMODEL_CODE,C.AREA_ID, P.PRODID, C.PROD_VER_CODE, P.ATTR_01 DESC, B.ALT_ID
																		 , B.ALT_PRIORITY, C.ATTR_10, Solids_amount								  ) AS NUM
										   ,(SELECT ATTRIBUTE1
											   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
											  WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
												AND SEGMENT1 = 'm/batch'
												AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
										   ,P.PROD_VERSION_TYPE
										   ,P.VERSION_TYPE
										   ,B.ALT_ID
										   ,B.ALT_PRIORITY
										   ,C.ATTR_10 -- 더블레이어
									--	   ,P.B_Loading										-- 2020-03-27 PIYONG DEL
									       ,P.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
									  FROM (
											SELECT DISTINCT M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.AREA_ID, M.CMODEL_CODE, M.PRODID, I.CHILD_ITEM_ID
												   , PROD_VER_CODE
												   , ATTR_01 --  차수
												   , VERSION_TYPE
												   , PROD_VERSION_TYPE
												   , COATING_WIDTH, Loading
											--	   ,B_Loading									-- 2020-03-27 PIYONG DEL
											       , M.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
											  FROM #POUCH_COT_INFO M
											 INNER JOIN [SCM_MODEL_COMP_EFFECTIVE_DATE] I		-- 2020-02-19 PIYONG CHANGE [SCM_MODEL_COMP_TEMP] -> [SCM_MODEL_COMP_EFFECTIVE_DATE]
													 ON 1=1 
											--	    AND M.COMPANY_ID	= I.CHILD_COMPANY_ID
											--	    AND M.DIVISION_ID	= I.CHILD_DIVISION_ID
											--		AND M.SITE_ID		= I.CHILD_SITE_ID
											--		AND M.PLANT_ID		= I.CHILD_PLANT_ID
													AND M.PRODID		= I.PARENT_ITEM_ID
													AND M.CMODEL_CODE = I.MODEL_ID
											 WHERE I.CHILD_ITEM_ID LIKE 'ASL%'
											   AND I.EFF_END_DATE > M.EFF_END_DATE
											   AND M.PRODID NOT LIKE 'APCCS%'
											   AND M.AREA_ID IN ( 'EB', 'EC','ED' )
											) P 
									  INNER JOIN #POUCH_MIX_INFO C
											  ON P.COMPANY_ID		= C.COMPANY_ID
											 AND P.DIVISION_ID		= C.DIVISION_ID
											 AND P.SITE_ID			= C.SITE_ID
											 AND P.PLANT_ID			= C.PLANT_ID
											 AND P.AREA_ID			= C.AREA_ID
											 AND P.CMODEL_CODE		= C.CMODEL_CODE
											 AND P.CHILD_ITEM_ID	= C.PRODID
											 AND P.PROD_VER_CODE	= C.PROD_VER_CODE
											 AND ISNULL(P.ATTR_01, '00')	= ISNULL(C.ATTR_01, '00')
									  INNER JOIN SCM_BOM_M B
											  ON B.COMPANY_ID		= P.COMPANY_ID
											 AND B.DIVISION_ID		= P.DIVISION_ID
											 AND B.SITE_ID			= P.SITE_ID
											 AND B.PLANT_ID			= P.PLANT_ID
											 AND B.PARENT_ITEM_ID	= P.PRODID
											 AND B.CHILD_ITEM_ID	= P.CHILD_ITEM_ID
											 AND B.EFF_START_DATE  <= GETDATE()
											 AND B.EFF_END_DATE	   >= GETDATE()
									  LEFT OUTER JOIN SCM_ITEM_M M					--NICK_NAME
												   ON P.COMPANY_ID	= M.COMPANY_ID
												  AND P.DIVISION_ID	= M.DIVISION_ID
												  AND P.CMODEL_CODE	= M.[ITEM_ID]
									  LEFT OUTER JOIN SCM_ITEM_M MM					--NICK_NAME
												   ON P.COMPANY_ID	= MM.COMPANY_ID
												  AND P.DIVISION_ID	= MM.DIVISION_ID
												  AND P.PRODID		= MM.[ITEM_ID]
								   ) A
							 WHERE NUM = 1
							--2019-08-20 PIYONG ADD CNB, 폴란드
 							------------------------------------------------------------------------------------------------------------------------------------



							---------------------------------------------------------------------------------------------------------------------------
							---------------------------------------------------------------------------------------------------------------------------
							-------------------------------------			POUCH 단면				---------------------------------------------------
							---------------------------------------------------------------------------------------------------------------------------
							---------------------------------------------------------------------------------------------------------------------------
								UNION ALL
								SELECT DISTINCT P.COMPANY_ID
									   ,P.DIVISION_ID
									   ,P.SITE_ID
									   ,P.PLANT_ID
									   ,C.CMODEL_CODE AS [MODEL_CODE]
									   ,ISNULL(M.NICK_NAME, MM.NICK_NAME) AS [PROJECT_NAME]
									   ,P.PRODID AS [ITEM_ID]
									   ,C.PROD_VER_CODE AS [VERSION]
									   ,P.ATTR_01 --  차수
									   ,C.AREA_ID AS [FACTORY_ID]
									   ,'E2000' AS OPERATION_ID
									   ,C.PRODID AS MIX_PRODID
									   ,C.Solids_amount
									   ,COATING_WIDTH
									   ,Loading
									   ,Solids_amount / ( COATING_WIDTH * Loading / 25 ) * POWER(10,5) AS [VALUE1]
									   ,(SELECT ATTRIBUTE1
										   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
										  WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
											AND SEGMENT1 = 'm/batch'
											AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
									   ,P.PROD_VERSION_TYPE
									   ,P.VERSION_TYPE
									   ,B.ALT_ID
									   ,B.ALT_PRIORITY
									   ,C.ATTR_10 -- 더블레이어
									   ,P.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
								  FROM (
										SELECT DISTINCT M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.AREA_ID, M.CMODEL_CODE, M.PRODID, I.CHILD_ITEM_ID
												, PROD_VER_CODE
												, ATTR_01 --  차수
												, PROD_VERSION_TYPE
												, VERSION_TYPE
												, COATING_WIDTH, Loading
												, M.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
										  FROM #POUCH_COT_INFO M
										 INNER JOIN SCM_BOM_M I
												 ON M.COMPANY_ID	= I.COMPANY_ID
												AND M.DIVISION_ID	= I.DIVISION_ID
												AND M.SITE_ID		= I.SITE_ID
												AND M.PRODID		= I.PARENT_ITEM_ID
												AND M.PRODID LIKE 'APCCS%'
									   ) P 
								 INNER JOIN #POUCH_MIX_INFO C
										 ON P.COMPANY_ID		= C.COMPANY_ID
										AND P.DIVISION_ID		= C.DIVISION_ID
										AND P.SITE_ID			= C.SITE_ID
										AND P.PLANT_ID			= C.PLANT_ID
										AND P.AREA_ID			= C.AREA_ID
										AND P.CMODEL_CODE		= C.CMODEL_CODE
										AND P.CHILD_ITEM_ID		= C.PRODID
										AND P.PROD_VER_CODE		= C.PROD_VER_CODE
										AND ISNULL(P.ATTR_01, '00')	= ISNULL(C.ATTR_01, '00')
								 INNER JOIN SCM_BOM_M B
										 ON B.COMPANY_ID		= P.COMPANY_ID
										AND B.DIVISION_ID		= P.DIVISION_ID
										AND B.SITE_ID			= P.SITE_ID
										AND B.PLANT_ID			= P.PLANT_ID
										AND B.PARENT_ITEM_ID	= P.PRODID
										AND B.CHILD_ITEM_ID		= P.CHILD_ITEM_ID
										AND B.EFF_START_DATE   <= GETDATE()
										AND B.EFF_END_DATE	   >= GETDATE()
								 LEFT OUTER JOIN SCM_ITEM_M M					--NICK_NAME
										 ON P.COMPANY_ID		= M.COMPANY_ID
										AND P.DIVISION_ID		= M.DIVISION_ID
										AND P.CMODEL_CODE		= M.[ITEM_ID]
								 LEFT OUTER JOIN SCM_ITEM_M MM					--NICK_NAME
										 ON P.COMPANY_ID		= MM.COMPANY_ID
										AND P.DIVISION_ID		= MM.DIVISION_ID
										AND P.PRODID			= MM.[ITEM_ID]
						   ) A
				   ) AA
			 WHERE NUM = 1
			 GROUP BY COMPANY_ID
					,[FACTORY_ID]
					,[MODEL_CODE]
					,[VERSION]
				    ,ATTR_01 --  차수
					,[ITEM_ID]
					,[OPERATION_ID]
					,[ACCT_NAME]

			
			--JUMBO_ROLL(CELL/M)
			SELECT MAX(COMPANY_ID) AS COMPANY_ID
					,MAX(DIVISION_ID) AS DIVISION_ID
					,MAX(SITE_ID) AS SITE_ID
					,MAX(PLANT_ID) AS PLANT_ID
					,[MODEL_CODE]
					,MAX([PROJECT_NAME]) AS [PROJECT_NAME]
					,[ITEM_ID]
					,[VERSION]
					,ATTR_01   -- 차수
					,[FACTORY_ID]
					,[OPERATION_ID]
					,SUM([VALUE1]) AS [VALUE1]
					,MAX([ACCT_NAME]) AS [ACCT_NAME]
					,MAX(PROD_VERSION_TYPE) AS PROD_VERSION_TYPE
					,MAX(VERSION_TYPE) AS VERSION_TYPE
					,MAX(APPLY_DATE) AS APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
			  INTO #POUCH_CELL_M
			  FROM (
					SELECT P.COMPANY_ID
							,P.DIVISION_ID
							,P.SITE_ID
							,P.PLANT_ID
							,P.CMODEL_CODE AS [MODEL_CODE]
							,ISNULL(M.NICK_NAME, MM.NICK_NAME) AS [PROJECT_NAME]
							,P.PRODID AS [ITEM_ID]
							,P.PROD_VER_CODE AS [VERSION]
							,P.ATTR_01 --  차수
							,P.AREA_ID AS [FACTORY_ID]
							,'E2000' AS OPERATION_ID
							,CELL_M AS [VALUE1]
							,(SELECT ATTRIBUTE1
								FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
								WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
								AND SEGMENT1 = N'점보롤 cell/m'
								AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
							,P.PROD_VERSION_TYPE
							,P.VERSION_TYPE
							,P.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					  FROM (
							  SELECT  M.COMPANY_ID
									, M.DIVISION_ID
									, M.SITE_ID
									, M.PLANT_ID
									, M.AREA_ID
									, M.CMODEL_CODE
									, M.PRODID
									, M.PROD_VER_CODE
									, M.ATTR_01 --  차수
									, M.PROD_VERSION_TYPE
									, M.VERSION_TYPE
									, M.LANE_CNT
									, (	1 / (DBO.FN_GET_REQ_QTY_MODEL ( '-', M.CMODEL_CODE, M.PRODID, ( SELECT TOP 1 CASE WHEN EFF_START_DATE > M.EFF_END_DATE THEN
																																	EFF_START_DATE 
																																  ELSE M.EFF_END_DATE END
																												 FROM [SCM_MODEL_COMP_EFFECTIVE_DATE] B (NOLOCK)
																												 WHERE B.EFF_END_DATE > M.EFF_END_DATE
																												 AND   B.ALT_PRIORITY = 'Y' 
																												 AND   B.MODEL_ID     = M.CMODEL_CODE
																												 AND   B.CHILD_ITEM_ID = M.PRODID
																											)
																			 ) )   ) AS CM 
									, M.LANE_CNT * ( 1 / (DBO.FN_GET_REQ_QTY_MODEL ( '-', M.CMODEL_CODE, M.PRODID, ( SELECT TOP 1CASE WHEN EFF_START_DATE > M.EFF_END_DATE THEN
																																				 EFF_START_DATE 
																																			   ELSE M.EFF_END_DATE END
																															 FROM [SCM_MODEL_COMP_EFFECTIVE_DATE] B (NOLOCK)
																															 WHERE B.EFF_END_DATE > M.EFF_END_DATE
																															 AND   B.ALT_PRIORITY = 'Y' 
																															 AND   B.MODEL_ID     = M.CMODEL_CODE
																															 AND   B.CHILD_ITEM_ID = M.PRODID
																															 )
																							 )
														 )   ) AS CELL_M			-- 2020-02-19 PIYONG CHANGE 
									, M.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
									-- 2021-01-12 kimcd 대당 수량 산출 함수를 다시 FN_GET_REQ_QTY_MODEL으로 복원
							   FROM #POUCH_COT_INFO M
							   /*	-- 2020-02-19 PIYONG DEL
									INNER JOIN (
												SELECT COMPANY_ID
														,DIVISION_ID
														,SITE_ID
														,PLANT_ID
														,MODEL_ID
														,PRODID
														,CELL_M
												  FROM (
														SELECT COMPANY_ID
																,DIVISION_ID
																,SITE_ID
																,PLANT_ID
																,MODEL_ID
																,PRODID
																,CELL_M
																,ROW_NUMBER() OVER(PARTITION BY MODEL_ID
																							 , PRODID
																					   ORDER BY COMPANY_ID
																							 , DIVISION_ID
																							 , SITE_ID
																							 , PLANT_ID ) AS NUM		--2019-03-11 PIYONG ADD	
														  FROM (
																SELECT  COMPANY_ID
																		,DIVISION_ID
																		,SITE_ID
																		,PLANT_ID
																		,MODEL_ID
																		,CHILD_ITEM_ID AS PRODID
																		,1 / SUM(ACCUMULATED_CHILD_QTY) AS CELL_M
																   FROM [SCM_MODEL_COMP_TEMP]
																  WHERE 1=1--'C100'	= COMPANY_ID
																--	AND MODEL_ID = 'MIF46B064A11'
																--	AND CHILD_ITEM_ID in ( 'APCCS0727A', '' )
																	AND ALT_PRIORITY = 'Y'
																  GROUP BY COMPANY_ID		--2019-03-11 PIYONG CHANGE CHILD_COMPANY_ID	 -> COMPANY_ID
																		,DIVISION_ID		--2019-03-11 PIYONG CHANGE CHILD_DIVISION_ID -> DIVISION_ID
																		,SITE_ID			--2019-03-11 PIYONG CHANGE CHILD_SITE_ID	 -> SITE_ID
																		,PLANT_ID			--2019-03-11 PIYONG CHANGE CHILD_PLANT_ID	 -> PLANT_ID
																		,MODEL_ID
																		,CHILD_ITEM_ID
																) A
														) AA
												  WHERE NUM = 1
												) I
											 ON M.CMODEL_CODE	= I.MODEL_ID
											AND M.PRODID		= I.PRODID
										--	AND M.DIVISION_ID	= I.CHILD_DIVISION_ID
								*/
							) P 
							LEFT OUTER JOIN SCM_ITEM_M M					--NICK_NAME
									ON P.COMPANY_ID		= M.COMPANY_ID
									AND P.DIVISION_ID	= M.DIVISION_ID
									AND P.CMODEL_CODE	= M.[ITEM_ID]
							LEFT OUTER JOIN SCM_ITEM_M MM					--NICK_NAME
										 ON P.COMPANY_ID		= MM.COMPANY_ID
										AND P.DIVISION_ID		= MM.DIVISION_ID
										AND P.PRODID			= MM.[ITEM_ID]
					) AA
			  WHERE [FACTORY_ID] NOT IN ( 'EA' )
			  GROUP BY COMPANY_ID
					,[FACTORY_ID]
					,[MODEL_CODE]
					,[VERSION]
				    ,ATTR_01 --  차수
					,[ITEM_ID]
					,[OPERATION_ID]
					,[ACCT_NAME]



			SET @v_err_check = '1. SCM_ITEM_CONV_CALC_M from #POUCH_M_BATCH'
			--Jumbo Roll (m/batch)		
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					 --SELECT COMPANY_ID
						--   ,DIVISION_ID
						--   ,SITE_ID
						--   ,PLANT_ID
						--   ,MODEL_CODE
						--   ,PROJECT_NAME
						--   ,NULL AS CA_FLAG
						--   ,ITEM_ID
						--   ,VERSION
						--   ,ATTR_01 AS PROD_SEQ 
						--   ,FACTORY_ID
						--   ,OPERATION_ID
						--   ,VALUE1
						--   ,ACCT_NAME
						--   ,PROD_VERSION_TYPE
						--   ,VERSION_TYPE
						--   ,APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
				  --    FROM #POUCH_M_BATCH

				  --#POUCH_M_BATCH : 버전별 차수가 복수일 경우 높은 차수 선택
					SELECT X.*
					  FROM (
						   SELECT COMPANY_ID
							    , DIVISION_ID
							    , SITE_ID
							    , PLANT_ID
							    , MODEL_CODE
							    , PROJECT_NAME
							    , NULL AS CA_FLAG
							    , ITEM_ID
							    , VERSION 
							    , FACTORY_ID
							    , OPERATION_ID
							    , VALUE1
							    , ACCT_NAME
							    , PROD_VERSION_TYPE
							    , VERSION_TYPE
   		            	        , [APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
							    , ATTR_01 AS   [PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
							    , ROW_NUMBER() OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_CODE, PROJECT_NAME, ITEM_ID, VERSION, FACTORY_ID, OPERATION_ID, ACCT_NAME, PROD_VERSION_TYPE, VERSION_TYPE ORDER BY ATTR_01 DESC) AS RANKNO
						     FROM #POUCH_M_BATCH
						   ) AS X
				     WHERE X.RANKNO = 1

				  ) B
			  ON (
					A.[COMPANY_ID]		= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]	= B.[FACTORY_ID]
				  AND A.[MODEL_ID]		= B.[MODEL_CODE]
				  AND A.[VERSION]		= B.[VERSION]
				  AND A.[OPERATION]		= B.[OPERATION_ID]
				  AND A.[ITEM_ID]		= B.[ITEM_ID]
				  AND A.[CATEGORY]		= B.[ACCT_NAME]
				  AND A.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[VALUE1] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[VALUE] ELSE B.[VALUE1] END END -- 차수가 다른 경우 값 갱신
						   ,[MMD_VALUE] = B.[VALUE1]
						   ,[VERSION_TYPE]		= B.[VERSION_TYPE]
						   ,[APPLY_DATE] = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]   = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ] -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[VALUE1]
					,B.[VALUE1]
					,'N'
					,B.[PROD_VERSION_TYPE]
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;

			SET @v_err_check = '2. SCM_ITEM_CONV_CALC_M from #POUCH_CELL_M'
			--Jumbo Roll (cell/m)
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					 --SELECT COMPANY_ID
						--   ,DIVISION_ID
						--   ,SITE_ID
						--   ,PLANT_ID
						--   ,MODEL_CODE
						--   ,PROJECT_NAME
						--   ,NULL AS CA_FLAG
						--   ,ITEM_ID
						--   ,VERSION 
						--   ,FACTORY_ID
						--   ,OPERATION_ID
						--   ,VALUE1
						--   ,ACCT_NAME
						--   ,PROD_VERSION_TYPE
						--   ,VERSION_TYPE
   			--			   ,[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						--   ,ATTR_01 AS   [PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				  --    FROM #POUCH_CELL_M

                    --#POUCH_CELL_M : 버전별 차수가 복수일 경우 높은 차수 선택
					SELECT X.*
					  FROM (
						   SELECT COMPANY_ID
							    , DIVISION_ID
							    , SITE_ID
							    , PLANT_ID
							    , MODEL_CODE
							    , PROJECT_NAME
							    , NULL AS CA_FLAG
							    , ITEM_ID
							    , VERSION 
							    , FACTORY_ID
							    , OPERATION_ID
							    , VALUE1
							    , ACCT_NAME
							    , PROD_VERSION_TYPE
							    , VERSION_TYPE
   		            	        , [APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
							    , ATTR_01 AS   [PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
							    , ROW_NUMBER() OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_CODE, PROJECT_NAME, ITEM_ID, VERSION, FACTORY_ID, OPERATION_ID, ACCT_NAME, PROD_VERSION_TYPE, VERSION_TYPE ORDER BY ATTR_01 DESC) AS RANKNO
						     FROM #POUCH_CELL_M
						   ) AS X
				     WHERE X.RANKNO = 1

				  ) B
			  ON (
					A.[COMPANY_ID]		= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]	= B.[FACTORY_ID]
				  AND A.[MODEL_ID]		= B.[MODEL_CODE]
				  AND A.[VERSION]		= B.[VERSION]
				  AND A.[OPERATION]		= B.[OPERATION_ID]
				  AND A.[ITEM_ID]		= B.[ITEM_ID]
				  AND A.[CATEGORY]		= B.[ACCT_NAME]
				  AND A.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE]		= B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[VALUE1] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[VALUE] ELSE B.[VALUE1] END END -- 차수가 다른 경우 값 갱신
						   ,[MMD_VALUE] = B.[VALUE1]
						   ,[VERSION_TYPE] =  B.[VERSION_TYPE]
						   ,[APPLY_DATE] = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]   = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[VALUE1]
					,B.[VALUE1]
					,'N'
					,B.[PROD_VERSION_TYPE]
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;			


			SET @v_err_check = '3. SCM_ITEM_CONV_CALC_M from #POUCH_M_BATCH'
			--cell/batch
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT X.*
					FROM (
						 SELECT M.COMPANY_ID
							   ,M.DIVISION_ID
							   ,M.SITE_ID
							   ,M.PLANT_ID
							   ,M.MODEL_CODE
							   ,M.PROJECT_NAME
							   ,NULL AS CA_FLAG
							   ,M.ITEM_ID
							   ,M.VERSION
							   ,M.FACTORY_ID
							   ,M.OPERATION_ID
							   ,M.VALUE1 * C.VALUE1 AS VALUE1
							   ,(SELECT ATTRIBUTE1
									FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
								   WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
									 AND SEGMENT1 = N'cell/batch'
									 AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
							   ,M.PROD_VERSION_TYPE
							   ,M.VERSION_TYPE
							   ,M.[APPLY_DATE]          -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
							   ,M.ATTR_01 AS [PROD_SEQ] -- 2020-07-10 kimcd PROD_SEQ 차수 추가
							   ,ROW_NUMBER() OVER(PARTITION BY M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.MODEL_CODE, M.PROJECT_NAME, M.ITEM_ID, M.VERSION, M.FACTORY_ID, M.OPERATION_ID, M.PROD_VERSION_TYPE, M.VERSION_TYPE ORDER BY M.ATTR_01 DESC) AS RANKNO
						  FROM #POUCH_M_BATCH M
								INNER JOIN #POUCH_CELL_M C
										ON M.[COMPANY_ID]	= C.[COMPANY_ID]
									   AND M.[FACTORY_ID]	= C.[FACTORY_ID]
									   AND M.[MODEL_CODE]	= C.[MODEL_CODE]
									   AND M.[VERSION]		= C.[VERSION]
									   AND ISNULL(M.ATTR_01, '00')		= ISNULL(C.ATTR_01, '00')  --차수
									   AND M.[OPERATION_ID] = C.[OPERATION_ID]
									   AND M.[ITEM_ID]		= C.[ITEM_ID]
						   ) AS X
				     WHERE X.RANKNO = 1
				  ) B
			  ON (
					A.[COMPANY_ID]			= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]		= B.[FACTORY_ID]
				  AND A.[MODEL_ID]			= B.[MODEL_CODE]
				  AND A.[VERSION]			= B.[VERSION]
				  AND A.[OPERATION]			= B.[OPERATION_ID]
				  AND A.[ITEM_ID]			= B.[ITEM_ID]
				  AND A.[CATEGORY]			= B.[ACCT_NAME]
				  AND A.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[VALUE1] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[VALUE] ELSE B.[VALUE1] END END -- 차수가 다른 경우 값 갱신 
						   ,[MMD_VALUE] = B.[VALUE1]
						   ,[VERSION_TYPE]		= B.VERSION_TYPE
						   ,[APPLY_DATE] = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]   = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[VALUE1]
					,B.[VALUE1]
					,'N'
					,B.[PROD_VERSION_TYPE]
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;			




			SET @v_err_check = '4. SCM_ITEM_CONV_CALC_M from #POUCH_COT_INFO'
			--Lane수
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					 SELECT COMPANY_ID
						  , MAX(DIVISION_ID) AS DIVISION_ID
						  , MAX(SITE_ID) AS SITE_ID
						  , MAX(PLANT_ID) AS PLANT_ID
						  , [MODEL_CODE]
						  , MAX([PROJECT_NAME]) AS [PROJECT_NAME]
						  , NULL AS CA_FLAG
						  , [ITEM_ID]
						  , VERSION
						  , [FACTORY_ID]
						  , [OPERATION_ID]
						  , SUM([VALUE1]) AS [VALUE1]
						  , MAX([ACCT_NAME]) AS [ACCT_NAME]
						  , MAX(PROD_VERSION_TYPE) AS PROD_VERSION_TYPE
						  , MAX(VERSION_TYPE) AS VERSION_TYPE
						  , MAX([APPLY_DATE]) AS [APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						  , ATTR_01           AS [PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
					   FROM (
							SELECT P.COMPANY_ID
								 , P.DIVISION_ID
								 , P.SITE_ID
								 , P.PLANT_ID
								 , P.CMODEL_CODE AS [MODEL_CODE]
								 , ISNULL(M.NICK_NAME, MM.NICK_NAME) AS [PROJECT_NAME]
								 , P.PRODID AS [ITEM_ID]
								 , P.PROD_VER_CODE AS [VERSION]
								 , P.ATTR_01 -- 차수
								 , P.AREA_ID AS [FACTORY_ID]
								 , 'E2000' AS OPERATION_ID
								 , LANE_CNT AS [VALUE1]
								 , (SELECT ATTRIBUTE1
								  	  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
								  	 WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
								  	   AND SEGMENT1 = N'Lane수'
								  	  AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
								 , P.PROD_VERSION_TYPE
								 , P.VERSION_TYPE
								 , P.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
							  FROM (
								   SELECT X.*
								     FROM (
										  SELECT M.COMPANY_ID
											   , M.DIVISION_ID
											   , M.SITE_ID
											   , M.PLANT_ID
											   , M.AREA_ID
											   , M.CMODEL_CODE
											   , M.PRODID
											   , M.PROD_VER_CODE
											   , M.ATTR_01  -- 차수 
											   , M.LANE_CNT
											   , M.PROD_VERSION_TYPE
											   , M.VERSION_TYPE
											   , M.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
											   , ROW_NUMBER() OVER(PARTITION BY M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.AREA_ID, M.CMODEL_CODE, M.PRODID, M.PROD_VER_CODE, M.PROD_VERSION_TYPE, M.VERSION_TYPE ORDER BY M.ATTR_01 DESC) AS RANKNO
											FROM #POUCH_COT_INFO M
											     INNER JOIN #POUCH_M_BATCH B		-- 2019-03-29 PIYONG JOIN ADD
											  ON M.AREA_ID					= B.[FACTORY_ID]
											 AND M.CMODEL_CODE				= B.[MODEL_CODE]
											 AND M.PRODID					= B.[ITEM_ID]
											 AND M.PROD_VER_CODE			= B.[VERSION]
											 AND ISNULL(M.ATTR_01, '00')	= ISNULL(B.ATTR_01, '00')
											 AND M.PROD_VERSION_TYPE		= B.PROD_VERSION_TYPE
										   ) AS X
									 WHERE X.RANKNO = 1
								   ) P 
								   LEFT JOIN SCM_ITEM_M M with(nolock)				--NICK_NAME
							    ON P.COMPANY_ID			= M.COMPANY_ID
							   AND P.DIVISION_ID		= M.DIVISION_ID
							   AND P.CMODEL_CODE		= M.[ITEM_ID]
							   	   LEFT OUTER JOIN SCM_ITEM_M MM with(nolock)			--NICK_NAME
							    ON P.COMPANY_ID			= MM.COMPANY_ID
							   AND P.DIVISION_ID		= MM.DIVISION_ID
							   AND P.PRODID				= MM.[ITEM_ID]

							) AA
					  GROUP BY 
					        COMPANY_ID
						  , [FACTORY_ID]
						  , [MODEL_CODE]
						  , [VERSION]
						  , ATTR_01
						  , [ITEM_ID]
						  , [OPERATION_ID]
						  , [ACCT_NAME]

				  ) B
			   ON A.[COMPANY_ID] = B.[COMPANY_ID]
			  AND A.[FACTORY_ID] = B.[FACTORY_ID]
			  AND A.[MODEL_ID] = B.[MODEL_CODE]
			  AND A.[VERSION] = B.[VERSION]
			  AND A.[OPERATION] = B.[OPERATION_ID]
			  AND A.[ITEM_ID] = B.[ITEM_ID]
			  AND A.[CATEGORY] = B.[ACCT_NAME]
			  AND A.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				         , [ELECTRODE_TYPE] = B.[CA_FLAG]
						 , [CATEGORY] = B.[ACCT_NAME]
						 , [VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[VALUE1] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[VALUE] ELSE B.[VALUE1] END END -- 차수가 다른 경우 값 갱신 
						 , [MMD_VALUE] = B.[VALUE1]
						 , [VERSION_TYPE] = B.[VERSION_TYPE]
						 , [APPLY_DATE]  = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						 , [PROD_SEQ]    = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						 , [UPDATE_ID]   = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신 
						 , [UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					   [COMPANY_ID]
					 , [DIVISION_ID]
					 , [SITE_ID]
					 , [PLANT_ID]
					 , [FACTORY_ID]
					 , [MODEL_ID]
					 , [PJT_CODE]
					 , [VERSION]
					 , [OPERATION]
					 , [ITEM_ID]
					 , [ELECTRODE_TYPE]
					 , [CATEGORY]
					 , [VALUE]
					 , [MMD_VALUE]
					 , [MAX_VER_FLAG]
					 , [PROD_VERSION_TYPE]
					 , [VERSION_TYPE]
					 , [CREATE_ID]
					 , [CREATE_TIME]
					 , [UPDATE_ID]
					 , [UPDATE_TIME]
					 , [APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					 , [PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) 
				VALUES (
					   B.[COMPANY_ID]
					 , B.[DIVISION_ID]
					 , B.[SITE_ID]
					 , B.[PLANT_ID]
					 , B.[FACTORY_ID]
					 , B.[MODEL_CODE]
					 , B.[PROJECT_NAME]
					 , B.[VERSION]
					 , B.[OPERATION_ID]
					 , B.[ITEM_ID]
					 , B.[CA_FLAG]
					 , B.[ACCT_NAME]
					 , B.[VALUE1]
					 , B.[VALUE1]
					 , 'N'
					 , B.[PROD_VERSION_TYPE]
					 , B.[VERSION_TYPE]
					 , 'PR_XIF_PLM_ITEM_CONV_CALC_R'
					 , GETDATE()
					 , 'PR_XIF_PLM_ITEM_CONV_CALC_R'
					 , GETDATE()
					 , B.[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					 , B.[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;	


			------------------------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			-------------------------------------			원, 각 형														--------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------

			/*	--2019-04-26 PIYONG DEL
			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'P'
			 WHERE PRODID IS NOT NULL
			   AND CELLTYPE != 'POUCH'
			   AND PROC_FLAG = 'N'
			*/

			SET @v_err_check = '4. SCM_ITEM_CONV_CALC_M into #MIX_INFO'
		
			--믹서 기준 원각형 고형분 생성
			SELECT COMPANY_ID
				   ,DIVISION_ID
				   ,SITE_ID
				   ,PLANT_ID
				   ,CMODEL_CODE
				   ,PROD_VER_CODE
				   ,ATTR_01  --차수
				   ,PRODID
				   ,AREA_ID
				   ,Solids_amount--고형분
			  INTO #MIX_INFO
			  FROM (
					SELECT COMPANY_ID
						   ,DIVISION_ID
						   ,SITE_ID
						   ,PLANT_ID
						   ,CMODEL_CODE
						   ,PROD_VER_CODE
						   ,ATTR_01 --  차수
						   ,(SELECT TOP 1 PRODID
							   FROM #PLM_ITEM_CONV_CALC R			--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
						      WHERE R.CELLTYPE != 'POUCH'
							    AND R.CELLTYPE != 'NFF Cylindrical' -- 2022-04-14 김현 [C20220328-000596] NFF Cylindrical 반영 로직 추가
						--		AND R.PROC_FLAG = 'P'				--2019-04-26 PIYONG DEL
							    AND R.CMODEL_CODE = AA.CMODEL_CODE
							    AND R.PROD_VER_CODE =  AA.PROD_VER_CODE
							    AND R.AREA_ID =  AA.AREA_ID
							    AND R.WO_ID = AA.WO_ID
							    AND R.PRODID LIKE AA.PRODID+'%'
							 ) AS PRODID
						   ,AREA_ID
						   ,Solids_amount--고형분
					  FROM (
							SELECT F.COMPANY_ID
									,F.DIVISION_ID
									,F.SITE_ID
									,F.PLANT_ID
									,CMODEL_CODE
									,PROD_VER_CODE
									,ATTR_01  --차수
									,SUBSTRING(PRODID, 1 ,4) AS PRODID
									,AREA_ID
									,WO_ID
									,SUM( /*2021-12-28 E7,EE 로직 막음 CASE WHEN ATTR_10 = 'Y' AND AREA_ID IN ( 'E7', 'EE') AND ATTR_11 = 'B' THEN 0 -- 2021-06-24 C20210626-000019 kimcd 남경 소형 전극 원각이면서 DLD의 경우 B(하면) 제외
										  ELSE */ CONVERT( FLOAT, REPLACE( Solids_amount, ',', '') ) /*END*/ ) AS Solids_amount--고형분 
							  FROM (
									SELECT CMODEL_CODE
											,PROD_VER_CODE
											,ATTR_01  --차수
											,PRODID
											,AREA_ID
											,WO_ID
											,CASE WHEN UNIT = 'KG' AND SPEC_ITEM_ID IN (
																						'I-C002-SPEC-009_1'
																						,'I-K002-SPEC-009_1'
																						,'I-C001-SPEC-016_1'
																						,'I-K001-SPEC-016_1'
																						) THEN VALUE1 END AS Solids_amount--고형분
											,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
																			,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																					WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																					WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																					ELSE '-' END
																			,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
																	ORDER BY PROD_VER_CODE DESC
																			,ISNULL( ATTR_01, '00') DESC
																			,IF_SEQ DESC
																			,WO_ID DESC														 ) NUM
											,ATTR_10 -- 2021-06-24 kimcd DLD 구분자
											,ATTR_11 -- 2021-06-24 kimcd T(상면), B(하면) 구분자
									  FROM #PLM_ITEM_CONV_CALC			--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
									 WHERE CELLTYPE != 'POUCH'
									   AND CELLTYPE != 'NFF Cylindrical' -- 2022-04-14 김현 [C20220328-000596] NFF Cylindrical 반영 로직 추가
								 --	   AND PROC_FLAG = 'P'				--2019-04-26 PIYONG DEL
									   AND ATTR_04 IS NULL
									UNION ALL
									SELECT CMODEL_CODE
											,PROD_VER_CODE
											,ATTR_01  --차수
											,PRODID
											,AREA_ID
											,WO_ID
											,CASE WHEN UNIT = 'KG' AND SPEC_ITEM_ID IN (
																						'I-C002-SPEC-009_1'
																						,'I-K002-SPEC-009_1'
																						,'I-C001-SPEC-016_1'
																						,'I-K001-SPEC-016_1'
																						) THEN VALUE1 END AS Solids_amount--고형분
											,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
																			,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																					WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																					WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																					ELSE '-' END
																			,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
																	ORDER BY PROD_VER_CODE DESC
																			,ISNULL( ATTR_01, '00') DESC
																			,IF_SEQ DESC
																			,WO_ID DESC														 ) NUM
											,ATTR_10 -- 2021-06-24 kimcd DLD 구분자
											,ATTR_11 -- 2021-06-24 kimcd T(상면), B(하면) 구분자
									  FROM #PLM_ITEM_CONV_CALC			--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
									 WHERE CELLTYPE != 'POUCH'
									   AND CELLTYPE != 'NFF Cylindrical' -- 2022-04-14 김현 [C20220328-000596] NFF Cylindrical 반영 로직 추가
								 --	   AND PROC_FLAG = 'P'				--2019-04-26 PIYONG DEL
									   AND ATTR_04 IS NOT NULL

									) A
							  INNER JOIN SCM_FACTORY_M F
									  ON A.AREA_ID = F.FACTORY_ID
							  WHERE NUM = 1
							--  AND CMODEL_CODE ='MCCE127501B1'
							--  AND AREA_ID = 'E3'
							--  AND PROD_VER_CODE = '006'
							  GROUP BY CMODEL_CODE
									,PROD_VER_CODE
									,ATTR_01  --차수
									,SUBSTRING(PRODID, 1 ,4)
									,AREA_ID
									,WO_ID
									,F.COMPANY_ID
									,F.DIVISION_ID
									,F.SITE_ID
									,F.PLANT_ID
						   ) AA
				   ) AAA
			 WHERE Solids_amount IS NOT  NULL
			   AND AREA_ID NOT IN ( 'EA' )


			SET @v_err_check = '4. SCM_ITEM_CONV_CALC_M into #COT_INFO'
			 -- 원각형 Loading 생성
			  SELECT F.COMPANY_ID
					 ,F.DIVISION_ID
					 ,F.SITE_ID
					 ,F.PLANT_ID
					 ,CMODEL_CODE
					 ,PROD_VER_CODE
					 ,ATTR_01  --차수
					 ,VERSION_TYPE
					 ,SSLV.ATTRIBUTE1 AS PROD_VERSION_TYPE
					 ,PRODID
					 ,AREA_ID
					 ,TOP_COATING
					 ,BACK_COATING
					 ,COATED_WIDTH
					 ,TOP_LOAD
					 ,BACK_LOAD
					 ,LOADING
					 ,PATTERN_WIDTH
					 ,TOP_UNCOATED_WIDTH
					 ,[DBO].[FN_SITE_TIME] ( SITE_ID ) AS EFF_END_DATE	-- 2020-02-19 PIYONG ADD
					 ,APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
				INTO #COT_INFO
				FROM (
					 SELECT CMODEL_CODE
							,PROD_VER_CODE
							,ATTR_01  --차수
							,VERSION_TYPE
							,PLM_FACTORY_CODE
							,PRODID
							,AREA_ID
							,SUM( TOP_COATING ) AS TOP_COATING
							,SUM( BACK_COATING ) AS BACK_COATING
							,SUM( COATED_WIDTH ) AS COATED_WIDTH
							,SUM( TOP_UNCOATED_WIDTH ) AS TOP_UNCOATED_WIDTH
							--top 코팅부 + 미코팅부
							,SUM( TOP_COATING ) + ISNULL(SUM( TOP_UNCOATED_WIDTH ) , 0) AS PATTERN_WIDTH
							,SUM( TOP_LOAD ) AS TOP_LOAD
							,SUM( BACK_LOAD ) AS BACK_LOAD
							--( ( (  패턴[㎜]>Top>코팅부  * 패턴[㎜]>>코팅부폭[㎜] ) * Loading [㎎/25㎠]>>Top / 25  ) +
							,( ( ( ( SUM( TOP_COATING ) * SUM( COATED_WIDTH ) ) * SUM( TOP_LOAD ) / 25) + 
							--  ( (  패턴[㎜]>Back>코팅부 * 패턴[㎜]>>코팅부폭[㎜] ) * Loading [㎎/25㎠]>>Back/ 25  ) ) / 100
								 ( ( SUM( BACK_COATING ) * SUM( COATED_WIDTH ) ) * SUM( BACK_LOAD )  / 25) ) / 100 )
							-- 2021-06-24 kimcd C20210626-000019 DLD 음극은 TOP LOAD만 적용 시작
							/ /* 2021-12-28 kimcd E7,EE 로직 막음 CASE WHEN AREA_ID IN ( 'E7', 'EE') AND MAX(ATTR_10) = 'Y' AND PRODID LIKE 'APCA%' THEN 2.0 ELSE */ 1.0 /*END*/  AS LOADING
							-- 2021-06-24 kimcd DLD 음극은 TOP LOAD만 적용 끝
							,MAX(AA.ATTR_05)   AS APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
					  FROM (
							SELECT CMODEL_CODE
									,PROD_VER_CODE
									,ATTR_01  --차수
									,VERSION_TYPE
									,PLM_FACTORY_CODE
									,PRODID
									,AREA_ID
									--	 사용자 입력값 중  / 기준으로 2개를 입력 하는 경우가 있음 두수를 합해야 함  (예-> 790/356  )
									,CASE WHEN CHARINDEX('/',TOP_COATING)  > 0 THEN		-- '/' 가 존재 하는 지 확인
											CONVERT( float,SUBSTRING(TOP_COATING, 0, CHARINDEX('/',TOP_COATING) ) ) +	-- / 앞쪽의 수를 구한다
											CASE WHEN CHARINDEX('/',TOP_COATING, CHARINDEX('/',TOP_COATING)) > 0 THEN	-- / 뒷 쪽의 수가 존재 하는지 확인
													--  첫번째  / 위치 +1 에서  시작해서   문자열 전체 길이에 /의 첫번째 위치 빼  자를 길이를 구한다 ( 예 '790 / 356',  5, 9-5)
													CONVERT ( float, SUBSTRING(TOP_COATING, CHARINDEX('/', TOP_COATING, CHARINDEX('/',TOP_COATING) ) +1, LEN(TOP_COATING) -
																 CHARINDEX('/', TOP_COATING, CHARINDEX('/',TOP_COATING) ) )
															 )
												ELSE
													0
												END
										  ELSE
											TOP_COATING
										  END AS TOP_COATING
									,CASE WHEN CHARINDEX('/',BACK_COATING)  > 0 THEN
											CONVERT( float,SUBSTRING(BACK_COATING, 0, CHARINDEX('/',BACK_COATING) )  )+ 
											CASE WHEN  CHARINDEX('/',BACK_COATING, CHARINDEX('/',BACK_COATING)) > 0 THEN
													CONVERT ( float, SUBSTRING(BACK_COATING, CHARINDEX('/', BACK_COATING, CHARINDEX('/',BACK_COATING) ) +1, LEN(BACK_COATING) -
																 CHARINDEX('/', BACK_COATING, CHARINDEX('/',BACK_COATING) ) )
															 )
												ELSE
													0
												END
										  ELSE
											BACK_COATING
										  END AS BACK_COATING
									,CASE WHEN CHARINDEX('/',COATED_WIDTH)  > 0 THEN
											CONVERT( float,SUBSTRING(COATED_WIDTH, 0, CHARINDEX('/',COATED_WIDTH) ) ) + 
											CASE WHEN  CHARINDEX('/',COATED_WIDTH, CHARINDEX('/',COATED_WIDTH)) > 0 THEN
													CONVERT ( float, SUBSTRING(COATED_WIDTH, CHARINDEX('/', COATED_WIDTH, CHARINDEX('/',COATED_WIDTH) ) +1, LEN(COATED_WIDTH) -
																 CHARINDEX('/', COATED_WIDTH, CHARINDEX('/',COATED_WIDTH) ) )
															 )
												ELSE
													0
												END
										  ELSE
											COATED_WIDTH
										  END AS COATED_WIDTH
									,CASE WHEN CHARINDEX('/',TOP_UNCOATED_WIDTH)  > 0 THEN
											CONVERT( float,SUBSTRING(TOP_UNCOATED_WIDTH, 0, CHARINDEX('/',TOP_UNCOATED_WIDTH) ) ) + 
											CASE WHEN  CHARINDEX('/',TOP_UNCOATED_WIDTH, CHARINDEX('/',TOP_UNCOATED_WIDTH)) > 0 THEN
													CONVERT ( float, SUBSTRING(TOP_UNCOATED_WIDTH, CHARINDEX('/', TOP_UNCOATED_WIDTH, CHARINDEX('/',TOP_UNCOATED_WIDTH) ) +1, LEN(TOP_UNCOATED_WIDTH) -
																 CHARINDEX('/', TOP_UNCOATED_WIDTH, CHARINDEX('/',TOP_UNCOATED_WIDTH) ) )
															 )
												ELSE
													0
												END
										  ELSE
											TOP_UNCOATED_WIDTH
										  END AS TOP_UNCOATED_WIDTH
									,CASE WHEN CHARINDEX('/',TOP_LOAD)  > 0 THEN
											CONVERT( float,SUBSTRING(TOP_LOAD, 0, CHARINDEX('/',TOP_LOAD) )  )+ 
											CASE WHEN  CHARINDEX('/',TOP_LOAD, CHARINDEX('/',TOP_LOAD)) > 0 THEN
													CONVERT ( float, SUBSTRING(TOP_LOAD, CHARINDEX('/', TOP_LOAD, CHARINDEX('/',TOP_LOAD) ) +1, LEN(TOP_LOAD) -
																 CHARINDEX('/', TOP_LOAD, CHARINDEX('/',TOP_LOAD) ) )
															 )
												ELSE
													0
												END
										  ELSE
											TOP_LOAD
										  END AS TOP_LOAD
									,CASE WHEN CHARINDEX('/',BACK_LOAD)  > 0 THEN
											CONVERT( float,SUBSTRING(BACK_LOAD, 0, CHARINDEX('/',BACK_LOAD) ) ) + 
											CASE WHEN  CHARINDEX('/',BACK_LOAD, CHARINDEX('/',BACK_LOAD)) > 0 THEN
													CONVERT ( float, SUBSTRING(BACK_LOAD, CHARINDEX('/', BACK_LOAD, CHARINDEX('/',BACK_LOAD) ) +1, LEN(BACK_LOAD) -
																 CHARINDEX('/', BACK_LOAD, CHARINDEX('/',BACK_LOAD) ) )
															 )
												ELSE
													0
												END
										  ELSE
											BACK_LOAD
										  END AS BACK_LOAD
									,A.ATTR_05 -- 2020-07-10 kimcd ATTR_05 적용일자 추가
									,ATTR_10 -- 2021-06-24 kimcd DLD 구분자
							   FROM (
										SELECT CMODEL_CODE
											   ,PROD_VER_CODE
											   ,ATTR_01													--차수
											   ,CASE  LEFT(PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE
											   ,ATTR_04 AS PLM_FACTORY_CODE
											   ,PRODID
											   ,AREA_ID
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			'I-K014-SPEC-003'
																			,'I-C014-SPEC-003'
																			,'I-C009-SPEC-003'
																			,'I-K009-SPEC-003'
																		  ) THEN VALUE2 END AS TOP_COATING -- TOP 패턴길이
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			'I-K014-SPEC-005'
																			,'I-K009-SPEC-005'
																			,'I-C009-SPEC-005'
																			,'I-C014-SPEC-005'
																		  ) THEN VALUE2 END AS BACK_COATING -- BACK패턴길이
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			'I-K014-SPEC-011'
																			,'I-K014-SPEC-012'
																			,'I-C014-SPEC-011'
																			,'I-C014-SPEC-012'
																			,'I-C009-SPEC-011'
																			,'I-C009-SPEC-012'
																			,'I-K009-SPEC-011'
																			,'I-K009-SPEC-012'
																		  ) THEN CASE WHEN CHARINDEX('(',VALUE1)  > 0 THEN 
																							SUBSTRING(VALUE1, 1, CHARINDEX('(', VALUE1, CHARINDEX('(',VALUE1) ) -1 )
																						ELSE
																							VALUE1
																		              END
																				  END AS COATED_WIDTH -- 코팅부폭
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			'I-K014-SPEC-004'
																			,'I-C014-SPEC-004'
																			,'I-C009-SPEC-004'
																			,'I-K009-SPEC-004'
																		  ) THEN VALUE2 END AS TOP_UNCOATED_WIDTH -- TOP 미코팅부
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			'I-K009-SPEC-001'
																			,'I-C009-SPEC-001'
																			,'I-K014-SPEC-001'
																			,'I-C014-SPEC-001'
																		  ) THEN VALUE2 END AS TOP_LOAD -- TOP_Loading
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			'I-K009-SPEC-002'
																			,'I-C009-SPEC-002'
																			,'I-C014-SPEC-002'
																			,'I-K014-SPEC-002'
																		  ) THEN VALUE2 END AS BACK_LOAD -- BACK_Loading
											   ,ATTR_05 -- 2020-07-10 kimcd ATTR_05 적용일자 추가
											   ,ATTR_10 -- 2021-06-24 kimcd DLD 구분자
											   ,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID ,SPEC_ITEM_ID
																			 ,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																				   WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																				   WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN 'S'
																				   WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																				   ELSE '-' END
																			 ,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
																	   ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																						 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																					 WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																					 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-11-06 PIYONG ADD P버전
																						 REPLACE( REPLACE( PROD_VER_CODE, 'S', '\'), 'Z', '/') 
																					 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN REPLACE( PROD_VER_CODE, 'S', '\')  -- 2019-11-06 PIYONG ADD P버전
																					 WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/')
																					 ELSE PROD_VER_CODE END DESC
																				 , ISNULL( ATTR_01, '00') DESC
																				 , IF_SEQ DESC						 ) NUM
										  FROM #PLM_ITEM_CONV_CALC			--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
									     WHERE CELLTYPE != 'POUCH'
										   AND CELLTYPE != 'NFF Cylindrical' -- 2022-04-14 김현 [C20220328-000596] NFF Cylindrical 반영 로직 추가
										   AND ATTR_04 IS NULL
								   --	   AND PROC_FLAG = 'P'				--2019-04-26 PIYONG DEL
									--	   AND CMODEL_CODE = 'MCR465275A10'
									--	   AND AREA_ID = 'E4'
										UNION ALL
										SELECT CMODEL_CODE
											   ,PROD_VER_CODE
											   ,ATTR_01														--차수
											   ,CASE  LEFT(PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE
											   ,ATTR_04 AS PLM_FACTORY_CODE
											   ,PRODID
											   ,AREA_ID
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			'I-K014-SPEC-003'
																			,'I-C014-SPEC-003'
																			,'I-C009-SPEC-003'
																			,'I-K009-SPEC-003'
																		  ) THEN VALUE2 END AS TOP_COATING -- TOP 패턴길이
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			'I-K014-SPEC-005'
																			,'I-K009-SPEC-005'
																			,'I-C009-SPEC-005'
																			,'I-C014-SPEC-005'
																		  ) THEN VALUE2 END AS BACK_COATING -- BACK패턴길이
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			'I-K014-SPEC-011'
																			,'I-K014-SPEC-012'
																			,'I-C014-SPEC-011'
																			,'I-C014-SPEC-012'
																			,'I-C009-SPEC-011'
																			,'I-C009-SPEC-012'
																			,'I-K009-SPEC-011'
																			,'I-K009-SPEC-012'
																		  ) THEN CASE WHEN CHARINDEX('(',VALUE1)  > 0 THEN 
																							SUBSTRING(VALUE1, 1, CHARINDEX('(', VALUE1, CHARINDEX('(',VALUE1) ) -1 )
																						ELSE
																							VALUE1
																		              END
																				  END AS COATED_WIDTH -- 코팅부폭
												,CASE WHEN SPEC_ITEM_ID IN (
																			'I-K014-SPEC-004'
																			,'I-C014-SPEC-004'
																			,'I-C009-SPEC-004'
																			,'I-K009-SPEC-004'
																		  ) THEN VALUE2 END AS TOP_UNCOATED_WIDTH -- TOP 미코팅부
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			'I-K009-SPEC-001'
																			,'I-C009-SPEC-001'
																			,'I-K014-SPEC-001'
																			,'I-C014-SPEC-001'
																		  ) THEN VALUE2 END AS TOP_LOAD -- TOP_LOAD
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			'I-K009-SPEC-002'
																			,'I-C009-SPEC-002'
																			,'I-C014-SPEC-002'
																			,'I-K014-SPEC-002'
																		  ) THEN VALUE2 END AS BACK_LOAD -- BACK_LOAD
											   ,ATTR_05 -- 2020-07-10 kimcd ATTR_05 적용일자 추가
											   ,ATTR_10 -- 2021-06-24 kimcd DLD 구분자
											   ,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID ,SPEC_ITEM_ID
																				,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																					  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																					  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN 'S'
																					  WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																					  ELSE '-' END
																				,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
																	   ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																						 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																					 WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																					 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-11-06 PIYONG ADD P버전
																						 REPLACE( REPLACE( PROD_VER_CODE, 'S', '\'), 'Z', '/') 
																					 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN REPLACE( PROD_VER_CODE, 'S', '\')  -- 2019-11-06 PIYONG ADD P버전
																					 WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
																					 ELSE PROD_VER_CODE END DESC
																				 , ISNULL( ATTR_01, '00') DESC
																				 , IF_SEQ DESC						 ) NUM
										  FROM #PLM_ITEM_CONV_CALC	--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
										 WHERE CELLTYPE != 'POUCH'
										   AND CELLTYPE != 'NFF Cylindrical' -- 2022-04-14 김현 [C20220328-000596] NFF Cylindrical 반영 로직 추가
										   AND ATTR_04 IS NOT NULL
									--	   AND PROC_FLAG = 'P'	--2019-04-26 PIYONG DEL
									--	   AND AREA_ID = 'E4'

									) A
							  WHERE NUM = 1
							--	AND CMODEL_CODE = 'MCR465275A10'
							--	AND AREA_ID = 'E4'
						   ) AA
					 GROUP BY CMODEL_CODE
							,PROD_VER_CODE
							,ATTR_01  --차수
							,VERSION_TYPE
							,PLM_FACTORY_CODE
							,PRODID
							,AREA_ID
					 ) AAA
				     INNER JOIN SCM_FACTORY_M F
						     ON AAA.AREA_ID = F.FACTORY_ID
				     INNER JOIN SCM_SYS_LOOKUP_VALUE SSLV
						     ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
						    AND SEGMENT4 = AAA.AREA_ID
						    AND SEGMENT5 = ISNULL(AAA.PLM_FACTORY_CODE, '-')
			   WHERE LOADING IS NOT NULL
				 AND AREA_ID NOT IN ( 'EA' )




			-- LANE  수
			/*
			SELECT COMPANY_ID
					,DIVISION_ID
					,SITE_ID
					,AA.PLANT_ID
					,CMODEL_CODE
					,PROD_VER_CODE
					,ATTR_01  --차수
					,VERSION_TYPE
					,ISNULL(SSLV.ATTRIBUTE1, 'GENERAL' ) AS PROD_VERSION_TYPE
					,PRODID
					,AREA_ID
					,LANE_CNT
			 INTO #LANE_INFO
			 FROM (
					SELECT F.COMPANY_ID
							,F.DIVISION_ID
							,F.SITE_ID
							,F.PLANT_ID
							,CMODEL_CODE
							,PROD_VER_CODE
							,ATTR_01  --차수
							,VERSION_TYPE
							,PLM_FACTORY_CODE
							,PRODID
							,AREA_ID
							,SUM( CONVERT( INT, LANE_CNT)  ) AS LANE_CNT
					  FROM (
							SELECT CMODEL_CODE
									,PROD_VER_CODE
									,ATTR_01  --차수
									,CASE  LEFT(PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE
									,ATTR_04 AS PLM_FACTORY_CODE
									,PRODID
									,AREA_ID
									,CASE WHEN SPEC_ITEM_ID IN (
																'I-K011-SPEC-C08'
																,'I-C011-SPEC-C08'
																,'I-C016-SPEC-C08'
																,'I-K011-SPEC-008'
																,'I-K016-SPEC-008'
																,'I-C011-SPEC-008'
																,'I-C016-SPEC-008'
																,'I-K016-SPEC-C08'
																) THEN VALUE1 END AS LANE_CNT	--LANE 수
									,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
																	,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																		  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																		  ELSE '-' END
																	,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
															ORDER BY PROD_VER_CODE DESC
																,ISNULL( ATTR_01, '00') DESC
																,IF_SEQ DESC
																,WO_ID DESC						 ) NUM
							  FROM SY_XIF_PLM_WO_INSP_SPEC_R
							 WHERE CELLTYPE != 'POUCH'
							   AND PRODID IS NOT NULL
							   AND ATTR_04 IS NULL
							   --AND PROC_FLAG = 'P'
							UNION ALL
							SELECT CMODEL_CODE
									,PROD_VER_CODE
									,ATTR_01  --차수
									,CASE  LEFT(PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE
									,ATTR_04 AS PLM_FACTORY_CODE
									,PRODID
									,AREA_ID
									,CASE WHEN SPEC_ITEM_ID IN (
																'I-K011-SPEC-C08'
																,'I-C011-SPEC-C08'
																,'I-C016-SPEC-C08'
																,'I-K011-SPEC-008'
																,'I-K016-SPEC-008'
																,'I-C011-SPEC-008'
																,'I-C016-SPEC-008'
																,'I-K016-SPEC-C08'
																) THEN VALUE1 END AS LANE_CNT	--LANE 수
									,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
																	,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																		  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																		  ELSE '-' END
																	,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
															ORDER BY PROD_VER_CODE DESC
																,ISNULL( ATTR_01, '00') DESC
																,IF_SEQ DESC
																,WO_ID DESC						 ) NUM
							  FROM SY_XIF_PLM_WO_INSP_SPEC_R
							 WHERE CELLTYPE != 'POUCH'
							   AND PRODID IS NOT NULL
							   AND ATTR_04 IS NOT NULL
							   --AND PROC_FLAG = 'P'
						   ) A
							INNER JOIN SCM_FACTORY_M F
									ON A.AREA_ID = F.FACTORY_ID
								 WHERE NUM = 1
							--	   AND CMODEL_CODE ='MCCE127501B1'
							--	   AND AREA_ID = 'E3'
							--	   AND PROD_VER_CODE = '006'
								 GROUP BY CMODEL_CODE
										,PROD_VER_CODE
										,ATTR_01  --차수
										,VERSION_TYPE
										,PLM_FACTORY_CODE
										,PRODID
										,AREA_ID
										,F.COMPANY_ID
										,F.DIVISION_ID
										,F.SITE_ID
										,F.PLANT_ID
				  ) AA
				  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV
							   ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
							  AND SEGMENT4 = AA.AREA_ID
							  AND SEGMENT5 = AA.PLM_FACTORY_CODE
			WHERE LANE_CNT IS NOT NULL
			  AND AREA_ID IN ('E2', 'E3') 
			*/

			--Cell/batch

			SET @v_err_check = '4. SCM_ITEM_CONV_CALC_M into #CELL_BATCH'

			SELECT MAX(COMPANY_ID) AS COMPANY_ID
					,MAX(DIVISION_ID) AS DIVISION_ID
					,MAX(SITE_ID) AS SITE_ID
					,MAX(PLANT_ID) AS PLANT_ID
					,[MODEL_CODE]
					,MAX([PROJECT_NAME]) AS [PROJECT_NAME]
					,[ITEM_ID]
					,[VERSION]
					,ATTR_01  --차수
					,[FACTORY_ID]
					,[OPERATION_ID]
					,SUM(CELL_BATCH) AS CELL_BATCH
					,MAX(VERSION_TYPE) AS VERSION_TYPE
					,MAX(PROD_VERSION_TYPE) AS PROD_VERSION_TYPE
					,MAX(APPLY_DATE)   AS APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
			  INTO #CELL_BATCH
			  FROM (
					SELECT P.COMPANY_ID
							,P.DIVISION_ID
							,P.SITE_ID
							,P.PLANT_ID
							,C.CMODEL_CODE AS [MODEL_CODE]
							,ISNULL(M.NICK_NAME, MM.NICK_NAME) AS [PROJECT_NAME]
							,P.PRODID AS [ITEM_ID]
							,C.PROD_VER_CODE AS [VERSION]
							,C.ATTR_01  --차수
							,C.AREA_ID AS [FACTORY_ID]
							,'E2000' AS OPERATION_ID
							,C.PRODID AS MIX_PRODID
							,C.Solids_amount
							,TOP_COATING
							,BACK_COATING
							,COATED_WIDTH
							,TOP_LOAD
							,BACK_LOAD
							,TOP_UNCOATED_WIDTH
							,PATTERN_WIDTH
							,LOADING
							,LANE_CNT
							,C.Solids_amount / LOADING * LANE_CNT * POWER(10, 6) AS  CELL_BATCH		-- 고형분/로딩량*레인수*10^6
							,P.VERSION_TYPE
							,P.PROD_VERSION_TYPE
							,P.APPLY_DATE   AS APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
					  FROM (
							SELECT DISTINCT M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.AREA_ID, M.CMODEL_CODE, M.PRODID, I.CHILD_ITEM_ID
									,PROD_VER_CODE
									,ATTR_01  --차수
									,TOP_COATING
									,BACK_COATING
									,COATED_WIDTH
									,TOP_LOAD
									,BACK_LOAD
									,LOADING
									,PATTERN_WIDTH
									,TOP_UNCOATED_WIDTH
									,VERSION_TYPE
									,PROD_VERSION_TYPE
									,M.APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
							  FROM #COT_INFO M
								   INNER JOIN [SCM_MODEL_COMP_EFFECTIVE_DATE] I			-- 2020-02-19 PIYONG CHANGE [SCM_MODEL_COMP_TEMP] -> [SCM_MODEL_COMP_EFFECTIVE_DATE]
										   ON 1=1
									--	  AND M.COMPANY_ID	= I.CHILD_COMPANY_ID
									--	  AND M.DIVISION_ID	= I.CHILD_DIVISION_ID
									--	  AND M.SITE_ID		= I.CHILD_SITE_ID
									--	  AND M.PLANT_ID	= I.CHILD_PLANT_ID
										  AND M.PRODID		= I.PARENT_ITEM_ID
										  AND M.CMODEL_CODE = I.MODEL_ID
							 WHERE I.CHILD_ITEM_ID LIKE 'ASL%'
							   AND I.EFF_END_DATE > M.EFF_END_DATE						-- 2020-02-19 PIYONG ADD
						   ) P 
					 INNER JOIN #MIX_INFO C
							 ON P.COMPANY_ID	= C.COMPANY_ID
							AND P.DIVISION_ID	= C.DIVISION_ID
							AND P.SITE_ID		= C.SITE_ID
							AND P.PLANT_ID		= C.PLANT_ID
							AND P.AREA_ID		= C.AREA_ID
							AND P.CMODEL_CODE	= C.CMODEL_CODE
							AND P.CHILD_ITEM_ID	= C.PRODID
							AND P.PROD_VER_CODE	= C.PROD_VER_CODE
							AND ISNULL(P.ATTR_01, '00')		= ISNULL(C.ATTR_01, '00')  --차수
					 INNER JOIN #LANE_INFO D
							 ON P.COMPANY_ID	= D.COMPANY_ID
							AND P.DIVISION_ID	= D.DIVISION_ID
							AND P.SITE_ID		= D.SITE_ID
							AND P.PLANT_ID		= D.PLANT_ID
							AND P.AREA_ID		= D.AREA_ID
							AND P.PRODID		= D.PRODID
							AND P.PROD_VERSION_TYPE	= D.PROD_VERSION_TYPE
					 LEFT OUTER JOIN SCM_ITEM_M M					--NICK_NAME
								  ON P.COMPANY_ID	= M.COMPANY_ID
								 AND P.DIVISION_ID	= M.DIVISION_ID
								 AND P.CMODEL_CODE	= M.[ITEM_ID]
					 LEFT OUTER JOIN SCM_ITEM_M MM					--NICK_NAME
								  ON P.COMPANY_ID	= MM.COMPANY_ID
								 AND P.DIVISION_ID	= MM.DIVISION_ID
								 AND P.PRODID		= MM.[ITEM_ID]
					) AA
			  GROUP BY COMPANY_ID
					,[FACTORY_ID]
					,[MODEL_CODE]
					,[VERSION]
					,ATTR_01  --차수
					,[ITEM_ID]
					,[OPERATION_ID]



			SET @v_err_check = '4. SCM_ITEM_CONV_CALC_M into #M_BATCH'

			--JUMBO ROLL (M/BATCH)
			SELECT MAX(COMPANY_ID) AS COMPANY_ID
					,MAX(DIVISION_ID) AS DIVISION_ID
					,MAX(SITE_ID) AS SITE_ID
					,MAX(PLANT_ID) AS PLANT_ID
					,[MODEL_CODE]
					,MAX([PROJECT_NAME]) AS [PROJECT_NAME]
					,[ITEM_ID]
					,[VERSION]
					,ATTR_01  --차수
					,[FACTORY_ID]
					,[OPERATION_ID]
					,SUM(M_BATCH) AS M_BATCH
					,MAX([ACCT_NAME]) AS [ACCT_NAME]
					,MAX(PROD_VERSION_TYPE) AS PROD_VERSION_TYPE
					,MAX(VERSION_TYPE) AS VERSION_TYPE
					,MAX(APPLY_DATE)   AS APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
			  INTO #M_BATCH
			  FROM (
						SELECT P.COMPANY_ID
								,P.DIVISION_ID
								,P.SITE_ID
								,P.PLANT_ID
								,C.CMODEL_CODE AS [MODEL_CODE]
								,ISNULL(M.NICK_NAME, MM.NICK_NAME) AS [PROJECT_NAME]
								,P.PRODID AS [ITEM_ID]
								,C.PROD_VER_CODE AS [VERSION]
								,C.ATTR_01						  --차수
								,P.PROD_VERSION_TYPE
								,B.VERSION_TYPE
								,C.AREA_ID AS [FACTORY_ID]
								,'E2000' AS OPERATION_ID
								,C.PRODID AS MIX_PRODID
								,C.Solids_amount
								,TOP_COATING
								,BACK_COATING
								,COATED_WIDTH
								,TOP_LOAD
								,BACK_LOAD
								,P.LOADING
								,D.LANE_CNT
								,B.CELL_BATCH
								,TOP_UNCOATED_WIDTH
								,PATTERN_WIDTH
								,B.CELL_BATCH / D.LANE_CNT * PATTERN_WIDTH * 0.001 AS M_BATCH		--배치당cell수/레인수*패턴길이*10^-3
								,P.APPLY_DATE  -- 2020-07-10 kimcd ATTR_05 적용일자 추가
								,(SELECT ATTRIBUTE1
									FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
									AND SEGMENT1 = 'm/batch'
									AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
						  FROM (
								SELECT DISTINCT M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.AREA_ID, M.CMODEL_CODE, M.PRODID, I.CHILD_ITEM_ID
										,PROD_VER_CODE
										,M.ATTR_01  --차수
										,TOP_COATING
										,BACK_COATING
										,COATED_WIDTH
										,TOP_LOAD
										,BACK_LOAD
										,LOADING
										,PATTERN_WIDTH
										,TOP_UNCOATED_WIDTH
										,PROD_VERSION_TYPE
										,M.APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
									FROM #COT_INFO M
										INNER JOIN [SCM_MODEL_COMP_EFFECTIVE_DATE] I		-- 2020-02-19 PIYONG CHANGE [SCM_MODEL_COMP_TEMP] -> [SCM_MODEL_COMP_EFFECTIVE_DATE]
												ON 1=1
										--		AND M.COMPANY_ID	= I.CHILD_COMPANY_ID
										--		AND M.DIVISION_ID	= I.CHILD_DIVISION_ID
										--		AND M.SITE_ID		= I.CHILD_SITE_ID
										--		AND M.PLANT_ID		= I.CHILD_PLANT_ID
												AND M.PRODID		= I.PARENT_ITEM_ID
												AND M.CMODEL_CODE	= I.MODEL_ID
									WHERE I.CHILD_ITEM_ID LIKE 'ASL%'
									  AND I.EFF_END_DATE > M.EFF_END_DATE					-- 2020-02-19 PIYONG ADD
							   ) P
							   INNER JOIN #CELL_BATCH B
									   ON P.COMPANY_ID	= B.COMPANY_ID
									  AND P.DIVISION_ID	= B.DIVISION_ID
									  AND P.SITE_ID		= B.SITE_ID
									  AND P.PLANT_ID	= B.PLANT_ID
									  AND P.AREA_ID		= B.FACTORY_ID
									  AND P.CMODEL_CODE	= B.MODEL_CODE
									  AND P.PRODID		= B.ITEM_ID
									  AND P.PROD_VER_CODE	= B.VERSION
									  AND ISNULL(P.ATTR_01, '00')	= ISNULL(B.ATTR_01, '00')  --차수
							   INNER JOIN #MIX_INFO C
									   ON P.COMPANY_ID		= C.COMPANY_ID
									  AND P.DIVISION_ID		= C.DIVISION_ID
									  AND P.SITE_ID			= C.SITE_ID
									  AND P.PLANT_ID		= C.PLANT_ID
									  AND P.AREA_ID			= C.AREA_ID
									  AND P.CMODEL_CODE		= C.CMODEL_CODE
									  AND P.CHILD_ITEM_ID	= C.PRODID
									  AND P.PROD_VER_CODE	= C.PROD_VER_CODE
									  AND ISNULL(P.ATTR_01, '00')	= ISNULL(C.ATTR_01, '00')  --차수
							   INNER JOIN #LANE_INFO D
										ON P.COMPANY_ID		= D.COMPANY_ID
									   AND P.DIVISION_ID	= D.DIVISION_ID
									   AND P.SITE_ID		= D.SITE_ID
									   AND P.PLANT_ID		= D.PLANT_ID
									   AND P.AREA_ID		= D.AREA_ID
									   AND P.PRODID			= D.PRODID
									   AND P.PROD_VERSION_TYPE	= D.PROD_VERSION_TYPE
								LEFT OUTER JOIN SCM_ITEM_M M					--NICK_NAME
										ON P.COMPANY_ID		= M.COMPANY_ID
									   AND P.DIVISION_ID	= M.DIVISION_ID
									   AND P.CMODEL_CODE	= M.[ITEM_ID]
								LEFT OUTER JOIN SCM_ITEM_M MM					--NICK_NAME
										ON P.COMPANY_ID		= MM.COMPANY_ID
									   AND P.DIVISION_ID	= MM.DIVISION_ID
									   AND P.PRODID			= MM.[ITEM_ID]
				   ) AA
			 GROUP BY [MODEL_CODE]
					,[ITEM_ID]
					,[VERSION]
					,ATTR_01  --차수
					,[FACTORY_ID]
					,[OPERATION_ID]



			SET @v_err_check = '5. SCM_ITEM_CONV_CALC_M from #CELL_BATCH'
			--  Cell/batch		
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT X.*
					  FROM (

					 SELECT COMPANY_ID
						   ,DIVISION_ID
						   ,SITE_ID
						   ,A.PLANT_ID
						   ,MODEL_CODE
						   ,PROJECT_NAME
						   ,NULL AS CA_FLAG
						   ,ITEM_ID
						   ,VERSION
						   ,FACTORY_ID
						   ,OPERATION_ID
						   ,CELL_BATCH
						   ,(SELECT ATTRIBUTE1
									FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
									AND SEGMENT1 = N'cell/batch'
									AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
						   ,PROD_VERSION_TYPE
						   ,VERSION_TYPE
						   ,ATTR_01    AS PROD_SEQ  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,ROW_NUMBER() OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_CODE, PROJECT_NAME, ITEM_ID, VERSION, FACTORY_ID, OPERATION_ID,  PROD_VERSION_TYPE, VERSION_TYPE ORDER BY ATTR_01 DESC) AS RANKNO
				      FROM #CELL_BATCH A

						   ) AS X
				     WHERE X.RANKNO = 1

				  ) B
			  ON (
					A.[COMPANY_ID]			= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]		= B.[FACTORY_ID]
				  AND A.[MODEL_ID]			= B.[MODEL_CODE]
				  AND A.[VERSION]			= B.[VERSION]
				  AND A.[OPERATION]			= B.[OPERATION_ID]
				  AND A.[ITEM_ID]			= B.[ITEM_ID]
				  AND A.[CATEGORY]			= B.[ACCT_NAME]
				  AND A.[PROD_VERSION_TYPE]	= B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[CELL_BATCH] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[VALUE] ELSE B.[CELL_BATCH] END END -- 차수가 다른 경우 값 갱신 
						   ,[MMD_VALUE] = B.[CELL_BATCH]
						   ,[VERSION_TYPE]		= B.[VERSION_TYPE] 
						   ,[APPLY_DATE]  = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]    = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID]   = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신 
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ]    -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[CELL_BATCH]
					,B.[CELL_BATCH]
					,'N'
					,B.[PROD_VERSION_TYPE]
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;



			SET @v_err_check = '6. SCM_ITEM_CONV_CALC_M from #M_BATCH'
			--  Jumbo Roll (m/batch)
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT X.*
					  FROM (

					SELECT COMPANY_ID
						   ,DIVISION_ID
						   ,SITE_ID
						   ,PLANT_ID
						   ,MODEL_CODE
						   ,PROJECT_NAME
						   ,NULL AS CA_FLAG
						   ,ITEM_ID
						   ,VERSION
						   ,FACTORY_ID
						   ,OPERATION_ID
						   ,M_BATCH
						   ,ACCT_NAME
						   ,PROD_VERSION_TYPE
						   ,VERSION_TYPE
						   ,ATTR_01    AS PROD_SEQ  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,ROW_NUMBER() OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_CODE, PROJECT_NAME, ITEM_ID, VERSION, FACTORY_ID, OPERATION_ID, ACCT_NAME, PROD_VERSION_TYPE, VERSION_TYPE ORDER BY ATTR_01 DESC) AS RANKNO
				      FROM #M_BATCH
						   ) AS X
				     WHERE X.RANKNO = 1

				  ) B
			  ON (
					A.[COMPANY_ID]			= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]		= B.[FACTORY_ID]
				  AND A.[MODEL_ID]			= B.[MODEL_CODE]
				  AND A.[VERSION]			= B.[VERSION]
				  AND A.[OPERATION]			= B.[OPERATION_ID]
				  AND A.[ITEM_ID]			= B.[ITEM_ID]
				  AND A.[CATEGORY]			= B.[ACCT_NAME]
				  AND A.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
   						   ,[VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[M_BATCH] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[VALUE] ELSE B.[M_BATCH] END END -- 차수가 다른 경우 값 갱신 
						   ,[MMD_VALUE] = B.[M_BATCH]
						   ,[VERSION_TYPE] = B.[VERSION_TYPE]
						   ,[APPLY_DATE]  = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]    = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID]   = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신 
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[M_BATCH]
					,B.[M_BATCH]
					,'N'
					,B.[PROD_VERSION_TYPE]
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;





			SET @v_err_check = '7. SCM_ITEM_CONV_CALC_M from #CELL_BATCH'
			--  Jumbo Roll (cell/m)
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT X.*
					  FROM (


					 SELECT M.COMPANY_ID
						   ,M.DIVISION_ID
						   ,M.SITE_ID
						   ,M.PLANT_ID
						   ,M.MODEL_CODE
						   ,M.PROJECT_NAME
						   ,NULL AS CA_FLAG
						   ,M.ITEM_ID
						   ,M.VERSION
						   ,M.FACTORY_ID
						   ,M.OPERATION_ID
						   ,C.CELL_BATCH / M_BATCH AS CELL_M
						   ,(SELECT ATTRIBUTE1
							   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
							  WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
								AND SEGMENT1 = N'점보롤 cell/m'
								AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
						   ,M.PROD_VERSION_TYPE
						   ,M.VERSION_TYPE
						   ,M.ATTR_01    AS PROD_SEQ  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,M.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,ROW_NUMBER() OVER(PARTITION BY M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.MODEL_CODE, M.PROJECT_NAME, M.ITEM_ID, M.VERSION, M.FACTORY_ID, M.OPERATION_ID, M.PROD_VERSION_TYPE, M.VERSION_TYPE ORDER BY M.ATTR_01 DESC) AS RANKNO
				      FROM #M_BATCH M
						   INNER JOIN #CELL_BATCH C
								   ON M.COMPANY_ID	= C.COMPANY_ID
								  AND M.DIVISION_ID = C.DIVISION_ID
								  AND M.SITE_ID		= C.SITE_ID
								  AND M.PLANT_ID	= C.PLANT_ID
								  AND M.FACTORY_ID	= C.FACTORY_ID
								  AND M.MODEL_CODE	= C.MODEL_CODE
								  AND M.ITEM_ID		= C.ITEM_ID
								  AND M.VERSION		= C.VERSION
								  AND ISNULL(M.ATTR_01, '00')	= ISNULL(C.ATTR_01, '00')
						   ) AS X
				     WHERE X.RANKNO = 1


				  ) B
			  ON (
					A.[COMPANY_ID]			= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]		= B.[FACTORY_ID]
				  AND A.[MODEL_ID]			= B.[MODEL_CODE]
				  AND A.[VERSION]			= B.[VERSION]
				  AND A.[OPERATION]			= B.[OPERATION_ID]
				  AND A.[ITEM_ID]			= B.[ITEM_ID]
				  AND A.[CATEGORY]			= B.[ACCT_NAME]
				  AND A.[PROD_VERSION_TYPE]	= B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[CELL_M] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[VALUE] ELSE B.[CELL_M] END END -- 차수가 다른 경우 값 갱신 
						   ,[MMD_VALUE] = B.[CELL_M]
						   ,[VERSION_TYPE] = B.[VERSION_TYPE]
						   ,[APPLY_DATE]  = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]    = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID]   = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신 
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[CELL_M]
					,B.[CELL_M]
					,'N'
					,B.[PROD_VERSION_TYPE]
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;


		
		
		
			SET @v_err_check = '8. SCM_ITEM_CONV_CALC_M : Lane수'
			--Lane수
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					 SELECT COMPANY_ID
							,MAX(DIVISION_ID) AS DIVISION_ID
							,MAX(SITE_ID) AS SITE_ID
							,MAX(PLANT_ID) AS PLANT_ID
							,[MODEL_CODE]
							,MAX([PROJECT_NAME]) AS [PROJECT_NAME]
							,NULL AS CA_FLAG
							,[ITEM_ID]
							,[VERSION]
							,[FACTORY_ID]
							,[OPERATION_ID]
							,SUM([VALUE1]) AS [VALUE1]
							,MAX([ACCT_NAME]) AS [ACCT_NAME]
							,MAX(PROD_VERSION_TYPE) AS PROD_VERSION_TYPE
							,MAX(VERSION_TYPE) AS VERSION_TYPE
							,PROD_SEQ   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
							,MAX(APPLY_DATE) AS APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					  FROM (
							SELECT P.COMPANY_ID
									,P.DIVISION_ID
									,P.SITE_ID
									,P.PLANT_ID
									,P.CMODEL_CODE AS [MODEL_CODE]
									,ISNULL(M.NICK_NAME, MM.NICK_NAME) AS [PROJECT_NAME]
									,P.PRODID AS [ITEM_ID]
									,P.PROD_VER_CODE AS [VERSION]
									,P.AREA_ID AS [FACTORY_ID]
									,'E2000' AS OPERATION_ID
									,LANE_CNT AS [VALUE1]
									,(SELECT ATTRIBUTE1
										FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
										WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
										AND SEGMENT1 = N'Lane수'
										AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
									,PROD_VERSION_TYPE
									,VERSION_TYPE
									,P.PROD_SEQ   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
									,P.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
							  FROM (
										SELECT P.COMPANY_ID
												,P.DIVISION_ID
												,P.SITE_ID
												,P.PLANT_ID
												,P.AREA_ID
												,P.CMODEL_CODE
												,P.PRODID
												,P.PROD_VER_CODE
												,P.VERSION_TYPE
												,P.PROD_VERSION_TYPE
												,D.LANE_CNT
												,P.PROD_SEQ   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
												,P.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
										  FROM (

					SELECT X.*
					  FROM (
							SELECT Y.*
									, ROW_NUMBER() OVER(PARTITION BY Y.COMPANY_ID, Y.DIVISION_ID, Y.SITE_ID, Y.PLANT_ID, Y.AREA_ID, Y.CMODEL_CODE, Y.PRODID, Y.PROD_VER_CODE, Y.PROD_VERSION_TYPE, Y.VERSION_TYPE ORDER BY Y.PROD_SEQ DESC) AS RANKNO
								FROM (
												SELECT DISTINCT M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.AREA_ID, M.CMODEL_CODE, M.PRODID
														,M.PROD_VER_CODE
														,M.PROD_VERSION_TYPE
														,M.VERSION_TYPE
														,M.ATTR_01   AS PROD_SEQ -- 2020-07-10 kimcd PROD_SEQ 차수 추가
														,M.APPLY_DATE  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
												  FROM #COT_INFO M
													   INNER JOIN #M_BATCH B		--2019-03-29 PIYONG JOIN ADD
														  ON M.AREA_ID = B.[FACTORY_ID]
														 AND M.CMODEL_CODE = B.[MODEL_CODE]
														 AND M.PRODID = B.[ITEM_ID]
														 AND M.PROD_VER_CODE = B.[VERSION]
														 AND ISNULL(M.ATTR_01, '00')	= ISNULL(B.ATTR_01, '00')  --차수
														 AND M.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE
									 ) AS Y
						   ) AS X
				     WHERE X.RANKNO = 1

											   ) P
											   INNER JOIN #LANE_INFO D
													   ON P.COMPANY_ID	= D.COMPANY_ID
													  AND P.DIVISION_ID	= D.DIVISION_ID
													  AND P.SITE_ID		= D.SITE_ID
													  AND P.PLANT_ID	= D.PLANT_ID
													  AND P.AREA_ID		= D.AREA_ID
													  AND P.PRODID		= D.PRODID
													  AND P.PROD_VERSION_TYPE	= D.PROD_VERSION_TYPE
									) P 
									LEFT OUTER JOIN SCM_ITEM_M M					--NICK_NAME
											ON P.COMPANY_ID		= M.COMPANY_ID
										   AND P.DIVISION_ID	= M.DIVISION_ID
										   AND P.CMODEL_CODE	= M.[ITEM_ID]
									LEFT OUTER JOIN SCM_ITEM_M MM			--NICK_NAME
											ON P.COMPANY_ID		= MM.COMPANY_ID
										   AND P.DIVISION_ID	= MM.DIVISION_ID
										   AND P.PRODID			= MM.[ITEM_ID]
							) AA
					  GROUP BY COMPANY_ID
							,[FACTORY_ID]
							,[MODEL_CODE]
							,[VERSION]
							,[ITEM_ID]
							,[OPERATION_ID]
							,[ACCT_NAME]
							,[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가

				  ) B
			  ON (
					 A.[COMPANY_ID]			= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]		= B.[FACTORY_ID]
				  AND A.[MODEL_ID]			= B.[MODEL_CODE]
				  AND A.[VERSION]			= B.[VERSION]
				  AND A.[OPERATION]			= B.[OPERATION_ID]
				  AND A.[ITEM_ID]			= B.[ITEM_ID]
				  AND A.[CATEGORY]			= B.[ACCT_NAME]
				  AND A.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[VALUE1] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[VALUE] ELSE B.[VALUE1] END END -- 차수가 다른 경우 값 갱신 
						   ,[MMD_VALUE] = B.[VALUE1]
						   ,[VERSION_TYPE] = B.[VERSION_TYPE]
						   ,[APPLY_DATE]  = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]    = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID]   = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신 
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ]    -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[VALUE1]
					,B.[VALUE1]
					,'N'
					,B.[PROD_VERSION_TYPE]
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;	


		    ------------------------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			-------------------------------------			     NFF Cylindrical											--------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
		
			--믹서 기준 NFF Cylindrical 고형분 생성
			SELECT COMPANY_ID
				   ,DIVISION_ID
				   ,SITE_ID
				   ,PLANT_ID
				   ,CMODEL_CODE
				   ,PROD_VER_CODE
				   ,ATTR_01  --차수
				   ,PRODID
				   ,AREA_ID
				   ,Solids_amount--고형분
			  INTO #MIX_INFO_NFF
			  FROM (
					SELECT COMPANY_ID
						   ,DIVISION_ID
						   ,SITE_ID
						   ,PLANT_ID
						   ,CMODEL_CODE
						   ,PROD_VER_CODE
						   ,ATTR_01 --  차수
						   ,(SELECT TOP 1 PRODID
							   FROM #PLM_ITEM_CONV_CALC R			--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
						      WHERE R.CELLTYPE = 'NFF Cylindrical'  --2022-07-28 leeseongmin NFF Cylindrical 수행
						--		AND R.PROC_FLAG = 'P'				--2019-04-26 PIYONG DEL
							    AND R.CMODEL_CODE = AA.CMODEL_CODE
							    AND R.PROD_VER_CODE =  AA.PROD_VER_CODE
							    AND R.AREA_ID =  AA.AREA_ID
							    AND R.WO_ID = AA.WO_ID
							    AND R.PRODID LIKE AA.PRODID+'%'
							 ) AS PRODID
						   ,AREA_ID
						   ,Solids_amount--고형분
					  FROM (
							SELECT F.COMPANY_ID
									,F.DIVISION_ID
									,F.SITE_ID
									,F.PLANT_ID
									,CMODEL_CODE
									,PROD_VER_CODE
									,ATTR_01  --차수
									,SUBSTRING(PRODID, 1 ,4) AS PRODID
									,AREA_ID
									,WO_ID
									,SUM( /*2021-12-28 E7,EE 로직 막음 CASE WHEN ATTR_10 = 'Y' AND AREA_ID IN ( 'E7', 'EE') AND ATTR_11 = 'B' THEN 0 -- 2021-06-24 C20210626-000019 kimcd 남경 소형 전극 원각이면서 DLD의 경우 B(하면) 제외
										  ELSE */ CONVERT( FLOAT, REPLACE( Solids_amount, ',', '') ) /*END*/ ) AS Solids_amount--고형분 
							  FROM (
									SELECT CMODEL_CODE
											,PROD_VER_CODE
											,ATTR_01  --차수
											,PRODID
											,AREA_ID
											,WO_ID
											,CASE WHEN UNIT = 'KG' AND SPEC_ITEM_ID IN (
																						'I-M001-SPEC-016_1'
																					   ,'I-M002-SPEC-009_1'
																						) THEN VALUE1 END AS Solids_amount--고형분
											,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
																			,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																					WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																					WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																					ELSE '-' END
																			,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
																	ORDER BY PROD_VER_CODE DESC
																			,ISNULL( ATTR_01, '00') DESC
																			,IF_SEQ DESC
																			,WO_ID DESC														 ) NUM
											,ATTR_10 -- 2021-06-24 kimcd DLD 구분자
											,ATTR_11 -- 2021-06-24 kimcd T(상면), B(하면) 구분자
									  FROM #PLM_ITEM_CONV_CALC			--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
									 WHERE CELLTYPE = 'NFF Cylindrical' --2022-07-28 leeseongmin NFF Cylindrical 수행
								 --	   AND PROC_FLAG = 'P'				--2019-04-26 PIYONG DEL
									   AND ATTR_04 IS NULL
									UNION ALL
									SELECT CMODEL_CODE
											,PROD_VER_CODE
											,ATTR_01  --차수
											,PRODID
											,AREA_ID
											,WO_ID
											,CASE WHEN UNIT = 'KG' AND SPEC_ITEM_ID IN (
																						'I-M001-SPEC-016_1'
																					   ,'I-M002-SPEC-009_1'
																						) THEN VALUE1 END AS Solids_amount--고형분
											,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
																			,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																					WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																					WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																					ELSE '-' END
																			,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
																	ORDER BY PROD_VER_CODE DESC
																			,ISNULL( ATTR_01, '00') DESC
																			,IF_SEQ DESC
																			,WO_ID DESC														 ) NUM
											,ATTR_10 -- 2021-06-24 kimcd DLD 구분자
											,ATTR_11 -- 2021-06-24 kimcd T(상면), B(하면) 구분자
									  FROM #PLM_ITEM_CONV_CALC			--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
									 WHERE CELLTYPE = 'NFF Cylindrical' --2022-07-28 leeseongmin NFF Cylindrical 수행
								 --	   AND PROC_FLAG = 'P'				 --2019-04-26 PIYONG DEL
									   AND ATTR_04 IS NOT NULL
									

									) A
							  INNER JOIN SCM_FACTORY_M F
									  ON A.AREA_ID = F.FACTORY_ID
							  WHERE NUM = 1
							--  AND CMODEL_CODE ='MCCE127501B1'
							--  AND AREA_ID = 'E3'
							--  AND PROD_VER_CODE = '006'
							  GROUP BY CMODEL_CODE
									,PROD_VER_CODE
									,ATTR_01  --차수
									,SUBSTRING(PRODID, 1 ,4)
									,AREA_ID
									,WO_ID
									,F.COMPANY_ID
									,F.DIVISION_ID
									,F.SITE_ID
									,F.PLANT_ID
						   ) AA
				   ) AAA
			 WHERE Solids_amount IS NOT  NULL
			   AND AREA_ID NOT IN ( 'EA' )


			 -- NFF Cylindrical Loading 생성
			  SELECT F.COMPANY_ID
					 ,F.DIVISION_ID
					 ,F.SITE_ID
					 ,F.PLANT_ID
					 ,CMODEL_CODE
					 ,PROD_VER_CODE
					 ,ATTR_01  --차수
					 ,VERSION_TYPE
					 ,SSLV.ATTRIBUTE1 AS PROD_VERSION_TYPE
					 ,PRODID
					 ,AREA_ID
					 ,TOP_COATING
					 ,BACK_COATING
					 ,COATED_WIDTH
					 ,TOP_LOAD
					 ,BACK_LOAD
					 ,LOADING
					 ,PATTERN_WIDTH
					 ,TOP_UNCOATED_WIDTH
					 ,[DBO].[FN_SITE_TIME] ( SITE_ID ) AS EFF_END_DATE	-- 2020-02-19 PIYONG ADD
					 ,APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
				INTO #COT_INFO_NFF
				FROM (
					 SELECT CMODEL_CODE
							,PROD_VER_CODE
							,ATTR_01  --차수
							,VERSION_TYPE
							,PLM_FACTORY_CODE
							,PRODID
							,AREA_ID
							,SUM( TOP_COATING ) AS TOP_COATING
							,ISNULL(SUM( BACK_COATING ) , 0) AS BACK_COATING
							,SUM( COATED_WIDTH ) AS COATED_WIDTH
							,ISNULL(SUM( TOP_UNCOATED_WIDTH ) , 0) AS TOP_UNCOATED_WIDTH 
							,SUM( PATTERN_WIDTH )  AS PATTERN_WIDTH   
							,SUM( TOP_LOAD ) AS TOP_LOAD
							,SUM( BACK_LOAD ) AS BACK_LOAD												
							,CASE WHEN AREA_ID = 'E2' THEN													
										    ((( SUM(TOP_COATING) + 10 ) * SUM( TOP_LOAD ) / 25) + 
										    ((SUM(BACK_COATING) + 10 ) * SUM( BACK_LOAD )  / 25)) 
                                            ELSE
											(( SUM( TOP_COATING )  * SUM( TOP_LOAD ) / 25) + 
											( SUM( BACK_COATING ) * SUM( BACK_LOAD )  / 25))
											END AS LOADING
						    --( ( (  패턴[㎜]>Top>코팅부  * 패턴[㎜]>>코팅부폭[㎜] ) * Loading [㎎/25㎠]>>Top / 25  ) +
							--  ( (  패턴[㎜]>Back>코팅부 * 패턴[㎜]>>코팅부폭[㎜] ) * Loading [㎎/25㎠]>>Back/ 25  ) ) / 100								
							-- 2021-06-24 kimcd C20210626-000019 DLD 음극은 TOP LOAD만 적용 시작
							-- /* 2021-12-28 kimcd E7,EE 로직 막음 CASE WHEN AREA_ID IN ( 'E7', 'EE') AND MAX(ATTR_10) = 'Y' AND PRODID LIKE 'APCA%' THEN 2.0 ELSE */ 1.0 /*END*/
							-- 2021-06-24 kimcd DLD 음극은 TOP LOAD만 적용 끝
							-- 2022-08-10 leeseongmin  ((((Total코팅Top[㎜]+10)*Top Loading[㎎/25㎠]/25)+((Total코팅Back[㎜]+10)*Back Loading[㎎/25㎠]/25))  적용

							,MAX(AA.ATTR_05)   AS APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
					  FROM (
							SELECT CMODEL_CODE
									,PROD_VER_CODE
									,ATTR_01  --차수
									,VERSION_TYPE
									,PLM_FACTORY_CODE
									,PRODID
									,AREA_ID
									--	 사용자 입력값 중  / 기준으로 2개를 입력 하는 경우가 있음 두수를 합해야 함  (예-> 790/356  )
									,CASE WHEN CHARINDEX('/',TOP_COATING)  > 0 THEN		-- '/' 가 존재 하는 지 확인
											CONVERT( float,SUBSTRING(TOP_COATING, 0, CHARINDEX('/',TOP_COATING) ) ) +	-- / 앞쪽의 수를 구한다
											CASE WHEN CHARINDEX('/',TOP_COATING, CHARINDEX('/',TOP_COATING)) > 0 THEN	-- / 뒷 쪽의 수가 존재 하는지 확인
													--  첫번째  / 위치 +1 에서  시작해서   문자열 전체 길이에 /의 첫번째 위치 빼  자를 길이를 구한다 ( 예 '790 / 356',  5, 9-5)
													CONVERT ( float, SUBSTRING(TOP_COATING, CHARINDEX('/', TOP_COATING, CHARINDEX('/',TOP_COATING) ) +1, LEN(TOP_COATING) -
																 CHARINDEX('/', TOP_COATING, CHARINDEX('/',TOP_COATING) ) )
															 )
												ELSE
													0
												END
										  ELSE
											TOP_COATING
										  END AS TOP_COATING
									,CASE WHEN CHARINDEX('/',BACK_COATING)  > 0 THEN
											CONVERT( float,SUBSTRING(BACK_COATING, 0, CHARINDEX('/',BACK_COATING) )  )+ 
											CASE WHEN  CHARINDEX('/',BACK_COATING, CHARINDEX('/',BACK_COATING)) > 0 THEN
													CONVERT ( float, SUBSTRING(BACK_COATING, CHARINDEX('/', BACK_COATING, CHARINDEX('/',BACK_COATING) ) +1, LEN(BACK_COATING) -
																 CHARINDEX('/', BACK_COATING, CHARINDEX('/',BACK_COATING) ) )
															 )
												ELSE
													0
												END
										  ELSE
											BACK_COATING
										  END AS BACK_COATING
									,CASE WHEN CHARINDEX('/',COATED_WIDTH)  > 0 THEN
											CONVERT( float,SUBSTRING(COATED_WIDTH, 0, CHARINDEX('/',COATED_WIDTH) ) ) + 
											CASE WHEN  CHARINDEX('/',COATED_WIDTH, CHARINDEX('/',COATED_WIDTH)) > 0 THEN
													CONVERT ( float, SUBSTRING(COATED_WIDTH, CHARINDEX('/', COATED_WIDTH, CHARINDEX('/',COATED_WIDTH) ) +1, LEN(COATED_WIDTH) -
																 CHARINDEX('/', COATED_WIDTH, CHARINDEX('/',COATED_WIDTH) ) )
															 )
												ELSE
													0
												END
										  ELSE
											COATED_WIDTH
										  END AS COATED_WIDTH
									,CASE WHEN CHARINDEX('/',TOP_UNCOATED_WIDTH)  > 0 THEN
											CONVERT( float,SUBSTRING(TOP_UNCOATED_WIDTH, 0, CHARINDEX('/',TOP_UNCOATED_WIDTH) ) ) + 
											CASE WHEN  CHARINDEX('/',TOP_UNCOATED_WIDTH, CHARINDEX('/',TOP_UNCOATED_WIDTH)) > 0 THEN
													CONVERT ( float, SUBSTRING(TOP_UNCOATED_WIDTH, CHARINDEX('/', TOP_UNCOATED_WIDTH, CHARINDEX('/',TOP_UNCOATED_WIDTH) ) +1, LEN(TOP_UNCOATED_WIDTH) -
																 CHARINDEX('/', TOP_UNCOATED_WIDTH, CHARINDEX('/',TOP_UNCOATED_WIDTH) ) )
															 )
												ELSE
													0
												END
										  ELSE
											TOP_UNCOATED_WIDTH
										  END AS TOP_UNCOATED_WIDTH

									,CASE WHEN CHARINDEX('/',PATTERN_WIDTH)  > 0 THEN
											CONVERT( float,SUBSTRING(PATTERN_WIDTH, 0, CHARINDEX('/',PATTERN_WIDTH) )  )+ 
											CASE WHEN  CHARINDEX('/',PATTERN_WIDTH, CHARINDEX('/',PATTERN_WIDTH)) > 0 THEN
													CONVERT ( float, SUBSTRING(PATTERN_WIDTH, CHARINDEX('/', PATTERN_WIDTH, CHARINDEX('/',PATTERN_WIDTH) ) +1, LEN(PATTERN_WIDTH) -
																 CHARINDEX('/', PATTERN_WIDTH, CHARINDEX('/',PATTERN_WIDTH) ) )
															 )
												ELSE
													0
												END
										  ELSE
											PATTERN_WIDTH
										  END AS PATTERN_WIDTH




									,CASE WHEN CHARINDEX('/',TOP_LOAD)  > 0 THEN
											CONVERT( float,SUBSTRING(TOP_LOAD, 0, CHARINDEX('/',TOP_LOAD) )  )+ 
											CASE WHEN  CHARINDEX('/',TOP_LOAD, CHARINDEX('/',TOP_LOAD)) > 0 THEN
													CONVERT ( float, SUBSTRING(TOP_LOAD, CHARINDEX('/', TOP_LOAD, CHARINDEX('/',TOP_LOAD) ) +1, LEN(TOP_LOAD) -
																 CHARINDEX('/', TOP_LOAD, CHARINDEX('/',TOP_LOAD) ) )
															 )
												ELSE
													0
												END
										  ELSE
											TOP_LOAD
										  END AS TOP_LOAD
									,CASE WHEN CHARINDEX('/',BACK_LOAD)  > 0 THEN
											CONVERT( float,SUBSTRING(BACK_LOAD, 0, CHARINDEX('/',BACK_LOAD) ) ) + 
											CASE WHEN  CHARINDEX('/',BACK_LOAD, CHARINDEX('/',BACK_LOAD)) > 0 THEN
													CONVERT ( float, SUBSTRING(BACK_LOAD, CHARINDEX('/', BACK_LOAD, CHARINDEX('/',BACK_LOAD) ) +1, LEN(BACK_LOAD) -
																 CHARINDEX('/', BACK_LOAD, CHARINDEX('/',BACK_LOAD) ) )
															 )
												ELSE
													0
												END
										  ELSE
											BACK_LOAD
										  END AS BACK_LOAD
									,A.ATTR_05 -- 2020-07-10 kimcd ATTR_05 적용일자 추가
									,ATTR_10 -- 2021-06-24 kimcd DLD 구분자
							   FROM (
										SELECT CMODEL_CODE
											   ,PROD_VER_CODE
											   ,ATTR_01													--차수
											   ,CASE  LEFT(PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE
											   ,ATTR_04 AS PLM_FACTORY_CODE
											   ,PRODID
											   ,AREA_ID
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M014-SPECA-019'
																			,'I-M009-SPECE-019'																		
																		  ) THEN VALUE1 END AS TOP_COATING -- TOP 코팅길이
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M014-SPECA-020'
																			,'I-M009-SPECE-020'
																		  ) THEN VALUE1 END AS BACK_COATING -- BACK 코팅길이

											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M014-SPECA-032' --'I-M014-SPECA-010'
																			,'I-M014-SPECA-032' --'I-M014-SPECA-011'
																			,'I-M009-SPECE-022' --'I-M009-SPECE-010'
																			,'I-M009-SPECE-022' --'I-M009-SPECE-011'
																		  ) THEN CASE WHEN CHARINDEX('(',VALUE2)  > 0 THEN 
																							SUBSTRING(VALUE2, 1, CHARINDEX('(', VALUE2, CHARINDEX('(',VALUE2) ) -1 )
																						ELSE
																							VALUE2
																		              END
																				  END AS COATED_WIDTH --TOP 코팅부폭
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M014-SPECA-033' --'I-M014-SPECA-012'																			
																			,'I-M014-SPECA-034' --'I-M014-SPECA-013'																																						
																			,'I-M014-SPECA-032' --'I-M009-SPECE-011'
																			,'I-M009-SPECE-023' --'I-M009-SPECE-012'														
																			,'I-M009-SPECE-022' --'I-M009-SPECE-011'
																			,'I-M009-SPECE-024' --'I-M009-SPECE-013'
																		  ) THEN VALUE2 END AS TOP_UNCOATED_WIDTH -- TOP 미코팅부폭
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M004-SPECA-007' --'I-M014-SPECA-007'
																			,'I-M004-SPEC-006'  --'I-M009-SPECE-007'
																		  ) THEN VALUE2 END AS PATTERN_WIDTH -- TOP 패턴길이

											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M014-SPECA-001' --'I-M014-SPECA-001'
																			,'I-M009-SPECE-001' --'I-M009-SPECE-001'
																		  ) THEN VALUE2 END AS TOP_LOAD -- TOP_Loading
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M014-SPECA-002' --'I-M014-SPECA-002'
																			,'I-M009-SPECE-002' --'I-M009-SPECE-002'
																		  ) THEN VALUE2 END AS BACK_LOAD -- BACK_Loading
											   ,ATTR_05 -- 2020-07-10 kimcd ATTR_05 적용일자 추가
											   ,ATTR_10 -- 2021-06-24 kimcd DLD 구분자
											   ,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID ,SPEC_ITEM_ID
																			 ,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																				   WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																				   WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN 'S'
																				   WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																				   ELSE '-' END
																			 ,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
																	   ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																						 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																					 WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																					 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-11-06 PIYONG ADD P버전
																						 REPLACE( REPLACE( PROD_VER_CODE, 'S', '\'), 'Z', '/') 
																					 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN REPLACE( PROD_VER_CODE, 'S', '\')  -- 2019-11-06 PIYONG ADD P버전
																					 WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/')
																					 ELSE PROD_VER_CODE END DESC
																				 , ISNULL( ATTR_01, '00') DESC
																				 , IF_SEQ DESC						 ) NUM
										  FROM #PLM_ITEM_CONV_CALC			--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
									     WHERE CELLTYPE = 'NFF Cylindrical' --2022-07-28 leeseongmin NFF Cylindrical 수행
										   AND ATTR_04 IS NULL
								   --	   AND PROC_FLAG = 'P'				--2019-04-26 PIYONG DEL
									--	   AND CMODEL_CODE = 'MCR465275A10'
									--	   AND AREA_ID = 'E4'
										UNION ALL
										SELECT CMODEL_CODE
											   ,PROD_VER_CODE
											   ,ATTR_01														--차수
											   ,CASE  LEFT(PROD_VER_CODE, 1) WHEN  'Z' THEN 'TEST' ELSE 'MASS' END AS VERSION_TYPE
											   ,ATTR_04 AS PLM_FACTORY_CODE
											   ,PRODID
											   ,AREA_ID
											   											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M014-SPECA-019'
																			,'I-M009-SPECE-019'																		
																		  ) THEN VALUE1 END AS TOP_COATING -- TOP 코팅길이
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M014-SPECA-020'
																			,'I-M009-SPECE-020'
																		  ) THEN VALUE1 END AS BACK_COATING -- BACK 코팅길이

											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M014-SPECA-032' --'I-M014-SPECA-010'
																			,'I-M014-SPECA-032' --'I-M014-SPECA-011'
																			,'I-M009-SPECE-022' --'I-M009-SPECE-010'
																			,'I-M009-SPECE-022' --'I-M009-SPECE-011'
																		  ) THEN CASE WHEN CHARINDEX('(',VALUE2)  > 0 THEN 
																							SUBSTRING(VALUE2, 1, CHARINDEX('(', VALUE2, CHARINDEX('(',VALUE2) ) -1 )
																						ELSE
																							VALUE2
																		              END
																				  END AS COATED_WIDTH --TOP 코팅부폭
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M014-SPECA-033' --'I-M014-SPECA-012'
																			,'I-M014-SPECA-034' --'I-M014-SPECA-013'
																			,'I-M014-SPECA-032' --'I-M009-SPECE-011'
																			,'I-M009-SPECE-023' --'I-M009-SPECE-012'
																			,'I-M009-SPECE-022' --'I-M009-SPECE-011'
																			,'I-M009-SPECE-024' --'I-M009-SPECE-013'
																		  ) THEN VALUE2 END AS TOP_UNCOATED_WIDTH -- TOP 미코팅부폭
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M004-SPECA-007' --'I-M014-SPECA-007'
																			,'I-M004-SPEC-006'  --'I-M009-SPECE-007'
																		  ) THEN VALUE2 END AS PATTERN_WIDTH -- TOP 패턴길이

											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M014-SPECA-001' --'I-M014-SPECA-001'
																			,'I-M009-SPECE-001' --'I-M009-SPECE-001'
																		  ) THEN VALUE2 END AS TOP_LOAD -- TOP_Loading
											   ,CASE WHEN SPEC_ITEM_ID IN (
																			 'I-M014-SPECA-002' --'I-M014-SPECA-002'
																			,'I-M009-SPECE-002' --'I-M009-SPECE-002'
																		  ) THEN VALUE2 END AS BACK_LOAD -- BACK_Loading
											   ,ATTR_05 -- 2020-07-10 kimcd ATTR_05 적용일자 추가
											   ,ATTR_10 -- 2021-06-24 kimcd DLD 구분자
											   ,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID ,SPEC_ITEM_ID
																				,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
																					  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
																					  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN 'S'
																					  WHEN RIGHT(PROD_VER_CODE, 1) = 'A' THEN 'A' -- 2020-08-20 kimcd 임시 추가 A
																					  ELSE '-' END
																				,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
																	   ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																						 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																					 WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																					 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-11-06 PIYONG ADD P버전
																						 REPLACE( REPLACE( PROD_VER_CODE, 'S', '\'), 'Z', '/') 
																					 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN REPLACE( PROD_VER_CODE, 'S', '\')  -- 2019-11-06 PIYONG ADD P버전
																					 WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
																					 ELSE PROD_VER_CODE END DESC
																				 , ISNULL( ATTR_01, '00') DESC
																				 , IF_SEQ DESC						 ) NUM
										  FROM #PLM_ITEM_CONV_CALC	--2019-04-26 PIYONG CHANGE SY_XIF_PLM_WO_INSP_SPEC_R -> #PLM_ITEM_CONV_CALC
										 WHERE CELLTYPE = 'NFF Cylindrical' --2022-07-28 leeseongmin NFF Cylindrical 수행
										   AND ATTR_04 IS NOT NULL
									--	   AND PROC_FLAG = 'P'	--2019-04-26 PIYONG DEL
									--	   AND AREA_ID = 'E4'

									) A
							  WHERE NUM = 1
							--	AND CMODEL_CODE = 'MCR465275A10'
							--	AND AREA_ID = 'E4'
						   ) AA
					 GROUP BY CMODEL_CODE
							,PROD_VER_CODE
							,ATTR_01  --차수
							,VERSION_TYPE
							,PLM_FACTORY_CODE
							,PRODID
							,AREA_ID
					 ) AAA
				     INNER JOIN SCM_FACTORY_M F
						     ON AAA.AREA_ID = F.FACTORY_ID
				     INNER JOIN SCM_SYS_LOOKUP_VALUE SSLV
						     ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
						    AND SEGMENT4 = AAA.AREA_ID
						    AND SEGMENT5 = ISNULL(AAA.PLM_FACTORY_CODE, '-')
			   WHERE LOADING IS NOT NULL
				 AND AREA_ID NOT IN ( 'EA' )
		

			--Cell/batch
			SELECT MAX(COMPANY_ID) AS COMPANY_ID
					,MAX(DIVISION_ID) AS DIVISION_ID
					,MAX(SITE_ID) AS SITE_ID
					,MAX(PLANT_ID) AS PLANT_ID
					,[MODEL_CODE]
					,MAX([PROJECT_NAME]) AS [PROJECT_NAME]
					,[ITEM_ID]
					,[VERSION]
					,ATTR_01  --차수
					,[FACTORY_ID]
					,[OPERATION_ID]
					,SUM(CELL_BATCH) AS CELL_BATCH
					,MAX(VERSION_TYPE) AS VERSION_TYPE
					,MAX(PROD_VERSION_TYPE) AS PROD_VERSION_TYPE
					,MAX(APPLY_DATE)   AS APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
			  INTO #CELL_BATCH_NFF
			  FROM (
					SELECT P.COMPANY_ID
							,P.DIVISION_ID
							,P.SITE_ID
							,P.PLANT_ID
							,C.CMODEL_CODE AS [MODEL_CODE]
							,ISNULL(M.NICK_NAME, MM.NICK_NAME) AS [PROJECT_NAME]
							,P.PRODID AS [ITEM_ID]
							,C.PROD_VER_CODE AS [VERSION]
							,C.ATTR_01  --차수
							,C.AREA_ID AS [FACTORY_ID]
							,'E2000' AS OPERATION_ID
							,C.PRODID AS MIX_PRODID
							,C.Solids_amount
							,TOP_COATING
							,BACK_COATING
							,COATED_WIDTH
							,TOP_LOAD
							,BACK_LOAD
							,TOP_UNCOATED_WIDTH
							,PATTERN_WIDTH
							,LOADING
							,LANE_CNT
							,CASE WHEN C.AREA_ID = 'E2' THEN													
										(C.Solids_amount * 100000) / LOADING / 2 * ( 1 / (PATTERN_WIDTH * 0.001)  * LANE_CNT )
                                        ELSE
										(C.Solids_amount * 100000) / LOADING  * ( 1 / (PATTERN_WIDTH * 0.001)  * LANE_CNT )
										END AS  CELL_BATCH	
							-- 고형분/로딩량*레인수*10^6 에서 변동 2022-08-10 leeseongmin
							-- (BottomSlurry-고형분[㎏/batch]+TopSlurry-고형분[㎏/batch])*10^5	/	-- 고형분은 기존과 동일
							-- ((((Total코팅Top[㎜]+10)*Top Loading[㎎/25㎠]/25)+((Total코팅Back[㎜]+10)*Back Loading[㎎/25㎠]/25)) / 2 )  *  (1/(패턴길이(mm)/1000)*슬리팅Lane수)
							,P.VERSION_TYPE
							,P.PROD_VERSION_TYPE
							,P.APPLY_DATE   AS APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
					  FROM (
							SELECT DISTINCT M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.AREA_ID, M.CMODEL_CODE, M.PRODID, I.CHILD_ITEM_ID
									,PROD_VER_CODE
									,ATTR_01  --차수
									,TOP_COATING
									,BACK_COATING
									,COATED_WIDTH
									,TOP_LOAD
									,BACK_LOAD
									,LOADING
									,PATTERN_WIDTH
									,TOP_UNCOATED_WIDTH
									,VERSION_TYPE
									,PROD_VERSION_TYPE
									,M.APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
							  FROM #COT_INFO_NFF M
								   INNER JOIN [SCM_MODEL_COMP_EFFECTIVE_DATE] I			-- 2020-02-19 PIYONG CHANGE [SCM_MODEL_COMP_TEMP] -> [SCM_MODEL_COMP_EFFECTIVE_DATE]
										   ON 1=1
									--	  AND M.COMPANY_ID	= I.CHILD_COMPANY_ID
									--	  AND M.DIVISION_ID	= I.CHILD_DIVISION_ID
									--	  AND M.SITE_ID		= I.CHILD_SITE_ID
									--	  AND M.PLANT_ID	= I.CHILD_PLANT_ID
										  AND M.PRODID		= I.PARENT_ITEM_ID
										  AND M.CMODEL_CODE = I.MODEL_ID
							 WHERE I.CHILD_ITEM_ID LIKE 'ASL%'
							   AND I.EFF_END_DATE > M.EFF_END_DATE						-- 2020-02-19 PIYONG ADD
						   ) P 
					 INNER JOIN #MIX_INFO_NFF C
							 ON P.COMPANY_ID	= C.COMPANY_ID
							AND P.DIVISION_ID	= C.DIVISION_ID
							AND P.SITE_ID		= C.SITE_ID
							AND P.PLANT_ID		= C.PLANT_ID
							AND P.AREA_ID		= C.AREA_ID
							AND P.CMODEL_CODE	= C.CMODEL_CODE
							AND P.CHILD_ITEM_ID	= C.PRODID
							AND P.PROD_VER_CODE	= C.PROD_VER_CODE
							AND ISNULL(P.ATTR_01, '00')		= ISNULL(C.ATTR_01, '00')  --차수
					 INNER JOIN #LANE_INFO D
							 ON P.COMPANY_ID	= D.COMPANY_ID
							AND P.DIVISION_ID	= D.DIVISION_ID
							AND P.SITE_ID		= D.SITE_ID
							AND P.PLANT_ID		= D.PLANT_ID
							AND P.AREA_ID		= D.AREA_ID
							AND P.PRODID		= D.PRODID
							AND P.PROD_VERSION_TYPE	= D.PROD_VERSION_TYPE
					 LEFT OUTER JOIN SCM_ITEM_M M					--NICK_NAME
								  ON P.COMPANY_ID	= M.COMPANY_ID
								 AND P.DIVISION_ID	= M.DIVISION_ID
								 AND P.CMODEL_CODE	= M.[ITEM_ID]
					 LEFT OUTER JOIN SCM_ITEM_M MM					--NICK_NAME
								  ON P.COMPANY_ID	= MM.COMPANY_ID
								 AND P.DIVISION_ID	= MM.DIVISION_ID
								 AND P.PRODID		= MM.[ITEM_ID]
					) AA
			  GROUP BY COMPANY_ID
					,[FACTORY_ID]
					,[MODEL_CODE]
					,[VERSION]
					,ATTR_01  --차수
					,[ITEM_ID]
					,[OPERATION_ID]




			--JUMBO ROLL (M/BATCH)
			SELECT MAX(COMPANY_ID) AS COMPANY_ID
					,MAX(DIVISION_ID) AS DIVISION_ID
					,MAX(SITE_ID) AS SITE_ID
					,MAX(PLANT_ID) AS PLANT_ID
					,[MODEL_CODE]
					,MAX([PROJECT_NAME]) AS [PROJECT_NAME]
					,[ITEM_ID]
					,[VERSION]
					,ATTR_01  --차수
					,[FACTORY_ID]
					,[OPERATION_ID]
					,SUM(M_BATCH) AS M_BATCH
					,MAX([ACCT_NAME]) AS [ACCT_NAME]
					,MAX(PROD_VERSION_TYPE) AS PROD_VERSION_TYPE
					,MAX(VERSION_TYPE) AS VERSION_TYPE
					,MAX(APPLY_DATE)   AS APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
			  INTO #M_BATCH_NFF
			  FROM (
						SELECT P.COMPANY_ID
								,P.DIVISION_ID
								,P.SITE_ID
								,P.PLANT_ID
								,C.CMODEL_CODE AS [MODEL_CODE]
								,ISNULL(M.NICK_NAME, MM.NICK_NAME) AS [PROJECT_NAME]
								,P.PRODID AS [ITEM_ID]
								,C.PROD_VER_CODE AS [VERSION]
								,C.ATTR_01						  --차수
								,P.PROD_VERSION_TYPE
								,B.VERSION_TYPE
								,C.AREA_ID AS [FACTORY_ID]
								,'E2000' AS OPERATION_ID
								,C.PRODID AS MIX_PRODID
								,C.Solids_amount
								,TOP_COATING
								,BACK_COATING
								,COATED_WIDTH
								,TOP_LOAD
								,BACK_LOAD
								,P.LOADING
								,D.LANE_CNT
								,B.CELL_BATCH
								,TOP_UNCOATED_WIDTH
								,PATTERN_WIDTH
								,B.CELL_BATCH / D.LANE_CNT * PATTERN_WIDTH * 0.001 AS M_BATCH		-- 배치당cell수/레인수*패턴길이*10^-3 
								,P.APPLY_DATE  -- 2020-07-10 kimcd ATTR_05 적용일자 추가
								,(SELECT ATTRIBUTE1
									FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
									AND SEGMENT1 = 'm/batch'
									AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
						  FROM (
								SELECT DISTINCT M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.AREA_ID, M.CMODEL_CODE, M.PRODID, I.CHILD_ITEM_ID
										,PROD_VER_CODE
										,M.ATTR_01  --차수
										,TOP_COATING
										,BACK_COATING
										,COATED_WIDTH
										,TOP_LOAD
										,BACK_LOAD
										,LOADING
										,PATTERN_WIDTH
										,TOP_UNCOATED_WIDTH
										,PROD_VERSION_TYPE
										,M.APPLY_DATE -- 2020-07-10 kimcd ATTR_05 적용일자 추가
									FROM #COT_INFO_NFF M
										INNER JOIN [SCM_MODEL_COMP_EFFECTIVE_DATE] I		-- 2020-02-19 PIYONG CHANGE [SCM_MODEL_COMP_TEMP] -> [SCM_MODEL_COMP_EFFECTIVE_DATE]
												ON 1=1
										--		AND M.COMPANY_ID	= I.CHILD_COMPANY_ID
										--		AND M.DIVISION_ID	= I.CHILD_DIVISION_ID
										--		AND M.SITE_ID		= I.CHILD_SITE_ID
										--		AND M.PLANT_ID		= I.CHILD_PLANT_ID
												AND M.PRODID		= I.PARENT_ITEM_ID
												AND M.CMODEL_CODE	= I.MODEL_ID
									WHERE I.CHILD_ITEM_ID LIKE 'ASL%'
									  AND I.EFF_END_DATE > M.EFF_END_DATE					-- 2020-02-19 PIYONG ADD
							   ) P
							   INNER JOIN #CELL_BATCH_NFF B
									   ON P.COMPANY_ID	= B.COMPANY_ID
									  AND P.DIVISION_ID	= B.DIVISION_ID
									  AND P.SITE_ID		= B.SITE_ID
									  AND P.PLANT_ID	= B.PLANT_ID
									  AND P.AREA_ID		= B.FACTORY_ID
									  AND P.CMODEL_CODE	= B.MODEL_CODE
									  AND P.PRODID		= B.ITEM_ID
									  AND P.PROD_VER_CODE	= B.VERSION
									  AND ISNULL(P.ATTR_01, '00')	= ISNULL(B.ATTR_01, '00')  --차수
							   INNER JOIN #MIX_INFO_NFF C
									   ON P.COMPANY_ID		= C.COMPANY_ID
									  AND P.DIVISION_ID		= C.DIVISION_ID
									  AND P.SITE_ID			= C.SITE_ID
									  AND P.PLANT_ID		= C.PLANT_ID
									  AND P.AREA_ID			= C.AREA_ID
									  AND P.CMODEL_CODE		= C.CMODEL_CODE
									  AND P.CHILD_ITEM_ID	= C.PRODID
									  AND P.PROD_VER_CODE	= C.PROD_VER_CODE
									  AND ISNULL(P.ATTR_01, '00')	= ISNULL(C.ATTR_01, '00')  --차수
							   INNER JOIN #LANE_INFO D
										ON P.COMPANY_ID		= D.COMPANY_ID
									   AND P.DIVISION_ID	= D.DIVISION_ID
									   AND P.SITE_ID		= D.SITE_ID
									   AND P.PLANT_ID		= D.PLANT_ID
									   AND P.AREA_ID		= D.AREA_ID
									   AND P.PRODID			= D.PRODID
									   AND P.PROD_VERSION_TYPE	= D.PROD_VERSION_TYPE
								LEFT OUTER JOIN SCM_ITEM_M M					--NICK_NAME
										ON P.COMPANY_ID		= M.COMPANY_ID
									   AND P.DIVISION_ID	= M.DIVISION_ID
									   AND P.CMODEL_CODE	= M.[ITEM_ID]
								LEFT OUTER JOIN SCM_ITEM_M MM					--NICK_NAME
										ON P.COMPANY_ID		= MM.COMPANY_ID
									   AND P.DIVISION_ID	= MM.DIVISION_ID
									   AND P.PRODID			= MM.[ITEM_ID]
				   ) AA
			 GROUP BY [MODEL_CODE]
					,[ITEM_ID]
					,[VERSION]
					,ATTR_01  --차수
					,[FACTORY_ID]
					,[OPERATION_ID]



			SET @v_err_check = '9. SCM_ITEM_CONV_CALC_M from #CELL_BATCH_NFF'
			--  Cell/batch		
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT COMPANY_ID
						   ,DIVISION_ID
						   ,SITE_ID
						   ,D.PLANT_ID
						   ,MODEL_CODE
						   ,PROJECT_NAME
						   ,NULL AS CA_FLAG
						   ,ITEM_ID
						   ,VERSION
						   ,FACTORY_ID
						   ,OPERATION_ID
						   ,CELL_BATCH
						   ,(SELECT ATTRIBUTE1
									FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
									AND SEGMENT1 = N'cell/batch'
									AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
						   ,PROD_VERSION_TYPE
						   ,VERSION_TYPE
						   ,ATTR_01    AS PROD_SEQ  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
				      FROM #CELL_BATCH_NFF D
				  ) B
			  ON (
					A.[COMPANY_ID]			= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]		= B.[FACTORY_ID]
				  AND A.[MODEL_ID]			= B.[MODEL_CODE]
				  AND A.[VERSION]			= B.[VERSION]
				  AND A.[OPERATION]			= B.[OPERATION_ID]
				  AND A.[ITEM_ID]			= B.[ITEM_ID]
				  AND A.[CATEGORY]			= B.[ACCT_NAME]
				  AND A.[PROD_VERSION_TYPE]	= B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[CELL_BATCH] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[VALUE] ELSE B.[CELL_BATCH] END END -- 차수가 다른 경우 값 갱신 
						   ,[MMD_VALUE] = B.[CELL_BATCH]
						   ,[VERSION_TYPE]		= B.[VERSION_TYPE] 
						   ,[APPLY_DATE]  = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]    = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID]   = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신 
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ]    -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[CELL_BATCH]
					,B.[CELL_BATCH]
					,'N'
					,B.[PROD_VERSION_TYPE]
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;


			SET @v_err_check = '10. SCM_ITEM_CONV_CALC_M from #M_BATCH_NFF'
			--  Jumbo Roll (m/batch)
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT COMPANY_ID
						   ,DIVISION_ID
						   ,SITE_ID
						   ,PLANT_ID
						   ,MODEL_CODE
						   ,PROJECT_NAME
						   ,NULL AS CA_FLAG
						   ,ITEM_ID
						   ,VERSION
						   ,FACTORY_ID
						   ,OPERATION_ID
						   ,M_BATCH
						   ,ACCT_NAME
						   ,PROD_VERSION_TYPE
						   ,VERSION_TYPE
						   ,ATTR_01    AS PROD_SEQ  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
				      FROM #M_BATCH_NFF

				  ) B
			  ON (
					A.[COMPANY_ID]			= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]		= B.[FACTORY_ID]
				  AND A.[MODEL_ID]			= B.[MODEL_CODE]
				  AND A.[VERSION]			= B.[VERSION]
				  AND A.[OPERATION]			= B.[OPERATION_ID]
				  AND A.[ITEM_ID]			= B.[ITEM_ID]
				  AND A.[CATEGORY]			= B.[ACCT_NAME]
				  AND A.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
   						   ,[VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[M_BATCH] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[VALUE] ELSE B.[M_BATCH] END END -- 차수가 다른 경우 값 갱신 
						   ,[MMD_VALUE] = B.[M_BATCH]
						   ,[VERSION_TYPE] = B.[VERSION_TYPE]
						   ,[APPLY_DATE]  = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]    = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID]   = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신 
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[M_BATCH]
					,B.[M_BATCH]
					,'N'
					,B.[PROD_VERSION_TYPE]
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;




			SET @v_err_check = '11. SCM_ITEM_CONV_CALC_M from #M_BATCH_NFF 2'
			--  Jumbo Roll (cell/m)
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					 SELECT M.COMPANY_ID
						   ,M.DIVISION_ID
						   ,M.SITE_ID
						   ,M.PLANT_ID
						   ,M.MODEL_CODE
						   ,M.PROJECT_NAME
						   ,NULL AS CA_FLAG
						   ,M.ITEM_ID
						   ,M.VERSION
						   ,M.FACTORY_ID
						   ,M.OPERATION_ID
						   ,C.CELL_BATCH / M_BATCH AS CELL_M  -- Jumbo Roll (cell/m)
						   ,(SELECT ATTRIBUTE1
							   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
							  WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
								AND SEGMENT1 = N'점보롤 cell/m'
								AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
						   ,M.PROD_VERSION_TYPE
						   ,M.VERSION_TYPE
						   ,M.ATTR_01    AS PROD_SEQ  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,M.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
				      FROM #M_BATCH_NFF M
						   INNER JOIN #CELL_BATCH_NFF C
								   ON M.COMPANY_ID	= C.COMPANY_ID
								  AND M.DIVISION_ID = C.DIVISION_ID
								  AND M.SITE_ID		= C.SITE_ID
								  AND M.PLANT_ID	= C.PLANT_ID
								  AND M.FACTORY_ID	= C.FACTORY_ID
								  AND M.MODEL_CODE	= C.MODEL_CODE
								  AND M.ITEM_ID		= C.ITEM_ID
								  AND M.VERSION		= C.VERSION
								  AND ISNULL(M.ATTR_01, '00')	= ISNULL(C.ATTR_01, '00')

				  ) B
			  ON (
					A.[COMPANY_ID]			= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]		= B.[FACTORY_ID]
				  AND A.[MODEL_ID]			= B.[MODEL_CODE]
				  AND A.[VERSION]			= B.[VERSION]
				  AND A.[OPERATION]			= B.[OPERATION_ID]
				  AND A.[ITEM_ID]			= B.[ITEM_ID]
				  AND A.[CATEGORY]			= B.[ACCT_NAME]
				  AND A.[PROD_VERSION_TYPE]	= B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[CELL_M] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[VALUE] ELSE B.[CELL_M] END END -- 차수가 다른 경우 값 갱신 
						   ,[MMD_VALUE] = B.[CELL_M]
						   ,[VERSION_TYPE] = B.[VERSION_TYPE]
						   ,[APPLY_DATE]  = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]    = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID]   = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신 
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[CELL_M]
					,B.[CELL_M]
					,'N'
					,B.[PROD_VERSION_TYPE]
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;

		
			SET @v_err_check = '12. SCM_ITEM_CONV_CALC_M from #COT_INFO_NFF'
			--Lane수
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					 SELECT COMPANY_ID
							,MAX(DIVISION_ID) AS DIVISION_ID
							,MAX(SITE_ID) AS SITE_ID
							,MAX(PLANT_ID) AS PLANT_ID
							,[MODEL_CODE]
							,MAX([PROJECT_NAME]) AS [PROJECT_NAME]
							,NULL AS CA_FLAG
							,[ITEM_ID]
							,[VERSION]
							,[FACTORY_ID]
							,[OPERATION_ID]
							,SUM([VALUE1]) AS [VALUE1]
							,MAX([ACCT_NAME]) AS [ACCT_NAME]
							,MAX(PROD_VERSION_TYPE) AS PROD_VERSION_TYPE
							,MAX(VERSION_TYPE) AS VERSION_TYPE
							,PROD_SEQ   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
							,MAX(APPLY_DATE) AS APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					  FROM (
							SELECT P.COMPANY_ID
									,P.DIVISION_ID
									,P.SITE_ID
									,P.PLANT_ID
									,P.CMODEL_CODE AS [MODEL_CODE]
									,ISNULL(M.NICK_NAME, MM.NICK_NAME) AS [PROJECT_NAME]
									,P.PRODID AS [ITEM_ID]
									,P.PROD_VER_CODE AS [VERSION]
									,P.AREA_ID AS [FACTORY_ID]
									,'E2000' AS OPERATION_ID
									,LANE_CNT AS [VALUE1]
									,(SELECT ATTRIBUTE1
										FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
										WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
										AND SEGMENT1 = N'Lane수'
										AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
									,PROD_VERSION_TYPE
									,VERSION_TYPE
									,P.PROD_SEQ   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
									,P.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
							  FROM (
										SELECT P.COMPANY_ID
												,P.DIVISION_ID
												,P.SITE_ID
												,P.PLANT_ID
												,P.AREA_ID
												,P.CMODEL_CODE
												,P.PRODID
												,P.PROD_VER_CODE
												,P.VERSION_TYPE
												,P.PROD_VERSION_TYPE
												,D.LANE_CNT
												,P.PROD_SEQ   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
												,P.APPLY_DATE -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
										  FROM (
												SELECT DISTINCT M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.AREA_ID, M.CMODEL_CODE, M.PRODID
														,M.PROD_VER_CODE
														,M.PROD_VERSION_TYPE
														,M.VERSION_TYPE
														,M.ATTR_01   AS PROD_SEQ -- 2020-07-10 kimcd PROD_SEQ 차수 추가
														,M.APPLY_DATE  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
												  FROM #COT_INFO_NFF M
													   INNER JOIN #M_BATCH_NFF B		--2019-03-29 PIYONG JOIN ADD
														  ON M.AREA_ID = B.[FACTORY_ID]
														 AND M.CMODEL_CODE = B.[MODEL_CODE]
														 AND M.PRODID = B.[ITEM_ID]
														 AND M.PROD_VER_CODE = B.[VERSION]
														 AND ISNULL(M.ATTR_01, '00')	= ISNULL(B.ATTR_01, '00')  --차수
														 AND M.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE
											   ) P
											   INNER JOIN #LANE_INFO D
													   ON P.COMPANY_ID	= D.COMPANY_ID
													  AND P.DIVISION_ID	= D.DIVISION_ID
													  AND P.SITE_ID		= D.SITE_ID
													  AND P.PLANT_ID	= D.PLANT_ID
													  AND P.AREA_ID		= D.AREA_ID
													  AND P.PRODID		= D.PRODID
													  AND P.PROD_VERSION_TYPE	= D.PROD_VERSION_TYPE
									) P 
									LEFT OUTER JOIN SCM_ITEM_M M					--NICK_NAME
											ON P.COMPANY_ID		= M.COMPANY_ID
										   AND P.DIVISION_ID	= M.DIVISION_ID
										   AND P.CMODEL_CODE	= M.[ITEM_ID]
									LEFT OUTER JOIN SCM_ITEM_M MM			--NICK_NAME
											ON P.COMPANY_ID		= MM.COMPANY_ID
										   AND P.DIVISION_ID	= MM.DIVISION_ID
										   AND P.PRODID			= MM.[ITEM_ID]
							) AA
					  GROUP BY COMPANY_ID
							,[FACTORY_ID]
							,[MODEL_CODE]
							,[VERSION]
							,[ITEM_ID]
							,[OPERATION_ID]
							,[ACCT_NAME]
							,[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가

				  ) B
			  ON (
					 A.[COMPANY_ID]			= B.[COMPANY_ID]
				  AND A.[FACTORY_ID]		= B.[FACTORY_ID]
				  AND A.[MODEL_ID]			= B.[MODEL_CODE]
				  AND A.[VERSION]			= B.[VERSION]
				  AND A.[OPERATION]			= B.[OPERATION_ID]
				  AND A.[ITEM_ID]			= B.[ITEM_ID]
				  AND A.[CATEGORY]			= B.[ACCT_NAME]
				  AND A.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN B.[VALUE1] ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[VALUE] ELSE B.[VALUE1] END END -- 차수가 다른 경우 값 갱신 
						   ,[MMD_VALUE] = B.[VALUE1]
						   ,[VERSION_TYPE] = B.[VERSION_TYPE]
						   ,[APPLY_DATE]  = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]    = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID]   = CASE WHEN B.[PROD_SEQ] > A.[PROD_SEQ] THEN 'PR_XIF_PLM_ITEM_CONV_CALC_R' ELSE CASE WHEN A.[UPDATE_ID] != 'PR_XIF_PLM_ITEM_CONV_CALC_R'THEN A.[UPDATE_ID] ELSE 'PR_XIF_PLM_ITEM_CONV_CALC_R' END END -- 차수가 다른 경우 값 갱신 
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ]    -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[VALUE1]
					,B.[VALUE1]
					,'N'
					,B.[PROD_VERSION_TYPE]
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;	
			-------------------------------------			     NFF Cylindrical 추가END 이후 공통사항			--------------------------------------------
			
			/*	--2019-04-26 PIYONG DEL
			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'Y'
			 WHERE PROC_FLAG = 'P'
			*/

			SET @v_err_check = '13. SCM_ITEM_CONV_CALC_M from #PLM_ITEM_CONV_CALC : 2'
			-- lane 기준으로 곱하는 경우 추가
			-- Jumbo Roll m/batch을	(Pancake) m/batch 로 전환
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT B.COMPANY_ID
						  ,B.DIVISION_ID
						  ,B.SITE_ID
						  ,B.PLANT_ID
						  ,B.FACTORY_ID
						  ,B.OPERATION
						  ,B.PJT_CODE
						  ,B.VERSION
						  ,B.MODEL_ID
						  ,B.ELECTRODE_TYPE
						  ,B.ITEM_ID
						  ,SLV.ATTRIBUTE1  AS CATEGORY
						  ,B.VALUE * C.VALUE AS VALUE
						  ,B.MMD_VALUE * C.MMD_VALUE AS MMD_VALUE
						  ,B.MAX_VER_FLAG
						  ,B.PROD_VERSION_TYPE
						  ,B.VERSION_TYPE
						  ,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						  ,B.[PROD_SEQ]    -- 2020-07-10 kimcd PROD_SEQ 차수 추가
					  FROM DBO.SCM_ITEM_CONV_CALC_M  B
						  ,DBO.SCM_ITEM_CONV_CALC_M  C
						  ,DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
						  ,(SELECT [CMODEL_CODE]
								  ,CASE WHEN [AREA_ID] = 'EA' THEN
										CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
											CONCAT([PROD_VER_CODE],'2')
										ELSE
											CONCAT([PROD_VER_CODE],'3')
										END
									ELSE
										[PROD_VER_CODE]
									END AS [PROD_VER_CODE]
								  ,[AREA_ID]
		  						  ,[PRODID]
								  ,[PROC_ID]
						    FROM   #PLM_ITEM_CONV_CALC  ICC 
							GROUP  BY  [CMODEL_CODE]
									  ,CASE WHEN [AREA_ID] = 'EA' THEN
											CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
												CONCAT([PROD_VER_CODE],'2')
											ELSE
												CONCAT([PROD_VER_CODE],'3')
											END
										ELSE
											[PROD_VER_CODE]
										END
									  ,[AREA_ID]
		  							  ,[PRODID]
									  ,[PROC_ID]
							UNION -- 2022-04-14 김현 [C20220328-000596] 단면 미형성 오류 보완
							SELECT [CMODEL_CODE]
								  ,CASE WHEN [AREA_ID] = 'EA' THEN
										CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
											CONCAT([PROD_VER_CODE],'2')
										ELSE
											CONCAT([PROD_VER_CODE],'3')
										END
									ELSE
										[PROD_VER_CODE]
									END AS [PROD_VER_CODE]
								  ,[AREA_ID]
		  						  ,[ATTR_07]
								  ,[PROC_ID]
						    FROM   #PLM_ITEM_CONV_CALC  ICC 
							WHERE   [ATTR_07] IS NOT NULL
							GROUP  BY  [CMODEL_CODE]
									  ,CASE WHEN [AREA_ID] = 'EA' THEN
											CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
												CONCAT([PROD_VER_CODE],'2')
											ELSE
												CONCAT([PROD_VER_CODE],'3')
											END
										ELSE
											[PROD_VER_CODE]
										END
									  ,[AREA_ID]
		  							  ,[ATTR_07]
									  ,[PROC_ID]
							) ICC -- 2020-11-09 kimcd 일괄 변경 대상 범위 제한
					 WHERE SLV.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
					 AND   SLV.SEGMENT1    = B.CATEGORY
					 AND   SLV.ACTIVE_FLAG = 'Y'
					 AND   SLV.ATTRIBUTE3  = 'MULTIPLY'
					 AND   C.COMPANY_ID    = B.COMPANY_ID
					 AND   C.FACTORY_ID    = B.FACTORY_ID
					 AND   C.MODEL_ID      = B.MODEL_ID
					 AND   C.VERSION       = B.VERSION
					 AND   C.OPERATION     = B.OPERATION
					 AND   C.ITEM_ID       = B.ITEM_ID
					 AND   C.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
					 AND   C.CATEGORY      = 'Lane Number'
					 AND   B.OPERATION     = 'E2000'
					 AND   B.UPDATE_TIME  >= CONVERT( DATE, GETDATE())
 					 AND   B.[FACTORY_ID] NOT IN ( 'EA' )
					 AND   ICC.[AREA_ID]       = B.FACTORY_ID
					 AND   ICC.[CMODEL_CODE]   = B.MODEL_ID
					 AND   ICC.[PROD_VER_CODE] = B.VERSION
					 AND   ICC.[PROC_ID]       = B.OPERATION
					 AND   ICC.[PRODID]        = B.ITEM_ID  -- 2020-11-09 kimcd 일괄 변경 대상 범위 제한


					) B
			  ON (A.[COMPANY_ID]     = B.[COMPANY_ID]
				  AND A.[FACTORY_ID] = B.[FACTORY_ID]
				  AND A.[MODEL_ID]   = B.[MODEL_ID]
				  AND A.[VERSION]    = B.[VERSION]
				  AND A.[OPERATION]  = B.[OPERATION]
				  AND A.[ITEM_ID]    = B.[ITEM_ID]
				  AND A.[CATEGORY]   = B.[CATEGORY]
				  AND A.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE]        = B.[PJT_CODE]
				           ,[ELECTRODE_TYPE] = B.[ELECTRODE_TYPE]
						   ,[VALUE]          = B.[VALUE]
						   ,[MMD_VALUE]		 = B.[MMD_VALUE]
						   ,[MAX_VER_FLAG]   = B.[MAX_VER_FLAG]
						   ,[VERSION_TYPE]   = B.[VERSION_TYPE]
						   ,[APPLY_DATE]	 = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]       = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID]      = 'PR_XIF_PLM_ITEM_CONV_CALC_R'
						   ,[UPDATE_TIME]    = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_ID]
					,B.[PJT_CODE]
					,B.[VERSION]
					,B.[OPERATION]
					,B.[ITEM_ID]
					,B.[ELECTRODE_TYPE]
					,B.[CATEGORY]
					,B.[VALUE]
					,B.[MMD_VALUE]
					,B.[MAX_VER_FLAG]
				    ,B.PROD_VERSION_TYPE
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;

			SET @v_err_check = '14. SCM_ITEM_CONV_CALC_M from #PLM_ITEM_CONV_CALC : 3'
			-- lane 기준으로 나누는 경우 추가
			-- Jumbo Roll (cell/m)를 Pancake (cell/m) 로 전환
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT B.COMPANY_ID
						  ,B.DIVISION_ID
						  ,B.SITE_ID
						  ,B.PLANT_ID
						  ,B.FACTORY_ID
						  ,B.OPERATION
						  ,B.PJT_CODE
						  ,B.VERSION
						  ,B.MODEL_ID
						  ,B.ELECTRODE_TYPE
						  ,B.ITEM_ID
						  ,SLV.ATTRIBUTE1  AS CATEGORY
					      ,B.VALUE / CASE WHEN C.VALUE = 0 THEN 1 ELSE C.VALUE END AS VALUE
						  ,B.MMD_VALUE / CASE WHEN C.MMD_VALUE = 0 THEN 1 ELSE C.MMD_VALUE END AS MMD_VALUE
						  ,B.MAX_VER_FLAG
						  ,B.PROD_VERSION_TYPE
						  ,B.VERSION_TYPE
						  ,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						  ,B.[PROD_SEQ]    -- 2020-07-10 kimcd PROD_SEQ 차수 추가
					  FROM DBO.SCM_ITEM_CONV_CALC_M  B
						  ,DBO.SCM_ITEM_CONV_CALC_M  C
						  ,DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
						  ,(SELECT [CMODEL_CODE]
								  ,CASE WHEN [AREA_ID] = 'EA' THEN
										CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
											CONCAT([PROD_VER_CODE],'2')
										ELSE
											CONCAT([PROD_VER_CODE],'3')
										END
									ELSE
										[PROD_VER_CODE]
									END AS [PROD_VER_CODE]
								  ,[AREA_ID]
		  						  ,[PRODID]
								  ,[PROC_ID]
						    FROM   #PLM_ITEM_CONV_CALC  ICC 
							GROUP  BY  [CMODEL_CODE]
									  ,CASE WHEN [AREA_ID] = 'EA' THEN
											CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
												CONCAT([PROD_VER_CODE],'2')
											ELSE
												CONCAT([PROD_VER_CODE],'3')
											END
										ELSE
											[PROD_VER_CODE]
										END
									  ,[AREA_ID]
		  							  ,[PRODID]
									  ,[PROC_ID]
							UNION -- 2022-04-14 김현 [C20220328-000596] 단면 미형성 오류 보완
							SELECT [CMODEL_CODE]
								  ,CASE WHEN [AREA_ID] = 'EA' THEN
										CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
											CONCAT([PROD_VER_CODE],'2')
										ELSE
											CONCAT([PROD_VER_CODE],'3')
										END
									ELSE
										[PROD_VER_CODE]
									END AS [PROD_VER_CODE]
								  ,[AREA_ID]
		  						  ,[ATTR_07]
								  ,[PROC_ID]
						    FROM   #PLM_ITEM_CONV_CALC  ICC 
							WHERE  [ATTR_07] IS NOT NULL
							GROUP  BY  [CMODEL_CODE]
									  ,CASE WHEN [AREA_ID] = 'EA' THEN
											CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
												CONCAT([PROD_VER_CODE],'2')
											ELSE
												CONCAT([PROD_VER_CODE],'3')
											END
										ELSE
											[PROD_VER_CODE]
										END
									  ,[AREA_ID]
		  							  ,[ATTR_07]
									  ,[PROC_ID]
							) ICC -- 2020-11-09 kimcd 일괄 변경 대상 범위 제한
					 WHERE SLV.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
					 AND   SLV.SEGMENT1    = B.CATEGORY
					 AND   SLV.ACTIVE_FLAG = 'Y'
					 AND   SLV.ATTRIBUTE3  = 'DIVIDE'
					 AND   C.COMPANY_ID    = B.COMPANY_ID
					 AND   C.FACTORY_ID    = B.FACTORY_ID
					 AND   C.MODEL_ID      = B.MODEL_ID
					 AND   C.VERSION       = B.VERSION
					 AND   C.OPERATION     = B.OPERATION
					 AND   C.ITEM_ID       = B.ITEM_ID
					 AND   C.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
					 AND   C.CATEGORY      = 'Lane Number'
					 AND   B.OPERATION     = 'E2000'
					 AND   B.UPDATE_TIME  >= CONVERT( DATE, GETDATE())
 					 AND   B.[FACTORY_ID] NOT IN ( 'EA' )
					 AND   ICC.[AREA_ID]       = B.FACTORY_ID
					 AND   ICC.[CMODEL_CODE]   = B.MODEL_ID
					 AND   ICC.[PROD_VER_CODE] = B.VERSION
					 AND   ICC.[PROC_ID]       = B.OPERATION
					 AND   ICC.[PRODID]        = B.ITEM_ID  -- 2020-11-09 kimcd 일괄 변경 대상 범위 제한
					) B
			  ON (A.[COMPANY_ID]     = B.[COMPANY_ID]
				  AND A.[FACTORY_ID] = B.[FACTORY_ID]
				  AND A.[MODEL_ID]   = B.[MODEL_ID]
				  AND A.[VERSION]    = B.[VERSION]
				  AND A.[OPERATION]  = B.[OPERATION]
				  AND A.[ITEM_ID]    = B.[ITEM_ID]
				  AND A.[CATEGORY]   = B.[CATEGORY]
				  AND A.[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE]        = B.[PJT_CODE]
				           ,[ELECTRODE_TYPE] = B.[ELECTRODE_TYPE]
						   ,[VALUE]          = B.[VALUE]
						   ,[MMD_VALUE]		 = B.[MMD_VALUE]
						   ,[MAX_VER_FLAG]   = B.[MAX_VER_FLAG]
						   ,[PROD_VERSION_TYPE] = B.PROD_VERSION_TYPE
						   ,[VERSION_TYPE]   = B.[VERSION_TYPE]
						   ,[APPLY_DATE]	 = B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
						   ,[PROD_SEQ]       = B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
						   ,[UPDATE_ID]      = 'PR_XIF_PLM_ITEM_CONV_CALC_R'
						   ,[UPDATE_TIME]    = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]
					,[VERSION_TYPE]
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[APPLY_DATE] -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,[PROD_SEQ]   -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_ID]
					,B.[PJT_CODE]
					,B.[VERSION]
					,B.[OPERATION]
					,B.[ITEM_ID]
					,B.[ELECTRODE_TYPE]
					,B.[CATEGORY]
					,B.[VALUE]
					,B.[MMD_VALUE]
					,B.[MAX_VER_FLAG]
					,B.PROD_VERSION_TYPE
					,B.[VERSION_TYPE]
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_PLM_ITEM_CONV_CALC_R'
					,GETDATE()
					,B.[APPLY_DATE]  -- 2020-07-10 kimcd APPLY_DATE 적용일자 추가
					,B.[PROD_SEQ]  -- 2020-07-10 kimcd PROD_SEQ 차수 추가
				)
			;




			-- 전체 N으로 변경
			UPDATE CCM
			SET    MAX_VER_FLAG = 'N'
			FROM  [SCM_ITEM_CONV_CALC_M] CCM
				, ( SELECT   [CMODEL_CODE]
							,[AREA_ID]
		  					,[PRODID]
							,[PROC_ID]
					FROM   #PLM_ITEM_CONV_CALC  ICC 
					GROUP BY [CMODEL_CODE]
							,[AREA_ID]
		  					,[PRODID]
							,[PROC_ID]
					UNION -- 2022-04-14 김현 [C20220328-000596] 단면 미형성 오류 보완
					SELECT   [CMODEL_CODE]
							,[AREA_ID]
		  					,[ATTR_07]
							,[PROC_ID]
					FROM   #PLM_ITEM_CONV_CALC  ICC 
					WHERE   [ATTR_07] IS NOT NULL
					GROUP BY [CMODEL_CODE]
							,[AREA_ID]
		  					,[ATTR_07]
							,[PROC_ID]) ICC -- 2020-11-09 kimcd 일괄 변경 대상 범위 제한
   			WHERE CCM.[FACTORY_ID] NOT IN ( 'EA' ) 
 			AND   ICC.[AREA_ID]       = CCM.FACTORY_ID
			AND   ICC.[CMODEL_CODE]   = CCM.MODEL_ID
			AND   ICC.[PROC_ID]       = CCM.OPERATION
			AND   ICC.[PRODID]        = CCM.ITEM_ID  -- 2020-11-09 kimcd 일괄 변경 대상 범위 제한
			
			-- Y로 재설정
			UPDATE B
			   SET B.MAX_VER_FLAG = 'Y'
				   ,B.VERSION_TYPE = A.VERSION_TYPE
			  FROM [dbo].[SCM_ITEM_CONV_CALC_M] B
				   ,( SELECT A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.MODEL_ID
							 , A.OPERATION
							 , A.ITEM_ID
							 , A.VERSION
							 , A.VERSION_TYPE
							 , A.PROD_VERSION_TYPE
						FROM (
							   SELECT A.COMPANY_ID
									  , A.DIVISION_ID
									  , A.SITE_ID
									  , A.PLANT_ID
									  , A.FACTORY_ID
									  , A.MODEL_ID
									  , A.OPERATION
									  , A.ITEM_ID
									  , A.VERSION
									  , A.VERSION_TYPE
									  , A.PROD_VERSION_TYPE
									  , ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
																	 , A.MODEL_ID, A.OPERATION, A.ITEM_ID, A.VERSION_TYPE  ,A.PROD_VERSION_TYPE
																	 , CASE WHEN LEFT(VERSION, 1) = 'Z' THEN 'T' ELSE 'M' END
															   ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID
																	 , A.OPERATION, A.ITEM_ID , CASE RIGHT(VERSION, 1) WHEN 'W' THEN VERSION+'0'
																													   WHEN 'P' THEN VERSION+'0'
																													   WHEN 'S' THEN VERSION+'0'
																													   ELSE VERSION
																													   END DESC						 )  AS ROW_NUM
								 FROM (
										SELECT DISTINCT A.COMPANY_ID
											   , A.DIVISION_ID
											   , A.SITE_ID
											   , A.PLANT_ID
											   , A.FACTORY_ID
											   , A.MODEL_ID
											   , A.OPERATION
											   , A.ITEM_ID
											   , A.VERSION
											   , A.VERSION_TYPE
											   , A.PROD_VERSION_TYPE
										  FROM SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
							  				 , ( SELECT  [CMODEL_CODE]
														,[AREA_ID]
		  												,[PRODID]
														,[PROC_ID]
												 FROM   #PLM_ITEM_CONV_CALC  ICC 
												 GROUP BY [CMODEL_CODE]
														 ,[AREA_ID]
		  												 ,[PRODID]
														 ,[PROC_ID] 
												 UNION -- 2022-04-14 김현 [C20220328-000596] 단면 미형성 오류 보완
												 SELECT  [CMODEL_CODE]
														,[AREA_ID]
		  												,[ATTR_07]
														,[PROC_ID]
												 FROM   #PLM_ITEM_CONV_CALC  ICC 
												 WHERE   [ATTR_07] IS NOT NULL
												 GROUP BY [CMODEL_CODE]
														 ,[AREA_ID]
		  												 ,[ATTR_07]
														 ,[PROC_ID]) ICC -- 2020-11-09 kimcd 일괄 변경 대상 범위 제한
										 WHERE A.[FACTORY_ID] NOT IN ( 'EA' ) 
							  			 AND   ICC.[AREA_ID]       = A.FACTORY_ID
										 AND   ICC.[CMODEL_CODE]   = A.MODEL_ID
										 AND   ICC.[PROC_ID]       = A.OPERATION
										 AND   ICC.[PRODID]        = A.ITEM_ID  -- 2020-11-09 kimcd 일괄 변경 대상 범위 제한
									  ) A
							 ) A
					   WHERE ROW_NUM = 1
				   ) A
			 WHERE A.COMPANY_ID = B.COMPANY_ID
			   AND A.DIVISION_ID = B.DIVISION_ID
			   AND A.SITE_ID = B.SITE_ID
			   AND A.PLANT_ID = B.PLANT_ID
			   AND A.FACTORY_ID = B.FACTORY_ID
			   AND A.MODEL_ID = B.MODEL_ID
			   AND A.OPERATION = B.OPERATION
			   AND A.ITEM_ID = B.ITEM_ID
			   AND A.VERSION = B.VERSION
	   		   AND A.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE

			SET @v_err_check = '15. SCM_ITEM_CONV_CALC_M from #PLM_ITEM_CONV_CALC : 4'
			-- 2022-12-02 kimcd 전극 버전별 생산 계획 수립하기 위해 환산자 버전별 가용 라인 정보 자동 형성 시작
			MERGE INTO [dbo].[SCM_ITEM_CONV_CALC_USE_M] ICC
			USING (SELECT  DISTINCT 
			               CNV.FACTORY_ID       AS [FACTORY_ID]
						  ,CNV.MODEL_ID         AS [MODEL_ID]
						  ,CNV.ITEM_ID          AS [ITEM_ID]
						  ,ILA.[LINE_ID]        AS [LINE_ID]
						  ,ILA.[ELECTRODE_TYPE] AS [ELECTRODE_TYPE]
						  ,CNV.VERSION          AS [VERSION]
						  ,ILA.[COMPANY_ID]
						  ,ILA.[DIVISION_ID]
						  ,ILA.[SITE_ID]
						  ,ILA.[PLANT_ID]
						  ,ILA.[OPERATION_ID]
						  ,'Y'                  AS [ACTIVE_FLAG]
			       FROM    ( SELECT  B.COMPANY_ID
									,B.DIVISION_ID
									,B.SITE_ID
									,B.PLANT_ID
									,B.FACTORY_ID
									,B.OPERATION
									,B.VERSION
									,B.MODEL_ID
									,B.ITEM_ID
									,B.PROD_VERSION_TYPE
								FROM DBO.SCM_ITEM_CONV_CALC_M  B
									,(SELECT [CMODEL_CODE]
											,CASE WHEN [AREA_ID] = 'EA' THEN
												CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
													CONCAT([PROD_VER_CODE],'2')
												ELSE
													CONCAT([PROD_VER_CODE],'3')
												END
											ELSE
												[PROD_VER_CODE]
											END AS [PROD_VER_CODE]
											,[AREA_ID]
		  									,[PRODID]
											,[PROC_ID]
									FROM   #PLM_ITEM_CONV_CALC  ICC 
									GROUP  BY  [CMODEL_CODE]
												,CASE WHEN [AREA_ID] = 'EA' THEN
													CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
														CONCAT([PROD_VER_CODE],'2')
													ELSE
														CONCAT([PROD_VER_CODE],'3')
													END
												ELSE
													[PROD_VER_CODE]
												END
												,[AREA_ID]
		  										,[PRODID]
												,[PROC_ID]
									UNION
									SELECT [CMODEL_CODE]
											,CASE WHEN [AREA_ID] = 'EA' THEN
												CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
													CONCAT([PROD_VER_CODE],'2')
												ELSE
													CONCAT([PROD_VER_CODE],'3')
												END
											ELSE
												[PROD_VER_CODE]
											END AS [PROD_VER_CODE]
											,[AREA_ID]
		  									,[ATTR_07]
											,[PROC_ID]
									FROM   #PLM_ITEM_CONV_CALC  ICC 
									WHERE  [ATTR_07] IS NOT NULL
									GROUP  BY  [CMODEL_CODE]
												,CASE WHEN [AREA_ID] = 'EA' THEN
													CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
														CONCAT([PROD_VER_CODE],'2')
													ELSE
														CONCAT([PROD_VER_CODE],'3')
													END
												ELSE
													[PROD_VER_CODE]
												END
												,[AREA_ID]
		  										,[ATTR_07]
												,[PROC_ID]
									) ICC
								WHERE B.OPERATION     = 'E2000'
								AND   B.UPDATE_TIME  >= CONVERT( DATE, GETDATE())
 								AND   B.[FACTORY_ID] NOT IN ( 'EA' )
								AND   ICC.[AREA_ID]       = B.FACTORY_ID
								AND   ICC.[CMODEL_CODE]   = B.MODEL_ID
								AND   ICC.[PROD_VER_CODE] = B.VERSION
								AND   ICC.[PROC_ID]       = B.OPERATION
								AND   ICC.[PRODID]        = B.ITEM_ID
								AND   B.[CATEGORY]        = 'Pancake (cell/m)' ) CNV
								INNER JOIN SCM_LINE_M   LM  WITH(NOLOCK)
								ON  LM.COMPANY_ID     = CNV.COMPANY_ID
								AND LM.DIVISION_ID    = CNV.DIVISION_ID
								AND LM.SITE_ID        = CNV.SITE_ID
								AND LM.PLANT_ID       = CNV.PLANT_ID
								AND LM.FACTORY_ID     = CNV.FACTORY_ID
								AND LM.OPERATION_ID      = CNV.OPERATION
								AND LM.PROD_VERSION_TYPE = CNV.PROD_VERSION_TYPE
								AND LM.ACTIVE_FLAG   = 'Y'
								INNER JOIN SCM_ITEM_LINE_ASSIGN_M  ILA WITH(NOLOCK)
								ON  ILA.COMPANY_ID     = LM.COMPANY_ID
								AND ILA.DIVISION_ID    = LM.DIVISION_ID
								AND ILA.SITE_ID        = LM.SITE_ID
								AND ILA.PLANT_ID       = LM.PLANT_ID
								AND ILA.FACTORY_ID     = LM.FACTORY_ID
								AND ILA.OPERATION_ID   = LM.OPERATION_ID
								AND ILA.LINE_ID        = LM.LINE_ID
								AND ILA.ELECTRODE_TYPE = LM.ELECTRODE_TYPE
								AND ILA.ITEM_ID        = CNV.ITEM_ID
					WHERE ILA.MONTH       >= CONVERT(VARCHAR(6), DATEADD(M, -1, GETDATE()), 112)
					) ILA
			ON (    ICC.[FACTORY_ID]	 = ILA.[FACTORY_ID]
				AND ICC.[MODEL_ID]		 = ILA.[MODEL_ID]
				AND ICC.[ITEM_ID]		 = ILA.[ITEM_ID]
				AND ICC.[LINE_ID]		 = ILA.[LINE_ID]
				AND ICC.[ELECTRODE_TYPE] = ILA.[ELECTRODE_TYPE]
				AND ICC.[VERSION]        = ILA.[VERSION] )
			WHEN NOT MATCHED THEN
				INSERT (   [FACTORY_ID]
						  ,[MODEL_ID]
						  ,[ITEM_ID]
						  ,[LINE_ID]
						  ,[ELECTRODE_TYPE]
						  ,[VERSION]
						  ,[COMPANY_ID]
						  ,[DIVISION_ID]
						  ,[SITE_ID]
						  ,[PLANT_ID]
						  ,[OPERATION_ID]
						  ,[ACTIVE_FLAG]
						  ,[INSERT_ID]
						  ,[INSERT_TIME]
						  ,[UPDATE_ID]
						  ,[UPDATE_TIME])
				VALUES (   ILA.[FACTORY_ID]
						  ,ILA.[MODEL_ID]
						  ,ILA.[ITEM_ID]
						  ,ILA.[LINE_ID]
						  ,ILA.[ELECTRODE_TYPE]
						  ,ILA.[VERSION]
						  ,ILA.[COMPANY_ID]
						  ,ILA.[DIVISION_ID]
						  ,ILA.[SITE_ID]
						  ,ILA.[PLANT_ID]
						  ,ILA.[OPERATION_ID]
						  ,ILA.[ACTIVE_FLAG]
						  ,'PR_XIF_PLM_ITEM_CONV_CALC_R'
						  ,GETDATE()
						  ,'PR_XIF_PLM_ITEM_CONV_CALC_R'
						  ,GETDATE()
						  );
			-- 2022-12-02 kimcd 전극 버전별 생산 계획 수립하기 위해 환산자 버전별 가용 라인 정보 자동 형성 종료

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		ROLLBACK TRAN

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, @v_err_check, @v_descr, @sysdate

	END CATCH

END
