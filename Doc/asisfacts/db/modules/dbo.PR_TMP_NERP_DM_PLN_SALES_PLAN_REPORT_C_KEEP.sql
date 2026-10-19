



-- =============================================
-- Author:		 P.C.I
-- Create date:  2024-05-02
-- Description:	 DM_PLN_SALES_PLAN_REPORT_C_KEEP Incoterms, Plant(A040,A041) Conversion
-- =============================================
CREATE PROCEDURE [dbo].[PR_TMP_NERP_DM_PLN_SALES_PLAN_REPORT_C_KEEP]

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
	WHERE PROCESS_TYPE = 'DM_PLN_SALES_PLAN_REPORT_C_KEEP'
	;
	
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_DM_PLN_SALES_PLAN_REPORT_C_KEEP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	--[C20200909-000203] LOG 표준화 적용
		-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		/*
	IF OBJECT_ID (N'DBO.BACKUP_DM_PLN_SALES_PLAN_REPORT_C_KEEP', N'U') IS NULL 	

		select * 
		into   DBO.BACKUP_DM_PLN_SALES_PLAN_REPORT_C_KEEP			
		from   DBO.DM_PLN_SALES_PLAN_REPORT_C_KEEP
		where  1=2;
		*/
	DECLARE @versionNo VARCHAR(100);
	DECLARE @oldIncoterms VARCHAR(10);--, @dom_exp VARCHAR(10), @newIncoterms VARCHAR(10) ;
	DECLARE @newCode VARCHAR(50);
	DECLARE @count int, @checkCode varchar(50);
	
	DECLARE cursorVersion CURSOR FOR
	
		SELECT DISTINCT VERSION_NO
		FROM   DM_PLN_SALES_PLAN_REPORT_C_KEEP WITH(NOLOCK)
		WHERE  CUTOFF_YYYYMMDD < '20240101'
		ORDER BY VERSION_NO DESC
		
	OPEN cursorVersion;
	FETCH NEXT FROM cursorVersion INTO  @versionNo ;
	

	WHILE @@FETCH_STATUS = 0
	BEGIN
		--------------------------------------------------------------------------------------------	
		BEGIN TRANSACTION;
		--------------------------------------------------------------------------------------------	

	/*
		-- Version 별 백업
		INSERT INTO DBO.BACKUP_DM_PLN_SALES_PLAN_REPORT_C_KEEP
		SELECT *
		FROM   DM_PLN_SALES_PLAN_REPORT_C_KEEP
		WHERE  VERSION_NO = @versionNo;
		*/
		
		-- Conversion Table 기준으로 SITE Incoterms List 정리(2024.12.26) Start
		DELETE FROM DBO.ZNERP_TARGET_SITE;

		DELETE FROM DBO.ZNERP_TARGET_SITE_INCOTERMS;
		
		INSERT INTO DBO.ZNERP_TARGET_SITE
		SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID
		FROM  [dbo].DM_PLN_SALES_PLAN_REPORT_C_KEEP A with(nolock) --DM_PLN_SALES_PLAN_REPORT_C_KEEP
		WHERE  INCOTERMS IN ( SELECT DISTINCT OLD_INCOTERMS FROM DBO.ZNERP_TARGET_INCOTERMS)
		AND    VERSION_NO = @versionNo;
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



		DECLARE @UPDATE_CNT INT;

		SET @UPDATE_CNT = 0;

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
		
			--VERSION_NO, DIVISION_ID, DEPARTMENT_ID, DEPT_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, COMPO_40, CELL_PROD_SITE
			--Incoterms Conversion
			MERGE INTO DM_PLN_SALES_PLAN_REPORT_C_KEEP AS A
			USING (SELECT A.*, B.NEW_INCOTERMS AS NewCode --, @newIncoterms AS NewCode -- NEW_INCOTERMS 변경(2024.12.26)
					FROM DM_PLN_SALES_PLAN_REPORT_C_KEEP A with(nolock)
					--LEFT OUTER JOIN [dbo].[NERP_SALES_RESULT_IF_DOM_EXP] B with(nolock)
					INNER JOIN DBO.ZNERP_TARGET_SITE_INCOTERMS B with(nolock) -- Inner Join 변경(Conversion Table 기준으로 SITE Incoterms List만 대상)(2024.12.26)
					ON  A.DIVISION_ID = B.DIVISION_ID
					AND A.SCM_SITE_ID = B.SALES_SITE_ID
					AND A.INCOTERMS = B.OLD_INCOTERMS -- Incoterms Mapping 추가(2024.12.26)
					--AND B.DOM_EXP = (CASE WHEN @oldIncoterms IN ('Z01', 'Z02')  THEN  @dom_exp ELSE B.DOM_EXP END) --Z01, Z02 인 경우에만 DOM_EXP 구분 필요 함 
					WHERE INCOTERMS = @oldIncoterms 
					AND  A.VERSION_NO = @versionNo) AS B
			ON   (  A.incoterms = B.NewCode
				AND A.version_no = B.version_no
				AND A.division_id= B.division_id
				AND A.DEPARTMENT_ID= B.DEPARTMENT_ID
				AND A.DEPT_ID= B.DEPT_ID
				AND A.PROJECT_CODE= B.PROJECT_CODE
				AND A.SCM_SITE_ID= B.SCM_SITE_ID
				AND A.ITEM_ID= B.ITEM_ID
				AND A.FCST_TYPE= B.FCST_TYPE
				AND A.MEASURE= B.MEASURE
				AND A.PLANT_SITE_ID= B.PLANT_SITE_ID
				AND A.YYYYMMDD= B.YYYYMMDD
				AND A.CURRENCY= B.CURRENCY
				AND A.COMPANY_ID= B.COMPANY_ID
				AND A.COMPO_40 = B.COMPO_40
				AND A.CELL_PROD_SITE = B.CELL_PROD_SITE )
			WHEN NOT MATCHED THEN 
				INSERT 
				(DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
				, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
				, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
				, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				, COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
				, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
				, COUNTRY_KR_NAME, ROUTE/*, COMPO_40*/, CELL_PROD_SITE)
				VALUES (B.data_type,  B.division_id ,  B.version_no , B.cutoff_type , B.cutoff_yyyymmdd , 
						B.department_id , B.department_name , B.dept_id , B.dept_name , B.end_cust_report , 
						B.cust_report , B.PRODUCT_GROUP , B.project_code , 
						B.scm_site_id ,B.item_id ,B.dom_exp ,B.fcst_type , B.NewCode ,  B.measure , B.plant_site_id , B.yyyymmdd , B.currency , B.qty ,
						B.CREATED_BY , B.creation_date, B.LAST_UPDATED_BY, B.last_update_date ,
						B.attribute1 , B.attribute2 , B.attribute3 , B.attribute4 , B.attribute5 ,B.attribute6 , 
						B.attribute7 , B.attribute8 , B.attribute9 , B.attribute10 ,B.company_id ,
						B.SOLDTO_CUST_REPORT ,B.OWNER_NAME ,B.CUST_GROUP_DTL ,B.PRODUCT_DETAILS ,B.FORECAST_INFO_SPEC ,B.NICK_NAME ,
						B.FORECAST_INFO_CELL_MODEL ,B.FORECAST_INFO_CELL_PACK_COUNT ,B.FORECAST_INFO_BIZ_TYPE ,B.COMPANY_NAME ,
						B.APPLICATION ,B.APPLICATION_GR ,B.COUNTRY_KR_NAME ,B.ROUTE /*,B.COMPO_40*/ ,B.CELL_PROD_SITE 
						)

			WHEN MATCHED THEN 
				UPDATE SET 
			--VERSION_NO, DIVISION_ID, DEPARTMENT_ID, DEPT_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, COMPO_40
					A.QTY = A.QTY + B.QTY, 
					A.FORECAST_INFO_CELL_PACK_COUNT = A.FORECAST_INFO_CELL_PACK_COUNT + B.FORECAST_INFO_CELL_PACK_COUNT, 					
					A.SOLDTO_CUST_REPORT = CASE WHEN A.SOLDTO_CUST_REPORT IS NULL AND B.SOLDTO_CUST_REPORT IS NULL THEN NULL
										        ELSE ISNULL(A.SOLDTO_CUST_REPORT, '') + IIF(ISNULL(A.SOLDTO_CUST_REPORT,'')='' OR ISNULL(B.SOLDTO_CUST_REPORT,'')='', '', ',') + ISNULL(B.SOLDTO_CUST_REPORT, '')
											END,
					A.OWNER_NAME = CASE WHEN A.OWNER_NAME IS NULL AND B.OWNER_NAME IS NULL THEN NULL
										        ELSE ISNULL(A.OWNER_NAME, '') + IIF(ISNULL(A.OWNER_NAME,'')='' OR ISNULL(B.OWNER_NAME,'')='', '', ',') + ISNULL(B.OWNER_NAME, '')
											END,
					A.CUST_GROUP_DTL = CASE WHEN A.CUST_GROUP_DTL IS NULL AND B.CUST_GROUP_DTL IS NULL THEN NULL
										        ELSE ISNULL(A.CUST_GROUP_DTL, '') + IIF(ISNULL(A.CUST_GROUP_DTL,'')='' OR ISNULL(B.CUST_GROUP_DTL,'')='', '', ',') + ISNULL(B.CUST_GROUP_DTL, '')
											END,
					A.PRODUCT_DETAILS = CASE WHEN A.PRODUCT_DETAILS IS NULL AND B.PRODUCT_DETAILS IS NULL THEN NULL
										        ELSE ISNULL(A.PRODUCT_DETAILS, '') + IIF(ISNULL(A.PRODUCT_DETAILS,'')='' OR ISNULL(B.PRODUCT_DETAILS,'')='', '', ',') + ISNULL(B.PRODUCT_DETAILS, '')
											END,
					A.FORECAST_INFO_SPEC = CASE WHEN A.FORECAST_INFO_SPEC IS NULL AND B.FORECAST_INFO_SPEC IS NULL THEN NULL
										        ELSE ISNULL(A.FORECAST_INFO_SPEC, '') + IIF(ISNULL(A.FORECAST_INFO_SPEC,'')='' OR ISNULL(B.FORECAST_INFO_SPEC,'')='', '', ',') + ISNULL(B.FORECAST_INFO_SPEC, '')
											END,
					A.NICK_NAME = CASE WHEN A.NICK_NAME IS NULL AND B.NICK_NAME IS NULL THEN NULL
										        ELSE ISNULL(A.NICK_NAME, '') + IIF(ISNULL(A.NICK_NAME,'')='' OR ISNULL(B.NICK_NAME,'')='', '', ',') + ISNULL(B.NICK_NAME, '')
											END,
					A.FORECAST_INFO_CELL_MODEL = CASE WHEN A.FORECAST_INFO_CELL_MODEL IS NULL AND B.FORECAST_INFO_CELL_MODEL IS NULL THEN NULL
										        ELSE ISNULL(A.FORECAST_INFO_CELL_MODEL, '') + IIF(ISNULL(A.FORECAST_INFO_CELL_MODEL,'')='' OR ISNULL(B.FORECAST_INFO_CELL_MODEL,'')='', '', ',') + ISNULL(B.FORECAST_INFO_CELL_MODEL, '')
											END,
					A.FORECAST_INFO_BIZ_TYPE = CASE WHEN A.FORECAST_INFO_BIZ_TYPE IS NULL AND B.FORECAST_INFO_BIZ_TYPE IS NULL THEN NULL
										        ELSE ISNULL(A.FORECAST_INFO_BIZ_TYPE, '') + IIF(ISNULL(A.FORECAST_INFO_BIZ_TYPE,'')='' OR ISNULL(B.FORECAST_INFO_BIZ_TYPE,'')='', '', ',') + ISNULL(B.FORECAST_INFO_BIZ_TYPE, '')
											END,
					A.COMPANY_NAME = CASE WHEN A.COMPANY_NAME IS NULL AND B.COMPANY_NAME IS NULL THEN NULL
										        ELSE ISNULL(A.COMPANY_NAME, '') + IIF(ISNULL(A.COMPANY_NAME,'')='' OR ISNULL(B.COMPANY_NAME,'')='', '', ',') + ISNULL(B.COMPANY_NAME, '')
											END,
					A.APPLICATION = CASE WHEN A.APPLICATION IS NULL AND B.APPLICATION IS NULL THEN NULL
										        ELSE ISNULL(A.APPLICATION, '') + IIF(ISNULL(A.APPLICATION,'')='' OR ISNULL(B.APPLICATION,'')='', '', ',') + ISNULL(B.APPLICATION, '')
											END,
					A.APPLICATION_GR = CASE WHEN A.APPLICATION_GR IS NULL AND B.APPLICATION_GR IS NULL THEN NULL
										        ELSE ISNULL(A.APPLICATION_GR, '') + IIF(ISNULL(A.APPLICATION_GR,'')='' OR ISNULL(B.APPLICATION_GR,'')='', '', ',') + ISNULL(B.APPLICATION_GR, '')
											END,
					A.COUNTRY_KR_NAME = CASE WHEN A.COUNTRY_KR_NAME IS NULL AND B.COUNTRY_KR_NAME IS NULL THEN NULL
										        ELSE ISNULL(A.COUNTRY_KR_NAME, '') + IIF(ISNULL(A.COUNTRY_KR_NAME,'')='' OR ISNULL(B.COUNTRY_KR_NAME,'')='', '', ',') + ISNULL(B.COUNTRY_KR_NAME, '')
											END,
					A.ROUTE = CASE WHEN A.ROUTE IS NULL AND B.ROUTE IS NULL THEN NULL
										        ELSE ISNULL(A.ROUTE, '') + IIF(ISNULL(A.ROUTE,'')='' OR ISNULL(B.ROUTE,'')='', '', ',') + ISNULL(B.ROUTE, '')
											END,
					A.attribute1 = CASE WHEN A.attribute1 IS NULL AND B.attribute1 IS NULL THEN NULL
										WHEN (ISNUMERIC(A.attribute1)=1 and ISNUMERIC(B.attribute1)=1)
											THEN CAST((CAST(A.attribute1 AS float) + CAST(B.attribute1 AS float)) AS NVARCHAR(150))
										WHEN A.attribute1 IS NULL AND B.attribute1 IS NULL
											THEN NULL
										ELSE ISNULL(A.attribute1, '') + IIF(ISNULL(A.attribute1,'')='' OR ISNULL(B.attribute1,'')='', '', ',') + ISNULL(B.attribute1, '')
								END,
					A.attribute2 = CASE WHEN A.attribute2 IS NULL AND B.attribute2 IS NULL THEN NULL
										WHEN (ISNUMERIC(A.attribute2)=1 and ISNUMERIC(B.attribute2)=1)
											THEN CAST((CAST(A.attribute2 AS float) + CAST(B.attribute2 AS float)) AS NVARCHAR(150))
										WHEN A.attribute2 IS NULL AND B.attribute2 IS NULL
											THEN NULL
										ELSE ISNULL(A.attribute2, '') + IIF(ISNULL(A.attribute2,'')='' OR ISNULL(B.attribute2,'')='', '', ',') + ISNULL(B.attribute2, '')
								END,
					A.attribute3 = CASE WHEN A.attribute3 IS NULL AND B.attribute3 IS NULL THEN NULL
										WHEN (ISNUMERIC(A.attribute3)=1 and ISNUMERIC(B.attribute3)=1)
											THEN CAST((CAST(A.attribute3 AS float) + CAST(B.attribute3 AS float)) AS NVARCHAR(150))
										WHEN A.attribute3 IS NULL AND B.attribute3 IS NULL
											THEN NULL
										ELSE ISNULL(A.attribute3, '') + IIF(ISNULL(A.attribute3,'')='' OR ISNULL(B.attribute3,'')='', '', ',') + ISNULL(B.attribute3, '')
								END,
					A.attribute4 = CASE WHEN A.attribute4 IS NULL AND B.attribute4 IS NULL THEN NULL
										WHEN (ISNUMERIC(A.attribute4)=1 and ISNUMERIC(B.attribute4)=1)
											THEN CAST((CAST(A.attribute4 AS float) + CAST(B.attribute4 AS float)) AS NVARCHAR(150))
										WHEN A.attribute4 IS NULL AND B.attribute4 IS NULL
											THEN NULL
										ELSE ISNULL(A.attribute4, '') + IIF(ISNULL(A.attribute4,'')='' OR ISNULL(B.attribute4,'')='', '', ',') + ISNULL(B.attribute4, '')
								END,
					A.attribute5 = CASE WHEN A.attribute5 IS NULL AND B.attribute5 IS NULL THEN NULL
										WHEN (ISNUMERIC(A.attribute5)=1 and ISNUMERIC(B.attribute5)=1)
											THEN CAST((CAST(A.attribute5 AS float) + CAST(B.attribute5 AS float)) AS NVARCHAR(150))
										WHEN A.attribute5 IS NULL AND B.attribute5 IS NULL
											THEN NULL
										ELSE ISNULL(A.attribute5, '') + IIF(ISNULL(A.attribute5,'')='' OR ISNULL(B.attribute5,'')='', '', ',') + ISNULL(B.attribute5, '')
								END,
					A.attribute6 = CASE WHEN A.attribute6 IS NULL AND B.attribute6 IS NULL THEN NULL
										WHEN (ISNUMERIC(A.attribute6)=1 and ISNUMERIC(B.attribute6)=1)
											THEN CAST((CAST(A.attribute6 AS float) + CAST(B.attribute6 AS float)) AS NVARCHAR(150))
										WHEN A.attribute6 IS NULL AND B.attribute6 IS NULL
											THEN NULL
										ELSE ISNULL(A.attribute6, '') + IIF(ISNULL(A.attribute6,'')='' OR ISNULL(B.attribute6,'')='', '', ',') + ISNULL(B.attribute6, '')
								END,
					A.attribute7 = CASE WHEN A.attribute7 IS NULL AND B.attribute7 IS NULL THEN NULL
										WHEN (ISNUMERIC(A.attribute7)=1 and ISNUMERIC(B.attribute7)=1)
											THEN CAST((CAST(A.attribute7 AS float) + CAST(B.attribute7 AS float)) AS NVARCHAR(150))
										WHEN A.attribute7 IS NULL AND B.attribute7 IS NULL
											THEN NULL
										ELSE ISNULL(A.attribute7, '') + IIF(ISNULL(A.attribute7,'')='' OR ISNULL(B.attribute7,'')='', '', ',') + ISNULL(B.attribute7, '')
								END,
					A.attribute8 = CASE WHEN A.attribute8 IS NULL AND B.attribute8 IS NULL THEN NULL
										WHEN (ISNUMERIC(A.attribute8)=1 and ISNUMERIC(B.attribute8)=1)
											THEN CAST((CAST(A.attribute8 AS float) + CAST(B.attribute8 AS float)) AS NVARCHAR(150))
										WHEN A.attribute8 IS NULL AND B.attribute8 IS NULL
											THEN NULL
										ELSE ISNULL(A.attribute8, '') + IIF(ISNULL(A.attribute8,'')='' OR ISNULL(B.attribute8,'')='', '', ',') + ISNULL(B.attribute8, '')
								END,
					A.attribute9 = CASE WHEN A.attribute9 IS NULL AND B.attribute9 IS NULL THEN NULL
										WHEN (ISNUMERIC(A.attribute9)=1 and ISNUMERIC(B.attribute9)=1)
											THEN CAST((CAST(A.attribute9 AS float) + CAST(B.attribute9 AS float)) AS NVARCHAR(150))
										WHEN A.attribute9 IS NULL AND B.attribute9 IS NULL
											THEN NULL
										ELSE ISNULL(A.attribute9, '') + IIF(ISNULL(A.attribute9,'')='' OR ISNULL(B.attribute9,'')='', '', ',') + ISNULL(B.attribute9, '')
								END,
					A.attribute10 = CASE WHEN A.attribute10 IS NULL AND B.attribute10 IS NULL THEN NULL
										WHEN (ISNUMERIC(A.attribute10)=1 and ISNUMERIC(B.attribute10)=1)
											THEN CAST((CAST(A.attribute10 AS float) + CAST(B.attribute10 AS float)) AS NVARCHAR(150))
										WHEN A.attribute10 IS NULL AND B.attribute10 IS NULL
											THEN NULL
										ELSE ISNULL(A.attribute10, '') + IIF(ISNULL(A.attribute10,'')='' OR ISNULL(B.attribute10,'')='', '', ',') + ISNULL(B.attribute10, '')
								END
					;

			SET @UPDATE_CNT = @UPDATE_CNT +  @@ROWCOUNT;

			DELETE FROM DM_PLN_SALES_PLAN_REPORT_C_KEEP 
			WHERE INCOTERMS = @oldIncoterms 
			AND   VERSION_NO = @versionNo
			;


			FETCH NEXT FROM cursorUpdate INTO  @oldIncoterms; --, @dom_exp ,@newIncoterms ;-- Incoterms 만 대상 (2024.12.26)
		END

		CLOSE cursorUpdate;
		DEALLOCATE cursorUpdate;

		-- STEP
		SET @v_log_type = 'STEP';
		SET @v_log_message = '';
		SET @n_log_count = @UPDATE_CNT ;
		SET @v_description = 'VERSION_NO : ' + @versionNo + '/@UPDATE_CNT : ' + CAST(@UPDATE_CNT AS NVARCHAR(1000)) ;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		
		-- Version 별 Incoterms 외 Converion 수행
		EXEC PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM_BIG @p_table_name = N'DM_PLN_SALES_PLAN_REPORT_C_KEEP', @p_version_no = @versionNo
		
		--------------------------------------------------------------------------------------------	
		COMMIT;
		--------------------------------------------------------------------------------------------	
		PRINT 'Transaction succeed!';

		FETCH NEXT FROM cursorVersion INTO  @versionNo ;
	END

	CLOSE cursorVersion;
	DEALLOCATE cursorVersion;
		/*
	-- BACKUP_FLAG 변경
	UPDATE  ZNERP_TARGET_INFO_DM  
	SET BACKUP_FLAG = 'N'
	  , MODIFY_USER_ID = 'PR_TMP_NERP_DM_PLN_SALES_PLAN_REPORT_C_KEEP'
	  , MODIFY_DATE = getDate()
	WHERE TABLE_NAME = 'DM_PLN_SALES_PLAN_REPORT_C_KEEP'
	AND BIG_CONVERSION_FLAG = 'N'
	;*/
	
	SET @UPDATE_END_TIME = SYSDATETIME();
		
	UPDATE  ZNERP_XLS_CHANGE_MASTER_CODE_DM  
	SET UPDATE_END_TIME = @UPDATE_END_TIME
	WHERE PROCESS_TYPE = 'DM_PLN_SALES_PLAN_REPORT_C_KEEP'
	;
	



	
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






