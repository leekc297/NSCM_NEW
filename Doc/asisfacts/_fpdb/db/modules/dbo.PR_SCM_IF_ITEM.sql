CREATE PROCEDURE [dbo].[PR_SCM_IF_ITEM]
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_ITEM'
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
      
      BEGIN
      
        SET @v_table_name = 'TH_MST_ITEM'
        
        DELETE FROM TH_MST_ITEM
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id
        
        INSERT INTO TH_MST_ITEM
                ( MASTER_ID
                , PLAN_ID
                , ITEM_ID
                , ITEM_NAME
                , ITEM_TYPE
                , ITEM_GROUP_ID
                --, SETUP_GROUP_ID
                , FLOW_ID
                , ITEM_UOM
                , SPEC
                --, MIN_LOT_SIZE
                --, INCREMENT_LOT_SIZE
                , DEMAND_LOT_SIZE
                , FINITE_TERM
                , FINITE_TERM_UOM
                , KEY_DATE
                , INSERT_ID
                , INSERT_DTTM
                , UPDATE_ID
                , UPDATE_DTTM )
        SELECT  DISTINCT  
                  @v_master_id
                , @v_plan_id
                , C.ITEM_ID
                , MAX(C.ITEM_NAME) AS ITEM_NAME
                , MIN(C.ITEM_TYPE) AS ITEM_TYPE
                , MAX(C.ITEM_GROUP_ID) AS ITEM_GROUP_ID
                --, C.ITEM_ID AS SETUP_GROUP_ID
                , MIN(C.FLOW_ID) AS FLOW_ID
                , isNULL(MAX(C.ITEM_UOM),'EA')
                , MAX(C.SPEC) AS SPEC
                --, C.MIN_LOT_SIZE
                --, C.INCREMENT_LOT_SIZE
                , MAX(DEMAND_LOT_SIZE) AS DEMAND_LOT_SIZE
                , MIN(FINITE_TERM) AS FINITE_TERM
                , MAX(FINITE_TERM_UOM) AS FINITE_TERM_UOM
                , @key_date AS KEY_DATE
                , @v_proc_name as INSERT_ID
                , GETDATE() as INSERT_DTTM
                , @v_proc_name as UPDATE_ID
                , getdate() as UPDATE_DTTM
        FROM (        
                SELECT  DISTINCT A.COMPANY_ID
                        ,A.DIVISION_ID
                        ,A.SITE_ID
                        ,A.ITEM_ID
                        ,A.ITEM_NAME
                        ,A.ITEM_TYPE
                        ,A.ITEM_GROUP_ID
                        ,A.SETUP_GROUP_ID_1
                        ,A.SETUP_GROUP_ID_2
                        ,A.SETUP_GROUP_ID_3
                        ,A.FLOW_ID
                        ,A.ITEM_UOM
                        ,A.SPEC
                        --,A.MIN_LOT_SIZE
                        --,A.INCREMENT_LOT_SIZE
                        ,A.DEMAND_LOT_SIZE
                        ,A.FINITE_TERM
                        ,A.FINITE_TERM_UOM
                FROM    SY_SCM_ITEM_M A
                        INNER JOIN TH_MST_INSTANCE_FLOW B
                              ON      A.COMPANY_ID = B.COMPANY_ID
                              AND     A.DIVISION_ID = B.DIVISION_ID
                              AND     A.SITE_ID = B.SITE_ID
                              AND     A.ITEM_ID = B.ITEM_ID
                              AND     A.ACTIVE_FLAG = 'Y'
                              AND     B.MASTER_ID = @v_master_id
                              AND     B.PLAN_ID = @v_plan_id
              ) C
        GROUP BY C.ITEM_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = 'Normal Item : ' + convert(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        INSERT INTO TH_MST_ITEM
                ( MASTER_ID
                , PLAN_ID
                , ITEM_ID
                , ITEM_NAME
                , ITEM_TYPE
                , ITEM_GROUP_ID
                , SETUP_GROUP_ID
                , FLOW_ID
                , ITEM_UOM
                , SPEC
                --, MIN_LOT_SIZE
                --, INCREMENT_LOT_SIZE
                , DEMAND_LOT_SIZE
                , FINITE_TERM
                , FINITE_TERM_UOM
                , KEY_DATE
                , INSERT_ID
                , INSERT_DTTM
                , UPDATE_ID
                , UPDATE_DTTM )
        SELECT  DISTINCT
                  @v_master_id
                , @v_plan_id
                , C.ITEM_ID
                , MAX(C.ITEM_NAME) AS ITEM_NAME
                , MIN(C.ITEM_TYPE) AS ITEM_TYPE
                , MAX(C.ITEM_GROUP_ID) AS ITEM_GROUP_ID
                --,(CASE WHEN LEN(GROUP_1) > 0 AND LEN(GROUP_2) > 0 AND LEN(GROUP_3) > 0  THEN GROUP_1+'##'+GROUP_2+'##'+GROUP_3
                --       WHEN LEN(GROUP_1) > 0 AND LEN(GROUP_2) > 0 AND LEN(GROUP_3) = 0  THEN GROUP_1+'##'+GROUP_2
                --       WHEN LEN(GROUP_1) > 0 AND LEN(GROUP_2) = 0 AND LEN(GROUP_3) > 0  THEN GROUP_1+'##NULL##'+GROUP_3
                --       WHEN LEN(GROUP_1) = 0 AND LEN(GROUP_2) > 0 AND LEN(GROUP_3) > 0  THEN 'NULL##'+GROUP_2+'##'+GROUP_3
                --       WHEN LEN(GROUP_1) > 0 AND LEN(GROUP_2) = 0 AND LEN(GROUP_3) = 0  THEN GROUP_1
                --       WHEN LEN(GROUP_1) = 0 AND LEN(GROUP_2) > 0 AND LEN(GROUP_3) = 0  THEN 'NULL##'+GROUP_2
                --       WHEN LEN(GROUP_1) = 0 AND LEN(GROUP_2) = 0 AND LEN(GROUP_3) > 0  THEN 'NULL##NULL##'+GROUP_3
                --       ELSE ''
                --   END) AS SETUP_GROUP_ID
                , C.ITEM_ID AS SETUP_GROUP_ID
                , MIN(C.FLOW_ID) AS FLOW_ID
                , isNULL(MAX(C.ITEM_UOM),'EA') AS ITEM_UOM
                , MAX(C.SPEC) AS SPEC
                --, C.MIN_LOT_SIZE
                --, C.INCREMENT_LOT_SIZE
                , MAX(DEMAND_LOT_SIZE) AS DEMAND_LOT_SIZE
                , MIN(FINITE_TERM) AS DEMAND_LOT_SIZE
                , MAX(FINITE_TERM_UOM) AS FINITE_TERM_UOM
                , @key_date AS KEY_DATE
                , @v_proc_name as INSERT_ID
                , GETDATE() as INSERT_DTTM
                , @v_proc_name as UPDATE_ID
                , getdate() as UPDATE_DTTM
        FROM (        
                SELECT  DISTINCT A.COMPANY_ID
                        ,A.DIVISION_ID
                        ,A.SITE_ID
                        ,A.ITEM_ID
                        ,A.ITEM_NAME
                        ,A.ITEM_TYPE
                        ,A.ITEM_GROUP_ID
                        --,A.SETUP_GROUP_ID_1
                        --,A.SETUP_GROUP_ID_2
                        --,A.SETUP_GROUP_ID_3
                        ,A.FLOW_ID
                        ,A.ITEM_UOM
                        ,A.SPEC
                        --,A.MIN_LOT_SIZE
                        --,A.INCREMENT_LOT_SIZE
                        ,A.DEMAND_LOT_SIZE
                        --,(CASE WHEN LEN(RTRIM(LTRIM(A.SETUP_GROUP_ID_1))) > 0 AND   A.SETUP_GROUP_ID_1 IS NOT NULL
                        --      THEN RTRIM(LTRIM(A.SETUP_GROUP_ID_1))
                        --      ELSE ''
                        -- END) AS GROUP_1
                        --,(CASE WHEN LEN(RTRIM(LTRIM(A.SETUP_GROUP_ID_2))) > 0 AND   A.SETUP_GROUP_ID_2 IS NOT NULL
                        --      THEN RTRIM(LTRIM(A.SETUP_GROUP_ID_2))
                        --      ELSE ''
                        -- END) AS GROUP_2
                        --,(CASE WHEN LEN(RTRIM(LTRIM(A.SETUP_GROUP_ID_3))) > 0 AND   A.SETUP_GROUP_ID_3 IS NOT NULL
                        --      THEN RTRIM(LTRIM(A.SETUP_GROUP_ID_3))
                        --      ELSE ''
                        -- END) AS GROUP_3
                        ,A.FINITE_TERM
                        ,A.FINITE_TERM_UOM
                FROM    SY_SCM_ITEM_M A
                        INNER JOIN (
                                          SELECT DISTINCT
                                                 A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.CHILD_ITEM_ID AS ITEM_ID
                                          FROM   
                                                 --SY_SCM_BOM_M A,
                                                 (
                                                  SELECT A.*  
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
                                                  AND    A.EFF_END_DATE   > CONVERT(DATE, @plan_start_time)
                                                 ) A,
                                                 TH_MST_INSTANCE_FLOW B
                                          WHERE  A.COMPANY_ID = B.COMPANY_ID
                                          AND    A.DIVISION_ID = B.DIVISION_ID
                                          AND    A.SITE_ID = B.SITE_ID
                                          AND    A.PLANT_ID = B.PLANT_ID
                                          AND    A.PARENT_ITEM_ID = B.ITEM_ID
                                          AND    A.ACTIVE_FLAG = 'Y'
                                          AND    B.MASTER_ID = @v_master_id
                                          AND    B.PLAN_ID = @v_plan_id
                                          AND    NOT EXISTS ( SELECT 1
                                                              FROM   TH_MST_ITEM X
                                                              WHERE  X.MASTER_ID = @v_master_id
                                                              AND    X.PLAN_ID = @v_plan_id
                                                              AND    X.ITEM_ID = A.CHILD_ITEM_ID)
                                        ) B
                              ON      A.COMPANY_ID = B.COMPANY_ID
                              AND     A.DIVISION_ID = B.DIVISION_ID
                              AND     A.SITE_ID = B.SITE_ID
                              AND     A.ITEM_ID = B.ITEM_ID 
                              AND     A.ACTIVE_FLAG = 'Y'
              ) C
        GROUP  BY C.ITEM_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = 'Instance Change Item : ' + convert(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        INSERT INTO TH_MST_ITEM
                ( MASTER_ID
                , PLAN_ID
                , ITEM_ID
                , ITEM_NAME
                , ITEM_TYPE
                , ITEM_GROUP_ID
                , SETUP_GROUP_ID
                , FLOW_ID
                , ITEM_UOM
                , SPEC
                --, MIN_LOT_SIZE
                --, INCREMENT_LOT_SIZE
                , DEMAND_LOT_SIZE
                , FINITE_TERM
                , FINITE_TERM_UOM
                , KEY_DATE
                , INSERT_ID
                , INSERT_DTTM
                , UPDATE_ID
                , UPDATE_DTTM )
        SELECT  DISTINCT
                  @v_master_id
                , @v_plan_id
                , C.NEW_ITEM_ID AS ITEM_ID
                , C.NEW_ITEM_ID AS ITEM_NAME
                , 'R'  ITEM_TYPE
                , NULL ITEM_GROUP_ID
                , '' SETUP_GROUP_ID
                , NULL FLOW_ID
                , 'EA'
                , 'LANE_MODELING_ITEM' SPEC
                , NULL DEMAND_LOT_SIZE
                , 0 FINITE_TERM
                , 'DAY' FINITE_TERM_UOM
                , @key_date AS KEY_DATE
                , @v_proc_name as INSERT_ID
                , GETDATE() as INSERT_DTTM
                , @v_proc_name as UPDATE_ID
                , getdate() as UPDATE_DTTM
        FROM (        
                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID,
                       A.ITEM_ID + '_' + A.ERP_OPERATION_ID AS NEW_ITEM_ID
                FROM   (
                        SELECT A.*, --C.ERP_OPERATION_ID,
                               ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID
                                                    ORDER   BY A.OPERATION_SEQ DESC) SEQ
                        FROM   --SY_SCM_x_ITEM_FLOW_V A
                               TH_MST_INSTANCE_FLOW A
                               INNER JOIN (
                                                SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MIN(OPERATION_SEQ) AS OPERATION_SEQ
                                                FROM   TH_MST_INSTANCE_FLOW A
                                                WHERE  A.MASTER_ID = @v_master_id
                                                AND    A.plan_id = @v_plan_id
                                                GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID
                                               ) B
                                      ON     A.COMPANY_ID = B.COMPANY_ID
                                      AND    A.DIVISION_ID = B.DIVISION_ID
                                      AND    A.SITE_ID = B.SITE_ID
                                      AND    A.PLANT_ID = B.PLANT_ID
                                      AND    A.FACTORY_ID = B.FACTORY_ID
                                      AND    A.ITEM_ID = B.ITEM_ID
                                      AND    A.OPERATION_SEQ < B.OPERATION_SEQ
                               INNER JOIN SY_SCM_OPERATION_M C
                                      ON     A.COMPANY_ID = C.COMPANY_ID
                                      AND    A.DIVISION_ID = C.DIVISION_ID
                                      AND    A.SITE_ID = C.SITE_ID
                                      AND    A.OPERATION_ID = C.OPERATION_ID
                                      AND    C.ACTIVE_FLAG = 'Y'
                        WHERE  A.MASTER_ID = @v_master_id
                        AND    A.PLAN_ID = @v_plan_id
                       ) A
                WHERE  SEQ = 1
              ) C

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = 'Lane Modeling Item : ' + convert(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END
      
      BEGIN

        UPDATE TH_MST_ITEM
        SET    TH_MST_ITEM.ITEM_TYPE = 'R'
        FROM   TH_MST_ITEM A,
               (
                SELECT ITEM_ID, ITEM_TYPE, FLOW_ID, MAX(POS) AS POS
                FROM   (
                        SELECT ITEM_ID, ITEM_TYPE, FLOW_ID, CHARINDEX(B.OPERATION_ID, A.FLOW_ID) AS POS
                        FROM   TH_MST_ITEM A,
                               (
                                SELECT DISTINCT OPERATION_ID
                                FROM   SY_SCM_OPERATION_M A,
                                       (
                                        SELECT B.*, A.INSTANCE_TYPE 
                                        FROM   SY_FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                                               SY_SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
                                        WHERE  A.INSTANCE_ID = @V_MASTER_ID
                                        AND    A.FACTORY_ID = B.FACTORY_ID
                                        AND    B.ACTIVE_FLAG = 'Y'
                                       ) B       
                                WHERE  A.COMPANY_ID    = B.COMPANY_ID
                                AND    A.DIVISION_ID   = B.DIVISION_ID
                                AND    A.SITE_ID       = B.SITE_ID
                                AND    A.INSTANCE_TYPE = B.INSTANCE_TYPE
                               ) B
                        WHERE  A.MASTER_ID  = @v_master_id
                        AND    A.PLAN_ID    = @v_plan_id
                        AND    A.FLOW_ID    IS NOT NULL
                       ) A
                WHERE  POS IS NOT NULL
                GROUP  BY ITEM_ID, ITEM_TYPE, FLOW_ID
                HAVING MAX(POS) = 0
               ) B
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.ITEM_ID    = B.ITEM_ID
        AND    A.ITEM_TYPE  IN ('P', 'H')
      
        --LOG 생성
        SET @v_message = 'ITEM_TYPE ( R ) : ' + convert(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
        UPDATE TH_MST_ITEM
        SET    TH_MST_ITEM.ITEM_TYPE = 'H'
             , UPDATE_ID = 'ITEM_TYPE IS NULL'
        FROM   TH_MST_ITEM A
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    ISNULL(A.ITEM_TYPE, '##') NOT IN ('P','H','R')
        
        --LOG 생성
        SET @v_message = 'ITEM_TYPE IS NULL DATA - ( H ) : ' + convert(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE TH_MST_ITEM
        SET    TH_MST_ITEM.ITEM_TYPE = 'H'
        FROM   TH_MST_ITEM A
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.ITEM_TYPE  = 'P'
        
        --LOG 생성
        SET @v_message = 'ITEM_TYPE = P - ( H ) : ' + convert(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END
      
      IF CHARINDEX('CELL', @v_master_id) > 0
      BEGIN
      
        SET @v_table_name = 'TH_MST_ITEM'

        -- CELL 에서 전극 ITEM 이 존재할 경우 
        -- FLOW ID 가 없는 경우가 있어서 위에서 UPDATE 안됨
        UPDATE TH_MST_ITEM
        SET    TH_MST_ITEM.ITEM_TYPE = 'R'
        FROM   TH_MST_ITEM A
        WHERE  MASTER_ID  = @v_master_id
        AND    PLAN_ID    = @v_plan_id
        AND    A.ITEM_TYPE IN ('H','P')
        AND    A.ITEM_ID IN (
                             SELECT  ITEM_ID 
                             FROM    SY_SCM_ITEM_M       A
                                   , SY_SCM_ITEM_CLASS_M B
                             WHERE   A.ITEM_CLASS   = B.CLASS_ID
                             AND     A.ACTIVE_FLAG  = 'Y'
                             AND     B.USE_FLAG     = 'Y'
                             AND     B.LEVEL_2_CODE = 'APC'
                            )

        --LOG 생성
        SET @v_message = 'ITEM_TYPE = H - ( R ) : ' + convert(nvarchar, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_MST_ITEM_CAL'
        
        DELETE FROM TH_MST_ITEM_CAL
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @p_plan_id

        INSERT INTO TH_MST_ITEM_CAL
              (
                MASTER_ID
              , PLAN_ID
              , ITEM_ID
              , DESCR
              , IS_USE
              , START_DATE
              , END_DATE
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM              
              )
        SELECT  DISTINCT
                @v_master_id
              , @v_plan_id
              , A.ITEM_ID
              , A.DESCRIPTION
              , 'N' AS IS_USE
              , CONVERT(DATE, ERP_EOL) AS START_DATE
              , DATEADD(MM, 1, CONVERT(DATE, @plan_end_time)) AS END_DATE
              , @key_date AS KEY_DATE
              , @v_proc_name as INSERT_ID
              , GETDATE() as INSERT_DTTM
              , @v_proc_name as UPDATE_ID
              , getdate() as UPDATE_DTTM
        FROM    SY_SCM_ITEM_M           A
                , SY_SCM_ITEM_CLASS_M   B
                , TH_MST_INSTANCE_FLOW  C
        WHERE   1=1
        AND     A.ITEM_CLASS = B.CLASS_ID
        AND     A.ACTIVE_FLAG = 'Y'
        AND     B.USE_FLAG = 'Y'
        AND     A.COMPANY_ID = C.COMPANY_ID
        AND     A.DIVISION_ID = C.DIVISION_ID
        AND     A.SITE_ID = C.SITE_ID
        AND     A.ITEM_ID = C.ITEM_ID
        AND     C.MASTER_ID = @v_master_id
        AND     C.PLAN_ID = @v_plan_id
        AND     CONVERT(DATE, ERP_EOL) BETWEEN CONVERT(DATE, @plan_start_time) AND CONVERT(DATE, @plan_end_time)

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END
          
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
