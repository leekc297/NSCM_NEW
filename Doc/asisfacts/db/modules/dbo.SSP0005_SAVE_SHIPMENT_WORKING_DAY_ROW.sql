/*
 * Program ID   : SSP0005_SAVE_SHIPMENT_WORKING_DAY
 * Description  : SHIPMENT_WORKING_DAY 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/25   ygkim   Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/05/29   ygkim			create date, last update date 시간 변경
 *
 */
CREATE PROCEDURE [dbo].[SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW]
	 @p_active_flag 	 NVARCHAR(MAX)
	,@p_division_id      NVARCHAR(MAX)
	,@p_company_id	     NVARCHAR(MAX)
	,@p_yyyymmdd         NVARCHAR(MAX)
	,@p_workday_yn		 NVARCHAR(MAX)
	,@p_last_updated_by  NVARCHAR(MAX)
	,@p_time_zone		 NVARCHAR(MAX)
	,@debug_mode         NVARCHAR(1) ='F'
	,@p_first_row		 NVARCHAR(MAX)
	,@p_last_row		 NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	DECLARE @v_creation_date		datetime

	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	SET @v_creation_date    = SYSDATETIME();--[dbo].[FN_MULTY_TIME](@p_time_zone); 

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작

	BEGIN TRY

		--PRINT '1';

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		IF @p_first_row = 'Y'
			BEGIN
				EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			END

		BEGIN		
			-- 수정
			UPDATE SSP_MST_SHIP_CALENDAR
				SET workday_yn = @p_workday_yn
					,last_updated_by	  = @p_last_updated_by
					,last_update_date	  = @v_creation_date 
			WHERE division_id = @p_division_id
				AND company_id = @p_company_id
				AND yyyymmdd = @p_yyyymmdd;
		END  -- 

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		IF @p_last_row = 'Y'
			BEGIN
				EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;		
			END	
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

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
