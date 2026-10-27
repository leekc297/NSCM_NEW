CREATE PROCEDURE [dbo].[PR_SCM_OF_COAT_WO_MERGE__ALLNEW]
   @p_master_id  nvarchar(max) = '-',
   @p_plan_id    nvarchar(max) = '-',
   @p_factory_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_COAT_WO_MERGE                                                   **/
/** 프로그램 명   : Coating 공정 WO merge                                                     **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument      :                                                                           **/
/**             EXEC PR_SCM_OF_COAT_WO_MERGE_2ND_DEV @v_master_id, @v_plan_id, @v_factory_id  **/
/**                                                                                           **/
/** [검색 조건]                                                                               **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/** 20170414       ksjeon        Coating 공정 WO merge                                        **/
/** 201704         ksjeon        Actual, close Flag에 따른 처리                               **/
/** 201704         ksjeon        Fixed seq adjust                                             **/
/** 201704         ksjeon        Demand type에 따른 WO merge 분리                             **/
/** 20170512       ksjeon        남경 납선기능 추가, 월 넘어갈때 Merge 보완(Actual date )     **/
/** 20170518       ksjeon        머지로직 전면 재개발                                         **/
/**                       1. coating 공정 기준의 머지 작성                                    **/
/**                          ( 기존은 coating 공정, mixer 공정을 개별로 merge 작업 함 )       **/
/**                       2.coating 공정기준 mixer WO를 찾아 Mapping TABLE 생성               **/
/**                       3. Mapping 테이블의 Coating merge WO 기준으로 mixer WO를 머지한다   **/
/** 20170628       ksjeon        머지한 merge_batch_order_id 를 쓰지 않고                     **/
/**                              Batch_group_id 로 넣는 로직을 적용                           **/
/**===========================================================================================**/
/*
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_factory_id     nvarchar(30)
  DECLARE @confirm_plan_id  nvarchar(30)
  DECLARE @release_plan_id  nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_OF_COAT_WO_MERGE__ALLNEW'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  
  DECLARE @v_instance_code      nvarchar(10)
  DECLARE @v_instance_sub_code  nvarchar(10)
  DECLARE @v_order_date_code    nvarchar(10)
  DECLARE @v_hhmiss             nvarchar(10)
  DECLARE @n_daily_plan_count   Integer  = 0

  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)
  
  DECLARE @v_is_wo_merge    nvarchar(5)
  DECLARE @v_is_co_merge    nvarchar(5)

-- WO Merge 대상 coating 공정 list
  DECLARE @v_wo_id_merge_op1      nvarchar(10) = '00000'
  DECLARE @v_wo_id_merge_op2      nvarchar(10) = '00000'
  DECLARE @v_wo_id_merge_op3      nvarchar(10) = '00000'
  DECLARE @v_wo_id_merge_op4      nvarchar(10) = '00000'
  DECLARE @v_wo_id_merge_op5      nvarchar(10) = '00000'
  DECLARE @v_wo_id_merge_op6      nvarchar(10) = '00000'

-- WO Merge 대상 mixer 공정 list
  DECLARE @v_mix_wo_id_merge_op1  nvarchar(10) = '00000'
  DECLARE @v_mix_wo_id_merge_op2  nvarchar(10) = '00000'
  DECLARE @v_mix_wo_id_merge_op3  nvarchar(10) = '00000'
  DECLARE @v_mix_wo_id_merge_op4  nvarchar(10) = '00000'
  DECLARE @v_mix_wo_id_merge_op5  nvarchar(10) = '00000'
  DECLARE @v_mix_wo_id_merge_op6  nvarchar(10) = '00000'


-- BATCH id Merge 대상 Mixer 공정 list
  DECLARE @v_batch_id_merge_op1   nvarchar(10) = '00000'
  DECLARE @v_batch_id_merge_op2   nvarchar(10) = '00000'
  DECLARE @v_batch_id_merge_op3   nvarchar(10) = '00000'
  DECLARE @v_batch_id_merge_op4   nvarchar(10) = '00000'
  DECLARE @v_batch_id_merge_op5   nvarchar(10) = '00000'
  DECLARE @v_batch_id_merge_op6   nvarchar(10) = '00000'

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  DECLARE @v_plan_month     nvarchar(30)
  DECLARE @v_plan_dd        nvarchar(30)

  DECLARE @v_cutoff_date     date

------  Pmix 소요량 생성용 -------------
  DECLARE @v_plan_date        DATE
  DECLARE @v_to_instance_id   nvarchar(30)
  DECLARE @v_to_instance_key  nvarchar(30)
  DECLARE @n_day_diff         Integer  = 0

  DECLARE @v_coat_mid_char    nvarchar(30)
  DECLARE @v_mix_mid_char     nvarchar(30)

----------------------------------------
  
  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id
  SET @v_factory_id = @p_factory_id
  
  SET @v_is_wo_merge = 'N'
  SET @v_is_co_merge = 'N'
  
--  SET @v_merge_op1 = 'E1000'
--  SET @v_merge_op2 = 'E2000'
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    -- 필수 DATA 쿼리.. 
    BEGIN
    
      --LOG 생성
      SET @v_table_name = 'SCM_FP_PLAN_H'
             
      SELECT 
             @plan_start_time = PLAN_START_TIME
           , @v_plan_month    = substring(CONVERT(varchar, CONVERT(DATETIME, PLAN_START_TIME, 20) , 112), 1, 6)
           , @v_plan_dd       = substring(CONVERT(varchar, CONVERT(DATETIME, PLAN_START_TIME, 20) , 112), 7, 2)
  
           , @plan_end_time = (
                                CASE  WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_TIME)
                                                                      ELSE DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                END  
                              )
           , @key_date    = CONVERT(NVARCHAR, PLAN_START_TIME, 112)
           , @v_plan_date = CONVERT(DATE,     PLAN_START_TIME, 112)                           -- Pmix 소요량 생성용
           , @n_day_diff  = DATEDIFF(MINUTE, CONVERT(DATE, PLAN_START_TIME), PLAN_START_TIME) -- Pmix 소요량 생성용
           , @v_hhmiss    = REPLACE(CONVERT(NVARCHAR, PLAN_START_TIME, 8), ':', '')
      FROM   SCM_FP_PLAN_H WITH(NOLOCK)
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID     = @v_plan_id             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null


             
      SET @v_table_name = 'SCM_STOCK_H'
      SELECT @v_cutoff_date = max(cutoff_date)
      FROM   SCM_STOCK_H
      --WHERE  CUTOFF_DATE <= DATEADD(DD, 0, CONVERT(DATE, @key_date))   -- 하루전부터 탐색
      WHERE  CUTOFF_DATE = DATEADD(DD, 0, CONVERT(DATE, @key_date))      -- 오늘꺼만             
             
             
      --LOG 생성
      SET @v_message = 'CUTOFF_DATE : ' + CONVERT(nvarchar, @v_cutoff_date, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
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

    END;

    -- Merge 여부 쿼리.. 
    BEGIN

      --LOG 생성
      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

      SELECT 
             @v_is_wo_merge = MAX(ISNULL(KEY_VALUE,'N'))
      FROM   FP_INSTANCE_CONFIG_M
      WHERE  INSTANCE_ID = @v_master_id
      AND    CATEGORY_ID = 'WO_MERGE'
      AND    KEY_ID      = 'WO_MERGE'            

      -- ### MERGE 옵션이 'Y' 일경우 해당 Instance 별 operation set
      IF ISNULL(@v_is_wo_merge,'N') = 'Y'
      BEGIN

          if CHARINDEX('E_PRE' , @v_master_id) > 0
              begin 
                set @v_wo_id_merge_op1     = 'E2000'
                set @v_wo_id_merge_op2     = '00000'
                set @v_wo_id_merge_op3     = '00000'
                set @v_wo_id_merge_op4     = '00000'
                set @v_wo_id_merge_op5     = '00000'
                set @v_wo_id_merge_op6     = '00000'
                set @v_mix_wo_id_merge_op1 = 'E1000'
                set @v_mix_wo_id_merge_op2 = '00000'
                set @v_mix_wo_id_merge_op3 = '00000'
                set @v_mix_wo_id_merge_op4 = '00000'
                set @v_mix_wo_id_merge_op5 = '00000'
                set @v_mix_wo_id_merge_op6 = '00000'
                set @v_batch_id_merge_op1  = 'E1000'
                set @v_batch_id_merge_op2  = '00000'
                set @v_batch_id_merge_op3  = '00000'
                set @v_batch_id_merge_op4  = '00000'
                set @v_batch_id_merge_op5  = '00000'
                set @v_batch_id_merge_op6  = '00000'
              end      
          -- 20170711 uncomment    
          else if CHARINDEX('E_PMIX' , @v_master_id) > 0
              begin 
                set @v_wo_id_merge_op1 = 'E0500'
                set @v_wo_id_merge_op2 = '00000'
                set @v_wo_id_merge_op3 = '00000'
                set @v_wo_id_merge_op4 = '00000'
                set @v_wo_id_merge_op5 = '00000'
                set @v_wo_id_merge_op6 = '00000'
                set @v_mix_wo_id_merge_op1 = 'E0500'
                set @v_mix_wo_id_merge_op2 = '00000'
                set @v_mix_wo_id_merge_op3 = '00000'
                set @v_mix_wo_id_merge_op4 = '00000'
                set @v_mix_wo_id_merge_op5 = '00000'
                set @v_mix_wo_id_merge_op6 = '00000'
                set @v_batch_id_merge_op1 = 'E0500'
                set @v_batch_id_merge_op2 = '00000'
                set @v_batch_id_merge_op3 = '00000'
                set @v_batch_id_merge_op4 = '00000'
                set @v_batch_id_merge_op5 = '00000'
                set @v_batch_id_merge_op6 = '00000'
              end      
          else if @v_master_id = 'KR_SRS'     
              begin 
                set @v_wo_id_merge_op1     = 'S2000'
                set @v_wo_id_merge_op2     = '00000'
                set @v_wo_id_merge_op3     = '00000'
                set @v_wo_id_merge_op4     = '00000'
                set @v_wo_id_merge_op5     = '00000'
                set @v_wo_id_merge_op6     = '00000'
                set @v_mix_wo_id_merge_op1 = 'S1000'
                set @v_mix_wo_id_merge_op2 = '00000'
                set @v_mix_wo_id_merge_op3 = '00000'
                set @v_mix_wo_id_merge_op4 = '00000'
                set @v_mix_wo_id_merge_op5 = '00000'
                set @v_mix_wo_id_merge_op6 = '00000'
                set @v_batch_id_merge_op1  = 'S1000'
                set @v_batch_id_merge_op2  = '00000'
                set @v_batch_id_merge_op3  = '00000'
                set @v_batch_id_merge_op4  = '00000'
                set @v_batch_id_merge_op5  = '00000'
                set @v_batch_id_merge_op6  = '00000'
              end      
          end      
          else      
              begin 
                set @v_wo_id_merge_op1     = '00000'
                set @v_wo_id_merge_op2     = '00000'
                set @v_wo_id_merge_op3     = '00000'
                set @v_wo_id_merge_op4     = '00000'
                set @v_wo_id_merge_op5     = '00000'
                set @v_wo_id_merge_op6     = '00000'
                set @v_mix_wo_id_merge_op1 = '00000'
                set @v_mix_wo_id_merge_op2 = '00000'
                set @v_mix_wo_id_merge_op3 = '00000'
                set @v_mix_wo_id_merge_op4 = '00000'
                set @v_mix_wo_id_merge_op5 = '00000'
                set @v_mix_wo_id_merge_op6 = '00000'
                set @v_batch_id_merge_op1  = '00000'
                set @v_batch_id_merge_op2  = '00000'
                set @v_batch_id_merge_op3  = '00000'
                set @v_batch_id_merge_op4  = '00000'
                set @v_batch_id_merge_op5  = '00000'
                set @v_batch_id_merge_op6  = '00000'
              end    
               
      --LOG 생성
      SET @v_message = 'IS_WO_MERGE : ' + ISNULL(@v_is_wo_merge, '') + ' / Factory_id : ' + @v_factory_id + ' / IS_CO_MERGE : ' + ISNULL(@v_is_co_merge, '')
                       + ' / @v_wo_id_merge_op1 : '    + @v_wo_id_merge_op1    + ' / @v_wo_id_merge_op2 : '    + @v_wo_id_merge_op2
                       + ' / @v_batch_id_merge_op1 : ' + @v_batch_id_merge_op1 + ' / @v_batch_id_merge_op2 : ' + @v_batch_id_merge_op2
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
    END;



    -- ### MERGE 옵션이 아닐 경우는 종료..!!
    IF ISNULL(@v_is_wo_merge,'N') = 'Y'
    
    BEGIN
    
        -- Confirm plan id 쿼리.. 
        BEGIN

          SET @v_table_name = 'SCM_FP_PLAN_DETAIL_H'
          select distinct 
                 @confirm_plan_id = plan_id
            FROM (
                  select plan_id, 
                         dense_rank() over( partition by instance_id
                                                order by plan_date desc, insert_time desc, plan_id desc ) as r
                  FROM   SCM_FP_PLAN_DETAIL_H
                  where  1=1
                  and    instance_id = @v_master_id
                  and    factory_id  = @v_factory_id
                  and    plan_date   < convert(nvarchar, @plan_start_time, 112)
                 ) a          
          where 1=1
          and   r = 1
                            
          --LOG 생성
          SET @v_message = '@confirm_plan_id : ' + @confirm_plan_id
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
          
        END;    

        -- @release_plan_id 쿼리.. 
        BEGIN

          SET @v_table_name = 'SCM_FP_PLAN_DETAIL_H'
          select distinct 
                 @release_plan_id = release_plan_id
            FROM (
                  select plan_id, release_plan_id, 
                         dense_rank() over( partition by instance_id
                                                order by plan_date desc, insert_time desc, plan_id desc ) as r
                  FROM   HIS_FP_PLAN_DETAIL_H
                  where  1=1
                  and    instance_id = @v_master_id
                  and    factory_id  = @v_factory_id
                  and    plan_date  <= convert(nvarchar, @plan_start_time, 112)
                  and    release_flag = 'Y'
                  and    mes_transfer_flag = 'Y'
                 ) a          
          where 1 = 1
          and   r = 1
                            
          --LOG 생성
          SET @v_message = '@release_plan_id : ' + @release_plan_id
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
          
        END;    
        

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

        -- 2018.03.19 : 1일 1 WORK 계획 먼저 수립함.
        BEGIN
        
          SET @v_table_name = 'FP_AMEND_DAILY_PLAN_R'

          SELECT @n_daily_plan_count = COUNT(1)
          FROM   FP_AMEND_DAILY_PLAN_R A
          WHERE  A.INSTANCE_ID    = @v_master_id
          AND    A.FP_PLAN_ID     = @v_plan_id
          AND    A.FACTORY_ID     = @v_factory_id

          SET @n_row_count = @n_daily_plan_count
          
          --LOG 생성
          SET @v_message = 'CHECK COUNT : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

          IF @n_daily_plan_count > 0
          BEGIN
          
            -- AMEND 한 DATA 를 ADJUST_IN/OUT_QTY 로 넣는다.. ( RELEASE 시 사용할 것이므로,, )
            UPDATE FP_AMEND_DAILY_PLAN_R
            SET    ADJUST_IN_QTY          = CASE B.ITEM_UOM WHEN 'EA' THEN CEILING(ADJUST_IN_QTY_CELL)
                                                            WHEN 'M'  THEN CEILING(ADJUST_IN_QTY_M)
                                                            WHEN 'KG' THEN CEILING(ADJUST_IN_QTY_KG)
                                                                      ELSE CEILING(ADJUST_IN_QTY)
                                            END
                 , ADJUST_OUT_QTY         = CASE B.ITEM_UOM WHEN 'EA' THEN CEILING(ADJUST_OUT_QTY_CELL)
                                                            WHEN 'M'  THEN CEILING(ADJUST_OUT_QTY_M)
                                                            WHEN 'KG' THEN CEILING(ADJUST_OUT_QTY_KG)
                                                                      ELSE CEILING(ADJUST_OUT_QTY)
                                            END
            FROM   FP_AMEND_DAILY_PLAN_R  A
                 , SCM_ITEM_M             B
            WHERE  A.INSTANCE_ID  = @v_master_id
            AND    A.FP_PLAN_ID   = @v_plan_id
            AND    A.COMPANY_ID   = B.COMPANY_ID
            AND    A.DIVISION_ID  = B.DIVISION_ID
            AND    A.SITE_ID      = B.SITE_ID
            AND    A.ITEM_ID      = B.ITEM_ID

            SET @n_row_count = @@ROWCOUNT
            
            --LOG 생성
            SET @v_message = 'ADJUST_IN_QTY, ADJUST_OUT_QTY : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

            
            SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY'
            
            DELETE FROM TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY
            WHERE   MASTER_ID     = @v_master_id
            AND     PLAN_ID       = @v_plan_id
            and     AFTER_SITE_ID = @v_factory_id
          
            --LOG 생성
            SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
            SET @n_log_count = @n_log_count + 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

            
            SET @v_table_name = 'TH_BUF_SCM_DAILY_PLAN_FACTORY'

            DELETE FROM TH_BUF_SCM_DAILY_PLAN_FACTORY WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())   -- 이전 데이터 삭제
          
            DELETE FROM A
            FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY A
            WHERE  A.INSTANCE_ID  = @v_master_id
            AND    A.FP_PLAN_ID   = @v_plan_id
            AND    A.FACTORY_ID   = @v_factory_id
            
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
                 , INSERT_ID
                 , INSERT_TIME           
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
                 , DATEADD(MINUTE, @n_day_diff + A.PLAN_DATE_SEQ, A.PLAN_DATE) AS START_TIME
                 , DATEADD(MINUTE, @n_day_diff + 1440,            A.PLAN_DATE) AS END_TIME
                 , A.PLAN_QTY         AS ORG_PLAN_QTY
                 , A.PLAN_QTY
                 , A.PLAN_IN_QTY
                 , A.ROLL_IN_QTY
                 , A.ROLL_OUT_QTY
                 , A.JR_IN_QTY
                 , A.JR_OUT_QTY
                 , A.CELL_IN_QTY
                 , A.CELL_OUT_QTY
                 , A.BATCH_QTY
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
                 , @v_proc_name       AS INSERT_ID
                 , GETDATE()          AS INSERT_TIME
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
                                 , A.ADJUST_OUT_QTY             AS PLAN_QTY
                                 , A.ADJUST_IN_QTY              AS PLAN_IN_QTY
                                 , A.ADJUST_IN_QTY_M            AS ROLL_IN_QTY
                                 , A.ADJUST_OUT_QTY_M           AS ROLL_OUT_QTY
                                 , A.ADJUST_IN_QTY_JR           AS JR_IN_QTY
                                 , A.ADJUST_OUT_QTY_JR          AS JR_OUT_QTY
                                 , A.ADJUST_IN_QTY_CELL         AS CELL_IN_QTY
                                 , A.ADJUST_OUT_QTY_CELL        AS CELL_OUT_QTY
                                 , A.ADJUST_OUT_QTY_BATCH       AS BATCH_QTY
                                 , A.ADJUST_IN_QTY_BATCH        AS BATCH_IN_QTY
                                 , A.PRODUCTION_TYPE
                                 , A.MARKET
                                 , B.ERP_OPERATION_ID
                                 , D.MODEL_TYPE AS PLAN_GROUP_ID
                                 , A.TOTAL_WORKING_TIME
                                 , DENSE_RANK() OVER (PARTITION BY B.ERP_OPERATION_ID
                                                      ORDER     BY A.PLAN_DATE
                                                                 , A.FACTORY_ID
                                                                 , A.LINE_ID
                                                                 , A.LOCATION
                                                                 , A.OPERATION_ID
                                                                 , A.ELECTRODE_TYPE
                                                                 , A.EQUIPMENT_ID
                                                                 , A.SEQ
                                                                 , A.ITEM_ID
                                                                 , A.TOP_ITEM_ID
                                                                 , A.PRODUCTION_TYPE
                                                                 , A.MARKET
                                                                 ) AS ORDER_SEQ
                            FROM   FP_AMEND_DAILY_PLAN_R  A
                                 , SCM_OPERATION_M        B
                                 , SCM_EQUIPMENT_M        C
                                 , SCM_LINE_M             D
                            WHERE  A.INSTANCE_ID    = @v_master_id
                            AND    A.FP_PLAN_ID     = @v_plan_id
                            AND    A.FACTORY_ID     = @v_factory_id
                            AND    A.ADJUST_OUT_QTY > 0
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
                           ) A
                   ) A
                 , SCM_ITEM_M B
                 , SCM_SYS_CALENDAR_M C
            WHERE  A.COMPANY_ID = B.COMPANY_ID
            AND    A.DIVISION_ID = B.DIVISION_ID
            AND    A.SITE_ID = B.SITE_ID
            AND    A.ITEM_ID = B.ITEM_ID
            AND    A.PLAN_DATE = C.DATE_ID
            
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

            update  a
            set     a.fix_work_order_id = b.fix_work_order_id
                  , a.batch_order_id    = b.fix_batch_order_id
            from    TH_BUF_SCM_DAILY_PLAN_FACTORY a,
                    (
                    select a.instance_id, a.fp_plan_id, a.work_order_id, b.work_order_id as fix_work_order_id,
                           a.factory_id, a.operation_id, a.equipment_id, a.item_id, a.seq, 
                           b.batch_order_id as fix_batch_order_id
                    from   (
                            select instance_id, fp_plan_id, work_order_id, factory_id, operation_id, equipment_id, item_id, PRODUCTION_TYPE, MARKET,
                                   -- 2018.04.11 : 일자별 seq 별 확정 work order 할당
                                   convert(date, plan_date) as plan_date,
                                   dense_rank()  over ( partition by factory_id, operation_id, equipment_id, item_id , PRODUCTION_TYPE, MARKET, convert(date, plan_date)
                                                        order by plan_date, work_order_id ) as seq
                                   --dense_rank()  over ( partition by factory_id, operation_id, equipment_id, item_id , PRODUCTION_TYPE, MARKET
                                   --                     order by plan_date, work_order_id ) as seq
                            from   TH_BUF_SCM_DAILY_PLAN_FACTORY
                            where  instance_id  = @v_master_id
                            and    fp_plan_id   = @v_plan_id
                            and    factory_id   = @v_factory_id
                            and    operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater / Mixer 공정..!!
                            and    plan_qty     > 0
                           ) a
                           inner JOIN
                           (
                            select 
                                   a.fp_plan_id, a.factory_id, a.operation_id, a.equipment_id, a.item_id, a.work_order_id, a.plan_start_time, a.batch_order_id, a.PRODUCTION_TYPE, a.MARKET,
                                   -- 2018.04.11 : 일자별 seq 별 확정 work order 할당
                                   convert(date, a.plan_date) as plan_date,
                                   dense_rank()  over ( partition by a.factory_id, a.operation_id, a.equipment_id, a.item_id, a.PRODUCTION_TYPE, a.MARKET, convert(date, a.plan_date)
                                                        order by a.plan_start_time, a.work_order_id ) as seq
                                   --dense_rank()  over ( partition by a.factory_id, a.operation_id, a.equipment_id, a.item_id, a.PRODUCTION_TYPE, a.MARKET 
                                   --                     order by a.plan_start_time, a.work_order_id ) as seq
                            from   fp_daily_instance_order_status a
                            where  a.instance_id  = @v_master_id
                            and    a.fp_plan_id   = @v_plan_id
                            and    a.factory_id   = @v_factory_id
                            and    a.plan_start_time >= case when @v_is_co_merge = 'Y' then @plan_start_time else (@plan_start_time-365) end  -- ## 확정 W/O 옵션..!!
                            and    a.org_qty > 0
                            and    a.WO_STATUS in ( 'OPEN', 'RUN' )
                            and    EXISTS ( 
                                                select 1
                                                from   (
                                                        select distinct --instance_id, 
                                                                        instance_date, release_plan_id, amend_plan_id, division_id, factory_id, work_order_id
                                                                      , batch_order_id, operation_id, equipment_id, fix_type, item_id, actual_flag, close_flag
                                                        FROM FP_RELEASE_FIX_PLAN_H b
                                                        --where  b.instance_id      = @v_master_id
                                                        where  b.instance_id      in (  @v_master_id, @v_master_id + '_A', @v_master_id + '_M' )
                                                        and    b.release_plan_id  = @release_plan_id
                                                        ----------------------------
                                                        ----------------------------
                                                        except
                                                        ----------------------------
                                                        ----------------------------
                                                        select distinct --instance_id, 
                                                                        instance_date, release_plan_id, amend_plan_id, division_id, factory_id, work_order_id
                                                                      , batch_order_id, operation_id, equipment_id, fix_type, item_id, actual_flag, close_flag
                                                        from   (              
                                                                -- 계획월과 R plan의 계획월이 같은 경우 close_flag = 'Y' 분 제외
                                                                select distinct --instance_id, 
                                                                                instance_date, release_plan_id, amend_plan_id, division_id, factory_id, work_order_id
                                                                              , batch_order_id, operation_id, equipment_id, fix_type, item_id, actual_flag, close_flag
                                                                FROM FP_RELEASE_FIX_PLAN_H b
                                                                --where  b.instance_id      = @v_master_id
                                                                where  b.instance_id      in (  @v_master_id, @v_master_id + '_A', @v_master_id + '_M' )
                                                                and    b.release_plan_id  = @release_plan_id
                                                                and    ( substring(b.instance_date, 1, 6) = @v_plan_month and -- 계획월과 R plan의 계획월이 같고
                                                                         isnull(b.close_flag, 'N') = 'Y'                      -- close_flag  = Y 제외
                                                                       )
                                                                ----------------------------
                                                                union all
                                                                ----------------------------
                                                                select distinct --instance_id, 
                                                                                instance_date, release_plan_id, amend_plan_id, division_id, factory_id, work_order_id
                                                                              , batch_order_id, operation_id, equipment_id, fix_type, item_id, actual_flag, close_flag
                                                                FROM FP_RELEASE_FIX_PLAN_H b
                                                                --where  b.instance_id      = @v_master_id
                                                                where  b.instance_id      in (  @v_master_id, @v_master_id + '_A', @v_master_id + '_M' )
                                                                and    b.release_plan_id  = @release_plan_id
                                                                and    ( substring(b.instance_date, 1, 6) <  @v_plan_month                    and  -- 계획월과 R plan의 계획월이 다르고
                                                                         substring(b.instance_date, 7, 2) != '01'                             and  -- R plan의 계획일이 1 일이 아니고
                                                                         substring(CONVERT(varchar, b.plan_date , 112), 1, 6) = @v_plan_month and  -- WO의 Plan date가 pst기준월과 같은월 이고
                                                                         isnull(b.close_flag, 'N')  = 'Y'                                          -- close_flag  = Y 이면 제외
                                                                       ) 
                                                              ) a   
                                                    ) b
                                                    where b.work_order_id = a.work_order_id  
                                            )  
                           ) b
                           on      a.factory_id       = b.factory_id
                           and     a.operation_id     = b.operation_id
                           and     a.equipment_id     = b.equipment_id
                           and     a.item_id          = b.item_id
                           and     a.PRODUCTION_TYPE  = b.PRODUCTION_TYPE -- add
                           and     a.MARKET           = b.MARKET          -- add
                           and     a.seq              = b.seq
                           and     a.plan_date        = b.plan_date       -- 2018.04.11 : 일자별 seq 별 확정 work order 할당
                    where  a.instance_id  = @v_master_id
                    and    a.fp_plan_id   = @v_plan_id
                    and    a.factory_id   = @v_factory_id   
                   ) b
            where  a.instance_id    = b.instance_id
            and    a.fp_plan_id     = b.fp_plan_id
            and    a.work_order_id  = b.work_order_id
            --and    isnull(a.merge_work_order_id, a.work_order_id) = isnull(b.merge_work_order_id, b.work_order_id)

            SET @n_row_count = @@ROWCOUNT
            
            --LOG 생성
            SET @v_message = 'FIX_WORK : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

            -- 환산자 없는 애들은 NULL 처리 함..
            -- 실제로 BATCH 환산하여 AMEND 한 정보만 BATCH 수량을 사용하고, 나머진 BOM 전개해야 하므로,,
            UPDATE A
            SET    A.BATCH_QTY      = NULL
                 , A.BATCH_IN_QTY   = NULL
            FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY A
            WHERE  A.INSTANCE_ID  = @v_master_id
            AND    A.FP_PLAN_ID   = @v_plan_id
            AND    A.FACTORY_ID   = @v_factory_id
            AND    NOT EXISTS (
                                SELECT 1
                                FROM   SCM_ITEM_CONV_CALC_M X
                                WHERE  X.MAX_VER_FLAG   = 'Y'
                                AND    X.VERSION        NOT LIKE 'Z%'
                                AND    X.COMPANY_ID     = A.COMPANY_ID
                                AND    X.DIVISION_ID    = A.DIVISION_ID
                                AND    X.SITE_ID        = A.SITE_ID
                                AND    X.PLANT_ID       = A.PLANT_ID
                                AND    X.FACTORY_ID     = A.FACTORY_ID
                                AND    X.OPERATION      = A.OPERATION_ID
                                AND    X.ELECTRODE_TYPE = A.ELECTRODE_TYPE
                                --AND    X.MODEL_ID       = A.TOP_ITEM_ID
                                AND    X.ITEM_ID        = A.ITEM_ID
                                AND    X.CATEGORY       = ( CASE A.ITEM_UOM WHEN 'EA' THEN 'cell/batch'
                                                                            WHEN 'M'  THEN 'm/batch'
                                                                            WHEN 'KG' THEN 'Slurry (kg/batch)'
                                                                                      ELSE 'XXXX'
                                                            END )
                              )

            SET @n_row_count = @@ROWCOUNT
            
            UPDATE A
            SET    A.BATCH_QTY      = NULL
                 , A.BATCH_IN_QTY   = NULL
            FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY A
            WHERE  A.INSTANCE_ID  = @v_master_id
            AND    A.FP_PLAN_ID   = @v_plan_id
            AND    A.FACTORY_ID   = @v_factory_id
            AND    A.BATCH_QTY   <= 0

            SET @n_row_count += @@ROWCOUNT

            --LOG 생성
            SET @v_message = 'BATCH_QTY = NULL : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


            SET @v_table_name = 'fp_amend_production_plan_r'

            DELETE FROM A
            FROM   fp_amend_production_plan_r A
            WHERE  A.MASTER_ID          = @v_master_id
            AND    A.PLAN_ID            = @v_plan_id
            AND    A.AFTER_SITE_ID      = @v_factory_id
            AND    A.AFTER_OPERATION_ID in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater / Mixer 공정..!!

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
                 , MARKET
                 , TOP_ITEM_ID
                 , INSERT_ID
                 , INSERT_TIME
                 , UPDATE_ID
                 , UPDATE_TIME
                 )
            SELECT A.INSTANCE_ID        AS MASTER_ID
                 , A.FP_PLAN_ID         AS PLAN_ID
                 , ISNULL(A.FIX_WORK_ORDER_ID, A.WORK_ORDER_SPL_ID)  AS WORK_ORDER_ID
                 , A.FACTORY_ID         AS BEFORE_SITE_ID
                 , A.FACTORY_ID         AS AFTER_SITE_ID
                 , A.LINE_ID            AS BEFORE_ROUTE_ID
                 , A.LINE_ID            AS AFTER_ROUTE_ID
                 , A.OPERATION_ID       AS BEFORE_OPERATION_ID
                 , A.OPERATION_ID       AS AFTER_OPERATION_ID
                 , A.EQUIPMENT_ID       AS BEFORE_RESOURCE_ID
                 , A.EQUIPMENT_ID       AS AFTER_RESOURCE_ID
                 , CONVERT(NVARCHAR, A.PLAN_DATE, 112)          AS BEFORE_PLAN_DATE
                 , CONVERT(NVARCHAR, A.PLAN_DATE, 112)          AS AFTER_PLAN_DATE
                 , REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR, A.START_TIME, 120), ':', ''), '-', ''), ' ', '') AS BEFORE_START_TIME
                 , REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR, A.START_TIME, 120), ':', ''), '-', ''), ' ', '') AS AFTER_START_TIME
                 , REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR, A.END_TIME,   120), ':', ''), '-', ''), ' ', '') AS BEFORE_END_TIME
                 , REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR, A.END_TIME,   120), ':', ''), '-', ''), ' ', '') AS AFTER_END_TIME
                 , A.TOTAL_WORKING_TIME AS WORKING_TIME
                 , A.PLAN_DATE_SEQ      AS BEFORE_SEQ
                 , A.PLAN_DATE_SEQ      AS AFTER_SEQ
                 , A.PLAN_QTY           AS BEFORE_QTY
                 , A.PLAN_QTY           AS AFTER_QTY
                 , A.PLAN_IN_QTY        AS BEFORE_IN_QTY
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
                 , A.MARKET
                 , A.TOP_ITEM_ID
                 , A.INSERT_ID
                 , A.INSERT_TIME
                 , A.INSERT_ID          AS UPDATE_ID
                 , A.INSERT_TIME        AS UPDATE_TIME
            FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY A
            WHERE  A.INSTANCE_ID  = @v_master_id
            AND    A.FP_PLAN_ID   = @v_plan_id
            AND    A.FACTORY_ID   = @v_factory_id
            AND    A.OPERATION_ID in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater / Mixer 공정..!!

            SET @n_row_count = @@ROWCOUNT

            --LOG 생성
            SET @v_message = CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          END

        END


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


-------------------------------------------------
        -- fp_amend_production_plan_r.BATCH_ORDER_ID <- 머지한 merge_batch_order_id 를 쓰지 않고
        --                                              Batch_group_id 로 넣는 로직을 적용
-------------------------------------------------
         begin

            SET @v_table_name = 'fp_amend_production_plan_r'

            update  fp_amend_production_plan_r
            set     fp_amend_production_plan_r.BATCH_ORDER_ID =  isnull(b.batch_id, b.item_id)
            from    fp_amend_production_plan_r a,
                    (
                      select  a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_operation_id, a.item_id
                            , b.batch_id       
                      from   fp_amend_production_plan_r a
                      left outer join
                           (
                            select a.company_id, a.division_id, a.site_id, a.plant_id, a.factory_id,
                                   b.item_id, b.batch_id
                            from   (
                                    select * 
                                    from   scm_factory_m    
                                    where  factory_id = @v_factory_id -- 'E6'
                                   ) a,
                                   (
                                    select *--item_id 
                                    from   scm_batch_m    
                                    --where  company_id = 'C100'
                                    --and    division_id = '81'
                                    --and    site_id = 'A001'
                                    --and    plant_id = 'A041'
                                   ) b
                            where  a.company_id  = b.company_id
                            and    a.division_id = b.division_id
                            and    a.site_id     = b.site_id
                            and    a.plant_id    = b.plant_id                                       
                            ) b
                      on a.item_id = b.item_id                                  
                      where  master_id     = @v_master_id  -- 'KR_SRS'
                      and    plan_id       = @v_plan_id    -- 'KR_SRS-20170529-00'
                      and    after_site_id = @v_factory_id -- 'E6'
                      and    after_operation_id in ( @v_batch_id_merge_op1, @v_batch_id_merge_op2, @v_batch_id_merge_op3, @v_batch_id_merge_op4, @v_batch_id_merge_op5, @v_batch_id_merge_op6 )
                    ) b
            where  a.master_id           = b.master_id
            and    a.plan_id             = b.plan_id
            and    a.work_order_id       = b.work_order_id
          
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

         end




-- BATCH_ORDER_ID Merge end
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


    END  
    

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
