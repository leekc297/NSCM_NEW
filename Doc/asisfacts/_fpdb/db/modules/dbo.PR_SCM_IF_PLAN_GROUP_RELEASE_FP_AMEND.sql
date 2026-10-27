CREATE PROCEDURE [dbo].[PR_SCM_IF_PLAN_GROUP_RELEASE_FP_AMEND]
@p_instance_id nvarchar(MAX) = '-', @p_plan_date nvarchar(MAX) = '-', @p_release_id nvarchar(MAX) = '-', @p_plan_group_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_PLAN_GROUP_RELEASE_FP_AMEND                                     **/
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
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_PLAN_GROUP_RELEASE_FP_AMEND
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_plan_date      nvarchar(30)
  DECLARE @v_release_id     nvarchar(30)
  DECLARE @v_plan_group_id  nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_PLAN_GROUP_RELEASE_FP_AMEND'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  DECLARE @n_cnt            Integer  = 0
  DECLARE @v_confirm_date   date
  DECLARE @v_order_date_code nvarchar(10)
  DECLARE @v_amend_plan_id  nvarchar (100)
  DECLARE @v_fix_count      Int
  DECLARE @v_release_term   Int
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @v_insert_dttm    date

  DECLARE @v_lgc_site           nvarchar(10)

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  DECLARE @v_release_term_limit_flag nvarchar(5)   = 'N'	
  DECLARE @v_release_term_limit_date date	

  SET @v_master_id      = @p_instance_id
  SET @v_plan_id        = @p_instance_id + '-' + @p_plan_date + '-99'
  SET @v_plan_date      = @p_plan_date
  SET @v_release_id     = @p_release_id
  SET @v_plan_group_id  = @p_plan_group_id
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY

    SET @v_table_name = 'SCM_FP_PLAN_H'

    --LOG 생성
    SET @v_message = 'PLAN_GROUP_ID : ' + ISNULL(@v_plan_group_id, '') 
    SET @n_log_count = @n_log_count + 1
    SET @sysdate = GETDATE()
    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    BEGIN

      SELECT @v_lgc_site = ISNULL(MAX(B.SITE_ID), 'A001' )
      FROM   FP_INSTANCE_FACTORY_M  A
           , SCM_FACTORY_M          B
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FACTORY_ID   = B.FACTORY_ID
      AND    A.ACTIVE_FLAG  = 'Y'
      AND    B.ACTIVE_FLAG  = 'Y'
    
      --LOG 생성
      SET @v_message = '@v_lgc_site : ' + @v_lgc_site
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END

    BEGIN
      SELECT @v_plan_id = CASE WHEN PLAN_ID = 'EMPTY' THEN @v_master_id + '-' + @v_plan_date + '-99'
             ELSE @v_master_id + '-' + @v_plan_date + '-'
                + REPLICATE ('0',2-LEN((CONVERT(NUMERIC, RIGHT((A.PLAN_ID), 2))-1))) + CAST ( (CONVERT(NUMERIC, RIGHT((A.PLAN_ID), 2))-1) AS nvarchar ) 
             END
      FROM (
        SELECT ISNULL(MIN(PLAN_ID), 'EMPTY') AS PLAN_ID
        FROM   SCM_FP_PLAN_H A
        WHERE  1=1
        AND    A.INSTANCE_ID = @v_master_id
        AND    A.PLAN_TYPE = 'RELEASE'
        AND    CONVERT(nvarchar(8), A.PLAN_START_TIME, 112) = @v_plan_date
      ) A
      
      SET @n_cnt = 0
      
      SELECT  @n_cnt = COUNT(1)
      FROM    SCM_FP_PLAN_H
      WHERE   INSTANCE_ID   = @v_master_id
      AND     PLAN_ID    = @v_plan_id

      IF @n_cnt = 0
      BEGIN
      
        SET @v_table_name = 'SCM_FP_PLAN_H'
        
        INSERT INTO SCM_FP_PLAN_H
            (
                INSTANCE_ID
              , PLAN_ID
              , PLAN_TYPE
              , SITE_ID
              , PLAN_START_TIME
              , PLAN_HORIZON
              , PLAN_HORIZON_UOM
              , DEMAND_HORIZON
              , DEMAND_HORIZON_UOM
              , CONFIG_SET_ID
              , BASIS_PLAN_ID
              , DEMAND_PLAN_ID
              , SCP_PLAN_ID
              , PLAN_WEEK
              , DESCRIPTION
              , INSERT_ID
              , INSERT_TIME
              , UPDATE_ID
              , UPDATE_TIME
            )
        SELECT 
                INSTANCE_ID
              , @v_plan_id                    AS PLAN_ID
              , 'RELEASE'                     AS PLAN_TYPE
              , MAX(SITE_ID)                  AS SITE_ID
              , MAX(PLAN_START_TIME)          AS PLAN_START_TIME
              , MAX(PLAN_HORIZON)             AS PLAN_HORIZON
              , MAX(PLAN_HORIZON_UOM)         AS PLAN_HORIZON_UOM
              , MAX(DEMAND_HORIZON)           AS DEMAND_HORIZON
              , MAX(DEMAND_HORIZON_UOM)       AS DEMAND_HORIZON_UOM
              , MAX(CONFIG_SET_ID)            AS CONFIG_SET_ID
              , MAX(PLAN_ID)                  AS BASIS_PLAN_ID      -- 2018.07.25 : AMEND 된 PLAN_ID 설정
              , MAX(DEMAND_PLAN_ID)           AS DEMAND_PLAN_ID
              , MAX(SCP_PLAN_ID)              AS SCP_PLAN_ID
              , MAX(PLAN_WEEK)                AS PLAN_WEEK
              , MAX(DESCRIPTION)              AS DESCRIPTION        -- 2018.08.21 : DESCRIPTION 정보 추가요청 처리
              --, MAX(INSERT_ID)                AS INSERT_ID
              , @p_release_id                AS INSERT_ID
              , dbo.FN_SITE_TIME(@v_lgc_site) AS INSERT_TIME
              --, MAX(UPDATE_ID)                AS UPDATE_ID
              , @p_release_id                AS UPDATE_ID
              , dbo.FN_SITE_TIME(@v_lgc_site) AS UPDATE_TIME
        FROM    SCM_FP_PLAN_H A
        WHERE   INSTANCE_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    SCM_FP_PLAN_GROUP_DETAIL_H B 
                        WHERE   B.INSTANCE_ID=A.INSTANCE_ID 
                        --AND     B.DIVISION_ID=A.DIVISION_ID 
                        --AND     CASE WHEN B.FACTORY_ID='-' THEN A.FACTORY_ID ELSE B.FACTORY_ID END=A.FACTORY_ID 
                        AND     B.PLAN_ID=A.PLAN_ID 
                        AND     B.PLAN_DATE= @v_plan_date
                        AND     B.PLAN_GROUP_ID = @v_plan_group_id
                       )
        GROUP  BY INSTANCE_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
      
        SET @v_table_name = 'SCM_FP_PLAN_H'
        
        UPDATE SCM_FP_PLAN_H SET
               CONFIRM_ID   = @v_release_id
              ,CONFIRM_TIME = dbo.FN_SITE_TIME(@v_lgc_site)
              ,CONFIRM_FLAG = 'Y'
              ,RELEASE_ID   = @v_release_id
              ,RELEASE_TIME = dbo.FN_SITE_TIME(@v_lgc_site)
              ,RELEASE_FLAG = 'P'
        WHERE  INSTANCE_ID  = @v_master_id
        AND    PLAN_ID      = @v_plan_id
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
        SET @v_table_name = 'SCM_FP_PLAN_GROUP_DETAIL_H'

        UPDATE SCM_FP_PLAN_GROUP_DETAIL_H SET
               RELEASE_TIME     = dbo.FN_SITE_TIME(@v_lgc_site)
              ,RELEASE_FLAG     = 'P'
              ,RELEASE_PLAN_ID  = @v_plan_id
        WHERE  INSTANCE_ID      = @v_master_id
        AND    PLAN_DATE        = @v_plan_date
        AND    PLAN_GROUP_ID    = @v_plan_group_id
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
      END
      
    END

    BEGIN

      BEGIN

        SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'
        
        -- DEFAULT 값
        SET @v_release_term = 7
        
        SELECT @v_release_term = ISNULL(MAX(CONVERT(INT, SEGMENT3)), 7)
			   ,@v_release_term_limit_flag = ISNULL(MAX(ATTRIBUTE7), 'N')	
      		   ,@v_release_term_limit_date = CONVERT(DATE,ISNULL(MAX(ATTRIBUTE8), '29990101'))
        FROM   SCM_SYS_LOOKUP_VALUE
        WHERE  LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
        AND    SEGMENT1 = @v_master_id        -- INSTANCE_ID
        AND    SEGMENT2 = @v_plan_group_id    -- PLAN_GROUP_ID
        AND    SEGMENT4 = 'DAY'

        --LOG 생성
        SET @v_message = '@v_release_term : ' + convert(nvarchar, @v_release_term, 23)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

        
        SET @v_table_name = 'SCM_FP_PLAN_H'
        
        SELECT @v_confirm_date = DATEADD(DAY, @v_release_term, CONVERT(DATE, A.PLAN_START_TIME))
        FROM   SCM_FP_PLAN_H A
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.PLAN_ID      = @v_plan_id

        --LOG 생성
        SET @v_message = '@v_confirm_date : ' + convert(nvarchar, @v_confirm_date, 23)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

		-- ### 특정 일자까지만 릴리즈 제한하기 위해 추가함 START release term 구간 내에서 제한. by cys 20241210 
		IF  @v_release_term_limit_flag = 'Y'
		BEGIN
			IF CONVERT(nvarchar,@v_confirm_date,112) > CONVERT(nvarchar,@v_release_term_limit_date,112) 
	    		AND CONVERT(nvarchar,@v_plan_date,112) < CONVERT(nvarchar,@v_release_term_limit_date,112)
			BEGIN
				SET @v_confirm_date = @v_release_term_limit_date
			END 
		END
    
		--LOG 생성
		SET @v_message = '@v_confirm_date NEW : ' + convert(nvarchar, @v_confirm_date, 23)
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
		-- ### 특정 일자까지만 릴리즈 제한하기 위해 추가함 END 


        SELECT  @v_order_date_code = SUBSTRING(PLAN_DATE, 3, 2)
                                      + CASE SUBSTRING(PLAN_DATE, 5, 2)
                                            WHEN '10' THEN 'A'
                                            WHEN '11' THEN 'B'
                                            WHEN '12' THEN 'C'
                                            ELSE SUBSTRING(PLAN_DATE, 6, 1)
                                        END
                                      + SUBSTRING(PLAN_DATE, 7, 2)
        FROM   (    
                SELECT CONVERT(NVARCHAR, PLAN_START_TIME, 112) AS PLAN_DATE                                  
                FROM   SCM_FP_PLAN_H  AS a
                WHERE  a.INSTANCE_ID = @v_master_id
                AND    a.PLAN_ID     = @v_plan_id
               ) A               
               
        --LOG 생성
        SET @v_message = '@v_order_date_code : ' + @v_order_date_code
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      END

      -- FACTORY 별로 DIVISION 이 다를 수 있을거 같아서 보완처리
      BEGIN
      
        SELECT @v_amend_plan_id = min(plan_id)
        FROM   SCM_FP_PLAN_GROUP_DETAIL_H
        WHERE  INSTANCE_ID = @v_master_id
        AND    PLAN_DATE = @v_plan_date
        AND    PLAN_GROUP_ID = @v_plan_group_id
      
        -- 동 변경시 DIVISION_ID, PLANT_ID 를 해당 동에 맞게 변경
        UPDATE FP_DAILY_PRODUCTION_PLAN_R
        SET    FP_DAILY_PRODUCTION_PLAN_R.COMPANY_ID  = B.COMPANY_ID
             , FP_DAILY_PRODUCTION_PLAN_R.DIVISION_ID = B.DIVISION_ID
             , FP_DAILY_PRODUCTION_PLAN_R.SITE_ID     = B.SITE_ID
             , FP_DAILY_PRODUCTION_PLAN_R.PLANT_ID    = B.PLANT_ID
        FROM   FP_DAILY_PRODUCTION_PLAN_R A,
               SCM_FACTORY_M B
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_amend_plan_id
        AND    A.FACTORY_ID   = B.FACTORY_ID
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )


        UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
        SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.COMPANY_ID  = B.COMPANY_ID
             , FP_PRODUCTION_PLAN_EQUIPMENT_R.DIVISION_ID = B.DIVISION_ID
             , FP_PRODUCTION_PLAN_EQUIPMENT_R.SITE_ID     = B.SITE_ID
             , FP_PRODUCTION_PLAN_EQUIPMENT_R.PLANT_ID    = B.PLANT_ID
        FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
               SCM_FACTORY_M B
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_amend_plan_id
        AND    A.FACTORY_ID   = B.FACTORY_ID
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )


        UPDATE FP_PRODUCTION_PLAN_R
        SET    FP_PRODUCTION_PLAN_R.COMPANY_ID  = B.COMPANY_ID
             , FP_PRODUCTION_PLAN_R.DIVISION_ID = B.DIVISION_ID
             , FP_PRODUCTION_PLAN_R.SITE_ID     = B.SITE_ID
             , FP_PRODUCTION_PLAN_R.PLANT_ID    = B.PLANT_ID
        FROM   FP_PRODUCTION_PLAN_R A,
               SCM_FACTORY_M B
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_amend_plan_id
        AND    A.FACTORY_ID   = B.FACTORY_ID
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )
        
        UPDATE FP_MOVE_PLAN_R
        SET    FP_MOVE_PLAN_R.COMPANY_ID  = B.COMPANY_ID
             , FP_MOVE_PLAN_R.DIVISION_ID = B.DIVISION_ID
             , FP_MOVE_PLAN_R.SITE_ID     = B.SITE_ID
             , FP_MOVE_PLAN_R.PLANT_ID    = B.PLANT_ID
        FROM   FP_MOVE_PLAN_R A,
               SCM_FACTORY_M B
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_amend_plan_id
        AND    A.FACTORY_ID   = B.FACTORY_ID
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )

        UPDATE FP_ORDER_TRACKING_R
        SET    FP_ORDER_TRACKING_R.COMPANY_ID  = B.COMPANY_ID
             , FP_ORDER_TRACKING_R.DIVISION_ID = B.DIVISION_ID
             , FP_ORDER_TRACKING_R.SITE_ID     = B.SITE_ID
             , FP_ORDER_TRACKING_R.PLANT_ID    = B.PLANT_ID
        FROM   FP_ORDER_TRACKING_R A,
               SCM_FACTORY_M B
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_amend_plan_id
        AND    A.FACTORY_ID   = B.FACTORY_ID
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )

        UPDATE FP_PLAN_UTILIZATION_R
        SET    FP_PLAN_UTILIZATION_R.COMPANY_ID  = B.COMPANY_ID
             , FP_PLAN_UTILIZATION_R.DIVISION_ID = B.DIVISION_ID
             , FP_PLAN_UTILIZATION_R.SITE_ID     = B.SITE_ID
             , FP_PLAN_UTILIZATION_R.PLANT_ID    = B.PLANT_ID
        FROM   FP_PLAN_UTILIZATION_R A,
               SCM_FACTORY_M B
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_amend_plan_id
        AND    A.FACTORY_ID   = B.FACTORY_ID
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )

      END

      BEGIN
      
        SET @v_fix_count = 0

        SELECT @v_fix_count = COUNT(1)
        FROM   (
                SELECT TOP 1 
                       A.WORK_ORDER_ID
                FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A
                WHERE  A.INSTANCE_ID  = @v_master_id
                AND    A.FP_PLAN_ID   = @v_amend_plan_id
                AND    A.FIX_TYPE     = 'F'
                AND    EXISTS (
                                SELECT 1
                                FROM   SCM_LINE_M X
                                WHERE  X.ACTIVE_FLAG  = 'Y'
                                AND    X.FACTORY_ID   = A.FACTORY_ID
                                AND    X.LINE_ID      = A.LINE_ID
                                AND    X.OPERATION_ID = A.OPERATION_ID
                                AND    X.MODEL_TYPE   = @v_plan_group_id
                              )
                UNION  ALL
                SELECT TOP 1 
                       A.WORK_ORDER_ID
                FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
      FP_INSTANCE_CONFIG_M           B
                WHERE  A.INSTANCE_ID  = @v_master_id
                AND    A.FP_PLAN_ID   = @v_amend_plan_id
                AND    A.INSTANCE_ID  = B.INSTANCE_ID
                AND    B.CATEGORY_ID  = 'EXPORT' 
                AND    B.KEY_ID       = 'INSTANCE_CODE'
                AND    A.WORK_ORDER_ID LIKE B.KEY_VALUE +'%'
                AND    EXISTS (
                                SELECT 1
                                FROM   SCM_LINE_M X
                                WHERE  X.ACTIVE_FLAG  = 'Y'
                                AND    X.FACTORY_ID   = A.FACTORY_ID
                                AND    X.LINE_ID      = A.LINE_ID
                                AND    X.OPERATION_ID = A.OPERATION_ID
                                AND    X.MODEL_TYPE   = @v_plan_group_id
                              )
               ) A
               
        /*
        SELECT @v_fix_count = COUNT(1)
        FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R 
        WHERE  INSTANCE_ID  = @v_master_id
        AND    FP_PLAN_ID   = @v_amend_plan_id
        AND    FACTORY_ID   = @v_factory_id
        AND    FIX_TYPE     = 'F'
        */

        SET @v_table_name = 'FP_DAILY_PLAN_ORDER_R'

        DELETE FROM FP_DAILY_PLAN_ORDER_R
        WHERE  INSTANCE_ID = @v_master_id
        AND    FP_PLAN_ID = @v_plan_id
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        INSERT INTO FP_DAILY_PLAN_ORDER_R
             (
               INSTANCE_ID
             , FP_PLAN_ID
             , WORK_ORDER_SPL_ID
             , WORK_ORDER_ID
             , NEW_ORDER_ID
             , ERP_OPERATION_ID
             , ORDER_SEQ
             , DEMAND_ID
             , INSERT_ID
             , INSERT_TIME
             )
        SELECT DISTINCT
               A.INSTANCE_ID
             , @v_plan_id AS FP_PLAN_ID
             , A.WORK_ORDER_SPL_ID
             , A.WORK_ORDER_ID
             -- 확정 계획 첫번째꺼는 그걸 유지하고, 아니면 신규로 채번한다.
             , CASE WHEN @v_fix_count > 0 OR @v_master_id = 'CN_E_PRE' OR @v_master_id = 'CN_E_POST' THEN
                           CASE WHEN A.FIX_TYPE = 'F' AND A.SEQ_SPLIT = 1 THEN A.ORG_WORK_ORDER_ID
                                WHEN A.FIX_TYPE = 'F' AND A.SEQ_SPLIT > 1 THEN A.NEW_PLAN_ORDER_ID
                                WHEN A.FIX_TYPE = 'N'                     THEN A.NEW_PLAN_ORDER_ID
                                ELSE ( CASE WHEN A.WO_HEAD = '-' THEN 'W' ELSE A.WO_HEAD END) + A.NEW_PLAN_ORDER_ID
                           END  
                    ELSE
                           --CASE WHEN A.FIX_TYPE = 'F'  THEN SUBSTRING(A.ORG_WORK_ORDER_ID, 1, 12)
                           --     WHEN A.FIX_TYPE = 'N'  THEN SUBSTRING(A.ORG_WORK_ORDER_ID, 2, 9)  + ORDER_ID
                           --     ELSE SUBSTRING(A.ORG_WORK_ORDER_ID, 1, 10) + ORDER_ID
                           --END
                           CASE WHEN A.FIX_TYPE = 'F'  AND A.SEQ_SPLIT = 1 THEN SUBSTRING(A.ORG_WORK_ORDER_ID, 1, 12)
                                WHEN A.FIX_TYPE = 'F'  AND A.SEQ_SPLIT > 1 THEN SUBSTRING(A.ORG_WORK_ORDER_ID, 2, 9)  + ORDER_ID
                                WHEN A.FIX_TYPE = 'N'  THEN SUBSTRING(A.ORG_WORK_ORDER_ID, 2, 9)  + ORDER_ID
                                ELSE SUBSTRING(A.ORG_WORK_ORDER_ID, 1, 10) + ORDER_ID
                           END
               END  AS NEW_ORDER_ID
             , A.ERP_OPERATION_ID
             , A.SEQ
             , A.DEMAND_ID
             , @v_proc_name AS INSERT_ID
             , GETDATE()    AS INSERT_TIME
        FROM   (
                SELECT A.INSTANCE_ID
                     , A.WORK_ORDER_SPL_ID
                     , A.WORK_ORDER_ID
                     , CASE WHEN A.INSTANCE_CODE = '-' THEN 'W'
                            ELSE A.INSTANCE_CODE
                       END
                           + @v_order_date_code
                           + ERP_OPERATION_ID
                           + ORDER_ID
                         AS NEW_PLAN_ORDER_ID
                     , A.DEMAND_ID
                     , A.INSTANCE_CODE
                     , A.WO_HEAD
                     , A.ERP_OPERATION_ID
                     , A.SEQ
                     , A.ORG_WORK_ORDER_ID
                     , A.FIX_TYPE
                     , A.SEQ_SPLIT
                     , ORDER_ID
                FROM   (
                        SELECT A.INSTANCE_ID
                             , A.WORK_ORDER_SPL_ID
                             , A.WORK_ORDER_ID
                             , A.DEMAND_ID
                             , A.PRODUCTION_TYPE
                             , A.ERP_OPERATION_ID
                             , A.INSTANCE_CODE
                             , A.WO_HEAD
                             , A.ORG_WORK_ORDER_ID
                             , A.FIX_TYPE
                             , COUNT(1) OVER (PARTITION BY A.ERP_OPERATION_ID  ORDER BY A.WORK_ORDER_SPL_ID) + ISNULL(B.MAX_ORDER_SEQ, 0) SEQ
                             , COUNT(1) OVER (PARTITION BY A.ORG_WORK_ORDER_ID ORDER BY A.WORK_ORDER_SPL_ID) SEQ_SPLIT
                        FROM   (
                                SELECT DISTINCT
                                       A.INSTANCE_ID
                                     , A.SITE_ID
                                     , A.WORK_ORDER_SPL_ID
                                     , A.WORK_ORDER_ID
                                     , A.DEMAND_ID
                                     , A.PRODUCTION_TYPE
                                     , A.ERP_OPERATION_ID
                                     , A.INSTANCE_CODE
                                     , A.WO_HEAD
                                     -- 전극 ROLLING 할때 @ 가 1차로 먼저 붙고, 
                                     -- AMEND 할때 # 이 2차로 붙음.. 순서 지킬것...
                                     , CASE WHEN CHARINDEX('@', A.ORG_WORK_ORDER_ID) > 0 THEN SUBSTRING(A.ORG_WORK_ORDER_ID, 1, CHARINDEX('@',A.ORG_WORK_ORDER_ID)-1)
                                            WHEN CHARINDEX('#', A.ORG_WORK_ORDER_ID) > 0 THEN SUBSTRING(A.ORG_WORK_ORDER_ID, 1, CHARINDEX('#',A.ORG_WORK_ORDER_ID)-1)
                                            ELSE A.ORG_WORK_ORDER_ID
                                       END  ORG_WORK_ORDER_ID
                                     --, A.ORG_WORK_ORDER_ID
                                     , CASE WHEN A.FIX_TYPE = 'F'         THEN 'F'      -- 확정은 그대로
                                            ELSE A.FIX_TYPE                             -- 그 이외에는 아래꺼
                                       END  AS FIX_TYPE
                                FROM   (
                                        SELECT A.INSTANCE_ID
                                             , A.SITE_ID
                                             , A.WORK_ORDER_SPL_ID
                                             , A.WORK_ORDER_ID
                                             , A.DEMAND_ID
                                             , A.PRODUCTION_TYPE
                                             , C.ERP_OPERATION_ID
                                             , B.KEY_VALUE AS INSTANCE_CODE
                                             , SUBSTRING(A.WORK_ORDER_SPL_ID, 1, 1) WO_HEAD
                                             , SUBSTRING(A.WORK_ORDER_SPL_ID, 1, 13) AS ORG_WORK_ORDER_ID
                                             --, CASE WHEN CHARINDEX(A.WORK_ORDER_SPL_ID, '_') = 0 THEN A.WORK_ORDER_SPL_ID
                                             --       ELSE SUBSTRING(A.WORK_ORDER_SPL_ID, 1, CHARINDEX(A.WORK_ORDER_SPL_ID, '_')-1)
                                             --  END  ORG_WORK_ORDER_ID
                                             , CASE WHEN FIX_TYPE = 'F'               THEN 'F'
                                                    WHEN PLAN_DATE > @v_confirm_date  THEN 'P'
                                                    ELSE 'N'
                                               END  AS FIX_TYPE                                           
                                        FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A
                                             , FP_INSTANCE_CONFIG_M B
                                             , SCM_OPERATION_M C
                                        WHERE  A.INSTANCE_ID = @v_master_id
                                        AND     EXISTS (  
                                                        SELECT  1 
                                                        FROM    (
                                                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                                                         SCM_LINE_M                 B
                                                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                                                  AND    A.INSTANCE_ID    = @v_master_id
                                                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                                                ) X
                                                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                                                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                                                        AND     X.FACTORY_ID    = A.FACTORY_ID
                                                        AND     X.LINE_ID       = A.LINE_ID
                                                        AND     X.OPERATION_ID  = A.OPERATION_ID
                                                       )
                                        AND    A.INSTANCE_ID = B.INSTANCE_ID
                                        AND    B.CATEGORY_ID = 'EXPORT' 
                                        AND    B.KEY_ID = 'INSTANCE_CODE'
                                        AND    A.COMPANY_ID = C.COMPANY_ID
                                        AND    A.DIVISION_ID = C.DIVISION_ID
                                        AND    A.SITE_ID = C.SITE_ID
                                        AND    A.OPERATION_ID = C.OPERATION_ID
                                        UNION  ALL
                                        SELECT A.INSTANCE_ID
                                             , A.SITE_ID
                                             , A.WORK_ORDER_SPL_ID
                                             , A.WORK_ORDER_ID
                                             , A.DEMAND_ID
                                             , A.PRODUCTION_TYPE
                                             , C.ERP_OPERATION_ID
                                             , B.KEY_VALUE AS INSTANCE_CODE
                                             , SUBSTRING(A.WORK_ORDER_SPL_ID, 1, 1) WO_HEAD
                                             , SUBSTRING(A.WORK_ORDER_SPL_ID, 1, 13) AS ORG_WORK_ORDER_ID
                                             --, CASE WHEN CHARINDEX(A.WORK_ORDER_SPL_ID, '_') = 0 THEN A.WORK_ORDER_SPL_ID
                                             --       ELSE SUBSTRING(A.WORK_ORDER_SPL_ID, 1, CHARINDEX(A.WORK_ORDER_SPL_ID, '_')-1)
                --  END  ORG_WORK_ORDER_ID
                                             , CASE WHEN FIX_TYPE = 'F'               THEN 'F'
                                                    WHEN PLAN_DATE > @v_confirm_date  THEN 'P'
                                                    ELSE 'N'
                                               END  AS FIX_TYPE                                           
                                        FROM   FP_DAILY_PRODUCTION_PLAN_R A
                                             , FP_INSTANCE_CONFIG_M B
                                             , SCM_OPERATION_M C
                                        WHERE  A.INSTANCE_ID = @v_master_id
                                        AND     EXISTS (  
                                                        SELECT  1 
                                                        FROM    (
                                                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                                                         SCM_LINE_M                 B
                                                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                                                  AND    A.INSTANCE_ID    = @v_master_id
                                                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                                                ) X
                                                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                                                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                                                        AND     X.FACTORY_ID    = A.FACTORY_ID
                                                        AND     X.LINE_ID       = A.LINE_ID
                                                        AND     X.OPERATION_ID  = A.OPERATION_ID
                                                       )
                                        AND    A.INSTANCE_ID = B.INSTANCE_ID
                                        AND    B.CATEGORY_ID = 'EXPORT' 
                                        AND    B.KEY_ID = 'INSTANCE_CODE'
                                        AND    A.COMPANY_ID = C.COMPANY_ID
                                        AND    A.DIVISION_ID = C.DIVISION_ID
                                        AND    A.SITE_ID = C.SITE_ID
                                        AND    A.OPERATION_ID = C.OPERATION_ID                                        
                                        UNION  ALL
                                        SELECT A.INSTANCE_ID
                                             , A.SITE_ID
                                             , A.WORK_ORDER_SPL_ID
                                             , A.WORK_ORDER_ID
                                             , A.DEMAND_ID
                                             , ISNULL(B.PRODUCTION_TYPE, 'MASS') PRODUCTION_TYPE
                                             , A.ERP_OPERATION_ID
                                             , A.INSTANCE_CODE
                                             , SUBSTRING(A.WORK_ORDER_SPL_ID, 1, 1) WO_HEAD
                                             , SUBSTRING(A.WORK_ORDER_SPL_ID, 1, 13) AS ORG_WORK_ORDER_ID
                                             --, CASE WHEN CHARINDEX(A.WORK_ORDER_SPL_ID, '_') = 0 THEN A.WORK_ORDER_SPL_ID
                                             --       ELSE SUBSTRING(A.WORK_ORDER_SPL_ID, 1, CHARINDEX(A.WORK_ORDER_SPL_ID, '_')-1)
                                  --  END  ORG_WORK_ORDER_ID
                                             , A.FIX_TYPE 
                                        FROM   (
                                                SELECT A.INSTANCE_ID
                                                     , A.SITE_ID
                                                     , A.FP_PLAN_ID
                                                     , A.MOVE_ORDER_ID AS WORK_ORDER_SPL_ID
                                                     , A.MOVE_ORDER_ID AS WORK_ORDER_ID
                                                     , A.DEMAND_ID
                                                     , 'MASS' AS PRODUCTION_TYPE 
                                                     , C.ERP_OPERATION_ID
                                                     , B.KEY_VALUE AS INSTANCE_CODE
                                                     , CASE WHEN FIX_TYPE = 'F'               THEN 'F'
                                                            WHEN PLAN_DATE > @v_confirm_date  THEN 'P'
                                                            ELSE 'N'
                                                       END  AS FIX_TYPE                                           
                                                FROM   FP_MOVE_PLAN_R A,
                                                       FP_INSTANCE_CONFIG_M B,
                                                       SCM_OPERATION_M C
                                                WHERE  A.INSTANCE_ID = @v_master_id
                                                AND     EXISTS (  
                                                                SELECT  1 
                                                                FROM    (
                                                                          SELECT A.INSTANCE_ID, A.PLAN_ID
                                                                               , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                                                          FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                                                                 SCM_LINE_M                 B
                                                                          WHERE  A.PLAN_DATE      = @v_plan_date
                                                                          AND    A.INSTANCE_ID    = @v_master_id
                                                                          AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                                                          AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                                                        ) X
                                                                WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                                                                AND     X.PLAN_ID       = A.FP_PLAN_ID 
                                                                AND     X.FACTORY_ID    = A.FACTORY_ID
                                                                AND     X.LINE_ID       = A.LINE_ID
                                                                AND     X.OPERATION_ID  = A.OPERATION_ID
                                                               )
                                                AND    A.INSTANCE_ID = B.INSTANCE_ID
                                                AND    B.CATEGORY_ID = 'EXPORT' 
                                                AND    B.KEY_ID = 'INSTANCE_CODE'
                                                AND    A.COMPANY_ID = C.COMPANY_ID
                                                AND    A.DIVISION_ID = C.DIVISION_ID
                                                AND    A.SITE_ID = C.SITE_ID
                                                AND    A.OPERATION_ID = C.OPERATION_ID
                         ) A
                                               LEFT OUTER JOIN FP_DAILY_NET_DEMAND_H B
                                                    ON    A.INSTANCE_ID = B.INSTANCE_ID
                                                    AND   A.FP_PLAN_ID = B.DPP_PLAN_ID
                                                    AND   A.DEMAND_ID  = B.FP_DEMAND_ID
                                       ) A
                                WHERE  FIX_TYPE != 'P'
                               ) A
                               LEFT OUTER JOIN (-- 기존 발생된 ORDER SEQ 를 찾음.
                                                -- 2017.05.30 : INSTANCE 분리에 따라 INSTANCE_ID 를 빼고, SITE_ID 를 추가함
                                                SELECT A.SITE_ID, B.ERP_OPERATION_ID, MAX(B.MAX_ORDER_SEQ) AS MAX_ORDER_SEQ
                                                FROM   (
                                                        SELECT A.INSTANCE_ID, MAX(B.SITE_ID) AS SITE_ID
                                                        FROM   FP_INSTANCE_FACTORY_M  A
                                                             , SCM_FACTORY_M          B
                                                        WHERE  A.FACTORY_ID = B.FACTORY_ID
                                                        GROUP  BY A.INSTANCE_ID
                                                       ) A
                                                     , (
                                                        SELECT A.INSTANCE_ID, B.ERP_OPERATION_ID, MAX(B.ORDER_SEQ) AS MAX_ORDER_SEQ
                                                        FROM   SCM_FP_PLAN_H          A
                                                             , FP_DAILY_PLAN_ORDER_R  B
                                                        WHERE  A.PLAN_TYPE    = 'RELEASE'
                                                        AND    A.INSTANCE_ID  = B.INSTANCE_ID
                                                        AND    A.PLAN_ID      = B.FP_PLAN_ID
                                                        AND    CONVERT(nvarchar(8), A.PLAN_START_TIME, 112) = @v_plan_date
                                                        GROUP  BY A.INSTANCE_ID, B.ERP_OPERATION_ID
                                                       ) B
                                                WHERE  A.INSTANCE_ID = B.INSTANCE_ID
                                                GROUP  BY A.SITE_ID, B.ERP_OPERATION_ID
                                                /*
                                                SELECT A.SITE_ID, B.ERP_OPERATION_ID, MAX(B.ORDER_SEQ) AS MAX_ORDER_SEQ
                                                FROM   SCM_FP_PLAN_H A,
                                                       FP_DAILY_PLAN_ORDER_R B
                                                WHERE  1=1
                                                AND    A.PLAN_TYPE   = 'RELEASE'
                                                AND    CONVERT(nvarchar(8), A.PLAN_START_TIME, 112) = @v_plan_date
                                                AND    A.INSTANCE_ID = B.INSTANCE_ID
                                                AND    A.PLAN_ID = B.FP_PLAN_ID
                                                GROUP  BY A.SITE_ID, B.ERP_OPERATION_ID
                                                */
                                                ) B
                                    ON    A.SITE_ID           = B.SITE_ID
                                    AND   A.ERP_OPERATION_ID  = B.ERP_OPERATION_ID
                       ) A
                       INNER HASH JOIN FP_ORDER_SEQ B
                             ON   A.SEQ = B.ORDER_NO
               ) A
               
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
    
    END
    
    BEGIN
    
      BEGIN
      
        SET @v_table_name = 'FP_DAILY_NET_DEMAND_H'

        DELETE  FROM FP_DAILY_NET_DEMAND_H
        WHERE   INSTANCE_ID   = @v_master_id
        AND     DPP_PLAN_ID    = @v_plan_id
        
        INSERT INTO FP_DAILY_NET_DEMAND_H
              (
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , SHOP_GROUP_ID
              , INSTANCE_ID
              , DPP_PLAN_ID
              , FP_DEMAND_ID
              , SCP_PLAN_ID
              , SCP_TARGET_ID
              , ITEM_ID
              , MFG_WEEK
              , MFG_QTY
              , SCP_QTY
              , WORK_ORDER_ID
              , DUE_DATE
              , DUE_FENCE_DATE
              , PRECEDE_PRODUCING_TERM
              , PRECEDE_PRODUCING_TERM_UOM
              , PRODUCTION_TYPE
              , TO_SITE_ID
              , TO_PLANT_ID
              , LINE_ID
              , PRIORITY
              , OFFSET_QTY
              , CONFIRM_TYPE
              , IS_PREV_SCHEDULE
              , TARGET_PRODUCTION_TYPE
              , INSERT_ID
              , INSERT_TIME
              , UPDATE_ID
              , UPDATE_TIME
              )
        SELECT
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , SHOP_GROUP_ID
              , INSTANCE_ID
              , @v_plan_id AS DPP_PLAN_ID
              , FP_DEMAND_ID
              , SCP_PLAN_ID
              , SCP_TARGET_ID
              , ITEM_ID
              , MFG_WEEK
              , MFG_QTY
              , SCP_QTY
              , WORK_ORDER_ID
              , DUE_DATE
              , DUE_FENCE_DATE
              , PRECEDE_PRODUCING_TERM
              , PRECEDE_PRODUCING_TERM_UOM
              , PRODUCTION_TYPE
              , TO_SITE_ID
              , TO_PLANT_ID
              , LINE_ID
              , PRIORITY
              , OFFSET_QTY
              , CONFIRM_TYPE
              , IS_PREV_SCHEDULE
              , TARGET_PRODUCTION_TYPE
              , INSERT_ID
              , INSERT_TIME
              , UPDATE_ID
              , UPDATE_TIME
        FROM    FP_DAILY_NET_DEMAND_H A
        WHERE   INSTANCE_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    SCM_FP_PLAN_GROUP_DETAIL_H B 
                        WHERE   B.INSTANCE_ID=A.INSTANCE_ID 
                        --AND     B.DIVISION_ID=A.DIVISION_ID 
                        --AND     CASE WHEN B.FACTORY_ID='-' THEN A.FACTORY_ID ELSE B.FACTORY_ID END=A.FACTORY_ID 
                        AND     B.PLAN_ID=A.DPP_PLAN_ID 
                        AND     B.PLAN_DATE= @v_plan_date
                        AND     B.PLAN_GROUP_ID = @v_plan_group_id    -- PLAN_GROUP별로 RELEASE
                       )
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

    
      BEGIN
      
        SET @v_table_name = 'FP_DAILY_DEMAND_OFFSET_H'

        DELETE  FROM FP_DAILY_DEMAND_OFFSET_H
        WHERE   INSTANCE_ID   = @v_master_id
        AND     DPP_PLAN_ID    = @v_plan_id
        
        INSERT INTO FP_DAILY_DEMAND_OFFSET_H
              (
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , INSTANCE_ID
              , DPP_PLAN_ID
              , SCP_PLAN_ID
              , SCP_TARGET_ID
              , ITEM_ID
       , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , PRODUCTION_TYPE
              , MARKET
              , MFG_WEEK
              , MFG_QTY
              , OFFSET_SEQ
              , OFFSET_TYPE
              , INIT_QTY
              , OFFSET_QTY
              , REMAIN_QTY
              , WORK_ORDER_SPL_ID
              , WORK_ORDER_ID
              , STORAGE_ID
              )
        SELECT
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , INSTANCE_ID
              , @v_plan_id AS DPP_PLAN_ID
              , SCP_PLAN_ID
              , SCP_TARGET_ID
              , ITEM_ID
              , FACTORY_ID
              , LINE_ID
              , OPERATION_ID
              , PRODUCTION_TYPE
              , MARKET
              , MFG_WEEK
              , MFG_QTY
              , OFFSET_SEQ
              , OFFSET_TYPE
              , INIT_QTY
              , OFFSET_QTY
              , REMAIN_QTY
              , WORK_ORDER_SPL_ID
              , WORK_ORDER_ID
              , STORAGE_ID
        FROM    FP_DAILY_DEMAND_OFFSET_H A
        WHERE   INSTANCE_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    SCM_FP_PLAN_GROUP_DETAIL_H B 
                        WHERE   B.INSTANCE_ID=A.INSTANCE_ID 
                        --AND     B.DIVISION_ID=A.DIVISION_ID 
                        --AND     CASE WHEN B.FACTORY_ID='-' THEN A.FACTORY_ID ELSE B.FACTORY_ID END=A.FACTORY_ID 
                        AND     B.PLAN_ID=A.DPP_PLAN_ID 
                        AND     B.PLAN_DATE= @v_plan_date
                        AND     B.PLAN_GROUP_ID = @v_plan_group_id    -- PLAN_GROUP별로 RELEASE
                       )
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END


      BEGIN
      
        SET @v_table_name = 'FP_DAILY_PRODUCTION_PLAN_R'

        DELETE  FROM FP_DAILY_PRODUCTION_PLAN_R
        WHERE   INSTANCE_ID   = @v_master_id
        AND     FP_PLAN_ID    = @v_plan_id
        
        INSERT INTO FP_DAILY_PRODUCTION_PLAN_R
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
              , ORG_DEMAND_ID
              , DEMAND_ID
              , ITEM_ID
              , TOP_ITEM_ID
              , OPERATION_ID
              , LINE_ID
              , ELECTRODE_TYPE
              , EQUIPMENT_ID
              , PLAN_DATE
              , START_TIME
              , END_TIME
              , PLAN_QTY
              , PLAN_IN_QTY
              , ITEM_UOM
              , ROLL_IN_QTY
              , ROLL_OUT_QTY
              , JR_IN_QTY
              , JR_OUT_QTY
              , BATCH_IN_QTY
              , BATCH_OUT_QTY
              , FIX_TYPE
              , PRODUCTION_TYPE
              , TOTAL_WORKING_TIME
              , LINE_ITEM_SEQ
              , OPERATION_ITEM_SEQ  
              , BATCH_ORDER_ID
              , MFG_WEEK
              , DEMAND_DIVISION_ID
              , INSERT_ID
              , INSERT_DTTM
              , MARKET
              )
        SELECT DISTINCT
                A.INSTANCE_ID
              , @v_plan_id AS FP_PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              --, A.WORK_ORDER_SPL_ID
              , ISNULL(ISNULL(X.NEW_ORDER_ID, Y.NEW_ORDER_ID), A.WORK_ORDER_SPL_ID) AS WORK_ORDER_SPL_ID
              --, A.WORK_ORDER_ID
              , ISNULL(ISNULL(Y.NEW_ORDER_ID, Y.NEW_ORDER_ID), A.WORK_ORDER_ID) AS WORK_ORDER_ID              
              , A.ORG_DEMAND_ID
              , A.DEMAND_ID
              , A.ITEM_ID
              , A.TOP_ITEM_ID
              , A.OPERATION_ID
              , A.LINE_ID
              , A.ELECTRODE_TYPE
              , A.EQUIPMENT_ID
              , A.PLAN_DATE
              , A.START_TIME
              , A.END_TIME
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      WHEN A.ITEM_UOM = 'EA'                                    THEN CEILING(A.PLAN_QTY)
                      ELSE A.PLAN_QTY
                END   AS PLAN_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      WHEN A.ITEM_UOM = 'EA'                                    THEN CEILING(A.PLAN_IN_QTY)
                      ELSE A.PLAN_IN_QTY
                END   AS PLAN_IN_QTY
              , A.ITEM_UOM
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.ROLL_IN_QTY
                END   AS     ROLL_IN_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.ROLL_OUT_QTY
                END   AS     ROLL_OUT_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.JR_IN_QTY
                END   AS     JR_IN_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.JR_OUT_QTY
                END   AS     JR_OUT_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.BATCH_IN_QTY
                END   AS     BATCH_IN_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.BATCH_OUT_QTY
                END   AS     BATCH_OUT_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'               THEN 'F'
                      WHEN A.PLAN_DATE > @v_confirm_date  THEN 'P'
                      ELSE 'N'
                END   AS FIX_TYPE
              , A.PRODUCTION_TYPE
              , A.TOTAL_WORKING_TIME
              , A.LINE_ITEM_SEQ
              , A.OPERATION_ITEM_SEQ   
              , A.BATCH_ORDER_ID
              , A.MFG_WEEK
              , A.DEMAND_DIVISION_ID
              , A.INSERT_ID
              , A.INSERT_DTTM
              , A.MARKET
        FROM    FP_DAILY_PRODUCTION_PLAN_R A
                INNER JOIN FP_DAILY_PLAN_ORDER_R X
                     ON    X.INSTANCE_ID = @v_master_id
                     AND   X.FP_PLAN_ID = @v_plan_id
                     AND   A.WORK_ORDER_SPL_ID = X.WORK_ORDER_SPL_ID
                INNER  JOIN (
                             SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                             FROM   FP_DAILY_PLAN_ORDER_R
                             WHERE  INSTANCE_ID = @v_master_id
                             AND    FP_PLAN_ID = @v_plan_id
                             GROUP  BY WORK_ORDER_ID
                            ) Y
                     ON    A.WORK_ORDER_ID = Y.WORK_ORDER_ID
        WHERE   A.INSTANCE_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID
                        AND     X.LINE_ID       = A.LINE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        UPDATE FP_DAILY_PRODUCTION_PLAN_R
        SET    FP_DAILY_PRODUCTION_PLAN_R.BATCH_ORDER_ID = B.NEW_ORDER_ID
        FROM   FP_DAILY_PRODUCTION_PLAN_R A,
               FP_DAILY_PLAN_ORDER_R B
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id
        AND    A.INSTANCE_ID    = B.INSTANCE_ID
        AND    A.FP_PLAN_ID     = B.FP_PLAN_ID
        AND    A.BATCH_ORDER_ID = B.WORK_ORDER_SPL_ID
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID
                        AND     X.LINE_ID       = A.LINE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE FP_DAILY_PRODUCTION_PLAN_R
        SET    FP_DAILY_PRODUCTION_PLAN_R.BATCH_ORDER_ID = B.NEW_ORDER_ID
        FROM   FP_DAILY_PRODUCTION_PLAN_R A,
               (
               SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
               FROM   FP_DAILY_PLAN_ORDER_R
               WHERE  INSTANCE_ID = @v_master_id
               AND    FP_PLAN_ID  = @v_plan_id
               GROUP  BY WORK_ORDER_ID
               ) B
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.FP_PLAN_ID     = @v_plan_id
        AND    A.BATCH_ORDER_ID = B.WORK_ORDER_ID
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID
                        AND     X.LINE_ID       = A.LINE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END
      
      BEGIN
      
        SET @v_table_name = 'FP_DEMAND_FULFILLMENT_R'

        DELETE  FROM FP_DEMAND_FULFILLMENT_R
        WHERE   INSTANCE_ID   = @v_master_id
        AND     FP_PLAN_ID    = @v_plan_id
        
        INSERT INTO FP_DEMAND_FULFILLMENT_R
              (
                INSTANCE_ID
              , FP_PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , ITEM_ID
              , PLAN_DATE
              , CATEGORY_ID
              , ITEM_ATTB_1
              , ITEM_ATTB_2
              , QTY
              , INSERT_ID
              , INSERT_TIME              
              )
        SELECT              
                INSTANCE_ID
              , @v_plan_id AS FP_PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , ITEM_ID
              , PLAN_DATE
              , CATEGORY_ID
              , ITEM_ATTB_1
              , ITEM_ATTB_2
              , QTY
              , INSERT_ID
              , INSERT_TIME        
        FROM    FP_DEMAND_FULFILLMENT_R A
        WHERE   INSTANCE_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    SCM_FP_PLAN_GROUP_DETAIL_H B 
                        WHERE   B.INSTANCE_ID=A.INSTANCE_ID 
                        --AND     B.DIVISION_ID=A.DIVISION_ID 
                        --AND     CASE WHEN B.FACTORY_ID='-' THEN A.FACTORY_ID ELSE B.FACTORY_ID END=A.FACTORY_ID 
                        AND     B.PLAN_ID=A.FP_PLAN_ID 
                        AND     B.PLAN_DATE= @v_plan_date
                        AND     B.PLAN_GROUP_ID = @v_plan_group_id    -- PLAN_GROUP별로 RELEASE
                       )
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

      BEGIN

        SET @v_table_name = 'FP_MOVE_PLAN_R'

        DELETE  FROM FP_MOVE_PLAN_R
        WHERE   INSTANCE_ID   = @v_master_id
        AND     FP_PLAN_ID    = @v_plan_id
        
        INSERT INTO FP_MOVE_PLAN_R
              (
                INSTANCE_ID
              , FP_PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , MOVE_ORDER_ID
              , SCP_TARGET_ID
              , DEMAND_ID
              , ITEM_ID
              , TOP_ITEM_ID
              , OPERATION_ID
              , LINE_ID
              , FROM_WORK_ORDER_ID
              , TO_FACTORY_ID
              , TO_OPERATION_ID
              , TO_LINE_ID
              , TO_WORK_ORDER_ID
              , TRANSPORT_MODE
              , BOD_ID
              , PLAN_DATE
              , START_TIME
              , END_TIME
              , PLAN_QTY
              , ITEM_UOM
              , FIX_TYPE
              , INSERT_ID
              , INSERT_TIME              
       )
        SELECT
                A.INSTANCE_ID
              , @v_plan_id AS FP_PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              --, A.MOVE_ORDER_ID
              , ISNULL(ISNULL(X.NEW_ORDER_ID, Y.NEW_ORDER_ID), A.MOVE_ORDER_ID) AS MOVE_ORDER_ID
              , A.SCP_TARGET_ID
              , A.DEMAND_ID
              , A.ITEM_ID
              , A.TOP_ITEM_ID
              , A.OPERATION_ID
              , A.LINE_ID
              --, A.FROM_WORK_ORDER_ID
              , ISNULL(ISNULL(FX.NEW_ORDER_ID, FY.NEW_ORDER_ID), A.FROM_WORK_ORDER_ID) AS FROM_WORK_ORDER_ID
              , A.TO_FACTORY_ID
              , A.TO_OPERATION_ID
              , A.TO_LINE_ID
              --, A.TO_WORK_ORDER_ID
              , ISNULL(ISNULL(TX.NEW_ORDER_ID, TY.NEW_ORDER_ID), A.TO_WORK_ORDER_ID) AS TO_WORK_ORDER_ID
              , A.TRANSPORT_MODE
              , A.BOD_ID
              , A.PLAN_DATE
              , A.START_TIME
              , A.END_TIME
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.PLAN_QTY
                END   AS PLAN_QTY
              , A.ITEM_UOM
              , CASE  WHEN A.FIX_TYPE = 'F'               THEN 'F'
                      WHEN A.PLAN_DATE > @v_confirm_date  THEN 'P'
                      ELSE 'N'
                END   AS FIX_TYPE
              , A.INSERT_ID
              , A.INSERT_TIME        
        FROM    FP_MOVE_PLAN_R A
                INNER JOIN FP_DAILY_PLAN_ORDER_R X
                     ON    X.INSTANCE_ID = @v_master_id
                     AND   X.FP_PLAN_ID = @v_plan_id
                     AND   A.MOVE_ORDER_ID = X.WORK_ORDER_SPL_ID
                INNER JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) Y
                     ON    A.MOVE_ORDER_ID = Y.WORK_ORDER_ID
                INNER JOIN FP_DAILY_PLAN_ORDER_R FX
                     ON    FX.INSTANCE_ID = @v_master_id
                     AND   FX.FP_PLAN_ID = @v_plan_id
                     AND   A.FROM_WORK_ORDER_ID = FX.WORK_ORDER_SPL_ID
                INNER JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) FY
                     ON    A.FROM_WORK_ORDER_ID = FY.WORK_ORDER_ID
                INNER JOIN FP_DAILY_PLAN_ORDER_R TX
                     ON    TX.INSTANCE_ID = @v_master_id
                     AND   TX.FP_PLAN_ID = @v_plan_id
                     AND   A.TO_WORK_ORDER_ID = TX.WORK_ORDER_SPL_ID
                INNER JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) TY
                     ON    A.TO_WORK_ORDER_ID = TY.WORK_ORDER_ID
        WHERE   A.INSTANCE_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID
                        AND     X.LINE_ID       = A.LINE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
        
        SET @v_table_name = 'FP_ORDER_PEGGING_R'

        DELETE  FROM FP_ORDER_PEGGING_R
        WHERE   INSTANCE_ID   = @v_master_id
        AND     FP_PLAN_ID    = @v_plan_id
        
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
              , FROM_LINE_ID
              , TO_LINE_ID
              , FROM_OPERATION_ID
              , TO_OPERATION_ID
              , FROM_QTY
              , TO_QTY
              , FROM_ITEM_ID
              , TO_ITEM_ID
              , DEMAND_ID
              , INSERT_ID
              , INSERT_TIME              
              )
        SELECT
                A.INSTANCE_ID
              , @v_plan_id AS FP_PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              --, A.FROM_WORK_ORDER_ID
              , ISNULL(ISNULL(FX.NEW_ORDER_ID, FY.NEW_ORDER_ID), A.FROM_WORK_ORDER_ID) AS FROM_WORK_ORDER_ID
              , A.FROM_STOCK_SET_ID
              --, A.TO_WORK_ORDER_ID
              , ISNULL(ISNULL(TX.NEW_ORDER_ID, TY.NEW_ORDER_ID), A.TO_WORK_ORDER_ID) AS TO_WORK_ORDER_ID
              , A.FROM_FACTORY_ID
              , A.TO_FACTORY_ID
              , A.FROM_LINE_ID
              , A.TO_LINE_ID
              , A.FROM_OPERATION_ID
              , A.TO_OPERATION_ID
              , A.FROM_QTY
              , A.TO_QTY
              , A.FROM_ITEM_ID
              , A.TO_ITEM_ID
              , A.DEMAND_ID
              , A.INSERT_ID
              , A.INSERT_TIME        
        FROM    FP_ORDER_PEGGING_R A
                INNER JOIN FP_DAILY_PLAN_ORDER_R FX
                     ON    FX.INSTANCE_ID = @v_master_id
                     AND   FX.FP_PLAN_ID = @v_plan_id
                     AND   A.FROM_WORK_ORDER_ID = FX.WORK_ORDER_SPL_ID
                INNER JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) FY
                     ON    A.FROM_WORK_ORDER_ID = FY.WORK_ORDER_ID
                INNER JOIN FP_DAILY_PLAN_ORDER_R TX
                     ON    TX.INSTANCE_ID = @v_master_id
                     AND   TX.FP_PLAN_ID = @v_plan_id
                     AND   A.TO_WORK_ORDER_ID = TX.WORK_ORDER_SPL_ID
                INNER JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) TY
                     ON    A.TO_WORK_ORDER_ID = TY.WORK_ORDER_ID
        WHERE   A.INSTANCE_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FROM_FACTORY_ID
                        AND     X.LINE_ID       = A.FROM_LINE_ID
                        AND     X.OPERATION_ID  = A.FROM_OPERATION_ID
                       )
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
        
        SET @v_table_name = 'FP_ORDER_TRACKING_R'

        DELETE  FROM FP_ORDER_TRACKING_R
        WHERE   INSTANCE_ID   = @v_master_id
        AND     FP_PLAN_ID    = @v_plan_id
        
        INSERT INTO FP_ORDER_TRACKING_R
              (
                INSTANCE_ID
              , FP_PLAN_ID
              , DPP_PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , DEMAND_ID
              , ORDERTRACKING_SEQ
              , WORK_ORDER_ID
              , ORDER_TYPE
              , FACTORY_ID
              , OPERATION_ID
              , LINE_ID
              , WORK_CENTER_ID
              , ITEM_ID
              , CO_PRODUCT_ID
              , PLAN_QTY
              , IN_ITEM_ID
              , IN_PLAN_QTY
              , DUE_DATE
              , TO_FACTORY_ID
              , TO_OPERATION_ID
              , TO_WORK_ORDER_ID
              , EPST
              , LPST
              , START_TIME
              , END_TIME
              , AVAILABLE_TIME
              , PLAN_RESULT
              , INSERT_ID
              , INSERT_TIME
              )
        SELECT
                A.INSTANCE_ID
              , @v_plan_id AS FP_PLAN_ID 
              , A.DPP_PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.DEMAND_ID
              , A.ORDERTRACKING_SEQ
              --, A.WORK_ORDER_ID
              , ISNULL(ISNULL(FX.NEW_ORDER_ID, FY.NEW_ORDER_ID), A.WORK_ORDER_ID) AS WORK_ORDER_ID
              , A.ORDER_TYPE
              , A.FACTORY_ID
              , A.OPERATION_ID
              , A.LINE_ID
              , A.WORK_CENTER_ID
              , A.ITEM_ID
              , A.CO_PRODUCT_ID
              , A.PLAN_QTY
              , A.IN_ITEM_ID
              , A.IN_PLAN_QTY
              , A.DUE_DATE
              , A.TO_FACTORY_ID
              , A.TO_OPERATION_ID
              --, A.TO_WORK_ORDER_ID
              , ISNULL(ISNULL(TX.NEW_ORDER_ID, TY.NEW_ORDER_ID), A.TO_WORK_ORDER_ID) AS TO_WORK_ORDER_ID
              , A.EPST
              , A.LPST
              , A.START_TIME
              , A.END_TIME
              , A.AVAILABLE_TIME
              , A.PLAN_RESULT
              , A.INSERT_ID
              , A.INSERT_TIME
        FROM    FP_ORDER_TRACKING_R A
                INNER JOIN FP_DAILY_PLAN_ORDER_R FX
                     ON    FX.INSTANCE_ID = @v_master_id
                     AND   FX.FP_PLAN_ID = @v_plan_id
                     AND   A.WORK_ORDER_ID = FX.WORK_ORDER_SPL_ID
                INNER JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) FY
                     ON    A.WORK_ORDER_ID = FY.WORK_ORDER_ID
                INNER JOIN FP_DAILY_PLAN_ORDER_R TX
                     ON    TX.INSTANCE_ID = @v_master_id
                     AND   TX.FP_PLAN_ID = @v_plan_id
                     AND   A.TO_WORK_ORDER_ID = TX.WORK_ORDER_SPL_ID
                INNER JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) TY
                     ON    A.TO_WORK_ORDER_ID = TY.WORK_ORDER_ID
        WHERE   A.INSTANCE_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID
                        AND     X.LINE_ID       = A.LINE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
        
        SET @v_table_name = 'FP_PLAN_UTILIZATION_R'
        
        DELETE  FROM FP_PLAN_UTILIZATION_R
        WHERE   INSTANCE_ID   = @v_master_id
        AND     FP_PLAN_ID    = @v_plan_id
        
        INSERT INTO FP_PLAN_UTILIZATION_R
              (
                INSTANCE_ID
              , FP_PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , EQUIPMENT_ID
              , PLAN_DATE
              , LINE_ID
              , OPERATION_ID
              , WORK_CENTER_ID
              , WORK_TIME
              , OFF_TIME
              , RUN_TIME
              , SETUP_TIME
              , IDLE_TIME
              , CAPACITY_UOM
              , PLAN_QTY
              , INSERT_ID
              , INSERT_TIME              
              )
        SELECT
                INSTANCE_ID
              , @v_plan_id AS FP_PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , EQUIPMENT_ID
              , PLAN_DATE
              , LINE_ID
              , OPERATION_ID
              , WORK_CENTER_ID
              , WORK_TIME
              , OFF_TIME
              , RUN_TIME
              , SETUP_TIME
              , IDLE_TIME
              , CAPACITY_UOM
              , PLAN_QTY
              , INSERT_ID
              , INSERT_TIME        
        FROM    FP_PLAN_UTILIZATION_R A
        WHERE   INSTANCE_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID
                        AND     X.LINE_ID       = A.LINE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
        
        SET @v_table_name = 'FP_PROBLEM_REPORT_R'
        
        DELETE  FROM FP_PROBLEM_REPORT_R
        WHERE   INSTANCE_ID   = @v_master_id
        AND     FP_PLAN_ID    = @v_plan_id
        
        INSERT INTO FP_PROBLEM_REPORT_R
              (
                INSTANCE_ID
              , FP_PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , DEMAND_ID
              , PROBLEM_SEQ
              , SCP_TARGET_ID
              , ITEM_ID
              , DUE_DATE
              , DUE_FENCE_DATE
              , RESPONSE_TIME
              , PROBLEM_TYPE
              , PROBLEM_REASON
              , PROBLEM_QTY
              , PROBLEM_ITEM
              , PROBLEM_PLANT
              , PROBLEM_FACTORY
              , PROBLEM_OPERATION
              , PROBLEM_LINE
              , PROBLEM_DESCRIPTION
              , EPST
              , LPST
              , INSERT_ID
              , INSERT_TIME              
              )
        SELECT
                INSTANCE_ID
              , @v_plan_id AS FP_PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , DEMAND_ID
              , PROBLEM_SEQ
              , SCP_TARGET_ID
              , ITEM_ID
              , DUE_DATE
              , DUE_FENCE_DATE
              , RESPONSE_TIME
              , PROBLEM_TYPE
              , PROBLEM_REASON
              , PROBLEM_QTY
              , PROBLEM_ITEM
              , PROBLEM_PLANT
              , PROBLEM_FACTORY
              , PROBLEM_OPERATION
              , PROBLEM_LINE
              , PROBLEM_DESCRIPTION
              , EPST
              , LPST
              , INSERT_ID
              , INSERT_TIME        
        FROM    FP_PROBLEM_REPORT_R A
        WHERE   INSTANCE_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    SCM_FP_PLAN_GROUP_DETAIL_H B 
                        WHERE   B.INSTANCE_ID=A.INSTANCE_ID 
                        --AND     B.DIVISION_ID=A.DIVISION_ID 
                        --AND     CASE WHEN B.FACTORY_ID='-' THEN A.FACTORY_ID ELSE B.FACTORY_ID END=A.FACTORY_ID 
                        AND     B.PLAN_ID=A.FP_PLAN_ID 
                        AND     B.PLAN_DATE= @v_plan_date
                        AND     B.PLAN_GROUP_ID = @v_plan_group_id    -- 동별로 RELEASE
                       )
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
        
        SET @v_table_name = 'FP_PRODUCTION_PLAN_EQUIPMENT_R'
        
        DELETE  FROM FP_PRODUCTION_PLAN_EQUIPMENT_R
        WHERE   INSTANCE_ID   = @v_master_id
        AND     FP_PLAN_ID    = @v_plan_id
        
        INSERT INTO FP_PRODUCTION_PLAN_EQUIPMENT_R
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
              , START_TIME
              , END_TIME
              , PLAN_QTY
              , PLAN_IN_QTY
              , ITEM_UOM
              , ROLL_IN_QTY
              , ROLL_OUT_QTY
              , JR_IN_QTY
              , JR_OUT_QTY
              , BATCH_QTY
              , BATCH_SUM_QTY
              , FIX_TYPE
              , PRODUCTION_TYPE
              , BOM_VERSION_ID
              , SLIT_PLANT_ID
              , MARKET
              , MFG_WEEK
              , DEMAND_DIVISION_ID
              , INSERT_ID
              , INSERT_TIME              
              )
        SELECT
                A.INSTANCE_ID
              , @v_plan_id AS FP_PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              --, A.WORK_ORDER_SPL_ID
              , ISNULL(ISNULL(X.NEW_ORDER_ID, Y.NEW_ORDER_ID), A.WORK_ORDER_SPL_ID) AS WORK_ORDER_SPL_ID
              --, A.WORK_ORDER_ID
              , ISNULL(Y.NEW_ORDER_ID, A.WORK_ORDER_ID) AS WORK_ORDER_ID
              --, A.BATCH_ORDER_ID
              , ISNULL(ISNULL(FX.NEW_ORDER_ID, FY.NEW_ORDER_ID), A.BATCH_ORDER_ID) AS BATCH_ORDER_ID
              --, A.BIN_ORDER_ID
              , ISNULL(ISNULL(TX.NEW_ORDER_ID, TY.NEW_ORDER_ID), A.BIN_ORDER_ID) AS BIN_ORDER_ID
              , A.ORDER_TYPE
              , A.SCP_TARGET_ID
              , A.DEMAND_ID
              , A.ITEM_ID
              , A.LANE_QTY
              , A.TOP_ITEM_ID
              , A.TOP_WORK_ORDER_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELECTRODE_TYPE
              , A.WORK_CENTER_ID
              , A.EQUIPMENT_ID
              , A.PLAN_DATE
              , A.START_TIME
              , A.END_TIME
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      WHEN A.ITEM_UOM = 'EA'                                    THEN CEILING(A.PLAN_QTY)
                      ELSE A.PLAN_QTY
                END   AS PLAN_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      WHEN A.ITEM_UOM = 'EA'                                    THEN CEILING(A.PLAN_IN_QTY)
                      ELSE A.PLAN_IN_QTY 
                END   AS PLAN_IN_QTY
              , A.ITEM_UOM
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.ROLL_IN_QTY
                END   AS     ROLL_IN_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.ROLL_OUT_QTY
                END   AS     ROLL_OUT_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.JR_IN_QTY
                END   AS     JR_IN_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.JR_OUT_QTY
                END   AS     JR_OUT_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.BATCH_QTY
                END   AS     BATCH_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.BATCH_SUM_QTY
                END   AS     BATCH_SUM_QTY
              , CASE  WHEN A.FIX_TYPE  = 'F'              THEN 'F'
                      WHEN A.PLAN_DATE > @v_confirm_date  THEN 'P'
                      ELSE 'N'
                END   AS FIX_TYPE
              , A.PRODUCTION_TYPE
              , A.BOM_VERSION_ID
              , A.SLIT_PLANT_ID
              , A.MARKET
              , A.MFG_WEEK
              , A.DEMAND_DIVISION_ID
              , A.INSERT_ID
              , A.INSERT_TIME        
        FROM    FP_PRODUCTION_PLAN_EQUIPMENT_R A
                INNER JOIN FP_DAILY_PLAN_ORDER_R X
                     ON    X.INSTANCE_ID = @v_master_id
                     AND   X.FP_PLAN_ID = @v_plan_id
                     AND   A.WORK_ORDER_SPL_ID = X.WORK_ORDER_SPL_ID
                LEFT OUTER JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) Y
                     ON    A.WORK_ORDER_ID = Y.WORK_ORDER_ID
                LEFT MERGE JOIN FP_DAILY_PLAN_ORDER_R FX
                     ON    FX.INSTANCE_ID = @v_master_id
                     AND   FX.FP_PLAN_ID = @v_plan_id
                     AND   A.BATCH_ORDER_ID = FX.WORK_ORDER_SPL_ID
                LEFT MERGE JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) FY
                     ON    A.BATCH_ORDER_ID = FY.WORK_ORDER_ID
                LEFT MERGE JOIN FP_DAILY_PLAN_ORDER_R TX
                     ON    TX.INSTANCE_ID = @v_master_id
                     AND   TX.FP_PLAN_ID = @v_plan_id
                     AND   A.BIN_ORDER_ID = TX.WORK_ORDER_SPL_ID
                LEFT MERGE JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) TY
                     ON    A.BIN_ORDER_ID = TY.WORK_ORDER_ID
        WHERE   A.INSTANCE_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID
                        AND     X.LINE_ID       = A.LINE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
        
        SET @v_table_name = 'FP_PRODUCTION_PLAN_R'
        
        DELETE  FROM FP_PRODUCTION_PLAN_R
        WHERE   INSTANCE_ID   = @v_master_id
        AND     FP_PLAN_ID    = @v_plan_id
        
        INSERT INTO FP_PRODUCTION_PLAN_R
              (
                INSTANCE_ID
              , FP_PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , WORK_ORDER_ID
              , BATCH_ORDER_ID
              , BIN_ORDER_ID
              , ORDER_TYPE
              , SCP_TARGET_ID
              , DEMAND_ID
              , ITEM_ID
              , LANE_QTY
              , TOP_ITEM_ID
              , OPERATION_ID
              , LINE_ID
              , ELECTRODE_TYPE
              , WORK_CENTER_ID
              , PLAN_DATE
              , START_TIME
              , END_TIME
              , PLAN_QTY
              , PLAN_IN_QTY
              , ITEM_UOM
              , ROLL_IN_QTY
              , ROLL_OUT_QTY
              , JR_IN_QTY
              , JR_OUT_QTY
              , BATCH_QTY
              , BATCH_SUM_QTY              
              , FIX_TYPE
              , PRODUCTION_TYPE
              , BOM_VERSION_ID
              , SLIT_PLANT_ID
              , MARKET              
              , MFG_WEEK
              , DEMAND_DIVISION_ID
              , INSERT_ID
              , INSERT_TIME              
              )
        SELECT DISTINCT
                A.INSTANCE_ID
              , @v_plan_id AS FP_PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              --, A.WORK_ORDER_ID
              , ISNULL(ISNULL(X.NEW_ORDER_ID, Y.NEW_ORDER_ID), A.WORK_ORDER_ID) AS WORK_ORDER_ID
              --, A.BATCH_ORDER_ID
              , ISNULL(ISNULL(FX.NEW_ORDER_ID, FY.NEW_ORDER_ID), A.BATCH_ORDER_ID) AS BATCH_ORDER_ID
              --, A.BIN_ORDER_ID
              , ISNULL(ISNULL(TX.NEW_ORDER_ID, TY.NEW_ORDER_ID), A.BIN_ORDER_ID) AS BIN_ORDER_ID
              , A.ORDER_TYPE
              , A.SCP_TARGET_ID
              , A.DEMAND_ID
              , A.ITEM_ID
              , A.LANE_QTY
              , A.TOP_ITEM_ID
              , A.OPERATION_ID
              , A.LINE_ID
              , A.ELECTRODE_TYPE
              , A.WORK_CENTER_ID
              , A.PLAN_DATE
              , A.START_TIME
              , A.END_TIME
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      WHEN A.ITEM_UOM = 'EA'                                    THEN CEILING(A.PLAN_QTY)
                      ELSE A.PLAN_QTY
                END   AS PLAN_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      WHEN A.ITEM_UOM = 'EA'                                    THEN CEILING(A.PLAN_IN_QTY)
                      ELSE A.PLAN_IN_QTY
                END   AS PLAN_IN_QTY
              , A.ITEM_UOM
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.ROLL_IN_QTY
                END   AS     ROLL_IN_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.ROLL_OUT_QTY
                END   AS     ROLL_OUT_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.JR_IN_QTY
                END   AS     JR_IN_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.JR_OUT_QTY
                END   AS     JR_OUT_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.BATCH_QTY
                END   AS     BATCH_QTY
              , CASE  WHEN A.FIX_TYPE = 'F'  AND  A.PLAN_DATE > @v_confirm_date THEN 0
                      ELSE A.BATCH_SUM_QTY  
                END   AS     BATCH_SUM_QTY            
              , CASE  WHEN A.FIX_TYPE = 'F'               THEN 'F'
                      WHEN A.PLAN_DATE > @v_confirm_date  THEN 'P'
                      ELSE 'N'
                END   AS FIX_TYPE
              , A.PRODUCTION_TYPE
              , A.BOM_VERSION_ID
              , A.SLIT_PLANT_ID
              , A.MARKET      
              , A.MFG_WEEK
              , A.DEMAND_DIVISION_ID
              , A.INSERT_ID
              , A.INSERT_TIME        
        FROM    FP_PRODUCTION_PLAN_R A
                INNER JOIN FP_DAILY_PLAN_ORDER_R X
                     ON    X.INSTANCE_ID = @v_master_id
                     AND   X.FP_PLAN_ID = @v_plan_id
                     AND   A.WORK_ORDER_ID = X.WORK_ORDER_SPL_ID
                LEFT OUTER JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) Y
                     ON    A.WORK_ORDER_ID = Y.WORK_ORDER_ID
                LEFT MERGE JOIN FP_DAILY_PLAN_ORDER_R FX
                     ON    FX.INSTANCE_ID = @v_master_id
                     AND   FX.FP_PLAN_ID = @v_plan_id
                     AND   A.BATCH_ORDER_ID = FX.WORK_ORDER_SPL_ID
                LEFT MERGE JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) FY
                     ON    A.BATCH_ORDER_ID = FY.WORK_ORDER_ID
                LEFT MERGE JOIN FP_DAILY_PLAN_ORDER_R TX
                     ON    TX.INSTANCE_ID = @v_master_id
                     AND   TX.FP_PLAN_ID = @v_plan_id
                     AND   A.BIN_ORDER_ID = TX.WORK_ORDER_SPL_ID
                LEFT MERGE JOIN (
                                 SELECT WORK_ORDER_ID, MIN(NEW_ORDER_ID) AS NEW_ORDER_ID
                                 FROM   FP_DAILY_PLAN_ORDER_R
                                 WHERE  INSTANCE_ID = @v_master_id
                                 AND    FP_PLAN_ID = @v_plan_id
                                 GROUP  BY WORK_ORDER_ID
                                ) TY
                     ON    A.BIN_ORDER_ID = TY.WORK_ORDER_ID
        WHERE   A.INSTANCE_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID
                        AND     X.LINE_ID       = A.LINE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      -- OPEN W/O  0 처리 로직 : FP_PRODUCTION_PLAN_EQUIPMENT_R
      BEGIN
      
        SET @v_table_name = 'FP_PRODUCTION_PLAN_EQUIPMENT_R'

        INSERT INTO FP_PRODUCTION_PLAN_EQUIPMENT_R
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
             , OPERATION_ID
             , LINE_ID
             , ELECTRODE_TYPE
             , WORK_CENTER_ID
             , EQUIPMENT_ID
             , PLAN_DATE
             , START_TIME
             , END_TIME
             , PLAN_QTY
             , PLAN_IN_QTY
             , ITEM_UOM
             , FIX_TYPE
             , PRODUCTION_TYPE
             , MARKET
             , DEMAND_DIVISION_ID     
             , A.INSERT_ID
             , A.INSERT_TIME
             )
        SELECT A.INSTANCE_ID
             , @v_plan_id         AS FP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.WORK_ORDER_SPL_ID
             , A.WORK_ORDER_ID
             , A.BATCH_ORDER_ID
             , '-'                                AS BIN_ORDER_ID
             , CASE WHEN CHARINDEX('W', A.ORDER_TYPE) > 0 THEN 'W'
                    ELSE 'M'
               END  AS ORDER_TYPE
             , CASE WHEN CHARINDEX('::', A.DEMAND_ID) = 0 THEN A.DEMAND_ID
                    ELSE SUBSTRING(A.DEMAND_ID, 1, CHARINDEX('::', A.DEMAND_ID)-1)
               END  AS SCP_TARGET_ID
             , A.DEMAND_ID
             , A.ITEM_ID
             , 0                                  AS LANE_QTY
             , ISNULL(A.TOP_ITEM_ID, A.ITEM_ID)   AS TOP_ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , ISNULL(ISNULL(ISNULL(E.ELECTRODE_TYPE, D.ELECTRODE_TYPE), A.ELECTRODE_TYPE), '-') AS ELECTRODE_TYPE
             , ISNULL(ISNULL(ISNULL(E.WORK_CENTER_ID, D.WORK_CENTER_ID), A.WORK_CENTER_ID), '-') AS WORK_CENTER_ID
             , ISNULL(ISNULL(ISNULL(E.EQUIPMENT_ID  , D.EQUIPMENT_ID  ), A.EQUIPMENT_ID  ), '-') AS EQUIPMENT_ID
             , A.PLAN_DATE
             , A.PLAN_START_TIME
             , A.PLAN_END_TIME
             , 0                          AS PLAN_QTY
             , 0                          AS PLAN_IN_QTY
             , C.ITEM_UOM
             , 'F'                        AS FIX_TYPE
             , A.PRODUCTION_TYPE
             , A.MARKET
             , A.DIVISION_ID              AS DEMAND_DIVISION_ID
             , A.INSERT_ID
             , A.INSERT_TIME
        FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
               LEFT OUTER JOIN SCM_ITEM_M C
                    ON    A.COMPANY_ID = C.COMPANY_ID
                    AND   A.DIVISION_ID = C.DIVISION_ID
                    AND   A.SITE_ID = C.SITE_ID
                    AND   A.ITEM_ID = C.ITEM_ID
               LEFT OUTER JOIN SCM_EQUIPMENT_M D
                    ON    A.COMPANY_ID = D.COMPANY_ID
                    AND   A.DIVISION_ID = D.DIVISION_ID
                    AND   A.SITE_ID = D.SITE_ID
                    AND   A.PLANT_ID = D.PLANT_ID
                    AND   A.FACTORY_ID = D.FACTORY_ID
                    AND   A.EQUIPMENT_ID = D.EQUIPMENT_ID
                    AND   A.OPERATION_ID = D.OPERATION_ID
               LEFT OUTER JOIN (
                                SELECT A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.WORK_CENTER_ID
                                     , A.RESOURCE_ID, A.EQUIPMENT_ID
                                FROM   (
                                        SELECT FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, WORK_CENTER_ID, EQUIPMENT_ID
                                             , LINE_ID + '_' + OPERATION_ID
                                                             + CASE WHEN ELECTRODE_TYPE = '-'   THEN ''
                                                                    WHEN ELECTRODE_TYPE = ''    THEN ''
                                                                    WHEN ELECTRODE_TYPE IS NULL THEN ''
                                                                    ELSE '_' + ELECTRODE_TYPE
                                                               END
                                               AS RESOURCE_ID
                                             , DENSE_RANK() OVER (PARTITION BY FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE
                                                                  ORDER     BY EQUIPMENT_ID) AS SEQ
                                        FROM   SCM_EQUIPMENT_M
                                        WHERE  ACTIVE_FLAG = 'Y'
                                        AND    EQUIPMENT_TYPE = 'M'
                                       ) A
                                WHERE  SEQ = 1    -- ## 대표설비만...                      
                               ) E
                    ON   A.EQUIPMENT_ID = E.RESOURCE_ID                    
        WHERE  A.INSTANCE_ID = @v_master_id
        AND    A.ORDER_TYPE = 'WO'
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID
                        AND     X.LINE_ID       = A.LINE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )
        --AND     ISNULL(ACTUAL_QTY, 0) = 0     -- 작업안한 WO 만
        AND     NOT EXISTS (-- PEGGING 안된 확정 WO 찾기
                            SELECT  1 
                            FROM   (
                                    SELECT  WORK_ORDER_ID
                                    FROM    FP_PRODUCTION_PLAN_EQUIPMENT_R B 
                                    WHERE   B.INSTANCE_ID = @v_master_id
                                    AND     B.FP_PLAN_ID  = @v_plan_id
                                    UNION   ALL
                                    SELECT  WORK_ORDER_ID
                                    FROM    FP_PRODUCTION_PLAN_EQUIPMENT_R B
                                    WHERE   B.INSTANCE_ID = @v_master_id
                                    AND     B.FP_PLAN_ID  = @v_amend_plan_id      -- CONFIRM ID
                                    AND     B.PLAN_DATE  <= @v_confirm_date
                                   ) B
                            WHERE  B.WORK_ORDER_ID = A.WORK_ORDER_SPL_ID
                           )
                         
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = 'PLAN_QTY = 0 : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END
      
      -- OPEN W/O  0 처리 로직 : FP_PRODUCTION_PLAN_R
      BEGIN

        SET @v_table_name = 'FP_PRODUCTION_PLAN_R'

        INSERT INTO FP_PRODUCTION_PLAN_R
             (
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , WORK_ORDER_ID
             , BATCH_ORDER_ID
             , BIN_ORDER_ID
             , ORDER_TYPE
             , SCP_TARGET_ID
             , DEMAND_ID
             , ITEM_ID
             , LANE_QTY
             , TOP_ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , ELECTRODE_TYPE
             , WORK_CENTER_ID
             , PLAN_DATE
             , START_TIME
             , END_TIME
             , PLAN_QTY
             , PLAN_IN_QTY
             , ITEM_UOM
             , FIX_TYPE
             , PRODUCTION_TYPE
             , MARKET
             , DEMAND_DIVISION_ID     
             , A.INSERT_ID
             , A.INSERT_TIME
             )
        SELECT A.INSTANCE_ID
             , @v_plan_id                         AS FP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.WORK_ORDER_SPL_ID                AS WORK_ORDER_ID
             , A.BATCH_ORDER_ID
             , '-'                                AS BIN_ORDER_ID
             , CASE WHEN CHARINDEX('W', A.ORDER_TYPE) > 0 THEN 'W'
                    ELSE 'M'
               END  AS ORDER_TYPE
    , CASE WHEN CHARINDEX('::', A.DEMAND_ID) = 0 THEN A.DEMAND_ID
                    ELSE SUBSTRING(A.DEMAND_ID, 1, CHARINDEX('::', A.DEMAND_ID)-1)
               END  AS SCP_TARGET_ID
             , A.DEMAND_ID
             , A.ITEM_ID
             , 0                                  AS LANE_QTY
             , ISNULL(A.TOP_ITEM_ID, A.ITEM_ID)   AS TOP_ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , ISNULL(ISNULL(ISNULL(E.ELECTRODE_TYPE, D.ELECTRODE_TYPE), A.ELECTRODE_TYPE), '-') AS ELECTRODE_TYPE
             , ISNULL(ISNULL(ISNULL(E.WORK_CENTER_ID, D.WORK_CENTER_ID), A.WORK_CENTER_ID), '-') AS WORK_CENTER_ID
             , A.PLAN_DATE
             , A.PLAN_START_TIME
             , A.PLAN_END_TIME
             , 0                    AS PLAN_QTY
             , 0                    AS PLAN_IN_QTY
             , C.ITEM_UOM           AS ITEM_UOM
             , 'F'                  AS FIX_TYPE
             , A.PRODUCTION_TYPE
             , A.MARKET
             , A.DIVISION_ID        AS DEMAND_DIVISION_ID
             , A.INSERT_ID
             , A.INSERT_TIME
        FROM   FP_DAILY_INSTANCE_ORDER_STATUS A
               LEFT OUTER JOIN SCM_ITEM_M C
                    ON    A.COMPANY_ID = C.COMPANY_ID
                    AND   A.DIVISION_ID = C.DIVISION_ID
                    AND   A.SITE_ID = C.SITE_ID
                    AND   A.ITEM_ID = C.ITEM_ID
               LEFT OUTER JOIN SCM_EQUIPMENT_M D
                    ON    A.COMPANY_ID = D.COMPANY_ID
                    AND   A.DIVISION_ID = D.DIVISION_ID
                    AND   A.SITE_ID = D.SITE_ID
                    AND   A.PLANT_ID = D.PLANT_ID
                    AND   A.FACTORY_ID = D.FACTORY_ID
                    AND   A.EQUIPMENT_ID = D.EQUIPMENT_ID
                    AND   A.OPERATION_ID = D.OPERATION_ID
               LEFT OUTER JOIN (
                                SELECT A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.WORK_CENTER_ID
                                     , A.RESOURCE_ID, A.EQUIPMENT_ID
                                FROM   (
                                        SELECT FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, WORK_CENTER_ID, EQUIPMENT_ID
                                             , LINE_ID + '_' + OPERATION_ID
                                                             + CASE WHEN ELECTRODE_TYPE = '-'   THEN ''
                                                                    WHEN ELECTRODE_TYPE = ''    THEN ''
                                                                    WHEN ELECTRODE_TYPE IS NULL THEN ''
                                                                    ELSE '_' + ELECTRODE_TYPE
                                                               END
                                               AS RESOURCE_ID
                                             , DENSE_RANK() OVER (PARTITION BY FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE
                                                                  ORDER     BY EQUIPMENT_ID) AS SEQ
                                        FROM   SCM_EQUIPMENT_M
                                        WHERE  ACTIVE_FLAG = 'Y'
                                        AND    EQUIPMENT_TYPE = 'M'
                                       ) A
                                WHERE  SEQ = 1    -- ## 대표설비만...                      
                               ) E
                    ON   A.EQUIPMENT_ID = E.RESOURCE_ID                    
        WHERE  A.INSTANCE_ID = @v_master_id
        AND    A.ORDER_TYPE = 'WO'
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
            SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID
                        AND     X.LINE_ID       = A.LINE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )
        --AND     ISNULL(ACTUAL_QTY, 0) = 0     -- 작업안한 WO 만
        AND     NOT EXISTS (-- PEGGING 안된 확정 WO 찾기
                            SELECT  1 
                            FROM   (
                                    SELECT  WORK_ORDER_ID
                                    FROM    FP_PRODUCTION_PLAN_R B 
                                    WHERE   B.INSTANCE_ID = @v_master_id
                                    AND     B.FP_PLAN_ID  = @v_plan_id
                                    UNION   ALL
                                    SELECT  WORK_ORDER_ID
                                    FROM    FP_PRODUCTION_PLAN_R B
                                    WHERE   B.INSTANCE_ID = @v_master_id
                                    AND     B.FP_PLAN_ID  = @v_amend_plan_id      -- CONFIRM ID
                                    AND     B.PLAN_DATE  <= @v_confirm_date
                                    ) B
                            WHERE   B.WORK_ORDER_ID = A.WORK_ORDER_SPL_ID
                           )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = 'PLAN_QTY = 0 : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END
      
      -- 2018.01.10 : 확정 이외의 계획에 대해 DAILY PP 를 생성한다.
      BEGIN
      
        SET @v_table_name = 'FP_DAILY_PRODUCTION_PLAN_R'

        INSERT INTO FP_DAILY_PRODUCTION_PLAN_R
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
              , ORG_DEMAND_ID
              , DEMAND_ID
              , ITEM_ID
              , TOP_ITEM_ID
              , OPERATION_ID
              , LINE_ID
              , ELECTRODE_TYPE
              , EQUIPMENT_ID
              , PLAN_DATE
              , START_TIME
              , END_TIME
              , PLAN_QTY
              , PLAN_IN_QTY
              , ITEM_UOM
              , ROLL_IN_QTY
              , ROLL_OUT_QTY
              , JR_IN_QTY
              , JR_OUT_QTY
              , BATCH_IN_QTY
              , BATCH_OUT_QTY
              , FIX_TYPE
              , PRODUCTION_TYPE
              , TOTAL_WORKING_TIME
              , LINE_ITEM_SEQ
              , OPERATION_ITEM_SEQ  
              , BATCH_ORDER_ID
              , MFG_WEEK
              , DEMAND_DIVISION_ID
              , INSERT_ID
              , INSERT_DTTM
              , MARKET
              )
        SELECT DISTINCT
                A.INSTANCE_ID
              , @v_plan_id AS FP_PLAN_ID
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.WORK_ORDER_SPL_ID
              , A.WORK_ORDER_ID
              , A.ORG_DEMAND_ID
              , A.DEMAND_ID
              , A.ITEM_ID
              , A.TOP_ITEM_ID
              , A.OPERATION_ID
              , A.LINE_ID
              , A.ELECTRODE_TYPE
              , A.EQUIPMENT_ID
              , A.PLAN_DATE
              , A.START_TIME
              , A.END_TIME
              , A.PLAN_QTY
              , A.PLAN_IN_QTY
              , A.ITEM_UOM
              , A.ROLL_IN_QTY
              , A.ROLL_OUT_QTY
              , A.JR_IN_QTY
              , A.JR_OUT_QTY
              , A.BATCH_IN_QTY
              , A.BATCH_OUT_QTY
              , 'P'   AS FIX_TYPE
              , A.PRODUCTION_TYPE
              , A.TOTAL_WORKING_TIME
              , A.LINE_ITEM_SEQ
              , A.OPERATION_ITEM_SEQ   
              , A.BATCH_ORDER_ID
              , A.MFG_WEEK
              , A.DEMAND_DIVISION_ID
              , A.INSERT_ID
              , A.INSERT_DTTM
              , A.MARKET
        FROM    FP_DAILY_PRODUCTION_PLAN_R A
        WHERE   A.INSTANCE_ID = @v_master_id
        AND     A.FIX_TYPE   <> 'F'
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.INSTANCE_ID 
                        AND     X.PLAN_ID       = A.FP_PLAN_ID 
                        AND     X.FACTORY_ID    = A.FACTORY_ID
                        AND     X.LINE_ID       = A.LINE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )
        AND     NOT EXISTS (
                            SELECT 1
                            FROM   FP_DAILY_PLAN_ORDER_R X
                            WHERE  X.INSTANCE_ID        = @v_master_id
                            AND    X.FP_PLAN_ID         = @v_plan_id
                            AND    X.WORK_ORDER_SPL_ID  = A.WORK_ORDER_SPL_ID
                            UNION  ALL
                            SELECT 1
                            FROM   FP_DAILY_PLAN_ORDER_R X
                            WHERE  X.INSTANCE_ID        = @v_master_id
                            AND    X.FP_PLAN_ID         = @v_plan_id
                            AND    X.WORK_ORDER_ID      = A.WORK_ORDER_ID
                           )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      
      -- RELEASE 버전이 저장되기 전에 ERP 로 전송한 거 같아서 충분한 시간을 부여한다.
      WAITFOR DELAY '0:0:3'

      -----------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------
      -- ERP 배포 : START
      -----------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------

      IF CHARINDEX('FORM', @v_master_id) = 0    -- 활성화를 제외하고 전송하기
      BEGIN

        -- ERP 배포
        BEGIN
  					SET @n_log_count = @n_log_count + 1
  					SET @v_descr = @v_master_id + ' PR_XIF_ERP_PRODUCTION_PLAN_S Start'
  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
  					
  					EXEC PR_XIF_ERP_PRODUCTION_PLAN_S @v_plan_id

  					SET @n_log_count = @n_log_count + 1
  					SET @v_descr = @v_master_id + ' PR_XIF_ERP_PRODUCTION_PLAN_S End'
  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
        END
        
        WAITFOR DELAY '0:0:3'

        -- MES 배포
        BEGIN
  					SET @n_log_count = @n_log_count + 1
  					SET @v_message = @v_master_id + ' PR_XIF_MES_MO_S Start'
  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
  					
  					EXEC PR_XIF_MES_MO_S @v_plan_id

  					SET @n_log_count = @n_log_count + 1
  					SET @v_message = @v_master_id + ' PR_XIF_MES_MO_S End'
  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
            
  					SET @n_log_count = @n_log_count + 1
  					SET @v_message = @v_master_id + ' PR_XIF_MES_WO_PEGGING_S Start'
  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
  					
  					EXEC PR_XIF_MES_WO_PEGGING_S @v_plan_id

  					SET @n_log_count = @n_log_count + 1
  					SET @v_message = @v_master_id + ' PR_XIF_MES_WO_PEGGING_S End'
  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
            
  					SET @n_log_count = @n_log_count + 1
  					SET @v_message = @v_master_id + ' PR_XIF_MES_WO_S Start'
  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
  					
  					EXEC PR_XIF_MES_WO_S @v_plan_id

  					SET @n_log_count = @n_log_count + 1
  					SET @v_message = @v_master_id + ' PR_XIF_MES_WO_S End'
  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
            
  					SET @n_log_count = @n_log_count + 1
  					SET @v_message = @v_master_id + ' PR_XIF_MES_DAILY_PP_S Start'
  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
  					
  					EXEC PR_XIF_MES_DAILY_PP_S @v_plan_id

  					SET @n_log_count = @n_log_count + 1
  					SET @v_message = @v_master_id + ' PR_XIF_MES_DAILY_PP_S End'
  					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
        END
        
      END

      WAITFOR DELAY '0:0:3'

      -----------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------
      -- ERP 배포 : END
      -----------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------

      

      BEGIN
      
        DELETE FROM A
        FROM   FP_RELEASE_PLAN_INFO_H A,
               (
                SELECT A.INSTANCE_ID
                     , A.PLAN_DATE      AS INSTANCE_DATE
                     , '-'              AS DIVISION_ID
                     , '-'             AS FACTORY_ID
                     , A.PLAN_GROUP_ID
                     , @v_plan_id       AS RELEASE_PLAN_ID
                     , PLAN_ID          AS AMEND_PLAN_ID
                FROM   SCM_FP_PLAN_GROUP_DETAIL_H A
               ) B
        WHERE  A.INSTANCE_DATE    = B.INSTANCE_DATE
        AND    A.INSTANCE_ID      = B.INSTANCE_ID
        AND    A.DIVISION_ID      = B.DIVISION_ID
        AND    A.FACTORY_ID       = B.FACTORY_ID
        AND    A.PLAN_GROUP_ID    = B.PLAN_GROUP_ID
        AND    A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
        AND    A.AMEND_PLAN_ID    = B.AMEND_PLAN_ID
        

        -- RELEASE 는 모두 적재
        INSERT INTO FP_RELEASE_PLAN_INFO_H
             (
               INSTANCE_ID
             , INSTANCE_DATE
             , DIVISION_ID
             , FACTORY_ID
             , PLAN_GROUP_ID
             , RELEASE_PLAN_ID
             , AMEND_PLAN_ID
             , INSERT_ID
             , INSERT_TIME       
             )
        SELECT A.INSTANCE_ID
             , A.PLAN_DATE      AS INSTANCE_DATE
             , '-'              AS DIVISION_ID
             , '-'              AS FACTORY_ID
             , A.PLAN_GROUP_ID
             , @v_plan_id       AS RELEASE_PLAN_ID
             , PLAN_ID          AS AMEND_PLAN_ID
             , @v_proc_name     AS INSERT_ID
             , dbo.FN_SITE_TIME(@v_lgc_site) AS INSERT_TIME       
        FROM   SCM_FP_PLAN_GROUP_DETAIL_H A
        WHERE  A.INSTANCE_ID    = @v_master_id
        AND    A.PLAN_DATE      = @v_plan_date
        AND    A.PLAN_GROUP_ID  = @v_plan_group_id        -- PLAN_GROUP_ID별로 RELEASE


        DELETE FROM A
        FROM   FP_RELEASE_FIX_PLAN_H  A,
               FP_RELEASE_PLAN_INFO_H B
        WHERE  A.INSTANCE_ID      = @v_master_id
        AND    A.RELEASE_PLAN_ID  = @v_plan_id
        AND    A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
        AND    A.AMEND_PLAN_ID    = B.AMEND_PLAN_ID
        AND    A.INSTANCE_ID      = B.INSTANCE_ID
        AND    A.INSTANCE_DATE    = B.INSTANCE_DATE
        AND    A.PLAN_GROUP_ID    = B.PLAN_GROUP_ID
        AND    A.PLAN_GROUP_ID    = @v_plan_group_id      -- PLAN_GROUP_ID별로 RELEASE

        DELETE FROM A
        FROM   FP_RELEASE_FULL_PLAN_H A,
               FP_RELEASE_PLAN_INFO_H B
        WHERE  A.INSTANCE_ID      = @v_master_id
        AND    A.RELEASE_PLAN_ID  = @v_plan_id
        AND    A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
        AND    A.AMEND_PLAN_ID    = B.AMEND_PLAN_ID
        AND    A.INSTANCE_ID      = B.INSTANCE_ID
        AND    A.INSTANCE_DATE    = B.INSTANCE_DATE
        AND    A.PLAN_GROUP_ID    = B.PLAN_GROUP_ID
        AND    A.PLAN_GROUP_ID    = @v_plan_group_id      -- PLAN_GROUP_ID별로 RELEASE


        BEGIN 
        
          INSERT INTO FP_RELEASE_FIX_PLAN_H
                (
                 INSTANCE_ID
               , INSTANCE_DATE
               , RELEASE_PLAN_ID
               , AMEND_PLAN_ID
               , DIVISION_ID
               , FACTORY_ID
               , PLAN_GROUP_ID
               , WORK_ORDER_ID
               , ITEM_ID
               , LINE_ID
               , OPERATION_ID
               , ELECTRODE_TYPE
               , EQUIPMENT_ID
               , FIX_TYPE
               , PLAN_DATE
               , START_TIME
               , END_TIME
               , PLAN_QTY
               , PLAN_IN_QTY
               , PRODUCTION_TYPE
               , MARKET
               , BATCH_ORDER_ID
               , LANE_QTY
               , INSERT_ID
               , INSERT_TIME
               , TOP_ITEM_ID
                )
          SELECT @v_master_id INSTANCE_ID
               , @v_plan_date PLAN_DATE
               , A.FP_PLAN_ID AS RELEASE_PLAN_ID
               , B.AMEND_PLAN_ID
               , A.DIVISION_ID
               , A.FACTORY_ID
               , B.PLAN_GROUP_ID
               , A.WORK_ORDER_SPL_ID    AS WORK_ORDER_ID  -- FP_PRODUCTION_PLAN_EQUIPMENT_R 는 WORK_ORDER_SPL_ID
               , A.ITEM_ID
               , A.LINE_ID
               , A.OPERATION_ID
               , A.ELECTRODE_TYPE
               , A.EQUIPMENT_ID
               , A.FIX_TYPE
               , A.PLAN_DATE
               , A.START_TIME
               , A.END_TIME
               , A.PLAN_QTY
               , A.PLAN_IN_QTY
               , A.PRODUCTION_TYPE
               , A.MARKET
               , A.BATCH_ORDER_ID
               , ISNULL(A.LANE_QTY, 0) AS LANE_QTY
               , @v_proc_name AS INSERT_ID
               , GETDATE()    AS INSERT_TIME       
               , TOP_ITEM_ID
          FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
                 FP_RELEASE_PLAN_INFO_H B
          WHERE  A.INSTANCE_ID    = @v_master_id
          AND    A.FP_PLAN_ID     = @v_plan_id
          AND    A.FP_PLAN_ID     = B.RELEASE_PLAN_ID
          AND    B.PLAN_GROUP_ID  = @v_plan_group_id    -- PLAN_GROUP_ID별로 RELEASE
          AND    A.PLAN_QTY       > 0
          
          -- full data
          
          INSERT INTO FP_RELEASE_FULL_PLAN_H
                (
                 INSTANCE_ID
               , INSTANCE_DATE
               , RELEASE_PLAN_ID
               , AMEND_PLAN_ID
               , DIVISION_ID
               , FACTORY_ID
               , PLAN_GROUP_ID
               , WORK_ORDER_ID
               , ITEM_ID
               , LINE_ID
               , OPERATION_ID
               , ELECTRODE_TYPE
               , EQUIPMENT_ID
               , FIX_TYPE
               , PLAN_DATE
               , START_TIME
               , END_TIME
               , PLAN_QTY
               , PLAN_IN_QTY
               , PRODUCTION_TYPE
               , MARKET
               , BATCH_ORDER_ID
               , LANE_QTY
               , INSERT_ID
               , INSERT_TIME        
               , TOP_ITEM_ID
                )
          SELECT @v_master_id   AS INSTANCE_ID
               , @v_plan_date   AS INSTANCE_DATE
               , A.FP_PLAN_ID   AS RELEASE_PLAN_ID
               , B.AMEND_PLAN_ID
               , A.DIVISION_ID
               , A.FACTORY_ID
               , B.PLAN_GROUP_ID
               , A.WORK_ORDER_SPL_ID    AS WORK_ORDER_ID  -- FP_PRODUCTION_PLAN_EQUIPMENT_R 는 WORK_ORDER_SPL_ID
               , A.ITEM_ID
               , A.LINE_ID
               , A.OPERATION_ID
               , A.ELECTRODE_TYPE
               , A.EQUIPMENT_ID
               , A.FIX_TYPE
               , A.PLAN_DATE
               , A.START_TIME
               , A.END_TIME
               , A.PLAN_QTY
               , A.PLAN_IN_QTY
               , A.PRODUCTION_TYPE
               , A.MARKET
               , A.BATCH_ORDER_ID
               , ISNULL(A.LANE_QTY, 0) AS LANE_QTY
               , @v_proc_name AS INSERT_ID
               , GETDATE()    AS INSERT_TIME       
               , TOP_ITEM_ID
          FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
                 FP_RELEASE_PLAN_INFO_H B
          WHERE  A.INSTANCE_ID    = @v_master_id
          AND    A.FP_PLAN_ID     = @v_plan_id
          AND    A.FP_PLAN_ID     = B.RELEASE_PLAN_ID
          AND    B.PLAN_GROUP_ID  = @v_plan_group_id    -- PLAN_GROUP_ID별로 RELEASE
          AND    A.PLAN_QTY       > 0

          

          INSERT INTO FP_RELEASE_FULL_PLAN_H
                (
                 INSTANCE_ID
               , INSTANCE_DATE
               , RELEASE_PLAN_ID
               , AMEND_PLAN_ID
               , DIVISION_ID
               , FACTORY_ID
               , PLAN_GROUP_ID
               , WORK_ORDER_ID
               , ITEM_ID
               , LINE_ID
               , OPERATION_ID
               , ELECTRODE_TYPE
               , EQUIPMENT_ID
               , FIX_TYPE
               , PLAN_DATE
               , START_TIME
               , END_TIME
               , PLAN_QTY
               , PLAN_IN_QTY
               , PRODUCTION_TYPE
         , MARKET
               , BATCH_ORDER_ID
               , LANE_QTY
               , INSERT_ID
               , INSERT_TIME        
               , TOP_ITEM_ID
                )              
          SELECT @v_master_id   AS INSTANCE_ID
               , @v_plan_date   AS INSTANCE_DATE
               , B.RELEASE_PLAN_ID
               , A.FP_PLAN_ID
               , A.DIVISION_ID
               , A.FACTORY_ID
               , A.PLAN_GROUP_ID
               , A.WORK_ORDER_SPL_ID    AS WORK_ORDER_ID  -- FP_PRODUCTION_PLAN_EQUIPMENT_R 는 WORK_ORDER_SPL_ID
               , A.ITEM_ID
               , A.LINE_ID
               , A.OPERATION_ID
               , A.ELECTRODE_TYPE
               , A.EQUIPMENT_ID
               , 'P'  AS FIX_TYPE
               , A.PLAN_DATE
               , A.START_TIME
               , A.END_TIME
               , A.PLAN_QTY
               , A.PLAN_IN_QTY
               , A.PRODUCTION_TYPE
               , A.MARKET
               , A.BATCH_ORDER_ID
               , ISNULL(A.LANE_QTY, 0) AS LANE_QTY
               , @v_proc_name AS INSERT_ID
               , GETDATE()    AS INSERT_TIME       
               , TOP_ITEM_ID
          FROM   FP_PRODUCTION_PLAN_GROUP_R A,
                 FP_RELEASE_PLAN_INFO_H B
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    B.RELEASE_PLAN_ID  = @v_plan_id
          AND    A.INSTANCE_ID      = B.INSTANCE_ID
          AND    A.FP_PLAN_ID       = B.AMEND_PLAN_ID
          AND    A.PLAN_GROUP_ID    = B.PLAN_GROUP_ID
          AND    A.PLAN_GROUP_ID    = @v_plan_group_id    -- PLAN_GROUP_ID별로 RELEASE
          AND    A.PLAN_QTY         > 0
          --AND    A.PLAN_DATE        > @v_confirm_date
          AND    NOT EXISTS (
                              SELECT 1
                              FROM   (
                                      SELECT A.WORK_ORDER_ID
                                      FROM   FP_DAILY_PLAN_ORDER_R          A,
                                             FP_PRODUCTION_PLAN_EQUIPMENT_R B
                                      WHERE  A.INSTANCE_ID  = @v_master_id
                                      AND    A.FP_PLAN_ID   = @v_plan_id
                                      AND    A.INSTANCE_ID  = B.INSTANCE_ID
                                      AND    A.FP_PLAN_ID   = B.FP_PLAN_ID
                                      AND    A.NEW_ORDER_ID = B.WORK_ORDER_ID
                                     ) X
                              WHERE  X.WORK_ORDER_ID = A.WORK_ORDER_ID
                            )
        
        END
        
        -- ACTUAL_FLAG, CLOSE_FLAG 상속받기
        BEGIN

          -- FP_RELEASE_FIX_PLAN_H
          UPDATE FP_RELEASE_FIX_PLAN_H
          SET    FP_RELEASE_FIX_PLAN_H.ACTUAL_FLAG      = C.ACTUAL_FLAG
               , FP_RELEASE_FIX_PLAN_H.CLOSE_FLAG       = C.CLOSE_FLAG
               , FP_RELEASE_FIX_PLAN_H.MIN_ACTUAL_DATE  = C.MIN_ACTUAL_DATE
          FROM   FP_RELEASE_FIX_PLAN_H A,
                 FP_RELEASE_PLAN_INFO_H B,
                 (
                  SELECT A.WORK_ORDER_ID, A.ACTUAL_FLAG, A.CLOSE_FLAG, A.MIN_ACTUAL_DATE
                  FROM   (
                          SELECT A.WORK_ORDER_ID, A.ACTUAL_FLAG, A.CLOSE_FLAG, A.MIN_ACTUAL_DATE
                               , ROW_NUMBER() OVER (PARTITION BY WORK_ORDER_ID 
                                                    ORDER BY INSTANCE_DATE   DESC
                                                           , RELEASE_PLAN_ID ASC) AS SEQ
                          FROM   FP_RELEASE_FIX_PLAN_H A
                          WHERE  A.INSTANCE_ID      = @v_master_id
                          AND    A.PLAN_GROUP_ID    = @v_plan_group_id
                          AND    A.INSTANCE_DATE    < @v_plan_date
                         ) A
                  WHERE  SEQ = 1
                 ) C
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    A.RELEASE_PLAN_ID  = @v_plan_id
          AND    A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
          AND    A.AMEND_PLAN_ID    = B.AMEND_PLAN_ID
          AND    A.INSTANCE_ID      = B.INSTANCE_ID
          AND    A.INSTANCE_DATE    = B.INSTANCE_DATE
          AND    A.PLAN_GROUP_ID    = B.PLAN_GROUP_ID
          AND    A.PLAN_GROUP_ID    = @v_plan_group_id    -- PLAN_GROUP_ID별로 RELEASE
          AND    A.WORK_ORDER_ID    = C.WORK_ORDER_ID

          -- FP_RELEASE_FULL_PLAN_H
          UPDATE FP_RELEASE_FULL_PLAN_H
          SET    FP_RELEASE_FULL_PLAN_H.ACTUAL_FLAG     = C.ACTUAL_FLAG
               , FP_RELEASE_FULL_PLAN_H.CLOSE_FLAG      = C.CLOSE_FLAG
               , FP_RELEASE_FULL_PLAN_H.MIN_ACTUAL_DATE = C.MIN_ACTUAL_DATE
          FROM   FP_RELEASE_FULL_PLAN_H A,
                 FP_RELEASE_PLAN_INFO_H B,
                 (
                  SELECT A.WORK_ORDER_ID, A.ACTUAL_FLAG, A.CLOSE_FLAG, A.MIN_ACTUAL_DATE
                  FROM   (
                          SELECT A.WORK_ORDER_ID, A.ACTUAL_FLAG, A.CLOSE_FLAG, A.MIN_ACTUAL_DATE
                               , ROW_NUMBER() OVER (PARTITION BY WORK_ORDER_ID 
                                                    ORDER BY INSTANCE_DATE   DESC
                                                           , RELEASE_PLAN_ID ASC) AS SEQ
                          FROM   FP_RELEASE_FULL_PLAN_H A
                          WHERE  A.INSTANCE_ID      = @v_master_id
                          AND    A.PLAN_GROUP_ID    = @v_plan_group_id
                          AND    A.INSTANCE_DATE    < @v_plan_date
                         ) A
                  WHERE  SEQ = 1
                 ) C
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    A.RELEASE_PLAN_ID  = @v_plan_id
          AND    A.RELEASE_PLAN_ID  = B.RELEASE_PLAN_ID
          AND    A.AMEND_PLAN_ID    = B.AMEND_PLAN_ID
          AND    A.INSTANCE_ID      = B.INSTANCE_ID
          AND    A.INSTANCE_DATE    = B.INSTANCE_DATE
          AND    A.PLAN_GROUP_ID    = B.PLAN_GROUP_ID
          AND    A.PLAN_GROUP_ID    = @v_plan_group_id    -- PLAN_GROUP_ID별로 RELEASE
          AND    A.WORK_ORDER_ID    = C.WORK_ORDER_ID

        END        
          
        -- Multi Release 를 위해 RELEASE 당시 ACTUAL 인지 아닌지를 UPDATE 함
        BEGIN

          SET @v_table_name = 'FP_RELEASE_FIX_PLAN_H'

          UPDATE A
          SET    A.ACTUAL_FLAG = ISNULL(B.ACTUAL_FLAG, 'N')
          FROM   FP_RELEASE_FIX_PLAN_H A
                 LEFT OUTER JOIN FP_DAILY_INSTANCE_ORDER_STATUS B
                      ON    A.INSTANCE_ID   = B.INSTANCE_ID
                      AND   A.AMEND_PLAN_ID = B.FP_PLAN_ID
                      AND   A.WORK_ORDER_ID = B.WORK_ORDER_SPL_ID
                      AND   B.ACTUAL_FLAG   = 'Y'
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    A.RELEASE_PLAN_ID  = @v_plan_id

          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = 'ACTUAL_FLAG : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          SET @v_table_name = 'FP_RELEASE_FULL_PLAN_H'

          UPDATE A
          SET    A.ACTUAL_FLAG = ISNULL(B.ACTUAL_FLAG, 'N')
          FROM   FP_RELEASE_FULL_PLAN_H A
                 LEFT OUTER JOIN FP_DAILY_INSTANCE_ORDER_STATUS B
                      ON    A.INSTANCE_ID   = B.INSTANCE_ID
                      AND   A.AMEND_PLAN_ID = B.FP_PLAN_ID
                      AND   A.WORK_ORDER_ID = B.WORK_ORDER_SPL_ID
                      AND   B.ACTUAL_FLAG   = 'Y'
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    A.RELEASE_PLAN_ID  = @v_plan_id
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = 'ACTUAL_FLAG : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

        -- IS_PREV_SCHEDULE, TARGET_PRODUCTION_TYPE  UPDATE 처리
        --UPDATE FP_RELEASE_FIX_PLAN_H
        --SET    FP_RELEASE_FIX_PLAN_H.IS_PREV_SCHEDULE       = C.IS_PREV_SCHEDULE
        --     , FP_RELEASE_FIX_PLAN_H.TARGET_PRODUCTION_TYPE = C.TARGET_PRODUCTION_TYPE
        --FROM   FP_RELEASE_FIX_PLAN_H          A,
        --       FP_PRODUCTION_PLAN_EQUIPMENT_R B,
        --       FP_DAILY_NET_DEMAND_H          C
        --WHERE  A.INSTANCE_ID      = @v_master_id
        --AND    A.RELEASE_PLAN_ID  = @v_plan_id
        --AND    A.INSTANCE_ID      = B.INSTANCE_ID
        --AND    A.RELEASE_PLAN_ID  = B.FP_PLAN_ID
        --AND    A.WORK_ORDER_ID    = B.WORK_ORDER_ID
        --AND    B.INSTANCE_ID      = C.INSTANCE_ID
        --AND    B.FP_PLAN_ID       = C.DPP_PLAN_ID
        --AND    B.DEMAND_ID        = C.FP_DEMAND_ID               

        
      END
      
      
      BEGIN
        
        SET @v_table_name = 'SCM_FP_PLAN_H'
        
        UPDATE SCM_FP_PLAN_H SET
               RELEASE_TIME = dbo.FN_SITE_TIME(@v_lgc_site)
              ,RELEASE_FLAG = 'Y'
        WHERE  INSTANCE_ID  = @v_master_id
        AND    PLAN_ID      = @v_plan_id
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        SET @v_table_name = 'SCM_FP_PLAN_GROUP_DETAIL_H'
        
        UPDATE SCM_FP_PLAN_GROUP_DETAIL_H SET
               RELEASE_TIME     = dbo.FN_SITE_TIME(@v_lgc_site)
              ,RELEASE_FLAG     = 'Y'
              ,RELEASE_PLAN_ID  = @v_plan_id
        WHERE  INSTANCE_ID      = @v_master_id
        AND    PLAN_DATE        = @v_plan_date
        AND    PLAN_GROUP_ID    = @v_plan_group_id
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END
      
      ------------------------------------
      -- AMEND 데이터 넣기
      ------------------------------------
      BEGIN
      
        SET @v_table_name = 'FP_AMEND_PRODUCTION_PLAN_R'
      
        DELETE  FROM FP_AMEND_PRODUCTION_PLAN_R
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID   = @v_plan_id

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
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
             , ORDER_ID
             , ORDER_TYPE
             , PO_ID
             , MFG_WEEK
             , SOP_WEEK
             , ORG_WORK_ORDER_ID
             , DEMAND_DUE_DATE
             , BATCH_ORDER_ID
             , DATE_FIX_FLAG
             , DATE_FIX_DATE
             , OPERATION_EPST
             , OPERATION_LPST
             , LANE_QTY
             , LANE_TACT_QTY
             , ITEM_UOM
             , WO_DAY_SPLIT_YN
             , SETUP_TIME
             , SETUP_TIME_UOM
             , BATCH_QTY
             , UI_EDIT_YN
             , MARKET
             , DESCRIPTION
             , INSERT_ID
             , INSERT_TIME
             , UPDATE_ID
             , UPDATE_TIME
             )
        SELECT DISTINCT
               A.MASTER_ID
             , @v_plan_id                               AS PLAN_ID
             , ISNULL(B.NEW_ORDER_ID, A.WORK_ORDER_ID)  AS WORK_ORDER_ID
             , A.BEFORE_SITE_ID
             , A.AFTER_SITE_ID
             , A.BEFORE_ROUTE_ID
             , A.AFTER_ROUTE_ID
             , A.BEFORE_OPERATION_ID
             , A.AFTER_OPERATION_ID
             , A.BEFORE_RESOURCE_ID
             , A.AFTER_RESOURCE_ID
             , A.BEFORE_PLAN_DATE
             , A.AFTER_PLAN_DATE
             , A.BEFORE_START_TIME
             , A.AFTER_START_TIME
             , A.BEFORE_END_TIME
             , A.AFTER_END_TIME
             , A.WORKING_TIME
             , A.BEFORE_SEQ
             , A.AFTER_SEQ
             , A.BEFORE_QTY
             , A.AFTER_QTY
             , A.BEFORE_IN_QTY
             , A.AFTER_IN_QTY
             , A.ITEM_ID
             , A.FIXED_YN
             , A.SPLIT_YN
             , A.DEMAND_ID
             , A.DEMAND_TYPE
             , A.ORDER_ID
             , A.ORDER_TYPE
             , A.PO_ID
             , A.MFG_WEEK
             , A.SOP_WEEK
             , ISNULL(B.NEW_ORDER_ID, A.ORG_WORK_ORDER_ID)  AS ORG_WORK_ORDER_ID
             , A.DEMAND_DUE_DATE
             , ISNULL(C.NEW_ORDER_ID, A.BATCH_ORDER_ID)     AS BATCH_ORDER_ID
             , A.DATE_FIX_FLAG
             , A.DATE_FIX_DATE
             , A.OPERATION_EPST
             , A.OPERATION_LPST
             , A.LANE_QTY
             , A.LANE_TACT_QTY
             , A.ITEM_UOM
             , A.WO_DAY_SPLIT_YN
             , A.SETUP_TIME
             , A.SETUP_TIME_UOM
             , A.BATCH_QTY
             , A.UI_EDIT_YN
             , A.MARKET
             , A.DESCRIPTION
             , A.INSERT_ID
             , A.INSERT_TIME
             , A.UPDATE_ID
             , A.UPDATE_TIME                   
        FROM   FP_AMEND_PRODUCTION_PLAN_R A
               LEFT OUTER JOIN FP_DAILY_PLAN_ORDER_R B
                    ON    B.INSTANCE_ID     = @v_master_id
                    AND   B.FP_PLAN_ID      = @v_plan_id
                    AND   A.WORK_ORDER_ID   = B.WORK_ORDER_SPL_ID
               LEFT OUTER JOIN FP_DAILY_PLAN_ORDER_R C
                    ON    C.INSTANCE_ID     = @v_master_id
                    AND   C.FP_PLAN_ID      = @v_plan_id
                    AND   A.BATCH_ORDER_ID  = C.WORK_ORDER_SPL_ID
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.AFTER_QTY > 0
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.MASTER_ID 
                        AND     X.PLAN_ID       = A.PLAN_ID 
                        AND     X.FACTORY_ID    = A.AFTER_SITE_ID
                        AND     X.LINE_ID       = A.AFTER_OPERATION_ID
                        AND     X.OPERATION_ID  = A.AFTER_OPERATION_ID
                       )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      

        SET @v_table_name = 'FP_AMEND_RESOURCE'
        
        DELETE FROM FP_AMEND_RESOURCE
        WHERE  MASTER_ID  = @v_master_id
        AND    PLAN_ID    = @v_plan_id
        
        INSERT INTO FP_AMEND_RESOURCE
             (
               MASTER_ID
             , PLAN_ID
             , RESOURCE_ID
             , RESOURCE_TYPE
             , SITE_ID
             , ROUTE_ID
             , OPERATION_ID
             , LOCATION_ID
             , MULTI_PORT_COUNT
             , UTILIZATION
             , BATCH_TYPE
             , IS_EXCEPTION
             , IS_FINITE
             , IS_DUMMY
             , OFFTIME_SET_ID
             , ATTRIBUTE_SET_ID
             , ATTRIBUTE_CHECKER_ID
             , INLINE_GROUP_ID
             , RESOURCE_GROUP_ID
             , RESOURCE_SETUP_GROUP_ID
             , BATCH_RES_GROUP_ID
             , MAX_SETUP_COUNT
             , RAMPUP_RATE
             , RAMPUP_TERM
             , RAMPUP_UOM
             , FIXED_TERM
             , FIXED_TERM_UOM
             , NCP_TERM
             , NCP_TERM_UOM
             , RESOURCE_CATEGORY_TYPE
             , DESCR     
             )
             
        SELECT A.MASTER_ID
             , @v_plan_id AS PLAN_ID
             , A.RESOURCE_ID
             , A.RESOURCE_TYPE
             , A.SITE_ID
             , A.ROUTE_ID
             , A.OPERATION_ID
             , A.LOCATION_ID
             , A.MULTI_PORT_COUNT
             , A.UTILIZATION
             , A.BATCH_TYPE
             , A.IS_EXCEPTION
             , A.IS_FINITE
             , A.IS_DUMMY
             , A.OFFTIME_SET_ID
             , A.ATTRIBUTE_SET_ID
             , A.ATTRIBUTE_CHECKER_ID
             , A.INLINE_GROUP_ID
             , A.RESOURCE_GROUP_ID
             , A.RESOURCE_SETUP_GROUP_ID
             , A.BATCH_RES_GROUP_ID
             , A.MAX_SETUP_COUNT
             , A.RAMPUP_RATE
             , A.RAMPUP_TERM
             , A.RAMPUP_UOM
             , A.FIXED_TERM
             , A.FIXED_TERM_UOM
             , A.NCP_TERM
             , A.NCP_TERM_UOM
             , A.RESOURCE_CATEGORY_TYPE
             , A.DESCR
        FROM   FP_AMEND_RESOURCE A
        WHERE  A.MASTER_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.MASTER_ID 
            AND     X.PLAN_ID       = A.PLAN_ID 
                        AND     X.FACTORY_ID    = A.SITE_ID
                        AND     X.LINE_ID       = A.ROUTE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )
      
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      

        SET @v_table_name = 'FP_AMEND_ITEM'
        
        DELETE FROM FP_AMEND_ITEM
        WHERE  MASTER_ID  = @v_master_id
        AND    PLAN_ID    = @v_plan_id

        INSERT INTO FP_AMEND_ITEM
             (
               MASTER_ID
             , PLAN_ID
             , ITEM_ID
             , ITEM_TYPE
             , ITEM_UOM
             , FLOW_ID
             , ITEM_GROUP_ID
             , SETUP_GROUP_ID
             , IS_FINITE
             , FINITE_TERM
             , FINITE_TERM_UOM
             , SAFETY_STOCK_QTY
             , MAX_STOCK_QTY
             , MIN_SAFETY_TERM
             , MIN_SAFETY_TERM_UOM
             , BUFFER_TIME
             , BUFFER_TIME_UOM
             , MIN_LOT_SIZE
             , MAX_LOT_SIZE
             , INCREMENT_LOT_SIZE
             , ATTRIBUTE_SET_ID
             , DESCR
             , ITEM_UOM_RATE
             , NICK_NAME
             , FOIL_ITEM_ID
             , FOIL_ITEM_NAME
             , ITEM_CLASS_NAME
             , CELL_TYPE
             )
        SELECT
               A.MASTER_ID
             , @v_plan_id AS PLAN_ID
             , A.ITEM_ID
             , A.ITEM_TYPE
             , A.ITEM_UOM
             , A.FLOW_ID
             , A.ITEM_GROUP_ID
             , A.SETUP_GROUP_ID
             , A.IS_FINITE
             , A.FINITE_TERM
             , A.FINITE_TERM_UOM
             , A.SAFETY_STOCK_QTY
             , A.MAX_STOCK_QTY
             , A.MIN_SAFETY_TERM
             , A.MIN_SAFETY_TERM_UOM
             , A.BUFFER_TIME
             , A.BUFFER_TIME_UOM
             , A.MIN_LOT_SIZE
             , A.MAX_LOT_SIZE
             , A.INCREMENT_LOT_SIZE
             , A.ATTRIBUTE_SET_ID
             , A.DESCR
             , A.ITEM_UOM_RATE
             , A.NICK_NAME
             , A.FOIL_ITEM_ID
             , A.FOIL_ITEM_NAME
             , A.ITEM_CLASS_NAME
             , A.CELL_TYPE
        FROM   FP_AMEND_ITEM A
        WHERE  A.MASTER_ID = @v_master_id
        AND    EXISTS (  
                        SELECT  1 
                        FROM    SCM_FP_PLAN_GROUP_DETAIL_H B 
                        WHERE   B.INSTANCE_ID=A.MASTER_ID 
                        --AND     B.DIVISION_ID=A.DIVISION_ID 
                        --AND     CASE WHEN B.FACTORY_ID='-' THEN A.SITE_ID ELSE B.FACTORY_ID END=A.SITE_ID 
                        AND     B.PLAN_ID=A.PLAN_ID 
                        AND     B.PLAN_DATE= @v_plan_date
                        AND     B.PLAN_GROUP_ID = @v_plan_group_id    -- 동별로 RELEASE
                       )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      
        SET @v_table_name = 'FP_AMEND_TIMEPHASED_LANE_BOR'
        
        DELETE FROM FP_AMEND_TIMEPHASED_LANE_BOR
        WHERE  MASTER_ID  = @v_master_id
        AND    PLAN_ID    = @v_plan_id

        INSERT INTO FP_AMEND_TIMEPHASED_LANE_BOR
             (
               MASTER_ID
             , PLAN_ID
             , COMBINE_ID
             , SITE_ID
             , ROUTE_ID
             , OPERATION_ID
             , ITEM_ID
             , LANE_TACT_QTY
             , RESOURCE_ID
             , START_TIME
             , END_TIME
             , UTILIZATION
             , TACT_TIME
             , TACT_TIME_UOM
             , MULTI_PORT_COUNT
             , ALT_PRIORITY
             , YIELD
             , RES_IS_USE
             , TACT_IS_USE
             )
        SELECT 
               A.MASTER_ID
             , @v_plan_id AS PLAN_ID
             , A.COMBINE_ID
             , A.SITE_ID
             , A.ROUTE_ID
             , A.OPERATION_ID
             , A.ITEM_ID
             , A.LANE_TACT_QTY
             , A.RESOURCE_ID
             , A.START_TIME
             , A.END_TIME
             , A.UTILIZATION
             , A.TACT_TIME
             , A.TACT_TIME_UOM
             , A.MULTI_PORT_COUNT
             , A.ALT_PRIORITY
             , A.YIELD
             , A.RES_IS_USE
             , A.TACT_IS_USE        
        FROM   FP_AMEND_TIMEPHASED_LANE_BOR A
        WHERE  A.MASTER_ID = @v_master_id
        AND     EXISTS (  
                        SELECT  1 
                        FROM    (
                                  SELECT A.INSTANCE_ID, A.PLAN_ID
                                       , B.FACTORY_ID, B.LINE_ID, B.OPERATION_ID, B.ELECTRODE_TYPE
                                  FROM   SCM_FP_PLAN_GROUP_DETAIL_H A,
                                         SCM_LINE_M                 B
                                  WHERE  A.PLAN_DATE      = @v_plan_date
                                  AND    A.INSTANCE_ID    = @v_master_id
                                  AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                  AND    A.PLAN_GROUP_ID  = B.MODEL_TYPE
                                ) X
                        WHERE   X.INSTANCE_ID   = A.MASTER_ID 
                        AND     X.PLAN_ID       = A.PLAN_ID 
                        AND     X.FACTORY_ID    = A.SITE_ID
                        AND     X.LINE_ID       = A.ROUTE_ID
                        AND     X.OPERATION_ID  = A.OPERATION_ID
                       )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        SET @v_table_name = 'FP_AMEND_UTILIZATION'
        
        DELETE FROM FP_AMEND_UTILIZATION
        WHERE  MASTER_ID  = @v_master_id
        AND    PLAN_ID    = @v_plan_id

        INSERT INTO FP_AMEND_UTILIZATION
             (
               MASTER_ID
             , PLAN_ID
             , OUT_VERSION_ID
             , RESOURCE_ID
             , WORK_DATE
             , WORK_TIME
             , RUN_TIME
             , OFF_TIME
             , SETUP_TIME
             , SLACK_TIME
             , OFF_SETUP_TIME
             )
        SELECT 
               A.MASTER_ID
             , @v_plan_id AS PLAN_ID
             , A.OUT_VERSION_ID
             , A.RESOURCE_ID
             , A.WORK_DATE
             , A.WORK_TIME
             , A.RUN_TIME
             , A.OFF_TIME
             , A.SETUP_TIME
             , A.SLACK_TIME
             , A.OFF_SETUP_TIME
        FROM   FP_AMEND_UTILIZATION A
        WHERE  A.MASTER_ID = @v_master_id
        AND    EXISTS (  
                        SELECT  1 
                        FROM    SCM_FP_PLAN_GROUP_DETAIL_H B 
                        WHERE   B.INSTANCE_ID=A.MASTER_ID 
                        --AND     B.DIVISION_ID=A.DIVISION_ID 
                        --AND     CASE WHEN B.FACTORY_ID='-' THEN A.SITE_ID ELSE B.FACTORY_ID END=A.SITE_ID 
                        AND     B.PLAN_ID=A.PLAN_ID 
                        AND     B.PLAN_DATE= @v_plan_date
         AND     B.PLAN_GROUP_ID = @v_plan_group_id    -- 동별로 RELEASE
                       )
        AND    EXISTS (
                        SELECT 1
                        FROM   FP_AMEND_RESOURCE C
                        WHERE  C.MASTER_ID    = A.MASTER_ID
                        AND    C.PLAN_ID      = @v_plan_id
                        AND    C.RESOURCE_ID  = A.RESOURCE_ID
                      )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        SET @v_table_name = 'FP_AMEND_SETUP_MATRIX'
        
        DELETE FROM FP_AMEND_SETUP_MATRIX
        WHERE  MASTER_ID  = @v_master_id
        AND    PLAN_ID    = @v_plan_id


        INSERT INTO FP_AMEND_SETUP_MATRIX
             (
               MASTER_ID
             , PLAN_ID
             , RESOURCE_SETUP_GROUP_ID
             , FROM_SETUP_GROUP_ID
             , TO_SETUP_GROUP_ID
             , SETUP_TIME
             , SETUP_TIME_UOM
             , FIRST_SETUP_TIME
             , FIRST_SETUP_TIME_UOM
             , DESCR                
             )
        SELECT 
               A.MASTER_ID
             , @v_plan_id AS PLAN_ID
             , A.RESOURCE_SETUP_GROUP_ID
             , A.FROM_SETUP_GROUP_ID
             , A.TO_SETUP_GROUP_ID
             , A.SETUP_TIME
             , A.SETUP_TIME_UOM
             , A.FIRST_SETUP_TIME
             , A.FIRST_SETUP_TIME_UOM
             , A.DESCR                
        FROM   FP_AMEND_SETUP_MATRIX A
        WHERE  A.MASTER_ID = @v_master_id
        AND    EXISTS (  
                        SELECT  1 
                        FROM    SCM_FP_PLAN_GROUP_DETAIL_H B 
                        WHERE   B.INSTANCE_ID=A.MASTER_ID 
                        --AND     B.DIVISION_ID=A.DIVISION_ID 
                        --AND     CASE WHEN B.FACTORY_ID='-' THEN A.SITE_ID ELSE B.FACTORY_ID END=A.SITE_ID 
                        AND     B.PLAN_ID=A.PLAN_ID 
                        AND     B.PLAN_DATE= @v_plan_date
                        AND     B.PLAN_GROUP_ID = @v_plan_group_id    -- 동별로 RELEASE
                       )
        AND    EXISTS (
                        SELECT 1
                        FROM   FP_AMEND_RESOURCE C
                        WHERE  C.MASTER_ID                = A.MASTER_ID
                        AND    C.PLAN_ID                  = @v_plan_id
                        AND    C.RESOURCE_SETUP_GROUP_ID  = A.RESOURCE_SETUP_GROUP_ID
                      )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        ------------------------------------------------------------------------------------------------------------

      END
      
      -- RELEASE 버전이 저장되기 수량 검증 POPUP 이 뜬다...
      WAITFOR DELAY '0:0:2'
      
      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END
    
  END TRY

  BEGIN CATCH
    --ROLLBACK
    UPDATE SCM_FP_PLAN_H SET
           RELEASE_FLAG = 'E'
    WHERE  INSTANCE_ID  = @v_master_id
    AND    PLAN_ID      = @v_plan_id

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
