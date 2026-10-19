
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
 ========================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0044_MOBILE_REPORT_CREATE_20250502]
	@p_division_id            NVARCHAR(30),
	@p_version_no             NVARCHAR(50),
	@p_version_type           NVARCHAR(50),
	@p_action_type            NVARCHAR(1),		-- T:Transfer, C:Cancel
	@p_created_by			  NVARCHAR(150)
AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0044_MOBILE_REPORT_CREATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_merge_count     INTEGER = 0;
	
    -- local 변수선언
    DECLARE @yyyy           NVARCHAR(4);
	SELECT @yyyy = LEFT(YYYYMMDD, 4)
	FROM DM_MDF_VERSION
	WHERE VERSION_NO = @p_version_no  
  
	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();	
	--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
	--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	BEGIN TRANSACTION;


	---------------------------------------------------------------------------------------------------------------------------	
	BEGIN TRY
	---------------------------------------------------------------------------------------------------------------------------	

		----------------------------------------------------------------------------------------------------- 
		-- Validation (BEGIN)
		-----------------------------------------------------------------------------------------------------
		IF NOT EXISTS ( SELECT 1 FROM SCM_MST_DIVISION WITH (NOLOCK) WHERE 1=1
									AND DIVISION_ID = @p_division_id ) 
			BEGIN 
				SET @v_log_type = 'DIVISION_INVALID'
				GOTO ERR_RTN
			END

		IF NOT EXISTS ( SELECT 1 FROM DM_MDF_VERSION WITH (NOLOCK) WHERE 1=1
									AND DIVISION_ID = @p_division_id 
									AND VERSION_NO  = @p_version_no ) 
			BEGIN 
				SET @v_log_type = 'VERSION_NO_INVALID'
				GOTO ERR_RTN
			END
		
		IF @p_action_type = 'C'
			AND NOT EXISTS ( 
				SELECT DIVISION_ID
				FROM DM_MDF_VERSION
				WHERE DIVISION_ID = @p_division_id 
					AND VERSION_NO  = @p_version_no
					AND SEND_YN = 'Y'
					)
			BEGIN
				SET @v_log_type = 'ACTION_TYPE_INVALID_C'
				GOTO ERR_RTN
			END
			
		IF @p_action_type = 'C'
			AND NOT EXISTS ( 
				SELECT DIVISION_ID
				FROM DM_MDF_VERSION
				WHERE DIVISION_ID = @p_division_id 
					AND VERSION_NO  = @p_version_no
					AND SEND_YN = 'Y'
					)
			BEGIN
				SET @v_log_type = 'ACTION_TYPE_INVALID_C'
				GOTO ERR_RTN
			END

		IF @p_action_type = 'T'
			AND NOT EXISTS ( 
				SELECT DIVISION_ID
				FROM DM_MDF_VERSION
				WHERE DIVISION_ID = @p_division_id 
					AND VERSION_NO  = @p_version_no
					AND SEND_YN IN ( 'Y','N' )
					)
			BEGIN
				SET @v_log_type = 'ACTION_TYPE_INVALID_T'
				GOTO ERR_RTN
			END

		--[E20250401-000548] SMS 선감지 대상 정리	 START
		 IF ( SELECT COUNT(1)  
			  FROM DM_PLN_SALES_ETC_REPORT_C
			  WHERE DIVISION_ID = @p_division_id
			  AND VERSION_NO = @p_version_no
			  AND DEPT_NAME IS NULL) > 0
			BEGIN
				SET @v_log_type = 'DEPT_NAME INVALID'
				GOTO ERR_RTN
			END
		--[E20250401-000548] SMS 선감지 대상 정리	 END
		----------------------------------------------------------------------------------------------------- 
		-- Validation (END)
		-----------------------------------------------------------------------------------------------------
        
		----------------------------------------------------------------------------------------------------- 
		--                                             전송준비 및 매출/사업계획 리포트 데이터 생성 (BEGIN)
		-----------------------------------------------------------------------------------------------------
		BEGIN
            -- 발송플래그 업데이트
		    UPDATE DM_MDF_VERSION
               SET SEND_YN = CASE WHEN @p_action_type = 'T' THEN 'Y' ELSE 'C' END     -- 초기는 N, 완료되면 Y, 취소되면 C, 삭제되면 D
                 , LAST_UPDATED_BY = @p_created_by
                 , LAST_UPDATE_DATE = GETDATE()
             WHERE DIVISION_ID = @p_division_id 
		       AND VERSION_NO  = @p_version_no
            ;

			IF ( @p_division_id = '40' ) -- 소형일 때만 적용
			BEGIN
				 delete from dm_pln_sales_plan_report_c where division_id = @p_division_id and version_no = @p_version_no and Data_Type = '2'

				insert into dm_pln_sales_plan_report_c ( data_type,DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,DEPARTMENT_ID,DEPARTMENT_Name,DEPT_ID,DEPT_name,END_CUST_REPORT
					,CUST_REPORT,PRODUCT_GROUP,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY,CREATED_BY
					,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7
					,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,COMPANY_ID,PROJECT_CODE
					, APPLICATION, APPLICATION_GR, COMPANY_NAME, COUNTRY_KR_NAME, CUST_GROUP_DTL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, NICK_NAME
					, OWNER_NAME, PRODUCT_DETAILS, ROUTE
					, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_MODEL, SOLDTO_CUST_REPORT
					, CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청							
				 )
				select '2' AS data_type,DIVISION_ID,VERSION_NO, 'REPORT_SP_W_E' AS CUTOFF_TYPE,CUTOFF_YYYYMMDD,DEPARTMENT_ID, DEPARTMENT_Name,DEPT_ID, DEPT_name,END_CUST_REPORT
					,CUST_REPORT,PRODUCT_GROUP,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY,CREATED_BY
					,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE, PRODUCT_DETAILS as ATTRIBUTE1, ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7
					,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,COMPANY_ID,PROJECT_CODE
					, APPLICATION, APPLICATION_GR, COMPANY_NAME, DBO.FN_GET_COUNTRY_KR_NAME(COUNTRY_CODE) AS COUNTRY_KR_NAME, CUST_GROUP_DTL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, NICK_NAME
					, OWNER_NAME, PRODUCT_DETAILS, ROUTE
					, BIZ_TYPE, case when ATTRIBUTE2 <> '' then ATTRIBUTE2 else CELL_MODEL_INFO end as CELL_MODEL_INFO, SOLDTO_CUST_REPORT
					, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청							
				from DM_PLN_SALES_ETC_REPORT_C
				where division_id = @p_division_id
					and version_no = @p_version_no

				EXEC DMF0044_SALES_REPORT_PRODUCT_CREATE @p_division_id, @p_version_no, @p_action_type, @yyyy;

				EXEC DMF0044_SALES_REPORT_DEPT_CREATE @p_division_id, @p_version_no, @p_action_type, @yyyy;

				EXEC DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE @p_division_id, @p_version_no, @p_action_type, @yyyy;

			END

		END

		----------------------------------------------------------------------------------------------------- 
		--                                               전송준비 및 매출/사업계획 리포트 데이터 생성 (END)
		-----------------------------------------------------------------------------------------------------

    COMMIT WORK;
	---------------------------------------------------------------------------------------------------------------------------	
	END TRY
	---------------------------------------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
	BEGIN CATCH
	--------------------------------------------------------------	
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION;
		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/		

		--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
		--[C20200909-000203] LOG 표준화 적용
		--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
		

	--------------------------------------------------------------	
	END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
		IF @v_log_message IS NULL
		SELECT 'success'
	;

	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
	SET @d_event_date = SYSDATETIME();

	--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
	--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	

	ERR_RTN:
	IF @v_log_type = 'DIVISION_INVALID'
		BEGIN
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
			ROLLBACK TRANSACTION;
			SET @v_log_message = N'TEAM정보가 존재하지 않아 저장할 수 없습니다.';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();			
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_CREATED_BY;	
			SELECT N'TEAM정보가 존재하지 않아 저장할 수 없습니다.'

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











