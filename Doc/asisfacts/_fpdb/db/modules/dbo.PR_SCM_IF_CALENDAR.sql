CREATE PROCEDURE [dbo].[PR_SCM_IF_CALENDAR]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_CALENDAR                                                        **/
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
/** 2016.08.17    LJH          최초 작성                                                      **/
/** 2016.08.26    SHS         CALENDAR MERGE  / CURSOR                                        **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_CALENDAR
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
  DECLARE @plan_type        nvarchar(30)
  DECLARE @v_daydiff        Integer

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_CALENDAR'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)

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
              @plan_type = PLAN_TYPE,
              @v_daydiff = DAYDIFF,
              @key_date = PLAN_DATE
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     PLAN_TYPE,
                     DATEDIFF(MINUTE,CONVERT(DATE,PLAN_START_DTTM), PLAN_START_DTTM) AS DAYDIFF,
                     PLAN_DATE
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

      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

      SELECT  @res_category = isnull(max(key_value), 'LINE')
      FROM    SY_FP_INSTANCE_CONFIG_M
      WHERE   instance_id = @v_master_id
      AND     category_id = 'RESOURCE_CATEGORY'
      AND     KEY_ID = @plan_type

      --LOG 생성
      SET @v_message = '@res_category : ' + @res_category
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
    END;
    
    BEGIN
    
      SET @v_table_name = 'TH_BUF_SCM_CAL_LINE_OFF_DAY-FACTORY'
      SET @n_row_count = 0
      
      DELETE FROM TH_BUF_SCM_CAL_LINE_OFF_DAY
      
      /*
        테이블변수 TH_BUF_SCM_CAL_LINE_OFF_DAY에 Factory Calendar의 휴일을 각 Line에 설정
      */
      
      INSERT INTO TH_BUF_SCM_CAL_LINE_OFF_DAY
              ( LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE              
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT    A.LINE_ID
              , A.OPERATION_ID
              , A.ELECTRODE_TYPE
              , B.WORK_DATE
              , DATEADD( minute, @v_daydiff,        CONVERT(DATETIME, WORK_DATE) ) AS START_DATE
              , DATEADD( minute, @v_daydiff + 1440, CONVERT(DATETIME, WORK_DATE) ) AS END_DATE
      FROM   (
              SELECT * 
              FROM   SY_SCM_LINE_M A
              WHERE  1=1
              AND    EXISTS ( SELECT 1
                              FROM   TH_MST_INSTANCE_FLOW X
                              WHERE  X.MASTER_ID = @v_master_id
                              AND    X.PLAN_ID = @v_plan_id
                              AND    A.COMPANY_ID = X.COMPANY_ID
                              AND    A.DIVISION_ID = X.DIVISION_ID
                              AND    A.SITE_ID = X.SITE_ID
                              AND    A.PLANT_ID = X.PLANT_ID
                              AND    A.FACTORY_ID = X.FACTORY_ID
                              AND    A.OPERATION_ID = X.OPERATION_ID )
             ) A,
             (
              SELECT A.* 
              FROM   SY_SCM_FACTORY_CALENDAR_M A
              WHERE  1=1
              AND    A.WORK_DATE BETWEEN CONVERT(DATE,@plan_start_time) AND CONVERT(DATE,@plan_end_time)
              AND    EXISTS ( SELECT 1
                              FROM   TH_MST_INSTANCE_FLOW X
                              WHERE  X.MASTER_ID = @v_master_id
                              AND    X.PLAN_ID = @v_plan_id
                              AND    A.COMPANY_ID = X.COMPANY_ID
                              AND    A.DIVISION_ID = X.DIVISION_ID
                              AND    A.SITE_ID = X.SITE_ID
                              AND    A.PLANT_ID = X.PLANT_ID 
                              AND    A.FACTORY_ID = X.FACTORY_ID )
             ) B       
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.FACTORY_ID = B.FACTORY_ID

      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      SET @v_table_name = 'TH_BUF_SCM_CAL_LINE_OFF_DAY-LINE'
      SET @n_row_count = 0
      
      /*
        테이블변수 TH_BUF_SCM_CAL_LINE_OFF_DAY에 LINE Calendar에서 Line Off 일자를 Factory Off 일자와 겹치지 않은 데이터를 저장
      */
      
      INSERT INTO TH_BUF_SCM_CAL_LINE_OFF_DAY
              ( LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT    A.LINE_ID
              , A.OPERATION_ID
              , A.ELECTRODE_TYPE
              , B.WORK_DATE
              , DATEADD( minute, @v_daydiff,        CONVERT(DATETIME, WORK_DATE) ) AS START_DATE
              , DATEADD( minute, @v_daydiff + 1440, CONVERT(DATETIME, WORK_DATE) ) AS END_DATE
      FROM   (
              SELECT * 
              FROM   SY_SCM_LINE_M A
              WHERE  1=1
              AND    EXISTS ( SELECT 1
                              FROM   TH_MST_INSTANCE_FLOW X
                              WHERE  X.MASTER_ID = @v_master_id
                              AND    X.PLAN_ID = @v_plan_id
                              AND    A.COMPANY_ID = X.COMPANY_ID
                              AND    A.DIVISION_ID = X.DIVISION_ID
                              AND    A.SITE_ID = X.SITE_ID
                              AND    A.PLANT_ID = X.PLANT_ID
                              AND    A.FACTORY_ID = X.FACTORY_ID
                              AND    A.OPERATION_ID = X.OPERATION_ID )
             ) A,
             (
              SELECT A.* 
              FROM   SY_SCM_LINE_CALENDAR_M A
              WHERE  1=1
              AND    A.WORK_DATE BETWEEN CONVERT(DATE,@plan_start_time) AND CONVERT(DATE,@plan_end_time)
              AND    OFF_FLAG = 'Y'
              AND    EXISTS ( SELECT 1
                              FROM   TH_MST_INSTANCE_FLOW X
                              WHERE  X.MASTER_ID = @v_master_id
                              AND    X.PLAN_ID = @v_plan_id
                              AND    A.COMPANY_ID = X.COMPANY_ID
                              AND    A.DIVISION_ID = X.DIVISION_ID
                              AND    A.SITE_ID = X.SITE_ID
                              AND    A.PLANT_ID = X.PLANT_ID
                              AND    A.FACTORY_ID = X.FACTORY_ID )
             ) B       
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.FACTORY_ID = B.FACTORY_ID
      AND    NOT EXISTS ( SELECT 1
                          FROM   TH_BUF_SCM_CAL_LINE_OFF_DAY X
                          WHERE  A.LINE_ID = X.LINE_ID
                          AND    A.OPERATION_ID = X.OPERATION_ID
                          AND    B.WORK_DATE = X.OFF_DATE )
      ;
      
      SET @n_row_count += @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
    
    END

    BEGIN

      SET @v_table_name = 'TH_BUF_SCM_CAL_LINE_OFF_TIME'
      SET @n_row_count = 0
      
      DELETE FROM TH_BUF_SCM_CAL_LINE_OFF_TIME
      
      /*
        테이블변수 TH_BUF_SCM_CAL_LINE_OFF_TIME에 Line Calendar 와 Line에 Work Type 을 적용한 데이터 중에서
        TH_BUF_SCM_CAL_LINE_OFF_DAY 에 없는 데이터 저장
      */
            
      INSERT INTO TH_BUF_SCM_CAL_LINE_OFF_TIME
              ( LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT    LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME
      FROM   (
                SELECT A.LINE_ID,
                       A.OPERATION_ID,
                       A.ELECTRODE_TYPE,
                       A.OFF_DATE,
                       CASE WHEN R = 1                           THEN DATE_START_TIME
                            WHEN WORK_START_TIME > WORK_END_TIME THEN DATEADD(DAY, 1, WORK_END_TIME)
                                                                 ELSE WORK_END_TIME
                       END  AS OFF_START_TIME,
                       CASE WHEN R = 1 THEN WORK_START_TIME
                                       ELSE DATE_END_TIME
                       END  AS OFF_END_TIME
                FROM   (
                        SELECT C.LINE_ID,
                               C.OPERATION_ID,
                               C.ELECTRODE_TYPE,
                               A.WORK_DATE AS OFF_DATE,
                               DATEADD( MINUTE, @v_daydiff,        CONVERT(DATETIME, WORK_DATE)) AS DATE_START_TIME,
                               DATEADD( MINUTE, @v_daydiff + 1440, CONVERT(DATETIME, WORK_DATE)) AS DATE_END_TIME,
                               CONVERT(DATETIME, WORK_DATE) + CONVERT(DATETIME, START_TIMESET) AS WORK_START_TIME,
                               CONVERT(DATETIME, WORK_DATE) + CONVERT(DATETIME, END_TIMESET)   AS WORK_END_TIME
                        FROM   SY_SCM_LINE_CALENDAR_M A,
                               SY_SCM_WORK_TYPE_M     B,
                               SY_SCM_LINE_M          C
                        WHERE  1=1
                        AND    A.WORK_DATE BETWEEN CONVERT(DATE,@plan_start_time) AND CONVERT(DATE,@plan_end_time)
                        AND    A.COMPANY_ID = B.COMPANY_ID
                        AND    A.DIVISION_ID = B.DIVISION_ID
                        AND    A.SITE_ID = B.SITE_ID
                        AND    A.PLANT_ID = B.PLANT_ID
                        AND    A.WORK_TYPE_ID = B.WORK_TYPE_ID
                        AND    A.COMPANY_ID = C.COMPANY_ID
                        AND    A.DIVISION_ID = C.DIVISION_ID
                        AND    A.SITE_ID = C.SITE_ID
                        AND    A.PLANT_ID = C.PLANT_ID
                        AND    A.FACTORY_ID = C.FACTORY_ID
                        --AND    A.SHOP_ID = C.SHOP_ID  2016.0929.LJH. SHOP_ID DELETE
                        AND    A.LINE_ID = C.LINE_ID
                        AND    A.OPERATION_ID = C.OPERATION_ID
                        AND    A.OFF_FLAG = 'N'
                        AND    EXISTS ( SELECT 1
                                        FROM   TH_MST_INSTANCE_FLOW X
                                        WHERE  X.MASTER_ID = @v_master_id
                                        AND    X.PLAN_ID = @v_plan_id
                                        AND    A.COMPANY_ID = X.COMPANY_ID
                                        AND    A.DIVISION_ID = X.DIVISION_ID
                                        AND    A.SITE_ID = X.SITE_ID
                                        AND    A.PLANT_ID = X.PLANT_ID 
                                        AND    A.FACTORY_ID = X.FACTORY_ID )
                       ) A,
                       ( SELECT 1 R UNION ALL
                         SELECT 2 R ) B
                WHERE  1=1
                AND    NOT EXISTS ( SELECT 1
                                    FROM   TH_BUF_SCM_CAL_LINE_OFF_DAY X
                                    WHERE  A.LINE_ID = X.LINE_ID
                                    AND    A.OPERATION_ID = X.OPERATION_ID
                                    AND    A.ELECTRODE_TYPE = X.ELECTRODE_TYPE
                                    AND    A.OFF_DATE = X.OFF_DATE )
               ) A
      WHERE   OFF_START_TIME < OFF_END_TIME
      
      SET @n_row_count += @@ROWCOUNT
      
      /*
        테이블변수 TH_BUF_SCM_CAL_LINE_OFF_TIME에 Line Calendar 와 Line에 Work Type 을 적용한 데이터 중에서
        TH_BUF_SCM_CAL_LINE_OFF_DAY 에 없는 데이터 저장
      */

      -- OFF TIME
      INSERT INTO TH_BUF_SCM_CAL_LINE_OFF_TIME
              ( LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT    A.LINE_ID
              , A.OPERATION_ID
              , A.ELECTRODE_TYPE
              , A.OFF_DATE
              , CASE WHEN CHECK_TIMESET > START_TIMESET THEN DATEADD(DAY, 1, OFF_START)
                                                        ELSE OFF_START
                END  AS OFF_START_TIME
              , CASE WHEN CHECK_TIMESET > END_TIMESET   THEN DATEADD(DAY, 1, OFF_END)
                                                        ELSE OFF_END
                END  AS OFF_END_TIME
      FROM   (
                SELECT C.LINE_ID,
                       C.OPERATION_ID,
                       C.ELECTRODE_TYPE,
                       A.WORK_DATE AS OFF_DATE,
                       CONVERT(TIME, START_TIMESET) AS START_TIMESET,
                       CONVERT(TIME, END_TIMESET)   AS END_TIMESET,
                       CONVERT(TIME, @plan_start_time) AS CHECK_TIMESET,
                       CONVERT(DATETIME, WORK_DATE) + CONVERT(DATETIME, START_TIMESET) AS OFF_START,
                       CONVERT(DATETIME, WORK_DATE) + CONVERT(DATETIME, END_TIMESET)   AS OFF_END
                FROM   SY_SCM_LINE_CALENDAR_M A,
                       SY_SCM_WORK_TYPE_OFF_M B,
                       SY_SCM_LINE_M          C
                WHERE  1=1
                AND    A.WORK_DATE BETWEEN CONVERT(DATE,@plan_start_time) AND CONVERT(DATE,@plan_end_time)
                AND    A.COMPANY_ID = B.COMPANY_ID
                AND    A.DIVISION_ID = B.DIVISION_ID
                AND    A.SITE_ID = B.SITE_ID
                AND    A.PLANT_ID = B.PLANT_ID
                AND    A.WORK_TYPE_ID = B.WORK_TYPE_ID
                AND    A.COMPANY_ID = C.COMPANY_ID
                AND    A.DIVISION_ID = C.DIVISION_ID
                AND    A.SITE_ID = C.SITE_ID
                AND    A.PLANT_ID = C.PLANT_ID
                AND    A.FACTORY_ID = C.FACTORY_ID
                --AND    A.SHOP_ID = C.SHOP_ID  2016.0929.LJH. SHOP_ID DELETE
                AND    A.LINE_ID = C.LINE_ID
                AND    A.OPERATION_ID = C.OPERATION_ID
                AND    A.OFF_FLAG = 'N'
                AND    EXISTS ( SELECT 1
                                FROM   TH_MST_INSTANCE_FLOW X
                                WHERE  X.MASTER_ID = @v_master_id
                                AND    X.PLAN_ID = @v_plan_id
                                AND    A.COMPANY_ID = X.COMPANY_ID
                                AND    A.DIVISION_ID = X.DIVISION_ID
                                AND    A.SITE_ID = X.SITE_ID
                                AND    A.PLANT_ID = X.PLANT_ID
                                AND    A.FACTORY_ID = X.FACTORY_ID )
             ) A
      WHERE  NOT EXISTS ( SELECT 1
                          FROM   TH_BUF_SCM_CAL_LINE_OFF_DAY X
                          WHERE  A.LINE_ID = X.LINE_ID
                          AND    A.OPERATION_ID = X.OPERATION_ID
                          AND    A.ELECTRODE_TYPE = X.ELECTRODE_TYPE
                          AND    A.OFF_DATE = X.OFF_DATE )

      SET @n_row_count += @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    END

    -- 시업일자 ~ 시업시간까지 OFFTIME 설정
    BEGIN

      SET @v_table_name = 'TH_BUF_SCM_CAL_LINE_OFF_TIME - PST'
      SET @n_row_count = 0

      -- OFF TIME
      INSERT INTO TH_BUF_SCM_CAL_LINE_OFF_TIME
              ( LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT DISTINCT
             LINE_ID
           , OPERATION_ID
           , ELECTRODE_TYPE
           , CONVERT(DATE, DATEADD(DD, -1, @plan_start_time ) ) OFF_DATE
           , CONVERT(DATE, @plan_start_time ) OFF_START
           , @plan_start_time OFF_END     
      FROM   SY_SCM_LINE_M A
      WHERE  A.ACTIVE_FLAG = 'Y'
      AND    EXISTS ( SELECT 1
                      FROM   TH_MST_INSTANCE_FLOW X
                      WHERE  X.MASTER_ID = @v_master_id
                      AND    X.PLAN_ID = @v_plan_id
                      AND    A.COMPANY_ID = X.COMPANY_ID
                      AND    A.DIVISION_ID = X.DIVISION_ID
                      AND    A.SITE_ID = X.SITE_ID
                      AND    A.PLANT_ID = X.PLANT_ID 
                      AND    A.FACTORY_ID = X.FACTORY_ID
                      AND    A.OPERATION_ID = X.OPERATION_ID)
      UNION  ALL
      -- 반드시 BOR 이 먼저 실행되어야 한다.
      SELECT DISTINCT
             ROUTE_ID     AS LINE_ID
           , OPERATION_ID
           , ELECTRODE_TYPE
           , CONVERT(DATE, START_DATE) AS OFF_DATE
           , START_DATE   AS OFF_START_TIME
           , END_DATE     AS OFF_END_TIME
      FROM   (-- ITEM 별 설비가 다르므로,,, GROUP BY 로 SUM 해서 실제 ACTIVE 안된 애들만,,
              SELECT ROUTE_ID, OPERATION_ID, ELECTRODE_TYPE, START_DATE, END_DATE 
              FROM   TH_MST_OP_RESOURCE_LINE_CAL
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
              GROUP  BY ROUTE_ID, OPERATION_ID, ELECTRODE_TYPE, START_DATE, END_DATE
              HAVING SUM(ACTIVE_RESOURCE_COUNT) = 0
             ) A
      
      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
    
    END

    
    BEGIN
    
      SET @v_table_name = 'TH_BUF_SCM_CAL_LINE_OFF_TIME += TH_BUF_SCM_CAL_LINE_OFF_DAY'
      SET @n_row_count = 0

      /*
        테이블변수 TH_BUF_SCM_CAL_LINE_OFF_DAY에서 조회한 데이터를 테이블 변수 TH_BUF_SCM_CAL_LINE_OFF_TIME 저장
      */
      
      INSERT INTO TH_BUF_SCM_CAL_LINE_OFF_TIME
              ( LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME )
      SELECT 
                LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME 
      FROM      TH_BUF_SCM_CAL_LINE_OFF_DAY

      SET @n_row_count += @@ROWCOUNT

          --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    END
    

    BEGIN

      SET @v_table_name = '@LINE_OFF_CALENDAR'
      SET @n_row_count = 0

      DECLARE @OFF_LINE_ID        nvarchar(100),
              @OFF_OPERATION_ID   nvarchar(100),
              @OFF_ELECTRODE_TYPE nvarchar(30),
              @OFF_DATE           DATETIME,
              @OFF_START_TIME     DATETIME,
              @OFF_END_TIME       DATETIME

      DECLARE @START_TIME         DATETIME,
              @END_TIME           DATETIME,
              @PLAN_DATE          DATETIME = NULL,
              @LINE_ID            nvarchar(100) = '-',
              @OPERATION_ID       nvarchar(100) = '-',
              @ELECTRODE_TYPE     nvarchar(30) = '-',
              @COUNT              INTEGER

      DECLARE @LINE_OFF_CALENDAR TABLE (
                                        LINE_ID         nvarchar(150),
                                        OPERATION_ID    nvarchar(150),
                                        ELECTRODE_TYPE  nvarchar(30),
                                        OFFTIME_TYPE_ID nvarchar(150),
                                        WORK_DATE       datetime,
                                        START_DATE      datetime,
                                        END_DATE        datetime
                                       )
      
      DECLARE OFF_LINE CURSOR FOR 
      
      /*
        테이블변수 TH_BUF_SCM_CAL_LINE_OFF_TIME 와 TH_BUF_SCM_CAL_LINE_OFF_TIME 에서 조회한 데이터를 테이블 변수 @LINE_OFF_CALENDAR에 저장
      */
      
        SELECT LINE_ID
             , OPERATION_ID 
             , ELECTRODE_TYPE
             , OFF_DATE
        FROM   TH_BUF_SCM_CAL_LINE_OFF_TIME
        GROUP  BY LINE_ID, OPERATION_ID, ELECTRODE_TYPE, OFF_DATE
        ORDER  BY LINE_ID, OPERATION_ID, ELECTRODE_TYPE, OFF_DATE

      OPEN OFF_LINE
      
      WHILE 1 = 1
   
      BEGIN

        FETCH OFF_LINE
          INTO @OFF_LINE_ID, @OFF_OPERATION_ID, @OFF_ELECTRODE_TYPE, @OFF_DATE

          IF @@FETCH_STATUS <> 0
            BREAK

          SET @START_TIME = NULL
          SET @END_TIME = NULL
          --SET @CHECK_FLAG = 'N'
          
          BEGIN
          
            DECLARE OFF_LINE_CAL CURSOR FOR 
              SELECT OFF_START_TIME
                   , OFF_END_TIME
              FROM   (
                      SELECT OFF_DATE
                           , OFF_START_TIME
                           , OFF_END_TIME
                      FROM   TH_BUF_SCM_CAL_LINE_OFF_TIME
                      WHERE  LINE_ID = @OFF_LINE_ID
                      AND    OPERATION_ID = @OFF_OPERATION_ID
                      AND    ELECTRODE_TYPE = @OFF_ELECTRODE_TYPE
                      AND    OFF_DATE = @OFF_DATE
                     ) A
              ORDER  BY OFF_START_TIME
            
            OPEN OFF_LINE_CAL
            
            WHILE 1 = 1
         
            BEGIN

              FETCH OFF_LINE_CAL
                INTO @OFF_START_TIME, @OFF_END_TIME
          
              IF @@FETCH_STATUS <> 0
                BEGIN
                  INSERT INTO @LINE_OFF_CALENDAR
                  SELECT    @OFF_LINE_ID
                          , @OFF_OPERATION_ID
                          , @OFF_ELECTRODE_TYPE
                          , @OFF_LINE_ID + '_' + @OFF_OPERATION_ID
                             + (CASE @OFF_ELECTRODE_TYPE WHEN '-' THEN '' WHEN '' THEN '' ELSE '_'+@OFF_ELECTRODE_TYPE END)
                             + '_' + CONVERT(nvarchar, @OFF_DATE, 112)
                             + '_' + REPLICATE ( '0', 4 - LEN( CONVERT(nvarchar,@COUNT+1) ) )   + CONVERT(nvarchar,@COUNT+1) AS OFFTIME_TYPE_ID
                          , @OFF_DATE AS WORK_DATE
                          , @START_TIME AS START_DATE
                          , @END_TIME   AS END_DATE
                  WHERE   @START_TIME IS NOT NULL
                  
                  SET @n_row_count += @@ROWCOUNT

                  BREAK
                END

                
              IF      @LINE_ID <> @OFF_LINE_ID 
                  OR  @OPERATION_ID <> @OFF_OPERATION_ID 
                  OR  @ELECTRODE_TYPE <> @OFF_ELECTRODE_TYPE 
                  OR  @PLAN_DATE <> @OFF_DATE
                BEGIN
                  SET @LINE_ID = @OFF_LINE_ID
                  SET @OPERATION_ID = @OFF_OPERATION_ID
                  SET @ELECTRODE_TYPE = @OFF_ELECTRODE_TYPE
                  SET @START_TIME = @OFF_START_TIME
                  SET @END_TIME = @OFF_END_TIME   
                  SET @PLAN_DATE = @OFF_DATE
                  SET @COUNT = 0
                END
              ELSE
                BEGIN
                
                  IF @START_TIME <= @OFF_START_TIME AND @OFF_START_TIME <= @END_TIME
                    BEGIN
                      IF @OFF_END_TIME > @END_TIME
                        SET @END_TIME = @OFF_END_TIME
                    END
                  ELSE
                    BEGIN
                      SET @COUNT += 1

                      INSERT INTO @LINE_OFF_CALENDAR
                      SELECT    @OFF_LINE_ID
                              , @OFF_OPERATION_ID
                              , @OFF_ELECTRODE_TYPE
                              , @OFF_LINE_ID + '_' + @OFF_OPERATION_ID
                                 + (CASE @OFF_ELECTRODE_TYPE WHEN '-' THEN '' WHEN '' THEN '' ELSE '_'+@OFF_ELECTRODE_TYPE END)
                                 + '_' + CONVERT(nvarchar, @OFF_DATE, 112)
                                 + '_' + REPLICATE ( '0', 4 - LEN( CONVERT(nvarchar,@COUNT) ) )   + CONVERT(nvarchar,@COUNT) AS OFFTIME_TYPE_ID
                              , @OFF_DATE AS WORK_DATE
                              , @START_TIME AS START_DATE
                              , @END_TIME   AS END_DATE
                      
                      SET @n_row_count += @@ROWCOUNT
                    
                      SET @START_TIME = @OFF_START_TIME
                      SET @END_TIME = @OFF_END_TIME
                    END
                
                END

            END

            CLOSE OFF_LINE_CAL

            DEALLOCATE OFF_LINE_CAL        

          END
            
      END

      CLOSE OFF_LINE

      DEALLOCATE OFF_LINE        

      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      DELETE FROM TH_BUF_SCM_CAL_LINE_OFF_CALENDAR
      
      INSERT INTO TH_BUF_SCM_CAL_LINE_OFF_CALENDAR
      SELECT * FROM @LINE_OFF_CALENDAR

    END;
    
    BEGIN

      SET @v_table_name = 'TH_MST_OFF_CALENDAR_LINE'
      SET @n_row_count = 0

      DELETE FROM TH_MST_OFF_CALENDAR_LINE
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      
      /* 
        테이블 변수 TH_BUF_SCM_CAL_LINE_OFF_CALENDAR에서 조회한 데이터를 TH_MST_OFF_CALENDAR_LINE에 저장
      */

      INSERT INTO TH_MST_OFF_CALENDAR_LINE
              ( MASTER_ID
              , PLAN_ID
              , LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE
              , WORK_DATE
              , START_DATE
              , END_DATE
              , OFFTIME_TERM
              , OFFTIME_TERM_UOM
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM
              )
      SELECT    @v_master_id AS MASTER_ID
              , @v_plan_id AS PLAN_ID
              , LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE
              , WORK_DATE
              , START_DATE
              , END_DATE
              , DATEDIFF(MI, START_DATE, END_DATE) AS OFFTIME_TERM
              , 'MINUTE' AS OFFTIME_TERM_UOM
              , @key_date AS KEY_DATE
              , @v_proc_name AS INSERT_ID
              , GETDATE() AS INSERT_DTTM
              , @v_proc_name AS UPDATE_ID
              , GETDATE() AS UPDATE_DTTM
      FROM   TH_BUF_SCM_CAL_LINE_OFF_CALENDAR

      SET @n_row_count += @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
    
    END
    
    BEGIN
    
      SET @v_table_name = 'TH_BUF_SCM_CAL_EQUIPMENT_OFF_TIME'
      SET @n_row_count = 0

      DELETE FROM TH_BUF_SCM_CAL_EQUIPMENT_OFF_TIME
      
      /*
        Off Calendar, Equipment, Instance Flow 에서 조회한 Equipment 별 Off time 데이터를 테이블 변수 TH_BUF_SCM_CAL_EQUIPMENT_OFF_TIME에 저장
      */

      INSERT INTO TH_BUF_SCM_CAL_EQUIPMENT_OFF_TIME
              ( LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE
              , EQUIPMENT_ID
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME 
              , CHK )
      SELECT    A.LINE_ID
              , A.OPERATION_ID
              , A.ELECTRODE_TYPE
              , A.EQUIPMENT_ID
              , CONVERT(DATE, DATEADD( DD, (B.INT - 1), CONVERT(DATETIME, OFF_START_DATE))) AS WORK_DATE
              , CASE WHEN B.INT = 1 THEN OFF_START_TIME
                     ELSE DATEADD( MINUTE, @v_daydiff + (B.INT - 1) * 1440, CONVERT(DATETIME, OFF_START_DATE))
                END  OFF_START_TIME
              , CASE WHEN B.INT = A.DAYDIFF THEN OFF_END_TIME
                     ELSE DATEADD( MINUTE, @v_daydiff + (B.INT - 0) * 1440, CONVERT(DATETIME, OFF_START_DATE))
                END  OFF_END_TIME
              , '1' CHK
      FROM   (
                SELECT A.*,
                       DATEDIFF( DD, OFF_START_DATE, OFF_END_DATE ) + 1 DAYDIFF
                FROM   (
                        SELECT B.LINE_ID,
                               B.OPERATION_ID,
                               B.ELECTRODE_TYPE,
                               A.EQUIPMENT_ID,
                               A.OFF_START_TIME,
                               A.OFF_END_TIME,
                               CONVERT(DATE, DATEADD( MINUTE, -1 *   @v_daydiff,           CONVERT(DATETIME, OFF_START_TIME))) OFF_START_DATE,
                               CONVERT(DATE, DATEADD( SECOND, -1 * ( @v_daydiff * 60 + 1), CONVERT(DATETIME, OFF_END_TIME)))   OFF_END_DATE
                        FROM   TH_MST_SCM_OFF_CALENDAR A,
                               --SY_SCM_OFF_CALENDAR_M A,
                               SY_SCM_EQUIPMENT_M     B
                        WHERE  1=1
                        AND    A.MASTER_ID  = @v_master_id
                        AND    A.PLAN_ID    = @v_plan_id
                        AND    A.COMPANY_ID = B.COMPANY_ID
                        AND    A.DIVISION_ID = B.DIVISION_ID
                        AND    A.SITE_ID = B.SITE_ID
                        AND    A.PLANT_ID = B.PLANT_ID
                        AND    A.FACTORY_ID = B.FACTORY_ID
                        and    A.LINE_ID = B.LINE_ID
                        AND    A.OPERATION_ID = B.OPERATION_ID
                        AND    A.EQUIPMENT_ID = B.EQUIPMENT_ID
                        --AND    A.OFF_END_TIME > @plan_start_time
                        --AND    A.OFF_START_TIME < @plan_end_time
                        AND    EXISTS ( SELECT 1
                                        FROM   TH_MST_INSTANCE_FLOW X
                                        WHERE  X.MASTER_ID = @v_master_id
                                        AND    X.PLAN_ID = @v_plan_id
                                        AND    A.COMPANY_ID = X.COMPANY_ID
                                        AND    A.DIVISION_ID = X.DIVISION_ID
                                        AND    A.SITE_ID = X.SITE_ID
                                        AND    A.PLANT_ID = X.PLANT_ID
                                        AND    A.FACTORY_ID = X.FACTORY_ID )
                       ) A
             ) A,
             COPYT B
      WHERE  DAYDIFF >= B.INT

      SET @n_row_count += @@ROWCOUNT
      
      /*
        테이블 변수 @T_LINE_OFF_TIM, TH_BUF_SCM_CAL_EQUIPMENT_OFF_TIME 에서 조회한 데이터를 테이블 변수 TH_BUF_SCM_CAL_EQUIPMENT_OFF_TIME에 저장
      */

      INSERT INTO TH_BUF_SCM_CAL_EQUIPMENT_OFF_TIME
              ( LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE
              , EQUIPMENT_ID
              , OFF_DATE
              , OFF_START_TIME
              , OFF_END_TIME 
              , CHK )
      SELECT    DISTINCT
                A.LINE_ID,
                A.OPERATION_ID,
                A.ELECTRODE_TYPE,
                B.EQUIPMENT_ID,
                A.OFF_DATE,
                A.OFF_START_TIME,
                A.OFF_END_TIME,
                '2' CHK
      FROM      TH_BUF_SCM_CAL_LINE_OFF_TIME A,
               (SELECT LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID
                FROM   TH_BUF_SCM_CAL_EQUIPMENT_OFF_TIME
                GROUP  BY LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID ) B
      WHERE     A.LINE_ID = B.LINE_ID
      AND       A.OPERATION_ID = B.OPERATION_ID
      AND       A.ELECTRODE_TYPE = B.ELECTRODE_TYPE

      SET @n_row_count += @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    
    END;

    BEGIN

      SET @v_table_name = '@OFF_CALENDAR'
      SET @n_row_count = 0

      DECLARE @OFF_EQUIPMENT_ID nvarchar(100)

      DECLARE @EQUIPMENT_ID    nvarchar(100) = '-'

      DECLARE @OFF_CALENDAR TABLE (
                                    LINE_ID nvarchar(150),
                                    OPERATION_ID nvarchar(150),
                                    ELECTRODE_TYPE nvarchar(30),
                                    EQUIPMENT_ID nvarchar(150),
                                    OFFTIME_TYPE_ID nvarchar(150),
                                    WORK_DATE datetime,
                                    START_DATE datetime,
                                    END_DATE datetime
                                   )
      
      DECLARE OFF_EQ CURSOR FOR 
        SELECT LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID
        FROM   TH_BUF_SCM_CAL_EQUIPMENT_OFF_TIME
        GROUP  BY LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID
        ORDER  BY LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID        

      OPEN OFF_EQ
      
      WHILE 1 = 1
   
      BEGIN

        FETCH OFF_EQ
          INTO @OFF_LINE_ID, @OFF_OPERATION_ID, @OFF_ELECTRODE_TYPE, @OFF_EQUIPMENT_ID

          IF @@FETCH_STATUS <> 0
            BREAK

          SET @START_TIME = NULL
          SET @END_TIME = NULL
          --SET @CHECK_FLAG = 'N'
          
          BEGIN
          
            DECLARE OFF_EQ_CAL CURSOR FOR 
              SELECT DISTINCT
                     OFF_DATE
                   , OFF_START_TIME
                   , OFF_END_TIME
              FROM   TH_BUF_SCM_CAL_EQUIPMENT_OFF_TIME
              WHERE  LINE_ID = @OFF_LINE_ID
              AND    OPERATION_ID = @OFF_OPERATION_ID
              AND    ELECTRODE_TYPE = @OFF_ELECTRODE_TYPE
              AND    EQUIPMENT_ID = @OFF_EQUIPMENT_ID
              ORDER  BY OFF_START_TIME
            
            OPEN OFF_EQ_CAL
            
            WHILE 1 = 1
         
            BEGIN

              FETCH OFF_EQ_CAL
                INTO @OFF_DATE, @OFF_START_TIME, @OFF_END_TIME
          
              IF @@FETCH_STATUS <> 0
                BEGIN
                  
                  /*
                    테이블 변수 TH_BUF_SCM_CAL_EQUIPMENT_OFF_TIME에서 조회한 내용을 Fetch 돌며서 @OFF_CALENDAR에 저장
                  */
                  
                  INSERT INTO @OFF_CALENDAR
                  SELECT    @OFF_LINE_ID
                          , @OFF_OPERATION_ID
                          , @OFF_ELECTRODE_TYPE
                          , @OFF_EQUIPMENT_ID
                          , @OFF_EQUIPMENT_ID
                             + '_' + REPLICATE ( '0', 4 - LEN( CONVERT(nvarchar,@COUNT+1) ) )   + CONVERT(nvarchar,@COUNT+1) AS OFFTIME_TYPE_ID
                          , @OFF_DATE AS WORK_DATE
                          , @START_TIME AS START_DATE
                          , @END_TIME   AS END_DATE
                  WHERE   @START_TIME IS NOT NULL
                  
                  SET @n_row_count += @@ROWCOUNT

                  BREAK
                END

                
              IF    @LINE_ID <> @OFF_LINE_ID 
                OR  @OPERATION_ID <> @OFF_OPERATION_ID 
                OR  @ELECTRODE_TYPE <> @OFF_ELECTRODE_TYPE
                OR  @EQUIPMENT_ID <> @OFF_EQUIPMENT_ID
                BEGIN
                  SET @LINE_ID = @OFF_LINE_ID
                  SET @OPERATION_ID = @OFF_OPERATION_ID
                  SET @ELECTRODE_TYPE = @OFF_ELECTRODE_TYPE
                  SET @EQUIPMENT_ID = @OFF_EQUIPMENT_ID
                  SET @START_TIME = @OFF_START_TIME
                  SET @END_TIME = @OFF_END_TIME   
                  SET @COUNT = 0
                END
              ELSE
                BEGIN
                
                  IF @START_TIME <= @OFF_START_TIME AND @OFF_START_TIME <= @END_TIME
                    BEGIN
                      IF @OFF_END_TIME > @END_TIME
                        SET @END_TIME = @OFF_END_TIME
                    END
                  ELSE
                    BEGIN
                      SET @COUNT += 1
                  
                      /*
                        테이블 변수 TH_BUF_SCM_CAL_EQUIPMENT_OFF_TIME에서 조회한 내용을 Fetch 돌며서 @OFF_CALENDAR에 저장
                      */

                      INSERT INTO @OFF_CALENDAR
                      SELECT    @OFF_LINE_ID
                              , @OFF_OPERATION_ID
                              , @OFF_ELECTRODE_TYPE
                              , @OFF_EQUIPMENT_ID
                              , @OFF_EQUIPMENT_ID
                                 + '_' + REPLICATE ( '0', 4 - LEN( CONVERT(nvarchar,@COUNT) ) )   + CONVERT(nvarchar,@COUNT) AS OFFTIME_TYPE_ID
                              , @OFF_DATE AS WORK_DATE
                              , @START_TIME AS START_DATE
                              , @END_TIME   AS END_DATE
                      
                      SET @n_row_count += @@ROWCOUNT

                      --IF @OFF_EQUIPMENT_ID = 'M1EMIX901'
                      --  SELECT @START_TIME, @END_TIME, @OFF_START_TIME, @OFF_END_TIME
                    
                      SET @START_TIME = @OFF_START_TIME
                      SET @END_TIME = @OFF_END_TIME
                    END
                
                END

            END

            CLOSE OFF_EQ_CAL

            DEALLOCATE OFF_EQ_CAL        

          END
            
      END

      CLOSE OFF_EQ

      DEALLOCATE OFF_EQ       

      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


      DELETE FROM TH_BUF_SCM_CAL_EQUIPMENT_OFF_CALENDAR
      
      INSERT INTO TH_BUF_SCM_CAL_EQUIPMENT_OFF_CALENDAR
      SELECT * FROM @OFF_CALENDAR
      
    END;

    BEGIN

      SET @v_table_name = 'TH_MST_OFF_CALENDAR_EQUIP'
      SET @n_row_count = 0

      DELETE FROM TH_MST_OFF_CALENDAR_EQUIP
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      
      /*
        테이블변수 TH_BUF_SCM_CAL_EQUIPMENT_OFF_CALENDAR 과 TH_BUF_SCM_CAL_LINE_OFF_CALENDAR 에서
        UNION ALL 로 조회한 데이터를 TH_MST_OFF_CALENDAR_EQUIP에 저장
      */
      
      INSERT INTO TH_MST_OFF_CALENDAR_EQUIP
              ( 
                MASTER_ID
              , PLAN_ID
              , RESOURCE_GROUP_ID
              , OFFTIME_TYPE_ID
              , WORK_DATE
              , SHIFT
              , WEEK
              , START_DATE
              , END_DATE
              , OFFTIME_TERM
              , OFFTIME_TERM_UOM
              , LINE_ID
              , OPERATION_ID
              , ELECTRODE_TYPE
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM
          )
      SELECT  DISTINCT  
                @v_master_id AS MASTER_ID
              , @v_plan_id AS PLAN_ID
              , A.RESOURCE_GROUP_ID
              , A.OFFTIME_TYPE_ID
              , A.WORK_DATE
              , 1 AS SHIFT
              , A.WEEK
              , A.START_DATE
              , A.END_DATE
              , DATEDIFF(MI, A.START_DATE, A.END_DATE) AS OFFTIME_TERM
              , 'MINUTE' AS OFFTIME_TERM_UOM
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELECTRODE_TYPE
              , @key_date AS KEY_DATE
              , @v_proc_name+'_1' AS INSERT_ID
              , GETDATE() AS INSERT_DTTM
              , @v_proc_name AS UPDATE_ID
              , GETDATE() AS UPDATE_DTTM
      FROM   (
              SELECT    A.EQUIPMENT_ID AS RESOURCE_GROUP_ID
                      , A.OFFTIME_TYPE_ID
                      , A.WORK_DATE
                      , B.WEEK
                      , CASE WHEN A.START_DATE < @plan_start_time THEN @plan_start_time ELSE A.START_DATE END START_DATE
                      , A.END_DATE
                      , A.LINE_ID
                      , A.OPERATION_ID
                      , A.ELECTRODE_TYPE
              FROM   TH_BUF_SCM_CAL_EQUIPMENT_OFF_CALENDAR  A,
                     SY_SCM_SYS_CALENDAR_M                  B
              WHERE  A.WORK_DATE = B.DATE_ID
              AND    A.END_DATE  > @plan_start_time
              UNION  ALL
              SELECT    B.EQUIPMENT_ID AS RESOURCE_GROUP_ID
                      --, A.LINE_ID + '_' + A.OPERATION_ID
                      --          + ( CASE A.ELECTRODE_TYPE WHEN '-' THEN '' WHEN '' THEN '' ELSE '_' + A.ELECTRODE_TYPE END ) AS RESOURCE_GROUP_ID
                      , A.OFFTIME_TYPE_ID
                      , A.WORK_DATE
                      , C.WEEK
                      , CASE WHEN A.START_DATE < @plan_start_time THEN @plan_start_time ELSE A.START_DATE END START_DATE
                      , A.END_DATE
                      , A.LINE_ID
                      , A.OPERATION_ID
                      , A.ELECTRODE_TYPE
              FROM   TH_BUF_SCM_CAL_LINE_OFF_CALENDAR A,
                     SY_SCM_EQUIPMENT_M               B,
                     SY_SCM_SYS_CALENDAR_M            C
              WHERE  A.LINE_ID = B.LINE_ID
              AND    A.OPERATION_ID = B.OPERATION_ID
              AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
              AND    B.ACTIVE_FLAG = 'Y'
              AND    B.EQUIPMENT_TYPE = 'M'
              AND    A.WORK_DATE = C.DATE_ID
              AND    A.END_DATE  > @plan_start_time
              AND    NOT EXISTS (SELECT 1
                                 FROM   TH_BUF_SCM_CAL_EQUIPMENT_OFF_CALENDAR X
                                 WHERE  X.EQUIPMENT_ID = B.EQUIPMENT_ID)
             ) A
              
      
      SET @n_row_count += @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    END
    
    BEGIN
    
      SET @v_table_name = 'TH_MST_OFF_CALENDAR'
      SET @n_row_count = 0

      DELETE FROM TH_MST_OFF_CALENDAR
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id


      IF @res_category = 'LINE'
        BEGIN
          
          /*
            테이블 변수 TH_BUF_SCM_CAL_LINE_OFF_CALENDAR 데이터를 TH_MST_OFF_CALENDAR 에 저장 --> Line 기준
          */
          
          INSERT INTO TH_MST_OFF_CALENDAR
                  ( 
                    MASTER_ID
                  , PLAN_ID
                  , RESOURCE_GROUP_ID
                  , OFFTIME_TYPE_ID
                  , WORK_DATE
                  , SHIFT
                  , WEEK
                  , START_DATE
                  , END_DATE
                  , OFFTIME_TERM
                  , OFFTIME_TERM_UOM
                  , KEY_DATE
                  , INSERT_ID
                  , INSERT_DTTM
                  , UPDATE_ID
                  , UPDATE_DTTM
                  )
          SELECT    @v_master_id AS MASTER_ID
                  , @v_plan_id AS PLAN_ID
                  , LINE_ID + '_' + OPERATION_ID 
                            + ( CASE ELECTRODE_TYPE WHEN '-' THEN '' WHEN '' THEN '' ELSE '_' + ELECTRODE_TYPE END ) AS RESOURCE_GROUP_ID
                  , OFFTIME_TYPE_ID
                  , WORK_DATE
                  , 1 AS SHIFT
                  , B.WEEK AS WEEK
                  , START_DATE
                  , END_DATE
                  , DATEDIFF(MI, START_DATE, END_DATE) AS OFFTIME_TERM
                  , 'MINUTE' AS OFFTIME_TERM_UOM
                  , @key_date AS KEY_DATE
                  , @v_proc_name AS INSERT_ID
                  , GETDATE() AS INSERT_DTTM
                  , @v_proc_name AS UPDATE_ID
                  , GETDATE() AS UPDATE_DTTM
          FROM   TH_BUF_SCM_CAL_LINE_OFF_CALENDAR A,
                 SY_SCM_SYS_CALENDAR_M            B
          WHERE  A.WORK_DATE = B.DATE_ID

        END
      ELSE
        BEGIN
          
          /*
            TH_MST_OFF_CALENDAR_EQUIP 에 TH_MST_OFF_CALENDAR 에 저장 --> 호기별
          */
          
          INSERT INTO TH_MST_OFF_CALENDAR
                ( 
                  MASTER_ID
                , PLAN_ID
                , RESOURCE_GROUP_ID
                , OFFTIME_TYPE_ID
                , WORK_DATE
                , SHIFT
                , WEEK
                , START_DATE
                , END_DATE
                , OFFTIME_TERM
                , OFFTIME_TERM_UOM
                , KEY_DATE
                , INSERT_ID
                , INSERT_DTTM
                , UPDATE_ID
                , UPDATE_DTTM
                )
          SELECT
                  MASTER_ID
                , PLAN_ID
                , RESOURCE_GROUP_ID
                , OFFTIME_TYPE_ID
                , WORK_DATE
                , SHIFT
                , WEEK
                , MIN(START_DATE) AS START_DATE
                , MAX(END_DATE) AS END_DATE
                , DATEDIFF(MI, MIN(START_DATE), MAX(END_DATE)) OFFTIME_TERM
                , 'MINUTE' OFFTIME_TERM_UOM
                , KEY_DATE
                , @v_proc_name AS INSERT_ID
                , GETDATE() AS INSERT_DTTM
                , @v_proc_name AS UPDATE_ID
                , GETDATE() AS UPDATE_DTTM
          FROM    TH_MST_OFF_CALENDAR_EQUIP
          WHERE  MASTER_ID = @v_master_id
          AND    PLAN_ID = @v_plan_id
          GROUP  BY 
                  MASTER_ID
                , PLAN_ID
                , RESOURCE_GROUP_ID
                , OFFTIME_TYPE_ID
                , WORK_DATE
                , SHIFT
                , WEEK
                , KEY_DATE
          
        END
          
      SET @n_row_count += @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    
      -- OFFTIME 을 일자별로 자른다.
      BEGIN
      
        SET @v_table_name = 'TH_MST_OFF_CALENDAR'
        
        DELETE FROM TH_MST_OFF_CALENDAR
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id + '_BAK'

        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        UPDATE TH_MST_OFF_CALENDAR
        SET    PLAN_ID = PLAN_ID + '_BAK'
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id

        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        INSERT INTO TH_MST_OFF_CALENDAR
              ( 
                MASTER_ID
              , PLAN_ID
              , RESOURCE_GROUP_ID
              , OFFTIME_TYPE_ID
              , WORK_DATE
              , SHIFT
              , WEEK
              , START_DATE
              , END_DATE
              , OFFTIME_TERM
              , OFFTIME_TERM_UOM
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM
              )
        SELECT A.MASTER_ID
             , A.PLAN_ID
             , A.RESOURCE_GROUP_ID
             , A.RESOURCE_GROUP_ID +'_'
                    + (CASE WHEN SEQ < 10 THEN '0000'
                            WHEN SEQ < 100 THEN '000'
                            WHEN SEQ < 1000 THEN '00'
                            WHEN SEQ < 10000 THEN '0'
                            WHEN SEQ < 100000 THEN ''
                       END )
                    + CONVERT(NVARCHAR, SEQ)
                 AS OFFTIME_TYPE_ID
             , A.PLAN_DATE
             , 1 SHIFT
             , A.WEEK
             , A.NEW_START_TIME AS START_DATE
             , A.NEW_END_TIME   AS END_DATE
             , A.OFF_TERM       AS OFFTIME_TERM
             , 'MINUTE'         AS OFFTIME_TERM_UOM
             , @key_date        AS KEY_DATE
             , @v_proc_name AS INSERT_ID
             , GETDATE() AS INSERT_DTTM
             , @v_proc_name AS UPDATE_ID
             , GETDATE() AS UPDATE_DTTM
        FROM   (       
                SELECT A.*,
                       DATEDIFF(MINUTE, NEW_START_TIME, NEW_END_TIME) AS OFF_TERM,
                       B.WEEK,
                       DENSE_RANK() OVER (PARTITION BY RESOURCE_GROUP_ID ORDER BY NEW_START_TIME) AS SEQ
                FROM   (
                        SELECT A.MASTER_ID, B.PLAN_ID,    -- A 는 _BAK 이다..
                               A.RESOURCE_GROUP_ID, A.OFFTIME_TYPE_ID, --WORK_DATE, SHIFT, WEEK, 
                               A.START_DATE, A.END_DATE, A.OFFTIME_TERM,
                               B.PLAN_DATE, B.START_TIME, B.END_TIME,
                               CASE WHEN A.START_DATE < B.START_TIME THEN B.START_TIME ELSE A.START_DATE END NEW_START_TIME,
                               CASE WHEN A.END_DATE   > B.END_TIME   THEN B.END_TIME   ELSE A.END_DATE   END NEW_END_TIME
                        FROM   th_mst_off_calendar a,
                               (
                                SELECT A.MASTER_ID, A.PLAN_ID,
                                       CONVERT(DATE, DATEADD(DAY, INT - 1, PLAN_START_DTTM)) AS PLAN_DATE,
                                       DATEADD(DAY, INT - 1, PLAN_START_DTTM) AS START_TIME, 
                                       DATEADD(DAY, INT, PLAN_START_DTTM)     AS END_TIME
                                FROM   TH_MST_PLAN A,
                                       COPYT B
                                WHERE  A.MASTER_ID      = @v_master_id
                                AND    A.PLAN_ID        = @v_plan_id
                                AND    A.PLAN_HORIZON  >= INT - 1
                               ) B
                        WHERE  A.MASTER_ID      = @v_master_id
                        AND    A.PLAN_ID        = @v_plan_id  + '_BAK'
                        AND    A.START_DATE <= B.END_TIME
                        AND    A.END_DATE   >= B.START_TIME
                       ) A,
                       SY_SCM_SYS_CALENDAR_M B
                WHERE  A.NEW_START_TIME < A.NEW_END_TIME
                AND    A.PLAN_DATE      = B.DATE_ID
               ) A

        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END
    
    
      SET @v_table_name = 'TH_MST_OFFTYPE_INFO'
      SET @n_row_count = 0

      DELETE FROM TH_MST_OFFTYPE_INFO
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      
      /*
        테이블 변수 TH_BUF_SCM_CAL_EQUIPMENT_OFF_CALENDAR 와 TH_BUF_SCM_CAL_LINE_OFF_CALENDAR UNION ALL 조건 으로 OFFTIME_TYPE_ID 조회
         --> TH_MST_OFFTYPE_INFO 에 저장
      */

      INSERT INTO TH_MST_OFFTYPE_INFO
              ( MASTER_ID
              , PLAN_ID
              , OFFTIME_TYPE_ID
              , OFFTIME_TYPE_NAME
              , IS_WO_OVERLAP
              , IS_DO_OVERLAP
              , IS_SETUP_OVERLAP
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM
              )
      SELECT    @v_master_id AS MASTER_ID
              , @v_plan_id AS PLAN_ID
              , A.OFFTIME_TYPE_ID
              , A.OFFTIME_TYPE_ID AS OFFTIME_TYPE_NAME
              --, 'Y'           AS IS_WO_OVERLAP
              , CASE WHEN A.OFFTIME_TYPE_ID LIKE '%MIX%' THEN 'N'
                ELSE 'Y'
                END AS IS_WO_OVERLAP
              , 'Y'           AS IS_DO_OVERLAP
              , B.KEY_VALUE   AS IS_SETUP_OVERLAP
              , @key_date     AS KEY_DATE
              , @v_proc_name  AS INSERT_ID
              , GETDATE()     AS INSERT_DTTM
              , @v_proc_name  AS UPDATE_ID
              , GETDATE()     AS UPDATE_DTTM             
      FROM    TH_MST_OFF_CALENDAR A,
      		    SY_FP_INSTANCE_CONFIG_M B
      WHERE   A.MASTER_ID = @v_master_id
      AND     A.PLAN_ID = @v_plan_id
      AND     A.MASTER_ID = B.INSTANCE_ID
      AND     B.CATEGORY_ID = 'OFF_TIME'
      AND     B.KEY_ID = 'IS_SETUP_OVERLAP'
      GROUP   BY A.OFFTIME_TYPE_ID, B.KEY_VALUE
           
      SET @n_row_count += @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    END


    BEGIN

      SET @v_table_name = 'TH_MST_RESOURCE - line'
      SET @n_row_count = 0

      UPDATE TH_MST_RESOURCE
      SET    OFFTIME_SET_ID = RES_ATTB_17 + '_' + RES_ATTB_18   -- WORK CENTER 정보를 SETTING 함.
                            + ( CASE RES_ATTB_20 WHEN '-' THEN '' WHEN '' THEN '' ELSE '_' + RES_ATTB_20 END )
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id


      SET @n_row_count += @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      
      SET @v_table_name = 'TH_MST_RESOURCE - equipment'
      SET @n_row_count = 0

      UPDATE TH_MST_RESOURCE
      SET    OFFTIME_SET_ID = RESOURCE_ID
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      AND    EXISTS (SELECT 1
                     FROM   TH_MST_OFF_CALENDAR X
                     WHERE  X.MASTER_ID = @v_master_id
                     AND    X.PLAN_ID = @v_plan_id
                     AND    TH_MST_RESOURCE.RESOURCE_ID = X.RESOURCE_GROUP_ID )
    
      SET @n_row_count += @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

    END


  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
