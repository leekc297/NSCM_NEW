
CREATE PROCEDURE [dbo].[PR_XIF_SCM_IN_TRANSIT_R]

-- ================================================================================================
-- Program ID          : FP00671 Receive SCP In-Transit
-- Program Name        : PR_XIF_SCM_IN_TRANSIT_R
-- Param               :
-- Batch Period        : 1 HOUR
-- Description         :
--
-- Source System       : SCP SDB
-- Destination System  : FP SDB
-- Source Table        : IF_FP_SCM_IN_TRANSIT_V SCM의 SCM_DNM_INTRANSIT_V 
--						 scm_dnm_intransit_c scm_dnm_stock_v
-- Destination Table   : FP_SCM_IN_TRANSIT_H
--
-- Create(Update) Date : 2021.10.06
-- Author              : KIMCD
-- Version             : 1.0 2019-11-07 kimcd  화면에서 SCP In-Transit 직접 조회하면 속도 늦어 별도 정보 형성함
--                       1.1 2019-11-11 kimcd  일별 최종 수신 정보로 in-transit 정보 갱신
--                       1.2 2020-07-16 kimcd  조회 View를 SCM_DNM_INTRANSIT_V에서 SCM_DNM_INTRANSIT_FP_V로 수정
--                       1.3 2021-10-06 kimcd  조회 View를 SCM_DNM_INTRANSIT_FP_V에서 SCM_DNM_INTRANSIT_V로 복원
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SCM_IN_TRANSIT_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	--LOGCAL 변수
	DECLARE @BASE_DATE	NVARCHAR(8)
	DECLARE @FROM_DATE	NVARCHAR(8)  -- 2019-11-11 kimcd 일자 검색 범위 제한

	DECLARE C_DATE CURSOR FOR
		SELECT DISTINCT CONVERT(NVARCHAR(8), DATEADD(D,-1,DBO.FN_SITE_TIME(SITE_ID)), 112) AS KEY_DATE
		              , CONVERT(NVARCHAR(8), DATEADD(D,-4,DBO.FN_SITE_TIME(SITE_ID)), 112) AS FROM_DATE  -- 2019-11-11 kimcd 일자 검색 범위 제한
		FROM [SCM_SITE_M] (NOLOCK)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN

		OPEN C_DATE
		FETCH NEXT FROM C_DATE INTO @BASE_DATE
		                          , @FROM_DATE	-- 2019-11-11 kimcd 일자 검색 범위 제한

		WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
			BEGIN

				DELETE
				FROM  FP_SCM_IN_TRANSIT_H
				WHERE RESULT_DATE = @BASE_DATE;

		                                                                                                                
				INSERT INTO FP_SCM_IN_TRANSIT_H
				 ( [RESULT_DATE]
				  ,[COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[ITEM_ID]
				  ,[DELIVERY_QTY]
				  ,[ETA_DATE]
				  ,[PLANT_ISSUE_DATE]
				  ,[FROM_SCM_SITE_ID]
				  ,[FROM_PLANT_ID]
				  ,[UOM]
				  ,[TRANSPORT_MODE]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
				  )
				SELECT @BASE_DATE AS [RESULT_DATE],
					   P.COMPANY_ID,
					   DI.DIVISION_ID,
					   P.SITE_ID,
					   P.PLANT_ID,
					   DI.ITEM_ID,
					   DI.DELIVERY_QTY,
					   DI.ETA_DATE,
					   DI.PLANT_ISSUE_DATE,
					   DI.FROM_SCM_SITE_ID,
					   S.PLANT_ID AS FROM_PLANT_ID,
					   DI.UOM,
					   DI.TRANSPORT_MODE,
					   @v_proc_name,
					   GETDATE(),
					   @v_proc_name,
					   GETDATE()
				FROM   LGCE_SCMDEV.DBO.SCM_DNM_INTRANSIT_V  DI  -- 2021-10-06 KIMCD SCM_DNM_INTRANSIT_V 복원 2020-07-16 kimcd SCM_DNM_INTRANSIT_V 에서 SCM_DNM_INTRANSIT_FP_V로 소스 변경
					   LEFT OUTER JOIN SCM_PLANT_M          S WITH(NOLOCK)
					   ON S.PLANT_ID = SUBSTRING(DI.FROM_SCM_SITE_ID,1,4)
					   -- 2021-10-06 KIMCD 최종 정보 조건 사용 2020-07-16 kimcd 일자 범위 조건 제거 SCM_DNM_INTRANSIT_FP_V에서는 result date 없음
					  ,( SELECT RESULT_TYPE, COMPANY_ID, DIVISION_ID, PLANT_ID, MAX(RESULT_DATE) AS RESULT_DATE
						 FROM  LGCE_SCMDEV.DBO.SCM_DNM_INTRANSIT_C WITH(NOLOCK)
						 WHERE RESULT_DATE >= @FROM_DATE
						 AND   RESULT_DATE <= @BASE_DATE
						 AND   RESULT_TYPE IN ( 'C', 'I', 'S')
						 GROUP BY RESULT_TYPE, COMPANY_ID, DIVISION_ID, PLANT_ID ) DIS  -- 2019-11-12 kimcd 3일 이내 수신된 정보 중 최신 일자 추출
					  ,SCM_PLANT_M          P WITH(NOLOCK)
				WHERE  1=1
				AND    DI.RESULT_DATE = DIS.RESULT_DATE
				AND    DI.RESULT_TYPE = DIS.RESULT_TYPE
				AND    DI.COMPANY_ID  = DIS.COMPANY_ID
				AND    DI.DIVISION_ID = DIS.DIVISION_ID
				AND    DI.PLANT_ID    = DIS.PLANT_ID  -- 2021-10-06 KIMCD 최신 정보 조회 조건 복원 2020-07-16 신규 View에는 result date 값 없음. 정보만 수신하면 됨.
				AND    P.PLANT_ID = SUBSTRING(DI.TO_SCM_SITE_ID,1,4)
				AND    DI.SITE_TYPE = 'PLANT'  -- 2019-11-12 kimcd 조회문장 재구성 
				;

				FETCH NEXT FROM C_DATE INTO @BASE_DATE
				                          , @FROM_DATE	-- 2019-11-11 kimcd 일자 검색 범위 제한

			END  -- WHILE @@FETCH_STATUS = 0  C_SITE
		CLOSE C_DATE;
		DEALLOCATE C_DATE;   -- 메모리 해제

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, @v_temp2, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
