

/*
 * Program ID   : PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST
 * Description  : Shipment Semi Dept Day History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.10.05   hwyoon			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST]
	@p_division_id			NVARCHAR(MAX),
	@p_item_id 				NVARCHAR(MAX),
	@p_departure_day		NVARCHAR(MAX),
	@p_valid_yn				NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX),
	@p_creation_date		NVARCHAR(MAX),
	@p_last_updated_by		NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	BEGIN    
		SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H

		INSERT	INTO  SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H (									   
						HISTORY_SEQ, DIVISION_ID, ITEM_ID, DEPARTURE_DAY, VALID_YN 
						,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, HISTORY_CREATION_DATE)
		VALUES  
					(
					 @n_history_seq, @p_division_id ,@p_item_id,@p_departure_day,@p_valid_yn
					,@p_created_by, @p_creation_date, @p_last_updated_by, SYSDATETIME(), SYSDATETIME()
					);
	END

			
END;







