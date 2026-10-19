
/*
 * Program ID   : PR_SCP_ANL_PROBLEM_REPORT_DESC  
 * Description  : PROBLEM_REPORT_DESC
 * OutTable     :
 * Execute      : EXEC PR_SCP_ANL_PROBLEM_REPORT_DESC N'81',N'20180108',N'MA',N'2',N'LTW'
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.27   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.10   YYDOK       WEEKLATE PROBLEM TYPE ADD
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PROBLEM_REPORT_DESC]
    ( @p_plan_cycle           NVARCHAR(150)          
    , @p_plan_start_yyyymmdd  NVARCHAR(8)     -- plan_name       
    , @p_plan_id              NVARCHAR(4000)          
    , @p_modeling_id          NVARCHAR(4000)          
    , @p_seq                  NVARCHAR(4000)          
    , @p_plan_type            NVARCHAR(4000)          
    , @p_master_id            NVARCHAR(4000)          
    , @p_division_id          NVARCHAR(30)          
    , @p_engine_plan_id       NVARCHAR(4000)          
    , @p_user_id              NVARCHAR(150)  = 'scp_batch' 
    -- , @p_debug       INT OUTPUT
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PROBLEM_REPORT_DESC';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      --상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_PROBLEM_REPORT_DESC'; --테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_ANL_PROBLEM_REPORT_DESC INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    
    
    
    BEGIN TRY
      BEGIN
    
        /*
        Program ID   : PR_SCP_ANL_PROBLEM_REPORT_DESC
        */

        --BEGIN TRANSACTION; 
        
          
        ----------------------------------------------------------- 
        -- 1. SCP_ANL_PROBLEM_REPORT_DESC 삭제
        -- 1.1. 현재 작업하는 division_id ,plan_start_yyyymmdd ,plan_type ,seq 과 같은 데이터가 있으면 삭제한다.
        ----------------------------------------------------------- 
        DELETE SCP_ANL_PROBLEM_REPORT_DESC 
        WHERE 1=1
          AND division_id         = @p_division_id 
          AND plan_start_yyyymmdd = @p_plan_start_yyyymmdd 
          AND plan_type           = @p_plan_type 
          AND seq                 = @p_seq 
          ;
        
        ----------------------------------------------------------- 
        -- 2. SCP_ANL_PROBLEM_REPORT_DESC 인서트
        ----------------------------------------------------------- 
        INSERT SCP_ANL_PROBLEM_REPORT_DESC
            (
               division_id 
              ,plan_start_yyyymmdd 
              ,plan_type 
              ,seq 
              ,eng_demand_id 
              ,problem_seq 
              ,eng_problem_type 
              ,eng_problem_desc 
              ,request_time 
              ,response_time
              ,problem_qty 
              ,node_type 
              ,node_id
              ,created_by 
              ,creation_date 
              ,last_updated_by 
              ,last_update_date
            )
            SELECT @p_division_id 
                  ,@p_plan_start_yyyymmdd 
                  ,@p_plan_type 
                  ,@p_seq 
                  ,item_id+'::'+ project_code+'::'+sales_site_id+'::'+ dom_exp+'::'+ fcst_type+'::'+yyyymmdd+'::'+plant_site_id AS ENG_DEMAND_ID
                  ,pr.problem_seq
                  ,pr.problem_type
                  ,pr.problem_descr
                  ,pr.request_time
                  ,pr.response_time
                  ,pr.problem_qty
                  ,pr.node_type
                  ,pr.node_id
                  ,@p_user_id 
                  ,GETDATE() 
                  ,@p_user_id 
                  ,GETDATE()
             FROM SCP_PLN_PROBLEM_REPORT_V AS pr 
            WHERE 1=1
              AND pr.division_id         = @p_division_id 
              AND pr.plan_start_yyyymmdd = @p_plan_start_yyyymmdd 
              AND pr.plan_type           = @p_plan_type 
              AND pr.seq                 = @p_seq
            
        
        ----------------------------------------------------------- 
        -- 3. scp_anl_problem_report_demand.problem_type 업데이트
        -- 2:UNPLAN, 1:LATE/WEEKLATE update처리
        ----------------------------------------------------------- 
        UPDATE pd
          SET pd.problem_type = (CASE a.problem_desc WHEN 2 THEN 'UNPLAN'
                                                     WHEN 1 THEN 'LATE'
                                 END)
        FROM SCP_ANL_PROBLEM_REPORT_DEMAND AS pd WITH(NOLOCK)
          ,(
              SELECT eng_demand_id
                    ,MAX(CASE x.eng_problem_type WHEN 'UNPLAN'    THEN 2
                                                 WHEN 'LATE'      THEN 1
                                                 WHEN 'WEEKLATE'  THEN 1
                                                 ELSE 0
                         END) AS problem_desc
               FROM SCP_ANL_PROBLEM_REPORT_DESC AS x WITH(NOLOCK)
              WHERE 1=1
                AND x.division_id         = @p_division_id 
                AND x.plan_start_yyyymmdd = @p_plan_start_yyyymmdd
                AND x.plan_type           = @p_plan_type 
                AND x.seq                 = @p_seq
              GROUP BY x.eng_demand_id
           ) AS a 
        WHERE 1=1
          AND pd.division_id          = @p_division_id 
          AND pd.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd 
          AND pd.plan_type            = @p_plan_type 
          AND pd.seq                  = @p_seq
          AND pd.eng_demand_id        = a.eng_demand_id




        --PRINT N'프로시저 종료'


        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

        --IF @@TRANCOUNT > 0 
        --  BEGIN
        --    COMMIT WORK;
        --  END;

        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    --로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121);
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;

      END;

    END TRY

    BEGIN CATCH
        
      --IF @@TRANCOUNT > 0 
      --  BEGIN
      --    ROLLBACK;
      --  END;


      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    return 1 


  END;

