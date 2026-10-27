
CREATE     PROCEDURE [dbo].[PR_XIF_MES_DAILY_PP_S]

-- ================================================================================================
-- Program ID          : FP02620
-- Program Name        : PR_XIF_MES_DAILY_PP_S
-- Param               :
-- Batch Period        : 1 Day
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF
-- Source Table        : FP_DAILY_PRODUCTION_PLAN_R
-- Destination Table   : XIF_MES_DAILY_PP_S
--
-- Create(Update) Date : 2016.09.08
-- Update Date		   : 2017.04.14 1.1
--						 2017.11.29 2.0
--                       2017.12.29 2.1
--                       2018.02.23 2.2
--                       2018.04.09 2.3
--                       2018.04.27 2.4
--                       2018.04.30 2.5
--                       2018.05.15 2.6
--						 2018.05.28 2.7
--                       2018.09.14 2.8
--                       2018.09.19 2.9
--                       2018.10.02 3.0
--						 2018.10.16 3.1
--                       2018.11.06 3.2
--                       2018.12.11 3.3
--						 2018.12.20 3.4
--						 2019.01.09 3.5
--                       2019.01.17 3.6
--                       2019.02.14 3.7
--                       2019.02.18 3.8
--                       2019.08.21 3.9
--                       2019.08.21 3.10
--						 2019.09.20 3.11
--                       2019.10.01 3.12
--						 2020.01.14 4.0
--                       2021.01.27 4.1
--                       2022.10.31 4.3

-- Author              : 김 석
-- Version             : 1.0
--                       1.1 kimcd add plan_id condition. tuning 2017-04-14
--						 2.0 FP_DAILY_PRODUCTIOIN_PLAN_H 정보 생성 추가
--                       2.1 kimcd fixed plan만 전송되도록 조건 추가
--                       2.2 kimcd 일자별 계획에 Plan 유형, Equipment ID 추가
--                       2.3 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량.
--                           Pancake Meter, Jumbo Roll Meter, Batch Qty, Cell 수량 추가
--                       2.4 kimcd instance id, plan group id 부가 정보로 전송
--                       2.5 kimcd 속도 개선 작업
--                       2.6 kimcd 일자별 계획 전송에서 LOCK 발생하는 경우 발생하여 
--                                 FP_DAILY_PRODUCTIOIN_PLAN_H 삭제 과정에서 NOLOCK 삭제
--						 2.7 ATTR_O3 ACCUM_DATE  ATTR_04  ACCUM_COUNT 정보 추가
--                       2.8 2018-09-14 kimcd 세정 컬럼 추가
--                       2.9 2018-09-19 kimcd 세정, 메모 정보 MES로 전송
--                       3.0 2018-10-02 kimcd 일자별 계획 delete에서 수량 0 갱신으로 임시 조정
--						 3.1 2018-10-16 PIYONG 전극 생산 우선 순위를 관리하기 위해 SEQ 추가
--                       3.2 2018-11-06 kimcd  활성화 후 공정 Cell Material ID 컬럼 추가
--                       3.3 2018-12-11 kimcd  TOTAL_BATCH 주별 계획 BATCH 합 정보 추가
--						 3.4 2018-12-20 PIYONG PIG 세정 컬럼 추가
--						 3.5 2019-01-09 PIYONG FULL, PIG세정 강화 관련 색 지정
--                       3.6 2019-01-17 kimcd  기존 정보 중 수량 0으로 유지된 정보 삭제. INSTANCE별 설정에 따라 계획 형성 범위 제한
--                       3.7 2019-02-14 kimcd  오창 자동차 조립 model 분리로 계획 정보 삭제되는 현상 보완
--                       3.8 2019-02-18 kimcd  일자별 계획 누적에서 Plan Group을 Key에서 제거
--						 3.9 FMCS 에 ROLL (광폭 포함) 수량을 조회하기 위해 ATTR_08 -> JR_IN_QTY, ATTR_09 -> JR_OUT_QTY 추가 송신
--						 3.10 전극 후공정 정보 추가 송신
--						 3.11 전송 테이블 컬럼 변경 ROLL_IN_QTY -> PANCAKE_IN_QTY,  ROLL_OUT_QTY -> PANCAKE_OUT_QTY
--                       3.12 2019-10-01 kimcd scm_equipment_m 조인에서 factory id 조건 추가
--						 4.0 piyong  daily pp  전송 로직 삭제 (procedure  분리)
--                       4.1 2021-01-27 kimcd 전극 후 공정 일별 계획을 shift별 형성
--                       4.2 2022-06-09 kimcd location은 항상 갱신하도록 수정
--                       4.3 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
-- ================================================================================================

-- PARAM PLAN_ID
@P_FP_PLAN_ID NVARCHAR(50) = NULL

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_DAILY_PP_S'
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
	DECLARE @if_id_code             NVARCHAR(50)  = 'OFP0_OSC1_XIF_MES_DAILY_PP'
	DECLARE @send_if_seq            NVARCHAR(50)
	DECLARE @send_date              NVARCHAR(50)
	DECLARE @if_seq_next            BIGINT
	DECLARE @TIME_SHIFT_TABLE table
            (SHIFT NVARCHAR(10),
			 PLAN_START_TIME NVARCHAR(10)
	        ) -- 2021-01-27 kimcd 전극 후 공정 일별 계획을 shift별 형성

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
/*
			DELETE A
			  FROM FP_DAILY_PRODUCTIOIN_PLAN_H A WITH (INDEX=[IX02_FP_DAILY_PRODUCTIOIN_PLAN_H])
					,(
						SELECT A.PLAN_GROUP_ID
								,B.INSTANCE_TYPE
								,DATEADD( D, -15, CONVERT(DATETIME, A.PLAN_DATE, 112) ) AS INSTANCE_DATE
								,B.FACTORY_ID
								,A.DIVISION_ID  -- 2019-02-14 kimcd 라인 정보 추출을 위해 구분자 추가
								,A.INSTANCE_ID  -- 2019-02-14 kimcd 라인 정보 추출을 위해 구분자 추가
						FROM (SELECT PLAN_DATE
										, INSTANCE_ID
										, DIVISION_ID
										, FACTORY_ID
										, '-' AS PLAN_GROUP_ID
										, RELEASE_PLAN_ID
								FROM DBO.SCM_FP_PLAN_DETAIL_H C(NOLOCK)
								WHERE RELEASE_FLAG IN ( 'P', 'Y')
									AND RELEASE_PLAN_ID = @P_FP_PLAN_ID
								UNION ALL
								SELECT PLAN_DATE
										, INSTANCE_ID
										,'-' AS DIVISION_ID
										,'-' AS FACTORY_ID
										, PLAN_GROUP_ID
										, RELEASE_PLAN_ID
								FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
								WHERE RELEASE_FLAG IN ( 'P', 'Y')
									AND RELEASE_PLAN_ID = @P_FP_PLAN_ID
								) A
								,( SELECT A.[INSTANCE_ID]
										,INSTANCE_TYPE
										,B.SITE_ID
										,B.FACTORY_ID
										,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
										,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
									FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
										,DBO.SCM_FACTORY_M B WITH(NOLOCK)
										,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
														ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
													AND MP.SEGMENT1 = SLV.SEGMENT1
													AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
									WHERE A.FACTORY_ID = B.FACTORY_ID     
									AND A.ACTIVE_FLAG = 'Y'     
									AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
									AND A.INSTANCE_ID != 'KR_CELL_M_P'
									AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
									AND SLV.SEGMENT1 = A.INSTANCE_ID
								UNION ALL
									SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
										,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
										,B.SITE_ID
										,B.FACTORY_ID
										,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
										,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
									FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
										,DBO.SCM_FACTORY_M B WITH(NOLOCK)
										,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
														ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
													AND MP.SEGMENT1 = SLV.SEGMENT1
													AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
									WHERE A.FACTORY_ID = B.FACTORY_ID     
									AND A.ACTIVE_FLAG = 'Y'     
									AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
									AND A.INSTANCE_ID = 'KR_CELL_M_P'
									AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
									AND SLV.SEGMENT1 = A.INSTANCE_ID
								) B      
						WHERE A.INSTANCE_ID = B.INSTANCE_ID
							AND A.FACTORY_ID = B.LINK_FACTORY_ID
							AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
							AND A.RELEASE_PLAN_ID = @P_FP_PLAN_ID
						) B
				WHERE A.UPDATE_TIME <= DATEADD( D, -1, GETDATE())
				-- AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID 2019-02-18 kimcd PLAN GROUP ID 조건을 제거하고 라인 기준으로 함
				AND A.FACTORY_ID = B.FACTORY_ID
				AND A.INSTANCE_TYPE = B.INSTANCE_TYPE
				AND A.PLAN_TYPE  = 'RELEASE' -- 2018-02-23 kimcd 조건 추가
   				AND A.PLAN_DATE >= B.INSTANCE_DATE
				AND A.PLAN_QTY   = 0			-- 2019-01-17 kimcd 계획 숫자 0인 계획 삭제 조건 추가
				-- 2019-02-14 kimcd 라인 조건 추가 시작
				AND EXISTS ( 
									SELECT 1
										FROM (
											SELECT DISTINCT LINE_ID
											FROM   SCM_LINE_M L WITH(NOLOCK, INDEX=PK_SCM_LINE_M)
											WHERE  L.FACTORY_ID  = B.FACTORY_ID
											AND    CASE WHEN B.PLAN_GROUP_ID = '-' THEN B.PLAN_GROUP_ID ELSE L.MODEL_TYPE END = B.PLAN_GROUP_ID
											AND    NOT EXISTS (SELECT 1
																FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
																AND    SLV.ACTIVE_FLAG       = 'Y'
																AND    SLV.SEGMENT2          = B.INSTANCE_ID
																AND    SLV.SEGMENT3          = L.LINE_ID )
											AND    NOT EXISTS (SELECT 1
																FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
																AND    SLV.ACTIVE_FLAG       = 'Y'
																AND    SLV.SEGMENT1          = B.INSTANCE_ID)
											UNION ALL
											SELECT SLV.SEGMENT3
											FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
											WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
											AND    SLV.ACTIVE_FLAG       = 'Y'
											AND    SLV.SEGMENT1          = B.INSTANCE_ID
											)  C
									WHERE A.LINE_ID = C.LINE_ID
									)
*/

			/* 2018-10-02 kimcd 임시 block 일자별 계획 입력 문장 막음
			-- 데이터 생성
			INSERT INTO FP_DAILY_PRODUCTIOIN_PLAN_H
			(
				[COMPANY_ID]
			    ,[DIVISION_ID]
			    ,[SITE_ID]
			    ,[PLANT_ID]
			    ,[FACTORY_ID]
			    ,[PLAN_GROUP_ID]
			    ,[INSTANCE_TYPE]
			    ,[TOP_ITEM_ID]
			    ,[ITEM_ID]
			    ,[OPERATION_ID]
			    ,[LOCATION]
			    ,[PRODUCTION_TYPE]
			    ,[MARKET]
			    ,[LINE_ID]
			    ,[ELECTRODE_TYPE]
			    ,[PLAN_DATE]
			    ,[PLAN_QTY]
			    ,[PLAN_IN_QTY]
			    ,[INSERT_ID]
			    ,[INSERT_TIME]
			    ,[UPDATE_ID]
			    ,[UPDATE_TIME]
				,[PLAN_TYPE]       -- 2018-02-23 kimcd 계획 유형 추가 - RELEASE
				,[EQUIPMENT_ID]    -- 2018-02-23 kimcd 설비 정보 추가
				-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
				,[FP_PRODUCTION_TYPE]
				,[ROLL_IN_QTY]
				,[ROLL_OUT_QTY]
				,[JR_IN_QTY]
				,[JR_OUT_QTY]
				,[BATCH_IN_QTY]
				,[BATCH_OUT_QTY]
				,[CELL_IN_QTY]
				,[CELL_OUT_QTY]
				-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
				,[FULL_CLEANING_FLAG]      -- 2018-09-14 kimcd 추가 풀 세척
				,[MODEL_TYPE_CHANGE_FLAG]  -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경
				,[SEQ]				--2018-10-16 PIYONG ADD 전극 생산 우선 순위를 관리하기 위한 SEQ
				,[CELL_MATERIAL_ID] --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
				,[TOTAL_BATCH]      --2018-12-11 kimcd  주별 계획 BATCH 합 추가
			)
			SELECT B.COMPANY_ID
				   ,B.DIVISION_ID
				   ,B.SITE_ID
				   ,B.PLANT_ID
				   ,A.FACTORY_ID
				   ,A.PLAN_GROUP_ID
				   ,(SELECT TOP 1 INSTANCE_TYPE
				      FROM ( SELECT FF.INSTANCE_TYPE
								  FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
								 WHERE FF.ACTIVE_FLAG = 'Y'     
								   AND FF.INSTANCE_ID != 'KR_CELL_M_P'
								   AND FF.INSTANCE_ID = A.INSTANCE_ID
								UNION ALL
								SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
								  FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
								 WHERE FF.ACTIVE_FLAG = 'Y'     
								   AND FF.INSTANCE_ID = 'KR_CELL_M_P'
								   AND FF.INSTANCE_ID = A.INSTANCE_ID ) FF)  INSTANCE_TYPE
				   ,A.TOP_ITEM_ID
				   ,A.ITEM_ID
				   ,A.OPERATION_ID
				   ,ISNULL((SELECT LOCATION 
							  FROM SCM_LINE_M WITH(NOLOCK)
						     WHERE LINE_ID = A.LINE_ID
							   AND OPERATION_ID = A.OPERATION_ID
							   AND FACTORY_ID = A.FACTORY_ID
							   AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
				   ,A.PRODUCTION_TYPE
				   ,A.MARKET
				   ,A.LINE_ID
				   ,A.ELECTRODE_TYPE
				   ,A.PLAN_DATE
				   ,A.PLAN_QTY
				   ,A.PLAN_IN_QTY
				   ,'PR_XIF_MES_DAILY_PP_S'
				   ,GETDATE()
				   ,'PR_XIF_MES_DAILY_PP_S'
				   ,GETDATE()
				   ,'RELEASE'         -- [PLAN_TYPE] 2018-02-23 kimcd 계획 유형 추가
				   ,A.EQUIPMENT_ID    -- 2018-02-23 kimcd 설비 정보 추가
					-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
				   ,A.FP_PRODUCTION_TYPE
				   ,A.ROLL_IN_QTY
				   ,A.ROLL_OUT_QTY
				   ,A.JR_IN_QTY
				   ,A.JR_OUT_QTY
				   ,A.BATCH_IN_QTY
				   ,A.BATCH_OUT_QTY
				   ,A.CELL_IN_QTY
				   ,A.CELL_OUT_QTY
					-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
				   ,A.FULL_CLEANING_FLAG      -- 2018-09-14 kimcd 추가 풀 세척
				   ,A.MODEL_TYPE_CHANGE_FLAG  -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경
   				   ,A.SEQ				--2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ
				   ,A.CELL_MATERIAL_ID  --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
				   ,A.TOTAL_BATCH       --2018-12-11 kimcd  주별 계획 BATCH 합 추가
			  FROM (
					SELECT PP.FACTORY_ID
						   ,A.PLAN_GROUP_ID
						   ,TOP_ITEM_ID
						   ,ITEM_ID
						   ,OPERATION_ID
						   ,MAX(PRODUCTION_TYPE) AS PRODUCTION_TYPE        -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY에서 제외
						   ,ISNULL(FP_PRODUCTION_TYPE, PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가
						   ,ISNULL(MARKET,'D') AS MARKET
						   ,LINE_ID
						   ,MAX(ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
						   ,PP.PLAN_DATE
						   ,SUM(PLAN_QTY) AS PLAN_QTY
						   ,SUM(PLAN_IN_QTY) AS PLAN_IN_QTY
						   ,MAX(A.INSTANCE_ID) AS INSTANCE_ID
						   ,PP.EQUIPMENT_ID   -- 2018-02-23 kimcd 설비 정보 추가
						   -- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 시작
						   ,SUM(PP.ROLL_IN_QTY)    AS ROLL_IN_QTY
						   ,SUM(PP.ROLL_OUT_QTY)   AS ROLL_OUT_QTY
						   ,SUM(PP.JR_IN_QTY)      AS JR_IN_QTY
						   ,SUM(PP.JR_OUT_QTY)     AS JR_OUT_QTY
						   ,SUM(PP.BATCH_IN_QTY)   AS BATCH_IN_QTY
						   ,SUM(PP.BATCH_OUT_QTY)  AS BATCH_OUT_QTY
						   ,SUM(PP.CELL_IN_QTY)    AS CELL_IN_QTY
						   ,SUM(PP.CELL_OUT_QTY)   AS CELL_OUT_QTY
						   -- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 끝
						   ,MAX(PP.FULL_CLEANING_FLAG)      AS  FULL_CLEANING_FLAG       -- 2018-09-14 kimcd 추가 풀 세척
						   ,MAX(PP.MODEL_TYPE_CHANGE_FLAG)  AS  MODEL_TYPE_CHANGE_FLAG   -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경
   						   ,MAX(PP.SEQ) AS SEQ											-- 2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ
						   ,MAX(PP.CELL_MATERIAL_ID) AS CELL_MATERIAL_ID  --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
						   ,MAX(PP.TOTAL_BATCH)    AS TOTAL_BATCH --2018-12-11 kimcd  주별 계획 BATCH 합 추가
					  FROM FP_DAILY_PRODUCTION_PLAN_R PP WITH(NOLOCK),
						   (SELECT PLAN_DATE
								   , INSTANCE_ID
								   , DIVISION_ID
								   , FACTORY_ID
								   , '-' AS PLAN_GROUP_ID
								   , RELEASE_PLAN_ID
							  FROM DBO.SCM_FP_PLAN_DETAIL_H C(NOLOCK)
						     WHERE RELEASE_FLAG IN ( 'P', 'Y')
						       AND RELEASE_PLAN_ID = @P_FP_PLAN_ID
						     UNION ALL
						    SELECT PLAN_DATE
								   , INSTANCE_ID
								   ,'-' AS DIVISION_ID
								   ,'-' AS FACTORY_ID
								   , PLAN_GROUP_ID
								   , RELEASE_PLAN_ID
							  FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
						     WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
							   AND RELEASE_PLAN_ID = @P_FP_PLAN_ID
						   ) A
                     WHERE A.RELEASE_PLAN_ID = @P_FP_PLAN_ID--'KR_CELL-20171125-99' --'CN_CELL_M2-20171121-98'
                       AND A.RELEASE_PLAN_ID = PP.FP_PLAN_ID
					   AND A.INSTANCE_ID     = PP.INSTANCE_ID -- 2018-03-30 kimcd add instance_id
					 GROUP BY PP.FACTORY_ID
						   ,A.PLAN_GROUP_ID
						   ,TOP_ITEM_ID
						   ,ITEM_ID
						   ,OPERATION_ID
						   ,ISNULL(FP_PRODUCTION_TYPE, PRODUCTION_TYPE) -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY 조건 조정
						   ,ISNULL(MARKET,'D')
						   ,LINE_ID
						   --,ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
						   ,PP.PLAN_DATE
						   ,PP.EQUIPMENT_ID  -- 2018-02-23 kimcd group by 조건 추가
				   )A
				   , SCM_FACTORY_M B WITH(NOLOCK)
			  WHERE A.FACTORY_ID = B.FACTORY_ID
			--------------------------------------------------------------------------------------------------------------------
			----- 2017-11-29 PIYONG   FP_DAILY_PRODUCTIOIN_PLAN_H 정보 생성 끝
			--------------------------------------------------------------------------------------------------------------------
		    2018-10-02 kimcd 임시 block 일자별 계획을 삭제하지 않도록 막음*/

			-- 2018-10-02 kimcd 임시 적용
			-- 일자별 계획을 0으로 갱신 시작
			UPDATE A 
			SET  [PLAN_QTY]                = 0
				,[PLAN_IN_QTY]             = 0
				,[ROLL_IN_QTY]             = 0
				,[ROLL_OUT_QTY]            = 0
				,[JR_IN_QTY]               = 0
				,[JR_OUT_QTY]              = 0
				,[BATCH_IN_QTY]            = 0
				,[BATCH_OUT_QTY]           = 0
				,[CELL_IN_QTY]             = 0
				,[CELL_OUT_QTY]            = 0
				,[FULL_CLEANING_FLAG]      = NULL		
				,[PIG_CLEANING_FLAG]	   = NULL		--2018-12-20 PIYONG ADD  PIG 세정 여부	
				,[MODEL_TYPE_CHANGE_FLAG]  = NULL		
				,[SEQ]					   = 0			--2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ 초기화
				,[CELL_MATERIAL_ID]        = NULL       --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 초기화
				,[TOTAL_BATCH]             = NULL       --2018-12-11 kimcd 주별 계획 BATCH 합 추가
				,[SETUP_COLOR_CODE]		   = '-'        --2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
				,[UPDATE_ID]               = 'PR_XIF_MES_DAILY_PP_S'
				,[UPDATE_TIME]             = GETDATE()
				FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting함
					,(
						SELECT A.PLAN_GROUP_ID
								,B.INSTANCE_TYPE
								,CONVERT(DATETIME, A.PLAN_DATE, 112) AS INSTANCE_DATE
								,B.FACTORY_ID
								,A.DIVISION_ID  -- 2019-02-14 kimcd 라인 정보 추출을 위해 구분자 추가
								,A.INSTANCE_ID  -- 2019-02-14 kimcd 라인 정보 추출을 위해 구분자 추가
						FROM (SELECT PLAN_DATE
										, INSTANCE_ID
										, DIVISION_ID
										, FACTORY_ID
										, '-' AS PLAN_GROUP_ID
										, RELEASE_PLAN_ID
								FROM DBO.SCM_FP_PLAN_DETAIL_H C(NOLOCK)
								WHERE RELEASE_FLAG IN ( 'P', 'Y')
									AND RELEASE_PLAN_ID = @P_FP_PLAN_ID
								UNION ALL
								SELECT PLAN_DATE
										, INSTANCE_ID
										,'-' AS DIVISION_ID
										,'-' AS FACTORY_ID
										, PLAN_GROUP_ID
										, RELEASE_PLAN_ID
								FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
								WHERE RELEASE_FLAG IN ( 'P', 'Y')
									AND RELEASE_PLAN_ID = @P_FP_PLAN_ID
								) A
								,( SELECT A.[INSTANCE_ID]
										,INSTANCE_TYPE
										,B.SITE_ID
										,B.FACTORY_ID
										,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
										,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
									FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
										,DBO.SCM_FACTORY_M B WITH(NOLOCK)
										,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
														ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
													AND MP.SEGMENT1 = SLV.SEGMENT1
													AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
									WHERE A.FACTORY_ID = B.FACTORY_ID     
									AND A.ACTIVE_FLAG = 'Y'     
									AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
									AND A.INSTANCE_ID != 'KR_CELL_M_P'
									AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
									AND SLV.SEGMENT1 = A.INSTANCE_ID
								UNION ALL
									SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
										,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
										,B.SITE_ID
										,B.FACTORY_ID
										,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
										,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
									FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
										,DBO.SCM_FACTORY_M B WITH(NOLOCK)
										,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
														ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
													AND MP.SEGMENT1 = SLV.SEGMENT1
													AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
									WHERE A.FACTORY_ID = B.FACTORY_ID     
									AND A.ACTIVE_FLAG = 'Y'     
									AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
									AND A.INSTANCE_ID = 'KR_CELL_M_P'
									AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
									AND SLV.SEGMENT1 = A.INSTANCE_ID
								) B      
						WHERE A.INSTANCE_ID = B.INSTANCE_ID
							AND A.FACTORY_ID = B.LINK_FACTORY_ID
							AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
							AND A.RELEASE_PLAN_ID = @P_FP_PLAN_ID
					) B
				WHERE A.FACTORY_ID = B.FACTORY_ID
				-- AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID 2019-02-18 kimcd PLAN GROUP ID 조건을 제거하고 라인 기준으로 함
				AND A.INSTANCE_TYPE = B.INSTANCE_TYPE
				AND A.PLAN_DATE >= B.INSTANCE_DATE
				AND A.PLAN_TYPE  = 'RELEASE' -- 2018-02-23 kimcd 조건 추가
				-- 2019-02-14 kimcd 라인 조건 추가 시작
				AND A.LINE_ID IN ( SELECT DISTINCT LINE_ID
									FROM   SCM_LINE_M L WITH(NOLOCK)
									WHERE  L.FACTORY_ID  = B.FACTORY_ID
									AND    CASE WHEN B.PLAN_GROUP_ID = '-' THEN B.PLAN_GROUP_ID ELSE L.MODEL_TYPE END = B.PLAN_GROUP_ID
									AND    NOT EXISTS (SELECT 1
														FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
														AND    SLV.ACTIVE_FLAG       = 'Y'
														AND    SLV.SEGMENT2          = B.INSTANCE_ID
														AND    SLV.SEGMENT3          = L.LINE_ID )
									AND    NOT EXISTS (SELECT 1
														FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
														AND    SLV.ACTIVE_FLAG       = 'Y'
														AND    SLV.SEGMENT1          = B.INSTANCE_ID)
								/*	
									UNION ALL
									SELECT SLV.SEGMENT3
									FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
									WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
									AND    SLV.ACTIVE_FLAG       = 'Y'
									AND    SLV.SEGMENT1          = B.INSTANCE_ID
							*/	
									UNION ALL		
									SELECT DISTINCT LINE_ID
									FROM   SCM_LINE_M L WITH(NOLOCK)
									WHERE  L.FACTORY_ID  = B.FACTORY_ID
									AND    (CASE WHEN B.PLAN_GROUP_ID = '-' THEN B.PLAN_GROUP_ID ELSE L.MODEL_TYPE END) = B.PLAN_GROUP_ID
									AND    EXISTS (SELECT 1
														FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
														AND    SLV.ACTIVE_FLAG       = 'Y'
														AND    SLV.SEGMENT1          = B.INSTANCE_ID
														AND    SLV.SEGMENT3          = L.LINE_ID 
													)
														
									)
				-- 2019-02-14 kimcd 라인 조건 추가 끝


			DELETE @TIME_SHIFT_TABLE; -- clear temp table
			INSERT INTO @TIME_SHIFT_TABLE
				(SHIFT,
				 PLAN_START_TIME)
			SELECT SHIFT,
				   PLAN_START_TIME
			FROM   FP_PLAN_SHIFT_H  PS (NOLOCK),
					(SELECT INSTANCE_ID,
							PLAN_ID
					FROM DBO.SCM_FP_PLAN_DETAIL_H C(NOLOCK)
					WHERE RELEASE_PLAN_ID = @P_FP_PLAN_ID
					UNION
					SELECT INSTANCE_ID,
						   PLAN_ID
					FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
					WHERE RELEASE_PLAN_ID = @P_FP_PLAN_ID
					) P
			WHERE PS.INSTANCE_ID = P.INSTANCE_ID
			AND   PS.PLAN_ID     = P.PLAN_ID; -- 2021-01-27 kimcd 시업 시간 등록

			-- 데이터 생성
			MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP
			USING ( SELECT  B.COMPANY_ID
							,B.DIVISION_ID
							,B.SITE_ID
							,B.PLANT_ID
							,A.FACTORY_ID
							,A.PLAN_GROUP_ID
							,(SELECT TOP 1 INSTANCE_TYPE
								FROM ( SELECT FF.INSTANCE_TYPE
											FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
											WHERE FF.ACTIVE_FLAG = 'Y'     
											AND FF.INSTANCE_ID != 'KR_CELL_M_P'
											AND FF.INSTANCE_ID = A.INSTANCE_ID
										UNION ALL
										SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
											FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
											WHERE FF.ACTIVE_FLAG = 'Y'     
											AND FF.INSTANCE_ID = 'KR_CELL_M_P'
											AND FF.INSTANCE_ID = A.INSTANCE_ID ) FF)  INSTANCE_TYPE
							,A.TOP_ITEM_ID
							,A.ITEM_ID
							,A.OPERATION_ID
							,ISNULL((SELECT LOCATION 
										FROM SCM_LINE_M WITH(NOLOCK)
										WHERE LINE_ID = A.LINE_ID
										AND OPERATION_ID = A.OPERATION_ID
										AND FACTORY_ID = A.FACTORY_ID
										AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
							,A.PRODUCTION_TYPE
							,A.MARKET
							,A.LINE_ID
							,A.ELECTRODE_TYPE
							,CASE WHEN A.SHIFT IS NOT NULL THEN DATEADD( S, CONVERT(NUMERIC(10), A.SHIFT), A.PLAN_DATE) ELSE A.PLAN_DATE END AS PLAN_DATE -- 2021-01-27 kimcd 시업 시간 shift 추가
							,A.PLAN_QTY
							,A.PLAN_IN_QTY
							,'PR_XIF_MES_DAILY_PP_S'  AS INSERT_ID  
							,GETDATE()                AS INSERT_TIME
							,'PR_XIF_MES_DAILY_PP_S'  AS UPDATE_ID
							,GETDATE()                AS UPDATE_TIME
							,'RELEASE'                AS PLAN_TYPE -- 2018-02-23 kimcd 계획 유형 추가
							,A.EQUIPMENT_ID    -- 2018-02-23 kimcd 설비 정보 추가
							-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
							,A.FP_PRODUCTION_TYPE
							,A.ROLL_IN_QTY
							,A.ROLL_OUT_QTY
							,A.JR_IN_QTY
							,A.JR_OUT_QTY
							,A.BATCH_IN_QTY
							,A.BATCH_OUT_QTY
							,A.CELL_IN_QTY
							,A.CELL_OUT_QTY
							-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
							,A.FULL_CLEANING_FLAG      -- 2018-09-14 kimcd 추가 풀 세척					
							,A.PIG_CLEANING_FLAG		  -- 2018-12-20 PIYONG 추가 PIG 세정					
							,A.MODEL_TYPE_CHANGE_FLAG  -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경	
   							,A.SEQ						-- 2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ
							,A.CELL_MATERIAL_ID        --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
							,A.TOTAL_BATCH             --2018-12-11 kimcd  주별 계획 BATCH 합 추가
							,A.SETUP_COLOR_CODE		  --2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
							,A.SHIFT -- 2021-01-27 kimcd 시업 시간 shift추가
							,A.[WORK_REQUEST_MODEL_ID]
							,A.[VERSION]
							,A.[PROD_SEQ]
							,A.[PLM_EC_NO]   -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
						FROM (
							SELECT PP.FACTORY_ID
									,A.PLAN_GROUP_ID
									,TOP_ITEM_ID
									,ITEM_ID
									,OPERATION_ID
									,MAX(PRODUCTION_TYPE) AS PRODUCTION_TYPE        -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY에서 제외
									,ISNULL(FP_PRODUCTION_TYPE, PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가
									,ISNULL(MARKET,'D') AS MARKET
									,LINE_ID
									,MAX(ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
									,PP.PLAN_DATE
									,SUM(PLAN_QTY) AS PLAN_QTY
									,SUM(PLAN_IN_QTY) AS PLAN_IN_QTY
									,MAX(A.INSTANCE_ID) AS INSTANCE_ID
									,PP.EQUIPMENT_ID   -- 2018-02-23 kimcd 설비 정보 추가
									-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 시작
									,SUM(PP.ROLL_IN_QTY)    AS ROLL_IN_QTY
									,SUM(PP.ROLL_OUT_QTY)   AS ROLL_OUT_QTY
									,SUM(PP.JR_IN_QTY)      AS JR_IN_QTY
									,SUM(PP.JR_OUT_QTY)     AS JR_OUT_QTY
									,SUM(PP.BATCH_IN_QTY)   AS BATCH_IN_QTY
									,SUM(PP.BATCH_OUT_QTY)  AS BATCH_OUT_QTY
									,SUM(PP.CELL_IN_QTY)    AS CELL_IN_QTY
									,SUM(PP.CELL_OUT_QTY)   AS CELL_OUT_QTY
									-- 2018-04-09 kimcd 일자별 계획에 전극 환산 계획 수량 추가 끝
									,MAX(PP.FULL_CLEANING_FLAG)      AS  FULL_CLEANING_FLAG       -- 2018-09-14 kimcd 추가 풀 세척					
									,MAX(PP.PIG_CLEANING_FLAG)		AS  PIG_CLEANING_FLAG		 -- 2018-12-20 PIYONG 추가 PIG 세정					
									,MAX(PP.MODEL_TYPE_CHANGE_FLAG)  AS  MODEL_TYPE_CHANGE_FLAG   -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경		
									,MAX(PP.SEQ) AS SEQ												-- 2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ
									,MAX(PP.CELL_MATERIAL_ID)        AS  CELL_MATERIAL_ID         -- 2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
									,MAX(PP.TOTAL_BATCH)             AS TOTAL_BATCH               --2018-12-11 kimcd  주별 계획 BATCH 합 추가
									,MAX(PP.SETUP_COLOR_CODE)		AS SETUP_COLOR_CODE			  --2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
									,ST.SHIFT -- 2021-01-27 kimcd 시업 시간 shift 추가
									,ISNULL(PP.[WORK_REQUEST_MODEL_ID],'-') AS WORK_REQUEST_MODEL_ID
									,ISNULL(PP.[VERSION],'-') AS VERSION
									,ISNULL(PP.[PROD_SEQ],'-') AS PROD_SEQ
									,ISNULL(PP.[PLM_EC_NO],'-')  AS PLM_EC_NO -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
								FROM FP_DAILY_PRODUCTION_PLAN_R PP WITH(NOLOCK)
									LEFT OUTER JOIN  @TIME_SHIFT_TABLE ST
										ON  ST.PLAN_START_TIME = REPLACE(SUBSTRING(CONVERT(NVARCHAR(20), PP.START_TIME, 120), 12, 8), ':', '') -- 2021-01-27 kimcd 시업 시간 shift 연결
									,
									(SELECT PLAN_DATE
											, INSTANCE_ID
											, DIVISION_ID
											, FACTORY_ID
											, '-' AS PLAN_GROUP_ID
											, RELEASE_PLAN_ID
										FROM DBO.SCM_FP_PLAN_DETAIL_H C(NOLOCK)
										WHERE RELEASE_FLAG IN ( 'P', 'Y')
										AND RELEASE_PLAN_ID = @P_FP_PLAN_ID
										UNION ALL
									SELECT PLAN_DATE
											, INSTANCE_ID
											,'-' AS DIVISION_ID
											,'-' AS FACTORY_ID
											, PLAN_GROUP_ID
											, RELEASE_PLAN_ID
										FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
										WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
										AND RELEASE_PLAN_ID = @P_FP_PLAN_ID
									) A
								WHERE A.RELEASE_PLAN_ID = @P_FP_PLAN_ID--'KR_CELL-20171125-99' --'CN_CELL_M2-20171121-98'
								AND A.RELEASE_PLAN_ID = PP.FP_PLAN_ID
								AND A.INSTANCE_ID     = PP.INSTANCE_ID -- 2018-03-30 kimcd add instance_id
								AND PP.PLAN_DATE <= (SELECT TOP 1 DATEADD(D, 0,SC.WEEKEND_DATE) --DATEADD(D,-1,SC.WEEKSTART_DATE)
													FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
															,SCM_SYS_CALENDAR_M   SC  WITH(NOLOCK)
													WHERE  SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
													AND    SLV.SEGMENT1 = A.INSTANCE_ID
													AND    SC.DATE_ID   = DATEADD(D, 7*CONVERT(NUMERIC(3), SLV.ATTRIBUTE15), A.PLAN_DATE) ) -- 2019-01-17 kimcd 계획 형성 구간 제한
								GROUP BY PP.FACTORY_ID
									,A.PLAN_GROUP_ID
									,TOP_ITEM_ID
									,ITEM_ID
									,OPERATION_ID
									,ISNULL(FP_PRODUCTION_TYPE, PRODUCTION_TYPE) -- 2018-04-09 kimcd FP PRODUCTION TYPE 추가에 따른 GROUP BY 조건 조정
									,ISNULL(MARKET,'D')
									,LINE_ID
									--,ELECTRODE_TYPE -- 2018-02-23 kimcd group by 조건에서 제외
									,PP.PLAN_DATE
									,PP.EQUIPMENT_ID  -- 2018-02-23 kimcd group by 조건 추가
									,ST.SHIFT -- 2021-01-27 kimcd 시업 시간 shift 추가
									,ISNULL(PP.[WORK_REQUEST_MODEL_ID],'-')
									,ISNULL(PP.[VERSION],'-')
									,ISNULL(PP.[PROD_SEQ],'-')
									,ISNULL(PP.[PLM_EC_NO],'-')  -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
							)A
							, SCM_FACTORY_M B WITH(NOLOCK)
						WHERE A.FACTORY_ID = B.FACTORY_ID ) B

				ON (	DP.[FACTORY_ID]        = B.[FACTORY_ID]
					-- AND DP.[PLAN_GROUP_ID] = B.[PLAN_GROUP_ID] 2019-02-18 kimcd PLAN GROUP ID 조건을 제거하고 라인 기준으로 함
					AND DP.[INSTANCE_TYPE] = B.[INSTANCE_TYPE]
					AND DP.[PLAN_TYPE]     = B.[PLAN_TYPE]
					AND DP.[ITEM_ID]       = B.[ITEM_ID]
					AND DP.[LINE_ID]       = B.[LINE_ID]
					AND DP.[PLAN_DATE]     = B.[PLAN_DATE]
					AND DP.[TOP_ITEM_ID]   = B.[TOP_ITEM_ID]
					AND DP.[OPERATION_ID]  = B.[OPERATION_ID]
					AND DP.[FP_PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]
					AND DP.[MARKET]        = B.[MARKET]
					AND DP.[EQUIPMENT_ID]  = B.[EQUIPMENT_ID]
					AND DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
					AND	DP.[VERSION]       = B.[VERSION]
					AND	DP.[PROD_SEQ]      = B.[PROD_SEQ]
					AND	DP.[PLM_EC_NO]     = B.[PLM_EC_NO] -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
					)
				WHEN MATCHED THEN
					UPDATE SET   DP.[PRODUCTION_TYPE]         = B.[PRODUCTION_TYPE]
								,DP.[ELECTRODE_TYPE]          = B.[ELECTRODE_TYPE]
								,DP.[PLAN_QTY]                = B.[PLAN_QTY]
								,DP.[PLAN_IN_QTY]             = B.[PLAN_IN_QTY]
								,DP.[ROLL_IN_QTY]             = B.[ROLL_IN_QTY]
								,DP.[ROLL_OUT_QTY]            = B.[ROLL_OUT_QTY]
								,DP.[JR_IN_QTY]               = B.[JR_IN_QTY]
								,DP.[JR_OUT_QTY]              = B.[JR_OUT_QTY]
								,DP.[BATCH_IN_QTY]            = B.[BATCH_IN_QTY]
								,DP.[BATCH_OUT_QTY]           = B.[BATCH_OUT_QTY]
								,DP.[CELL_IN_QTY]             = B.[CELL_IN_QTY]
								,DP.[CELL_OUT_QTY]            = B.[CELL_OUT_QTY]
								,DP.[FULL_CLEANING_FLAG]      = B.[FULL_CLEANING_FLAG]		-- 2018-09-14 kimcd 추가 풀 세척					
								,DP.[PIG_CLEANING_FLAG]		  = B.[PIG_CLEANING_FLAG]		-- 2018-12-20 PIYONG 추가 PIG 세정				
								,DP.[MODEL_TYPE_CHANGE_FLAG]  = B.[MODEL_TYPE_CHANGE_FLAG]	-- 2018-09-14 kimcd 추가 파우치->원각 모델 변경	
								,DP.[SEQ]					  = B.[SEQ]						-- 2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ
								,DP.[CELL_MATERIAL_ID]        = B.[CELL_MATERIAL_ID]  -- 2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
								,DP.[TOTAL_BATCH]             = B.[TOTAL_BATCH]       -- 2018-12-11 kimcd  주별 계획 BATCH 합 추가
								,DP.[SETUP_COLOR_CODE]		  = B.SETUP_COLOR_CODE			--2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
								,DP.[PLAN_GROUP_ID]           = B.[PLAN_GROUP_ID] -- 2019-02-18 kimcd PLAN GROUP ID 조건을 제거하고 갱신하도록 함
								,DP.[SHIFT]                   = B.[SHIFT] -- 2021-01-27 kimcd 시업 시간 shift 추가
								,DP.[UPDATE_ID]               = B.[UPDATE_ID]
								,DP.[UPDATE_TIME]             = B.[UPDATE_TIME]
								,DP.[LOCATION]                = B.[LOCATION] -- 2022-06-09 kimcd LOCATION 항상 갱신하도록 추가
				WHEN NOT MATCHED THEN
					INSERT ( [COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[PLAN_GROUP_ID]
							,[INSTANCE_TYPE]
							,[TOP_ITEM_ID]
							,[ITEM_ID]
							,[OPERATION_ID]
							,[LOCATION]
							,[PRODUCTION_TYPE]
							,[MARKET]
							,[LINE_ID]
							,[ELECTRODE_TYPE]
							,[PLAN_DATE]
							,[PLAN_QTY]
							,[PLAN_IN_QTY]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
							,[PLAN_TYPE]       -- 2018-02-23 kimcd 계획 유형 추가 - RELEASE
							,[EQUIPMENT_ID]    -- 2018-02-23 kimcd 설비 정보 추가
							-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
							,[FP_PRODUCTION_TYPE]
							,[ROLL_IN_QTY]
							,[ROLL_OUT_QTY]
							,[JR_IN_QTY]
							,[JR_OUT_QTY]
							,[BATCH_IN_QTY]
							,[BATCH_OUT_QTY]
							,[CELL_IN_QTY]
							,[CELL_OUT_QTY]
							-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
							,[FULL_CLEANING_FLAG]      -- 2018-09-14 kimcd 추가 풀 세척					
							,[PIG_CLEANING_FLAG]		-- 2018-12-20 PIYONG 추가 PIG 세정				
							,[MODEL_TYPE_CHANGE_FLAG]	-- 2018-09-14 kimcd 추가 파우치->원각 모델 변경	
							,[SEQ]						-- 2018-10-16 PIYONG ADD 전극 생산 우선 순위를 관리하기 위한 SEQ
							,[CELL_MATERIAL_ID]        --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
							,[TOTAL_BATCH]             --2018-12-11 kimcd  주별 계획 BATCH 합 추가
							,[SETUP_COLOR_CODE]		   --2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
							,[SHIFT]                   --2021-01-27 kimcd 시업 시간 shift 추가
							,[WORK_REQUEST_MODEL_ID]
							,[VERSION]
							,[PROD_SEQ]
							,[PLM_EC_NO]  -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
					) VALUES ( B.[COMPANY_ID]
							,B.[DIVISION_ID]
							,B.[SITE_ID]
							,B.[PLANT_ID]
							,B.[FACTORY_ID]
							,B.[PLAN_GROUP_ID]
							,B.[INSTANCE_TYPE]
							,B.[TOP_ITEM_ID]
							,B.[ITEM_ID]
							,B.[OPERATION_ID]
							,B.[LOCATION]
							,B.[PRODUCTION_TYPE]
							,B.[MARKET]
							,B.[LINE_ID]
							,B.[ELECTRODE_TYPE]
							,B.[PLAN_DATE]
							,B.[PLAN_QTY]
							,B.[PLAN_IN_QTY]
							,B.[INSERT_ID]
							,B.[INSERT_TIME]
							,B.[UPDATE_ID]
							,B.[UPDATE_TIME]
							,B.[PLAN_TYPE]       -- 2018-02-23 kimcd 계획 유형 추가 - RELEASE
							,B.[EQUIPMENT_ID]    -- 2018-02-23 kimcd 설비 정보 추가
							-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
							,B.[FP_PRODUCTION_TYPE]
							,B.[ROLL_IN_QTY]
							,B.[ROLL_OUT_QTY]
							,B.[JR_IN_QTY]
							,B.[JR_OUT_QTY]
							,B.[BATCH_IN_QTY]
							,B.[BATCH_OUT_QTY]
							,B.[CELL_IN_QTY]
							,B.[CELL_OUT_QTY]
							-- 2018-04-09 kimcd 일자별 계획에 FP_PRODUCTION_TYPE 컬럼. 전극 환산 계획 수량 추가 시작
							,B.[FULL_CLEANING_FLAG]      -- 2018-09-14 kimcd 추가 풀 세척						
							,B.[PIG_CLEANING_FLAG]		 -- 2018-12-20 PIYONG 추가 PIG 세정					
							,B.[MODEL_TYPE_CHANGE_FLAG]	 -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경		
							,B.[SEQ]					 -- 2018-10-16 PIYONG ADD 전극 생산 우선 순위를 관리하기 위한 SEQ
							,B.[CELL_MATERIAL_ID]        --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
							,B.[TOTAL_BATCH]             --2018-12-11 kimcd  주별 계획 BATCH 합 추가
							,B.[SETUP_COLOR_CODE]			--2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
							,B.[SHIFT]                   --2021-01-27 kimcd 시업 시간 shift 추가
							,B.[WORK_REQUEST_MODEL_ID]
							,B.[VERSION]
							,B.[PROD_SEQ]
							,B.[PLM_EC_NO]  -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
					);

			--------------------------------------------------------------------------------------------------------------------
			----- 2017-11-29 PIYONG   FP_DAILY_PRODUCTIOIN_PLAN_H 정보 생성 끝
			--------------------------------------------------------------------------------------------------------------------		


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
