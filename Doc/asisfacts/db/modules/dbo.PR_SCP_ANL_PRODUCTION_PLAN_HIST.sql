/*
 * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_HIST
 * Description  : Production Plan History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.12   byunghunjung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.18	YHW				전극용 데이터 저장 추가
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_HIST]

@p_division_id			NVARCHAR(MAX),
@p_plan_start_yyyymmdd  NVARCHAR(MAX),
@p_plan_type			NVARCHAR(MAX),
@p_seq					NVARCHAR(MAX),
@p_operation_group		NVARCHAR(MAX),
@p_scm_site_id			NVARCHAR(MAX),
@p_item_id				NVARCHAR(MAX),
@p_line_id				NVARCHAR(MAX),
@p_operation_id			NVARCHAR(MAX),
@p_measure				NVARCHAR(MAX),
@p_yyyymmdd				NVARCHAR(MAX),
@p_qty					NVARCHAR(MAX),
@p_created_by			NVARCHAR(MAX),
@p_creation_date		DATETIME,
@p_last_updated_by		NVARCHAR(MAX),
@p_origin_division_id	NVARCHAR(MAX),
@p_electrode_type		NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_PRODUCTION_PLAN_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		--BEGIN TRY

			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H
				
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
			END

	END;





