
/*
 * Program ID   : SCP0115_EXCEL_UPLOAD
 * Description  : SCP0115_EXCEL_UPLOAD
 * Program History 
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 /* 2025-03-25   dsiol         긴급 개발 요청...(?) */  
 --EXEC [SCP0115_EXCEL_UPLOAD] 0, 'dsiol'

 */ 

CREATE PROCEDURE [dbo].[SCP0115_EXCEL_UPLOAD]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)		

AS


BEGIN
	SET NOCOUNT ON;
	DECLARE @v_program_id     AS NVARCHAR(40) = 'SCP0115';
    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'Policy Inv Management';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_division		AS NVARCHAR(10); 

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0115_EXCEL_UPLOAD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	SELECT @v_creation_date = CONVERT(NVARCHAR(40), MAX(T.CREATION_DATE), 121)
	FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T WITH(NOLOCK)
	WHERE  T.PROGRAM_ID = @v_program_id
	AND    T.SHEET_NAME = @v_sheet_name
	AND    T.CREATED_BY = @p_created_by;
	--  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';

	IF @v_creation_date IS NULL BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'Data Not Found [' + CONVERT(CHAR(19), @v_creation_date, 121) +']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END
	-- @p_mode = 0 이면 Validation Check (1. UPLOAD_STATUS_CODE 정의)
	IF ISNULL(@p_mode, 0) = 0 BEGIN	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--EXCEL 업로드시 Validation Check 할 동안 임시적으로 UPLOAD로 UPDATE한다.
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'UPLOAD'
             , MESSAGE_TEXT       = NULL             
        FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
		WHERE  T.PROGRAM_ID    = @v_program_id
        AND    T.SHEET_NAME    = @v_sheet_name
        AND    T.CREATED_BY    = @p_created_by
        AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
        AND    ISNULL(T.UPLOAD_STATUS_CODE,'X') != 'UPLOAD';
    	END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
	    SET @v_log_type = '1';
	    SET @v_log_message = '########## RESET Status = UPLOAD ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--EXCEL에서 값이 입력되지 않은 것은 SKIP 하는건데 기준은 ATTRIBUTE1이 비었으면 실행한다. (TOTAL 일단 무시..)
		BEGIN
	    UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'SKIP'
        WHERE  PROGRAM_ID    = @v_program_id
        AND    SHEET_NAME    = @v_sheet_name
        AND    CREATED_BY    = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    ATTRIBUTE2  IS NULL OR ATTRIBUTE2  = '' ;
	            
		END;

	    BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
		SET @v_log_type = '2';
		SET @v_log_message = '########## SKIP EMPTY LINE ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
				SET    ATTRIBUTE1 = ATTRIBUTE2 +'-'+ CAST( NEXT VALUE FOR SEQ1_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN AS NVARCHAR)
				WHERE  PROGRAM_ID         = @v_program_id
				AND    SHEET_NAME         = @v_sheet_name
				AND    CREATED_BY         = @p_created_by
				AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121)  = @v_creation_date
				AND    ATTRIBUTE1 = ''
				AND    UPLOAD_STATUS_CODE = 'UPLOAD';	


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--EXCEL에서 첫 행 (HEADER 정보를 가져오기 위함 =UPLOAD_STATUS_CODE 값이 @TITLE 인것)

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
		SET    UPLOAD_STATUS_CODE = '@TITLE'
		WHERE  PROGRAM_ID    = @v_program_id
		AND    SHEET_NAME    = @v_sheet_name
		AND    CREATED_BY    = @p_created_by
		AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
		AND    ATTRIBUTE1 = 'Request No.'; -- EXCEL기준 A1 , A2 에 해당하는 값이 Plan Date인 행을 @TITLE로 업데이트 함.  
		END;

		BEGIN
		------------------------------------------------------------------------
		--scm2_mgr.xLOG('@TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
		SET @v_log_type = '3';
		SET @v_log_message = '########## TITLE Header Line ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		------------------------------------------------------------------------
		END;
	END;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------프로시저에서 사용되는 공용 임시테이블 - 시작-----------------------------------------------

			--IF OBJECT_ID(N'tempdb..#TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION', N'U') IS NOT NULL
			--	DROP TABLE #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION
			IF OBJECT_ID(N'tempdb..#TEMP_SCM_LGTM_OCCR_RSN_CD', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_LGTM_OCCR_RSN_CD
			IF OBJECT_ID(N'tempdb..#TEMP_SCM_LGTM_EXHT_TP_CD', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_LGTM_EXHT_TP_CD
			IF OBJECT_ID(N'tempdb..#TEMP_SCM_LGTM_PLAN_TP_CD', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_LGTM_PLAN_TP_CD

			-- 임시확인용테이블 중복제거
			--IF OBJECT_ID(N'dbo.#TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION', N'U') IS NOT NULL
			--	DROP TABLE #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION
			IF OBJECT_ID(N'dbo.#TEMP_SCM_LGTM_OCCR_RSN_CD', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_LGTM_OCCR_RSN_CD
			IF OBJECT_ID(N'dbo.#TEMP_SCM_LGTM_EXHT_TP_CD', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_LGTM_EXHT_TP_CD
			IF OBJECT_ID(N'dbo.#TEMP_SCM_LGTM_PLAN_TP_CD', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_LGTM_PLAN_TP_CD
			-- 2.4 발생사유 / 소진방안을 입력하십시오 : 특정 ITEM_TYPE의 EXHT_TP_CD일 경우 수정을 하면 안되는 것으로 보인다.
			-- 해당 임시테이블
			--CREATE TABLE #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION(
			--	ITEM_TYPE         NVARCHAR(100),
			--	EXHT_TP_CD		  NVARCHAR(100),
			--);

			-- 2.5 잘못된 발생사유 유형입니다. : 입력된 발생사유가 등록되지 않은 사유 일 경우
			-- Lookup에 등록된 발생사유 데이터.
			CREATE TABLE #TEMP_SCM_LGTM_OCCR_RSN_CD(
				CODE         NVARCHAR(100),
				NAME		 NVARCHAR(100),
			);

			-- 2.6 잘못된 소진방안 유형입니다. : 입력된 소진방안이 등록되지 않은 사유 일 경우
			-- Lookup에 등록된 소진방안 데이터.
			CREATE TABLE #TEMP_SCM_LGTM_EXHT_TP_CD(
				CODE         NVARCHAR(100),
				NAME	     NVARCHAR(100),
			);

			CREATE TABLE #TEMP_SCM_LGTM_PLAN_TP_CD(
				CODE         NVARCHAR(100),
				NAME		 NVARCHAR(100),
			);

			--INSERT INTO #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION
			--EXEC SCP0115_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION

			INSERT INTO #TEMP_SCM_LGTM_OCCR_RSN_CD
			EXEC SCP0115_GET_COMBOBOX_DATA 'SCM_LGTM_PCY_INV_OCCR_RSN_CD','Y'

			INSERT INTO #TEMP_SCM_LGTM_EXHT_TP_CD
			EXEC SCP0115_GET_COMBOBOX_DATA 'SCM_LGTM_PCY_EXHT_TP_CD','Y'

			INSERT INTO #TEMP_SCM_LGTM_PLAN_TP_CD
			EXEC SCP0115_GET_COMBOBOX_DATA 'SCM_LGTM_PCY_INV_PLAN_TYPE','Y'


-----------------------------------------------프로시저에서 사용되는 공용 임시테이블 - 종료-----------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------Validation Check 시작 ---------------------------------------------

	IF ISNULL(@p_mode, 0) = 0 BEGIN
		DECLARE @V_VALIDATION_CHECK_RESULT NVARCHAR(200) = '';


		-- 1-2. 업로드 Header 의 컬럼 정합성 검증 - 필수 컬럼 입력 했는지 여부
		-- (ex: 필수컬럼 누락 여부, UI에서 메시지 주고 리턴 필요)
		SELECT @V_VALIDATION_CHECK_RESULT = (

			--주요 컬럼 (필수 이외 프로시저에서 사용될수있는 컬럼)
		CASE WHEN ISNULL(X.ATTRIBUTE3,'FAIL') <>  N'구분'           THEN  N'H1 셀은 Data TP CD 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE4,'FAIL') <>  N'발생사유'           THEN  N'I1 셀은 SRCE TP CD 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE6,'FAIL') <>  N'소진방안'            THEN  N'J1 셀은 Item Type 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE8,'FAIL') <>  N'COMPANY ID'           THEN  N'K1 셀은 발생 유형 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE9,'FAIL') <> 'DIV'           THEN  N'L1 셀은 Group Code 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE10,'FAIL') <> N'플랜트코드' THEN  N'M1 셀은 Marketing Department 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE12,'FAIL') <> N'아이템코드' THEN  N'M1 셀은 Marketing Department 으로 입력해주세요.'
			 WHEN ISNULL(X.ATTRIBUTE16,'FAIL') <> N'수량' THEN  N'M1 셀은 Marketing Department 으로 입력해주세요.'
			 WHEN ISNULL(X.ATTRIBUTE18,'FAIL') <> N'계획일자' THEN  N'M1 셀은 Marketing Department 으로 입력해주세요.'

			 ELSE 'SUCCESS'

		END )  
		FROM [SCM_ADM_EXCEL_UPLOAD] X WITH(NOLOCK)
		WHERE X.PROGRAM_ID = @v_program_id -- 'SCP0115' 
		AND X.SHEET_NAME = @v_sheet_name   -- 'Long Term Stock Management' 
		AND X.CREATED_BY = @p_created_by   -- 'dsiol'
		AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date -- '2025-03-25 09:48:37.000' 
		AND UPLOAD_STATUS_CODE = '@TITLE'		

		IF @V_VALIDATION_CHECK_RESULT <> 'SUCCESS'
		BEGIN
			------------------------------------------------------------------------
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = N'Validation Check - UI - ERROR : 필수컬럼 누락 여부.';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			RAISERROR(@V_VALIDATION_CHECK_RESULT, 11, 1); -- UI에 Error Msg 를 보여준다.
			RETURN -1;									  -- 프로시저를 종료 한다.
		END
		BEGIN
			------------------------------------------------------------------------
			SET @v_log_type = '5';
			SET @v_log_message = '########## Validation Check - UI - SUCCESS ##########';
			SET @v_description = N'필수컬럼 누락 여부. - PASS';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
		END
		-- DB Validation
		-- 2.1 업로드한 데이터의 Key값 중복여부 검증
		-- 2.2 업로드한 데이터의 컬럼 최대사이즈 초과여부 검증
		-- 2.3 업로드한 데이터의 월별 수량 값에 숫자가 아닌 데이터가 존재하는지 검증
		-- 2.4 발생사유 / 소진방안을 입력하십시오
		-- 2.5 잘못된 발생사유 유형입니다.
		-- 2.6 잘못된 소진방안 유형입니다.
		-- 2.7 월별 수량 입력 불가.
		-- 2.8 if (qty < 0) Qty must be greater than or equal to 0
		-- 2.9 월별 입력한 수량의 합계는, Quantity를 초과할 수 없습니다.
		-- Validation 결과가 전부 Success 인 경우, 적재 테이블에 데이터 반영
		DECLARE @V_ERR_CNT INT = 0
		DECLARE @v_err_message NVARCHAR(500) = '';

		-- 2.2 업로드한 데이터의 컬럼 최대사이즈 초과여부 검증
			--Error Message에 열을 표시하기위한 사전 작업
			DECLARE @V_HEADER1 NVARCHAR(50) = (SELECT ATTRIBUTE7  FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER2 NVARCHAR(50) = (SELECT ATTRIBUTE8  FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER3 NVARCHAR(50) = (SELECT ATTRIBUTE9  FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER4 NVARCHAR(50) = (SELECT ATTRIBUTE4  FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER5 NVARCHAR(50) = (SELECT ATTRIBUTE6  FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER6 NVARCHAR(50) = (SELECT ATTRIBUTE15 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER7 NVARCHAR(50) = (SELECT ATTRIBUTE5  FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')

		-- 테이블중복제거
			IF OBJECT_ID(N'tempdb..#TEMP_COLUMN_SIZE', N'U') IS NOT NULL
				DROP TABLE #TEMP_COLUMN_SIZE

			-- 임시확인용테이블 중복제거
			IF OBJECT_ID(N'dbo.#TEMP_COLUMN_SIZE', N'U') IS NOT NULL
				DROP TABLE #TEMP_COLUMN_SIZE

				CREATE TABLE #TEMP_COLUMN_SIZE(
					COLUMN_NAME         NVARCHAR(100),
					SIZE				INT
				);

			INSERT INTO #TEMP_COLUMN_SIZE
			SELECT A.COLUMN_NAME, Character_Maximum_Length  
			FROM INFORMATION_SCHEMA.ColumnS A WITH(NOLOCK) 
			WHERE A.Table_Name = 'SCP_ANL_LGTM_PCY_INV_MGMT_PLAN' 
			  AND Character_Maximum_Length IS NOT NULL
			  select * from #TEMP_COLUMN_SIZE

			--DECLARE @vPLAN_START_YYYYMMDD AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'PLAN_START_YYYYMMDD')
			DECLARE @vPLAN_TP_CD          AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'PLAN_TP_CD')
			DECLARE @vDATA_TP_CD          AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'DATA_TP_CD')
			DECLARE @vSRCE_TP_CD          AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'SRCE_TP_CD')
			DECLARE @vDIVISION_ID         AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'DIVISION_ID')
			DECLARE @vPLANT_ID            AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'PLANT_ID')
			DECLARE @vITEM_ID             AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'ITEM_ID')
			--DECLARE @vPLAN_YYYYMM         AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'PLAN_YYYYMM')
			DECLARE @vCOMPANY_ID          AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'COMPANY_ID')
			DECLARE @V_MSG2 NVARCHAR(100) = N' Over of Column Size'
			
			BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = CASE WHEN DATALENGTH(ATTRIBUTE3)  > @vPLAN_TP_CD  THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER1 + N'▷' + ATTRIBUTE3  + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE3))  +' > ' + CONVERT(NVARCHAR,@vPLAN_TP_CD)  +  @V_MSG2
											 WHEN DATALENGTH(ATTRIBUTE4)  > @vDATA_TP_CD  THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER2 + N'▷' + ATTRIBUTE4  + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE4))  +' > ' + CONVERT(NVARCHAR,@vDATA_TP_CD)  +  @V_MSG2
											 WHEN DATALENGTH(ATTRIBUTE6)  > @vSRCE_TP_CD  THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER3 + N'▷' + ATTRIBUTE6  + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE6))  +' > ' + CONVERT(NVARCHAR,@vSRCE_TP_CD)  +  @V_MSG2
											 WHEN DATALENGTH(ATTRIBUTE9)  > @vDIVISION_ID THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER4 + N'▷' + ATTRIBUTE9  + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE9))  +' > ' + CONVERT(NVARCHAR,@vDIVISION_ID) +  @V_MSG2
											 WHEN DATALENGTH(ATTRIBUTE10)  > @vPLANT_ID    THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER5 + N'▷' + ATTRIBUTE10  + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE10))  +' > ' + CONVERT(NVARCHAR,@vPLANT_ID)    +  @V_MSG2
											 WHEN DATALENGTH(ATTRIBUTE12) > @vITEM_ID     THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER6 + N'▷' + ATTRIBUTE12 + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE12)) +' > ' + CONVERT(NVARCHAR,@vITEM_ID)     +  @V_MSG2
											 WHEN DATALENGTH(ATTRIBUTE8)  > @vCOMPANY_ID  THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER7 + N'▷' + ATTRIBUTE8  + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE8))  +' > ' + CONVERT(NVARCHAR,@vCOMPANY_ID)  +  @V_MSG2
										END
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND  (DATALENGTH(ATTRIBUTE3)  > @vPLAN_TP_CD
			  OR  DATALENGTH(ATTRIBUTE4)  > @vDATA_TP_CD
			  OR  DATALENGTH(ATTRIBUTE6)  > @vSRCE_TP_CD
			  OR  DATALENGTH(ATTRIBUTE9)  > @vDIVISION_ID
			  OR  DATALENGTH(ATTRIBUTE10)  > @vPLANT_ID
			  OR  DATALENGTH(ATTRIBUTE12) > @vITEM_ID
			  OR  DATALENGTH(ATTRIBUTE8)  > @vCOMPANY_ID
			     )
			END

			SELECT @V_ERR_CNT = COUNT(1) FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK)
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'ERROR'
			AND    MESSAGE_TEXT       LIKE '%' + @V_MSG2 + '%'

			IF @V_ERR_CNT > 0
			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
			SET @v_log_type = '7';
			SET @v_log_message = '########## Validation Check - DB - ERROR ##########';
			SET @v_description = 'Over of Column Size - ' + CONVERT(NVARCHAR,@V_ERR_CNT) + N'건';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			END;
			ELSE
			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
			SET @v_log_type = '7';
			SET @v_log_message = '########## Validation Check - DB - SUCCESS ##########';
			SET @v_description = 'Over of Column Size - PASS';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			END

			IF @V_ERR_CNT > 0
			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
			SET @v_log_type = '8';
			SET @v_log_message = '########## Validation Check - DB - ERROR ##########';
			SET @v_description = 'The quantity value contains non-numeric data. - ' + CONVERT(NVARCHAR,@V_ERR_CNT) + N'건';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			END;
			ELSE
			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
			SET @v_log_type = '8';
			SET @v_log_message = '########## Validation Check - DB - SUCCESS ##########';
			SET @v_description = 'The quantity value contains non-numeric data. - PASS';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			END



			-- 2.4 발생사유 / 소진방안을 입력하십시오
			-- 2.5 잘못된 발생사유 유형입니다.
			-- 2.6 잘못된 소진방안 유형입니다.
			-- 2.7 월별 수량 입력 불가.
			--Error Message에 열을 표시하기위한 사전 작업
			--DECLARE @V_HEADER21  NVARCHAR(50) = (SELECT ATTRIBUTE42 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			--DECLARE @V_HEADER22  NVARCHAR(50) = (SELECT ATTRIBUTE44 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			--DECLARE @V_HEADER23  NVARCHAR(50) = (SELECT ATTRIBUTE10 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')

			--DECLARE @V_MSG4_1 NVARCHAR(100) = N'발생사유를 입력하십시오'     -- OCCR_RSN_CD(ATTRIBUTE42)
			--DECLARE @V_MSG4_2 NVARCHAR(100) = N'소진방안을 입력하십시오'     -- EXHT_TP_CD(ATTRIBUTE44)
			--DECLARE @V_MSG5   NVARCHAR(100) = N'잘못된 발생사유 유형입니다.' -- OCCR_RSN_CD(ATTRIBUTE42)
			--DECLARE @V_MSG6   NVARCHAR(100) = N'잘못된 소진방안 유형입니다.' -- EXHT_TP_CD(ATTRIBUTE44)
			--DECLARE @V_MSG7   NVARCHAR(100) = N'월별 수량 입력 불가.'        -- ITEM_TYPE(ATTRIBUTE10) / EXHT_TP_CD(ATTRIBUTE44)
			--Validation Check 결과 ERROR가 있었는지 마지막으로 확인
			SELECT @v_count = COUNT(1)
			FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
			WHERE  T.PROGRAM_ID         = @v_program_id
			AND    T.SHEET_NAME         = @v_sheet_name
			AND    T.CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
			AND    T.UPLOAD_STATUS_CODE = 'ERROR';

			IF @v_count = 0
			BEGIN
				-- Validation 결과가 전부 Success 인 경우, 적재 테이블에 데이터 반영
				-- (※참고 - 모든 데이터가 SUCCESS 일 경우 다음 로직에서 저장을 실행한다.)
				BEGIN
				UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
				SET    UPLOAD_STATUS_CODE = 'SUCCESS'
				WHERE  PROGRAM_ID         = @v_program_id
				AND    SHEET_NAME         = @v_sheet_name
				AND    CREATED_BY         = @p_created_by
				AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121)  = @v_creation_date
				AND    UPLOAD_STATUS_CODE = 'UPLOAD';	
				END;

				BEGIN
				----------------------------------------------------------------------------
				--scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
				SET @v_log_type = '11';
				SET @v_log_message = '########## SUCCESS ##########';
				SET @v_description = 'Validation Check - SUCCESS';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				----------------------------------------------------------------------------
				END;
			END;
------------------------------------------------------------------Validation Check 종료후 작성 - 종료------------------------------------------------------------------
	END;
---------------------------------------------Validation Check 종료 ---------------------------------------------

	--Validation Check 결과 ERROR가 있었는지 마지막으로 확인
	SELECT @v_count = COUNT(1)
	FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
	WHERE  T.PROGRAM_ID         = @v_program_id
	AND    T.SHEET_NAME         = @v_sheet_name
	AND    T.CREATED_BY         = @p_created_by
	AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
	AND    T.UPLOAD_STATUS_CODE = 'ERROR';

	--ERROR가 있을 경우 로그를 남긴 후 종료 한다.
	IF @v_count > 0
	BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = N'Validation Check - ERROR: ' + CONVERT(NVARCHAR, @v_count) + N'건';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			RETURN -1;	
	END

	IF @p_mode > 0 AND @v_count = 0	BEGIN	
	
-------------------------------------------------------------임시테이블 생성 시작-------------------------------------------------------------
		BEGIN

		----------------------------------------------------------------------------
		SET @v_log_type = '12';
		SET @v_log_message = '########## SUCCESS ##########';
		SET @v_description = N'#TEMP_SCP_ANL_LGTM_INV_MGMT_PLAN 임시테이블 생성 시작';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		----------------------------------------------------------------------------

		-- 테이블중복제거
		IF OBJECT_ID(N'tempdb..#TEMP_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN', N'U') IS NOT NULL
			DROP TABLE #TEMP_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID(N'dbo.#TEMP_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN', N'U') IS NOT NULL
			DROP TABLE #TEMP_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN

			CREATE TABLE #TEMP_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN(
				[REQUEST_NO] [varchar](300) NOT NULL,
				[COMPANY_ID] [nvarchar](10) NULL,
				[PLAN_START_YYYYMMDD] [nvarchar](8) NOT NULL,
				[PLAN_TP_CD] [nvarchar](20) NOT NULL,
				[DIVISION_ID] [nvarchar](30) NOT NULL,
				[PLANT_ID] [nvarchar](30) NOT NULL,
				[ITEM_ID] [nvarchar](50) NOT NULL,
				[PLAN_YYYYMMDD] [nvarchar](8) NOT NULL,
				[OCCR_RSN_CD] [nvarchar](20) NOT NULL,
				[OCCR_RSN_CTN] [nvarchar](200) NULL,
				[EXHT_TP_CD] [nvarchar](20) NOT NULL,
				[EXHT_TP_CTN] [nvarchar](200) NULL,
				[QTY] [numeric](30, 8) NULL,
				[SUPPLIER_CODE] [nvarchar](20) NOT NULL
			);
			
		INSERT INTO #TEMP_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN
		SELECT * 
		FROM
		(
			SELECT 
			 A.REQUEST_NO
			, A.COMPANY_ID
			, A.PLAN_START_YYYYMMDD 
			, (SELECT CODE FROM #TEMP_SCM_LGTM_PLAN_TP_CD WHERE NAME = A.PLAN_TP_NM) AS PLAN_TP_CD 
			, A.DIVISION_ID
			, A.PLANT_ID
			, A.ITEM_ID
			, A.PLAN_YYYYMMDD
			, (SELECT CODE FROM #TEMP_SCM_LGTM_OCCR_RSN_CD WHERE NAME = A.OCCR_RSN_NM) AS OCCR_RSN_CD
			, A.OCCR_RSN_CTN
			, (SELECT CODE FROM #TEMP_SCM_LGTM_EXHT_TP_CD WHERE NAME = A.EXHT_TP_NM) AS EXHT_TP_CD
			, A.EXHT_TP_CTN
			, A.QTY
			, A.SUPPLIER_CODE

			FROM
			(
				SELECT ATTRIBUTE1  AS REQUEST_NO
					 , ATTRIBUTE2  AS PLAN_START_YYYYMMDD
					 , ATTRIBUTE3  AS PLAN_TP_NM
					 , ATTRIBUTE4  AS OCCR_RSN_NM
					 , ATTRIBUTE5  AS OCCR_RSN_CTN
					 , ATTRIBUTE6  AS EXHT_TP_NM
					 , ATTRIBUTE7  AS EXHT_TP_CTN
					 , ATTRIBUTE8  AS COMPANY_ID
					 , ATTRIBUTE9  AS DIVISION_ID
					 , ATTRIBUTE10 AS PLANT_ID
					 , ATTRIBUTE12 AS ITEM_ID
					 , ATTRIBUTE16 AS QTY
					 , ATTRIBUTE18 AS PLAN_YYYYMMDD
					 , ATTRIBUTE19 AS SUPPLIER_CODE
					 , CREATION_DATE
				FROM(
					SELECT X.ATTRIBUTE1,  X.ATTRIBUTE2,  X.ATTRIBUTE3,  X.ATTRIBUTE4,  X.ATTRIBUTE5 
						 , X.ATTRIBUTE6,  X.ATTRIBUTE7,  X.ATTRIBUTE8,  X.ATTRIBUTE9,  X.ATTRIBUTE10, X.ATTRIBUTE11 
						 , X.ATTRIBUTE12, X.ATTRIBUTE13, X.ATTRIBUTE14, X.ATTRIBUTE15, X.ATTRIBUTE16, X.ATTRIBUTE17 
						 , X.ATTRIBUTE18, X.ATTRIBUTE19, X.ATTRIBUTE20, X.ATTRIBUTE21, X.ATTRIBUTE22, X.ATTRIBUTE23 
						 , X.ATTRIBUTE24, X.ATTRIBUTE25, X.ATTRIBUTE26, X.ATTRIBUTE27, X.ATTRIBUTE28, X.ATTRIBUTE29 
						 , X.ATTRIBUTE30, X.ATTRIBUTE31, X.ATTRIBUTE32, X.ATTRIBUTE33, X.ATTRIBUTE34, X.ATTRIBUTE35 
						 , X.ATTRIBUTE36, X.ATTRIBUTE37, X.ATTRIBUTE38, X.ATTRIBUTE39, X.ATTRIBUTE40, X.ATTRIBUTE41 
						 , X.ATTRIBUTE42, X.ATTRIBUTE43, X.ATTRIBUTE44, X.ATTRIBUTE45, X.ATTRIBUTE46, X.ATTRIBUTE47 
						 , X.ATTRIBUTE48, X.ATTRIBUTE49, X.ATTRIBUTE50, X.ATTRIBUTE51, X.ATTRIBUTE52, X.ATTRIBUTE53 
						 , X.ATTRIBUTE54, X.ATTRIBUTE55, X.ATTRIBUTE56, X.ATTRIBUTE57, X.ATTRIBUTE58, X.ATTRIBUTE59 
						 , X.ATTRIBUTE60, X.ATTRIBUTE61, X.ATTRIBUTE62, X.ATTRIBUTE63, X.ATTRIBUTE64, X.ATTRIBUTE65 
						 , X.CREATION_DATE 
					FROM [SCM_ADM_EXCEL_UPLOAD] X WITH(NOLOCK) 
					WHERE X.PROGRAM_ID = @v_program_id
					  AND X.SHEET_NAME = @v_sheet_name
					  AND X.CREATED_BY = @p_created_by
					  AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date 
					  AND UPLOAD_STATUS_CODE <> '@TITLE'
				) A
			) A
		) A
		WHERE A.PLAN_START_YYYYMMDD <> ''

		END;

		----------------------------------------------------------------------------
		SET @v_log_type = '13';
		SET @v_log_message = '########## SUCCESS ##########';
		SET @v_description = N'#TEMP_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN 임시테이블 생성 성공';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		BEGIN TRANSACTION SCP0115_EXCEL_UPLOAD;
		BEGIN TRY
			BEGIN

        ----------------------------------------------------------------------------
		SET @v_log_type = '14';
		SET @v_log_message = '########## START - MERGE - SCP_ANL_LGTM_INV_MGMT_PLAN ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------		

		MERGE INTO SCP_ANL_LGTM_PCY_INV_MGMT_PLAN AS A
		USING (SELECT * FROM #TEMP_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN WITH(NOLOCK)) AS B
		   ON (
		     	A.REQUEST_NO				= B.REQUEST_NO
			AND	A.PLAN_START_YYYYMMDD		= B.PLAN_START_YYYYMMDD
			)
		 --WHEN MATCHED AND B.QTY <> 0 THEN
		WHEN MATCHED AND B.QTY >= 0 THEN
		   UPDATE SET 
			 A.OCCR_RSN_CTN		    = B.OCCR_RSN_CTN
			,A.EXHT_TP_CTN			= B.EXHT_TP_CTN 
			,A.QTY					= B.QTY
			,A.OCCR_RSN_CD			= B.OCCR_RSN_CD
			,A.EXHT_TP_CD			= B.EXHT_TP_CD		
			,A.PLAN_TP_CD			= B.PLAN_TP_CD
			,A.COMPANY_ID			= B.COMPANY_ID
			,A.DIVISION_ID			= B.DIVISION_ID
			,A.ITEM_ID				= B.ITEM_ID
			,A.PLAN_YYYYMMDD		= B.PLAN_YYYYMMDD
			,A.PLANT_ID				= B.PLANT_ID
			,A.LAST_UPDATED_BY		= @p_created_by
			,A.LAST_UPDATE_DATE	    = SYSDATETIME()
		 --WHEN NOT MATCHED AND B.QTY <> 0 THEN
		WHEN NOT MATCHED AND B.QTY >= 0 THEN
		   INSERT           
				(
					PLAN_START_YYYYMMDD
					, PLAN_TP_CD
					, DIVISION_ID
					, PLANT_ID
					, ITEM_ID
					, PLAN_YYYYMMDD
					, OCCR_RSN_CD
					, OCCR_RSN_CTN
					, EXHT_TP_CD
					, EXHT_TP_CTN
					, QTY
					, SUPPLIER_CODE
					, CREATE_DATE
					, CREATED_BY
					, LAST_UPDATE_DATE
					, LAST_UPDATED_BY
					, REQUEST_NO
					, COMPANY_ID

			   )
		   VALUES
	   			(
					B.PLAN_START_YYYYMMDD
					, B.PLAN_TP_CD
					, B.DIVISION_ID
					, B.PLANT_ID
					, B.ITEM_ID
					, B.PLAN_YYYYMMDD
					, B.OCCR_RSN_CD
					, B.OCCR_RSN_CTN
					, B.EXHT_TP_CD
					, B.EXHT_TP_CTN
					, B.QTY
					, B.SUPPLIER_CODE
					, @v_creation_date
					, @p_created_by
					, @v_creation_date
					, @p_created_by
					, B.REQUEST_NO
					, B.COMPANY_ID
			   );

        ----------------------------------------------------------------------------
		SET @v_log_type = '15';
		SET @v_log_message = '########## END - MERGE - SCP_ANL_LGTM_INV_MGMT_PLAN ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------
			END;

		    COMMIT WORK;
        END TRY
		BEGIN CATCH
		    ROLLBACK TRANSACTION SCP0115_EXCEL_UPLOAD;
		----------------------------------------------------------------------------
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '@p_mode' + @p_mode + ', Error Message : ' + ERROR_MESSAGE(); --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		----------------------------------------------------------------------------
		END CATCH

		BEGIN
		----------------------------------------------------------------------------
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		----------------------------------------------------------------------------
		END;	
	END;
END
