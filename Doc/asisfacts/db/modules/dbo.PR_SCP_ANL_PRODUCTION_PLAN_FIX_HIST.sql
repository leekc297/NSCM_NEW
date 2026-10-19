/*
 * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST
 * Description  : Production Plan Fix History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/17   PJS             Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/18	YHW				전극용 데이터 저장 추가
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST]
	@p_fix_id				NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_operation_group		NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_item_id				NVARCHAR(MAX),
	@p_line_id				NVARCHAR(MAX),
	@p_operation_id			NVARCHAR(MAX),
	@p_yyyymmdd				NVARCHAR(MAX),
	@p_qty					NVARCHAR(MAX),
	@p_fix_reason			NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX),
	@p_creation_date		DATETIME,
	@p_last_updated_by		NVARCHAR(MAX),
	@p_origin_division_id	NVARCHAR(MAX)='',
	@p_electrode_type		NVARCHAR(MAX)=''

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
		BEGIN    
			SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H

			BEGIN
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

			END
		END

	END;

