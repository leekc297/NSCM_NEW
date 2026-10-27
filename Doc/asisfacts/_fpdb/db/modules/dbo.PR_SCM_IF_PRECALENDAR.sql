CREATE PROCEDURE [dbo].[PR_SCM_IF_PRECALENDAR]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_PRECALENDAR                                                      **/
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
  EXEC PR_SCM_IF_PRECALENDAR
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_PRECALENDAR'
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

        SET @v_table_name = 'C_OFF_CAL'
        SET @n_row_count = 0

        DELETE FROM TH_MST_SCM_OFF_CALENDAR
        WHERE  MASTER_ID  = @v_master_id
        AND    PLAN_ID    = @v_plan_id

        DELETE FROM TH_MST_SCM_OFF_CALENDAR
        WHERE  INSERT_TIME < DATEADD(DAY, -7, GETDATE())
        
        DECLARE C_OFF_CAL CURSOR FOR
          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, C.EQUIPMENT_ID
               , CONVERT(DATE, START_TIME) AS PLAN_DATE
               , B.START_TIME AS OFF_START_TIME, DATEADD(MINUTE, CASE WHEN A.OFF_TIME_TERM > 1440 THEN 1440 ELSE A.OFF_TIME_TERM END , B.START_TIME) AS OFF_END_TIME
          FROM   SY_SCM_OFF_CALENDAR_LINE_M A,
                 (
                  SELECT CONVERT(nvarchar, DATEADD(DAY, INT-1, PLAN_START_DTTM), 112) AS PLAN_DATE,
                  		 DATEADD(DAY, INT-1, PLAN_START_DTTM) AS START_TIME, 
                         DATEADD(DAY, INT-0, PLAN_START_DTTM) AS END_TIME
                  FROM   TH_MST_PLAN A,                  
                         COPYT B
                  WHERE  1=1
                  AND    MASTER_ID = @v_master_id
                  AND    PLAN_ID   = @v_plan_id
                  AND    PLAN_HORIZON >= INT - 1
                 ) B,
                 SY_SCM_EQUIPMENT_M C
          WHERE  1=1
          AND    CONVERT(nvarchar, A.OFF_DATE, 112) = PLAN_DATE
          AND 	 A.COMPANY_ID = C.COMPANY_ID
          AND 	 A.SITE_ID = C.SITE_ID
          AND 	 A.DIVISION_ID = C.DIVISION_ID
          AND    A.PLANT_ID = C.PLANT_ID
          AND    A.FACTORY_ID = C.FACTORY_ID
          AND    A.OPERATION_ID = C.OPERATION_ID
          AND    A.LINE_ID = C.LINE_ID
          AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE
          AND    C.ACTIVE_FLAG = 'Y'
          AND    EXISTS (
                          SELECT 1
                          FROM   TH_MST_INSTANCE_FLOW X
                          WHERE  1=1
                          AND    X.MASTER_ID    = @v_master_id
                          AND    X.PLAN_ID      = @v_plan_id
                          AND    X.COMPANY_ID   = A.COMPANY_ID
                          AND    X.DIVISION_ID  = A.DIVISION_ID
                          AND    X.SITE_ID      = A.SITE_ID
     AND    X.PLANT_ID     = A.PLANT_ID
                          AND    X.FACTORY_ID   = A.FACTORY_ID
                          AND    X.OPERATION_ID = A.OPERATION_ID
                        )
          ORDER  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID
                  , OFF_START_TIME, OFF_END_TIME

        DECLARE 							-- 커서로 받을 변수
          @COMPANY_ID       nvarchar(30),
          @DIVISION_ID      nvarchar(30),
          @SITE_ID          nvarchar(30),
          @PLANT_ID         nvarchar(30),
          @FACTORY_ID       nvarchar(30),
          @OPERATION_ID     nvarchar(30),
          @LINE_ID          nvarchar(30),
          @ELECTRODE_TYPE   nvarchar(30),
          @EQUIPMENT_ID     nvarchar(30),
          @PLAN_DATE        datetime,
          @OFF_START_TIME   datetime,
          @OFF_END_TIME     datetime
      
        DECLARE 							-- 커서로 받을 변수
          @n_check          Int
      
        OPEN C_OFF_CAL
        
        WHILE 1 = 1
        BEGIN
          
          FETCH C_OFF_CAL
          INTO  
                @COMPANY_ID       ,
                @DIVISION_ID      ,
                @SITE_ID          ,
                @PLANT_ID         ,
                @FACTORY_ID       ,
                @OPERATION_ID     ,
                @LINE_ID          ,
                @ELECTRODE_TYPE   ,
                @EQUIPMENT_ID     ,
                @PLAN_DATE        ,
                @OFF_START_TIME   ,
                @OFF_END_TIME     

          IF @@FETCH_STATUS <> 0
            BREAK;
            
          SELECT @n_check = COUNT(1)
          FROM   TH_MST_SCM_OFF_CALENDAR
          WHERE  MASTER_ID        = @v_master_id
          AND    PLAN_ID          = @v_plan_id
          AND    COMPANY_ID       = @COMPANY_ID 
          AND    DIVISION_ID      = @DIVISION_ID      
          AND    SITE_ID          = @SITE_ID          
          AND    PLANT_ID         = @PLANT_ID         
          AND    FACTORY_ID       = @FACTORY_ID       
          AND    OPERATION_ID     = @OPERATION_ID     
          AND    LINE_ID          = @LINE_ID       
          AND    ELECTRODE_TYPE   = @ELECTRODE_TYPE
          AND    EQUIPMENT_ID     = @EQUIPMENT_ID     
          AND    PLAN_DATE        = @PLAN_DATE
          AND    OFF_START_TIME  >= @OFF_START_TIME
          AND    OFF_END_TIME    <= @OFF_START_TIME
          
          IF @n_check = 0
            INSERT INTO TH_MST_SCM_OFF_CALENDAR
            SELECT 
                    @v_master_id      ,
                    @v_plan_id        ,
                    @COMPANY_ID       ,
                    @DIVISION_ID      ,
                    @SITE_ID          ,
                    @PLANT_ID         ,
                    @FACTORY_ID       ,
                    @OPERATION_ID     ,
                    @LINE_ID          ,
                    @ELECTRODE_TYPE   ,
                    @EQUIPMENT_ID     ,
                    @PLAN_DATE        ,
                    @OFF_START_TIME   ,
                    @OFF_END_TIME     ,
                    GETDATE()
          ELSE
            UPDATE TH_MST_SCM_OFF_CALENDAR
            SET    OFF_START_TIME   = CASE WHEN OFF_START_TIME > @OFF_START_TIME THEN @OFF_START_TIME ELSE OFF_START_TIME  END
                 , OFF_END_TIME     = CASE WHEN OFF_END_TIME   > @OFF_END_TIME   THEN OFF_END_TIME    ELSE @OFF_END_TIME   END
            WHERE  MASTER_ID        = @v_master_id
            AND    PLAN_ID          = @v_plan_id
            AND    COMPANY_ID       = @COMPANY_ID 
            AND    DIVISION_ID      = @DIVISION_ID      
            AND    SITE_ID          = @SITE_ID          
            AND    PLANT_ID         = @PLANT_ID         
            AND    FACTORY_ID       = @FACTORY_ID       
            AND    OPERATION_ID     = @OPERATION_ID     
            AND    LINE_ID          = @LINE_ID         
            AND    ELECTRODE_TYPE   = @ELECTRODE_TYPE
            AND    EQUIPMENT_ID     = @EQUIPMENT_ID     
            AND    PLAN_DATE        = @PLAN_DATE
            AND    OFF_START_TIME  >= @OFF_START_TIME
            AND    OFF_END_TIME    <= @OFF_START_TIME
          
          SET @n_row_count += @@ROWCOUNT

        END
          
        CLOSE C_OFF_CAL	
        
        DEALLOCATE C_OFF_CAL
      
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
        
    END

  END TRY  
  
  BEGIN CATCH
    --ROLLBACK

    IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_OFF_CAL')
      BEGIN
          CLOSE C_OFF_CAL
          DEALLOCATE C_OFF_CAL
      END

  SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
