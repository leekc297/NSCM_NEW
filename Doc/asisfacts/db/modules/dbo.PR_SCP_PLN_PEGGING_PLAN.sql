
/*
 * Program ID   : PR_SCP_PLN_PEGGING_PLAN 
 * Description  : Chempion 생산 계획 I/F를 위한 사업부별 1차 정보 생성
 * OutTable     :
 * Execute      : EXEC PR_SCP_PLN_PEGGING_PLAN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.12.08   KSG            Initial Release C20201203-000215 SCP → Chempion 생산 계획 I/F 개발 건
 * 
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_PEGGING_PLAN]
    ( 
      @p_division_id          NVARCHAR(10)
    , @p_start_yyyymmdd       NVARCHAR(8)
    , @p_plan_type            NVARCHAR(40)
    , @p_seq                  INT
    , @p_user_id              NVARCHAR(100)
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_PEGGING_PLAN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_PLN_PEGGING_GCS'; 
    DECLARE @d_event_date   DATETIME;

    DECLARE @v_delete_yyyymmdd   NVARCHAR(8);  
    
    ----------------------------------------------------------- 
    -- 0. validation
    -- PLAN_TYPE='FN' 만 처리함.
    -----------------------------------------------------------
    IF @p_plan_type NOT IN ( 'FN' )
        BEGIN
            RETURN;
        END 
           
    IF @p_user_id IS NULL 
        BEGIN
            SET @p_user_id = 'SCP';
        END 

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;

    --BEGIN TRANSACTION;               
    BEGIN TRY
      BEGIN
		   
        -----------------------------------------------------------
        -- 동일 주차 Data 삭제
        -----------------------------------------------------------
		DELETE SCP_PLN_PEGGING_GCS
        WHERE  division_id         = @p_division_id
        AND    plan_start_yyyymmdd = @p_start_yyyymmdd ;
		   
        -----------------------------------------------------------
        -- Data 생성
        -----------------------------------------------------------		
        INSERT INTO SCP_PLN_PEGGING_GCS
           (division_id, plan_start_yyyymmdd, plan_type, seq
          , demand_operation_group, pegging_operation_code, origin_division_id
          , eng_demand_id, fcst_type, demand_item_id
          , item_id, site_id, company_id
          , yyyymmdd, qty
          , creation_date, created_by, last_update_date, last_updated_by
           )
        
        SELECT pe.division_id             AS division_id
             , pe.plan_name               AS plan_start_yyyymmdd
             , pe.plan_type               AS plan_type
             , pe.plan_seq                AS seq
             , sp.operation_group         AS demand_operation_group -- Demand 구분 : Pack / Cell / Elec
        	 , pe.pegging_operation_code  AS pegging_operation_code
             , pe.origin_from_division_id AS origin_division_id
             , pe.eng_demand_id
             , pe.fcst_type
             , pe.demand_item_id
             , pe.from_item_id            AS item_id
             , pe.from_site_id            AS site_id
        
             , CASE WHEN sf.site_type = 'PLANT' AND sf.osp_yn = 'Y' THEN sf.plant_id
                    WHEN sf.site_type = 'PLANT'                     THEN sf.company_id
                    ELSE 'ZZZ'
               END                                 AS company_id
        
             , CONVERT(CHAR(8), pe.end_dttm, 112)  AS yyyymmdd
             , pe.planned_qty                      AS qty
        	 
             , GETDATE()  AS creation_date
             , @p_user_id AS created_by
             , GETDATE()  AS last_update_date
             , @p_user_id AS last_updated_by
        
        FROM   SCP_PLN_PEGGING_INFO_V pe WITH(NOLOCK) -- Pegging된 생산 계획 대상
        
               -- Demand Item 구분용 : P/A/E
               -- plant_site_id : demand에서 demand_item_id에 대하여 생산지로 지정한 Plant Site ID
               INNER JOIN scm_mst_site sp WITH(NOLOCK)
               ON  pe.plant_site_id           = sp.scm_site_id -- EE 사업부간 Shippng 때문에 사업부 조건 제외
        
               -- From Site : from_item_id 별 실제 생산 Site ID
               INNER JOIN scm_mst_site sf WITH(NOLOCK)
               ON  pe.from_site_id            = sf.scm_site_id -- EE 사업부간 Shippng 때문에 사업부 조건 제외
        
        WHERE  pe.division_id            = @p_division_id
        AND    pe.plan_name              = @p_start_yyyymmdd
        AND    pe.plan_type              = @p_plan_type
        AND    pe.plan_seq               = @p_seq
        AND    pe.pegging_operation_code IN ('ELEC', 'CELL', 'PACK', 'TCELL') -- Pegging된 생산계획
       ;

        ----------------------------------------------------------- 
        -- 종료 처리
        -----------------------------------------------------------          
       -- IF @@TRANCOUNT > 0 
       --   BEGIN
       --      COMMIT WORK;
       --                                
       --   END;      
        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';   
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ;
		   
        -----------------------------------------------------------
        -- 과거  Data 삭제
        -----------------------------------------------------------
		SET @v_delete_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7*12, CONVERT(DATETIME, @p_start_yyyymmdd)), 112) ; -- 12주 이전 정보 삭제

		DELETE SCP_PLN_PEGGING_GCS
        WHERE  division_id          = @p_division_id
        AND    plan_start_yyyymmdd <= @v_delete_yyyymmdd ;

      END;

    END TRY

    BEGIN CATCH     
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;

    return 1  
  END;
