CREATE PROCEDURE [dbo].[PR_SCM_PROD_FIX_NETTING]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_PROD_FIX_NETTING                                                   **/
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
  EXEC PR_SCM_PROD_FIX_NETTING
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_PROD_FIX_NETTING'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  
  DECLARE @sysdate          DATETIME = GETDATE()
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

      SELECT @plan_start_time = PLAN_START_TIME
           , @plan_end_time = (
                                CASE  WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_TIME)
                                                                      ELSE DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                END  
                              )
           , @key_date = CONVERT(NVARCHAR, PLAN_START_TIME, 112)
      FROM   SCM_FP_PLAN_H WITH(NOLOCK)
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
    END;
    
    BEGIN
      
      BEGIN
      
        SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_RESULT'
        
        UPDATE TH_BUF_SCM_RESCHEDULE_RESULT
        SET    REMAIN_PLAN_QTY = PLAN_QTY,
               REMAIN_PLAN_IN_QTY = PLAN_IN_QTY
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
 
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      -- 확정 W/O 기준으로 최종 계획 Netting 처리..!!
      BEGIN

        SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_RESULT'
        SET @n_row_count = 0
        
        DECLARE
          @c_fix$SITE_ID            nvarchar(30), 
          @c_fix$OPERATION_ID       nvarchar(30), 
          @c_fix$LINE_ID            nvarchar(30), 
          @c_fix$ITEM_ID            nvarchar(30), 
          @c_fix$FIX_WORK_ORDER_ID  nvarchar(50), 
          @c_fix$fix_qty            numeric(20,10) = 0
          
        DECLARE
          @n_fix_alloc_qty          numeric(20,10) = 0,
          @n_fix_remain_qty         numeric(20,10) = 0,
          @n_assign_cnt             int = 0   -- 할당 count


        DECLARE
          C_FIX CURSOR LOCAL FOR
            select a.site_id, a.operation_id, a.line_id, a.item_id,
                   a.work_order_id as fix_work_order_id, a.plan_qty as fix_qty
            from   fp_erp_work_order_status_h a
            where  cutoff_date = convert(date, @key_date)
            and    exists (
                            select 1
                            from   (
                                    select distinct a.factory_id, c.operation_id 
                                    from   fp_instance_factory_m a,
                                           scm_factory_m b,
                                           scm_operation_m c
                                    where  a.instance_id = @v_master_id
                                    and    a.factory_id = b.factory_id
                                    and    b.company_id = c.company_id
                                    and    b.site_id = c.site_id
                                    and    b.division_id = c.division_id
                                    and    a.instance_type = c.instance_type
                                   ) x
                           where  a.factory_id = x.factory_id
                           and    a.operation_id = x.operation_id
                         )
            and    operation_id in ( 'E1000','S1000')
            and    not exists (
                                SELECT 1
                                FROM   TH_BUF_SCM_RESCHEDULE_RESULT x
                                WHERE  X.MASTER_ID     = @v_master_id    
                                AND    X.PLAN_ID       = @v_plan_id          
                                --AND    X.CAPA_TYPE     = 'TACT'    
                                AND    ISNULL(X.FIXED_YN,'N') = 'Y'  -- 확정 WO
                                AND    X.WORK_ORDER_ID = A.WORK_ORDER_ID
                               )
            order  by a.operation_id, a.line_id, a.plan_start_time, a.work_order_id, a.item_id

        OPEN C_FIX
        
        WHILE 1 = 1
        BEGIN

          FETCH C_FIX INTO  
                          @c_fix$SITE_ID          
                        , @c_fix$OPERATION_ID     
                        , @c_fix$LINE_ID      
                        , @c_fix$ITEM_ID          
                        , @c_fix$FIX_WORK_ORDER_ID
                        , @c_fix$fix_qty


          IF @@FETCH_STATUS <> 0
            BREAK

          SET @n_fix_remain_qty = @c_fix$fix_qty
          SET @n_assign_cnt = 0

          WHILE 1=1
          BEGIN

            DECLARE
              @v_new_work_order_id  nvarchar(50), 
              @n_remain_plan_qty    numeric(20,10) = 0
              
            SET @v_new_work_order_id = 'NULL'
            SET @n_assign_cnt += 1
           
            SELECT TOP 1
                   @v_new_work_order_id = new_work_order_id
                  ,@n_remain_plan_qty = remain_plan_qty
            FROM   (
                    SELECT A.*                                   
                    FROM   TH_BUF_SCM_RESCHEDULE_RESULT A        
                    WHERE  MASTER_ID     = @v_master_id    
                    AND    PLAN_ID       = @v_plan_id
                    AND    OPERATION_ID  = @c_fix$OPERATION_ID     
                    AND    ROUTE_ID      = @c_fix$LINE_ID         
                    AND    ITEM_ID       = @c_fix$ITEM_ID          
                    --AND    CAPA_TYPE     = 'TACT'
                    AND    ISNULL(FIXED_YN,'N') = 'N'
                    AND    ISNULL(FIX_WORK_ORDER_ID, '*NULL*') = '*NULL*'
                    AND    REMAIN_PLAN_QTY  > 0
                   ) A
            ORDER  BY START_TIME, END_TIME, NEW_WORK_ORDER_ID
          
            IF @v_new_work_order_id = 'NULL'     -- 위 SELECT 문에서 대상을 못찾으면 나가기
              BREAK
              
            IF @n_fix_remain_qty >= @n_remain_plan_qty
              SET @n_fix_alloc_qty = @n_remain_plan_qty
            ELSE
              SET @n_fix_alloc_qty = @n_fix_remain_qty

            SET @n_fix_remain_qty -= @n_fix_alloc_qty

            BEGIN

               IF @n_assign_cnt <= 1

                  INSERT INTO TH_BUF_SCM_RESCHEDULE_RESULT
                       (
                         MASTER_ID
                       , PLAN_ID
                       , SITE_ID
                       , ROUTE_ID
                       , OPERATION_ID
                       , RESOURCE_ID
                       , ITEM_ID
                       , LANE_QTY
                       , WORK_ORDER_ID
                       , PLAN_DATE
                       , START_TIME
                       , END_TIME
                       , PLAN_QTY
                       , PLAN_IN_QTY
                       , CAPA_TYPE
                       , FIXED_YN
                       , ASSIGN_SEQ
                       , DEMAND_ID
                       , NEW_WORK_ORDER_ID
                       , FIX_WORK_ORDER_ID
                       , FIX_PLAN_QTY
                       , FIX_PLAN_IN_QTY
                       , REMAIN_PLAN_QTY
                       , REMAIN_PLAN_IN_QTY                     
                       , INSERT_ID
                       , INSERT_TIME  
                         )
                  SELECT MASTER_ID
                       , PLAN_ID
                       , SITE_ID
                       , ROUTE_ID
                       , OPERATION_ID
                       , RESOURCE_ID
                       , ITEM_ID
                       , LANE_QTY
                       , WORK_ORDER_ID
                       , PLAN_DATE
                       , START_TIME
                       , END_TIME
                       , PLAN_QTY
                       , PLAN_IN_QTY
                       , CAPA_TYPE
                       , 'Y' as FIXED_YN  -- 확정 W/O 설정..!!
                       , ASSIGN_SEQ
                       , DEMAND_ID
                       , @c_fix$FIX_WORK_ORDER_ID AS NEW_WORK_ORDER_ID
                       , @c_fix$FIX_WORK_ORDER_ID as FIX_WORK_ORDER_ID
                       , @n_fix_alloc_qty as FIX_PLAN_QTY
                       , 0 as FIX_PLAN_IN_QTY
                       , (ISNULL(REMAIN_PLAN_QTY,0)-@n_fix_alloc_qty) as REMAIN_PLAN_QTY
                       , 0 as REMAIN_PLAN_IN_QTY                     
                       , NEW_WORK_ORDER_ID AS INSERT_ID
                       , INSERT_TIME                        
                  FROM   TH_BUF_SCM_RESCHEDULE_RESULT      
                  WHERE  MASTER_ID     = @v_master_id    
                  AND    PLAN_ID       = @v_plan_id
                  AND    OPERATION_ID  = @c_fix$OPERATION_ID     
                  AND    ROUTE_ID      = @c_fix$LINE_ID         
                  AND    ITEM_ID       = @c_fix$ITEM_ID
                  AND    NEW_WORK_ORDER_ID = @v_new_work_order_id
                  AND    ISNULL(FIX_WORK_ORDER_ID, '*NULL*') = '*NULL*'
                  AND    REMAIN_PLAN_QTY  > 0

               ELSE

                 UPDATE TH_BUF_SCM_RESCHEDULE_RESULT
                 SET    FIX_PLAN_QTY  += @n_fix_alloc_qty
                 WHERE  MASTER_ID      = @v_master_id    
                 AND    PLAN_ID        = @v_plan_id
                 AND    OPERATION_ID   = @c_fix$OPERATION_ID     
                 AND    ROUTE_ID       = @c_fix$LINE_ID         
                 AND    ITEM_ID        = @c_fix$ITEM_ID
                 AND    FIX_WORK_ORDER_ID = @c_fix$FIX_WORK_ORDER_ID
                   
            END

            UPDATE TH_BUF_SCM_RESCHEDULE_RESULT
            SET    REMAIN_PLAN_QTY  -= @n_fix_alloc_qty
            WHERE  MASTER_ID         = @v_master_id    
            AND    PLAN_ID           = @v_plan_id
            AND    OPERATION_ID      = @c_fix$OPERATION_ID     
            AND    ROUTE_ID          = @c_fix$LINE_ID         
            AND    ITEM_ID           = @c_fix$ITEM_ID
            AND    NEW_WORK_ORDER_ID = @v_new_work_order_id
            AND    ISNULL(FIX_WORK_ORDER_ID, '*NULL*') = '*NULL*'
            AND    REMAIN_PLAN_QTY  > 0

            SET @n_row_count += @@ROWCOUNT

            IF @n_fix_remain_qty <= 0    -- fix 를 전부 pegging 하면 나가기
              BREAK

          END
        
        END
        CLOSE C_FIX

        DEALLOCATE C_FIX

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        BEGIN

          UPDATE TH_BUF_SCM_RESCHEDULE_RESULT
          SET    FIX_PLAN_IN_QTY = (FIX_PLAN_QTY * (PLAN_IN_QTY / PLAN_QTY)),
                 REMAIN_PLAN_QTY = FIX_PLAN_QTY,
                 REMAIN_PLAN_IN_QTY = (FIX_PLAN_QTY * (PLAN_IN_QTY / PLAN_QTY))
          WHERE  MASTER_ID       = @v_master_id    
          AND    PLAN_ID         = @v_plan_id          
          --AND    CAPA_TYPE       = 'TACT'
          AND    ISNULL(FIX_WORK_ORDER_ID, '*NULL*') != '*NULL*' -- FIX!!
          AND    PLAN_QTY > 0
          
          UPDATE TH_BUF_SCM_RESCHEDULE_RESULT
          SET    REMAIN_PLAN_IN_QTY = (REMAIN_PLAN_QTY * (PLAN_IN_QTY / PLAN_QTY))
          WHERE  MASTER_ID       = @v_master_id    
          AND    PLAN_ID         = @v_plan_id          
          --AND    CAPA_TYPE       = 'TACT'
          AND    ISNULL(FIX_WORK_ORDER_ID, '*NULL*') = '*NULL*' -- PLAN!!
          AND    PLAN_QTY > 0
        
        END

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
