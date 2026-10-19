
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

CREATE PROCEDURE [dbo].[DMF0003_SAVE_PR_Request_AUTO_BASIS]

AS  
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	SET ANSI_WARNINGS ON;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0003_SAVE_PR_Request_AUTO';
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
		WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(WEEK, 12, GETDATE()), 112) --13주 뒤
	)
	SELECT 
	MF.DIVISION_ID
	,MF.PROJECT_CODE
	,(
		SELECT TOP 1 SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			WHERE LOOKUP_TYPE = 'DM_PR_PUCH' 
	) PUCH_MGR
	,(
		SELECT TOP 1 SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			WHERE LOOKUP_TYPE = 'DM_PR_PUCH' 
	) PUCH_GROUP
	,'( ' + MF.PROJECT_CODE + ' ) ' 
		+ (
			SELECT TOP 1 PROJECT_NAME FROM SCM_MST_PROJECT WITH(NOLOCK) 
			WHERE DIVISION_ID = MF.DIVISION_ID 
			AND PROJECT_CODE = MF.PROJECT_CODE)
		+ LUP.SEGMENT2
			PR_HEADER -- (Project Code) + Project + '물량'(룩업관리)
	--,'( ' + MF.PROJECT_CODE + ' ) ' + dbo.FN_GET_PROJECT_NAME (MF.DIVISION_ID, MF.PROJECT_CODE) + N' 물량'	PR_HEADER -- (Project Code) + Project + '물량'(룩업관리)
	,row_number() OVER( ORDER BY MF.PROJECT_CODE, MF.ITEM_ID) ITEM_SEQ
	,LUP.SEGMENT4 STORAGE_ID -- SLOC(룩업관리)
	/*,
	CASE WHEN (	
		SELECT TOP 1
				 SEGMENT1
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			WHERE LOOKUP_TYPE = 'DM_PR_SLOC'
				AND ATTRIBUTE2 LIKE 
				(
					SELECT DEPT_ID
							FROM TB_FX_USER 
							WHERE USERID = MF.CREATED_BY
				)
			) IS NULL THEN
			(
						SELECT TOP 1
							 SEGMENT1
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL
						WHERE LOOKUP_TYPE = 'DM_PR_SLOC'
							AND ATTRIBUTE2 = ''	
			) 
			ELSE
			(	
				SELECT TOP 1
						 SEGMENT1
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL
					WHERE LOOKUP_TYPE = 'DM_PR_SLOC'
						AND ATTRIBUTE2 LIKE 
						(
							SELECT DEPT_ID
									FROM TB_FX_USER 
									WHERE USERID = MF.CREATED_BY
						)
			)
	END STORAGE_PLANT_ID*/
	, LUP.SEGMENT3 STORAGE_PLANT_ID--(룩업관리) => 별도 쿼리 해오다가 룩업관리로 변경함
	, LUP.SEGMENT5 ITEM_DETAIL--(룩업관리)
	, (
		SELECT ITEM_UOM 
		FROM  DM_MST_ITEM_SINGLE_V
		WHERE DIVISION_ID = MF.DIVISION_ID 
		AND ITEM_ID = MF.ITEM_ID
	) UOM
	, MF.QTY
	, MF.YYYYMMDD
	, MF.SCM_SITE_ID
	, MF.ITEM_ID
	, MF.DOM_EXP
	, MF.FCST_TYPE
	, MF.INCOTERMS
	--, LUP.SEGMENT3 PLANT_SITE_ID--(룩업관리) =>STORAGE_PLANT_ID로 변경
	, '' PLANT_SITE_ID
	INTO #TMP_TARGET_LIST
	FROM DM_PLN_MKT_FCST MF WITH(NOLOCK)
	INNER JOIN
	(
		SELECT * FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
		WHERE LOOKUP_TYPE = 'PR_REQUEST_AUTO_TEXT'
	) LUP
		ON LUP.SEGMENT1 = MF.DIVISION_ID
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
	WHERE MF.DIVISION_ID = '82'
	AND MF.MEASURE = 'MKT_FCST'
	AND MF.YYYYMMDD >= (SELECT BASIS_START_DATE FROM DTTMP) --13주차 시작(91일)
	AND MF.YYYYMMDD <= (SELECT BASIS_END_DATE FROM DTTMP) --13주차 종료(98일)
	ORDER BY MF.PROJECT_CODE, MF.ITEM_ID

	--커서 값 담을 변수
	DECLARE  @CUR_ITEM_SEQ			NVARCHAR(150)
		, @CUR_DIVISION_ID		NVARCHAR(150)
		, @CUR_PROJECT_CODE		NVARCHAR(150)
		, @CUR_SCM_SITE_ID		NVARCHAR(150)
		, @CUR_ITEM_ID			NVARCHAR(150)
		, @CUR_DOM_EXP			NVARCHAR(150)
		, @CUR_FCST_TYPE			NVARCHAR(150)
		, @CUR_INCOTERMS			NVARCHAR(150)
		, @CUR_PLANT_SITE_ID		NVARCHAR(150)
		, @CUR_YYYYMMDD			NVARCHAR(150)
		, @CUR_UOM				NVARCHAR(150)
		, @CUR_PLAN_QTY			NVARCHAR(150)
		, @CUR_STORAGE_ID			NVARCHAR(150)
		, @CUR_STORAGE_PLANT_ID	NVARCHAR(150)
		, @CUR_PUCH_MGR			NVARCHAR(150)
		, @CUR_PUCH_GROUP			NVARCHAR(150)
		, @CUR_PR_HEADER			NVARCHAR(150)
		, @CUR_PR_ITEM_DETAIL		NVARCHAR(150)


	--커서 값 누적 시켜 SP 호출시 넘길 변수
	DECLARE  @V_ITEM_SEQ			NVARCHAR(max) = ''
		, @V_DIVISION_ID		NVARCHAR(max) = ''
		, @V_PROJECT_CODE		NVARCHAR(max) = ''
		, @V_SCM_SITE_ID		NVARCHAR(max) = ''
		, @V_ITEM_ID			NVARCHAR(max) = ''
		, @V_DOM_EXP			NVARCHAR(max) = ''
		, @V_FCST_TYPE			NVARCHAR(max) = ''
		, @V_INCOTERMS			NVARCHAR(max) = ''
		, @V_PLANT_SITE_ID		NVARCHAR(max) = ''
		, @V_YYYYMMDD			NVARCHAR(max) = ''
		, @V_UOM				NVARCHAR(max) = ''
		, @V_PLAN_QTY			NVARCHAR(max) = ''
		, @V_STORAGE_ID			NVARCHAR(max) = ''
		, @V_STORAGE_PLANT_ID	NVARCHAR(max) = ''
		, @V_PUCH_MGR			NVARCHAR(max) = ''
		, @V_PUCH_GROUP			NVARCHAR(max) = ''
		, @V_PR_HEADER			NVARCHAR(max) = ''
		, @V_PR_ITEM_DETAIL		NVARCHAR(max) = ''

		DECLARE CUR_TARGET_LIST CURSOR FAST_FORWARD FOR
		SELECT 
				DIVISION_ID
				,PROJECT_CODE
				, PUCH_MGR
				, PUCH_GROUP
				, PR_HEADER
				, ITEM_SEQ
				, STORAGE_ID 
				, STORAGE_PLANT_ID
				, ITEM_DETAIL
				,  UOM
				,QTY
				,YYYYMMDD
				,SCM_SITE_ID
				,ITEM_ID
				,DOM_EXP
				,FCST_TYPE
				,INCOTERMS
				, PLANT_SITE_ID		
		FROM #TMP_TARGET_LIST

		OPEN CUR_TARGET_LIST;
		FETCH NEXT FROM CUR_TARGET_LIST INTO 
					@CUR_DIVISION_ID	
					, @CUR_PROJECT_CODE		
					, @CUR_PUCH_MGR			
					, @CUR_PUCH_GROUP
					, @CUR_PR_HEADER	
					, @CUR_ITEM_SEQ			
					, @CUR_STORAGE_ID			
					, @CUR_STORAGE_PLANT_ID		
					, @CUR_PR_ITEM_DETAIL	
					, @CUR_UOM		
					, @CUR_PLAN_QTY	
					, @CUR_YYYYMMDD	
					, @CUR_SCM_SITE_ID		
					, @CUR_ITEM_ID			
					, @CUR_DOM_EXP			
					, @CUR_FCST_TYPE			
					, @CUR_INCOTERMS			
					, @CUR_PLANT_SITE_ID		

		WHILE @@FETCH_STATUS = 0
		BEGIN

			SET @V_DIVISION_ID = @V_DIVISION_ID + CASE WHEN @V_DIVISION_ID = '' THEN '' ELSE '^' END + @CUR_DIVISION_ID
			SET @V_PROJECT_CODE = @V_PROJECT_CODE + (CASE WHEN @V_PROJECT_CODE = '' THEN '' ELSE '^' END) + @CUR_PROJECT_CODE
			SET @V_PUCH_MGR = @V_PUCH_MGR + CASE WHEN @V_PUCH_MGR = '' THEN '' ELSE '^' END + @CUR_PUCH_MGR
			SET @V_PUCH_GROUP = @V_PUCH_GROUP + CASE WHEN @V_PUCH_GROUP = '' THEN '' ELSE '^' END + @CUR_PUCH_GROUP
			SET @V_PR_HEADER = @V_PR_HEADER + CASE WHEN @V_PR_HEADER = '' THEN '' ELSE '^' END + @CUR_PR_HEADER
			SET @V_ITEM_SEQ = @V_ITEM_SEQ + CASE WHEN @V_ITEM_SEQ = '' THEN '' ELSE '^' END + @CUR_ITEM_SEQ
			SET @V_STORAGE_ID = @V_STORAGE_ID + CASE WHEN @V_STORAGE_ID = '' THEN '' ELSE '^' END + @CUR_STORAGE_ID
			SET @V_STORAGE_PLANT_ID = @V_STORAGE_PLANT_ID + CASE WHEN @V_STORAGE_PLANT_ID = '' THEN '' ELSE '^' END + @CUR_STORAGE_PLANT_ID
			SET @V_PR_ITEM_DETAIL = @V_PR_ITEM_DETAIL + CASE WHEN @V_PR_ITEM_DETAIL = '' THEN '' ELSE '^' END + @CUR_PR_ITEM_DETAIL
			SET @V_UOM = @V_UOM + CASE WHEN @V_UOM = '' THEN '' ELSE '^' END + @CUR_UOM
			SET @V_PLAN_QTY = @V_PLAN_QTY + CASE WHEN @V_PLAN_QTY = '' THEN '' ELSE '^' END + @CUR_PLAN_QTY
			SET @V_YYYYMMDD = @V_YYYYMMDD + CASE WHEN @V_YYYYMMDD = '' THEN '' ELSE '^' END + @CUR_YYYYMMDD
			SET @V_SCM_SITE_ID = @V_SCM_SITE_ID + CASE WHEN @V_SCM_SITE_ID = '' THEN '' ELSE '^' END + @CUR_SCM_SITE_ID
			SET @V_ITEM_ID = @V_ITEM_ID + CASE WHEN @V_ITEM_ID = '' THEN '' ELSE '^' END + @CUR_ITEM_ID
			SET @V_DOM_EXP = @V_DOM_EXP + CASE WHEN @V_DOM_EXP = '' THEN '' ELSE '^' END + @CUR_DOM_EXP
			SET @V_FCST_TYPE = @V_FCST_TYPE + CASE WHEN @V_FCST_TYPE = '' THEN '' ELSE '^' END + @CUR_FCST_TYPE
			SET @V_INCOTERMS = @V_INCOTERMS + CASE WHEN @V_INCOTERMS = '' THEN '' ELSE '^' END + @CUR_INCOTERMS
			SET @V_PLANT_SITE_ID = @V_PLANT_SITE_ID + CASE WHEN @V_PLANT_SITE_ID = '' THEN '' ELSE '^' END + @CUR_PLANT_SITE_ID

			FETCH NEXT FROM CUR_TARGET_LIST INTO 
						@CUR_DIVISION_ID	
						, @CUR_PROJECT_CODE		
						, @CUR_PUCH_MGR			
						, @CUR_PUCH_GROUP
						, @CUR_PR_HEADER	
						, @CUR_ITEM_SEQ			
						, @CUR_STORAGE_ID			
						, @CUR_STORAGE_PLANT_ID		
						, @CUR_PR_ITEM_DETAIL	
						, @CUR_UOM		
						, @CUR_PLAN_QTY	
						, @CUR_YYYYMMDD	
						, @CUR_SCM_SITE_ID		
						, @CUR_ITEM_ID			
						, @CUR_DOM_EXP			
						, @CUR_FCST_TYPE			
						, @CUR_INCOTERMS			
						, @CUR_PLANT_SITE_ID	

		END
		CLOSE CUR_TARGET_LIST;
		DEALLOCATE CUR_TARGET_LIST;


		----------------------------------------------------------------------------------------------------------------
		--DMF0003_SAVE_PRPOPUP 호출
		----------------------------------------------------------------------------------------------------------------
		
		SELECT @V_ITEM_SEQ
		SELECT @V_DIVISION_ID
		SELECT @V_PROJECT_CODE
		SELECT @V_SCM_SITE_ID
		SELECT @V_ITEM_ID
		SELECT @V_DOM_EXP
		SELECT @V_FCST_TYPE
		SELECT @V_INCOTERMS
		SELECT @V_PLANT_SITE_ID
		SELECT @V_YYYYMMDD
		SELECT @V_UOM
		SELECT @V_PLAN_QTY
		SELECT @V_STORAGE_ID
		SELECT @V_STORAGE_PLANT_ID
		SELECT @V_PUCH_MGR
		SELECT @V_PUCH_GROUP
		SELECT @V_PR_HEADER
		SELECT @V_PR_ITEM_DETAIL
		

		/*
		EXEC DMF0003_SAVE_PRPOPUP_TEST
		   @p_POPUP_TYPE = 'Request_PR'
		  ,@p_ITEM_SEQ = @V_ITEM_SEQ
		  ,@p_DIVISION_ID = @V_DIVISION_ID
		  ,@p_PROJECT_CODE = @V_PROJECT_CODE
		  ,@p_SCM_SITE_ID = @V_SCM_SITE_ID
		  ,@p_ITEM_ID = @V_ITEM_ID
		  ,@p_DOM_EXP = @V_DOM_EXP
		  ,@p_FCST_TYPE = @V_FCST_TYPE
		  ,@p_INCOTERMS = @V_INCOTERMS
		  ,@p_PLANT_SITE_ID = @V_PLANT_SITE_ID
		  ,@p_YYYYMMDD = @V_YYYYMMDD
		  ,@p_UOM = @V_UOM
		  ,@p_PLAN_QTY = @V_PLAN_QTY
		  ,@p_STORAGE_ID = @V_STORAGE_ID
		  ,@p_STORAGE_PLANT_ID = @V_STORAGE_PLANT_ID
		  ,@p_PUCH_MGR = @V_PUCH_MGR
		  ,@p_PUCH_GROUP = @V_PUCH_GROUP
		  ,@p_PR_HEADER = @V_PR_HEADER
		  ,@p_PR_ITEM_DETAIL = @V_PR_ITEM_DETAIL
		  ,@p_CREATED_BY = 'SCM_BATCH'
		  */


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










