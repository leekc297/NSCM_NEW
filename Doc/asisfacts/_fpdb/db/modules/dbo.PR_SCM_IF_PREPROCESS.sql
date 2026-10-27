CREATE PROCEDURE [dbo].[PR_SCM_IF_PREPROCESS]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_PREPROCESS                                                      **/
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
/** 2016.08.18    LJH          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_PREPROCESS
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_company        nvarchar(30)   
  DECLARE @v_division        nvarchar(30)
  DECLARE @v_corporation    nvarchar(30)
  DECLARE @v_plant           nvarchar(30)
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime
  DECLARE @v_plan_type      nvarchar(30)
  DECLARE @v_daydiff        Integer

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_PREPROCESS'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)

  DECLARE @v_prod_plan_id   nvarchar(30)
  DECLARE @v_ship_plan_id   nvarchar(30)
  DECLARE @v_srs_plan_id    nvarchar(30)
  DECLARE @v_start_week     nvarchar(6)
  DECLARE @v_end_week       nvarchar(6)
  DECLARE @v_confirm_week   int
  DECLARE @v_instance_type  nvarchar(10)
  
  DECLARE @v_plan_date      DATE
  DECLARE @v_plan_week      nvarchar(30)
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)

  -------------------------------------------------------------------------------------------
  -- LINE 인지 EQUIPMENT 인지 설정하는 변수... 아주 중요
  -------------------------------------------------------------------------------------------
   DECLARE @res_category      nvarchar(10)
  -------------------------------------------------------------------------------------------
  
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
              @v_plan_type = PLAN_TYPE,
              @v_daydiff = DAYDIFF,
              @v_prod_plan_id = SCP_PRODUCT_PLAN_ID,
              @v_ship_plan_id = SCP_SHIPMENT_PLAN_ID,
              @v_srs_plan_id  = SCP_SRS_PLAN_ID,
              @v_plan_date = PLAN_DATE,
              @v_plan_week = PLAN_WEEK,
              @key_date    = CONVERT(NVARCHAR, PLAN_DATE, 112)
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN DEMAND_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, DEMAND_HORIZON,     PLAN_START_DTTM)
                          WHEN DEMAND_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, DEMAND_HORIZON * 7, PLAN_START_DTTM)
                          WHEN DEMAND_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, DEMAND_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     PLAN_TYPE,
                     DATEDIFF(MINUTE,CONVERT(DATE,PLAN_START_DTTM), PLAN_START_DTTM) AS DAYDIFF,
                     TOP_PLAN_ID,
                     SCP_PRODUCT_PLAN_ID,
                     SCP_SHIPMENT_PLAN_ID,
                     SCP_SRS_PLAN_ID,
                     CONVERT(DATE, PLAN_DATE) AS PLAN_DATE,
                     WEEK AS PLAN_WEEK
              FROM   TH_MST_PLAN
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
             ) A
             
      --LOG 생성
      SET @v_message  = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @v_message += ' / day minute : ' + CONVERT(nvarchar, @v_daydiff)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      
      SELECT @v_start_week = WEEK
      FROM   SY_SCM_SYS_CALENDAR_M
      WHERE  DATE_ID = CONVERT(DATE, @plan_start_time)

      SELECT @v_end_week = WEEK
      FROM   SY_SCM_SYS_CALENDAR_M
      WHERE  DATE_ID = CONVERT(DATE, @plan_end_time - 1)    -- 하루 뺀다.

      SET @v_message  = '@v_start_week : ' + CONVERT(nvarchar, @v_start_week, 112) + ' / @v_end_week : ' + CONVERT(nvarchar, @v_end_week, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null



      SELECT @v_confirm_week = isnull(convert(numeric, replace(replace(key_value, 'WEEK', ''), 'W', '')), 4)
      FROM   (SELECT MAX(key_value) AS key_value
              FROM   SY_FP_INSTANCE_CONFIG_M
              WHERE  INSTANCE_ID = 'COMMON'
              AND    CATEGORY_ID = 'DPP_CONFIG'
              AND    KEY_ID = 'CONFIRM_WEEK'
             ) A

      SET @v_message  = '@v_confirm_week : ' + convert(nvarchar, @v_confirm_week)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      SELECT @v_instance_type = MAX(A.INSTANCE_TYPE) 
      FROM   SY_FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
             SY_SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
      WHERE  A.INSTANCE_ID = @v_master_id
      AND    A.FACTORY_ID = B.FACTORY_ID
      
      SET @v_message  = '@v_instance_type : ' + @v_instance_type
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      /*--------------------------------------------------------------------------
       INSTANCE 별 DIVISION 별 DEMAND TARGET 이 다르다.
       아래의 쿼리는 DIVISION 별 TARGET 을 설정하는 부분이다.

        INSERT INTO SY_FP_INSTANCE_CONFIG_M
        SELECT DISTINCT INSTANCE_ID, 'DEMAND_TARGET' CATEGORY_ID, DIVISION_ID KEY_ID,
               CASE WHEN CHARINDEX('CELL', INSTANCE_ID) > 0 THEN 'PRODUCT'
                    WHEN CHARINDEX('SRS',  INSTANCE_ID) > 0 THEN 'SRS'
                    WHEN CHARINDEX('PACK', INSTANCE_ID) > 0 AND R = 1 THEN 'PRODUCT'
                    WHEN CHARINDEX('PACK', INSTANCE_ID) > 0 AND R = 2 THEN 'SHIPMENT'
                    WHEN DIVISION_ID LIKE '4_' AND R = 1 THEN 'SHIPMENT'
                    WHEN DIVISION_ID LIKE '4_' AND R = 2 THEN 'SHIPMENT_ELEC'
                    WHEN DIVISION_ID LIKE '8_' AND R = 1 THEN 'SHIPMENT'
                    WHEN DIVISION_ID LIKE '8_' AND R = 2 THEN 'DAILY_PLAN'
               END  KEY_VALUE,
               NULL KEY_PRIORITY,
               'N' VIEW_FLAG,
               'KEY_ID is DIVISION_ID',
               'SYSTEM' INSERT_ID,
               GETDATE() INSERT_TIME,
               'SYSTEM' UPDATE_ID,
               GETDATE() UPDATE_TIME       
        FROM   SY_FP_INSTANCE_FACTORY_M A,
               SY_SCM_FACTORY_M B,
               (SELECT 1 R UNION SELECT 2 R) C
        WHERE  A.FACTORY_ID = B.FACTORY_ID       
       
      
      --------------------------------------------------------------------------*/
      
    END;

    BEGIN

      BEGIN
      

        SET @v_table_name = 'TH_MST_SCM_SALES_PRODUCT'
        
        DELETE FROM TH_MST_SCM_SALES_PRODUCT
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
        
        --DELETE FROM TH_MST_SCM_SALES_PRODUCT
        --WHERE  KEY_DATE <= CONVERT(NVARCHAR, DATEADD(DAY, -7, CONVERT(DATE, @key_date)), 112)      

        INSERT INTO TH_MST_SCM_SALES_PRODUCT
        SELECT DISTINCT
                @v_master_id  AS MASTER_ID
              , @v_plan_id    AS PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PARENT_ITEM_ID AS SALES_MODEL_ID
              , A.CHILD_ITEM_ID AS PRODUCT_ITEM_ID
              , @key_date     AS KEY_DATE
              , @v_proc_name  AS INSERT_ID
              , sysdatetime() AS INSERT_DATE
              , @v_proc_name  AS UPDATE_ID
              , sysdatetime() AS UPDATE_DATE
        FROM   SY_SCM_BOM_M A,
               SY_SCM_ITEM_M B,
               SY_SCM_ITEM_CLASS_M C,
               SY_SCM_ITEM_M D,
               SY_SCM_ITEM_CLASS_M E
        WHERE  A.COMPANY_ID = B.COMPANY_ID
        AND    A.DIVISION_ID = B.DIVISION_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.PARENT_ITEM_ID = B.ITEM_ID
        AND    B.ITEM_CLASS = C.CLASS_ID
        AND    C.level_2_code != 'APC' 
        AND    A.COMPANY_ID = D.COMPANY_ID
        AND    A.DIVISION_ID = D.DIVISION_ID
        AND    A.SITE_ID = D.SITE_ID
        AND    A.CHILD_ITEM_ID = D.ITEM_ID
        AND    D.ITEM_CLASS = E.CLASS_ID
        AND    E.level_2_code = 'APC'
        AND    EXISTS (
                        SELECT 1
                        FROM   TH_MST_SCM_DEMAND X
                        WHERE  X.INSTANCE_ID = @v_master_id
                        AND    X.DPP_PLAN_ID = @v_plan_id
                        AND    X.COMPANY_ID = A.COMPANY_ID
                        AND    X.DIVISION_ID = A.DIVISION_ID
                        AND    X.SITE_ID = A.SITE_ID
                        AND    X.PLANT_ID = A.PLANT_ID
                        AND    X.ITEM_ID = A.PARENT_ITEM_ID
                      )  
      
        SET @n_row_count = @@ROWCOUNT
                
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        INSERT INTO TH_MST_SCM_SALES_PRODUCT
        SELECT DISTINCT
                @v_master_id  AS MASTER_ID
              , @v_plan_id    AS PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.ITEM_ID     AS SALES_MODEL_ID
              , A.ITEM_ID     AS PRODUCT_ITEM_ID
              , @key_date     AS KEY_DATE
              , @v_proc_name  AS INSERT_ID
              , sysdatetime() AS INSERT_DATE
              , @v_proc_name  AS UPDATE_ID
              , sysdatetime() AS UPDATE_DATE
        FROM   TH_MST_SCM_DEMAND A
        WHERE  A.INSTANCE_ID = @v_master_id
        AND    A.DPP_PLAN_ID = @v_plan_id
        AND    NOT EXISTS (
                            SELECT 1
                            FROM   TH_MST_SCM_SALES_PRODUCT X
                            WHERE  X.MASTER_ID = @v_master_id
                            AND    X.PLAN_ID = @v_plan_id
                            AND    X.COMPANY_ID = A.COMPANY_ID
                            AND    X.DIVISION_ID = A.DIVISION_ID
                            AND    X.SITE_ID = A.SITE_ID
                            AND    X.SALES_MODEL_ID = A.ITEM_ID
                          )
                  
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        INSERT INTO TH_MST_SCM_SALES_PRODUCT
        SELECT DISTINCT
                @v_master_id  AS MASTER_ID
              , @v_plan_id    AS PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.ITEM_ID     AS SALES_MODEL_ID
              , A.ITEM_ID     AS PRODUCT_ITEM_ID
              , @key_date     AS KEY_DATE
              , @v_proc_name  AS INSERT_ID
              , sysdatetime() AS INSERT_DATE
              , @v_proc_name  AS UPDATE_ID
              , sysdatetime() AS UPDATE_DATE
        FROM   TH_MST_SCM_ORDER_STATUS A
        WHERE  A.INSTANCE_ID = @v_master_id
        AND    A.FP_PLAN_ID = @v_plan_id
        AND    NOT EXISTS (
                            SELECT 1
                            FROM   TH_MST_SCM_SALES_PRODUCT X
                            WHERE  X.MASTER_ID = @v_master_id
                            AND    X.PLAN_ID = @v_plan_id
                            AND    X.COMPANY_ID = A.COMPANY_ID
                            AND    X.DIVISION_ID = A.DIVISION_ID
                            AND    X.SITE_ID = A.SITE_ID
                            AND    X.SALES_MODEL_ID = A.ITEM_ID
                          )
                  
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

      BEGIN

        SET @v_table_name = 'TH_MST_SCM_BOM'
        
        DELETE FROM TH_MST_SCM_BOM
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
        
        SET @n_row_count = @@ROWCOUNT
                  
        --DELETE FROM TH_MST_SCM_BOM
        --WHERE  KEY_DATE <= CONVERT(NVARCHAR, DATEADD(DAY, -7, CONVERT(DATE, @key_date)), 112)      

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        
        INSERT INTO TH_MST_SCM_BOM
              (
                MASTER_ID
              , PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , PARENT_ITEM_ID
              , CHILD_ITEM_ID
              , OPERATION_ID
              , FLOW_ID
              , ITEM_ATTRIBUTE
              , SETUP_ATTRIBUTE
              , BOM_VERSION_ID
              , BOM_VERSION_LINE
              , PARENT_QTY
              , PARENT_UOM
              , CHILD_QTY
              , CHILD_UOM
              , ALT_ID
              , ALT_PRIORITY
              , ALT_RATE
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM           
              )
        SELECT DISTINCT
                @v_master_id  AS MASTER_ID
              , @v_plan_id    AS PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , PARENT_ITEM_ID
              , CHILD_ITEM_ID
              , OPERATION_ID
              , FLOW_ID
              , ITEM_ATTRIBUTE
              , SETUP_ATTRIBUTE
              , KEY_DATE AS BOM_VERSION_ID
              , BOM_VERSION_LINE
              , PARENT_QTY
              , PARENT_UOM
              , CHILD_QTY
              , CHILD_UOM
              , ALT_ID
              , ALT_PRIORITY
              , ALT_RATE
              , KEY_DATE
              , @v_proc_name  AS INSERT_ID
              , sysdatetime() AS INSERT_DATE
              , @v_proc_name  AS UPDATE_ID
              , sysdatetime() AS UPDATE_DATE
        FROM   (
                SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID, 
                       AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID, EE.OPERATION_ID, EE.SEQ AS OPERATION_SEQ,
                       AA.BOM_VERSION_ID, AA.KEY_DATE, AA.BOM_VERSION_LINE, 
                       AA.PARENT_QTY, AA.PARENT_UOM, AA.CHILD_QTY, AA.CHILD_UOM, AA.ALT_ID, AA.ALT_PRIORITY, AA.ALT_RATE,
                       CC.FLOW_ID, CC.ITEM_ATTRIBUTE, CC.SETUP_ATTRIBUTE,
                       AA.EFF_START_DATE, AA.EFF_END_DATE
                FROM   SY_SCM_BOM_M AA,
                       (
                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.KEY_DATE
                        FROM   SY_SCM_BOM_M         A,
                               SY_SCM_ITEM_M        B,
                               SY_SCM_ITEM_CLASS_M  C
                        WHERE  1=1
                        AND    A.ACTIVE_FLAG    = 'Y'
                        AND    A.COMPANY_ID     = B.COMPANY_ID
                        AND    A.DIVISION_ID    = B.DIVISION_ID
                        AND    A.SITE_ID        = B.SITE_ID
                        AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
                        AND    B.ACTIVE_FLAG    = 'Y'
                        AND    B.ITEM_CLASS     = C.CLASS_ID  
                        AND    C.USE_FLAG       = 'Y'                                
                        --AND    A.EFF_START_DATE <= CONVERT(DATE, GETDATE())
                        AND    ISNULL(A.EFF_END_DATE, GETDATE()+365)   > CONVERT(DATE, GETDATE())
                        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.KEY_DATE
                        /*
                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID,
                               MAX(KEY_DATE) AS KEY_DATE
                        FROM   SY_SCM_BOM_M         A,
                               SY_SCM_ITEM_M        B,
                               SY_SCM_ITEM_CLASS_M  C
                        WHERE  1=1
                        AND    A.ACTIVE_FLAG    = 'Y'
                        AND    A.COMPANY_ID     = B.COMPANY_ID
                        AND    A.DIVISION_ID    = B.DIVISION_ID
                        AND    A.SITE_ID        = B.SITE_ID
                        AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
                        AND    B.ACTIVE_FLAG    = 'Y'
                        AND    B.ITEM_CLASS     = C.CLASS_ID  
                        AND    C.USE_FLAG       = 'Y'                                
                        AND    A.EFF_END_DATE  >= CONVERT(DATE, GETDATE())
                        GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                        */
                       ) BB,
                       SY_SCM_ITEM_M        CC,
                       SY_SCM_ITEM_CLASS_M  DD,
                       (
                        SELECT *
                        FROM   (
                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.FLOW_ID, A.OPERATION_ID,
                                       DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.FLOW_ID
                                                          ORDER     BY A.OPERATION_SEQ) AS SEQ  
                                FROM   SY_SCM_OPERATION_FLOW_M  A,
                                       SY_SCM_OPERATION_M       B
                                WHERE  A.ACTIVE_FLAG = 'Y'
                                AND    A.COMPANY_ID = B.COMPANY_ID
                                AND    A.DIVISION_ID = B.DIVISION_ID
                                AND    A.SITE_ID = B.SITE_ID
                                AND    A.OPERATION_ID = B.OPERATION_ID
                                AND    B.ACTIVE_FLAG = 'Y'
                                AND    EXISTS (
                                                SELECT 1
                                                FROM   SY_FP_INSTANCE_FACTORY_M X
                                                WHERE  X.INSTANCE_ID = @v_master_id
                                                AND    X.ACTIVE_FLAG = 'Y'
                                                AND    X.INSTANCE_TYPE = B.INSTANCE_TYPE
                                              )
                               ) A
                        WHERE  SEQ = 1
                       ) EE
                WHERE  AA.COMPANY_ID      = BB.COMPANY_ID
                AND    AA.DIVISION_ID     = BB.DIVISION_ID
                AND    AA.SITE_ID         = BB.SITE_ID
                AND    AA.PLANT_ID        = BB.PLANT_ID
                AND    AA.PARENT_ITEM_ID  = BB.PARENT_ITEM_ID
                AND    AA.CHILD_ITEM_ID   = BB.CHILD_ITEM_ID
                AND    AA.KEY_DATE        = BB.KEY_DATE
                AND    AA.ACTIVE_FLAG     = 'Y'
                AND    AA.BOM_VERSION_ID  = '1'
                --AND    AA.EFF_START_DATE <= CONVERT(DATE, GETDATE())
                AND    AA.EFF_END_DATE   >= CONVERT(DATE, GETDATE())
                AND    AA.COMPANY_ID      = CC.COMPANY_ID
                AND    AA.DIVISION_ID     = CC.DIVISION_ID
                AND    AA.SITE_ID         = CC.SITE_ID
                AND    AA.PARENT_ITEM_ID  = CC.ITEM_ID
                AND    CC.ITEM_CLASS      = DD.CLASS_ID
                AND    CC.ACTIVE_FLAG     = 'Y'
                AND    DD.USE_FLAG        = 'Y'
                AND    CC.COMPANY_ID      = EE.COMPANY_ID
                AND    CC.DIVISION_ID     = EE.DIVISION_ID
                AND    CC.SITE_ID         = EE.SITE_ID
                AND    CC.FLOW_ID         = EE.FLOW_ID
               ) A      
        WHERE  EXISTS  (
                        SELECT 1
                        FROM   (
                                SELECT DISTINCT 
                                       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
                                FROM   SY_SCM_FACTORY_M         A,
                                       SY_FP_INSTANCE_FACTORY_M B
                                WHERE  A.FACTORY_ID = B.FACTORY_ID
                                AND    B.INSTANCE_ID = @v_master_id
                                AND    A.ACTIVE_FLAG = 'Y'
                                AND    B.ACTIVE_FLAG = 'Y'
                               ) X
                        WHERE  X.COMPANY_ID = A.COMPANY_ID
                        AND    X.DIVISION_ID = A.DIVISION_ID
                        AND    X.SITE_ID = A.SITE_ID
                        AND    X.PLANT_ID = A.PLANT_ID
                       )
        
        SET @n_row_count = @@ROWCOUNT
                  
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
         
      END

      BEGIN

        SET @v_table_name = 'TH_MST_SCM_COMBINE_BOM'

        DELETE FROM TH_MST_SCM_COMBINE_BOM
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
        
        SET @n_row_count = @@ROWCOUNT
                  
        --DELETE FROM TH_MST_SCM_COMBINE_BOM
        --WHERE  KEY_DATE <= CONVERT(NVARCHAR, DATEADD(DAY, -7, CONVERT(DATE, @key_date)), 112)      

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        INSERT INTO TH_MST_SCM_COMBINE_BOM
        SELECT  DISTINCT
                A.MASTER_ID
              , A.PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.PARENT_ITEM_ID AS TOP_ITEM_ID
              , 1 AS BOM_LEVEL
              , A.PARENT_ITEM_ID
              , A.CHILD_ITEM_ID
              , A.OPERATION_ID
              , A.FLOW_ID
              , @key_date     AS KEY_DATE
              , @v_proc_name  AS INSERT_ID
              , sysdatetime() AS INSERT_DATE
              , @v_proc_name  AS UPDATE_ID
              , sysdatetime() AS UPDATE_DATE
        FROM    TH_MST_SCM_BOM A
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        AND     EXISTS (
                        SELECT 1
                        FROM   TH_MST_SCM_SALES_PRODUCT B
                        WHERE  B.MASTER_ID        = B.MASTER_ID
                        AND    B.PLAN_ID          = B.PLAN_ID
                        AND    B.COMPANY_ID       = A.COMPANY_ID
                        AND    B.DIVISION_ID      = A.DIVISION_ID
                        AND    B.SITE_ID          = A.SITE_ID
                        AND    B.PRODUCT_ITEM_ID  = A.PARENT_ITEM_ID
                       )
        /*
        AND     EXISTS ( 
                        SELECT 1
                        FROM   TH_MST_SCM_DEMAND B
                        WHERE  B.INSTANCE_ID = @v_master_id
                        AND    B.DPP_PLAN_ID = @v_plan_id
                        AND    B.COMPANY_ID = A.COMPANY_ID
                        AND    B.DIVISION_ID = A.DIVISION_ID
                        AND    B.SITE_ID = A.SITE_ID
                        AND    B.PLANT_ID = ( CASE WHEN B.SHOP_GROUP_ID = '-' THEN B.PLANT_ID ELSE A.PLANT_ID END )
                        AND    B.ITEM_ID = A.PARENT_ITEM_ID
                       )
        */
        
        SET @n_row_count = @@ROWCOUNT
                  
        --LOG 생성
        SET @v_message = 'TARGET DEMAND ( '+ CONVERT(nvarchar, 0) +' ) : ' + CONVERT(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        BEGIN

          DECLARE @n_loop int = 0

          SET @v_table_name = 'TH_MST_SCM_COMBINE_BOM'
          SET @n_row_count = 0

          WHILE 1 = 1
         
            BEGIN
              SET @n_loop += 1

              INSERT INTO TH_MST_SCM_COMBINE_BOM
              SELECT  DISTINCT
                      A.MASTER_ID
                    , A.PLAN_ID
                    , A.COMPANY_ID
                    , A.DIVISION_ID
                    , A.SITE_ID
                    , A.PLANT_ID
                    , A.TOP_ITEM_ID
                    , A.BOM_LEVEL + 1 AS BOM_LEVEL
                    , B.PARENT_ITEM_ID
                    , B.CHILD_ITEM_ID
                    , B.OPERATION_ID
                    , B.FLOW_ID
                    , @key_date     AS KEY_DATE
                    , @v_proc_name  AS INSERT_ID
                    , sysdatetime() AS INSERT_DATE
                    , @v_proc_name  AS UPDATE_ID
                    , sysdatetime() AS UPDATE_DATE
              FROM    TH_MST_SCM_COMBINE_BOM  A,
                      TH_MST_SCM_BOM          B
              WHERE   A.MASTER_ID = @v_master_id
              AND     A.PLAN_ID = @v_plan_id
              AND     A.BOM_LEVEL = @n_loop
              AND     A.MASTER_ID = B.MASTER_ID
              AND     A.PLAN_ID = B.PLAN_ID
              AND     A.COMPANY_ID = B.COMPANY_ID
              AND     A.DIVISION_ID = B.DIVISION_ID
              AND     A.SITE_ID = B.SITE_ID
              --AND     A.PLANT_ID = B.PLANT_ID
              AND     A.CHILD_ITEM_ID = B.PARENT_ITEM_ID

              SET @n_row_count = @@ROWCOUNT
              
              --LOG 생성
              SET @v_message = 'TARGET DEMAND ( '+ CONVERT(nvarchar, @n_loop) +' ) : ' + CONVERT(nvarchar, @n_row_count)
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

              IF @n_loop > 100 OR @n_row_count = 0
                BREAK

            END
        
        END
        
        BEGIN
        
          SET @v_table_name = 'TH_MST_SCM_PLAN_BOM'
          
          DELETE FROM TH_MST_SCM_PLAN_BOM
          WHERE  MASTER_ID = @v_master_id
          AND    PLAN_ID = @v_plan_id
          
          SET @n_row_count = @@ROWCOUNT
                    
          --DELETE FROM TH_MST_SCM_PLAN_BOM
          --WHERE  KEY_DATE <= CONVERT(NVARCHAR, DATEADD(DAY, -7, CONVERT(DATE, @key_date)), 112)      

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

          INSERT INTO TH_MST_SCM_PLAN_BOM
               (
                 MASTER_ID
               , PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , PARENT_ITEM_ID
               , CHILD_ITEM_ID
               , OPERATION_ID
               , FLOW_ID
               , ITEM_ATTRIBUTE
               , SETUP_ATTRIBUTE
               , BOM_VERSION_ID
               , BOM_VERSION_LINE
               , PARENT_QTY
               , PARENT_UOM
               , CHILD_QTY
               , CHILD_UOM
               , ALT_ID
               , ALT_PRIORITY
               , ALT_RATE
               , KEY_DATE
               , INSERT_ID
               , INSERT_DTTM
               , UPDATE_ID
               , UPDATE_DTTM          
               )
          SELECT 
                 MASTER_ID
               , PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , PARENT_ITEM_ID
               , CHILD_ITEM_ID
               , OPERATION_ID
               , FLOW_ID
               , ITEM_ATTRIBUTE
               , SETUP_ATTRIBUTE
               , BOM_VERSION_ID
               , BOM_VERSION_LINE
               , PARENT_QTY
               , PARENT_UOM
               , CHILD_QTY
               , CHILD_UOM
               , ALT_ID
               , ALT_PRIORITY
               , ALT_RATE
               , KEY_DATE
               , INSERT_ID
               , INSERT_DTTM
               , UPDATE_ID
               , UPDATE_DTTM          
          FROM   TH_MST_SCM_BOM A
          WHERE  A.MASTER_ID = @v_master_id
          AND    A.PLAN_ID = @v_plan_id
          AND    EXISTS (
                          SELECT 1
                          FROM   TH_MST_SCM_COMBINE_BOM B
                          WHERE  B.MASTER_ID = A.MASTER_ID
                          AND    B.PLAN_ID = A.PLAN_ID
                          AND    B.COMPANY_ID = A.COMPANY_ID
                          AND    B.DIVISION_ID = A.DIVISION_ID
                          AND    B.SITE_ID = A.SITE_ID
                          AND    B.PLANT_ID = A.PLANT_ID
                          AND    B.PARENT_ITEM_ID = A.PARENT_ITEM_ID
                          AND    B.CHILD_ITEM_ID = A.CHILD_ITEM_ID
                          AND    B.OPERATION_ID = A.OPERATION_ID
                          AND    B.FLOW_ID = A.FLOW_ID
                        )
          
          SET @n_row_count = @@ROWCOUNT
                    
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      
        END
        
      END;


      BEGIN
      
        SET @v_table_name = 'TH_MST_SCM_ITEM_OPERATION'
        
        DELETE FROM TH_MST_SCM_ITEM_OPERATION
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
        
        SET @n_row_count = @@ROWCOUNT
                  
        --DELETE FROM TH_MST_SCM_ITEM_OPERATION
        --WHERE  KEY_DATE <= CONVERT(NVARCHAR, DATEADD(DAY, -7, CONVERT(DATE, @key_date)), 112)      

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        INSERT INTO TH_MST_SCM_ITEM_OPERATION
              (
                MASTER_ID
              , PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , ITEM_ID
              , FLOW_ID
              , OPERATION_ID
              , OPERATION_SEQ
              , OPERATION_COUNT
              , ERP_OPERATION_ID
              , ORDER_TYPE
              , BATCH_TYPE
              , CAPA_TYPE
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM           
              )      
        SELECT  DISTINCT
                @v_master_id  AS MASTER_ID
              , @v_plan_id    AS PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , '-' FACTORY_ID
              , A.ITEM_ID
              , A.FLOW_ID
              , B.OPERATION_ID
              , B.SEQ AS OPERATION_SEQ
              , B.CNT AS OPERATION_COUNT
              , B.ERP_OPERATION_ID
              , B.ORDER_TYPE
              , B.BATCH_TYPE
              , B.CAPA_TYPE
              , @key_date     AS KEY_DATE
              , @v_proc_name  AS INSERT_ID
              , sysdatetime() AS INSERT_DATE
              , @v_proc_name  AS UPDATE_ID
              , sysdatetime() AS UPDATE_DATE
        FROM   (
                SELECT DISTINCT MASTER_ID, PLAN_ID, 
                       COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, 
                       PARENT_ITEM_ID AS ITEM_ID, FLOW_ID
                FROM   TH_MST_SCM_PLAN_BOM
                WHERE  MASTER_ID = @v_master_id
                AND    PLAN_ID = @v_plan_id
               ) A,
               (
                SELECT *
                FROM   (
                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.FLOW_ID, A.OPERATION_ID,
                               ISNULL(B.ERP_OPERATION_ID, 'ZZ') AS ERP_OPERATION_ID,
                               CASE WHEN B.WO_FLAG = 'Y' THEN 'W'
                                    WHEN B.MO_FLAG = 'Y' THEN 'M'
                                    ELSE 'W'
                               END  ORDER_TYPE,
                               CASE WHEN B.CAPA_TYPE = 'BATCH' THEN 'Y'
                                                               ELSE 'N'
                               END  BATCH_TYPE,
                               B.CAPA_TYPE,
                               COUNT(1) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.FLOW_ID
                                                  ORDER     BY A.OPERATION_SEQ) AS SEQ,
                               COUNT(1) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.FLOW_ID) AS CNT  
                        FROM   SY_SCM_OPERATION_FLOW_M  A,
                               SY_SCM_OPERATION_M       B
                        WHERE  A.ACTIVE_FLAG = 'Y'
                        AND    A.COMPANY_ID = B.COMPANY_ID
                        AND    A.DIVISION_ID = B.DIVISION_ID
                        AND    A.SITE_ID = B.SITE_ID
                        AND    A.OPERATION_ID = B.OPERATION_ID
                        AND    B.ACTIVE_FLAG = 'Y'
                        AND    EXISTS (
                                        SELECT 1
                                        FROM   SY_FP_INSTANCE_FACTORY_M X
                                        WHERE  X.INSTANCE_ID = @v_master_id
                                        AND    X.ACTIVE_FLAG = 'Y'
                                        AND    X.INSTANCE_TYPE = B.INSTANCE_TYPE
                                      )
                       ) A 
               ) B
        WHERE  A.COMPANY_ID = B.COMPANY_ID
        AND    A.DIVISION_ID = B.DIVISION_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.FLOW_ID = B.FLOW_ID


        SET @n_row_count = @@ROWCOUNT
                  
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN

        SET @v_table_name = 'TH_MST_INSTANCE_FLOW'

        DELETE TH_MST_INSTANCE_FLOW
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
        AND    ITEM_ID NOT IN (
                               SELECT ITEM_ID
                               FROM   TH_MST_SCM_ITEM_OPERATION
                               WHERE  MASTER_ID = @v_master_id
                               AND    PLAN_ID = @v_plan_id
                              )
        AND    ITEM_ID NOT IN (
                               SELECT ITEM_ID
                               FROM   TH_MST_SCM_ORDER_STATUS
                               WHERE  INSTANCE_ID = @v_master_id
                               AND    FP_PLAN_ID = @v_plan_id
                              )
      
        SET @n_row_count = @@ROWCOUNT
                  
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        DELETE TH_MST_INSTANCE_FLOW
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
        AND    OPERATION_ID LIKE 'E%'
        AND    OPERATION_ID > 'E4000'

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END
        
    END

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
