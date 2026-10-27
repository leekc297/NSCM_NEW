
create PROCEDURE [dbo].[PR_XIF_FCS_ROUTE_R_20230405]

-- ================================================================================================
-- Program ID          : FP00400
-- Program Name        : PR_XIF_FCS_ROUTE_R
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_AGING_ROUTE_R
-- Destination Table   : SCM_AGING_ITEM_FLOW_M
--
-- Create Date         : 2016.08.16
-- Update Date         : 2017.04.26 piyong 1.1
--						 2017.11.30 PIYONG 1.2
--						 2018.03.08 PIYONG 1.3
--						 2018.03.13 PIYONG 1.4
--                       2018.03.22 KIMCD  1.5
--						 2018.03.22 PIYONG 1.6
--						 2018.05.14 PIYONG 1.7
--						 2018.05.25 PIYONG 1.8
--						 2018.05.25 PIYONG 2.0
--						 2018.06.19 PIYONG 3.0
--						 2018.07.17 PIYONG 3.1
--						 2018.08.06 PIYONG 3.2
--						 2018.08.13 PIYONG 3.3
--						 2018.09.27 PIYONG 3.4
--						 2018.10.26 PIYONG 3.5
--						 2018.10.31 PIYONG 3.6
--                       2018.11.06 KIMCD  3.7
--						 2018.11.15 PIYONG 3.8
--                       2018.12.26 kimcd 3.9
--						 2019.01.18 PIYONG 4.0
--						 2019.04.08 PIYONG 4.1
--						 2019.04.22 PIYONG 4.2
--						 2019.05.14 PIYONG 4.3
--						 2019.07.25 PIYONG 4.4 
--						 2019.08.20 PIYONG 4.5
--						 2019.09.17 PIYONG 4.6
--						 2019.10.07 PIYONG 4.7
--						 2019.10.08 PIYONG 4.8
--						 2019.11.11 PIYONG 4.9
--						 2019.11.18 PIYONG 5.0
--						 2020.06.17 PIYONG 6.0
--						 2020.07.09 kimcd  6.1
--						 2020.12.07 kimcd  6.2
--                       2021.04.09 kimcd  6.3
--                       2021.11.11 kimcd  6.4

-- Author              : 김 석
-- Version             : 1.0
--                       1.1 SCM_AGING_ITEM_FLOW_M Delete  terms add
--						 1.2 [DEFAULT_ROUTE], [STANDARD_LT]	데이터 유지를 위해 로직 추가
--						 1.3 DEFAULT_FLAG  Y,N -> S, F 로 변경
--						 1.4 UPDATE_ID, UPDATE_TIME 데이터 복원을 위해 주석 처리
--                       1.5 용량 라우트의 lead time이 다른 route와 합산되어 route_id max로 조건 추가함
--						 1.6 용량 ROUTE의 마지막 공정 일 경우 PROCESSING_TIME의 값을 0으로
--						 1.7 I/F 된 LINE_ID 기준으로  LINE_ID, FACTORY_ID, PLANT_ID 설정
--						 1.8 용량 라우트 최종 공정일때 [STANDARD_LT] 값도 0으로 치환
--						 2.0 DEFAULT_ROUTE, STANDARD_LT, DEFAULT_FLAG 데이터 유지 로직 삭제
--							 용량 라우트 최종 공정일때 PROCESSING_TIME 값 0으로 치환 로직 삭제
--							 DEFAULT_ROUTE, DEFAULT_FLAG look up 관리
--						 3.0 N2.1 ROUTE, LINE, OPERATION, OPERATION_SEQ, OPERATION_STEP 별  OCV2까지 L/T을 OCV2_TOTAL_TIME 컬럼에 입력
--							 용량 ROUTE STANDARD_LT 값 설정 시 PROCESSING_TIME <> 0 조건 추가 
--						 3.1 조회 조건에서 IFSEQNO 제거
--						 3.2 동일 ROUTE 삭제 로직  추가
--						 3.3 ROUTE 종료까지 시간 설정
--							 장현석선임 요청으로 공정별 L/T 종료일자가 20일 이상이면 0으로 변경
--						 3.4 OCV2 종료일자 기준에서 전용OCV2 종료일자로 변경
--						 3.5 PLANT 기준 테이블 변경  F.PLANT_ID -> A.PLANT
--						 3.6 장현석선임 요청으로 공정별 L/T 종료일자가 10일 이상이면 0으로 변경
--                       3.7 2018-11-06 KIMCD 남경소형(G182)는 10일 이상, 마지막 공정 L/T 제거 로직 수행하지 않음.
--                                                             99999(9 다섯개)만 0으로 변경함.
--						 3.8 FCS MODEL_ID -> FP ITEM_ID로 변환시 FACTORY_ID 추가
--                       3.9 2018-12-26 kimcd 속도 개선 작업 조회 조건에 factory_id 추가
--						 4.0 SY_XIF_DW_AGING_ROUTE_R 테이블에서  SY_TM_ROUTE, SY_TM_ROUTE_OP, SY_TM_ROUTE_OP_RECIPE, SY_TM_OP 으로 변경
--						 4.1 프로시저 속도 개선을 위해 ROUTE_TOTAL_TIME , NEXT_ROUTE_ID 생성 로직 분리
--						 4.2 PLANT 정보가 잘못 생성된 정보 삭제
--						 4.3 A2동 ESS라인 생성 하드코딩에서 LOOKUP으로 변경
--						 4.4 장현석 책임 요청으로 폴란드 용량 라우트 마지막 공정은 0-> 1로 변경
--						 4.5 장현석 책임 요청으로 폴란드 기본 라우트 마지막 공정은 0-> 1로 변경
--						 4.6 생성 조건 시업시간 SITE -> PLANT 기준 생성
--						 4.7 장현석 책임 요청으로 폴란드 용량 라우트 마지막 공정은 1.5-> 0로 변경
--						 4.8 FORMATION_LINE_MAPPING  LOOK UP JOIN 시 BUILDING 조건 추가
--						 4.9 초과 한계 시간 추가
--						 5.0 SSP 신유진선임 요청으로 오창 소형 END_TIME 생성 조건 변경
--						 6.0 SPLNUK -> RDB 데이터 수집 변경으로 인해 로직 변경
--                       6.1 2020-07-09 kimcd 속도 이슈로 튜닝 수행
--                       6.2 2020-12-07 kimcd 오창 자동차 사업부 소형 3동(OCMF3)은 자동차 로직 따라야 해서 수정
--                       6.3 2021-04-09 kimcd C20210409-000067 FP 활성화 LT 수식적용오류 개선요청건
--                                      END TIME 계산할 때 초로 시간 관리하는 공정은 /60.0을 하여 시간 합산한다
--                       6.4 2021-11-11 kimcd Aging Route 속도 개선 - Group By 사용으로 메모리 사용량 감소
-- ================================================================================================
-- PARAMETER
@P_SITE_ID NVARCHAR(50) = 'NULL',
@P_SOURCE_INDEX NVARCHAR(50) = 'OC'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_FCS_ROUTE_R'
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
	DECLARE @COMPANY          NVARCHAR(1000)
	DECLARE @DIVISION         NVARCHAR(1000)
	DECLARE @SITE_ID          NVARCHAR(1000)
	DECLARE @ITEM_ID          NVARCHAR(1000)
	DECLARE @PLANT_ID         NVARCHAR(1000)
	DECLARE @PROD_VERSION     NVARCHAR(1000)
	DECLARE @EFF_START_DATE   NVARCHAR(1000)
	DECLARE @EFF_END_DATE     NVARCHAR(1000)
	DECLARE @WORK_CENTER_ID   NVARCHAR(1000)
	DECLARE @LINE_CODE        NVARCHAR(1000)
	DECLARE @OPERATION        NVARCHAR(1000)
	DECLARE @PRIORITY         NVARCHAR(1000)
	DECLARE @VALID_YN         NVARCHAR(1000)
	DECLARE @BOM_VERSION      NVARCHAR(1000)
	DECLARE @V_IFSEQNO	      NVARCHAR(1000)

	DECLARE @ROUTE_ID			NVARCHAR(50)	-- 2018-06-19 PIYONG ADD
	DECLARE @LINE_ID			NVARCHAR(50)	-- 2018-06-19 PIYONG ADD
	DECLARE @NEXT_ROUTE_ID		NVARCHAR(150)	-- 2018-06-19 PIYONG ADD
	DECLARE @OPERATION_ID		NVARCHAR(30)	-- 2018-06-19 PIYONG ADD
	DECLARE @OPERATION_SEQ		NUMERIC(20,10)	-- 2018-06-19 PIYONG ADD
	DECLARE @OPERATION_STEP		NUMERIC(20,10)	-- 2018-06-19 PIYONG ADD
	DECLARE @FACTORY_ID         NVARCHAR(50)    -- 2018-12-26 KIMCD ADD
--	DECLARE @TEMP_PLANT			TABLE (			-- 2019-09-17 PIYONG ADD	--2020-05-04 PIYONG DEL
--										PLANT_ID NVARCHAR(30)
--									  )

	DECLARE @C_SITE_ID			NVARCHAR(50)	-- 2020-05-04 PIYONG ADD
	DECLARE @C_FACTORY_ID		NVARCHAR(50)	-- 2020-05-04 PIYONG ADD
	DECLARE @C_SOURCE_INDEX		NVARCHAR(50)	-- 2020-05-04 PIYONG ADD
	CREATE TABLE #TEMP_ROUTE (
								SITE_ID NVARCHAR(30),
								PLANT_ID NVARCHAR(30),
								BUILDING NVARCHAR(30), 
								MODEL_ID NVARCHAR(150), 
								ROUTE_ID NVARCHAR(30),
								LINE_ID NVARCHAR(30),
								OP_ID NVARCHAR(30),
								OP_SEQ NVARCHAR(30),
								OP_STEP NVARCHAR(30),
								ROUTE_TYPE_CD NVARCHAR(10),
								END_TIME NUMERIC(18,0),
								ROUTE_DESC NVARCHAR(2000),
								OP_NAME NVARCHAR(2000),
								SOURCE_INDEX NVARCHAR(30),
								EXTRA_LIMIT_TIME NUMERIC(18,0),
								ACTUAL_TIME NUMERIC(18,0)
							)

	--------------------------------------------------------------------------------------------------------------------------------------------------------
	--2020-06-17 PIYONG ADD
	CREATE TABLE #TEMP_AGING_ITEM_FLOW_ACTUAL_TIME (
								BUILDING NVARCHAR(30), 
								MODEL_ID NVARCHAR(150), 
								ROUTE_ID NVARCHAR(30),
								LINE_ID NVARCHAR(30),
								OP_ID NVARCHAR(30),
								OP_SEQ NVARCHAR(30),
								OP_STEP NVARCHAR(30),
								SOURCE_INDEX NVARCHAR(30)
							)


							

	DECLARE CUR CURSOR FOR
		SELECT SITE_ID
			   , FACTORY_ID
			   , S.ATTRIBUTE1 AS SOURCE_INDEX
		  FROM SCM_FACTORY_M F WITH(NOLOCK)
			   INNER JOIN (
							SELECT ATTRIBUTE1
									,SEGMENT1
									,SEGMENT2
								FROM SCM_SYS_LOOKUP_VALUE
								WHERE LOOKUP_TYPE_CODE = 'DW_INSTANCE_FP_FACTORY_MAPPING'
								AND ACTIVE_FLAG = 'Y'
							) S
						ON (
								S.SEGMENT1 = F.PLANT_ID
								AND S.SEGMENT2 = F.FACTORY_ID
							)
		 WHERE SHOP_GROUP_ID ='A'
		   AND ACTIVE_FLAG = 'Y'
		   AND FACTORY_ID NOT IN ('M4', 'S2', 'S4')
		   AND CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (F.SITE_ID), 120) >= (
																				SELECT DISTINCT DATEADD(MI,CONVERT(NUMERIC,ISNULL(V.ATTRIBUTE2, '0')), CONVERT(NVARCHAR(10), GETDATE(), 120) + ' ' +  -- 2020-06-17 PIYONG 시업 시간 이후 late time 적용 CNB 정보 정합성 유지용
																								SUBSTRING(V.SEGMENT2, 1,2 ) +':'+
																								SUBSTRING(V.SEGMENT2, 3,2 ) +':'+
																								SUBSTRING(V.SEGMENT2, 5,2 ))
																				  FROM [SCM_SYS_LOOKUP_VALUE] V WITH(NOLOCK)
																				 WHERE V.LOOKUP_TYPE_CODE	= 'BASIS_START_TIME_PLANT'
																				   AND V.ACTIVE_FLAG		= 'Y'
																				   AND V.SEGMENT1			= F.PLANT_ID
																				)
		   AND NOT EXISTS (
							SELECT 1
							  FROM SCM_AGING_ITEM_FLOW_M AF
							 WHERE CONVERT(NVARCHAR(10), UPDATE_TIME, 120) = CONVERT(NVARCHAR(10), GETDATE(), 120)
							   AND F.COMPANY_ID = AF.COMPANY_ID
							   AND F.DIVISION_ID = AF.DIVISION_ID
							   AND F.SITE_ID = AF.SITE_ID
							   AND F.PLANT_ID = AF.PLANT_ID
							   AND F.FACTORY_ID = AF.FACTORY_ID
						  )
		 GROUP BY DIVISION_ID
			   , SITE_ID
			   , PLANT_ID
			   , FACTORY_ID
			   , S.ATTRIBUTE1
	--2020-06-17 PIYONG ADD
	--------------------------------------------------------------------------------------------------------------------------------------------------------

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- ================================================
		-- 로직 추가 start
		-- ================================================
			OPEN CUR;
			FETCH NEXT FROM CUR INTO @C_SITE_ID
									 , @C_FACTORY_ID
									 , @C_SOURCE_INDEX

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
				BEGIN TRAN

/*			--2019-01-18 piyong del
			SET @V_IFSEQNO = (
							  SELECT MAX(IFSEQNO)
								FROM [dbo].[SY_XIF_DW_AGING_ROUTE_R] WITH(NOLOCK)
							   WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'
							 );

			IF @V_IFSEQNO IS NOT NULL AND @V_IFSEQNO !=''
				BEGIN
					 UPDATE [dbo].[SY_XIF_DW_AGING_ROUTE_R]
						SET TRANSFER_FLAG = 'P'
						   ,TRANSFER_DATE = getdate()
					  WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'
--						AND IFSEQNO = @V_IFSEQNO; --PIYONG 2018-07-17 DEL
*/		  	
			/*
			--2018-05-25 PIYONG DEL 사용자가 관리 안함
			-----------------------------------------------------------------------------------------------------------
			--	PIYONG 2017-11-30	[DEFAULT_ROUTE], [STANDARD_LT]	데이터 유지를 유해 TEMP_TABLE에 임시저장 시작
			SELECT [COMPANY_ID]
				   ,[DIVISION_ID]
				   ,[SITE_ID]
				   ,[PLANT_ID]
				   ,[FACTORY_ID]
				   ,[ITEM_ID]
				   ,[ROUTE_ID]
				   ,[LINE_ID]
				   ,[OPERATION_ID]
				   ,[OPERATION_SEQ]
				   ,[OPERATION_STEP]
				   ,[DEFAULT_ROUTE]
				   ,[STANDARD_LT]
				   ,[DEFAULT_FLAG]
			  INTO #tempItemFlow
			  FROM DBO.SCM_AGING_ITEM_FLOW_M
			  WHERE SITE_ID = CASE WHEN @P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL THEN
									  SITE_ID
								   ELSE @P_SITE_ID
								    END
			--	PIYONG 2017-11-30	[DEFAULT_ROUTE], [STANDARD_LT]	데이터 유지를 유해 TEMP_TABLE에 임시저장 끝
			-----------------------------------------------------------------------------------------------------------
			*/
			/*			--2019-01-18 piyong del
					--------------------------------------------------------------------------------------------------
					--2018-08-06 PIYONG  동일 ROUTE 삭제
					DELETE DAR
					  FROM SY_XIF_DW_AGING_ROUTE_R DAR
						   ,(
								SELECT *
								  FROM (
										SELECT AR.PLANT
											   ,AR.BUILDING
											   ,AR.MODEL_ID
											   ,AR.ROUTE_ID
											   ,AR.LINE_ID
											   ,AR.OP_ID
											   ,AR.OP_SEQ
											   ,AR.OP_STEP
											   ,AR.ROUTE_TYPE_CD
											   ,AR.END_TIME
											   ,AR.ROUTE_DESC
											   ,AR.OP_NAME
											   ,AR.IFSEQNO
											   ,ROW_NUMBER() OVER (PARTITION BY [IFSEQNO],
																				[PLANT],
																				[BUILDING],
																				[MODEL_ID],
																				[ROUTE_ID],
																				[LINE_ID],
																				[OP_ID],
																				[OP_SEQ],
																				[OP_STEP]
																   ORDER BY [IFSEQNO] ASC,
																			[PLANT] ASC,
																			[BUILDING] ASC,
																			[MODEL_ID] ASC,
																			[ROUTE_ID] ASC,
																			[LINE_ID] ASC,
																			[OP_ID] ASC,
																			[OP_SEQ] ASC,
																			[OP_STEP] ASC,
																			[END_TIME] DESC ) NUM
										  FROM [dbo].[SY_XIF_DW_AGING_ROUTE_R]  AR WITH(NOLOCK)
										 WHERE TRANSFER_FLAG = 'P'
									   ) A
								 WHERE NUM = 2
							 ) B
					   WHERE DAR.PLANT = B.PLANT
						 AND DAR.BUILDING = B.BUILDING
						 AND DAR.MODEL_ID = B.MODEL_ID
						 AND DAR.ROUTE_ID = B.ROUTE_ID
						 AND DAR.LINE_ID = B.LINE_ID
						 AND DAR.OP_ID = B.OP_ID
						 AND DAR.OP_SEQ = B.OP_SEQ
						 AND DAR.OP_STEP = B.OP_STEP
						 AND DAR.END_TIME = B.END_TIME
						 AND DAR.ROUTE_DESC = B.ROUTE_DESC
						 AND DAR.IFSEQNO = B.IFSEQNO
					--2018-08-06 PIYONG  동일 ROUTE 삭제
					--------------------------------------------------------------------------------------------------
*/
					--------------------------------------------------------------------------------------------------
/*					--2019-09-17 PIYONG ADD	--2020-05-04 PIYONG DEL
					INSERT INTO @TEMP_PLANT
					SELECT DISTINCT PLANT_ID
					  FROM SY_TM_ROUTE TR
					 WHERE TR.USE_YN = 'Y'
					   AND TR.SOURCE_INDEX LIKE @P_SOURCE_INDEX+'%'
					UNION ALL
					SELECT ATTRIBUTE1
					  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
					 WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'			-- A050 생성
					   AND ACTIVE_FLAG = 'Y'
					   AND SEGMENT1	   LIKE @P_SOURCE_INDEX+'%'
					--2019-09-17 PIYONG ADD END
					-------------------------------------------------------------------------------------------------
*/

							;
					DELETE [dbo].[SCM_AGING_ITEM_FLOW_M] 
					 WHERE [SCM_AGING_ITEM_FLOW_M].FACTORY_ID IN ( (				 --2020-05-04 PIYONG CHANGE PLANT_ID IN ( ( SELECT PLANT_ID FROM @TEMP_PLANT ) )
																	SELECT ATTRIBUTE2
																	  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																	 WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'
																	   AND ACTIVE_FLAG = 'Y'
																	   AND SEGMENT1	   = @C_SOURCE_INDEX
																	UNION
																	SELECT @C_FACTORY_ID
																   )
																 )
					;


					--------------------------------------------------------------------------------------------------------------------------------------------------------
					--2020-06-17 PIYONG ADD
					DELETE FROM #TEMP_ROUTE

					IF ( 'OCMF01' = @C_SOURCE_INDEX OR 'NJMF01' = @C_SOURCE_INDEX )
						BEGIN
							INSERT INTO #TEMP_ROUTE
							SELECT (SELECT TOP 1 SITE_ID FROM SCM_PLANT_M WHERE PLANT_ID =  TR.PLANT_ID) AS SITE_ID,
									TR.PLANT_ID AS PLANT_ID , -- 2019-05-14 PIYONG CHANGE CASE WHEN TR.SOURCE_INDEX = 'OCAF02' AND TR.LINE_ID = 'XZ0' THEN 'A050' ELSE TR.PLANT_ID  END  AS PLANT_ID ,
									TR.BUILDING AS BUILDING , -- 2019-05-14 PIYONG CHANGE CASE WHEN TR.SOURCE_INDEX = 'OCAF02' AND TR.LINE_ID = 'XZ0' THEN 'S2' ELSE TR.BUILDING END -> TR.BUILDING
									TR.MODEL_ID,
									UPPER(TR.ROUTE_ID),
									TR.LINE_ID,
									TRO.OP_ID,
									TRO.OP_SEQ,
									ISNULL(TROR.OP_STEP, 1) AS OP_STEP,
									MAX(TR.ROUTE_TYPE_CD),
									MAX(CASE WHEN TRO.USE_YN = 'Y' AND TROR.USE_YN = 'Y' THEN ISNULL (TROR.END_TIME, 0) ELSE 0 END) AS END_TIME,
									MAX(TR.ROUTE_DESC),
									MAX(TMO.OP_NAME),
									TR.SOURCE_INDEX,
									MAX(ISNULL(TROR.EXTRA_LIMIT_TIME, 0 )) AS EXTRA_LIMIT_TIME,	-- 2019-11-11 PIYONG ADD
									MAX(CASE WHEN TRO.USE_YN = 'Y' AND TROR.USE_YN = 'Y' THEN ISNULL(TROR.ACTUAL_TIME, 0 ) ELSE 0 END) AS ACTUAL_TIME				-- 2020-06-16 PIYONG ADD
							  FROM SY_TM_ROUTE TR
								   INNER JOIN SY_TM_ROUTE_OP TRO
										   ON TR.SOURCE_INDEX	= TRO.SOURCE_INDEX
										  AND TR.BUILDING		= TRO.BUILDING
										  AND TR.ROUTE_ID		= TRO.ROUTE_ID
										  AND TR.MODEL_ID		= TRO.MODEL_ID  -- 2020-06-17 PIYONG JOIN 조건 추가 오창소형 1동, 남경소형 1동만 관리
										  AND TR.LINE_ID		= TRO.LINE_ID  -- 2020-06-17 PIYONG JOIN 조건 추가 오창소형 1동, 남경소형 1동만 관리
								   LEFT OUTER JOIN SY_TM_ROUTE_OP_RECIPE TROR
												ON TRO.SOURCE_INDEX	= TROR.SOURCE_INDEX
											   AND TRO.BUILDING		= TROR.BUILDING
											   AND TRO.ROUTE_ID		= TROR.ROUTE_ID
											   AND TRO.OP_ID		= TROR.OP_ID
											   AND TRO.MODEL_ID		= TROR.MODEL_ID  -- 2020-06-17 PIYONG JOIN 조건 추가 오창소형 1동, 남경소형 1동만 관리
											   AND TRO.LINE_ID		= TROR.LINE_ID  -- 2020-06-17 PIYONG JOIN 조건 추가 오창소형 1동, 남경소형 1동만 관리
								   RIGHT OUTER JOIN SY_TM_OP TMO
												 ON TRO.SOURCE_INDEX	= TMO.SOURCE_INDEX
												AND TRO.BUILDING		= TMO.BUILDING
												AND TRO.OP_ID			= TMO.OP_ID
							 WHERE TR.USE_YN = 'Y'
							   AND TR.SOURCE_INDEX = @C_SOURCE_INDEX
							 GROUP BY TR.PLANT_ID, TR.BUILDING, TR.MODEL_ID, UPPER(TR.ROUTE_ID), TR.LINE_ID, TRO.OP_ID, TRO.OP_SEQ, ISNULL(TROR.OP_STEP, 1), TR.SOURCE_INDEX
							 -- 2021-11-11 kimcd 속도 개선위해 Group by 추가
						END
					--2020-06-17 PIYONG ADD
					--------------------------------------------------------------------------------------------------------------------------------------------------------
					ELSE
						BEGIN
							INSERT INTO #TEMP_ROUTE
							SELECT (SELECT TOP 1 SITE_ID FROM SCM_PLANT_M WHERE PLANT_ID =  TR.PLANT_ID) AS SITE_ID,
									TR.PLANT_ID AS PLANT_ID , -- 2019-05-14 PIYONG CHANGE CASE WHEN TR.SOURCE_INDEX = 'OCAF02' AND TR.LINE_ID = 'XZ0' THEN 'A050' ELSE TR.PLANT_ID  END  AS PLANT_ID ,
									TR.BUILDING AS BUILDING , -- 2019-05-14 PIYONG CHANGE CASE WHEN TR.SOURCE_INDEX = 'OCAF02' AND TR.LINE_ID = 'XZ0' THEN 'S2' ELSE TR.BUILDING END -> TR.BUILDING
									TR.MODEL_ID,
									UPPER(TR.ROUTE_ID),
									TR.LINE_ID,
									TRO.OP_ID,
									TRO.OP_SEQ,
									ISNULL(TROR.OP_STEP, 1) AS OP_STEP,
									MAX(TR.ROUTE_TYPE_CD),
									-- CASE WHEN TRO.USE_YN = 'Y' AND TROR.USE_YN = 'Y' THEN ISNULL (TROR.END_TIME, 0) ELSE 0 END AS END_TIME,
									MAX(CASE WHEN TRO.USE_YN = 'Y' AND TROR.USE_YN = 'Y' THEN CASE WHEN TMO.ATTRIBUTE1 = 'SEC' THEN ISNULL (TROR.END_TIME, 0.0)/60.0 ELSE ISNULL (TROR.END_TIME, 0) END ELSE 0 END) AS END_TIME,
									-- 2021-04-09 kimcd END TIME 계산할 때 초로 시간 관리하는 공정은 /60.0을 하여 시간 합산한다
									MAX(TR.ROUTE_DESC),
									MAX(TMO.OP_NAME),
									TR.SOURCE_INDEX,
									MAX(ISNULL(TROR.EXTRA_LIMIT_TIME, 0 )) AS EXTRA_LIMIT_TIME,	-- 2019-11-11 PIYONG ADD
									MAX(CASE WHEN TRO.USE_YN = 'Y' AND TROR.USE_YN = 'Y' THEN ISNULL(TROR.ACTUAL_TIME, 0 )  ELSE 0 END) AS ACTUAL_TIME				-- 2020-06-16 PIYONG ADD
							  FROM SY_TM_ROUTE TR
								   INNER JOIN SY_TM_ROUTE_OP TRO
										   ON TR.SOURCE_INDEX	= TRO.SOURCE_INDEX
										  AND TR.BUILDING		= TRO.BUILDING
										  AND TR.ROUTE_ID		= TRO.ROUTE_ID
								   LEFT OUTER JOIN SY_TM_ROUTE_OP_RECIPE TROR
												ON TRO.SOURCE_INDEX	= TROR.SOURCE_INDEX
											   AND TRO.BUILDING		= TROR.BUILDING
											   AND TRO.ROUTE_ID		= TROR.ROUTE_ID
											   AND TRO.OP_ID = TROR.OP_ID
								   RIGHT OUTER JOIN SY_TM_OP TMO
												 ON TRO.SOURCE_INDEX	= TMO.SOURCE_INDEX
												AND TRO.BUILDING		= TMO.BUILDING
												AND TRO.OP_ID			= TMO.OP_ID
								WHERE TR.USE_YN = 'Y'
								  AND TR.SOURCE_INDEX = @C_SOURCE_INDEX -- LIKE @P_SOURCE_INDEX+'%'	--2020-05-04 PIYONG CHANGE
								GROUP BY TR.PLANT_ID, TR.BUILDING, TR.MODEL_ID, UPPER(TR.ROUTE_ID), TR.LINE_ID, TRO.OP_ID, TRO.OP_SEQ, ISNULL(TROR.OP_STEP, 1), TR.SOURCE_INDEX
								-- 2021-11-11 kimcd 속도 개선위해 Group by 추가
						END



					--------------------------------------------------------------------------------------------------------------------------------------------------------
					--2020-06-17 PIYONG ADD
					IF @C_SOURCE_INDEX LIKE 'NJMF%'
						BEGIN
							INSERT INTO #TEMP_AGING_ITEM_FLOW_ACTUAL_TIME (
								SOURCE_INDEX,
								BUILDING,
								MODEL_ID,
								ROUTE_ID,
								LINE_ID,
								OP_SEQ,
								OP_STEP
							)
							SELECT SOURCE_INDEX,
								   BUILDING,
								   MODEL_ID,
								   ROUTE_ID,
								   LINE_ID,
								   MAX(CAST(OP_SEQ AS INT )) AS OP_SEQ,
								   MAX(CAST(OP_STEP AS INT )) AS OP_STEP
							 FROM #TEMP_ROUTE
							WHERE LEFT(OP_ID, 1 ) IN ( '3', '4', '7' )  -- 2020-06-17 PIYONG 활성화 라우트 중 Aging 공정(3,4,7) 중 마지막 공정 SCP L/T 반영용
							GROUP BY SOURCE_INDEX,
								   BUILDING,
								   MODEL_ID,
								   ROUTE_ID,
								   LINE_ID  --  2020-06-17 PIYONG 남경소형 scp용 l/t 추출
						END
					ELSE
						BEGIN
							INSERT INTO #TEMP_AGING_ITEM_FLOW_ACTUAL_TIME (
								SOURCE_INDEX,
								BUILDING,
								MODEL_ID,
								ROUTE_ID,
								LINE_ID,
								OP_SEQ,
								OP_STEP
							)
							SELECT @C_SOURCE_INDEX AS  SOURCE_INDEX,
								   @C_FACTORY_ID AS BUILDING,
								   NULL AS MODEL_ID,
								   NULL AS ROUTE_ID,
								   NULL AS LINE_ID,
								   NULL AS  OP_SEQ,
								   NULL AS OP_STEP  --  2020-06-17 PIYONG 임시 테이블 #TEMP_AGING_ITEM_FLOW_ACTUAL_TIME 형성용
						END
				--2020-06-17 PIYONG ADD
				--------------------------------------------------------------------------------------------------------------------------------------------------------


				--SELECT TOP 1* FROM DBO.SCM_AGING_ITEM_FLOW_M
					INSERT INTO  DBO.SCM_AGING_ITEM_FLOW_M
					(
						[COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[FACTORY_ID]
						,[ITEM_ID]
						,[ROUTE_ID]
						,[LINE_ID]
						,[OPERATION_ID]
						,[OPERATION_SEQ]
						,[OPERATION_STEP]
						,[ROUTE_TYPE]
						,[PROCESSING_TIME]
						,[ROUTE_DESCRIPTION]
						,[OPERATION_NAME]
						,[INSERT_ID]
						,[INSERT_TIME]
		--					  ,[UPDATE_ID]			--2018-03-13 PIYONG 데이터 복원을 위해 주석 처리
						,[UPDATE_TIME]
						,[DEFAULT_ROUTE]	--2018-05-25 PIYONG ADD
						,[DEFAULT_FLAG]		--2018-05-25 PIYONG ADD
						,[STANDARD_LT]		--2018-05-25 PIYONG ADD
						,[EXTRA_LIMIT_TIME]	--2019-11-11 PIYONG ADD
					)
					SELECT -- DISTINCT  -- 2021-11-11 kimcd 속도 개선위해 DISTINCT 제거
							 A.COMPANY_ID     
							,A.DIVISION_ID    
							,A.SITE_ID        
							,A.PLANT         
							,A.BUILDING      
							,B.MODEL_ID
							,A.ROUTE_ID
							,A.LINE_ID 
							,A.OP_ID         
							,A.OP_SEQ        
							,A.OP_STEP       
							,A.ROUTE_TYPE_CD 
							,A.END_TIME      
							,A.ROUTE_DESC    
							,A.OP_NAME
							,'PR_XIF_FCS_ROUTE_R'              
							,GETDATE()        
		--					   ,'PR_XIF_FCS_ROUTE_R'	--2018-03-13 PIYONG 데이터 복원을 위해 주석 처리
							,GETDATE()
							-----------------------------------------------------------------------------
							--2018-05-25 PIYONG ADD
							,DEFAULT_ROUTE
							,DEFAULT_FLAG		--B: BASIC(기본) C:CAPACITY(용량)    
							,CASE --WHEN ISNULL(MP.ATTRIBUTE2, 'C') = 'B' AND END_TIME > 5760 THEN		
								  --	5760
								  --WHEN ISNULL(MP.ATTRIBUTE2, 'C') = 'C' AND END_TIME > 14400 THEN
								  --	14400
								  WHEN A.SITE_ID = 'A004' AND CAST( A.OP_SEQ AS NUMERIC) >= 91 THEN					-- 2019-08-20 piyong ADD 폴란드 특별 조건 추가
									0
								   WHEN ( END_TIME > 14400 AND A.PLANT NOT IN  ( 'A010', 'G182' )  )			-- 2018-10-31 piyong CHANGE 28800 -> 14400  -- 2019-11-18 PIYONG CHANGE A010 ADD
								        OR ( A.PLANT = 'G182' AND ( END_TIME = 99999 OR END_TIME > 28800 ) ) 	-- 2018-11-06 KIMCD G182가 아니고 100일 초과나 G182이고 99999는 0으로 갱신
										OR ( A.PLANT = 'A010' AND ( END_TIME >= 99999 ) )					 	-- 2019-11-18 PIYONG ADD
																												THEN
									0
								  ELSE
									END_TIME
								  END AS STANDARD_LT
							--2018-05-25 PIYONG ADD 끝
							-----------------------------------------------------------------------------
						   ,A.EXTRA_LIMIT_TIME								-- 2019-11-11 PIYONG ADD
					  FROM (
							--2018-05-14 PIYONG UPDATE
							SELECT F.COMPANY_ID
								   ,F.DIVISION_ID
								   ,F.SITE_ID
								   ,A.PLANT_ID AS PLANT		--2018-10-26 PIYONG CHANGE  F.PLANT_ID -> A.PLANT
								   ,A.BUILDING
								   ,A.MODEL_ID -- MDM 에서 모델 연결정보를 받아오면 바꿔야 함.
								   ,A.ROUTE_ID
								   ,A.LINE_ID  -- FCS 라인과 FP의 LINE 연결정보를 가지고 변경해야 함.
								   ,A.OP_ID
								   ,A.OP_SEQ
								   ,A.OP_STEP
								   ,A.ROUTE_TYPE_CD
								   ,A.END_TIME
								   ,A.ROUTE_DESC
								   ,A.OP_NAME
								   ,MP.ATTRIBUTE4 AS DEFAULT_ROUTE
								   ,ISNULL(MP.ATTRIBUTE2, 'C')	AS DEFAULT_FLAG		--B: BASIC(기본) C:CAPACITY(용량)
								   ,A.EXTRA_LIMIT_TIME								-- 2019-11-11 PIYONG ADD
								   --,ROW_NUMBER() OVER (PARTITION BY A.PLANT_ID,
											--					 [BUILDING],
											--					 [MODEL_ID],
											--					 UPPER([ROUTE_ID]),
											--					 [LINE_ID],
											--					 [OP_ID],
											--					 [OP_SEQ],
											--					 [OP_STEP]
											--			ORDER BY A.PLANT_ID ASC,
											--				  [BUILDING] ASC,
											--				  [MODEL_ID] ASC,
											--				  UPPER([ROUTE_ID]) ASC,
											--				  [LINE_ID] ASC,
											--				  [OP_ID] ASC,
											--				  [OP_SEQ] ASC,
											--				  [OP_STEP] ASC,
											--				  MP.ATTRIBUTE5 DESC,		--2019-05-14 PIYONG ADD
											--				  [END_TIME] DESC
											--										   ) NUM
											-- 2021-11-11 kimcd 속도 개선위해 ROW_NUMBER() 제거
							  FROM (
									  SELECT ISNULL(LM.FACTORY_ID, ISNULL(SSLV1.ATTRIBUTE2, AR.[BUILDING] ) ) AS BUILDING  -- 2019-05-14 PIYONG CHANGE	AR.BUILDING -> ISNULL(SSLV1.ATTRIBUTE2, AR.[BUILDING] )
											,ISNULL(LM.[LINE_ID], AR.LINE_ID ) AS LINE_ID   -- FCS 라인과 FP의 LINE 연결정보를 가지고 변경해야 함.
											,AR.MODEL_ID -- MDM 에서 모델 연결정보를 받아오면 바꿔야 함.
											,AR.ROUTE_ID
											,AR.OP_ID
											,AR.OP_SEQ
											,AR.OP_STEP
											,AR.ROUTE_TYPE_CD
											--------------------------------------------------------------------------------------------------------------------------------------------------------
											--2020-06-17 PIYONG ADD
											,CASE WHEN AR.SOURCE_INDEX IN ('OCMF1','OCMF2') AND LEFT(AR.OP_ID, 1 ) IN ( '3', '4', '7' ) THEN
											       -- 2020-12-07 kimcd A9 오창 자동차 사업부 소형 3동(OCMF3)은 자동차 로직 따라야 해서 수정 OCF%에서 'OCMF1','OCMF2'으로 수정 
													ISNULL(ISNULL( CONVERT( NVARCHAR, AR.ACTUAL_TIME ), AR.END_TIME), '0' )
												  WHEN AR.SOURCE_INDEX LIKE 'NJMF%' AND LEFT(AR.OP_ID, 1 ) IN ( '3', '4', '7' ) 
														AND CAST( AR.OP_SEQ AS INT ) = TEMP_AR.OP_SEQ AND CAST( AR.OP_STEP AS INT ) = TEMP_AR.OP_STEP THEN -- 2020-06-17 PIYONG 남경 소형은 Aging의 마지막 공정만 SCP L/T 사용
													ISNULL( CONVERT( NVARCHAR, AR.ACTUAL_TIME ), '0')
												  ELSE
											--2020-06-17 PIYONG ADD
											--------------------------------------------------------------------------------------------------------------------------------------------------------
											
													AR.END_TIME
												  END AS END_TIME
											,AR.ROUTE_DESC
											,AR.OP_NAME
											,ISNULL(SSLV1.ATTRIBUTE1,AR.PLANT_ID ) AS PLANT_ID	--2018-10-26 PIYONG ADD -- 2019-05-14 PIYONG CHANGE	AR.PLANT_ID -> ISNULL(SSLV1.ATTRIBUTE1,AR.PLANT_ID )
											,AR.EXTRA_LIMIT_TIME								-- 2019-11-11 PIYONG ADD
									   FROM #TEMP_ROUTE AR 
											INNER JOIN (
														SELECT *
														  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
														 WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
														   AND ACTIVE_FLAG = 'Y'
													   ) SSLV
													ON AR.LINE_ID  = SSLV.SEGMENT2
												   AND AR.SITE_ID = SSLV.SEGMENT1
												   AND AR.BUILDING = SSLV.ATTRIBUTE1										--2019-10-08 PIYONG ADD
											LEFT OUTER JOIN (
																SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
																  FROM SCM_LINE_M
																 WHERE OPERATION_ID IN ( 'F5300','F5500','F5600','F6000')	--2019-05-14 PIYONG ADD 'F5300','F5500','F5600' 
															--	AND ACTIVE_FLAG = 'Y'										--2019-05-14 PIYONG DEL
															) LM
														 ON SSLV.SEGMENT5 = LM.LINE_ID
														AND SSLV.SEGMENT1 = LM.SITE_ID

											---------------------------------------------------------------------------------------------------------------------------------
											--2019-05-14 PIYONG ADD
											LEFT OUTER JOIN (
																SELECT SEGMENT1, SEGMENT2, ATTRIBUTE1, ATTRIBUTE2
																  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																 WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'
																   AND ACTIVE_FLAG = 'Y'
															) SSLV1
														 ON AR.SOURCE_INDEX = SSLV1.SEGMENT1
													    AND AR.LINE_ID = SSLV1.SEGMENT2
											--2019-05-14 PIYONG ADD
											---------------------------------------------------------------------------------------------------------------------------------
											
											---------------------------------------------------------------------------------------------------------------------------------
											--2020-06-17 PIYONG ADD
											LEFT OUTER JOIN #TEMP_AGING_ITEM_FLOW_ACTUAL_TIME TEMP_AR
														 ON AR.SOURCE_INDEX = TEMP_AR.SOURCE_INDEX
														AND AR.BUILDING = TEMP_AR.BUILDING
														AND AR.MODEL_ID = ISNULL( CONVERT( NVARCHAR, TEMP_AR.MODEL_ID ), '')
														AND AR.ROUTE_ID = ISNULL( CONVERT( NVARCHAR, TEMP_AR.ROUTE_ID ), '')
														AND AR.LINE_ID = ISNULL( CONVERT( NVARCHAR, TEMP_AR.LINE_ID ), '')
														AND CONVERT(NUMERIC(18,0), AR.OP_SEQ  ) = TEMP_AR.OP_SEQ 
														AND CONVERT(NUMERIC(18,0), AR.OP_STEP ) = TEMP_AR.OP_STEP
											--2020-06-17 PIYONG ADD END
											---------------------------------------------------------------------------------------------------------------------------------
											
								   ) A
							 INNER JOIN [DBO].[SCM_FACTORY_M] F WITH(NOLOCK)
									 ON A.BUILDING = F.FACTORY_ID
							  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
										   ON MP.LOOKUP_TYPE_CODE  = 'FORMATION_ROUTE_TYPE_MAPPING'
										  AND SEGMENT1 = A.ROUTE_TYPE_CD
							--2018-05-14 PIYONG UPDATE 끝
							 WHERE F.FACTORY_ID IN ( 												 --2019-09-17 PIYONG CHANGE SITE_ID -> PLANT_ID	-- 20202-05-04 PIYONG PLANT_ID -> FACTORY_ID
														SELECT ATTRIBUTE2
														  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
														 WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'
														   AND ACTIVE_FLAG = 'Y'
														   AND SEGMENT1	   = @C_SOURCE_INDEX
														UNION
														SELECT @C_FACTORY_ID
													 
												   )
						   ) A
						   ,(
								SELECT MODEL_ID, 
									   MODEL_LOT_ID,
									   FACTORY_ID			--2018-11-15 PIYONG ADD
								  FROM FP_MODEL_LOT_M
						   ) B
					 WHERE A.MODEL_ID = B.MODEL_LOT_ID
					   AND A.BUILDING = B.FACTORY_ID	--2018-11-15 PIYONG ADD
					   -- AND A.NUM = 1 -- 2021-11-11 kimcd 속도 개선위해 ROW_NUMBER() 조건 제거
						--ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.BUILDING, A.MODEL_ID, A.ROUTE_ID, A.LINE_ID, A.OP_ID, A.OP_STEP
					;
     
					SET @ROWCOUNT = @@ROWCOUNT

					--2019-04-22 PIYONG 기준정보에 맞지 않는 정보 삭제
					DELETE AIF
					  FROM [dbo].[SCM_AGING_ITEM_FLOW_M] AIF
						   , SCM_FACTORY_M F
					 WHERE AIF.COMPANY_ID = F.COMPANY_ID    
					   AND AIF.DIVISION_ID  = F.DIVISION_ID   
					   AND AIF.SITE_ID  = F.SITE_ID       
					   AND AIF.PLANT_ID != F.PLANT_ID        
					   AND AIF.FACTORY_ID  = F.FACTORY_ID
					   AND AIF.FACTORY_ID IN ( (													 --2019-09-17 PIYONG CHANGE SITE_ID -> PLANT_ID	-- 20202-05-04 PIYONG PLANT_ID -> FACTORY_ID
												SELECT ATTRIBUTE2
													FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
													WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'
													AND ACTIVE_FLAG = 'Y'
													AND SEGMENT1	   = @C_SOURCE_INDEX
												UNION
												SELECT @C_FACTORY_ID
												)
											)

/*     
					UPDATE [dbo].[SY_XIF_DW_AGING_ROUTE_R]
					   SET TRANSFER_FLAG = 'Y'
						  ,TRANSFER_DATE = getdate()
					 WHERE TRANSFER_FLAG = 'P'
--					   AND IFSEQNO = @V_IFSEQNO; --PIYONG 2018-07-17 DEL
					;
*/
			/*
			--2018-05-25 PIYONG 수정 사용자 데이터 관리 안함
			-- 차기 용량 Route 정보와 그 Route의 L/T 정보를 update 함.
			IF OBJECT_ID('tempdb..#tempRoute') IS NOT NULL
				DROP TABLE #tempRoute

				-----------------------------------------------------------------------------------------------------------
				--	PIYONG 2017-11-30 복사한 DEFAULT_ROUTE, STANDARD_LT 데이터로 수정 시작

				UPDATE [DBO].[SCM_AGING_ITEM_FLOW_M]
				   SET DEFAULT_ROUTE = B.DEFAULT_ROUTE
					   ,STANDARD_LT = B.STANDARD_LT
					   ,DEFAULT_FLAG = B.DEFAULT_FLAG
				  FROM [DBO].[SCM_AGING_ITEM_FLOW_M] AS A WITH (NOLOCK)
					   INNER JOIN #tempItemFlow AS B
							   ON A.[COMPANY_ID] = B.COMPANY_ID
							  AND A.[DIVISION_ID] = B.DIVISION_ID
							  AND A.[SITE_ID] = B.SITE_ID
							  AND A.[PLANT_ID]	= B.PLANT_ID
							  AND A.[FACTORY_ID] = B.FACTORY_ID
							  AND A.[ITEM_ID] = B.ITEM_ID
							  AND A.[ROUTE_ID] = B.ROUTE_ID
							  AND A.[LINE_ID] = B.LINE_ID
							  AND A.[OPERATION_ID] = B.OPERATION_ID
							  AND A.[OPERATION_SEQ] = B.OPERATION_SEQ
							  AND A.[OPERATION_STEP] = B.OPERATION_STEP
			*/

			-----------------------------------------------------------------------------------------------------------
			-- PIYONG 2018-03-22 용량 ROUTE의 마지막 공정일 경우 PROCESSING_TIME의 값을 0으로 치환 시작
			-----------------------------------------------------------------------------------------------------------
					IF @C_SITE_ID != 'A004'
						BEGIN
							UPDATE A
							   SET --PROCESSING_TIME = 0	--2018-05-25 PIYONG DEL
								   [STANDARD_LT] = 0		--2018-05-25 PIYONG ADD	--2019-07-25 PIYONG CHANGE 폴란드는 1일로 변경 -- 2019-08-08-21 PIYONG CHANGE  CASE WHEN A.SITE_ID = 'A004' THEN 1440 ELSE 0 END -> 0
							  FROM [SCM_AGING_ITEM_FLOW_M] A
								   ,(
										SELECT *
										  FROM (
												SELECT COMPANY_ID
													   , DIVISION_ID
													   , SITE_ID
													   , PLANT_ID
													   , FACTORY_ID
													   , ITEM_ID
													   , ROUTE_ID
													   , LINE_ID
													   , ROUTE_TYPE
													   , OPERATION_ID
													   , OPERATION_SEQ
													   ,ROW_NUMBER() OVER( PARTITION BY PLANT_ID, FACTORY_ID, ITEM_ID, ROUTE_ID, LINE_ID				--	2018-11-06 KIMCD PARTITION BY에 PLANT_ID 추가
																			   ORDER BY OPERATION_SEQ DESC, OPERATION_STEP DESC			) AS NUM	--	2018-05-25 PIYONG OPERATION_STEP DESC ADD
												  FROM [DBO].[SCM_AGING_ITEM_FLOW_M]
												 WHERE DEFAULT_FLAG = 'C'	-- 용량 ROUTE
												   AND PROCESSING_TIME <> 0	--2018-06-19 PIYONG ADD
												   AND PLANT_ID != 'G182'  -- 2018-11-06 KIMCD G182가 아닌 경우만 마지막 공정 0으로 갱신
												   AND FACTORY_ID IN ( (						 --2019-09-17 PIYONG CHANGE SITE_ID -> PLANT_ID	-- 20202-05-04 PIYONG PLANT_ID -> FACTORY_ID
																		SELECT ATTRIBUTE2
																		  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																		 WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'
																		   AND ACTIVE_FLAG = 'Y'
																		   AND SEGMENT1	   = @C_SOURCE_INDEX
																		UNION
																		SELECT @C_FACTORY_ID
																	 )
																   )
											   ) BB
										 WHERE NUM  = 1 
								   ) B
							 WHERE A.COMPANY_ID = B.COMPANY_ID
							   AND A.DIVISION_ID = B.DIVISION_ID
							   AND A.SITE_ID = B.SITE_ID
							   AND A.PLANT_ID = B.PLANT_ID
							   AND A.FACTORY_ID = B.FACTORY_ID
							   AND A.ITEM_ID = B.ITEM_ID
							   AND A.ROUTE_ID = B.ROUTE_ID
							   AND A.LINE_ID = B.LINE_ID
							   AND A.OPERATION_ID = B.OPERATION_ID
							   AND A.OPERATION_SEQ = B.OPERATION_SEQ
   							   AND A.ROUTE_TYPE = B.ROUTE_TYPE
						END
			
					-----------------------------------------------------------------------------------------------------------------------------------------------
					-- 2019-08-20 PIYONG ADD 폴란드 별도
					IF @C_SITE_ID = 'A004'
						BEGIN
							UPDATE A
							   SET [STANDARD_LT] = CASE WHEN A.DEFAULT_FLAG = 'C' THEN
															0								-- 2019-10-07 PIYONG CHANGE 2160 -> 0
														ELSE
															1440
														END
							  FROM [SCM_AGING_ITEM_FLOW_M] A
								   ,(
									  SELECT *
										FROM (
											  SELECT COMPANY_ID
													 , DIVISION_ID
													 , SITE_ID
													 , PLANT_ID
													 , FACTORY_ID
													 , ITEM_ID
													 , ROUTE_ID
													 , LINE_ID
													 , ROUTE_TYPE
													 , OPERATION_ID
													 , OPERATION_SEQ
													 , DEFAULT_FLAG
													 , ROW_NUMBER() OVER( PARTITION BY DEFAULT_FLAG, PLANT_ID, FACTORY_ID, ITEM_ID, ROUTE_ID, LINE_ID
																			  ORDER BY OPERATION_SEQ DESC, OPERATION_STEP DESC							) AS NUM
												FROM [DBO].[SCM_AGING_ITEM_FLOW_M]
											   WHERE SITE_ID = 'A004'--@P_SITE_ID
												 AND PROCESSING_TIME <> 0
												 AND OPERATION_SEQ < 91
											 ) BB
									   WHERE NUM  = 1 
								   ) B
							 WHERE A.COMPANY_ID = B.COMPANY_ID
							   AND A.DIVISION_ID = B.DIVISION_ID
							   AND A.SITE_ID = B.SITE_ID
							   AND A.PLANT_ID = B.PLANT_ID
							   AND A.FACTORY_ID = B.FACTORY_ID
							   AND A.ITEM_ID = B.ITEM_ID
							   AND A.ROUTE_ID = B.ROUTE_ID
							   AND A.LINE_ID = B.LINE_ID
							   AND A.OPERATION_ID = B.OPERATION_ID
							   AND A.OPERATION_SEQ = B.OPERATION_SEQ
   							   AND A.ROUTE_TYPE = B.ROUTE_TYPE
							   AND A.DEFAULT_FLAG = B.DEFAULT_FLAG
						END
					-- 2019-08-20 PIYONG ADD 폴란드 별도
					-----------------------------------------------------------------------------------------------------------------------------------------------

			-----------------------------------------------------------------------------------------------------------
			-- PIYONG 2018-03-22 용량 ROUTE의 마지막 공정일 경우 PROCESSING_TIME의 값을 0으로 치환 끝
			-----------------------------------------------------------------------------------------------------------


				--	PIYONG 2017-11-30 복사한 DEFAULT_ROUTE, STANDARD_LT 데이터로 수정 끝  
				-----------------------------------------------------------------------------------------------------------
/*
				select factory_id, item_id, ROUTE_ID, line_id, route_type,OPERATION_ID, OPERATION_SEQ, PROCESSING_TIME total_time --  sum(PROCESSING_TIME) total_time
					into #tempRoute 
					from (
						select factory_id, item_id, ROUTE_ID, line_id, OPERATION_ID, OPERATION_SEQ, PROCESSING_TIME, ROUTE_TYPE
								,ROW_NUMBER() over ( partition by item_id, ROUTE_ID, line_id   order by OPERATION_SEQ desc ) last_op
							from [dbo].[SCM_AGING_ITEM_FLOW_M] WITH(NOLOCK)
						) w
				where ( ( last_op = 1 and  PROCESSING_TIME < 900000) or last_op <> 1 )
				;

			--	2018.03.08 PIYONG	DEFAULT_FLAG  Y,N -> S, F	--	2018-05-25 주석처리
			SELECT FACTORY_ID, ITEM_ID, ROUTE_ID, LINE_ID, ROUTE_TYPE, OPERATION_ID, OPERATION_SEQ, DEFAULT_ROUTE --2018-03-22 PIYONG  DEFAULT_ROUTE ADD
				   ,CASE WHEN DEFAULT_FLAG = 'B' AND PROCESSING_TIME > 5760 THEN
							5760
						 WHEN DEFAULT_FLAG = 'C' AND PROCESSING_TIME > 14400 THEN
							14400
						 ELSE
							PROCESSING_TIME
						 END AS total_time
			 INTO #tempRoute
			 FROM [DBO].[SCM_AGING_ITEM_FLOW_M]
*/
			--select * into [dbo].[SCM_AGING_ITEM_FLOW_M_BK] from [dbo].[SCM_AGING_ITEM_FLOW_M]
					UPDATE [DBO].[SCM_AGING_ITEM_FLOW_M]
					   SET NEXT_ROUTE_ID = B.NEXT_ROUTE_ID
					  --   ,ROUTE_TOTAL_TIME = B.NEXT_STEP_TIME		--2019-04-08 PIYONG DEL
					  FROM [DBO].[SCM_AGING_ITEM_FLOW_M] AS A WITH (NOLOCK)
						   INNER JOIN (
										SELECT FACTORY_ID
												,X.ITEM_ID
												,X.ROUTE_ID
												,X.LINE_ID
												,X.ROUTE_TYPE
												,CASE WHEN x.ROUTE_TYPE IN (SELECT SEGMENT1		--2018-05-25 PIYONG look up으로 변경
																			  FROM SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																			 WHERE MP.LOOKUP_TYPE_CODE  = 'FORMATION_ROUTE_TYPE_MAPPING'
																			   AND ATTRIBUTE2 = 'B') THEN (
																											SELECT TOP 1 [ROUTE_ID]					--2018-03-22 PIYONG MAX([ROUTE_ID]) -> TOP 1 [ROUTE_ID]
																												FROM [SCM_AGING_ITEM_FLOW_M] w		--2018-05-25 PIYONG tempRoute -> [SCM_AGING_ITEM_FLOW_M] 변경
																												WHERE w.ITEM_ID    = x.ITEM_ID
																												AND w.LINE_ID    = x.line_id
																												AND w.FACTORY_ID = x.FACTORY_ID
																												AND w.ROUTE_ID   <> x.ROUTE_ID
																												AND w.ROUTE_TYPE  = 'C'
																												ORDER BY DEFAULT_ROUTE  DESC, ROUTE_ID DESC --2018-03-22 PIYONG  ORDER BY ADD
																											)
													  ELSE NULL END NEXT_ROUTE_ID
											/*	--2019-04-08 PIYONG DEL
											,CASE WHEN X.ROUTE_TYPE IN (SELECT SEGMENT1		--2018-05-25 PIYONG LOOK UP으로 변경
																		  FROM SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																		 WHERE MP.LOOKUP_TYPE_CODE  = 'FORMATION_ROUTE_TYPE_MAPPING'
																		   AND ATTRIBUTE2 = 'B') THEN (
																										SELECT SUM(W.STANDARD_LT)				--2018-05-25 PIYONG TOTAL_TIME -> STANDARD_LT으로 변경
																										  FROM [SCM_AGING_ITEM_FLOW_M] W		--2018-05-25 PIYONG TEMPROUTE -> [SCM_AGING_ITEM_FLOW_M] 으로 변경
																										 WHERE W.ITEM_ID    = X.ITEM_ID
																										   AND W.LINE_ID    = X.LINE_ID
																										   AND W.FACTORY_ID = X.FACTORY_ID
																										   AND W.ROUTE_ID   <> X.ROUTE_ID
																										   AND W.ROUTE_TYPE  = 'C'
																										-- 2018-03-22 KIMCD 복수 ROUTE의 LEAD TIME 합산되는 것을 막기 위해 ROUTE_ID 조건 추가 시작
																										   AND W.ROUTE_ID =  ( SELECT TOP 1 [ROUTE_ID]				--2018-03-22 PIYONG MAX([ROUTE_ID]) -> TOP 1 [ROUTE_ID]
																																	FROM [SCM_AGING_ITEM_FLOW_M] Y		--2018-05-25 PIYONG TEMPROUTE -> [SCM_AGING_ITEM_FLOW_M] 변경
																																WHERE Y.ITEM_ID    = X.ITEM_ID
																																	AND Y.LINE_ID    = X.LINE_ID
																																	AND Y.FACTORY_ID = X.FACTORY_ID
																																	AND Y.ROUTE_ID   <> X.ROUTE_ID
																																	AND Y.ROUTE_TYPE  = 'C'
																																ORDER BY DEFAULT_ROUTE  DESC, ROUTE_ID DESC --2018-03-22 PIYONG  ORDER BY ADD
																																)
																										-- 2018-03-22 KIMCD 복수 ROUTE의 LEAD TIME 합산되는 것을 막기 위해 ROUTE_ID 조건 추가 종료
																										)
													ELSE NULL END NEXT_STEP_TIME
											*/
										  FROM [SCM_AGING_ITEM_FLOW_M] X WITH (NOLOCK)		--2018-05-25 PIYONG TEMPROUTE -> [SCM_AGING_ITEM_FLOW_M] 변경
										 WHERE FACTORY_ID IN ( (							 --2019-09-17 PIYONG CHANGE SITE_ID -> PLANT_ID	-- 20202-05-04 PIYONG PLANT_ID -> FACTORY_ID
																SELECT ATTRIBUTE2
																	FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																	WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'
																	AND ACTIVE_FLAG = 'Y'
																	AND SEGMENT1	   = @C_SOURCE_INDEX
																UNION
																SELECT @C_FACTORY_ID
																)
															)
										 AND	x.ROUTE_TYPE IN (SELECT SEGMENT1		--2018-05-25 PIYONG look up으로 변경
																 FROM SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																 WHERE MP.LOOKUP_TYPE_CODE  = 'FORMATION_ROUTE_TYPE_MAPPING'
																 AND ATTRIBUTE2 = 'B')  -- 2020-07-09 kimcd 미리 갱신될 대상만 추출
										 GROUP BY FACTORY_ID
											   ,X.ITEM_ID
											   ,X.ROUTE_ID
											   ,X.LINE_ID
											   ,X.ROUTE_TYPE
									  ) AS B 
								   ON A.ROUTE_ID = B.ROUTE_ID
								  AND A.ITEM_ID = B.ITEM_ID
								  AND A.LINE_ID = B.LINE_ID
								  AND A.FACTORY_ID = B.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
					;


					-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
					--2019-04-08 PIYONG  속도개선을 위한 분리
					UPDATE [DBO].[SCM_AGING_ITEM_FLOW_M]
					   SET ROUTE_TOTAL_TIME = B.NEXT_STEP_TIME
					  FROM [DBO].[SCM_AGING_ITEM_FLOW_M] AS A WITH (NOLOCK)
						   INNER JOIN (
										SELECT FACTORY_ID
												,X.ITEM_ID
												,X.ROUTE_ID
												,X.LINE_ID
												,X.ROUTE_TYPE
												,CASE WHEN X.ROUTE_TYPE IN (
																			SELECT SEGMENT1
																			  FROM SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																			 WHERE MP.LOOKUP_TYPE_CODE  = 'FORMATION_ROUTE_TYPE_MAPPING'
																			   AND ATTRIBUTE2 = 'B') THEN (
																											SELECT SUM(W.STANDARD_LT)
																											  FROM [SCM_AGING_ITEM_FLOW_M] W
																											 WHERE W.ITEM_ID    = X.ITEM_ID
																											   AND W.LINE_ID    = X.LINE_ID
																											   AND W.FACTORY_ID = X.FACTORY_ID
																											   AND W.ROUTE_ID   <> X.ROUTE_ID
																											   AND W.ROUTE_TYPE  = 'C'
																											   AND W.ROUTE_ID = MAX(X.NEXT_ROUTE_ID)  -- 2020-07-09 kimcd 미리 찾아 놓은 next route id 사용
																											                    /* (
																																   SELECT TOP 1 [ROUTE_ID]
																																	 FROM [SCM_AGING_ITEM_FLOW_M] Y
																																	WHERE Y.ITEM_ID    = X.ITEM_ID
																																	  AND Y.LINE_ID    = X.LINE_ID
																																	  AND Y.FACTORY_ID = X.FACTORY_ID
																																	  AND Y.ROUTE_ID   <> X.ROUTE_ID
																																	  AND Y.ROUTE_TYPE  = 'C'
																																	ORDER BY DEFAULT_ROUTE  DESC, ROUTE_ID DESC
																																	
																																) */
																											)
													  ELSE NULL END NEXT_STEP_TIME
										  FROM [SCM_AGING_ITEM_FLOW_M] X WITH (NOLOCK)
										 WHERE FACTORY_ID IN ( (										 --2019-09-17 PIYONG CHANGE SITE_ID -> PLANT_ID	-- 20202-05-04 PIYONG PLANT_ID -> FACTORY_ID
																SELECT ATTRIBUTE2
																	FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																	WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'
																	AND ACTIVE_FLAG = 'Y'
																	AND SEGMENT1	   = @C_SOURCE_INDEX
																UNION
																SELECT @C_FACTORY_ID
																)
															)
										   AND X.NEXT_ROUTE_ID IS NOT NULL -- 2020-07-09 kimcd 갱신할 다음 Route가 존재하는 경우만 갱신
										 GROUP BY FACTORY_ID
											   ,X.ITEM_ID
											   ,X.ROUTE_ID
											   ,X.LINE_ID
											   ,X.ROUTE_TYPE
									  ) AS B 
								   ON A.ROUTE_ID = B.ROUTE_ID
								  AND A.ITEM_ID = B.ITEM_ID
								  AND A.LINE_ID = B.LINE_ID
								  AND A.FACTORY_ID = B.FACTORY_ID
					;
					--2019-04-08 PIYONG  속도개선을 위한 분리
					-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
					


					----------------------------------------------------------------------------------------------------------------------------------------------------
					--2018-08-13 PIYONG ADD
					UPDATE X
					   SET REMAIN_TIME = ( SELECT SUM([STANDARD_LT]) 
											 FROM [dbo].[SCM_AGING_ITEM_FLOW_M] A
											WHERE A.SITE_ID = X.SITE_ID
											  AND A.ITEM_ID = X.ITEM_ID
											  AND A.LINE_ID = X.LINE_ID
											  AND A.FACTORY_ID = X.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
											  AND A.ROUTE_ID = X.ROUTE_ID
											  AND (
													( OPERATION_SEQ = X.OPERATION_SEQ  AND OPERATION_STEP >= X.OPERATION_STEP )
													OR ( OPERATION_SEQ > X.OPERATION_SEQ )
												  )
											GROUP BY A.ITEM_ID
													,A.ROUTE_ID
													,A.LINE_ID 
											) 
					  FROM [DBO].[SCM_AGING_ITEM_FLOW_M] AS X WITH (NOLOCK)
					 WHERE FACTORY_ID IN ( (													 --2019-09-17 PIYONG CHANGE SITE_ID -> PLANT_ID	-- 20202-05-04 PIYONG PLANT_ID -> FACTORY_ID
											SELECT ATTRIBUTE2
												FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
												WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'
												AND ACTIVE_FLAG = 'Y'
												AND SEGMENT1	   = @C_SOURCE_INDEX
											UNION
											SELECT @C_FACTORY_ID
											)
										)
					;
			--2018-08-13 PIYONG ADD
			----------------------------------------------------------------------------------------------------------------------------------------------------


			--2018-06-19 PIYONG ADD ----------------------------------------------------------------------------------------------------------------------------
			--N2.1 OCV2까지 총 L/T
					DECLARE CUR_OCV2_B CURSOR FOR
						SELECT A.SITE_ID, A.ITEM_ID, A.ROUTE_ID, A.NEXT_ROUTE_ID, A.LINE_ID, A.OPERATION_ID, A.OPERATION_SEQ, A.OPERATION_STEP, A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
						  FROM [dbo].[SCM_AGING_ITEM_FLOW_M] A
						 WHERE A.FACTORY_ID IN ( (										 --2019-09-17 PIYONG CHANGE SITE_ID -> PLANT_ID	-- 20202-05-04 PIYONG PLANT_ID -> FACTORY_ID
													SELECT ATTRIBUTE2
														FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
														WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'
														AND ACTIVE_FLAG = 'Y'
														AND SEGMENT1	   = @C_SOURCE_INDEX
													UNION
													SELECT @C_FACTORY_ID
													)
												)
						   AND A.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_FCS_SHIPPING_TERM_M )
						   AND A.DEFAULT_FLAG = 'B'
						 ORDER BY A.ROUTE_ID, A.ITEM_ID,  A.NEXT_ROUTE_ID, A.LINE_ID, A.OPERATION_SEQ, A.OPERATION_STEP

					DECLARE CUR_OCV2_C CURSOR FOR
						SELECT A.SITE_ID, A.ITEM_ID, A.ROUTE_ID, A.LINE_ID, A.OPERATION_ID, A.OPERATION_SEQ, A.OPERATION_STEP, A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
						  FROM [dbo].[SCM_AGING_ITEM_FLOW_M] A
						 WHERE A.FACTORY_ID IN ( (													 --2019-09-17 PIYONG CHANGE SITE_ID -> PLANT_ID	-- 20202-05-04 PIYONG PLANT_ID -> FACTORY_ID
													SELECT ATTRIBUTE2
														FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
														WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'
														AND ACTIVE_FLAG = 'Y'
														AND SEGMENT1	   = @C_SOURCE_INDEX
													UNION
													SELECT @C_FACTORY_ID
												 )
											  )
						   AND A.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_FCS_SHIPPING_TERM_M )
						   AND A.DEFAULT_FLAG = 'C'
						   AND A.OPERATION_SEQ <= (
													SELECT OPERATION_SEQ
													  FROM [dbo].[SCM_AGING_ITEM_FLOW_M] C
													 WHERE C.ROUTE_ID = A.ROUTE_ID
													   AND C.ITEm_ID = A.ITEM_ID
													   AND C.DEFAULT_FLAG = 'C'
												       AND C.OPERATION_ID = N'812'			--2018-09-27 PIYONG ADD
							   						   AND C.OPERATION_SEQ > 0				--2018-09-27 PIYONG ADD
													--   AND C.OPERATION_NAME = N'OCV #02'	--2018-09-27 PIYONG DEL
													   AND C.FACTORY_ID = A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
												  )
						ORDER BY A.ROUTE_ID, A.ITEM_ID, A.LINE_ID, A.OPERATION_SEQ, A.OPERATION_STEP


					OPEN CUR_OCV2_B;
					FETCH NEXT FROM CUR_OCV2_B INTO @SITE_ID
													,@ITEM_ID
													,@ROUTE_ID
													,@NEXT_ROUTE_ID
													,@LINE_ID
													,@OPERATION_ID
													,@OPERATION_SEQ
													,@OPERATION_STEP
													,@FACTORY_ID  -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해

					WHILE (@@FETCH_STATUS = 0)
						BEGIN
					--기본 ROUTE
							UPDATE [DBO].[SCM_AGING_ITEM_FLOW_M]
							   SET OCV2_TOTAL_TIME = (
													  SELECT SUM([STANDARD_LT]) +
															 (
															  SELECT SUM([STANDARD_LT]) 
																FROM [dbo].[SCM_AGING_ITEM_FLOW_M] B
															   WHERE B.ROUTE_ID = A.NEXT_ROUTE_ID
																 AND B.ITEM_ID = A.ITEM_ID
																 AND B.LINE_ID = A.LINE_ID
																 AND B.FACTORY_ID = A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
																 AND B.DEFAULT_FLAG = 'C'
																 AND B.OPERATION_SEQ <= (
																						 SELECT OPERATION_SEQ
																						   FROM [dbo].[SCM_AGING_ITEM_FLOW_M] C
																						  WHERE C.ROUTE_ID = A.NEXT_ROUTE_ID
																							AND C.ITEM_ID = A.ITEM_ID
																							AND C.LINE_ID = A.LINE_ID
																							AND C.FACTORY_ID = A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
																							AND C.DEFAULT_FLAG = 'C'
																							AND C.OPERATION_ID = N'812'			--2018-09-27 PIYONG ADD
																						    AND C.OPERATION_SEQ > 0				--2018-09-27 PIYONG ADD
																						--  AND C.OPERATION_NAME = N'OCV #02'	--2018-09-27 PIYONG DEL
																						)
															 ) + (SELECT ATTRIBUTE1 * 24 * 60
																	FROM SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
																   WHERE LOOKUP_TYPE_CODE  = 'FORMATION_SHIP_EOH_EXCEPT'
																	 AND SEGMENT2 = 'AGING'
																	 AND SEGMENT4 = @ITEM_ID )
														FROM [dbo].[SCM_AGING_ITEM_FLOW_M] A
													   WHERE A.SITE_ID = @SITE_ID
														 AND A.ITEM_ID = @ITEM_ID
														 AND A.LINE_ID = @LINE_ID
														 AND A.DEFAULT_FLAG = 'B'
														 AND ROUTE_ID = @ROUTE_ID
														 AND A.FACTORY_ID = @FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
														 AND (
																( OPERATION_SEQ = @OPERATION_SEQ  AND OPERATION_STEP >= @OPERATION_STEP )
																OR ( OPERATION_SEQ > @OPERATION_SEQ )
															 )
													   GROUP BY A.ITEM_ID
															 , A.ROUTE_ID
															 , A.NEXT_ROUTE_ID
															 , A.LINE_ID
															 , A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
													 )
								WHERE ROUTE_ID = @ROUTE_ID
								   AND NEXT_ROUTE_ID = @NEXT_ROUTE_ID
								   AND OPERATION_ID = @OPERATION_ID
								   AND OPERATION_SEQ = @OPERATION_SEQ
								   AND OPERATION_STEP = @OPERATION_STEP
								   AND LINE_ID = @LINE_ID
								   AND ITEM_ID = @ITEM_ID
								   AND FACTORY_ID = @FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해

							FETCH NEXT FROM CUR_OCV2_B INTO @SITE_ID
															,@ITEM_ID
															,@ROUTE_ID
															,@NEXT_ROUTE_ID
															,@LINE_ID
															,@OPERATION_ID
															,@OPERATION_SEQ
															,@OPERATION_STEP
															,@FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해

						  END;

					CLOSE CUR_OCV2_B;
					DEALLOCATE CUR_OCV2_B; 


					--용량 ROUTE
					OPEN CUR_OCV2_C;
					FETCH NEXT FROM CUR_OCV2_C INTO @SITE_ID
													,@ITEM_ID
													,@ROUTE_ID
													,@LINE_ID
													,@OPERATION_ID
													,@OPERATION_SEQ
													,@OPERATION_STEP
													,@FACTORY_ID  -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해

					WHILE (@@FETCH_STATUS = 0)
						BEGIN

							UPDATE [DBO].[SCM_AGING_ITEM_FLOW_M]
							   SET OCV2_TOTAL_TIME = (
													  SELECT SUM([STANDARD_LT]) + (
																				   SELECT ATTRIBUTE1 * 24 * 60
																					 FROM SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
																					WHERE LOOKUP_TYPE_CODE  = 'FORMATION_SHIP_EOH_EXCEPT'
																					  AND SEGMENT2 = 'AGING'
																					  AND SEGMENT4 = @ITEM_ID
																				  )
														FROM [dbo].[SCM_AGING_ITEM_FLOW_M] A
													   WHERE A.SITE_ID = @SITE_ID
														 AND A.ITEM_ID = @ITEM_ID
														 AND A.LINE_ID = @LINE_ID
														 AND A.DEFAULT_FLAG = 'C'
														 AND ROUTE_ID = @ROUTE_ID
														 AND A.FACTORY_ID = @FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
														 AND (
																( OPERATION_SEQ = @OPERATION_SEQ  AND OPERATION_STEP >= @OPERATION_STEP )
																OR ( OPERATION_SEQ > @OPERATION_SEQ )
															 )
														 AND OPERATION_SEQ <= (
																				SELECT OPERATION_SEQ
																				  FROM [dbo].[SCM_AGING_ITEM_FLOW_M] C
																				 WHERE C.ROUTE_ID = A.ROUTE_ID
																				   AND C.ITEm_ID = A.ITEM_ID
																				   AND C.LINE_ID = A.LINE_ID
																				   AND C.DEFAULT_FLAG = 'C'
																				   AND C.OPERATION_ID = N'812'			--2018-09-27 PIYONG ADD
														   						   AND C.OPERATION_SEQ > 0				--2018-09-27 PIYONG ADD
																				-- AND C.OPERATION_NAME = N'OCV #02'	--2018-09-27 PIYONG DEL
																				   AND C.FACTORY_ID = A.FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해
																			  )
													   GROUP BY A.ITEM_ID
															 , A.ROUTE_ID
															 , A.LINE_ID
													 )
								WHERE ROUTE_ID = @ROUTE_ID
								  AND OPERATION_ID = @OPERATION_ID
								  AND OPERATION_SEQ = @OPERATION_SEQ
								  AND OPERATION_STEP = @OPERATION_STEP
								  AND LINE_ID = @LINE_ID
								  AND ITEM_ID = @ITEM_ID
								  AND FACTORY_ID = @FACTORY_ID -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해

							FETCH NEXT FROM CUR_OCV2_C INTO @SITE_ID
															,@ITEM_ID
															,@ROUTE_ID
															,@LINE_ID
															,@OPERATION_ID
															,@OPERATION_SEQ
															,@OPERATION_STEP
															,@FACTORY_ID  -- 2018-12-26 kimcd 갱신 조건 추가 - index 사용하기 위해

						  END;

					CLOSE CUR_OCV2_C;
					DEALLOCATE CUR_OCV2_C; 

					COMMIT TRAN
			--2018-06-19 PIYONG ADD ----------------------------------------------------------------------------------------------------------------------------
					FETCH NEXT FROM CUR INTO @C_SITE_ID
											 , @C_FACTORY_ID
											 , @C_SOURCE_INDEX
					;

				END;

			CLOSE CUR;
			DEALLOCATE CUR;  
--			END;
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
