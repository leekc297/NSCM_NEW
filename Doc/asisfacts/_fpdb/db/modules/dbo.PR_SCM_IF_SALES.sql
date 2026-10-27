CREATE PROCEDURE [dbo].[PR_SCM_IF_SALES]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_ITEM                                                             **/
/** 프로그램 명   :                                                                           **/
/** 설 명         :                                                                            **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                   **/
/**                                                                                           **/
/**  [검색 조건]                                                                                **/
/**                                                                                           **/
/** [Biz Logic]                                                                                **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                       **/
/**===========================================================================================**/
/** 2016.08.17    LJH          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_ITEM
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

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_SALES'
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
    
      --LOG 생성
      SET @v_table_name = 'TH_MST_PLAN'
      SELECT  @plan_start_time = PLAN_START_DTTM,
              @plan_end_time   = PLAN_END_DTTM,
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
    
      SET @v_table_name = 'TH_MST_SALES_PRODUCT_MAP'
      
      DELETE FROM TH_MST_SALES_PRODUCT_MAP
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @p_plan_id
      
      INSERT INTO TH_MST_SALES_PRODUCT_MAP
             ( MASTER_ID
             , PLAN_ID
             , SITE_ID
             , SALES_MODEL_ID
             , PRODUCT_ITEM_ID
             , ALT_PRIORITY
             , KEY_DATE
             , INSERT_ID
             , INSERT_DTTM
             , UPDATE_ID
             , UPDATE_DTTM)
      SELECT   @v_master_id
              ,@v_plan_id
              ,C.SITE_ID
              ,C.SALES_MODEL_ID
              ,C.PRODUCT_ITEM_ID
              ,C.ALT_PRIORITY
              ,@key_date AS KEY_DATE
              ,@v_proc_name as INSERT_ID
              ,GETDATE() as INSERT_DTTM
              ,@v_proc_name as UPDATE_ID
              ,getdate() as UPDATE_DTTM
      FROM    (
                SELECT   DISTINCT C.FACTORY_ID AS SITE_ID
                        ,E.SALES_MODEL_ID AS SALES_MODEL_ID
                        ,E.PRODUCT_ITEM_ID AS PRODUCT_ITEM_ID
                        ,D.ALT_PRIORITY
                FROM    SY_SCM_ITEM_M         A
                      , TH_MST_INSTANCE_FLOW  B
                      , SY_SCM_FACTORY_M      C
                      , (
                        SELECT ITEM_ID, SITE_ID, ISNULL(MIN(ALT_PRIORITY), 9) AS ALT_PRIORITY
                        FROM   TH_MST_OP_RESOURCE 
                        WHERE  MASTER_ID = @v_master_id
                        AND    PLAN_ID = @v_plan_id
                        AND    ALT_PRIORITY IN (1,2,3,4,5,6,7,8)
                        GROUP  BY ITEM_ID, SITE_ID
                        ) D,
                        TH_MST_SCM_SALES_PRODUCT E
                WHERE   A.COMPANY_ID = B.COMPANY_ID
                AND     A.DIVISION_ID = B.DIVISION_ID
                AND     A.SITE_ID = B.SITE_ID
                AND     A.ITEM_ID = B.ITEM_ID
                AND     B.COMPANY_ID = C.COMPANY_ID
                AND     B.DIVISION_ID = C.DIVISION_ID
                AND     B.SITE_ID = C.SITE_ID
                AND     B.PLANT_ID = C.PLANT_ID
                AND     B.FACTORY_ID = C.FACTORY_ID
                AND     A.ITEM_ID = D.ITEM_ID
                AND     C.FACTORY_ID = D.SITE_ID
                AND     D.ALT_PRIORITY IN (1,2,3,4,5,6,7,8)
                AND     B.MASTER_ID = E.MASTER_ID
                AND     B.PLAN_ID = E.PLAN_ID
                AND     A.ITEM_ID = E.PRODUCT_ITEM_ID
                AND     B.MASTER_ID = @v_master_id
                AND     B.PLAN_ID = @v_plan_id
                /*
                AND     EXISTS (
                                SELECT 1
                                FROM   TH_DPP_NET_DEMAND X
                                WHERE  X.MASTER_ID = @v_master_id
                                AND    X.PLAN_ID = @v_plan_id
                                AND    X.ITEM_ID = A.ITEM_ID
                               )
                */
                AND     EXISTS (
                                SELECT 1
                                FROM   TH_MST_OP_RESOURCE Z
                                WHERE  Z.MASTER_ID = @v_master_id
                                AND    Z.PLAN_ID = @v_plan_id
                                AND    Z.SITE_ID = C.FACTORY_ID
                                AND    Z.ITEM_ID = A.ITEM_ID
                               )
               ) C
      
      SET @n_row_count = @@ROWCOUNT

      INSERT INTO TH_MST_SALES_PRODUCT_MAP
             ( MASTER_ID
             , PLAN_ID
             , SITE_ID
             , SALES_MODEL_ID
             , PRODUCT_ITEM_ID
             , ALT_PRIORITY
             , DESCR
             , KEY_DATE
             , INSERT_ID
             , INSERT_DTTM
             , UPDATE_ID
             , UPDATE_DTTM)
      SELECT   @v_master_id
              ,@v_plan_id
              ,C.SITE_ID
              ,C.SALES_MODEL_ID
              ,C.PRODUCT_ITEM_ID
              ,9 AS ALT_PRIORITY
              ,'NO TACT TIME' AS DESCR
              ,@key_date AS KEY_DATE
              ,@v_proc_name as INSERT_ID
              ,GETDATE() as INSERT_DTTM
              ,@v_proc_name as UPDATE_ID
              ,getdate() as UPDATE_DTTM
      FROM    (
                SELECT   DISTINCT C.FACTORY_ID AS SITE_ID
                        ,E.SALES_MODEL_ID AS SALES_MODEL_ID
                        ,E.PRODUCT_ITEM_ID AS PRODUCT_ITEM_ID
                FROM    SY_SCM_ITEM_M           A
                      , TH_MST_INSTANCE_FLOW  B
                      , SY_SCM_FACTORY_M      C
                      , TH_MST_SCM_SALES_PRODUCT E
                WHERE   A.COMPANY_ID = B.COMPANY_ID
                AND     A.DIVISION_ID = B.DIVISION_ID
                AND     A.SITE_ID = B.SITE_ID
                AND     A.ITEM_ID = B.ITEM_ID
                AND     B.COMPANY_ID = C.COMPANY_ID
                AND     B.DIVISION_ID = C.DIVISION_ID
                AND     B.SITE_ID = C.SITE_ID
                AND     B.PLANT_ID = C.PLANT_ID
                AND     B.FACTORY_ID = C.FACTORY_ID
                AND     B.MASTER_ID = E.MASTER_ID
                AND     B.PLAN_ID = E.PLAN_ID
                AND     A.ITEM_ID = E.PRODUCT_ITEM_ID
                AND     B.MASTER_ID = @v_master_id
                AND     B.PLAN_ID = @v_plan_id
                /*
                AND     EXISTS (
                                SELECT 1
                                FROM   TH_DPP_NET_DEMAND X
                                WHERE  X.MASTER_ID = @v_master_id
                                AND    X.PLAN_ID = @v_plan_id
                                AND    X.ITEM_ID = A.ITEM_ID
                               )
                */
                AND     NOT EXISTS (
                                SELECT 1
                                FROM   TH_MST_OP_RESOURCE Z
                                WHERE  Z.MASTER_ID = @v_master_id
                                AND    Z.PLAN_ID = @v_plan_id
                                AND    Z.SITE_ID = C.FACTORY_ID
                                AND    Z.ITEM_ID = A.ITEM_ID
                               )
               ) C
            
      SET @n_row_count += @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
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
