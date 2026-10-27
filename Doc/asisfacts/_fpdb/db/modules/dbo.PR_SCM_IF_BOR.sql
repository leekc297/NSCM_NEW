CREATE PROCEDURE [dbo].[PR_SCM_IF_BOR]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_BOR                                                             **/
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
/** 2016.08.18    LJH          최초 작성                                                      **/
/** 2016.08.24    SHS          OP RESOURCE CAL 추가                                           **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_BOR
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
  DECLARE @plan_type        nvarchar(30)
  DECLARE @v_daydiff        Integer

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_BOR'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)

  -------------------------------------------------------------------------------------------
  -- LINE 인지 EQUIPMENT 인지 설정하는 변수... 아주 중요
  -------------------------------------------------------------------------------------------
   DECLARE @res_category      nvarchar(10)
  -------------------------------------------------------------------------------------------
  
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
              @plan_end_time   = PLAN_END_DTTM,
              @plan_type = PLAN_TYPE,
              @v_daydiff = DAYDIFF,
              @key_date = PLAN_DATE
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     PLAN_TYPE,
                     DATEDIFF(MINUTE,CONVERT(DATE,PLAN_START_DTTM), PLAN_START_DTTM) AS DAYDIFF,
                     PLAN_DATE
              FROM   TH_MST_PLAN
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
             ) A
             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

      SELECT  @res_category = isnull(max(key_value), 'LINE')
      FROM    SY_FP_INSTANCE_CONFIG_M
      WHERE   instance_id = @v_master_id
      AND     category_id = 'RESOURCE_CATEGORY'
      AND     KEY_ID = @plan_type

      --LOG 생성
      SET @v_message = '@res_category : ' + @res_category
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
    END;
    
    
    BEGIN

      SET @v_table_name = 'TH_BUF_SCM_UTILIZATION'
      
      DELETE FROM TH_BUF_SCM_UTILIZATION
      WHERE  INSTANCE_ID = @v_master_id
      AND    FP_PLAN_ID = @v_plan_id
    
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      
      SET @v_table_name = 'TH_BUF_SCM_UTILIZATION'

      INSERT INTO TH_BUF_SCM_UTILIZATION
            (
             INSTANCE_ID
            ,FP_PLAN_ID
	          ,COMPANY_ID
          	,DIVISION_ID
          	,SITE_ID
          	,PLANT_ID
          	,FACTORY_ID
          	,LINE_ID
          	,OPERATION_ID
          	,ELECTRODE_TYPE
          	,EQUIPMENT_ID
          	,MONTH
          	,LOSS_RATE
          	,TOTAL_EQUIP_MONTH_TIME
          	,TOTAL_OFF_TIME
          	,TOTAL_WORK_TIME
          	,LOSS_TIME
          	,NET_LOSS_RATE
          	,UTILIZATION
            ,NET_UTILIZATION
          	,INSERT_ID
          	,INSERT_TIME
            )
      SELECT @v_master_id AS INSTANCE_ID,
             @v_plan_id AS FP_PLAN_ID,
              A.COMPANY_ID, 
              A.DIVISION_ID, 
              A.SITE_ID, 
              A.PLANT_ID, 
              A.FACTORY_ID, 
              A.LINE_ID, 
              A.OPERATION_ID, 
              A.ELECTRODE_TYPE, 
              A.EQUIPMENT_ID, 
              A.LOSS_MONTH AS MONTH, 
				      ISNULL(B.LOSS_RATE,0) AS LOSS_RATE,
				      DATEDIFF(DAY, CONVERT(DATE, A.LOSS_MONTH + '01'), DATEADD(MONTH, 1, CONVERT(DATE, A.LOSS_MONTH + '01')))*86400 AS TOTAL_EQUIP_MONTH_TIME,
				      ISNULL(C.SUM_OFF_TIME,0) AS SUM_OFF_TIME, 
				      DATEDIFF(DAY, CONVERT(DATE, A.LOSS_MONTH + '01'), DATEADD(MONTH, 1, CONVERT(DATE, A.LOSS_MONTH + '01')))*86400-ISNULL(C.SUM_OFF_TIME,0) AS TOTAL_WORK_TIME, 
					    DATEDIFF(DAY, CONVERT(DATE, A.LOSS_MONTH + '01'), DATEADD(MONTH, 1, CONVERT(DATE, A.LOSS_MONTH + '01')))*86400*isnull(B.LOSS_RATE,0) AS LOSS_TIME,
					    CASE WHEN (DATEDIFF(DAY, CONVERT(DATE, A.LOSS_MONTH + '01'), DATEADD(MONTH, 1, CONVERT(DATE, A.LOSS_MONTH + '01')))*86400-ISNULL(C.SUM_OFF_TIME,0)) = 0 THEN 0 
                   ELSE ISNULL((DATEDIFF(DAY, CONVERT(DATE, A.LOSS_MONTH + '01'), DATEADD(MONTH, 1, CONVERT(DATE, A.LOSS_MONTH + '01')))*86400*isnull(B.LOSS_RATE,0))/(DATEDIFF(DAY, CONVERT(DATE, A.LOSS_MONTH + '01'), DATEADD(MONTH, 1, CONVERT(DATE, A.LOSS_MONTH + '01')))*86400-ISNULL(C.SUM_OFF_TIME,0)),0) 
                   END AS NET_LOSS_RATE,
              1-ISNULL(B.LOSS_RATE,0) AS UTILIZATION,
					    CASE WHEN (DATEDIFF(DAY, CONVERT(DATE, A.LOSS_MONTH + '01'), DATEADD(MONTH, 1, CONVERT(DATE, A.LOSS_MONTH + '01')))*86400-ISNULL(C.SUM_OFF_TIME,0)) = 0 THEN 1 
                   ELSE 1-ISNULL((DATEDIFF(DAY, CONVERT(DATE, A.LOSS_MONTH + '01'), DATEADD(MONTH, 1, CONVERT(DATE, A.LOSS_MONTH + '01')))*86400*isnull(B.LOSS_RATE,0))/(DATEDIFF(DAY, CONVERT(DATE, A.LOSS_MONTH + '01'), DATEADD(MONTH, 1, CONVERT(DATE, A.LOSS_MONTH + '01')))*86400-ISNULL(C.SUM_OFF_TIME,0)),0) 
                   END AS NET_UTILIZATION,              
					    @v_proc_name AS INSERT_ID, 
              GETDATE() AS INSERT_TIME
			FROM (
						  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, LOSS_MONTH, B.EQUIPMENT_ID
  						FROM (
    								SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, LOSS_MONTH   				
    								FROM  (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.EQUIPMENT_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.BASIS_MONTH, LOSS_MONTH, LOSS_RATE,
        										       RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.LOSS_MONTH ORDER BY A.BASIS_MONTH desc) as RNK
        										FROM (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, C.LINE_ID, A.OPERATION_ID, C.ELECTRODE_TYPE, C.EQUIPMENT_ID,  
        												SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),1,4) + SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),6,2) AS BASIS_MONTH, 
        												A.MONTH AS LOSS_MONTH, SUM(A.LOSS_RATE) AS LOSS_RATE
        												FROM SY_SCM_LINE_LOSS_M A, SY_SCM_EQUIPMENT_M C
        												WHERE 1=1
        											    AND   A.COMPANY_ID = C.COMPANY_ID
        												AND   A.DIVISION_ID = C.DIVISION_ID
        												AND   A.SITE_ID = C.SITE_ID
        												AND   A.PLANT_ID = C.PLANT_ID
        												AND   A.OPERATION_ID = C.OPERATION_ID
        												AND   A.LINE_ID = C.LINE_ID
        												AND   A.ELECTRODE_TYPE = C.ELECTRODE_TYPE
        												AND   C.ACTIVE_FLAG = 'Y'
--        												AND   A.EQUIPMENT_ID = C.EQUIPMENT_ID
        											    AND   A.MONTH >= SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),1,4) + SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),6,2)
        												GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, C.LINE_ID, A.OPERATION_ID, C.ELECTRODE_TYPE, C.EQUIPMENT_ID, A.MONTH) A) A				
    								WHERE 1=1
    								AND RNK = 1) A,
  								  SY_SCM_EQUIPMENT_M B
  						WHERE 1=1
  						AND   A.COMPANY_ID = B.COMPANY_ID
  						AND   A.DIVISION_ID = B.DIVISION_ID
  						AND   A.SITE_ID = B.SITE_ID
  						AND   A.PLANT_ID = B.PLANT_ID
  						AND   A.FACTORY_ID = B.FACTORY_ID
  						AND   A.LINE_ID = B.LINE_ID
  						AND   A.OPERATION_ID = B.OPERATION_ID
  						AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
  						AND   B.ACTIVE_FLAG = 'Y'
  						AND   B.EQUIPMENT_TYPE = 'M') A
				LEFT OUTER JOIN (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.BASIS_MONTH, A.LOSS_MONTH, A.LOSS_RATE   				
									FROM   (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.EQUIPMENT_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.BASIS_MONTH, LOSS_MONTH, LOSS_RATE,
											       RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.LOSS_MONTH ORDER BY A.BASIS_MONTH desc) as RNK
											FROM (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, C.LINE_ID, A.OPERATION_ID, C.ELECTRODE_TYPE, C.EQUIPMENT_ID,  
        												SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),1,4) + SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),6,2) AS BASIS_MONTH, 
        												A.MONTH AS LOSS_MONTH, SUM(A.LOSS_RATE) AS LOSS_RATE
        												FROM SY_SCM_LINE_LOSS_M A, SY_SCM_EQUIPMENT_M C
        												WHERE 1=1
        											    AND   A.COMPANY_ID = C.COMPANY_ID
        												AND   A.DIVISION_ID = C.DIVISION_ID
        												AND   A.SITE_ID = C.SITE_ID
        												AND   A.PLANT_ID = C.PLANT_ID
        												AND   A.OPERATION_ID = C.OPERATION_ID
        												AND   A.LINE_ID = C.LINE_ID
        												AND   A.ELECTRODE_TYPE = C.ELECTRODE_TYPE
        												AND   C.ACTIVE_FLAG = 'Y'
--        												AND   A.EQUIPMENT_ID = C.EQUIPMENT_ID
        											    AND   A.MONTH >= SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),1,4) + SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),6,2)
        												GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, C.LINE_ID, A.OPERATION_ID, C.ELECTRODE_TYPE, C.EQUIPMENT_ID, A.MONTH) A) A				
									WHERE 1=1
									AND RNK = 1) B
				ON 	A.COMPANY_ID = B.COMPANY_ID
				AND A.DIVISION_ID = B.DIVISION_ID
				AND A.SITE_ID = B.SITE_ID
				AND A.PLANT_ID = B.PLANT_ID
				AND A.FACTORY_ID = B.FACTORY_ID
				AND A.LINE_ID = B.LINE_ID
				AND A.OPERATION_ID = B.OPERATION_ID
				AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				AND A.EQUIPMENT_ID = B.EQUIPMENT_ID
				AND A.LOSS_MONTH = B.LOSS_MONTH
				LEFT OUTER JOIN (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.EQUIPMENT_ID, A.OFF_MONTH, SUM(A.SUM_OFF_TIME) AS SUM_OFF_TIME
				FROM (SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, EQUIPMENT_ID,
									  CONVERT(DATE, DATEADD(MINUTE, @v_daydiff * (-1), OFF_START_TIME)) AS PLAN_DATE, 
									  SUBSTRING(CONVERT(NVARCHAR, DATEADD(MINUTE, @v_daydiff * (-1), OFF_START_TIME), 112), 1, 6) AS OFF_MONTH,
									   OFF_START_TIME, OFF_END_TIME, DATEDIFF(SECOND, OFF_START_TIME, OFF_END_TIME) AS SUM_OFF_TIME
								FROM TH_MST_SCM_OFF_CALENDAR A 
                     --SY_SCM_OFF_CALENDAR_M A
								WHERE 1=1
                AND   MASTER_ID = @v_master_id
                AND   PLAN_ID   = @v_plan_id
								--AND   SUBSTRING(CONVERT(NVARCHAR, DATEADD(HOUR, -6, OFF_START_TIME), 112), 1, 6) >= SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),1,4) + SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),6,2)
              ) A
						WHERE  1=1		
						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.EQUIPMENT_ID, A.OFF_MONTH) C
				ON  A.COMPANY_ID = C.COMPANY_ID
				AND A.DIVISION_ID = C.DIVISION_ID
				AND A.SITE_ID = C.SITE_ID
				AND A.PLANT_ID = C.PLANT_ID
				AND A.FACTORY_ID = C.FACTORY_ID
				AND A.LINE_ID = C.LINE_ID
				AND A.OPERATION_ID = C.OPERATION_ID
				AND A.EQUIPMENT_ID = C.EQUIPMENT_ID
				AND A.LOSS_MONTH = C.OFF_MONTH				
      WHERE 1=1

      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
    END;
    
    BEGIN

      SET @v_table_name = 'TH_MST_LINE_EQUIP_MAP'
      
      DELETE FROM TH_MST_LINE_EQUIP_MAP
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
    
      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null


      SET @v_table_name = 'TH_MST_LINE_EQUIP_MAP - EXCEPT'

      INSERT INTO TH_MST_LINE_EQUIP_MAP
            (
             MASTER_ID
            ,PLAN_ID
            ,EQUIPMENT_ID
            ,FACTORY_ID
            ,OPERATION_ID
            ,LINE_ID
            ,ELECTRODE_TYPE
            ,TOP_LINE_ID
            ,FP_RESOURCE_ID
            ,FP_RESOURCE_COUNT
            ,LINE_SETUP_GROUP_ID
            ,WORK_CENTER_ID
            ,COMPANY_ID
            ,DIVISION_ID
            ,SITE_ID
            ,PLANT_ID
            ,KEY_DATE
            ,INSERT_ID
            ,INSERT_DTTM
            ,UPDATE_ID
            ,UPDATE_DTTM
            )
      SELECT DISTINCT
             @v_master_id AS MASTER_ID
            ,@v_plan_id   AS PLAN_ID
            ,B.EQUIPMENT_ID
            ,A.FACTORY_ID
            ,A.OPERATION_ID
            ,B.LINE_ID
            ,b.ELECTRODE_TYPE
            ,NULL AS TOP_LINE_ID
            ,CASE WHEN @res_category = 'EQUIPMENT' THEN B.EQUIPMENT_ID
                  ELSE
                       B.LINE_ID +'_'+A.OPERATION_ID
                                 +CASE B.ELECTRODE_TYPE 
                                      WHEN NULL   THEN '' 
                                      WHEN ''     THEN '' 
                                      WHEN '-'    THEN '' 
                                      ELSE '_'+ B.ELECTRODE_TYPE 
                                  END 
                                 +'_'+B.EQUIPMENT_ID 
             END  AS LINE_RESOURCE
            ,0 AS FP_RESOURCE_COUNT
            ,C.LINE_SETUP_GROUP_ID
            ,CASE WHEN @res_category = 'EQUIPMENT' THEN B.WORK_CENTER_ID
                  ELSE ''
             END  AS WORK_CENTER_ID
            ,A.COMPANY_ID
            ,A.DIVISION_ID
            ,A.SITE_ID
            ,A.PLANT_ID
            ,@key_date  AS KEY_DATE
            ,@v_proc_name as INSERT_ID
            ,GETDATE() as INSERT_DTTM
            ,@v_proc_name as UPDATE_ID
            ,getdate() as UPDATE_DTTM
      FROM   SY_SCM_ITEM_EQUIPMENT_ASSIGN_EXCEPT_M A
            ,SY_SCM_EQUIPMENT_M       B
            ,SY_SCM_LINE_M            C
            ,SY_FP_INSTANCE_FACTORY_M D        -- INSTANCE 에 해당하는 FACTORY 만 추출
            ,SY_SCM_OPERATION_M       E        -- INSTANCE 에 해당하는 OPERATION 만 추출 
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.OPERATION_ID = B.OPERATION_ID
      AND    A.EQUIPMENT_ID = B.EQUIPMENT_ID
      AND    B.COMPANY_ID = C.COMPANY_ID
      AND    B.DIVISION_ID = C.DIVISION_ID
      AND    B.SITE_ID = C.SITE_ID
      AND    B.PLANT_ID = C.PLANT_ID
      AND    B.FACTORY_ID = C.FACTORY_ID
      AND    B.OPERATION_ID = C.OPERATION_ID
      AND    B.LINE_ID = C.LINE_ID
      AND    B.ELECTRODE_TYPE = C.ELECTRODE_TYPE
      AND    A.FACTORY_ID = D.FACTORY_ID
      AND    D.INSTANCE_TYPE = E.INSTANCE_TYPE
      AND    C.COMPANY_ID = E.COMPANY_ID
      AND    C.DIVISION_ID = E.DIVISION_ID
      AND    C.SITE_ID = E.SITE_ID
      AND    C.OPERATION_ID = E.OPERATION_ID
      AND    D.INSTANCE_ID = @v_master_id

      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      

      SET @v_table_name = 'TH_MST_LINE_EQUIP_MAP - NORMAL'

      INSERT INTO TH_MST_LINE_EQUIP_MAP
            (
             MASTER_ID
            ,PLAN_ID
            ,EQUIPMENT_ID
            ,FACTORY_ID
            ,OPERATION_ID
            ,LINE_ID
            ,ELECTRODE_TYPE
            ,TOP_LINE_ID
            ,FP_RESOURCE_ID
            ,FP_RESOURCE_COUNT
            ,LINE_SETUP_GROUP_ID
            ,WORK_CENTER_ID
            ,COMPANY_ID
            ,DIVISION_ID
            ,SITE_ID
            ,PLANT_ID
            ,KEY_DATE
            ,INSERT_ID
            ,INSERT_DTTM
            ,UPDATE_ID
            ,UPDATE_DTTM
            )
      SELECT DISTINCT
             @v_master_id AS MASTER_ID
            ,@v_plan_id   AS PLAN_ID
            ,B.EQUIPMENT_ID
            ,A.FACTORY_ID
            ,A.OPERATION_ID
            ,A.LINE_ID
            ,A.ELECTRODE_TYPE
            ,A.TOP_LINE_ID
            ,CASE WHEN @res_category = 'EQUIPMENT' THEN B.EQUIPMENT_ID
                  ELSE
                       A.LINE_ID +'_'+A.OPERATION_ID
                                 +CASE A.ELECTRODE_TYPE 
                                      WHEN NULL   THEN '' 
                                      WHEN ''     THEN '' 
                                      WHEN '-'    THEN '' 
                                      ELSE '_'+A.ELECTRODE_TYPE 
                                  END  
             END  AS LINE_RESOURCE
            ,0 AS FP_RESOURCE_COUNT
            ,A.LINE_SETUP_GROUP_ID
            ,CASE WHEN @res_category = 'EQUIPMENT' THEN B.WORK_CENTER_ID
                  ELSE MIN(B.WORK_CENTER_ID) OVER ( PARTITION BY A.LINE_ID +'_'+A.OPERATION_ID
                                                                           +CASE A.ELECTRODE_TYPE 
                                                                                WHEN NULL   THEN '' 
                                                                                WHEN ''     THEN '' 
                                                                                WHEN '-'    THEN '' 
                                                                                ELSE '_'+A.ELECTRODE_TYPE 
                                                                            END )
             END  AS WORK_CENTER_ID
            ,A.COMPANY_ID
            ,A.DIVISION_ID
            ,A.SITE_ID
            ,A.PLANT_ID
            ,@key_date  AS KEY_DATE
            ,@v_proc_name as INSERT_ID
            ,GETDATE() as INSERT_DTTM
            ,@v_proc_name as UPDATE_ID
            ,getdate() as UPDATE_DTTM
      FROM   SY_SCM_LINE_M            A
            ,SY_SCM_EQUIPMENT_M       B
            ,SY_FP_INSTANCE_FACTORY_M C        -- INSTANCE 에 해당하는 FACTORY 만 추출
            ,SY_SCM_OPERATION_M       D        -- INSTANCE 에 해당하는 OPERATION 만 추출
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.OPERATION_ID = B.OPERATION_ID
      AND    A.LINE_ID = B.LINE_ID
      AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
      AND    A.ACTIVE_FLAG = 'Y'
      AND    B.EQUIPMENT_TYPE = 'M'
      AND    B.ACTIVE_FLAG = 'Y'
      AND    A.FACTORY_ID = C.FACTORY_ID
      AND    C.INSTANCE_TYPE = D.INSTANCE_TYPE
      AND    A.COMPANY_ID = D.COMPANY_ID
      AND    A.DIVISION_ID = D.DIVISION_ID
      AND    A.SITE_ID = D.SITE_ID
      AND    A.OPERATION_ID = D.OPERATION_ID
      AND    C.INSTANCE_ID = @v_master_id
      AND    NOT EXISTS  (
                          SELECT 1
                          FROM   TH_MST_LINE_EQUIP_MAP X
                          WHERE  X.MASTER_ID = @v_master_id
                          AND    X.PLAN_ID   = @v_plan_id
                          AND    X.COMPANY_ID = B.COMPANY_ID
                          AND    X.DIVISION_ID = B.DIVISION_ID
                          AND    X.SITE_ID = B.SITE_ID
                          AND    X.PLANT_ID = B.PLANT_ID
                          AND    X.OPERATION_ID = B.OPERATION_ID
        AND    X.LINE_ID = B.LINE_ID
                          AND    X.ELECTRODE_TYPE = B.ELECTRODE_TYPE
                          AND    X.EQUIPMENT_ID = B.EQUIPMENT_ID
                         )

      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      SET @v_table_name = 'TH_MST_LINE_EQUIP_MAP - FP_RESOURCE_COUNT'

      UPDATE TH_MST_LINE_EQUIP_MAP
      SET    TH_MST_LINE_EQUIP_MAP.FP_RESOURCE_COUNT = B.RES_COUNT
      FROM   TH_MST_LINE_EQUIP_MAP A,
             (
              SELECT A.*,
                     COUNT(1) OVER (PARTITION BY FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, FP_RESOURCE_ID) RES_COUNT
              FROM   TH_MST_LINE_EQUIP_MAP A
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
             ) B
      WHERE  A.MASTER_ID = B.MASTER_ID
      AND    A.PLAN_ID = B.PLAN_ID
      AND    A.EQUIPMENT_ID = B.EQUIPMENT_ID

      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
            
      SET @v_table_name = 'TH_MST_LINE_EQUIP_MAP - UTILIZATION'
      /*
      UPDATE TH_MST_LINE_EQUIP_MAP
      SET    TH_MST_LINE_EQUIP_MAP.UTILIZATION = B.LOSS_RATE
      FROM   TH_MST_LINE_EQUIP_MAP A,
             (
                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID,
                       MIN(100  - A.NON_OP_BM_RATE 
                                - A.NON_OP_CM_RATE 
                                - A.NON_OP_PD_RATE 
                                - A.NON_OP_UTIL_RATE 
                                - A.NON_OP_SPEED_RATE ) / 100.0 AS LOSS_RATE
                FROM   SY_SCM_LOSS_M A
                GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID
            ) B
      WHERE   A.COMPANY_ID      = B.COMPANY_ID
      AND     A.DIVISION_ID     = B.DIVISION_ID
      AND     A.SITE_ID         = B.SITE_ID
      AND     A.PLANT_ID        = B.PLANT_ID
      AND     A.FACTORY_ID      = B.FACTORY_ID
      AND     A.OPERATION_ID    = B.OPERATION_ID
      AND     A.LINE_ID         = B.LINE_ID
      AND     A.MASTER_ID       = @v_master_id
      AND     A.PLAN_ID         = @v_plan_id
      */
      IF @res_category = 'EQUIPMENT'
        BEGIN        
          UPDATE TH_MST_LINE_EQUIP_MAP
          SET    TH_MST_LINE_EQUIP_MAP.UTILIZATION = ISNULL(B.UTILIZATION,1)
          FROM   TH_MST_LINE_EQUIP_MAP A
                 LEFT OUTER JOIN TH_BUF_SCM_UTILIZATION B
                      ON A.MASTER_ID = B.INSTANCE_ID
                      AND A.PLAN_ID = B.FP_PLAN_ID
                      AND A.COMPANY_ID = B.COMPANY_ID
                      AND A.DIVISION_ID = B.DIVISION_ID
                      AND A.SITE_ID = B.SITE_ID
                      AND A.OPERATION_ID = B.OPERATION_ID
                      AND A.LINE_ID = B.LINE_ID
                      AND A.EQUIPMENT_ID = B.EQUIPMENT_ID
                      AND B.MONTH = SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),1,4) + SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),6,2)
          WHERE 1=1
          AND     A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          /*
                 (
                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID,B.ELECTRODE_TYPE, 
                             A.LINE_ID +'_'+ A.OPERATION_ID + ( CASE WHEN B.ELECTRODE_TYPE = '-' THEN '' ELSE '_'+ B.ELECTRODE_TYPE END ) AS FP_RESOURCE_ID,
                             1-SUM(LOSS_RATE) AS LOSS_RATE
                      FROM    SY_SCM_UTILIZATION_M A,
                              SY_SCM_EQUIPMENT_M B
                      WHERE 1=1
                      AND A.BASIS_MONTH = A.LOSS_MONTH
                      AND A.BASIS_MONTH = SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),1,4) + SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),6,2)
                      AND A.OFF_TYPE_ID IN (SELECT SEGMENT1
                                            FROM SY_SCM_SYS_LOOKUP_VALUE
                                            WHERE 1=1
                                            AND LOOKUP_TYPE_CODE = 'CAPACITY_LOSS_TYPE'
                                            AND ATTRIBUTE3 = 'Y'   )
                      AND A.EQUIPMENT_ID = B.EQUIPMENT_ID                    
                      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, B.ELECTRODE_TYPE 
                ) B
          WHERE   A.COMPANY_ID      = B.COMPANY_ID
          AND     A.DIVISION_ID     = B.DIVISION_ID
          AND     A.SITE_ID         = B.SITE_ID
          AND     A.PLANT_ID        = B.PLANT_ID
          AND     A.FACTORY_ID      = B.FACTORY_ID
          AND     A.OPERATION_ID    = B.OPERATION_ID
          AND     A.LINE_ID         = B.LINE_ID
          AND     A.EQUIPMENT_ID    = B.EQUIPMENT_ID
          AND     A.MASTER_ID       = @v_master_id
          AND     A.PLAN_ID         = @v_plan_id
          */
        END
      ELSE
          UPDATE TH_MST_LINE_EQUIP_MAP
            SET    TH_MST_LINE_EQUIP_MAP.UTILIZATION = ISNULL(B.UTILIZATION,1)
            FROM   TH_MST_LINE_EQUIP_MAP A
                   LEFT OUTER JOIN (
                      				SELECT INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, MONTH, 
                      				       LINE_ID +'_'+ OPERATION_ID + ( CASE WHEN ELECTRODE_TYPE = '-' THEN '' ELSE '_'+ ELECTRODE_TYPE END ) AS FP_RESOURCE_ID,
                      				       SUM(TOTAL_EQUIP_MONTH_TIME) AS TOTAL_EQUIP_MONTH_TIME, SUM(TOTAL_OFF_TIME) AS TOTAL_OFF_TIME,
                      				       SUM(TOTAL_WORK_TIME) AS TOTAL_WORK_TIME, SUM(LOSS_TIME) AS LOSS_TIME,
                      				       AVG(NET_LOSS_RATE) AS NET_LOSS_RATE, AVG(UTILIZATION) AS UTILIZATION
                      				FROM TH_BUF_SCM_UTILIZATION
                      				WHERE 1=1
                      				AND INSTANCE_ID = @v_master_id
                      				AND FP_PLAN_ID = @v_plan_id
                      				AND MONTH = SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),1,4) + SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),6,2)
                      				GROUP BY INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, MONTH) B
                      	ON A.MASTER_ID = B.INSTANCE_ID
                      	AND A.PLAN_ID = B.FP_PLAN_ID
                      	AND A.COMPANY_ID = B.COMPANY_ID
                      	AND A.DIVISION_ID = B.DIVISION_ID
                      	AND A.SITE_ID = B.SITE_ID
                      	AND A.OPERATION_ID = B.OPERATION_ID
                      	AND A.LINE_ID = B.LINE_ID
                      	AND A.FP_RESOURCE_ID = B.FP_RESOURCE_ID
            WHERE 1=1
            AND     A.MASTER_ID = @v_master_id
            AND     A.PLAN_ID = @v_plan_id
            /*
            FROM   TH_MST_LINE_EQUIP_MAP A,
                   (
                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.FP_RESOURCE_ID, 
                             MAX(A.LOSS_RATE) AS MAX_LOSS_RATE, MIN(A.LOSS_RATE) AS MIN_LOSS_RATE, AVG(A.LOSS_RATE) AS AVG_LOSS_RATE
                      FROM (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID,B.ELECTRODE_TYPE, 
                                 A.LINE_ID +'_'+ A.OPERATION_ID + ( CASE WHEN B.ELECTRODE_TYPE = '-' THEN '' ELSE '_'+ B.ELECTRODE_TYPE END ) AS FP_RESOURCE_ID,
                                 1-SUM(LOSS_RATE) AS LOSS_RATE
                          FROM SY_SCM_UTILIZATION_M A,
                               SY_SCM_EQUIPMENT_M B
                          WHERE 1=1
                          AND A.BASIS_MONTH = A.LOSS_MONTH
                          AND A.BASIS_MONTH = SUBSTRING(CONVERT(nvarchar,getdate(), 120),1,4) + SUBSTRING(CONVERT(nvarchar,getdate(), 120),6,2)
                          AND A.OFF_TYPE_ID IN (SELECT SEGMENT1
                                    FROM SY_SCM_SYS_LOOKUP_VALUE
                                    WHERE 1=1
                                    AND LOOKUP_TYPE_CODE = 'CAPACITY_LOSS_TYPE'
                                    AND ATTRIBUTE3 = 'Y'   )
                          AND A.EQUIPMENT_ID = B.EQUIPMENT_ID                    
                          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, B.ELECTRODE_TYPE   ) A
                      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.FP_RESOURCE_ID 
                  ) B
            WHERE   A.COMPANY_ID      = B.COMPANY_ID
            AND     A.DIVISION_ID     = B.DIVISION_ID
            AND     A.SITE_ID         = B.SITE_ID
            AND     A.PLANT_ID        = B.PLANT_ID
            AND     A.FACTORY_ID      = B.FACTORY_ID
            AND     A.OPERATION_ID    = B.OPERATION_ID
            AND     A.LINE_ID         = B.LINE_ID
            AND     A.FP_RESOURCE_ID  = B.FP_RESOURCE_ID
            AND     A.MASTER_ID       = @v_master_id
            AND     A.PLAN_ID         = @v_plan_id
            */
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

    END

    /*
      TH_MST_OP_RESOURCE_CAL
    */
    BEGIN
      
      SET @v_table_name = 'TH_BUF_SCM_LINE_CALENDAR_A' 
      
      TRUNCATE TABLE TH_BUF_SCM_LINE_CALENDAR_A

      -- EQUIPMEN 기준 CALENDAR 구간에 대해 설정함.
      -- 구간별 TACT TIME 반영하기 위함.
      
      BEGIN
        
        INSERT INTO TH_BUF_SCM_LINE_CALENDAR_A
              (
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , OPERATION_ID
              , LINE_ID
              , ELECTRODE_TYPE
              , START_DATE
              , END_DATE
              , EQUIPMENT_ID
              , FP_RESOURCE_ID
              , FP_RESOURCE_COUNT
              )
        SELECT 
                A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.OPERATION_ID
              , A.LINE_ID
              , A.ELECTRODE_TYPE
              , A.START_DATE
              , A.END_DATE
              , B.EQUIPMENT_ID
              , B.FP_RESOURCE_ID
              , B.FP_RESOURCE_COUNT
        FROM   (
                SELECT 
                        A.COMPANY_ID
                      , A.DIVISION_ID
                      , A.SITE_ID
                      , A.PLANT_ID
                      , A.FACTORY_ID
                      , A.OPERATION_ID
                      , A.LINE_ID
   , A.ELECTRODE_TYPE
                      , A.START_DATE
                      , LEAD(A.START_DATE, 1, NULL) OVER (PARTITION BY 
          A.COMPANY_ID
                                                                , A.DIVISION_ID
                                                                , A.SITE_ID
                                                                , A.PLANT_ID
                                                                , A.FACTORY_ID
                                                                , A.OPERATION_ID
                                                                , A.LINE_ID
                                                                , A.ELECTRODE_TYPE
                                                    ORDER     BY  A.START_DATE ) END_DATE
                FROM   (
                        SELECT DISTINCT *
                        FROM   (
                                SELECT 
                                        COMPANY_ID
                                      , DIVISION_ID
                                      , SITE_ID
                                      , PLANT_ID
                                      , FACTORY_ID
                                      , OPERATION_ID
                                      , LINE_ID
                                      , ELECTRODE_TYPE
                                      , START_DATE
                                FROM    SY_SCM_LINE_M A,
                                        (
                                          SELECT DATEADD(MM, INT-1, PST_START) START_DATE
                                          FROM   (
                                                  SELECT DATEADD(DD, DATEDIFF(DD, PST_MONTH_DATE, PST_DATE) * (-1), PST) PST_START
                                                  FROM   (-- 년월일 시분초를 년월일로 변환
                                                          SELECT CONVERT(DATE, CONVERT(nvarchar, DATEPART(YEAR, PST) * 10000 + DATEPART(MONTH, PST) * 100 + 1)) PST_MONTH_DATE,
                                                                 CONVERT(DATE, PST) AS PST_DATE,
                                                                 PST
                                                          FROM   ( 
                                                                  SELECT @plan_start_time AS PST
                                                                 ) A
                                                         ) A
                                                 ) A,
                                                 COPYT B
                                          WHERE  DATEDIFF(M, @plan_start_time, @plan_end_time)+2 >= INT
                                          /*
                                          SELECT CONVERT(DATE, CONVERT(nvarchar, DATEPART(YEAR, DX) * 10000 + DATEPART(MONTH, DX) * 100 + 1)) START_DATE 
                                          FROM   (
                                                  SELECT DATEADD(MM, INT - 1  , @plan_start_time) DX, '1' FLAG
                                                  FROM   COPYT
                                                  WHERE DATEDIFF(M, @plan_start_time, @plan_end_time)+2 >= INT
                                                 ) A
                                          */
                                        ) B
                                WHERE  A.ACTIVE_FLAG = 'Y'
                                AND    EXISTS ( SELECT  1
                                                FROM    TH_MST_INSTANCE_FLOW X
                                                WHERE   A.COMPANY_ID    = X.COMPANY_ID
                                                AND     A.DIVISION_ID   = X.DIVISION_ID
                                                AND     A.SITE_ID       = X.SITE_ID
                                                AND     A.PLANT_ID      = X.PLANT_ID
                 AND     A.FACTORY_ID    = X.FACTORY_ID
                                                AND     A.OPERATION_ID  = X.OPERATION_ID
                                                AND     X.MASTER_ID     = @v_master_id
                                                AND     X.PLAN_ID       = @v_plan_id )
                                UNION  ALL
                                -- TACT_TIME EXCEPT_M 넣기
                                SELECT 
                                        A.COMPANY_ID
                                      , A.DIVISION_ID
                                      , A.SITE_ID
                                      , A.PLANT_ID
                                      , A.FACTORY_ID
                                      , A.OPERATION_ID
                                      , A.LINE_ID
                                      , A.ELECTRODE_TYPE
                                      , CASE WHEN R = 1 THEN 
                                                              CASE WHEN B.START_TIME < @plan_start_time   THEN @plan_start_time
                                                                                                          ELSE B.START_TIME
                                                              END
                                                        ELSE 
                                                              CASE WHEN B.END_TIME   > @plan_end_time     THEN @plan_end_time
                                                                                                          ELSE B.END_TIME
                                                              END
                                        END  START_DATE
                                FROM   SY_SCM_LINE_M              A,
                                       SY_SCM_TACT_TIME_EXCEPT_M  B,
                                       (SELECT 1 R UNION ALL
                                        SELECT 2 R ) C
                                WHERE  A.COMPANY_ID = B.COMPANY_ID             
                                AND    A.DIVISION_ID = B.DIVISION_ID
                                AND    A.SITE_ID = B.SITE_ID
                                AND    A.PLANT_ID = B.PLANT_ID
                                AND    A.FACTORY_ID = B.FACTORY_ID
                                AND    A.LINE_ID = B.LINE_ID
                                AND    A.OPERATION_ID = B.OPERATION_ID
                                AND    A.ACTIVE_FLAG = 'Y'
                                AND    B.START_TIME < B.END_TIME
                                AND    B.END_TIME > @plan_start_time
                                AND    B.START_TIME < @plan_end_time
                                AND    EXISTS ( SELECT  1
                                                FROM    TH_MST_INSTANCE_FLOW X
                                                WHERE   A.COMPANY_ID    = X.COMPANY_ID
                                                AND     A.DIVISION_ID   = X.DIVISION_ID
                                                AND     A.SITE_ID       = X.SITE_ID
                                                AND     A.PLANT_ID      = X.PLANT_ID
                                                AND     A.FACTORY_ID    = X.FACTORY_ID
                                                AND     A.OPERATION_ID  = X.OPERATION_ID
                                                AND     X.MASTER_ID     = @v_master_id
                                                AND     X.PLAN_ID       = @v_plan_id )
                                UNION  ALL
                                -- YIELD EXCEPT_M 넣기
                                SELECT 
                                        A.COMPANY_ID
                                      , A.DIVISION_ID
                                      , A.SITE_ID
                                      , A.PLANT_ID
                                      , A.FACTORY_ID
     , A.OPERATION_ID
                                      , A.LINE_ID
                                      , A.ELECTRODE_TYPE
                                    , CASE WHEN R = 1 THEN 
                                                              CASE WHEN B.START_TIME < @plan_start_time   THEN @plan_start_time
                                                                                                          ELSE B.START_TIME
                                                              END
                                                        ELSE 
                                                              CASE WHEN B.END_TIME   > @plan_end_time     THEN @plan_end_time
                                                                                                          ELSE B.END_TIME
                                                              END
                                        END  START_DATE
                                FROM   SY_SCM_LINE_M          A, 
                                       SY_SCM_YIELD_EXCEPT_M  B,
                                       (SELECT 1 R UNION ALL
                                        SELECT 2 R ) C
                                WHERE  A.COMPANY_ID = B.COMPANY_ID             
                                AND    A.DIVISION_ID = B.DIVISION_ID
                                AND    A.SITE_ID = B.SITE_ID
                                AND    A.PLANT_ID = B.PLANT_ID
                                AND    A.FACTORY_ID = B.FACTORY_ID
                                AND    A.LINE_ID = B.LINE_ID
                                AND    A.OPERATION_ID = B.OPERATION_ID
                                AND    A.ACTIVE_FLAG = 'Y'
                                AND    B.START_TIME < B.END_TIME
                                AND    B.END_TIME > @plan_start_time
                                AND    B.START_TIME < @plan_end_time
                                AND    EXISTS ( SELECT  1
                                                FROM    TH_MST_INSTANCE_FLOW X
                                                WHERE   A.COMPANY_ID    = X.COMPANY_ID
                                                AND     A.DIVISION_ID   = X.DIVISION_ID
                                                AND     A.SITE_ID       = X.SITE_ID
                                                AND     A.PLANT_ID      = X.PLANT_ID
                                                AND     A.FACTORY_ID    = X.FACTORY_ID
                                                AND     A.OPERATION_ID  = X.OPERATION_ID
                                                AND     X.MASTER_ID     = @v_master_id
                                                AND     X.PLAN_ID       = @v_plan_id )
                                UNION  ALL
                                -- LINE_ASSIGN EXCEPT_M 넣기
                                SELECT 
                                        A.COMPANY_ID
                                      , A.DIVISION_ID
                                      , A.SITE_ID
                                      , A.PLANT_ID
                                      , A.FACTORY_ID
                                      , A.OPERATION_ID
                                      , A.LINE_ID
                                      , A.ELECTRODE_TYPE
                                      , CASE WHEN R = 1 THEN 
                                                              CASE WHEN DATEADD(MINUTE, @v_daydiff, B.START_TIME) < @plan_start_time   THEN @plan_start_time
                                                                   ELSE DATEADD(MINUTE, @v_daydiff, B.START_TIME)
                                                              END
                                                        ELSE 
                                                              CASE WHEN DATEADD(MINUTE, @v_daydiff + 1440, B.END_TIME)   > @plan_end_time     THEN @plan_end_time
                                                            ELSE DATEADD(MINUTE, @v_daydiff + 1440, B.END_TIME)
                                           END
                                        END  START_DATE
                                FROM   SY_SCM_LINE_M                    A,
                                       SY_SCM_ITEM_LINE_ASSIGN_EXCEPT_M B,
                                       (SELECT 1 R UNION ALL
                                        SELECT 2 R ) C
                                WHERE  A.COMPANY_ID = B.COMPANY_ID             
                                AND    A.DIVISION_ID = B.DIVISION_ID
                                AND    A.SITE_ID = B.SITE_ID
                                AND    A.PLANT_ID = B.PLANT_ID
                                AND    A.FACTORY_ID = B.FACTORY_ID
                                AND    A.LINE_ID = B.LINE_ID
                                AND    A.OPERATION_ID = B.OPERATION_ID
                                AND    A.ACTIVE_FLAG = 'Y'
                                AND    B.START_TIME < B.END_TIME
                                AND    B.END_TIME   > CONVERT(DATE, @plan_start_time)
                                AND    B.START_TIME < CONVERT(DATE, @plan_end_time)
                                AND    EXISTS ( SELECT  1
                                                FROM    TH_MST_INSTANCE_FLOW X
                                                WHERE   A.COMPANY_ID    = X.COMPANY_ID
                                                AND     A.DIVISION_ID   = X.DIVISION_ID
                                                AND     A.SITE_ID       = X.SITE_ID
                                                AND     A.PLANT_ID      = X.PLANT_ID
                                                AND     A.FACTORY_ID    = X.FACTORY_ID
                                                AND     A.OPERATION_ID  = X.OPERATION_ID
                                                AND     X.MASTER_ID     = @v_master_id
                                                AND     X.PLAN_ID       = @v_plan_id )
                                UNION  ALL
                                -- OFF CALENDAR 넣기
                                SELECT DISTINCT
                                        A.COMPANY_ID
                                      , A.DIVISION_ID
                                      , A.SITE_ID
                                      , A.PLANT_ID
                                      , A.FACTORY_ID
                                      , A.OPERATION_ID
                                      , A.LINE_ID
                                      , A.ELECTRODE_TYPE
                                      , CASE WHEN R = 1 THEN 
                                                              CASE WHEN B.OFF_START_TIME < @plan_start_time   THEN @plan_start_time
                                                                                                              ELSE B.OFF_START_TIME
                                                              END
                                                        ELSE 
                                                              CASE WHEN B.OFF_END_TIME   > @plan_end_time     THEN @plan_end_time
                                                                                                              ELSE B.OFF_END_TIME
                                                              END
                                        END  START_DATE
                                FROM   SY_SCM_LINE_M            A,
                                       TH_MST_SCM_OFF_CALENDAR  B,
                                       --SY_SCM_OFF_CALENDAR_M    B,
                                       SY_SCM_EQUIPMENT_M       C,
                                       (SELECT 1 R UNION ALL
                                        SELECT 2 R ) D
                                WHERE  B.MASTER_ID  = @v_master_id
                   AND    B.PLAN_ID    = @v_plan_id
                                AND    A.COMPANY_ID = B.COMPANY_ID             
                                AND    A.DIVISION_ID = B.DIVISION_ID
                                AND    A.SITE_ID = B.SITE_ID
                                AND    A.PLANT_ID = B.PLANT_ID
                                AND    A.FACTORY_ID = B.FACTORY_ID
                                AND    A.LINE_ID = B.LINE_ID
                                AND    A.OPERATION_ID = B.OPERATION_ID
                                AND    A.ACTIVE_FLAG = 'Y'
                                AND    B.OFF_START_TIME < B.OFF_END_TIME
                                --AND    B.OFF_END_TIME > @plan_start_time
                                --AND    B.OFF_START_TIME < @plan_end_time
                                AND    A.COMPANY_ID = C.COMPANY_ID             
                                AND    A.DIVISION_ID = C.DIVISION_ID
                                AND    A.SITE_ID = C.SITE_ID
                                AND    A.PLANT_ID = C.PLANT_ID
                                AND    A.FACTORY_ID = C.FACTORY_ID
                                AND    A.LINE_ID = C.LINE_ID
                                AND    A.OPERATION_ID = C.OPERATION_ID
                                AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE
                                AND    C.EQUIPMENT_TYPE = 'M'
                                AND    C.ACTIVE_FLAG = 'Y'
                                AND    EXISTS ( SELECT  1
                                                FROM    TH_MST_INSTANCE_FLOW X
                                                WHERE   A.COMPANY_ID    = X.COMPANY_ID
                                                AND     A.DIVISION_ID   = X.DIVISION_ID
                                                AND     A.SITE_ID       = X.SITE_ID
                                                AND     A.PLANT_ID      = X.PLANT_ID
                                                AND     A.FACTORY_ID    = X.FACTORY_ID
                                                AND     A.OPERATION_ID  = X.OPERATION_ID
                                                AND     X.MASTER_ID     = @v_master_id
                                                AND     X.PLAN_ID       = @v_plan_id )
                                UNION  ALL
                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE
                                     , CASE WHEN R = 1 THEN 
                                                            CASE WHEN A.START_TIME < @plan_start_time THEN @plan_start_time
                                                                                                      ELSE A.START_TIME
                                                            END
                                                       ELSE 
                                                            CASE WHEN A.END_TIME   > @plan_end_time   THEN @plan_end_time
                                                                                                      ELSE A.END_TIME
                                                            END
                                       END  START_DATE
                                FROM   SY_SCM_ITEM_EQUIPMENT_ASSIGN_EXCEPT_M  A,
                                       SY_SCM_EQUIPMENT_M                     B,
                                       (SELECT 1 R UNION ALL
                                        SELECT 2 R ) D   
                                WHERE  A.COMPANY_ID = B.COMPANY_ID
                                AND    A.DIVISION_ID = B.DIVISION_ID
                                AND    A.SITE_ID = B.SITE_ID
                                AND    A.PLANT_ID = B.PLANT_ID
                                AND    A.FACTORY_ID = B.FACTORY_ID
                                AND    A.OPERATION_ID = B.OPERATION_ID
                                AND    A.EQUIPMENT_ID = B.EQUIPMENT_ID                          
                                AND    A.END_TIME > @plan_start_time
                                AND    A.START_TIME < @plan_end_time
                               ) A
                       ) A
               ) A,
               TH_MST_LINE_EQUIP_MAP B
        WHERE  A.END_DATE IS NOT NULL
        AND    A.COMPANY_ID = B.COMPANY_ID
        AND    A.DIVISION_ID = B.DIVISION_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.PLANT_ID = B.PLANT_ID
        AND    A.FACTORY_ID = B.FACTORY_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        AND    A.LINE_ID = B.LINE_ID
        AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        AND    B.MASTER_ID = @v_master_id
        AND    B.PLAN_ID = @v_plan_id

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END;
      
      SET @v_table_name = 'TH_BUF_SCM_LINE_CALENDAR_B' 
      
      TRUNCATE TABLE TH_BUF_SCM_LINE_CALENDAR_B

      BEGIN

        INSERT INTO TH_BUF_SCM_LINE_CALENDAR_B
             (
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , OPERATION_ID
              , LINE_ID
              , ELECTRODE_TYPE
              , START_DATE
              , END_DATE
              , ITEM_ID
              , EQUIPMENT_ID
              , FP_RESOURCE_ID
              , FP_RESOURCE_COUNT
              , IS_USE
              , CHECKING
              )
        SELECT DISTINCT
               COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID,
               LINE_ID, ELECTRODE_TYPE, START_DATE, END_DATE, ITEM_ID, EQUIPMENT_ID,
               FP_RESOURCE_ID, FP_RESOURCE_COUNT, IS_USE, CHECKING
        FROM   (
                -- 일반 라인 
                SELECT DISTINCT
                       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, 
                       A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.START_DATE, A.END_DATE,
                       '-' AS ITEM_ID, A.EQUIPMENT_ID, B.FP_RESOURCE_ID, B.FP_RESOURCE_COUNT, 
                       'Y' IS_USE, '1.NORMAL' CHECKING
                FROM   TH_BUF_SCM_LINE_CALENDAR_A A,
                       TH_MST_LINE_EQUIP_MAP      B
                WHERE  A.COMPANY_ID     = B.COMPANY_ID
                AND    A.DIVISION_ID    = B.DIVISION_ID
                AND    A.SITE_ID        = B.SITE_ID
                AND    A.PLANT_ID       = B.PLANT_ID
                AND    A.FACTORY_ID     = B.FACTORY_ID
                AND    A.OPERATION_ID   = B.OPERATION_ID
                AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
                AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID
                AND    A.LINE_ID        = B.LINE_ID
                AND    B.TOP_LINE_ID    IS NULL
                AND    B.MASTER_ID      = @v_master_id
                AND    B.PLAN_ID        = @v_plan_id
                UNION  ALL
                -- 종속 라인
                SELECT DISTINCT
                       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, 
                       A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.START_DATE, A.END_DATE,
                       '-' AS ITEM_ID, B.EQUIPMENT_ID, B.FP_RESOURCE_ID, B.FP_RESOURCE_COUNT, 
                       'Y' IS_USE, '2.TOP_LINE' CHECKING
                FROM   TH_BUF_SCM_LINE_CALENDAR_A A,
                       TH_MST_LINE_EQUIP_MAP      B
                WHERE  A.COMPANY_ID     = B.COMPANY_ID
                AND    A.DIVISION_ID    = B.DIVISION_ID
                AND    A.SITE_ID        = B.SITE_ID
                AND    A.PLANT_ID       = B.PLANT_ID
          AND    A.FACTORY_ID     = B.FACTORY_ID
                AND    A.OPERATION_ID   = B.OPERATION_ID
                AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
                AND    B.TOP_LINE_ID    IS NOT NULL
                AND    A.LINE_ID        = B.TOP_LINE_ID
                AND    B.MASTER_ID      = @v_master_id
                AND    B.PLAN_ID        = @v_plan_id
                UNION  ALL
                -- ITEM 예외 라인
                SELECT DISTINCT
                       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, 
                       A.OPERATION_ID, B.LINE_ID, A.ELECTRODE_TYPE, A.START_DATE, A.END_DATE,
                       B.ITEM_ID, A.EQUIPMENT_ID, A.FP_RESOURCE_ID, A.FP_RESOURCE_COUNT,
                       CASE ACTION_TYPE
                            WHEN 'ADD' THEN
                                            CASE WHEN A.END_DATE <= B.START_TIME THEN 'N'
                                                 WHEN A.START_DATE >= B.END_TIME THEN 'N'
                                                 ELSE 'Y'
                                            END
                                       ELSE 
                                            CASE WHEN A.END_DATE <= B.START_TIME THEN 'Y'
                                                 WHEN A.START_DATE >= B.END_TIME THEN 'Y'
                                                 ELSE 'N'
                                            END                               
                       END IS_USE, '3.ASSIGN_EXCEPT' CHECKING
                FROM   TH_BUF_SCM_LINE_CALENDAR_A             A,
                       SY_SCM_ITEM_EQUIPMENT_ASSIGN_EXCEPT_M  B
                WHERE  A.COMPANY_ID   = B.COMPANY_ID
                AND    A.DIVISION_ID  = B.DIVISION_ID
                AND    A.SITE_ID      = B.SITE_ID
                AND    A.PLANT_ID     = B.PLANT_ID
                AND    A.FACTORY_ID   = B.FACTORY_ID
                AND    A.OPERATION_ID = B.OPERATION_ID
                AND    A.EQUIPMENT_ID = B.EQUIPMENT_ID                                
                AND    B.END_TIME > @plan_start_time
                AND    B.START_TIME < @plan_end_time
               ) A
    
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
    
      END
      
      SET @v_table_name = 'TH_BUF_SCM_LINE_CALENDAR_C'
      
      TRUNCATE TABLE TH_BUF_SCM_LINE_CALENDAR_C

      BEGIN
        
        INSERT INTO TH_BUF_SCM_LINE_CALENDAR_C
              (
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , OPERATION_ID
              , LINE_ID
              , ELECTRODE_TYPE
              , START_DATE
              , END_DATE
              , EQUIPMENT_ID
              , FP_RESOURCE_ID
              , FP_RESOURCE_COUNT
              , ITEM_ID
              , CAPA_TYPE
              , ALT_PRIORITY
              , TACT_TIME
              , TACT_TIME_UOM
              , YIELD
              , IS_USE
              , DESCR
              --, DAILY_CAPA_TACT_TIME
              --, DAILY_CAPA_TACT_TIME_UOM
              )
        SELECT 
                A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.OPERATION_ID
              , A.LINE_ID
              , A.ELECTRODE_TYPE
              , A.START_DATE
              , A.END_DATE
              , A.EQUIPMENT_ID
              , A.FP_RESOURCE_ID
              , A.FP_RESOURCE_COUNT             
              , A.ITEM_ID
              , A.CAPA_TYPE
 , CASE WHEN A.ALT_PRIORITY = 0 OR A.ALT_PRIORITY IS NULL THEN 9 ELSE A.ALT_PRIORITY END ALT_PRIORITY
              , ISNULL(A.TACT_TIME, 0) AS TACT_TIME
              , A.TACT_TIME_UOM
              , CASE WHEN A.YIELD = 0 OR A.YIELD IS NULL THEN 1.0 ELSE A.YIELD END YIELD
              , A.IS_USE
              , A.CHECKING                
        FROM   (
                SELECT  DISTINCT 
                          A.COMPANY_ID
                        , A.DIVISION_ID
                        , A.SITE_ID
                        , A.PLANT_ID
                        , A.FACTORY_ID
                        , A.OPERATION_ID
                        , A.LINE_ID
                        , A.ELECTRODE_TYPE
                        , A.START_DATE
                        , A.END_DATE
                        , A.EQUIPMENT_ID
                        , A.FP_RESOURCE_ID
                        , A.FP_RESOURCE_COUNT                                
                        , A.ITEM_ID
                        , A.CAPA_TYPE
                        , CASE WHEN A.EXCEPT_PRIORITY IS NOT NULL THEN A.EXCEPT_PRIORITY ELSE A.NORMAL_PRIORITY END AS  ALT_PRIORITY
                        , CASE WHEN A.EXCEPT_TACT_TIME IS NOT NULL THEN A.EXCEPT_TACT_TIME ELSE A.NORMAL_TACT_TIME END AS TACT_TIME
                        , A.TACT_TIME_UOM
                        , CASE WHEN A.EXCEPT_YIELD IS NOT NULL THEN A.EXCEPT_YIELD ELSE A.YIELD END AS  YIELD
                        , A.IS_USE
                        , CHECKING
                FROM (
                          SELECT 
                                  A.COMPANY_ID
                                , A.DIVISION_ID
                                , A.SITE_ID
                                , A.PLANT_ID
                                , A.FACTORY_ID
                                , A.OPERATION_ID
                                , A.LINE_ID
                                , A.ELECTRODE_TYPE
                                , A.START_DATE
                                , A.END_DATE
                                , A.EQUIPMENT_ID
                                , A.FP_RESOURCE_ID
                                , A.FP_RESOURCE_COUNT                                
                                , C.ITEM_ID
                                , H.CAPA_TYPE
                                , CASE WHEN H.CAPA_TYPE    <> 'TACT'   THEN 0.0000000001
                                       WHEN B.TACT_TIME_UOM = 'SECOND' THEN B.TACT_TIME
                                       WHEN B.TACT_TIME_UOM = 'MINUTE' THEN B.TACT_TIME*60
                                       WHEN B.TACT_TIME_UOM = 'HOUR'   THEN B.TACT_TIME*60*60
                                       ELSE B.TACT_TIME
                                  END AS NORMAL_TACT_TIME
                                , CASE WHEN H.CAPA_TYPE <> 'TACT'      THEN 'SECOND'
                                       ELSE ISNULL(B.TACT_TIME_UOM,'SECOND')
                                  END  AS TACT_TIME_UOM
                                , CASE WHEN C.PRIORITY IS NULL THEN 9 ELSE C.PRIORITY END AS NORMAL_PRIORITY
                                , CASE WHEN D.YIELD IS NULL THEN 1.0 ELSE D.YIELD END YIELD
                                , E.TACT_TIME AS EXCEPT_TACT_TIME
                                , F.PRIORITY AS EXCEPT_PRIORITY
                                , G.YIELD AS EXCEPT_YIELD
                                --, A.IS_USE
                                , ISNULL(F.ACTIVE_FLAG,A.IS_USE) as IS_USE
                                , CHECKING
                          FROM TH_BUF_SCM_LINE_CALENDAR_B AS A
                               INNER JOIN SY_SCM_ITEM_LINE_ASSIGN_M C
                                       ON    A.COMPANY_ID     = C.COMPANY_ID
                                       AND   A.DIVISION_ID    = C.DIVISION_ID
              AND   A.SITE_ID        = C.SITE_ID
                   AND   A.PLANT_ID       = C.PLANT_ID
                                       AND   A.FACTORY_ID     = C.FACTORY_ID
                                       AND   A.LINE_ID        = C.LINE_ID
                                       AND   A.OPERATION_ID   = C.OPERATION_ID
                                       AND   A.ELECTRODE_TYPE = C.ELECTRODE_TYPE
                                       AND   C.ITEM_ID        = (CASE WHEN A.ITEM_ID = '-' THEN C.ITEM_ID ELSE A.ITEM_ID END)
                                       AND   C.ACTIVE_FLAG    = 'Y'
                                       AND   SUBSTRING(CONVERT(nvarchar,CONVERT(CHAR(8),A.START_DATE,112),112),1,6) = C.MONTH
                                       AND   EXISTS (
                                                      SELECT 1
                                                      FROM   TH_MST_INSTANCE_FLOW X
                                                      WHERE  X.MASTER_ID = @v_master_id
                                                      AND    X.PLAN_ID = @v_plan_id
                                                      AND    X.ITEM_ID = C.ITEM_ID    -- ITEM 만 걸자... OPERATION 다른놈들 다 올라오게..
                                                    )
                               INNER JOIN SY_SCM_OPERATION_M H
                                       ON    A.COMPANY_ID = H.COMPANY_ID
                                       AND   A.DIVISION_ID = H.DIVISION_ID
                                       AND   A.SITE_ID = H.SITE_ID
                                       AND   A.OPERATION_ID = H.OPERATION_ID
                               LEFT OUTER JOIN SY_SCM_TACT_TIME_M B
                                       ON A.COMPANY_ID = B.COMPANY_ID
                                       AND   A.DIVISION_ID    = B.DIVISION_ID
                                       AND   A.SITE_ID        = B.SITE_ID
                                       AND   A.PLANT_ID       = B.PLANT_ID
                                       AND   A.FACTORY_ID     = B.FACTORY_ID
                                       AND   A.LINE_ID        = B.LINE_ID
                                       AND   A.OPERATION_ID   = B.OPERATION_ID 
                                       AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
                                       AND   C.ITEM_ID        = B.ITEM_ID
                                       AND   SUBSTRING(CONVERT(nvarchar,CONVERT(CHAR(8),A.START_DATE,112),112),1,6) = B.MONTH
                               LEFT OUTER JOIN SY_SCM_YIELD_M D
                                       ON    A.COMPANY_ID   = D.COMPANY_ID
                                       AND   A.DIVISION_ID  = D.DIVISION_ID
                                       AND   A.SITE_ID      = D.SITE_ID
                                       AND   A.PLANT_ID     = D.PLANT_ID
                                       AND   A.FACTORY_ID   = D.FACTORY_ID
                                       AND   A.LINE_ID      = D.LINE_ID
                                       AND   A.OPERATION_ID = D.OPERATION_ID
                                       AND   C.ITEM_ID      = D.ITEM_ID
                                       AND   SUBSTRING(CONVERT(nvarchar,CONVERT(CHAR(8),A.START_DATE,112),112),1,6) = D.MONTH
                               LEFT OUTER JOIN SY_SCM_TACT_TIME_EXCEPT_M E
                                       ON    A.COMPANY_ID     = E.COMPANY_ID
                                       AND   A.DIVISION_ID    = E.DIVISION_ID
                                       AND   A.SITE_ID        = E.SITE_ID
                                       AND   A.PLANT_ID       = E.PLANT_ID
                                       AND   A.FACTORY_ID     = E.FACTORY_ID
                                       AND   A.LINE_ID        = E.LINE_ID
                                       AND   A.OPERATION_ID   = E.OPERATION_ID
AND   A.ELECTRODE_TYPE = E.ELECTRODE_TYPE
                                AND   C.ITEM_ID        = E.ITEM_ID
                                       AND   A.START_DATE    >= E.START_TIME
                                       AND   A.END_DATE      <= E.END_TIME
                               LEFT OUTER JOIN SY_SCM_ITEM_LINE_ASSIGN_EXCEPT_M F
                                       ON    A.COMPANY_ID     = F.COMPANY_ID
                                       AND   A.DIVISION_ID    = F.DIVISION_ID
                                       AND   A.SITE_ID        = F.SITE_ID
                                       AND   A.PLANT_ID       = F.PLANT_ID
                                       AND   A.FACTORY_ID     = F.FACTORY_ID
                                       AND   A.LINE_ID        = F.LINE_ID
                                       AND   A.OPERATION_ID   = F.OPERATION_ID
                                       AND   A.ELECTRODE_TYPE = F.ELECTRODE_TYPE
                                       AND   C.ITEM_ID        = F.ITEM_ID
                                       AND   A.START_DATE    >= DATEADD(MINUTE, @v_daydiff       , F.START_TIME)
                                       AND   A.END_DATE      <= DATEADD(MINUTE, @v_daydiff + 1440, F.END_TIME)
                               LEFT OUTER JOIN SY_SCM_YIELD_EXCEPT_M G
                                       ON    A.COMPANY_ID   = G.COMPANY_ID
                                       AND   A.DIVISION_ID  = G.DIVISION_ID
                                       AND   A.SITE_ID      = G.SITE_ID
                                       AND   A.PLANT_ID     = G.PLANT_ID
                                       AND   A.FACTORY_ID   = G.FACTORY_ID
                                       AND   A.LINE_ID      = G.LINE_ID
                                       AND   A.OPERATION_ID = G.OPERATION_ID
                                       AND   C.ITEM_ID      = G.ITEM_ID
                                       AND   A.START_DATE  >= G.START_TIME
                                       AND   A.END_DATE    <= G.END_TIME                               
                      )A
                WHERE A.START_DATE <= @plan_end_time
               ) A
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
    
        SET @v_table_name = 'TH_MST_OP_RESOURCE_EQUIP_CAL'

        DELETE FROM TH_MST_OP_RESOURCE_EQUIP_CAL
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id
        
        INSERT INTO TH_MST_OP_RESOURCE_EQUIP_CAL
                ( MASTER_ID
                 ,PLAN_ID
                 ,ITEM_ID
                 ,SITE_ID
                 ,ROUTE_ID
                 ,OPERATION_ID
                 ,RESOURCE_ID
                 ,ALT_PRIORITY
                 ,TACT_TIME
                 ,TACT_TIME_UOM
                 ,YIELD
                 ,IS_USE
                 ,START_DATE
                 ,END_DATE
                 ,ELECTRODE_TYPE
                 ,KEY_DATE
                 ,INSERT_ID
                 ,INSERT_DTTM
                 ,UPDATE_ID
                 ,UPDATE_DTTM
                 )
        SELECT  DISTINCT 
                @V_MASTER_ID
               ,@V_PLAN_ID
                ,A.ITEM_ID
                ,A.FACTORY_ID AS SITE_ID
                ,A.LINE_ID AS ROUTE_ID
                ,A.OPERATION_ID
                ,A.FP_RESOURCE_ID AS RESOURCE_ID
                ,A.ALT_PRIORITY
                ,A.TACT_TIME
                ,A.TACT_TIME_UOM
                ,A.YIELD
                ,A.IS_USE
                --,'Y' AS IS_USE
                ,A.START_DATE AS START_DATE
                ,A.END_DATE   AS END_DATE
                ,A.ELECTRODE_TYPE
                ,@key_date AS KEY_DATE
                ,@V_PROC_NAME AS INSERT_ID
                ,GETDATE() AS INSERT_DTTM
                ,@V_PROC_NAME AS UPDATE_ID
                ,GETDATE() AS UPDATE_DTTM
        FROM     TH_BUF_SCM_LINE_CALENDAR_C A

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END;


      IF @res_category = 'LINE'
        BEGIN

          SET @v_table_name = 'TH_MST_OP_RESOURCE_LINE_CAL'

          DELETE FROM TH_MST_OP_RESOURCE_LINE_CAL
          WHERE   MASTER_ID   = @v_master_id
          AND     PLAN_ID     = @v_plan_id
          
          INSERT INTO TH_MST_OP_RESOURCE_LINE_CAL
                ( 
                  MASTER_ID
                , PLAN_ID
                , ITEM_ID
                , SITE_ID
                , ROUTE_ID
                , OPERATION_ID
                , RESOURCE_ID
                , ALT_PRIORITY
                , TACT_TIME
                , TACT_TIME_UOM
                , YIELD
                , IS_USE
                , START_DATE
                , END_DATE
                , ELECTRODE_TYPE
                , TOTAL_RESOURCE_COUNT
                , ACTIVE_RESOURCE_COUNT
                , DESCR
                , KEY_DATE
                , INSERT_ID
                , INSERT_DTTM
                , UPDATE_ID
                , UPDATE_DTTM
                )
          SELECT  DISTINCT 
                  @V_MASTER_ID
                , @V_PLAN_ID
                , A.ITEM_ID
                , A.FACTORY_ID AS SITE_ID
                , A.LINE_ID AS ROUTE_ID
                , A.OPERATION_ID
                , A.RESOURCE_ID
                , CASE WHEN RESOURCE_COUNT = OFF_CHK THEN 1                ELSE A.ALT_PRIORITY END AS ALT_PRIORITY
                -- 가용한 설비가 없을 경우 기본 TACT 을 넣고,
                -- PR_SCM_IF_CALENDAR 에서 OFF 처리 한다.
                , CASE WHEN CAPA_TYPE <> 'TACT' THEN ORG_TACT_TIME
                       WHEN RESOURCE_COUNT = OFF_CHK THEN A.ORG_TACT_TIME / ( CASE WHEN RESOURCE_COUNT = 0 THEN 1 ELSE RESOURCE_COUNT END )     -- 2017.03.22 : TRANSFER BATCH 시간 왜곡으로 설비댓수를 나눈 TACT 을 사용한다.
                       ELSE A.TACT_TIME    
                  END  AS TACT_TIME
                , A.TACT_TIME_UOM
                --, CASE WHEN RESOURCE_COUNT = OFF_CHK THEN 1                ELSE A.YIELD        END AS YIELD
                , A.YIELD
                , 'Y' AS IS_USE
                , A.START_DATE AS START_DATE
                , A.END_DATE   AS END_DATE
                , A.ELECTRODE_TYPE
                , RESOURCE_COUNT AS TOTAL_RESOURCE_COUNT
                , (RESOURCE_COUNT - OFF_CHK) AS ACTIVE_RESOURCE_COUNT
                , CASE WHEN RESOURCE_COUNT = OFF_CHK THEN 'LINE_OFF' ELSE NULL END AS DESCR
                , @key_date AS KEY_DATE
                , @V_PROC_NAME AS INSERT_ID
                , GETDATE() AS INSERT_DTTM
                , @V_PROC_NAME AS UPDATE_ID
                , GETDATE() AS UPDATE_DTTM
          FROM  (
                  SELECT
                           COMPANY_ID
                          ,DIVISION_ID
                          ,SITE_ID
                          ,PLANT_ID
                          ,FACTORY_ID
                          ,OPERATION_ID
                          ,LINE_ID
                          ,ELECTRODE_TYPE
                          ,ITEM_ID
                          ,RESOURCE_ID
                          ,CAPA_TYPE
                          ,MIN(ALT_PRIORITY) AS ALT_PRIORITY
                          ,CASE WHEN SUM(TACT_TIME) = 0 THEN 0.0
                                ELSE ( 1 / (SUM(TACT_TIME) / RESOURCE_COUNT) / RESOURCE_COUNT ) -- 조화평균 구하기
                           END  AS TACT_TIME
                          ,ORG_TACT_TIME
                          ,TACT_TIME_UOM
                          ,MAX(YIELD) AS YIELD
                          ,START_DATE
                          ,END_DATE
                          ,SUM(OFF_CHK) AS OFF_CHK
                          ,RESOURCE_COUNT AS RESOURCE_COUNT
                  FROM   (
                          SELECT   A.COMPANY_ID
                                  ,A.DIVISION_ID
                                  ,A.SITE_ID
                                  ,A.PLANT_ID
                                  ,A.FACTORY_ID
                                  ,A.OPERATION_ID
                                  ,A.LINE_ID
                                  ,A.ELECTRODE_TYPE
                                  ,A.ITEM_ID
                                  ,A.FP_RESOURCE_ID AS RESOURCE_ID
                                  ,A.CAPA_TYPE
                                  ,CASE WHEN B.EQUIPMENT_ID IS NOT NULL THEN 999999 ELSE ISNULL(A.ALT_PRIORITY, 1) END AS ALT_PRIORITY
                                  ,CASE WHEN B.EQUIPMENT_ID IS NOT NULL THEN 0.0
                                        WHEN A.TACT_TIME    = 0         THEN 0.0
                                        ELSE (1.0 / A.TACT_TIME)       
                                   END  AS TACT_TIME
                                  ,A.TACT_TIME AS ORG_TACT_TIME
                                  ,A.TACT_TIME_UOM
                                  --,CASE WHEN B.EQUIPMENT_ID IS NOT NULL THEN 0.001  ELSE ISNULL(A.YIELD, 1)        END AS YIELD
                                  ,ISNULL(A.YIELD, 1) AS YIELD
                                  ,A.START_DATE
                                  ,A.END_DATE
                                  ,CASE WHEN B.EQUIPMENT_ID IS NOT NULL THEN 1.0 ELSE 0.0 END OFF_CHK
                                  ,COUNT(1.0) OVER (PARTITION BY  
                                                               A.COMPANY_ID
                                                              ,A.DIVISION_ID
                                                              ,A.SITE_ID
                                                              ,A.PLANT_ID
                                                              ,A.FACTORY_ID
                                                              ,A.OPERATION_ID
                                                              ,A.LINE_ID
                                                              ,A.ELECTRODE_TYPE
                                                              ,A.ITEM_ID
                                                              ,A.FP_RESOURCE_ID
                                                              ,A.START_DATE
                                                              ) * 1.0 AS RESOURCE_COUNT
                          FROM    TH_BUF_SCM_LINE_CALENDAR_C A
                                  LEFT  OUTER JOIN TH_MST_SCM_OFF_CALENDAR B
                                                    --SY_SCM_OFF_CALENDAR_M B
                                        ON     1=1
                                        AND    B.MASTER_ID = @v_master_id
                                        AND    B.PLAN_ID = @v_plan_id
                                        AND    A.COMPANY_ID = B.COMPANY_ID             
                                        AND    A.DIVISION_ID = B.DIVISION_ID
                                        AND    A.SITE_ID = B.SITE_ID
                                        AND    A.PLANT_ID = B.PLANT_ID
                                        AND    A.FACTORY_ID = B.FACTORY_ID
                                        AND    A.LINE_ID = B.LINE_ID
                                        AND    A.OPERATION_ID = B.OPERATION_ID
                                        AND    A.EQUIPMENT_ID = B.EQUIPMENT_ID
                       AND    A.START_DATE >= B.OFF_START_TIME
                                        AND    A.END_DATE <= B.OFF_END_TIME
                         ) A
                  GROUP  BY 
                           COMPANY_ID
                          ,DIVISION_ID
                          ,SITE_ID
                          ,PLANT_ID
                          ,FACTORY_ID
                          ,OPERATION_ID
                          ,LINE_ID
                          ,ELECTRODE_TYPE
                          ,ITEM_ID
                          ,RESOURCE_ID
                          ,CAPA_TYPE
                          ,ORG_TACT_TIME
                          ,TACT_TIME_UOM
                          ,START_DATE
                          ,END_DATE
                          ,RESOURCE_COUNT
                 ) A

          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        END


      BEGIN
        SET @v_table_name = 'TH_MST_OP_RESOURCE_CAL'

        DELETE FROM TH_MST_OP_RESOURCE_CAL
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id

        IF @res_category = 'LINE'
          BEGIN

            INSERT INTO TH_MST_OP_RESOURCE_CAL
                    ( 
                      MASTER_ID
                     ,PLAN_ID
                     ,ITEM_ID
                     ,SITE_ID
                     ,ROUTE_ID
                     ,OPERATION_ID
                     ,RESOURCE_ID
                     ,ALT_PRIORITY
                     ,TACT_TIME
                     ,TACT_TIME_UOM
                     ,YIELD
                     ,IS_USE
                     ,START_DATE
                     ,END_DATE
                     ,DESCR
                     ,KEY_DATE
                     ,INSERT_ID
                     ,INSERT_DTTM
                     ,UPDATE_ID
                     ,UPDATE_DTTM
                     )
            SELECT  
                      MASTER_ID
                     ,PLAN_ID
                     ,ITEM_ID
                     ,SITE_ID
                     ,ROUTE_ID
                     ,OPERATION_ID
                     ,RESOURCE_ID
                     ,ALT_PRIORITY
                     ,TACT_TIME
                     ,TACT_TIME_UOM
                     ,YIELD
                     ,CASE WHEN ALT_PRIORITY IN (1,2,3,4,5,6,7,8) THEN IS_USE ELSE 'N' END AS IS_USE
                     --,IS_USE
                     ,START_DATE
                     ,END_DATE
                     ,DESCR
                     ,KEY_DATE
                     ,INSERT_ID
                     ,INSERT_DTTM
                     ,UPDATE_ID
                     ,UPDATE_DTTM
            FROM     TH_MST_OP_RESOURCE_LINE_CAL A
            WHERE   MASTER_ID   = @v_master_id
            AND     PLAN_ID     = @v_plan_id

          END
        ELSE
          BEGIN

            INSERT INTO TH_MST_OP_RESOURCE_CAL
                    ( 
                      MASTER_ID
                     ,PLAN_ID
                     ,ITEM_ID
                     ,SITE_ID
                     ,ROUTE_ID
                     ,OPERATION_ID
                     ,RESOURCE_ID
                     ,ALT_PRIORITY
                     ,TACT_TIME
                     ,TACT_TIME_UOM
                     ,YIELD
                     ,IS_USE
                     ,START_DATE
                     ,END_DATE
                     ,KEY_DATE
                     ,INSERT_ID
                     ,INSERT_DTTM
                     ,UPDATE_ID
                     ,UPDATE_DTTM
                     )
            SELECT  
                      MASTER_ID
             ,PLAN_ID
 ,ITEM_ID
                     ,SITE_ID
                     ,ROUTE_ID
                     ,OPERATION_ID
                     ,RESOURCE_ID
                     ,ALT_PRIORITY
                     ,TACT_TIME
                     ,TACT_TIME_UOM
                     ,YIELD
                     ,CASE WHEN ALT_PRIORITY IN (1,2,3,4,5,6,7,8) THEN IS_USE ELSE 'N' END AS IS_USE
                     --,IS_USE
                     ,START_DATE
                     ,END_DATE
                     ,KEY_DATE
                     ,INSERT_ID
                     ,INSERT_DTTM
                     ,UPDATE_ID
                     ,UPDATE_DTTM
            FROM     TH_MST_OP_RESOURCE_EQUIP_CAL A
            WHERE   MASTER_ID   = @v_master_id
            AND     PLAN_ID     = @v_plan_id

          END
          
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
      
        SET @v_table_name = 'TH_MST_OP_RESOURCE'

        DELETE FROM TH_MST_OP_RESOURCE
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id

        INSERT INTO TH_MST_OP_RESOURCE
                 (MASTER_ID
                 ,PLAN_ID
                 ,ITEM_ID
                 ,SITE_ID
                 ,ROUTE_ID
                 ,OPERATION_ID
                 ,RESOURCE_ID
                 ,ALT_PRIORITY
                 ,TACT_TIME
                 ,TACT_TIME_UOM
                 ,YIELD
                 ,IS_VALID
                 ,KEY_DATE
                 ,INSERT_ID
                 ,INSERT_DTTM
                 ,UPDATE_ID
                 ,UPDATE_DTTM)
        SELECT   
                MASTER_ID
              , PLAN_ID
              , ITEM_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , RESOURCE_ID
              , MIN(ALT_PRIORITY)
              , MAX(TACT_TIME)
              , MAX(TACT_TIME_UOM)
              , MAX(YIELD)
              , 'Y' AS ACTIVE_FLAG
              , @key_date AS KEY_DATE
              , @v_proc_name +'_TACT' as INSERT_ID
              , GETDATE() as INSERT_DTTM
              , @v_proc_name as UPDATE_ID
              , getdate() as UPDATE_DTTM
        FROM    TH_MST_OP_RESOURCE_CAL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        GROUP  BY 
                MASTER_ID
              , PLAN_ID
              , ITEM_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , RESOURCE_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

      -- OP RESOURCE 와 OP RESOURCE CAL 이 같은 데이터는 삭제한다. 데이터가 너무 많아서
      BEGIN
      
        SET @v_table_name = 'TH_MST_OP_RESOURCE_CAL'

        DELETE FROM A
        FROM   TH_MST_OP_RESOURCE_CAL A,
               TH_MST_OP_RESOURCE B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID
        AND    A.RESOURCE_ID    = B.RESOURCE_ID
        AND    A.ALT_PRIORITY   = B.ALT_PRIORITY
        AND    A.TACT_TIME      = B.TACT_TIME
        AND    A.TACT_TIME_UOM  = B.TACT_TIME_UOM
        AND    A.YIELD          = B.YIELD
        AND    A.IS_USE         = 'Y'      
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_MST_RESOURCE'
        
        DELETE FROM TH_MST_RESOURCE
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id
        
        INSERT INTO TH_MST_RESOURCE
                (MASTER_ID
                ,PLAN_ID
                ,RESOURCE_ID
                ,RESOURCE_NAME
                ,RESOURCE_TYPE
                ,SITE_ID
                ,RESOURCE_GROUP_ID
                ,UTILIZATION
                ,RESOURCE_SETUP_GROUP_ID
                ,RES_ATTB_11
                ,RES_ATTB_12
                ,RES_ATTB_13
                ,RES_ATTB_14
                ,RES_ATTB_15
                ,RES_ATTB_17
                ,RES_ATTB_18
                ,RES_ATTB_19
                ,RES_ATTB_20
                ,KEY_DATE
                ,INSERT_ID
                ,INSERT_DTTM
                ,UPDATE_ID
                ,UPDATE_DTTM
                ,FIXED_TERM
                )
        SELECT  
                MASTER_ID
              , PLAN_ID
              , RESOURCE_ID
              , RESOURCE_NAME
              , RESOURCE_TYPE
              , SITE_ID
              , RESOURCE_GROUP_ID
              , UTILIZATION
              , RESOURCE_SETUP_GROUP_ID
              , RES_ATTB_11
              , RES_ATTB_12
              , RES_ATTB_13
              , RES_ATTB_14
              , RES_ATTB_15
              , RES_ATTB_17
              , RES_ATTB_18
              , RES_ATTB_19
              , RES_ATTB_20
              , @key_date AS KEY_DATE
              , @v_proc_name as INSERT_ID
              , GETDATE() as INSERT_DTTM
              , @v_proc_name as UPDATE_ID
              , getdate() as UPDATE_DTTM
              , 5
        FROM   (                
                SELECT  DISTINCT
                          @v_master_id   AS MASTER_ID
                        , @v_plan_id     AS PLAN_ID
                        , FP_RESOURCE_ID AS RESOURCE_ID
                        , FP_RESOURCE_ID AS RESOURCE_NAME
                        , 'MAIN'         AS RESOURCE_TYPE
                        , FACTORY_ID     AS SITE_ID
                        , FP_RESOURCE_ID AS RESOURCE_GROUP_ID
                        , CASE WHEN UTILIZATION IS NULL OR UTILIZATION = 0 THEN 1
                            ELSE UTILIZATION
                          END  UTILIZATION
                        , LINE_SETUP_GROUP_ID AS RESOURCE_SETUP_GROUP_ID
                        , COMPANY_ID     AS RES_ATTB_11
                        , DIVISION_ID    AS RES_ATTB_12
                        , SITE_ID        AS RES_ATTB_13
                        , PLANT_ID       AS RES_ATTB_14
                        , FACTORY_ID     AS RES_ATTB_15
                        , LINE_ID        AS RES_ATTB_17
                        , OPERATION_ID   AS RES_ATTB_18
                        , WORK_CENTER_ID AS RES_ATTB_19
                        , ELECTRODE_TYPE AS RES_ATTB_20
                        , DENSE_RANK() OVER ( PARTITION BY FP_RESOURCE_ID 
                                              ORDER     BY (CASE WHEN CHARINDEX('CN', MASTER_ID) > 0 THEN FACTORY_ID
                                                                 ELSE 'ZZZZ'
                                                            END  ), -- 남경 SITE 로 인해 1번째 구분
                                                           COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID,
                                                           LINE_ID, OPERATION_ID, ELECTRODE_TYPE) SEQ
        FROM   TH_MST_LINE_EQUIP_MAP A
                  WHERE  MASTER_ID = @v_master_id
                  AND    PLAN_ID = @v_plan_id
                  AND    EXISTS (
                                  SELECT 1
                                  FROM   TH_MST_OP_RESOURCE X
                                  WHERE  X.MASTER_ID = A.MASTER_ID
                                  AND    X.PLAN_ID = A.PLAN_ID
                                  AND    X.RESOURCE_ID = A.FP_RESOURCE_ID
                                )
               ) A
        WHERE  SEQ = 1
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END

      BEGIN

        SET @v_table_name = 'TH_MST_RESOURCE_CAL'
        
        DELETE FROM TH_MST_RESOURCE_CAL
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @p_plan_id

        IF @res_category = 'LINE'
          BEGIN

            INSERT INTO TH_MST_RESOURCE_CAL
                    (MASTER_ID
                    ,PLAN_ID
                    ,RESOURCE_ID
                    ,UTILIZATION
                    ,START_DATE
                    ,END_DATE
                    ,KEY_DATE
                    ,INSERT_ID
                    ,INSERT_DTTM
                    ,UPDATE_ID
                    ,UPDATE_DTTM )
            SELECT   DISTINCT
                     @v_master_id
                    ,@v_plan_id
                    ,A.RESOURCE_ID        AS RESOURCE_ID
                    ,A.UTILIZATION        AS UTILIZATION
                    ,A.START_TIME         AS START_DATE
                    ,A.END_TIME           AS END_DATE
                    ,@key_date AS KEY_DATE
                    ,@v_proc_name as INSERT_ID
                    ,GETDATE() as INSERT_DTTM
                    ,@v_proc_name as UPDATE_ID
                    ,getdate() as UPDATE_DTTM
            FROM   (SELECT A.MASTER_ID, A.PLAN_ID, A.RESOURCE_ID, B.MONTH, B.UTILIZATION,
                           DATEADD(MI, @v_daydiff, CONVERT(DATETIME, B.MONTH+'01')) START_TIME,
                           DATEADD(MI, @v_daydiff, DATEADD(MM, 1, CONVERT(DATETIME, B.MONTH+'01'))) END_TIME
                    FROM TH_MST_RESOURCE A,
                    	 (SELECT INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, MONTH, 
                    				       LINE_ID +'_'+ OPERATION_ID + ( CASE WHEN ELECTRODE_TYPE = '-' THEN '' ELSE '_'+ ELECTRODE_TYPE END ) AS FP_RESOURCE_ID,
                    		       SUM(TOTAL_EQUIP_MONTH_TIME) AS TOTAL_EQUIP_MONTH_TIME, SUM(TOTAL_OFF_TIME) AS TOTAL_OFF_TIME,
                    		       SUM(TOTAL_WORK_TIME) AS TOTAL_WORK_TIME, SUM(LOSS_TIME) AS LOSS_TIME,
                    		       AVG(NET_LOSS_RATE) AS NET_LOSS_RATE, AVG(UTILIZATION) AS UTILIZATION
                    		FROM TH_BUF_SCM_UTILIZATION
                    		WHERE 1=1
                    		--AND MONTH > SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),1,4) + SUBSTRING(CONVERT(nvarchar,@plan_start_time, 120),6,2)
                    		GROUP BY INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, MONTH) B
                    WHERE 1=1
                    AND A.MASTER_ID = @v_master_id
                    AND A.PLAN_ID = @v_plan_id
                    AND A.MASTER_ID = B.INSTANCE_ID
                    AND A.PLAN_ID = B.FP_PLAN_ID
                    AND A.RESOURCE_ID = B.FP_RESOURCE_ID
                    AND A.UTILIZATION != B.UTILIZATION) A

          END
        ELSE
          BEGIN

            INSERT INTO TH_MST_RESOURCE_CAL
                    (MASTER_ID
                    ,PLAN_ID
                    ,RESOURCE_ID
                    ,UTILIZATION
                    ,START_DATE
                    ,END_DATE
                    ,KEY_DATE
                    ,INSERT_ID
                    ,INSERT_DTTM
                    ,UPDATE_ID
                    ,UPDATE_DTTM )
            SELECT   DISTINCT
                     @v_master_id
                    ,@v_plan_id
                    ,A.RESOURCE_ID     AS RESOURCE_ID
                    ,A.UTILIZATION          AS UTILIZATION
                    ,A.START_TIME         AS START_DATE
                    ,A.END_TIME           AS END_DATE
                    ,@key_date AS KEY_DATE
                    ,@v_proc_name as INSERT_ID
                    ,GETDATE() as INSERT_DTTM
                    ,@v_proc_name as UPDATE_ID
                    ,getdate() as UPDATE_DTTM                    
            FROM    (SELECT A.MASTER_ID, A.PLAN_ID, A.RESOURCE_ID, B.MONTH, B.UTILIZATION,
                             DATEADD(MI, @v_daydiff, CONVERT(DATETIME, B.MONTH+'01')) START_TIME,
                             DATEADD(MI, @v_daydiff, DATEADD(MM, 1, CONVERT(DATETIME, B.MONTH+'01'))) END_TIME
                      FROM TH_MST_RESOURCE A,
                           TH_BUF_SCM_UTILIZATION B
                      WHERE 1=1
                      AND A.MASTER_ID = @v_master_id
                      AND A.PLAN_ID = @v_plan_id
                      AND A.MASTER_ID = B.INSTANCE_ID
                      AND A.PLAN_ID = B.FP_PLAN_ID
                      AND A.RESOURCE_ID = B.EQUIPMENT_ID
                      AND A.UTILIZATION != B.UTILIZATION ) A

          END
        /*
        INSERT INTO TH_MST_RESOURCE_CAL
                (MASTER_ID
                ,PLAN_ID
                ,RESOURCE_ID
                ,UTILIZATION
                ,START_DATE
                ,END_DATE
                ,KEY_DATE
                ,INSERT_ID
                ,INSERT_DTTM
                ,UPDATE_ID
                ,UPDATE_DTTM )
        SELECT   DISTINCT
                 @v_master_id
                ,@v_plan_id
                ,A.FP_RESOURCE_ID     AS RESOURCE_ID
                ,B.LOSS_RATE          AS UTILIZATION
                ,B.START_TIME         AS START_DATE
                ,B.END_TIME           AS END_DATE
                ,@key_date AS KEY_DATE
                ,@v_proc_name as INSERT_ID
                ,GETDATE() as INSERT_DTTM
                ,@v_proc_name as UPDATE_ID
                ,getdate() as UPDATE_DTTM                
        FROM    TH_MST_LINE_EQUIP_MAP A
               ,(
                  SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, 
                          DATEADD(MI, @v_daydiff, CONVERT(DATETIME, MONTH+'01')) START_TIME,
                          DATEADD(MI, @v_daydiff, DATEADD(MM, 1, CONVERT(DATETIME, MONTH+'01'))) END_TIME,
                          CASE WHEN LOSS_RATE < 0 THEN 0 ELSE LOSS_RATE END AS LOSS_RATE
                  FROM    (
                            SELECT  A.*,
                                    MIN(LOSS_RATE) OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID) AS MIN_LOSS_RATE,
                                    MAX(LOSS_RATE) OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID) AS MAX_LOSS_RATE
                            FROM    (
                                      SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.MONTH,
                                              (100  - A.NON_OP_BM_RATE 
                                                    - A.NON_OP_CM_RATE 
                                                    - A.NON_OP_PD_RATE 
                                                    - A.NON_OP_UTIL_RATE 
      - A.NON_OP_SPEED_RATE ) / 100.0 AS LOSS_RATE
                                      FROM    SY_SCM_LOSS_M A
                                      WHERE   EXISTS (
                                                      SELECT 1
                                                      FROM   TH_MST_INSTANCE_FLOW B
                                                      WHERE   A.COMPANY_ID    = B.COMPANY_ID
                                                      AND     A.DIVISION_ID   = B.DIVISION_ID
                                                      AND     A.SITE_ID       = B.SITE_ID
                                                      AND     A.PLANT_ID      = B.PLANT_ID
                                                      AND     A.FACTORY_ID    = B.FACTORY_ID
                                                      AND     A.OPERATION_ID  = B.OPERATION_ID
                                                      AND     B.MASTER_ID     = @v_master_id
                                                      AND     B.PLAN_ID       = @p_plan_id
                                                     )
                                      AND    MONTH BETWEEN CONVERT(nvarchar(6), @plan_start_time, 112)
                                                      AND  CONVERT(nvarchar(6), @plan_end_time, 112)
                                    ) A
                          ) A
                  WHERE  MIN_LOSS_RATE <> MAX_LOSS_RATE
                ) B
        WHERE   A.COMPANY_ID = B.COMPANY_ID
        AND     A.DIVISION_ID = B.DIVISION_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.PLANT_ID = B.PLANT_ID
        AND     A.FACTORY_ID = B.FACTORY_ID
        AND     A.OPERATION_ID = B.OPERATION_ID
        AND     A.LINE_ID = B.LINE_ID
        AND     A.UTILIZATION <> B.LOSS_RATE
        AND     A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     EXISTS (
                        SELECT 1
                        FROM   TH_MST_OP_RESOURCE X
                        WHERE  X.MASTER_ID = A.MASTER_ID
                        AND    X.PLAN_ID = A.PLAN_ID
                        AND    X.RESOURCE_ID = A.FP_RESOURCE_ID
                       )
        */

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        IF @@TRANCOUNT > 0
          COMMIT WORK 
          
      END
            
      
      ---------------------------------------------------------------------------------------------------
      -- LANE 관련 정보 추가  -- 설비일때만 작동되도록,,
      ---------------------------------------------------------------------------------------------------
      IF @res_category = 'EQUIPMENT'
      BEGIN

        SET @v_table_name = 'TH_MST_OP_RESOURCE - LANE'
      
        UPDATE TH_MST_OP_RESOURCE
        SET    TH_MST_OP_RESOURCE.TACT_TIME = A.LANE_TACT_TIME
        FROM   TH_MST_ITEM_LANE A,
               TH_MST_RESOURCE B,
               TH_MST_OP_RESOURCE C
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.COMPANY_ID     = B.RES_ATTB_11
        AND    A.DIVISION_ID    = B.RES_ATTB_12
        AND    A.SITE_ID        = B.RES_ATTB_13
        AND    A.PLANT_ID       = B.RES_ATTB_14
        AND    A.FACTORY_ID     = B.RES_ATTB_15
        AND    A.LINE_ID        = B.RES_ATTB_17
        AND    A.OPERATION_ID   = B.RES_ATTB_18
        AND    A.ELECTRODE_TYPE = B.RES_ATTB_20
        AND    A.MASTER_ID      = C.MASTER_ID
        AND    A.PLAN_ID        = C.PLAN_ID
        AND    A.ITEM_ID        = C.ITEM_ID
        AND    A.FACTORY_ID     = C.SITE_ID
        AND    A.LINE_ID        = C.ROUTE_ID
        AND    A.OPERATION_ID   = C.OPERATION_ID
        AND    B.RESOURCE_ID    = C.RESOURCE_ID        

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      

        SET @v_table_name = 'TH_MST_OP_RESOURCE_CAL - LANE'
      
        UPDATE TH_MST_OP_RESOURCE_CAL
        SET    TH_MST_OP_RESOURCE_CAL.TACT_TIME = A.LANE_TACT_TIME
        FROM   TH_MST_ITEM_LANE_CAL A,
               TH_MST_RESOURCE B,
               TH_MST_OP_RESOURCE_CAL C
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.COMPANY_ID     = B.RES_ATTB_11
        AND    A.DIVISION_ID    = B.RES_ATTB_12
        AND    A.SITE_ID        = B.RES_ATTB_13
        AND    A.PLANT_ID       = B.RES_ATTB_14
        AND    A.FACTORY_ID     = B.RES_ATTB_15
        AND    A.LINE_ID        = B.RES_ATTB_17
        AND    A.OPERATION_ID   = B.RES_ATTB_18
        AND    A.ELECTRODE_TYPE = B.RES_ATTB_20
        AND    A.MASTER_ID      = C.MASTER_ID
        AND    A.PLAN_ID        = C.PLAN_ID
        AND    A.ITEM_ID        = C.ITEM_ID
        AND    A.FACTORY_ID     = C.SITE_ID
        AND    A.LINE_ID        = C.ROUTE_ID
        AND    A.OPERATION_ID   = C.OPERATION_ID
        AND    B.RESOURCE_ID    = C.RESOURCE_ID
        AND    A.START_TIME    <= C.START_DATE
        AND    A.END_TIME      >= C.END_DATE
              
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END
/*
      -- 긴급 조치
      BEGIN
      
        SET @v_table_name = 'TH_MST_OP_RESOURCE_CAL'

        DELETE FROM A
        FROM   TH_MST_OP_RESOURCE_CAL A,
               TH_MST_OP_RESOURCE B
        WHERE  A.MASTER_ID    = @v_master_id
        AND    A.PLAN_ID      = @v_plan_id
        AND    A.MASTER_ID    = B.MASTER_ID
        AND    A.PLAN_ID      = B.PLAN_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    A.SITE_ID      = B.SITE_ID
        AND    A.ROUTE_ID     = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        AND    A.RESOURCE_ID  = B.RESOURCE_ID
        AND    B.ALT_PRIORITY = 9
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        SET @v_table_name = 'TH_MST_OP_RESOURCE'

        DELETE FROM A
        FROM   TH_MST_OP_RESOURCE A
        WHERE  A.MASTER_ID    = @v_master_id
        AND    A.PLAN_ID      = @v_plan_id
        AND    A.ALT_PRIORITY = 9
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      
      END
*/

      ---------------------------------------------------------------------------
      -- LANE TACT 반영 후 실제 TACT 이 0 일 경우에는 IS_USE 를 N 으로 변경한다.
      ---------------------------------------------------------------------------
 BEGIN
      
        SET @v_table_name = 'TH_MST_OP_RESOURCE_CAL (TACT = 0): IS_USE = N'
      
        UPDATE TH_MST_OP_RESOURCE_CAL
        SET    IS_USE       = 'N'
        WHERE  MASTER_ID  = @v_master_id
        AND    PLAN_ID    = @v_plan_id
        AND    TACT_TIME <= 0
      
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END

      IF @@TRANCOUNT > 0
        COMMIT WORK 

    END
    
    
    /*
      TH_MST_SUB_OP_RESOURCE
    */
    
    /*
      TH_MST_SUB_OP_RESOURCE_CAL
    */
    
    /*
      TH_MST_PRODUCT_MIX
    */
    
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
