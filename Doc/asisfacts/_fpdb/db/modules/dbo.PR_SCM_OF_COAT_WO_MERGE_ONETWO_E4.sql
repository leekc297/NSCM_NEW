CREATE PROCEDURE [dbo].[PR_SCM_OF_COAT_WO_MERGE_ONETWO_E4]
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_OF_COAT_WO_MERGE_ONETWO_E4'
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
           , @key_date = CONVERT(NVARCHAR, PLAN_START_TIME, 112)
           , @v_plan_date = CONVERT(DATE,     PLAN_START_TIME, 112)                           -- Pmix 소요량 생성용
           , @n_day_diff  = DATEDIFF(MINUTE, CONVERT(DATE, PLAN_START_TIME), PLAN_START_TIME) -- Pmix 소요량 생성용
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
--          else if @v_master_id = 'KR_E_PMIX'     
--              begin 
--                set @v_wo_id_merge_op1 = 'E0500'
--                set @v_wo_id_merge_op2 = '00000'
--                set @v_wo_id_merge_op3 = '00000'
--                set @v_wo_id_merge_op4 = '00000'
--                set @v_wo_id_merge_op5 = '00000'
--                set @v_wo_id_merge_op6 = '00000'
--                set @v_batch_id_merge_op1 = 'E0500'
--                set @v_batch_id_merge_op2 = '00000'
--                set @v_batch_id_merge_op3 = '00000'
--                set @v_batch_id_merge_op4 = '00000'
--                set @v_batch_id_merge_op5 = '00000'
--                set @v_batch_id_merge_op6 = '00000'
--              end      
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
                        ,MIN(a.fixed_yn)  as fixed_yn  -- MAX -> MIN
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
                          -- and    fixed_yn = 'Y' -- 20170710
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
                          -- and    fixed_yn = 'Y' -- 20170710
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
                        ,MIN(a.fixed_yn)  as fixed_yn -- MAX -> min
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
                        ,item_id,demand_id,demand_type,market
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
                                      from    (        
                                              select 
                                                      master_id,plan_id,work_order_id,before_site_id,after_site_id,before_route_id,after_route_id,before_operation_id
                                                      ,after_operation_id,before_resource_id,after_resource_id,before_plan_date,after_plan_date,before_start_time
                                                      ,after_start_time,before_end_time,after_end_time,working_time,before_seq,after_seq,before_qty,after_qty,before_in_qty
                                                      ,after_in_qty,item_id,fixed_yn,split_yn,demand_id,demand_type,order_id,order_type,po_id,mfg_week,sop_week,org_work_order_id
                                                      ,demand_due_date,batch_order_id,date_fix_flag,date_fix_date,operation_epst,operation_lpst,lane_qty,lane_tact_qty,item_uom
                                                      ,wo_day_split_yn,setup_time,setup_time_uom,batch_qty,ui_edit_yn,market, description,insert_id,insert_time,update_id,update_time
                                              from   fp_amend_production_plan_r --TH_BUF_FP_AMEND_PROD_PLAN_R_COAT_MER
                                              where  master_id      = @v_master_id
                                              and    plan_id        = @v_plan_id
                                              and    after_site_id  = @v_factory_id
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
                                                      select distinct --a.parent_item_id,
                                                                      case when charindex('_', a.parent_item_id) = 0 
                                                                           then a.parent_item_id
                                                                           else substring(a.parent_item_id, 1, charindex('_', a.parent_item_id)-1)
                                                                      end  as parent_item_id
                                                                    --, a.child_item_id
                                                                    , case when charindex('_', a.child_item_id) = 0 
                                                                           then a.child_item_id
                                                                           else substring(a.child_item_id, 1, charindex('_', a.child_item_id)-1)
                                                                      end  as child_item_id
                                                                    , a.alt_priority, a.parent_item_rate, a.child_item_rate, a.route_id
        --                                              from   lgce_fpdev.dbo.th_eng_plan_bom a
                                                      from   (
                                                              select * from   kr_e_pre_a.dbo.th_eng_plan_bom where master_id = @v_master_id union all
                                                              select * from   kr_e_pre_m.dbo.th_eng_plan_bom where master_id = @v_master_id union all
                                                              select * from     us_e_pre.dbo.th_eng_plan_bom where master_id = @v_master_id union all
                                                              select * from     cn_e_pre.dbo.th_eng_plan_bom where master_id = @v_master_id union all
                                                              select * from       kr_srs.dbo.th_eng_plan_bom where master_id = @v_master_id 
                                                             ) a
                                                      where  a.master_id    = @v_master_id
                                                      and    a.plan_id      = @v_plan_id
                                                      and    a.operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater  공정..!!
                                                      --and    isnull(a.alt_priority, 1) = 1 -- alt_priority = 1인 것으로 선택
                                                      --and a.parent_item_id like 'APCCA0345A%'
                                                      and case when charindex('_', a.child_item_id) = 0 
                                                          then a.child_item_id
                                                          else substring(a.child_item_id, 1, charindex('_', a.child_item_id)-1)
                                                          end  in ( 
                                                                    select item_id
                                                                           --factory_id, item_id, operation_id, line_id as route_id, month, priority as alt_priority, active_flag 
                                                                    from   SCM_ITEM_LINE_ASSIGN_M
                                                                    where  factory_id   = @v_factory_id
                                                                    and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                                                    and    month        = @v_plan_month --'201707'
                                                                    and    active_flag  = 'Y'
                                                                    --and item_id = 'ASLAN0823A'
                                                                    and    priority in ( 1, 2, 3, 4, 5, 6, 7, 8 ) -- 미사용 Flag인것은 할당 제외 (0, 9,null)
                                                                    -----------------------------------------
                                                                    -----------------------------------------
                                                                    -- EXCEPT 기간에 속한 기종은 할당 제외 ( 20170726 ksjeon )
                                                                    -- 20170817 MODIFIED Yang 2376line으로 이동
--                                                                    and    item_id not in ( select item_id 
--                                                                                            from   SCM_ITEM_LINE_ASSIGN_EXCEPT_M
--                                                                                            where  1=1
--                                                                                            --and   item_id in ( 'ASLCA0102A', 'ASLCA0126A' )
--                                                                                            and    active_flag = 'N'
--                                                                                            and    @plan_start_time between start_time and end_time
--                                                                                            )
                                                                    -----------------------------------------
                                                                    -----------------------------------------
                                                                  )  
                                                      and    exists  (
                                                                      select 1 -- 자재 코드가 아닌것
                                                                      --from   lgce_fpdev.dbo.th_eng_item b
                                                                      from   (
                                                                              select * from   kr_e_pre_a.dbo.th_eng_item where master_id = @v_master_id union all
                                                                              select * from   kr_e_pre_m.dbo.th_eng_item where master_id = @v_master_id union all
                                                                              select * from     us_e_pre.dbo.th_eng_item where master_id = @v_master_id union all
                                                                              select * from     cn_e_pre.dbo.th_eng_item where master_id = @v_master_id union all
                                                                              select * from       kr_srs.dbo.th_eng_item where master_id = @v_master_id                                  
                                                                             ) b
                                                                      where  b.master_id = a.master_id 
                                                                      and    b.plan_id   = a.plan_id 
                                                                      and    b.item_id   = a.child_item_id 
                                                                      and    b.flow_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                                                      --and    b.item_type != 'R'
                                                                      --and    b.flow_id in ( 'E1000', 'S1000' )
                                                                      and substring(b.item_id, 1, 5) in ( SELECT  level_3_code
                                                                                                          FROM    SCM_ITEM_CLASS_M
                                                                                                          WHERE   1=1
                                                                                                          --and level_3_name = 'SRS Pancake'
                                                                                                          AND     LEVEL_2_NAME LIKE 'Slurry'
                                                                                                          and    class_id not in ( 'ES01', 'ES0101' ) -- 선분산 제외 
                                                                                                         )   
                                                                     )  
                                                      and    charindex('STOCK', a.child_item_id) = 0
                                                      and    charindex('^^',    a.route_id)      = 0
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
                                    where  factory_id   = @v_factory_id
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
                      ,item_id,FIXED_YN,demand_id,demand_type,market
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
                       +  
                       c.order_id as work_order_id
                     , a.work_order_id as attb1
                     , a.after_site_id, a.after_route_id, a.after_operation_id
                     , a.RESOURCE_ID as after_resource_id
                     , a.after_plan_date, a.after_start_time, a.after_end_time
                     , ceiling(a.final_after_in_qty * isnull(b.E1000_YIELD, 1) ) as after_qty 
                     , a.final_after_in_qty                          as after_in_qty 
                     , a.item_id
                     , a.fixed_yn, a.demand_id , a.demand_type, a.market
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
                              , a.fixed_yn, a.demand_id, a.demand_type, a.market
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
                                      , a.fixed_yn, a.demand_id, a.demand_type, a.market
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
                                              , a.fixed_yn, a.demand_id, a.demand_type, a.market
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
                                                      , a.fixed_yn, a.demand_id, a.demand_type, a.market
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
                                                              , a.fixed_yn, a.demand_id, a.demand_type, a.market
                                                              , a.e2000_start_time, a.e2000_end_time, a.e2000_plan_date, a.e2000_item_id, a.e2000_org_qty, a.org_qty
                                                              --,a.r,a.acu_org_qty,a.stock_qty,a.remain_qty
                                                             -----------------------------------------------------------------
                                                             , isnull(b.batch_lot_size, 1)  as batch_lot_size
                                                             , isnull(b.tat, 1)             as tat
                                                      FROM   TH_BUF_E1000_PLAN_TARGET a
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
                                                      --and e2000_work_order_id = 'WK117604CT2BP'
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
                                                      , a.fixed_yn, a.demand_id, a.demand_type, a.market
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
                                                              , a.fixed_yn, a.demand_id, a.demand_type, a.market
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
                          where  factory_id   = @v_factory_id
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
                      ,after_in_qty,item_id,fixed_yn,split_yn,demand_id,demand_type,market, order_id,order_type,po_id,mfg_week,sop_week,org_work_order_id
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
                              , a.order_id, a.order_type, a.po_id, a.mfg_week, a.sop_week
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
                          --    and a.work_order_id in (  'WK117604MX0MJ',  'WK117604MXZMJ' )
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
--    ---------------------------
--    -- Merge 작업 후 batch_order_id 재 채번
--    -- 공정은 Instance 별 상이함
--    ---------------------------
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


--
--
--    ---------------------------
--    -- Batch work_order_id 생성
--    -- MASTER_ID, PLAN_ID, AFTER_PLAN_DATE, AFTER_SITE_ID, AFTER_OPERATION_ID, AFTER_ROUTE_ID, AFTER_RESOURCE_ID 별
--    -- 동일 Batch_id 가 연속인 건이 머지 대상
--    -- operation_id  = 'E1000'
--    ---------------------------
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
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_INSTANCE_CONFIG_M', 'SELECT', @@ROWCOUNT, null, 'RESULT_TRANSFER', null

          IF @v_to_instance_key = 'CONSUME_DEMAND' 
            BEGIN
            
              DELETE FROM FP_DAILY_INSTANCE_DEMAND_H
              WHERE  INSTANCE_ID   = @v_to_instance_id
              AND    INSTANCE_DATE = @v_plan_date
              AND    SCP_PLAN_ID   = @v_plan_id
              and    customer_id   = @v_factory_id

              SET @v_message = @@ROWCOUNT
              SET @n_log_count += 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_INSTANCE_DEMAND_H', 'DELETE', @n_log_count, null, @v_message, null 


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
                      , a.plan_id                                     as scp_plan_id
                      , a.work_order_id + a.item_id + a.child_item_id as scp_target_id
                      , a.work_order_id + a.item_id + a.child_item_id as fp_target_id
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
                              select a.master_id, a.plan_id
                                    ,a.bom_version_id, a.PARENT_ITEM_ID, a.CHILD_ITEM_ID, a.site_id, a.route_id, a.OPERATION_ID, a.CONSUME_RATE, a.ALT_ID
                              from   (      
                                      select a.master_id, a.plan_id
                                            ,a.bom_version_id, a.PARENT_ITEM_ID, a.CHILD_ITEM_ID, a.site_id, a.route_id, a.OPERATION_ID, a.CONSUME_RATE, a.ALT_ID
                                            ,dense_rank() over ( partition by a.master_id, a.plan_id,a.bom_version_id, a.PARENT_ITEM_ID, a.site_id, a.OPERATION_ID , a.child_item_id
                                                                 order by a.CHILD_ITEM_ID, a.route_id, a.CONSUME_RATE ) as r
                                             --distinct parent_item_id, child_item_id, BOM_VERSION_ID, consume_rate, alt_id 
                                          -------------------------------------------------------
                                          -------------------------------------------------------
--                                      from   lgce_fpdev.dbo.th_mst_plan_bom a
                                      from   (
                                              select * from   kr_e_pre_a.dbo.th_mst_plan_bom where master_id = @v_master_id union all
                                              select * from   kr_e_pre_m.dbo.th_mst_plan_bom where master_id = @v_master_id union all
                                              select * from     us_e_pre.dbo.th_mst_plan_bom where master_id = @v_master_id union all
                                              select * from     cn_e_pre.dbo.th_mst_plan_bom where master_id = @v_master_id union all
                                              select * from       kr_srs.dbo.th_mst_plan_bom where master_id = @v_master_id 
                                             ) a
                                          -------------------------------------------------------
                                          -------------------------------------------------------
                                      where  a.master_id = @v_master_id
                                      and    a.plan_id   = @v_plan_id
                                      and    a.site_id   = @v_factory_id
                                      --and    a.parent_item_id = 'ASLCA0227A'
                                      and @plan_start_time between a.eff_start_date and a.eff_end_date
                                      --and convert(datetime, '2017-07-13 06:00:00', 20) between eff_start_date and eff_end_date
                                      and    a.child_item_id in ( 
                                                                 select item_id 
                                                                 from   scm_item_m       a
                                                                       ,scm_item_class_m b
                                                                 where  1=1
                                                                 and    a.item_class   = b.class_id
                                                                 --and    a.company_id   = 'C100'
                                                                 --and    a.division_id  = '40'
                                                                 --and    a.site_id      = 'A001'
                                                                 --and    a.item_class   = 'ES0101'
                                                                 and    a.active_flag  = 'Y'
                                                                 and    b.use_flag     = 'Y'
                                                                 and    b.level_2_code = 'ASL'
                                                                 and    b.level_3_code = 'ASLPD'      -- pre mix 만 대상  
                                                                )   
                                     ) a
                              where  a.r = 1  -- Route 별 수량을 나눌 필요가 없음
                             ) b 
                      where  a.master_id = b.master_id
                      and    a.plan_id   = b.plan_id
                      and    a.item_id   = b.parent_item_id
                      --order by a.work_order_id, a.item_id, b.child_item_id
                     ) a,
                     SCM_FACTORY_M b
              where  a.after_site_id = b.factory_id       
              
              --LOG 생성
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_INSTANCE_DEMAND_H', 'INSERT', @@ROWCOUNT, null, @v_to_instance_id, null

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
                          ,market
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
                           , null     as description
                    from   (
                            select a.company_id, a.division_id, a.site_id, a.plant_id
                                   , a.instance_id, a.dpp_plan_id
                                   , substring ( a.dpp_plan_id, charindex( '-', a.dpp_plan_id )+1, 8 ) as fp_plan_date
                                   , a.production_type, a.market, b.operation_id
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
                                where  factory_id   = @v_factory_id
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
                        
          
            SET @v_message = @@ROWCOUNT
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
