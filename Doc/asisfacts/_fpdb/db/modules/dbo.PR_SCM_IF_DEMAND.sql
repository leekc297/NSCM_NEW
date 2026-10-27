CREATE PROCEDURE [dbo].[PR_SCM_IF_DEMAND]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_DEMAND                                                          **/
/** 프로그램 명   :                                                                           **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2016.08.22    LJH          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_DEMAND
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime
  DECLARE @plan_date        date

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_DEMAND'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN

      SET @v_table_name = 'TH_MST_PLAN'
      SELECT  @plan_start_time = PLAN_START_DTTM,
              @plan_end_time   = PLAN_END_DTTM,
              @plan_date = CONVERT(DATETIME, PLAN_DATE),
              @key_date = PLAN_DATE
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     PLAN_DATE
              FROM   TH_MST_PLAN
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
             ) A
             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      
    END;

    BEGIN
    
      SET @v_table_name = 'TH_DPP_NET_DEMAND'
      
      DELETE FROM TH_DPP_NET_DEMAND
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @p_plan_id
      
      INSERT INTO TH_DPP_NET_DEMAND
               (MASTER_ID
               ,PLAN_ID
               ,NET_DEMAND_ID
               ,DEMAND_ID
               ,PRODUCTION_ORDER_ID
               ,SALES_MODEL
               ,ITEM_ID
               ,QTY
               ,DUE_DATE
               ,SHIPPING_DATE
               ,DUE_FENCE_DATE
               ,MFG_WEEK
               ,SPLIT_DATE
               ,PO_TYPE
               ,ORDER_TYPE
               ,FROM_SITE_ID
               ,TO_SITE_ID
               ,MARKET
               ,DEMAND_GROUP_PRIORITY
               ,DEMAND_PRIORITY
               ,EARLY_PRODUCING_TERM
               ,EARLY_PRODUCING_TERM_UOM
               ,IS_CONSUME
               ,KEY_DATE
               ,INSERT_ID
               ,INSERT_DTTM
               ,UPDATE_ID
               ,UPDATE_DTTM)
      SELECT    @v_master_id
               ,@v_plan_id
               ,C.FP_DEMAND_ID
               ,C.SCP_TARGET_ID
               ,C.WORK_ORDER_ID
               ,C.SALES_MODEL_ID AS SALES_MODEL
               ,C.PRODUCT_ITEM_ID AS ITEM_ID
               ,MFG_QTY
               ,CASE WHEN C.DUE_DATE < @plan_date       THEN @plan_date ELSE C.DUE_DATE       END AS DUE_DATE       -- 일자기준이다.
               ,CASE WHEN C.DUE_DATE < @plan_date       THEN @plan_date ELSE C.DUE_DATE       END AS SHIPPING_DATE
               ,CASE WHEN C.DUE_FENCE_DATE < @plan_date THEN @plan_date ELSE C.DUE_FENCE_DATE END AS DUE_FENCE_DATE
               ,C.MFG_WEEK
               ,C.DUE_DATE  AS SPLIT_DATE
               ,CASE WHEN ISNULL(C.WORK_ORDER_ID, '') = '' THEN '' ELSE 'FIX' END AS PO_TYPE
               ,C.PRODUCTION_TYPE
               ,C.PLANT_ID
               ,C.TO_PLANT_ID
               ,C.MARKET
               --,C.MFG_WEEK AS DEMAND_GROUP_PRIORITY
               , CASE DEMAND_TYPE WHEN 'FIX' THEN '0'
                                  WHEN 'NCP' THEN '1'
                                             ELSE '2'
                 END  +':'+C.MFG_WEEK AS DEMAND_GROUP_PRIORITY
               --,MFG_WEEK + ':' +  CASE  WHEN WORK_ORDER_ID IS NULL THEN '0'
               --                         ELSE '1'
               --                   END  
               --          + ':' + PRODUCTION_TYPE + ':' + ITEM_ID 
               -- AS DEMAND_GROUP_PRIORITY
               ,C.PRIORITY
               ,C.PRECEDE_PRODUCING_TERM
               ,C.PRECEDE_PRODUCING_TERM_UOM
               ,C.IS_CONSUME
               ,@key_date AS KEY_DATE
               ,@v_proc_name as INSERT_ID
               ,GETDATE() as INSERT_DTTM
               ,@v_proc_name as UPDATE_ID
               ,getdate() as UPDATE_DTTM
      FROM    (SELECT   DISTINCT 
                         A.PLANT_ID
                        ,A.SHOP_GROUP_ID
                        ,A.DPP_PLAN_ID
                        ,A.FP_DEMAND_ID
                        ,A.SCP_TARGET_ID
                        ,ISNULL(B.SALES_MODEL_ID, A.ITEM_ID)  AS SALES_MODEL_ID
                        ,ISNULL(B.PRODUCT_ITEM_ID, A.ITEM_ID) AS PRODUCT_ITEM_ID
                        ,A.MFG_WEEK
                        ,A.MFG_QTY
                        ,A.WORK_ORDER_ID
                        ,A.DUE_DATE
                        ,A.PRODUCTION_TYPE
                        ,A.DUE_FENCE_DATE
                        ,A.TO_PLANT_ID
                        ,A.MARKET
                        ,A.PRIORITY
                        ,A.PRECEDE_PRODUCING_TERM
                        ,A.PRECEDE_PRODUCING_TERM_UOM
                        ,A.COMPANY_ID
                        ,A.DIVISION_ID
                        ,A.SITE_ID
                        ,A.DEMAND_TYPE
                        ,A.IS_CONSUME
                FROM     SY_FP_DAILY_NET_DEMAND_H A
                         LEFT OUTER JOIN TH_MST_SCM_SALES_PRODUCT B
                              ON    A.INSTANCE_ID = B.MASTER_ID
                              AND   A.DPP_PLAN_ID = B.PLAN_ID
                              AND   A.COMPANY_ID  = B.COMPANY_ID
                              AND   A.DIVISION_ID = B.DIVISION_ID
                              AND   A.SITE_ID     = B.SITE_ID
                              AND   A.ITEM_ID     = B.SALES_MODEL_ID
                WHERE    A.INSTANCE_ID = @v_master_id
                AND      A.DPP_PLAN_ID = @v_plan_id
                --AND      A.DUE_DATE >= convert(date, @plan_start_time)
                AND      A.MFG_QTY > 0
               ) C
        /*
        WHERE  EXISTS (
                        SELECT 1
                        FROM   TH_MST_INSTANCE_FLOW     X
                        WHERE  C.COMPANY_ID = X.COMPANY_ID
                        AND    C.DIVISION_ID = X.DIVISION_ID
                        AND    C.SITE_ID = X.SITE_ID
                        --AND    A.PLANT_ID = B.PLANT_ID
                        AND    C.DPP_PLAN_ID = X.PLAN_ID
                        AND    X.MASTER_ID = @v_master_id
                        AND    X.PLAN_ID = @v_plan_id
                      )
        */
/*      
      INSERT INTO TH_DPP_NET_DEMAND
               (MASTER_ID
               ,PLAN_ID
               ,NET_DEMAND_ID
               ,DEMAND_ID
               ,PRODUCTION_ORDER_ID
               ,SALES_MODEL
               ,ITEM_ID
               ,QTY
               ,DUE_DATE
               ,SHIPPING_DATE
               ,DUE_FENCE_DATE
               ,MFG_WEEK
               ,SPLIT_DATE
               ,PO_TYPE
               ,ORDER_TYPE
               ,FROM_SITE_ID
               ,TO_SITE_ID
               ,MARKET
               ,DEMAND_GROUP_PRIORITY
               ,DEMAND_PRIORITY
               ,EARLY_PRODUCING_TERM
               ,EARLY_PRODUCING_TERM_UOM
               ,IS_CONSUME
               ,KEY_DATE
               ,INSERT_ID
               ,INSERT_DTTM
               ,UPDATE_ID
               ,UPDATE_DTTM)
      SELECT  @V_MASTER_ID
             ,@V_PLAN_ID
             ,a.TEST_TARGET_ID AS NET_DEMAND_ID
             , a.TEST_TARGET_ID AS DEMAND_ID
             , '-'PRODUCTION_ORDER_ID
             ,a.ITEM_ID AS SALES_MODEL
             ,a.ITEM_ID
             ,a.MFG_QTY AS QTY
             ,DATEADD(DAY, -1, a.DUE_DATE) AS DUE_DATE
             ,a.DUE_DATE AS SHIPPING_DATE
             ,a.DUE_DATE AS DUE_FENCE_DATE
             ,'-' AS MFG_WEEK
             ,a.DUE_DATE AS SPLIT_DATE
             ,'TEST' AS PO_TYPE
             ,'TEST' AS ORDER_TYPE
             ,NULL AS FROM_SITE_ID
             ,NULL AS TO_SITE_ID
             ,NULL AS MARKET
             ,'1'  AS DEMAND_GROUP_PRIORITY
             ,'1'  AS DEMAND_PRIORITY
             ,0 AS EARLY_PRODUCING_TERM
             ,'DAY' AS EARLY_PRODUCING_TERM_UOM
             ,'Y'   AS IS_CONSUME
             ,@key_date AS KEY_DATE
             ,@v_proc_name as INSERT_ID
             ,GETDATE() as INSERT_DTTM
             ,@v_proc_name as UPDATE_ID
             ,getdate() as UPDATE_DTTM
      FROM    SY_FP_WEEKLY_DEMAND_PRODUCT_TEST_H a,
              th_mst_plan b
      WHERE   1=1
      and     b.master_ID = @v_master_id
      and     b.plan_id   = @v_plan_id
      and     a.due_date >= b.PLAN_START_DTTM
      and     exists (
                      select 1
                      from   th_mst_instance_flow x
                      where  b.master_id    = x.master_id
                      and    b.plan_id      = x.plan_id
                      and    a.item_id      = x.item_id
                      and    a.operation_id = x.operation_id
                     )
      
      
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      
      INSERT INTO SY_FP_DAILY_NET_DEMAND_H
            (
              COMPANY_ID
            , DIVISION_ID
            , SITE_ID
            , PLANT_ID
            , SHOP_GROUP_ID
            , INSTANCE_ID
            , DPP_PLAN_ID
            , FP_DEMAND_ID
            , SCP_PLAN_ID
            , SCP_TARGET_ID
            , ITEM_ID
            , MFG_WEEK
            , MFG_QTY
            , SCP_QTY
            , WORK_ORDER_ID
            , DUE_DATE
            , DUE_FENCE_DATE
            , PRECEDE_PRODUCING_TERM
            , PRECEDE_PRODUCING_TERM_UOM
            , PRODUCTION_TYPE
            , MARKET
            , PRIORITY
            , OFFSET_QTY
            , CONFIRM_TYPE
            , DEMAND_TYPE
            , IS_CONSUME
            , INSERT_ID
            , INSERT_TIME
            , UPDATE_ID
            , UPDATE_TIME
            )
      SELECT 
              COMPANY_ID
            , DIVISION_ID
            , SITE_ID
            , PLANT_ID
            , 'E' AS SHOP_GROUP_ID
            , MASTER_ID AS INSTANCE_ID
            , PLAN_ID AS DPP_PLAN_ID
            , TEST_TARGET_ID AS FP_DEMAND_ID
            , SCP_PLAN_ID
            , TEST_TARGET_ID AS SCP_TARGET_ID
            , ITEM_ID
            , MFG_WEEK
            , MFG_QTY
            , MFG_QTY AS SCP_QTY
            , NULL  AS WORK_ORDER_ID
            , DUE_DATE
            , DUE_DATE AS DUE_FENCE_DATE
            , 0 AS PRECEDE_PRODUCING_TERM
            , 'DAY' AS PRECEDE_PRODUCING_TERM_UOM
            , 'TEST'  AS PRODUCTION_TYPE
            , 'D' AS MARKET
            , '1'  AS PRIORITY
            , 0 AS OFFSET_QTY
            , 'COMFIRM' AS CONFIRM_TYPE
            , 'NOR' AS DEMAND_TYPE
            , 'Y'   AS IS_CONSUME
            , @v_proc_name as INSERT_ID
            , GETDATE() as INSERT_TIME
            , @v_proc_name as UPDATE_ID
            , getdate() as UPDATE_TIME
      FROM    SY_FP_WEEKLY_DEMAND_PRODUCT_TEST_H a,
              th_mst_plan b
      WHERE   1=1
      and     b.master_ID = @v_master_id
      and     b.plan_id   = @v_plan_id
      and     a.due_date >= b.PLAN_START_DTTM
      and     exists (
                      select 1
                      from   th_mst_instance_flow x
                      where  b.master_id    = x.master_id
                      and    b.plan_id      = x.plan_id
                      and    a.item_id      = x.item_id
                      and    a.operation_id = x.operation_id
                     )
      */
    
      SET @v_table_name = 'TH_DPP_NET_DEMAND BAK'
      
      DELETE FROM TH_DPP_NET_DEMAND
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = RTRIM(LTRIM(ISNULL(@v_plan_id, '') + 'BAK'))
      
      INSERT INTO TH_DPP_NET_DEMAND
               (MASTER_ID
               ,PLAN_ID
               ,NET_DEMAND_ID
               ,DEMAND_ID
               ,PRODUCTION_ORDER_ID
               ,SALES_MODEL
               ,ITEM_ID
               ,QTY
               ,DUE_DATE
               ,SHIPPING_DATE
               ,DUE_FENCE_DATE
               ,MFG_WEEK
               ,SPLIT_DATE
               ,ORDER_TYPE
               ,FROM_SITE_ID
               ,TO_SITE_ID
               ,MARKET
               ,DEMAND_GROUP_PRIORITY
               ,DEMAND_PRIORITY
               ,EARLY_PRODUCING_TERM
               ,EARLY_PRODUCING_TERM_UOM
               ,IS_CONSUME               
               ,KEY_DATE
               ,INSERT_ID
               ,INSERT_DTTM
               ,UPDATE_ID
               ,UPDATE_DTTM)
      SELECT    MASTER_ID
               ,RTRIM(LTRIM(ISNULL(@v_plan_id, '') + 'BAK')) AS PLAN_ID
               ,NET_DEMAND_ID
               ,DEMAND_ID
               ,PRODUCTION_ORDER_ID
               ,SALES_MODEL
               ,ITEM_ID
               ,QTY
               ,DUE_DATE
               ,SHIPPING_DATE
               ,DUE_FENCE_DATE
               ,MFG_WEEK
               ,SPLIT_DATE
               ,ORDER_TYPE
               ,FROM_SITE_ID
               ,TO_SITE_ID
               ,MARKET
               ,DEMAND_GROUP_PRIORITY
               ,DEMAND_PRIORITY
               ,EARLY_PRODUCING_TERM
               ,EARLY_PRODUCING_TERM_UOM
               ,IS_CONSUME               
               ,@key_date AS KEY_DATE
               ,@v_proc_name as INSERT_ID
               ,GETDATE() as INSERT_DTTM
               ,@v_proc_name as UPDATE_ID
               ,getdate() as UPDATE_DTTM
      FROM    TH_DPP_NET_DEMAND C
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @v_plan_id
      
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      /* -- 후공정 계획몰림 현상으로 주석처리 . 2017.03.20      
      SET @v_table_name = 'TH_DPP_DEMAND_ATTRBUTE'
      
      DELETE FROM TH_DPP_DEMAND_ATTRIBUTE
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @p_plan_id

      INSERT INTO TH_DPP_DEMAND_ATTRIBUTE
            (
              MASTER_ID
            , PLAN_ID
            , DEMAND_ID
            , PREFERENCE_SITE_ID
            , PREFERENCE_ROUTE_ID
            , PREFERENCE_OPERATION_ID
            , PREFERENCE_RESOURCE_ID
            , PREFERENCE_PRODUCT_ID
            , IS_HARD_PREFERENCE
            , KEY_DATE
            , INSERT_ID
            , INSERT_DTTM
            , UPDATE_ID
            , UPDATE_DTTM
            )            
      SELECT  DISTINCT
              @v_master_id
            , @v_plan_id
            , FP_DEMAND_ID
            , PREFER_SITE   AS PREFERENCE_SITE_ID
            , ''            AS PREFERENCE_ROUTE_ID
            , ''            AS PREFERENCE_OPERATION_ID
            , ''            AS PREFERENCE_RESOURCE_ID
            , ''            AS PREFERENCE_PRODUCT_ID
            , 'Y'           AS IS_HARD_PREFERENCE
            , @key_date     AS KEY_DATE
            , @v_proc_name as INSERT_ID
            , GETDATE() as INSERT_DTTM
            , @v_proc_name as UPDATE_ID
            , getdate() as UPDATE_DTTM
      FROM   (
              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, FP_DEMAND_ID, ITEM_ID
              FROM   SY_FP_DAILY_NET_DEMAND_H A
              WHERE  A.INSTANCE_ID = @v_master_id
              AND    A.DPP_PLAN_ID = @v_plan_id
              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, FP_DEMAND_ID, ITEM_ID
             ) A,
             (
              SELECT COMPANY_ID, DIVISION_ID, SITE_ID,
                     MAX(AF01)+MAX(AF02)+MAX(AF03)+MAX(AF04)+MAX(AF05)+MAX(AF06)+MAX(AF07)+MAX(AF08)+MAX(AF09)+MAX(AF10)
                    +MAX(AF11)+MAX(AF12)+MAX(AF13)+MAX(AF14)+MAX(AF15)+MAX(AF16)+MAX(AF17)+MAX(AF18)+MAX(AF19)+MAX(AF20) AS PREFER_SITE
              FROM   (
                      SELECT COMPANY_ID, DIVISION_ID, SITE_ID
                           , CASE WHEN INT =  1 THEN FACTORY_ID + '##' ELSE '' END AF01
                           , CASE WHEN INT =  2 THEN FACTORY_ID + '##' ELSE '' END AF02
                           , CASE WHEN INT =  3 THEN FACTORY_ID + '##' ELSE '' END AF03
                           , CASE WHEN INT =  4 THEN FACTORY_ID + '##' ELSE '' END AF04
                           , CASE WHEN INT =  5 THEN FACTORY_ID + '##' ELSE '' END AF05
                           , CASE WHEN INT =  6 THEN FACTORY_ID + '##' ELSE '' END AF06
                           , CASE WHEN INT =  7 THEN FACTORY_ID + '##' ELSE '' END AF07
                           , CASE WHEN INT =  8 THEN FACTORY_ID + '##' ELSE '' END AF08
                           , CASE WHEN INT =  9 THEN FACTORY_ID + '##' ELSE '' END AF09
                           , CASE WHEN INT = 10 THEN FACTORY_ID + '##' ELSE '' END AF10
                           , CASE WHEN INT = 11 THEN FACTORY_ID + '##' ELSE '' END AF11
                           , CASE WHEN INT = 12 THEN FACTORY_ID + '##' ELSE '' END AF12
                           , CASE WHEN INT = 13 THEN FACTORY_ID + '##' ELSE '' END AF13
                           , CASE WHEN INT = 14 THEN FACTORY_ID + '##' ELSE '' END AF14
                           , CASE WHEN INT = 15 THEN FACTORY_ID + '##' ELSE '' END AF15
                           , CASE WHEN INT = 16 THEN FACTORY_ID + '##' ELSE '' END AF16
                           , CASE WHEN INT = 17 THEN FACTORY_ID + '##' ELSE '' END AF17
                           , CASE WHEN INT = 18 THEN FACTORY_ID + '##' ELSE '' END AF18
                           , CASE WHEN INT = 19 THEN FACTORY_ID + '##' ELSE '' END AF19
                           , CASE WHEN INT = 20 THEN FACTORY_ID + '##' ELSE '' END AF20
                      FROM   (
                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,
                                     A.FACTORY_ID,
                                     COUNT(1) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ORDER BY A.FACTORY_ID) SEQ
                              FROM   SY_SCM_FACTORY_M A,
                                     SY_FP_INSTANCE_FACTORY_M B
                              WHERE  A.ACTIVE_FLAG = 'Y'
                              AND    A.FACTORY_ID = B.FACTORY_ID
                              AND    B.INSTANCE_ID = @v_master_id
                             ) A,
                             COPYT B
                      WHERE  SEQ = INT    
                     ) A
              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID
             ) B
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID             
      */
      
      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END;    
    
    
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
