/*
 * Program ID   : PR_SCP_PLN_SET_ASSIGN_TYPE 
 * Description  :
 * OutTable     :
 * Execute      : EXEC PR_SCP_PLN_SET_ASSIGN_TYPE N'81',N'20180108',N'MA',N'2',N'LTW'
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.26   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.17   LTW         ASSIGN_TYPE 1건 이상 나오는 케이스 ORDER_ID 추적 수정
 * 2018.06.05   LTW         UNPEGGING 데이터 처리 부분 수정(PACK 별도처리)
 * 2018.06.08   LTW         PEGGING 성능개선을 위한 수정(scp_eng_pegging_info_o_sn->scp_eng_pegging_info_o_temp_sn)
 * 2018.06.27   LTW         scm_mst_site.valid_yn = 'Y' 조건 추가
 * 2018.07.12   LTW         SCP_PLN_SHIPMENT_PLAN ASSIGN_TYPE 로직 변경
 * 2018.10.10   LTW         UNPEGGING ,PACK 데이터에 대한 UPDATE 로직 수정(속도 개선을 위한 수정)
 *
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_SET_ASSIGN_TYPE]
    ( 
      @p_plan_cycle           NVARCHAR(150)
    , @p_plan_start_yyyymmdd  NVARCHAR(8)
    , @p_plan_id              NVARCHAR(4000)
    , @p_modeling_id          NVARCHAR(4000)
    , @p_seq                  NVARCHAR(4000)
    , @p_plan_type            NVARCHAR(4000)
    , @p_master_id            NVARCHAR(4000)
    , @p_division_id          NVARCHAR(30)
    , @p_engine_plan_id       NVARCHAR(4000)
    , @p_user_id              NVARCHAR(150)  = N'scp_batch'
    --, @p_engine_out_version_id nvarchar(4000) = N'1024::MA::1'
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_SET_ASSIGN_TYPE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      --상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_PLN_TABLES'; --테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    
    
    -- 임시 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    
    

    BEGIN TRY
      BEGIN
    
        /*
        Program ID   : PR_SCP_PLN_SET_ASSIGN_TYPE
        */

        ----------------------------------------------------------- 
        -- UPDATE ASSIGN TYPE ON SHIPMENT PLAN
        ----------------------------------------------------------- 
        /*
        UPDATE S
             SET assign_type = (CASE WHEN t.site_type ='SALES'    THEN 'SALES'
                                     WHEN t.osp_yn    = 'Y'       THEN 'OUT_PLANT'
                                     WHEN f.site_id = t.site_id   THEN 'IN_PLANT'
                                     ELSE 'OUT_PLANT'
                                END) 
        --SELECT *
            FROM scp_pln_shipment_plan s WITH(NOLOCK)
            INNER JOIN scm_mst_site f WITH(NOLOCK)
                    ON f.division_id = s.division_id
                   AND f.scm_site_id = s.from_site  
                   AND f.valid_yn    = 'Y'
            INNER JOIN scm_mst_site t WITH(NOLOCK)
                    ON t.division_id = s.division_id
                   AND t.scm_site_id = s.to_site    
                   AND t.valid_yn    = 'Y'
           WHERE 1=1
             AND s.division_id         = @p_division_id         --'81'         --
             AND s.plan_start_yyyymmdd = @p_plan_start_yyyymmdd --'20180702'   --
             AND s.plan_type           = @p_plan_type           --'PR'         --
             AND s.seq                 = @p_seq                 --'6'          --
             AND s.measure             = 'SHIP_PLAN'
             ;*/

        /*전극 수정 작업
          ,A.ATTRIBUTE1   --TS.SITE_TYPE
          ,A.ATTRIBUTE2   --TS.OSP_YN   
          ,A.ATTRIBUTE3   --TS.SITE_ID  
          ,A.ATTRIBUTE4   --FS.SITE_ID  
        */
        UPDATE S
           SET assign_type = (CASE WHEN s.ATTRIBUTE1 ='SALES'       THEN 'SALES'
                                   WHEN s.ATTRIBUTE2 = 'Y'          THEN 'OUT_PLANT'
                                   WHEN s.ATTRIBUTE4 = s.ATTRIBUTE3 THEN 'IN_PLANT'
                                   ELSE 'OUT_PLANT'
                              END) 
        --SELECT *
          FROM SCP_PLN_SHIPMENT_PLAN AS s WITH(NOLOCK)
         WHERE 1=1
           AND s.division_id         = @p_division_id         --'81'         --
           AND s.plan_start_yyyymmdd = @p_plan_start_yyyymmdd --'20180702'   --
           AND s.plan_type           = @p_plan_type           --'PR'         --
           AND s.seq                 = @p_seq                 --'6'          --
           AND s.measure             = 'SHIP_PLAN'
           ;
        
        ----------------------------------------------------------- 
        -- UPDATE ASSIGN TYPE ON PRODUCTION PLAN PEGGING
        ----------------------------------------------------------- 
        -- UNPEGGING DATA
        /*UPDATE scp_pln_production_plan_pegging 
           SET  in_plant_qty  = 0.0
               ,out_plant_qty = isnull(allocation_qty,0.0)
               ,sales_qty     = 0.0
               ,attribute1    = 'UNPEGGING'
         WHERE 1=1
           AND master_id            = @p_master_id            --'81::WEEKLY'    --
           AND plan_id              = @p_plan_id              --'1024'          --
           AND out_version_id       = @p_engine_plan_id       --'1024::PR::1'   --
           AND plan_type            = @p_plan_type            --'PR'            --
           AND plan_start_yyyymmdd  = @p_plan_start_yyyymmdd  --'20180430'      --
           AND seq                  = @p_seq                  --'1'             --
           AND division_id          = @p_division_id          --'81'            --
           AND eng_demand_id        = 'UNPEGGING'
           ;*/
        /* 2018년 10월 2일 주석처리
        UPDATE gg 
           SET  gg.in_plant_qty  = 0.0
               ,gg.out_plant_qty = isnull(gg.allocation_qty,0.0)
               ,gg.sales_qty     = 0.0
               ,gg.attribute1    = 'UNPEGGING'
          FROM scp_pln_production_plan AS pp WITH(NOLOCK)
         INNER JOIN scp_pln_production_plan_pegging AS gg WITH(NOLOCK)
                 ON 1=1
                AND pp.master_id            = gg.master_id
                AND pp.plan_id              = gg.plan_id
                AND pp.out_version_id       = gg.out_version_id
                AND pp.plan_type            = gg.plan_type
                AND pp.plan_start_yyyymmdd  = gg.plan_start_yyyymmdd
                AND pp.seq                  = gg.seq
                AND pp.division_id          = gg.division_id
                AND pp.work_order_id        = gg.work_order_id
                AND gg.eng_demand_id        = 'UNPEGGING'
                AND pp.operation_group      <> 'P'
         WHERE 1=1
           AND pp.master_id                 = @p_master_id            -- '81::WEEKLY'    -- 
           AND pp.plan_id                   = @p_plan_id              -- '1024'          -- 
           AND pp.out_version_id            = @p_engine_plan_id       -- '1024::PR::1'   -- 
           AND pp.plan_type                 = @p_plan_type            -- 'PR'            -- 
           AND pp.plan_start_yyyymmdd       = @p_plan_start_yyyymmdd  -- '20180430'      -- 
           AND pp.seq                       = @p_seq                  -- '1'             -- 
           AND pp.division_id               = @p_division_id          -- '81'            -- 
           ;

        -- PACK DATA
        UPDATE gg 
           SET  gg.in_plant_qty  = 0.0
               ,gg.out_plant_qty = 0.0
               ,gg.sales_qty     = isnull(gg.allocation_qty,0.0)
               ,gg.attribute1    = 'PACK'
          FROM scp_pln_production_plan AS pp WITH(NOLOCK)
         INNER JOIN scp_pln_production_plan_pegging AS gg WITH(NOLOCK)
                 ON 1=1
                AND pp.master_id            = gg.master_id
                AND pp.plan_id              = gg.plan_id
                AND pp.out_version_id       = gg.out_version_id
                AND pp.plan_type            = gg.plan_type
                AND pp.plan_start_yyyymmdd  = gg.plan_start_yyyymmdd
                AND pp.seq                  = gg.seq
                AND pp.division_id          = gg.division_id
                AND pp.work_order_id        = gg.work_order_id
                --AND gg.eng_demand_id        <> 'UNPEGGING'
                AND pp.operation_group      = 'P'
         WHERE 1=1
           AND pp.master_id                 = @p_master_id            -- '81::WEEKLY'    -- 
           AND pp.plan_id                   = @p_plan_id              -- '1024'          -- 
           AND pp.out_version_id            = @p_engine_plan_id       -- '1024::PR::1'   -- 
           AND pp.plan_type                 = @p_plan_type            -- 'PR'            -- 
           AND pp.plan_start_yyyymmdd       = @p_plan_start_yyyymmdd  -- '20180430'      -- 
           AND pp.seq                       = @p_seq                  -- '1'             -- 
           AND pp.division_id               = @p_division_id          -- '81'            -- 
           ;*/

        -- UNPEGGING DATA ,PACK DATA
        UPDATE gg 
           SET  gg.in_plant_qty  = 0.0
               ,gg.out_plant_qty = (CASE WHEN (gg.eng_demand_id   = 'UNPEGGING' AND pp.operation_group <> 'P') THEN isnull(gg.allocation_qty,0.0) ELSE 0.0 END)
               ,gg.sales_qty     = (CASE WHEN (pp.operation_group = 'P'                                      ) THEN isnull(gg.allocation_qty,0.0) ELSE 0.0 END)
               ,gg.attribute1    = (CASE WHEN (gg.eng_demand_id   = 'UNPEGGING' AND pp.operation_group <> 'P') THEN 'UNPEGGING'
                                         WHEN (pp.operation_group = 'P'                                      ) THEN 'PACK'
                                         END)
          FROM scp_pln_production_plan              AS pp WITH(NOLOCK)
         INNER JOIN scp_pln_production_plan_pegging AS gg WITH(NOLOCK)
                 ON 1=1
                AND pp.master_id            = gg.master_id
                AND pp.plan_id              = gg.plan_id
                AND pp.out_version_id       = gg.out_version_id
                AND pp.plan_type            = gg.plan_type
                AND pp.plan_start_yyyymmdd  = gg.plan_start_yyyymmdd
                AND pp.seq                  = gg.seq
                AND pp.division_id          = gg.division_id

                AND pp.work_order_id        = gg.work_order_id
                AND (gg.eng_demand_id = 'UNPEGGING' OR pp.operation_group = 'P')
         WHERE 1=1
           AND pp.master_id                 = @p_master_id            -- '81::WEEKLY'    -- 
           AND pp.plan_id                   = @p_plan_id              -- '1024'          -- 
           AND pp.out_version_id            = @p_engine_plan_id       -- '1024::PR::1'   -- 
           AND pp.plan_type                 = @p_plan_type            -- 'PR'            -- 
           AND pp.plan_start_yyyymmdd       = @p_plan_start_yyyymmdd  -- '20180430'      -- 
           AND pp.seq                       = @p_seq                  -- '1'             -- 
           AND pp.division_id               = @p_division_id          -- '81'            -- 
           ;

        --BEGIN TRANSACTION; 


        IF OBJECT_ID(N'tempdb..#Tbl_PeggingInfo') IS NOT NULL
          DROP TABLE #Tbl_PeggingInfo
          ;
        IF OBJECT_ID(N'tempdb..#Tbl_ShipInfo') IS NOT NULL
          DROP TABLE #Tbl_ShipInfo
          ;
        IF OBJECT_ID(N'tempdb..#Tbl_ProductionInfo') IS NOT NULL
          DROP TABLE #Tbl_ProductionInfo
          ;
        IF OBJECT_ID(N'tempdb..#Tbl_AssignTemp') IS NOT NULL
          DROP TABLE #Tbl_AssignTemp
          ;
         IF OBJECT_ID('tempdb..#TBL_Info') IS NOT NULL    
          DROP TABLE #TBL_Info 
          ;
         IF OBJECT_ID('tempdb..#Tbl_AssignTemp_DO') IS NOT NULL    
          DROP TABLE #Tbl_AssignTemp_DO 
          ;
        IF OBJECT_ID('tempdb..#Tbl_AssignTemp_WO') IS NOT NULL    
          DROP TABLE #Tbl_AssignTemp_WO 
          ;


        ----------------------------------------------------------- 
        -- 임시테이블 생성
        ----------------------------------------------------------- 
        --#Tbl_PeggingInfo
        SELECT pi.demand_id
              ,pi.delivery_order_id
              ,pi.work_order_id
              ,pi.to_delivery_order_id
          INTO #Tbl_PeggingInfo
          --FROM scp_eng_pegging_info_o_sn AS pi WITH(NOLOCK)
          FROM scp_eng_pegging_info_o_temp_sn AS pi WITH(NOLOCK)
         WHERE 1=1
           AND pi.plan_id        = @p_plan_id             --N'1024'
           AND pi.modeling_id    = @p_modeling_id         --N'2'
           AND pi.seq            = @p_seq                 --N'1'
           AND pi.plan_name      = @p_plan_start_yyyymmdd --N'20180430'
           AND pi.master_id      = @p_master_id           --N'81::WEEKLY'
           AND pi.out_version_id = @p_engine_plan_id      --N'1024::PR::1'
           AND pi.division_id    = @p_division_id         --N'81'
           AND pi.plan_type      = @p_plan_type           --N'PR'
           AND LEFT(isnull(pi.route_id,'') ,1) <> 'P'     --PACK 제외
           AND LEFT(isnull(pi.route_id,'') ,5) <> 'F1000' --'F1000' 제외
           ;
         --임시테이블 인덱스 생성 
         CREATE CLUSTERED INDEX XI01_#Tbl_PeggingInfo 
                             ON #Tbl_PeggingInfo (
                                                    demand_id
                                                   ,delivery_order_id
                                                   ,work_order_id
                                                   ,to_delivery_order_id
                                                 ) 
                                                 ;
        
        --#Tbl_ShipInfo
        SELECT g.eng_demand_id
              ,s.item_id 
              ,s.from_site 
              ,s.order_id 
              ,s.assign_type 
          INTO #Tbl_ShipInfo
          FROM scp_pln_shipment_plan AS s WITH(NOLOCK)
         INNER JOIN scp_pln_shipment_plan_pegging AS g WITH(NOLOCK)
                 ON 1=1
                AND s.master_id           = g.master_id
                AND s.plan_id             = g.plan_id
                AND s.out_version_id      = g.out_version_id
                AND s.plan_type           = g.plan_type
                AND s.plan_start_yyyymmdd = g.plan_start_yyyymmdd
                AND s.seq                 = g.seq
                AND s.division_id         = g.division_id
                AND s.order_id            = g.order_id
          WHERE 1=1
            AND s.master_id               = @p_master_id            --'81::WEEKLY'
            AND s.plan_id                 = @p_plan_id              --'1024'
            AND s.out_version_id          = @p_engine_plan_id       --'1024::PR::1'
            AND s.plan_type               = @p_plan_type            --'PR'
            AND s.plan_start_yyyymmdd     = @p_plan_start_yyyymmdd  --'20180430'
            AND s.seq                     = @p_seq                  --'1'
            AND s.division_id             = @p_division_id          --'81'
            AND s.measure                 = 'SHIP_PLAN'
            AND g.eng_demand_id           <> '-'
            AND s.OPERATION_GROUP         <> 'P' --PACK 제외
            ;

        --#Tbl_ProductionInfo
        SELECT gg.eng_demand_id
              ,pp.item_id 
              ,pp.site_id 
              ,gg.work_order_id
              ,gg.pegging_type
              ,gg.allocation_qty
               
              ,gg.in_plant_qty
              ,gg.out_plant_qty
              ,gg.sales_qty
              
              ,isnull(gg.attribute1,'') AS attribute1
          INTO #Tbl_ProductionInfo
          FROM scp_pln_production_plan AS pp WITH(NOLOCK)
         INNER JOIN scp_pln_production_plan_pegging AS gg WITH(NOLOCK)
                 ON 1=1
                AND pp.master_id           = gg.master_id          
                AND pp.plan_id             = gg.plan_id            
                AND pp.out_version_id      = gg.out_version_id     
                AND pp.plan_type           = gg.plan_type          
                AND pp.plan_start_yyyymmdd = gg.plan_start_yyyymmdd
                AND pp.seq                 = gg.seq                
                AND pp.division_id         = gg.division_id        
                AND gg.eng_demand_id       <> 'UNPEGGING'
                AND pp.operation_group     <> 'P'     --PACK 제외
                AND pp.operation_id        <> 'F1000' --'F1000' 공정 제외 
                AND pp.work_order_id       = gg.work_order_id
         WHERE 1=1
           AND pp.master_id                = @p_master_id            --'81::WEEKLY'      --
           AND pp.plan_id                  = @p_plan_id              --'1024'            --
           AND pp.out_version_id           = @p_engine_plan_id       --'1024::PR::1'     --
           AND pp.plan_type                = @p_plan_type            --'PR'              --
           AND pp.plan_start_yyyymmdd      = @p_plan_start_yyyymmdd  --'20180430'        --
           AND pp.seq                      = @p_seq                  --'1'               --
           AND pp.division_id              = @p_division_id          --'81'              --
           ;
        --임시테이블 인덱스 생성 
        CREATE CLUSTERED INDEX XI01_#Tbl_ProductionInfo
                            ON #Tbl_ProductionInfo (
                                                      eng_demand_id
                                                     ,work_order_id
                                                   ) 
                                                   ;
        CREATE NONCLUSTERED INDEX XI02_#Tbl_ProductionInfo
                            ON #Tbl_ProductionInfo (
                                                      eng_demand_id
                                                     ,item_id
                                                     ,site_id
                                                   ) 
                                                   ;   

        ----------------------------------------------------------- 
        -- ASSIGN_TYPE 조회
        ----------------------------------------------------------- 
        SELECT pp.work_order_id
              ,pp.eng_demand_id
              ,MAX(ss.assign_type)            AS assign_type
              ,COUNT(DISTINCT ss.assign_type) AS cnt
              ,MAX(pp.pegging_type)           AS pegging_type
              ,MAX(pp.allocation_qty)         AS allocation_qty
          INTO #Tbl_AssignTemp
          FROM #Tbl_ShipInfo AS ss 
               INNER JOIN #Tbl_ProductionInfo AS pp
                  ON ss.eng_demand_id = pp.eng_demand_id
                 AND ss.item_id       = pp.item_id
                 AND ss.from_site     = pp.site_id
         --WHERE 1=1
         GROUP BY pp.work_order_id 
                 ,pp.eng_demand_id 
         ;
        --임시테이블 인덱스 생성 
        CREATE CLUSTERED INDEX XI01_#Tbl_AssignTemp
                            ON #Tbl_AssignTemp (
                                                      work_order_id
                                                     ,eng_demand_id
                                                   ) 
                                                   ;
        
        
        ----------------------------------------------------------- 
        -- ASSIGN_TYPE 1건 조회되는 케이스 업데이트
        ----------------------------------------------------------- 
        UPDATE pp
           SET pp.in_plant_qty  = isnull(work.in_plant_qty,0.0)
              ,pp.out_plant_qty = isnull(work.out_plant_qty,0.0)
              ,pp.sales_qty     = isnull(work.sales_qty,0.0)
              ,pp.attribute1 = '1'
          --SELECT '1',*     
          FROM #Tbl_ProductionInfo AS pp 
               INNER JOIN(
                          SELECT 
                                a.work_order_id
                               ,a.eng_demand_id
                               ,a.assign_type
                               ,a.allocation_qty
                               ,(CASE a.assign_type WHEN 'IN_PLANT'  THEN isnull(a.allocation_qty,0.0) END) AS in_plant_qty
                               ,(CASE a.assign_type WHEN 'OUT_PLANT' THEN isnull(a.allocation_qty,0.0) END) AS out_plant_qty
                               ,(CASE a.assign_type WHEN 'SALES'     THEN isnull(a.allocation_qty,0.0) END) AS sales_qty
                            FROM #Tbl_AssignTemp AS a WITH(NOLOCK)
                           WHERE 1=1
                             AND a.cnt = 1 --ASSIGN_TYPE 1건 조회되는 케이스
                         ) AS work ON pp.eng_demand_id = work.eng_demand_id AND pp.work_order_id = work.work_order_id 
        WHERE 1=1
        ;


        ----------------------------------------------------------- 
        -- #TBL_Info
        -- ASSIGN_TYPE 1건 이상 나오는 케이스일경우
        -- ORDER_ID 추적
        ----------------------------------------------------------- 
        SELECT * 
          INTO #TBL_Info
          FROM (
                --'WO'영역
                SELECT 'W' AS div, a.to_delivery_order_id AS order_id ,b.work_order_id ,b.eng_demand_id
                  FROM #Tbl_PeggingInfo AS a WITH(NOLOCK)
                  JOIN #Tbl_AssignTemp  AS b WITH(NOLOCK)
                    ON a.work_order_id = b.work_order_id 
                   --AND a.demand_id     = b.eng_demand_id
                   AND a.to_delivery_order_id IS NOT NULL
                   AND b.cnt > 1
                   AND b.pegging_type  = 'WORK_ORDER'  --'WORK_ORDER' 케이스
                 UNION ALL
                SELECT 'W' ,c.to_delivery_order_id ,aa.work_order_id ,aa.eng_demand_id
                  FROM #Tbl_PeggingInfo AS c WITH(NOLOCK)
                      INNER JOIN ( SELECT a.to_delivery_order_id ,b.work_order_id ,b.eng_demand_id
                                     FROM #Tbl_PeggingInfo AS a WITH(NOLOCK)
                                     JOIN #Tbl_AssignTemp  AS b WITH(NOLOCK)
                                       ON a.work_order_id = b.work_order_id 
                                      --AND a.demand_id     = b.eng_demand_id
                                      AND a.to_delivery_order_id IS NOT NULL
                                      AND b.cnt > 1
                                      AND b.pegging_type  = 'WORK_ORDER'  --'WORK_ORDER' 케이스
                                 ) AS aa ON c.delivery_order_id = aa.to_delivery_order_id
                 WHERE c.to_delivery_order_id IS NOT NULL
                 UNION ALL
                SELECT 'W' ,d.to_delivery_order_id ,bb.work_order_id ,bb.eng_demand_id
                  FROM #Tbl_PeggingInfo AS d WITH(NOLOCK)
                       INNER JOIN ( SELECT c.to_delivery_order_id ,aa.work_order_id ,aa.eng_demand_id
                                      FROM #Tbl_PeggingInfo AS c WITH(NOLOCK)
                                          INNER JOIN ( SELECT a.to_delivery_order_id ,b.work_order_id ,b.eng_demand_id
                                                          FROM #Tbl_PeggingInfo AS a WITH(NOLOCK)
                                                          JOIN #Tbl_AssignTemp  AS b WITH(NOLOCK)
                                                            ON a.work_order_id = b.work_order_id 
                                                          --AND a.demand_id      = b.eng_demand_id
                                                          AND a.to_delivery_order_id IS NOT NULL
                                                          AND b.cnt > 1
                                                          AND b.pegging_type  = 'WORK_ORDER'  --'WORK_ORDER' 케이스
                                                      ) AS aa on c.delivery_order_id = aa.to_delivery_order_id
                                      WHERE c.to_delivery_order_id IS NOT NULL
                                  ) AS bb ON d.delivery_order_id = bb.to_delivery_order_id
                 WHERE d.to_delivery_order_id IS NOT NULL
                 UNION ALL
                SELECT 'W' ,e.to_delivery_order_id ,cc.work_order_id ,cc.eng_demand_id
                  FROM #Tbl_PeggingInfo AS e with(nolock)
                       INNER JOIN (  SELECT d.to_delivery_order_id ,bb.work_order_id ,bb.eng_demand_id
                                       FROM #Tbl_PeggingInfo AS d WITH(NOLOCK)
                                             INNER JOIN ( SELECT c.to_delivery_order_id ,aa.work_order_id ,aa.eng_demand_id
                                                           FROM #Tbl_PeggingInfo AS c WITH(NOLOCK)
                                                               INNER JOIN ( SELECT a.to_delivery_order_id ,b.work_order_id ,b.eng_demand_id
                                                                               FROM #Tbl_PeggingInfo AS a WITH(NOLOCK)
                                                                               JOIN #Tbl_AssignTemp  AS b WITH(NOLOCK)
                                                                                 ON a.work_order_id = b.work_order_id 
                                                                               --AND a.demand_id      = b.eng_demand_id
                                                                               AND a.to_delivery_order_id IS NOT NULL
                                                                               AND b.cnt > 1
                                                                               AND b.pegging_type  = 'WORK_ORDER'  --'WORK_ORDER' 케이스
                                                                           ) AS aa on c.delivery_order_id = aa.to_delivery_order_id
                                                           WHERE c.to_delivery_order_id IS NOT NULL
                                                       ) AS bb ON d.delivery_order_id = bb.to_delivery_order_id
                                       WHERE d.to_delivery_order_id IS NOT NULL
                                  ) AS cc ON e.delivery_order_id = cc.to_delivery_order_id
                 WHERE e.to_delivery_order_id IS NOT NULL
                
                --'DO'영역
                 UNION ALL 
                SELECT 'D' AS div, a.to_delivery_order_id AS order_id ,b.work_order_id ,b.eng_demand_id
                  FROM #Tbl_PeggingInfo AS a WITH(NOLOCK)
                  JOIN #Tbl_AssignTemp  AS b WITH(NOLOCK)
                    ON a.delivery_order_id = b.work_order_id 
                   --AND a.demand_id         = b.eng_demand_id
                   AND a.to_delivery_order_id IS NOT NULL
                   AND b.cnt > 1
                   AND b.pegging_type  = 'DELIVERY_ORDER'  --'DELIVERY_ORDER' 케이스
                 UNION ALL
                SELECT 'D' ,c.to_delivery_order_id ,aa.work_order_id ,aa.eng_demand_id
                  FROM #Tbl_PeggingInfo AS c WITH(NOLOCK)
                      INNER JOIN ( SELECT a.to_delivery_order_id ,b.work_order_id ,b.eng_demand_id
                                     FROM #Tbl_PeggingInfo AS a WITH(NOLOCK)
                                     JOIN #Tbl_AssignTemp  AS b WITH(NOLOCK)
                                       ON a.delivery_order_id = b.work_order_id 
                                      --AND a.demand_id         = b.eng_demand_id
                                      AND a.to_delivery_order_id IS NOT NULL
                                      AND b.cnt > 1
                                      AND b.pegging_type  = 'DELIVERY_ORDER'  --'DELIVERY_ORDER' 케이스
                                 ) AS aa ON c.delivery_order_id = aa.to_delivery_order_id
                 WHERE c.to_delivery_order_id IS NOT NULL
                 UNION ALL
                SELECT 'D' ,d.to_delivery_order_id ,bb.work_order_id ,bb.eng_demand_id
                  FROM #Tbl_PeggingInfo AS d WITH(NOLOCK)
                       INNER JOIN ( SELECT c.to_delivery_order_id ,aa.work_order_id ,aa.eng_demand_id
                                      FROM #Tbl_PeggingInfo AS c WITH(NOLOCK)
                                          INNER JOIN ( SELECT a.to_delivery_order_id ,b.work_order_id ,b.eng_demand_id
                                                          FROM #Tbl_PeggingInfo AS a WITH(NOLOCK)
                                                          JOIN #Tbl_AssignTemp  AS b WITH(NOLOCK)
                                                            ON a.delivery_order_id = b.work_order_id 
                                                          --AND a.demand_id          = b.eng_demand_id 
                                                          AND a.to_delivery_order_id IS NOT NULL
                                                          AND b.cnt > 1
                                                          AND b.pegging_type  = 'DELIVERY_ORDER'  --'DELIVERY_ORDER' 케이스
                                                      ) AS aa on c.delivery_order_id = aa.to_delivery_order_id
                                      WHERE c.to_delivery_order_id IS NOT NULL
                                  ) AS bb ON d.delivery_order_id = bb.to_delivery_order_id
                 WHERE d.to_delivery_order_id IS NOT NULL
                
              ) X
              ;
        

        ----------------------------------------------------------- 
        -- ASSIGN_TYPE 2건이상 조회되는 케이스 업데이트
        -- DO 추적쿼리 
        ----------------------------------------------------------- 
        --drop table #Tbl_AssignTemp_DO
        SELECT b.work_order_id
              ,b.eng_demand_id
              ,a.assign_type
              ,MAX(c.cnt) AS cnt
              ,(CASE a.assign_type WHEN 'IN_PLANT'  THEN ISNULL(MAX(b.allocation_qty),0.0) ELSE 0.0 END) AS in_plant_qty
              ,(CASE a.assign_type WHEN 'OUT_PLANT' THEN ISNULL(MAX(b.allocation_qty),0.0) ELSE 0.0 END) AS out_plant_qty
              ,(CASE a.assign_type WHEN 'SALES'     THEN ISNULL(MAX(b.allocation_qty),0.0) ELSE 0.0 END) AS sales_qty
          INTO #Tbl_AssignTemp_DO
          FROM #Tbl_ShipInfo        AS a WITH(NOLOCK)
              ,#Tbl_ProductionInfo  AS b WITH(NOLOCK)
              ,#Tbl_AssignTemp      AS c WITH(NOLOCK)
              ,#TBL_Info            AS d WITH(NOLOCK)
         WHERE 1=1
                                    
           AND a.eng_demand_id     = b.eng_demand_id
           AND a.from_site         = b.site_id
           AND a.item_id           = b.item_id
                                                     
           AND c.cnt               > 1                 --ASSIGN_TYPE 2건 조회되는 케이스
           AND c.pegging_type      = 'DELIVERY_ORDER'  --'DELIVERY_ORDER' 케이스
           AND b.work_order_id     = c.work_order_id
           AND b.eng_demand_id     = c.eng_demand_id
                                                     
           AND a.order_id          = d.order_id
           AND c.work_order_id     = d.work_order_id
           AND c.eng_demand_id     = d.eng_demand_id
           AND d.div               = 'D'
         GROUP BY b.work_order_id 
                 ,b.eng_demand_id 
                 ,a.assign_type
                 ;
        
        -- 업데이트
        UPDATE pp
           SET pp.in_plant_qty = isnull(a.in_plant_qty ,0.0)
              ,pp.attribute1    = 'DO' 
          FROM #Tbl_ProductionInfo            AS pp 
               INNER JOIN #Tbl_AssignTemp_DO  AS a 
                  ON pp.eng_demand_id = a.eng_demand_id AND pp.work_order_id = a.work_order_id AND a.assign_type = 'IN_PLANT'
        WHERE 1=1
        ;
        UPDATE pp
           SET pp.in_plant_qty  = (CASE WHEN isnull(pp.in_plant_qty ,0.0) > 0.0 THEN a.out_plant_qty/2 ELSE 0.0 END)
              ,pp.out_plant_qty = (CASE WHEN isnull(pp.in_plant_qty ,0.0) > 0.0 THEN a.out_plant_qty/2 ELSE a.out_plant_qty END)
              ,pp.attribute1    = 'DO' 
          FROM #Tbl_ProductionInfo            AS pp 
               INNER JOIN #Tbl_AssignTemp_DO  AS a 
                  ON pp.eng_demand_id = a.eng_demand_id AND pp.work_order_id = a.work_order_id AND a.assign_type = 'OUT_PLANT'
        WHERE 1=1
        ;
        UPDATE pp
           SET pp.in_plant_qty  = (CASE WHEN (isnull(pp.in_plant_qty ,0.0) > 0.0 AND isnull(pp.out_plant_qty ,0.0) > 0.0) THEN a.sales_qty/3 
                                        WHEN (isnull(pp.in_plant_qty ,0.0) > 0.0) THEN a.sales_qty/2
                                        ELSE 0.0
                                        END)
              ,pp.out_plant_qty = (CASE WHEN (isnull(pp.in_plant_qty ,0.0) > 0.0 AND isnull(pp.out_plant_qty ,0.0) > 0.0) THEN a.sales_qty/3 
                                        WHEN (isnull(pp.out_plant_qty ,0.0) > 0.0) THEN a.sales_qty/2
                                        ELSE 0.0
                                        END)
              ,pp.sales_qty     = (CASE WHEN (isnull(pp.in_plant_qty ,0.0) > 0.0 AND isnull(pp.out_plant_qty ,0.0) > 0.0) THEN a.sales_qty/3 
                                        WHEN (isnull(pp.in_plant_qty ,0.0) > 0.0  OR isnull(pp.out_plant_qty ,0.0) > 0.0) THEN a.sales_qty/2
                                        ELSE a.sales_qty
                                        END)
              ,pp.attribute1    = 'DO' 
          FROM #Tbl_ProductionInfo            AS pp 
               INNER JOIN #Tbl_AssignTemp_DO  AS a 
                  ON pp.eng_demand_id = a.eng_demand_id AND pp.work_order_id = a.work_order_id AND a.assign_type = 'SALES'
        WHERE 1=1
        ;

        
        ----------------------------------------------------------- 
        -- ASSIGN_TYPE 2건이상 조회되는 케이스 업데이트
        -- WO 추적쿼리
        ----------------------------------------------------------- 
        --drop table #Tbl_AssignTemp_WO
        SELECT b.work_order_id
              ,b.eng_demand_id
              ,a.assign_type
              ,MAX(c.cnt) AS cnt
              ,(CASE a.assign_type WHEN 'IN_PLANT'  THEN ISNULL(MAX(b.allocation_qty),0.0) ELSE 0.0 END) AS in_plant_qty
              ,(CASE a.assign_type WHEN 'OUT_PLANT' THEN ISNULL(MAX(b.allocation_qty),0.0) ELSE 0.0 END) AS out_plant_qty
              ,(CASE a.assign_type WHEN 'SALES'     THEN ISNULL(MAX(b.allocation_qty),0.0) ELSE 0.0 END) AS sales_qty
          INTO #Tbl_AssignTemp_WO
          FROM #Tbl_ShipInfo        AS a WITH(NOLOCK)
              ,#Tbl_ProductionInfo  AS b WITH(NOLOCK)
              ,#Tbl_AssignTemp      AS c WITH(NOLOCK)
              ,#TBL_Info            AS d WITH(NOLOCK)
         WHERE 1=1
                                    
           AND a.eng_demand_id     = b.eng_demand_id
           AND a.from_site         = b.site_id
           AND a.item_id           = b.item_id
                                                   
           AND c.cnt             > 1                 --ASSIGN_TYPE 2건 조회되는 케이스
           AND c.pegging_type    = 'WORK_ORDER'      --'WORK_ORDER' 케이스
           AND b.work_order_id   = c.work_order_id
           AND b.eng_demand_id   = c.eng_demand_id
                                                   
           AND a.order_id        = d.order_id
           AND c.work_order_id   = d.work_order_id
           AND c.eng_demand_id   = d.eng_demand_id
           AND d.div             = 'W'
         GROUP BY b.work_order_id 
                 ,b.eng_demand_id 
                 ,a.assign_type
                 ;
        
        -- 업데이트
        UPDATE pp
           SET pp.in_plant_qty  = isnull(a.in_plant_qty ,0.0)
              ,pp.attribute1    = 'WO' 
          FROM #Tbl_ProductionInfo            AS pp 
               INNER JOIN #Tbl_AssignTemp_WO  AS a 
                  ON pp.eng_demand_id = a.eng_demand_id AND pp.work_order_id = a.work_order_id AND a.assign_type = 'IN_PLANT'
        WHERE 1=1
        ;
        UPDATE pp
           SET pp.in_plant_qty  = (CASE WHEN isnull(pp.in_plant_qty ,0.0) > 0.0 THEN a.out_plant_qty/2 ELSE 0.0 END)
              ,pp.out_plant_qty = (CASE WHEN isnull(pp.in_plant_qty ,0.0) > 0.0 THEN a.out_plant_qty/2 ELSE a.out_plant_qty END)
              ,pp.attribute1    = 'WO' 
          FROM #Tbl_ProductionInfo            AS pp 
               INNER JOIN #Tbl_AssignTemp_WO  AS a 
                  ON pp.eng_demand_id = a.eng_demand_id AND pp.work_order_id = a.work_order_id AND a.assign_type = 'OUT_PLANT'
        WHERE 1=1
        ;
        UPDATE pp
           SET pp.in_plant_qty  = (CASE WHEN (isnull(pp.in_plant_qty ,0.0) > 0.0 AND isnull(pp.out_plant_qty ,0.0) > 0.0) THEN a.sales_qty/3 
                                        WHEN (isnull(pp.in_plant_qty ,0.0) > 0.0) THEN a.sales_qty/2
                                        ELSE 0.0
                                        END)
              ,pp.out_plant_qty = (CASE WHEN (isnull(pp.in_plant_qty ,0.0) > 0.0 AND isnull(pp.out_plant_qty ,0.0) > 0.0) THEN a.sales_qty/3 
                                        WHEN (isnull(pp.out_plant_qty ,0.0) > 0.0) THEN a.sales_qty/2
                                        ELSE 0.0
                                        END)
              ,pp.sales_qty     = (CASE WHEN (isnull(pp.in_plant_qty ,0.0) > 0.0 AND isnull(pp.out_plant_qty ,0.0) > 0.0) THEN a.sales_qty/3 
                                        WHEN (isnull(pp.in_plant_qty ,0.0) > 0.0  OR isnull(pp.out_plant_qty ,0.0) > 0.0) THEN a.sales_qty/2
                                        ELSE a.sales_qty
                                        END)
              ,pp.attribute1    = 'WO' 
          FROM #Tbl_ProductionInfo            AS pp 
               INNER JOIN #Tbl_AssignTemp_WO  AS a 
                  ON pp.eng_demand_id = a.eng_demand_id AND pp.work_order_id = a.work_order_id AND a.assign_type = 'SALES'
        WHERE 1=1
        ;

        
        ----------------------------------------------------------- 
        -- ASSIGN_TYPE 미매칭 케이스 업데이트
        ----------------------------------------------------------- 
        UPDATE pp
           SET pp.in_plant_qty  = 0.0
              ,pp.out_plant_qty = isnull(pp.allocation_qty,0.0)
              ,pp.sales_qty     = 0.0
              
              ,pp.attribute1 = 'NONE' --포함 케이스 없음
        --select *
          FROM #Tbl_ProductionInfo AS pp 
        WHERE 1=1
          --AND (pp.in_plant_qty = 0.0 AND pp.out_plant_qty = 0.0 AND pp.sales_qty = 0.0)
          AND (pp.attribute1 <> '1' AND pp.attribute1 <> 'DO' AND pp.attribute1 <> 'WO')
        ;


        ----------------------------------------------------------- 
        -- SCP_PLN_PRODUCTION_PLAN_PEGGING 업데이트
        ----------------------------------------------------------- 
        UPDATE X
           SET X.in_plant_qty  = isnull(Y.in_plant_qty,0.0)
              ,X.out_plant_qty = isnull(Y.out_plant_qty,0.0)
              ,X.sales_qty     = isnull(Y.sales_qty,0.0)
              ,X.attribute1    = Y.attribute1
        FROM scp_pln_production_plan_pegging X
        JOIN #Tbl_ProductionInfo Y
        ON 1=1   
          AND X.eng_demand_id         = Y.eng_demand_id
          AND X.work_order_id         = Y.work_order_id
         WHERE 0 = 0
          AND X.master_id             = @p_master_id            --N'81::WEEKLY'
          AND X.plan_id               = @p_plan_id              --N'1024'
          AND X.out_version_id        = @p_engine_plan_id       --N'1024::PR::1'
          AND X.plan_type             = @p_plan_type            --N'PR'
          AND X.plan_start_yyyymmdd   = @p_plan_start_yyyymmdd  --N'20180430'
          AND X.seq                   = @p_seq                  --N'1'
          AND X.division_id           = @p_division_id          --N'8

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
        IF OBJECT_ID(N'tempdb..#Tbl_PeggingInfo') IS NOT NULL
          DROP TABLE #Tbl_PeggingInfo
          ;
        IF OBJECT_ID(N'tempdb..#Tbl_ShipInfo') IS NOT NULL
          DROP TABLE #Tbl_ShipInfo
          ;
        IF OBJECT_ID(N'tempdb..#Tbl_ProductionInfo') IS NOT NULL
          DROP TABLE #Tbl_ProductionInfo
          ;
        IF OBJECT_ID(N'tempdb..#Tbl_AssignTemp') IS NOT NULL
          DROP TABLE #Tbl_AssignTemp
          ;
         IF OBJECT_ID('tempdb..#TBL_Info') IS NOT NULL    
          DROP TABLE #TBL_Info 
          ;
         IF OBJECT_ID('tempdb..#Tbl_AssignTemp_DO') IS NOT NULL    
          DROP TABLE #Tbl_AssignTemp_DO 
          ;
        IF OBJECT_ID('tempdb..#Tbl_AssignTemp_WO') IS NOT NULL    
          DROP TABLE #Tbl_AssignTemp_WO 
          ;
        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    --로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'UPDATE '+@v_table_id;
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

     -- 임시 운영반영시에 주석처리 할것.    
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
    
    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'' + '[' + @p_division_id + ']' + '[' +  @p_engine_plan_id + '][' +@v_exec_time + ']'    
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

