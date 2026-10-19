



-- =============================================
-- Author:		 P.C.I
-- Create date:  2024-07-31
-- Description:	 SCM_MST_FUTURE_PRICE_C Incoterms, G480 Plant
-- 실적기준으로 Incoterms Conversion 진행
-- =============================================
CREATE PROCEDURE [dbo].[PR_TMP_NERP_SCM_MST_FUTURE_PRICE_C]
    @p_period_type NVARCHAR(100) --LATEST(최근 데이터), OTHERS(최근 데이터를 제외한 나머지 모두)

AS

BEGIN 

	BEGIN TRY
	--------------------------------------------------------------------------------------------

	SET NOCOUNT ON;

	DECLARE @UPDATE_START_TIME   DATETIME = SYSDATETIME();
	DECLARE @UPDATE_END_TIME     DATETIME ;
	
	
	UPDATE  ZNERP_XLS_CHANGE_MASTER_CODE_DM  
	SET UPDATE_START_TIME = @UPDATE_START_TIME, 
	UPDATE_CNT = 0
	WHERE PROCESS_TYPE = 'SCM_MST_FUTURE_PRICE_C'
	;
	
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_SCM_MST_FUTURE_PRICE_C';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	--[C20200909-000203] LOG 표준화 적용
		-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = @p_period_type;
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		/*
	print 'PR_TMP_NERP_SCM_MST_FUTURE_PRICE_C'
			
	IF OBJECT_ID (N'DBO.BACKUP_SCM_MST_FUTURE_PRICE_C', N'U') IS NULL 	

		select * 
		into   DBO.BACKUP_SCM_MST_FUTURE_PRICE_C 			
		from   DBO.SCM_MST_FUTURE_PRICE_C 
		where  1=2;
			*/
	DECLARE @start_yyyymmdd varchar(100) ; --최근 데이터 컨버전 YYYYMMDD

	SET @start_yyyymmdd = (
		SELECT TOP 1 A.CONSTRAINT2 AS TERMS
		FROM ZNERP_XLS_CHANGE_MASTER_CODE_DM A WITH(NOLOCK)
		INNER JOIN ZNERP_TARGET_INFO_DM B WITH(NOLOCK)
		ON A.PROGRAM_NAME = B.TABLE_NAME 
		WHERE A.CONSTRAINT4 = 'AUTO'
		AND B.TABLE_NAME = 'SCM_MST_FUTURE_PRICE_C' )
		
	--DECLARE @start_yyyymmdd varchar(100) = CONVERT(CHAR(8), DATEADD(DD, -@latestPeriod, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);
		
	DECLARE @versionNo VARCHAR(100);
	DECLARE @divisionId VARCHAR(100); -- 2024.12.03 속도개선
	DECLARE @versionLowNumber VARCHAR(100); -- 2024.12.03 속도개선

	DECLARE @oldIncoterms VARCHAR(10);--, @dom_exp VARCHAR(10), @newIncoterms VARCHAR(10) ;
	DECLARE @newCode VARCHAR(50);
	DECLARE @count int, @checkCode varchar(50);
	
	DECLARE cursorVersion CURSOR FOR
	
		SELECT DISTINCT VERSION_NO, DIVISION_ID, ROW_NUMBER() OVER(partition by VERSION_NO order by DIVISION_ID) as VERSION_ROW_NUMBER -- 2024.12.03 속도개선, DIVISION_ID 추가
		FROM   DM_MST_VERSION WITH(NOLOCK)
		WHERE  VERSION_TYPE IN ( 'SP_W', 'SP_M', 'FP_W')
		AND    YYYYMMDD >= @start_yyyymmdd --FORMAT(DATEADD(DAY, -@latestPeriod, GETDATE()), 'yyyyMMdd')
		--AND    YYYYMMDD BETWEEN '20241216' AND '20241220'
		AND    @p_period_type = 'LATEST'
		UNION ALL		
		SELECT DISTINCT VERSION_NO, DIVISION_ID, ROW_NUMBER() OVER(partition by VERSION_NO order by DIVISION_ID) as VERSION_ROW_NUMBER -- 2024.12.03 속도개선, DIVISION_ID 추가
		FROM   DM_MST_VERSION WITH(NOLOCK)
		WHERE  VERSION_TYPE IN ( 'SP_W', 'SP_M', 'FP_W')
		AND    YYYYMMDD < @start_yyyymmdd --FORMAT(DATEADD(DAY, -@latestPeriod, GETDATE()), 'yyyyMMdd')
		--AND    YYYYMMDD BETWEEN '20241216' AND '20241220'
		AND    @p_period_type = 'OTHERS'
		ORDER BY VERSION_NO DESC
		
	OPEN cursorVersion;
	FETCH NEXT FROM cursorVersion INTO  @versionNo, @divisionId, @versionLowNumber ; -- 2024.12.03 속도개선, DIVISION_ID 추가
	

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		--------------------------------------------------------------------------------------------	
		BEGIN TRANSACTION;
		--------------------------------------------------------------------------------------------	
		
		DECLARE @UPDATE_CNT_INCOTERMS INT;
		DECLARE @UPDATE_CNT_PLANT INT;
		SET @UPDATE_CNT_INCOTERMS = 0;
		SET @UPDATE_CNT_PLANT = 0;
	/*
		-- Version 별 백업
		INSERT INTO DBO.BACKUP_SCM_MST_FUTURE_PRICE_C
		SELECT *
		FROM   SCM_MST_FUTURE_PRICE_C WITH(NOLOCK)
		WHERE  VERSION_NO = @versionNo;
		
		-- Conversion Table 기준으로 SITE Incoterms List 정리(2024.12.26) Start
		DELETE FROM DBO.ZNERP_TARGET_SITE;

		DELETE FROM DBO.ZNERP_TARGET_SITE_INCOTERMS;
		
		INSERT INTO DBO.ZNERP_TARGET_SITE
		SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID
		FROM  [dbo].SCM_MST_FUTURE_PRICE_C A with(nolock) --SCM_MST_FUTURE_PRICE_C
		WHERE  INCOTERMS IN ( SELECT DISTINCT OLD_INCOTERMS FROM DBO.ZNERP_TARGET_INCOTERMS)
		AND    VERSION_NO = @versionNo
		AND    DIVISION_ID = @divisionId;
		; 
		
		INSERT INTO DBO.ZNERP_TARGET_SITE_INCOTERMS
		SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID AS SALES_SITE_ID, ISNULL(B.DOM_EXP, 'E') AS DOM_EXP, C.OLD_INCOTERMS, C.NEW_INCOTERMS
		FROM  DBO.ZNERP_TARGET_SITE A with(nolock)
		LEFT JOIN  [dbo].[NERP_SALES_RESULT_IF_DOM_EXP] B with(nolock)
		ON  A.DIVISION_ID = B.DIVISION_ID
		AND A.SCM_SITE_ID = B.SALES_SITE_ID
		LEFT JOIN  DBO.ZNERP_TARGET_INCOTERMS C WITH(NOLOCK)
		ON   ISNULL(B.DOM_EXP, 'E') = C.DOM_EXP  
		;
		-- Conversion Table 기준으로 SITE Incoterms List 정리(2024.12.26) End


	
		DECLARE cursorUpdate CURSOR FOR
			--Z03, Z04 -> DAP 동시에 발생하면 Merge 중복데이터 발생하므로 Curor 사용
			--Z01, Z02 인 경우에만 DOM_EXP 구분 필요 함 
			SELECT DISTINCT OLD_INCOTERMS AS OLD_INCOTERMS--, CASE WHEN OLD_VALUE1 IN ('Z01', 'Z02')  THEN  OLD_VALUE2 ELSE 'E' END AS DOM_EXP, NEW_VALUE1 AS NEW_INCOTERMS -- Incoterms 만 대상 (2024.12.26)
			FROM   DBO.ZNERP_TARGET_INCOTERMS WITH(NOLOCK) --ZNERP_TARGET_INCOTERMS 변경 (2024.12.26)
			--WHERE  CODETYPE = 'INCOTERMS_ID'
			;
		
		OPEN cursorUpdate;
		FETCH NEXT FROM cursorUpdate INTO  @oldIncoterms; --, @dom_exp ,@newIncoterms ;-- Incoterms 만 대상 (2024.12.26)

		WHILE @@FETCH_STATUS = 0
		BEGIN
		

			--DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
			MERGE INTO SCM_MST_FUTURE_PRICE_C AS A
			USING (SELECT A.*, B.NEW_INCOTERMS AS NewCode --, @newIncoterms AS NewCode -- NEW_INCOTERMS 변경(2024.12.26)
					FROM SCM_MST_FUTURE_PRICE_C A with(nolock)
					--LEFT OUTER JOIN [dbo].[NERP_SALES_RESULT_IF_DOM_EXP] B with(nolock)
					INNER JOIN DBO.ZNERP_TARGET_SITE_INCOTERMS B with(nolock) -- Inner Join 변경(Conversion Table 기준으로 SITE Incoterms List만 대상)(2024.12.26)
					ON  A.DIVISION_ID = B.DIVISION_ID
					AND A.SCM_SITE_ID = B.SALES_SITE_ID
					AND A.INCOTERMS = B.OLD_INCOTERMS -- Incoterms Mapping 추가(2024.12.26)
					--AND B.DOM_EXP = (CASE WHEN @oldIncoterms IN ('Z01', 'Z02')  THEN  @dom_exp ELSE B.DOM_EXP END) --Z01, Z02 인 경우에만 DOM_EXP 구분 필요 함 
					WHERE A.DIVISION_ID = @divisionId -- 2024.12.03 속도개선, DIVISION_ID 추가
					AND  A.INCOTERMS = @oldIncoterms 
					AND  A.VERSION_NO = @versionNo) AS B
			ON   (  A.incoterms = B.NewCode
				AND A.division_id= B.division_id
				AND A.version_no = B.version_no
				AND A.CUTOFF_TYPE= B.CUTOFF_TYPE
				AND A.CUTOFF_YYYYMMDD= B.CUTOFF_YYYYMMDD
				AND A.project_code = B.project_code
				AND A.scm_site_id = B.scm_site_id
				AND A.plant_site_id= B.plant_site_id
				AND A.item_id= B.item_id
				AND A.yyyymmdd = B.yyyymmdd
				--AND A.CURRENCY = B.CURRENCY --DM_PLN_SALES_PLAN 중복
				AND A.measure = B.measure
				AND A.dom_exp = B.dom_exp
				AND A.fcst_type= B.fcst_type )
			WHEN NOT MATCHED THEN 
				INSERT   
				VALUES (B.division_id, B.version_No, B.cutoff_type, B.cutoff_yyyymmdd, B.project_code, B.scm_site_id, B.plant_site_id, B.item_id , 
										B.yyyymmdd,  B.currency, B.measure, B.dom_exp,	B.fcst_type, B.newCode, 
										B.PRICE, B.created_by, B.creation_date, B.last_updated_by, B.last_update_date,
										B.attribute1, B.attribute2, B.attribute3, B.attribute4, B.attribute5, B.attribute6,
										B.attribute7, B.attribute8, B.attribute9, B.attribute10)
					;

			SET @UPDATE_CNT_INCOTERMS = @UPDATE_CNT_INCOTERMS +  @@ROWCOUNT;
			
			
			DELETE FROM SCM_MST_FUTURE_PRICE_C 
			WHERE DIVISION_ID = @divisionId -- 2024.12.03 속도개선, DIVISION_ID 추가
			AND  INCOTERMS = @oldIncoterms 
			AND  VERSION_NO = @versionNo
			;


			FETCH NEXT FROM cursorUpdate INTO  @oldIncoterms; --, @dom_exp ,@newIncoterms ;-- Incoterms 만 대상 (2024.12.26)
		END

		CLOSE cursorUpdate;
		DEALLOCATE cursorUpdate;
		
		
		*/
		
		-- STEP
		SET @v_log_type = 'STEP';
		SET @v_log_message = '';
		SET @n_log_count = @UPDATE_CNT_INCOTERMS ;
		--SET @v_description = '@UPDATE_CNT_INCOTERMS : ' + CAST(@UPDATE_CNT_INCOTERMS AS NVARCHAR(1000));
		SET @v_description = @p_period_type + '/VERSION_NO : ' + @versionNo + '/DIVISION_ID : ' + @divisionId + '/@UPDATE_CNT_INCOTERMS : ' + CAST(@UPDATE_CNT_INCOTERMS AS NVARCHAR(1000)) ;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		IF (@versionLowNumber = '1' ) 
		BEGIN
			-- Version 별 Incoterms 외 Converion 수행
			EXEC PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM_BIG @p_table_name = N'SCM_MST_FUTURE_PRICE_C', @p_version_no = @versionNo
		END

		
		
		--------------------------------------------------------------------------------------------	
		COMMIT;
		--------------------------------------------------------------------------------------------	
		PRINT 'Transaction succeed!';

		FETCH NEXT FROM cursorVersion INTO  @versionNo, @divisionId, @versionLowNumber ; -- 2024.12.03 속도개선, DIVISION_ID 추가
	END

	CLOSE cursorVersion;
	DEALLOCATE cursorVersion;
				/*
	-- BACKUP_FLAG 변경
	UPDATE  ZNERP_TARGET_INFO_DM  
	SET BACKUP_FLAG = 'N'
	  , MODIFY_USER_ID = 'PR_TMP_NERP_SCM_MST_FUTURE_PRICE_C'
	  , MODIFY_DATE = getDate()
	WHERE TABLE_NAME = 'SCM_MST_FUTURE_PRICE_C'
	AND BIG_CONVERSION_FLAG = 'N'
	;*/
	
	SET @UPDATE_END_TIME = SYSDATETIME();
		
	UPDATE  ZNERP_XLS_CHANGE_MASTER_CODE_DM  
	SET UPDATE_END_TIME = @UPDATE_END_TIME
	WHERE PROCESS_TYPE = 'SCM_MST_FUTURE_PRICE_C'
	;
	
	
	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @n_log_count = 0;
	SET @v_description = @p_period_type;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	--------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	
	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		ROLLBACK;
		PRINT 'Transaction is cancels cause of error';
		
		-- ERROR LOG
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @n_log_count = 0;
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
		
		DECLARE @fileCursorStatus INT;

		SET @fileCursorStatus = CURSOR_STATUS('GLOBAL', 'cursorVersion');
 
		IF (@fileCursorStatus >= 0)
		BEGIN
			PRINT 'Closing fileCursor cursorVersion';
			CLOSE cursorVersion;
			DEALLOCATE cursorVersion;
		END
		
		SET @fileCursorStatus = CURSOR_STATUS('GLOBAL', 'cursorUpdate');
 
		IF (@fileCursorStatus >= 0)
		BEGIN
			PRINT 'Closing fileCursor cursorUpdate';
			CLOSE cursorUpdate;
			DEALLOCATE cursorUpdate;
		END


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

END






