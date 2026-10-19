


/*
 * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST_DATASET
 * Description  : SHIPMENT PLAN FG FIX History 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/06/07   HWYOON			[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2019/07/22	HWYOON			[CSR ID:4053788] 자체개선 - Tact TIme Except 입력 날짜 Validation 추가 외 3건
 *                              -> 오류선조치 - qty INT 캐스팅 오류 수정
 * 2019.09.03	HWYOON			[CSR ID:4071705] Production Plan Fix에서 Unfix 기능 추가 - I/M/D FLAG 추가
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST_DATASET]
	@SCP0009			AS DBO.SCP0009       READONLY
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
				, A.FIX_ID
				,B.p_division_id 
				,B.p_biz_type 
				,B.p_item_id
				,B.p_to_site
				,B.p_from_site
				,B.p_project_code
				,B.p_incoterms
				,B.p_bod_id
				,B.p_yyyymmdd
				--,cast(B.p_qty as int)
				,cast(round (cast(B.p_qty as numeric(20,10)), 0 ,1) as int)
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
		FROM SCP_ANL_SHIPMENT_PLAN_FIX A, @SCP0009 B
		WHERE A.division_id				= B.p_division_id
		and A.BIZ_TYPE					= B.p_biz_type
		and A.ITEM_ID					= B.p_item_id
		and A.TO_SITE					= B.p_to_site
		and A.FROM_SITE					= B.p_from_site
		and A.PROJECT_CODE				= B.p_project_code
		and A.INCOTERMS					= B.p_incoterms
		and A.BOD_ID					= B.p_bod_id
		and A.yyyymmdd					= B.p_yyyymmdd
		AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
		AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
		AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(B.p_electrode_type,''),'-')
	END

END;

