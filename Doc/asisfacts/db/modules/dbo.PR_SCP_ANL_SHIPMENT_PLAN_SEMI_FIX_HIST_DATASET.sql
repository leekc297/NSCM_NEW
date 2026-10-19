


/*
 * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET
 * Description  : SHIPMENT PLAN SEMI FIX History 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/05/27   YHW             [CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2019.09.03	HWYOON			[CSR ID:4071705] Production Plan Fix에서 Unfix 기능 추가 - I/M/D FLAG 추가
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET]
	@SCP0010			AS DBO.SCP0010       READONLY
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

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
			history_creation_date,
			ATTRIBUTE1)
		SELECT (NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H)
				,A.FIX_ID
				,B.p_division_id 
				,B.p_biz_type 
				,B.p_item_id
				,B.p_to_site
				,B.p_from_site
				,NULL
				,NULL
				,B.p_bod_id
				,B.p_yyyymmdd
				,B.p_qty
				,B.p_origin_from_division_id
				,B.p_origin_to_division_id
				,B.p_electrode_type
				,A.fix_reason
				,B.p_created_by
				,SYSDATETIME()
				,B.p_last_updated_by
				,SYSDATETIME()
				,SYSDATETIME()
				,ISNULL(B.p_active_flag,'')
		FROM SCP_ANL_SHIPMENT_PLAN_FIX A, @SCP0010 B
		WHERE A.division_id				= B.p_division_id
		and A.BIZ_TYPE					= B.p_biz_type
		and A.ITEM_ID					= B.p_item_id
		and A.TO_SITE					= B.p_to_site
		and A.FROM_SITE					= B.p_from_site
		and A.BOD_ID					= B.p_bod_id
		and A.yyyymmdd					= B.p_yyyymmdd
		and A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
		and A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
		and ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')	= ISNULL(NULLIF(B.p_electrode_type,''),'-')
		;

	END

END;

