CREATE PROCEDURE [dbo].[PR_SCM_OF_PSI_AMEND_UI_CALCULATION_FORM]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-' , @p_confirm_flag nvarchar(10) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_PSI_AMEND_UI_CALCULATION                                        **/
/** 프로그램 명   : PSI_AMEND_UI 수량변경분 재계산                                            **/
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
/** 2017.11.10    KSJEON         최초 작성                                                    **/
/** **/
/***********************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_company          nvarchar(30)   
  DECLARE @v_division         nvarchar(30)
  DECLARE @v_corporation      nvarchar(30)
  DECLARE @v_plant            nvarchar(30)
  DECLARE @v_master_id        nvarchar(30)    = @p_instance_id
  DECLARE @v_plan_id          nvarchar(30)    = @p_plan_id
  DECLARE @v_instance_id      nvarchar(30)    = @p_instance_id
  DECLARE @v_confirm_flag     nvarchar(10)    = @p_confirm_flag

  -- LOG 용 변수 설정
  DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_OF_PSI_AMEND_UI_CALCULATION_FORM'
  DECLARE @v_table_name       nvarchar(100)
  DECLARE @v_message          nvarchar(250)
  DECLARE @v_descr            nvarchar(250)
  DECLARE @n_row_count        Integer  = 0
  DECLARE @n_log_count        Integer  = 0
  DECLARE @v_log_code         nvarchar(10)
  
  DECLARE @logdate            DATETIME2 = GETDATE()
  DECLARE @sysdate            DATETIME2 = GETDATE()

  DECLARE @v_temp1            nvarchar(1000)
  DECLARE @v_temp2            nvarchar(1000)
  
  DECLARE @v_plan_week        nvarchar(6)
  
  DECLARE @v_plan_date        date
  
  DECLARE @v_top_plan_id      nvarchar(30)
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  IF @v_confirm_flag ='N'
  BEGIN
    EXEC PR_LOG_RUNLOG  @logdate, @v_master_id, @v_plan_id, @v_proc_name, 'START', null
  END
  
  SELECT	@v_plan_week = B.WEEK 
                     FROM	SCM_FP_PLAN_H A, 
                          scm_sys_calendar_m B 
                     WHERE	A.INSTANCE_ID = @v_INSTANCE_ID 
                     AND		A.PLAN_ID = @v_PLAN_ID
                     AND		CONVERT(DATE, A.PLAN_START_TIME, 112) = B.DATE_ID
  
  SELECT	@v_plan_date = B.date_id 
                     FROM	SCM_FP_PLAN_H A, 
                          scm_sys_calendar_m B 
                     WHERE	A.INSTANCE_ID = @v_INSTANCE_ID 
                     AND		A.PLAN_ID = @v_PLAN_ID
                     AND		CONVERT(DATE, A.PLAN_START_TIME, 112) = B.DATE_ID
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN
    
      BEGIN
        
        SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE PSI_CAL_STATUS'
        
         --SELECT ATTRIBUTE5
         UPDATE SCM_SYS_LOOKUP_VALUE
         SET    ATTRIBUTE5 = 'Y'
    		 WHERE	1=1
    		 AND	LOOKUP_TYPE_CODE = 'INSTANCE_ID'
    		 AND	SEGMENT1 = @V_INSTANCE_ID
         
                 --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
      END  
      
      -- 사용하지 않아 제외 20230803 by cys
      /*
      IF @p_confirm_flag = 'Y' -- Confirm 시에만 rollback table 저장하겠음.
      BEGIN
      -- AMEND 값으로 FP_DAILY_PRODUCTION_PLAN_R 값 재 계산
      -- FP_DAILY_PRODUCTION_PLAN_R
      
        SET @v_table_name = 'FP_DAILY_PRODUCTION_PLAN_ROLLBACK_R'
        
        DELETE FROM FP_DAILY_PRODUCTION_PLAN_ROLLBACK_R WHERE INSERT_DTTM < DATEADD(DAY, -3, GETDATE())
        
        DELETE FROM FP_DAILY_PRODUCTION_PLAN_ROLLBACK_R
        WHERE  1=1
        AND    INSTANCE_ID = @v_master_id
        AND    FP_PLAN_ID  = @v_plan_id    

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        INSERT INTO FP_DAILY_PRODUCTION_PLAN_ROLLBACK_R
        SELECT  *
        FROM   FP_DAILY_PRODUCTION_PLAN_R
        WHERE  1=1
        and    instance_id = @v_master_id
        and    fp_plan_id  = @v_plan_id    

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'BACK UP', @n_log_count, null, @v_message, null
        
      END
      */
      
      /*begin
      
          UPDATE FP_AMEND_PLAN_FORM_R
          SET ITEM_TYPE = A.ITEM_TYPE
          FROM (
                SELECT ITEM_TYPE ,ITEM_ID
                FROM FP_AMEND_PLAN_FORM_R
                WHERE INSTANCE_ID = @V_MASTER_ID
                AND    FP_PLAN_ID  = @V_PLAN_ID
                AND    ITEM_TYPE IS NOT NULL
                GROUP BY ITEM_TYPE , ITEM_ID
                )A
          WHERE FP_AMEND_PLAN_FORM_R.INSTANCE_ID = @v_master_id
          AND   FP_AMEND_PLAN_FORM_R.FP_PLAN_ID = @v_plan_id
          AND   FP_AMEND_PLAN_FORM_R.ITEM_ID = A.ITEM_ID
      
      end*/
      
      BEGIN
        
          UPDATE FP_AMEND_PLAN_FORM_R
          SET ITEM_TYPE = A.ITEM_TYPE
          FROM (
                SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,
                       A.ITEM_ID,
                       (CASE WHEN LEFT(A.FLOW_ID,5) = 'A9000' AND ISNULL(C.LEVEL_4_NAME, '-') = '-' THEN C.LEVEL_3_NAME
                       	     WHEN LEFT(A.FLOW_ID,5) = 'A9000' THEN ISNULL(C.LEVEL_4_NAME, '-')
                       	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,
                       ISNULL(A.NICK_NAME,'-') AS NICK_NAME
                FROM	 SCM_ITEM_M A WITH(NOLOCK),
                  		 SCM_ITEM_CLASS_M C WITH(NOLOCK)
                WHERE	 A.ITEM_CLASS  = C.CLASS_ID
          )A
          WHERE FP_AMEND_PLAN_FORM_R.INSTANCE_ID = @v_master_id
          AND   FP_AMEND_PLAN_FORM_R.FP_PLAN_ID = @v_plan_id
          AND   FP_AMEND_PLAN_FORM_R.ITEM_ID = A.ITEM_ID
          AND   FP_AMEND_PLAN_FORM_R.ITEM_TYPE IS NULL
          AND   FP_AMEND_PLAN_FORM_R.COMPANY_ID = A.COMPANY_ID 
          AND   FP_AMEND_PLAN_FORM_R.DIVISION_ID = A.DIVISION_ID 
          AND   FP_AMEND_PLAN_FORM_R.SITE_ID = A.SITE_ID
      
      END
      
       -- 사용하지 않아 제외 20230803 by cys
      /*
      IF @p_confirm_flag = 'Y'    -- Confirm 시에만 rollback table 저장하겠음.
      BEGIN
      -- AMEND 값으로 FP_DAILY_PRODUCTION_PLAN_R 값 재 계산
      -- FP_DAILY_PRODUCTION_PLAN_R
      
        SET @v_table_name = 'FP_AMEND_PLAN_FORM_ROLLBACK_R'
        
        delete from FP_AMEND_PLAN_FORM_ROLLBACK_R
        where  1=1
        and    instance_id = @v_master_id
        and    fp_plan_id  = @v_plan_id    

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        INSERT INTO FP_AMEND_PLAN_FORM_ROLLBACK_R
        SELECT  *
        FROM   FP_AMEND_PLAN_FORM_R
        WHERE  1=1
        and    instance_id = @v_master_id
        and    fp_plan_id  = @v_plan_id    

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'BACK UP', @n_log_count, null, @v_message, null
        
      END
		*/
      
      BEGIN
      
        SET @v_table_name = 'FP_DAILY_PRODUCTION_PLAN_R'

        delete from FP_DAILY_PRODUCTION_PLAN_R
        where  1=1
        and    instance_id = @v_master_id
        and    fp_plan_id  = @v_plan_id    

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
        
                
        insert into FP_DAILY_PRODUCTION_PLAN_R
                (
                  instance_id,
                  fp_plan_id,
                  company_id,
                  division_id,
                  site_id,
                  plant_id,
                  factory_id,
                  work_order_spl_id,
                  work_order_id,
                  org_demand_id,
                  demand_id,
                  item_id,
                  top_item_id,
                  operation_id,
                  line_id,
                  electrode_type,
                  equipment_id,
                  plan_date,
                  start_time,
                  end_time,
                  plan_qty,
                  plan_in_qty,
                  item_uom,
                  roll_in_qty,
                  roll_out_qty,
                  jr_in_qty,
                  jr_out_qty,
                  batch_in_qty,
                  batch_out_qty,
                  fix_type,
                  production_type,
                  total_working_time,
                  line_item_seq,
                  operation_item_seq,
                  lane_qty,
                  lane_tact_qty,
                  batch_order_id,
                  bin_order_id,
                  mfg_week,
                  demand_division_id,
                  market,
                  insert_id,
                  insert_dttm
                )
        select	instance_id,
              	fp_plan_id,
              	company_id,
              	division_id,
              	site_id,
              	plant_id,
              	factory_id,
              	item_id + '_' + operation_id + '_' + line_id + '_' + electrode_type + '_' +convert(varchar(8), plan_date, 112) + '_' + production_type + '_' + market as work_order_spl_id,
              	item_id + '_' + operation_id + '_' + line_id + '_' + electrode_type + '_' +convert(varchar(8), plan_date, 112) + '_' + production_type + '_' + market as work_order_id,
              	item_id + '_' + operation_id + '_' + line_id + '_' + electrode_type + '_' +convert(varchar(8), plan_date, 112) + '_' + production_type + '_' + market as org_demand_id,
              	item_id + '_' + operation_id + '_' + line_id + '_' + electrode_type + '_' +convert(varchar(8), plan_date, 112) + '_' + production_type + '_' + market as demand_id,
              	item_id,
              	top_item_id,
              	operation_id,
              	line_id,
              	electrode_type,
              	'-' as equipment_id,
              	plan_date,
              	plan_date as start_time,
              	plan_date + 1 as end_time,
              	ISNULL(out_qty,0) as plan_qty,
              	ISNULL(in_qty,0) as plan_in_qty,
              	null as item_uom,
              	null as roll_in_qty,
              	null as roll_out_qty,
              	null as jr_in_qty,
              	null as jr_out_qty,
              	null as batch_in_qty,
              	null as batch_out_qty,
              	null as fix_type,
              	production_type,
              	86400 as total_working_time,
              	1 as line_item_seq,
              	1 as operation_item_seq,
              	null as lane_qty,
              	null as lane_tact_qty,
              	null as batch_order_id,
              	null as bin_order_id,
              	null as mfg_week,
              	null as demand_division_id,
                market,
              	@v_proc_name as insert_id,
              	getdate() as insert_dttm
              		
        from 	FP_AMEND_PLAN_FORM_R
        where 	1=1
        and 	instance_id = @v_instance_id
        and		fp_plan_id = @v_plan_id
        --and		ISNULL(out_qty,0) > 0  // 0 값 없으면 Activated 등 부가 정보 생성 아구빠짐.
        and   line_id != '-'
        and   plan_date >= @v_plan_date
        
        --LOG 생성
        SET @v_message   = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
      
        SET @v_table_name = 'PR_SCM_OF_PSI_AMEND_UI_CAL'

        --LOG 생성
        SET @v_message   = 'PROCEDURE Start'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null

        EXEC(@v_instance_id+'_SY_PR_SCM_OF_PSI_AMEND_UI_CAL '''+@v_instance_id+''','''+@v_plan_id+''','''+ @v_confirm_flag + '''')
        
        SET @v_message   = 'PROCEDURE End'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null
              
      END
      
/*
      BEGIN
      
         EXECUTE PR_SCM_AMEND_PLAN_FORM_ACTIVATED_CAL  @v_master_id , @v_plan_id
      
      END*/
      
      
      BEGIN
        
        SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE PSI_CAL_STATUS'
        
         --SELECT ATTRIBUTE5
         UPDATE SCM_SYS_LOOKUP_VALUE
         SET    ATTRIBUTE5 = 'N'
    		 WHERE	1=1
    		 AND	LOOKUP_TYPE_CODE = 'INSTANCE_ID'
    		 AND	SEGMENT1 = @V_INSTANCE_ID
         
                 --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
      END 
      
      IF @v_confirm_flag = 'Y'
      BEGIN
      
        EXEC(@v_instance_id+'_PR_SCM_OF_FORM_ADDITIONAL_INFO '''+@v_instance_id+''','''+@v_plan_id+''',''N'+'''')
        
      END
      
    END
    
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

      BEGIN
        
        SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE PSI_CAL_STATUS'
        
         --SELECT ATTRIBUTE5
         UPDATE SCM_SYS_LOOKUP_VALUE
         SET    ATTRIBUTE5 = 'N'
    		 WHERE	1=1
    		 AND	LOOKUP_TYPE_CODE = 'INSTANCE_ID'
    		 AND	SEGMENT1 = @V_INSTANCE_ID
         
                 --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
      END 
    
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    EXEC PR_LOG_RUNLOG  @logdate, @v_master_id, @v_plan_id, @v_proc_name, 'ERROR', null
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null
  
  IF @v_confirm_flag ='N'
  BEGIN
    EXEC PR_LOG_RUNLOG  @logdate, @v_master_id, @v_plan_id, @v_proc_name, 'END', null
  END

END
