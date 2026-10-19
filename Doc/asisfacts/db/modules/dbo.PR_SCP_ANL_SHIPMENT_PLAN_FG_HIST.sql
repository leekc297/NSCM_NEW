
/*
 * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_FG_HIST
 * Description  : Shipment Plan FG History
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018.03.13   byunghunjung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/19	KYH				신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE) 
 */
CREATE PROCEDURE [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_FG_HIST]
	 @p_division_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd		NVARCHAR(MAX)
	,@p_plan_type				NVARCHAR(MAX)
	,@p_seq						NVARCHAR(MAX)
	,@p_biz_type				NVARCHAR(MAX)
	,@p_project_code			NVARCHAR(MAX)
	,@p_item_id					NVARCHAR(MAX)
	,@p_to_site					NVARCHAR(MAX)
	,@p_incoterms				NVARCHAR(MAX)
	,@p_from_site				NVARCHAR(MAX)
	,@p_bod_id					NVARCHAR(MAX)
	,@p_measure					NVARCHAR(MAX)
	,@p_yyyymmdd				NVARCHAR(MAX)
	,@p_qty						int
	,@p_origin_from_division_id		NVARCHAR(MAX)
	,@p_origin_to_division_id		NVARCHAR(MAX)
	,@p_electrode_type			NVARCHAR(MAX)
	,@p_created_by				NVARCHAR(150) 
	,@p_last_updated_by			NVARCHAR(150)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_SHIPMENT_PLAN_FG_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	BEGIN    
		SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H

		BEGIN
		INSERT INTO [dbo].[SCP_ANL_SHIPMENT_PLAN_FG_H]
			([HISTORY_SEQ]
			, [DIVISION_ID]
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
		VALUES  (
			@n_history_seq	,
			@p_division_id			,
			@p_plan_start_yyyymmdd	,
			@p_plan_type			,
			@p_seq					,
			@p_biz_type				,
			@p_project_code			,
			@p_item_id				,
			@p_to_site				,
			@p_incoterms			,
			@p_from_site			,
			@p_bod_id				,
			@p_measure				,
			@p_yyyymmdd				,
			@p_qty ,
			@p_origin_from_division_id	,
			@p_origin_to_division_id	,
			@p_electrode_type		,
			@p_created_by			,
			SYSDATETIME()	,
			@p_last_updated_by		,
			SYSDATETIME()	,
			SYSDATETIME()
		);
		END
	END
END;
