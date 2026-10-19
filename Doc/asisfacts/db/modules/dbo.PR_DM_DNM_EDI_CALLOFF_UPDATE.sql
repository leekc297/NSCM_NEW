/*
 * Program ID  : PR_DM_DNM_EDI_CALLOFF_UPDATE
 * Description  : DM_DNM_EDI_CALLOFF 테이블 (SENDER_CODE, SENDER_NAME) NULL인 과거 데이터 소급 적용
 * Program History
 *============================================================================================================
 *   Date       In Charge              Description
 *============================================================================================================
 * 2023-01-18 	kdmcc14	[E20230118-000139]	    DM_DNM_EDI_CALLOFF_ITEM SENDER_CODE 누락건 매핑 작업
 * 2023-02-07 	kdmcc14	[E20230207-000316] 	EDI SENDER CODE 수신받기 전 데이터에 대한 SENDER_CODE 누락 데이터 소급 적용

** -----------------------------------------------------------------------------------------------------------
*/

-- EXEC PR_DM_DNM_EDI_CALLOFF_UPDATE

CREATE PROCEDURE [dbo].[PR_DM_DNM_EDI_CALLOFF_UPDATE]
AS
BEGIN 
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_DNM_EDI_CALLOFF_UPDATE';
	DECLARE @v_batch_user	NVARCHAR(150) = 'EDI_CALLOFF';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE	@v_OK_description		NVARCHAR(1200);	-- cut off Generated Number	
	
	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = N'EDI 신규컬럼 데이터 이관 및 소급 적용'
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

BEGIN TRY

	BEGIN

	--1. INDEX 생성작업 전
	UPDATE A
		  SET SOLDTO_CODE = ISNULL(SOLDTO_CODE, '')
			   , COMPANY_ID = ISNULL(COMPANY_ID, '')
			   , SHIPTO_CODE = ISNULL(SHIPTO_CODE, '')
			   , ITEM_ID = ISNULL(ITEM_ID, '')
			   , IFSEQNO = ISNULL(IFSEQNO, '')
	FROM DM_DNM_EDI_CALLOFF_ITEM A

/*
PRINT N'신규컬럼 데이터 이관 START : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)

		--신규컬럼 데이터 이관
		UPDATE A
			  SET ITEM_ID = ISNULL(ITEM_ID, '')
				   ,IFSEQNO = A.ATTRIBUTE2
				   ,SOLDTO_CODE_W = ISNULL(A.ATTRIBUTE3, '')
				   ,MESSAGE_TYPE_W = ISNULL(A.ATTRIBUTE4, '')
				   ,RDD_START_W = ISNULL(A.ATTRIBUTE5, '')
				   ,DOC_STATUS  = ISNULL(A.ATTRIBUTE6, '')
				   ,PROJECT_CODE = ISNULL(A.ATTRIBUTE7, '')
				   ,SCM_SITE_ID = ISNULL(A.ATTRIBUTE8, '')
				   ,SALES_PLANT_SITE_ID = ''
				   ,EDI_INCOTERMS = ''
				   ,STATUS_CODE = (CASE WHEN ATTRIBUTE1 = 'COMPLETED' THEN 'S'											 
													 ELSE 'U' END)
				   ,BOM_STATUS = (CASE WHEN ATTRIBUTE1 = 'COMPLETED' THEN 'S'
													ELSE 'E' END)
				   ,SALES_SITE_STATUS = (CASE WHEN ATTRIBUTE1 = 'COMPLETED' THEN 'S'
															ELSE 'E' END)
				   ,SSPM_STATUS = (CASE WHEN ATTRIBUTE1 = 'COMPLETED' THEN 'S'
													 ELSE 'E' END)
				   ,PROJECT_STATUS = (CASE WHEN ATTRIBUTE1 = 'COMPLETED' THEN 'S'
														 ELSE 'E' END)
				   ,ITEM_STATUS = (CASE WHEN ATTRIBUTE1 = 'COMPLETED' THEN 'S'
													ELSE 'E' END)
				   ,SALES_PLANT_SITE_STATUS = (CASE WHEN ATTRIBUTE1 = 'COMPLETED' THEN 'S'
																	  ELSE 'E' END)
				   ,INCOTERMS_STATUS = (CASE WHEN ATTRIBUTE1 = 'COMPLETED' THEN 'S'
															  ELSE 'E' END)
				   ,BASIS_YYYYMMDD = ''
				   ,EDI_LT = 0
				   ,ERP_STATUS = (CASE WHEN ISNULL(RDD_START, '') = '' OR LEN(RDD_START) <> 8 THEN 'E'
										  WHEN ISNULL(SOLDTO_CODE, '') = '' OR ISNULL(SHIPTO_CODE, '') = '' OR ISNULL(ITEM_ID, '') = '' THEN 'ING_ERP' 
										  ELSE 'ING_GSCM' END)
		FROM DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK)

PRINT N'신규컬럼 데이터 이관 END : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)
*/

/* --이미 처리함
PRINT N'XIF_EDI_CALLOFF_ITEM_R 데이터 이관 START : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)

		UPDATE XIF_ERP_EDI_CALLOFF_HEAD_R_SN
		SET TRANSACTION_FLAG = (CASE WHEN ISNULL(TRANSFER_FLAG, '') = '' THEN 'N'
														ELSE TRANSFER_FLAG END)

		UPDATE XIF_ERP_EDI_CALLOFF_PARTNER_R_SN
		SET TRANSACTION_FLAG = (CASE WHEN ISNULL(TRANSFER_FLAG, '') = '' THEN 'N'
														ELSE TRANSFER_FLAG END)

		UPDATE XIF_ERP_EDI_CALLOFF_ITEM_R_SN
		SET TRANSACTION_FLAG = (CASE WHEN ISNULL(TRANSFER_FLAG, '') = '' THEN 'N'
														ELSE TRANSFER_FLAG END)

PRINT N'XIF_EDI_CALLOFF_ITEM_R 데이터 이관 END : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)
*/
/*
PRINT N'SALES_PLANT_SITE_ID 신규 컬럼 데이터 1차 생성 START : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)
		--SALES_PLANT_SITE_ID 신규 컬럼 데이터 1차 생성
		UPDATE DM_DNM_EDI_CALLOFF_ITEM 
		SET SALES_PLANT_SITE_ID = ISNULL((CASE SUBSTRING(DM_DNM_EDI_CALLOFF_ITEM.ITEM_ID,2,1) WHEN 'P' THEN B.SHIP_FROM_PLANT+'-P' 
																																	 		  WHEN 'M' THEN B.SHIP_FROM_PLANT+'-P' 
																																			  WHEN 'C' THEN B.SHIP_FROM_PLANT+'-A' 
																																			  ELSE B.SHIP_FROM_PLANT+'-A' END), '')
		FROM DM_DNM_EDI_CALLOFF_PARTNER B
		WHERE DM_DNM_EDI_CALLOFF_ITEM.EDI_IF_SEQ = B.EDI_IF_SEQ
		AND DM_DNM_EDI_CALLOFF_ITEM.SOLDTO_CODE = B.SOLDTO_CODE
		AND DM_DNM_EDI_CALLOFF_ITEM.SHIPTO_CODE = B.SHIPTO_CODE

		UPDATE DM_DNM_EDI_CALLOFF_ITEM
		SET SALES_PLANT_SITE_STATUS = (CASE WHEN ISNULL(SALES_PLANT_SITE_ID, '') = '' THEN 'E'
													    ELSE 'S' END)
		

PRINT N'SALES_PLANT_SITE_ID 신규 컬럼 데이터 1차 생성 START : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)
*/
/*
PRINT N'EDI STATUS 체크 START : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)

		--EDI STATUS 체크
		EXEC PR_DM_DNM_EDI_CALLOFF_STATUS

PRINT N'EDI STATUS 체크 END : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)		
*/
/*
PRINT N'SALES_PLANT_SITE_ID 신규 컬럼 데이터 2차 생성 START : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)
		--SALES_PLANT_SITE_ID 신규 컬럼 데이터 2차 생성
		UPDATE A 
		SET SALES_PLANT_SITE_ID = (SELECT TOP 1 CASE SUBSTRING(ITEM_ID, 2, 1) WHEN 'P' THEN SALES_PLANT+'-P' 
																												  WHEN 'M' THEN SALES_PLANT+'-P' 
																												  WHEN 'C' THEN SALES_PLANT+'-A' 
																										ELSE SALES_PLANT+'-A' END 
												FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
												WHERE SCM_SITE_ID = A.SCM_SITE_ID 
												AND ITEM_ID = A.ITEM_ID 
												AND VALID_YN = 'Y' )
		FROM DM_DNM_EDI_CALLOFF_ITEM A				
		WHERE ISNULL(SALES_PLANT_SITE_ID, '') = ''

		UPDATE DM_DNM_EDI_CALLOFF_ITEM
		SET SALES_PLANT_SITE_STATUS = 'S'
		WHERE ISNULL(SALES_PLANT_SITE_ID, '') <> ''
		AND SALES_PLANT_SITE_STATUS = 'E'

PRINT N'SALES_PLANT_SITE_ID 신규 컬럼 데이터 2차 생성 START : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)
*/
/*
PRINT N'BASIS_YYYYYMMDD 신규 컬럼 데이터 생성 START : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)

		--BASIS_YYYYYMMDD 신규 컬럼 데이터 생성		
		--1. 월, 일 날짜가 00인 데이터
		UPDATE DM_DNM_EDI_CALLOFF_ITEM
		SET BASIS_YYYYMMDD = YYYYMMDD
		WHERE (SUBSTRING(YYYYMMDD, 7, 2) = '00' OR SUBSTRING(YYYYMMDD, 5, 2) = '00')

		--2. RDD_START 444444인 데이터
		UPDATE DM_DNM_EDI_CALLOFF_ITEM
		SET BASIS_YYYYMMDD = YYYYMMDD
		WHERE LEN(YYYYMMDD) <> 8

		--3. EDI_LT가 0인 데이터
		UPDATE DM_DNM_EDI_CALLOFF_ITEM
		SET BASIS_YYYYMMDD = YYYYMMDD
		WHERE LEN(YYYYMMDD) = 8 
		AND EDI_LT = 0
*/

-------------------------------------------------------
/* --------하지말것
		--4. EDI_LT가 0이 아닌 데이터		
		-- 테이블중복제거
		IF OBJECT_ID (N'tempdb..#TEMP_EDI_ALL', N'U')			IS NOT NULL	DROP TABLE #TEMP_EDI_ALL			

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID (N'dbo.#TEMP_EDI_ALL', N'U')					IS NOT NULL	DROP TABLE #TEMP_EDI_ALL				

		--#TEMP_EDI_NEW_ALL	
		CREATE TABLE #TEMP_EDI_ALL	(
			NUM					INT	NULL,
			IFSEQNO			NVARCHAR(35)	NULL);

		INSERT INTO #TEMP_EDI_ALL ( NUM, IFSEQNO )
		SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS NUM
				 , IFSEQNO 
		FROM DM_DNM_EDI_CALLOFF_ITEM WITH(NOLOCK)
		WHERE ISNULL(BASIS_YYYYMMDD, '') = ''
AND CREATE_DATE >= CONVERT(CHAR(8), DATEADD(DD, -10, DBO.FN_NEXT_DAY(CONVERT(VARCHAR,GETDATE(),112), 'MON')), 112)
		GROUP BY IFSEQNO
		ORDER BY IFSEQNO

		DECLARE @i INT = 1, @CNT INT = 0
		DECLARE @V_IFSEQNO NVARCHAR(35)

		SET @i = 1
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		SELECT @CNT = COUNT(*) FROM #TEMP_EDI_ALL

		WHILE (@i <= @CNT)
		BEGIN

			SELECT @V_IFSEQNO = IFSEQNO FROM #TEMP_EDI_ALL
			WHERE NUM = @i

PRINT CONVERT(NVARCHAR(10), @i) + ', ' + CONVERT(NVARCHAR(10), @CNT) + ',' + @V_IFSEQNO

			UPDATE DM_DNM_EDI_CALLOFF_ITEM
			SET BASIS_YYYYMMDD = CONVERT(CHAR(8), dbo.FN_NEXT_WORK_DAY(YYYYMMDD, EDI_LT * -1), 112) 			
			WHERE IFSEQNO = @V_IFSEQNO			
			AND ISNULL(BASIS_YYYYMMDD, '') = ''

			SET @i = @i + 1

		END

PRINT N'BASIS_YYYYYMMDD 신규 컬럼 데이터 생성 END : ' + CONVERT(NVARCHAR(30), GETDATE(), 121)
*/
	END

	--EXEC PR_DM_DNM_EDI_CALLOFF_UPDATE

END TRY
BEGIN CATCH
	
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END CATCH

	    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = N'EDI 신규컬럼 데이터 이관 및 소급 적용'
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


END




