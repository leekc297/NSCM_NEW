
/*
 * Program ID   : PR_SCP_ANL_PLAN_N
 * Description  : 매주 해당 주차 정보를 최신 Plan 정보로 이관
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.07.19   KSG            Initial Release PJ20209643 Digital SCM Level.3 달성을 위한 개선(Phase2)
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_ANL_PLAN_N]
    ( @p_division_id          NVARCHAR(30)
    , @p_plan_start_yyyymmdd  NVARCHAR(8)
    , @p_seq                  NVARCHAR(4000)
    -- , @p_debug       INT OUTPUT
) 

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_PLAN_N';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_division_id  NVARCHAR(500);
    DECLARE @v_plan_name    NVARCHAR(500);
    DECLARE @v_plan_type    NVARCHAR(500);
    DECLARE @v_plan_seq     NVARCHAR(500);

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	BEGIN TRANSACTION PR_SCP_ANL_PLAN_N;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------
		-------------------------------------------
	    -- 1. Division별 MAX(plan_seq)
		-------------------------------------------								 
        SET @v_division_id = @p_division_id;
        SET @v_plan_name   = @p_plan_start_yyyymmdd;
        SET @v_plan_type   = 'FN';
        SET @v_plan_seq    = @p_seq;

		BEGIN	
			--------------------------------------------------
			-- 1. Shipment Plan FG
			--------------------------------------------------
			DELETE scp_anl_shipment_plan_fg_n
            WHERE  1=1
            AND    division_id  = @v_division_id
            AND    yyyymmdd    >= @v_plan_name;

            INSERT INTO scp_anl_shipment_plan_fg_n
                (  division_id, a.plan_start_yyyymmdd, plan_type, seq, biz_type, project_code, item_id
                 , to_site, incoterms, from_site, bod_id, measure, yyyymmdd, qty, origin_from_division_id, origin_to_division_id, electrode_type
                 , created_by, creation_date, last_updated_by, last_update_date
                 , attribute1, attribute2, attribute3, attribute4, attribute5
                 , attribute6, attribute7, attribute8, attribute9, attribute10
                )
            SELECT a.division_id, a.plan_start_yyyymmdd, a.plan_type, a.seq, biz_type, project_code, item_id
                 , to_site, incoterms, from_site, bod_id, measure, yyyymmdd, qty, origin_from_division_id, origin_to_division_id, electrode_type
                 , created_by, creation_date, last_updated_by, last_update_date
                 , attribute1, attribute2, attribute3, attribute4, attribute5
                 , attribute6, attribute7, attribute8, attribute9, attribute10
            FROM   scp_anl_shipment_plan_fg a WITH(NOLOCK)
            WHERE  1=1
            AND    a.division_id         = @v_division_id
            AND    a.plan_start_yyyymmdd = @v_plan_name
            AND    a.plan_type           = @v_plan_type
            AND    a.seq                 = @v_plan_seq
            AND    a.measure             = 'SHIP_PLAN_AMEND'
            AND    a.qty                 > 0
			
            -- 종료 LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'TXN';
            SET @v_log_message = '1. Shipment Plan FG';
            SET @v_description = ISNULL(@p_division_id, 'ALL') + ' : ' + @v_plan_name;
            SET @d_event_date = SYSDATETIME();

			--------------------------------------------------
			-- 2. Shipment Plan SEMI
			--------------------------------------------------
			DELETE scp_anl_shipment_plan_semi_n
            WHERE  1=1
            AND    division_id  = @v_division_id
            AND    yyyymmdd    >= @v_plan_name;

            INSERT INTO scp_anl_shipment_plan_semi_n
                (  division_id, plan_start_yyyymmdd, plan_type, seq
                 , operation_group, item_id, from_site, bod_id, measure, yyyymmdd
                 , to_site, qty, origin_from_division_id, electrode_type
                 , created_by, creation_date, last_updated_by, last_update_date
                 , attribute1, attribute2, attribute3, attribute4, attribute5
                 , attribute6, attribute7, attribute8, attribute9, attribute10
                )
            SELECT a.division_id, a.plan_start_yyyymmdd, a.plan_type, a.seq
                 , operation_group, item_id, from_site, bod_id, measure, yyyymmdd
                 , to_site, qty, origin_from_division_id, electrode_type
                 , created_by, creation_date, last_updated_by, last_update_date
                 , attribute1, attribute2, attribute3, attribute4, attribute5
                 , attribute6, attribute7, attribute8, attribute9, attribute10
            FROM   scp_anl_shipment_plan_semi a WITH(NOLOCK)
            WHERE  1=1
            AND    a.division_id         = @v_division_id
            AND    a.plan_start_yyyymmdd = @v_plan_name
            AND    a.plan_type           = @v_plan_type
            AND    a.seq                 = @v_plan_seq
            AND    a.measure             = 'SHIP_PLAN_AMEND'
            AND    a.qty                 > 0
			
            -- 종료 LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'TXN';
            SET @v_log_message = '2. Shipment Plan SEMI';
            SET @v_description = ISNULL(@p_division_id, 'ALL') + ' : ' + @v_plan_name;
            SET @d_event_date = SYSDATETIME();

			--------------------------------------------------
			-- 3. Production Plan
			--------------------------------------------------
			DELETE scp_anl_production_plan_n
            WHERE  1=1
            AND    division_id  = @v_division_id
            AND    yyyymmdd    >= @v_plan_name;

            INSERT INTO scp_anl_production_plan_n
                (  division_id, plan_start_yyyymmdd, plan_type, seq
                 , operation_group, scm_site_id, item_id, line_id, operation_id
                 , measure, yyyymmdd, qty, origin_division_id, electrode_type 
                 , created_by, creation_date, last_updated_by, last_update_date
                 , attribute1, attribute2, attribute3, attribute4, attribute5
                 , attribute6, attribute7, attribute8, attribute9, attribute10
                 , cell_qty
                )
            SELECT a.division_id, a.plan_start_yyyymmdd, a.plan_type, a.seq
                 , operation_group, scm_site_id, item_id, line_id, operation_id
                 , measure, yyyymmdd, qty, origin_division_id, electrode_type 
                 , created_by, creation_date, last_updated_by, last_update_date
                 , attribute1, attribute2, attribute3, attribute4, attribute5
                 , attribute6, attribute7, attribute8, attribute9, attribute10
                 , cell_qty
            FROM   scp_anl_production_plan a WITH(NOLOCK)
            WHERE  1=1
            AND    a.division_id         = @v_division_id
            AND    a.plan_start_yyyymmdd = @v_plan_name
            AND    a.plan_type           = @v_plan_type
            AND    a.seq                 = @v_plan_seq
            AND    a.measure             = 'PROD_PLAN_AMEND'
            AND    a.qty                 > 0
			
            -- 종료 LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'TXN';
            SET @v_log_message = '3. Production Plan';
            SET @v_description = ISNULL(@p_division_id, 'ALL') + ' : ' + @v_plan_name;
            SET @d_event_date = SYSDATETIME();

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
		ROLLBACK TRANSACTION PR_SCP_ANL_PLAN_N;

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        return -1 
	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = ISNULL(@p_division_id, 'ALL') + ' : ' + @v_plan_name;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1 
  END;
