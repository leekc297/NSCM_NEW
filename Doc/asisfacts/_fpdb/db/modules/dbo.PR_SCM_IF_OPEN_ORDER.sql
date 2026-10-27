CREATE PROCEDURE [dbo].[PR_SCM_IF_OPEN_ORDER]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_OPEN_ORDER                                                      **/
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
  EXEC PR_SCM_IF_OPEN_ORDER
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_company        nvarchar(30)   
  DECLARE @v_division       nvarchar(30)
  DECLARE @v_corporation    nvarchar(30)
  DECLARE @v_plant          nvarchar(30)
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_amend_plan_id  nvarchar(30)
  
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime
  DECLARE @v_plan_type      nvarchar(30)
  DECLARE @v_daydiff        Integer

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_OPEN_ORDER'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)

  DECLARE @v_prod_plan_id       nvarchar(30)
  DECLARE @v_ship_plan_id       nvarchar(30)
  DECLARE @v_ship_elec_plan_id  nvarchar(30)
  DECLARE @v_srs_plan_id        nvarchar(30)
  DECLARE @v_prod_test_plan_id  nvarchar(30)
  
  DECLARE @v_demand_target  nvarchar(30)
  DECLARE @v_start_week     nvarchar(6)
  DECLARE @v_end_week       nvarchar(6)
  DECLARE @v_confirm_week   int
  DECLARE @v_instance_type  nvarchar(10)
  
  DECLARE @v_plan_date      DATE
  DECLARE @v_plan_week      nvarchar(30)
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)
  
  DECLARE @v_ncp_date       datetime

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)

  -------------------------------------------------------------------------------------------
  -- LINE 인지 EQUIPMENT 인지 설정하는 변수... 아주 중요
  -------------------------------------------------------------------------------------------
   DECLARE @res_category      nvarchar(10)
  -------------------------------------------------------------------------------------------
  
  SET @v_master_id      = @p_master_id
  SET @v_plan_id        = @p_plan_id
  
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
              @v_prod_plan_id       = SCP_PRODUCT_PLAN_ID,
              @v_ship_plan_id       = SCP_SHIPMENT_PLAN_ID,
              @v_ship_elec_plan_id  = SCP_SHIP_ELEC_PLAN_ID,
              @v_srs_plan_id        = SCP_SRS_PLAN_ID,
              @v_prod_test_plan_id  = SCP_PROD_TEST_PLAN_ID,
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
                     SCP_SHIP_ELEC_PLAN_ID,
                     SCP_SRS_PLAN_ID,
                     SCP_PROD_TEST_PLAN_ID,
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


      
      SELECT @v_demand_target = isnull(max(key_value), 'PRODUCT') 
      FROM   SY_FP_INSTANCE_CONFIG_M
      where  instance_id = @v_master_id
      and    category_id = 'DPP_CONFIG'
      and    key_id      = 'OFFSET'
      
      SET @v_message  = '@v_demand_target : ' + @v_demand_target
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

      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

      SELECT  @res_category = isnull(max(key_value), 'LINE')
      FROM    SY_FP_INSTANCE_CONFIG_M
      WHERE   instance_id = @v_master_id
      AND     category_id = 'RESOURCE_CATEGORY'
      AND     KEY_ID = @v_plan_type

      --LOG 생성
      SET @v_message = '@res_category : ' + @res_category
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      SET @v_table_name = 'SCM_FP_PLAN_H'

      SELECT @v_amend_plan_id = MIN(PRE_FIX_TARGET_ID)
      FROM   SY_SCM_FP_PLAN_H
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID     = @v_plan_id

      --LOG 생성
      SET @v_message = '@v_amend_plan_id : ' + @v_amend_plan_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END;

        
    ---------------------------------------------------------------------------------------
    -- OPEN WORK ORDER 를 여기서 집계한다..
    -- TARGET 기준 BOM, ITEM 정보를 사용하기 위해서,,
    BEGIN
    
      SELECT @v_ncp_date = MAX(DATE_ID)
      FROM   (
                SELECT DATE_ID, WEEK,
                       DENSE_RANK() OVER (ORDER BY WEEK) AS SEQ
                FROM   SY_SCM_SYS_CALENDAR_M
                WHERE  DATE_ID >= CONVERT(DATE, @plan_start_time)
             ) A
      WHERE  SEQ = 3
    

      SET @v_table_name = 'TH_MST_SCM_ORDER_STATUS'
      
      DELETE FROM TH_MST_SCM_ORDER_STATUS
      WHERE  INSTANCE_ID  = @v_master_id
      AND    FP_PLAN_ID   = @v_amend_plan_id
      AND    WO_STATUS    = 'AMEND'
      

      -- 전일 미세조정 정보를 가지고 온다.
      INSERT INTO TH_MST_SCM_ORDER_STATUS
            (
             INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, 
             FACTORY_ID, WORK_ORDER_SPL_ID, WORK_ORDER_ID, 
             PRODUCTION_TYPE, ITEM_ID, OPERATION_ID, LINE_ID, EQUIPMENT_ID,
             PLAN_DATE, PLAN_START_TIME, PLAN_END_TIME, PLAN_QTY,
             WO_STATUS, TOP_OPERATION_ITEM_ID, ORG_QTY, REMAIN_QTY,
             INSERT_ID, INSERT_TIME            
            )
      SELECT A.MASTER_ID, 
             @V_PLAN_ID AS PLAN_ID,
             B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID,
             A.AFTER_SITE_ID AS FACTORY_ID, A.WORK_ORDER_ID, A.WORK_ORDER_ID, 
             A.DEMAND_TYPE AS PRODUCTION_TYPE, A.ITEM_ID,  
             A.AFTER_OPERATION_ID AS OPERATION_ID, A.AFTER_ROUTE_ID AS LINE_ID, 
             A.AFTER_RESOURCE_ID AS EQUIPMENT_ID, CONVERT(DATE, A.AFTER_PLAN_DATE) AS PLAN_DATE, 
             DATEADD(MINUTE, @v_daydiff + AFTER_SEQ * 30 ,  CONVERT(DATETIME, A.AFTER_PLAN_DATE)) AS PLAN_START_TIME, 
             DATEADD(MINUTE, @v_daydiff + (AFTER_SEQ+1)*30, CONVERT(DATETIME, A.AFTER_PLAN_DATE)) AS PLAN_END_TIME, 
             A.AFTER_QTY, 'AMEND' AS WO_STATUS,
             CASE WHEN C.MAX_OPERATION_ID IS NOT NULL THEN 'TOP' ELSE NULL END AS TOP_OPERATION_ID,
             A.AFTER_QTY ORG_QTY, A.AFTER_QTY AS REMAIN_QTY, 
             @v_proc_name AS INSERT_ID, GETDATE() INSERT_TIME
      FROM   SY_FP_AMEND_PRODUCTION_PLAN_R A
             LEFT OUTER JOIN (
                              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID,
                                     FACTORY_ID, ITEM_ID, MAX(OPERATION_ID) AS MAX_OPERATION_ID
                              FROM   TH_MST_INSTANCE_FLOW A
                              WHERE  A.MASTER_ID  = @v_master_id
                              AND    A.PLAN_ID    = @v_amend_plan_id
                              AND    A.OPERATION_ID IN (
                                                         'A9000','A4000'    -- CELL
                                                        ,'E2000','E2500'    -- E_PRE
                                                        ,'E4000'            -- E_POST
                                                        ,'E0500'            -- E_PMIX
                                                        ,'S4000'            -- SRS
                                                       )  
                              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID,
                                        FACTORY_ID, ITEM_ID, OPERATION_ID                         
                             ) C
                  ON    A.AFTER_SITE_ID       = C.FACTORY_ID
                  AND   A.ITEM_ID             = C.ITEM_ID
                  AND   A.AFTER_OPERATION_ID  = C.MAX_OPERATION_ID
           , SY_SCM_FACTORY_M B
      WHERE  A.MASTER_ID  = @v_master_id
      AND    A.PLAN_ID    = @v_amend_plan_id
      AND    A.AFTER_SITE_ID = B.FACTORY_ID
      AND    A.AFTER_PLAN_DATE >= CONVERT(NVARCHAR, @plan_start_time, 112)
      AND    A.AFTER_PLAN_DATE <= CONVERT(NVARCHAR, @v_ncp_date     , 112)
      and    not exists ( -- OPEN WORK 이 있으면 미세조정에서 사용하지 않는다
                          SELECT 1
                          FROM   TH_MST_SCM_ORDER_STATUS X
                          WHERE  X.INSTANCE_ID   = A.MASTER_iD
                          AND    X.FP_PLAN_ID    = A.PLAN_ID
                          AND    X.WORK_ORDER_ID = A.WORK_ORDER_ID
                        )

      
      SET @n_row_count = @@ROWCOUNT
     
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

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
