
/*====================================================================================================================
 * Program ID	: [PR_DM_CUST_MODEL_MAPPING]
 * Description  : N:N Model Mapping 데이터 기초값 생성 
 * 테이블		: DM_CUST_MODEL_MAPPING_M
 * Program History
 *=====================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================
 * 2024.12.09	KANG.H.J		[PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 * 2026.01.06	JSSBAE			[E20260106-000753]_EDI Calloff 데이터 IF 로직 개선
 
 --EXEC PR_DM_CUST_MODEL_MAPPING 'SCM'    --EDI(PR_DM_DNM_EDI_CALLOFF CALL)
=====================================================================================================================*/
CREATE PROCEDURE [dbo].[PR_DM_CUST_MODEL_MAPPING]  
	 @p_accept_flag			NVARCHAR(10)	-- 업무구분(SCM)
AS 
 
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON; 
	
	BEGIN TRAN PR_DM_CUST_MODEL_MAPPING;
	BEGIN TRY
		--=====================================================================================================================
		-- LOG 용 변수 설정 (START)
		--=====================================================================================================================
		DECLARE @V_PROGRAM_NAME		NVARCHAR(150) = 'PR_DM_CUST_MODEL_MAPPING';
		DECLARE @V_LOG_TYPE			NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @N_LOG_COUNT		INTEGER = 0;
		DECLARE @V_LOG_MESSAGE		NVARCHAR(1000);
		DECLARE @V_DESCRIPTION		NVARCHAR(500);
		DECLARE @D_EVENT_DATE		DATETIME;
		DECLARE @N_DELETE_COUNT		INTEGER = 0;
		DECLARE @N_INSERT_COUNT     INTEGER = 0;
		DECLARE @V_CREATED_BY		NVARCHAR(150)	= @V_PROGRAM_NAME; --[E20260106-000753]_CREATE명 변경
		--=====================================================================================================================
		-- LOG 용 변수 설정 (END)
		--=====================================================================================================================
		
		--=====================================================================================================================
		-- 시작 LOG (START)
		--=====================================================================================================================
		SET @V_LOG_TYPE = 'START';
		SET @V_LOG_MESSAGE = '########## START OF PROCEDURE ##########';
		SET @V_DESCRIPTION = 'PR_DM_CUST_MODEL_MAPPING: ' +  @p_accept_flag;
		SET @D_EVENT_DATE = SYSDATETIME();
		EXEC  PR_DM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE, @V_CREATED_BY;   
		--=====================================================================================================================
		-- 시작 LOG (END)
		--=====================================================================================================================    
		
		--=====================================================================================================================
		-- 변수 설정 (START)
		--=====================================================================================================================
		DECLARE @v_delimiter			NVARCHAR(1);
     	DECLARE @v_accept_flag			NVARCHAR(10);	 	  
		DECLARE @v_CNT					INTEGER = 0; 
		DECLARE @v_from_yyyymmdd		NVARCHAR(08);
		DECLARE @v_delete_yyyymmdd		NVARCHAR(08); 
		DECLARE @v_VALID_START_DATE		NVARCHAR(08);
		DECLARE @v_VALID_END_DATE		NVARCHAR(08);
		
		/* 오윤종 PI 요청으로 셋팅함 */
		SET @v_from_yyyymmdd	= '20240101'  
		SET @v_delete_yyyymmdd	= CONVERT(CHAR(8), DATEADD(mm, - 12, GETDATE()),  112)	-- 미사용됨.
		SET @v_VALID_START_DATE = CONVERT(CHAR(4), GETDATE(), 112) + '0101' 
		SET @v_VALID_END_DATE	= '20991231' 
	    SET @v_accept_flag		= @p_accept_flag 
		--=====================================================================================================================
		-- 변수 설정 (END)
		--=====================================================================================================================
PRINT @V_PROGRAM_NAME + ': A1--' + CONVERT(VARCHAR(30), GETDATE(), 121) + ' / @p_accept_flag: ' + @p_accept_flag	 

	    IF @v_accept_flag = 'SCM'  
		BEGIN 
PRINT @V_PROGRAM_NAME + ': A2--' + CONVERT(VARCHAR(30), GETDATE(), 121) + ' / @p_accept_flag: ' + @p_accept_flag	 
			--[PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 START
			MERGE INTO DM_CUST_MODEL_MAPPING_M T1
			--[E20260106-000753]_DM_CUST_MODEL_MAPPING_M 해당 키값으로 데이터 조회를 하지 않아, 두개 이상의 데이터가 조회되어 오류 발생 (START)
			-- 원소스 주석 처리 후 DM_CUST_MODEL_MAPPING_M 테이블 키값기준으로 조회하여 진행하도록 수정 
			/*
			USING (	SELECT DISTINCT A.DIVISION_ID
				   				  , A.SENDER_CODE
								  , A.SENDER_NAME 
								  , ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),'') AS UNLOADING_POINT
								  , ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'') AS CUSTOMER_PLANT 
								  , ISNULL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)),'') AS CUSTOMER_ITEM_ID
								  , A.SHIPTO_CODE
								  , A.SOLDTO_CODE
								  , A.ITEM_ID
								  , ISNULL(B.MAPPING_ITEM_ID, A.ITEM_ID) AS MAPPING_ITEM_ID
								  , A.SCM_SITE_ID 
								  , A.EDI_INCOTERMS AS INCOTERMS 
								  , A.PROJECT_CODE
								  , ISNULL(C.END_CUSTOMER, '')	AS END_CUSTOMER								  
								  , CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END AS FCST_TYPE					
								  , 'E' AS DOM_EXP
								  , @v_VALID_START_DATE AS VALID_START_DATE
								  , @v_VALID_END_DATE AS VALID_END_DATE
								  , A.COMPANY_ID AS COMPANY_ID
								  , 'SCM' AS DATA_TYPE_CODE				
					FROM DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK) 
					LEFT OUTER JOIN DM_CUST_MODEL_MAPPING_M B WITH(NOLOCK)
								 ON A.DIVISION_ID		= B.DIVISION_ID
								AND B.DATA_TYPE_CODE	= 'SCM'
								AND A.COMPANY_ID		= B.COMPANY_ID
								AND A.SOLDTO_CODE		= B.SOLDTO_CODE
								AND A.SHIPTO_CODE		= B.SHIPTO_CODE
								AND ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)), '')		= ISNULL(RTRIM(LTRIM(B.UNLOADING_POINT)), '')
								AND ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), '')		= ISNULL(RTRIM(LTRIM(B.CUSTOMER_PLANT)), '') 
								AND ISNULL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)), '')	= ISNULL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)), '')   
								AND A.SCM_SITE_ID		= B.SCM_SITE_ID
								AND A.PROJECT_CODE		= B.PROJECT_CODE 
								AND B.FCST_TYPE			= CASE WHEN A.ERP_FCST_TYPE	= 'S' THEN 'SMC' ELSE 'MPS' END 
								AND A.EDI_INCOTERMS		= B.INCOTERMS 
								AND B.DOM_EXP			= 'E'
								AND A.ITEM_ID			= B.ITEM_ID 	
					LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
								 ON A.DIVISION_ID	= C.DIVISION_ID
								AND A.SCM_SITE_ID	= C.SCM_SITE_ID
								AND C.SITE_TYPE		= 'SALES'
								AND C.VALID_YN		= 'Y'					
					WHERE A.CREATE_DATE >= @v_from_yyyymmdd
					AND A.STATUS_CODE	= 'S'
					--AND A.SENDER_NAME	<> 'LUCID' 
					AND A.COMPANY_ID IN (SELECT SEGMENT1 AS COMPANY FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_EDI_COMPANY_DIVISION_MAPPING' AND SEGMENT3='N' AND VALID_YN = 'Y')	-- NERP로부터 기준정보를 받지 않는 법인
					GROUP BY A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),''), ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'')
						   , ISNULL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)),''), A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, B.MAPPING_ITEM_ID, A.SCM_SITE_ID, A.EDI_INCOTERMS
						   , A.PROJECT_CODE, C.END_CUSTOMER,A.ERP_FCST_TYPE,A.COMPANY_ID 
			*/
			--DM_CUST_MODEL_MAPPING_M 테이블 키값기준으로 조회 + END_CUSTOMER 추가
			USING (	SELECT T.DATA_TYPE_CODE, T.DIVISION_ID, T.COMPANY_ID, T.SOLDTO_CODE, T.SHIPTO_CODE
						 , T.UNLOADING_POINT, T.CUSTOMER_PLANT, T.CUSTOMER_ITEM_ID, T.SCM_SITE_ID, T.PROJECT_CODE
						 , T.FCST_TYPE, T.INCOTERMS, T.DOM_EXP, T.ITEM_ID, T.MAPPING_ITEM_ID, ISNULL(C.END_CUSTOMER, '') AS END_CUSTOMER
					FROM ( SELECT  DISTINCT 'SCM' AS DATA_TYPE_CODE, A.DIVISION_ID, A.COMPANY_ID, A.SOLDTO_CODE, A.SHIPTO_CODE
						  		 , ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),'') AS UNLOADING_POINT, ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'') AS CUSTOMER_PLANT 
								 , ISNULL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)),'') AS CUSTOMER_ITEM_ID, A.SCM_SITE_ID, A.PROJECT_CODE
								 , CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END AS FCST_TYPE, A.EDI_INCOTERMS AS INCOTERMS, 'E' AS DOM_EXP, A.ITEM_ID 	
								 , ISNULL(B.MAPPING_ITEM_ID, A.ITEM_ID) AS MAPPING_ITEM_ID		
							FROM DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK) 
							LEFT OUTER JOIN DM_CUST_MODEL_MAPPING_M B WITH(NOLOCK)
										 ON A.DIVISION_ID		= B.DIVISION_ID
										AND B.DATA_TYPE_CODE	= 'SCM'
										AND A.COMPANY_ID		= B.COMPANY_ID
										AND A.SOLDTO_CODE		= B.SOLDTO_CODE
										AND A.SHIPTO_CODE		= B.SHIPTO_CODE
										AND ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)), '')		= ISNULL(RTRIM(LTRIM(B.UNLOADING_POINT)), '')
										AND ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), '')		= ISNULL(RTRIM(LTRIM(B.CUSTOMER_PLANT)), '') 
										AND ISNULL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)), '')	= ISNULL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)), '')   
										AND A.SCM_SITE_ID		= B.SCM_SITE_ID
										AND A.PROJECT_CODE		= B.PROJECT_CODE 
										AND B.FCST_TYPE			= CASE WHEN A.ERP_FCST_TYPE	= 'S' THEN 'SMC' ELSE 'MPS' END 
										AND A.EDI_INCOTERMS		= B.INCOTERMS 
										AND B.DOM_EXP			= 'E'
										AND A.ITEM_ID			= B.ITEM_ID 
							WHERE A.CREATE_DATE >= @v_from_yyyymmdd
							AND A.STATUS_CODE	= 'S'
							AND A.COMPANY_ID IN (SELECT SEGMENT1 AS COMPANY FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = 'DM_EDI_COMPANY_DIVISION_MAPPING' AND SEGMENT3='N' AND VALID_YN = 'Y')	-- NERP로부터 기준정보를 받지 않는 법인
						 ) T	
					LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
								 ON T.DIVISION_ID	= C.DIVISION_ID
								AND T.SCM_SITE_ID	= C.SCM_SITE_ID
								AND C.SITE_TYPE		= 'SALES'
								AND C.VALID_YN		= 'Y'					
				   ) T2
				ON (	T1.DIVISION_ID		= T2.DIVISION_ID
					AND T1.DATA_TYPE_CODE	= T2.DATA_TYPE_CODE
					AND T1.COMPANY_ID		= T2.COMPANY_ID
					AND T1.SOLDTO_CODE		= T2.SOLDTO_CODE
					AND T1.SHIPTO_CODE		= T2.SHIPTO_CODE
					AND ISNULL(RTRIM(LTRIM(T1.UNLOADING_POINT)), '')	= ISNULL(RTRIM(LTRIM(T2.UNLOADING_POINT)), '')
					AND ISNULL(RTRIM(LTRIM(T1.CUSTOMER_PLANT)), '')		= ISNULL(RTRIM(LTRIM(T2.CUSTOMER_PLANT)), '') 
					AND ISNULL(RTRIM(LTRIM(T1.CUSTOMER_ITEM_ID)), '')	= ISNULL(RTRIM(LTRIM(T2.CUSTOMER_ITEM_ID)), '')   
					AND T1.SCM_SITE_ID		= T2.SCM_SITE_ID
					AND T1.PROJECT_CODE		= T2.PROJECT_CODE 
					AND T1.FCST_TYPE		= T2.FCST_TYPE 
					AND T1.INCOTERMS		= T2.INCOTERMS 
					AND T1.DOM_EXP			= T2.DOM_EXP 
					AND T1.ITEM_ID			= T2.ITEM_ID 	
					AND T1.MAPPING_ITEM_ID	= T2.MAPPING_ITEM_ID ) 
			WHEN MATCHED THEN
				UPDATE SET T1.END_CUSTOMER		= T2.END_CUSTOMER
						--[E20260106-000753]_UPDATED_BY는 프로시져 명으로 작성한다 원소스 주석 (START)
						--,  T1.LAST_UPDATED_BY	= 'BATCH SYSTEM' 
						,  T1.LAST_UPDATED_BY	= @V_CREATED_BY			
						--[E20260106-000753]_UPDATED_BY는 프로시져 명으로 작성한다 원소스 주석 (END)
						,  T1.LAST_UPDATE_DATE	= SYSDATETIME()
			WHEN NOT MATCHED AND (T2.DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION DIV WITH(NOLOCK) WHERE VALID_YN = 'Y')) THEN
				INSERT ( DIVISION_ID, DATA_TYPE_CODE, END_CUSTOMER, SCM_SITE_ID, PROJECT_CODE
					   , FCST_TYPE, INCOTERMS, DOM_EXP, ITEM_ID, MAPPING_ITEM_ID
					   , ACTIVE_YN, UNLOADING_POINT, CUSTOMER_PLANT, SOLDTO_CODE, SHIPTO_CODE
					   , CUSTOMER_ITEM_ID, VALID_START_DATE, VALID_END_DATE, COMPANY_ID, CREATED_BY
					   , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
				VALUES ( T2.DIVISION_ID, T2.DATA_TYPE_CODE, T2.END_CUSTOMER, T2.SCM_SITE_ID, T2.PROJECT_CODE 
					   , T2.FCST_TYPE, T2.INCOTERMS, T2.DOM_EXP, T2.ITEM_ID, T2.MAPPING_ITEM_ID
					   , 'Y', T2.UNLOADING_POINT, T2.CUSTOMER_PLANT, T2.SOLDTO_CODE, T2.SHIPTO_CODE
					   , T2.CUSTOMER_ITEM_ID
					   --[E20260106-000753]_고정값이므로, 고정값으로 변경 (START)
					   --, T2.VALID_START_DATE, T2.VALID_END_DATE
					   , @v_VALID_START_DATE, @v_VALID_END_DATE
					   --[E20260106-000753]_고정값이므로, 고정값으로 변경 (END)
					   , T2.COMPANY_ID, @V_CREATED_BY--'BATCH SYSTEM' --[E20260106-000753]_UPDATED_BY는 프로시져 명으로 작성한다 'BATCH SYSTEM' ->  @V_CREATED_BY
					   , SYSDATETIME(), @V_CREATED_BY--'BATCH SYSTEM' --[E20260106-000753]_UPDATED_BY는 프로시져 명으로 작성한다 'BATCH SYSTEM' ->  @V_CREATED_BY
					   , SYSDATETIME()) 
			;
			--[PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 END
PRINT @V_PROGRAM_NAME + ': A3--' + CONVERT(VARCHAR(30), GETDATE(), 121) + ' / @p_accept_flag: ' + @p_accept_flag	 
		END  	
		COMMIT;

	END TRY

	BEGIN CATCH
		ROLLBACK TRAN PR_DM_CUST_MODEL_MAPPING;		
		--=====================================================================================================================
		-- ERROR LOG (START)
		--=====================================================================================================================
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		--=====================================================================================================================
		-- ERROR LOG (END)
		--=====================================================================================================================	
	END CATCH;
	
PRINT @V_PROGRAM_NAME + ': A4--' + CONVERT(VARCHAR(30), GETDATE(), 121) + ' / @p_accept_flag: ' + @p_accept_flag	 
	--=====================================================================================================================
	-- 종료 LOG (START)
	--=====================================================================================================================
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;		
	--=====================================================================================================================
	-- 종료 LOG (END)
	--=====================================================================================================================

END;
