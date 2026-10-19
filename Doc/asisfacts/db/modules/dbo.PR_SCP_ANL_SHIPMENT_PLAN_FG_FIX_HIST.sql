
/*
 * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST
 * Description  : SHIPMENT PLAN FG FIX History 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/05/24   KYH             Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/19	KYH				신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE) 
 */
CREATE PROCEDURE [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST]
	@p_fix_id			NVARCHAR(MAX),
	@p_division_id		NVARCHAR(MAX),
	@p_biz_type			NVARCHAR(MAX),
	@p_item_id 			NVARCHAR(MAX),
	@p_to_site 			NVARCHAR(MAX),
	@p_from_site		NVARCHAR(MAX),
	@p_project_code		NVARCHAR(MAX),
	@p_incoterms		NVARCHAR(MAX),
	@p_bod_id			NVARCHAR(MAX),
	@p_yyyymmdd			NVARCHAR(MAX),
	@p_qty				NVARCHAR(MAX),
	@p_origin_from_division_id		NVARCHAR(MAX) ,
	@p_origin_to_division_id		NVARCHAR(MAX) ,
	@p_electrode_type	NVARCHAR(MAX) ,
	@p_fix_reason		NVARCHAR(MAX),
	@p_created_by		NVARCHAR(MAX),
	@p_creation_date	DATETIME,
	@p_last_updated_by	NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	BEGIN    
		SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H

		BEGIN
		INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H (
			history_seq,
			fix_id,
			division_id,
			BIZ_TYPE ,
			ITEM_ID ,
			TO_SITE ,
			FROM_SITE ,
			PROJECT_CODE ,
			INCOTERMS ,
			BOD_ID ,
			yyyymmdd,
			qty,
			ORIGIN_FROM_DIVISION_ID ,
			ORIGIN_TO_DIVISION_ID ,
			ELECTRODE_TYPE ,
			fix_reason,
			created_by,
			creation_date,
			last_updated_by,
			last_update_date,
			history_creation_date)
		VALUES  (
			@n_history_seq,
			@p_fix_id,
			@p_division_id, 
			@p_biz_type, 
			@p_item_id,
			@p_to_site,
			@p_from_site,
			@p_project_code,
			@p_incoterms ,
			@p_bod_id ,
			@p_yyyymmdd , 
			@p_qty ,
			@p_origin_from_division_id ,
			@p_origin_to_division_id ,
			@p_electrode_type ,
			@p_fix_reason,
			@p_created_by , 
			@p_creation_date, 
			@p_last_updated_by,	
			SYSDATETIME() ,
			SYSDATETIME() 
		);

		END
	END

	END;


