--USE [LGCE_FP_TR]

create PROCEDURE [dbo].[PR_SCM_OF_COAT_WO_PEGGING_20251101]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_factory_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/*********************************************************************************************/ 
/** 프로그램 ID	: PR_SCM_OF_COAT_WO_PEGGING													**/
/** 프로그램 명	:                                                                           **/
/** 설 명		:																			**/
/** Version		: 1.0.0																		**/
/**                                                                                         **/
/** Argument	:																			**/
/**                                                                                         **/
/** [검색 조건]																				**/
/**                                                                                         **/
/** [Biz Logic]                                                                             **/
/**                                                                                         **/
/**-----------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유													**/
/** 20180626       hajh          분산된 프로시저를 하나로 통합 처리							**/
/**  ~ 201806XX                  > dbo.PR_SCM_OF_COAT_WO_MERGE__ALLNEW                      **/
/**                                + dbo.PR_SCM_OF_COAT_WO_MERGE_ONEONE_ETC_ALLNEW          **/
/**                                + dbo.PR_SCM_OF_COAT_WO_MERGE_ONETWO_E4_ALLNEW           **/
/**                              > 동일 factory 에 mixer 가 1개 있는 라인, 2개 있는 라인이	**/
/**                                같이 있음 ( 중국 전극 E7 )								**/
/** 2019.07.17	  LHS		CN_E_PRE_M의 MARKET을 구분함. (D로 강제변경 취소)				**/
/** 2020.01.07    LHS       E0500 W/O: 설비검색 조건에 ELECTRODE_TYPE추가					**/
/** 2020.01.10    LHS       전극 S-TEST 타입 추가로 엔진타입 보존용 컬럼추가				**/ -- (D20200110-R0100.01)
/** 2020.10.07    CGJ		SLURRY, 선분산 대치 WO 생성 옵션 추가 반영       				**/	-- (D20201005-R01013.01)
/** 2022.10.07    CYS		ECO 기준일자가 겹쳤을 경우 PLAN_BOM 생성시 일자를 넣어 plan date 조건에 걸어 하이 품번을 지정하도록 수정 **/	-- (D20221007-R01007.01) 
/** 2023.02.19    CYS          전극 버전별 생산계획 수립 및 확정 	**/	-- (D221117~R230219.01)
/** 2023.02.19    CYS          대치 slurry item 만 기준으로 작업지시서 기준으로 적용아이템 	**/	-- (D221117~R230219.01)
/** 2024.05.29    CYS          Mixer WO 발행시 균등하게 발행되도록 룩업 관리 (CSR:E20240527-000127) 	**/	-- (D240529~R240529.01)
/** 2020.08.29    CYS       E0430 Dam Mixer 추가 관련 대응							**/	--  (D240829~R240829.01)
/** 2020.09.04    CYS       E0500 작업지시서 관리하지 않지만 특정 Item 으로 WO 내리고 싶을 경우 Alt Priority 무시하고 강제 지정	**/	--  (D240904~R240905.01)
/** 2025.03.19    CYS          PDS-4MCC 고도화(PDS Target, Equipment, 작업지시서)  **/ -- (D20250319~R0319.01)
/** 2025.09.18    CYS         [E20250918-001592] PDS 버전 -자리수 조치 요청건,  Pre Mixer 는 조건에 따라 버전 정보를 보내지 말아야 한다.  **/
/** 2025.11.01    FP Pjt.   E20251015-001250 / 슬러리 하위자재 소요량 로직 수정  **/
/*********************************************************************************************/  
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
  DECLARE @release_plan_id  nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_OF_COAT_WO_PEGGING'
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

-- WO Merge 대상 mixer 공정 list
  DECLARE @v_mix_wo_id_merge_op1  nvarchar(10) = '00000'
  DECLARE @v_mix_wo_id_merge_op2  nvarchar(10) = '00000'
  
-- WO Merge 대상 pmixer 공정 list
  DECLARE @v_pmix_wo_id_merge_op1  nvarchar(10) = '00000'
  DECLARE @v_pmix_wo_id_merge_op2  nvarchar(10) = '00000' 


-- BATCH id Merge 대상 Mixer 공정 list
  DECLARE @v_batch_id_merge_op1   nvarchar(10) = '00000'
  DECLARE @v_batch_id_merge_op2   nvarchar(10) = '00000'

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  DECLARE @v_plan_month     nvarchar(30)

  DECLARE @v_cutoff_date     date

------  mix 소요량 생성용 -------------
  DECLARE @v_plan_date      DATE
  DECLARE @v_to_instance_id   nvarchar(30)
  DECLARE @v_to_instance_key  nvarchar(30)
  DECLARE @n_day_diff         Integer  = 0

  DECLARE @v_coat_mid_char    nvarchar(30)
  DECLARE @v_mix_mid_char     nvarchar(30)
  DECLARE @v_mix_mid_char2    nvarchar(30)		--  (D240829~R240829.01)
  DECLARE @v_mix_mid_op       nvarchar(10)
  DECLARE @v_mix_mid_op2      nvarchar(10)		--  (D240829~R240829.01)
----------------------------------------

------  P-mix 소요량 생성용 -------------
  DECLARE @v_pmix_option       nvarchar(2)
  DECLARE @v_pmix_mid_char     nvarchar(30)

  DECLARE @v_pmix_instruction_flag   nvarchar(10)	-- (D20250319~R0319.01) PDS2
  
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
           , @plan_end_time = (
                                CASE  WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_TIME)
                                                                      ELSE DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                END  
                              )
           , @v_plan_month    = substring(CONVERT(varchar, CONVERT(DATETIME, PLAN_START_TIME, 20) , 112), 1, 6)
           , @key_date    = CONVERT(NVARCHAR, PLAN_START_TIME, 112)
           , @v_plan_date = CONVERT(DATE,     PLAN_START_TIME, 112)                           -- Pmix 소요량 생성용
           , @v_cutoff_date = CONVERT(DATE,     PLAN_START_TIME, 112) 					-- ADD (D20201005-R01013.01)
           , @n_day_diff  = DATEDIFF(MINUTE, CONVERT(DATE, PLAN_START_TIME), PLAN_START_TIME) -- Pmix 소요량 생성용
           , @v_hhmiss    = REPLACE(CONVERT(NVARCHAR, PLAN_START_TIME, 8), ':', '')
      FROM   SCM_FP_PLAN_H WITH(NOLOCK)
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID     = @v_plan_id             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112) + ' / CUTOFF_DATE : ' + CONVERT(nvarchar, @v_cutoff_date, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

	  -- 주석처리 (D20201005-R01013.01)
	  /*             
      SET @v_table_name = 'SCM_STOCK_H'
      SELECT @v_cutoff_date = max(cutoff_date)
      FROM   SCM_STOCK_H WITH(NOLOCK)
      --WHERE  CUTOFF_DATE <= DATEADD(DD, 0, CONVERT(DATE, @key_date))   -- 하루전부터 탐색
      WHERE  CUTOFF_DATE = DATEADD(DD, 0, CONVERT(DATE, @key_date))      -- 오늘꺼만             
             
             
      --LOG 생성
      SET @v_message = 'CUTOFF_DATE : ' + CONVERT(nvarchar, @v_cutoff_date, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
	  */

      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

      SELECT @v_instance_code = ISNULL(MAX(A.KEY_VALUE), '-')
      FROM   FP_INSTANCE_CONFIG_M  AS A WITH(NOLOCK)
      WHERE  A.INSTANCE_ID = @v_master_id
      AND    A.CATEGORY_ID = 'EXPORT' 
      AND    A.KEY_ID = 'INSTANCE_CODE'

      --LOG 생성
      SET @v_message = '@v_instance_code : ' + ISNULL(@v_instance_code, '')
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'

      SELECT @v_instance_sub_code = SEGMENT3
      FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
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
      
      SELECT  @v_pmix_option = ISNULL(MAX(ACTIVE_FLAG),'N')
      FROM  SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
      WHERE LOOKUP_TYPE_CODE = 'CREATE_WO_PRE_MIX'
      AND 	ACTIVE_FLAG ='Y'
      AND		ATTRIBUTE3 = @v_master_id
      
      --LOG 생성
      SET @v_message = '@v_pmix_option : ' + @v_pmix_option
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      -- (D20250319~R0319.01) PDS2
      SELECT  @v_pmix_instruction_flag = ISNULL(MAX(ATTRIBUTE6),'N')
      FROM  SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
      WHERE LOOKUP_TYPE_CODE = 'CREATE_WO_PRE_MIX'
      AND 	ACTIVE_FLAG ='Y'
      AND	ATTRIBUTE3 = @v_master_id
      
      --LOG 생성
      SET @v_message = '@v_pmix_instruction_flag : ' + @v_pmix_option
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
      FROM   FP_INSTANCE_CONFIG_M WITH(NOLOCK)
      WHERE  INSTANCE_ID = @v_master_id
      AND    CATEGORY_ID = 'WO_MERGE'
      AND    KEY_ID      = 'WO_MERGE'            

      -- ### MERGE 옵션이 'Y' 일경우 해당 Instance 별 operation set
      IF ISNULL(@v_is_wo_merge,'N') = 'Y'
      BEGIN

        if CHARINDEX('E_PRE' , @v_master_id) > 0
          begin   
            set @v_wo_id_merge_op1      = 'E2000'
            set @v_wo_id_merge_op2      = '00000'
            set @v_mix_wo_id_merge_op1  = 'E1000'
            --set @v_mix_wo_id_merge_op2  = '00000'
            set @v_mix_wo_id_merge_op2  = 'E0430'		--  (D240829~R240829.01)
            set @v_batch_id_merge_op1   = 'E1000'
            --set @v_batch_id_merge_op2   = '00000'
            set @v_batch_id_merge_op2   = 'E0430'		--  (D240829~R240829.01)		
            set @v_pmix_wo_id_merge_op1 = 'E0500'
            set @v_pmix_wo_id_merge_op2 = '00000'
          end      
        else if CHARINDEX('E_PMIX' , @v_master_id) > 0
          begin 
            set @v_wo_id_merge_op1     = 'E0500'
            set @v_wo_id_merge_op2     = '00000'
            set @v_mix_wo_id_merge_op1 = 'E0500'
            set @v_mix_wo_id_merge_op2 = '00000'
            set @v_batch_id_merge_op1  = 'E0500'
            set @v_batch_id_merge_op2  = '00000'
          end      
      END      
               
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
    
      -- @release_plan_id 쿼리.. 
      BEGIN

        SET @v_table_name = 'SCM_FP_PLAN_DETAIL_H'
        select distinct 
               @release_plan_id = release_plan_id
          FROM (
                select plan_id, release_plan_id, 
                       dense_rank() over( partition by instance_id
                                              order by plan_date desc, insert_time desc, plan_id desc ) as r
                FROM   HIS_FP_PLAN_DETAIL_H WITH(NOLOCK)
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
        SET @v_message = '@release_plan_id : ' + ISNULL(@release_plan_id, 'NULL')
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
                from   SCM_OPERATION_M a WITH(NOLOCK)
                where  a.erp_operation_id is not null
               ) a,
               (
                select distinct a.company_id, a.division_id, a.site_id, a.plant_id, a.factory_id
                from   scm_factory_m a WITH(NOLOCK)
               ) b
        where  a.company_id  = b.company_id
        and    a.division_id = b.division_id
        and    a.site_id     = b.site_id
        and    a.operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 )
        and    b.factory_id = @v_factory_id
               
        --LOG 생성
        SET @v_message = ' v_coat_mid_char : ' + @v_coat_mid_char
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
        
      END    

      BEGIN

        SET @v_table_name = 'SCM_OPERATION_M'
        select distinct @v_mix_mid_char = a.erp_operation_id, @v_mix_mid_op = a.operation_id
        --select distinct a.company_id, a.division_id, a.site_id, a.operation_id, a.erp_operation_id, b.plant_id, b.factory_id
        from   (
                select distinct a.company_id, a.division_id, a.site_id, a.operation_id, a.erp_operation_id
                from   SCM_OPERATION_M a WITH(NOLOCK)
                where  a.erp_operation_id is not null
               ) a,
               (
                select distinct a.company_id, a.division_id, a.site_id, a.plant_id, a.factory_id
                from   scm_factory_m a WITH(NOLOCK)
               ) b
        where  a.company_id  = b.company_id
        and    a.division_id = b.division_id
        and    a.site_id     = b.site_id
        and    a.operation_id in ( @v_mix_wo_id_merge_op1 )    
        and    b.factory_id = @v_factory_id
               
        --LOG 생성
        SET @v_message = ' @v_mix_mid_char : ' + @v_mix_mid_char
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
        
        --  (D240829~R240829.01)
        SET @v_table_name = 'SCM_OPERATION_M'
        select distinct @v_mix_mid_char2 = a.erp_operation_id, @v_mix_mid_op2 = a.operation_id
        --select distinct a.company_id, a.division_id, a.site_id, a.operation_id, a.erp_operation_id, b.plant_id, b.factory_id
        from   (
                select distinct a.company_id, a.division_id, a.site_id, a.operation_id, a.erp_operation_id
                from   SCM_OPERATION_M a WITH(NOLOCK)
                where  a.erp_operation_id is not null
               ) a,
               (
                select distinct a.company_id, a.division_id, a.site_id, a.plant_id, a.factory_id
                from   scm_factory_m a WITH(NOLOCK)
               ) b
        where  a.company_id  = b.company_id
        and    a.division_id = b.division_id
        and    a.site_id     = b.site_id
        and    a.operation_id in ( @v_mix_wo_id_merge_op2 )    
        and    b.factory_id = @v_factory_id
        
        IF @v_mix_mid_char2 IS NULL
        BEGIN
	       	 SET @v_mix_mid_char2 = 'XX'
	       	 SET @v_mix_mid_op2 = '00000'
	       	 SET @v_mix_wo_id_merge_op2 = '00000'
	    END
        
        --LOG 생성
        SET @v_message = ' @v_mix_mid_char2 : ' + @v_mix_mid_char2 + ' @v_mix_mid_op2 : ' + @v_mix_mid_op2
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
        
      END   
      
      BEGIN

        SET @v_table_name = 'SCM_OPERATION_M'
        select distinct @v_pmix_mid_char = a.erp_operation_id
        --select distinct a.company_id, a.division_id, a.site_id, a.operation_id, a.erp_operation_id, b.plant_id, b.factory_id
        from   (
                select distinct a.company_id, a.division_id, a.site_id, a.operation_id, a.erp_operation_id
                from   SCM_OPERATION_M a WITH(NOLOCK)
                where  a.erp_operation_id is not null
               ) a,
               (
                select distinct a.company_id, a.division_id, a.site_id, a.plant_id, a.factory_id
                from   scm_factory_m a WITH(NOLOCK)
               ) b
        where  a.company_id  = b.company_id
        and    a.division_id = b.division_id
        and    a.site_id     = b.site_id
        and    a.operation_id in ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 )    
        and    b.factory_id = @v_factory_id
               
        --LOG 생성
        SET @v_message = ' @v_pmix_mid_char : ' + @v_pmix_mid_char
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
        
      END 
        
      ------------------------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------

      -- 2018.03.19 : 1일 1 WORK 계획 먼저 수립함.
      IF   CHARINDEX('E_PRE',  @v_master_id ) > 0
        OR CHARINDEX('E_PMIX', @v_master_id ) > 0
      BEGIN

        SET @v_table_name = 'FP_AMEND_DAILY_PLAN_R'

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
             , SCM_ITEM_M             B WITH(NOLOCK)
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
             , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
             , VERSION    -- (D221117~R230219.01)
             --, PROD_SEQ    -- (D221117~R230219.01)
             , PLM_EC_NO    -- (D221117~R230219.01)
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
             , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           	 , A.VERSION    -- (D221117~R230219.01)
             --, A.PROD_SEQ    -- (D221117~R230219.01)
             , A.PLM_EC_NO    -- (D221117~R230219.01)
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
                             , A.SETUP_TIME
                             , A.FULL_CLEANING_FLAG
                             , A.MODEL_TYPE_CHANGE_FLAG
                             , A.TOTAL_BATCH
                             , A.CALC_TYPE
                             , A.CALC_VERSION
                             , A.PIG_CLEANING_FLAG
                             , A.SETUP_COLOR_CODE
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
                                                             , A.WORK_REQUEST_MODEL_ID	-- 버전이 없는 것이 들어와 중복이 발생하여 추가 20230322 by cys
                                                             , A.VERSION
                                                             --, A.PLM_EC_NO
                                                             ) AS ORDER_SEQ
                             , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
					         , A.VERSION    -- (D221117~R230219.01)
					         --, A.PROD_SEQ    -- (D221117~R230219.01)
					         , A.PLM_EC_NO    -- (D221117~R230219.01)
                        FROM   FP_AMEND_DAILY_PLAN_R  A
                             , SCM_OPERATION_M        B WITH(NOLOCK)
                             , SCM_EQUIPMENT_M        C WITH(NOLOCK)
                             , SCM_LINE_M             D WITH(NOLOCK)
                        WHERE  A.INSTANCE_ID    = @v_master_id
                        AND    A.FP_PLAN_ID     = @v_plan_id
                        AND    A.FACTORY_ID     = @v_factory_id
                        AND    A.PLAN_DATE     >= @v_plan_date
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
                        AND    D.ACTIVE_FLAG = 'Y'
                       ) A
               ) A
             , SCM_ITEM_M B WITH(NOLOCK)
             , SCM_SYS_CALENDAR_M C WITH(NOLOCK)
        WHERE  A.COMPANY_ID  = B.COMPANY_ID
        AND    A.DIVISION_ID = B.DIVISION_ID
        AND    A.SITE_ID     = B.SITE_ID
        AND    A.ITEM_ID     = B.ITEM_ID
        AND    A.PLAN_DATE   = C.DATE_ID
        
        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        -- (D221117~R230219.01)  ??? Lane 을 cal 에서 가져올 지 여부
        UPDATE A
        SET    A.LANE_QTY = B.LANE_QTY
        FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY  A
             , SCM_ITEM_LINE_ASSIGN_M         B WITH(NOLOCK)
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

        ------------------------------------------------------------------------------------------------------------
        -- 2018.11.14 : 확정 WORK ORDER SPLIT 배분
        ------------------------------------------------------------------------------------------------------------
        BEGIN
          
          SET @n_row_count  = 0
          SET @v_table_name = 'C_COAT_WO_PEGGING'

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
            FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
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
                      FROM   FP_DAILY_INSTANCE_ORDER_STATUS A WITH(NOLOCK)
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
              AND    FP_PLAN_ID         = @v_plan_id
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
              ORDER  BY PLAN_DATE_SEQ
              
              IF @C_COAT_RATE > 0.0
              BEGIN

                IF @C_COAT_SEQ = @C_COAT_CNT      -- 1일 1WORK 에 의해 맨 마지막 WO 는 그냥 전체 할당함.
                  SET @C_COAT_RATE = 1.0
                
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
                       , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
			           , VERSION    -- (D221117~R230219.01)
			           --, PROD_SEQ    -- (D221117~R230219.01)
			           , PLM_EC_NO    -- (D221117~R230219.01)
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
                       , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
			           , VERSION    -- (D221117~R230219.01)
			           --, PROD_SEQ    -- (D221117~R230219.01)
			           , PLM_EC_NO    -- (D221117~R230219.01)
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
                       , JR_IN_QTY          = JR_IN_QTY     - ( CASE WHEN ROUND(JR_IN_QTY      * @C_COAT_RATE, 0) > JR_IN_QTY      THEN JR_IN_QTY
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

        /*
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
                        and    operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 ) -- ## Coater / Mixer 공정..!!
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
        */

        ------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------

        SET @v_table_name = 'fp_amend_production_plan_r'

        DELETE FROM A
        FROM   fp_amend_production_plan_r A
        WHERE  A.MASTER_ID          = @v_master_id
        AND    A.PLAN_ID            = @v_plan_id
        AND    A.AFTER_SITE_ID      = @v_factory_id
        AND    A.AFTER_OPERATION_ID in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 ) -- ## Coater / Mixer 공정..!!

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
             , TOTAL_BATCH
             , CALC_TYPE
             , CALC_VERSION
             , PIG_CLEANING_FLAG
             , SETUP_COLOR_CODE
			 , FP_PRODUCTION_TYPE   ---(20200110) ADD : FP생산타입 정보
			 , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           	 , VERSION    -- (D221117~R230219.01)
             --, PROD_SEQ    -- (D221117~R230219.01)
             , PLM_EC_NO    -- (D221117~R230219.01)
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
             --, A.NEW_SEQ            AS BEFORE_SEQ
             --, A.NEW_SEQ            AS AFTER_SEQ
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
             , A.PRODUCTION_TYPE    AS DEMAND_TYPE   ---+ MES전송용으로 뒤에서 업데이트 한다.
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
             , A.INSERT_TIME
             , A.INSERT_ID          AS UPDATE_ID
             , A.INSERT_TIME        AS UPDATE_TIME
             , A.TOTAL_BATCH
             , A.CALC_TYPE
             , A.CALC_VERSION
             , A.PIG_CLEANING_FLAG
             , A.SETUP_COLOR_CODE
			 , A.PRODUCTION_TYPE    AS FP_PRODUCTION_TYPE  ---(20200110) FP에서 푼 PRODUCTION_TYPE (S-TEST)
			 , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           	 , A.VERSION    -- (D221117~R230219.01)
             --, A.PROD_SEQ    -- (D221117~R230219.01)
             , A.PLM_EC_NO    -- (D221117~R230219.01)
        FROM   (
                SELECT A.*
                     /*
                     , DENSE_RANK() OVER (PARTITION BY A.FACTORY_ID
                                                     , A.LINE_ID
                                                     , A.OPERATION_ID
                                                     , A.ELECTRODE_TYPE
                                                     , A.EQUIPMENT_ID
                                                     , A.PLAN_DATE
                                          ORDER     BY A.PLAN_DATE_SEQ
                                                     , ISNULL(A.FIX_WORK_SEQ, 0)    -- 확정 SPLIT 은 그 순서 유지
                                         ) AS NEW_SEQ
                     */
                FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY A WITH(NOLOCK)
                WHERE  A.INSTANCE_ID  = @v_master_id
                AND    A.FP_PLAN_ID   = @v_plan_id
                AND    A.FACTORY_ID   = @v_factory_id
                AND    A.OPERATION_ID in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 ) -- ## Coater / Mixer 공정..!!
               ) A

        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

      ------------------------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      -- Coating WO merge 후 Mixer WO One to one 생성
      -- sy_fp_amend_production_plan_r -> TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER
      ------------------------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------

      if CHARINDEX('PRE', @v_master_id) > 0
      begin

        BEGIN
        
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER'
          
          DELETE FROM TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER WHERE  INSERT_TIME < DATEADD(DAY, -7, GETDATE())

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
                  , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
	           	  , VERSION    -- (D221117~R230219.01)
	              --, PROD_SEQ    -- (D221117~R230219.01)
	              , PLM_EC_NO    -- (D221117~R230219.01)
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
                  , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
	           	  , VERSION    -- (D221117~R230219.01)
	              --, PROD_SEQ    -- (D221117~R230219.01)
	              , PLM_EC_NO    -- (D221117~R230219.01)
          from fp_amend_production_plan_r WITH(NOLOCK)
          where master_id      = @v_master_id
          and   plan_id        = @v_plan_id
          and   AFTER_SITE_ID  = @v_factory_id
          
          SET @v_message = @@ROWCOUNT
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER'
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END           


        ---------------------------
        -- E_PRE E1000 계획 생성용 buf table 생성
        -- TH_BUF_E1000_PLAN_TARGET
        -- 2020/10/07 ALT SLURRY WO 생성 옵션 추가 반영 BY CGJ
        ---------------------------
        BEGIN
        
          SET @v_table_name = 'TH_BUF_E1000_PLAN_BOM'
          
          DELETE FROM TH_BUF_E1000_PLAN_BOM WHERE  INSERT_TIME < DATEADD(DAY, -7, GETDATE())

          DELETE FROM TH_BUF_E1000_PLAN_BOM
          WHERE  MASTER_ID  = @v_master_id
          AND    PLAN_ID    = @v_plan_id
          AND    SITE_ID    = @v_factory_id

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_E1000_PLAN_BOM', 'DELETE', @n_log_count, null, @v_message, null 
          
          INSERT INTO TH_BUF_E1000_PLAN_BOM
               (
                 MASTER_ID
               , PLAN_ID
               , SITE_ID
               , PARENT_ITEM_ID
               , CHILD_ITEM_ID
               , ALT_ID
               , ALT_PRIORITY
               , PARENT_ITEM_RATE
               , CHILD_ITEM_RATE
               , ROUTE_ID
               , INSERT_TIME
			   , EFF_START_DATE	-- (D20221007-R01007.01) 
			   , EFF_END_DATE	-- (D20221007-R01007.01) 
               )
          -- E2000 공정에서 E1000의 Parent 기종 정보를 찾는다
          SELECT DISTINCT
                 @V_MASTER_ID   AS MASTER_ID
               , @V_PLAN_ID     AS PLAN_ID
               , EE.FACTORY_ID  AS SITE_ID
               , AA.PARENT_ITEM_ID
               , AA.CHILD_ITEM_ID
--               , AA.ALT_ID
--               , AA.ALT_PRIORITY
	       	   , CASE WHEN EE.ALT_WO_CREATE = 'Y' THEN NULL ELSE AA.ALT_ID END AS ALT_ID				-- (D20201005-R01013.01)
               , CASE WHEN EE.ALT_WO_CREATE = 'Y' THEN NULL ELSE AA.ALT_PRIORITY END AS ALT_PRIORITY    -- (D20201005-R01013.01)              
               , AA.PARENT_QTY / AA.PARENT_QTY AS PARENT_ITEM_RATE
               , AA.CHILD_QTY  / AA.PARENT_QTY AS CHILD_ITEM_RATE
               , EE.LINE_ID     AS ROUTE_ID
               , GETDATE()      AS INSERT_TIME
			   , AA.EFF_START_DATE	-- (D20221007-R01007.01) 
			   , AA.EFF_END_DATE	-- (D20221007-R01007.01) 
          FROM   SCM_BOM_M AA WITH(NOLOCK) ,
                 (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, 
                         MIN(KEY_DATE) AS KEY_DATE
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
                  AND    A.EFF_END_DATE   > @v_plan_date --CONVERT(DATE, GETDATE())             
                  AND    B.ITEM_TYPE      <> 'R'
                  GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.KEY_DATE
                 ) BB,
                 SCM_ITEM_M        CC WITH(NOLOCK) ,
                 SCM_ITEM_CLASS_M  DD WITH(NOLOCK) , 
                 (		-- (D20201005-R01013.01)
					SELECT A.COMPANY_ID
							, A.DIVISION_ID
							, A.SITE_ID
							, A.PLANT_ID
							, A.ITEM_ID
							, A.FACTORY_ID
							, A.LINE_ID
							, B.ATTRIBUTE3 AS ALT_WO_CREATE
					FROM   TH_BUF_SCM_DAILY_PLAN_FACTORY A,
							SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK) 
					WHERE  	A.INSTANCE_ID    = @v_master_id
					AND    	A.FP_PLAN_ID     = @v_plan_id
					AND    	A.FACTORY_ID     = @v_factory_id
					AND    	B.LOOKUP_TYPE_CODE = 'CREATE_ALT_WO_E_PRE'
					AND	 	A.INSTANCE_ID    = B.ATTRIBUTE1 
					AND	 	B.ACTIVE_FLAG    = 'Y'   
					AND 	A.FACTORY_ID     = B.SEGMENT5                  
					GROUP  BY A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.ITEM_ID
					, A.FACTORY_ID
					, A.LINE_ID             
					, B.ATTRIBUTE3         
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
          AND    AA.EFF_END_DATE    >  @v_plan_date --CONVERT(DATE, GETDATE())
          AND    AA.COMPANY_ID      = EE.COMPANY_ID
          AND    AA.DIVISION_ID     = EE.DIVISION_ID
          AND    AA.SITE_ID         = EE.SITE_ID
          AND    AA.PLANT_ID        = EE.PLANT_ID
          AND    AA.PARENT_ITEM_ID  = EE.ITEM_ID
          AND    DD.LEVEL_2_NAME LIKE 'Slurry'
          and    DD.class_id not in ( 'ES01', 'ES0101' ) -- 선분산 제외 
          
          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_E1000_PLAN_BOM', 'INSERT', @n_log_count, null, @v_message, null 
          
          /* --Test 
          update TH_BUF_E1000_PLAN_BOM
          set alt_priority = case when alt_priority = 1 then 3 else alt_priority -1 end 
          WHERE	1=1
			AND 	MASTER_ID = @v_master_id
			AND 	PLAN_ID = @v_plan_id
			and parent_item_id = 'APCAN1715A'
		*/
          
          -------------------------------------------------------------------------------------
          -- 대치 slurry item 만 기준으로 작업지시서 기준으로 적용아이템 이외건은 삭제처리
          -- 삭제처리가 안된것은 아래처리로직에서 org_priority 기준으로 걸러냄
          -- (D221117~R230219.01)
          -------------------------------------------------------------------------------------
        
			DELETE	TH_BUF_E1000_PLAN_BOM
			WHERE	1=1
			AND 	MASTER_ID = @v_master_id
			AND 	PLAN_ID = @v_plan_id
			AND		ALT_ID IS NOT NULL	-- 대치 item 만 적용
			AND		NOT EXISTS (			
										SELECT 	1
										FROM 	(
													SELECT 	DISTINCT A.SITE_ID AS FACTORY_ID
															, A.PARENT_ITEM_ID AS PANCAKE_ID
															, A.CHILD_ITEM_ID AS SLURRY_ID
															, RANK() OVER (PARTITION BY A.SITE_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, B.MODEL_ID, B.PROD_VERSION_TYPE, B.PROD_VERSION 
																		--ORDER BY B.PROD_SEQ DESC) AS RNK
																			ORDER BY B.APPLY_DATE DESC, B.PROD_VERSION DESC, B.PROD_SEQ DESC ) AS RNK
													FROM 	TH_BUF_E1000_PLAN_BOM A,
															FP_PROD_VERSION_M B,
															FP_PROD_VERSION_M D
													WHERE 	1=1
													AND 	A.MASTER_ID = @v_master_id
													AND 	A.PLAN_ID = @v_plan_id
													AND 	A.SITE_ID = B.FACTORY_ID 
													AND 	A.PARENT_ITEM_ID = B.ITEM_ID 
													AND 	B.COMPANY_ID = D.COMPANY_ID 
													AND 	B.DIVISION_ID = D.DIVISION_ID
													AND 	B.SITE_ID = D.SITE_ID
													AND 	B.PLANT_ID = D.PLANT_ID 
													AND 	B.FACTORY_ID = D.FACTORY_ID 
													AND 	B.MODEL_ID = D.MODEL_ID 
													AND 	B.PROD_VERSION_TYPE = D.PROD_VERSION_TYPE 
													AND 	B.PROD_VERSION = D.PROD_VERSION 
													AND 	B.PROD_SEQ = D.PROD_SEQ 
													AND 	A.CHILD_ITEM_ID = D.ITEM_ID
													AND		A.ALT_ID IS NOT NULL	-- 대치 item 만 적용
												) B
										WHERE 	1=1
										AND 	B.RNK =1
										AND 	SITE_ID = B.FACTORY_ID 
										AND 	PARENT_ITEM_ID = B.PANCAKE_ID 
										AND 	CHILD_ITEM_ID = B.SLURRY_ID 
								)
          
          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_E1000_PLAN_BOM', 'DELETE', @n_log_count, null, @v_message, null 
          
          
          SET @v_table_name = 'TH_BUF_E1000_PLAN_TARGET'
          
          DELETE FROM TH_BUF_E1000_PLAN_TARGET WHERE  INSERT_TIME < DATEADD(DAY, -7, GETDATE())
          
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
                   , after_operation_id,after_resource_id,after_plan_date,after_start_time,after_end_time,after_qty,after_in_qty
                   , item_id,demand_id,demand_type,market,TOP_ITEM_ID
                   , E2000_START_TIME,E2000_END_TIME,E2000_PLAN_DATE,E2000_item_id,fixed_yn, E2000_org_qty,org_qty
                   , r
                   , acu_org_qty,stock_qty,remain_qty,plan_qty
                   , INSERT_ID,INSERT_TIME
                   , E2000_FACTORY_ID
                   , E2000_LINE_ID
                   , E2000_OPERATION_ID
                   , E2000_EQUIPMENT_ID
                   , CHILD_ITEM_RATE
                   , CALC_TYPE
                   , CALC_VERSION
                   , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
		           , VERSION    -- (D221117~R230219.01)
        		 --, PROD_SEQ    -- (D221117~R230219.01)
		           , PLM_EC_NO    -- (D221117~R230219.01)
                  )
          select   a.master_id, a.plan_id
                 , a.E2000_WORK_ORDER_ID
               --, replace(a.E2000_WORK_ORDER_ID, @v_coat_mid_char, @v_mix_mid_char) as  work_order_id -- CT -> MX
                 , (
                   replace( substring(a.E2000_WORK_ORDER_ID, 1, charindex(@v_coat_mid_char, a.E2000_WORK_ORDER_ID)+1), @v_coat_mid_char, (CASE WHEN ISNULL(@v_mix_mid_op2,'0000') = a.after_operation_id THEN @v_mix_mid_char2 ELSE @v_mix_mid_char END) )			--  (D240829~R240829.01)
                   +
                   substring(a.E2000_WORK_ORDER_ID, charindex(@v_coat_mid_char, a.E2000_WORK_ORDER_ID)+2, 100) 
                   + work_order_post_str
                   ) as  work_order_id -- CT -> MX
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
                 , a.E2000_FACTORY_ID
                 , a.E2000_LINE_ID
                 , a.E2000_OPERATION_ID
                 , a.E2000_EQUIPMENT_ID
                 , a.CHILD_ITEM_RATE
                 , a.CALC_TYPE
                 , a.CALC_VERSION
                 , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
		         , A.VERSION    -- (D221117~R230219.01)
		         --, A.PROD_SEQ    -- (D221117~R230219.01)
		         , A.PLM_EC_NO    -- (D221117~R230219.01)
          from   (
                  select a.master_id, a.plan_id, a.E2000_WORK_ORDER_ID, a.after_site_id, a.after_route_id, a.after_operation_id
                         , null   as after_resource_id -- null
                         , null   as after_plan_date   -- null
                         , null   as after_start_time  -- null
                         , null   as after_end_time    -- null
						 -- START :: E20251015-001250 / 슬러리 하위자재 소요량 로직 수정
                         --, a.E2000_after_in_qty * a.child_item_rate                     as after_qty
                         --, ( a.E2000_after_in_qty * a.child_item_rate ) / isnull(c.E1000_YIELD, 1) as after_in_qty
						 , a.E1000_after_qty                    as after_qty
						 , a.E1000_after_qty / isnull(c.E1000_YIELD, 1) as after_in_qty
						 -- END :: E20251015-001250
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

						 -- START :: E20251015-001250 / 슬러리 하위자재 소요량 로직 수정
                         --, ( a.E2000_after_in_qty * a.child_item_rate ) / isnull(c.E1000_YIELD, 1) as org_qty -- consume rate 적용 ( E1000의 필요량 )
						 , a.E1000_after_qty / isnull(c.E1000_YIELD, 1) as org_qty -- consume rate 적용 ( E1000의 필요량 )
						 -- END :: E20251015-001250

                         , dense_rank() over( partition by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type, a.market
                                                  order by a.E2000_item_id, a.E2000_PLAN_DATE, a.E2000_WORK_ORDER_ID ) 
                           as r
						 -- START :: E20251015-001250 / 슬러리 하위자재 소요량 로직 수정
                         --, sum( a.E2000_after_in_qty * a.child_item_rate ) over( partition by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type, a.market
                         --                           order by a.E2000_item_id, a.E2000_PLAN_DATE, a.E2000_WORK_ORDER_ID ) 
                         --  as acu_org_qty
                        , sum( a.E1000_after_qty ) over( partition by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type, a.market
                                                    order by a.E2000_item_id, a.E2000_PLAN_DATE, a.E2000_WORK_ORDER_ID ) 
                           as acu_org_qty
                         -- END :: E20251015-001250
						, isnull(b.stock_qty, 0) as stock_qty 
                     , b.fp_apply_item_id 
                         --, (case when a.alt_id is not null then a.NEW_ORD_PRIORITY else 1 end) as ord_priority 	--(case when a.alt_id is not null then a.ord_priority else 1 end) as ord_priority
                         , CASE WHEN A.PROD_CNT > 0 AND A.RNK IS NULL THEN 9 ELSE (CASE WHEN A.ALT_ID IS NOT NULL THEN A.NEW_ORD_PRIORITY ELSE 1 END) END AS ORD_PRIORITY --작업지시서 기준으로 한후 없으면 BOM 기준으로 생성
                         , (case when a.alt_id is not null then '' else convert(NVARCHAR(10), a.NEW_ORD_PRIORITY) end) work_order_post_str	 --(case when a.alt_id is not null then '' else convert(NVARCHAR(10), a.ord_priority) end) work_order_post_str
                         , a.E2000_FACTORY_ID
                         , a.E2000_LINE_ID
                         , a.E2000_OPERATION_ID
                         , a.E2000_EQUIPMENT_ID
                         , a.CHILD_ITEM_RATE
                         , a.CALC_TYPE
                         , a.CALC_VERSION
                         , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
				         , A.VERSION    -- (D221117~R230219.01)
				         --, A.PROD_SEQ    -- (D221117~R230219.01)
				         , A.PLM_EC_NO    -- (D221117~R230219.01)
                  from   (
                  				SELECT 	A.*
                  						, ROW_NUMBER() OVER ( 	PARTITION BY A.E2000_ITEM_ID, A.E2000_WORK_ORDER_ID , A.ALT_ID 
																ORDER BY ISNULL(EE.RNK,9), A.ORD_PRIORITY, A.ITEM_ID) AS NEW_ORD_PRIORITY	-- 작업지시서에 동시 들어 있을 경우 작업지시서 먼저 보고 Priority 를 보도록 개선
                  						--  , ROW_NUMBER() OVER ( 	PARTITION BY A.E2000_ITEM_ID, A.E2000_WORK_ORDER_ID , A.ALT_ID 
										--						ORDER BY A.ORD_PRIORITY, A.ITEM_ID) AS NEW_ORD_PRIORITY	-- alt 가 2순위가 누락되는 현상이 있어 제외 20241101 cys
										  , EE.RNK
										  , FF.PROD_CNT	-- 작업지시서 존재 여부
										-- START :: E20251015-001250 / 슬러리 하위자재 소요량 로직 수정
										, case when isnull(A.E2000_batch_in_qty, 0) * isnull(SIC.VALUE, 0) > 0 then A.E2000_batch_in_qty * isnull(SIC.VALUE, 0) 
										        else a.E2000_after_in_qty * a.child_item_rate end	AS E1000_after_qty
										-- END :: E20251015-001250
                  				FROM	(
					                          -- 2018.07.23 : 전극 FP Mixer W/O 생성 로직 보완
					                          --              Coater W/O 기준으로 하위 Mixer W/O 생성 시
					                          --              Item Line Assign 기준으로 생성하며 Mixer Item이 2개 이상인 경우에는 
					                          --              BOM의 Alt Priority가 우선인 Item으로 W/O 생성
					                          select   a.master_id
					                                 , a.plan_id
					                                 , a.work_order_id as E2000_WORK_ORDER_ID
					                                 , a.after_site_id
					                               -------------------------------------------------
					                                 -------------------------------------------------
					                                 -- E2000 의 route_id 와 동일한지 확인할것 ksjeon
					                                 , a.after_route_id     
					                                 -------------------------------------------------
					                                 , case when a.after_operation_id = 'E2000' then (CASE WHEN C.OPERATION_ID = 'E0430' THEN C.OPERATION_ID ELSE 'E1000' END)
					                                        when a.after_operation_id = 'S2000' then 'S1000' 
					                                        else 'XXXX'
					                                   end  as after_operation_id
					                                 , b.CHILD_ITEM_ID    as item_id
					                                 , a.demand_id
					                                 , a.demand_type
					                                 , a.market
					                                 , a.top_item_id
					                                 , a.after_start_time as E2000_START_TIME
					                                 , A.after_end_time   as E2000_end_TIME
					                                 , a.after_plan_date  as E2000_PLAN_DATE
					                                 , a.item_id          as E2000_item_id
					                                 , a.fixed_yn
					                                 , a.after_in_qty     as E2000_after_in_qty
					                                 , b.alt_priority 
					                                 , b.parent_item_rate, b.child_item_rate
					                                 , row_number() over ( partition by a.item_id, a.work_order_id , b.alt_id order by b.alt_priority, b.child_item_id) as ord_priority
					                                -- , dense_rank() over ( partition by a.item_id, a.work_order_id order by b.alt_priority) as ord_priority
					                                 , b.alt_id
					                                 , a.AFTER_SITE_ID      AS E2000_FACTORY_ID
					                                 , a.AFTER_ROUTE_ID     AS E2000_LINE_ID
					                                 , a.AFTER_OPERATION_ID AS E2000_OPERATION_ID
					                                 , a.AFTER_RESOURCE_ID  AS E2000_EQUIPMENT_ID
					        						, a.CALC_TYPE
					                               , a.CALC_VERSION
					                                 , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
											         , A.VERSION    -- (D221117~R230219.01)
											         --, A.PROD_SEQ    -- (D221117~R230219.01)
											   , A.PLM_EC_NO    -- (D221117~R230219.01)
													 -- START :: E20251015-001250 / 슬러리 하위자재 소요량 로직 수정
													 , a.batch_in_qty       AS E2000_batch_in_qty
													 , c.company_id
													 -- END :: E20251015-001250
					     				from    fp_amend_production_plan_r a WITH(NOLOCK)
					                                , TH_BUF_E1000_PLAN_BOM      b WITH(NOLOCK)
					                                , (
					                                    SELECT A.*
					                                    FROM SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) , SCM_LINE_M B WITH(NOLOCK)
					                                    WHERE A.COMPANY_ID = B.COMPANY_ID 
					                                    AND A.DIVISION_ID  = B.DIVISION_ID 
					                                    AND A.SITE_ID = B.SITE_ID 
					           							AND A.PLANT_ID = B.PLANT_ID 
					                                    AND A.FACTORY_ID = B.FACTORY_ID
					                                    AND A.OPERATION_ID = B.OPERATION_ID 
					                                    AND A.LINE_ID = B.LINE_ID 
					                                    AND A.ELECTRODE_TYPE =  B.ELECTRODE_TYPE 
					                                    AND A.ACTIVE_FLAG = 'Y'
					                                    AND B.ACTIVE_FLAG = 'Y'
					                                  )c
					                          where  a.master_id          = @v_master_id
					                          and    a.plan_id            = @v_plan_id
					                          and    a.after_site_id      = @v_factory_id
					                          and    a.after_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 ) -- ## Coater  공정..!!
					                          and    a.master_id          = b.master_id
					                          and    a.plan_id            = b.plan_id
					                          and    a.after_site_id      = b.site_id
					                          and    a.item_id            = b.parent_item_id
					                          and    a.after_route_id     = b.route_id
											  AND    CONVERT(DATETIME,A.AFTER_PLAN_DATE)   >= B.EFF_START_DATE	-- (D20221007-R01007.01) 
											  AND    CONVERT(DATETIME,A.AFTER_PLAN_DATE)   < B.EFF_END_DATE		-- (D20221007-R01007.01) 
					                          and    b.child_item_id      = c.item_id
					                          and    b.site_id            = c.factory_id
					                          and    b.route_id           = c.line_id
					                          AND    c.ACTIVE_FLAG        = 'Y'
					                          AND    c.PRIORITY           IN ( 1,2,3,4,5,6,7,8)
					                          and    c.month              = substring(a.after_plan_date, 1, 6)
					                          and    NOT EXISTS ( select item_id 
					                                              from   SCM_ITEM_LINE_ASSIGN_EXCEPT_M X WITH(NOLOCK)
					                                              where  1=1
					                                              AND    X.ITEM_ID        = C.ITEM_ID
					                                              AND    X.FACTORY_ID     = C.FACTORY_ID
					                                              AND    X.LINE_ID        = C.LINE_ID
					                                              AND    X.OPERATION_ID   = C.OPERATION_ID
					                                              AND    X.ELECTRODE_TYPE = C.ELECTRODE_TYPE
					                                              AND    X.START_TIME    <= CONVERT(DATE, A.AFTER_PLAN_DATE)
					                                              AND    X.END_TIME      >= CONVERT(DATE, A.AFTER_PLAN_DATE)
					                                              and    (
					                                                        X.active_flag = 'N'
					                                                        OR
					                                                        X.PRIORITY    = 0
					                                                        OR
					                                                        X.PRIORITY    = 9
					                                                     )
					                      )
									) A
									LEFT OUTER JOIN (
															SELECT 	*
															FROM 	(
																		SELECT 	DISTINCT A.SITE_ID AS FACTORY_ID
																				, A.PARENT_ITEM_ID AS PANCAKE_ID
																				, A.CHILD_ITEM_ID AS SLURRY_ID
																				, B.MODEL_ID, B.PROD_VERSION_TYPE, B.PROD_VERSION
																				, RANK() OVER (PARTITION BY A.SITE_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, B.MODEL_ID, B.PROD_VERSION_TYPE, B.PROD_VERSION 
																							--ORDER BY B.PROD_SEQ DESC) AS RNK
																								ORDER BY B.APPLY_DATE DESC, B.PROD_VERSION DESC, B.PROD_SEQ DESC ) AS RNK
																		FROM 	TH_BUF_E1000_PLAN_BOM A,
																				FP_PROD_VERSION_M B,
																				FP_PROD_VERSION_M D
																		WHERE 	1=1
																		AND 	A.MASTER_ID = @v_master_id
																		AND 	A.PLAN_ID = @v_plan_id
																		AND     A.SITE_ID = @v_factory_id
																		AND 	A.SITE_ID = B.FACTORY_ID 
																		AND 	A.PARENT_ITEM_ID = B.ITEM_ID 
																		AND 	B.COMPANY_ID = D.COMPANY_ID 
																		AND 	B.DIVISION_ID = D.DIVISION_ID
																		AND 	B.SITE_ID = D.SITE_ID
																		AND 	B.PLANT_ID = D.PLANT_ID 
																		AND 	B.FACTORY_ID = D.FACTORY_ID 
																		AND 	B.MODEL_ID = D.MODEL_ID 
																		AND 	B.PROD_VERSION_TYPE = D.PROD_VERSION_TYPE 
																		AND 	B.PROD_VERSION = D.PROD_VERSION 
																		AND 	B.PROD_SEQ = D.PROD_SEQ 
																		AND 	A.CHILD_ITEM_ID = D.ITEM_ID
																		--AND		A.ALT_ID IS NOT NULL	-- 대치 ITEM 만 적용
																	) B
															WHERE 	1=1
															AND 	B.RNK =1
									) EE
									ON 1=1
									AND EE.FACTORY_ID	= A.AFTER_SITE_ID
									and EE.PANCAKE_ID   = A.E2000_item_id
									and EE.SLURRY_ID    = A.ITEM_ID
									AND EE.MODEL_ID		= A.WORK_REQUEST_MODEL_ID
									AND EE.PROD_VERSION	= A.VERSION
									
									LEFT OUTER JOIN (
															SELECT  M.MASTER_ID, M.PLAN_ID, M.AFTER_SITE_ID, M.AFTER_ROUTE_ID, M.ITEM_ID, M.AFTER_PLAN_DATE, M.AFTER_OPERATION_ID, M.WORK_REQUEST_MODEL_ID, M.VERSION, COUNT(*) AS PROD_CNT
															FROM 	FP_AMEND_PRODUCTION_PLAN_R M WITH(NOLOCK) ,
																	TH_BUF_E1000_PLAN_BOM A,
																	FP_PROD_VERSION_M B,
																	FP_PROD_VERSION_M D
															WHERE 	1=1
															AND    M.MASTER_ID 				= @v_master_id
															AND    M.PLAN_ID 				= @v_plan_id
															AND    M.AFTER_SITE_ID			= @v_factory_id
															AND    M.AFTER_OPERATION_ID		IN ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 ) -- ## Coater  공정..!!
															AND    M.MASTER_ID				= A.MASTER_ID
															AND    M.PLAN_ID				= A.PLAN_ID
															AND    M.AFTER_SITE_ID			= A.SITE_ID
															AND    M.ITEM_ID				= A.PARENT_ITEM_ID
															AND    M.AFTER_ROUTE_ID			= A.ROUTE_ID
															AND    CONVERT(DATETIME,M.AFTER_PLAN_DATE)   >= A.EFF_START_DATE	-- (D20221007-R01007.01) 
															AND    CONVERT(DATETIME,M.AFTER_PLAN_DATE)   <  A.EFF_END_DATE		-- (D20221007-R01007.01) 
															--AND	   M.WORK_REQUEST_MODEL_ID	= D.MODEL_ID
															--AND	   M.VERSION				= D.PROD_VERSION
															AND	   M.WORK_REQUEST_MODEL_ID	= B.MODEL_ID		-- (D20250319~R0319.01) PDS2 PDS2
															AND	   M.VERSION				= B.PROD_VERSION	-- (D20250319~R0319.01) PDS2 PDS2
															AND    A.SITE_ID				= B.FACTORY_ID 
															AND    A.PARENT_ITEM_ID			= B.ITEM_ID 
															AND    B.COMPANY_ID				= D.COMPANY_ID 
															AND    B.DIVISION_ID			= D.DIVISION_ID
															AND    B.SITE_ID				= D.SITE_ID
															AND    B.PLANT_ID				= D.PLANT_ID 
															AND    B.FACTORY_ID				= D.FACTORY_ID 
															AND    B.MODEL_ID				= D.MODEL_ID 
															AND    B.PROD_VERSION_TYPE		= D.PROD_VERSION_TYPE 
															AND    B.PROD_VERSION			= D.PROD_VERSION 
															AND    B.PROD_SEQ				= D.PROD_SEQ 
															AND    A.CHILD_ITEM_ID			= D.ITEM_ID
															--AND    D.APPLY_END_DATE			>= @v_plan_date -- 이전 버전으로 넣을 경우가 있어 주석처리 해둔다. 
															GROUP BY M.MASTER_ID, M.PLAN_ID, M.AFTER_SITE_ID, M.AFTER_ROUTE_ID, M.ITEM_ID, M.AFTER_PLAN_DATE, M.AFTER_OPERATION_ID, M.WORK_REQUEST_MODEL_ID, M.VERSION
									) FF
									ON 1=1
									AND FF.AFTER_SITE_ID	= A.AFTER_SITE_ID
									AND FF.AFTER_ROUTE_ID	= A.AFTER_ROUTE_ID
									and FF.ITEM_ID			= A.E2000_item_id
									And FF.AFTER_PLAN_DATE	= A.E2000_PLAN_DATE
									AND FF.AFTER_OPERATION_ID		= A.E2000_OPERATION_ID
									AND FF.WORK_REQUEST_MODEL_ID	= A.WORK_REQUEST_MODEL_ID
									AND FF.VERSION			= A.VERSION
									-- START :: E20251015-001250 / 슬러리 하위자재 소요량 로직 수정
									left outer join	 [SCM_ITEM_CONV_CALC_M] as SIC with(nolock)
									 on SIC.category		= 'Slurry (kg/batch)'
									and SIC.company_id		= a.company_id
									and SIC.factory_id		= a.[AFTER_SITE_ID]
									and SIC.model_id		= a.[WORK_REQUEST_MODEL_ID]
									and SIC.version			= a.version
									and SIC.operation		= a.after_operation_id
									and SIC.item_id			= a.item_id
									-- END :: E20251015-001250
							WHERE 	1=1
						 ) a 
 
                         left outer join
                             ( 
                              -- stock 미사용
                              select factory_id
                                     , fp_apply_item_id
                                     , sum(qty) as stock_qty
                              from   scm_stock_h_V WITH(NOLOCK)
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
                                from   SCM_YIELD_M WITH(NOLOCK)
                                where  1=0                          -- 2018.03.28 : Mixer 계획에서는 Yield 를 반영하지 않는다. / 20190225 Yield 반영 hssong 
                                and    factory_id   = @v_factory_id
                                and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
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
                                from   SCM_YIELD_M WITH(NOLOCK)
                                where  factory_id   = @v_factory_id
                                and    operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 ) -- ## Coater  공정..!!
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
          
          DELETE FROM TH_BUF_E1000_PLAN_TARGET_E4 WHERE  INSERT_TIME < DATEADD(DAY, -7, GETDATE())

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
                  , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
		          , VERSION    -- (D221117~R230219.01)
		          --, PROD_SEQ    -- (D221117~R230219.01)
		          , PLM_EC_NO    -- (D221117~R230219.01)
                 ) 
          -- 2018.11.06 : PL_E_PRE 에 Coat : Mix = 1 : 3 인 경우가 발생하여, 수량에 관계없이 반영되도록 로직 보완
          select a.MASTER_ID, a.PLAN_ID
                 , a.E2000_WORK_ORDER_ID
                 , substring(a.work_order_id, 1, charindex( (CASE WHEN ISNULL(@v_mix_mid_op2,'0000') = a.after_operation_id THEN @v_mix_mid_char2 ELSE @v_mix_mid_char END) , a.work_order_id)+1)			--  (D240829~R240829.01)
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
                 , 0 res1_qty     
                 , 0 res2_qty     
                 , 0 tot_tat1     
                 , 0 tot_tat2
                 , a.resource_seq   as r
                 , a.tat_min 
                 , isnull(b.E1000_YIELD, 1) as E1000_YIELD
                 , @v_proc_name AS INSERT_ID
                 , GETDATE()    AS INSERT_TIME
                 , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
		         , A.VERSION    -- (D221117~R230219.01)
		         --, A.PROD_SEQ    -- (D221117~R230219.01)
		         , A.PLM_EC_NO    -- (D221117~R230219.01)
          from   (    
                  select a.MASTER_ID, a.PLAN_ID
                         , a.E2000_WORK_ORDER_ID
                         , a.work_order_id + convert(nvarchar, a.resource_seq) as work_order_id
                         , row_number() over( partition by a.master_id, a.plan_id, a.after_operation_id
                                                  order by a.after_plan_date, a.after_site_id, a.after_route_id, a.after_resource_id, a.item_id, a.work_order_id, a.resource_seq )
                           as SEQ                        
                         , a.after_site_id, a.after_operation_id, a.item_id
                         , a.plan_qty                      -- 계획대상 수량
                         , a.batch_lot_size                             -- Batch lot size
                         , a.batch_count1                               -- Batch 수 - 소수점 batch
                         , a.batch_count                                -- Batch 수 - floor
                         , a.min_batch_apply                            -- MinLot Qty
                         , a.tat                                        -- 1 Batch time
                         , a.resource_seq                               -- Mixer 설비 순서
                         , a.resource_count                             -- Mixer 설비 대수
                         , a.resource_id                                -- Mixer 설비
                         , a.divide_count                               -- 나머지를 뺀 몫 수
                         , a.add_count                                  -- 첫번째 설비에 할당 할 MinLot1
                         , a.batch_lot_size * a.divide_count + a.add_qty as final_after_in_qty     
                         , ( a.tat * (a.divide_count + a.add_count) )    as tat_min     
                         -----------------------------------------------------------------
                          , a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time, a.after_qty, a.after_in_qty
                          , a.fixed_yn, a.demand_id, a.demand_type, a.market, A.TOP_ITEM_ID
                          , a.e2000_start_time, a.e2000_end_time, a.e2000_plan_date, a.e2000_item_id, a.e2000_org_qty, a.org_qty
                         -----------------------------------------------------------------
                          , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
				         , A.VERSION    -- (D221117~R230219.01)
				         --, A.PROD_SEQ    -- (D221117~R230219.01)
				         , A.PLM_EC_NO    -- (D221117~R230219.01)
                  from   (
                          select a.MASTER_ID, a.PLAN_ID
                                 , a.E2000_WORK_ORDER_ID, a.work_order_id
                                 , a.after_site_id, a.after_operation_id, a.item_id
                                 , a.plan_qty                                   -- 계획대상 수량
                                 , a.batch_lot_size                             -- Batch lot size
                                 , a.batch_count1                               -- Batch 수 - 소수점 batch
                                 , a.batch_count                                -- Batch 수 - floor
                                 , a.min_batch_apply                            -- MinLot Qty
                                 , a.tat                                        -- 1 Batch time
                                 , a.resource_seq                               -- Mixer 할당 순서
                                 , a.resource_count                             -- Mixer 설비 대수
                                 , a.resource_id                                -- Mixer 설비
                                 , case when a.batch_count % a.resource_count >= a.resource_seq then ceiling(a.batch_count / a.resource_count) 
                                                                                                else floor(a.batch_count / a.resource_count) 
                                   end  as divide_count   -- 나머지를 뺀 몫 수
                                 , case when ( a.batch_count % a.resource_count  ) + 1 = a.resource_seq 
                                         and a.min_batch_apply > 0                                      then 1
                                                                                                        else 0
                                   end  as add_count      -- tat 추가(?)
                                 , case when ( a.batch_count % a.resource_count  ) + 1 = a.resource_seq then a.min_batch_apply
                                                                                                        else 0
                                   end  as add_qty        -- qty 추가 (나머지 수량)
                                 -----------------------------------------------------------------
                , a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time, a.after_qty, a.after_in_qty
                                  , a.fixed_yn, a.demand_id, a.demand_type, a.market, A.TOP_ITEM_ID
                                  , a.e2000_start_time, a.e2000_end_time, a.e2000_plan_date, a.e2000_item_id, a.e2000_org_qty, a.org_qty
                                 -----------------------------------------------------------------
                                  , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
						          , A.VERSION    -- (D221117~R230219.01)
						          --, A.PROD_SEQ    -- (D221117~R230219.01)
						          , A.PLM_EC_NO    -- (D221117~R230219.01)
               			from   (
                                  select a.MASTER_ID, a.PLAN_ID
                                         , a.E2000_WORK_ORDER_ID, a.work_order_id
                                         , a.after_site_id, a.after_operation_id, a.item_id
                                         , a.plan_qty
                                         , a.batch_lot_size
                                         , a.plan_qty / a.batch_lot_size as batch_count1
                                         , floor(a.plan_qty / a.batch_lot_size)   as batch_count
                                         , ceiling(a.plan_qty / a.batch_lot_size) as batch_mod_count
                                         , a.plan_qty % a.batch_lot_size          as MOD_qty
                                         , ceiling(a.batch_lot_size * a.min_rate) as min_batch_size
                                         , case when a.plan_qty % a.batch_lot_size >= ceiling(a.batch_lot_size * a.min_rate)
                                                then a.plan_qty % a.batch_lot_size
                                                else ceiling(a.batch_lot_size * a.min_rate)
                                           end as min_batch_apply ---+ 나머지수량(MOD)     
                                         , a.tat
                                         , a.min_rate
                                         , a.resource_id, a.alt_priority, a.resource_seq, a.resource_count 
                                         -----------------------------------------------------------------
                                          , a.after_route_id, a.after_resource_id, a.after_plan_date, a.after_start_time, a.after_end_time, a.after_qty, a.after_in_qty
                                          , a.fixed_yn, a.demand_id, a.demand_type, a.market, A.TOP_ITEM_ID
                                          , a.e2000_start_time, a.e2000_end_time, a.e2000_plan_date, a.e2000_item_id, a.e2000_org_qty, a.org_qty
                                         -----------------------------------------------------------------
                                          , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
								          , A.VERSION    -- (D221117~R230219.01)
								          --, A.PROD_SEQ    -- (D221117~R230219.01)
								          , A.PLM_EC_NO    -- (D221117~R230219.01)
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
						, CASE WHEN ISNULL(F.MIX_LOT_SIZE_EXCEPT,'N') = 'Y' THEN 1 	-- (D240529~R240529.01)
						       ELSE
								CASE WHEN B.ITEM_UOM = 'EA' THEN CEILING(B.CELL_BATCH  / B.CHILD_YIELD * A.CHILD_ITEM_RATE ) --  CEILING(B.CELL_BATCH  / B.YIELD / B.CHILD_YIELD * A.CHILD_ITEM_RATE )
	                                                        WHEN B.ITEM_UOM = 'M'  THEN CEILING(B.M_BATCH     / B.CHILD_YIELD * A.CHILD_ITEM_RATE )
	                                                        ELSE 1 END
                                                   END  BATCH_LOT_SIZE
                                                , 1     as tat
                                                --, isnull(b.batch_lot_size, 1)  as batch_lot_size
                                                --, isnull(b.tat, 1)             as tat
                                                , isnull(c.min_rate, 0)        as min_rate
                                                , d.resource_id, d.alt_priority, d.resource_seq, d.resource_count 
                           , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
									            , A.VERSION    -- (D221117~R230219.01)
									            --, A.PROD_SEQ    -- (D221117~R230219.01)
									            , A.PLM_EC_NO    -- (D221117~R230219.01)
                                          FROM    TH_BUF_E1000_PLAN_TARGET a
                                                  LEFT OUTER JOIN FP_AMEND_DAILY_BOR_R B WITH(NOLOCK)
                                                        ON    A.MASTER_ID           = B.INSTANCE_ID
                                                        AND   A.PLAN_ID             = B.FP_PLAN_ID
                                                        AND   A.E2000_ITEM_ID       = B.ITEM_ID
                                                        AND   A.E2000_FACTORY_ID    = B.FACTORY_ID
                                                        AND   A.E2000_LINE_ID       = B.LINE_ID
                                                        AND   A.E2000_OPERATION_ID  = B.OPERATION_ID
                                                        AND   A.E2000_EQUIPMENT_ID  = B.EQUIPMENT_ID
                                                        AND   A.CALC_TYPE           = B.CALC_TYPE
                                                        AND   A.WORK_REQUEST_MODEL_ID = B.WORK_REQUEST_MODEL_ID	-- (D221117~R230219.01)  -- type 만 사용해서 걸지 않아도 될것 같음
                                                        AND   A.VERSION 			= B.VERSION					-- (D221117~R230219.01)	-- type 만 사용해서 걸지 않아도 될것 같음
                                                        --AND   A.CALC_VERSION        = B.CALC_VERSION
                                                        AND   A.E2000_PLAN_DATE     BETWEEN CONVERT(NVARCHAR(8), B.START_DATE, 112)
                                                                                    AND     CONVERT(NVARCHAR(8), B.END_DATE,   112)
                                                   left outer join (
                                                                    -- 최소 Batch size 정보
                                                                    SELECT LOOKUP_TYPE_CODE, segment2 as factory_id, segment3 as operation_id, convert(numeric(20,10), attribute1) as min_rate 
                                                                    FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
                                                                    WHERE  LOOKUP_TYPE_CODE LIKE 'MIN_BATCH_SIZE'
                                                                    AND    1=0      -- 2019.01.08 : MIN BATCH 조건 제외 요청
                                                                   ) c
                                                        on     a.after_site_id      = c.factory_id
         and    a.after_operation_id = c.operation_id
                                                   left outer join (
                                                                    -- 수량 상관없이 설비별 균등 배분위해서	-- (D240529~R240529.01)
                                                                    SELECT segment1 as instance_id, ISNULL(ATTRIBUTE3,'N') AS MIX_LOT_SIZE_EXCEPT 
                                                                    FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
                                                                    WHERE  LOOKUP_TYPE_CODE LIKE 'ELEC_INSTANCE_OPTION'
                                                                    AND    active_flag = 'Y'
                                                                   ) f
                                                        on     a.master_id      = f.instance_id
                                                 , (
                            select a.item_id, a.route_id, b.resource_id, a.month, a.alt_priority
                                                         , row_number() over ( partition by a.item_id, a.route_id, a.month order by a.ALT_PRIORITY, b.RESOURCE_ID ) as resource_seq 
                                                         , count(1)     over ( partition by a.item_id, a.route_id, a.month ) as resource_count 
                                                    from   (
                                                            select factory_id, item_id, operation_id, line_id as route_id, month, priority as alt_priority, active_flag 
                                                            from   (
                                                                    SELECT A.*
                                                                  FROM SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)  , SCM_LINE_M B WITH(NOLOCK)
                                                                    WHERE A.COMPANY_ID = B.COMPANY_ID 
                                                                    AND A.DIVISION_ID  = B.DIVISION_ID 
                                                                    AND A.SITE_ID = B.SITE_ID 
                                                                    AND A.PLANT_ID = B.PLANT_ID 
                                                                    AND A.FACTORY_ID = B.FACTORY_ID
                                                                    AND A.OPERATION_ID = B.OPERATION_ID 
                                                                    AND A.LINE_ID = B.LINE_ID 
                                                                    AND A.ELECTRODE_TYPE =  B.ELECTRODE_TYPE 
                                                                    AND A.ACTIVE_FLAG = 'Y'
                                                                    AND B.ACTIVE_FLAG = 'Y'
                                                                   )A
                                                            where  factory_id   = @v_factory_id
                                                            and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
                                                            --and    month        = @v_plan_month --'201707'
                                                            and    month        >= CONVERT(NVARCHAR(6), @v_plan_date, 112)
                                                            and    month        <= CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, @v_plan_date), 112)
                                                            and    active_flag  = 'Y'
                                                            --and item_id = 'ASLAN0823A'
                                                            and    priority in ( 1, 2, 3, 4, 5, 6, 7, 8 ) -- 미사용 Flag인것은 할당 제외 (0, 9,null)
                                                           ) a,
                                                           (
                                                            select factory_id, operation_id, equipment_id as resource_id, line_id as route_id, equipment_type, active_flag
                                                            from   scm_equipment_m WITH(NOLOCK)
                                                            where  equipment_type = 'M'
                                                            and    factory_id     = @v_factory_id
                                                            and    operation_id   in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
                                                            and    active_flag    = 'Y'
                                                           ) b
                                                    where  a.factory_id   = b.factory_id
and    a.operation_id = b.operation_id
                                                    and    a.route_id     = b.route_id
                                                   ) d
                                          WHERE   a.MASTER_ID     = @v_master_id
                                          AND     a.PLAN_ID       = @v_plan_id
                                          and     a.AFTER_SITE_ID = @v_factory_id
                                          --and     e2000_work_order_id = 'WP18B05CT#PE1#EB#02#0029'
                                          and     a.item_id        = d.item_id
                                          and     a.after_route_id = d.route_id
                                          AND     CHARINDEX(D.MONTH, A.E2000_PLAN_DATE) > 0 
                    ) a   
                                 ) a
                         ) a
                 ) a 
                 left outer join
                     (
                      -- * 수율 ( SCM_YIELD_M )
                      select factory_id, operation_id, line_id, item_id, month
                             , case when yield = null then 1
                                    when yield = 0    then 1
                                    else yield
                               end as E1000_YIELD 
                      from   SCM_YIELD_M WITH(NOLOCK)
                      where  1=0                          -- 2018.03.28 : Mixer 계획에서는 Yield 를 반영하지 않는다.  -- 20190225 Yield 반영 hssong
                      and    factory_id   = @v_factory_id
                      and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
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
          
          DELETE FROM TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY WHERE  INSERT_TIME < DATEADD(DAY, -7, GETDATE())

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
                  ,wo_day_split_yn,setup_time,setup_time_uom,batch_in_qty,batch_qty,ui_edit_yn,description,insert_id,insert_time,update_id,update_time
                  ,delete_yn
                  , WORK_REQUEST_MODEL_ID   -- (D221117~R230219.01)
	           	  , VERSION    -- (D221117~R230219.01)
	              --, PROD_SEQ    -- (D221117~R230219.01)
	              , PLM_EC_NO    -- (D221117~R230219.01)
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
                  , a.batch_in_qty,  a.batch_qty,     a.ui_edit_yn,    a.description
                  , @v_proc_name as insert_id, getdate() as insert_time
                  , @v_proc_name as update_id, getdate() as update_time
                  , a.E2000_work_order_id
                  , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
	     	  , A.VERSION    -- (D221117~R230219.01)
	              --, A.PROD_SEQ    -- (D221117~R230219.01)
	              , A.PLM_EC_NO    -- (D221117~R230219.01)
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
                          , a.batch_in_qty,  a.batch_qty,     a.ui_edit_yn,    a.description
                          , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
			           	  , A.VERSION    -- (D221117~R230219.01)
			              --, A.PROD_SEQ    -- (D221117~R230219.01)
			              , A.PLM_EC_NO    -- (D221117~R230219.01)
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
--                                                                               + ':' + SUBSTRING(a.E2000_START_TIME, 13, 2))
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
--                                    + ':' + SUBSTRING(a.E2000_START_TIME, 13, 2))
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
                                  , null as wo_day_split_yn, 0 as setup_time, 'SECOND' as setup_time_uom
                                  , case when a.batch_lot_size > 0 then a.after_in_qty / ceiling(a.batch_lot_size)
                                                                   else a.after_in_qty
                                    end  as batch_in_qty
                                  , case when a.batch_lot_size > 0 then a.after_qty / ceiling(a.batch_lot_size)
                                                                   else a.after_qty
                                    end  as batch_qty
                                  , null as ui_edit_yn, null as description
                                  , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
					           	  , A.VERSION    -- (D221117~R230219.01)
					              --, A.PROD_SEQ    -- (D221117~R230219.01)
					              , A.PLM_EC_NO    -- (D221117~R230219.01)
                          ------------------------------------------------------------------        
                          ------------------------------------------------------------------        
                          from   TH_BUF_E1000_PLAN_TARGET_E4 a
                          ------------------------------------------------------------------        
                          ------------------------------------------------------------------   
                                 /*
                                 left outer join SCM_OPERATION_MOVE_M c -- PRECEDE_PRODUCING_TERM
                                      on    a.after_operation_id = c.operation_id
                                      and   a.after_site_id      = c.factory_id
                               */
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
                              from   SCM_OPERATION_M WITH(NOLOCK)
                              where  operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
                         ) b
                             on   a.after_operation_id = b.operation_id
                         left outer join
                             (
                              -- 국가코드
                              select instance_id, key_value  
                              from   fp_instance_config_m WITH(NOLOCK)
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
                              from   FP_INSTANCE_CONFIG_M WITH(NOLOCK)
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
                              from   SCM_OPERATION_M WITH(NOLOCK)
                              where  operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
                         ) e
                             --on   a.after_operation_id = b.operation_id
                         on   a.after_operation_id = e.operation_id
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
                                   , a.E2000_item_id, a.item_id   -- 2018.07.25 : from_item_id, to_item_id 연결
                            from   (       
                                    select master_id, plan_id, after_site_id, after_operation_id, E2000_work_order_id, work_order_id
                                           , after_route_id
                               , E2000_item_id, item_id   -- 2018.07.25 : from_item_id, to_item_id 연결
                                           , row_number() over ( partition by master_id, plan_id, after_site_id, after_operation_id, E2000_work_order_id
                                                                            , E2000_item_id, item_id    -- 2018.07.25 : from_item_id, to_item_id 연결
                                                                 order by work_order_id ) seq
                                    from TH_BUF_E1000_PLAN_TARGET_E4
                                    where master_id        = @v_master_id
                                    and plan_id            = @v_plan_id
                                    and after_site_id      = @v_factory_id
                                    and after_operation_id  in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
                                    --and E2000_work_order_id in ( 'K117630CT0A9' )
                                   ) a 
                            ) a,
                            (
                            select a.instance_id , a.fp_plan_id, a.to_factory_id, a.to_operation_id, a.to_work_order_id, a.from_work_order_id
                                   , a.from_line_id, a.seq
                                   , a.from_item_id, a.to_item_id     -- 2018.07.25 : from_item_id, to_item_id 연결
                            from   (       
                                    select instance_id , fp_plan_id, to_factory_id, to_operation_id, to_work_order_id, from_work_order_id
                                           , from_line_id
                                           , from_item_id, to_item_id     -- 2018.07.25 : from_item_id, to_item_id 연결
                                           , row_number() over ( partition by instance_id , fp_plan_id, to_factory_id, to_operation_id, to_work_order_id
                                                                            , from_item_id, to_item_id     -- 2018.07.25 : from_item_id, to_item_id 연결
                                                                 order by from_work_order_id ) seq
                                    from FP_ORDER_PEGGING_R
                                where instance_id   = @v_master_id
                                    and fp_plan_id      = @release_plan_id
                                    and to_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 ) -- ## Coater  공정..!!
                                    and to_factory_id   = @v_factory_id
                                   ) a 
                           ) b
                    where  a.master_id = b.instance_id 
                    and    a.after_site_id       = b.to_factory_id
                    and    a.seq                 = b.seq
                    --and    a.after_route_id      = b.from_line_id
                    and    a.E2000_item_id       = b.to_item_id         -- 2018.07.25 : from_item_id, to_item_id 연결
                    and    a.item_id             = b.from_item_id       -- 2018.07.25 : from_item_id, to_item_id 연결
                    and    a.E2000_work_order_id = b.to_work_order_id
                 ) b
          where  a.master_id           = b.master_id
          and    a.plan_id             = b.plan_id
          and    a.work_order_id       = b.work_order_id
          and  a.master_id             = @v_master_id
          and    a.plan_id             = @v_plan_id
          and    a.after_site_id       = @v_factory_id            
          and    a.after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
          and    a.after_qty > 0
          and    a.fixed_yn = 'Y'
          and    b.fix_seq  = 1 -- 20180115 ksjeon add release pegging  에서 가져온 Mix의 Fix order가 두개의 COATER 와 맵핑되는 경우가 있어 방지함
          
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
--song
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
                        and    AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
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
          and   AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
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
                            and   AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
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
                    and    AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
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
          and     AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!

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
                        ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_IN_QTY,BATCH_QTY,UI_EDIT_YN
                        ,MARKET,TOP_ITEM_ID
                        ,DESCRIPTION,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
                        , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
			            , VERSION    -- (D221117~R230219.01)
			            --, PROD_SEQ    -- (D221117~R230219.01)
			            , PLM_EC_NO    -- (D221117~R230219.01)
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
                        ,SUM(a.batch_in_qty)    as batch_in_qty
                        ,SUM(a.batch_qty)       as batch_qty
                        ,min(a.ui_edit_yn)      as ui_edit_yn
                        --,a.market
                        ,min(a.market)          as market
                        ,min(A.TOP_ITEM_ID)     AS TOP_ITEM_ID
                        ,min(a.description)     as description
                        , @v_proc_name as insert_id, getdate() as insert_time
                        , @v_proc_name as update_id, getdate() as update_time
                        , MAX(WORK_REQUEST_MODEL_ID) AS WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
			            , MAX(VERSION) AS VERSION    -- (D221117~R230219.01)
			            --, MAX(PROD_SEQ) AS PROD_SEQ    -- (D221117~R230219.01)
			            , MAX(PLM_EC_NO) AS PLM_EC_NO    -- (D221117~R230219.01)
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
                              ,batch_in_qty,batch_qty
                              ,ui_edit_yn
                              ,market
                              ,TOP_ITEM_ID
                              ,description
                              , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
					          , VERSION    -- (D221117~R230219.01)
					          --, PROD_SEQ    -- (D221117~R230219.01)
					          , PLM_EC_NO    -- (D221117~R230219.01)
                      from TH_BUF_FP_AMEND_PROD_PLAN_R_MIX_MER_APPLY
                      where master_id      = @v_master_id
                      and   plan_id        = @v_plan_id
                      and   AFTER_SITE_ID  = @v_factory_id  
                      and   AFTER_OPERATION_ID in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- Mixer 공정..!!
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
                          and    after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- Mixer 공정..!!
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
                              and    from_operation_id  in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- Mixer 공정..!!
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
        --
        begin

          BEGIN
          
            SET @v_table_name = 'TH_BUF_FP_ORDER_PEGGING_R'
            
            DELETE FROM TH_BUF_FP_ORDER_PEGGING_R WHERE  INSERT_TIME < DATEADD(DAY, -7, GETDATE())

            DELETE FROM TH_BUF_FP_ORDER_PEGGING_R
            WHERE  instance_id     = @v_master_id
            and    fp_plan_id      = @v_plan_id
            and    to_factory_id   = @v_factory_id
            and    to_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 ) -- 'E2000'          

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
            and     to_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 ) -- 'E2000'          

            
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
            and    a.to_operation_id in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 ) -- 'E2000'          

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
                    and    after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 )
                   ) a 
                   left OUTER join
                          (
                           select * 
                           from   scm_factory_m WITH(NOLOCK)
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
                                           and    operation_id       in ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 ) -- 'E2000'          
                                          ) a
                                 ) a
                           where seq = 1
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
                           and    after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 )    
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
            and    a.after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 )
            
            SET @v_message = @@ROWCOUNT
            SET @v_table_name = 'FP_ORDER_PEGGING_R'
            SET @n_log_count = @n_log_count + 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
            
          END      
-- L 2419 조건              
        end  


        -- FP_ORDER_PEGGING_R Delete / Insert end

      end  

      ------------------------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------


      -------------------------------------------------
      -- fp_amend_production_plan_r.BATCH_ORDER_ID <- 머지한 merge_batch_order_id 를 쓰지 않고
      --                                              Batch_group_id 로 넣는 로직을 적용
      -------------------------------------------------
      IF   CHARINDEX('E_PRE',  @v_master_id ) > 0
        OR CHARINDEX('E_PMIX', @v_master_id ) > 0
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
                                from   scm_factory_m WITH(NOLOCK)     
                                where  factory_id = @v_factory_id -- 'E6'
                               ) a,
                               (
                                select *--item_id 
                                from   scm_batch_m WITH(NOLOCK)   
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
                  and    after_operation_id in ( @v_batch_id_merge_op1, @v_batch_id_merge_op2 )
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

      IF   CHARINDEX('E_PRE',  @v_master_id ) > 0 -- 오창말곤 필요없음./
      BEGIN
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

          IF @v_to_instance_key = 'CONSUME_DEMAND' AND @v_pmix_option != 'Y'
            BEGIN
            
              SET @v_table_name = 'FP_DAILY_INSTANCE_DEMAND_H'

              DELETE FROM FP_DAILY_INSTANCE_DEMAND_H WHERE INSERT_TIME < DATEADD(DAY, -30, GETDATE())

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
                              and    after_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 )    
                              and    after_site_id      = @v_factory_id
                              --and    item_id in ( 'ASLCA0227A' )  
                             ) a, 
                             ( 
                              SELECT AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID
                                   , AA.CHILD_QTY / AA.PARENT_QTY AS CONSUME_RATE
                              FROM   SCM_BOM_M AA WITH(NOLOCK) ,
                                     (
                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, 
                                             MIN(KEY_DATE) AS KEY_DATE
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
                                      AND    A.EFF_END_DATE   > @v_plan_date  --CONVERT(DATE, GETDATE())              
                                      GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                                      --GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                                     ) BB,
                                     SCM_ITEM_M        CC WITH(NOLOCK),
                                     SCM_ITEM_CLASS_M  DD WITH(NOLOCK),
                                     (
                                      SELECT A.ITEM_ID, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID
                                      FROM   TH_BUF_E1000_PLAN_TARGET A
                              , SCM_FACTORY_M            B WITH(NOLOCK)
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
                              AND    AA.EFF_END_DATE    >  @v_plan_date--CONVERT(DATE, GETDATE())
                              AND    AA.COMPANY_ID      = EE.COMPANY_ID
                              AND    AA.DIVISION_ID     = EE.DIVISION_ID
                              AND    AA.SITE_ID         = EE.SITE_ID
                              AND    AA.PLANT_ID        = EE.PLANT_ID
                              AND    AA.PARENT_ITEM_ID  = EE.ITEM_ID
                              --AND    ISNULL(ALT_PRIORITY, 1) = 1
                              and    DD.level_2_code    = 'ASL'
                              and    DD.level_3_code    = 'ASLPD'      -- pre mix 만 대상  
                              --and    DD.level_3_code    IN ('ASLPD','ASLPW')  -- 2018.12.10 : Pre Wetting Slurry 추가
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
                                 , CONVERT(VARCHAR, CONVERT(DATETIME, B.DUE_DATE, 20) , 112) + '060000' as DATE_YYMMDDHH24MISS
                                -- , dateadd(minute, 360, CONVERT(DATETIME, b.due_date, 20)) as date_yymmddhh24miss
                                 --, dateadd(minute, @n_day_diff, CONVERT(DATETIME, b.due_date, 20)) as date_yymmddhh24miss
                                 , CONVERT(varchar, CONVERT(DATETIME, b.due_date, 20) , 112) as date_yyyymmdd
                                 , row_number() over ( partition by a.instance_id, a.dpp_plan_id, b.factory_id, b.operation_id
                                                           order by a.scp_target_id, a.fp_demand_id ) as seq
                          from   dbo.fp_daily_net_demand_h a WITH(NOLOCK),
                                 dbo.fp_weekly_demand_product_test_h b WITH(NOLOCK)
                          where  a.instance_id     = @v_master_id
                          and    a.dpp_plan_id     = @v_plan_id
                          and    a.production_type = 'TEST'
                          and    a.scp_target_id like b.test_target_id +'%'
                          and    b.operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
                          and    isnull(a.work_order_id, '##') not in ( 
                                                                        select from_work_order_id 
                                                                        from   FP_ORDER_PEGGING_R
                                                                        where  instance_id   = @v_master_id
                                                                        and    fp_plan_id    = @v_plan_id
                                                                        and    to_factory_id = @v_factory_id
                                                                        and from_operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
                                                         ) 
                         ) a
                         inner join scm_item_m b WITH(NOLOCK)
                               on a.company_id   = b.company_id
                               and a.division_id = b.division_id
                               and a.site_id     = b.site_id
                               and a.item_id     = b.item_id
                         left outer join scm_batch_m c WITH(NOLOCK)
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
                              from   SCM_YIELD_M WITH(NOLOCK)
                              where  1=0                          -- 2018.03.28 : Mixer 계획에서는 Yield 를 반영하지 않는다.
                              and    factory_id   = @v_factory_id
                              and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
                           ) d
                               on   a.factory_id   = d.factory_id
                               and  a.operation_id = d.operation_id 
                               and  a.line_id      = d.line_id
                               and  a.item_id      = d.item_id
                               and  substring(CONVERT(varchar, CONVERT(DATETIME, a.due_date, 20) , 112), 1, 6) = d.month             
                           inner join
                               (
                                  -- 설비 할당
                                  select a.item_id, a.factory_id as site_id, a.route_id, a.operation_id, a.month, min(a.resource_id) as resource_group_id
                                  from   (
                                          select a.item_id, a.factory_id, a.route_id, a.operation_id, a.month, b.resource_id 
                                          from   (
                                                  select factory_id, item_id, operation_id, line_id as route_id, month, priority as alt_priority, active_flag 
                                                  from   (
                                                          SELECT A.*
                                                          FROM SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) , SCM_LINE_M B WITH(NOLOCK)
                                                          WHERE A.COMPANY_ID = B.COMPANY_ID 
                                                          AND A.DIVISION_ID  = B.DIVISION_ID 
                                                          AND A.SITE_ID = B.SITE_ID 
                                                          AND A.PLANT_ID = B.PLANT_ID 
                                                          AND A.FACTORY_ID = B.FACTORY_ID
                                                          AND A.OPERATION_ID = B.OPERATION_ID 
                                                          AND A.LINE_ID = B.LINE_ID 
                                                          AND A.ELECTRODE_TYPE =  B.ELECTRODE_TYPE 
                                                          AND A.ACTIVE_FLAG = 'Y'
                                                          AND B.ACTIVE_FLAG = 'Y'
                                                          )A
                                                  where  factory_id   = @v_factory_id
                                                  and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
                                                  --and    month        = @v_plan_month --'201707'
                                                  and    month        >= CONVERT(NVARCHAR(6), @v_plan_date, 112)
                                                  and    month        <= CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, @v_plan_date), 112)
                                                  and    active_flag  = 'Y'
                                                  --and item_id = 'ASLAN0823A'
                                                  and    priority in ( 1, 2, 3, 4, 5, 6, 7, 8 ) -- 미사용 Flag인것은 할당 제외 (0, 9,null)
                                                 ) a,
                                                 (
                                                  select factory_id, operation_id, equipment_id as resource_id, line_id as route_id, equipment_type, active_flag
                                                  from   SCM_equipment_M WITH(NOLOCK)
                                                  where  equipment_type = 'M'
                                                  and    factory_id     = @v_factory_id
                                                  and    operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
                                                  and    active_flag    = 'Y'
                                                 ) b
                                          where  a.factory_id   = b.factory_id
                                          and    a.operation_id = b.operation_id
                                          and    a.route_id     = b.route_id
                                         ) a
                                  group by a.item_id, a.factory_id, a.route_id, a.operation_id, a.month
                           ) e
                               on   a.operation_id = e.operation_id
                               and  a.factory_id   = e.site_id
                               and  a.line_id      = e.route_id
                               and  a.item_id      = e.item_id               
                               and  convert(nvarchar(6), a.due_date, 112) = e.month
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
                                from   SCM_OPERATION_M WITH(NOLOCK)
                                where  operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
                           ) f
                               on   a.operation_id = f.operation_id
                           left outer join
                               (
                                -- 국가코드
                                select instance_id, key_value  
                                from   fp_instance_config_m WITH(NOLOCK)
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
                                from   FP_INSTANCE_CONFIG_M WITH(NOLOCK)
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
                                from   SCM_OPERATION_M WITH(NOLOCK)
                                where  operation_id in ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## Mixer 공정..!!
                           ) i
                               on   a.operation_id = i.operation_id     
                           -- WO 생성용 Join
                           ---------------------------
                  ) a                 
                  inner join
                      -- seq로 WO seq 를 찾는다 
                      ( select order_no, order_id from FP_ORDER_SEQ WITH(NOLOCK)
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
                   , A.AFTER_SEQ 
                                                   , A.WORK_ORDER_ID
                                                   ) AS ORDER_SEQ
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
                               , A.WORK_ORDER_ID
                          FROM   FP_AMEND_PRODUCTION_PLAN_R A
                               , (
                                  SELECT A.FACTORY_ID, B.LINE_ID, B.ELECTRODE_TYPE, A.ITEM_ID
                                       , MAX(A.LANE_QTY) AS LANE_QTY
                                  FROM   SCM_ITEM_LANE_M  A WITH(NOLOCK)
                                       , SCM_LINE_M       B WITH(NOLOCK)
                                  WHERE  A.COMPANY_ID         = B.COMPANY_ID
                                  AND    A.DIVISION_ID        = B.DIVISION_ID
                                  AND    A.SITE_ID            = B.SITE_ID
                                  AND    A.PLANT_ID           = B.PLANT_ID
                                  AND    A.FACTORY_ID         = B.FACTORY_ID
                                  AND A.PROD_VERSION_TYPE  = B.PROD_VERSION_TYPE
                                  AND    A.HALF_SLIT_FLAG     = 'Y'
                                  AND    A.ACTIVE_FLAG        = 'Y'
                                  AND    B.ACTIVE_FLAG        = 'Y'
                                  GROUP  BY A.FACTORY_ID, B.LINE_ID, B.ELECTRODE_TYPE, A.ITEM_ID
                                 ) B
                               , (
                                  SELECT *
                                  FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                                  WHERE  ACTIVE_FLAG    = 'Y'
                                  AND    EQUIPMENT_TYPE = 'M'
                                  AND    OPERATION_ID   = 'E2500'
                                 ) C
                          WHERE  A.MASTER_ID          = @v_master_id
                          AND    A.PLAN_ID            = @v_plan_id
                          AND    A.AFTER_SITE_ID      = @v_factory_id
                          AND    A.AFTER_OPERATION_ID = 'E2000'
                          --AND    A.DEMAND_TYPE       <> 'TEST'          -- 2018.04.04 : TEST 는 HS 를 만들지 않는다.
                          AND    A.AFTER_SITE_ID      = B.FACTORY_ID
                          --AND    A.AFTER_ROUTE_ID     = B.LINE_ID       -- 동일한 line 이 존재하지 않는 경우가 있음
                          AND    A.ITEM_ID            = B.ITEM_ID
                          AND    A.LANE_TACT_QTY      = B.LANE_QTY
                          AND    A.AFTER_SITE_ID      = C.FACTORY_ID
          --AND    A.AFTER_ROUTE_ID     = C.LINE_ID       -- 동일한 line 이 존재하지 않는 경우가 있음
                          AND    B.FACTORY_ID         = C.FACTORY_ID      -- PROD_VERSION_TYPE 조건 처리를 위해
                          AND    B.LINE_ID            = C.LINE_ID         -- PROD_VERSION_TYPE 조건 처리를 위해
                          AND    B.ELECTRODE_TYPE     = C.ELECTRODE_TYPE  -- PROD_VERSION_TYPE 조건 처리를 위해
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
                               , A.OFFSET_SEQ + 10000         AS AFTER_SEQ          -- 위에 꺼랑 중복 방지 ( + 10000 )
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
                               , A.ITEM_ID   AS TOP_ITEM_ID
                               , A.WORK_ORDER_ID
                          FROM   FP_DAILY_DEMAND_OFFSET_H A WITH(NOLOCK)
                               , (
                                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, B.LINE_ID, A.ITEM_ID
                                       , MAX(LANE_QTY) AS LANE_QTY
                                  FROM   SCM_ITEM_LANE_M  A WITH(NOLOCK)
                                       , SCM_LINE_M       B WITH(NOLOCK)
                                  WHERE  A.COMPANY_ID         = B.COMPANY_ID
                                  AND    A.DIVISION_ID        = B.DIVISION_ID
                                  AND    A.SITE_ID            = B.SITE_ID
                                  AND    A.PLANT_ID           = B.PLANT_ID
                                  AND    A.FACTORY_ID         = B.FACTORY_ID
                                  AND    A.PROD_VERSION_TYPE  = B.PROD_VERSION_TYPE
                                  AND    A.ACTIVE_FLAG        = 'Y'
                                  AND    A.HALF_SLIT_FLAG     = 'Y'
                                  AND    B.ACTIVE_FLAG        = 'Y'
                                  GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, B.LINE_ID, A.ITEM_ID
                                 ) B
                               , (
                                  SELECT *
                                  FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                                  WHERE  ACTIVE_FLAG    = 'Y'
                                  AND    EQUIPMENT_TYPE = 'M'
                                  AND    OPERATION_ID   = 'E2500'
                                 ) C
                               , SCM_ITEM_M       D
                               , (
                                  SELECT DATE_ID, WEEK
                                       , CONVERT(NVARCHAR, DATE_ID, 112) PLAN_DATE
                                       , CONVERT(NVARCHAR, DATEADD(DAY, 1, DATE_ID), 112) NEXT_PLAN_DATE
                                  FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
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
                          AND    B.LINE_ID      = C.LINE_ID
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
          
          /*****************************************************************************
            오창제외 위에서 Slurry 생성까진 유지하고 선분산 ( PRE MIX ) work 생성
          *******************************************************************************/
          IF @v_pmix_option = 'Y' -- 1=1  --song 
          BEGIN
          
            DELETE FROM TH_BUF_E0500_PLAN_BOM WHERE  INSERT_TIME < DATEADD(DAY, -7, @v_plan_date) -- ADDSONG
            
            DELETE FROM TH_BUF_E0500_PLAN_BOM
            WHERE  MASTER_ID  = @v_master_id
            AND    PLAN_ID    = @v_plan_id
            AND    SITE_ID    = @v_factory_id

            SET @v_message = @@ROWCOUNT
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_E0500_PLAN_BOM', 'DELETE', @n_log_count, null, @v_message, null 
            
             -- ADDSONG
            -- 2020/10/07 선분산 대치 자재 WO 생성 추가 수정 BY CGJ
            INSERT INTO TH_BUF_E0500_PLAN_BOM
                 (
                   MASTER_ID
                 , PLAN_ID
                 , SITE_ID
                 , PARENT_ITEM_ID
                 , CHILD_ITEM_ID
                 , ALT_ID
                 , ALT_PRIORITY
           , PARENT_ITEM_RATE
                 , CHILD_ITEM_RATE
                 , ROUTE_ID
                 , INSERT_TIME
				 , EFF_START_DATE	-- (D20221007-R01007.01) 
				 , EFF_END_DATE		-- (D20221007-R01007.01) 
                 )
            SELECT DISTINCT
                   @V_MASTER_ID   AS MASTER_ID
                 , @V_PLAN_ID     AS PLAN_ID
                 , EE.FACTORY_ID  AS SITE_ID
                 , AA.PARENT_ITEM_ID
                 , AA.CHILD_ITEM_ID
                 , CASE WHEN EE.ALT_WO_CREATE = 'Y' THEN NULL ELSE AA.ALT_ID END AS ALT_ID				-- (D20201005-R01013.01)
                 , CASE WHEN EE.ALT_WO_CREATE = 'Y' THEN NULL ELSE AA.ALT_PRIORITY END AS ALT_PRIORITY  -- (D20201005-R01013.01)               
--                 , AA.ALT_ID
--                 , AA.ALT_PRIORITY
                 , AA.PARENT_QTY / AA.PARENT_QTY AS PARENT_ITEM_RATE
                 , AA.CHILD_QTY  / AA.PARENT_QTY AS CHILD_ITEM_RATE
                 , EE.LINE_ID     AS ROUTE_ID
                 , GETDATE()      AS INSERT_TIME
				 , AA.EFF_START_DATE	-- (D20221007-R01007.01) 
				 , AA.EFF_END_DATE		-- (D20221007-R01007.01) 
                -- , DD.level_3_code
            FROM   SCM_BOM_M AA,
                   (
                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, 
                           MIN(KEY_DATE) AS KEY_DATE
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
                    AND    A.EFF_END_DATE   > @v_plan_date -- CONVERT(DATE, GETDATE())             
                    AND    B.ITEM_TYPE      <> 'R'
                    GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.KEY_DATE
                   ) BB,
                   SCM_ITEM_M        CC WITH(NOLOCK),
                   SCM_ITEM_CLASS_M  DD WITH(NOLOCK),
                   (	-- (D20201005-R01013.01)
						SELECT  B.SEGMENT1 		AS  COMPANY_ID ,
								B.SEGMENT2 		AS  DIVISION_ID , 
								B.SEGMENT3 		AS  SITE_ID , 
								B.SEGMENT4 		AS  PLANT_ID , 
								B.SEGMENT5 		AS  FACTORY_ID ,
								A.CHILD_ITEM_ID 	AS ITEM_ID , 
								A.ROUTE_ID   		AS LINE_ID,
								B.ATTRIBUTE2 		AS  ALT_WO_CREATE
						FROM  	TH_BUF_E1000_PLAN_BOM A ,
								SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK) 
						WHERE 	A.MASTER_ID = @v_master_id 
						AND		A.PLAN_ID = @v_plan_id 
						AND   	B.LOOKUP_TYPE_CODE = 'CREATE_ALT_WO_E_PRE'
						AND		A.MASTER_ID = B.ATTRIBUTE1 
						AND		B.ACTIVE_FLAG = 'Y'   
						AND 	B.SEGMENT5 = @v_factory_id
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
            AND    AA.EFF_END_DATE    >  @v_plan_date -- CONVERT(DATE, GETDATE())
            AND    AA.COMPANY_ID      = EE.COMPANY_ID
            AND    AA.DIVISION_ID     = EE.DIVISION_ID
            AND    AA.SITE_ID         = EE.SITE_ID
            AND    AA.PLANT_ID        = EE.PLANT_ID
            AND    AA.PARENT_ITEM_ID  = EE.ITEM_ID
            AND    DD.level_3_code    IN ('ASLPD','ASLPW')  -- [ASLPD] Pre Dispersion Slurry , [ASLPW]Pre Wetting Slurry
            
            SET @v_message = @@ROWCOUNT
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_E0500_PLAN_BOM', 'INSERT', @n_log_count, null, @v_message, null
            
            UPDATE  TH_BUF_E0500_PLAN_BOM 
            SET   TH_BUF_E0500_PLAN_BOM.VIRTUAL_INLINE_ROUTE =  A.SEGMENT4 -- 해당 라인기준 Pre mix work 생성 
            FROM  SCM_SYS_LOOKUP_VALUE A
            WHERE TH_BUF_E0500_PLAN_BOM.MASTER_ID = @v_master_id
            AND		  TH_BUF_E0500_PLAN_BOM.PLAN_ID = @v_plan_id
            AND		  A.LOOKUP_TYPE_CODE = 'ELECTRODE_VIRTUAL_INLINE'
			AND		  A.ACTIVE_FLAG = 'Y'	-- add 20240523
            AND		  TH_BUF_E0500_PLAN_BOM.SITE_ID  = A.ATTRIBUTE3
            AND		  TH_BUF_E0500_PLAN_BOM.ROUTE_ID = A.SEGMENT2
            
            SET @v_message = @@ROWCOUNT
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_E0500_PLAN_BOM', 'UPDATE', @n_log_count, null, @v_message, null
            
            UPDATE  TH_BUF_E0500_PLAN_BOM 
            SET     VIRTUAL_INLINE_ROUTE = ROUTE_ID
            WHERE   MASTER_ID = @v_master_id
            AND		  PLAN_ID = @v_plan_id
            AND     VIRTUAL_INLINE_ROUTE IS NULL    
            
            SET @v_table_name = 'TH_BUF_E0500_PLAN_TARGET'
          
            DELETE FROM TH_BUF_E0500_PLAN_TARGET
            WHERE  MASTER_ID     = @v_master_id
            AND    PLAN_ID       = @v_plan_id
            AND    AFTER_SITE_ID = @v_factory_id

            SET @v_message = @@ROWCOUNT
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_E0500_PLAN_TARGET', 'DELETE', @n_log_count, null, @v_message, null 
            
            INSERT INTO TH_BUF_E0500_PLAN_TARGET
                  (
                    MASTER_ID
                   ,PLAN_ID
                   ,E2000_WORK_ORDER_ID
                   ,E1000_WORK_ORDER_ID
                   ,WORK_ORDER_ID
                   ,AFTER_SITE_ID
                   ,AFTER_ROUTE_ID
                   ,AFTER_OPERATION_ID
                   ,AFTER_RESOURCE_ID
                   ,AFTER_PLAN_DATE
                   ,AFTER_START_TIME
                   ,AFTER_END_TIME
            ,AFTER_QTY
                   ,AFTER_IN_QTY
                   ,ITEM_ID,DEMAND_ID
                   ,DEMAND_TYPE
                   ,MARKET,TOP_ITEM_ID
                   ,E1000_START_TIME
                   ,E1000_END_TIME
                   ,E1000_PLAN_DATE
                   ,E1000_ITEM_ID
                   ,FIXED_YN
                   ,E1000_ORG_QTY
                   ,ORG_QTY
                   ,R
                   ,ACU_ORG_QTY
                   ,STOCK_QTY
                   ,REMAIN_QTY
                   ,PLAN_QTY
                   ,INSERT_ID,INSERT_TIME
                   ,E1000_FACTORY_ID
                   ,E1000_LINE_ID
                   ,E1000_OPERATION_ID
                   ,E1000_EQUIPMENT_ID
                   ,CHILD_ITEM_RATE
                   ,CALC_TYPE
                   ,CALC_VERSION
                   ,E0500_LINE_ID
                   , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
		           , VERSION    -- (D221117~R230219.01)
		           --, PROD_SEQ    -- (D221117~R230219.01)
		           , PLM_EC_NO    -- (D221117~R230219.01)
                  )
            SELECT  A.MASTER_ID
                  , A.PLAN_ID
                  , E2000_WORK_ORDER_ID
                  , A.E1000_WORK_ORDER_ID
               --, REPLACE(A.E1000_WORK_ORDER_ID, @V_COAT_MID_CHAR, @V_MIX_MID_CHAR) AS  WORK_ORDER_ID -- CT -> MX
                  , (
                     REPLACE( SUBSTRING(A.E1000_WORK_ORDER_ID, 1, CHARINDEX((CASE WHEN ISNULL(@v_mix_mid_op2,'0000') = a.after_operation_id THEN @v_mix_mid_char2 ELSE @v_mix_mid_char END), A.E1000_WORK_ORDER_ID)+1), (CASE WHEN @v_mix_mid_op2 = a.after_operation_id THEN @v_mix_mid_char2 ELSE @v_mix_mid_char END), @v_pmix_mid_char)			--  (D240829~R240829.01)
                     +
        SUBSTRING(A.E1000_WORK_ORDER_ID, CHARINDEX((CASE WHEN ISNULL(@v_mix_mid_op2,'0000') = a.after_operation_id THEN @v_mix_mid_char2 ELSE @v_mix_mid_char END), A.E1000_WORK_ORDER_ID)+2, 100) 
                     + WORK_ORDER_POST_STR
                    ) AS  WORK_ORDER_ID -- MX -> PM
                   , A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_OPERATION_ID
                   , A.AFTER_RESOURCE_ID -- NULL
                   , A.AFTER_PLAN_DATE   -- NULL
                   , A.AFTER_START_TIME  -- NULL
                   , A.AFTER_END_TIME    -- NULL
                   , A.AFTER_QTY 
                   , A.AFTER_IN_QTY
                   , A.ITEM_ID
                   , A.DEMAND_ID
                   , A.DEMAND_TYPE
                   , A.MARKET
                   , A.TOP_ITEM_ID
                   , A.E1000_START_TIME
                   , A.E1000_END_TIME
                   , A.E1000_PLAN_DATE
                   , A.E1000_ITEM_ID
                   , A.FIXED_YN
                   , A.E1000_AFTER_IN_QTY AS E1000_ORG_QTY -- E1000->AFTER_IN_QTY 수량
                   , A.ORG_QTY -- CONSUME RATE 적용 ( E0500의 필요량 ) 
                   , A.R
                   , A.ACU_ORG_QTY
                   , A.STOCK_QTY
                   , A.ACU_ORG_QTY - A.STOCK_QTY AS REMAIN_QTY
                   -- 재고 차감후 생산 계획 수량
                   , CASE WHEN ( A.ACU_ORG_QTY - A.STOCK_QTY ) <= 0 
                          THEN 0                                                             -- 전량 차감건
                          ELSE ( CASE WHEN ( A.ORG_QTY - (A.ACU_ORG_QTY - A.STOCK_QTY) ) > 0  
                                      THEN ( (A.ACU_ORG_QTY - A.STOCK_QTY) )                 -- 일부차감 -> 잔량 있는건 ( 원수량 - 차감잔량 )
                                      ELSE A.ORG_QTY                                         -- 차감되지 않은건 ( 원수량유지 )
                                  END  )
                     END  
                     AS PLAN_QTY
                   , @v_proc_name AS INSERT_ID
                   , GETDATE()    AS INSERT_TIME
                   , A.E1000_FACTORY_ID
                   , A.E1000_LINE_ID
                   , A.E1000_OPERATION_ID
                   , A.E1000_EQUIPMENT_ID
                   , A.CHILD_ITEM_RATE
                   , A.CALC_TYPE
                   , A.CALC_VERSION
                   , A.VIRTUAL_INLINE_ROUTE
                   , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
		           , A.VERSION    -- (D221117~R230219.01)
		           --, A.PROD_SEQ    -- (D221117~R230219.01)
		           , A.PLM_EC_NO    -- (D221117~R230219.01)
          FROM   (
                  SELECT A.MASTER_ID, A.PLAN_ID, E2000_WORK_ORDER_ID , A.E1000_WORK_ORDER_ID, A.AFTER_SITE_ID, A.VIRTUAL_INLINE_ROUTE AS AFTER_ROUTE_ID, A.AFTER_OPERATION_ID
                         , NULL   AS AFTER_RESOURCE_ID -- NULL
                         , NULL   AS AFTER_PLAN_DATE   -- NULL
                         , NULL   AS AFTER_START_TIME  -- NULL
                         , NULL   AS AFTER_END_TIME    -- NULL
                         , A.E1000_AFTER_IN_QTY * A.CHILD_ITEM_RATE                     AS AFTER_QTY
                         , ( A.E1000_AFTER_IN_QTY * A.CHILD_ITEM_RATE ) AS AFTER_IN_QTY --  / ISNULL(C.E1000_YIELD, 1)
                         , A.ITEM_ID
                         , A.DEMAND_ID
                         , A.DEMAND_TYPE
                         , A.MARKET
                         , A.TOP_ITEM_ID
                         , A.E1000_START_TIME
  , A.E1000_END_TIME
                         , A.E1000_PLAN_DATE
                         , A.E1000_ITEM_ID
                         , A.FIXED_YN
                         , A.E1000_AFTER_IN_QTY      -- E1000->AFTER_IN_QTY 수량
                         -- , D.E1000_YIELD, C.E1000_YIELD, A.CHILD_ITEM_RATE
                         -- MIXER QTY = (COATER PLAN QTY / COATER YIELD * CHILD RATE(BOM))/ MIXER YIELD
                         , ( A.E1000_AFTER_IN_QTY * A.CHILD_ITEM_RATE )  AS ORG_QTY -- CONSUME RATE 적용 ( E0500의 필요량 ) --/ ISNULL(C.E1000_YIELD, 1)
                         , DENSE_RANK() OVER( PARTITION BY A.MASTER_ID, A.PLAN_ID, A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_OPERATION_ID, A.ITEM_ID, A.DEMAND_TYPE, A.MARKET
                                                  ORDER BY A.E1000_ITEM_ID, A.E1000_PLAN_DATE, A.E1000_WORK_ORDER_ID ) 
                           AS R
                         , SUM( A.E1000_AFTER_IN_QTY * A.CHILD_ITEM_RATE ) OVER( PARTITION BY A.MASTER_ID, A.PLAN_ID, A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_OPERATION_ID, A.ITEM_ID, A.DEMAND_TYPE, A.MARKET
                                                    ORDER BY A.E1000_ITEM_ID, A.E1000_PLAN_DATE, A.E1000_WORK_ORDER_ID ) 
                           AS ACU_ORG_QTY
                         , ISNULL(B.STOCK_QTY, 0) AS STOCK_QTY 
                         , B.FP_APPLY_ITEM_ID 
                         --, (CASE WHEN A.ALT_ID IS NOT NULL THEN A.ORD_PRIORITY ELSE 1 END) AS ORD_PRIORITY
                         --, (CASE WHEN A.ALT_ID IS NOT NULL THEN '' ELSE CONVERT(NVARCHAR(10), A.ORD_PRIORITY) END) WORK_ORDER_POST_STR
                         , CASE WHEN A.PROD_CNT > 0 AND A.RNK IS NULL THEN 9 ELSE (CASE WHEN A.ALT_ID IS NOT NULL THEN A.NEW_ORD_PRIORITY ELSE 1 END) END AS ORD_PRIORITY --작업지시서 기준으로 한 후 없으면 BOM 기준으로 생성	-- (D20250319~R0319.01) PDS2 PDS2
                         , (CASE WHEN A.ALT_ID IS NOT NULL THEN '' ELSE CONVERT(NVARCHAR(10), A.NEW_ORD_PRIORITY) END) WORK_ORDER_POST_STR	-- (D20250319~R0319.01) PDS2 PDS2
                         , A.E1000_FACTORY_ID
                         , A.E1000_LINE_ID
                         , A.E1000_OPERATION_ID
                         , A.E1000_EQUIPMENT_ID
                         , A.CHILD_ITEM_RATE
                         , A.CALC_TYPE
                         , A.CALC_VERSION
                         , A.VIRTUAL_INLINE_ROUTE
                         , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
				         , A.VERSION    -- (D221117~R230219.01)
				         --, A.PROD_SEQ    -- (D221117~R230219.01)
				         , A.PLM_EC_NO   -- (D221117~R230219.01)
                  FROM   (		-- (D20250319~R0319.01) PDS2
                  				SELECT 	A.*
              							, ROW_NUMBER() OVER ( 	PARTITION BY A.E1000_ITEM_ID, A.E1000_WORK_ORDER_ID , A.ALT_ID 
																ORDER BY ISNULL(EE.RNK,9), A.ORD_PRIORITY, A.ITEM_ID) AS NEW_ORD_PRIORITY	-- 작업지시서에 동시 들어 있을 경우 작업지시서 먼저 보고 Priority 를 보도록 개선
										  , EE.RNK
										  , FF.PROD_CNT	-- 작업지시서 존재 여부
              					FROM	(			
					                          SELECT	A.MASTER_ID ,
					                          			A.PLAN_ID , 
														E2000_WORK_ORDER_ID ,
					                          			MAX(A.E1000_WORK_ORDER_ID) AS E1000_WORK_ORDER_ID,
					                          			A.AFTER_SITE_ID , 
					                 			A.AFTER_ROUTE_ID , 
					                          			A.AFTER_OPERATION_ID , 
					                          			A.ITEM_ID ,
					                          			MAX(A.DEMAND_ID) AS DEMAND_ID ,
					                          			A.DEMAND_TYPE, 
					                          			--CASE WHEN @v_master_id = 'CN_E_PRE_M' THEN 'D' ELSE A.MARKET END AS MARKET, 
														A.MARKET ,                                 --- (20190717) Modify Market Info.
					                          			A.TOP_ITEM_ID , 
					            			A.E1000_START_TIME, 
					                          			A.E1000_END_TIME,
														A.E1000_PLAN_DATE,
														A.E1000_ITEM_ID,
														A.FIXED_YN,
														SUM(A.E1000_AFTER_IN_QTY) AS E1000_AFTER_IN_QTY, 
														A.ALT_PRIORITY ,
														A.PARENT_ITEM_RATE, 
														A.CHILD_ITEM_RATE,
														ROW_NUMBER() OVER (ORDER BY MAX(A.ORD_PRIORITY)) AS ORD_PRIORITY , 
														A.ALT_ID,
														A.E1000_FACTORY_ID,
														A.E1000_LINE_ID,
														A.E1000_OPERATION_ID,
														NULL AS E1000_EQUIPMENT_ID,
														A.CALC_TYPE,
														A.CALC_VERSION,
														A.VIRTUAL_INLINE_ROUTE
														, A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
												        , A.VERSION    -- (D221117~R230219.01)
												        --, A.PROD_SEQ    -- (D221117~R230219.01)
												        , A.PLM_EC_NO    -- (D221117~R230219.01)
					         FROM (
					                                SELECT   A.MASTER_ID
					         , A.PLAN_ID
					                                       , D.E2000_WORK_ORDER_ID  AS E2000_WORK_ORDER_ID 
					                                       , A.WORK_ORDER_ID    AS E1000_WORK_ORDER_ID
					                                       , A.AFTER_SITE_ID
					                                       , A.AFTER_ROUTE_ID      -- E1000 의 LINE
					                                       , CASE WHEN A.AFTER_OPERATION_ID = 'E1000' THEN 'E0500'
					                                              ELSE 'XXXX'
					                                         END  AS AFTER_OPERATION_ID
					         , B.CHILD_ITEM_ID    AS ITEM_ID
					                                       , A.DEMAND_ID
					                                       , A.DEMAND_TYPE
					                                       , A.MARKET
					                                       , A.TOP_ITEM_ID
					                                       , A.AFTER_START_TIME AS E1000_START_TIME
					                                       , A.AFTER_END_TIME   AS E1000_END_TIME
					                                       , A.AFTER_PLAN_DATE  AS E1000_PLAN_DATE
					                                       , A.ITEM_ID          AS E1000_ITEM_ID
					                                       , A.FIXED_YN
					                                       , A.AFTER_IN_QTY     AS E1000_AFTER_IN_QTY
					                                       , B.ALT_PRIORITY 
					                                       , B.PARENT_ITEM_RATE, B.CHILD_ITEM_RATE
					                                       --, ROW_NUMBER() OVER ( PARTITION BY A.ITEM_ID, A.WORK_ORDER_ID ORDER BY B.ALT_PRIORITY, B.CHILD_ITEM_ID) AS ORD_PRIORITY
					                                       , ROW_NUMBER() OVER ( PARTITION BY A.ITEM_ID, A.WORK_ORDER_ID ORDER BY ISNULL(EE.REPLACE_ALT_PRIORITY,9),  B.ALT_PRIORITY, B.CHILD_ITEM_ID) AS ORD_PRIORITY		--  (D240904~R240905.01) BOM alt priority 보다 lookup 기준으로 본다.
					                                       , B.ALT_ID
					                                       , A.AFTER_SITE_ID      AS E1000_FACTORY_ID
					                           , A.AFTER_ROUTE_ID     AS E1000_LINE_ID
					                                       , A.AFTER_OPERATION_ID AS E1000_OPERATION_ID
					                                       , A.AFTER_RESOURCE_ID  AS E1000_EQUIPMENT_ID
					                                       , A.CALC_TYPE
					                                       , A.CALC_VERSION
					                                       , B.VIRTUAL_INLINE_ROUTE
					                                       , (CASE WHEN @v_pmix_instruction_flag = 'Y' THEN A.WORK_REQUEST_MODEL_ID ELSE '-' END) AS WORK_REQUEST_MODEL_ID --@@@ PDS2
					                                       , (CASE WHEN @v_pmix_instruction_flag = 'Y' THEN A.VERSION ELSE '-' END) AS VERSION --@@@ PDS2
					                                       , (CASE WHEN @v_pmix_instruction_flag = 'Y' THEN A.PLM_EC_NO ELSE '-' END) AS PLM_EC_NO --@@@ PDS2
					                                       --, A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
													       --, A.VERSION    -- (D221117~R230219.01)
													       --, A.PROD_SEQ    -- (D221117~R230219.01)
													       --, A.PLM_EC_NO    -- (D221117~R230219.01)
					                                FROM    FP_AMEND_PRODUCTION_PLAN_R A
					                                		INNER JOIN TH_BUF_E0500_PLAN_BOM B
					                                    	ON     A.MASTER_ID          = B.MASTER_ID
					                      					AND    A.PLAN_ID            = B.PLAN_ID
					                      					AND    A.AFTER_SITE_ID      = B.SITE_ID
					                      					AND    A.ITEM_ID            = B.PARENT_ITEM_ID
					                      					AND    A.AFTER_ROUTE_ID     = B.ROUTE_ID
															AND    CONVERT(DATETIME,A.AFTER_PLAN_DATE)   >= B.EFF_START_DATE	-- (D20221007-R01007.01)
															AND    CONVERT(DATETIME,A.AFTER_PLAN_DATE)   < B.EFF_END_DATE		-- (D20221007-R01007.01) 
					                  						LEFT OUTER JOIN (
																	SELECT A.*
																	FROM SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) , SCM_LINE_M B WITH(NOLOCK)
																	WHERE A.COMPANY_ID = B.COMPANY_ID 
																	AND A.DIVISION_ID  = B.DIVISION_ID 
																	AND A.SITE_ID = B.SITE_ID 
																	AND A.PLANT_ID = B.PLANT_ID 
																	AND A.FACTORY_ID = B.FACTORY_ID
																	AND A.OPERATION_ID = B.OPERATION_ID 
																	AND A.LINE_ID = B.LINE_ID 
																	AND A.ELECTRODE_TYPE =  B.ELECTRODE_TYPE 
																	AND A.ACTIVE_FLAG = 'Y'
																	AND B.ACTIVE_FLAG = 'Y'
					                                        ) C  -- LOOKUP 정의 데이터도 추가해야함.
					                      					ON     B.CHILD_ITEM_ID      = C.ITEM_ID
					                      					AND    B.SITE_ID            = C.FACTORY_ID
					                      					AND    B.VIRTUAL_INLINE_ROUTE  = C.LINE_ID
					                   					AND    C.ACTIVE_FLAG        = 'Y'
					                      					AND    C.PRIORITY           IN ( 1,2,3,4,5,6,7,8)
					                      					AND    C.MONTH            = SUBSTRING(A.AFTER_PLAN_DATE, 1, 6)
					                                        LEFT OUTER  JOIN TH_BUF_E1000_PLAN_TARGET_E4 D
					                      					ON 		A.MASTER_ID = D.MASTER_ID
					                      					AND		A.PLAN_ID = D.PLAN_ID
					                      					AND		A.WORK_ORDER_ID = D.WORK_ORDER_ID
					                      					LEFT OUTER JOIN (		--  (D240904~R240905.01)
																				SELECT  B.SEGMENT1 		AS  INSTANCE_ID ,
																						B.SEGMENT2 		AS  DIVISION_ID , 
																						B.SEGMENT3 		AS  PLANT_ID , 
																						B.SEGMENT4 		AS  FACTORY_ID , 
																						B.SEGMENT5 		AS  E0500_LINE_ID ,
																						B.ATTRIBUTE1	AS  E1000_ITEM_ID ,
																						B.ATTRIBUTE2	AS  E0500_ITEM_ID ,
																						B.ATTRIBUTE3	AS  REPLACE_ALT_PRIORITY 
																				FROM  	SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK) 
																				WHERE 	1=1
																				AND   	B.LOOKUP_TYPE_CODE = 'REPLACE_ALT_BOM_PRE_MIX'
																				AND		B.SEGMENT1 = @v_master_id
																				AND 	B.SEGMENT4 = @v_factory_id
																				AND		B.ACTIVE_FLAG = 'Y'   
																		   ) EE
															ON	1=1
															AND A.MASTER_ID 	= EE.INSTANCE_ID
															AND A.AFTER_SITE_ID = EE.FACTORY_ID
															AND B.VIRTUAL_INLINE_ROUTE = EE.E0500_LINE_ID
															AND A.ITEM_ID 		= EE.E1000_ITEM_ID
															AND B.CHILD_ITEM_ID = EE.E0500_ITEM_ID
					                                WHERE  A.MASTER_ID          = @v_master_id
					                    AND    A.PLAN_ID            = @v_plan_id
					                                AND    A.AFTER_SITE_ID      = @v_factory_id
					                                AND    A.AFTER_OPERATION_ID IN ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## COATER  공정..!!   
					                                AND    NOT EXISTS (		SELECT ITEM_ID 
																			FROM   SCM_ITEM_LINE_ASSIGN_EXCEPT_M  X WITH(NOLOCK)
																			WHERE  1=1
																			AND    X.ITEM_ID        = C.ITEM_ID
																			AND    X.FACTORY_ID     = C.FACTORY_ID
																			AND    X.LINE_ID        = C.LINE_ID
																			AND    X.OPERATION_ID   = C.OPERATION_ID
																			AND    X.ELECTRODE_TYPE = C.ELECTRODE_TYPE
																			AND    X.START_TIME    <= CONVERT(DATE, A.AFTER_PLAN_DATE)
																			AND    X.END_TIME      >= CONVERT(DATE, A.AFTER_PLAN_DATE)
																			AND    (
																			          X.ACTIVE_FLAG = 'N'
																			          OR
																			          X.PRIORITY    = 0
																			          OR
																			          X.PRIORITY    = 9
																			       )
					                                                    )
													AND	C.PRIORITY IS NOT NULL 		-- line assine 에서 걸러낸 품목이 1순위가 되어서 final 에서 들어오지 못함 20200714 cys
					                                  )A
					                          WHERE (A.ALT_ID IS NOT NULL AND  A.ORD_PRIORITY = 1) OR A.ALT_ID IS NULL      
					                          GROUP BY  A.MASTER_ID ,
					                          			A.PLAN_ID , 
					                                    A.E2000_WORK_ORDER_ID,
					                          			-- MAX(E1000_WORK_ORDER_ID) ,
					                          			A.AFTER_SITE_ID , 
					                          			A.AFTER_ROUTE_ID , 
					                          			A.AFTER_OPERATION_ID , 
					                          			A.ITEM_ID ,
					                          			--MAX(A.DEMAND_ID) ,
					                          			A.DEMAND_TYPE, 
					                          			A.MARKET, 
					                          			A.TOP_ITEM_ID , 
					                          			A.E1000_START_TIME, 
					   			A.E1000_END_TIME,
					        			                A.E1000_PLAN_DATE,
					        			                A.E1000_ITEM_ID,
					        			                A.FIXED_YN,
					        			                --SUM(A.E1000_AFTER_IN_QTY), 
					        			                A.ALT_PRIORITY ,
					        			                A.PARENT_ITEM_RATE, 
					        			                A.CHILD_ITEM_RATE,
					        			                A.ALT_ID,
					        			                A.E1000_FACTORY_ID,
					        			                A.E1000_LINE_ID,
					        			                A.E1000_OPERATION_ID,
					        			                A.CALC_TYPE,
					        			                A.CALC_VERSION,
					                                    A.VIRTUAL_INLINE_ROUTE
					                                    , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
												        , A.VERSION    -- (D221117~R230219.01)
												        --, A.PROD_SEQ    -- (D221117~R230219.01)
												        , A.PLM_EC_NO    -- (D221117~R230219.01)
								) A
								LEFT OUTER JOIN (
													SELECT 	*
													FROM 	(
																SELECT 	DISTINCT A.SITE_ID AS FACTORY_ID
																		, A.PARENT_ITEM_ID AS PANCAKE_ID
																		, A.CHILD_ITEM_ID AS SLURRY_ID
																		, B.MODEL_ID, B.PROD_VERSION_TYPE, B.PROD_VERSION
																		, RANK() OVER (PARTITION BY A.SITE_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, B.MODEL_ID, B.PROD_VERSION_TYPE, B.PROD_VERSION 
																					--ORDER BY B.PROD_SEQ DESC) AS RNK
																						ORDER BY B.APPLY_DATE DESC, B.PROD_VERSION DESC, B.PROD_SEQ DESC ) AS RNK
																FROM 	TH_BUF_E0500_PLAN_BOM A,
																		FP_PROD_VERSION_M B,
																		FP_PROD_VERSION_M D
																WHERE 	1=(CASE WHEN @v_pmix_instruction_flag = 'Y' THEN 1 ELSE 0 END)
																AND 	A.MASTER_ID = @v_master_id
																AND 	A.PLAN_ID = @v_plan_id
																AND     A.SITE_ID = @v_factory_id
																AND 	A.SITE_ID = B.FACTORY_ID 
																AND 	A.PARENT_ITEM_ID = B.ITEM_ID 
																AND 	B.COMPANY_ID = D.COMPANY_ID 
																AND 	B.DIVISION_ID = D.DIVISION_ID
																AND 	B.SITE_ID = D.SITE_ID
																AND 	B.PLANT_ID = D.PLANT_ID 
																AND 	B.FACTORY_ID = D.FACTORY_ID 
																AND 	B.MODEL_ID = D.MODEL_ID 
																AND 	B.PROD_VERSION_TYPE = D.PROD_VERSION_TYPE 
																AND 	B.PROD_VERSION = D.PROD_VERSION 
																AND 	B.PROD_SEQ = D.PROD_SEQ 
																AND 	A.CHILD_ITEM_ID = D.ITEM_ID
																--AND		A.ALT_ID IS NOT NULL	-- 대치 ITEM 만 적용
															) B
													WHERE 	1=1
													AND 	B.RNK =1
									) EE
									ON 1=1
									AND EE.FACTORY_ID	= A.AFTER_SITE_ID
									and EE.PANCAKE_ID   = A.E1000_item_id
									and EE.SLURRY_ID    = A.ITEM_ID
									AND EE.MODEL_ID		= A.WORK_REQUEST_MODEL_ID
									AND EE.PROD_VERSION	= A.VERSION
								
									LEFT OUTER JOIN (
														SELECT  M.MASTER_ID, M.PLAN_ID, M.AFTER_SITE_ID, M.AFTER_ROUTE_ID, M.ITEM_ID, M.AFTER_PLAN_DATE, M.AFTER_OPERATION_ID, M.WORK_REQUEST_MODEL_ID, M.VERSION, COUNT(*) AS PROD_CNT
														FROM 	FP_AMEND_PRODUCTION_PLAN_R M WITH(NOLOCK) ,
																TH_BUF_E0500_PLAN_BOM A,
																FP_PROD_VERSION_M B,
																FP_PROD_VERSION_M D
														WHERE 	1=(CASE WHEN @v_pmix_instruction_flag = 'Y' THEN 1 ELSE 0 END)
														AND    M.MASTER_ID 				= @v_master_id
														AND    M.PLAN_ID 				= @v_plan_id
														AND    M.AFTER_SITE_ID			= @v_factory_id
														AND    M.AFTER_OPERATION_ID		IN ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 )
														AND    M.MASTER_ID				= A.MASTER_ID
														AND    M.PLAN_ID				= A.PLAN_ID
														AND    M.AFTER_SITE_ID			= A.SITE_ID
														AND    M.ITEM_ID				= A.PARENT_ITEM_ID
														AND    M.AFTER_ROUTE_ID			= A.ROUTE_ID
														AND    CONVERT(DATETIME,M.AFTER_PLAN_DATE)   >= A.EFF_START_DATE	 
														AND    CONVERT(DATETIME,M.AFTER_PLAN_DATE)   <  A.EFF_END_DATE		
														AND	   M.WORK_REQUEST_MODEL_ID	= B.MODEL_ID
														AND	   M.VERSION				= B.PROD_VERSION
														AND    A.SITE_ID				= B.FACTORY_ID 
														AND    A.PARENT_ITEM_ID			= B.ITEM_ID 
														AND    B.COMPANY_ID				= D.COMPANY_ID 
														AND    B.DIVISION_ID			= D.DIVISION_ID
														AND    B.SITE_ID				= D.SITE_ID
														AND    B.PLANT_ID				= D.PLANT_ID 
														AND    B.FACTORY_ID				= D.FACTORY_ID 
														AND    B.MODEL_ID				= D.MODEL_ID 
														AND    B.PROD_VERSION_TYPE		= D.PROD_VERSION_TYPE 
														AND    B.PROD_VERSION			= D.PROD_VERSION 
														AND    B.PROD_SEQ				= D.PROD_SEQ 
														AND    A.CHILD_ITEM_ID			= D.ITEM_ID
														--AND    D.APPLY_END_DATE			>= @v_plan_date -- 이전 버전으로 넣을 경우가 있어 주석처리 해둔다. 
														GROUP BY M.MASTER_ID, M.PLAN_ID, M.AFTER_SITE_ID, M.AFTER_ROUTE_ID, M.ITEM_ID, M.AFTER_PLAN_DATE, M.AFTER_OPERATION_ID, M.WORK_REQUEST_MODEL_ID, M.VERSION
									) FF
									ON 1=1
									AND FF.AFTER_SITE_ID	= A.AFTER_SITE_ID
									AND FF.AFTER_ROUTE_ID	= A.AFTER_ROUTE_ID
									and FF.ITEM_ID			= A.E1000_item_id
									And FF.AFTER_PLAN_DATE	= A.E1000_PLAN_DATE
									AND FF.AFTER_OPERATION_ID		= A.E1000_OPERATION_ID
									AND FF.WORK_REQUEST_MODEL_ID	= A.WORK_REQUEST_MODEL_ID
									AND FF.VERSION			= A.VERSION
							WHERE 	1=1									
                         ) A 
                         LEFT OUTER JOIN
                             ( 
                              -- STOCK 미사용
                              SELECT FACTORY_ID
                                     , FP_APPLY_ITEM_ID
                                     , SUM(QTY) AS STOCK_QTY
                              FROM   SCM_STOCK_H_V WITH(NOLOCK)
          WHERE  CUTOFF_DATE = @v_cutoff_date --'2017-04-17'
                              AND    STOCK_TYPE  = 'WIP'
                              AND    FP_APPLY_OPERATION_ID = 'XXXXX' --@V_OPERATION_E1000
                              AND    FP_APPLY_WIPQTY > 0
                              GROUP BY FACTORY_ID, FP_APPLY_ITEM_ID
                          ) B
                              ON A.AFTER_SITE_ID = B.FACTORY_ID
                              AND A.ITEM_ID      = B.FP_APPLY_ITEM_ID
                         LEFT OUTER JOIN
                             (
                                -- * 수율 ( SCM_YIELD_M )
                                SELECT FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, MONTH
                                       , CASE WHEN YIELD = NULL THEN 1
                                              WHEN YIELD = 0    THEN 1
                                              ELSE YIELD
                                         END AS E1000_YIELD 
                                FROM   SCM_YIELD_M WITH(NOLOCK)
                                WHERE  1=0                          -- MIXER IN 수량 기준생성
                                AND    FACTORY_ID   = @v_factory_id
                                AND    OPERATION_ID IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 ) -- ## PRE-MIX 공정..!!
                         ) C
                             ON   A.AFTER_OPERATION_ID = C.OPERATION_ID
                             AND  A.AFTER_SITE_ID      = C.FACTORY_ID 
                             AND  A.AFTER_ROUTE_ID     = C.LINE_ID
                             AND  A.ITEM_ID            = C.ITEM_ID
                             AND  SUBSTRING(A.E1000_PLAN_DATE, 1, 6) = C.MONTH
                         LEFT OUTER JOIN
                             (
                                -- * 수율 ( SCM_YIELD_M )
                                SELECT FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, MONTH
                                       ,CASE WHEN YIELD = NULL THEN 1
                                             WHEN YIELD = 0    THEN 1
                                             ELSE YIELD
                                        END AS E1000_YIELD 
                                FROM   SCM_YIELD_M WITH(NOLOCK)
                                WHERE  FACTORY_ID   = @v_factory_id
                                AND    OPERATION_ID IN ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- ## MIXER  공정..!!
                              ) D
                             ON   A.AFTER_SITE_ID      = D.FACTORY_ID 
                             AND  A.AFTER_ROUTE_ID     = D.LINE_ID
                             AND  A.E1000_ITEM_ID      = D.ITEM_ID
                             AND  SUBSTRING(A.E1000_PLAN_DATE, 1, 6) = D.MONTH
                  ) A
                  --WHERE ORD_PRIORITY = 1 -- 우선순위 1번만
          ORDER BY A.MASTER_ID, A.PLAN_ID, A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_OPERATION_ID, A.ITEM_ID, A.DEMAND_TYPE, A.MARKET, A.E1000_ITEM_ID, A.E1000_PLAN_DATE, A.E1000_WORK_ORDER_ID
          
          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_E0500_PLAN_TARGET', 'INSERT', @n_log_count, null, @v_message, null 
          
          IF @v_pmix_instruction_flag = 'Y'	-- [E20250918-001592] 작업지시서 기준으로 발행 시 PLM 버전은 보내지 않는다.
          BEGIN
				UPDATE	A
				SET 	A.WORK_REQUEST_MODEL_ID = CASE WHEN ISNULL(X.PLM_VERSION_FLAG,'N') = 'N' THEN '-' ELSE A.WORK_REQUEST_MODEL_ID END
					   ,A.VERSION = CASE WHEN ISNULL(X.PLM_VERSION_FLAG,'N') = 'N' THEN '-' ELSE A.VERSION END
				
				FROM	TH_BUF_E0500_PLAN_TARGET A
						LEFT OUTER JOIN (
											SELECT 	DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID, A.ITEM_ID, A.PROD_VERSION, X.PLM_VERSION_FLAG
											FROM 	FP_PROD_VERSION_M A WITH(NOLOCK)
													INNER JOIN (
																SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, ISNULL(A.ATTRIBUTE2, 'N') AS PLM_VERSION_FLAG
																		, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, C.FACTORY_ID
																FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  A WITH(NOLOCK)	
																		INNER JOIN FP_INSTANCE_INFO_V B 
																		ON 1=1
																		AND A.SEGMENT1 = B.INSTANCE_ID
																		INNER JOIN FP_INSTANCE_FACTORY_M C  WITH(NOLOCK)
																		ON 1=1
																		AND A.SEGMENT1 = C.INSTANCE_ID
																WHERE 1=1
																AND A.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
																AND A.ACTIVE_FLAG = 'Y'
																--AND A.ATTRIBUTE2 = 'Y'		--PLM_VERSION_FLAG
																AND A.SEGMENT1 = @v_master_id
													) X
													ON 1=1
													AND A.COMPANY_ID = X.COMPANY_ID
													AND A.DIVISION_ID = X.DIVISION_ID
													AND A.SITE_ID = X.SITE_ID
													AND A.PLANT_ID = X.PLANT_ID
													AND A.FACTORY_ID = X.FACTORY_ID
											WHERE 1=1
											AND A.INSERT_ID LIKE '%PDS_WO%'	-- PLM/PDS 버전 구분이 여의치 않아 insert id 로 처리 (추후 변경 필요)
										) X
						ON	1=1
						AND A.AFTER_SITE_ID	= X.FACTORY_ID
						AND A.ITEM_ID		= X.ITEM_ID
						AND A.WORK_REQUEST_MODEL_ID	= X.MODEL_ID
						AND A.VERSION		= X.PROD_VERSION
				where 1=1
				and PLAN_ID = @v_plan_id
				
				SET @v_message = @@ROWCOUNT
          		SET @n_log_count += 1
		        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_E0500_PLAN_TARGET - PLM_VERSION_FLAG', 'UPDATE', @n_log_count, null, @v_message, null 
	          
	      END
	      
	      
          SET @v_table_name = 'TH_BUF_E0500_PLAN_TARGET_FINAL'
          
          DELETE FROM TH_BUF_E0500_PLAN_TARGET_FINAL
          WHERE  MASTER_ID     = @v_master_id
          AND    PLAN_ID       = @v_plan_id
          AND    AFTER_SITE_ID = @v_factory_id

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_E0500_PLAN_TARGET_FINAL', 'DELETE', @n_log_count, null, @v_message, null 
          
          INSERT INTO  TH_BUF_E0500_PLAN_TARGET_FINAL
              (
                 MASTER_ID
                ,PLAN_ID
                ,E2000_WORK_ORDER_ID
                ,E1000_WORK_ORDER_ID
                ,WORK_ORDER_ID
                ,ATTB1
                ,AFTER_SITE_ID
                ,AFTER_ROUTE_ID
                ,AFTER_OPERATION_ID
                ,AFTER_RESOURCE_ID
                ,AFTER_PLAN_DATE
                ,AFTER_START_TIME
                ,AFTER_END_TIME
                ,AFTER_QTY
                ,AFTER_IN_QTY
                ,ITEM_ID
                ,FIXED_YN
                ,DEMAND_ID
                ,DEMAND_TYPE
                ,MARKET,TOP_ITEM_ID
                ,E1000_START_TIME
                ,E1000_END_TIME
                ,E1000_PLAN_DATE
                ,E1000_ITEM_ID
                ,E1000_ORG_QTY
                ,ORG_QTY
                ,PLAN_QTY
                ,BATCH_LOT_SIZE
                ,BATCH_COUNT
                ,MIN_BATCH_APPLY,TAT
                ,RESOURCE_COUNT
                ,DIVIDE_COUNT
                ,ADD_COUNT,RES1_QTY
                ,RES2_QTY
                ,TOT_TAT1 
                ,TOT_TAT2
                ,R
                ,TAT_MIN
                ,E0500_YIELD
                ,INSERT_ID,INSERT_TIME
		, WORK_REQUEST_MODEL_ID    -- (D20250319~R0319.01) PDS2
		, VERSION    -- (D20250319~R0319.01) PDS2
		, PLM_EC_NO    -- (D20250319~R0319.01) PDS2
               ) 
          SELECT   A.MASTER_ID, A.PLAN_ID
                 , A.E2000_WORK_ORDER_ID
                 , A.E1000_WORK_ORDER_ID
                 , SUBSTRING(A.WORK_ORDER_ID, 1, CHARINDEX((CASE WHEN ISNULL(@v_mix_mid_op2,'0000') = a.after_operation_id THEN @v_mix_mid_char2 ELSE @v_mix_mid_char END), A.WORK_ORDER_ID)+1)			--  (D240829~R240829.01)
                    + '#'
                    + @V_INSTANCE_SUB_CODE
                    + '#'
                    + @V_FACTORY_ID
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
                    AS WORK_ORDER_ID
                 , A.WORK_ORDER_ID AS ATTB1
                 , A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_OPERATION_ID
                 , A.RESOURCE_ID AS AFTER_RESOURCE_ID
                 , A.AFTER_PLAN_DATE, A.AFTER_START_TIME, A.AFTER_END_TIME
                 , CEILING(A.FINAL_AFTER_IN_QTY * ISNULL(B.E1000_YIELD, 1) ) AS AFTER_QTY 
                 , A.FINAL_AFTER_IN_QTY                          AS AFTER_IN_QTY 
                 , A.ITEM_ID
                 , A.FIXED_YN, A.DEMAND_ID , A.DEMAND_TYPE, A.MARKET, A.TOP_ITEM_ID
                 , A.E1000_START_TIME, A.E1000_END_TIME, A.E1000_PLAN_DATE, A.E1000_ITEM_ID, A.E1000_ORG_QTY, A.ORG_QTY
                 --,A.R,A.ACU_ORG_QTY,A.STOCK_QTY,A.REMAIN_QTY
                 , A.PLAN_QTY                                   -- 계획대상 수량
                 , A.BATCH_LOT_SIZE                             -- BATCH LOT SIZE
                 , A.BATCH_COUNT                                -- BATCH 수 ( 1.1 => 1 )
                 , A.MIN_BATCH_APPLY                            -- MINLOT QTY
                 , A.TAT                                        -- 1 BATCH TIME
                 , A.RESOURCE_COUNT                             -- MIXER 설비 대수
   , A.DIVIDE_COUNT                               -- 나머지를 뺀 몫 수 FLOOR( 3 / 2 ) => 1
                 , A.ADD_COUNT                                  -- 잔량이 어디로 가야하는지 확인용 ( BATCH_COUNT % 2  )
                 , 0 RES1_QTY     
                 , 0 RES2_QTY     
                 , 0 TOT_TAT1     
                 , 0 TOT_TAT2
                 , A.RESOURCE_SEQ   AS R
                 , A.TAT_MIN 
                 , ISNULL(B.E1000_YIELD, 1) AS E1000_YIELD
                 , @V_PROC_NAME AS INSERT_ID
                 , GETDATE()    AS INSERT_TIME
                 , A.WORK_REQUEST_MODEL_ID    	-- (D20250319~R0319.01) PDS2
		 , A.VERSION    				-- (D20250319~R0319.01) PDS2
		 , A.PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
          FROM   (    
                  SELECT A.MASTER_ID, A.PLAN_ID
                         , A.E2000_WORK_ORDER_ID
                         , A.E1000_WORK_ORDER_ID
                         , A.WORK_ORDER_ID + CONVERT(NVARCHAR, A.RESOURCE_SEQ) AS WORK_ORDER_ID
                         , ROW_NUMBER() OVER( PARTITION BY A.MASTER_ID, A.PLAN_ID, A.AFTER_OPERATION_ID
                                                  ORDER BY A.AFTER_PLAN_DATE, A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_RESOURCE_ID, A.ITEM_ID, A.WORK_ORDER_ID, A.RESOURCE_SEQ )
                           AS SEQ                        
                         , A.AFTER_SITE_ID, A.AFTER_OPERATION_ID, A.ITEM_ID
                         , A.PLAN_QTY                                   -- 계획대상 수량
                         , A.BATCH_LOT_SIZE                             -- BATCH LOT SIZE
                         , A.BATCH_COUNT1                               -- BATCH 수 - 소수점 BATCH
                         , A.BATCH_COUNT                                -- BATCH 수 - FLOOR
                         , A.MIN_BATCH_APPLY                            -- MINLOT QTY
                         , A.TAT                                        -- 1 BATCH TIME
                         , A.RESOURCE_SEQ                               -- MIXER 설비 순서
                         , A.RESOURCE_COUNT                             -- MIXER 설비 대수
                         , A.RESOURCE_ID                                -- MIXER 설비
                         , NULL AS DIVIDE_COUNT                         -- 나머지를 뺀 몫 수
                         , A.ADD_COUNT                                  -- 첫번째 설비에 할당 할 MINLOT1
                         , A.E0500_PLAN_QTY AS FINAL_AFTER_IN_QTY   -- A.PLAN_QTY AS FINAL_AFTER_IN_QTY -- A.BATCH_LOT_SIZE * A.DIVIDE_COUNT + A.ADD_QTY AS FINAL_AFTER_IN_QTY     
                         , NULL    AS TAT_MIN     
                         -----------------------------------------------------------------
                          , A.AFTER_ROUTE_ID, A.AFTER_RESOURCE_ID, A.AFTER_PLAN_DATE, A.AFTER_START_TIME, A.AFTER_END_TIME, A.AFTER_QTY, A.AFTER_IN_QTY
                          , A.FIXED_YN, A.DEMAND_ID, A.DEMAND_TYPE, A.MARKET, A.TOP_ITEM_ID
                          , A.E1000_START_TIME, A.E1000_END_TIME, A.E1000_PLAN_DATE, A.E1000_ITEM_ID, A.E1000_ORG_QTY, A.ORG_QTY
                         -----------------------------------------------------------------
                         , A.WORK_REQUEST_MODEL_ID    	-- (D20250319~R0319.01) PDS2
			 , A.VERSION    				-- (D20250319~R0319.01) PDS2
			 , A.PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
                  FROM   (
                          SELECT A.MASTER_ID, A.PLAN_ID
                                 , A.E2000_WORK_ORDER_ID
                                 , A.E1000_WORK_ORDER_ID, A.WORK_ORDER_ID
                                 , A.AFTER_SITE_ID, A.AFTER_OPERATION_ID, A.ITEM_ID
                                 , A.PLAN_QTY                                   -- 계획대상 수량
                                 , A.BATCH_LOT_SIZE                             -- BATCH LOT SIZE
                                 , A.BATCH_COUNT1                               -- BATCH 수 - 소수점 BATCH
                                 , A.BATCH_COUNT                                -- BATCH 수 - FLOOR
                                 , A.MIN_BATCH_APPLY                            -- MINLOT QTY
                                 , A.TAT                                        -- 1 BATCH TIME
                                 , A.RESOURCE_SEQ                               -- MIXER 할당 순서
                                 , A.RESOURCE_COUNT                             -- MIXER 설비 대수
                                 , A.RESOURCE_ID                                -- MIXER 설비
                                 , CASE WHEN A.PLAN_QTY % A.RESOURCE_COUNT >= A.RESOURCE_SEQ THEN CEILING(A.PLAN_QTY / A.RESOURCE_COUNT) 
                                                                                                ELSE FLOOR(A.PLAN_QTY / A.RESOURCE_COUNT) 
                                   END  AS E0500_PLAN_QTY
                                 , CASE WHEN ( A.PLAN_QTY % A.RESOURCE_COUNT  ) + 1 = A.RESOURCE_SEQ 
                                         AND A.PLAN_QTY > 0                             THEN 1
                                                                                                        ELSE 0
                                   END  AS ADD_COUNT      -- TAT 추가
                                 , CASE WHEN ( A.PLAN_QTY % A.RESOURCE_COUNT  ) + 1 = A.RESOURCE_SEQ THEN A.MIN_BATCH_APPLY
                                                                                                        ELSE 0
                                   END  AS ADD_QTY        -- QTY 추가
                                 -----------------------------------------------------------------
                                  , A.AFTER_ROUTE_ID, A.AFTER_RESOURCE_ID, A.AFTER_PLAN_DATE, A.AFTER_START_TIME, A.AFTER_END_TIME, A.AFTER_QTY, A.AFTER_IN_QTY
                                  , A.FIXED_YN, A.DEMAND_ID, A.DEMAND_TYPE
								  --, CASE WHEN @v_master_id = 'CN_E_PRE_M' THEN 'D' ELSE A.MARKET END AS MARKET
								  , A.MARKET                                   --- (20190717) Modify Market Info. 
								  , A.TOP_ITEM_ID
                                  , A.E1000_START_TIME, A.E1000_END_TIME, A.E1000_PLAN_DATE, A.E1000_ITEM_ID, A.E1000_ORG_QTY, A.ORG_QTY
                                 -----------------------------------------------------------------
                                 , A.WORK_REQUEST_MODEL_ID    	-- (D20250319~R0319.01) PDS2
				 , A.VERSION    				-- (D20250319~R0319.01) PDS2
				 , A.PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
                          FROM   (
                                  SELECT A.MASTER_ID, A.PLAN_ID
                                         , A.E2000_WORK_ORDER_ID
                                         , A.E1000_WORK_ORDER_ID, A.WORK_ORDER_ID
                                         , A.AFTER_SITE_ID, A.AFTER_OPERATION_ID, A.ITEM_ID
                                         , A.PLAN_QTY
                                         , A.BATCH_LOT_SIZE
                                         , A.PLAN_QTY / A.BATCH_LOT_SIZE AS BATCH_COUNT1
                                         , FLOOR(A.PLAN_QTY / A.BATCH_LOT_SIZE)   AS BATCH_COUNT
                                         , CEILING(A.PLAN_QTY / A.BATCH_LOT_SIZE) AS BATCH_MOD_COUNT
                                         , A.PLAN_QTY % A.BATCH_LOT_SIZE          AS MOD_QTY
                                         , CEILING(A.BATCH_LOT_SIZE * A.MIN_RATE) AS MIN_BATCH_SIZE
                                         , CASE WHEN A.PLAN_QTY % A.BATCH_LOT_SIZE >= CEILING(A.BATCH_LOT_SIZE * A.MIN_RATE)
                                                THEN A.PLAN_QTY % A.BATCH_LOT_SIZE
                                                ELSE CEILING(A.BATCH_LOT_SIZE * A.MIN_RATE)
                                           END AS MIN_BATCH_APPLY     
                                         , A.TAT
                                         , A.MIN_RATE
                                         , A.RESOURCE_ID, A.ALT_PRIORITY, A.RESOURCE_SEQ
                                         -----------------------------------------------------------------
                                          , A.AFTER_ROUTE_ID, A.AFTER_RESOURCE_ID, A.AFTER_PLAN_DATE, A.AFTER_START_TIME, A.AFTER_END_TIME, A.AFTER_QTY, A.AFTER_IN_QTY
                                          , A.FIXED_YN, A.DEMAND_ID, A.DEMAND_TYPE, A.MARKET, A.TOP_ITEM_ID
                                          , A.E1000_START_TIME, A.E1000_END_TIME, A.E1000_PLAN_DATE, A.E1000_ITEM_ID, A.E1000_ORG_QTY, A.ORG_QTY , A.RESOURCE_COUNT
                                         -----------------------------------------------------------------
                                         , A.WORK_REQUEST_MODEL_ID    	-- (D20250319~R0319.01) PDS2
					 , A.VERSION    				-- (D20250319~R0319.01) PDS2
					 , A.PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
                                  FROM   (
                                          -- MIXER TARGET 수량
                                          SELECT A.MASTER_ID, A.PLAN_ID
                                                , A.E2000_WORK_ORDER_ID
                                                , A.E1000_WORK_ORDER_ID, A.WORK_ORDER_ID
                                                , A.AFTER_SITE_ID
                                                , A.AFTER_OPERATION_ID, A.ITEM_ID, CEILING(A.AFTER_IN_QTY) AS PLAN_QTY
                                                -----------------------------------------------------------------
                                                , A.AFTER_ROUTE_ID, A.AFTER_RESOURCE_ID, A.AFTER_PLAN_DATE, A.AFTER_START_TIME, A.AFTER_END_TIME, A.AFTER_QTY, A.AFTER_IN_QTY
                                                , A.FIXED_YN, A.DEMAND_ID, A.DEMAND_TYPE, A.MARKET, A.TOP_ITEM_ID
                                                , A.E1000_START_TIME, A.E1000_END_TIME, A.E1000_PLAN_DATE, A.E1000_ITEM_ID, A.E1000_ORG_QTY, A.ORG_QTY
                                                 --,A.R,A.ACU_ORG_QTY,A.STOCK_QTY,A.REMAIN_QTY
                                                , NULL  AS BATCH_LOT_SIZE
                                                , 1     AS TAT
                                                , ISNULL(C.MIN_RATE, 0)        AS MIN_RATE
                                                , D.RESOURCE_ID, D.ALT_PRIORITY, D.RESOURCE_SEQ, D.RESOURCE_COUNT 
                                                , A.WORK_REQUEST_MODEL_ID    	-- (D20250319~R0319.01) PDS2
						, A.VERSION    				-- (D20250319~R0319.01) PDS2
						, A.PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
                                          FROM    TH_BUF_E0500_PLAN_TARGET A
                                                   LEFT OUTER JOIN (
                                                                    -- 최소 BATCH SIZE 정보
                                                                    SELECT LOOKUP_TYPE_CODE, SEGMENT2 AS FACTORY_ID, SEGMENT3 AS OPERATION_ID, CONVERT(NUMERIC(20,10), ATTRIBUTE1) AS MIN_RATE 
                                                                    FROM   SCM_SYS_LOOKUP_VALUE
                                                                    WHERE  LOOKUP_TYPE_CODE LIKE 'MIN_BATCH_SIZE'
                                                                    AND    1=0      -- 2019.01.08 : MIN BATCH 조건 제외 요청
                                                                   ) C
                                                        ON     A.AFTER_SITE_ID      = C.FACTORY_ID
                                                        AND    A.AFTER_OPERATION_ID = C.OPERATION_ID
                                                 , (  --- LINE , EQUIPMENT 매핑 --- 
                                                    SELECT A.ITEM_ID, A.ROUTE_ID, B.RESOURCE_ID, A.MONTH, A.ALT_PRIORITY
                                                         , ROW_NUMBER() OVER ( PARTITION BY A.ITEM_ID, A.ROUTE_ID ORDER BY A.ALT_PRIORITY, B.RESOURCE_ID ) AS RESOURCE_SEQ 
                                                         , COUNT(1)     OVER ( PARTITION BY A.ITEM_ID, A.ROUTE_ID , A.MONTH ) AS RESOURCE_COUNT 
                                                    FROM   (
                                                            SELECT FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID AS ROUTE_ID, MONTH, PRIORITY AS ALT_PRIORITY, ACTIVE_FLAG , ELECTRODE_TYPE
                                                            FROM   (
                                                                    SELECT A.*
                                                                    FROM SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)  , SCM_LINE_M B WITH(NOLOCK)
                                                                    WHERE A.COMPANY_ID = B.COMPANY_ID 
                                                                    AND A.DIVISION_ID  = B.DIVISION_ID 
                                                                    AND A.SITE_ID = B.SITE_ID 
                                                                    AND A.PLANT_ID = B.PLANT_ID 
                                                                    AND A.FACTORY_ID = B.FACTORY_ID
                                                                    AND A.OPERATION_ID = B.OPERATION_ID 
                                                                    AND A.LINE_ID = B.LINE_ID 
                                                                    AND A.ELECTRODE_TYPE =  B.ELECTRODE_TYPE 
                                                                    AND A.ACTIVE_FLAG = 'Y'
                                                                    AND B.ACTIVE_FLAG = 'Y'
                                                                    )A
                                                            WHERE  FACTORY_ID   = @v_factory_id
                                                            AND    OPERATION_ID IN ( @v_pmix_wo_id_merge_op1, @V_PMIX_WO_ID_MERGE_OP2 ) -- ## MIXER 공정..!!
                                                            --AND    MONTH        = @V_PLAN_MONTH --'201707'
							                                              AND    MONTH        >= CONVERT(NVARCHAR(6), @v_plan_date, 112)
                                                            AND    MONTH        <= CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, @v_plan_date), 112)
                                                            AND    ACTIVE_FLAG  = 'Y'
                                                            --AND ITEM_ID = 'ASLAN0823A'
                                                            AND    PRIORITY IN ( 1, 2, 3, 4, 5, 6, 7, 8 ) -- 미사용 FLAG인것은 할당 제외 (0, 9,NULL)
                                                           ) A,
                                                           (
                                                            SELECT FACTORY_ID, OPERATION_ID, EQUIPMENT_ID AS RESOURCE_ID, LINE_ID AS ROUTE_ID, EQUIPMENT_TYPE, ACTIVE_FLAG, ELECTRODE_TYPE
                                                            FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                                                            WHERE  EQUIPMENT_TYPE = 'M'
                                                            AND    FACTORY_ID     = @V_FACTORY_ID
                                                            AND    OPERATION_ID   IN ( @V_PMIX_WO_ID_MERGE_OP1, @V_PMIX_WO_ID_MERGE_OP2 ) -- ## MIXER 공정..!!
                                                            AND    ACTIVE_FLAG    = 'Y'
                                                           ) B
                                                    WHERE  A.FACTORY_ID   = B.FACTORY_ID
                                                    AND    A.OPERATION_ID = B.OPERATION_ID
                                                    AND    A.ROUTE_ID     = B.ROUTE_ID
													AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE    ---+ (20200107) 양극,음극이 섞이지않게 조건추가.
                                                   ) D
                                          WHERE   A.MASTER_ID     = @V_MASTER_ID
                                          AND     A.PLAN_ID       = @V_PLAN_ID
                                          AND     A.AFTER_SITE_ID = @V_FACTORY_ID
                                          --AND     E1000_WORK_ORDER_ID = 'WP18B05CT#PE1#EB#02#0029'
                                          AND     A.ITEM_ID        = D.ITEM_ID
                                          AND     A.AFTER_ROUTE_ID = D.ROUTE_ID
					                                AND     CHARINDEX(D.MONTH, A.E1000_PLAN_DATE) > 0 
                                          --AND     D.RESOURCE_SEQ = 1  설비단위 계획 
                                         ) A        
                                 ) A                
                         ) A
 ) A 
                 LEFT OUTER JOIN
                     (
                      -- * 수율 ( SCM_YIELD_M )
                      SELECT FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, MONTH
                             , CASE WHEN YIELD = NULL THEN 1
                                    WHEN YIELD = 0    THEN 1
                                    ELSE YIELD
                               END AS E1000_YIELD 
                      FROM   SCM_YIELD_M WITH(NOLOCK)
                      WHERE  1=0                          -- 2019.02.25 : PRE MIXER 계획에서는 YIELD 를 반영하지 않는다.
                      AND    FACTORY_ID   = @V_FACTORY_ID
                      AND    OPERATION_ID IN ( @V_PMIX_WO_ID_MERGE_OP1, @V_PMIX_WO_ID_MERGE_OP2 ) -- ## MIXER 공정..!!
                    ) B
                     ON   A.AFTER_OPERATION_ID = B.OPERATION_ID
                     AND  A.AFTER_SITE_ID      = B.FACTORY_ID 
                     AND  A.AFTER_ROUTE_ID     = B.LINE_ID
                     AND  A.ITEM_ID            = B.ITEM_ID
                     AND  SUBSTRING(A.E1000_PLAN_DATE, 1, 6) = B.MONTH  
                 INNER JOIN
                     -- SEQ로 WO SEQ 를 찾는다 
                     ( SELECT ORDER_NO, ORDER_ID FROM FP_ORDER_SEQ  ) C
                 ON A.SEQ = C.ORDER_NO
          
          
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY'
          
          DELETE FROM TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY
          WHERE   MASTER_ID     = @v_master_id
          AND     PLAN_ID       = @v_plan_id
          AND     AFTER_SITE_ID = @v_factory_id

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY', 'DELETE', @n_log_count, null, @v_message, null 
          
          INSERT INTO TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY
                (
                  MASTER_ID,PLAN_ID,WORK_ORDER_ID,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
                  ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE,BEFORE_START_TIME
                  ,AFTER_START_TIME,BEFORE_END_TIME,AFTER_END_TIME,WORKING_TIME,BEFORE_SEQ,AFTER_SEQ,BEFORE_QTY,AFTER_QTY,BEFORE_IN_QTY
                  ,AFTER_IN_QTY,ITEM_ID,FIXED_YN,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,MARKET,TOP_ITEM_ID, ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK,ORG_WORK_ORDER_ID
                  ,DEMAND_DUE_DATE,BATCH_ORDER_ID,DATE_FIX_FLAG,DATE_FIX_DATE,OPERATION_EPST,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                  ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_IN_QTY,BATCH_QTY,UI_EDIT_YN,DESCRIPTION,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
		  , DELETE_YN
		  , WORK_REQUEST_MODEL_ID , VERSION , PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
                 )                  
          SELECT     
                  A.MASTER_ID, A.PLAN_ID 
                  ----------------------------------------------------------------------------------------------------------------
          --        , A.WO_HEADER
          --        , A.NATION_CD
          --        , A.MASS_SAMPLE
          --        , A.YYMMDD_CODE
          --        , A.ERP_OPERATION_ID  
          --        , A.AFTER_SITE_ID  ( WORK ORDER 번호가 FACTORY 별로 돌릴때 중복될수 있어 보정코드로 넣음 ) 
          --        , B.ORDER_ID AS SEQ                        
                  --, A.WO_HEADER + A.NATION_CD + A.MASS_SAMPLE + A.YYMMDD_CODE + A.ERP_OPERATION_ID + A.AFTER_SITE_ID + B.ORDER_ID AS WORK_ORDER_ID
                  , A.WORK_ORDER_ID
                  ----------------------------------------------------------------------------------------------------------------
                  , A.BEFORE_SITE_ID,      A.AFTER_SITE_ID
                  , A.BEFORE_ROUTE_ID,     A.AFTER_ROUTE_ID
                  , A.BEFORE_OPERATION_ID, A.AFTER_OPERATION_ID
                  , A.BEFORE_RESOURCE_ID,  A.AFTER_RESOURCE_ID
        , A.BEFORE_PLAN_DATE,    A.AFTER_PLAN_DATE
                  , A.BEFORE_START_TIME,   A.AFTER_START_TIME
                  , A.BEFORE_END_TIME,     A.AFTER_END_TIME
                  , A.WORKING_TIME
                  , A.BEFORE_SEQ,          A.AFTER_SEQ
                  , CEILING(A.BEFORE_QTY)    AS BEFORE_QTY,          CEILING(A.AFTER_QTY)    AS AFTER_QTY
                  , CEILING(A.BEFORE_IN_QTY) AS BEFORE_IN_QTY,       CEILING(A.AFTER_IN_QTY) AS AFTER_IN_QTY
                  , A.ITEM_ID
                  , A.FIXED_YN, A.SPLIT_YN, A.DEMAND_ID
                  , A.DEMAND_TYPE
                  , A.MARKET
                  , A.TOP_ITEM_ID
                  , A.ORDER_ID, A.ORDER_TYPE, A.PO_ID, A.MFG_WEEK, A.SOP_WEEK
                  , A.ORG_WORK_ORDER_ID
                  , A.DEMAND_DUE_DATE
                  , A.BATCH_ORDER_ID
                  , A.DATE_FIX_FLAG, A.DATE_FIX_DATE, A.OPERATION_EPST,  A.OPERATION_LPST, A.LANE_QTY
                  , A.LANE_TACT_QTY, A.ITEM_UOM,      A.WO_DAY_SPLIT_YN, A.SETUP_TIME,     A.SETUP_TIME_UOM
                  , A.BATCH_IN_QTY,  A.BATCH_QTY,     A.UI_EDIT_YN,    A.DESCRIPTION
                  , @v_proc_name AS INSERT_ID, GETDATE() AS INSERT_TIME
                  , @v_proc_name AS UPDATE_ID, GETDATE() AS UPDATE_TIME
                  , A.E1000_WORK_ORDER_ID
                  , A.WORK_REQUEST_MODEL_ID    	-- (D20250319~R0319.01) PDS2
		  , A.VERSION    				-- (D20250319~R0319.01) PDS2
		  , A.PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
          FROM    (        
                  SELECT 
                          A.MASTER_ID, A.PLAN_ID 
                          ----------------------------------------------------------------------------------------------------------------
                          , ISNULL(B.WO_HEADER, 'M') AS WO_HEADER
                          , ISNULL(C.KEY_VALUE, 'K') AS NATION_CD
                          , ISNULL(D.KEY_VALUE, '1') AS MASS_SAMPLE
                          , SUBSTRING(A.FP_PLAN_DATE, 3, 2)
                            + CASE SUBSTRING(A.FP_PLAN_DATE, 5, 2)
                                   WHEN '10' THEN 'A'
                                   WHEN '11' THEN 'B'
                                   WHEN '12' THEN 'C'
                                   ELSE SUBSTRING(A.FP_PLAN_DATE, 6, 1)
                              END
                            + SUBSTRING(A.FP_PLAN_DATE, 7, 2)
                            AS YYMMDD_CODE
                          , ISNULL(ERP_OPERATION_ID, 'PM') AS ERP_OPERATION_ID  
                          , ROW_NUMBER() OVER( PARTITION BY A.MASTER_ID, A.PLAN_ID, A.AFTER_OPERATION_ID
                                                   ORDER BY A.AFTER_PLAN_DATE, A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_RESOURCE_ID, A.ITEM_ID, A.AFTER_SEQ )
                           AS SEQ                        
                          , A.WORK_ORDER_ID
                          , A.E1000_WORK_ORDER_ID
                          ----------------------------------------------------------------------------------------------------------------
                          , A.BEFORE_SITE_ID,      A.AFTER_SITE_ID
                          , A.BEFORE_ROUTE_ID,     A.AFTER_ROUTE_ID
                          , A.BEFORE_OPERATION_ID, A.AFTER_OPERATION_ID
                          , A.BEFORE_RESOURCE_ID,  A.AFTER_RESOURCE_ID
                          , A.BEFORE_PLAN_DATE,    A.AFTER_PLAN_DATE
                          , A.AFTER_START_TIME  AS BEFORE_START_TIME
                          , A.AFTER_START_TIME
                          , A.AFTER_END_TIME    AS BEFORE_END_TIME
                          , A.AFTER_END_TIME
                          , A.WORKING_TIME
                          , A.BEFORE_SEQ,          A.AFTER_SEQ
                          , A.BEFORE_QTY,          A.AFTER_QTY
                          , A.BEFORE_IN_QTY,       A.AFTER_IN_QTY
                          , A.ITEM_ID
                          , A.FIXED_YN, A.SPLIT_YN, A.DEMAND_ID
                          , A.DEMAND_TYPE
                          , A.MARKET
                          , A.TOP_ITEM_ID
                          , A.ORDER_ID
                          , ISNULL(B.WO_HEADER, 'M') AS ORDER_TYPE
                          , A.PO_ID, A.MFG_WEEK, A.SOP_WEEK
                          , A.ORG_WORK_ORDER_ID
                          , A.DEMAND_DUE_DATE
                          , A.BATCH_ORDER_ID
                          , A.DATE_FIX_FLAG, A.DATE_FIX_DATE, A.OPERATION_EPST,  A.OPERATION_LPST, A.LANE_QTY
                          , A.LANE_TACT_QTY, A.ITEM_UOM,      A.WO_DAY_SPLIT_YN, A.SETUP_TIME,     A.SETUP_TIME_UOM
                          , A.BATCH_IN_QTY,  A.BATCH_QTY,     A.UI_EDIT_YN,    A.DESCRIPTION
                          , A.WORK_REQUEST_MODEL_ID    	-- (D20250319~R0319.01) PDS2
			  , A.VERSION    				-- (D20250319~R0319.01) PDS2
			  , A.PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
                  FROM    (
                          SELECT  --A.TAT_MIN,A.E2000_START_TIME, C.PRECEDE_PRODUCING_TERM,
                                    A.MASTER_ID, A.PLAN_ID, SUBSTRING ( A.PLAN_ID, CHARINDEX( '-', A.PLAN_ID )+1, 8 ) AS FP_PLAN_DATE
                                  , A.WORK_ORDER_ID
                                  , A.E1000_WORK_ORDER_ID
                                  , A.AFTER_SITE_ID      AS BEFORE_SITE_ID,      A.AFTER_SITE_ID
                                  , A.AFTER_ROUTE_ID     AS BEFORE_ROUTE_ID,     A.AFTER_ROUTE_ID
                                  , A.AFTER_OPERATION_ID AS BEFORE_OPERATION_ID, A.AFTER_OPERATION_ID
                                  , A.AFTER_RESOURCE_ID  AS BEFORE_RESOURCE_ID,  A.AFTER_RESOURCE_ID
                                  --  ( MIXE / PRE-MIX 시간 동일 )                                   
                                  , A.E1000_PLAN_DATE AS BEFORE_PLAN_DATE                               
                                  , A.E1000_PLAN_DATE AS AFTER_PLAN_DATE                                
                                  , A.E1000_START_TIME AS AFTER_START_TIME                    
                                  , A.E1000_END_TIME AS AFTER_END_TIME
                                  , 0 AS WORKING_TIME
                                  , DENSE_RANK() OVER( PARTITION BY A.MASTER_ID, A.PLAN_ID, A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_OPERATION_ID, A.ITEM_ID, A.DEMAND_TYPE, A.MARKET
                                                           ORDER BY A.E1000_ITEM_ID, A.E1000_PLAN_DATE ) 
                                    AS BEFORE_SEQ
                                  , DENSE_RANK() OVER( PARTITION BY A.MASTER_ID, A.PLAN_ID, A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_OPERATION_ID, A.ITEM_ID, A.DEMAND_TYPE, A.MARKET
                                                           ORDER BY A.E1000_ITEM_ID, A.E1000_PLAN_DATE ) 
                                    AS AFTER_SEQ
                                  , A.AFTER_QTY AS BEFORE_QTY, A.AFTER_QTY AS AFTER_QTY, A.AFTER_IN_QTY AS BEFORE_IN_QTY, A.AFTER_IN_QTY AS AFTER_IN_QTY
                                  , A.ITEM_ID
                                  , A.FIXED_YN, NULL AS SPLIT_YN
                                  , A.DEMAND_ID
                                  , A.DEMAND_TYPE
                                  --, CASE WHEN @v_master_id = 'CN_E_PRE_M' THEN 'D' ELSE A.MARKET END AS MARKET
								  , A.MARKET                                   --- (20190717) Modify Market Info. 
                                  , A.TOP_ITEM_ID
                                  , NULL AS ORDER_ID, NULL AS ORDER_TYPE, NULL AS PO_ID, NULL AS MFG_WEEK, NULL AS SOP_WEEK
                                  , NULL AS ORG_WORK_ORDER_ID
                                  , NULL AS DEMAND_DUE_DATE, A.ITEM_ID AS BATCH_ORDER_ID, NULL AS DATE_FIX_FLAG, NULL AS DATE_FIX_DATE, NULL AS OPERATION_EPST, NULL AS OPERATION_LPST, NULL AS LANE_QTY, NULL AS LANE_TACT_QTY
                                  , C.ITEM_UOM AS ITEM_UOM
                                  , NULL AS WO_DAY_SPLIT_YN, 0 AS SETUP_TIME, 'SECOND' AS SETUP_TIME_UOM
                                 /* , CASE WHEN A.BATCH_LOT_SIZE > 0 THEN A.AFTER_IN_QTY / CEILING(A.BATCH_LOT_SIZE)
                      ELSE A.AFTER_IN_QTY
                                    END  AS BATCH_IN_QTY */
                                  , NULL AS BATCH_IN_QTY
                                 /* , CASE WHEN A.BATCH_LOT_SIZE > 0 THEN A.AFTER_QTY / CEILING(A.BATCH_LOT_SIZE)
                                                                   ELSE A.AFTER_QTY
                                    END  AS BATCH_QTY */
                                  , NULL AS   BATCH_QTY
                                  , NULL AS UI_EDIT_YN, NULL AS DESCRIPTION
                                  , A.WORK_REQUEST_MODEL_ID    	-- (D20250319~R0319.01) PDS2
				  , A.VERSION    				-- (D20250319~R0319.01) PDS2
				  , A.PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
                          ------------------------------------------------------------------        
                          ------------------------------------------------------------------        
  		  	FROM   TH_BUF_E0500_PLAN_TARGET_FINAL A , 
                                (
                          				SELECT 	DISTINCT SEGMENT1 AS COMPANY_ID  , SEGMENT2  AS DIVISION_ID , SEGMENT3  AS SITE_ID  , SEGMENT4 AS PLANT_ID , ATTRIBUTE3 AS MASTER_ID 
							FROM 	SCM_SYS_LOOKUP_VALUE  WITH(NOLOCK)
                          				WHERE 	1=1
                          				AND 	LOOKUP_TYPE_CODE = 'CREATE_WO_PRE_MIX'
                          				AND 	ACTIVE_FLAG	= 'Y'
                          				AND		ATTRIBUTE3 = @v_master_id 
                          			)B , 
                                SCM_ITEM_M C WITH(NOLOCK)
                          ------------------------------------------------------------------        
                          ------------------------------------------------------------------   
                                 /*
                                 LEFT OUTER JOIN SCM_OPERATION_MOVE_M C -- PRECEDE_PRODUCING_TERM
                                      ON    A.AFTER_OPERATION_ID = C.OPERATION_ID
                                      AND   A.AFTER_SITE_ID      = C.FACTORY_ID
                                 */
                          WHERE  A.MASTER_ID     = @V_MASTER_ID
                          AND    A.PLAN_ID       = @V_PLAN_ID
                          AND    A.AFTER_SITE_ID = @V_FACTORY_ID
                          AND    A.AFTER_QTY      > 0 
                          AND    A.MASTER_ID     = B.MASTER_ID
                          AND    B.COMPANY_ID    = C.COMPANY_ID
                          AND    B.DIVISION_ID   = C.DIVISION_ID
                          AND    B.SITE_ID       = C.SITE_ID
                          AND    A.ITEM_ID       = C.ITEM_ID
                          ) A  
                         LEFT OUTER JOIN
                             (
                              -- M ( 기확정은 사용안함 )WO_HEADER
                              SELECT DISTINCT OPERATION_ID,
                                     --COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, OPERATION_NAME, ERP_OPERATION_ID, CAPA_TYPE,
                                     CASE WHEN WO_FLAG = 'Y' 
                                          THEN 'W' 
                                          ELSE 'M' 
                                     END  AS WO_HEADER 
                              FROM   SCM_OPERATION_M WITH(NOLOCK)
                              WHERE  OPERATION_ID IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 ) -- ## MIXER 공정..!!
                         ) B
                             ON   A.AFTER_OPERATION_ID = B.OPERATION_ID
                         LEFT OUTER JOIN
                             (
                              -- 국가코드
                              SELECT INSTANCE_ID, KEY_VALUE  
                              FROM   FP_INSTANCE_CONFIG_M WITH(NOLOCK)
                              WHERE  1=1
                              AND    INSTANCE_ID = @v_master_id
                              AND    CATEGORY_ID = 'EXPORT'
                              AND    KEY_ID      = 'INSTANCE_CODE'
                         ) C
                             ON   A.MASTER_ID = C.INSTANCE_ID
                         LEFT OUTER JOIN
                             (
                              -- 샘플양산 구분
                              SELECT KEY_ID, KEY_VALUE 
                              FROM   FP_INSTANCE_CONFIG_M WITH(NOLOCK)
                              WHERE  1=1
                              AND    INSTANCE_ID = 'COMMON'
                              AND    KEY_ID      = 'MASS'
                         ) D
                             ON   A.DEMAND_TYPE = D.KEY_ID
                         LEFT OUTER JOIN
                             (
                              -- ERP_OPERATION_ID
                              SELECT DISTINCT OPERATION_ID,
                                     --COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, OPERATION_NAME, ERP_OPERATION_ID, CAPA_TYPE,
                                     ERP_OPERATION_ID
                              FROM   SCM_OPERATION_M WITH(NOLOCK)
               WHERE  OPERATION_ID IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 ) -- ## MIXER 공정..!!
                         ) E
                             ON   A.AFTER_OPERATION_ID = B.OPERATION_ID
                 ) A
                 INNER JOIN
                     -- SEQ로 WO SEQ 를 찾는다 
                     ( SELECT ORDER_NO, ORDER_ID FROM FP_ORDER_SEQ) B
                 ON A.SEQ = B.ORDER_NO
          ORDER BY A.WO_HEADER, A.NATION_CD, A.MASS_SAMPLE, A.YYMMDD_CODE, A.ERP_OPERATION_ID, B.ORDER_ID
          
          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY', 'INSERT', @n_log_count, null, @v_message, null 
          
          UPDATE  TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY
          SET     TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY.FIX_WORK_ORDER_ID  = B.FIX_WORK_ORDER_ID,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY.ATTB_1  = 'FIX_WO_UPDATE', 
                  TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY.CHANGE_ID          = @v_proc_name
          FROM    TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY A,
                  (
                    SELECT A.MASTER_ID, A.PLAN_ID, A.AFTER_SITE_ID, A.AFTER_OPERATION_ID, A.E1000_WORK_ORDER_ID, A.WORK_ORDER_ID
                         , B.FROM_WORK_ORDER_ID AS FIX_WORK_ORDER_ID
                         -- 20180115 KSJEON ADD
                         , ROW_NUMBER() OVER ( PARTITION BY A.MASTER_ID, A.PLAN_ID, A.AFTER_SITE_ID, A.AFTER_OPERATION_ID, B.FROM_WORK_ORDER_ID 
                                                   ORDER BY A.E1000_WORK_ORDER_ID, A.WORK_ORDER_ID ) FIX_SEQ
                    FROM   (     
                            SELECT A.MASTER_ID, A.PLAN_ID, A.AFTER_SITE_ID, A.AFTER_OPERATION_ID, A.E2000_WORK_ORDER_ID ,A.E1000_WORK_ORDER_ID, A.WORK_ORDER_ID
                                   , A.AFTER_ROUTE_ID, A.SEQ
                                   , A.E1000_ITEM_ID, A.ITEM_ID   -- 2018.07.25 : FROM_ITEM_ID, TO_ITEM_ID 연결
                            FROM   (       
                                    SELECT MASTER_ID, PLAN_ID, AFTER_SITE_ID, AFTER_OPERATION_ID, E2000_WORK_ORDER_ID ,E1000_WORK_ORDER_ID, WORK_ORDER_ID
                                           , AFTER_ROUTE_ID
                                           , E1000_ITEM_ID, ITEM_ID   -- 2018.07.25 : FROM_ITEM_ID, TO_ITEM_ID 연결
                                           , ROW_NUMBER() OVER ( PARTITION BY MASTER_ID, PLAN_ID, AFTER_SITE_ID, AFTER_OPERATION_ID, E1000_WORK_ORDER_ID
                                                                            , E1000_ITEM_ID, ITEM_ID    -- 2018.07.25 : FROM_ITEM_ID, TO_ITEM_ID 연결
                                                                 ORDER BY WORK_ORDER_ID ) SEQ
                                    FROM TH_BUF_E0500_PLAN_TARGET_FINAL
                                    WHERE MASTER_ID        = @v_master_id
                                    AND PLAN_ID            = @v_plan_id
                                    AND AFTER_SITE_ID      = @v_factory_id
                                    AND AFTER_OPERATION_ID  IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 ) -- ## PRE-MIXER 공정..!!
                                   ) A 
                            ) A,
                            (
                            SELECT A.INSTANCE_ID , A.FP_PLAN_ID, A.TO_FACTORY_ID, A.TO_OPERATION_ID, A.TO_WORK_ORDER_ID, A.FROM_WORK_ORDER_ID
                                   , A.FROM_LINE_ID, A.SEQ
                                   , A.FROM_ITEM_ID, A.TO_ITEM_ID     -- 2018.07.25 : FROM_ITEM_ID, TO_ITEM_ID 연결
                            FROM   (       
                                    SELECT INSTANCE_ID , FP_PLAN_ID, TO_FACTORY_ID, TO_OPERATION_ID, TO_WORK_ORDER_ID, FROM_WORK_ORDER_ID
                                           , FROM_LINE_ID
                               , FROM_ITEM_ID, TO_ITEM_ID     -- 2018.07.25 : FROM_ITEM_ID, TO_ITEM_ID 연결
                                           , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID , FP_PLAN_ID, TO_FACTORY_ID, TO_OPERATION_ID, TO_WORK_ORDER_ID
                                                                            , FROM_ITEM_ID, TO_ITEM_ID     -- 2018.07.25 : FROM_ITEM_ID, TO_ITEM_ID 연결
                                                                 ORDER BY FROM_WORK_ORDER_ID ) SEQ
                                    FROM FP_ORDER_PEGGING_R 
                                    WHERE INSTANCE_ID   = @v_master_id
                                    AND FP_PLAN_ID      = @release_plan_id
                                    AND TO_OPERATION_ID IN ( @v_wo_id_merge_op1, @v_wo_id_merge_op1 ) -- ## COATER  공정..!!
                                    AND TO_FACTORY_ID   = @v_factory_id
                                   ) A 
                           ) B
                    WHERE  A.MASTER_ID = B.INSTANCE_ID 
                    AND    A.AFTER_SITE_ID       = B.TO_FACTORY_ID
                    AND    A.SEQ                 = B.SEQ
                    --AND    A.AFTER_ROUTE_ID      = B.FROM_LINE_ID
                    --AND    A.E1000_ITEM_ID       = B.TO_ITEM_ID         
                    AND    A.ITEM_ID             = B.FROM_ITEM_ID       
                    AND    A.E2000_WORK_ORDER_ID = B.TO_WORK_ORDER_ID
                 ) B
          WHERE  A.MASTER_ID           = B.MASTER_ID
          AND    A.PLAN_ID             = B.PLAN_ID
          AND    A.WORK_ORDER_ID       = B.WORK_ORDER_ID
          AND    A.MASTER_ID           = @v_master_id
          AND    A.PLAN_ID             = @v_plan_id
          AND    A.AFTER_SITE_ID       = @v_factory_id            
          AND    A.AFTER_OPERATION_ID IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 ) -- ## PRE-MIXER 공정..!!
          AND    A.AFTER_QTY > 0
          AND    A.FIXED_YN = 'Y'
          AND    B.FIX_SEQ  = 1 --   ADD RELEASE PEGGING  에서 가져온 MIX의 FIX ORDER가 두개의 COATER 와 맵핑되는 경우가 있어 방지함
            
          SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY'

          UPDATE  TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY
          SET     TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY.FINAL_WORK_ORDER_ID  = B.NEW_WORK_ORDER_ID,
                  TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY.CHANGE_ID            = @V_PROC_NAME
          FROM    TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY A,
                  (
                    SELECT A.MASTER_ID, A.PLAN_ID
                           , A.MX_WO
                           , A.CT_WO
                           , A.NEW_WORK_ORDER_ID
                    FROM   (         
                            SELECT MASTER_ID,PLAN_ID
                                   , WORK_ORDER_ID AS MX_WO
                                   , DELETE_YN AS CT_WO
                                   , CASE WHEN -- FIXED_YN = 'Y'  AND 
                                               FIX_WORK_ORDER_ID IS NOT NULL
                                     THEN SUBSTRING(ISNULL( FIX_WORK_ORDER_ID, ISNULL( MERGE_WORK_ORDER_ID, WORK_ORDER_ID ) ), 1, 12 )
                                     ELSE ISNULL( FIX_WORK_ORDER_ID, ISNULL( MERGE_WORK_ORDER_ID, WORK_ORDER_ID ) )
                                     END  AS NEW_WORK_ORDER_ID
                            FROM   TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY
                            WHERE MASTER_ID      = @v_master_id
                            AND   PLAN_ID        = @v_plan_id
                            AND   AFTER_SITE_ID  = @v_factory_id
                            AND    AFTER_OPERATION_ID IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 ) -- ## PRE-MIXER 공정..!!
                            AND    AFTER_QTY > 0
                           ) A 
                 ) B
          WHERE  A.MASTER_ID           = B.MASTER_ID
 AND    A.PLAN_ID             = B.PLAN_ID
          AND    A.WORK_ORDER_ID       = B.MX_WO
          AND    A.DELETE_YN           = B.CT_WO

          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          SET @V_TABLE_NAME = 'TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY'

          UPDATE  TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY
          SET     FINAL_WORK_ORDER_ID  = CASE WHEN SUBSTRING(FINAL_WORK_ORDER_ID, 1, 1) IN ( 'W', 'M' ) THEN ''
                                              ELSE 'X' 
                                         END + FINAL_WORK_ORDER_ID,
                  FIXED_YN             = 'N',
                  ATTB_2               = 'NOT_FIX'
          WHERE MASTER_ID      = @v_master_id
          AND   PLAN_ID        = @v_plan_id
          AND   AFTER_SITE_ID  = @v_factory_id
          AND   AFTER_OPERATION_ID IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 ) -- ## PRE-MIXER 공정..!!
          AND   ATTB_1 IS NULL

          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'not fix UPDATE', @n_log_count, null, @v_message, null
          
          SET @v_table_name = 'TH_BUF_E0500_PLAN_TARGET_FINAL'

          UPDATE  TH_BUF_E0500_PLAN_TARGET_FINAL
          SET     TH_BUF_E0500_PLAN_TARGET_FINAL.WORK_ORDER_ID  = B.FINAL_WORK_ORDER_ID,
                  TH_BUF_E0500_PLAN_TARGET_FINAL.INSERT_ID      = 'CHANGE_WORK_ORDER'
          FROM    TH_BUF_E0500_PLAN_TARGET_FINAL A,
                  (
                    SELECT 
                           MASTER_ID,PLAN_ID, WORK_ORDER_ID, DELETE_YN AS E1000_WORK_ORDER_ID, FINAL_WORK_ORDER_ID
                    FROM   TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY
                    WHERE  MASTER_ID      = @v_master_id
                    AND    PLAN_ID        = @v_plan_id
                    AND    AFTER_SITE_ID  = @v_factory_id
                    AND    AFTER_OPERATION_ID IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 ) -- ## PRE-MIXER 공정..!!
                    AND    AFTER_QTY > 0
                    AND    FINAL_WORK_ORDER_ID IS NOT NULL
                 ) B
          WHERE  A.MASTER_ID           = B.MASTER_ID
          AND    A.PLAN_ID             = B.PLAN_ID
          AND    A.WORK_ORDER_ID       = B.WORK_ORDER_ID
          AND    A.E1000_WORK_ORDER_ID = B.E1000_WORK_ORDER_ID
                

          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          ---------------------------
          -- SY_FP_AMEND_PRODUCTION_PLAN_R  Pre - MIX Merge work order 반영
          ---------------------------
      
          SET @v_table_name = 'FP_AMEND_PRODUCTION_PLAN_R'

          DELETE FROM fp_amend_production_plan_r
          WHERE   MASTER_ID     = @v_master_id
          AND     PLAN_ID       = @v_plan_id
          and     AFTER_SITE_ID = @v_factory_id
          and     AFTER_OPERATION_ID in ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 ) -- ## Mixer 공정..!!

          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_AMEND_PRODUCTION_PLAN_R', 'DELETE', @n_log_count, null, @v_message, null 
          
          INSERT INTO FP_AMEND_PRODUCTION_PLAN_R
                     ( 
                      MASTER_ID,PLAN_ID,WORK_ORDER_ID,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
           ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE,BEFORE_START_TIME
                      ,AFTER_START_TIME,BEFORE_END_TIME,AFTER_END_TIME,WORKING_TIME,BEFORE_SEQ,AFTER_SEQ,BEFORE_QTY,AFTER_QTY,BEFORE_IN_QTY
                      ,AFTER_IN_QTY,ITEM_ID,FIXED_YN,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK,ORG_WORK_ORDER_ID
                      ,DEMAND_DUE_DATE,BATCH_ORDER_ID,DATE_FIX_FLAG,DATE_FIX_DATE,OPERATION_EPST,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                      ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_IN_QTY,BATCH_QTY,UI_EDIT_YN
                      ,MARKET,TOP_ITEM_ID
                      ,DESCRIPTION,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
                      , WORK_REQUEST_MODEL_ID    	-- (D20250319~R0319.01) PDS2
		      , VERSION    				-- (D20250319~R0319.01) PDS2
		      , PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
                      )        
          SELECT     A.MASTER_ID
                    ,A.PLAN_ID 
                    ,A.WORK_ORDER_ID
                    --,A.BEFORE_SITE_ID
                    ,MIN(A.BEFORE_SITE_ID) AS BEFORE_SITE_ID
                    ,A.AFTER_SITE_ID
                    --,A.BEFORE_ROUTE_ID
                    ,MIN(A.BEFORE_ROUTE_ID) AS BEFORE_ROUTE_ID
                    ,A.AFTER_ROUTE_ID
                    --,A.BEFORE_OPERATION_ID
                    ,MIN(A.BEFORE_OPERATION_ID) AS BEFORE_OPERATION_ID
                    ,A.AFTER_OPERATION_ID
                    ,MIN(A.BEFORE_RESOURCE_ID) AS BEFORE_RESOURCE_ID
                    ,A.AFTER_RESOURCE_ID
                    ,MIN(A.BEFORE_PLAN_DATE) AS BEFORE_PLAN_DATE
                    -- 20170620 KSJEON ,MAX(A.AFTER_PLAN_DATE)  AS AFTER_PLAN_DATE
                    ,MIN(A.AFTER_PLAN_DATE)  AS AFTER_PLAN_DATE
                    -----------------------
                    ,MIN(A.BEFORE_START_TIME) AS BEFORE_START_TIME
                    ,MIN(A.AFTER_START_TIME) AS AFTER_START_TIME
                    ,MAX(A.BEFORE_END_TIME) AS BEFORE_END_TIME
                    ,MAX(A.AFTER_END_TIME) AS AFTER_END_TIME
                    ,SUM(A.WORKING_TIME) AS WORKING_TIME
--                        ,A.BEFORE_START_TIME
--                        ,A.AFTER_START_TIME
--                        ,A.BEFORE_END_TIME
--                        ,A.AFTER_END_TIME
--                        ,A.WORKING_TIME
                    ,MIN(A.BEFORE_SEQ) AS BEFORE_SEQ
                    ,MIN(A.AFTER_SEQ)  AS AFTER_SEQ
                    -------------------------------------
                    ,SUM(A.BEFORE_QTY) AS BEFORE_QTY
                    ,SUM(A.AFTER_QTY) AS AFTER_QTY
                    ,SUM(A.BEFORE_IN_QTY) AS BEFORE_IN_QTY
                    ,SUM(A.AFTER_IN_QTY) AS AFTER_IN_QTY
--                        ,A.BEFORE_QTY
--                        ,A.AFTER_QTY
--                        ,A.BEFORE_IN_QTY
--                        ,A.AFTER_IN_QTY
                    ,MIN(A.ITEM_ID)   AS ITEM_ID
                    ,MIN(A.FIXED_YN)  AS FIXED_YN -- MAX -> MIN
                    ,MIN(A.SPLIT_YN)  AS SPLIT_YN 
                    ,MIN(A.DEMAND_ID) AS DEMAND_ID
                    --,A.DEMAND_TYPE
                    ,MAX(A.DEMAND_TYPE) AS DEMAND_TYPE 
                    ,MIN(A.ORDER_ID)          AS ORDER_ID
             ,MIN(A.ORDER_TYPE)        AS ORDER_TYPE
                    ,MIN(A.PO_ID)             AS PO_ID
                    ,MIN(A.MFG_WEEK)          AS MFG_WEEK
                    ,MIN(A.SOP_WEEK)          AS SOP_WEEK
                    ,MIN(A.ORG_WORK_ORDER_ID) AS ORG_WORK_ORDER_ID
                    ,MIN(A.DEMAND_DUE_DATE) AS DEMAND_DUE_DATE
                    ,MIN(A.BATCH_ORDER_ID)  AS BATCH_ORDER_ID
                    ,MIN(A.DATE_FIX_FLAG)   AS DATE_FIX_FLAG
                    ,MIN(A.DATE_FIX_DATE)   AS DATE_FIX_DATE
                    ,MIN(A.OPERATION_EPST)  AS OPERATION_EPST
                    ,MAX(A.OPERATION_LPST)  AS OPERATION_LPST
                    ,MIN(A.LANE_QTY)        AS LANE_QTY
                    ,MIN(A.LANE_TACT_QTY)   AS LANE_TACT_QTY
                    ,MIN(A.ITEM_UOM)        AS ITEM_UOM
                    ,MIN(A.WO_DAY_SPLIT_YN) AS WO_DAY_SPLIT_YN
                    ,MIN(A.SETUP_TIME)      AS SETUP_TIME
                    ,MIN(A.SETUP_TIME_UOM)  AS SETUP_TIME_UOM
                    ,SUM(A.BATCH_IN_QTY)    AS BATCH_IN_QTY
                    ,SUM(A.BATCH_QTY)       AS BATCH_QTY
                    ,MIN(A.UI_EDIT_YN)      AS UI_EDIT_YN
                    ,A.MARKET                                                  --- (20190717) Modify Market Info.   
                    --,MIN(CASE WHEN @v_master_id = 'CN_E_PRE_M' THEN 'D' ELSE A.MARKET END )          AS MARKET          
                    ,MIN(A.TOP_ITEM_ID)     AS TOP_ITEM_ID
                    ,MIN(A.DESCRIPTION)     AS DESCRIPTION
                    , @V_PROC_NAME AS INSERT_ID, GETDATE() AS INSERT_TIME
               , @V_PROC_NAME AS UPDATE_ID, GETDATE() AS UPDATE_TIME
               , A.WORK_REQUEST_MODEL_ID    	-- (D20250319~R0319.01) PDS2
		, A.VERSION    				-- (D20250319~R0319.01) PDS2
		, A.PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
          FROM     (     
                    SELECT   MASTER_ID
                            ,PLAN_ID 
                            --,WORK_ORDER_ID
                            ,ISNULL(FINAL_WORK_ORDER_ID, WORK_ORDER_ID) AS WORK_ORDER_ID
                            ,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
                            ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE
                            ,BEFORE_START_TIME
                            ,AFTER_START_TIME
                            ,BEFORE_END_TIME
                            ,AFTER_END_TIME
                            ,WORKING_TIME
                            ,BEFORE_SEQ
                            ,AFTER_SEQ
                            ,BEFORE_QTY
                            ,AFTER_QTY
                            ,BEFORE_IN_QTY
                            ,AFTER_IN_QTY
                            ,ITEM_ID
                            ,FIXED_YN
                            ,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK
                            ,ORG_WORK_ORDER_ID
                            ,DEMAND_DUE_DATE
                            -------------------
                            , BATCH_ORDER_ID
                            ------------------
                            ,DATE_FIX_FLAG,DATE_FIX_DATE
                            ,OPERATION_EPST
                            ,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                            ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM
                            ,BATCH_IN_QTY,BATCH_QTY
                            ,UI_EDIT_YN
                            ,MARKET
                            ,TOP_ITEM_ID
                            ,DESCRIPTION
                            , WORK_REQUEST_MODEL_ID    	-- (D20250319~R0319.01) PDS2
			, VERSION    				-- (D20250319~R0319.01) PDS2
			, PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
                 FROM TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY
                    WHERE MASTER_ID      = @V_MASTER_ID
                    AND   PLAN_ID        = @V_PLAN_ID
                    AND   AFTER_SITE_ID  = @V_FACTORY_ID  
                    AND   AFTER_OPERATION_ID IN ( @V_PMIX_WO_ID_MERGE_OP1, @V_PMIX_WO_ID_MERGE_OP2 ) -- MIXER 공정..!!
                    AND   AFTER_QTY > 0
                   ) A
          GROUP BY   A.MASTER_ID,A.PLAN_ID 
                      ,A.WORK_ORDER_ID
                      --,A.BEFORE_SITE_ID
                      ,A.AFTER_SITE_ID
                      --,A.BEFORE_ROUTE_ID
                      ,A.AFTER_ROUTE_ID
                      --,A.BEFORE_OPERATION_ID
                      ,A.AFTER_OPERATION_ID
                      ,A.AFTER_RESOURCE_ID
--                        ,A.BEFORE_START_TIME
--                        ,A.AFTER_START_TIME
--                        ,A.BEFORE_END_TIME
--                        ,A.AFTER_END_TIME
--                        ,A.WORKING_TIME
--                        ,A.BEFORE_QTY
--                        ,A.AFTER_QTY
--                        ,A.BEFORE_IN_QTY
--                        ,A.AFTER_IN_QTY
    --,A.DEMAND_TYPE
                      ,A.MARKET
                      , A.WORK_REQUEST_MODEL_ID    	-- (D20250319~R0319.01) PDS2
		  , A.VERSION    				-- (D20250319~R0319.01) PDS2
		  , A.PLM_EC_NO    				-- (D20250319~R0319.01) PDS2
                      
          SET @v_message = @@ROWCOUNT
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_AMEND_PRODUCTION_PLAN_R', 'INSERT', @n_log_count, null, @v_message, null             
                      
          SET @v_table_name = 'FP_AMEND_PRODUCTION_PLAN_R'

          UPDATE FP_AMEND_PRODUCTION_PLAN_R
          SET    FP_AMEND_PRODUCTION_PLAN_R.FIXED_YN    = B.NEW_FIXED_YN,
                 FP_AMEND_PRODUCTION_PLAN_R.UPDATE_ID   = 'FIX: ' + A.FIXED_YN + ' -> ' + B.NEW_FIXED_YN,
                 FP_AMEND_PRODUCTION_PLAN_R.UPDATE_TIME = GETDATE()
          FROM   FP_AMEND_PRODUCTION_PLAN_R A,
                 (
                  SELECT A.MASTER_ID, A.PLAN_ID, A.WORK_ORDER_ID, A.FIXED_YN, A.ITEM_ID, A.AFTER_SITE_ID
                         , B.FROM_WORK_ORDER_ID, B.FROM_FACTORY_ID, B.FROM_OPERATION_ID, B.FROM_ITEM_ID
                         , CASE WHEN A.ITEM_ID = ISNULL(B.FROM_ITEM_ID, '##') 
                                THEN 'Y'
                                ELSE 'N'
                           END AS NEW_FIXED_YN      
                  FROM   (
                          SELECT MASTER_ID, PLAN_ID, WORK_ORDER_ID, FIXED_YN, ITEM_ID, AFTER_SITE_ID
                          FROM   FP_AMEND_PRODUCTION_PLAN_R
                          WHERE  MASTER_ID      = @v_master_id
                          AND    PLAN_ID        = @v_plan_id
                          AND    AFTER_SITE_ID  = @v_factory_id
                          AND    AFTER_OPERATION_ID IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 ) -- PRE MIXER 공정..!!
                          --AND WORK_ORDER_ID IN ( 'K117706MX013', 'K117706MX014' )
                          AND   FIXED_YN = 'Y'
                         ) A
                         LEFT OUTER JOIN
                             ( 
                              SELECT INSTANCE_ID, FP_PLAN_ID, FROM_WORK_ORDER_ID, FROM_FACTORY_ID, FROM_OPERATION_ID, FROM_ITEM_ID
                              FROM   FP_ORDER_PEGGING_R
                              WHERE  1=1
                              AND    INSTANCE_ID        = @v_master_id
                              AND    FP_PLAN_ID         = @release_plan_id
                              AND    FROM_FACTORY_ID    = @v_factory_id
                              AND    FROM_OPERATION_ID  IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 ) --PRE MIXER 공정..!!
                              --AND    FROM_WORK_ORDER_ID IN ( 'K117706MX013', 'K117706MX014' )
                         ) B
                         ON   A.WORK_ORDER_ID = B.FROM_WORK_ORDER_ID
                         AND   A.ITEM_ID      = B.FROM_ITEM_ID
                  ) B 
          WHERE  A.MASTER_ID           = B.MASTER_ID
          AND    A.PLAN_ID             = B.PLAN_ID
          AND    A.AFTER_SITE_ID       = B.AFTER_SITE_ID
          AND    A.WORK_ORDER_ID       = B.WORK_ORDER_ID   
        
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null        
          
          DELETE FROM A
          -- SELECT A.* 
          FROM   FP_ORDER_PEGGING_R A,
                 SCM_FACTORY_M       B WITH(NOLOCK)
          WHERE  A.COMPANY_ID      = B.COMPANY_ID
          AND    A.DIVISION_ID     = B.DIVISION_ID
          AND    A.SITE_ID         = B.SITE_ID
          AND    A.PLANT_ID        = B.PLANT_ID
          AND    A.TO_FACTORY_ID   = B.FACTORY_ID
          AND    A.INSTANCE_ID     = @v_master_id
          AND    A.FP_PLAN_ID      = @v_plan_id
          AND    A.TO_FACTORY_ID   = @v_factory_id
          AND    A.TO_OPERATION_ID IN ( @v_mix_wo_id_merge_op1, @v_mix_wo_id_merge_op2 ) -- 'E1000'          

         SET @V_MESSAGE = @@ROWCOUNT
          SET @N_LOG_COUNT += 1
          EXECUTE PR_LOG_PROCESS  NULL, @V_MASTER_ID, @V_PLAN_ID, @V_PROC_NAME, 'FP_ORDER_PEGGING_R', 'DELETE', @N_LOG_COUNT, NULL, @V_MESSAGE, NULL 



          INSERT INTO FP_ORDER_PEGGING_R
                 (
                  	INSTANCE_ID 
        				  , FP_PLAN_ID 
        				  , COMPANY_ID 
        				  , DIVISION_ID
        				  , SITE_ID
        				  , PLANT_ID 
        				  , FROM_WORK_ORDER_ID 
        				  , FROM_STOCK_SET_ID
        				  , TO_WORK_ORDER_ID
        				  , FROM_FACTORY_ID 
        				  , TO_FACTORY_ID 
        				  , FROM_OPERATION_ID 
        				  , TO_OPERATION_ID 
        				  , FROM_QTY 
        				  , TO_QTY
        				  , FROM_ITEM_ID
        				  , TO_ITEM_ID 
        				  , DEMAND_ID
        				  , INSERT_ID
        				 ,  INSERT_TIME	      
                 )
          SELECT DISTINCT	A.INSTANCE_ID 
           					, A.FP_PLAN_ID 
           					, A.COMPANY_ID 
           					, A.DIVISION_ID
           					, A.SITE_ID
           					, A.PLANT_ID 
           					, A.FROM_WORK_ORDER_ID 
           					, A.FROM_STOCK_SET_ID
           					, B.TO_WORK_ORDER_ID
           					, A.FROM_FACTORY_ID 
           					, B.TO_FACTORY_ID 
           					, A.FROM_OPERATION_ID 
           					, B.TO_OPERATION_ID 
           					, A.FROM_QTY 
           					, B.TO_QTY
           					, A.FROM_ITEM_ID
           					, B.TO_ITEM_ID 
           					, B.DEMAND_ID
           					, @v_proc_name          AS INSERT_ID
             				, GETDATE()             AS INSERT_TIME	  
             FROM (
                    SELECT   A.MASTER_ID           AS INSTANCE_ID
                           , A.PLAN_ID             AS FP_PLAN_ID
                           , B.COMPANY_ID
                           , B.DIVISION_ID
                           , B.SITE_ID
                           , B.PLANT_ID
                           , A.WORK_ORDER_ID       AS FROM_WORK_ORDER_ID
                           , '-'                   AS FROM_STOCK_SET_ID
                           , A.E2000_WORK_ORDER_ID AS TO_WORK_ORDER_ID --A.E1000_WORK_ORDER_ID AS TO_WORK_ORDER_ID
                           , D.AFTER_SITE_ID       AS FROM_FACTORY_ID
                           , C.AFTER_SITE_ID       AS TO_FACTORY_ID
                           , D.AFTER_OPERATION_ID  AS FROM_OPERATION_ID
                           , C.AFTER_OPERATION_ID  AS TO_OPERATION_ID
                           , D.AFTER_QTY           AS FROM_QTY
                           , C.AFTER_QTY           AS TO_QTY
                           , D.ITEM_ID             AS FROM_ITEM_ID
                           , C.ITEM_ID             AS TO_ITEM_ID
                           , '-'                   AS DEMAND_ID
                  --SELECT A.*       
                    FROM  (
                            SELECT DISTINCT MASTER_ID, PLAN_ID, AFTER_SITE_ID, AFTER_OPERATION_ID, E1000_WORK_ORDER_ID, WORK_ORDER_ID , E2000_WORK_ORDER_ID 
                            FROM   TH_BUF_E0500_PLAN_TARGET_FINAL
                            WHERE  MASTER_ID = @v_master_id
                            AND    PLAN_ID   = @v_plan_id
                            AND    AFTER_OPERATION_ID IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 )
                           )A LEFT OUTER JOIN
                                (
                                 SELECT * 
                                 FROM   SCM_FACTORY_M WITH(NOLOCK)
                                 WHERE  FACTORY_ID = @v_factory_id
                                ) B
                                ON   A.AFTER_SITE_ID = B.FACTORY_ID
                              INNER JOIN
                                (
                                 -- MIXER 정보
                                 SELECT A.*
                                 FROM   (
    SELECT A.*
                                              , DENSE_RANK() OVER (PARTITION BY A.MASTER_ID
                                                                              , A.PLAN_ID
                                                                              , A.AFTER_SITE_ID
                                                                              , A.WORK_ORDER_ID
                                                                   ORDER     BY A.CHK) AS SEQ
                                         FROM   (
												 SELECT MASTER_ID ,
														PLAN_ID ,
														AFTER_SITE_ID ,
														AFTER_OPERATION_ID ,
														WORK_ORDER_ID,
														AFTER_QTY ,
														AFTER_IN_QTY ,
														ITEM_ID ,
														FIXED_YN ,
														DEMAND_ID ,
														DEMAND_TYPE ,
														MARKET ,
														1 AS CHK
                                                  FROM  FP_AMEND_PRODUCTION_PLAN_R
                                                  WHERE MASTER_ID = @v_master_id
                                                  AND	PLAN_ID = @v_plan_id 
                                                  AND   AFTER_SITE_ID   = @v_factory_id
                                                  AND   AFTER_OPERATION_ID  IN ( @v_wo_id_merge_op1, @v_wo_id_merge_op1 ) -- 'E2000'         
                                                ) A
                                       ) A
                                 WHERE SEQ = 1
                                ) C 
                                  ON   A.MASTER_ID           = C.MASTER_ID
                                  AND  A.PLAN_ID             = C.PLAN_ID
                                  --AND  A.AFTER_SITE_ID       = C.AFTER_SITE_ID
                                  AND  A.E2000_WORK_ORDER_ID = C.WORK_ORDER_ID
                              INNER JOIN
                                    (
                                     -- PRE-MIXER 정보
                                     SELECT MASTER_ID, PLAN_ID, AFTER_SITE_ID, AFTER_OPERATION_ID, FINAL_WORK_ORDER_ID, AFTER_QTY, AFTER_IN_QTY, ITEM_ID
                                          , FIXED_YN, DEMAND_ID, DEMAND_TYPE, MARKET
                                     FROM   TH_BUF_FP_AMEND_PROD_PLAN_R_PMIX_MER_APPLY
                                     WHERE  MASTER_ID          = @v_master_id
                                     AND    PLAN_ID            = @v_plan_id
                                     AND    AFTER_SITE_ID      = @v_factory_id
                                     AND    AFTER_OPERATION_ID IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 )    
                                     AND    AFTER_QTY > 0
                                    ) D 
                                  ON   A.MASTER_ID           = D.MASTER_ID
                                  AND  A.PLAN_ID             = D.PLAN_ID
                                  AND  A.AFTER_SITE_ID       = D.AFTER_SITE_ID
                                  AND  A.AFTER_OPERATION_ID  = D.AFTER_OPERATION_ID
                                  AND  A.WORK_ORDER_ID       = D.FINAL_WORK_ORDER_ID
           WHERE  A.MASTER_ID          = @v_master_id
                    AND    A.PLAN_ID            = @v_plan_id
                    AND    A.AFTER_SITE_ID      = @v_factory_id
                    AND    A.AFTER_OPERATION_ID IN ( @v_pmix_wo_id_merge_op1, @v_pmix_wo_id_merge_op2 )
            )A INNER JOIN FP_ORDER_PEGGING_R B WITH(NOLOCK)
            ON     A.INSTANCE_ID = B.INSTANCE_ID 
            AND    A.FP_PLAN_ID = B.FP_PLAN_ID 
            AND    A.COMPANY_ID = B.COMPANY_ID 
            AND		 A.DIVISION_ID = B.DIVISION_ID 
            AND		 A.SITE_ID = B.SITE_ID 
            AND		 A.TO_WORK_ORDER_ID = B.TO_WORK_ORDER_ID
            AND		 B.TO_OPERATION_ID IN ( @v_wo_id_merge_op1, @v_wo_id_merge_op2 )
            
            SET @v_message = @@ROWCOUNT
SET @v_table_name = 'FP_ORDER_PEGGING_R'
            SET @n_log_count = @n_log_count + 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
            
            /*
              선분산  TARGET W/O 강제생성
            */
            
            INSERT INTO FP_AMEND_PRODUCTION_PLAN_R
                       ( 
                        MASTER_ID,PLAN_ID,WORK_ORDER_ID,BEFORE_SITE_ID,AFTER_SITE_ID,BEFORE_ROUTE_ID,AFTER_ROUTE_ID,BEFORE_OPERATION_ID
                        ,AFTER_OPERATION_ID,BEFORE_RESOURCE_ID,AFTER_RESOURCE_ID,BEFORE_PLAN_DATE,AFTER_PLAN_DATE,BEFORE_START_TIME
                        ,AFTER_START_TIME,BEFORE_END_TIME,AFTER_END_TIME,WORKING_TIME,BEFORE_SEQ,AFTER_SEQ,BEFORE_QTY,AFTER_QTY,BEFORE_IN_QTY
                        ,AFTER_IN_QTY,ITEM_ID,FIXED_YN,SPLIT_YN,DEMAND_ID,DEMAND_TYPE,ORDER_ID,ORDER_TYPE,PO_ID,MFG_WEEK,SOP_WEEK,ORG_WORK_ORDER_ID
                        ,DEMAND_DUE_DATE,BATCH_ORDER_ID,DATE_FIX_FLAG,DATE_FIX_DATE,OPERATION_EPST,OPERATION_LPST,LANE_QTY,LANE_TACT_QTY,ITEM_UOM
                        ,WO_DAY_SPLIT_YN,SETUP_TIME,SETUP_TIME_UOM,BATCH_QTY,UI_EDIT_YN
                        ,MARKET, TOP_ITEM_ID
                        ,DESCRIPTION,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
                       )
            SELECT   A.MASTER_ID
                   , A.PLAN_ID
                   , ISNULL(A.WORK_ORDER_ID,
                            A.WO_HEADER + A.NATION_CD + A.MASS_SAMPLE + A.YYMMDD_CODE + A.ERP_OPERATION_ID + A.AFTER_SITE_ID + B.ORDER_ID
                           ) AS WORK_ORDER_ID
                   , A.BEFORE_SITE_ID,      A.AFTER_SITE_ID
                   , A.BEFORE_ROUTE_ID,     A.AFTER_ROUTE_ID
                   , A.BEFORE_OPERATION_ID, A.AFTER_OPERATION_ID
                   , A.BEFORE_RESOURCE_ID,  A.AFTER_RESOURCE_ID
                   , A.BEFORE_PLAN_DATE,    A.AFTER_PLAN_DATE
                   , A.BEFORE_START_TIME,   A.AFTER_START_TIME
                   , A.BEFORE_END_TIME,     A.AFTER_END_TIME
                   , A.WORKING_TIME
                   , A.BEFORE_SEQ,    A.AFTER_SEQ
                   , A.BEFORE_QTY,    A.AFTER_QTY
                   , A.BEFORE_IN_QTY, A.AFTER_IN_QTY
                   , A.ITEM_ID
                   , A.FIXED_YN
                   , A.SPLIT_YN
                   , A.DEMAND_ID
                   , A.DEMAND_TYPE
                   , A.ORDER_ID
                   , A.ORDER_TYPE
                   , A.PO_ID
                   , A.MFG_WEEK, A.SOP_WEEK, A.ORG_WORK_ORDER_ID
                   , A.DEMAND_DUE_DATE
                   , A.BATCH_ORDER_ID
                   , A.DATE_FIX_FLAG,  A.DATE_FIX_DATE
                   , A.OPERATION_EPST, A.OPERATION_LPST
                   , A.LANE_QTY,       A.LANE_TACT_QTY
                   , A.ITEM_UOM
                   , A.WO_DAY_SPLIT_YN, A.SETUP_TIME, A.SETUP_TIME_UOM, A.BATCH_QTY, A.UI_EDIT_YN
                   --, CASE WHEN @v_master_id = 'CN_E_PRE_M' THEN 'D' ELSE A.MARKET END AS MARKET   
				   , A.MARKET                                                                       --- (20190717) Modify Market Info.
                   , A.TOP_ITEM_ID
                   , A.DESCRIPTION
                   , @V_PROC_NAME AS INSERT_ID, GETDATE() AS INSERT_TIME
                   , @V_PROC_NAME AS UPDATE_ID, GETDATE() AS UPDATE_TIME
            FROM   (       
                    SELECT   A.INSTANCE_ID AS MASTER_ID
                           , A.DPP_PLAN_ID AS PLAN_ID
                           , A.WORK_ORDER_ID
                           ----------------------------------------------------------------------------------------------------------------
                           , ISNULL(F.WO_HEADER, 'M') AS WO_HEADER
                           , ISNULL(G.KEY_VALUE, 'K') AS NATION_CD
                           , ISNULL(H.KEY_VALUE, '1') AS MASS_SAMPLE
                , SUBSTRING(A.FP_PLAN_DATE, 3, 2)
                             + CASE SUBSTRING(A.FP_PLAN_DATE, 5, 2)
                                    WHEN '10' THEN 'A'
                                    WHEN '11' THEN 'B'
                                    WHEN '12' THEN 'C'
                                    ELSE SUBSTRING(A.FP_PLAN_DATE, 6, 1)
                               END
                             + SUBSTRING(A.FP_PLAN_DATE, 7, 2)
                             AS YYMMDD_CODE
                           , ISNULL(I.ERP_OPERATION_ID, 'MX') AS ERP_OPERATION_ID  
                           , ROW_NUMBER() OVER( PARTITION BY A.INSTANCE_ID, A.DPP_PLAN_ID, A.OPERATION_ID
                                                    ORDER BY A.DATE_YYYYMMDD, A.FACTORY_ID, A.LINE_ID, E.RESOURCE_GROUP_ID, A.ITEM_ID, A.SEQ )
                            AS WO_SEQ                        
                           ----------------------------------------------------------------------------------------------------------------
                           , A.FACTORY_ID          AS BEFORE_SITE_ID,      A.FACTORY_ID          AS AFTER_SITE_ID
                           , A.LINE_ID             AS BEFORE_ROUTE_ID,     A.LINE_ID             AS AFTER_ROUTE_ID
                           , A.OPERATION_ID        AS BEFORE_OPERATION_ID, A.OPERATION_ID        AS AFTER_OPERATION_ID
                           , E.RESOURCE_GROUP_ID   AS BEFORE_RESOURCE_ID,  E.RESOURCE_GROUP_ID   AS AFTER_RESOURCE_ID
                           , A.DATE_YYYYMMDD       AS BEFORE_PLAN_DATE,    A.DATE_YYYYMMDD       AS AFTER_PLAN_DATE
                           , A.DATE_YYMMDDHH24MISS AS BEFORE_START_TIME,   A.DATE_YYMMDDHH24MISS AS AFTER_START_TIME
                           , A.DATE_YYMMDDHH24MISS AS BEFORE_END_TIME,     A.DATE_YYMMDDHH24MISS AS AFTER_END_TIME
                           , 0 AS WORKING_TIME
                           , A.SEQ     AS BEFORE_SEQ
                           , A.SEQ     AS AFTER_SEQ
                           , A.MFG_QTY AS BEFORE_QTY
                           , A.MFG_QTY AS AFTER_QTY
                           , A.MFG_QTY / ISNULL(D.MIXER_YIELD, 1) AS BEFORE_IN_QTY
                           , A.MFG_QTY / ISNULL(D.MIXER_YIELD, 1) AS AFTER_IN_QTY
                           , A.ITEM_ID
                           , CASE WHEN A.WORK_ORDER_ID IS NOT NULL 
                                  THEN 'Y'
                                  ELSE 'N'
                             END AS FIXED_YN
                           , 'N'               AS SPLIT_YN
                           , A.FP_DEMAND_ID    AS DEMAND_ID
                           , A.PRODUCTION_TYPE AS DEMAND_TYPE
                           , NULL AS ORDER_ID
                           , 'W'  AS ORDER_TYPE
                           , NULL AS PO_ID
                           , A.MFG_WEEK AS MFG_WEEK
                           , A.MFG_WEEK AS SOP_WEEK
                           , A.WORK_ORDER_ID AS ORG_WORK_ORDER_ID
                           , A.DUE_DATE      AS DEMAND_DUE_DATE
                           , ISNULL(C.BATCH_ID, A.ITEM_ID) AS BATCH_ORDER_ID
     , NULL AS DATE_FIX_FLAG
                           , NULL AS DATE_FIX_DATE
                           , NULL AS OPERATION_EPST
                           , NULL AS OPERATION_LPST
                           , 0 AS LANE_QTY
                           , 0 AS LANE_TACT_QTY
                           , B.ITEM_UOM
                           , 'N'      AS WO_DAY_SPLIT_YN
                           , 0        AS SETUP_TIME
                           , 'SECOND' AS SETUP_TIME_UOM
                           , NULL     AS BATCH_QTY
                           , 'N'      AS UI_EDIT_YN
                           , A.MARKET
                           , A.TOP_ITEM_ID
                           , NULL     AS DESCRIPTION
                  FROM   (
                          SELECT      B.COMPANY_ID
                  				  , B.DIVISION_ID
                          				  , B.SITE_ID
                          				  , B.PLANT_ID
	                                 	 , @v_master_id as INSTANCE_ID, @v_plan_id as DPP_PLAN_ID
		                                 , SUBSTRING ( @v_plan_id, CHARINDEX( '-', @v_plan_id )+1, 8 ) AS FP_PLAN_DATE
		                                 , 'TEST' AS PRODUCTION_TYPE, B.MARKET
		                                 , B.ITEM_ID  AS TOP_ITEM_ID
		                                 , B.OPERATION_ID
		                                 , B.TEST_TARGET_ID AS FP_DEMAND_ID
		                                 , NULL  AS WORK_ORDER_ID 
		                                 , B.ITEM_ID 
		                                 , B.FACTORY_ID 
		                                 , B.LINE_ID 
		                                 , B.DUE_DATE 
		                                 , B.MFG_QTY
		                                 , A.WEEK AS MFG_WEEK
                                     , CONVERT(VARCHAR, CONVERT(DATETIME, B.DUE_DATE, 20) , 112) + '060000' as DATE_YYMMDDHH24MISS
		                               --  , DATEADD(MINUTE, 360, CONVERT(DATETIME, B.DUE_DATE, 20)) AS DATE_YYMMDDHH24MISS
		                                 --, DATEADD(MINUTE, @N_DAY_DIFF, CONVERT(DATETIME, B.DUE_DATE, 20)) AS DATE_YYMMDDHH24MISS
		                                 , CONVERT(VARCHAR, CONVERT(DATETIME, B.DUE_DATE, 20) , 112) AS DATE_YYYYMMDD
		                                 , ROW_NUMBER() OVER ( PARTITION BY B.FACTORY_ID, B.OPERATION_ID
		                                                           ORDER BY B.TEST_TARGET_ID ) AS SEQ
                          FROM  	SCM_SYS_CALENDAR_M A WITH(NOLOCK) , 
                          				 FP_WEEKLY_DEMAND_PRODUCT_TEST_H B WITH(NOLOCK)
                          WHERE  1=1
                          AND 	 A.DATE_ID = B.DUE_DATE
                          AND	 B.DUE_DATE >= @v_plan_date
                          AND    B.OPERATION_ID IN ( @V_PMIX_WO_ID_MERGE_OP1, @V_PMIX_WO_ID_MERGE_OP2 ) -- ## PRE-MIXER 공정..!!                                
                         ) A  INNER JOIN SCM_ITEM_M B WITH(NOLOCK)
                                   ON A.COMPANY_ID   = B.COMPANY_ID
                                   AND A.DIVISION_ID = B.DIVISION_ID
                                   AND A.SITE_ID     = B.SITE_ID
                                   AND A.ITEM_ID     = B.ITEM_ID
                              LEFT OUTER JOIN SCM_BATCH_M C WITH(NOLOCK)
                                   ON  A.COMPANY_ID  = C.COMPANY_ID
                                   AND A.DIVISION_ID = C.DIVISION_ID
                                   AND A.SITE_ID     = C.SITE_ID
                                   AND A.PLANT_ID    = C.PLANT_ID
                                   AND A.ITEM_ID     = C.ITEM_ID
                              LEFT OUTER JOIN ( -- * 수율 ( SCM_YIELD_M )
                                                SELECT FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, MONTH
                                                       , CASE WHEN YIELD = NULL THEN 1
                    WHEN YIELD = 0    THEN 1
                                                              ELSE YIELD
                                                         END AS MIXER_YIELD 
                                                FROM   SCM_YIELD_M WITH(NOLOCK)
                                                WHERE  1=0                          -- 2018.03.28 : MIXER 계획에서는 YIELD 를 반영하지 않는다.
                                                AND    FACTORY_ID   = @V_FACTORY_ID
                                                AND    OPERATION_ID IN ( @V_PMIX_WO_ID_MERGE_OP1, @V_PMIX_WO_ID_MERGE_OP2 ) -- ## MIXER 공정..!!
                                              )D
                                   ON   A.FACTORY_ID   = D.FACTORY_ID
                                   AND  A.OPERATION_ID = D.OPERATION_ID 
       AND  A.LINE_ID      = D.LINE_ID
                                   AND  A.ITEM_ID      = D.ITEM_ID
                                   AND  SUBSTRING(CONVERT(VARCHAR, CONVERT(DATETIME, A.DUE_DATE, 20) , 112), 1, 6) = D.MONTH             
                              INNER JOIN (-- 설비 할당
                                          SELECT A.ITEM_ID, A.FACTORY_ID AS SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.MONTH, MIN(A.RESOURCE_ID) AS RESOURCE_GROUP_ID
                                          FROM   (
                                                  SELECT A.ITEM_ID, A.FACTORY_ID, A.ROUTE_ID, A.OPERATION_ID, A.MONTH, B.RESOURCE_ID 
                                                  FROM   (
                                                          SELECT FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID AS ROUTE_ID, MONTH, PRIORITY AS ALT_PRIORITY, ACTIVE_FLAG 
                                                          FROM   (
                                                                  SELECT A.*
                                                                  FROM SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)  , SCM_LINE_M B WITH(NOLOCK)
                                                                  WHERE A.COMPANY_ID = B.COMPANY_ID 
                                                                  AND A.DIVISION_ID  = B.DIVISION_ID 
                                                                  AND A.SITE_ID = B.SITE_ID 
                                                                  AND A.PLANT_ID = B.PLANT_ID 
                                                                  AND A.FACTORY_ID = B.FACTORY_ID
                                                                  AND A.OPERATION_ID = B.OPERATION_ID 
                                                                  AND A.LINE_ID = B.LINE_ID 
                                                                  AND A.ELECTRODE_TYPE =  B.ELECTRODE_TYPE 
                                                                  AND A.ACTIVE_FLAG = 'Y'
                                                                  AND B.ACTIVE_FLAG = 'Y'
                                                                  )A
                                                          WHERE  FACTORY_ID   = @V_FACTORY_ID
                                                          AND    OPERATION_ID IN ( @V_PMIX_WO_ID_MERGE_OP1, @V_PMIX_WO_ID_MERGE_OP2 ) -- ## PRE MIXER 공정..!!
                                                          --AND    MONTH        = @V_PLAN_MONTH --'201707'
                                                          AND    MONTH        >= CONVERT(NVARCHAR(6), @V_PLAN_DATE, 112)
                                                          AND    MONTH        <= CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, @V_PLAN_DATE), 112)
                                                          AND    ACTIVE_FLAG  = 'Y'
                                                          --AND ITEM_ID = 'ASLAN0823A'
                                                          AND    PRIORITY IN ( 1, 2, 3, 4, 5, 6, 7, 8 ) -- 미사용 FLAG인것은 할당 제외 (0, 9,NULL)
                                                         ) A,
                                                         (
                                                          SELECT FACTORY_ID, OPERATION_ID, EQUIPMENT_ID AS RESOURCE_ID, LINE_ID AS ROUTE_ID, EQUIPMENT_TYPE, ACTIVE_FLAG
                                                          FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                                                          WHERE  EQUIPMENT_TYPE = 'M'
                                                          AND    FACTORY_ID     = @V_FACTORY_ID
                                                          AND    OPERATION_ID IN ( @V_PMIX_WO_ID_MERGE_OP1, @V_PMIX_WO_ID_MERGE_OP2 ) -- ##PRE MIXER 공정..!!
                                                          AND    ACTIVE_FLAG    = 'Y'
                       ) B
                                                  WHERE  A.FACTORY_ID   = B.FACTORY_ID
                                                  AND    A.OPERATION_ID = B.OPERATION_ID
                                                  AND    A.ROUTE_ID     = B.ROUTE_ID
                                                 ) A
                                          GROUP BY A.ITEM_ID, A.FACTORY_ID, A.ROUTE_ID, A.OPERATION_ID, A.MONTH
                                          ) E
                                   ON   A.OPERATION_ID = E.OPERATION_ID
                                   AND  A.FACTORY_ID   = E.SITE_ID
                                   AND  A.LINE_ID      = E.ROUTE_ID
                                   AND  A.ITEM_ID      = E.ITEM_ID               
                                   AND  CONVERT(NVARCHAR(6), A.DUE_DATE, 112) = E.MONTH
                               ---------------------------
                               -- WO 생성용 JOIN
                              LEFT OUTER JOIN (
                                                -- M ( 기확정은 사용안함 )WO_HEADER
                                                SELECT DISTINCT OPERATION_ID,
                                                       --COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, OPERATION_NAME, ERP_OPERATION_ID, CAPA_TYPE,
                                                       CASE WHEN WO_FLAG = 'Y' 
                                                            THEN 'W' 
                                                            ELSE 'M' 
                                                       END  AS WO_HEADER 
                                                FROM   SCM_OPERATION_M WITH(NOLOCK)
                                                WHERE  OPERATION_ID IN ( @V_PMIX_WO_ID_MERGE_OP1, @V_PMIX_WO_ID_MERGE_OP2 ) -- ## MIXER 공정..!!
                                              )F
                                  ON   A.OPERATION_ID = F.OPERATION_ID
                             LEFT OUTER JOIN (
                                              -- 국가코드
                                              SELECT INSTANCE_ID, KEY_VALUE  
                                              FROM   FP_INSTANCE_CONFIG_M WITH(NOLOCK)
                                              WHERE  1=1
                                              AND    INSTANCE_ID = @V_MASTER_ID
                                              AND    CATEGORY_ID = 'EXPORT'
                                              AND    KEY_ID      = 'INSTANCE_CODE'
                                             ) G
                                  ON   A.INSTANCE_ID = G.INSTANCE_ID
                           LEFT OUTER JOIN   (
                                              -- 샘플양산 구분
                                              SELECT KEY_ID, KEY_VALUE 
                                              FROM   FP_INSTANCE_CONFIG_M WITH(NOLOCK)
                                              WHERE  1=1
                                              AND    INSTANCE_ID = 'COMMON'
AND    KEY_ID      = 'MASS'
                                            ) H
                                ON   A.PRODUCTION_TYPE = H.KEY_ID
                           LEFT OUTER JOIN  (
                                            -- ERP_OPERATION_ID
                                            SELECT DISTINCT OPERATION_ID,
                                                   --COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, OPERATION_NAME, ERP_OPERATION_ID, CAPA_TYPE,
                                                   ERP_OPERATION_ID
                                            FROM   SCM_OPERATION_M WITH(NOLOCK)
                                            WHERE  OPERATION_ID IN ( @V_PMIX_WO_ID_MERGE_OP1, @V_PMIX_WO_ID_MERGE_OP2 ) -- ## MIXER 공정..!!
                                            ) I
                                ON   A.OPERATION_ID = I.OPERATION_ID     
            -- WO 생성용 JOIN
                  ) A                 
                  INNER JOIN
                      -- SEQ로 WO SEQ 를 찾는다 
                      ( SELECT ORDER_NO, ORDER_ID FROM FP_ORDER_SEQ) B
                    ON A.WO_SEQ = B.ORDER_NO
            ORDER BY A.WO_HEADER, A.NATION_CD, A.MASS_SAMPLE, A.YYMMDD_CODE, A.ERP_OPERATION_ID, B.ORDER_ID
            
            SET @v_message = @@ROWCOUNT
            SET @v_table_name = 'FP_ORDER_PEGGING_R TEST'
            SET @n_log_count = @n_log_count + 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
            
            
          END
        
        END  --SONG  

      END
      
      -- CANCEL 여부 정해지면 ..
      /*
      DELETE FROM FP_DAILY_INSTANCE_ORDER_STATUS
      WHERE  INSTANCE_ID  = @V_MASTER_ID
      AND    FP_PLAN_ID   = @V_PLAN_ID
      AND    INSTANCE_ID  LIKE '%E_PRE%'
      AND    OPERATION_ID = 'E0500'
      */
      
	  -- @@@ -- ERP I/F 사이즈 (nvarchar 30) 맞추기 위해
      UPDATE 	FP_AMEND_PRODUCTION_PLAN_R
      SET	 	DEMAND_ID = SUBSTRING(DEMAND_ID, 1,29)	-- ERP W/O I/F 사이즈 맞춤
      WHERE 	1=1
      AND    	MASTER_ID   = @v_master_id
      AND    	PLAN_ID   	= @v_plan_id
      ;
      

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
