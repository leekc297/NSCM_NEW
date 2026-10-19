/*
 * Program ID   : SCP0113_EXCEL_UPLOAD
 * Description  : SCP0113_EXCEL_UPLOAD
 * Program History 
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 /* 2025-03-25   dsiol         긴급 개발 요청...(?) */  
 --EXEC [SCP0113_EXCEL_UPLOAD] 0, 'dsiol'

 */ 

CREATE PROCEDURE [dbo].[SCP0113_EXCEL_UPLOAD_20250331]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)		

AS


BEGIN
	SET NOCOUNT ON;
	DECLARE @v_program_id     AS NVARCHAR(40) = 'SCP0113';
    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'Long Term Stock Management';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_division		AS NVARCHAR(10); 

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0113_EXCEL_UPLOAD';
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
        AND    (   ATTRIBUTE1  IS NULL 
	            OR UPPER(ATTRIBUTE1) = 'TOTAL') ;
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
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--EXCEL에서 첫 행 (HEADER 정보를 가져오기 위함 =UPLOAD_STATUS_CODE 값이 @TITLE 인것)
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
		SET    UPLOAD_STATUS_CODE = '@TITLE'
		WHERE  PROGRAM_ID    = @v_program_id
		AND    SHEET_NAME    = @v_sheet_name
		AND    CREATED_BY    = @p_created_by
		AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
		AND    ATTRIBUTE1 = 'Plan Date'; -- EXCEL기준 A1 , A2 에 해당하는 값이 Plan Date인 행을 @TITLE로 업데이트 함.  
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
			-- 임시확인용테이블 중복제거
			IF OBJECT_ID(N'tempdb..#TEMP_EDIT_YYYYMM', N'U') IS NOT NULL
				DROP TABLE #TEMP_EDIT_YYYYMM

			IF OBJECT_ID(N'dbo.#TEMP_EDIT_YYYYMM', N'U') IS NOT NULL
				DROP TABLE #TEMP_EDIT_YYYYMM

			CREATE TABLE #TEMP_EDIT_YYYYMM(			--임시테이블     COLUMN_NAME   YYYYMM
				COLUMN_NAME         NVARCHAR(100),	--1번 ROW 예시 : ATTRIBUTE47 , 202503
				YYYYMM				NVARCHAR(6)		--2번 ROW 예시 : ATTRIBUTE48 , 202504
			);

			-- UI기준 소진계획에 해당하는 YYYYMM 값이 있는 ATTRIBUTE 컬럼명을 가지고 있다.
			INSERT INTO #TEMP_EDIT_YYYYMM
			SELECT DISTINCT UNPVT.PLAN_YYYYMM, LEFT(DATEPART(YYYY, GETDATE()),2)+LEFT(UNPVT.YYYYMM,2) + RIGHT(UNPVT.YYYYMM,2) AS YYYYMM
					FROM(
						SELECT X.ATTRIBUTE1,  X.ATTRIBUTE2,  X.ATTRIBUTE3,  X.ATTRIBUTE4,  X.ATTRIBUTE5 
							 , X.ATTRIBUTE6  ,X.ATTRIBUTE7,  X.ATTRIBUTE8,  X.ATTRIBUTE9,  X.ATTRIBUTE10, X.ATTRIBUTE11
							 , X.ATTRIBUTE12 ,X.ATTRIBUTE13, X.ATTRIBUTE14, X.ATTRIBUTE15, X.ATTRIBUTE16, X.ATTRIBUTE17
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
							WHERE X.PROGRAM_ID = @v_program_id                               -- 'SCP0113' 
							AND X.SHEET_NAME   = @v_sheet_name                               -- 'Long Term Stock Management' 
							AND X.CREATED_BY   = @p_created_by                               -- 'dsiol'
							AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date -- '2025-03-25 09:48:37.000'
							AND UPLOAD_STATUS_CODE = '@TITLE'	
						) T
						UNPIVOT 
						(YYYYMM
							FOR	PLAN_YYYYMM
											IN(	   -- YYYYMM이 시작하는 컬럼은 현재 ATTRIBUTE47으로 되어있다. 현재는 13개월치
												   -- 그 이후에 입력자나 입력일자 때문에 필터를 위하여 아래 HAVING 절이 포함됨..
												   -- 변경 사항있을시 보통이라면 아래를 수정하면 된다..
												   T.ATTRIBUTE47 
												 , T.ATTRIBUTE48, T.ATTRIBUTE49, T.ATTRIBUTE50, T.ATTRIBUTE51, T.ATTRIBUTE52, T.ATTRIBUTE53 
												 , T.ATTRIBUTE54, T.ATTRIBUTE55, T.ATTRIBUTE56, T.ATTRIBUTE57, T.ATTRIBUTE58, T.ATTRIBUTE59
											  )
						) AS UNPVT
					GROUP BY CREATION_DATE, PLAN_YYYYMM,YYYYMM
					HAVING ISNULL(FORMAT(TRY_PARSE(LEFT(DATEPART(YYYY, GETDATE()),2)+LEFT(YYYYMM,2) +'.'+RIGHT(YYYYMM,2)  AS DATE),'yy.MM'),'FAIL') <> 'FAIL'

			-- 테이블중복제거
			IF OBJECT_ID(N'tempdb..#TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION
			IF OBJECT_ID(N'tempdb..#TEMP_SCM_LGTM_OCCR_RSN_CD', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_LGTM_OCCR_RSN_CD
			IF OBJECT_ID(N'tempdb..#TEMP_SCM_LGTM_EXHT_TP_CD', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_LGTM_EXHT_TP_CD

			-- 임시확인용테이블 중복제거
			IF OBJECT_ID(N'dbo.#TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION
			IF OBJECT_ID(N'dbo.#TEMP_SCM_LGTM_OCCR_RSN_CD', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_LGTM_OCCR_RSN_CD
			IF OBJECT_ID(N'dbo.#TEMP_SCM_LGTM_EXHT_TP_CD', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_LGTM_EXHT_TP_CD

			-- 2.4 발생사유 / 소진방안을 입력하십시오 : 특정 ITEM_TYPE의 EXHT_TP_CD일 경우 수정을 하면 안되는 것으로 보인다.
			-- 해당 임시테이블
			CREATE TABLE #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION(
				ITEM_TYPE         NVARCHAR(100),
				EXHT_TP_CD		  NVARCHAR(100),
			);

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

			INSERT INTO #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION
			EXEC SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION

			INSERT INTO #TEMP_SCM_LGTM_OCCR_RSN_CD
			EXEC SCP0084_GET_COMBOBOX_DATA 'SCM_LGTM_OCCR_RSN_CD','Y'

			INSERT INTO #TEMP_SCM_LGTM_EXHT_TP_CD
			EXEC SCP0084_GET_COMBOBOX_DATA 'SCM_LGTM_EXHT_TP_CD','Y'
-----------------------------------------------프로시저에서 사용되는 공용 임시테이블 - 종료-----------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------Validation Check 시작 ---------------------------------------------
	IF ISNULL(@p_mode, 0) = 0 BEGIN

		-- 공백인 데이터 0 으로 업데이트
		UPDATE [SCM_ADM_EXCEL_UPLOAD]
		SET ATTRIBUTE47  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE47') > 0 AND X.ATTRIBUTE47 = '') THEN '0' ELSE X.ATTRIBUTE47 END
		,   ATTRIBUTE48  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE48') > 0 AND X.ATTRIBUTE48 = '') THEN '0' ELSE X.ATTRIBUTE48 END
		,   ATTRIBUTE49  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE49') > 0 AND X.ATTRIBUTE49 = '') THEN '0' ELSE X.ATTRIBUTE49 END
		,   ATTRIBUTE50  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE50') > 0 AND X.ATTRIBUTE50 = '') THEN '0' ELSE X.ATTRIBUTE50 END
		,   ATTRIBUTE51  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE51') > 0 AND X.ATTRIBUTE51 = '') THEN '0' ELSE X.ATTRIBUTE51 END
		,   ATTRIBUTE52  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE52') > 0 AND X.ATTRIBUTE52 = '') THEN '0' ELSE X.ATTRIBUTE52 END
		,   ATTRIBUTE53  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE53') > 0 AND X.ATTRIBUTE53 = '') THEN '0' ELSE X.ATTRIBUTE53 END
		,   ATTRIBUTE54  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE54') > 0 AND X.ATTRIBUTE54 = '') THEN '0' ELSE X.ATTRIBUTE54 END
		,   ATTRIBUTE55  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE55') > 0 AND X.ATTRIBUTE55 = '') THEN '0' ELSE X.ATTRIBUTE55 END
		,   ATTRIBUTE56  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE56') > 0 AND X.ATTRIBUTE56 = '') THEN '0' ELSE X.ATTRIBUTE56 END
		,   ATTRIBUTE57  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE57') > 0 AND X.ATTRIBUTE57 = '') THEN '0' ELSE X.ATTRIBUTE57 END
		,   ATTRIBUTE58  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE58') > 0 AND X.ATTRIBUTE58 = '') THEN '0' ELSE X.ATTRIBUTE58 END
		,   ATTRIBUTE59  = CASE WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE59') > 0 AND X.ATTRIBUTE59 = '') THEN '0' ELSE X.ATTRIBUTE59 END
		FROM [SCM_ADM_EXCEL_UPLOAD] X 
		WHERE X.PROGRAM_ID = @v_program_id 
			AND X.SHEET_NAME = @v_sheet_name 
			AND X.CREATED_BY = @p_created_by
			AND CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date 
			AND X.UPLOAD_STATUS_CODE <> '@TITLE'
			AND  (((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE47') > 0 AND X.ATTRIBUTE47 = '')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE48') > 0 AND X.ATTRIBUTE48 = '')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE49') > 0 AND X.ATTRIBUTE49 = '')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE50') > 0 AND X.ATTRIBUTE50 = '')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE51') > 0 AND X.ATTRIBUTE51 = '')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE52') > 0 AND X.ATTRIBUTE52 = '')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE53') > 0 AND X.ATTRIBUTE53 = '')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE54') > 0 AND X.ATTRIBUTE54 = '')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE55') > 0 AND X.ATTRIBUTE55 = '')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE56') > 0 AND X.ATTRIBUTE56 = '')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE57') > 0 AND X.ATTRIBUTE57 = '')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE58') > 0 AND X.ATTRIBUTE58 = '')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE59') > 0 AND X.ATTRIBUTE59 = '')
			     )

		-- ATTRIBUTE100 에 ROW번호 적기
		UPDATE [SCM_ADM_EXCEL_UPLOAD]
		SET ATTRIBUTE100 = X.RNUM
		FROM (SELECT ROW_NUMBER() OVER(ORDER BY UPLOAD_ID) + 2 AS RNUM,UPLOAD_ID AS U_ID
		      FROM [SCM_ADM_EXCEL_UPLOAD] A WITH(NOLOCK) 
			  WHERE A.PROGRAM_ID = @v_program_id 
				AND A.SHEET_NAME = @v_sheet_name 
				AND A.CREATED_BY = @p_created_by
				AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date 
				AND A.UPLOAD_STATUS_CODE <> '@TITLE'
		) X
		WHERE UPLOAD_ID = X.U_ID

		-- UI Validation
		DECLARE @V_VALIDATION_CHECK_RESULT NVARCHAR(200) = '';
		DECLARE @V_MSG1 NVARCHAR(100) = N'입력 기간이 경과하였습니다.' 

		-- 1-1. 입력 기간이 경과하였습니다.
		-- 기준 날짜 + 수정 가능 일수 ex) 20250307 + 40 이면 20250307일 이후 40일까지 가능한 듯.
		--DECLARE @V_PLANDATE NVARCHAR(100) = '';	--기준 날짜		 -- ex) 20250307
		DECLARE @V_ADDDATE INT;					--수정 가능 일수 -- ex) 40

		------------------------------- 기준 날짜 -----------------------------
		--SELECT TOP 1 @V_PLANDATE = ATTRIBUTE1
		--FROM [SCM_ADM_EXCEL_UPLOAD] X WITH(NOLOCK)
		--WHERE X.PROGRAM_ID = @v_program_id -- 'SCP0113' 
		--AND X.SHEET_NAME = @v_sheet_name   -- 'Long Term Stock Management' 
		--AND X.CREATED_BY = @p_created_by   -- 'dsiol'
		--AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date -- '2025-03-25 09:48:37.000' 
		--AND UPLOAD_STATUS_CODE <> '@TITLE'

		----------------------------- 수정 가능 일수 -----------------------------
		IF OBJECT_ID(N'tempdb..#TEMP_EDIT_PERIOD', N'U') IS NOT NULL
		DROP TABLE #TEMP_EDIT_PERIOD

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID(N'dbo.#TEMP_EDIT_PERIOD', N'U') IS NOT NULL
			DROP TABLE #TEMP_EDIT_PERIOD
			
		CREATE TABLE #TEMP_EDIT_PERIOD(
			EDIT_PERIOD         NVARCHAR(100),
		);

		INSERT INTO #TEMP_EDIT_PERIOD
		EXEC SCP0113_GET_LGTM_PLAN_EDIT_PERIOD

		SELECT @V_ADDDATE = CONVERT(INT, EDIT_PERIOD) FROM #TEMP_EDIT_PERIOD
		
		--------------------------------------------------------------------------------------------------------------------
		--														  -- 40         20250307
		--SELECT @V_VALIDATION_CHECK_RESULT = CASE WHEN DATEADD(DAY, @V_ADDDATE, @V_PLANDATE) > GETDATE() THEN 'SUCCESS' ELSE @V_MSG1 END

		SELECT @V_VALIDATION_CHECK_RESULT = CASE WHEN COUNT(*) = 0 THEN 'SUCCESS' ELSE @V_MSG1 END
		FROM [SCM_ADM_EXCEL_UPLOAD] X WITH(NOLOCK)
		WHERE X.PROGRAM_ID = @v_program_id -- 'SCP0113' 
		AND X.SHEET_NAME = @v_sheet_name   -- 'Long Term Stock Management' 
		AND X.CREATED_BY = @p_created_by   -- 'dsiol'
		AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date -- '2025-03-25 09:48:37.000' 
		AND UPLOAD_STATUS_CODE <> '@TITLE'
		AND CASE WHEN DATEADD(DAY, @V_ADDDATE, ATTRIBUTE1) > GETDATE() THEN 'SUCCESS' ELSE 'FAIL' END = 'FAIL'

		IF @V_VALIDATION_CHECK_RESULT <> 'SUCCESS'
		BEGIN
			------------------------------------------------------------------------
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = N'Validation Check - UI - ERROR : 입력 기간이 경과하였습니다.';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			RAISERROR(@V_VALIDATION_CHECK_RESULT, 11, 1); -- UI에 Error Msg 를 보여준다.
			RETURN -1;									  -- 프로시저를 종료 한다.
		END
		ELSE
		BEGIN
			------------------------------------------------------------------------
			SET @v_log_type = '4';
			SET @v_log_message = '########## Validation Check - UI - SUCCESS ##########';
			SET @v_description = N'입력 기간이 경과하였습니다. - PASS';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
		END
		--------------------------------------------------------------------------------------------------------------------

		-- 1-2. 업로드 Header 의 컬럼 정합성 검증 - 필수 컬럼 입력 했는지 여부
		-- (ex: 필수컬럼 누락 여부, UI에서 메시지 주고 리턴 필요)
		SELECT @V_VALIDATION_CHECK_RESULT = (

			--주요 컬럼 (필수 이외 프로시저에서 사용될수있는 컬럼)
		CASE WHEN ISNULL(X.ATTRIBUTE1,'FAIL') <>  'Plan Date'		     THEN  N'A1 셀은 Plan Date 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE2,'FAIL') <>  'Ending INV Month'     THEN  N'B1 셀은 Ending INV Month 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE3,'FAIL') <>  'EOH Month'            THEN  N'C1 셀은 EOH Month 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE4,'FAIL') <>  'Div'			         THEN  N'D1 셀은 Div 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE5,'FAIL') <>  'Company ID'           THEN  N'E1 셀은 Company ID 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE6,'FAIL') <>  'Plant ID'             THEN  N'F1 셀은 Plant ID 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE7,'FAIL') <>  'Plan TP CD'           THEN  N'G1 셀은 Plan TP CD 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE8,'FAIL') <>  'Data TP CD'           THEN  N'H1 셀은 Data TP CD 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE9,'FAIL') <>  'SRCE TP CD'           THEN  N'I1 셀은 SRCE TP CD 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE10,'FAIL') <> 'Item Type'            THEN  N'J1 셀은 Item Type 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE11,'FAIL') <> N'발생 유형'           THEN  N'K1 셀은 발생 유형 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE12,'FAIL') <> 'Group Code'           THEN  N'L1 셀은 Group Code 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE13,'FAIL') <> 'Marketing Department' THEN  N'M1 셀은 Marketing Department 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE14,'FAIL') <> 'End Customer'         THEN  N'N1 셀은 End Customer 으로 입력해주세요.'
 			 WHEN ISNULL(X.ATTRIBUTE15,'FAIL') <> 'Material Code'        THEN  N'O1 셀은 Material Code 으로 입력해주세요.'
			 WHEN ISNULL(X.ATTRIBUTE34,'FAIL') <> 'Total(UOM)'           THEN  N'AH1 셀은 Total(UOM) 으로 입력해주세요.'

			 --입력 부분
			 WHEN ISNULL(X.ATTRIBUTE41,'FAIL') <> N'귀책부서'            THEN  N'AO1 셀은 귀책부서 으로 입력해주세요.'
			 WHEN ISNULL(X.ATTRIBUTE42,'FAIL') <> N'*발생사유 유형'      THEN  N'AP1 셀은 *발생사유 유형 으로 입력해주세요.'
			 WHEN ISNULL(X.ATTRIBUTE43,'FAIL') <> N'발생사유 상세'       THEN  N'AQ1 셀은 발생사유 상세 입력해주세요.'
			 WHEN ISNULL(X.ATTRIBUTE44,'FAIL') <> N'*소진방안 유형'      THEN  N'AR1 셀은 *소진방안 유형 으로 입력해주세요.'
			 WHEN ISNULL(X.ATTRIBUTE45,'FAIL') <> N'소진방안 상세'       THEN  N'AS1 셀은 소진방안상세 으로 입력해주세요.'
			 WHEN ISNULL(X.ATTRIBUTE46,'FAIL') <> N'EDIT_TYPE'           THEN  N'AT1 셀은 EDIT_TYPE 으로 입력해주세요.'

			 ELSE 'SUCCESS'

		END )  
		FROM [SCM_ADM_EXCEL_UPLOAD] X WITH(NOLOCK)
		WHERE X.PROGRAM_ID = @v_program_id -- 'SCP0113' 
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

		-- 2.1 업로드한 데이터의 Key값 중복여부 검증
		-- Validation Check - Duplication Key
			BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       =  N'행:'+ ATTRIBUTE100 + SPACE(1) + 'Duplication Key.' + N'혹은 빈 데이터 일 경우 해당 행을 삭제해주세요.'
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND EXISTS (SELECT 1
						FROM  (SELECT X.ATTRIBUTE1 AS COL1		--PLAN_START_YYYYMMDD
									--, X.ATTRIBUTE2 AS COL2
									--, X.ATTRIBUTE3 AS COL3
									, X.ATTRIBUTE4 AS COL4		--DIVISION_ID
									--, X.ATTRIBUTE5 AS COL5	
									, X.ATTRIBUTE6 AS COL6		--PLANT_ID
									, X.ATTRIBUTE7 AS COL7		--PLAN_TP_CD
									, X.ATTRIBUTE8 AS COL8		--DATA_TP_CD
									, X.ATTRIBUTE9 AS COL9		--SRCE_TP_CD
									--, X.ATTRIBUTE10 AS COL10
									--, X.ATTRIBUTE11 AS COL11
									--, X.ATTRIBUTE12 AS COL12
									--, X.ATTRIBUTE13 AS COL13
									--, X.ATTRIBUTE14 AS COL14
									, X.ATTRIBUTE15 AS COL15	--ITEM_ID
							   FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
							   WHERE  X.PROGRAM_ID    = @v_program_id
							   AND    X.SHEET_NAME    = @v_sheet_name
							   AND    X.CREATED_BY    = @p_created_by
							   AND    CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
							   AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
							   GROUP BY X.ATTRIBUTE1			--PLAN_START_YYYYMMDD
									  --, X.ATTRIBUTE2
									  --, X.ATTRIBUTE3
									  , X.ATTRIBUTE4			--DIVISION_ID
									  --, X.ATTRIBUTE5
									  , X.ATTRIBUTE6			--PLANT_ID
									  , X.ATTRIBUTE7			--PLAN_TP_CD
									  , X.ATTRIBUTE8			--DATA_TP_CD
									  , X.ATTRIBUTE9			--SRCE_TP_CD
									  --, X.ATTRIBUTE10
									  --, X.ATTRIBUTE11
									  --, X.ATTRIBUTE12
									  --, X.ATTRIBUTE13
									  --, X.ATTRIBUTE14
									  , X.ATTRIBUTE15			--ITEM_ID
							   HAVING COUNT(*) > 1 ) T
						WHERE 1 = 1										 
	 					AND T.COL1 = ATTRIBUTE1					--PLAN_START_YYYYMMDD
						--AND T.COL2 = ATTRIBUTE2
						--AND T.COL3 = ATTRIBUTE3
						AND T.COL4 = ATTRIBUTE4					--DIVISION_ID
						--AND T.COL5 = ATTRIBUTE5
	 					AND T.COL6 = ATTRIBUTE6					--PLANT_ID
						AND T.COL7 = ATTRIBUTE7					--PLAN_TP_CD
						AND T.COL8 = ATTRIBUTE8					--DATA_TP_CD
						AND T.COL9 = ATTRIBUTE9					--SRCE_TP_CD
						--AND T.COL10 = ATTRIBUTE10
	 					--AND T.COL11 = ATTRIBUTE11
						--AND T.COL12 = ATTRIBUTE12
						--AND T.COL13 = ATTRIBUTE13
						--AND T.COL14 = ATTRIBUTE14
						AND T.COL15 = ATTRIBUTE15				--ITEM_ID
					   );
			END

			SELECT @V_ERR_CNT = COUNT(1) FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK)
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'ERROR'
			AND    MESSAGE_TEXT       LIKE '%Duplication Key.%'

			IF @V_ERR_CNT > 0
			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
			SET @v_log_type = '6';
			SET @v_log_message = '########## Validation Check - DB - ERROR ##########';
			SET @v_description = 'Key Duplication - ' + CONVERT(NVARCHAR,@V_ERR_CNT) + N'건';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			END
			ELSE
			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
			SET @v_log_type = '6';
			SET @v_log_message = '########## Validation Check - DB - SUCCESS ##########';
			SET @v_description = 'Key Duplication - PASS';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			END

		-- 2.2 업로드한 데이터의 컬럼 최대사이즈 초과여부 검증
			--Error Message에 열을 표시하기위한 사전 작업
			DECLARE @V_HEADER1 NVARCHAR(50) = (SELECT ATTRIBUTE7  FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER2 NVARCHAR(50) = (SELECT ATTRIBUTE8  FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER3 NVARCHAR(50) = (SELECT ATTRIBUTE9  FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER4 NVARCHAR(50) = (SELECT ATTRIBUTE4  FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER5 NVARCHAR(50) = (SELECT ATTRIBUTE6  FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER6 NVARCHAR(50) = (SELECT ATTRIBUTE15 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')

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
			WHERE A.Table_Name = 'SCP_ANL_LGTM_INV_MGMT_PLAN' 
			  AND Character_Maximum_Length IS NOT NULL

			--DECLARE @vPLAN_START_YYYYMMDD AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'PLAN_START_YYYYMMDD')
			DECLARE @vPLAN_TP_CD          AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'PLAN_TP_CD')
			DECLARE @vDATA_TP_CD          AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'DATA_TP_CD')
			DECLARE @vSRCE_TP_CD          AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'SRCE_TP_CD')
			DECLARE @vDIVISION_ID         AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'DIVISION_ID')
			DECLARE @vPLANT_ID            AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'PLANT_ID')
			DECLARE @vITEM_ID             AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'ITEM_ID')
			--DECLARE @vPLAN_YYYYMM         AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'PLAN_YYYYMM')
			DECLARE @V_MSG2 NVARCHAR(100) = N' Over of Column Size'

			BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = CASE WHEN DATALENGTH(ATTRIBUTE7)  > @vPLAN_TP_CD  THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER1 + N'▷' + ATTRIBUTE7  + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE7))  +' > ' + CONVERT(NVARCHAR,@vPLAN_TP_CD)  +  @V_MSG2
											 WHEN DATALENGTH(ATTRIBUTE8)  > @vDATA_TP_CD  THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER2 + N'▷' + ATTRIBUTE8  + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE8))  +' > ' + CONVERT(NVARCHAR,@vDATA_TP_CD)  +  @V_MSG2
											 WHEN DATALENGTH(ATTRIBUTE9)  > @vSRCE_TP_CD  THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER3 + N'▷' + ATTRIBUTE9  + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE9))  +' > ' + CONVERT(NVARCHAR,@vSRCE_TP_CD)  +  @V_MSG2
											 WHEN DATALENGTH(ATTRIBUTE4)  > @vDIVISION_ID THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER4 + N'▷' + ATTRIBUTE4  + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE4))  +' > ' + CONVERT(NVARCHAR,@vDIVISION_ID) +  @V_MSG2
											 WHEN DATALENGTH(ATTRIBUTE6)  > @vPLANT_ID    THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER5 + N'▷' + ATTRIBUTE6  + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE6))  +' > ' + CONVERT(NVARCHAR,@vPLANT_ID)    +  @V_MSG2
											 WHEN DATALENGTH(ATTRIBUTE15) > @vITEM_ID     THEN N'행: ' + ATTRIBUTE100 + N' , 열: ' + @V_HEADER6 + N'▷' + ATTRIBUTE15 + SPACE(1)+CONVERT(NVARCHAR,DATALENGTH(ATTRIBUTE15)) +' > ' + CONVERT(NVARCHAR,@vITEM_ID)     +  @V_MSG2
										END
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND  (DATALENGTH(ATTRIBUTE7)  > @vPLAN_TP_CD
			  OR  DATALENGTH(ATTRIBUTE8)  > @vDATA_TP_CD
			  OR  DATALENGTH(ATTRIBUTE9)  > @vSRCE_TP_CD
			  OR  DATALENGTH(ATTRIBUTE4)  > @vDIVISION_ID
			  OR  DATALENGTH(ATTRIBUTE6)  > @vPLANT_ID
			  OR  DATALENGTH(ATTRIBUTE15) > @vITEM_ID
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

			-- 2.3 업로드한 데이터의 월별 수량 값에 숫자가 아닌 데이터가 존재하는지 검증
			--Error Message에 열을 표시하기위한 사전 작업
			DECLARE @V_HEADER7  NVARCHAR(50) = (SELECT ATTRIBUTE47 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER8  NVARCHAR(50) = (SELECT ATTRIBUTE48 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER9  NVARCHAR(50) = (SELECT ATTRIBUTE49 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER10 NVARCHAR(50) = (SELECT ATTRIBUTE50 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER11 NVARCHAR(50) = (SELECT ATTRIBUTE51 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER12 NVARCHAR(50) = (SELECT ATTRIBUTE52 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER13 NVARCHAR(50) = (SELECT ATTRIBUTE53 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER14 NVARCHAR(50) = (SELECT ATTRIBUTE54 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER15 NVARCHAR(50) = (SELECT ATTRIBUTE55 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER16 NVARCHAR(50) = (SELECT ATTRIBUTE56 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER17 NVARCHAR(50) = (SELECT ATTRIBUTE57 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER18 NVARCHAR(50) = (SELECT ATTRIBUTE58 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER19 NVARCHAR(50) = (SELECT ATTRIBUTE59 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			
			DECLARE @V_MSG3 NVARCHAR(100) = N'The quantity value contains non-numeric data.'
			BEGIN
            UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = CASE WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE47') > 0 AND (ATTRIBUTE47 IS NOT NULL AND LEN(ATTRIBUTE47) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE47,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER7  + N'▷' + ATTRIBUTE47 + SPACE(1) + ' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE48') > 0 AND (ATTRIBUTE48 IS NOT NULL AND LEN(ATTRIBUTE48) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE48,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER8  + N'▷' + ATTRIBUTE48 + SPACE(1) + ' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE49') > 0 AND (ATTRIBUTE49 IS NOT NULL AND LEN(ATTRIBUTE49) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE49,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER9  + N'▷' + ATTRIBUTE49 + SPACE(1) + ' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE50') > 0 AND (ATTRIBUTE50 IS NOT NULL AND LEN(ATTRIBUTE50) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE50,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER10 + N'▷' + ATTRIBUTE50 + SPACE(1) + ' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE51') > 0 AND (ATTRIBUTE51 IS NOT NULL AND LEN(ATTRIBUTE51) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE51,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER11 + N'▷' + ATTRIBUTE51 + SPACE(1) + ' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE52') > 0 AND (ATTRIBUTE52 IS NOT NULL AND LEN(ATTRIBUTE52) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE52,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER12 + N'▷' + ATTRIBUTE52 + SPACE(1) + ' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE53') > 0 AND (ATTRIBUTE53 IS NOT NULL AND LEN(ATTRIBUTE53) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE53,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER13 + N'▷' + ATTRIBUTE53 + SPACE(1) + ' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE54') > 0 AND (ATTRIBUTE54 IS NOT NULL AND LEN(ATTRIBUTE54) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE54,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER14 + N'▷' + ATTRIBUTE54 + SPACE(1) + ' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE55') > 0 AND (ATTRIBUTE55 IS NOT NULL AND LEN(ATTRIBUTE55) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE55,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER15 + N'▷' + ATTRIBUTE55 + SPACE(1) + ' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE56') > 0 AND (ATTRIBUTE56 IS NOT NULL AND LEN(ATTRIBUTE56) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE56,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER16 + N'▷' + ATTRIBUTE56 + SPACE(1) + ' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE57') > 0 AND (ATTRIBUTE57 IS NOT NULL AND LEN(ATTRIBUTE57) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE57,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER17 + N'▷' + ATTRIBUTE57 + SPACE(1) + ' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE58') > 0 AND (ATTRIBUTE58 IS NOT NULL AND LEN(ATTRIBUTE58) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE58,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER18 + N'▷' + ATTRIBUTE58 + SPACE(1) + ' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE59') > 0 AND (ATTRIBUTE59 IS NOT NULL AND LEN(ATTRIBUTE59) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE59,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER19 + N'▷' + ATTRIBUTE59 + SPACE(1) + ' = ' + @V_MSG3
									    END
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND  (((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE47') > 0 AND ATTRIBUTE47 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE47, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE47,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE48') > 0 AND ATTRIBUTE48 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE48, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE48,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE49') > 0 AND ATTRIBUTE49 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE49, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE49,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE50') > 0 AND ATTRIBUTE50 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE50, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE50,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE51') > 0 AND ATTRIBUTE51 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE51, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE51,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE52') > 0 AND ATTRIBUTE52 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE52, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE52,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE53') > 0 AND ATTRIBUTE53 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE53, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE53,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE54') > 0 AND ATTRIBUTE54 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE54, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE54,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE55') > 0 AND ATTRIBUTE55 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE55, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE55,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE56') > 0 AND ATTRIBUTE56 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE56, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE56,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE57') > 0 AND ATTRIBUTE57 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE57, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE57,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE58') > 0 AND ATTRIBUTE58 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE58, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE58,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE59') > 0 AND ATTRIBUTE59 IS NOT NULL AND LEN(REPLACE(ATTRIBUTE59, '', 0)) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE59,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			     )
			/* UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = CASE WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE47') > 0 AND (ATTRIBUTE47 IS NOT NULL AND LEN(ATTRIBUTE47) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE47,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE47+SPACE(1)+' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE48') > 0 AND (ATTRIBUTE48 IS NOT NULL AND LEN(ATTRIBUTE48) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE48,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE48+SPACE(1)+' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE49') > 0 AND (ATTRIBUTE49 IS NOT NULL AND LEN(ATTRIBUTE49) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE49,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE49+SPACE(1)+' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE50') > 0 AND (ATTRIBUTE50 IS NOT NULL AND LEN(ATTRIBUTE50) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE50,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE50+SPACE(1)+' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE51') > 0 AND (ATTRIBUTE51 IS NOT NULL AND LEN(ATTRIBUTE51) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE51,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE51+SPACE(1)+' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE52') > 0 AND (ATTRIBUTE52 IS NOT NULL AND LEN(ATTRIBUTE52) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE52,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE52+SPACE(1)+' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE53') > 0 AND (ATTRIBUTE53 IS NOT NULL AND LEN(ATTRIBUTE53) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE53,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE53+SPACE(1)+' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE54') > 0 AND (ATTRIBUTE54 IS NOT NULL AND LEN(ATTRIBUTE54) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE54,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE54+SPACE(1)+' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE55') > 0 AND (ATTRIBUTE55 IS NOT NULL AND LEN(ATTRIBUTE55) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE55,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE55+SPACE(1)+' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE56') > 0 AND (ATTRIBUTE56 IS NOT NULL AND LEN(ATTRIBUTE56) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE56,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE56+SPACE(1)+' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE57') > 0 AND (ATTRIBUTE57 IS NOT NULL AND LEN(ATTRIBUTE57) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE57,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE57+SPACE(1)+' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE58') > 0 AND (ATTRIBUTE58 IS NOT NULL AND LEN(ATTRIBUTE58) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE58,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE58+SPACE(1)+' = ' + @V_MSG3
											 WHEN (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE59') > 0 AND (ATTRIBUTE59 IS NOT NULL AND LEN(ATTRIBUTE59) > 0) AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE59,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN ATTRIBUTE59+SPACE(1)+' = ' + @V_MSG3
										END
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND  (((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE47') > 0 AND ATTRIBUTE47 IS NOT NULL AND LEN(ATTRIBUTE47) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE47,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE48') > 0 AND ATTRIBUTE48 IS NOT NULL AND LEN(ATTRIBUTE48) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE48,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE49') > 0 AND ATTRIBUTE49 IS NOT NULL AND LEN(ATTRIBUTE49) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE49,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE50') > 0 AND ATTRIBUTE50 IS NOT NULL AND LEN(ATTRIBUTE50) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE50,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE51') > 0 AND ATTRIBUTE51 IS NOT NULL AND LEN(ATTRIBUTE51) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE51,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE52') > 0 AND ATTRIBUTE52 IS NOT NULL AND LEN(ATTRIBUTE52) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE52,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE53') > 0 AND ATTRIBUTE53 IS NOT NULL AND LEN(ATTRIBUTE53) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE53,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE54') > 0 AND ATTRIBUTE54 IS NOT NULL AND LEN(ATTRIBUTE54) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE54,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE55') > 0 AND ATTRIBUTE55 IS NOT NULL AND LEN(ATTRIBUTE55) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE55,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE56') > 0 AND ATTRIBUTE56 IS NOT NULL AND LEN(ATTRIBUTE56) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE56,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE57') > 0 AND ATTRIBUTE57 IS NOT NULL AND LEN(ATTRIBUTE57) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE57,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE58') > 0 AND ATTRIBUTE58 IS NOT NULL AND LEN(ATTRIBUTE58) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE58,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE59') > 0 AND ATTRIBUTE59 IS NOT NULL AND LEN(ATTRIBUTE59) > 0 AND ISNULL(FORMAT(TRY_PARSE(ISNULL(ATTRIBUTE59,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL')
			     ) */
			END

			SELECT @V_ERR_CNT = COUNT(1) FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK)
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'ERROR'
			AND    MESSAGE_TEXT       LIKE '%' + @V_MSG3 + '%'

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
			DECLARE @V_HEADER20  NVARCHAR(50) = (SELECT ATTRIBUTE42 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')
			DECLARE @V_HEADER21  NVARCHAR(50) = (SELECT ATTRIBUTE44 FROM [SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK) WHERE PROGRAM_ID = @v_program_id AND SHEET_NAME = @v_sheet_name AND CREATED_BY = @p_created_by AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date AND UPLOAD_STATUS_CODE = '@TITLE')

			DECLARE @V_MSG4_1 NVARCHAR(100) = N'발생사유를 입력하십시오'     -- OCCR_RSN_CD(ATTRIBUTE42)
			DECLARE @V_MSG4_2 NVARCHAR(100) = N'소진방안을 입력하십시오'     -- EXHT_TP_CD(ATTRIBUTE44)
			DECLARE @V_MSG5   NVARCHAR(100) = N'잘못된 발생사유 유형입니다.' -- OCCR_RSN_CD(ATTRIBUTE42)
			DECLARE @V_MSG6   NVARCHAR(100) = N'잘못된 소진방안 유형입니다.' -- EXHT_TP_CD(ATTRIBUTE44)
			DECLARE @V_MSG7   NVARCHAR(100) = N'월별 수량 입력 불가.'        -- ITEM_TYPE(ATTRIBUTE10) / EXHT_TP_CD(ATTRIBUTE44)

			BEGIN TRY
			BEGIN
            UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = CASE WHEN ((ATTRIBUTE42 IS NULL OR LEN(RTRIM(LTRIM(ATTRIBUTE42))) = 0)) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER20  + N'▷' + ATTRIBUTE42 + SPACE(1) + ' = ' +  @V_MSG4_1
											 WHEN ((ATTRIBUTE44 IS NULL OR LEN(RTRIM(LTRIM(ATTRIBUTE44))) = 0)) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER21  + N'▷' + ATTRIBUTE44 + SPACE(1) + ' = ' +  @V_MSG4_2
											 WHEN ((ATTRIBUTE42 IS NOT NULL 
											        AND LEN(RTRIM(LTRIM(ATTRIBUTE42))) > 0 
													AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_OCCR_RSN_CD A WHERE A.NAME = ATTRIBUTE42) = 0
													)) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER20  + N'▷' + ATTRIBUTE42 + SPACE(1) + ' = ' +  @V_MSG5
											 WHEN ((ATTRIBUTE44 IS NOT NULL 
											        AND LEN(RTRIM(LTRIM(ATTRIBUTE44))) > 0 
													AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_EXHT_TP_CD A WHERE A.NAME = ATTRIBUTE44) = 0
													)) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER21  + N'▷' + ATTRIBUTE44 + SPACE(1) + ' = ' +  @V_MSG6
											 WHEN ((ATTRIBUTE10 IS NOT NULL 
											        AND LEN(RTRIM(LTRIM(ATTRIBUTE10))) > 0 
													AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION A WHERE A.ITEM_TYPE = ATTRIBUTE10) > 0
													AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION A WHERE A.EXHT_TP_CD = (SELECT CODE FROM #TEMP_SCM_LGTM_EXHT_TP_CD WHERE NAME = ATTRIBUTE44)) > 0
													)) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + @V_HEADER6 + ' , ' + @V_HEADER20 + N'▷' + ATTRIBUTE10 + ' , ' + ATTRIBUTE44 + SPACE(1) + ' = ' +  @V_MSG7
										END
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND  ((ATTRIBUTE42 IS NULL OR LEN(RTRIM(LTRIM(ATTRIBUTE42))) = 0)	--@V_MSG4_1
			  OR  (ATTRIBUTE44 IS NULL OR LEN(RTRIM(LTRIM(ATTRIBUTE44))) = 0)	--@V_MSG4_2
			  OR  ( ATTRIBUTE42 IS NOT NULL										--@V_MSG5
			        AND LEN(RTRIM(LTRIM(ATTRIBUTE42))) > 0 
					AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_OCCR_RSN_CD A WHERE A.NAME = ATTRIBUTE42) = 0 
				  )
			  OR  ( ATTRIBUTE44 IS NOT NULL										--@V_MSG6
			        AND LEN(RTRIM(LTRIM(ATTRIBUTE44))) > 0 
					AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_EXHT_TP_CD A WHERE A.NAME = ATTRIBUTE44) = 0 
				  )
			  OR  ( ATTRIBUTE10 IS NOT NULL										--@V_MSG7
			        AND LEN(RTRIM(LTRIM(ATTRIBUTE10))) > 0 
					AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION A WHERE A.ITEM_TYPE = ATTRIBUTE10) > 0 
					AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION A WHERE A.EXHT_TP_CD = (SELECT CODE FROM #TEMP_SCM_LGTM_EXHT_TP_CD WHERE NAME = ATTRIBUTE44)) > 0 
				  )																--@V_MSG8
			     )
			/* UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = CASE WHEN ((ATTRIBUTE42 IS NULL OR LEN(RTRIM(LTRIM(ATTRIBUTE42))) = 0)) THEN @V_MSG4_1
											 WHEN ((ATTRIBUTE44 IS NULL OR LEN(RTRIM(LTRIM(ATTRIBUTE44))) = 0)) THEN @V_MSG4_2
											 WHEN ((ATTRIBUTE42 IS NOT NULL 
											        AND LEN(RTRIM(LTRIM(ATTRIBUTE42))) > 0 
													AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_OCCR_RSN_CD A WHERE A.NAME = ATTRIBUTE42) = 0
													)) THEN @V_MSG5
											 WHEN ((ATTRIBUTE44 IS NOT NULL 
											        AND LEN(RTRIM(LTRIM(ATTRIBUTE44))) > 0 
													AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_EXHT_TP_CD A WHERE A.NAME = ATTRIBUTE44) = 0
													)) THEN @V_MSG6
											 WHEN ((ATTRIBUTE10 IS NOT NULL 
											        AND LEN(RTRIM(LTRIM(ATTRIBUTE10))) > 0 
													AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION A WHERE A.ITEM_TYPE = ATTRIBUTE10) > 0
													AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION A WHERE A.EXHT_TP_CD = ATTRIBUTE44) > 0
													)) THEN @V_MSG7
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE47') > 0 AND ATTRIBUTE47 IS NOT NULL AND LEN(ATTRIBUTE47) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) <= 0) THEN @V_MSG8
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE48') > 0 AND ATTRIBUTE48 IS NOT NULL AND LEN(ATTRIBUTE48) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE48) <= 0) THEN @V_MSG8
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE49') > 0 AND ATTRIBUTE49 IS NOT NULL AND LEN(ATTRIBUTE49) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE49) <= 0) THEN @V_MSG8
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE50') > 0 AND ATTRIBUTE50 IS NOT NULL AND LEN(ATTRIBUTE50) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE50) <= 0) THEN @V_MSG8
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE51') > 0 AND ATTRIBUTE51 IS NOT NULL AND LEN(ATTRIBUTE51) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE51) <= 0) THEN @V_MSG8
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE52') > 0 AND ATTRIBUTE52 IS NOT NULL AND LEN(ATTRIBUTE52) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE52) <= 0) THEN @V_MSG8
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE53') > 0 AND ATTRIBUTE53 IS NOT NULL AND LEN(ATTRIBUTE53) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE53) <= 0) THEN @V_MSG8
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE54') > 0 AND ATTRIBUTE54 IS NOT NULL AND LEN(ATTRIBUTE54) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE54) <= 0) THEN @V_MSG8
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE55') > 0 AND ATTRIBUTE55 IS NOT NULL AND LEN(ATTRIBUTE55) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE55) <= 0) THEN @V_MSG8
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE56') > 0 AND ATTRIBUTE56 IS NOT NULL AND LEN(ATTRIBUTE56) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE56) <= 0) THEN @V_MSG8
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE57') > 0 AND ATTRIBUTE57 IS NOT NULL AND LEN(ATTRIBUTE57) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE57) <= 0) THEN @V_MSG8
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE58') > 0 AND ATTRIBUTE58 IS NOT NULL AND LEN(ATTRIBUTE58) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE58) <= 0) THEN @V_MSG8
											 WHEN ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE59') > 0 AND ATTRIBUTE59 IS NOT NULL AND LEN(ATTRIBUTE59) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE59) <= 0) THEN @V_MSG8
										END
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND  ((ATTRIBUTE42 IS NULL OR LEN(RTRIM(LTRIM(ATTRIBUTE42))) = 0)	--@V_MSG4_1
			  OR  (ATTRIBUTE44 IS NULL OR LEN(RTRIM(LTRIM(ATTRIBUTE44))) = 0)	--@V_MSG4_2
			  OR  ( ATTRIBUTE42 IS NOT NULL										--@V_MSG5
			        AND LEN(RTRIM(LTRIM(ATTRIBUTE42))) > 0 
					AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_OCCR_RSN_CD A WHERE A.NAME = ATTRIBUTE42) = 0 
				  )
			  OR  ( ATTRIBUTE44 IS NOT NULL										--@V_MSG6
			        AND LEN(RTRIM(LTRIM(ATTRIBUTE44))) > 0 
					AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_EXHT_TP_CD A WHERE A.NAME = ATTRIBUTE44) = 0 
				  )
			  OR  ( ATTRIBUTE10 IS NOT NULL										--@V_MSG7
			        AND LEN(RTRIM(LTRIM(ATTRIBUTE10))) > 0 
					AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION A WHERE A.ITEM_TYPE = ATTRIBUTE10) > 0 
					AND (SELECT COUNT(1) FROM #TEMP_SCM_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION A WHERE A.EXHT_TP_CD = ATTRIBUTE44) > 0 
				  )																--@V_MSG8
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE47') > 0 AND ATTRIBUTE47 IS NOT NULL AND LEN(ATTRIBUTE47) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) <= 0)
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE48') > 0 AND ATTRIBUTE48 IS NOT NULL AND LEN(ATTRIBUTE48) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE48) <= 0)
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE49') > 0 AND ATTRIBUTE49 IS NOT NULL AND LEN(ATTRIBUTE49) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE49) <= 0)
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE50') > 0 AND ATTRIBUTE50 IS NOT NULL AND LEN(ATTRIBUTE50) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE50) <= 0)
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE51') > 0 AND ATTRIBUTE51 IS NOT NULL AND LEN(ATTRIBUTE51) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE51) <= 0)
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE52') > 0 AND ATTRIBUTE52 IS NOT NULL AND LEN(ATTRIBUTE52) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE52) <= 0)
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE53') > 0 AND ATTRIBUTE53 IS NOT NULL AND LEN(ATTRIBUTE53) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE53) <= 0)
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE54') > 0 AND ATTRIBUTE54 IS NOT NULL AND LEN(ATTRIBUTE54) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE54) <= 0)
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE55') > 0 AND ATTRIBUTE55 IS NOT NULL AND LEN(ATTRIBUTE55) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE55) <= 0)
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE56') > 0 AND ATTRIBUTE56 IS NOT NULL AND LEN(ATTRIBUTE56) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE56) <= 0)
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE57') > 0 AND ATTRIBUTE57 IS NOT NULL AND LEN(ATTRIBUTE57) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE57) <= 0)
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE58') > 0 AND ATTRIBUTE58 IS NOT NULL AND LEN(ATTRIBUTE58) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE58) <= 0)
			  OR  ((SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE59') > 0 AND ATTRIBUTE59 IS NOT NULL AND LEN(ATTRIBUTE59) > 0 AND CONVERT(NUMERIC(30,8), ATTRIBUTE59) <= 0)
			     ) */
			END
			END TRY
			BEGIN CATCH 
				BEGIN
				SET @v_err_message=  ERROR_MESSAGE();
				------------------------------------------------------------------------
				--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
				SET @v_log_type = '9-1';
				SET @v_log_message = '########## Validation Check - DB - SQL ERROR ##########';
				--SET @v_description = N'UI ExcelUpload 화면의 Message 항목을 확인해주세요.';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_err_message, @d_event_date;
				------------------------------------------------------------------------
				END;
			END CATCH;

			SELECT @V_ERR_CNT = COUNT(1) FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK)
			            WHERE  PROGRAM_ID         = @v_program_id
						AND    SHEET_NAME         = @v_sheet_name
						AND    CREATED_BY         = @p_created_by
						AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
						AND    UPLOAD_STATUS_CODE = 'ERROR'
						/* AND    ( MESSAGE_TEXT       LIKE '%' + @V_MSG4_1 + '%'
							OR
	 							 MESSAGE_TEXT       LIKE '%' + @V_MSG4_2 + '%'
							OR
	 							 MESSAGE_TEXT       LIKE '%' + @V_MSG5 + '%'
							OR
	 							 MESSAGE_TEXT       LIKE '%' + @V_MSG6 + '%'
							OR
	 							 MESSAGE_TEXT       LIKE '%' + @V_MSG7 + '%'
							OR
	 							 MESSAGE_TEXT       LIKE '%' + @V_MSG8 + '%'
								) */
								
			IF @V_ERR_CNT > 0
			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
			SET @v_log_type = '9-1';
			SET @v_log_message = '########## Validation Check - DB - ERROR ##########';
			SET @v_description = N'UI ExcelUpload 화면의 Message 항목을 확인해주세요. - ' + CONVERT(NVARCHAR,@V_ERR_CNT) + N'건';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			END;
			ELSE
			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
			SET @v_log_type = '9-1';
			SET @v_log_message = '########## Validation Check - DB - SUCCESS ##########';
			SET @v_description = N'발생사유 / 소진방안을 입력 여부,잘못된 발생사유,소진방안 유형 확인,월별 수량 입력 불가 케이스 확인 - PASS';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			END;

			-- 2.8 if (qty < 0) Qty must be greater than or equal to 0
			DECLARE @V_MSG8   NVARCHAR(100) = N'Qty must be greater than or equal to 0'
			DECLARE @V_VAL1	 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE47')
			DECLARE @V_VAL2	 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE48')
			DECLARE @V_VAL3	 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE49')
			DECLARE @V_VAL4	 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE50')
			DECLARE @V_VAL5	 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE51')
			DECLARE @V_VAL6	 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE52')
			DECLARE @V_VAL7	 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE53')
			DECLARE @V_VAL8	 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE54')
			DECLARE @V_VAL9	 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE55')
			DECLARE @V_VAL10 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE56')
			DECLARE @V_VAL11 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE57')
			DECLARE @V_VAL12 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE58')
			DECLARE @V_VAL13 INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE59')

			BEGIN TRY
			BEGIN
            UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       =  CASE WHEN (@V_VAL1  = 1 AND ATTRIBUTE47 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE47') + ' : ' + ATTRIBUTE47 + SPACE(1) + ' = ' + @V_MSG8
						      				  WHEN (@V_VAL2  = 1 AND ATTRIBUTE48 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE48) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE48') + ' : ' + ATTRIBUTE48 + SPACE(1) + ' = ' + @V_MSG8
											  WHEN (@V_VAL3  = 1 AND ATTRIBUTE49 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE49) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE49') + ' : ' + ATTRIBUTE49 + SPACE(1) + ' = ' + @V_MSG8
											  WHEN (@V_VAL4  = 1 AND ATTRIBUTE50 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE50) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE50') + ' : ' + ATTRIBUTE50 + SPACE(1) + ' = ' + @V_MSG8
											  WHEN (@V_VAL5  = 1 AND ATTRIBUTE51 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE51) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE51') + ' : ' + ATTRIBUTE51 + SPACE(1) + ' = ' + @V_MSG8
											  WHEN (@V_VAL6  = 1 AND ATTRIBUTE52 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE52) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE52') + ' : ' + ATTRIBUTE52 + SPACE(1) + ' = ' + @V_MSG8
											  WHEN (@V_VAL7  = 1 AND ATTRIBUTE53 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE53) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE53') + ' : ' + ATTRIBUTE53 + SPACE(1) + ' = ' + @V_MSG8
											  WHEN (@V_VAL8  = 1 AND ATTRIBUTE54 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE54) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE54') + ' : ' + ATTRIBUTE54 + SPACE(1) + ' = ' + @V_MSG8
											  WHEN (@V_VAL9  = 1 AND ATTRIBUTE55 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE55) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE55') + ' : ' + ATTRIBUTE55 + SPACE(1) + ' = ' + @V_MSG8
											  WHEN (@V_VAL10 = 1 AND ATTRIBUTE56 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE56) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE56') + ' : ' + ATTRIBUTE56 + SPACE(1) + ' = ' + @V_MSG8
											  WHEN (@V_VAL11 = 1 AND ATTRIBUTE57 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE57) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE57') + ' : ' + ATTRIBUTE57 + SPACE(1) + ' = ' + @V_MSG8
											  WHEN (@V_VAL12 = 1 AND ATTRIBUTE58 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE58) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE58') + ' : ' + ATTRIBUTE58 + SPACE(1) + ' = ' + @V_MSG8
											  WHEN (@V_VAL13 = 1 AND ATTRIBUTE59 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE59) < 0) THEN N'행: '+ ATTRIBUTE100 + N' , 열: ' + (SELECT A.YYYYMM FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE59') + ' : ' + ATTRIBUTE59 + SPACE(1) + ' = ' + @V_MSG8
										 END
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND  (					--@V_MSG8
			          (@V_VAL1  = 1 AND ATTRIBUTE47 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) < 0)
				  OR  (@V_VAL2  = 1 AND ATTRIBUTE48 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE48) < 0)
				  OR  (@V_VAL3  = 1 AND ATTRIBUTE49 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE49) < 0)
				  OR  (@V_VAL4  = 1 AND ATTRIBUTE50 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE50) < 0)
				  OR  (@V_VAL5  = 1 AND ATTRIBUTE51 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE51) < 0)
				  OR  (@V_VAL6  = 1 AND ATTRIBUTE52 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE52) < 0)
				  OR  (@V_VAL7  = 1 AND ATTRIBUTE53 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE53) < 0)
				  OR  (@V_VAL8  = 1 AND ATTRIBUTE54 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE54) < 0)
				  OR  (@V_VAL9  = 1 AND ATTRIBUTE55 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE55) < 0)
				  OR  (@V_VAL10 = 1 AND ATTRIBUTE56 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE56) < 0)
				  OR  (@V_VAL11 = 1 AND ATTRIBUTE57 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE57) < 0)
				  OR  (@V_VAL12 = 1 AND ATTRIBUTE58 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE58) < 0)
				  OR  (@V_VAL13 = 1 AND ATTRIBUTE59 IS NOT NULL AND CONVERT(NUMERIC(30,8), ATTRIBUTE59) < 0)
			     )
			END
			END TRY
			BEGIN CATCH 
				BEGIN
				SET @v_err_message=  ERROR_MESSAGE();
				------------------------------------------------------------------------
				--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
				SET @v_log_type = '9-2';
				SET @v_log_message = '########## Validation Check - DB - SQL ERROR ##########';
				--SET @v_description = N'UI ExcelUpload 화면의 Message 항목을 확인해주세요.';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_err_message, @d_event_date;
				------------------------------------------------------------------------
				END;
			END CATCH;

			SELECT @V_ERR_CNT = COUNT(1) FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK)
			            WHERE  PROGRAM_ID         = @v_program_id
						AND    SHEET_NAME         = @v_sheet_name
						AND    CREATED_BY         = @p_created_by
						AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
						AND    UPLOAD_STATUS_CODE = 'ERROR'
						AND    MESSAGE_TEXT       LIKE '%' + @V_MSG8 + '%'

			IF @V_ERR_CNT > 0
			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
			SET @v_log_type = '9-2';
			SET @v_log_message = '########## Validation Check - DB - ERROR ##########';
			SET @v_description = N'UI ExcelUpload 화면의 Message 항목을 확인해주세요. - ' + CONVERT(NVARCHAR,@V_ERR_CNT) + N'건';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			END;
			ELSE
			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
			SET @v_log_type = '9-2';
			SET @v_log_message = '########## Validation Check - DB - SUCCESS ##########';
			SET @v_description = N'Qty must be greater than or equal to 0';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			END;

			-- 2.9 월별 입력한 수량의 합계는, Quantity를 초과할 수 없습니다.
			DECLARE @V_MSG9   NVARCHAR(100) = N'월별 입력한 수량의 합계는, Quantity를 초과할 수 없습니다.'
			DECLARE @V_EDIT_YYYYMM_CNT INT = (SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM)
			--SELECT COUNT(1) FROM #TEMP_EDIT_YYYYMM A WHERE A.COLUMN_NAME = 'ATTRIBUTE47') > 0 OR문에 넣었더니.. 이상하게도 다음 구문도 실행되서 에러나는 경우가 있었는데 이렇게 하면 정상작동

			--ATTRIBUTE47 이후는 입력자 입력일자 빼고 값...
			--ATTRIBUTE34 는 TOTAL
			BEGIN TRY
			BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				  , MESSAGE_TEXT =  N'행:'+ ATTRIBUTE100 + SPACE(1) + 'Total(UOM) :' + ATTRIBUTE34 + ' , ' + @V_MSG9
				 --, MESSAGE_TEXT       = CASE WHEN @V_EDIT_YYYYMM_CNT = 1  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--	  				     WHEN @V_EDIT_YYYYMM_CNT = 2  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--						 WHEN @V_EDIT_YYYYMM_CNT = 3  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--						 WHEN @V_EDIT_YYYYMM_CNT = 4  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50) > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--						 WHEN @V_EDIT_YYYYMM_CNT = 5  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE51) > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--						 WHEN @V_EDIT_YYYYMM_CNT = 6  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--						 WHEN @V_EDIT_YYYYMM_CNT = 7  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--						 WHEN @V_EDIT_YYYYMM_CNT = 8  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) + CONVERT(NUMERIC(30,8), ATTRIBUTE54) > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--						 WHEN @V_EDIT_YYYYMM_CNT = 9  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) + CONVERT(NUMERIC(30,8), ATTRIBUTE54) 
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE55)  > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--						 WHEN @V_EDIT_YYYYMM_CNT = 10 AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) + CONVERT(NUMERIC(30,8), ATTRIBUTE54) 
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE55) + CONVERT(NUMERIC(30,8), ATTRIBUTE56)  > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--						 WHEN @V_EDIT_YYYYMM_CNT = 11 AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) + CONVERT(NUMERIC(30,8), ATTRIBUTE54) 
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE55) + CONVERT(NUMERIC(30,8), ATTRIBUTE56) + CONVERT(NUMERIC(30,8), ATTRIBUTE57) > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--						 WHEN @V_EDIT_YYYYMM_CNT = 12 AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) + CONVERT(NUMERIC(30,8), ATTRIBUTE54) 
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE55) + CONVERT(NUMERIC(30,8), ATTRIBUTE56) + CONVERT(NUMERIC(30,8), ATTRIBUTE57) + CONVERT(NUMERIC(30,8), ATTRIBUTE58) > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--						 WHEN @V_EDIT_YYYYMM_CNT = 13 AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) + CONVERT(NUMERIC(30,8), ATTRIBUTE54) 
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE55) + CONVERT(NUMERIC(30,8), ATTRIBUTE56) + CONVERT(NUMERIC(30,8), ATTRIBUTE57) + CONVERT(NUMERIC(30,8), ATTRIBUTE58) 
					--													    + CONVERT(NUMERIC(30,8), ATTRIBUTE59) > CONVERT(NUMERIC(30,8), ATTRIBUTE34) THEN @V_MSG9
					--					END
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND  ((@V_EDIT_YYYYMM_CNT = 1  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
   			  OR  (@V_EDIT_YYYYMM_CNT = 2  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
			  OR  (@V_EDIT_YYYYMM_CNT = 3  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
			  OR  (@V_EDIT_YYYYMM_CNT = 4  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
			  OR  (@V_EDIT_YYYYMM_CNT = 5  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE51) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
			  OR  (@V_EDIT_YYYYMM_CNT = 6  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
			  OR  (@V_EDIT_YYYYMM_CNT = 7  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
			  OR  (@V_EDIT_YYYYMM_CNT = 8  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) + CONVERT(NUMERIC(30,8), ATTRIBUTE54) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
			  OR  (@V_EDIT_YYYYMM_CNT = 9  AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) + CONVERT(NUMERIC(30,8), ATTRIBUTE54)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE55) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
			  OR  (@V_EDIT_YYYYMM_CNT = 10 AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) + CONVERT(NUMERIC(30,8), ATTRIBUTE54)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE55) + CONVERT(NUMERIC(30,8), ATTRIBUTE56) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
			  OR  (@V_EDIT_YYYYMM_CNT = 11 AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) + CONVERT(NUMERIC(30,8), ATTRIBUTE54)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE55) + CONVERT(NUMERIC(30,8), ATTRIBUTE56) + CONVERT(NUMERIC(30,8), ATTRIBUTE57) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
			  OR  (@V_EDIT_YYYYMM_CNT = 12 AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) + CONVERT(NUMERIC(30,8), ATTRIBUTE54)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE55) + CONVERT(NUMERIC(30,8), ATTRIBUTE56) + CONVERT(NUMERIC(30,8), ATTRIBUTE57) + CONVERT(NUMERIC(30,8), ATTRIBUTE58) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
			  OR  (@V_EDIT_YYYYMM_CNT = 13 AND CONVERT(NUMERIC(30,8), ATTRIBUTE47) + CONVERT(NUMERIC(30,8), ATTRIBUTE48) + CONVERT(NUMERIC(30,8), ATTRIBUTE49) + CONVERT(NUMERIC(30,8), ATTRIBUTE50)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE51) + CONVERT(NUMERIC(30,8), ATTRIBUTE52) + CONVERT(NUMERIC(30,8), ATTRIBUTE53) + CONVERT(NUMERIC(30,8), ATTRIBUTE54)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE55) + CONVERT(NUMERIC(30,8), ATTRIBUTE56) + CONVERT(NUMERIC(30,8), ATTRIBUTE57) + CONVERT(NUMERIC(30,8), ATTRIBUTE58)
											 + CONVERT(NUMERIC(30,8), ATTRIBUTE59) > CONVERT(NUMERIC(30,8), ATTRIBUTE34))
				 )
			END
			END TRY
			BEGIN CATCH
			SET @v_err_message=  ERROR_MESSAGE();
			SET @v_log_type = '10';
			SET @v_log_message = '########## Validation Check - DB - SQL ERROR ##########';
			--SET @v_description = N'월별 입력한 수량의 합계는, Quantity를 초과할 수 없습니다. - ' + CONVERT(NVARCHAR,@V_ERR_CNT) + N'건';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_err_message, @d_event_date;
			END CATCH;

			SELECT @V_ERR_CNT = COUNT(1) FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] WITH(NOLOCK)
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'ERROR'
			AND    MESSAGE_TEXT       LIKE '%' + @V_MSG9 + '%'

			IF @V_ERR_CNT > 0
			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
			SET @v_log_type = '10';
			SET @v_log_message = '########## Validation Check - DB - ERROR ##########';
			SET @v_description = N'월별 입력한 수량의 합계는, Quantity를 초과할 수 없습니다. - ' + CONVERT(NVARCHAR,@V_ERR_CNT) + N'건';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			END
			ELSE
			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
			SET @v_log_type = '10';
			SET @v_log_message = '########## Validation Check - DB - SUCCESS ##########';
			SET @v_description = N'월별 입력한 수량의 합계는, Quantity를 초과할 수 없습니다. - PASS';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
			END;
------------------------------------------------------------------Validation Check 종료후 작성 - 시작------------------------------------------------------------------

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
		IF OBJECT_ID(N'tempdb..#TEMP_SCP_ANL_LGTM_INV_MGMT_PLAN', N'U') IS NOT NULL
			DROP TABLE #TEMP_SCP_ANL_LGTM_INV_MGMT_PLAN

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID(N'dbo.#TEMP_SCP_ANL_LGTM_INV_MGMT_PLAN', N'U') IS NOT NULL
			DROP TABLE #TEMP_SCP_ANL_LGTM_INV_MGMT_PLAN

			CREATE TABLE #TEMP_SCP_ANL_LGTM_INV_MGMT_PLAN(
				PLAN_START_YYYYMMDD NVARCHAR(200),
				PLAN_TP_CD			NVARCHAR(200),
				DATA_TP_CD			NVARCHAR(200),
				SRCE_TP_CD		    NVARCHAR(200),
				DIVISION_ID         NVARCHAR(200),
				PLANT_ID			NVARCHAR(200),
				ITEM_ID				NVARCHAR(200),
				PLAN_YYYYMM			NVARCHAR(200),
				QTY					NUMERIC(30,8),
				OCCR_RSN_CD			NVARCHAR(200),
				OCCR_RSN_CTN		NVARCHAR(200),
				EXHT_TP_CD			NVARCHAR(200),
				EXHT_TP_CTN			NVARCHAR(200),
				IMPU_DEPT_NM		NVARCHAR(200),
				CREATION_DATE		DATETIME,     
			);

		INSERT INTO #TEMP_SCP_ANL_LGTM_INV_MGMT_PLAN
		SELECT * 
		FROM
		(
		SELECT A.PLAN_START_YYYYMMDD, A.PLAN_TP_CD, A.DATA_TP_CD, A.SRCE_TP_CD, A.DIVISION_ID, A.PLANT_ID, A.ITEM_ID
		, CASE A.PLAN_YYYYMM WHEN 'ATTRIBUTE47' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE47,2) + RIGHT(B.ATTRIBUTE47,2)
							 WHEN 'ATTRIBUTE48' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE48,2) + RIGHT(B.ATTRIBUTE48,2) 
							 WHEN 'ATTRIBUTE49' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE49,2) + RIGHT(B.ATTRIBUTE49,2) 
							 WHEN 'ATTRIBUTE50' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE50,2) + RIGHT(B.ATTRIBUTE50,2) 
							 WHEN 'ATTRIBUTE51' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE51,2) + RIGHT(B.ATTRIBUTE51,2) 
							 WHEN 'ATTRIBUTE52' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE52,2) + RIGHT(B.ATTRIBUTE52,2) 
							 WHEN 'ATTRIBUTE53' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE53,2) + RIGHT(B.ATTRIBUTE53,2)
							 WHEN 'ATTRIBUTE54' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE54,2) + RIGHT(B.ATTRIBUTE54,2) 
							 WHEN 'ATTRIBUTE55' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE55,2) + RIGHT(B.ATTRIBUTE55,2) 
							 WHEN 'ATTRIBUTE56' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE56,2) + RIGHT(B.ATTRIBUTE56,2) 
							 WHEN 'ATTRIBUTE57' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE57,2) + RIGHT(B.ATTRIBUTE57,2) 
							 WHEN 'ATTRIBUTE58' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE58,2) + RIGHT(B.ATTRIBUTE58,2) 
							 WHEN 'ATTRIBUTE59' THEN LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(B.ATTRIBUTE59,2) + RIGHT(B.ATTRIBUTE59,2) 
		  END AS PLAN_YYYYMM
		, A.QTY, (SELECT CODE FROM #TEMP_SCM_LGTM_OCCR_RSN_CD WHERE NAME = A.OCCR_RSN_CD) AS OCCR_RSN_CD, A.OCCR_RSN_CTN, (SELECT CODE FROM #TEMP_SCM_LGTM_EXHT_TP_CD WHERE NAME = A.EXHT_TP_CD) AS EXHT_TP_CD, A.EXHT_TP_CTN, A.IMPU_DEPT_NM, A.CREATION_DATE
		FROM
		(
		SELECT ATTRIBUTE1  AS PLAN_START_YYYYMMDD
		     , ATTRIBUTE4  AS DIVISION_ID
			 , ATTRIBUTE6  AS PLANT_ID
			 , ATTRIBUTE7  AS PLAN_TP_CD
			 , ATTRIBUTE8  AS DATA_TP_CD
			 , ATTRIBUTE9  AS SRCE_TP_CD
			 , ATTRIBUTE15 AS ITEM_ID
			 , ATTRIBUTE41 AS IMPU_DEPT_NM
			 , ATTRIBUTE42 AS OCCR_RSN_CD
			 , ATTRIBUTE43 AS OCCR_RSN_CTN
			 , ATTRIBUTE44 AS EXHT_TP_CD
			 , ATTRIBUTE45 AS EXHT_TP_CTN
			 , UNPVT.PLAN_YYYYMM
			 ,SUM(CASE WHEN ISNULL(FORMAT(TRY_PARSE(ISNULL(QTY,'0') AS NUMERIC(30,8)),'#.########'),'FAIL')  = 'FAIL' THEN 0 ELSE CONVERT(NUMERIC(30,8),ISNULL(QTY,0)) END)  QTY
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
			) T
			UNPIVOT 
			(QTY
				FOR	PLAN_YYYYMM
								IN(
									   T.ATTRIBUTE47 , T.ATTRIBUTE48, T.ATTRIBUTE49, T.ATTRIBUTE50, T.ATTRIBUTE51, T.ATTRIBUTE52
									 , T.ATTRIBUTE53 , T.ATTRIBUTE54, T.ATTRIBUTE55, T.ATTRIBUTE56, T.ATTRIBUTE57, T.ATTRIBUTE58
									 , T.ATTRIBUTE59 
								  )
			) AS UNPVT
			GROUP BY CREATION_DATE, ATTRIBUTE1 , ATTRIBUTE4  , ATTRIBUTE6  , ATTRIBUTE7  , ATTRIBUTE8  , ATTRIBUTE9		
			                      , ATTRIBUTE15, ATTRIBUTE41 , ATTRIBUTE42 , ATTRIBUTE43 , ATTRIBUTE44 , ATTRIBUTE45
								  , PLAN_YYYYMM
		) A
		INNER JOIN (SELECT * 
					FROM [SCM_ADM_EXCEL_UPLOAD] X WITH(NOLOCK)
					WHERE X.PROGRAM_ID = @v_program_id 
					  AND X.SHEET_NAME = @v_sheet_name 
					  AND X.CREATED_BY = @p_created_by
					  AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date 
					  AND UPLOAD_STATUS_CODE = '@TITLE'
					) B
		ON A.CREATION_DATE = B.CREATION_DATE
		) TEMP_TABLE
		WHERE PLAN_YYYYMM IN (SELECT YYYYMM FROM #TEMP_EDIT_YYYYMM) --필터를 해야 엉뚱한 값 방지..
		END;

		----------------------------------------------------------------------------
		SET @v_log_type = '13';
		SET @v_log_message = '########## SUCCESS ##########';
		SET @v_description = N'#TEMP_SCP_ANL_LGTM_INV_MGMT_PLAN 임시테이블 생성 성공';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		----------------------------------------------------------------------------

-------------------------------------------------------------임시테이블 생성 종료-------------------------------------------------------------
--		BEGIN
--		SET @v_start_yyyymmdd = '';
--	    SET @v_end_yyyymmdd = '';
--		END;
--
--		BEGIN
--		--기존 데이터 범위를 파악하기 위한 쿼리
--		SELECT @v_start_yyyymmdd = D.MIN_YYYYMM
--		     , @v_end_yyyymmdd = D.MAX_YYYYMM
--		FROM  (				
--		       SELECT MIN(LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(X.YYYYMM,2) + RIGHT(X.YYYYMM,2)) AS MIN_YYYYMM
--		            , MAX(LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(X.YYYYMM,2) + RIGHT(X.YYYYMM,2)) AS MAX_YYYYMM
--               FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
--	                 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
--                     , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
--	                 , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
--	                 , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
--                     , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
--		             , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
--		             , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
--		             , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
--		             , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
--		             , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
--		             , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
--		             , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
--                FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)
--		        WHERE  1 = 1
--		        AND    PROGRAM_ID    = @v_program_id
--	            AND    SHEET_NAME    = @v_sheet_name
--		        AND    CREATED_BY    = @p_created_by
--                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
--		        AND    UPLOAD_STATUS_CODE = '@TITLE'
--               ) T
--       UNPIVOT (    YYYYMM
--                FOR COLUMN_NAME
--		        IN   (  
--					 --(월별 데이터 yyyymm)
--					   ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50, ATTRIBUTE51, ATTRIBUTE52
--					 , ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58
--					 , ATTRIBUTE59
--				     )
--		           ) AS X
--		WHERE   X.YYYYMM != '' 
--			AND LEFT(DATEPART(YYYY, GETDATE()),2) + LEFT(X.YYYYMM,2) + RIGHT(X.YYYYMM,2) IN (SELECT YYYYMM FROM #TEMP_EDIT_YYYYMM)
--		) AS D;			
--        END;

		BEGIN TRANSACTION SCP0113_EXCEL_UPLOAD;
		BEGIN TRY
			BEGIN

        ----------------------------------------------------------------------------
		SET @v_log_type = '14';
		SET @v_log_message = '########## START - MERGE - SCP_ANL_LGTM_INV_MGMT_PLAN ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------		

		MERGE INTO SCP_ANL_LGTM_INV_MGMT_PLAN AS A
		USING (SELECT * FROM #TEMP_SCP_ANL_LGTM_INV_MGMT_PLAN WITH(NOLOCK)) AS B
		   ON (
		       A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
		   AND A.PLAN_TP_CD          = B.PLAN_TP_CD
		   AND A.DATA_TP_CD          = B.DATA_TP_CD
		   AND A.SRCE_TP_CD          = B.SRCE_TP_CD
		   AND A.DIVISION_ID         = B.DIVISION_ID
		   AND A.PLANT_ID            = B.PLANT_ID
		   AND A.ITEM_ID             = B.ITEM_ID
		   AND A.PLAN_YYYYMM         = B.PLAN_YYYYMM
		   )
		 --WHEN MATCHED AND B.QTY <> 0 THEN
		WHEN MATCHED AND B.QTY >= 0 THEN
		   UPDATE SET 
			   A.QTY              = B.QTY
			  ,A.OCCR_RSN_CD      = B.OCCR_RSN_CD
			  ,A.OCCR_RSN_CTN     = B.OCCR_RSN_CTN
			  ,A.EXHT_TP_CD       = B.EXHT_TP_CD
			  ,A.EXHT_TP_CTN      = B.EXHT_TP_CTN
			  ,A.IMPU_DEPT_NM     = B.IMPU_DEPT_NM
			  ,A.LAST_UPDATED_BY  = @p_created_by
			  ,A.LAST_UPDATE_DATE = @v_creation_date
		 --WHEN NOT MATCHED AND B.QTY <> 0 THEN
		WHEN NOT MATCHED AND B.QTY >= 0 THEN
		   INSERT           
				(
					 PLAN_START_YYYYMMDD
					,PLAN_TP_CD
					,DATA_TP_CD
					,SRCE_TP_CD
					,DIVISION_ID
					,PLANT_ID
					,ITEM_ID
					,PLAN_YYYYMM
					,QTY
					,OCCR_RSN_CD
					,OCCR_RSN_CTN
					,EXHT_TP_CD
					,EXHT_TP_CTN
					,CREATE_DATE
					,CREATED_BY
					,LAST_UPDATE_DATE
					,LAST_UPDATED_BY
					,IMPU_DEPT_NM
			   )
		   VALUES
	   			(
					 B.PLAN_START_YYYYMMDD
					,B.PLAN_TP_CD
					,B.DATA_TP_CD
					,B.SRCE_TP_CD
					,B.DIVISION_ID
					,B.PLANT_ID
					,B.ITEM_ID
					,B.PLAN_YYYYMM
					,B.QTY
					,B.OCCR_RSN_CD
					,B.OCCR_RSN_CTN
					,B.EXHT_TP_CD
					,B.EXHT_TP_CTN
					,@v_creation_date
					,@p_created_by
					,@v_creation_date
					,@p_created_by
					,B.IMPU_DEPT_NM
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
		    ROLLBACK TRANSACTION SCP0113_EXCEL_UPLOAD;
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
