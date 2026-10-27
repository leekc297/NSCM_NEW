
CREATE   PROCEDURE [dbo].[PR_XIF_DW_YIELD_R_20260611]

-- ================================================================================================
-- Program ID          : FP00973
-- Program Name        : PR_XIF_DW_YIELD_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : DW
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_YIELD_R
-- Destination Table   : SCM_YIELD_M
--
-- Create Date		   : 2018.01.12
-- Update Date		   : 2018.03.09 1.1  PIYONG
--						 2018.06.28 2.0  PIYONG
--						 2018.07.17 2.1  PIYONG
--						 2018.08.24 3.0  PIYONG
--						 2018.11.15 3.1  PIYONG
--						 2018.12.04 3.2  PIYONG
--						 2019.01.21 3.3  PIYONG
--						 2019.02.13 3.4  PIYONG
--                       2019.03.31 3.5  KIMCD
--						 2019.04.16 3.6  PIYONG
--						 2019.04.24 3.7  PIYONG
--						 2019.06.18 3.8  PIYONG
--						 2019.09.26 4.0  PIYONG
--						 2019.11.05 4.1	 PIYONG
--						 2019.11.14 4.2	 PIYONG
--                       2021.02.17 4.3  kimcd
--                       2021.04.30 4.4  kimcd
--                       2021.07.21 4.5  kimcd

-- Author              : piyong
-- Version             : 1.0
--						 1.1 [SCM_EQUIPMENT_M] 조인 추가
--						 2.0 SCM_YIELD_M INNER JOIN 하면 신규 ITEM은 추가가 안돼 삭제
--						     SCM_EQUIPMENT_M 대신 FORMATION_LINE_MAPPING LOOK UP, SCM_LINE_M 조인 으로 변경
--						 2.1 조건에서 IFSEQNO 제거
--						 3.0 활성화 공정별 수율 추가
--						 3.1 수욜테이블에 활성화 후공정(F7000, F7100, F7200, F7300) 추가 수집 (장현석선임 요청)
--						 3.2 CUR_FORMATION_TOTAL_YIELD 수율 로직 변경
--							 남경의 경우 원각의 경우 활성화2의 수율이 없어서 항상 1이 나와 각 공정별 값이 0일 경우 1처리
--						 3.3 CUR_FORMATION_TOTAL_YIELD 수율 로직 변경 MONTH 컬럼 삭제
--							 SCM_FORMATION_YIELD_M 테이블에 MONTH 컬럼 삭제
--						 3.4 [SCM_FORMATION_YIELD_M] 조건에 UPDATE_ID 제거	
--                       3.5 2019-03-31 kimcd SCM_YIELD_M Merge 문장 오류 수정
--						 3.6 SCM_YIELD_M 정보 생성시 PLANT = G182 제외
--						 3.7 SCM_YIELD_M 정보 생성 공정 추가
--						 3.8 RESULT_YIELD 정보 생성 추가
--						 4.0 수율 생성 기준 테이블 변경 [SY_XIF_DW_YIELD_R] -> [SY_XIF_DW_YIELD_H]
--							 -- DW에서 수신받은 수율 기준 데이터(SY_XIF_DW_YIELD_R)를 중복제거 하여 [SY_XIF_DW_YIELD_H] 쌓는다.
--							 -- 최종 생산 일자에서 폴란드는 30건 타 사이트는 90건수를 SUM하여 수율 생성
--							 -- 15건이 되지 않는 데이터는 제외 
--						 4.1 정인천 책임 요청으로 투입수량이 0보다 큰경우에만 적용
--						 4.2 정인천 책임 요청으로 투입수량이 양품보다 큰경우에만 적용
--                       2020-11-05 kimcd 수율 2자리 Round 처리에서 4자리로 변경
--                       4.3 2021-02-17 kimcd 기준 정보 Master용 실적 수율 정보 갱신
--                                      DW 공정 연결 로직 수정
--                                      F4800	특성 측정(EOL) -> F6000 자동차
--										F5100	Grading/외관 -> F5100 - 남경 초소형, F6000 - 오창 초소형
--                                      F5300DW	Charateristic/Grading (Cylindrical/Prismatic) -> F5300 - 남경 소형, F6000 - 오창 소형
--                                      F7000DW	Grading+DSF+TCO  -> F5500 - 남경 소형 파우치, F6000 - 오창 소형
--                                      F7200DW	Taping           -> F7200 - 남경 소형 파우치 2D
--                       4.4 2021-04-30 kimcd 갱신범위 내 일자 정보가 수정 안 될 경우 삭제
--                                            전월 실적 수율 갱신 전 실적 수율 값 초기화
--                       4.5 2021-07-21 kimcd 전월 실적 수율 갱신을 5일 이후 계속하도록 수정
--                       4.6 2022-08-31 leeseongmin 활성화 DATA 삭제로직 수정 (CSR : C20220831-000137)	
--                       4.7 2024-03-06 kimcd  WA.FP로 전월 실적 수율 전송 과정 추가
-- ================================================================================================
-- PARAMETER
@P_SITE_ID	NVARCHAR(30) = 'A001'
,@P_BASIS_START_TIME NVARCHAR(6) = '060000'
,@P_SEARCH_TERM NVARCHAR(6) = '90'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_YIELD_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)


	--변수
	DECLARE @P_IFSEQNO     NVARCHAR(50)
	DECLARE @COMPANY_ID     NVARCHAR(30)
	DECLARE @DIVISION_ID    NVARCHAR(30)
	DECLARE @SITE_ID		NVARCHAR(30)
	DECLARE @PLANT_ID		NVARCHAR(30)
	DECLARE @FACTORY_ID		NVARCHAR(30)
	DECLARE @OPERATION_ID	NVARCHAR(30)
	DECLARE @LINE_ID		NVARCHAR(30)
	DECLARE @ITEM_ID		NVARCHAR(150)
	DECLARE @MONTH			NVARCHAR(6)
	DECLARE @YIELD			NUMERIC(18,6)

	DECLARE @FORMATION1_YIELD			NUMERIC(18,6)	--2018-08-24 add
	DECLARE @DEGAS_YIELD				NUMERIC(18,6)	--2018-08-24 add
	DECLARE @FORMATION2_YIELD			NUMERIC(18,6)	--2018-08-24 add
	DECLARE @GRADE_YIELD				NUMERIC(18,6)	--2018-08-24 add
	DECLARE @CHARACTERIZATION_YIELD		NUMERIC(18,6)	--2018-08-24 add
	DECLARE @FORMATION_TOTAL_YIELD		NUMERIC(18,6)	--2018-08-24 add


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
		  /*				 --PIYONG 2018-07-17 DEL
			SET @P_IFSEQNO = (
								SELECT MAX(IFSEQNO)
								  FROM [dbo].[SY_XIF_DW_YIELD_R]
								 WHERE TRANSFER_FLAG = 'N'
							 )
			*/

			UPDATE x
			   SET x.TRANSFER_FLAG = 'P'
			  from [dbo].[SY_XIF_DW_YIELD_R] as x
			       JOIN scm_factory_m as y with(nolock)
				   on x.factory_id = y.factory_id
			 WHERE 1=1 --IFSEQNO       = @P_IFSEQNO 				 --PIYONG 2018-07-17 DEL
			   AND x.TRANSFER_FLAG = 'N'
			   AND y.PLANT_ID IN (								SELECT SEGMENT1 AS plantId
								  FROM DBO.SCM_SYS_LOOKUP_VALUE
								 WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
								   AND ACTIVE_FLAG = 'Y'
								   AND SEGMENT2 = @P_BASIS_START_TIME
							   )


			--------------------------------------------------------------------------------------------
			--	2019-09-26 PIYONG ADD			
			MERGE INTO [SY_XIF_DW_YIELD_H] H
			USING (
					SELECT [PLANT_ID]
						   ,[FACTORY_ID]
						   ,[LINE_ID]
						   ,[PROCID]
						   ,[ITEM_ID]
						   ,[MONTH_CODE]
						   ,[FCS_INPUT]
						   ,[FCS_GOOD]
					  FROM (
							SELECT  y.[PLANT_ID]
								   ,x.[FACTORY_ID]
								   ,x.[LINE_ID]
								   ,x.[PROCID]
								   ,x.[ITEM_ID]
								   ,x.[MONTH_CODE]
								   ,x.[FCS_INPUT]
								   ,x.[FCS_GOOD]
								   ,ROW_NUMBER() OVER ( PARTITION BY y.[PLANT_ID], x.[FACTORY_ID], x.[LINE_ID], x.[PROCID], x.[ITEM_ID], x.[MONTH_CODE]
															ORDER BY x.[IFSEQNO] DESC ) AS NUM
							  FROM [SY_XIF_DW_YIELD_R] as x
								   JOIN scm_factory_m as y with(nolock)
								   on x.factory_id = y.factory_id
							 WHERE x.TRANSFER_FLAG = 'P'
							  -- 2021-02-17 kimcd  DW와 수율 산출 로직 동기화하기 위해 조건 막음 AND FCS_INPUT > 0 --(FCS_INPUT > 0 OR FCS_GOOD > 0)		--2019-11-05 정인천 책임요청으로 투입 수량이 0보다 큰거만
						   ) A
					 WHERE NUM = 1
				  ) R
			   ON (
						H.BASE_YMD		= R.[MONTH_CODE]
					AND H.PLANT_ID		= R.PLANT_ID
					AND H.[FACTORY_ID]	= R.[FACTORY_ID]
					AND H.[LINE_ID]		= R.[LINE_ID]
					AND H.[PROCID]		= R.[PROCID]
					AND H.[ITEM_ID]		= R.[ITEM_ID]
				  )
			 WHEN MATCHED THEN
				UPDATE
			       SET H.INPUT_QTY			= R.[FCS_INPUT]
				       ,H.GOOD_QTY			= R.[FCS_GOOD]
   				       ,[MODIFY_USER_ID]	= 'PR_XIF_DW_YIELD_R'
				       ,[MODIFY_DATE]		= GETDATE()
			 WHEN NOT MATCHED THEN
				INSERT (
					[PLANT_ID]
				    ,[FACTORY_ID]
				    ,[LINE_ID]
				    ,[PROCID]
				    ,[ITEM_ID]
				    ,[BASE_YMD]
				    ,[INPUT_QTY]
				    ,[GOOD_QTY]
			        ,[CREATE_USER_ID]
				    ,[CREATE_DATE]
				    ,[MODIFY_USER_ID]
				    ,[MODIFY_DATE]
				) VALUES (
					[PLANT_ID]
					,[FACTORY_ID]
					,[LINE_ID]
					,[PROCID]
					,[ITEM_ID]
					,[MONTH_CODE]
					,[FCS_INPUT]
					,[FCS_GOOD]
					,'PR_XIF_DW_YIELD_R'
					,GETDATE()
					,'PR_XIF_DW_YIELD_R'
					,GETDATE()
				)
			;

	---------------- START 2022-08-31 leeseongmin 활성화 DATA 삭제로직 수정 (CSR : C20220831-000137) ---------------
		
	IF EXISTS
    --전월 여부 조건 & F 대상
          ( SELECT TOP 1 x.[BASE_YMD]	
		           FROM [SY_XIF_DW_YIELD_H] as x
			       WHERE x.PLANT_ID IN (
						SELECT SLV.SEGMENT1 AS PLANT_ID
						FROM SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
							, SCM_PLANT_M          P   (NOLOCK)
						WHERE P.PLANT_ID = SLV.SEGMENT1
						AND SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
						AND SLV.ACTIVE_FLAG = 'Y'
						AND SLV.SEGMENT2 = @P_BASIS_START_TIME
						AND P.SITE_ID = @P_SITE_ID
						)
			AND x.PROCID     LIKE 'F%'	
			AND x.BASE_YMD   >= CONVERT(NVARCHAR(10), DATEADD(m,-1, DATEADD(d,-day(GETDATE())+1,GETDATE())), 112)  --전월1일보다크고
			AND x.BASE_YMD   < CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 112)   --당월1일보다작다
			AND x.MODIFY_DATE > CONVERT(DATE, GETDATE())
			)

        BEGIN
			--전월데이터가 있으면 전월과 이번달까지삭제
			DELETE X
                   FROM [SY_XIF_DW_YIELD_H] X
			WHERE x.PLANT_ID IN (
						SELECT SLV.SEGMENT1 AS PLANT_ID
						FROM SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
							, SCM_PLANT_M          P   (NOLOCK)
						WHERE P.PLANT_ID = SLV.SEGMENT1
						AND SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
						AND SLV.ACTIVE_FLAG = 'Y'
						AND SLV.SEGMENT2 = @P_BASIS_START_TIME
						AND P.SITE_ID = @P_SITE_ID
						)
			AND x.PROCID   LIKE 'F%'
			AND x.BASE_YMD   >= CONVERT(NVARCHAR(10), DATEADD(m,-1, DATEADD(d,-day(GETDATE())+1,GETDATE())), 112)
			AND x.MODIFY_DATE < CONVERT(DATE, GETDATE())  -- 2021-04-30 갱신 범위 안에 존재하나 갱신 안 되는 경우 삭제
           END
       ELSE
	      BEGIN
			DELETE X
                   FROM [SY_XIF_DW_YIELD_H] X
			WHERE x.PLANT_ID IN (
						SELECT SLV.SEGMENT1 AS PLANT_ID
						FROM SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
							, SCM_PLANT_M          P   (NOLOCK)
						WHERE P.PLANT_ID = SLV.SEGMENT1
						AND SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
						AND SLV.ACTIVE_FLAG = 'Y'
						AND SLV.SEGMENT2 = @P_BASIS_START_TIME
						AND P.SITE_ID = @P_SITE_ID
						)
			AND x.PROCID   LIKE 'F%'
			AND x.BASE_YMD   >= CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 112)
			AND x.MODIFY_DATE < CONVERT(DATE, GETDATE())  -- 2021-04-30 갱신 범위 안에 존재하나 갱신 안 되는 경우 삭제
          END

       ---------------- END 2022-08-31 leeseongmin 활성화 DATA 삭제로직 수정 (CSR : C20220831-000137) ---------------

			-- 기준일자 6개월 전 데이터 추출
			SELECT AA.BASE_YMD
				   , AA.PLANT_ID
				   , AA.FACTORY_ID
				   , AA.LINE_ID
				   , AA.PROCID
				   , AA.ITEM_ID
				   , AA.GOOD_QTY
				   , AA.INPUT_QTY
				   , ROW_NUMBER() OVER(PARTITION BY AA.PLANT_ID, AA.FACTORY_ID, AA.LINE_ID, AA.ITEM_ID, AA.PROCID
										   ORDER BY AA.PLANT_ID, AA.FACTORY_ID, AA.LINE_ID, AA.ITEM_ID, AA.PROCID, AA.BASE_YMD DESC		 ) AS R_CNT
			  INTO #TEMP_TABLE
			  FROM (
					SELECT BASE_YMD
							,R.PLANT_ID
							,R.FACTORY_ID
							,R.ITEM_ID
							,R.PROCID
							,R.LINE_ID
							,R.GOOD_QTY
							,R.INPUT_QTY
						FROM [dbo].[SY_XIF_DW_YIELD_H] AS R
						WHERE r.PLANT_ID IN (
											SELECT SEGMENT1 AS PLANT_ID
												FROM DBO.SCM_SYS_LOOKUP_VALUE
												WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
												AND ACTIVE_FLAG = 'Y'
												AND SEGMENT2 = @P_BASIS_START_TIME
											)
					    AND r.INPUT_QTY >= r.GOOD_QTY --(INPUT_QTY > 0 OR GOOD_QTY > 0)		--2019-11-05 PIYONG CHANGE --2019-11-14 PIYONG  CHANGE 
						AND r.INPUT_QTY > 0 -- 2021-02-17 kimcd  기존 자동 산출 수율과 로직 동기화하기 위해 조건 추가
						AND R.PROCID LIKE 'F%'
					) AA
			  WHERE AA.BASE_YMD	>= DATEADD(DAY,-180, CONVERT( NVARCHAR(8), GETDATE() , 112) ) --(AA.BASE_YMD)



			--일자 건수가 15건 이하 구함
			SELECT PLANT_ID
				   , FACTORY_ID
				   , LINE_ID
				   , PROCID
				   , ITEM_ID
			  INTO #MIN_TEMP
			  FROM (
					SELECT PLANT_ID
						   , FACTORY_ID
						   , LINE_ID
						   , PROCID
						   , ITEM_ID
						   , MAX( R_CNT )  AS R_CNT
					  FROM #TEMP_TABLE
					 GROUP BY PLANT_ID
							, FACTORY_ID
							, LINE_ID
							, PROCID
							, ITEM_ID
				   ) A
			 WHERE R_CNT <= 15

			--	2019-09-26 PIYONG ADD			
			--------------------------------------------------------------------------------------------


			
			DECLARE CUR_YIELD CURSOR FOR
				SELECT [COMPANY_ID]
					   ,[DIVISION_ID]
					   ,[SITE_ID]
					   ,[PLANT_ID]
					   ,[FACTORY_ID]
					   ,[OPERATION_ID]
					   ,[LINE_ID]
					   ,[ITEM_ID]
					   ,MONTH
					   ,ROUND(YIELD, 4) AS YIELD  -- 2020-11-05 kimcd 수율 2자리 Round 처리에서 4자리로 변경
				  FROM (
					----------------------------------------------------------------------------
					--2018-06-28 PIYONG CHANGE
						SELECT DISTINCT R.[COMPANY_ID]
							   ,R.[DIVISION_ID]
							   ,R.[SITE_ID]
							   ,R.[PLANT_ID]
							   ,R.[FACTORY_ID]
							   ,R.OPERATION_ID
							   ,R.[LINE_ID]
							   ,R.[ITEM_ID]
							   ,CASE WHEN FCS_INPUT = 0  THEN
										0
									 ELSE 
										FCS_GOOD / FCS_INPUT
									 END AS YIELD
						  FROM (
								SELECT R.PLANT_ID
									   ,R.FACTORY_ID
									   ,E.LINE_ID
									   ,R.ITEM_ID
									   ,E.COMPANY_ID
									   ,E.DIVISION_ID
									   ,E.SITE_ID
                                       ,CASE WHEN R.PROCID IN  ( 'F4800', 'F5100','F5300DW','F7000DW') THEN ISNULL(RIGHT(I.FORMATION_FLOW_ID, 5),'F6000')
										WHEN R.PROCID = 'F7200DW' THEN 'F7200'
										ELSE R.PROCID END AS OPERATION_ID -- 2021-02-17 kimcd 각 법인별 특성 공정에 맞도록 공정 변경
									   ,SUM(R.GOOD_QTY)  AS FCS_GOOD
									   ,SUM(R.INPUT_QTY) AS FCS_INPUT
								  FROM (
										-----------------------------------------------------------------------------------------------------
										--	2019-09-26 PIYONG ADD
										SELECT BASE_YMD
											   , PLANT_ID
											   , FACTORY_ID
											   , LINE_ID
											   , CASE WHEN T.PROCID = 'F2000' THEN 'F1000' 
													  ELSE T.PROCID
													  END AS PROCID -- 2021-02-17 kimcd 활성화 특성의 수율 관리 공정 맞추기 위해 공정 case 문장 수정
											   , ITEM_ID
											   , GOOD_QTY
											   , INPUT_QTY
										  FROM #TEMP_TABLE T
										 WHERE NOT EXISTS (
															SELECT 1
															  FROM #MIN_TEMP M
															 WHERE T.PLANT_ID = M.PLANT_ID
															   AND T.FACTORY_ID = M.FACTORY_ID
															   AND T.LINE_ID = M.LINE_ID
															   AND T.PROCID = M.PROCID
															   AND T.ITEM_ID = M.ITEM_ID
															)
											AND R_CNT <= @P_SEARCH_TERM
										--	2019-09-26 PIYONG ADD
										-----------------------------------------------------------------------------------------------------
									   ) R
									   ,( SELECT DISTINCT LM.COMPANY_ID
												 ,LM.DIVISION_ID
												 ,LM.SITE_ID
												 ,LM.PLANT_ID
												 ,LM.FACTORY_ID
												 ,LM.LINE_ID
											FROM SCM_LINE_M LM
										   WHERE LM.ACTIVE_FLAG = 'Y'
											 AND LM.SITE_ID = @P_SITE_ID
									   )  E
									   , SCM_ITEM_M I
								 WHERE R.PLANT_ID      = E.PLANT_ID
								   AND R.FACTORY_ID    = E.FACTORY_ID
								   AND R.LINE_ID       = E.LINE_ID
								   AND I.COMPANY_ID = E.COMPANY_ID
								   AND I.DIVISION_ID =  E.DIVISION_ID
								   AND I.SITE_ID = E.SITE_ID
								   AND I.ITEM_ID = R.ITEM_ID
								   AND ( ( R.PLANT_ID = 'G182' AND I.ITEM_CLASS != 'EM010104' ) OR R.PLANT_ID != 'G182' )
								 GROUP BY R.PLANT_ID
									   ,R.FACTORY_ID
									   ,E.LINE_ID
									   ,R.ITEM_ID
									   ,E.COMPANY_ID
									   ,E.DIVISION_ID
									   ,E.SITE_ID
                                       ,CASE WHEN R.PROCID IN  ( 'F4800', 'F5100','F5300DW','F7000DW') THEN ISNULL(RIGHT(I.FORMATION_FLOW_ID, 5),'F6000')
										WHEN R.PROCID = 'F7200DW' THEN 'F7200'
										ELSE R.PROCID END -- 2021-02-17 kimcd 각 법인별 특성 공정에 맞도록 공정 변경

							   ) R
						 WHERE R.FCS_GOOD != 0
	   					--2018-06-28 PIYONG CHANGE
						----------------------------------------------------------------------------
					   ) A
					   ,(
							SELECT DISTINCT YEAR+MONTH AS MONTH
							  FROM SCM_SYS_CALENDAR_M
							 WHERE YEAR+MONTH BETWEEN CONVERT(NVARCHAR(6),GETDATE(), 112)
							   AND CONVERT(NVARCHAR(6),DATEADD(MM, 5, GETDATE()), 112)
					   ) B


					---------------------------------------------------------------------------------------------------
					--2018-08-24 piyong add
			DECLARE CUR_FORMATION_TOTAL_YIELD CURSOR FOR
				SELECT [COMPANY_ID]
					   ,[DIVISION_ID]
					   ,[SITE_ID]
					   ,[PLANT_ID]
					   ,[FACTORY_ID]
					   ,[LINE_ID]
					   ,[ITEM_ID]
				--	   ,MONTH  	--2019-01-21 PIYONG DEL
					   ,FORMATION1_YIELD
					   ,DEGAS_YIELD
					   ,FORMATION2_YIELD
					   ,GRADE_YIELD
					   ,CHARACTERIZATION_YIELD
					   ,FORMATION_TOTAL_YIELD
				  FROM (
						SELECT AA.[COMPANY_ID]
							   ,AA.[DIVISION_ID]
							   ,AA.[SITE_ID]
							   ,AA.[PLANT_ID]
							   ,AA.[FACTORY_ID]
							   ,AA.[LINE_ID]
							   ,AA.[ITEM_ID]
							   ,SUM( FORMATION1_YIELD ) AS FORMATION1_YIELD
							   ,SUM( DEGAS_YIELD ) AS DEGAS_YIELD
							   ,SUM( FORMATION2_YIELD ) AS FORMATION2_YIELD
							   ,SUM( GRADE_YIELD ) AS GRADE_YIELD
							   ,SUM( CHARACTERIZATION_YIELD ) AS CHARACTERIZATION_YIELD
								--2018-12-04 PIYONG CASE분 변경
							   ,CASE WHEN SUM( FORMATION1_YIELD ) = 0 THEN 1 ELSE SUM( FORMATION1_YIELD ) END 
									* CASE WHEN SUM( DEGAS_YIELD ) = 0 THEN 1 ELSE SUM( DEGAS_YIELD ) END
									* CASE WHEN SUM( FORMATION2_YIELD ) = 0 THEN 1 ELSE SUM( FORMATION2_YIELD ) END 
									* CASE WHEN SUM( GRADE_YIELD ) = 0 THEN 1 ELSE SUM( GRADE_YIELD ) END 
										AS FORMATION_TOTAL_YIELD
						  FROM (
								SELECT A.[COMPANY_ID]
									   ,A.[DIVISION_ID]
									   ,A.[SITE_ID]
									   ,A.[PLANT_ID]
									   ,A.[FACTORY_ID]
									   ,A.[OPERATION_ID]
									   ,A.[LINE_ID]
									   ,A.[ITEM_ID]
									   ,CASE WHEN [OPERATION_ID] = 'F1000' THEN YIELD ELSE 0 END AS FORMATION1_YIELD
									   ,CASE WHEN [OPERATION_ID] = 'F4000' THEN YIELD ELSE 0 END AS DEGAS_YIELD
									   ,CASE WHEN [OPERATION_ID] = 'F4500' THEN YIELD ELSE 0 END AS FORMATION2_YIELD
									   ,CASE WHEN [OPERATION_ID] = 'F4700' THEN YIELD ELSE 0 END AS GRADE_YIELD
									   ,CASE WHEN [OPERATION_ID] = 'F6000' THEN YIELD ELSE 0 END AS CHARACTERIZATION_YIELD
								  FROM (
										SELECT R.[COMPANY_ID]
											   ,R.[DIVISION_ID]
											   ,R.[SITE_ID]
											   ,R.[PLANT_ID]
											   ,R.[FACTORY_ID]
											   ,R.[OPERATION_ID]
											   ,R.[LINE_ID]
											   ,R.[ITEM_ID]
											   ,CASE WHEN FCS_INPUT = 0  THEN
														0
													 ELSE 
														FCS_GOOD / FCS_INPUT
													 END AS YIELD
										  FROM (
												SELECT E.COMPANY_ID
													   ,E.DIVISION_ID
													   ,E.SITE_ID
													   ,R.PLANT_ID
													   ,R.FACTORY_ID
													   ,CASE WHEN R.PROCID = 'F2000' THEN 'F1000' 
															 WHEN R.PROCID IN ('F4800','F5100','F5300DW','F7000DW') THEN 'F6000' -- 2021-02-17 kimcd 특성 공정 CASE 수정
															 ELSE R.PROCID
															 END AS [OPERATION_ID]
													   ,E.LINE_ID
													   ,R.ITEM_ID
													   ,SUM(R.GOOD_QTY)  AS FCS_GOOD
													   ,SUM(R.INPUT_QTY) AS FCS_INPUT
												  FROM (
														------------------------------------------------------------------------------------------------------
														--	2019-09-26 PIYONG ADD
														SELECT BASE_YMD
															   , PLANT_ID
															   , FACTORY_ID
															   , LINE_ID
															   , PROCID
															   , ITEM_ID
															   , GOOD_QTY
															   , INPUT_QTY
														  FROM #TEMP_TABLE T
														 WHERE NOT EXISTS (
																			SELECT 1
																			  FROM #MIN_TEMP M
																			  WHERE T.PLANT_ID = M.PLANT_ID
																				AND T.FACTORY_ID = M.FACTORY_ID
																				AND T.LINE_ID = M.LINE_ID
																				AND T.PROCID = M.PROCID
																				AND T.ITEM_ID = M.ITEM_ID
																		  )
														   AND R_CNT <= @P_SEARCH_TERM
									   					--	2019-09-26 PIYONG ADD
														------------------------------------------------------------------------------------------------------
													   ) R
													   ,(
															SELECT DISTINCT LM.COMPANY_ID
																   ,LM.DIVISION_ID
																   ,LM.SITE_ID
																   ,LM.PLANT_ID
																   ,FACTORY_ID
																   ,LM.LINE_ID
															  FROM SCM_LINE_M LM
															 WHERE LM.ACTIVE_FLAG = 'Y'
															   AND LM.SITE_ID = @P_SITE_ID
													   ) E
												 WHERE R.PROCID IN (
																	'F1000'
																	,'F2000'
																	,'F4000'
																	,'F4500'
																	,'F4700'
																	,'F4800' -- 2021-02-17 kimcd 자동차 특성
																	,'F5100' -- 2021-02-17 kimcd 초소형 특성
																	,'F5300DW' -- 2021-02-17 kimcd 소형 특성
																	,'F7000DW' -- 2021-02-17 kimcd 파우치 특성
																	)
												   AND R.PLANT_ID      = E.PLANT_ID
												   AND R.FACTORY_ID    = E.FACTORY_ID
												   AND R.LINE_ID       = E.LINE_ID
												 GROUP BY E.COMPANY_ID
													   ,E.DIVISION_ID
													   ,E.SITE_ID
													   ,R.PLANT_ID
													   ,R.FACTORY_ID
													   ,CASE WHEN R.PROCID = 'F2000' THEN 'F1000' 
															 WHEN R.PROCID IN ('F4800','F5100','F5300DW','F7000DW') THEN 'F6000' -- 2021-02-17 kimcd 특성 공정 CASE 수정
															 ELSE R.PROCID END
													   ,E.LINE_ID
													   ,R.ITEM_ID
											   ) R
										 WHERE R.FCS_GOOD != 0
									   ) A
							   ) AA
						 GROUP BY AA.[COMPANY_ID]
							   ,AA.[DIVISION_ID]
							   ,AA.[SITE_ID]
							   ,AA.[PLANT_ID]
							   ,AA.[FACTORY_ID]
							   ,AA.[LINE_ID]
							   ,AA.[ITEM_ID]
					   ) A
						/*	--2019-01-21 PIYONG DEL
						,(
							SELECT DISTINCT YEAR+MONTH AS MONTH
							FROM SCM_SYS_CALENDAR_M
							WHERE YEAR+MONTH BETWEEN CONVERT(NVARCHAR(6),GETDATE(), 112)
							AND CONVERT(NVARCHAR(6),DATEADD(MM, 5, GETDATE()), 112)
						) B
						*/
			--2018-08-24 piyong add
			---------------------------------------------------------------------------------------------------


			OPEN CUR_YIELD;
			FETCH NEXT FROM CUR_YIELD INTO @COMPANY_ID
											   ,@DIVISION_ID
											   ,@SITE_ID
											   ,@PLANT_ID
											   ,@FACTORY_ID
											   ,@OPERATION_ID
											   ,@LINE_ID
											   ,@ITEM_ID
											   ,@MONTH
											   ,@YIELD
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					MERGE INTO [dbo].[SCM_YIELD_M] YM
					USING (
							SELECT @COMPANY_ID AS COMPANY_ID
									,@DIVISION_ID AS DIVISION_ID
									,@SITE_ID AS SITE_ID
									,@PLANT_ID AS PLANT_ID
									,@FACTORY_ID AS FACTORY_ID
									,@OPERATION_ID AS OPERATION_ID
									,@LINE_ID AS LINE_ID
									,@ITEM_ID AS ITEM_ID
									,@MONTH AS MONTH
									,@YIELD AS YIELD
						  ) TEMP
					  ON (
							YM.[COMPANY_ID] = TEMP.COMPANY_ID
							AND YM.[DIVISION_ID] = TEMP.DIVISION_ID
							AND YM.[SITE_ID] =  TEMP.SITE_ID
							AND YM.[PLANT_ID] = TEMP.PLANT_ID
							AND YM.FACTORY_ID = TEMP.FACTORY_ID
							AND YM.OPERATION_ID = TEMP.OPERATION_ID
							AND YM.[LINE_ID] = TEMP.LINE_ID
							AND YM.[ITEM_ID] = TEMP.ITEM_ID
							AND YM.[MONTH] = TEMP.MONTH
							-- AND YM.UPDATE_ID = 'PR_XIF_DW_YIELD_R' 2019-03-31 kimcd 조건 제거

						 )
					WHEN MATCHED THEN
						UPDATE
						  SET YM.YIELD  = CASE WHEN YM.UPDATE_ID = 'PR_XIF_DW_YIELD_R' THEN TEMP.YIELD ELSE YM.YIELD END	-- 2019-03-31 kimcd i/f된 정보만 갱신. 사용자가 변경한 것은 갱신 안 함
							  ,YM.RESULT_YIELD = TEMP.YIELD																	-- 2109-06-18 PIYONG ADD
							  ,YM.UPDATE_TIME = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
								[COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[OPERATION_ID]
								,[LINE_ID]
								,[ITEM_ID]
								,[MONTH]
								,[YIELD]
								,[RESULT_YIELD]			--2019-06-18 PIYONG ADD
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
								,TEMP.ITEM_ID
								,TEMP.MONTH
								,TEMP.YIELD
								,TEMP.YIELD				--2019-06-18 PIYONG ADD
								,'PR_XIF_DW_YIELD_R'
								,GETDATE()
								,'PR_XIF_DW_YIELD_R'
								,GETDATE()
						)
					;
	
					SET @ROWCOUNT = @@ROWCOUNT
			 				   	
					FETCH NEXT FROM CUR_YIELD INTO @COMPANY_ID
													,@DIVISION_ID
													,@SITE_ID
													,@PLANT_ID
													,@FACTORY_ID
													,@OPERATION_ID
													,@LINE_ID
													,@ITEM_ID
													,@MONTH
													,@YIELD
					;
				END;

			CLOSE CUR_YIELD;
			DEALLOCATE CUR_YIELD;

			---------------------------------------------------------------------------------------------------
			--2018-08-24 piyong add

			OPEN CUR_FORMATION_TOTAL_YIELD;
			FETCH NEXT FROM CUR_FORMATION_TOTAL_YIELD INTO @COMPANY_ID
													   ,@DIVISION_ID
													   ,@SITE_ID
													   ,@PLANT_ID
													   ,@FACTORY_ID
													   ,@LINE_ID
													   ,@ITEM_ID
												--	   ,@MONTH	  	--2019-01-21 PIYONG DEL
													   ,@FORMATION1_YIELD
													   ,@DEGAS_YIELD
													   ,@FORMATION2_YIELD
													   ,@GRADE_YIELD
													   ,@CHARACTERIZATION_YIELD
													   ,@FORMATION_TOTAL_YIELD
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					MERGE INTO [dbo].[SCM_FORMATION_YIELD_M] FY
					USING (
							SELECT @COMPANY_ID AS COMPANY_ID
								   ,@DIVISION_ID AS DIVISION_ID
								   ,@SITE_ID AS SITE_ID
								   ,@PLANT_ID AS PLANT_ID
								   ,@FACTORY_ID AS FACTORY_ID
								   ,@LINE_ID AS LINE_ID
								   ,@ITEM_ID AS ITEM_ID
							--	   ,@MONTH AS MONTH		  	--2019-01-21 PIYONG DEL
								   ,@FORMATION1_YIELD AS FORMATION1_YIELD
								   ,@DEGAS_YIELD AS DEGAS_YIELD
								   ,@FORMATION2_YIELD AS FORMATION2_YIELD
								   ,@GRADE_YIELD AS GRADE_YIELD
								   ,@CHARACTERIZATION_YIELD AS CHARACTERIZATION_YIELD
								   ,@FORMATION_TOTAL_YIELD AS FORMATION_TOTAL_YIELD
						  ) TEMP
					  ON (
							FY.[COMPANY_ID] = TEMP.COMPANY_ID
							AND FY.[DIVISION_ID] = TEMP.DIVISION_ID
							AND FY.[SITE_ID] =  TEMP.SITE_ID
							AND FY.[PLANT_ID] = TEMP.PLANT_ID
							AND FY.FACTORY_ID = TEMP.FACTORY_ID
							AND FY.[LINE_ID] = TEMP.LINE_ID
							AND FY.[ITEM_ID] = TEMP.ITEM_ID
						--	AND FY.[MONTH] = TEMP.MONTH	  	--2019-01-21 PIYONG DEL
						--	AND FY.UPDATE_ID = 'PR_XIF_DW_YIELD_R'	  	--2019-02-13 PIYONG DEL
						 )
					WHEN MATCHED THEN
						UPDATE
						  SET FY.FORMATION1_YIELD  = TEMP.FORMATION1_YIELD
							  ,FY.DEGAS_YIELD  = TEMP.DEGAS_YIELD
							  ,FY.FORMATION2_YIELD  = TEMP.FORMATION2_YIELD
							  ,FY.GRADE_YIELD  = TEMP.GRADE_YIELD
							  ,FY.CHARACTERIZATION_YIELD  = TEMP.CHARACTERIZATION_YIELD
							  ,FY.FORMATION_TOTAL_YIELD  = TEMP.FORMATION_TOTAL_YIELD
							  ,FY.UPDATE_ID = 'PR_XIF_DW_YIELD_R'
							  ,FY.UPDATE_TIME = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
								[COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[LINE_ID]
								,[ITEM_ID]
							--	,[MONTH]				  	--2019-01-21 PIYONG DEL
								,FORMATION1_YIELD
								,DEGAS_YIELD
								,FORMATION2_YIELD
								,GRADE_YIELD
								,CHARACTERIZATION_YIELD
								,FORMATION_TOTAL_YIELD
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
								,TEMP.LINE_ID
								,TEMP.ITEM_ID
							--	,TEMP.MONTH				  	--2019-01-21 PIYONG DEL
								,TEMP.FORMATION1_YIELD
								,TEMP.DEGAS_YIELD
								,TEMP.FORMATION2_YIELD
								,TEMP.GRADE_YIELD
								,TEMP.CHARACTERIZATION_YIELD
								,TEMP.FORMATION_TOTAL_YIELD
								,'PR_XIF_DW_YIELD_R'
								,GETDATE()
								,'PR_XIF_DW_YIELD_R'
								,GETDATE()
						)
					;
	
					SET @ROWCOUNT = @@ROWCOUNT
			 				   	
					FETCH NEXT FROM CUR_FORMATION_TOTAL_YIELD INTO @COMPANY_ID
													   ,@DIVISION_ID
													   ,@SITE_ID
													   ,@PLANT_ID
													   ,@FACTORY_ID
													   ,@LINE_ID
													   ,@ITEM_ID
												--	   ,@MONTH	  	--2019-01-21 PIYONG DEL
													   ,@FORMATION1_YIELD
													   ,@DEGAS_YIELD
													   ,@FORMATION2_YIELD
													   ,@GRADE_YIELD
													   ,@CHARACTERIZATION_YIELD
													   ,@FORMATION_TOTAL_YIELD
					;
				END;

			CLOSE CUR_FORMATION_TOTAL_YIELD;
			DEALLOCATE CUR_FORMATION_TOTAL_YIELD;

			--2018-08-24 piyong add
			---------------------------------------------------------------------------------------------------



			UPDATE [dbo].[SY_XIF_DW_YIELD_R]
			   SET TRANSFER_FLAG = 'Y'
				   ,TRANSFER_DATE = GETDATE()
			 WHERE 1=1	--IFSEQNO       = @P_IFSEQNO			 --PIYONG 2018-07-17 DEL
			   AND TRANSFER_FLAG = 'P'

		COMMIT TRAN

		-- 2021-02-17 kimcd 전월 실적 수율 갱신 과정 추가 시작
			IF '5' <= DAY(GETDATE()) -- 2021-07-21 kimcd 5일 이후 과거 수율 계속 갱신
				BEGIN
					UPDATE YM SET RESULT_YIELD = NULL
					FROM   [dbo].[SCM_YIELD_M] YM
					WHERE YM.SITE_ID = @P_SITE_ID
					AND   YM.PLANT_ID IN (
								SELECT SLV.SEGMENT1 AS PLANT_ID
								FROM SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
								WHERE SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
								AND SLV.ACTIVE_FLAG = 'Y'
								AND SLV.SEGMENT2 = @P_BASIS_START_TIME
								)
					AND YM.OPERATION_ID LIKE 'F%'
					AND YM.MONTH = CONVERT(NVARCHAR(6),DATEADD(M,-1,GETDATE()),112) -- 2021-04-30 kimcd 실적 수율 초기화

					DECLARE CUR_RESULT_YIELD CURSOR FOR
					SELECT [COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[FACTORY_ID]
						   ,[OPERATION_ID]
						   ,[LINE_ID]
						   ,[ITEM_ID]
						   ,MONTH
						   ,YIELD
					  FROM (
							SELECT R.[COMPANY_ID]
								   ,R.[DIVISION_ID]
								   ,R.[SITE_ID]
								   ,R.[PLANT_ID]
								   ,R.[FACTORY_ID]
								   ,R.OPERATION_ID
								   ,R.[LINE_ID]
								   ,R.[ITEM_ID]
								   ,CASE WHEN FCS_GOOD > FCS_INPUT THEN 1.0 ELSE FCS_GOOD / FCS_INPUT END AS YIELD
							  FROM (
									SELECT   MAX(P.COMPANY_ID)   AS  COMPANY_ID
										   , MAX(P.DIVISION_ID)  AS  DIVISION_ID
										   , MAX(P.SITE_ID)      AS  SITE_ID
										   , A.PLANT_ID
										   , A.FACTORY_ID
										   , A.LINE_ID
										   , A.ITEM_ID
										   , CASE   WHEN A.PROCID = 'F2000' THEN 'F1000' 
													WHEN A.PROCID IN  ( 'F4800', 'F5100','F5300DW','F7000DW') THEN ISNULL(RIGHT(I.FORMATION_FLOW_ID, 5),'F6000')
													WHEN A.PROCID = 'F7200DW' THEN 'F7200'
													ELSE A.PROCID END          AS OPERATION_ID
										   , SUM(A.[GOOD_QTY])  AS FCS_GOOD
										   , SUM(A.[INPUT_QTY]) AS FCS_INPUT
									  FROM  [SCM_ITEM_M]        I (NOLOCK)
										  , [SY_XIF_DW_YIELD_H] A (NOLOCK)
										  , SCM_PLANT_M         P (NOLOCK)
									 WHERE 1 = 1
									 and   A.PLANT_ID = P.PLANT_ID
									 AND   I.COMPANY_ID  = P.COMPANY_ID
									 AND   I.DIVISION_ID = P.DIVISION_ID
									 AND   I.SITE_ID     = P.SITE_ID
									 AND   I.ITEM_ID     = A.ITEM_ID
									 AND   P.SITE_ID = @P_SITE_ID
									 AND   P.PLANT_ID IN (
													SELECT SLV.SEGMENT1 AS PLANT_ID
													  FROM SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
													 WHERE SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
													   AND SLV.ACTIVE_FLAG = 'Y'
													   AND SLV.SEGMENT2 = @P_BASIS_START_TIME
													)
										AND A.PROCID LIKE 'F%'
										AND A.BASE_YMD >=	CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()) - 1, 0), 112)
										AND A.BASE_YMD <	CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 112)
									 GROUP BY A.PLANT_ID
											,A.FACTORY_ID
											,A.LINE_ID
											,A.ITEM_ID
											,CASE   WHEN A.PROCID = 'F2000' THEN 'F1000' 
													WHEN A.PROCID IN  ( 'F4800', 'F5100','F5300DW','F7000DW') THEN ISNULL(RIGHT(I.FORMATION_FLOW_ID, 5),'F6000')
													WHEN A.PROCID = 'F7200DW' THEN 'F7200'
													ELSE A.PROCID END
									) R
							 WHERE R.FCS_INPUT != 0
							) A
							,(
								SELECT CONVERT(NVARCHAR(6),DATEADD(M,-1,GETDATE()),112)AS MONTH
							) B




					OPEN CUR_RESULT_YIELD;
					FETCH NEXT FROM CUR_RESULT_YIELD INTO @COMPANY_ID
													,@DIVISION_ID
													,@SITE_ID
													,@PLANT_ID
													,@FACTORY_ID
													,@OPERATION_ID
													,@LINE_ID
													,@ITEM_ID
													,@MONTH
													,@YIELD
					;

					WHILE (@@FETCH_STATUS = 0)
						BEGIN

							MERGE INTO [dbo].[SCM_YIELD_M] YM
							USING (
									SELECT @COMPANY_ID AS COMPANY_ID
											,@DIVISION_ID AS DIVISION_ID
											,@SITE_ID AS SITE_ID
											,@PLANT_ID AS PLANT_ID
											,@FACTORY_ID AS FACTORY_ID
											,@OPERATION_ID AS OPERATION_ID
											,@LINE_ID AS LINE_ID
											,@ITEM_ID AS ITEM_ID
											,@MONTH AS MONTH
											,@YIELD AS YIELD
									) TEMP
								ON (
									YM.[COMPANY_ID] = TEMP.COMPANY_ID
									AND YM.[DIVISION_ID] = TEMP.DIVISION_ID
									AND YM.[SITE_ID] =  TEMP.SITE_ID
									AND YM.[PLANT_ID] = TEMP.PLANT_ID
									AND YM.FACTORY_ID = TEMP.FACTORY_ID
									AND YM.OPERATION_ID = TEMP.OPERATION_ID
									AND YM.[LINE_ID] = TEMP.LINE_ID
									AND YM.[ITEM_ID] = TEMP.ITEM_ID
									AND YM.[MONTH] = TEMP.MONTH
									)
							WHEN MATCHED THEN
								UPDATE
									SET YM.RESULT_YIELD	= TEMP.YIELD
										,YM.UPDATE_ID	= 'PR_XIF_DW_YIELD_R'
										,YM.UPDATE_TIME	= GETDATE()
							WHEN NOT MATCHED THEN
								INSERT (
										[COMPANY_ID]
										,[DIVISION_ID]
										,[SITE_ID]
										,[PLANT_ID]
										,[FACTORY_ID]
										,[OPERATION_ID]
										,[LINE_ID]
										,[ITEM_ID]
										,[MONTH]
										,[YIELD]
										,[RESULT_YIELD]				--2019-06-17 PIYONG ADD
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
										,TEMP.OPERATION_ID
										,TEMP.LINE_ID
										,TEMP.ITEM_ID
										,TEMP.MONTH
										,1							--2019-06-17 PIYONG CHANGE TEMP.YIELD -> 1
										,TEMP.YIELD					--2019-06-17 PIYONG ADD
										,'PR_XIF_DW_YIELD_R'
										,GETDATE()
										,'PR_XIF_DW_YIELD_R'
										,GETDATE()
								)
							;
	
							SET @ROWCOUNT = @@ROWCOUNT
			 				   	
							FETCH NEXT FROM CUR_RESULT_YIELD INTO @COMPANY_ID
																,@DIVISION_ID
																,@SITE_ID
																,@PLANT_ID
																,@FACTORY_ID
																,@OPERATION_ID
																,@LINE_ID
																,@ITEM_ID
																,@MONTH
																,@YIELD
							;
						END;

					CLOSE CUR_RESULT_YIELD;
					DEALLOCATE CUR_RESULT_YIELD;

					-- 2024-03-06 kimcd  WA.FP로 전월 실적 수율 전송 과정 추가 시작
					INSERT INTO SY_XIF_FP_RESULT_YIELD_S
					    ( [IF_SEQ]
					     ,[IF_TYPE]
					     ,[IF_ID]
					     ,[IF_INS_DATE]
					     ,[IF_FLAG]
					     ,[IF_SND_DATE]
                         ,[FACTORY_ID]
                         ,[OPERATION_ID]
                         ,[LINE_ID]
                         ,[ITEM_ID]
                         ,[MONTH]
                         ,[INPUT_QTY]
                         ,[GOOD_QTY]
                         ,[GNRT_DTTM]
                         ,[ACCUM_COUNT] )
					SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3, 6)
           					+ REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_FP_SEND_SEQ]))
           					+ CAST( NEXT VALUE FOR [dbo].[XIF_FP_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
					      ,'S' AS IF_TYPE
					      ,'OFP0' +'_' + A.FP_SOURCE_CODE +'_RESULT_YIELD'
					      ,GETDATE()        AS IF_INS_DATE
					      ,'N'              AS IF_FLAG
					      ,GETDATE()        AS IF_SND_DATE
					      ,A.[FACTORY_ID]
                          ,A.[OPERATION_ID]
                          ,A.[LINE_ID]
                          ,A.[ITEM_ID]
                          ,CONVERT(NVARCHAR(6),DATEADD(M,-1,GETDATE()),112) AS [MONTH]
                          ,A.[INPUT_QTY]
                          ,A.[GOOD_QTY]
			              ,GETDATE() AS GNRT_DTTM
					      ,COUNT(*) OVER(PARTITION BY A.FP_SOURCE_CODE)   ACCUM_COUNT
					FROM  (	SELECT  A.FACTORY_ID
								  , A.LINE_ID
								  , A.ITEM_ID
								  , CASE   WHEN A.PROCID = 'F2000' THEN 'F1000' 
								  		WHEN A.PROCID IN  ( 'F4800', 'F5100','F5300DW','F7000DW') THEN ISNULL(RIGHT(I.FORMATION_FLOW_ID, 5),'F6000')
								  		WHEN A.PROCID = 'F7200DW' THEN 'F7200'
								  		ELSE A.PROCID END          AS [OPERATION_ID]
								  , SUM(A.[GOOD_QTY])  AS [GOOD_QTY]
								  , SUM(A.[INPUT_QTY]) AS [INPUT_QTY]
								  , MAX(SLVFS.ATTRIBUTE1)   AS [FP_SOURCE_CODE]
							FROM  [SY_XIF_DW_YIELD_H] A (NOLOCK)
								  INNER JOIN SCM_PLANT_M         P (NOLOCK)
									  ON  A.PLANT_ID    = P.PLANT_ID
								  INNER JOIN [SCM_ITEM_M]        I (NOLOCK)
									  ON  I.COMPANY_ID  = P.COMPANY_ID
									  AND I.DIVISION_ID = P.DIVISION_ID
									  AND I.SITE_ID     = P.SITE_ID
									  AND I.ITEM_ID     = A.ITEM_ID
								  INNER JOIN SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
									  ON  SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
									  AND P.PLANT_ID           = SLV.SEGMENT1
                                      AND SLV.ACTIVE_FLAG      = 'Y'
								  INNER JOIN  [DBO].[SCM_SYS_LOOKUP_VALUE]  SLVFS WITH(NOLOCK)
						              ON P.COMPANY_ID = SLVFS.SEGMENT1
							WHERE SLV.LOOKUP_TYPE_CODE   = 'BASIS_START_TIME_PLANT'
							AND   SLV.ACTIVE_FLAG        = 'Y'
							AND   SLVFS.LOOKUP_TYPE_CODE = 'COMPANY_FP_SYSTEM_CODE'
						    AND   SLVFS.ACTIVE_FLAG      = 'Y'
							AND   P.SITE_ID              = @P_SITE_ID
						    AND   SLV.SEGMENT2           = @P_BASIS_START_TIME
							AND   A.PROCID            LIKE 'F%'
							AND   A.BASE_YMD            >= CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()) - 1, 0), 112)
							AND   A.BASE_YMD             < CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 112)
							GROUP BY A.FACTORY_ID
									, A.LINE_ID
									, A.ITEM_ID
									, CASE WHEN A.PROCID = 'F2000' THEN 'F1000' 
										WHEN A.PROCID IN  ( 'F4800', 'F5100','F5300DW','F7000DW') THEN ISNULL(RIGHT(I.FORMATION_FLOW_ID, 5),'F6000')
										WHEN A.PROCID = 'F7200DW' THEN 'F7200'
										ELSE A.PROCID END
						) A
					WHERE A.[INPUT_QTY] != 0
                    -- 2024-03-06 kimcd  WA.FP로 전월 실적 수율 전송 과정 추가 끝
				END
		-- 2021-02-17 kimcd 전월 실적 수율 갱신 과정 추가 끝

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		ROLLBACK TRAN

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



