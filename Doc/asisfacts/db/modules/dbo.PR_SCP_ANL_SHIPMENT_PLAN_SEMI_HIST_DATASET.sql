


/*
 * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_SEMI_HIST_DATASET
 * Description  : Shipment Plan SEMI History 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019.05.27	YHW				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2019.07.22	YHW				[CSR ID:4053788] 자체개선 - Tact TIme Except 입력 날짜 Validation 추가 외 3건
 *                              -> 오류선조치 - qty INT 캐스팅 오류 수정
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_SEMI_HIST_DATASET]
	@SCP0010			AS DBO.SCP0010       READONLY
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_SHIPMENT_PLAN_SEMI_HIST_DATASET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

			BEGIN    

				INSERT	INTO  SCP_ANL_SHIPMENT_PLAN_SEMI_H (
					[HISTORY_SEQ]
					,[DIVISION_ID]
					,[PLAN_START_YYYYMMDD]
					,[PLAN_TYPE]
					,[SEQ]
					,[OPERATION_GROUP]
					,[ITEM_ID]
					,[FROM_SITE]
					,[TO_SITE]
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
					(NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_SEMI_H) ,
					p_division_id			 ,
					p_plan_start_yyyymmdd	 ,
					p_plan_type			 ,
					p_seq					 ,
					p_operation_group		 ,
					p_item_id				 ,
					p_from_site			 ,
					p_to_site				 ,
					p_bod_id				 ,
					p_measure				 ,
					p_yyyymmdd				 ,
					--cast(p_qty as int)					 ,
					cast(round (cast(p_qty as numeric(20,10)), 0 ,1) as int),
					p_origin_from_division_id	,
					p_origin_to_division_id	,
					p_electrode_type			,
					p_created_by			 ,
					SYSDATETIME()			 ,
					p_last_updated_by		 ,
					SYSDATETIME() ,
					SYSDATETIME()
				FROM @SCP0010

			END
	END;



