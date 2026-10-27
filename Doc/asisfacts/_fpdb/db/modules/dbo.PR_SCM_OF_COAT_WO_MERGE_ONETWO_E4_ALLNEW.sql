CREATE PROCEDURE [dbo].[PR_SCM_OF_COAT_WO_MERGE_ONETWO_E4_ALLNEW]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_factory_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_COAT_WO_MERGE_ONETWO_E4                                         **/
/** 프로그램 명   : Coating 공정 WO merge                                                     **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument      :                                                                           **/
/**     EXEC PR_SCM_OF_COAT_WO_MERGE_ONETWO_E4 @v_master_id, @v_plan_id, @v_factory_id        **/
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
/** 20170609       ksjeon        머지로직 전면 재개발                                         **/
/**                       1. coating 공정 기준의 머지 작성                                    **/
/**                       2. coating 공정기준으로 mixer 공정 계획 수립                        **/
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_OF_COAT_WO_MERGE_ONETWO_E4_ALLNEW'
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
      SET @v_message = 'IS_WO_MERGE : ' + @v_is_wo_merge + ' / Factory_id : ' + @v_factory_id + ' / IS_CO_MERGE : ' + @v_is_co_merge 
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
        

        BEGIN

          SET @v_table_name = 'SCM_OPERATION_M'
          select distinct @v_coat_mid_char = a.erp_operation_id
          --select distinct a.company_id, a.division_id, a.site_id, a.operation_id, a.erp_operation_id, b.plant_id, b.factory_id
          from   (
                  select distinct a.company_id, a.division_id, a.site_id, a.operation_id, a.erp_operation_id
                  from   SCM_OPERATION_M a
                  where  a.erp_operation_id is not null
                 ) a,
                 (
                  select distinct a.company_id, a.division_id, a.site_id, a.plant_id, a.factory_id
                  from   scm_factory_m a
                 ) b
          where  a.company_id  = b.company_id
          and    a.division_id = b.division_id
          and    a.site_id     = b.site_id
          and    a.operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6)
          and    b.factory_id = @v_factory_id
                 
          --LOG 생성
          SET @v_message = ' v_coat_mid_char : ' + @v_coat_mid_char
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
          
        END    

        BEGIN

          SET @v_table_name = 'SCM_OPERATION_M'
          select distinct @v_mix_mid_char = a.erp_operation_id
          --select distinct a.company_id, a.division_id, a.site_id, a.operation_id, a.erp_operation_id, b.plant_id, b.factory_id
          from   (
                  select distinct a.company_id, a.division_id, a.site_id, a.operation_id, a.erp_operation_id
                  from   SCM_OPERATION_M a
                  where  a.erp_operation_id is not null
                 ) a,
                 (
                  select distinct a.company_id, a.division_id, a.site_id, a.plant_id, a.factory_id
                  from   scm_factory_m a
                 ) b
          where  a.company_id  = b.company_id
          and    a.division_id = b.division_id
          and    a.site_id     = b.site_id
          and    a.operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )    
          and    b.factory_id = @v_factory_id
                 
          --LOG 생성
          SET @v_message = ' @v_mix_mid_char : ' + @v_mix_mid_char
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
          
        END    
        
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

        -- 2018.03.19 : 1일 1 WORK 계획 먼저 수립함.
        BEGIN
        
          SET @v_table_name = 'FP_AMEND_DAILY_PLAN_R'

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
-- Coating WO merge 후 Mixer WO One to one 생성
-- sy_fp_amend_production_plan_r -> TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

        if @v_master_id = 'KR_E_PRE_A' or
           @v_master_id = 'KR_E_PRE_M' or
           @v_master_id = 'US_E_PRE'   or
           @v_master_id = 'CN_E_PRE'   or
           @v_master_id = 'KR_SRS'     
           begin

            BEGIN
            
              SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER'
              
              DELETE FROM TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER
              WHERE   MASTER_ID     = @v_master_id
              AND     PLAN_ID       = @v_plan_id
              and     AFTER_SITE_ID = @v_factory_id

              SET @v_message = @@ROWCOUNT
              SET @n_log_count += 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER', 'DELETE', @n_log_count, null, @v_message, null 


              insert into TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER
                     (
                      MASTER_ID,PLAN_ID,WORK_ORDER_ID,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
                      ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE,BEFORE_START_TIME
                      ,AFTER_START_TIME,BEFORE_END_TIME,AFTER_END_TIME,WORKING_TIME,BEFORE_SEQ,AFTER_SEQ,BEFORE_QTY,AFTER_QTY,BEFORE_IN_QTY
                      ,AFTER_IN_QTY,ITEM_ID,FIXED_YN,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK,ORG_WORK_ORDER_ID
                      ,DEMAND_DUE_DATE,BATCH_ORDER_ID,DATE_FIX_FLAG,DATE_FIX_DATE,OPERATION_EPST,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                      ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_QTY,UI_EDIT_YN
                      ,MARKET,TOP_ITEM_ID
                      , DESCRIPTION,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
                      )
              select 
                      MASTER_ID,PLAN_ID,WORK_ORDER_ID,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
                      ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE,BEFORE_START_TIME
                      ,AFTER_START_TIME,BEFORE_END_TIME,AFTER_END_TIME,WORKING_TIME,BEFORE_SEQ,AFTER_SEQ,BEFORE_QTY,AFTER_QTY,BEFORE_IN_QTY
                      ,AFTER_IN_QTY,ITEM_ID,FIXED_YN,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK,ORG_WORK_ORDER_ID
                      ,DEMAND_DUE_DATE,BATCH_ORDER_ID,DATE_FIX_FLAG,DATE_FIX_DATE,OPERATION_EPST,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                      ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_QTY,UI_EDIT_YN
                      ,MARKET,TOP_ITEM_ID
                      , DESCRIPTION,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
              from fp_amend_production_plan_r
              where master_id      = @v_master_id
              and   plan_id        = @v_plan_id
              and   AFTER_SITE_ID  = @v_factory_id
              
              SET @v_message = @@ROWCOUNT
              SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER'
              SET @n_log_count = @n_log_count + 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
              
            END           


    --------------------------------------------------------
    --------------------------------------------------------

    --        BEGIN
    --          SET @v_table_name = 'PR_SCM_OF_MANUAL_PLAN_MIXER_REG'
    --
    --          -- Coater 와 1 : 1 로 Mixer 정보를 생성한다
    --          -- TH_BUF_E1000_PLAN_TARGET
    --          EXEC PR_SCM_OF_MANUAL_PLAN_MIXER_REG  @v_master_id, @v_plan_id, @v_factory_id
    --          
    --        END


        ---------------------------
        -- E_PRE E1000 계획 생성용 buf table 생성
        -- TH_BUF_E1000_PLAN_TARGET
        ---------------------------
            BEGIN
            
              SET @v_table_name = 'TH_BUF_E1000_PLAN_TARGET'
              
              DELETE FROM TH_BUF_E1000_PLAN_TARGET
              WHERE  MASTER_ID     = @v_master_id
              AND    PLAN_ID       = @v_plan_id
              AND    AFTER_SITE_ID = @v_factory_id

              SET @v_message = @@ROWCOUNT
              SET @n_log_count += 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_E1000_PLAN_TARGET', 'DELETE', @n_log_count, null, @v_message, null 


              
              -- site, route, item, plan_date 별 계획 대상 물량 구하기     
              -- plan_qty > 0 인건이 PLAN 대상건
              insert into TH_BUF_E1000_PLAN_TARGET
                      (
                        master_id,plan_id,E2000_WORK_ORDER_ID,work_order_id,after_site_id,after_route_id
                        ,after_operation_id,after_resource_id,after_plan_date,after_start_time,after_end_time,after_qty,after_in_qty
                        ,item_id,demand_id,demand_type,market,TOP_ITEM_ID
                        ,E2000_START_TIME,E2000_END_TIME,E2000_PLAN_DATE,E2000_item_id,fixed_yn, E2000_org_qty,org_qty
                        ,r
                        ,acu_org_qty,stock_qty,remain_qty,plan_qty
                        ,INSERT_ID,INSERT_TIME
                      )
              select a.master_id, a.plan_id
                     , a.E2000_WORK_ORDER_ID
                     , replace(a.E2000_WORK_ORDER_ID, @v_coat_mid_char, @v_mix_mid_char) work_order_id -- CT -> MX
                     , a.after_site_id, a.after_route_id, a.after_operation_id
                     , a.after_resource_id -- null
                     , a.after_plan_date   -- null
                     , a.after_start_time  -- null
                     , a.after_end_time    -- null
                     , a.after_qty 
                     , a.after_in_qty
                     , a.item_id
                     , a.demand_id
                     , a.demand_type
                     , a.market
                     , A.TOP_ITEM_ID
                     , a.E2000_START_TIME
                     , A.E2000_end_TIME
                     , a.E2000_PLAN_DATE
                     , a.E2000_item_id
                     , a.fixed_yn
                     , a.E2000_after_in_qty as E2000_org_qty -- E2000->after_in_qty 수량
                     , a.org_qty -- consume rate 적용 ( E1000의 필요량 ) 
                     , a.r
                     , a.acu_org_qty
                     , a.stock_qty
                     , a.acu_org_qty - a.stock_qty as remain_qty
                     -- 재고 차감후 생산 계획 수량
                     , case when ( a.acu_org_qty - a.stock_qty ) <= 0 
                            then 0                                                             -- 전량 차감건
                            else ( case when ( a.org_qty - (a.acu_org_qty - a.stock_qty) ) > 0  
                                        then ( (a.acu_org_qty - a.stock_qty) )                 -- 일부차감 -> 잔량 있는건 ( 원수량 - 차감잔량 )
                                        else a.org_qty                                         -- 차감되지 않은건 ( 원수량유지 )
                                    end  )
                       end  
                       as plan_qty
                     ,  @v_proc_name AS INSERT_ID
                     ,  GETDATE()    AS INSERT_TIME
              from   (
                      select a.master_id, a.plan_id, a.E2000_WORK_ORDER_ID, a.after_site_id, a.after_route_id, a.after_operation_id
                             , a.after_resource_id -- null
                             , a.after_plan_date   -- null
                             , a.after_start_time  -- null
                             , a.after_end_time    -- null
                             , a.E2000_after_in_qty * a.child_item_rate                     as after_qty
                             , ( a.E2000_after_in_qty * a.child_item_rate ) / isnull(c.E1000_YIELD, 1) as after_in_qty
                             , a.item_id
                             , a.demand_id
                             , a.demand_type
                             , a.market
                             , A.TOP_ITEM_ID
                             , a.E2000_START_TIME
                             , A.E2000_end_TIME
                             , a.E2000_PLAN_DATE
                             , a.E2000_item_id
                             , a.fixed_yn
                             , a.E2000_after_in_qty      -- E2000->after_in_qty 수량
                             -- , d.E2000_YIELD, c.E1000_YIELD, a.child_item_rate
                             -- Mixer Qty = (Coater Plan Qty / Coater Yield * Child Rate(BOM))/ Mixer Yield
                             , ( a.E2000_after_in_qty * a.child_item_rate ) / isnull(c.E1000_YIELD, 1) as org_qty -- consume rate 적용 ( E1000의 필요량 )
                             , dense_rank() over( partition by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type, a.market
                                                      order by a.E2000_item_id, a.E2000_PLAN_DATE, a.E2000_WORK_ORDER_ID ) 
                               as r
                             , sum( a.E2000_after_in_qty * a.child_item_rate ) over( partition by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type, a.market
                                                        order by a.E2000_item_id, a.E2000_PLAN_DATE, a.E2000_WORK_ORDER_ID ) 
                               as acu_org_qty
                             , isnull(b.stock_qty, 0) as stock_qty 
                             , b.fp_apply_item_id 
                             , a.ord_priority
                      from   (
                               select a.master_id, a.plan_id, a.E2000_WORK_ORDER_ID, a.after_site_id, a.after_route_id, a.after_operation_id
                                     , after_resource_id -- null
                                     , after_plan_date   -- null
                                     , after_start_time  -- null
                                     , after_end_time    -- null
                                     , after_qty         -- null
                                     , after_in_qty      -- null
                                     , b.child_item_id    as item_id  -- Item에서 '_XXXX' 제거
                                     , a.demand_id
                                     , a.demand_type
                                     , a.market
                                     , A.TOP_ITEM_ID
                                     , a.E2000_START_TIME
                                     , A.E2000_end_TIME
                                     , a.E2000_PLAN_DATE
                                     , a.E2000_item_id
                                     , a.fixed_yn
                                     , a.E2000_after_in_qty
                                     , b.alt_priority 
                                     , b.parent_item_rate, b.child_item_rate
                                     , row_number() over ( partition by a.e2000_item_id, a.e2000_work_order_id order by b.alt_priority, b.child_item_id) as ord_priority
                             from    (        
                                      select  a.master_id
                                             , a.plan_id
                                             , a.work_order_id as E2000_WORK_ORDER_ID
                                             , a.after_site_id
                                             -------------------------------------------------
                                             -------------------------------------------------
                                             -- E2000 의 route_id 와 동일한지 확인할것 ksjeon
                                             , a.after_route_id     
                                             -------------------------------------------------
                                             , case when a.after_operation_id = 'E2000' then 'E1000'
                                                    when a.after_operation_id = 'S2000' then 'S1000' 
                                                    else 'XXXX'
                                               end  as after_operation_id
                                             , null as after_resource_id
                                             , null as after_plan_date
                                             , null as after_start_time
                                             , null as after_end_time
                                             , a.after_start_time as E2000_START_TIME
                                             , A.after_end_time   as E2000_end_TIME
                                             , a.after_plan_date  as E2000_PLAN_DATE
                                             , a.item_id          as E2000_item_id
                                             , a.fixed_yn
                                             , a.after_in_qty     as E2000_after_in_qty
                                             , null               as after_qty
                                             , null               as after_in_qty
                                             --, a.after_in_qty     as org_qty
                                             , a.demand_id
                                             , a.demand_type
                                             , a.market
                                             , A.TOP_ITEM_ID
                                      from    (        
                                              select 
                                                      master_id,plan_id,work_order_id,before_site_id,after_site_id,before_route_id,after_route_id,before_operation_id
                                                      ,after_operation_id,before_resource_id,after_resource_id,before_plan_date,after_plan_date,before_start_time
                                                      ,after_start_time,before_end_time,after_end_time,working_time,before_seq,after_seq,before_qty,after_qty,before_in_qty
                                                      ,after_in_qty,item_id,fixed_yn,split_yn,demand_id,demand_type,order_id,order_type,po_id,mfg_week,sop_week,org_work_order_id
                                                      ,demand_due_date,batch_order_id,date_fix_flag,date_fix_date,operation_epst,operation_lpst,lane_qty,lane_tact_qty,item_uom
                                                      ,wo_day_split_yn,setup_time,setup_time_uom,batch_qty,ui_edit_yn,market,TOP_ITEM_ID, description,insert_id,insert_time,update_id,update_time
                                              from   fp_amend_production_plan_r --TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
                                              where  master_id      = @v_master_id
                                              and    plan_id        = @v_plan_id
                                              and    after_site_id  = @v_factory_id
                                              --and    demand_type   <> 'TEST'        -- 2018.04.04 : TEST 는 하위계획을 수립하지 않는다.
                                              --and    demand_id = N'A^A^20170424^ACEN1058I-A1^오창공장조립셀13호::PFD01000001'
                                              and    after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater  공정..!!
                                              ) a  
                                      ) a          
                                      inner join
                                          (
                                              select a.parent_item_id, a.child_item_id, a.alt_priority, a.parent_item_rate, a.child_item_rate, a.route_id,
                                                     row_number() over ( partition by parent_item_id, a.route_id order by a.alt_priority, child_item_id) as r 
                                              from   (
                                                      -- E2000 공정에서 E1000의 Parent 기종 정보를 찾는다
                                                      SELECT DISTINCT
                                                             AA.PARENT_ITEM_ID
                                                            ,AA.CHILD_ITEM_ID
                                                            ,AA.ALT_PRIORITY
                                                            ,AA.PARENT_QTY / AA.PARENT_QTY AS PARENT_ITEM_RATE
                                                            ,AA.CHILD_QTY  / AA.PARENT_QTY AS CHILD_ITEM_RATE
                                                            ,EE.LINE_ID AS ROUTE_ID
                                                            ,AA.ALT_ID
                                                      FROM   SCM_BOM_M AA,
                                                             (
                                                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, 
                                                                     MIN(KEY_DATE) AS KEY_DATE
                                                              FROM   SCM_BOM_M         A,
                                                                     SCM_ITEM_M        B,
                                                                     SCM_ITEM_CLASS_M  C
                                                              WHERE  1=1
                                                              AND    A.ACTIVE_FLAG    = 'Y'
                                                              AND    A.COMPANY_ID     = B.COMPANY_ID
                                                              AND    A.DIVISION_ID    = B.DIVISION_ID
                                                              AND    A.SITE_ID        = B.SITE_ID
                                                              AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
                                                              AND    B.ACTIVE_FLAG    = 'Y'
                                                              AND    B.ITEM_CLASS     = C.CLASS_ID  
                                                              AND    C.USE_FLAG       = 'Y'                    
                                                              AND    A.EFF_END_DATE   > CONVERT(DATE, GETDATE())              
                                                              GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.KEY_DATE
                                                              --GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                                                             ) BB,
                                                             SCM_ITEM_M        CC,
                                                             SCM_ITEM_CLASS_M  DD,
                                                             (
                                                              SELECT COMPANY_ID
                                                                   , DIVISION_ID
                                                                   , SITE_ID
                                                                   , PLANT_ID
                                                                   , ITEM_ID
                                                                   , LINE_ID
                                                              FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY
                                                              WHERE  INSTANCE_ID    = @v_master_id
                                                              AND    FP_PLAN_ID     = @v_plan_id
                                                              AND    FACTORY_ID     = @v_factory_id
                                                              GROUP  BY COMPANY_ID
                                                                      , DIVISION_ID
                                                                      , SITE_ID
                                                                      , PLANT_ID
                                                                      , ITEM_ID
                                                                      , LINE_ID             
                                                             ) EE
                                                      WHERE  AA.COMPANY_ID      = BB.COMPANY_ID
                                                      AND    AA.DIVISION_ID     = BB.DIVISION_ID
                                                      AND    AA.SITE_ID         = BB.SITE_ID
                                                      AND    AA.PLANT_ID        = BB.PLANT_ID
                                                      AND    AA.PARENT_ITEM_ID  = BB.PARENT_ITEM_ID
                                                      AND    AA.CHILD_ITEM_ID   = BB.CHILD_ITEM_ID
                                                      AND    AA.KEY_DATE        = BB.KEY_DATE
                                                      AND    AA.COMPANY_ID      = CC.COMPANY_ID
                                                      AND    AA.DIVISION_ID     = CC.DIVISION_ID
                                                      AND    AA.SITE_ID         = CC.SITE_ID
                                                      AND    AA.CHILD_ITEM_ID   = CC.ITEM_ID  
                                                      AND    CC.ACTIVE_FLAG     = 'Y'
                                                      AND    CC.ITEM_CLASS      = DD.CLASS_ID  
                                                      AND    DD.USE_FLAG        = 'Y'                    
                                                      AND    AA.ACTIVE_FLAG     = 'Y'
                                                      AND    AA.BOM_VERSION_ID  = '1'
                                                      AND    AA.EFF_END_DATE    >  CONVERT(DATE, GETDATE())
                                                      AND    AA.COMPANY_ID      = EE.COMPANY_ID
                                                      AND    AA.DIVISION_ID     = EE.DIVISION_ID
                                                      AND    AA.SITE_ID         = EE.SITE_ID
                                                      AND    AA.PLANT_ID        = EE.PLANT_ID
                                                      AND    AA.PARENT_ITEM_ID  = EE.ITEM_ID
                                                      AND    DD.LEVEL_2_NAME LIKE 'Slurry'
                                                      and    DD.class_id not in ( 'ES01', 'ES0101' ) -- 선분산 제외 
                                                      AND    EXISTS (
                                                                      SELECT 1
                                                                      FROM   SCM_ITEM_LINE_ASSIGN_M X
                                                                      WHERE  X.COMPANY_ID   = AA.COMPANY_ID
                                                                      AND    X.DIVISION_ID  = AA.DIVISION_ID
                                                                      AND    X.SITE_ID      = AA.SITE_ID
                                                                      AND    X.PLANT_ID     = AA.PLANT_ID
                                                                      AND    X.ITEM_ID      = AA.CHILD_ITEM_ID
                                                                      AND    X.FACTORY_ID   = @v_factory_id       -- COAT, MIXER 간 FACTORY 제약 설정
                                                                      AND    X.ACTIVE_FLAG  = 'Y'
                                                                      AND    X.PRIORITY     IN ( 1,2,3,4,5,6,7,8)
                                                                      AND    X.MONTH        = CONVERT(NVARCHAR(6), GETDATE(), 112)
                                                                    )
                                                     ) a 
                                      ) b
                                        on   a.E2000_item_id  = b.parent_item_id
                                        and  a.after_route_id = b.route_id
                                        --and  b.r = 1
                                        and  b.child_item_id not in ( select item_id 
                                                                    from   SCM_ITEM_LINE_ASSIGN_EXCEPT_M
                                                                    where  1=1
                                                                    and    active_flag = 'N'
                                                                    and    CONVERT(DATETIME,        SUBSTRING(a.E2000_START_TIME,  1, 4) 
                                                                                            + '-' + SUBSTRING(a.E2000_START_TIME,  5, 2)
                                                                                            + '-' + SUBSTRING(a.E2000_START_TIME,  7, 2)
                                                                                            + ' ' + SUBSTRING(a.E2000_START_TIME,  9, 2)
                                                                                            + ':' + SUBSTRING(a.E2000_START_TIME, 11, 2)
                                                                                            + ':' + SUBSTRING(a.E2000_START_TIME, 13, 2)) between start_time and end_time
                                                                    )
                             ) a 
                             left outer join
                                 ( 
                                  -- stock 미사용
                                  select factory_id
                                         , fp_apply_item_id
                                         , sum(qty) as stock_qty
                                  from   scm_stock_h
                                  where  cutoff_date = @v_cutoff_date --'2017-04-17'
                                  and    stock_type  = 'WIP'
                                  and    fp_apply_operation_id = 'XXXXX' --@v_operation_E1000
                                  and    fp_apply_wipqty > 0
                                  group by factory_id, fp_apply_item_id
                              ) b
                                  on a.after_site_id = b.factory_id
                                  and a.item_id      = b.fp_apply_item_id
                             left outer join
                                 (
                                    -- * 수율 ( SCM_YIELD_M )
                                    select factory_id, operation_id, line_id, item_id, month
                                           , case when yield = null then 1
                                                  when yield = 0    then 1
                                                  else yield
                                             end as E1000_YIELD 
                                    from   SCM_YIELD_M
                                    where  1=0                          -- 2018.03.28 : Mixer 계획에서는 Yield 를 반영하지 않는다.
                                    and    factory_id   = @v_factory_id
                                    and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                             ) c
                                 on   a.after_operation_id = c.operation_id
                                 and  a.after_site_id      = c.factory_id 
                                 and  a.after_route_id     = c.line_id
                                 and  a.item_id            = c.item_id
                                 and  substring(a.E2000_PLAN_DATE, 1, 6) = c.month
                             left outer join
                                 (
                                    -- * 수율 ( SCM_YIELD_M )
                                    select factory_id, operation_id, line_id, item_id, month
                                           ,case when yield = null then 1
                                                 when yield = 0    then 1
                                                 else yield
                                            end as E2000_YIELD 
                                    from   SCM_YIELD_M
                                    where  factory_id   = @v_factory_id
                                    and    operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater  공정..!!
                             ) d
                                 on   a.after_site_id      = d.factory_id 
                                 and  a.after_route_id     = d.line_id
                                 and  a.E2000_item_id      = d.item_id
                                 and  substring(a.E2000_PLAN_DATE, 1, 6) = d.month
                      ) a
                      where ord_priority = 1 -- 우선순위 1번만
              order by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type, a.market, a.E2000_item_id, a.E2000_PLAN_DATE, a.E2000_WORK_ORDER_ID
               



              SET @v_message = @@ROWCOUNT
              SET @v_table_name = 'TH_BUF_E1000_PLAN_TARGET'
              SET @n_log_count = @n_log_count + 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
              
            END           
            
            
        ---------------------------
        -- TH_BUF_E1000_PLAN_TARGET -> TH_BUF_E1000_PLAN_TARGET_E4
        -- E4 Factory의 Coater(1) :  Mixer(2)  처리를 위해 Buff 추가
        -- 
        ---------------------------
            BEGIN
            
              SET @v_table_name = 'TH_BUF_E1000_PLAN_TARGET_E4'
              
              DELETE FROM TH_BUF_E1000_PLAN_TARGET_E4
              WHERE  MASTER_ID     = @v_master_id
              AND    PLAN_ID       = @v_plan_id
              AND    AFTER_SITE_ID = @v_factory_id

              SET @v_message = @@ROWCOUNT
              SET @n_log_count += 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_E1000_PLAN_TARGET_E4', 'DELETE', @n_log_count, null, @v_message, null 

              insert into  TH_BUF_E1000_PLAN_TARGET_E4
              (
                      master_id,plan_id,E2000_WORK_ORDER_ID,work_order_id
                      , attb1
                      ,after_site_id,after_route_id,after_operation_id,after_resource_id,after_plan_date
                      ,after_start_time,after_end_time,after_qty,after_in_qty
                      ,item_id,FIXED_YN,demand_id,demand_type,market,TOP_ITEM_ID
                      ,E2000_START_TIME,E2000_END_TIME,E2000_PLAN_DATE,E2000_item_id,E2000_org_qty
                      ,org_qty,plan_qty,batch_lot_size,batch_count,min_batch_apply,tat
                      ,resource_count,divide_count,add_count,res1_qty,res2_qty,tot_tat1,tot_tat2,r
                      ,tat_min,E1000_YIELD
                      --attb2
                      --attb3
                      --attb4
                      --attb5
                      ,INSERT_ID,INSERT_TIME
                     ) 
              
              select a.MASTER_ID, a.PLAN_ID
                     , a.E2000_WORK_ORDER_ID
                     , substring(a.work_order_id, 1, charindex(@v_mix_mid_char, a.work_order_id)+1)
                        + '#'
                        + @v_instance_sub_code
                        + '#'
                        + @v_factory_id
                        + '#'
                        + SUBSTRING(A.PLAN_ID, CHARINDEX('-', A.PLAN_ID, CHARINDEX('-', A.PLAN_ID)+1)+1, 9)
                        + '#'
                        + ( CASE WHEN SEQ < 10 THEN '000'
                                 WHEN SEQ < 100 THEN '00'
                                 WHEN SEQ < 1000 THEN '0'
                                                        ELSE ''
                            END  
                          )
                        + CONVERT(NVARCHAR, A.SEQ)
                        as work_order_id
                     , a.work_order_id as attb1
                     , a.after_site_id, a.after_route_id, a.after_operation_id
                     , a.RESOURCE_ID as after_resource_id
                     , a.after_plan_date, a.after_start_time, a.after_end_time
                     , ceiling(a.final_after_in_qty * isnull(b.E1000_YIELD, 1) ) as after_qty 
                     , a.final_after_in_qty                          as after_in_qty 
                     , a.item_id
                     , a.fixed_yn, a.demand_id , a.demand_type, a.market, A.TOP_ITEM_ID
                     , a.e2000_start_time, a.e2000_end_time, a.e2000_plan_date, a.e2000_item_id, a.e2000_org_qty, a.org_qty
                     --,a.r,a.acu_org_qty,a.stock_qty,a.remain_qty
                     , a.plan_qty                                   -- 계획대상 수량
                     , a.batch_lot_size                             -- Batch lot size
                     , a.batch_count                                -- Batch 수 ( 1.1 => 1 )
                     , a.min_batch_apply                            -- MinLot Qty
                     , a.tat                                        -- 1 Batch time
                     , a.resource_count                             -- Mixer 설비 대수
                     , a.divide_count                               -- 나머지를 뺀 몫 수 floor( 3 / 2 ) => 1
                     , a.add_count                                  -- 잔량이 어디로 가야하는지 확인용 ( batch_count % 2  )
                     , a.res1_qty     
                     , a.res2_qty     
                     , a.tot_tat1     
                     , a.tot_tat2
                     , a.r
                     , a.tat_min 
                     , isnull(b.E1000_YIELD, 1) as E1000_YIELD
                     , @v_proc_name AS INSERT_ID
                     , GETDATE()    AS INSERT_TIME
              from   (    
                      -- Mixer line 및 수량 분배
                      select a.MASTER_ID, a.PLAN_ID
                             , a.E2000_WORK_ORDER_ID
                             --, a.work_order_id
                             , case when b.r = 1 then a.work_order_id
                                    else substring(a.work_order_id, 1, charindex(@v_mix_mid_char, a.work_order_id)+1)
                                         + 'Z' +
                                         substring(a.work_order_id, charindex(@v_mix_mid_char, a.work_order_id)+3,10)
                               end as work_order_id
                             , row_number() over( partition by a.master_id, a.plan_id, a.after_operation_id
                                                      order by a.after_plan_date, a.after_site_id, a.after_route_id, a.after_resource_id, a.item_id, a.work_order_id, b.r )
                               as SEQ                        
                             , a.after_site_id, a.after_operation_id, a.item_id
                             , a.plan_qty                                   -- 계획대상 수량
                             , a.batch_lot_size                             -- Batch lot size
                             --, a.batch_count1
                             , a.batch_count                                -- Batch 수
                             , a.min_batch_apply                            -- MinLot Qty
                             , a.tat                                        -- 1 Batch time
                             , a.resource_count                             -- Mixer 설비 대수
                             , a.divide_count                               -- 나머지를 뺀 몫 수
                             , a.add_count                                  -- 첫번째 설비에 할당 할 MinLot1
                             , a.res1_qty     
                             , a.res2_qty     
                             , a.tot_tat1     
                             , a.tot_tat2
                             , b.RESOURCE_ID, b.r
                             , case when b.r = 1 then a.res1_qty when b.r = 2 then a.res2_qty else 0 end final_after_in_qty 
                             , case when b.r = 1 then a.tot_tat1 when b.r = 2 then a.tot_tat2 else 0 end tat_min 
                             -----------------------------------------------------------------
                              , a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time, a.after_qty, a.after_in_qty
                              , a.fixed_yn, a.demand_id, a.demand_type, a.market, A.TOP_ITEM_ID
                              , a.e2000_start_time, a.e2000_end_time, a.e2000_plan_date, a.e2000_item_id, a.e2000_org_qty, a.org_qty
                             -----------------------------------------------------------------
                      from   (       
                              select a.MASTER_ID, a.PLAN_ID
                                     , a.E2000_WORK_ORDER_ID, a.work_order_id
                                     , a.after_site_id, a.after_operation_id, a.item_id
                                     , a.plan_qty                                   -- 계획대상 수량
                                     , a.batch_lot_size                             -- Batch lot size
                                     , a.batch_count1
                                     , a.batch_count                                -- Batch 수
                                     , a.min_batch_apply                            -- MinLot Qty
                                     , a.tat                                        -- 1 Batch time
                                     , a.resource_count                             -- Mixer 설비 대수
                                     , a.divide_count                               -- 나머지를 뺀 몫 수
                                     , a.add_count                                  -- 첫번째 설비에 할당 할 MinLot1
                                     , case when a.batch_count = 0 and a.resource_count = 1 and a.divide_count = 0                     then a.min_batch_apply
                                            when a.batch_count > 0 and a.resource_count = 2 and a.divide_count = 0 and a.add_count = 1 then a.batch_lot_size
                                            when a.batch_count > 0 and a.resource_count = 2 and a.divide_count > 0 and a.add_count = 0 then ( a.batch_lot_size * a.divide_count ) + a.min_batch_apply
                                            when a.batch_count > 0 and a.resource_count = 2 and a.divide_count > 0 and a.add_count = 1 then ( a.batch_lot_size * a.divide_count ) + a.batch_lot_size
                                            else 0
                                       end  as res1_qty     
                                     , case when a.batch_count = 0 and a.resource_count = 1 and a.divide_count = 0                     then 0
                                            when a.batch_count > 0 and a.resource_count = 2 and a.divide_count = 0 and a.add_count = 1 then a.min_batch_apply
                                            when a.batch_count > 0 and a.resource_count = 2 and a.divide_count > 0 and a.add_count = 0 then a.batch_lot_size * a.divide_count
                                            when a.batch_count > 0 and a.resource_count = 2 and a.divide_count > 0 and a.add_count = 1 then ( a.batch_lot_size * a.divide_count ) + a.min_batch_apply
                                            else 0
                                       end  as res2_qty     
                                     , case when a.batch_count = 0 and a.resource_count = 1 and a.divide_count = 0                     then ( a.tat * 1 )
                                            when a.batch_count > 0 and a.resource_count = 2 and a.divide_count = 0 and a.add_count = 1 then ( a.tat * 1 )
                                            when a.batch_count > 0 and a.resource_count = 2 and a.divide_count > 0 and a.add_count = 0 then ( a.tat * (a.divide_count + 1) )
                                            when a.batch_count > 0 and a.resource_count = 2 and a.divide_count > 0 and a.add_count = 1 then ( a.tat * (a.divide_count + 1) )
                                            else 0
                                       end  as tot_tat1     
                                     , case when a.batch_count = 0 and a.resource_count = 1 and a.divide_count = 0                     then 0
                                            when a.batch_count > 0 and a.resource_count = 2 and a.divide_count = 0 and a.add_count = 1 then ( a.tat * 1 )
                                            when a.batch_count > 0 and a.resource_count = 2 and a.divide_count > 0 and a.add_count = 0 then ( a.tat * a.divide_count )
                                            when a.batch_count > 0 and a.resource_count = 2 and a.divide_count > 0 and a.add_count = 1 then ( a.tat * (a.divide_count + 1) )
                                            else 0
                                       end  as tot_tat2     
                                     -----------------------------------------------------------------
                                      , a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time, a.after_qty, a.after_in_qty
                                      , a.fixed_yn, a.demand_id, a.demand_type, a.market, A.TOP_ITEM_ID
                                      , a.e2000_start_time, a.e2000_end_time, a.e2000_plan_date, a.e2000_item_id, a.e2000_org_qty, a.org_qty
                                     -----------------------------------------------------------------
                              from   (       
                                      select a.MASTER_ID, a.PLAN_ID
                                             , a.E2000_WORK_ORDER_ID, a.work_order_id
                                             , a.after_site_id, a.after_operation_id, a.item_id
                                             , a.plan_qty                                   -- 계획대상 수량
                                             , a.batch_lot_size                             -- Batch lot size
                                             , a.batch_count1
                                             , a.batch_count                                -- Batch 수
                                             , a.min_batch_apply                            -- MinLot Qty
                                             , a.tat                                        -- 1 Batch time
                                             , case when ( a.batch_count = 0 ) 
                                                    then 1 
                                                    else 2 
                                               end                        as resource_count -- Mixer 설비 대수
                                             , floor( a.batch_count / 2 ) as divide_count   -- 나머지를 뺀 몫 수
                                             , ( a.batch_count % 2  )     as add_count      -- 첫번째 설비에 할당 할 MinLot
                                             -----------------------------------------------------------------
                                              , a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time, a.after_qty, a.after_in_qty
                                              , a.fixed_yn, a.demand_id, a.demand_type, a.market, A.TOP_ITEM_ID
                                              , a.e2000_start_time, a.e2000_end_time, a.e2000_plan_date, a.e2000_item_id, a.e2000_org_qty, a.org_qty
                                             -----------------------------------------------------------------
                                      from   (
                                              select a.MASTER_ID, a.PLAN_ID
                                                     , a.E2000_WORK_ORDER_ID, a.work_order_id
                                                     , a.after_site_id, a.after_operation_id, a.item_id
                                                     , a.plan_qty
                                                     , a.batch_lot_size
                                                     , a.plan_qty / a.batch_lot_size as batch_count1
                                                     , floor(a.plan_qty / a.batch_lot_size)   as batch_count
                                                     , a.plan_qty % a.batch_lot_size          as MOD_qty
                                                     , ceiling(a.batch_lot_size * c.min_rate) as min_batch_size
                                                     , case when a.plan_qty % a.batch_lot_size >= ceiling(a.batch_lot_size * c.min_rate)
                                                            then a.plan_qty % a.batch_lot_size
                                                            else ceiling(a.batch_lot_size * c.min_rate)
                                                       end as min_batch_apply     
                                                     , a.tat
                                                     , c.min_rate
                                                     -----------------------------------------------------------------
                                                      , a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time, a.after_qty, a.after_in_qty
                                                      , a.fixed_yn, a.demand_id, a.demand_type, a.market, A.TOP_ITEM_ID
                                                      , a.e2000_start_time, a.e2000_end_time, a.e2000_plan_date, a.e2000_item_id, a.e2000_org_qty, a.org_qty
                                                     -----------------------------------------------------------------
                                              from   (
                                                      -- Mixer target 수량
                                                      select a.MASTER_ID, a.PLAN_ID
                                                             , a.E2000_WORK_ORDER_ID, a.work_order_id
                                                             , a.AFTER_SITE_ID
                                                             , a.after_operation_id, a.item_id, ceiling(a.after_in_qty) as plan_qty
                                                             -----------------------------------------------------------------
                                                              , a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time, a.after_qty, a.after_in_qty
                                                              , a.fixed_yn, a.demand_id, a.demand_type, a.market, A.TOP_ITEM_ID
                                                              , a.e2000_start_time, a.e2000_end_time, a.e2000_plan_date, a.e2000_item_id, a.e2000_org_qty, a.org_qty
                                                              --,a.r,a.acu_org_qty,a.stock_qty,a.remain_qty
                                                             -----------------------------------------------------------------
                                                             , isnull(b.batch_lot_size, 1)  as batch_lot_size
                                                             , isnull(b.tat, 1)             as tat
                                                      FROM    TH_BUF_E1000_PLAN_TARGET a
                                                              left outer join (
                                                                                -- Batch_lot_size, TAT
                                                                                select company_id, division_id, site_id, plant_id
                                                                                       , factory_id, operation_id, item_id
                                                                                       , ceiling(batch_lot_size) as batch_lot_size
                                                                                       , case when tat = 0 then 1 
                                                                                                           else tat 
                                                                                         end  as tat
                                                                                from  scm_item_equip_rate_batch_m
                                                                                where 1=1
                                                                                and   factory_id   = @v_factory_id
                                                                                and   operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                                                                and   active_flag  = 'Y'
                                                                                and   batch_lot_size > 0
                                                                               ) b
                                                                    on     a.after_site_id      = b.factory_id
                                                                    and    a.after_operation_id = b.operation_id
                                                                    and    a.item_id            = b.item_id
                                                      WHERE   a.MASTER_ID     = @v_master_id
                                                      AND     a.PLAN_ID       = @v_plan_id
                                                      and     a.AFTER_SITE_ID = @v_factory_id
                                                      --and e2000_work_order_id = 'WK18502CT#KE4#E4#02#0022'
                                                     ) a,
                                                     (
                                                      -- 최소 Batch size 정보
                                                      SELECT LOOKUP_TYPE_CODE, segment2 as factory_id, segment3 as operation_id, convert(numeric(20,10), attribute1) as min_rate 
                                                      FROM   SCM_SYS_LOOKUP_VALUE
                                                      WHERE  LOOKUP_TYPE_CODE LIKE 'MIN_BATCH_SIZE'
                                                     ) c
                                              where  a.after_site_id      = c.factory_id
                                              and    a.after_operation_id = c.operation_id
                                              /*
                                              select a.MASTER_ID, a.PLAN_ID
                                                     , a.E2000_WORK_ORDER_ID, a.work_order_id
                                                     , a.after_site_id, a.after_operation_id, a.item_id
                                                     , a.plan_qty
                                                     , b.batch_lot_size
                                                     , a.plan_qty / b.batch_lot_size as batch_count1
                                                     , floor(a.plan_qty / b.batch_lot_size)   as batch_count
                                                     , a.plan_qty % b.batch_lot_size          as MOD_qty
                                                     , ceiling(b.batch_lot_size * c.min_rate) as min_batch_size
                                                     , case when a.plan_qty % b.batch_lot_size >= ceiling(b.batch_lot_size * c.min_rate)
                                                            then a.plan_qty % b.batch_lot_size
                                                            else ceiling(b.batch_lot_size * c.min_rate)
                                                       end as min_batch_apply     
                                                     , b.lot_size_uom, b.tat, b.tat_uom, b.active_flag
                                                     , c.min_rate
                                                     -----------------------------------------------------------------
                                                      , a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time, a.after_qty, a.after_in_qty
                                                      , a.fixed_yn, a.demand_id, a.demand_type, a.market, A.TOP_ITEM_ID
                                                      , a.e2000_start_time, a.e2000_end_time, a.e2000_plan_date, a.e2000_item_id, a.e2000_org_qty, a.org_qty
                                                     -----------------------------------------------------------------
                                              from   (
                                                      -- Mixer target 수량
                                                      select a.MASTER_ID, a.PLAN_ID
                                                             , a.E2000_WORK_ORDER_ID, a.work_order_id
                                                             , a.AFTER_SITE_ID
                                                             , a.after_operation_id, a.item_id, ceiling(a.after_in_qty) as plan_qty
                                                             -----------------------------------------------------------------
                                                              , a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time, a.after_qty, a.after_in_qty
                                                              , a.fixed_yn, a.demand_id, a.demand_type, a.market, A.TOP_ITEM_ID
                                                              , a.e2000_start_time, a.e2000_end_time, a.e2000_plan_date, a.e2000_item_id, a.e2000_org_qty, a.org_qty
                                                              --,a.r,a.acu_org_qty,a.stock_qty,a.remain_qty
                                                             -----------------------------------------------------------------
                                                      FROM   TH_BUF_E1000_PLAN_TARGET a
                                                      WHERE   a.MASTER_ID     = @v_master_id
                                                      AND     a.PLAN_ID       = @v_plan_id
                                                      and     a.AFTER_SITE_ID = @v_factory_id
                                                      --and e2000_work_order_id = 'WK117604CT2BP'
                                                     ) a,
                                                     (
                                                      -- Batch_lot_size, TAT
                                                      select company_id, division_id, site_id, plant_id
                                                             , factory_id, operation_id, item_id
                                                             , ceiling(batch_lot_size) as batch_lot_size, lot_size_uom, tat, tat_uom, active_flag
                                                      from  scm_item_equip_rate_batch_m
                                                      where 1=1
                                                      and   factory_id   = @v_factory_id
                                                      and   operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                                      and   active_flag  = 'Y'
                                                     ) b,
                                                     (
                                                      -- 최소 Batch size 정보
                                                      SELECT LOOKUP_TYPE_CODE, segment2 as factory_id, segment3 as operation_id, convert(numeric(20,10), attribute1) as min_rate 
                                                      FROM   SCM_SYS_LOOKUP_VALUE
                                                      WHERE  LOOKUP_TYPE_CODE LIKE 'MIN_BATCH_SIZE'
                                                     ) c
                                              where  a.after_site_id      = b.factory_id
                                              and    a.after_operation_id = b.operation_id
                                              and    a.item_id            = b.item_id
                                              and    a.after_site_id      = c.factory_id
                                              and    a.after_operation_id = c.operation_id
                                              */
                                             ) a
                                      ) a               
                              ) a,
                              (
                               -- E4 -> Coater에 1에 대응하는 Mixer 설비 2대를 가져오는 쿼리 
                               ----------------------------------------------------------------
                                select a.item_id, a.route_id, a.resource_id, a.alt_priority, a.r
                                from   (
                                        select a.item_id, a.route_id, b.resource_id, a.alt_priority,
                                               row_number() over ( partition by a.item_id, a.route_id order by a.ALT_PRIORITY, b.RESOURCE_ID ) as r 
                                        from   (
                                                select factory_id, item_id, operation_id, line_id as route_id, month, priority as alt_priority, active_flag 
                                                from   SCM_ITEM_LINE_ASSIGN_M
                                                where  factory_id   = @v_factory_id
                                                and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                                and    month        = @v_plan_month --'201707'
                                                and    active_flag  = 'Y'
                                                --and item_id = 'ASLAN0823A'
                                                and    priority in ( 1, 2, 3, 4, 5, 6, 7, 8 ) -- 미사용 Flag인것은 할당 제외 (0, 9,null)
                                               ) a,
                                               (
                                                select factory_id, operation_id, equipment_id as resource_id, line_id as route_id, equipment_type, active_flag
                                                from   SCM_equipment_M
                                                where  equipment_type = 'M'
                                                and    factory_id     = @v_factory_id
                                                and    operation_id   in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                                and    active_flag    = 'Y'
                                               ) b
                                        where  a.factory_id   = b.factory_id
                                        and    a.operation_id = b.operation_id
                                        and    a.route_id     = b.route_id
                                       ) a
                                where  a.r < 3   
-----------------------------------
-- old
--                               select distinct a.ITEM_ID, a.route_id, a.RESOURCE_ID, a.ALT_PRIORITY, a.r
--                               from   (
--                                       select a.item_id, a.route_id, a.ALT_PRIORITY, a.RESOURCE_ID,
--                                              row_number() over ( partition by a.item_id, a.route_id order by a.ALT_PRIORITY, a.RESOURCE_ID ) as r 
--                                          -------------------------------------------------------
--                                          -------------------------------------------------------
----                                       from   lgce_fpdev.dbo.th_mst_op_resource a
--                                     from   (
--                                             select * from   kr_e_pre_a.dbo.th_mst_op_resource where master_id = @v_master_id union all
--                                             select * from   kr_e_pre_m.dbo.th_mst_op_resource where master_id = @v_master_id union all
--                                             select * from     us_e_pre.dbo.th_mst_op_resource where master_id = @v_master_id union all
--                                             select * from     cn_e_pre.dbo.th_mst_op_resource where master_id = @v_master_id union all
--                                             select * from       kr_srs.dbo.th_mst_op_resource where master_id = @v_master_id                                  
--                                            ) a
--                                          -------------------------------------------------------
--                                          -------------------------------------------------------
--                                       where  a.master_id = @v_master_id
--                                       and    a.plan_id   = @v_plan_id
--                                       and    a.site_id   = @v_factory_id
--                                       and    a.operation_id  in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
--                                       and    a.alt_priority in ( 1, 2, 3, 4, 5, 6, 7, 8 ) -- 미사용 Flag인것은 할당 제외 (0, 9,null)
--                                      ) a
--                               where a.r < 3       
                              ) b
                      where  a.item_id        = b.item_id
                      and    a.after_route_id = b.route_id
                      --and a.work_order_id in (  'WK117604MX0MJ',  'WK117604MXZMJ' )
                     ) a 
                     left outer join
                         (
                          -- * 수율 ( SCM_YIELD_M )
                          select factory_id, operation_id, line_id, item_id, month
                                 , case when yield = null then 1
                                        when yield = 0    then 1
                                        else yield
                                   end as E1000_YIELD 
                          from   SCM_YIELD_M
                          where  1=0                          -- 2018.03.28 : Mixer 계획에서는 Yield 를 반영하지 않는다.
                          and    factory_id   = @v_factory_id
                          and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                        ) b
                         on   a.after_operation_id = b.operation_id
                         and  a.after_site_id      = b.factory_id 
                         and  a.after_route_id     = b.line_id
                         and  a.item_id            = b.item_id
                         and  substring(a.E2000_PLAN_DATE, 1, 6) = b.month  
                     inner join
                         -- seq로 WO seq 를 찾는다 
                         ( select order_no, order_id from FP_ORDER_SEQ
                     ) c
                     on a.seq = c.order_no
                     


              SET @v_message = @@ROWCOUNT
              SET @v_table_name = 'TH_BUF_E1000_PLAN_TARGET_E4'
              SET @n_log_count = @n_log_count + 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
              
            END                    

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

        ---------------------------
        -- E_PRE E1000 계획 생성
        -- TH_BUF_E1000_PLAN_TARGET -> TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY 
        -- WO 생성
        ---------------------------
            BEGIN
            
              SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY'
              
              delete from TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
              where   master_id     = @v_master_id
              and     plan_id       = @v_plan_id
              and     after_site_id = @v_factory_id

              SET @v_message = @@ROWCOUNT
              SET @n_log_count += 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY', 'DELETE', @n_log_count, null, @v_message, null 
              
            

              insert into TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
              (
                      master_id,plan_id,work_order_id,before_site_id,after_site_id,before_route_id,after_route_id,before_operation_id
                      ,after_operation_id,before_resource_id,after_resource_id,before_plan_date,after_plan_date,before_start_time
                      ,after_start_time,before_end_time,after_end_time,working_time,before_seq,after_seq,before_qty,after_qty,before_in_qty
                      ,after_in_qty,item_id,fixed_yn,split_yn,demand_id,demand_type,market,TOP_ITEM_ID, order_id,order_type,po_id,mfg_week,sop_week,org_work_order_id
                      ,demand_due_date,batch_order_id,date_fix_flag,date_fix_date,operation_epst,operation_lpst,lane_qty,lane_tact_qty,item_uom
                      ,wo_day_split_yn,setup_time,setup_time_uom,batch_qty,ui_edit_yn,description,insert_id,insert_time,update_id,update_time
                      , delete_yn
                     ) 

              select     
                      a.master_id, a.plan_id 
                      ----------------------------------------------------------------------------------------------------------------
              --        , a.wo_header
              --        , a.nation_cd
              --        , a.mass_sample
              --        , a.yymmdd_code
              --        , a.erp_operation_id  
              --        , a.after_site_id  ( Work order 번호가 factory 별로 돌릴때 중복될수 있어 보정코드로 넣음 ) 
              --        , b.order_id as SEQ                        
                      --, a.wo_header + a.nation_cd + a.mass_sample + a.yymmdd_code + a.erp_operation_id + a.after_site_id + b.order_id as work_order_id
                      , a.work_order_id
                      ----------------------------------------------------------------------------------------------------------------
                      , a.before_site_id,      a.after_site_id
                      , a.before_route_id,     a.after_route_id
                      , a.before_operation_id, a.after_operation_id
                      , a.before_resource_id,  a.after_resource_id
                      , a.before_plan_date,    a.after_plan_date
                      , a.before_start_time,   a.after_start_time
                      , a.before_end_time,     a.after_end_time
                      , a.working_time
                      , a.before_seq,          a.after_seq
                      , ceiling(a.before_qty)    as before_qty,          ceiling(a.after_qty)    as after_qty
                      , ceiling(a.before_in_qty) as before_in_qty,       ceiling(a.after_in_qty) as after_in_qty
                      , a.item_id
                      , a.fixed_yn, a.split_yn, a.demand_id
                      , a.demand_type
                      , a.market
                      , A.TOP_ITEM_ID
                      , a.order_id, a.order_type, a.po_id, a.mfg_week, a.sop_week
                      , a.org_work_order_id
                      , a.demand_due_date
                      , a.batch_order_id
                      , a.date_fix_flag, a.date_fix_date, a.operation_epst,  a.operation_lpst, a.lane_qty
                      , a.lane_tact_qty, a.item_uom,      a.wo_day_split_yn, a.setup_time,     a.setup_time_uom
                      , a.batch_qty,     a.ui_edit_yn,    a.description
                      , @v_proc_name as insert_id, getdate() as insert_time
                      , @v_proc_name as update_id, getdate() as update_time
                      , a.E2000_work_order_id
              from    (        
                      select 
                              a.master_id, a.plan_id 
                              ----------------------------------------------------------------------------------------------------------------
                              , isnull(b.wo_header, 'M') as wo_header
                              , isnull(c.key_value, 'K') as nation_cd
                              , isnull(d.key_value, '1') as mass_sample
                              , SUBSTRING(a.fp_plan_date, 3, 2)
                                + CASE SUBSTRING(a.fp_plan_date, 5, 2)
                                       WHEN '10' THEN 'A'
                                       WHEN '11' THEN 'B'
                                       WHEN '12' THEN 'C'
                                       ELSE SUBSTRING(a.fp_plan_date, 6, 1)
                                  END
                                + SUBSTRING(a.fp_plan_date, 7, 2)
                                as yymmdd_code
                              , isnull(erp_operation_id, 'MX') as erp_operation_id  
                              , row_number() over( partition by a.master_id, a.plan_id, a.after_operation_id
                                                       order by a.after_plan_date, a.after_site_id, a.after_route_id, a.after_resource_id, a.item_id, a.after_seq )
                               as SEQ                        
                              , a.work_order_id
                              , a.E2000_work_order_id
                              ----------------------------------------------------------------------------------------------------------------
                              , a.before_site_id,      a.after_site_id
                              , a.before_route_id,     a.after_route_id
                              , a.before_operation_id, a.after_operation_id
                              , a.before_resource_id,  a.after_resource_id
                              , a.before_plan_date,    a.after_plan_date
                              , a.after_start_time  as before_start_time
                              , a.after_start_time
                              , a.after_end_time    as before_end_time
                              , a.after_end_time
                              , a.working_time
                              , a.before_seq,          a.after_seq
                              , a.before_qty,          a.after_qty
                              , a.before_in_qty,       a.after_in_qty
                              , a.item_id
                              , a.fixed_yn, a.split_yn, a.demand_id
                              , a.demand_type
                              , a.market
                              , A.TOP_ITEM_ID
                              , a.order_id
                              , isnull(b.wo_header, 'M') as order_type
                              , a.po_id, a.mfg_week, a.sop_week
                              , a.org_work_order_id
                              , a.demand_due_date
                              , a.batch_order_id
                              , a.date_fix_flag, a.date_fix_date, a.operation_epst,  a.operation_lpst, a.lane_qty
                              , a.lane_tact_qty, a.item_uom,      a.wo_day_split_yn, a.setup_time,     a.setup_time_uom
                              , a.batch_qty,     a.ui_edit_yn,    a.description
                      from    (
                              select  --a.TAT_MIN,a.E2000_START_TIME, c.PRECEDE_PRODUCING_TERM,
                                      a.master_id, a.plan_id, substring ( a.plan_id, charindex( '-', a.plan_id )+1, 8 ) as fp_plan_date
                                      , a.work_order_id
                                      , a.E2000_work_order_id
                                      , a.after_site_id      as before_site_id,      a.after_site_id
                                      , a.after_route_id     as before_route_id,     a.after_route_id
                                      , a.after_operation_id as before_operation_id, a.after_operation_id
                                      , a.after_resource_id  as before_resource_id,  a.after_resource_id
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-- 현상무님 지시사항 ( Coater와 Mixer의 시간을 같게하라 )
--                                      , convert( varchar, 
--                                        DATEADD( MINUTE, a.TAT_MIN*(-1), CONVERT(DATETIME,      SUBSTRING(a.E2000_START_TIME,  1, 4) 
--                                                                                        + '-' + SUBSTRING(a.E2000_START_TIME,  5, 2)
--                                                                                        + '-' + SUBSTRING(a.E2000_START_TIME,  7, 2)
--                                                                                        + ' ' + SUBSTRING(a.E2000_START_TIME,  9, 2)
--                                                                                        + ':' + SUBSTRING(a.E2000_START_TIME, 11, 2)
--                                                                                        + ':' + SUBSTRING(a.E2000_START_TIME, 13, 2))
--                                                                      - c.PRECEDE_PRODUCING_TERM  ) , 112)
--                                                 AS before_plan_date                              
                                      , a.E2000_PLAN_DATE as before_plan_date           
--                                      , convert( varchar, 
--                                        DATEADD( MINUTE, a.TAT_MIN*(-1), CONVERT(DATETIME,      SUBSTRING(a.E2000_START_TIME,  1, 4) 
--                                                                                        + '-' + SUBSTRING(a.E2000_START_TIME,  5, 2)
--                                                                                        + '-' + SUBSTRING(a.E2000_START_TIME,  7, 2)
--                                                                                        + ' ' + SUBSTRING(a.E2000_START_TIME,  9, 2)
--                                                                                        + ':' + SUBSTRING(a.E2000_START_TIME, 11, 2)
--                                                                                        + ':' + SUBSTRING(a.E2000_START_TIME, 13, 2))
--                                                                      - c.PRECEDE_PRODUCING_TERM  ) , 112)
--                                                 AS after_plan_date                              
                                      , a.E2000_PLAN_DATE as after_plan_date            
--                                      , CONVERT(varchar,
--                                                         DATEADD( MINUTE, a.TAT_MIN*(-1), CONVERT(DATETIME,     SUBSTRING(a.E2000_START_TIME,  1, 4) 
--                                                                                                        + '-' + SUBSTRING(a.E2000_START_TIME,  5, 2)
--                                                                                                        + '-' + SUBSTRING(a.E2000_START_TIME,  7, 2)
--                                                                                                        + ' ' + SUBSTRING(a.E2000_START_TIME,  9, 2)
--                                                                                                        + ':' + SUBSTRING(a.E2000_START_TIME, 11, 2)
--                                                                                                        + ':' + SUBSTRING(a.E2000_START_TIME, 13, 2))
--                                                                                      - c.PRECEDE_PRODUCING_TERM  )                                                   
--                                                  , 112) 
--                                         + 
--                                         replace(CONVERT(varchar,
--                                                             DATEADD( MINUTE, a.TAT_MIN*(-1), CONVERT(DATETIME,     SUBSTRING(a.E2000_START_TIME,  1, 4) 
--                                                                                                            + '-' + SUBSTRING(a.E2000_START_TIME,  5, 2)
--                                                                                                            + '-' + SUBSTRING(a.E2000_START_TIME,  7, 2)
--                                                                                                            + ' ' + SUBSTRING(a.E2000_START_TIME,  9, 2)
--                                                                                                            + ':' + SUBSTRING(a.E2000_START_TIME, 11, 2)
--                                                                                                            + ':' + SUBSTRING(a.E2000_START_TIME, 13, 2))
--                                                                                          - c.PRECEDE_PRODUCING_TERM  )                                                   
--                                                                 
--                                                                 , 108), ':', '') 
--                                          AS after_start_time                              
                                        , a.E2000_START_TIME as after_start_time
--                                      , CONVERT(varchar,
--                                                        DATEADD( MINUTE, a.TAT_MIN*(-1), CONVERT(DATETIME,      SUBSTRING(a.E2000_END_TIME,  1, 4) 
--                                                                                                        + '-' + SUBSTRING(a.E2000_END_TIME,  5, 2)
--                                                                                                        + '-' + SUBSTRING(a.E2000_END_TIME,  7, 2)
--                                                                                                        + ' ' + SUBSTRING(a.E2000_END_TIME,  9, 2)
--                                                                                                        + ':' + SUBSTRING(a.E2000_END_TIME, 11, 2)
--                                                                                                        + ':' + SUBSTRING(a.E2000_END_TIME, 13, 2))
--                                                                )                                        
--                                                  , 112) 
--                                         + 
--                                         replace(CONVERT(varchar,
--                                                            DATEADD( MINUTE, a.TAT_MIN*(-1), CONVERT(DATETIME,      SUBSTRING(a.E2000_END_TIME,  1, 4) 
--                                                                                                            + '-' + SUBSTRING(a.E2000_END_TIME,  5, 2)
--                                                                                                            + '-' + SUBSTRING(a.E2000_END_TIME,  7, 2)
--                                                                                                            + ' ' + SUBSTRING(a.E2000_END_TIME,  9, 2)
--                                                                                                            + ':' + SUBSTRING(a.E2000_END_TIME, 11, 2)
--                                                                                                            + ':' + SUBSTRING(a.E2000_END_TIME, 13, 2))
--                                                                    )                                        
--                                                                 , 108), ':', '') 
--                                          AS after_end_time                              
                                      , a.E2000_END_TIME as after_end_time
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
                                      , 0 as working_time
                                      , dense_rank() over( partition by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type, a.market
                                                               order by a.E2000_item_id, a.E2000_PLAN_DATE ) 
                                        as before_seq
                                      , dense_rank() over( partition by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type, a.market
                                                               order by a.E2000_item_id, a.E2000_PLAN_DATE ) 
                                        as after_seq
                                      , a.after_qty as before_qty, a.after_qty as after_qty, a.after_in_qty as before_in_qty, a.after_in_qty as after_in_qty
                                      , a.item_id
                                      , a.fixed_yn, null as split_yn
                                      , a.demand_id
                                      , a.demand_type
                                      , a.market
                                      , A.TOP_ITEM_ID
                                      , null as order_id, null as order_type, null as po_id, null as mfg_week, null as sop_week
                                      , null as org_work_order_id
                                      , null as demand_due_date, '-' as batch_order_id, null as date_fix_flag, null as date_fix_date, null as operation_epst, null as operation_lpst, null as lane_qty, null as lane_tact_qty, 'EA' as item_uom
                                      , null as wo_day_split_yn, 0 as setup_time, 'SECOND' as setup_time_uom, null as batch_qty, null as ui_edit_yn, null as description
                              ------------------------------------------------------------------        
                              ------------------------------------------------------------------        
                              from   TH_BUF_E1000_PLAN_TARGET_E4 a
                              ------------------------------------------------------------------        
                              ------------------------------------------------------------------        
                                     inner join SCM_OPERATION_MOVE_M c -- PRECEDE_PRODUCING_TERM
                                             on   a.after_operation_id = c.operation_id
                                             and  a.after_site_id      = c.factory_id
                              where  a.master_id     = @v_master_id
                              and    a.plan_id       = @v_plan_id
                              and    a.after_site_id = @v_factory_id
                              and    a.after_qty      > 0 
                              ) a 
                             left outer join
                                 (
                                  -- M ( 기확정은 사용안함 )WO_Header
                                  select distinct operation_id,
                                         --company_id, division_id, site_id, operation_id, operation_name, erp_operation_id, capa_type,
                                         case when wo_flag = 'Y' 
                                              then 'W' 
                                              else 'M' 
                                         end  as WO_header 
                                  from   SCM_OPERATION_M
                                  where  operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                             ) b
                                 on   a.after_operation_id = b.operation_id
                             left outer join
                                 (
                                  -- 국가코드
                                  select instance_id, key_value  
                                  from   fp_instance_config_m
                                  where  1=1
                                  and    INSTANCE_ID = @v_master_id
                                  AND    CATEGORY_ID = 'EXPORT'
                                  AND    KEY_ID      = 'INSTANCE_CODE'
                             ) c
                                 on   a.master_id = c.instance_id
                             left outer join
                                 (
                                  -- 샘플양산 구분
                                  select KEY_ID, key_value 
                                  from   FP_INSTANCE_CONFIG_M
                                  where  1=1
                                  and    INSTANCE_ID = 'COMMON'
                                  AND    KEY_ID      = 'MASS'
                             ) d
                                 on   a.demand_type = d.KEY_ID
                             left outer join
                                 (
                                  -- erp_operation_id
                                  select distinct operation_id,
                                         --company_id, division_id, site_id, operation_id, operation_name, erp_operation_id, capa_type,
                                         erp_operation_id
                                  from   SCM_OPERATION_M
                                  where  operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                             ) e
                                 on   a.after_operation_id = b.operation_id
                     ) a
                     inner join
                         -- seq로 WO seq 를 찾는다 
                         ( select order_no, order_id from FP_ORDER_SEQ
                     ) b
                     on a.seq = b.order_no
              order by a.wo_header, a.nation_cd, a.mass_sample, a.yymmdd_code, a.erp_operation_id, b.order_id


              SET @v_message = @@ROWCOUNT
              SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY'
              SET @n_log_count = @n_log_count + 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
              
            END           

-- L 1425 조건
           end  
--------------------------------------------------------
--------------------------------------------------------



----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- MIXer
        /*** TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY UPDATE ***/
        -- 전일 Fix  work order 로 Update

        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY'
          
          
          update  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
          set     TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.fix_work_order_id  = b.fix_work_order_id,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.attb_1  = 'FIX_WO_UPDATE', 
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.change_id          = @v_proc_name
          from    TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY a,
                  (
                    select a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.E2000_work_order_id, a.work_order_id
                         , b.from_work_order_id as fix_work_order_id
                         -- 20180115 ksjeon add
                         , row_number() over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, b.from_work_order_id 
                                                   order by a.E2000_work_order_id, a.work_order_id ) fix_seq
                    from   (     
                            select a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.E2000_work_order_id, a.work_order_id
                                   , a.after_route_id, a.seq
                            from   (       
                                    select master_id, plan_id, after_site_id, after_operation_id, E2000_work_order_id, work_order_id
                                           , after_route_id
                                           , row_number() over ( partition by master_id, plan_id, after_site_id, after_operation_id, E2000_work_order_id
                                                                 order by work_order_id ) seq
                                    from TH_BUF_E1000_PLAN_TARGET_E4
                                    where master_id        = @v_master_id
                                    and plan_id            = @v_plan_id
                                    and after_site_id      = @v_factory_id
                                    and after_operation_id  in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                    --and E2000_work_order_id in ( 'K117630CT0A9' )
                                   ) a 
                            ) a,
                            (
                            select a.instance_id , a.fp_plan_id, a.to_factory_id, a.to_operation_id, a.to_work_order_id, a.from_work_order_id
                                   , a.from_line_id, a.seq
                            from   (       
                                    select instance_id , fp_plan_id, to_factory_id, to_operation_id, to_work_order_id, from_work_order_id
                                           , from_line_id
                                           , row_number() over ( partition by instance_id , fp_plan_id, to_factory_id, to_operation_id, to_work_order_id
                                                                 order by from_work_order_id ) seq
                                    from FP_ORDER_PEGGING_R
                                    where instance_id   = @v_master_id
                                    and fp_plan_id      = @release_plan_id
                                    and to_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater  공정..!!
                                    and to_factory_id   = @v_factory_id
                                    --and to_work_order_id in ( 'K117630CT0A9' )
                                   ) a 
                           ) b
                    where  a.master_id = b.instance_id 
                    and    a.after_site_id       = b.to_factory_id
                    and    a.seq                 = b.seq
                    --and    a.after_route_id      = b.from_line_id
                    and    a.E2000_work_order_id = b.to_work_order_id
                 ) b
          where  a.master_id           = b.master_id
          and    a.plan_id             = b.plan_id
          and    a.work_order_id       = b.work_order_id
          and  a.master_id             = @v_master_id
          and    a.plan_id             = @v_plan_id
          and    a.after_site_id       = @v_factory_id            
          and    a.after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
          and    a.after_qty > 0
          and    a.fixed_yn = 'Y'
          and    b.fix_seq  = 1 -- 20180115 ksjeon add release pegging  에서 가져온 Mix의 Fix order가 두개의 COATER 와 맵핑되는 경우가 있어 방지함
          


--
--          update  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
--          set     TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.fix_work_order_id  = b.fix_work_order_id,
--                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.fix_batch_order_id = b.fix_batch_order_id,
--                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.change_id          = @v_proc_name
--          from    TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY a,
--                  (
--                  select a.master_id, a.plan_id, a.work_order_id, b.work_order_id as fix_work_order_id,
--                         a.after_site_id, a.after_operation_id, a.after_resource_id, a.item_id, a.after_end_time, a.seq, 
--                         b.batch_order_id as fix_batch_order_id
--                  from   (
--                          select master_id, plan_id, work_order_id, after_site_id, after_operation_id, after_resource_id, item_id, after_end_time, fixed_yn, DEMAND_TYPE, MARKET,
--                                 dense_rank()  over ( partition by after_site_id, after_operation_id, after_resource_id, item_id , DEMAND_TYPE, MARKET
--                                                      order by after_plan_date, after_seq, after_end_time, work_order_id ) as seq
--                          from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
--                          where  master_id              = @v_master_id
--                          and    plan_id                = @v_plan_id
--                          and    after_site_id          = @v_factory_id            
--                          and    after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
--                          and    after_qty > 0
--                          and    fixed_yn = 'Y'
--                         ) a
--                         inner JOIN
--                         (
--                          select 
--                                 a.fp_plan_id, a.factory_id, a.operation_id, a.equipment_id, a.item_id, a.work_order_id, a.plan_start_time, a.batch_order_id,a.PRODUCTION_TYPE, a.MARKET,
--                                 dense_rank()  over ( partition by a.factory_id, a.operation_id, a.equipment_id, a.item_id ,a.PRODUCTION_TYPE, a.MARKET
--                                                      order by a.plan_start_time, a.work_order_id ) as seq
--                          from   fp_daily_instance_order_status a
--                          where  a.instance_id  = @v_master_id
--                          and    a.fp_plan_id   = @v_plan_id
--                          and    a.factory_id   = @v_factory_id
--                          and    a.operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
--                          and    a.plan_start_time >= case when @v_is_co_merge = 'Y' then @plan_start_time else (@plan_start_time-365) end  -- ## 확정 W/O 옵션..!!
--                          and    a.org_qty > 0
--                          and    a.WO_STATUS in ( 'OPEN', 'RUN' )
--                          and    EXISTS ( 
--                                              select 1
--                                              from   (
--                                                      select distinct --instance_id, 
--                                                                      instance_date, release_plan_id, amend_plan_id, division_id, factory_id, work_order_id
--                                                                    , batch_order_id, operation_id, equipment_id, fix_type, item_id, actual_flag, close_flag
--                                                      FROM FP_RELEASE_FIX_PLAN_H b
--                                                      --where  b.instance_id      = @v_master_id
--                                                      where  b.instance_id      in (  @v_master_id, @v_master_id + '_A', @v_master_id + '_M' )
--                                                      and    b.release_plan_id  = @release_plan_id
--                                                      ----------------------------
--                                                      ----------------------------
--                                                      except
--                                                      ----------------------------
--                                                      ----------------------------
--                                                      select distinct --a.instance_id, 
--                                                                      a.instance_date, a.release_plan_id, a.amend_plan_id, a.division_id, a.factory_id, a.work_order_id
--                                                                    , a.batch_order_id, a.operation_id, a.equipment_id, a.fix_type, a.item_id, a.actual_flag, a.close_flag
--                                                      from   (              
--                                                              -- 계획월과 R plan의 계획월이 같은 경우 close_flag = 'Y' 분 제외
--                                                              select distinct --instance_id, 
--                                                                              instance_date, release_plan_id, amend_plan_id, division_id, factory_id, work_order_id
--                                                                            , batch_order_id, operation_id, equipment_id, fix_type, item_id, actual_flag, close_flag
--                                                              FROM FP_RELEASE_FIX_PLAN_H b
--                                                              --where  b.instance_id      = @v_master_id
--                                                              where  b.instance_id      in (  @v_master_id, @v_master_id + '_A', @v_master_id + '_M' )
--                                                              and    b.release_plan_id  = @release_plan_id
--                                                              and    ( substring(b.instance_date, 1, 6) = @v_plan_month and -- 계획월과 R plan의 계획월이 같고
--                                                                       isnull(b.close_flag, 'N') = 'Y'                      -- close_flag  = Y 제외
--                                                                     )
--                                                              ----------------------------
--                                                              union all
--                                                              ----------------------------
--                                                              select distinct --instance_id, 
--                                                                              instance_date, release_plan_id, amend_plan_id, division_id, factory_id, work_order_id
--                                                                            , batch_order_id, operation_id, equipment_id, fix_type, item_id, actual_flag, close_flag
--                                                              FROM FP_RELEASE_FIX_PLAN_H b
--                                                              --where  b.instance_id      = @v_master_id
--                                                              where  b.instance_id      in (  @v_master_id, @v_master_id + '_A', @v_master_id + '_M' )
--                                                              and    b.release_plan_id  = @release_plan_id
--                                                              and    ( substring(b.instance_date, 1, 6) <  @v_plan_month                    and  -- 계획월과 R plan의 계획월이 다르고
--                                                                       substring(CONVERT(varchar, b.plan_date , 112), 1, 6) < @v_plan_month      -- WO의 Plan date가 pst기준 이전월인 경우 제외
--                                                                     )  
--                                                              ----------------------------
--                                                              union all
--                                                              ----------------------------
--                                                              select distinct --instance_id, 
--                                                                              instance_date, release_plan_id, amend_plan_id, division_id, factory_id, work_order_id
--                                                                            , batch_order_id, operation_id, equipment_id, fix_type, item_id, actual_flag, close_flag
--                                                              FROM FP_RELEASE_FIX_PLAN_H b
--                                                              --where  b.instance_id      = @v_master_id
--                                                              where  b.instance_id      in (  @v_master_id, @v_master_id + '_A', @v_master_id + '_M' )
--                                                              and    b.release_plan_id  = @release_plan_id
--                                                              and    ( substring(b.instance_date, 1, 6) <  @v_plan_month                    and  -- 계획월과 R plan의 계획월이 다르고
--                                                                       @v_plan_dd                       = '01'                              and  -- PST가 일이 1 일이고
--                                                                       substring(CONVERT(varchar, b.plan_date , 112), 1, 6) = @v_plan_month and  -- WO의 Plan date가 pst기준과 같은월이고
--                                                                       ( isnull(b.actual_flag, 'N') = 'Y' or isnull(b.close_flag, 'N')  = 'Y')   -- actual_flag = Y 이거나 close_flag  = Y 이면 제외
--                                                                     )  
--                                                              ----------------------------
--                                                              union all
--                                                              ----------------------------
--                                                              select distinct --instance_id, 
--                                                                              instance_date, release_plan_id, amend_plan_id, division_id, factory_id, work_order_id
--                                                                            , batch_order_id, operation_id, equipment_id, fix_type, item_id, actual_flag, close_flag
--                                                              FROM FP_RELEASE_FIX_PLAN_H b
--                                                              --where  b.instance_id      = @v_master_id
--                                                              where  b.instance_id      in (  @v_master_id, @v_master_id + '_A', @v_master_id + '_M' )
--                                                              and    b.release_plan_id  = @release_plan_id
--                                                              and    ( substring(b.instance_date, 1, 6) <  @v_plan_month                    and  -- 계획월과 R plan의 계획월이 다르고
--                                                                       substring(b.instance_date, 7, 2) != '01'                             and  -- R plan의 계획일이 1 일이 아니고
--                                                                       substring(CONVERT(varchar, b.plan_date , 112), 1, 6) = @v_plan_month and  -- WO의 Plan date가 pst기준월과 같은월 이고
--                                                                       isnull(b.close_flag, 'N')  = 'Y'                                          -- close_flag  = Y 이면 제외
--                                                                     ) 
--                                                              ----------------------------
--                                                              union all
--                                                              ----------------------------
--                                                              select distinct --instance_id, 
--                                                                              instance_date, release_plan_id, amend_plan_id, division_id, factory_id, work_order_id
--                                                                            , batch_order_id, operation_id, equipment_id, fix_type, item_id, actual_flag, close_flag
--                                                              FROM FP_RELEASE_FIX_PLAN_H b
--                                                              --where  b.instance_id      = @v_master_id
--                                                              where  b.instance_id      in (  @v_master_id, @v_master_id + '_A', @v_master_id + '_M' )
--                                                              and    b.release_plan_id  = @release_plan_id
--                                                              and    substring(CONVERT(varchar, b.MIN_ACTUAL_DATE , 112), 1, 6) < @v_plan_month  -- WO의 최초 실적일이 Plan month 이전 월이면 제외
--                                                              and    b.MIN_ACTUAL_DATE is not null
--                                                           
--                                                            ) a   
--                                                  ) b
--                                                  where b.work_order_id = a.work_order_id  
--                                          )  
--                         
--                         ) b
--                         on      a.after_site_id      = b.factory_id
--                         and     a.after_operation_id = b.operation_id
--                         and     a.after_resource_id  = b.equipment_id
--                         and     a.item_id            = b.item_id
--                         and     a.demand_type        = b.PRODUCTION_TYPE -- add
--                         and     a.MARKET             = b.MARKET          -- add
--                         and     a.seq                = b.seq
--                  where  a.master_id              = @v_master_id
--                  and    a.plan_id                = @v_plan_id
--                  and    a.after_site_id          = @v_factory_id   
--                 ) b
--          where  a.master_id           = b.master_id
--          and    a.plan_id             = b.plan_id
--          and    a.work_order_id       = b.work_order_id
--          --and    isnull(a.merge_work_order_id, a.work_order_id) = isnull(b.merge_work_order_id, b.work_order_id)


          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

--------------------------------------------------------
--------------------------------------------------------



----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- MIXer
        /*** TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY UPDATE ***/
        -- fix_work_order_id 를 WO로 반영

        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY'

          update  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
          set     TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.final_work_order_id  = b.new_work_order_id,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.change_id            = @v_proc_name
          from    TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY a,
                  (
                    select a.master_id, a.plan_id
                           , a.mx_wo
                           , a.ct_wo
                           , a.new_work_order_id
                    from   (         
                            select master_id,plan_id
                                   , work_order_id as mx_wo
                                   , delete_yn as ct_wo
                                   , case when -- fixed_yn = 'Y'  and 
                                               fix_work_order_id is not null
                                     then substring(isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) ), 1, 12 )
                                     else isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) )
                                     end  as new_work_order_id
                            from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
                            where master_id      = @v_master_id
                            and   plan_id        = @v_plan_id
                            and   AFTER_SITE_ID  = @v_factory_id
                            and    AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                            and    after_qty > 0
                           ) a 
                 ) b
          where  a.master_id           = b.master_id
          and    a.plan_id             = b.plan_id
          and    a.work_order_id       = b.mx_wo
          and    a.delete_yn           = b.ct_wo

          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END



-- MIXer
        /*** TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY UPDATE ***/
        -- fix_work_order_id 를 WO로 반영

        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY'

          update  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
          set     final_work_order_id  = case when substring(final_work_order_id, 1, 1) in ( 'W', 'M' ) then ''
                                              else 'X' 
                                         end + final_work_order_id,
                  fixed_yn             = 'N',
                  attb_2               = 'NOT_FIX'
          where master_id      = @v_master_id
          and   plan_id        = @v_plan_id
          and   AFTER_SITE_ID  = @v_factory_id
          and   AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
          and   attb_1 is null

          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'not fix UPDATE', @n_log_count, null, @v_message, null

        END


--------------------------------------------------------
--------------------------------------------------------

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- MIXer
        /*** TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY UPDATE ***/
        -- 다른 Factory에 동일한 Mixer WO 가 있을수 있어 확인 후 같은것이 있으면 WO를 변경 함
        
        
        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY'

          update  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
          set     TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.final_work_order_id  = b.z_work_order_id ,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.change_id            = 'z_work_order_id'
          from    TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY a,
                  (
                    select 
                            a.master_id, a.plan_id, a.final_work_order_id, a.z_work_order_id
                    from   (            
                            select 
                                  master_id,plan_id, final_work_order_id, final_work_order_id + @v_factory_id as z_work_order_id
                            from TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
                            where master_id      = @v_master_id
                            and   plan_id        = @v_plan_id
                            and   AFTER_SITE_ID  = @v_factory_id
                            and   AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                            and   after_qty > 0
                           ) a
                           inner JOIN
                             fp_amend_production_plan_r b
                           on     a.master_id           = b.master_id
                           and    a.plan_id             = b.plan_id
                           and    a.final_work_order_id = b.work_order_id
                           and    b.after_site_id      != @v_factory_id
                    where  b.work_order_id is not null       
                 ) b
          where  a.master_id           = b.master_id
          and    a.plan_id             = b.plan_id
          and    a.final_work_order_id = b.final_work_order_id
                

          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

--------------------------------------------------------
--------------------------------------------------------



----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- MIXer
        /*** TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY UPDATE ***/
        -- 최종 WO 로 Update

        
        BEGIN
         
          SET @v_table_name = 'TH_BUF_E1000_PLAN_TARGET_E4'

          update  TH_BUF_E1000_PLAN_TARGET_E4
          set     TH_BUF_E1000_PLAN_TARGET_E4.work_order_id  = b.final_work_order_id,
                  TH_BUF_E1000_PLAN_TARGET_E4.insert_id      = 'CHANGE_WORK_ORDER'
          from    TH_BUF_E1000_PLAN_TARGET_E4 a,
                  (
                    select 
                           master_id,plan_id, work_order_id, delete_yn as e2000_work_order_id, final_work_order_id
                    from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
                    where  master_id      = @v_master_id
                    and    plan_id        = @v_plan_id
                    and    AFTER_SITE_ID  = @v_factory_id
                    and    AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                    and    after_qty > 0
                    and    final_work_order_id is not null
                 ) b
          where  a.master_id           = b.master_id
          and    a.plan_id             = b.plan_id
          and    a.work_order_id       = b.work_order_id
          and    a.e2000_work_order_id = b.e2000_work_order_id
                

          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

--------------------------------------------------------
--------------------------------------------------------




        
    ---------------------------
    -- sy_fp_amend_production_plan_r 테이블 Merge work order 반영
    ---------------------------
        BEGIN
        
          SET @v_table_name = 'fp_amend_production_plan_r'

          DELETE FROM fp_amend_production_plan_r
          WHERE   MASTER_ID     = @v_master_id
          AND     PLAN_ID       = @v_plan_id
          and     AFTER_SITE_ID = @v_factory_id
          and     AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'fp_amend_production_plan_r', 'DELETE', @n_log_count, null, @v_message, null 


          insert into fp_amend_production_plan_r
                       ( 
                        MASTER_ID,PLAN_ID,WORK_ORDER_ID,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
                        ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE,BEFORE_START_TIME
                        ,AFTER_START_TIME,BEFORE_END_TIME,AFTER_END_TIME,WORKING_TIME,BEFORE_SEQ,AFTER_SEQ,BEFORE_QTY,AFTER_QTY,BEFORE_IN_QTY
                        ,AFTER_IN_QTY,ITEM_ID,FIXED_YN,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK,ORG_WORK_ORDER_ID
                        ,DEMAND_DUE_DATE,BATCH_ORDER_ID,DATE_FIX_FLAG,DATE_FIX_DATE,OPERATION_EPST,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                        ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_QTY,UI_EDIT_YN
                        ,MARKET,TOP_ITEM_ID
                        ,DESCRIPTION,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
                       )
            select      a.master_id,a.plan_id 
                        ,a.work_order_id
                        --,a.before_site_id
                        ,min(a.before_site_id) as before_site_id
                        ,a.after_site_id
                        --,a.before_route_id
                        ,min(a.before_route_id) as before_route_id
                        ,a.after_route_id
                        --,a.before_operation_id
                        ,min(a.before_operation_id) as before_operation_id
                        ,a.after_operation_id
                        ,min(a.before_resource_id) as before_resource_id
                        ,a.after_resource_id
                        ,min(a.before_plan_date) as before_plan_date
                        -- 20170620 ksjeon ,max(a.after_plan_date)  as after_plan_date
                        ,min(a.after_plan_date)  as after_plan_date
                        -----------------------
                        ,min(a.before_start_time) as before_start_time
                        ,min(a.after_start_time) as after_start_time
                        ,max(a.before_end_time) as before_end_time
                        ,max(a.after_end_time) as after_end_time
                        ,sum(a.working_time) as working_time
--                        ,a.before_start_time
--                        ,a.after_start_time
--                        ,a.before_end_time
--                        ,a.after_end_time
--                        ,a.working_time
                        ,min(a.before_seq) as before_seq
                        ,min(a.after_seq)  as after_seq
                        -------------------------------------
                        ,sum(a.before_qty) as before_qty
                        ,sum(a.after_qty) as after_qty
                        ,sum(a.before_in_qty) as before_in_qty
                        ,sum(a.after_in_qty) as after_in_qty
--                        ,a.before_qty
--                        ,a.after_qty
--                        ,a.before_in_qty
--                        ,a.after_in_qty
                        ,min(a.item_id)   as item_id
                        ,MIN(a.fixed_yn)  as fixed_yn -- MAX -> min
                        ,min(a.split_yn)  as split_yn 
                        ,min(a.demand_id) as demand_id
                        --,a.demand_type
                        ,max(a.demand_type) as demand_type 
                        ,min(a.order_id)          as order_id
                        ,min(a.order_type)        as order_type
                        ,min(a.po_id)             as po_id
                        ,min(a.mfg_week)          as mfg_week
                        ,min(a.sop_week)          as sop_week
                        ,min(a.org_work_order_id) as org_work_order_id
                        ,min(a.demand_due_date) as demand_due_date
                        ,min(a.batch_order_id)  as batch_order_id
                        ,min(a.date_fix_flag)   as date_fix_flag
                        ,min(a.date_fix_date)   as date_fix_date
                        ,min(a.operation_epst)  as operation_epst
                        ,max(a.operation_lpst)  as operation_lpst
                        ,min(a.lane_qty)        as lane_qty
                        ,min(a.lane_tact_qty)   as lane_tact_qty
                        ,min(a.item_uom)        as item_uom
                        ,min(a.wo_day_split_yn) as wo_day_split_yn
                        ,min(a.setup_time)      as setup_time
                        ,min(a.setup_time_uom)  as setup_time_uom
                        ,min(a.batch_qty)       as batch_qty
                        ,min(a.ui_edit_yn)      as ui_edit_yn
                        --,a.market
                        ,min(a.market)          as market
                        ,min(A.TOP_ITEM_ID)     AS TOP_ITEM_ID
                        ,min(a.description)     as description
                        , @v_proc_name as insert_id, getdate() as insert_time
                        , @v_proc_name as update_id, getdate() as update_time
            from        (            
                        select 
                                    master_id,plan_id 
                                    --,work_order_id
                                    ,isnull(final_work_order_id, work_order_id) as work_order_id
                                    ,before_site_id,after_site_id,before_route_id,after_route_id,before_operation_id
                                    ,after_operation_id,before_resource_id,after_resource_id,before_plan_date,after_plan_date
                                    ,before_start_time
                                    ,after_start_time
                                    ,before_end_time
                                    ,after_end_time
                                    ,working_time
                                    ,before_seq
                                    ,after_seq
                                    ,before_qty
                                    ,after_qty
                                    ,before_in_qty
                                    ,after_in_qty
                                    ,item_id
                                    ,fixed_yn
                                    ,split_yn,demand_id,demand_type,order_id,order_type,po_id,mfg_week,sop_week
                                    ,org_work_order_id
                                    ,demand_due_date
                                    -------------------
                                    , batch_order_id
                                    ------------------
                                    ,date_fix_flag,date_fix_date
                                    ,operation_epst
                                    ,operation_lpst,lane_qty,lane_tact_qty,item_uom
                                    ,wo_day_split_yn,setup_time,setup_time_uom
                                    ,batch_qty
                                    ,ui_edit_yn
                                    ,market
                                    ,TOP_ITEM_ID
                                    ,description
                      from TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
                      where master_id      = @v_master_id
                      and   plan_id        = @v_plan_id
                      and   AFTER_SITE_ID  = @v_factory_id  
                      and   AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- Mixer 공정..!!
                      and   after_qty > 0
                     ) a
            group by   a.master_id,a.plan_id 
                        ,a.work_order_id
                        --,a.before_site_id
                        ,a.after_site_id
                        --,a.before_route_id
                        ,a.after_route_id
                        --,a.before_operation_id
                        ,a.after_operation_id
                        ,a.after_resource_id
--                        ,a.before_start_time
--                        ,a.after_start_time
--                        ,a.before_end_time
--                        ,a.after_end_time
--                        ,a.working_time
--                        ,a.before_qty
--                        ,a.after_qty
--                        ,a.before_in_qty
--                        ,a.after_in_qty
                        --,a.demand_type
                        --,a.market

          
          SET @v_message = @@ROWCOUNT
          SET @v_table_name = 'fp_amend_production_plan_r'
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'Insert', @n_log_count, null, @v_message, null
          
        END           


--------------------------------------------------------
--------------------------------------------------------



-------------------------------------------------
        -- 20170711
        -- fp_amend_production_plan_r -> fixed_yn update
        -- fixed_yn = 'Y' 인 Mixer의 WO는
        -- 이전 release plan의 FP_ORDER_PEGGING_R 상 Mixer WO 와 Item이 동일해야 함
        -- WO는 같지만 Item이 동일하지 않은 건에 대해 fixed_yn = 'N' 처리하여 WO 를 신규 채번하도록 변경한다
-------------------------------------------------

-- CN_E_PRE 임시처리
--if @v_master_id = 'CN_E_PRE'
--   begin
--
--          SET @v_message = 'CN_E_PRE exept'
--          SET @v_table_name = 'fp_amend_production_plan_r'
--          SET @n_log_count = @n_log_count + 1
--          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'exept', @n_log_count, null, @v_message, null
--   end
--else
--   begin
         
         begin

            SET @v_table_name = 'fp_amend_production_plan_r'

            update fp_amend_production_plan_r
            set    fp_amend_production_plan_r.fixed_yn    = b.new_fixed_yn,
                   fp_amend_production_plan_r.update_id   = 'FIX: ' + a.fixed_yn + ' -> ' + b.new_fixed_yn,
                   fp_amend_production_plan_r.update_time = getdate()
            from   fp_amend_production_plan_r a,
                   (
                    select a.master_id, a.plan_id, a.work_order_id, a.fixed_yn, a.item_id, a.after_site_id
                           , b.from_work_order_id, b.from_factory_id, b.from_operation_id, b.from_item_id
                           , case when a.item_id = isnull(b.from_item_id, '##') 
                                  then 'Y'
                                  else 'N'
                             end as new_fixed_yn      
                    from   (
                            select master_id, plan_id, work_order_id, fixed_yn, item_id, after_site_id
                            from   fp_amend_production_plan_r
                            where  master_id      = @v_master_id
                            and    plan_id        = @v_plan_id
                            and    after_site_id  = @v_factory_id
                            and after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- Mixer 공정..!!
                            --and work_order_id in ( 'K117706MX013', 'K117706MX014' )
                            and   fixed_yn = 'Y'
                           ) a
                           left outer join
                               ( 
                                select instance_id, fp_plan_id, from_work_order_id, from_factory_id, from_operation_id, from_item_id
                                from   FP_ORDER_PEGGING_R
                                WHERE  1=1
                                and    instance_id        = @v_master_id
                                AND    FP_PLAN_ID         = @release_plan_id
                                and    from_factory_id    = @v_factory_id
                                and    from_operation_id  in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- Mixer 공정..!!
                                --and    from_work_order_id in ( 'K117706MX013', 'K117706MX014' )
                           ) b
                           on   a.work_order_id = b.from_work_order_id
                           and   a.item_id      = b.from_item_id
                    ) b 
            where  a.master_id           = b.master_id
            and    a.plan_id             = b.plan_id
            and    a.after_site_id       = b.after_site_id
            and    a.work_order_id       = b.work_order_id   
          
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

         end

 --   end



------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

-- FP_ORDER_PEGGING_R Delete / Insert start
--
        if @v_master_id = 'KR_E_PRE_A' or
           @v_master_id = 'KR_E_PRE_M' or
           @v_master_id = 'US_E_PRE'   or
           @v_master_id = 'CN_E_PRE'   or
           @v_master_id = 'KR_SRS'     
           begin

            BEGIN
            
              SET @v_table_name = 'TH_BUF_FP_ORDER_PEGGING_R'
              
              DELETE FROM TH_BUF_FP_ORDER_PEGGING_R
              WHERE  instance_id     = @v_master_id
              and    fp_plan_id      = @v_plan_id
              and    to_factory_id   = @v_factory_id
              and    to_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6) -- 'E2000'          

              SET @v_message = @@ROWCOUNT
              SET @n_log_count += 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_FP_ORDER_PEGGING_R', 'DELETE', @n_log_count, null, @v_message, null 


              insert into TH_BUF_FP_ORDER_PEGGING_R
                     (
                      INSTANCE_ID,FP_PLAN_ID,COMPANY_ID,DIVISION_ID,SITE_ID
                      ,PLANT_ID,FROM_WORK_ORDER_ID,FROM_STOCK_SET_ID,TO_WORK_ORDER_ID,FROM_FACTORY_ID
                      ,TO_FACTORY_ID,FROM_LINE_ID,TO_LINE_ID,FROM_OPERATION_ID,TO_OPERATION_ID
                      ,FROM_QTY,TO_QTY,FROM_ITEM_ID,TO_ITEM_ID,DEMAND_ID
                      ,INSERT_ID,INSERT_TIME                 
                      )
              select 
                      INSTANCE_ID,FP_PLAN_ID,COMPANY_ID,DIVISION_ID,SITE_ID
                      ,PLANT_ID,FROM_WORK_ORDER_ID,FROM_STOCK_SET_ID,TO_WORK_ORDER_ID,FROM_FACTORY_ID
                      ,TO_FACTORY_ID,FROM_LINE_ID,TO_LINE_ID,FROM_OPERATION_ID,TO_OPERATION_ID
                      ,FROM_QTY,TO_QTY,FROM_ITEM_ID,TO_ITEM_ID,DEMAND_ID
                      ,INSERT_ID,INSERT_TIME                 
              from    FP_ORDER_PEGGING_R
              WHERE   instance_id     = @v_master_id
              and     fp_plan_id      = @v_plan_id
              and     to_factory_id   = @v_factory_id
              and     to_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6) -- 'E2000'          

              
              SET @v_message = @@ROWCOUNT
              SET @v_table_name = 'TH_BUF_FP_ORDER_PEGGING_R'
              SET @n_log_count = @n_log_count + 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
              
            END   


            BEGIN
            
              SET @v_table_name = 'FP_ORDER_PEGGING_R'

              delete from a
              -- select a.* 
              from   FP_ORDER_PEGGING_R a,
                     scm_factory_m       b
              where  a.company_id      = b.company_id
              and    a.division_id     = b.division_id
              and    a.site_id         = b.site_id
              and    a.plant_id        = b.plant_id
              and    a.to_factory_id   = b.factory_id
              and    a.instance_id     = @v_master_id
              and    a.fp_plan_id      = @v_plan_id
              and    a.to_factory_id   = @v_factory_id
              and    a.to_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6) -- 'E2000'          

              SET @v_message = @@ROWCOUNT
              SET @n_log_count += 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_ORDER_PEGGING_R', 'DELETE', @n_log_count, null, @v_message, null 



              insert into FP_ORDER_PEGGING_R
                     (
                      instance_id,fp_plan_id,company_id,division_id,site_id
                      ,plant_id,from_work_order_id,from_stock_set_id,to_work_order_id,from_factory_id
                      ,to_factory_id,from_operation_id,to_operation_id,from_qty,to_qty
                      ,from_item_id,to_item_id,demand_id,insert_id,insert_time       
                     )
              
              select   a.master_id           as instance_id
                     , a.plan_id             as fp_plan_id
                     , b.company_id
                     , b.division_id
                     , b.site_id
                     , b.plant_id
                     , a.work_order_id       as from_work_order_id
                     , '-'                   as from_stock_set_id
                     , a.E2000_work_order_id as to_work_order_id
                     , d.after_site_id       as from_factory_id
                     , c.after_site_id       as to_factory_id
                     , d.after_operation_id  as from_operation_id
                     , c.after_operation_id  as to_operation_id
                     , d.after_qty           as from_qty
                     , c.after_qty           as to_qty
                     , d.item_id             as from_item_id
                     , c.item_id             as to_item_id
                     , '-'                   AS DEMAND_ID
                     , @v_proc_name          AS INSERT_ID
                     , GETDATE()             AS INSERT_TIME
              --select a.*       
              from   (
                      select distinct master_id, plan_id, after_site_id, after_operation_id, E2000_work_order_id, work_order_id
                      from   TH_BUF_E1000_PLAN_TARGET_E4
                      where  master_id = @v_master_id
                      and    plan_id   = @v_plan_id
                      and    after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )
                     ) a 
                     left OUTER join
                            (
                             select * 
                             from   scm_factory_m
                             where  factory_id = @v_factory_id
                            ) b
                            on   a.after_site_id = b.factory_id
                     inner join
                            (
                             -- Coater 정보
                             select a.*
                             from   (
                                     select a.*
                                          , dense_rank() over (partition by a.master_id
                                                                          , a.plan_id
                                                                          , a.after_site_id
                                                                          , a.work_order_id
                                                               order     by a.chk) as seq
                                     from   (
                                             select master_id, plan_id, after_site_id, after_operation_id
                                                    --, work_order_id
                                                    ,case when -- fixed_yn = 'Y'  and 
                                                               fix_work_order_id is not null
                                                          then substring(isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) ), 1, 12 )
                                                          else isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) )
                                                          end as  work_order_id                                    
                                                    , after_qty, after_in_qty, item_id
                                                    , fixed_yn, demand_id, demand_type, market
                                                    , 2 as chk
                                             from   TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY
                                             where  master_id          = @v_master_id
                                             and    plan_id            = @v_plan_id
                                             and    after_site_id      = @v_factory_id
                                             and    after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6) -- 'E2000'          
                                             union  all
                                             select instance_id as master_id, fp_plan_id as plan_id, factory_id as after_site_id, operation_id as after_operation_id
                                                    ,case when -- fixed_yn = 'Y'  and 
                                                               fix_work_order_id is not null
                                                          then substring(fix_work_order_id, 1, 12 )
                                                          else isnull( fix_work_order_id, work_order_id ) 
                                                          end as  work_order_id                                    
                                                    , plan_qty as after_qty, plan_in_qty as after_in_qty, item_id
                                                    , case when fix_work_order_id is not null then 'Y' else 'N' end as fixed_yn
                                                    , demand_id, production_type as demand_type, market
                                                    , 1 as chk
                                             from   TH_BUF_SCM_DAILY_PLAN_FACTORY
                                             where  instance_id        = @v_master_id
                                             and    fp_plan_id         = @v_plan_id
                                             and    factory_id         = @v_factory_id
                                             and    operation_id       in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6) -- 'E2000'          
                                            ) a
                                   ) a
                             where seq = 1
                             /*
                             select master_id, plan_id, after_site_id, after_operation_id
                                    --, work_order_id
                                    ,case when -- fixed_yn = 'Y'  and 
                                               fix_work_order_id is not null
                                          then substring(isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) ), 1, 12 )
                                          else isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) )
                                          end as  work_order_id                                    
                                    , after_qty, after_in_qty, item_id
                                    , fixed_yn, demand_id, demand_type, market
                             from   TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY
                             where  master_id          = @v_master_id
                             and    plan_id            = @v_plan_id
                             and    after_site_id      = @v_factory_id
                             and    after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6) -- 'E2000'          
                             */
                            ) c 
                            on   a.master_id           = c.master_id
                            and  a.plan_id             = c.plan_id
                            and  a.after_site_id       = c.after_site_id
                            and  a.E2000_work_order_id = c.work_order_id
                     inner join
                            (
                             -- Mixer 정보
                             select master_id, plan_id, after_site_id, after_operation_id, final_work_order_id, after_qty, after_in_qty, item_id
                                  , fixed_yn, demand_id, demand_type, market
                             from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
                             where  master_id          = @v_master_id
                             and    plan_id            = @v_plan_id
                             and    after_site_id      = @v_factory_id
                             and    after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )    
                             AND    after_qty > 0
                            ) d 
                            on   a.master_id           = d.master_id
                            and  a.plan_id             = d.plan_id
                            and  a.after_site_id       = d.after_site_id
                            and  a.after_operation_id  = d.after_operation_id
                            and  a.work_order_id       = d.final_work_order_id
              where  a.master_id          = @v_master_id
              and    a.plan_id            = @v_plan_id
              and    a.after_site_id      = @v_factory_id
              and    a.after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )
              
              
              
              

              
              SET @v_message = @@ROWCOUNT
              SET @v_table_name = 'FP_ORDER_PEGGING_R'
              SET @n_log_count = @n_log_count + 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
              
            END      
-- L 2419 조건              
          end  


-- FP_ORDER_PEGGING_R Delete / Insert end


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- BATCH_ORDER_ID Merge start
/* -- 2018.03.21 : 사용되지 않도록 주석처리
    ---------------------------
    -- Merge 작업 후 batch_order_id 재 채번
    -- 공정은 Instance 별 상이함
    ---------------------------
        BEGIN
        
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_BATCH_ORD'
          
          DELETE FROM TH_BUF_FP_AMEND_PROD_PLAN_R_BATCH_ORD
          WHERE   MASTER_ID     = @v_master_id
          AND     PLAN_ID       = @v_plan_id
          and     AFTER_SITE_ID = @v_factory_id

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_FP_AMEND_PROD_PLAN_R_BATCH_ORD', 'DELETE', @n_log_count, null, @v_message, null 


          insert into TH_BUF_FP_AMEND_PROD_PLAN_R_BATCH_ORD
                 (
                  MASTER_ID,PLAN_ID,WORK_ORDER_ID,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
                  ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE,BEFORE_START_TIME
                  ,AFTER_START_TIME,BEFORE_END_TIME,AFTER_END_TIME,WORKING_TIME,BEFORE_SEQ,AFTER_SEQ,BEFORE_QTY,AFTER_QTY,BEFORE_IN_QTY
                  ,AFTER_IN_QTY,ITEM_ID,FIXED_YN,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK,ORG_WORK_ORDER_ID
                  ,DEMAND_DUE_DATE,BATCH_ORDER_ID,DATE_FIX_FLAG,DATE_FIX_DATE,OPERATION_EPST,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                  ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_QTY,UI_EDIT_YN
                  ,MARKET
                  ,DESCRIPTION,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
                  )
          select 
                  MASTER_ID,PLAN_ID,WORK_ORDER_ID,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
                  ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE,BEFORE_START_TIME
                  ,AFTER_START_TIME,BEFORE_END_TIME,AFTER_END_TIME,WORKING_TIME,BEFORE_SEQ,AFTER_SEQ,BEFORE_QTY,AFTER_QTY,BEFORE_IN_QTY
                  ,AFTER_IN_QTY,ITEM_ID,FIXED_YN,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK,ORG_WORK_ORDER_ID
                  ,DEMAND_DUE_DATE,BATCH_ORDER_ID,DATE_FIX_FLAG,DATE_FIX_DATE,OPERATION_EPST,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                  ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_QTY,UI_EDIT_YN
                  ,MARKET
                  ,DESCRIPTION,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
          from fp_amend_production_plan_r
          where master_id      = @v_master_id
          and   plan_id        = @v_plan_id
          and   AFTER_SITE_ID  = @v_factory_id
          
          SET @v_message = @@ROWCOUNT
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_BATCH_ORD'
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END           




    ---------------------------
    -- Batch work_order_id 생성
    -- MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID 별
    -- 동일 Batch_id 가 연속인 건이 머지 대상
    -- operation_id  = 'E1000'
    ---------------------------
        BEGIN

          DECLARE
            @c_act2$master_id          nvarchar(150), 
            @c_act2$plan_id            nvarchar(150), 
            @c_act2$work_order_id      nvarchar(150), 
            @c_act2$after_plan_date    nvarchar(150), 
            @c_act2$after_site_id      nvarchar(150), 
            @c_act2$after_operation_id nvarchar(150), 
            @c_act2$after_route_id     nvarchar(150), 
            @c_act2$after_resource_id  nvarchar(150), 
            @c_act2$item_id            nvarchar(150), 
            @c_act2$r                  int,
            @c_act2$merge_header       nvarchar(150),
            @c_act2$batch_id           nvarchar(150)
            
          set @n_act_loop_cnt = 0  


          -- cursor 선언 및 데이터 읽어오기
          DECLARE C_ACT2 CURSOR LOCAL 
          FOR

                select  a.MASTER_ID, a.PLAN_ID, a.WORK_ORDER_ID
                          , a.AFTER_PLAN_DATE, a.AFTER_SITE_ID, a.AFTER_OPERATION_ID, a.AFTER_ROUTE_ID, a.AFTER_RESOURCE_ID, a.ITEM_ID, a.r, a.merge_header
                          , a.batch_id                      
                from    (        
                          select  a.MASTER_ID, a.PLAN_ID, a.WORK_ORDER_ID 
                                  , a.AFTER_PLAN_DATE, a.AFTER_SITE_ID, a.AFTER_OPERATION_ID, a.AFTER_ROUTE_ID, a.AFTER_RESOURCE_ID, a.ITEM_ID
                                  , a.AFTER_START_TIME, a.AFTER_END_TIME
                                  , a.AFTER_SEQ, a.AFTER_QTY, a.AFTER_IN_QTY
                                  , a.DEMAND_ID
                                  , a.DEMAND_TYPE, a.MARKET
                                  , a.r
                                  , a.next_batch_id
                                  , a.prev_batch_id
                                  , case when ( a.batch_id = a.next_batch_id or a.batch_id = a.prev_batch_id ) then 'M' 
                                         else 'N' end as merge_header
                                  , a.batch_id       
                          from    (        
                                   select  a.MASTER_ID, a.PLAN_ID, a.WORK_ORDER_ID
                                          , a.AFTER_PLAN_DATE, a.AFTER_SITE_ID, a.AFTER_OPERATION_ID, a.AFTER_ROUTE_ID, a.AFTER_RESOURCE_ID, a.ITEM_ID
                                          , a.AFTER_START_TIME, a.AFTER_END_TIME
                                          , a.AFTER_SEQ, a.AFTER_QTY, a.AFTER_IN_QTY
                                          , a.DEMAND_ID
                                          , a.DEMAND_TYPE, a.MARKET
                                  ----------------------------------------------------------------------------------------------------------------
                                  , dense_rank()      over ( partition by a.MASTER_ID, a.PLAN_ID, a.AFTER_PLAN_DATE, a.AFTER_SITE_ID, a.AFTER_OPERATION_ID, a.AFTER_ROUTE_ID, a.AFTER_RESOURCE_ID
                                                        order by a.after_seq  ) as r
                                  ----------------------------------------------------------------------------------------------------------------
                                  , LEAD ( b.batch_id )  OVER ( partition by a.MASTER_ID, a.PLAN_ID, a.AFTER_PLAN_DATE, a.AFTER_SITE_ID, a.AFTER_OPERATION_ID, a.AFTER_ROUTE_ID, a.AFTER_RESOURCE_ID
                                                        order by a.after_seq  ) as next_batch_id
                                  ----------------------------------------------------------------------------------------------------------------
                                  , LAG ( b.batch_id )   OVER ( partition by a.MASTER_ID, a.PLAN_ID, a.AFTER_PLAN_DATE, a.AFTER_SITE_ID, a.AFTER_OPERATION_ID, a.AFTER_ROUTE_ID, a.AFTER_RESOURCE_ID
                                                        order by a.after_seq  ) as prev_batch_id
                                  ----------------------------------------------------------------------------------------------------------------
                                  , b.batch_id       
                                  from   TH_BUF_FP_AMEND_PROD_PLAN_R_BATCH_ORD a
                                  left outer join
                                       (
                                        select a.company_id, a.division_id, a.site_id, a.plant_id, a.factory_id,
                                               b.item_id, b.batch_id
                                        from   (
                                                select * 
                                                from   scm_factory_m    
                                                where  factory_id = @v_factory_id
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

                                  where  master_id     = @v_master_id
                                  and    plan_id       = @v_plan_id
                                  and    after_site_id = @v_factory_id
                                  and    after_operation_id in ( @v_batch_id_merge_op1, @v_batch_id_merge_op2, @v_batch_id_merge_op3, @v_batch_id_merge_op4, @v_batch_id_merge_op5, @v_batch_id_merge_op6 )
                                 ) a
                           ) a       
                  -- 순서 중요 !!!!         
                  order by a.MASTER_ID, a.PLAN_ID, a.AFTER_PLAN_DATE, a.AFTER_SITE_ID, a.AFTER_OPERATION_ID, a.AFTER_ROUTE_ID, a.AFTER_RESOURCE_ID, a.r
                  
          -- cursor open  
          OPEN C_ACT2

          WHILE 1=1

          BEGIN
          
                FETCH C_ACT2 INTO  
                            @c_act2$master_id
                            ,@c_act2$plan_id
                            ,@c_act2$work_order_id
                            ,@c_act2$after_plan_date
                            ,@c_act2$after_site_id
                            ,@c_act2$after_operation_id
                            ,@c_act2$after_route_id
                            ,@c_act2$after_resource_id
                            ,@c_act2$item_id
                            ,@c_act2$r
                            ,@c_act2$merge_header
                            ,@c_act2$batch_id

                IF @@FETCH_STATUS <> 0 
                  BREAK

                IF @before_after_plan_date    <> @c_act2$after_plan_date    or
                   @before_after_site_id      <> @c_act2$after_site_id      or
                   @before_after_operation_id <> @c_act2$after_operation_id or
                   @before_after_route_id     <> @c_act2$after_route_id     or
                   @before_after_resource_id  <> @c_act2$after_resource_id  or
                   @before_batch_id           <> @c_act2$batch_id
                  begin 
                      set @n_act_loop_cnt  = 0
                  
                  end
     
                set @n_act_loop_cnt  += 1

                IF @n_act_loop_cnt = 1
                   BEGIN
                      -- 첫번째 루푸면 ...
                      
                      update TH_BUF_FP_AMEND_PROD_PLAN_R_BATCH_ORD
                      set    merge_batch_order_id = @c_act2$work_order_id
                      where  master_id      = @c_act2$master_id   
                      and    plan_id        = @c_act2$plan_id
                      and    after_site_id  = @c_act2$after_site_id
                      and    work_order_id  = @c_act2$work_order_id

                      SET @n_row_count = @@ROWCOUNT

                      set @before_after_plan_date    = @c_act2$after_plan_date
                      set @before_after_site_id      = @c_act2$after_site_id
                      set @before_after_operation_id = @c_act2$after_operation_id
                      set @before_after_route_id     = @c_act2$after_route_id
                      set @before_after_resource_id  = @c_act2$after_resource_id
                      set @before_merge_batch_id     = @c_act2$work_order_id
                      set @before_batch_id           = @c_act2$batch_id
                   END
                ELSE
                   BEGIN
                   --  이전 데이터와 같으면 ( merge 대상 )
                    IF @before_after_plan_date    = @c_act2$after_plan_date    and
                       @before_after_site_id      = @c_act2$after_site_id      and
                       @before_after_operation_id = @c_act2$after_operation_id and
                       @before_after_route_id     = @c_act2$after_route_id     and
                       @before_after_resource_id  = @c_act2$after_resource_id  and
                       @before_batch_id           = @c_act2$batch_id           and
                       @c_act2$merge_header       = 'M'
                      
                       BEGIN
                           
                            update TH_BUF_FP_AMEND_PROD_PLAN_R_BATCH_ORD
                            set    merge_batch_order_id = @before_merge_batch_id
                            where  master_id      = @c_act2$master_id   
                            and    plan_id        = @c_act2$plan_id
                            and    after_site_id  = @c_act2$after_site_id
                            and    work_order_id  = @c_act2$work_order_id

                          SET @n_row_count = @@ROWCOUNT
                          
                       END
                    ELSE
                       BEGIN
                            
                            update TH_BUF_FP_AMEND_PROD_PLAN_R_BATCH_ORD
                            set    merge_batch_order_id = @c_act2$work_order_id
                            where  master_id      = @c_act2$master_id   
                            and    plan_id        = @c_act2$plan_id
                            and    after_site_id  = @c_act2$after_site_id
                            and    work_order_id  = @c_act2$work_order_id

                            SET @n_row_count = @@ROWCOUNT
                        
                            set @before_after_plan_date    = @c_act2$after_plan_date
                            set @before_after_site_id      = @c_act2$after_site_id
                            set @before_after_operation_id = @c_act2$after_operation_id
                            set @before_after_route_id     = @c_act2$after_route_id
                            set @before_after_resource_id  = @c_act2$after_resource_id
                            set @before_merge_batch_id     = @c_act2$work_order_id
                            set @before_batch_id           = @c_act2$batch_id
                            
                       END
                   END
            END
          
          CLOSE C_ACT2

          DEALLOCATE C_ACT2

            --LOG 생성
            SET @v_message = N'위치-Batch_id Merge end '
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'BATCH MERGE', @n_log_count, null, @v_message, null

        END      

     

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


-- 아래 로직으로 변경

        /*** fp_amend_production_plan_r UPDATE ***/
        -- BATCH_ORDER_ID Update
--        BEGIN
--         
--          SET @v_table_name = 'fp_amend_production_plan_r'
--
--          update  fp_amend_production_plan_r
--          set     fp_amend_production_plan_r.BATCH_ORDER_ID = b.merge_batch_order_id
--          from    fp_amend_production_plan_r a,
--                  (
--                   select  MASTER_ID, PLAN_ID, WORK_ORDER_ID, merge_batch_order_id
--                  from   TH_BUF_FP_AMEND_PROD_PLAN_R_BATCH_ORD
--                  where  master_id              = @v_master_id --'LGCE_FPDEV'
--                  and    plan_id                = @v_plan_id   --'LGCE_FPDEV-20170407-00'
--                  and    after_site_id          = @v_factory_id
--                  and    after_operation_id in ( @v_batch_id_merge_op1, @v_batch_id_merge_op2, @v_batch_id_merge_op3, @v_batch_id_merge_op4, @v_batch_id_merge_op5, @v_batch_id_merge_op6 )
--                  and    merge_batch_order_id is not null
--                 ) b
--          where  a.master_id           = b.master_id
--          and    a.plan_id             = b.plan_id
--          and    a.work_order_id       = b.work_order_id
--
--            
--          SET @v_message = @@ROWCOUNT
--          SET @n_log_count = @n_log_count + 1
--          SET @sysdate = GETDATE()
--          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
--
--        END
*/



-------------------------------------------------
        -- fp_amend_production_plan_r.BATCH_ORDER_ID <- 머지한 merge_batch_order_id 를 쓰지 않고
        --                                              Batch_group_id 로 넣는 로직을 적용
-------------------------------------------------
         begin

            SET @v_table_name = 'fp_amend_production_plan_r'

            update  fp_amend_production_plan_r
            set     fp_amend_production_plan_r.BATCH_ORDER_ID = isnull(b.batch_id, b.item_id)
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




------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

-- BATCH_ORDER_ID Merge end
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

-- PRE MIX - INSTANCE DEMAND 생성 Start

        ---------------------------------------------------------------------
        -- PRE MIX - INSTANCE DEMAND 생성
        ---------------------------------------------------------------------
        BEGIN
        
          SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

          SET @v_to_instance_id = NULL
          SET @v_to_instance_key = NULL
              
          SELECT @v_to_instance_key = KEY_ID, 
                 @v_to_instance_id  = KEY_VALUE
          FROM   FP_INSTANCE_CONFIG_M
          WHERE  1=1
          AND    INSTANCE_ID  = @v_master_id
          AND    CATEGORY_ID  = 'RESULT_TRANSFER' 
          AND    KEY_PRIORITY = 3
          
          --LOG 생성
          IF @v_to_instance_key IS NOT NULL
          BEGIN
          
            SET @v_message = 'RESULT_TRANSFER : ' + @v_to_instance_id
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
            
          END

          IF @v_to_instance_key = 'CONSUME_DEMAND' 
            BEGIN
            
              SET @v_table_name = 'FP_DAILY_INSTANCE_DEMAND_H'

              DELETE FROM FP_DAILY_INSTANCE_DEMAND_H
              WHERE  INSTANCE_ID   = @v_to_instance_id
              AND    INSTANCE_DATE = @v_plan_date
              AND    SCP_PLAN_ID   = @v_plan_id
              and    customer_id   = @v_factory_id

              SET @v_message = @@ROWCOUNT
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

              INSERT INTO FP_DAILY_INSTANCE_DEMAND_H
                  (
                    INSTANCE_ID
                  , INSTANCE_DATE
                  , COMPANY_ID
                  , DIVISION_ID
                  , SITE_ID
                  , PLANT_ID
                  , SHOP_GROUP_ID
                  , SCP_PLAN_ID
                  , SCP_TARGET_ID
                  , FP_TARGET_ID
                  , ITEM_ID
                  , TO_SITE_ID
                  , TO_PLANT_ID
                  , CUSTOMER_ID
                  , MARKET
                  , DUE_DATE
                  , DUE_FENCE_DATE
                  , DEMAND_QTY
                  , ROLL_QTY
                  , JR_QTY
                  , CELL_QTY
                  , PRODUCTION_TYPE
                  , ELEC_ITEM_ID
                  , INSERT_ID
                  , INSERT_TIME
                  , UPDATE_ID
                  , UPDATE_TIME
                  )

              select 
                        @v_to_instance_id as instance_id
                      , @v_plan_date      as instance_date
                      , b.company_id, b.division_id, b.site_id, b.plant_id
                      , b.shop_group_id
                      , a.plan_id                                                 as scp_plan_id
                      , a.work_order_id + '_' + a.item_id + '_' + a.child_item_id as scp_target_id
                      , a.work_order_id + '_' + a.item_id + '_' + a.child_item_id as fp_target_id
                      , a.child_item_id as item_id -- ksjeon
                      , b.site_id       as to_site_id
                      , b.plant_id      as to_plant_id
                      , a.after_site_id as customer_id
                      , a.market
                      -- Mixer의 plan_date 하루 전의 시간에 PST의 시간 정보를 더한값
                      --, null as due_date
                      --, null as due_fence_date
                      , dateadd(minute, @n_day_diff, dateadd(day, -1, convert(datetime, after_plan_date))) as due_date
                      , dateadd(minute, @n_day_diff, dateadd(day, -1, convert(datetime, after_plan_date))) as due_fence_date
                      ----------------------------------------------------------
                      , a.pmix_target_qty as demand_qty
                      , null as roll_qty
                      , null as jr_qty
                      , null as cell_qty
                      , a.demand_type as production_type
                      , a.item_id     as elec_item_id
                      , @v_proc_name  as insert_id
                      , getdate()     as insert_dttm
                      , @v_proc_name  as update_id
                      , getdate()     as update_dttm
              --select b.*, a.*       
              from   (       
                      -- Pre Mixer 소요량 산출
                      select a.master_id, a.plan_id, 
                             a.work_order_id
                             , a.after_site_id, a.after_route_id, a.after_operation_id, a.after_resource_id
                             , a.after_plan_date, a.after_start_time, a.after_end_time
                             , a.after_seq, a.after_qty, a.after_in_qty
                             , a.item_id, a.fixed_yn, a.demand_id, a.demand_type, a.market
                             , b.CHILD_ITEM_ID, b.CONSUME_RATE
                             , a.after_in_qty * b.CONSUME_RATE as pmix_target_qty
                      from   (       
                              select master_id, plan_id, work_order_id
                                     , after_site_id, after_route_id, after_operation_id, after_resource_id, after_plan_date, after_start_time, after_end_time
                                     , after_seq, after_qty, after_in_qty, item_id, fixed_yn, demand_id, demand_type, market
                              from   fp_amend_production_plan_r
                              where  master_id          = @v_master_id
                              and    plan_id            = @v_plan_id
                              and    after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )    
                              and    after_site_id      = @v_factory_id
                              --and    item_id in ( 'ASLCA0227A' )  
                             ) a, 
                             ( 
                              SELECT AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID
                                   , AA.CHILD_QTY / AA.PARENT_QTY AS CONSUME_RATE
                              FROM   SCM_BOM_M AA,
                                     (
                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, 
                                             MIN(KEY_DATE) AS KEY_DATE
                                      FROM   SCM_BOM_M         A,
                                             SCM_ITEM_M        B,
                                             SCM_ITEM_CLASS_M  C
                                      WHERE  1=1
                                      AND    A.ACTIVE_FLAG    = 'Y'
                                      AND    A.COMPANY_ID     = B.COMPANY_ID
                                      AND    A.DIVISION_ID    = B.DIVISION_ID
                                      AND    A.SITE_ID        = B.SITE_ID
                                      AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
                                      AND    B.ACTIVE_FLAG    = 'Y'
                                      AND    B.ITEM_CLASS     = C.CLASS_ID  
                                      AND    C.USE_FLAG       = 'Y'                    
                                      AND    A.EFF_END_DATE   > CONVERT(DATE, GETDATE())              
                                      GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                                      --GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                                     ) BB,
                                     SCM_ITEM_M        CC,
                                     SCM_ITEM_CLASS_M  DD,
                                     (
                                      SELECT A.ITEM_ID, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID
                                      FROM   TH_BUF_E1000_PLAN_TARGET A
                                           , SCM_FACTORY_M            B
                                      WHERE  A.MASTER_ID      = @v_master_id
                                      AND    A.PLAN_ID        = @v_plan_id
                                      AND    A.AFTER_SITE_ID  = @v_factory_id
                                      AND    A.AFTER_SITE_ID = B.FACTORY_ID
                                      GROUP  BY A.ITEM_ID, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID
                                     ) EE
                              WHERE  AA.COMPANY_ID      = BB.COMPANY_ID
                              AND    AA.DIVISION_ID     = BB.DIVISION_ID
                              AND    AA.SITE_ID         = BB.SITE_ID
                              AND    AA.PLANT_ID        = BB.PLANT_ID
                              AND    AA.PARENT_ITEM_ID  = BB.PARENT_ITEM_ID
                              AND    AA.CHILD_ITEM_ID   = BB.CHILD_ITEM_ID
                              AND    AA.KEY_DATE        = BB.KEY_DATE
                              AND    AA.COMPANY_ID      = CC.COMPANY_ID
                              AND    AA.DIVISION_ID     = CC.DIVISION_ID
                              AND    AA.SITE_ID         = CC.SITE_ID
                              AND    AA.CHILD_ITEM_ID   = CC.ITEM_ID  
                              AND    CC.ACTIVE_FLAG     = 'Y'
                              AND    CC.ITEM_CLASS      = DD.CLASS_ID  
                              AND    DD.USE_FLAG        = 'Y'                    
                              AND    AA.ACTIVE_FLAG     = 'Y'
                              AND    AA.BOM_VERSION_ID  = '1'
                              AND    AA.EFF_END_DATE    >  CONVERT(DATE, GETDATE())
                              AND    AA.COMPANY_ID      = EE.COMPANY_ID
                              AND    AA.DIVISION_ID     = EE.DIVISION_ID
                              AND    AA.SITE_ID         = EE.SITE_ID
                              AND    AA.PLANT_ID        = EE.PLANT_ID
                              AND    AA.PARENT_ITEM_ID  = EE.ITEM_ID
                              --AND    ISNULL(ALT_PRIORITY, 1) = 1
                              and    DD.level_2_code    = 'ASL'
                              and    DD.level_3_code    = 'ASLPD'      -- pre mix 만 대상  
                              /* -- 2018.05.15 : 속도가 너무 느려서 뺀다..
                              AND    EXISTS (
                                              SELECT 1
                                              FROM   SCM_ITEM_LINE_ASSIGN_M X
                                              WHERE  X.COMPANY_ID   = AA.COMPANY_ID
                                            --AND    X.DIVISION_ID  = AA.DIVISION_ID      -- 2018.05.15 : division_id 다른 경우가 있다
                                              AND    X.SITE_ID      = AA.SITE_ID
                                            --AND    X.PLANT_ID     = AA.PLANT_ID         -- 2018.05.15 : plant_id 다른 경우가 있다
                                              AND    X.ITEM_ID      = AA.CHILD_ITEM_ID
                                            --AND    X.FACTORY_ID   = @v_factory_id       -- PREMIX 는 FACTORY 제약 없음
                                              AND    X.ACTIVE_FLAG  = 'Y'
                                              AND    X.PRIORITY     IN ( 1,2,3,4,5,6,7,8)
                                              AND    X.MONTH        = CONVERT(NVARCHAR(6), GETDATE(), 112)
                                            )
                              */
                             ) b 
                      where  1=1
                      --and    a.master_id = b.master_id
                      --and    a.plan_id   = b.plan_id
                      and    a.item_id   = b.parent_item_id
                      --order by a.work_order_id, a.item_id, b.child_item_id
                     ) a,
                     SCM_FACTORY_M b
              where  a.after_site_id = b.factory_id       
              
              --LOG 생성
              SET @v_message = @@ROWCOUNT
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

            END            
            
        END


-- PRE MIX - INSTANCE DEMAND 생성 End
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- 20170714 ksjeon
-- Mixer 공정 강제 생성 start
-- Mixer 공정 계획만 수립할 TEST 오더를 수동으로 생성 한다

         begin

            SET @v_table_name = 'fp_amend_production_plan_r'

        
            insert into fp_amend_production_plan_r
                         ( 
                          master_id,plan_id,work_order_id,before_site_id,after_site_id,before_route_id,after_route_id,before_operation_id
                          ,after_operation_id,before_resource_id,after_resource_id,before_plan_date,after_plan_date,before_start_time
                          ,after_start_time,before_end_time,after_end_time,working_time,before_seq,after_seq,before_qty,after_qty,before_in_qty
                          ,after_in_qty,item_id,fixed_yn,split_yn,demand_id,demand_type,order_id,order_type,po_id,mfg_week,sop_week,org_work_order_id
                          ,demand_due_date,batch_order_id,date_fix_flag,date_fix_date,operation_epst,operation_lpst,lane_qty,lane_tact_qty,item_uom
                          ,wo_day_split_yn,setup_time,setup_time_uom,batch_qty,ui_edit_yn
                          ,market, TOP_ITEM_ID
                          ,description,insert_id,insert_time,update_id,update_time
                         )
                           
            select a.master_id
                   , a.plan_id
                   , isnull(a.work_order_id,
                            a.wo_header + a.nation_cd + a.mass_sample + a.yymmdd_code + a.erp_operation_id + a.after_site_id + b.order_id
                           ) as work_order_id
                   ----------------------------------------------------------------------------------------------------------------
            --       , a.wo_header + a.nation_cd + a.mass_sample + a.yymmdd_code + a.erp_operation_id + a.after_site_id + b.order_id as new_work_order_id
            --       , a.wo_header
            --       , a.nation_cd
            --       , a.mass_sample
            --       , a.yymmdd_code
            --       , a.erp_operation_id  
            --       , a.after_site_id
            --       , b.order_id
            --       , a.WO_SEQ                        
                   ----------------------------------------------------------------------------------------------------------------
                   , a.before_site_id,      a.after_site_id
                   , a.before_route_id,     a.after_route_id
                   , a.before_operation_id, a.after_operation_id
                   , a.before_resource_id,  a.after_resource_id
                   , a.before_plan_date,    a.after_plan_date
                   , a.before_start_time,   a.after_start_time
                   , a.before_end_time,     a.after_end_time
                   , a.working_time
                   , a.before_seq,    a.after_seq
                   , a.before_qty,    a.after_qty
                   , a.before_in_qty, a.after_in_qty
                   , a.item_id
                   , a.fixed_yn
                   , a.split_yn
                   , a.demand_id
                   , a.demand_type
                   , a.order_id
                   , a.order_type
                   , a.po_id
                   , a.mfg_week, a.sop_week, a.org_work_order_id
                   , a.demand_due_date
                   , a.batch_order_id
                   , a.date_fix_flag,  a.date_fix_date
                   , a.operation_epst, a.operation_lpst
                   , a.lane_qty,       a.lane_tact_qty
                   , a.item_uom
                   , a.wo_day_split_yn, a.setup_time, a.setup_time_uom, a.batch_qty, a.ui_edit_yn
                   , a.market
                   , A.TOP_ITEM_ID
                   , a.description
                   , @v_proc_name as insert_id, getdate() as insert_time
                   , @v_proc_name as update_id, getdate() as update_time
            from   (       
                    select 
                             a.instance_id as master_id
                           , a.dpp_plan_id as plan_id
                           , a.work_order_id
                           ----------------------------------------------------------------------------------------------------------------
                           , isnull(f.wo_header, 'M') as wo_header
                           , isnull(g.key_value, 'K') as nation_cd
                           , isnull(h.key_value, '1') as mass_sample
                           , SUBSTRING(a.fp_plan_date, 3, 2)
                             + CASE SUBSTRING(a.fp_plan_date, 5, 2)
                                    WHEN '10' THEN 'A'
                                    WHEN '11' THEN 'B'
                                    WHEN '12' THEN 'C'
                                    ELSE SUBSTRING(a.fp_plan_date, 6, 1)
                               END
                             + SUBSTRING(a.fp_plan_date, 7, 2)
                             as yymmdd_code
                           , isnull(i.erp_operation_id, 'MX') as erp_operation_id  
                           , row_number() over( partition by a.instance_id, a.dpp_plan_id, a.operation_id
                                                    order by a.date_yyyymmdd, a.factory_id, a.line_id, e.resource_group_id, a.item_id, a.seq )
                            as WO_SEQ                        
                           ----------------------------------------------------------------------------------------------------------------
                           , a.factory_id          as before_site_id,      a.factory_id          as after_site_id
                           , a.line_id             as before_route_id,     a.line_id             as after_route_id
                           , a.operation_id        as before_operation_id, a.operation_id        as after_operation_id
                           , e.resource_group_id   as before_resource_id,  e.resource_group_id   as after_resource_id
                           , a.date_yyyymmdd       as before_plan_date,    a.date_yyyymmdd       as after_plan_date
                           , a.date_yymmddhh24miss as before_start_time,   a.date_yymmddhh24miss as after_start_time
                           , a.date_yymmddhh24miss as before_end_time,     a.date_yymmddhh24miss as after_end_time
                           , 0 as working_time
                           , a.seq     as before_seq
                           , a.seq     as after_seq
                           , a.mfg_qty as before_qty
                           , a.mfg_qty as after_qty
                           , a.mfg_qty / isnull(d.mixer_YIELD, 1) as before_in_qty
                           , a.mfg_qty / isnull(d.mixer_YIELD, 1) as after_in_qty
                           , a.item_id
                           , case when a.work_order_id is not null 
                                  then 'Y'
                                  else 'N'
                             end as fixed_yn
                           , 'N'               as split_yn
                           , a.fp_demand_id    as demand_id
                           , a.production_type as demand_type
                           , null as order_id
                           , 'W'  as order_type
                           , null as po_id
                           , a.mfg_week as mfg_week
                           , a.mfg_week as sop_week
                           , a.work_order_id as org_work_order_id
                           , a.due_date      as demand_due_date
                           , isnull(c.batch_id, a.item_id) as batch_order_id
                           , null as date_fix_flag
                           , null as date_fix_date
                           , null as operation_epst
                           , null as operation_lpst
                           , 0 as lane_qty
                           , 0 as lane_tact_qty
                           , b.item_uom
                           , 'N'      as wo_day_split_yn
                           , 0        as setup_time
                           , 'SECOND' as setup_time_uom
                           , null     as batch_qty
                           , 'N'      as ui_edit_yn
                           , a.market
                           , A.TOP_ITEM_ID
                           , null     as description
                    from   (
                            select a.company_id, a.division_id, a.site_id, a.plant_id
                                   , a.instance_id, a.dpp_plan_id
                                   , substring ( a.dpp_plan_id, charindex( '-', a.dpp_plan_id )+1, 8 ) as fp_plan_date
                                   , a.production_type, a.market
                                   , B.ITEM_ID  AS TOP_ITEM_ID
                                   , b.operation_id
                                   , a.fp_demand_id, a.work_order_id, b.item_id, b.factory_id, b.line_id, b.due_date, b.mfg_qty, b.mfg_week
                                   , dateadd(minute, 360, CONVERT(DATETIME, b.due_date, 20)) as date_yymmddhh24miss
                                   --, dateadd(minute, @n_day_diff, CONVERT(DATETIME, b.due_date, 20)) as date_yymmddhh24miss
                                   , CONVERT(varchar, CONVERT(DATETIME, b.due_date, 20) , 112) as date_yyyymmdd
                                   , row_number() over ( partition by a.instance_id, a.dpp_plan_id, b.factory_id, b.operation_id
                                                             order by a.scp_target_id, a.fp_demand_id ) as seq
                            from   dbo.fp_daily_net_demand_h a,
                                   dbo.fp_weekly_demand_product_test_h b
                            where  a.instance_id     = @v_master_id
                            and    a.dpp_plan_id     = @v_plan_id
                            and    a.production_type = 'TEST'
                            and    a.scp_target_id like b.test_target_id +'%'
                            and    b.operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                            and    isnull(a.work_order_id, '##') not in ( 
                                                                            select from_work_order_id 
                                                                            from   FP_ORDER_PEGGING_R
                                                                            where  instance_id   = @v_master_id
                                                                            and    fp_plan_id    = @v_plan_id
                                                                            and    to_factory_id = @v_factory_id
                                                                            and from_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                                                           ) 
                           ) a
                           inner join scm_item_m b
                                 on a.company_id   = b.company_id
                                 and a.division_id = b.division_id
                                 and a.site_id     = b.site_id
                                 and a.item_id     = b.item_id
                           left outer join scm_batch_m c
                                 on  a.company_id  = c.company_id
                                 and a.division_id = c.division_id
                                 and a.site_id     = c.site_id
                                 and a.plant_id    = c.plant_id
                                 and a.item_id     = c.item_id
                           left outer join
                             (
                                -- * 수율 ( SCM_YIELD_M )
                                select factory_id, operation_id, line_id, item_id, month
                                       , case when yield = null then 1
                                              when yield = 0    then 1
                                              else yield
                                         end as mixer_YIELD 
                                from   SCM_YIELD_M
                                where  1=0                          -- 2018.03.28 : Mixer 계획에서는 Yield 를 반영하지 않는다.
                                and    factory_id   = @v_factory_id
                                and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                             ) d
                                 on   a.factory_id   = d.factory_id
                                 and  a.operation_id = d.operation_id 
                                 and  a.line_id      = d.line_id
                                 and  a.item_id      = d.item_id
                                 and  substring(CONVERT(varchar, CONVERT(DATETIME, a.due_date, 20) , 112), 1, 6) = d.month             
                             inner join
                                 (
                                    -- 설비 할당
                                    select a.item_id, a.factory_id as site_id, a.route_id, a.operation_id, min(a.resource_id) as resource_group_id
                                    from   (
                                            select a.item_id, a.factory_id, a.route_id, a.operation_id, b.resource_id 
                                            from   (
                                                    select factory_id, item_id, operation_id, line_id as route_id, month, priority as alt_priority, active_flag 
                                                    from   SCM_ITEM_LINE_ASSIGN_M
                                                    where  factory_id   = @v_factory_id
                                                    and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                                    and    month        = @v_plan_month --'201707'
                                                    and    active_flag  = 'Y'
                                                    --and item_id = 'ASLAN0823A'
                                                    and    priority in ( 1, 2, 3, 4, 5, 6, 7, 8 ) -- 미사용 Flag인것은 할당 제외 (0, 9,null)
                                                   ) a,
                                                   (
                                                    select factory_id, operation_id, equipment_id as resource_id, line_id as route_id, equipment_type, active_flag
                                                    from   SCM_equipment_M
                                                    where  equipment_type = 'M'
                                                    and    factory_id     = @v_factory_id
                                                    and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                                    and    active_flag    = 'Y'
                                                   ) b
                                            where  a.factory_id   = b.factory_id
                                            and    a.operation_id = b.operation_id
                                            and    a.route_id     = b.route_id
                                           ) a
                                    group by a.item_id, a.factory_id, a.route_id, a.operation_id 
                             ) e
                                 on   a.operation_id = e.operation_id
                                 and  a.factory_id   = e.site_id
                                 and  a.line_id      = e.route_id
                                 and  a.item_id      = e.item_id               
                             ---------------------------
                             -- WO 생성용 Join
                             left outer join
                                 (
                                  -- M ( 기확정은 사용안함 )WO_Header
                                  select distinct operation_id,
                                         --company_id, division_id, site_id, operation_id, operation_name, erp_operation_id, capa_type,
                                         case when wo_flag = 'Y' 
                                              then 'W' 
                                              else 'M' 
                                         end  as WO_header 
                                  from   SCM_OPERATION_M
                                  where  operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                             ) f
                                 on   a.operation_id = f.operation_id
                             left outer join
                                 (
                                  -- 국가코드
                                  select instance_id, key_value  
                                  from   fp_instance_config_m
                                  where  1=1
                                  and    INSTANCE_ID = @v_master_id
                                  AND    CATEGORY_ID = 'EXPORT'
                                  AND    KEY_ID      = 'INSTANCE_CODE'
                             ) g
                                 on   a.instance_id = g.instance_id
                             left outer join
                                 (
                                  -- 샘플양산 구분
                                  select KEY_ID, key_value 
                                  from   FP_INSTANCE_CONFIG_M
                                  where  1=1
                                  and    INSTANCE_ID = 'COMMON'
                                  AND    KEY_ID      = 'MASS'
                             ) h
                                 on   a.production_type = h.KEY_ID
                             left outer join
                                 (
                                  -- erp_operation_id
                                  select distinct operation_id,
                                         --company_id, division_id, site_id, operation_id, operation_name, erp_operation_id, capa_type,
                                         erp_operation_id
                                  from   SCM_OPERATION_M
                                  where  operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                             ) i
                                 on   a.operation_id = i.operation_id     
                             -- WO 생성용 Join
                             ---------------------------
                    ) a                 
                    inner join
                        -- seq로 WO seq 를 찾는다 
                        ( select order_no, order_id from FP_ORDER_SEQ
                        ) b
                     on a.wo_seq = b.order_no
              order by a.wo_header, a.nation_cd, a.mass_sample, a.yymmdd_code, a.erp_operation_id, b.order_id
                        
          
            SET @v_message = 'TEST Mixer : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

         end



-- Mixer 공정 강제 생성 end

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

      -- HALF SLIT 정보 생성
      BEGIN
      
        SET @v_table_name = 'FP_AMEND_PRODUCTION_PLAN_R'

        DELETE FROM FP_AMEND_PRODUCTION_PLAN_R
        WHERE  MASTER_ID          = @v_master_id
        AND    PLAN_ID            = @v_plan_id
        AND    AFTER_SITE_ID      = @v_factory_id
        AND    AFTER_OPERATION_ID = 'E2500'
      
        SET @v_message = 'Half Slit E2500 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      
        INSERT INTO FP_AMEND_PRODUCTION_PLAN_R
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
             , ORDER_TYPE
             , MFG_WEEK
             , SOP_WEEK
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
        SELECT A.MASTER_ID
             , A.PLAN_ID
             , CASE WHEN C.WO_FLAG = 'Y' THEN 'W' 
                                         ELSE 'M' 
               END  + @v_instance_code
                    + @v_order_date_code
                    + C.ERP_OPERATION_ID
                    + '#'
                    + @v_instance_sub_code
                    + '#'
                    + A.AFTER_SITE_ID
                    + '#'
                    + SUBSTRING(A.PLAN_ID, CHARINDEX('-', A.PLAN_ID, CHARINDEX('-', A.PLAN_ID)+1)+1, 9)
                    + '#'
                    + ( CASE WHEN ORDER_SEQ < 10 THEN '000'
                             WHEN ORDER_SEQ < 100 THEN '00'
                             WHEN ORDER_SEQ < 1000 THEN '0'
                                                    ELSE ''
                        END  
                      )
                    + CONVERT(NVARCHAR, A.ORDER_SEQ)  AS WORK_ORDER_ID
             , A.AFTER_SITE_ID          AS BEFORE_SITE_ID
             , A.AFTER_SITE_ID
             , A.AFTER_ROUTE_ID         AS BEFORE_ROUTE_ID
             , A.AFTER_ROUTE_ID
             , A.AFTER_OPERATION_ID     AS BEFORE_OPERATION_ID
             , A.AFTER_OPERATION_ID
             , A.AFTER_RESOURCE_ID      AS BEFORE_RESOURCE_ID
             , A.AFTER_RESOURCE_ID
             , A.AFTER_PLAN_DATE        AS BEFORE_PLAN_DATE
             , A.AFTER_PLAN_DATE
             , A.AFTER_START_TIME       AS BEFORE_START_TIME
             , A.AFTER_START_TIME
             , A.AFTER_END_TIME         AS BEFORE_END_TIME
             , A.AFTER_END_TIME
             , A.WORKING_TIME
             , A.AFTER_SEQ              AS BEFORE_SEQ
             , A.AFTER_SEQ
             , A.AFTER_QTY              AS BEFORE_QTY
             , A.AFTER_QTY
             , A.AFTER_IN_QTY           AS BEFORE_IN_QTY
             , A.AFTER_IN_QTY
             , A.ITEM_ID
             , 'N'                      AS FIXED_YN
             , 'N'                      AS SPLIT_YN
             , A.DEMAND_ID
             , A.DEMAND_TYPE
             , CASE WHEN C.WO_FLAG = 'Y' THEN 'W' ELSE 'M' END AS ORDER_TYPE
             , A.MFG_WEEK
             , A.SOP_WEEK
             , A.DEMAND_DUE_DATE
             , A.BATCH_ORDER_ID
             , A.LANE_QTY
             , A.LANE_TACT_QTY
             , A.ITEM_UOM
             , A.MARKET
             , A.TOP_ITEM_ID
             , @v_proc_name     AS INSERT_ID
             , GETDATE()        AS INSERT_TIME
             , @v_proc_name     AS UPDATE_ID
             , GETDATE()        AS UPDATE_TIME
        FROM   (
                SELECT A.*
                     , DENSE_RANK() OVER (ORDER BY A.AFTER_SITE_ID
                                                 , A.AFTER_ROUTE_ID
                                                 , A.AFTER_OPERATION_ID
                                                 , A.AFTER_RESOURCE_ID
                                                 , A.AFTER_PLAN_DATE
                                                 , A.ITEM_ID
                                                 , A.DEMAND_ID
                                                 , A.AFTER_SEQ ) AS ORDER_SEQ
                FROM   (
                        SELECT A.MASTER_ID
                             , A.PLAN_ID
                             , A.AFTER_SITE_ID
                             , C.LINE_ID            AS AFTER_ROUTE_ID
                             , C.OPERATION_ID       AS AFTER_OPERATION_ID
                             , C.EQUIPMENT_ID       AS AFTER_RESOURCE_ID
                             , A.AFTER_PLAN_DATE
                             , A.AFTER_START_TIME
                             , A.AFTER_END_TIME
                             , A.WORKING_TIME
                             , A.AFTER_SEQ
                             , A.AFTER_QTY
                             , A.AFTER_IN_QTY
                             , A.ITEM_ID
                             , A.FIXED_YN
                             , A.SPLIT_YN
                             , A.DEMAND_ID
                             , A.DEMAND_TYPE
                             , A.MFG_WEEK
                             , A.SOP_WEEK
                             , A.DEMAND_DUE_DATE
                             , A.BATCH_ORDER_ID
                             , A.LANE_QTY
                             , A.LANE_TACT_QTY
                             , A.ITEM_UOM
                             , A.MARKET
                             , A.TOP_ITEM_ID
                        FROM   FP_AMEND_PRODUCTION_PLAN_R A
                             , SCM_ITEM_LANE_M            B
                             , (
                                SELECT *
                                FROM   SCM_EQUIPMENT_M
                                WHERE  ACTIVE_FLAG    = 'Y'
                                AND    EQUIPMENT_TYPE = 'M'
                                AND    OPERATION_ID   = 'E2500'
                               ) C
                        WHERE  A.MASTER_ID          = @v_master_id
                        AND    A.PLAN_ID            = @v_plan_id
                        AND    A.AFTER_SITE_ID      = @v_factory_id
                        AND    A.AFTER_OPERATION_ID = 'E2000'
                        --AND    A.DEMAND_TYPE       <> 'TEST'        -- 2018.04.04 : TEST 는 HS 를 만들지 않는다.
                        AND    A.AFTER_SITE_ID      = B.FACTORY_ID
                        AND    A.ITEM_ID            = B.ITEM_ID
                        AND    A.LANE_TACT_QTY      = B.LANE_QTY
                        AND    B.HALF_SLIT_FLAG     = 'Y'
                        AND    A.AFTER_SITE_ID      = C.FACTORY_ID
                        UNION  ALL
                        SELECT A.INSTANCE_ID                AS MASTER_ID
                             , A.DPP_PLAN_ID                AS PLAN_ID
                             , A.FACTORY_ID                 AS AFTER_SITE_ID
                             , C.LINE_ID                    AS AFTER_ROUTE_ID
                             , 'E2500'                      AS AFTER_OPERATION_ID
                             , C.EQUIPMENT_ID               AS AFTER_RESOURCE_ID
                             , E.PLAN_DATE                  AS AFTER_PLAN_DATE
                             , E.PLAN_DATE      + @v_hhmiss AS AFTER_START_TIME
                             , E.NEXT_PLAN_DATE + @v_hhmiss AS AFTER_END_TIME
                             , 86400                        AS WORKING_TIME
                             , A.OFFSET_SEQ                 AS AFTER_SEQ
                             , CEILING(A.OFFSET_QTY)        AS AFTER_QTY
                             , CEILING(A.OFFSET_QTY)        AS AFTER_IN_QTY
                             , A.ITEM_ID
                             , 'N'                          AS FIXED_YN
                             , 'N'                          AS SPLIT_YN
                             , A.SCP_TARGET_ID              AS DEMAND_ID
                             , A.PRODUCTION_TYPE            AS DEMAND_TYPE
                             , E.WEEK                       AS MFG_WEEK
                             , E.WEEK                       AS SOP_WEEK
                             , E.DATE_ID                    AS DEMAND_DUE_DATE
                             , '-'                          AS BATCH_ORDER_ID
                             , B.LANE_QTY
                             , B.LANE_QTY                   AS LANE_TACT_QTY
                             , D.ITEM_UOM
                             , A.MARKET
                             , A.ITEM_ID                    AS TOP_ITEM_ID
                        FROM   FP_DAILY_DEMAND_OFFSET_H A
                             , (
                                SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID
                                     , MAX(LANE_QTY) AS LANE_QTY
                                FROM   SCM_ITEM_LANE_M
                                WHERE  ACTIVE_FLAG    = 'Y'
                                AND    HALF_SLIT_FLAG = 'Y'
                                GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID
                               ) B
                             , (
                                SELECT *
                                FROM   SCM_EQUIPMENT_M
                                WHERE  ACTIVE_FLAG    = 'Y'
                                AND    EQUIPMENT_TYPE = 'M'
                                AND    OPERATION_ID   = 'E2500'
                               ) C
                             , SCM_ITEM_M       D
                             , (
                                SELECT DATE_ID, WEEK
                                     , CONVERT(NVARCHAR, DATE_ID, 112) PLAN_DATE
                                     , CONVERT(NVARCHAR, DATEADD(DAY, 1, DATE_ID), 112) NEXT_PLAN_DATE
                                FROM   SCM_SYS_CALENDAR_M
                                WHERE  DATE_ID = @v_plan_date
                               ) E
                        WHERE  A.INSTANCE_ID  = @v_master_id
                        AND    A.DPP_PLAN_ID  = @v_plan_id
                        AND    A.FACTORY_ID   = @v_factory_id
                        AND    A.OPERATION_ID = 'E2000'
                        AND    A.OFFSET_QTY   > 0
                        AND    A.COMPANY_ID   = B.COMPANY_ID
                        AND    A.DIVISION_ID  = B.DIVISION_ID
                        AND    A.SITE_ID      = B.SITE_ID
                        AND    A.PLANT_ID     = B.PLANT_ID
                        AND    A.FACTORY_ID   = B.FACTORY_ID
                        AND    A.ITEM_ID      = B.ITEM_ID
                        AND    A.COMPANY_ID   = C.COMPANY_ID
                        AND    A.DIVISION_ID  = C.DIVISION_ID
                        AND    A.SITE_ID      = C.SITE_ID
                        AND    A.PLANT_ID     = C.PLANT_ID
                        AND    A.FACTORY_ID   = C.FACTORY_ID
                        AND    A.COMPANY_ID   = D.COMPANY_ID
                        AND    A.DIVISION_ID  = D.DIVISION_ID
                        AND    A.SITE_ID      = D.SITE_ID
                        AND    A.ITEM_ID      = D.ITEM_ID
                       ) A
               ) a
             , SCM_FACTORY_M        B
             , SCM_OPERATION_M      C
        WHERE  A.AFTER_SITE_ID      = B.FACTORY_ID
        AND    B.COMPANY_ID         = C.COMPANY_ID
        AND    B.DIVISION_ID        = C.DIVISION_ID
        AND    B.SITE_ID            = C.SITE_ID
        AND    A.AFTER_OPERATION_ID = C.OPERATION_ID
      
        SET @v_message = 'Half Slit E2500 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END


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
