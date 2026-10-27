

--CREATE PROCEDURE [dbo].[PR_XIF_PLM_WO_INSP_SPEC_R]
CREATE PROCEDURE [dbo].[PR_XIF_PLM_WO_INSP_SPEC_R]

-- ================================================================================================
-- Program ID          : FP02661
-- Program Name        : PR_XIF_PLM_WO_INSP_SPEC_R
-- Param               :
-- Batch Period        : 1 DAY
-- Description         :
--
-- Source System       : PLM
-- Destination System  : FP SDB

-- Source Table        : SY_XIF_PLM_WO_INSP_SPEC_R, SY_XIF_PLM_WO_SPEC_R
--						 SY_XIF_PLM_MIXER_MTRL_R
-- Destination Table   : 
--                       FP_PROD_VERSION_M
--                       SCM_PLM_WO_TACT_TIME_M
--                       SCM_TACT_TIME_M
--                       SCM_ITEM_EQUIP_RATE_BATCH_M
--                       SCM_ITEM_LANE_M
--                       SCM_ITEM_EQUIP_RATE_BATCH_M
--                       SCM_ITEM_FOIL_M
--                       SCM_SLURRY_SOLID_RATE
--                       FP_PROD_VERSION_APPLY_DATE_M
--
-- Create Date		   : 2017.07.03	FP02661
-- Update Date		   : 2017.08.07 1.1	PIYONG
--					   : 2017.08.22 1.3 PIYONG
--						 2017.08.28 1.4 PIYONG
--						 2017.09.01 1.5 PIYONG
--						 2017.10.10 1.6 PIYONG
--						 2017.11.24 1.7 PIYONG
--						 2017.11.30 1.8 PIYONG
--						 2018.04.12 2.0 PIYONG
--						 2018.04.24 3.0 PIYONG
--						 2018.05.02 3.1 PIYONG
--						 2018.05.17 3.2 PIYONG
--						 2018.06.26	4.0 PIYONG
--						 2018.09.10 5.0 PIYONG
--						 2018.10.22 5.1 PIYONG
--						 2019.01.15 5.2 PIYONG
--						 2019.02.18 6.0 PIYONG
--						 2019.02.25 6.1 PIYONG
--						 2019.03.04 6.2 PIYONG
--						 2019.03.28 6.3 PIYONG
--						 2019.03.29 6.4 PIYONG
--						 2019.04.08 6.5 PIYONG
--						 2019.04.19 6.6 PIYONG
--						 2019.04.26 6.7 PIYONG
--						 2019.10.07 6.8 PIYONG
--						 2020.06.11 6.9 PIYONG
--                       2021.05.14 6.91 kimcd
--                       2022.04.14 7.0 김현
--                       2022.05.23 7.1 kimcd

-- Author              : PIYONG
-- Version             : 1.0
--					   : 1.1  TACT_TIME FACTORY가 E7일경우 E8로 변경
--                     : 1.2  kimcd 2017-08-22 정권 길이에서 숫자만 수신 조건 추가
--						 1.3  슬리팅(E400)	조건 추가 - 숫자만 받음
--						 1.4  정권길이 조회 쿼리 수정
--						 1.5  정권길이 조회 쿼리 수정 SY_XIF_PLM_WO_ORDER_R -> SY_XIF_PLM_WO_INSP_SPEC_R
--						 1.6  PROC_FLAG P로 변경조건 변경
--							  PROD_VER_CODE의 값이 Z로 시작하는 데이터는 제외(테스트 데이터)
--						 1.7  LOT_SIZE,  E2000, E3000, E4000 NUM ORDERBY 조건 추가
--						 1.8  ROWNUM  ORDER BY 조건 차수 (ISNULL( ATTR_01, '00') DESC)  추가
--						 2.0  TAT 생성 추가
--						 3.0  TAT_TIME MASTER 테이블 변경, 같은 ITEM에 2개이상의 TAT_TIME 처리 로직 추가
--							  FOIL 생성 추가
--							  LANE 수 추가
--							  E8동 조회 쿼리 삭제
--						 3.1  SCM_ITEM_EQUIP_RATE_BATCH_M ACTIVE_FLAG  입력 추가
--						 3.2  테스트 버전도 적용
--							  E8동 주석처리한 로직 삭제
--						 4.0  남경 소형 전극 3,4라인( 광폭) 구분  로직 추가
--						 5.0  PROD VERSION 별 적용일자 추가
--						 5.1  남경 소형 전극 3,4라인( 광폭) 구분  로직 수정 SPEC_ITEM_ID 종류 추가
--						 5.2  CNA  2,3라인 구분 로직 추가 
--						 6.0  고형분 비율 수신 추가
--						 6.1  CUR_SL_LANE 에 값이 10/11 경우 10으로 값 처리
--						 6.2  FOIL 수신 테이블 변경
--						 6.3  장현석 책임 요청 SCM_ITEM_LANE_M 테이블 LANE 정보 수신 삭제(작업의뢰 LANE 정보가 신뢰되지 않아)
--						 6.4  고형분 비율 차수 적용
--						 6.5  작업의뢰 적용일자 대상 조건 변경
--						 6.6  작업의뢰 적용일자 대상 단면 반제품 생성 로직 추가
--						 6.7  적용일자의 ORDER_TYPE 수신
--						 6.8  R/P, SL  TACT TIME  생성 기준 테이블 변경  SCM_ITEM_LINE_ASSIGN_M ->  SCM_LINE_M
--						 6.9 적용 일자 생성 조건 추가
--                       6.91 2021-05-14 kimcd SCM_ITEM_LANE_M UPDATE ID가 PR_XIF_PLM_CONVERSION_RATE_R 인 경우 변경자는 바꾸지 않음
--                       7.0 2022-04-14 김현 [C20220328-000596]NFF 셀 유형 추가에 따른 정보 수신 로직 변경. Jumbo Roll 정권 길이 추가
--                       7.1 2022-05-23 kimcd 전극 후 공정의 Pancake, Jumbo Roll 정권 길이 추가
--                       7.2 2022-12-02 kimcd 작업의뢰서 Version 정보 형성은 Flag 없이 시간만 제한
--                                            작업의뢰서 Version 정보에서 X로 시작하는 것은 받지 않음
--                                            전극 버전별 계획 수립을 위해 Version 부여 로직을 환산자와 통일
--                       7.3 2024-04-02 kimcd 작업 오류로 CUR_RP_TAT_TIME에 숫자 검증 문장 추가
--                       7.4 2024-04-01 FP Pjt NFF 신코드 반영  --CUR_SL_LANE / CUR_INSULATION_COATING 미사용 처리
-- 2026.08.04    kimcd   7.5 [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
-- ================================================================================================

-- PARAM


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PLM_WO_INSP_SPEC_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	declare @v_err_check nvarchar(1000)
	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @FACTORY_ID     NVARCHAR(50)
	DECLARE @OPERATION_ID	NVARCHAR(50)
	DECLARE @ITEM_ID		NVARCHAR(150)
	DECLARE @UNIT			NVARCHAR(50)
	DECLARE @LOT_SIZE		NUMERIC(20,10)
	
	DECLARE @COMPANY_ID     NVARCHAR(30)
	DECLARE @DIVISION_ID    NVARCHAR(30)
	DECLARE @SITE_ID		NVARCHAR(30)
	DECLARE @PLANT_ID		NVARCHAR(30)
	DECLARE @LINE_ID		NVARCHAR(30)
	DECLARE @ELECTRODE_TYPE NVARCHAR(20)
	DECLARE @MONTH			NVARCHAR(6)
	DECLARE @TAT_TIME		NUMERIC(18,4)
	DECLARE @TAT			NUMERIC(20,10)
	DECLARE @IS_DOUBLE		NVARCHAR(1)
	DECLARE @LENGTH			NUMERIC(18,3)
	DECLARE @CNT			NUMERIC(18,3)
	DECLARE @WO_ID			NVARCHAR(50)
	DECLARE @WO_SEQ			NVARCHAR(50)
	DECLARE @CATEGORY		NVARCHAR(150)	--2018-04-24 PIYONG ADD
	DECLARE @FOIL_ID		NVARCHAR(150)	--2018-04-24 PIYONG ADD
	DECLARE @PROD_VER_CODE	NVARCHAR(50)	--2018-04-24 PIYONG ADD
	DECLARE @SPEC_ITEM_ID	NVARCHAR(50)	--2018-04-24 PIYONG ADD
	DECLARE @MAIN_QTY		NUMERIC(20,10)	--2018-04-24 PIYONG ADD
	DECLARE @SUB_QTY		NUMERIC(20,10)	--2018-04-24 PIYONG ADD
	DECLARE @PROD_VERSION_TYPE	NVARCHAR(50)	--2018-06-26 PIYONG ADD
	DECLARE @MODEL_ID			NVARCHAR(150)	--2018-09-10 PIYONG ADD
	DECLARE @PROD_VER_SEQ		NVARCHAR(10)	--2018-09-10 PIYONG ADD
	DECLARE @APPLY_DATE			DATE			--2018-09-10 PIYONG ADD
	DECLARE @ORDER_APPLY_DATE	DATETIME		--2019-03-14 PIYONG ADD

	DECLARE @CHILD_CLASS_NAME	NVARCHAR(300)	--2019-02-18 PIYONG ADD
	DECLARE @CHILD_ITEM_ID		NVARCHAR(50)	--2019-02-18 PIYONG ADD
	DECLARE @CHILD_ITEM_NAME	NVARCHAR(1000)	--2019-02-18 PIYONG ADD
	DECLARE @SOLID_RATE			NUMERIC(18,5)	--2019-02-18 PIYONG ADD

	DECLARE @ORDER_TYPE	NVARCHAR(30)	--2019-04-19 PIYONG ADD												 
	DECLARE @POST_TYPE  NVARCHAR(30)    --2022-05-23 E3000E4000 형성 여부


	DECLARE CUR_LOT_SIZE CURSOR FOR
		SELECT [AREA_ID]
			   ,[PROC_ID]
			   ,[PRODID]
			   ,[UNIT]
			   ,CAST( [VALUE1] AS NUMERIC(20, 10) ) AS LOT_SIZE
			   ,ISNULL(SSLV2.ATTRIBUTE1, ISNULL(SSLV.ATTRIBUTE1,'GENERAL') ) AS PROD_VERSION_TYPE	-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영. 버전 유형 로직 추가 2018-06-26 PIYONG ADD
		  FROM (
				SELECT [AREA_ID]
					   ,[PROC_ID]
					   ,[PRODID]
					   ,UPPER([UNIT]) AS UNIT
					   ,PROD_VER_CODE
					   ,REPLACE([VALUE1], ',' , '') AS [VALUE1]
					   ,ATTR_04						--2018-06-26 PIYONG ADD
   					   ,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID 
											   ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
															 WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
															 WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
															 ELSE PROD_VER_CODE END DESC	--2018-05-11 PIYONG ADD 테스트버전 포함
													 , ISNULL( ATTR_01, '00') DESC
													 , IF_SEQ DESC						 ) NUM	--2017-11-30 PIYONG 차수 조건 추가
				  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
				 WHERE PROC_ID = 'E1000'
				   AND SPEC_ITEM_ID LIKE    'I-%-SPEC-%2'
				   AND SPEC_ITEM_ID != 'I-M001-SPEC-002'   --nff 구코드 -- 2022-04-14 김현 [C20220328-000596] NFF 부등호 조건 추가
				   AND SPEC_ITEM_ID != 'I-M001-SPEC-012'   --nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-002'   --nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-004_2' --nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-005_2' --nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-012'   --nff 구코드 
				   AND PRODID IS NOT NULL
				   AND VALUE1 IS NOT NULL
				   AND ATTR_04 IS NULL				--2018-06-26 PIYONG ADD
				   AND PROC_FLAG = 'P'
				----------------------------------------------------------------------------------------------------------------------------------------------
				--2018-06-26 PIYONG ADD
				UNION ALL
				SELECT [AREA_ID]
					   ,[PROC_ID]
					   ,[PRODID]
					   ,UPPER([UNIT]) AS UNIT
					   ,PROD_VER_CODE
					   ,REPLACE([VALUE1], ',' , '') AS [VALUE1]
					   ,ATTR_04
   					   ,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID, ATTR_04
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
				  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
				 WHERE PROC_ID = 'E1000'
				   AND SPEC_ITEM_ID LIKE    'I-%-SPEC-%2'
				   AND SPEC_ITEM_ID != 'I-M001-SPEC-002'   --nff 구코드 -- 2022-04-14 김현 [C20220328-000596] NFF 부등호 조건 추가
				   AND SPEC_ITEM_ID != 'I-M001-SPEC-012'   --nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-002'   --nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-004_2' --nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-005_2' --nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-012'   --nff 구코드 
				   AND PRODID IS NOT NULL
				   AND VALUE1 IS NOT NULL
				   AND ATTR_04 IS NOT NULL
				   AND PROC_FLAG = 'P'
			    --2018-06-26 PIYONG ADD
				----------------------------------------------------------------------------------------------------------------------------------------------
			   ) A
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV
				       ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					  AND SEGMENT4 = A.AREA_ID
					  AND SEGMENT5 = A.ATTR_04  -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV2   -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
				       ON SSLV2.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					  AND SSLV2.SEGMENT4   = SSLV.SEGMENT4
					  AND SSLV2.ATTRIBUTE2 = SSLV.SEGMENT5
		 WHERE NUM  = 1
	;

	--	2017-08-28 PIYONG	정권길이 조회 쿼리 수정
	--	2017-09-01 PIYONG	정권길이 조회 쿼리 수정 SY_XIF_PLM_WO_ORDER_R -> SY_XIF_PLM_WO_INSP_SPEC_R
	DECLARE CUR_PC_ROLL CURSOR FOR
		SELECT [AREA_ID]
			   ,[PRODID]
			   ,[VALUE1]
			   ,[WO_ID]
			   ,ISNULL(SSLV3.ATTRIBUTE1, ISNULL(SSLV.ATTRIBUTE1,'GENERAL') ) AS PROD_VERSION_TYPE	-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영. 버전 유형 로직 추가 2018-06-26 PIYONG ADD
			   ,(SELECT TOP 1 SSLV2.ATTRIBUTE1
				FROM    SCM_SYS_LOOKUP_VALUE SSLV2 (NOLOCK)
				WHERE   SSLV2.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
				AND     SSLV2.SEGMENT4 = A.AREA_ID
				AND     SSLV2.SEGMENT5 = 'E3000E4000' )   AS POST_TYPE -- 2022-05-23 E3000E4000 형성 여부
		  FROM (
				 SELECT PRODID
						,AREA_ID
						,WO_ID
						,ATTR_01 AS [VALUE1]
						,ATTR_04									 --2018-06-26 PIYONG ADD
				   FROM (
							SELECT [PRODID]
									,[AREA_ID]
									,REPLACE(REPLACE(VALUE1,',',''), 'M','') AS [ATTR_01]
									,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID
														    ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																			 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																		  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																		  WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
																		  ELSE PROD_VER_CODE END DESC	--2018-05-11 PIYONG ADD 테스트버전 포함
																  , ISNULL( ATTR_01, '00') DESC  ) NUM	--2017-11-30 PIYONG 차수 조건 추가
									,WO_ID
									,ATTR_04						 --2018-06-26 PIYONG ADD
							  FROM [SY_XIF_PLM_WO_INSP_SPEC_R]
							 WHERE PROC_ID = 'E4000'
							   AND ( SPEC_ITEM_ID LIKE 'I-%011-SPECE-010' OR SPEC_ITEM_ID LIKE 'I-%016-SPECAE-010' 
			   --      OR SPEC_ITEM_ID = 'I-M011-SPECE-023' --nff 신코드 없음
					 --OR SPEC_ITEM_ID = 'I-M016-SPECA-023' --nff 신코드 없음
								   )
							   AND SPEC_ITEM_ID != 'I-M011-SPECE-006' --> 'I-M011-SPECE-010'  --nff
							   AND SPEC_ITEM_ID != 'I-M016-SPECA-005' --> 'I-M016-SPECA-010'  --nff 2022-04-14 김현 [C20220328-000596] NFF 유형용 조건 조정
							   AND [VALUE1] IS NOT NULL
							   AND [PRODID] IS NOT NULL
--							   AND [PROD_VER_CODE] NOT LIKE 'Z%'	--2018-05-11 PIYONG DEL  테스트 버전도 포함
							   AND ATTR_04 IS NULL					--2018-06-26 PIYONG ADD			
							   AND PROC_FLAG = 'P'
							----------------------------------------------------------------------------------------------------------------------------------------------
							 --2018-06-26 PIYONG ADD
							 UNION ALL
							 SELECT [PRODID]
									,[AREA_ID]
									,REPLACE(REPLACE(VALUE1,',',''), 'M','') AS [ATTR_01]
									,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, ATTR_04
														    ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																			 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																		  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																		  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-11-06 PIYONG ADD P버전
																			 REPLACE( REPLACE( PROD_VER_CODE, 'S', '\'), 'Z', '/') 
																		  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN REPLACE( PROD_VER_CODE, 'S', '\')  -- 2019-11-06 PIYONG ADD P버전
																		  WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
																		  ELSE PROD_VER_CODE END DESC
																  , ISNULL( ATTR_01, '00') DESC  ) NUM
									,WO_ID
									,ATTR_04
							  FROM [SY_XIF_PLM_WO_INSP_SPEC_R]
							 WHERE PROC_ID = 'E4000'
							   AND ( SPEC_ITEM_ID LIKE 'I-%011-SPECE-010' OR SPEC_ITEM_ID LIKE 'I-%016-SPECAE-010' 
			   --      OR SPEC_ITEM_ID = 'I-M011-SPECE-023' --nff 신코드 없음
					 --OR SPEC_ITEM_ID = 'I-M016-SPECA-023' --nff 신코드 없음
									 )
							   AND SPEC_ITEM_ID != 'I-M011-SPECE-006' --> 'I-M011-SPECE-010'  --nff
							   AND SPEC_ITEM_ID != 'I-M016-SPECA-005' --> 'I-M016-SPECA-010'  --nff 2022-04-14 김현 [C20220328-000596] NFF 유형용 조건 조정
							   AND [VALUE1] IS NOT NULL
							   AND [PRODID] IS NOT NULL
							   AND ATTR_04 IS NOT NULL
							   AND PROC_FLAG = 'P'
							 --2018-06-26 PIYONG ADD
							----------------------------------------------------------------------------------------------------------------------------------------------
						) A
				  WHERE NUM =1
			   ) A
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV
					   ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					  AND SEGMENT4 = A.AREA_ID
					  AND SEGMENT5 = A.ATTR_04
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV3   -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
						   ON SSLV3.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
						  AND SSLV3.SEGMENT4   = SSLV.SEGMENT4
						  AND SSLV3.ATTRIBUTE2 = SSLV.SEGMENT5
		 WHERE ISNUMERIC([VALUE1]) = 1  -- kimcd 2017-08-22 숫자만 수신 조건 추가
	;


	--2018-04-24 PIYONG  조회문 변경 - SPEC_ITEM_NAME LIKE N'Coating Speed (m/min)>%'  추가
	--								 - LINE , 설비 존재 조건  제거
	DECLARE CUR_TAT_TIME CURSOR FOR
		SELECT D.AREA_ID
			   ,D.ITEM_ID
			   ,D.PPM_VAL AS TACT_TIME
			   ,D.CATEGORY
			   ,ISNULL(SSLV2.ATTRIBUTE1, ISNULL(SSLV.ATTRIBUTE1,'GENERAL') ) AS PROD_VERSION_TYPE	-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영. 버전 유형 로직 추가 2018-06-26 PIYONG ADD
	      FROM (
				SELECT [AREA_ID]
					   ,[PROC_ID]
					   ,[PRODID] AS ITEM_ID
					   ,[UNIT]
					   ,[VALUE1] AS PPM
					   ,60.0 / CONVERT(NUMERIC(18,3), [VALUE1]) AS PPM_VAL
					   ,[SPEC_ITEM_NAME]
					   ,ATTR_04							--2018-06-26 PIYONG ADD
					   ,CASE WHEN [SPEC_ITEM_NAME] = 'Coating Speed (m/min)>1' THEN 'SECOND'
					         WHEN [SPEC_ITEM_NAME] = 'Coating Speed (m/min)>2' THEN 'THIRD'
							 WHEN [SPEC_ITEM_NAME] = 'Coating Speed (m/min)>3' THEN 'FOURTH'
							 WHEN [SPEC_ITEM_NAME] = 'Coating Speed (m/min)>4' THEN 'FIFTH'
							 WHEN [SPEC_ITEM_NAME] = 'Coating Speed (m/min)>5' THEN 'SIXTH'
							 ELSE 'FIRST'
							 END AS CATEGORY
				  FROM (
						SELECT [CELLTYPE]
							   ,[PROD_VER_CODE]
							   ,[PRODID]
							   ,[AREA_ID]
							   ,[AREA_NAME]
							   ,[PROC_ID]
							   ,[PROC_NAME]
							   ,[SPEC_ITEM_NAME]
							   ,[UNIT]
							   ,[VALUE1]
							   ,WO_ID
							   ,[ATTR_04]				--2018-06-26 PIYONG ADD
							   ,DENSE_RANK() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID 
													   ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																		 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																	 WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																	 WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
																	 ELSE PROD_VER_CODE END DESC	--2018-05-11 PIYONG ADD 테스트버전 포함
															 , CAST(WO_ID AS NUMERIC) DESC																			  ) NUM
						  FROM (
								 SELECT [CELLTYPE]
										,[PROD_VER_CODE]
										,[PRODID]
										,[AREA_ID]
										,[AREA_NAME]
										,[PROC_ID]
										,[PROC_NAME]
										,[SPEC_ITEM_NAME]
										,[UNIT]
										,[VALUE1]
										,WO_ID
										,[ATTR_04]			--2018-06-26 PIYONG ADD
										,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID, SPEC_ITEM_NAME
																ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																				 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																			  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																			  WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
																			  ELSE PROD_VER_CODE END DESC --2018-05-11 PIYONG ADD 테스트버전 포함
																	 , CAST(WO_ID AS NUMERIC) DESC  ) NUM	--2017-11-24 PIYONG ORDER BY 조건 변경
								   FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
								  WHERE 1=1
									AND PROC_ID = 'E2000'
									AND ( SPEC_ITEM_ID LIKE 'I-%C1-001' OR  SPEC_ITEM_NAME LIKE N'Coating Speed (m/min)>%')
									AND VALUE1 IS NOT NULL
									AND PRODID IS NOT NULL
									AND VALUE1 != N'≥'
									AND VALUE1 != N'.'
									AND ATTR_04 IS NULL		--2018-06-26 PIYONG ADD
			--						AND PRODID LIKE 'APCAN0974A%'
								    AND PROC_FLAG = 'P'
							   ) AA
					     WHERE NUM =1
						 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					 	--2018-06-26 PIYONG ADD
						 UNION ALL
						 SELECT [CELLTYPE]
							   ,[PROD_VER_CODE]
							   ,[PRODID]
							   ,[AREA_ID]
							   ,[AREA_NAME]
							   ,[PROC_ID]
							   ,[PROC_NAME]
							   ,[SPEC_ITEM_NAME]
							   ,[UNIT]
							   ,[VALUE1]
							   ,WO_ID
							   ,[ATTR_04]
							   ,DENSE_RANK() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID, ATTR_04 
													   ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																		REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																	 WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																	 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-11-06 PIYONG ADD P버전
																		REPLACE( REPLACE( PROD_VER_CODE, 'S', '\'), 'Z', '/') 
																	 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN REPLACE( PROD_VER_CODE, 'S', '\')  -- 2019-11-06 PIYONG ADD P버전
																	 WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/')
																	 ELSE PROD_VER_CODE END DESC	--2018-05-11 PIYONG ADD 테스트버전 포함
															 , CAST(WO_ID AS NUMERIC) DESC																			  ) NUM
						  FROM (
								 SELECT [CELLTYPE]
										,[PROD_VER_CODE]
										,[PRODID]
										,[AREA_ID]
										,[AREA_NAME]
										,[PROC_ID]
										,[PROC_NAME]
										,[SPEC_ITEM_NAME]
										,[UNIT]
										,[VALUE1]
										,WO_ID
										,[ATTR_04]
										,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID, SPEC_ITEM_NAME, ATTR_04
																ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																				 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																			  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																			  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-11-06 PIYONG ADD P버전
																				 REPLACE( REPLACE( PROD_VER_CODE, 'S', '\'), 'Z', '/') 
																			  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN REPLACE( PROD_VER_CODE, 'S', '\')  -- 2019-11-06 PIYONG ADD P버전
																			  WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
																			  ELSE PROD_VER_CODE END DESC
																	 , CAST(WO_ID AS NUMERIC) DESC  ) NUM	--2017-11-24 PIYONG ORDER BY 조건 변경
								   FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
								  WHERE 1=1
									AND PROC_ID = 'E2000'
									AND ( SPEC_ITEM_ID LIKE 'I-%C1-001' OR  SPEC_ITEM_NAME LIKE N'Coating Speed (m/min)>%')
									AND VALUE1 IS NOT NULL
									AND PRODID IS NOT NULL
									AND VALUE1 != N'≥'
									AND VALUE1 != N'.'
									AND ATTR_04 IS NOT NULL
								    AND PROC_FLAG = 'P'
							   ) AA
					     WHERE NUM =1
 					 	--2018-06-26 PIYONG ADD
						 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					   ) A
			     WHERE NUM  = 1
				   AND VALUE1 > 0
			   ) D
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV
					   ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					  AND SEGMENT4 = D.AREA_ID
					  AND SEGMENT5 = D.ATTR_04
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV2   -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
				       ON SSLV2.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					  AND SSLV2.SEGMENT4   = SSLV.SEGMENT4
					  AND SSLV2.ATTRIBUTE2 = SSLV.SEGMENT5
	;


	DECLARE CUR_RP_TAT_TIME CURSOR FOR
		SELECT C.COMPANY_ID
			   ,C.DIVISION_ID
			   ,C.SITE_ID
			   ,C.PLANT_ID
			   ,C.FACTORY_ID
			   ,C.OPERATION_ID
			   ,C.LINE_ID
			   ,C.ELECTRODE_TYPE
			   ,D.PRODID AS ITEM_ID						--2019-10-07 PIYONG CHANGE C.ITEM_ID	-> D.PRODID
			   ,E.[MONTH]								--2019-10-07 PIYONG CHANGE C.MONTH		-> E.MONTH
			   ,D.PPM_VAL AS TACT_TIME
	      FROM (
/*
				--2019-10-07 PIYONG DEL
				SELECT COMPANY_ID
					   ,DIVISION_ID
					   ,SITE_ID
					   ,PLANT_ID
					   ,FACTORY_ID
					   ,OPERATION_ID
					   ,LINE_ID
					   ,ITEM_ID
					   ,ELECTRODE_TYPE
					   ,MONTH
				  FROM (
						 SELECT A.COMPANY_ID
								,A.DIVISION_ID
								,A.SITE_ID
								,A.PLANT_ID
								,A.FACTORY_ID
								,A.OPERATION_ID
								,A.LINE_ID
								,A.ITEM_ID
								,A.ELECTRODE_TYPE
								,A.MONTH
								,(SELECT COUNT(*)
								    FROM SCM_EQUIPMENT_M T(NOLOCK)
								   WHERE T.COMPANY_ID = A.COMPANY_ID
									 AND T.DIVISION_ID = A.DIVISION_ID
									 AND T.SITE_ID = A.SITE_ID
									 AND T.PLANT_ID = A.PLANT_ID
									 AND T.FACTORY_ID = A.FACTORY_ID
									 AND T.OPERATION_ID = A.OPERATION_ID
									 AND T.LINE_ID = A.LINE_ID
									 AND T.ELECTRODE_TYPE = A.ELECTRODE_TYPE
									 AND T.ACTIVE_FLAG = 'Y'
									 AND T.EQUIPMENT_TYPE = 'M'		) AS EQUIPMENT_COUNT
						   FROM [DBO].[SCM_ITEM_LINE_ASSIGN_M] A
						  WHERE ACTIVE_FLAG = 'Y'
							AND OPERATION_ID = 'E3000'
							AND MONTH >= SUBSTRING( CONVERT(VARCHAR(8), GETDATE(),112), 0, 7) 
						    AND MONTH <= SUBSTRING( CONVERT(CHAR(8), DATEADD(MM, +4, GETDATE()),112), 0, 7)
					   ) B
				 WHERE EQUIPMENT_COUNT > 0																--설비가 존재하는 라인만 적용
*/
						SELECT A.COMPANY_ID
							   ,A.DIVISION_ID
							   ,A.SITE_ID
							   ,A.PLANT_ID
							   ,A.FACTORY_ID
							   ,A.OPERATION_ID
							   ,A.LINE_ID
							   ,A.ELECTRODE_TYPE
						  FROM [DBO].[SCM_LINE_M] A
						 WHERE OPERATION_ID = 'E3000'
						   AND ACTIVE_FLAG = 'Y'
				) C
		     ,(
				SELECT PRODID
				        ,case when substring(PRODID, 4,2) = 'AN' then 'Anode' else 'Cathode' end as ELECTRODE_TYPE
						,AREA_ID
						,PROC_ID
						,UNIT
						,VALUE1 AS PPM
						,( 60.0 / CONVERT(NUMERIC(18,3), [VALUE1]) ) * CAST( ROLLPRESS_COUNT AS NUMERIC(18) ) AS PPM_VAL		--ROLLPRESS_COUNT로 텐덤(COUNT 1면 적용N  2면 적용 Y) 적용
						 
				  FROM (
						SELECT WIS.PROD_VER_CODE
							   ,WIS.PRODID
							   ,WIS.AREA_ID
							   ,WIS.PROC_ID
							   ,WIS.SPEC_ITEM_ID
							   ,WIS.SPEC_ITEM_NAME
							   ,WIS.UNIT
							   ,WIS.VALUE1
							   ,WS.ROLLPRESS_COUNT
							   ,ROW_NUMBER() OVER (PARTITION BY WIS.PRODID, WIS.AREA_ID, WIS.PROC_ID, WIS.SPEC_ITEM_ID
													   ORDER BY CASE WHEN RIGHT(WIS.PROD_VER_CODE, 1) = 'P' AND WIS.PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																		 REPLACE( REPLACE( WIS.PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																	 WHEN RIGHT(WIS.PROD_VER_CODE, 1) = 'P' THEN REPLACE( WIS.PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																	 WHEN RIGHT(WIS.PROD_VER_CODE, 1) = 'S' AND WIS.PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-11-06 PIYONG ADD P버전
																		 REPLACE( REPLACE( WIS.PROD_VER_CODE, 'S', '\'), 'Z', '/') 
																	 WHEN RIGHT(WIS.PROD_VER_CODE, 1) = 'S' THEN REPLACE( WIS.PROD_VER_CODE, 'S', '\')  -- 2019-11-06 PIYONG ADD P버전
																	 WHEN WIS.PROD_VER_CODE LIKE 'Z%' THEN REPLACE( WIS.PROD_VER_CODE, 'Z', '/') 
																	 ELSE WIS.PROD_VER_CODE END DESC --2018-05-11 PIYONG ADD 테스트버전 포함
															 , ISNULL( WIS.ATTR_01, '00') DESC
															 , WIS.IF_SEQ DESC											 ) NUM	--2017-11-30 PIYONG 차수 조건 추가
						  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R] WIS
							   ,[dbo].[SY_XIF_PLM_WO_SPEC_R] WS
						 WHERE 1=1
						   AND WIS.WO_ID = WS.WO_ID
						   AND WIS.CELLTYPE = WS.CELLTYPE
						   AND WIS.CMODEL_CODE = WS.CMODEL_CODE
						   AND WIS.PRODID = WS.PRODID
						   AND WIS.PROD_VER_CODE = WS.PROD_VER_CODE
						   AND WIS.AREA_ID = WS.AREA_ID
						   AND WIS.VALUE1 IS NOT NULL
						   AND PROC_ID = 'E3000'
						   AND (SPEC_ITEM_ID LIKE  'I-%-SPEC-B02' OR SPEC_ITEM_ID LIKE  'I-%-SPEC-003' 
						        OR SPEC_ITEM_ID = 'I-M011-SPECE-006' --> 'I-M011-SPECE-010' --nff
								OR SPEC_ITEM_ID = 'I-M016-SPECA-005' --> 'I-M016-SPECA-010' --nff -- 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
							   ) 
						   AND SPEC_ITEM_ID != 'I-M005-SPEC-003' -- 2022-04-14 김현 [C20220328-000596] NFF 부등호 조건 추가
						   AND WIS.PROC_FLAG = 'P'
						   AND WIS.VALUE1 != N'≥'					--2018-04-13 PIYONG ADD
						   --AND CONVERT(NUMERIC(18,3), [VALUE1]) > 0
						   AND CASE WHEN ISNUMERIC([VALUE1]) = 1 THEN CONVERT(NUMERIC(18,3), [VALUE1]) ELSE 0 END > 0  -- 2024-04-02 kimcd 숫자 변환 오류 발생하여 CASE 문장 추가
					  )A
				WHERE NUM = 1
				) D
			 ,[DBO].[SCM_ITEM_M]  IM WITH(NOLOCK) 
			 ,(
				--2019-10-07 PIYONG ADD
				SELECT DISTINCT YEAR+MONTH AS MONTH
				  FROM SCM_SYS_CALENDAR_M
				 WHERE YEAR+MONTH BETWEEN CONVERT(NVARCHAR(6),GETDATE(), 112)
				   AND CONVERT(NVARCHAR(6),DATEADD(MM, 5, GETDATE()), 112)
			 ) E
	   WHERE C.FACTORY_ID = D.AREA_ID
		 AND C.OPERATION_ID = D.PROC_ID
--		 AND C.ITEM_ID		 = D.PRODID			--2019-10-07 PIYONG DEL
         AND C.ELECTRODE_TYPE		 = D.ELECTRODE_TYPE	
		 AND IM.DIVISION_ID  = C.DIVISION_ID
		 AND IM.SITE_ID      = C.SITE_ID
		 AND IM.ITEM_ID      = D.PRODID

	;


		
	DECLARE CUR_SL_TAT_TIME CURSOR FOR
		SELECT C.COMPANY_ID
			   ,C.DIVISION_ID
			   ,C.SITE_ID
			   ,C.PLANT_ID
			   ,C.FACTORY_ID
			   ,C.OPERATION_ID
			   ,C.LINE_ID
			   ,C.ELECTRODE_TYPE
			   ,D.PRODID AS ITEM_ID						--2019-10-07 PIYONG CHANGE C.ITEM_ID	-> D.PRODID
			   ,E.[MONTH]								--2019-10-07 PIYONG CHANGE C.MONTH		-> E.MONTH
			   ,D.PPM_VAL AS TACT_TIME
	      FROM (
/*
				--2019-10-07 PIYONG DEL
				SELECT COMPANY_ID
					   ,DIVISION_ID
					   ,SITE_ID
					   ,PLANT_ID
					   ,FACTORY_ID
					   ,OPERATION_ID
					   ,LINE_ID
					   ,ITEM_ID
					   ,ELECTRODE_TYPE
					   ,MONTH
				  FROM (
						 SELECT A.COMPANY_ID
								,A.DIVISION_ID
								,A.SITE_ID
								,A.PLANT_ID
								,A.FACTORY_ID
								,A.OPERATION_ID
								,A.LINE_ID
								,A.ITEM_ID
								,A.ELECTRODE_TYPE
								,A.MONTH
								,(SELECT COUNT(*)
								    FROM SCM_EQUIPMENT_M T(NOLOCK)
								   WHERE T.COMPANY_ID = A.COMPANY_ID
									 AND T.DIVISION_ID = A.DIVISION_ID
									 AND T.SITE_ID = A.SITE_ID
									 AND T.PLANT_ID = A.PLANT_ID
									 AND T.FACTORY_ID = A.FACTORY_ID
									 AND T.OPERATION_ID = A.OPERATION_ID
									 AND T.LINE_ID = A.LINE_ID
									 AND T.ELECTRODE_TYPE = A.ELECTRODE_TYPE
									 AND T.ACTIVE_FLAG = 'Y'
									 AND T.EQUIPMENT_TYPE = 'M'		) AS EQUIPMENT_COUNT
						   FROM [DBO].[SCM_ITEM_LINE_ASSIGN_M] A
						  WHERE ACTIVE_FLAG = 'Y'
							AND OPERATION_ID = 'E4000'
							AND MONTH >= SUBSTRING( CONVERT(VARCHAR(8), GETDATE(),112), 0, 7) 
						    AND MONTH <= SUBSTRING( CONVERT(CHAR(8), DATEADD(MM, +4, GETDATE()),112), 0, 7)
					   ) B
				 WHERE EQUIPMENT_COUNT > 0																--설비가 존재하는 라인만 적용
*/
					SELECT A.COMPANY_ID
						   ,A.DIVISION_ID
						   ,A.SITE_ID
						   ,A.PLANT_ID
						   ,A.FACTORY_ID
						   ,A.OPERATION_ID
						   ,A.LINE_ID
						   ,A.ELECTRODE_TYPE
					  FROM [DBO].[SCM_LINE_M] A
					 WHERE OPERATION_ID = 'E4000'
					   AND ACTIVE_FLAG = 'Y'
				) C
		     ,(
				SELECT PRODID
						,AREA_ID
						,PROC_ID
						,UNIT
						,VALUE1 AS PPM
						, 60.0 / [VALUE1] AS PPM_VAL
				  FROM (
						SELECT [CELLTYPE]
								,[PROD_VER_CODE]
								,[PRODID]
								,[AREA_ID]
								,[AREA_NAME]
								,[PROC_ID]
								,[PROC_NAME]
								,[SPEC_ITEM_NAME]
								,[UNIT]
								,CONVERT(FLOAT, [VALUE1]) AS [VALUE1]
								,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID
														ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																		REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																	  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																	  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-11-06 PIYONG ADD P버전
																		REPLACE( REPLACE( PROD_VER_CODE, 'S', '\'), 'Z', '/') 
																	  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN REPLACE( PROD_VER_CODE, 'S', '\')  -- 2019-11-06 PIYONG ADD P버전
																	  WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
																	  ELSE PROD_VER_CODE END DESC 	--2018-05-11 PIYONG ADD 테스트버전 포함
															  , ISNULL( ATTR_01, '00') DESC
															  , IF_SEQ DESC						 ) NUM	--2017-11-30 PIYONG 차수 조건 추가
						   FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R] WIS
						  WHERE (SPEC_ITEM_ID LIKE  'I-%-SPEC-B08' OR SPEC_ITEM_ID LIKE  'I-%-SPEC-016' OR SPEC_ITEM_ID LIKE  'I-%-SPEC-017' 
						         OR SPEC_ITEM_ID = 'I-M011-SPECE-026' --> 'I-M011-SPECE-018' --nff
								 OR SPEC_ITEM_ID = 'I-M016-SPECA-034' --> 'I-M016-SPECA-018' --nff   -- 2022-04-14 김현 [C20220328-000596] NFF 로직 추가
								)
						    AND PROC_ID = 'E4000'
						    AND VALUE1 IS NOT NULL
							AND ISNUMERIC([VALUE1]) = 1
						    AND PRODID IS NOT NULL
						    AND PROC_FLAG = 'P'
					  )A
				WHERE NUM = 1
				  AND ISNUMERIC([VALUE1]) = 1	--PIYONG 1.3 ADD
			      AND [VALUE1] > 0
				) D
			 ,[DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
			 ,(
				--2019-10-07 PIYONG ADD
				SELECT DISTINCT YEAR+MONTH AS MONTH
				  FROM SCM_SYS_CALENDAR_M
				 WHERE YEAR+MONTH BETWEEN CONVERT(NVARCHAR(6),GETDATE(), 112)
				   AND CONVERT(NVARCHAR(6),DATEADD(MM, 5, GETDATE()), 112)
			 ) E
	   WHERE C.FACTORY_ID = D.AREA_ID
		 AND C.OPERATION_ID = D.PROC_ID
--		 AND C.ITEM_ID = D.PRODID					--2019-10-07 PIYONG DEL
		 AND IM.DIVISION_ID  = C.DIVISION_ID
		 AND IM.SITE_ID      = C.SITE_ID
		 AND IM.ITEM_ID      = D.PRODID

	  ;

	--2018-04-12 PIYONG ADD
	DECLARE CUR_TAT CURSOR FOR
		SELECT [AREA_ID]
			   ,[PROC_ID]
			   ,[PRODID]
			   ,CAST( [VALUE1] AS NUMERIC(20, 10) )  AS TAT
			   ,ISNULL(SSLV2.ATTRIBUTE1, ISNULL(SSLV.ATTRIBUTE1,'GENERAL') ) AS PROD_VERSION_TYPE	-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영. 버전 유형 로직 추가 2018-06-26 PIYONG ADD
		  FROM (
				SELECT [AREA_ID]
					   ,[PROC_ID]
					   ,[PRODID]
					   ,[VALUE1]
					   ,[ATTR_04]	--2018-06-26 PIYONG ADD
					   ,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID 
											 ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
															 WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
															 WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
															 ELSE PROD_VER_CODE END DESC
														, IF_SEQ DESC																						 ) NUM
				  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
				 WHERE PROC_ID = 'E1000'
				   AND [SPEC_ITEM_NAME] = 'Total mixing time'
				   AND PRODID IS NOT NULL
				   AND VALUE1 IS NOT NULL
				   AND ATTR_04 IS NULL	--2018-06-26 PIYONG ADD
				   AND PROC_FLAG = 'P'
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------
				--2018-06-26 PIYONG ADD
				UNION ALL
				SELECT [AREA_ID]
					   ,[PROC_ID]
					   ,[PRODID]
					   ,[VALUE1]
					   ,[ATTR_04]
					   ,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID, ATTR_04 
											   ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
															 WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
															 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-11-06 PIYONG ADD P버전
																 REPLACE( REPLACE( PROD_VER_CODE, 'S', '\'), 'Z', '/') 
															 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN REPLACE( PROD_VER_CODE, 'S', '\')  -- 2019-11-06 PIYONG ADD P버전
															 WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
															 ELSE PROD_VER_CODE END DESC
														, IF_SEQ DESC																						 ) NUM
				  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
				 WHERE PROC_ID = 'E1000'
				   AND [SPEC_ITEM_NAME] = 'Total mixing time'
				   AND PRODID IS NOT NULL
				   AND VALUE1 IS NOT NULL
				   AND ATTR_04 IS NOT NULL
				   AND PROC_FLAG = 'P'
				--2018-06-26 PIYONG ADD
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------
			   ) A
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV
				       ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					  AND SEGMENT4 = A.AREA_ID
					  AND SEGMENT5 = A.ATTR_04
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV2   -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
				       ON SSLV2.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					  AND SSLV2.SEGMENT4   = SSLV.SEGMENT4
					  AND SSLV2.ATTRIBUTE2 = SSLV.SEGMENT5
		 WHERE NUM  = 1
	;

	/*
	--2018-04-24 PIYONG ADD
	DECLARE CUR_SL_LANE CURSOR FOR
		SELECT [AREA_ID]
			   ,[PROC_ID]
			   ,[PRODID]
			   ,MAX( MAIN ) AS MAIN
			   ,MAX( SUB ) AS SUB
			   ,ISNULL(SSLV.ATTRIBUTE1, 'GENERAL' ) AS PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
		  FROM (
				 SELECT [AREA_ID]
						,[PROC_ID]
						,[PRODID]
						,CASE NUM WHEN 1THEN [VALUE1] ELSE NULL END AS MAIN
						,CASE NUM WHEN 2THEN [VALUE1] ELSE NULL END AS SUB
						,ATTR_04								--2018-06-26 PIYONG ADD
				   FROM (
						SELECT [AREA_ID]
							   ,[PROC_ID]
							   ,[PRODID]
							   ,[VALUE1]
							   ,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID ORDER BY [VALUE1] DESC  ) NUM
							   ,ATTR_04							--2018-06-26 PIYONG ADD
						 FROM (
								SELECT [AREA_ID]
									   ,[PROC_ID]
									   ,[PRODID]
									   ,CASE WHEN CHARINDEX('/',[VALUE1])  > 0 THEN
												REPLACE(SUBSTRING([VALUE1], 1, CHARINDEX('/', [VALUE1], CHARINDEX('/',[VALUE1]) ) -1 ) , ' ', '')		-- 2019-02-25 PIYONG ADD 10/11 경우 10으로 값 처리 
											ELSE 
												[VALUE1]
											END [VALUE1]
									   ,ATTR_04					--2018-06-26 PIYONG ADD
									   ,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
															   ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																				 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																			 WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																			 WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
																			 ELSE PROD_VER_CODE END DESC --2018-05-11 PIYONG ADD 테스트버전 포함
																	 , CAST(WO_ID AS NUMERIC) DESC, IF_RCV_DATE DESC																			  ) NUM
								  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
								 WHERE PROC_ID = 'E4000'
								   AND SPEC_ITEM_NAME LIKE N'%Lane%'
								   AND (
										SPEC_ITEM_ID LIKE N'I-%011-SPEC-008'
										OR SPEC_ITEM_ID LIKE N'I-%016-SPEC-008'
										OR SPEC_ITEM_ID LIKE N'I-%016-SPEC-C08'
										OR SPEC_ITEM_ID LIKE N'I-%011-SPEC-C08'
										OR SPEC_ITEM_ID LIKE N'I-%011-SPECE-005'
										OR SPEC_ITEM_ID LIKE N'I-%016-SPECA-005'
										OR SPEC_ITEM_ID LIKE N'I-P011-SPEC-011'
										OR SPEC_ITEM_ID LIKE N'I-P016-SPEC-007'
										OR SPEC_ITEM_ID = 'I-M009-SPECE-040' --> 'I-M011-SPECE-006' --nff 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
										OR SPEC_ITEM_ID = 'I-M014-SPECA-037' --> 'I-M016-SPECA-006' --nff
									   )
								   --AND SPEC_ITEM_ID != 'I-M011-SPECE-005'  --nff 신코드 없음 
								   --AND SPEC_ITEM_ID != 'I-M016-SPECA-005'  --nff 신코드 없음 -- 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
								   AND PRODID IS NOT NULL
								   AND VALUE1 IS NOT NULL
								   AND VALUE1 != N'＜'
								   AND ATTR_04 IS NULL			--2018-06-26 PIYONG ADD
								   AND PROC_FLAG = 'P'
							  ) A
					    WHERE NUM  = 1
						---------------------------------------------------------------------------------------------------------------------------------------------------------------------
						--2018-06-26 PIYONG ADD
						UNION ALL
						SELECT [AREA_ID]
							   ,[PROC_ID]
							   ,[PRODID]
							   ,[VALUE1]
							   ,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID ORDER BY [VALUE1] DESC  ) NUM
							   ,ATTR_04
						 FROM (
								SELECT [AREA_ID]
									   ,[PROC_ID]
									   ,[PRODID]
									   ,CASE WHEN CHARINDEX('/',[VALUE1])  > 0 THEN
												REPLACE(SUBSTRING([VALUE1], 1, CHARINDEX('/', [VALUE1], CHARINDEX('/',[VALUE1]) ) -1 ) , ' ', '')		-- 2019-02-25 PIYONG ADD 10/11 경우 10으로 값 처리 
											ELSE 
												[VALUE1]
											END [VALUE1]
									   ,ATTR_04
									   ,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID, ATTR_04
															   ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																				 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																			 WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																			 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-11-06 PIYONG ADD P버전
																				 REPLACE( REPLACE( PROD_VER_CODE, 'S', '\'), 'Z', '/') 
																			 WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN REPLACE( PROD_VER_CODE, 'S', '\')  -- 2019-11-06 PIYONG ADD P버전
																			 WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
																			 ELSE PROD_VER_CODE END DESC
																	 , CAST(WO_ID AS NUMERIC) DESC, IF_RCV_DATE DESC																			  ) NUM
								  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
								 WHERE PROC_ID = 'E4000'
								   AND SPEC_ITEM_NAME LIKE N'%Lane%'
								   AND ( (
											SPEC_ITEM_ID LIKE N'I-E01%-SPECA-L0%' OR SPEC_ITEM_ID LIKE N'I-A01%-SPECA-L0%'
										  )
										  OR ( SPEC_ITEM_ID LIKE N'I-C01%-SPEC-%08' OR SPEC_ITEM_ID LIKE N'I-K01%-SPEC-%08'		--2018-10-22 PIYONG ADD
												OR SPEC_ITEM_ID LIKE N'I-P011-SPEC-011' OR SPEC_ITEM_ID LIKE N'I-P016-SPEC-007'	--2018-10-22 PIYONG ADD
												OR SPEC_ITEM_ID = 'I-M009-SPECE-040' --> 'I-M011-SPECE-006' --nff
												OR SPEC_ITEM_ID = 'I-M014-SPECA-037' --> 'I-M016-SPECA-006' --nff 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
											 )
									   )
								   --AND SPEC_ITEM_ID != 'I-M011-SPECE-005'  --nff 신코드 없음
								   --AND SPEC_ITEM_ID != 'I-M016-SPECA-005'  --nff 신코드 없음 -- 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
								   AND PRODID IS NOT NULL
								   AND VALUE1 IS NOT NULL
								   AND VALUE1 != N'＜'
								   AND ATTR_04 IS NOT NULL
								   AND PROC_FLAG = 'P'
							  ) A
					    WHERE NUM  = 1
						--2018-06-26 PIYONG ADD
						---------------------------------------------------------------------------------------------------------------------------------------------------------------------
						) AA
			   )AAA
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV
				       ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					  AND SEGMENT4 = AAA.AREA_ID
					  AND SEGMENT5 = AAA.ATTR_04
		 GROUP BY AREA_ID
			   , PROC_ID
			   , PRODID
			   , ISNULL(SSLV.ATTRIBUTE1, 'GENERAL' )	--2018-06-26 PIYONG ADD

*/

	--2018-04-24 PIYONG ADD
	DECLARE CUR_FOIL CURSOR FOR
		SELECT [AREA_ID]
			   ,[PROC_ID]
			   ,[PRODID]
			   ,[VALUE1] AS FOIL_ID
			   ,[WO_ID]
			   ,CASE WHEN [AREA_ID] = 'EA' THEN
					CASE WHEN [ATTR_04] IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
							CONCAT([PROD_VER_CODE],'2')
						WHEN [ATTR_04] IN ('CNNJ6C0A', 'CNNJ6E0A') THEN 
							CONCAT([PROD_VER_CODE],'3')
						ELSE
						    CASE WHEN ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3) IS NOT NULL THEN
					            CONCAT([PROD_VER_CODE],ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3))
					        ELSE
							    [PROD_VER_CODE]
							END
					END
				ELSE
				    CASE WHEN ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3) IS NOT NULL THEN
			            CONCAT([PROD_VER_CODE],ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3))
			        ELSE
					    [PROD_VER_CODE]
					END
				END         AS   [PROD_VER_CODE] -- 2022-12-02 kimcd 전극 버전별 계획 수립을 위해 Version 부여 로직을 환산자와 통일
			   ,[PROD_VER_SEQ]								--2019-03-04 PIYONG ADD
			   ,[SPEC_ITEM_ID]
			   ,ISNULL(SSLV2.ATTRIBUTE1, ISNULL(SSLV.ATTRIBUTE1,'GENERAL') ) AS PROD_VERSION_TYPE	-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영. 버전 유형 로직 추가 2018-06-26 PIYONG ADD
			   ,[CMODEL_CODE]								--2019-03-04 PIYONG ADD
		  FROM (
				SELECT [AREA_ID]
					   ,[PROC_ID]
					   ,[CMODEL_CODE]						--2019-03-04 PIYONG ADD
					   ,[PRODID]
					   ,[VALUE1]
					   ,[WO_ID]
					   ,[PROD_VER_CODE]
					   ,ISNULL( ATTR_01, '00') AS PROD_VER_SEQ
					   ,[SPEC_ITEM_ID]
					   ,ATTR_04								--2018-06-26 PIYONG ADD
					   ,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
												/*		--2019-03-29 PIYONG DEL
													   ,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
															 WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
															 ELSE '-' END
												*/
														,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
												ORDER BY PROD_VER_CODE DESC
														,ISNULL( ATTR_01, '00') DESC
														,IF_SEQ DESC
														,WO_ID DESC														) AS NUM
				  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
				 WHERE PROC_ID = 'E2000'
				   AND ( 
						SPEC_ITEM_ID LIKE 'I-K%-SPEC-008'
						 OR SPEC_ITEM_ID LIKE 'I-C%-SPEC-008'
						 OR SPEC_ITEM_ID LIKE 'I-%009-FOIL-001'
						 OR SPEC_ITEM_ID LIKE 'I-%014-FOIL-002'
						 OR SPEC_ITEM_ID LIKE 'I-P009-SPEC-%10'
						 OR SPEC_ITEM_ID LIKE 'I-P014-SPEC-010'
					   )
				   AND PRODID IS NOT NULL
				   AND VALUE1 IS NOT NULL
				   AND ATTR_04 IS NULL
				   AND PROD_VER_CODE NOT LIKE '%.W'
				   AND PROD_VER_CODE NOT LIKE '%.P'
				   AND PROD_VER_CODE NOT LIKE '%.S'
				   AND PROC_FLAG = 'P'
				----------------------------------------------------------------------------------------------------------------------------------------------------------
				--2018-06-26 PIYONG ADD
				UNION ALL
				SELECT [AREA_ID]
					   ,[PROC_ID]
   					   ,[CMODEL_CODE]						--2019-03-04 PIYONG ADD
					   ,[PRODID]
					   ,[VALUE1]
					   ,[WO_ID]
					   ,[PROD_VER_CODE]
					   ,ISNULL( ATTR_01, '00') AS PROD_VER_SEQ
					   ,[SPEC_ITEM_ID]
					   ,ATTR_04
					   ,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID, SPEC_ITEM_ID
														,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
															  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
															  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN 'S'
																ELSE '-' END
														,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
												ORDER BY PROD_VER_CODE DESC
														,ISNULL( ATTR_01, '00') DESC
														,IF_SEQ DESC
														,WO_ID DESC														) AS NUM
				  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
				 WHERE PROC_ID = 'E2000'
				   AND ( SPEC_ITEM_ID LIKE 'I-K%-SPEC-008'
						 OR SPEC_ITEM_ID LIKE 'I-C%-SPEC-008'
						 OR SPEC_ITEM_ID LIKE 'I-%009-FOIL-001'
						 OR SPEC_ITEM_ID LIKE 'I-%014-FOIL-002'
						 OR SPEC_ITEM_ID LIKE 'I-P009-SPEC-%10'
						 OR SPEC_ITEM_ID LIKE 'I-P014-SPEC-010'
					   )
				   AND PRODID IS NOT NULL
				   AND VALUE1 IS NOT NULL
				   AND ATTR_04 IS NOT NULL
				   AND PROC_FLAG = 'P'
				   --2018-06-26 PIYONG ADD
				   ----------------------------------------------------------------------------------------------------------------------------------------------------------
			   ) A
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV
					   ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					  AND SEGMENT4 = A.AREA_ID
					  AND SEGMENT5 = A.ATTR_04
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV2   -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
				       ON SSLV2.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					  AND SSLV2.SEGMENT4   = SSLV.SEGMENT4
					  AND SSLV2.ATTRIBUTE2 = SSLV.SEGMENT5
		-- WHERE NUM  = 1							--2019-03-29 PIYONG DEL

	--2018-09-10 PIYONG ADD 작업의뢰 적용일자
	DECLARE CUR_APPLY_DATE CURSOR FOR
		SELECT CMODEL_CODE
				,PRODID
			    ,CASE WHEN [AREA_ID] = 'EA' THEN
					 CASE WHEN A.PROD_VERSION_TYPE IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
							CONCAT([PROD_VER_CODE],'2')
						WHEN A.PROD_VERSION_TYPE IN ('CNNJ6C0A', 'CNNJ6E0A') THEN 
							CONCAT([PROD_VER_CODE],'3')
						ELSE
							CASE WHEN ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3) IS NOT NULL THEN
								CONCAT([PROD_VER_CODE],ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3))
							ELSE
								[PROD_VER_CODE]
							END
					 END
				 ELSE
					 CASE WHEN ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3) IS NOT NULL THEN
					 	 CONCAT([PROD_VER_CODE],ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3))
					 ELSE
						 [PROD_VER_CODE]
					 END
				 END         AS   [PROD_VER_CODE] -- 2022-12-02 kimcd 전극 버전별 계획 수립을 위해 Version 부여 로직을 환산자와 통일
				,PROD_VER_SEQ
				,AREA_ID
				,APPLY_DATE
				,ISNULL(SSLV2.ATTRIBUTE1, ISNULL(SSLV.ATTRIBUTE1,'GENERAL') ) AS PROD_VERSION_TYPE	-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영. 버전 유형 로직 추가
				,ORDER_TYPE								--2019-04-26 PIYONG ADD
		  FROM (
				SELECT WIS.CMODEL_CODE
					   ,WIS.PRODID
					   ,WIS.PROD_VER_CODE
					   ,ISNULL( WIS.ATTR_01, '00') AS PROD_VER_SEQ
					   ,WIS.AREA_ID
					   ,MAX(WIS.ATTR_05) AS APPLY_DATE
					   ,WIS.ATTR_04 AS PROD_VERSION_TYPE
					   ,WIS.ATTR_06 AS ORDER_TYPE		--2019-04-26 PIYONG ADD
				  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R] WIS
				 WHERE 1 = 1 -- PROC_FLAG = 'N' 2022-12-02 kimcd 정보 누락을 막기위해 조건 추가
				   AND ATTR_05 IS NOT NULL
				   AND PRODID IS NOT NULL
				   AND PROC_ID IN ('E1000', 'E2000')
				  -----------------------------------------------------------------------------------------------------------------------
				   --2020-06-11 PIYONG ADD
				   AND IF_RCV_DATE >= DATEADD(HOUR, -2,GETDATE()) -- 2022-12-02 kimcd 1일에서 2시간으로 범위 축소
				   AND ( SPEC_ITEM_ID LIKE 'I-K%-SPEC-008'
						 OR SPEC_ITEM_ID LIKE 'I-C%-SPEC-008'
						 OR SPEC_ITEM_ID LIKE 'I-%009-FOIL-001'
						 OR SPEC_ITEM_ID LIKE 'I-%014-FOIL-002'
						 OR SPEC_ITEM_ID LIKE 'I-P009-SPEC-%10'
						 OR SPEC_ITEM_ID LIKE 'I-P014-SPEC-010'
						 OR SPEC_ITEM_ID LIKE 'I-K%-SPEC-008'
						 OR SPEC_ITEM_ID LIKE 'I-C%-SPEC-008'
						 OR SPEC_ITEM_ID LIKE N'I-%011-SPEC-008'
						OR SPEC_ITEM_ID LIKE N'I-%016-SPEC-008'

						OR SPEC_ITEM_ID LIKE N'I-%016-SPEC-C08'
						OR SPEC_ITEM_ID LIKE N'I-%011-SPEC-C08'

						OR SPEC_ITEM_ID LIKE N'I-%011-SPECE-005'
						OR SPEC_ITEM_ID LIKE N'I-%016-SPECA-005'

						OR SPEC_ITEM_ID LIKE N'I-P011-SPEC-011'

						OR SPEC_ITEM_ID LIKE N'I-P016-SPEC-007'
						OR [SPEC_ITEM_NAME] = 'Total mixing time'
						OR ( SPEC_ITEM_ID LIKE 'I-%C1-001' OR  SPEC_ITEM_NAME LIKE N'Coating Speed (m/min)>%')
						OR ( ( SPEC_ITEM_ID LIKE N'I-E01%-SPECA-L0%' OR SPEC_ITEM_ID LIKE N'I-A01%-SPECA-L0%' )
							OR ( SPEC_ITEM_ID LIKE N'I-C01%-SPEC-%08' OR SPEC_ITEM_ID LIKE N'I-K01%-SPEC-%08'
								  OR SPEC_ITEM_ID LIKE N'I-P011-SPEC-011' OR SPEC_ITEM_ID LIKE N'I-P016-SPEC-007'
							   )
						  ) 
					   )
				   AND SPEC_ITEM_ID != 'I-M001-SPEC-002'    --nff 구코드 -- 2022-04-14 김현 [C20220328-000596] NFF 부등호 조건 추가
				   AND SPEC_ITEM_ID != 'I-M001-SPEC-012'	--nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-002'	--nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-004_2'	--nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-005_2'	--nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-012'	--nff 구코드 
			   			--2020-06-11 PIYONG ADD END
					   -----------------------------------------------------------------------------------------------------------------------
				 GROUP BY WIS.CMODEL_CODE
					   ,WIS.PRODID
					   ,WIS.PROD_VER_CODE
					   ,ISNULL( WIS.ATTR_01, '00')
					   ,WIS.AREA_ID
					   ,WIS.PROC_NAME
					   ,WIS.ATTR_04
					   ,WIS.ATTR_06						--2019-04-26 PIYONG ADD
				-----------------------------------------------------------------------------
				--2019-04-19 PIYONG ADD 단면 반제품 처리
				UNION
				SELECT WIS.CMODEL_CODE
					   ,WIS.ATTR_07 AS PRODID
					   ,WIS.PROD_VER_CODE
					   ,ISNULL( WIS.ATTR_01, '00') AS PROD_VER_SEQ
					   ,WIS.AREA_ID
					   ,MAX(WIS.ATTR_05) AS APPLY_DATE
					   ,WIS.ATTR_04 AS PROD_VERSION_TYPE
					   ,WIS.ATTR_06 AS ORDER_TYPE		--2019-04-26 PIYONG ADD
				  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R] WIS
				 WHERE 1 = 1 -- PROC_FLAG = 'N' 2022-12-02 kimcd 정보 누락을 막기위해 조건 추가
				   AND ATTR_05 IS NOT NULL
				   AND ATTR_07 IS NOT NULL
				   AND PROC_ID IN ('E1000', 'E2000')

				  -----------------------------------------------------------------------------------------------------------------------
				   --2020-06-11 PIYONG ADD
				   AND IF_RCV_DATE >= DATEADD(HOUR, -2,GETDATE()) -- 2022-12-02 kimcd 1일에서 2시간으로 범위 축소
				   AND ( SPEC_ITEM_ID LIKE 'I-K%-SPEC-008'
						 OR SPEC_ITEM_ID LIKE 'I-C%-SPEC-008'
						 OR SPEC_ITEM_ID LIKE 'I-%009-FOIL-001'
						 OR SPEC_ITEM_ID LIKE 'I-%014-FOIL-002'
						 OR SPEC_ITEM_ID LIKE 'I-P009-SPEC-%10'
						 OR SPEC_ITEM_ID LIKE 'I-P014-SPEC-010'
						 OR SPEC_ITEM_ID LIKE 'I-K%-SPEC-008'
						 OR SPEC_ITEM_ID LIKE 'I-C%-SPEC-008'
						 OR SPEC_ITEM_ID LIKE N'I-%011-SPEC-008'
						OR SPEC_ITEM_ID LIKE N'I-%016-SPEC-008'

						OR SPEC_ITEM_ID LIKE N'I-%016-SPEC-C08'
						OR SPEC_ITEM_ID LIKE N'I-%011-SPEC-C08'

						OR SPEC_ITEM_ID LIKE N'I-%011-SPECE-005'
						OR SPEC_ITEM_ID LIKE N'I-%016-SPECA-005'

						OR SPEC_ITEM_ID LIKE N'I-P011-SPEC-011'

						OR SPEC_ITEM_ID LIKE N'I-P016-SPEC-007'
						OR [SPEC_ITEM_NAME] = 'Total mixing time'
						OR ( SPEC_ITEM_ID LIKE 'I-%C1-001' OR  SPEC_ITEM_NAME LIKE N'Coating Speed (m/min)>%')
						OR ( ( SPEC_ITEM_ID LIKE N'I-E01%-SPECA-L0%' OR SPEC_ITEM_ID LIKE N'I-A01%-SPECA-L0%' )
							OR ( SPEC_ITEM_ID LIKE N'I-C01%-SPEC-%08' OR SPEC_ITEM_ID LIKE N'I-K01%-SPEC-%08'
								  OR SPEC_ITEM_ID LIKE N'I-P011-SPEC-011' OR SPEC_ITEM_ID LIKE N'I-P016-SPEC-007'
							   )
						  ) 
					   )
				   AND SPEC_ITEM_ID != 'I-M001-SPEC-002'   --nff 구코드  2022-04-14 김현 [C20220328-000596] NFF 부등호 조건 추가
				   AND SPEC_ITEM_ID != 'I-M001-SPEC-012'   --nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-002'   --nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-004_2' --nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-005_2' --nff 구코드 
				   AND SPEC_ITEM_ID != 'I-M013-SPEC-012'   --nff 구코드 
			   			--2020-06-11 PIYONG ADD END
					   -----------------------------------------------------------------------------------------------------------------------
				 GROUP BY WIS.CMODEL_CODE
					   ,WIS.ATTR_07
					   ,WIS.PROD_VER_CODE
					   ,ISNULL( WIS.ATTR_01, '00')
					   ,WIS.AREA_ID
					   ,WIS.PROC_NAME
					   ,WIS.ATTR_04
					   ,WIS.ATTR_06						--2019-04-26 PIYONG ADD
				--2019-04-19 PIYONG ADD 단면 반제품 처리
				-----------------------------------------------------------------------------
			   ) A
			   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV
							ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
						   AND A.AREA_ID  = SEGMENT4
						   AND A.PROD_VERSION_TYPE = SEGMENT5
				LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV2   -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
							ON SSLV2.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
							AND SSLV2.SEGMENT4   = SSLV.SEGMENT4
							AND SSLV2.ATTRIBUTE2 = SSLV.SEGMENT5
		 ORDER BY AREA_ID
				,CMODEL_CODE
				,PRODID
				,PROD_VER_CODE
				,PROD_VER_SEQ
				,APPLY_DATE
/*
	--2018-12-18 PIYONG ADD 절연코팅
	DECLARE CUR_INSULATION_COATING CURSOR FOR
		SELECT F.COMPANY_ID
			   ,F.DIVISION_ID
			   ,F.SITE_ID
			   ,PRODID
		  FROM (
				SELECT CMODEL_CODE
					   ,PROD_VER_CODE
					   ,PRODID
					   ,AREA_ID
					   ,WO_ID
					   ,ATTR_01 --  차수
					   ,ROW_NUMBER() OVER (PARTITION BY CMODEL_CODE, PRODID, AREA_ID, PROC_ID
													,CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'W' THEN 'W'
														  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN 'P'
														  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN 'S'
														  ELSE '-' END
													,CASE WHEN LEFT(PROD_VER_CODE, 1) = 'Z' THEN 'T' ELSE 'M' END	
										   ORDER BY PROD_VER_CODE DESC
												,ISNULL( ATTR_01, '00') DESC
												,IF_SEQ DESC
												,WO_ID DESC						 ) NUM
				  FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
				 WHERE ATTR_09 IS NOT NULL
				   AND PROC_ID = 'E2300'
			   ) A
		INNER JOIN SCM_FACTORY_M F
				ON A.AREA_ID = F.FACTORY_ID
			 WHERE A.NUM = 1
		GROUP BY F.COMPANY_ID
			  ,F.DIVISION_ID
			  ,F.SITE_ID
			  ,PRODID
		ORDER BY F.COMPANY_ID
			  ,F.DIVISION_ID
			  ,F.SITE_ID
			  ,PRODID
*/
	--2019-02-18 PIYONG 고형분비율
	DECLARE CUR_SOLID_RATE CURSOR FOR
		SELECT [CMODEL_CODE]
		      ,CASE WHEN [AREA_ID] = 'EA' THEN
				   CASE WHEN A.PROD_VERSION_TYPE IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
							CONCAT([PROD_VER_CODE],'2')
						WHEN A.PROD_VERSION_TYPE IN ('CNNJ6C0A', 'CNNJ6E0A') THEN 
							CONCAT([PROD_VER_CODE],'3')
						ELSE
							CASE WHEN ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3) IS NOT NULL THEN
								CONCAT([PROD_VER_CODE],ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3))
							ELSE
								[PROD_VER_CODE]
							END
					END
			   ELSE
				   CASE WHEN ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3) IS NOT NULL THEN
					   CONCAT([PROD_VER_CODE],ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3))
				   ELSE
					   [PROD_VER_CODE]
				   END
			   END         AS   [PROD_VER_CODE] -- 2022-12-02 kimcd 전극 버전별 계획 수립을 위해 Version 부여 로직을 환산자와 통일
			  ,ATTR_01 AS PROD_VER_SEQ		--2019-03-29 PIYONG ADD
			  ,ISNULL(SSLV2.ATTRIBUTE1, ISNULL(SSLV.ATTRIBUTE1,'GENERAL') ) AS PROD_VERSION_TYPE	-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영. 버전 유형 로직 추가
			  ,[PRODID]
			  ,[AREA_ID]
			  ,[MTRLCLASS_NAME]
			  ,[MTRLID]
			  ,[MTRLNAME]
			  ,[SOLID_RATE]
		 FROM (
				SELECT [PROC_FLAG]
					  ,[CMODEL_CODE]
					  ,[PROD_VER_CODE]
  					  ,ISNULL( ATTR_01, '00')  AS ATTR_01
					  ,[PRODID]
					  ,[AREA_ID]
					  ,REPLACE( [MTRLCLASS_NAME], N'<BR>',' ' ) AS [MTRLCLASS_NAME]
					  ,ISNULL(PRODID_PREDISP, [MTRLID]) AS [MTRLID]
					  ,[MTRLNAME]
					  ,[SOLID_FLAG]
					  ,ISNULL([SOLID_RATE], '100') AS [SOLID_RATE]
					  ,ATTR_02 AS PROD_VERSION_TYPE
				  FROM [SY_XIF_PLM_MIXER_MTRL_R]
				 WHERE SOLID_FLAG = 'Y'
			   	   AND (
						( SOLID_RATE IS NULL AND PRODID_PREDISP IS NULL )
							OR SOLID_RATE IS NOT NULL  
					   )
				   AND PROC_FLAG = 'P'
			--	   AND PRODID = 'ASLAN0863A'
			  ) A
		LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV
				ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
			   AND SEGMENT4 = A.AREA_ID
			   AND SEGMENT5 = ISNULL(A.PROD_VERSION_TYPE, '-')
		LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV2   -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
				    ON SSLV2.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					AND SSLV2.SEGMENT4   = SSLV.SEGMENT4
					AND SSLV2.ATTRIBUTE2 = SSLV.SEGMENT5
		ORDER BY ATTR_01


	--2019-03-14 PIYONG ADD 작업지시 적용일자
	DECLARE CUR_WO_ORDER_APPLY_DATE CURSOR FOR
		SELECT CMODEL_CODE
				,PRODID
				,CASE WHEN [AREA_ID] = 'EA' THEN
				     CASE WHEN A.PROD_VERSION_TYPE IN ('CNNJ5C0A', 'CNNJ5E0A') THEN
							CONCAT([PROD_VER_CODE],'2')
					      WHEN A.PROD_VERSION_TYPE IN ('CNNJ6C0A', 'CNNJ6E0A') THEN 
							CONCAT([PROD_VER_CODE],'3')
					 ELSE
						CASE WHEN ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3) IS NOT NULL THEN
							CONCAT([PROD_VER_CODE],ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3))
						ELSE
							[PROD_VER_CODE]
						END
				     END
			     ELSE
					CASE WHEN ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3) IS NOT NULL THEN
						CONCAT([PROD_VER_CODE],ISNULL(SSLV2.ATTRIBUTE3,SSLV.ATTRIBUTE3))
					ELSE
						[PROD_VER_CODE]
					END
			     END         AS   [PROD_VER_CODE] -- 2022-12-02 kimcd 전극 버전별 계획 수립을 위해 Version 부여 로직을 환산자와 통일
				,PROD_VER_SEQ
				,AREA_ID
				,APPLY_DATE
				,ISNULL(SSLV2.ATTRIBUTE1, ISNULL(SSLV.ATTRIBUTE1,'GENERAL') ) AS PROD_VERSION_TYPE	-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영. 버전 유형 로직 추가
		  FROM (
				SELECT CMODEL_CODE
						,PRODID
						,PROD_VER_CODE
						,ISNULL( WO_SEQ, '00') AS PROD_VER_SEQ
						,AREA_ID
						,MAX(APPLY_DATE) AS APPLY_DATE
						,ATTR_04 AS PROD_VERSION_TYPE
				  FROM [dbo].[SY_XIF_PLM_WO_ORDER_R]
				 WHERE PRODID IS NOT NULL
				   AND PROD_VER_CODE  IS NOT NULL
				   AND PROC_FLAG = 'P'
				 GROUP BY CMODEL_CODE
						,PRODID
						,PROD_VER_CODE
						,ISNULL( WO_SEQ, '00')
						,AREA_ID
						,ATTR_04
			   ) A
			   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV
							ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
						   AND A.AREA_ID  = SEGMENT4
						   AND A.PROD_VERSION_TYPE = SEGMENT5
				LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV2   -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
						    ON SSLV2.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
							AND SSLV2.SEGMENT4   = SSLV.SEGMENT4
							AND SSLV2.ATTRIBUTE2 = SSLV.SEGMENT5
		 ORDER BY CMODEL_CODE
			   ,PRODID
   			   ,AREA_ID
			   ,PROD_VER_CODE
			   ,PROD_VER_SEQ

	--	2022-04-14 김현 [C20220328-000596]	Jmubo roll 정권 길이 조회
	DECLARE CUR_JR_ROLL CURSOR FOR
		SELECT [AREA_ID]
			   ,[PRODID]
			   ,[VALUE1]
			   ,[WO_ID]
			   ,ISNULL(SSLV2.ATTRIBUTE1, ISNULL(SSLV.ATTRIBUTE1,'GENERAL') ) AS PROD_VERSION_TYPE	-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영. 버전 유형 로직 추가 2018-06-26 PIYONG ADD
			   ,(SELECT TOP 1 SSLV2.ATTRIBUTE1
				FROM    SCM_SYS_LOOKUP_VALUE SSLV2 (NOLOCK)
				WHERE   SSLV2.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
				AND     SSLV2.SEGMENT4 = A.AREA_ID
				AND     SSLV2.SEGMENT5 = 'E3000E4000' )   AS POST_TYPE -- 2022-05-23 E3000E4000 형성 여부
		  FROM (
				 SELECT PRODID
						,AREA_ID
						,WO_ID
						,ATTR_01 AS [VALUE1]
						,ATTR_04									 --2018-06-26 PIYONG ADD
				   FROM (
							SELECT [PRODID]
									,[AREA_ID]
									,REPLACE(REPLACE(VALUE1,',',''), 'M','') AS [ATTR_01]
									,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID
														    ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																			 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																		  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																		  WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
																		  ELSE PROD_VER_CODE END DESC	--2018-05-11 PIYONG ADD 테스트버전 포함
																  , ISNULL( ATTR_01, '00') DESC  ) NUM	--2017-11-30 PIYONG 차수 조건 추가
									,WO_ID
									,ATTR_04						 --2018-06-26 PIYONG ADD
							  FROM [SY_XIF_PLM_WO_INSP_SPEC_R]
							 WHERE PROC_ID = 'E2000'
							   AND SPEC_ITEM_ID IN ('I-A009-SPECE-010'
												   ,'I-A014-SPECAE-010'
												   ,'I-E009-SPECE-010'
												   ,'I-E014-SPECAE-010'
									               ,'I-M009-SPECE-013' --> 'I-M009-SPECE-008'    --nff
									               ,'I-M014-SPECA-030' --> 'I-M014-SPECA-008'    --nff
												   )
							   AND [VALUE1] IS NOT NULL
							   AND [PRODID] IS NOT NULL
							   AND ATTR_04 IS NULL					--2018-06-26 PIYONG ADD			
							   AND PROC_FLAG = 'P'
							----------------------------------------------------------------------------------------------------------------------------------------------
							 --2018-06-26 PIYONG ADD
							 UNION ALL
							 SELECT [PRODID]
									,[AREA_ID]
									,REPLACE(REPLACE(VALUE1,',',''), 'M','') AS [ATTR_01]
									,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, ATTR_04
														    ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-01-15 PIYONG ADD P버전
																			 REPLACE( REPLACE( PROD_VER_CODE, 'P', '\'), 'Z', '/') 
																		  WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\')  -- 2019-01-15 PIYONG ADD P버전
																		  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' AND PROD_VER_CODE LIKE 'Z%' THEN		-- 2019-11-06 PIYONG ADD P버전
																			 REPLACE( REPLACE( PROD_VER_CODE, 'S', '\'), 'Z', '/') 
																		  WHEN RIGHT(PROD_VER_CODE, 1) = 'S' THEN REPLACE( PROD_VER_CODE, 'S', '\')  -- 2019-11-06 PIYONG ADD P버전
																		  WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
																		  ELSE PROD_VER_CODE END DESC
																  , ISNULL( ATTR_01, '00') DESC  ) NUM
									,WO_ID
									,ATTR_04
							  FROM [SY_XIF_PLM_WO_INSP_SPEC_R]
							 WHERE PROC_ID = 'E2000'
							   AND SPEC_ITEM_ID IN ('I-A009-SPECE-010'
												   ,'I-A014-SPECAE-010'
												   ,'I-E009-SPECE-010'
												   ,'I-E014-SPECAE-010'
									               ,'I-M009-SPECE-013' --> 'I-M009-SPECE-008'    --nff
									               ,'I-M014-SPECA-030' --> 'I-M014-SPECA-008'    --nff
												   )
							   AND [VALUE1] IS NOT NULL
							   AND [PRODID] IS NOT NULL
							   AND ATTR_04 IS NOT NULL
							   AND PROC_FLAG = 'P'
						) A
				  WHERE NUM =1
			   ) A
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV
					   ON SSLV.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					  AND SEGMENT4 = A.AREA_ID
					  AND SEGMENT5 = A.ATTR_04
		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SSLV2   -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
				       ON SSLV2.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
					  AND SSLV2.SEGMENT4   = SSLV.SEGMENT4
					  AND SSLV2.ATTRIBUTE2 = SSLV.SEGMENT5
		 WHERE ISNUMERIC([VALUE1]) = 1;
	;


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

				UPDATE B
				SET    B.PROC_FLAG = 'N'
				FROM  [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R] B
				     , (SELECT   [PRODID]
								,[AREA_ID]
								,[PROC_ID]
								,[IF_SEQ]
								,ROW_NUMBER() OVER (PARTITION BY PRODID, AREA_ID, PROC_ID, ATTR_04				--2018-06-26 PIYONG ADD ATTR_04
														ORDER BY CASE WHEN RIGHT(PROD_VER_CODE, 1) = 'P' THEN REPLACE( PROD_VER_CODE, 'P', '\') -- 2019-01-15 PIYONG ADD P버전
																	  WHEN PROD_VER_CODE LIKE 'Z%' THEN REPLACE( PROD_VER_CODE, 'Z', '/') 
														              ELSE PROD_VER_CODE END DESC				 --2018-05-11 PIYONG ADD 테스트버전 포함
															  , ISNULL( ATTR_01, '00') DESC, IF_SEQ DESC ) NUM	--2017-11-30 PIYONG 차수 조건 추가
						   FROM [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R] WIS
						      , [DBO].[SCM_ITEM_LINE_ASSIGN_M]    A
						  WHERE A.FACTORY_ID = WIS.AREA_ID
						    AND A.ITEM_ID    = WIS.PRODID
							AND A.OPERATION_ID = WIS.PROC_ID
						    AND WIS.VALUE1 IS NOT NULL
						    AND WIS.PRODID IS NOT NULL
						    AND WIS.PROC_FLAG = 'Y'
							AND A.ACTIVE_FLAG = 'Y'
							AND A.UPDATE_TIME > GETDATE()-1
					  ) A
				WHERE A.NUM = 1
				AND   B.[PRODID]  = A.[PRODID]
				AND	  B.[AREA_ID] = A.[AREA_ID]
				AND	  B.[PROC_ID] = A.[PROC_ID]
				AND	  B.[IF_SEQ]  = A.[IF_SEQ]

			SET @v_err_check = 'CUR_APPLY_DATE'
			----------------------------------------------------------------------------------------------------------------------------------------
			--2018-09-10 PIYONG ADD 적용일자
			OPEN CUR_APPLY_DATE;
			FETCH NEXT FROM CUR_APPLY_DATE INTO @MODEL_ID
											,@ITEM_ID
											,@PROD_VER_CODE
											,@PROD_VER_SEQ
											,@FACTORY_ID
											,@APPLY_DATE
											,@PROD_VERSION_TYPE
											,@ORDER_TYPE
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					MERGE INTO [dbo].[FP_PROD_VERSION_M] PV
					USING (
							SELECT COMPANY_ID
								   ,DIVISION_ID
								   ,SITE_ID
								   ,PLANT_ID
								   ,FACTORY_ID
								   ,@MODEL_ID AS MODEL_ID
								   ,@ITEM_ID AS ITEM_ID
								   ,@PROD_VER_CODE AS [PROD_VERSION]
								   ,@PROD_VER_SEQ AS [PROD_SEQ]
								   ,@APPLY_DATE AS APPLY_DATE
								   ,@PROD_VERSION_TYPE AS PROD_VERSION_TYPE
								   ,@ORDER_TYPE AS ORDER_TYPE
							  FROM SCM_FACTORY_M
						     WHERE FACTORY_ID = @FACTORY_ID
						  ) TEMP
					   ON (
							PV.[PLANT_ID] = TEMP.[PLANT_ID]
							AND PV.[FACTORY_ID] = TEMP.[FACTORY_ID]
							AND PV.[MODEL_ID] = TEMP.[MODEL_ID]
							AND PV.[ITEM_ID] = TEMP.[ITEM_ID]
							AND PV.[PROD_VERSION] = TEMP.[PROD_VERSION]
							AND PV.[PROD_SEQ] = TEMP.[PROD_SEQ]
						  )
					WHEN MATCHED THEN
						UPDATE
						  SET PV.[APPLY_DATE] = TEMP.[APPLY_DATE]
							  ,PV.[ORDER_TYPE] =  TEMP.[ORDER_TYPE]
							  ,PV.UPDATE_ID = 'PR_XIF_PLM_WO_INSP_SPEC_R'
							  ,PV.UPDATE_TIME = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
								[COMPANY_ID]
							    ,[DIVISION_ID]
							    ,[SITE_ID]
							    ,[PLANT_ID]
							    ,[FACTORY_ID]
							    ,[MODEL_ID]
							    ,[ITEM_ID]
							    ,[PROD_VERSION]
							    ,[PROD_SEQ]
							    ,[APPLY_DATE]
								,[APPLY_END_DATE]
								,[PROD_VERSION_TYPE]
								,[ORDER_TYPE]
							    ,[INSERT_ID]
							    ,[INSERT_TIME]
							    ,[UPDATE_ID]
							    ,[UPDATE_TIME]
						) VALUES (      								
								TEMP.COMPANY_ID
								,TEMP.DIVISION_ID
								,TEMP.SITE_ID
								,TEMP.PLANT_ID
								,TEMP.FACTORY_ID
								,TEMP.MODEL_ID
								,TEMP.ITEM_ID
								,TEMP.PROD_VERSION
								,TEMP.PROD_SEQ
								,TEMP.APPLY_DATE
								,DATEADD(YEAR, 100, GETDATE())
								,TEMP.PROD_VERSION_TYPE
								,TEMP.ORDER_TYPE
								,'PR_XIF_PLM_WO_INSP_SPEC_R'
								,GETDATE()
								,'PR_XIF_PLM_WO_INSP_SPEC_R'
								,GETDATE()
						)
					;


					-- APPLY_END_DATE 형성 
		  			UPDATE PV
		  			   SET PV.APPLY_END_DATE	= DATEADD(DAY, -1, @APPLY_DATE)
					  FROM [FP_PROD_VERSION_M] PV
					       ,[SCM_FACTORY_M] F
				     WHERE F.FACTORY_ID			= @FACTORY_ID
					   AND PV.COMPANY_ID		= F.COMPANY_ID
					   AND PV.DIVISION_ID		= F.DIVISION_ID
		  			   AND PV.SITE_ID			= F.SITE_ID
					   AND PV.PLANT_ID			= F.PLANT_ID
		  			   AND PV.FACTORY_ID		= F.FACTORY_ID
		  			   AND PV.MODEL_ID			= @MODEL_ID
					   AND PV.ITEM_ID			= @ITEM_ID
  					   AND PV.APPLY_DATE		< @APPLY_DATE
					   AND PV.APPLY_END_DATE	>= @APPLY_DATE


					FETCH NEXT FROM CUR_APPLY_DATE INTO @MODEL_ID
													 ,@ITEM_ID
													 ,@PROD_VER_CODE
													 ,@PROD_VER_SEQ
													 ,@FACTORY_ID
													 ,@APPLY_DATE
													 ,@PROD_VERSION_TYPE
													 ,@ORDER_TYPE

					;
				END;

			CLOSE CUR_APPLY_DATE;
			DEALLOCATE CUR_APPLY_DATE;

			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'P'
			 WHERE PROC_ID = 'E2000'
				AND ( SPEC_ITEM_ID LIKE 'I-%C1-001' OR  SPEC_ITEM_NAME LIKE N'Coating Speed (m/min)>%')
				AND VALUE1 IS NOT NULL
				AND PRODID IS NOT NULL
--			    AND [PROD_VER_CODE] NOT LIKE 'Z%'	--2018-05-11 PIYONG DEL  테스트 버전도 포함
				AND PROC_FLAG = 'N'
					

			SET @v_err_check = 'CUR_TAT_TIME'

			OPEN CUR_TAT_TIME;
			FETCH NEXT FROM CUR_TAT_TIME INTO @FACTORY_ID											  
											  ,@ITEM_ID
											  ,@TAT_TIME
											  ,@CATEGORY
											  ,@PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					--2018-04-24 PIYONG  기준 테이블 변경
					MERGE INTO [dbo].[SCM_PLM_WO_TACT_TIME_M] TT
					USING (
							SELECT COMPANY_ID AS [COMPANY_ID]
								   ,DIVISION_ID AS [DIVISION_ID]
								   ,SITE_ID AS [SITE_ID]
								   ,PLANT_ID AS [PLANT_ID]
								   ,FACTORY_ID AS [FACTORY_ID]
								   ,@ITEM_ID AS [ITEM_ID]
								   ,CASE WHEN @FACTORY_ID IN ( 'E1', 'E2' ) AND ( @ITEM_ID LIKE 'APCCA%' OR  @ITEM_ID LIKE 'APCAN%') /*김춘동 양면만...*/THEN @TAT_TIME * 2 ELSE @TAT_TIME END  AS [TACT_TIME]
								   ,@CATEGORY AS CATEGORY
								   ,@PROD_VERSION_TYPE AS PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
								   ,( SELECT ATTRIBUTE2
									    FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
									   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
										 AND ACTIVE_FLAG = 'Y'
										 AND SEGMENT1 = @FACTORY_ID
										 AND SEGMENT2 = 'E2000'
									 ) AS UPDATE_YN
							  FROM SCM_FACTORY_M
							 WHERE FACTORY_ID = @FACTORY_ID
						  ) TEMP
					  ON (
							TT.[COMPANY_ID] = TEMP.COMPANY_ID
							AND TT.[DIVISION_ID] = TEMP.DIVISION_ID
							AND TT.[SITE_ID] =  TEMP.SITE_ID
							AND TT.[PLANT_ID] = TEMP.PLANT_ID
							AND TT.[FACTORY_ID] = TEMP.FACTORY_ID
							AND TT.[ITEM_ID] = TEMP.ITEM_ID
							AND TT.[CATEGORY] = TEMP.CATEGORY
							AND TT.PROD_VERSION_TYPE = TEMP.[PROD_VERSION_TYPE]		--2018-06-26 PIYONG ADD
						 )
					WHEN MATCHED THEN
						UPDATE
						  SET TT.[TACT_TIME] = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN TEMP.[TACT_TIME] ELSE TT.[TACT_TIME]  END
							  ,TT.GPLM_TACT_TIME  = TEMP.[TACT_TIME]
							  ,TT.UPDATE_ID = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN 'PR_XIF_PLM_WO_INSP_SPEC_R' ELSE TT.UPDATE_ID END
							  ,TT.UPDATE_TIME = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN GETDATE() ELSE TT.UPDATE_TIME END
					WHEN NOT MATCHED THEN
						INSERT (
								[COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[ITEM_ID]
								,[CATEGORY]
								,[TACT_TIME]
								,[GPLM_TACT_TIME]
								,[PROD_VERSION_TYPE]		--2018-06-26 PIYONG ADD
							    ,[INSERT_ID]
							    ,[INSERT_TIME]
							    ,[UPDATE_ID]
							    ,[UPDATE_TIME]
						) VALUES(      								
								TEMP.COMPANY_ID
								,TEMP.DIVISION_ID
								,TEMP.SITE_ID
								,TEMP.PLANT_ID
								,TEMP.FACTORY_ID
								,TEMP.ITEM_ID
								,TEMP.CATEGORY
								,CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN TEMP.[TACT_TIME] ELSE 0  END
								,TEMP.TACT_TIME
								,TEMP.PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
								,'PR_XIF_PLM_WO_INSP_SPEC_R'
								,GETDATE()
								,CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN 'PR_XIF_PLM_WO_INSP_SPEC_R' ELSE NULL END
								,GETDATE()
						)
					;
	
					SET @ROWCOUNT = @@ROWCOUNT
			 				   	
					FETCH NEXT FROM CUR_TAT_TIME INTO @FACTORY_ID											  
													  ,@ITEM_ID
													  ,@TAT_TIME
													  ,@CATEGORY
													  ,@PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
					;
				END;

			CLOSE CUR_TAT_TIME;
			DEALLOCATE CUR_TAT_TIME;

			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'Y'
				   ,PROC_DATE = GETDATE()
			 WHERE PROC_ID = 'E2000'
			   AND ( SPEC_ITEM_ID LIKE 'I-%C1-001' OR  SPEC_ITEM_NAME LIKE N'Coating Speed (m/min)>%')
			   AND VALUE1 IS NOT NULL
		       AND PRODID IS NOT NULL
		       AND PROC_FLAG = 'P'



			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'P'
			 WHERE PROC_ID = 'E3000'
			   AND (SPEC_ITEM_ID LIKE  'I-%-SPEC-B02' OR SPEC_ITEM_ID LIKE  'I-%-SPEC-003' 
					OR SPEC_ITEM_ID = 'I-M011-SPECE-006' --> 'I-M011-SPECE-010' --nff
					OR SPEC_ITEM_ID = 'I-M016-SPECA-005' --> 'I-M016-SPECA-010' --nff -- 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
				   ) 
			   AND SPEC_ITEM_ID != 'I-M005-SPEC-003' -- 2022-04-14 김현 [C20220328-000596] NFF 부등호 조건 추가
			   AND VALUE1 IS NOT NULL
			   AND PRODID IS NOT NULL
--			   AND [PROD_VER_CODE] NOT LIKE 'Z%'	--2018-05-11 PIYONG DEL  테스트 버전도 포함
			   AND PROC_FLAG = 'N'
					

			SET @v_err_check = 'CUR_RP_TAT_TIME'

			OPEN CUR_RP_TAT_TIME;
			FETCH NEXT FROM CUR_RP_TAT_TIME INTO @COMPANY_ID
											  ,@DIVISION_ID
											  ,@SITE_ID
											  ,@PLANT_ID
											  ,@FACTORY_ID
											  ,@OPERATION_ID
											  ,@LINE_ID
											  ,@ELECTRODE_TYPE
											  ,@ITEM_ID
											  ,@MONTH
											  ,@TAT_TIME
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					MERGE INTO [dbo].[SCM_TACT_TIME_M] TT
					USING (
							SELECT @COMPANY_ID AS [COMPANY_ID]
								   ,@DIVISION_ID AS [DIVISION_ID]
								   ,@SITE_ID AS [SITE_ID]
								   ,@PLANT_ID AS [PLANT_ID]
								   ,@FACTORY_ID AS [FACTORY_ID]
								   ,@OPERATION_ID AS [OPERATION_ID]
								   ,@LINE_ID AS [LINE_ID]
								   ,@ELECTRODE_TYPE AS [ELECTRODE_TYPE]
								   ,@ITEM_ID AS [ITEM_ID]
								   ,@MONTH AS [MONTH]
								   ,@TAT_TIME AS [TACT_TIME]
								   ,( SELECT ATTRIBUTE2
									    FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
									   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
										 AND ACTIVE_FLAG = 'Y'
										 AND SEGMENT1 = @FACTORY_ID
										 AND SEGMENT2 = @OPERATION_ID
									 ) AS UPDATE_YN
						  ) TEMP
					  ON (
							TT.[COMPANY_ID] = TEMP.COMPANY_ID
							AND TT.[DIVISION_ID] = TEMP.DIVISION_ID
							AND TT.[SITE_ID] =  TEMP.SITE_ID
							AND TT.[PLANT_ID] = TEMP.PLANT_ID
							AND TT.FACTORY_ID = TEMP.FACTORY_ID
							AND TT.OPERATION_ID = TEMP.OPERATION_ID
							AND TT.[OPERATION_ID] = TEMP.OPERATION_ID
							AND TT.[LINE_ID] = TEMP.LINE_ID
							AND TT.[ELECTRODE_TYPE] = TEMP.ELECTRODE_TYPE
							AND TT.[ITEM_ID] = TEMP.ITEM_ID
							AND TT.[MONTH] = TEMP.MONTH
						 )
					WHEN MATCHED THEN
						UPDATE
						  SET TT.[TACT_TIME] = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN TEMP.[TACT_TIME] ELSE TT.[TACT_TIME]  END
							  ,TT.GPLM_TACT_TIME  = TEMP.[TACT_TIME]
							  ,TT.UPDATE_ID = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN 'PR_XIF_PLM_WO_INSP_SPEC_R' ELSE TT.UPDATE_ID END
							  ,TT.UPDATE_TIME = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN GETDATE() ELSE TT.UPDATE_TIME END
					WHEN NOT MATCHED THEN
						INSERT (
								[COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[OPERATION_ID]
								,[LINE_ID]
								,[ELECTRODE_TYPE]
								,[ITEM_ID]
								,[MONTH]
								,[TACT_TIME]
								,[TACT_TIME_UOM]
								,[GPLM_TACT_TIME]
							    ,[INSERT_ID]
							    ,[INSERT_TIME]
							    ,[UPDATE_ID]
							    ,[UPDATE_TIME]
						) VALUES(      								
								TEMP.COMPANY_ID
								,TEMP.DIVISION_ID
								,TEMP.SITE_ID
								,TEMP.PLANT_ID
								,TEMP.FACTORY_ID
								,TEMP.OPERATION_ID
								,TEMP.LINE_ID
								,TEMP.ELECTRODE_TYPE
								,TEMP.ITEM_ID
								,TEMP.MONTH
								,CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN TEMP.[TACT_TIME] ELSE 0  END
								,'SECOND'
								,TEMP.TACT_TIME
								,'PR_XIF_PLM_WO_INSP_SPEC_R'
								,GETDATE()
								,CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN 'PR_XIF_PLM_WO_INSP_SPEC_R' ELSE NULL END
								,GETDATE()
						)
					;
	
					SET @ROWCOUNT = @@ROWCOUNT
			 				   	
					FETCH NEXT FROM CUR_RP_TAT_TIME INTO @COMPANY_ID
													  ,@DIVISION_ID
													  ,@SITE_ID
													  ,@PLANT_ID
													  ,@FACTORY_ID
													  ,@OPERATION_ID
													  ,@LINE_ID
													  ,@ELECTRODE_TYPE
													  ,@ITEM_ID
													  ,@MONTH
													  ,@TAT_TIME
					;
				END;

			CLOSE CUR_RP_TAT_TIME;
			DEALLOCATE CUR_RP_TAT_TIME;


			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'Y'
			       ,PROC_DATE = GETDATE()
			 WHERE PROC_ID = 'E3000'
			   AND (SPEC_ITEM_ID LIKE  'I-%-SPEC-B02' OR SPEC_ITEM_ID LIKE  'I-%-SPEC-003' 
					OR SPEC_ITEM_ID = 'I-M011-SPECE-006' --> 'I-M011-SPECE-010' --nff
					OR SPEC_ITEM_ID = 'I-M016-SPECA-005' --> 'I-M016-SPECA-010' --nff -- 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
				   ) 
		       AND PRODID IS NOT NULL
		       AND PROC_FLAG = 'P'
		
			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'P'
			 WHERE (SPEC_ITEM_ID LIKE  'I-%-SPEC-B08' OR SPEC_ITEM_ID LIKE  'I-%-SPEC-016' OR SPEC_ITEM_ID LIKE  'I-%-SPEC-017' 
						OR SPEC_ITEM_ID = 'I-M011-SPECE-026' -- 'I-M011-SPECE-018'  --nff
						OR SPEC_ITEM_ID = 'I-M016-SPECA-034' -- 'I-M016-SPECA-018'  --nff
					) 
				AND PROC_ID = 'E4000'
				AND VALUE1 IS NOT NULL
				AND PRODID IS NOT NULL
--			    AND [PROD_VER_CODE] NOT LIKE 'Z%'	--2018-05-11 PIYONG DEL  테스트 버전도 포함
				AND PROC_FLAG = 'N'


			SET @v_err_check = 'CUR_SL_TAT_TIME'

			OPEN CUR_SL_TAT_TIME;
			FETCH NEXT FROM CUR_SL_TAT_TIME INTO @COMPANY_ID
											  ,@DIVISION_ID
											  ,@SITE_ID
											  ,@PLANT_ID
											  ,@FACTORY_ID
											  ,@OPERATION_ID
											  ,@LINE_ID
											  ,@ELECTRODE_TYPE
											  ,@ITEM_ID
											  ,@MONTH
											  ,@TAT_TIME
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					MERGE INTO [dbo].[SCM_TACT_TIME_M] TT
					USING (
							SELECT @COMPANY_ID AS [COMPANY_ID]
								   ,@DIVISION_ID AS [DIVISION_ID]
								   ,@SITE_ID AS [SITE_ID]
								   ,@PLANT_ID AS [PLANT_ID]
								   ,@FACTORY_ID AS [FACTORY_ID]
								   ,@OPERATION_ID AS [OPERATION_ID]
								   ,@LINE_ID AS [LINE_ID]
								   ,@ELECTRODE_TYPE AS [ELECTRODE_TYPE]
								   ,@ITEM_ID AS [ITEM_ID]
								   ,@MONTH AS [MONTH]
								   ,@TAT_TIME AS [TACT_TIME]
								   ,( SELECT ATTRIBUTE2
									    FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
									   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
										 AND ACTIVE_FLAG = 'Y'
										 AND SEGMENT1 = @FACTORY_ID
										 AND SEGMENT2 = @OPERATION_ID
									 ) AS UPDATE_YN
						  ) TEMP
					  ON (
							TT.[COMPANY_ID] = TEMP.COMPANY_ID
							AND TT.[DIVISION_ID] = TEMP.DIVISION_ID
							AND TT.[SITE_ID] =  TEMP.SITE_ID
							AND TT.[PLANT_ID] = TEMP.PLANT_ID
							AND TT.FACTORY_ID = TEMP.FACTORY_ID
							AND TT.OPERATION_ID = TEMP.OPERATION_ID
							AND TT.[OPERATION_ID] = TEMP.OPERATION_ID
							AND TT.[LINE_ID] = TEMP.LINE_ID
							AND TT.[ELECTRODE_TYPE] = TEMP.ELECTRODE_TYPE
							AND TT.[ITEM_ID] = TEMP.ITEM_ID
							AND TT.[MONTH] = TEMP.MONTH
						 )
					WHEN MATCHED THEN
						UPDATE
						  SET TT.[TACT_TIME] = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN TEMP.[TACT_TIME] ELSE TT.[TACT_TIME]  END
							  ,TT.GPLM_TACT_TIME  = TEMP.[TACT_TIME]
							  ,TT.UPDATE_ID = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN 'PR_XIF_PLM_WO_INSP_SPEC_R' ELSE TT.UPDATE_ID END
							  ,TT.UPDATE_TIME = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN GETDATE() ELSE TT.UPDATE_TIME END
					WHEN NOT MATCHED THEN
						INSERT (
								[COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[OPERATION_ID]
								,[LINE_ID]
								,[ELECTRODE_TYPE]
								,[ITEM_ID]
								,[MONTH]
								,[TACT_TIME]
								,[TACT_TIME_UOM]
								,[GPLM_TACT_TIME]
							    ,[INSERT_ID]
							    ,[INSERT_TIME]
							    ,[UPDATE_ID]
							    ,[UPDATE_TIME]
						) VALUES(      								
								TEMP.COMPANY_ID
								,TEMP.DIVISION_ID
								,TEMP.SITE_ID
								,TEMP.PLANT_ID
								,TEMP.FACTORY_ID
								,TEMP.OPERATION_ID
								,TEMP.LINE_ID
								,TEMP.ELECTRODE_TYPE
								,TEMP.ITEM_ID
								,TEMP.MONTH
								,CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN TEMP.[TACT_TIME] ELSE 0  END
								,'SECOND'
								,TEMP.TACT_TIME
								,'PR_XIF_PLM_WO_INSP_SPEC_R'
								,GETDATE()
								,CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN 'PR_XIF_PLM_WO_INSP_SPEC_R' ELSE NULL END
								,GETDATE()
						)
					;
	
					SET @ROWCOUNT = @@ROWCOUNT
			 				   	
					FETCH NEXT FROM CUR_SL_TAT_TIME INTO @COMPANY_ID
													  ,@DIVISION_ID
													  ,@SITE_ID
													  ,@PLANT_ID
													  ,@FACTORY_ID
													  ,@OPERATION_ID
													  ,@LINE_ID
													  ,@ELECTRODE_TYPE
													  ,@ITEM_ID
													  ,@MONTH
													  ,@TAT_TIME
					;
				END;

			CLOSE CUR_SL_TAT_TIME;
			DEALLOCATE CUR_SL_TAT_TIME;


			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'Y'
   				   ,PROC_DATE = GETDATE()
			 WHERE PROC_ID = 'E4000'
			   AND (SPEC_ITEM_ID LIKE  'I-%-SPEC-B08' OR SPEC_ITEM_ID LIKE  'I-%-SPEC-016' OR SPEC_ITEM_ID LIKE  'I-%-SPEC-017' 
						OR SPEC_ITEM_ID = 'I-M011-SPECE-026' -- 'I-M011-SPECE-018' --nff
						OR SPEC_ITEM_ID = 'I-M016-SPECA-034' -- 'I-M016-SPECA-018' --nff
					) 
		       AND PRODID IS NOT NULL
		       AND PROC_FLAG = 'P'





			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'P'
			 WHERE PROC_ID = 'E1000'
			   AND SPEC_ITEM_ID LIKE 'I-%-SPEC-%2'
			   AND SPEC_ITEM_ID !='I-M001-SPEC-002'   --nff 구코드 
			   AND SPEC_ITEM_ID !='I-M001-SPEC-012'	  --nff 구코드 
			   AND SPEC_ITEM_ID !='I-M013-SPEC-002'	  --nff 구코드 
			   AND SPEC_ITEM_ID !='I-M013-SPEC-004_2' --nff 구코드 
			   AND SPEC_ITEM_ID !='I-M013-SPEC-005_2' --nff 구코드 
			   AND SPEC_ITEM_ID !='I-M013-SPEC-012'   --nff 구코드 2022-04-14 김현 [C20220328-000596] NFF 예외 조건 추가
			   AND PRODID IS NOT NULL
--			   AND [PROD_VER_CODE] NOT LIKE 'Z%'	--2018-05-11 PIYONG DEL  테스트 버전도 포함
			   AND PROC_FLAG = 'N'

			SET @v_err_check = 'CUR_LOT_SIZE'

			OPEN CUR_LOT_SIZE;
			FETCH NEXT FROM CUR_LOT_SIZE INTO @FACTORY_ID
											  ,@OPERATION_ID
											  ,@ITEM_ID
											  ,@UNIT
											  ,@LOT_SIZE
											  ,@PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					MERGE INTO [dbo].[SCM_ITEM_EQUIP_RATE_BATCH_M] IERB
					USING (
							SELECT COMPANY_ID
								   ,DIVISION_ID
								   ,SITE_ID
								   ,PLANT_ID
								   ,FACTORY_ID
								   ,@OPERATION_ID AS OPERATION_ID
								   ,@ITEM_ID AS ITEM_ID
								   ,@UNIT AS UNIT
								   ,@LOT_SIZE AS LOT_SIZE
								   ,@PROD_VERSION_TYPE AS PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
								   ,( SELECT ATTRIBUTE1
									    FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
									   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
										 AND ACTIVE_FLAG = 'Y'
										 AND SEGMENT1 = @FACTORY_ID
										 AND SEGMENT2 = @OPERATION_ID
									 ) AS UPDATE_YN
							 FROM SCM_FACTORY_M
						    WHERE FACTORY_ID = @FACTORY_ID
						  ) TEMP
					  ON (
							IERB.FACTORY_ID = TEMP.FACTORY_ID
							AND IERB.OPERATION_ID = TEMP.OPERATION_ID
							AND IERB.ITEM_ID = TEMP.ITEM_ID
							AND IERB.PROD_VERSION_TYPE = TEMP.PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
						 )
					WHEN MATCHED THEN
						UPDATE
						  SET IERB.BATCH_LOT_SIZE = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN TEMP.LOT_SIZE ELSE IERB.BATCH_LOT_SIZE END
--							  ,IERB.LOT_SIZE_UOM = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN TEMP.UNIT ELSE IERB.LOT_SIZE_UOM END 
							  ,IERB.GPLM_BATCH_LOT_SIZE = TEMP.LOT_SIZE
							  ,IERB.UPDATE_ID = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN 'PR_XIF_PLM_WO_INSP_SPEC_R' ELSE IERB.UPDATE_ID END
							  ,IERB.UPDATE_TIME = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN GETDATE() ELSE IERB.UPDATE_TIME END 
					WHEN NOT MATCHED THEN
						INSERT (
								[COMPANY_ID]
							    ,[DIVISION_ID]
							    ,[SITE_ID]
							    ,[PLANT_ID]
							    ,[FACTORY_ID]
							    ,[OPERATION_ID]
							    ,[ITEM_ID]
								,[BATCH_LOT_SIZE]
								,[LOT_SIZE_UOM]
								,[GPLM_BATCH_LOT_SIZE]
								,[RATIO_ID]
								,[ACTIVE_FLAG]					--2018-05-02 PIYONG ADD
								,[PROD_VERSION_TYPE]			--2018-06-26 PIYONG ADD
							    ,[INSERT_ID]
							    ,[INSERT_TIME]
							    ,[UPDATE_ID]
							    ,[UPDATE_TIME]
						) VALUES(      								
								TEMP.COMPANY_ID
								,TEMP.DIVISION_ID
								,TEMP.SITE_ID
								,TEMP.PLANT_ID
								,TEMP.FACTORY_ID
								,TEMP.OPERATION_ID
								,TEMP.ITEM_ID
								,TEMP.LOT_SIZE
								,'KG'
								,TEMP.LOT_SIZE
								,'-'
								,'Y'							--2018-05-02 PIYONG ADD
								,TEMP.PROD_VERSION_TYPE			--2018-06-26 PIYONG ADD
								,'PR_XIF_PLM_WO_INSP_SPEC_R'
								,GETDATE()
								,CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN 'PR_XIF_PLM_WO_INSP_SPEC_R' ELSE NULL END
								,GETDATE()
						)
					;
	
					SET @ROWCOUNT = @@ROWCOUNT
			 				   	
					FETCH NEXT FROM CUR_LOT_SIZE INTO @FACTORY_ID
												  ,@OPERATION_ID
												  ,@ITEM_ID
												  ,@UNIT
												  ,@LOT_SIZE
												  ,@PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
					;
				END;

			CLOSE CUR_LOT_SIZE;
			DEALLOCATE CUR_LOT_SIZE;

			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'Y'
   				   ,PROC_DATE = GETDATE()
			 WHERE PROC_ID = 'E1000'
			   AND SPEC_ITEM_ID LIKE 'I-%-SPEC-%2'
			   AND SPEC_ITEM_ID !='I-M001-SPEC-002'   --nff 구코드
			   AND SPEC_ITEM_ID !='I-M001-SPEC-012'	  --nff 구코드
			   AND SPEC_ITEM_ID !='I-M013-SPEC-002'	  --nff 구코드
			   AND SPEC_ITEM_ID !='I-M013-SPEC-004_2' --nff 구코드
			   AND SPEC_ITEM_ID !='I-M013-SPEC-005_2' --nff 구코드
			   AND SPEC_ITEM_ID !='I-M013-SPEC-012'   --nff 구코드 -- 2022-04-14 김현 [C20220328-000596] NFF 예외 조건 추가
			   AND PRODID IS NOT NULL
--			   AND [PROD_VER_CODE] NOT LIKE 'Z%'	--2018-05-11 PIYONG DEL  테스트 버전도 포함
			   AND PROC_FLAG = 'P'


			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'P'
			 WHERE PROC_ID = 'E4000'
			   AND VALUE1 IS NOT NULL
			   AND [PRODID] IS NOT NULL
--			   AND [PROD_VER_CODE] NOT LIKE 'Z%'	--2018-05-11 PIYONG DEL  테스트 버전도 포함
			   AND ( SPEC_ITEM_ID LIKE '%E-010%' 
			   --      OR SPEC_ITEM_ID = 'I-M011-SPECE-023' --nff 신코드 없음
					 --OR SPEC_ITEM_ID = 'I-M016-SPECA-023' --nff 신코드 없음  -- 2022-04-14 김현 [C20220328-000596] NFF 유형용 조건 조정
				   ) 
			   AND SPEC_ITEM_ID != 'I-M011-SPECE-006' --> 'I-M011-SPECE-010'  --nff
			   AND SPEC_ITEM_ID != 'I-M016-SPECA-005' --> 'I-M016-SPECA-010'  --nff 2022-04-14 김현 [C20220328-000596] NFF 유형용 조건 조정
			   AND PROC_FLAG = 'N'
			   

			SET @v_err_check = 'CUR_PC_ROLL'

			OPEN CUR_PC_ROLL;
			FETCH NEXT FROM CUR_PC_ROLL INTO @FACTORY_ID
											 ,@ITEM_ID
											 ,@LENGTH
											 ,@WO_ID
											 ,@PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
											 ,@POST_TYPE -- 2022-05-23 E3000E4000 형성 여부
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @CNT = (	SELECT COUNT(*)
									  FROM DBO.[SCM_ITEM_LANE_M] A
										  ,(SELECT COMPANY_ID
												   ,DIVISION_ID
												   ,SITE_ID
												   ,PLANT_ID
												   ,FACTORY_ID
												   ,@ITEM_ID AS ITEM_ID
											 FROM SCM_FACTORY_M
											WHERE FACTORY_ID = @FACTORY_ID
										 )B
								   WHERE A.COMPANY_ID = B.COMPANY_ID
									 AND A.DIVISION_ID = B.DIVISION_ID
									 AND A.SITE_ID = B.SITE_ID
									 AND A.PLANT_ID = B.PLANT_ID
									 AND A.FACTORY_ID = B.FACTORY_ID
									 AND A.ITEM_ID = B.ITEM_ID
									 AND A.PROD_VERSION_TYPE =  @PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
								)
					;

					IF @CNT > 0
						BEGIN
							UPDATE A
							   SET  PC_ROLL_LENGTH      = CASE WHEN SV.UP_FLAG = 'ALL' THEN @LENGTH ELSE PC_ROLL_LENGTH END -- 2022-04-14 김현 [C20220328-000596] add for PLM Apply Option
							       ,GPLM_PC_ROLL_LENGTH = @LENGTH -- 2022-04-14 김현 [C20220328-000596] add for PLM Apply Option
								   ,PC_ROLL_LENGTH_UOM = 'm'
								   ,UPDATE_TIME =  GETDATE()
								   ,UPDATE_ID = CASE WHEN UPDATE_ID = 'PR_XIF_PLM_CONVERSION_RATE_R' THEN UPDATE_ID ELSE 'PR_XIF_PLM_WO_INSP_SPEC_R' END
								    -- 2021-05-14 kimcd SCM_ITEM_LANE_M UPDATE ID가 PR_XIF_PLM_CONVERSION_RATE_R 인 경우 변경자는 바꾸지 않음. Pancake Master UI에서 값 변경 제한
							  FROM DBO.[SCM_ITEM_LANE_M] A
								   ,(SELECT COMPANY_ID
										   ,DIVISION_ID
										   ,SITE_ID
										   ,PLANT_ID
										   ,FACTORY_ID
										   ,@ITEM_ID AS ITEM_ID
									  FROM SCM_FACTORY_M
									 WHERE FACTORY_ID = @FACTORY_ID
								  ) B
								  ,	( SELECT ATTRIBUTE7 AS UP_FLAG
									    FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
									   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
										 AND ACTIVE_FLAG = 'Y'
										 AND SEGMENT1 = @FACTORY_ID
										 AND SEGMENT2 = 'E4000'
									 ) AS SV  -- 2022-04-14 김현 [C20220328-000596] add for PLM Apply Option
						    WHERE A.COMPANY_ID = B.COMPANY_ID
							  AND A.DIVISION_ID = B.DIVISION_ID
							  AND A.SITE_ID = B.SITE_ID
							  AND A.PLANT_ID = B.PLANT_ID
							  AND A.FACTORY_ID = B.FACTORY_ID
							  AND A.ITEM_ID = B.ITEM_ID
							  AND A.PROD_VERSION_TYPE = @PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD

							IF @POST_TYPE IS NOT NULL AND @POST_TYPE != '' -- 2022-05-23 JUMBO ROLL 정권 길이 전극 후 고정에 유형에 추가
								BEGIN
									UPDATE A
									   SET  PC_ROLL_LENGTH      = CASE WHEN SV.UP_FLAG = 'ALL' THEN @LENGTH ELSE PC_ROLL_LENGTH END
										   ,GPLM_PC_ROLL_LENGTH = @LENGTH
										   ,PC_ROLL_LENGTH_UOM = 'm'
										   ,UPDATE_TIME =  GETDATE()
										   ,UPDATE_ID = CASE WHEN UPDATE_ID = 'PR_XIF_PLM_CONVERSION_RATE_R' THEN UPDATE_ID ELSE 'PR_XIF_PLM_WO_INSP_SPEC_R' END
											-- 2021-05-14 kimcd SCM_ITEM_LANE_M UPDATE ID가 PR_XIF_PLM_CONVERSION_RATE_R 인 경우 변경자는 바꾸지 않음. Pancake Master UI에서 값 변경 제한
									  FROM DBO.[SCM_ITEM_LANE_M] A
										   ,(SELECT COMPANY_ID
												   ,DIVISION_ID
												   ,SITE_ID
												   ,PLANT_ID
												   ,FACTORY_ID
												   ,@ITEM_ID AS ITEM_ID
											  FROM SCM_FACTORY_M
											 WHERE FACTORY_ID = @FACTORY_ID
										  ) B
										  ,	( SELECT ATTRIBUTE7 AS UP_FLAG
												FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
											   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
												 AND ACTIVE_FLAG = 'Y'
												 AND SEGMENT1 = @FACTORY_ID
												 AND SEGMENT2 = 'E4000'
											 ) AS SV
									WHERE A.COMPANY_ID = B.COMPANY_ID
									  AND A.DIVISION_ID = B.DIVISION_ID
									  AND A.SITE_ID = B.SITE_ID
									  AND A.PLANT_ID = B.PLANT_ID
									  AND A.FACTORY_ID = B.FACTORY_ID
									  AND A.ITEM_ID = B.ITEM_ID
									  AND A.PROD_VERSION_TYPE = @POST_TYPE
								END;

							UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
							   SET PROC_FLAG = 'Y'
							       ,PROC_DATE = GETDATE()
							 WHERE WO_ID = @WO_ID
							   AND PRODID = @ITEM_ID
							   AND AREA_ID = @FACTORY_ID
		                       AND ( SPEC_ITEM_ID LIKE '%E-010%' 
							   --      OR SPEC_ITEM_ID = 'I-M011-SPECE-023' --nff 신코드 없음
									 --OR SPEC_ITEM_ID = 'I-M016-SPECA-023' --nff 신코드 없음  -- 2022-04-14 김현 [C20220328-000596] NFF 유형용 조건 조정
								   ) 
							   AND PROC_FLAG = 'P'
							   AND PROC_ID = 'E4000';
						END
					;


			 				   	
					FETCH NEXT FROM CUR_PC_ROLL INTO @FACTORY_ID
													 ,@ITEM_ID
													 ,@LENGTH
													 ,@WO_ID
													 ,@PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
													 ,@POST_TYPE -- 2022-05-23 E3000E4000 형성 여부
					;
				END;

			CLOSE CUR_PC_ROLL;
			DEALLOCATE CUR_PC_ROLL;

			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'N'
				   ,PROC_DATE = GETDATE()
			 WHERE PROC_ID = 'E4000'
			   AND VALUE1 IS NOT NULL
			   AND [PRODID] IS NOT NULL
--			   AND [PROD_VER_CODE] NOT LIKE 'Z%'	--2018-05-11 PIYONG DEL  테스트 버전도 포함
			   AND ( SPEC_ITEM_ID LIKE '%E-010%' 
			   --      OR SPEC_ITEM_ID = 'I-M011-SPECE-023'   --nff 신코드는 없음
					 --OR SPEC_ITEM_ID = 'I-M016-SPECA-023'   --nff 신코드는 없음  -- 2022-04-14 김현 [C20220328-000596] NFF 유형용 조건 조정
				    ) 
							   AND SPEC_ITEM_ID != 'I-M011-SPECE-006' --> 'I-M011-SPECE-010'  --nff
							   AND SPEC_ITEM_ID != 'I-M016-SPECA-005' --> 'I-M016-SPECA-010'  -- 2022-04-14 김현 [C20220328-000596] NFF 유형용 조건 조정
			   AND PROC_FLAG = 'P'


			-------------------------------------------------------------------------------------
			--2018-04-12 PIYONG ADD
			-------------------------------------------------------------------------------------
			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'P'
			 WHERE PROC_ID = 'E1000'
		       AND [SPEC_ITEM_NAME] = 'Total mixing time'
		       AND PRODID IS NOT NULL
--			   AND [PROD_VER_CODE] NOT LIKE 'Z%'	--2018-05-11 PIYONG DEL  테스트 버전도 포함
		       AND PROC_FLAG = 'N'

			SET @v_err_check = 'CUR_TAT'

			OPEN CUR_TAT;
			FETCH NEXT FROM CUR_TAT INTO @FACTORY_ID
										 ,@OPERATION_ID
										 ,@ITEM_ID
										 ,@TAT
										 ,@PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					MERGE INTO [dbo].[SCM_ITEM_EQUIP_RATE_BATCH_M] IERB
					USING (
							SELECT COMPANY_ID
								   ,DIVISION_ID
								   ,SITE_ID
								   ,PLANT_ID
								   ,FACTORY_ID
								   ,@OPERATION_ID AS OPERATION_ID
								   ,@ITEM_ID AS ITEM_ID
								   ,@TAT AS TAT
								   ,@PROD_VERSION_TYPE AS PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
								   ,( SELECT ATTRIBUTE4
									    FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
									   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
										 AND ACTIVE_FLAG = 'Y'
										 AND SEGMENT1 = @FACTORY_ID
										 AND SEGMENT2 = @OPERATION_ID
									 ) AS UPDATE_YN
							 FROM SCM_FACTORY_M
						    WHERE FACTORY_ID = @FACTORY_ID
						  ) TEMP
					  ON (
							IERB.FACTORY_ID = TEMP.FACTORY_ID
							AND IERB.OPERATION_ID = TEMP.OPERATION_ID
							AND IERB.ITEM_ID = TEMP.ITEM_ID
							AND IERB.PROD_VERSION_TYPE = TEMP.PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
						 )
					WHEN MATCHED THEN
						UPDATE
						  SET IERB.TAT = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN TEMP.TAT ELSE IERB.TAT END
							  ,IERB.GPLM_TAT = TEMP.TAT
							  ,IERB.UPDATE_ID = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN 'PR_XIF_PLM_WO_INSP_SPEC_R' ELSE IERB.UPDATE_ID END
							  ,IERB.UPDATE_TIME = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN GETDATE() ELSE IERB.UPDATE_TIME END 
					WHEN NOT MATCHED THEN
						INSERT (
								[COMPANY_ID]
							    ,[DIVISION_ID]
							    ,[SITE_ID]
							    ,[PLANT_ID]
							    ,[FACTORY_ID]
							    ,[OPERATION_ID]
							    ,[ITEM_ID]
								,[BATCH_LOT_SIZE]
								,[TAT]
								,[GPLM_TAT]
								,[TAT_UOM]
								,[RATIO_ID]
								,[ACTIVE_FLAG]						-- 2018-05-02 PIYONG ADD
							    ,[INSERT_ID]
							    ,[INSERT_TIME]
							    ,[UPDATE_ID]
							    ,[UPDATE_TIME]
								,[PROD_VERSION_TYPE]                --2018-06-26 PIYONG ADD
						) VALUES(      								
								TEMP.COMPANY_ID
								,TEMP.DIVISION_ID
								,TEMP.SITE_ID
								,TEMP.PLANT_ID
								,TEMP.FACTORY_ID
								,TEMP.OPERATION_ID
								,TEMP.ITEM_ID
								,0
								,TEMP.TAT
								,TEMP.TAT
								,'MINUTE'
								,'-'
								,'Y'							--2018-05-02 PIYONG ADD
								,'PR_XIF_PLM_WO_INSP_SPEC_R'
								,GETDATE()
								,CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN 'PR_XIF_PLM_WO_INSP_SPEC_R' ELSE NULL END
								,GETDATE()
								,@PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
						)
					;
	
					SET @ROWCOUNT = @@ROWCOUNT
			 				   	
					FETCH NEXT FROM CUR_TAT INTO @FACTORY_ID
												 ,@OPERATION_ID
												 ,@ITEM_ID
												 ,@TAT
												 ,@PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
					;
				END;

			CLOSE CUR_TAT;
			DEALLOCATE CUR_TAT;

			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'Y'
   				   ,PROC_DATE = GETDATE()
			 WHERE PROC_ID = 'E1000'
		       AND [SPEC_ITEM_NAME] = 'Total mixing time'
		       AND PRODID IS NOT NULL
--			   AND [PROD_VER_CODE] NOT LIKE 'Z%'	--2018-05-11 PIYONG DEL  테스트 버전도 포함
		       AND PROC_FLAG = 'P'
			-------------------------------------------------------------------------------------
			--2018-04-24 PIYONG ADD
			-------------------------------------------------------------------------------------
			--LANE 수
			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'P'
			 WHERE PROC_ID = 'E4000'
		       AND SPEC_ITEM_NAME LIKE N'%Lane%'
			   AND (
					SPEC_ITEM_ID LIKE N'I-%011-SPEC-008'
					OR SPEC_ITEM_ID LIKE N'I-%016-SPEC-008'

					OR SPEC_ITEM_ID LIKE N'I-%016-SPEC-C08'
					OR SPEC_ITEM_ID LIKE N'I-%011-SPEC-C08'

					OR SPEC_ITEM_ID LIKE N'I-%011-SPECE-005'
					OR SPEC_ITEM_ID LIKE N'I-%016-SPECA-005'

					OR SPEC_ITEM_ID LIKE N'I-P011-SPEC-011'

					OR SPEC_ITEM_ID LIKE N'I-P016-SPEC-007'

					OR SPEC_ITEM_ID LIKE N'I-E016-SPECA-L0%'
			   		OR SPEC_ITEM_ID = 'I-M009-SPECE-040' --> 'I-M011-SPECE-006'  -- 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
					OR SPEC_ITEM_ID = 'I-M014-SPECA-037' --> 'I-M016-SPECA-006'   -- 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
				   )
		       AND PRODID IS NOT NULL
			   --AND SPEC_ITEM_ID != N'I-M011-SPECE-005'  --nff 신코드 없음 -- 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
			   --AND SPEC_ITEM_ID != N'I-M016-SPECA-005'  --nff 신코드 없음 -- 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
		       AND PROC_FLAG = 'N'

/*			--2019-03-28 PIYONG DEL 장현석 책임 요청
			OPEN CUR_SL_LANE;
			FETCH NEXT FROM CUR_SL_LANE INTO @FACTORY_ID
										     ,@OPERATION_ID
										     ,@ITEM_ID
										     ,@MAIN_QTY
											 ,@SUB_QTY
											 ,@PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					
					MERGE INTO [dbo].[SCM_ITEM_LANE_M] IL
					USING (
							SELECT COMPANY_ID
								   ,DIVISION_ID
								   ,SITE_ID
								   ,PLANT_ID
								   ,FACTORY_ID
								   ,@ITEM_ID AS ITEM_ID
								   ,ISNULL(@MAIN_QTY, 0) + ISNULL(@SUB_QTY, 0) AS LANE_QTY
								   ,ISNULL(@MAIN_QTY, 0) AS MAIN_QTY
								   ,ISNULL(@SUB_QTY, 0) AS SUB_QTY
								   ,@PROD_VERSION_TYPE AS PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
								   ,( SELECT ATTRIBUTE5
									    FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
									   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
										 AND ACTIVE_FLAG = 'Y'
										 AND SEGMENT1 = @FACTORY_ID
										 AND SEGMENT2 = @OPERATION_ID
									 ) AS UPDATE_YN
							 FROM SCM_FACTORY_M
						    WHERE FACTORY_ID = @FACTORY_ID
						  ) TEMP
					   ON (
							IL.COMPANY_ID				= TEMP.COMPANY_ID
							AND IL.DIVISION_ID			= TEMP.DIVISION_ID
							AND IL.SITE_ID				= TEMP.SITE_ID
							AND IL.PLANT_ID				= TEMP.PLANT_ID
							AND IL.ITEM_ID				= TEMP.ITEM_ID
							AND IL.LANE_QTY				= TEMP.LANE_QTY
							AND IL.FACTORY_ID			= TEMP.FACTORY_ID
							AND IL.PROD_VERSION_TYPE	= TEMP.PROD_VERSION_TYPE							
						  )
					WHEN MATCHED THEN
						UPDATE
						  SET IL.LANE_QTY = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN TEMP.LANE_QTY ELSE IL.LANE_QTY END
							  ,IL.MAIN_LANE_QTY = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN TEMP.MAIN_QTY ELSE IL.MAIN_LANE_QTY END
							  ,IL.SUB_LANE_QTY = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN TEMP.SUB_QTY ELSE IL.SUB_LANE_QTY END
							  ,IL.GPLM_LANE_QTY = TEMP.LANE_QTY
							  ,IL.GPLM_MAIN_LANE_QTY = TEMP.MAIN_QTY
							  ,IL.GPLM_SUB_LANE_QTY = TEMP.SUB_QTY
							  ,IL.UPDATE_ID = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN 'PR_XIF_PLM_WO_INSP_SPEC_R' ELSE IL.UPDATE_ID END
							  ,IL.UPDATE_TIME = CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN GETDATE() ELSE IL.UPDATE_TIME END
					WHEN NOT MATCHED THEN
						INSERT (
								[COMPANY_ID]
							    ,[DIVISION_ID]
							    ,[SITE_ID]
							    ,[PLANT_ID]
							    ,[FACTORY_ID]
							    ,[ITEM_ID]
								,[LANE_QTY]
								,[MAIN_LANE_QTY]
								,[SUB_LANE_QTY]
								,[GPLM_LANE_QTY]
								,[GPLM_MAIN_LANE_QTY]
								,[GPLM_SUB_LANE_QTY]
								,[PROD_VERSION_TYPE]	--2018-06-26 PIYONG ADD
							    ,[INSERT_ID]
							    ,[INSERT_TIME]
							    ,[UPDATE_ID]
							    ,[UPDATE_TIME]
						) VALUES(      								
								TEMP.COMPANY_ID
								,TEMP.DIVISION_ID
								,TEMP.SITE_ID
								,TEMP.PLANT_ID
								,TEMP.FACTORY_ID
								,TEMP.ITEM_ID
								,TEMP.LANE_QTY
								,TEMP.MAIN_QTY
								,TEMP.SUB_QTY
								,TEMP.LANE_QTY
								,TEMP.MAIN_QTY
								,TEMP.SUB_QTY
								,TEMP.PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
								,'PR_XIF_PLM_WO_INSP_SPEC_R'
								,GETDATE()
								,CASE WHEN TEMP.UPDATE_YN = 'ALL' THEN 'PR_XIF_PLM_WO_INSP_SPEC_R' ELSE NULL END
								,GETDATE()
						)
					;

			 				   	
					FETCH NEXT FROM CUR_SL_LANE INTO @FACTORY_ID
												     ,@OPERATION_ID
												     ,@ITEM_ID
												     ,@MAIN_QTY
													 ,@SUB_QTY
													 ,@PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
					;
				END;

			CLOSE CUR_SL_LANE;
			DEALLOCATE CUR_SL_LANE;
*/

			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'Y'
   				   ,PROC_DATE = GETDATE()
			 WHERE PROC_ID = 'E4000'
		       AND SPEC_ITEM_NAME LIKE N'%Lane%'
			   AND (
					SPEC_ITEM_ID LIKE N'I-%011-SPEC-008'
					OR SPEC_ITEM_ID LIKE N'I-%016-SPEC-008'

					OR SPEC_ITEM_ID LIKE N'I-%016-SPEC-C08'
					OR SPEC_ITEM_ID LIKE N'I-%011-SPEC-C08'

					OR SPEC_ITEM_ID LIKE N'I-%011-SPECE-005'
					OR SPEC_ITEM_ID LIKE N'I-%016-SPECA-005'

					OR SPEC_ITEM_ID LIKE N'I-P011-SPEC-011'

					OR SPEC_ITEM_ID LIKE N'I-P016-SPEC-007'

					OR SPEC_ITEM_ID LIKE N'I-E016-SPECA-L0%'
			   		OR SPEC_ITEM_ID = 'I-M009-SPECE-040' --> 'I-M011-SPECE-006'  -- 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
					OR SPEC_ITEM_ID = 'I-M014-SPECA-037' --> 'I-M016-SPECA-006'   -- 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
				   )
			   --AND SPEC_ITEM_ID != N'I-M011-SPECE-005'  --nff 신코드 없음 -- 2022-04-14 김현 [C20220328-000596] NFF 조건 추가
			   --AND SPEC_ITEM_ID != N'I-M016-SPECA-005'  --nff 신코드 없음 --  2022-04-14 김현 [C20220328-000596] NFF 조건 추가
		       AND PROC_FLAG = 'P'


			-- FOIL
			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'P'
			 WHERE PROC_ID = 'E2000'
		       AND ( SPEC_ITEM_ID LIKE 'I-K%-SPEC-008'
					 OR SPEC_ITEM_ID LIKE 'I-C%-SPEC-008'
					 OR SPEC_ITEM_ID LIKE 'I-%009-FOIL-001'
					 OR SPEC_ITEM_ID LIKE 'I-%014-FOIL-002'
					 OR SPEC_ITEM_ID LIKE 'I-P009-SPEC-%10'
					 OR SPEC_ITEM_ID LIKE 'I-P014-SPEC-010'
				   )
		       AND PRODID IS NOT NULL
-- 			   AND PROD_VER_CODE NOT LIKE 'Z%'
		       AND PROC_FLAG = 'N'

			SET @v_err_check = 'CUR_FOIL'

			OPEN CUR_FOIL;
			FETCH NEXT FROM CUR_FOIL INTO @FACTORY_ID
										 ,@OPERATION_ID
										 ,@ITEM_ID
										 ,@FOIL_ID
										 ,@WO_ID
										 ,@PROD_VER_CODE
										 ,@PROD_VER_SEQ
										 ,@SPEC_ITEM_ID
										 ,@PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
										 ,@MODEL_ID					--2019-03-04 PIYONG ADD
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					MERGE INTO [dbo].[SCM_ITEM_FOIL_M] F
					USING (
							SELECT COMPANY_ID
									,DIVISION_ID
									,SITE_ID
									,PLANT_ID
									,FACTORY_ID
									,@MODEL_ID AS MODEL_ID
									,@ITEM_ID AS ITEM_ID
									,@PROD_VER_CODE AS PROD_VERSION
									,@PROD_VER_SEQ AS PROD_SEQ
									,@PROD_VERSION_TYPE AS PROD_VERSION_TYPE
									,@FOIL_ID AS FOIL_ID
								FROM SCM_FACTORY_M
							WHERE FACTORY_ID = @FACTORY_ID
							) M
						ON (
							F.FACTORY_ID = M.FACTORY_ID
							AND F.MODEL_ID = M.MODEL_ID
							AND F.ITEM_ID = M.ITEM_ID
							AND F.PROD_VERSION = M.PROD_VERSION
							AND F.PROD_SEQ = M.PROD_SEQ
							)
						WHEN MATCHED THEN
						UPDATE
							SET F.FOIL_ID = M.FOIL_ID
								,F.UPDATE_ID = 'PR_XIF_PLM_WO_INSP_SPEC_R'
								,F.UPDATE_TIME = GETDATE()
						WHEN NOT MATCHED THEN
						INSERT (
								[COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[MODEL_ID]
								,[ITEM_ID]
								,[PROD_VERSION]
								,[PROD_SEQ]
								,[PROD_VERSION_TYPE]
								,[FOIL_ID]
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
						) VALUES(      								
								M.COMPANY_ID
								,M.DIVISION_ID
								,M.SITE_ID
								,M.PLANT_ID
								,M.FACTORY_ID
								,M.MODEL_ID
								,M.ITEM_ID
								,M.PROD_VERSION
								,M.PROD_SEQ
								,M.PROD_VERSION_TYPE
								,M.FOIL_ID
								,'PR_XIF_PLM_WO_INSP_SPEC_R'
								,GETDATE()
								,'PR_XIF_PLM_WO_INSP_SPEC_R'
								,GETDATE()
						)
						;
	   	
					FETCH NEXT FROM CUR_FOIL INTO @FACTORY_ID
												 ,@OPERATION_ID
												 ,@ITEM_ID
												 ,@FOIL_ID
												 ,@WO_ID
												 ,@PROD_VER_CODE
												 ,@PROD_VER_SEQ			--2019-03-04 PIYONG ADD
												 ,@SPEC_ITEM_ID
												 ,@PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
												 ,@MODEL_ID				--2019-03-04 PIYONG ADD
					;
				END;

			CLOSE CUR_FOIL;
			DEALLOCATE CUR_FOIL;


			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'Y'
   				   ,PROC_DATE = GETDATE()
			 WHERE PROC_ID = 'E2000'
		       AND ( SPEC_ITEM_ID LIKE 'I-K%-SPEC-008'
					 OR SPEC_ITEM_ID LIKE 'I-C%-SPEC-008'
					 OR SPEC_ITEM_ID LIKE 'I-%009-FOIL-001'
					 OR SPEC_ITEM_ID LIKE 'I-%014-FOIL-002'
					 OR SPEC_ITEM_ID LIKE 'I-P009-SPEC-%10'
					 OR SPEC_ITEM_ID LIKE 'I-P014-SPEC-010'
				   )
		       AND PROC_FLAG = 'P'
			;
			-------------------------------------------------------------------------------------
			--2018-04-24 PIYONG ADD END
			-------------------------------------------------------------------------------------


			-------------------------------------------------------------------------------------
			--2018-12-18 PIYIONG ADD 고형분 비율
			-------------------------------------------------------------------------------------
			UPDATE [dbo].[SY_XIF_PLM_MIXER_MTRL_R]
			   SET PROC_FLAG = 'P'
   				   ,PROC_DATE = GETDATE()
			 WHERE PROC_FLAG = 'N'
			;


			SET @v_err_check = 'CUR_SOLID_RATE'

			OPEN CUR_SOLID_RATE;
			FETCH NEXT FROM CUR_SOLID_RATE INTO @MODEL_ID
												,@PROD_VER_CODE
												,@PROD_VER_SEQ		--2019-03-29 PIYONG ADD
												,@PROD_VERSION_TYPE
												,@ITEM_ID
												,@FACTORY_ID
												,@CHILD_CLASS_NAME
											    ,@CHILD_ITEM_ID
											    ,@CHILD_ITEM_NAME
											    ,@SOLID_RATE

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					MERGE INTO SCM_SLURRY_SOLID_RATE A
					USING (
							SELECT [COMPANY_ID]
								   ,[DIVISION_ID]
								   ,[SITE_ID]
								   ,[PLANT_ID]
								   ,[FACTORY_ID]
								   ,@MODEL_ID AS MODEL_ID
								   ,@PROD_VER_CODE AS [VERSION_ID]
								   ,@PROD_VER_SEQ AS [VERSION_SEQ]			--2019-03-29 PIYONG ADD
								   ,@PROD_VERSION_TYPE AS [PROD_VERSION_TYPE]
								   ,@ITEM_ID AS [SLURRY_ITEM_ID]
								   ,@CHILD_CLASS_NAME AS [CHILD_CLASS_NAME]
								   ,@CHILD_ITEM_ID AS [CHILD_ITEM_ID]
								   ,@CHILD_ITEM_NAME AS [CHILD_ITEM_NAME]
								   ,@SOLID_RATE AS [SOLID_RATE]
							  FROM SCM_FACTORY_M
							 WHERE FACTORY_ID = @FACTORY_ID
					     )B
					  ON (
							A.[DIVISION_ID] = B.[DIVISION_ID]
							AND A.[FACTORY_ID] = B.[FACTORY_ID]
							AND A.[MODEL_ID] = B.[MODEL_ID]
							AND A.[VERSION_ID] = B.[VERSION_ID]
							AND A.[VERSION_SEQ] = B.[VERSION_SEQ]			--2019-03-29 PIYONG ADD
							AND A.[SLURRY_ITEM_ID] = B.[SLURRY_ITEM_ID]
							AND A.[CHILD_CLASS_NAME] = B.[CHILD_CLASS_NAME]
							AND A.[CHILD_ITEM_ID] = B.[CHILD_ITEM_ID]
						 )
					WHEN MATCHED THEN
						UPDATE SET [SOLID_RATE]      = B.[SOLID_RATE]
								   ,[CHILD_ITEM_NAME] = B.[CHILD_ITEM_NAME]
   								   ,[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]
								   ,[UPDATE_ID]      = 'PR_XIF_PLM_WO_INSP_SPEC_R'
								   ,[UPDATE_TIME]    = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
							[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[MODEL_ID]
							,[VERSION_ID]
							,[VERSION_SEQ]		--2019-03-29 PIYONG ADD
							,[PROD_VERSION_TYPE]
							,[SLURRY_ITEM_ID]
							,[CHILD_CLASS_NAME]
							,[CHILD_ITEM_ID]
							,[CHILD_ITEM_NAME]
							,[SOLID_RATE]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
						) VALUES (
							B.[COMPANY_ID]
							,B.[DIVISION_ID]
							,B.[SITE_ID]
							,B.[PLANT_ID]
							,B.[FACTORY_ID]
							,B.[MODEL_ID]
							,B.[VERSION_ID]
							,B.[VERSION_SEQ]		--2019-03-29 PIYONG ADD
							,B.[PROD_VERSION_TYPE]
							,B.[SLURRY_ITEM_ID]
							,B.[CHILD_CLASS_NAME]
							,B.[CHILD_ITEM_ID]
							,B.[CHILD_ITEM_NAME]
							,B.[SOLID_RATE]
							,'PR_XIF_PLM_WO_INSP_SPEC_R'
							,GETDATE()
							,'PR_XIF_PLM_WO_INSP_SPEC_R'
							,GETDATE()
						)
					; 


					FETCH NEXT FROM CUR_SOLID_RATE INTO @MODEL_ID
														,@PROD_VER_CODE
														,@PROD_VER_SEQ		--2019-03-29 PIYONG ADD
														,@PROD_VERSION_TYPE
														,@ITEM_ID
														,@FACTORY_ID
														,@CHILD_CLASS_NAME
														,@CHILD_ITEM_ID
														,@CHILD_ITEM_NAME
														,@SOLID_RATE
				END

			CLOSE CUR_SOLID_RATE;
			DEALLOCATE CUR_SOLID_RATE;


			UPDATE [dbo].[SY_XIF_PLM_MIXER_MTRL_R]
			   SET PROC_FLAG = 'Y'
			 WHERE PROC_FLAG = 'P'


			UPDATE SCM_SLURRY_SOLID_RATE
			   SET MAX_VER_FLAG = 'N'

			UPDATE B
			   SET B.MAX_VER_FLAG = 'Y'
			  FROM [dbo].SCM_SLURRY_SOLID_RATE B
				   ,( SELECT A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.MODEL_ID
							 , A.SLURRY_ITEM_ID
							 , A.VERSION_ID
							 , A.VERSION_SEQ													--2019-03-29 PIYONG ADD
							 , A.PROD_VERSION_TYPE
						FROM (
							   SELECT A.COMPANY_ID
									  , A.DIVISION_ID
									  , A.SITE_ID
									  , A.PLANT_ID
									  , A.FACTORY_ID
									  , A.MODEL_ID
									  , A.SLURRY_ITEM_ID
									  , A.VERSION_ID
									  , ISNULL(VERSION_SEQ, '00') AS VERSION_SEQ				--2019-03-29 PIYONG ADD
									  , A.PROD_VERSION_TYPE
									  , ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
																	 , A.MODEL_ID, A.SLURRY_ITEM_ID
																	 , CASE RIGHT(VERSION_ID, 1) WHEN 'W' THEN 'W'
																							  WHEN 'P' THEN 'P'
																							  ELSE '-'
																							  END
																	 , CASE WHEN LEFT(VERSION_ID, 1) = 'Z' THEN 'T' ELSE 'M' END
															   ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID
																	 , A.SLURRY_ITEM_ID
																	 , A.VERSION_ID DESC
																	 , ISNULL(VERSION_SEQ, '00') DESC				--2019-03-29 PIYONG ADD
																																			  ) AS ROW_NUM
								 FROM (
										SELECT DISTINCT A.COMPANY_ID
											   , A.DIVISION_ID
											   , A.SITE_ID
											   , A.PLANT_ID
											   , A.FACTORY_ID
											   , A.MODEL_ID
											   , A.SLURRY_ITEM_ID
											   , A.VERSION_ID
											   , A.VERSION_SEQ
											   , A.PROD_VERSION_TYPE
											   , A.CHILD_CLASS_NAME 
										  FROM SCM_SLURRY_SOLID_RATE A WITH(NOLOCK)
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
			   AND A.SLURRY_ITEM_ID = B.SLURRY_ITEM_ID
			   AND A.VERSION_ID = B.VERSION_ID
			   AND A.VERSION_SEQ = B.VERSION_SEQ				--2019-03-29 PIYONG ADD
			-------------------------------------------------------------------------------------
			--2018-12-18 PIYONG ADD 고형분 비율 END
			-------------------------------------------------------------------------------------


			-------------------------------------------------------------------------------------
			--2019-03-14 PIYONG ADD 코팅 작업지시 적용일자
			-------------------------------------------------------------------------------------
			UPDATE B
			   SET PROC_FLAG = 'P'
			  FROM [dbo].[SY_XIF_PLM_WO_ORDER_R] B
			 WHERE APPLY_DATE IS NOT NULL
			   AND PRODID IS NOT NULL
			   AND TOTAL_BATCH IS NULL		--TOTAL_BATH 가 있는건 MIXER 작업지시
			   AND LANE_QTY IS NULL			--LANE_QTY 가 있는건  RTS 작업지시
			   AND PROD_VER_CODE IS NOT NULL
			   AND PROC_FLAG = 'N'
			;

			SET @v_err_check = 'CUR_WO_ORDER_APPLY_DATE'

			OPEN CUR_WO_ORDER_APPLY_DATE;
			FETCH NEXT FROM CUR_WO_ORDER_APPLY_DATE INTO @MODEL_ID
														,@ITEM_ID
														,@PROD_VER_CODE
														,@PROD_VER_SEQ
														,@FACTORY_ID
														,@ORDER_APPLY_DATE
														,@PROD_VERSION_TYPE
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					MERGE INTO [dbo].[FP_PROD_VERSION_APPLY_DATE_M] PV
					USING (
							SELECT COMPANY_ID
								   ,DIVISION_ID
								   ,SITE_ID
								   ,PLANT_ID
								   ,FACTORY_ID
								   ,@MODEL_ID AS MODEL_ID
								   ,@ITEM_ID AS ITEM_ID
								   ,@PROD_VER_CODE AS [PROD_VERSION]
								   ,CASE WHEN LEN( @PROD_VER_SEQ ) < 3 THEN REPLICATE('0', 2 - LEN( @PROD_VER_SEQ )) + @PROD_VER_SEQ ELSE @PROD_VER_SEQ END AS [PROD_SEQ]	-- 차수값 앞에 다른테이블과 동일하게 만들기 위해 0을 붙인다
								   ,@ORDER_APPLY_DATE AS APPLY_DATE
								   ,@PROD_VERSION_TYPE AS PROD_VERSION_TYPE
							  FROM SCM_FACTORY_M
						     WHERE FACTORY_ID = @FACTORY_ID
						  ) TEMP
					   ON (
							PV.[PLANT_ID] = TEMP.[PLANT_ID]
							AND PV.[FACTORY_ID] = TEMP.[FACTORY_ID]
							AND PV.[MODEL_ID] = TEMP.[MODEL_ID]
							AND PV.[ITEM_ID] = TEMP.[ITEM_ID]
							AND PV.[PROD_VERSION] = TEMP.[PROD_VERSION]
							AND PV.[PROD_SEQ] = TEMP.[PROD_SEQ]
						  )
					 WHEN MATCHED THEN
						UPDATE
						   SET PV.[APPLY_DATE]	=	TEMP.[APPLY_DATE]
							   ,PV.UPDATE_ID	=	'PR_XIF_PLM_WO_ORDER_R'
							   ,PV.UPDATE_TIME	=	GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
							[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[MODEL_ID]
							,[ITEM_ID]
							,[PROD_VERSION]
							,[PROD_SEQ]
							,[APPLY_DATE]
							,[APPLY_END_DATE]
							,[PROD_VERSION_TYPE]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
						) VALUES (
							TEMP.COMPANY_ID
							,TEMP.DIVISION_ID
							,TEMP.SITE_ID
							,TEMP.PLANT_ID
							,TEMP.FACTORY_ID
							,TEMP.MODEL_ID
							,TEMP.ITEM_ID
							,TEMP.PROD_VERSION
							,TEMP.PROD_SEQ
							,TEMP.APPLY_DATE
							,DATEADD(YEAR, 100, GETDATE())
							,TEMP.PROD_VERSION_TYPE
							,'PR_XIF_PLM_WO_ORDER_R'
							,GETDATE()
							,'PR_XIF_PLM_WO_ORDER_R'
							,GETDATE()
						)
					;


					-- APPLY_END_DATE 형성 
		  			UPDATE PVA
		  			   SET PVA.APPLY_END_DATE	=	DATEADD(SECOND, -1, @ORDER_APPLY_DATE)
							,UPDATE_TIME =  GETDATE()
					  FROM [FP_PROD_VERSION_APPLY_DATE_M] PVA
					       ,[SCM_FACTORY_M] F
				     WHERE F.FACTORY_ID			=	@FACTORY_ID
					   AND PVA.COMPANY_ID		=	F.COMPANY_ID
					   AND PVA.DIVISION_ID		=	F.DIVISION_ID
		  			   AND PVA.SITE_ID			=	F.SITE_ID
					   AND PVA.PLANT_ID			=	F.PLANT_ID
		  			   AND PVA.FACTORY_ID		=	F.FACTORY_ID
		  			   AND PVA.MODEL_ID			=	@MODEL_ID
					   AND PVA.ITEM_ID			=	@ITEM_ID
  					   AND PVA.APPLY_DATE		<	@ORDER_APPLY_DATE
					   AND PVA.APPLY_END_DATE	>=	@ORDER_APPLY_DATE


					FETCH NEXT FROM CUR_WO_ORDER_APPLY_DATE INTO @MODEL_ID
																 ,@ITEM_ID
																 ,@PROD_VER_CODE
																 ,@PROD_VER_SEQ
																 ,@FACTORY_ID
																 ,@ORDER_APPLY_DATE
																 ,@PROD_VERSION_TYPE

					;
				END;

			CLOSE CUR_WO_ORDER_APPLY_DATE;
			DEALLOCATE CUR_WO_ORDER_APPLY_DATE;

			UPDATE [dbo].[SY_XIF_PLM_WO_ORDER_R]
			   SET PROC_FLAG = 'Y'
				   ,PROC_DATE = GETDATE()
			 WHERE PROC_FLAG = 'P'
			-------------------------------------------------------------------------------------
			--2019-03-14 PIYONG ADD 작업지시 적용일자 끝
			-------------------------------------------------------------------------------------
	    -- 2022-04-14 김현 [C20220328-000596] Receive Jumbo Roll Length Start
			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'P'
			 WHERE PROC_ID = 'E2000'
			   AND VALUE1 IS NOT NULL
			   AND [PRODID] IS NOT NULL
			   AND SPEC_ITEM_ID IN ('I-A009-SPECE-010'
								   ,'I-A014-SPECAE-010'
								   ,'I-E009-SPECE-010'
								   ,'I-E014-SPECAE-010'
								   ,'I-M009-SPECE-013' --> 'I-M009-SPECE-008'    --nff
								   ,'I-M014-SPECA-030' --> 'I-M014-SPECA-008'    --nff
								   )   
			   AND PROC_FLAG = 'N';

			SET @v_err_check = 'CUR_JR_ROLL'

			OPEN CUR_JR_ROLL;
			FETCH NEXT FROM CUR_JR_ROLL INTO @FACTORY_ID
											 ,@ITEM_ID
											 ,@LENGTH
											 ,@WO_ID
											 ,@PROD_VERSION_TYPE		--2018-06-26 PIYONG ADD
											 ,@POST_TYPE -- 2022-05-23 E3000E4000 형성 여부
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @CNT = (	SELECT COUNT(*)
									  FROM DBO.[SCM_ITEM_LANE_M] A
										  ,(SELECT COMPANY_ID
												   ,DIVISION_ID
												   ,SITE_ID
												   ,PLANT_ID
												   ,FACTORY_ID
												   ,@ITEM_ID AS ITEM_ID
											 FROM SCM_FACTORY_M
											WHERE FACTORY_ID = @FACTORY_ID
										 )B
								   WHERE A.COMPANY_ID = B.COMPANY_ID
									 AND A.DIVISION_ID = B.DIVISION_ID
									 AND A.SITE_ID = B.SITE_ID
									 AND A.PLANT_ID = B.PLANT_ID
									 AND A.FACTORY_ID = B.FACTORY_ID
									 AND A.ITEM_ID = B.ITEM_ID
									 AND A.PROD_VERSION_TYPE =  @PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
								)
					;

					IF @CNT > 0
						BEGIN
							UPDATE A
							   SET  JUMBO_ROLL_LENGTH      = CASE WHEN SV.UP_FLAG = 'ALL' THEN @LENGTH ELSE JUMBO_ROLL_LENGTH END
							       ,GPLM_JUMBO_ROLL_LENGTH = @LENGTH
								   ,UPDATE_TIME =  GETDATE()
								   ,UPDATE_ID = CASE WHEN UPDATE_ID = 'PR_XIF_PLM_CONVERSION_RATE_R' THEN UPDATE_ID ELSE 'PR_XIF_PLM_WO_INSP_SPEC_R' END
								    -- 2021-05-14 kimcd SCM_ITEM_LANE_M UPDATE ID가 PR_XIF_PLM_CONVERSION_RATE_R 인 경우 변경자는 바꾸지 않음. Pancake Master UI에서 값 변경 제한
							  FROM DBO.[SCM_ITEM_LANE_M] A
								   ,(SELECT COMPANY_ID
										   ,DIVISION_ID
										   ,SITE_ID
										   ,PLANT_ID
										   ,FACTORY_ID
										   ,@ITEM_ID AS ITEM_ID
									  FROM SCM_FACTORY_M
									 WHERE FACTORY_ID = @FACTORY_ID
								  ) B
								  ,	( SELECT ATTRIBUTE6 AS UP_FLAG
									    FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
									   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
										 AND ACTIVE_FLAG = 'Y'
										 AND SEGMENT1 = @FACTORY_ID
										 AND SEGMENT2 = 'E2000'
									 ) AS SV  -- 2022-04-14 김현 [C20220328-000596] add for PLM Apply Option
						    WHERE A.COMPANY_ID = B.COMPANY_ID
							  AND A.DIVISION_ID = B.DIVISION_ID
							  AND A.SITE_ID = B.SITE_ID
							  AND A.PLANT_ID = B.PLANT_ID
							  AND A.FACTORY_ID = B.FACTORY_ID
							  AND A.ITEM_ID = B.ITEM_ID
							  AND A.PROD_VERSION_TYPE = @PROD_VERSION_TYPE;	--2018-06-26 PIYONG ADD

							IF @POST_TYPE IS NOT NULL AND @POST_TYPE != '' -- 2022-05-23 JUMBO ROLL 정권 길이 전극 후 고정에 유형에 추가
								BEGIN
									UPDATE A
									   SET  JUMBO_ROLL_LENGTH      = CASE WHEN SV.UP_FLAG = 'ALL' THEN @LENGTH ELSE JUMBO_ROLL_LENGTH END
										   ,GPLM_JUMBO_ROLL_LENGTH = @LENGTH
										   ,UPDATE_TIME =  GETDATE()
										   ,UPDATE_ID = CASE WHEN UPDATE_ID = 'PR_XIF_PLM_CONVERSION_RATE_R' THEN UPDATE_ID ELSE 'PR_XIF_PLM_WO_INSP_SPEC_R' END
											-- 2021-05-14 kimcd SCM_ITEM_LANE_M UPDATE ID가 PR_XIF_PLM_CONVERSION_RATE_R 인 경우 변경자는 바꾸지 않음. Pancake Master UI에서 값 변경 제한
									  FROM DBO.[SCM_ITEM_LANE_M] A
										   ,(SELECT COMPANY_ID
												   ,DIVISION_ID
												   ,SITE_ID
												   ,PLANT_ID
												   ,FACTORY_ID
												   ,@ITEM_ID AS ITEM_ID
											  FROM SCM_FACTORY_M
											 WHERE FACTORY_ID = @FACTORY_ID
										  ) B
										  ,	( SELECT ATTRIBUTE6 AS UP_FLAG
												FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
											   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
												 AND ACTIVE_FLAG = 'Y'
												 AND SEGMENT1 = @FACTORY_ID
												 AND SEGMENT2 = 'E2000'
											 ) AS SV
									WHERE A.COMPANY_ID = B.COMPANY_ID
									  AND A.DIVISION_ID = B.DIVISION_ID
									  AND A.SITE_ID = B.SITE_ID
									  AND A.PLANT_ID = B.PLANT_ID
									  AND A.FACTORY_ID = B.FACTORY_ID
									  AND A.ITEM_ID = B.ITEM_ID
									  AND A.PROD_VERSION_TYPE = @POST_TYPE;
								END;

							UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
							   SET PROC_FLAG = 'Y'
							       ,PROC_DATE = GETDATE()
							 WHERE WO_ID = @WO_ID
							   AND PRODID = @ITEM_ID
							   AND AREA_ID = @FACTORY_ID
							   AND SPEC_ITEM_ID IN ('I-A009-SPECE-010'
													,'I-A014-SPECAE-010'
													,'I-E009-SPECE-010'
													,'I-E014-SPECAE-010'
									                ,'I-M009-SPECE-013' --> 'I-M009-SPECE-008'   --nff
									                ,'I-M014-SPECA-030' --> 'I-M014-SPECA-008'   --nff
													)
							   AND PROC_FLAG = 'P';
						END;
					;


			 				   	
					FETCH NEXT FROM CUR_JR_ROLL INTO @FACTORY_ID
													 ,@ITEM_ID
													 ,@LENGTH
													 ,@WO_ID
													 ,@PROD_VERSION_TYPE	--2018-06-26 PIYONG ADD
													 ,@POST_TYPE -- 2022-05-23 E3000E4000 형성 여부
					;
				END;

			CLOSE CUR_JR_ROLL;
			DEALLOCATE CUR_JR_ROLL;

			UPDATE [dbo].[SY_XIF_PLM_WO_INSP_SPEC_R]
			   SET PROC_FLAG = 'N'
			   ,PROC_DATE = GETDATE()
			 WHERE PROC_ID = 'E2000'
			   AND VALUE1 IS NOT NULL
			   AND [PRODID] IS NOT NULL
			   AND SPEC_ITEM_ID IN ('I-A009-SPECE-010'
								   ,'I-A014-SPECAE-010'
								   ,'I-E009-SPECE-010'
								   ,'I-E014-SPECAE-010'
								   ,'I-M009-SPECE-013'   --> 'I-M009-SPECE-008',   --nff
								   ,'I-M014-SPECA-030'   --> 'I-M014-SPECA-008'    --nff
								   )
			   AND PROC_FLAG = 'P';
		-- 2022-04-14 김현 [C20220328-000596] Receive Jumbo Roll Length End
		
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
		SELECT ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
