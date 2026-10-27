
CREATE PROCEDURE [dbo].[PR_SCM_RF_RESCHEDULE_FP_AMEND_POST]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_factory_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_RF_RESCHEDULE_FP_AMEND_POST                                        **/
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
/**------------------------------------------------------------------------------------------- **/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2019.08.27    shs          최초 작성                                                      **/
/** 2021.01.05    CYS          후공정 Shift 별 확정 (D.201130 ~ R.0105)                          **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_RF_RESCHEDULE_FP_AMEND
  

*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_factory_id     nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_RF_RESCHEDULE_FP_AMEND_POST'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  DECLARE @n_job_seq        Integer  = 0
  DECLARE @sysdate          DATETIME2 = GETDATE()

  -- 사용자 변수 설정
  DECLARE @v_confirm_date   date
        , @v_plan_date      date
        , @v_key_date       date
        , @key_date         nvarchar(8)
  DECLARE @v_release_term   Int
  DECLARE @n_day_diff         Integer  = 0

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)
  
  DECLARE @v_instance_code      nvarchar(10)
  DECLARE @v_instance_sub_code  nvarchar(10)
  DECLARE @v_order_date_code    nvarchar(10)
  DECLARE @v_hhmiss             nvarchar(10)
  
  DECLARE @v_lgc_site           nvarchar(10)
  
  -------------------------------------------------------------------------------------------

  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id
  SET @v_factory_id = @p_factory_id

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN
    
      SET @v_table_name = ''

      --LOG 생성
      SET @v_message = 'FACTORY_ID : ' + @v_factory_id
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null
 
BEGIN

      SELECT @v_lgc_site = ISNULL(MAX(B.SITE_ID), 'A001' )
      FROM   FP_INSTANCE_FACTORY_M  A
           , SCM_FACTORY_M          B
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FACTORY_ID   = B.FACTORY_ID
      AND    A.ACTIVE_FLAG  = 'Y'
      AND    B.ACTIVE_FLAG  = 'Y'
    
      --LOG 생성
      SET @v_message = '@v_lgc_site : ' + @v_lgc_site
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      END

      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'
      
      -- DEFAULT 값
      SET @v_release_term = 7
      
      SELECT @v_release_term = ISNULL(MAX(CONVERT(INT, SEGMENT3)), 7)
      FROM   SCM_SYS_LOOKUP_VALUE
      WHERE  LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM'
      AND    SEGMENT1 = @v_master_id        -- INSTANCE_ID
      AND    SEGMENT2 = @v_factory_id       -- FACTORY_ID
      AND    SEGMENT4 = 'DAY'

      --LOG 생성
      SET @v_message = '@v_release_term : ' + convert(nvarchar, @v_release_term, 23)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      
      SET @v_table_name = 'SCM_FP_PLAN_H'
      
      SELECT @v_confirm_date  = DATEADD(DAY, @v_release_term, CONVERT(DATE, A.PLAN_START_TIME))
           , @v_plan_date     = CONVERT(DATE, PLAN_START_TIME)
           , @v_key_date      = CONVERT(DATE, PLAN_START_TIME)
           , @n_day_diff  = DATEDIFF(MINUTE, CONVERT(DATE, PLAN_START_TIME), PLAN_START_TIME) 
           , @v_hhmiss    = REPLACE(CONVERT(NVARCHAR, PLAN_START_TIME, 8), ':', '')
           , @key_date    = CONVERT(NVARCHAR, PLAN_START_TIME, 112)
      FROM   SCM_FP_PLAN_H A
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.PLAN_ID      = @v_plan_id
      
      --LOG 생성
      SET @v_message = '@v_confirm_date : ' + convert(nvarchar, @v_confirm_date, 23)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      SELECT @v_instance_code = ISNULL(MAX(A.KEY_VALUE), '-')
      FROM   FP_INSTANCE_CONFIG_M  AS A
      WHERE  A.INSTANCE_ID = @v_master_id
      AND    A.CATEGORY_ID = 'EXPORT' 
      AND    A.KEY_ID = 'INSTANCE_CODE'

      --LOG 생성
      SET @v_message = '@v_instance_code : ' + ISNULL(@v_instance_code, '')
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

      SELECT @v_instance_code = ISNULL(MAX(A.KEY_VALUE), '-')
      FROM   FP_INSTANCE_CONFIG_M  AS A
      WHERE  A.INSTANCE_ID = @v_master_id
      AND    A.CATEGORY_ID = 'EXPORT' 
      AND    A.KEY_ID = 'INSTANCE_CODE'

      --LOG 생성
      SET @v_message = '@v_instance_code : ' + ISNULL(@v_instance_code, '')
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'

      SELECT @v_instance_sub_code = SEGMENT3
      FROM   SCM_SYS_LOOKUP_VALUE
      WHERE  1=1
      AND    SEGMENT1         = @v_master_id
      AND    LOOKUP_TYPE_CODE = 'INSTANCE_ID'              

      --LOG 생성
      SET @v_message = '@v_instance_sub_code : ' + ISNULL(@v_instance_sub_code, '')
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

  SELECT @v_order_date_code = SUBSTRING(@key_date, 3, 2)
        + CASE SUBSTRING(@key_date, 5, 2)
                                         WHEN '10' THEN 'A'
                                         WHEN '11' THEN 'B'
                                         WHEN '12' THEN 'C'
                                         ELSE SUBSTRING(@key_date, 6, 1)
                                     END
                                   + SUBSTRING(@key_date, 7, 2)

      --LOG 생성
      SET @v_message = '@v_order_date_code : ' + ISNULL(@v_order_date_code, '')
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
    END
    
    BEGIN
      
      -- DIVISION ID CONFIG SETTING 후 설정
      -- (D.201130 ~ R.0105) 외부에서 설정
      /**
      SET @v_table_name = 'SCM_FP_PLAN_DETAIL_H'
      
      DELETE SCM_FP_PLAN_DETAIL_H WHERE PLAN_DATE = @key_date AND INSTANCE_ID = @v_master_id AND FACTORY_ID = @v_factory_id

      --LOG 생성
      SET @v_message = 'DELETE : ' + + convert(nvarchar, @v_factory_id)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      
      INSERT INTO SCM_FP_PLAN_DETAIL_H
            (
              PLAN_DATE , 
              INSTANCE_ID , 
              DIVISION_ID , 
              FACTORY_ID , 
              PLAN_ID ,  
              CONFIRM_ID , 
              CONFIRM_TIME , 
              INSERT_ID , 
              INSERT_TIME , 
              UPDATE_ID , 
              UPDATE_TIME
            )
      SELECT @key_date , @v_master_id , '81' , @v_factory_id , @v_plan_id  , @v_proc_name , getdate(), @v_proc_name as INSERT_ID , getdate() , @v_proc_name as INSERT_ID , getdate() 
    
      --LOG 생성
      SET @v_message = 'INSERT : ' + + convert(nvarchar, @v_factory_id)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
	**/

      SET @v_table_name = 'TH_MST_INSTANCE_FLOW_POST'
      
      DELETE FROM TH_MST_INSTANCE_FLOW_POST
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      
      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      
      INSERT INTO TH_MST_INSTANCE_FLOW_POST
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
   END BATCH_TYPE,
             CAPA_TYPE,
             'N' AS HALF_SLIT_FLAG,
             @v_plan_date                AS KEY_DATE,
             @v_proc_name as INSERT_ID,
             convert(date, @v_plan_date) as INSERT_DTTM,
             @v_proc_name as UPDATE_ID,
             getdate() as UPDATE_DTTM
      FROM   (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, D.PLANT_ID, D.FACTORY_ID, A.ITEM_ID,
                     B.FLOW_ID, B.OPERATION_ID, B.OPERATION_SEQ
              FROM   SCM_ITEM_M A WITH(NOLOCK)
                      INNER JOIN SCM_OPERATION_FLOW_M B WITH(NOLOCK)
                            ON     A.COMPANY_ID = B.COMPANY_ID
AND    A.DIVISION_ID = B.DIVISION_ID
                            AND    A.SITE_ID = B.SITE_ID
                            AND    A.FLOW_ID = B.FLOW_ID
                            AND    B.ACTIVE_FLAG = 'Y'
                      INNER JOIN SCM_ITEM_CLASS_M C WITH(NOLOCK)
                            ON     A.ITEM_CLASS = C.CLASS_ID
                            AND    C.USE_FLAG = 'Y'
                   , (
                      SELECT B.*, A.INSTANCE_TYPE 
                      FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK),   -- INSTANCE 별 FACTORY ID
                             SCM_FACTORY_M         B WITH(NOLOCK)    -- FACTORY 별 SITE ID
                      WHERE  A.INSTANCE_ID = @v_master_id
                      AND    A.FACTORY_ID = B.FACTORY_ID
                      AND    A.ACTIVE_FLAG = 'Y'
                      AND    B.ACTIVE_FLAG = 'Y'
                     ) D
              WHERE  A.ACTIVE_FLAG = 'Y'
              AND    A.COMPANY_ID = D.COMPANY_ID
              AND    A.DIVISION_ID = D.DIVISION_ID
              AND    A.SITE_ID = D.SITE_ID
             ) A,
             (
              SELECT A.*, B.PLANT_ID, B.FACTORY_ID
              FROM   SCM_OPERATION_M A WITH(NOLOCK),
                     (
                      SELECT B.*, A.INSTANCE_TYPE 
                      FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK),   -- INSTANCE 별 FACTORY ID
                             SCM_FACTORY_M         B WITH(NOLOCK)    -- FACTORY 별 SITE ID
                      WHERE  A.INSTANCE_ID = @v_master_id
                      AND    A.FACTORY_ID = B.FACTORY_ID
                      AND    A.ACTIVE_FLAG = 'Y'
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
                              FROM   SCM_BOM_M         A WITH(NOLOCK),
                                     SCM_ITEM_M        B WITH(NOLOCK),
                                     SCM_ITEM_CLASS_M  C WITH(NOLOCK)
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
      
      SET @v_table_name = 'TH_MST_INSTANCE_LINE_POST'
      
      DELETE FROM TH_MST_INSTANCE_LINE_POST
      WHERE  MASTER_ID  = @v_master_id
      AND    PLAN_ID    = @v_plan_id
      
      INSERT INTO TH_MST_INSTANCE_LINE_POST
           (
             MASTER_ID
           , PLAN_ID
           , COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , FACTORY_ID
           , LINE_ID
           , OPERATION_ID
           , ELECTRODE_TYPE
           , LOCATION
           , RESOURCE_ID
           , FP_LINE_ID
           , TOP_LINE_ID
           , LINE_SETUP_GROUP_ID
           , MODEL_TYPE
           , INSERT_ID
           , INSERT_DTTM
           , UPDATE_ID
           , UPDATE_DTTM
           )
      SELECT DISTINCT
             B.MASTER_ID
           , B.PLAN_ID
           , A.COMPANY_ID
           , A.DIVISION_ID
           , A.SITE_ID
           , A.PLANT_ID
           , A.FACTORY_ID
           , A.LINE_ID
           , A.OPERATION_ID
           , A.ELECTRODE_TYPE
           , ISNULL(A.LOCATION, '-')  AS LOCATION
           , CASE WHEN D.KEY_VALUE <> 'LINE' THEN '-'   -- EQUIPMENT 일 경우 설비까지 사용할 필요가 없어서
                  ELSE A.LINE_ID + '_' + A.OPERATION_ID 
                                 + CASE ISNULL(A.ELECTRODE_TYPE, '-') WHEN '-'  THEN ''
                    WHEN ''   THEN ''
                                                                                ELSE '_' + A.ELECTRODE_TYPE
                                   END  
             END  AS RESOURCE_ID             
           , A.LINE_ID  AS FP_LINE_ID
           , A.TOP_LINE_ID
           , A.LINE_SETUP_GROUP_ID
           , A.MODEL_TYPE
           , @v_proc_name       AS INSERT_ID
           , GETDATE()          AS INSERT_DTTM
           , @v_proc_name       AS UPDATE_ID
           , getdate()          AS UPDATE_DTTM
      FROM   SCM_LINE_M        A WITH(NOLOCK)
--             INNER JOIN SCM_EQUIPMENT_M   C
--                  ON    A.COMPANY_ID      = C.COMPANY_ID
--                  AND   A.DIVISION_ID     = C.DIVISION_ID
--                  AND   A.SITE_ID         = C.SITE_ID
--                  AND   A.PLANT_ID        = C.PLANT_ID
--                  AND   A.FACTORY_ID      = C.FACTORY_ID
--                  AND   A.LINE_ID         = C.LINE_ID
--                  AND   A.OPERATION_ID    = C.OPERATION_ID
--                  AND   A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE
--                  AND   C.EQUIPMENT_TYPE  = 'M'
--                  AND   C.ACTIVE_FLAG     = 'Y'
             LEFT OUTER JOIN FP_INSTANCE_CONFIG_M D WITH(NOLOCK)
                  ON    D.INSTANCE_ID     = @v_master_id
                  AND   D.CATEGORY_ID     = 'RESOURCE_CATEGORY'
                  AND   D.KEY_ID          = 'PRE'
           , TH_MST_INSTANCE_FLOW_POST B WITH(NOLOCK)
      WHERE  A.COMPANY_ID     = B.COMPANY_ID
      AND    A.DIVISION_ID    = B.DIVISION_ID
      AND    A.SITE_ID        = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.FACTORY_ID     = B.FACTORY_ID
      AND    A.OPERATION_ID   = B.OPERATION_ID
AND    A.ACTIVE_FLAG   = 'Y'
      AND    B.MASTER_ID      = @v_master_id
      AND    B.PLAN_ID        = @v_plan_id

--LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      SET @v_table_name = 'TH_MST_INSTANCE_RELEASE_LINE_POST'

      DELETE FROM TH_MST_INSTANCE_RELEASE_LINE_POST
      WHERE  MASTER_ID  = @v_master_id
      AND    PLAN_ID    = @v_plan_id
      
      INSERT INTO TH_MST_INSTANCE_RELEASE_LINE_POST
           (
             MASTER_ID
           , PLAN_ID
         , FACTORY_ID
           , LINE_ID
           , OPERATION_ID
           , ELECTRODE_TYPE
           , RELEASE_ID
           , RELEASE_DATE
           , RELEASE_PLAN_ID
           , INSERT_ID
           , INSERT_TIME
           )
      SELECT DISTINCT
             A.MASTER_ID
           , A.PLAN_ID
           , A.FACTORY_ID
           , A.LINE_ID
           , A.OPERATION_ID
           , A.ELECTRODE_TYPE
           , B.INSTANCE_ID      AS RELEASE_ID
           , B.INSTANCE_DATE    AS RELEASE_DATE
           , B.RELEASE_PLAN_ID
           , @v_proc_name       AS INSERT_ID
           , GETDATE()          AS INSERT_TIME
      FROM   TH_MST_INSTANCE_LINE_POST A WITH(NOLOCK)
           , (
              SELECT A.*
              FROM   (
                      SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.RELEASE_PLAN_ID
                           , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
                           , DENSE_RANK() OVER (PARTITION BY A.INSTANCE_DATE
                                                           , A.FACTORY_ID
                                                           , A.OPERATION_ID
                                                           , A.LINE_ID
                                                           , A.ELECTRODE_TYPE
                                                ORDER     BY A.RELEASE_PLAN_ID) AS SEQ
                      FROM   FP_RELEASE_PLAN_LINE_INFO_H A WITH(NOLOCK)
                           , (
                              SELECT A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
                                   , MAX(INSTANCE_DATE) AS INSTANCE_DATE
                              FROM   FP_RELEASE_PLAN_LINE_INFO_H A WITH(NOLOCK)
                              WHERE  A.INSTANCE_DATE  <= @v_plan_date
                              AND    EXISTS (
                                              SELECT 1
                                              FROM   HIS_FP_PLAN_DETAIL_H X
                                              WHERE  X.INSTANCE_ID        = A.INSTANCE_ID
                                              AND    X.PLAN_DATE          = A.INSTANCE_DATE
                                              AND    X.RELEASE_PLAN_ID    = A.RELEASE_PLAN_ID
                                              AND    X.CONFIRM_FLAG       = 'Y'
                                              AND    X.RELEASE_FLAG       = 'Y'
                                              AND    X.MES_TRANSFER_FLAG  = 'Y'
                                              UNION  ALL
                                              SELECT 1
                                              FROM   HIS_FP_PLAN_GROUP_DETAIL_H X
                                              WHERE  X.INSTANCE_ID        = A.INSTANCE_ID
                                              AND    X.PLAN_DATE          = A.INSTANCE_DATE
                                              AND    X.RELEASE_PLAN_ID    = A.RELEASE_PLAN_ID
                                              AND    X.CONFIRM_FLAG       = 'Y'
                                              AND    X.RELEASE_FLAG = 'Y'
                                AND    X.MES_TRANSFER_FLAG  = 'Y'                                        
   )
   GROUP  BY
  A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
                             ) B
                      WHERE  A.INSTANCE_DATE  = B.INSTANCE_DATE
                      AND    A.FACTORY_ID     = B.FACTORY_ID
                      AND    A.OPERATION_ID   = B.OPERATION_ID
                      AND    A.LINE_ID        = B.LINE_ID
                      AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
                     ) A
              WHERE  A.SEQ = 1
             ) B
      WHERE  A.MASTER_ID      = @v_master_id
      AND    A.PLAN_ID        = @v_plan_id
      AND    A.FACTORY_ID     = B.FACTORY_ID
      AND    A.LINE_ID        = B.LINE_ID
      AND    A.OPERATION_ID   = B.OPERATION_ID
      AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
      ;
      
      --LOG 생성
      SET @v_message = 'PLAN_START_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      
      BEGIN

        SET @v_table_name = 'TH_MST_SCM_ORDER_STATUS_POST'

        DELETE FROM TH_MST_SCM_ORDER_STATUS_POST
        WHERE  INSTANCE_ID  = @v_master_id
        AND    FP_PLAN_ID   = @v_plan_id

        
        INSERT INTO TH_MST_SCM_ORDER_STATUS_POST
              (
                INSTANCE_ID
              , FP_PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , WORK_ORDER_SPL_ID
              , WORK_ORDER_ID
              , DEMAND_ID
              , PRODUCTION_TYPE
              , ORDER_TYPE
              , ITEM_ID
              , TOP_ITEM_ID
              , OPERATION_ID
              , LINE_ID
              , ELECTRODE_TYPE
              , WORK_CENTER_ID
              , EQUIPMENT_ID
              , PLAN_DATE
              , PLAN_START_TIME
              , PLAN_END_TIME
              , PLAN_QTY
              , PLAN_IN_QTY
              , ACTUAL_START_TIME
              , ACTUAL_END_TIME
              , ACTUAL_QTY
              , ACTUAL_GOOD_QTY
              , ACTUAL_SCRAP_QTY
              , RUNNING_FLAG
              , WO_STATUS
              , ORG_QTY
              , REMAIN_QTY
              , BATCH_ORDER_ID
              , MARKET
              , LANE_QTY
              , FIX_EQUIPMENT_ID
              , ACTUAL_FLAG
              , INSERT_ID
              , INSERT_TIME
              )
        SELECT  DISTINCT
                @v_master_id      AS INSTANCE_ID
              , @v_plan_id        AS FP_PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.WORK_ORDER_SPL_ID AS WORK_ORDER_SPL_ID
              , A.WORK_ORDER_SPL_ID AS WORK_ORDER_ID
              , A.DEMAND_ID
              , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                     WHEN A.PRODUCTION_TYPE = ''    THEN 'MASS'
                     ELSE A.PRODUCTION_TYPE
                END  AS PRODUCTION_TYPE
              , A.ORDER_TYPE
              , A.ITEM_ID
              , A.TOP_ITEM_ID
              , A.OPERATION_ID
              , A.LINE_ID AS LINE_ID
              , B.ELECTRODE_TYPE AS ELECTRODE_TYPE
              , A.WORK_CENTER_ID
              , A.EQUIPMENT_ID AS  EQUIPMENT_ID
              , A.PLAN_DATE
              , A.PLAN_START_TIME
              , A.PLAN_END_TIME
              , A.PLAN_QTY
              , A.PLAN_IN_QTY
              , A.ACTUAL_START_TIME
              , A.ACTUAL_END_TIME
              , ISNULL(A.ACTUAL_QTY,        0.0) AS ACTUAL_QTY
              , ISNULL(A.ACTUAL_GOOD_QTY,   0.0) AS ACTUAL_GOOD_QTY
      , ISNULL(A.ACTUAL_SCRAP_QTY,  0.0) AS ACTUAL_SCRAP_QTY
              , CASE WHEN ISNULL(A.ACTUAL_QTY, 0.0) > 0 THEN 'Y'
                     ELSE 'N'
               END  AS RUNNING_FLAG
              , A.WO_STATUS
              , 0           AS ORG_QTY
              , 0           AS REMAIN_QTY
              , A.BATCH_ORDER_ID
              , A.MARKET
              , A.LANE_QTY
              , A.EQUIPMENT_ID
              , CASE WHEN ISNULL(A.ACTUAL_QTY, 0.0) > 0 THEN 'Y'
                     ELSE 'N'
                END  AS ACTUAL_FLAG
              , @v_proc_name INSERT_ID
              , GETDATE() INSERT_TIME
        FROM   FP_MES_WORK_ORDER_STATUS_H A WITH(NOLOCK)
               LEFT OUTER JOIN SCM_EQUIPMENT_M B WITH(NOLOCK)
             ON    A.COMPANY_ID    = B.COMPANY_ID
                    AND   A.DIVISION_ID   = B.DIVISION_ID
                    AND   A.SITE_ID       = B.SITE_ID
                    AND   A.PLANT_ID      = B.PLANT_ID
                    AND   A.FACTORY_ID    = B.FACTORY_ID
                    AND   A.LINE_ID       = B.LINE_ID
                    AND   A.OPERATION_ID  = B.OPERATION_ID
                    AND   A.EQUIPMENT_ID  = B.EQUIPMENT_ID    -- LINE 계획 수립하는 경우에도 대표 EQUIPMENT_ID 가 I/F 되므로,, 이걸 쓴다.
        WHERE  A.CUTOFF_DATE    = @v_plan_date
        AND    A.WO_STATUS IN ('OPEN','RUN')
        AND    EXISTS (
                        SELECT 1
                        FROM   TH_MST_INSTANCE_LINE_POST X
                        WHERE  X.MASTER_ID      = @v_master_id
                        AND    X.PLAN_ID        = @v_plan_id
                        AND    X.COMPANY_ID     = A.COMPANY_ID
                        AND    X.DIVISION_ID    = A.DIVISION_ID
                        AND    X.SITE_ID        = A.SITE_ID
                        AND    X.PLANT_ID       = A.PLANT_ID
                        AND    X.FACTORY_ID     = A.FACTORY_ID
                        AND    X.LINE_ID        = A.LINE_ID
                        AND    X.OPERATION_ID   = A.OPERATION_ID
                        AND    X.OPERATION_ID  != 'A6000'
                      )
                     
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        DELETE FROM A
        FROM   TH_MST_SCM_ORDER_STATUS_POST      A
             , TH_MST_INSTANCE_RELEASE_LINE_POST B
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id
        AND    A.INSTANCE_ID    = B.MASTER_ID
        AND    A.FP_PLAN_ID     = B.PLAN_ID
        AND    A.FACTORY_ID     = B.FACTORY_ID
        AND    A.LINE_ID        = B.LINE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID
        AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        AND    B.RELEASE_DATE   = @v_plan_date             -- 당일 RELEASE 내역이 있으면 삭제 처리

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        -- PLAN_IN_QTY 로 PLAN_QTY 를 계산하고
        -- ( PLAN_QTY - ACTUAL_QTY ) 로 ORG_QTY, REMAIN_QTY 를 계산한다.
        -- 수율은 PLAN_DATE 기준으로 SCM_YIELD_M 을 참고하여 계산한다.
        UPDATE TH_MST_SCM_ORDER_STATUS_POST
        -- 2018.12.23 : 투입 수량 기준에서 완성 수량 기준으로 변경
        SET    TH_MST_SCM_ORDER_STATUS_POST.PLAN_IN_QTY = CEILING(A.PLAN_QTY / (CASE WHEN B.YIELD IS NULL  THEN 1
                                                                                WHEN B.YIELD <= 0     THEN 1
                                                                                WHEN B.YIELD >= 1     THEN 1
               ELSE B.YIELD
            END)
                     )
        FROM TH_MST_SCM_ORDER_STATUS_POST A
               LEFT OUTER JOIN SCM_YIELD_M B
                    ON    A.FACTORY_ID = B.FACTORY_ID
                    AND   A.OPERATION_ID = B.OPERATION_ID
                    AND   A.LINE_ID = B.LINE_ID
                    AND   A.ITEM_ID = B.ITEM_ID
                    AND   SUBSTRING(CONVERT(NVARCHAR, PLAN_DATE, 112), 1, 6) = B.MONTH
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id

        --LOG 생성
        SET @v_message = 'PLAN_IN_QTY : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE TH_MST_SCM_ORDER_STATUS_POST
        SET    TH_MST_SCM_ORDER_STATUS_POST.ORG_QTY  = CASE WHEN A.PLAN_QTY < ISNULL(A.ACTUAL_GOOD_QTY,0) THEN 0
                                                            ELSE A.PLAN_QTY - ISNULL(A.ACTUAL_GOOD_QTY,0)
                                                       END
        FROM   TH_MST_SCM_ORDER_STATUS_POST A
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id

        --LOG 생성
        SET @v_message = 'ORG_QTY : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


        -- 올림/내림처리는 계산 후 조정한다.
        UPDATE TH_MST_SCM_ORDER_STATUS_POST
        SET    TH_MST_SCM_ORDER_STATUS_POST.PLAN_QTY   = CEILING(A.PLAN_QTY)
             , TH_MST_SCM_ORDER_STATUS_POST.ORG_QTY    = CEILING(A.ORG_QTY)
             , TH_MST_SCM_ORDER_STATUS_POST.REMAIN_QTY = CEILING(A.ORG_QTY)
        FROM   TH_MST_SCM_ORDER_STATUS_POST A
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id

        --LOG 생성
        SET @v_message = 'REMAIN_QTY : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


        UPDATE TH_MST_SCM_ORDER_STATUS_POST
        -- 2018.12.23 : 투입 수량 기준에서 완성 수량 기준으로 변경
        SET    TH_MST_SCM_ORDER_STATUS_POST.PLAN_IN_QTY     = ( -- 최종 RELEASE 한 수량과 같다면 PLAN_IN_QTY 도 맞춘다.
                                                            CASE WHEN A.PLAN_QTY = B.PLAN_QTY AND ISNULL(A.ACTUAL_GOOD_QTY,0) = 0
                                                                 THEN B.PLAN_IN_QTY
                                                                 ELSE A.PLAN_IN_QTY
                                                            END
                                                          )
             , TH_MST_SCM_ORDER_STATUS_POST.IS_PREV_SCHEDULE = B.IS_PREV_SCHEDULE -- ( 20171012 ksjeon )TEST Target 하위 공정 계획 수립 여부
             , TH_MST_SCM_ORDER_STATUS_POST.TOP_ITEM_ID = ( CASE WHEN ISNULL(A.TOP_ITEM_ID, '-') = '-' THEN ISNULL(B.TOP_ITEM_ID,'-')
                                                            ELSE A.TOP_ITEM_ID
                                                       END  )
        FROM   TH_MST_SCM_ORDER_STATUS_POST A,
               (
                SELECT A.WORK_ORDER_ID, A.PLAN_DATE, A.START_TIME, A.END_TIME
                     , A.PLAN_QTY, A.PLAN_IN_QTY
                     , A.IS_PREV_SCHEDULE  -- ( 20171012 ksjeon )TEST Target 하위 공정 계획 수립 여부
                     , TOP_ITEM_ID
                FROM   FP_RELEASE_FIX_PLAN_H     A
                     , TH_MST_INSTANCE_RELEASE_LINE_POST B
                WHERE  A.INSTANCE_ID      = B.RELEASE_ID
            AND    A.INSTANCE_DATE    = B.RELEASE_DATE
                AND    A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
            AND  A.FACTORY_ID       = B.FACTORY_ID
             AND    A.LINE_ID          = B.LINE_ID
           AND    A.OPERATION_ID     = B.OPERATION_ID
                AND    A.ELECTRODE_TYPE   = B.ELECTRODE_TYPE
                AND    B.MASTER_ID        = @v_master_id
                AND    B.PLAN_ID          = @v_plan_id
               ) B
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id
        AND    A.WORK_ORDER_ID  = B.WORK_ORDER_ID

        --LOG 생성
        SET @v_message = 'PLAN_START_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
        
        INSERT INTO TH_MST_SCM_ORDER_STATUS_POST
              (
                INSTANCE_ID
              , FP_PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , WORK_ORDER_SPL_ID
              , WORK_ORDER_ID
              , DEMAND_ID
              , PRODUCTION_TYPE
              , ORDER_TYPE
              , ITEM_ID
              , TOP_ITEM_ID
              , OPERATION_ID
              , LINE_ID
              , ELECTRODE_TYPE
              , WORK_CENTER_ID
              , EQUIPMENT_ID
              , PLAN_DATE
              , PLAN_START_TIME
              , PLAN_END_TIME
              , PLAN_QTY
              , PLAN_IN_QTY
              , ACTUAL_START_TIME
              , ACTUAL_END_TIME
              , ACTUAL_QTY
              , ACTUAL_GOOD_QTY
              , ACTUAL_SCRAP_QTY
              , RUNNING_FLAG
              , WO_STATUS
              , ORG_QTY
              , REMAIN_QTY
              , BATCH_ORDER_ID
              , MARKET
              , LANE_QTY
              , FIX_EQUIPMENT_ID
              , ACTUAL_FLAG
              , IS_PREV_SCHEDULE
              , INSERT_ID
              , INSERT_TIME
              )
        SELECT @v_master_id      AS INSTANCE_ID
             , @v_plan_id        AS FP_PLAN_ID
             , C.COMPANY_ID
             , C.DIVISION_ID
             , C.SITE_ID
             , C.PLANT_ID
             , A.FACTORY_ID
             , A.WORK_ORDER_ID  AS WORK_ORDER_SPL_ID
             , A.WORK_ORDER_ID
             , A.WORK_ORDER_ID  AS DEMAND_ID
             , A.PRODUCTION_TYPE
             , CASE WHEN F.WO_FLAG = 'Y' THEN 'WO' ELSE 'MO' END AS ORDER_TYPE
             , A.ITEM_ID
             , A.TOP_ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.ELECTRODE_TYPE
             , E.WORK_CENTER_ID
             -- 2018.07.13 : 무등록 설비가 존재할 수 있음.. CELL / PACK 만 대상임.
             , A.EQUIPMENT_ID AS  EQUIPMENT_ID
             , A.PLAN_DATE
             , A.START_TIME
             , A.END_TIME
             , A.PLAN_QTY
             , A.PLAN_IN_QTY
             , NULL       AS ACTUAL_START_TIME
             , NULL       AS ACTUAL_END_TIME
             , 0          AS ACTUAL_QTY
             , 0          AS ACTUAL_GOOD_QTY
             , 0          AS ACTUAL_SCRAP_QTY
             , 'N'        AS RUNNING_FLAG
             , CASE WHEN FIX_TYPE = 'F' THEN 'OPEN'
                    WHEN FIX_TYPE = 'N' THEN 'OPEN'
                    WHEN FIX_TYPE = 'Y' THEN 'OPEN'
                    ELSE 'AMEND'
               END  AS WO_STATUS
             , A.PLAN_QTY         AS ORG_QTY
             , A.PLAN_QTY         AS REMAIN_QTY
             , A.BATCH_ORDER_ID
             , CASE WHEN A.MARKET IS NULL THEN 'D'
                    WHEN A.MARKET = ''    THEN 'D'
                    ELSE A.MARKET
               END  MARKET                            -- ## MARKET 정보 추가
   , 0                  AS LANE_QTY
             , A.EQUIPMENT_ID     AS FIX_EQUIPMENT_ID
             , A.ACTUAL_FLAG
             , A.IS_PREV_SCHEDULE
         , A.RELEASE_PLAN_ID  AS INSERT_ID
             , GETDATE()          AS INSERT_TIME
        FROM   (
                SELECT A.*
                FROM   FP_RELEASE_FIX_PLAN_H    A
                     , TH_MST_INSTANCE_RELEASE_LINE_POST B
                WHERE  B.MASTER_ID        = @v_master_id
                AND    B.PLAN_ID          = @v_plan_id
                AND    A.FACTORY_ID       = B.FACTORY_ID
                AND    A.LINE_ID          = B.LINE_ID
                AND    A.OPERATION_ID     = B.OPERATION_ID
                AND    A.ELECTRODE_TYPE   = B.ELECTRODE_TYPE
                AND    A.INSTANCE_ID      = B.RELEASE_ID
                AND    A.INSTANCE_DATE    = B.RELEASE_DATE
                AND    A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
                AND    B.RELEASE_DATE     = @v_plan_date           -- 당일 RELEASE 정보 참조
                AND    NOT EXISTS (
                                    SELECT 1
                                    FROM   TH_MST_SCM_ORDER_STATUS_POST X
                                    WHERE  X.INSTANCE_ID    = @v_master_id
                                    AND    X.FP_PLAN_ID     = @v_plan_id
                                    AND    X.WORK_ORDER_ID  = A.WORK_ORDER_ID
                                  )
               ) A
               LEFT OUTER JOIN SCM_EQUIPMENT_M E
                    ON    A.FACTORY_ID    = E.FACTORY_ID
                    AND   A.LINE_ID       = E.LINE_ID
                    AND   A.OPERATION_ID  = E.OPERATION_ID
                    AND   A.EQUIPMENT_ID  = E.EQUIPMENT_ID    -- LINE 계획 수립하는 경우에도 대표 EQUIPMENT_ID 가 I/F 되므로,, 이걸 쓴다.
             , SCM_FACTORY_M C
             , SCM_OPERATION_M F
        WHERE  A.FACTORY_ID    = C.FACTORY_ID
        AND    C.COMPANY_ID    = F.COMPANY_ID
        AND    C.DIVISION_ID   = F.DIVISION_ID
        AND    C.SITE_ID       = F.SITE_ID
        AND    A.OPERATION_ID  = F.OPERATION_ID

        --LOG 생성
        SET @v_message = 'MULTI-RELEASE (FIX) : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        -------------------------------------------------------------------------------------
        -- 2018.12.19 : TARGET - DIVISION 별 PRODUCTION_TYPE 에 등록되지 않은 것은 삭제 처리
        -------------------------------------------------------------------------------------
        /*
        BEGIN

          SET @v_table_name = 'TH_MST_SCM_ORDER_STATUS'

          DELETE FROM A
          FROM   TH_MST_SCM_ORDER_STATUS_POST A
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    A.FP_PLAN_ID       = @v_plan_id
          AND    NOT EXISTS (
                              SELECT 1
                              FROM   (
                                      SELECT B.SEGMENT1       AS DIVISION_ID
                                           , B.SEGMENT2       AS PRODUCTION_TYPE
                                      FROM   SY_SCM_SYS_LOOKUP_TYPE_M A
                                           , SY_SCM_SYS_LOOKUP_VALUE  B
                                      WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
                                      AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
                                      AND    A.ACTIVE_FLAG      = 'Y'
                                      AND    B.ACTIVE_FLAG      = 'Y'
                                      GROUP  BY B.SEGMENT1, B.SEGMENT2
                                     ) X
                              WHERE  X.DIVISION_ID      = A.DIVISION_ID
                              AND    X.PRODUCTION_TYPE  = A.PRODUCTION_TYPE
     )
          
        --LOG 생성
          SET @v_message = 'DIVISION_DEMAND_TYPE Not Exists : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
        
        END */

        --------------------------------------------------------------------
        -- 2018.04.03 : 외부 TEST 를 내부 TEST, S-TEST 로 변경
        --------------------------------------------------------------------
        BEGIN

          UPDATE A
          SET    A.PRODUCTION_TYPE = B.FP_PRODUCTION_TYPE
          FROM   TH_MST_SCM_ORDER_STATUS_POST A,
                 (
                  SELECT A.WORK_ORDER_ID, A.FP_PRODUCTION_TYPE
                  FROM   FP_RELEASE_FULL_PLAN_H A
                       , (
                          SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.DIVISION_ID, A.FACTORY_ID
                               , MIN(RELEASE_PLAN_ID) AS RELEASE_PLAN_ID
                          FROM   FP_RELEASE_PLAN_INFO_H A,
                                 (
                                  SELECT DIVISION_ID
                                       , FACTORY_ID
                                       , MAX(INSTANCE_DATE) AS INSTANCE_DATE
                                  FROM   FP_RELEASE_PLAN_INFO_H A
                                  WHERE  A.INSTANCE_ID = @v_master_id
                                  GROUP  BY DIVISION_ID, FACTORY_ID
                                 ) B
                          WHERE  A.INSTANCE_ID    = @v_master_id
                          AND    A.INSTANCE_DATE  = B.INSTANCE_DATE
                          AND    A.DIVISION_ID    = B.DIVISION_ID
                          AND    A.FACTORY_ID     = B.FACTORY_ID
                          GROUP  BY A.INSTANCE_ID, A.INSTANCE_DATE, A.DIVISION_ID, A.FACTORY_ID
                         ) B
                  WHERE  A.INSTANCE_ID = B.INSTANCE_ID
                  AND    A.INSTANCE_DATE = B.INSTANCE_DATE
                  AND    A.DIVISION_ID = B.DIVISION_ID
                  AND    A.FACTORY_ID = B.FACTORY_ID
                  AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID
                 ) B
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    A.FP_PLAN_ID       = @v_plan_id
          AND    A.WORK_ORDER_ID    = B.WORK_ORDER_ID
          AND    A.PRODUCTION_TYPE <> B.FP_PRODUCTION_TYPE
        
          --LOG 생성
          SET @v_message = 'FP_PRODUCTION_TYPE : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END
        
      END
      
      SET @v_table_name = 'FP_DAILY_INSTANCE_ORDER_STATUS'

      DELETE FROM FP_DAILY_INSTANCE_ORDER_STATUS
      WHERE  INSTANCE_ID = @v_master_id
      AND    FP_PLAN_ID  = @v_plan_id
      
      INSERT INTO FP_DAILY_INSTANCE_ORDER_STATUS
             (
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , WORK_ORDER_SPL_ID
             , WORK_ORDER_ID
             , DEMAND_ID
             , PRODUCTION_TYPE
             , ORDER_TYPE
             , ITEM_ID
             , TOP_ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , ELECTRODE_TYPE
             , WORK_CENTER_ID
             , EQUIPMENT_ID
             , PLAN_DATE
             , PLAN_START_TIME
             , PLAN_END_TIME
             , PLAN_QTY
             , PLAN_IN_QTY
             , ACTUAL_START_TIME
             , ACTUAL_END_TIME
             , ACTUAL_QTY
             , ACTUAL_GOOD_QTY
             , ACTUAL_SCRAP_QTY
 , RUNNING_FLAG
             , WO_STATUS
             , TOP_OPERATION_ITEM_ID
      , ORG_QTY
    , REMAIN_QTY
             , BATCH_ORDER_ID
             , FIX_TARGET_DATE
             , MARKET
             , LANE_QTY
             , FIX_EQUIPMENT_ID
             , ACTUAL_FLAG
             , IS_PREV_SCHEDULE -- ( 20171012 ksjeon )TEST Target 하위 공정 계획 수립 여부
             , INSERT_ID
             , INSERT_TIME
             )
      SELECT
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
  , WORK_ORDER_SPL_ID
             , WORK_ORDER_ID
             , DEMAND_ID
             , PRODUCTION_TYPE
             , ORDER_TYPE
             , ITEM_ID
             , TOP_ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , ELECTRODE_TYPE
             , WORK_CENTER_ID
             , EQUIPMENT_ID
             , PLAN_DATE
             , PLAN_START_TIME
             , PLAN_END_TIME
             , PLAN_QTY
             , PLAN_IN_QTY
             , ACTUAL_START_TIME
             , ACTUAL_END_TIME
             , ACTUAL_QTY
             , ACTUAL_GOOD_QTY
             , ACTUAL_SCRAP_QTY
             , RUNNING_FLAG
             , WO_STATUS
             , TOP_OPERATION_ITEM_ID
             , ORG_QTY
             , REMAIN_QTY
             , BATCH_ORDER_ID
             , FIX_TARGET_DATE
             , MARKET
             , LANE_QTY
             , FIX_EQUIPMENT_ID
             , ACTUAL_FLAG
             , IS_PREV_SCHEDULE -- ( 20171012 ksjeon )TEST Target 하위 공정 계획 수립 여부
             , INSERT_ID
             , INSERT_TIME
      FROM   TH_MST_SCM_ORDER_STATUS_POST
      WHERE  INSTANCE_ID = @v_master_id
      AND    FP_PLAN_ID  = @v_plan_id
      
      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
    
    END
    
    -------------------------------------------------------------------------------
    -- 2019.03.07 : OPEN W/O 처리 부분 ( TARGET_ELEC 에서 이 곳으로 이관 )
    -------------------------------------------------------------------------------
    BEGIN
    
      SET @v_table_name = 'TH_BUF_SCM_ACTUAL_WORK_ORDER'

      ------------------------------------------------------------------------------------
      -- 실시간 W/O 상태를 BUFFER 에 저장한다. - 시간단축을 위해
      ------------------------------------------------------------------------------------
      DELETE FROM TH_BUF_SCM_ACTUAL_WORK_ORDER
      WHERE  INSTANCE_ID      = @v_master_id
      AND    FP_PLAN_ID       = @v_plan_id
      AND    FACTORY_ID       = @v_factory_id
      
      DELETE FROM TH_BUF_SCM_ACTUAL_WORK_ORDER WHERE INSERT_TIME < GETDATE() - 7
      
      INSERT INTO TH_BUF_SCM_ACTUAL_WORK_ORDER 
           (
             INSTANCE_ID
           , FP_PLAN_ID
           , FACTORY_ID
           , PLAN_GROUP_ID
           , WORK_ORDER_ID
           , ATTRIBUTE8
           , ATTRIBUTE9
           , INSERT_TIME
           )
      SELECT @v_master_id               AS INSTANCE_ID
           , @v_plan_id                 AS FP_PLAN_ID
           , @v_factory_id              AS FACTORY_ID
           , '-'                        AS PLAN_GROUP_ID
           , A.WORK_ORDER_ID
           , A.ATTRIBUTE8
           , ISNULL(A.ATTRIBUTE9, 'N')  AS ATTRIBUTE9
           , GETDATE()                  AS INSERT_TIME
      FROM   FP_MES_PRODUCTION_PLAN_M A WITH(NOLOCK)
      WHERE  1=1
      AND    (
                A.ATTRIBUTE8 IS NOT NULL              -- 투입 시간
                OR
                ISNULL(A.ATTRIBUTE9, 'N') = 'Y'       -- CLOSE FLAG
             )
      AND    A.FACTORY_ID = @v_factory_id

      --LOG 생성
      SET @v_message = 'ATTRIBUTE8 IS NOT NULL : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
    SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


      ------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------
    
      SET @v_table_name = 'FP_DAILY_INSTANCE_ORDER_STATUS'

      ------------------------------------------------------------------------------------
      -- 실시간 W/O 상태를 UPDATE 한다.
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS    = ( CASE WHEN B.ATTRIBUTE9 = 'Y'                THEN 'CANCEL'
                                                                            ELSE 'OPEN'
                                END  )
           , A.ACTUAL_FLAG  = ( CASE WHEN B.ATTRIBUTE8 IS NOT NULL          THEN 'Y'
                                     WHEN ISNULL(A.ACTUAL_GOOD_QTY, 0) > 0  THEN 'Y'
                                                                            ELSE 'N'
                                END  )
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
             LEFT OUTER JOIN TH_BUF_SCM_ACTUAL_WORK_ORDER B
                  ON    B.INSTANCE_ID   = A.INSTANCE_ID
                  AND   B.FP_PLAN_ID    = A.FP_PLAN_ID
                  AND   B.WORK_ORDER_ID = A.WORK_ORDER_ID
      WHERE  A.INSTANCE_ID      = @v_master_id
      AND    A.FP_PLAN_ID       = @v_plan_id
      AND    A.FACTORY_ID       = @v_factory_id
      AND    A.WO_STATUS        IN ( 'OPEN', 'RUN', 'CANCEL' )

      --LOG 생성
      SET @v_message = 'WO_STATUS = OPEN / ACTUAL_FLAG = Y/N : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      ------------------------------------------------------------------------------------
      -- TOP ITEM ID 가 존재하지 않으면 CANCEL 시킨다.
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS = 'CANCEL'
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
      WHERE  A.INSTANCE_ID      = @v_master_id
      AND    A.FP_PLAN_ID       = @v_plan_id
      AND    A.FACTORY_ID       = @v_factory_id
      AND    A.WO_STATUS        IN ( 'OPEN', 'RUN' )
      AND    ISNULL(A.TOP_ITEM_ID, '-') = '-'

      --LOG 생성
      SET @v_message = 'WO_STATUS = CANCEL / TOP_ITEM_ID = - : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      ------------------------------------------------------------------------------------
      -- 잔여 수량이 0 이하 일 경우도 CANCEL 시킨다.
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS = 'CANCEL'
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
      WHERE  A.INSTANCE_ID      = @v_master_id
      AND    A.FP_PLAN_ID       = @v_plan_id
      AND    A.FACTORY_ID       = @v_factory_id
      AND    A.WO_STATUS        IN ( 'OPEN', 'RUN' )
      AND    A.PLAN_QTY - ISNULL(A.ACTUAL_GOOD_QTY, 0) <= 0
    
      --LOG 생성
      SET @v_message = 'WO_STATUS = CANCEL / PLAN_QTY <= 0 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      ------------------------------------------------------------------------------------
      -- 2일 이전 WORK ORDER 는 CANCEL
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS    = 'CANCEL'
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
           , (
              SELECT A.WORK_ORDER_ID, MIN(B.PLAN_DATE) AS PLAN_DATE
              FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
                     LEFT OUTER JOIN FP_RELEASE_FIX_PLAN_H B
                          ON    B.INSTANCE_ID     = A.INSTANCE_ID
                          AND   B.INSTANCE_DATE  <= CONVERT(NVARCHAR, @v_plan_date, 112)
                          AND   B.WORK_ORDER_ID   = A.WORK_ORDER_ID
              WHERE  A.INSTANCE_ID  = @v_master_id
              AND    A.FP_PLAN_ID   = @v_plan_id
              AND    A.FACTORY_ID   = @v_factory_id
              AND    A.WO_STATUS    IN ('RUN','OPEN')
              GROUP  BY A.WORK_ORDER_ID
              HAVING MIN(B.PLAN_DATE) < DATEADD(DAY, -2, @v_plan_date)
             ) B
      WHERE  A.INSTANCE_ID    = @v_master_id
      AND    A.FP_PLAN_ID     = @v_plan_id
      AND    A.WORK_ORDER_ID  = B.WORK_ORDER_ID

      --LOG 생성
      SET @v_message = 'WO_STATUS = CANCEL / OPEN WORK (D-3) : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      ------------------------------------------------------------------------------------
      -- ACTUAL 이 아니면서 동일일자에 동일 유형이 2개이상이면 1개는 남기고 나머진 CANCEL
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS    = 'CANCEL'
      FROM   (
              SELECT A.WORK_ORDER_ID
                   , A.FACTORY_ID
                   , A.LINE_ID
                   , A.OPERATION_ID
                   , A.ELECTRODE_TYPE
                   , A.EQUIPMENT_ID
                   , A.ITEM_ID
                   , A.PRODUCTION_TYPE
                   , A.MARKET
                   , A.PLAN_DATE
                   , A.WO_STATUS
                   , DENSE_RANK() OVER (PARTITION BY A.PLAN_DATE          -- 동일 일자
                   								   , A.PLAN_START_TIME		--동일 shift		-- (D.201130 ~ R.0105) shift 조건 추가
                                                   , A.FACTORY_ID         -- 동일 동
                                                   , A.LINE_ID            -- 동일 라인
                                                   , A.OPERATION_ID       -- 동일 OPERATION
                                                   , A.ELECTRODE_TYPE     -- 동일 TYPE
                                                   , A.EQUIPMENT_ID       -- 동일 설비
                                                   , A.TOP_ITEM_ID        -- 동일 TOP_ITEM
                                                   , A.ITEM_ID            -- 동일 ITEM
                                                   , A.PRODUCTION_TYPE    -- 동일 PRODUCTION_TYPE
                                                   , A.MARKET             -- 동일 MARKET
                                        ORDER     BY A.WORK_ORDER_ID DESC
                                       ) AS DESC_SEQ                    -- 가장 최근 WORK 이 1번
              FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
              WHERE  A.INSTANCE_ID  = @v_master_id
              AND    A.FP_PLAN_ID   = @v_plan_id
              AND    A.FACTORY_ID   = @v_factory_id
              AND    A.ACTUAL_FLAG  = 'N'
              AND    A.WO_STATUS    IN ('RUN','OPEN')
             ) A
      WHERE  A.DESC_SEQ > 1

      --LOG 생성
      SET @v_message = 'WO_STATUS = CANCEL / NOT ACTUAL WORK : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      ------------------------------------------------------------------------------------
      -- 2019.01.04 : RELEASE 구간 밖의 OPEN WO 취소 로직
      ------------------------------------------------------------------------------------
      UPDATE A
      SET    A.WO_STATUS    = 'CANCEL'
      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id
      AND    A.FACTORY_ID   = @v_factory_id
      AND    A.PLAN_DATE    > @v_confirm_date
      AND    A.WO_STATUS IN ( 'OPEN', 'RUN' )

      --LOG 생성
      SET @v_message = 'WO_STATUS = CANCEL / PLAN_DATE > @v_confirm_date : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      

    END
    
    BEGIN
    
      DELETE FP_AMEND_DAILY_PLAN_R
      WHERE INSTANCE_ID = @v_master_id
      AND   FP_PLAN_ID = @v_plan_id
      
      SET @v_table_name = 'FP_AMEND_DAILY_PLAN_R'
      
      INSERT INTO FP_AMEND_DAILY_PLAN_R
            (
             INSTANCE_ID
            ,FP_PLAN_ID
            ,COMPANY_ID
            ,DIVISION_ID
            ,SITE_ID
            ,PLANT_ID
            ,FACTORY_ID
            ,LOCATION
            ,OPERATION_ID
            ,LINE_ID
            ,ELECTRODE_TYPE
            ,EQUIPMENT_ID
            ,PLAN_DATE
            ,TOP_ITEM_ID
            ,ITEM_ID
            ,PRODUCTION_TYPE
            ,MARKET
            ,CUSTOMER_ID
            ,SEQ
            ,PLAN_IN_QTY_BATCH
            ,PLAN_IN_QTY
            ,PLAN_IN_QTY_M
            ,PLAN_IN_QTY_JR
            ,PLAN_IN_QTY_CELL
            ,PLAN_OUT_QTY_BATCH
            ,PLAN_OUT_QTY
            ,PLAN_OUT_QTY_M
            ,PLAN_OUT_QTY_JR
            ,PLAN_OUT_QTY_CELL
            ,ADJUST_IN_QTY_BATCH
            ,ADJUST_IN_QTY
            ,ADJUST_IN_QTY_M
            ,ADJUST_IN_QTY_JR
            ,ADJUST_IN_QTY_CELL
            ,ADJUST_OUT_QTY_BATCH
            ,ADJUST_OUT_QTY
            ,ADJUST_OUT_QTY_M
            ,ADJUST_OUT_QTY_JR
            ,ADJUST_OUT_QTY_CELL
            ,TOTAL_WORKING_TIME
            ,INSERT_ID
            ,INSERT_TIME
            ,UPDATE_ID
            ,UPDATE_TIME
            )
      SELECT  INSTANCE_ID
      			, FP_PLAN_ID
      			, COMPANY_ID
      			, DIVISION_ID
      			, SITE_ID
      			, PLANT_ID
      			, FACTORY_ID
      			, '-' AS LOCATION
      			, OPERATION_ID
      			, LINE_ID
      			, ELECTRODE_TYPE
      			, EQUIPMENT_ID
      			, PLAN_DATE
      			, TOP_ITEM_ID
      			, ITEM_ID
      			, PRODUCTION_TYPE
      			, MARKET
      			, '-' AS CUSTOMER_ID
      			, SEQ
      			, SUM(BATCH_IN_QTY )AS PLAN_IN_QTY_BATCH
      			, SUM(PLAN_IN_QTY) AS PLAN_IN_QTY
      			, SUM(ROLL_IN_QTY )AS PLAN_IN_QTY_M
      			, SUM(JR_IN_QTY )AS  PLAN_IN_QTY_JR
      			, SUM(CELL_IN_QTY )AS PLAN_IN_QTY_CELL
      			, SUM(BATCH_OUT_QTY ) AS PLAN_OUT_QTY_BATCH
      			, SUM(PLAN_QTY ) AS PLAN_OUT_QTY
      			, SUM(ROLL_OUT_QTY ) AS PLAN_OUT_QTY_M
      			, SUM(JR_OUT_QTY ) AS PLAN_OUT_QTY_JR
      			, SUM(CELL_OUT_QTY ) AS PLAN_OUT_QTY_CELL
      			, SUM(BATCH_IN_QTY ) AS ADJUST_IN_QTY_BATCH
      			, SUM(PLAN_IN_QTY ) AS ADJUST_IN_QTY
      			, SUM(ROLL_IN_QTY ) AS ADJUST_IN_QTY_M
      			, SUM(JR_IN_QTY  ) AS ADJUST_IN_QTY_JR
      			, SUM(CELL_IN_QTY ) AS ADJUST_IN_QTY_CELL
      			, SUM(BATCH_OUT_QTY ) AS ADJUST_OUT_QTY_BATCH
      			, SUM(PLAN_QTY) AS ADJUST_OUT_QTY
      			, SUM(ROLL_OUT_QTY) AS ADJUST_OUT_QTY_M
      			, SUM(JR_OUT_QTY) AS ADJUST_OUT_QTY_JR
      			, SUM(CELL_OUT_QTY) AS ADJUST_OUT_QTY_CELL
      			, SUM(TOTAL_WORKING_TIME) AS TOTAL_WORKING_TIME
      			, @v_proc_name AS INSERT_ID
      			, GETDATE() AS INSERT_TIME
      			, @v_proc_name AS UPDATE_ID
      			, GETDATE() AS UPDATE_TIME
 FROM  FP_DAILY_PRODUCTION_PLAN_R
      WHERE INSTANCE_ID = @v_master_id
      AND		FP_PLAN_ID = @v_plan_id 
      GROUP BY INSTANCE_ID
      			, FP_PLAN_ID
      			, COMPANY_ID
      			, DIVISION_ID
      			, SITE_ID
      			, PLANT_ID
      			, FACTORY_ID
      			, OPERATION_ID
      			, LINE_ID
      			, ELECTRODE_TYPE
      			, EQUIPMENT_ID
      			, PLAN_DATE
      			, TOP_ITEM_ID
      			, ITEM_ID
      			, PRODUCTION_TYPE
      			, MARKET
      			, SEQ
      
      SET @n_row_count = @@ROWCOUNT
        
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
     
      SET @v_table_name = 'TH_BUF_SCM_DAILY_PLAN_FACTORY'
      
      DELETE FROM A
      FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY A
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id
      AND    A.FACTORY_ID   = @v_factory_id
      
      
      
      -- (D.201130 ~ R.0105) FP_AMEND_DAILY_PLAN_R -> FP_DAILY_PRODUCTION_PLAN_R 변경 start/end 를 가져올 수 없어서
      INSERT INTO TH_BUF_SCM_DAILY_PLAN_FACTORY
             (
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , WORK_ORDER_SPL_ID
             , WORK_ORDER_ID
             , BATCH_ORDER_ID
             , BIN_ORDER_ID
             , ORDER_TYPE
             , SCP_TARGET_ID
             , DEMAND_ID
             , ITEM_ID
             , LANE_QTY
             , TOP_ITEM_ID
             , TOP_WORK_ORDER_ID
             , LINE_ID
             , OPERATION_ID
             , ELECTRODE_TYPE
             , WORK_CENTER_ID
             , EQUIPMENT_ID
             , PLAN_DATE
             , PLAN_DATE_SEQ
             , START_TIME
             , END_TIME
             , ORG_PLAN_QTY
             , PLAN_QTY
             , PLAN_IN_QTY
             , ROLL_IN_QTY
             , ROLL_OUT_QTY
             , JR_IN_QTY
             , JR_OUT_QTY
             , CELL_IN_QTY
             , CELL_OUT_QTY
             , BATCH_QTY
             , BATCH_IN_QTY
             , ITEM_UOM
             , PRODUCTION_TYPE
             , BOM_VERSION_ID
             , SLIT_PLANT_ID
             , MARKET
             , MFG_WEEK
             , DEMAND_DIVISION_ID
             , PLAN_GROUP_ID
             , TOTAL_WORKING_TIME
             , SETUP_TIME
             , FULL_CLEANING_FLAG
             , MODEL_TYPE_CHANGE_FLAG
             , INSERT_ID
             , INSERT_TIME
             , TOTAL_BATCH
             , CALC_TYPE
             , CALC_VERSION
             , PIG_CLEANING_FLAG
             , SETUP_COLOR_CODE
             )
        SELECT 
               A.INSTANCE_ID
             , A.FP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.WORK_ORDER_ID    AS WORK_ORDER_SPL_ID
             , A.WORK_ORDER_ID
             , '-'                AS BATCH_ORDER_ID
             , '-'                AS BIN_ORDER_ID
             , A.ORDER_TYPE
             , A.WORK_ORDER_ID    AS SCP_TARGET_ID
             , A.WORK_ORDER_ID    AS DEMAND_ID
             , A.ITEM_ID
             , 0                  AS LANE_QTY
             , A.TOP_ITEM_ID
             , A.WORK_ORDER_ID    AS TOP_WORK_ORDER_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELECTRODE_TYPE
             , A.WORK_CENTER_ID
             , A.EQUIPMENT_ID
             , A.PLAN_DATE
             , A.PLAN_DATE_SEQ
             --, DATEADD(MINUTE, @n_day_diff + A.PLAN_DATE_SEQ, A.PLAN_DATE) AS START_TIME
 --, DATEADD(MINUTE, @n_day_diff + 1440,            A.PLAN_DATE) AS END_TIME
             , A.START_TIME		-- (D.201130 ~ R.0105) table 정보로 넣어준다. 
             , A.END_TIME 		-- (D.201130 ~ R.0105)
             , A.PLAN_QTY         AS ORG_PLAN_QTY
             , A.PLAN_QTY
             , A.PLAN_IN_QTY
             , A.ROLL_IN_QTY
             , A.ROLL_OUT_QTY
             , A.JR_IN_QTY
             , A.JR_OUT_QTY
             , A.CELL_IN_QTY
             , A.CELL_OUT_QTY
             , A.BATCH_OUT_QTY  -- (D.201130 ~ R.0105)
             , A.BATCH_IN_QTY
             , B.ITEM_UOM
             , A.PRODUCTION_TYPE
             , ''                 AS BOM_VERSION_ID
             , A.PLANT_ID         AS SLIT_PLANT_ID
             , A.MARKET
             , C.WEEK             AS MFG_WEEK
             , A.DIVISION_ID      AS DEMAND_DIVISION_ID
             , A.PLAN_GROUP_ID
             , A.TOTAL_WORKING_TIME
             , A.SETUP_TIME
             , A.FULL_CLEANING_FLAG
             , A.MODEL_TYPE_CHANGE_FLAG
             , @v_proc_name       AS INSERT_ID
             , GETDATE()          AS INSERT_TIME
             , A.TOTAL_BATCH
             , A.CALC_TYPE
             , A.CALC_VERSION
             , A.PIG_CLEANING_FLAG
             , A.SETUP_COLOR_CODE
        FROM   (
		                SELECT A.*
			                     , ORDER_TYPE + @v_instance_code
			                                  + @v_order_date_code
			                                  + A.ERP_OPERATION_ID
			                                  + '#'
			                                  + @v_instance_sub_code
			                                  + '#'
			                                  + @v_factory_id
			                                  + '#'
			                                  + SUBSTRING(A.FP_PLAN_ID, CHARINDEX('-', A.FP_PLAN_ID, CHARINDEX('-', A.FP_PLAN_ID)+1)+1, 9)
			                                  + '#'
			                                  + ( CASE WHEN ORDER_SEQ < 10 THEN '000'
			                                           WHEN ORDER_SEQ < 100 THEN '00'
			                                           WHEN ORDER_SEQ < 1000 THEN '0'
			                                                                  ELSE ''
			                                      END  
			                                    )
			                                  + CONVERT(NVARCHAR, A.ORDER_SEQ)
			                       AS WORK_ORDER_ID
		                FROM   (
					                        SELECT DISTINCT 
					                               A.INSTANCE_ID
					                             , A.FP_PLAN_ID
					                             , A.COMPANY_ID
					                             , A.DIVISION_ID
					                             , A.SITE_ID
					                             , A.PLANT_ID
					                             , A.FACTORY_ID
					                             , CASE WHEN B.WO_FLAG = 'Y' THEN 'W' ELSE 'M' END AS ORDER_TYPE
					                             , A.ITEM_ID
					                             , A.TOP_ITEM_ID
					                             , A.LINE_ID
					                             , A.OPERATION_ID
					                             , A.ELECTRODE_TYPE
					                             , C.WORK_CENTER_ID
					                             , A.EQUIPMENT_ID
					                             , A.PLAN_DATE
					                             , ISNULL(A.SEQ, 1)             AS PLAN_DATE_SEQ
					                             , PLAN_QTY		--(D.201130 ~ R.0105)
					                             , PLAN_IN_QTY	--(D.201130 ~ R.0105)
					                             , ROLL_IN_QTY	--(D.201130 ~ R.0105)	
					                             , ROLL_OUT_QTY	--(D.201130 ~ R.0105)		
					                             , JR_IN_QTY	--(D.201130 ~ R.0105)	
					                             , JR_OUT_QTY	--(D.201130 ~ R.0105)	
					                             , CELL_IN_QTY	--(D.201130 ~ R.0105)	
					     , CELL_OUT_QTY	--(D.201130 ~ R.0105)
					                             , BATCH_OUT_QTY	--(D.201130 ~ R.0105)
					                             , BATCH_IN_QTY	--(D.201130 ~ R.0105)
					                             , A.PRODUCTION_TYPE
					                    , A.MARKET
					                             , B.ERP_OPERATION_ID
					                             , D.MODEL_TYPE AS PLAN_GROUP_ID
					                             , A.TOTAL_WORKING_TIME
					              				 , 0 AS SETUP_TIME	 --A.SETUP_TIME	--(D.201130 ~ R.0105) 해당 정보 없어서 0으로
					                             , A.FULL_CLEANING_FLAG
					                             , A.MODEL_TYPE_CHANGE_FLAG
					                             , A.TOTAL_BATCH
					                             , A.CALC_TYPE
					                             , A.CALC_VERSION
					                             , A.PIG_CLEANING_FLAG
					                             , A.SETUP_COLOR_CODE
					                             , DENSE_RANK() OVER (PARTITION BY B.ERP_OPERATION_ID
							                                                  ORDER     BY A.PLAN_DATE
							                                                  					, A.START_TIME		--(D.201130 ~ R.0105) SHIFT 별 Seq 발췌위해 추가
									                                							, A.FACTORY_ID
									                                                             , A.LINE_ID
									                                                             --, A.LOCATION		--(D.201130 ~ R.0105) 해당정보 없어 제외
									                                                             , A.OPERATION_ID
									                                                             , A.ELECTRODE_TYPE
									                                                             , A.EQUIPMENT_ID
									                                                             , A.SEQ
									                                                             , A.ITEM_ID
									                                                             , A.TOP_ITEM_ID
									                                                             , A.PRODUCTION_TYPE
									                                                             , A.MARKET
					                                                             ) AS ORDER_SEQ
													, START_TIME	--(D.201130 ~ R.0105)
													, END_TIME	--(D.201130 ~ R.0105)
					                        FROM   FP_DAILY_PRODUCTION_PLAN_R  A  WITH(NOLOCK)	--(D.201130 ~ R.0105)
						                             , SCM_OPERATION_M        B
						                             , SCM_EQUIPMENT_M        C
						                             , SCM_LINE_M             D
					                        WHERE  A.INSTANCE_ID    = @v_master_id
					                        AND    A.FP_PLAN_ID     = @v_plan_id
					                        AND    A.FACTORY_ID     = @v_factory_id
					                        AND    A.PLAN_DATE     >= @v_plan_date
					                        AND    A.PLAN_QTY > 0					--(D.201130 ~ R.0105)
					                        AND    A.COMPANY_ID     = B.COMPANY_ID
					                        AND    A.DIVISION_ID    = B.DIVISION_ID
					                        AND    A.SITE_ID        = B.SITE_ID
					                        AND    A.OPERATION_ID   = B.OPERATION_ID
					                        AND    A.FACTORY_ID     = C.FACTORY_ID
					                        AND    A.OPERATION_ID   = C.OPERATION_ID
					                        AND    A.EQUIPMENT_ID   = C.EQUIPMENT_ID
					                        AND    A.FACTORY_ID     = D.FACTORY_ID
					                        AND    A.LINE_ID        = D.LINE_ID
					                        AND    A.OPERATION_ID   = D.OPERATION_ID
					                        AND    A.ELECTRODE_TYPE = D.ELECTRODE_TYPE
					                        AND    D.ACTIVE_FLAG = 'Y'
                      		 ) A
               ) A
             , SCM_ITEM_M B
             , SCM_SYS_CALENDAR_M C
        WHERE  A.COMPANY_ID  = B.COMPANY_ID
  AND    A.DIVISION_ID = B.DIVISION_ID
        AND    A.SITE_ID     = B.SITE_ID
        AND A.ITEM_ID     = B.ITEM_ID
        AND    A.PLAN_DATE   = C.DATE_ID
        
        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        UPDATE A
        SET    A.LANE_QTY = B.LANE_QTY
        FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY  A
             , SCM_ITEM_LINE_ASSIGN_M         B
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id
        AND    A.FACTORY_ID     = @v_factory_id
        AND    A.COMPANY_ID     = B.COMPANY_ID
        AND    A.DIVISION_ID    = B.DIVISION_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.PLANT_ID       = B.PLANT_ID
        AND    A.ITEM_ID        = B.ITEM_ID
        AND    A.FACTORY_ID     = B.FACTORY_ID
        AND    A.LINE_ID        = B.LINE_ID
    AND    A.OPERATION_ID   = B.OPERATION_ID
        AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        AND    B.MONTH          = CONVERT(NVARCHAR(6), A.PLAN_DATE, 112)          

        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = 'LANE_QTY : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
        -- COATER 계획과 같은 로직으로 확정Mapping
        BEGIN
          
          SET @n_row_count  = 0
          SET @v_table_name = 'C_POST_WO_PEGGING'

          DECLARE               -- 커서로 받을 변수
                  @C_COAT_FACTORY_ID        NVARCHAR(30)
                , @C_COAT_LINE_ID           NVARCHAR(30)
                , @C_COAT_OPERATION_ID      NVARCHAR(30)
                , @C_COAT_EQUIPMENT_ID      NVARCHAR(30)
                , @C_COAT_ITEM_ID           NVARCHAR(150)
                , @C_COAT_PRODUCTION_TYPE   NVARCHAR(30)
                , @C_COAT_MARKET            NVARCHAR(30)
                , @C_COAT_PLAN_DATE         DATE
                , @C_COAT_SEQ               Integer
                , @C_COAT_CNT               Integer
                , @C_COAT_WORK_ORDER_ID     NVARCHAR(30)
                , @C_COAT_BATCH_ORDER_ID    NVARCHAR(30)
                , @C_COAT_ORG_QTY           Numeric(20,10)
                ------------------------------------------
                , @C_COAT_RATE              Numeric(20,10)
                , @C_COAT_ORDER_ID          NVARCHAR(30)
                , @C_COAT_BATCH_ROUND_SITE  Integer
          BEGIN
            
            SELECT @C_COAT_BATCH_ROUND_SITE = ISNULL(CONVERT(Integer, MAX(ATTRIBUTE14)), 2)
            FROM   SCM_SYS_LOOKUP_VALUE
            WHERE  LOOKUP_TYPE_CODE = 'INSTANCE_ID'
            AND    SEGMENT1         = @v_master_id
                 
            DECLARE C_COAT_WO_PEGGING CURSOR FOR
              SELECT A.FACTORY_ID
                   , A.LINE_ID
                   , A.OPERATION_ID
                   , A.EQUIPMENT_ID
                   , A.ITEM_ID
                   , A.PRODUCTION_TYPE
                   , A.MARKET
                   , A.PLAN_DATE
                   , A.SEQ
                   , A.CNT
                   , A.WORK_ORDER_ID
                   , A.BATCH_ORDER_ID
                   , A.ORG_QTY
              FROM   (
                      SELECT A.FACTORY_ID
                           , A.LINE_ID
                           , A.OPERATION_ID
                           , A.EQUIPMENT_ID
                           , A.ITEM_ID
                           , A.PRODUCTION_TYPE
                           , A.MARKET
                       , CASE WHEN CONVERT(DATE, A.PLAN_DATE) < @v_plan_date THEN @v_plan_date
                                     ELSE CONVERT(DATE, A.PLAN_DATE)
     END  AS PLAN_DATE
                           , A.WORK_ORDER_ID
         , A.BATCH_ORDER_ID
                           , A.ORG_QTY
                           , A.ACTUAL_FLAG
                           , DENSE_RANK()  OVER ( PARTITION BY A.FACTORY_ID
                                                             , A.LINE_ID
                                                             , A.OPERATION_ID
                                                             , A.EQUIPMENT_ID
                                                             , A.ITEM_ID
                                                             , A.PRODUCTION_TYPE
                                                             , A.MARKET
                                                             , CASE WHEN CONVERT(DATE, A.PLAN_DATE) < @v_plan_date THEN @v_plan_date
                       ELSE CONVERT(DATE, A.PLAN_DATE)
        END
                                                  ORDER     BY A.PLAN_START_TIME
                                                             , A.WORK_ORDER_ID ) AS SEQ
                           , COUNT(1)      OVER ( PARTITION BY A.FACTORY_ID
                                                             , A.LINE_ID
                                                             , A.OPERATION_ID
                                               , A.EQUIPMENT_ID
                                                             , A.ITEM_ID
                                                             , A.PRODUCTION_TYPE
                                                             , A.MARKET
                                                             , CASE WHEN CONVERT(DATE, A.PLAN_DATE) < @v_plan_date THEN @v_plan_date
                                                                                                                   ELSE CONVERT(DATE, A.PLAN_DATE)
                                                               END  ) AS CNT
                           ,  DENSE_RANK() OVER (PARTITION BY FACTORY_ID
                                                     , LINE_ID
                                                     , OPERATION_ID
                                                     , ITEM_ID
                                                     , CASE WHEN PLAN_DATE < @v_plan_date THEN @v_plan_date 
                                                                                          ELSE PLAN_DATE 
                                                       END 
                                          ORDER     BY WORK_ORDER_ID) AS WO_ASC    
                           ,  DENSE_RANK() OVER (PARTITION BY FACTORY_ID
                                                     , LINE_ID
                                                     , OPERATION_ID
                                                     , ITEM_ID
                                                     , CASE WHEN PLAN_DATE < @v_plan_date THEN @v_plan_date 
                                                                                          ELSE PLAN_DATE 
                                                       END 
                                          ORDER     BY WORK_ORDER_ID DESC) AS WO_DESC               
                      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
                      WHERE  A.INSTANCE_ID  = @v_master_id
                      AND    A.FP_PLAN_ID   = @v_plan_id
                      AND    A.FACTORY_ID   = @v_factory_id
                      AND    A.ORG_QTY      > 0
                      AND    A.WO_STATUS    IN ( 'OPEN', 'RUN' )
                     ) A
              ORDER  BY
                     A.FACTORY_ID
                   , A.LINE_ID
          , A.OPERATION_ID
                   , A.EQUIPMENT_ID
                   , A.ITEM_ID
                   , A.PRODUCTION_TYPE
              , A.MARKET
                   , A.PLAN_DATE
                   , CASE WHEN ACTUAL_FLAG = 'Y' THEN WO_DESC  ELSE A.SEQ  END
                   , A.SEQ
          
          
          OPEN C_COAT_WO_PEGGING
            
            WHILE 1 = 1
            BEGIN
              
              FETCH C_COAT_WO_PEGGING
              INTO  @C_COAT_FACTORY_ID
                  , @C_COAT_LINE_ID
                  , @C_COAT_OPERATION_ID
                  , @C_COAT_EQUIPMENT_ID
                  , @C_COAT_ITEM_ID
                  , @C_COAT_PRODUCTION_TYPE
                  , @C_COAT_MARKET
                  , @C_COAT_PLAN_DATE
                  , @C_COAT_SEQ
                  , @C_COAT_CNT
                  , @C_COAT_WORK_ORDER_ID
                  , @C_COAT_BATCH_ORDER_ID
                  , @C_COAT_ORG_QTY
            
              IF @@FETCH_STATUS <> 0          -- FETCH 레코드 없으면 LOOP 탈출
                BREAK
          
              SET @C_COAT_RATE = 0.0
   
              SELECT TOP 1
                     @C_COAT_RATE = CASE WHEN @C_COAT_ORG_QTY > PLAN_QTY THEN 1.0
                                         ELSE @C_COAT_ORG_QTY / PLAN_QTY
                                    END
                   , @C_COAT_ORDER_ID = WORK_ORDER_ID
              FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY
              WHERE  INSTANCE_ID        = @v_master_id
              AND  FP_PLAN_ID         = @v_plan_id
              AND    FACTORY_ID         = @C_COAT_FACTORY_ID
              AND    LINE_ID            = @C_COAT_LINE_ID
              AND    OPERATION_ID       = @C_COAT_OPERATION_ID
              AND    EQUIPMENT_ID       = @C_COAT_EQUIPMENT_ID
              AND    ITEM_ID            = @C_COAT_ITEM_ID
              AND    PRODUCTION_TYPE    = @C_COAT_PRODUCTION_TYPE
              AND    MARKET             = @C_COAT_MARKET
              AND    PLAN_DATE          = @C_COAT_PLAN_DATE
              AND    FIX_WORK_ORDER_ID  IS NULL
              AND    PLAN_QTY           > 0
              ORDER  BY PLAN_DATE_SEQ, START_TIME	--(D.201130 ~ R.0105) order by 순서 조정
              
              IF @C_COAT_RATE > 0.0
              BEGIN

               -- IF @C_COAT_SEQ = @C_COAT_CNT      --(D.201130 ~ R.0105) 1일 1WORK 에 의해 맨 마지막 WO 는 그냥 전체 할당함.
               --   SET @C_COAT_RATE = 1.0
                
                IF @C_COAT_RATE < 1.0
                BEGIN
          
                  INSERT INTO TH_BUF_SCM_DAILY_PLAN_FACTORY
                       (
                         INSTANCE_ID
                       , FP_PLAN_ID
                       , COMPANY_ID
                       , DIVISION_ID
                       , SITE_ID
                       , PLANT_ID
                       , FACTORY_ID
                       , WORK_ORDER_SPL_ID
                       , WORK_ORDER_ID
                       , FIX_WORK_ORDER_ID
                       , BATCH_ORDER_ID
                       , BIN_ORDER_ID
                       , ORDER_TYPE
                       , SCP_TARGET_ID
                       , DEMAND_ID
                       , ITEM_ID
                       , LANE_QTY
                       , TOP_ITEM_ID
                       , TOP_WORK_ORDER_ID
                       , LINE_ID
                       , OPERATION_ID
                       , ELECTRODE_TYPE
                       , WORK_CENTER_ID
                       , EQUIPMENT_ID
                       , PLAN_DATE
                       , PLAN_DATE_SEQ
                       , FIX_WORK_SEQ
                       , START_TIME
                       , END_TIME
                       , ORG_PLAN_QTY
                       , PLAN_QTY
                       , PLAN_IN_QTY
                       , ITEM_UOM
                       , ROLL_IN_QTY
                       , ROLL_OUT_QTY
                       , JR_IN_QTY
                       , JR_OUT_QTY
                       , CELL_IN_QTY
				   , CELL_OUT_QTY
                       , BATCH_QTY
          , BATCH_IN_QTY
      , BATCH_SUM_QTY
                       , FIX_TYPE
                       , PRODUCTION_TYPE
                  , BOM_VERSION_ID
                       , SLIT_PLANT_ID
                       , MARKET
                       , MFG_WEEK
                       , DEMAND_DIVISION_ID
                       , PLAN_GROUP_ID
                       , TOTAL_WORKING_TIME
                       , SETUP_TIME
                       , FULL_CLEANING_FLAG
                       , MODEL_TYPE_CHANGE_FLAG
                       , INSERT_ID
                       , INSERT_TIME
                       , TOTAL_BATCH
                       , CALC_TYPE
                       , CALC_VERSION
                       , PIG_CLEANING_FLAG
                       , SETUP_COLOR_CODE
                       )
                  SELECT INSTANCE_ID
                	   , FP_PLAN_ID
                       , COMPANY_ID
                       , DIVISION_ID
            		   , SITE_ID
                       , PLANT_ID
                       , FACTORY_ID
                       , WORK_ORDER_SPL_ID  + CONVERT(NVARCHAR, @C_COAT_SEQ)
                       , WORK_ORDER_ID      + CONVERT(NVARCHAR, @C_COAT_SEQ)
                       , @C_COAT_WORK_ORDER_ID  FIX_WORK_ORDER_ID
                       , @C_COAT_BATCH_ORDER_ID BATCH_ORDER_ID
                       , BIN_ORDER_ID
                       , ORDER_TYPE
                       , SCP_TARGET_ID
                       , DEMAND_ID
                       , ITEM_ID
                       , LANE_QTY
                       , TOP_ITEM_ID
                       , TOP_WORK_ORDER_ID
                       , LINE_ID
                       , OPERATION_ID
                       , ELECTRODE_TYPE
                       , WORK_CENTER_ID
                       , EQUIPMENT_ID
                       , PLAN_DATE
                       , PLAN_DATE_SEQ
                       , @C_COAT_SEQ      AS FIX_WORK_SEQ
                       , START_TIME
                       , END_TIME
                       , ORG_PLAN_QTY
                       , CASE WHEN ROUND(PLAN_QTY       * @C_COAT_RATE, 0) > PLAN_QTY       THEN PLAN_QTY
                              ELSE ROUND(PLAN_QTY       * @C_COAT_RATE, 0)
                         END  AS PLAN_QTY
                       , CASE WHEN ROUND(PLAN_IN_QTY    * @C_COAT_RATE, 0) > PLAN_IN_QTY    THEN PLAN_IN_QTY
                              ELSE ROUND(PLAN_IN_QTY    * @C_COAT_RATE, 0)
                         END  AS PLAN_IN_QTY
                       , ITEM_UOM
                       , CASE WHEN ROUND(ROLL_IN_QTY    * @C_COAT_RATE, 0) > ROLL_IN_QTY    THEN ROLL_IN_QTY
                              ELSE ROUND(ROLL_IN_QTY    * @C_COAT_RATE, 0)
                         END  AS ROLL_IN_QTY
                       , CASE WHEN ROUND(ROLL_OUT_QTY   * @C_COAT_RATE, 0) > ROLL_OUT_QTY   THEN ROLL_OUT_QTY
                              ELSE ROUND(ROLL_OUT_QTY   * @C_COAT_RATE, 0)
                         END  AS ROLL_OUT_QTY
                       , CASE WHEN ROUND(JR_IN_QTY      * @C_COAT_RATE, 0) > JR_IN_QTY      THEN JR_IN_QTY
                              ELSE ROUND(JR_IN_QTY      * @C_COAT_RATE, 0)
                         END  AS JR_IN_QTY
                       , CASE WHEN ROUND(JR_OUT_QTY     * @C_COAT_RATE, 0) > JR_OUT_QTY     THEN JR_OUT_QTY
                              ELSE ROUND(JR_OUT_QTY     * @C_COAT_RATE, 0)
                         END  AS JR_OUT_QTY
                       , CASE WHEN ROUND(CELL_IN_QTY    * @C_COAT_RATE, 0) > CELL_IN_QTY    THEN CELL_IN_QTY
                              ELSE ROUND(CELL_IN_QTY    * @C_COAT_RATE, 0)
                         END  AS CELL_IN_QTY
        , CASE WHEN ROUND(CELL_OUT_QTY   * @C_COAT_RATE, 0) > CELL_OUT_QTY   THEN CELL_OUT_QTY
                              ELSE ROUND(CELL_OUT_QTY   * @C_COAT_RATE, 0)
                         END  AS CELL_OUT_QTY
                       , CASE WHEN ROUND(BATCH_QTY      * @C_COAT_RATE, @C_COAT_BATCH_ROUND_SITE) > BATCH_QTY      THEN BATCH_QTY
           ELSE ROUND(BATCH_QTY      * @C_COAT_RATE, @C_COAT_BATCH_ROUND_SITE)
                         END  AS BATCH_QTY
                       , CASE WHEN ROUND(BATCH_IN_QTY   * @C_COAT_RATE, @C_COAT_BATCH_ROUND_SITE) > BATCH_IN_QTY   THEN BATCH_IN_QTY
                              ELSE ROUND(BATCH_IN_QTY   * @C_COAT_RATE, @C_COAT_BATCH_ROUND_SITE)
                         END  AS BATCH_IN_QTY
                       , CASE WHEN ROUND(BATCH_SUM_QTY  * @C_COAT_RATE, @C_COAT_BATCH_ROUND_SITE) > BATCH_SUM_QTY  THEN BATCH_SUM_QTY
                              ELSE ROUND(BATCH_SUM_QTY  * @C_COAT_RATE, @C_COAT_BATCH_ROUND_SITE)
                         END  AS BATCH_SUM_QTY
                       , FIX_TYPE
                   , PRODUCTION_TYPE
                       , BOM_VERSION_ID
                       , SLIT_PLANT_ID
                     , MARKET
                       , MFG_WEEK
                       , DEMAND_DIVISION_ID
                       , PLAN_GROUP_ID
                       , TOTAL_WORKING_TIME * @C_COAT_RATE
                       , SETUP_TIME
                       , FULL_CLEANING_FLAG
                       , MODEL_TYPE_CHANGE_FLAG
                       , INSERT_ID
                       , INSERT_TIME
                       , TOTAL_BATCH
                       , CALC_TYPE
                       , CALC_VERSION
                       , PIG_CLEANING_FLAG
                       , SETUP_COLOR_CODE
                  FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY
                  WHERE  INSTANCE_ID        = @v_master_id
                  AND    FP_PLAN_ID         = @v_plan_id
                  AND    FACTORY_ID         = @C_COAT_FACTORY_ID
                  AND    LINE_ID            = @C_COAT_LINE_ID
                  AND    OPERATION_ID       = @C_COAT_OPERATION_ID
                  AND    EQUIPMENT_ID       = @C_COAT_EQUIPMENT_ID
                  AND    ITEM_ID            = @C_COAT_ITEM_ID
                  AND    PRODUCTION_TYPE    = @C_COAT_PRODUCTION_TYPE
                  AND    MARKET             = @C_COAT_MARKET
                  AND    PLAN_DATE          = @C_COAT_PLAN_DATE
                  AND    WORK_ORDER_ID      = @C_COAT_ORDER_ID
                  AND    FIX_WORK_ORDER_ID  IS NULL
                  AND    PLAN_QTY           > 0
          
                  SET @n_row_count = @n_row_count + @@ROWCOUNT
                  
                  UPDATE TH_BUF_SCM_DAILY_PLAN_FACTORY
                  SET    PLAN_QTY           = PLAN_QTY      - ( CASE WHEN ROUND(PLAN_QTY       * @C_COAT_RATE, 0) > PLAN_QTY       THEN PLAN_QTY
                                                                     ELSE ROUND(PLAN_QTY       * @C_COAT_RATE, 0)
                                                                END  )
                       , PLAN_IN_QTY        = PLAN_IN_QTY   - ( CASE WHEN ROUND(PLAN_IN_QTY    * @C_COAT_RATE, 0) > PLAN_IN_QTY    THEN PLAN_IN_QTY
                                                                     ELSE ROUND(PLAN_IN_QTY    * @C_COAT_RATE, 0)
                                                                END  )
                       , ROLL_IN_QTY        = ROLL_IN_QTY   - ( CASE WHEN ROUND(ROLL_IN_QTY    * @C_COAT_RATE, 0) > ROLL_IN_QTY    THEN ROLL_IN_QTY
                                                                     ELSE ROUND(ROLL_IN_QTY    * @C_COAT_RATE, 0)
                                                                END  )
                       , ROLL_OUT_QTY       = ROLL_OUT_QTY  - ( CASE WHEN ROUND(ROLL_OUT_QTY   * @C_COAT_RATE, 0) > ROLL_OUT_QTY   THEN ROLL_OUT_QTY
                                                                   ELSE ROUND(ROLL_OUT_QTY   * @C_COAT_RATE, 0)
                  END )
                       , JR_IN_QTY          = JR_IN_QTY     - ( CASE WHEN ROUND(JR_IN_QTY      * @C_COAT_RATE, 0) > JR_IN_QTY    THEN JR_IN_QTY
                                                                     ELSE ROUND(JR_IN_QTY      * @C_COAT_RATE, 0)
                                                                END  )
                       , JR_OUT_QTY         = JR_OUT_QTY    - ( CASE WHEN ROUND(JR_OUT_QTY     * @C_COAT_RATE, 0) > JR_OUT_QTY     THEN JR_OUT_QTY
                                                                     ELSE ROUND(JR_OUT_QTY     * @C_COAT_RATE, 0)
                                                                END  )
                       , CELL_IN_QTY        = CELL_IN_QTY   - ( CASE WHEN ROUND(CELL_IN_QTY    * @C_COAT_RATE, 0) > CELL_IN_QTY    THEN CELL_IN_QTY
                                                                     ELSE ROUND(CELL_IN_QTY    * @C_COAT_RATE, 0)
                                                                END  )
   , CELL_OUT_QTY       = CELL_OUT_QTY  - ( CASE WHEN ROUND(CELL_OUT_QTY   * @C_COAT_RATE, 0) > CELL_OUT_QTY   THEN CELL_OUT_QTY
                                                                     ELSE ROUND(CELL_OUT_QTY   * @C_COAT_RATE, 0)
                                                                END  )
                       , BATCH_QTY          = BATCH_QTY     - ( CASE WHEN ROUND(BATCH_QTY      * @C_COAT_RATE, @C_COAT_BATCH_ROUND_SITE) > BATCH_QTY      THEN BATCH_QTY
                                                                     ELSE ROUND(BATCH_QTY      * @C_COAT_RATE, @C_COAT_BATCH_ROUND_SITE)
                                                                END  )
                       , BATCH_IN_QTY       = BATCH_IN_QTY  - ( CASE WHEN ROUND(BATCH_IN_QTY   * @C_COAT_RATE, @C_COAT_BATCH_ROUND_SITE) > BATCH_IN_QTY   THEN BATCH_IN_QTY
                                                                     ELSE ROUND(BATCH_IN_QTY   * @C_COAT_RATE, @C_COAT_BATCH_ROUND_SITE)
                                                                END  )
                       , BATCH_SUM_QTY      = BATCH_SUM_QTY - ( CASE WHEN ROUND(BATCH_SUM_QTY  * @C_COAT_RATE, @C_COAT_BATCH_ROUND_SITE) > BATCH_SUM_QTY  THEN BATCH_SUM_QTY
                                                                     ELSE ROUND(BATCH_SUM_QTY  * @C_COAT_RATE, @C_COAT_BATCH_ROUND_SITE)
                                                                END  )
                       , TOTAL_WORKING_TIME = TOTAL_WORKING_TIME  - ( TOTAL_WORKING_TIME    * @C_COAT_RATE )
                  WHERE  INSTANCE_ID        = @v_master_id
                  AND    FP_PLAN_ID         = @v_plan_id
                  AND    FACTORY_ID         = @C_COAT_FACTORY_ID
                  AND    LINE_ID            = @C_COAT_LINE_ID
                  AND    OPERATION_ID       = @C_COAT_OPERATION_ID
                  AND    EQUIPMENT_ID       = @C_COAT_EQUIPMENT_ID
                  AND    ITEM_ID            = @C_COAT_ITEM_ID
                  AND    PRODUCTION_TYPE    = @C_COAT_PRODUCTION_TYPE
                  AND    MARKET             = @C_COAT_MARKET
                  AND    PLAN_DATE          = @C_COAT_PLAN_DATE
                  AND    WORK_ORDER_ID      = @C_COAT_ORDER_ID
                  AND    FIX_WORK_ORDER_ID  IS NULL
                  AND    PLAN_QTY           > 0
          
                END
                
                IF @C_COAT_RATE >= 1.0
                BEGIN
          	      
                  UPDATE TH_BUF_SCM_DAILY_PLAN_FACTORY
                  SET    FIX_WORK_ORDER_ID  = @C_COAT_WORK_ORDER_ID
                       , FIX_WORK_SEQ       = @C_COAT_SEQ
                       , BATCH_ORDER_ID     = @C_COAT_BATCH_ORDER_ID
                  WHERE  INSTANCE_ID     = @v_master_id
                  AND    FP_PLAN_ID         = @v_plan_id
                  AND    FACTORY_ID         = @C_COAT_FACTORY_ID
AND    LINE_ID            = @C_COAT_LINE_ID
                  AND    OPERATION_ID       = @C_COAT_OPERATION_ID
                  AND    EQUIPMENT_ID       = @C_COAT_EQUIPMENT_ID
                  AND    ITEM_ID            = @C_COAT_ITEM_ID
                  AND    PRODUCTION_TYPE    = @C_COAT_PRODUCTION_TYPE
                  AND    MARKET             = @C_COAT_MARKET
                  AND    PLAN_DATE          = @C_COAT_PLAN_DATE
                  AND    WORK_ORDER_ID      = @C_COAT_ORDER_ID
                  AND    FIX_WORK_ORDER_ID  IS NULL
                  AND    PLAN_QTY           > 0
                  
                  SET @n_row_count = @n_row_count + @@ROWCOUNT

                END
                
              END
          
            END
            CLOSE C_COAT_WO_PEGGING 
            
            DEALLOCATE C_COAT_WO_PEGGING
              
          END 
        
          --LOG 생성
          SET @v_message = 'FIX_WORK : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END
        
        SET @v_table_name = 'fp_amend_production_plan_r'

        DELETE FROM A
        FROM   fp_amend_production_plan_r A
        WHERE  A.MASTER_ID          = @v_master_id
        AND    A.PLAN_ID            = @v_plan_id
        AND    A.AFTER_SITE_ID      = @v_factory_id
        
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
        
        INSERT INTO fp_amend_production_plan_r
             (
               MASTER_ID
             , PLAN_ID
             , WORK_ORDER_ID
             , BEFORE_SITE_ID
             , AFTER_SITE_ID
             , BEFORE_ROUTE_ID
             , AFTER_ROUTE_ID
             , BEFORE_OPERATION_ID
             , AFTER_OPERATION_ID
             , BEFORE_RESOURCE_ID
             , AFTER_RESOURCE_ID
             , BEFORE_PLAN_DATE
             , AFTER_PLAN_DATE
             , BEFORE_START_TIME
             , AFTER_START_TIME
             , BEFORE_END_TIME
             , AFTER_END_TIME
             , WORKING_TIME
             , BEFORE_SEQ
             , AFTER_SEQ
             , BEFORE_QTY
             , AFTER_QTY
             , BEFORE_IN_QTY
             , AFTER_IN_QTY
             , ITEM_ID
             , FIXED_YN
             , SPLIT_YN
             , DEMAND_ID
             , DEMAND_TYPE
             , ORDER_ID
             , ORDER_TYPE
             , PO_ID
             , MFG_WEEK
             , SOP_WEEK
             , ORG_WORK_ORDER_ID
             , DEMAND_DUE_DATE
             , BATCH_ORDER_ID
             , LANE_QTY
             , LANE_TACT_QTY
             , ITEM_UOM
             , SETUP_TIME
             , SETUP_TIME_UOM
             , ROLL_IN_QTY
             , ROLL_QTY
             , JR_IN_QTY
             , JR_QTY
             , CELL_IN_QTY
             , CELL_QTY
             , BATCH_IN_QTY       
             , BATCH_QTY
             , MARKET
             , TOP_ITEM_ID
             , FULL_CLEANING_FLAG
             , MODEL_TYPE_CHANGE_FLAG
             , INSERT_ID
             , INSERT_TIME
             , UPDATE_ID
             , UPDATE_TIME
             )
        SELECT A.INSTANCE_ID        AS MASTER_ID
             , A.FP_PLAN_ID         AS PLAN_ID
       , ISNULL(A.FIX_WORK_ORDER_ID, A.WORK_ORDER_SPL_ID)  AS WORK_ORDER_ID
             , A.FACTORY_ID         AS BEFORE_SITE_ID
             , A.FACTORY_ID AS AFTER_SITE_ID
             , A.LINE_ID            AS BEFORE_ROUTE_ID
             , A.LINE_ID            AS AFTER_ROUTE_ID
             , A.OPERATION_ID       AS BEFORE_OPERATION_ID
             , A.OPERATION_ID       AS AFTER_OPERATION_ID
    , A.EQUIPMENT_ID       AS BEFORE_RESOURCE_ID
             , A.EQUIPMENT_ID      AS AFTER_RESOURCE_ID
             , CONVERT(NVARCHAR, A.PLAN_DATE, 112)          AS BEFORE_PLAN_DATE
             , CONVERT(NVARCHAR, A.PLAN_DATE, 112)          AS AFTER_PLAN_DATE
             , REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR, A.START_TIME, 120), ':', ''), '-', ''), ' ', '') AS BEFORE_START_TIME
             , REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR, A.START_TIME, 120), ':', ''), '-', ''), ' ', '') AS AFTER_START_TIME
             , REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR, A.END_TIME,   120), ':', ''), '-', ''), ' ', '') AS BEFORE_END_TIME
             , REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR, A.END_TIME,   120), ':', ''), '-', ''), ' ', '') AS AFTER_END_TIME
             , A.TOTAL_WORKING_TIME AS WORKING_TIME
             --, A.NEW_SEQ            AS BEFORE_SEQ
             --, A.NEW_SEQ            AS AFTER_SEQ
             , A.PLAN_DATE_SEQ      AS BEFORE_SEQ
             , A.PLAN_DATE_SEQ      AS AFTER_SEQ
             , A.PLAN_QTY           AS BEFORE_QTY
             , A.PLAN_QTY           AS AFTER_QTY
             , A.PLAN_IN_QTY      AS BEFORE_IN_QTY
             , A.PLAN_IN_QTY        AS AFTER_IN_QTY
             , A.ITEM_ID
             , CASE WHEN A.FIX_WORK_ORDER_ID IS NOT NULL THEN 'Y' ELSE 'N' END  AS FIXED_YN
             , 'N'                  AS SPLIT_YN
             , A.DEMAND_ID
             , A.PRODUCTION_TYPE    AS DEMAND_TYPE
             , ''                   AS ORDER_ID
             , A.ORDER_TYPE
             , ''                   AS PO_ID
             , A.MFG_WEEK
             , A.MFG_WEEK           AS SOP_WEEK
             , A.WORK_ORDER_ID      AS ORG_WORK_ORDER_ID

             , A.PLAN_DATE          AS DEMAND_DUE_DATE
             , A.BATCH_ORDER_ID
             , A.LANE_QTY
             , A.LANE_QTY           AS LANE_TACT_QTY
             , A.ITEM_UOM
             , A.SETUP_TIME
             , 'SECOND'             AS SETUP_TIME_UOM
             , A.ROLL_IN_QTY
             , A.ROLL_OUT_QTY       AS ROLL_QTY
             , A.JR_IN_QTY
             , A.JR_OUT_QTY         AS JR_QTY
             , A.CELL_IN_QTY
             , A.CELL_OUT_QTY       AS CELL_QTY
             , A.BATCH_IN_QTY       
             , A.BATCH_QTY
             , A.MARKET
             , A.TOP_ITEM_ID
             , A.FULL_CLEANING_FLAG
             , A.MODEL_TYPE_CHANGE_FLAG
             , A.INSERT_ID
             , GETDATE()  AS INSERT_TIME
             , A.INSERT_ID          AS UPDATE_ID
             , GETDATE()        AS UPDATE_TIME
        FROM   (
--                SELECT A.*
--                     /*
--                     , DENSE_RANK() OVER (PARTITION BY A.FACTORY_ID
--                                                     , A.LINE_ID
--                                                     , A.OPERATION_ID
--                                                     , A.ELECTRODE_TYPE
--                                                     , A.EQUIPMENT_ID
--                                                     , A.PLAN_DATE
--                                          ORDER     BY A.PLAN_DATE_SEQ
--                                                     , ISNULL(A.FIX_WORK_SEQ, 0)    -- 확정 SPLIT 은 그 순서 유지
--                                         ) AS NEW_SEQ
--                     */
--                FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY A
--                WHERE  A.INSTANCE_ID  = @v_master_id
--                AND    A.FP_PLAN_ID   = @v_plan_id
--                AND    A.FACTORY_ID   = @v_factory_id
                        SELECT INSTANCE_ID,FP_PLAN_ID,COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,WORK_ORDER_SPL_ID,WORK_ORDER_ID,FIX_WORK_ORDER_ID,BATCH_ORDER_ID,BIN_ORDER_ID,ORDER_TYPE,SCP_TARGET_ID,DEMAND_ID,
                		  ITEM_ID,LANE_QTY,TOP_ITEM_ID,TOP_WORK_ORDER_ID,LINE_ID,OPERATION_ID,ELECTRODE_TYPE,WORK_CENTER_ID,EQUIPMENT_ID,PLAN_DATE,PLAN_DATE_SEQ,FIX_WORK_SEQ,START_TIME,END_TIME,
                		  SUM(ORG_PLAN_QTY) AS ORG_PLAN_QTY,
                		  SUM(PLAN_QTY) AS PLAN_QTY,
                		  SUM(PLAN_IN_QTY) AS PLAN_IN_QTY,
                		  ITEM_UOM,
                		  SUM(ROLL_IN_QTY) AS ROLL_IN_QTY,
                		  SUM(ROLL_OUT_QTY) AS ROLL_OUT_QTY,
                		  SUM(JR_IN_QTY) AS JR_IN_QTY,
                		  SUM(JR_OUT_QTY) AS JR_OUT_QTY,
                		  SUM(CELL_IN_QTY) AS CELL_IN_QTY,
                		  SUM(CELL_OUT_QTY) AS CELL_OUT_QTY,
                		  SUM(BATCH_QTY) AS BATCH_QTY,
                		  SUM(BATCH_IN_QTY) AS BATCH_IN_QTY,
                		  SUM(BATCH_SUM_QTY) AS BATCH_SUM_QTY,
                		  FIX_TYPE,PRODUCTION_TYPE,BOM_VERSION_ID,SLIT_PLANT_ID,MARKET,MFG_WEEK,DEMAND_DIVISION_ID,PLAN_GROUP_ID,TOTAL_WORKING_TIME,SETUP_TIME,FULL_CLEANING_FLAG,MODEL_TYPE_CHANGE_FLAG,
                		  INSERT_ID
                FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY
                WHERE  INSTANCE_ID  = @v_master_id
                AND    FP_PLAN_ID   = @v_plan_id
                AND    FACTORY_ID   = @v_factory_id                
--                AND 	  WORK_ORDER_ID = 'MP22425RP#PE2#EB#01#0009'
                GROUP BY INSTANCE_ID,FP_PLAN_ID,COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,WORK_ORDER_SPL_ID,WORK_ORDER_ID,FIX_WORK_ORDER_ID,BATCH_ORDER_ID,BIN_ORDER_ID,ORDER_TYPE,SCP_TARGET_ID,DEMAND_ID,
                		  ITEM_ID,LANE_QTY,TOP_ITEM_ID,TOP_WORK_ORDER_ID,LINE_ID,OPERATION_ID,ELECTRODE_TYPE,WORK_CENTER_ID,EQUIPMENT_ID,PLAN_DATE,PLAN_DATE_SEQ,FIX_WORK_SEQ,START_TIME,END_TIME,
                		  ITEM_UOM,
                		  FIX_TYPE,PRODUCTION_TYPE,BOM_VERSION_ID,SLIT_PLANT_ID,MARKET,MFG_WEEK,DEMAND_DIVISION_ID,PLAN_GROUP_ID,TOTAL_WORKING_TIME,SETUP_TIME,FULL_CLEANING_FLAG,MODEL_TYPE_CHANGE_FLAG,
                		  INSERT_ID
               ) A

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        
    END
    
    BEGIN
      
     -- FP_AMEND_PRODUCTION_PLAN_R
      -- S-TEST - TEST 변환
      UPDATE A
      SET    A.DEMAND_TYPE  = B.SCP_PRODUCTION_TYPE
      FROM   FP_AMEND_PRODUCTION_PLAN_R A
           , (
              SELECT B.SEGMENT1         AS DIVISION_ID
                   , B.ATTRIBUTE1       AS SCP_PRODUCTION_TYPE
                   , MAX(B.ATTRIBUTE2)  AS FP_PRODUCTION_TYPE
              FROM   SCM_SYS_LOOKUP_TYPE_M A
                   , SCM_SYS_LOOKUP_VALUE  B
              WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
              AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
              AND    B.ATTRIBUTE3       = 'Y'                 -- SCP TARGET FLAG
              AND    A.ACTIVE_FLAG      = 'Y'
              AND    B.ACTIVE_FLAG      = 'Y'
              GROUP  BY B.SEGMENT1, B.ATTRIBUTE1
              HAVING B.ATTRIBUTE1 <> MAX(B.ATTRIBUTE2)
            ) B
      WHERE  A.MASTER_ID      = @v_master_id 
      AND    A.PLAN_ID       = @v_plan_id
      AND    A.AFTER_SITE_ID       = @v_factory_id
  AND    A.DEMAND_TYPE  = B.FP_PRODUCTION_TYPE
      
      SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null 

      ---------------------------------------------------------------------------------------
      -- FP_DAILY_PRODUCTION_PLAN_R 
      ---------------------------------------------------------------------------------------
      SET @v_table_name = 'FP_DAILY_PRODUCTION_PLAN_R'
      
      -- DAILY_PRODUCTION_PLAN_R
      DELETE FROM FP_DAILY_PRODUCTION_PLAN_R
      WHERE  INSTANCE_ID  = @v_master_id
      AND    FP_PLAN_ID   = @v_plan_id
      AND    FACTORY_ID   = @v_factory_id

     SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null 

      INSERT INTO FP_DAILY_PRODUCTION_PLAN_R
           (
             INSTANCE_ID
           , FP_PLAN_ID
           , COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , FACTORY_ID
           , WORK_ORDER_SPL_ID
           , WORK_ORDER_ID
           , ORG_DEMAND_ID
           , DEMAND_ID
           , ITEM_ID
           , TOP_ITEM_ID
           , OPERATION_ID
           , LINE_ID
           , ELECTRODE_TYPE
           , EQUIPMENT_ID
           , PLAN_DATE
           , START_TIME
           , END_TIME
           , PLAN_QTY
           , PLAN_IN_QTY
           , ITEM_UOM
           , ROLL_IN_QTY
           , ROLL_OUT_QTY
           , JR_IN_QTY
           , JR_OUT_QTY
           , CELL_IN_QTY
           , CELL_OUT_QTY
           , BATCH_IN_QTY
           , BATCH_OUT_QTY
           , FIX_TYPE
           , PRODUCTION_TYPE
           , TOTAL_WORKING_TIME
           , LINE_ITEM_SEQ
           , OPERATION_ITEM_SEQ
           , LANE_QTY
           , LANE_TACT_QTY
           , BATCH_ORDER_ID
           , BIN_ORDER_ID
           , MFG_WEEK
           , DEMAND_DIVISION_ID
           , MARKET
           , FP_PRODUCTION_TYPE
           , FULL_CLEANING_FLAG
           , MODEL_TYPE_CHANGE_FLAG
           , SEQ
           , INSERT_ID
           , INSERT_DTTM
           , CALC_TYPE
           , CALC_VERSION
           , TOTAL_BATCH
           , PIG_CLEANING_FLAG
           , SETUP_COLOR_CODE
           )          
      SELECT 
             A.MASTER_ID
           , A.PLAN_ID
           , C.COMPANY_ID
    , C.DIVISION_ID
           , C.SITE_ID
           , C.PLANT_ID
           , A.AFTER_SITE_ID            AS FACTORY_ID
           , A.WORK_ORDER_ID            AS WORK_ORDER_SPL_ID
           , A.WORK_ORDER_ID
           , ISNULL(B.SCP_TARGET_ID, A.DEMAND_ID) AS SCP_TARGET_ID
           , A.DEMAND_ID
           , A.ITEM_ID
           , ISNULL(B.ITEM_ID, A.ITEM_ID)         AS TOP_ITEM_ID
           , A.AFTER_OPERATION_ID             AS OPERATION_ID
           , A.AFTER_ROUTE_ID                 AS LINE_ID
           , ISNULL(D.ELECTRODE_TYPE, E.ELECTRODE_TYPE) AS ELECTRODE_TYPE
           , A.AFTER_RESOURCE_ID              AS EQUIPMENT_ID
           , CONVERT(DATETIME, A.AFTER_PLAN_DATE)                             AS PLAN_DATE
           , CONVERT(DATETIME, SUBSTRING(A.AFTER_START_TIME, 1, 4) 
                               + '-' + SUBSTRING(A.AFTER_START_TIME, 5, 2)
                            + '-' + SUBSTRING(A.AFTER_START_TIME, 7, 2)
                               + ' ' + SUBSTRING(A.AFTER_START_TIME, 9, 2)
                               + ':' + SUBSTRING(A.AFTER_START_TIME, 11, 2)
                               + ':' + SUBSTRING(A.AFTER_START_TIME, 13, 2))  AS START_TIME
           , CONVERT(DATETIME, SUBSTRING(A.AFTER_END_TIME, 1, 4) 
                               + '-' + SUBSTRING(A.AFTER_END_TIME, 5, 2)
                               + '-' + SUBSTRING(A.AFTER_END_TIME, 7, 2)
                               + ' ' + SUBSTRING(A.AFTER_END_TIME, 9, 2)
                               + ':' + SUBSTRING(A.AFTER_END_TIME, 11, 2)
                               + ':' + SUBSTRING(A.AFTER_END_TIME, 13, 2))    AS AFTER_END_TIME
           , A.AFTER_QTY
           , A.AFTER_IN_QTY
           , A.ITEM_UOM
           , A.ROLL_IN_QTY
           , A.ROLL_QTY                 AS ROLL_OUT_QTY
           , A.JR_IN_QTY
           , A.JR_QTY                   AS JR_OUT_QTY
           , A.CELL_IN_QTY
           , A.CELL_QTY                 AS CELL_OUT_QTY
           , A.BATCH_IN_QTY
           , A.BATCH_QTY                AS BATCH_OUT_QTY
           , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
           , A.DEMAND_TYPE              AS PRODUCTION_TYPE
           , 0 TOTAL_WORKING_TIME
           , 1 LINE_ITEM_SEQ
           , 1 OPERATION_ITEM_SEQ
           , A.LANE_QTY
           , A.LANE_TACT_QTY
           , A.BATCH_ORDER_ID
           , '-'                        AS BIN_ORDER_ID
           , A.MFG_WEEK
           , C.DIVISION_ID              AS DEMAND_DIVISION_ID
           , A.MARKET
           , A.DEMAND_TYPE              AS FP_PRODUCTION_TYPE
           , A.FULL_CLEANING_FLAG
           , A.MODEL_TYPE_CHANGE_FLAG
           , A.AFTER_SEQ
           , @v_proc_name               AS INSERT_ID
           , GETDATE()                  AS INSERT_DATE
           , A.CALC_TYPE
           , A.CALC_VERSION
           , A.TOTAL_BATCH
           , A.PIG_CLEANING_FLAG
           , A.SETUP_COLOR_CODE
      FROM   FP_AMEND_PRODUCTION_PLAN_R A
             LEFT OUTER JOIN FP_DAILY_NET_DEMAND_H B
                  ON    1=1
                  AND   A.MASTER_ID      = B.INSTANCE_ID
                  AND   A.PLAN_ID        = B.DPP_PLAN_ID
                  AND   A.DEMAND_ID      = B.FP_DEMAND_ID
             LEFT OUTER JOIN (
                              SELECT DISTINCT
                                     COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                                     MIN(WORK_CENTER_ID) AS WORK_CENTER_ID,
                                     LINE_ID +'_'+OPERATION_ID
                                               +CASE ELECTRODE_TYPE 
                                                    WHEN NULL   THEN '' 
                          WHEN ''     THEN '' 
                                                    WHEN '-'    THEN '' 
                                                    ELSE '_'+ELECTRODE_TYPE 
                                                END  AS RESOURCE_ID
                              FROM   SCM_EQUIPMENT_M
                              WHERE  EQUIPMENT_TYPE = 'M'
                              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
                             ) D
                  ON    A.AFTER_SITE_ID       = D.FACTORY_ID
                  AND   A.AFTER_ROUTE_ID      = D.LINE_ID
                  AND   A.AFTER_OPERATION_ID  = D.OPERATION_ID
                  AND   A.AFTER_RESOURCE_ID   = D.RESOURCE_ID
             LEFT OUTER JOIN (
                              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                                     WORK_CENTER_ID, 
                                     EQUIPMENT_ID AS RESOURCE_ID
                              FROM   SCM_EQUIPMENT_M
                              WHERE  EQUIPMENT_TYPE = 'M'
                             ) E
                  ON    A.AFTER_SITE_ID       = E.FACTORY_ID
                  AND   A.AFTER_ROUTE_ID      = E.LINE_ID
                  AND   A.AFTER_OPERATION_ID  = E.OPERATION_ID
                  AND   A.AFTER_RESOURCE_ID   = E.RESOURCE_ID
           , SCM_FACTORY_M C
      WHERE  A.MASTER_ID      = @v_master_id
      AND    A.PLAN_ID      = @v_plan_id
      AND    A.AFTER_SITE_ID  = @v_factory_id
      AND    A.AFTER_SITE_ID  = C.FACTORY_ID

      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


      ---------------------------------------------------------------------------------------
      -- FP_PRODUCTION_PLAN_R 
      ---------------------------------------------------------------------------------------

      SET @v_table_name = 'FP_PRODUCTION_PLAN_R'

      -- FP_PRODUCTION_PLAN_R
      DELETE FROM FP_PRODUCTION_PLAN_R
      WHERE  INSTANCE_ID = @v_master_id
      AND    FP_PLAN_ID = @v_plan_id
      AND    FACTORY_ID = @v_factory_id

      SET @v_message = @@ROWCOUNT
SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null 

      INSERT INTO FP_PRODUCTION_PLAN_R
           (
             INSTANCE_ID
           , FP_PLAN_ID
           , COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , FACTORY_ID
           --, WORK_ORDER_SPL_ID
           , WORK_ORDER_ID
           , BATCH_ORDER_ID
           , BIN_ORDER_ID
           , ORDER_TYPE
           , SCP_TARGET_ID
           , DEMAND_ID
           , ITEM_ID
           , LANE_QTY
           , TOP_ITEM_ID
           , LINE_ID
           , OPERATION_ID
           , ELECTRODE_TYPE
           , WORK_CENTER_ID
           --, EQUIPMENT_ID
           , PLAN_DATE
           , START_TIME
           , END_TIME
           , PLAN_QTY
           , PLAN_IN_QTY
           , ROLL_IN_QTY
           , ROLL_OUT_QTY
           , JR_IN_QTY
           , JR_OUT_QTY
           , BATCH_QTY
           , FIX_TYPE
           , PRODUCTION_TYPE
           , MARKET
           , LANE_TACT_QTY
           , MFG_WEEK
           , DEMAND_DIVISION_ID
           , INSERT_ID
           , INSERT_TIME
           )
      SELECT       
             A.MASTER_ID
           , A.PLAN_ID
           , C.COMPANY_ID
           , C.DIVISION_ID
           , C.SITE_ID
           , C.PLANT_ID
           , A.AFTER_SITE_ID         AS FACTORY_ID
           , A.WORK_ORDER_ID
           , A.BATCH_ORDER_ID
           , '-' BIN_ORDER_ID
           , A.ORDER_TYPE
           , ISNULL(B.SCP_TARGET_ID, A.DEMAND_ID) AS SCP_TARGET_ID
           , A.DEMAND_ID
       , A.ITEM_ID
           , A.LANE_QTY
           , A.TOP_ITEM_ID
           , A.AFTER_ROUTE_ID        AS LINE_ID
           , A.AFTER_OPERATION_ID
           , ISNULL(D.ELECTRODE_TYPE, E.ELECTRODE_TYPE) AS ELECTRODE_TYPE
           , ISNULL(D.WORK_CENTER_ID, E.WORK_CENTER_ID) AS WORK_CENTER_ID
           , CONVERT(DATETIME, A.AFTER_PLAN_DATE)                             AS PLAN_DATE
           , CONVERT(DATETIME, SUBSTRING(A.AFTER_START_TIME, 1, 4) 
                               + '-' + SUBSTRING(A.AFTER_START_TIME, 5, 2)
                               + '-' + SUBSTRING(A.AFTER_START_TIME, 7, 2)
                               + ' ' + SUBSTRING(A.AFTER_START_TIME, 9, 2)
                               + ':' + SUBSTRING(A.AFTER_START_TIME, 11, 2)
                               + ':' + SUBSTRING(A.AFTER_START_TIME, 13, 2))  AS START_TIME
      , CONVERT(DATETIME, SUBSTRING(A.AFTER_END_TIME, 1, 4) 
                               + '-' + SUBSTRING(A.AFTER_END_TIME, 5, 2)
                               + '-' + SUBSTRING(A.AFTER_END_TIME, 7, 2)
                               + ' ' + SUBSTRING(A.AFTER_END_TIME, 9, 2)
                               + ':' + SUBSTRING(A.AFTER_END_TIME, 11, 2)
                               + ':' + SUBSTRING(A.AFTER_END_TIME, 13, 2))    AS AFTER_END_TIME
           , A.AFTER_QTY
           , A.AFTER_IN_QTY
       , A.ROLL_IN_QTY
           , A.ROLL_QTY       AS ROLL_OUT_QTY
           , A.JR_IN_QTY
           , A.JR_QTY         AS JR_OUT_QTY
           , A.BATCH_QTY
           , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
           , A.DEMAND_TYPE       AS PRODUCTION_TYPE
           , A.MARKET
           , A.LANE_TACT_QTY
           , A.MFG_WEEK
           , C.DIVISION_ID   AS DEMAND_DIVISION_ID
           , @v_proc_name    AS INSERT_ID
           , GETDATE()       AS INSERT_TIME
      FROM   FP_AMEND_PRODUCTION_PLAN_R A
             LEFT OUTER JOIN FP_DAILY_NET_DEMAND_H B
                  ON    1=1
                  AND   A.MASTER_ID      = B.INSTANCE_ID
                  AND   A.PLAN_ID        = B.DPP_PLAN_ID
                  AND   A.DEMAND_ID      = B.FP_DEMAND_ID
             LEFT OUTER JOIN (
                              SELECT DISTINCT
          COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                                     MIN(WORK_CENTER_ID) AS WORK_CENTER_ID,
                                     LINE_ID +'_'+OPERATION_ID
                                               +CASE ELECTRODE_TYPE 
                                                    WHEN NULL   THEN '' 
                                                    WHEN ''     THEN '' 
                                                    WHEN '-'    THEN '' 
                                                    ELSE '_'+ELECTRODE_TYPE 
                                                END  AS RESOURCE_ID
                              FROM   SCM_EQUIPMENT_M
                              WHERE  EQUIPMENT_TYPE = 'M'
                              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
                             ) D
                  ON    A.AFTER_SITE_ID       = D.FACTORY_ID
                  AND   A.AFTER_ROUTE_ID      = D.LINE_ID
                  AND   A.AFTER_OPERATION_ID  = D.OPERATION_ID
                  AND   A.AFTER_RESOURCE_ID   = D.RESOURCE_ID
             LEFT OUTER JOIN (
                              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                                     WORK_CENTER_ID, 
                                     EQUIPMENT_ID AS RESOURCE_ID
                          FROM   SCM_EQUIPMENT_M
                              WHERE  EQUIPMENT_TYPE = 'M'
                             ) E
                  ON    A.AFTER_SITE_ID       = E.FACTORY_ID
                  AND   A.AFTER_ROUTE_ID      = E.LINE_ID
                  AND   A.AFTER_OPERATION_ID  = E.OPERATION_ID
                  AND   A.AFTER_RESOURCE_ID   = E.RESOURCE_ID
           , SCM_FACTORY_M C
      WHERE  A.MASTER_ID      = @v_master_id
      AND    A.PLAN_ID        = @v_plan_id
      AND    A.AFTER_SITE_ID  = @v_factory_id
      AND    A.AFTER_SITE_ID  = C.FACTORY_ID

      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


      ---------------------------------------------------------------------------------------
      -- FP_PRODUCTION_PLAN_EQUIPMENT_R 
      ---------------------------------------------------------------------------------------
      SET @v_table_name = 'FP_PRODUCTION_PLAN_EQUIPMENT_R'

 -- FP_PRODUCTION_PLAN_R
      DELETE FROM FP_PRODUCTION_PLAN_EQUIPMENT_R
      WHERE  INSTANCE_ID  = @v_master_id
      AND    FP_PLAN_ID   = @v_plan_id
      AND    FACTORY_ID   = @v_factory_id
      
      SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null 

      INSERT INTO FP_PRODUCTION_PLAN_EQUIPMENT_R
           (
             INSTANCE_ID        
           , FP_PLAN_ID       
           , COMPANY_ID       
           , DIVISION_ID      
           , SITE_ID          
           , PLANT_ID         
           , FACTORY_ID       
           , WORK_ORDER_SPL_ID
           , WORK_ORDER_ID  
           , BATCH_ORDER_ID
           , BIN_ORDER_ID
           , ORDER_TYPE
           , SCP_TARGET_ID    
           , DEMAND_ID        
           , ITEM_ID  
           , LANE_QTY
           , TOP_ITEM_ID      
           , TOP_WORK_ORDER_ID
           , LINE_ID          
           , OPERATION_ID   
           , ELECTRODE_TYPE
           , WORK_CENTER_ID   
           , EQUIPMENT_ID     
           , PLAN_DATE     
           , START_TIME       
   , END_TIME         
           , PLAN_QTY         
  , PLAN_IN_QTY      
           , ROLL_IN_QTY
           , ROLL_OUT_QTY
           , JR_IN_QTY
           , JR_OUT_QTY
           , BATCH_QTY
           , FIX_TYPE         
           , PRODUCTION_TYPE  
           , BOM_VERSION_ID   
           , MARKET
           , MFG_WEEK
           , DEMAND_DIVISION_ID
           , INSERT_ID        
           , INSERT_TIME   
           )
      SELECT  
             A.MASTER_ID
           , A.PLAN_ID
           , C.COMPANY_ID
           , C.DIVISION_ID
           , C.SITE_ID
           , C.PLANT_ID
           , A.AFTER_SITE_ID      AS FACTORY_ID
           , A.WORK_ORDER_ID      AS WORK_ORDER_SPL_ID
           , A.WORK_ORDER_ID
           , A.BATCH_ORDER_ID
           , '-' BIN_ORDER_ID
           , A.ORDER_TYPE
           , ISNULL(B.SCP_TARGET_ID, A.DEMAND_ID) AS SCP_TARGET_ID
           , A.DEMAND_ID
           , A.ITEM_ID
           , A.LANE_QTY
           , A.TOP_ITEM_ID         AS TOP_ITEM_ID
           , A.WORK_ORDER_ID       AS TOP_WORK_ORDER_ID
           , A.AFTER_ROUTE_ID      AS LINE_ID
           , A.AFTER_OPERATION_ID  AS OPERATION_ID
           , ISNULL(D.ELECTRODE_TYPE, E.ELECTRODE_TYPE) AS ELECTRODE_TYPE
           , ISNULL(D.WORK_CENTER_ID, E.WORK_CENTER_ID) AS WORK_CENTER_ID
           , A.AFTER_RESOURCE_ID   AS EQUIPMENT_ID
           , CONVERT(DATETIME, A.AFTER_PLAN_DATE)                             AS PLAN_DATE
           , CONVERT(DATETIME, SUBSTRING(A.AFTER_START_TIME, 1, 4) 
                               + '-' + SUBSTRING(A.AFTER_START_TIME, 5, 2)
                               + '-' + SUBSTRING(A.AFTER_START_TIME, 7, 2)
                               + ' ' + SUBSTRING(A.AFTER_START_TIME, 9, 2)
                               + ':' + SUBSTRING(A.AFTER_START_TIME, 11, 2)
                               + ':' + SUBSTRING(A.AFTER_START_TIME, 13, 2))  AS START_TIME
           , CONVERT(DATETIME, SUBSTRING(A.AFTER_END_TIME, 1, 4) 
                               + '-' + SUBSTRING(A.AFTER_END_TIME, 5, 2)
                               + '-' + SUBSTRING(A.AFTER_END_TIME, 7, 2)
                               + ' ' + SUBSTRING(A.AFTER_END_TIME, 9, 2)
                               + ':' + SUBSTRING(A.AFTER_END_TIME, 11, 2)
                               + ':' + SUBSTRING(A.AFTER_END_TIME, 13, 2))    AS AFTER_END_TIME
           , A.AFTER_QTY     AS PLAN_QTY
           , A.AFTER_IN_QTY  AS PLAN_IN_QTY
           , A.ROLL_IN_QTY
           , A.ROLL_QTY       AS ROLL_OUT_QTY
           , A.JR_IN_QTY
      , A.JR_QTY         AS JR_OUT_QTY
           , A.BATCH_QTY
           , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
           , A.DEMAND_TYPE      AS PRODUCTION_TYPE
           , NULL AS BOM_VERSION_ID
           , A.MARKET
           , A.MFG_WEEK
           , C.DIVISION_ID   AS DEMAND_DIVISION_ID
           , @v_proc_name    AS INSERT_ID
           , GETDATE()       AS INSERT_TIME
      FROM   FP_AMEND_PRODUCTION_PLAN_R A
             LEFT OUTER JOIN FP_DAILY_NET_DEMAND_H B
                  ON    1=1
                  AND   A.MASTER_ID      = B.INSTANCE_ID
                  AND   A.PLAN_ID        = B.DPP_PLAN_ID
                  AND   A.DEMAND_ID      = B.FP_DEMAND_ID
             LEFT OUTER JOIN (
                              SELECT DISTINCT
                                     COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                                     MIN(WORK_CENTER_ID) AS WORK_CENTER_ID,
                                     LINE_ID +'_'+OPERATION_ID
                                               +CASE ELECTRODE_TYPE 
                                                    WHEN NULL   THEN '' 
                                                    WHEN ''     THEN '' 
     WHEN '-'    THEN '' 
                                                    ELSE '_'+ELECTRODE_TYPE 
                                                END AS RESOURCE_ID
                              FROM   SCM_EQUIPMENT_M
                              WHERE  EQUIPMENT_TYPE = 'M'
                              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
                             ) D
                  ON    A.AFTER_SITE_ID       = D.FACTORY_ID
                  AND   A.AFTER_ROUTE_ID      = D.LINE_ID
                  AND   A.AFTER_OPERATION_ID  = D.OPERATION_ID
                  AND   A.AFTER_RESOURCE_ID   = D.RESOURCE_ID
             LEFT OUTER JOIN (
                              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                                     WORK_CENTER_ID, 
                                     EQUIPMENT_ID AS RESOURCE_ID
                              FROM   SCM_EQUIPMENT_M
                              WHERE  EQUIPMENT_TYPE = 'M'
                             ) E
                  ON    A.AFTER_SITE_ID       = E.FACTORY_ID
                  AND   A.AFTER_ROUTE_ID      = E.LINE_ID
                  AND   A.AFTER_OPERATION_ID  = E.OPERATION_ID
                  AND   A.AFTER_RESOURCE_ID   = E.RESOURCE_ID
           , SCM_FACTORY_M C
      WHERE  A.MASTER_ID      = @v_master_id
      AND    A.PLAN_ID        = @v_plan_id
      AND    A.AFTER_SITE_ID  = @v_factory_id
      AND    A.AFTER_SITE_ID  = C.FACTORY_ID

      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      --(D.201130 ~ R.0105) 외부에서 설정
      /**
      -- RELEASE START
      
      UPDATE SCM_FP_PLAN_DETAIL_H
      SET CONFIRM_TIME  = dbo.FN_SITE_TIME(@v_lgc_site), 
          CONFIRM_FLAG  = 'Y'
      WHERE PLAN_DATE = @key_date
      AND INSTANCE_ID = @v_master_id
      AND FACTORY_ID = @v_factory_id
      
      EXECUTE PR_SCM_IF_PLAN_RELEASE_FP_AMEND_POST @v_master_id , @key_date , 'AUTO', @v_factory_id
      
      /*SELECT @N_JOB_SEQ = ISNULL(MAX(JOB_SEQ),0) + 1
      FROM HIS_FP_PLAN_DETAIL_H
      WHERE PLAN_DATE  = @KEY_DATE
      AND   INSTANCE_ID = @V_MASTER_ID*/
      
      INSERT INTO HIS_FP_PLAN_DETAIL_H
          (
            PLAN_DATE
          , INSTANCE_ID
          , DIVISION_ID
          , FACTORY_ID
          , PLAN_ID
          , CONFIRM_ID
          , CONFIRM_TIME
          , CONFIRM_FLAG
          , INSERT_ID
          , INSERT_TIME
          , UPDATE_ID
          , UPDATE_TIME
    --  , JOB_SEQ
          , RELEASE_TIME
          , RELEASE_FLAG
          , RELEASE_PLAN_ID
          , MES_TRANSFER_FLAG
          , MES_TRANSFER_TIME
          )
      SELECT PLAN_DATE
           , INSTANCE_ID
           , DIVISION_ID
           , FACTORY_ID
           , PLAN_ID
           , CONFIRM_ID
           , CONFIRM_TIME
           , CONFIRM_FLAG
           , INSERT_ID
           , INSERT_TIME
           , UPDATE_ID
           , UPDATE_TIME
          -- , @N_JOB_SEQ AS JOB_SEQ
           , RELEASE_TIME
           , RELEASE_FLAG
           , RELEASE_PLAN_ID
           , MES_TRANSFER_FLAG
           , MES_TRANSFER_TIME
      FROM SCM_FP_PLAN_DETAIL_H
      WHERE PLAN_DATE = @key_date
      AND INSTANCE_ID = @v_master_id
      AND FACTORY_ID = @v_factory_id

	**/
      

    END
    
    IF @@TRANCOUNT > 0
      COMMIT WORK 
    
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
