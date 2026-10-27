CREATE PROCEDURE [dbo].[PR_SCM_AF_PANCAKE_INVENTORY_BALANCE]
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_AF_PANCAKE_INVENTORY_BALANCE                                       **/
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
/** 2016.10.19    LJH          최초 작성                                                      **/
/***********************************************************************************************/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_company              nvarchar(30)   
  DECLARE @v_division             nvarchar(30)
  DECLARE @v_corporation          nvarchar(30)
  DECLARE @v_plant                nvarchar(30)
  DECLARE @v_master_id            nvarchar(30)
  DECLARE @v_plan_id              nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name            nvarchar(100) = 'PR_SCM_AF_PANCAKE_INVENTORY_BALANCE'
  DECLARE @v_table_name           nvarchar(100)
  DECLARE @v_message              nvarchar(250)
  DECLARE @v_descr                nvarchar(250)
  DECLARE @n_row_count            Integer  = 0
  DECLARE @n_log_count            Integer  = 0
  DECLARE @v_log_code             nvarchar(10)
  
  -- 일반 변수
  DECLARE @v_plan_date            datetime
  DECLARE @v_default_roll_length  numeric(20,10) = 1100.0
  
  -- 기타 변수
  DECLARE @sysdate                DATETIME2 = GETDATE()

  DECLARE @v_temp1                nvarchar(1000)
  DECLARE @v_temp2                nvarchar(1000)
  
  SET @v_master_id  = 'MASTER'
  SET @v_plan_id    = 'NETJOB_' + CONVERT(nvarchar, GETDATE(), 112)
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
	
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN

      -- 프로시저 수행시 PLAN DATE 설정
      BEGIN
      
        DELETE FROM TH_BUF_SCM_PANCAKE_INVENTORY_BASIS_TIME

        INSERT INTO TH_BUF_SCM_PANCAKE_INVENTORY_BASIS_TIME
             (
               COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , BASIS_DATE
             , BASIS_TIME
             , PLAN_START_TIME
             , INSERT_TIME     
             )
        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
             , A.BASIS_DATE
             , A.BASIS_TIME
             , CASE WHEN PLAN_START_TIME <= INSERT_TIME THEN PLAN_START_TIME
                    ELSE DATEADD(DAY, -1, PLAN_START_TIME)
               END  PLAN_START_TIME
             , INSERT_TIME
        FROM   (
                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
                     , A.BASIS_DATE
                     , A.BASIS_TIME
                     , CONVERT(DATETIME, BASIS_DATE + ' ' + HH +':'+ MI +':'+SS) AS PLAN_START_TIME
                     , GETDATE() AS INSERT_TIME
                FROM   (
                        SELECT A.*
                             , SUBSTRING(BASIS_TIME, 1, 2) AS HH
                             , SUBSTRING(BASIS_TIME, 3, 2) AS MI
                             , SUBSTRING(BASIS_TIME, 5, 2) AS SS
                        FROM   (
                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID 
                                     , CONVERT(NVARCHAR, GETDATE(), 112) AS BASIS_DATE
                                     , ISNULL(ISNULL(SEGMENT2, SEGMENT1), '060000') AS BASIS_TIME 
                                FROM   (
                                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, B.SEGMENT1, C.SEGMENT2
                                        FROM   SCM_FACTORY_M A
                                               LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE B
                                                    ON    B.ACTIVE_FLAG = 'Y'
                                                    AND   B.LOOKUP_TYPE_CODE = 'BASIS_START_TIME'
                                               LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C
                                                    ON    C.ACTIVE_FLAG = 'Y'
                                                    AND   C.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
                                                    AND   A.PLANT_ID = C.SEGMENT1
                                       ) A
                               ) A
                       ) A
               ) A
       
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BASIS_TIME'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

      -- FP_PANCAKE_INVENTORY_BALANCE_M_R 생성
      BEGIN
      
        -- 노칭 계획
        DELETE FROM TH_BUF_SCM_PANCAKE_INVENTORY_NOTCHING_PLAN

        -- RELEASE 버전 당시의 NOTCHING DAILY 계획
        INSERT INTO TH_BUF_SCM_PANCAKE_INVENTORY_NOTCHING_PLAN
             (
               DIVISION_ID
             , FACTORY_ID
             , ITEM_ID
             , PLAN_DATE
             , PLAN_QTY
             , PLAN_IN_QTY
             )
        SELECT A.DIVISION_ID, A.FACTORY_ID, A.ITEM_ID, A.PLAN_DATE
             , SUM(A.PLAN_QTY), SUM(A.PLAN_IN_QTY)
        FROM   FP_DAILY_PRODUCTION_PLAN_R A WITH(NOLOCK)
        WHERE  OPERATION_ID = 'A5000'
        AND    EXISTS ( 
                        SELECT *
                        FROM   (
                                SELECT A.*
                                     , DENSE_RANK() OVER (PARTITION BY A.FACTORY_ID 
                                                          ORDER     BY A.INSTANCE_DATE DESC
                                                                     , A.RELEASE_PLAN_ID ASC) AS SEQ
                                FROM   FP_RELEASE_PLAN_INFO_H   A WITH(NOLOCK),
                                       SCM_FACTORY_M            B WITH(NOLOCK)
           WHERE  A.FACTORY_ID = B.FACTORY_ID
                                AND    B.SHOP_GROUP_ID = 'A'
                               ) B
                        WHERE  B.SEQ = 1
                        AND    A.INSTANCE_ID = B.INSTANCE_ID
                        AND    A.FP_PLAN_ID = B.AMEND_PLAN_ID
                        AND    A.DIVISION_ID    = B.DIVISION_ID
                        AND    A.FACTORY_ID     = B.FACTORY_ID
                      )
        GROUP  BY A.DIVISION_ID, A.FACTORY_ID, A.ITEM_ID, A.PLAN_DATE
        
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_NOTCHING_PLAN'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        -- 과거 PLAN 은 삭제
        DELETE FROM A
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_NOTCHING_PLAN A,
               TH_BUF_SCM_PANCAKE_INVENTORY_BASIS_TIME B
        WHERE  A.DIVISION_ID = B.DIVISION_ID
        AND    A.FACTORY_ID = B.FACTORY_ID
        AND    A.PLAN_DATE < CONVERT(DATE, PLAN_START_TIME)        
        
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_NOTCHING_PLAN'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        UPDATE A
        SET    A.PLAN_IN_QTY = ( CASE WHEN A.PLAN_IN_QTY - B.QTY < 0 THEN 0
                                      ELSE A.PLAN_IN_QTY - B.QTY
                                 END )
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_NOTCHING_PLAN A,
               (
                SELECT A.FACTORY_ID, A.PRODID AS ITEM_ID
                     , CONVERT(DATE, B.PLAN_START_TIME) AS PLAN_DATE
                     , SUM(WIPQTY2_ED) AS QTY
                FROM   SCM_MES_RT_WIP_HISTORY_H A,
                       TH_BUF_SCM_PANCAKE_INVENTORY_BASIS_TIME B
                WHERE  A.FACTORY_ID = B.FACTORY_ID
                AND    A.CALDATE   >= B.PLAN_START_TIME
                AND    A.PROCID     = 'A5000'
                GROUP  BY A.FACTORY_ID, A.PRODID
                     , CONVERT(DATE, B.PLAN_START_TIME)
               ) B
        WHERE  A.FACTORY_ID = B.FACTORY_ID
        AND    A.ITEM_ID    = B.ITEM_ID
        AND    A.PLAN_DATE  = B.PLAN_DATE
        
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_NOTCHING_PLAN'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        /*
        -- 노칭 확정 계획
        INSERT INTO TH_BUF_SCM_PANCAKE_INVENTORY_NOTCHING_PLAN
             (
               DIVISION_ID
             , FACTORY_ID
             , ITEM_ID
             , PLAN_DATE
             , PLAN_QTY
             , PLAN_IN_QTY
             )
        SELECT A.DIVISION_ID, A.FACTORY_ID, A.ITEM_ID
             , CONVERT(DATE, PLAN_DATE) AS PLAN_DATE
             , SUM(PLAN_QTY     - ISNULL(ACTUAL_QTY, 0))  AS PLAN_QTY
             , SUM(PLAN_IN_QTY  - ISNULL(ACTUAL_QTY, 0))  AS PLAN_IN_QTY
        FROM   FP_MES_WORK_ORDER_STATUS_H A
        WHERE  1=1
        AND    ISNULL(ACTUAL_QTY, 0) = 0    -- ACTUAL 은 빼고,,
        AND    EXISTS (
                        SELECT 1
                        FROM   (
                                SELECT FACTORY_ID, OPERATION_ID, MAX(CUTOFF_DATE) AS CUTOFF_DATE
                                FROM   FP_MES_WORK_ORDER_STATUS_H
                                WHERE  OPERATION_ID = 'A5000'
                                GROUP  BY FACTORY_ID, OPERATION_ID
                               ) B
                        WHERE  A.CUTOFF_DATE = B.CUTOFF_DATE
                        AND    A.FACTORY_ID  = B.FACTORY_ID
                        AND    A.OPERATION_ID = B.OPERATION_ID
                     )
        GROUP  BY A.DIVISION_ID, A.FACTORY_ID, A.ITEM_ID, CONVERT(DATE, PLAN_DATE)             

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_NOTCHING_PLAN'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        -- 노칭 예시 계획
        INSERT INTO TH_BUF_SCM_PANCAKE_INVENTORY_NOTCHING_PLAN
             (
               DIVISION_ID
             , FACTORY_ID
             , ITEM_ID
             , PLAN_DATE
             , PLAN_QTY
             , PLAN_IN_QTY
             )
        SELECT A.DIVISION_ID, A.FACTORY_ID, A.ITEM_ID, A.PLAN_DATE
             , SUM(A.PLAN_QTY), SUM(A.PLAN_IN_QTY)
        FROM   FP_RELEASE_FULL_PLAN_H A WITH(NOLOCK)
        WHERE  OPERATION_ID = 'A5000'
        AND    FIX_TYPE = 'P'       -- 예시 계획만 찾기
        AND    EXISTS ( 
                        SELECT *
                        FROM   (
                                SELECT A.*
                                     , DENSE_RANK() OVER (PARTITION BY A.FACTORY_ID 
                                                          ORDER     BY A.INSTANCE_DATE DESC
                                                                     , A.RELEASE_PLAN_ID ASC) AS SEQ
                                FROM   FP_RELEASE_PLAN_INFO_H   A WITH(NOLOCK),
                                       SCM_FACTORY_M            B WITH(NOLOCK)
                                WHERE  A.FACTORY_ID = B.FACTORY_ID
                                AND    B.SHOP_GROUP_ID = 'A'
                               ) B
                        WHERE  B.SEQ = 1
                        AND    A.INSTANCE_ID = B.INSTANCE_ID
                        AND    A.INSTANCE_DATE = B.INSTANCE_DATE
                        AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID
                        AND    A.AMEND_PLAN_ID = B.AMEND_PLAN_ID
                        AND    A.DIVISION_ID    = B.DIVISION_ID
                        AND    A.FACTORY_ID     = B.FACTORY_ID
                      )
        GROUP  BY A.DIVISION_ID, A.FACTORY_ID, A.ITEM_ID, A.PLAN_DATE
        
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_NOTCHING_PLAN'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        */

        -- 노칭 계획을 SLITTING 계획으로 전환
        DELETE FROM TH_BUF_SCM_PANCAKE_INVENTORY_SLITTING_PLAN

        INSERT INTO TH_BUF_SCM_PANCAKE_INVENTORY_SLITTING_PLAN
             (
               COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , ITEM_ID
             , PLAN_DATE
             , PLAN_QTY
             , PLAN_IN_QTY
             , PARENT_QTY
             , PARENT_UOM
             , CHILD_QTY
             , CHILD_UOM
             , CHILD_ITEM_ID
             , CHILD_PLAN_QTY
             )
        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
               A.FACTORY_ID, A.ITEM_ID, A.PLAN_DATE,
               A.PLAN_QTY, A.PLAN_IN_QTY,
               B.PARENT_QTY, B.PARENT_UOM,  
               B.CHILD_QTY, B.CHILD_UOM,
    B.CHILD_ITEM_ID,
               A.PLAN_IN_QTY / PARENT_QTY * CHILD_QTY AS CHILD_PLAN_QTY
        FROM   (
                SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, 
                       A.FACTORY_ID, A.ITEM_ID, A.PLAN_DATE, 
                       SUM(A.PLAN_QTY)    AS PLAN_QTY, 
                       SUM(A.PLAN_IN_QTY) AS PLAN_IN_QTY
                FROM   TH_BUF_SCM_PANCAKE_INVENTORY_NOTCHING_PLAN A,
                       SCM_FACTORY_M B
                WHERE  A.FACTORY_ID = B.FACTORY_ID
                GROUP  BY 
                       B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, 
                       A.FACTORY_ID, A.ITEM_ID, A.PLAN_DATE
               ) A,
               SCM_BOM_M B
        WHERE  A.COMPANY_ID   = B.COMPANY_ID
        AND    A.DIVISION_ID  = B.DIVISION_ID
        AND    A.SITE_ID      = B.SITE_ID
        AND    A.PLANT_ID     = B.PLANT_ID
        AND    A.ITEM_ID      = B.PARENT_ITEM_ID
        AND    A.PLAN_DATE   >= B.EFF_START_DATE
        AND    A.PLAN_DATE    < B.EFF_END_DATE
        
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_SLITTING_PLAN'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null



        DELETE FROM TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
        
        INSERT INTO TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
             (
               COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , ITEM_ID
             , CATEGORY
             , UOM
             , D0_DATE
             , INSERT_TIME
             )
        SELECT DISTINCT
               COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , ITEM_ID
             , CATEGORY
             , UOM
             , CONVERT(DATE, GETDATE()) AS D0_DATE
             , GETDATE()                AS INSERT_TIME
        FROM   (
                SELECT DISTINCT
                       A.COMPANY_ID
                     , A.DIVISION_ID
                     , A.SITE_ID
                     , A.PLANT_ID
                     , A.FACTORY_ID
                     , A.CHILD_ITEM_ID          AS ITEM_ID
                     , A.CHILD_UOM              AS UOM
                FROM   TH_BUF_SCM_PANCAKE_INVENTORY_SLITTING_PLAN A
                UNION  ALL
                SELECT DISTINCT
                       B.COMPANY_ID
                     , B.DIVISION_ID
                     , B.SITE_ID
                     , B.PLANT_ID
                     , A.FP_APPLY_FACTORY_ID    AS FACTORY_ID
                     , A.ITEM_ID
                     , C.ITEM_UOM               AS UOM
                FROM   (
                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, 
                               A.ITEM_ID, A.QTY_UOM,
                               CASE A.FACTORY_ID  WHEN 'E5' THEN 'A1'   -- 한국
                                                  WHEN 'E6' THEN 'A2'
                                                  WHEN 'E8' THEN 'A3'   -- 중국
                                                  WHEN 'EA' THEN 'A3'
                                                  WHEN 'E9' THEN 'A4'   -- 미국
                                                            ELSE A.FACTORY_ID
                               END  AS FP_APPLY_FACTORY_ID,
                               A.FP_APPLY_OPERATION_ID, ISNULL(A.FP_APPLY_WIPQTY, 0) AS FP_APPLY_WIPQTY
                        FROM   SCM_MES_RT_STOCK_H A,
                               (
                                SELECT FACTORY_ID, MAX(CUTOFF_DATE) AS CUTOFF_DATE
               FROM   SCM_MES_RT_STOCK_H
                                GROUP  BY FACTORY_ID
                               ) B
                        WHERE  A.CUTOFF_DATE  = B.CUTOFF_DATE
                        AND    A.FACTORY_ID   = B.FACTORY_ID
                        AND    A.FP_APPLY_OPERATION_ID IN ('E4000','A5000')
                        AND    A.FP_APPLY_ITEM_ID IN (
                                                       SELECT  ITEM_ID 
                                                       FROM    SCM_ITEM_M       A
                                                             , SCM_ITEM_CLASS_M B
                                                       WHERE   A.ITEM_CLASS   = B.CLASS_ID
                                                       AND     A.ACTIVE_FLAG  = 'Y'
                                                       AND     B.USE_FLAG     = 'Y'
                                                       AND     B.LEVEL_2_CODE = 'APC'
                                                      )
                        AND    ISNULL(A.FP_APPLY_WIPQTY, 0) > 0
                       ) A,
                       SCM_FACTORY_M B,
                       SCM_ITEM_M C
               WHERE  A.FP_APPLY_FACTORY_ID = B.FACTORY_ID
               AND    A.COMPANY_ID = C.COMPANY_ID
               AND    A.DIVISION_ID = C.DIVISION_ID
               AND    A.SITE_ID = C.SITE_ID
               AND    A.ITEM_ID = C.ITEM_ID
               ) A,
               (
                SELECT 'PRODUCT'    AS CATEGORY UNION ALL -- 단일 생산 계획
                SELECT 'ACCUMULATE' AS CATEGORY UNION ALL -- 누적 생산 계획
                SELECT 'OSQT'       AS CATEGORY           -- over and short quantity
               ) B
        WHERE  1=1

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        UPDATE TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
        SET    TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE A,
               SCM_ITEM_LINE_ASSIGN_M B
        WHERE  1=1
        --AND    A.COMPANY_ID   = B.COMPANY_ID
        AND    A.DIVISION_ID  = B.DIVISION_ID
        AND    A.SITE_ID      = B.SITE_ID
        --AND    A.PLANT_ID     = B.PLANT_ID
        AND    A.FACTORY_ID   = ( CASE B.FACTORY_ID WHEN 'E5' THEN 'A1'   -- 한국
                                                    WHEN 'E6' THEN 'A2'
                                                    WHEN 'E8' THEN 'A3'   -- 중국
                                                    WHEN 'EA' THEN 'A3'
                                                    WHEN 'E9' THEN 'A4'   -- 미국
                                                    ELSE A.FACTORY_ID
                                  END )
        AND    CONVERT(NVARCHAR(6), D0_DATE, 112) = B.MONTH
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    B.ACTIVE_FLAG  = 'Y'
        AND    B.OPERATION_ID = 'E4000'
        AND    A.ELECTRODE_TYPE IS NULL

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


        UPDATE TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
        SET    TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE A,
               SCM_ITEM_LINE_ASSIGN_M B
        WHERE  1=1
--AND    A.COMPANY_ID   = B.COMPANY_ID
        AND    A.DIVISION_ID  = B.DIVISION_ID
        AND    A.SITE_ID      = B.SITE_ID
        --AND    A.PLANT_ID     = B.PLANT_ID
        AND    A.FACTORY_ID   = ( CASE B.FACTORY_ID WHEN 'E5' THEN 'A1'   -- 한국
                                                    WHEN 'E6' THEN 'A2'
                                                    WHEN 'E8' THEN 'A3'   -- 중국
                                                    WHEN 'EA' THEN 'A3'
                                                    WHEN 'E9' THEN 'A4'   -- 미국
                                                    ELSE A.FACTORY_ID
                                  END )
        AND    CONVERT(NVARCHAR(6), D0_DATE, 112) = B.MONTH
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    B.ACTIVE_FLAG  = 'Y'
        AND    B.OPERATION_ID = 'E3000'
        AND    A.ELECTRODE_TYPE IS NULL

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
        SET    TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE A,
               SCM_ITEM_LINE_ASSIGN_M B
        WHERE  1=1
        --AND    A.COMPANY_ID   = B.COMPANY_ID
        AND    A.DIVISION_ID  = B.DIVISION_ID
        AND    A.SITE_ID      = B.SITE_ID
        --AND    A.PLANT_ID     = B.PLANT_ID
        AND    A.FACTORY_ID   = ( CASE B.FACTORY_ID WHEN 'E5' THEN 'A1'   -- 한국
                                                    WHEN 'E6' THEN 'A2'
                                                    WHEN 'E8' THEN 'A3'   -- 중국
                                                    WHEN 'EA' THEN 'A3'
                                                    WHEN 'E9' THEN 'A4'   -- 미국
                                                    ELSE A.FACTORY_ID
                                  END )
        AND    CONVERT(NVARCHAR(6), D0_DATE, 112) = B.MONTH
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    B.ACTIVE_FLAG  = 'Y'
        AND    B.OPERATION_ID = 'E2000'
        AND    A.ELECTRODE_TYPE IS NULL

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
        SET    TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE A,
               SCM_ITEM_LINE_ASSIGN_M B
        WHERE  1=1
        --AND    A.COMPANY_ID   = B.COMPANY_ID
        AND    A.DIVISION_ID  = B.DIVISION_ID
        AND    A.SITE_ID      = B.SITE_ID
        --AND    A.PLANT_ID     = B.PLANT_ID
        --AND    A.FACTORY_ID   = B.FACTORY_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    B.ACTIVE_FLAG  = 'Y'
        AND    B.OPERATION_ID = 'E2000'
        AND    A.ELECTRODE_TYPE IS NULL

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
        SET    TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.PLAN_TOT_QTY  = B.TOTAL_QTY
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D0            = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D0  WHEN 'ACCUMULATE' THEN B.SUM_D0  ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D1            = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D1  WHEN 'ACCUMULATE' THEN B.SUM_D1  ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D2            = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D2  WHEN 'ACCUMULATE' THEN B.SUM_D2  ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D3            = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D3  WHEN 'ACCUMULATE' THEN B.SUM_D3  ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D4            = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D4  WHEN 'ACCUMULATE' THEN B.SUM_D4  ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D5            = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D5  WHEN 'ACCUMULATE' THEN B.SUM_D5  ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D6            = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D6  WHEN 'ACCUMULATE' THEN B.SUM_D6  ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D7            = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D7  WHEN 'ACCUMULATE' THEN B.SUM_D7  ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D8            = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D8  WHEN 'ACCUMULATE' THEN B.SUM_D8  ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D9            = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D9  WHEN 'ACCUMULATE' THEN B.SUM_D9  ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D10           = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D10 WHEN 'ACCUMULATE' THEN B.SUM_D10 ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D11           = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D11 WHEN 'ACCUMULATE' THEN B.SUM_D11 ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D12           = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D12 WHEN 'ACCUMULATE' THEN B.SUM_D12 ELSE 0 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D13           = CASE A.CATEGORY WHEN 'PRODUCT' THEN B.D13 WHEN 'ACCUMULATE' THEN B.SUM_D13 ELSE 0 END
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE A,
               (
                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.CHILD_ITEM_ID, A.CHILD_UOM
                     , SUM(D0)  AS D0
                     , SUM(D1)  AS D1
                     , SUM(D2)  AS D2
                     , SUM(D3)  AS D3
                     , SUM(D4)  AS D4
                     , SUM(D5)  AS D5
                     , SUM(D6)  AS D6
                     , SUM(D7)  AS D7
                     , SUM(D8)  AS D8
                     , SUM(D9)  AS D9
                     , SUM(D10) AS D10
                     , SUM(D11) AS D11
                     , SUM(D12) AS D12
                     , SUM(D13) AS D13
                     , SUM(CHILD_PLAN_QTY) AS TOTAL_QTY
                     , SUM(SUM_D0)  AS SUM_D0
                     , SUM(SUM_D1)  AS SUM_D1
                     , SUM(SUM_D2)  AS SUM_D2
                     , SUM(SUM_D3)  AS SUM_D3
                     , SUM(SUM_D4)  AS SUM_D4
                     , SUM(SUM_D5)  AS SUM_D5
                     , SUM(SUM_D6)  AS SUM_D6
                     , SUM(SUM_D7)  AS SUM_D7
                     , SUM(SUM_D8)  AS SUM_D8
                     , SUM(SUM_D9)  AS SUM_D9
                     , SUM(SUM_D10) AS SUM_D10
                     , SUM(SUM_D11) AS SUM_D11
                     , SUM(SUM_D12) AS SUM_D12
                     , SUM(SUM_D13) AS SUM_D13
                FROM   (
                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.CHILD_ITEM_ID, A.CHILD_UOM
                             , CASE WHEN DIFF =  0 THEN CHILD_PLAN_QTY ELSE 0 END AS D0
                             , CASE WHEN DIFF =  1 THEN CHILD_PLAN_QTY ELSE 0 END AS D1
                             , CASE WHEN DIFF =  2 THEN CHILD_PLAN_QTY ELSE 0 END AS D2
                             , CASE WHEN DIFF =  3 THEN CHILD_PLAN_QTY ELSE 0 END AS D3
                             , CASE WHEN DIFF =  4 THEN CHILD_PLAN_QTY ELSE 0 END AS D4
                             , CASE WHEN DIFF =  5 THEN CHILD_PLAN_QTY ELSE 0 END AS D5
                             , CASE WHEN DIFF =  6 THEN CHILD_PLAN_QTY ELSE 0 END AS D6
                             , CASE WHEN DIFF =  7 THEN CHILD_PLAN_QTY ELSE 0 END AS D7
                             , CASE WHEN DIFF =  8 THEN CHILD_PLAN_QTY ELSE 0 END AS D8
                             , CASE WHEN DIFF =  9 THEN CHILD_PLAN_QTY ELSE 0 END AS D9
                             , CASE WHEN DIFF = 10 THEN CHILD_PLAN_QTY ELSE 0 END AS D10
                             , CASE WHEN DIFF = 11 THEN CHILD_PLAN_QTY ELSE 0 END AS D11
                             , CASE WHEN DIFF = 12 THEN CHILD_PLAN_QTY ELSE 0 END AS D12
                             , CASE WHEN DIFF = 13 THEN CHILD_PLAN_QTY ELSE 0 END AS D13
                             , CHILD_PLAN_QTY
                             , CASE WHEN DIFF =  0 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D0
                             , CASE WHEN DIFF =  1 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D1
                             , CASE WHEN DIFF =  2 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D2
                             , CASE WHEN DIFF =  3 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D3
                             , CASE WHEN DIFF =  4 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D4
                             , CASE WHEN DIFF =  5 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D5
                             , CASE WHEN DIFF =  6 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D6
                             , CASE WHEN DIFF =  7 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D7
                             , CASE WHEN DIFF =  8 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D8
                             , CASE WHEN DIFF =  9 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D9
                             , CASE WHEN DIFF = 10 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D10
                             , CASE WHEN DIFF = 11 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D11
                             , CASE WHEN DIFF = 12 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D12
                             , CASE WHEN DIFF = 13 THEN SUM_CHILD_PLAN_QTY ELSE 0 END AS SUM_D13                             
                        FROM   (
                                SELECT A.*
                                     , SUM(CHILD_PLAN_QTY) OVER (PARTITION BY A.COMPANY_ID
                                                                            , A.DIVISION_ID
                                                                            , A.SITE_ID
                                                                            , A.PLANT_ID
                                                                            , A.FACTORY_ID
                                                                            , A.CHILD_ITEM_ID
                                                                            , A.CHILD_UOM
                                                                 ORDER     BY A.DIFF) AS SUM_CHILD_PLAN_QTY
                                FROM   (
                                        SELECT A.*, ISNULL(CHILD_PLAN_QTY, 0) AS CHILD_PLAN_QTY
                                        FROM   (
                                                SELECT A.*, DATE_ID, DIFF
                                                FROM   (
                                                        SELECT 
                                                               A.COMPANY_ID
                                                             , A.DIVISION_ID
                                                             , A.SITE_ID
                          , A.PLANT_ID
                                                             , A.FACTORY_ID
                                                             , A.CHILD_ITEM_ID
                                                             , A.CHILD_UOM
                                                        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_SLITTING_PLAN A
                                                        GROUP  BY 
                                                               A.COMPANY_ID
                                                             , A.DIVISION_ID
                                                             , A.SITE_ID
                                                             , A.PLANT_ID
                                                             , A.FACTORY_ID
                                                             , A.CHILD_ITEM_ID
                                                             , A.CHILD_UOM
                                                       ) A,
                                                       (
                                                        SELECT DATE_ID
                                                             , DATEDIFF(DAY, CONVERT(DATE, GETDATE()), DATE_ID) DIFF
                                                        FROM   SCM_SYS_CALENDAR_M
                                                        WHERE  DATE_ID >= CONVERT(DATE, GETDATE())
                                                        AND    DATE_ID <  DATEADD(DAY, 14, CONVERT(DATE, GETDATE()))
                                                       ) B
                                                WHERE  1=1
                                               ) A
                                               LEFT OUTER JOIN TH_BUF_SCM_PANCAKE_INVENTORY_SLITTING_PLAN B
                                                    ON     A.COMPANY_ID     = B.COMPANY_ID
                                                    AND    A.DIVISION_ID    = B.DIVISION_ID
                                                    AND    A.SITE_ID        = B.SITE_ID
                                                    AND    A.PLANT_ID       = B.PLANT_ID
                                                    AND    A.FACTORY_ID     = B.FACTORY_ID
                                                    AND    A.CHILD_ITEM_ID  = B.CHILD_ITEM_ID
                                                    AND    A.CHILD_UOM      = B.CHILD_UOM
                                                    AND    A.DATE_ID        = B.PLAN_DATE
                                       ) A
                               ) A
                        
                       ) A
                GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.CHILD_ITEM_ID, A.CHILD_UOM
                HAVING SUM(CHILD_PLAN_QTY) > 0
               ) B
        WHERE  A.COMPANY_ID   = B.COMPANY_ID
        AND    A.DIVISION_ID  = B.DIVISION_ID
        AND    A.SITE_ID      = B.SITE_ID
        AND    A.PLANT_ID     = B.PLANT_ID
        AND    A.FACTORY_ID   = B.FACTORY_ID
        AND    A.ITEM_ID      = B.CHILD_ITEM_ID
        AND    A.UOM          = B.CHILD_UOM

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      
        UPDATE TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
        SET    TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.INV_E4000   = B.INV_E4000 --CASE WHEN B.INV_E4000 = 0 THEN NULL ELSE B.INV_E4000 END
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.INV_A5000   = B.INV_A5000 --CASE WHEN B.INV_A5000 = 0 THEN NULL ELSE B.INV_A5000 END
    , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.INV_TOT_QTY = B.INV_E4000 + B.INV_A5000
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE A,
               (
                SELECT ITEM_ID, QTY_UOM, FP_APPLY_FACTORY_ID
                     , SUM(INV_E4000) AS INV_E4000
                     , SUM(INV_A5000) AS INV_A5000
                FROM   (
                        SELECT ITEM_ID, QTY_UOM, FP_APPLY_FACTORY_ID
                             , CASE FP_APPLY_OPERATION_ID WHEN 'E4000' THEN FP_APPLY_WIPQTY ELSE 0 END AS INV_E4000
                             , CASE FP_APPLY_OPERATION_ID WHEN 'A5000' THEN FP_APPLY_WIPQTY ELSE 0 END AS INV_A5000
                        FROM   (
                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, 
                                       A.ITEM_ID, A.QTY_UOM,
                                       CASE A.FACTORY_ID  WHEN 'E5' THEN 'A1'   -- 한국
                                                          WHEN 'E6' THEN 'A2'
                                                          WHEN 'E8' THEN 'A3'   -- 중국
                                                          WHEN 'EA' THEN 'A3'
                                                          WHEN 'E9' THEN 'A4'   -- 미국
                                                                    ELSE A.FACTORY_ID
                                       END  AS FP_APPLY_FACTORY_ID,
                                       A.FP_APPLY_OPERATION_ID, ISNULL(A.FP_APPLY_WIPQTY, 0) AS FP_APPLY_WIPQTY
                                FROM   SCM_MES_RT_STOCK_H A,
                                       (
                                        SELECT FACTORY_ID, MAX(CUTOFF_DATE) AS CUTOFF_DATE
                                        FROM   SCM_MES_RT_STOCK_H
                                        GROUP  BY FACTORY_ID
                                       ) B
                                WHERE  A.CUTOFF_DATE  = B.CUTOFF_DATE
                                AND    A.FACTORY_ID   = B.FACTORY_ID
                                AND    A.FP_APPLY_OPERATION_ID IN ('E4000','A5000')
                                AND    A.WIPHOLD_YN = 'N'
                                AND    A.ITEM_ID IN (
                                                     SELECT  ITEM_ID 
                                                     FROM    SCM_ITEM_M       A
                                                           , SCM_ITEM_CLASS_M B
                                                     WHERE   A.ITEM_CLASS   = B.CLASS_ID
                                                     AND     A.ACTIVE_FLAG  = 'Y'
                                                     AND     B.USE_FLAG     = 'Y'
                                                     AND     B.LEVEL_2_CODE = 'APC'
                                                    )
                                AND    ISNULL(A.FP_APPLY_WIPQTY, 0) > 0
                               ) A
                        WHERE  FP_APPLY_FACTORY_ID IS NOT NULL       
                       ) A
                GROUP  BY ITEM_ID, QTY_UOM, FP_APPLY_FACTORY_ID
               ) B
        WHERE  A.FACTORY_ID   = B.FP_APPLY_FACTORY_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    A.UOM          = B.QTY_UOM
      
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


        DELETE FROM TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
        WHERE  ISNULL(PLAN_TOT_QTY,0) + ISNULL(INV_TOT_QTY,0) = 0

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null


        UPDATE TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
        SET    TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.INV_HOLD = B.HOLD_QTY
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE A,
               (
                SELECT ITEM_ID, FP_APPLY_FACTORY_ID
                     , SUM(FP_APPLY_WIPQTY) AS HOLD_QTY
                FROM   (
                        SELECT A.ITEM_ID, A.QTY_UOM,
                               CASE A.FACTORY_ID  WHEN 'E5' THEN 'A1'   -- 한국
                                                  WHEN 'E6' THEN 'A2'
                                                  WHEN 'E8' THEN 'A3'   -- 중국
                                                  WHEN 'EA' THEN 'A3'
                                                  WHEN 'E9' THEN 'A4'   -- 미국
                                                            ELSE A.FACTORY_ID
                               END  AS FP_APPLY_FACTORY_ID,
                               A.FP_APPLY_OPERATION_ID, ISNULL(A.FP_APPLY_WIPQTY, 0) AS FP_APPLY_WIPQTY
                        FROM   SCM_MES_RT_STOCK_H A,
                               (
                                SELECT FACTORY_ID, MAX(CUTOFF_DATE) AS CUTOFF_DATE
                                FROM   SCM_MES_RT_STOCK_H
                                GROUP  BY FACTORY_ID
                               ) B
                        WHERE  A.CUTOFF_DATE  = B.CUTOFF_DATE
                        AND    A.FACTORY_ID   = B.FACTORY_ID
                        AND    A.FP_APPLY_OPERATION_ID IN ('E4000','A5000')
                        AND    A.WIPHOLD_YN = 'Y'
                        AND    ISNULL(A.FP_APPLY_WIPQTY, 0) > 0
                        AND    A.ITEM_ID IN (
                                             SELECT  ITEM_ID 
                                             FROM    SCM_ITEM_M       A
                                                   , SCM_ITEM_CLASS_M B
                                             WHERE   A.ITEM_CLASS   = B.CLASS_ID
                                             AND     A.ACTIVE_FLAG  = 'Y'
                                             AND     B.USE_FLAG     = 'Y'
                                             AND     B.LEVEL_2_CODE = 'APC'
                                            )
                       ) A
                GROUP  BY ITEM_ID, FP_APPLY_FACTORY_ID      
               ) B
        WHERE  A.FACTORY_ID   = B.FP_APPLY_FACTORY_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        
        UPDATE TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
        SET    TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.INTRANSIT = B.MOVE_ORD_QTY
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE A,
               (
                SELECT ITEM_ID, FP_APPLY_FACTORY_ID
                     , SUM(MOVE_ORD_QTY) AS MOVE_ORD_QTY
                FROM   (
                        SELECT A.PRODID AS ITEM_ID
                             , CASE A.FROM_AREAID WHEN 'E5' THEN 'A1'   -- 한국
                                                  WHEN 'E6' THEN 'A2'
                                                  WHEN 'E8' THEN 'A3'   -- 중국
                                                  WHEN 'EA' THEN 'A3'
                                                  WHEN 'E9' THEN 'A4'   -- 미국
                                                            ELSE A.FROM_AREAID
                            END  AS FP_APPLY_FACTORY_ID
                             , ISNULL(A.MOVE_ORD_QTY, 0) AS MOVE_ORD_QTY
                        FROM   SCM_MES_MOVE_H A,
                               (
                                SELECT FROM_AREAID, MAX(CUTOFF_DATE) AS CUTOFF_DATE
                                FROM   SCM_MES_MOVE_H
                                GROUP  BY FROM_AREAID
                               ) B
                        WHERE  A.CUTOFF_DATE = B.CUTOFF_DATE
                        AND    A.FROM_AREAID = B.FROM_AREAID
                        AND    A.MOVE_ORD_STAT_CODE = 'MOVING'
                        AND    A.FROM_PROCID        = 'E7000'
                       ) A
                GROUP  BY ITEM_ID, FP_APPLY_FACTORY_ID       
               ) B
        WHERE  A.FACTORY_ID   = B.FP_APPLY_FACTORY_ID
        AND    A.ITEM_ID      = B.ITEM_ID

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
        UPDATE TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
        SET    TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D0            = B.OS_D0
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D1            = B.OS_D1
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D2            = B.OS_D2
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D3            = B.OS_D3
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D4            = B.OS_D4
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D5            = B.OS_D5
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D6            = B.OS_D6
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D7            = B.OS_D7
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D8            = B.OS_D8
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D9            = B.OS_D9
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D10           = B.OS_D10
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D11           = B.OS_D11
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D12           = B.OS_D12
             , TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE.D13           = B.OS_D13
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE A,
               (
                SELECT A.*
                      , ISNULL(INV_TOT_QTY, 0.0) - D0   AS OS_D0
                      , ISNULL(INV_TOT_QTY, 0.0) - D1   AS OS_D1
                      , ISNULL(INV_TOT_QTY, 0.0) - D2   AS OS_D2
                      , ISNULL(INV_TOT_QTY, 0.0) - D3   AS OS_D3
                      , ISNULL(INV_TOT_QTY, 0.0) - D4   AS OS_D4
                      , ISNULL(INV_TOT_QTY, 0.0) - D5   AS OS_D5
                      , ISNULL(INV_TOT_QTY, 0.0) - D6   AS OS_D6
                      , ISNULL(INV_TOT_QTY, 0.0) - D7   AS OS_D7
                      , ISNULL(INV_TOT_QTY, 0.0) - D8   AS OS_D8
                      , ISNULL(INV_TOT_QTY, 0.0) - D9   AS OS_D9
                      , ISNULL(INV_TOT_QTY, 0.0) - D10  AS OS_D10
                      , ISNULL(INV_TOT_QTY, 0.0) - D11  AS OS_D11
                      , ISNULL(INV_TOT_QTY, 0.0) - D12  AS OS_D12
                      , ISNULL(INV_TOT_QTY, 0.0) - D13  AS OS_D13
                 FROM   TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE A
                 WHERE  CATEGORY = 'ACCUMULATE'               
               ) B
        WHERE  A.COMPANY_ID   = B.COMPANY_ID
        AND    A.DIVISION_ID  = B.DIVISION_ID
        AND    A.SITE_ID      = B.SITE_ID
        AND    A.PLANT_ID     = B.PLANT_ID
        AND    A.FACTORY_ID   = B.FACTORY_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    A.UOM          = B.UOM
        AND    A.CATEGORY     = 'OSQT'

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


        INSERT INTO TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
             (
               COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , ELECTRODE_TYPE
             , ITEM_ID
             , INV_A5000
             , INV_E4000
             , INV_HOLD
             , INTRANSIT
             , INV_TOT_QTY
             , PLAN_TOT_QTY
             , CATEGORY
             , UOM
             , D0_DATE
             , D0
             , D1
             , D2
             , D3
             , D4
             , D5
             , D6
             , D7
             , D8
             , D9
             , D10
             , D11
             , D12
             , D13
             , INSERT_ID
             , INSERT_TIME
             )
        SELECT
               A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.ELECTRODE_TYPE
             , A.ITEM_ID
             , CEILING(A.INV_A5000    / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))   AS INV_A5000
             , CEILING(A.INV_E4000    / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))   AS INV_E4000
             , CEILING(A.INV_HOLD     / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))   AS INV_HOLD
             , CEILING(A.INTRANSIT    / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))   AS INTRANSIT
             , CEILING(A.INV_TOT_QTY  / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))   AS INV_TOT_QTY
             , CEILING(A.PLAN_TOT_QTY / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))   AS PLAN_TOT_QTY
             , A.CATEGORY
             , 'EA'       AS UOM
             , A.D0_DATE
             , CEILING(ABS(A.D0  / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D0)  AS D0
             , CEILING(ABS(A.D1  / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D1)  AS D1
             , CEILING(ABS(A.D2  / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D2)  AS D2
             , CEILING(ABS(A.D3  / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D3)  AS D3
             , CEILING(ABS(A.D4  / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D4)  AS D4
             , CEILING(ABS(A.D5  / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D5)  AS D5
             , CEILING(ABS(A.D6  / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D6)  AS D6
             , CEILING(ABS(A.D7  / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D7)  AS D7
             , CEILING(ABS(A.D8  / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D8)  AS D8
             , CEILING(ABS(A.D9  / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D9)  AS D9
             , CEILING(ABS(A.D10 / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D10) AS D10
             , CEILING(ABS(A.D11 / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D11) AS D11
             , CEILING(ABS(A.D12 / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D12) AS D12
             , CEILING(ABS(A.D13 / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length))) * SIGN(A.D13) AS D13
             , A.INSERT_ID
             , A.INSERT_TIME
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE A
               INNER JOIN (
                            SELECT ITEM_ID, FP_APPLY_FACTORY_ID, MAX(PC_ROLL_LENGTH) AS PC_ROLL_LENGTH
                            FROM   (
                                    SELECT ITEM_ID
                                         , CASE FACTORY_ID  WHEN 'E5' THEN 'A1'   -- 한국
                                                            WHEN 'E6' THEN 'A2'
                                                            WHEN 'E8' THEN 'A3'   -- 중국
                                                            WHEN 'EA' THEN 'A3'
                                                            WHEN 'E9' THEN 'A4'   -- 미국
                                                                     ELSE FACTORY_ID
                                           END  AS FP_APPLY_FACTORY_ID
                                         , ISNULL(PC_ROLL_LENGTH, 0) AS PC_ROLL_LENGTH
                                    FROM   SCM_ITEM_LANE_M
                                    WHERE  ISNULL(PC_ROLL_LENGTH, 0) > 0
                                   ) A
                            GROUP  BY ITEM_ID, FP_APPLY_FACTORY_ID
                           ) B
                    ON    A.ITEM_ID = B.ITEM_ID
                    AND   A.FACTORY_ID = B.FP_APPLY_FACTORY_ID
        WHERE   UOM = 'M'            

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


      
        DELETE FROM FP_PANCAKE_INVENTORY_BALANCE_M_R
        
        INSERT INTO FP_PANCAKE_INVENTORY_BALANCE_M_R
             (
               COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , ELECTRODE_TYPE
             , ITEM_ID
             , INV_A5000
             , INV_E4000
             , INV_HOLD
             , INTRANSIT
             , INV_TOT_QTY
             , PLAN_TOT_QTY
             , CATEGORY
             , UOM
             , D0_DATE
             , D0
             , D1
             , D2
             , D3
             , D4
             , D5
             , D6
             , D7
             , D8
             , D9
             , D10
             , D11
             , D12
             , D13
             , INSERT_ID
             , INSERT_TIME
             )
        SELECT 
               COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , ELECTRODE_TYPE
             , ITEM_ID
             , INV_A5000
             , INV_E4000
             , INV_HOLD
             , INTRANSIT
             , INV_TOT_QTY
             , PLAN_TOT_QTY
             , CATEGORY
             , UOM
             , D0_DATE
             , D0
             , D1
             , D2
             , D3
             , D4
             , D5
             , D6
             , D7
             , D8
             , D9
             , D10
             , D11
             , D12
             , D13
             , @v_proc_name AS INSERT_ID
             , GETDATE()    AS INSERT_TIME        
        FROM   TH_BUF_SCM_PANCAKE_INVENTORY_BALANCE
        WHERE  1=1
        --AND    DIVISION_ID = '81'         -- ## 자동차만
        AND    DIVISION_ID IN ('81', '81_GM')         -- ## 자동차만, division 별 type 구분자가 없어서 hard coding 
      
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'FP_PANCAKE_INVENTORY_BALANCE_M_R'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END
            
      -- FP_PANCAKE_INVENTORY_BALANCE_S_R 생성
      IF 1=1
      BEGIN
      
        DELETE FROM TH_BUF_SCM_PANCAKE_INVENTORY_SUB
        
        INSERT INTO TH_BUF_SCM_PANCAKE_INVENTORY_SUB
             (
               CUTOFF_DATE
             , ID
             , ITEM_ID
             , FACTORY_ID
             , MAIN_FACTORY_ID
             , ACTUAL_GOOD_QTY
             , HOLD_RELEASE_QTY
             , IN_QTY
             , OUT_QTY
             )        
        SELECT A.CALDATE        AS CUTOFF_DATE
             , A.LOTID          AS ID
             , A.PRODID         AS ITEM_ID
             , A.FACTORY_ID
             , CASE A.FACTORY_ID  WHEN 'E5' THEN 'A1'   -- 한국
                                  WHEN 'E6' THEN 'A2'
                                  WHEN 'E8' THEN 'A3'   -- 중국
                                  WHEN 'EA' THEN 'A3'
                                  WHEN 'E9' THEN 'A4'   -- 미국
                                            ELSE A.FACTORY_ID
               END  AS MAIN_FACTORY_ID
             , A.WIPQTY2_ED     AS ACTUAL_GOOD_QTY
             , 0                AS HOLD_RELEASE_QTY
             , 0                AS IN_QTY
             , 0                AS OUT_QTY
        FROM   SCM_MES_RT_WIP_HISTORY_H A,
               TH_BUF_SCM_PANCAKE_INVENTORY_BASIS_TIME B
        WHERE  A.FACTORY_ID = B.FACTORY_ID
        AND    A.CALDATE   >= B.PLAN_START_TIME
        --AND    A.CALDATE = ( SELECT MAX(CALDATE) FROM SCM_MES_RT_WIP_HISTORY_H )
        AND    A.PROCID = 'E4000'
        AND    A.PRODID IN (
                             SELECT  ITEM_ID 
                             FROM    SCM_ITEM_M       A
                                   , SCM_ITEM_CLASS_M B
                             WHERE   A.ITEM_CLASS   = B.CLASS_ID
                             AND     A.ACTIVE_FLAG  = 'Y'
                             AND     B.USE_FLAG     = 'Y'
                             AND     B.LEVEL_2_CODE = 'APC'
                           )
      
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_SUB'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        INSERT INTO TH_BUF_SCM_PANCAKE_INVENTORY_SUB
             (
               CUTOFF_DATE
             , ID
             , ITEM_ID
             , FACTORY_ID
             , MAIN_FACTORY_ID
             , ACTUAL_GOOD_QTY
             , HOLD_RELEASE_QTY
             , IN_QTY
             , OUT_QTY
             )             
        SELECT A.CUTOFF_DATE
             , A.LOTID            AS ID
             , A.ITEM_ID
             , A.FACTORY_ID
             , CASE A.FACTORY_ID  WHEN 'E5' THEN 'A1'   -- 한국
                                  WHEN 'E6' THEN 'A2'
                                  WHEN 'E8' THEN 'A3'   -- 중국
                                  WHEN 'EA' THEN 'A3'
                                  WHEN 'E9' THEN 'A4'   -- 미국
                                            ELSE A.FACTORY_ID
               END  AS MAIN_FACTORY_ID
             , 0                      AS ACTUAL_GOOD_QTY
             , ISNULL(A.HOLD_QTY2, 0) AS HOLD_RELEASE_QTY
             , 0                      AS IN_QTY
             , 0                      AS OUT_QTY
        FROM   SCM_MES_WIP_HOLD_HISTORY_H A,
               TH_BUF_SCM_PANCAKE_INVENTORY_BASIS_TIME B
        WHERE  A.FACTORY_ID   = B.FACTORY_ID
        AND    A.CUTOFF_DATE >= B.PLAN_START_TIME
        --AND    CUTOFF_DATE = ( SELECT MAX(CUTOFF_DATE) FROM SCM_MES_WIP_HOLD_HISTORY_H )
        AND    A.HOLD_FLAG    = 'N'
        AND    A.ITEM_ID IN (
                             SELECT  ITEM_ID 
                             FROM    SCM_ITEM_M       A
                                   , SCM_ITEM_CLASS_M B
                             WHERE   A.ITEM_CLASS   = B.CLASS_ID
                             AND     A.ACTIVE_FLAG  = 'Y'
                             AND     B.USE_FLAG     = 'Y'
                             AND     B.LEVEL_2_CODE = 'APC'
                            )
    AND    A.OPERATION_ID = 'E7000'

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_SUB'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        INSERT INTO TH_BUF_SCM_PANCAKE_INVENTORY_SUB
             (
               CUTOFF_DATE
             , ID
             , ITEM_ID
             , FACTORY_ID
             , MAIN_FACTORY_ID
             , ACTUAL_GOOD_QTY
             , HOLD_RELEASE_QTY
             , IN_QTY
             , OUT_QTY
             )        
        SELECT A.CUTOFF_DATE
             , A.MOVE_ORD_ID    AS ID
             , A.PRODID         AS ITEM_ID
             , A.FROM_AREAID    AS FACTORY_ID
             , CASE A.FROM_AREAID WHEN 'E5' THEN 'A1'   -- 한국
                                  WHEN 'E6' THEN 'A2'
                                  WHEN 'E8' THEN 'A3'   -- 중국
                                  WHEN 'EA' THEN 'A3'
                                  WHEN 'E9' THEN 'A4'   -- 미국
                                            ELSE A.FROM_AREAID
               END  AS MAIN_FACTORY_ID
             , 0                AS ACTUAL_GOOD_QTY
             , 0                AS HOLD_RELEASE_QTY
             , 0                AS IN_QTY
             , A.MOVE_ORD_QTY   AS OUT_QTY
        FROM   SCM_MES_MOVE_H A,
               TH_BUF_SCM_PANCAKE_INVENTORY_BASIS_TIME B
        WHERE  A.FROM_AREAID  = B.FACTORY_ID
        AND    A.CUTOFF_DATE >= B.PLAN_START_TIME
        --AND    CUTOFF_DATE = (SELECT MAX(CUTOFF_DATE) FROM SCM_MES_MOVE_H )
        AND    A.MOVE_ORD_STAT_CODE = 'CLOSE_MOVE'
        AND    A.MOVE_TYPE_CODE     = 'MOVE_AREA'
        AND    A.FROM_PROCID        = 'E7000'
        AND    A.TO_PROCID          = 'E7000'

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_SUB'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        INSERT INTO TH_BUF_SCM_PANCAKE_INVENTORY_SUB
             (
               CUTOFF_DATE
             , ID
             , ITEM_ID
             , FACTORY_ID
             , MAIN_FACTORY_ID
             , ACTUAL_GOOD_QTY
             , HOLD_RELEASE_QTY
             , IN_QTY
             , OUT_QTY
             )        
        SELECT A.CUTOFF_DATE
             , A.MOVE_ORD_ID    AS ID
             , A.PRODID         AS ITEM_ID
             , A.TO_AREAID      AS FACTORY_ID
             , CASE A.TO_AREAID WHEN 'E5' THEN 'A1'   -- 한국
                                WHEN 'E6' THEN 'A2'
                                WHEN 'E8' THEN 'A3'   -- 중국
                                WHEN 'EA' THEN 'A3'
                                WHEN 'E9' THEN 'A4'   -- 미국
                                          ELSE A.TO_AREAID
               END  AS MAIN_FACTORY_ID
             , 0                AS ACTUAL_GOOD_QTY
             , 0                AS HOLD_RELEASE_QTY
             , A.MOVE_CMPL_QTY  AS IN_QTY
             , 0                AS OUT_QTY
        FROM   SCM_MES_MOVE_H A,
               TH_BUF_SCM_PANCAKE_INVENTORY_BASIS_TIME B
        WHERE  A.TO_AREAID    = B.FACTORY_ID
        AND    A.CUTOFF_DATE >= B.PLAN_START_TIME
        --AND    CUTOFF_DATE = (SELECT MAX(CUTOFF_DATE) FROM SCM_MES_MOVE_H )
        AND    A.MOVE_ORD_STAT_CODE = 'CLOSE_MOVE'
        AND    A.MOVE_TYPE_CODE     = 'MOVE_AREA'
        AND    A.FROM_PROCID        = 'E7000'
        AND    A.TO_PROCID          = 'E7000'


        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'TH_BUF_SCM_PANCAKE_INVENTORY_SUB'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        DELETE FROM FP_PANCAKE_INVENTORY_BALANCE_S_R
        
        INSERT INTO FP_PANCAKE_INVENTORY_BALANCE_S_R
             (
               COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , MAIN_FACTORY_ID
             , ELECTRODE_TYPE
             , ITEM_ID
             , UOM
             , ACTUAL_GOOD_QTY
             , HOLD_RELEASE_QTY
             , IN_QTY
             , OUT_QTY
             , INSERT_ID
             , INSERT_TIME
             )
        SELECT B.COMPANY_ID
             , B.DIVISION_ID
             , B.SITE_ID
             , B.PLANT_ID
             , A.FACTORY_ID
             , A.MAIN_FACTORY_ID
             , NULL         AS ELECTRODE_TYPE
             , A.ITEM_ID
             , 'M'          AS UOM
             , A.ACTUAL_GOOD_QTY
             , A.HOLD_RELEASE_QTY
             , A.IN_QTY
             , A.OUT_QTY
             , @v_proc_name AS INSERT_ID
             , GETDATE()    AS INSERT_TIME
        FROM   (
                SELECT
                       ITEM_ID
                     , FACTORY_ID
                     , MAIN_FACTORY_ID
                     , SUM(ACTUAL_GOOD_QTY)   AS ACTUAL_GOOD_QTY
                     , SUM(HOLD_RELEASE_QTY)  AS HOLD_RELEASE_QTY
                     , SUM(IN_QTY)            AS IN_QTY
                     , SUM(OUT_QTY)           AS OUT_QTY
                FROM   TH_BUF_SCM_PANCAKE_INVENTORY_SUB
                GROUP  BY 
                       ITEM_ID
                     , FACTORY_ID
                     , MAIN_FACTORY_ID
               ) A,
               SCM_FACTORY_M B
        WHERE  A.FACTORY_ID = B.FACTORY_ID
        --AND    B.DIVISION_ID = '81'         -- ## 자동차만
		AND    B.DIVISION_ID IN ('81', '81_GM')         -- ## 자동차만, division 별 type 구분자가 없어서 hard coding 
		
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'FP_PANCAKE_INVENTORY_BALANCE_S_R'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        UPDATE FP_PANCAKE_INVENTORY_BALANCE_S_R
        SET    FP_PANCAKE_INVENTORY_BALANCE_S_R.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        FROM   FP_PANCAKE_INVENTORY_BALANCE_S_R A,
               SCM_ITEM_LINE_ASSIGN_M B
        WHERE  A.COMPANY_ID   = B.COMPANY_ID
        AND    A.DIVISION_ID  = B.DIVISION_ID
        AND    A.SITE_ID      = B.SITE_ID
        AND    A.PLANT_ID     = B.PLANT_ID
        AND    A.FACTORY_ID   = B.FACTORY_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    B.ACTIVE_FLAG  = 'Y'
        AND    B.OPERATION_ID = 'E4000'
        AND    A.ELECTRODE_TYPE IS NULL

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'FP_PANCAKE_INVENTORY_BALANCE_S_R'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE FP_PANCAKE_INVENTORY_BALANCE_S_R
        SET    FP_PANCAKE_INVENTORY_BALANCE_S_R.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        FROM   FP_PANCAKE_INVENTORY_BALANCE_S_R A,
               SCM_ITEM_LINE_ASSIGN_M B
        WHERE  A.COMPANY_ID   = B.COMPANY_ID
        AND    A.DIVISION_ID  = B.DIVISION_ID
        AND    A.SITE_ID      = B.SITE_ID
        AND    A.PLANT_ID     = B.PLANT_ID
        AND    A.FACTORY_ID   = B.FACTORY_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    B.ACTIVE_FLAG  = 'Y'
        AND    B.OPERATION_ID = 'E3000'
        AND    A.ELECTRODE_TYPE IS NULL

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'FP_PANCAKE_INVENTORY_BALANCE_S_R'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        --LOG 생성
        SET @v_table_name = 'FP_PANCAKE_INVENTORY_BALANCE_S_R'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE FP_PANCAKE_INVENTORY_BALANCE_S_R
        SET    FP_PANCAKE_INVENTORY_BALANCE_S_R.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        FROM   FP_PANCAKE_INVENTORY_BALANCE_S_R A,
               SCM_ITEM_LINE_ASSIGN_M B
        WHERE  A.COMPANY_ID   = B.COMPANY_ID
        AND    A.DIVISION_ID  = B.DIVISION_ID
        AND    A.SITE_ID      = B.SITE_ID
        AND    A.PLANT_ID     = B.PLANT_ID
        AND    A.FACTORY_ID   = B.FACTORY_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    B.ACTIVE_FLAG  = 'Y'
        AND    B.OPERATION_ID = 'E2000'
        AND    A.ELECTRODE_TYPE IS NULL

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'FP_PANCAKE_INVENTORY_BALANCE_S_R'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE FP_PANCAKE_INVENTORY_BALANCE_S_R
        SET    FP_PANCAKE_INVENTORY_BALANCE_S_R.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        FROM   FP_PANCAKE_INVENTORY_BALANCE_S_R A,
               SCM_ITEM_LINE_ASSIGN_M B
        WHERE  A.COMPANY_ID   = B.COMPANY_ID
        AND    A.DIVISION_ID  = B.DIVISION_ID
        AND    A.SITE_ID      = B.SITE_ID
        AND    A.PLANT_ID     = B.PLANT_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    B.ACTIVE_FLAG  = 'Y'
        AND    A.ELECTRODE_TYPE IS NULL

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'FP_PANCAKE_INVENTORY_BALANCE_S_R'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


        INSERT INTO FP_PANCAKE_INVENTORY_BALANCE_S_R
             (
               COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , MAIN_FACTORY_ID
             , ELECTRODE_TYPE
             , ITEM_ID
             , UOM
             , ACTUAL_GOOD_QTY
             , HOLD_RELEASE_QTY
             , IN_QTY
             , OUT_QTY
             , INSERT_ID
             , INSERT_TIME
             )
        SELECT 
               A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.MAIN_FACTORY_ID
             , A.ELECTRODE_TYPE
             , A.ITEM_ID
             , 'EA'       AS UOM
             , CEILING(A.ACTUAL_GOOD_QTY  / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length)) AS ACTUAL_GOOD_QTY
             , CEILING(A.HOLD_RELEASE_QTY / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length)) AS HOLD_RELEASE_QTY
             , CEILING(A.IN_QTY           / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length)) AS IN_QTY
             , CEILING(A.OUT_QTY          / ISNULL(PC_ROLL_LENGTH, @v_default_roll_length)) AS OUT_QTY
             , A.INSERT_ID
             , A.INSERT_TIME
        FROM   FP_PANCAKE_INVENTORY_BALANCE_S_R A
               INNER JOIN (
                                SELECT ITEM_ID
                                     , FACTORY_ID
                                     , ISNULL(PC_ROLL_LENGTH, 0) AS PC_ROLL_LENGTH
                                     , PC_ROLL_LENGTH_UOM
                                FROM   SCM_ITEM_LANE_M
                                WHERE  ISNULL(PC_ROLL_LENGTH, 0) > 0
                               ) B
                    ON    A.ITEM_ID = B.ITEM_ID
                    AND   A.FACTORY_ID = B.FACTORY_ID
        WHERE   UOM = 'M'
        
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_table_name = 'FP_PANCAKE_INVENTORY_BALANCE_S_R'
        SET @v_message    = @n_row_count
        SET @n_log_count  = @n_log_count + 1
        SET @sysdate      = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

    END
    
    IF @@TRANCOUNT > 0
      COMMIT WORK 
        
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
    
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

	EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

END
