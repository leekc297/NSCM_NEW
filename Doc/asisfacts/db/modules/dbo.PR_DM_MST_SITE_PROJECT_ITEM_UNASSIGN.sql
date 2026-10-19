
/*
 * Program ID   : PR_DM_MST_SITE_PROJECT_ITEM_UNASSIGN
 * Description  : PR_DM_MST_SITE_PROJECT_ITEM_UNASSIGN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 1.     DWOK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_MST_SITE_PROJECT_ITEM_UNASSIGN] 
	@p_division_id			NVARCHAR(MAX),
	@p_project_code			NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)

AS

BEGIN

	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_project_code			NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);

	SET @v_division_id		 = NULL;	
	SET @v_project_code		 = NULL;	
	SET @v_created_by		 = NULL;	

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	---- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_SITE_PROJECT_ITEM_UNASSIGN';
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
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--	 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION PROJECT_ITEM_UNASSIGN;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

	BEGIN
		SET @v_division_id = @p_division_id;
		--SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
		SELECT @v_division_id;

		SET @v_project_code = @p_project_code; 
		--SET @v_project_code = [dbo].[SCM_ARR_SPL_VAL](@p_project_code, @v_delimiter , @mst_loop_cnt) ; 
		SELECT @v_project_code;
	
		SET @v_created_by = @p_created_by;
		--SET @v_created_by = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter, @mst_loop_cnt) ; 
		SELECT @v_created_by
	END

	BEGIN			
		UPDATE
			[dbo].[SCM_MST_SITE_ITEM] 	
			SET	[BPMS_EXIST] = 'N' , 
				[LAST_UPDATED_BY] = @v_created_by,
				[LAST_UPDATE_DATE] = sysdatetime()
		FROM 
		(
			SELECT 
				[DIVISION_ID],
				[PROJECT_CODE],
				MAX([PROJECT_VER_SEQ])	AS PROJECT_VER_SEQ,
				[ITEM_ID],
				[ITEM_TYPE],
				[VALID_YN]
			FROM 
				[dbo].[SCM_MST_PROJECT_ITEM]	WITH  (NOLOCK) 
			WHERE 1 = 1
				AND [VALID_YN] = 'N'
				AND [PROJECT_CODE] = @v_project_code
				AND [DIVISION_ID] = @v_division_id
			GROUP BY
				[DIVISION_ID],
				[PROJECT_CODE],
				[ITEM_ID],
				[ITEM_TYPE],
				[VALID_YN]
			--ORDER BY [PROJECT_VER_SEQ]
		) PR
		WHERE
			PR.[DIVISION_ID] = [dbo].[SCM_MST_SITE_ITEM].[DIVISION_ID] AND
			PR.[PROJECT_CODE] = [dbo].[SCM_MST_SITE_ITEM].[PROJECT_CODE] AND
			PR.[ITEM_ID] = [dbo].[SCM_MST_SITE_ITEM].[ITEM_ID] 
		;

	END			

		COMMIT WORK;

	END TRY	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION  PROJECT_ITEM_UNASSIGN;

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
		
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
    IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;











