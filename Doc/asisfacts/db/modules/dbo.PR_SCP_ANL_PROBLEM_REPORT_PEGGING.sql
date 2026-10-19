

/*
 * Program ID   : PR_SCP_ANL_PROBLEM_REPORT_PEGGING  
 * Description  : PROBLEM_REPORT_PEGGING
 * OutTable     :
 * Execute      : EXEC PR_SCP_ANL_PROBLEM_REPORT_PEGGING N'81',N'20180108',N'MA',N'2',N'LTW'
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.27   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.05   LTW         통합테스트 수정
 * 2018.05.17   LTW         호출 파라메터 추가(@p_modeling_id ,@p_master_id ,@p_plan_id ,@p_engine_plan_id)
 * 2018.06.01   YYDOK       ALLOC의 경우, stock_plan_lot_id의 날짜가 있고 납기보다 늦으면 해당일자로 PLAN START,END DATE로 셋팅처리
 * 2018.06.15   LTW         트랙잭션 제거
 * 2018.07.04   LTW         전극 SCP 작업(ORIGIN_FROM_DIVISION_ID ,ORIGIN_TO_DIVISION_ID) 추가
 * 2018.09.18   LTW         SCP_ANL_PROBLEM_REPORT_PEGGING.PLANNED_QTY 의 수량을 완료 기준 수량(FROM_SITE 기준) 으로 변경
 * 2018.09.28   LTW         TO_DELIVERY_ORDER_ID => DELIVERY_ORDER_ID 매핑 부분 수정처리
 * 2018.10.12   LTW         #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_SRC,SCP_ENG_PEGGING_INFO_O_TEMP_SN 조인 조건 추가(DUE_DATE)
 *
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PROBLEM_REPORT_PEGGING]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PROBLEM_REPORT_PEGGING';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      --상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_PROBLEM_REPORT_PEGGING'; --테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_ANL_PROBLEM_REPORT_PEGGING INSERT LOGIC';
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
    
        /*
        Program ID   : PR_SCP_ANL_PROBLEM_REPORT_PEGGING
        */

        --BEGIN TRANSACTION; 


        ----------------------------------------------------------- 
        -- 1. SCP_ANL_PROBLEM_REPORT_PEGGING 삭제
        ----------------------------------------------------------- 
        DELETE SCP_ANL_PROBLEM_REPORT_PEGGING 
         WHERE 1=1
           AND division_id         = @p_division_id 
           AND plan_start_yyyymmdd = @p_plan_start_yyyymmdd 
           AND plan_type           = @p_plan_type 
           AND seq                 = @p_seq
           ;
        

        --작업용 임시테이블 생성        
        IF OBJECT_ID(N'tempdb..#tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_SRC') IS NOT NULL
          DROP TABLE #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_SRC
          ;
        CREATE TABLE #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_SRC (
           division_id              NVARCHAR(30)
          ,plan_start_yyyymmdd      NVARCHAR(8) 
          ,plan_type                NVARCHAR(8) 
          ,seq                      BIGINT 
          ,eng_demand_id            NVARCHAR(1000) 
          ,pegging_operation_code   NVARCHAR(10)
          ,item_id                  NVARCHAR(50)
          ,from_site                NVARCHAR(30)
          ,to_site                  NVARCHAR(30)
          ,due_date                 DATETIME
          ,plan_start_date          DATETIME
          ,plan_end_date            DATETIME
          ,planned_qty              NUMERIC(20,10)
          ,complete_qty             NUMERIC(20,10)
          ,operation_group          NVARCHAR(10)
          ,electrode_type           NVARCHAR(30)
          ,stock_plan_lot_id        NVARCHAR(100)
          ,lpst                     DATETIME
          ,origin_from_division_id  NVARCHAR(30)    --전극 작업 추가
          ,origin_to_division_id    NVARCHAR(30)    --전극 작업 추가
          ,delivery_order_id        NVARCHAR(1000)
          ,to_delivery_order_id     NVARCHAR(1000)
          ,descr                    NVARCHAR(10)
        );

        IF OBJECT_ID(N'tempdb..#tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_DESC') IS NOT NULL
          DROP TABLE #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_DESC
          ;
        CREATE TABLE #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_DESC (
           division_id              NVARCHAR(30)
          ,plan_start_yyyymmdd      NVARCHAR(8) 
          ,plan_type                NVARCHAR(8) 
          ,seq                      BIGINT 
          ,eng_demand_id            NVARCHAR(1000) 
          ,pegging_operation_code   NVARCHAR(10)
          ,item_id                  NVARCHAR(50)
          ,from_site                NVARCHAR(30)
          ,to_site                  NVARCHAR(30)
          ,due_date                 DATETIME
          ,plan_start_date          DATETIME
          ,plan_end_date            DATETIME
          ,planned_qty              NUMERIC(20,10)
          ,complete_qty             NUMERIC(20,10)
          ,operation_group          NVARCHAR(10)
          ,electrode_type           NVARCHAR(30)
          ,stock_plan_lot_id        NVARCHAR(100)
          ,lpst                     DATETIME
          ,origin_from_division_id  NVARCHAR(30)    --전극 작업 추가
          ,origin_to_division_id    NVARCHAR(30)    --전극 작업 추가
          ,delivery_order_id        NVARCHAR(1000)
          ,to_delivery_order_id     NVARCHAR(1000)
          ,descr                    NVARCHAR(10)
        );
        

        ----------------------------------------------------------- 
        -- 2. SCP_ANL_PROBLEM_REPORT_PEGGING 입력
        -----------------------------------------------------------
        INSERT #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_SRC 
        (
           division_id 
          ,plan_start_yyyymmdd 
          ,plan_type 
          ,seq 
          ,eng_demand_id 
          ,pegging_operation_code 
          ,item_id 
          ,from_site 
          ,to_site 
          ,due_date 
          ,plan_start_date 
          ,plan_end_date
          ,planned_qty 
          ,complete_qty
          ,operation_group 
          ,electrode_type 
          ,stock_plan_lot_id
          ,lpst
          ,origin_from_division_id  --전극 작업 추가
          ,origin_to_division_id    --전극 작업 추가
          ,delivery_order_id
          ,to_delivery_order_id
          ,descr 
        )
        SELECT pi.division_id
              ,pi.plan_name
              ,pi.plan_type
              ,pi.plan_seq
              ,demand_item_id+'::'+ project_code+'::'+sales_site_id+'::'+ dom_exp+'::'+ fcst_type+'::'+yyyymmdd+'::'+plant_site_id AS ENG_DEMAND_ID
              ,pi.pegging_operation_code
              ,pi.from_item_id    as item_id
              ,pi.from_site_id
              ,pi.to_site_id
              ,pi.due_date
              ,CASE WHEN ( PI.PEGGING_OPERATION_CODE = 'ALLOC' AND PI.STOCK_PLAN_LOT_ID IS NOT NULL AND DBO.FN_SCM_SPLIT(PI.STOCK_PLAN_LOT_ID,4,'::') > CONVERT(NVARCHAR(8), PI.DUE_DATE, 112) ) THEN CONVERT(DATETIME,DBO.FN_SCM_SPLIT(PI.STOCK_PLAN_LOT_ID,4,'::'),112)
                      ELSE pi.plan_start_date
                END as plan_start_date
              ,CASE WHEN ( PI.PEGGING_OPERATION_CODE = 'ALLOC' AND PI.STOCK_PLAN_LOT_ID IS NOT NULL AND DBO.FN_SCM_SPLIT(PI.STOCK_PLAN_LOT_ID,4,'::') > CONVERT(NVARCHAR(8), PI.DUE_DATE, 112) ) THEN CONVERT(DATETIME,DBO.FN_SCM_SPLIT(PI.STOCK_PLAN_LOT_ID,4,'::'),112)
                      ELSE pi.plan_end_date
                END as plan_end_date

              ,pi.planned_qty 
              ,NULL AS complete_qty
              ,pi.operation_group --pi.operation_group_id
              ,pi.electrode_type
              ,pi.stock_plan_lot_id
              ,pi.lpst
              ,pi.origin_from_division_id   --전극 작업 추가
              ,pi.origin_to_division_id     --전극 작업 추가
              ,pi.delivery_order_id
              ,pi.to_delivery_order_id
              ,pi.descr
                  
          FROM SCP_PLN_PEGGING_INFO_V AS pi WITH(NOLOCK)
         WHERE 1=1
           AND pi.plan_id        = @p_plan_id              --N'1033'           --
           AND pi.modeling_id    = @p_modeling_id          --N'2'              --
           AND pi.plan_seq       = @p_seq                  --N'6'              --
           AND pi.plan_name      = @p_plan_start_yyyymmdd  --N'20180702'       --
           AND pi.master_id      = @p_master_id            --N'81::WEEKLY'     --
           AND pi.out_version_id = @p_engine_plan_id       --N'1033::PR::6'    --
           AND pi.plan_type      = @p_plan_type            --N'PR'             --
           AND pi.division_id    = @p_division_id          --N'81'             --
           AND pi.pegging_operation_code <> '-'
           ;


        --TO_DELIVERY_ORDER_ID 기준의 완료 수량 가져오기
        UPDATE X
           SET X.complete_qty = ISNULL(P.complete_qty ,NULL)
        --SELECT X.* ,PI.qty AS complete_qty
          FROM #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_SRC AS  X WITH(NOLOCK)
          INNER JOIN (
                      SELECT PI.delivery_order_id 
                            ,PI.due_date
                            ,SUM(PI.qty) AS complete_qty 
                      --SELECT * 
                        FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN AS PI WITH(NOLOCK)
                       WHERE 1=1
                         AND PI.plan_id             = @p_plan_id              --N'1044'           --
                         AND PI.modeling_id         = @p_modeling_id          --N'1'              --
                         AND PI.seq                 = @p_seq                  --3                 --
                         AND PI.plan_name           = @p_plan_start_yyyymmdd  --N'20180917'       --
                         AND PI.master_id           = @p_master_id            --N'40::WEEKLY'     --
                         AND PI.out_version_id      = @p_engine_plan_id       --N'1044::MA::1'    --
                         AND PI.plan_type           = @p_plan_type            --N'MA'             --
                         AND PI.division_id         = @p_division_id          --N'40'             --
           
                         AND PI.operation_group     = 'A'
                         AND PI.pegging_type        = 'DELIVERY_ORDER'
                       GROUP BY 
                             PI.plan_id             
                            ,PI.modeling_id         
                            ,PI.seq                 
                            ,PI.plan_name           
                            ,PI.master_id           
                            ,PI.out_version_id      
                            ,PI.plan_type           
                            ,PI.division_id         
                            ,PI.due_date
                            ,PI.delivery_order_id

                     ) AS P 
            ON 1=1
           AND X.operation_group      = 'A'
           AND X.due_date             = P.due_date
           AND X.to_delivery_order_id = P.delivery_order_id
          WHERE 1=1
           AND X.operation_group      = 'A'
           AND X.due_date             = P.due_date
           AND X.to_delivery_order_id = P.delivery_order_id
           AND ISNULL(x.to_delivery_order_id,'') <> '' --PEGGING_OPERATION_CODE <> 'ALLOC'
           AND X.pegging_operation_code IN ('FORM','CHAR')
          ;


        --TO_DELIVERY_ORDER_ID : IN('FORM','CHAR')
        INSERT #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_DESC
        (
           division_id 
          ,plan_start_yyyymmdd 
          ,plan_type 
          ,seq 
          ,eng_demand_id 
          ,pegging_operation_code 
          ,item_id 
          ,from_site 
          ,to_site 
          ,due_date 
          ,plan_start_date 
          ,plan_end_date
          ,planned_qty 
          ,complete_qty 
          ,operation_group 
          ,electrode_type 
          ,stock_plan_lot_id
          ,lpst
          ,origin_from_division_id  --전극 작업 추가
          ,origin_to_division_id    --전극 작업 추가
          
          ,to_delivery_order_id
          
        )
        SELECT pi.division_id
              ,pi.plan_start_yyyymmdd
              ,pi.plan_type
              ,pi.seq
              ,pi.ENG_DEMAND_ID
              ,pi.pegging_operation_code
              ,pi.item_id
              ,pi.from_site
              ,pi.to_site
              ,pi.due_date
             
              ,pi.plan_start_date
              ,pi.plan_end_date

              ,SUM(pi.planned_qty)                              as planned_qty
              ,ISNULL(MAX(pi.complete_qty),SUM(pi.planned_qty)) as complete_qty
              ,pi.operation_group 
              ,pi.electrode_type
              ,NULL as stock_plan_lot_id 
              ,pi.lpst
              ,pi.origin_from_division_id   --전극 작업 추가
              ,pi.origin_to_division_id     --전극 작업 추가
              
              ,pi.to_delivery_order_id
          
         --SELECT * 
          FROM #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_SRC AS pi WITH(NOLOCK)
         WHERE 1=1
           AND pi.pegging_operation_code IN ('FORM','CHAR')

           --and pi.item_id = 'MCCH129520A4'
           --and pi.eng_demand_id like '%::20180924::A010-A'
           --and pi.eng_demand_id = 'MCCH129520A4::Shark Ninja::BYD_CN_SZX::E::MPS::20180924::A010-A'
         
        GROUP BY 
               pi.division_id
              ,pi.plan_start_yyyymmdd
              ,pi.plan_type
              ,pi.seq
              ,pi.eng_demand_id
              ,pi.pegging_operation_code
              ,pi.item_id
              ,pi.from_site
              ,pi.to_site
              ,pi.due_date
              ,pi.operation_group --pi.operation_group_id
              ,pi.electrode_type
              ,pi.plan_start_date
              ,pi.plan_end_date 
              --,pi.stock_plan_lot_id
              ,pi.lpst
              ,pi.origin_from_division_id  --전극 작업 추가
              ,pi.origin_to_division_id    --전극 작업 추가
              
              --,pi.delivery_order_id
              ,pi.to_delivery_order_id              
              ;

        --TO_DELIVERY_ORDER_ID : NOT IN('FORM','CHAR')
        INSERT #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_DESC
        (
           division_id 
          ,plan_start_yyyymmdd 
          ,plan_type 
          ,seq 
          ,eng_demand_id 
          ,pegging_operation_code 
          ,item_id 
          ,from_site 
          ,to_site 
          ,due_date 
          ,plan_start_date 
          ,plan_end_date
          ,planned_qty 
          ,complete_qty 
          ,operation_group 
          ,electrode_type 
          ,stock_plan_lot_id
          ,lpst
          ,origin_from_division_id  --전극 작업 추가
          ,origin_to_division_id    --전극 작업 추가
          
          ,to_delivery_order_id
          
        )
        SELECT pi.division_id
              ,pi.plan_start_yyyymmdd
              ,pi.plan_type
              ,pi.seq
              ,pi.ENG_DEMAND_ID
              ,pi.pegging_operation_code
              ,pi.item_id
              ,pi.from_site
              ,pi.to_site
              ,pi.due_date
             
              ,pi.plan_start_date
              ,pi.plan_end_date

              ,SUM(pi.planned_qty)  as planned_qty
              ,ISNULL(MAX(pi.complete_qty),SUM(pi.planned_qty)) as complete_qty
              ,pi.operation_group 
              ,pi.electrode_type
              ,pi.stock_plan_lot_id 
              ,pi.lpst
              ,pi.origin_from_division_id   --전극 작업 추가
              ,pi.origin_to_division_id     --전극 작업 추가
              
              ,null as to_delivery_order_id
          
         --SELECT * 
          FROM #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_SRC AS pi WITH(NOLOCK)
         WHERE 1=1
           AND pi.pegging_operation_code NOT IN ('FORM','CHAR')

           --and pi.item_id = 'MCCH129520A4'
           --and pi.eng_demand_id like '%::20180924::A010-A'
           --and pi.eng_demand_id = 'MCCH129520A4::Shark Ninja::BYD_CN_SZX::E::MPS::20180924::A010-A'
         
        GROUP BY 
               pi.division_id
              ,pi.plan_start_yyyymmdd
              ,pi.plan_type
              ,pi.seq
              ,pi.eng_demand_id
              ,pi.pegging_operation_code
              ,pi.item_id
              ,pi.from_site
              ,pi.to_site
              ,pi.due_date
              ,pi.operation_group --pi.operation_group_id
              ,pi.electrode_type
              ,pi.plan_start_date
              ,pi.plan_end_date 
              ,pi.stock_plan_lot_id
              ,pi.lpst
              ,pi.origin_from_division_id  --전극 작업 추가
              ,pi.origin_to_division_id    --전극 작업 추가
              
              --,pi.delivery_order_id
              --,pi.to_delivery_order_id              
              ;


        ----------------------------------------------------------- 
        -- 3. (ORIGIN_FROM_DIVISION_ID ,ORIGIN_TO_DIVISION_ID)
        ----------------------------------------------------------- 
        /* TEMP 테이블 선행 작업으로 주석처리
        UPDATE x
           SET x.origin_from_division_id = ISNULL(fs.division_id,'')
          FROM #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING  AS  x WITH (NOLOCK)
               LEFT OUTER JOIN SCM_MST_SITE         AS fs WITH (NOLOCK) 
                 ON 1=1 --fs.site_type   = N'PLANT'    
                AND (CASE WHEN x.division_id = 'EE' THEN 0 ELSE x.division_id END ) = (CASE WHEN x.division_id = 'EE' THEN 0 ELSE fs.division_id END )
                AND fs.valid_yn    = N'Y'   
                AND fs.scm_site_id = REPLACE(x.from_site ,'-S' ,'') --x.from_site
                ;

        UPDATE x
           SET x.origin_to_division_id = ISNULL(ts.division_id,'')
          FROM #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING  AS  x WITH (NOLOCK)
               LEFT OUTER JOIN SCM_MST_SITE         AS ts WITH (NOLOCK) 
                 ON 1=1 --ts.site_type   = N'PLANT'    
                AND (CASE WHEN x.division_id = 'EE' THEN 0 ELSE x.division_id END ) = (CASE WHEN x.division_id = 'EE' THEN 0 ELSE ts.division_id END )
                AND ts.valid_yn    = N'Y'   
                AND ts.scm_site_id = REPLACE(x.to_site ,'-S' ,'') --x.to_site
                ;*/
     
        
        ----------------------------------------------------------- 
        -- 4. 실제 인서트 작업
        ----------------------------------------------------------- 
        INSERT SCP_ANL_PROBLEM_REPORT_PEGGING 
            (
               division_id 
              ,plan_start_yyyymmdd 
              ,plan_type 
              ,seq 
              ,eng_demand_id 
              ,pegging_operation_code 
              ,item_id 
              ,from_site 
              ,to_site 
              ,due_date 
              ,plan_start_date 
              ,plan_end_date

              ,planned_qty 

              ,operation_group 
              ,electrode_type 
              ,stock_plan_lot_id
              ,lpst
              ,origin_from_division_id 
              ,origin_to_division_id 

              ,created_by
              ,creation_date
              ,last_updated_by
              ,last_update_date  
            )
            SELECT pi.division_id
              ,pi.plan_start_yyyymmdd
              ,pi.plan_type
              ,pi.seq
              ,pi.ENG_DEMAND_ID
              ,pi.pegging_operation_code
              ,pi.item_id
              ,pi.from_site
              ,pi.to_site
              ,pi.due_date             
              ,pi.plan_start_date
              ,pi.plan_end_date

              --,SUM(pi.planned_qty)  as planned_qty
              --,SUM(pi.complete_qty) as complete_qty
              ,(CASE WHEN pi.pegging_operation_code IN ('FORM','CHAR') THEN SUM(pi.complete_qty)
                                                                       ELSE SUM(pi.planned_qty)
               END) AS planned_qty

              ,pi.operation_group 
              ,pi.electrode_type
              ,ISNULL(pi.stock_plan_lot_id ,'') as stock_plan_lot_id 
              ,pi.lpst
              ,pi.origin_from_division_id   --전극 작업 추가
              ,pi.origin_to_division_id     --전극 작업 추가
              
              ,@p_user_id           AS created_by
              ,GETDATE()            AS creation_date
              ,@p_user_id           AS last_updated_by
              ,GETDATE()            AS last_update_date

         --SELECT * 
          FROM #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_DESC AS pi WITH(NOLOCK)
         WHERE 1=1

           --and pi.item_id = 'MCCH129520A4'
           --and pi.eng_demand_id like '%::20180924::A010-A'
           --and pi.eng_demand_id = 'MCCH129520A4::Shark Ninja::BYD_CN_SZX::E::MPS::20180924::A010-A'
         
        GROUP BY 
               pi.division_id
              ,pi.plan_start_yyyymmdd
              ,pi.plan_type
              ,pi.seq
              ,pi.eng_demand_id
              ,pi.pegging_operation_code
              ,pi.item_id
              ,pi.from_site
              ,pi.to_site
              ,pi.due_date
              ,pi.operation_group --pi.operation_group_id
              ,pi.electrode_type
              ,pi.plan_start_date
              ,pi.plan_end_date 
              ,ISNULL(pi.stock_plan_lot_id ,'')
              ,pi.lpst
              ,pi.origin_from_division_id  --전극 작업 추가
              ,pi.origin_to_division_id    --전극 작업 추가
              ;

        --PRINT N'프로시저 종료'

        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

        --IF @@TRANCOUNT > 0 
        --  BEGIN
        --    COMMIT WORK;
        --  END;
        
        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------  
        IF OBJECT_ID(N'tempdb..#tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_SRC') IS NOT NULL
          DROP TABLE #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_SRC

        IF OBJECT_ID(N'tempdb..#tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_DESC') IS NOT NULL
          DROP TABLE #tbl_SCP_ANL_PROBLEM_REPORT_PEGGING_DESC
        
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

