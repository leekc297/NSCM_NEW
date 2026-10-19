




/*
 * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET
 * Description  : Production Plan History 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019.02.21   HWYOON			[CSR ID:3929450] Supply(Plan Line, FG, SEMI) 수정 시 Fix 데이터 저장로직 개선
 * 2019.06.07	HWYOON			[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2019.09.03	HWYOON			[CSR ID:4071705] Production Plan Fix에서 Unfix 기능 추가 - I/M/D FLAG 추가
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET]
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

					INSERT	INTO  SCP_ANL_PRODUCTION_PLAN_FIX_H(									   
								  history_seq,
								  fix_id,
								  division_id,
								  operation_group,
								  scm_site_id,
								  item_id,
								  line_id,
								  operation_id,
								  yyyymmdd,
								  qty,
								  fix_reason,
								  ORIGIN_DIVISION_ID,
								  ELECTRODE_TYPE,
								  created_by,
								  creation_date,
								  last_updated_by,
								  last_update_date,
								  history_creation_date,
								  ATTRIBUTE1)
					SELECT (NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H), 
							A.FIX_ID,
							B.p_division_id, 
							B.p_operation_group, 
							B.p_scm_site_id, 
							B.p_item_id,
							B.p_line_id,
							B.p_operation_id,
							B.p_yyyymmdd,
							B.p_qty,
							A.FIX_REASON,
							B.p_origin_division_id,
							B.p_electrode_type,
							B.p_user_id, 
							SYSDATETIME(), 
							B.p_user_id,	
							SYSDATETIME(),
							SYSDATETIME(),
							ISNULL(B.p_active_flag,'')
					FROM SCP_ANL_PRODUCTION_PLAN_FIX A, @SCP0013 B
					WHERE A.DIVISION_ID          = B.p_division_id          
					AND A.OPERATION_GROUP      = B.p_operation_group
					AND A.SCM_SITE_ID          = B.p_scm_site_id
					AND A.ITEM_ID              = B.p_item_id
					AND A.LINE_ID              = B.p_line_id
					AND A.OPERATION_ID         = B.p_operation_id
					AND A.YYYYMMDD             = B.p_yyyymmdd
					AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(B.p_electrode_type,''),'-')
					--AND B.p_fix='Y'
					/*
				   INSERT INTO  SCP_ANL_PRODUCTION_PLAN_FIX_H (
						history_seq,
						fix_id,
						division_id,
						operation_group,
						scm_site_id,
						item_id,
						line_id,
						operation_id,
						yyyymmdd,
						qty,
						fix_reason,
						ORIGIN_DIVISION_ID,
						ELECTRODE_TYPE,
						created_by,
						creation_date,
						last_updated_by,
						last_update_date,
						history_creation_date)
					VALUES  (
						@n_history_seq,
						@p_fix_id,
						@p_division_id, 
						@p_operation_group, 
						@p_scm_site_id, 
						@p_item_id,
						@p_line_id,
						@p_operation_id,
						@p_yyyymmdd , 
						@p_qty ,
						@p_fix_reason,
						@p_origin_division_id,
						@p_electrode_type,
						@p_created_by , 
						@p_creation_date, 
						@p_last_updated_by,	
						SYSDATETIME() ,
						SYSDATETIME() 
					);
				   */
			END

	END;









