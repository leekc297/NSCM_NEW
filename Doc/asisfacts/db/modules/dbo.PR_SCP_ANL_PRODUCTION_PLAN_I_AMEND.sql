
/*
 * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND  
 * Description  :
 * OutTable     :
 * Execute      : EXEC PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND N'81',N'20180108',N'MA',N'2',N'LTW'
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.06.07   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.11	HWY			EOH 계산 관련 RETURN값 수정
 *
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND]
    ( @p_division_id          NVARCHAR(30)
     ,@p_plan_start_yyyymmdd  NVARCHAR(8) -- plan_name
     ,@p_plan_type            NVARCHAR(30)
     ,@p_seq                  NVARCHAR(MAX)
     ,@p_operation_group     NVARCHAR(10)
     ,@p_user_id              NVARCHAR(150)  = 'scp_batch'
    -- ,@p_debug       INT OUTPUT
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500); 
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_PRODUCTION_PLAN'; 
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_ANL_PRODUCTION_PLAN UPDATE LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    
    
    
    BEGIN TRY
      BEGIN
    
        
        ----------------------------------------------------------- 
        --1. 생산계획(ONHAND_EOH) 데이터 AMEND
        ----------------------------------------------------------- 
        UPDATE x
           SET x.qty              = a.qty
              ,x.last_updated_by  = @p_user_id
              ,x.last_update_date = GETDATE()
          FROM scp_anl_production_plan AS x
          INNER JOIN (
                      SELECT division_id
                            ,plan_start_yyyymmdd
                            ,plan_type
                            ,seq
                            ,operation_group
                            ,scm_site_id
                            ,item_id
                            ,'*'                      AS line_id
                            ,'*'                      AS operation_id
                            ,'ONHAND_EOH'             AS measure
                            ,yyyymmdd
                            ,p_sum - s_sum            AS qty

                        FROM (
                              SELECT DISTINCT pp.division_id
                                    ,pp.plan_start_yyyymmdd
                                    ,pp.plan_type
                                    ,pp.seq
                                    ,pp.operation_group
                                    ,pp.scm_site_id
                                    ,pp.item_id
                                    ,pp.yyyymmdd
                                    ,SUM((CASE WHEN pp.measure = 'REQUIREMENT'     THEN ISNULL(pp.qty ,0) ELSE 0 END)) OVER(PARTITION BY pp.scm_site_id ,pp.item_id ORDER BY pp.scm_site_id ,pp.item_id ,pp.yyyymmdd) AS s_sum 
                                    ,SUM((CASE WHEN pp.measure = 'PROD_PLAN_AMEND' THEN ISNULL(pp.qty ,0) ELSE 0 END)) OVER(PARTITION BY pp.scm_site_id ,pp.item_id ORDER BY pp.scm_site_id ,pp.item_id ,pp.yyyymmdd) AS p_sum
                                FROM scp_anl_production_plan AS pp WITH(NOLOCK) 
                               WHERE 1=1
                                 AND pp.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd   --'20180604'        --
                                 AND pp.plan_type            = @p_plan_type             --'PR'              --
                                 AND pp.seq                  = @p_seq                   --'4'               --
                                 AND pp.division_id          = @p_division_id           --'81'              --
                                 AND pp.operation_group      = @p_operation_group      --'A'               --
                                 AND pp.measure              IN ('PROD_PLAN_AMEND','REQUIREMENT') 
                                 
                             ) AS x
                     ) AS a ON x.plan_start_yyyymmdd  = a.plan_start_yyyymmdd
                           AND x.plan_type            = a.plan_type
                           AND x.seq                  = a.seq
                           AND x.division_id          = a.division_id 
                           AND x.operation_group      = a.operation_group
                           AND x.scm_site_id          = a.scm_site_id
                           AND x.item_id              = a.item_id
                           AND x.measure              = a.measure
                           AND x.yyyymmdd             = a.yyyymmdd
                           
        WHERE 1=1
          AND x.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd   --'20180604'        --
          AND x.plan_type            = @p_plan_type             --'PR'              --
          AND x.seq                  = @p_seq                   --'4'               --
          AND x.division_id          = @p_division_id           --'81'              --
          AND x.operation_group      = @p_operation_group      --'A'               --
          AND x.measure              = 'ONHAND_EOH'
          ; 


        --PRINT N'프로시저 종료';

        
        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN'; 
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'UPDATE '+@v_table_id;
        --SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
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

	  -- 결과코드 반환
	  SELECT 'S' AS result_code ;

    END TRY

    BEGIN CATCH
      
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

      --RETURN -1 
	  -- 결과코드 반환
	  SELECT 'F' AS result_code ;
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

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
    --RETURN 1 

  END;

