
CREATE PROCEDURE [dbo].[PR_XIF_DW_ITEM_YIELD_R]

-- ================================================================================================
-- Program ID          : FP00973
-- Program Name        : PR_XIF_DW_ITEM_YIELD_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : DW
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_ITEM_YIELD_R
-- Destination Table   : SCM_YIELD_M
--
-- Create Date		   : 2018.09.19
-- Update Date		   : 2019.06.17 PIYONG
--						 2019.07.05 2.1 PIYONG
--						 2019.09.26 2.2 PIYONG
--						 2019.11.05 2.3 PIYONG
--						 2019.11.14 2.4 PIYONG
--                       2021.02.17 2.5 kimcd
--                       2021.04.30 2.6 kimcd
--                       2021.07.21 2.7 kimcd
--                       2021.09.10 2.8 kimcd

-- Author              : piyong
-- Version             : 1.0
--						 2.0 FACTORY_GPLM_APPLY_TYPE LOOK UP 테이블 삭제
--							 월 1회만 실행 로직 삭제
--						 2.1 PACK 공정 추가 수신
--						 2.2 설비 기준에서 MES 라인 기준으로 수율 생성으로 변경
--						 2.3 정인천 책임 요청으로 투입수량이 0보다 큰경우에만 적용
--						 2.4 정인천 책임 요청으로 투입수량이 양품보다 큰경우에만 적용
--                       2.5 2021-02-17 kimcd 기준 정보 Master용 실적 수율 정보 갱신
--                       2.6 2021-04-30 kimcd 갱신 범위 존재하는 계획 갱신 안 되면 삭제
--                                            전월 실적 수율 넣는 과정에 실적 수율 초기화 문장 추가
--                       2.7 2021-07-21 kimcd 미래월 실적 수율 형성 로직 삭제, 전월 실적 5일 이후 계속 변경
--                       2.8 2021-09-10 kimcd Coater에 설비 기반으로 수율 집계
--                                            A4000DW 공정으로 집계되는 수율을 Assembly 공정 수율로 집계
--                       2.9 2022-08-31 leeseongmin 일반 DATA 삭제로직 수정 (CSR : C20220831-000137)
--                       3.0 2023-07-24 FP Pjt. 자동차/ESS 사업부 전 법인의 '23년 7월 데이터부터 A7000, A8000 공정 정보가 A7400DW, A8400DW 로 변경됨
--                                              - A7000(라미) + A7400(AZS E-Cutter) = A7400DW(Lamination & Cutter)
--                                              - A8000(폴딩) + A8400(AZS Stacking) = A8400DW(Folding & Stacking)
--                       3.1 2024-03-06 kimcd  WA.FP로 전월 실적 수율 전송 과정 추가
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
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_ITEM_YIELD_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)


	--변수
	DECLARE @P_IFSEQNO		NVARCHAR(50)
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

--	DECLARE @L_SITE_ID		NVARCHAR(30) = @P_SITE_ID	--2019-06-17 PIYONG ADD

	
	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
--			SET  @L_SITE_ID =   @P_SITE_ID;
			UPDATE [dbo].[SY_XIF_DW_ITEM_YIELD_R]
			SET TRANSFER_FLAG = 'P'
			WHERE 1=1 --IFSEQNO       = @P_IFSEQNO
			AND TRANSFER_FLAG = 'N'
			--AND PLANT_ID = @P_PLANT_ID

			---------------------------------------------------------------------------------------------------------------------------------------------------------
			--2019-10-08 PIYONG ADD
			MERGE INTO [SY_XIF_DW_YIELD_H] H
			USING (
					SELECT [PLANT_ID]
							,[FACTORY_ID]
							,[LINE_ID]
							,[EQUIPMENT_ID]  -- 2021-09-10 kimcd 설비 정보 추가
							,[PROCID]
							,[ITEM_ID]
							,[YMD_CODE]
							,[FCS_INPUT]
							,[FCS_GOOD]
						FROM (
							SELECT   y.[PLANT_ID]
									,x.[FACTORY_ID]
									,x.[LINE_ID]
									,x.[EQUIPMENT_ID] -- 2021-09-10 kimcd 설비 정보 추가
									,x.[PROCID]
									,x.[ITEM_ID]
									,x.[YMD_CODE]
									,x.[FCS_INPUT]
									,x.[FCS_GOOD]
									,ROW_NUMBER() OVER ( PARTITION BY y.[PLANT_ID], x.[FACTORY_ID], x.[LINE_ID], x.[PROCID], x.[ITEM_ID], x.[YMD_CODE], x.[EQUIPMENT_ID] -- 2021-09-10 kimcd 설비 정보 추가
															ORDER BY x.[IFSEQNO] DESC ) AS NUM
								FROM [SY_XIF_DW_ITEM_YIELD_R] as x
									   JOIN scm_factory_m as y with(nolock)
									   on x.factory_id = y.factory_id
								WHERE x.TRANSFER_FLAG = 'P'
								AND x.PROCID NOT LIKE 'F%'
								-- 2021-02-17 kimcd DW와 로직 동기화하기 위해 조건 제거 AND FCS_INPUT > 0 --(FCS_INPUT > 0 OR FCS_GOOD > 0)		--2019-11-05 정인천 책임요청으로 투입 수량이 0보다 큰거만
							) A
						WHERE NUM = 1
					) R
				ON (
						H.BASE_YMD		= R.[YMD_CODE]
					AND H.PLANT_ID		= R.PLANT_ID
					AND H.[FACTORY_ID]	= R.[FACTORY_ID]
					AND H.[LINE_ID]		= R.[LINE_ID]
					AND H.[PROCID]		= R.[PROCID]
					AND H.[ITEM_ID]		= R.[ITEM_ID]
					AND H.[EQUIPMENT_ID] = R.[EQUIPMENT_ID] -- 2021-09-10 kimcd 설비 정보 추가
					)
				WHEN MATCHED THEN
				UPDATE
					SET H.INPUT_QTY			= R.[FCS_INPUT]
						,H.GOOD_QTY			= R.[FCS_GOOD]
   						,[MODIFY_USER_ID]	= 'PR_XIF_DW_ITEM_YIELD_R'
						,[MODIFY_DATE]		= GETDATE()
				WHEN NOT MATCHED THEN
				INSERT (
					[PLANT_ID]
					,[FACTORY_ID]
					,[LINE_ID]
					,[EQUIPMENT_ID] -- 2021-09-10 kimcd 설비 정보 추가
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
					,[EQUIPMENT_ID] -- 2021-09-10 kimcd 설비 정보 추가
					,[PROCID]
					,[ITEM_ID]
					,[YMD_CODE]
					,[FCS_INPUT]
					,[FCS_GOOD]
					,'PR_XIF_DW_ITEM_YIELD_R'
					,GETDATE()
					,'PR_XIF_DW_ITEM_YIELD_R'
					,GETDATE()
				)
			;

			UPDATE [dbo].[SY_XIF_DW_ITEM_YIELD_R]
				SET TRANSFER_FLAG = 'Y'
					,TRANSFER_DATE = GETDATE()
				WHERE 1=1	--IFSEQNO       = @P_IFSEQNO
				AND TRANSFER_FLAG = 'P'









	---------------- START 2022-08-31 leeseongmin 일반 DATA 삭제로직 수정 (CSR : C20220831-000137) ---------------
	
	IF EXISTS
    --전월 여부 조건 & F가 아니며 P로 시작하는 대상
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
			AND x.PROCID    NOT LIKE 'F%'
			AND x.PROCID    LIKE 'P%'
			AND x.BASE_YMD   >= CONVERT(NVARCHAR(10), DATEADD(m,-1, DATEADD(d,-day(GETDATE())+1,GETDATE())), 112)  --전월1일보다크고
			AND x.BASE_YMD   < CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 112)   --당월1일보다작다
			AND x.MODIFY_DATE > CONVERT(DATE, GETDATE())
			)

        BEGIN
			--전월데이터가 있으면 전월과 이번달까지삭제
			DELETE x
                     FROM [SY_XIF_DW_YIELD_H] x
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
			AND x.PROCID    NOT LIKE 'F%'
			AND x.PROCID    LIKE 'P%'
			AND x.BASE_YMD   >= CONVERT(NVARCHAR(10), DATEADD(m,-1, DATEADD(d,-day(GETDATE())+1,GETDATE())), 112)
            AND x.MODIFY_DATE < CONVERT(DATE, GETDATE())
           END
       ELSE
	      BEGIN
			DELETE x
                     FROM [SY_XIF_DW_YIELD_H] x
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
			AND x.PROCID    NOT LIKE 'F%'
			AND x.PROCID    LIKE 'P%'
			AND x.BASE_YMD   >= CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 112)
            AND x.MODIFY_DATE < CONVERT(DATE, GETDATE())
            END



    IF EXISTS
    --전월 여부 조건 & F가 아니며 P도 아닌 대상                                    
         ( SELECT TOP 1 x.BASE_YMD   
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
			AND x.PROCID    NOT LIKE 'F%'
			AND x.PROCID    NOT LIKE 'P%'
			AND x.BASE_YMD   >= CONVERT(NVARCHAR(10), DATEADD(m,-1, DATEADD(d,-day(GETDATE())+1,GETDATE())), 112)  --전월1일보다크고
			AND x.BASE_YMD   < CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 112)   --당월1일보다작다
			AND x.MODIFY_DATE > CONVERT(DATE, GETDATE())
			)

         BEGIN
			--전월데이터가 있으면   전월과 이번달까지삭제
			DELETE x
                    FROM [SY_XIF_DW_YIELD_H] x
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
			AND x.PROCID    NOT LIKE 'F%'
			AND x.PROCID    NOT LIKE 'P%'
			AND x.BASE_YMD   >= CONVERT(NVARCHAR(10), DATEADD(m,-1, DATEADD(d,-day(GETDATE())+1,GETDATE())), 112)
            AND x.MODIFY_DATE < CONVERT(DATE, GETDATE())
            END
      ELSE

	        BEGIN
			DELETE x
                     FROM [SY_XIF_DW_YIELD_H] x
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
			AND x.PROCID    NOT LIKE 'F%'
			AND x.PROCID    NOT LIKE 'P%'
			AND x.BASE_YMD   >= CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 112)
            AND x.MODIFY_DATE < CONVERT(DATE, GETDATE())
            END

	---------------- END 2022-08-31 leeseongmin 일반 DATA 삭제로직 수정 (CSR : C20220831-000137) ---------------

			-- 매월 5일에만 실행
			IF '0' = DAY(GETDATE()) -- 2021-07-21 kimcd 미래 월 실적 수율 형성 로직 삭제
				BEGIN
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
							  FROM [dbo].[SY_XIF_DW_YIELD_H] R
							 WHERE r.PLANT_ID IN (
													SELECT SEGMENT1 AS PLANT_ID
													  FROM SCM_SYS_LOOKUP_VALUE
													 WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
													   AND ACTIVE_FLAG = 'Y'
													   AND SEGMENT2 = @P_BASIS_START_TIME
													)
								AND r.INPUT_QTY >= r.GOOD_QTY --(INPUT_QTY > 0 OR GOOD_QTY > 0)		--2019-11-05 PIYONG CHANGE --2019-11-14 PIYONG  CHANGE 
								AND r.INPUT_QTY > 0 -- 2021-02-17 kimcd  기존 자동 산출 수율과 로직 동기화하기 위해 조건 추가
								AND R.PROCID NOT LIKE 'F%'
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

					--2019-10-08 PIYONG ADD END
					---------------------------------------------------------------------------------------------------------------------------------------------------------

			

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
								   ,FCS_GOOD / FCS_INPUT AS YIELD
							  FROM (
			/*						--2019-10-08 PIYONG DELL
									SELECT R.PLANT_ID
										   ,R.FACTORY_ID
										   ,E.LINE_ID
										   ,R.ITEM_ID
										   ,E.COMPANY_ID
										   ,E.DIVISION_ID
										   ,E.SITE_ID
										   ,R.PROCID AS OPERATION_ID
										   ,SUM(R.FCS_GOOD)  AS FCS_GOOD
										   ,SUM(R.FCS_INPUT) AS FCS_INPUT
									  FROM [dbo].[SY_XIF_DW_ITEM_YIELD_R] R
										   ,( SELECT EM.COMPANY_ID
													 ,EM.DIVISION_ID
													 ,EM.SITE_ID
  													 ,EM.PLANT_ID
													 ,EM.FACTORY_ID
													 ,EM.LINE_ID
													 ,EM.MES_LINE_ID
													 ,EM.EQUIPMENT_ID
													 ,EM.OPERATION_ID
												FROM SCM_EQUIPMENT_M EM
											   WHERE EM.ACTIVE_FLAG = 'Y'
												 AND EM.EQUIPMENT_TYPE ='M'
			--									 AND EM.SITE_ID = @L_SITE_ID
																				) E
			/*								--2019-06-17 PIYONG DEL
										   ,( SELECT SEGMENT1 AS FACTORY_ID
													 , SEGMENT2 AS OPERATION_ID
												FROM SCM_SYS_LOOKUP_VALUE
											   WHERE LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
												 AND ACTIVE_FLAG = 'Y'
												 AND ATTRIBUTE6 = 'DW' )  SLV
			*/
									 WHERE 1=1	--R.IFSEQNO       = @P_IFSEQNO
									   AND R.TRANSFER_FLAG = 'P'
			--						   AND R.FCS_GOOD != 0									--2019-06-17 PIYONG DEL
									   AND R.PLANT_ID		= E.PLANT_ID
									   AND R.FACTORY_ID		= E.FACTORY_ID
									   AND R.LINE_ID		= E.MES_LINE_ID
			--						   AND R.EQUIPMENT_ID	= E.EQUIPMENT_ID				--2019-09-26 PIYONG DEL
									   AND R.PROCID			= E.OPERATION_ID
									   AND R.PROCID NOT IN ( 'P5000','P5500','P9500')
									   AND R.PROCID NOT LIKE 'F%'
								--	   AND E.OPERATION_ID	= SLV.OPERATION_ID				--2019-06-17 PIYONG DEL
								--	   AND E.FACTORY_ID		= SLV.FACTORY_ID				--2019-06-17 PIYONG DEL
									 GROUP BY R.PLANT_ID
											,R.FACTORY_ID
											,E.LINE_ID
											,R.ITEM_ID
											,E.COMPANY_ID
											,E.DIVISION_ID
											,E.SITE_ID
											,R.PROCID
			*/
									---------------------------------------------------------------------------------------------------------------------------------------------------------
									--2019-10-08 PIYONG ADD
									SELECT A.PLANT_ID
										   , A.FACTORY_ID
										   , A.LINE_ID
										   , A.ITEM_ID
										   , A.COMPANY_ID
										   , A.DIVISION_ID
										   , A.SITE_ID
										   , A.OPERATION_ID
										   , SUM(A.[GOOD_QTY])  AS FCS_GOOD
										   , SUM(A.[INPUT_QTY]) AS FCS_INPUT
									  FROM (
											SELECT (SELECT COMPANY_ID  FROM SCM_PLANT_M WHERE PLANT_ID = R.PLANT_ID ) AS COMPANY_ID
												   ,(SELECT DIVISION_ID  FROM SCM_PLANT_M WHERE PLANT_ID = R.PLANT_ID ) AS DIVISION_ID
												   ,(SELECT SITE_ID  FROM SCM_PLANT_M WHERE PLANT_ID = R.PLANT_ID ) AS SITE_ID
												   ,R.PLANT_ID
												   ,R.FACTORY_ID
												   ,R.LINE_ID
												   ,R.ITEM_ID
												   ,R.PROCID AS OPERATION_ID
												   ,R.[INPUT_QTY]
												   ,R.[GOOD_QTY]
											  FROM #TEMP_TABLE R --  2021-02-17 kimcd Pack 공정 Union 형태를 한 조회문으로 수정.
											 WHERE NOT EXISTS (
																SELECT 1
																  FROM #MIN_TEMP M
																 WHERE R.PLANT_ID = M.PLANT_ID
																   AND R.FACTORY_ID = M.FACTORY_ID
																   AND R.LINE_ID = M.LINE_ID
																   AND R.PROCID = M.PROCID
																   AND R.ITEM_ID = M.ITEM_ID
															  )
											   AND R_CNT <= @P_SEARCH_TERM
										   ) A
									 GROUP BY A.PLANT_ID
											,A.FACTORY_ID
											,A.LINE_ID
											,A.ITEM_ID
											,A.COMPANY_ID
											,A.DIVISION_ID
											,A.SITE_ID
											,A.OPERATION_ID
									--2019-10-08 PIYONG ADD END
									---------------------------------------------------------------------------------------------------------------------------------------------------------									
								   ) R
							 WHERE R.FCS_INPUT != 0
							   AND R.SITE_ID = @P_SITE_ID
							) A
							,(
								SELECT DISTINCT YEAR+MONTH AS MONTH
								FROM SCM_SYS_CALENDAR_M
								WHERE YEAR+MONTH BETWEEN CONVERT(NVARCHAR(6),GETDATE(), 112)
								AND CONVERT(NVARCHAR(6),DATEADD(MM, 5, GETDATE()), 112)
							) B




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
									 SELECT DISTINCT @COMPANY_ID AS COMPANY_ID
										   ,@DIVISION_ID AS DIVISION_ID
										   ,@SITE_ID AS SITE_ID
										   ,@PLANT_ID AS PLANT_ID
										   ,@FACTORY_ID AS FACTORY_ID
										   ,@OPERATION_ID AS OPERATION_ID
										   ,EP.LINE_ID AS LINE_ID
										   ,@ITEM_ID AS ITEM_ID
										   ,@MONTH AS MONTH
										   ,@YIELD AS YIELD
									 FROM   SCM_EQUIPMENT_M  EP WITH(NOLOCK)
									 WHERE  EP.COMPANY_ID     = @COMPANY_ID
									 AND    EP.DIVISION_ID    = @DIVISION_ID
									 AND    EP.SITE_ID        = @SITE_ID
									 AND    EP.PLANT_ID       = @PLANT_ID
									 AND    EP.FACTORY_ID     = @FACTORY_ID
									 AND    EP.OPERATION_ID   = @OPERATION_ID
									 AND    EP.MES_LINE_ID    = @LINE_ID
									 AND    EP.EQUIPMENT_TYPE = 'M'
									 AND    EP.ACTIVE_FLAG    = 'Y'
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
										,YM.UPDATE_ID	= 'PR_XIF_DW_ITEM_YIELD_R'
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
										,'PR_XIF_DW_ITEM_YIELD_R'
										,GETDATE()
										,'PR_XIF_DW_ITEM_YIELD_R'
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

				END

		COMMIT TRAN

		-- 2021-02-17 kimcd 전월 실적 수율 갱신 과정 추가 시작
			IF '5' <= DAY(GETDATE()) -- 2021-07-21 kimcd 5일 이후 계속 갱신
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
					AND YM.OPERATION_ID NOT LIKE 'F%'
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
							SELECT P.[COMPANY_ID]
								   ,P.[DIVISION_ID]
								   ,P.[SITE_ID]
								   ,R.[PLANT_ID]
								   ,R.[FACTORY_ID]
								   ,R.OPERATION_ID
								   ,R.[LINE_ID]
								   ,R.[ITEM_ID]
								   ,CASE WHEN FCS_GOOD > FCS_INPUT THEN 1.0 ELSE FCS_GOOD / FCS_INPUT END AS YIELD
							  FROM (
									SELECT A.PLANT_ID
										   , A.FACTORY_ID
										   , A.LINE_ID
										   , A.ITEM_ID
										   , CASE WHEN A.PROCID = 'A4000DW' THEN 'A3000' 
										          WHEN A.PROCID = 'A7400DW' THEN  IIF(X.COMPANY_ID = 'G740', 'A7400', 'A7000') 
										          WHEN A.PROCID = 'A8400DW' THEN  IIF(X.COMPANY_ID = 'G740', 'A8400', 'A8000') 
										          ELSE A.PROCID 
											 END AS OPERATION_ID -- 2021-09-10 kimcd A4000DW 공정으로 집계되는 수율을 Assembly 공정 수율로 집계
										   , SUM(A.[GOOD_QTY])  AS FCS_GOOD
										   , SUM(A.[INPUT_QTY]) AS FCS_INPUT
									  FROM [SY_XIF_DW_YIELD_H] A (NOLOCK)
									       JOIN SCM_FACTORY_M AS X WITH(NOLOCK)
										ON A.FACTORY_ID = X.FACTORY_ID
									   AND A.PLANT_ID = X.PLANT_ID
									 WHERE A.PLANT_ID IN (
													SELECT SLV.SEGMENT1 AS PLANT_ID
													  FROM SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
													     , SCM_PLANT_M          P   (NOLOCK)
													 WHERE P.PLANT_ID = SLV.SEGMENT1
													   AND SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
													   AND SLV.ACTIVE_FLAG = 'Y'
													   AND SLV.SEGMENT2 = @P_BASIS_START_TIME
													   AND P.SITE_ID = @P_SITE_ID
													)
										AND A.PROCID NOT LIKE 'F%'
										AND A.PROCID != 'E2000' -- 2021-09-10 kimcd Coater 공정은 설비별로 구분하기 위해 별도 작업으로 분리
										AND A.BASE_YMD >=	CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()) - 1, 0), 112)
										AND A.BASE_YMD <	CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 112)
									 GROUP BY A.PLANT_ID
											,A.FACTORY_ID
											,A.LINE_ID
											,A.ITEM_ID
											,CASE WHEN A.PROCID = 'A4000DW' THEN 'A3000' 
										          WHEN A.PROCID = 'A7400DW' THEN  IIF(X.COMPANY_ID = 'G740', 'A7400', 'A7000') 
										          WHEN A.PROCID = 'A8400DW' THEN  IIF(X.COMPANY_ID = 'G740', 'A8400', 'A8000') 
										          ELSE A.PROCID 
											 END -- 2021-09-10 kimcd A4000DW 공정으로 집계되는 수율을 Assembly 공정 수율로 집계
									) R, 
									SCM_PLANT_M          P   (NOLOCK)
							 WHERE R.PLANT_ID = P.PLANT_ID
							   AND R.FCS_INPUT != 0
							   AND P.SITE_ID = @P_SITE_ID
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
									 SELECT DISTINCT @COMPANY_ID AS COMPANY_ID
										   ,@DIVISION_ID AS DIVISION_ID
										   ,@SITE_ID AS SITE_ID
										   ,@PLANT_ID AS PLANT_ID
										   ,@FACTORY_ID AS FACTORY_ID
										   ,@OPERATION_ID AS OPERATION_ID
										   ,EP.LINE_ID AS LINE_ID
										   ,@ITEM_ID AS ITEM_ID
										   ,@MONTH AS MONTH
										   ,@YIELD AS YIELD
									 FROM   SCM_EQUIPMENT_M  EP WITH(NOLOCK)
									 WHERE  EP.COMPANY_ID     = @COMPANY_ID
									 AND    EP.DIVISION_ID    = @DIVISION_ID
									 AND    EP.SITE_ID        = @SITE_ID
									 AND    EP.PLANT_ID       = @PLANT_ID
									 AND    EP.FACTORY_ID     = @FACTORY_ID
									 AND    EP.OPERATION_ID   = @OPERATION_ID
									 AND    EP.MES_LINE_ID    = @LINE_ID
									 AND    EP.EQUIPMENT_TYPE = 'M'
									 AND    EP.ACTIVE_FLAG    = 'Y'
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
										,YM.UPDATE_ID	= 'PR_XIF_DW_ITEM_YIELD_R'
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
										,'PR_XIF_DW_ITEM_YIELD_R'
										,GETDATE()
										,'PR_XIF_DW_ITEM_YIELD_R'
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

					-- 2021-09-10 kimcd Coater 설비 연계하여 라인 구분 시작
					DECLARE CUR_COATER_RESULT_YIELD CURSOR FOR
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
							SELECT P.[COMPANY_ID]
								   ,P.[DIVISION_ID]
								   ,P.[SITE_ID]
								   ,R.[PLANT_ID]
								   ,R.[FACTORY_ID]
								   ,R.OPERATION_ID
								   ,R.[LINE_ID]
								   ,R.[ITEM_ID]
								   ,CASE WHEN FCS_GOOD > FCS_INPUT THEN 1.0 ELSE FCS_GOOD / FCS_INPUT END AS YIELD
							  FROM (
									SELECT A.PLANT_ID
										   , A.FACTORY_ID
 										   , EP.LINE_ID AS LINE_ID
										   , A.ITEM_ID
										   , A.PROCID           AS OPERATION_ID
										   , SUM(A.[GOOD_QTY])  AS FCS_GOOD
										   , SUM(A.[INPUT_QTY]) AS FCS_INPUT
									  FROM [SY_XIF_DW_YIELD_H] A (NOLOCK)
										   , SCM_EQUIPMENT_M   EP WITH(NOLOCK)
									 WHERE  1 = 1
									 and    EP.PLANT_ID       = A.PLANT_ID
									 AND    EP.FACTORY_ID     = A.FACTORY_ID
									 AND    EP.OPERATION_ID   = A.PROCID
									 AND    EP.MES_LINE_ID    = A.LINE_ID
									 AND    EP.EQUIPMENT_ID   = A.EQUIPMENT_ID
									 AND    EP.EQUIPMENT_TYPE = 'M'
									 AND    EP.ACTIVE_FLAG    = 'Y'
									 AND    A.PLANT_ID IN (
													SELECT SLV.SEGMENT1 AS PLANT_ID
													  FROM SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
													     , SCM_PLANT_M          P   (NOLOCK)
													 WHERE P.PLANT_ID = SLV.SEGMENT1
													   AND SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
													   AND SLV.ACTIVE_FLAG = 'Y'
													   AND SLV.SEGMENT2 = @P_BASIS_START_TIME
													   AND P.SITE_ID = @P_SITE_ID
													)
										AND A.PROCID = 'E2000'
										AND A.BASE_YMD >=	CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()) - 1, 0), 112)
										AND A.BASE_YMD <	CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 112)
									 GROUP BY A.PLANT_ID
											,A.FACTORY_ID
											,EP.LINE_ID
											,A.ITEM_ID
											,A.PROCID
									) R, 
									SCM_PLANT_M          P   (NOLOCK)
							 WHERE R.PLANT_ID = P.PLANT_ID
							   AND R.FCS_INPUT != 0
							   AND P.SITE_ID = @P_SITE_ID
							) A
							,(
								SELECT CONVERT(NVARCHAR(6),DATEADD(M,-1,GETDATE()),112)AS MONTH
							) B




					OPEN CUR_COATER_RESULT_YIELD;
					FETCH NEXT FROM CUR_COATER_RESULT_YIELD INTO @COMPANY_ID
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
							USING (SELECT    @COMPANY_ID     AS COMPANY_ID
											,@DIVISION_ID    AS DIVISION_ID
											,@SITE_ID        AS SITE_ID
											,@PLANT_ID       AS PLANT_ID
											,@FACTORY_ID     AS FACTORY_ID
											,@OPERATION_ID   AS OPERATION_ID
											,@LINE_ID        AS LINE_ID
											,@ITEM_ID        AS ITEM_ID
											,@MONTH          AS MONTH
											,@YIELD          AS YIELD
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
										,YM.UPDATE_ID	= 'PR_XIF_DW_ITEM_YIELD_R'
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
										,'PR_XIF_DW_ITEM_YIELD_R'
										,GETDATE()
										,'PR_XIF_DW_ITEM_YIELD_R'
										,GETDATE()
								)
							;
	
							SET @ROWCOUNT = @@ROWCOUNT
			 				   	
							FETCH NEXT FROM CUR_COATER_RESULT_YIELD INTO @COMPANY_ID
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

					CLOSE CUR_COATER_RESULT_YIELD;
					DEALLOCATE CUR_COATER_RESULT_YIELD;
					-- 2021-09-10 kimcd Coater 설비 연계하여 라인 구분 끝

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
                    FROM  ( SELECT  A.FACTORY_ID
							      , A.LINE_ID
								  , A.ITEM_ID
								  , CASE WHEN A.PROCID = 'A4000DW' THEN 'A3000' 
								         WHEN A.PROCID = 'A7400DW' THEN  IIF(X.COMPANY_ID = 'G740', 'A7400', 'A7000') 
								         WHEN A.PROCID = 'A8400DW' THEN  IIF(X.COMPANY_ID = 'G740', 'A8400', 'A8000') 
								         ELSE A.PROCID 
								    END                     AS [OPERATION_ID]
								  , SUM(A.[GOOD_QTY])       AS [GOOD_QTY]
								  , SUM(A.[INPUT_QTY])      AS [INPUT_QTY]
								  , MAX(SLVFS.ATTRIBUTE1)   AS [FP_SOURCE_CODE]
							FROM  [SY_XIF_DW_YIELD_H] AS A (NOLOCK)
								  INNER JOIN SCM_FACTORY_M AS X WITH(NOLOCK)
								      ON  A.FACTORY_ID = X.FACTORY_ID
									  AND A.PLANT_ID   = X.PLANT_ID
								  INNER JOIN SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
									  ON A.PLANT_ID = SLV.SEGMENT1
								  INNER JOIN  [DBO].[SCM_SYS_LOOKUP_VALUE]  SLVFS WITH(NOLOCK)
						              ON X.COMPANY_ID = SLVFS.SEGMENT1
							WHERE SLVFS.LOOKUP_TYPE_CODE = 'COMPANY_FP_SYSTEM_CODE'
						    AND   SLVFS.ACTIVE_FLAG      = 'Y'
							AND   SLV.LOOKUP_TYPE_CODE   = 'BASIS_START_TIME_PLANT'
							AND   SLV.ACTIVE_FLAG        = 'Y'
							AND   SLV.SEGMENT2           = @P_BASIS_START_TIME
							AND   X.SITE_ID              = @P_SITE_ID
							AND   A.PROCID        NOT LIKE 'F%'
							AND   A.PROCID              != 'E2000' -- Coater 공정은 FP 라인 기준으로 취합
							AND   A.BASE_YMD            >= CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()) - 1, 0), 112)
							AND   A.BASE_YMD             < CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 112)
							GROUP BY A.PLANT_ID
									,A.FACTORY_ID
									,A.LINE_ID
									,A.ITEM_ID
									,CASE WHEN A.PROCID = 'A4000DW' THEN 'A3000' 
								          WHEN A.PROCID = 'A7400DW' THEN  IIF(X.COMPANY_ID = 'G740', 'A7400', 'A7000') 
								          WHEN A.PROCID = 'A8400DW' THEN  IIF(X.COMPANY_ID = 'G740', 'A8400', 'A8000') 
								          ELSE A.PROCID 
									 END
							UNION ALL
							SELECT  A.FACTORY_ID
 								  , EP.LINE_ID            AS [LINE_ID]
								  , A.ITEM_ID
								  , A.PROCID              AS [OPERATION_ID]
								  , SUM(A.[GOOD_QTY])     AS [GOOD_QTY]
								  , SUM(A.[INPUT_QTY])    AS [INPUT_QTY]
								  , MAX(SLVFS.ATTRIBUTE1) AS [FP_SOURCE_CODE]
							FROM  [SY_XIF_DW_YIELD_H] A (NOLOCK)
								  INNER JOIN SCM_EQUIPMENT_M   EP WITH(NOLOCK)
								      ON  EP.PLANT_ID       = A.PLANT_ID
									  AND EP.FACTORY_ID     = A.FACTORY_ID
									  AND EP.OPERATION_ID   = A.PROCID
									  AND EP.MES_LINE_ID    = A.LINE_ID
									  AND EP.EQUIPMENT_ID   = A.EQUIPMENT_ID
									  AND EP.EQUIPMENT_TYPE = 'M'
									  AND EP.ACTIVE_FLAG    = 'Y'
								  INNER JOIN SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
									  ON A.PLANT_ID = SLV.SEGMENT1
								  INNER JOIN SCM_PLANT_M          P   (NOLOCK)
									  ON P.PLANT_ID = SLV.SEGMENT1
								  INNER JOIN  [DBO].[SCM_SYS_LOOKUP_VALUE]  SLVFS WITH(NOLOCK)
						              ON P.COMPANY_ID = SLVFS.SEGMENT1
							WHERE SLV.LOOKUP_TYPE_CODE   = 'BASIS_START_TIME_PLANT'
							AND   SLV.ACTIVE_FLAG        = 'Y'
							AND   SLVFS.LOOKUP_TYPE_CODE = 'COMPANY_FP_SYSTEM_CODE'
						    AND   SLVFS.ACTIVE_FLAG      = 'Y'
							AND   SLV.SEGMENT2           = @P_BASIS_START_TIME
						    AND   P.SITE_ID              = @P_SITE_ID
							AND   A.PROCID               = 'E2000'
							AND   A.BASE_YMD            >= CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()) - 1, 0), 112)
							AND   A.BASE_YMD             < CONVERT(NVARCHAR(10), DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 112)
							GROUP BY A.PLANT_ID
								    ,A.FACTORY_ID
								    ,EP.LINE_ID
								    ,A.ITEM_ID
								    ,A.PROCID ) A;
					-- 2024-03-06 kimcd  WA.FP로 전월 실적 수율 전송 과정 추가 끝
				END;
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