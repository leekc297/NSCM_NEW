CREATE PROCEDURE [dbo].[PR_SCM_IF_BOD]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_BOD                                                               **/
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
/** 2016.08.18    LJH          최초 작성                                                        **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_BOD
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_BOD'
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
    
    /*
      Instance 별 BOD 데이터 생성
    */
    
    BEGIN
    
      SET @v_table_name = 'TH_MST_BOD'
      
      DELETE FROM TH_MST_BOD
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @v_plan_id
      
      INSERT INTO TH_MST_BOD
               (MASTER_ID
               ,PLAN_ID
               ,BOD_ID
               ,FROM_SITE_ID
               ,TO_SITE_ID
               ,BOD_PATTERN_ID
               ,TRANSPORT_MODE
               ,TRANSPORT_TIME
               ,TRANSPORT_TIME_UOM
               ,BOD_START_DTTM
               ,IS_RELEASE
               ,DESCR
               ,KEY_DATE
               ,INSERT_ID
               ,INSERT_DTTM
               ,UPDATE_ID
               ,UPDATE_DTTM)
      SELECT    @v_master_id
               ,@v_plan_id
               ,BOD_ID
               ,FROM_SITE_ID
               ,TO_SITE_ID
               ,BOD_PATTERN_ID
               ,TRANSPORT_MODE
               ,TRANSPORT_TIME
               ,TRANSPORT_TIME_UOM
               ,BOD_START_DTTM
               ,IS_FLAG
               ,DESCRIPTION
               ,@key_date AS KEY_DATE
               ,@v_proc_name as INSERT_ID
               ,getdate() as INSERT_DTTM
               ,@v_proc_name as UPDATE_ID
               ,getdate() as UPDATE_DTTM
      FROM    (SELECT    DISTINCT A.BOD_ID
                        ,A.FROM_FACTORY_ID  AS FROM_SITE_ID
                        ,A.TO_FACTORY_ID  AS TO_SITE_ID
                        ,A.BOD_PATTERN_ID
                        ,A.FROM_OPERATION_ID + '#' + A.TO_OPERATION_ID AS TRANSPORT_MODE
                        --,CASE WHEN ISNULL(LTRIM(RTRIM(A.TRANSPORT_MODE)), '') = '' THEN A.FROM_OPERATION_ID + '#' + A.TO_OPERATION_ID 
                        --      ELSE A.TRANSPORT_MODE 
                        -- END  TRANSPORT_MODE
                        ,A.TRANSPORT_TIME
                        ,A.TRANSPORT_TIME_UOM 
                        ,CASE WHEN A.BOD_START_TIME < @plan_start_time
                              THEN @plan_start_time
                              ELSE A.BOD_START_TIME
                         END  AS BOD_START_DTTM
                        ,A.RELEASE_FLAG AS IS_FLAG
                        ,A.DESCRIPTION
                FROM     SY_SCM_BOD_M         A
                WHERE    EXISTS (
                                  SELECT 1
                                  FROM   TH_MST_INSTANCE_FLOW X
                                  WHERE  X.COMPANY_ID   = A.COMPANY_ID
                                  AND    X.DIVISION_ID  = A.DIVISION_ID
                                  AND    X.SITE_ID      = A.SITE_ID
                                  AND    X.PLANT_ID     = A.PLANT_ID
                                  AND    X.MASTER_ID    = @v_master_id
                                  AND    X.PLAN_ID      = @v_plan_id
                                )
               ) C
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      INSERT INTO TH_MST_BOD
               (MASTER_ID
               ,PLAN_ID
               ,BOD_ID
               ,FROM_SITE_ID
               ,TO_SITE_ID
               ,BOD_PATTERN_ID
               ,TRANSPORT_MODE
               ,TRANSPORT_TIME
               ,TRANSPORT_TIME_UOM
               ,BOD_START_DTTM
               ,KEY_DATE
               ,INSERT_ID
               ,INSERT_DTTM
               ,UPDATE_ID
               ,UPDATE_DTTM)
      SELECT    @v_master_id
               ,@v_plan_id
               ,FROM_SITE_ID + '_' + TO_SITE_ID + '_' + TRANSPORT_MODE AS BOD_ID
               ,FROM_SITE_ID
               ,TO_SITE_ID
               ,'DX' BOD_PATTERN_ID
               ,TRANSPORT_MODE
               ,0 TRANSPORT_TIME
               ,'MINUTE' TRANSPORT_TIME_UOM
               ,@plan_start_time BOD_START_DTTM
               ,@key_date   AS KEY_DATE
               ,@v_proc_name as INSERT_ID
               ,GETDATE() as INSERT_DTTM
               ,@v_proc_name as UPDATE_ID
               ,getdate() as UPDATE_DTTM
      FROM   (
              SELECT MASTER_ID, PLAN_ID, 
                     FROM_SITE_ID, FROM_SITE_ID AS TO_SITE_ID, TRANSPORT_MODE
              FROM   TH_MST_BOD  A
              WHERE  A.MASTER_ID = @v_master_id
              AND    A.PLAN_ID   = @v_plan_id
              GROUP  BY MASTER_ID, PLAN_ID, 
                        FROM_SITE_ID, TRANSPORT_MODE
             ) A
      WHERE  NOT EXISTS (
                          SELECT 1
                          FROM   TH_MST_BOD X
                          WHERE  X.MASTER_ID      = A.MASTER_ID
                          AND    X.PLAN_ID        = A.PLAN_ID
                          AND    X.FROM_SITE_ID   = A.FROM_SITE_ID
                          AND    X.TO_SITE_ID     = A.TO_SITE_ID
                          AND    X.TRANSPORT_MODE = A.TRANSPORT_MODE
                        )

      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      /*
      INSERT INTO TH_MST_BOD
               (MASTER_ID
               ,PLAN_ID
               ,BOD_ID
               ,FROM_SITE_ID
               ,TO_SITE_ID
               ,BOD_PATTERN_ID
               ,TRANSPORT_MODE
               ,TRANSPORT_TIME
               ,TRANSPORT_TIME_UOM
               ,BOD_START_DTTM
               ,KEY_DATE
               ,INSERT_ID
               ,INSERT_DTTM
               ,UPDATE_ID
               ,UPDATE_DTTM)
      SELECT     
                 A.MASTER_ID
               , A.PLAN_ID
               , A.BOD_ID
               , A.FROM_SITE_ID
               , A.TO_SITE_ID
               , A.BOD_PATTERN_ID
               , A.TRANSPORT_MODE
               , 0 TRANSPORT_TIME
               , 'MINUTE' TRANSPORT_TIME_UOM
               , @plan_start_time BOD_START_DTTM
               , @key_date   AS KEY_DATE
               , @v_proc_name as INSERT_ID
               , GETDATE() as INSERT_DTTM
               , @v_proc_name as UPDATE_ID
               , getdate() as UPDATE_DTTM
      FROM    ( 
                SELECT DISTINCT
                       A.MASTER_ID
                     , A.PLAN_ID
                     , B.SITE_ID + '_' + A.SITE_ID +'_'+B.OPERATION_ID +'#'+A.OPERATION_ID AS BOD_ID
                     , B.SITE_ID AS FROM_SITE_ID
                     , A.SITE_ID AS TO_SITE_ID
                     , 'DX' BOD_PATTERN_ID
                     , B.OPERATION_ID +'#'+A.OPERATION_ID AS TRANSPORT_MODE
                FROM   TH_MST_PLAN_BOM A,
                       TH_MST_ITEM_ROUTE_SITE B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    A.MASTER_ID      = B.MASTER_iD
                AND    A.PLAN_ID        = B.PLAN_ID
                AND    A.CHILD_ITEM_ID  = B.ITEM_ID
                AND    A.SITE_ID        = B.SITE_ID
             ) A
      WHERE  NOT EXISTS (
                          SELECT 1
                          FROM   TH_MST_BOD X
                          WHERE  X.MASTER_ID      = A.MASTER_ID
                          AND    X.PLAN_ID        = A.PLAN_ID
                          AND    X.FROM_SITE_ID   = A.FROM_SITE_ID
                          AND    X.TO_SITE_ID     = A.TO_SITE_ID
                          AND    X.TRANSPORT_MODE = A.TRANSPORT_MODE
                        )
          
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      */
    
    END
    
    /*
      Instance 별 BOD PATTERN 데이터 생성
    */

    BEGIN
    
      SET @v_table_name = 'TH_MST_BOD_PATTERN'
      
      DELETE FROM TH_MST_BOD_PATTERN
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @v_plan_id
      
      INSERT INTO TH_MST_BOD_PATTERN
               (MASTER_ID
               ,PLAN_ID
               ,BOD_PATTERN_ID
               ,CYCLE_TIME
               ,CYCLE_TIME_UOM
               ,DESCR
               ,KEY_DATE
               ,INSERT_ID
               ,INSERT_DTTM
               ,UPDATE_ID
               ,UPDATE_DTTM)
      SELECT    @v_master_id  AS NASTER_ID
               ,@v_plan_id    AS PLAN_ID
               ,BOD_PATTERN_ID
               ,CYCLE_TIME
               ,CYCLE_TIME_UOM
               ,DESCRIPTION
               ,@key_date AS KEY_DATE
               ,@v_proc_name as INSERT_ID
               ,GETDATE() as INSERT_DTTM
               ,@v_proc_name as UPDATE_ID
               ,getdate() as UPDATE_DTTM
      FROM    (SELECT   DISTINCT A.BOD_PATTERN_ID
                        ,A.CYCLE_TIME
                        ,A.CYCLE_TIME_UOM
                        ,A.DESCRIPTION
                FROM     SY_SCM_BOD_PATTERN_M A
                WHERE    BOD_PATTERN_ID != 'DX'
                AND      EXISTS (
                                  SELECT 1
                                  FROM   TH_MST_INSTANCE_FLOW X
                                  WHERE  X.COMPANY_ID   = A.COMPANY_ID
                                  AND    X.DIVISION_ID  = A.DIVISION_ID
                                  AND    X.SITE_ID      = A.SITE_ID
                                  AND    X.PLANT_ID     = A.PLANT_ID
                                  AND    X.MASTER_ID    = @v_master_id
                                  AND    X.PLAN_ID      = @v_plan_id
                                )
               ) C
      UNION  ALL
      SELECT    @v_master_id  AS MASTER_ID
               ,@v_plan_id    AS PLAN_ID
               ,'DX'          AS BOD_PATTERN_ID
               ,0             AS CYCLE_TIME
               ,'MINUTE'      AS CYCLE_TIME_UOM
               ,NULL          AS DESCRIPTION
               ,@key_date     AS KEY_DATE
               ,@v_proc_name  as INSERT_ID
               ,GETDATE()     as INSERT_DTTM
               ,@v_proc_name  as UPDATE_ID
               ,getdate()     as UPDATE_DTTM
      
      
      SET @n_row_count = @@ROWCOUNT

            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END;
    
    /*
      Instance별 ITEM BOD 데이터 생성
    */
    
    BEGIN
    
      SET @v_table_name = 'TH_MST_ITEM_BOD'
      
      DELETE FROM TH_MST_ITEM_BOD
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @v_plan_id
      
      INSERT INTO TH_MST_ITEM_BOD
               (MASTER_ID
               ,PLAN_ID
               ,BOD_ID
               ,ITEM_ID
               --,TRANSPORT_LOT_SIZE
               ,KEY_DATE
               ,INSERT_ID
               ,INSERT_DTTM
               ,UPDATE_ID
               ,UPDATE_DTTM )
      SELECT   DISTINCT
                A.MASTER_ID
               ,A.PLAN_ID
               ,A.BOD_ID
               ,B.PARENT_ITEM_ID AS ITEM_ID
               ,@key_date AS KEY_DATE
               ,@v_proc_name as INSERT_ID
               ,GETDATE() as INSERT_DTTM
               ,@v_proc_name as UPDATE_ID
               ,getdate() as UPDATE_DTTM
      FROM   TH_MST_BOD A,
             (
              SELECT DISTINCT
                     B.PARENT_ITEM_ID
                    ,B.SITE_ID AS FROM_SITE_ID
                    ,A.SITE_ID AS TO_SITE_ID
                    ,B.OPERATION_ID AS FROM_OPEATION_ID
                    ,A.OPERATION_ID AS TO_OPEATION_ID
              FROM   TH_MST_PLAN_BOM A,
                     TH_MST_PLAN_BOM B
              WHERE  A.MASTER_ID = @v_master_id
              AND    A.PLAN_ID = @v_plan_id
              AND    A.MASTER_ID = B.MASTER_ID
              AND    A.PLAN_ID = B.PLAN_ID
              AND    A.CHILD_ITEM_ID = B.PARENT_ITEM_ID
             ) B
      WHERE  A.MASTER_ID = @v_master_id
      AND    A.PLAN_ID = @v_plan_id
      AND    A.FROM_SITE_ID = B.FROM_SITE_ID
      AND    A.TO_SITE_ID = B.TO_SITE_ID
      AND    A.TRANSPORT_MODE = B.FROM_OPEATION_ID +'#'+ B.TO_OPEATION_ID

               
      /*
      SELECT    @v_company 
               ,@v_division
               ,@v_corporation
               ,@v_plant
               ,@v_master_id
               ,@v_plan_id
               ,BOD_ID
               ,ITEM_ID
               ,MIN_TRANSPORT_LOT_SIZE AS TRANSPORT_LOT_SIZE
               ,@v_proc_name as INSERT_ID
               ,@v_insert_dttm as INSERT_DTTM
               ,@v_proc_name as UPDATE_ID
               ,getdate() as UPDATE_DTTM
      FROM    (SELECT   DISTINCT A.BOD_ID
                        ,A.ITEM_ID
                        ,A.MIN_TRANSPORT_LOT_SIZE
                FROM     SY_SCM_ITEM_BOD_M A
                        ,TH_MST_INSTANCE_FLOW B
                WHERE    A.COMPANY_ID       = B.COMPANY_ID
                AND      A.DIVISION_ID      = B.DIVISION_ID
                AND      A.SITE_ID          = B.SITE_ID
                AND      A.PLANT_ID         = B.PLANT_ID
                AND      A.ITEM_ID          = B.ITEM_ID
                AND      A.TO_OPERATION_ID  = B.OPERATION_ID
                AND      B.MASTER_ID        = @v_master_id
                AND      B.PLAN_ID          = @v_plan_id
               ) C
      */
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END;
    
    /*
      TH_MST_ITEM_BOD_CAL
    */
    
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    SET @n_log_count = @n_log_count + 1
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', @n_log_count, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null


END
