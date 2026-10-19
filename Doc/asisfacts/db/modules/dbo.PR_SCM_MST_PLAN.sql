
/*
 * Program ID   : PR_SCM_MST_PLAN
 * Description  : PLAN ID Create 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.21   Kim SungGi     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020.10.15   KIM BOK KI     @p_plan_cycle = 'DAILY' 의 실행 일자 처리 GETDATE() - 1 => GETDATE() 로 변경 
 * 2023.10.17   KSG            PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase : 도전과제 계획 Plan End Date 지정
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_PLAN]
  @p_plan_cycle  NVARCHAR(150) = 'WEEKLY'
 ,@p_plan_name   NVARCHAR(8)   = ''
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_PLAN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME; 

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '[PR_SCM_MST_PLAN]' + ':' + @p_plan_cycle;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
		
        -----------------------------------------------------------
        -- 실행 Logic START --
        -----------------------------------------------------------
		  
        -----------------------------------------------------------
        -- WEEKLY Plan ID 생성
        -----------------------------------------------------------
        IF @p_plan_cycle = 'WEEKLY'        
        BEGIN
          -- 실행 일자 처리
          -- WEEKLY : NULL 이거나 미래 일자이면 오늘 일자로 처리
          IF (ISNULL(@p_plan_name, '') = '')
            SET @d_plan_name = GETDATE()
          ELSE IF @p_plan_name > CONVERT(CHAR(8), GETDATE(), 112)
            SET @d_plan_name = GETDATE()
          ELSE
            SET @d_plan_name = CONVERT(DATETIME, @p_plan_name)

          -- 전주 Plan ID 찾기
          SET @n_pre_plan_id = 0

          SELECT /* PR_SCM_MST_PLAN */
                 @n_pre_plan_id = CONVERT(INT, a.plan_id)
          FROM  (
                 SELECT p.plan_id, row_number() OVER (ORDER BY p.plan_id DESC) AS rownum
                 FROM   scm_mst_plan p WITH(NOLOCK)
                 WHERE  p.plan_name  = CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(@d_plan_name, 'MON')), 112)   -- 지난 주 월요일 'YYYYMMDD'
                 AND    p.plan_cycle = @p_plan_cycle
                ) a
          WHERE  rownum = 1
          ;
        
          -----------------------------------------------------------
          -- Division별 Weekly Plan ID 생성        
          -----------------------------------------------------------
          DECLARE div_w_cur CURSOR FOR SELECT DISTINCT division_id FROM SCM_MST_DIVISION ORDER BY division_id;
          SET @v_division_id = '0'

          OPEN div_w_cur;
          FETCH NEXT FROM div_w_cur INTO @v_division_id; -- 첫 열 Fetch
          WHILE @@FETCH_STATUS = 0 -- 정상 Fetch인 경우
          BEGIN
      
            -- 당주 Plan ID 찾기
            SET @n_cur_plan_id = 0
          
            SELECT /* PR_SCM_MST_PLAN */
                   @n_cur_plan_id = CONVERT(INT, p.plan_id)
            FROM   scm_mst_plan p WITH(NOLOCK)
            WHERE  p.division_id = @v_division_id
            AND    p.plan_cycle  = @p_plan_cycle
            AND    p.plan_id     = RTRIM(LTRIM(STR(@n_pre_plan_id + 1)))
            ;
       
            IF @@ROWCOUNT = 0
            BEGIN
              SET @n_cur_plan_id = 0
            END;
            
            -----------------------------------------------------------
            -- 당주 Plan ID가 없는 경우만 생성
            -- 신규 Division 추가 시 전주 Plan ID 미리 생성 할 것
            -----------------------------------------------------------
            IF @n_cur_plan_id = 0 
            BEGIN
              INSERT INTO scm_mst_plan
              (division_id, plan_cycle, plan_id, plan_name, horizon_start_date, horizon_end_date
               -- 20231017 PJ20230692 도전과제 계획 Plan End Date 지정
              ,attribute1
              ,creation_date, created_by, last_update_date, last_updated_by
              )
              SELECT /* PR_SCM_MST_PLAN */
                     division_id
                    ,@p_plan_cycle
                    ,RTRIM(LTRIM(STR(CONVERT(INT, plan_id) + 1)))
                    ,CONVERT(CHAR(8), DATEADD(DD, 7, CONVERT (DATE, plan_name)), 112)
                    ,CONVERT(CHAR(8), DATEADD(DD, 7, CONVERT (DATE, horizon_start_date)), 112)
                    ,CONVERT(CHAR(8), DATEADD(DD, 7, CONVERT (DATE, horizon_end_date)), 112)
                    -- 20231017 PJ20230692 도전과제 계획 Plan End Date 지정
                    ,CONVERT(CHAR(8), DATEADD(DD, 7, CONVERT (DATE, attribute1)), 112)
                    ,SYSDATETIME() creation_date, 'scm_batch' created_by
                    ,SYSDATETIME() last_update_date, 'scm_batch' last_updated_by
              FROM   scm_mst_plan t WITH(NOLOCK)
              WHERE  t.division_id = @v_division_id
              AND    t.plan_cycle  = @p_plan_cycle
              AND    t.plan_id     = RTRIM(LTRIM(STR(@n_pre_plan_id)))
              ;
             -- COMMIT WORK;
			  
              -----------------------------------------------------------
              -- Insert LOG
              -----------------------------------------------------------
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'INSERT INTO scm_mst_plan';
              SET @v_description = @p_plan_cycle + ':' + @v_division_id + ':' + CONVERT(CHAR(8), @d_plan_name, 112) ;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------

            END;-- IF @n_cur_plan_id = 0 THEN
            
            FETCH NEXT FROM div_w_cur INTO @v_division_id; -- 다음 열 Fetch
          END; -- CURSOR FETCH

          CLOSE div_w_cur;
          DEALLOCATE div_w_cur;

        END; -- IF @p_plan_cycle = 'WEEKLY' 
		  
        -----------------------------------------------------------
        -- DAILY Plan ID 생성
        -----------------------------------------------------------
        ELSE IF @p_plan_cycle = 'DAILY' 
    
        BEGIN
          -- 실행 일자 처리
          -- DAILY : NULL 이거나 오늘 이후 일자이면 어제 일자로 처리
          --IF (ISNULL(@p_plan_name, '') = '')
          --  SET @d_plan_name = DATEADD(DD, -1, GETDATE())
          --ELSE IF @p_plan_name >= CONVERT(CHAR(8), GETDATE(), 112)
          --  SET @d_plan_name = DATEADD(DD, -1, GETDATE())
          --ELSE
          --  SET @d_plan_name = DATEADD(DD, -1, CONVERT(DATETIME, @p_plan_name))

          -- DAILY : NULL 이거나 오늘 이후 일자이면 오늘 일자로 처리
      --                ,CONVERT(CHAR(8), DATEADD(DD, 7, CONVERT (DATE, horizon_end_date)), 112)
          IF (ISNULL(@p_plan_name, '') = '')
            SET @d_plan_name = GETDATE()
          ELSE IF @p_plan_name > CONVERT(CHAR(8), GETDATE(), 112)
            SET @d_plan_name = GETDATE()
          ELSE
            SET @d_plan_name = CONVERT(DATETIME, @p_plan_name)
        
          -- 전주 WEEKLY Plan ID 찾기
          SET @n_pre_week_plan_id = 0

          SELECT /* PR_SCM_MST_PLAN */
                 @n_pre_week_plan_id = CONVERT(INT, a.plan_id)
          FROM  (
                 SELECT p.plan_id, row_number() OVER (ORDER BY p.plan_id) AS rownum
                 FROM   scm_mst_plan p WITH(NOLOCK)
                 WHERE  p.plan_name  = CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(@d_plan_name, 'MON')), 112)   -- 지난 주 월요일 'YYYYMMDD'
                 AND    p.plan_cycle = 'WEEKLY'
                ) a
          WHERE  rownum = 1
          ;

          -- 당주 WEEKLY Plan ID 찾기
          SET @n_cur_week_plan_id = @n_pre_week_plan_id + 1
        
          -----------------------------------------------------------
          -- Division별 Daily Plan ID 생성
          -----------------------------------------------------------
          DECLARE div_d_cur CURSOR FOR SELECT DISTINCT division_id FROM SCM_MST_DIVISION ORDER BY division_id;
          SET @v_division_id = '0'

          OPEN div_d_cur;
          FETCH NEXT FROM div_d_cur INTO @v_division_id; -- 첫 열 Fetch
          WHILE @@FETCH_STATUS = 0 -- 정상 Fetch인 경우
          BEGIN              
		  
            -----------------------------------------------------------
            -- 신규 Division 추가 시 전주 Plan ID 미리 생성 할 것
            -- 1. 월요일 : 전주 월요일 정보 사용하여 생성
            -----------------------------------------------------------
            IF @v_cur_monday = CONVERT(CHAR(8), @d_plan_name, 112)    
            BEGIN
        
              -- 전주 DAILY 월요일 Plan ID 찾기
              SET @n_pre_plan_id = 0

              SELECT /* PR_SCM_MST_PLAN */
                     @n_pre_plan_id = CONVERT(INT, a.plan_id)
              FROM  (
                     SELECT p.plan_id, row_number() OVER (ORDER BY p.plan_id) AS rownum
                     FROM   scm_mst_plan p WITH(NOLOCK)
                     WHERE  p.plan_name  = CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(@d_plan_name, 'MON')), 112)   -- 지난 주 월요일 'YYYYMMDD'
                     AND    p.plan_cycle = @p_plan_cycle
                    ) a
              WHERE  rownum = 1
              ;
        
              -- 당일 Plan ID 찾기
              SET @n_cur_plan_id = 0
              
              SELECT /* PR_SCM_MST_PLAN */
                     @n_cur_plan_id = CONVERT(INT, p.plan_id)
              FROM   scm_mst_plan p WITH(NOLOCK)
              WHERE  p.division_id = @v_division_id
              AND    p.plan_cycle  = @p_plan_cycle
              AND    p.plan_id     = RTRIM(LTRIM(STR(@n_cur_week_plan_id))) + '01' -- 당주 월요일 Plan ID
              ;
        
              IF @@ROWCOUNT = 0
              BEGIN
                SET @n_cur_plan_id = 0
              END;
              
              -----------------------------------------------------------
              -- 당일Plan ID가 없는 경우만 생성
              -- 전주 월요일 정보 사용하여 생성
              -----------------------------------------------------------
              IF @n_cur_plan_id = 0
              BEGIN
                INSERT INTO scm_mst_plan
                (division_id, plan_cycle, plan_id, plan_name, horizon_start_date, horizon_end_date
                ,creation_date, created_by, last_update_date, last_updated_by
                )
                SELECT /* PR_SCM_MST_PLAN */
                       division_id
                      ,@p_plan_cycle 
                      ,RTRIM(LTRIM(STR(@n_cur_week_plan_id))) + '01'
                      ,CONVERT(CHAR(8), DATEADD(DD, 7, CONVERT (DATE, plan_name)), 112)
                      ,CONVERT(CHAR(8), DATEADD(DD, 7, CONVERT (DATE, horizon_start_date)), 112)
                      ,CONVERT(CHAR(8), DATEADD(DD, 7, CONVERT (DATE, horizon_end_date)), 112)
                      ,SYSDATETIME() creation_date, 'scm_batch' created_by
                      ,SYSDATETIME() last_update_date, 'scm_batch' last_updated_by
                FROM   scm_mst_plan t WITH(NOLOCK)
                WHERE  t.division_id = @v_division_id
                AND    t.plan_cycle  = @p_plan_cycle
                AND    t.plan_id     = RTRIM(LTRIM(STR(@n_pre_plan_id)))
                ;
              --  COMMIT WORK;
			  
                -----------------------------------------------------------
                -- Insert LOG
                -----------------------------------------------------------
                SET @v_log_type = 'APPEND';
                SET @v_log_message = 'INSERT INTO SCM_MST_PLAN : MON';
                SET @v_description = @p_plan_cycle + ':' + @v_division_id + ':' + CONVERT(CHAR(8), @d_plan_name, 112) ;
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                -----------------------------------------------------------

              END; -- IF @n_cur_plan_id = 0
                
            END;  -- IF @v_cur_monday = CONVERT(CHAR(8), @d_plan_name, 112)    
            -----------------------------------------------------------
            -- 2. 월요일 외: 전일 정보 사용하여 생성
            -----------------------------------------------------------
            ELSE 
            BEGIN
      
              -- 전일 Plan ID 찾기
              SET @n_pre_plan_id = 0

              SELECT /* PR_SCM_MST_PLAN */
                     @n_pre_plan_id = CONVERT(INT, a.plan_id)
              FROM  (
                     SELECT p.plan_id, row_number() OVER (ORDER BY p.plan_id DESC) AS rownum
                     FROM   scm_mst_plan p WITH(NOLOCK)
                     WHERE  p.plan_name  = CONVERT(CHAR(8), DATEADD(DD, -1, @d_plan_name), 112)   -- 어제일자 'YYYYMMDD'
                     AND    p.plan_cycle = @p_plan_cycle
                    ) a
              WHERE  rownum = 1
              ;
        
              -- 당일 Plan ID 찾기
              SET @n_cur_plan_id = 0

              SELECT /* PR_SCM_MST_PLAN */
                     @n_cur_plan_id = CONVERT(INT, p.plan_id)
              FROM   scm_mst_plan p WITH(NOLOCK)
              WHERE  p.division_id = @v_division_id
              AND    p.plan_cycle  = @p_plan_cycle
              AND    p.plan_id     = RTRIM(LTRIM(STR(@n_pre_plan_id + 1)))
              ;

              IF @@ROWCOUNT = 0
              BEGIN
                SET @n_cur_plan_id = 0
              END;

              -----------------------------------------------------------
              -- 당일Plan ID가 없는 경우만 생성
              -- 전일 정보 사용하여 생성
              -----------------------------------------------------------
              IF @n_cur_plan_id = 0 
              BEGIN
                INSERT INTO scm_mst_plan
                (division_id, plan_cycle, plan_id, plan_name, horizon_start_date, horizon_end_date
                ,creation_date, created_by, last_update_date, last_updated_by
                )
                SELECT /* PR_SCM_MST_PLAN */
                       division_id
                      ,@p_plan_cycle 
                      ,RTRIM(LTRIM(STR(CONVERT(INT, t.plan_id) + 1)))
                      ,CONVERT(CHAR(8), DATEADD(DD, 1, CONVERT (DATE, plan_name)), 112)
                      ,CONVERT(CHAR(8), DATEADD(DD, 1, CONVERT (DATE, horizon_start_date)), 112)
                      ,CONVERT(CHAR(8), DATEADD(DD, 1, CONVERT (DATE, horizon_end_date)), 112) -- END Date도 하루씩 증가
                    --  ,CONVERT(CHAR(8), DATEADD(DD, 0, CONVERT (DATE, horizon_end_date)), 112) -- END Date는 동일 주차일 경우 그대로 유지
                      ,SYSDATETIME() creation_date, 'scm_batch' created_by
                      ,SYSDATETIME() last_update_date, 'scm_batch' last_updated_by
                FROM   scm_mst_plan t WITH(NOLOCK)
                WHERE  t.division_id = @v_division_id
                AND    t.plan_cycle  = @p_plan_cycle
                AND    t.plan_id     = RTRIM(LTRIM(STR(@n_pre_plan_id)))
                ;
             --   COMMIT WORK;
			  
                -----------------------------------------------------------
                -- Insert LOG
                -----------------------------------------------------------
                SET @v_log_type = 'APPEND';
                SET @v_log_message = 'INSERT INTO SCM_MST_PLAN : NON MON';
                SET @v_description = @p_plan_cycle + ':' + @v_division_id + ':' + CONVERT(CHAR(8), @d_plan_name, 112) ;
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                -----------------------------------------------------------

              END; -- IF @n_cur_plan_id = 0
                             
            END ; -- ELSE : MONDAY
                        
            FETCH NEXT FROM div_d_cur INTO @v_division_id; -- 다음 열 Fetch
          END; -- CURSOR FETCH

          CLOSE div_d_cur;
          DEALLOCATE div_d_cur;
        
        END; -- ELSE IF @p_plan_cycle = 'DAILY' 
		
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'SCM_MST_PLAN';
        SET @v_description = 'Process Complete.' + ':' + @p_plan_cycle + ':' + CONVERT(CHAR(8), @d_plan_name, 112);
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF @@TRANCOUNT > 0
        BEGIN
          COMMIT WORK;
        END;

      END;
    
    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR LINE ' + CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '[PR_SCM_MST_PLAN]' + ':' + @p_plan_cycle;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
