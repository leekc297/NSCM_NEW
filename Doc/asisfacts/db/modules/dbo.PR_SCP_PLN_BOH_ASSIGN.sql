  
  
--  select * from PLAN_V
  
/*      
 * Program ID   : PR_SCP_PLN_BOH_ASSIGN        
 * Description  : PR_SCP_PLN_CREATE_DATA 에서 호출함.      
 * OutTable     :      
 * Execute      :     
   EXEC PR_SCP_PLN_BOH_ASSIGN   @p_plan_cycle          ='WEEKLY'  
                              , @p_plan_start_yyyymmdd ='20180618'     
                              , @p_plan_id             ='1031'     
                              , @p_modeling_id         ='2'            
                              , @p_seq                 ='7'  
                              , @p_plan_type           ='PR'      
                              , @p_master_id           ='81::WEEKLY'   
                              , @p_division_id         ='81'       
                              , @p_engine_plan_id      ='1031::PR::7'  
                              , @p_user_id             = 'KTH'  
  
 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2018.04.17   KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트   
 * 2018.04.18   yydok       전극에 대해서 E~002,E~003 STOCK_PLAN_LOT_ID의 재고가 출하되는 것만 대상으로 변경    
 * 2018.06.07   KTH         TRANSACTION 삭제  
 * 2018.06.08   KTH         SCP_ENG_PEGGING_INFO_O_TEMP 사용 로직으로 변경,  
 * 2018.06.27   KTH         전극 SCP 반영(ORIGIN_DIVISION_ID,ELECTRODE_TYPE) 추가, VALID_YN ='Y' 추가
 * 2018.07.04   KTH         SCP_MST_FINAL_ITEM_V로 변경  
 * 2018.07.09   KTH         TEMP 테이블 변경으로 로직 수정
 * 2018.08.28   KTH         PACK 일경우 ASSIGN_TYPE 'SALES'로 FIX
 * 2018.08.29   KTH         ASSIGN_QTY 보정로직 추가 (PSI_BOH_QTY로)
 */  
       
CREATE PROCEDURE [dbo].[PR_SCP_PLN_BOH_ASSIGN]        
(         
      @p_plan_cycle            NVARCHAR(150)          
    , @p_plan_start_yyyymmdd  NVARCHAR(8)          
    , @p_plan_id              NVARCHAR(4000)          
    , @p_modeling_id          NVARCHAR(4000)          
    , @p_seq                  NVARCHAR(4000)          
    , @p_plan_type            NVARCHAR(4000)          
    , @p_master_id            NVARCHAR(4000)          
    , @p_division_id          NVARCHAR(30)          
    , @p_engine_plan_id       NVARCHAR(4000)          
    , @p_user_id              NVARCHAR(150)  = 'scp_batch'          
    ---- , @p_debug       INT OUTPUT        
)         
AS        
  BEGIN        
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;        
    SET NOCOUNT ON;        
    SET XACT_ABORT ON;        
    SET ANSI_WARNINGS OFF;        
        
    -- LOG 용 변수 설정        
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';          
    SET @v_batch_user = @p_user_id        
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_BOH_ASSIGN';        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...        
    DECLARE @n_log_count    INTEGER = 0;        
    DECLARE @v_log_message  NVARCHAR(1000);        
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';     
    DECLARE @d_event_date   DATETIME;        
        
  -- 시작 LOG        
    SET @v_log_type = N'START';        
    SET @v_log_message = N'########## Start of procedure ##########';        
    SET @v_description = @v_program_name + ':' + N' SCP_PLN_BOH_ASSIGN INSERT LOGIC';        
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
        --BEGIN TRAN T1        
            -------------------------------------------------------------------------------------------------------------         
            -- 0 #tmp_SCP_PLN_BOH_ASSIGN 생성  
            -------------------------------------------------------------------------------------------------------------         
              SELECT  SUB.MASTER_ID    
                     ,SUB.PLAN_ID    
                     ,SUB.OUT_VERSION_ID    
                     ,SUB.DIVISION_ID    
                     ,SUB.PLAN_NAME     AS PLAN_START_YYYYMMDD    
                     ,SUB.PLAN_TYPE    
                     ,SUB.SEQ    
                     ,SUB.SCM_SITE_ID    
                     ,SUB.ITEM_ID    
                     ,SUB.ASSIGN_TYPE    
                     ,SUB.ORIGIN_DIVISION_ID  
                     ,SUB.ELECTRODE_TYPE  
                     ,SUM(QTY)          AS ASSIGN_QTY    
              INTO #tmp_SCP_PLN_BOH_ASSIGN  
              FROM     
              (    
               /*
              ,ATTRIBUTE1  --TS.SITE_TYPE
              ,ATTRIBUTE2  --TS.OSP_YN
              ,ATTRIBUTE3  --TS.SITE_ID
              ,ATTRIBUTE4  --FS.SITE_ID
              */
              -- 셀 003사이트에서 출하    
                SELECT P.MASTER_ID    
                      ,P.PLAN_ID    
                      ,P.OUT_VERSION_ID    
                      ,P.DIVISION_ID    
                      ,P.PLAN_NAME    
                      ,P.PLAN_TYPE    
                      ,P.SEQ    
                      ,P.SCM_FROM_SITE_ID     AS SCM_SITE_ID
                      ,P.FROM_ITEM_ID         AS ITEM_ID   
                      ,CASE WHEN P.ATTRIBUTE1 = 'SALES'                                     THEN 'SALES'    
                            WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE2  =  'Y'            THEN 'OUT_PLANT'    
                            WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  <> P.ATTRIBUTE4   THEN 'OUT_PLANT'    
                            WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  =  P.ATTRIBUTE4   THEN 'IN_PLANT'    
                            ELSE '-'    
                       END          AS ASSIGN_TYPE    
                      ,P.ORIGIN_FROM_DIVISION_ID AS ORIGIN_DIVISION_ID
                      ,P.ELECTRODE_TYPE  
                       ,SUM(P.QTY)     AS QTY                         
--                  FROM SCP_ENG_PEGGING_INFO_O_SN P WITH(NOLOCK),    
                  FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN P WITH(NOLOCK)                   
                 WHERE 0 = 0    
                   AND P.MASTER_ID                  = @p_master_id    
                   AND P.PLAN_ID                    = @p_plan_id    
                   AND P.OUT_VERSION_ID             = @p_engine_plan_id  
                   AND P.DIVISION_ID                = @p_division_id    
                   AND P.PLAN_NAME                  = @p_plan_start_yyyymmdd    
                   AND P.PLAN_TYPE                  = @p_plan_type    
                   AND P.SEQ                        = @p_seq    
                   AND P.TO_DELIVERY_ORDER_ID       IS NOT NULL    
                   AND P.BOD_ID                     IS NOT NULL    
                   AND P.STOCK_PLAN_LOT_ID          IS NOT NULL    
                   AND P.STOCK_PLAN_LOT_ID          <> 'FIXED_NOH'    
                   AND P.STOCK_PLAN_LOT_ID        LIKE 'WH%A~003%'    
                   AND P.DIVISION_ID                = @p_division_id    
                   AND P.OPERATION_GROUP            ='A'    
                 GROUP BY P.MASTER_ID    
                        ,P.PLAN_ID    
                        ,P.OUT_VERSION_ID    
                        ,P.DIVISION_ID    
                        ,P.PLAN_NAME    
                        ,P.PLAN_TYPE    
                        ,P.SEQ    
                        ,P.SCM_FROM_SITE_ID    
                        ,P.FROM_ITEM_ID    
                        ,CASE WHEN P.ATTRIBUTE1 = 'SALES'                                     THEN 'SALES'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE2  =  'Y'            THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  <> P.ATTRIBUTE4   THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  =  P.ATTRIBUTE4   THEN 'IN_PLANT'    
                            ELSE '-'    
                         END      
                        ,P.ORIGIN_FROM_DIVISION_ID 
                        ,P.ELECTRODE_TYPE  
                UNION ALL    
                -- 셀 002사이트에서 출하     
                -- CELL 002 사이트 출하    
                -- CASE : INPLANT ONLY    
                SELECT P.MASTER_ID    
                      ,P.PLAN_ID    
                      ,P.OUT_VERSION_ID    
                      ,P.DIVISION_ID    
                      ,P.PLAN_NAME    
                      ,P.PLAN_TYPE    
                      ,P.SEQ    
                      ,P.SCM_FROM_SITE_ID    
                      ,FROM_ITEM_ID AS ITEM_ID    
                       -- IN_PLANT,OUT_PLANT,SALES    
                      ,CASE WHEN P.ATTRIBUTE1 = 'SALES'                                     THEN 'SALES'    
                            WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE2  =  'Y'            THEN 'OUT_PLANT'    
                            WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  <> P.ATTRIBUTE4   THEN 'OUT_PLANT'    
                            WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  =  P.ATTRIBUTE4   THEN 'IN_PLANT'    
                          ELSE '-'    
                       END  AS ASSIGN_TYPE    
                      ,P.ORIGIN_FROM_DIVISION_ID AS ORIGIN_DIVISION_ID
                      ,P.ELECTRODE_TYPE  
                      ,SUM(P.QTY) AS QTY    
--                  FROM SCP_ENG_PEGGING_INFO_O_SN P WITH(NOLOCK),    
                  FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN P WITH(NOLOCK)
                WHERE  0 = 0    
                   AND P.MASTER_ID                              = @p_master_id    
                   AND P.PLAN_ID                                = @p_plan_id    
                   AND P.OUT_VERSION_ID                         = @p_engine_plan_id    
                   AND P.DIVISION_ID                            = @p_division_id    
                   AND P.PLAN_NAME                              = @p_plan_start_yyyymmdd    
                   AND P.PLAN_TYPE                              = @p_plan_type    
                   AND P.SEQ                                    = @p_seq    
                   AND P.TO_DELIVERY_ORDER_ID                   IS NOT NULL    
                   AND P.BOD_ID                                 IS NOT NULL    
                   AND P.STOCK_PLAN_LOT_ID                      IS NOT NULL    
                   AND P.STOCK_PLAN_LOT_ID                      <> 'FIXED_NOH'    
                   AND P.STOCK_PLAN_LOT_ID                    LIKE 'WH%A~002%'    
                   AND P.DIVISION_ID                            = @p_division_id   
                   AND P.OPERATION_GROUP                        = 'A'    
                   AND P.TO_SITE_ID                       NOT LIKE '%A~003'    
                GROUP BY P.MASTER_ID    
                        ,P.PLAN_ID    
                        ,P.OUT_VERSION_ID    
                        ,P.DIVISION_ID    
                        ,P.PLAN_NAME    
                        ,P.PLAN_TYPE    
                        ,P.SEQ    
                        ,P.SCM_FROM_SITE_ID 
                        ,P.FROM_ITEM_ID    
                        ,CASE WHEN P.ATTRIBUTE1 = 'SALES'    THEN 'SALES'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE2  =  'Y'            THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  <> P.ATTRIBUTE4   THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  =  P.ATTRIBUTE4   THEN 'IN_PLANT'    
                            ELSE '-'    
                         END  
                        ,P.ORIGIN_FROM_DIVISION_ID 
                        ,P.ELECTRODE_TYPE 
    
                UNION ALL    
                -- CELL 002 사이트 출하    
                -- CASE : NEXT DELIVERY ORDER에서 유형을 알수있는 것.    
                SELECT   P.MASTER_ID    
                        ,P.PLAN_ID    
                        ,P.OUT_VERSION_ID    
                        ,P.DIVISION_ID    
                        ,P.PLAN_NAME    
                        ,P.PLAN_TYPE    
                        ,P.SEQ    
                        ,P.SCM_FROM_SITE_ID 
                        ,P.FROM_ITEM_ID     AS ITEM_ID    
                       -- IN_PLANT,OUT_PLANT,SALES    
                       ,CASE WHEN P.ATTRIBUTE1 = 'SALES'                                     THEN 'SALES'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE2  =  'Y'            THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  <> P.ATTRIBUTE4   THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  =  P.ATTRIBUTE4   THEN 'IN_PLANT'    
                            ELSE '-'    
                         END AS ASSIGN_TYPE    
                        ,P.ORIGIN_FROM_DIVISION_ID AS ORIGIN_DIVISION_ID
                        ,P.ELECTRODE_TYPE  
                        ,SUM(P.QTY) AS QTY    
--                  FROM SCP_ENG_PEGGING_INFO_O_SN P WITH(NOLOCK),    
                  FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN P WITH(NOLOCK)
               WHERE  0 = 0    
                   AND P.MASTER_ID                              = @p_master_id    
                   AND P.PLAN_ID                                = @p_plan_id    
                   AND P.OUT_VERSION_ID                         = @p_engine_plan_id    
                   AND P.DIVISION_ID                            = @p_division_id    
                   AND P.PLAN_NAME                              = @p_plan_start_yyyymmdd    
                   AND P.PLAN_TYPE                              = @p_plan_type    
                   AND P.SEQ                                    = @p_seq    
                   AND P.TO_DELIVERY_ORDER_ID                   IS NOT NULL    
                   AND P.BOD_ID                                 IS NOT NULL    
                --   AND P.STOCK_PLAN_LOT_ID                    IS NULL    
                   AND P.DIVISION_ID                            = @p_division_id    
                   AND P.OPERATION_GROUP                        = 'A'    
                   --AND P.TO_SITE_ID                        LIKE '%A~003'    
                   AND P.DELIVERY_ORDER_ID IN    
                                           (    
                                            SELECT P.TO_DELIVERY_ORDER_ID    
                                              FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN P WITH(NOLOCK)
                                             WHERE  P.MASTER_ID                             = @p_master_id    
                                               AND P.PLAN_ID                                = @p_plan_id    
                                               AND P.OUT_VERSION_ID                         = @p_engine_plan_id  
                                               AND P.DIVISION_ID                            = @p_division_id    
                                               AND P.PLAN_NAME                              = @p_plan_start_yyyymmdd    
                                               AND P.PLAN_TYPE                              = @p_plan_type    
                                               AND P.SEQ                                    = @p_seq    
                                               AND P.TO_DELIVERY_ORDER_ID                   IS NOT NULL    
                                               AND P.BOD_ID                                 IS NOT NULL    
                                               AND P.STOCK_PLAN_LOT_ID                      IS NOT NULL    
                                               AND P.STOCK_PLAN_LOT_ID                      <> 'FIXED_NOH'    
                                               AND P.STOCK_PLAN_LOT_ID                    LIKE 'WH%A~002%'    
                                               AND P.DIVISION_ID                            = @p_division_id    
                                               AND P.OPERATION_GROUP                     = 'A'    
                                               AND P.TO_SITE_ID                           LIKE '%A~003'    
                                           )    
                GROUP BY P.MASTER_ID    
                        ,P.PLAN_ID    
                        ,P.OUT_VERSION_ID    
                        ,P.DIVISION_ID    
                        ,P.PLAN_NAME    
                        ,P.PLAN_TYPE    
                        ,P.SEQ    
                        ,P.SCM_FROM_SITE_ID   
                        ,P.FROM_ITEM_ID    
                        ,CASE WHEN P.ATTRIBUTE1 = 'SALES'                                     THEN 'SALES'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE2  =  'Y'            THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  <> P.ATTRIBUTE4   THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  =  P.ATTRIBUTE4   THEN 'IN_PLANT'    
                            ELSE '-'    
                         END     
                        ,P.ORIGIN_FROM_DIVISION_ID 
                        ,P.ELECTRODE_TYPE  
                UNION ALL    
     
                -- 팩 사이트 출하    
                SELECT  P.MASTER_ID    
                        ,P.PLAN_ID    
                        ,P.OUT_VERSION_ID    
                        ,P.DIVISION_ID    
                        ,P.PLAN_NAME    
                        ,P.PLAN_TYPE    
                        ,P.SEQ    
                        ,P.SCM_FROM_SITE_ID    
                        ,FROM_ITEM_ID AS ITEM_ID    
                       -- IN_PLANT,OUT_PLANT,SALES    
                        --,CASE WHEN P.ATTRIBUTE1 = 'SALES'                                     THEN 'SALES'    
                        --      WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE2  =  'Y'            THEN 'OUT_PLANT'    
                        --      WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  <> P.ATTRIBUTE4   THEN 'OUT_PLANT'    
                        --      WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  =  P.ATTRIBUTE4   THEN 'SALES'    --IN_PLANT'    
                        --    ELSE '-'    
                        -- END  AS ASSIGN_TYPE    
                        ,'SALES' AS ASSIGN_TYPE    
                        ,P.ORIGIN_FROM_DIVISION_ID AS ORIGIN_DIVISION_ID
                        ,P.ELECTRODE_TYPE  
                        ,SUM(P.QTY) AS QTY    
--                  FROM SCP_ENG_PEGGING_INFO_O_SN P WITH(NOLOCK),    
                  FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN P WITH(NOLOCK)
                WHERE  0 = 0    
                   AND P.MASTER_ID                              = @p_master_id    
                   AND P.PLAN_ID                                = @p_plan_id    
                   AND P.OUT_VERSION_ID                         = @p_engine_plan_id   
                   AND P.DIVISION_ID                            = @p_division_id    
                   AND P.PLAN_NAME               = @p_plan_start_yyyymmdd    
                   AND P.PLAN_TYPE                              = @p_plan_type    
                   AND P.SEQ                                    = @p_seq    
                   AND P.TO_DELIVERY_ORDER_ID                   IS NOT NULL    
                   AND P.BOD_ID                                 IS NOT NULL    
                   AND P.STOCK_PLAN_LOT_ID                      IS NOT NULL    
                   AND P.STOCK_PLAN_LOT_ID                      <> 'FIXED_NOH'    
                   AND P.STOCK_PLAN_LOT_ID                    LIKE 'WH%P~%'    
                   AND P.DIVISION_ID                            = @p_division_id    
                   AND P.OPERATION_GROUP                        = 'P'    
                GROUP BY P.MASTER_ID    
                        ,P.PLAN_ID    
                        ,P.OUT_VERSION_ID    
                        ,P.DIVISION_ID    
                        ,P.PLAN_NAME    
                        ,P.PLAN_TYPE    
                        ,P.SEQ    
                        ,P.SCM_FROM_SITE_ID    
                        ,P.FROM_ITEM_ID    
                        --,CASE WHEN P.ATTRIBUTE1 = 'SALES'                                     THEN 'SALES'    
                        --      WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE2  =  'Y'            THEN 'OUT_PLANT'    
                        --      WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  <> P.ATTRIBUTE4   THEN 'OUT_PLANT'    
                        --      WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  =  P.ATTRIBUTE4   THEN 'SALES'    --IN_PLANT'  
                        --    ELSE '-'    
                        -- END   
                        ,P.ORIGIN_FROM_DIVISION_ID
                        ,P.ELECTRODE_TYPE  
     
                UNION ALL    
                -- 전극 사이트 출하    
                -- E-002에서 003안가고 바로 출하되는 것    
                SELECT   P.MASTER_ID    
                        ,P.PLAN_ID    
                        ,P.OUT_VERSION_ID    
                        ,P.DIVISION_ID    
                        ,P.PLAN_NAME    
                        ,P.PLAN_TYPE    
                        ,P.SEQ    
                        ,P.SCM_FROM_SITE_ID    
                        ,P.FROM_ITEM_ID    AS ITEM_ID    
                       -- IN_PLANT,OUT_PLANT,SALES    
                        ,CASE WHEN P.ATTRIBUTE1 = 'SALES'                                     THEN 'SALES'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE2  =  'Y'            THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  <> P.ATTRIBUTE4   THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  =  P.ATTRIBUTE4   THEN 'IN_PLANT'    
                            ELSE '-'    
                         END  AS ASSIGN_TYPE    
                        ,P.ORIGIN_FROM_DIVISION_ID AS ORIGIN_DIVISION_ID
                        ,P.ELECTRODE_TYPE  
                        ,SUM(P.QTY) AS QTY    
                --SELECT P.*    
--                  FROM SCP_ENG_PEGGING_INFO_O_SN P WITH(NOLOCK),    
                  FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN P WITH(NOLOCK)
                WHERE  0 = 0    
                   AND P.MASTER_ID                              = @p_master_id    
                   AND P.PLAN_ID                                = @p_plan_id    
                   AND P.OUT_VERSION_ID                         = @p_engine_plan_id   
                   AND P.DIVISION_ID                            = @p_division_id    
                   AND P.PLAN_NAME                              = @p_plan_start_yyyymmdd    
                   AND P.PLAN_TYPE                              = @p_plan_type    
                   AND P.SEQ                                    = @p_seq    
                   AND P.TO_DELIVERY_ORDER_ID                   IS NOT NULL    
                 AND P.BOD_ID                                 IS NOT NULL    
                   AND P.STOCK_PLAN_LOT_ID                      IS NOT NULL    
                   AND P.STOCK_PLAN_LOT_ID                      <> 'FIXED_NOH'    
                   AND P.STOCK_PLAN_LOT_ID                    LIKE 'WH%E~002%'    
                   AND P.DIVISION_ID                            = @p_division_id    
                   AND P.OPERATION_GROUP                        = 'E'    
                   AND P.TO_SITE_ID                      NOT LIKE '%E~003'    
                GROUP BY P.MASTER_ID    
                        ,P.PLAN_ID    
                        ,P.OUT_VERSION_ID    
                        ,P.DIVISION_ID    
                        ,P.PLAN_NAME    
                        ,P.PLAN_TYPE    
                        ,P.SEQ    
                        ,P.SCM_FROM_SITE_ID    
                        ,FROM_ITEM_ID    
                        ,CASE WHEN P.ATTRIBUTE1 = 'SALES'                                     THEN 'SALES'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE2  =  'Y'            THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  <> P.ATTRIBUTE4   THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  =  P.ATTRIBUTE4   THEN 'IN_PLANT'    
                            ELSE '-'    
                         END   
                        ,P.ORIGIN_FROM_DIVISION_ID
                        ,P.ELECTRODE_TYPE  
                -- E~002에서 재고가 이동한후에 E~003에서출하하는 전극    
                UNION ALL    
                SELECT   P.MASTER_ID    
                        ,P.PLAN_ID    
                        ,P.OUT_VERSION_ID    
                        ,P.DIVISION_ID    
                        ,P.PLAN_NAME    
                        ,P.PLAN_TYPE    
                        ,P.SEQ    
                        ,P.SCM_FROM_SITE_ID    
                        ,P.FROM_ITEM_ID AS ITEM_ID    
                       -- IN_PLANT,OUT_PLANT,SALES    
                        ,CASE WHEN P.ATTRIBUTE1 = 'SALES'                                     THEN 'SALES'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE2  =  'Y'            THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  <> P.ATTRIBUTE4   THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  =  P.ATTRIBUTE4   THEN 'IN_PLANT'    
                            ELSE '-'    
                         END AS ASSIGN_TYPE
                        ,P.ORIGIN_FROM_DIVISION_ID AS ORIGIN_DIVISION_ID    
                        ,P.ELECTRODE_TYPE  
                        ,SUM(P.QTY) AS QTY    
--                  FROM SCP_ENG_PEGGING_INFO_O_SN P WITH(NOLOCK),    
                  FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN P WITH(NOLOCK)
                WHERE  0 = 0    
                   AND P.MASTER_ID                              = @p_master_id    
                   AND P.PLAN_ID                                = @p_plan_id    
                   AND P.OUT_VERSION_ID                         = @p_engine_plan_id  
                   AND P.DIVISION_ID                            = @p_division_id    
                   AND P.PLAN_NAME                              = @p_plan_start_yyyymmdd    
                   AND P.PLAN_TYPE                              = @p_plan_type    
                   AND P.SEQ                                    = @p_seq    
                   AND P.TO_DELIVERY_ORDER_ID                   IS NOT NULL    
                   AND P.BOD_ID                                 IS NOT NULL    
                --   AND P.STOCK_PLAN_LOT_ID                    IS NULL    
                   AND P.DIVISION_ID                            = @p_division_id    
                   AND P.OPERATION_GROUP     = 'E'    
                   --AND P.TO_SITE_ID                       LIKE '%A~003'    
                   AND P.DELIVERY_ORDER_ID IN    
                                         (    
                                          SELECT P.TO_DELIVERY_ORDER_ID    
                                            FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN P WITH(NOLOCK)
                                           WHERE  P.MASTER_ID                             = @p_master_id    
                                             AND P.PLAN_ID                                = @p_plan_id    
                                             AND P.DIVISION_ID                            = @p_division_id    
                                             AND P.PLAN_NAME                              = @p_plan_start_yyyymmdd    
                                             AND P.PLAN_TYPE                              = @p_plan_type    
                                             AND P.SEQ                                    = @p_seq    
                                             AND P.TO_DELIVERY_ORDER_ID                   IS NOT NULL    
                                             AND P.BOD_ID                                 IS NOT NULL    
                                             AND P.STOCK_PLAN_LOT_ID                      IS NOT NULL    
                                             AND P.STOCK_PLAN_LOT_ID                      <> 'FIXED_NOH'    
                                             AND P.STOCK_PLAN_LOT_ID                    LIKE 'WH%E~002%'    
                                             AND P.DIVISION_ID                            = @p_division_id    
                                             AND P.OPERATION_GROUP                        = 'E'    
                                             AND P.TO_SITE_ID                          LIKE '%E~003'    
                                         )    
                GROUP BY P.MASTER_ID    
                        ,P.PLAN_ID    
                        ,P.OUT_VERSION_ID    
                        ,P.DIVISION_ID    
                        ,P.PLAN_NAME    
                        ,P.PLAN_TYPE    
                        ,P.SEQ    
                        ,P.SCM_FROM_SITE_ID    
                        ,P.FROM_ITEM_ID    
                        ,CASE WHEN P.ATTRIBUTE1 = 'SALES'                                     THEN 'SALES'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE2  =  'Y'            THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  <> P.ATTRIBUTE4   THEN 'OUT_PLANT'    
                              WHEN P.ATTRIBUTE1 = 'PLANT' AND P.ATTRIBUTE3  =  P.ATTRIBUTE4   THEN 'IN_PLANT'    
                            ELSE '-'    
                         END      
                        ,P.ORIGIN_FROM_DIVISION_ID
                        ,P.ELECTRODE_TYPE 
              ) SUB    
              GROUP BY     
                     SUB.MASTER_ID    
                    ,SUB.PLAN_ID    
                    ,SUB.OUT_VERSION_ID    
                    ,SUB.DIVISION_ID    
                    ,SUB.PLAN_NAME    
                    ,SUB.PLAN_TYPE    
                    ,SUB.SEQ    
                    ,SUB.SCM_SITE_ID    
                    ,SUB.ITEM_ID    
                    ,SUB.ASSIGN_TYPE    
                    ,SUB.ORIGIN_DIVISION_ID
                    ,SUB.ELECTRODE_TYPE  

              ;    
  
  
            -------------------------------------------------------------------------------------------------------------         
            -- 1. ASSIGN_QTY 보정         
            -------------------------------------------------------------------------------------------------------------  
            -- 1.1. SCP_PLN_BOH_ASSIGN 비율 추출
              SELECT SCM_SITE_ID
                    ,ITEM_ID
                    ,ASSIGN_TYPE
            --      ,SUM(ASSIGN_QTY) AS ASSIGN_QTY 
                    ,SUM(ISNULL(ASSIGN_QTY,0))  OVER (PARTITION BY SCM_SITE_ID,ITEM_ID,ASSIGN_TYPE) AS ASSIGN_QTY 
                    --,SUM(ISNULL(ASSIGN_QTY,0))  OVER (PARTITION BY SCM_SITE_ID,ITEM_ID,ASSIGN_TYPE) AS ASSIGN_ITEM_QTY 
                    ,SUM(ISNULL(ASSIGN_QTY,0))  OVER (PARTITION BY SCM_SITE_ID,ITEM_ID)  AS ASSIGN_TOT_QTY      
                    ,SUM(ISNULL(ASSIGN_QTY,0))  OVER (PARTITION BY SCM_SITE_ID,ITEM_ID,ASSIGN_TYPE) 
                    / 
                    (CASE WHEN SUM(ISNULL(ASSIGN_QTY,0))  OVER (PARTITION BY SCM_SITE_ID,ITEM_ID) = 0 THEN 1 
                          ELSE SUM(ISNULL(ASSIGN_QTY,0))  OVER (PARTITION BY SCM_SITE_ID,ITEM_ID) 
                          END)   AS ASSIGN_RATE
                    --,COUNT(ITEM_ID)             OVER (PARTITION BY SCM_SITE_ID,ITEM_ID,ASSIGN_TYPE) AS ASSIGN_ITEM_COUNT
                    --,COUNT(ITEM_ID)             OVER (PARTITION BY SCM_SITE_ID,ITEM_ID) AS ASSIGN_TYPE_COUNT 
              INTO #BOH_ASSIGN
              FROM #tmp_SCP_PLN_BOH_ASSIGN X WITH(NOLOCK)
            --WHERE 1=1 
            --AND X.DIVISION_ID         = @p_division_id
            --AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
            --AND X.PLAN_TYPE           = @p_plan_type
            --AND X.SEQ                 = @p_seq

--            SELECT * FROM #BOH_ASSIGN WITH (NOLOCK) WHERE ITEM_ID ='ACEP1038I-A1' AND SCM_SITE_ID ='G451-A'

            -- 1.2. SCP_PLN_PLANT_ONHAND PSI_BOH_QTY 추출
              SELECT SITE_ID  
                    ,ITEM_ID
                    ,SUM(PSI_BOH_QTY) AS PSI_BOH_QTY
                    ,ORIGIN_DIVISION_ID
                    ,ELECTRODE_TYPE
                INTO #BOH    
                FROM SCP_PLN_PLANT_ONHAND B WITH (NOLOCK)                  
                WHERE DIVISION_ID               = @p_division_id     
                AND STOCK_TYPE    NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING','A_MOVE_WH')   --셀 특성완료이전 제외       
                AND B.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                AND B.PLAN_TYPE           = @p_plan_type
                AND B.SEQ                 = @p_seq
--              AND SITE_ID               = @P_SCM_SITE_ID        
--              AND ITEM_ID               = @p_item_id       
                AND YYYYMMDD              = @p_plan_start_yyyymmdd   
              GROUP BY SITE_ID  
                      ,ITEM_ID    
                      ,ORIGIN_DIVISION_ID
                      ,ELECTRODE_TYPE

            -- 1.2. SCP_PLN_BOH_ASSIGN에  PSI_BOH_QTY UPDATE
            UPDATE X
            SET X.ASSIGN_QTY = (Y.PSI_BOH_QTY*X.ASSIGN_RATE)  
            FROM #BOH_ASSIGN X WITH (NOLOCK)
            INNER JOIN #BOH Y  WITH (NOLOCK)
            ON 0 = 0
            AND X.SCM_SITE_ID     = Y.SITE_ID 
            AND X.ITEM_ID         = Y.ITEM_ID
            AND X.ASSIGN_TOT_QTY  <> Y.PSI_BOH_QTY

            UPDATE X
              SET  X.ASSIGN_QTY =  Y.ASSIGN_QTY
            FROM #tmp_SCP_PLN_BOH_ASSIGN X WITH (NOLOCK)
            INNER JOIN #BOH_ASSIGN Y  WITH (NOLOCK)
            ON 0 = 0
            AND X.SCM_SITE_ID = Y.SCM_SITE_ID 
            AND X.ITEM_ID     = Y.ITEM_ID
            AND X.ASSIGN_TYPE = Y.ASSIGN_TYPE

            -- 1.3. SCP_PLN_BOH_ASSIGN에 데이터가 없을 경우 SCP_PLN_PLANT_ONHAND INSERT (PSI_BOH_QTY > 0 경우에만)
            MERGE INTO #tmp_SCP_PLN_BOH_ASSIGN AS X  
            USING (SELECT SITE_ID
                         ,ITEM_ID
                         ,PSI_BOH_QTY
                         ,ORIGIN_DIVISION_ID
                         ,ELECTRODE_TYPE
                    FROM #BOH
                  WHERE PSI_BOH_QTY > 0 
                  ) AS Y
            ON 0 = 0
            AND X.SCM_SITE_ID = Y.SITE_ID 
            AND X.ITEM_ID     = Y.ITEM_ID

            WHEN NOT MATCHED  THEN 
              INSERT (
                    MASTER_ID    
                    ,PLAN_ID    
                    ,OUT_VERSION_ID    
                    ,DIVISION_ID    
                    ,PLAN_START_YYYYMMDD
                    ,PLAN_TYPE    
                    ,SEQ    
                    ,SCM_SITE_ID    
                    ,ITEM_ID    
                    ,ASSIGN_TYPE    
                    ,ORIGIN_DIVISION_ID  
                    ,ELECTRODE_TYPE  
                    ,ASSIGN_QTY
                    )
             VALUES (
                     @p_master_id
                    ,@p_plan_id
                    ,@p_engine_plan_id
                    ,@p_division_id
                    ,@p_plan_start_yyyymmdd
                    ,@p_plan_type
                    ,@p_seq
                    ,Y.SITE_ID
                    ,Y.ITEM_ID
                    ,'OUT_PLANT' 
                    ,ISNULL(Y.ORIGIN_DIVISION_ID,'')  
                    ,ISNULL(Y.ELECTRODE_TYPE,'')  
                    ,ISNULL(Y.PSI_BOH_QTY,0)
                    )
                    ;


            -------------------------------------------------------------------------------------------------------------         
            -- 2. SCP_PLN_BOH_ASSIGN 입력         
            -------------------------------------------------------------------------------------------------------------         
    
              DELETE FROM dbo.SCP_PLN_BOH_ASSIGN          
              WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq        
        
              INSERT INTO dbo.SCP_PLN_BOH_ASSIGN        
              (        
                MASTER_ID    
                ,PLAN_ID    
                ,OUT_VERSION_ID    
                ,DIVISION_ID    
                ,PLAN_START_YYYYMMDD    
                ,PLAN_TYPE    
                ,SEQ    
                ,SCM_SITE_ID    
                ,ITEM_ID    
                ,ASSIGN_TYPE    
                ,ASSIGN_QTY        
                ,ORIGIN_DIVISION_ID  
                ,ELECTRODE_TYPE  
                ,CREATED_BY        
                ,CREATION_DATE        
                ,LAST_UPDATED_BY        
                ,LAST_UPDATE_DATE        
              )                    
  
               SELECT MASTER_ID    
                     ,PLAN_ID    
                     ,OUT_VERSION_ID    
                     ,DIVISION_ID    
                     ,PLAN_START_YYYYMMDD    
                     ,PLAN_TYPE    
                     ,SEQ    
                     ,SCM_SITE_ID    
                     ,ITEM_ID    
                     ,ASSIGN_TYPE    
                     ,ASSIGN_QTY    
                     ,ORIGIN_DIVISION_ID  
                     ,ELECTRODE_TYPE  
                     ,@v_batch_user     AS CREATED_BY        
                     ,GETDATE()         AS CREATION_DATE        
                     ,@v_batch_user     AS LAST_UPDATED_BY        
                     ,GETDATE()         AS LAST_UPDATED_DATE      
              FROM  #tmp_SCP_PLN_BOH_ASSIGN WITH (NOLOCK)  
              ;         
          
        -----------------------------------------------------------        
        -- 실행 Logic END --        
        -----------------------------------------------------------        
        --IF @@TRANCOUNT > 0        
        --  BEGIN        
        --    COMMIT TRAN T1;        
        --  END;    
        
        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#tmp_SCP_PLN_BOH_ASSIGN') IS NOT NULL
        DROP TABLE #tmp_SCP_PLN_BOH_ASSIGN
        
        IF OBJECT_ID('tempdb..#BOH_ASSIGN') IS NOT NULL
        DROP TABLE #BOH_ASSIGN
        
        IF OBJECT_ID('tempdb..#BOH') IS NOT NULL
        DROP TABLE #BOH
        
        -- TXN LOG        
        SET @v_log_type = N'TXN';            
        SET @n_log_count = @@ROWCOUNT;        
        SET @v_log_message = N'INSERT INTO '+@v_table_id;        
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);        
        SET @d_event_date = SYSDATETIME();        
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name        
     ,@p_log_type      =@v_log_type        
                           ,@p_log_count     =@n_log_count         
                                  ,@p_log_message   =@v_log_message         
                                  ,@p_description   =@v_description         
                                  ,@p_event_date    =@d_event_date         
                                  ,@p_user_id       =@v_batch_user        
                                  ;              
        
    END        
    END TRY        
        
    BEGIN CATCH        
      --IF @@TRANCOUNT > 0        
      --  BEGIN        
      --    ROLLBACK TRAN T1        
--  END;        
              
      -- ERROR LOG        
      SET @v_log_type = N'ERROR';        
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));        
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());        
      SET @d_event_date = SYSDATETIME();        
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name        
                                ,@p_log_type      =@v_log_type        
                                ,@p_log_count     =@n_log_count         
                                ,@p_log_message   =@v_log_message         
                                ,@p_description   =@v_description         
                                ,@p_event_date    =@d_event_date                                       
                                ,@p_user_id       =@v_batch_user        
                                ;        
--      PRINT @@ERROR        
      return -1        
    END CATCH;        
        

          -- 임시 운영반영시에 주석처리 할것.    
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))  

    -- 종료 LOG        
    SET @v_log_type = N'END';        
    SET @v_log_message = N'########## END of procedure ##########';        
    SET @v_description = N'[' + @p_master_id + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';         
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
  
  


  

