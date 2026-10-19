



-- =============================================
-- Author:		 P.C.I
-- Create date:  2024-07-31
-- Description:	 SCM_MST_FUTURE_PRICE Incoterms
-- 실적기준으로 Incoterms Conversion 진행
-- =============================================
CREATE PROCEDURE [dbo].[PR_TMP_NERP_SCM_MST_FUTURE_PRICE]

AS

BEGIN 

	--------------------------------------------------------------------------------------------	
	BEGIN TRANSACTION;
	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------


	SET NOCOUNT ON;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_SCM_MST_FUTURE_PRICE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				
	--@@ROWCOUNT
	DECLARE @UPDATE_CNT_INCOTERMS INT;
	DECLARE @UPDATE_CNT_PLANT INT;
	SET @UPDATE_CNT_INCOTERMS = 0;
	SET @UPDATE_CNT_PLANT = 0;
	/*
	print 'PR_TMP_NERP_SCM_MST_FUTURE_PRICE'
	
	IF OBJECT_ID (N'DBO.BACKUP_SCM_MST_FUTURE_PRICE', N'U') IS NOT NULL 	
		DROP TABLE DBO.BACKUP_SCM_MST_FUTURE_PRICE

	SELECT *
	INTO   DBO.BACKUP_SCM_MST_FUTURE_PRICE
	FROM   SCM_MST_FUTURE_PRICE;
	
	-- Conversion Table 기준으로 SITE Incoterms List 정리(2024.12.26) Start
	DELETE FROM DBO.ZNERP_TARGET_SITE;

	DELETE FROM DBO.ZNERP_TARGET_SITE_INCOTERMS;
		
	INSERT INTO DBO.ZNERP_TARGET_SITE
	SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID
	FROM  [dbo].SCM_MST_FUTURE_PRICE A with(nolock) --SCM_MST_FUTURE_PRICE
	WHERE  INCOTERMS IN ( SELECT DISTINCT OLD_INCOTERMS FROM DBO.ZNERP_TARGET_INCOTERMS)
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

	DECLARE @oldIncoterms VARCHAR(10), @dom_exp VARCHAR(10), @newIncoterms VARCHAR(10) ;

	DECLARE @newCode VARCHAR(50);
	DECLARE @count int, @checkCode varchar(50);
	

	DECLARE cursorUpdate CURSOR FOR
	
		--Z03, Z04 -> DAP 동시에 발생하면 Merge 중복데이터 발생하므로 Cursor 사용
		--Z01, Z02 인 경우에만 DOM_EXP 구분 필요 함 
		SELECT DISTINCT OLD_INCOTERMS AS OLD_INCOTERMS--, CASE WHEN OLD_VALUE1 IN ('Z01', 'Z02')  THEN  OLD_VALUE2 ELSE 'E' END AS DOM_EXP, NEW_VALUE1 AS NEW_INCOTERMS -- Incoterms 만 대상 (2024.12.26)
		FROM   DBO.ZNERP_TARGET_INCOTERMS WITH(NOLOCK) --ZNERP_TARGET_INCOTERMS 변경 (2024.12.26)
		--WHERE  CODETYPE = 'INCOTERMS_ID'
		;


	OPEN cursorUpdate;
	FETCH NEXT FROM cursorUpdate INTO  @oldIncoterms; --, @dom_exp ,@newIncoterms ;-- Incoterms 만 대상 (2024.12.26)

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		--DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
		--Incoterms Conversion
		MERGE INTO SCM_MST_FUTURE_PRICE AS A
		USING (SELECT A.*, B.NEW_INCOTERMS AS NewCode --, @newIncoterms AS NewCode -- NEW_INCOTERMS 변경(2024.12.26)
				FROM SCM_MST_FUTURE_PRICE A with(nolock)
				--LEFT OUTER JOIN [dbo].[NERP_SALES_RESULT_IF_DOM_EXP] B with(nolock)
				INNER JOIN DBO.ZNERP_TARGET_SITE_INCOTERMS B with(nolock) -- Inner Join 변경(Conversion Table 기준으로 SITE Incoterms List만 대상)(2024.12.26)
				ON  A.DIVISION_ID = B.DIVISION_ID
				AND A.SCM_SITE_ID = B.SALES_SITE_ID
				AND A.INCOTERMS = B.OLD_INCOTERMS -- Incoterms Mapping 추가(2024.12.26)
				--AND B.DOM_EXP = (CASE WHEN @oldIncoterms IN ('Z01', 'Z02')  THEN  @dom_exp ELSE B.DOM_EXP END) --Z01, Z02 인 경우에만 DOM_EXP 구분 필요 함 
				WHERE INCOTERMS = @oldIncoterms 
				) AS B
		ON   (  A.incoterms = B.NewCode
			AND A.division_id= B.division_id
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
			VALUES (B.division_id ,B.project_code ,B.scm_site_id, B.plant_site_id, B.item_id , B.yyyymmdd , B.currency , B.measure  ,
							B.dom_exp ,B.fcst_type , B.newCode , B.PRICE , 
							B.CREATED_BY ,B.creation_date , B.LAST_UPDATED_BY, B.last_update_date ,
							B.attribute1 , B.attribute2 , B.attribute3 ,B.attribute4 , B.attribute5 , B.attribute6 ,
							B.attribute7 , B.attribute8 , B.attribute9 , B.attribute10 )
				;
				
		SET @UPDATE_CNT_INCOTERMS = @UPDATE_CNT_INCOTERMS +  @@ROWCOUNT;


		DELETE FROM SCM_MST_FUTURE_PRICE 
		WHERE INCOTERMS = @oldIncoterms 
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
	SET @v_description = '@UPDATE_CNT_INCOTERMS : ' + CAST(@UPDATE_CNT_INCOTERMS AS NVARCHAR(1000));
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	
	-- Incoterms 외 Converion 수행
	EXEC PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM @p_table_name = N'SCM_MST_FUTURE_PRICE'
	
	-- BACKUP_FLAG 변경
	UPDATE  ZNERP_TARGET_INFO_DM  
	SET CONVERSION_FLAG = 'Y'
	  , BACKUP_FLAG = 'N'
	  , MODIFY_USER_ID = 'PR_TMP_NERP_SCM_MST_FUTURE_PRICE'
	  , MODIFY_DATE = getDate()
	WHERE TABLE_NAME = 'SCM_MST_FUTURE_PRICE'
	AND CONVERSION_FLAG = 'N'
	;
	
	COMMIT;
	PRINT 'Transaction succeed!';
	
	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @n_log_count = 0;
	SET @v_description = '';
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






