/*
 * Program ID   : [DMF0070_SAVE_REQUEST_AUTO_LIST]
 * Description  : PR_DETAIL_AUTO 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024. 01. 31   KJJ			최초 작성
 */
CREATE PROCEDURE [dbo].[DMF0070_SAVE_REQUEST_AUTO_LIST]
	@P_MAIL_INFO_DATE		NVARCHAR(MAX),		
	@P_DIVISION_ID			NVARCHAR(MAX),
	@P_PROJECT_CODE			NVARCHAR(MAX),
	@P_SCM_SITE_ID			NVARCHAR(MAX),
	@P_ITEM_ID				NVARCHAR(MAX),
	@P_DOM_EXP				NVARCHAR(MAX),		
	@P_FCST_TYPE 			NVARCHAR(MAX),
	@P_INCOTERMS			NVARCHAR(MAX),
	@P_PLANT_SITE_ID		NVARCHAR(MAX),
	@P_MKT_FCST_DATE		NVARCHAR(MAX),
	@P_AUTO_FLAG			NVARCHAR(MAX),
	@P_USER_ID     			NVARCHAR(100),
	@P_STORAGE_ID			NVARCHAR(MAX),
	@P_PR_ITEM_DETAIL		NVARCHAR(MAX),
	@P_STORAGE_PLANT_ID		NVARCHAR(MAX)
	--@P_ORIGIN_PLANT_SITE_ID	NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	-- LOG 용 변수 설정
	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0070_SAVE_REQUEST_AUTO_LIST';
    DECLARE @v_log_type     NVARCHAR(30);
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	BEGIN TRY

	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	SELECT 
		REPLACE(B1.TOKEN, '-', '') AS MAIL_INFO_DATE
		, B2.TOKEN AS DIVISION_ID
		, B3.TOKEN AS PROJECT_CODE
		, B4.TOKEN AS SCM_SITE_ID
		, B5.TOKEN AS ITEM_ID
		, B6.TOKEN AS DOM_EXP
		, B7.TOKEN AS FCST_TYPE
		, B8.TOKEN AS INCOTERMS
		, B9.TOKEN AS PLANT_SITE_ID
		, REPLACE(B10.TOKEN, '-', '') AS MKT_FCST_DATE
		, B11.TOKEN AS AUTO_FLAG	
		, B12.TOKEN AS STORAGE_ID
		, B13.TOKEN AS PR_ITEM_DETAIL
		--, B14.TOKEN AS ORIGIN_PLANT_SITE_ID
		, B14.TOKEN AS STORAGE_PLANT_ID
	INTO #T_MAIN
	FROM DBO.UF_FX_STRING_SPLIT(@P_MAIL_INFO_DATE, '^') B1
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_DIVISION_ID			, '^') B2  ON B1.NR = B2.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_PROJECT_CODE			, '^') B3  ON B1.NR = B3.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_SCM_SITE_ID			, '^') B4  ON B1.NR = B4.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_ITEM_ID				, '^') B5  ON B1.NR = B5.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_DOM_EXP				, '^') B6  ON B1.NR = B6.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_FCST_TYPE				, '^') B7  ON B1.NR = B7.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_INCOTERMS				, '^') B8  ON B1.NR = B8.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_PLANT_SITE_ID			, '^') B9  ON B1.NR = B9.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_MKT_FCST_DATE			, '^') B10 ON B1.NR = B10.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_AUTO_FLAG				, '^') B11 ON B1.NR = B11.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_STORAGE_ID			, '^') B12 ON B1.NR = B12.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_PR_ITEM_DETAIL		, '^') B13 ON B1.NR = B13.NR
		--LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_ORIGIN_PLANT_SITE_ID	, '^') B14 ON B1.NR = B14.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_STORAGE_PLANT_ID	, '^') B14 ON B1.NR = B14.NR


	UPDATE ATO
	SET
	AUTO_FLAG = T_LIST.AUTO_FLAG
	,STORAGE_PLANT_ID = T_LIST.STORAGE_PLANT_ID
	,STORAGE_ID = T_LIST.STORAGE_ID
	,PR_ITEM_DETAIL = T_LIST.PR_ITEM_DETAIL
	,LAST_UPDATED_BY = @P_USER_ID
	,LAST_UPDATE_DATE = GETDATE()
	FROM DM_PLN_AUTO_PR_CHECK  ATO
	INNER JOIN #T_MAIN T_LIST
		ON ATO.DIVISION_ID = T_LIST.DIVISION_ID
		AND ATO.PROJECT_CODE = T_LIST.PROJECT_CODE
		AND ATO.SCM_SITE_ID = T_LIST.SCM_SITE_ID
		AND ATO.ITEM_ID = T_LIST.ITEM_ID
		AND ATO.DOM_EXP = T_LIST.DOM_EXP
		AND ATO.FCST_TYPE = T_LIST.FCST_TYPE
		AND ATO.INCOTERMS = T_LIST.INCOTERMS
		AND ATO.PLANT_SITE_ID = T_LIST.PLANT_SITE_ID
		AND ATO.MKT_FCST_DATE = T_LIST.MKT_FCST_DATE	
		AND ATO.MAIL_INFO_DATE = T_LIST.MAIL_INFO_DATE

	DECLARE @ROWCNT INT
	SET @ROWCNT = @@ROWCOUNT

	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 결과코드, 결과 카운트 반환
	SELECT  'S' AS result_code,  @ROWCNT AS result_cnt ;


	END TRY

	BEGIN CATCH 
		BEGIN

			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;
END




