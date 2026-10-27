CREATE PROCEDURE [dbo].[PR_SCM_MF_SITE_ROUTE_ENG]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_SITE_ROUTE_ENG                                                  **/
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
  EXEC PR_SCM_MF_SITE_ROUTE_ENG
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_MF_SITE_ROUTE_ENG'
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
      
      --if @v_master_id != 'KR_CELL'
      BEGIN
      
        -------------------------------------------------------------------------------------------------------------------------------
        -------------------------------------------------------------------------------------------------------------------------------

        BEGIN
        
          DECLARE @V_OPERATION_ID   NVARCHAR(30) = 'A5000'
        
          BEGIN
            SET @v_table_name = 'TH_ENG_FIXED_PLAN'

            UPDATE TH_ENG_FIXED_PLAN
            SET    ROUTE_ID = ROUTE_ID + '^' + OPERATION_ID
            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
            AND    OPERATION_ID = @V_OPERATION_ID
            ;
            
            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = @V_OPERATION_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END

          BEGIN
            SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE'

            UPDATE TH_ENG_ITEM_ROUTE_SITE
            SET    ROUTE_ID = ROUTE_ID + '^' + OPERATION_ID
            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
            AND    OPERATION_ID = @V_OPERATION_ID
            ;          
            
            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = @V_OPERATION_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END

          BEGIN
            SET @v_table_name = 'TH_ENG_OP_RES_GROUP'

            UPDATE TH_ENG_OP_RES_GROUP
            SET    ROUTE_ID = ROUTE_ID + '^' + OPERATION_ID
            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
            AND    OPERATION_ID = @V_OPERATION_ID
            ;
            
            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = @V_OPERATION_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END

          BEGIN
            SET @v_table_name = 'TH_ENG_OP_RES_GROUP_CAL'

            UPDATE TH_ENG_OP_RES_GROUP_CAL
            SET    ROUTE_ID = ROUTE_ID + '^' + OPERATION_ID
            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
            AND    OPERATION_ID = @V_OPERATION_ID
            ;
            
            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = @V_OPERATION_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END

          BEGIN
            SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP'

            UPDATE TH_ENG_OP_RES_GROUP_MAP
            SET    ROUTE_ID = ROUTE_ID + '^' + OPERATION_ID
            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
            AND    OPERATION_ID = @V_OPERATION_ID
            ;
            
            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = @V_OPERATION_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END

          BEGIN
            SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP_CAL'

            UPDATE TH_ENG_OP_RES_GROUP_MAP_CAL
            SET    ROUTE_ID = ROUTE_ID + '^' + OPERATION_ID
            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
            AND    OPERATION_ID = @V_OPERATION_ID
            ;
            
            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = @V_OPERATION_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END

          BEGIN
            SET @v_table_name = 'TH_ENG_PLAN_BOM'


            UPDATE TH_ENG_PLAN_BOM
            SET    ROUTE_ID = ROUTE_ID + '^' + OPERATION_ID
            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
            AND    OPERATION_ID = @V_OPERATION_ID
            ;          
            
            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = @V_OPERATION_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END

          BEGIN
            SET @v_table_name = 'TH_ENG_PLAN_BOM_CAL'

            UPDATE TH_ENG_PLAN_BOM_CAL
            SET    ROUTE_ID = ROUTE_ID + '^' + OPERATION_ID
            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
            AND    OPERATION_ID = @V_OPERATION_ID
            ;          
            
            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = @V_OPERATION_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END

          BEGIN
            SET @v_table_name = 'TH_ENG_RESOURCE'

            UPDATE TH_ENG_RESOURCE
            SET    ROUTE_ID = ROUTE_ID + '^' + @V_OPERATION_ID
            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
            AND    RESOURCE_ID IN (
                                    SELECT RESOURCE_ID
                                    FROM   TH_MST_RESOURCE
                                    WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
                                    AND    RES_ATTB_18 = @V_OPERATION_ID
                          )
            ;
            
            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = @V_OPERATION_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END

          BEGIN
            SET @v_table_name = 'TH_ENG_STOCK_PLAN'

            UPDATE TH_ENG_STOCK_PLAN
            SET    ROUTE_ID = ROUTE_ID + '^' + OPERATION_ID
            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id
            AND    OPERATION_ID = @V_OPERATION_ID
            AND    ISNULL(ROUTE_ID, '-') != '-'                  -- STOCK 은 뒤에서 후처리 하기 때문에
            ;          
            
            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = @V_OPERATION_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END

          BEGIN
            SET @v_table_name = 'TH_ENG_WIP'

            UPDATE TH_ENG_WIP
            SET    ROUTE_ID = ROUTE_ID + '^' + OPERATION_ID
            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
            AND    OPERATION_ID = @V_OPERATION_ID
            ;
            
            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = @V_OPERATION_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END        
          
          BEGIN
            SET @v_table_name = 'TH_ENG_ROUTE'

            INSERT INTO TH_ENG_ROUTE
                  (
                   MASTER_ID,
                   PLAN_ID,
                   ROUTE_ID,
                   ROUTE_LEVEL
                  )
            SELECT DISTINCT
                   MASTER_ID,
                   PLAN_ID,
                   ROUTE_ID,
                   1 AS ROUTE_LEVEL
            FROM   TH_ENG_ITEM_ROUTE_SITE
            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
            AND    OPERATION_ID = @V_OPERATION_ID
            AND    ROUTE_ID LIKE '%'+@V_OPERATION_ID
            ;
            
            SET @n_row_count = @@ROWCOUNT
                  
            --LOG 생성
            SET @v_message = @V_OPERATION_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END        
          
        END

        -------------------------------------------------------------------------------------------------------------------------------
        -------------------------------------------------------------------------------------------------------------------------------

        BEGIN
          SET @v_table_name = 'TH_ENG_SALES_PRODUCT_MAP'

          INSERT INTO TH_ENG_SALES_PRODUCT_MAP
               ( MASTER_ID, PLAN_ID, SALES_MODEL_ID, PRODUCT_ITEM_ID, SITE_ID, ALT_PRIORITY, ALT_RATE, DESCR )     
          SELECT DISTINCT
                 A.MASTER_ID, A.PLAN_ID, A.SALES_MODEL_ID, A.PRODUCT_ITEM_ID, (A.SITE_ID+'^'+B.ROUTE_ID) AS SITE_ID, A.ALT_PRIORITY, A.ALT_RATE, A.DESCR
          FROM   TH_ENG_SALES_PRODUCT_MAP A,
                 (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID
                  FROM   TH_ENG_ITEM_ROUTE_SITE
                  WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) B
          WHERE  A.PRODUCT_ITEM_ID = B.ITEM_ID
          AND    A.SITE_ID = B.SITE_ID
          AND    A.MASTER_ID = @v_master_id AND A.PLAN_ID = @v_plan_id
          ;

          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          DELETE FROM TH_ENG_SALES_PRODUCT_MAP
          WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND SITE_ID NOT LIKE '%^%'
          ;
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        END
      
        BEGIN
          SET @v_table_name = 'TH_ENG_BOD'

          INSERT INTO TH_ENG_BOD
               ( MASTER_ID, PLAN_ID, BOD_ID, FROM_SITE_ID, TO_SITE_ID, TRANSPORT_MODE, TRANSPORT_TIME, TRANSPORT_TIME_UOM, 
                 BOD_START_DTTM, BOD_PATTERN_ID, FROM_OFFTIME_SET_ID, TO_OFFTIME_SET_ID, FIXED_TERM, FIXED_TERM_UOM, 
                 ATTRIBUTE_SET_ID, ATTRIBUTE_CHECKER_ID, IS_PREV_EPST, DESCR )
          SELECT DISTINCT
                 -- 동간 이동부터 먼저 넣는다..
                 A.MASTER_ID, A.PLAN_ID, (A.BOD_ID+'^'+B.ROUTE_ID+C.ROUTE_ID) AS BOD_ID, 
                 (A.FROM_SITE_ID+'^'+B.ROUTE_ID) AS FROM_SITE_ID, (A.TO_SITE_ID+'^'+C.ROUTE_ID) AS TO_SITE_ID,
                 A.TRANSPORT_MODE, A.TRANSPORT_TIME, A.TRANSPORT_TIME_UOM, A.BOD_START_DTTM, A.BOD_PATTERN_ID, A.FROM_OFFTIME_SET_ID, A.TO_OFFTIME_SET_ID,
                 A.FIXED_TERM, A.FIXED_TERM_UOM, A.ATTRIBUTE_SET_ID, A.ATTRIBUTE_CHECKER_ID, A.IS_PREV_EPST, A.BOD_ID AS DESCR
          FROM   TH_ENG_BOD A,
                 (SELECT DISTINCT SITE_ID, ROUTE_ID, OPERATION_ID
                  FROM   TH_ENG_ITEM_ROUTE_SITE
                  WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) B,
                 (SELECT DISTINCT SITE_ID, ROUTE_ID, OPERATION_ID
                  FROM   TH_ENG_ITEM_ROUTE_SITE
                  WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) C
          WHERE  A.FROM_SITE_ID = B.SITE_ID
          AND    A.TO_SITE_ID = C.SITE_ID
          --AND    A.FROM_SITE_ID <> A.TO_SITE_ID
          AND    A.TRANSPORT_MODE = B.OPERATION_ID+'#'+C.OPERATION_ID
          AND    A.MASTER_ID = @v_master_id AND A.PLAN_ID = @v_plan_id
          AND    A.BOD_ID NOT LIKE '%^%'
          ;

          INSERT INTO TH_ENG_BOD
               ( MASTER_ID, PLAN_ID, BOD_ID, FROM_SITE_ID, TO_SITE_ID, TRANSPORT_MODE, TRANSPORT_TIME, TRANSPORT_TIME_UOM, 
                 BOD_START_DTTM, BOD_PATTERN_ID, FROM_OFFTIME_SET_ID, TO_OFFTIME_SET_ID, FIXED_TERM, FIXED_TERM_UOM, 
                 ATTRIBUTE_SET_ID, ATTRIBUTE_CHECKER_ID, IS_PREV_EPST, DESCR )
          SELECT DISTINCT
                 -- 동간 이동을 제외하고 나머지를 넣는다.
                 A.MASTER_ID, A.PLAN_ID, (A.BOD_ID+'^'+B.ROUTE_ID+C.ROUTE_ID) AS BOD_ID, 
                 (A.FROM_SITE_ID+'^'+B.ROUTE_ID) AS FROM_SITE_ID, (A.TO_SITE_ID+'^'+C.ROUTE_ID) AS TO_SITE_ID,
                 A.TRANSPORT_MODE, A.TRANSPORT_TIME, A.TRANSPORT_TIME_UOM, A.BOD_START_DTTM, A.BOD_PATTERN_ID, A.FROM_OFFTIME_SET_ID, A.TO_OFFTIME_SET_ID,
                 A.FIXED_TERM, A.FIXED_TERM_UOM, A.ATTRIBUTE_SET_ID, A.ATTRIBUTE_CHECKER_ID, A.IS_PREV_EPST, A.BOD_ID AS DESCR
          FROM   TH_ENG_BOD A,
                 (SELECT DISTINCT SITE_ID, ROUTE_ID
                  FROM   TH_ENG_ITEM_ROUTE_SITE
                  WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) B,
                 (SELECT DISTINCT SITE_ID, ROUTE_ID
                  FROM   TH_ENG_ITEM_ROUTE_SITE
                  WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) C
          WHERE  A.FROM_SITE_ID = B.SITE_ID
          AND    A.TO_SITE_ID = C.SITE_ID
          AND    B.ROUTE_ID = C.ROUTE_ID
          AND    A.FROM_SITE_ID = A.TO_SITE_iD
          AND    A.MASTER_ID = @v_master_id AND A.PLAN_ID = @v_plan_id
          AND    A.BOD_ID NOT LIKE '%^%'
          AND    NOT EXISTS (
                              SELECT 1
                              FROM   TH_ENG_BOD X 
                              WHERE  X.MASTER_ID = @v_master_id AND X.PLAN_ID = @v_plan_id
                              AND    X.TRANSPORT_MODE = A.TRANSPORT_MODE
                              AND    X.BOD_ID LIKE '%^%'
                            )

          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          DELETE FROM TH_ENG_BOD
          WHERE  MASTER_ID = @v_master_id 
          AND    PLAN_ID = @v_plan_id 
          AND    BOD_ID NOT LIKE '%^%'
          --;
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        END

        BEGIN
          SET @v_table_name = 'TH_ENG_ITEM_BOD'

          INSERT INTO TH_ENG_ITEM_BOD
               ( MASTER_ID, PLAN_ID, BOD_ID, ITEM_ID, ALT_PRIORITY, ALT_RATE, TRANSFER_LOT_SIZE, 
                 IS_PREV_LOT_SIZE, IS_PULL, PRE_BUFFER_TIME, POST_BUFFER_TIME, BUFFER_TIME_UOM, ROUTE_SELECTOR_ID, 
                 ATTRIBUTE_SET_ID, MIN_LOT_SIZE, MAX_LOT_SIZE, INCREMENT_LOT_SIZE, SAFETY_STOCK_TERM, SAFETY_STOCK_TERM_UOM, SAFETY_STOCK_QTY, DESCR )
          SELECT DISTINCT
                 A.MASTER_ID, A.PLAN_ID, B.BOD_ID, A.ITEM_ID, A.ALT_PRIORITY, A.ALT_RATE, A.TRANSFER_LOT_SIZE, 
                 A.IS_PREV_LOT_SIZE, A.IS_PULL, A.PRE_BUFFER_TIME, A.POST_BUFFER_TIME, A.BUFFER_TIME_UOM, A.ROUTE_SELECTOR_ID, 
                 A.ATTRIBUTE_SET_ID, A.MIN_LOT_SIZE, A.MAX_LOT_SIZE, A.INCREMENT_LOT_SIZE, 
                 A.SAFETY_STOCK_TERM, A.SAFETY_STOCK_TERM_UOM, A.SAFETY_STOCK_QTY, A.DESCR
          FROM   TH_ENG_ITEM_BOD A,
                 TH_ENG_BOD B
          WHERE  A.MASTER_ID = B.MASTER_ID
          AND    A.PLAN_ID = B.PLAN_ID
          AND    A.BOD_ID = B.DESCR
          AND    A.MASTER_ID = @v_master_id AND A.PLAN_ID = @v_plan_id
          ;

          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          DELETE FROM TH_ENG_ITEM_BOD
          WHERE  MASTER_ID = @v_master_id 
          AND    PLAN_ID = @v_plan_id 
          AND    BOD_ID NOT LIKE '%^%'
          ;
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        END

        BEGIN
          SET @v_table_name = 'TH_ENG_FIXED_PLAN'

          UPDATE TH_ENG_FIXED_PLAN
          SET    SITE_ID = (SITE_ID+'^'+ROUTE_ID)
          WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
          ;
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

        BEGIN
          SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE'

          UPDATE TH_ENG_ITEM_ROUTE_SITE
          SET    SITE_ID = (SITE_ID+'^'+ROUTE_ID)
          WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
          ;          
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

        BEGIN
          SET @v_table_name = 'TH_ENG_OP_RES_GROUP'

          UPDATE TH_ENG_OP_RES_GROUP
          SET    SITE_ID = (SITE_ID+'^'+ROUTE_ID)
          WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
          ;
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

        BEGIN
          SET @v_table_name = 'TH_ENG_OP_RES_GROUP_CAL'

          UPDATE TH_ENG_OP_RES_GROUP_CAL
          SET    SITE_ID = (SITE_ID+'^'+ROUTE_ID)
          WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
          ;
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

        BEGIN
          SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP'

          UPDATE TH_ENG_OP_RES_GROUP_MAP
          SET    SITE_ID = (SITE_ID+'^'+ROUTE_ID)
          WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
          ;
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

        BEGIN
          SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP_CAL'

          UPDATE TH_ENG_OP_RES_GROUP_MAP_CAL
          SET    SITE_ID = (SITE_ID+'^'+ROUTE_ID)
          WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
          ;
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

        BEGIN
          SET @v_table_name = 'TH_ENG_PLAN_BOM'


          UPDATE TH_ENG_PLAN_BOM
          SET    SITE_ID = (SITE_ID+'^'+ROUTE_ID)
          WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
          ;          
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

        BEGIN
          SET @v_table_name = 'TH_ENG_PLAN_BOM_CAL'

          UPDATE TH_ENG_PLAN_BOM_CAL
          SET    SITE_ID = (SITE_ID+'^'+ROUTE_ID)
          WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
          ;          
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

        BEGIN
          SET @v_table_name = 'TH_ENG_RESOURCE'

          UPDATE TH_ENG_RESOURCE
          SET    SITE_ID = (SITE_ID+'^'+ROUTE_ID)
          WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
          ;
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

        BEGIN
          SET @v_table_name = 'TH_ENG_STOCK_PLAN'

          UPDATE TH_ENG_STOCK_PLAN
          SET    SITE_ID = (SITE_ID+'^'+ROUTE_ID)
          WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id 
          AND    ISNULL(ROUTE_ID, '-') != '-'
          ;          
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

        BEGIN
          SET @v_table_name = 'TH_ENG_WIP'

          UPDATE TH_ENG_WIP
          SET    SITE_ID = (SITE_ID+'^'+ROUTE_ID)
          WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND ROUTE_ID IS NOT NULL
          ;
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

      END   -- IF END

      -- 추가 보완로직
      BEGIN

        SET @v_table_name = 'TH_ENG_BOD'

        INSERT INTO TH_ENG_BOD
             ( MASTER_ID, PLAN_ID, BOD_ID, FROM_SITE_ID, TO_SITE_ID, TRANSPORT_MODE, TRANSPORT_TIME, TRANSPORT_TIME_UOM, 
               BOD_START_DTTM, BOD_PATTERN_ID, FROM_OFFTIME_SET_ID, TO_OFFTIME_SET_ID, FIXED_TERM, FIXED_TERM_UOM, 
               ATTRIBUTE_SET_ID, ATTRIBUTE_CHECKER_ID, IS_PREV_EPST, DESCR )
        SELECT DISTINCT
               A.MASTER_ID, A.PLAN_ID, (B.SITE_ID+'^'+C.SITE_ID+'^'+A.OPERATION_ID+':VIRTUAL') AS BOD_ID, B.SITE_ID AS FROM_SITE_ID, C.SITE_ID AS TO_SITE_ID,
               '-' AS TRANSPORT_MODE, 0 AS TRANSPORT_TIME, 'DAY' AS TRANSPORT_TIME_UOM, D.PLAN_START_DTTM AS BOD_START_DTTM, 
               'DX' AS BOD_PATTERN_ID, NULL AS FROM_OFFTIME_SET_ID, NULL AS TO_OFFTIME_SET_ID,
               0 AS FIXED_TERM, 'DAY' AS FIXED_TERM_UOM, NULL AS ATTRIBUTE_SET_ID, NULL AS ATTRIBUTE_CHECKER_ID, NULL AS IS_PREV_EPST, 'VIRTUAL^1' AS DESCR
        FROM   TH_ENG_PLAN_BOM A,
               (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                       CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                            ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                       END  AS FACTORY_ID               
                FROM   TH_ENG_OP_RES_GROUP
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) B,
               (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                       CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                            ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                       END  AS FACTORY_ID               
                FROM   TH_ENG_OP_RES_GROUP
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) C,
               (SELECT DISTINCT PLAN_ID, PLAN_START_DTTM
                FROM   TH_ENG_PLAN_INFO
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) D
        WHERE  A.CHILD_ITEM_ID = B.ITEM_ID
        AND    A.PARENT_ITEM_ID = C.ITEM_ID
        AND    A.SITE_ID = C.SITE_ID
        AND    B.FACTORY_ID = C.FACTORY_ID  -- 같은 동 일 경우
        AND    B.SITE_ID <> C.SITE_ID
        AND    B.ROUTE_ID <> C.ROUTE_ID
        AND    A.PLAN_ID = D.PLAN_ID
        AND   (
               CHARINDEX(C.OPERATION_ID, A.PARENT_ITEM_ID) > 0 OR 
               CHARINDEX(B.OPERATION_ID, A.CHILD_ITEM_ID) > 0  OR
               CHARINDEX(A.OPERATION_ID, A.CHILD_ITEM_ID) > 0
               )
        AND    A.MASTER_ID = @v_master_id AND A.PLAN_ID = @v_plan_id
        ;

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        SET @v_table_name = 'TH_ENG_ITEM_BOD'

        INSERT INTO TH_ENG_ITEM_BOD
             ( MASTER_ID, PLAN_ID, BOD_ID, ITEM_ID, ALT_PRIORITY, ALT_RATE, TRANSFER_LOT_SIZE, 
               IS_PREV_LOT_SIZE, IS_PULL, PRE_BUFFER_TIME, POST_BUFFER_TIME, BUFFER_TIME_UOM, ROUTE_SELECTOR_ID, 
               ATTRIBUTE_SET_ID, MIN_LOT_SIZE, MAX_LOT_SIZE, INCREMENT_LOT_SIZE, SAFETY_STOCK_TERM, SAFETY_STOCK_TERM_UOM, SAFETY_STOCK_QTY, DESCR )
               
        SELECT DISTINCT
               A.MASTER_ID, A.PLAN_ID, (B.SITE_ID+'^'+C.SITE_ID+'^'+A.OPERATION_ID+':VIRTUAL') AS BOD_ID, A.CHILD_ITEM_ID AS ITEM_ID, 
               1 AS ALT_PRIORITY, 1 AS ALT_RATE, -1 AS TRANSFER_LOT_SIZE, NULL AS IS_PREV_LOT_SIZE, NULL AS IS_PULL, 
               0 AS PRE_BUFFER_TIME, 0 AS POST_BUFFER_TIME, 'DAY' AS BUFFER_TIME_UOM, NULL AS ROUTE_SELECTOR_ID, 
               NULL AS ATTRIBUTE_SET_ID, 0 AS MIN_LOT_SIZE, 0 AS MAX_LOT_SIZE, 0 AS INCREMENT_LOT_SIZE, 
               0 AS SAFETY_STOCK_TERM, 'DAY' AS SAFETY_STOCK_TERM_UOM, 0 AS SAFETY_STOCK_QTY, 'VIRTUAL^1' AS DESCR
        FROM   TH_ENG_PLAN_BOM A,
               (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                       CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                            ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                       END  AS FACTORY_ID               
                FROM   TH_ENG_OP_RES_GROUP
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) B,
               (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                       CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                            ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                       END  AS FACTORY_ID               
                FROM   TH_ENG_OP_RES_GROUP
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) C,
               (SELECT DISTINCT PLAN_ID, PLAN_START_DTTM
                FROM   TH_ENG_PLAN_INFO
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) D
        WHERE  A.CHILD_ITEM_ID = B.ITEM_ID
        AND    A.PARENT_ITEM_ID = C.ITEM_ID
        AND    A.SITE_ID = C.SITE_ID
        AND    B.FACTORY_ID = C.FACTORY_ID  -- 같은 동 일 경우
        AND    B.SITE_ID <> C.SITE_ID
        AND    B.ROUTE_ID <> C.ROUTE_ID
        AND    A.PLAN_ID = D.PLAN_ID
        AND   (
               CHARINDEX(C.OPERATION_ID, A.PARENT_ITEM_ID) > 0 OR 
               CHARINDEX(B.OPERATION_ID, A.CHILD_ITEM_ID) > 0  OR
               CHARINDEX(A.OPERATION_ID, A.CHILD_ITEM_ID) > 0
               )
        AND    A.MASTER_ID = @v_master_id AND A.PLAN_ID = @v_plan_id
        ;       
                     
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
      END

      -- LANE 연계 ( 전, 후 공정 ) 로직 관련 보완
      BEGIN
      
        SET @v_table_name = 'TH_ENG_BOD'

        INSERT INTO TH_ENG_BOD
             ( MASTER_ID, PLAN_ID, BOD_ID, FROM_SITE_ID, TO_SITE_ID, TRANSPORT_MODE, TRANSPORT_TIME, TRANSPORT_TIME_UOM, 
               BOD_START_DTTM, BOD_PATTERN_ID, FROM_OFFTIME_SET_ID, TO_OFFTIME_SET_ID, FIXED_TERM, FIXED_TERM_UOM, 
               ATTRIBUTE_SET_ID, ATTRIBUTE_CHECKER_ID, IS_PREV_EPST, DESCR )
        SELECT DISTINCT
               A.MASTER_ID, A.PLAN_ID, (B.SITE_ID+'^'+C.SITE_ID+'^'+A.OPERATION_ID+':VIRTUAL') AS BOD_ID, B.SITE_ID AS FROM_SITE_ID, C.SITE_ID AS TO_SITE_ID,
               '-' AS TRANSPORT_MODE, 0 AS TRANSPORT_TIME, 'DAY' AS TRANSPORT_TIME_UOM, D.PLAN_START_DTTM AS BOD_START_DTTM, 
               'DX' AS BOD_PATTERN_ID, NULL AS FROM_OFFTIME_SET_ID, NULL AS TO_OFFTIME_SET_ID,
               0 AS FIXED_TERM, 'DAY' AS FIXED_TERM_UOM, NULL AS ATTRIBUTE_SET_ID, NULL AS ATTRIBUTE_CHECKER_ID, NULL AS IS_PREV_EPST, 'VIRTUAL^2' AS DESCR
        FROM   TH_ENG_PLAN_BOM A,
               (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                       CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                            ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                       END  AS FACTORY_ID               
                FROM   TH_ENG_OP_RES_GROUP
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id
                AND    ROUTE_ID = 'VIRTUAL_LANE'
               ) B,
               (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                       CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                            ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                       END  AS FACTORY_ID               
                FROM   TH_ENG_OP_RES_GROUP
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id
               ) C,
               (SELECT DISTINCT PLAN_ID, PLAN_START_DTTM
                FROM   TH_ENG_PLAN_INFO
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) D
        WHERE  A.CHILD_ITEM_ID = B.ITEM_ID
        AND    A.PARENT_ITEM_ID = C.ITEM_ID
        AND    A.SITE_ID = C.SITE_ID
        --AND    B.FACTORY_ID = C.FACTORY_ID  -- 같은 동 일 경우
        AND    B.SITE_ID <> C.SITE_ID
        AND    B.ROUTE_ID <> C.ROUTE_ID
        AND    A.PLAN_ID = D.PLAN_ID
        AND    A.MASTER_ID = @v_master_id AND A.PLAN_ID = @v_plan_id

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      

        SET @v_table_name = 'TH_ENG_ITEM_BOD'

        INSERT INTO TH_ENG_ITEM_BOD
             ( MASTER_ID, PLAN_ID, BOD_ID, ITEM_ID, ALT_PRIORITY, ALT_RATE, TRANSFER_LOT_SIZE, 
               IS_PREV_LOT_SIZE, IS_PULL, PRE_BUFFER_TIME, POST_BUFFER_TIME, BUFFER_TIME_UOM, ROUTE_SELECTOR_ID, 
               ATTRIBUTE_SET_ID, MIN_LOT_SIZE, MAX_LOT_SIZE, INCREMENT_LOT_SIZE, SAFETY_STOCK_TERM, SAFETY_STOCK_TERM_UOM, SAFETY_STOCK_QTY, DESCR )
               
        SELECT DISTINCT
               A.MASTER_ID, A.PLAN_ID, (B.SITE_ID+'^'+C.SITE_ID+'^'+A.OPERATION_ID+':VIRTUAL') AS BOD_ID, A.CHILD_ITEM_ID AS ITEM_ID, 
               1 AS ALT_PRIORITY, 1 AS ALT_RATE, -1 AS TRANSFER_LOT_SIZE, NULL AS IS_PREV_LOT_SIZE, NULL AS IS_PULL, 
               0 AS PRE_BUFFER_TIME, 0 AS POST_BUFFER_TIME, 'DAY' AS BUFFER_TIME_UOM, NULL AS ROUTE_SELECTOR_ID, 
               NULL AS ATTRIBUTE_SET_ID, 0 AS MIN_LOT_SIZE, 0 AS MAX_LOT_SIZE, 0 AS INCREMENT_LOT_SIZE, 
               0 AS SAFETY_STOCK_TERM, 'DAY' AS SAFETY_STOCK_TERM_UOM, 0 AS SAFETY_STOCK_QTY, 'VIRTUAL^2' AS DESCR
        FROM   TH_ENG_PLAN_BOM A,
               (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                       CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                            ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                       END  AS FACTORY_ID               
                FROM   TH_ENG_OP_RES_GROUP
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id
                AND    ROUTE_ID = 'VIRTUAL_LANE'
               ) B,
               (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                       CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                            ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                       END  AS FACTORY_ID               
                FROM   TH_ENG_OP_RES_GROUP
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id
               ) C,
               (SELECT DISTINCT PLAN_ID, PLAN_START_DTTM
                FROM   TH_ENG_PLAN_INFO
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) D
        WHERE  A.CHILD_ITEM_ID = B.ITEM_ID
        AND    A.PARENT_ITEM_ID = C.ITEM_ID
        AND    A.SITE_ID = C.SITE_ID
        --AND    B.FACTORY_ID = C.FACTORY_ID  -- 같은 동 일 경우
        AND    B.SITE_ID <> C.SITE_ID
        AND    B.ROUTE_ID <> C.ROUTE_ID
        AND    A.PLAN_ID = D.PLAN_ID
        AND    A.MASTER_ID = @v_master_id AND A.PLAN_ID = @v_plan_id
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END
      
      -- 기타 누락되는 애들..
      BEGIN
      
        SET @v_table_name = 'TH_ENG_BOD'

        INSERT INTO TH_ENG_BOD
             ( MASTER_ID, PLAN_ID, BOD_ID, FROM_SITE_ID, TO_SITE_ID, TRANSPORT_MODE, TRANSPORT_TIME, TRANSPORT_TIME_UOM, 
               BOD_START_DTTM, BOD_PATTERN_ID, FROM_OFFTIME_SET_ID, TO_OFFTIME_SET_ID, FIXED_TERM, FIXED_TERM_UOM, 
               ATTRIBUTE_SET_ID, ATTRIBUTE_CHECKER_ID, IS_PREV_EPST, DESCR )
        SELECT DISTINCT
               A.MASTER_ID, A.PLAN_ID, (B.SITE_ID+'^'+C.SITE_ID+'^'+A.OPERATION_ID+':VIRTUAL') AS BOD_ID, B.SITE_ID AS FROM_SITE_ID, C.SITE_ID AS TO_SITE_ID,
               '-' AS TRANSPORT_MODE, 0 AS TRANSPORT_TIME, 'DAY' AS TRANSPORT_TIME_UOM, D.PLAN_START_DTTM AS BOD_START_DTTM, 
               'DX' AS BOD_PATTERN_ID, NULL AS FROM_OFFTIME_SET_ID, NULL AS TO_OFFTIME_SET_ID,
               0 AS FIXED_TERM, 'DAY' AS FIXED_TERM_UOM, NULL AS ATTRIBUTE_SET_ID, NULL AS ATTRIBUTE_CHECKER_ID, NULL AS IS_PREV_EPST, 'VIRTUAL^3' AS DESCR
        FROM   TH_ENG_PLAN_BOM A,
               (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                       CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                            ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                       END  AS FACTORY_ID
                FROM   TH_ENG_OP_RES_GROUP
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id ) B,
               (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                       CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                            ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                       END  AS FACTORY_ID               
                FROM   TH_ENG_OP_RES_GROUP
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) C,
               (SELECT DISTINCT PLAN_ID, PLAN_START_DTTM
                FROM   TH_ENG_PLAN_INFO
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) D
        WHERE  A.CHILD_ITEM_ID = B.ITEM_ID
        AND    A.PARENT_ITEM_ID = C.ITEM_ID
        AND    A.SITE_ID = C.SITE_ID
        AND    B.FACTORY_ID = C.FACTORY_ID  -- 같은 동 일 경우
        AND    B.SITE_ID <> C.SITE_ID
        AND    B.ROUTE_ID <> C.ROUTE_ID
        AND    A.PLAN_ID = D.PLAN_ID
        AND    A.MASTER_ID = @v_master_id AND A.PLAN_ID = @v_plan_id
        --AND    A.CHILD_ITEM_ID = 'ANRAN0471B'
        AND    NOT EXISTS ( -- 위에서 등록된 놈들은 제외
                            SELECT 1
                            FROM   TH_ENG_ITEM_BOD X
                            WHERE  X.MASTER_ID = A.MASTER_ID
                            AND    X.PLAN_ID = A.PLAN_ID
                            AND    X.ITEM_ID = A.CHILD_ITEM_ID
                          )
        AND    NOT EXISTS ( -- FROM-TO 가 같은애들은 제외
                            SELECT 1
                            FROM   (
                                    SELECT A.CHILD_ITEM_ID
                                    FROM   TH_ENG_PLAN_BOM A,
                                           (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                                                   CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                                                        ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                                                   END  AS FACTORY_ID                                           
                                            FROM   TH_ENG_OP_RES_GROUP
                                            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) B,
                                           (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                                                   CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                                                        ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                                                   END  AS FACTORY_ID                                           
                                            FROM   TH_ENG_OP_RES_GROUP
                                            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) C,
                                           (SELECT DISTINCT PLAN_ID, PLAN_START_DTTM
                                            FROM   TH_ENG_PLAN_INFO
                                            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) D
                                    WHERE  A.CHILD_ITEM_ID = B.ITEM_ID
                                    AND    A.PARENT_ITEM_ID = C.ITEM_ID
                                    AND    A.SITE_ID = C.SITE_ID
                                    AND    B.FACTORY_ID = C.FACTORY_ID  -- 같은 동 일 경우
                                    AND    B.SITE_ID = C.SITE_ID
                                    AND    B.ROUTE_ID = C.ROUTE_ID
                                    AND    A.PLAN_ID = D.PLAN_ID
                                    AND    A.MASTER_ID = @v_master_id AND A.PLAN_ID = @v_plan_id
                                   ) Y
                           WHERE   A.CHILD_ITEM_ID = Y.CHILD_ITEM_ID
                          )
        ;
      
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      

        SET @v_table_name = 'TH_ENG_ITEM_BOD'

        INSERT INTO TH_ENG_ITEM_BOD
             ( MASTER_ID, PLAN_ID, BOD_ID, ITEM_ID, ALT_PRIORITY, ALT_RATE, TRANSFER_LOT_SIZE, 
               IS_PREV_LOT_SIZE, IS_PULL, PRE_BUFFER_TIME, POST_BUFFER_TIME, BUFFER_TIME_UOM, ROUTE_SELECTOR_ID, 
               ATTRIBUTE_SET_ID, MIN_LOT_SIZE, MAX_LOT_SIZE, INCREMENT_LOT_SIZE, SAFETY_STOCK_TERM, SAFETY_STOCK_TERM_UOM, SAFETY_STOCK_QTY, DESCR )
               
        SELECT DISTINCT
               A.MASTER_ID, A.PLAN_ID, (B.SITE_ID+'^'+C.SITE_ID+'^'+A.OPERATION_ID+':VIRTUAL') AS BOD_ID, A.CHILD_ITEM_ID AS ITEM_ID, 
               1 AS ALT_PRIORITY, 1 AS ALT_RATE, -1 AS TRANSFER_LOT_SIZE, NULL AS IS_PREV_LOT_SIZE, NULL AS IS_PULL, 
               0 AS PRE_BUFFER_TIME, 0 AS POST_BUFFER_TIME, 'DAY' AS BUFFER_TIME_UOM, NULL AS ROUTE_SELECTOR_ID, 
               NULL AS ATTRIBUTE_SET_ID, 0 AS MIN_LOT_SIZE, 0 AS MAX_LOT_SIZE, 0 AS INCREMENT_LOT_SIZE, 
               0 AS SAFETY_STOCK_TERM, 'DAY' AS SAFETY_STOCK_TERM_UOM, 0 AS SAFETY_STOCK_QTY, 'VIRTUAL^3' AS DESCR
        FROM   TH_ENG_PLAN_BOM A,
               (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                       CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                            ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                       END  AS FACTORY_ID               
                FROM   TH_ENG_OP_RES_GROUP
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) B,
               (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                       CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                            ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                       END  AS FACTORY_ID               
                FROM   TH_ENG_OP_RES_GROUP
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) C,
               (SELECT DISTINCT PLAN_ID, PLAN_START_DTTM
                FROM   TH_ENG_PLAN_INFO
                WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) D
        WHERE  A.CHILD_ITEM_ID = B.ITEM_ID
        AND    A.PARENT_ITEM_ID = C.ITEM_ID
        AND    A.SITE_ID = C.SITE_ID
        AND    B.FACTORY_ID = C.FACTORY_ID  -- 같은 동 일 경우
        AND    B.SITE_ID <> C.SITE_ID
        AND    B.ROUTE_ID <> C.ROUTE_ID
        AND    A.PLAN_ID = D.PLAN_ID
        AND    A.MASTER_ID = @v_master_id AND A.PLAN_ID = @v_plan_id
        --AND    A.CHILD_ITEM_ID = 'ANRAN0471B'
        AND    NOT EXISTS ( -- 위에서 등록된 놈들은 제외
                            SELECT 1
                            FROM   TH_ENG_ITEM_BOD X
                            WHERE  X.MASTER_ID = A.MASTER_ID
                            AND    X.PLAN_ID = A.PLAN_ID
                            AND    X.ITEM_ID = A.CHILD_ITEM_ID
                          )
        AND    NOT EXISTS ( -- FROM-TO 가 같은애들은 제외
                            SELECT 1
                            FROM   (
                                    SELECT A.CHILD_ITEM_ID
                                    FROM   TH_ENG_PLAN_BOM A,
                                           (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                                                   CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                                                        ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                                                   END  AS FACTORY_ID                                           
                                            FROM   TH_ENG_OP_RES_GROUP
                                            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) B,
                                           (SELECT DISTINCT ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, 
                                                   CASE WHEN CHARINDEX('^', SITE_ID) = 0 THEN SITE_ID
                                                        ELSE SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) 
                                                   END  AS FACTORY_ID                                           
                                            FROM   TH_ENG_OP_RES_GROUP
                                            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) C,
                                           (SELECT DISTINCT PLAN_ID, PLAN_START_DTTM
                                            FROM   TH_ENG_PLAN_INFO
                                            WHERE  MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id) D
                                    WHERE  A.CHILD_ITEM_ID = B.ITEM_ID
                                    AND    A.PARENT_ITEM_ID = C.ITEM_ID
                                    AND    A.SITE_ID = C.SITE_ID
                                    AND    B.FACTORY_ID = C.FACTORY_ID  -- 같은 동 일 경우
                                    AND    B.SITE_ID = C.SITE_ID
                                    AND    B.ROUTE_ID = C.ROUTE_ID
                                    AND    A.PLAN_ID = D.PLAN_ID
                                    AND    A.MASTER_ID = @v_master_id AND A.PLAN_ID = @v_plan_id
                                   ) Y
                           WHERE   A.CHILD_ITEM_ID = Y.CHILD_ITEM_ID
                          )
        ;

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END
      
      
      BEGIN

        SET @v_table_name = 'TH_ENG_DEMAND_ATTRIBUTE'

        UPDATE TH_ENG_DEMAND_ATTRIBUTE
        SET    TH_ENG_DEMAND_ATTRIBUTE.PREFERENCE_PRODUCT_ID    = A.ITEM_ID
             , TH_ENG_DEMAND_ATTRIBUTE.PREFERENCE_SITE_ID       = A.SITE_ID
             , TH_ENG_DEMAND_ATTRIBUTE.PREFERENCE_ROUTE_ID      = A.ROUTE_ID
             , TH_ENG_DEMAND_ATTRIBUTE.PREFERENCE_OPERATION_ID  = A.OPERATION_ID
        FROM   TH_ENG_ITEM_ROUTE_SITE A,
               TH_ENG_DEMAND_ATTRIBUTE B
        WHERE  A.MASTER_ID    = @v_master_id
        AND    A.PLAN_ID      = @v_plan_id
        AND    A.MASTER_ID    = B.MASTER_ID
        AND    A.PLAN_ID      = B.PLAN_ID
        AND    A.ITEM_ID      LIKE B.PREFERENCE_PRODUCT_ID +'%'
        AND    A.SITE_ID      LIKE B.PREFERENCE_SITE_ID +'%'
        AND    A.ROUTE_ID     LIKE B.PREFERENCE_ROUTE_ID +'%'
        AND    A.OPERATION_ID LIKE B.PREFERENCE_OPERATION_ID +'%'

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END
      
      /* -- 후공정 계획 몰림 현상으로 주석처리 -- 2017.03.20
      -- TH_ENG_DEMAND_ATTRIBUTE 에 PREFER_SITE_ID 갱신
      BEGIN
      
        SET @v_table_name = 'TH_ENG_DEMAND_ATTRIBUTE'
        
        DECLARE
          @c_ps$site_id     nvarchar(max), 
          @c_ps$new_site_id nvarchar(max),
          @c_ps$seq         int
        
        DECLARE C_PREFER_SITE CURSOR LOCAL FOR 
          SELECT SITE_ID, NEW_SITE_ID,
                 DENSE_RANK() OVER (PARTITION BY SITE_ID ORDER BY NEW_SITE_ID DESC) AS SEQ
          FROM   (
                  SELECT SUBSTRING(SITE_ID, 1, CHARINDEX('^', SITE_ID)-1) AS SITE_ID,
                         SITE_ID AS NEW_SITE_ID
                  FROM   TH_ENG_ITEM_ROUTE_SITE A
                  WHERE  A.MASTER_ID  = @v_master_id
                  AND    A.PLAN_ID    = @v_plan_id
                  AND    CHARINDEX('^', A.SITE_ID) > 0
                  GROUP  BY SITE_ID
                 ) A
          ORDER  BY SITE_ID, NEW_SITE_ID

        OPEN C_PREFER_SITE

        WHILE 1 = 1
       
          BEGIN
          
            SET @n_row_count = 0

            FETCH C_PREFER_SITE
             INTO @c_ps$site_id, @c_ps$new_site_id, @c_ps$seq

              IF @@FETCH_STATUS <> 0
                BREAK
                
                UPDATE TH_ENG_DEMAND_ATTRIBUTE
                SET    PREFERENCE_SITE_ID = REPLACE(PREFERENCE_SITE_ID, @c_ps$site_id+'##', @c_ps$new_site_id + '##' + @c_ps$site_id + '##') 
                WHERE  MASTER_ID  = @v_master_id
                AND    PLAN_ID    = @v_plan_id
                AND    PREFERENCE_SITE_ID LIKE '%' + @c_ps$site_id + '##%'
                
                IF @c_ps$seq = 1
                  UPDATE TH_ENG_DEMAND_ATTRIBUTE
                  SET    PREFERENCE_SITE_ID = REPLACE(PREFERENCE_SITE_ID, @c_ps$site_id+'##', '') 
                  WHERE  MASTER_ID  = @v_master_id
                  AND    PLAN_ID    = @v_plan_id
                  AND    PREFERENCE_SITE_ID LIKE '%' + @c_ps$site_id + '##%'

          END
          
        CLOSE C_PREFER_SITE

        DEALLOCATE C_PREFER_SITE
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END
      */

      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END;
    
  END TRY

  BEGIN CATCH
    --ROLLBACK
    
    IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_PREFER_SITE')
    BEGIN
        CLOSE C_PREFER_SITE
        DEALLOCATE C_PREFER_SITE
    END

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
