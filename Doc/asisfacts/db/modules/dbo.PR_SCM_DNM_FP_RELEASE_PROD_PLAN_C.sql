
/*
 * Program ID   : PR_SCM_DNM_FP_RELEASE_PROD_PLAN_C
 * Description  : FP 생산 계획 Cutoff 프로시져  
				: 매주 화요일 동기화
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 4.26    Kim Jaejung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 5.15    Kim Jihye     creation_date, update_date 프로시저 수행 일자로 변경
 * 2019.07.09    KSG           [CSR ID:4034546] GSCM 계획 수립 시점 별 FP Version 조회가능 UI 개발 요청 : Plan Version 저장 작업 Call 추가
 *
 */

CREATE PROCEDURE [dbo].[PR_SCM_DNM_FP_RELEASE_PROD_PLAN_C]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_FP_RELEASE_PROD_PLAN_C';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno      NVARCHAR(30); 
	DECLARE @n_history_seq	BIGINT;
	DECLARE @basis_start_date      NVARCHAR(8);
	DECLARE @v_del_yyyymmdd        NVARCHAR(8) = '';  -- Delete 기준 일자

	SET @v_del_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7*13, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 12주 전 월요일 일자

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

		SELECT @basis_start_date = basis_yyyymmdd
		FROM   scm_sys_calendar_m cm with (nolock)
		WHERE  iso_yyyyww IN (SELECT iso_yyyyww
                              FROM   scm_sys_calendar_m with (nolock)
                              WHERE  basis_yyyymmdd = CONVERT(CHAR(8), GETDATE(), 112))
		AND    dayofweek = 'MON';

		------------------------------------------------
		-- Plan Cutoff 작업
		------------------------------------------------
		DELETE 
		FROM  scm_dnm_fp_release_prod_plan_c
		WHERE yyyymmdd = @basis_start_date;

		INSERT INTO SCM_DNM_FP_RELEASE_PROD_PLAN_C(
			   yyyymmdd
			  ,company_id
			  ,division_id
			  ,scm_site_id
			  ,plant_id
			  ,factory_id
			  ,operation_id
			  ,location
			  ,top_item_id
			  ,item_id
			  ,production_type
			  ,market
			  ,line_id
			  ,electrode_type
			  ,plan_date
			  ,plan_qty
			  ,plan_in_qty
			  ,equipment_id
			  ,created_by
			  ,creation_date
			  ,last_updated_by
			  ,last_update_date
		)
		SELECT @basis_start_date
			  ,company_id
			  ,division_id
			  ,scm_site_id
			  ,plant_id
			  ,factory_id
			  ,operation_id
			  ,location
			  ,top_item_id
			  ,item_id
			  ,fp_production_type
			  ,market
			  ,line_id
			  ,electrode_type
			  ,plan_date
			  ,plan_qty
			  ,plan_in_qty
			  ,equipment_id
			  ,@v_batch_user
			  ,getdate() -- 2018. 5. 15    Kim Jihye
			  ,@v_batch_user
			  ,getdate()
		FROM  [SCM_DNM_PLAN_FROZEN_V] WITH(NOLOCK)
		WHERE plan_date >=  CONVERT(datetime,  @basis_start_date + ' 00:00:00', 120)

	  END
    END TRY

    BEGIN CATCH
	  IF @@TRANCOUNT > 0 
        BEGIN
          ROLLBACK;
        END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10)) + ' : ' + @basis_start_date   ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

	------------------------------------------------
	-- 1. Plan Version 저장 작업 Call : 20190709 
	-- 2. 과거 정보 삭제
	--   위치 조정하지 말 것 : 오류 발생해도 Plan Cutoff 작업은 정상 종료되어야 함
	------------------------------------------------
	EXEC [dbo].[PR_SCM_MST_PLAN_FP_RELEASE_ID] @basis_start_date, NULL, NULL, NULL, 'PR', NULL;
		
    DELETE 
	FROM  scm_dnm_fp_release_prod_plan_c
	WHERE yyyymmdd < @v_del_yyyymmdd;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

