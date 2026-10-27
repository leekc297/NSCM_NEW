CREATE PROCEDURE [dbo].[PR_SCM_FP_WPPMPP_REBUILD_LINE]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_FP_WPPMPP_REBUILD_LINE                                             **/
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
/** 2022.06.02    CYS          Location 정보 변경에 과거/현재 구간 UI 표시 불일치로 Location 정보를 최신 정보로 갱신 (D20220602~R0602.01)     **/
/** 2024.05.09    CYS          PDS-4MCC 버전 대응 **/ -- (D20240509~R0509.01)  
/** 2026/06/08   kimcd      [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응.            **/
/**                         Pack 공정군 로직에 LINK 공정군 추가                                 **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_FP_WPPMPP_REBUILD_LINE
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_FP_WPPMPP_REBUILD_LINE'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)

  DECLARE @v_start_date         date
        , @n_amend_past_period  Integer   
        
  DECLARE @v_max_model_type     nvarchar(100)
        , @n_include_line_cnt   Integer
        , @n_exclude_line_cnt   Integer
        
  DECLARE @sysdate          DATETIME2 = GETDATE()

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
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

      --LOG 생성
      SET @v_message   = '@v_start_date : ' + CONVERT(NVARCHAR, @v_start_date, 112)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

    
      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'

      select @n_amend_past_period = isnull(max(day_period), 30)
      from   (
              -- 일자 기준이면 일자만
              select convert(Integer, SEGMENT2) as day_period
              from   scm_sys_lookup_value WITH(NOLOCK)
              where  lookup_type_code = 'AMEND_PAST_PERIOD'
              and    segment1         = @v_master_id
              and    segment2         = 'DAY'
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

      SET @v_max_model_type = '-'
      
      SELECT @v_max_model_type = ISNULL(MAX(MODEL_TYPE), '-')
      FROM   SCM_LINE_M           A WITH(NOLOCK)
           , SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)
      WHERE  B.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
      AND    B.SEGMENT1         = @v_master_id
      AND    A.MODEL_TYPE       = B.SEGMENT2             

      --LOG 생성
      SET @v_message   = '@v_max_model_type : ' + @v_max_model_type
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

      SELECT @n_include_line_cnt = COUNT(1)
      FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
      WHERE  LOOKUP_TYPE_CODE = 'INSTANCE_SPLIT_LINE_DEFINITION'
      AND    SEGMENT1         = @v_master_id        -- 계획 수립할 라인이 있는 INSTANCE_ID
      AND    ACTIVE_FLAG      = 'Y'

      --LOG 생성
      SET @v_message   = '@n_include_line_cnt : ' + convert(nvarchar, @n_include_line_cnt)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

      SELECT @n_exclude_line_cnt = COUNT(1)
      FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
      WHERE  LOOKUP_TYPE_CODE = 'INSTANCE_SPLIT_LINE_DEFINITION'
      AND    SEGMENT2         = @v_master_id        -- 계획 제외할 라인이 있는 INSTANCE_ID
      AND    ACTIVE_FLAG      = 'Y'

      --LOG 생성
      SET @v_message   = '@n_exclude_line_cnt : ' + convert(nvarchar, @n_exclude_line_cnt)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

    END
    
    BEGIN
    
      SET @v_table_name = 'TH_BUF_AMEND_PLAN_WPPMPP_DATA'
    
      DELETE FROM TH_BUF_AMEND_PLAN_WPPMPP_DATA WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())
      
      DELETE FROM TH_BUF_AMEND_PLAN_WPPMPP_DATA WHERE INSTANCE_ID  = @v_master_id AND FP_PLAN_ID   = @v_plan_id
      DELETE FROM TH_BUF_AMEND_PLAN_WPPMPP_DATA WHERE INSTANCE_ID  = @v_master_id AND FP_PLAN_ID   = @v_plan_id + '_ORG'
    
      INSERT INTO TH_BUF_AMEND_PLAN_WPPMPP_DATA 
           (
             INSTANCE_ID
           , FP_PLAN_ID
           , COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , TOP_ITEM_ID
           , ITEM_ID
           , OPERATION_ID
           , FACTORY_ID
           , LOCATION
           , LINE_ID
           , ELECTRODE_TYPE
           , PLAN_DATE
           , PRODUCTION_TYPE
           , MARKET
           , DATE_SEQ
           , WPP_IN_QTY
           , WPP_OUT_QTY
           , WPP_CELL_IN_QTY
           , WPP_CELL_OUT_QTY
           , MPP_IN_QTY
           , MPP_OUT_QTY
           , MPP_CELL_IN_QTY
           , MPP_CELL_OUT_QTY
           , INSERT_ID
           , INSERT_TIME
           , UPDATE_ID
           , UPDATE_TIME
           , VERSION	 -- (D20240509~R0509.01)  
           , PLM_EC_NO	 -- (D20240509~R0509.01)  
           )
      SELECT @v_master_id         AS INSTANCE_ID
           , @v_plan_id + '_ORG'  AS FP_PLAN_ID
           , A.COMPANY_ID
           , A.DIVISION_ID
           , A.SITE_ID
           , A.PLANT_ID
           , A.TOP_ITEM_ID
           , A.ITEM_ID
           , A.OPERATION_ID
           , A.FACTORY_ID
           , ISNULL(C.LOCATION, A.LOCATION) AS LOCATION			-- (D20220602~R0602.01)
           , A.LINE_ID
           , A.ELECTRODE_TYPE
           , A.PLAN_DATE
           , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE
           , A.MARKET
           , 1 AS DATE_SEQ
           , CASE WHEN A.PLAN_TYPE = 'WPP'      THEN A.PLAN_IN_QTY   ELSE 0 END AS WPP_IN_QTY
           , CASE WHEN A.PLAN_TYPE = 'WPP'      THEN A.PLAN_QTY      ELSE 0 END AS WPP_OUT_QTY
           , CASE WHEN A.PLAN_TYPE = 'WPP'      THEN A.CELL_IN_QTY   ELSE 0 END AS WPP_CELL_IN_QTY
           , CASE WHEN A.PLAN_TYPE = 'WPP'      THEN A.CELL_OUT_QTY  ELSE 0 END AS WPP_CELL_OUT_QTY
           , CASE WHEN A.PLAN_TYPE = 'MPP'      THEN A.PLAN_IN_QTY   ELSE 0 END AS MPP_IN_QTY
           , CASE WHEN A.PLAN_TYPE = 'MPP'      THEN A.PLAN_QTY      ELSE 0 END AS MPP_OUT_QTY
           , CASE WHEN A.PLAN_TYPE = 'MPP'      THEN A.CELL_IN_QTY   ELSE 0 END AS MPP_CELL_IN_QTY
           , CASE WHEN A.PLAN_TYPE = 'MPP'      THEN A.CELL_OUT_QTY  ELSE 0 END AS MPP_CELL_OUT_QTY
           , @v_proc_name     AS INSERT_ID	-- (D20220602~R0602.01)
           , GETDATE()  AS INSERT_TIME
           , @v_proc_name     AS UPDATE_ID	-- (D20220602~R0602.01)
           , GETDATE()  AS UPDATE_TIME
           , A.VERSION		 -- (D20240509~R0509.01)  
           , A.PLM_EC_NO	 -- (D20240509~R0509.01)  
      FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)
				INNER JOIN (	-- 항상 최근 location 보도록 수정 by cys (D20220602~R0602.01)
								SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, MAX(ISNULL(A.LOCATION,'-')) AS LOCATION
								FROM 	SCM_LINE_M A WITH(NOLOCK)
								WHERE	1=1
								AND		A.ACTIVE_FLAG = 'Y'
								GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
				) C
				ON 1=1
				AND    A.COMPANY_ID       = C.COMPANY_ID
				AND    A.DIVISION_ID      = C.DIVISION_ID
				AND    A.SITE_ID          = C.SITE_ID
				AND    A.PLANT_ID         = C.PLANT_ID
				AND    A.FACTORY_ID       = C.FACTORY_ID
				AND    A.OPERATION_ID     = C.OPERATION_ID
				AND    A.LINE_ID          = C.LINE_ID
				AND    A.ELECTRODE_TYPE   = C.ELECTRODE_TYPE
      WHERE  1=1
      AND    A.PLAN_DATE   >= DATEADD(DAY, -@n_amend_past_period, @v_start_date )
      AND    A.PLAN_TYPE    IN ('MPP','WPP')
      AND    A.PLAN_IN_QTY  > 0
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

      --LOG 생성
      SET @v_message   = 'ORG : ' + convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, @v_log_code, @v_message, null
      
      -- PLAN GROUP 으로 진행되는 INSTANCE 는 해당 PLAN GROUP 을 제외한 데이터는 삭제 처리
      IF @v_max_model_type != '-'
      BEGIN
      
        DELETE FROM A 
        FROM   TH_BUF_AMEND_PLAN_WPPMPP_DATA A
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_plan_id + '_ORG'
        AND    NOT EXISTS (
                            SELECT 1
                            FROM   SCM_LINE_M           X WITH(NOLOCK)
                                 , SCM_SYS_LOOKUP_VALUE Y WITH(NOLOCK)
                            WHERE  Y.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
                            AND    Y.SEGMENT1         = A.INSTANCE_ID
                            AND    Y.SEGMENT2         = X.MODEL_TYPE
                            AND    X.ACTIVE_FLAG      = 'Y'
                            AND    X.COMPANY_ID       = A.COMPANY_ID
                            AND    X.DIVISION_ID      = A.DIVISION_ID
                            AND    X.SITE_ID          = A.SITE_ID
                            AND    X.PLANT_ID         = A.PLANT_ID
                            AND    X.FACTORY_ID       = A.FACTORY_ID
                            AND    X.LINE_ID          = A.LINE_ID
                            AND    X.OPERATION_ID     = A.OPERATION_ID            
                          )
        
        --LOG 생성
        SET @v_message   = 'ORG (NOT-PLAN-GROUP) : ' + convert(nvarchar, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null
        
      END
      
      -- 계획 수립라인이 지정된 인스턴스는 해당 라인을 제외한 데이터 삭제
      IF @n_include_line_cnt > 0
      BEGIN

        DELETE FROM A 
        FROM   TH_BUF_AMEND_PLAN_WPPMPP_DATA A
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_plan_id + '_ORG'
        AND    NOT EXISTS (
                            SELECT 1
                            FROM   SCM_SYS_LOOKUP_VALUE X WITH(NOLOCK)
                            WHERE  LOOKUP_TYPE_CODE = 'INSTANCE_SPLIT_LINE_DEFINITION'
                            AND    X.SEGMENT1       = A.INSTANCE_ID        -- 계획 수립할 라인이 있는 INSTANCE_ID
                            AND    X.SEGMENT3       = A.LINE_ID 
                            AND    X.ACTIVE_FLAG    = 'Y'
                          )

        --LOG 생성
        SET @v_message   = 'ORG (INCLUDE_LINE) : ' + convert(nvarchar, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null

      END
      
      -- 계획 제외 라인이 지정된 인스턴스는 해당 라인의 데이터 삭제
      IF @n_exclude_line_cnt > 0
      BEGIN

        DELETE FROM A
        FROM   TH_BUF_AMEND_PLAN_WPPMPP_DATA A
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_plan_id
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_SYS_LOOKUP_VALUE X WITH(NOLOCK)
                        WHERE  LOOKUP_TYPE_CODE = 'INSTANCE_SPLIT_LINE_DEFINITION'
                        AND    X.SEGMENT2         = A.INSTANCE_ID        -- 계획 제외할 라인이 있는 INSTANCE_ID
                        AND    X.SEGMENT3         = A.LINE_ID 
                        AND    X.ACTIVE_FLAG      = 'Y'
                      )

        --LOG 생성
        SET @v_message   = 'ORG (EXCLUDE_LINE) : ' + convert(nvarchar, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null

      END

      INSERT INTO TH_BUF_AMEND_PLAN_WPPMPP_DATA 
           (
             INSTANCE_ID
           , FP_PLAN_ID
           , COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , TOP_ITEM_ID
           , ITEM_ID
           , OPERATION_ID
           , FACTORY_ID
           , LOCATION
           , LINE_ID
           , ELECTRODE_TYPE
           , PLAN_DATE
           , PRODUCTION_TYPE
           , MARKET
           , DATE_SEQ
           , WPP_IN_QTY
           , WPP_OUT_QTY
           , WPP_CELL_IN_QTY
           , WPP_CELL_OUT_QTY
           , MPP_IN_QTY
           , MPP_OUT_QTY
           , MPP_CELL_IN_QTY
           , MPP_CELL_OUT_QTY
           , INSERT_ID
           , INSERT_TIME
           , UPDATE_ID
           , UPDATE_TIME
           , VERSION	 -- (D20240509~R0509.01)  
           , PLM_EC_NO	 -- (D20240509~R0509.01)  
           )
      SELECT A.INSTANCE_ID
           , @v_plan_id               AS FP_PLAN_ID
           , A.COMPANY_ID
           , A.DIVISION_ID
           , A.SITE_ID
           , A.PLANT_ID
           , A.TOP_ITEM_ID
           , A.ITEM_ID
           , A.OPERATION_ID
           , A.FACTORY_ID
           , A.LOCATION
           , A.LINE_ID
           , A.ELECTRODE_TYPE
           , A.PLAN_DATE
           , A.PRODUCTION_TYPE
           , A.MARKET
           , MAX(A.DATE_SEQ)          AS DATE_SEQ
           , SUM(A.WPP_IN_QTY)        AS WPP_IN_QTY
           , SUM(A.WPP_OUT_QTY)       AS WPP_OUT_QTY
           , SUM(A.WPP_CELL_IN_QTY)   AS WPP_CELL_IN_QTY
           , SUM(A.WPP_CELL_OUT_QTY)  AS WPP_CELL_OUT_QTY
           , SUM(A.MPP_IN_QTY)        AS MPP_IN_QTY
           , SUM(A.MPP_OUT_QTY)       AS MPP_OUT_QTY
           , SUM(A.MPP_CELL_IN_QTY)   AS MPP_CELL_IN_QTY
           , SUM(A.MPP_CELL_OUT_QTY)  AS MPP_CELL_OUT_QTY
           , MAX(INSERT_ID)           AS INSERT_ID
           , MAX(INSERT_TIME)         AS INSERT_TIME
           , MAX(UPDATE_ID)           AS UPDATE_ID
           , MAX(UPDATE_TIME)         AS UPDATE_TIME
           , A.VERSION	 	 -- (D20240509~R0509.01)  
           , A.PLM_EC_NO	 -- (D20240509~R0509.01)  
      FROM   TH_BUF_AMEND_PLAN_WPPMPP_DATA A
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id + '_ORG'
      GROUP  BY
             A.INSTANCE_ID
           , A.FP_PLAN_ID
           , A.COMPANY_ID
           , A.DIVISION_ID
           , A.SITE_ID
           , A.PLANT_ID
           , A.TOP_ITEM_ID
           , A.ITEM_ID
           , A.OPERATION_ID
           , A.FACTORY_ID
           , A.LOCATION
           , A.LINE_ID
           , A.ELECTRODE_TYPE
           , A.PLAN_DATE
           , A.PRODUCTION_TYPE
           , A.MARKET
           , A.VERSION		 -- (D20240509~R0509.01)  
           , A.PLM_EC_NO  	 -- (D20240509~R0509.01)  
      
      --LOG 생성
      SET @v_message   = convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, @v_log_code, @v_message, null


      UPDATE A
      SET    A.WPP_IN_QTY = CEILING(A.WPP_OUT_QTY / ISNULL(B.YIELD, 1)) 
           , A.MPP_IN_QTY = CEILING(A.MPP_OUT_QTY / ISNULL(B.YIELD, 1))
      FROM   TH_BUF_AMEND_PLAN_WPPMPP_DATA A
             LEFT OUTER JOIN  SCM_YIELD_M   B WITH(NOLOCK)
                  ON    B.COMPANY_ID      = A.COMPANY_ID
                  AND   B.DIVISION_ID     = A.DIVISION_ID
                  AND   B.SITE_ID         = A.SITE_ID
                  AND   B.PLANT_ID        = A.PLANT_ID
                  AND   B.FACTORY_ID      = A.FACTORY_ID
                  AND   B.LINE_ID         = A.LINE_ID
                  AND   B.OPERATION_ID    = A.OPERATION_ID
                  AND   B.ITEM_ID         = A.ITEM_ID
                  AND   B.MONTH           = CONVERT(NVARCHAR(6), A.PLAN_DATE, 112)
                  AND   B.YIELD           > 0
                  AND   B.YIELD           < 1
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id

      --LOG 생성
      SET @v_message   = 'WPP_IN_QTY / MPP_IN_QTY : ' + convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, @v_log_code, @v_message, null

	  UPDATE A
      SET    A.WPP_CELL_IN_QTY    = FLOOR(ISNULL(A.WPP_IN_QTY,0)  / A.ACCUMULATED_CHILD_QTY )
           , A.WPP_CELL_OUT_QTY   = FLOOR(ISNULL(A.WPP_OUT_QTY,0) / A.ACCUMULATED_CHILD_QTY )
           , A.MPP_CELL_IN_QTY    = FLOOR(ISNULL(A.MPP_IN_QTY,0)  / A.ACCUMULATED_CHILD_QTY )
           , A.MPP_CELL_OUT_QTY   = FLOOR(ISNULL(A.MPP_OUT_QTY,0) / A.ACCUMULATED_CHILD_QTY )
      FROM   (
              SELECT A.*
						, CASE WHEN ISNULL(DBO.FN_GET_REQ_QTY_MODEL( A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PLAN_DATE), 0) <= 0  THEN 1
                                 ELSE ISNULL(DBO.FN_GET_REQ_QTY_MODEL( A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PLAN_DATE), 0)
						  END  AS ACCUMULATED_CHILD_QTY
              FROM	TH_BUF_AMEND_PLAN_WPPMPP_DATA A
              WHERE	A.INSTANCE_ID	= @v_master_id
              AND		A.FP_PLAN_ID	= @v_plan_id
             ) A
      WHERE  1=1

	  /** FP_ITEM_CELL_EXCHANGE_M table 사용안함 20190904 by cys
      UPDATE A
      SET    A.WPP_CELL_IN_QTY    = FLOOR(ISNULL(A.WPP_IN_QTY,0)  / A.ACCUMULATED_CHILD_QTY )
           , A.WPP_CELL_OUT_QTY   = FLOOR(ISNULL(A.WPP_OUT_QTY,0) / A.ACCUMULATED_CHILD_QTY )
           , A.MPP_CELL_IN_QTY    = FLOOR(ISNULL(A.MPP_IN_QTY,0)  / A.ACCUMULATED_CHILD_QTY )
           , A.MPP_CELL_OUT_QTY   = FLOOR(ISNULL(A.MPP_OUT_QTY,0) / A.ACCUMULATED_CHILD_QTY )
      FROM   (
              SELECT A.*
                   , CASE WHEN ISNULL(B.ACCUMULATED_CHILD_QTY, 0) <= 0  THEN 1
                                                                        ELSE B.ACCUMULATED_CHILD_QTY
                     END  AS ACCUMULATED_CHILD_QTY
              FROM   TH_BUF_AMEND_PLAN_WPPMPP_DATA A
                     LEFT OUTER JOIN FP_ITEM_CELL_EXCHANGE_M B
                          ON    A.COMPANY_ID  = B.COMPANY_ID
                          AND   A.DIVISION_ID = B.DIVISION_ID
                          AND   A.SITE_ID     = B.SITE_ID
                          AND   A.PLANT_ID    = B.PLANT_ID
                          AND   A.TOP_ITEM_ID = B.MODEL_ID
                          AND   A.ITEM_ID     = B.ITEM_ID
              WHERE  A.INSTANCE_ID  = @v_master_id
              AND    A.FP_PLAN_ID   = @v_plan_id
             ) A
      WHERE  1=1
	  */
      --LOG 생성
      SET @v_message   = 'CELL_IN_QTY / CELL_OUT_QTY : ' + convert(nvarchar, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, @v_log_code, @v_message, null

      ----------------------------------------------------------------------------------------------------------------
      ----------------------------------------------------------------------------------------------------------------
      ----------------------------------------------------------------------------------------------------------------
      
      IF 1=1
      BEGIN
      
        IF CHARINDEX('CELL', @v_master_id) > 0
        BEGIN
        
          SET @v_table_name = 'FP_AMEND_PLAN_CELL_R'

          UPDATE A 
          SET    A.WPP_IN_QTY         = ISNULL(B.WPP_IN_QTY,        0)
               , A.WPP_OUT_QTY        = ISNULL(B.WPP_OUT_QTY,       0)
               , A.WPP_CELL_IN_QTY    = ISNULL(B.WPP_CELL_IN_QTY,   0)
               , A.WPP_CELL_OUT_QTY   = ISNULL(B.WPP_CELL_OUT_QTY,  0)
               , A.MPP_IN_QTY         = ISNULL(B.MPP_IN_QTY,        0)
               , A.MPP_OUT_QTY        = ISNULL(B.MPP_OUT_QTY,       0)
               , A.MPP_CELL_IN_QTY    = ISNULL(B.MPP_CELL_IN_QTY,   0)
               , A.MPP_CELL_OUT_QTY   = ISNULL(B.MPP_CELL_OUT_QTY,  0)
          FROM   FP_AMEND_PLAN_CELL_R A 
                 LEFT OUTER JOIN TH_BUF_AMEND_PLAN_WPPMPP_DATA   B 
                      ON    1=1
                      AND   A.INSTANCE_ID     = B.INSTANCE_ID
                      AND   A.FP_PLAN_ID      = B.FP_PLAN_ID
                      AND   A.ITEM_ID         = B.ITEM_ID
                      AND   A.OPERATION_ID    = B.OPERATION_ID
                      AND   A.FACTORY_ID      = B.FACTORY_ID
                      AND   A.LOCATION        = B.LOCATION
                      AND   A.PRODUCTION_TYPE = B.PRODUCTION_TYPE
                      AND   A.MARKET          = B.MARKET
                      AND   A.LINE_ID         = B.LINE_ID
                      AND   A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE
                      AND   A.PLAN_DATE       = B.PLAN_DATE
                      AND   A.TOP_ITEM_ID     = B.TOP_ITEM_ID
                      AND   A.VERSION         = B.VERSION		 -- (D20240509~R0509.01)  
                      AND   A.PLM_EC_NO       = B.PLM_EC_NO		 -- (D20240509~R0509.01)  
          WHERE  A.INSTANCE_ID  = @v_master_id
          AND    A.FP_PLAN_ID   = @v_plan_id

          --LOG 생성
          SET @v_message   = 'WPP / MPP : ' + convert(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, @v_log_code, @v_message, null

          -- LINE 에 존재하지 않는 WPP / MPP 데이터는 0 으로 설정
          INSERT INTO FP_AMEND_PLAN_CELL_R
               (
                 INSTANCE_ID
               , FP_PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , CATEGORY_ID
               , SITE_ID
               , PLANT_ID
               , ITEM_ID
               , OPERATION_ID
               , FACTORY_ID
               , LOCATION
               , PRODUCTION_TYPE
               , MARKET
               , LINE_ID
               , ELECTRODE_TYPE
               , PLAN_DATE
               , TOP_ITEM_ID
               , ITEM_TYPE
               , IN_QTY
               , OUT_QTY
               , CELL_IN_QTY
               , CELL_OUT_QTY
               , DATE_SEQ
               , ORG_IN_QTY
               , ORG_OUT_QTY
               , ORG_CELL_IN_QTY
               , ORG_CELL_OUT_QTY
               , INSERT_ID
               , INSERT_TIME
               , UPDATE_ID
               , UPDATE_TIME
               , SETUP_COLOR_CODE
               , RESULT_IN_QTY
               , RESULT_OUT_QTY
               , RESULT_CELL_IN_QTY
               , RESULT_CELL_OUT_QTY
               , WPP_IN_QTY
               , WPP_OUT_QTY
               , WPP_CELL_IN_QTY
               , WPP_CELL_OUT_QTY
               , MPP_IN_QTY
               , MPP_OUT_QTY
               , MPP_CELL_IN_QTY
               , MPP_CELL_OUT_QTY
               , VERSION		 -- (D20240509~R0509.01)  
               , PLM_EC_NO		 -- (D20240509~R0509.01)  
               )
          SELECT
                 A.INSTANCE_ID
               , A.FP_PLAN_ID
               , A.COMPANY_ID
               , A.DIVISION_ID
               , A.CATEGORY_ID
               , A.SITE_ID
               , A.PLANT_ID
               , A.ITEM_ID
               , A.OPERATION_ID
               , A.FACTORY_ID
               , A.LOCATION
               , A.PRODUCTION_TYPE
               , A.MARKET
               , A.LINE_ID
               , A.ELECTRODE_TYPE
               , A.PLAN_DATE
               , A.TOP_ITEM_ID
               , ISNULL(A.ITEM_TYPE, '-') AS ITEM_TYPE
               , 0                AS IN_QTY
               , 0                AS OUT_QTY
               , 0                AS CELL_IN_QTY
               , 0                AS CELL_OUT_QTY
               , 1                AS DATE_SEQ
               , 0                AS ORG_IN_QTY
               , 0                AS ORG_OUT_QTY
               , 0                AS ORG_CELL_IN_QTY
               , 0                AS ORG_CELL_OUT_QTY
               , A.INSERT_ID
               , A.INSERT_TIME
               , A.UPDATE_ID
               , A.UPDATE_TIME
               , NULL             AS SETUP_COLOR_CODE
               , 0                AS RESULT_IN_QTY
               , 0                AS RESULT_OUT_QTY
               , 0                AS RESULT_CELL_IN_QTY
               , 0                AS RESULT_CELL_OUT_QTY
               , 0                AS WPP_IN_QTY
               , 0                AS WPP_OUT_QTY
               , 0                AS WPP_CELL_IN_QTY
               , 0                AS WPP_CELL_OUT_QTY
               , 0                AS MPP_IN_QTY
               , 0                AS MPP_OUT_QTY
               , 0                AS MPP_CELL_IN_QTY
               , 0                AS MPP_CELL_OUT_QTY
               , A.VERSION		 -- (D20240509~R0509.01)  
               , A.PLM_EC_NO	 -- (D20240509~R0509.01)  
          FROM   TH_BUF_AMEND_PLAN_WPPMPP_DATA A
          WHERE  A.INSTANCE_ID  = @v_master_id
          AND    A.FP_PLAN_ID   = @v_plan_id
          AND    NOT EXISTS (
                              SELECT 1
                              FROM   SCM_LINE_M X WITH(NOLOCK)
                              WHERE  X.COMPANY_ID     = A.COMPANY_ID
                              AND    X.DIVISION_ID    = A.DIVISION_ID
                              AND    X.SITE_ID        = A.SITE_ID
                              AND    X.PLANT_ID       = A.PLANT_ID
                              AND    X.FACTORY_ID     = A.FACTORY_ID
                              AND    X.LINE_ID        = A.LINE_ID
                              AND    X.OPERATION_ID   = A.OPERATION_ID
                              AND    X.ELECTRODE_TYPE = A.ELECTRODE_TYPE
                            )

          --LOG 생성
          SET @v_message   = 'WPP / MPP (DEL) : ' + convert(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, @v_log_code, @v_message, null


          INSERT INTO FP_AMEND_PLAN_CELL_R
               (
                 INSTANCE_ID
               , FP_PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , CATEGORY_ID
               , SITE_ID
               , PLANT_ID
               , ITEM_ID
               , OPERATION_ID
               , FACTORY_ID
               , LOCATION
               , PRODUCTION_TYPE
               , MARKET
               , LINE_ID
               , ELECTRODE_TYPE
               , PLAN_DATE
               , TOP_ITEM_ID
               , ITEM_TYPE
               , IN_QTY
               , OUT_QTY
               , CELL_IN_QTY
               , CELL_OUT_QTY
               , DATE_SEQ
               , ORG_IN_QTY
               , ORG_OUT_QTY
               , ORG_CELL_IN_QTY
               , ORG_CELL_OUT_QTY
               , INSERT_ID
               , INSERT_TIME
               , UPDATE_ID
               , UPDATE_TIME
               , SETUP_COLOR_CODE
               , RESULT_IN_QTY
               , RESULT_OUT_QTY
               , RESULT_CELL_IN_QTY
               , RESULT_CELL_OUT_QTY
               , WPP_IN_QTY
               , WPP_OUT_QTY
               , WPP_CELL_IN_QTY
               , WPP_CELL_OUT_QTY
               , MPP_IN_QTY
               , MPP_OUT_QTY
               , MPP_CELL_IN_QTY
               , MPP_CELL_OUT_QTY
               , VERSION		 -- (D20240509~R0509.01)  
               , PLM_EC_NO		 -- (D20240509~R0509.01)  
               )
          SELECT
                 A.INSTANCE_ID
               , A.FP_PLAN_ID
               , A.COMPANY_ID
               , A.DIVISION_ID
               , A.CATEGORY_ID
               , A.SITE_ID
               , A.PLANT_ID
               , A.ITEM_ID
               , A.OPERATION_ID
               , A.FACTORY_ID
               , A.LOCATION
               , A.PRODUCTION_TYPE
               , A.MARKET
               , A.LINE_ID
               , A.ELECTRODE_TYPE
               , A.PLAN_DATE
               , A.TOP_ITEM_ID
               , ISNULL(A.ITEM_TYPE, '-') AS ITEM_TYPE
               , 0                AS IN_QTY
               , 0                AS OUT_QTY
               , 0                AS CELL_IN_QTY
               , 0                AS CELL_OUT_QTY
               , 1                AS DATE_SEQ
               , 0                AS ORG_IN_QTY
               , 0                AS ORG_OUT_QTY
               , 0                AS ORG_CELL_IN_QTY
               , 0                AS ORG_CELL_OUT_QTY
               , A.INSERT_ID
               , A.INSERT_TIME
               , A.UPDATE_ID
               , A.UPDATE_TIME
               , NULL             AS SETUP_COLOR_CODE
               , 0                AS RESULT_IN_QTY
               , 0                AS RESULT_OUT_QTY
               , 0                AS RESULT_CELL_IN_QTY
               , 0                AS RESULT_CELL_OUT_QTY
               , A.WPP_IN_QTY
               , A.WPP_OUT_QTY
               , A.WPP_CELL_IN_QTY
               , A.WPP_CELL_OUT_QTY
               , A.MPP_IN_QTY
               , A.MPP_OUT_QTY
               , A.MPP_CELL_IN_QTY
               , A.MPP_CELL_OUT_QTY
               , A.VERSION		 -- (D20240509~R0509.01)  
               , A.PLM_EC_NO	 -- (D20240509~R0509.01)  
          FROM   TH_BUF_AMEND_PLAN_WPPMPP_DATA A
          WHERE  A.INSTANCE_ID  = @v_master_id
          AND    A.FP_PLAN_ID   = @v_plan_id
          AND    NOT EXISTS (
                              SELECT 1
                              FROM   FP_AMEND_PLAN_CELL_R X
                              WHERE  1=1  
                              AND    X.INSTANCE_ID      = A.INSTANCE_ID
                              AND    X.FP_PLAN_ID       = A.FP_PLAN_ID
                              AND    X.ITEM_ID          = A.ITEM_ID
                              AND    X.OPERATION_ID     = A.OPERATION_ID
                              AND    X.FACTORY_ID       = A.FACTORY_ID
                              AND    X.LOCATION         = A.LOCATION
                              AND    X.PRODUCTION_TYPE  = A.PRODUCTION_TYPE
                              AND    X.MARKET           = A.MARKET
                              AND    X.LINE_ID          = A.LINE_ID
                              AND    X.ELECTRODE_TYPE   = A.ELECTRODE_TYPE
                              AND    X.PLAN_DATE        = A.PLAN_DATE
                              AND    X.TOP_ITEM_ID      = A.TOP_ITEM_ID
                              AND    X.VERSION      	= A.VERSION		 -- (D20240509~R0509.01)  
                              AND    X.PLM_EC_NO      	= A.PLM_EC_NO	 -- (D20240509~R0509.01)  
                            )

          --LOG 생성
          SET @v_message   = 'WPP / MPP (NEW) : ' + convert(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, @v_log_code, @v_message, null

        END

        IF CHARINDEX('PACK', @v_master_id) > 0 OR (CHARINDEX('LINK',@v_master_id) > 0)  -- 2026/06/08 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. Pack 공정군 로직에 LINK 공정군 추가  
        BEGIN
        
          SET @v_table_name = 'FP_AMEND_PLAN_PACK_R'

          UPDATE A 
          SET    A.WPP_IN_QTY         = ISNULL(B.WPP_IN_QTY,        0)
               , A.WPP_OUT_QTY        = ISNULL(B.WPP_OUT_QTY,       0)
               , A.WPP_CELL_IN_QTY    = ISNULL(B.WPP_CELL_IN_QTY,   0)
               , A.WPP_CELL_OUT_QTY   = ISNULL(B.WPP_CELL_OUT_QTY,  0)
               , A.MPP_IN_QTY         = ISNULL(B.MPP_IN_QTY,        0)
               , A.MPP_OUT_QTY        = ISNULL(B.MPP_OUT_QTY,       0)
               , A.MPP_CELL_IN_QTY    = ISNULL(B.MPP_CELL_IN_QTY,   0)
               , A.MPP_CELL_OUT_QTY   = ISNULL(B.MPP_CELL_OUT_QTY,  0)
          FROM   FP_AMEND_PLAN_PACK_R A 
                 LEFT OUTER JOIN TH_BUF_AMEND_PLAN_WPPMPP_DATA  B
                      ON    1=1
                      AND   A.INSTANCE_ID     = B.INSTANCE_ID
                      AND   A.FP_PLAN_ID      = B.FP_PLAN_ID
                      AND   A.ITEM_ID         = B.ITEM_ID
                      AND   A.OPERATION_ID    = B.OPERATION_ID
                      AND   A.FACTORY_ID      = B.FACTORY_ID
                      AND   A.LOCATION        = B.LOCATION
                      AND   A.PRODUCTION_TYPE = B.PRODUCTION_TYPE
                      AND   A.MARKET          = B.MARKET
                      AND   A.LINE_ID         = B.LINE_ID
                      AND   A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE
                      AND   A.PLAN_DATE       = B.PLAN_DATE
                      AND   A.TOP_ITEM_ID     = B.TOP_ITEM_ID
                      AND   A.VERSION         = B.VERSION		 -- (D20240509~R0509.01)  
                      AND   A.PLM_EC_NO       = B.PLM_EC_NO		 -- (D20240509~R0509.01)  
          WHERE  A.INSTANCE_ID  = @v_master_id
          AND    A.FP_PLAN_ID   = @v_plan_id

          --LOG 생성
          SET @v_message   = 'WPP / MPP : ' + convert(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, @v_log_code, @v_message, null

          -- LINE 에 존재하지 않는 WPP / MPP 데이터는 0 으로 설정
          INSERT INTO FP_AMEND_PLAN_PACK_R
               (
                 INSTANCE_ID
               , FP_PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , CATEGORY_ID
               , SITE_ID
               , PLANT_ID
               , ITEM_ID
               , OPERATION_ID
               , FACTORY_ID
               , LOCATION
               , PRODUCTION_TYPE
               , MARKET
               , LINE_ID
               , ELECTRODE_TYPE
               , PLAN_DATE
               , TOP_ITEM_ID
               , ITEM_TYPE
               , IN_QTY
               , OUT_QTY
               , CELL_IN_QTY
               , CELL_OUT_QTY
               , DATE_SEQ
               , ORG_IN_QTY
               , ORG_OUT_QTY
               , ORG_CELL_IN_QTY
               , ORG_CELL_OUT_QTY
               , INSERT_ID
               , INSERT_TIME
               , UPDATE_ID
               , UPDATE_TIME
               , SETUP_COLOR_CODE
               , RESULT_IN_QTY
               , RESULT_OUT_QTY
               , RESULT_CELL_IN_QTY
               , RESULT_CELL_OUT_QTY
               , WPP_IN_QTY
               , WPP_OUT_QTY
               , WPP_CELL_IN_QTY
               , WPP_CELL_OUT_QTY
               , MPP_IN_QTY
               , MPP_OUT_QTY
               , MPP_CELL_IN_QTY
               , MPP_CELL_OUT_QTY
               , VERSION		 -- (D20240509~R0509.01)  
               , PLM_EC_NO		 -- (D20240509~R0509.01)  
               )
          SELECT
                 A.INSTANCE_ID
               , A.FP_PLAN_ID
               , A.COMPANY_ID
               , A.DIVISION_ID
               , A.CATEGORY_ID
               , A.SITE_ID
               , A.PLANT_ID
               , A.ITEM_ID
               , A.OPERATION_ID
               , A.FACTORY_ID
               , A.LOCATION
               , A.PRODUCTION_TYPE
               , A.MARKET
               , A.LINE_ID
               , A.ELECTRODE_TYPE
               , A.PLAN_DATE
               , A.TOP_ITEM_ID
               , ISNULL(A.ITEM_TYPE, '-') AS ITEM_TYPE
               , 0                AS IN_QTY
               , 0                AS OUT_QTY
               , 0                AS CELL_IN_QTY
               , 0                AS CELL_OUT_QTY
               , 1                AS DATE_SEQ
               , 0                AS ORG_IN_QTY
               , 0                AS ORG_OUT_QTY
               , 0                AS ORG_CELL_IN_QTY
               , 0                AS ORG_CELL_OUT_QTY
               , A.INSERT_ID
               , A.INSERT_TIME
               , A.UPDATE_ID
               , A.UPDATE_TIME
               , NULL             AS SETUP_COLOR_CODE
               , 0                AS RESULT_IN_QTY
               , 0                AS RESULT_OUT_QTY
               , 0                AS RESULT_CELL_IN_QTY
               , 0                AS RESULT_CELL_OUT_QTY
               , 0                AS WPP_IN_QTY
               , 0                AS WPP_OUT_QTY
               , 0                AS WPP_CELL_IN_QTY
               , 0                AS WPP_CELL_OUT_QTY
               , 0                AS MPP_IN_QTY
               , 0                AS MPP_OUT_QTY
               , 0                AS MPP_CELL_IN_QTY
               , 0                AS MPP_CELL_OUT_QTY
               , A.VERSION		 -- (D20240509~R0509.01)  
               , A.PLM_EC_NO	 -- (D20240509~R0509.01)  
          FROM   TH_BUF_AMEND_PLAN_WPPMPP_DATA A
          WHERE  A.INSTANCE_ID  = @v_master_id
          AND    A.FP_PLAN_ID   = @v_plan_id
          AND    NOT EXISTS (
                              SELECT 1
                              FROM   SCM_LINE_M X WITH(NOLOCK)
                              WHERE  X.COMPANY_ID     = A.COMPANY_ID
                              AND    X.DIVISION_ID    = A.DIVISION_ID
                              AND    X.SITE_ID        = A.SITE_ID
                              AND    X.PLANT_ID       = A.PLANT_ID
                              AND    X.FACTORY_ID     = A.FACTORY_ID
                              AND    X.LINE_ID        = A.LINE_ID
                              AND    X.OPERATION_ID   = A.OPERATION_ID
                              AND    X.ELECTRODE_TYPE = A.ELECTRODE_TYPE
                            )

          --LOG 생성
          SET @v_message   = 'WPP / MPP (DEL) : ' + convert(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, @v_log_code, @v_message, null


          INSERT INTO FP_AMEND_PLAN_PACK_R
               (
                 INSTANCE_ID
               , FP_PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , CATEGORY_ID
               , SITE_ID
               , PLANT_ID
               , ITEM_ID
               , OPERATION_ID
               , FACTORY_ID
               , LOCATION
               , PRODUCTION_TYPE
               , MARKET
               , LINE_ID
               , ELECTRODE_TYPE
               , PLAN_DATE
               , TOP_ITEM_ID
               , ITEM_TYPE
               , IN_QTY
               , OUT_QTY
               , CELL_IN_QTY
               , CELL_OUT_QTY
               , DATE_SEQ
               , ORG_IN_QTY
               , ORG_OUT_QTY
               , ORG_CELL_IN_QTY
               , ORG_CELL_OUT_QTY
               , INSERT_ID
               , INSERT_TIME
               , UPDATE_ID
               , UPDATE_TIME
               , SETUP_COLOR_CODE
               , RESULT_IN_QTY
               , RESULT_OUT_QTY
               , RESULT_CELL_IN_QTY
               , RESULT_CELL_OUT_QTY
               , WPP_IN_QTY
               , WPP_OUT_QTY
               , WPP_CELL_IN_QTY
               , WPP_CELL_OUT_QTY
               , MPP_IN_QTY
               , MPP_OUT_QTY
               , MPP_CELL_IN_QTY
               , MPP_CELL_OUT_QTY
               , VERSION		 -- (D20240509~R0509.01)  
               , PLM_EC_NO		 -- (D20240509~R0509.01)  
               )
          SELECT
                 A.INSTANCE_ID
               , A.FP_PLAN_ID
               , A.COMPANY_ID
               , A.DIVISION_ID
               , A.CATEGORY_ID
               , A.SITE_ID
               , A.PLANT_ID
               , A.ITEM_ID
               , A.OPERATION_ID
               , A.FACTORY_ID
               , A.LOCATION
               , A.PRODUCTION_TYPE
               , A.MARKET
               , A.LINE_ID
               , A.ELECTRODE_TYPE
               , A.PLAN_DATE
               , A.TOP_ITEM_ID
               , ISNULL(A.ITEM_TYPE, '-') AS ITEM_TYPE
               , 0                AS IN_QTY
               , 0                AS OUT_QTY
               , 0                AS CELL_IN_QTY
               , 0                AS CELL_OUT_QTY
               , 1                AS DATE_SEQ
               , 0                AS ORG_IN_QTY
               , 0                AS ORG_OUT_QTY
               , 0                AS ORG_CELL_IN_QTY
               , 0                AS ORG_CELL_OUT_QTY
               , A.INSERT_ID
               , A.INSERT_TIME
               , A.UPDATE_ID
               , A.UPDATE_TIME
               , NULL             AS SETUP_COLOR_CODE
               , 0                AS RESULT_IN_QTY
               , 0                AS RESULT_OUT_QTY
               , 0                AS RESULT_CELL_IN_QTY
               , 0                AS RESULT_CELL_OUT_QTY
               , A.WPP_IN_QTY
               , A.WPP_OUT_QTY
               , A.WPP_CELL_IN_QTY
               , A.WPP_CELL_OUT_QTY
               , A.MPP_IN_QTY
               , A.MPP_OUT_QTY
               , A.MPP_CELL_IN_QTY
               , A.MPP_CELL_OUT_QTY
               , A.VERSION		 -- (D20240509~R0509.01)  
               , A.PLM_EC_NO	 -- (D20240509~R0509.01)  
          FROM   TH_BUF_AMEND_PLAN_WPPMPP_DATA A
          WHERE  A.INSTANCE_ID  = @v_master_id
          AND    A.FP_PLAN_ID   = @v_plan_id
          AND    NOT EXISTS (
                              SELECT 1
                              FROM   FP_AMEND_PLAN_PACK_R X
                              WHERE  1=1  
                              AND    X.INSTANCE_ID      = A.INSTANCE_ID
                              AND    X.FP_PLAN_ID       = A.FP_PLAN_ID
                              AND    X.ITEM_ID          = A.ITEM_ID
                              AND    X.OPERATION_ID     = A.OPERATION_ID
                              AND    X.FACTORY_ID       = A.FACTORY_ID
                              AND    X.LOCATION         = A.LOCATION
                              AND    X.PRODUCTION_TYPE  = A.PRODUCTION_TYPE
                              AND    X.MARKET           = A.MARKET
                              AND    X.LINE_ID          = A.LINE_ID
                              AND    X.ELECTRODE_TYPE   = A.ELECTRODE_TYPE
                              AND    X.PLAN_DATE        = A.PLAN_DATE
                              AND    X.TOP_ITEM_ID      = A.TOP_ITEM_ID
                              AND    X.VERSION      	= A.VERSION		 -- (D20240509~R0509.01)  
                              AND    X.PLM_EC_NO      	= A.PLM_EC_NO	 -- (D20240509~R0509.01)  
                            )

          --LOG 생성
          SET @v_message   = 'WPP / MPP (NEW) : ' + convert(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, @v_log_code, @v_message, null

        END

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