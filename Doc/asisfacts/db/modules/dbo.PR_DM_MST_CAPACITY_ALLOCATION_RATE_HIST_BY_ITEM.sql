



/*
 * Program ID   : PR_DM_MST_CAPACITY_ALLOCATION_RATE_HIST_BY_ITEM
 * Description  : Capacity Allodation Rate item별 히스토리 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/08/29	YHW				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 */

CREATE PROCEDURE [dbo].[PR_DM_MST_CAPACITY_ALLOCATION_RATE_HIST_BY_ITEM]

	@p_division_id			NVARCHAR(2),
	@p_item_id				NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX),
	@p_creation_date		DATETIME,
	@p_last_updated_by		NVARCHAR(MAX)
		
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_CAPACITY_ALLOCATION_RATE_HIST_BY_ITEM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	BEGIN TRY --[C20200909-000203] LOG 표준화 적용
	BEGIN    
				
		INSERT INTO DM_MST_CAPACITY_ALLOCATION_H
		(HISTORY_SEQ
		, DIVISION_ID
		, ITEM_ID
		, END_CUSTOMER
		, SCM_SITE_ID
		, YYYYMM
		, CAPACITY_RATE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
		SELECT NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_H history_seq
				, DIVISION_ID
				, ITEM_ID
				, END_CUSTOMER
				, SCM_SITE_ID
				, YYYYMM
				, CAPACITY_RATE
				, @p_created_by
				, @p_creation_date
				, @p_created_by
				, SYSDATETIME()
		FROM DM_MST_CAPACITY_ALLOCATION
		WHERE DIVISION_ID = @p_division_id
		AND ITEM_ID=@p_item_id

	END
	
	END TRY --[C20200909-000203] LOG 표준화 적용
	--------------------------------------------------------------	
    BEGIN CATCH --[C20200909-000203] LOG 표준화 적용
	--------------------------------------------------------------	

      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;




