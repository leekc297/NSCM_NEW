
/*========================================================================================================================
 * Program ID   : DMF0044_MOBILE_REPORT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *========================================================================================================================
 *	Date		In Charge		Description
 *========================================================================================================================
 * 2019.05.22	JSYOUN			Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 2019.11.18	hwi1993			파라미터 추가  및 데이터타입 변경, Cancel 기능 추가
 * 2020.05.19	HWI1993			@YYYY 를 버전번호를 잘라서 사용하던 것을 MDF_VERSION 에서 가져오도록 함
 * 2020.05.22	HWI1993			전송시 etc 를 묶는 로직 추가
 * 2020.06.05	HWI1993			BP 로직 제거 ( SP 와 변합 )
 * 2020.09.09   P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020.09.21	HWI1993			[C20200909-000188] [ESS영업관리팀] GDW 용도별 매출 수정 (프로젝트 코드 S 주택용/상업용 분리) 
 * 2021.08.16	hwi1993			[C20210811-000341] ETC Report - GDW 전송시 누락 컬럼 점검 요청의 건 -- ETC 누락 데이터 등 수정
 * 2024.05.09	JSSBAE			[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2025.04.04   JSSBAE			[E20250401-000548] SMS 선감지 대상 정리
 * 2025.05.09   JSSBAE			[E20250418-001567]_40사업부 Sales Report, ETC Report 개선
 * 2026.02.09   JSSBAE			[E20260107-001542]_DM_COMPANY 룩업코드 로직 개선
 ========================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0044_MOBILE_REPORT_CREATE]
	  @p_division_id            NVARCHAR(30) 
	, @p_version_no             NVARCHAR(50) 
	, @p_version_type           NVARCHAR(50) 
	, @p_action_type            NVARCHAR(1) 		-- T:Transfer, C:Cancel
	, @p_created_by				NVARCHAR(150)
AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;
	--------------------------------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정
	--------------------------------------------------------------------------------------------------------------------------
    DECLARE @v_program_name		NVARCHAR(150) = 'DMF0044_MOBILE_REPORT_CREATE';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;
    DECLARE @n_delete_count		INTEGER = 0;
    DECLARE @n_merge_count		INTEGER = 0;
	
	--------------------------------------------------------------------------------------------------------------------------
    -- local 변수선언
	--------------------------------------------------------------------------------------------------------------------------
    DECLARE @yyyy				NVARCHAR(4);
	--------------------------------------------------------------------------------------------------------------------------

	SELECT @yyyy = LEFT(YYYYMMDD, 4)
	FROM  DM_MDF_VERSION
	WHERE VERSION_NO = @p_version_no  
  
	--------------------------------------------------------------------------------------------------------------------------
	-- 시작 LOG  (START)
	--------------------------------------------------------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();	
	--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
	--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--------------------------------------------------------------------------------------------------------------------------
	-- 시작 LOG  (END)	
	--------------------------------------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------------------------------------
	-- 트랜잭션 (START)
	--------------------------------------------------------------------------------------------------------------------------
	BEGIN TRANSACTION;

	---------------------------------------------------------------------------------------------------------------------------	
	BEGIN TRY
	---------------------------------------------------------------------------------------------------------------------------		
		-----------------------------------------------------------------------------------------------------------------------
		-- Validation (BEGIN)
		-----------------------------------------------------------------------------------------------------------------------
		IF NOT EXISTS ( SELECT 1 FROM SCM_MST_DIVISION WITH(NOLOCK) 
								 WHERE 1=1
								 AND   DIVISION_ID = @p_division_id ) 
			BEGIN 
print '1--' + convert(varchar(30), getdate(), 121)
				SET @v_log_type = 'DIVISION_INVALID'
				GOTO ERR_RTN
			END

		IF NOT EXISTS ( SELECT 1 FROM DM_MDF_VERSION WITH(NOLOCK) 
								 WHERE 1=1
								 AND   DIVISION_ID = @p_division_id 
								 AND   VERSION_NO  = @p_version_no ) 
			BEGIN 
print '2--' + convert(varchar(30), getdate(), 121)
				SET @v_log_type = 'VERSION_NO_INVALID'
				GOTO ERR_RTN
			END
		
		IF @p_action_type = 'C'	AND NOT EXISTS ( SELECT DIVISION_ID FROM  DM_MDF_VERSION WITH(NOLOCK) 
												 WHERE DIVISION_ID = @p_division_id 
												 AND   VERSION_NO  = @p_version_no
												 AND   SEND_YN = 'Y' )
			BEGIN
print '3--' + convert(varchar(30), getdate(), 121)
				SET @v_log_type = 'ACTION_TYPE_INVALID_C'
				GOTO ERR_RTN
			END
			
		IF @p_action_type = 'C' AND NOT EXISTS ( SELECT DIVISION_ID	FROM DM_MDF_VERSION WITH(NOLOCK) 
												 WHERE DIVISION_ID = @p_division_id 
												 AND   VERSION_NO  = @p_version_no
												 AND   SEND_YN = 'Y' )
			BEGIN
print '4--' + convert(varchar(30), getdate(), 121)
				SET @v_log_type = 'ACTION_TYPE_INVALID_C'
				GOTO ERR_RTN
			END

		IF @p_action_type = 'T'	AND NOT EXISTS ( SELECT DIVISION_ID FROM DM_MDF_VERSION WITH(NOLOCK) 
												 WHERE DIVISION_ID = @p_division_id 
												 AND   VERSION_NO  = @p_version_no
												 AND   SEND_YN IN ( 'Y', 'N' ))
			BEGIN
print '5--' + convert(varchar(30), getdate(), 121)
				SET @v_log_type = 'ACTION_TYPE_INVALID_T'
				GOTO ERR_RTN
			END

		--[E20250401-000548]_DEPT_NAME VALIDATION 추가 START
		 IF ( SELECT COUNT(1) FROM DM_PLN_SALES_ETC_REPORT_C WITH(NOLOCK) 
			  WHERE DIVISION_ID = @p_division_id
			  AND   VERSION_NO  = @p_version_no
			  AND   DEPT_NAME IS NULL) > 0
			BEGIN
print '6--' + convert(varchar(30), getdate(), 121)
				SET @v_log_type = 'DEPT_NAME INVALID'
				GOTO ERR_RTN
			END
		--[E20250401-000548]_DEPT_NAME VALIDATION 추가 END
		--[E20260107-001542]_DEPARTMENT_NAME VALIDATION 추가 START
		 IF ( SELECT COUNT(1) FROM DM_PLN_SALES_ETC_REPORT_C WITH(NOLOCK) 
			  WHERE DIVISION_ID = @p_division_id
			  AND   VERSION_NO  = @p_version_no
			  AND   DEPARTMENT_NAME IS NULL) > 0
			BEGIN
print '6--' + convert(varchar(30), getdate(), 121)
				SET @v_log_type = 'DEPARTMENT_NAME INVALID'
				GOTO ERR_RTN
			END
		--[E20260107-001542]_DEPARTMENT_NAME VALIDATION 추가 END
		-----------------------------------------------------------------------------------------------------------------------
		--[E20250418-001567]_ETC Report 데이터를 Report로 병합하는 과정에서 중복오류발생하여,
		--해당 데이터 Insert 하기 전 데이터 생성 가능여부 확인 START
		-----------------------------------------------------------------------------------------------------------------------
		DECLARE @s_duplicate_validation  NVARCHAR(1000) = null;

		SET @s_duplicate_validation = (	SELECT TOP 1 'VERSION_NO_ : '+ ISNULL(A.VERSION_NO ,'') 
										+ CHAR(10) + 'DIVISION_ID_ : '+ ISNULL(A.DIVISION_ID ,'') 
										+ CHAR(10) + 'DEPARTMENT_ID_ : '+ ISNULL(A.DEPARTMENT_ID ,'') 
										+ CHAR(10) + 'DEPT_ID_ : '+ ISNULL(A.DEPT_ID ,'') 
										+ CHAR(10) + 'ITEM_ID_ : '+ ISNULL(A.ITEM_ID ,'') 
										+ CHAR(10) + 'MEASURE_ : '+ ISNULL(A.MEASURE ,'') 
										+ CHAR(10) + 'YYYYMMDD_ : '+ ISNULL(A.YYYYMMDD ,'') 
										+ CHAR(10) + 'CURRENCY_ : '+ ISNULL(A.CURRENCY ,'') 
										+ CHAR(10) + 'COMPANY_ID_ : '+ ISNULL(A.COMPANY_ID ,'') 
										+ CHAR(10) + 'END_CUST_REPORT_ : '+ ISNULL(A.END_CUST_REPORT ,'') 
										+ CHAR(10) + 'CUST_REPORT_ : '+ ISNULL(A.CUST_REPORT ,'') 
										+ CHAR(10) + 'PRODUCT_GROUP_ : '+ ISNULL(A.PRODUCT_GROUP ,'') 
										+ CHAR(10) + 'COUNTRY_KR_NAME_ : '+ ISNULL(A.COUNTRY_KR_NAME ,'') 											
										+ CHAR(10) + CHAR(10)
									FROM 
									(	SELECT A.VERSION_NO, A.DIVISION_ID, A.DEPARTMENT_ID, A.DEPT_ID, A.ITEM_ID
											 , A.MEASURE, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.END_CUST_REPORT
											 , A.CUST_REPORT, A.PRODUCT_GROUP, DBO.FN_GET_COUNTRY_KR_NAME(A.COUNTRY_CODE) AS COUNTRY_KR_NAME, COUNT(*) AS CNT
										FROM DM_PLN_SALES_ETC_REPORT_C A WITH(NOLOCK) 
										WHERE A.DIVISION_ID = @p_division_id
										AND   A.VERSION_NO = @p_version_no
										GROUP BY A.VERSION_NO, A.DIVISION_ID, A.DEPARTMENT_ID, A.DEPT_ID, A.ITEM_ID
											   , A.MEASURE, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.END_CUST_REPORT
											   , A.CUST_REPORT, A.PRODUCT_GROUP, DBO.FN_GET_COUNTRY_KR_NAME(A.COUNTRY_CODE)
										HAVING  COUNT(*) > 1 ) A )
		IF (@s_duplicate_validation IS NOT NULL)
			BEGIN	
print '7--' + convert(varchar(30), getdate(), 121)
				SET @v_log_type = 'DUPLICATION VALIDATION'
				GOTO ERR_RTN
			END
		-----------------------------------------------------------------------------------------------------------------------
		--[E20250418-001567]_ETC Report 데이터를 Report로 병합하는 과정에서 중복오류발생하여,
		--해당 데이터 Insert 하기 전 데이터 생성 가능여부 확인 END
		-----------------------------------------------------------------------------------------------------------------------
		-- Validation (END)
		-----------------------------------------------------------------------------------------------------------------------        
		-----------------------------------------------------------------------------------------------------------------------
		-- 전송준비 및 매출/사업계획 리포트 데이터 생성 (BEGIN)
		-----------------------------------------------------------------------------------------------------------------------
		BEGIN
print '8--' + convert(varchar(30), getdate(), 121)
            -- 발송플래그 업데이트
		    UPDATE DM_MDF_VERSION
               SET SEND_YN = CASE WHEN @p_action_type = 'T' THEN 'Y' ELSE 'C' END -- 초기는 N, 완료되면 Y, 취소되면 C, 삭제되면 D
                 , LAST_UPDATED_BY = @p_created_by
                 , LAST_UPDATE_DATE = GETDATE()
             WHERE DIVISION_ID = @p_division_id 
		       AND VERSION_NO  = @p_version_no;

			IF ( @p_division_id = '40' ) -- 소형일 때만 적용
			BEGIN
PRINT '9--' + CONVERT(VARCHAR(30), GETDATE(), 121)

				--같은 버전이 생성되어 있다면, 삭제 먼저 진행한다.
				DELETE FROM DM_PLN_SALES_PLAN_REPORT_C 
				WHERE DIVISION_ID = @p_division_id
				AND   VERSION_NO = @p_version_no
				AND   DATA_TYPE = '2'

PRINT '10--' + CONVERT(VARCHAR(30), GETDATE(), 121)
				
				--데이터를 생성한다.
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
				( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
				, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
				, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
				, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
				, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS
				, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
				, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE
				, COMPANY_NAME, APPLICATION, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
				, CELL_PROD_SITE )
				SELECT '2' AS DATA_TYPE, DIVISION_ID, VERSION_NO, 'REPORT_SP_W_E' AS CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
				, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
				, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
				, LAST_UPDATE_DATE, PRODUCT_DETAILS AS ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
				, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS
				, FORECAST_INFO_SPEC, NICK_NAME, CASE WHEN ATTRIBUTE2 <> '' THEN ATTRIBUTE2 ELSE CELL_MODEL_INFO END AS FORECAST_INFO_CELL_MODEL
				, FORECAST_INFO_CELL_PACK_COUNT, BIZ_TYPE AS FORECAST_INFO_BIZ_TYPE
				, COMPANY_NAME, APPLICATION, APPLICATION_GR, DBO.FN_GET_COUNTRY_KR_NAME(COUNTRY_CODE) AS COUNTRY_KR_NAME, ROUTE
				, '-' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청			
				FROM DM_PLN_SALES_ETC_REPORT_C WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND   VERSION_NO  = @p_version_no
				
PRINT '11--' + CONVERT(VARCHAR(30), GETDATE(), 121)

				EXEC DMF0044_SALES_REPORT_PRODUCT_CREATE @p_division_id, @p_version_no, @p_action_type, @yyyy;
				
PRINT '12--' + CONVERT(VARCHAR(30), GETDATE(), 121)

				EXEC DMF0044_SALES_REPORT_DEPT_CREATE @p_division_id, @p_version_no, @p_action_type, @yyyy;
				
PRINT '13--' + CONVERT(VARCHAR(30), GETDATE(), 121)

				EXEC DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE @p_division_id, @p_version_no, @p_action_type, @yyyy;
				
PRINT '14--' + CONVERT(VARCHAR(30), GETDATE(), 121)

			END
		END
		  
		-----------------------------------------------------------------------------------------------------------------------
		-- 전송준비 및 매출/사업계획 리포트 데이터 생성 (END)  
		-----------------------------------------------------------------------------------------------------------------------

    COMMIT WORK;
	---------------------------------------------------------------------------------------------------------------------------	
	END TRY
	---------------------------------------------------------------------------------------------------------------------------	
	
	---------------------------------------------------------------------------------------------------------------------------	
	BEGIN CATCH
	---------------------------------------------------------------------------------------------------------------------------	
	--------------------------------------------------------------------------------------------------------------------------
	-- 트랜잭션 (END)
	--------------------------------------------------------------------------------------------------------------------------
	--[C20200909-000203] LOG 표준화 적용		
	ROLLBACK TRANSACTION;
	-- ROLLBACK
	-- ERROR LOG VALUE SAVE
	--------------------------------------------------------------------------------------------------------------------------
	-- ERROR LOG (START)
	--------------------------------------------------------------------------------------------------------------------------
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

		--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
		--[C20200909-000203] LOG 표준화 적용
		--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
	--------------------------------------------------------------------------------------------------------------------------
	-- ERROR LOG (END)
	--------------------------------------------------------------------------------------------------------------------------
		
	--------------------------------------------------------------------------------------------------------------------------
	END CATCH;
	--------------------------------------------------------------------------------------------------------------------------

	-- 수행결과 성공여부 DISPLAY
		IF @v_log_message IS NULL
		SELECT 'success'
	;
	
	--------------------------------------------------------------------------------------------------------------------------
	-- 종료 LOG (START)
	--------------------------------------------------------------------------------------------------------------------------
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
	SET @d_event_date = SYSDATETIME();

	--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
	--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;		
	--------------------------------------------------------------------------------------------------------------------------
	-- 종료 LOG (END)
	--------------------------------------------------------------------------------------------------------------------------

	ERR_RTN:
	IF @v_log_type = 'DIVISION_INVALID'
		BEGIN
PRINT '15--' + CONVERT(VARCHAR(30), GETDATE(), 121)
			ROLLBACK TRANSACTION;
			--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 START
			--SET @v_log_message = '########## END of procedure ##########';
			SET @v_log_message = N'Division 값이 존재하지 않습니다.';
			--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 END
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();			
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
			SELECT N'Division 값이 존재하지 않습니다.'

			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 START
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
			SET @d_event_date = SYSDATETIME();

			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 END
		END
		
	IF @v_log_type = 'VERSION_NO_INVALID'
		BEGIN
PRINT '16--' + CONVERT(VARCHAR(30), GETDATE(), 121)
			ROLLBACK TRANSACTION;
			--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 START
			--SET @v_log_message = '########## END of procedure ##########';
			SET @v_log_message =  N'VERSION 값이 존재하지 않습니다.'
			--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 END
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();			
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
			SELECT N'VERSION 값이 존재하지 않습니다.'

			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 START
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
			SET @d_event_date = SYSDATETIME();

			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 END
		END
		
	IF @v_log_type = 'ACTION_TYPE_INVALID_C'
		BEGIN
PRINT '17--' + CONVERT(VARCHAR(30), GETDATE(), 121)
			ROLLBACK TRANSACTION;
			--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 START
			--SET @v_log_message = '########## END of procedure ##########';
			SET @v_log_message = N'Transfer Cancel은 SendYN 이 Y일 경우만 가능합니다.';
			--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 END
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();			
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
			SELECT N'Transfer Cancel은 SendYN 이 Y일 경우만 가능합니다.'

			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 START
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
			SET @d_event_date = SYSDATETIME();

			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 END
		END
	IF @v_log_type = 'ACTION_TYPE_INVALID_T'
		BEGIN
PRINT '18--' + CONVERT(VARCHAR(30), GETDATE(), 121)
			ROLLBACK TRANSACTION;
			--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 START
			--SET @v_log_message = '########## END of procedure ##########';
			SET @v_log_message =  N'Transfer 는 SendYN 이 N일 경우만 가능합니다.'
			--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 END
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();			
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
			SELECT N'Transfer 는 SendYN 이 N일 경우만 가능합니다.'

			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 START
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
			SET @d_event_date = SYSDATETIME();

			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 END
		END
	--[E20250401-000548] SMS 선감지 대상 정리	START
	IF @v_log_type = 'DEPT_NAME INVALID'
		BEGIN
PRINT '19--' + CONVERT(VARCHAR(30), GETDATE(), 121)
			ROLLBACK TRANSACTION;
			SET @v_log_message = N'DEPT_NAME 정보가 존재하지 않아 저장할 수 없습니다.';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();			
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
			SELECT N'DEPT_NAME 정보가 존재하지 않아 저장할 수 없습니다.'

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
			SET @d_event_date = SYSDATETIME();

			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
		END	

	--[E20260107-001542]_DEPARTMENT_NAME VALIDATION 추가 START
	IF @v_log_type = 'DEPARTMENT_NAME INVALID'
		BEGIN
PRINT '19--' + CONVERT(VARCHAR(30), GETDATE(), 121)
			ROLLBACK TRANSACTION;
			SET @v_log_message = N'DEPARTMENT_NAME 정보가 존재하지 않아 저장할 수 없습니다.';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();			
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
			SELECT N'DEPARTMENT_NAME 정보가 존재하지 않아 저장할 수 없습니다.'

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
			SET @d_event_date = SYSDATETIME();

			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
		END	
	--[E20260107-001542]_DEPARTMENT_NAME VALIDATION 추가 END

	--[E20250418-001567]_중복데이터 발생시 VALIDATION 내용 추가
	IF @v_log_type = 'DUPLICATION VALIDATION'
		BEGIN
PRINT '20--' + CONVERT(VARCHAR(30), GETDATE(), 121)
			ROLLBACK TRANSACTION;
			SET @v_log_message = @s_duplicate_validation + N'ETC Report데이터를 Sales Report 데이터와 병합하는 과정에서 중복 데이터가 발생했습니다.'
							    + char(10) + N'ETC Rpeort데이터에서 해당 데이터의 정보를 수정하시기 바랍니다.'
			SET @v_description = ''
			SET @d_event_date = SYSDATETIME();			
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
			SELECT @s_duplicate_validation + N'ETC Report데이터를 Sales Report 데이터와 병합하는 과정에서 중복 데이터가 발생했습니다.'
							    + char(10) + N'ETC Rpeort데이터에서 해당 데이터의 정보를 수정하시기 바랍니다.';

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
			SET @d_event_date = SYSDATETIME();

			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
		END
		--[E20250401-000548] SMS 선감지 대상 정리	END
	END;











