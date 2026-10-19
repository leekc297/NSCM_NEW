

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : PR_DM_MST_EXCHANGE_RATE_CUTOFF
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date          In Charge          Description
 *===================================================================================================
 * 20180806 KHSONG Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2021.06.04		HWI1993		[PJ20209642R][C20210528-000439] Sales Price>Exchange Rate 관련의 건
 * 2022.04.05   hwi1993     GM JV 작업
 */

CREATE PROCEDURE [dbo].[PR_DM_MST_EXCHANGE_RATE_CUTOFF]
	  @p_division_id			  NVARCHAR(30)    -- division_id 전달받음
	, @p_ver_type				  NVARCHAR(MAX)  -- Sales Plan Weekly Cutoff Version Type
	, @p_created_by				  NVARCHAR(MAX)  -- 
	, @sales_plan_ver_return_no	  NVARCHAR(MAX)  -- Sales Plan Weekly Cutoff Version No
AS

BEGIN
    SET NOCOUNT ON; 
    DECLARE @v_program_name		NVARCHAR(150) = 'PR_DM_MST_EXCHANGE_RATE_CUTOFF';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;
	DECLARE	@v_ver_return_no	NVARCHAR(100);	-- cut off Generated Number	
	DECLARE	@v_OK_description	NVARCHAR(1200);	-- cut off Generated Number	

		-- 시작 LOG  (START)
		SET @v_log_type		= 'START';
		SET @v_log_message	= '########## Start of procedure ##########';
		SET @v_description	= '';
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		SET @v_log_message	= NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION PR_DM_MST_EXCHANGE_RATE_CUTOFF;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

 		/* CUTOFF DATA INSERT */
		BEGIN

		/* 20180726 version 추출 필요없음 주석처리
			-- version no 추출
			EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]
					 @p_division_id
					,@p_version_description
					,@p_ver_type
					,@p_created_by
					,@v_ver_return_no  OUTPUT
					,@v_OK_description OUTPUT
		*/			
			-- insert전 중복체크후 삭제
			DELETE FROM [dbo].DM_MST_EXCHANGE_RATE_C 
						WHERE DIVISION_ID = @p_division_id
						  AND VERSION_NO  = @sales_plan_ver_return_no
						  AND CUTOFF_TYPE = @p_ver_type

			-- insert 작업
			INSERT INTO [dbo].DM_MST_EXCHANGE_RATE_C 
			(
				DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,YYYYMMDD,CURRENCY,UNIT_CURRENCY
				,EXCHANGE_PRICE,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1
				,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
			)
			SELECT 
				 @p_division_id
				,@sales_plan_ver_return_no  -- sales plan Weekly Cufoff에서 수행된 version no 를 저장  20180726
				,@p_ver_type AS CUTOFF_TYPE
				,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS CUTOFF_YYYYMMDD
				,YYYYMMDD
				,CURRENCY
				,UNIT_CURRENCY
				,EXCHANGE_PRICE
				,CREATED_BY
				,CREATION_DATE
				,@p_created_by AS LAST_UPDATED_BY
				,GETDATE()
				,ATTRIBUTE1
				,ATTRIBUTE2
				,ATTRIBUTE3
				,ATTRIBUTE4
				,ATTRIBUTE5
				,ATTRIBUTE6
				,ATTRIBUTE7
				,ATTRIBUTE8
				,ATTRIBUTE9
				,ATTRIBUTE10
			FROM [dbo].DM_MST_EXCHANGE_RATE WITH(NOLOCK) 
			WHERE DIVISION_ID = @p_division_id
				--[PJ20209642R] GSCM에서 관리중인 환율만 조회 Currency = 'KRW', Unit_Currency IN ( 'RMB', 'USD', 'EUR', 'JPY', 'AUD' ))
				AND CURRENCY = 'KRW'
				AND UNIT_CURRENCY IN ( SELECT SEGMENT1
										FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
										WHERE LOOKUP_TYPE = 'DMF0020_CURRENCY'
											AND VALID_YN = 'Y'
								)
		END
	
	-- 트랜잭션 (COMMIT)
		COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		-- ROLLBACK
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION PR_DM_MST_EXCHANGE_RATE_CUTOFF;

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	--END LOG
	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
		SELECT 'success'

    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

