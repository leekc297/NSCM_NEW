
CREATE PROCEDURE [dbo].[PR_MK_FP_KPI]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_MK_FP_KPI
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : KPI
-- Destination System  : FP 
-- Source Table        : TH_BUF_SCM_BOM_VALIDATION_A
--						 FP_WEEKLY_DEMAND_PRODUCT_H, FP_WEEKLY_DEMAND_SHIPMENT_H, FP_WEEKLY_DEMAND_PRODUCT_SRS_H, FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H, FP_WEEKLY_DEMAND_PRODUCT_TEST_H	
--    [dbo].[PR_SCM_OF_PACK_REQUIRE_CEL]                   SCM_SYS_CALENDAR_M
--						 FP_MASTER_VALIDATION_H
--						 SCM_FP_PLAN_H
--						 FP_PRODUCTION_PLAN_EQUIPMENT_R
--						 FP_DAILY_PRODUCTION_PLAN_R
--                       FP_KPI_DAILY_PRODUCTION_PLAN_H - 3일 fix, 생산 계획 준수율
--                       FP_DAILY_PRODUCTIOIN_PLAN_H 생산 계획 달성율
--                       SCM_DAILY_PRODUCT_RESULT_H  생산 계획 달성율, 준수율
-- Destination Table   : FP_KPI_RESULT_R , FP_KPI_RAW_DATA_R
--                       009 3일 Fix준수율
--                       010 생산 계획 달성율
--                       011 생산 계획 준수율
--                       012 SCP타겟-FP계획 충족율
--                       013 W/O 미생성 건 수
--                       014 Capa 미등록율
--                       015 SCP Target 기준 수율 등록 건수
--
-- Create Date		   : 2017.03.23
-- Update Date		   : 2017.06.14 PIYONG
--					   : 2017.06.23 PIYONG
--                     : 2018.09.04 kimcd
--                     : 2018.10.08 kimcd
--                     : 2018.10.10 kimcd
--                     : 2018.11.01 kimcd
--                     : 2018.11.12 kimcd
--                     : 2018.11.25 kimcd
--                     : 2018.12.04 kimcd
--                     : 2018.12.07 kimcd
--                     : 2018.12.17 kimcd
--                     : 2018.12.18 kimcd
--                     : 2019.01.08 kimcd
--                     : 2019.01.16 kimcd
--                     : 2019.01.21 kimcd
--                     : 2019.03.25 kimcd
--                     : 2019.04.02 kimcd
--                     : 2019.04.04 kimcd
--                     : 2019.04.23 kimcd
--                     : 2019.06.13 kimcd
--                     : 2019.07.09 kimcd
--                     : 2019.09.27 kimcd
--                     : 2019.12.06 kimcd
--                     : 2020.03.17 kimcd
--                     : 2020.06.26 kimcd
--                     : 2021.11.03 kimcd
--                     : 2022.03.20 kimcd

-- Author              : 박 성용
-- Version             : 1.0
--						 1.1 2017-06-14 PIYONG	실적 합산시 ADD_QTY 추가
--						 1.2 2017-06-14 PIYONG	실적수량 조회시 ADD_QTY 삭제  양품 수량에 이미 포함되어 있음
--                       1.3 2018-09-04 kimcd   계획 fix 준수율, 계획 실적 달성율, 준수율 로직 재구성
--                       1.4 2018-10-08 kimcd   계획 달성율 로직 수정
--                       1.5 2018-10-10 kimcd   생산계획 준수율, 3일 fix 확정율 수정
--                       1.6 2018-10-12 kimcd   prod type group 컬럼 추가
--                       1.7 2018-10-30 kimcd   A011 - 오창 소형 전극 MPP 달성율 대상에서 제외
--                       1.8 2018-11-01 kimcd   달성율,준수율 분모 추출에서 당일 이후는 제외
--                       1.9 2018-11-12 kimcd   3일 fix 로직 수정 - polit line 제거, sequence, 선행 품목 추가
--                       2.0 2018-11-23	kimcd	가동율 지표 추가
--                       2.1 2018-11-25 kimcd   준수율 지표에서 실적만 있는 base date는 base week의 마지막 일자로 넣음
--                       2.2 2018-12-04 kimcd	준수율 plan 정보를 WPP로 변경. 달성율 월 기준 계획 WPP로 변경
--                       2.3 2018-12-07 kimcd   rework 실적 제거, 실적 Jumbo roll로 전환
--                       2.4 2018-12-17 kimcd	SCM_MES_WIP_HISTORY_H에서 실적 취합 로직 제거. 신규 WO는 실적 없음
--                       2.5 2018-12-18 kimcd   KPI 지표 대상 제외 Factory lookup 조정으로 변경
--                       2.6 2019-01-08 kimcd   준수율에서 과거 base week은 계획 정보 수정 안 함
--                       2.7 2019-01-16 kimcd   준수율 계획은 미래 구간도 입력
--                       2.8 2019-01-21 kimcd	달성율,준수율,가동율에서 SPECIAL은 MASS에 포함되도록 로직 수정
--                       2.9 2019-03-25 kimcd   3일 Fix 지표에서 Seq 제외
--                       2.91 2019-04-02 kimcd  3일 Fix 지표에서 선행 모델 제외
--                       3.0 2019-04-04 kimcd   준수율, 달성율 지표에서 계획, 실적 로직 수정
--                                              FP_KPI_DOUBLE_LINE 계획, 실적 2배로 형성
--                                              오창 1동 코팅 실적을 Top, Back 더하여 1/2로 함
--                       3.1 2019-04-23 kimcd   HI 지표 013	HI 지표 : W/O 미생성 건수
--                                                      014	HI 지표 : Capa 미등록 율 추가
--                                                      015 HI 지표 : 수율 등록율 추가
--                       3.2 2019-06-13 kimcd   HI 지표 012 HI 지표 : 가동율 ID 재활용하여 SCP타겟-FP계획 충족율 형성
--                       3.3 2019-07-09 kimcd   HI 지표 013	HI 지표 : W/O 미생성 건수 : item, nick name 추가
--                                                      014	HI 지표 : Capa 미등록 율 : Nick Name 추가
--                       3.4 2019-09-27 kimcd   남경 시업 시간 분리 감안 시업 시간 기준으로 정보 형성 단위 분리
--                                              미사용지표 형성에서 제거
--                       3.5 2019-12-06 kimcd   3일 fix 준수율 계산 로직 전체 수정
--                       3.6 2020-03-17 kimcd   생산 계획 준수율, 달성율에서 E1,E2동 실적 계산 로직 수정
--                                              back 실적만 있어도 반으로 나눔
--                       3.7 2020-06-26 kimcd   PRODUCTION_TYPE C-MASS, D-MASS를 MASS에 포함
--                       3.8 2021-11-03 kimcd   생산 계획 준수율 - SCP 부가 정보 추가하여 별도 형성
--                                              P5200 공정 추가에 따른 수정. P5500 예외 처리
--                       3.9 2022-03-20 kimcd   가상 Division 사용에 따른 수정
-- ================================================================================================
-- PARAMETER
@P_SITE_ID NVARCHAR(50) = 'NULL',
@P_BASIS_START_TIME NVARCHAR(6) = '060000'  -- 2019-09-27 kimcd 시업 시간 매개변수 추가

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_MK_FP_KPI'
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

	--내부 용 변수 
	DECLARE @v_date			 NVARCHAR(10);
	DECLARE @v_ydate		 NVARCHAR(10);
	DECLARE @THREE_FIX_DATE  DATE;         -- 2018-09-04 kimcd 추가 3일 fix date 기준일
	DECLARE @THREE_FIX_WEEK  NVARCHAR(10); -- 2018-09-04 kimcd 추가 3일 fix date 기준일
	DECLARE @MPP_MONTH       NVARCHAR(10); -- 2018-09-04 kimcd 달성율 MPP
	DECLARE @WEEK_NUMBER     NVARCHAR(10); -- 2018-09-04 kimcd 달성율,준수율 주차번호
	DECLARE @FROM_DATE       DATE;         -- 2018-09-04 kimcd 달성율,준수율 주 시작일
	DECLARE @TO_DATE         DATE;         -- 2018-09-04 kimcd 달성율,준수율 주 종료일
	DECLARE @BASIC_WEEK      NVARCHAR(10); -- 2018-10-10 kimcd 준수율 계획 주차 구분
	DECLARE @OB_NUM          NUMERIC(1,0); -- 2018-10-10 kimcd 준수율 계획 주차 - 조회 범위 확정용 snapshot 일자
	DECLARE @I_COMPANY_ID    NVARCHAR(30); -- 2018-09-04 kimcd 3일 fix 정보 입력
	DECLARE @I_DIVISION_ID   NVARCHAR(30); -- 2018-09-04 kimcd 3일 fix 정보 입력
	DECLARE @I_SITE_ID       NVARCHAR(30); -- 2018-09-04 kimcd 3일 fix 정보 입력
	DECLARE @I_PLANT_ID      NVARCHAR(30); -- 2018-09-04 kimcd 3일 fix 정보 입력
	DECLARE @I_FACTORY_ID    NVARCHAR(30); -- 2018-09-04 kimcd 3일 fix 정보 입력
	DECLARE @I_OPERATION_ID  NVARCHAR(30); -- 2018-09-04 kimcd 3일 fix 정보 입력
	DECLARE @I_LINE_ID       NVARCHAR(30); -- 2018-09-04 kimcd 3일 fix 정보 입력
	DECLARE @I_VALUE3        NVARCHAR(150);-- 2018-09-04 kimcd 3일 fix 정보 입력
	DECLARE @I_VALUE2        NVARCHAR(150);-- 2018-09-04 kimcd 3일 fix 정보 입력
	DECLARE @I_SEQ           NUMERIC(18,0);-- 2018-09-04 kimcd 3일 fix 정보 입력
	DECLARE @CURRENT_WEEK    NVARCHAR(10); -- 2019-01-08 kimcd 준수율에서 BASIC_WEEK(계획 수립 주차)가 과거인 경우 계획 수량 갱신에서 제외
	DECLARE @BASIS_START_TIME NVARCHAR(6) = @P_BASIS_START_TIME;  -- 2019-09-27 kimcd 시업 시간 매개변수 추가
	
	DECLARE @v_dp_scp_plan_id   NVARCHAR(30);
	DECLARE @v_ds_scp_plan_id   NVARCHAR(30);
	DECLARE @v_dp_srs_plan_id   NVARCHAR(30);
	DECLARE @v_dse_scp_plan_id  NVARCHAR(30);
	DECLARE @v_dpt_scp_plan_id  NVARCHAR(30);

	DECLARE @v_instance_id   NVARCHAR(100);
	DECLARE @i_baseBomCnt    INTEGER = 0;
	DECLARE @TACT_TIME_MONTH NVARCHAR(10); -- 2019-04-23 kimcd HI 지표에서 Capa 미등록율 월설정용

	BEGIN TRY				

		
		-- ================================================
		-- 로직 추가
		-- ================================================
		SET @v_date = CONVERT(CHAR(10),  GETDATE(), 120)
		SET @v_ydate = CONVERT(CHAR(10), GETDATE() -1, 120)
		SET @v_dp_scp_plan_id = ISNULL((SELECT MAX(SCP_PLAN_ID)
									   FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_H] WITH(NOLOCK)
									  WHERE SITE_ID = @P_SITE_ID), '');
	    SET @v_ds_scp_plan_id = ISNULL((SELECT MAX(SCP_PLAN_ID)
									   FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_H] WITH(NOLOCK)
									  WHERE SITE_ID = @P_SITE_ID), '');
		SET @v_dp_srs_plan_id = ISNULL((SELECT MAX(SRS_PLAN_ID)
									   FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_SRS_H] WITH(NOLOCK)
									  WHERE SITE_ID = @P_SITE_ID), '');
		SET @v_dse_scp_plan_id = ISNULL((SELECT MAX(SCP_PLAN_ID)
									   FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] WITH(NOLOCK)
									  WHERE SITE_ID = @P_SITE_ID), '');
		SET @v_dpt_scp_plan_id = ISNULL((SELECT MAX(SCP_PLAN_ID)
									   FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_TEST_H] WITH(NOLOCK)
									  WHERE SITE_ID = @P_SITE_ID), '');

		

		BEGIN TRAN
			SET @v_temp2 = 'DELETE OLD DATA-BASE INFO';
			DELETE [DBO].[FP_KPI_RAW_DATA_R]
			WHERE KPI_ID IN ('001','002','003','004','005','006','007')
			AND   KPI_DATE = @v_date
			AND   SITE_ID = @P_SITE_ID;

			DELETE [DBO].[FP_KPI_RESULT_R]
			WHERE KPI_ID IN ('001','002','003','004','005','006','007')
			AND   KPI_DATE = @v_date
			AND   SITE_ID = @P_SITE_ID;

			SET @v_temp2 = 'DELETE OLD DATA-TXN';
			DELETE [DBO].[FP_KPI_RAW_DATA_R]
			WHERE KPI_ID IN ('008')
			AND   KPI_DATE = @v_ydate
			AND   SITE_ID = @P_SITE_ID;

			DELETE [DBO].[FP_KPI_RESULT_R]
			WHERE KPI_ID IN ('008')
			AND   KPI_DATE = @v_ydate
			AND   SITE_ID = @P_SITE_ID;
		

		-- FP 계획 수립 대상 수요부터 BOM 전개하여 BOM 미등록된 반제품, 제품 Item 개수 8주차
		-- 타이틀 입력
		/* 2019-09-27 kimcd 미사용지표 형성에서 제거
			SET @v_temp2 = 'INSERT 001 TITLE';
			INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[SEQ],
				[VALUE1],
				[VALUE2],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
			)VALUES(
				'001',
				@v_date,
				'-',
				'-',
				@P_SITE_ID,
				'-',
				'-',
				'-',
				'-',
				0,
				'PROBLEM ITEM',
				'Min due Date ',
				'SYSTEM',
				GETDATE(),
				'SYSTEM',
				GETDATE()
			);

		-- 데이터 입력
			SET @v_temp2 = 'INSERT OO1 DATA';
			INSERT INTO [dbo].[FP_KPI_RAW_DATA_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[SEQ],
				[VALUE1],
				[VALUE2],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
			)
			SELECT '001',
				   @v_date,
				   A.COMPANY_ID,
				   A.DIVISION_ID,
				   A.SITE_ID,
				   '-',
				   '-',
				   '-',
				   '-',
				   ROW_NUMBER()OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROBLEM_DATA) AS SEQ,
				   A.PROBLEM_DATA,
				   MIN(FIRST_DUE_DATE),
				   'SYSTEM',
				   GETDATE(),
				   'SYSTEM',
				   GETDATE() 
			 FROM (
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  										 FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
												  AND (SELECT WEEK + 7
				  										 FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
							   AND SCP_PLAN_ID = @v_dp_scp_plan_id) DP
					 INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
							 ON DP.COMPANY_ID = MV.COMPANY_ID
							AND DP.DIVISION_ID = MV.DIVISION_ID
							AND DP.SITE_ID = MV.SITE_ID
							AND DP.PLANT_ID = MV.PLANT_ID
							AND DP.ITEM_ID = MV.TOP_ITEM_ID
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'BOM'	
					   AND MV.REFERENCE_TABLE = 'FP_WEEKLY_DEMAND_PRODUCT_H'
					   AND MV.PLAN_DATE = @v_date
					UNION ALL
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							 FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_H] A with(nolock)
							WHERE A.SITE_ID = @P_SITE_ID		
							  AND A.SHIP_WEEK BETWEEN (SELECT WEEK
			  											 FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
												  AND (SELECT WEEK + 7
				  										 FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
							  AND SCP_PLAN_ID = @v_ds_scp_plan_id) DS
					       INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
							  ON DS.COMPANY_ID = MV.COMPANY_ID
							 AND DS.DIVISION_ID = MV.DIVISION_ID
							 AND DS.SITE_ID = MV.SITE_ID
							 AND DS.PLANT_ID = MV.PLANT_ID
							 AND DS.ITEM_ID = MV.TOP_ITEM_ID
							 AND DS.SHIP_DATE = MV.PLAN_DATE
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'BOM'	
					   AND MV.REFERENCE_TABLE = 'FP_WEEKLY_DEMAND_SHIPMENT_H'
					   AND MV.PLAN_DATE = @v_date
					UNION ALL
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_SRS_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  										 FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
														  AND (SELECT WEEK + 7
				  												FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
															   WHERE DATE_ID = @v_date) 
							   AND SRS_PLAN_ID = @v_dp_srs_plan_id) DPS
					        INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
							   ON DPS.COMPANY_ID = MV.COMPANY_ID
							  AND DPS.DIVISION_ID = MV.DIVISION_ID
							  AND DPS.SITE_ID = MV.SITE_ID
							  AND DPS.PLANT_ID = MV.PLANT_ID
							  AND DPS.ITEM_ID = MV.TOP_ITEM_ID
							  AND DPS.MFG_DATE = MV.PLAN_DATE
				     WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'BOM'	
					   AND MV.REFERENCE_TABLE = 'FP_WEEKLY_DEMAND_PRODUCT_SRS_H'
					   AND MV.PLAN_DATE = @v_date
					UNION ALL
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.SHIP_WEEK BETWEEN (SELECT WEEK
				  										  FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
														 WHERE DATE_ID = @v_date) 
												   AND (SELECT WEEK + 7
				  										  FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
														 WHERE DATE_ID = @v_date) 
								AND A.SCP_PLAN_ID = @v_dse_scp_plan_id) DSE
					          INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
							     ON DSE.COMPANY_ID = MV.COMPANY_ID
							    AND DSE.DIVISION_ID = MV.DIVISION_ID
							    AND DSE.SITE_ID = MV.SITE_ID
							    AND DSE.PLANT_ID = MV.PLANT_ID
							    AND DSE.ITEM_ID = MV.TOP_ITEM_ID
							    AND DSE.SHIP_DATE = MV.PLAN_DATE
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'BOM'
					   AND MV.REFERENCE_TABLE = 'FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H'
					   AND MV.PLAN_DATE = @v_date
					UNION ALL
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_TEST_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  										 FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
												  AND (SELECT WEEK + 7
				  										 FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
							   AND A.SCP_PLAN_ID = @v_dpt_scp_plan_id) DPTH
					         INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
						 	    ON DPTH.COMPANY_ID = MV.COMPANY_ID
							   AND DPTH.DIVISION_ID = MV.DIVISION_ID
							   AND DPTH.SITE_ID = MV.SITE_ID
							   AND DPTH.PLANT_ID = MV.PLANT_ID
							   AND DPTH.ITEM_ID = MV.TOP_ITEM_ID
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'BOM'
					   AND MV.REFERENCE_TABLE = 'FP_WEEKLY_DEMAND_PRODUCT_TEST_H'
					   AND MV.PLAN_DATE = @v_date
 				) A
		  GROUP BY A.COMPANY_ID,
				A.DIVISION_ID,
				A.SITE_ID,
				A.PROBLEM_DATA;

			SET @v_temp2 = 'INSERT 001 KPI';
			INSERT INTO [DBO].[FP_KPI_RESULT_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[RESULT],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
			)
			SELECT '001', --[KPI_ID],
				   @v_date, -- [KPI_DATE],
				   A.[COMPANY_ID],
				   A.[DIVISION_ID],
				   A.[SITE_ID],
				   '-', --[PLANT_ID],
				   '-', --[FACTORY_ID],
				   '-', --[OPERATION_ID],
				   '-', --[LINE_ID],
				   COUNT(SEQ) AS SEQ,
				   'SYSTEM',
				   GETDATE(),
				   'SYSTEM',
				   GETDATE() 

			 FROM ( SELECT COMPANY_ID, DIVISION_ID, SITE_ID
					FROM DBO.SCM_PLANT_M  WITH(NOLOCK)
					GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID ) A
			 LEFT OUTER JOIN (SELECT *
					  		    FROM [DBO].[FP_KPI_RAW_DATA_R]  WITH(NOLOCK)
							   WHERE [KPI_ID] = '001'
					    		 AND [KPI_DATE] = @v_date
								 AND [SITE_ID] = @P_SITE_ID
								 AND SEQ > 0 ) B
			   ON A.COMPANY_ID = B.COMPANY_ID
			  AND A.DIVISION_ID = B.DIVISION_ID
			  AND A.SITE_ID = B.SITE_ID
            WHERE A.SITE_ID = @P_SITE_ID
		     GROUP BY [KPI_ID],
				   [KPI_DATE],
				   A.[COMPANY_ID],
				   A.[DIVISION_ID],
				   A.[SITE_ID],
				   [PLANT_ID],
				   [FACTORY_ID],
				   [OPERATION_ID],
				   [LINE_ID] 2019-09-27 kimcd 미사용지표 형성에서 제거*/

			-- FP 계획 수립 대상 수요부터 BOM 전개하여 BOM 미등록된 반제품, 제품 8주차 율
			--타이틀 등록
			/* 2019-09-27 kimcd 미사용지표 형성에서 제거
			SET @v_temp2 = 'INSERT 002 TITLE';
			INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[SEQ],
				[value1],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
			)VALUES(
				'002',
				@v_date,
				'-',
				'-',
				@P_SITE_ID,
				'-',
				'-',
				'-',
				'-',
				0,
				'Rate',
				'SYSTEM',
				GETDATE(),
				'SYSTEM',
				GETDATE()
			);

			SET @v_temp2 = 'INSERT 002 DATA';
			INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
					[KPI_ID],
					[KPI_DATE],
					[COMPANY_ID],
					[DIVISION_ID],
					[SITE_ID],
					[PLANT_ID],
					[FACTORY_ID],
					[OPERATION_ID],
					[LINE_ID],
					[SEQ],
					[value1],
					[INSERT_ID],
					[INSERT_TIME],
					[UPDATE_ID],
					[UPDATE_TIME]
				)
				SELECT '002',
					   @v_date,
					   A.[COMPANY_ID],
					   A.[DIVISION_ID],
					   A.[SITE_ID],
					   '-',
					   '-',
					   '-',
					   '-',
					   ROW_NUMBER()OVER(ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID) AS SEQ,
					   CASE WHEN (SELECT COUNT(DISTINCT C.PARENT_ITEM_ID)
									FROM [dbo].[TH_BUF_SCM_BOM_VALIDATION_A] C WITH(NOLOCK)
								   WHERE C.COMPANY_ID = A.[COMPANY_ID]
								     AND C.DIVISION_ID = A.[DIVISION_ID]
									 AND C.SITE_ID = A.SITE_ID
									 AND C.PARENT_ITEM_TYPE IN('P', 'H') ) = 0 THEN 0
							 ELSE
								convert(numeric(18,5), COUNT(SEQ) / (SELECT COUNT(DISTINCT C.PARENT_ITEM_ID)
																	   FROM [dbo].[TH_BUF_SCM_BOM_VALIDATION_A] C WITH(NOLOCK)
																	  WHERE C.COMPANY_ID = A.[COMPANY_ID]
																		AND C.DIVISION_ID = A.[DIVISION_ID]
																		AND C.SITE_ID = A.SITE_ID
																		AND C.PARENT_ITEM_TYPE IN('P', 'H')) * 100)
							  END,
					   'SYSTEM',
					   GETDATE(),
					   'SYSTEM',
					   GETDATE() 
				  FROM ( SELECT COMPANY_ID, DIVISION_ID, SITE_ID
						   FROM DBO.SCM_PLANT_M WITH(NOLOCK)
						  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID )A
			      LEFT OUTER JOIN (SELECT *
					  		         FROM [DBO].[FP_KPI_RAW_DATA_R] WITH(NOLOCK)
							        WHERE [KPI_ID] = '001'
					    			  AND [KPI_DATE] = @v_date
									  AND [SITE_ID] = @P_SITE_ID
									  AND SEQ > 0 ) B
					ON A.COMPANY_ID = B.COMPANY_ID
				   AND A.DIVISION_ID = B.DIVISION_ID
				   AND A.SITE_ID = B.SITE_ID
                 WHERE A.SITE_ID = @P_SITE_ID
				 GROUP BY A.[COMPANY_ID],
					   A.[DIVISION_ID],
					   A.[SITE_ID];


			SET @v_temp2 = 'INSERT 002 KPI';
			INSERT INTO [DBO].[FP_KPI_RESULT_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[RESULT],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME])
			SELECT '002',
				   @v_date,
				   A.[COMPANY_ID],
				   A.[DIVISION_ID],
				   A.[SITE_ID],
				   '-', -- [PLANT_ID],
				   '-',
				   '-',
				   '-',
				   CASE WHEN (SELECT COUNT(DISTINCT C.PARENT_ITEM_ID)
									FROM [dbo].[TH_BUF_SCM_BOM_VALIDATION_A] C WITH(NOLOCK)
								   WHERE C.COMPANY_ID = A.[COMPANY_ID]
								     AND C.DIVISION_ID = A.[DIVISION_ID]
									 AND C.SITE_ID = A.SITE_ID
									 AND C.PARENT_ITEM_TYPE IN('P', 'H') ) = 0 THEN 0
							 ELSE
								convert(numeric(18,5), COUNT(SEQ) / (SELECT COUNT(DISTINCT C.PARENT_ITEM_ID)
																	   FROM [dbo].[TH_BUF_SCM_BOM_VALIDATION_A] C  WITH(NOLOCK)
																	  WHERE C.COMPANY_ID = A.[COMPANY_ID]
																		AND C.DIVISION_ID = A.[DIVISION_ID]
																		AND C.SITE_ID = A.SITE_ID
																		AND C.PARENT_ITEM_TYPE IN('P', 'H')) * 100)
							  END,
				   'SYSTEM',
				   GETDATE(),
				   'SYSTEM',
				   GETDATE() 
			 FROM ( SELECT COMPANY_ID, DIVISION_ID, SITE_ID
					FROM DBO.SCM_PLANT_M  WITH(NOLOCK)
					GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID ) A
			 LEFT OUTER JOIN (SELECT *
					  		    FROM [DBO].[FP_KPI_RAW_DATA_R]  WITH(NOLOCK)
							   WHERE [KPI_ID] = '001'
					    		 AND [KPI_DATE] = @v_date
								 AND [SITE_ID] = @P_SITE_ID
								 AND SEQ > 0 ) B
			   ON A.COMPANY_ID = B.COMPANY_ID
			  AND A.DIVISION_ID = B.DIVISION_ID
			  AND A.SITE_ID = B.SITE_ID
            WHERE A.SITE_ID = @P_SITE_ID
			GROUP BY B.[KPI_ID],
				   B.[KPI_DATE],
				   A.[COMPANY_ID],
				   A.[DIVISION_ID],
				   A.[SITE_ID] 2019-09-27 kimcd 미사용지표 형성에서 제거*/




			-- FP 계획 수립 대상 수요부터 BOM 전개하여 BOM 미등록된 반제품, 제품 Item 개수 4주차
			-- 타이틀 입력
			/* 2019-09-27 kimcd 미사용지표 형성에서 제거
			SET @v_temp2 = 'INSERT 003 TITLE';
			INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[SEQ],
				[value1],
				[value2],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
			)VALUES(
				'003',
				@v_date,
				'-',
				'-',
				@P_SITE_ID,
				'-',
				'-',
				'-',
				'-',
				0,
				'PROBLEM ITEM',
				'Min due Date',
				'SYSTEM',
				GETDATE(),
				'SYSTEM',
				GETDATE()
			);

			SET @v_temp2 = 'INSERT 003 DATA';
			INSERT INTO [dbo].[FP_KPI_RAW_DATA_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				SEQ,
				[value1],
				[value2],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
			)
			SELECT '003',
				   @v_date,
				   A.COMPANY_ID,
				   A.DIVISION_ID,
				   @P_SITE_ID,
				   '-',
				   '-',
				   '-',
				   '-',
				   ROW_NUMBER()OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROBLEM_DATA) AS SEQ,
				   A.PROBLEM_DATA,
				   MIN(FIRST_DUE_DATE),
				   'SYSTEM',
				   GETDATE(),
				   'SYSTEM',
				   GETDATE() 
			 FROM (
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  										 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
												  AND (SELECT WEEK + 3
				  										 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
							   AND SCP_PLAN_ID = @v_dp_scp_plan_id) DP
						     INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV
								ON DP.COMPANY_ID = MV.COMPANY_ID
							   AND DP.DIVISION_ID = MV.DIVISION_ID
							   AND DP.SITE_ID = MV.SITE_ID
							   AND DP.PLANT_ID = MV.PLANT_ID
							   AND DP.ITEM_ID = MV.TOP_ITEM_ID
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'BOM'	
					   AND MV.REFERENCE_TABLE = 'FP_WEEKLY_DEMAND_PRODUCT_H'
					   AND MV.PLAN_DATE = @v_date
					UNION ALL
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.SHIP_WEEK BETWEEN (SELECT WEEK
			  											  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														 WHERE DATE_ID = @v_date) 
												   AND (SELECT WEEK + 3
				  										  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														  WHERE DATE_ID = @v_date) 
							   AND SCP_PLAN_ID = @v_ds_scp_plan_id) DS
					         INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
							    ON DS.COMPANY_ID = MV.COMPANY_ID
							   AND DS.DIVISION_ID = MV.DIVISION_ID
							   AND DS.SITE_ID = MV.SITE_ID
							   AND DS.PLANT_ID = MV.PLANT_ID
							   AND DS.ITEM_ID = MV.TOP_ITEM_ID
							   AND DS.SHIP_DATE = MV.PLAN_DATE
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'BOM'	
					   AND MV.REFERENCE_TABLE = 'FP_WEEKLY_DEMAND_SHIPMENT_H'
					   AND MV.PLAN_DATE = @v_date
					UNION ALL
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_SRS_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  										 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
												  AND (SELECT WEEK + 3
				  										 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
								AND SRS_PLAN_ID = @v_dp_srs_plan_id) DPS
					          INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
							     ON DPS.COMPANY_ID = MV.COMPANY_ID
							    AND DPS.DIVISION_ID = MV.DIVISION_ID
							    AND DPS.SITE_ID = MV.SITE_ID
							    AND DPS.PLANT_ID = MV.PLANT_ID
							    AND DPS.ITEM_ID = MV.TOP_ITEM_ID
							    AND DPS.MFG_DATE = MV.PLAN_DATE
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'BOM'	
					   AND MV.REFERENCE_TABLE = 'FP_WEEKLY_DEMAND_PRODUCT_SRS_H'
					   AND MV.PLAN_DATE = @v_date
					UNION ALL
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.SHIP_WEEK BETWEEN (SELECT WEEK
				  										  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														 WHERE DATE_ID = @v_date) 
												   AND (SELECT WEEK + 3
				  										  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														 WHERE DATE_ID = @v_date ) 
							   AND A.SCP_PLAN_ID = @v_dse_scp_plan_id) DSE
					         INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
							    ON DSE.COMPANY_ID = MV.COMPANY_ID
							  AND DSE.DIVISION_ID = MV.DIVISION_ID
							  AND DSE.SITE_ID = MV.SITE_ID
							  AND DSE.PLANT_ID = MV.PLANT_ID
							  AND DSE.ITEM_ID = MV.TOP_ITEM_ID
							  AND DSE.SHIP_DATE = MV.PLAN_DATE
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'BOM'
					   AND MV.REFERENCE_TABLE = 'FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H'
					   AND MV.PLAN_DATE = @v_date
					UNION ALL
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_TEST_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  										 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
												  AND (SELECT WEEK + 3
				  										 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														WHERE DATE_ID = @v_date ) 
								AND A.SCP_PLAN_ID = @v_dpt_scp_plan_id) DPTH
					          INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
							     ON DPTH.COMPANY_ID = MV.COMPANY_ID
							    AND DPTH.DIVISION_ID = MV.DIVISION_ID
							    AND DPTH.SITE_ID = MV.SITE_ID
							    AND DPTH.PLANT_ID = MV.PLANT_ID
							    AND DPTH.ITEM_ID = MV.TOP_ITEM_ID
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'BOM'
					   AND MV.REFERENCE_TABLE = 'FP_WEEKLY_DEMAND_PRODUCT_TEST_H'
					   AND MV.PLAN_DATE = @v_date
 				)A
		 GROUP BY A.COMPANY_ID,
		       A.DIVISION_ID,
		       A.SITE_ID,
		       A.PROBLEM_DATA;

		SET @v_temp2 = 'INSERT 003 KPI';
		INSERT INTO [DBO].[FP_KPI_RESULT_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[RESULT],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
			)
			SELECT '003', --[KPI_ID],
				   @v_date,--[KPI_DATE],
				   A.[COMPANY_ID],
				   A.[DIVISION_ID],
				   A.[SITE_ID],
				   '-', --[PLANT_ID],
				   '-', --[FACTORY_ID],
				   '-', --[OPERATION_ID],
				   '-', --[LINE_ID],
				   COUNT(SEQ) AS SEQ,
				   'SYSTEM',
				   GETDATE(),
				   'SYSTEM',
				   GETDATE() 
			  FROM ( SELECT COMPANY_ID, DIVISION_ID, SITE_ID
					   FROM DBO.SCM_PLANT_M  WITH(NOLOCK)
					  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID )  A
			  LEFT OUTER JOIN (SELECT *
							     FROM [DBO].[FP_KPI_RAW_DATA_R] WITH(NOLOCK)
							    WHERE [KPI_ID] = '003'
								  AND [KPI_DATE] = @v_date
								  AND [SITE_ID] = @P_SITE_ID
								  AND SEQ > 0 ) B
				ON A.COMPANY_ID = B.COMPANY_ID
			   AND A.DIVISION_ID = B.DIVISION_ID
			   AND A.SITE_ID = B.SITE_ID
             WHERE A.SITE_ID = @P_SITE_ID
		     GROUP BY [KPI_ID],
				      [KPI_DATE],
				      A.[COMPANY_ID],
				      A.[DIVISION_ID],
				      A.[SITE_ID]; 2019-09-27 kimcd 미사용지표 형성에서 제거*/




			-- FP 계획 수립 대상 수요부터 BOM 전개하여 BOM 미등록된 반제품, 제품 Item 개수 4주차 율
			--타이틀 등록
			/* 2019-09-27 kimcd 미사용지표 형성에서 제거
			SET @v_temp2 = 'INSERT 004 TITLE';
			INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[SEQ],
				[value1],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
			)VALUES(
				'004',
				@v_date,
				'-',
				'-',
				@P_SITE_ID,
				'-',
				'-',
				'-',
				'-',
				0,
				'Rate',
				'SYSTEM',
				GETDATE(),
				'SYSTEM',
				GETDATE()
			);

			SET @v_temp2 = 'INSERT 004 DATA';
			INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[SEQ],
				[value1],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
			)
			SELECT '004',
				   @v_date,
				   A.[COMPANY_ID],
				   A.[DIVISION_ID],
				   A.[SITE_ID],
				   '-',
				   '-',
				   '-',
				   '-',
				   ROW_NUMBER()OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID) AS SEQ,
				   CASE WHEN (SELECT COUNT(DISTINCT C.PARENT_ITEM_ID)
									FROM [dbo].[TH_BUF_SCM_BOM_VALIDATION_A] C  WITH(NOLOCK)
								   WHERE C.COMPANY_ID = A.[COMPANY_ID]
								     AND C.DIVISION_ID = A.[DIVISION_ID]
									 AND C.SITE_ID = A.SITE_ID
									 AND C.PARENT_ITEM_TYPE IN('P', 'H') ) = 0 THEN 0
							 ELSE
								convert(numeric(18,5), COUNT(SEQ) / (SELECT COUNT(DISTINCT C.PARENT_ITEM_ID)
																	   FROM [dbo].[TH_BUF_SCM_BOM_VALIDATION_A] C  WITH(NOLOCK)
																	  WHERE C.COMPANY_ID = A.[COMPANY_ID]
																		AND C.DIVISION_ID = A.[DIVISION_ID]
																		AND C.SITE_ID = A.SITE_ID
																		AND C.PARENT_ITEM_TYPE IN('P', 'H')) * 100)
							  END,
				   'SYSTEM',
				   GETDATE(),
				   'SYSTEM',
				   GETDATE() 
			  FROM ( SELECT COMPANY_ID, DIVISION_ID, SITE_ID
					   FROM DBO.SCM_PLANT_M  WITH(NOLOCK)
					  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID )A
		LEFT OUTER JOIN (SELECT *
						   FROM [DBO].[FP_KPI_RAW_DATA_R]  WITH(NOLOCK)
						  WHERE [KPI_ID] = '003'
							AND [KPI_DATE] = @v_date
							AND [SITE_ID] = @P_SITE_ID
							AND SEQ > 0 ) B
				ON A.COMPANY_ID = B.COMPANY_ID
			   AND A.DIVISION_ID = B.DIVISION_ID
			   AND A.SITE_ID = B.SITE_ID
             WHERE A.SITE_ID = @P_SITE_ID
		     GROUP BY [KPI_ID],
				   [KPI_DATE],
				   A.[COMPANY_ID],
				   A.[DIVISION_ID],
				   A.[SITE_ID];

			SET @v_temp2 = 'INSERT 004 KPI';
			INSERT INTO [DBO].[FP_KPI_RESULT_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[RESULT],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME])
			SELECT '004',
				   @v_date,
				   A.[COMPANY_ID],
				   A.[DIVISION_ID],
				   A.[SITE_ID],
				   '-', --[PLANT_ID],
				   '-',
				   '-',
				   '-',
				   CASE WHEN (SELECT COUNT(DISTINCT C.PARENT_ITEM_ID)
									FROM [dbo].[TH_BUF_SCM_BOM_VALIDATION_A] C  WITH(NOLOCK)
								   WHERE C.COMPANY_ID = A.[COMPANY_ID]
								     AND C.DIVISION_ID = A.[DIVISION_ID]
									 AND C.SITE_ID = A.SITE_ID
									 AND C.PARENT_ITEM_TYPE IN('P', 'H') ) = 0 THEN 0
							 ELSE
								convert(numeric(18,5), COUNT(SEQ) / (SELECT COUNT(DISTINCT C.PARENT_ITEM_ID)
																	   FROM [dbo].[TH_BUF_SCM_BOM_VALIDATION_A] C  WITH(NOLOCK)
																	  WHERE C.COMPANY_ID = A.[COMPANY_ID]
																		AND C.DIVISION_ID = A.[DIVISION_ID]
																		AND C.SITE_ID = A.SITE_ID
																		AND C.PARENT_ITEM_TYPE IN('P', 'H')) * 100)
							  END,
				   'SYSTEM',
				   GETDATE(),
				   'SYSTEM',
				   GETDATE() 
			  FROM ( SELECT COMPANY_ID, DIVISION_ID, SITE_ID
					   FROM DBO.SCM_PLANT_M  WITH(NOLOCK)
					  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID )  A
			  LEFT OUTER JOIN (SELECT *
							     FROM [DBO].[FP_KPI_RAW_DATA_R] WITH(NOLOCK)
							    WHERE [KPI_ID] = '003'
								  AND [KPI_DATE] = @v_date
								  AND [SITE_ID] = @P_SITE_ID
								  AND SEQ > 0 ) B
				ON A.COMPANY_ID = B.COMPANY_ID
			   AND A.DIVISION_ID = B.DIVISION_ID
			   AND A.SITE_ID = B.SITE_ID
             WHERE A.SITE_ID = @P_SITE_ID
		     GROUP BY [KPI_ID],
				      [KPI_DATE],
				      A.[COMPANY_ID],
				      A.[DIVISION_ID],
				      A.[SITE_ID]; 2019-09-27 kimcd 미사용지표 형성에서 제거 */

		-- FP 계획 수립 대상 수요부터 BOM 전개하여 Operation Flow 미등록된 반제품, 제품 Item 개수 
		-- 타이틀 입력
		/* 2019-09-27 kimcd 미사용지표 형성에서 제거
			SET @v_temp2 = 'INSERT 005 TITLE';
			INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[SEQ],
				[value1],
				[value2],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
			)VALUES(
				'005',
				@v_date,
				'-',
				'-',
				@P_SITE_ID,
				'-',
				'-',
				'-',
				'-',
				0,
				'Problem Item',
				'Min due Date',
				'SYSTEM',
				GETDATE(),
				'SYSTEM',
				GETDATE()
			);

			SET @v_temp2 = 'INSERT 005 DATA';			
			INSERT INTO [dbo].[FP_KPI_RAW_DATA_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				SEQ,
				[value1],
				[value2],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
			)
			SELECT '005',
				   @v_date,
				   A.COMPANY_ID,
				   A.DIVISION_ID,
				   A.SITE_ID,
				   '-',
				   '-',
				   '-',
				   '-',
				   ROW_NUMBER()OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROBLEM_DATA) AS SEQ,
				   A.PROBLEM_DATA,
				   MIN(FIRST_DUE_DATE) AS FIRST_DUE_DATE,
				   'SYSTEM',
				   GETDATE(),
				   'SYSTEM',
				   GETDATE() 
			 FROM (
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_H] A with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  										 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
												  AND (SELECT WEEK + 3
				  										 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
							   AND SCP_PLAN_ID = @v_dp_scp_plan_id) DP
						     INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
								ON DP.COMPANY_ID = MV.COMPANY_ID
							   AND DP.DIVISION_ID = MV.DIVISION_ID
							   AND DP.SITE_ID = MV.SITE_ID
							   AND DP.PLANT_ID = MV.PLANT_ID
							   AND DP.ITEM_ID = MV.TOP_ITEM_ID
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'OPERATION'	
					   AND MV.REFERENCE_TABLE = 'SCM_OPERATION_FLOW_M'
					   AND MV.PLAN_DATE = @v_date
					UNION ALL
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.SHIP_WEEK BETWEEN (SELECT WEEK
			  											  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														 WHERE DATE_ID = @v_date) 
												   AND (SELECT WEEK + 3
				  										  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														 WHERE DATE_ID = @v_date) 
							   AND SCP_PLAN_ID = @v_ds_scp_plan_id) DS
					         INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
							    ON DS.COMPANY_ID = MV.COMPANY_ID
							   AND DS.DIVISION_ID = MV.DIVISION_ID
							   AND DS.SITE_ID = MV.SITE_ID
							   AND DS.PLANT_ID = MV.PLANT_ID
							   AND DS.ITEM_ID = MV.TOP_ITEM_ID
							   AND DS.SHIP_DATE = MV.PLAN_DATE
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'OPERATION'	
					   AND MV.REFERENCE_TABLE = 'SCM_OPERATION_FLOW_M'
					UNION ALL
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_SRS_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  										 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
												  AND (SELECT WEEK + 3
				  										 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
													    WHERE DATE_ID = @v_date	) 
								AND SRS_PLAN_ID = @v_dp_srs_plan_id) DPS
					          INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
							     ON DPS.COMPANY_ID = MV.COMPANY_ID
							    AND DPS.DIVISION_ID = MV.DIVISION_ID
							    AND DPS.SITE_ID = MV.SITE_ID
							    AND DPS.PLANT_ID = MV.PLANT_ID
							    AND DPS.ITEM_ID = MV.TOP_ITEM_ID
							    AND DPS.MFG_DATE = MV.PLAN_DATE
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'OPERATION'	
					   AND MV.REFERENCE_TABLE = 'SCM_OPERATION_FLOW_M'
					   AND MV.PLAN_DATE = @v_date
					UNION ALL
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.SHIP_WEEK BETWEEN (SELECT WEEK
				  										  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														 WHERE DATE_ID = @v_date) 
												   AND (SELECT WEEK + 3
				  										  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														 WHERE DATE_ID = @v_date) 
							   AND A.SCP_PLAN_ID = @v_dse_scp_plan_id) DSE
					         INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
							    ON DSE.COMPANY_ID = MV.COMPANY_ID
							   AND DSE.DIVISION_ID = MV.DIVISION_ID
							   AND DSE.SITE_ID = MV.SITE_ID
							   AND DSE.PLANT_ID = MV.PLANT_ID
							   AND DSE.ITEM_ID = MV.TOP_ITEM_ID
							   AND DSE.SHIP_DATE = MV.PLAN_DATE
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'OPERATION'
					   AND MV.REFERENCE_TABLE = 'SCM_OPERATION_FLOW_M'
					   AND MV.PLAN_DATE = @v_date
					UNION ALL
					SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
					  FROM (SELECT *
							  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_TEST_H] A  with(nolock)
							 WHERE A.SITE_ID = @P_SITE_ID		
							   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  										 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
												  AND (SELECT WEEK + 3
				  										 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														WHERE DATE_ID = @v_date) 
							   AND A.SCP_PLAN_ID = @v_dpt_scp_plan_id) DPTH
					         INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
							    ON DPTH.COMPANY_ID = MV.COMPANY_ID
							   AND DPTH.DIVISION_ID = MV.DIVISION_ID
							   AND DPTH.SITE_ID = MV.SITE_ID
							   AND DPTH.PLANT_ID = MV.PLANT_ID
							   AND DPTH.ITEM_ID = MV.TOP_ITEM_ID
					 WHERE 1 = 1
					   AND MV.CHECK_CATEGORY = 'OPERATION'
					   AND MV.REFERENCE_TABLE = 'SCM_OPERATION_FLOW_M'
					   AND MV.PLAN_DATE = @v_date
 				)A
		  GROUP BY A.COMPANY_ID,
		        A.DIVISION_ID,
		        A.SITE_ID,
		        A.PROBLEM_DATA
		;

			SET @v_temp2 = 'INSERT 005 KPI';
			INSERT INTO [DBO].[FP_KPI_RESULT_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[RESULT],
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
			)
			SELECT '005', --[KPI_ID],
				   @v_date, -- [KPI_DATE],
				   A.[COMPANY_ID],
				   A.[DIVISION_ID],
				   A.[SITE_ID],
				   '-', --[PLANT_ID],
				   '-', --[FACTORY_ID],
				   '-', --[OPERATION_ID],
				   '-', --[LINE_ID],
				   COUNT(SEQ) AS SEQ,
				   'SYSTEM',
				   GETDATE(),
				   'SYSTEM',
				   GETDATE() 
			  FROM ( SELECT COMPANY_ID, DIVISION_ID, SITE_ID
					   FROM DBO.SCM_PLANT_M  WITH(NOLOCK)
					  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID )  A
			  LEFT OUTER JOIN (SELECT *
							     FROM [DBO].[FP_KPI_RAW_DATA_R] WITH(NOLOCK)
							    WHERE [KPI_ID] = '005'
								  AND [KPI_DATE] = @v_date
								  AND [SITE_ID] = @P_SITE_ID
								  AND SEQ > 0 ) B
				ON A.COMPANY_ID = B.COMPANY_ID
			   AND A.DIVISION_ID = B.DIVISION_ID
			   AND A.SITE_ID = B.SITE_ID
             WHERE A.SITE_ID = @P_SITE_ID
		     GROUP BY [KPI_ID],
				      [KPI_DATE],
				      A.[COMPANY_ID],
				      A.[DIVISION_ID],
				      A.[SITE_ID]; 2019-09-27 kimcd 미사용지표 형성에서 제거 */

			-- FP 계획 수립 대상 수요부터 BOM 전개하여 생산 가능 라인 미할당된 반제품, 제품 Item 개수 
			-- 타이틀 입력
			/* 2019-09-27 kimcd 미사용지표 형성에서 제거
				SET @v_temp2 = 'INSERT 006 TITLE';
				INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
					[KPI_ID],
					[KPI_DATE],
					[COMPANY_ID],
					[DIVISION_ID],
					[SITE_ID],
					[PLANT_ID],
					[FACTORY_ID],
					[OPERATION_ID],
					[LINE_ID],
					[SEQ],
					[value1],
					[value2],
					[INSERT_ID],
					[INSERT_TIME],
					[UPDATE_ID],
					[UPDATE_TIME]
				)VALUES(
					'006',
					@v_date,
					'-',
					'-',
					@P_SITE_ID,
					'-',
					'-',
					'-',
					'-',
					0,
					'PROBLEM ITEM',
					'Min due Date',
					'SYSTEM',
					GETDATE(),
					'SYSTEM',
					GETDATE()
				);

				SET @v_temp2 = 'INSERT 006 DATA';			
				INSERT INTO [dbo].[FP_KPI_RAW_DATA_R](
					[KPI_ID],
					[KPI_DATE],
					[COMPANY_ID],
					[DIVISION_ID],
					[SITE_ID],
					[PLANT_ID],
					[FACTORY_ID],
					[OPERATION_ID],
					[LINE_ID],
					SEQ,
					[value1],
					[value2],
					[INSERT_ID],
					[INSERT_TIME],
					[UPDATE_ID],
					[UPDATE_TIME]
				)
				SELECT '006',
						@v_date,
						A.COMPANY_ID,
						A.DIVISION_ID,
						A.SITE_ID,
						'-',
						'-',
						'-',
						'-',
						ROW_NUMBER()OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROBLEM_DATA) AS SEQ,
						A.PROBLEM_DATA,
						MIN(FIRST_DUE_DATE),
						'SYSTEM',
						GETDATE(),
						'SYSTEM',
						GETDATE() 
				   FROM (
						 SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
						   FROM (SELECT *
								   FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_H] A  with(nolock)
								  WHERE A.SITE_ID = @P_SITE_ID		
									AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  											  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															 WHERE DATE_ID = @v_date) 
													   AND (SELECT WEEK + 3
				  											  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															 WHERE DATE_ID = @v_date) 
									AND SCP_PLAN_ID = @v_dp_scp_plan_id) DP
							      INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
									 ON DP.COMPANY_ID = MV.COMPANY_ID
								    AND DP.DIVISION_ID = MV.DIVISION_ID
								    AND DP.SITE_ID = MV.SITE_ID
								    AND DP.PLANT_ID = MV.PLANT_ID
								    AND DP.ITEM_ID = MV.TOP_ITEM_ID
						  WHERE 1 = 1
						    AND MV.CHECK_CATEGORY = 'ITEM_LINE_ASSIGN'	
							AND MV.REFERENCE_TABLE = 'SCM_ITEM_LINE_ASSIGN_M'
						    AND MV.PLAN_DATE = @v_date
						UNION ALL
						SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
						  FROM (SELECT *
									FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_H] A  with(nolock)
								   WHERE A.SITE_ID = @P_SITE_ID		
									 AND A.SHIP_WEEK BETWEEN (SELECT WEEK
			  												    FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															   WHERE DATE_ID = @v_date) 
														 AND (SELECT WEEK + 3
				  												FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
																WHERE DATE_ID = @v_date) 
									AND SCP_PLAN_ID = @v_ds_scp_plan_id) DS
						          INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
								     ON DS.COMPANY_ID = MV.COMPANY_ID
								    AND DS.DIVISION_ID = MV.DIVISION_ID
								    AND DS.SITE_ID = MV.SITE_ID
								    AND DS.PLANT_ID = MV.PLANT_ID
								    AND DS.ITEM_ID = MV.TOP_ITEM_ID
								    AND DS.SHIP_DATE = MV.PLAN_DATE
						 WHERE 1 = 1
						   AND MV.CHECK_CATEGORY = 'ITEM_LINE_ASSIGN'	
						   AND MV.REFERENCE_TABLE = 'SCM_ITEM_LINE_ASSIGN_M'
						   AND MV.PLAN_DATE = @v_date
						 UNION ALL
						SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
						  FROM (SELECT *
								  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_SRS_H] A  with(nolock)
								 WHERE A.SITE_ID = @P_SITE_ID		
								   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  											 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														    WHERE DATE_ID = @v_date) 
													  AND (SELECT WEEK + 3
				  											 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															WHERE DATE_ID = @v_date ) 
								   AND SRS_PLAN_ID = @v_dp_srs_plan_id) DPS
						         INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
								    ON DPS.COMPANY_ID = MV.COMPANY_ID
								   AND DPS.DIVISION_ID = MV.DIVISION_ID
								   AND DPS.SITE_ID = MV.SITE_ID
								   AND DPS.PLANT_ID = MV.PLANT_ID
								   AND DPS.ITEM_ID = MV.TOP_ITEM_ID
								   AND DPS.MFG_DATE = MV.PLAN_DATE
						 WHERE 1 = 1
						   AND MV.CHECK_CATEGORY = 'ITEM_LINE_ASSIGN'	
						   AND MV.REFERENCE_TABLE = 'SCM_ITEM_LINE_ASSIGN_M'
						   AND MV.PLAN_DATE = @v_date
						 UNION ALL
						SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
						  FROM (SELECT *
								  FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] A  with(nolock)
								 WHERE A.SITE_ID = @P_SITE_ID		
								   AND A.SHIP_WEEK BETWEEN (SELECT WEEK
				  											  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															 WHERE DATE_ID = @v_date) 
													   AND (SELECT WEEK + 3
				  											  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															 WHERE DATE_ID = @v_date ) 
								   AND A.SCP_PLAN_ID = @v_dse_scp_plan_id) DSE
						         INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
								    ON DSE.COMPANY_ID = MV.COMPANY_ID
								   AND DSE.DIVISION_ID = MV.DIVISION_ID
								   AND DSE.SITE_ID = MV.SITE_ID
								   AND DSE.PLANT_ID = MV.PLANT_ID
								   AND DSE.ITEM_ID = MV.TOP_ITEM_ID
								   AND DSE.SHIP_DATE = MV.PLAN_DATE
						 WHERE 1 = 1
						   AND MV.CHECK_CATEGORY = 'ITEM_LINE_ASSIGN'
						   AND MV.REFERENCE_TABLE = 'SCM_ITEM_LINE_ASSIGN_M'
						   AND MV.PLAN_DATE = @v_date
						 UNION ALL
						SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
						  FROM (SELECT *
								  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_TEST_H] A  with(nolock)
								 WHERE A.SITE_ID = @P_SITE_ID		
								   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  											 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															WHERE DATE_ID = @v_date) 
													  AND (SELECT WEEK + 3
				  											 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															WHERE DATE_ID = @v_date ) 
								   AND A.SCP_PLAN_ID = @v_dpt_scp_plan_id) DPTH
						         INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
								    ON DPTH.COMPANY_ID = MV.COMPANY_ID
								   AND DPTH.DIVISION_ID = MV.DIVISION_ID
								   AND DPTH.SITE_ID = MV.SITE_ID
								   AND DPTH.PLANT_ID = MV.PLANT_ID
								   AND DPTH.ITEM_ID = MV.TOP_ITEM_ID
						 WHERE 1 = 1
						   AND MV.CHECK_CATEGORY = 'ITEM_LINE_ASSIGN'
						   AND MV.REFERENCE_TABLE = 'SCM_ITEM_LINE_ASSIGN_M'
						   AND MV.PLAN_DATE = @v_date
 					)A
			  GROUP BY A.COMPANY_ID,
		            A.DIVISION_ID,
		            A.SITE_ID,
		            A.PROBLEM_DATA;

			SET @v_temp2 = 'INSERT 006 KPI';
			 INSERT INTO [DBO].[FP_KPI_RESULT_R](
					[KPI_ID],
					[KPI_DATE],
					[COMPANY_ID],
					[DIVISION_ID],
					[SITE_ID],
					[PLANT_ID],
					[FACTORY_ID],
					[OPERATION_ID],
					[LINE_ID],
					[RESULT],
					[INSERT_ID],
					[INSERT_TIME],
					[UPDATE_ID],
					[UPDATE_TIME]
				)
			SELECT '006', --[KPI_ID],
				   @v_date, -- [KPI_DATE],
				   A.[COMPANY_ID],
				   A.[DIVISION_ID],
				   A.[SITE_ID],
				   '-', --[PLANT_ID],
				   '-', --[FACTORY_ID],
				   '-', --[OPERATION_ID],
				   '-', --[LINE_ID],
				   COUNT(SEQ) AS SEQ,
				   'SYSTEM',
				   GETDATE(),
				   'SYSTEM',
				   GETDATE() 
			  FROM ( SELECT COMPANY_ID, DIVISION_ID, SITE_ID
					   FROM DBO.SCM_PLANT_M  WITH(NOLOCK)
					  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID )  A
			  LEFT OUTER JOIN (SELECT *
							     FROM [DBO].[FP_KPI_RAW_DATA_R] WITH(NOLOCK)
							    WHERE [KPI_ID] = '006'
								  AND [KPI_DATE] = @v_date
								  AND [SITE_ID] = @P_SITE_ID
								  AND SEQ > 0 ) B
				ON A.COMPANY_ID = B.COMPANY_ID
			   AND A.DIVISION_ID = B.DIVISION_ID
			   AND A.SITE_ID = B.SITE_ID
             WHERE A.SITE_ID = @P_SITE_ID
		     GROUP BY [KPI_ID],
				      [KPI_DATE],
				      A.[COMPANY_ID],
				      A.[DIVISION_ID],
				      A.[SITE_ID]; 2019-09-27 kimcd 미사용지표 형성에서 제거 */


			-- FP 계획 수립 대상 수요부터 BOM 전개하여 생산 가능 Tact Time 미등록된 반제품, 제품 Item 개수 
			-- 타이틀 입력
			/* 2019-09-27 kimcd 미사용지표 형성에서 제거
				SET @v_temp2 = 'INSERT 007 TITLE';
				INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
					[KPI_ID],
					[KPI_DATE],
					[COMPANY_ID],
					[DIVISION_ID],
					[SITE_ID],
					[PLANT_ID],
					[FACTORY_ID],
					[OPERATION_ID],
					[LINE_ID],
					[SEQ],
					[value1],
					[value2],
					[INSERT_ID],
					[INSERT_TIME],
					[UPDATE_ID],
					[UPDATE_TIME]
				)VALUES(
					'007',
					@v_date,
					'-',
					'-',
					@P_SITE_ID,
					'-',
					'-',
					'-',
					'-',
					0,
					'PROBLEM ITEM',
					'Min due Date',
					'SYSTEM',
					GETDATE(),
					'SYSTEM',
					GETDATE()
				);
				SET @v_temp2 = 'INSERT 007 DATA';
				INSERT INTO [dbo].[FP_KPI_RAW_DATA_R](
					[KPI_ID],
					[KPI_DATE],
					[COMPANY_ID],
					[DIVISION_ID],
					[SITE_ID],
					[PLANT_ID],
					[FACTORY_ID],
					[OPERATION_ID],
					[LINE_ID],
					SEQ,
					[value1],
					[value2],
					[INSERT_ID],
					[INSERT_TIME],
					[UPDATE_ID],
					[UPDATE_TIME]
				)
				SELECT '007',
						@v_date,
						A.COMPANY_ID,
						A.DIVISION_ID,
						A.SITE_ID,
						'-',
						'-',
						'-',
						'-',
						ROW_NUMBER()OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PROBLEM_DATA) AS SEQ,
						A.PROBLEM_DATA,
						MIN(FIRST_DUE_DATE),
						'SYSTEM',
						GETDATE(),
						'SYSTEM',
						GETDATE() 
					FROM (
						SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
						  FROM (SELECT *
								  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_H] A  with(nolock)
								 WHERE A.SITE_ID = @P_SITE_ID		
								   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  											 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															WHERE DATE_ID = @v_date) 
													  AND (SELECT WEEK + 3
				  											 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															WHERE DATE_ID = @v_date) 
									AND SCP_PLAN_ID = @v_dp_scp_plan_id) DP
							      INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
									ON DP.COMPANY_ID = MV.COMPANY_ID
								   AND DP.DIVISION_ID = MV.DIVISION_ID
								   AND DP.SITE_ID = MV.SITE_ID
								   AND DP.PLANT_ID = MV.PLANT_ID
								   AND DP.ITEM_ID = MV.TOP_ITEM_ID
						 WHERE 1 = 1
						   AND MV.CHECK_CATEGORY = 'TACT-TIME'	
						   AND MV.REFERENCE_TABLE = 'SCM_TACT_TIME_M'
						   AND MV.PLAN_DATE = @v_date
						UNION ALL
						SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
						  FROM (SELECT *
								  FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_H] A  with(nolock)
								 WHERE A.SITE_ID = @P_SITE_ID		
								   AND A.SHIP_WEEK BETWEEN (SELECT WEEK
			  												  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															 WHERE DATE_ID = @v_date) 
													   AND (SELECT WEEK + 3
				  											  FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															 WHERE DATE_ID = @v_date) 
									AND SCP_PLAN_ID = @v_ds_scp_plan_id) DS
						          INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
								     ON DS.COMPANY_ID = MV.COMPANY_ID
									AND DS.DIVISION_ID = MV.DIVISION_ID
									AND DS.SITE_ID = MV.SITE_ID
									AND DS.PLANT_ID = MV.PLANT_ID
									AND DS.ITEM_ID = MV.TOP_ITEM_ID
									AND DS.SHIP_DATE = MV.PLAN_DATE
						 WHERE 1 = 1
						   AND MV.CHECK_CATEGORY = 'TACT-TIME'	
						   AND MV.REFERENCE_TABLE = 'SCM_TACT_TIME_M'
						   AND MV.PLAN_DATE = @v_date
						UNION ALL
						SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
						  FROM (SELECT *
								 FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_SRS_H] A  with(nolock)
								WHERE A.SITE_ID = @P_SITE_ID		
								  AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  										    FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														   WHERE DATE_ID = @v_date) 
													 AND (SELECT WEEK + 3
				  											FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														   WHERE DATE_ID = @v_date) 
								  AND SRS_PLAN_ID = @v_dp_srs_plan_id) DPS
						        INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
								   ON DPS.COMPANY_ID = MV.COMPANY_ID
								  AND DPS.DIVISION_ID = MV.DIVISION_ID
								  AND DPS.SITE_ID = MV.SITE_ID
								  AND DPS.PLANT_ID = MV.PLANT_ID
								  AND DPS.ITEM_ID = MV.TOP_ITEM_ID
								  AND DPS.MFG_DATE = MV.PLAN_DATE
						 WHERE 1 = 1
						   AND MV.CHECK_CATEGORY = 'TACT-TIME'	
						   AND MV.REFERENCE_TABLE = 'SCM_TACT_TIME_M'
						   AND MV.PLAN_DATE = @v_date
						UNION ALL
					   SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
						 FROM (SELECT *
								FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] A  with(nolock)
							   WHERE A.SITE_ID = @P_SITE_ID		
								 AND A.SHIP_WEEK BETWEEN (SELECT WEEK
				  											FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
														   WHERE DATE_ID = @v_date) 
													 AND (SELECT WEEK + 3
				  											FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															WHERE DATE_ID = @v_date ) 
								AND A.SCP_PLAN_ID = @v_dse_scp_plan_id) DSE
						      INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
								 ON DSE.COMPANY_ID = MV.COMPANY_ID
								AND DSE.DIVISION_ID = MV.DIVISION_ID
								AND DSE.SITE_ID = MV.SITE_ID
								AND DSE.PLANT_ID = MV.PLANT_ID
								AND DSE.ITEM_ID = MV.TOP_ITEM_ID
								AND DSE.SHIP_DATE = MV.PLAN_DATE
						 WHERE 1 = 1
						   AND MV.CHECK_CATEGORY = 'TACT-TIME'
						   AND MV.REFERENCE_TABLE = 'SCM_TACT_TIME_M'
						   AND MV.PLAN_DATE = @v_date
						UNION ALL
						SELECT MV.COMPANY_ID, MV.DIVISION_ID, MV.SITE_ID, MV.PLANT_ID, MV.PROBLEM_DATA, MV.PLAN_DATE AS FIRST_DUE_DATE
						  FROM (SELECT *
								  FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_TEST_H] A  with(nolock)
								 WHERE A.SITE_ID = @P_SITE_ID		
								   AND A.MFG_WEEK BETWEEN (SELECT WEEK
				  											 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															WHERE DATE_ID = @v_date) 
													  AND (SELECT WEEK + 3
				  											 FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
															WHERE DATE_ID = @v_date ) 
									AND A.SCP_PLAN_ID = @v_dpt_scp_plan_id) DPTH
						          INNER JOIN [DBO].FP_MASTER_VALIDATION_H MV  with(nolock)
								     ON DPTH.COMPANY_ID = MV.COMPANY_ID
									AND DPTH.DIVISION_ID = MV.DIVISION_ID
									AND DPTH.SITE_ID = MV.SITE_ID
									AND DPTH.PLANT_ID = MV.PLANT_ID
									AND DPTH.ITEM_ID = MV.TOP_ITEM_ID
					     WHERE 1 = 1
						   AND MV.CHECK_CATEGORY = 'TACT-TIME'
						   AND MV.REFERENCE_TABLE = 'SCM_TACT_TIME_M'
						   AND MV.PLAN_DATE = @v_date
 					)A
			  GROUP BY COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PROBLEM_DATA
			;

				SET @v_temp2 = 'INSERT 007 KPI';
				INSERT INTO [DBO].[FP_KPI_RESULT_R](
					[KPI_ID],
					[KPI_DATE],
					[COMPANY_ID],
					[DIVISION_ID],
					[SITE_ID],
					[PLANT_ID],
					[FACTORY_ID],
					[OPERATION_ID],
					[LINE_ID],
					[RESULT],
					[INSERT_ID],
					[INSERT_TIME],
					[UPDATE_ID],
					[UPDATE_TIME]
				)
			SELECT '007', --[KPI_ID],
				   @v_date, -- [KPI_DATE],
				   A.[COMPANY_ID],
				   A.[DIVISION_ID],
				   A.[SITE_ID],
				   '-', --[PLANT_ID],
				   '-', --[FACTORY_ID],
				   '-', --[OPERATION_ID],
				   '-', --[LINE_ID],
				   COUNT(SEQ) AS SEQ,
				   'SYSTEM',
				   GETDATE(),
				   'SYSTEM',
				   GETDATE() 
			  FROM ( SELECT COMPANY_ID, DIVISION_ID, SITE_ID
					   FROM DBO.SCM_PLANT_M  WITH(NOLOCK)
					  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID )  A
			  LEFT OUTER JOIN (SELECT *
							     FROM [DBO].[FP_KPI_RAW_DATA_R] WITH(NOLOCK)
							    WHERE [KPI_ID] = '007'
								  AND [KPI_DATE] = @v_date
								  AND [SITE_ID] = @P_SITE_ID
								  AND SEQ > 0 ) B
				ON A.COMPANY_ID = B.COMPANY_ID
			   AND A.DIVISION_ID = B.DIVISION_ID
			   AND A.SITE_ID = B.SITE_ID
             WHERE A.SITE_ID = @P_SITE_ID
		     GROUP BY [KPI_ID],
				      [KPI_DATE],
				      A.[COMPANY_ID],
				      A.[DIVISION_ID],
				      A.[SITE_ID]; 2019-09-27 kimcd 미사용지표 형성에서 제거 */


			-- 계획 수립 후 확정 작업에 의해 MES로 전송되는 상세 WO, MO의 건수
			-- 타이틀 입력
			/* 2019-09-27 kimcd 미사용지표 형성에서 제거
			    SET @v_temp2 = 'INSERT 008 TITLE';
				INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
					[KPI_ID],
					[KPI_DATE],
					[COMPANY_ID],
					[DIVISION_ID],
					[SITE_ID],
					[PLANT_ID],
					[FACTORY_ID],
					[OPERATION_ID],
					[LINE_ID],
					[SEQ],
					[value1],
					[value2],
					[value3],
					[value4],
					[value5],
					[INSERT_ID],
					[INSERT_TIME],
					[UPDATE_ID],
					[UPDATE_TIME]
				)VALUES(
					'008',
					@v_ydate,
					'-',
					'-',
					@P_SITE_ID,
					'-',
					'-',
					'-',
					'-',
					0,
					'Work Order', 
					'Line', 
					'Start Time', 
					'End Time', 
					'plan Out qty',
					'SYSTEM',
					GETDATE(),
					'SYSTEM',
					GETDATE()
				);

				
						-- WO, MO 수
						SET @v_temp2 = 'INSERT 008 DATA';
						INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
							[KPI_ID],
							[KPI_DATE],
							[COMPANY_ID],
							[DIVISION_ID],
							[SITE_ID],
							[PLANT_ID],
							[FACTORY_ID],
							[OPERATION_ID],
							[LINE_ID],
							[SEQ],
							[value1],
							[value2],
							[value3],
							[value4],
							[value5],
							[INSERT_ID],
							[INSERT_TIME],
							[UPDATE_ID],
							[UPDATE_TIME]
						 )
						 SELECT '008',
								@v_ydate,
								COMPANY_ID,
								DIVISION_ID,
								SITE_ID,
								PLANT_ID,
								FACTORY_ID,
								OPERATION_ID,
								LINE_ID,
								ROW_NUMBER()OVER(ORDER BY COMPANY_ID) AS SEQ,
								WORK_ORDER_ID,
								LINE_ID,
								MIN(START_TIME) AS START_TIME,
								MAX(END_TIME) AS END_TIME,
								SUM(OUT_QTY) AS OUT_QTY,
								'SYSTEM',
								GETDATE(),
								'SYSTEM',
								GETDATE()
						   FROM (SELECT SOURCES.COMPANY_ID
										, SOURCES.DIVISION_ID
										, SOURCES.SITE_ID
										, SOURCES.PLANT_ID
										, SOURCES.FACTORY_ID
										, SOURCES.OPERATION_ID
										, SOURCES.WORK_ORDER_ID
										, SOURCES.LINE_ID
										, SOURCES.START_TIME
										, SOURCES.END_TIME
										, SOURCES.PLAN_QTY /* 2018-12-17 kimcd 실적 조회문장 제거 + (SELECT ISNULL( SUM(ISNULL(WIPQTY2_ED,0))
																			+ SUM(ISNULL(CONVERT(NUMERIC(14,3), CNFM_DFCT_QTY2),0)) 
																			+ SUM(ISNULL(CONVERT(NUMERIC(14,3), CNFM_LOSS_QTY2),0)) 
																			+ SUM(ISNULL(CONVERT(NUMERIC(14,3), CNFM_PRDT_REQ_QTY2),0))
																			+ SUM(ISNULL(CAST( SCRAP_QTY AS NUMERIC(14,3)),0))
																		,0)
														        FROM [dbo].[SCM_MES_WIP_HISTORY_H]  WITH(NOLOCK)
													           WHERE WOID = SOURCES.WORK_ORDER_ID
														         AND WO_DETL_ID = SOURCES.WORK_ORDER_SPL_ID
														         AND PRODID     = SOURCES.ITEM_ID) */ AS OUT_QTY
								   FROM FP_PRODUCTION_PLAN_EQUIPMENT_R SOURCES  with(nolock)
								  INNER JOIN ( SELECT RELEASE_PLAN_ID, FACTORY_ID
												FROM ( SELECT D.FACTORY_ID
															  , RELEASE_PLAN_ID 
															  , ROW_NUMBER() OVER(PARTITION BY D.DIVISION_ID, D.FACTORY_ID, D.INSTANCE_ID ORDER BY D.DIVISION_ID, D.FACTORY_ID, D.INSTANCE_ID, D.RELEASE_TIME DESC) AS REL_CNT
													     FROM SCM_FP_PLAN_H        W WITH(NOLOCK)
														      ,SCM_FP_PLAN_DETAIL_H D WITH(NOLOCK)
												        WHERE W.PLAN_ID =D.RELEASE_PLAN_ID
													      AND W.PLAN_TYPE = 'RELEASE'
														  AND W.SITE_ID = @P_SITE_ID
--													      AND W.INSTANCE_ID = @v_instance_id
													      AND D.RELEASE_FLAG = 'Y'
														  AND D.RELEASE_TIME BETWEEN DATEADD(DAY, -1, CONVERT(DATE, GETDATE()))
															                     AND DATEADD(DAY, 0, CONVERT(DATE, GETDATE())) 
													 )A
											   WHERE REL_CNT = 1
											 ) B
								     ON SOURCES.FP_PLAN_ID = B.RELEASE_PLAN_ID
								    AND SOURCES.FACTORY_ID = B.FACTORY_ID
									AND SOURCES.ORDER_TYPE IN ('W', 'M')
									AND SOURCES.FIX_TYPE = 'N'
									AND SOURCES.SITE_ID = @P_SITE_ID
								
							   )A
					     GROUP BY COMPANY_ID
							   , DIVISION_ID
							   , SITE_ID
							   , PLANT_ID
							   , FACTORY_ID
							   , OPERATION_ID
							   , WORK_ORDER_ID
							   , LINE_ID 2019-09-27 kimcd 미사용지표 형성에서 제거 */
										
            /* 2018-09-04 kimcd 3일 fix 준수율 생산 계획 달성율, 생산 계획 준수율 전면 재개발 시작 */
			-- 2018-10-10 3일 fix 재구성 시작
			-- 3일 Fix준수율
			/* 2019-12-06 3일 Fix 준수율 전면 재개발 기존 로직 주석 처리
			SET @THREE_FIX_DATE = DATEADD(DD,-3, CONVERT(DATE, @v_date, 120))
			SET @v_temp2 = 'UPDATE OLD DATA-BASE INFO 009';
			UPDATE [DBO].[FP_KPI_RAW_DATA_R]
			SET    VALUE1 = NULL, VALUE6 = NULL, VALUE7 = NULL, VALUE8 = NULL, VALUE9 = NULL, UPDATE_TIME = GETDATE() -- 2018-11-12 kimcd VALUE9 - 선행 품목 추가 -- VALUE8 PROD_TYPE_GROUP 2018-10-12 kimcd 추가
			WHERE  KPI_ID   = '009'
			AND    KPI_DATE = @THREE_FIX_DATE
			AND    SITE_ID  = @P_SITE_ID
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
			AND    PLANT_ID IN ( SELECT V.SEGMENT1
								 FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
								 WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
								 AND    V.ACTIVE_FLAG      = 'Y'
								 AND    V.SEGMENT2         = @BASIS_START_TIME
								 )
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝

			SET @v_temp2 = 'INSERT 009 DATA'
			MERGE  INTO [DBO].[FP_KPI_RAW_DATA_R] A
			USING ( SELECT [COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[CUTOFF_DATE]
							,[ITEM_ID]
							,[OPERATION_ID]
							,[LINE_ID]
							,[PLAN_DATE]
							,[FP_PRODUCTION_TYPE]
							,[PLAN_QTY]
							, (SELECT TOP 1 B.LINE_NAME
								FROM   SCM_LINE_M B WITH(NOLOCK)
								WHERE  B.COMPANY_ID   = A.COMPANY_ID
								AND    B.SITE_ID      = A.SITE_ID
								AND    B.DIVISION_ID  = A.DIVISION_ID
								AND    B.PLANT_ID     = A.PLANT_ID
								AND    B.FACTORY_ID   = A.FACTORY_ID
								AND    B.OPERATION_ID = A.OPERATION_ID
								AND    B.LINE_ID      = A.LINE_ID) AS LINE_NAME
							,CASE WHEN A.[FP_PRODUCTION_TYPE] IN ('MASS','M-SAMPLE','SPECIAL') THEN 'MASS' ELSE 'Sample/Dev/Test' END AS PROD_TYPE_GROUP -- 2018-10-12 kimcd 추가 2019-01-21 kimcd MASS에 SPECIAL 추가
					  		,1  -- 2019-03-25 kimcd SEQ 제거 ROW_NUMBER()  OVER ( PARTITION BY [CUTOFF_DATE],	[SITE_ID],	[FACTORY_ID], [OPERATION_ID], [LINE_ID], [PLAN_DATE]
								--				ORDER BY START_TIME, ITEM_ID, FP_PRODUCTION_TYPE)
								AS SEQ 
							,'-' -- 2019-04-02 kimcd 선행 품목 제거 LAG(A.ITEM_ID, 1, '-')  OVER ( PARTITION BY [CUTOFF_DATE],	[SITE_ID],	[FACTORY_ID], [OPERATION_ID], [LINE_ID], [PLAN_DATE]
								 --				ORDER BY START_TIME, ITEM_ID, FP_PRODUCTION_TYPE) 
								 AS PRIOR_ITEM -- 2018-11-12 kimcd VALUE9 - 선행 품목 추가
					FROM (SELECT MAX([COMPANY_ID])  AS COMPANY_ID
								,MAX([DIVISION_ID]) AS DIVISION_ID
								,[SITE_ID]
								,MAX([PLANT_ID])    AS PLANT_ID
								,[FACTORY_ID]
								,[CUTOFF_DATE]
								,[ITEM_ID]
								,[OPERATION_ID]
								,[LINE_ID]
								,[PLAN_DATE]
								,ISNULL([FP_PRODUCTION_TYPE], [PRODUCTION_TYPE]) AS FP_PRODUCTION_TYPE
								,SUM([PLAN_QTY])    AS PLAN_QTY
								,MIN([START_TIME])  AS START_TIME
							FROM [DBO].[FP_KPI_DAILY_PRODUCTION_PLAN_H] A WITH(NOLOCK)
							WHERE [SITE_ID] = @P_SITE_ID
							AND   [CUTOFF_DATE] >= @THREE_FIX_DATE
							AND   [CUTOFF_DATE] <= DATEADD(DD, 2, @THREE_FIX_DATE)
							AND   [PLAN_DATE]  >= @THREE_FIX_DATE
							AND   [PLAN_DATE]  <= DATEADD(DD, 2, @THREE_FIX_DATE)
							AND   [PLAN_TYPE]   = '3DAY_FIX'
							AND   [OPERATION_ID] IN ('A3000','A9000','E2000','P5500','P9500')
							-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
							AND    PLANT_ID IN ( SELECT V.SEGMENT1
												 FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
												 WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
												 AND    V.ACTIVE_FLAG      = 'Y'
												 AND    V.SEGMENT2         = @BASIS_START_TIME
												 )
							-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
							AND   [FACTORY_ID] NOT IN  (SELECT SV.SEGMENT1 
														FROM   [SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
														WHERE  SV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
														AND    SV.ACTIVE_FLAG = 'Y' ) -- 2018-12-18 kimcd setup 진행 중인 공장 KPI 대상 제외
							AND   NOT EXISTS ( SELECT 1 
											   FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
											   WHERE  SV.LOOKUP_TYPE_CODE = 'PILOT_LINE'
											   AND    SV.SEGMENT1    = A.FACTORY_ID
											   AND    SV.SEGMENT2    = A.LINE_ID
											   AND    SV.SEGMENT3    = A.OPERATION_ID
											   AND    SV.ACTIVE_FLAG = 'Y'
											   AND    SV.ATTRIBUTE1  = 'N')  -- 2018-11-12 kimcd 개발 pilot line 제거
							GROUP BY [CUTOFF_DATE],	[SITE_ID],	[FACTORY_ID], [OPERATION_ID], [LINE_ID], [PLAN_DATE],[ITEM_ID], ISNULL([FP_PRODUCTION_TYPE], [PRODUCTION_TYPE]) ) A )  B
			ON ( A.KPI_ID   = '009'
			AND  A.KPI_DATE = @THREE_FIX_DATE
			AND  A.SITE_ID  = @P_SITE_ID
			AND  A.SITE_ID  = B.SITE_ID
			AND  A.PLANT_ID     = B.PLANT_ID
			AND  A.FACTORY_ID   = B.FACTORY_ID
			AND  A.OPERATION_ID = B.OPERATION_ID
			AND  A.LINE_ID      = B.LINE_ID
			AND  A.VALUE2       = B.[FP_PRODUCTION_TYPE]
			AND  A.VALUE3       = B.[ITEM_ID]
			AND  A.VALUE4       = CONVERT( NVARCHAR(10), B.[CUTOFF_DATE], 120)
			AND  A.VALUE5       = CONVERT( NVARCHAR(10), B.[PLAN_DATE], 120) )
			WHEN MATCHED THEN 
				UPDATE
				SET A.VALUE1      = B.LINE_NAME,
					A.VALUE6      = B.PLAN_QTY,  -- plan qty
					A.VALUE7      = B.SEQ,       -- seq
					A.VALUE8      = B.PROD_TYPE_GROUP, -- 2018-10-12 kimcd 추가
					A.VALUE9      = B.PRIOR_ITEM, -- 2018-11-12 kimcd VALUE9 - 선행 품목 추가
					A.UPDATE_TIME = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT ([KPI_ID],       --  KPI 지표 구분 ID - 3일 Fix 준수율 - 009
						[KPI_DATE],     --  KPI 지표 집계 일자 - 3DAY_FIX_DATE
						[COMPANY_ID],   --  법인 코드
						[DIVISION_ID],  --  사업부 코드
						[SITE_ID],      --  법인 Site 코드
						[PLANT_ID],     --  공장 구분 코드
						[FACTORY_ID],   --  공장 동 코드
						[OPERATION_ID], --  공정 코드
						[LINE_ID],      --  FP 라인 코드
						[SEQ],          --  정보 일련번호 - 일, 법인 단위 Sequence
						[VALUE1],       --  3일 Fix 준수율 - LINE NAME
						[VALUE2],       --  3일 Fix 준수율 - Prod Type
						[VALUE3],       --  3일 Fix 준수율 - Item ID
						[VALUE4],       --  3일 Fix 준수율 - plan make date
						[VALUE5],       --  3일 Fix 준수율 - plan date
						[VALUE6],       --  3일 Fix 준수율 - plan qty
						[VALUE7],       --  3일 Fix 준수율 - seq
						[VALUE8],       --  3일 Fix 준수율 - PROD TYPE GROUP
						[VALUE9],       --  2018-11-12 kimcd VALUE9 - 선행 품목 추가
						[INSERT_ID],
						[INSERT_TIME],
						[UPDATE_ID],
						[UPDATE_TIME]
						)
				VALUES ( '009'
						,@THREE_FIX_DATE
						,B.COMPANY_ID
						,B.DIVISION_ID
						,B.SITE_ID
						,B.PLANT_ID
						,B.FACTORY_ID
						,B.OPERATION_ID
						,B.LINE_ID
						,B.SEQ
						,B.LINE_NAME
						,B.FP_PRODUCTION_TYPE
						,B.ITEM_ID
						,CONVERT( NVARCHAR(10), B.[CUTOFF_DATE], 120)
						,CONVERT( NVARCHAR(10), B.[PLAN_DATE], 120)
						,B.PLAN_QTY
						,B.SEQ
						,B.PROD_TYPE_GROUP -- 2018-10-12 kimcd 추가
						,B.PRIOR_ITEM -- 2018-11-12 kimcd VALUE9 - 선행 품목 추가
						,@v_proc_name
						,GETDATE() -- INSERT_TIME
						,@v_proc_name
						,GETDATE() -- UPDATE_TIME
						);
			-- 2018-10-10 3일 fix 재구성 끝
			*/
			-- 2019-12-06 kimcd 3일 Fix 준수율 재개발 시작
			-- D-2일 계획과 D-0일의 계획을 Building, Model, Order Type 기준으로 비교하여 큰 값을 분모, 작은 값을 분자로 하여 
			-- 단순 합계를 비율로 구한다.
			SET @THREE_FIX_DATE = @v_ydate; -- 어제 일자 지표를 형성한다
			SET @v_temp2 = 'UPDATE OLD DATA-BASE INFO 009';
			DELETE [DBO].[FP_KPI_RAW_DATA_R]
			WHERE  KPI_ID   = '009'
			AND    KPI_DATE = @THREE_FIX_DATE
			AND    SITE_ID  = @P_SITE_ID
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
			AND    PLANT_ID IN ( SELECT V.SEGMENT1
								 FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
								 WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
								 AND    V.ACTIVE_FLAG      = 'Y'
								 AND    V.SEGMENT2         = @BASIS_START_TIME
								 )
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝

			SET @v_temp2 = 'INSERT 009 DATA'
			MERGE  INTO [DBO].[FP_KPI_RAW_DATA_R] A
			USING ( SELECT MAX([COMPANY_ID])    AS COMPANY_ID
							,ISNULL( (SELECT TOP 1 PD.[ORIGINAL_DIVISION_ID] FROM [DBO].[SCM_PSEUDO_DIVISION_M] AS PD (NOLOCK) WHERE PD.[PLANT_ID] = MAX(A.[PLANT_ID])), MAX([DIVISION_ID])) AS DIVISION_ID --2022-03-20 kimcd 가상 Division 전환
							,[SITE_ID]
							,MAX([PLANT_ID])    AS PLANT_ID
							,[FACTORY_ID]
							,[ITEM_ID]
							,[OPERATION_ID]
							,[PLAN_DATE]
							,[FP_PRODUCTION_TYPE]
							,MAX(CASE WHEN [CUTOFF_DATE] = DATEADD(DD, -2, @THREE_FIX_DATE) THEN [PLAN_QTY] END)  AS D_2_QTY
							,MAX(CASE WHEN [CUTOFF_DATE] = @THREE_FIX_DATE THEN [PLAN_QTY] END)  AS D_QTY
							,CASE WHEN ISNULL(MIN(CASE WHEN [CUTOFF_DATE] = DATEADD(DD, -2, @THREE_FIX_DATE) THEN [PLAN_QTY] END),0) > ISNULL(MIN(CASE WHEN [CUTOFF_DATE] = @THREE_FIX_DATE THEN [PLAN_QTY] END),0) THEN
							     ISNULL(MIN(CASE WHEN [CUTOFF_DATE] = @THREE_FIX_DATE THEN [PLAN_QTY] END),0)
							 ELSE
							     ISNULL(MIN(CASE WHEN [CUTOFF_DATE] = DATEADD(DD, -2, @THREE_FIX_DATE) THEN [PLAN_QTY] END),0)
							 END                AS NUMERATOR
							,MAX([PLAN_QTY])    AS DENOMINATOR
							,CASE WHEN A.[FP_PRODUCTION_TYPE] IN ('MASS','M-SAMPLE','SPECIAL', 'C-MASS', 'D-MASS') THEN 'MASS' ELSE 'Sample/Dev/Test' END AS PROD_TYPE_GROUP  -- 2020-06-26 kimcd C-MASS D-MASS를 MASS 구분 항목에 포함
					FROM (SELECT MAX([COMPANY_ID])  AS COMPANY_ID
								,MAX([DIVISION_ID]) AS DIVISION_ID
								,[SITE_ID]
								,MAX([PLANT_ID])    AS PLANT_ID
								,[FACTORY_ID]
								,[CUTOFF_DATE]
								,[ITEM_ID]
								,[OPERATION_ID]
								,[PLAN_DATE]
								,ISNULL([FP_PRODUCTION_TYPE], [PRODUCTION_TYPE]) AS FP_PRODUCTION_TYPE
								,SUM([PLAN_QTY])    AS PLAN_QTY
							FROM [DBO].[FP_KPI_DAILY_PRODUCTION_PLAN_H] A WITH(NOLOCK)
							WHERE [SITE_ID] = @P_SITE_ID
							AND   ( [CUTOFF_DATE] = @THREE_FIX_DATE OR [CUTOFF_DATE] = DATEADD(DD, -2, @THREE_FIX_DATE) )
							AND   [PLAN_DATE]   = @THREE_FIX_DATE
							AND   [PLAN_TYPE]   = '3DAY_FIX'
							AND   [OPERATION_ID] IN ('A3000','A9000','E2000','P5500','P9500')
							-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
							AND    PLANT_ID IN ( SELECT V.SEGMENT1
												 FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
												 WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
												 AND    V.ACTIVE_FLAG      = 'Y'
												 AND    V.SEGMENT2         = @BASIS_START_TIME
												 )
							-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
							AND   [FACTORY_ID] NOT IN  (SELECT SV.SEGMENT1 
														FROM   [SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
														WHERE  SV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
														AND    SV.ACTIVE_FLAG = 'Y' ) -- 2018-12-18 kimcd setup 진행 중인 공장 KPI 대상 제외
							AND   NOT EXISTS ( SELECT 1 
											   FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
											   WHERE  SV.LOOKUP_TYPE_CODE = 'PILOT_LINE'
											   AND    SV.SEGMENT1    = A.FACTORY_ID
											   AND    SV.SEGMENT2    = A.LINE_ID
											   AND    SV.SEGMENT3    = A.OPERATION_ID
											   AND    SV.ACTIVE_FLAG = 'Y'
											   AND    SV.ATTRIBUTE1  = 'N')  -- 2018-11-12 kimcd 개발 pilot line 제거
							GROUP BY [CUTOFF_DATE],	[SITE_ID],	[FACTORY_ID], [OPERATION_ID], [PLAN_DATE],[ITEM_ID], ISNULL([FP_PRODUCTION_TYPE], [PRODUCTION_TYPE]) ) A
					GROUP BY  [SITE_ID], [FACTORY_ID], [OPERATION_ID], [PLAN_DATE],[ITEM_ID], [FP_PRODUCTION_TYPE] )  B
			ON ( A.KPI_ID   = '009'
			AND  A.KPI_DATE = @THREE_FIX_DATE
			AND  A.SITE_ID  = @P_SITE_ID
			AND  A.SITE_ID  = B.SITE_ID
			AND  A.PLANT_ID     = B.PLANT_ID
			AND  A.FACTORY_ID   = B.FACTORY_ID
			AND  A.OPERATION_ID = B.OPERATION_ID
			AND  A.VALUE2       = B.[FP_PRODUCTION_TYPE]
			AND  A.VALUE3       = B.[ITEM_ID])
			WHEN MATCHED THEN 
				UPDATE
				SET A.VALUE4      = B.D_2_QTY,      -- D-2일 계획 수량
				    A.VALUE5      = B.D_QTY,        -- D일 계획 수량
				    A.VALUE6      = B.NUMERATOR,    -- 분자
					A.VALUE7      = B.DENOMINATOR,  -- 분모
					A.VALUE8      = B.PROD_TYPE_GROUP, -- 2018-10-12 kimcd 추가
					A.UPDATE_TIME = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT ([KPI_ID],       --  KPI 지표 구분 ID - 3일 Fix 준수율 - 009
						[KPI_DATE],     --  KPI 지표 집계 일자 - 3DAY_FIX_DATE
						[COMPANY_ID],   --  법인 코드
						[DIVISION_ID],  --  사업부 코드
						[SITE_ID],      --  법인 Site 코드
						[PLANT_ID],     --  공장 구분 코드
						[FACTORY_ID],   --  공장 동 코드
						[OPERATION_ID], --  공정 코드
						[LINE_ID],      --  FP 라인 코드
						[SEQ],          --  정보 일련번호 - 일, 법인 단위 Sequence
						[VALUE2],       --  3일 Fix 준수율 - Prod Type
						[VALUE3],       --  3일 Fix 준수율 - Item ID
						[VALUE4],       --  D-2일 계획 수량
						[VALUE5],       --  D일 계획 수량
						[VALUE6],       --  3일 Fix 준수율 - 분자  NUMERATOR
						[VALUE7],       --  3일 Fix 준수율 - 분모  DENOMINATOR
						[VALUE8],       --  3일 Fix 준수율 - PROD TYPE GROUP
						[INSERT_ID],
						[INSERT_TIME],
						[UPDATE_ID],
						[UPDATE_TIME]
						)
				VALUES ( '009'
						,@THREE_FIX_DATE
						,B.COMPANY_ID
						,B.DIVISION_ID
						,B.SITE_ID
						,B.PLANT_ID
						,B.FACTORY_ID
						,B.OPERATION_ID
						,'-'  -- LINE_ID
						,1    -- SEQ
						,B.FP_PRODUCTION_TYPE
						,B.ITEM_ID
						,B.D_2_QTY      -- D-2일 계획 수량
						,B.D_QTY        -- D일 계획 수량
						,B.NUMERATOR
						,B.DENOMINATOR
						,B.PROD_TYPE_GROUP -- 2018-10-12 kimcd 추가
						,@v_proc_name
						,GETDATE() -- INSERT_TIME
						,@v_proc_name
						,GETDATE() -- UPDATE_TIME
						);
            -- 2019-12-06 kimcd 3일 Fix 준수율 재개발 끝

			-- 생산계획달성율
			-- 2018-10-08 KPI 달성율 재구성 시작
			-- KPI_ID        : KPI 지표 구분 ID - 생산 계획 달성율 - 010
			-- KPI_DATE      : KPI 지표 일자 Plan Date
			-- COMPANY_ID    : 법인 코드
			-- DIVISION_ID   : 사업부 코드
			-- SITE_ID	법인 : Site 코드
			-- PLANT_ID      : 공장 구분 코드
			-- FACTORY_ID    : 공장 동 코드
			-- OPERATION_ID  : 공정 코드
			-- LINE_ID       : FP 라인 코드
			-- SEQ	정보     : 일련번호 - 일, 법인 단위 Sequence
			-- VALUE1        : 생산 계획 달성율 : 공정 Shop 구분자
			-- VALUE2        : 생산 계획 달성율 : Nick Name
			-- VALUE3        : 생산 계획 달성율 : Material Code
			-- VALUE4        : 생산 계획 달성율 : Prod Type
			-- VALUE5        : 생산 계획 달성율 : 분자 값 Result
			-- VALUE6        : 생산 계획 달성율 : 분모 값 Plan
			-- VALUE7        : 생산 계획 달성율 : FP 주차 plan week
			-- VALUE8        : 생산 계획 달성율 : FP 월 plan month
			-- VALUE9        : 생산 계획 달성율 : Plan Type - MPP WPP
			-- VALUE10       : FP 라인 명
			-- VALUE11       : PROD_TYPE_GROUP -- 2018-10-12 kimcd 추가

			DECLARE CUR_MPP CURSOR FOR
				SELECT CONVERT(NVARCHAR(6), CONVERT(DATE, @v_date, 120), 112)   AS MPP_MONTH
				UNION
				SELECT TOP 1 CONVERT(NVARCHAR(6),DATEADD(D,-DAY(@v_date),@v_date),112)
				FROM   SCM_SITE_M WITH(NOLOCK)
				WHERE  SITE_ID = @P_SITE_ID
				AND    EXISTS ( SELECT 1 FROM  [SCM_DAILY_PRODUCT_RESULT_H]  A WITH(NOLOCK)
								WHERE A.SITE_ID = @P_SITE_ID
								AND   A.PLAN_DATE >= DATEADD(M,-1, DATEADD(D,-DAY(@v_date)+1,@v_date))
								AND   A.PLAN_DATE <= DATEADD(D,-DAY(GETDATE()),GETDATE())
								AND   A.[UPDATE_TIME] >= DATEADD(D,-2,@v_date)
				                UNION
								SELECT 1 FROM  [FP_DAILY_PRODUCTIOIN_PLAN_H] A WITH(NOLOCK)
								WHERE A.SITE_ID = @P_SITE_ID
								AND   A.PLAN_DATE >= DATEADD(M,-1, DATEADD(D,-DAY(@v_date)+1,@v_date))
								AND   A.PLAN_DATE <= DATEADD(D,-DAY(GETDATE()),GETDATE())
								AND   A.PLAN_TYPE = 'WPP' -- 2018-12-04 kimcd 월 기준 달성율 기준 계획을 WPP로 변경
								AND   A.[UPDATE_TIME] >= DATEADD(D,-2,@v_date) ) ;

			OPEN CUR_MPP;
			FETCH NEXT FROM CUR_MPP INTO @MPP_MONTH;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN		
					SET @v_temp2 = 'UPDATE OLD DATA-BASE INFO MPP 010';
					UPDATE [DBO].[FP_KPI_RAW_DATA_R]
					SET    VALUE5 = '0', VALUE6 = '0', VALUE11 = NULL, UPDATE_TIME = GETDATE() -- VALUE11 PROD TYPE GROUP 2018-10-12 KIMCD 추가
					WHERE  KPI_ID   = '010'
					AND    SITE_ID  = @P_SITE_ID
					-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
					AND    PLANT_ID IN (SELECT V.SEGMENT1
										FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
										WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
										AND    V.ACTIVE_FLAG      = 'Y'
										AND    V.SEGMENT2         = @BASIS_START_TIME
										)
					-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
					AND    VALUE8   = @MPP_MONTH
					AND    VALUE9   = 'MPP';

					SET @v_temp2 = 'INSERT 010 MPP DATA'
					MERGE  INTO [DBO].[FP_KPI_RAW_DATA_R] A
					USING ( SELECT COMPANY_ID
								 , ISNULL((SELECT TOP 1 PD.[ORIGINAL_DIVISION_ID] FROM [DBO].[SCM_PSEUDO_DIVISION_M] AS PD (NOLOCK) WHERE PD.[PLANT_ID] = A.[PLANT_ID]), A.DIVISION_ID) AS DIVISION_ID -- 2022-03-20 kimcd 가상 Division 전환
								 , SITE_ID
								 , PLANT_ID
								 , FACTORY_ID
								 , ITEM_ID
								 , (SELECT TOP 1 B.NICK_NAME
									FROM   SCM_ITEM_M B WITH(NOLOCK)
									WHERE  B.COMPANY_ID  = A.COMPANY_ID
									AND    B.SITE_ID     = A.SITE_ID
									AND    B.DIVISION_ID = A.DIVISION_ID
									AND    B.ITEM_ID     = A.ITEM_ID) AS NICK_NAME
								 , OPERATION_ID
								 , LINE_ID
								 , PRODUCTION_TYPE
								 , PLAN_MONTH
								 , PLAN_DATE
								 , (SELECT TOP 1 C.WEEK
									FROM   [DBO].SCM_SYS_CALENDAR_M C WITH(NOLOCK)
									WHERE  C.DATE_ID = A.PLAN_DATE)  AS PLAN_WEEK
								 , SUM(PLAN_QTY) AS PLAN_QTY
								 , SUM(GOOD_QTY) AS RESULT
								 , (SELECT TOP 1 B.LINE_NAME
									FROM   SCM_LINE_M B WITH(NOLOCK)
									WHERE  B.COMPANY_ID   = A.COMPANY_ID
									AND    B.SITE_ID      = A.SITE_ID
									AND    B.DIVISION_ID  = A.DIVISION_ID
									AND    B.PLANT_ID     = A.PLANT_ID
									AND    B.FACTORY_ID   = A.FACTORY_ID
									AND    B.OPERATION_ID = A.OPERATION_ID
									AND    B.LINE_ID      = A.LINE_ID) AS LINE_NAME
								 , ROW_NUMBER() OVER (ORDER BY ITEM_ID, LINE_ID) AS SEQ
								 , CASE WHEN A.PRODUCTION_TYPE IN ('MASS','M-SAMPLE','SPECIAL', 'C-MASS', 'D-MASS') THEN 'MASS' ELSE 'Sample/Dev/Test' END AS PROD_TYPE_GROUP -- 2020-06-26 kimcd C-MASS D-MASS를 MASS 구분 항목에 포함 -- 2018-10-12 kimcd 추가 2019-01-21 kimcd MASS에 SPECIAL 추가 
							  FROM (SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, CONVERT(NVARCHAR(6),PLAN_DATE,112) AS PLAN_MONTH, PLAN_DATE,
										   CASE WHEN OPERATION_ID = 'E2000' THEN  JR_OUT_QTY *
																				   CASE WHEN ( SELECT COUNT(*) 
																							   FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																							   WHERE  SLV.LOOKUP_TYPE_CODE = 'FP_KPI_DOUBLE_LINE'
																							   AND    SLV.ACTIVE_FLAG = 'Y'
																							   AND    SLV.SEGMENT1 = H.FACTORY_ID
																							   AND    SLV.SEGMENT2 = H.LINE_ID
																							   AND    SLV.SEGMENT3 = H.OPERATION_ID ) = 1 THEN
																						2
																					ELSE 1 END 
										   ELSE PLAN_QTY END AS  PLAN_QTY, 0 AS GOOD_QTY -- 2018-12-07 kimcd Coating은 jumbro roll 길이로 취합 2019-04-04 광폭 설비의 계획을 일반폭으로 환산
									FROM   FP_DAILY_PRODUCTIOIN_PLAN_H H WITH(NOLOCK)   
									WHERE  PLAN_DATE >= DATEADD(D,-DAY(CONVERT(DATE,@MPP_MONTH+'01',112))+1,CONVERT(DATE,@MPP_MONTH+'01',112))
									AND    PLAN_DATE <= DATEADD(D,-DAY(DATEADD(M,1,CONVERT(DATE,@MPP_MONTH+'01',112))), DATEADD(M,1,CONVERT(DATE,@MPP_MONTH+'01',112)))
									AND    PLAN_DATE <  CONVERT( DATETIME, @v_date, 120) -- 2018-11-01 kimcd 분모 추출에서 당일 포함 미래 일자 제외
									AND    OPERATION_ID IN  ('A3000','A9000','E2000','P5500','P9500')
									AND    PRODUCTION_TYPE != 'REWORK' -- 2018-12-07 kimcd 재작업 제외
									AND    PLAN_TYPE = 'WPP' -- 2018-12-04 kimcd 달성율 월 기준 계획을 WPP로 변경
									-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
									AND    PLANT_ID IN ( SELECT V.SEGMENT1
														 FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
														 WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
														 AND    V.ACTIVE_FLAG      = 'Y'
														 AND    V.SEGMENT2         = @BASIS_START_TIME
														 )
									-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
									AND    FACTORY_ID NOT IN  ( SELECT SV.SEGMENT1 
																FROM   [SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
																WHERE  SV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
																AND    SV.ACTIVE_FLAG = 'Y' ) -- 2018-12-18 kimcd setup 진행 중인 공장 KPI 대상 제외
									-- 2018-12-04 kimcd 기준 계획을 WPP로 수정하면 제약 없앰. AND    PLANT_ID != 'A011'  -- 2018-10-30 kimcd 오창 소형 전극은 MPP 정보 관리 안 해서 제거 
									AND    SITE_ID   = @P_SITE_ID
									UNION ALL     
									SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, CONVERT(NVARCHAR(6),PLAN_DATE,112) AS PLAN_MONTH, PLAN_DATE, 
									       0 AS PLAN_QTY, CASE WHEN OPERATION_ID = 'E2000' THEN  CASE WHEN FACTORY_ID IN ('E1','E2') AND ITEM_ID NOT LIKE 'APCCS%' THEN (ISNULL(JR_OUT_QTY,0) + ISNULL(TOP_JR_OUT_QTY,0))/2 ELSE JR_OUT_QTY END *
																										-- 2020-03-17 kimcd TOP Coding 수량 더해서 나누는 로직을 Factory Id 기준으로 함
																								  CASE WHEN ( SELECT COUNT(*) 
																											  FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																											  WHERE  SLV.LOOKUP_TYPE_CODE = 'FP_KPI_DOUBLE_LINE'
																											  AND    SLV.ACTIVE_FLAG = 'Y'
																											  AND    SLV.SEGMENT1 = H.FACTORY_ID
																											  AND    SLV.SEGMENT2 = H.LINE_ID
																											  AND    SLV.SEGMENT3 = H.OPERATION_ID ) = 1 THEN
																										2
																									ELSE 1 END
														  ELSE ACTUAL_GOOD_QTY END AS GOOD_QTY  -- 2018-12-07 kimcd Coating은 jumbro roll 길이로 취합 2019-04-04  TOP COATING 수량 존재하는 경우 더하고 2로 나눔. 광폭 설비의 계획을 일반폭으로 환산
									FROM   SCM_DAILY_PRODUCT_RESULT_H H WITH(NOLOCK)
									WHERE  PLAN_DATE >= DATEADD(D,-DAY(CONVERT(DATE,@MPP_MONTH+'01',112))+1,CONVERT(DATE,@MPP_MONTH+'01',112))
									AND    PLAN_DATE <= DATEADD(D,-DAY(DATEADD(M,1,CONVERT(DATE,@MPP_MONTH+'01',112))), DATEADD(M,1,CONVERT(DATE,@MPP_MONTH+'01',112)))
									AND    OPERATION_ID IN  ('A3000','A9000','E2000','P5500','P9500')
									AND    PRODUCTION_TYPE != 'REWORK' -- 2018-12-07 kimcd 재작업 제외
									-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
									AND    PLANT_ID IN ( SELECT V.SEGMENT1
														 FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
														 WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
														 AND    V.ACTIVE_FLAG      = 'Y'
														 AND    V.SEGMENT2         = @BASIS_START_TIME
														 )
									-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
									AND    FACTORY_ID NOT IN  ( SELECT SV.SEGMENT1 
																FROM   [SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
																WHERE  SV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
																AND    SV.ACTIVE_FLAG = 'Y' ) -- 2018-12-18 kimcd setup 진행 중인 공장 KPI 대상 제외
									-- 2018-12-04 kimcd 기준 계획을 WPP로 수정하면 제약 없앰. AND    PLANT_ID != 'A011'  -- 2018-10-30 kimcd 오창 소형 전극은 MPP 정보 관리 안 해서 제거
									AND    SITE_ID   = @P_SITE_ID
									) A
							  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, PLAN_MONTH, PLAN_DATE )  B
					ON ( A.KPI_ID   = '010'
					AND  A.KPI_DATE = B.PLAN_DATE
					AND  A.SITE_ID  = @P_SITE_ID
					AND  A.SITE_ID  = B.SITE_ID
					AND  A.PLANT_ID     = B.PLANT_ID
					AND  A.FACTORY_ID   = B.FACTORY_ID
					AND  A.OPERATION_ID = B.OPERATION_ID
					AND  A.LINE_ID      = B.LINE_ID
					AND  A.VALUE3       = B.ITEM_ID
					AND  A.VALUE4       = B.PRODUCTION_TYPE
					AND  A.VALUE9       = 'MPP' )
					WHEN MATCHED THEN 
						UPDATE
						SET A.VALUE1      = SUBSTRING(B.OPERATION_ID, 1,1),
							A.VALUE2      = B.NICK_NAME,
							A.VALUE5      = B.RESULT,   -- 분자
							A.VALUE6      = B.PLAN_QTY, -- 분모
							A.VALUE10     = B.LINE_NAME,-- : FP 라인 명
							A.VALUE11     = B.PROD_TYPE_GROUP, -- 2018-10-12 kimcd 추가
							A.UPDATE_TIME = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT ([KPI_ID],       -- : KPI 지표 구분 ID - 생산 계획 달성율 - 010
								[KPI_DATE],     -- : KPI 지표 일자 Plan Date
								[COMPANY_ID],   -- : 법인 코드
								[DIVISION_ID],  -- : 사업부 코드
								[SITE_ID],      -- : Site 코드
								[PLANT_ID],     -- : 공장 구분 코드
								[FACTORY_ID],   -- : 공장 동 코드
								[OPERATION_ID], -- : 공정 코드
								[LINE_ID],      -- : FP 라인 코드
								[SEQ],          -- : 일련번호 - 일, 법인 단위 Sequence
								[value1],       -- : 생산 계획 달성율 : 공정 Shop 구분자
								[value2],       -- : 생산 계획 달성율 : Nick Name
								[value3],       -- : 생산 계획 달성율 : Material Code
								[value4],       -- : 생산 계획 달성율 : Prod Type
								[value5],       -- : 생산 계획 달성율 : 분자 값 Result
								[value6],       -- : 생산 계획 달성율 : 분모 값 Plan
								[value7],       -- : 생산 계획 달성율 : FP 주차 plan week
								[value8],       -- : 생산 계획 달성율 : FP 월 plan month
								[value9],       -- : 생산 계획 달성율 : Plan Type - MPP WPP
								[value10],      -- : FP 라인 명
								[value11],      -- : prod type group 2018-10-12 kimcd 추가
								[INSERT_ID],
								[INSERT_TIME],
								[UPDATE_ID],
								[UPDATE_TIME]
								)
						VALUES ( '010'
								,B.PLAN_DATE
								,B.COMPANY_ID
								,B.DIVISION_ID
								,B.SITE_ID
								,B.PLANT_ID
								,B.FACTORY_ID
								,B.OPERATION_ID
								,B.LINE_ID
								,B.SEQ
								,SUBSTRING(B.OPERATION_ID, 1,1)
								,B.NICK_NAME
								,B.ITEM_ID
								,B.PRODUCTION_TYPE
								,B.RESULT   -- 분자
								,B.PLAN_QTY -- 분모
								,B.PLAN_WEEK
								,B.PLAN_MONTH
								,'MPP'
								,B.LINE_NAME
								,B.PROD_TYPE_GROUP  -- 2018-10-12 kimcd 추가
								,@v_proc_name
								,GETDATE() -- INSERT_TIME
								,@v_proc_name
								,GETDATE() -- UPDATE_TIME
								);
					;					

					FETCH NEXT FROM CUR_MPP INTO @MPP_MONTH;
				END;
			
			CLOSE CUR_MPP;
			DEALLOCATE CUR_MPP;  

			DECLARE CUR_WPP CURSOR FOR
				SELECT DISTINCT C.WEEK, C.WEEKSTART_DATE, WEEKEND_DATE
				FROM   [DBO].SCM_SYS_CALENDAR_M C WITH(NOLOCK)
				WHERE  C.DATE_ID <= CONVERT(DATE, @v_date, 120)
				AND    C.DATE_ID >= DATEADD(D,-45,CONVERT(DATE,@v_date,120))
				AND    EXISTS ( SELECT 1 FROM  [SCM_DAILY_PRODUCT_RESULT_H]  A WITH(NOLOCK)
								WHERE A.SITE_ID = @P_SITE_ID
								AND   A.PLAN_DATE = C.DATE_ID
								AND   A.[UPDATE_TIME] >= DATEADD(D,-2,@v_date)
				                UNION
								SELECT 1 FROM  [FP_DAILY_PRODUCTIOIN_PLAN_H] A WITH(NOLOCK)
								WHERE A.SITE_ID = @P_SITE_ID
								AND   A.PLAN_DATE = C.DATE_ID
								AND   A.PLAN_TYPE = 'WPP'
								AND   A.[UPDATE_TIME] >= DATEADD(D,-2,@v_date) ) ;

			OPEN CUR_WPP;
			FETCH NEXT FROM CUR_WPP INTO @WEEK_NUMBER
										,@FROM_DATE
										,@TO_DATE;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN		
					SET @v_temp2 = 'UPDATE OLD DATA-BASE INFO WPP 010';
					UPDATE [DBO].[FP_KPI_RAW_DATA_R]
					SET    VALUE5 = '0', VALUE6 = '0', VALUE11 = NULL, UPDATE_TIME = GETDATE()
					WHERE  KPI_ID   = '010'
					AND    SITE_ID  = @P_SITE_ID
					-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
					AND    PLANT_ID IN ( SELECT V.SEGMENT1
											FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
											WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND    V.ACTIVE_FLAG      = 'Y'
											AND    V.SEGMENT2         = @BASIS_START_TIME
											)
					-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
					AND    VALUE7   = @WEEK_NUMBER
					AND    VALUE9   = 'WPP';

					SET @v_temp2 = 'INSERT 010 WPP DATA'
					MERGE  INTO [DBO].[FP_KPI_RAW_DATA_R] A
					USING ( SELECT COMPANY_ID
								 , ISNULL((SELECT TOP 1 PD.[ORIGINAL_DIVISION_ID] FROM [DBO].[SCM_PSEUDO_DIVISION_M] AS PD (NOLOCK) WHERE PD.[PLANT_ID] = A.[PLANT_ID]), A.DIVISION_ID) AS DIVISION_ID -- 2022-03-20 kimcd 가상 Division 전환
								 , SITE_ID
								 , PLANT_ID
								 , FACTORY_ID
								 , ITEM_ID
								 , (SELECT TOP 1 B.NICK_NAME
									FROM   SCM_ITEM_M B WITH(NOLOCK)
									WHERE  B.COMPANY_ID  = A.COMPANY_ID
									AND    B.SITE_ID     = A.SITE_ID
									AND    B.DIVISION_ID = A.DIVISION_ID
									AND    B.ITEM_ID     = A.ITEM_ID) AS NICK_NAME
								 , OPERATION_ID
								 , LINE_ID
								 , PRODUCTION_TYPE
								 , PLAN_DATE
								 , CONVERT(NVARCHAR(6),PLAN_DATE,112) AS PLAN_MONTH
								 , SUM(PLAN_QTY) AS PLAN_QTY
								 , SUM(GOOD_QTY) AS RESULT
								 , ROW_NUMBER() OVER (ORDER BY ITEM_ID, LINE_ID) AS SEQ
								 , (SELECT TOP 1 B.LINE_NAME
									FROM   SCM_LINE_M B WITH(NOLOCK)
									WHERE  B.COMPANY_ID   = A.COMPANY_ID
									AND    B.SITE_ID      = A.SITE_ID
									AND    B.DIVISION_ID  = A.DIVISION_ID
									AND    B.PLANT_ID     = A.PLANT_ID
									AND    B.FACTORY_ID   = A.FACTORY_ID
									AND    B.OPERATION_ID = A.OPERATION_ID
									AND    B.LINE_ID      = A.LINE_ID) AS LINE_NAME
								  , CASE WHEN A.PRODUCTION_TYPE IN ('MASS','M-SAMPLE','SPECIAL', 'C-MASS', 'D-MASS') THEN 'MASS' ELSE 'Sample/Dev/Test' END AS PROD_TYPE_GROUP -- 2020-06-26 kimcd C-MASS D-MASS를 MASS 구분 항목에 포함 -- 2018-10-12 kimcd 추가 2019-01-21 kimcd MASS에 SPECIAL 추가
							  FROM (SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, PLAN_DATE,
									       CASE WHEN OPERATION_ID = 'E2000' THEN JR_OUT_QTY * 
																				   CASE WHEN ( SELECT COUNT(*) 
																							   FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																							   WHERE  SLV.LOOKUP_TYPE_CODE = 'FP_KPI_DOUBLE_LINE'
																							   AND    SLV.ACTIVE_FLAG = 'Y'
																							   AND    SLV.SEGMENT1 = H.FACTORY_ID
																							   AND    SLV.SEGMENT2 = H.LINE_ID
																							   AND    SLV.SEGMENT3 = H.OPERATION_ID ) = 1 THEN
																						2
																					ELSE 1 END 
										   ELSE PLAN_QTY END AS PLAN_QTY, 0 AS GOOD_QTY -- 2018-12-07 kimcd Coating은 jumbro roll 길이로 취합 2019-04-04 광폭 설비의 계획을 일반폭으로 환산
									FROM   FP_DAILY_PRODUCTIOIN_PLAN_H H WITH(NOLOCK)   
									WHERE  PLAN_DATE >= @FROM_DATE
									AND    PLAN_DATE <= @TO_DATE
									AND    PLAN_DATE <  CONVERT( DATETIME, @v_date, 120) -- 2018-11-01 kimcd 분모 추출에서 당일 포함 미래 일자 제외
									AND    OPERATION_ID IN  ('A3000','A9000','E2000','P5500','P9500')
									AND    PRODUCTION_TYPE != 'REWORK' -- 2018-12-07 kimcd 재작업 제외
									AND    FACTORY_ID NOT IN  ( SELECT SV.SEGMENT1 
																FROM   [SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
																WHERE  SV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
																AND    SV.ACTIVE_FLAG = 'Y' ) -- 2018-12-18 kimcd setup 진행 중인 공장 KPI 대상 제외
									AND    PLAN_TYPE = 'WPP'
									AND    SITE_ID   = @P_SITE_ID
									-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
									AND    PLANT_ID IN ( SELECT V.SEGMENT1
														 FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
														 WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
														 AND    V.ACTIVE_FLAG      = 'Y'
														 AND    V.SEGMENT2         = @BASIS_START_TIME
														 )
									-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
									UNION ALL     
									SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, PLAN_DATE,
									       0 AS PLAN_QTY, CASE WHEN OPERATION_ID = 'E2000' THEN CASE WHEN FACTORY_ID IN ('E1', 'E2') AND ITEM_ID NOT LIKE 'APCCS%' THEN (ISNULL(JR_OUT_QTY,0) + ISNULL(TOP_JR_OUT_QTY,0))/2 ELSE JR_OUT_QTY END *
										                                                             -- 2020-03-17 kimcd TOP Coding 수량 더해서 나누는 로직을 Factory Id 기준으로 함
																								CASE WHEN ( SELECT COUNT(*) 
																											FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																											WHERE  SLV.LOOKUP_TYPE_CODE = 'FP_KPI_DOUBLE_LINE'
																											AND    SLV.ACTIVE_FLAG = 'Y'
																											AND    SLV.SEGMENT1 = H.FACTORY_ID
																											AND    SLV.SEGMENT2 = H.LINE_ID
																											AND    SLV.SEGMENT3 = H.OPERATION_ID ) = 1 THEN
																									2
																								ELSE 1 END
														  ELSE ACTUAL_GOOD_QTY END AS GOOD_QTY -- 2018-12-07 kimcd Coating은 jumbro roll 길이로 취합 2019-04-04 TOP COATING 수량 존재하는 경우 더하고 2로 나눔. 광폭 설비의 계획을 일반폭으로 환산
									FROM   SCM_DAILY_PRODUCT_RESULT_H H WITH(NOLOCK)
									WHERE  PLAN_DATE >= @FROM_DATE
									AND    PLAN_DATE <= @TO_DATE
									AND    OPERATION_ID IN  ('A3000','A9000','E2000','P5500','P9500')
									AND    PRODUCTION_TYPE != 'REWORK' -- 2018-12-07 kimcd 재작업 제외
									AND    FACTORY_ID NOT IN  ( SELECT SV.SEGMENT1 
																FROM   [SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
																WHERE  SV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
																AND    SV.ACTIVE_FLAG = 'Y' ) -- 2018-12-18 kimcd setup 진행 중인 공장 KPI 대상 제외
									AND    SITE_ID   = @P_SITE_ID
									-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
									AND    PLANT_ID IN ( SELECT V.SEGMENT1
														 FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
														 WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
														 AND    V.ACTIVE_FLAG      = 'Y'
														 AND    V.SEGMENT2         = @BASIS_START_TIME
														 )
									-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
									) A
							  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, PLAN_DATE )  B
					ON ( A.KPI_ID   = '010'
					AND  A.SITE_ID  = @P_SITE_ID
					AND  A.SITE_ID  = B.SITE_ID
					AND  A.PLANT_ID     = B.PLANT_ID
					AND  A.FACTORY_ID   = B.FACTORY_ID
					AND  A.OPERATION_ID = B.OPERATION_ID
					AND  A.LINE_ID      = B.LINE_ID
					AND  A.VALUE3       = B.ITEM_ID
					AND  A.VALUE4       = B.PRODUCTION_TYPE
					AND  A.KPI_DATE     = B.PLAN_DATE
					AND  A.VALUE9       = 'WPP' )
					WHEN MATCHED THEN 
						UPDATE
						SET A.VALUE1      = SUBSTRING(B.OPERATION_ID, 1,1),
							A.VALUE2      = B.NICK_NAME,
							A.VALUE5      = B.RESULT,   -- 분자
							A.VALUE6      = B.PLAN_QTY, -- 분모
							A.VALUE10     = B.LINE_NAME,
							A.VALUE11     = B.PROD_TYPE_GROUP, -- 2018-10-12 kimcd 추가
							A.UPDATE_TIME = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT ([KPI_ID],       -- : KPI 지표 구분 ID - 생산 계획 달성율 - 010
								[KPI_DATE],     -- : KPI 지표 일자 Plan Date
								[COMPANY_ID],   -- : 법인 코드
								[DIVISION_ID],  -- : 사업부 코드
								[SITE_ID],      -- : Site 코드
								[PLANT_ID],     -- : 공장 구분 코드
								[FACTORY_ID],   -- : 공장 동 코드
								[OPERATION_ID], -- : 공정 코드
								[LINE_ID],      -- : FP 라인 코드
								[SEQ],          -- : 일련번호 - 일, 법인 단위 Sequence
								[value1],       -- : 생산 계획 달성율 : 공정 Shop 구분자
								[value2],       -- : 생산 계획 달성율 : Nick Name
								[value3],       -- : 생산 계획 달성율 : Material Code
								[value4],       -- : 생산 계획 달성율 : Prod Type
								[value5],       -- : 생산 계획 달성율 : 분자 값 Result
								[value6],       -- : 생산 계획 달성율 : 분모 값 Plan
								[value7],       -- : 생산 계획 달성율 : FP 주차 plan week
								[value8],       -- : 생산 계획 달성율 : FP 월 plan month
								[value9],       -- : 생산 계획 달성율 : Plan Type - MPP WPP
								[value10],      -- : FP 라인 명
								[value11],      -- : prod type group 추가 2018-10-12 kimcd
								[INSERT_ID],
								[INSERT_TIME],
								[UPDATE_ID],
								[UPDATE_TIME]
								)
						VALUES ( '010'
								,B.PLAN_DATE
								,B.COMPANY_ID
								,B.DIVISION_ID
								,B.SITE_ID
								,B.PLANT_ID
								,B.FACTORY_ID
								,B.OPERATION_ID
								,B.LINE_ID
								,B.SEQ
								,SUBSTRING(B.OPERATION_ID, 1,1)
								,B.NICK_NAME
								,B.ITEM_ID
								,B.PRODUCTION_TYPE
								,B.RESULT   -- 분자
								,B.PLAN_QTY -- 분모
								,@WEEK_NUMBER
								,B.PLAN_MONTH
								,'WPP'
								,B.LINE_NAME
								,B.PROD_TYPE_GROUP  -- VALUE11 2018-10-12 kimcd 추가
								,@v_proc_name
								,GETDATE() -- INSERT_TIME
								,@v_proc_name
								,GETDATE() -- UPDATE_TIME
								);
					;					

					FETCH NEXT FROM CUR_WPP INTO @WEEK_NUMBER
												,@FROM_DATE
												,@TO_DATE;
				END;
			
			CLOSE CUR_WPP;
			DEALLOCATE CUR_WPP;
			-- 2018-10-08 KPI 달성율 재구성 종료

			-- 생산 계획 준수율 011
			-- 2018-10-10 생산 계획 준수율 재구성 
			SELECT TOP 1 @CURRENT_WEEK = C.WEEK FROM  [DBO].SCM_SYS_CALENDAR_M C WITH(NOLOCK) WHERE C.DATE_ID = CONVERT(DATE, @v_ydate, 120)
			-- 2019-01-08 kimcd 어제 일 기준으로 기준 주차 추출. @CURRENT_WEEK보다 이전 주차는 계획 수량 변경 안 함

			DECLARE CUR_OB CURSOR FOR
				SELECT DISTINCT C.WEEK, C.WEEKSTART_DATE, WEEKEND_DATE, CASE WHEN A.NUM = 1 THEN
																			(SELECT TOP 1 D.WEEK
																			 FROM   [DBO].SCM_SYS_CALENDAR_M D WITH(NOLOCK)
																			 WHERE D.DATE_ID = DATEADD(DD, -1, C.WEEKSTART_DATE) )
																		ELSE C.WEEK END AS BASIC_WEEK
							   ,A.NUM
				FROM   [DBO].SCM_SYS_CALENDAR_M C WITH(NOLOCK)
					  ,(SELECT 1 AS NUM UNION SELECT 2) A
				WHERE  C.DATE_ID <= CONVERT(DATE, @v_date, 120)
				AND    C.DATE_ID >= DATEADD(D,-45,CONVERT(DATE,@v_date,120))
				AND    EXISTS ( SELECT 1 FROM  [SCM_DAILY_PRODUCT_RESULT_H]  A WITH(NOLOCK)
								WHERE A.SITE_ID = @P_SITE_ID
								AND   A.PLAN_DATE = C.DATE_ID
								AND   A.[UPDATE_TIME] >= DATEADD(D,-2,@v_date)
				                UNION
								SELECT 1 FROM  [FP_DAILY_PRODUCTIOIN_PLAN_H] A WITH(NOLOCK) -- 2018-12-04 kimcd 계획 취합 조건에서 WPP 계획 변경 추가
								WHERE A.SITE_ID = @P_SITE_ID
								AND   A.PLAN_DATE = C.DATE_ID
								AND   A.PLAN_TYPE = 'WPP'
								AND   A.[UPDATE_TIME] >= DATEADD(D,-2,@v_date) ) 
				-- 2019-01-16 kimcd 미래 주차 추가 시작
				UNION
				SELECT DISTINCT C.WEEK, C.WEEKSTART_DATE, WEEKEND_DATE, CASE WHEN A.NUM = 1 THEN
																			(SELECT TOP 1 D.WEEK
																			 FROM   [DBO].SCM_SYS_CALENDAR_M D WITH(NOLOCK)
																			 WHERE D.DATE_ID = DATEADD(DD, -1, C.WEEKSTART_DATE) )
																		ELSE C.WEEK END AS BASIC_WEEK
							   ,A.NUM
				FROM   [DBO].SCM_SYS_CALENDAR_M C WITH(NOLOCK)
					  ,(SELECT 1 AS NUM UNION SELECT 2) A
				WHERE  C.DATE_ID = DATEADD( D, 7, CONVERT(DATE, @v_date, 120))
				-- 2019-01-16 kimcd 미래 주차 추가 끝
				;

			OPEN CUR_OB;
			FETCH NEXT FROM CUR_OB  INTO @WEEK_NUMBER
										,@FROM_DATE
										,@TO_DATE
										,@BASIC_WEEK
										,@OB_NUM;
			WHILE (@@FETCH_STATUS = 0)
				BEGIN		
					SET @v_temp2 = 'UPDATE OLD DATA-BASE INFO 011';
					UPDATE [DBO].[FP_KPI_RAW_DATA_R]
					SET    VALUE5 = '0', VALUE6 = CASE WHEN VALUE9 < @CURRENT_WEEK THEN VALUE6 ELSE '0' END,    -- 2019-01-08 kimcd @CURRENT_WEEK보다 이전 계획 수립 주차는 계획 수량 변경 안 함
										 VALUE11 = CASE WHEN VALUE9 < @CURRENT_WEEK THEN VALUE11 ELSE NULL END, -- 2019-01-08 kimcd @CURRENT_WEEK보다 이전 계획 수립 주차는 계획 수량 변경 안 함
										 UPDATE_TIME = GETDATE() -- VALUE11 PROD TYPE GROUP 추가 2018-10-12 kimcd
					WHERE  KPI_ID   = '011'
					AND    SITE_ID  = @P_SITE_ID
					-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
					AND    PLANT_ID IN ( SELECT V.SEGMENT1
											FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
											WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND    V.ACTIVE_FLAG      = 'Y'
											AND    V.SEGMENT2         = @BASIS_START_TIME
											)
					-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
					AND    VALUE7   = @WEEK_NUMBER
					AND    VALUE9   = @BASIC_WEEK;

					SET @v_temp2 = 'INSERT 011 DATA'
					MERGE  INTO [DBO].[FP_KPI_RAW_DATA_R] A
					USING ( SELECT PLAN_DATE    AS KPI_DATE
					             , COMPANY_ID
								 , ISNULL((SELECT TOP 1 PD.[ORIGINAL_DIVISION_ID] FROM [DBO].[SCM_PSEUDO_DIVISION_M] AS PD (NOLOCK) WHERE PD.[PLANT_ID] = A.[PLANT_ID]), A.DIVISION_ID) AS DIVISION_ID -- 2022-03-20 kimcd 가상 Division 전환
								 , DIVISION_ID AS SCM_DIVISION_ID -- 2022-03-20 kimcd 부가 정보 설정용 SCM 가상 Division 관리
								 , SITE_ID
								 , PLANT_ID
								 , FACTORY_ID
								 , OPERATION_ID
								 , ITEM_ID
								 , (SELECT TOP 1 B.NICK_NAME
									FROM   SCM_ITEM_M B WITH(NOLOCK)
									WHERE  B.COMPANY_ID  = A.COMPANY_ID
									AND    B.SITE_ID     = A.SITE_ID
									AND    B.DIVISION_ID = A.DIVISION_ID
									AND    B.ITEM_ID     = A.ITEM_ID) AS NICK_NAME
								 , LINE_ID
								 , PRODUCTION_TYPE
								 , SUM(PLAN_QTY) AS PLAN_QTY
								 , SUM(GOOD_QTY) AS RESULT
								 , ISNULL(MAX(BASIC_DATE), CASE WHEN @OB_NUM = 2 THEN @TO_DATE ELSE DATEADD(DD, -1, @FROM_DATE) END ) AS BASIC_DATE
								 , (SELECT TOP 1 B.LINE_NAME
									FROM   SCM_LINE_M B WITH(NOLOCK)
									WHERE  B.COMPANY_ID   = A.COMPANY_ID
									AND    B.SITE_ID      = A.SITE_ID
									AND    B.DIVISION_ID  = A.DIVISION_ID
									AND    B.PLANT_ID     = A.PLANT_ID
									AND    B.FACTORY_ID   = A.FACTORY_ID
									AND    B.OPERATION_ID = A.OPERATION_ID
									AND    B.LINE_ID      = A.LINE_ID) AS LINE_NAME
								 , ROW_NUMBER() OVER (ORDER BY ITEM_ID, LINE_ID) AS SEQ
								 , CASE WHEN A.PRODUCTION_TYPE IN ('MASS','M-SAMPLE','SPECIAL', 'C-MASS' , 'D-MASS') THEN 'MASS' ELSE 'Sample/Dev/Test' END AS PROD_TYPE_GROUP -- 2020-06-26 kimcd C-MASS D-MASS를 MASS 구분 항목에 포함 -- 2018-10-12 kimcd 추가 2019-01-21 kimcd MASS에 SPECIAL 추가
							  FROM (/* 2018-12-04 kimcd 막음
									SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, PLAN_DATE, PLAN_QTY, 0 AS GOOD_QTY, CONVERT(DATE, SUBSTRING(FP_PLAN_ID,1,8) , 112) AS BASIC_DATE
									FROM   FP_KPI_DAILY_PRODUCTION_PLAN_H WITH(NOLOCK)   
									WHERE  PLAN_DATE >= @FROM_DATE
									AND    PLAN_DATE <= @TO_DATE
									AND    PLAN_DATE <  CONVERT( DATETIME, @v_date, 120) -- 2018-11-01 kimcd 분모 추출에서 당일 포함 미래 일자 제외
									AND    OPERATION_ID IN  ('A3000','A9000','E2000','P5500','P9500')
									AND    PLAN_TYPE = 'W+2_PLAN'
									AND    SITE_ID   = @P_SITE_ID
									AND    CUTOFF_DATE = CASE WHEN @OB_NUM = 2 THEN @TO_DATE ELSE DATEADD(DD, -1, @FROM_DATE) END */
									-- 2018-12-04 kimcd 기준 계획 조회를 WPP 계획으로 변경
									SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, PLAN_DATE,
									       CASE WHEN OPERATION_ID = 'E2000' THEN  JR_OUT_QTY *
										   										   CASE WHEN ( SELECT COUNT(*) 
																							   FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																							   WHERE  SLV.LOOKUP_TYPE_CODE = 'FP_KPI_DOUBLE_LINE'
																							   AND    SLV.ACTIVE_FLAG = 'Y'
																							   AND    SLV.SEGMENT1 = H.FACTORY_ID
																							   AND    SLV.SEGMENT2 = H.LINE_ID
																							   AND    SLV.SEGMENT3 = H.OPERATION_ID ) = 1 THEN
																						2
																					ELSE 1 END -- 2019-04-04 광폭 설비의 계획을 일반폭으로 환산
										   ELSE PLAN_QTY END AS PLAN_QTY
										   , 0 AS GOOD_QTY, CASE WHEN @OB_NUM = 2 THEN @TO_DATE ELSE DATEADD(DD, -1, @FROM_DATE) END AS BASIC_DATE -- 2018-12-07 kimcd Coating은 jumbro roll 길이로 취합
									FROM   FP_DAILY_PRODUCTIOIN_PLAN_H H WITH(NOLOCK)   
									WHERE  PLAN_DATE >= @FROM_DATE
									AND    PLAN_DATE <= @TO_DATE
									-- 2019-01-16 kimcd 일별 조건 제거 AND    PLAN_DATE <  CONVERT( DATETIME, @v_date, 120) -- 2018-11-01 kimcd 분모 추출에서 당일 포함 미래 일자 제외
									AND    OPERATION_ID IN  ('A3000','A9000','E2000','P5500','P9500')
									AND    PRODUCTION_TYPE != 'REWORK' -- 2018-12-07 kimcd 재작업 제외
									AND    FACTORY_ID NOT IN  ( SELECT SV.SEGMENT1 
																FROM   [SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
																WHERE  SV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
																AND    SV.ACTIVE_FLAG = 'Y' ) -- 2018-12-18 kimcd setup 진행 중인 공장 KPI 대상 제외
									AND    PLAN_TYPE = 'WPP'
									AND    SITE_ID   = @P_SITE_ID
									-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
									AND    PLANT_ID IN ( SELECT V.SEGMENT1
														 FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
														 WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
														 AND    V.ACTIVE_FLAG      = 'Y'
														 AND    V.SEGMENT2         = @BASIS_START_TIME
														 )
									-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
									UNION ALL     
									SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, PLAN_DATE,
									       0 AS PLAN_QTY, CASE WHEN OPERATION_ID = 'E2000' THEN   CASE WHEN FACTORY_ID IN ('E1','E2') AND ITEM_ID NOT LIKE 'APCCS%' THEN (ISNULL(JR_OUT_QTY,0) + ISNULL(TOP_JR_OUT_QTY,0))/2 ELSE JR_OUT_QTY END *
																										-- 2020-03-17 kimcd TOP Coding 수량 더해서 나누는 로직을 Factory Id 기준으로 함
																								  CASE WHEN ( SELECT COUNT(*) 
																											  FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																											  WHERE  SLV.LOOKUP_TYPE_CODE = 'FP_KPI_DOUBLE_LINE'
																											  AND    SLV.ACTIVE_FLAG = 'Y'
																											  AND    SLV.SEGMENT1 = H.FACTORY_ID
																											  AND    SLV.SEGMENT2 = H.LINE_ID
																											  AND    SLV.SEGMENT3 = H.OPERATION_ID ) = 1 THEN
																										2
																								  ELSE 1 END  -- 2019-04-04  TOP COATING 수량 존재하는 경우 더하고 2로 나눔. 광폭 설비의 계획을 일반폭으로 환산
														  ELSE ACTUAL_GOOD_QTY END AS GOOD_QTY  
										   , NULL AS BASIC_DATE -- 2018-12-07 kimcd Coating은 jumbro roll 길이로 취합
									FROM   SCM_DAILY_PRODUCT_RESULT_H H WITH(NOLOCK)
									WHERE  PLAN_DATE >= @FROM_DATE
									AND    PLAN_DATE <= @TO_DATE
									AND    OPERATION_ID IN  ('A3000','A9000','E2000','P5500','P9500')
									AND    PRODUCTION_TYPE != 'REWORK' -- 2018-12-07 kimcd 재작업 제외
									AND    FACTORY_ID NOT IN  ( SELECT SV.SEGMENT1 
																FROM   [SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
																WHERE  SV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
																AND    SV.ACTIVE_FLAG = 'Y' ) -- 2018-12-18 kimcd setup 진행 중인 공장 KPI 대상 제외
									AND    SITE_ID   = @P_SITE_ID
									-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
									AND    PLANT_ID IN ( SELECT V.SEGMENT1
														 FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
														 WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
														 AND    V.ACTIVE_FLAG      = 'Y'
														 AND    V.SEGMENT2         = @BASIS_START_TIME
														 )
									-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
									) A
							  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, PRODUCTION_TYPE, PLAN_DATE )  B
					ON ( A.KPI_ID   = '011'
					AND  A.KPI_DATE = B.KPI_DATE
					AND  A.SITE_ID  = @P_SITE_ID
					AND  A.SITE_ID  = B.SITE_ID
					AND  A.PLANT_ID     = B.PLANT_ID
					AND  A.FACTORY_ID   = B.FACTORY_ID
					AND  A.OPERATION_ID = B.OPERATION_ID
					AND  A.LINE_ID      = B.LINE_ID
					AND  A.VALUE3       = B.ITEM_ID
					AND  A.VALUE4       = B.PRODUCTION_TYPE
					AND  A.VALUE9       = @BASIC_WEEK)
					WHEN MATCHED THEN 
						UPDATE
						SET A.VALUE1      = SUBSTRING(B.OPERATION_ID, 1,1),
							A.VALUE2      = B.NICK_NAME,
							A.VALUE5      = B.RESULT,   -- 분자
							A.VALUE6      = CASE WHEN VALUE9 < @CURRENT_WEEK THEN VALUE6 ELSE B.PLAN_QTY END, -- 분모  -- 2019-01-08 kimcd @CURRENT_WEEK보다 이전 계획 수립 주차는 계획 수량 변경 안 함
							A.VALUE8      = CONVERT(NVARCHAR(10), B.BASIC_DATE, 120),
							A.VALUE10     = B.LINE_NAME,
							A.VALUE11     = CASE WHEN VALUE9 < @CURRENT_WEEK THEN VALUE11 ELSE B.PROD_TYPE_GROUP END, -- 2018-10-12 kimcd 추가 -- 2019-01-08 kimcd @CURRENT_WEEK보다 이전 계획 수립 주차는 계획 수량 변경 안 함
							A.UPDATE_TIME = CASE WHEN B.KPI_DATE <  CONVERT( DATETIME, @v_date, 120) THEN GETDATE() ELSE CONVERT(DATETIME, '2001-01-01', 120) END -- 2019-01-16 kimcd 미래일자의 경우 2001년 1월 1일로 갱신일자 입력
					WHEN NOT MATCHED THEN
						INSERT ([KPI_ID],        -- KPI 지표 구분 ID - 생산 계획 준수율 - 011
								[KPI_DATE],      -- PLAN_DATE
								[COMPANY_ID],    -- 법인 코드
								[DIVISION_ID],   -- 사업부 코드
								[SITE_ID],       -- 법인 Site 코드
								[PLANT_ID],      -- 공장 구분 코드
								[FACTORY_ID],    -- 공장 동 코드
								[OPERATION_ID],  -- 공정 코드
								[LINE_ID],       -- FP 라인 코드
								[SEQ],           -- 정보 일련번호 - 일, 법인 단위 Sequence
								[VALUE1],        -- 생산 계획 준수율 : 공정 Shop 구분자
								[VALUE2],        -- 생산 계획 준수율 : Nick Name
								[VALUE3],        -- 생산 계획 준수율 : Material Code
								[VALUE4],        -- 생산 계획 준수율 : Prod Type
								[VALUE5],        -- 생산 계획 준수율 : 분자 값 Result
								[VALUE6],        -- 생산 계획 준수율 : 분모 값 Plan
								[VALUE7],        -- 생산 계획 준수율 : PLAN WEEK
								[VALUE8],        -- 생산 계획 준수율 : BASIC DATE
								[VALUE9],        -- 생산 계획 준수율 : BASIC WEEK
								[VALUE10],       -- 생산 계획 준수율 : LINE NAME
								[VALUE11],       -- 생산 계획 준수율 : PROD TYPE GROUP 2018-10-12 kimcd 추가
								[VALUE17],       -- 2022-03-20 kimcd 부가 정보 설정용 SCM 가상 Division id 설정
								[INSERT_ID],
								[INSERT_TIME],
								[UPDATE_ID],
								[UPDATE_TIME]
								)
						VALUES ( '011'
								,B.KPI_DATE
								,B.COMPANY_ID
								,B.DIVISION_ID
								,B.SITE_ID
								,B.PLANT_ID
								,B.FACTORY_ID
								,B.OPERATION_ID
								,B.LINE_ID
								,B.SEQ
								,SUBSTRING(B.OPERATION_ID, 1,1)
								,B.NICK_NAME
								,B.ITEM_ID
								,B.PRODUCTION_TYPE
								,B.RESULT   -- 분자
								,CASE WHEN @BASIC_WEEK < @CURRENT_WEEK THEN '0' ELSE B.PLAN_QTY END -- 분모 -- 2019-01-08 kimcd @CURRENT_WEEK보다 이전 계획 수립 주차는 계획 수량 변경 안 함
								,@WEEK_NUMBER
								,CONVERT(NVARCHAR(10), B.BASIC_DATE, 120)
								,@BASIC_WEEK
								,B.LINE_NAME
								,B.PROD_TYPE_GROUP  -- 생산 계획 준수율 : PROD TYPE GROUP 2018-10-12 kimcd 추가
								,B.SCM_DIVISION_ID  -- 2022-03-20 kimcd 부가 정보 설정용 SCM 가성 Division id 설정
								,@v_proc_name
								,GETDATE() -- INSERT_TIME
								,@v_proc_name
								,CASE WHEN B.KPI_DATE <  CONVERT( DATETIME, @v_date, 120) THEN GETDATE() ELSE CONVERT(DATETIME, '2001-01-01', 120) END  -- UPDATE_TIME  -- 2019-01-16 kimcd 미래일자의 경우 2001년 1월 1일로 갱신일자 입력
								);
					;					

					-- 2021-11-03 kimcd 준수율 SCM 부가 정보 설정 시작
					IF @OB_NUM = 1
						UPDATE A
						SET    [VALUE12]   = ( SELECT TOP 1 ISNULL(ISNULL(ISNULL(M2.NICK_NAME, M1.DOE), A.[VALUE2]), A.[VALUE3])
											   FROM   SCM_ITEM_M M1 (NOLOCK)
													  LEFT OUTER JOIN SCM_ITEM_M M2 (NOLOCK)
														  ON M1.DOE = M2.ITEM_ID
											   WHERE M1.[COMPANY_ID]  = A.[COMPANY_ID]
											   AND   M1.[SITE_ID]     = A.[SITE_ID]
											   -- AND   M1.[DIVISION_ID] = A.[DIVISION_ID] 
											   AND   M1.[DIVISION_ID] = A.[VALUE17] -- 2022-03-20 kimcd 부가 정보 설정용으로 SCM 내부 DIVISION ID 사용
											   AND   M1.[ITEM_ID]     = A.[VALUE3]
											   ORDER BY M2.[NICK_NAME] DESC) 
							  ,[VALUE13]   = F.GROUP_CODE1 -- SCP GROUP_CODE1
							  ,[VALUE14]   = F.GROUP_CODE2 -- SCP GROUP_CODE2
							  ,UPDATE_TIME = GETDATE()
						FROM   [DBO].[FP_KPI_RAW_DATA_R] A
		      			       LEFT OUTER JOIN LGCE_SCMDEV.DBO.SCP_MST_FINAL_ITEM AS F WITH(NOLOCK)
								   -- ON  A.DIVISION_ID	= F.DIVISION_ID
								   ON  A.VALUE17        = F.DIVISION_ID -- 2022-03-20 kimcd 부가 정보 설정용으로 SCM 내부 DIVISION ID 사용
								   AND A.VALUE3  		= F.ITEM_ID
						WHERE  A.KPI_ID   = '011'
						AND    A.SITE_ID  = @P_SITE_ID
						AND    A.PLANT_ID IN (  SELECT V.SEGMENT1
												FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
												WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
												AND    V.ACTIVE_FLAG      = 'Y'
												AND    V.SEGMENT2         = @BASIS_START_TIME
												)
						AND    A.VALUE7   = @WEEK_NUMBER
						AND    A.VALUE9   = @BASIC_WEEK;

					IF @OB_NUM = 1
						UPDATE A
						SET    [VALUE15]   = CONVERT(NUMERIC(18,4), A.[VALUE5]) * B.CHILD_QTY -- Cell 환산된 실적. 분자
							  ,[VALUE16]   = CONVERT(NUMERIC(18,4), A.[VALUE6]) * B.CHILD_QTY -- Cell 환산된 계획. 분모
							  ,UPDATE_TIME = GETDATE()
						FROM   [DBO].[FP_KPI_RAW_DATA_R] A
		      			       LEFT OUTER HASH JOIN (  SELECT A.[COMPANY_ID]    -- 법인 코드
														,A.[DIVISION_ID]   -- 사업부 코드
														,A.[SITE_ID]       -- 법인 Site 코드
														,A.[PLANT_ID]      -- 공장 구분 코드
														,A.[VALUE3]        -- 생산 계획 준수율 : Material Code
														,(SELECT SUM(MCT.ACCUMULATED_CHILD_QTY)
														  FROM   SCM_MODEL_COMP_TEMP MCT WITH(NOLOCK)
														  WHERE  MCT.[COMPANY_ID]     = A.[COMPANY_ID]
														  -- AND    MCT.[DIVISION_ID]    = A.[DIVISION_ID]
														  AND    MCT.[DIVISION_ID]    = MAX(A.[VALUE17]) -- 2022-03-20 kimcd 부가 정보 설정용으로 SCM 내부 DIVISION ID 사용
														  AND    MCT.[SITE_ID]        = A.[SITE_ID]
														  AND    MCT.[PLANT_ID]       = A.[PLANT_ID]
														  AND    MCT.[MODEL_ID]       = A.[VALUE3]
														  AND    MCT.ALT_PRIORITY     = 'Y'
														  AND    EXISTS ( SELECT 1
																		  FROM   SCM_ITEM_M          I   WITH(NOLOCK)
																		  WHERE  I.[ITEM_ID]     = MCT.[CHILD_ITEM_ID]
																		  AND    I.[ACTIVE_FLAG] = 'Y'
																		  AND    I.[FLOW_ID]    IN  ('A3000','A9000') )
														  ) AS CHILD_QTY 
							                      FROM   [DBO].[FP_KPI_RAW_DATA_R] A
												  WHERE  A.KPI_ID   = '011'
												  AND    A.SITE_ID  = @P_SITE_ID
												  AND    A.PLANT_ID IN ( SELECT V.SEGMENT1
																		 FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
																		 WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																		 AND    V.ACTIVE_FLAG      = 'Y'
																		 AND    V.SEGMENT2         = @BASIS_START_TIME
																		 )
												  AND    A.VALUE7   = @WEEK_NUMBER
												  AND    A.VALUE9   = @BASIC_WEEK
												  AND    A.OPERATION_ID IN ('P5500','P9500') -- Pack 공정 제한
												  GROUP BY A.[COMPANY_ID],A.[DIVISION_ID],A.[SITE_ID],A.[PLANT_ID],A.[VALUE3]
												  ) AS B
								   ON  A.[COMPANY_ID]  = B.[COMPANY_ID]  -- 법인 코드
								   AND A.[DIVISION_ID] = B.[DIVISION_ID] -- 사업부 코드
								   AND A.[SITE_ID]     = B.[SITE_ID]     -- 법인 Site 코드
								   AND A.[PLANT_ID]    = B.[PLANT_ID]    -- 공장 구분 코드
								   AND A.[VALUE3]      = B.[VALUE3]      -- 생산 계획 준수율 : Material Code
						WHERE  A.KPI_ID   = '011'
						AND    A.SITE_ID  = @P_SITE_ID
						AND    A.PLANT_ID IN (  SELECT V.SEGMENT1
												FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
												WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
												AND    V.ACTIVE_FLAG      = 'Y'
												AND    V.SEGMENT2         = @BASIS_START_TIME
												)
						AND    A.VALUE7   = @WEEK_NUMBER
						AND    A.VALUE9   = @BASIC_WEEK
						AND    A.OPERATION_ID IN ('P5500','P9500');
					
					IF @OB_NUM = 1 AND @P_SITE_ID = 'A004'  -- P5200 공정은 제품이 아니라서 MODEL 기준으로 CELL 수량 찾기 불가능하여 추가
						UPDATE A
						SET    [VALUE15]   = CONVERT(NUMERIC(18,4), A.[VALUE5]) * B.CHILD_QTY -- Cell 환산된 실적. 분자
							  ,[VALUE16]   = CONVERT(NUMERIC(18,4), A.[VALUE6]) * B.CHILD_QTY -- Cell 환산된 계획. 분모
							  ,UPDATE_TIME = GETDATE()
						FROM   [DBO].[FP_KPI_RAW_DATA_R] A
		      			       LEFT OUTER HASH JOIN (  SELECT A.[COMPANY_ID]    -- 법인 코드
														,A.[DIVISION_ID]   -- 사업부 코드
														,A.[SITE_ID]       -- 법인 Site 코드
														,A.[PLANT_ID]      -- 공장 구분 코드
														,A.[VALUE3]        -- 생산 계획 준수율 : Material Code
														,(SELECT TOP 1 SUM(BOM.CHILD_QTY/BOM.PARENT_QTY)
														  FROM   SCM_BOM_M BOM WITH(NOLOCK)
														  WHERE  BOM.[COMPANY_ID]     = A.[COMPANY_ID]
														  --AND    BOM.[DIVISION_ID]    = A.[DIVISION_ID]
														  AND    BOM.[DIVISION_ID]    = MAX(A.[VALUE17]) -- 2022-03-20 kimcd 부가 정보 설정용으로 SCM 내부 DIVISION ID 사용
														  AND    BOM.[SITE_ID]        = A.[SITE_ID]
														  AND    BOM.[PLANT_ID]       = A.[PLANT_ID]
														  AND    BOM.[PARENT_ITEM_ID] = A.[VALUE3]
														  AND    (BOM.ALT_ID IS NULL OR BOM.ALT_PRIORITY = 1)
								  						  AND    BOM.[EFF_START_DATE] <= @FROM_DATE
														  AND    BOM.[EFF_END_DATE]   >  @FROM_DATE
														  AND    EXISTS ( SELECT 1
																		  FROM   SCM_ITEM_M          I   WITH(NOLOCK)
																		  WHERE  I.[ITEM_ID]     = BOM.[CHILD_ITEM_ID]
																		  AND    I.[ACTIVE_FLAG] = 'Y'
																		  AND    I.[FLOW_ID]    IN  ('A3000','A9000') )
														  ) AS CHILD_QTY
							                      FROM   [DBO].[FP_KPI_RAW_DATA_R] A
												  WHERE  A.KPI_ID   = '011'
												  AND    A.SITE_ID  = @P_SITE_ID
												  AND    A.PLANT_ID IN ( SELECT V.SEGMENT1
																		 FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
																		 WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																		 AND    V.ACTIVE_FLAG      = 'Y'
																		 AND    V.SEGMENT2         = @BASIS_START_TIME
																		 )
												  AND    A.VALUE7   = @WEEK_NUMBER
												  AND    A.VALUE9   = @BASIC_WEEK
												  AND    A.[OPERATION_ID] = 'P5200'
												  GROUP BY A.[COMPANY_ID],A.[DIVISION_ID],A.[SITE_ID],A.[PLANT_ID],A.[VALUE3]
												  ) AS B
								   ON  A.[COMPANY_ID]  = B.[COMPANY_ID]  -- 법인 코드
								   AND A.[DIVISION_ID] = B.[DIVISION_ID] -- 사업부 코드
								   AND A.[SITE_ID]     = B.[SITE_ID]     -- 법인 Site 코드
								   AND A.[PLANT_ID]    = B.[PLANT_ID]    -- 공장 구분 코드
								   AND A.[VALUE3]      = B.[VALUE3]      -- 생산 계획 준수율 : Material Code
						WHERE  A.KPI_ID   = '011'
						AND    A.SITE_ID  = @P_SITE_ID
						AND    A.PLANT_ID IN (  SELECT V.SEGMENT1
												FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
												WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
												AND    V.ACTIVE_FLAG      = 'Y'
												AND    V.SEGMENT2         = @BASIS_START_TIME
												)
						AND    A.VALUE7   = @WEEK_NUMBER
						AND    A.VALUE9   = @BASIC_WEEK
						AND    A.OPERATION_ID = 'P5200';
					-- 2021-11-03 kimcd 준수율 SCM 부가 정보 설정 종료

					FETCH NEXT FROM CUR_OB  INTO @WEEK_NUMBER
												,@FROM_DATE
												,@TO_DATE
												,@BASIC_WEEK
												,@OB_NUM;

				END;
			
			CLOSE CUR_OB;
			DEALLOCATE CUR_OB;
            /* 2018-09-04 kimcd 3일 fix 준수율 생산 계획 달성율, 생산 계획 준수율 전면 재개발 종료 */

			-- 2019-06-13 kimcd 012 SCP타겟-FP계획 충족율 추가 가동율 재활용
            -- KPI_ID       : KPI 지표 구분 ID - 충족율 - 012 : PK
            -- KPI_DATE     : 정보 형성 일자
            -- COMPANY_ID   : 법인 코드
            -- DIVISION_ID  : 사업부 코드
            -- SITE_ID      : 법인 Site 코드
            -- PLANT_ID     : 공장 구분 코드                  : PK
            -- FACTORY_ID   : '-'
            -- OPERATION_ID : 공정 코드                       : PK
            -- LINE_ID      : -
            -- SEQ          : 정보 일련번호 - 일, 법인 단위 Sequence
            -- VALUE1       : 충족율 : TARGET_WEEK            : PK - SCP 계획 주차
            -- VALUE2       : 충족율 : NICK_NAME
            -- VALUE3       : 충족율 : Material Code          : PK
            -- VALUE4       : 충족율 : MFG_WEEK               : PK
            -- VALUE5       : 충족율 : TARGET_QTY             : SCP 계획 수량
            -- VALUE6       : 충족율 : PLAN_QTY               : FP 계획 수량
            -- VALUE7       : 충족율 : ACTUAL_GOOD_QTY        : 양품 실적 수량
			-- VALUE8       : 충족율 : SHOP_GROUP_ID          : 공정군 구분 P, A, E

			SET @v_temp2 = 'UPDATE OLD DATA-BASE INFO 012';
			UPDATE A
			SET    VALUE5 = '0', VALUE6 = '0', VALUE7 = '0', UPDATE_TIME = GETDATE()
			FROM   [DBO].[FP_KPI_RAW_DATA_R] A,
                   ( SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, C.WEEK AS TARGET_WEEK
                     FROM    ( SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, MAX(A.SCP_PLAN_ID) AS SCP_PLAN_ID
                               FROM 	FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)
                               GROUP   BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID ) A,
                               SCM_SYS_CALENDAR_M C WITH(NOLOCK)
                     WHERE   C.DATE_ID = CONVERT(DATE,SUBSTRING(A.SCP_PLAN_ID, 0,9),112)  ) B
			WHERE  A.KPI_ID      = '012'
			AND    A.SITE_ID     = @P_SITE_ID
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
			AND    A.PLANT_ID IN ( SELECT V.SEGMENT1
									FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
									WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
									AND    V.ACTIVE_FLAG      = 'Y'
									AND    V.SEGMENT2         = @BASIS_START_TIME
									)
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
			AND    A.PLANT_ID    = B.PLANT_ID
			AND    A.VALUE1      = B.TARGET_WEEK
			AND    A.VALUE8      = B.SHOP_GROUP_ID;

			SET @v_temp2 = 'INSERT 012 DATA'
			MERGE  INTO [DBO].[FP_KPI_RAW_DATA_R] A
			USING ( SELECT  ROW_NUMBER()OVER(ORDER BY B.COMPANY_ID) AS SEQ,
			                B.TARGET_WEEK,
			                B.COMPANY_ID,
							ISNULL((SELECT TOP 1 PD.[ORIGINAL_DIVISION_ID] FROM [DBO].[SCM_PSEUDO_DIVISION_M] AS PD (NOLOCK) WHERE PD.[PLANT_ID] = B.[PLANT_ID]), B.DIVISION_ID) AS DIVISION_ID, -- 2022-03-20 kimcd 가상 Division 전환
							B.SITE_ID,
							B.PLANT_ID,
							B.SHOP_GROUP_ID,
							B.ITEM_ID,
							B.OPERATION_ID,
							B.NICK_NAME,
							B.MFG_WEEK, 
		                    B.TARGET_QTY,
		                    B.PLAN_QTY,
		                    B.ACTUAL_GOOD_QTY
					FROM ( SELECT B.TARGET_WEEK,
								  B.COMPANY_ID,
								  B.DIVISION_ID,
								  B.SITE_ID,
								  B.PLANT_ID,
								  B.SHOP_GROUP_ID,
								  B.ITEM_ID,
								  B.OPERATION_ID,
								  B.NICK_NAME,
								  B.MFG_WEEK, 
								  B.TARGET_QTY,
								  B.PLAN_QTY,
								  B.ACTUAL_GOOD_QTY,
								  ( SELECT V.SEGMENT2
									FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
									WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
									AND    V.ACTIVE_FLAG      = 'Y'
									AND    V.SEGMENT1         = B.PLANT_ID ) AS START_TIME
						   FROM    [FP_KPI_SATISFACTION_V] B
						   WHERE   SITE_ID + '' = @P_SITE_ID ) B  -- 2019-09-27 kimcd 시업 시간 구분되어 plant 시업 시간 검증 로직 추가. sub query 형태로 수정
					WHERE   B.START_TIME = @BASIS_START_TIME
                                )  B
			ON ( A.KPI_ID       = '012'
			AND  A.COMPANY_ID   = B.COMPANY_ID
			AND  A.DIVISION_ID  = B.DIVISION_ID
			AND  A.SITE_ID      = @P_SITE_ID
			AND  A.SITE_ID      = B.SITE_ID
			AND  A.PLANT_ID     = B.PLANT_ID
			AND  A.OPERATION_ID = B.OPERATION_ID
			AND  A.VALUE1       = B.TARGET_WEEK
			AND  A.VALUE3       = B.ITEM_ID
			AND  A.VALUE4       = B.MFG_WEEK
			AND  A.VALUE8       = B.SHOP_GROUP_ID)
			WHEN MATCHED THEN 
				UPDATE
				SET A.VALUE2      = B.NICK_NAME,
					A.VALUE5      = B.TARGET_QTY,       -- SCP 계획
					A.VALUE6      = B.PLAN_QTY,         -- FP 계획
					A.VALUE7      = B.ACTUAL_GOOD_QTY,  -- 실적
					A.KPI_DATE    = CONVERT(DATE,@v_date,120),
					A.UPDATE_TIME = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT ([KPI_ID],       -- : KPI 지표 구분 ID - FP계획 충족율 - 012 : PK
						[KPI_DATE],     -- : 정보 형성 일자
						[COMPANY_ID],   -- : 법인 코드
						[DIVISION_ID],  -- : 사업부 코드
						[SITE_ID],      -- : Site 코드
						[PLANT_ID],     -- : 공장 구분 코드                  : PK
						[FACTORY_ID],   -- : 공장 동 코드 '-'
						[OPERATION_ID], -- : 공정 코드                       : PK
						[LINE_ID],      -- : "-" FP 라인 코드
						[SEQ],          -- : 일련번호 - 일, 법인 단위 Sequence
						[value1],       -- : 충족율 : TARGET_WEEK            : PK - SCP 계획 주차
						[value2],       -- : 충족율 : NICK_NAME
						[value3],       -- : 충족율 : Material Code          : PK
						[value4],       -- : 충족율 : MFG_WEEK               : PK
						[value5],       -- : 충족율 : TARGET_QTY             : SCP 계획 수량
						[value6],       -- : 충족율 : PLAN_QTY               : FP 계획 수량
						[value7],       -- : 충족율 : ACTUAL_GOOD_QTY        : 양품 실적 수량
						[VALUE8],       -- : 충족율 : SHOP_GROUP_ID          : 공정군 구분 P, A, E
						[INSERT_ID],
						[INSERT_TIME],
						[UPDATE_ID],
						[UPDATE_TIME]
						)
				VALUES ( '012'
						,CONVERT(DATE,@v_date,120)
						,B.COMPANY_ID
						,B.DIVISION_ID
						,B.SITE_ID
						,B.PLANT_ID
						,'-'   -- FACTORY_ID
						,B.OPERATION_ID
						,'-'  -- LINE_ID
						,B.SEQ
						,B.TARGET_WEEK
						,B.NICK_NAME
						,B.ITEM_ID
						,B.MFG_WEEK
						,B.TARGET_QTY   -- 분모
						,B.PLAN_QTY     -- 분자
						,B.ACTUAL_GOOD_QTY -- 양품 실적
						,B.SHOP_GROUP_ID
						,@v_proc_name
						,GETDATE() -- INSERT_TIME
						,@v_proc_name
						,GETDATE() -- UPDATE_TIME
						);
			;
			-- 2019-06-13 kimcd 012 SCP타겟-FP계획 충족율 추가 가동율 재활용 종료

			-- 2019-04-23 HI 지표 추가 시작
			-- W/O 미생성 건수
            -- KPI_ID       : HI 지표 구분 ID - W/O 미생성 건 수 - 013 : PK
            -- KPI_DATE     : 정보 형성 일자
            -- COMPANY_ID   : 법인 코드
            -- DIVISION_ID  : 사업부 코드
            -- SITE_ID      : 법인 Site 코드
            -- PLANT_ID     : 공장 구분 코드                  : PK
            -- FACTORY_ID   : 공장 동 코드                    : PK
            -- OPERATION_ID : 공정 코드                       : PK
            -- LINE_ID      : 라인
            -- SEQ          : 정보 일련번호 - 일, 법인 단위 Sequence
            -- VALUE1       : Work Order Id                   : PK
            -- VALUE2       : FP_PLAN_ID                      : PK
            -- VALUE3       : Work Order 형성 여부 Y/N
            -- VALUE4       : ERP 회신 메시지
			-- VALUE5       : ITEM ID         -- 2019-07-09 kimcd 품목 추가
			-- VALUE6       : NICK NAME       -- 2019-07-09 kimcd Nick Name 추가

			SET @v_temp2 = 'DELETE OLD DATA-BASE INFO 013';
			DELETE [DBO].[FP_KPI_RAW_DATA_R]
			WHERE KPI_ID   = '013'
			AND   KPI_DATE = @v_ydate
			AND   SITE_ID  = @P_SITE_ID
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
			AND   PLANT_ID IN ( SELECT V.SEGMENT1
								FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
								WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
								AND    V.ACTIVE_FLAG      = 'Y'
								AND    V.SEGMENT2         = @BASIS_START_TIME
								);
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝

			SET @v_temp2 = 'INSERT DATA-BASE INFO 013';
			INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[SEQ],
				[value1], -- Work Order Id                   : PK
				[value2], -- FP_PLAN_ID                      : PK
				[value3], -- Work Order 형성 여부 S/E
				[value4], -- ERP 회신 메시지
				[value5], -- 2019-07-09 kimcd 품목 추가
				[value6], -- 2019-07-09 kimcd Nick Name 추가
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
				)
			SELECT '013'  AS KPI_ID
				 , @v_ydate
				 , C.COMPANY_ID
				 , ISNULL((SELECT TOP 1 PD.[ORIGINAL_DIVISION_ID] FROM [DBO].[SCM_PSEUDO_DIVISION_M] AS PD (NOLOCK) WHERE PD.[PLANT_ID] = SOURCES.[PLANT_ID]), C.DIVISION_ID) -- 2022-03-20 kimcd 가상 Division 전환
				 , C.SITE_ID
				 , SOURCES.PLANT_ID
				 , SOURCES.FACTORY_ID
				 , SOURCES.OPERATION_ID
				 , ISNULL(H.LINE_ID, SOURCES.LINE_ID) AS LINE_ID
				 , ROW_NUMBER()OVER(ORDER BY C.COMPANY_ID) AS SEQ
				 , SOURCES.WORK_ORDER_ID  -- [value1]
				 , SOURCES.FP_PLAN_ID     -- [value2]
				 , ISNULL(H.ERP_IF_STATUS, 'S') -- [value3]
				 , H.ERP_IF_RETURN        -- [value4]
				 , SOURCES.ITEM_ID        -- 2019-07-09 kimcd 품목 추가 [value5]
				 , SIM.NICK_NAME          -- 2019-07-09 kimcd Nick Name 추가 [value6]
				 , @v_proc_name
				 , GETDATE()
				 , @v_proc_name
				 , GETDATE()
			FROM SY_XIF_ERP_PRODUCTION_PLAN_S SOURCES  with(nolock)
			INNER JOIN ( SELECT RELEASE_PLAN_ID
						FROM ( SELECT D.RELEASE_PLAN_ID 
										, ROW_NUMBER() OVER(PARTITION BY D.DIVISION_ID, D.FACTORY_ID, D.INSTANCE_ID ORDER BY D.DIVISION_ID, D.FACTORY_ID, D.INSTANCE_ID, D.RELEASE_TIME DESC) AS REL_CNT
									FROM SCM_FP_PLAN_H        W WITH(NOLOCK)
										,SCM_FP_PLAN_DETAIL_H D WITH(NOLOCK)
								WHERE W.PLAN_ID =D.RELEASE_PLAN_ID
									AND W.PLAN_TYPE = 'RELEASE'
									AND W.SITE_ID = @P_SITE_ID
									AND D.RELEASE_FLAG = 'Y'
									AND D.MES_TRANSFER_FLAG = 'Y'
									AND D.RELEASE_TIME BETWEEN DATEADD(DAY, -31, CONVERT(DATE, GETDATE()))
															AND DATEADD(DAY, 0, CONVERT(DATE, GETDATE())) 
								UNION ALL
								SELECT D.RELEASE_PLAN_ID 
										, ROW_NUMBER() OVER(PARTITION BY D.PLAN_GROUP_ID, D.INSTANCE_ID ORDER BY D.PLAN_GROUP_ID, D.INSTANCE_ID, D.RELEASE_TIME DESC) AS REL_CNT
									FROM SCM_FP_PLAN_H        W WITH(NOLOCK)
										,SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
								WHERE W.PLAN_ID =D.RELEASE_PLAN_ID
									AND W.PLAN_TYPE = 'RELEASE'
									AND W.SITE_ID = @P_SITE_ID
									AND D.RELEASE_FLAG = 'Y'
									AND D.MES_TRANSFER_FLAG = 'Y'
									AND D.RELEASE_TIME BETWEEN DATEADD(DAY, -31, CONVERT(DATE, GETDATE()))
															AND DATEADD(DAY, 0, CONVERT(DATE, GETDATE())) 
								) A
						WHERE REL_CNT = 1
						) B
				ON SOURCES.FP_PLAN_ID = B.RELEASE_PLAN_ID
			INNER JOIN  SCM_PLANT_M  C WITH(NOLOCK)
				ON SOURCES.PLANT_ID = C.PLANT_ID
			INNER JOIN  SCM_ITEM_M  SIM WITH(NOLOCK)   -- 2019-07-09 kimcd Nick Name 추가
				ON C.COMPANY_ID     = SIM.COMPANY_ID
				AND C.DIVISION_ID   = SIM.DIVISION_ID
				AND C.SITE_ID       = SIM.SITE_ID
				AND SOURCES.ITEM_ID = SIM.ITEM_ID
			LEFT OUTER JOIN FP_ERP_PRODUCTION_PLAN_H  H WITH(NOLOCK)
				ON   H.FP_PLAN_ID = SOURCES.FP_PLAN_ID
				AND  H.WORK_ORDER_ID = SOURCES.WORK_ORDER_ID
			WHERE SOURCES.ATTRIBUTE1 = 'Created'
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
			AND   SOURCES.PLANT_ID IN ( SELECT V.SEGMENT1
										FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
										WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
										AND    V.ACTIVE_FLAG      = 'Y'
										AND    V.SEGMENT2         = @BASIS_START_TIME
										);
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝

			-- Capa 미등록율
            -- KPI_ID       : HI 지표 구분 ID - Capa 미등록율 - 014 : PK
            -- KPI_DATE     : 정보 형성 일자
            -- COMPANY_ID   : 법인 코드
            -- DIVISION_ID  : 사업부 코드
            -- SITE_ID      : 법인 Site 코드
            -- PLANT_ID     : 공장 구분 코드                  : PK
            -- FACTORY_ID   : 공장 동 코드
            -- OPERATION_ID : 공정 코드                       : PK
            -- LINE_ID      : 라인
            -- SEQ          : 정보 일련번호 - 일, 법인 단위 Sequence
            -- VALUE1       : SHOP_GROUP_ID
            -- VALUE2       : ITEM_ID                         : PK
            -- VALUE3       : Capa 등록 여부 Y/N
            -- VALUE4       : MIN WEEK
			-- VALUE5       : SCP_PLAN_ID
			-- VALUE6       : BASE TABLE
			-- VALUE7       : NICK NAME 2019-07-09 kimcd 추가

			SET @v_temp2 = 'DELETE OLD DATA-BASE INFO 014';
			DELETE [DBO].[FP_KPI_RAW_DATA_R]
			WHERE KPI_ID   = '014'
			AND   KPI_DATE = @v_ydate
			AND   SITE_ID  = @P_SITE_ID
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
			AND   PLANT_ID IN ( SELECT V.SEGMENT1
								FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
								WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
								AND    V.ACTIVE_FLAG      = 'Y'
								AND    V.SEGMENT2         = @BASIS_START_TIME
								);
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
			
			SET @TACT_TIME_MONTH = CONVERT(NVARCHAR(6), CONVERT(DATE, @v_ydate, 120), 112)

			SET @v_temp2 = 'INSERT DATA-BASE INFO 014';
			INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[SEQ],
				[value1], -- SHOP_GROUP_ID
				[value2], -- ITEM_ID                         : PK
				[value3], -- Capa 등록 여부 Y/N
				[value4], -- MIN WEEK
				[value5], -- SCP_PLAN_ID
				[value6], -- BASE TABLE
				[value7], -- NICK NAME 2019-07-09 kimcd 추가
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
				)
			SELECT '014'  AS KPI_ID
				 , @v_ydate
				 , B.COMPANY_ID
				 , ISNULL((SELECT TOP 1 PD.[ORIGINAL_DIVISION_ID] FROM [DBO].[SCM_PSEUDO_DIVISION_M] AS PD (NOLOCK) WHERE PD.[PLANT_ID] = B.PLANT_ID), B.DIVISION_ID) -- 2022-03-20 kimcd 가상 Division 전환
				 , B.SITE_ID
				 , B.PLANT_ID
				 , '-'   AS FACTORY_ID
				 , B.OPERATION_ID
				 , '-'   AS LINE_ID
				 , ROW_NUMBER()OVER(ORDER BY B.COMPANY_ID) AS SEQ
				 , B.SHOP_GROUP_ID    -- [value1]
				 , B.ITEM_ID          -- [value2]
				 , ISNULL( (SELECT TOP 1 'Y'
							FROM   SCM_TACT_TIME_M        TT  WITH(NOLOCK)
								 , SCM_ITEM_LINE_ASSIGN_M ILA WITH(NOLOCK)
							     , SCM_LINE_M             L   WITH(NOLOCK)
							WHERE  L.COMPANY_ID     = ILA.COMPANY_ID
							AND    L.DIVISION_ID    = ILA.DIVISION_ID
							AND    L.SITE_ID        = ILA.SITE_ID
							AND    L.PLANT_ID       = ILA.PLANT_ID
							AND    L.FACTORY_ID     = ILA.FACTORY_ID
							AND    L.LINE_ID        = ILA.LINE_ID
							AND    L.OPERATION_ID   = ILA.OPERATION_ID
							AND    L.ELECTRODE_TYPE = ILA.ELECTRODE_TYPE
							AND    L.ACTIVE_FLAG    = 'Y'
							AND    ILA.COMPANY_ID     = TT.COMPANY_ID
							AND    ILA.DIVISION_ID    = TT.DIVISION_ID
							AND    ILA.SITE_ID        = TT.SITE_ID
							AND    ILA.PLANT_ID       = TT.PLANT_ID
							AND    ILA.FACTORY_ID     = TT.FACTORY_ID
							AND    ILA.ITEM_ID        = TT.ITEM_ID
							AND    ILA.LINE_ID        = TT.LINE_ID
							AND    ILA.OPERATION_ID   = TT.OPERATION_ID
							AND    ILA.ELECTRODE_TYPE = TT.ELECTRODE_TYPE
							AND    ILA.MONTH          = TT.MONTH
							AND    ILA.COMPANY_ID     = B.COMPANY_ID
							AND    ILA.DIVISION_ID    = B.DIVISION_ID
							AND    ILA.SITE_ID        = B.SITE_ID
							AND    ILA.PLANT_ID       = B.PLANT_ID
							AND    ILA.ITEM_ID        = B.ITEM_ID
							AND    ILA.OPERATION_ID   = B.OPERATION_ID
							AND    ILA.MONTH         >= @TACT_TIME_MONTH
							AND    (TT.TACT_TIME > 0 OR TT.DAILY_CAPA > 0) ), 'N')                 -- [value3]
				 , MIN(B.MFG_WEEK)    -- [value4]
				 , MIN(B.SCP_PLAN_ID) -- [value5]
				 , MIN(B.SOURCE_TABLE) -- [value6]
				 , MIN(SIM.NICK_NAME)  -- [value7] 2019-07-09 kimcd 추가
				 , @v_proc_name
				 , GETDATE()
				 , @v_proc_name
				 , GETDATE()
			FROM ( SELECT D.COMPANY_ID
						,D.DIVISION_ID
						,D.SITE_ID
						,D.PLANT_ID
						,D.ITEM_ID
						,MIN(D.MFG_WEEK) AS MFG_WEEK
						,D.SHOP_GROUP_ID 
						,D.SCP_PLAN_ID
						,D.OPERATION_ID
						,'SCP PROD TARGET' AS SOURCE_TABLE
					FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_H] D WITH(NOLOCK)
						,( SELECT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID , DIVISION_ID, SHOP_GROUP_ID
							FROM [FP_WEEKLY_DEMAND_PRODUCT_H]	WITH(NOLOCK)
							GROUP BY DIVISION_ID , SHOP_GROUP_ID ) M
						,( SELECT SFM.COMPANY_ID, SFM.DIVISION_ID, SFM.SITE_ID, SFM.PLANT_ID, SFM.SHOP_GROUP_ID, MAX(SSC.WEEK) AS WEEK
							FROM   SCM_FACTORY_M          SFM WITH(NOLOCK)
								, FP_INSTANCE_FACTORY_M  IFM WITH(NOLOCK)
								, SCM_SYS_LOOKUP_VALUE   SLV WITH(NOLOCK)
								, SCM_SYS_CALENDAR_M     SSC WITH(NOLOCK)
							WHERE  SFM.FACTORY_ID     = IFM.FACTORY_ID
							AND    SFM.SHOP_GROUP_ID  = IFM.SHOP_GROUP_ID
							AND    IFM.ACTIVE_FLAG    = 'Y'
							AND    SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
							AND    SLV.SEGMENT1       = IFM.INSTANCE_ID
							AND    SLV.ACTIVE_FLAG    = 'Y'
							AND    SFM.SITE_ID        = @P_SITE_ID
							-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
							AND    SFM.PLANT_ID IN (SELECT V.SEGMENT1
													FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
													WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
													AND    V.ACTIVE_FLAG      = 'Y'
													AND    V.SEGMENT2         = @BASIS_START_TIME
													)
							-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
							AND    SSC.DATE_ID = CONVERT( DATE, DATEADD(D,(CONVERT(NUMERIC(10,2),SLV.ATTRIBUTE15)-1)*7,GETDATE()))
							GROUP  BY SFM.COMPANY_ID, SFM.DIVISION_ID, SFM.SITE_ID, SFM.PLANT_ID, SFM.SHOP_GROUP_ID ) S
					WHERE D.SCP_PLAN_ID   = M.SCP_PLAN_ID
					AND   D.DIVISION_ID   = M.DIVISION_ID
					AND   D.SHOP_GROUP_ID = M.SHOP_GROUP_ID
					AND   D.SITE_ID       = @P_SITE_ID
					AND   D.MFG_QTY       > 0
					AND   D.COMPANY_ID    = S.COMPANY_ID
					AND   D.DIVISION_ID   = S.DIVISION_ID
					AND   D.SITE_ID       = S.SITE_ID
					AND   D.PLANT_ID      = S.PLANT_ID
					AND   D.SHOP_GROUP_ID = S.SHOP_GROUP_ID
					AND   D.MFG_WEEK     <= S.WEEK
					AND   D.OPERATION_ID IN ('A3000','A9000','E2000','P5500','P9500')
					GROUP BY D.COMPANY_ID
						,D.DIVISION_ID
						,D.SITE_ID
						,D.PLANT_ID
						,D.ITEM_ID
						,D.SHOP_GROUP_ID 
						,D.SCP_PLAN_ID
						,D.OPERATION_ID
				UNION ALL
					SELECT D.COMPANY_ID
						,D.DIVISION_ID
						,D.SITE_ID
						,D.PLANT_ID
						,D.ITEM_ID
						,MIN(D.MFG_WEEK ) AS MFG_WEEK
						,SUBSTRING(D.OPERATION_ID,1,1) AS SHOP_GROUP_ID 
						,D.SCP_PLAN_ID
						,D.OPERATION_ID
						,'TEST TARGET' AS SOURCE_TABLE
					FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_TEST_H] D WITH(NOLOCK)
						,( SELECT SFM.COMPANY_ID, SFM.DIVISION_ID, SFM.SITE_ID, SFM.PLANT_ID, SFM.SHOP_GROUP_ID, MAX(SSC.WEEK) AS WEEK
							FROM   SCM_FACTORY_M          SFM WITH(NOLOCK)
								, FP_INSTANCE_FACTORY_M  IFM WITH(NOLOCK)
								, SCM_SYS_LOOKUP_VALUE   SLV WITH(NOLOCK)
								, SCM_SYS_CALENDAR_M     SSC WITH(NOLOCK)
							WHERE  SFM.FACTORY_ID     = IFM.FACTORY_ID
							AND    SFM.SHOP_GROUP_ID  = IFM.SHOP_GROUP_ID
							AND    IFM.ACTIVE_FLAG    = 'Y'
							AND    SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
							AND    SLV.SEGMENT1       = IFM.INSTANCE_ID
							AND    SLV.ACTIVE_FLAG    = 'Y'
							AND    SFM.SITE_ID        = @P_SITE_ID
							-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
							AND    SFM.PLANT_ID IN (SELECT V.SEGMENT1
													FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
													WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
													AND    V.ACTIVE_FLAG      = 'Y'
													AND    V.SEGMENT2         = @BASIS_START_TIME
													)
							-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
							AND    SSC.DATE_ID = CONVERT( DATE, DATEADD(D,(CONVERT(NUMERIC(10,2),SLV.ATTRIBUTE15)-1)*7,GETDATE()))
							GROUP  BY SFM.COMPANY_ID, SFM.DIVISION_ID, SFM.SITE_ID, SFM.PLANT_ID, SFM.SHOP_GROUP_ID ) S
					WHERE D.SITE_ID       = @P_SITE_ID
					AND   D.MFG_QTY       > 0
					AND   D.COMPANY_ID    = S.COMPANY_ID
					AND   D.DIVISION_ID   = S.DIVISION_ID
					AND   D.SITE_ID       = S.SITE_ID
					AND   D.PLANT_ID      = S.PLANT_ID
					AND   SUBSTRING(D.OPERATION_ID,1,1) = S.SHOP_GROUP_ID
					AND   D.DUE_DATE     >= @v_ydate
					AND   D.MFG_WEEK     <= S.WEEK
					AND   D.OPERATION_ID IN ('A3000','A9000','E2000','P5500','P9500')
					GROUP BY D.COMPANY_ID
						,D.DIVISION_ID
						,D.SITE_ID
						,D.PLANT_ID
						,D.ITEM_ID
						,SUBSTRING(D.OPERATION_ID,1,1)
						,D.SCP_PLAN_ID
						,D.OPERATION_ID ) B
			INNER JOIN  SCM_ITEM_M  SIM WITH(NOLOCK)   -- 2019-07-09 kimcd Nick Name 추가
				ON B.COMPANY_ID   = SIM.COMPANY_ID
				AND B.DIVISION_ID = SIM.DIVISION_ID
				AND B.SITE_ID     = SIM.SITE_ID
				AND B.ITEM_ID     = SIM.ITEM_ID
			GROUP BY B.COMPANY_ID
					 , B.DIVISION_ID
					 , B.SITE_ID
					 , B.PLANT_ID
					 , B.OPERATION_ID
					 , B.SHOP_GROUP_ID    -- [value1]
					 , B.ITEM_ID          -- [value2]

			-- SCP Target 기준 수율 등록 건수
            -- KPI_ID       : HI 지표 구분 ID - SCP Target 기준 수율 등록 건수 - 015 : PK
            -- KPI_DATE     : 정보 형성 일자
            -- COMPANY_ID   : 법인 코드
            -- DIVISION_ID  : 사업부 코드
            -- SITE_ID      : 법인 Site 코드
            -- PLANT_ID     : 공장 구분 코드                  : PK
            -- FACTORY_ID   : 공장 동 코드
            -- OPERATION_ID : 공정 코드                       : PK
            -- LINE_ID      : 라인
            -- SEQ          : 정보 일련번호 - 일, 법인 단위 Sequence
            -- VALUE1       : SHOP_GROUP_ID
            -- VALUE2       : ITEM_ID                         : PK
            -- VALUE3       : 수율 등록 여부 Y/N
            -- VALUE4       : MIN WEEK
			-- VALUE5       : SCP_PLAN_ID
			-- VALUE6       : BASE TABLE

			SET @v_temp2 = 'DELETE OLD DATA-BASE INFO 015';
			DELETE [DBO].[FP_KPI_RAW_DATA_R]
			WHERE KPI_ID   = '015'
			AND   KPI_DATE = @v_ydate
			AND   SITE_ID  = @P_SITE_ID
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
			AND   PLANT_ID IN ( SELECT V.SEGMENT1
								FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
								WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
								AND    V.ACTIVE_FLAG      = 'Y'
								AND    V.SEGMENT2         = @BASIS_START_TIME
								);
			-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
			
			SET @TACT_TIME_MONTH = CONVERT(NVARCHAR(6), CONVERT(DATE, @v_ydate, 120), 112)

			SET @v_temp2 = 'INSERT DATA-BASE INFO 015';
			INSERT INTO [DBO].[FP_KPI_RAW_DATA_R](
				[KPI_ID],
				[KPI_DATE],
				[COMPANY_ID],
				[DIVISION_ID],
				[SITE_ID],
				[PLANT_ID],
				[FACTORY_ID],
				[OPERATION_ID],
				[LINE_ID],
				[SEQ],
				[value1], -- SHOP_GROUP_ID
				[value2], -- ITEM_ID                         : PK
				[value3], -- 수율 등록 여부 Y/N
				[value4], -- MIN WEEK
				[value5], -- SCP_PLAN_ID
				[value6], -- BASE TABLE
				[INSERT_ID],
				[INSERT_TIME],
				[UPDATE_ID],
				[UPDATE_TIME]
				)
			SELECT '015'  AS KPI_ID
				 , @v_ydate
				 , B.COMPANY_ID
				 , ISNULL((SELECT TOP 1 PD.[ORIGINAL_DIVISION_ID] FROM [DBO].[SCM_PSEUDO_DIVISION_M] AS PD (NOLOCK) WHERE PD.[PLANT_ID] = B.PLANT_ID), B.DIVISION_ID) -- 2022-03-20 kimcd 가상 Division 전환
				 , B.SITE_ID
				 , B.PLANT_ID
				 , '-'   AS FACTORY_ID
				 , B.OPERATION_ID
				 , '-'   AS LINE_ID
				 , ROW_NUMBER()OVER(ORDER BY B.COMPANY_ID) AS SEQ
				 , B.SHOP_GROUP_ID    -- [value1]
				 , B.ITEM_ID          -- [value2]
				 , ISNULL( (SELECT TOP 1 'Y'
							FROM   SCM_YIELD_M        TT  WITH(NOLOCK)
								 , SCM_ITEM_LINE_ASSIGN_M ILA WITH(NOLOCK)
							     , SCM_LINE_M             L   WITH(NOLOCK)
							WHERE  L.COMPANY_ID     = ILA.COMPANY_ID
							AND    L.DIVISION_ID    = ILA.DIVISION_ID
							AND    L.SITE_ID        = ILA.SITE_ID
							AND    L.PLANT_ID       = ILA.PLANT_ID
							AND    L.FACTORY_ID     = ILA.FACTORY_ID
							AND    L.LINE_ID        = ILA.LINE_ID
							AND    L.OPERATION_ID   = ILA.OPERATION_ID
							AND    L.ELECTRODE_TYPE = ILA.ELECTRODE_TYPE
							AND    L.ACTIVE_FLAG    = 'Y'
							AND    ILA.COMPANY_ID     = TT.COMPANY_ID
							AND    ILA.DIVISION_ID    = TT.DIVISION_ID
							AND    ILA.SITE_ID        = TT.SITE_ID
							AND    ILA.PLANT_ID       = TT.PLANT_ID
							AND    ILA.FACTORY_ID     = TT.FACTORY_ID
							AND    ILA.ITEM_ID        = TT.ITEM_ID
							AND    ILA.LINE_ID        = TT.LINE_ID
							AND    ILA.OPERATION_ID   = TT.OPERATION_ID
							AND    ILA.MONTH          = TT.MONTH
							AND    ILA.COMPANY_ID     = B.COMPANY_ID
							AND    ILA.DIVISION_ID    = B.DIVISION_ID
							AND    ILA.SITE_ID        = B.SITE_ID
							AND    ILA.PLANT_ID       = B.PLANT_ID
							AND    ILA.ITEM_ID        = B.ITEM_ID
							AND    ILA.OPERATION_ID   = B.OPERATION_ID
							AND    ILA.MONTH         >= @TACT_TIME_MONTH
							AND    TT.YIELD > 0 ), 'N')                 -- [value3]
				 , MIN(B.MFG_WEEK)    -- [value4]
				 , MIN(B.SCP_PLAN_ID) -- [value5]
				 , MIN(B.SOURCE_TABLE) -- [value6]
				 , @v_proc_name
				 , GETDATE()
				 , @v_proc_name
				 , GETDATE()
			FROM ( SELECT D.COMPANY_ID
						,D.DIVISION_ID
						,D.SITE_ID
						,D.PLANT_ID
						,D.ITEM_ID
						,MIN(D.MFG_WEEK) AS MFG_WEEK
						,D.SHOP_GROUP_ID 
						,D.SCP_PLAN_ID
						,D.OPERATION_ID
						,'SCP PROD TARGET' AS SOURCE_TABLE
					FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_H] D WITH(NOLOCK)
						,( SELECT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID , DIVISION_ID, SHOP_GROUP_ID
							FROM [FP_WEEKLY_DEMAND_PRODUCT_H]	WITH(NOLOCK)
							GROUP BY DIVISION_ID , SHOP_GROUP_ID ) M
						,( SELECT SFM.COMPANY_ID, SFM.DIVISION_ID, SFM.SITE_ID, SFM.PLANT_ID, SFM.SHOP_GROUP_ID, MAX(SSC.WEEK) AS WEEK
							FROM   SCM_FACTORY_M          SFM WITH(NOLOCK)
								, FP_INSTANCE_FACTORY_M  IFM WITH(NOLOCK)
								, SCM_SYS_LOOKUP_VALUE   SLV WITH(NOLOCK)
								, SCM_SYS_CALENDAR_M     SSC WITH(NOLOCK)
							WHERE  SFM.FACTORY_ID     = IFM.FACTORY_ID
							AND    SFM.SHOP_GROUP_ID  = IFM.SHOP_GROUP_ID
							AND    IFM.ACTIVE_FLAG    = 'Y'
							AND    SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
							AND    SLV.SEGMENT1       = IFM.INSTANCE_ID
							AND    SLV.ACTIVE_FLAG    = 'Y'
							AND    SFM.SITE_ID        = @P_SITE_ID
							-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
							AND    SFM.PLANT_ID IN (SELECT V.SEGMENT1
													FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
													WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
													AND    V.ACTIVE_FLAG      = 'Y'
													AND    V.SEGMENT2         = @BASIS_START_TIME
													)
							-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
							AND    SSC.DATE_ID = CONVERT( DATE, DATEADD(D,(CONVERT(NUMERIC(10,2),SLV.ATTRIBUTE15)-1)*7,GETDATE()))
							GROUP  BY SFM.COMPANY_ID, SFM.DIVISION_ID, SFM.SITE_ID, SFM.PLANT_ID, SFM.SHOP_GROUP_ID ) S
					WHERE D.SCP_PLAN_ID   = M.SCP_PLAN_ID
					AND   D.DIVISION_ID   = M.DIVISION_ID
					AND   D.SHOP_GROUP_ID = M.SHOP_GROUP_ID
					AND   D.SITE_ID       = @P_SITE_ID
					AND   D.MFG_QTY       > 0
					AND   D.COMPANY_ID    = S.COMPANY_ID
					AND   D.DIVISION_ID   = S.DIVISION_ID
					AND   D.SITE_ID       = S.SITE_ID
					AND   D.PLANT_ID      = S.PLANT_ID
					AND   D.SHOP_GROUP_ID = S.SHOP_GROUP_ID
					AND   D.MFG_WEEK     <= S.WEEK
					AND   D.OPERATION_ID IN ('A3000','A9000','E2000','P5500','P9500')
					GROUP BY D.COMPANY_ID
						,D.DIVISION_ID
						,D.SITE_ID
						,D.PLANT_ID
						,D.ITEM_ID
						,D.SHOP_GROUP_ID 
						,D.SCP_PLAN_ID
						,D.OPERATION_ID
				UNION ALL
					SELECT D.COMPANY_ID
						,D.DIVISION_ID
						,D.SITE_ID
						,D.PLANT_ID
						,D.ITEM_ID
						,MIN(D.MFG_WEEK ) AS MFG_WEEK
						,SUBSTRING(D.OPERATION_ID,1,1) AS SHOP_GROUP_ID 
						,D.SCP_PLAN_ID
						,D.OPERATION_ID
						,'TEST TARGET' AS SOURCE_TABLE
					FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_TEST_H] D WITH(NOLOCK)
						,( SELECT SFM.COMPANY_ID, SFM.DIVISION_ID, SFM.SITE_ID, SFM.PLANT_ID, SFM.SHOP_GROUP_ID, MAX(SSC.WEEK) AS WEEK
							FROM   SCM_FACTORY_M          SFM WITH(NOLOCK)
								, FP_INSTANCE_FACTORY_M  IFM WITH(NOLOCK)
								, SCM_SYS_LOOKUP_VALUE   SLV WITH(NOLOCK)
								, SCM_SYS_CALENDAR_M     SSC WITH(NOLOCK)
							WHERE  SFM.FACTORY_ID     = IFM.FACTORY_ID
							AND    SFM.SHOP_GROUP_ID  = IFM.SHOP_GROUP_ID
							AND    IFM.ACTIVE_FLAG    = 'Y'
							AND    SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
							AND    SLV.SEGMENT1       = IFM.INSTANCE_ID
							AND    SLV.ACTIVE_FLAG    = 'Y'
							AND    SFM.SITE_ID        = @P_SITE_ID
							-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 시작
							AND    SFM.PLANT_ID IN (SELECT V.SEGMENT1
													FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
													WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
													AND    V.ACTIVE_FLAG      = 'Y'
													AND    V.SEGMENT2         = @BASIS_START_TIME
													)
							-- 2019-09-27 kimcd 시업 시간 기준으로 PLANT_ID 조건 추가 끝
							AND    SSC.DATE_ID = CONVERT( DATE, DATEADD(D,(CONVERT(NUMERIC(10,2),SLV.ATTRIBUTE15)-1)*7,GETDATE()))
							GROUP  BY SFM.COMPANY_ID, SFM.DIVISION_ID, SFM.SITE_ID, SFM.PLANT_ID, SFM.SHOP_GROUP_ID ) S
					WHERE D.SITE_ID       = @P_SITE_ID
					AND   D.MFG_QTY       > 0
					AND   D.COMPANY_ID    = S.COMPANY_ID
					AND   D.DIVISION_ID   = S.DIVISION_ID
					AND   D.SITE_ID       = S.SITE_ID
					AND   D.PLANT_ID      = S.PLANT_ID
					AND   SUBSTRING(D.OPERATION_ID,1,1) = S.SHOP_GROUP_ID
					AND   D.DUE_DATE     >= @v_ydate
					AND   D.MFG_WEEK     <= S.WEEK
					AND   D.OPERATION_ID IN ('A3000','A9000','E2000','P5500','P9500')
					GROUP BY D.COMPANY_ID
						,D.DIVISION_ID
						,D.SITE_ID
						,D.PLANT_ID
						,D.ITEM_ID
						,SUBSTRING(D.OPERATION_ID,1,1)
						,D.SCP_PLAN_ID
						,D.OPERATION_ID ) B
			GROUP BY B.COMPANY_ID
					 , B.DIVISION_ID
					 , B.SITE_ID
					 , B.PLANT_ID
					 , B.OPERATION_ID
					 , B.SHOP_GROUP_ID    -- [value1]
					 , B.ITEM_ID          -- [value2]
			-- 2019-04-23 HI 지표 추가 끝
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		select @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END


