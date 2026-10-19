


/*
 * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_HIST_DATASET
 * Description  : Production Plan History 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019.01.22   HWYOON			[CSR ID:3913598] GSCM 시스템 속도 향상 요청 건 (production plan line 수정 / 저장 속도)
 * 2019.06.07	HWYOON			[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_HIST_DATASET]
	@SCP0013			AS DBO.SCP0013       READONLY
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_PRODUCTION_PLAN_HIST_DATASET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		--BEGIN TRY

			BEGIN    
					--SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H

					INSERT	INTO  SCP_ANL_PRODUCTION_PLAN_H(									   
								  history_seq,division_id,plan_start_yyyymmdd,plan_type,seq,operation_group
								, scm_site_id,item_id,line_id,operation_id,measure,yyyymmdd,qty
								, origin_division_id, electrode_type
								, created_by,creation_date,last_updated_by,last_update_date, history_creation_date)
					SELECT (NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H), p_division_id, p_plan_start_yyyymmdd, p_plan_type,  p_seq, p_operation_group
								, p_scm_site_id, p_item_id, p_line_id, p_operation_id, p_measure, p_yyyymmdd, p_qty
								, p_origin_division_id, p_electrode_type
								, p_user_id, SYSDATETIME(), [p_user_id], SYSDATETIME(), SYSDATETIME()
					FROM @SCP0013
					/*
				   BEGIN
					INSERT	INTO  SCP_ANL_PRODUCTION_PLAN_H(									   
								  history_seq,division_id,plan_start_yyyymmdd,plan_type,seq,operation_group
								, scm_site_id,item_id,line_id,operation_id,measure,yyyymmdd,qty
								, origin_division_id, electrode_type
								, created_by,creation_date,last_updated_by,last_update_date, history_creation_date)
					VALUES  
								(
								  @n_history_seq,@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq,@p_operation_group
								, @p_scm_site_id,@p_item_id,@p_line_id,@p_operation_id,@p_measure,@p_yyyymmdd,@p_qty
								, @p_origin_division_id, @p_electrode_type
								, @p_created_by,@p_creation_date,@p_last_updated_by,SYSDATETIME(),SYSDATETIME()
								);
				   END
				   */
			END

	END;







