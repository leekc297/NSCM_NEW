--CREATE PROCEDURE [dbo].[PR_SCM_MANUAL_WO_MERGE_ONEONE_ETC]
CREATE PROCEDURE [dbo].[PR_SCM_MANUAL_WO_MERGE_ONEONE_ETC]
   @p_master_id  nvarchar(max) = '-',
   @p_plan_id    nvarchar(max) = '-',
   @p_factory_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MANUAL_WO_MERGE_ONEONE_ETC                                         **/
/** 프로그램 명   : Mixer 공정 수동생성                                                       **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument      :                                                                           **/
/**     EXEC PR_SCM_MANUAL_WO_MERGE_ONEONE_ETC @v_master_id, @v_plan_id, @v_factory_id        **/
/**                                                                                           **/
/** [검색 조건]                                                                               **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/** 20170720       ksjeon        Mixer 공정 수동생성                                          **/
/** 20170817       kimcd         복수 Slurry 반영                                             **/
/** 20180211       kimcd         1일 복수 릴리즈 반영                                         **/
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_MANUAL_WO_MERGE_ONEONE_ETC'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  
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

-- BOM 조회용 조직 변수
  DECLARE @COMPANY_ID     NVARCHAR(30)
  DECLARE @DIVISION_ID    NVARCHAR(30)
  DECLARE @SITE_ID        NVARCHAR(30)
  DECLARE @PLANT_ID       NVARCHAR(30)
  
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
      FROM   SCM_FP_PLAN_H WITH(NOLOCK)
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID     = @v_plan_id             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null


      -- @p_factory_id 기반으로 BOM plant 정보 추출
	  SELECT  @COMPANY_ID  = SF.COMPANY_ID
			, @DIVISION_ID = SF.DIVISION_ID
			, @SITE_ID     = SF.SITE_ID
			, @PLANT_ID    = SF.PLANT_ID
	  FROM    DBO.SCM_FACTORY_M  SF WITH(NOLOCK)
	  WHERE   SF.FACTORY_ID = @p_factory_id
             
      SET @v_table_name = 'SCM_STOCK_H'
      SELECT @v_cutoff_date = max(cutoff_date)
      FROM   SCM_STOCK_H_V
      --WHERE  CUTOFF_DATE <= DATEADD(DD, 0, CONVERT(DATE, @key_date))   -- 하루전부터 탐색
      WHERE  CUTOFF_DATE = DATEADD(DD, 0, CONVERT(DATE, @key_date))      -- 오늘꺼만             
             
             
      --LOG 생성
      SET @v_message = 'CUTOFF_DATE : ' + CONVERT(nvarchar, @v_cutoff_date, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END;


    BEGIN

      --'KR_CELL', 'KR_E_PMIX', 'KR_E_POST', 'KR_E_PRE', 'KR_PACK', 'KR_SRS'
      --'CN_CELL', 'CN_E_PMIX', 'CN_E_POST', 'CN_E_PRE', 'CN_PACK'
      --'US_CELL',              'US_E_POST', 'US_E_PRE', 'US_PACK'             

      if @v_master_id = 'KR_E_PRE' 
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
      else if @v_master_id = 'KR_E_PRE_A'     
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



    BEGIN

        -- @release_plan_id 쿼리.. 
        BEGIN

		  -- 2018-02-11 kimcd 하루에 여러번 배포 가능하도록 기능 보완. 기준 Table을 SCM_FP_PLAN_DETAIL_H에서 FP_RELEASE_PLAN_INFO_H으로 전환 막기 시작
		  /*
          SET @v_table_name = 'SCM_FP_PLAN_DETAIL_H'
          select distinct 
                 @release_plan_id = release_plan_id
            FROM (
                  select plan_id, release_plan_id, 
                         dense_rank() over( partition by instance_id
                                                order by plan_date desc, insert_time desc, plan_id desc ) as r
                  FROM   SCM_FP_PLAN_DETAIL_H
                  where  1=1
                  and    instance_id = @v_master_id
                  and    factory_id  = @v_factory_id
                  and    plan_date   <= convert(nvarchar, @plan_start_time, 112) -- 2018-02-11 kimcd 1일 복수 릴리즈 대비하여 최종 릴리즈 계획 조회하는 일자 조건 변경
                  and    release_flag = 'Y'
                 ) a          
          where 1 = 1
          and   r = 1 */
		  -- 2018-02-11 kimcd 하루에 여러번 배포 가능하도록 기능 보완. 기준 Table을 SCM_FP_PLAN_DETAIL_H에서 FP_RELEASE_PLAN_INFO_H으로 전환 막기 끝
		  -- 2018-02-11 kimcd 하루에 여러번 배포 가능하도록 기능 보완. 기준 Table을 SCM_FP_PLAN_DETAIL_H에서 FP_RELEASE_PLAN_INFO_H으로 전환 추가 시작
		  SET @v_table_name = 'FP_RELEASE_PLAN_INFO_H'
		  select distinct
		         @release_plan_id = release_plan_id
		  FROM  (
				  select release_plan_id, 
						 dense_rank() over( partition by instance_id
											    order by instance_date desc, insert_time desc, release_plan_id desc ) as r
				  FROM   FP_RELEASE_PLAN_INFO_H
				  WHERE  1=1
				  and    instance_id = @v_master_id
				  and    factory_id  = @v_factory_id
				  and    instance_date <= convert(nvarchar, @plan_start_time, 112)
                 ) a
          where 1 = 1
          and   r = 1
		  -- 2018-02-11 kimcd 하루에 여러번 배포 가능하도록 기능 보완. 기준 Table을 SCM_FP_PLAN_DETAIL_H에서 FP_RELEASE_PLAN_INFO_H으로 전환 추가 끝

          --LOG 생성
          SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
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
-- Mixer WO One to two 생성
-- sy_fp_amend_production_plan_r -> TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


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
                    --, replace(a.E2000_WORK_ORDER_ID, @v_coat_mid_char, @v_mix_mid_char) as  work_order_id -- CT -> MX
                     , replace( substring(a.E2000_WORK_ORDER_ID, 1, charindex(@v_coat_mid_char, a.E2000_WORK_ORDER_ID)+1), @v_coat_mid_char, @v_mix_mid_char)
                       +
                       substring(a.E2000_WORK_ORDER_ID, charindex(@v_coat_mid_char, a.E2000_WORK_ORDER_ID)+2, 100)
					   + CONVERT( NVARCHAR(1), ROW_NUMBER() OVER (PARTITION BY a.E2000_WORK_ORDER_ID ORDER BY A.ITEM_ID )) as  work_order_id -- CT -> MX
					   -- add kimcd row_number() 2017-08-17
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
							 , a.ord_priority  -- add kimcd 2017-08-17
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
									 , CASE WHEN B.ALT_ID IS NULL THEN 1 ELSE row_number() over ( partition by a.e2000_item_id, a.e2000_work_order_id, B.ALT_ID order by b.alt_priority, b.child_item_id) END as ord_priority -- ADD kimcd 2017-08-17
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
											  and    after_qty      > 0
                                              --and    demand_id = N'A^A^20170424^ACEN1058I-A1^오창공장조립셀13호::PFD01000001'
                                              and    after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater  공정..!!
                                              ) a  
                                      ) a          
                                      inner join
                                          (
                                              select a.parent_item_id, a.child_item_id, a.alt_priority, a.parent_item_rate, a.child_item_rate, a.route_id
													,a.alt_id -- add kimcd 2017-08-17
                                                     -- row_number() over ( partition by parent_item_id, a.route_id order by a.alt_priority, child_item_id) as r block kimcd 2017-08-17
                                              from   (
                                                      -- E2000 공정에서 E1000의 Parent 기종 정보를 찾는다
                                                      -- KR_E_PRE
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
																	, a.alt_id -- add kimcd 2017-08-17
        --                                              from   lgce_fpdev.dbo.th_eng_plan_bom a
                                                      from   (
                                                              /*select * from     kr_e_pre.dbo.th_eng_plan_bom where master_id = @v_master_id union all
                                                              select * from   kr_e_pre_a.dbo.th_eng_plan_bom where master_id = @v_master_id union all
                                                              select * from   kr_e_pre_m.dbo.th_eng_plan_bom where master_id = @v_master_id union all
                                                              select * from     us_e_pre.dbo.th_eng_plan_bom where master_id = @v_master_id union all
                                                              select * from     cn_e_pre.dbo.th_eng_plan_bom where master_id = @v_master_id union all
                                                              select * from       kr_srs.dbo.th_eng_plan_bom where master_id = @v_master_id */
															  SELECT    DISTINCT SBM.PARENT_ITEM_ID, SBM.CHILD_ITEM_ID,  SBM.ALT_PRIORITY, SBM.PARENT_ITEM_RATE, SBM.CHILD_ITEM_RATE, ILA.OPERATION_ID, ILA.LINE_ID AS route_id
																		, SBM.ALT_ID -- add kimcd 2017-08-17
																FROM    DBO.SCM_ITEM_LINE_ASSIGN_M ILA WITH(NOLOCK),
																		(   SELECT SBM.PARENT_ITEM_ID, SBM.CHILD_ITEM_ID,  SBM.ALT_PRIORITY, 1 AS PARENT_ITEM_RATE, SBM.CHILD_QTY/SBM.PARENT_QTY  AS CHILD_ITEM_RATE
																				, SBM.COMPANY_ID, SBM.DIVISION_ID, SBM.SITE_ID, SBM.PLANT_ID
																				, SBM.ALT_ID -- add kimcd 2017-08-17 
																			FROM   DBO.SCM_BOM_M               SBM WITH(NOLOCK)
																			WHERE  SBM.EFF_START_DATE <= GETDATE()
																			AND    SBM.EFF_END_DATE   >  GETDATE()
																			AND    SBM.PARENT_ITEM_ID LIKE 'APC%'
																			AND    SBM.CHILD_ITEM_ID  LIKE 'ASL%'
																			AND    SBM.PARENT_QTY     > 0
																			AND    SBM.COMPANY_ID     = @COMPANY_ID
																			AND    SBM.DIVISION_ID    = @DIVISION_ID
																			AND    SBM.SITE_ID        = @SITE_ID
																			AND    SBM.PLANT_ID       = @PLANT_ID ) SBM
																WHERE  SBM.COMPANY_ID     = ILA.COMPANY_ID
																AND    SBM.DIVISION_ID    = ILA.DIVISION_ID
																AND    SBM.SITE_ID        = ILA.SITE_ID
																AND    SBM.PLANT_ID       = ILA.PLANT_ID
																AND    SBM.PARENT_ITEM_ID = ILA.ITEM_ID
																AND    ILA.FACTORY_ID     = @p_factory_id
																AND    ILA.OPERATION_ID   = 'E2000'
																AND    ILA.MONTH          = @v_plan_month
                                                             ) a
                                                      where  /*a.master_id    = @v_master_id
                                                      and    a.plan_id      = @v_plan_id
                                                      and    */a.operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater  공정..!!
                                                      --and    isnull(a.alt_priority, 1) = 1 -- alt_priority = 1인 것으로 선택
                                                      --and a.parent_item_id like 'APCCA0345A%'
                                                      and case when charindex('_', a.child_item_id) = 0 
                                                          then a.child_item_id
                                                          else substring(a.child_item_id, 1, charindex('_', a.child_item_id)-1)
                                                          end  in ( 
                                                                    select item_id
                                                                           --factory_id, item_id, operation_id, line_id as route_id, month, priority as alt_priority, active_flag 
                                                                    from   SCM_ITEM_LINE_ASSIGN_M
                                                                    where  factory_id   = @v_factory_id --'E4'
                                                                    and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                                                    and    month        = @v_plan_month --'201707'
                                                                    and    active_flag  = 'Y'
                                                                    --and item_id = 'ASLAN0823A'
                                                                    and    priority in ( 1, 2, 3, 4, 5, 6, 7, 8 ) -- 미사용 Flag인것은 할당 제외 (0, 9,null)
                                                                  )  
                                                      and    exists  (
                                                                      select 1 -- 자재 코드가 아닌것
                                                                      --from   lgce_fpdev.dbo.th_eng_item b
                                                                      from   /*(
                                                                              select * from     kr_e_pre.dbo.th_eng_item where master_id = @v_master_id union all
                                                                              select * from   kr_e_pre_a.dbo.th_eng_item where master_id = @v_master_id union all
                                                                              select * from   kr_e_pre_m.dbo.th_eng_item where master_id = @v_master_id union all
                                                                              select * from     us_e_pre.dbo.th_eng_item where master_id = @v_master_id union all
                                                                              select * from     cn_e_pre.dbo.th_eng_item where master_id = @v_master_id union all
                                                                              select * from       kr_srs.dbo.th_eng_item where master_id = @v_master_id

                                                                             )*/ DBO.SCM_ITEM_M  b WITH(NOLOCK)
                                                                      where  /*b.master_id = a.master_id 
                                                                      and    b.plan_id   = a.plan_id */
																			b.COMPANY_ID     = @COMPANY_ID
																	  AND    b.DIVISION_ID    = @DIVISION_ID
																	  AND    b.SITE_ID        = @SITE_ID
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
                                        -- and  b.r = 1 kimcd block 2017-08-17
										-- add start kimcd 2017-08-17
                                        and  b.child_item_id not in ( select sima.item_id
                                                                    from   SCM_ITEM_LINE_ASSIGN_EXCEPT_M  SIMA WITH(NOLOCK)
                                                                    where  1=1
																	and	   sima.company_id  = @COMPANY_ID
																	and    sima.division_id = @DIVISION_ID
																	and    sima.site_id     = @SITE_ID
																	and    sima.plant_id    = @plant_id
																	and    sima.factory_id  = @p_factory_id
																	and    sima.line_id     = b.route_id
                                                                    and    sima.active_flag = 'N'
                                                                    and    CONVERT(DATETIME,        SUBSTRING(a.E2000_START_TIME,  1, 4) 
                                                                                            + '-' + SUBSTRING(a.E2000_START_TIME,  5, 2)
                                                                                            + '-' + SUBSTRING(a.E2000_START_TIME,  7, 2)
                                                                                            + ' ' + SUBSTRING(a.E2000_START_TIME,  9, 2)
                                                                                            + ':' + SUBSTRING(a.E2000_START_TIME, 11, 2)
                                                                                            + ':' + SUBSTRING(a.E2000_START_TIME, 13, 2)) between sima.start_time and sima.end_time
                                                                    )
										-- add end kimcd 2017-08-17
                             ) a 
                             left outer join
                                 ( 
                                  -- stock 미사용
                                  select factory_id
                                         , fp_apply_item_id
                                         , sum(qty) as stock_qty
                                  from   scm_stock_h_V
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
              where a.ord_priority = 1 -- 우선순위 1번만 kimcd add 2017-08-17
              order by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type, a.market, a.E2000_item_id, a.E2000_PLAN_DATE, a.E2000_WORK_ORDER_ID
               



              SET @v_message = @@ROWCOUNT
              SET @v_table_name = 'TH_BUF_E1000_PLAN_TARGET'
              SET @n_log_count = @n_log_count + 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
              
            END           


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
                              select 
                                      a.master_id, a.plan_id, substring ( a.plan_id, charindex( '-', a.plan_id )+1, 8 ) as fp_plan_date
                                      , a.work_order_id
                                      , a.E2000_work_order_id
                                      , a.after_site_id      as before_site_id,      a.after_site_id
                                      , a.after_route_id     as before_route_id,     a.after_route_id
                                      , a.after_operation_id as before_operation_id, a.after_operation_id
                                      , b.resource_group_id  as before_resource_id,  b.resource_group_id as after_resource_id
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
                                      , a.E2000_PLAN_DATE as before_plan_date           
                                      , a.E2000_PLAN_DATE as after_plan_date            
                                      , a.E2000_START_TIME as after_start_time
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
                                      --, a.E2000_org_qty as before_qty, a.E2000_org_qty as after_qty, a.plan_qty as before_in_qty, a.plan_qty as after_in_qty
                                      , a.after_qty as before_qty, a.after_qty  as after_qty, a.plan_qty as before_in_qty, a.plan_qty as after_in_qty
                                      , a.item_id
                                      , a.fixed_yn, null as split_yn
                                      , a.demand_id
                                      , a.demand_type
                                      , a.market
                                      , null as order_id, null as order_type, null as po_id, null as mfg_week, null as sop_week
                                      , null as org_work_order_id
                                      , null as demand_due_date, '-' as batch_order_id, null as date_fix_flag, null as date_fix_date, null as operation_epst, null as operation_lpst, null as lane_qty, null as lane_tact_qty, 'EA' as item_uom
                                      , null as wo_day_split_yn, 0 as setup_time, 'SECOND' as setup_time_uom, null as batch_qty, null as ui_edit_yn, null as description
                              --select b.resource_group_id, a.*        
                              from   TH_BUF_E1000_PLAN_TARGET a
                                     inner join
                                         (
                                            -- 설비 할당
                                            select a.item_id, a.factory_id as site_id, a.route_id, a.operation_id, min(a.resource_id) as resource_group_id
                                            from   (
                                                    select a.item_id, a.factory_id, a.route_id, a.operation_id, b.resource_id 
                                                    from   (
                                                            select factory_id, item_id, operation_id, line_id as route_id, month, priority as alt_priority, active_flag 
                                                            from   SCM_ITEM_LINE_ASSIGN_M
                                                            where  factory_id   = @v_factory_id --'E4'
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
                                                            and    factory_id     = @v_factory_id --'E4'
                                                            and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                                            and    active_flag    = 'Y'
                                                           ) b
                                                    where  a.factory_id   = b.factory_id
                                                    and    a.operation_id = b.operation_id
                                                    and    a.route_id     = b.route_id
                                                   ) a
                                            group by a.item_id, a.factory_id, a.route_id, a.operation_id 
                                     ) b
                                         on   a.after_operation_id = b.operation_id
                                         and  a.after_site_id      = b.site_id
                                         and  a.after_route_id     = b.route_id
                                         and  a.item_id            = b.item_id  
                                     inner join SCM_ITEM_EQUIP_RATE_BATCH_M d
                                         on   a.after_operation_id = d.operation_id
                                         and  a.after_site_id      = d.factory_id
                                         and  a.item_id            = d.item_id  
                              where  a.master_id     = @v_master_id
                              and    a.plan_id       = @v_plan_id
                              and    a.after_site_id = @v_factory_id
                              and    a.plan_qty      > 0 
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
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.change_id          = @v_proc_name
          from    TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY a,
                  (
                    select a.master_id, a.plan_id, a.after_site_id, a.after_operation_id, a.E2000_work_order_id, a.work_order_id
                         , b.from_work_order_id as fix_work_order_id
                    from   (     
                            select master_id, plan_id, after_site_id, after_operation_id, E2000_work_order_id, work_order_id
									, item_id -- add kimcd 2017-08-17
                            from TH_BUF_E1000_PLAN_TARGET
                            where master_id        = @v_master_id
                            and plan_id            = @v_plan_id
                            and after_site_id      = @v_factory_id
                            and after_operation_id  in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                            --and work_order_id in ( 'K417609MX064', 'K117607MX01H' )
                            ) a,
                            (
                            select instance_id , fp_plan_id, to_factory_id, to_operation_id, to_work_order_id, from_work_order_id
									, from_item_id -- add kimcd 2017-08-17
                            from FP_ORDER_PEGGING_R
                            where instance_id   = @v_master_id
                            and fp_plan_id      = @release_plan_id
                            and to_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6 ) -- ## Coater  공정..!!
                            and to_factory_id   = @v_factory_id
                            --and to_work_order_id in ( 'K117607CT01H', 'K417609CT08F' )
                           ) b
                    where  a.master_id = b.instance_id 
                    and    a.after_site_id       = b.to_factory_id
                    and    a.E2000_work_order_id = b.to_work_order_id
					and    a.item_id = b.from_item_id -- add kimcd 2017-08-17
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
        -- Fix work order 를 반영한 최종 WO 로 Update
        -- Fix work order 를 반영하면서 Dup 에러 발생하여 이를 수정함
        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY'

          update  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
          set     TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.final_work_order_id  = b.new_work_order_id,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.z_work_order_id      = case when charindex(@v_mix_mid_char, b.new_work_order_id) > 0
                                                                                        then substring(b.new_work_order_id, 1, charindex(@v_mix_mid_char, b.new_work_order_id)+1)
                                                                                             + 'Z' +
                                                                                             substring(b.new_work_order_id, charindex(@v_mix_mid_char, b.new_work_order_id)+3,10)
                                                                                        else  b.new_work_order_id 
                                                                                   end ,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.change_id            = @v_proc_name
          from    TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY a,
                  (
                    select 
                            master_id,plan_id 
                            ,work_order_id, merge_work_order_id, fix_work_order_id, r
                            , CASE WHEN R = 1 THEN new_work_order_id  ELSE new_work_order_id + '@' + CONVERT(NVARCHAR, R )  END  AS new_work_order_id  
                    from   (            
                            select 
                                    master_id,plan_id , work_order_id, merge_work_order_id, fix_work_order_id
                                    ,new_work_order_id
                                    ,ROW_NUMBER() OVER ( PARTITION BY new_work_order_id ORDER BY new_work_order_id, fix_work_order_id DESC ) AS R
                            from   (            
                                    select 
                                          master_id,plan_id, work_order_id, merge_work_order_id, fix_work_order_id
                                          ,case when -- fixed_yn = 'Y'  and 
                                                     fix_work_order_id is not null
                                                then substring(isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) ), 1, 12 )
                                                else isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) )
                                                  end as  new_work_order_id
                                    from TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
                                    where master_id      = @v_master_id
                                    and   plan_id        = @v_plan_id
                                    and   AFTER_SITE_ID  = @v_factory_id
                                    and   AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                                    and   after_qty > 0
                                   ) a
                            ) a     
                 ) b
          where  a.master_id           = b.master_id
          and    a.plan_id             = b.plan_id
          and    a.work_order_id       = b.work_order_id
                

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
        -- 다른 Factory에 동일한 Mixer WO 가 있을수 있어 확인 후 같은것이 있으면 WO를 변경 함
        BEGIN
         
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY'

          update  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
          set     TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.final_work_order_id  = b.z_work_order_id ,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY.change_id            = @v_proc_name
          from    TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY a,
                  (
                    select 
                            a.master_id, a.plan_id, a.final_work_order_id, a.z_work_order_id, isnull(b.work_order_id, '##') same_work
                    from   (            
                            select 
                                  master_id,plan_id, final_work_order_id, z_work_order_id
                            from TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
                            where master_id      = @v_master_id
                            and   plan_id        = @v_plan_id
                            and   AFTER_SITE_ID  = @v_factory_id
                            and   AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 ) -- ## Mixer 공정..!!
                            and   after_qty > 0
                           ) a
                           left outer JOIN
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
        -- Fix work order 를 반영한 최종 WO 로 Update
        -- Fix work order 를 반영하면서 Dup 에러 발생하여 이를 수정함
        BEGIN
         
          SET @v_table_name = 'TH_BUF_E1000_PLAN_TARGET'

          update  TH_BUF_E1000_PLAN_TARGET
          set     TH_BUF_E1000_PLAN_TARGET.work_order_id  = b.final_work_order_id,
                  TH_BUF_E1000_PLAN_TARGET.attb_1         = a.work_order_id,
                  TH_BUF_E1000_PLAN_TARGET.insert_id      = 'CHANGE_WORK_ORDER'
          from    TH_BUF_E1000_PLAN_TARGET a,
                  (
                    select 
                           master_id,plan_id, work_order_id, final_work_order_id
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
                        ,a.before_site_id,a.after_site_id
                        --,a.before_route_id
                        ,min(a.before_route_id) as before_route_id
                        ,a.after_route_id
                        ,a.before_operation_id
                        ,a.after_operation_id
                        ,min(a.before_resource_id) as before_resource_id
                        ,a.after_resource_id
                        ,min(a.before_plan_date) as before_plan_date
                        -- 20170620 ksjeon ,max(a.after_plan_date)  as after_plan_date
                        ,min(a.after_plan_date)  as after_plan_date
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
--                                    ,case when fixed_yn = 'Y'  and fix_work_order_id is not null
--                                          then substring(isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) ), 1, 12 )
--                                          else isnull( fix_work_order_id, isnull( merge_work_order_id, work_order_id ) )
--                                          end as  work_order_id
                                    ,final_work_order_id as work_order_id     
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
                        ,a.before_site_id,a.after_site_id
                        --,a.before_route_id
                        ,a.after_route_id,a.before_operation_id
                        ,a.after_operation_id
                        ,a.after_resource_id
                        ,a.before_start_time
                        ,a.after_start_time
                        ,a.before_end_time
                        ,a.after_end_time
                        ,a.working_time
                        ,a.before_qty
                        ,a.after_qty
                        ,a.before_in_qty
                        ,a.after_in_qty
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
                                AND    FP_PLAN_ID         = @release_plan_id --'KR_E_PRE-20170710-95' 
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






------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

-- FP_ORDER_PEGGING_R Delete / Insert start

        begin

            BEGIN
            
              SET @v_table_name = 'TH_BUF_FP_ORDER_PEGGING_R'
              
              DELETE FROM TH_BUF_FP_ORDER_PEGGING_R
              WHERE  instance_id     = @v_master_id --'KR_E_PRE'
              and    fp_plan_id      = @v_plan_id --'KR_E_PRE-20170523-10'
              and    to_factory_id   = @v_factory_id --'E3'
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
              WHERE   instance_id     = @v_master_id --'KR_E_PRE'
              and     fp_plan_id      = @v_plan_id --'KR_E_PRE-20170523-10'
              and     to_factory_id   = @v_factory_id --'E3'
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
              and    a.instance_id     = @v_master_id --'KR_E_PRE'
              and    a.fp_plan_id      = @v_plan_id --'KR_E_PRE-20170523-10'
              and    a.to_factory_id   = @v_factory_id --'E3'
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
                      from   TH_BUF_E1000_PLAN_TARGET
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
                             /*select master_id, plan_id, after_site_id, after_operation_id
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
                             and    after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6) */-- 'E2000'          
							 SELECT
                                    master_id, plan_id, after_site_id, after_operation_id,
                                    work_order_id                                    
                                    , after_qty, after_in_qty, item_id
                                    , fixed_yn, demand_id, demand_type, market                             
                             from fp_amend_production_plan_r
                             where  master_id          = @v_master_id --'KR_E_PRE'
                             and    plan_id            = @v_plan_id -- 'KR_E_PRE-20170724-98'
                             and    after_site_id      = @v_factory_id -- 'E1'
                             and    after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2, @v_wo_id_merge_op3, @v_wo_id_merge_op4, @v_wo_id_merge_op5, @v_wo_id_merge_op6) -- ( 'E2000') -- 'E2000'     
                            ) c 
                            on   a.master_id           = c.master_id
                            and  a.plan_id             = c.plan_id
                            and  a.after_site_id       = c.after_site_id
                            and  a.E2000_work_order_id = c.work_order_id
                     inner join
                            (
                             -- Mixer 정보
                             select master_id, plan_id, after_site_id, after_operation_id, final_work_order_id as work_order_id, after_qty, after_in_qty, item_id
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
                            and  a.work_order_id = d.work_order_id
              where  a.master_id          = @v_master_id
              and    a.plan_id            = @v_plan_id
              and    a.after_site_id      = @v_factory_id
              and    a.after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2, @v_mix_wo_id_merge_op3, @v_mix_wo_id_merge_op4, @v_mix_wo_id_merge_op5, @v_mix_wo_id_merge_op6 )
              
              
              
              

              
              SET @v_message = @@ROWCOUNT
              SET @v_table_name = 'FP_ORDER_PEGGING_R'
              SET @n_log_count = @n_log_count + 1
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
              
            END      
        end  


-- FP_ORDER_PEGGING_R Delete / Insert end


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
                      , a.plan_id                   as scp_plan_id
                      , a.work_order_id + a.item_id as scp_target_id
                      , a.work_order_id + a.item_id as fp_target_id
                      , a.CHILD_ITEM_ID as item_id -- ksjeon
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
                                            ,dense_rank() over ( partition by a.master_id, a.plan_id,a.bom_version_id, a.PARENT_ITEM_ID, a.site_id, a.OPERATION_ID
                                                                 order by a.CHILD_ITEM_ID, a.route_id, a.CONSUME_RATE ) as r
                                             --distinct parent_item_id, child_item_id, BOM_VERSION_ID, consume_rate, alt_id 
                                          -------------------------------------------------------
                                          -------------------------------------------------------
--                                      from   lgce_fpdev.dbo.th_mst_plan_bom a
                                      from   (
                                              /*select * from     kr_e_pre.dbo.th_mst_plan_bom where master_id = @v_master_id union all
                                              select * from   kr_e_pre_a.dbo.th_mst_plan_bom where master_id = @v_master_id union all
                                              select * from   kr_e_pre_m.dbo.th_mst_plan_bom where master_id = @v_master_id union all
                                              select * from     us_e_pre.dbo.th_mst_plan_bom where master_id = @v_master_id union all
                                              select * from     cn_e_pre.dbo.th_mst_plan_bom where master_id = @v_master_id union all
                                              select * from       kr_srs.dbo.th_mst_plan_bom where master_id = @v_master_id */
											  SELECT    DISTINCT @v_master_id AS MASTER_ID, @v_plan_id AS PLAN_ID, ILA.FACTORY_ID AS SITE_ID, SBM.BOM_VERSION_ID, SBM.PARENT_ITEM_ID, SBM.CHILD_ITEM_ID,  SBM.ALT_PRIORITY, SBM.PARENT_ITEM_RATE, SBM.CONSUME_RATE, ILA.OPERATION_ID, ILA.LINE_ID AS route_id
														, SBM.EFF_START_DATE, SBM.EFF_END_DATE, SBM.ALT_ID
												FROM    DBO.SCM_ITEM_LINE_ASSIGN_M ILA WITH(NOLOCK),
														(   SELECT SBM.BOM_VERSION_ID, SBM.PARENT_ITEM_ID, SBM.CHILD_ITEM_ID,  SBM.ALT_PRIORITY, 1 AS PARENT_ITEM_RATE, SBM.CHILD_QTY/SBM.PARENT_QTY  AS CONSUME_RATE
																, SBM.COMPANY_ID, SBM.DIVISION_ID, SBM.SITE_ID, SBM.PLANT_ID, SBM.EFF_START_DATE, SBM.EFF_END_DATE , SBM.PARENT_ITEM_ID + '_ALT_' + SBM.ALT_ID AS ALT_ID
															FROM   DBO.SCM_BOM_M               SBM WITH(NOLOCK)
															WHERE  SBM.EFF_START_DATE <= GETDATE()
															AND    SBM.EFF_END_DATE   >  GETDATE()
															AND    SBM.PARENT_ITEM_ID LIKE 'ASL%'
															AND    SBM.CHILD_ITEM_ID  LIKE 'ASL%'
															AND    SBM.PARENT_QTY     > 0
															AND    SBM.COMPANY_ID     = @COMPANY_ID
															AND    SBM.DIVISION_ID    = @DIVISION_ID
															AND    SBM.SITE_ID        = @SITE_ID
															AND    SBM.PLANT_ID       = @PLANT_ID ) SBM
												WHERE  SBM.COMPANY_ID     = ILA.COMPANY_ID
												AND    SBM.DIVISION_ID    = ILA.DIVISION_ID
												AND    SBM.SITE_ID        = ILA.SITE_ID
												AND    SBM.PLANT_ID       = ILA.PLANT_ID
												AND    SBM.PARENT_ITEM_ID = ILA.ITEM_ID
												AND    ILA.FACTORY_ID     = @v_factory_id
												AND    ILA.OPERATION_ID   = 'E1000'
												AND    ILA.MONTH          = @v_plan_month
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
