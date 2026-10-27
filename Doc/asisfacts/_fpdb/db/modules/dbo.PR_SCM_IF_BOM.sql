CREATE PROCEDURE [dbo].[PR_SCM_IF_BOM]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_BOM                                                             **/
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
  EXEC PR_SCM_IF_BOM
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_BOM'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)
  DECLARE @n_day_diff       Integer  = 0

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
              @key_date = PLAN_DATE,
              @n_day_diff = DAY_DIFF
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     PLAN_DATE,
                     DATEDIFF(MINUTE, CONVERT(DATE, PLAN_START_DTTM), PLAN_START_DTTM) AS DAY_DIFF
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
      BOM 기준으로 Item Flow, Line, Instasnc을 이용하여 Instance별 Plan BOM 데이터 생성
    */
    
    BEGIN
    
      SET @v_table_name = 'TH_BUF_SCM_BOM'
      
      DELETE FROM TH_BUF_SCM_BOM
      
      INSERT INTO TH_BUF_SCM_BOM
             (
             COMPANY_ID
            ,DIVISION_ID
            ,SITE_ID
            ,PLANT_ID
            ,BOM_VERSION_ID
            ,PARENT_ITEM_ID
            ,CHILD_ITEM_ID
            ,PARENT_QTY
            ,CHILD_QTY
            ,ALT_ID
            ,ALT_RATE
            ,ALT_PRIORITY
            ,EFF_START_DATE
            ,EFF_END_DATE
             )
      SELECT DISTINCT
             AA.COMPANY_ID
            ,AA.DIVISION_ID
            ,AA.SITE_ID
            ,AA.PLANT_ID
            ,AA.KEY_DATE   AS BOM_VERSION_ID
            --, '1'   AS BOM_VERSION_ID
            ,AA.PARENT_ITEM_ID
            ,AA.CHILD_ITEM_ID
            ,AA.PARENT_QTY
            ,AA.CHILD_QTY
            ,AA.ALT_ID
            ,AA.ALT_RATE
            ,AA.ALT_PRIORITY
            ,DATEADD(MINUTE, @n_day_diff, AA.EFF_START_DATE) AS EFF_START_DATE
            ,DATEADD(MINUTE, @n_day_diff, AA.EFF_END_DATE)   AS EFF_END_DATE
      FROM   SY_SCM_BOM_M AA,
             (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, 
                     A.KEY_DATE
                     --MAX(KEY_DATE) AS KEY_DATE
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
              AND    A.EFF_END_DATE   > CONVERT(DATE, @plan_start_time)              
              GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.KEY_DATE
              --GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
             ) BB,
             SY_SCM_ITEM_M        CC,
             SY_SCM_ITEM_CLASS_M  DD
      WHERE  AA.COMPANY_ID      = BB.COMPANY_ID
      AND    AA.DIVISION_ID     = BB.DIVISION_ID
      AND    AA.SITE_ID         = BB.SITE_ID
      AND    AA.PLANT_ID        = BB.PLANT_ID
      AND    AA.PARENT_ITEM_ID  = BB.PARENT_ITEM_ID
      AND    AA.CHILD_ITEM_ID   = BB.CHILD_ITEM_ID
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
      AND    AA.EFF_END_DATE    >  CONVERT(DATE, @plan_start_time)
      AND    EXISTS  (
                      SELECT 1
                      FROM   TH_MST_INSTANCE_FLOW X
                      WHERE  X.MASTER_ID    = @v_master_id
                      AND    X.PLAN_ID      = @v_plan_id
                      AND    X.COMPANY_ID   = AA.COMPANY_ID
                      AND    X.DIVISION_ID  = AA.DIVISION_ID
                      AND    X.SITE_ID      = AA.SITE_ID
                      AND    X.PLANT_ID     = AA.PLANT_ID
                      AND    X.ITEM_ID      = AA.PARENT_ITEM_ID
                     )      
    
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      IF   CHARINDEX('KR_E_PRE',  @v_master_id) > 0  -- 전극 전, 후 공정인지 아닌지 확인이 필요 ( 한국만 해당 )
        or CHARINDEX('KR_E_POST', @v_master_id) > 0
      BEGIN
      
        INSERT INTO TH_BUF_SCM_BOM
             (
               COMPANY_ID
              ,DIVISION_ID
              ,SITE_ID
              ,PLANT_ID
              ,BOM_VERSION_ID
              ,PARENT_ITEM_ID
              ,CHILD_ITEM_ID
              ,PARENT_QTY
              ,CHILD_QTY
              ,ALT_ID
              ,ALT_RATE
              ,ALT_PRIORITY
              ,EFF_START_DATE
              ,EFF_END_DATE
             )
        SELECT 
               A.COMPANY_ID
              ,A.DIVISION_ID
              ,A.SITE_ID
              ,A.PLANT_ID
              ,A.BOM_VERSION_ID
              ,A.PARENT_ITEM_ID
              ,A.CHILD_ITEM_ID
              ,MAX(A.PARENT_QTY) AS PARENT_QTY
              ,MAX(A.CHILD_QTY) AS CHILD_QTY
              ,A.ALT_ID AS ALT_ID
              ,MAX(A.ALT_RATE) AS ALT_RATE
              ,MAX(A.ALT_PRIORITY) AS ALT_PRIORITY
              ,DATEADD(MINUTE, @n_day_diff, A.EFF_START_DATE) AS EFF_START_DATE
              ,DATEADD(MINUTE, @n_day_diff, A.EFF_END_DATE)   AS EFF_END_DATE
        FROM   (
                SELECT DISTINCT
                       A.COMPANY_ID
                      ,A.DIVISION_ID
                      ,A.SITE_ID
                      ,B.PLANT_ID
                      ,A.BOM_VERSION_ID
                      ,A.PARENT_ITEM_ID
                      ,A.CHILD_ITEM_ID
                      ,A.CHILD_QTY
                      ,A.PARENT_QTY
                      ,A.ALT_ID
                      ,A.ALT_RATE
                      ,A.ALT_PRIORITY
                      ,A.EFF_START_DATE
                      ,A.EFF_END_DATE
                FROM  (
                       SELECT * 
                       FROM   TH_BUF_SCM_BOM 
                      ) A,
                      (
                        SELECT DISTINCT
                               COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID
                        FROM   SY_FP_INSTANCE_FACTORY_M A,
                               SY_SCM_FACTORY_M B
                        WHERE  A.INSTANCE_ID = @v_master_id
                        AND    A.FACTORY_ID = B.FACTORY_ID
                      ) B
                WHERE A.COMPANY_ID = B.COMPANY_ID
                AND   A.DIVISION_ID = B.DIVISION_ID
                AND   A.SITE_ID = B.SITE_ID
               ) A
        WHERE  NOT EXISTS (
                            SELECT 1
                            FROM   TH_BUF_SCM_BOM X
                            WHERE A.COMPANY_ID = X.COMPANY_ID
                            AND   A.DIVISION_ID = X.DIVISION_ID
                            AND   A.SITE_ID = X.SITE_ID
                            AND   A.PLANT_ID = X.PLANT_ID
                            AND   A.PARENT_ITEM_ID = X.PARENT_ITEM_ID
                            AND   A.CHILD_ITEM_ID = X.CHILD_ITEM_ID
                          )       
        GROUP  BY 
                 A.COMPANY_ID
                ,A.DIVISION_ID
                ,A.SITE_ID
                ,A.PLANT_ID
                ,A.BOM_VERSION_ID
                ,A.PARENT_ITEM_ID
                ,A.CHILD_ITEM_ID
                ,A.ALT_ID
                ,A.EFF_START_DATE
                ,A.EFF_END_DATE

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = 'KR_E_POST 3050 PLANT BOM : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      SET @v_table_name = 'TH_MST_PLAN_BOM'
      
      DELETE FROM TH_MST_PLAN_BOM
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @p_plan_id

      INSERT INTO TH_MST_PLAN_BOM
               (MASTER_ID
               ,PLAN_ID
               ,BOM_VERSION_ID
               ,PARENT_ITEM_ID
               ,CHILD_ITEM_ID
               ,SITE_ID
               ,ROUTE_ID
               ,OPERATION_ID
               ,CONSUME_RATE
               ,PRODUCTION_RATE
               ,ALT_ID
               ,ALT_RATE
               ,ALT_PRIORITY
               ,KEY_DATE
               ,EFF_START_DATE
               ,EFF_END_DATE
               ,INSERT_ID
               ,INSERT_DTTM
               ,UPDATE_ID
               ,UPDATE_DTTM)
      SELECT    DISTINCT
                @v_master_id
               ,@v_plan_id
               ,BOM_VERSION_ID
               ,PARENT_ITEM_ID
               ,CHILD_ITEM_ID
               ,SITE_ID
               ,ROUTE_ID
               ,OPERATION_ID
               ,CONSUME_RATE / PRODUCTION_RATE    AS CONSUME_RATE
               ,PRODUCTION_RATE / PRODUCTION_RATE AS PRODUCTION_RATE
               ,ALT_ID
               ,ALT_RATE
               ,MIN(ALT_PRIORITY) OVER (PARTITION BY ALT_ID, CHILD_ITEM_ID) AS ALT_PRIORITY
               ,@key_date AS KEY_DATE
               ,EFF_START_DATE
               ,EFF_END_DATE
               ,@v_proc_name as INSERT_ID
               ,GETDATE() as INSERT_DTTM
               ,@v_proc_name as UPDATE_ID
               ,getdate() as UPDATE_DTTM
      FROM    (
                SELECT   DISTINCT 
                         AA.BOM_VERSION_ID
                        ,AA.PARENT_ITEM_ID
                        ,ISNULL(BB.NEW_ITEM_ID, AA.CHILD_ITEM_ID) AS CHILD_ITEM_ID
                        ,AA.FACTORY_ID AS SITE_ID
                        ,AA.LINE_ID AS ROUTE_ID
                        ,AA.OPERATION_ID
                        ,CASE WHEN BB.CONSUME_RATE IS NULL THEN AA.CHILD_QTY ELSE 1.0 END CONSUME_RATE
                        --,ISNULL(BB.CONSUME_RATE, AA.CHILD_QTY) * 1.0 AS CONSUME_RATE
                        ,CASE WHEN BB.PRODUCTION_RATE IS NULL THEN AA.PARENT_QTY ELSE 1.0 END PRODUCTION_RATE
                        --,ISNULL(BB.PRODUCTION_RATE, AA.PARENT_QTY) * 1.0 AS PRODUCTION_RATE
                        ,CASE WHEN AA.ALT_ID IS NULL OR AA.ALT_ID = '' THEN NULL
                              ELSE AA.PARENT_ITEM_ID + '_ALT_' + AA.ALT_ID
                         END  ALT_ID
                        ,AA.ALT_RATE
                        ,AA.ALT_PRIORITY
                        ,AA.EFF_START_DATE
                        ,AA.EFF_END_DATE
                FROM   (
                        SELECT   DISTINCT
                                 A.COMPANY_ID
                                ,A.DIVISION_ID
                                ,A.SITE_ID
                                ,A.PLANT_ID
                                ,A.BOM_VERSION_ID
                                ,A.PARENT_ITEM_ID
                                ,A.CHILD_ITEM_ID
                                ,B.FACTORY_ID
                                ,B.LINE_ID
                                ,B.OPERATION_ID
                                ,A.CHILD_QTY
                                ,A.PARENT_QTY
                                ,A.ALT_ID
                                ,A.ALT_RATE
                                ,A.ALT_PRIORITY
                                ,A.EFF_START_DATE
                                ,A.EFF_END_DATE
                        FROM   --SY_FP_PLAN_BOM_M A,
                               TH_BUF_SCM_BOM A,
                               (
                                SELECT *
                                FROM   (
                                        SELECT   DISTINCT
                                                 A.COMPANY_ID
                                                ,A.DIVISION_ID
                                                ,A.SITE_ID
                                                ,A.PLANT_ID
                                                ,A.ITEM_ID
                                                ,A.FACTORY_ID
                                                ,B.LINE_ID
                                                ,A.OPERATION_ID
                                                ,A.OPERATION_SEQ
                                                ,MIN(A.OPERATION_SEQ) OVER (PARTITION BY A.ITEM_ID, A.FACTORY_ID) MIN_SEQ
                                        FROM     TH_MST_INSTANCE_FLOW       A
                                                ,SY_SCM_LINE_M              B
                                                ,SY_SCM_ITEM_LINE_ASSIGN_M  D
                                        WHERE    A.MASTER_ID    = @v_master_id
                                        AND      A.PLAN_ID      = @v_plan_id
                                        AND      A.COMPANY_ID   = B.COMPANY_ID
                                        AND      A.DIVISION_ID  = B.DIVISION_ID
                                        AND      A.SITE_ID      = B.SITE_ID
                                        AND      A.PLANT_ID     = B.PLANT_ID
                                        AND      A.FACTORY_ID   = B.FACTORY_ID
                                        AND      A.COMPANY_ID   = D.COMPANY_ID
                                        AND      A.DIVISION_ID  = D.DIVISION_ID
                                        AND      A.SITE_ID      = D.SITE_ID
                                        AND      A.PLANT_ID     = D.PLANT_ID
                                        AND      A.FACTORY_ID   = D.FACTORY_ID
                                        AND      A.ITEM_ID      = D.ITEM_ID
                                        AND      A.OPERATION_ID = D.OPERATION_ID
                                        AND      B.LINE_ID      = D.LINE_ID
                                        AND      D.ACTIVE_FLAG  = 'Y'
                                        AND      D.MONTH        BETWEEN CONVERT(nvarchar(6), @plan_start_time, 112)
                                                                AND     CONVERT(nvarchar(6), @plan_end_time, 112)
                                        AND      B.ACTIVE_FLAG  = 'Y'
                                       ) A
                                WHERE  OPERATION_SEQ = MIN_SEQ
                               ) B
                        WHERE  A.COMPANY_ID     = B.COMPANY_ID
                        AND    A.DIVISION_ID    = B.DIVISION_ID
                        AND    A.SITE_ID        = B.SITE_ID
                        AND    A.PLANT_ID       = B.PLANT_ID
                        AND    A.PARENT_ITEM_ID = B.ITEM_ID  
                       ) AA
                        LEFT OUTER JOIN (
                                        SELECT DISTINCT
                                               A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID,
                                               A.ITEM_ID + '_' + A.ERP_OPERATION_ID AS NEW_ITEM_ID,
                                               1 CONSUME_RATE, 1 PRODUCTION_RATE
                                        FROM   (
                                                SELECT A.*, 
                                                       ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID
                                                                            ORDER   BY A.OPERATION_SEQ DESC) SEQ
                                                FROM   --SY_SCM_x_ITEM_FLOW_V A
                                                       TH_MST_INSTANCE_FLOW A
                                                     , (
                                                        SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MIN(OPERATION_SEQ) AS OPERATION_SEQ
                                                        FROM   TH_MST_INSTANCE_FLOW A
                                                        WHERE  A.MASTER_ID = @v_master_id
                                                        AND    A.plan_id = @v_plan_id
                                                        AND    CHARINDEX('E_POST', @v_master_id) > 0      -- POST 만 전공정 연결
                                                        GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID
                                                       ) B
                                                     , SY_SCM_OPERATION_M C
                                                WHERE  1=1
                                                AND    A.MASTER_ID = @v_master_id
                                                AND    A.PLAN_ID = @v_plan_id
                                                AND    A.COMPANY_ID = B.COMPANY_ID
                                                AND    A.DIVISION_ID = B.DIVISION_ID
                                                AND    A.SITE_ID = B.SITE_ID
                                                AND    A.PLANT_ID = B.PLANT_ID
                                                AND    A.FACTORY_ID = B.FACTORY_ID
                                                AND    A.ITEM_ID = B.ITEM_ID
                                                AND    A.OPERATION_SEQ < B.OPERATION_SEQ
                                                AND    A.COMPANY_ID = C.COMPANY_ID
                                                AND    A.DIVISION_ID = C.DIVISION_ID
                                                AND    A.SITE_ID = C.SITE_ID
                                                AND    A.OPERATION_ID = C.OPERATION_ID
                                                AND    C.ACTIVE_FLAG = 'Y'
                                               ) A
                                        WHERE  SEQ = 1                
                                        ) BB
                      ON    AA.COMPANY_ID = BB.COMPANY_ID
                      AND   AA.DIVISION_ID = BB.DIVISION_ID
                      AND   AA.SITE_ID = BB.SITE_ID
                      AND   AA.PLANT_ID = BB.PLANT_ID
                      AND   AA.FACTORY_ID = BB.FACTORY_ID
                      AND   AA.PARENT_ITEM_ID = BB.ITEM_ID
               ) H

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
      TH_MST_PLAN_BOM_CAL
    */
    
    
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
