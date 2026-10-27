CREATE PROCEDURE [dbo].[PR_SCM_IF_PLAN_PRE]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_PLAN_PRE                                                        **/
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
/** 2016.01.01    COCHO          최초 작성                                                    **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_PLAN_PRE
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_top_plan_id    nvarchar(30)
  DECLARE @n_count          integer = 0
  DECLARE @v_plan_date      nvarchar(10)

  DECLARE @n_engine_stop    Integer = 0

  DECLARE @v_target_start   nvarchar(10)
  DECLARE @v_target_end     nvarchar(10)

  DECLARE @v_prod_plan_id       nvarchar(30)
  DECLARE @v_ship_plan_id       nvarchar(30)
  DECLARE @v_ship_elec_plan_id  nvarchar(30)
  DECLARE @v_prod_test_plan_id  nvarchar(30)
  DECLARE @v_srs_plan_id        nvarchar(30)
  
  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_PLAN_PRE'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @v_plan_start     DATETIME
  DECLARE @v_basis_start    nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)
  
  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN
	  
	  DELETE FROM TH_MST_PLAN          
      WHERE MASTER_ID  = @v_master_id 
      AND   PLAN_ID = @v_plan_id
    
      --LOG 생성
      SET @v_table_name = 'TH_MST_PLAN'
      SET @v_descr = @@ROWCOUNT
      SET @v_message = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr  
	    
	  SET @n_count = 0
	  /*
      SELECT @n_count = COUNT(1)
      FROM   TH_MST_PLAN
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
	  */
      
      SELECT @v_plan_date = SUBSTRING(SUBSTR, 1, CHARINDEX('-', SUBSTR) -1) 
      FROM   (
              SELECT SUBSTRING(@v_plan_id, CHARINDEX('-', @v_plan_id) + 1, 999) SUBSTR
             ) A
      
      IF @n_count = 0 
        BEGIN

          SELECT @v_target_start = CONVERT(NVARCHAR, MIN(DATE_ID), 112), 
                 @v_target_end   = CONVERT(NVARCHAR, MAX(DATE_ID), 112)
          FROM   SY_SCM_SYS_CALENDAR_M A,
                 (-- 당주
                  SELECT WEEK
                  FROM   SY_SCM_SYS_CALENDAR_M
                  WHERE  DATE_ID = CONVERT(DATE, @v_plan_date )     -- ## PLAN_DATE 기준
                  UNION  ALL
                  -- 전주
                  SELECT WEEK
                  FROM   SY_SCM_SYS_CALENDAR_M
                  WHERE  DATE_ID = DATEADD(DAY, -7, CONVERT(DATE, @v_plan_date ))     -- ## PLAN_DATE 기준
                 ) B
          WHERE  A.WEEK = B.WEEK

          -- 2017.05.08 : 장기 휴무로 인해 SCP TARGET 이 없을 경우가 발생하여 MAX 로 바꿈.
          SELECT @v_top_plan_id = MAX(SCP_PLAN_ID)
          FROM   SY_fp_weekly_demand_product_h
          --WHERE  SUBSTRING(SCP_PLAN_ID, 1, 8) BETWEEN @v_target_start AND @v_target_end

          SELECT @v_prod_plan_id = MAX(SCP_PLAN_ID)
          FROM   SY_fp_weekly_demand_product_h
          --WHERE  SUBSTRING(SCP_PLAN_ID, 1, 8) BETWEEN @v_target_start AND @v_target_end

          SELECT @v_ship_plan_id = MAX(SCP_PLAN_ID)
          FROM   SY_fp_weekly_demand_shipment_h
          --WHERE  SUBSTRING(SCP_PLAN_ID, 1, 8) BETWEEN @v_target_start AND @v_target_end

          SELECT @v_ship_elec_plan_id = MAX(SCP_PLAN_ID)
          FROM   SY_FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H
          --WHERE  SUBSTRING(SCP_PLAN_ID, 1, 8) BETWEEN @v_target_start AND @v_target_end
		  /*
          SELECT @v_srs_plan_id = MAX(SRS_PLAN_ID)
          FROM   SY_fp_weekly_demand_product_srs_h
          --WHERE  SUBSTRING(SRS_PLAN_ID, 1, 8) BETWEEN @v_target_start AND @v_target_end
          */
          /*
          -- TARGET 은 전주, 당주를 기준으로 MAX PLAN 을 선택
          SELECT @v_top_plan_id = MAX(SCP_PLAN_ID)
          FROM   SY_fp_weekly_demand_product_h
          WHERE  SUBSTRING(SCP_PLAN_ID, 1, 8) BETWEEN @v_target_start AND @v_target_end

          SELECT @v_prod_plan_id = MAX(SCP_PLAN_ID)
          FROM   SY_fp_weekly_demand_product_h
          WHERE  SUBSTRING(SCP_PLAN_ID, 1, 8) BETWEEN @v_target_start AND @v_target_end

          SELECT @v_ship_plan_id = MAX(SCP_PLAN_ID)
          FROM   SY_fp_weekly_demand_shipment_h
          WHERE  SUBSTRING(SCP_PLAN_ID, 1, 8) BETWEEN @v_target_start AND @v_target_end

          SELECT @v_ship_elec_plan_id = MAX(SCP_PLAN_ID)
          FROM   SY_FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H
          WHERE  SUBSTRING(SCP_PLAN_ID, 1, 8) BETWEEN @v_target_start AND @v_target_end

          SELECT @v_srs_plan_id = MAX(SRS_PLAN_ID)
          FROM   SY_fp_weekly_demand_product_srs_h
          WHERE  SUBSTRING(SRS_PLAN_ID, 1, 8) BETWEEN @v_target_start AND @v_target_end
          */
          
          
          -- TEST 는 당일만...          
          SELECT @v_prod_test_plan_id = MAX(SCP_PLAN_ID)
          FROM   SY_FP_WEEKLY_DEMAND_PRODUCT_TEST_H
          WHERE  SCP_PLAN_ID LIKE '%' + @v_plan_date + '%'      -- 해당 일자의 MAX PLAN ID 만 선택한다.

          SELECT @v_basis_start = SEGMENT2 
          FROM   SY_SCM_SYS_LOOKUP_VALUE
          WHERE  LOOKUP_TYPE_CODE = 'BASIS_START_TIME'
          
          SET    @v_plan_start = CONVERT(DATETIME, @v_plan_date + ' ' + SUBSTRING(@v_basis_start, 1,2)
                                                                + ':' + SUBSTRING(@v_basis_start, 3,2)
                                                                + ':' + SUBSTRING(@v_basis_start, 5,2))

          SET @n_count = 0
          
          SELECT @n_count = COUNT(1)
          FROM   SY_SCM_FP_PLAN_H
          WHERE  INSTANCE_ID = @v_master_id
          AND    PLAN_ID = @v_plan_id

          SET @v_table_name = 'TH_MST_PLAN'

          IF @n_count = 0 

            INSERT INTO TH_MST_PLAN
                  (
                    MASTER_ID,
                    PLAN_ID,
                    PLAN_SEQ,
                    PLAN_TYPE,
                    PLAN_NAME,
                    PLAN_START_DTTM,
                    PLAN_DATE,
                    BASIS_START_TIME,
                    PLAN_HORIZON,
                    PLAN_HORIZON_UOM,
               		DEMAND_HORIZON,
                    DEMAND_HORIZON_UOM,
                    WEEK,
                    MONTH,
                    IS_RUNNING,
                    IS_FINISHED,
                    IS_CONFIRMED,
                    IS_AMEND_POSSIBLE,
                    IS_PLANDATE_START,
                    BASIS_PLAN_ID,
                    CONFIG_SET_ID,
                    DPP_CONFIG_SET_ID,
                    AMEND_MASTER_ID,
                    AMEND_PLAN_ID,
                    ORDER_START_SEQ,
                    TOP_PLAN_ID,
                    TOP_ROUTE_ID,
                    SCP_PRODUCT_PLAN_ID,
                    SCP_SHIPMENT_PLAN_ID,
                    SCP_SHIP_ELEC_PLAN_ID,
                    SCP_SRS_PLAN_ID,
                    SCP_PROD_TEST_PLAN_ID,
                    DESCR,
                    KEY_DATE,
                    INSERT_ID,
                    INSERT_DTTM,
                    UPDATE_ID,
                    UPDATE_DTTM
                  )
            SELECT 
                    @v_master_id                AS MASTER_ID,         
                    @v_plan_id                  AS PLAN_ID,           
                    1                           AS PLAN_SEQ,          
                    'PRE'                       AS PLAN_TYPE,         
                    'PRE PLAN'                  AS PLAN_NAME,         
                    DATEADD(HH, 8, CONVERT(DATETIME, @v_plan_date))  AS PLAN_START_DTTM,   
                    @v_plan_date                AS PLAN_DATE,         
                    @v_basis_start              AS BASIS_START_TIME,  
                    60                          AS PLAN_HORIZON,      
                    'DAY'                       AS PLAN_HORIZON_UOM,  
                    60                          AS DEMAND_HORIZON,    
                    'DAY'                       AS DEMAND_HORIZON_UOM,
                    WEEK                        AS WEEK,              
                    SUBSTRING(@v_plan_date,1,6) AS MONTH,             
                    'N'                         AS IS_RUNNING,        
                    'N'                         AS IS_FINISHED,       
                    'N'                         AS IS_CONFIRMED,      
                    ''                          AS IS_AMEND_POSSIBLE, 
                    'Y'                         AS IS_PLANDATE_START, 
                    @v_plan_id                  AS BASIS_PLAN_ID,     
                    'LG_CHEM'                   AS CONFIG_SET_ID,     
                    'DEFAULT'                   AS DPP_CONFIG_SET_ID, 
                    ''                          AS AMEND_MASTER_ID,   
                    ''                          AS AMEND_PLAN_ID,     
                    0                           AS ORDER_START_SEQ,   
                    @v_top_plan_id              AS TOP_PLAN_ID,       
                    ''                          AS TOP_ROUTE_ID, 
                    @v_prod_plan_id             AS SCP_PRODUCT_PLAN_ID,
                    @v_ship_plan_id             AS SCP_SHIPMENT_PLAN_ID,
                    @v_ship_elec_plan_id        AS SCP_SHIP_ELEC_PLAN_ID,
                    @v_srs_plan_id              AS SCP_SRS_PLAN_ID,
                    @v_prod_test_plan_id        AS SCP_PROD_TEST_PLAN_ID,
                    ''                          AS DESCR,      
                    @v_plan_date                AS KEY_DATE,
                    @v_proc_name                AS INSERT_ID,         
                    convert(date, @v_plan_date) AS INSERT_DTTM,       
                    @v_proc_name                AS UPDATE_ID,         
                    GETDATE()                   AS UPDATE_DTTM        
            FROM    SY_SCM_SYS_CALENDAR_M
            WHERE   DATE_ID = CONVERT(DATE, @v_plan_date)
        
          ELSE
        
            INSERT INTO TH_MST_PLAN
                  (
   					MASTER_ID,
                    PLAN_ID,
                    PLAN_SEQ,
                    PLAN_TYPE,
                    PLAN_NAME,
                    PLAN_START_DTTM,
                    PLAN_DATE,
                    BASIS_START_TIME,
                    PLAN_HORIZON,
                    PLAN_HORIZON_UOM,
                    DEMAND_HORIZON,
                    DEMAND_HORIZON_UOM,
                    WEEK,
                    MONTH,
                    IS_RUNNING,
                    IS_FINISHED,
                    IS_CONFIRMED,
                    IS_AMEND_POSSIBLE,
                    IS_PLANDATE_START,
                    BASIS_PLAN_ID,
                    CONFIG_SET_ID,
                    DPP_CONFIG_SET_ID,
                    AMEND_MASTER_ID,
                    AMEND_PLAN_ID,
                    ORDER_START_SEQ,
                    TOP_PLAN_ID,
                    TOP_ROUTE_ID,
                    SCP_PRODUCT_PLAN_ID,
                    SCP_SHIPMENT_PLAN_ID,
                    SCP_SHIP_ELEC_PLAN_ID,
                    SCP_SRS_PLAN_ID,
                    SCP_PROD_TEST_PLAN_ID,
                    DESCR,
                    KEY_DATE,
                    INSERT_ID,
                    INSERT_DTTM,
                    UPDATE_ID,
                    UPDATE_DTTM
                  )
            SELECT 
                    @v_master_id                AS MASTER_ID,         
                    @v_plan_id                  AS PLAN_ID,           
                    1                           AS PLAN_SEQ,          
                    							   PLAN_TYPE,         
                    PLAN_TYPE + ' PLAN'         AS PLAN_NAME,         
                    PLAN_START_TIME             AS PLAN_START_DTTM,   
                    @v_plan_date                AS PLAN_DATE,         
                    REPLACE(CONVERT(nvarchar, PLAN_START_TIME, 8), ':', '') AS BASIS_START_TIME,  
                    PLAN_HORIZON                AS PLAN_HORIZON,      
                    PLAN_HORIZON_UOM            AS PLAN_HORIZON_UOM,  
                    DEMAND_HORIZON              AS DEMAND_HORIZON,    
                    DEMAND_HORIZON_UOM          AS DEMAND_HORIZON_UOM,
                    PLAN_WEEK                   AS WEEK,              
                    CONVERT(nvarchar(6), PLAN_START_TIME, 112) AS MONTH,             
                    'N'                         AS IS_RUNNING,        
                    'N'                         AS IS_FINISHED,       
                    'N'                         AS IS_CONFIRMED,      
                    ''                          AS IS_AMEND_POSSIBLE, 
                    'Y'                         AS IS_PLANDATE_START, 
                    BASIS_PLAN_ID               AS BASIS_PLAN_ID,     
                    CONFIG_SET_ID               AS CONFIG_SET_ID,     
                    'DEFAULT'                   AS DPP_CONFIG_SET_ID, 
                    ''                          AS AMEND_MASTER_ID,   
                    ''                          AS AMEND_PLAN_ID,     
                    0                           AS ORDER_START_SEQ,   
                    BASIS_PLAN_ID               AS TOP_PLAN_ID,       
                    ''                          AS TOP_ROUTE_ID, 
                    SCP_PLAN_ID                 AS SCP_PRODUCT_PLAN_ID,
                    SCP_PLAN_ID                 AS SCP_SHIPMENT_PLAN_ID,
                    SCP_PLAN_ID        			AS SCP_SHIP_ELEC_PLAN_ID,
                    NULL              			AS SCP_SRS_PLAN_ID,
                    SCP_PLAN_ID        			AS SCP_PROD_TEST_PLAN_ID,
                    ''                          AS DESCR,             
                    @v_plan_date                AS KEY_DATE,
                    @v_proc_name                AS INSERT_ID,         
                    convert(date, @v_plan_date) AS INSERT_DTTM,       
                    @v_proc_name                AS UPDATE_ID,         
                    GETDATE()                   AS UPDATE_DTTM        
            FROM   SY_SCM_FP_PLAN_H A
            WHERE  INSTANCE_ID = @v_master_id
            AND    PLAN_ID = @v_plan_id

          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END
	  
      /*
      -- 무조건 8주만 선택한다.
      UPDATE TH_MST_PLAN
      SET    TH_MST_PLAN.DEMAND_HORIZON = NEW_PLAN_HORIZON
           , TH_MST_PLAN.PLAN_HORIZON   = NEW_PLAN_HORIZON
      FROM   TH_MST_PLAN A,
             (
              SELECT DISTINCT
                     A.MASTER_ID, A.PLAN_ID, START_DATE, WEEKEND_DATE
                   , DATEDIFF(DAY, START_DATE, WEEKEND_DATE) + 1  AS NEW_PLAN_HORIZON
              FROM   (
                      SELECT A.*, B.*,
                             DENSE_RANK() OVER (ORDER BY B.WEEK) AS WEEK_SEQ
                      FROM   (
                              SELECT A.MASTER_ID
                                   , A.PLAN_ID
                                   , CONVERT(DATE, PLAN_DATE) AS START_DATE, PLAN_HORIZON
                                   , DATEADD(DAY, PLAN_HORIZON - 1, CONVERT(DATE, PLAN_DATE)) AS END_DATE
                                   , CEILING(56 / 7) AS WEEK_CNT
                              FROM   TH_MST_PLAN A
                              WHERE  A.MASTER_ID  = @v_master_id
                              AND    A.PLAN_ID    = @v_plan_id
                             ) A,
                             SY_SCM_SYS_CALENDAR_M B
                      WHERE  B.DATE_ID BETWEEN A.START_DATE AND A.END_DATE
                     ) A
              WHERE  WEEK_SEQ = WEEK_CNT
             ) B
      WHERE  A.MASTER_ID = B.MASTER_ID
      AND    A.PLAN_ID = B.PLAN_ID
	  */
      
      -- 해당 주차 마지막 요일 + 1일로 plan 구간 설정
      /*
      UPDATE TH_MST_PLAN
      SET    TH_MST_PLAN.DEMAND_HORIZON = DATEDIFF(DD, CONVERT(DATE, A.PLAN_START_DTTM), C.DATE_ID) + 1
           , TH_MST_PLAN.PLAN_HORIZON   = DATEDIFF(DD, CONVERT(DATE, A.PLAN_START_DTTM), C.DATE_ID) + 1
      FROM   TH_MST_PLAN A,
             SY_SCM_SYS_CALENDAR_M B,
             SY_SCM_SYS_CALENDAR_M C
      WHERE  A.MASTER_ID = @v_master_id
      AND    A.PLAN_ID = @v_plan_id
      AND    B.DATE_ID = CONVERT(DATE, DATEADD(DD, DEMAND_HORIZON - 1, PLAN_START_DTTM))
      AND    B.WEEK = C.WEEK
      AND    C.DAY = 'SUN' 
      */
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = 'PLAN-HORIZON'
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
    
    END
    
    BEGIN
    
      SET @v_table_name = 'TH_CFG_CONFIG_VALUE'
      
      DELETE FROM TH_CFG_CONFIG_VALUE
      WHERE  CONFIG_SET_ID = 'LG_CHEM'
      
      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      
      INSERT INTO TH_CFG_CONFIG_VALUE
      SELECT  'LGC' AS COMPANY,
              'LGC' AS DIVISION,
              'LGC' AS CORPORATION,
              'LGC' AS PLANT,
              CATEGORY_ID AS PLAN_TYPE,
              CONFIG_SET_ID,
              KEY_ID,
              VALUE_TYPE, 
              KEY_VALUE AS VALUE, 
              DESCRIPTION AS DESCR,
              @v_proc_name+'_'+@v_master_id AS INSERT_ID,
              GETDATE() AS INSERT_DTTM,
              @v_proc_name+'_'+@v_master_id AS UPDATE_ID,
              GETDATE() AS UPDATE_DTTM
      FROM    SY_FP_INSTANCE_CONFIG_M A
      WHERE   1=1
      AND     INSTANCE_ID = @v_master_id
      AND     CATEGORY_ID = 'ENGINE'
      AND     NOT EXISTS (-- 키 중복 방지..
                          SELECT 1
                          FROM   TH_CFG_CONFIG_VALUE X
                          WHERE  X.COMPANY        = 'LGC'
                          AND    X.DIVISION       = 'LGC'
                          AND    X.CORPORATION    = 'LGC'
                          AND    X.PLANT          = 'LGC'
                          AND    X.PLAN_TYPE      = A.CATEGORY_ID
                          AND    X.CONFIG_SET_ID  = A.CONFIG_SET_ID
                          AND    X.KEY_ID         = A.KEY_ID
                         )      
    
      set @n_row_count = @@ROWCOUNT


      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      SET @v_table_name = 'TH_CFG_CONFIG_SELECTOR'
      
      DELETE FROM TH_CFG_CONFIG_SELECTOR
      WHERE  1=1
      
      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      
      INSERT INTO TH_CFG_CONFIG_SELECTOR
      SELECT DISTINCT
             'LGC' AS COMPANY,
             'LGC' AS DIVISION,
             'LGC' AS CORPORATION,
             'LGC' AS PLANT,
             'ENGINE' AS PLAN_TYPE,
             CATEGORY_ID AS KEY_ID,
             KEY_ID AS SELECTOR_ID,
             KEY_VALUE AS COMPARATOR_ID,
             KEY_VALUE AS COMPARATOR_NAME,
             NULL AS TRUE_KEY_ID,
             NULL AS FALSE_KEY_ID,
             KEY_PRIORITY AS APPLY_ORDER,
             1 AS VIEW_LEVEL,
             TOLERANCE,
             TOLERANCE_UOM,
             DESCRIPTION AS DESCR,
             @v_proc_name+'_'+@v_master_id AS INSERT_ID,
             GETDATE() AS INSERT_DTTM,
             @v_proc_name+'_'+@v_master_id AS UPDATE_ID,
             GETDATE() AS UPDATE_DTTM,
             'Y' AS IS_USE
      FROM   SY_FP_INSTANCE_CONFIG_M A
      WHERE  1=1
      AND    INSTANCE_ID = @v_master_id
      AND    CATEGORY_ID LIKE '%SELECTOR%'
      AND    PART_ID = 'PRE'
      AND    NOT EXISTS (
                          SELECT 1
                          FROM   TH_CFG_CONFIG_SELECTOR X
                          WHERE  X.COMPANY        = 'LGC'
                          AND    X.DIVISION       = 'LGC'
                          AND    X.CORPORATION    = 'LGC'
                          AND    X.PLANT          = 'LGC'
                          AND    X.PLAN_TYPE      = 'ENGINE'
                          AND    X.KEY_ID         = A.CATEGORY_ID
                          AND    X.SELECTOR_ID    = A.KEY_ID
                          AND    X.COMPARATOR_ID  = A.KEY_VALUE
                        )
    
      set @n_row_count = @@ROWCOUNT


      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
    END
    
    BEGIN
    
      SET @v_table_name = 'TH_MST_INSTANCE_FLOW'
      
      DELETE FROM TH_MST_INSTANCE_FLOW
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      
      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      
      INSERT INTO TH_MST_INSTANCE_FLOW
            (
             MASTER_ID,
             PLAN_ID,
             COMPANY_ID, 
             DIVISION_ID, 
             SITE_ID, 
             PLANT_ID,
             FACTORY_ID,
             ITEM_ID, 
             OPERATION_ID, 
             OPERATION_SEQ,
             ERP_OPERATION_ID,
             ORDER_TYPE,
             BATCH_TYPE,
             CAPA_TYPE,
             HALF_SLIT_FLAG,
             KEY_DATE,
             INSERT_ID,
             INSERT_DTTM,
             UPDATE_ID,
             UPDATE_DTTM
            )
      /*
      SELECT DISTINCT 
             @v_master_id AS MASTER_ID,
             @v_plan_id   AS PLAN_ID,
             A.COMPANY_ID, 
             A.DIVISION_ID, 
             A.SITE_ID, 
             B.PLANT_ID, 
             A.ITEM_ID, 
             A.OPERATION_ID, 
             A.OPERATION_SEQ,
             ISNULL(B.ERP_OPERATION_ID, 'ZZ') AS ERP_OPERATION_ID,
             CASE WHEN B.WO_FLAG = 'Y' THEN 'W'
                  WHEN B.MO_FLAG = 'Y' THEN 'M'
                  ELSE 'W'
             END  ORDER_TYPE,
             CASE WHEN CAPA_TYPE = 'BATCH' THEN 'Y'
                                           ELSE 'N'
             END  BATCH_TYPE,
             CAPA_TYPE,
             @v_plan_date                AS KEY_DATE,
             @v_proc_name as INSERT_ID,
             convert(date, @v_plan_date) as INSERT_DTTM,
             @v_proc_name as UPDATE_ID,
             getdate() as UPDATE_DTTM
      --
      FROM   (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID,
                     B.FLOW_ID, B.OPERATION_ID, B.OPERATION_SEQ
              FROM   SY_SCM_ITEM_M A
                      INNER JOIN SY_SCM_OPERATION_FLOW_M B
                            ON     A.COMPANY_ID = B.COMPANY_ID
                            AND    A.DIVISION_ID = B.DIVISION_ID
                            AND    A.SITE_ID = B.SITE_ID
                            AND    A.FLOW_ID = B.FLOW_ID
                            AND    B.ACTIVE_FLAG = 'Y'
                      INNER JOIN SY_SCM_ITEM_CLASS_M C
                            ON     A.ITEM_CLASS = C.CLASS_ID
                            AND    C.USE_FLAG = 'Y'
              WHERE  A.ACTIVE_FLAG = 'Y'   
             ) A,
             (
              SELECT A.*, B.PLANT_ID, B.FACTORY_ID
              FROM   SY_SCM_OPERATION_M A,
                     (
                      SELECT B.*, A.INSTANCE_TYPE 
                      FROM   SY_FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                             SY_SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
                      WHERE  A.INSTANCE_ID = @v_master_id
                      AND    A.FACTORY_ID = B.FACTORY_ID
                      AND    B.ACTIVE_FLAG = 'Y'
                     ) B       
              WHERE  A.COMPANY_ID    = B.COMPANY_ID
              AND    A.DIVISION_ID   = B.DIVISION_ID
              AND    A.SITE_ID       = B.SITE_ID
              AND    A.INSTANCE_TYPE = B.INSTANCE_TYPE
             ) B
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.OPERATION_ID = B.OPERATION_ID
      */
      SELECT DISTINCT 
             @v_master_id AS MASTER_ID,
             @v_plan_id   AS PLAN_ID,
             A.COMPANY_ID, 
             A.DIVISION_ID, 
             A.SITE_ID, 
             A.PLANT_ID, 
             A.FACTORY_ID,
             A.ITEM_ID, 
             A.OPERATION_ID, 
             A.OPERATION_SEQ,
             ISNULL(B.ERP_OPERATION_ID, 'ZZ') AS ERP_OPERATION_ID,
             CASE WHEN B.WO_FLAG = 'Y' THEN 'W'
                  WHEN B.MO_FLAG = 'Y' THEN 'M'
                  ELSE 'W'
             END  ORDER_TYPE,
             CASE WHEN CAPA_TYPE = 'BATCH' THEN 'Y'
                                           ELSE 'N'
             END  BATCH_TYPE,
             CAPA_TYPE,
             'N'                         AS HALF_SLIT_FLAG,
             @v_plan_date               AS KEY_DATE,
             @v_proc_name as INSERT_ID,
             convert(date, @v_plan_date) as INSERT_DTTM,
             @v_proc_name as UPDATE_ID,
             getdate() as UPDATE_DTTM
      FROM   (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, D.PLANT_ID, D.FACTORY_ID, A.ITEM_ID,
                     B.FLOW_ID, B.OPERATION_ID, B.OPERATION_SEQ
              FROM   SY_SCM_ITEM_M A
                      INNER JOIN SY_SCM_OPERATION_FLOW_M B
                            ON     A.COMPANY_ID = B.COMPANY_ID
                            AND    A.DIVISION_ID = B.DIVISION_ID
                            AND    A.SITE_ID = B.SITE_ID
                            AND    A.FLOW_ID = B.FLOW_ID
                            AND    B.ACTIVE_FLAG = 'Y'
                      INNER JOIN SY_SCM_ITEM_CLASS_M C
                            ON     A.ITEM_CLASS = C.CLASS_ID
                            AND    C.USE_FLAG = 'Y'
                   , (
                      SELECT B.*, A.INSTANCE_TYPE 
                      FROM   SY_FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                             SY_SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
                      WHERE  A.INSTANCE_ID = @v_master_id
                      AND    A.FACTORY_ID = B.FACTORY_ID
                      AND    B.ACTIVE_FLAG = 'Y'
                     ) D
              WHERE  A.ACTIVE_FLAG = 'Y'
              AND    A.COMPANY_ID = D.COMPANY_ID
              AND    A.DIVISION_ID = D.DIVISION_ID
              AND    A.SITE_ID = D.SITE_ID
              /*
              UNION  ALL
              -- HALF_SLIT 강제 설정 
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,
                     'E2500' AS FLOW_ID, 'E2500' AS OPERATION_ID, B.OPERATION_SEQ
              FROM   SY_SCM_ITEM_LANE_M A,
                     (
                      SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, MAX(OPERATION_SEQ) AS OPERATION_SEQ
                      FROM   SY_SCM_OPERATION_FLOW_M 
                      WHERE  OPERATION_ID = 'E2500'
                      GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID
                     ) B
              WHERE  A.ACTIVE_FLAG = 'Y'
              AND    A.HALF_SLIT_FLAG = 'Y'
              AND    A.COMPANY_ID = B.COMPANY_ID
              AND    A.DIVISION_ID = B.DIVISION_ID
              AND    A.SITE_ID = B.SITE_ID
              */
             ) A,
             (
              SELECT A.*, B.PLANT_ID, B.FACTORY_ID
              FROM   SY_SCM_OPERATION_M A,
                     (
                      SELECT B.*, A.INSTANCE_TYPE 
                      FROM   SY_FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                             SY_SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
                      WHERE  A.INSTANCE_ID = @v_master_id
                      AND    A.FACTORY_ID = B.FACTORY_ID
                      AND    B.ACTIVE_FLAG = 'Y'
                     ) B       
              WHERE  A.COMPANY_ID    = B.COMPANY_ID
              AND    A.DIVISION_ID   = B.DIVISION_ID
              AND    A.SITE_ID       = B.SITE_ID
              AND    A.INSTANCE_TYPE = B.INSTANCE_TYPE
             ) B
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.FACTORY_ID = B.FACTORY_ID
      AND    A.OPERATION_ID = B.OPERATION_ID
      AND    EXISTS ( -- BOM 단종 제약 설정 -- 2017.01.25
                      SELECT 1
                      FROM   (
                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                                   , MAX(KEY_DATE) AS KEY_DATE
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
                              AND    A.BOM_VERSION_ID = '1'
                              --AND    A.EFF_END_DATE   >  GETDATE()
                              AND    A.EFF_END_DATE   >  CONVERT(DATE, @v_plan_date)
                              GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                              /*
                              SELECT AA.*
                              FROM   SY_SCM_BOM_M AA,
                                     (
                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID
                                           , MAX(KEY_DATE) AS KEY_DATE
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
                                      AND    A.BOM_VERSION_ID = '1'
                                      AND    A.EFF_END_DATE   >  GETDATE()
                                      GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID
                                     ) BB,
                                     SY_SCM_ITEM_M        CC,
                                     SY_SCM_ITEM_CLASS_M  DD
                              WHERE  AA.COMPANY_ID      = BB.COMPANY_ID
                              AND    AA.DIVISION_ID     = BB.DIVISION_ID
                              AND    AA.SITE_ID         = BB.SITE_ID
                              AND    AA.PLANT_ID        = BB.PLANT_ID
                              AND    AA.PARENT_ITEM_ID  = BB.PARENT_ITEM_ID
                              AND    AA.KEY_DATE        = BB.KEY_DATE
                              AND    AA.COMPANY_ID     = CC.COMPANY_ID
                              AND    AA.DIVISION_ID    = CC.DIVISION_ID
                              AND    AA.SITE_ID        = CC.SITE_ID
                              AND    AA.CHILD_ITEM_ID  = CC.ITEM_ID  
                              AND    CC.ACTIVE_FLAG    = 'Y'
                              AND    CC.ITEM_CLASS     = DD.CLASS_ID  
                              AND    DD.USE_FLAG       = 'Y'                    
                              AND    AA.ACTIVE_FLAG     = 'Y'
                              AND    AA.BOM_VERSION_ID  = '1'
                              AND    AA.EFF_END_DATE  >= GETDATE()     
                              */
                             ) X
                      WHERE  A.COMPANY_ID   = X.COMPANY_ID
                      AND    A.DIVISION_ID  = X.DIVISION_ID
                      AND    A.SITE_ID      = X.SITE_ID
                      --AND    A.PLANT_ID     = X.PLANT_ID
                      AND    A.ITEM_ID      = X.PARENT_ITEM_ID
                      )
      
      set @n_row_count = @@ROWCOUNT


      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      /*
      UPDATE TH_MST_INSTANCE_FLOW
      SET    TH_MST_INSTANCE_FLOW.HALF_SLIT_FLAG = 'Y'
      FROM   TH_MST_INSTANCE_FLOW A
           , (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,
                     'E2500' AS OPERATION_ID
              FROM   SY_SCM_ITEM_LANE_M A
              WHERE  A.ACTIVE_FLAG    = 'Y'
              AND    A.HALF_SLIT_FLAG = 'Y'
             ) B 
      WHERE  A.MASTER_ID    = @v_master_id
      AND    A.PLAN_ID      = @v_plan_id
      AND    A.COMPANY_ID   = B.COMPANY_ID
      AND    A.DIVISION_ID  = B.DIVISION_ID
      AND    A.SITE_ID      = B.SITE_ID
      AND    A.PLANT_ID     = B.PLANT_ID
      AND    A.FACTORY_ID   = B.FACTORY_ID
      AND    A.ITEM_ID      = B.ITEM_ID
      AND    A.OPERATION_ID > B.OPERATION_ID      -- 2500 보다 큰 애들,,, 2500 은 뒤어서 짜르기 때문에.. 그보다 큰놈들을 한다.

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
	  */
      
      IF @v_master_id <> '-'
        BEGIN


          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_TARGET      @v_master_id,@v_plan_id ;
            
          ---------------------------------------------------------------------------
          /*
          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_OPEN_ORDER  @v_master_id,@v_plan_id ;
		  */
          ---------------------------------------------------------------------------

          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_PREPROCESS  @v_master_id,@v_plan_id ;

          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_PRECALENDAR @v_master_id,@v_plan_id ;

          -- 실행순서 바꾸지 말것....
          
          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_ITEM        @v_master_id,@v_plan_id ;

          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_LANE        @v_master_id,@v_plan_id ;

          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_BOR         @v_master_id,@v_plan_id ;

          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_ROUTE       @v_master_id,@v_plan_id ;

          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_BOM         @v_master_id,@v_plan_id ;

          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_BOD         @v_master_id,@v_plan_id ;

          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_SETUP       @v_master_id,@v_plan_id ;

          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_CALENDAR    @v_master_id,@v_plan_id ;   -- BOR 이 먼저 실행되어야 한다.

          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_SALES       @v_master_id,@v_plan_id ;

          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_BATCH       @v_master_id,@v_plan_id ;   -- ITEM GROUP ID 추가, PRIORITY 룰 지정
          
          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_DPP_DEMAND     @v_master_id,@v_plan_id ;

          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_DEMAND      @v_master_id,@v_plan_id ;

          -----------------------------------------------------------------------------------
          -- 특화 PROCESS
          -----------------------------------------------------------------------------------
          
          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            EXECUTE dbo.PR_SCM_IF_STOCK       @v_master_id,@v_plan_id ;

          --EXECUTE dbo.PR_SCM_IF_OPERATION_SITE  @v_master_id,@v_plan_id ;


          IF dbo.fn_plan_status(@v_master_id, @v_plan_id) > 0
             UPDATE SY_FP_PLAN_STATUS_H
                SET 
                   ACTIVE_FLAG = 0,
                   INBOUND_FLAG = 'S',
                   INBOUND_END = sysdatetime(), 
                   UPDATE_ID = @v_proc_name, 
                   UPDATE_TIME = sysdatetime()
             FROM SY_FP_PLAN_STATUS_H  AS a
             WHERE 
                a.INSTANCE_ID = @v_master_id AND 
                a.PLAN_ID = @v_plan_id            

        END

      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END;
    
  END TRY

  BEGIN CATCH
    --ROLLBACK
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr
    commit;
  END CATCH

  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
