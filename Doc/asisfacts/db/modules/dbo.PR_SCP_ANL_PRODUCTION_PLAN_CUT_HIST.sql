
/*
 * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_CUT_HIST
 * Description  : 매주 해당 주차 정보 HIST_SCP_ANL_SHIPMENT_PLAN_FG 로 이관
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.07.12   KSG            Initial Release PJ20209643 Digital SCM Level.3 달성을 위한 개선
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_CUT_HIST]

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_PRODUCTION_PLAN_CUT_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_plan_name    NVARCHAR(500);

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	BEGIN TRANSACTION PR_SCP_ANL_PRODPLAN_CUT_HIST;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------
		-------------------------------------------
	    -- 1. Division별 MAX(plan_seq)
		-------------------------------------------
        IF OBJECT_ID('tempdb..#plan_seq') IS NOT NULL
        BEGIN 
            DROP TABLE #plan_seq          
        END 

		SET @v_plan_name = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	-- 금주 월요일
		
        SELECT division_id, plan_start_yyyymmdd, plan_type, MAX(plan_seq) AS seq
        INTO   #plan_seq
        FROM   scp_plan_version_v WITH(NOLOCK)
        WHERE  plan_start_yyyymmdd = @v_plan_name
        AND    confirm_flag        = 'Y'
        GROUP BY division_id, plan_start_yyyymmdd, plan_type

		BEGIN	
		  
            INSERT INTO HIST_SCP_ANL_PRODUCTION_PLAN
               (division_id, plan_start_yyyymmdd, plan_type, seq
              , operation_group, scm_site_id, item_id, line_id, operation_id
              , measure, yyyymmdd, qty, origin_division_id, electrode_type 
              , created_by, creation_date, last_updated_by, last_update_date
              , attribute1, attribute2, attribute3, attribute4, attribute5
              , attribute6, attribute7, attribute8, attribute9, attribute10
              , cell_qty
               )
            SELECT a.division_id, a.plan_start_yyyymmdd, a.plan_type, a.seq
                 , a.operation_group, a.scm_site_id, a.item_id, a.line_id, a.operation_id
                 , a.measure, a.yyyymmdd, a.qty, a.origin_division_id, a.electrode_type
                 , a.created_by, a.creation_date, a.last_updated_by, a.last_update_date
                 , a.attribute1, a.attribute2, a.attribute3, a.attribute4, a.attribute5
                 , a.attribute6, a.attribute7, a.attribute8, a.attribute9, a.attribute10
                 , a.cell_qty
            FROM   SCP_ANL_PRODUCTION_PLAN a WITH(NOLOCK)
                 , #plan_seq b
            WHERE  1=1
            AND    a.division_id         = b.division_id
            AND    a.plan_start_yyyymmdd = b.plan_start_yyyymmdd
            AND    a.plan_type           = b.plan_type
            AND    a.SEQ                 = b.seq		

            SET @n_log_count = @@ROWCOUNT;		 

		END

        IF OBJECT_ID('tempdb..#plan_seq') IS NOT NULL
        BEGIN 
            DROP TABLE #plan_seq          
        END 

  	-- 트랜잭션 (COMMIT)
    COMMIT WORK;

	--------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		SET @v_log_type    = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + @v_plan_name + ' : ' + STR(ERROR_LINE());
		SET @d_event_date  = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION PR_SCP_ANL_PRODPLAN_CUT_HIST;

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @v_plan_name;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  END;
