CREATE PROCEDURE [dbo].[PR_SCM_MF_MULTI_ROUTE_ENG]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_MULTI_ROUTE_ENG                                                 **/
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
/***********************************************************************************************/
/*
  EXEC PR_SCM_MF_MULTI_ROUTE_ENG
  
  ITEM_ID 가 들어 있는 부분에 대해 변경작업 처리한다.

  TH_ENG_ITEM                     -- INSERT 
  TH_ENG_ITEM_CAL                 -- INSERT 
  TH_ENG_SALES_PRODUCT_MAP        -- INSERT  
  TH_ENG_SALES_PRODUCT_MAP_CAL    -- INSERT  
  TH_ENG_PLAN_BOM                 -- INSERT 
  TH_ENG_PLAN_BOM                             -- UPDATE 
  TH_ENG_PLAN_BOM_CAL                         -- UPDATE 
  TH_ENG_ITEM_ROUTE_SITE                      -- UPDATE 
  TH_ENG_OP_RES_GROUP                         -- UPDATE 
  TH_ENG_OP_RES_GROUP_CAL                     -- UPDATE 
  TH_ENG_OP_RES_GROUP_MAP                     -- UPDATE 
  TH_ENG_OP_RES_GROUP_MAP_CAL                 -- UPDATE 
  TH_ENG_PRODUCT_MIX_MAP                      -- UPDATE   
  TH_ENG_FIXED_PLAN                           -- UPDATE 
  TH_ENG_STOCK_PLAN                           -- UPDATE
  TH_ENG_WIP                                  -- UPDATE
  
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_MF_MULTI_ROUTE_ENG'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()

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
              @plan_end_time   = PLAN_END_DTTM
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM
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
      
        SET @v_table_name = 'TH_BUF_SCM_MULTI_ROUTING'
        
        DELETE FROM TH_BUF_SCM_MULTI_ROUTING
        
        INSERT INTO TH_BUF_SCM_MULTI_ROUTING
        SELECT MASTER_ID, PLAN_ID, ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, OPERATION_SEQ, FLOW_ID,
               ITEM_ID + '_' + OPERATION_ID NEW_ITEM_ID, SEQ,
               MAX(SEQ) OVER (PARTITION BY ITEM_ID, SITE_ID, FLOW_ID) MAX_SEQ
        FROM   (
                SELECT MASTER_ID, PLAN_ID, ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, OPERATION_SEQ, FLOW_ID,
                       DENSE_RANK() OVER (PARTITION BY ITEM_ID, SITE_ID, FLOW_ID ORDER BY OPERATION_SEQ) SEQ
                FROM   TH_ENG_ITEM_ROUTE_SITE A
                WHERE  MASTER_ID = @v_master_id
                AND    PLAN_ID = @v_plan_id
                /*
                AND    EXISTS  ( -- OP RESOURCE 에 등록된 것만..
                                SELECT 1
                                FROM   TH_ENG_OP_RES_GROUP_MAP K
                                WHERE  K.MASTER_ID = A.MASTER_ID
                                AND    K.PLAN_ID = A.PLAN_ID
                                AND    K.ITEM_ID = A.ITEM_ID
                                AND    K.SITE_ID = A.SITE_ID
                                AND    K.ROUTE_ID = A.ROUTE_ID
                                AND    K.OPERATION_ID = A.OPERATION_ID
                               )    
                */
                AND    EXISTS  (                
                                SELECT 1
                                FROM   (-- MULTI OPERATION 인데 ROUTE_ID 가 다른 경우
                                        SELECT ITEM_ID, FLOW_ID, SITE_ID
                                        FROM   TH_ENG_ITEM_ROUTE_SITE
                                        WHERE  MASTER_ID = @v_master_id
                                        AND    PLAN_ID = @v_plan_id
                                        GROUP  BY ITEM_ID, FLOW_ID, SITE_ID
                                        HAVING MIN(OPERATION_ID) <> MAX(OPERATION_ID)
                                           AND MIN(ROUTE_ID) <> MAX(ROUTE_ID)
                                       ) X
                                WHERE  X.ITEM_ID = A.ITEM_ID
                                AND    X.FLOW_ID = A.FLOW_ID
                                AND    X.SITE_ID = A.SITE_ID
                               )
               ) A

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
      
        SET @v_table_name = 'TH_ENG_ITEM'

        INSERT INTO TH_ENG_ITEM
                (
                  MASTER_ID
                , PLAN_ID
                , ITEM_ID
                , ITEM_TYPE
                , ITEM_UOM
                , FLOW_ID
                , ITEM_GROUP_ID
                , SETUP_GROUP_ID
                , IS_FINITE
                , FINITE_TERM
                , FINITE_TERM_UOM
                , SAFETY_STOCK_QTY
                , MAX_STOCK_QTY
                , MIN_SAFETY_TERM
                , MIN_SAFETY_TERM_UOM
                , BUFFER_TIME
                , BUFFER_TIME_UOM
                , MIN_LOT_SIZE
                , MAX_LOT_SIZE
                , INCREMENT_LOT_SIZE
                , ATTRIBUTE_SET_ID
                , DESCR
                , ITEM_UOM_RATE
                )
        SELECT    DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , 'H' ITEM_TYPE
                , A.ITEM_UOM
                , A.FLOW_ID
                , A.ITEM_GROUP_ID
                , A.SETUP_GROUP_ID
                , A.IS_FINITE
                --,'N'            AS IS_FINITE
                , A.FINITE_TERM
                , A.FINITE_TERM_UOM
                , A.SAFETY_STOCK_QTY
                , A.MAX_STOCK_QTY
                , A.MIN_SAFETY_TERM
                , A.MIN_SAFETY_TERM_UOM
                , A.BUFFER_TIME
                , A.BUFFER_TIME_UOM
                , A.MIN_LOT_SIZE
                , A.MAX_LOT_SIZE
                , A.INCREMENT_LOT_SIZE
                , A.ATTRIBUTE_SET_ID
                , A.DESCR
                , A.ITEM_UOM_RATE
        FROM    TH_ENG_ITEM A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     B.SEQ > 1

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        UPDATE  TH_ENG_ITEM 
        SET     TH_ENG_ITEM.ITEM_TYPE = 'H'
        FROM    TH_ENG_ITEM A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     A.ITEM_TYPE = 'P'
        AND     B.SEQ = 1

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ITEM_CAL'

        INSERT INTO TH_ENG_ITEM_CAL
                (
                  MASTER_ID
                , PLAN_ID
                , ITEM_ID
                , START_DTTM
                , END_DTTM
                , IS_USE
                , DESCR
                )
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.START_DTTM
                , A.END_DTTM
                , A.IS_USE
                , A.DESCR
        FROM    TH_ENG_ITEM_CAL A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     B.SEQ > 1
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_SALES_PRODUCT_MAP'

        INSERT  INTO TH_ENG_SALES_PRODUCT_MAP        
        SELECT  DISTINCT
                A.MASTER_ID
              , A.PLAN_ID
              , A.SALES_MODEL_ID
              , B.NEW_ITEM_ID AS PRODUCT_ITEM_ID
              , A.SITE_ID
              , A.ALT_PRIORITY
              , A.ALT_RATE
              , A.DESCR
        FROM    TH_ENG_SALES_PRODUCT_MAP A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.PRODUCT_ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     B.SEQ   = B.MAX_SEQ
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE  FROM A
        FROM    TH_ENG_SALES_PRODUCT_MAP A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.PRODUCT_ITEM_ID = B.ITEM_ID
        --AND     A.SITE_ID != B.SITE_ID
        AND     B.SEQ   = B.MAX_SEQ
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_SALES_PRODUCT_MAP_CAL'

        INSERT  INTO TH_ENG_SALES_PRODUCT_MAP_CAL
        SELECT  DISTINCT
                A.MASTER_ID
              , A.PLAN_ID
              , A.SALES_MODEL_ID
              , B.NEW_ITEM_ID AS PRODUCT_ITEM_ID
              , A.SITE_ID
              , A.START_DTTM
              , A.END_DTTM
              , A.ALT_PRIORITY
              , A.ALT_RATE
              , A.IS_USE
              , A.DESCR
        FROM    TH_ENG_SALES_PRODUCT_MAP_CAL A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.PRODUCT_ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     B.SEQ   = B.MAX_SEQ

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        DELETE  FROM A
        FROM    TH_ENG_SALES_PRODUCT_MAP_CAL A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.PRODUCT_ITEM_ID = B.ITEM_ID
        --AND     A.SITE_ID = B.SITE_ID
        AND     B.SEQ   = B.MAX_SEQ

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
            
      END
          
      BEGIN
      
        SET @v_table_name = 'TH_ENG_PLAN_BOM'

        INSERT INTO TH_ENG_PLAN_BOM
                (
                  MASTER_ID
                , PLAN_ID
                , PARENT_ITEM_ID
                , CHILD_ITEM_ID
                , SITE_ID
                , ROUTE_ID
                , OPERATION_ID
                , BINNING_ID
                , PRODUCTION_FLAG
                , BOM_VERSION_ID
                , PARENT_ITEM_RATE
                , CHILD_ITEM_RATE
                , ALT_ID
                , ALT_PRIORITY
                , ALT_RATE
                , IN_MOVE_TIME
                , OUT_MOVE_TIME
                , MOVE_TIME_UOM
                , DESCR
                )
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_PARENT_ITEM_ID  AS PARENT_ITEM_ID
                , B.NEW_CHILD_ITEM_ID   AS CHILD_ITEM_ID
                , B.SITE_ID
                , B.ROUTE_ID
                , B.OPERATION_ID
                , '-' BINNING_ID
                , 'Y' PRODUCTION_FLAG
                , A.BOM_VERSION_ID
                , 1 PARENT_ITEM_RATE
                , 1 CHILD_ITEM_RATE
                , NULL AS ALT_ID          -- 상위 OPERATION 을 BOM 으로 하는 것이라 NULL 해도 무방함
                , NULL AS ALT_PRIORITY
                , NULL AS ALT_RATE
                , 0 IN_MOVE_TIME
                , 0 OUT_MOVE_TIME
                , 'MINUTE' MOVE_TIME_UOM
                , A.DESCR
        FROM    TH_ENG_PLAN_BOM A,
                (
                 SELECT A.MASTER_ID, A.PLAN_ID, 
                        A.ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID,
                        A.NEW_ITEM_ID AS NEW_PARENT_ITEM_ID,
                        CASE WHEN B.SEQ = 1 THEN B.ITEM_ID 
                                            ELSE B.NEW_ITEM_ID 
                        END  AS NEW_CHILD_ITEM_ID
                 FROM   TH_BUF_SCM_MULTI_ROUTING A,
                        TH_BUF_SCM_MULTI_ROUTING B
                 WHERE  A.MASTER_ID = @v_master_id
                 AND    A.PLAN_ID = @v_plan_id
                 AND    A.MASTER_ID = B.MASTER_ID
                 AND    A.PLAN_ID = B.PLAN_ID
                 AND    A.ITEM_ID = B.ITEM_ID
                 AND    A.SITE_ID = B.SITE_ID
                 AND    A.FLOW_ID = B.FLOW_ID
                 AND    A.SEQ     = B.SEQ + 1
                 --AND    A.SEQ     < A.MAX_SEQ
                ) B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.PARENT_ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_PLAN_BOM'

        -- 최종 완료 OPERATION 이 다음 투입이 있을 경우 보정처리
        UPDATE TH_ENG_PLAN_BOM
        SET    TH_ENG_PLAN_BOM.CHILD_ITEM_ID = B.NEW_ITEM_ID
        FROM   TH_ENG_PLAN_BOM A,
               TH_BUF_SCM_MULTI_ROUTING B
        WHERE  A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.CHILD_ITEM_ID = B.ITEM_ID
        AND    CHARINDEX(B.ITEM_ID, A.PARENT_ITEM_ID) = 0   -- 동일 ITEM 으로 파생된 BOM 은 제외
        AND    B.SEQ = B.MAX_SEQ
        AND    A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    EXISTS (
                        SELECT 1
                        FROM   TH_ENG_PLAN_BOM C
                        WHERE  1=1
                        AND    B.MASTER_ID = C.MASTER_ID
                        AND    B.PLAN_ID = C.PLAN_ID
                        AND    B.NEW_ITEM_ID = C.PARENT_ITEM_ID
                        AND    B.SITE_ID = C.SITE_ID
                        AND    B.ROUTE_ID = C.ROUTE_ID
                        AND    B.OPERATION_ID = C.OPERATION_ID
                      )
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END
      
/*
      BEGIN
      
        SET @v_table_name = 'TH_ENG_PLAN_BOM_CAL'

        UPDATE  TH_ENG_PLAN_BOM_CAL
        SET     TH_ENG_PLAN_BOM_CAL.CHILD_ITEM_ID = B.NEW_ITEM_ID
        FROM    TH_ENG_PLAN_BOM_CAL A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.CHILD_ITEM_ID = B.ITEM_ID
        AND     B.SEQ   = B.MAX_SEQ
        AND     B.MAX_SEQ > 2   -- MAX 가 2 LEVEL 인데 바뀌면 무한 LOOP 가 돌더라. 췟..
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END
*/
      BEGIN
      
        
        SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE'

        UPDATE  TH_ENG_ITEM_ROUTE_SITE
        SET     TH_ENG_ITEM_ROUTE_SITE.FLOW_ID = A.OPERATION_ID
        FROM    TH_ENG_ITEM_ROUTE_SITE A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        
        UPDATE  TH_ENG_ITEM_ROUTE_SITE
        SET     TH_ENG_ITEM_ROUTE_SITE.ITEM_ID = B.NEW_ITEM_ID
        FROM    TH_ENG_ITEM_ROUTE_SITE A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID
        --AND     A.FLOW_ID = B.FLOW_ID
        AND     B.SEQ > 1

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        /*
        DELETE  FROM AA
        FROM    TH_ENG_ITEM_ROUTE_SITE AS AA
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        AND     EXISTS ( 
                        SELECT '1'
                        FROM   (
                                SELECT  A.* 
                                FROM    TH_ENG_ITEM_ROUTE_SITE A,
                                        TH_BUF_SCM_MULTI_ROUTING B
                                WHERE   A.MASTER_ID     = @v_master_id
                                AND     A.PLAN_ID       = @v_plan_id
                                AND     A.MASTER_ID     = B.MASTER_ID
                                AND     A.PLAN_ID       = B.PLAN_ID
                                AND     A.ITEM_ID       = B.ITEM_ID
                                AND     A.SITE_ID       = B.SITE_ID
                                AND     A.ROUTE_ID     != B.ROUTE_ID
                                AND     A.OPERATION_ID  = B.OPERATION_ID
                               ) X
                        WHERE  X.MASTER_ID    = AA.MASTER_ID
                        AND    X.PLAN_ID      = AA.PLAN_ID
                        AND    X.ITEM_ID      = AA.ITEM_ID
                        AND    X.SITE_ID      = AA.SITE_ID
                        AND    X.ROUTE_ID     = AA.ROUTE_ID
                        AND    X.OPERATION_ID = AA.OPERATION_ID
                      )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
        */
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP'

        UPDATE  TH_ENG_OP_RES_GROUP
        SET     TH_ENG_OP_RES_GROUP.ITEM_ID = B.NEW_ITEM_ID
        FROM    TH_ENG_OP_RES_GROUP A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID
        AND     B.SEQ > 1

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP'

        UPDATE  TH_ENG_OP_RES_GROUP_MAP
        SET     TH_ENG_OP_RES_GROUP_MAP.ITEM_ID = B.NEW_ITEM_ID
        FROM    TH_ENG_OP_RES_GROUP_MAP A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID
        AND     B.SEQ > 1
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_CAL'

        UPDATE  TH_ENG_OP_RES_GROUP_CAL
        SET     TH_ENG_OP_RES_GROUP_CAL.ITEM_ID = B.NEW_ITEM_ID
        FROM    TH_ENG_OP_RES_GROUP_CAL A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID
        AND     B.SEQ > 1
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP_CAL'

        UPDATE  TH_ENG_OP_RES_GROUP_MAP_CAL
        SET     TH_ENG_OP_RES_GROUP_MAP_CAL.ITEM_ID = B.NEW_ITEM_ID
        FROM    TH_ENG_OP_RES_GROUP_MAP_CAL A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID
        AND     B.SEQ > 1

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_PRODUCT_MIX_MAP'

        UPDATE  TH_ENG_PRODUCT_MIX_MAP
        SET     TH_ENG_PRODUCT_MIX_MAP.ITEM_ID = B.NEW_ITEM_ID
        FROM    TH_ENG_PRODUCT_MIX_MAP A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID
        AND     B.SEQ > 1

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_FIXED_PLAN'

        UPDATE  TH_ENG_FIXED_PLAN
        SET     TH_ENG_FIXED_PLAN.ITEM_ID = B.NEW_ITEM_ID
        FROM    TH_ENG_FIXED_PLAN A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID
        AND     B.SEQ > 1

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_STOCK_PLAN'

        UPDATE  TH_ENG_STOCK_PLAN
        SET     TH_ENG_STOCK_PLAN.ITEM_ID = B.NEW_ITEM_ID
        FROM    TH_ENG_STOCK_PLAN A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        --AND     A.SITE_ID = B.SITE_ID
        --AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID
        AND     B.SEQ > 1

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_WIP'

        UPDATE  TH_ENG_WIP
        SET     TH_ENG_WIP.ITEM_ID = B.NEW_ITEM_ID
        FROM    TH_ENG_WIP A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID
        AND     B.SEQ > 1

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
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
