

CREATE PROCEDURE [dbo].[PR_XIF_MES_WIP_R]

-- ================================================================================================
-- Program ID          : FP00900
-- Program Name        : PR_XIF_MES_WIP_R
-- Param               :
-- Batch Period        : 1Day
-- Description         : MES 재고 정보 전환
--
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_WIP_R
-- Destination Table   : SCM_STOCK_H
--
-- Create Date		   : 2017.04.11
-- Update Date		   : 2017.04.24 PIYONG 1.1
--					   : 2017.05.08 PIYONG 1.3
--					   : 2017.06.22 PIYONG 1.4
--					   : 2017.08.09 kimcd  1.6
--					   : 2017.08.31 PIYONG 1.7
--                     : 2017.09.01 kimcd  1.8
--					   : 2017.09.15 PIYONG 1.9
--					   : 2017.11.09 PIYONG 1.10
--                     : 2018.01.17 kimcd  1.11
--                     : 2018.03.29 kimcd  1.12
--                     : 2018.05.25 kimcd  1.13
--                     : 2018.05.28 kimcd  1.14
--					   : 2018.10.16 PIYONG 1.15
--						 2018.10.24 PIYONG 2.0
--						 2019.10.21 PIYONG 2.1
--						 2019.10.29 PIYONG 2.2
--						 2019.11.19 PIYONG 2.3
--						 2020.01.16 PIYONG 2.4
--						 2020.02.10 PIYONG 2.5
--                       2020.02.13 KIMCD  2.6
--						 2020.03.30 PIYONG 2.7
--                       2020.05.13 KIMCD  2.8
--                       2020.10.08 KIMCD  2.81
--                       2020.09.23 KIMCD  2.9
--                       2021.08.19 KIMCD  3.0
--                       2021.10.27 KIMCD  3.1
--                       2021.11.29 KIMCD  3.2
--                       2022.01.13 KIMCD  3.3
--                       2022.02.04 KIMCD  3.4
--                       2022.02.23 KIMCD  3.41
--                       2022.04.25 KIMCD  3.5
--                       2022.05.10 KIMCD  3.6
--                       2022.07.04 KIMCD  3.7
--                       2022.09.06 KIMCD  3.8
--                       2022.09.20 KIMCD  3.9
--                       2022.10.18 KIMCD  4.0
--                       2022.11.11 leeseonmgin 4.1
--                       2023.01.12 KIMCD  4.2
--                       2023.03.20 FP Pjt.4.3

-- Author              : PIYONG
-- Version             : 1.0
--                     : 1.1 SELECT QUERY CUTOFF-DATE CHANGE(  GETDATE() -> CONVERT(VARCHAR(10), @ACCUM_DATE, 120)  )
--                     : 1.2 kimcd 2017-05-04 modify qty condition
--                       1.3 SCM_STOCK_H qty2 컬럼 추가
--						 1.4 FP_APPLY_WIPQTY 값 구할떄  QTY에서  QTY2 변경 KIMCD 요청
--							 COATING_SIDE_TYPE_CODE 조건 추가
--                       1.5 E4(소형 3동) E2500 half slitting 공정 재고 강제 형성. kimcd 2017-06-28
--                       1.6 라인 추출하는 로직 보완. kimcd 2017-08-09
--						 1.7 FP_APPLY_OPERATION_ID  조건 변경
--                       1.8 kimcd 2017-09-01 이동 중 재고의 line, operation 조회 방식 수정
--						 1.9 [FP_APPLY_WIPQTY]  활성화 후 재작업으로 다시 들어온 Cell 재고 0처리 조건 추가 
--						 1.10 SCM_STOCK_H 테이블에 LOCATION 컬럼 
--                       1.11 2018-01-17 kimcd AC001(수리) 공정에서 이동하는 경우 재고 인식을 위해
--                                             WIP_TYPE_CODE를 IN으로 수정함
--                       1.12 2018-03-29 kimcd P5000 INOUT 상태의 경우 END인 경우 하위 Cell로 변환하면 안됨 관련 로직 추가
--                       1.13 2018-05-25 kimcd E7 전극 후 공정 생산 지원 EA 재고로 반영하는 로직 추가 구현
--                       1.14 2018-05-28 kimcd P5000 공정의 경우 Wait로 대기 상태 재고만 Cell로 전환.
--						 1.15 2018-11-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
--						 2.0  SCM_STOCK_H  생성 조회 쿼리 수정
--								SCM_BOM_M 서브쿼리에서 OUTER JOIN으로 변경( 대체코드 경우 ALT_PRIORITY=1 나오도록 변경, 누락데이터 보완)  
--						 2.1  UNHOLD_EXP_DATE ADD
--						 2.2  QMS_HOLD_YN ADD
--						 2.3  MES_SLOC_ID 추가
--						 2.4  WIPHOLD, QMS_HOLD_YN 생성 로직 변경, WIP_HOLD_YN, PRODUCTION_TYPE 추가
--						 2.5  속도 개선을 위한 쿼리 수정
--                       2.6  2020-02-13 kimcd B1000 공정 포장 홀드, 셀홀드 항목 추가(ATTRIBUTE7)
--						 2.7  MES HOLD 해제 일자, QMS HOLD 일자, QMS HOLD 해제 예정 일자, QMS HOLD 해제 일자 ADD
--                       2.8  2020-05-13  kimcd CMA, BMA 포장의 경우 품목 STATUS에 따라 현재 공정, 기본 공정 입력하도록 로직 수정
--                       2.81 2020-10-08  kimcd Site ID 추출 로직을 기존 IF ID 사용에서 동 사용으로 수정
--                       2.9  2020-09-23  kimcd 계획 공정에 P5200 공정이 추가됨에 따라 재고 공정 추출 로직 수정
--                                              ATTRIBUTE12	P5400(OCV2 차수)(1,2)
--                                              ATTRIBUTE13	P5400 완료 예정일자(YYYYMMDD) 컬럼 추가
--                       3.0 2021-08-19   kimcd XIF_MES_WIP_HOLD_SUM_R 수신 Table 변경.
--                                              P5200 공정 생산 품목은 P5200 공정 초과, 5000 공정에 존재하는 품목은 제품으로 인식
--                       3.1 2021-10-27   kimcd 2nd OCV L/T 추출 기준 정보 변경 - SCM_MMD_SECOND_OCV_SPEC_M -> SCM_MMD_SECOND_OCV_SPEC_V
--                       3.2 2021-11-29   kimcd P5200 공정 생산 품목을 제품으로 전환하는 로직 막음
--                                              QLTY_NO_INSP_FLAG 품질 미검사 여부 (Y/N)
--												ATTR_01	Lot 유형 - 포장 유형 : UI : 박스포장, EQ : 자동포장, MGZ : 매거진 포장
--												ATTR_02	Position Category(재고 위치)
--												ATTR_03	Detail Position Category(재고 위치 상세) 컬럼 추가
--												ATTR_04	전극 Lot 개수 - 합산
--                       3.3 2022-01-13   kimcd 하위 BOM 전개 로직에 MOVING 상태 누락 - 보완
--                       3.4 2022-02-04   kimcd P5200 공정 생산 품목은 P5200 공정 초과, 5000 공정에 존재하는 품목은 제품으로 인식
--                                              로직에서 상위 품목이 복수이면 최초 제품으로 할당하도록 함.
--                       3.41 2022-02-23  kimcd P5200 공정 생산 품목은 P5200 공정 초과, 5000 공정에 존재하는 품목은 제품으로 인식
--                                              로직에서 BOM 기본 품목만 선택하는 로직 제거
--                       3.5 2022-04-25   kimcd Coating 설비 기준으로 Coating Line 추가
--                       3.6 2022-05-10   kimcd 속도 개선 - Temp Table 도입 CXPACKET lock 회피용
--                       3.7 2022-07-04   kimcd Pack 이동 중 수량 구분 Flag 추가
--                                              전극 후 공정용 Hold Flag 구분 추가
--                       3.8 2022-09-06   kimcd P5310(CMA OCV INSP (CHG)), P5410(CMA 2ND OCV INSP (CHG)) L/T 감안 로직 추가
--                       3.9 2022-09-20   kimcd P5310(CMA OCV INSP (CHG)), P5410(CMA 2ND OCV INSP (CHG)) L/T 감안 로직 수정. 두 공정 모두 2nd OCV LT 반영
--                       4.0 2022-10-18   kimcd ILT lead tiem 무조건 6일로 변경
--                       4.1 2022-11-11   leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
--                       4.2 2023-01-12   kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 모델과 버전까지만 회신하기로 하여 수정
--                       4.3 2023-03-21   E20230313-000336 / [SCM/물류PI팀] SCM 재고정합성 점검/확보를 위한 재고 데이터 셋 추가 속성 개발 요청 건
--                                        ATTR_09 MES 변환전 품목, ATTR_10 MES 변환전 공정, SLOC_ID AS FROM_SLOC_ID
--                       4.4 2024-02-01   FP Pjt. AND    A.WIPSTAT  != 'BIZWF' AND    A.LOTTYPE NOT IN ('L', 'X') 추가
--                       4.5 2025-07-31   kimcd PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
--                                              MES에서 전송하는 2nd OCV 차수, 일자 사용
-- ================================================================================================

-- PARAMETER
@P_SITE_ID NVARCHAR(50) = 'NULL',
@P_IF_ID NVARCHAR(50) = 'NULL'


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_WIP_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @IF_ID        NVARCHAR(50)
	DECLARE @SUM_DATE     NVARCHAR(50) -- 2021-08-19   kimcd 일자 변수 추가
    DECLARE @SUM_DTTM     DATETIME     -- 2021-08-19   kimcd 변수명, 데이터 유형 변경
	DECLARE @SHOP_GROUP_ID NVARCHAR(2) -- 2021-08-19   kimcd 공정군 변수 추가
    DECLARE @SITE_ID      NVARCHAR(50)
	DECLARE @START_TIME   NVARCHAR(10)  -- 2020-09-23 kimcd 시업 시간 구분자 추가
	DECLARE @i_CNT        INTEGER


	DECLARE CUR_IF_MES_WIP CURSOR FOR
		SELECT IF_ID, SUM_DATE, MAX(SUM_DTTM) , ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z with(NOLOCK) WHERE Z.FACTORY_ID = MAX(R.AREAID) ) SITE_ID -- 2020-10-08 kimcd Site ID를 동 사용하여 조회
		      , ( SELECT TOP 1 SLV.SEGMENT2
			      FROM   SCM_FACTORY_M Z with(NOLOCK)
				        ,SCM_SYS_LOOKUP_VALUE SLV with(NOLOCK)
				  WHERE  SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
				  AND    SLV.SEGMENT1         = Z.PLANT_ID
				  AND    SLV.ACTIVE_FLAG      = 'Y'
				  AND    Z.FACTORY_ID         = MAX(R.AREAID)
				  ) START_TIME -- 2020-09-23 kimcd 시업 시간 구분자 추가
			  , ( SELECT DISTINCT Z.SHOP_GROUP_ID FROM SCM_FACTORY_M Z with(NOLOCK) WHERE Z.FACTORY_ID = MAX(R.AREAID) ) SHOP_GROUP_ID -- 2021-08-19   kimcd 공정군 추가
          FROM [SY_XIF_MES_WIP_HOLD_SUM_R] R with(nolock) -- 2021-08-19   kimcd XIF_MES_WIP_HOLD_SUM_R 수신 Table 변경.
         WHERE 1=1
           AND PROC_FLAG = 'N'
--		   AND ACCUM_DATE = CONVERT(CHAR(10),  GETDATE(), 112)
		   AND IF_ID  = ( CASE WHEN @P_IF_ID = 'NULL' OR @P_IF_ID IS NULL THEN IF_ID  ELSE @P_IF_ID END)
		   AND ( SUBSTRING(CONVERT(NVARCHAR(20),[dbo].[FN_SITE_TIME] ('A004'), 120), 12,5) < '07:00' OR SUBSTRING(CONVERT(NVARCHAR(20),[dbo].[FN_SITE_TIME] ('A004'), 120), 12,5) > '07:40' )
		   -- 2022-05-10 kimcd WA 법인의 시업 시간에 작업 회피
         GROUP BY IF_ID, SUM_DATE  -- 2022-09-06 kimcd group by 조건을 작업 시간(SUM_DTTM)에서 snapshot 일자(SUM_DATE)로 변경
        --HAVING COUNT(1) = MAX(SUM_COUNT) -- 전체를 수신받지 못한 경우에는 처리하지 않음.
		HAVING ( COUNT(1) = MAX(SUM_COUNT) 
				 OR ( COUNT(1) = 1 AND MAX(SUM_COUNT) = 0 )																			-- 2017-06-02 PIYONG 실적이 없는 날은 ACCUM_COUNT가 0 으로 수신
			   )  -- 전체를 수신받지 못한 경우에는 처리하지 않음.
         ORDER BY IF_ID, SUM_DATE
		 ;


	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		--BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
			OPEN CUR_IF_MES_WIP;
			FETCH NEXT FROM CUR_IF_MES_WIP INTO @IF_ID        
											    ,@SUM_DATE -- 2021-08-19   kimcd 변수 추가
												,@SUM_DTTM -- 2021-08-19   kimcd 변수명, 데이터 유형 변경
                                                ,@SITE_ID	
												,@START_TIME  -- 2020-09-23 kimcd 시업 시간 구분자 추가	
												,@SHOP_GROUP_ID -- 2021-08-19   kimcd 공정군 변수 추가

			WHILE (@@FETCH_STATUS = 0)
			BEGIN

				BEGIN TRAN

				IF ( @P_SITE_ID != 'NULL' AND @P_SITE_ID IS NOT NULL AND @SITE_ID = @P_SITE_ID ) OR (@P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL)		
				BEGIN
						
					IF OBJECT_ID('tempdb..#XIF_MES_WIP_HOLD_SUM_R') IS NOT NULL -- 2022-05-10 kimcd 임시 Table 삭제
						DROP TABLE #XIF_MES_WIP_HOLD_SUM_R

					UPDATE [dbo].[SY_XIF_MES_WIP_HOLD_SUM_R] -- 2021-08-19   kimcd XIF_MES_WIP_HOLD_SUM_R 수신 Table 변경.
					   SET PROC_FLAG	= 'P'
					 WHERE PROC_FLAG	= 'N'
					   AND IF_ID		= @IF_ID
					   AND SUM_DATE		= @SUM_DATE -- 2022-09-06 kimcd 기준을 SUM_DATE로 변경 2021-08-19   kimcd 변수명, 데이터 유형 변경
					;

					DELETE FROM [dbo].[SCM_STOCK_H]
						WHERE CUTOFF_DATE = CONVERT(DATETIME, @SUM_DATE, 112)
						AND STORAGE_ID = 'MES'
						AND SITE_ID    = @SITE_ID
						AND INSERT_ID = @IF_ID
						AND UPDATE_ID  = 'PR_XIF_MES_WIP_R'
					;

					SET @i_CNT =  (SELECT ISNULL(MAX(SEQ), 0)
										FROM [dbo].[SCM_STOCK_H] with(nolock)
									WHERE CUTOFF_DATE = CONVERT(DATETIME, @SUM_DATE, 112)
										AND SITE_ID = @SITE_ID );


					INSERT INTO SY_XIF_LOG_HISTORY (
							[PROC_NAME],
							[LOG_TYPE],
							[MESSAGE],
							[EVENT_DTTM]
						) VALUES (
							'PR_XIF_MES_WIP_R',
							'LOG',
							CONCAT(' @IF_ID > ', @IF_ID ,' @SITE_ID > ', @SITE_ID, ' @ACCUM_DATE > ',@SUM_DATE ),
							GETDATE()
						)
					;

					-- 2022-05-10 kimcd 임시 Table 정보 형성 시작
					SELECT A.PRODID
							, A.AREAID
							, SUM(A.WIPQTY)  AS WIPQTY
							, SUM(A.WIPQTY2) AS WIPQTY2
							, A.LANE_QTY
            				, wipstat
							, A.TO_PROCID
							, A.PROCID
							, A.TO_EQSGID
							, A.EQSGID
							, A.EQPTID
            				, A.IF_ID
							, A.WIP_TYPE_CODE
							, A.PROD_HOLD_FLAG
							, A.QLTY_HOLD_FLAG
							, A.PROC_HOLD_FLAG
							, A.FCS_RWK_FALG
							, A.EQPT_FLOOR_NO
							, A.TO_SLOC_ID
							, A.SLOC_ID
							, A.PROC_UNHOLD_SCHD_DATE
							, A.PROD_UNHOLD_SCHD_DATE
							, A.QLTY_UNHOLD_SCHD_DATE
							, A.FINL_2ND_OCV_INSP_SEQS
                            , A.FINL_2ND_OCV_INSP_END_DTTM
							, A.LONG_TERM_STCK_FLAG
							, A.[QLTY_NO_INSP_FLAG]            -- 품질 미검사 여부 (Y/N)
							, A.ATTR_01
							, A.ATTR_02
							, A.ATTR_03
							, SUM(CONVERT(NUMERIC(18),A.[ATTR_04])) AS ATTR_04
							, A.LOTTYPE
							, CASE WHEN A.DB_TYPE = 'ELTR' THEN A.COATING_EQPTID END AS COATING_EQPTID
							, CASE WHEN A.DB_TYPE = 'ELTR' THEN A.COATING_AREAID END AS COATING_AREAID
							, CASE WHEN A.DB_TYPE = 'ELTR' THEN A.COATING_EQSGID END AS COATING_EQSGID
							, DB_TYPE
							, A.COATING_SIDE_TYPE_CODE
							, A.SUM_DATE
							, A.PROC_FLAG
							, A.ATTR_05 AS WORK_REQUEST_MODEL_ID	-- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							, A.ATTR_06 AS [VERSION]	            -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							, A.ATTR_07 AS PROD_SEQ	            -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							, A.ATTR_08 AS PLM_EC_NO	            -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							, A.ATTR_09 AS MES_ITEM_ID             -- 2023-03-21 MES에서 변경전 품목
							, A.ATTR_10 AS MES_OPERATION_ID        -- 2023-03-21 MES에서 변경전 공정
					INTO   #XIF_MES_WIP_HOLD_SUM_R
					FROM   [dbo].[SY_XIF_MES_WIP_HOLD_SUM_R] A WITH(NOLOCK)
					WHERE  A.PROC_FLAG = 'P'
					AND    ( A.COATING_SIDE_TYPE_CODE != 'T' OR A.COATING_SIDE_TYPE_CODE IS NULL )
					--AND    NOT (A.WIPSTAT = 'BIZWF' AND A.PROCID LIKE 'P%' ) -- 2022-09-20 kimcd 재공 승인 진행 중 수량 제거
					AND    A.IF_ID     = @IF_ID
					AND    A.SUM_DATE  = @SUM_DATE  -- 2022-09-06 kimcd 기준을 SUM_DATE로 변경 
					AND    A.WIPSTAT  != 'BIZWF' 
					AND    A.LOTTYPE NOT IN ('L', 'X')
					GROUP BY A.PRODID
							,A.AREAID
							,A.WIPSTAT
							,A.TO_PROCID
							,A.PROCID
							,A.TO_EQSGID
							,A.EQSGID
							,A.EQPTID
            				,A.IF_ID
							,A.WIP_TYPE_CODE
							,A.PROD_HOLD_FLAG
							,A.QLTY_HOLD_FLAG
							,A.PROC_HOLD_FLAG
							,A.LANE_QTY
							,A.FCS_RWK_FALG
							,A.EQPT_FLOOR_NO
							,A.TO_SLOC_ID
							,A.SLOC_ID
							,A.LOTTYPE
							,A.PROC_UNHOLD_SCHD_DATE
							,A.PROD_UNHOLD_SCHD_DATE
							,A.QLTY_UNHOLD_SCHD_DATE
							,A.FINL_2ND_OCV_INSP_SEQS
							,A.FINL_2ND_OCV_INSP_END_DTTM
							,LONG_TERM_STCK_FLAG
							,A.[QLTY_NO_INSP_FLAG]  -- 품질 미검사 여부 (Y/N)
							,A.[ATTR_01]            -- Lot 유형 - 포장 유형 : UI : 박스포장, EQ : 자동포장, MGZ : 매거진 포장
							,A.[ATTR_02]	        -- Position Category(재고 위치)
							,A.[ATTR_03]		    -- Detail Position Category(재고 위치 상세) 컬럼 추가
							,A.LOTTYPE
							,CASE WHEN A.DB_TYPE = 'ELTR' THEN A.COATING_EQPTID END
							,CASE WHEN A.DB_TYPE = 'ELTR' THEN A.COATING_AREAID END
							,CASE WHEN A.DB_TYPE = 'ELTR' THEN A.COATING_EQSGID END
							,DB_TYPE
							,A.COATING_SIDE_TYPE_CODE 
							,A.SUM_DATE -- 2022-09-06 kimcd 기준을 SUM_DATE로 변경 
							,A.PROC_FLAG
					-- 2022-05-10 kimcd 임시 Table 정보 형성 종료
							,A.[ATTR_05]            -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,A.[ATTR_06]	        -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,A.[ATTR_07]		    -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,A.[ATTR_08]		    -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,A.[ATTR_09]            -- 2023-03-21 
							,A.[ATTR_10]            -- 2023-03-21 
							;

					INSERT INTO [dbo].[SCM_STOCK_H]
							([COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[STORAGE_ID]
							,[CUTOFF_DATE]
							,[SEQ]
							,[STOCK_TYPE]
							,[ITEM_ID]
							,[PRODUCTION_TYPE]
							,[AVAILABLE_DATE]
							,[REMAIN_LEAD_TIME]
							,[UNHOLD_EXP_DATE]			-- PIYONG ADD 2019-10-21
							,[QTY]
							,[QTY_UOM]
							,[QTY2]
							,[STOCK_STATUS]
							,[OPERATION_ID]
							,[LANE]
							,[LINE_ID]
							,[OUTSOURCING_FLAG]
							,[OUTSOURCING_FACTORY]
							,[DESCRIPTION]
							,[FP_APPLY_OPERATION_ID]
							,[FP_APPLY_ITEM_ID]
							,[FP_APPLY_WIPQTY]
							,[WIPHOLD_YN]
							,[WIP_TYPE_CODE]  -- kimcd add 2017-05-04
							,[FORMATION_REWORK_TYPE]	--PIYONG ADD 2017-09-15
							,[LOCATION] 			    --PIYONG ADD 2017-11-09
							,[QMS_HOLD_YN]				--PIYONG ADD 2019-10-29
							,[MES_MAP_SLOC]				--PIYONG ADD 2019-11-19
							,[MES_HOLD_YN]				--2020-01-16 PIYONG ADD
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
							,[MES_UNHOLD_DATE]		-- 2020-03-30 PIYONG ADD MES HOLD 해제 일자
							,[QMS_UNHOLD_EXP_DATE]	-- 2020-03-30 PIYONG ADD QMS HOLD 해제 예정 일자
							,[SECOND_OCV_TIME]      -- 2020-09-23  kimcd 	P5400(OCV2 차수)(1,2)
                            ,[SECOND_OCV_EXP_DATE]  -- 2020-09-23  kimcd    P5400 완료 예정일자(YYYYMMDD) 컬럼 추가
							,[LONG_TERM_FLAG]       -- 2021-08-19  kimcd 장기 재고 flag 추가
							-- 2021-11-29 kimcd 컬럼 추가 시작
							,[QLTY_NO_INSP_FLAG]    -- 품질 미검사 여부 (Y/N)
							,[LOT_PACKING_TYPE]	    -- ATTR_01	Lot 유형 - 포장 유형 : UI : 박스포장, EQ : 자동포장, MGZ : 매거진 포장
							,[POSITION_CATEGORY]	-- ATTR_02	Position Category(재고 위치)
							,[DETAIL_POSITION]		-- ATTR_03	Detail Position Category(재고 위치 상세) 컬럼 추가
							,[LOT_COUNT]			-- ATTR_04	전극 Lot 개수 - 합산
							-- 2021-11-29 kimcd 컬럼 추가 끝
							,[COATING_LINE_ID] -- 2022-04-25 kimcd Coating Line 추가
							,[PACK_MOVE_FLAG]    -- 2022-07-04 kimcd Pack 이동 중 수량 구분용 - In-house request/moving 반영용
							,[ELEC_POST_HOLD_YN] -- 2022-07-04 kimcd 전극 후 공정 E4100 rewiding을 hold로 반영
							,[WORK_REQUEST_MODEL_ID]	-- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,[VERSION]	                -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,[PROD_SEQ]	                -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,[PLM_EC_NO]	            -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,MES_ITEM_ID
							,MES_OPERATION_ID
							,FROM_SLOC_ID
					) 
					SELECT A.[COMPANY_ID]
							,A.[DIVISION_ID]
							,A.[SITE_ID]
							,A.[PLANT_ID]
							,A.[FACTORY_ID]
							,A.[STORAGE_ID]
							,A.[CUTOFF_DATE]
							,ROW_NUMBER() OVER ( PARTITION BY @IF_ID ORDER BY A.[ITEM_ID] DESC ) + @i_CNT  AS [SEQ]		-- 2018-10-24 PIYONG DEL
							,A.[STOCK_TYPE]
							,A.[ITEM_ID]
							,A.[PRODUCTION_TYPE]
							,A.[AVAILABLE_DATE]
							,A.[REMAIN_LEAD_TIME]
							,A.[UNHOLD_EXP_DATE]																		-- PIYONG ADD 2019-10-21
							,A.[QTY]
							,A.[QTY_UOM]
							,A.[QTY2]
							,A.[STOCK_STATUS]
							,A.[OPERATION_ID]
							,A.LANE
							,A.[LINE_ID]
							,A.[OUTSOURCING_FLAG]
							,A.[OUTSOURCING_FACTORY]
							,A.[DESCRIPTION]
							,A.FP_APPLY_OPERATION_ID
							,CASE WHEN A.[FLOW_ID] = 'P5200' AND A.[OPERATION_ID] = 'P5000' THEN  -- 2020-09-23 kimcd 2nd OCV 적용 품목은 P5000 공정에서 Cell로 변경되면 안 되어 예외 처리
								A.[ITEM_ID]
								ELSE
								CASE SEGMENT5  WHEN 'PRE' THEN
													CHILD_ITEM_ID
													/*	--2018-10-24 PIYOND DEL
													( SELECT TOP 1 CHILD_ITEM_ID
														FROM [dbo].[SCM_BOM_M_V] BOM
														WHERE BOM.COMPANY_ID = A.COMPANY_ID
														AND BOM.DIVISION_ID = A.DIVISION_ID
														AND BOM.SITE_ID = A.SITE_ID
														AND BOM.PLANT_ID = A.PLANT_ID
														AND BOM.PARENT_ITEM_ID = A.[ITEM_ID]
														AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID) 
														AND BOM.EFF_START_DATE <= GETDATE()
														AND BOM.EFF_END_DATE > GETDATE()
														)
													*/
												-- 2018-03-29 kimcd STOCK STATUS에 따라 반제품 코드 결정함 시작
												WHEN 'STATUS' THEN
													CASE WHEN A.STOCK_STATUS = 'END' OR  A.STOCK_STATUS = 'EQPT_END'  OR  A.STOCK_STATUS = 'MOVING' THEN -- 2021-08-19 kimcd MOVING 추가
														A.[ITEM_ID]
													ELSE
														CHILD_ITEM_ID
														/*	--2018-10-24 PIYOND DEL
														( SELECT TOP 1 CHILD_ITEM_ID
															FROM [dbo].[SCM_BOM_M_V] BOM
															WHERE BOM.COMPANY_ID = A.COMPANY_ID
															AND BOM.DIVISION_ID = A.DIVISION_ID
															AND BOM.SITE_ID = A.SITE_ID
															AND BOM.PLANT_ID = A.PLANT_ID
															AND BOM.PARENT_ITEM_ID = A.[ITEM_ID]
															AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID) 
															AND BOM.EFF_START_DATE <= GETDATE()
															AND BOM.EFF_END_DATE > GETDATE()
															)
														*/
													END
												-- 2018-03-29 kimcd STOCK STATUS에 따라 반제품 코드 결정함 끝
												-- 2018-05-28 kimcd P5000 공정은 WAIT 상태만 대기 재고로 보고.. 이후 단계는 완성 재고로 함
												WHEN 'WAIT' THEN
													CASE WHEN A.STOCK_STATUS = 'WAIT' THEN
														CHILD_ITEM_ID
														/*	--2018-10-24 PIYOND DEL
														( SELECT TOP 1 CHILD_ITEM_ID
															FROM [dbo].[SCM_BOM_M_V] BOM
															WHERE BOM.COMPANY_ID = A.COMPANY_ID
															AND BOM.DIVISION_ID = A.DIVISION_ID
															AND BOM.SITE_ID = A.SITE_ID
															AND BOM.PLANT_ID = A.PLANT_ID
															AND BOM.PARENT_ITEM_ID = A.[ITEM_ID]
															AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID) 
															AND BOM.EFF_START_DATE <= GETDATE()
															AND BOM.EFF_END_DATE > GETDATE()
															)
														*/
													ELSE
														A.[ITEM_ID]
													END
												-- 2018-05-28 kimcd P5000 공정은 WAIT 상태만 대기 재고로 보고.. 이후 단계는 완성 재고로 함
												ELSE                  
													A.[ITEM_ID]
												END
								END  AS FP_APPLY_ITEM_ID
							,CASE WHEN A.[FLOW_ID] = 'P5200' AND A.[OPERATION_ID] = 'P5000' THEN  -- 2020-09-23 kimcd 2nd OCV 적용 품목은 P5000 공정에서 Cell 수량으로 변경되면 안 되어 예외 처리
								A.QTY2
								ELSE
									CASE SEGMENT5  WHEN 'PRE' THEN
													CASE  WHEN FORMATION_REWORK_TYPE = 'Y' AND A.OPERATION_ID = 'A4000' THEN	    -- PIYONG ADD 2017-09-15
																0
															WHEN ( A.STOCK_STATUS = 'PROC' AND A.WIP_TYPE_CODE = 'OUT')
																	OR A.WIP_TYPE_CODE = 'PROD' THEN							    -- kimcd change 2017-05-04
																0
															ELSE
																A.QTY2 *  BOM_QTY
																/*	-- 2018-10-24 PIYONG DELL
																A.QTY2 *( SELECT TOP 1 CHILD_QTY / PARENT_QTY						--2017-06-22 KIMCD 요청으로  QTY에서 QTY2로 변경
																	FROM [dbo].[SCM_BOM_M_V] BOM
																	WHERE BOM.COMPANY_ID = A.COMPANY_ID
																	AND BOM.DIVISION_ID = A.DIVISION_ID
																	AND BOM.SITE_ID = A.SITE_ID
																	AND BOM.PLANT_ID = A.PLANT_ID
																	AND BOM.PARENT_ITEM_ID = A.[ITEM_ID]
																	AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID ) 
																	AND BOM.EFF_START_DATE <= GETDATE()
																	AND BOM.EFF_END_DATE > GETDATE()
																)
																*/
															END
													-- 2018-03-29 kimcd 재고 상태에 따라 하위 품목 수량으로 전환 여부 결정 시작
													WHEN 'STATUS' THEN
													  	CASE  WHEN FORMATION_REWORK_TYPE = 'Y' AND A.OPERATION_ID = 'A4000' THEN	    -- PIYONG ADD 2017-09-15
																0
															WHEN ( A.STOCK_STATUS = 'PROC' AND A.WIP_TYPE_CODE = 'OUT')
																	OR A.WIP_TYPE_CODE = 'PROD' THEN							    -- kimcd change 2017-05-04
																0
															WHEN A.STOCK_STATUS = 'END' OR  A.STOCK_STATUS = 'EQPT_END' OR  A.STOCK_STATUS = 'MOVING' THEN -- 2021-08-19 kimcd MOVING 추가
																A.QTY2
															ELSE
																A.QTY2 *  BOM_QTY
																/*	-- 2018-10-24 PIYONG DELL
																A.QTY2 *( SELECT TOP 1 CHILD_QTY / PARENT_QTY						--2017-06-22 KIMCD 요청으로  QTY에서 QTY2로 변경
																	FROM [dbo].[SCM_BOM_M_V] BOM
																	WHERE BOM.COMPANY_ID = A.COMPANY_ID
																	AND BOM.DIVISION_ID = A.DIVISION_ID
																	AND BOM.SITE_ID = A.SITE_ID
																	AND BOM.PLANT_ID = A.PLANT_ID
																	AND BOM.PARENT_ITEM_ID = A.[ITEM_ID]
																	AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID ) 
																	AND BOM.EFF_START_DATE <= GETDATE()
																	AND BOM.EFF_END_DATE > GETDATE()
																)
																*/
															END
													-- 2018-03-29 kimcd 재고 상태에 따라 하위 품목 수량으로 전환 여부 결정 끝
													-- 2018-05-28 kimcd P5000 공정은 WAIT 상태만 대기 재고로 보고.. 이후 단계는 완성 재고로 함
													WHEN 'WAIT' THEN
													  	CASE  WHEN FORMATION_REWORK_TYPE = 'Y' AND A.OPERATION_ID = 'A4000' THEN	    -- PIYONG ADD 2017-09-15
																0
															WHEN ( A.STOCK_STATUS = 'PROC' AND A.WIP_TYPE_CODE = 'OUT')
																	OR A.WIP_TYPE_CODE = 'PROD' THEN							    -- kimcd change 2017-05-04
																0
															WHEN A.STOCK_STATUS = 'WAIT' THEN
																A.QTY2 *  BOM_QTY
																/*	-- 2018-10-24 PIYONG DELL
																A.QTY2 *( SELECT TOP 1 CHILD_QTY / PARENT_QTY						--2017-06-22 KIMCD 요청으로  QTY에서 QTY2로 변경
																	FROM [dbo].[SCM_BOM_M_V] BOM
																	WHERE BOM.COMPANY_ID = A.COMPANY_ID
																	AND BOM.DIVISION_ID = A.DIVISION_ID
																	AND BOM.SITE_ID = A.SITE_ID
																	AND BOM.PLANT_ID = A.PLANT_ID
																	AND BOM.PARENT_ITEM_ID = A.[ITEM_ID]
																	AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID ) 
																	AND BOM.EFF_START_DATE <= GETDATE()
																	AND BOM.EFF_END_DATE > GETDATE()
																)
																*/
															ELSE
																A.QTY2
															END
													-- 2018-05-28 kimcd P5000 공정은 WAIT 상태만 대기 재고로 보고.. 이후 단계는 완성 재고로 함
													ELSE
														CASE  WHEN FORMATION_REWORK_TYPE = 'Y' AND A.OPERATION_ID = 'A4000' THEN	-- PIYONG ADD 2017-09-15
																	0
																WHEN ( A.STOCK_STATUS = 'PROC' AND A.WIP_TYPE_CODE = 'OUT')
																		OR A.WIP_TYPE_CODE = 'PROD' THEN							-- kimcd change 2017-05-04
																	0
																ELSE                  
																	A.QTY2
																END
													END
								END AS [FP_APPLY_WIPQTY]
							,A.WIPHOLD
							,A.WIP_TYPE_CODE -- kimcd add 2017-05-04
							,A.FORMATION_REWORK_TYPE --PIYONG ADD 2017-09-15
							--------------------------------------------------------------------------------------------
							--PIYONG ADD 2017-11-09  ADD 시작
							,LOCATION
							,QMS_HOLD_YN			--2019-10-29 PIYONG ADD
							,MES_MAP_SLOC			--2019-11-19 PIYONG ADD
							,MES_HOLD_YN			--2020-01-16 PIYONG ADD
							,@IF_ID AS INSERT_ID
							,GETDATE() AS INSERT_TIME
       						,'PR_XIF_MES_WIP_R' AS UPDATE_ID
         					,GETDATE() AS UPDATE_TIME
							,MES_UNHOLD_DATE		-- 2020-03-30 PIYONG ADD MES HOLD 해제 일자
							,QMS_UNHOLD_EXP_DATE	-- 2020-03-30 PIYONG ADD QMS HOLD 해제 예정 일자
							,SECOND_OCV_TIME        -- 2020-09-23  kimcd 	P5400(OCV2 차수)(1,2)
                            ,SECOND_OCV_EXP_DATE    -- 2020-09-23  kimcd    P5400 완료 예정일자(YYYYMMDD) 컬럼 추가
							,LONG_TERM_FLAG         -- 2021-08-19  kimcd 장기 재고 flag 추가
							-- 2021-11-29 kimcd 컬럼 추가 시작
							,A.[QLTY_NO_INSP_FLAG]    -- 품질 미검사 여부 (Y/N)
							,A.[LOT_PACKING_TYPE]	    -- ATTR_01	Lot 유형 - 포장 유형 : UI : 박스포장, EQ : 자동포장, MGZ : 매거진 포장
							,A.[POSITION_CATEGORY]	-- ATTR_02	Position Category(재고 위치)
							,A.[DETAIL_POSITION]		-- ATTR_03	Detail Position Category(재고 위치 상세) 컬럼 추가
							,A.[LOT_COUNT]			-- ATTR_04	전극 Lot 개수 - 합산
							-- 2021-11-29 kimcd 컬럼 추가 끝
							,A.[COATING_LINE_ID] -- 2022-04-25 kimcd Coating Line 추가
							,A.[PACK_MOVE_FLAG]  -- 2022-07-04 kimcd Pack 이동 중 수량 구분용 - In-house request/moving 반영용
							,CASE WHEN A.WIPHOLD = 'Y' OR A.ELEC_POST_HOLD_YN = 'Y' THEN 'Y' ELSE 'N' END AS ELEC_POST_HOLD_YN -- 2022-07-04 kimcd 전극 후 공정 E4100 rewiding을 hold로 반영
							,WORK_REQUEST_MODEL_ID	-- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,SUBSTRING(A.VER_SEQ, 1, CHARINDEX('^', A.VER_SEQ)-1)-- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,CASE WHEN SUBSTRING(A.VER_SEQ, CHARINDEX('^', A.VER_SEQ)+1, LEN(A.VER_SEQ)) = '' THEN NULL ELSE SUBSTRING(A.VER_SEQ, CHARINDEX('^', A.VER_SEQ)+1, LEN(A.VER_SEQ)) END
								-- 2023-01-12   kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 모델과 버전까지만 회신하기로 하여 수정
							,PLM_EC_NO	            -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,MES_ITEM_ID
							,MES_OPERATION_ID
							,FROM_SLOC_ID
						FROM (
								SELECT A.[COMPANY_ID]
									,A.[DIVISION_ID]
									,A.[SITE_ID]
									,A.[PLANT_ID]
									,A.[FACTORY_ID]
									,A.[STORAGE_ID]
									,A.[CUTOFF_DATE]
									,A.[STOCK_TYPE]
									,A.[ITEM_ID]
									,A.[PRODUCTION_TYPE]
									,A.[AVAILABLE_DATE]
									,A.[REMAIN_LEAD_TIME]
									,CASE WHEN A.MES_UNHOLD_DATE > A.QMS_UNHOLD_EXP_DATE THEN
											A.MES_UNHOLD_DATE
										ELSE ISNULL(A.QMS_UNHOLD_EXP_DATE,A.MES_UNHOLD_DATE) END	AS	UNHOLD_EXP_DATE
									,A.[QTY]
									,(SELECT ITEM_UOM
										FROM [DBO].SCM_ITEM_M D with(nolock)
												INNER JOIN [DBO].[SCM_ITEM_CLASS_M] M with(nolock)
												ON D.ITEM_CLASS = M.CLASS_ID
												AND M.USE_FLAG = 'Y'
										WHERE A.[ITEM_ID] = D.ITEM_ID
											AND A.DIVISION_ID = d.DIVISION_ID
											AND A.SITE_ID  = D.site_id
											AND A.COMPANY_ID = D.COMPANY_ID) AS [QTY_UOM]
									,A.[QTY2]
									,A.[STOCK_STATUS]
									,A.[OPERATION_ID]
									,CASE WHEN SUBSTRING(A.[ITEM_ID],1,3) = 'APC' THEN A.LANE ELSE NULL END AS LANE
									,A.[LINE_ID]
									,A.[OUTSOURCING_FLAG]
									,A.[OUTSOURCING_FACTORY]
									,A.[DESCRIPTION]
									, CASE SEGMENT4  WHEN 'PRE' THEN
														-- kimcd 2017-06-28 add start  E4 소형 3동 half slitting 예외 처리
														CASE WHEN A.[FACTORY_ID] = 'E4' AND A.OPERATION_ID = 'E3000' THEN
															'E2500'
														ELSE
														-- kimcd 2017-06-28 add end
															ISNULL( ( SELECT TOP 1 F.OPERATION_ID				 
																		FROM DBO.SCM_OPERATION_M  O WITH(NOLOCK)
																				,DBO.SCM_ITEM_M   I WITH(NOLOCK)
																				,SCM_OPERATION_FLOW_M F WITH(NOLOCK)
																		WHERE  I.COMPANY_ID   = A.COMPANY_ID
																		AND    I.DIVISION_ID  = A.DIVISION_ID
																		AND    I.SITE_ID      = A.SITE_ID
																		AND    I.ITEM_ID      = A.ITEM_ID
																		AND    F.COMPANY_ID   = I.COMPANY_ID
																		AND    F.DIVISION_ID  = I.DIVISION_ID
																		AND    F.SITE_ID      = I.SITE_ID
																		AND    F.FLOW_ID      = I.FLOW_ID
																		AND    F.OPERATION_ID < A.OPERATION_ID 
																		AND    O.COMPANY_ID   = F.COMPANY_ID
																		AND    O.DIVISION_ID  = F.DIVISION_ID
																		AND    O.SITE_ID      = F.SITE_ID
																		AND    O.OPERATION_ID = F.OPERATION_ID
																		ORDER  BY F.OPERATION_SEQ DESC) , A.OPERATION_ID)
														END -- kimcd 2017-06-28 add
													WHEN 'STATUS' THEN 
															CASE  WHEN A.STOCK_STATUS = 'END' OR  A.STOCK_STATUS = 'EQPT_END' THEN
																	A.OPERATION_ID
															ELSE
																-- kimcd 2017-06-28 add start E4 소형 3동 half slitting 예외 처리
																CASE WHEN A.[FACTORY_ID] = 'E4' AND A.OPERATION_ID = 'E3000' THEN
																	'E2500'
																ELSE
																-- kimcd 2017-06-28 add end
																	ISNULL( ( SELECT TOP 1 F.OPERATION_ID				 
																		FROM DBO.SCM_OPERATION_M  O WITH(NOLOCK)
																				,DBO.SCM_ITEM_M   I WITH(NOLOCK)
																				,SCM_OPERATION_FLOW_M F WITH(NOLOCK)
																		WHERE  I.COMPANY_ID   = A.COMPANY_ID
																		AND    I.DIVISION_ID  = A.DIVISION_ID
																		AND    I.SITE_ID      = A.SITE_ID
																		AND    I.ITEM_ID      = A.ITEM_ID
																		AND    F.COMPANY_ID   = I.COMPANY_ID
																		AND    F.DIVISION_ID  = I.DIVISION_ID
																		AND    F.SITE_ID      = I.SITE_ID
																		AND    F.FLOW_ID      = I.FLOW_ID
																		AND    F.OPERATION_ID < A.OPERATION_ID 
																		AND    O.COMPANY_ID   = F.COMPANY_ID
																		AND    O.DIVISION_ID  = F.DIVISION_ID
																		AND    O.SITE_ID      = F.SITE_ID
																		AND    O.OPERATION_ID = F.OPERATION_ID
																		ORDER  BY F.OPERATION_SEQ DESC) , A.OPERATION_ID)
																END -- -- kimcd 2017-06-28 add
															END
													-- 2020-09-23 KIMCD P5200 공정이 P5000 공정을 대신하는 품목 발생하면서 로직 수정 추가 시작
													WHEN 'PACK_FLOW' THEN 
															CASE  WHEN SIM.FLOW_ID LIKE 'P%' THEN
																	SIM.FLOW_ID
															ELSE
																ISNULL( ( SELECT TOP 1 I.FLOW_ID
																	FROM DBO.SCM_BOM_M_V  O WITH(NOLOCK)
																		,DBO.SCM_ITEM_M I WITH(NOLOCK)
																	WHERE  I.COMPANY_ID   = O.COMPANY_ID
																	AND    I.DIVISION_ID  = O.DIVISION_ID
																	AND    I.SITE_ID      = O.SITE_ID
																	AND    I.ITEM_ID      = O.PARENT_ITEM_ID
																	--AND    O.COMPANY_ID   = A.COMPANY_ID
																	--AND    O.DIVISION_ID  = A.DIVISION_ID
																	--AND    O.SITE_ID      = A.SITE_ID
																	--AND    O.PLANT_ID     = A.PLANT_ID
																	AND    O.CHILD_ITEM_ID = A.ITEM_ID
																	AND    O.EFF_START_DATE <= GETDATE()
																	AND    O.EFF_END_DATE > GETDATE()
																	AND    I.FLOW_ID IN  ('P5000','P5200')
																	ORDER  BY 
																			CASE WHEN O.PLANT_ID     = A.PLANT_ID THEN 1 ELSE 2 END
																		,CASE WHEN O.COMPANY_ID   = A.COMPANY_ID THEN 1 ELSE 2 END
																		,CASE WHEN O.DIVISION_ID  = A.DIVISION_ID THEN 1 ELSE 2 END
																		,CASE WHEN O.SITE_ID      = A.SITE_ID THEN 1 ELSE 2 END
																		,I.FLOW_ID DESC) , 'P5000')
															END
													-- 2020-09-23 KIMCD P5200 공정이 P5000 공정을 대신하는 품목 발생하면서 로직 수정 추가 종료
													ELSE
														CASE WHEN SEGMENT5 = 'STATUS' AND ( A.STOCK_STATUS = 'END' OR  A.STOCK_STATUS = 'EQPT_END' OR  A.STOCK_STATUS = 'MOVING' ) THEN -- 2021-08-19 kimcd MOVING 추가
															A.OPERATION_ID
														ELSE
															ISNULL( SEGMENT4, A.OPERATION_ID)	--	2017-08-31 PIYONG 1.7 CHANGE
														END -- 2020-05-13 kimcd 하위 품목 찾는 것이 Status인 경우 완성 단계는 자기 공정 유지되도록 함
													END AS FP_APPLY_OPERATION_ID
									,SEGMENT5			--2018-10-24 PIYONG ADD
									,A.WIPHOLD
									,A.WIP_TYPE_CODE -- kimcd add 2017-05-04
									,A.FORMATION_REWORK_TYPE --PIYONG ADD 2017-09-15
									--------------------------------------------------------------------------------------------
									--PIYONG ADD 2017-11-09  ADD 시작
									,CASE WHEN ISNULL((SELECT SEGMENT2
															FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK) 
														WHERE W.LOOKUP_TYPE_CODE = 'WIP_LOCATION'
															AND ACTIVE_FLAG = 'Y'
															AND SEGMENT1 = A.PLANT_ID), 'N' ) = 'Y' THEN  A.EQPT_FLOOR_NO
											ELSE
												NULL
											END AS LOCATION
									--PIYONG ADD 2017-11-09  ADD 끝
									---------------------------------------------------------------------------------------------
									,QMS_HOLD_YN			--2019-10-29 PIYONG ADD
									,MES_MAP_SLOC			--2019-11-19 PIYONG ADD
									,MES_HOLD_YN			--2020-01-16 PIYONG ADD
									,MES_UNHOLD_DATE		-- 2020-03-30 PIYONG ADD MES HOLD 해제 일자
									,QMS_UNHOLD_EXP_DATE	-- 2020-03-30 PIYONG ADD QMS HOLD 해제 예정 일자
									,CASE WHEN SIM.FLOW_ID = 'P5200' THEN
											CASE WHEN ISNUMERIC([SECOND_OCV_TIME]) = 1 THEN
												CONVERT(NUMERIC,[SECOND_OCV_TIME])
											END
										END  AS SECOND_OCV_TIME -- 2025-07-31 kimcd MES에서 전송하는 2nd OCV 차수, 일자 사용
                                    ,CASE WHEN SIM.FLOW_ID = 'P5200' THEN
											SECOND_OCV_EXP_DATE
										END  AS  SECOND_OCV_EXP_DATE  -- 2025-07-31 kimcd MES에서 전송하는 2nd OCV 차수, 일자 사용
									--,CASE WHEN SIM.FLOW_ID = 'P5200' AND A.[OPERATION_ID] IN ( 'P5310', 'P5410') AND ISNUMERIC([SECOND_OCV_TIME]) = 1 THEN
									--		CONVERT(NUMERIC,[SECOND_OCV_TIME]) + 1
									--	END  AS SECOND_OCV_TIME --2022-09-20 kimcd P5410 추가. 2022-09-06 kimcd 대상 공정 P5400에서 P5310으로 수정 -- 2020-09-23  kimcd 	P5400(OCV2 차수)(1,2)
                                    --,CASE WHEN SIM.FLOW_ID = 'P5200' AND A.[OPERATION_ID] IN ('P5310','P5410') THEN
									--		ISNULL( 
											--     (SELECT TOP 1 DATEADD( D, CASE WHEN SOC.RUN_TIME = 1 THEN
											--                                   SOC.KEEP_DAYS
														--				   ELSE
														--				       365
														--				   END
														--				   , SECOND_OCV_EXP_DATE)
													--FROM  SCM_MMD_SECOND_OCV_SPEC_V SOC WITH(NOLOCK) -- 2021-10-27 kimcd SCM_MMD_SECOND_OCV_SPEC_V 로 변경 조건 변경
													--WHERE SOC.FACTORY_ID   = A.FACTORY_ID
													--AND   SOC.ITEM_ID      = A.ITEM_ID
													--ORDER BY CASE WHEN SOC.RUN_TIME = 1 THEN 1 ELSE 2 END
													--        ,KEEP_DAYS
													--)
									--				DATEADD(D, 6, SECOND_OCV_EXP_DATE)  -- 2022-10-18 kimcd 무조건 6일로 변경
									--			, CONVERT(DATE, @SUM_DATE, 112))  --2022-09-20 kimcd P5410 추가.--2022-09-06 kimcd 대상 공정 P5400에서 P5310으로 수정
										--WHEN SIM.FLOW_ID = 'P5200' AND A.[OPERATION_ID] = 'P5200' AND  A.STOCK_STATUS IN ('END', 'EQPT_END')  THEN
										--    ISNULL( (SELECT TOP 1 DATEADD( D, SOC.KEEP_DAYS , CONVERT(DATE, @SUM_DATE, 112))
										--			  FROM   SCM_MMD_SECOND_OCV_SPEC_V SOC WITH(NOLOCK) -- 2021-10-27 kimcd SCM_MMD_SECOND_OCV_SPEC_V 로 변경 조건 변경
										--			  WHERE  SOC.FACTORY_ID   = A.FACTORY_ID
										--			  AND    SOC.ITEM_ID      = A.ITEM_ID
										--			  AND    SOC.RUN_TIME     = 1
										--			  ORDER BY SOC.KEEP_DAYS), CONVERT(DATE, @SUM_DATE, 112))
										-- --2022-09-06 kimcd 제거
										-- 2022-09-20 kimcd P5410 조건 제거 WHEN SIM.FLOW_ID = 'P5200' AND A.[OPERATION_ID] = 'P5410' THEN --2022-09-06 kimcd 대상 공정 P5410추가
										--	ISNULL( DATEADD( D, -1, SECOND_OCV_EXP_DATE), CONVERT(DATE, @SUM_DATE, 112))
									--	WHEN SIM.FLOW_ID = 'P5200' AND A.[OPERATION_ID] = 'P5000' THEN
									--		CONVERT(DATE, @SUM_DATE, 112)
									--	END  AS  SECOND_OCV_EXP_DATE    -- 2020-09-23  kimcd    P5400 완료 예정일자(YYYYMMDD) 컬럼 추가
									,SIM.FLOW_ID            -- 2020-09-23  kimcd    생산공정 P5000, P5200 생산 품목 구분용
									,LONG_TERM_FLAG         -- 2021-08-19  kimcd 장기 재고 flag 추가
									-- 2021-11-29 kimcd 컬럼 추가 시작
									,A.[QLTY_NO_INSP_FLAG]    -- 품질 미검사 여부 (Y/N)
									,A.[LOT_PACKING_TYPE]	    -- ATTR_01	Lot 유형 - 포장 유형 : UI : 박스포장, EQ : 자동포장, MGZ : 매거진 포장
									,A.[POSITION_CATEGORY]	-- ATTR_02	Position Category(재고 위치)
									,A.[DETAIL_POSITION]		-- ATTR_03	Detail Position Category(재고 위치 상세) 컬럼 추가
									,A.[LOT_COUNT]			-- ATTR_04	전극 Lot 개수 - 합산
									-- 2021-11-29 kimcd 컬럼 추가 끝
									,A.[COATING_LINE_ID] -- 2022-04-25 kimcd Coating Line 추가
									,A.[PACK_MOVE_FLAG]  -- 2022-07-04 kimcd Pack 이동 중 수량 구분용 - In-house request/moving 반영용
									,W.[ATTRIBUTE1]      AS ELEC_POST_HOLD_YN -- 2022-07-04 kimcd 전극 후 공정 E4100 rewiding을 hold로 반영
                                    ,A.WORK_REQUEST_MODEL_ID	-- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
									, ISNULL ( (SELECT TOP 1 CM.[VERSION] + '^' + CM.PROD_SEQ
												FROM   [dbo].[SCM_ITEM_CONV_CALC_USE_M]  CU with(NOLOCK)
													INNER JOIN [dbo].[SCM_ITEM_CONV_CALC_M] CM with(NOLOCK)
														ON  CM.COMPANY_ID = CU.COMPANY_ID
														AND CM.FACTORY_ID = CU.FACTORY_ID
														AND CM.ITEM_ID    = CU.ITEM_ID
														AND CM.OPERATION  = CU.OPERATION_ID
														AND CM.MODEL_ID   = CU.MODEL_ID
														AND CM.[VERSION]  = CU.[VERSION]
												WHERE CU.FACTORY_ID     = A.COATING_AREAID
												AND   CU.MODEL_ID       = A.WORK_REQUEST_MODEL_ID
												AND   CU.ITEM_ID        = A.[ITEM_ID]
												AND   CU.[LINE_ID]      = A.COATING_LINE_ID
												AND   CU.[OPERATION_ID] = 'E2000'
												AND   CU.[VERSION]   LIKE A.[VERSION] + '%'
												AND   CU.[ACTIVE_FLAG]  = 'Y'
												ORDER BY CM.APPLY_DATE DESC), A.[VERSION] + '^' + ISNULL(A.PROD_SEQ, '') ) AS VER_SEQ -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
														                                                                                -- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 모델과 버전까지만 회신하기로 하여 수정
									,A.PLM_EC_NO	            -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
									,A.MES_ITEM_ID
									,A.MES_OPERATION_ID
									,FROM_SLOC_ID
								FROM (
										SELECT /*	--2018-11-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
											CASE WHEN @SITE_ID = 'A002' THEN
														CASE WHEN MAX(A.NJ_ELEC_FACTORY) IN ( 'G452','A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' THEN
																	'G450'
																ELSE ISNULL( B.COMPANY_ID, C.COMPANY_ID) END 
														ELSE
														ISNULL( B.COMPANY_ID, C.COMPANY_ID)
													END AS COMPANY_ID
											,CASE WHEN @SITE_ID = 'A002' THEN
														CASE WHEN MAX(A.NJ_ELEC_FACTORY) IN ( 'G452', 'A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' THEN 
																	'81'
																ELSE ISNULL( B.DIVISION_ID, C.DIVISION_ID)  END 
														ELSE
														ISNULL( B.DIVISION_ID, C.DIVISION_ID) 
													END AS DIVISION_ID
											,ISNULL( B.SITE_ID, C.SITE_ID )  AS SITE_ID
											,CASE WHEN @SITE_ID = 'A002' THEN
														CASE WHEN MAX(A.NJ_ELEC_FACTORY) IN ( 'G452', 'A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' THEN 
																'G452'
															ELSE
																ISNULL( B.PLANT_ID, C.PLANT_ID )
																END
														ELSE
														ISNULL( B.PLANT_ID, C.PLANT_ID )
													END AS PLANT_ID
											,CASE WHEN @SITE_ID = 'A002' THEN
														CASE WHEN MAX(A.NJ_ELEC_FACTORY) IN ( 'G452', 'A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' THEN 
																	-- 2018-05-25 kimcd E8, EA 구분 수정 시작
																	CASE WHEN CASE WHEN A.WIPSTAT = 'MOVING' THEN A.TO_PROCID ELSE A.PROCID END >= 'E2000' AND (MAX(A.WOID) >= 'C185' OR MAX(A.WOID) IS NULL) THEN
																		'EA'
																	ELSE 'E8' END
																	-- 2018-05-25 kimcd E8, EA 구분 수정 종료
																ELSE ISNULL( B.FACTORY_ID, C.FACTORY_ID ) END 
														ELSE
														ISNULL( B.FACTORY_ID, C.FACTORY_ID ) 
													END AS FACTORY_ID
											*/
											ISNULL( B.COMPANY_ID, C.COMPANY_ID) AS COMPANY_ID
											,ISNULL( B.DIVISION_ID, C.DIVISION_ID) AS DIVISION_ID
											,ISNULL( B.SITE_ID, C.SITE_ID )  AS SITE_ID
											,ISNULL( B.PLANT_ID, C.PLANT_ID )AS PLANT_ID
											,ISNULL( B.FACTORY_ID, C.FACTORY_ID ) AS FACTORY_ID
											,'MES' AS STORAGE_ID
											,CONVERT(DATETIME, @SUM_DATE, 112) AS CUTOFF_DATE
--											,ROW_NUMBER() OVER ( PARTITION BY A.IF_ID ORDER BY   A.PRODID  DESC )  AS [SEQ]	-- 2018-10-24 PIYONG DEL
            								,'WIP' AS STOCK_TYPE 
											,A.PRODID AS ITEM_ID
											,(
												SELECT ATTRIBUTE1
													FROM SCM_SYS_LOOKUP_VALUE with(nolock)
													WHERE LOOKUP_TYPE_CODE = 'MES_LOT_TYPE'
													AND ACTIVE_FLAG= 'Y'
													AND SEGMENT1 = A.LOTTYPE ) AS PRODUCTION_TYPE							--2020-01-16 PIYONG CHANGE NULL -> LOOKUP
											,CASE WHEN A.PROD_HOLD_FLAG = 'Y' OR A.QLTY_HOLD_FLAG = 'Y' OR A.PROC_HOLD_FLAG = 'Y' THEN  -- 2020-02-13 kimcd B1000 공정 포장 홀드, 셀홀드 항목 추가 OR ATTRIBUTE7 = 'Y'
												convert( varchar, dateadd( dd, 60, getdate() ) ,120 )
												ELSE '1999-01-01 00:00:00' END AS AVAILABLE_DATE
            								,0 AS REMAIN_LEAD_TIME
            								,SUM(A.WIPQTY) QTY
											,SUM(A.WIPQTY2) AS QTY2
											,A.LANE_QTY AS LANE
            								,wipstat AS STOCK_STATUS
											--, A.PROCID AS OPERATION_ID kimcd block 2017-09-01
											,CASE WHEN A.WIPSTAT = 'MOVING' THEN ISNULL(A.TO_PROCID,A.PROCID) ELSE A.PROCID END AS OPERATION_ID -- kimcd add 2017-09-01
											--,ISNULL(ISNULL(B.LINE_ID,A.EQSGID),'-') AS LINE_ID  -- MES 라인 직접 사용 kimcd 2017-08-09 kimcd block 2017-09-01
											,CASE WHEN A.WIPSTAT = 'MOVING' THEN ISNULL(A.TO_EQSGID,'-') ELSE ISNULL(ISNULL(B.LINE_ID,A.EQSGID),'-') END AS LINE_ID -- kimcd add 2017-09-01
            								,'-' AS OUTSOURCING_FLAG
											,NULL AS OUTSOURCING_FACTORY
            								,NULL AS DESCRIPTION
            								,A.IF_ID AS INSERT_ID
											,CASE WHEN A.WIPSTAT = 'MOVING' AND A.PROCID = 'AC001' THEN 'IN' ELSE A.WIP_TYPE_CODE END AS WIP_TYPE_CODE  -- 2018-01-17 kimcd AC001(수리)공정에서 나오는 이동 중 재고는 IN으로 강제 전환
											,CASE WHEN A.PROD_HOLD_FLAG = 'Y' OR A.QLTY_HOLD_FLAG = 'Y' OR A.PROC_HOLD_FLAG = 'Y' THEN 'Y' ELSE  'N' END AS WIPHOLD				-- 2020-02-13 kimcd B1000 공정 포장 홀드, 셀홀드 항목 추가(ATTRIBUTE7). 2019-10-29 PIYONG CHANGE
											,A.FCS_RWK_FALG   AS FORMATION_REWORK_TYPE														--2017-09-15 PIYONG ADD
											,A.EQPT_FLOOR_NO
											,A.QLTY_HOLD_FLAG AS QMS_HOLD_YN	    --2019-10-29 PIYONG ADD
											,CASE WHEN A.WIPSTAT = 'MOVING' THEN ISNULL(A.TO_SLOC_ID,A.SLOC_ID) ELSE A.SLOC_ID END              AS MES_MAP_SLOC																--2019-11-19 PIYONG ADD
											,CASE WHEN A.PROC_HOLD_FLAG = 'Y' OR A.PROD_HOLD_FLAG = 'Y' THEN 'Y' ELSE 'N' END AS MES_HOLD_YN       --2020-02-13 kimcd B1000 공정 포장 홀드, 셀홀드 항목 추가. 2020-01-16 PIYONG ADD
											,CASE WHEN CASE WHEN PROC_HOLD_FLAG = 'Y' THEN A.PROC_UNHOLD_SCHD_DATE END > CASE WHEN PROD_HOLD_FLAG = 'Y' THEN A.PROD_UNHOLD_SCHD_DATE END THEN
													A.PROC_UNHOLD_SCHD_DATE
												ELSE ISNULL(CASE WHEN PROD_HOLD_FLAG = 'Y' THEN A.PROD_UNHOLD_SCHD_DATE END , CASE WHEN PROC_HOLD_FLAG = 'Y' THEN A.PROC_UNHOLD_SCHD_DATE END ) END	AS	MES_UNHOLD_DATE			-- 2020-03-30 PIYONG MES HOLD 해제 일자
											,CASE WHEN QLTY_HOLD_FLAG = 'Y' THEN A.QLTY_UNHOLD_SCHD_DATE END AS QMS_UNHOLD_EXP_DATE		-- 2020-03-30 PIYONG QMS HOLD 해제 예정 일자
											,A.FINL_2ND_OCV_INSP_SEQS                           AS SECOND_OCV_TIME          -- 2020-09-23  kimcd 	P5400(OCV2 차수)(1,2)
                                            ,CASE WHEN A.FINL_2ND_OCV_INSP_END_DTTM IS NOT NULL THEN 
														CONVERT(DATE, A.FINL_2ND_OCV_INSP_END_DTTM, 112)
												END 	AS SECOND_OCV_EXP_DATE      -- 2020-09-23  kimcd    P5400 완료 예정일자(YYYYMMDD) 컬럼 추가
											,A.LONG_TERM_STCK_FLAG AS LONG_TERM_FLAG       -- 2021-08-19  kimcd 장기 재고 flag 추가
											-- 2021-11-29 kimcd 컬럼 추가 시작
											,A.[QLTY_NO_INSP_FLAG]            -- 품질 미검사 여부 (Y/N)
											,A.ATTR_01 AS LOT_PACKING_TYPE	  -- ATTR_01	Lot 유형 - 포장 유형 : UI : 박스포장, EQ : 자동포장, MGZ : 매거진 포장
											,A.ATTR_02 AS POSITION_CATEGORY	  -- ATTR_02	Position Category(재고 위치)
											,A.ATTR_03 AS DETAIL_POSITION	  -- ATTR_03	Detail Position Category(재고 위치 상세) 컬럼 추가
											,SUM(A.[ATTR_04])  AS LOT_COUNT	 -- ATTR_04	전극 Lot 개수 - 합산
											-- 2021-11-29 kimcd 컬럼 추가 끝
											,CL.[LINE_ID]  AS COATING_LINE_ID -- 2022-04-25 kimcd Coating Line 추가
											,CASE WHEN A.PROCID = 'B1000' AND (A.TO_SLOC_ID LIKE '2%' OR A.TO_SLOC_ID LIKE '3%') THEN 'Y' ELSE 'N' END AS [PACK_MOVE_FLAG]  -- 2022-07-04 kimcd Pack 이동 중 수량 구분용 - In-house request/moving 반영용
											,A.COATING_AREAID           -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,A.WORK_REQUEST_MODEL_ID	-- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,A.[VERSION]	            -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,A.PROD_SEQ	                -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,A.PLM_EC_NO	            -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											, A.MES_ITEM_ID
											, A.MES_OPERATION_ID
											, CASE WHEN A.WIPSTAT = 'MOVING' THEN A.SLOC_ID END  AS FROM_SLOC_ID               
										FROM #XIF_MES_WIP_HOLD_SUM_R A  -- 2022-05-10 kimcd 임시 Table로 변경함. CXPACKET lock 회피용 [dbo].[SY_XIF_MES_WIP_HOLD_SUM_R] A WITH(NOLOCK)   -- 2021-08-19   kimcd XIF_MES_WIP_HOLD_SUM_R 수신 Table 변경.
										LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M] B WITH(NOLOCK)
												-- ON A.EQPTID = B.EQUIPMENT_ID kimcd block 2017-09-01
												ON CASE WHEN A.WIPSTAT = 'MOVING' THEN '' ELSE A.EQPTID END = B.EQUIPMENT_ID -- kimcd ADD 2017-09-01
												AND SUBSTRING(B.MES_LINE_ID,1,2)  =  B.FACTORY_ID -- 남경에 전극 설비가 PLANNING을 위해서 여러 BUILDING에 속해져 있음.
												AND A.EQSGID = B.MES_LINE_ID -- MES 라인 조건 추가 kimcd 2017-08-09
												AND A.PROCID = B.OPERATION_ID					 -- 하나의 설비가 여러 공정에 속할 수 있다고 함.
											INNER JOIN ( SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
														FROM [DBO].SCM_EQUIPMENT_M A WITH(NOLOCK) ) C
													ON (CASE WHEN A.WIPSTAT = 'MOVING' THEN
																CASE WHEN A.TO_EQSGID ='' OR A.TO_EQSGID IS NULL THEN	-- 2020-03-30 PIYONG A.TO_EQSGID IS NULL ADD
																		A.AREAID						-- 2020-02-10 PIYONG CHANGE END  A.EQSGID -> A.AREAID
																		ELSE
																		SUBSTRING( A.TO_EQSGID ,1,2)
																		END
																ELSE A.AREAID								-- 2020-02-10 PIYONG CHANGE END  A.EQSGID -> A.AREAID
																END ) =  C.FACTORY_ID
										LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M] CL WITH(NOLOCK) -- 2022-04-25 kimcd Coating Line 추가
												ON  A.COATING_EQPTID = CL.EQUIPMENT_ID -- 설비
												AND A.COATING_AREAID = CL.FACTORY_ID   -- 동
												AND A.COATING_EQSGID = CL.MES_LINE_ID  -- MES 라인
												-- 2022-11-11 leeseonmgin 전극 제한 조건 변경 AND A.DB_TYPE        = 'ELTR'          -- 전극만 조회
												AND A.COATING_AREAID LIKE 'E%'  -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리 전극 제한 조건 변경
										WHERE A.PROC_FLAG = 'P'
										AND ( A.COATING_SIDE_TYPE_CODE != 'T' OR A.COATING_SIDE_TYPE_CODE IS NULL )			--2017-06-20  PIYONG 추가
										AND A.IF_ID = @IF_ID
										AND ISNULL( B.SITE_ID, C.SITE_ID ) = @SITE_ID
										AND A.SUM_DATE = @SUM_DATE -- 2022-09-06 kimcd 기준을 SUM_DATE로 변경 
										GROUP BY ISNULL( B.COMPANY_ID, C.COMPANY_ID)
											,ISNULL( B.DIVISION_ID, C.DIVISION_ID)
											,ISNULL( B.SITE_ID, C.SITE_ID )
											,ISNULL( B.PLANT_ID, C.PLANT_ID )
											,ISNULL( B.FACTORY_ID, C.FACTORY_ID )
											,A.PRODID
            								--,A.PROCID kimcd block 2017-09-01
											,CASE WHEN A.WIPSTAT = 'MOVING' THEN ISNULL(A.TO_PROCID,A.PROCID) ELSE A.PROCID END -- kimcd add 2017-09-01
											--,ISNULL(ISNULL(B.LINE_ID,A.EQSGID),'-') -- MES 라인 직접 사용 kimcd 2017-08-09  -- kimcd block 2017-09-01
											,CASE WHEN A.WIPSTAT = 'MOVING' THEN ISNULL(A.TO_EQSGID,'-') ELSE ISNULL(ISNULL(B.LINE_ID,A.EQSGID),'-') END -- kimcd add 2017-09-01
            								,A.IF_ID
											,wipstat
											,CASE WHEN A.WIPSTAT = 'MOVING' AND A.PROCID = 'AC001' THEN 'IN' ELSE A.WIP_TYPE_CODE END -- 2018-01-17 kimcd AC001(수리)공정에서 나오는 이동 중 재고는 IN으로 강제 전환
											,CASE WHEN A.PROD_HOLD_FLAG = 'Y' OR A.QLTY_HOLD_FLAG = 'Y' OR A.PROC_HOLD_FLAG = 'Y' THEN 'Y' ELSE  'N' END
											,A.LANE_QTY
											,A.FCS_RWK_FALG
											,A.EQPT_FLOOR_NO													--PIYONG ADD 2017-11-09
											,CASE WHEN A.WIPSTAT = 'MOVING' THEN ISNULL(A.TO_SLOC_ID,A.SLOC_ID) ELSE A.SLOC_ID END --PIYONG ADD 2019-11-19
											,A.QLTY_HOLD_FLAG												--PIYONG ADD 2020-01-16
											,A.LOTTYPE													--PIYONG ADD 2020-01-16
											,CASE WHEN A.PROC_HOLD_FLAG = 'Y' OR A.PROD_HOLD_FLAG = 'Y' THEN 'Y' ELSE 'N' END --2020-02-13 kimcd B1000 공정 포장 홀드, 셀홀드 항목 추가
											,CASE WHEN CASE WHEN PROC_HOLD_FLAG = 'Y' THEN A.PROC_UNHOLD_SCHD_DATE END > CASE WHEN PROD_HOLD_FLAG = 'Y' THEN A.PROD_UNHOLD_SCHD_DATE END THEN
													A.PROC_UNHOLD_SCHD_DATE
												ELSE ISNULL(CASE WHEN PROD_HOLD_FLAG = 'Y' THEN A.PROD_UNHOLD_SCHD_DATE END , CASE WHEN PROC_HOLD_FLAG = 'Y' THEN A.PROC_UNHOLD_SCHD_DATE END ) END -- 2020-03-30 PIYONG MES HOLD 해제 일자
											,CASE WHEN QLTY_HOLD_FLAG = 'Y' THEN A.QLTY_UNHOLD_SCHD_DATE END -- 2020-03-30 PIYONG QMS HOLD 해제 예정 일자
											,A.FINL_2ND_OCV_INSP_SEQS                                       -- 2020-09-23  kimcd 	P5400(OCV2 차수)(1,2)
                                            ,CASE WHEN A.FINL_2ND_OCV_INSP_END_DTTM IS NOT NULL THEN 
														CONVERT(DATE, A.FINL_2ND_OCV_INSP_END_DTTM, 112)
												END	                                                -- 2020-09-23  kimcd    P5400 완료 예정일자(YYYYMMDD) 컬럼 추가
											,LONG_TERM_STCK_FLAG -- 2021-08-19  kimcd 장기 재고 flag 추가
											,CASE WHEN A.PROD_HOLD_FLAG = 'Y' OR A.QLTY_HOLD_FLAG = 'Y' OR A.PROC_HOLD_FLAG = 'Y' THEN  -- 2020-02-13 kimcd B1000 공정 포장 홀드, 셀홀드 항목 추가 OR ATTRIBUTE7 = 'Y'
												convert( varchar, dateadd( dd, 60, getdate() ) ,120 )
											ELSE '1999-01-01 00:00:00'	END
											-- 2021-11-29 kimcd 컬럼 추가 시작
											,A.[QLTY_NO_INSP_FLAG]  -- 품질 미검사 여부 (Y/N)
											,A.[ATTR_01]            -- Lot 유형 - 포장 유형 : UI : 박스포장, EQ : 자동포장, MGZ : 매[;거진 포장
											,A.[ATTR_02]	        -- Position Category(재고 위치)
											,A.[ATTR_03]		    -- Detail Position Category(재고 위치 상세) 컬럼 추가
											-- 2021-11-29 kimcd 컬럼 추가 끝
											,CL.[LINE_ID]           -- 2022-04-25 kimcd Coating Line 추가
											,CASE WHEN A.PROCID = 'B1000' AND (A.TO_SLOC_ID LIKE '2%' OR A.TO_SLOC_ID LIKE '3%') THEN 'Y' ELSE 'N' END -- 2022-07-04 kimcd Pack 이동 중 수량 구분용 - In-house request/moving 반영용
											,A.COATING_AREAID           -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,A.WORK_REQUEST_MODEL_ID	-- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,A.[VERSION]	            -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,A.PROD_SEQ	            -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											,A.PLM_EC_NO	            -- 2022-11-11 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											, A.MES_ITEM_ID
											, A.MES_OPERATION_ID
											, CASE WHEN A.WIPSTAT = 'MOVING' THEN A.SLOC_ID END 
											
									) A
									LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
													ON W.LOOKUP_TYPE_CODE = 'WIP_OPERATION_STOCK_MAP'
												AND W.SEGMENT1 = A.OPERATION_ID
												AND W.SEGMENT3 = A.WIP_TYPE_CODE
												AND W.ACTIVE_FLAG = 'Y'
									--------------------------------------------------------------------------------------------------------------------------------------
									--2020-09-23 KIMCD P5200 공정이 P5000 공정을 대신하는 품목 발생하면서 로직 수정 추가 시작
									LEFT OUTER JOIN SCM_ITEM_M SIM with(NOLOCK)
													ON SIM.COMPANY_ID  = A.COMPANY_ID
												AND SIM.DIVISION_ID = A.DIVISION_ID
												AND SIM.SITE_ID = A.SITE_ID
												AND SIM.ITEM_ID = A.ITEM_ID
									--2020-09-23 KIMCD P5200 공정이 P5000 공정을 대신하는 품목 발생하면서 로직 수정 추가 끝
									--------------------------------------------------------------------------------------------------------------------------------------
							) A
							--------------------------------------------------------------------------------------------------------------------------------------
							--2018-10-24 PIYONG ADD
							LEFT OUTER JOIN (
												SELECT CHILD_QTY / PARENT_QTY	AS BOM_QTY
														,COMPANY_ID
														,BOM.DIVISION_ID
														,BOM.SITE_ID
														,BOM.PLANT_ID
														,BOM.PARENT_ITEM_ID
														,CHILD_ITEM_ID
														,ALT_PRIORITY
													FROM [dbo].[SCM_BOM_M_V] BOM with(nolock)
													WHERE 1=1
													AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M with(nolock) WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID ) 
													AND BOM.EFF_START_DATE <= GETDATE()
													AND BOM.EFF_END_DATE > GETDATE()
											) BOM
											ON BOM.COMPANY_ID = A.COMPANY_ID
										AND BOM.DIVISION_ID = A.DIVISION_ID
										AND BOM.SITE_ID = A.SITE_ID
										AND BOM.PLANT_ID = A.PLANT_ID
										AND (BOM.ALT_PRIORITY = 1 OR BOM.ALT_PRIORITY IS NULL)
										AND BOM.PARENT_ITEM_ID = (  CASE WHEN A.[FLOW_ID] = 'P5200' AND A.[OPERATION_ID] = 'P5000' THEN  -- 2020-09-23 kimcd 2nd OCV 적용 품목은 P5000 공정에서 Cell 수량으로 변경되면 안 되어 예외 처리
																		'-'
																	ELSE
																		CASE SEGMENT5 WHEN 'PRE' THEN
																							A.ITEM_ID
																						WHEN 'STATUS' THEN
																							CASE WHEN A.STOCK_STATUS = 'END' OR  A.STOCK_STATUS = 'EQPT_END'  OR  A.STOCK_STATUS = 'MOVING'  THEN  -- 2022-01-13 kimcd 하위 BOM 전개 로직에 MOVING 상태 누락 - 보완
																								'-'
																							ELSE
																								A.ITEM_ID
																							END
																						WHEN 'WAIT' THEN
																							CASE WHEN A.STOCK_STATUS = 'WAIT' THEN
																								A.ITEM_ID
																							ELSE
																								'-'
																							END
																						ELSE                  
																							'-'
																						END
																	END
																	)
							--2018-10-24 PIYONG ADD END
							--------------------------------------------------------------------------------------------------------------------------------------
					;


					SET @ROWCOUNT = @@ROWCOUNT

					--2021-12-12 임시로 다시 사용. 2021-11-29   kimcd P5200 공정 생산 품목을 제품으로 전환하는 로직 막음
					--2022-01-04 수량 갱신에 품목 우선 순위 로적 추가
					IF @SHOP_GROUP_ID = 'P'
					BEGIN

							UPDATE A
							SET    A.[FP_APPLY_OPERATION_ID] = B.[FP_APPLY_OPERATION_ID], 
									A.[FP_APPLY_ITEM_ID]      = B.[FP_APPLY_ITEM_ID],
									A.[FP_APPLY_WIPQTY]       = B.[FP_APPLY_WIPQTY]
							FROM   [dbo].[SCM_STOCK_H] A with(nolock),
									(    SELECT A.[COMPANY_ID],
												A.[DIVISION_ID],
												A.[SITE_ID],
												A.[PLANT_ID],
												A.[FACTORY_ID],
												A.[STORAGE_ID],
												A.[CUTOFF_DATE],
												A.[SEQ],
												P.FLOW_ID                                        AS [FP_APPLY_OPERATION_ID], 
												B.PARENT_ITEM_ID                                 AS [FP_APPLY_ITEM_ID],
												B.PARENT_QTY / B.CHILD_QTY * A.[FP_APPLY_WIPQTY] AS [FP_APPLY_WIPQTY],
												ROW_NUMBER() OVER (  PARTITION BY  A.[COMPANY_ID],
																					A.[DIVISION_ID],
																					A.[SITE_ID],
																					A.[PLANT_ID],
																					A.[FACTORY_ID],
																					A.[STORAGE_ID],
																					A.[CUTOFF_DATE],
																					A.[SEQ]
																		ORDER BY CASE WHEN (B.ALT_PRIORITY  = 1 OR B.ALT_PRIORITY IS NULL) THEN 1 ELSE 2 END,  B.PARENT_ITEM_ID ) AS ROW_NUM
										FROM   [dbo].[SCM_STOCK_H] A with(nolock),
												[dbo].[SCM_BOM_M_V]   B with(NOLOCK),
												[dbo].[SCM_ITEM_M]  P with(NOLOCK),
												[dbo].[SCM_ITEM_M]  C with(NOLOCK)
										WHERE  B.COMPANY_ID     = A.COMPANY_ID
										AND	   B.DIVISION_ID    = A.DIVISION_ID
										AND    B.SITE_ID        = A.SITE_ID
										AND    B.PLANT_ID       = A.PLANT_ID
										-- AND    (B.ALT_PRIORITY  = 1 OR B.ALT_PRIORITY IS NULL) 2022-02-23 kimcd 기본품목 제한 로직 제거
										AND    B.CHILD_ITEM_ID  = A.FP_APPLY_ITEM_ID
										AND    P.COMPANY_ID     = A.COMPANY_ID
										AND    P.DIVISION_ID    = A.DIVISION_ID
										AND    P.SITE_ID        = A.SITE_ID
										AND    P.ITEM_ID        = B.PARENT_ITEM_ID
										AND    C.COMPANY_ID     = A.COMPANY_ID
										AND    C.DIVISION_ID    = A.DIVISION_ID
										AND    C.SITE_ID        = A.SITE_ID
										AND    C.ITEM_ID        = A.FP_APPLY_ITEM_ID
										AND    B.EFF_START_DATE <= GETDATE()
										AND    B.EFF_END_DATE   > GETDATE()
										AND    A.CUTOFF_DATE    = CONVERT(DATETIME, @SUM_DATE, 112)
										AND    A.STOCK_TYPE     = 'WIP'
										AND    A.STORAGE_ID     = 'MES'
										AND    A.SITE_ID        = @SITE_ID
										AND    A.INSERT_ID      = @IF_ID
										AND    A.UPDATE_ID      = 'PR_XIF_MES_WIP_R'
										AND    (A.OPERATION_ID  = 'P5000' OR OPERATION_ID > 'P5200')
										AND    A.OPERATION_ID LIKE 'P5%'
										AND    A.[FP_APPLY_OPERATION_ID] IN ('P5200', 'P5500')
										AND    C.FLOW_ID        =  'P5200' ) B
							WHERE  A.[COMPANY_ID]  = B.[COMPANY_ID]
							AND	   A.[DIVISION_ID] = B.[DIVISION_ID]
							AND	   A.[SITE_ID]     = B.[SITE_ID]
							AND	   A.[PLANT_ID]    = B.[PLANT_ID]
							AND	   A.[FACTORY_ID]  = B.[FACTORY_ID]
							AND	   A.[STORAGE_ID]  = B.[STORAGE_ID]
							AND	   A.[CUTOFF_DATE] = B.[CUTOFF_DATE]
							AND	   A.[SEQ]         = B.[SEQ]
							AND    B.[ROW_NUM]     = 1
					END;

					UPDATE [dbo].[SY_XIF_MES_WIP_HOLD_SUM_R] 
					   SET PROC_FLAG	= 'Y'
						 , PROC_DATE	= GETDATE()
					 WHERE 1 = 1
					   AND PROC_FLAG	= 'P'
					   AND IF_ID		= @IF_ID
					   AND SUM_DATE		= @SUM_DATE -- 2021-08-19   kimcd 변수명, 데이터 유형 변경
					;

				END;





				COMMIT TRAN

				FETCH NEXT FROM CUR_IF_MES_WIP INTO @IF_ID
													,@SUM_DATE -- 2021-08-19   kimcd 변수 추가
													,@SUM_DTTM -- 2021-08-19   kimcd 변수명, 데이터 유형 변경
													,@SITE_ID
													,@START_TIME  -- 2020-09-23 kimcd 시업 시간 구분자 추가
													,@SHOP_GROUP_ID -- 2021-08-19   kimcd 공정군 변수 추가
				;


			END;

			CLOSE CUR_IF_MES_WIP;
			DEALLOCATE CUR_IF_MES_WIP;  

 

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		--COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		SELECT @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
