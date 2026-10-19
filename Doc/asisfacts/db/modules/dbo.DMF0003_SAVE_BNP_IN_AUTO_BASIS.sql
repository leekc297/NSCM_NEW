
/*************************************************************************************************
* Program ID  : DMF0003_SAVE_PR_Request_AUTO                                               
* Description : Procedure 작성 가이드                                                             
* Usage       : PR Request 자동 생성할 때 사용
* Parameter   :                                                                                  
* 
*------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                           
*------------------------------------------------------------------------------------------------
* 2024-01-25   kjj		 신규생성

***************************************************************************************************/

CREATE PROCEDURE [dbo].[DMF0003_SAVE_BNP_IN_AUTO_BASIS]

AS  
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	SET ANSI_WARNINGS ON;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0003_SAVE_BNP_IN_AUTO';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_log_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_insert_count INTEGER = 0;
    DECLARE @n_input_count     INTEGER = 0;
    DECLARE @n_logo_count      INTEGER = 0;
	DECLARE @n_Invalid_item		nvarchar(50)
	DECLARE @n_msg			nvarchar(1000)
	DECLARE @V_BF_REQ_NO	NVARCHAR(30)
	DECLARE @V_BF_QTY		INT = 0;
	DECLARE @V_THIS_QTY		INT = 0;

	
	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure @@@##########';
	SET @v_log_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_Batch'
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 


	--BEGIN TRANSACTION
	BEGIN TRANSACTION 
	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------


	--메일발송 주기(케이스 별)
	/*
	*1차
(A) Incoterms= EXW => D-91(13주)
(B) Incoterms = C* or F*, Country=KR => D-119(17주)
(C) Incoterms = D*, Country=JP => D-119(17주)
(D) Incoterms = D*, Country = not KR => D-175(25주)


	*2차
(A) Incoterms= EXW => D-20 (3주 전)
(B) Incoterms = C* or F*, Country=KR => D-48 (7주 전)
(C) Incoterms = D*, Country=JP => D-48 (7주 전)
(D) Incoterms = D*, Country = not KR => D-104 (15주 전)
	*/


	--대상 추출

	--case A 1차 
	;WITH DTTMP AS
	(
		SELECT BASIS_START_DATE, BASIS_END_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
		WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(WEEK, 13, GETDATE()), 112) --13주 뒤
	)
	SELECT 
	MF.DIVISION_ID
	,MF.PROJECT_CODE
	, MF.SCM_SITE_ID
	, MF.ITEM_ID
	, MF.DOM_EXP
	, MF.FCST_TYPE
	, MF.INCOTERMS
	, 'BNPIn' MEASURE
	, MF.PLANT_SITE_ID
	, MF.YYYYMMDD
	, MF.QTY
	INTO #TMP_TARGET_LIST
	FROM DM_PLN_MKT_FCST MF WITH(NOLOCK)
	INNER JOIN DM_PLN_MKT_FCST_MAIL_SEND MSND WITH(NOLOCK)
		ON MSND.DIVISION_ID = MF.DIVISION_ID
		AND MSND.PROJECT_CODE = MF.PROJECT_CODE
		AND MSND.SCM_SITE_ID = MF.SCM_SITE_ID
		AND MSND.ITEM_ID = MF.ITEM_ID
		AND MSND.DOM_EXP = MF.DOM_EXP
		AND MSND.INCOTERMS = MF.INCOTERMS
		AND MSND.MEASURE = MF.MEASURE
		AND MSND.PLANT_SITE_ID = MF.PLANT_SITE_ID
		AND MSND.YYYYMMDD = MF.YYYYMMDD
		AND MSND.AUTOMATION_YN = 'Y'
		AND ISNULL(MSND.ATTRIBUTE1, '') = ''--데이터 생성 안된것만
	WHERE MF.DIVISION_ID = '82'
	AND MF.MEASURE = 'MKT_FCST'
	AND MF.YYYYMMDD >= (SELECT BASIS_START_DATE FROM DTTMP) --13주차 시작(91일)
	AND MF.YYYYMMDD <= (SELECT BASIS_END_DATE FROM DTTMP) --13주차 종료(98일)

	--커서 값 담을 변수
	DECLARE  @CUR_DIVISION_ID		NVARCHAR(150)
		, @CUR_PROJECT_CODE		NVARCHAR(150)
		, @CUR_SCM_SITE_ID		NVARCHAR(150)
		, @CUR_ITEM_ID			NVARCHAR(150)
		, @CUR_DOM_EXP			NVARCHAR(150)
		, @CUR_FCST_TYPE			NVARCHAR(150)
		, @CUR_INCOTERMS			NVARCHAR(150)
		, @CUR_MEASURE			NVARCHAR(150)
		, @CUR_PLANT_SITE_ID		NVARCHAR(150)
		, @CUR_YYYYMMDD			NVARCHAR(150)
		, @CUR_PLAN_QTY			NVARCHAR(150)

	--커서 값 누적 시켜 SP 호출시 넘길 변수
	DECLARE  @V_DIVISION_ID		NVARCHAR(max) = ''
		, @V_PROJECT_CODE		NVARCHAR(max) = ''
		, @V_SCM_SITE_ID		NVARCHAR(max) = ''
		, @V_ITEM_ID			NVARCHAR(max) = ''
		, @V_DOM_EXP			NVARCHAR(max) = ''
		, @V_FCST_TYPE			NVARCHAR(max) = ''
		, @V_INCOTERMS			NVARCHAR(max) = ''
		, @V_MEASURE			NVARCHAR(max) = ''
		, @V_PLANT_SITE_ID		NVARCHAR(max) = ''
		, @V_YYYYMMDD			NVARCHAR(max) = ''
		, @V_PLAN_QTY			NVARCHAR(max) = ''
		, @V_ACTIVE_FLAG		NVARCHAR(max) = ''

		DECLARE CUR_TARGET_LIST CURSOR FAST_FORWARD FOR
		SELECT 
				DIVISION_ID
				,PROJECT_CODE
				,SCM_SITE_ID
				,ITEM_ID
				,DOM_EXP
				,FCST_TYPE
				,INCOTERMS
				,MEASURE
				, PLANT_SITE_ID	
				,YYYYMMDD
				,QTY
		FROM #TMP_TARGET_LIST

		OPEN CUR_TARGET_LIST;
		FETCH NEXT FROM CUR_TARGET_LIST INTO 
					@CUR_DIVISION_ID	
					, @CUR_PROJECT_CODE		
					, @CUR_SCM_SITE_ID	
					, @CUR_ITEM_ID			
					, @CUR_DOM_EXP			
					, @CUR_FCST_TYPE			
					, @CUR_INCOTERMS
					, @CUR_MEASURE
					, @CUR_PLANT_SITE_ID
					, @CUR_YYYYMMDD	
					, @CUR_PLAN_QTY	

		WHILE @@FETCH_STATUS = 0
		BEGIN

			SET @V_DIVISION_ID = @V_DIVISION_ID + CASE WHEN @V_DIVISION_ID = '' THEN '' ELSE '^' END + @CUR_DIVISION_ID
			SET @V_PROJECT_CODE = @V_PROJECT_CODE + (CASE WHEN @V_PROJECT_CODE = '' THEN '' ELSE '^' END) + @CUR_PROJECT_CODE
			SET @V_PLAN_QTY = @V_PLAN_QTY + CASE WHEN @V_PLAN_QTY = '' THEN '' ELSE '^' END + @CUR_PLAN_QTY
			SET @V_YYYYMMDD = @V_YYYYMMDD + CASE WHEN @V_YYYYMMDD = '' THEN '' ELSE '^' END + @CUR_YYYYMMDD
			SET @V_SCM_SITE_ID = @V_SCM_SITE_ID + CASE WHEN @V_SCM_SITE_ID = '' THEN '' ELSE '^' END + @CUR_SCM_SITE_ID
			SET @V_ITEM_ID = @V_ITEM_ID + CASE WHEN @V_ITEM_ID = '' THEN '' ELSE '^' END + @CUR_ITEM_ID
			SET @V_DOM_EXP = @V_DOM_EXP + CASE WHEN @V_DOM_EXP = '' THEN '' ELSE '^' END + @CUR_DOM_EXP
			SET @V_FCST_TYPE = @V_FCST_TYPE + CASE WHEN @V_FCST_TYPE = '' THEN '' ELSE '^' END + @CUR_FCST_TYPE
			SET @V_INCOTERMS = @V_INCOTERMS + CASE WHEN @V_INCOTERMS = '' THEN '' ELSE '^' END + @CUR_INCOTERMS
			SET @V_PLANT_SITE_ID = @V_PLANT_SITE_ID + CASE WHEN @V_PLANT_SITE_ID = '' THEN '' ELSE '^' END + @CUR_PLANT_SITE_ID
			SET @V_MEASURE = @V_MEASURE + CASE WHEN @V_MEASURE = '' THEN '' ELSE '^' END + @CUR_MEASURE

			SET @V_ACTIVE_FLAG = @V_ACTIVE_FLAG + CASE WHEN @V_ACTIVE_FLAG = '' THEN '' ELSE '^' END + 'M'

			FETCH NEXT FROM CUR_TARGET_LIST INTO 
					@CUR_DIVISION_ID	
					, @CUR_PROJECT_CODE		
					, @CUR_SCM_SITE_ID	
					, @CUR_ITEM_ID			
					, @CUR_DOM_EXP			
					, @CUR_FCST_TYPE			
					, @CUR_INCOTERMS
					, @CUR_MEASURE
					, @CUR_PLANT_SITE_ID
					, @CUR_YYYYMMDD	
					, @CUR_PLAN_QTY	

		END
		CLOSE CUR_TARGET_LIST;
		DEALLOCATE CUR_TARGET_LIST;


		----------------------------------------------------------------------------------------------------------------
		--DMF0003_SAVE_MKT_FCST 호출
		----------------------------------------------------------------------------------------------------------------

		EXEC DMF0003_SAVE_MKT_FCST
		   @p_active_flag = @V_ACTIVE_FLAG
		  ,@p_division_id = @V_DIVISION_ID
		  ,@p_project_code = @V_PROJECT_CODE
		  ,@p_scm_site_id = @V_SCM_SITE_ID
		  ,@p_item_id = @V_ITEM_ID
		  ,@p_dom_exp = @V_DOM_EXP
		  ,@p_fcst_type = @V_FCST_TYPE
		  ,@p_incoterms = @V_INCOTERMS
		  ,@p_measure = @V_MEASURE
		  ,@p_plant_site_id = @V_PLANT_SITE_ID
		  ,@p_yyyymmdd = @V_YYYYMMDD
		  ,@p_qty = @V_PLAN_QTY
		  ,@p_created_by = 'SCM_BATCH'
		  ,@p_as_FROM_SITE = 'ALL'
		  
		IF XACT_STATE() > 0 and @@trancount > 0
		BEGIN
			COMMIT TRAN 
		END
	------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		-- 트랜잭션 (END)
		--select XACT_STATE() as xact_state_1, @@trancount 
		--select XACT_STATE() as xact_state_2, @@trancount, 'A21'
		IF @@trancount > 0
		BEGIN 
			ROLLBACK TRAN
		END
		
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_log_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MSG;  /*-- 에러메시지 DISPLAY --*/

		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_Batch';


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure @@@##########';
    SET @v_log_description = 'input_count: ' + Convert(NVARCHAR(10), @n_input_count) ;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_Batch';


  END;










