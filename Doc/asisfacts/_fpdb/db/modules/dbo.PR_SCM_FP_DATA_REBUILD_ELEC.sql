CREATE PROCEDURE [dbo].[PR_SCM_FP_DATA_REBUILD_ELEC]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_FP_DATA_REBUILD_ELEC                                             **/
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
/** 2023.03.24    CYS          환산자 정보 잘 못 적용된 데이타 맞추기 위해 생성  	**/	
/***********************************************************************************************/
/*
  EXEC PR_SCM_FP_DATA_REBUILD_ELEC
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_FP_DATA_REBUILD_ELEC'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)

  DECLARE @v_start_date         date
        , @n_amend_past_period  Integer        
        
  DECLARE @sysdate          DATETIME2 = GETDATE()

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  DECLARE @v_cal_type       nvarchar(10)
  -------------------------------------------------------------------------------------------

  SET @v_master_id      = @p_instance_id
  SET @v_plan_id        = @p_plan_id
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY

    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN
    
      SELECT  @v_start_date   = CONVERT(DATE, PLAN_START_TIME)
      FROM    SCM_FP_PLAN_H WITH(NOLOCK)
      WHERE   INSTANCE_ID = @v_master_id 
      AND     PLAN_ID     = @v_plan_id

    
      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'

      select @n_amend_past_period = isnull(max(day_period), 30)
      from   (
              -- 일자 기준이면 일자만
              select convert(Integer, SEGMENT2) as day_period
              from   scm_sys_lookup_value WITH(NOLOCK)
              where  lookup_type_code = 'AMEND_PAST_PERIOD'
              and    segment1         = @v_master_id
              and    segment2   = 'DAY'
              union  all
              -- 주차 기준이면 주차 기준의 월요일
              select datediff(day, a.date_id, @v_start_date) as day_period
              from   (
                      select a.date_id
                           , dense_rank() over (order by a.date_id desc) as seq
                      from   scm_sys_calendar_m a WITH(NOLOCK)
                           , scm_sys_calendar_m b WITH(NOLOCK)
                      where  b.date_id  = @v_start_date
                      and    b.week     > a.week
                      and    a.day      = 'MON'
                      and    a.date_id  > dateadd(day, -365, @v_start_date)
                     ) a
                   , (               
                      select convert(Integer, SEGMENT2) as week_period
                      from   scm_sys_lookup_value  WITH(NOLOCK)
                      where  lookup_type_code = 'AMEND_PAST_PERIOD'
                      and    segment1         = @v_master_id
                      and    segment2         = 'WEEK'
                     ) b
              where  a.seq = b.week_period
             ) a
      
      --LOG 생성
      SET @v_message   = '@n_amend_past_period : ' + convert(nvarchar, @n_amend_past_period)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null
	  
      SELECT @v_cal_type = ISNULL(MAX(ATTRIBUTE1),'N')
      from   scm_sys_lookup_value WITH(NOLOCK)
      where  lookup_type_code = 'ELEC_INSTANCE_OPTION'
      and    segment1         = @v_master_id
      and    ACTIVE_FLAG      = 'Y'
              
    END
    
    -- 적용 테이블
	-- FP_DAILY_PRODUCTIOIN_PLAN_H
	-- FP_AMEND_DAILY_PLAN_R
	-- FP_AMEND_DAILY_PLAN_H
    
    BEGIN
    
      SET @v_table_name = 'TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG'
    
      --DELETE FROM TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())
      
      DELETE FROM TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG 
      --WHERE INSTANCE_ID  = @v_master_id AND FP_PLAN_ID   = @v_plan_id
      
      --DELETE FROM TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG 
      --WHERE INSTANCE_ID  = @v_master_id AND FP_PLAN_ID   = @v_plan_id + '_ORG'
    
      INSERT INTO TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG
           (
             COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , FACTORY_ID
           , LOCATION
           , OPERATION_ID
           , LINE_ID
           , ELECTRODE_TYPE
           , EQUIPMENT_ID
           , PLAN_DATE
           , TOP_ITEM_ID
           , ITEM_ID
           , PRODUCTION_TYPE
           , MARKET
           , ITEM_UOM
           , WPP_IN_QTY_BATCH
           , WPP_IN_QTY
           , WPP_IN_QTY_M
           , WPP_IN_QTY_CELL
           , WPP_IN_QTY_JR
           , WPP_IN_QTY_KG
           , WPP_OUT_QTY_BATCH
           , WPP_OUT_QTY
           , WPP_OUT_QTY_M
           , WPP_OUT_QTY_CELL
           , WPP_OUT_QTY_JR
           , WPP_OUT_QTY_KG
           , INSERT_ID
           , INSERT_TIME
           , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           , VERSION    -- (D221117~R230219.01)
           , PLM_EC_NO    -- (D221117~R230219.01)
           , PLAN_TYPE
           , ORG_TYPE
           )
      SELECT A.COMPANY_ID
           , A.DIVISION_ID
           , A.SITE_ID
           , A.PLANT_ID
           , A.FACTORY_ID
           , ISNULL(B.LOCATION, '-')  AS LOCATION
           , A.OPERATION_ID
           , A.LINE_ID
           , A.ELECTRODE_TYPE
     	   , A.EQUIPMENT_ID
           , A.PLAN_DATE
           , A.ITEM_ID                AS TOP_ITEM_ID
           , A.ITEM_ID
           , A.PRODUCTION_TYPE
           , A.MARKET
           , C.ITEM_UOM
            , A.BATCH_IN_QTY  AS WPP_IN_QTY_BATCH
			, A.PLAN_IN_QTY   AS WPP_IN_QTY
			, A.ROLL_IN_QTY   AS WPP_IN_QTY_M
			, A.CELL_IN_QTY   AS WPP_IN_QTY_CELL
			, A.JR_IN_QTY     AS WPP_IN_QTY_JR
			, CASE WHEN A.OPERATION_ID = 'E0500' THEN A.PLAN_IN_QTY    ELSE 0 END AS WPP_IN_QTY_KG
			, A.BATCH_OUT_QTY AS WPP_OUT_QTY_BATCH
			, A.PLAN_QTY      AS WPP_OUT_QTY
			, A.ROLL_OUT_QTY  AS WPP_OUT_QTY_M
			, A.CELL_OUT_QTY  AS WPP_OUT_QTY_CELL
			, A.JR_OUT_QTY    AS WPP_OUT_QTY_JR
			, CASE WHEN A.OPERATION_ID = 'E0500' THEN A.PLAN_QTY       ELSE 0 END AS WPP_OUT_QTY_KG
			
           /*
           , CASE WHEN A.PLAN_TYPE = 'WPP' THEN A.BATCH_IN_QTY  ELSE 0 END AS WPP_IN_QTY_BATCH
           , CASE WHEN A.PLAN_TYPE = 'WPP' THEN A.PLAN_IN_QTY   ELSE 0 END AS WPP_IN_QTY
           , CASE WHEN A.PLAN_TYPE = 'WPP' THEN A.ROLL_IN_QTY   ELSE 0 END AS WPP_IN_QTY_M
           , CASE WHEN A.PLAN_TYPE = 'WPP' THEN A.CELL_IN_QTY   ELSE 0 END AS WPP_IN_QTY_CELL
           , CASE WHEN A.PLAN_TYPE = 'WPP' THEN A.JR_IN_QTY     ELSE 0 END AS WPP_IN_QTY_JR
           , CASE WHEN A.PLAN_TYPE = 'WPP' AND A.OPERATION_ID = 'E0500' THEN A.PLAN_IN_QTY    ELSE 0 END AS WPP_IN_QTY_KG
           , CASE WHEN A.PLAN_TYPE = 'WPP' THEN A.BATCH_OUT_QTY ELSE 0 END AS WPP_OUT_QTY_BATCH
           , CASE WHEN A.PLAN_TYPE = 'WPP' THEN A.PLAN_QTY      ELSE 0 END AS WPP_OUT_QTY
           , CASE WHEN A.PLAN_TYPE = 'WPP' THEN A.ROLL_OUT_QTY  ELSE 0 END AS WPP_OUT_QTY_M
           , CASE WHEN A.PLAN_TYPE = 'WPP' THEN A.CELL_OUT_QTY  ELSE 0 END AS WPP_OUT_QTY_CELL
           , CASE WHEN A.PLAN_TYPE = 'WPP' THEN A.JR_OUT_QTY    ELSE 0 END AS WPP_OUT_QTY_JR
           , CASE WHEN A.PLAN_TYPE = 'WPP' AND A.OPERATION_ID = 'E0500' THEN A.PLAN_QTY       ELSE 0 END AS WPP_OUT_QTY_KG
           
           , CASE WHEN A.PLAN_TYPE = 'MPP' THEN A.BATCH_IN_QTY  ELSE 0 END AS WPP_IN_QTY_BATCH
           , CASE WHEN A.PLAN_TYPE = 'MPP' THEN A.PLAN_IN_QTY   ELSE 0 END AS WPP_IN_QTY
           , CASE WHEN A.PLAN_TYPE = 'MPP' THEN A.ROLL_IN_QTY   ELSE 0 END AS WPP_IN_QTY_M
           , CASE WHEN A.PLAN_TYPE = 'MPP' THEN A.CELL_IN_QTY   ELSE 0 END AS WPP_IN_QTY_CELL
           , CASE WHEN A.PLAN_TYPE = 'MPP' THEN A.JR_IN_QTY     ELSE 0 END AS WPP_IN_QTY_JR
           , CASE WHEN A.PLAN_TYPE = 'MPP' AND A.OPERATION_ID = 'E0500' THEN A.PLAN_IN_QTY    ELSE 0 END AS WPP_IN_QTY_KG
           , CASE WHEN A.PLAN_TYPE = 'MPP' THEN A.BATCH_OUT_QTY ELSE 0 END AS WPP_OUT_QTY_BATCH
           , CASE WHEN A.PLAN_TYPE = 'MPP' THEN A.PLAN_QTY      ELSE 0 END AS WPP_OUT_QTY
           , CASE WHEN A.PLAN_TYPE = 'MPP' THEN A.ROLL_OUT_QTY  ELSE 0 END AS WPP_OUT_QTY_M
           , CASE WHEN A.PLAN_TYPE = 'MPP' THEN A.CELL_OUT_QTY  ELSE 0 END AS WPP_OUT_QTY_CELL
           , CASE WHEN A.PLAN_TYPE = 'MPP' THEN A.JR_OUT_QTY    ELSE 0 END AS WPP_OUT_QTY_JR
           , CASE WHEN A.PLAN_TYPE = 'MPP' AND A.OPERATION_ID = 'E0500' THEN A.PLAN_QTY       ELSE 0 END AS WPP_OUT_QTY_KG
           
           , CASE WHEN A.PLAN_TYPE = 'RELEASE' THEN A.BATCH_IN_QTY  ELSE 0 END AS WPP_IN_QTY_BATCH
           , CASE WHEN A.PLAN_TYPE = 'RELEASE' THEN A.PLAN_IN_QTY   ELSE 0 END AS WPP_IN_QTY
           , CASE WHEN A.PLAN_TYPE = 'RELEASE' THEN A.ROLL_IN_QTY   ELSE 0 END AS WPP_IN_QTY_M
           , CASE WHEN A.PLAN_TYPE = 'RELEASE' THEN A.CELL_IN_QTY   ELSE 0 END AS WPP_IN_QTY_CELL
           , CASE WHEN A.PLAN_TYPE = 'RELEASE' THEN A.JR_IN_QTY     ELSE 0 END AS WPP_IN_QTY_JR
           , CASE WHEN A.PLAN_TYPE = 'RELEASE' AND A.OPERATION_ID = 'E0500' THEN A.PLAN_IN_QTY    ELSE 0 END AS WPP_IN_QTY_KG
           , CASE WHEN A.PLAN_TYPE = 'RELEASE' THEN A.BATCH_OUT_QTY ELSE 0 END AS WPP_OUT_QTY_BATCH
           , CASE WHEN A.PLAN_TYPE = 'RELEASE' THEN A.PLAN_QTY      ELSE 0 END AS WPP_OUT_QTY
           , CASE WHEN A.PLAN_TYPE = 'RELEASE' THEN A.ROLL_OUT_QTY  ELSE 0 END AS WPP_OUT_QTY_M
           , CASE WHEN A.PLAN_TYPE = 'RELEASE' THEN A.CELL_OUT_QTY  ELSE 0 END AS WPP_OUT_QTY_CELL
           , CASE WHEN A.PLAN_TYPE = 'RELEASE' THEN A.JR_OUT_QTY    ELSE 0 END AS WPP_OUT_QTY_JR
           , CASE WHEN A.PLAN_TYPE = 'RELEASE' AND A.OPERATION_ID = 'E0500' THEN A.PLAN_QTY       ELSE 0 END AS WPP_OUT_QTY_KG
           */--
           
           
           , 'REBUILD'        AS INSERT_ID
           , GETDATE()        AS INSERT_TIME
           , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           , VERSION    -- (D221117~R230219.01)
           , '-' AS PLM_EC_NO    -- (D221117~R230219.01)
           , A.PLAN_TYPE
           , 'ORG' AS ORG_TYPE
           
      FROM   FP_DAILY_PRODUCTIOIN_PLAN_H  A
             LEFT OUTER JOIN SCM_LINE_M   B WITH(NOLOCK)
                  ON    B.COMPANY_ID      = A.COMPANY_ID
                  AND   B.DIVISION_ID     = A.DIVISION_ID
                  AND   B.SITE_ID         = A.SITE_ID
                  AND   B.PLANT_ID        = A.PLANT_ID
                  AND   B.FACTORY_ID      = A.FACTORY_ID
                  AND   B.OPERATION_ID    = A.OPERATION_ID
                  AND   B.LINE_ID         = A.LINE_ID
                  AND   B.ELECTRODE_TYPE  = A.ELECTRODE_TYPE
             LEFT OUTER JOIN SCM_ITEM_M   C WITH(NOLOCK)
  			 	  ON    C.COMPANY_ID   	  = A.COMPANY_ID
                  AND   C.DIVISION_ID     = A.DIVISION_ID
                  AND   C.SITE_ID         = A.SITE_ID
                  AND   C.ITEM_ID         = A.ITEM_ID
      WHERE  1=1
      --AND    A.PLAN_DATE   >= DATEADD(DAY, -@n_amend_past_period, @v_start_date )
      AND    A.PLAN_DATE   >= CONVERT(DATE, '20230219')
      AND    A.BATCH_IN_QTY > 0
      AND    A.VERSION <> '-'
      AND    A.OPERATION_ID = 'E2000'
      /*
      AND    EXISTS (
                      SELECT 1
                      FROM   (
                              SELECT B.COMPANY_ID
                                   , B.DIVISION_ID
                                   , B.SITE_ID
                                   , B.PLANT_ID
                                   , B.FACTORY_ID
                                   , C.OPERATION_ID
                              FROM   FP_INSTANCE_FACTORY_M  A WITH(NOLOCK)
                                   , SCM_FACTORY_M          B WITH(NOLOCK)
                                   , SCM_OPERATION_M        C WITH(NOLOCK)
                              WHERE  A.INSTANCE_ID    = @v_master_id
                              AND    A.ACTIVE_FLAG    = 'Y'
                              AND    A.FACTORY_ID     = B.FACTORY_ID
                              AND    B.ACTIVE_FLAG    = 'Y'
                              AND    B.COMPANY_ID     = C.COMPANY_ID
                              AND    B.DIVISION_ID    = C.DIVISION_ID
                              AND    B.SITE_ID        = C.SITE_ID
                              AND    A.INSTANCE_TYPE  = C.INSTANCE_TYPE
                              AND    C.ACTIVE_FLAG    = 'Y'
                             ) X
                      WHERE  X.COMPANY_ID     = A.COMPANY_ID
                      AND    X.DIVISION_ID    = A.DIVISION_ID
                      AND    X.SITE_ID        = A.SITE_ID
                      AND    X.PLANT_ID       = A.PLANT_ID
                      AND    X.FACTORY_ID     = A.FACTORY_ID
                      AND    X.OPERATION_ID   = A.OPERATION_ID
                    )
		*/
      --LOG 생성
      SET @v_message   = 'ORG : ' + convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, @v_log_code, @v_message, null

      INSERT INTO TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG
           (
             COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , FACTORY_ID
           , LOCATION
           , OPERATION_ID
           , LINE_ID
           , ELECTRODE_TYPE
           , EQUIPMENT_ID
           , PLAN_DATE
           , TOP_ITEM_ID
           , ITEM_ID
           , PRODUCTION_TYPE
           , MARKET
           , ITEM_UOM
           , WPP_IN_QTY_BATCH
           , WPP_IN_QTY
    , WPP_IN_QTY_M
           , WPP_IN_QTY_CELL
           , WPP_IN_QTY_JR
           , WPP_IN_QTY_KG
           , WPP_OUT_QTY_BATCH
           , WPP_OUT_QTY
           , WPP_OUT_QTY_M
           , WPP_OUT_QTY_CELL
           , WPP_OUT_QTY_JR
           , WPP_OUT_QTY_KG
           , INSERT_ID
           , INSERT_TIME
           , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           , VERSION    -- (D221117~R230219.01)
           --, PROD_SEQ    -- (D221117~R230219.01)
           , PLM_EC_NO    -- (D221117~R230219.01)
           , PLAN_TYPE
           , ORG_TYPE
           )
      SELECT A.COMPANY_ID
           , A.DIVISION_ID
           , A.SITE_ID
           , A.PLANT_ID
           , A.FACTORY_ID
           , A.LOCATION
           , A.OPERATION_ID
           , A.LINE_ID
           , A.ELECTRODE_TYPE
           , A.EQUIPMENT_ID
           , A.PLAN_DATE
           , A.TOP_ITEM_ID
           , A.ITEM_ID
           , A.PRODUCTION_TYPE
           , A.MARKET
           , A.ITEM_UOM
           , SUM(A.WPP_IN_QTY_BATCH ) AS WPP_IN_QTY_BATCH 
           , SUM(A.WPP_IN_QTY       ) AS WPP_IN_QTY       
           , SUM(A.WPP_IN_QTY_M     ) AS WPP_IN_QTY_M     
           , SUM(A.WPP_IN_QTY_CELL  ) AS WPP_IN_QTY_CELL  
           , SUM(A.WPP_IN_QTY_JR    ) AS WPP_IN_QTY_JR    
           , SUM(A.WPP_IN_QTY_KG    ) AS WPP_IN_QTY_KG    
           , SUM(A.WPP_OUT_QTY_BATCH) AS WPP_OUT_QTY_BATCH
           , SUM(A.WPP_OUT_QTY      ) AS WPP_OUT_QTY      
           , SUM(A.WPP_OUT_QTY_M    ) AS WPP_OUT_QTY_M    
           , SUM(A.WPP_OUT_QTY_CELL ) AS WPP_OUT_QTY_CELL 
           , SUM(A.WPP_OUT_QTY_JR   ) AS WPP_OUT_QTY_JR   
           , SUM(A.WPP_OUT_QTY_KG   ) AS WPP_OUT_QTY_KG   
           , MAX(A.INSERT_ID        ) AS INSERT_ID
           , MAX(A.INSERT_TIME      ) AS INSERT_TIME
           , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)-- (DR230317~R230317.01) 
           , A.VERSION   -- (D221117~R230219.01)-- (DR230317~R230317.01) 
           --, PROD_SEQ    -- (D221117~R230219.01)
           , PLM_EC_NO    -- (D221117~R230219.01)
           , PLAN_TYPE
           , 'CONVERT' AS ORG_TYPE
      FROM   TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG A
      WHERE  1=1
      AND    A.ORG_TYPE = 'ORG'
      GROUP  BY
         	 A.COMPANY_ID
           , A.DIVISION_ID
           , A.SITE_ID
           , A.PLANT_ID
           , A.FACTORY_ID
           , A.LOCATION
           , A.OPERATION_ID
           , A.LINE_ID
           , A.ELECTRODE_TYPE
           , A.EQUIPMENT_ID
           , A.PLAN_DATE
           , A.TOP_ITEM_ID
           , A.ITEM_ID
           , A.PRODUCTION_TYPE
           , A.MARKET
           , A.ITEM_UOM
		   , A.WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)-- (DR230317~R230317.01) 
           , A.VERSION   -- (D221117~R230219.01)-- (DR230317~R230317.01) 
           , PLM_EC_NO    -- (D221117~R230219.01) 
           , PLAN_TYPE 
      
      --LOG 생성
      SET @v_message   = convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, @v_log_code, @v_message, null

      UPDATE A
      SET    A.PROD_VERSION_TYPE  = ISNULL(B.PROD_VERSION_TYPE, 'GENERAL')
      FROM   TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG A
             LEFT OUTER JOIN SCM_LINE_M     B WITH(NOLOCK)
                  ON    B.COMPANY_ID      = A.COMPANY_ID
                  AND   B.DIVISION_ID     = A.DIVISION_ID
                  AND   B.SITE_ID         = A.SITE_ID
                  AND   B.PLANT_ID        = A.PLANT_ID
                  AND   B.FACTORY_ID      = A.FACTORY_ID
                  AND   B.OPERATION_ID    = A.OPERATION_ID
                  AND   B.LINE_ID         = A.LINE_ID
                  AND   B.ELECTRODE_TYPE  = A.ELECTRODE_TYPE
      WHERE  1=1
      AND    A.ORG_TYPE = 'CONVERT'

--LOG 생성
      SET @v_message  = 'PROD_VERSION_TYPE : ' + convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, @v_log_code, @v_message, null


      UPDATE A
      SET    A.YIELD              = A.MAX_YIELD
           , A.CHILD_YIELD        = A.CHILD_MAX_YIELD
      FROM   (
              SELECT A.*
                   , MAX(YIELD_CAL)       OVER ( PARTITION BY
                                                              A.COMPANY_ID
                                                            , A.DIVISION_ID
                                                            , A.SITE_ID
                                                            , A.PLANT_ID
                                                            , A.FACTORY_ID
                                                            , A.OPERATION_ID
                                                            , A.LINE_ID
                                                            , A.ELECTRODE_TYPE
                                                            , A.ITEM_ID
                                                            , A.MONTH) MAX_YIELD
                   , MAX(CHILD_YIELD_CAL) OVER ( PARTITION BY
                                                              A.COMPANY_ID
                                                            , A.DIVISION_ID
                                                            , A.SITE_ID
                                                            , A.PLANT_ID
                                                            , A.FACTORY_ID
                                                            , A.OPERATION_ID
                                                            , A.LINE_ID
                                                            , A.ELECTRODE_TYPE
                                                            , A.ITEM_ID
                                                            , A.MONTH) CHILD_MAX_YIELD
              FROM   (
                      SELECT A.*
                           , CASE WHEN B.YIELD >= 1 THEN 1 
                                  WHEN B.YIELD <= 0 THEN 1 
                                  ELSE ISNULL(B.YIELD, 1)
                             END  YIELD_CAL
                           , CASE WHEN C.YIELD >= 1 THEN 1 
                                  WHEN C.YIELD <= 0 THEN 1 
                                  ELSE ISNULL(C.YIELD, 1)
                             END  CHILD_YIELD_CAL
							, RANK() OVER ( PARTITION BY      A.COMPANY_ID
															, A.DIVISION_ID
															, A.SITE_ID
															, A.PLANT_ID
															, A.FACTORY_ID
															, A.OPERATION_ID
															, A.LINE_ID
															, A.ELECTRODE_TYPE
															, A.ITEM_ID
															, A.MONTH 
											ORDER BY ALT_PRIORITY)  AS RNK	-- add  (D20210422~R0422.01)
                      FROM   (
                              SELECT A.*
                                   , B.CHILD_ITEM_ID
                                   , C.FLOW_ID
                                   , CONVERT(NVARCHAR(6), A.PLAN_DATE, 112) AS MONTH
								   , ISNULL(B.ALT_PRIORITY,1) AS ALT_PRIORITY			-- add  (D20210422~R0422.01)
                              FROM   TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG A
                                   , SCM_BOM_M        B WITH(NOLOCK)
                                   , SCM_ITEM_M       C WITH(NOLOCK)
                                   , SCM_ITEM_CLASS_M D WITH(NOLOCK)
                             WHERE  1=1
      						  AND    A.ORG_TYPE = 'CONVERT'
                              AND    A.ITEM_UOM       IN ('EA', 'M')
                              AND    B.ACTIVE_FLAG    = 'Y'
                              AND    B.EFF_END_DATE   > GETDATE()
                              --AND   (B.ALT_PRIORITY   IS NULL OR B.ALT_PRIORITY = 1)	-- del  (D20210422~R0422.01)
                              AND    A.COMPANY_ID     = B.COMPANY_ID
                              AND    A.DIVISION_ID    = B.DIVISION_ID
                              AND    A.SITE_ID        = B.SITE_ID
                              AND    A.PLANT_ID       = B.PLANT_ID
                              AND    A.ITEM_ID        = B.PARENT_ITEM_ID             
                              AND    B.COMPANY_ID     = C.COMPANY_ID
                              AND    B.DIVISION_ID    = C.DIVISION_ID
                              AND    B.SITE_ID        = C.SITE_ID
                              AND    B.CHILD_ITEM_ID  = C.ITEM_ID
                              AND    C.ACTIVE_FLAG    = 'Y'
                              AND    C.ITEM_TYPE      = 'H'
                              AND    C.ITEM_CLASS     = D.CLASS_ID
                              AND    D.USE_FLAG       = 'Y'
                             ) A
                             LEFT OUTER JOIN SCM_YIELD_M B WITH(NOLOCK)
                                  ON    1=1			-- (D20200928~R0928.01)
								  AND	A.COMPANY_ID	  = B.COMPANY_ID
								  AND	A.DIVISION_ID	  = B.DIVISION_ID
								  AND	A.SITE_ID		  = B.SITE_ID
                                  AND   A.FACTORY_ID      = B.FACTORY_ID
                                  AND   A.LINE_ID         = B.LINE_ID
                                  AND   A.OPERATION_ID    = B.OPERATION_ID
								  AND	A.ITEM_ID         = B.ITEM_ID
                                  AND   A.MONTH           = B.MONTH
                                  AND   B.YIELD           > 0
                             LEFT OUTER JOIN SCM_YIELD_M C WITH(NOLOCK)
                                  ON    1=1			-- (D20200928~R0928.01)
								  AND	A.COMPANY_ID	  = B.COMPANY_ID
								  AND	A.DIVISION_ID	  = B.DIVISION_ID
								  AND	A.SITE_ID		  = B.SITE_ID
                                  AND   A.FACTORY_ID      = C.FACTORY_ID
                                  AND   A.LINE_ID         = C.LINE_ID
                                  AND   A.FLOW_ID         = C.OPERATION_ID
								  AND	A.CHILD_ITEM_ID   = C.ITEM_ID
                                  AND   A.MONTH           = C.MONTH
                                  AND   C.YIELD           > 0
                      WHERE  1=1
                     ) A            
              WHERE	1=1
			  AND	RNK = 1		-- add  (D20210422~R0422.01)
             ) A
      WHERE  1=1

      --LOG 생성
      SET @v_message   = 'YIELD / CHILD_YIELD : ' + convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, @v_log_code, @v_message, null

      SET @v_table_name = 'TH_BUF_AMEND_DAILY_CALC'
    
      --DELETE FROM TH_BUF_AMEND_DAILY_CALC WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())
      
      DELETE FROM TH_BUF_AMEND_DAILY_CALC
      --WHERE  INSTANCE_ID  = @v_master_id
      --AND    FP_PLAN_ID   = @v_plan_id
	  
     
	  			INSERT INTO TH_BUF_AMEND_DAILY_CALC
			           (
			             COMPANY_ID
			           , DIVISION_ID
			           , SITE_ID
			           , PLANT_ID
			           , FACTORY_ID
			           , OPERATION_ID
			           , LINE_ID
			           , ELECTRODE_TYPE
			           , ITEM_ID
			           , ITEM_UOM
			           , PROD_VERSION_TYPE
			           , CALC_MODEL
			           , CALC_TYPE
			           , CALC_VERSION
			            , WORK_REQUEST_MODEL_ID    -- (D221117~R230219.01)
           				, VERSION    -- (D221117~R230219.01)
           				, INSERT_ID
			           , INSERT_TIME
			           )
			      SELECT  A.COMPANY_ID
						, A.DIVISION_ID
						, A.SITE_ID
						, A.PLANT_ID
						, A.FACTORY_ID
						, A.OPERATION_ID
						, A.LINE_ID
						, A.ELECTRODE_TYPE
						, A.ITEM_ID
						, A.ITEM_UOM
						, ISNULL(A.PROD_VERSION_TYPE, '-') AS PROD_VERSION_TYPE
						, ISNULL(A.WORK_REQUEST_MODEL_ID, '-')          AS CALC_MODEL
						, CASE WHEN A.ITEM_UOM = 'KG' THEN 'MASS'
								                        ELSE ISNULL(A.VERSION_TYPE, '-')
							END  AS CALC_TYPE
						, ISNULL(A.VERSION, '-')           AS CALC_VERSION
						, ISNULL(A.WORK_REQUEST_MODEL_ID, '-')  AS WORK_REQUEST_MODEL_ID   -- (D221117~R230219.01)
           				, ISNULL(A.VERSION, '-')  AS VERSION    -- (D221117~R230219.01)
						, 'REBUILD'        AS INSERT_ID
						, GETDATE()        AS INSERT_TIME
					FROM   (
								SELECT A.COMPANY_ID
									, A.DIVISION_ID
									, A.SITE_ID
									, A.PLANT_ID
									, A.FACTORY_ID
									, A.OPERATION_ID
									, A.LINE_ID
									, A.ELECTRODE_TYPE
									, A.ITEM_ID
									, A.WORK_REQUEST_MODEL_ID
									, A.VERSION
									, B.PROD_VERSION_TYPE
									, B.VERSION_TYPE
									, MAX(A.ITEM_UOM)  AS ITEM_UOM
								FROM   TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG A
									, SCM_ITEM_CONV_CALC_M B WITH(NOLOCK)
								WHERE  1=1
     							AND    A.ORG_TYPE = 'CONVERT'
								AND   A.COMPANY_ID        = B.COMPANY_ID
								AND   A.DIVISION_ID       = B.DIVISION_ID
								AND   A.SITE_ID           = B.SITE_ID
								AND   A.PLANT_ID          = B.PLANT_ID
								AND   A.FACTORY_ID        = B.FACTORY_ID
								AND   A.OPERATION_ID      = B.OPERATION
								AND   A.WORK_REQUEST_MODEL_ID	= B.MODEL_ID
								AND   A.VERSION           = B.VERSION
								GROUP  BY 
									A.COMPANY_ID
									, A.DIVISION_ID
									, A.SITE_ID
									, A.PLANT_ID
									, A.FACTORY_ID
									, A.OPERATION_ID
									, A.LINE_ID
									, A.ELECTRODE_TYPE
									, A.ITEM_ID
									, A.WORK_REQUEST_MODEL_ID
									, A.VERSION
									, B.PROD_VERSION_TYPE
									, B.VERSION_TYPE
							) A
			      	WHERE  1=1
	  
	  

      --LOG 생성
      SET @v_message   = convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, @v_log_code, @v_message, null


      UPDATE A
      SET    A.PC_M_BATCH = ISNULL(B.VALUE, A.PC_M_BATCH)
           , A.JR_M_BATCH = ISNULL(C.VALUE, A.JR_M_BATCH)
           , A.CELL_BATCH = ISNULL(D.VALUE, A.CELL_BATCH)
      FROM  TH_BUF_AMEND_DAILY_CALC       A
            LEFT OUTER JOIN SCM_ITEM_CONV_CALC_M B WITH(NOLOCK)
                  ON    B.COMPANY_ID        = A.COMPANY_ID
                  AND   B.DIVISION_ID       = A.DIVISION_ID
                  AND   B.SITE_ID      		= A.SITE_ID
                  AND   B.PLANT_ID          = A.PLANT_ID
                  AND   B.FACTORY_ID        = A.FACTORY_ID
                  AND   B.ITEM_ID           = A.ITEM_ID
                  AND   B.OPERATION         = A.OPERATION_ID
                  AND   B.PROD_VERSION_TYPE = A.PROD_VERSION_TYPE
                  AND   B.MODEL_ID          = A.CALC_MODEL
                  AND   B.VERSION_TYPE      = A.CALC_TYPE
                  AND   B.VERSION           = A.CALC_VERSION
                  AND   B.CATEGORY          = 'Pancake (m/batch)'
             LEFT OUTER JOIN SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
                  ON    C.COMPANY_ID        = A.COMPANY_ID
                  AND   C.DIVISION_ID       = A.DIVISION_ID
                  AND   C.SITE_ID           = A.SITE_ID
                  AND   C.PLANT_ID          = A.PLANT_ID
                  AND   C.FACTORY_ID        = A.FACTORY_ID
                  AND   C.ITEM_ID           = A.ITEM_ID
                  AND   C.OPERATION         = A.OPERATION_ID
                  AND   C.PROD_VERSION_TYPE = A.PROD_VERSION_TYPE
                  AND   C.MODEL_ID          = A.CALC_MODEL
                  AND   C.VERSION_TYPE      = A.CALC_TYPE
                  AND   C.VERSION           = A.CALC_VERSION
                  AND   C.CATEGORY          = 'Jumbo Roll (m/batch)'
             LEFT OUTER JOIN SCM_ITEM_CONV_CALC_M D WITH(NOLOCK)
                  ON    D.COMPANY_ID        = A.COMPANY_ID
                  AND   D.DIVISION_ID       = A.DIVISION_ID
                  AND   D.SITE_ID           = A.SITE_ID
                  AND   D.PLANT_ID          = A.PLANT_ID
                  AND   D.FACTORY_ID        = A.FACTORY_ID
                  AND   D.ITEM_ID           = A.ITEM_ID
                  AND   D.OPERATION         = A.OPERATION_ID
                  AND   D.PROD_VERSION_TYPE = A.PROD_VERSION_TYPE
                  AND   D.MODEL_ID          = A.CALC_MODEL
                  AND   D.VERSION_TYPE      = A.CALC_TYPE
                  AND   D.VERSION           = A.CALC_VERSION
                  AND   D.CATEGORY          = 'cell/batch'
      WHERE  1=1
      AND    A.ITEM_UOM         IN ('M', 'EA')

      --LOG 생성
      SET @v_message   = 'PC / JR / CELL : ' + convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, @v_log_code, @v_message, null


      UPDATE A
      SET    A.KG_BATCH = ISNULL(B.BATCH_LOT_SIZE, A.KG_BATCH)
      FROM   TH_BUF_AMEND_DAILY_CALC       A
             LEFT  OUTER JOIN (
                               SELECT A.*
                                    , ISNULL(B.BATCH_ID, A.ITEM_ID) AS BATCH_ID
                                    , C.LINE_ID
                               FROM   SCM_ITEM_EQUIP_RATE_BATCH_M A WITH(NOLOCK)
                                      LEFT OUTER JOIN SCM_BATCH_M B WITH(NOLOCK)
                                           ON    A.COMPANY_ID   = B.COMPANY_ID
                                           AND   A.DIVISION_ID  = B.DIVISION_ID
                                           AND   A.SITE_ID      = B.SITE_ID
                                           AND   A.PLANT_ID     = B.PLANT_ID
                                           AND   A.ITEM_ID      = B.ITEM_ID
                                    , SCM_LINE_M                  C WITH(NOLOCK)
                               WHERE  1=1
                               AND    A.ACTIVE_FLAG       = 'Y'
                               AND    ISNULL(A.BATCH_LOT_SIZE, 0) > 0
  							   AND    ISNULL(A.TAT, 0)            > 0
                               AND    A.COMPANY_ID        = C.COMPANY_ID
 							   AND    A.DIVISION_ID       = C.DIVISION_ID
                               AND    A.SITE_ID           = C.SITE_ID
         					   AND    A.PLANT_ID          = C.PLANT_ID
                               AND    A.FACTORY_ID        = C.FACTORY_ID
                               AND    A.OPERATION_ID      = C.OPERATION_ID
          					   AND    A.PROD_VERSION_TYPE = C.PROD_VERSION_TYPE
                               AND    C.ACTIVE_FLAG       = 'Y'
                              ) B
                   ON     A.COMPANY_ID    = B.COMPANY_ID
                   AND    A.DIVISION_ID   = B.DIVISION_ID
                   AND    A.SITE_ID       = B.SITE_ID
                   AND    A.PLANT_ID      = B.PLANT_ID
                   AND    A.FACTORY_ID    = B.FACTORY_ID
                   AND    A.LINE_ID       = B.LINE_ID
                   AND    A.OPERATION_ID  = B.OPERATION_ID
                   AND    A.ITEM_ID       = B.ITEM_ID
      WHERE  A.ITEM_UOM         IN ('KG')

      
      --LOG 생성
      SET @v_message   = 'KG : ' + convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, @v_log_code, @v_message, null


      SET @v_table_name = 'TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG'
	  
     
	      	  UPDATE A
		      SET    A.WPP_IN_QTY       = CASE WHEN A.ITEM_UOM = 'EA' THEN ISNULL(ISNULL(B.CELL_BATCH, C.CELL_BATCH), D.CELL_BATCH)
		                                       WHEN A.ITEM_UOM = 'M'  THEN ISNULL(ISNULL(B.PC_M_BATCH, C.PC_M_BATCH), D.PC_M_BATCH)
		                                                              ELSE ISNULL(ISNULL(B.KG_BATCH,   C.KG_BATCH),   D.KG_BATCH)
		                                  END                                                      * A.WPP_IN_QTY_BATCH * A.CHILD_YIELD
		           , A.WPP_IN_QTY_M     = ISNULL(ISNULL(B.PC_M_BATCH, C.PC_M_BATCH), D.PC_M_BATCH) * A.WPP_IN_QTY_BATCH * A.CHILD_YIELD
		           , A.WPP_IN_QTY_JR    = ISNULL(ISNULL(B.JR_M_BATCH, C.JR_M_BATCH), D.JR_M_BATCH) * A.WPP_IN_QTY_BATCH * A.CHILD_YIELD
		           , A.WPP_IN_QTY_CELL  = ISNULL(ISNULL(B.CELL_BATCH, C.CELL_BATCH), D.CELL_BATCH) * A.WPP_IN_QTY_BATCH * A.CHILD_YIELD
		           --
		           , A.WPP_OUT_QTY      = CASE WHEN A.ITEM_UOM = 'EA' THEN ISNULL(ISNULL(B.CELL_BATCH, C.CELL_BATCH), D.CELL_BATCH)
		                                       WHEN A.ITEM_UOM = 'M'  THEN ISNULL(ISNULL(B.PC_M_BATCH, C.PC_M_BATCH), D.PC_M_BATCH)
		                                                              ELSE ISNULL(ISNULL(B.KG_BATCH,   C.KG_BATCH),   D.KG_BATCH)
		                                  END                                                      * A.WPP_IN_QTY_BATCH * A.CHILD_YIELD * A.YIELD
		           , A.WPP_OUT_QTY_M    = ISNULL(ISNULL(B.PC_M_BATCH, C.PC_M_BATCH), D.PC_M_BATCH) * A.WPP_IN_QTY_BATCH * A.CHILD_YIELD * A.YIELD
		           , A.WPP_OUT_QTY_JR   = ISNULL(ISNULL(B.JR_M_BATCH, C.JR_M_BATCH), D.JR_M_BATCH) * A.WPP_IN_QTY_BATCH * A.CHILD_YIELD * A.YIELD
		           , A.WPP_OUT_QTY_CELL = ISNULL(ISNULL(B.CELL_BATCH, C.CELL_BATCH), D.CELL_BATCH) * A.WPP_IN_QTY_BATCH * A.CHILD_YIELD * A.YIELD
		           --
		           
		           /*
		           , A.MPP_IN_QTY       = CASE WHEN A.ITEM_UOM = 'EA' THEN ISNULL(ISNULL(B.CELL_BATCH, C.CELL_BATCH), D.CELL_BATCH)
		                                       WHEN A.ITEM_UOM = 'M'  THEN ISNULL(ISNULL(B.PC_M_BATCH, C.PC_M_BATCH), D.PC_M_BATCH)
		                                                              ELSE ISNULL(ISNULL(B.KG_BATCH,   C.KG_BATCH),   D.KG_BATCH)
		                                  END                                                      * A.MPP_IN_QTY_BATCH * A.CHILD_YIELD
		           , A.MPP_IN_QTY_M     = ISNULL(ISNULL(B.PC_M_BATCH, C.PC_M_BATCH), D.PC_M_BATCH) * A.MPP_IN_QTY_BATCH * A.CHILD_YIELD
		           , A.MPP_IN_QTY_JR    = ISNULL(ISNULL(B.JR_M_BATCH, C.JR_M_BATCH), D.JR_M_BATCH) * A.MPP_IN_QTY_BATCH * A.CHILD_YIELD
		           , A.MPP_IN_QTY_CELL  = ISNULL(ISNULL(B.CELL_BATCH, C.CELL_BATCH), D.CELL_BATCH) * A.MPP_IN_QTY_BATCH * A.CHILD_YIELD
		           --
		           , A.MPP_OUT_QTY      = CASE WHEN A.ITEM_UOM = 'EA' THEN ISNULL(ISNULL(B.CELL_BATCH, C.CELL_BATCH), D.CELL_BATCH)
		                                       WHEN A.ITEM_UOM = 'M'  THEN ISNULL(ISNULL(B.PC_M_BATCH, C.PC_M_BATCH), D.PC_M_BATCH)
		                                                              ELSE ISNULL(ISNULL(B.KG_BATCH,   C.KG_BATCH),   D.KG_BATCH)
		                                  END                                                      * A.MPP_IN_QTY_BATCH * A.CHILD_YIELD * A.YIELD
		           , A.MPP_OUT_QTY_M    = ISNULL(ISNULL(B.PC_M_BATCH, C.PC_M_BATCH), D.PC_M_BATCH) * A.MPP_IN_QTY_BATCH * A.CHILD_YIELD * A.YIELD
		           , A.MPP_OUT_QTY_JR   = ISNULL(ISNULL(B.JR_M_BATCH, C.JR_M_BATCH), D.JR_M_BATCH) * A.MPP_IN_QTY_BATCH * A.CHILD_YIELD * A.YIELD
		           , A.MPP_OUT_QTY_CELL = ISNULL(ISNULL(B.CELL_BATCH, C.CELL_BATCH), D.CELL_BATCH) * A.MPP_IN_QTY_BATCH * A.CHILD_YIELD * A.YIELD
		           --
		           , A.WPP_OUT_QTY_BATCH  = A.WPP_IN_QTY_BATCH
		           , A.MPP_OUT_QTY_BATCH  = A.MPP_IN_QTY_BATCH
		          */
		           --, A.CALC_TYPE          = ISNULL(ISNULL(B.CALC_TYPE,    C.CALC_TYPE),    D.CALC_TYPE)
		           --, A.CALC_VERSION       = ISNULL(ISNULL(B.CALC_VERSION, C.CALC_VERSION), D.CALC_VERSION)
		      FROM   TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG A
		      LEFT OUTER JOIN TH_BUF_AMEND_DAILY_CALC B	--1순위에서 맞춰준다
		                  ON    B.COMPANY_ID        = A.COMPANY_ID
		                  AND   B.DIVISION_ID       = A.DIVISION_ID
		                  AND   B.SITE_ID           = A.SITE_ID
		                  AND   B.PLANT_ID          = A.PLANT_ID
		                  AND   B.FACTORY_ID        = A.FACTORY_ID
		                  AND   B.OPERATION_ID      = A.OPERATION_ID
		                  AND   B.LINE_ID           = A.LINE_ID
		                  AND   B.PROD_VERSION_TYPE = A.PROD_VERSION_TYPE
		                  AND   B.ITEM_ID           = A.ITEM_ID
		                  AND   CHARINDEX(B.CALC_TYPE, A.PRODUCTION_TYPE) > 0
		                  AND   B.CALC_VERSION		= A.VERSION
		                  AND   B.CALC_MODEL		= A.WORK_REQUEST_MODEL_ID
		             LEFT OUTER JOIN TH_BUF_AMEND_DAILY_CALC C
		                  ON    C.COMPANY_ID        = A.COMPANY_ID
		                  AND   C.DIVISION_ID       = A.DIVISION_ID
		                  AND   C.SITE_ID           = A.SITE_ID
		                  AND   C.PLANT_ID          = A.PLANT_ID
		                  AND   C.FACTORY_ID        = A.FACTORY_ID
		                  AND   C.OPERATION_ID      = A.OPERATION_ID
		                  AND   C.LINE_ID           = A.LINE_ID
		                  AND   C.PROD_VERSION_TYPE = A.PROD_VERSION_TYPE
		                  AND   C.ITEM_ID           = A.ITEM_ID
		                  AND   C.CALC_VERSION		= A.VERSION
		                  AND   C.CALC_MODEL		= A.WORK_REQUEST_MODEL_ID
		                  AND   C.CALC_TYPE         = 'MASS'
		             LEFT OUTER JOIN TH_BUF_AMEND_DAILY_CALC D
		                  ON    D.COMPANY_ID        = A.COMPANY_ID
		                  AND   D.DIVISION_ID       = A.DIVISION_ID
		                  AND   D.SITE_ID           = A.SITE_ID
		                  AND   D.PLANT_ID          = A.PLANT_ID
		                  AND   D.FACTORY_ID        = A.FACTORY_ID
		                  AND   D.OPERATION_ID      = A.OPERATION_ID
		                  AND   D.LINE_ID           = A.LINE_ID
		                  AND   D.PROD_VERSION_TYPE = A.PROD_VERSION_TYPE
		                  AND   D.ITEM_ID           = A.ITEM_ID
		                  AND   D.CALC_VERSION		= A.VERSION
		                  AND   D.CALC_MODEL		= A.WORK_REQUEST_MODEL_ID
		                  AND   D.CALC_TYPE         = 'TEST'
		      WHERE  1=1
		      AND    A.ORG_TYPE = 'CONVERT'
		      --AND    A.PLAN_DATE   >= CONVERT(DATE, @v_start_date)
	  
	

      --LOG 생성
      SET @v_message   = 'WPP / MPP : ' + convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, @v_log_code, @v_message, null
	
  
      -- batch 수량 제외하고 환산된 정보 만 업데이트 해준다.
      
        UPDATE A
		SET       A.PLAN_IN_QTY        = ISNULL(B.WPP_IN_QTY        , 0)
				, A.ROLL_IN_QTY      = ISNULL(B.WPP_IN_QTY_M      , 0)
				, A.JR_IN_QTY     = ISNULL(B.WPP_IN_QTY_JR     , 0)
				, A.CELL_IN_QTY   = ISNULL(B.WPP_IN_QTY_CELL   , 0)
				, A.PLAN_QTY       = ISNULL(B.WPP_OUT_QTY       , 0)
				, A.ROLL_OUT_QTY     = ISNULL(B.WPP_OUT_QTY_M     , 0)
				, A.JR_OUT_QTY = ISNULL(B.WPP_OUT_QTY_JR    , 0)
				, A.CELL_OUT_QTY  = ISNULL(B.WPP_OUT_QTY_CELL  , 0)
				, A.UPDATE_ID 			= A.UPDATE_ID + '_SYS'
	    FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A
               LEFT OUTER JOIN TH_BUF_AMEND_DAILY_WPPMPP_DATA_ORG B
                    ON    1=1
                    AND   A.COMPANY_ID     = B.COMPANY_ID
                    AND   A.DIVISION_ID      = B.DIVISION_ID
                    AND   A.SITE_ID         = B.SITE_ID
                    AND   A.PLANT_ID        = B.PLANT_ID
                    AND   A.FACTORY_ID      = B.FACTORY_ID
                    AND   A.LOCATION        = B.LOCATION
                    AND   A.OPERATION_ID    = B.OPERATION_ID
                    AND   A.LINE_ID         = B.LINE_ID
                    AND   A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE
                    AND   A.EQUIPMENT_ID    = B.EQUIPMENT_ID
                    AND   A.PLAN_DATE       = B.PLAN_DATE
                    AND   A.TOP_ITEM_ID     = B.TOP_ITEM_ID
                    AND   A.ITEM_ID         = B.ITEM_ID
                    AND   A.PRODUCTION_TYPE = B.PRODUCTION_TYPE
                    AND   A.MARKET          = B.MARKET
		    		AND   A.WORK_REQUEST_MODEL_ID  = B.WORK_REQUEST_MODEL_ID		
                    AND   A.VERSION          = B.VERSION		
                    AND   A.PLAN_TYPE		 = B.PLAN_TYPE
        WHERE  1=1
        AND    A.PLAN_DATE   >= CONVERT(DATE, '20230301')
      	AND    A.BATCH_IN_QTY > 0
        AND    A.VERSION <> '-'
        AND    A.OPERATION_ID = 'E2000'
        AND    B.ORG_TYPE = 'CONVERT'
		AND A.ITEM_ID IN (
							'APCCA1621A'
							,'APCAN1991A'
							,'APCAN1991A'
							,'APCAN0946A'
							,'APCAN0946A'
							,'APCAN2247A'
							,'APCCA2282A'
							,'APCAN2197A'
							,'APCCA1724A'
							,'APCCA1724A'
							,'APCCA1724A'
							,'APCCA1724A'
							,'APCAN1433A'
							,'APCCA1494A'
						)
       
	     --LOG 생성
      SET @v_message   = 'CONVERT : ' + convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, @v_log_code, @v_message, null

      ----------------------------------------------------------------------------------------------------------------
      ----------------------------------------------------------------------------------------------------------------
      ----------------------------------------------------------------------------------------------------------------
  

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
