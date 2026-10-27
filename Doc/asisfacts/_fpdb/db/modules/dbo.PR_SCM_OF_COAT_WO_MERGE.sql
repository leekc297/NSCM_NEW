CREATE PROCEDURE [dbo].[PR_SCM_OF_COAT_WO_MERGE]
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_OF_COAT_WO_MERGE'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
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
           , @key_date = CONVERT(NVARCHAR, PLAN_START_TIME, 112)
      FROM   SCM_FP_PLAN_H WITH(NOLOCK)
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID     = @v_plan_id             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
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

          if @v_master_id = 'KR_E_PRE_A'     
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
          else if @v_master_id = 'KR_E_PRE_M'     
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
          else if @v_master_id = 'US_E_PRE'     
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
          else if @v_master_id = 'CN_E_PRE'     
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
          else if @v_master_id = 'KR_E_PMIX'     
              begin 
                set @v_wo_id_merge_op1 = 'E0500'
                set @v_wo_id_merge_op2 = '00000'
                set @v_wo_id_merge_op3 = '00000'
                set @v_wo_id_merge_op4 = '00000'
                set @v_wo_id_merge_op5 = '00000'
                set @v_wo_id_merge_op6 = '00000'
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
          else if @v_master_id = 'KR_PACK'     
              begin 
                set @v_wo_id_merge_op1     = 'P5000'
                set @v_wo_id_merge_op2     = 'P5500'
                set @v_wo_id_merge_op3     = 'P9500'
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
          else if @v_master_id = 'CN_PACK'     
              begin 
                set @v_wo_id_merge_op1     = 'P5000'
                set @v_wo_id_merge_op2     = 'P5500'
                set @v_wo_id_merge_op3     = 'P9500'
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
          else if @v_master_id = 'US_PACK'     
              begin 
                set @v_wo_id_merge_op1     = 'P5000'
                set @v_wo_id_merge_op2     = 'P5500'
                set @v_wo_id_merge_op3     = 'P9500'
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
        
        
    ---------------------------
    -- Coat Merge용 buf table 생성
    -- sy_fp_amend_production_plan_r -> TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
    ---------------------------
        BEGIN
        
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER'
          
          DELETE FROM TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
          WHERE   MASTER_ID     = @v_master_id
          AND     PLAN_ID       = @v_plan_id
          and     AFTER_SITE_ID = @v_factory_id

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER', 'DELETE', @n_log_count, null, @v_message, null 


          insert into TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
                 (
                  MASTER_ID,PLAN_ID,WORK_ORDER_ID,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
                  ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE,BEFORE_START_TIME
                  ,AFTER_START_TIME,BEFORE_END_TIME,AFTER_END_TIME,WORKING_TIME,BEFORE_SEQ,AFTER_SEQ,BEFORE_QTY,AFTER_QTY,BEFORE_IN_QTY
                  ,AFTER_IN_QTY,ITEM_ID,FIXED_YN,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK,ORG_WORK_ORDER_ID
                  ,DEMAND_DUE_DATE,BATCH_ORDER_ID,DATE_FIX_FLAG,DATE_FIX_DATE,OPERATION_EPST,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                  ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_QTY,UI_EDIT_YN
                  ,MARKET
                  , DESCRIPTION,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
                  )
          select 
                  MASTER_ID,PLAN_ID,WORK_ORDER_ID,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
                  ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE,BEFORE_START_TIME
                  ,AFTER_START_TIME,BEFORE_END_TIME,AFTER_END_TIME,WORKING_TIME,BEFORE_SEQ,AFTER_SEQ,BEFORE_QTY,AFTER_QTY,BEFORE_IN_QTY
                  ,AFTER_IN_QTY,ITEM_ID,FIXED_YN,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK,ORG_WORK_ORDER_ID
                  ,DEMAND_DUE_DATE,BATCH_ORDER_ID,DATE_FIX_FLAG,DATE_FIX_DATE,OPERATION_EPST,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                  ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_QTY,UI_EDIT_YN
                  ,MARKET
                  , DESCRIPTION,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
          from fp_amend_production_plan_r
          where master_id      = @v_master_id
          and   plan_id        = @v_plan_id
          and   AFTER_SITE_ID  = @v_factory_id
          
          SET @v_message = @@ROWCOUNT
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER'
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END           



    ---------------------------
    -- Merge work_order_id 생성
    -- MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID 별
    -- 동일 Item 이 연속인 건이 머지 대상
    ---------------------------
        BEGIN

          DECLARE
            @before_after_plan_date    nvarchar(150), 
            @before_after_site_id      nvarchar(150), 
            @before_after_operation_id nvarchar(150), 
            @before_after_route_id     nvarchar(150), 
            @before_after_resource_id  nvarchar(150), 
            @before_item_id            nvarchar(150), 
            @before_merge_id           nvarchar(150), 
            @before_merge_batch_id     nvarchar(150), 
            @new_merge_id              nvarchar(150), 
            @before_batch_id           nvarchar(150),
            @before_demand_type        nvarchar(150),
            --
            @before_market             nvarchar(150),
            @n_act_group_cnt           int = 0,
            @n_act_loop_cnt            int = 0

          DECLARE
            @c_act$master_id          nvarchar(150), 
            @c_act$plan_id            nvarchar(150), 
            @c_act$work_order_id      nvarchar(150), 
            @c_act$fix_work_order_id  nvarchar(150), 
            @c_act$after_plan_date    nvarchar(150), 
            @c_act$after_site_id      nvarchar(150), 
            @c_act$after_operation_id nvarchar(150), 
            @c_act$after_route_id     nvarchar(150), 
            @c_act$after_resource_id  nvarchar(150), 
            @c_act$item_id            nvarchar(150), 
            @c_act$r                  int,
            @c_act$merge_header       nvarchar(150),
            @c_act$fixed_yn           nvarchar(150),
            @c_act$demand_type        nvarchar(150),
            -- 
            @c_act$market             nvarchar(150),
            @c_act$r2                 int


          -- cursor 선언 및 데이터 읽어오기
          DECLARE C_ACT CURSOR LOCAL 
          FOR

                select  a.MASTER_ID, a.PLAN_ID, a.WORK_ORDER_ID, a.fix_work_order_id
                          , a.AFTER_PLAN_DATE, a.AFTER_SITE_ID, a.AFTER_OPERATION_ID, a.AFTER_ROUTE_ID, a.AFTER_RESOURCE_ID, a.ITEM_ID, a.r, a.merge_header
                          , a.fixed_yn
                          , a.DEMAND_TYPE, a.MARKET
                          , dense_rank()      over ( partition by MASTER_ID, PLAN_ID, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID, a.DEMAND_TYPE
                                                order by after_plan_date, after_seq, work_order_id  ) as r2
                from    (        
                          select  a.MASTER_ID, a.PLAN_ID, a.WORK_ORDER_ID 
                                  , NULL as fix_work_order_id
                                  , a.AFTER_PLAN_DATE, a.AFTER_SITE_ID, a.AFTER_OPERATION_ID, a.AFTER_ROUTE_ID, a.AFTER_RESOURCE_ID, a.ITEM_ID
                                  , a.AFTER_START_TIME, a.AFTER_END_TIME
                                  , a.AFTER_SEQ, a.AFTER_QTY, a.AFTER_IN_QTY
                                  , a.DEMAND_ID
                                  , a.DEMAND_TYPE, a.MARKET
                                  , a.r
                                  , a.next_item_id
                                  , a.prev_item_id
                                  , substring(a.prev_work_order_id,1,12) as prev_work_order_id
                                  , isnull(b.work_order_id,'NULL')       as open_work_order_id
                                                -- 아래 Case 순서 주의 !!!!
                                  , case when ( a.AFTER_PLAN_DATE               =  @key_date                           and -- 첫날에 
                                                isnull(b.work_order_id,'NULL') != 'NULL'                               and -- 차질이지만
                                                a.r                             > 1                                    and -- 첫번째 이후 WO이고
                                                b.work_order_id                 = substring(a.prev_work_order_id,1,12)     -- 앞의 WO와 같으면  'M'
                                              )          
                                              then 'M' 
                                          when ( a.AFTER_PLAN_DATE              =  @key_date                           and -- 첫날에 
                                                isnull(b.work_order_id,'NULL') != 'NULL'                               and -- 차질이고
                                                a.r                             > 1                                    and -- 첫번째 이후 WO이고
                                                a.item_id                       = a.prev_item_id                       and -- 앞의 기종과 같더라도
                                                --b.work_order_id                != substring(a.prev_work_order_id,1,12)   -- 앞의 WO와 다르면 'N'
                                                substring(a.work_order_id,1,12)  != substring(a.prev_work_order_id,1,12)
                                              )          
                                              then 'N' 
                                         when ( a.item_id = a.prev_item_id ) then 'M'                                      -- 첫날이 아닌경우는 차질여부를 보지 않는다 
                                         else 'N' end as merge_header
--                                  , case --when a.AFTER_PLAN_DATE = @key_date then 'N' -- ## 첫 날은 Merge 제외..!!
--                                         when isnull(b.work_order_id,'NULL') != 'NULL' then 'N' -- ## 차질 W/O는 제외..!!
--                                         when ( a.item_id = a.next_item_id or a.item_id = a.prev_item_id ) then 'M' 
--                                         else 'N' end as merge_header
                                  , a.fixed_yn
                          from    (        
                                  select  MASTER_ID, PLAN_ID, WORK_ORDER_ID
                                          , AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID, ITEM_ID
                                          , AFTER_START_TIME, AFTER_END_TIME
                                          , AFTER_SEQ, AFTER_QTY, AFTER_IN_QTY
                                          , DEMAND_ID
                                          --, case when demand_type = 'TEST' then 'TEST' else 'MASS' end as DEMAND_TYPE
                                          , DEMAND_TYPE
                                          , isnull(MARKET, 'D') as MARKET
                                  ----------------------------------------------------------------------------------------------------------------
                                  , dense_rank()      over ( partition by MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID, DEMAND_TYPE, isnull(MARKET, 'D')
                                                             order by after_seq  ) as r
                                  ----------------------------------------------------------------------------------------------------------------
                                  , LEAD ( ITEM_ID )  OVER ( partition by MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID, DEMAND_TYPE, isnull(MARKET, 'D')
                                                             order by after_seq  ) as next_item_id
                                  ----------------------------------------------------------------------------------------------------------------
                                  , LAG ( ITEM_ID )   OVER ( partition by MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID, DEMAND_TYPE, isnull(MARKET, 'D')
                                                             order by after_seq  ) as prev_item_id
                                  ----------------------------------------------------------------------------------------------------------------
                                  , isnull(
                                    LAG ( WORK_ORDER_ID )   OVER ( partition by MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID, DEMAND_TYPE, isnull(MARKET, 'D')
                                                        order by after_seq  ) 
                                          , 'FIRST')                          as prev_work_order_id
                                  ----------------------------------------------------------------------------------------------------------------
                                  , fixed_yn
                                  from   TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
                                  where  master_id     = @v_master_id
                                  and    plan_id       = @v_plan_id
                                  and    after_site_id = @v_factory_id
                                  and    after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6)
                                  and    after_qty > 0  -- ksjeon 20170516 ( amend에서 머지하여 수량이 0 가 된건은 제외함 )
                                  ) a 
                                  left outer join
                                       (select distinct work_order_id
                                        from   fp_daily_instance_order_status
                                        where  instance_id     = case when @v_is_co_merge = 'Y' then 'NULL' else @v_master_id end
                                        and    fp_plan_id      = @v_plan_id
                                        and    factory_id      = @v_factory_id
                                        and    plan_start_time < @plan_start_time  -- ## 차질 W/O 만..!!
                                        and    org_qty > 0
                                        and    WO_STATUS in ( 'OPEN', 'RUN' )) b
                                  on substring(a.work_order_id,1,12) = b.work_order_id
                           ) a       
                  -- 순서 중요 !!!!         
                  --order by a.MASTER_ID, a.PLAN_ID, a.AFTER_PLAN_DATE, a.AFTER_SITE_ID, a.AFTER_OPERATION_ID, a.AFTER_ROUTE_ID, a.AFTER_RESOURCE_ID, a.r
                  -- 20170525 DEMAND_TYPE 조건 추가로 인한 변경
                  -- 20170527 MARKET      조건 추가로 인한 변경
                  --order by a.MASTER_ID, a.PLAN_ID, a.AFTER_PLAN_DATE, a.AFTER_SITE_ID, a.AFTER_OPERATION_ID, a.AFTER_ROUTE_ID, a.AFTER_RESOURCE_ID, a.DEMAND_TYPE, a.r
                  order by a.MASTER_ID, a.PLAN_ID, a.AFTER_PLAN_DATE, a.AFTER_SITE_ID, a.AFTER_OPERATION_ID, a.AFTER_ROUTE_ID, a.AFTER_RESOURCE_ID, a.DEMAND_TYPE, a.MARKET, a.r
            
          -- cursor open  
          OPEN C_ACT

          WHILE 1=1

          BEGIN
          
                FETCH C_ACT INTO  
                            @c_act$master_id
                            ,@c_act$plan_id
                            ,@c_act$work_order_id
                            ,@c_act$fix_work_order_id
                            ,@c_act$after_plan_date
                            ,@c_act$after_site_id
                            ,@c_act$after_operation_id
                            ,@c_act$after_route_id
                            ,@c_act$after_resource_id
                            ,@c_act$item_id
                            ,@c_act$r
                            ,@c_act$merge_header
                            ,@c_act$fixed_yn
                            ,@c_act$demand_type
                            ,@c_act$market
                            ,@c_act$r2

                IF @@FETCH_STATUS <> 0 
                  BREAK

                IF @before_after_plan_date    <> @c_act$after_plan_date    or
                   @before_after_site_id      <> @c_act$after_site_id      or
                   @before_after_operation_id <> @c_act$after_operation_id or
                   @before_after_route_id     <> @c_act$after_route_id     or
                   @before_after_resource_id  <> @c_act$after_resource_id  or
                   @before_demand_type        <> @c_act$demand_type        or
                   @before_market             <> @c_act$market
                  begin 
                      set @n_act_loop_cnt  = 0
                      set @n_act_group_cnt = 0
                  
                  end
     
                set @n_act_loop_cnt  += 1

                IF @c_act$r2 = 1
                   BEGIN
                        -- 첫번째 루푸면 ...
                        set @n_act_group_cnt += 1
                        
                        if  @c_act$fixed_yn = 'Y' and @n_act_group_cnt = 1
                            and 1 = 0     -- 확정 첫 work order merge 제외시 1 = 0 제거
                            begin
                                set @n_act_loop_cnt  = 0
                                set @new_merge_id = NULL 

                                update TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
                                set    merge_work_order_id = @c_act$work_order_id
                                where  master_id      = @c_act$master_id   
                                and    plan_id        = @c_act$plan_id
                                and    after_site_id  = @c_act$after_site_id
                                and    work_order_id  = @c_act$work_order_id
                            end
                        else
                            begin
                                set @new_merge_id = @c_act$work_order_id
                                
                                update TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
                                set    merge_work_order_id = @new_merge_id
                                where  master_id      = @c_act$master_id   
                                and    plan_id        = @c_act$plan_id
                                and    after_site_id  = @c_act$after_site_id
                                and    work_order_id  = @c_act$work_order_id
                            
                            end    

                        SET @n_row_count = @@ROWCOUNT

                        set @before_after_plan_date    = @c_act$after_plan_date
                        set @before_after_site_id      = @c_act$after_site_id
                        set @before_after_operation_id = @c_act$after_operation_id
                        set @before_after_route_id     = @c_act$after_route_id
                        set @before_after_resource_id  = @c_act$after_resource_id
                        set @before_item_id            = @c_act$item_id
                        set @before_demand_type        = @c_act$demand_type
                        set @before_market             = @c_act$market
                        set @before_merge_id           = @new_merge_id
                   END
                ELSE
                   BEGIN
                   --  이전 데이터와 같으면 ( merge 대상 )
                    IF @before_after_plan_date    = @c_act$after_plan_date    and
                       @before_after_site_id      = @c_act$after_site_id      and
                       @before_after_operation_id = @c_act$after_operation_id and
                       @before_after_route_id     = @c_act$after_route_id     and
                       @before_after_resource_id  = @c_act$after_resource_id  and
                       @before_item_id            = @c_act$item_id            and
                       @before_demand_type        = @c_act$demand_type        and 
                       @before_market             = @c_act$market             and 
                       @c_act$merge_header        = 'M'
                      
                       BEGIN
                           set @new_merge_id = isnull(@before_merge_id, @c_act$work_order_id)
                           set @before_merge_id = @new_merge_id
                           
                            update TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
                            set    merge_work_order_id = @new_merge_id
                            where  master_id      = @c_act$master_id   
                            and    plan_id        = @c_act$plan_id
                            and    after_site_id  = @c_act$after_site_id
                            and    work_order_id  = @c_act$work_order_id

                          SET @n_row_count = @@ROWCOUNT
                          
                       END
                    ELSE
                       BEGIN
                           --  이전 데이터와 다르면 ( 신규 채번대상 )
                            set @new_merge_id = @c_act$work_order_id
                            
                            update TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
                            set    merge_work_order_id = @new_merge_id
                            where  master_id      = @c_act$master_id   
                            and    plan_id        = @c_act$plan_id
                            and    after_site_id  = @c_act$after_site_id
                            and    work_order_id  = @c_act$work_order_id

                            SET @n_row_count = @@ROWCOUNT
                        
                            set @before_after_plan_date    = @c_act$after_plan_date
                            set @before_after_site_id      = @c_act$after_site_id
                            set @before_after_operation_id = @c_act$after_operation_id
                            set @before_after_route_id     = @c_act$after_route_id
                            set @before_after_resource_id  = @c_act$after_resource_id
                            set @before_item_id            = @c_act$item_id
                            set @before_demand_type        = @c_act$demand_type
                            set @before_market             = @c_act$market
                            set @before_merge_id           = @new_merge_id
                            
                       END
                   END
            END
          
          CLOSE C_ACT

          DEALLOCATE C_ACT

            --LOG 생성
            SET @v_message =  N'위치-Work order_id Merge end '
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'MERGE', @n_log_count, null, @v_message, null

        END      

        


        /*** TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER UPDATE ***/
        -- IN / OUT sum  수량 Update
        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER'

          update  TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
          set     TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER.merge_plan_qty     = b.plan_qty,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER.merge_plan_in_qty  = b.plan_in_qty,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER.merge_start_time   = b.merge_start_time,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER.merge_end_time     = b.merge_end_time,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER.merge_working_time = b.merge_working_time,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER.merge_batch_qty    = b.merge_batch_qty,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER.change_id          = @v_proc_name
          from    TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER a,
                  (
                   select  MASTER_ID, PLAN_ID, WORK_ORDER_ID, merge_work_order_id
                           , after_qty
                           ----------------------------------------------------------------------------------------------------------------
                           , sum(after_qty)        over ( partition by MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID, merge_work_order_id, DEMAND_TYPE, isnull(MARKET, 'D') ) as plan_qty
                           ----------------------------------------------------------------------------------------------------------------
                           , after_in_qty
                           ----------------------------------------------------------------------------------------------------------------
                           , sum(after_in_qty)     over ( partition by MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID, merge_work_order_id, DEMAND_TYPE, isnull(MARKET, 'D') ) as plan_in_qty
                           ----------------------------------------------------------------------------------------------------------------
                           , min(after_start_time) over ( partition by MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID, merge_work_order_id, DEMAND_TYPE, isnull(MARKET, 'D') ) as merge_start_time
                           ----------------------------------------------------------------------------------------------------------------
                           , max(after_end_time)   over ( partition by MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID, merge_work_order_id, DEMAND_TYPE, isnull(MARKET, 'D') ) as merge_end_time
                           ----------------------------------------------------------------------------------------------------------------
                           , sum(working_time)     over ( partition by MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID, merge_work_order_id, DEMAND_TYPE, isnull(MARKET, 'D') ) as merge_working_time
                           ----------------------------------------------------------------------------------------------------------------
                           , sum(batch_qty)        over ( partition by MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID, merge_work_order_id, DEMAND_TYPE, isnull(MARKET, 'D') ) as merge_batch_qty
                           ----------------------------------------------------------------------------------------------------------------
                  from   TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
                  where  master_id              = @v_master_id --'LGCE_FPDEV'
                  and    plan_id                = @v_plan_id   --'LGCE_FPDEV-20170407-00'
                  and    after_site_id          = @v_factory_id
                  and    after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 )
                  and    merge_work_order_id is not null
                 ) b
          where  a.master_id           = b.master_id
          and    a.plan_id             = b.plan_id
          and    a.work_order_id       = b.work_order_id
          and    a.merge_work_order_id = b.merge_work_order_id

            
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

        /*** TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY INSERT ***/
        -- TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER 의 머지 정보를 반영하여
        -- 임시 버퍼인 TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY 생성
        -- 이 테이블에 전일 Fix  work order 정보를 생성한다

        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY'

          
          DELETE FROM TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY
          WHERE   MASTER_ID     = @v_master_id
          AND     PLAN_ID       = @v_plan_id
          and     AFTER_SITE_ID = @v_factory_id

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null 




            insert TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY
            (   MASTER_ID
              , PLAN_ID        , WORK_ORDER_ID        , BEFORE_SITE_ID        , AFTER_SITE_ID        , BEFORE_ROUTE_ID
              , AFTER_ROUTE_ID        , BEFORE_OPERATION_ID        , AFTER_OPERATION_ID        , BEFORE_RESOURCE_ID        , AFTER_RESOURCE_ID
              , BEFORE_PLAN_DATE        , AFTER_PLAN_DATE        , BEFORE_START_TIME        , AFTER_START_TIME        , BEFORE_END_TIME
              , AFTER_END_TIME        , WORKING_TIME        , BEFORE_SEQ        , AFTER_SEQ        , BEFORE_QTY        , AFTER_QTY
              , BEFORE_IN_QTY        , AFTER_IN_QTY        , ITEM_ID        , FIXED_YN        , SPLIT_YN
              , DEMAND_ID        , DEMAND_TYPE        , ORDER_ID        , ORDER_TYPE        , PO_ID
              , MFG_WEEK        , SOP_WEEK        , ORG_WORK_ORDER_ID        , DEMAND_DUE_DATE        , BATCH_ORDER_ID
              , DATE_FIX_FLAG        , DATE_FIX_DATE        , OPERATION_EPST        , OPERATION_LPST        , LANE_QTY
              , LANE_TACT_QTY        , ITEM_UOM        , WO_DAY_SPLIT_YN        , SETUP_TIME        , SETUP_TIME_UOM
              , BATCH_QTY        , UI_EDIT_YN
              , MARKET
              , DESCRIPTION
              , INSERT_ID        , INSERT_TIME               , UPDATE_ID              , UPDATE_TIME
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
                        ,a.after_plan_date
                        ,a.before_start_time
                        ,a.after_start_time
                        ,a.before_end_time
                        ,a.after_end_time
                        ,a.working_time
                        ,min(a.before_seq) as before_seq
                        ,min(a.after_seq)  as after_seq
                        ,a.before_qty
                        ,a.after_qty
                        ,a.before_in_qty
                        ,a.after_in_qty
                        ,a.item_id
                        ,MIN(a.fixed_yn)  as fixed_yn -- max -> min
                        ,min(a.split_yn)  as split_yn 
                        ,min(a.demand_id) as demand_id
                        ,a.demand_type
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
                        ,a.market
                        ,min(a.description)     as description
                        , @v_proc_name as insert_id, getdate() as insert_time
                        , @v_proc_name as update_id, getdate() as update_time
            from        (            
                        select 
                                  master_id
                                , plan_id 
                                , isnull( merge_work_order_id, work_order_id ) as work_order_id
                                , before_site_id,                          after_site_id
                                , before_route_id,                         after_route_id
                                , before_operation_id,                     after_operation_id
                                , before_resource_id,                      after_resource_id
                                , before_plan_date,                        after_plan_date
                                , merge_start_time   as before_start_time, merge_start_time as after_start_time
                                , merge_end_time     as before_end_time,   merge_end_time   as after_end_time
                                , merge_working_time as working_time
                                , before_seq,                              after_seq
                                , merge_plan_qty     as before_qty,        merge_plan_qty    as after_qty
                                , merge_plan_in_qty  as before_in_qty,     merge_plan_in_qty as after_in_qty
                                , item_id
                                --, case when fixed_yn = 'Y' and fix_work_order_id is null then 'N' else fixed_yn end as fixed_yn
                                , fixed_yn
                                , split_yn, demand_id
                                , DEMAND_TYPE --case when demand_type = 'TEST' then 'TEST' else 'MASS' end as demand_type
                                , order_id, order_type, po_id, mfg_week, sop_week
                                , org_work_order_id
                                , demand_due_date
                                , batch_order_id 
                                , date_fix_flag, date_fix_date
                                , operation_epst, operation_lpst
                                , lane_qty, lane_tact_qty
                                , item_uom
                                , wo_day_split_yn, setup_time, setup_time_uom
                                , merge_batch_qty as batch_qty
                                , ui_edit_yn
                                , MARKET
                                , description
                      from th_buf_fp_amend_prod_plan_r_coat_mer
                      where  master_id     = @v_master_id 
                      and    plan_id       = @v_plan_id
                      and    after_site_id = @v_factory_id
                      --and    merge_work_order_id = 'K117421CT0AW@2'
                      and   AFTER_OPERATION_ID in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater / Mixer 공정..!!
                      and   merge_plan_qty > 0
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
                        ,a.after_plan_date
                        ,a.before_start_time
                        ,a.after_start_time
                        ,a.before_end_time
                        ,a.after_end_time
                        ,a.working_time
                        ,a.before_qty
                        ,a.after_qty
                        ,a.before_in_qty
                        ,a.after_in_qty
                        ,a.item_id
                        ,a.demand_type   
                        ,a.MARKET
            
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


        /*** TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY UPDATE ***/
        -- 전일 Fix  work order 로 Update
        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY'

          update  TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY
          set     TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY.fix_work_order_id  = b.fix_work_order_id,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY.fix_batch_order_id = b.fix_batch_order_id,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY.change_id          = @v_proc_name
          from    TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY a,
                  (
                  select a.master_id, a.plan_id, a.work_order_id, b.work_order_id as fix_work_order_id,
                         a.after_site_id, a.after_operation_id, a.after_resource_id, a.item_id, a.after_end_time, a.seq, 
                         b.batch_order_id as fix_batch_order_id
                  from   (
                          select master_id, plan_id, work_order_id, after_site_id, after_operation_id, after_resource_id, item_id, after_end_time, fixed_yn, DEMAND_TYPE, MARKET,
                                 dense_rank()  over ( partition by after_site_id, after_operation_id, after_resource_id, item_id , DEMAND_TYPE, MARKET
                                                      order by after_plan_date, after_seq, after_end_time, work_order_id ) as seq
                          from   TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY
                          where  master_id              = @v_master_id
                          and    plan_id                = @v_plan_id
                          and    after_site_id          = @v_factory_id            
                          and    after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater / Mixer 공정..!!
                          and    after_qty > 0
                          --and    fixed_yn = 'Y'
                          union all
                          select master_id, plan_id, work_order_id, after_site_id, after_operation_id, after_resource_id, item_id, after_end_time, fixed_yn, DEMAND_TYPE, MARKET,
                                 dense_rank()  over ( partition by after_site_id, after_operation_id, after_resource_id, item_id , DEMAND_TYPE, MARKET
                                                      order by after_plan_date, after_seq, after_end_time, work_order_id ) as seq
                          from   TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY
                          where  master_id              = @v_master_id
                          and    plan_id                = @v_plan_id
                          and    after_site_id          = @v_factory_id            
                          and    after_operation_id not in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater / Mixer 이외 공정..!!
                          and    after_qty > 0
                          --and    fixed_yn = 'Y'
                         ) a
                         inner JOIN
                         (
                          select 
                                 a.fp_plan_id, a.factory_id, a.operation_id, a.equipment_id, a.item_id, a.work_order_id, a.plan_start_time, a.batch_order_id, a.PRODUCTION_TYPE, a.MARKET,
                                 dense_rank()  over ( partition by a.factory_id, a.operation_id, a.equipment_id, a.item_id, a.PRODUCTION_TYPE, a.MARKET 
                                                      order by a.plan_start_time, a.work_order_id ) as seq
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
-- 20170629 Fix pegging시 월경계  로직 변경 ( -- check 부분이 변경분 )                                                                    
--                                                              ----------------------------
--                                                              union all    -- check
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
--                                                              union all  -- check
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
--                                                              ----------------------------
--                                                              union all   -- check
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
                                                           
                                                            ) a   
                                                  ) b
                                                  where b.work_order_id = a.work_order_id  
                                          )  
                         
                         ) b
                         on      a.after_site_id      = b.factory_id
                         and     a.after_operation_id = b.operation_id
                         and     a.after_resource_id  = b.equipment_id
                         and     a.item_id            = b.item_id
                         and     a.demand_type        = b.PRODUCTION_TYPE -- add
                         and     a.MARKET             = b.MARKET          -- add
                         and     a.seq                = b.seq
                  where  a.master_id              = @v_master_id
                  and    a.plan_id                = @v_plan_id
                  and    a.after_site_id          = @v_factory_id   
                 ) b
          where  a.master_id           = b.master_id
          and    a.plan_id             = b.plan_id
          and    a.work_order_id       = b.work_order_id
          --and    isnull(a.merge_work_order_id, a.work_order_id) = isnull(b.merge_work_order_id, b.work_order_id)


          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END


        
    ---------------------------
    -- sy_fp_amend_production_plan_r 테이블 Merge work order 반영
    ---------------------------
        BEGIN
        
          SET @v_table_name = 'fp_amend_production_plan_r'

          DELETE FROM fp_amend_production_plan_r
          WHERE   MASTER_ID     = @v_master_id
          AND     PLAN_ID       = @v_plan_id
          and     AFTER_SITE_ID = @v_factory_id

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
                        ,MARKET
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
                        -----------------------------------------
                        ,min(a.after_plan_date)  as after_plan_date
                        ,min(a.before_start_time) as before_start_time
                        ,min(a.after_start_time) as after_start_time
                        ,max(a.before_end_time) as before_end_time
                        ,max(a.after_end_time) as after_end_time
                        ,sum(a.working_time) as working_time
--                        ,a.after_plan_date
--                        ,a.before_start_time
--                        ,a.after_start_time
--                        ,a.before_end_time
--                        ,a.after_end_time
--                        ,a.working_time
                        -----------------------------------------
                        ,min(a.before_seq) as before_seq
                        ,min(a.after_seq)  as after_seq
                        ---------------------
                        ,sum(a.before_qty) as before_qty
                        ,sum(a.after_qty) as after_qty
                        ,sum(a.before_in_qty) as before_in_qty
                        ,sum(a.after_in_qty) as after_in_qty
                        ,min(a.item_id)   as item_id
--                        ,a.before_qty
--                        ,a.after_qty
--                        ,a.before_in_qty
--                        ,a.after_in_qty
--                        ,a.item_id
                        -----------------------------------------
                        ,min(a.fixed_yn)  as fixed_yn -- max -> min
                        ,min(a.split_yn)  as split_yn 
                        ,min(a.demand_id) as demand_id
                        ,a.demand_type
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
                        ,isnull(a.market, 'D')  as market
                        ,min(a.description)     as description
                        , @v_proc_name as insert_id, getdate() as insert_time
                        , @v_proc_name as update_id, getdate() as update_time
            from        (            
                        select 
                                    master_id,plan_id 
                                    ,case when -- fixed_yn = 'Y'  and 
                                               fix_work_order_id is not null
                                          then substring(isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) ), 1, 12 )
                                          else isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) )
                                          end as  work_order_id
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
                                    ,case when -- fixed_yn = 'Y' and 
                                               fix_work_order_id is null then 'N' else 'Y' end as fixed_yn
                                    ,split_yn,demand_id,demand_type,order_id,order_type,po_id,mfg_week,sop_week
                                    ,org_work_order_id
                                    ,demand_due_date
                                    , min(case when -- fixed_yn = 'Y'  and 
                                                    fix_work_order_id is not null then fix_batch_order_id else batch_order_id end ) 
                                      over ( partition by case when -- fixed_yn = 'Y'  and 
                                                                    fix_work_order_id is not null
                                                               then substring(isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) ), 1, 12 )
                                                               else isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) )
                                                          end 
                                             order by after_seq ) as batch_order_id
--                                    ,case when fixed_yn = 'Y'  and fix_work_order_id is not null
--                                          then fix_batch_order_id
--                                          else batch_order_id
--                                          end as batch_order_id
                                    ,date_fix_flag,date_fix_date
                                    ,operation_epst
                                    ,operation_lpst,lane_qty,lane_tact_qty,item_uom
                                    ,wo_day_split_yn,setup_time,setup_time_uom
                                    ,batch_qty
                                    ,ui_edit_yn
                                    ,market
                                    ,description
                      from TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY
                      where master_id      = @v_master_id
                      and   plan_id        = @v_plan_id
                      and   AFTER_SITE_ID  = @v_factory_id  
                      and   AFTER_OPERATION_ID in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater / Mixer 공정..!!
                      and   after_qty > 0
                      --and   merge_work_order_id = 'WK117429MX1B2'
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
--                        ,a.after_plan_date
--                        ,a.before_start_time
--                        ,a.after_start_time
--                        ,a.before_end_time
--                        ,a.after_end_time
--                        ,a.working_time
--                        ,a.before_qty
--                        ,a.after_qty
--                        ,a.before_in_qty
--                        ,a.after_in_qty
--                        ,a.item_id
                        ,a.demand_type
                        ,isnull(a.market, 'D')
          union all
          select 
                        MASTER_ID,PLAN_ID
                        ,work_order_id
                        ,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
                        ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE,BEFORE_START_TIME
                        ,AFTER_START_TIME
                        ,BEFORE_END_TIME
                        ,AFTER_END_TIME
                        ,WORKING_TIME,BEFORE_SEQ,AFTER_SEQ,BEFORE_QTY
                        ,AFTER_QTY
                        ,BEFORE_IN_QTY
                        ,AFTER_IN_QTY
                        ,ITEM_ID
                        ,FIXED_YN
                        ,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK,ORG_WORK_ORDER_ID
                        ,DEMAND_DUE_DATE
                        ,batch_order_id
                        ,DATE_FIX_FLAG,DATE_FIX_DATE,OPERATION_EPST,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                        ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_QTY,UI_EDIT_YN
                        ,market
                        ,DESCRIPTION
                        , @v_proc_name AS INSERT_ID, GETDATE() AS INSERT_TIME
                        , @v_proc_name AS UPDATE_ID, GETDATE() AS UPDATE_TIME
          from TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
          where master_id      = @v_master_id
          and   plan_id        = @v_plan_id
          and   AFTER_SITE_ID  = @v_factory_id          
          and   AFTER_OPERATION_ID not in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater / Mixer 이외 공정..!!
          and   after_qty > 0


          
          SET @v_message = @@ROWCOUNT
          SET @v_table_name = 'fp_amend_production_plan_r'
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END           


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- 20170714~
-- WO merge 대상 공정의 일별 끝에 붙은 자투리 수량을 전날의 WO에 합산한다
--1. th_buf_fp_wo_tolerance 생성 ( 기종별 tolerance 수량 정보 ) 
--2. th_buf_fp_wo_tolerance_qty_adj 생성 ( 머지, Delete 대상의 판별 및 수량 정보 등 )
--3. th_buf_fp_wo_tolerance_qty_adj 이용  merge 수행
--4. th_buf_fp_wo_tolerance_qty_adj 이용  delete 수행
------------------------------------------------------------------------------------------------------
-- JJJ
-- 자투리 WO 머지 or Delete 처리 start


    ---------------------------
    -- << tolerance 수량 가져오기 >>
    -- operation별 tolerance 와 Item별 tolerance 를 수량 변환한 후 
    -- Item별 tolerance 수량을 구하고 없으면 operation별 수량을 사용한다
    ---------------------------
        BEGIN
        
          SET @v_table_name = 'th_buf_fp_wo_tolerance'
          
          DELETE FROM th_buf_fp_wo_tolerance
          WHERE  factory_id = @v_factory_id

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'th_buf_fp_wo_tolerance', 'DELETE', @n_log_count, null, @v_message, null 

          insert into th_buf_fp_wo_tolerance
                  (
                  factory_id  
                  ,operation_id    
                  ,line_id 
                  ,electrode_type  
                  ,item_id 
                  ,month   
                  ,tact_time   
                  ,tact_time_uom   
                  ,tolerance   
                  ,tolerance_uom   
                  ,make_sec    
                  ,tolerance_qty   
                  ,tact_time_item  
                  ,tact_time_uom_item  
                  ,tolerance_item  
                  ,tolerance_uom_item  
                  ,make_sec_item   
                  ,tolerance_qty_item  
                  ,apply_tolerance_qty
                  ,insert_id
                  ,insert_time
                  )

          select a.factory_id, a.operation_id, a.line_id, a.electrode_type, a.item_id, a.month
                 , a.tact_time , a.tact_time_uom, a.tolerance, a.tolerance_uom, a.make_sec, a.tolerance_qty
                 , b.tact_time     as tact_time_ITEM 
                 , b.tact_time_uom as tact_time_uom_ITEM
                 , b.tolerance     as tolerance_ITEM
                 , b.tolerance_uom as tolerance_uom_ITEM
                 , b.make_sec      as make_sec_ITEM
                 , b.tolerance_qty as tolerance_qty_ITEM
                 , isnull(b.tolerance_qty, a.tolerance_qty) as apply_tolerance_qty
                 , @v_proc_name as insert_id
                 , getdate()    as insert_time
            from (
                  select a.factory_id, a.operation_id, a.line_id, a.electrode_type, a.item_id, a.month
                         , a.tact_time , a.tact_time_uom
                         , b.tolerance, b.tolerance_uom, b.make_sec
                         , ceiling( ( b.tolerance * b.make_sec ) / a.tact_time ) as tolerance_qty
                    from (       
                          select factory_id, operation_id, line_id, electrode_type, item_id, month, tact_time , tact_time_uom
                            from SCM_TACT_TIME_M
                           where factory_id   = @v_factory_id
                             and operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## WO Merge 공정..!!
                             and month        = @v_plan_month  --'201707'
                             and tact_time    > 0
                             --and item_id      = 'APCAN0572A'
                         ) a,
                         (
                          select factory_id, operation_id
                                 , tolerance
                                 , tolerance_uom
                                 , case when tolerance_uom = 'MINUTE' then 60
                                        when tolerance_uom = 'HOUR'   then 60 * 60
                                        when tolerance_uom = 'DAY'    then 60 * 60 * 24
                                        else 1
                                   end as make_sec     
                            from SCM_OPERATION_MOVE_M
                           where factory_id   = @v_factory_id
                             and tolerance is not null
                             and operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## WO Merge 공정..!!
                         ) b
                   where a.factory_id   = b.factory_id
                     and a.operation_id = b.operation_id
                 ) a    
                 left outer join
                 (
                  select a.factory_id, a.operation_id, a.line_id, a.electrode_type, a.item_id, a.month
                         , a.tact_time , a.tact_time_uom
                         , b.tolerance, b.tolerance_uom, b.make_sec
                         , case when b.tolerance_uom = 'MINUTE' OR 
                                     b.tolerance_uom = 'HOUR'   OR
                                     b.tolerance_uom = 'DAY'
                                then ceiling( ( b.tolerance * b.make_sec ) / a.tact_time )
                                else b.tolerance
                           end as tolerance_qty
                    from (       
                          select factory_id, operation_id, line_id, electrode_type, item_id, month, tact_time , tact_time_uom
                            from SCM_TACT_TIME_M
                           where factory_id   = @v_factory_id
                             and operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## WO Merge 공정..!!
                             and month        = @v_plan_month --'201707'
                             and tact_time    > 0
                             --and item_id      = 'APCAN0572A'
                         ) a,
                         (
                          select factory_id, operation_id, item_id
                                 , tolerance
                                 , tolerance_uom
                                 , case when tolerance_uom = 'MINUTE' then 60
                                        when tolerance_uom = 'HOUR'   then 60 * 60
                                        when tolerance_uom = 'DAY'    then 60 * 60 * 24
                                        when tolerance_uom = 'EA'     then 1
                                        when tolerance_uom = 'KG'     then 1
                                        when tolerance_uom = 'M'      then 1
                                        when tolerance_uom = 'TO'     then 1
                                        else 1
                                   end as make_sec     
                            from SCM_ITEM_FLOW_EXCEPT_M
                           where factory_id   = @v_factory_id
                             and tolerance is not null
                             and operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## WO Merge 공정..!!
                         ) b
                   where a.factory_id   = b.factory_id
                     and a.operation_id = b.operation_id
                     and a.item_id      = b.item_id
                 ) b
                 on  a.factory_id     = b.factory_id
                 and a.operation_id   = b.operation_id
                 and a.line_id        = b.line_id
                 and a.electrode_type = b.electrode_type
                 and a.item_id        = b.item_id
                 and a.month          = b.month
          
          SET @v_message = @@ROWCOUNT
          SET @v_table_name = 'th_buf_fp_wo_tolerance'
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END           

    ---------------------------
    -- << 짜투리 WO 머지 로직 >>
    --1. a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_resource_id rank 생성
    --   operation별, 기종별 apply_tolerance_qty를 가져와 tolerance 이내인지 이후 인지 구분
    --2. Item별 구분을 주기위해 1단계로 item rank를 생성한다 
    --3. Item별 구분을 주기위해 2단계로 앞의 Item의 item rank를 가져온다
    --4. Item별 구분을 주기위해 3단계로 앞에서 가져온 item rank와 비교하여 같으면 0 , 다르면 1을 set 한다
    --5. Item별 구분을 주기위해 4단계로 item rank와 비교하여 같으면 0 , 다르면 1을 set 한 결과를 누적 SUM 한다
    --   이렇게 하면 동일 a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_resource_id
    --   내에서 동일 Item 이 있어도 위치가 다르면 다른 Rank를 가지므로 작업 대상의 구분이 가능 하다
    --6. 최종 a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_resource_id, a.final_rank 별로
    --   구분한 Item작업 대상을 최종 머지나 Delete 할 대상으로 뽑아내기위한 Rank를 구성한다 
    --7. 작업 대상인 Rank의 건을 찾는다
    --   tolerance를 구하고 마지막 계획이 동일한 item_id, demand_type, market을 갖는지 확인한다
    --   각 after_qty 수량이 tolerance 범위내에 있는지 확인한다
    --8. 머지대상인지, 머지당하고 죽을놈인지, 유지대상인지를 판단한다
    --   머지당한 WO는 후에 삭제 처리한다
    --9. Merge 대상인 경우 머지시간, 수량을 설정한다          
    --   Delete 대상인 경우 Delete WO 를 설정한다          
    ---------------------------
        BEGIN
        
          SET @v_table_name = 'th_buf_fp_wo_tolerance_qty_adj'
          
          DELETE FROM th_buf_fp_wo_tolerance_qty_adj
          where   master_id      = @v_master_id
          and     plan_id        = @v_plan_id
          and     after_site_id  = @v_factory_id

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'th_buf_fp_wo_tolerance_qty_adj', 'DELETE', @n_log_count, null, @v_message, null 

          insert into th_buf_fp_wo_tolerance_qty_adj
                 (
                  master_id
                  ,plan_id
                  ,work_order_id
                  ,after_site_id
                  ,after_operation_id
                  ,after_route_id
                  ,after_resource_id
                  ,after_plan_date
                  ,after_start_time
                  ,after_end_time
                  ,after_qty
                  ,after_in_qty
                  ,item_id
                  ,fixed_yn
                  ,demand_type
                  ,market
                  ,tolerance
                  ,tol_inout
                  ,rank_r
                  ,item_r
                  ,prev_item_r
                  ,item_prev_diff
                  ,final_rank
                  ,rev_r
                  ,same_flag_c2_d1
                  ,next_tol_inout
                  ,same_flag_c1_d2
                  ,delete_yn
                  ,merge_yn
                  ,delete_work_order_id
                  ,merge_after_end_time
                  ,merge_after_qty
                  ,merge_after_in_qty
                  ,prev_item_id
                  ,prev_demand_type
                  ,prev_market
                  ,prev_after_start_time
                  ,prev_after_end_time
                  ,prev_after_qty
                  ,prev_after_in_qty
                  ,next_item_id
                  ,next_demand_type
                  ,next_market
                  ,next_after_start_time
                  ,next_after_end_time
                  ,next_after_qty
                  ,next_after_in_qty
                  ,next_work_order_id
                  ,INSERT_ID
                  ,INSERT_TIME
                  )

          -- Merge 대상인 경우 머지시간, 수량을 설정한다          
          -- Delete 대상인 경우 Delete WO 를 설정한다          
          select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time
                 , a.after_qty, a.after_in_qty, a.item_id, a.fixed_yn, a.demand_type, a.market
                 , a.tolerance , a.tol_inout
                 , a.rank_r , a.item_r , a.prev_item_r , a.item_prev_diff , a.final_rank, a.rev_r
                 , a.same_flag_c2_d1, a.next_tol_inout, a.same_flag_c1_d2
                 --, '========'
                 , a.delete_YN     
                 , a.merge_YN     
                 --, '========'
                 , case when delete_YN = 'Y' then a.next_work_order_id                 else '' end as delete_work_order_id
                 , case when merge_YN  = 'Y' then a.next_after_end_time                else '' end as merge_after_end_time
                 , case when merge_YN  = 'Y' then a.after_qty + a.next_after_qty       else 0  end as merge_after_qty
                 , case when merge_YN  = 'Y' then a.after_in_qty + a.next_after_in_qty else 0  end as merge_after_in_qty
                   -- 앞의 데이터를 본다
                 , a.prev_item_id, a.prev_demand_type, a.prev_market, a.prev_after_start_time, a.prev_after_end_time, a.prev_after_qty, a.prev_after_in_qty
                   -- 뒤의 데이터를 본다
                 , a.next_item_id, a.next_demand_type, a.next_market, a.next_after_start_time, a.next_after_end_time, a.next_after_qty, a.next_after_in_qty, a.next_work_order_id
                 , @v_proc_name as insert_id
                 , getdate()    as insert_time
            from (
                  -- 머지대상인지, 머지당하고 죽을놈인지, 유지대상인지를 판단한다
                  -- 머지당한 WO는 후에 삭제 처리한다
                  select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time
                         , a.after_qty, a.after_in_qty, a.item_id, a.fixed_yn, a.demand_type, a.market
                         , a.tolerance , a.tol_inout
                         , a.rank_r , a.item_r , a.prev_item_r , a.item_prev_diff , a.final_rank, a.rev_r
                         , a.same_flag_c2_d1, a.next_tol_inout, a.same_flag_c1_d2
                         , case when a.rev_r = 1 and a.tol_inout = 'TOL_IN' and same_flag_c1_d2 = 'SAME'
                                then 'Y'
                                else 'N'
                           end as delete_YN     
                         , case when a.rev_r = 2 and a.next_tol_inout = 'TOL_IN' and same_flag_c2_d1 = 'SAME'
                                then 'Y'
                                else 'N'
                           end as merge_YN     
                           -- 앞의 데이터를 본다
                         , a.prev_item_id, a.prev_demand_type, a.prev_market, a.prev_after_start_time, a.prev_after_end_time, a.prev_after_qty, a.prev_after_in_qty
                           -- 뒤의 데이터를 본다
                         , a.next_item_id, a.next_demand_type, a.next_market, a.next_after_start_time, a.next_after_end_time, a.next_after_qty, a.next_after_in_qty, a.next_work_order_id
                    from (
                          -- 작업 대상인 Rank의 건을 찾는다
                          -- tolerance를 구하고 마지막 계획이 동일한 item_id, demand_type, market을 갖는지 확인한다
                          -- 각 after_qty 수량이 tolerance 범위내에 있는지 확인한다
                          select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time
                                 , a.after_qty, a.after_in_qty, a.item_id, a.fixed_yn, a.demand_type, a.market
                                 , a.tolerance , a.tol_inout
                                 , a.rank_r , a.item_r , a.prev_item_r , a.item_prev_diff , a.final_rank, a.rev_r
                                 , case when a.rev_r != 2 then ''
                                        when a.rev_r  = 2 and a.item_id     = a.next_item_id 
                                                          and a.demand_type = a.next_demand_type 
                                                          and a.market      = a.next_market 
                                                          then 'SAME'
                                        else 'DIFF'
                                   end as same_flag_c2_d1     
                                 , case when a.rev_r != 2 then ''
                                        when a.rev_r  = 2 and a.next_after_qty <= a.tolerance --9000 
                                                          then 'TOL_IN'
                                        else 'TOL_OUT'
                                   end as next_tol_inout     
                                 , case when a.rev_r != 1 then ''
                                        when a.rev_r  = 1 and a.item_id     = a.prev_item_id 
                                                          and a.demand_type = a.prev_demand_type 
                                                          and a.market      = a.prev_market 
                                                          then 'SAME'
                                        else 'DIFF'
                                   end as same_flag_c1_d2     
                                   -- 앞의 데이터를 본다
                                 , a.prev_item_id, a.prev_demand_type, a.prev_market, a.prev_after_start_time, a.prev_after_end_time, a.prev_after_qty, a.prev_after_in_qty
                                   -- 뒤의 데이터를 본다
                                 , a.next_item_id, a.next_demand_type, a.next_market, a.next_after_start_time, a.next_after_end_time, a.next_after_qty, a.next_after_in_qty, a.next_work_order_id
                            from (       
                                  -- 최종 a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_resource_id, a.final_rank 별로
                                  -- 구분한 Item작업 대상을 최종 머지나 Delete 할 대상으로 뽑아내기위한 Rank를 구성한다 
                                  select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time
                                         , a.after_qty, a.after_in_qty, a.item_id, a.fixed_yn, a.demand_type, a.market
                                         , a.tolerance, a.tol_inout       
                                         , a.rank_r
                                         , a.item_r
                                         , a.prev_item_r
                                         , a.item_prev_diff
                                         , a.final_rank
                                         , row_number() over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id, a.final_rank
                                                                   order by  a.rank_r desc ) as rev_r
                                           -- 앞의 데이터를 본다
                                         , a.prev_item_id, a.prev_demand_type, a.prev_market, a.prev_after_start_time, a.prev_after_end_time, a.prev_after_qty, a.prev_after_in_qty
                                           -- 뒤의 데이터를 본다
                                         , a.next_item_id, a.next_demand_type, a.next_market, a.next_after_start_time, a.next_after_end_time, a.next_after_qty, a.next_after_in_qty, a.next_work_order_id
                                    from (     
                                          -- Item별 구분을 주기위해 4단계로 item rank와 비교하여 같으면 0 , 다르면 1을 set 한 결과를 누적 SUM 한다
                                          -- 이렇게 하면 동일 a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_resource_id
                                          -- 내에서 동일 Item 이 있어도 위치가 다르면 다른 Rank를 가지므로 작업 대상의 구분이 가능 하다
                                          select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time
                                                 , a.after_qty, a.after_in_qty, a.item_id, a.fixed_yn, a.demand_type, a.market
                                                 , a.tolerance, a.tol_inout       
                                                 , a.rank_r
                                                 , a.item_r
                                                 , a.prev_item_r
                                                 , a.item_prev_diff
                                                 , sum(a.item_prev_diff) over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                order by a.after_start_time, a.after_end_time ) as final_rank
                                                   -- 앞의 데이터를 본다
                                                 , a.prev_item_id, a.prev_demand_type, a.prev_market, a.prev_after_start_time, a.prev_after_end_time, a.prev_after_qty, a.prev_after_in_qty
                                                   -- 뒤의 데이터를 본다
                                                 , a.next_item_id, a.next_demand_type, a.next_market, a.next_after_start_time, a.next_after_end_time, a.next_after_qty, a.next_after_in_qty, a.next_work_order_id
                                            from (     
                                                  -- Item별 구분을 주기위해 3단계로 앞에서 가져온 item rank와 비교하여 같으면 0 , 다르면 1을 set 한다
                                                  select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time
                                                         , a.after_qty, a.after_in_qty, a.item_id, a.fixed_yn, a.demand_type, a.market
                                                         , a.tolerance, a.tol_inout       
                                                         , a.rank_r
                                                         , a.item_r
                                                         , a.prev_item_r
                                                         , case when a.item_r = a.prev_item_r then 0 else 1 end as item_prev_diff  
                                                           -- 앞의 데이터를 본다
                                                         , a.prev_item_id, a.prev_demand_type, a.prev_market, a.prev_after_start_time, a.prev_after_end_time, a.prev_after_qty, a.prev_after_in_qty
                                                           -- 뒤의 데이터를 본다
                                                         , a.next_item_id, a.next_demand_type, a.next_market, a.next_after_start_time, a.next_after_end_time, a.next_after_qty, a.next_after_in_qty, a.next_work_order_id
                                                    from (     
                                                          -- Item별 구분을 주기위해 2단계로 앞의 Item의 item rank를 가져온다
                                                          select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time
                                                                 , a.after_qty, a.after_in_qty, a.item_id, a.fixed_yn, a.demand_type, a.market
                                                                 , a.tolerance, a.tol_inout       
                                                                 , a.rank_r
                                                                 , a.item_r
                                                                 , LAG ( a.item_r, 1, 0 ) over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                     order by a.after_start_time, a.after_end_time  ) as prev_item_r
                                                                   -- 앞의 데이터를 본다
                                                                 , a.prev_item_id, a.prev_demand_type, a.prev_market, a.prev_after_start_time, a.prev_after_end_time, a.prev_after_qty, a.prev_after_in_qty
                                                                   -- 뒤의 데이터를 본다
                                                                 , a.next_item_id, a.next_demand_type, a.next_market, a.next_after_start_time, a.next_after_end_time, a.next_after_qty, a.next_after_in_qty, a.next_work_order_id
                                                            from (
                                                                  -- Item별 구분을 주기위해 1단계로 item rank를 생성한다 
                                                                  select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time
                                                                         , a.after_qty, a.after_in_qty, a.item_id, a.fixed_yn, a.demand_type, a.market
                                                                         , row_number() over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                            --,item_id, demand_type, market
                                                                                                   order by  a.after_start_time, a.after_end_time ) as rank_r
                                                                         , dense_rank() over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                   order by  item_id ) as item_r
                                                                         , a.tolerance, a.tol_inout       
                                                                           -- 앞의 데이터를 본다
                                                                         , a.prev_item_id, a.prev_demand_type, a.prev_market, a.prev_after_start_time, a.prev_after_end_time, a.prev_after_qty, a.prev_after_in_qty
                                                                           -- 뒤의 데이터를 본다
                                                                         , a.next_item_id, a.next_demand_type, a.next_market, a.next_after_start_time, a.next_after_end_time, a.next_after_qty, a.next_after_in_qty, a.next_work_order_id
                                                                    from (     
                                                                          -- a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_resource_id rank 생성
                                                                          -- operation별, 기종별 apply_tolerance_qty를 가져와 tolerance 이내인지 이후 인지 구분
                                                                          select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time
                                                                                 , a.after_qty, a.after_in_qty, a.item_id, a.fixed_yn, a.demand_type, a.market
                                                                                 , isnull(b.apply_tolerance_qty, 0) as tolerance
                                                                                 , case when a.after_qty <= isnull(b.apply_tolerance_qty, 0) 
                                                                                        then 'TOL_IN'
                                                                                        else 'TOL_OUT'
                                                                                   end as tol_inout       
                                                                                   -- 앞의 데이터를 본다
                                                                                 , LAG ( a.item_id )           over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as prev_item_id
                                                                                 , LAG ( a.demand_type )       over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as prev_demand_type
                                                                                 , LAG ( a.market )            over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as prev_market
                                                                                 , LAG ( a.after_plan_date )   over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as prev_after_plan_date
                                                                                 , LAG ( a.after_start_time )  over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as prev_after_start_time
                                                                                 , LAG ( a.after_end_time )    over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as prev_after_end_time
                                                                                 , LAG ( a.after_qty )         over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as prev_after_qty
                                                                                 , LAG ( a.after_in_qty )      over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as prev_after_in_qty
                                                                                 -- 뒤의 데이터를 본다
                                                                                 , LEAD ( a.item_id )          over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as next_item_id
                                                                                 , LEAD ( a.demand_type )      over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as next_demand_type
                                                                                 , LEAD ( a.market )           over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as next_market
                                                                                 , LEAD ( a.after_plan_date )  over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as next_after_plan_date
                                                                                 , LEAD ( a.after_start_time ) over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as next_after_start_time
                                                                                 , LEAD ( a.after_end_time )   over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as next_after_end_time
                                                                                 , LEAD ( a.after_qty )        over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as next_after_qty
                                                                                 , LEAD ( a.after_in_qty )     over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as next_after_in_qty
                                                                                 , LEAD ( a.work_order_id )    over ( partition by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id
                                                                                                                        order by a.after_start_time, a.after_end_time  ) as next_work_order_id
                                                                            from fp_amend_production_plan_r a
                                                                            left outer join 
                                                                                 th_buf_fp_wo_tolerance b
                                                                                on   a.after_site_id      = b.factory_id
                                                                                and  a.after_operation_id = b.operation_id
                                                                                and  a.after_route_id     = b.line_id
                                                                                and  a.item_id            = b.item_id
                                                                           where a.master_id          = @v_master_id
                                                                             and a.plan_id            = @v_plan_id
                                                                             and a.after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## WO Merge 공정..!!
                                                                             and a.after_site_id      = @v_factory_id
                                                                         ) a 
                                                                   where ( a.item_id = a.next_item_id or a.item_id = a.prev_item_id )
                                                                   and   ( a.after_plan_date != a.next_after_plan_date or a.after_plan_date != a.prev_after_plan_date )
                                                                  ) a
                                                          ) a  
                                                  ) a
                                          ) a          
                                 ) a
                           where a.rev_r <= 2
                         ) a
              ) a            
           order by a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.after_route_id, a.after_resource_id,
                    a.after_plan_date, a.after_start_time, a.after_end_time


          SET @v_message = @@ROWCOUNT
          SET @v_table_name = 'th_buf_fp_wo_tolerance_qty_adj'
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END   



        ----------------------------
        -- merge_YN = 'Y' ->  Merge
        ----------------------------
        BEGIN
         
          SET @v_table_name = 'fp_amend_production_plan_r'

          update  fp_amend_production_plan_r
          set     fp_amend_production_plan_r.after_end_time = b.merge_after_end_time,
                  fp_amend_production_plan_r.after_qty      = b.merge_after_qty,
                  fp_amend_production_plan_r.after_in_qty   = b.merge_after_in_qty,
                  fp_amend_production_plan_r.update_id      = @v_proc_name
          from    fp_amend_production_plan_r a,
                  (
                   select master_id, plan_id, work_order_id, after_site_id, after_operation_id, merge_yn
                          , after_end_time,       after_qty,       after_in_qty
                          , merge_after_end_time, merge_after_qty, merge_after_in_qty
                   from   th_buf_fp_wo_tolerance_qty_adj
                   where  master_id          = @v_master_id 
                   and    plan_id            = @v_plan_id
                   and    after_site_id      = @v_factory_id
                   and    after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## WO Merge 공정..!!
                   and    merge_yn           = 'Y'
                 ) b
          where  a.master_id           = b.master_id
          and    a.plan_id             = b.plan_id
          and    a.after_site_id       = b.after_site_id
          and    a.work_order_id       = b.work_order_id

            
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END


        --------------------------
         --delete_YN = 'Y' -> 삭제
        --------------------------
        BEGIN
         
          SET @v_table_name = 'fp_amend_production_plan_r'

          delete from a
          --select a.* 
          from   fp_amend_production_plan_r     a,
                 th_buf_fp_wo_tolerance_qty_adj b
          where  a.master_id          = b.master_id
          and    a.plan_id            = b.plan_id
          and    a.after_site_id      = b.after_site_id
          and    a.after_operation_id = b.after_operation_id
          and    a.work_order_id      = b.work_order_id
          and    a.master_id          = @v_master_id 
          and    a.plan_id            = @v_plan_id
          and    a.after_site_id      = @v_factory_id
          and    a.after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## WO Merge 공정..!!
          and    b.delete_YN          = 'Y'

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'fp_amend_production_plan_r mod', 'DELETE', @n_log_count, null, @v_message, null 

        END

-- 자투리 WO 머지 or Delete 처리 end

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--------------------------------------------------------
--------------------------------------------------------
        -- ksjeon 20170512
        -- Coating WO merge 후 map 생성
        ---------------------------

        BEGIN
        
          SET @v_table_name = 'TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP'
          
          delete  from th_buf_coat_mix_work_order_merge_map
          where   instance_id = @v_master_id
          and     fp_plan_id  = @v_plan_id
          and     factory_id  = @v_factory_id


          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP', 'DELETE', @n_log_count, null, @v_message, null 


          insert into TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP
                 (
                  INSTANCE_ID,                    FP_PLAN_ID,                   FACTORY_ID,             DEMAND_ID,          COAT_WORK_ORDER_ID
                  , COAT_SUB_WORK_ORDER_ID,       COAT_OPERATION_ID,            EX_ORD_COAT_QTY,        COAT_ITEM_ID,       COAT_WORK_CNT,      CALC_COAT_QTY
                  , COAT_MER_COATQTY,   COAT_PLAN_DATE
                  , COAT_MERGE_WORK_ORDER_ID,     COAT_SUB_MERGE_WORK_ORDER_ID, COAT_FIX_WORK_ORDER_ID, COAT_FIXED_YN,      COAT_DEMAND_TYPE
                  , MIX_WORK_ORDER_ID,            MIX_OPERATION_ID,             EX_ORD_MIX_QTY,         MIX_ITEM_ID,        COAT_MER_MIXQTY,    MIX_PLAN_DATE
                  , MIX_MERGE_WORK_ORDER_ID,      INSERT_ID,                    INSERT_TIME
                 ) 

    ------------------------------------------------------------
    -- 소량 Lot Merge 추가
    -- coat 수량 -> mix WO 수로 나누기
    ------------------------------------------------------------

          -- Fix work order map 추가
          select   a.instance_id, a.FP_PLAN_ID, a.factory_id
                 , a.demand_id--, isnull(a.coat_merge_work_order_id, a.coat_work_order_id)
                         -------------------------------------------------------------------------------------------------  
                 , a.coat_work_order_id, a.coat_sub_work_order_id, a.coat_operation_id
                 , a.ex_ord_coat_qty, a.coat_item_id
                 , count(*) over ( partition by a.coat_work_order_id) as coat_work_cnt, ( a.EX_ORD_COAT_QTY / count(*) over ( partition by a.coat_work_order_id) ) as calc_coat_qty
                 --, b.item_id
                 , a.coat_mer_coatqty, a.coat_plan_date
                 , a.coat_merge_work_order_id, a.coat_sub_merge_work_order_id, b.fix_work_order_id as coat_fix_work_order_id, a.coat_fixed_yn, a.coat_demand_type  
                         -------------------------------------------------------------------------------------------------  
                 , a.mix_work_order_id,  a.mix_operation_id, a.ex_ord_mix_qty, a.mix_item_id
                 , a.coat_mer_mixqty, a.mix_plan_date
                 , a.mix_merge_work_order_id
                         -------------------------------------------------------------------------------------------------  
                 , @v_proc_name as insert_id, getdate() as insert_time
          from   (   
                  -- MIX/COAT MRGE후의 WO Map ( 일자별, Factory별, 공정별, 설비별, Demand type별 머지  ( Coat 기준으로 봄 )
                  select   a.instance_id, a.FP_PLAN_ID, a.factory_id
                         , a.demand_id
                         -------------------------------------------------------------------------------------------------  
                         , a.coat_work_order_id, a.coat_sub_work_order_id, a.coat_operation_id, a.ex_ord_coat_qty, a.coat_item_id, b.merge_plan_qty as coat_mer_coatqty, b.after_plan_date as coat_plan_date
                         , b.merge_work_order_id as coat_merge_work_order_id
                         , case when charindex( '@', b.merge_work_order_id, 0 ) > 0 
                                then substring( b.merge_work_order_id, 1, charindex( '@', b.merge_work_order_id, 0 )-1)
                                else b.merge_work_order_id 
                           end as coat_sub_merge_work_order_id
                         , b.after_resource_id as coat_resource_id  -- add
                         -------------------------------------------------------------------------------------------------  
                         , b.fixed_yn as coat_fixed_yn, b.demand_type as coat_demand_type 
                         , a.mix_work_order_id,  a.mix_operation_id,  a.ex_ord_mix_qty, a.mix_item_id
                         , c.merge_plan_qty as coat_mer_mixqty, c.after_plan_date as mix_plan_date
                         , c.merge_work_order_id as mix_merge_work_order_id
                         -------------------------------------------------------------------------------------------------  
                  from   (             
                          -- th_exp_order_tracking 에 의한 MIX/COAT WO MAP        
                          select   a.instance_id, a.FP_PLAN_ID, a.factory_id
                                 , a.demand_id
                                 , a.work_order_id as coat_work_order_id, a.sub_work_order_id as coat_sub_work_order_id, a.operation_id as coat_operation_id, a.ex_ord_coat_qty, a.item_id as coat_item_id
                                 , b.work_order_id as mix_work_order_id,  b.after_operation_id as mix_operation_id, b.ex_ord_mix_qty, b.item_id as mix_item_id   
                          from   (
                                  select distinct a.instance_id, a.FP_PLAN_ID
                                         , a.company_id, a.division_id, a.site_id, a.plant_id, a.factory_id
                                         , a.demand_id
                                         , a.work_order_id
                                         , case when charindex( '@', a.work_order_id, 0 ) > 0 
                                                then substring( a.work_order_id, 1, charindex( '@', a.work_order_id, 0 )-1)
                                                else a.work_order_id 
                                           end as sub_work_order_id
                                         , a.operation_id, a.item_id
                                         , a.plan_qty as ex_ord_coat_qty--, in_plan_qty
                                  -----------------------------------------       
                                  --from   lgce_fpdev.dbo.th_exp_order_tracking a
                                  from   (
                                          select * from   kr_e_pre_a.dbo.th_exp_order_tracking union all
                                          select * from   kr_e_pre_m.dbo.th_exp_order_tracking union all
                                          select * from     us_e_pre.dbo.th_exp_order_tracking union all
                                          select * from     cn_e_pre.dbo.th_exp_order_tracking union all
                                          select * from       kr_srs.dbo.th_exp_order_tracking                                  
                                         ) a 
                                  -----------------------------------------       
                                  where  a.instance_id   = @v_master_id
                                  and    a.fp_plan_id    = @v_plan_id
                                  and    a.factory_id    = @v_factory_id
                                  -- coat_operation --'E2000'
                                  and    a.operation_id  in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater 공정..!!
                                 ) a 
                                 left outer JOIN  
                                 (
                                  select distinct 
                                         a.master_id, a.PLAN_ID
                                         , a.after_site_id, a.item_id
                                         , a.demand_id, a.work_order_id, a.after_operation_id
                                         , a.new_plan_qty as ex_ord_mix_qty
                                  -----------------------------------------       
                                  --from   lgce_fpdev.dbo.th_buf_fp_amend_production_plan_r a
                                  from   (
                                          select * from   kr_e_pre_a.dbo.th_buf_fp_amend_production_plan_r union all
                                          select * from   kr_e_pre_m.dbo.th_buf_fp_amend_production_plan_r union all
                                          select * from     us_e_pre.dbo.th_buf_fp_amend_production_plan_r union all
                                          select * from     cn_e_pre.dbo.th_buf_fp_amend_production_plan_r union all
                                          select * from       kr_srs.dbo.th_buf_fp_amend_production_plan_r                                  
                                         ) a
                                  -----------------------------------------       
                                  where  a.master_id           = @v_master_id
                                  and    a.plan_id             = @v_plan_id
                                  and    a.after_site_id       = @v_factory_id
                                  -- mix_operation --'E1000'
                                  and    a.after_operation_id  in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )
                                  and    a.delete_yn not in ( 'D' ) 
                                ) b                
                               on  a.instance_id          = b.master_id
                               and a.FP_PLAN_ID           = b.PLAN_ID
                               and a.factory_id           = b.after_site_id
                               and a.demand_id            = b.demand_id
                          ) a
                         left outer join 
                          TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER b
                              on  a.instance_id        = b.master_id
                              and a.fp_plan_id         = b.plan_id
                              and a.factory_id         = b.after_site_id
                              and a.demand_id          = b.demand_id
                              and a.coat_sub_work_order_id  = case when charindex( '@', b.work_order_id, 0 ) > 0 
                                                                   then substring( b.work_order_id, 1, charindex( '@', b.work_order_id, 0 )-1)
                                                                   else b.work_order_id 
                                                              end
                              and a.coat_operation_id  = b.after_operation_id   
                         left outer join 
                          TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER c
                              on  a.instance_id        = c.master_id
                              and a.fp_plan_id         = c.plan_id
                              and a.factory_id         = c.after_site_id
                              and a.demand_id          = c.demand_id
                              and a.mix_work_order_id  = c.work_order_id
                              and a.mix_operation_id   = c.after_operation_id       
                  where  1=1
                 ) a 
                 left outer join 
                  TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER_APPLY b
                      on  a.instance_id        = b.master_id
                      and a.fp_plan_id         = b.plan_id
                      and a.factory_id         = b.after_site_id
                      and a.coat_resource_id   = b.after_resource_id -- add
                      --and isnull(a.coat_sub_merge_work_order_id, a.coat_sub_work_order_id) = isnull(b.fix_work_order_id, b.work_order_id)
                      and isnull(a.coat_sub_merge_work_order_id, a.coat_sub_work_order_id) = case when charindex('@', b.work_order_id) = 0 then b.work_order_id
                                                                                                  else substring(b.work_order_id, 1, charindex('@', b.work_order_id)-1)
                                                                                             end
                      and a.coat_operation_id  = b.after_operation_id      
          -- coat 기준
          order by a.instance_id, a.fp_plan_id, a.factory_id, a.coat_operation_id, a.coat_plan_date, a.coat_sub_merge_work_order_id desc, a.coat_merge_work_order_id, a.coat_sub_work_order_id, a.coat_work_order_id
          -- MIX 기준
          --order by a.instance_id, a.fp_plan_id, a.factory_id, a.coat_operation_id, a.mix_merge_work_order_id, a.mix_plan_date, a.mix_work_order_id         
         
    
    

          --LOG 생성
          SET @v_message = N'Coating_Mixer WO merge 후 map 생성 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END

--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------

  
    ---------------------------
    -- MIX Merge용 buf table 생성
    -- 1차로 Coating 머지 후 그 결과를 이용하여 Mixer를 머지 한다
    -- sy_fp_amend_production_plan_r -> TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER
    ---------------------------
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
                  ,MARKET
                  , DESCRIPTION,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
                  )
          select 
                  MASTER_ID,PLAN_ID,WORK_ORDER_ID,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
                  ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE,BEFORE_START_TIME
                  ,AFTER_START_TIME,BEFORE_END_TIME,AFTER_END_TIME,WORKING_TIME,BEFORE_SEQ,AFTER_SEQ,BEFORE_QTY,AFTER_QTY,BEFORE_IN_QTY
                  ,AFTER_IN_QTY,ITEM_ID,FIXED_YN,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK,ORG_WORK_ORDER_ID
                  ,DEMAND_DUE_DATE,BATCH_ORDER_ID,DATE_FIX_FLAG,DATE_FIX_DATE,OPERATION_EPST,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                  ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_QTY,UI_EDIT_YN
                  ,MARKET
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


        /*** TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER UPDATE ***/
        -- merge_work_order_id Update
        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER'

          update TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER
          set    TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_work_order_id = b.mix_merge_work_order_id
          from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER a,
                 (
                  select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_resource_id
                           -- a.item_id add -> 1:2 인건 누락오류 수정
                         --, min(a.work_order_id) over ( partition by a.coat_merge_work_order_id, a.after_resource_id ) as mix_merge_work_order_id
                         , min(a.work_order_id) over ( partition by a.coat_merge_work_order_id, a.after_resource_id, a.item_id ) as mix_merge_work_order_id
                         ----------------------------------------------------------------------------------------------------------------
                         , a.coat_merge_work_order_id
                  from   (
                          select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_resource_id, b.coat_work_order_id, b.coat_merge_work_order_id
                                 , after_qty, a.after_in_qty, a.after_start_time, a.after_end_time, a.working_time, a.batch_qty
                                   -- a.item_id add -> 1:2 인건 누락오류 수정
                                 , a.item_id
                          from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER a
                                 left outer JOIN
                                     TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP b
                                 on     1=1
                                 and    a.master_id              = b.instance_id
                                 and    a.plan_id                = b.fp_plan_id
                                 and    a.after_site_id          = b.factory_id
                                 and    a.after_operation_id     = isnull(b.mix_operation_id, '###')
                                 and    a.work_order_id          = isnull(b.mix_work_order_id, '###')
                          where  a.master_id              = @v_master_id
                          and    a.plan_id                = @v_plan_id
                          and    a.after_site_id          = @v_factory_id
                          --and    a.after_operation_id in ( 'E1000' )
                          and    b.COAT_MER_COATQTY > 0 -- 20170704 ksjeon
                          and    a.after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )
                          ) a
                 ) b
          where  a.master_id           = b.master_id
          and    a.plan_id             = b.plan_id
          and    a.after_site_id       = b.after_site_id
          and    a.work_order_id       = b.work_order_id


            
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END



        /*** TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER UPDATE ***/
        -- IN / OUT sum  수량 Update Update
        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER'

          update  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER
          set     TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_plan_qty     = b.plan_qty,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_plan_in_qty  = b.plan_in_qty,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_start_time   = b.merge_start_time,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_end_time     = b.merge_end_time,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_working_time = b.merge_working_time,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_batch_qty    = b.merge_batch_qty,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.change_id          = @v_proc_name
          from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER a,
                 (
                  select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_resource_id, a.merge_work_order_id
                         ----------------------------------------------------------------------------------------------------------------
                         , sum(a.after_qty)        over ( partition by a.merge_work_order_id, a.after_resource_id ) as plan_qty
                         ----------------------------------------------------------------------------------------------------------------
                         , sum(a.after_in_qty)     over ( partition by a.merge_work_order_id, a.after_resource_id ) as plan_in_qty
                         ----------------------------------------------------------------------------------------------------------------
                         , min(a.after_start_time) over ( partition by a.merge_work_order_id, a.after_resource_id ) as merge_start_time
                         ----------------------------------------------------------------------------------------------------------------
                         , max(a.after_end_time)   over ( partition by a.merge_work_order_id, a.after_resource_id ) as merge_end_time
                         ----------------------------------------------------------------------------------------------------------------
                         , sum(a.working_time)     over ( partition by a.merge_work_order_id, a.after_resource_id ) as merge_working_time
                         ----------------------------------------------------------------------------------------------------------------
                         , sum(a.batch_qty)        over ( partition by a.merge_work_order_id, a.after_resource_id ) as merge_batch_qty
                         ----------------------------------------------------------------------------------------------------------------
                  from   (
                          select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_resource_id--, b.coat_work_order_id, b.coat_merge_work_order_id
                                 , a.after_qty, a.after_in_qty, a.after_start_time, a.after_end_time, a.working_time, a.batch_qty
                                 , a.merge_work_order_id
                          from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER a
                                 left outer JOIN
                                     TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER b
                                 on     1=1
                                 and    a.master_id              = b.master_id
                                 and    a.plan_id                = b.plan_id
                                 and    a.after_site_id          = b.after_site_id
                                 and    a.after_operation_id     = isnull(b.after_operation_id, '###')
                                 and    a.work_order_id          = isnull(b.work_order_id, '###')
                          where  a.master_id              = @v_master_id
                          and    a.plan_id                = @v_plan_id
                          and    a.after_site_id          = @v_factory_id
                          --and    a.after_operation_id in ( 'E1000' )
                          and    a.after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )
                          ) a
                 ) b
          where  a.master_id           = b.master_id
          and    a.plan_id             = b.plan_id
          and    a.work_order_id       = b.work_order_id
          and    a.merge_work_order_id = b.merge_work_order_id


--          update  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER
--          set     TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_plan_qty     = b.plan_qty,
--                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_plan_in_qty  = b.plan_in_qty,
--                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_start_time   = b.merge_start_time,
--                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_end_time     = b.merge_end_time,
--                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_working_time = b.merge_working_time,
--                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.merge_batch_qty    = b.merge_batch_qty,
--                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER.change_id          = @v_proc_name
--          from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER a,
--                 (
--                  select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_resource_id, a.merge_work_order_id
--                         ----------------------------------------------------------------------------------------------------------------
--                         , sum(a.after_qty)        over ( partition by a.coat_merge_work_order_id, a.after_resource_id ) as plan_qty
--                         ----------------------------------------------------------------------------------------------------------------
--                         , sum(a.after_in_qty)     over ( partition by a.coat_merge_work_order_id, a.after_resource_id ) as plan_in_qty
--                         ----------------------------------------------------------------------------------------------------------------
--                         , min(a.after_start_time) over ( partition by a.coat_merge_work_order_id, a.after_resource_id ) as merge_start_time
--                         ----------------------------------------------------------------------------------------------------------------
--                         , max(a.after_end_time)   over ( partition by a.coat_merge_work_order_id, a.after_resource_id ) as merge_end_time
--                         ----------------------------------------------------------------------------------------------------------------
--                         , sum(a.working_time)     over ( partition by a.coat_merge_work_order_id, a.after_resource_id ) as merge_working_time
--                         ----------------------------------------------------------------------------------------------------------------
--                         , sum(a.batch_qty)        over ( partition by a.coat_merge_work_order_id, a.after_resource_id ) as merge_batch_qty
--                         ----------------------------------------------------------------------------------------------------------------
--                  from   (
--                          select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_resource_id, b.coat_work_order_id, b.coat_merge_work_order_id
--                                 , after_qty, a.after_in_qty, a.after_start_time, a.after_end_time, a.working_time, a.batch_qty
--                                 , a.merge_work_order_id
--                          from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER a
--                                 left outer JOIN
--                                     TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP b
--                                 on     1=1
--                                 and    a.master_id              = b.instance_id
--                                 and    a.plan_id                = b.fp_plan_id
--                                 and    a.after_site_id          = b.factory_id
--                                 and    a.after_operation_id     = isnull(b.mix_operation_id, '###')
--                                 and    a.work_order_id          = isnull(b.mix_work_order_id, '###')
--                          where  a.master_id              = @v_master_id
--                          and    a.plan_id                = @v_plan_id
--                          and    a.after_site_id          = @v_factory_id
--                          --and    a.after_operation_id in ( 'E1000' )
--                          and    a.after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )
--                          ) a
--                 ) b
--          where  a.master_id           = b.master_id
--          and    a.plan_id             = b.plan_id
--          and    a.work_order_id       = b.work_order_id
--          and    a.merge_work_order_id = b.merge_work_order_id


            
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

--------------------------------------------------------
--------------------------------------------------------

        /*** TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY INSERT ***/
        -- TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER 의 머지 정보를 반영하여
        -- 임시 버퍼인 TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY 생성

        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY'

          
          DELETE FROM TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
          WHERE   MASTER_ID     = @v_master_id
          AND     PLAN_ID       = @v_plan_id
          and     AFTER_SITE_ID = @v_factory_id
          and     after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null 




            insert TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
            (   MASTER_ID
              , PLAN_ID        , WORK_ORDER_ID        , BEFORE_SITE_ID        , AFTER_SITE_ID        , BEFORE_ROUTE_ID
              , AFTER_ROUTE_ID        , BEFORE_OPERATION_ID        , AFTER_OPERATION_ID        , BEFORE_RESOURCE_ID        , AFTER_RESOURCE_ID
              , BEFORE_PLAN_DATE        , AFTER_PLAN_DATE        , BEFORE_START_TIME        , AFTER_START_TIME        , BEFORE_END_TIME
              , AFTER_END_TIME        , WORKING_TIME        , BEFORE_SEQ        , AFTER_SEQ        , BEFORE_QTY        , AFTER_QTY
              , BEFORE_IN_QTY        , AFTER_IN_QTY        , ITEM_ID        , FIXED_YN        , SPLIT_YN
              , DEMAND_ID        , DEMAND_TYPE        , ORDER_ID        , ORDER_TYPE        , PO_ID
              , MFG_WEEK        , SOP_WEEK        , ORG_WORK_ORDER_ID        , DEMAND_DUE_DATE        , BATCH_ORDER_ID
              , DATE_FIX_FLAG        , DATE_FIX_DATE        , OPERATION_EPST        , OPERATION_LPST        , LANE_QTY
              , LANE_TACT_QTY        , ITEM_UOM        , WO_DAY_SPLIT_YN        , SETUP_TIME        , SETUP_TIME_UOM
              , BATCH_QTY        , UI_EDIT_YN
              , MARKET
              , DESCRIPTION
              , INSERT_ID        , INSERT_TIME               , UPDATE_ID              , UPDATE_TIME
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
                        --,a.after_plan_date
                        ,min(a.after_plan_date) as after_plan_date
                        ,min(a.before_start_time) as before_start_time
                        ,min(a.after_start_time) as after_start_time
                        ,max(a.before_end_time) as before_end_time
                        ,max(a.after_end_time) as after_end_time
                        ,MIN(a.working_time) as working_time
--                        ,a.before_start_time
--                        ,a.after_start_time
--                        ,a.before_end_time
--                        ,a.after_end_time
--                        ,a.working_time
                        ,min(a.before_seq) as before_seq
                        ,min(a.after_seq)  as after_seq
                        ---------------------
                        ,min(a.before_qty) as before_qty
                        ,min(a.after_qty) as after_qty
                        ,min(a.before_in_qty) as before_in_qty
                        ,min(a.after_in_qty) as after_in_qty
--                        ,a.before_qty
--                        ,a.after_qty
--                        ,a.before_in_qty
--                        ,a.after_in_qty
                        ,a.item_id
                        ,min(a.fixed_yn)  as fixed_yn -- max -> min
                        ,min(a.split_yn)  as split_yn 
                        ,min(a.demand_id) as demand_id
                        ,a.demand_type
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
                        ,a.market
                        ,min(a.description)     as description
                        , @v_proc_name as insert_id, getdate() as insert_time
                        , @v_proc_name as update_id, getdate() as update_time
            from        (            
                        select 
                                  master_id
                                , plan_id 
                                , isnull( merge_work_order_id, work_order_id ) as work_order_id
                                , before_site_id,                          after_site_id
                                , before_route_id,                         after_route_id
                                , before_operation_id,                     after_operation_id
                                , before_resource_id,                      after_resource_id
                                , before_plan_date,                        after_plan_date
                                , merge_start_time   as before_start_time, merge_start_time as after_start_time
                                , merge_end_time     as before_end_time,   merge_end_time   as after_end_time
                                , merge_working_time as working_time
                                , before_seq,                              after_seq
                                , merge_plan_qty     as before_qty,        merge_plan_qty    as after_qty
                                , merge_plan_in_qty  as before_in_qty,     merge_plan_in_qty as after_in_qty
                                , item_id
                                --, case when fixed_yn = 'Y' and fix_work_order_id is null then 'N' else fixed_yn end as fixed_yn
                                , fixed_yn
                                , split_yn, demand_id
                                , DEMAND_TYPE --case when demand_type = 'TEST' then 'TEST' else 'MASS' end as demand_type
                                , order_id, order_type, po_id, mfg_week, sop_week
                                , org_work_order_id
                                , demand_due_date
                                , batch_order_id 
                                , date_fix_flag, date_fix_date
                                , operation_epst, operation_lpst
                                , lane_qty, lane_tact_qty
                                , item_uom
                                , wo_day_split_yn, setup_time, setup_time_uom
                                , merge_batch_qty as batch_qty
                                , ui_edit_yn
                                , MARKET
                                , description
                      from th_buf_fp_amend_prod_plan_r_mix_mer
                      where  master_id     = @v_master_id 
                      and    plan_id       = @v_plan_id
                      and    after_site_id = @v_factory_id
                      --and    merge_work_order_id = 'K117421CT0AW@2'
                      and   AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                      and   merge_plan_qty > 0
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
                        --,a.after_plan_date
                        --,a.before_start_time
                        --,a.after_start_time
                        --,a.before_end_time
                        --,a.after_end_time
                        --,a.working_time
                        --,a.before_qty
                        --,a.after_qty
                        --,a.before_in_qty
                        --,a.after_in_qty
                        ,a.item_id
                        ,a.demand_type   
                        ,a.MARKET
            
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END



----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- MIXer
        /*** TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY UPDATE ***/
        -- 전일 Fix  work order 로 Update
        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY'

          update  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
          set     TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.fix_work_order_id  = b.fix_work_order_id,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.fix_batch_order_id = b.fix_batch_order_id,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.change_id          = @v_proc_name
          from    TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY a,
                  (
                  select a.master_id, a.plan_id, a.work_order_id, b.work_order_id as fix_work_order_id,
                         a.after_site_id, a.after_operation_id, a.after_resource_id, a.item_id, a.after_end_time, a.seq, 
                         b.batch_order_id as fix_batch_order_id
                  from   (
                          select master_id, plan_id, work_order_id, after_site_id, after_operation_id, after_resource_id, item_id, after_end_time, fixed_yn, DEMAND_TYPE, MARKET,
                                 dense_rank()  over ( partition by after_site_id, after_operation_id, after_resource_id, item_id , DEMAND_TYPE, MARKET
                                                      order by after_plan_date, after_seq, after_end_time, work_order_id ) as seq
                          from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
                          where  master_id              = @v_master_id
                          and    plan_id                = @v_plan_id
                          and    after_site_id          = @v_factory_id            
                          and    after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                          and    after_qty > 0
                          --and    fixed_yn = 'Y' -- 20170710
--                          union all
--                          select master_id, plan_id, work_order_id, after_site_id, after_operation_id, after_resource_id, item_id, after_end_time, fixed_yn,
--                                 dense_rank()  over ( partition by after_site_id, after_operation_id, after_resource_id, item_id 
--                                                      order by after_plan_date, after_seq, after_end_time, work_order_id ) as seq
--                          from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
--                          where  master_id              = @v_master_id
--                          and    plan_id                = @v_plan_id
--                          and    after_site_id          = @v_factory_id            
--                          and    after_operation_id not in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater / Mixer 이외 공정..!!
--                          and    after_qty > 0
--                          and    fixed_yn = 'Y'
                         ) a
                         inner JOIN
                         (
                          select 
                                 a.fp_plan_id, a.factory_id, a.operation_id, a.equipment_id, a.item_id, a.work_order_id, a.plan_start_time, a.batch_order_id,a.PRODUCTION_TYPE, a.MARKET,
                                 dense_rank()  over ( partition by a.factory_id, a.operation_id, a.equipment_id, a.item_id ,a.PRODUCTION_TYPE, a.MARKET
                                                      order by a.plan_start_time, a.work_order_id ) as seq
                          from   fp_daily_instance_order_status a
                          where  a.instance_id  = @v_master_id
                          and    a.fp_plan_id   = @v_plan_id
                          and    a.factory_id   = @v_factory_id
                          and    a.operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
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
                                                      select distinct --a.instance_id, 
                                                                      a.instance_date, a.release_plan_id, a.amend_plan_id, a.division_id, a.factory_id, a.work_order_id
                                                                    , a.batch_order_id, a.operation_id, a.equipment_id, a.fix_type, a.item_id, a.actual_flag, a.close_flag
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
-- 20170629 Fix pegging시 월경계  로직 변경 ( -- check 부분이 변경분 )                                                                    
--                                                              ----------------------------
--                                                              union all  -- check
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
--                                                              union all -- check
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
--                                                              ----------------------------
--                                                              union all -- check
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
                                                           
                                                            ) a   
                                                  ) b
                                                  where b.work_order_id = a.work_order_id  
                                          )  
                         
                         ) b
                         on      a.after_site_id      = b.factory_id
                         and     a.after_operation_id = b.operation_id
                         and     a.after_resource_id  = b.equipment_id
                         and     a.item_id            = b.item_id
                         and     a.demand_type        = b.PRODUCTION_TYPE -- add
                         and     a.MARKET             = b.MARKET          -- add
                         and     a.seq                = b.seq
                  where  a.master_id              = @v_master_id
                  and    a.plan_id                = @v_plan_id
                  and    a.after_site_id          = @v_factory_id   
                 ) b
          where  a.master_id           = b.master_id
          and    a.plan_id             = b.plan_id
          and    a.work_order_id       = b.work_order_id
          --and    isnull(a.merge_work_order_id, a.work_order_id) = isnull(b.merge_work_order_id, b.work_order_id)


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
                        ,MARKET
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
                        ,sum(a.before_qty) as before_qty
                        ,sum(a.after_qty) as after_qty
                        ,sum(a.before_in_qty) as before_in_qty
                        ,sum(a.after_in_qty) as after_in_qty
--                        ,a.before_qty
--                        ,a.after_qty
--                        ,a.before_in_qty
--                        ,a.after_in_qty
                        ,min(a.item_id)   as item_id
                        ,min(a.fixed_yn)  as fixed_yn -- max -> min
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
                        ,min(a.description)     as description
                        , @v_proc_name as insert_id, getdate() as insert_time
                        , @v_proc_name as update_id, getdate() as update_time
            from        (            
                        select 
                                    master_id,plan_id 
                                    ,case when -- fixed_yn = 'Y'  and 
                                               fix_work_order_id is not null
                                          then substring(isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) ), 1, 12 )
                                          else isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) )
                                          end as  work_order_id
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
                                    ,case when -- fixed_yn = 'Y' and 
                                               fix_work_order_id is null then 'N' else 'Y' end as fixed_yn
                                    ,split_yn,demand_id,demand_type,order_id,order_type,po_id,mfg_week,sop_week
                                    ,org_work_order_id
                                    ,demand_due_date
                                    , min(case when -- fixed_yn = 'Y'  and 
                                                    fix_work_order_id is not null then fix_batch_order_id else batch_order_id end ) 
                                      over ( partition by case when -- fixed_yn = 'Y'  and 
                                                                    fix_work_order_id is not null
                                                               then substring(isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) ), 1, 12 )
                                                               else isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) )
                                                          end 
                                             order by after_seq ) as batch_order_id
--                                    ,case when fixed_yn = 'Y'  and fix_work_order_id is not null
--                                          then fix_batch_order_id
--                                          else batch_order_id
--                                          end as batch_order_id
                                    ,date_fix_flag,date_fix_date
                                    ,operation_epst
                                    ,operation_lpst,lane_qty,lane_tact_qty,item_uom
                                    ,wo_day_split_yn,setup_time,setup_time_uom
                                    ,batch_qty
                                    ,ui_edit_yn
                                    ,market
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
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
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

--
---- CN_E_PRE 임시처리
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


  --  end



--------------------------------------------------------
--------------------------------------------------------

    ---------------------------
    -- MIX Merge 생성분을 MAP 테이블에 반영키위해 Final buf table 생성
    ---------------------------
        BEGIN
        
          SET @v_table_name = 'TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F'
          
          DELETE FROM TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F
          WHERE   INSTANCE_ID   = @v_master_id
          AND     FP_PLAN_ID    = @v_plan_id
          and     FACTORY_ID    = @v_factory_id

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F', 'DELETE', @n_log_count, null, @v_message, null 


          insert into TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F
                 (
                  INSTANCE_ID ,FP_PLAN_ID ,FACTORY_ID ,DEMAND_ID ,COAT_WORK_ORDER_ID ,COAT_SUB_WORK_ORDER_ID ,COAT_OPERATION_ID ,EX_ORD_COAT_QTY, COAT_ITEM_ID ,COAT_WORK_CNT
                  ,CALC_COAT_QTY ,COAT_MER_COATQTY ,COAT_PLAN_DATE ,COAT_MERGE_WORK_ORDER_ID ,COAT_SUB_MERGE_WORK_ORDER_ID ,COAT_FIX_WORK_ORDER_ID
                  ,COAT_FIXED_YN ,COAT_DEMAND_TYPE ,MIX_WORK_ORDER_ID ,MIX_OPERATION_ID ,EX_ORD_MIX_QTY, MIX_ITEM_ID ,COAT_MER_MIXQTY
                  ,MIX_PLAN_DATE ,MIX_MERGE_WORK_ORDER_ID ,INSERT_ID ,INSERT_TIME                 
                  )
          select 
                  INSTANCE_ID ,FP_PLAN_ID ,FACTORY_ID ,DEMAND_ID ,COAT_WORK_ORDER_ID ,COAT_SUB_WORK_ORDER_ID ,COAT_OPERATION_ID ,EX_ORD_COAT_QTY, COAT_ITEM_ID ,COAT_WORK_CNT
                  ,CALC_COAT_QTY ,COAT_MER_COATQTY ,COAT_PLAN_DATE ,COAT_MERGE_WORK_ORDER_ID ,COAT_SUB_MERGE_WORK_ORDER_ID ,COAT_FIX_WORK_ORDER_ID
                  ,COAT_FIXED_YN ,COAT_DEMAND_TYPE ,MIX_WORK_ORDER_ID ,MIX_OPERATION_ID ,EX_ORD_MIX_QTY, MIX_ITEM_ID ,COAT_MER_MIXQTY
                  ,MIX_PLAN_DATE ,MIX_MERGE_WORK_ORDER_ID ,INSERT_ID ,INSERT_TIME                 
          from    TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP
          WHERE   INSTANCE_ID   = @v_master_id
          AND     FP_PLAN_ID    = @v_plan_id
          and     FACTORY_ID    = @v_factory_id
          
          SET @v_message = @@ROWCOUNT
          SET @v_table_name = 'TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F'
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END           



        /*** TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F UPDATE ***/
        -- merge_work_order_id Update
        BEGIN
         
          SET @v_table_name = 'TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F'

          update TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F
          set     TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F.MIX_MERGE_WORK_ORDER_ID = b.merge_work_order_id
                 ,TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F.COAT_MER_MIXQTY         = b.merge_plan_qty
                -- ,TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F.MIX_PLAN_DATE           = b.after_plan_date
          from   TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F a,
                 (
--                  select a.master_id, a.plan_id, a.work_order_id, a.after_site_id, a.after_operation_id
--                         --, a.merge_work_order_id
--                         ,case when a.fixed_yn = 'Y'  and a.fix_work_order_id is not null
--                               then substring(isnull( a.fix_work_order_id, isnull( a.merge_work_order_id, a.work_order_id ) ), 1, 12 )
--                               else isnull( a.fix_work_order_id, isnull( a.merge_work_order_id, a.work_order_id ) )
--                          end as  merge_work_order_id                         
--                         , a.merge_plan_qty, a.after_plan_date
--                  from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER a 
--                  where  a.master_id              = @v_master_id
--                  and    a.plan_id                = @v_plan_id
--                  and    a.after_site_id          = @v_factory_id
--                  and    a.after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )
                  select a.master_id, a.plan_id, a.work_order_id, a.fix_work_order_id, a.after_site_id, a.after_operation_id
                         , a.merge_plan_qty, a.after_plan_date
                         --, a.merge_work_order_id     
                         , case when -- b.fixed_yn = 'Y'  and 
                                     b.fix_work_order_id is not null
                               then substring(isnull( b.fix_work_order_id, isnull( a.merge_work_order_id, a.work_order_id ) ), 1, 12 )
                               else isnull( a.fix_work_order_id, isnull( a.merge_work_order_id, a.work_order_id ) )
                          end as  merge_work_order_id
                  from   ( 
                          select a.master_id, a.plan_id, a.work_order_id, a.fix_work_order_id, a.after_site_id, a.after_operation_id
                                 , a.merge_plan_qty, a.after_plan_date
                                 , a.mix_sub_merge_work_order_id
                                 , a.merge_work_order_id
                          from   (       
                                  select a.master_id, a.plan_id, a.work_order_id, a.fix_work_order_id, a.after_site_id, a.after_operation_id
                                         --, a.merge_work_order_id
                                         , a.merge_plan_qty, a.after_plan_date
                                         , case when charindex( '@', a.merge_work_order_id, 0 ) > 0 
                                                then substring( a.merge_work_order_id, 1, charindex( '@', a.merge_work_order_id, 0 )-1)
                                                else a.merge_work_order_id 
                                           end as mix_sub_merge_work_order_id
                                         , a.merge_work_order_id
                                  from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER a 
                                  where  a.master_id              = @v_master_id
                                  and    a.plan_id                = @v_plan_id
                                  and    a.after_site_id          = @v_factory_id--'E5'
                                  and    a.after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )
                                 ) a 
                         ) a
                         left outer join
                             (
                              select *
                              from   TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY a 
                              where  a.master_id              = @v_master_id
                              and    a.plan_id                = @v_plan_id
                              and    a.after_site_id          = @v_factory_id--'E5'
                              and    a.after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )
                             ) b
                         on  a.master_id          = b.master_id
                         and a.plan_id            = b.plan_id
                         and a.after_site_id      = b.after_site_id
                         and a.after_operation_id = b.after_operation_id
                         --where  isnull(a.mix_sub_merge_work_order_id, a.merge_work_order_id) = isnull(b.fix_work_order_id, b.work_order_id)
                         where  isnull(a.mix_sub_merge_work_order_id, a.merge_work_order_id) = case when charindex('@', b.work_order_id) = 0 then b.work_order_id
                                                                                                    else substring(b.work_order_id, 1, charindex('@', b.work_order_id)-1)
                                                                                               end
                 ) b
          where  a.instance_id          = b.master_id
          and    a.fp_plan_id           = b.plan_id
          and    a.factory_id           = b.after_site_id
          and    a.mix_operation_id     = b.after_operation_id
          and    a.mix_work_order_id    = b.work_order_id
          and    a.instance_id          = @v_master_id
          and    a.fp_plan_id           = @v_plan_id
          and    a.factory_id           = @v_factory_id
          and    a.mix_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )


            
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

-- FP_ORDER_PEGGING_R Delete / Insert start

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
              select a.instance_id, a.fp_plan_id
                     , a.company_id, a.division_id, a.site_id, a.plant_id
                     , a.from_work_order_id
                     , a.from_stock_set_id
                     , a.to_work_order_id
                     , a.from_factory_id
                     , a.to_factory_id
                     , a.from_operation_id
                     , a.to_operation_id
                     , sum(a.from_qty)     as from_qty
                     , sum(a.to_qty)       as to_qty
                     --, a.from_item_id
                     , MIN(a.from_item_id) as from_item_id
                     , a.to_item_id
                     , '-'                      AS DEMAND_ID
                     , @v_proc_name             AS INSERT_ID
                     , GETDATE()                AS INSERT_TIME       
              from   (       
                      select a.instance_id, a.fp_plan_id
                             , b.company_id, b.division_id, b.site_id, b.plant_id
                             , isnull(a.mix_merge_work_order_id, '-')  as from_work_order_id
                             , '-'                                     as from_stock_set_id
                             --, isnull(a.coat_merge_work_order_id, '-') as to_work_order_id
                             , case when -- a.coat_FIXED_YN = 'Y'  and 
                                         a.coat_fix_work_order_id is not null
                                    then substring(isnull( a.coat_fix_work_order_id, isnull( a.coat_merge_work_order_id, a.coat_work_order_id ) ), 1, 12 )
                                    else isnull( a.coat_fix_work_order_id, isnull( a.coat_merge_work_order_id, a.coat_work_order_id ) )
                               end as  to_work_order_id                         
                             , a.factory_id                    as from_factory_id
                             , a.factory_id                    as to_factory_id
                             , isnull(a.mix_operation_id, '-') as from_operation_id
                             , a.coat_operation_id             as to_operation_id
                             , a.coat_mer_mixqty          as from_qty
                             , a.calc_coat_qty            as to_qty
                             , a.mix_item_id              as from_item_id
                             , a.coat_item_id             as to_item_id
                      from   (
                              select * from TH_BUF_COAT_MIX_WORK_ORDER_MERGE_MAP_F a
                              where  a.instance_id              = @v_master_id
                              and    a.fp_plan_id               = @v_plan_id
                              and    a.factory_id               = @v_factory_id
                              and    a.coat_operation_id        in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6) -- 'E2000'          
                              ) a
                             left OUTER join
                                     (
                                      select * 
                                      from   scm_factory_m
                                      where  factory_id = @v_factory_id
                                     ) b
                             on    a.factory_id = b.factory_id
                    ) a
              group by a.instance_id, a.fp_plan_id
                     , a.company_id, a.division_id, a.site_id, a.plant_id
                     , a.from_work_order_id
                     , a.from_stock_set_id
                     , a.to_work_order_id
                     , a.from_factory_id
                     , a.to_factory_id
                     , a.from_operation_id
                     , a.to_operation_id
                     --, a.from_item_id
                     , a.to_item_id

              
              SET @v_message = @@ROWCOUNT
              SET @v_table_name = 'FP_ORDER_PEGGING_R'
              SET @n_log_count = @n_log_count + 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
              
            END      
              
          end  


-- FP_ORDER_PEGGING_R Delete / Insert end

------------------------------------------------------------------------------------------------------
-- FROM_WORK_ORDER_ID 누락건을 추가로 찾아 Update 한다
------------------------------------------------------------------------------------------------------

        if @v_master_id = 'KR_E_PRE_A' or
           @v_master_id = 'KR_E_PRE_M' or
           @v_master_id = 'US_E_PRE'   or
           @v_master_id = 'CN_E_PRE'
           begin

                update FP_ORDER_PEGGING_R
                set     FP_ORDER_PEGGING_R.FROM_WORK_ORDER_ID = b.from_work_order_id,
                        FP_ORDER_PEGGING_R.FROM_factory_ID    = b.from_factory_id,
                        FP_ORDER_PEGGING_R.FROM_operation_id  = b.from_operation_id,
                        FP_ORDER_PEGGING_R.FROM_qty           = b.from_qty,
                        FP_ORDER_PEGGING_R.FROM_item_id       = b.from_item_id,
                        FP_ORDER_PEGGING_R.insert_id          = 'ADD_WORK_ORDER'
                --select b.*        
                from   FP_ORDER_PEGGING_R a,
                        (
                        select a.instance_id, a.fp_plan_id, a.to_factory_id, a.to_operation_id, a.to_work_order_id,
                                a.PLAN_ORDER_ID, a.demand_id, a.item_id,
                                a.ORDER_ID,
                                a.from_factory_id, a.from_operation_id, a.from_qty, a.out_item_id,
                                b.from_item_id, b.from_work_order_id
                        from   (        
                                select a.instance_id, a.fp_plan_id, a.to_factory_id, a.to_operation_id, a.to_work_order_id,
                                        a.PLAN_ORDER_ID, a.demand_id, a.item_id,
                                        b.ORDER_ID,
                                        b.from_factory_id, b.from_operation_id, b.from_qty, b.out_item_id
                                from   (        
                                        select a.instance_id, a.fp_plan_id, a.to_factory_id, a.to_operation_id, a.to_work_order_id,
                                                b.PLAN_ORDER_ID, b.demand_id, b.item_id
                                        from   (
                                                select distinct a.instance_id, a.fp_plan_id, a.to_factory_id, a.to_operation_id, a.to_work_order_id
                                                from   FP_ORDER_PEGGING_R a
                                                where  a.instance_id     = @v_master_id
                                                and    a.fp_plan_id      = @v_plan_id
                                                and    a.to_factory_id   = @v_factory_id
                                                and    a.to_operation_id = 'E2000'
                                                and    ( a.from_work_order_id  = '-' and a.to_work_order_id is not null )
                                               ) a,
                                               (
                                                SELECT  a.MASTER_ID, a.PLAN_ID, a.PLAN_ORDER_ID, a.demand_id, a.item_id
                                                --FROM    LGCE_FPDEV.dbo.TH_EXP_PLANORDER a
                                                FROM   (
                                                        select * from   kr_e_pre_a.dbo.TH_EXP_PLANORDER union all
                                                        select * from   kr_e_pre_m.dbo.TH_EXP_PLANORDER union all
                                                        select * from     us_e_pre.dbo.TH_EXP_PLANORDER union all
                                                        select * from     cn_e_pre.dbo.TH_EXP_PLANORDER
                                                       ) a
                                                WHERE   1=1
                                                AND     a.MASTER_ID         = @v_master_id
                                                AND     a.PLAN_ID           = @v_plan_id
                                                --AND     a.PLAN_ORDER_ID LIKE 'K117517CT057%'
                                               ) b
                                        where a.instance_id = b.MASTER_ID
                                        and   fp_plan_id    = b.PLAN_ID
                                        and   charindex(  a.to_work_order_id, b.PLAN_ORDER_ID ) > 0
                                        ) a
                                        inner join
                                        (
                                            SELECT  DISTINCT a.MASTER_ID, a.PLAN_ID
                                                             , left(a.site_id, 2) as from_factory_id
                                                             , a.operation_id     as from_operation_id
                                                             , a.resource_id
                                                             , a.out_item_id
                                                             , a.complete_qty     as from_qty
                                                             , a.ORDER_ID
                                                             , a.DEMAND_ID
                                            --FROM    LGCE_FPDEV.DBO.TH_OUT_ORDER_TRACKING
                                            FROM   (
                                                      select * from   kr_e_pre_a.dbo.TH_OUT_ORDER_TRACKING union all
                                                      select * from   kr_e_pre_m.dbo.TH_OUT_ORDER_TRACKING union all
                                                      select * from     us_e_pre.dbo.TH_OUT_ORDER_TRACKING union all
                                                      select * from     cn_e_pre.dbo.TH_OUT_ORDER_TRACKING
                                                   ) a
                                            WHERE   1=1
                                            AND     a.MASTER_ID    = @v_master_id
                                            AND     a.PLAN_ID      = @v_plan_id
                                            AND     a.OPERATION_ID = 'E1000'
                                            --AND     DEMAND_ID    = 'APCAN0186A^20170605^G182^A011^MASS^MCF406376B10::FIX001'        
                                        ) b
                                        on  a.instance_id = b.MASTER_ID
                                        and a.fp_plan_id  = b.PLAN_ID
                                        and a.demand_id   = b.demand_id
                                ) a 
                                inner join
                                (
                                    SELECT  a.master_id, a.plan_id, a.order_id, a.item_id as from_item_id, a.PLAN_ORDER_ID as from_work_order_id
                                    --FROM    LGCE_FPDEV.DBO.TH_EXP_PLANORDER
                                    FROM   (
                                            select * from   kr_e_pre_a.dbo.TH_EXP_PLANORDER union all
                                            select * from   kr_e_pre_m.dbo.TH_EXP_PLANORDER union all
                                            select * from     us_e_pre.dbo.TH_EXP_PLANORDER union all
                                            select * from     cn_e_pre.dbo.TH_EXP_PLANORDER
                                           ) a
                                    WHERE   1=1
                                    AND     a.MASTER_ID = @v_master_id
                                    AND     a.PLAN_ID   = @v_plan_id
                                    --AND     ORDER_ID = 'WO##20170525_0000001336_NORMAL'
                                ) b
                                on  a.instance_id = b.MASTER_ID
                                and a.fp_plan_id  = b.PLAN_ID
                                and a.ORDER_ID    = b.order_id
                       ) b
                where  a.instance_id         = b.instance_id
                and    a.fp_plan_id          = b.fp_plan_id
                and    a.to_factory_id       = b.to_factory_id
                and    a.to_work_order_id    = b.to_work_order_id
                and    a.from_work_order_id  = '-'
                and    a.instance_id     = @v_master_id
                and    a.fp_plan_id      = @v_plan_id
                and    a.to_factory_id   = @v_factory_id
                and    a.to_operation_id = 'E2000'
                and    not EXISTS ( 
                                    select 1
                                    from   FP_ORDER_PEGGING_R
                                    where  instance_id     = @v_master_id
                                    and    fp_plan_id      = @v_plan_id
                                    and    to_factory_id   = @v_factory_id
                                    and    to_operation_id = 'E2000'
                                    and    from_work_order_id  != '-'
                                    and    from_work_order_id = b.from_work_order_id 
                                    and    to_work_order_id   = b.to_work_order_id
                                  ) 
           end
        else if @v_master_id = 'KR_SRS'     
           begin
                update FP_ORDER_PEGGING_R
                set     FP_ORDER_PEGGING_R.FROM_WORK_ORDER_ID = b.from_work_order_id,
                        FP_ORDER_PEGGING_R.FROM_factory_ID    = b.from_factory_id,
                        FP_ORDER_PEGGING_R.FROM_operation_id  = b.from_operation_id,
                        FP_ORDER_PEGGING_R.FROM_qty           = b.from_qty,
                        FP_ORDER_PEGGING_R.FROM_item_id       = b.from_item_id,
                        FP_ORDER_PEGGING_R.insert_id          = 'ADD_WORK_ORDER'
                --select b.*        
                from   FP_ORDER_PEGGING_R a,
                        (
                        select a.instance_id, a.fp_plan_id, a.to_factory_id, a.to_operation_id, a.to_work_order_id,
                                a.PLAN_ORDER_ID, a.demand_id, a.item_id,
                                a.ORDER_ID,
                                a.from_factory_id, a.from_operation_id, a.from_qty, a.out_item_id,
                                b.from_item_id, b.from_work_order_id
                        from   (        
                                select a.instance_id, a.fp_plan_id, a.to_factory_id, a.to_operation_id, a.to_work_order_id,
                                        a.PLAN_ORDER_ID, a.demand_id, a.item_id,
                                        b.ORDER_ID,
                                        b.from_factory_id, b.from_operation_id, b.from_qty, b.out_item_id
                                from   (        
                                        select a.instance_id, a.fp_plan_id, a.to_factory_id, a.to_operation_id, a.to_work_order_id,
                                                b.PLAN_ORDER_ID, b.demand_id, b.item_id
                                        from   (
                                                select distinct a.instance_id, a.fp_plan_id, a.to_factory_id, a.to_operation_id, a.to_work_order_id
                                                from   FP_ORDER_PEGGING_R a
                                                where  a.instance_id     = @v_master_id
                                                and    a.fp_plan_id      = @v_plan_id
                                                and    a.to_factory_id   = @v_factory_id
                                                and    a.to_operation_id = 'S2000'
                                                and    ( a.from_work_order_id  = '-' and a.to_work_order_id is not null )
                                               ) a,
                                               (
                                                SELECT  a.MASTER_ID, a.PLAN_ID, a.PLAN_ORDER_ID, a.demand_id, a.item_id
                                                --FROM    LGCE_FPDEV.dbo.TH_EXP_PLANORDER a
                                                FROM    KR_SRS.dbo.TH_EXP_PLANORDER a
                                                WHERE   1=1
                                                AND     a.MASTER_ID         = @v_master_id
                                                AND     a.PLAN_ID           = @v_plan_id
                                                --AND     a.PLAN_ORDER_ID LIKE 'K117517CT057%'
                                               ) b
                                        where a.instance_id = b.MASTER_ID
                                        and   fp_plan_id    = b.PLAN_ID
                                        and   charindex(  a.to_work_order_id, b.PLAN_ORDER_ID ) > 0
                                        ) a
                                        inner join
                                        (
                                            SELECT  DISTINCT a.MASTER_ID, a.PLAN_ID
                                                             , left(a.site_id, 2) as from_factory_id
                                                             , a.operation_id     as from_operation_id
                                                             , a.resource_id
                                                             , a.out_item_id
                                                             , a.complete_qty     as from_qty
                                                             , a.ORDER_ID
                                                             , a.DEMAND_ID
                                            --FROM    LGCE_FPDEV.DBO.TH_OUT_ORDER_TRACKING
                                            FROM    KR_SRS.DBO.TH_OUT_ORDER_TRACKING a
                                            WHERE   1=1
                                            AND     a.MASTER_ID    = @v_master_id
                                            AND     a.PLAN_ID      = @v_plan_id
                                            AND     a.OPERATION_ID = 'S1000'
                                            --AND     DEMAND_ID    = 'APCAN0186A^20170605^G182^A011^MASS^MCF406376B10::FIX001'        
                                        ) b
                                        on  a.instance_id = b.MASTER_ID
                                        and a.fp_plan_id  = b.PLAN_ID
                                        and a.demand_id   = b.demand_id
                                ) a 
                                inner join
                                (
                                    SELECT  a.master_id, a.plan_id, a.order_id, a.item_id as from_item_id, a.PLAN_ORDER_ID as from_work_order_id
                                    --FROM    LGCE_FPDEV.DBO.TH_EXP_PLANORDER
                                    FROM    KR_SRS.DBO.TH_EXP_PLANORDER a
                                    WHERE   1=1
                                    AND     a.MASTER_ID = @v_master_id
                                    AND     a.PLAN_ID   = @v_plan_id
                                    --AND     ORDER_ID = 'WO##20170525_0000001336_NORMAL'
                                ) b
                                on  a.instance_id = b.MASTER_ID
                                and a.fp_plan_id  = b.PLAN_ID
                                and a.ORDER_ID    = b.order_id
                       ) b
                where  a.instance_id         = b.instance_id
                and    a.fp_plan_id          = b.fp_plan_id
                and    a.to_factory_id       = b.to_factory_id
                and    a.to_work_order_id    = b.to_work_order_id
                and    a.from_work_order_id  = '-'
                and    a.instance_id     = @v_master_id
                and    a.fp_plan_id      = @v_plan_id
                and    a.to_factory_id   = @v_factory_id
                and    a.to_operation_id = 'S2000'
                and    not EXISTS ( 
                                    select 1
                                    from   FP_ORDER_PEGGING_R
                                    where  instance_id     = @v_master_id
                                    and    fp_plan_id      = @v_plan_id
                                    and    to_factory_id   = @v_factory_id
                                    and    to_operation_id = 'S2000'
                                    and    from_work_order_id  != '-'
                                    and    from_work_order_id = b.from_work_order_id 
                                    and    to_work_order_id   = b.to_work_order_id
                                  ) 
           
           end
        --else if @v_master_id = 'KR_PACK'    
        --else if @v_master_id = 'CN_PACK'   
        --else if @v_master_id = 'US_PACK'
        --else
        --   begin
        --   end

        if @v_master_id = 'KR_E_PRE_A' or
           @v_master_id = 'KR_E_PRE_M' or
           @v_master_id = 'US_E_PRE'   or
           @v_master_id = 'CN_E_PRE'   or
           @v_master_id = 'KR_SRS'     
           begin

              update fp_order_pegging_r
              set    fp_order_pegging_r.from_work_order_id = b.mix_merge_work_order_id
              --select a.*
              from   fp_order_pegging_r a,
                     th_buf_coat_mix_work_order_merge_map_f b
              where  a.instance_id        = @v_master_id
              and    a.fp_plan_id         = @v_plan_id
              and    a.to_factory_id      = @v_factory_id
              and    a.insert_id          = 'ADD_WORK_ORDER'
              and    a.instance_id        = b.instance_id
              and    a.fp_plan_id         = b.fp_plan_id
              and    a.to_factory_id      = b.factory_id
              and    a.from_work_order_id = b.mix_work_order_id
              and    b.mix_work_order_id != b.mix_merge_work_order_id
              and    not exists (
                                  select 1
                                  from   fp_order_pegging_r x
                                  where  x.instance_id        = a.instance_id
                                  and    x.fp_plan_id         = a.fp_plan_id
                                  and    x.to_factory_id      = a.to_factory_id
                                  and    x.from_work_order_id = b.mix_merge_work_order_id
                                  and    x.to_work_order_id   = a.to_work_order_id
                                )

              SET @v_message = @@ROWCOUNT
              SET @n_log_count += 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'fp_order_pegging_r ADD_WORK_ORDER', 'UPDATE', @n_log_count, null, @v_message, null 

           end

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

     
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

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
