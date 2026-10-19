
/*
 * Program ID   : [DMF0070_SAVE_QTY_PR_DETAIL_AUTO]
 * Description  : MKT FCST 저장시 PR_DETAIL_AUTO 수량도 업데이트  
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.02.05   KJJ        신규생성
 */
CREATE PROCEDURE [dbo].[DMF0070_SAVE_QTY_PR_DETAIL_AUTO]
	@p_division_id			NVARCHAR(MAX),
	@p_project_code			NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_item_id				NVARCHAR(MAX),
	@p_dom_exp				NVARCHAR(MAX),
	@p_fcst_type			NVARCHAR(MAX),
	@p_incoterms			NVARCHAR(MAX),
	@p_plant_site_id  	    NVARCHAR(MAX),
	@p_yyyymmdd				NVARCHAR(MAX),
	@p_qty					NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	-- LOG 용 변수 설정
	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0070_SAVE_QTY_PR_DETAIL_AUTO';
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
		B1.TOKEN AS DIVISION_ID
		, B2.TOKEN AS PROJECT_CODE
		, B3.TOKEN AS SCM_SITE_ID
		, B4.TOKEN AS ITEM_ID
		, B5.TOKEN AS DOM_EXP
		, B6.TOKEN AS FCST_TYPE
		, B7.TOKEN AS INCOTERMS
		, B8.TOKEN AS PLANT_SITE_ID
		, REPLACE(B9.TOKEN, '-', '') AS MKT_FCST_DATE
		, B10.TOKEN AS QTY		 
	INTO #T_MAIN
	FROM 
		DBO.UF_FX_STRING_SPLIT(@P_DIVISION_ID		, '^') B1
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_PROJECT_CODE		, '^') B2  ON B1.NR = B2.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_SCM_SITE_ID		, '^') B3  ON B1.NR = B3.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_ITEM_ID			, '^') B4  ON B1.NR = B4.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_DOM_EXP			, '^') B5  ON B1.NR = B5.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_FCST_TYPE			, '^') B6  ON B1.NR = B6.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_INCOTERMS			, '^') B7  ON B1.NR = B7.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_PLANT_SITE_ID		, '^') B8  ON B1.NR = B8.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_yyyymmdd			, '^') B9  ON B1.NR = B9.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_qty				, '^') B10 ON B1.NR = B10.NR


	UPDATE ATO
	SET
	PLAN_QTY = CONVERT(NUMERIC, T_LIST.QTY)
	,LAST_UPDATED_BY = 'AUTO_UPDATE'
	,LAST_UPDATE_DATE = GETDATE()
	FROM DM_PLN_AUTO_PR_CHECK ATO
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
		AND ISNULL(ATO.BNP_IN_DATE, '') = ''--BNP IN 데이터 생성 안된것만

	DECLARE @ROWCNT INT
	SET @ROWCNT = @@ROWCOUNT

	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 결과코드, 결과 카운트 반환
	--SELECT  'S' AS result_code,  @ROWCNT AS result_cnt ;


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




