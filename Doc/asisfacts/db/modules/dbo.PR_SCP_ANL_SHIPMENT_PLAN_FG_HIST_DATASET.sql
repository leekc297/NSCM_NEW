


/*
 * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_FG_HIST_DATASET
 * Description  : Shipment Plan FG History
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/05/20   HWYOON			[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2019/07/22	HWYOON			오류선조치 - qty INT 캐스팅 오류 수정
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_FG_HIST_DATASET]
	@SCP0009			AS DBO.SCP0009       READONLY
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	BEGIN    
		INSERT INTO [dbo].[SCP_ANL_SHIPMENT_PLAN_FG_H]
			([HISTORY_SEQ]
			,[DIVISION_ID]
			,[PLAN_START_YYYYMMDD]
			,[PLAN_TYPE]
			,[SEQ]
			,[BIZ_TYPE]
			,[PROJECT_CODE]
			,[ITEM_ID]
			,[TO_SITE]
			,[INCOTERMS]
			,[FROM_SITE]
			,[BOD_ID]
			,[MEASURE]
			,[YYYYMMDD]
			,[QTY]
			,[ORIGIN_FROM_DIVISION_ID]
			,[ORIGIN_TO_DIVISION_ID]
			,[ELECTRODE_TYPE]
			,[CREATED_BY]
			,[CREATION_DATE]
			,[LAST_UPDATED_BY]
			,[LAST_UPDATE_DATE]
			,[HISTORY_CREATION_DATE])
		SELECT 
			(NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H)	,
			p_division_id			,
			p_plan_start_yyyymmdd	,
			p_plan_type			,
			p_seq					,
			p_biz_type				,
			p_project_code			,
			p_item_id				,
			p_to_site				,
			p_incoterms			,
			p_from_site			,
			p_bod_id				,
			p_measure				,
			p_yyyymmdd				,
			--cast(p_qty as int) ,
			cast(round (cast(p_qty as numeric(20,10)), 0 ,1) as int) ,
			p_origin_from_division_id	,
			p_origin_to_division_id	,
			p_electrode_type		,
			p_created_by			,
			SYSDATETIME()	,
			p_last_updated_by		,
			SYSDATETIME()	,
			SYSDATETIME()
		FROM @SCP0009

	END

END;

